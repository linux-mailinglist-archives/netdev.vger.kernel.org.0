Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88D476E9F85
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 00:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233393AbjDTW5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 18:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233255AbjDTW4d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 18:56:33 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on060f.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0e::60f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D02966A5A;
        Thu, 20 Apr 2023 15:56:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iMNZ1gHo6LeDZhpNB4WdqqUzuD8VWWARBJTCZUXKDBom2HxpaRHYae1+QU1hEl6IeCqY67loHHfTLxlpA9lAfmvtxQ5ZkRXJ4Dvq7InU+IxDfO9/TB403KLwIfzf4eyPhXJ9y/g8Y9uw6ZmBKqXJ7oDDNbOOBJItJYKVYIXevpIrievRHipQAFuETDKKv6AZrxNynAqVMc/oOke7GiHwsnGyi6w+axhVSvoAibZ5efdmD1k+UbV/2dqkF8Ry2AFSZid9o5u+CDRPbpUNCdPtGeJKC5SnBvdHRv/B0W32XlhlSjHulKTfosaqZiO0fsKQHE9HwdBdTV/WxBdRbIMB+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T/hd14NTERXsZeFZUPsIg4Ww7+KoT2dotGnFbCxnoxU=;
 b=dMH+GgAV3hXL7C/iLnj58r30I2SgiQTxb6jsYlbcWMzybInT81qHrnMR+SiZM4vKZMJPIbFwxuPDkl4MO6ywnWIOD3Q+H+bqXYgAhWZnxjnXYaiTQnI5edJ5CAr0Ru5Smjtt6CrKTfb7bt1C9CW1cXvVNhdK3SxdrzeuUUI7b3OwMOSaFKd6ofupMbhcFqTwNA1rRAuiZjcp9zq6DOHhzNL5ZTTQe5psdZ1TNfC2fmXBrrtqu9POipnmmbBsp8AWimRMxq/nMN7Ihp6JlLxgBwfcx3i/0BMwLqTycSbYf3DOqWz8vensPbXruhP+qLeDtCK6LgjZsHf64k3jT5ltOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T/hd14NTERXsZeFZUPsIg4Ww7+KoT2dotGnFbCxnoxU=;
 b=Z9WIsiwmtPltj7/B7TpuUqEnTlGA0lhQcAmenhXLQ08tTHxex4zFaUVSXmxHK4SvkCbmmEAwgTQCuoEb3vx4bA2ltwI+1X4LO/M3Q/J8+zS2LP0n697GE/t2AyidQ4L/4BsZU7r39FsHiAeMHsnqlLoSmbDEpE0oALcH7/mnPXU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DB9PR04MB9497.eurprd04.prod.outlook.com (2603:10a6:10:361::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 22:56:19 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c%3]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 22:56:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v2 net-next 9/9] net: dsa: tag_ocelot: call only the relevant portion of __skb_vlan_pop() on TX
Date:   Fri, 21 Apr 2023 01:56:01 +0300
Message-Id: <20230420225601.2358327-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230420225601.2358327-1-vladimir.oltean@nxp.com>
References: <20230420225601.2358327-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0088.eurprd03.prod.outlook.com
 (2603:10a6:208:69::29) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DB9PR04MB9497:EE_
