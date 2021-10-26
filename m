Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEC3A43B40C
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 16:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236578AbhJZObD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 10:31:03 -0400
Received: from mail-eopbgr50050.outbound.protection.outlook.com ([40.107.5.50]:8192
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236556AbhJZOa4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 10:30:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ez3IrKFITx/HZOhAIWfrZ6FlyF4Lp0AzTZxQHLY7v7OZ4IFdH1rf8c5y0L39+bKGfLONdTXD2OxzYuzP8fTm36oov6xsVMgJmYNS6U79YvJNP8o4SCamVyCyw92BvW6K+8kjpjPtMtGZFeqbKMdRl5CBJ4kFRavWl2DJ8kI8rZYbCkwQZqY5+YGUo6tHqXQDPVMClieBm2bYyjyss3bxkSnBW35xzjEN8e53TyWy51yZuRPjgs1yymiiliniWj0DXlpYBmoftF/OxgAFKG93ecZlPbQZweSFFSqPHPDhJCHCWJvt3AVRDgJRO1WPDQejce0B/RxXcFcPB7vwjYYADA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A5nR19mNnV8u2H1uvZkP9pWk3V2t74K2rRbftmh1R8w=;
 b=RK4MAIuS2R9alImipILak8gkjHSwIPbL/wvApEuYHz2dPOpLWKlC3ICVqS3ME3yNkuB/sIgvjVomSW8aXJMM1jff4wJWfzq3RmmGmfra/Y1SdBzUvPx4Hd565xl8cTKnvb8EFlUWl7jY2a/Ofr1t9xhPYVsO9ZBlIi2+lLQ/svsFOnqewmSTedwrztenYYMxZADm8Yg2r35bdehcWdCjlyAs7M3KNTPxpyWYvitaN/sLfh3S/dhB3FTDmPwWUxVOyQaldLQT/cNGS6/Oj1UXGIr48XFPJgxgIBHFz1PwsSWUE0pj7hB0RMvyCNGtn5G9NM1H9KkWKkg0/vNX9OEdjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A5nR19mNnV8u2H1uvZkP9pWk3V2t74K2rRbftmh1R8w=;
 b=SfiJ+0ZjfDFQIKW0Kj8gKkl254GDl9Tu6ean420LQfBwNxAh1PCvQHnJ6oPkc7bZBGx6+36DoX4ELAwrdhnh7TPJtgWgmA0gK0VT+HXhgrZVtvixB1KN9RhYaUHFRKYVHTUpT8aYROv3SUAbt45ftCDg6LZhfaiwCBWQxPyk0YY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6016.eurprd04.prod.outlook.com (2603:10a6:803:d3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 14:28:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 14:28:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next 7/8] net: bridge: create a common function for populating switchdev FDB entries
Date:   Tue, 26 Oct 2021 17:27:42 +0300
Message-Id: <20211026142743.1298877-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211026142743.1298877-1-vladimir.oltean@nxp.com>
References: <20211026142743.1298877-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0113.eurprd07.prod.outlook.com
 (2603:10a6:207:7::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM3PR07CA0113.eurprd07.prod.outlook.com (2603:10a6:207:7::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.10 via Frontend Transport; Tue, 26 Oct 2021 14:28:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a9453db-67cd-469c-dc70-08d9988cd6e5
X-MS-TrafficTypeDiagnostic: VI1PR04MB6016:
X-Microsoft-Antispam-PRVS: <VI1PR04MB60166DE61C5228089E2FA374E0849@VI1PR04MB6016.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FQxDW6OMHhdaQLDFqr6bbyN8e4yH2wG77Q2CLqKuD0UxMI4ks0/s35TIDwFiY0cbxiLLmErrua8m0SerpjK4ym6uNhBfFuwmNRZv8QgBoVJObkEl6KKF/oLDaZaRqH1DYqtkAITViqYEimsZEpEN4bykVOy10LMiXQFyqHwHvcKrH0pVxtD/6dJbNTyANeJpW2CibM6NXq4gsoJQl60Zlh8suGMqAUbHXYEJ0B84dGtWXODpokCslZzIQNfvyO1kVFrhMxWxy3ECmxkT81HznYozw6upCUlbPCcm2BHgdpNdgkVvA2XXq4RxcEJS4Wkno9qZd5UwDERNB/NnX4nIC8DB54xqlzKy/hCyA41Mu14KwaXCof5QVeJzWF8Fdx9498sSGvZv8kAYpongAVcwN/e2kNYlqB11N6Jx5bMpFupWuCgpwT11mpMc5ppMCx8i1b60aG+H2sj34qB/jrxW7xPPUfIrvREnVWEfTXh+P6uu1ATH7Iuz9mUxi8tCJx7dKPqaL4bVFlGx3NDYa+1J2NibYW0SeXGkwwRabnp5BjXBC309/jE1F+ccKyJ4dJAuRKU3DYEfQpVgaSuTJ/az0Rtx+bTzkXS4eGpegWirMW8LzI4eIi0BGsajjfRq/3ByGo3BoRI13Rna4RqM5MYzC4o7nLiXzCSzRjHTmLs3Wmc1Sl4aqlYDJJr/23rudO+Z6g1d5RB2Nv1G31m35pR4Tw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(52116002)(44832011)(66476007)(26005)(38100700002)(54906003)(8676002)(86362001)(5660300002)(2616005)(38350700002)(7416002)(6486002)(6506007)(6666004)(66556008)(316002)(6512007)(956004)(6916009)(36756003)(83380400001)(66946007)(2906002)(186003)(8936002)(508600001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2DYS/48SVLqpQmxcpuKG8qh3E8FTaoNaaw+x6t2KBV6PPNE5okBfiziqctKG?=
 =?us-ascii?Q?6iSi8pgstgsSVezzYEjFy+bcD4MfpHfHEaFUDQ01PsTaxbCdcmBNKrbisqLr?=
 =?us-ascii?Q?0/IwNIK63TV7cuaCOicmFx5nycEB+n1G9tYF3WovmgPij4TBvRKOc5Tp/mcf?=
 =?us-ascii?Q?OJAOcBwry11PvGhnPKHIFHfMtpKbO4rZYjumFvixlyF5rt6uJvKGJCwDvFK0?=
 =?us-ascii?Q?56Cz8CtTugbO5Dbl8Fe0/Z6jagJKwpyc9UX3UtlQ37bN7Dgd/iqW1ZI9wnOk?=
 =?us-ascii?Q?XysNrwgNk+Zk5dR5tb0VROgdBfx1exGi2hvJjuYOKAT4lLFwBD504rp1B/T4?=
 =?us-ascii?Q?XGPo87iO7QYev3S3N5umEkcJBxebRlxDsNmcEJIwdtmpHqhg3SYBj5uk0vWg?=
 =?us-ascii?Q?aBKXMSkWDqgA01W1L6W8IowHP3ylO4Ob6isXa5WWnKIhGeuIJnoaj8jLoRKu?=
 =?us-ascii?Q?XYEm/TeMyKZBEFQCl5e+Vz9k5P+6LqYE1ScDI8Sfji38zHh5yBh3nnSzzOLU?=
 =?us-ascii?Q?3hp/q4F62jscH3ECfH0EgYmXGD+znpoS2Vytm1tz6jxcIt3o5wU2tU7wAYFO?=
 =?us-ascii?Q?JPhyiXJnGIUgxDvEE+w9z/zRyALblpmcuNQYIaBqBqZDqaLqW7vGoD7jCCul?=
 =?us-ascii?Q?kQRszDt+1AqgPfrSGFOfssY/ccWu8pbcAtPnLv2Y2teJvAvkG9jZiG7NQo4R?=
 =?us-ascii?Q?NdPlw291dv4oRC4QrRTnheqZBeG1nTr392F9XdZpR/GTtbI8L9ARAhrvSirt?=
 =?us-ascii?Q?t6iBJ2qwayncVOoJu9Sl4WIc8GiBs0yiqfDFxMeSct0YF6HwXw/1VswkM/Nb?=
 =?us-ascii?Q?znpSfxjvCwAVVSHxGCFwE8Pb3yIRQ127+oMrXNdNzfS0f76CyLQTWitcQqQ1?=
 =?us-ascii?Q?1o3MN9R04+fR9sGqMcKAfr9useqjrAHyngWLhz99VS0i8B8A0E8ptG8ZplkA?=
 =?us-ascii?Q?dEXMuZAhu6OaqQZ09Mm4jK4l7TMMC6dUF2BGzVgw2g8LKpFpSyAMoE4mwOFe?=
 =?us-ascii?Q?U5jzOz1PmG2LZzmFDFh2u4AROKb21rtdSPDcDPq+ZHZvKmlv31MpyRHLI3s0?=
 =?us-ascii?Q?UUrjULL4jaGLJtqfNUHeAOR6QwIlb5T32C3/2l7KrfRuXj/M/GnMdO99yCPV?=
 =?us-ascii?Q?aLDNLfFEHriKeMc7ik7dq6sb2/MPdpI2axWQ9O3RWavBuMxEM39p2YLoUklv?=
 =?us-ascii?Q?nj8S5sv42M7DYSRMRExoB+0hr5xdMgYjyZ29LuLhbwNH7zuhjBtpqD30go3p?=
 =?us-ascii?Q?J0N98U4UDMq1gPPUbVpFswKdB06MuYK3lFsKvLHB1J6NUKLE/1SvFcwkvqpJ?=
 =?us-ascii?Q?YvkV3IPDr1dbmGnq9RQWPagHen8qPETxuRK0+gEw1eT1RK3s/9c/CX9pWPsI?=
 =?us-ascii?Q?v7vJeoaJB7o/I32gtZre5KKf+s82wRSbeCPPhk4Mep9/DwIjk4uqOoJAZmZS?=
 =?us-ascii?Q?tSYMNz/rzZ8FORTv0x4p8R8IDaYqPtmfJrKUnz1tJVe29EW7OxHSXgeuxgYz?=
 =?us-ascii?Q?hzEht4Wbtzqr42hq9xvif1sfC2LgJNgFV4xpV3MJPtKk5+EKk3Y0rfPrOHLZ?=
 =?us-ascii?Q?cz+ziQT8sFFugsKNRQ/6Yga4kjFfkMXwWBOCLel0hGVuow6hBCaz7+ibAg6W?=
 =?us-ascii?Q?Sa+WC7xUVCey3XF+/t14oUk=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a9453db-67cd-469c-dc70-08d9988cd6e5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 14:28:11.9796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: osC6jEB+gGniF6W+myEL5cGZheKssc9mRbp/dv/sxCY1NqTQjQW2msQrjcdblWavSoixO026fQtRf6afUhocrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6016
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two places where a switchdev FDB entry is constructed, one is
br_switchdev_fdb_notify() and the other is br_fdb_replay(). One uses a
struct initializer, and the other declares the structure as
uninitialized and populates the elements one by one.

One problem when introducing new members of struct
switchdev_notifier_fdb_info is that there is a risk for one of these
functions to run with an uninitialized value.

So centralize the logic of populating such structure into a dedicated
function. Being the primary location where these structures are created,
using an uninitialized variable and populating the members one by one
should be fine, since this one function is supposed to assign values to
all its members.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_switchdev.c | 41 +++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 19 deletions(-)

diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 8a45b1cfe06f..2fbe881cdfe2 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -122,28 +122,38 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
 	return 0;
 }
 
+static void br_switchdev_fdb_populate(struct net_bridge *br,
+				      struct switchdev_notifier_fdb_info *item,
+				      const struct net_bridge_fdb_entry *fdb,
+				      const void *ctx)
+{
+	const struct net_bridge_port *p = READ_ONCE(fdb->dst);
+
+	item->addr = fdb->key.addr.addr;
+	item->vid = fdb->key.vlan_id;
+	item->added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
+	item->offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags);
+	item->is_local = test_bit(BR_FDB_LOCAL, &fdb->flags);
+	item->info.dev = (!p || item->is_local) ? br->dev : p->dev;
+	item->info.ctx = ctx;
+}
+
 void
 br_switchdev_fdb_notify(struct net_bridge *br,
 			const struct net_bridge_fdb_entry *fdb, int type)
 {
-	const struct net_bridge_port *dst = READ_ONCE(fdb->dst);
-	struct switchdev_notifier_fdb_info info = {
-		.addr = fdb->key.addr.addr,
-		.vid = fdb->key.vlan_id,
-		.added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags),
-		.is_local = test_bit(BR_FDB_LOCAL, &fdb->flags),
-		.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags),
-	};
-	struct net_device *dev = (!dst || info.is_local) ? br->dev : dst->dev;
+	struct switchdev_notifier_fdb_info item;
+
+	br_switchdev_fdb_populate(br, &item, fdb, NULL);
 
 	switch (type) {
 	case RTM_DELNEIGH:
 		call_switchdev_notifiers(SWITCHDEV_FDB_DEL_TO_DEVICE,
-					 dev, &info.info, NULL);
+					 item.info.dev, &item.info, NULL);
 		break;
 	case RTM_NEWNEIGH:
 		call_switchdev_notifiers(SWITCHDEV_FDB_ADD_TO_DEVICE,
-					 dev, &info.info, NULL);
+					 item.info.dev, &item.info, NULL);
 		break;
 	}
 }
@@ -274,17 +284,10 @@ static int br_fdb_replay_one(struct net_bridge *br, struct notifier_block *nb,
 			     const struct net_bridge_fdb_entry *fdb,
 			     unsigned long action, const void *ctx)
 {
-	const struct net_bridge_port *p = READ_ONCE(fdb->dst);
 	struct switchdev_notifier_fdb_info item;
 	int err;
 
-	item.addr = fdb->key.addr.addr;
-	item.vid = fdb->key.vlan_id;
-	item.added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
-	item.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags);
-	item.is_local = test_bit(BR_FDB_LOCAL, &fdb->flags);
-	item.info.dev = (!p || item.is_local) ? br->dev : p->dev;
-	item.info.ctx = ctx;
+	br_switchdev_fdb_populate(br, &item, fdb, ctx);
 
 	err = nb->notifier_call(nb, action, &item);
 	return notifier_to_errno(err);
-- 
2.25.1

