Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECFA4AFF3A
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 22:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233518AbiBIVbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 16:31:36 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:58986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233465AbiBIVbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 16:31:12 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140081.outbound.protection.outlook.com [40.107.14.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E15C1C0045A5
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 13:31:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZPp9KELUP1OYSMoXMgsgTbSbfHEbLl6fTWydwBc5aHEp9q1aP79W7/eB4X6+vDXNoDMMM6T7smCKEqKa5PsdtizFC964yqAnqkf+WRW7HMeTnEzo76mnXG8VLB97bk5IkvDEvvSEKCK3XtB9xI0yqOoGdrOBJPKiC5c2fYciuTuBqb49L4GoLMjE4f3880dr78JmIqU69P8YXKb33LhqRHEtyweIROv83Lfanx7YkH6dKnJFcktL56Jv1622TWlE2sMWdihhg87A02NCXdb69JPZ9q7q4N0bsXyI6TZe2G9DtUE+XR/DZkn0olUOm62xrLstPY2PWb0kbBRcplpFGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VuneEx9DS+CE/0abLvuhCoFBnwOXlZEkJ/H40dIVbvs=;
 b=JfSGxpWTizlL58EbkWfPNapI4oIfbFHD8Bx7uCdx91cdUi2oORauw1NONezJOTi9qbXo/eGrJSiBTx9EzKJT4oEQRl97cuuRnxVJdznEvVNPz35Z6ZD3IKrMZoKq+7CTbim1H6G5w0u7I3PmS/5gU6S+DIiV3highUBX2hB2vE5eX6ZUDG1E5VJ0laujz469Eq7oUV77vIqN5etRm40lPHYHPpf+49xt9NQXFZVhVJF+2+eX3+E3PyKX0yJIoTBZd5dqh3AvvTK4tOO42y99fwbaXB7ASEB73ji1+D9EkevrieV8uZLGng+UJfjUvFW7xseofj35VhhnQ+X1QsWI6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VuneEx9DS+CE/0abLvuhCoFBnwOXlZEkJ/H40dIVbvs=;
 b=onlema4TAJ8iGv3Cb7Cw8nvKw8swm4/yr2TfqBoWzwUg/2Np4QxhCy78MduJcs7KC/eOepS68l8GzRBaFUy+FeH834FM96/2qlbbXlnDqtlmZHM4yYbkIvFWV+9PooebikiXOCQSd/jjBu44nCOW8cCbWTtoA/zO3DdjZdDoJjI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by HE1PR0402MB3481.eurprd04.prod.outlook.com (2603:10a6:7:83::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19; Wed, 9 Feb
 2022 21:31:07 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 21:31:07 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [RFC PATCH net-next 4/5] net: bridge: switchdev: replay VLANs present on the bridge device itself
Date:   Wed,  9 Feb 2022 23:30:42 +0200
Message-Id: <20220209213044.2353153-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220209213044.2353153-1-vladimir.oltean@nxp.com>
References: <20220209213044.2353153-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0077.eurprd09.prod.outlook.com
 (2603:10a6:802:29::21) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c15d97b5-7e45-4d17-777e-08d9ec137baa
X-MS-TrafficTypeDiagnostic: HE1PR0402MB3481:EE_
X-Microsoft-Antispam-PRVS: <HE1PR0402MB34810FF6BB907EFD1A351B8BE02E9@HE1PR0402MB3481.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6lshKCHgtDp2EE3ML9OQ1rS5nrwUmeI0ebCjLm+8bKM2mrLIYzct1OS45gZS465pdhfxzQe62bT31Jj03Yls9ENcpOC9Oa/NGgvPg6Q70ATgMWlqdj0hGY5KTIDcuouLMhnIz8Ku+7tGt2cZLaDcV76XPRKj92UpQkESyYALW4Q+eKYDi7YSWEcznX+/86hU8Cm3ATnBDaz2E2/m0tB/fjiIgDjLC3r+7Gwv2seN21DyRpz2l+lZrYYOMkx2ZUwj4a5f1OSqeuCYYootlfQWA5Wk3S4vga1qtZMuhFc1WYhFdeAfFo8IiIPuesl3JuSlqvVFlOn3zIkBr9dqNEX744DhDSOH3OrzvtQZ0iNYP16g39wrk3myOkpuV2ZbvWyVYRNzzZ46CoQo2ggGNcz3jGKGgItYN4yufHxkX8UmJHOTe9LrDjbtNQHW07pE+WIBfymgwgQ0+RPK19cS/QgV5zF1bJ2MeBol9JTufVZA80tjw96kupT4J4X5j+FO6Bpf6vlY0lA7S69XlmheBghzYuxzi636IsjaZBWaNPkgkebIYbIxfJN3hIk6jVg+ofR/NS21inUCfehwDk+ak4n51qhWQ1pXIKEONv87LX1sb9zcvxRiCwUX9TBhKYOXAhfiiXvUUkfcJ9jqXoFZKU8qShTeK4hiVydKYjr98wHVPOsLut/ROplst+9lhYWpj3EhxJMoF49rD+RKoGEZwvreiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(316002)(6486002)(86362001)(508600001)(66476007)(6916009)(83380400001)(5660300002)(6512007)(44832011)(52116002)(8676002)(186003)(26005)(7416002)(1076003)(4326008)(6666004)(6506007)(54906003)(2906002)(38100700002)(38350700002)(36756003)(2616005)(66946007)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lQoF8nmu40N/z5PNiXJtXMw7Dh2i9S+SH5glJhPr8MuvsfggIOzjgKNi90mJ?=
 =?us-ascii?Q?ZjkN4YMvlJpufr7OFTGnSC1jG2nRKX522TfQDv88PldVWRGUS2/zBur9+r87?=
 =?us-ascii?Q?9b5A9i/griKthRaytXS9e5fyoMJlzyoKNagoKJdV1WeasL+xI7myNO5W56pT?=
 =?us-ascii?Q?fr2Rs9mOJL+dZ0SgyjNZvcNy6aIwwne1leOmfir3Dxb1D9l1aJuqUyOsHStF?=
 =?us-ascii?Q?8YcpK50WFQ2W/hGMYtebkne5ajapSJ/o4aSUMKX+wnmV7MGQugPD+bv69ycc?=
 =?us-ascii?Q?pIOFJeuDQjNz96PSXi02bWL+90zIUm2sYdMIqSAEGt/fCC/jxguB8Wiq3o3M?=
 =?us-ascii?Q?Q6YGULUQOgMyT7YL1D6o+in7+Kr6QW6skw5dH+sKoUpKNZSV7bsm0lCjxf2R?=
 =?us-ascii?Q?7rbuE28BW5k+IOG1S2GWM5glZ9WwKXFT6I50GcUxv6fdK6pQwBv4bOjxxSws?=
 =?us-ascii?Q?QBhcwf+bCe8fl4rHKBmYNWS1BamHOfQ1cK+/P2K8olMg6oZphYuM2Wpx4gbU?=
 =?us-ascii?Q?ZrX57O6/29llwyzPJW5D6p3EY2yWXqO8jfY5aNrUdWvqEu9YMP50nFApGr6n?=
 =?us-ascii?Q?cY+CRjGMtgbhJOf0dnVIesq8BR4A/cPs1hyC0waUhjSuQrBIGz4zl4zRLz48?=
 =?us-ascii?Q?0A3WQ981N5JMq989DjjlyMkJntsDib7ZHRGvHOlKqtnuATQGDhTeuUMM706B?=
 =?us-ascii?Q?NE36s6IUdyBHeU7VFO7Bn3LsUTJf+O11yBqB0ggXh2ePGtqiGdyXmZS89Yxf?=
 =?us-ascii?Q?RlIh+HQAWtu1A0KoGKMmI2TB6qbuhK4JsLf9FrXByXsBfyS9g5fnoXs4Osvc?=
 =?us-ascii?Q?tASbLAH2rCQkGgoJuhlN+fEy+V/tWSu277Sfcz/AvTi/XKxSXKzQIdy8/q6l?=
 =?us-ascii?Q?BMecHzBb5WzR0vf68uNEqxR4gCwm1kkTE8hdhemeNFOqbt97mUeVMRkwzw6X?=
 =?us-ascii?Q?0S6ba9CLCYhBJMjRlVRFmXx9h1sO2SZlEB2KdsGIUDEA252dPow/AoklCk60?=
 =?us-ascii?Q?ZgRHNyxiI6mBJYlrs/sKXiJsNnvW8iZyKsxPj+lPktK1WTzrCvz+DzdNCQEQ?=
 =?us-ascii?Q?QPMla5bilwAuycKYjANi2n0fU2lvocX4HR5Gp1iiyqd7ZN8jK1FaFMpEsLW9?=
 =?us-ascii?Q?xynl6Bpaw8dEuk5/nG8HdciyF9wnmRAHYQwwUdCjFF+u5/kBhy4aUedCWfwA?=
 =?us-ascii?Q?vQiVcNI1PJWWjd3vu5AxdDV6PXPujgygIg6VONYxST8sN8s1DQQ1xBnBW4s3?=
 =?us-ascii?Q?4QdWOw/Id9qmwYeJYsKYSdTpVJPxwzkj0B0F3pgNemj4Xj59bfZ3/T9MUaOm?=
 =?us-ascii?Q?pUU2UG1UV0m8adU8ghXMCI6+8Lvp7QFvscEmGjAsL8gH+EwYzQWxGcGQbYRf?=
 =?us-ascii?Q?PyUfrGiq3SKXn0jV/daolQS2UPq/2+5WbBZWr5QLaq6bDbV9DdQ2Oug8pX+P?=
 =?us-ascii?Q?86Exn177ZvqzgwvPH7dZunJnujpFpMjwyxp+LXLR+0503F2SAaC+VWb3ex9q?=
 =?us-ascii?Q?6ZOLLBQfa4PpgdtLGpTfC4a0TNnyhtWBq81JG4/ghBdq9E+M+woczcqsOP2B?=
 =?us-ascii?Q?MkhLdeviyMBIe7aS4UEHt56/U6AfgMh7V4MNtYkKWI5lN91C8Rra48+3xq/k?=
 =?us-ascii?Q?0zHPr0iUudNr8DHBUaRsmMo=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c15d97b5-7e45-4d17-777e-08d9ec137baa
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 21:31:07.4657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yxg3E+ycSVsC9cdRenhqNumrzjqUbyrjJwlVlVDWA1yy206WRuZOrTLPcrnX4b8pbY1o0PqsCSwCSgAJpNbY7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB3481
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mv88e6xxx DSA driver currently prints this error message as soon as
the first port of a switch joins a bridge:

mv88e6085 0x0000000008b96000:00: port 0 failed to add a6:ef:77:c8:5f:3d vid 1 to fdb: -95

where a6:ef:77:c8:5f:3d vid 1 is a local FDB entry corresponding to the
bridge MAC address in the default_pvid.

The -EOPNOTSUPP is returned by mv88e6xxx_port_db_load_purge() because it
tries to map VID 1 to a FID (the ATU is indexed by FID not VID), but
fails to do so. This is because ->port_fdb_add() is called before
->port_vlan_add() for VID 1.

The abridged timeline of the calls is:

br_add_if
-> netdev_master_upper_dev_link
   -> dsa_port_bridge_join
      -> switchdev_bridge_port_offload
         -> br_switchdev_vlan_replay (*)
         -> br_switchdev_fdb_replay
            -> mv88e6xxx_port_fdb_add
-> nbp_vlan_init
   -> nbp_vlan_add
      -> mv88e6xxx_port_vlan_add

and the issue is that at the time of (*), the bridge port isn't in VID 1
(nbp_vlan_init hasn't been called), therefore br_switchdev_vlan_replay()
won't have anything to replay, therefore VID 1 won't be in the VTU by
the time mv88e6xxx_port_fdb_add() is called.

This happens only when the first port of a switch joins. For further
ports, the initial mv88e6xxx_port_vlan_add() is sufficient for VID 1 to
be loaded in the VTU (which is switch-wide, not per port).

The problem is somewhat unique to mv88e6xxx by chance, because most
other drivers offload an FDB entry by VID, so FDBs and VLANs can be
added asynchronously with respect to each other, but addressing the
issue at the bridge layer makes sense, since what mv88e6xxx requires
isn't absurd.

To fix this problem, we need to recognize that it isn't the VLAN group
of the port that we're interested in, but the VLAN group of the bridge
itself (so it isn't a timing issue, but rather insufficient information
being passed from switchdev to drivers).

Currently nbp_switchdev_sync_objs() only calls br_switchdev_vlan_replay()
for VLANs corresponding to the port, but the VLANs corresponding to the
bridge itself, for local termination, also need to be replayed.
In this case, VID 1 is not (yet) present in the port's VLAN group but is
present in the bridge's VLAN group.

Call br_switchdev_vlan_replay() once more, with the br_dev passed as the
"dev" argument. The function is already prepared to deal with this and
search in the right VLAN group, just that the functionality hasn't been
utilized yet.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_switchdev.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index f8fbaaa7c501..d2d59fcfc0d4 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -681,11 +681,18 @@ static int nbp_switchdev_sync_objs(struct net_bridge_port *p, const void *ctx,
 	struct net_device *dev = p->dev;
 	int err;
 
+	/* Port VLANs */
 	err = br_switchdev_vlan_replay(br_dev, dev, ctx, true, blocking_nb,
 				       extack);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
+	/* And VLANs on the bridge device */
+	err = br_switchdev_vlan_replay(br_dev, br_dev, ctx, true, blocking_nb,
+				       extack);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
 	err = br_switchdev_mdb_replay(br_dev, dev, ctx, true, blocking_nb,
 				      extack);
 	if (err && err != -EOPNOTSUPP)
@@ -708,6 +715,8 @@ static void nbp_switchdev_unsync_objs(struct net_bridge_port *p,
 
 	br_switchdev_vlan_replay(br_dev, dev, ctx, false, blocking_nb, NULL);
 
+	br_switchdev_vlan_replay(br_dev, br_dev, ctx, false, blocking_nb, NULL);
+
 	br_switchdev_mdb_replay(br_dev, dev, ctx, false, blocking_nb, NULL);
 
 	br_switchdev_fdb_replay(br_dev, ctx, false, atomic_nb);
-- 
2.25.1

