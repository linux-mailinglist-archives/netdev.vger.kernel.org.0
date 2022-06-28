Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 297F055E972
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347398AbiF1Ow6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 10:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347381AbiF1Ow5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 10:52:57 -0400
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30049.outbound.protection.outlook.com [40.107.3.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FA6832062;
        Tue, 28 Jun 2022 07:52:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XQZHigmldVJEcr+qkP1apkUIOz4kX7X52CO4m0APHdVRIDZUr01WJDjMXupz8FHwg48EVGiI3P4v3QE8frtJiUSnpunb3eGH1VSYzVr3Sb+g3bvte0UqzkMoidW2JuzjKgMJIwRg9VD2wfVpUOT/AGxFWX+A6JIliLvQ0SQIwzupFID+bRC8LyPi+piADEVEGKRvowRR4gI/uF/E19yipmAFN5oQYc/4g031Y1ZXyBMUHqkT1u1TJIuKfNqdqm48Rh/MgZKr8qXp2fJ6AKoEs1tDZuJCpLuVjYNlnYcblebqf/iM79CNRu1nYuI+V49k37RryHonJROpTK+HD7gzgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tW3YVwfaQ6p7S8rFYbrMLcidiVZurAYL5jC3TpLXvxw=;
 b=oI7DU/qTD2JusfWR/ywZzmXMFvw6Z2/pKhM3W/Bz48q/acA/+SrlUNxtWaUObVt8wbTAKkVHmhsusG2gE6Vl8q5jAEfXglAqPYlapFvMrIBbX2yLIZ29PKaZeBE761k805mH6JetMJOM9zZgJ8Z+FlqOd4hxuE3y6pGuW/YtjzH/re+Kru++X/GaXM4xpQIj5xCMqbN01PQ4HyeaJfujsMvtTp/SgcFnVaVGJgguuIjFaxGDaIb05qLHgBVgYPNjZbK6SC8cUXlZMDyT0hQdzsvVCRq7dTsmBE7JHkXStbonGz7p85JEcj2bxaaclAAEc/2FY/rt/fO4h9dK7d3MIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tW3YVwfaQ6p7S8rFYbrMLcidiVZurAYL5jC3TpLXvxw=;
 b=Q5M4hA5/DzWu7hXGUz0nX9WgS6L/pKXROcHF+Aw7M7JjWK09+7eO9nKqHc3NA9wQjwt/6K5R2V6srL7ylGKtC/2JjS+voiNfyh6JRtlSCYXCleQzGYr9DVFnh9o9dAynBJDbYOTGAbV+lgl7HTfmWHX419zZjbCTq9oMmgGBpW4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR0402MB3810.eurprd04.prod.outlook.com (2603:10a6:208:e::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 14:52:54 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea%7]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 14:52:54 +0000
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
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 1/4] net: dsa: felix: keep reference on entire tc-taprio config
Date:   Tue, 28 Jun 2022 17:52:35 +0300
Message-Id: <20220628145238.3247853-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220628145238.3247853-1-vladimir.oltean@nxp.com>
References: <20220628145238.3247853-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0104.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c3::8) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2b9409f-1ec7-442d-8daf-08da5915e184
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3810:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1ZQ2kBJPx8pl/mkQsWSjQRKRZlSJx/rjyWzgb/ojc4ly7xVCfC9el0Ly1zD4Es0yd2aLbHgmdjwI3rzerBWlykrkKLRBtW7ZnrItoV1FDYM6KPcTjzaX3FpMsu4BP4rQBquySTARLpupVH0LCZ69at5Ttk2a99erCAFHmz5ZGc1MmqE5JtBdthoKcoEaszibJI3MPqhfYQP7HxY41NDo4k91RN9E06FbuEksV94P1hwKfEawqCKp2/xt2ncj3JfGkLiSsKq2EVUJ2ecV5F0jeDUO4FHknItsPOWPwSCAAJHOtldfxuTfpbOe3aon7S5cBCqXx4Nj7XJZqq6VLzJ897+XzghoAyCJojlElidcXcbX4FKUotABmosIIx0a8/qxeOEz5RyuoXj2uvcO7PIIgg40o5qqb6nW/ZdN7SeHb3csZ+CPZd1Kl02VrTmTyVnk1EVYLfCuUmTINyFogEBJGtUPoEOs5I2+tfL+qw31Nwejt90Rl7StPBkrABsVQY5P0ObP5RGyVVCFC9nrx5cQnUHJBcFDQ8ObFCMe8zabqA1QO76zxvyA0JMZ730q2UrV+ujIMBh4V953YS/AXVM075uOSYRM3U42tLvsXPbavk27CRruNcUiOHaZONyWpwDv1aFTYDFfTg8NGDPlEMFPRFo32zciXK+qqPwLTu72SQeWolq9Zo9SYcID95XVcdukp6IJZEbNlVdBRzTDP6/X+5JdNXMU5riKV2xvAMi5ail0Pyd2tmUhtg2xxEVNXKlgOb+3f8GQ9m0mgvB72oPyj7O69MErQjvfUH8iPuEpHQw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(346002)(396003)(376002)(39860400002)(2616005)(38350700002)(38100700002)(41300700001)(54906003)(316002)(7416002)(44832011)(1076003)(26005)(66946007)(66476007)(6916009)(66556008)(8676002)(36756003)(4326008)(6486002)(86362001)(6512007)(2906002)(186003)(52116002)(8936002)(6666004)(478600001)(83380400001)(5660300002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nxou2B94i2QxXo+6jmWoihpc8/61T72mgMM+8gt3Ul3iqWIC6jov5WGTufYA?=
 =?us-ascii?Q?voTwNiVDkor5jDMMdXieLaWBe+WBwR22H99OjZspyBMFh1612xtZ9Jusrepp?=
 =?us-ascii?Q?r2AVpjvI88AYJyk5BG4wK7aHulq+/0AHpX6lu4P3Ae75i8potA/bdcdTpBfy?=
 =?us-ascii?Q?ZiHW9x9S5GD8fe9kfnXmcpRhDFLrSxdCcw5uGlMebAncht0Nlf88s2YdJd9Y?=
 =?us-ascii?Q?A/Xyvd8kXfhdmmxmLmDiMz1c4lxEkDAJljK+WjJmbYd3UeFlH71VfaZJtwT+?=
 =?us-ascii?Q?vNciyb3W6PlZo4agBYvM45umxfp1XHyF64Iu54jXHVucYmmnc8fRihpMsbJs?=
 =?us-ascii?Q?joYQi82dA7MiTVZraW2DshwOv2hKlaPAJ9fJn+gYvpyOBWRS9wj2KXlmbgqd?=
 =?us-ascii?Q?CBs2Qv+WDZFHezCVgmvHd+juVBRkfPGPUhMOG6j/KMICHe/OjDKo1F1xD1Hc?=
 =?us-ascii?Q?+z8Kk07z7+MPcPrAnX5EnY4r/Wbpuei6ENA1i0RO6x9t1O+YkTJFc8sVOJSo?=
 =?us-ascii?Q?13+INW4d9l66huVsLLCKelqOGzkPWl8mYZ7FTlfRaFQTBv1SwUd2VGtD9BM/?=
 =?us-ascii?Q?CTjeX9GJSsgvgfwlcfl6N0WvVGKegjy6cKbbjlymHux2IwWQmboY6sWacPue?=
 =?us-ascii?Q?17hNVyLYla7eitXmB85RkP6GCVEnH60y8iwq/VwbZWkE0rWT995GbaORXRAT?=
 =?us-ascii?Q?Mv/dtssLmZwSM2Wi7VzX5pGH6GNVYePsUn8ZPYZqLti/ACjeIV7gBKBdLXR/?=
 =?us-ascii?Q?VUnrGRt7r5tD580QlGOOrH+X4B45k56Pn5YJLAshkJbWOIn8tUru+gQB9Ybs?=
 =?us-ascii?Q?3hZwyg0qek9vjuLpHfyuuj+sjuov+mLCN43ykGWPEA8DSQRRRjA8aGc9Ifvn?=
 =?us-ascii?Q?V184KptN3MA/SKmGGW5zCF6SRXehyuEr2F30dT6uG+6z/1gwLy1ig637mTh7?=
 =?us-ascii?Q?8TdSl1tIx5K10BmtRTVNNlSjiRg/09xjACv/+7TnceXeTtOV1L2dNOGEuENo?=
 =?us-ascii?Q?xwZPu8L/77S785roCBSLqROfBlZL/KLLxHB1LTgKiWehQdDxufTdxTFUQvQS?=
 =?us-ascii?Q?J9z0Dqb5CcVMRSak9cHOWC5L/M+XOy3pshA9pDT+ZOv0V86NgJuUelT9m8NK?=
 =?us-ascii?Q?ASCduUpiuYFis9rSFcmEJXXUWt4PVcROzdcqxeoIQKp2YsZV5r6VbIGJqxHa?=
 =?us-ascii?Q?QOIla4zBIlBDK5UrhLMU2yphy0FPbaDEwyrE21qj3Zdi7gHqC5aQJOAKQzIA?=
 =?us-ascii?Q?G66/0giooQdyhP0Fz4lTmm11CzZFIdnMeW6nG4WXz1tag8h1rjbab3GSlNGT?=
 =?us-ascii?Q?kTpxatyfJSn/+iBn4Pg1ur/S147f/+jUmOOOYv2G2FksbR9GRbMJhUsRVgYV?=
 =?us-ascii?Q?s4SQmvecmDvSrOI50+Xp3Pnu1OrGf1Gkq8+WQ+ihZr6R9Y8gslBAUEX5A+KK?=
 =?us-ascii?Q?ocf1XJWc0kN7Li8qVutJaGwzQXjCYX6Fr2ZjJ69w/pjPI7NNjlqJGkRtfy1v?=
 =?us-ascii?Q?AkHF9KTeRqjBFPrBv2Wtq0R21Gm+BcK0ve3Zu+hdgHw3+TOBkWXBhbl5a6w+?=
 =?us-ascii?Q?fEnPIvy8b38uG9X5Bvc7v8L7gVvDHMtmwZvNa1Dw8W7/95duXllfygT/IDtR?=
 =?us-ascii?Q?Dw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2b9409f-1ec7-442d-8daf-08da5915e184
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 14:52:54.0498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iSi+tpCybxq+U0kNzD5Y/lheIZek6jv5/PF3lH8bFVwjPbEdEuxHhYymJHdlO5eAEDrR/RbmNhJqhjrHFkUAsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3810
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In a future change we will need to remember the entire tc-taprio config
on all ports rather than just the base time, so use the
taprio_offload_get() helper function to replace ocelot_port->base_time
with ocelot_port->taprio.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 drivers/net/dsa/ocelot/felix_vsc9959.c | 23 +++++++++++++----------
 include/soc/mscc/ocelot.h              |  5 ++---
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index dd9085ae0922..44bbbba4d528 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1210,6 +1210,9 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
 			       QSYS_TAG_CONFIG_INIT_GATE_STATE_M,
 			       QSYS_TAG_CONFIG, port);
 
