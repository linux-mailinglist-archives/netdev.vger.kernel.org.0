Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED983EBFE8
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 04:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237200AbhHNCvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 22:51:09 -0400
Received: from mail-bn1nam07on2106.outbound.protection.outlook.com ([40.107.212.106]:65089
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236771AbhHNCuy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 22:50:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N0ABKt7gvCnoA0dSMkShzgBv9Zz0mdqHphmjsMfRua6hx3r0Z5UiGZVc5SpVwm1+h8iu6zVihjoTik5elO8Ax3wU0yNtlyWpbcDynuH1XoCO0Y+IGpYVCKBuFwqqJ/GJ14uFYPnqf9Os6lac2tZ5pmgQiY0CN5bpavXAqGh3iVJV6VqEeZWTvLejghmypo1mR83JCsDp53SoN8WCkCUKZA+HUq+R6Ew8/Z5goqn7ABft7c/0iC43yv3PtObnVyIVS7yz7KLcPKNjMeBanHIL/207xU0B2FVAVoqUO0dzoCGjrDDQqFCyTq9aJLFlyyAr8ZLWI4JMhFlWNfXlobJkBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=69gWLfAnB4g7iCvGnjzIm/xSoRnOBjRhTEx0QX+M4FY=;
 b=hostB5NLpNHVD20EInIgihAOlQ6btIYC9xcywahDndPVN5mdgBqezqhsdHvT/DSH7K78xD9RHFOq9cHmjrgflDjkfw0h3vbsC4SkYotghUKHAYuRvcPho6SnLMfyVsxm7JCBz1qwTwY41RGXyDb7URwd4wgDH2GWRobRAgGWsl/HoKyVNOTk5No0MjHr0RYdv9mU9RAxg0s1H1Q3NhwsBKNncnq87cTxtUJw0h/bJSOb87ROI6tOXeHDgw1QYerFBxPOaa+hBdAKD7oUium8VnGY7ij+Ni8KwqAiK4iopaYW76oECp/5ArEIBpW5w6N7mWFBHyex7cUUCEYv5OrMnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=69gWLfAnB4g7iCvGnjzIm/xSoRnOBjRhTEx0QX+M4FY=;
 b=BD8J1BqQalRkccVJ/+zUhooHqs0w9vbc/UOu453AN9g+dfokenAhKYi5XfTYMyHfzFr2IF4Hi50bvuwJprJEq/JIIak7BOxsRcyu2zqj4wCOxwoDtUGWrOTHXtVLOXSXb/DUgyemlcFddwht5SrTHcghlveem5ZI8cmlsHfu5WY=
Authentication-Results: in-advantage.com; dkim=none (message not signed)
 header.d=none;in-advantage.com; dmarc=none action=none
 header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB2030.namprd10.prod.outlook.com
 (2603:10b6:300:10d::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Sat, 14 Aug
 2021 02:50:20 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d%3]) with mapi id 15.20.4415.019; Sat, 14 Aug 2021
 02:50:20 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     colin.foster@in-advantage.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v3 net-next 07/10] net: mscc: ocelot: expose ocelot wm functions