X-MS-Office365-Filtering-Correlation-Id: f34c1c0f-2259-4237-7218-08db41f27404
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i84X2GnrtaOzIzSyMCm9ITpGRTa0pn2wYZTuUIOtd5IXP4Tm7zacvydznkKE/SYiZWWsiVeLbyor8mqMWctgPzH5VdYy+TZ9lrEMS7yr9buYUWITJishiuC7nKSOJvosi4eeROg1vmhSfU0zOBSJCb9Wn+SQYDJoRxwEB+9MhAze0Lmm2KogtbeavZEs1AMZ2d5dhHiFEztAKga/m11AxwEfqQk17IMaMI++jdHQ78/Szmrup3XJyg26VqSX6A3jBr04zjRWvHcfYubSuxdZK4XX4s1sUAjAnhrpZnJksP48nhY4rK/5sQeU2ECKfh6XH0+4LYCyh6M9EWYnngchKvUrLSbfUL3p9Zf9uyC1qJesjHoe+IE53VtAEPpToHZubiUdUNLtpw3mRFsVFrB7q0spIvIlF/zIwtp0az5v9aSaaRIYtXT5SByRu7D43pdhLVPYrj0bwCQUKDRvj21derb15Sv/PkRLtp/h/ByqavGITVy3lcW5c3liwEf2tNzSMZUF2Hklym0a9W26AFbY11bd6NuaRw1nX/yVnroybhpKiT883DSPlihBPFKaYD14bHHVfZNNrVSzmN/eA5z8TDPdU/SKpe6axbYMwYi2rIQZI6WM2BVQr4g+Tmant8mo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(376002)(366004)(396003)(136003)(451199021)(83380400001)(86362001)(2616005)(6506007)(1076003)(26005)(6512007)(36756003)(52116002)(478600001)(6486002)(54906003)(6666004)(4326008)(66476007)(66946007)(66556008)(41300700001)(316002)(8936002)(8676002)(38100700002)(6916009)(186003)(44832011)(2906002)(5660300002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0s4dBz43+w+hVcPizI+mtqftpe3fvThvs8Y8zUwKN+a1hm7qbsK6OOliQi4F?=
 =?us-ascii?Q?jhm3JQNPt9n8z7Zc2G7dzuHaf5lW2IizWHhzNxBVeS6Z40vGjArNkAg2+XiP?=
 =?us-ascii?Q?uPKAejK22fg+a1hmZSHMJQOoeR0Gr9MPGB00tl/kBcBVehcynVyG+0ByzXAL?=
 =?us-ascii?Q?+LuYmdkqB8i295dBRVauJYn9DqKj0mxzs8t+2LW8S0YrNHsZw3HRfAl441iq?=
 =?us-ascii?Q?bD9KgXlCFT283+5vJIEDY/90bJbWWIAjMI8ooeRAnAyWN4WXITMtUU5iBjfD?=
 =?us-ascii?Q?gf58SoYDZJp1qSQS3TTwbw0I9qbEZ/wLrBNnPDVouCybmBgHEtKxLrtjrXd6?=
 =?us-ascii?Q?9Z63QH/D/9tESn5/eeEmNH0U8B6l0nLQUrAPBkvQiLRlxpydsXXUYWcFVXZ/?=
 =?us-ascii?Q?j4L+579ngBukbZ1Fp/njWs/qS8VuqRW5A4gx5+LYCLi6PbFCStlx/UvY3oB8?=
 =?us-ascii?Q?tCz7bJD18SH2zhf1QxG4RGzvgslOGBQaBQAAtLBn0tcWIeYHUi+zq0MVTgK9?=
 =?us-ascii?Q?efn6pSXVH8s0DYCTVP/cnQdRzkPit97vp2HW7jZ0+PTxq0nAcUf/mNDVgDFy?=
 =?us-ascii?Q?hxLw9023oveuF1qIb8RmOIA42q+HsGwLnK1FfP0AUU3B6mDn9/Jhp7RtAvtg?=
 =?us-ascii?Q?wFiE5Ucq9Lxg0gpXW1B9R4CsB08fNQYxXWxYk0KTT3ePCBjF2x1wdKxjue0m?=
 =?us-ascii?Q?yWsU/nxW92ds0y13uL6Nt+LIAXZBC1dlgQxXMnC6D0RuEMV+4MUfXKGcMO9e?=
 =?us-ascii?Q?IzOMtvgOmrxmdbqfNXQGrWXLLrkrR8sD0FN2WYBccFgTUIFQX9RCjM3qkXF3?=
 =?us-ascii?Q?lKsCtpGlEpgvwcG2FzDidIicKw/RNPHmXU9AWzRZ+rJKAczHCXrWKWrOgW/M?=
 =?us-ascii?Q?JgCxRmSf6C5UFoCQebl8vS1LHqKW0e8QJzz1fucIQPrqlDRJjyR+hrMxLHKq?=
 =?us-ascii?Q?hX9n7YLnaXLSguh5Jgv+f3zJillsCufZReu3i/l0va04CP4194ZQKS2qcziR?=
 =?us-ascii?Q?GA0qMSyW46QJzRVpsfPGFmtyM0k1ioYULhlbdR4++FNlB9LIfCTGrhsU7faj?=
 =?us-ascii?Q?Ils/IsGHIdesMeB0h30BeWZNH2hVi0RSGb5zp5EHHpCHx/PXTLDLlkFZ1BcP?=
 =?us-ascii?Q?hh1G7981uHjt9aSaAotT/MztpVFP2aBafGcIL14xB+wv0ZqqxJoexxs/2bPJ?=
 =?us-ascii?Q?slNUQCanGzJyECeel34szeq1mfX1TSTLYqxMBZ4kRd3Oj9vlVg0fZyjdg6iV?=
 =?us-ascii?Q?NsJpLnkpQt+yr6zUsDrxcOU4p5oJs0sFmj4gHpGuKyEIGayJM+6Io65Xt+d5?=
 =?us-ascii?Q?gugUjuBGpqkrgCAjmB5DLqgl6mLm6XmIAlxxG42qDNoiVpSw+NiEBKzCcwB9?=
 =?us-ascii?Q?1SvuuZmg/4Ak7e7jtIeTboNtFnJ/35TiNnK8UJguyHHZEXXsUIGDvV8wXbqz?=
 =?us-ascii?Q?G953fGiWoi0hLDCV2vUCSu2sjkBfLUKgb6SQlE8Cc7Oa3Zw1xN2wtO70Dj8y?=
 =?us-ascii?Q?QtzzxrgHO3M/aVEukWBxVbtcCzTw98Y9OlwICKLa2CKyDHaUMGmR6pKqARBe?=
 =?us-ascii?Q?HrL8TZV2tBjS9KRyLTxLweDpcBJ4zTSEbxdWPkUP2BVAVhkaEt/OstwQS1V+?=
 =?us-ascii?Q?EQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f34c1c0f-2259-4237-7218-08db41f27404
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 22:56:18.9062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0LaxCqmuqKDqeL4beTUtoKQ9xqCu9DcDNigRvbjBXkZXi+Vi+q+XgC9lZy+w/LKrj3RXsUxmyGwaR/SDu4yezg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9497
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ocelot_xmit_get_vlan_info() calls __skb_vlan_pop() as the most
appropriate helper I could find which strips away a VLAN header.
That's all I need it to do, but __skb_vlan_pop() has more logic, which
will become incompatible with the future revert of commit 6d1ccff62780
("net: reset mac header in dev_start_xmit()").

Namely, it performs a sanity check on skb_mac_header(), which will stop
being set after the above revert, so it will return an error instead of
removing the VLAN tag.

ocelot_xmit_get_vlan_info() gets called in 2 circumstances:

(1) the port is under a VLAN-aware bridge and the bridge sends
    VLAN-tagged packets

(2) the port is under a VLAN-aware bridge and somebody else (an 8021q
    upper) sends VLAN-tagged packets (using a VID that isn't in the
    bridge vlan tables)

In case (1), there is actually no bug to defend against, because
br_dev_xmit() calls skb_reset_mac_header() and things continue to work.

However, in case (2), illustrated using the commands below, it can be
seen that our intervention is needed, since __skb_vlan_pop() complains:

$ ip link add br0 type bridge vlan_filtering 1 && ip link set br0 up
$ ip link set $eth master br0 && ip link set $eth up
$ ip link add link $eth name $eth.100 type vlan id 100 && ip link set $eth.100 up
$ ip addr add 192.168.100.1/24 dev $eth.100

I could fend off the checks in __skb_vlan_pop() with some
skb_mac_header_was_set() calls, but seeing how few callers of
__skb_vlan_pop() there are from TX paths, that seems rather
unproductive.

As an alternative solution, extract the bare minimum logic to strip a
VLAN header, and move it to a new helper named vlan_remove_tag(), close
to the definition of vlan_insert_tag(). Document it appropriately and
make ocelot_xmit_get_vlan_info() call this smaller helper instead.

Seeing that it doesn't appear illegal to test skb->protocol in the TX
path, I guess it would be a good for vlan_remove_tag() to also absorb
the vlan_set_encap_proto() function call.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/if_vlan.h | 21 +++++++++++++++++++++
 net/core/skbuff.c       |  8 +-------
 net/dsa/tag_ocelot.c    |  2 +-
 3 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index 3698f2b391cd..0f40f379d75c 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -685,6 +685,27 @@ static inline void vlan_set_encap_proto(struct sk_buff *skb,
 		skb->protocol = htons(ETH_P_802_2);
 }
 
+/**
+ * vlan_remove_tag - remove outer VLAN tag from payload
+ * @skb: skbuff to remove tag from
+ * @vlan_tci: buffer to store value
+ *
+ * Expects the skb to contain a VLAN tag in the payload, and to have skb->data
+ * pointing at the MAC header.
+ *
+ * Returns a new pointer to skb->data, or NULL on failure to pull.
+ */
+static inline void *vlan_remove_tag(struct sk_buff *skb, u16 *vlan_tci)
+{
+	struct vlan_hdr *vhdr = (struct vlan_hdr *)(skb->data + ETH_HLEN);
+
+	*vlan_tci = ntohs(vhdr->h_vlan_TCI);
+
+	memmove(skb->data + VLAN_HLEN, skb->data, 2 * ETH_ALEN);
+	vlan_set_encap_proto(skb, vhdr);
+	return __skb_pull(skb, VLAN_HLEN);
+}
+
 /**
  * skb_vlan_tagged - check if skb is vlan tagged.
  * @skb: skbuff to query
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 768f9d04911f..3fbf32897b8d 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5943,7 +5943,6 @@ EXPORT_SYMBOL(skb_ensure_writable);
  */
 int __skb_vlan_pop(struct sk_buff *skb, u16 *vlan_tci)
 {
-	struct vlan_hdr *vhdr;
 	int offset = skb->data - skb_mac_header(skb);
 	int err;
 
@@ -5959,13 +5958,8 @@ int __skb_vlan_pop(struct sk_buff *skb, u16 *vlan_tci)
 
 	skb_postpull_rcsum(skb, skb->data + (2 * ETH_ALEN), VLAN_HLEN);
 
-	vhdr = (struct vlan_hdr *)(skb->data + ETH_HLEN);
-	*vlan_tci = ntohs(vhdr->h_vlan_TCI);
-
-	memmove(skb->data + VLAN_HLEN, skb->data, 2 * ETH_ALEN);
-	__skb_pull(skb, VLAN_HLEN);
+	vlan_remove_tag(skb, vlan_tci);
 
-	vlan_set_encap_proto(skb, vhdr);
 	skb->mac_header += VLAN_HLEN;
 
 	if (skb_network_offset(skb) < ETH_HLEN)
diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index 73ee09de1a3a..20bf7074d5a6 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -30,7 +30,7 @@ static void ocelot_xmit_get_vlan_info(struct sk_buff *skb, struct dsa_port *dp,
 	br_vlan_get_proto(br, &proto);
 
 	if (ntohs(hdr->h_vlan_proto) == proto) {
-		__skb_vlan_pop(skb, &tci);
+		vlan_remove_tag(skb, &tci);
 		*vlan_tci = tci;
 	} else {
 		rcu_read_lock();
-- 
2.34.1

