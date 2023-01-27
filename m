Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA2ED67EE5C
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 20:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231769AbjA0Tj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 14:39:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjA0Tiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 14:38:54 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20724.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::724])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E57BF757A9;
        Fri, 27 Jan 2023 11:38:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OPyaFhpu7RHT6Ky7JNFtnyI2yRLsvjCzIHVSslpOmsWZ7d/N8KxOVWRhVQHl8DFK1boIjJT+4XOKcyUM7khtQ9xBwSgn5SnVSaMNoF9Xb1aM7vYEJX3txdmltbl27GmpqOk2dXxeANStSHC2bsZgKTPCUHeW7pl2m8tyjgB9piCAosC6r9V70jc4rOqMxQGoSXCclvyf/5eb8KSYaeBgbP5kHMYKzYBhbRjp0WLKlSmqg9gR7Fh2NfLIsRrz7TFVImyR351OYgMsCkmVVryI+CC6qXEE2RSvqFxHrVOtifcp6QyUIlG+1L2PKqhW0/IxqCJZQPx2DqAp217nZPRDkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CkyMqF4Bc7NMOZIfxwd+ykscnIFJwIuugmuhyzXKYoA=;
 b=bSFLo2OqPJ05zxTBU1zcKNpeQnOBpYtKZ/GGmUqxL3IA8yAJlLxbIQ18YHrT28cYMWi81mVgsGQY2gZ7LWG9Pv8uGxUerqj2l6Th2O9psOuv5EkKLeRT4mHO+RtpkjPNWsLdxIOvAvG5CvNdjEqgNv12OcWIjOvXbSNh/uREGg6TtffNrfx5DXyHpG+prcITVwJqa8NThVLWGZTgj04WvmCChAlPC+xiQD/FuCYEuQLVExRbcCSr40yPw7vGixRMYLD2wPO3A3LUhQwMqj9JfGL3bxufkLh/4LKtwqgH6UvpH7kKcB37OY9QuK+sp0ZrfmlWH7wZpTeymyWyJrAhvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CkyMqF4Bc7NMOZIfxwd+ykscnIFJwIuugmuhyzXKYoA=;
 b=w9r/3oUP9KyGNgbvTybtii5Qw+8YV79NWWidgGuEM3CNeMmI1B7uZUC9DHJ519lcWht6FyXI+TmxP0xnReyHlwtgCkDIKNcQ8Q07KdN6PD2kLqzGjE782qehLtiWEXx/tpa8RJ9vGgH37QmqIigsdElzB+j9smUD1JePRxhNb5c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com (2603:10b6:4:2d::31)
 by SA2PR10MB4636.namprd10.prod.outlook.com (2603:10b6:806:11e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.13; Fri, 27 Jan
 2023 19:36:33 +0000
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::221:4186:6ea3:9097]) by DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::221:4186:6ea3:9097%7]) with mapi id 15.20.6064.010; Fri, 27 Jan 2023
 19:36:33 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>