Date:   Fri, 13 Aug 2021 19:50:00 -0700
Message-Id: <20210814025003.2449143-8-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210814025003.2449143-1-colin.foster@in-advantage.com>
References: <20210814025003.2449143-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4P221CA0007.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::12) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.185.175.147) by MW4P221CA0007.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Sat, 14 Aug 2021 02:50:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b81e6519-99d4-463a-83cf-08d95ece411e
X-MS-TrafficTypeDiagnostic: MWHPR10MB2030:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB203056FE35C431850B9A8672A4FB9@MWHPR10MB2030.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8uldhPLIY+QKgCbGSRPEQ0g3H5mHnkZwW9cgsqFHqVb5hRldBodL256d1eRA2LUABAODBSBF/c1O0Xfp9HpFpRYzsdIYel88w0Cesxd5hwtKN7S3458DadZMJTo9e5YpYuN6Ns+diq/hcWt09W0Yecx7s9WQqAbrhboKT/Oex/STX756UZcAfElDPwQHNAmY2JMlXGwJF0fgc4rQsIZd51/kkRLpJlxNOUsjRfBZcwEYQKgKa7LRf7D2POrgrr6PGdqkXusLnFLWMz8Qj227SPVP0p5PHmpoj1Dqr9E+tM8wXHYE5WggFLh/vaumvbW2+QUBz0y0wFgrM3gmdYjwvUs8SqKkN20OgzkjKy02CkS2smPpDUiKk1p2blS58EF60kTKdHSHNMacNHyJNDsXPRCwg9tY6HMj8ud50LjjnKSGDihXtIxBL9GTPR6Vd0zGHhq36yVlG7EjxHwmkniONGw4YtNouj+RNjvO2wMZjq7Xzv3pVRgS2aDOo1tGXULPoMSnht3iuyvO2UHdXU+XX5y+8XEhQl8jwHro/KLfrUEoimSrXTKaU/4sCK0Q/44GHzOk2Smsywl/lTPY6XhWTbKhawMI36ijwm2uWqURCvvplVbAktFh1GHmIUbF/vhjySeVXBQN0Z69uLp5IvrWePpznpD5norSCbzRZg59mDb018BKsmtXJpATOrETE55gjVxb6HiiZTt5SB31YJm5ixp6BqgeKerMeL6bY9GMiP8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(346002)(39830400003)(136003)(376002)(186003)(5660300002)(316002)(4326008)(8936002)(6486002)(2906002)(52116002)(66476007)(66556008)(44832011)(956004)(2616005)(66946007)(1076003)(921005)(36756003)(83380400001)(38100700002)(38350700002)(6512007)(6506007)(26005)(478600001)(8676002)(86362001)(6666004)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vfC+3UMnPSLOYf+0nOb/dPXhi/MHWJQaw2ONewoSAg64eRV2AUQAbUL1cmJ5?=
 =?us-ascii?Q?XLbl3jP+PI7xJZ2xIV0FiP7Cp8GEH2g8cgh/0t3O5zsf2mH0BC+7UnRbuvEl?=
 =?us-ascii?Q?qjamY0FcyNMFZT4UrdP9oVZxgKn1+/E5JLb79ys6CqIXbAtO6BDFbjP+nCig?=
 =?us-ascii?Q?06/5nUFk1b7oBAB6GAxyzbn2Uji4v3IO6RYVyCmHVCCti1/A/qNK1MmAEiS4?=
 =?us-ascii?Q?L4Ictuhrf4FMjRGFJWar+5a9Yt1UigSHxsnWmfYJA4frEdUqL7tGjaZWuwAj?=
 =?us-ascii?Q?+vYLKOl2eruTwMbE9esMtnbF3UYgdUoumARKGRQujK8Zzha6vb8B2QVbtw8c?=
 =?us-ascii?Q?cICP35RaLCZQc7XcNDTQSs8v+SwOQFZ6wUUUo1WhE4Iy4YZCqpVPwKrLqo1/?=
 =?us-ascii?Q?+iYuRfyl0H1zmTp5vBET/cvwGW3AIL0AsxzCBHH9hh4qWDT15gtHeo+4ibFo?=
 =?us-ascii?Q?NlAUFuUZvQCl5Zio7M5T9dukuG7l3rL4QUu0NcuH8VIj/U9iUDCkd5sxKvO/?=
 =?us-ascii?Q?VV4QV/2v4xhksmBngkpzvAZzaS6aUs7QfnRY7jelKQ2ksrhzkXGCkXB6AIVO?=
 =?us-ascii?Q?XioQjFgMcUvHL50UZxR423gmgZMtMGKhCKcxQxzzILGrjZZ5i5ri0uuHIkGl?=
 =?us-ascii?Q?wAvhyneKPJDYqAiyqlxsgB+oaLQdDfpuQFQmuFp8HepOAzJQdyz5+GzCPyMx?=
 =?us-ascii?Q?gB8HtkCLy9FA2AajblU86o3AYpWOsKGSAWMyqJmcjdsbrcmIu59DCqT3/t9M?=
 =?us-ascii?Q?KXNizGPp5q1Zxo6OdH/hTlcvbHUuQZSxchO0dtqCGTVr+kGiXnW5RxSR+QsW?=
 =?us-ascii?Q?Z/loHU0l5cz9+btXzf4ci/zmeUErNHxIJSMsSgGC3zzcnWcZkq/GbtyA34xX?=
 =?us-ascii?Q?bUBKFbMEZ5ApdUr46mw1etJzQ3n0wuLBfI1QB9cPAUcG1Y/QeKMXdcOPrvI2?=
 =?us-ascii?Q?blojvWtVERIQUVxZCpsryT0YiYfOGWUa2hI/Mu5pITgN2AkBfJrnRoNK+d7b?=
 =?us-ascii?Q?OQq3vXRFs6Yd14j5IkmzcwC1fzm0si9LDD+yf4lM1I1lSs3uZgXnsztB3neP?=
 =?us-ascii?Q?I+4HwjPxw9QsA25IaYzND0XnHnO2QrrrnHbI74sB+UndQFw4yYw8pkcPm/Ni?=
 =?us-ascii?Q?Vdv53vHDJV/6RQYyc8d1POxK33JnXb9BFViSZ0Urifzn3Qb1BbSEiUjj2bH9?=
 =?us-ascii?Q?HF+2NNNen8z3Oq/70ngbrnzsQUCJDft9VdOu7arE4ZT+r73F4LbcQwftkRCZ?=
 =?us-ascii?Q?V13/6yAixWZrZKhMbyrCdp4DUOVO1SZ8GN6BSLRGPY0B91qjyJAk+rSd0R7P?=
 =?us-ascii?Q?HbYFrXfK9M7TlcgLdu20QZv6?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b81e6519-99d4-463a-83cf-08d95ece411e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2021 02:50:20.2586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g7B5hho4Y38WSdpUGCdjkK0DZQEy44kLOQvepS1Th1CktClKKt555/PtiKdBtpBPMBa97syIHNVtBNlULh5lMJEMNxHq8/NMDZy8+sH+MhU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB2030
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose ocelot_wm functions so they can be shared with other drivers.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/ethernet/mscc/Makefile         |  1 +
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 28 ----------------
 drivers/net/ethernet/mscc/ocelot_wm.c      | 39 ++++++++++++++++++++++
 include/soc/mscc/ocelot.h                  |  5 +++
 4 files changed, 45 insertions(+), 28 deletions(-)
 create mode 100644 drivers/net/ethernet/mscc/ocelot_wm.c