+		taprio_offload_free(ocelot_port->taprio);
+		ocelot_port->taprio = NULL;
+
 		mutex_unlock(&ocelot->tas_lock);
 		return 0;
 	}
@@ -1258,8 +1261,6 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
 		       QSYS_TAG_CONFIG_SCH_TRAFFIC_QUEUES_M,
 		       QSYS_TAG_CONFIG, port);
 
-	ocelot_port->base_time = taprio->base_time;
-
 	vsc9959_new_base_time(ocelot, taprio->base_time,
 			      taprio->cycle_time, &base_ts);
 	ocelot_write(ocelot, base_ts.tv_nsec, QSYS_PARAM_CFG_REG_1);
@@ -1282,6 +1283,10 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
 	ret = readx_poll_timeout(vsc9959_tas_read_cfg_status, ocelot, val,
 				 !(val & QSYS_TAS_PARAM_CFG_CTRL_CONFIG_CHANGE),
 				 10, 100000);
+	if (ret)
+		goto err;
+
+	ocelot_port->taprio = taprio_offload_get(taprio);
 
 err:
 	mutex_unlock(&ocelot->tas_lock);
@@ -1291,17 +1296,18 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
 
 static void vsc9959_tas_clock_adjust(struct ocelot *ocelot)
 {
+	struct tc_taprio_qopt_offload *taprio;
 	struct ocelot_port *ocelot_port;
 	struct timespec64 base_ts;
-	u64 cycletime;
 	int port;
 	u32 val;
 
 	mutex_lock(&ocelot->tas_lock);
 
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
-		val = ocelot_read_rix(ocelot, QSYS_TAG_CONFIG, port);
-		if (!(val & QSYS_TAG_CONFIG_ENABLE))
+		ocelot_port = ocelot->ports[port];
+		taprio = ocelot_port->taprio;
+		if (!taprio)
 			continue;
 
 		ocelot_rmw(ocelot,
@@ -1315,11 +1321,8 @@ static void vsc9959_tas_clock_adjust(struct ocelot *ocelot)
 			       QSYS_TAG_CONFIG_INIT_GATE_STATE_M,
 			       QSYS_TAG_CONFIG, port);
 
-		cycletime = ocelot_read(ocelot, QSYS_PARAM_CFG_REG_4);
-		ocelot_port = ocelot->ports[port];
-
-		vsc9959_new_base_time(ocelot, ocelot_port->base_time,
-				      cycletime, &base_ts);
+		vsc9959_new_base_time(ocelot, taprio->base_time,
+				      taprio->cycle_time, &base_ts);
 
 		ocelot_write(ocelot, base_ts.tv_nsec, QSYS_PARAM_CFG_REG_1);
 		ocelot_write(ocelot, lower_32_bits(base_ts.tv_sec),
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 3737570116c3..ac151ecc7f19 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -670,6 +670,8 @@ struct ocelot_port {
 	/* VLAN that untagged frames are classified to, on ingress */
 	const struct ocelot_bridge_vlan	*pvid_vlan;
 
+	struct tc_taprio_qopt_offload	*taprio;
+
 	phy_interface_t			phy_mode;
 
 	unsigned int			ptp_skbs_in_flight;
@@ -692,9 +694,6 @@ struct ocelot_port {
 	int				bridge_num;
 
 	int				speed;
-
-	/* Store the AdminBaseTime of EST fetched from userspace. */
-	s64				base_time;
 };
 
 struct ocelot {
-- 
2.25.1