Subject: [PATCH v5 net-next 13/13] mfd: ocelot: add external ocelot switch control
Date:   Fri, 27 Jan 2023 11:35:59 -0800
Message-Id: <20230127193559.1001051-14-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230127193559.1001051-1-colin.foster@in-advantage.com>
References: <20230127193559.1001051-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::24) To DM5PR1001MB2345.namprd10.prod.outlook.com
 (2603:10b6:4:2d::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2345:EE_|SA2PR10MB4636:EE_
X-MS-Office365-Filtering-Correlation-Id: ccda9539-c093-41ef-b0da-08db009dcc04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h4JIcBEVGj+QmgK3RW7Q35FzUyLhlT+YpM+LOSo7veMYBeaApaOixIxCnRzGLddG45WiXlb7EprTNGTz1BYLWe3HN2YvnVL6POP03L+g0VeIPFHgHcVXO0dt0qytsLKyfQmNgY2Qdb+QUQZQlA37GLh9HkFOZNpWdx6HXNOE82PKr9bTssLE+ms/TslBHhbm9qO4YEcr//gcK4QKOyx+hEg5ADLBqnZgsrRarwFtC52g/UGegE2dDsf5QdNB4erPHQZTAgyWHC5DrC0443A90599dZYuwCcYvqnGnS6hKgdk90UpSiEisnQVV2QH643COP5GUg4LInQJ4vRtj3B6mw6ubxkyY23DChTjSspmz0p1ld0pTwHb+Yl0QRwaH42ZuDEzpLzB1UOrrTawXvnet2eEGJiqxIKbDJlkt1dlmMes+tJ1K5N3dGEY0uwRpyU9fTazoqD1YQEa5ATmYk7G1XVd0vlJiS95FLi/jFDYQQe1cR9Utja+gni753IULOcAneb4m1qaRjvE9R5zMq83QTg9ic8aArY3lX8/MMtnB0jZpm52Lxltz/Qsw6vbOv4+1o55qefBxlNsPXtipGRTw8rxk64U5wdbLlTVif3YsUB0LUhXZ9va32S4RB2Y4bw/GJaWQILzijc8pBG0JPKLT8UM8ij3bKOkOX9bjF8ifJsbxgcaFqJGSyeNrwZlDN7QbPDjkLlEid8BeEegndPD2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2345.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(39840400004)(396003)(346002)(366004)(451199018)(36756003)(86362001)(2906002)(2616005)(6512007)(26005)(186003)(66946007)(66556008)(8676002)(4326008)(66476007)(52116002)(316002)(54906003)(6666004)(1076003)(6506007)(6486002)(478600001)(38350700002)(38100700002)(5660300002)(44832011)(41300700001)(7416002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ld4bWvPTNQGcBZR5rnzV8KJh7xinSZxXbV02IVYb3AybjpJwEGAKgTgwLz51?=
 =?us-ascii?Q?gBE5H14unAmiIXIdLAOcmITGQZgmXLLnL5A44OFzxtHYBYx/THOIjxePbUoE?=
 =?us-ascii?Q?TYnZoyXaWe/90BYi4+Fspfvhqhj7H51653joEae7Ih2L75Zrhz9sdqyX0fCt?=
 =?us-ascii?Q?JsNM9qd34a20CjP1ksJr5uIHZIMl+Gcw5UkUO0A6FfF8kSrdK2rr7MM65R9h?=
 =?us-ascii?Q?hi7qG8YYm3pbYNyf+Q6p/XkXZqDv1U6hULyaOmch9YBY81iq9+okLGJSTNWR?=
 =?us-ascii?Q?svF7qQ72unIM0fmSdUDHWsug3Oxjxip5Y+aF7XXkQZjeSLNnJgvVbvfh9kt6?=
 =?us-ascii?Q?sfnt7Th7O9PxVSmJ3iwg8LqUei8DjLyY8oa4FB2QEtZznAoKlAcaPgCpXGno?=
 =?us-ascii?Q?rjkkrtmgSmqxMDRSLArvilP+pZ75IpCb/zAFjZ24dcR81OpNulF+RcAZyz3/?=
 =?us-ascii?Q?26ucemt4hxFnJQJ+FBFhbvd6Gr150KTqKEiZzAUIkWmfx+Q29QllSQg9icjp?=
 =?us-ascii?Q?VEp0m5WkRNkg5FQDrHo3SZ/Y5GsG17duQW6PN9K7p4M7PSBR8PcZYAGF2k+2?=
 =?us-ascii?Q?lHavDl8E5cKQ30dzdV9t65APw+Sc9tyjnOMvnpi5T7zfw9KkODy2nDPlxzXk?=
 =?us-ascii?Q?RuYraG5fT+20JEUSe3LX0vKU12KDL0xZWThe+HpI5msVhVmJEm251zJS9wkO?=
 =?us-ascii?Q?x/A2Xy0ubP0buR+gUAvL3RL5Xjr4dui/9zls+xwlZ52+gbxhkrI+8bTeGsfR?=
 =?us-ascii?Q?z5gPyll4F2g7cphVRedmlOF1eY7pRkrADYQT8Q5xbKeLGtUTRBXwLi0ZGLl3?=
 =?us-ascii?Q?4IswvvWzuXHNzrDHGssDCWCFIsFQR2dL1ZKmtodn1wqJj7KG7YneoeKB/vEY?=
 =?us-ascii?Q?YYEswDrOWObjDnlugWIF4Z4RhdZDNKSn3DZBINOR35m72RYZxpuUO6yQOF2y?=
 =?us-ascii?Q?KJZfKEDMMawDLvDE2ORB9IBmaMpUEVRtJaJXm0FaDWxnfZL4rerWbwnBFhS0?=
 =?us-ascii?Q?vPCYAJnPIFKdSuiNzpSBs8IEotiZ60POMzvYBNcFlIUYChrC7veO91q/MoBC?=
 =?us-ascii?Q?byjstV1VRrnLqpA2EiT67t+d51nsizGU718ady/oerzkjBvifJ644QRypfTC?=
 =?us-ascii?Q?gLvPCbgrcsiTFuVMhc+dJnOIqXwCqvwKxftwWItzCwE7ZlPH2a3u9SbbXEwo?=
 =?us-ascii?Q?T48JM+VHQ5kx3bNehdkymbJ2tgRvLb13DMBW1GxqgrgOTKUOx9ww5VONexJJ?=
 =?us-ascii?Q?MJ0yoFD+uv0H1aKcUM1rVUv1lj77HAdMKW/9uT9tAtqF9ewOt9Yxkrzkw3Nf?=
 =?us-ascii?Q?FHybcsEkSIkK4aLilqKtS1orA/dLpgVKkor1L9PE6er3wYqhAd+U2R9FU5Jt?=
 =?us-ascii?Q?4+rZKD6TNYhQWoR62EIGIYU7SikWNe78Wj8MKFfbhu1tmIpHMC6lXnOC0EM6?=
 =?us-ascii?Q?XSS/2H+WVWgSqiIMj6LD9PEXOQNBjrNxfsNOCCaD+4n9rcbbdCm/Mhu3bitS?=
 =?us-ascii?Q?+7disEAb2bGuZ35hikt5PZLPPIjQ+2hfov7o+0jZdSTZ6/+D/9NfEESPwvP3?=
 =?us-ascii?Q?vxml7P+5sGhgtUD7x97bJXl7yDFY+CgD4HYmA9WOQvMZCsa1lxqD1KXFsOiD?=
 =?us-ascii?Q?A7AtDAIEx1Uc8dtezuf7H+4=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccda9539-c093-41ef-b0da-08db009dcc04
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2345.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 19:36:33.7344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9HfBQfpzu4BlakstwQMluHRcKXXbyCMFLJ0CL7N5Sxuj9lOACBhxdR4BPvbsUSj01HxN0IP9GMhLRRzK++kziGOL63oGbJFpXCI5V8hHBtw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4636
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Utilize the existing ocelot MFD interface to add switch functionality to
the Microsemi VSC7512 chip.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Acked-for-MFD-by: Lee Jones <lee@kernel.org>
---

v5
    * Add Acked-for-MFD Lee tag
    * Remove OCELOT_REG_NAME_ macros

v4
    * Integrate a different patch, so now this one
      - Adds the resources during this patch. Previouisly this
        was done in a separate patch
      - Utilize the standard {,num_}resources initializer

v3
    * No change

v2
    * New patch, broken out from a previous one

---
 drivers/mfd/ocelot-core.c | 60 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
index 013e83173062..b0ff05c1759f 100644
--- a/drivers/mfd/ocelot-core.c
+++ b/drivers/mfd/ocelot-core.c
@@ -45,6 +45,39 @@
 #define VSC7512_SIO_CTRL_RES_START	0x710700f8
 #define VSC7512_SIO_CTRL_RES_SIZE	0x00000100
 
+#define VSC7512_ANA_RES_START		0x71880000
+#define VSC7512_ANA_RES_SIZE		0x00010000
+
+#define VSC7512_QS_RES_START		0x71080000
+#define VSC7512_QS_RES_SIZE		0x00000100
+
+#define VSC7512_QSYS_RES_START		0x71800000
+#define VSC7512_QSYS_RES_SIZE		0x00200000
+
+#define VSC7512_REW_RES_START		0x71030000
+#define VSC7512_REW_RES_SIZE		0x00010000
+
+#define VSC7512_SYS_RES_START		0x71010000
+#define VSC7512_SYS_RES_SIZE		0x00010000
+
+#define VSC7512_S0_RES_START		0x71040000
+#define VSC7512_S1_RES_START		0x71050000
+#define VSC7512_S2_RES_START		0x71060000
+#define VCAP_RES_SIZE			0x00000400
+
+#define VSC7512_PORT_0_RES_START	0x711e0000
+#define VSC7512_PORT_1_RES_START	0x711f0000
+#define VSC7512_PORT_2_RES_START	0x71200000
+#define VSC7512_PORT_3_RES_START	0x71210000
+#define VSC7512_PORT_4_RES_START	0x71220000
+#define VSC7512_PORT_5_RES_START	0x71230000
+#define VSC7512_PORT_6_RES_START	0x71240000
+#define VSC7512_PORT_7_RES_START	0x71250000
+#define VSC7512_PORT_8_RES_START	0x71260000
+#define VSC7512_PORT_9_RES_START	0x71270000
+#define VSC7512_PORT_10_RES_START	0x71280000
+#define VSC7512_PORT_RES_SIZE		0x00010000
+
 #define VSC7512_GCB_RST_SLEEP_US	100
 #define VSC7512_GCB_RST_TIMEOUT_US	100000
 
@@ -96,6 +129,28 @@ static const struct resource vsc7512_sgpio_resources[] = {
 	DEFINE_RES_REG_NAMED(VSC7512_SIO_CTRL_RES_START, VSC7512_SIO_CTRL_RES_SIZE, "gcb_sio"),
 };
 
+static const struct resource vsc7512_switch_resources[] = {
+	DEFINE_RES_REG_NAMED(VSC7512_ANA_RES_START, VSC7512_ANA_RES_SIZE, "ana"),
+	DEFINE_RES_REG_NAMED(VSC7512_QS_RES_START, VSC7512_QS_RES_SIZE, "qs"),
+	DEFINE_RES_REG_NAMED(VSC7512_QSYS_RES_START, VSC7512_QSYS_RES_SIZE, "qsys"),
+	DEFINE_RES_REG_NAMED(VSC7512_REW_RES_START, VSC7512_REW_RES_SIZE, "rew"),
+	DEFINE_RES_REG_NAMED(VSC7512_SYS_RES_START, VSC7512_SYS_RES_SIZE, "sys"),
+	DEFINE_RES_REG_NAMED(VSC7512_S0_RES_START, VCAP_RES_SIZE, "s0"),
+	DEFINE_RES_REG_NAMED(VSC7512_S1_RES_START, VCAP_RES_SIZE, "s1"),
+	DEFINE_RES_REG_NAMED(VSC7512_S2_RES_START, VCAP_RES_SIZE, "s2"),
+	DEFINE_RES_REG_NAMED(VSC7512_PORT_0_RES_START, VSC7512_PORT_RES_SIZE, "port0"),
+	DEFINE_RES_REG_NAMED(VSC7512_PORT_1_RES_START, VSC7512_PORT_RES_SIZE, "port1"),
+	DEFINE_RES_REG_NAMED(VSC7512_PORT_2_RES_START, VSC7512_PORT_RES_SIZE, "port2"),
+	DEFINE_RES_REG_NAMED(VSC7512_PORT_3_RES_START, VSC7512_PORT_RES_SIZE, "port3"),
+	DEFINE_RES_REG_NAMED(VSC7512_PORT_4_RES_START, VSC7512_PORT_RES_SIZE, "port4"),
+	DEFINE_RES_REG_NAMED(VSC7512_PORT_5_RES_START, VSC7512_PORT_RES_SIZE, "port5"),
+	DEFINE_RES_REG_NAMED(VSC7512_PORT_6_RES_START, VSC7512_PORT_RES_SIZE, "port6"),
+	DEFINE_RES_REG_NAMED(VSC7512_PORT_7_RES_START, VSC7512_PORT_RES_SIZE, "port7"),
+	DEFINE_RES_REG_NAMED(VSC7512_PORT_8_RES_START, VSC7512_PORT_RES_SIZE, "port8"),
+	DEFINE_RES_REG_NAMED(VSC7512_PORT_9_RES_START, VSC7512_PORT_RES_SIZE, "port9"),
+	DEFINE_RES_REG_NAMED(VSC7512_PORT_10_RES_START, VSC7512_PORT_RES_SIZE, "port10")
+};
+
 static const struct mfd_cell vsc7512_devs[] = {
 	{
 		.name = "ocelot-pinctrl",
@@ -121,6 +176,11 @@ static const struct mfd_cell vsc7512_devs[] = {
 		.use_of_reg = true,
 		.num_resources = ARRAY_SIZE(vsc7512_miim1_resources),
 		.resources = vsc7512_miim1_resources,
+	}, {
+		.name = "ocelot-switch",
+		.of_compatible = "mscc,vsc7512-switch",
+		.num_resources = ARRAY_SIZE(vsc7512_switch_resources),
+		.resources = vsc7512_switch_resources,
 	},
 };
 
-- 
2.25.1

