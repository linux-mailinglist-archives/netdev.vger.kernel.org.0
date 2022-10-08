Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC9855F86C2
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 20:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiJHSwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Oct 2022 14:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbiJHSwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Oct 2022 14:52:10 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2118.outbound.protection.outlook.com [40.107.94.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D423F1DA;
        Sat,  8 Oct 2022 11:52:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a45BY3daUdmjLhJLS7z9d3z4UOX8IL5rT9TlvrmPt3h6i/IlP3xRZLVPNStrGRpRHGbWWLaxzNc8J/ncDwJwiBdtD7gu+80z9vc8wYAmO6vcCRsPyNVNPrT873ZlA0pdSPEQl+TjdY3RjVJ647yMcxFKL+cow+wjiqEybP8VIXMUfStiUMZBjiqzxYz8Bgm9jT8oqRdYqeRkWxeJab+4jhfQ6KIpMRQbJUE1PZwWZd/nr3D/X+r425JV3zeJbxqU5Idyfu9JgkgXnF+lAILov3BloNR311VFsohURRN99Qg8+YIXL4UU2GsAAKIn+zfQ1ZKB+GWG3yUjMcCAkxu9xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OAo2yqRtU2ZEFfuhn1TmTcFTpyicruheyh3pV/alJbI=;
 b=kLGaFw66LC+Z0rReg98YRSZDvNI9usqDYODj8UC6ohntmlHg7XgIfEI9YCJHgJr/yGzg/f3DwYNr3ervxO6Gk4muq0SYS/gubzbfSBmsh90dR3J/NaIwNO0Fr9A/nGR7T8bIiW9WmIptyU7yrmBcTY0BSFaM5y3+Y/exeqiovY74AEamS/nxx3qvZo3jXnLQl/RXZIxqEgyR1eCOompZee9+dMWkU5sOK9PCT1MI4TIjPz/jeyP9GYuQAMMgxm27mc2HrIAoE8XGahjYs0ETlabBgRPnzchIfUjaTjz5h4Mrs7hM7aS1WR2WlVgxmIVxY22DBbkMCy/vwruyjW76kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OAo2yqRtU2ZEFfuhn1TmTcFTpyicruheyh3pV/alJbI=;
 b=CWElgqX69p9XJSjLfpOfdSd+yKtgA6UJ2IVwODH3R/2IHGT4k5Drn2tx8AnKPcb/GsRPyLN+NvahKvSEIJpLgfk+MuccceRbcROiretNSJdtB49TFxSd8qY8YNXkjHEUbb3NhgsV1Lu8Ztd9kfAe70rxlfHuSzMwfNgjFbW8jaI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH7PR10MB6129.namprd10.prod.outlook.com
 (2603:10b6:510:1f7::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.20; Sat, 8 Oct
 2022 18:52:05 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f%7]) with mapi id 15.20.5676.028; Sat, 8 Oct 2022
 18:52:05 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>
