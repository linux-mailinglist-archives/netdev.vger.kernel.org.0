Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2367B5B23E1
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 18:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbiIHQth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 12:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbiIHQtP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 12:49:15 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60072.outbound.protection.outlook.com [40.107.6.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED6A513B128;
        Thu,  8 Sep 2022 09:49:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kCWtFN3f9ux6L51sna+x5sj1eJ/G1/QgCWjQoMBTUhAB4SZ3RXgfK4DtK/pDlIFIKDq0N+FlasMmHcXQdWcBihksCDZ/LfHts3ZcDt31V7vSbSMFX5sKnHkB1+K/djUX93dCw7g6zk4hbdwweL/Fg1734vMNb5ZIgMapGRxQFEOadK2WhYeo5MlsrzXPUdxHa2+lJHIJUL9GMgy+c0TWj99YGMpVRhxOcqtVqwA9RgRGHqMc6NAlzNXdHZZ9HnSDc7UTYjKIKu6SPfNsZ8BCRPMY/pnkiBjDZ0o3/V60br+JvEHP2OZXwT4NGxDShyvnjvc7vOnmS+SI0fUNIZGgAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DLihaKa6dsbnSMfBapGQRS2Sp5MMPgEOkztcaEuiQMo=;
 b=eeRcVHyLjU20NiEKRcFbgtVgik8Q5+JZrjuOSTywSSRPU6oRI5fXCIv4X+dR+Vum7XZkqUUF3rFszAqcM78qHH4MCnxNSMtyDnpIojJp6Lj46OGVziDCCgQVBQBRRt8EWHuM1pmvX18uwhrJCesx8sqAQLLRr/JGJEf5wtwXvgSg3uHRPzjcmXVGKr69aPrXuHnSEz0rzUoVgeqDWHdZ+zFLoJ7Z404WmHTjzsuScIvB5Bx0xPZsmRJxayH9pYCP5YNb6r9P9l6cSYRgaaPz2LASjSgKzkjePd16JSDCgvwDvd4QFQz2S3D7UQrZpyQ8cnXAsW9rS619BIGZ76JCiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DLihaKa6dsbnSMfBapGQRS2Sp5MMPgEOkztcaEuiQMo=;
 b=F0FN4zoXCuufxmgzpPgJI4R4qr37h7jf1sKfht109ZR5r8WD3yPom0dHcwPBZEDoRvduI7j9UiPMlKnccK/22VMw5qKYgZIdzGU4WyuGv7UUPMOrXLKTDnTVwg+x25hH4cx+H8GygatdUNMLpDYJ2XH3AOa+SVbBDhVpb1oqSyk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB5052.eurprd04.prod.outlook.com (2603:10a6:10:1b::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Thu, 8 Sep
 2022 16:49:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Thu, 8 Sep 2022
 16:49:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 07/14] net: mscc: ocelot: unexport ocelot_port_fdb_do_dump from the common lib
Date:   Thu,  8 Sep 2022 19:48:09 +0300
Message-Id: <20220908164816.3576795-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220908164816.3576795-1-vladimir.oltean@nxp.com>
References: <20220908164816.3576795-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BEXP281CA0009.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::19)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18562b9d-99dd-4515-8d5f-08da91b9f8fa
X-MS-TrafficTypeDiagnostic: DB7PR04MB5052:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w1OdY/sVxbQrz9lOQPOaOtP+EA3t8fltrewPAtBSiw//WhWzzdFdnNM04Sja9D35zZtvXCgmZ6FpnVV+qLRgI239i2CH/BhmSh/NuNmZ0XmUahYybMe+dKbmfTZ489CCXLDGiXle3NxQFemN0S+dgp4BvXTMbiWyDOA3OatWdYxU/xsPD99pKpkvA5HUlvOYb+Inx7xuW8UGFfrLRYICjmodZHFi/Dylz+BfltIKFYsejEcUfJiiuvH3K+NXkaouyO9dGZt2r9LkU3tioLeKIamngX2OyJvBVV0dqJ9DjRV7Y8wojnLUxUtJ6vEOgUMpkpJvuC4lFymvZ/qXdNuAz80W18GmB7fPKEXlSp4mgHYDw6bpXwxEpWfOYY3aIPi73YPQSVfaiKA964xl+pYP5/ZqMoMEGMfNHZYHBHkr0v0R1s0y43EYjWFb6WvNozobJ4lgNo5j0Oe2BXT+IPmk6cJSX0vDa4FQWdAlWDVQXi20gVDTI24Rcfv0WqD2vxiw5CfMrSJkU7xWcyv4gUDUvuIbyPFvylheS5WPwOCFXqpwFImjURGUWqroMEAIXThv40lD0xP+uwQdQXjHVyQHKAqfnm+rEEHtzJceHV5U8AkIznoja1+QyP76jhQEAUCCMXe2YTNxjxDUF1JrWzFtGb9mFsKWWTeoS9E3j2WJx3Bm+btrDGfPesADuYZywKnW9VG4HZmD3g+KbQiw/vxSO1Nkj57ZMlUT1hmXVePVKdxmYZx1iYlZgGGIFoDCuyGBhBVbKyBw3e2BicCtUBnCEg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(396003)(346002)(366004)(376002)(38350700002)(8676002)(66476007)(66946007)(2616005)(6486002)(186003)(66556008)(38100700002)(36756003)(1076003)(4326008)(478600001)(83380400001)(8936002)(2906002)(5660300002)(44832011)(7416002)(52116002)(41300700001)(6506007)(6916009)(26005)(54906003)(6512007)(86362001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RpRghoHyX0OAUKNYc/7dsZ+CiCTCPGqbRXbsS/d/Gl64FmGLmz8NLSI72YA+?=
 =?us-ascii?Q?x96wAZXqsq/iWYYSvm2SMncYRqJ2sJ9Qo4w772f7jzq1xCr/TnAIQBhZRjOt?=
 =?us-ascii?Q?jTZqwk6h+fkP5B9pwuA2woAz8F8nl6EPSrg1Zvu4TsxQWRr1oa2DVKPJWvbS?=
 =?us-ascii?Q?E+2+8rVht2BytOJKmIrcgbJYA3JAkIixM6mgNx4OpOGQFNI6X4ZvTSubGVB3?=
 =?us-ascii?Q?27iKLo9LULOKWKhPyM/Pbegu+0QFzKjJKDlWN1kMLa5IABpMTkye5gykUhD/?=
 =?us-ascii?Q?TlD0/O8Jgpdg1ont9B2piiFFFeuVvgnDbWrK2Tyz2JnfByoCjMwt5qrOCEr+?=
 =?us-ascii?Q?FLoozQl3OPPdHuNfJSmVWBcMDqCXoDzqDCNsFxhoTfJ1pkC2MTUueYjFcGpM?=
 =?us-ascii?Q?2EzrimGe/Ofyglui59tTj7Sj/rFA4Gk/dB0oov0vJL04epfXyfxZUCJqySBK?=
 =?us-ascii?Q?Y/YP+DNaDllxtQXFlHbiojI6iioQvXfJikqjdx9lJYni+zEYtXLblwBrUiXt?=
 =?us-ascii?Q?1AnPDioXmJ5eao1wtAd0Qximm/N4DEF+dSHtzV+a13gvzIH0Vrbgp9euE+d4?=
 =?us-ascii?Q?0L8NuWe1s5tnKPuGSu0ZGgFOpZHV9srqbS3XuEO9sSqGo7vO+F09GDKJOkYd?=
 =?us-ascii?Q?e44BI3ZbaalQc/fbUx7TDyr0tFrj/NxqbNigYTwUHUKdvWYb8+wdzt23eMKE?=
 =?us-ascii?Q?wQrGoZ6SAOhD6uCZ9/XxT0rmisX9CWSftBWzRIvcpzQ2v4DFa6DVhj1V0P7F?=
 =?us-ascii?Q?+9asRWPFbdeWPGz4TX363UBjyurk7YoVHPEvQml69uoXRP9+SXnNfARDr6bl?=
 =?us-ascii?Q?WoYUAOyFGiVX73N0nhlsKM1+PDxe+1xXVraDN2aOkTED2hG9xARiPxJL9ZoJ?=
 =?us-ascii?Q?yOcz/zP7azaerzYCsBpvuyQDH9s8HDORe0VmZn8XSNQUK0p9jWI9TXwe4YV1?=
 =?us-ascii?Q?3DMNvps1pD36VEoDqIG5gT3JAjLrv6ylyayPD1OmNcUhCs7I2BDlMZzbKZsZ?=
 =?us-ascii?Q?njqSe28F7+xNnSNVXn9v9mhoUW98CHt7/duBQTJVbM/NtDuAAoZDzJI7BA9K?=
 =?us-ascii?Q?owg8PQAhfT4HS4oYIoT3pB9ynQNhLQ1I6yoLSWZ8BlcJpRWBaSOwnzxSSHwd?=
 =?us-ascii?Q?8TYF76DtsTjdTWtMjzGnBF5IkJIR92S/EbQ6YVkwa56SOihvzUwdDK/0WvhN?=
 =?us-ascii?Q?S90IIqa0DjGsPpoKp4eP1hkzythuDP9FKB8QqKQp+2ztySO784067m+hIvN3?=
 =?us-ascii?Q?2m3lfVRBYrw8/t+aGNnyWVCdEmwM7JPFhzMIMvcal4gnbD8x+xevhdP4/PS/?=
 =?us-ascii?Q?XBwz0qelJjEHIo5oOyzF18HoJPwU4RHWjXWMiokgU/7kIbYPn3JAdjbElnYo?=
 =?us-ascii?Q?3y/Ha4tGi/kVlOlESSUaxolpuBAx47UtJDPJhurzi8UhlqMm4+8+WDd2Rivl?=
 =?us-ascii?Q?bAZlnZtgnDY//lGuE1Jwv19u2LcBl8Aryd87Qgakg3TFES9fBE+czxUzJahe?=
 =?us-ascii?Q?nQK9xqQQWpgWtg6Zow3LaFNhtVB52ma+lDOYSpGKAm6F4PVw76GN6X5zfRe4?=
 =?us-ascii?Q?/YamHI6IxWwv/74PSwxXj5DDTkl+DjbxH9drNpz1AfOmXunNXPc59GSiynAJ?=
 =?us-ascii?Q?OQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18562b9d-99dd-4515-8d5f-08da91b9f8fa
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 16:48:36.0055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MfNGnO+/WxYwR6h19aSIrNMYsWEJwsuZSEJui5fIX1QYHPwC6N5u3ycNkf8BaVabWZ6FCOLbON+Hwfw+8Kvdwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5052
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ocelot_port_fdb_do_dump() is only used by ocelot_net.c, so move it
there.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c     | 44 -----------------------
 drivers/net/ethernet/mscc/ocelot.h     |  9 -----
 drivers/net/ethernet/mscc/ocelot_net.c | 50 ++++++++++++++++++++++++++
 3 files changed, 50 insertions(+), 53 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index be3c25ea278a..d1bbc48cc246 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1366,50 +1366,6 @@ int ocelot_fdb_del(struct ocelot *ocelot, int port, const unsigned char *addr,
 }
 EXPORT_SYMBOL(ocelot_fdb_del);
 
