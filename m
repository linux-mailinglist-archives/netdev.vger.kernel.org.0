Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF9C4BB8F0
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 13:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235050AbiBRMNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 07:13:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235024AbiBRMNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 07:13:33 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2065.outbound.protection.outlook.com [40.107.22.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AEEB25B6D0
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 04:13:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mrj6yvANvkN5RBLbfW11+4ZAvBcbPHUwaCW60sZ5u4GkYc6e87eQY2qm8g+bvYESG9pxKLWMP+W8EioeG4jlt3Ay1kGyOBJqYgrS2lK6ibJmRhjYUYRpVP2p11//HEUAmPiSAx2FxOhBgU4m7q17/FAegULbBa2mM/WUI42f1hjuyXnt8kZ2PNVYPsQsHtm6e/2mEW7e/xgdfk3WHTNQxuJ/gCbfMy93CECA2uHhpZCRXXpFBRFgg2D4ZM6+JZ9PfRFNnNDbTnRvxaM1yxOwar/1XMOJZQgIjSUwBlmQOgEje0tKj+pNc3jA32l8XBQZ5jN5l42HjG0TA9cXpLcI3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1soUUPKuHUl91IRuLObI0TlUrAJT2MAVth5TEt1vUbY=;
 b=h2EOkuw9NABeh/80tdyIOhNEBEnYKrbSgCbPgSb3o0EHyLeJX7EvQtzTcwKQnu5jhM3Jy09ESq6yKSq1etfn3rdYSOjKNgwoCRRpMqVl/mIz99EtERWkevzC45XaqWNYzYwsbtrIKLZyd/X+Q2x2p8qcELHQb+wwHtuGTwkPY5WoUnq1JymY7hW1ns9xWnQDB1733POpLvcG/A5Xnv17Tp7zNJHJk41MsZWWF2vSvCr51ciGRmihB9RUYAT46qrOQrruexGlj3RzmR+W9BsOgEGNSlQGu+heD3Ye4DYdlo06Yqg0/yec9QrKys1kp2DF08fGw1ONV11QUE3TYTPm6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1soUUPKuHUl91IRuLObI0TlUrAJT2MAVth5TEt1vUbY=;
 b=JXkXuNZwNKwUjPcgRSSbpeFvdHZlydKPcoKPISoiDvwj8+/kxA0FZPppDOaydAwL0oAFgL3W5EIJTax7sOeq6klt8yaOE1EiS5SmvZttyazxUQiBJIQVevCBN/e8E2A/fMFmTPYm6ZTCoIOgBom+wC3b3+hoxMEQeAuKJPNgdnE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7345.eurprd04.prod.outlook.com (2603:10a6:20b:1c5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.22; Fri, 18 Feb
 2022 12:13:13 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Fri, 18 Feb 2022
 12:13:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [PATCH net] net: dsa: avoid call to __dev_set_promiscuity() while rtnl_mutex isn't held
Date:   Fri, 18 Feb 2022 14:13:02 +0200
Message-Id: <20220218121302.3961040-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0802CA0013.eurprd08.prod.outlook.com
 (2603:10a6:800:aa::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85c2c56b-e534-4c1c-9701-08d9f2d8090c
X-MS-TrafficTypeDiagnostic: AM8PR04MB7345:EE_
X-Microsoft-Antispam-PRVS: <AM8PR04MB7345A7185CE4412322815107E0379@AM8PR04MB7345.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: imYXkfFqpUwwZckzmCZBxZ72RsCOx61J3HkXPxb6plVXREydLxS08KLQkbnpDqvAWDJTn1RTniB+kmKK8TOY+VL1gTj/yU42ViKxaybSJAQC8h40WS2wefaYtSxczSUt7nHxfwXOeh/Ouv3UArf81E7MQZw9QoMcHvI6t4FnL3GkJWHTHQYvCuUKdZHJslRRcM6bXPL7A6JM2BL+KtkUy82vnHcy7BtxfUX4qsnWZL49Zc7u8d2p6VdqJ3K1ypEqe8lbdHSlxEGtS1FJh+MYcVshn0bg4SwfuX0d05MqgduM9UGesGjDjZxgx+6wv7sCSxcWFG+YZp4ddO0/J1IWkOzZOVK4qr3RdcCxoSO1M3/frCL/FbuNiVg/iswsrHxbuo6ZhCozqI2fzzR8UuyCZNErKCLTBuTNTMikPuB7scnM9K5Z+EMHD57i3AJyAUM9Xwk96geVwbE9kja3wucGDHx03742oHQ6/Kp/96CiXQ3dbRpLT1EYZ31zH4Tnn/85OkdZCYqJBCwscBWcX/KBSNZMFUNR6mszLzr0nKMAYK+1J/+e0ShiCoAwVeX5SOtp05O43zvKy5s3qu8U9FwBc5C0MStIs6kw5pkkP1P+hPJFgfXb7Z9HZRiIaUoBQObuPXbpTaREi1UKaizITEuc0iRzNbsSewm0DBM64pI6UZiMEUDEjOPTqmjM4DrohM/I6QxeeW65/ohAnh8mCuVVJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(6486002)(186003)(83380400001)(508600001)(6666004)(2906002)(6512007)(52116002)(316002)(1076003)(2616005)(86362001)(54906003)(26005)(8936002)(5660300002)(38350700002)(38100700002)(66946007)(66556008)(66476007)(44832011)(6916009)(4326008)(36756003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wUiz/70YSJNvOXzyDuLCYNIZuYZlTIOEhspfIga24WKRjzvpgbV4X62pcADy?=
 =?us-ascii?Q?mPwYph9E4VsIzW0kvIcRfxw2wF8uhkkWWj2U7yE4ks3jf9m1tXyBaTDziOMs?=
 =?us-ascii?Q?6C1OvQRpsva1eb6skOiSMWA2KluTmxy4QN6v5b34X+UYfQIz3YdqHKvGq/b+?=
 =?us-ascii?Q?H5YBRFD6ObeH/Wm+vR1M/IopnWaj/6SZC+ITrZteWQpzQTeKutvZ97uxQkK2?=
 =?us-ascii?Q?hcXseoaXBtFxkclKnkVo1T4WkGJMvuxmYV2sPqspaF8r1FauQTkEsW/h3Sr5?=
 =?us-ascii?Q?Enbi9+Lu89aa7/gWse3Ex51xcPNwgyPb0m6QeeIPhwlM2PYX7s+yp199KcTr?=
 =?us-ascii?Q?bD0Shs1MxOJpIT7bRPWdrByVoNLZLihtQQQIBIWg8AUwCt3k1pVwa4Pi6P4K?=
 =?us-ascii?Q?hCQrkf2ns1qfNXbzqhp3e1AOdMomlYF98F3hbQ8p5rjFSiT3+hr7gVLsdCPs?=
 =?us-ascii?Q?4GP1RcRlVLkXXu5OBtzajkZ3mirV4i3oIW6NMAYfwEl6K/VUabkAt3hRew9s?=
 =?us-ascii?Q?hU2T0yy0VEsDDVIu7GmllSGdJdHvVJAzVQLaN6ChKVXMLmH3zDDF8ig7BVXA?=
 =?us-ascii?Q?hqz96pVifqk5UzjjWQ77qBlA6EjoTGzB5VktoCv0Frlo5HCHf9ddHDJ05nrq?=
 =?us-ascii?Q?YRN0t2Jj6Y5x9sbUnONHZ5ZmNOl2YEhGr1DzedhOzvK2k6h62p/Wg+hQ3RGd?=
 =?us-ascii?Q?FCNqeoEZMqQi6I3B+eo4sjYg+y16W9/sWG6gOvHzmoQzs80GWCWZhLbVpR81?=
 =?us-ascii?Q?1tH4s9yl+lnLNLL3CV5Zqi1m3Wupx58iR/Lh81UjMYzKnDp+Ei1PcXRmvPeq?=
 =?us-ascii?Q?VeY5Kbv/8hPWlN4epUM473d7J434gx2E1CJ4UEMaxKYtGQ5ct/mMScasONQ0?=
 =?us-ascii?Q?2BlkQIHHbAt/bPLIJXQwb3r5bzaR+YSy+Fuax7J+i+zSAuiSpg5mGfTVqEnS?=
 =?us-ascii?Q?BCQ0ScrlbPqj5yyrKX56lxEQPjCwwYh4zR6LSAYmjkYjBPeVZi1NyOnQtDwj?=
 =?us-ascii?Q?75Lz+D13u6gHCQ9/Ep9oFMAaYRaQ8ifhlg9T51/vH+HxRGccPLqxTOLX0gEo?=
 =?us-ascii?Q?M6/F7d9YrlrPBd1edYDhS9MlWgDxZJLpJM2gvVMVHP8NxuDbkY0KcP/1O7iw?=
 =?us-ascii?Q?rb2NLqinO60NUGPZt/5FHZDDBEiAgc8+BvMCADyFeN72qde8J9/+y6JEPghn?=
 =?us-ascii?Q?hyXAPERmsYQkA5FGJ05b5otf/aJgGiQ504Z5/M74ALJ3VoUo5G07JxmTsVwE?=
 =?us-ascii?Q?09TcTM6RRixxKW0wPOyYQeiaSKJ6MFHM37q54Qq3XFSFJko6wlUB3i6tBoZc?=
 =?us-ascii?Q?jQnPw30o3SibExsL0ASMUu7QcUfLFZikLo0xRliOE7G3XK7VYvRxDO2NTjcw?=
 =?us-ascii?Q?7vqgbbxzV+1/g8XtEZyDIkTSJdCkBdncSB4C/IM7weYTUdmYP7pY0HzLTj4L?=
 =?us-ascii?Q?SRKeL5BmCCo9EmgioEZvfOpeJaTStGaa2rSr3SNt9uSdSRv7InerQSblKIrc?=
 =?us-ascii?Q?rbwWqxDGSYE9VHzspnwFNzEBEwDfSIIOHw/TO7y3D6uYmGr8xfPIYutFr/He?=
 =?us-ascii?Q?CZXVOOWnyM8/nSVwLAkwRlanDqmaF5uYQWRJl26BlIJVFrX0rNX9WHIVuXqK?=
 =?us-ascii?Q?Sp6QCK+qw3ZgyOxaZh+Ub8w=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85c2c56b-e534-4c1c-9701-08d9f2d8090c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2022 12:13:13.0969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TLAnbuKDRhhdEwRZBbhXgR7BlukoUelEAgvkrGNJHJz1nPG+ER96MrTfy/ongmpwTYW7xbOkDphpcXNmaWpQ4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7345
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the DSA master doesn't support IFF_UNICAST_FLT, then the following
call path is possible:

dsa_slave_switchdev_event_work
-> dsa_port_host_fdb_add
   -> dev_uc_add
      -> __dev_set_rx_mode
         -> __dev_set_promiscuity

Since the blamed commit, dsa_slave_switchdev_event_work() no longer
holds rtnl_lock(), which triggers the ASSERT_RTNL() from
__dev_set_promiscuity().

Taking rtnl_lock() around dev_uc_add() is impossible, because all the
code paths that call dsa_flush_workqueue() do so from contexts where the
rtnl_mutex is already held - so this would lead to an instant deadlock.

dev_uc_add() in itself doesn't require the rtnl_mutex for protection.
There is this comment in __dev_set_rx_mode() which assumes so:

		/* Unicast addresses changes may only happen under the rtnl,
		 * therefore calling __dev_set_promiscuity here is safe.
		 */

but it is from commit 4417da668c00 ("[NET]: dev: secondary unicast
address support") dated June 2007, and in the meantime, commit
f1f28aa3510d ("netdev: Add addr_list_lock to struct net_device."), dated
July 2008, has added &dev->addr_list_lock to protect this instead of the
global rtnl_mutex.

Nonetheless, __dev_set_promiscuity() does assume rtnl_mutex protection,
but it is the uncommon path of what we typically expect dev_uc_add()
to do. So since only the uncommon path requires rtnl_lock(), just check
ahead of time whether dev_uc_add() would result into a call to
__dev_set_promiscuity(), and handle that condition separately.

DSA already configures the master interface to be promiscuous if the
tagger requires this. We can extend this to also cover the case where
the master doesn't handle dev_uc_add() (doesn't support IFF_UNICAST_FLT),
and on the premise that we'd end up making it promiscuous during
operation anyway, either if a DSA slave has a non-inherited MAC address,
or if the bridge notifies local FDB entries for its own MAC address, the
address of a station learned on a foreign port, etc.

Fixes: 0faf890fc519 ("net: dsa: drop rtnl_lock from dsa_slave_switchdev_event_work")
Reported-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/master.c |  7 ++++++-
 net/dsa/port.c   | 20 ++++++++++++++------
 2 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/net/dsa/master.c b/net/dsa/master.c
index 6ac393cc6ea7..991c2930d631 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -260,11 +260,16 @@ static void dsa_netdev_ops_set(struct net_device *dev,
 	dev->dsa_ptr->netdev_ops = ops;
 }
 
+/* Keep the master always promiscuous if the tagging protocol requires that
+ * (garbles MAC DA) or if it doesn't support unicast filtering, case in which
+ * it would revert to promiscuous mode as soon as we call dev_uc_add() on it
+ * anyway.
+ */
 static void dsa_master_set_promiscuity(struct net_device *dev, int inc)
 {
 	const struct dsa_device_ops *ops = dev->dsa_ptr->tag_ops;
 
-	if (!ops->promisc_on_master)
+	if ((dev->priv_flags & IFF_UNICAST_FLT) && !ops->promisc_on_master)
 		return;
 
 	ASSERT_RTNL();
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 09e1f2f589ba..11c6c0f2c947 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -781,9 +781,15 @@ int dsa_port_host_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 	struct dsa_port *cpu_dp = dp->cpu_dp;
 	int err;
 
-	err = dev_uc_add(cpu_dp->master, addr);
-	if (err)
-		return err;
+	/* Avoid a call to __dev_set_promiscuity() on the master, which
+	 * requires rtnl_lock(), since we can't guarantee that is held here,
+	 * and we can't take it either.
+	 */
+	if (cpu_dp->master->priv_flags & IFF_UNICAST_FLT) {
+		err = dev_uc_add(cpu_dp->master, addr);
+		if (err)
+			return err;
+	}
 
 	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_FDB_ADD, &info);
 }
@@ -800,9 +806,11 @@ int dsa_port_host_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 	struct dsa_port *cpu_dp = dp->cpu_dp;
 	int err;
 
-	err = dev_uc_del(cpu_dp->master, addr);
-	if (err)
-		return err;
+	if (cpu_dp->master->priv_flags & IFF_UNICAST_FLT) {
+		err = dev_uc_del(cpu_dp->master, addr);
+		if (err)
+			return err;
+	}
 
 	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_FDB_DEL, &info);
 }
-- 
2.25.1