Subject: [RFC v4 net-next 03/17] net: mscc: ocelot: expose stats layout definition to be used by other drivers
Date:   Sat,  8 Oct 2022 11:51:38 -0700
Message-Id: <20221008185152.2411007-4-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221008185152.2411007-1-colin.foster@in-advantage.com>
References: <20221008185152.2411007-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0304.namprd03.prod.outlook.com
 (2603:10b6:303:dd::9) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|PH7PR10MB6129:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a140f7d-ba5d-4ee0-1290-08daa95e31a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1EsWjjbLvnzfQmlyGFIGHWhRGbvGUi1PugvzVHVOwteKzVy2GqfpO0HQEGBIRXOTIKUCRSHPmkXFc6n6VMGBZ7cMq+CocnVXJq/4ymy7e6nWkSD1W2sPFszQUcjs9toz/q0gA/r4902tCvaztKGQwtvr8/V9E1Cy/ThHCA+gI3VI56FxaFNi+HGxgQozidaoAZnEpr/HxZFEtDFbso2d7EBMoGh+x+Qf+0Krg9sVWoNRucO0wS4rRCLYQNAD/p6fbAlYJlmRXPQ3ZM8uA+8QSPtGn85ZLyh8FfgeLtgZIbebjLOeHXL21Tmlm1yejgi+eRMWveFWuWDi3TNdqLyTZX4wf2/OCVDDWrMsWoel4T4KT4xk8iRzkGyz/A14IPm1VSQ9tKB7STKyCvONh/aBED3UM2DRUy9r3vKI5RrsCM9gjJs7xMluxSHB6pbUJFhpnwTVGUhX53YdWOj04YOHGcqtzSlCgUQPKYD2SpPhXPZa9j2I0gFGJMhz4AWZ0CWNOAMwzBks6fU8QNeBw2eQ/8BFHMXkGz4leO9Q9Ke09uk+hK11ZEIva5NZfPAl1x9NyU1gR+3jZqOGzCmTcOHvrO9sc+FNE1hy185rWNH9N91DWhJ242AL974yozqgq0196cNCctZiW1kI6TIkNZcMRrfEkYZVBVzK7zo59VCS4Xgr1Nmro5AAtscAUOAnqgK+X6ojXvE+jLgRLiPzYJByjSL0pYl/+AHxQrbDLyF7sUu9z4c8oAjoQcu5GcnCRPGTO7yhJk3e1yvTxbObphAnGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39830400003)(376002)(366004)(136003)(396003)(451199015)(44832011)(186003)(6512007)(6666004)(26005)(6486002)(6506007)(2616005)(316002)(54906003)(38100700002)(38350700002)(52116002)(4326008)(86362001)(83380400001)(1076003)(478600001)(36756003)(7416002)(2906002)(41300700001)(8676002)(66476007)(8936002)(5660300002)(66946007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FTxLwquaytkF1TiFsdmUvOFJJSUdDbHCYYqiSRbCwIKaTbgIzHWNvTgNs0EP?=
 =?us-ascii?Q?ym5TOI5RE5ZB80YYWCAANfPlyEchpeEqsIO+WCDxCVZ6/V+hA8JpBxLuJE87?=
 =?us-ascii?Q?4lXMzxXSw4CpxoGSAkg3IFFQMYBaGdwu/RoiprkwaOw5cUNGWpwPW6O2XJQT?=
 =?us-ascii?Q?IomiYONnTgJocELVsHYWBgkxm76INYPdPG0fqzoqX9wF83g683dtYvtXM8nc?=
 =?us-ascii?Q?60vWD1XbLvemRLYntHiqjbo5bj4CaEqIVk+9dKFETQFjZH56cpIPqkB/+/CJ?=
 =?us-ascii?Q?Q+9Qgw5hF2O4ZUwYiOyiHo85SS9Fh9cUMmcLamRcK9Gc5zSEOLM22tX5UBgr?=
 =?us-ascii?Q?L1oTBULRAa+u+mPdqS6M1/qiAjhkq0/j7BERUF3oQyHNhgA/+5+w7cZuqV2i?=
 =?us-ascii?Q?JXYJTpVONAPKjOxiaYUfTacQt5nfw1BbBk3ufFtymGBKgZPN0d3XXGFXkxSh?=
 =?us-ascii?Q?vDX82i2XxNdaBqPNOGt+djbs2oSWjS0/ktZqTHoIpFHMHLsvZ6dR7w3tsjfz?=
 =?us-ascii?Q?SfJlGaDPAoAewghGvon24Nh4nzunk6MQkBz2dE15hrHeLebRPv0uEM+BYxsh?=
 =?us-ascii?Q?EbjrX0WdwK2Ntx2j/hK887Rmhe7jH3y5jJ0B06TF2mvQgQ/bzeUyA0bElQVD?=
 =?us-ascii?Q?fKbnaMGWlOVIf9SkXxwwWHI2mHfHzR+iKRVyPJUtTAp3kcjG9UvcpI6eQmaR?=
 =?us-ascii?Q?wNdvFaLen9cT1W8zqkpJtBIf3T53yPaPXeK+cNKfz3neTgn5b76z9ddUvdpW?=
 =?us-ascii?Q?WoGLevwEQ021injRsD2YKn9hbGuElsq2RQnDs3ElKp5C9j9ncFuYNvnJp7SI?=
 =?us-ascii?Q?U3XOOkj7rJ2l4RcGQYpNnzRHRZ8e9PcIbcvw11bpFkajSe4mkQ1ibQ/FjM0q?=
 =?us-ascii?Q?M4QWIoN3Zw4VRVJd4Ht0JLd9aT7IiWO2TTrlMp7+BehaELYUfXlPzTk6n4Dr?=
 =?us-ascii?Q?pg5WcCMy54Y2NrSu5pLgHGCOEAt+cQVWgaCsBvhY8uGZCopNvRbVqFu0MLMr?=
 =?us-ascii?Q?9U1k6XyXH8eUUSi7G2+pTjUI+73x5isE5RXAimBGI9u6sss6N2cALeYWNIoh?=
 =?us-ascii?Q?9DZJW8bCekGyQzsQgp5p8nizdtNkCHwp0F5W2iax7A/lLw57v3G75FxHWoJ3?=
 =?us-ascii?Q?u5Tcz5XXl/y8hPT6GZH0GhRv3T33tS1V6nKJMSgxs5LuRcLMXfR2s19bgP0H?=
 =?us-ascii?Q?o21tFgyA/wCrDs9ojYBIQPYnIKrmkmXuu1mmmRJkr3zjrPnENuUtPg6paWE1?=
 =?us-ascii?Q?l4HjHAGoWKOjA7n/xatdKSokoQeKKgQKJoQqoZCueKURGeRGrWci9MyDyAhD?=
 =?us-ascii?Q?Dm3+7/cai8JNbwINLowvF1EeHZVMi2xmnOs13rmvmwPsFQbVExJ2KIRztDBA?=
 =?us-ascii?Q?k93l+W9u0QXjBjpeG7WtPdsDD9XUWg9s/+K6yD7blZrjxQsG2B+/L/Gy6/Kf?=
 =?us-ascii?Q?4a6qIh2kisVEHpQbyPHugi7cotPPozsd8RhuNyc/OsCVGwCLVnZamtM4xG4T?=
 =?us-ascii?Q?e5KtHkENhDUghE/NPiT7gbv5FDhXr5zDvdgAdNsycUQxTiQBrjSuUntyYivt?=
 =?us-ascii?Q?Vj+N7PmEwW+uA7Hk9tvQIdX4j/VdZUYCubFlCYAa08udgNdOK7+HmkCM8Hqb?=
 =?us-ascii?Q?iw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a140f7d-ba5d-4ee0-1290-08daa95e31a1
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2022 18:52:05.2568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kbuotqx5cWXaq45pA7HaVPk1DAsptSQA2BwWypiBEykDddhEdQiCZ/LiimOo9Y4lulK7bHbpKI8j2FB2hBFRq8G55Xg4x2dkYO+M9O7p5dM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6129
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ocelot_stats_layout array is common between several different chips,
some of which can only be controlled externally. Export this structure so
it doesn't have to be duplicated in these other drivers.

Rename the structure as well, to follow the conventions of other shared
resources.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v2-v4
    * No change

v1 from previous RFC:
    * Utilize OCELOT_COMMON_STATS

---
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 6 +-----
 drivers/net/ethernet/mscc/vsc7514_regs.c   | 5 +++++
 include/soc/mscc/vsc7514_regs.h            | 3 +++
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 6d695375b14b..4fb525f071ac 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -42,10 +42,6 @@ static const u32 *ocelot_regmap[TARGET_MAX] = {
 	[DEV_GMII] = vsc7514_dev_gmii_regmap,
 };
 
-static const struct ocelot_stat_layout ocelot_stats_layout[OCELOT_NUM_STATS] = {
-	OCELOT_COMMON_STATS,
-};
-
 static void ocelot_pll5_init(struct ocelot *ocelot)
 {
 	/* Configure PLL5. This will need a proper CCF driver
@@ -80,7 +76,7 @@ static int ocelot_chip_init(struct ocelot *ocelot, const struct ocelot_ops *ops)
 	int ret;
 
 	ocelot->map = ocelot_regmap;
-	ocelot->stats_layout = ocelot_stats_layout;
+	ocelot->stats_layout = vsc7514_stats_layout;
 	ocelot->num_mact_rows = 1024;
 	ocelot->ops = ops;
 
diff --git a/drivers/net/ethernet/mscc/vsc7514_regs.c b/drivers/net/ethernet/mscc/vsc7514_regs.c
index 123175618251..d665522e18c6 100644
--- a/drivers/net/ethernet/mscc/vsc7514_regs.c
+++ b/drivers/net/ethernet/mscc/vsc7514_regs.c
@@ -9,6 +9,11 @@
 #include <soc/mscc/vsc7514_regs.h>
 #include "ocelot.h"
 
+const struct ocelot_stat_layout vsc7514_stats_layout[OCELOT_NUM_STATS] = {
+	OCELOT_COMMON_STATS,
+};
+EXPORT_SYMBOL(vsc7514_stats_layout);
+
 const struct reg_field vsc7514_regfields[REGFIELD_MAX] = {
 	[ANA_ADVLEARN_VLAN_CHK] = REG_FIELD(ANA_ADVLEARN, 11, 11),
 	[ANA_ADVLEARN_LEARN_MIRROR] = REG_FIELD(ANA_ADVLEARN, 0, 10),
diff --git a/include/soc/mscc/vsc7514_regs.h b/include/soc/mscc/vsc7514_regs.h
index 9b40e7d00ec5..d2b5b6b86aff 100644
--- a/include/soc/mscc/vsc7514_regs.h
+++ b/include/soc/mscc/vsc7514_regs.h
@@ -8,8 +8,11 @@
 #ifndef VSC7514_REGS_H
 #define VSC7514_REGS_H
 
+#include <soc/mscc/ocelot.h>
 #include <soc/mscc/ocelot_vcap.h>
 
+extern const struct ocelot_stat_layout vsc7514_stats_layout[];
+
 extern const struct reg_field vsc7514_regfields[REGFIELD_MAX];
 
 extern const u32 vsc7514_ana_regmap[];
-- 
2.25.1