-int ocelot_port_fdb_do_dump(const unsigned char *addr, u16 vid,
-			    bool is_static, void *data)
-{
-	struct ocelot_dump_ctx *dump = data;
-	u32 portid = NETLINK_CB(dump->cb->skb).portid;
-	u32 seq = dump->cb->nlh->nlmsg_seq;
-	struct nlmsghdr *nlh;
-	struct ndmsg *ndm;
-
-	if (dump->idx < dump->cb->args[2])
-		goto skip;
-
-	nlh = nlmsg_put(dump->skb, portid, seq, RTM_NEWNEIGH,
-			sizeof(*ndm), NLM_F_MULTI);
-	if (!nlh)
-		return -EMSGSIZE;
-
-	ndm = nlmsg_data(nlh);
-	ndm->ndm_family  = AF_BRIDGE;
-	ndm->ndm_pad1    = 0;
-	ndm->ndm_pad2    = 0;
-	ndm->ndm_flags   = NTF_SELF;
-	ndm->ndm_type    = 0;
-	ndm->ndm_ifindex = dump->dev->ifindex;
-	ndm->ndm_state   = is_static ? NUD_NOARP : NUD_REACHABLE;
-
-	if (nla_put(dump->skb, NDA_LLADDR, ETH_ALEN, addr))
-		goto nla_put_failure;
-
-	if (vid && nla_put_u16(dump->skb, NDA_VLAN, vid))
-		goto nla_put_failure;
-
-	nlmsg_end(dump->skb, nlh);
-
-skip:
-	dump->idx++;
-	return 0;
-
-nla_put_failure:
-	nlmsg_cancel(dump->skb, nlh);
-	return -EMSGSIZE;
-}
-EXPORT_SYMBOL(ocelot_port_fdb_do_dump);
-
 /* Caller must hold &ocelot->mact_lock */
 static int ocelot_mact_read(struct ocelot *ocelot, int port, int row, int col,
 			    struct ocelot_mact_entry *entry)
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 37b79593cd5f..70dbd9c4e512 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -51,13 +51,6 @@ struct ocelot_port_private {
 	struct ocelot_port_tc tc;
 };
 