diff --git a/drivers/net/ethernet/mscc/Makefile b/drivers/net/ethernet/mscc/Makefile
index d539a231a478..4ea9ecdfa60c 100644
--- a/drivers/net/ethernet/mscc/Makefile
+++ b/drivers/net/ethernet/mscc/Makefile
@@ -8,6 +8,7 @@ mscc_ocelot_switch_lib-y := \
 	ocelot_flower.o \
 	ocelot_ptp.o \
 	ocelot_regs.o \
+	ocelot_wm.o \
 	ocelot_devlink.o
 mscc_ocelot_switch_lib-$(CONFIG_BRIDGE_MRP) += ocelot_mrp.o
 obj-$(CONFIG_MSCC_OCELOT_SWITCH) += mscc_ocelot.o
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index ef1bf24f51b5..6e58f95a8dad 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -302,34 +302,6 @@ static int ocelot_reset(struct ocelot *ocelot)
 	return 0;
 }
 
-/* Watermark encode
- * Bit 8:   Unit; 0:1, 1:16
- * Bit 7-0: Value to be multiplied with unit
- */
-static u16 ocelot_wm_enc(u16 value)
-{
-	WARN_ON(value >= 16 * BIT(8));
-
-	if (value >= BIT(8))
-		return BIT(8) | (value / 16);
-
-	return value;
-}
-
-static u16 ocelot_wm_dec(u16 wm)
-{
-	if (wm & BIT(8))
-		return (wm & GENMASK(7, 0)) * 16;
-
-	return wm;
-}
-
-static void ocelot_wm_stat(u32 val, u32 *inuse, u32 *maxuse)
-{
-	*inuse = (val & GENMASK(23, 12)) >> 12;
-	*maxuse = val & GENMASK(11, 0);
-}
-
 static const struct ocelot_ops ocelot_ops = {
 	.reset			= ocelot_reset,
 	.wm_enc			= ocelot_wm_enc,
diff --git a/drivers/net/ethernet/mscc/ocelot_wm.c b/drivers/net/ethernet/mscc/ocelot_wm.c
new file mode 100644
index 000000000000..b21315b7b7f2
--- /dev/null
+++ b/drivers/net/ethernet/mscc/ocelot_wm.c
@@ -0,0 +1,39 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/*
+ * Microsemi Ocelot Switch driver
+ *
+ * Copyright (c) 2017 Microsemi Corporation
+ */
+
+#include "ocelot.h"
+
+/* Watermark encode
+ * Bit 8:   Unit; 0:1, 1:16
+ * Bit 7-0: Value to be multiplied with unit
+ */
+u16 ocelot_wm_enc(u16 value)
+{
+	WARN_ON(value >= 16 * BIT(8));
+
+	if (value >= BIT(8))
+		return BIT(8) | (value / 16);
+
+	return value;
+}
+EXPORT_SYMBOL(ocelot_wm_enc);
+
+u16 ocelot_wm_dec(u16 wm)
+{
+	if (wm & BIT(8))
+		return (wm & GENMASK(7, 0)) * 16;
+
+	return wm;
+}
+EXPORT_SYMBOL(ocelot_wm_dec);
+
+void ocelot_wm_stat(u32 val, u32 *inuse, u32 *maxuse)
+{
+	*inuse = (val & GENMASK(23, 12)) >> 12;
+	*maxuse = val & GENMASK(11, 0);
+}
+EXPORT_SYMBOL(ocelot_wm_stat);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 2f5ce4d4fdbf..ff6e65a266d6 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -797,6 +797,11 @@ void ocelot_deinit(struct ocelot *ocelot);
 void ocelot_init_port(struct ocelot *ocelot, int port);
 void ocelot_deinit_port(struct ocelot *ocelot, int port);
 
+/* Watermark interface */
+u16 ocelot_wm_enc(u16 value);
+u16 ocelot_wm_dec(u16 wm);
+void ocelot_wm_stat(u32 val, u32 *inuse, u32 *maxuse);
+
 /* DSA callbacks */
 void ocelot_port_enable(struct ocelot *ocelot, int port,
 			struct phy_device *phy);
-- 
2.25.1

