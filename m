Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4DD63C3665
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 21:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbhGJT3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 15:29:24 -0400
Received: from mail-bn7nam10on2107.outbound.protection.outlook.com ([40.107.92.107]:9249
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231250AbhGJT3M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Jul 2021 15:29:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JzXByueDt9zQcwhzHrV57Xs1vPmhZzDFhQGsefKousPUDhUbGP2ei/etwiD8FIoJ/5PoV61FNCCf8dD6etS7ySSIzOo3rOFQzo6KmnH5eXtjQRp+gIsOdiR41QCEmMKTmvp9lG95iC4doBq/TKez+bD5fRn1DQVHQ98lDbsJ05X+cVUlsupkX6VWidqqu+mMuWxfZPRwOPSHGnu4ZrbiPaFV51eUHsHQ/z1jApaPl/KrpWR9LgDSIh32k9qcTmW/MZR8FuMv64RziUfnJBLj1aE/awHA9aSomPonZ8qqUj8DCahrsZm1igpPdi6f30GS6de5QJNODDNoW7gNrsvZBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=djsFpEiieRGtj4ktu+HG/gTHru21HG3VhDOiWR3q+S4=;
 b=dSzwwW03zkW3+GDbRwFQlWUVADSeL4cs3tHzrqSo3OS9CvTL2B/BgLbiW1L7Ve0xCEnfA2cgrMOGjtlwLkw8K9WkZZzsKg4niqIItzqJEkBmOiPeX+Cdy5crJQ24IK5om4aMG7KqDgWyXbmMnXuaMv9Y39jyHt2z0ffO37LDTWyR6OFF0kFse9+0MxWtD6yvkTmWcj9MNfaxZ7X0ZsE5gKKidnmlctQQrJb2T5XZcEHKXF2l/h+FAQQZdzYXVJhHegxd+uNLTHmPdmx+VMQuMgy2j9WEUr+jciT2A6OLFlw/+3W27O2MFvxAn6zpi7GjtiDTG2mkEZOiGu8fHk3C7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=djsFpEiieRGtj4ktu+HG/gTHru21HG3VhDOiWR3q+S4=;
 b=biJIL/UGKjKq94sC1WkGRFtoGMg9piuJ53XPbodhuWvcuVF0fHa7pBD2EDgegEL3+kChSXfM9QNQ+5+5I6XlTaf+5BUDhJmqqbYJkkQ3jFuhHADJpuu8vYRkJXXPJCKaD4xxPXhAig9NW+3MUBVuPlBWyWawl3eABkAbk/kcKhg=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1709.namprd10.prod.outlook.com
 (2603:10b6:301:7::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.22; Sat, 10 Jul
 2021 19:26:20 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d%3]) with mapi id 15.20.4287.033; Sat, 10 Jul 2021
 19:26:20 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        linux@armlinux.org.uk
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 net-next 6/8] net: mscc: ocelot: expose ocelot wm functions
Date:   Sat, 10 Jul 2021 12:26:00 -0700
Message-Id: <20210710192602.2186370-7-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210710192602.2186370-1-colin.foster@in-advantage.com>
References: <20210710192602.2186370-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR12CA0042.namprd12.prod.outlook.com
 (2603:10b6:301:2::28) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.185.175.147) by MWHPR12CA0042.namprd12.prod.outlook.com (2603:10b6:301:2::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19 via Frontend Transport; Sat, 10 Jul 2021 19:26:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0e94c2a1-9648-41e4-853c-08d943d89882
X-MS-TrafficTypeDiagnostic: MWHPR10MB1709:
X-Microsoft-Antispam-PRVS: <MWHPR10MB170982C585C2815BF1BF0FA7A4179@MWHPR10MB1709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KaFxKc3f+NxwnZGkJTo33K6C3pzgiLKVxS9mlyqpSJSuujqYJuIoy9CBFLYA6gOkYhO+qxpVp6e2eBs51lTy7ZxxFURLj1LOo4ZULcfKgJ4sh1JyLyYYxICB+O+qRCH9TiFVPAkibvPoqKoH1yLkfuoKd09Q5wjWSnJgG0xdXU1zua5S2t86qLgh75i9xZO3VFzHeH3k4cg6RuxGiRPrR6uRZ8uCEhWc9q8DjjEUTNu2NNvdeqxnSK5i7xoXmdFToOeJ8E8M5ZYZFh7gjwZHGfBB3GjCDy31BtaSfMWpQUVEpJelZdWp1IyJ1apArr4+t0XGUQwweWheUntJWG+OLAjjq3mmldOFZE1dLSlG0R4KwOymKzc04OAI0y5sd5nrDhREaai0kTFoyjk7zL1IbW6VZAVezuMDZ0Psx8O1YASBYu5O4mqg3+0TshbnVMeyYUodV7Af9t2j9l4M6iFX9KCl0oAGe8LVLb+tU2oX8z/L4vglxpYnQ4UaOFAF1KDtmWKyMX54QbbMTXYkjEjzWPXWvg4Ky/F+gqiydtrvvX2I8PV0fopCxOVIJ0hi7SFU3zS3LQgEYYJp+gLunEx+4YWPmZ2bFFykvlZWq99RAIXUgDgVGgnl3jvKzaRv/XJl9cg9uC6sE3O+Iutze3fCtEm1qjASQweIIdyAbtjsMLewoniiNTQuRyIvSBSM5IKQMj+BAtTohJD19w5gEBbq41IcymPJ1XmW9QgAuHBjq1A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(39830400003)(136003)(366004)(8936002)(7416002)(6506007)(5660300002)(2906002)(66556008)(26005)(2616005)(8676002)(44832011)(6486002)(6512007)(66476007)(6666004)(38100700002)(38350700002)(52116002)(66946007)(921005)(4326008)(956004)(83380400001)(1076003)(316002)(36756003)(86362001)(186003)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bl4tecyLqSpT4qIYcd/hOatlfDBmjlWWm+JMV6EMAcTZBdXvuR5IMMHe3xYq?=
 =?us-ascii?Q?tWyuDFV5i4sq7Urva3UVKKL3xlAHtz0mweGq/GHzMITJ2AO1KxyIcYVmfTmz?=
 =?us-ascii?Q?E5Gh4QzuFI2+bIEojZP2JwHZTUisNuzpV955swWu6FS2OJQJ1/s5rQ56j6dO?=
 =?us-ascii?Q?YI9hZ5UxrGvlJ1Qn30zlbIbhFL3kfHgLHBfc1MRBwxxMj3bKSDOMU1aztB6w?=
 =?us-ascii?Q?6G8Z0z3eps+7bMUj7m1PKwAsgxi4n9+ryj2OqYgOTa5RsZpTrJHXu1Ow7znH?=
 =?us-ascii?Q?ofixfF7ZQJcwiCmEHwF7Mqa7hd5B/c+56n35r5mHpbFUgB3uq3t+kMncqn10?=
 =?us-ascii?Q?ZsHMwRi7zBBnh4NJPE/j4FFnow7dHr1gxHnEE0mZKd2LjiEcgZmyvBL99ug/?=
 =?us-ascii?Q?lBA9sZZQFLOsmLtB7fQJULIDIT2zhT5kj0nwI2JhDArRZYqJhl4qLR89tijp?=
 =?us-ascii?Q?2xpN5Tv3OSUCVJHyIbOEAczUvSIY8vaXGtxq6x4eDlG1QSi4uaoJXjF81s+F?=
 =?us-ascii?Q?U/b9Ci9k0BYJYVBH0yw/7aEp/Uku0YpRPFeFkZePJn+lLQIXLC+Xe3qgNhaS?=
 =?us-ascii?Q?qtN5HDQA/iGhUc/HMvzWWgK+NNVPKfnPQxBeG6EoJHOCPr6TmmJkTjXCdkah?=
 =?us-ascii?Q?urDu8lADMv/Ks5b6dG2VdkhKquO48lI908eswsSwH2C1SVyQGpDFuPeDpaHZ?=
 =?us-ascii?Q?duTA/O3uqqcperkVORufH/VhSUfw69fs3d5dxc5PUbnRNOvZFl4xqDvTH/TB?=
 =?us-ascii?Q?SFDVT/jeQpC1GvBfCuom2ENZmL8KbknB2dOvyKThHktXeuX4B5wDdcIL6k4O?=
 =?us-ascii?Q?sZqGhGX//9xBJBWquXJOTeL1ZhiBWKTrVWjdkufLmtOX3xC8vkFO2hf545Vn?=
 =?us-ascii?Q?iZEwe1ZIB5iAUnohd6dGcglNri5cHgq3gCcUEst7uDDaz58I6EvndbwYjQUh?=
 =?us-ascii?Q?bB8GN5B9e3VXY62MmSkD9rnIxr9k5+xfrGm3NbyWOQMXArB+wyGqEQU0Eu88?=
 =?us-ascii?Q?139nvtQ0IsnzXpFrvZ79PTWH/6gO/7C9Zhdr6TUNt5/LUpwKZgq2KLIH2Uqa?=
 =?us-ascii?Q?jRWTYtUdfq5suRMLnvbrUzjtIDjfEO1F4oOxyBgSOybuQbQBr/iW9NcuLY1D?=
 =?us-ascii?Q?qIrGsXi58a/nrFbLURB7Dtea/T+J7KvB5CWRpgvJPDAGDdxHJJDYTvngWJnX?=
 =?us-ascii?Q?kYy+oy3mXLRJ888alO3c45zgEZ3JpPiJvD5KTZ4WAGppI+q6O7LauAlj+jVS?=
 =?us-ascii?Q?dlVsc1hQVeF4AUPYLNhV+KYf+1gqsngDQjIMG1qFF7uULzO3VnHczyza5MKK?=
 =?us-ascii?Q?gmTl9NaoEuult7Exp3rLaNQV?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e94c2a1-9648-41e4-853c-08d943d89882
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2021 19:26:20.1802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +pHS6d+jSmlS0qc+B8go9dLkpp9goYlnbIyOS2Ezui8+InLGXKyFhAjB/1nxbN654Q6Nq+2nISvhFhiLB6QZKMjn/4gOaeosUIYBRbabH9k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1709
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose ocelot_wm functions so they can be shared with other drivers.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/ethernet/mscc/Makefile         |  1 +
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 28 ---------------
 drivers/net/ethernet/mscc/ocelot_wm.c      | 40 ++++++++++++++++++++++
 include/soc/mscc/ocelot.h                  |  5 +++
 4 files changed, 46 insertions(+), 28 deletions(-)
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
index 000000000000..f9a11a6a059d
--- /dev/null
+++ b/drivers/net/ethernet/mscc/ocelot_wm.c
@@ -0,0 +1,40 @@
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
+
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