-struct ocelot_dump_ctx {
-	struct net_device *dev;
-	struct sk_buff *skb;
-	struct netlink_callback *cb;
-	int idx;
-};
-
 /* A (PGID) port mask structure, encoding the 2^ocelot->num_phys_ports
  * possibilities of egress port masks for L2 multicast traffic.
  * For a switch with 9 user ports, there are 512 possible port masks, but the
@@ -84,8 +77,6 @@ struct ocelot_multicast {
 int ocelot_bridge_num_find(struct ocelot *ocelot,
 			   const struct net_device *bridge);
 
-int ocelot_port_fdb_do_dump(const unsigned char *addr, u16 vid,
-			    bool is_static, void *data);
 int ocelot_mact_learn(struct ocelot *ocelot, int port,
 		      const unsigned char mac[ETH_ALEN],
 		      unsigned int vid, enum macaccess_entry_type type);
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index d7956fd051e6..6d41ddd71bf4 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -20,6 +20,13 @@
 
 #define OCELOT_MAC_QUIRKS	OCELOT_QUIRK_QSGMII_PORTS_MUST_BE_UP
 
+struct ocelot_dump_ctx {
+	struct net_device *dev;
+	struct sk_buff *skb;
+	struct netlink_callback *cb;
+	int idx;
+};
+
 static bool ocelot_netdevice_dev_check(const struct net_device *dev);
 
 static struct ocelot *devlink_port_to_ocelot(struct devlink_port *dlp)
@@ -815,6 +822,49 @@ static int ocelot_port_fdb_del(struct ndmsg *ndm, struct nlattr *tb[],
 	return ocelot_fdb_del(ocelot, port, addr, vid, ocelot_port->bridge);
 }
 
+static int ocelot_port_fdb_do_dump(const unsigned char *addr, u16 vid,
+				   bool is_static, void *data)
+{
+	struct ocelot_dump_ctx *dump = data;
+	u32 portid = NETLINK_CB(dump->cb->skb).portid;
+	u32 seq = dump->cb->nlh->nlmsg_seq;
+	struct nlmsghdr *nlh;
+	struct ndmsg *ndm;
+
+	if (dump->idx < dump->cb->args[2])
+		goto skip;
+
+	nlh = nlmsg_put(dump->skb, portid, seq, RTM_NEWNEIGH,
+			sizeof(*ndm), NLM_F_MULTI);
+	if (!nlh)
+		return -EMSGSIZE;
+
+	ndm = nlmsg_data(nlh);
+	ndm->ndm_family  = AF_BRIDGE;
+	ndm->ndm_pad1    = 0;
+	ndm->ndm_pad2    = 0;
+	ndm->ndm_flags   = NTF_SELF;
+	ndm->ndm_type    = 0;
+	ndm->ndm_ifindex = dump->dev->ifindex;
+	ndm->ndm_state   = is_static ? NUD_NOARP : NUD_REACHABLE;
+
+	if (nla_put(dump->skb, NDA_LLADDR, ETH_ALEN, addr))
+		goto nla_put_failure;
+
+	if (vid && nla_put_u16(dump->skb, NDA_VLAN, vid))
+		goto nla_put_failure;
+
+	nlmsg_end(dump->skb, nlh);
+
+skip:
+	dump->idx++;
+	return 0;
+
+nla_put_failure:
+	nlmsg_cancel(dump->skb, nlh);
+	return -EMSGSIZE;
+}
+
 static int ocelot_port_fdb_dump(struct sk_buff *skb,
 				struct netlink_callback *cb,
 				struct net_device *dev,
-- 
2.34.1

