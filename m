Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 560C7194080
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 14:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbgCZNwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 09:52:47 -0400
Received: from mail-eopbgr60089.outbound.protection.outlook.com ([40.107.6.89]:57111
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727707AbgCZNwr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 09:52:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TM/6CMcYDHZrSA8ACkRdu4Mce8OORFb+0deNIL/6c9+CikKna2uKa2pE9y3Y1Qp2kCsOIxLumZUvccoKTQlTmAZiVeTbGWPwwa7r4iNiiIiikWPFp5rHdI9zZ/D0pBjse/VPs1nEcNF+QysNAp4omkBVTSE2yEE1EmvjdfLwA9K5Jo5J0Ql/MJMKCSdPQX2Wl/8lRXQwF3hndEu8sn96NJiSdpaHZAlUPz2nfLMollRbfsQ9J7soRekFfOVECHmsCqJa6jEuARSjpy6JbGtDK4RYiH49GnA59AvoIu1hOV4Zs4z+1N1KxV2cxibRBz93+LM6n01Pd1Pb9IBnSoYHmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P0wOW7awuHLwlx8uSLjJCqcIhR8hxr2Npy0wqXk/P7s=;
 b=NvQVgGiItra5PCFqUazxFhzRxa4Gdu3q6nRQvM4c7Oo1seve9Rx6RDfFpnG/356PiozJQ6QtWGTqCarP4rVl0r62ZjH3dcyRVffncQK7XuxfrZZDETnRa3VPeAkGh+AJrnumj9Clrioaoz0i/O7Od5NRcE2Dg9GnMAgxe5Rvle0GXoCAEXvTunPTcI071dA6LMCEOpQL6zlPQZwrIeoQVJs7Uz8wR/sShzJvQ9pr41/Yl9aOUM69iB5b/yNFYXqpMqjam2aQPFg6bHrIIsy7MaltvjNp0mcPlRbIRlcVVJDDGAYWuVxsc0zz0kCmqxCHt/oqNYc+dEFtuQqeNQrqzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P0wOW7awuHLwlx8uSLjJCqcIhR8hxr2Npy0wqXk/P7s=;
 b=V+Y/bh8+Wq7u8htoQnE7OyfLLKs5hMI3CKNOcwFvQY/7dzUL9J2RkUHla913gebH2Y3CVSFjY04373ypojeg63x6Hxc0JNRGR5Nu16f1dWjNdYWK7FyiGvCIV0TjnS8AQG9X3gQlU8EpPqWdEwd2bTB0NXEzle44kv6UCH/MBzc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=florinel.iordache@nxp.com; 
Received: from VI1PR04MB5454.eurprd04.prod.outlook.com (20.178.122.87) by
 VI1PR04MB4272.eurprd04.prod.outlook.com (10.171.182.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.20; Thu, 26 Mar 2020 13:52:19 +0000
Received: from VI1PR04MB5454.eurprd04.prod.outlook.com
 ([fe80::69f6:5d59:b505:a6c8]) by VI1PR04MB5454.eurprd04.prod.outlook.com
 ([fe80::69f6:5d59:b505:a6c8%3]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 13:52:19 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk
Cc:     devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net-next 8/9] net: phy: add bee algorithm for kr training
Date:   Thu, 26 Mar 2020 15:51:21 +0200
Message-Id: <1585230682-24417-9-git-send-email-florinel.iordache@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1585230682-24417-1-git-send-email-florinel.iordache@nxp.com>
References: <1585230682-24417-1-git-send-email-florinel.iordache@nxp.com>
Reply-to: florinel.iordache@nxp.com
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0142.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::47) To VI1PR04MB5454.eurprd04.prod.outlook.com
 (2603:10a6:803:d1::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1464-128.ea.freescale.net (89.37.124.34) by AM0PR01CA0142.eurprd01.prod.exchangelabs.com (2603:10a6:208:168::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.2835.20 via Frontend Transport; Thu, 26 Mar 2020 13:52:17 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [89.37.124.34]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 589b2268-cbe1-4efe-3ec9-08d7d18ce6b8
X-MS-TrafficTypeDiagnostic: VI1PR04MB4272:|VI1PR04MB4272:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB4272160F8D322547A403EEC0FBCF0@VI1PR04MB4272.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:299;
X-Forefront-PRVS: 0354B4BED2
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(136003)(366004)(396003)(26005)(478600001)(186003)(16526019)(956004)(81166006)(3450700001)(36756003)(81156014)(8936002)(44832011)(4326008)(8676002)(5660300002)(2616005)(7416002)(2906002)(66946007)(86362001)(6486002)(30864003)(66556008)(316002)(6506007)(6512007)(6666004)(66476007)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4272;H:VI1PR04MB5454.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mUxlXsEvayJCzjDF1ud5BmHGt0437xk+0tACO2g678UiA/R0MVC5aNcbcefSFltBWCDxCVFDycIanyIMWPcZQ38h2XeAqmbtakkzktkdMpeP9/PR/CUXGm5Sd7Br96kmlpfu1DG3iZ0qorgi0fIB/8WHy9GvUT+o+fWddhp60uVwcYjCOCGdbaqxvaJqSGELqEAsBM7dY9si/P+Mq5NASlEdseeQgkXOg8E3kkNfJMH4K6J10GHDhZkZ9sZhx8ZI38sswkTyZIXoHnKyDggFOst+s5VO1Xya1xP4ZtMc/q2UdObuicHHL5VWTeKG5ZGcJh6GSHPJGwWNXCR5dlCjm/qdGQ9fs0eeIAwAP6cPneVynkgHvUV3GAQjNzUdzL5wNdoOpgDSuPcKLMUwiinEQO7cSPDP/NsF4EHDgZHGpdyL7Y13gBEmTaXf/zmhvuk5
X-MS-Exchange-AntiSpam-MessageData: bTIWg3mLoc5rXudKXMvFQlEQbnyMjDXoQqCy7E+lm1uSdew+iIx+JXxisyGSPTa05GI54kMX4ZOlO8ysqgasE/lhCbo9lAjKmp34Y0ImY+EzRvaBiZYGO4mwEFISCqVfesuGv+4BUSelRACjuNSulA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 589b2268-cbe1-4efe-3ec9-08d7d18ce6b8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2020 13:52:19.4314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I6iFsFmNe17qqQN/hGPECRE4mTd23sOprMRtnJ+/gYFWsOgpMia8dVeTG6a0PgCBCLGDf0KArZ2MXE0A+yOvEsHdU8M6ldG1LkDocJ+znkw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4272
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for bee equalization algorithm used by kr training:
3-Taps Bit Edge Equalization (BEE) algorithm

Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
---
 drivers/net/phy/backplane/Kconfig  |   11 +
 drivers/net/phy/backplane/Makefile |    1 +
 drivers/net/phy/backplane/eq_bee.c | 1078 ++++++++++++++++++++++++++++++++++++
 3 files changed, 1090 insertions(+)
 create mode 100644 drivers/net/phy/backplane/eq_bee.c

diff --git a/drivers/net/phy/backplane/Kconfig b/drivers/net/phy/backplane/Kconfig
index 3e20a78..ee5cf1c 100644
--- a/drivers/net/phy/backplane/Kconfig
+++ b/drivers/net/phy/backplane/Kconfig
@@ -19,6 +19,17 @@ config ETH_BACKPLANE_FIXED
 	  No Equalization algorithm is used to adapt the initial coefficients
 	  initially set by the user.
 
+config ETH_BACKPLANE_BEE
+	tristate "3-Taps Bit Edge Equalization (BEE) algorithm"
+	depends on ETH_BACKPLANE
+	help
+	  This module provides a driver for BEE algorithm: 3-Taps
+	  Bit Edge Equalization. This algorithm is using a method
+	  based on 3-taps coefficients for mitigating intersymbol
+	  interference (ISI) in high-speed backplane applications.
+	  The initial values for algorithm coefficient values are
+	  user configurable and used as a starting point of the algorithm.
+
 config ETH_BACKPLANE_QORIQ
 	tristate "QorIQ Ethernet Backplane driver"
 	depends on ETH_BACKPLANE
diff --git a/drivers/net/phy/backplane/Makefile b/drivers/net/phy/backplane/Makefile
index d8f95ac..242e938 100644
--- a/drivers/net/phy/backplane/Makefile
+++ b/drivers/net/phy/backplane/Makefile
@@ -5,6 +5,7 @@
 
 obj-$(CONFIG_ETH_BACKPLANE) += eth_backplane.o
 obj-$(CONFIG_ETH_BACKPLANE_FIXED) += eq_fixed.o
+obj-$(CONFIG_ETH_BACKPLANE_BEE) += eq_bee.o
 obj-$(CONFIG_ETH_BACKPLANE_QORIQ) += eth_backplane_qoriq.o
 
 eth_backplane-objs	:= backplane.o link_training.o
diff --git a/drivers/net/phy/backplane/eq_bee.c b/drivers/net/phy/backplane/eq_bee.c
new file mode 100644
index 0000000..f62b777
--- /dev/null
+++ b/drivers/net/phy/backplane/eq_bee.c
@@ -0,0 +1,1078 @@
+// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
+/* 3-Taps Bit Edge Equalization (BEE) algorithm
+ *
+ * Copyright 2019-2020 NXP
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include "equalization.h"
+
+#define ALGORITHM_NAME		"backplane_bee_3tap"
+#define ALGORITHM_DESCR		"3-Taps Bit Edge Equalization"
+#define ALGORITHM_VERSION	"1.5.5"
+
+/* BEE algorithm timeouts */
+#define TIMEOUT_LONG				3
+#define TIMEOUT_M1				3
+
+/* Size of equalization snapshots data collection */
+#define EQ_SNAPSHOTS_SIZE			10
+
+/* Rx link quality conditions:
+ * The following macros are used to determine the Rx link quality
+ * which is used to decide if/when to proceed with BinLong/BinM1 modules.
+ * The code that considers Rx in good quality is always in place:
+ * Rx link is in 'good quality' if:
+ * Bin1, Bin2 and Bin3 are toggling
+ *
+ * These macros are used to enable less quality link conditions.
+ * If Rx link quality is considered good enough then proceed to BinLong/BinM1
+ */
+
+/* Rx is 'less quality' if:
+ * Bin1 is toggling
+ * AND
+ *   Bin2 is Early, GainMF stuck at max_eq_gain and Bin3 is Late
+ *   OR
+ *   Bin2 is Late, GainMF stuck at min_eq_gain and Bin3 is Early
+ */
+#define ENABLE_LESS_QUALITY_CONDITION
+
+/* Rx is 'even less quality' if:
+ * Bin1 is Early AND GainHF stuck at max_eq_gain and Bin2 is Late AND
+ *     GainMF stuck at min_eq_gain
+ * OR
+ * Bin1 is Late AND GainHF stuck at min_eq_gain AND
+ *     Bin2 is Early, GainMF stuck at max_eq_gain
+ */
+#define ENABLE_EVEN_LESS_QUALITY_CONDITION
+
+/* Rx is 'seemingly quality' if:
+ * Bin1 is always Late for all snapshots AND
+ *     GainHF is stuck at min_eq_gain
+ * AND
+ * Bin2 and Bin3 are both Toggling
+ */
+#define ENABLE_SEEMINGLY_QUALITY_CONDITION
+
+enum bin_state {
+	BIN_INVALID,
+	BIN_EARLY,
+	BIN_TOGGLE,
+	BIN_LATE
+};
+
+struct eq_data_priv {
+	/* Equalization Algorithm setup data */
+	struct eq_setup_info eq_setup;
+
+	/* Bin state */
+	enum bin_state bin_m1_state;
+	enum bin_state bin_long_state;
+	enum bin_state prev_bin_m1_state;
+	enum bin_state prev_bin_long_state;
+
+	/* Bin training status */
+	bool bin_m1_stop;
+	bool bin_long_stop;
+	int m1_min_max_cnt;
+	int long_min_max_cnt;
+
+	/* Algorithm controlled value */
+	u32 ld_update;
+
+	/* Bit edge statistics: Bin snapshots */
+	s16 bin1_snapshot[EQ_SNAPSHOTS_SIZE];
+	s16 bin2_snapshot[EQ_SNAPSHOTS_SIZE];
+	s16 bin3_snapshot[EQ_SNAPSHOTS_SIZE];
+	s16 bin_long_snapshot[EQ_SNAPSHOTS_SIZE];
+	s16 bin_m1_snapshot[EQ_SNAPSHOTS_SIZE];
+	s16 bin_offset_snapshot[EQ_SNAPSHOTS_SIZE];
+
+	/* Gain snapshots */
+	u8 gain_hf_snapshot[EQ_SNAPSHOTS_SIZE];
+	u8 gain_mf_snapshot[EQ_SNAPSHOTS_SIZE];
+
+	/* Offset status snapshot */
+	u8 osestat_snapshot[EQ_SNAPSHOTS_SIZE];
+};
+
+static enum bin_state get_bin_snapshots_state(struct eq_data_priv *priv,
+					      enum eqc_type type)
+{
+	s16 bin_snp_av_thr_low, bin_snp_av_thr_high;
+	s16 snapshot_average, snapshot_sum = 0;
+	s16 *bin_snapshot;
+	struct eqc_range *bin_range;
+	int i;
+
+	if (!priv) {
+		pr_err("%s: NULL private data\n", ALGORITHM_NAME);
+		return BIN_INVALID;
+	}
+
+	switch (type) {
+	case EQC_BIN_1:
+		bin_snapshot = priv->bin1_snapshot;
+		break;
+	case EQC_BIN_2:
+		bin_snapshot = priv->bin2_snapshot;
+		break;
+	case EQC_BIN_3:
+		bin_snapshot = priv->bin3_snapshot;
+		break;
+	case EQC_BIN_LONG:
+		bin_snapshot = priv->bin_long_snapshot;
+		break;
+	case EQC_BIN_OFFSET:
+		bin_snapshot = priv->bin_offset_snapshot;
+		break;
+	case EQC_BIN_M1:
+		bin_snapshot = priv->bin_m1_snapshot;
+		break;
+	default:
+		/* invalid bin type */
+		return BIN_INVALID;
+	}
+	if (!bin_snapshot)
+		return BIN_INVALID;
+
+	bin_range = priv->eq_setup.equalizer.ops.get_counter_range(type);
+	if (!bin_range)
+		return BIN_INVALID;
+
+	bin_snp_av_thr_low = bin_range->mid_low;
+	bin_snp_av_thr_high = bin_range->mid_high;
+
+	for (i = 0; i < EQ_SNAPSHOTS_SIZE; i++)
+		snapshot_sum += bin_snapshot[i];
+
+	snapshot_average = (s16)(snapshot_sum / EQ_SNAPSHOTS_SIZE);
+
+	if (snapshot_average >= -256 && snapshot_average < bin_snp_av_thr_low)
+		return BIN_EARLY;
+	else if (snapshot_average >= bin_snp_av_thr_low &&
+		 snapshot_average < bin_snp_av_thr_high)
+		return BIN_TOGGLE;
+	else if (snapshot_average >= bin_snp_av_thr_high &&
+		 snapshot_average <= 255)
+		return BIN_LATE;
+
+	return BIN_INVALID;
+}
+
+static u32 process_bin_m1_toggle(struct eq_data_priv *priv)
+{
+	enum req_type prev_req_cm1;
+	u32 update = lt_encode_startup_request(REQ_HOLD);
+
+	if (!priv) {
+		pr_err("%s: NULL private data\n", ALGORITHM_NAME);
+		return update;
+	}
+
+	prev_req_cm1 = lt_decode_coef_update(priv->ld_update, C_M1);
+
+	/* Toggle path */
+	if (priv->prev_bin_m1_state == priv->bin_m1_state) {
+		/* Hold C- */
+		update = lt_encode_startup_request(REQ_HOLD);
+	} else {
+		update = lt_encode_startup_request(REQ_HOLD);
+		/* If previous step moved C- repeat C- move */
+		if (prev_req_cm1 == REQ_INC ||
+		    prev_req_cm1 == REQ_DEC)
+			update = lt_encode_request(update, prev_req_cm1, C_M1);
+	}
+
+	return update;
+}
+
+static u32 process_bin_m1_prev_toggle(struct eq_data_priv *priv)
+{
+	enum req_type prev_req_cm1;
+	u32 update = lt_encode_startup_request(REQ_HOLD);
+
+	if (!priv) {
+		pr_err("%s: NULL private data\n", ALGORITHM_NAME);
+		return update;
+	}
+
+	prev_req_cm1 = lt_decode_coef_update(priv->ld_update, C_M1);
+
+	update = lt_encode_startup_request(REQ_HOLD);
+	/* If previous step moved C- go back on C- */
+	if (prev_req_cm1 == REQ_INC)
+		update = lt_encode_request(update, REQ_DEC, C_M1);
+	if (prev_req_cm1 == REQ_DEC)
+		update = lt_encode_request(update, REQ_INC, C_M1);
+
+	return update;
+}
+
+static u32 process_bin_m1_early(struct eq_data_priv *priv)
+{
+	enum coef_status lpst_cm1;
+	u32 update = lt_encode_startup_request(REQ_HOLD);
+
+	if (!priv) {
+		pr_err("%s: NULL private data\n", ALGORITHM_NAME);
+		return update;
+	}
+
+	/* Get LP coefficient status to determine
+	 * if coefficient is in range or reached the limit thresholds
+	 * IF the coefficient is at MIN/MAX and still want to INC/DEC
+	 * THEN do we are done with this module
+	 */
+	lpst_cm1 = lt_get_lp_coef_status(priv->eq_setup.krlane, C_M1);
+
+	/* Early path */
+	if (lpst_cm1 == COEF_MAX) {
+		/* Hold C- */
+		update = lt_encode_startup_request(REQ_HOLD);
+	} else {
+		/* request Increment C- */
+		update = lt_encode_request(update, REQ_INC, C_M1);
+	}
+
+	return update;
+}
+
+static u32 process_bin_m1_late(struct eq_data_priv *priv)
+{
+	enum coef_status lpst_cm1;
+	u32 update = lt_encode_startup_request(REQ_HOLD);
+
+	if (!priv) {
+		pr_err("%s: NULL private data\n", ALGORITHM_NAME);
+		return update;
+	}
+
+	/* Get LP coefficient status to determine
+	 * if coefficient is in range or reached the limit thresholds
+	 * IF the coefficient is at MIN/MAX and still want to INC/DEC
+	 * THEN do we are done with this module
+	 */
+	lpst_cm1 = lt_get_lp_coef_status(priv->eq_setup.krlane, C_M1);
+
+	/* Late path */
+	if (lpst_cm1 == COEF_MIN) {
+		/* Hold C- */
+		update = lt_encode_startup_request(REQ_HOLD);
+	} else {
+		/* request Decrement C- */
+		update = lt_encode_request(update, REQ_DEC, C_M1);
+	}
+
+	return update;
+}
+
+static u32 process_bin_m1_antipodal(struct eq_data_priv *priv)
+{
+	u32 update = lt_encode_startup_request(REQ_HOLD);
+
+	if (!priv) {
+		pr_err("%s: NULL private data\n", ALGORITHM_NAME);
+		return update;
+	}
+
+	if (priv->bin_m1_state == BIN_LATE) {
+		/* request Decrement C- */
+		update = lt_encode_request(update, REQ_DEC, C_M1);
+	} else {
+		/* Hold C- */
+		update = lt_encode_startup_request(REQ_HOLD);
+	}
+
+	return update;
+}
+
+/* process_bin_m1
+ *
+ * Bin_M1:
+ *   contains the scoring of initial edges on pulses that are 1UI long
+ *      following non-single bits
+ *   used to adjust LP coefficient: C_M1
+ */
+static void process_bin_m1(struct eq_data_priv *priv)
+{
+	u32 update = lt_encode_startup_request(REQ_HOLD);
+
+	if (!priv) {
+		pr_err("%s: NULL private data\n", ALGORITHM_NAME);
+		return;
+	}
+
+	if (priv->bin_m1_state == BIN_INVALID) {
+		bpdev_err(priv->eq_setup.bpphy, "Invalid Bin_M1 state\n");
+		return;
+	}
+
+	if (priv->bin_m1_state == BIN_TOGGLE) {
+		update = process_bin_m1_toggle(priv);
+	} else {
+		if (priv->prev_bin_m1_state == BIN_TOGGLE) {
+			update = process_bin_m1_prev_toggle(priv);
+		} else {
+			if (priv->prev_bin_m1_state == priv->bin_m1_state) {
+				if (priv->bin_m1_state == BIN_LATE)
+					update = process_bin_m1_late(priv);
+				else
+					update = process_bin_m1_early(priv);
+			} else {
+				update = process_bin_m1_antipodal(priv);
+			}
+		}
+	}
+
+	/* Store current algorithm decision
+	 * as previous algorithm ld_update for next step
+	 */
+	priv->ld_update = update;
+}
+
+static u32 process_bin_long_toggle(struct eq_data_priv *priv)
+{
+	enum req_type prev_req_cp1, prev_req_cz0;
+	u32 update = lt_encode_startup_request(REQ_HOLD);
+
+	if (!priv) {
+		pr_err("%s: NULL private data\n", ALGORITHM_NAME);
+		return update;
+	}
+
+	prev_req_cp1 = lt_decode_coef_update(priv->ld_update, C_P1);
+	prev_req_cz0 = lt_decode_coef_update(priv->ld_update, C_Z0);
+
+	/* Toggle path */
+	if (priv->prev_bin_long_state == priv->bin_long_state) {
+		/* Hold C+ and C0 */
+		update = lt_encode_startup_request(REQ_HOLD);
+	} else {
+		update = lt_encode_startup_request(REQ_HOLD);
+		/* If previous step moved C+/C0 repeat C+/C0 move */
+		if (prev_req_cp1 == REQ_INC ||
+		    prev_req_cp1 == REQ_DEC ||
+		    prev_req_cz0 == REQ_INC ||
+		    prev_req_cz0 == REQ_DEC) {
+			update = lt_encode_request(update, prev_req_cp1, C_P1);
+			update = lt_encode_request(update, prev_req_cz0, C_Z0);
+		}
+	}
+
+	return update;
+}
+
+static u32 process_bin_long_prev_toggle(struct eq_data_priv *priv)
+{
+	enum req_type prev_req_cp1, prev_req_cz0;
+	u32 update = lt_encode_startup_request(REQ_HOLD);
+
+	if (!priv) {
+		pr_err("%s: NULL private data\n", ALGORITHM_NAME);
+		return update;
+	}
+
+	prev_req_cp1 = lt_decode_coef_update(priv->ld_update, C_P1);
+	prev_req_cz0 = lt_decode_coef_update(priv->ld_update, C_Z0);
+
+	/* If previous step moved C+/C0 then go back on C+/C0 */
+	if (prev_req_cp1 == REQ_INC)
+		update = lt_encode_request(update, REQ_DEC, C_P1);
+	if (prev_req_cp1 == REQ_DEC)
+		update = lt_encode_request(update, REQ_INC, C_P1);
+	if (prev_req_cz0 == REQ_INC)
+		update = lt_encode_request(update, REQ_DEC, C_Z0);
+	if (prev_req_cz0 == REQ_DEC)
+		update = lt_encode_request(update, REQ_INC, C_Z0);
+
+	return update;
+}
+
+static u32 process_bin_long_early(struct eq_data_priv *priv)
+{
+	enum coef_status lpst_cp1, lpst_cz0;
+	u32 update = lt_encode_startup_request(REQ_HOLD);
+
+	if (!priv) {
+		pr_err("%s: NULL private data\n", ALGORITHM_NAME);
+		return update;
+	}
+
+	/* Get LP coefficient status to determine
+	 * if coefficient is in range or reached the limit thresholds
+	 * IF the coefficient is at MIN/MAX and still want to INC/DEC
+	 * THEN do we are done with this module
+	 */
+	lpst_cp1 = lt_get_lp_coef_status(priv->eq_setup.krlane, C_P1);
+	lpst_cz0 = lt_get_lp_coef_status(priv->eq_setup.krlane, C_Z0);
+
+	/* Early path (make edge later) */
+	if (lpst_cp1 == COEF_MAX) {
+		if (lpst_cz0 == COEF_MAX) {
+			/* Hold C+, C0 */
+			update = lt_encode_startup_request(REQ_HOLD);
+		} else {
+			/* request Increment C0 and
+			 * Decrement C+
+			 */
+			update = lt_encode_request(update, REQ_INC, C_Z0);
+			update = lt_encode_request(update, REQ_DEC, C_P1);
+		}
+	} else {
+		/* request Increment C+ */
+		update = lt_encode_request(update, REQ_INC, C_P1);
+	}
+
+	return update;
+}
+
+static u32 process_bin_long_late(struct eq_data_priv *priv)
+{
+	enum coef_status lpst_cp1, lpst_cz0;
+	u32 update = lt_encode_startup_request(REQ_HOLD);
+
+	if (!priv) {
+		pr_err("%s: NULL private data\n", ALGORITHM_NAME);
+		return update;
+	}
+
+	/* Get LP coefficient status to determine
+	 * if coefficient is in range or reached the limit thresholds
+	 * IF the coefficient is at MIN/MAX and still want to INC/DEC
+	 * THEN do we are done with this module
+	 */
+	lpst_cp1 = lt_get_lp_coef_status(priv->eq_setup.krlane, C_P1);
+	lpst_cz0 = lt_get_lp_coef_status(priv->eq_setup.krlane, C_Z0);
+
+	/* Late path (make edge earlier) */
+	if (lpst_cp1 == COEF_MIN) {
+		if (lpst_cz0 == COEF_MIN) {
+			/* Hold C0 */
+			update = lt_encode_startup_request(REQ_HOLD);
+		} else {
+			/* request Decrement C0 */
+			update = lt_encode_request(update, REQ_DEC, C_Z0);
+		}
+	} else {
+		/* request Decrement C+ */
+		update = lt_encode_request(update, REQ_DEC, C_P1);
+	}
+
+	return update;
+}
+
+static u32 process_bin_long_antipodal(struct eq_data_priv *priv)
+{
+	enum req_type prev_req_cp1;
+	u32 update = lt_encode_startup_request(REQ_HOLD);
+
+	if (!priv) {
+		pr_err("%s: NULL private data\n", ALGORITHM_NAME);
+		return update;
+	}
+
+	prev_req_cp1 = lt_decode_coef_update(priv->ld_update, C_P1);
+
+	/* Request move on C+ and C0 */
+	/* If previous step moved C+ then go back on C+ */
+	if (prev_req_cp1 == REQ_INC)
+		update = lt_encode_request(update, REQ_DEC, C_P1);
+	if (prev_req_cp1 == REQ_DEC)
+		update = lt_encode_request(update, REQ_INC, C_P1);
+
+	if (priv->bin_long_state == BIN_LATE) {
+		/* request Decrement C0 */
+		update = lt_encode_request(update, REQ_DEC, C_Z0);
+	} else {
+		/* request Increment C0 */
+		update = lt_encode_request(update, REQ_INC, C_Z0);
+	}
+
+	return update;
+}
+
+/* process_bin_long
+ *
+ * Bin_Long:
+ *   contains the scoring of final edges on pulses longer than 7UI long
+ *   used to adjust LP coefficients: C_P1 and C_Z0
+ */
+static void process_bin_long(struct eq_data_priv *priv)
+{
+	u32 update = lt_encode_startup_request(REQ_HOLD);
+
+	if (!priv) {
+		pr_err("%s: NULL private data\n", ALGORITHM_NAME);
+		return;
+	}
+
+	if (priv->bin_long_state == BIN_INVALID) {
+		bpdev_err(priv->eq_setup.bpphy, "Invalid Bin_Long state\n");
+		return;
+	}
+
+	if (priv->bin_long_state == BIN_TOGGLE) {
+		update = process_bin_long_toggle(priv);
+	} else {
+		if (priv->prev_bin_long_state == BIN_TOGGLE) {
+			update = process_bin_long_prev_toggle(priv);
+		} else {
+			if (priv->prev_bin_long_state == priv->bin_long_state) {
+				if (priv->bin_long_state == BIN_LATE)
+					update = process_bin_long_late(priv);
+				else
+					update = process_bin_long_early(priv);
+			} else {
+				update = process_bin_long_antipodal(priv);
+			}
+		}
+	}
+
+	/* Store current algorithm decision
+	 * as previous algorithm ld_update for next step
+	 */
+	priv->ld_update = update;
+}
+
+/* Callbacks:
+ * required by generic equalization_algorithm
+ */
+static void process_bad_state(struct eq_data_priv *priv)
+{
+	bool lp_at_init, lp_at_preset;
+	u32 req;
+
+	if (!priv) {
+		pr_err("%s: NULL private data\n", ALGORITHM_NAME);
+		return;
+	}
+
+	lp_at_init = lt_is_lp_at_startup(priv->eq_setup.krlane, REQ_INIT);
+	lp_at_preset = lt_is_lp_at_startup(priv->eq_setup.krlane, REQ_PRESET);
+
+	if (lp_at_init) {
+		/* Try Request Preset */
+		req = lt_encode_startup_request(REQ_PRESET);
+		lt_lp_update(priv->eq_setup.krlane, req);
+	} else if (lp_at_preset) {
+		/* LT ERROR
+		 * set lt_error flag to prevent reaching
+		 * training state = TRAINED
+		 * and resume training in case of LT error
+		 */
+		lt_set_error(priv->eq_setup.krlane, true);
+		bpdev_err(priv->eq_setup.bpphy,
+			  "LT Error: CDR_LOCK is zero on Preset\n");
+	} else {
+		/* Move LP back to previous C-, C0, C+ and HOLD */
+		lt_move_lp_back(priv->eq_setup.krlane);
+	}
+}
+
+static bool collect_bin_counters(struct eq_data_priv *priv,
+				 enum eqc_type type)
+{
+	struct equalizer_ops *eqops;
+	s16 *bin_snapshot = NULL;
+	int snp_size;
+
+	if (!priv) {
+		pr_err("%s: NULL private data\n", ALGORITHM_NAME);
+		return false;
+	}
+
+	/* collect Bin snapshots */
+	switch (type) {
+	case EQC_BIN_1:
+		bin_snapshot = priv->bin1_snapshot;
+		break;
+	case EQC_BIN_2:
+		bin_snapshot = priv->bin2_snapshot;
+		break;
+	case EQC_BIN_3:
+		bin_snapshot = priv->bin3_snapshot;
+		break;
+	case EQC_BIN_LONG:
+		bin_snapshot = priv->bin_long_snapshot;
+		break;
+	case EQC_BIN_OFFSET:
+		bin_snapshot = priv->bin_offset_snapshot;
+		break;
+	case EQC_BIN_M1:
+		bin_snapshot = priv->bin_m1_snapshot;
+		break;
+	default:
+		/* invalid bin type */
+		return false;
+	}
+	if (!bin_snapshot)
+		return false;
+
+	eqops = &priv->eq_setup.equalizer.ops;
+	if (!eqops) {
+		bpdev_err(priv->eq_setup.bpphy,
+			  "No operations for equalizer %s %s\n",
+			  priv->eq_setup.equalizer.name,
+			  priv->eq_setup.equalizer.version);
+		return false;
+	}
+	snp_size = eqops->collect_counters(priv->eq_setup.reg_base, type,
+					   bin_snapshot, EQ_SNAPSHOTS_SIZE);
+	/* Check if snapshots collection failed */
+	if (snp_size < EQ_SNAPSHOTS_SIZE) {
+		bpdev_err(priv->eq_setup.bpphy,
+			  "Counters collection failed for equalizer %s %s\n",
+			  priv->eq_setup.equalizer.name,
+			  priv->eq_setup.equalizer.version);
+		return false;
+	}
+
+	/* if CDR_LOCK = 0: Statistics are invalid */
+	if (!backplane_is_cdr_lock(priv->eq_setup.krlane, true)) {
+		process_bad_state(priv);
+		return false;
+	}
+
+	return true;
+}
+
+static bool collect_bit_edge_statistics(struct eq_data_priv *priv)
+{
+	struct equalizer_ops *eqops;
+	enum eqc_type status_types[] = {
+		EQC_GAIN_HF, EQC_GAIN_MF, EQC_EQOFFSET
+	};
+	s16 status_counters[ARRAY_SIZE(status_types)][EQ_SNAPSHOTS_SIZE];
+	int i, snp_size;
+
+	if (!priv) {
+		pr_err("%s: NULL private data\n", ALGORITHM_NAME);
+		return false;
+	}
+
+	/* collect Bin snapshots */
+	if (!collect_bin_counters(priv, EQC_BIN_1))
+		return false;
+	if (!collect_bin_counters(priv, EQC_BIN_2))
+		return false;
+	if (!collect_bin_counters(priv, EQC_BIN_3))
+		return false;
+	if (!collect_bin_counters(priv, EQC_BIN_LONG))
+		return false;
+	if (!collect_bin_counters(priv, EQC_BIN_OFFSET))
+		return false;
+	if (!collect_bin_counters(priv, EQC_BIN_M1))
+		return false;
+
+	/* collect Gains */
+	eqops = &priv->eq_setup.equalizer.ops;
+	if (!eqops) {
+		bpdev_err(priv->eq_setup.bpphy,
+			  "No operations for equalizer %s %s\n",
+			  priv->eq_setup.equalizer.name,
+			  priv->eq_setup.equalizer.version);
+		return false;
+	}
+	snp_size = eqops->collect_multiple_counters(priv->eq_setup.reg_base,
+						    status_types,
+						    ARRAY_SIZE(status_types),
+						    (s16 *)status_counters,
+						    EQ_SNAPSHOTS_SIZE);
+	/* Check if snapshots collection failed */
+	if (snp_size < EQ_SNAPSHOTS_SIZE) {
+		bpdev_err(priv->eq_setup.bpphy,
+			  "Counters collection failed for equalizer %s %s\n",
+			  priv->eq_setup.equalizer.name,
+			  priv->eq_setup.equalizer.version);
+		return false;
+	}
+
+	for (i = 0; i < EQ_SNAPSHOTS_SIZE; i++) {
+		priv->gain_hf_snapshot[i] = (u8)status_counters[0][i];
+		priv->gain_mf_snapshot[i] = (u8)status_counters[1][i];
+		priv->osestat_snapshot[i] = (u8)status_counters[2][i];
+	}
+
+	return true;
+}
+
+static void generate_3taps_request(struct eq_data_priv *priv)
+{
+	if (!priv) {
+		pr_err("%s: NULL private data\n", ALGORITHM_NAME);
+		return;
+	}
+
+	/* Store current state as previous state */
+	priv->prev_bin_m1_state = priv->bin_m1_state;
+	priv->prev_bin_long_state = priv->bin_long_state;
+
+	priv->bin_m1_state = get_bin_snapshots_state(priv, EQC_BIN_M1);
+	if (priv->bin_m1_state == BIN_INVALID) {
+		/* invalid state: should never happen */
+		return;
+	}
+
+	priv->bin_long_state = get_bin_snapshots_state(priv, EQC_BIN_LONG);
+	if (priv->bin_long_state == BIN_INVALID) {
+		/* invalid state: should never happen */
+		return;
+	}
+
+	/* Move to BinLong/BinM1 modules:
+	 * Bin Modules order: BinLong before BinM1
+	 * We try to finish BinLong before we do BinM1
+	 */
+
+	/* Process BinLong module
+	 * decide and ask for movement of C+/C0
+	 */
+	if (!priv->bin_long_stop) {
+		process_bin_long(priv);
+		lt_lp_update(priv->eq_setup.krlane, priv->ld_update);
+		if (lt_is_update_of_type(priv->ld_update, REQ_HOLD)) {
+			/* Sent All Hold request */
+			priv->long_min_max_cnt++;
+			if (priv->long_min_max_cnt >= TIMEOUT_LONG)
+				priv->bin_long_stop = true;
+		} else {
+			/* Sent C Inc/Dec request */
+			priv->long_min_max_cnt = 0;
+		}
+		return;
+	}
+
+	/* Process BinM1 module
+	 * decide and ask for movement of C-
+	 */
+	if (!priv->bin_m1_stop) {
+		process_bin_m1(priv);
+		lt_lp_update(priv->eq_setup.krlane, priv->ld_update);
+		if (lt_is_update_of_type(priv->ld_update, REQ_HOLD)) {
+			/* Sent All Hold request */
+			priv->m1_min_max_cnt++;
+			if (priv->m1_min_max_cnt >= TIMEOUT_M1)
+				priv->bin_m1_stop = true;
+		} else {
+			/* Sent C Inc/Dec request */
+			priv->m1_min_max_cnt = 0;
+		}
+		return;
+	}
+}
+
+static bool is_rx_ok(struct eq_data_priv *priv)
+{
+	enum bin_state bin1_snapshot_state;
+	enum bin_state bin2_snapshot_state;
+	enum bin_state bin3_snapshot_state;
+	struct eqc_range *gain_range, *osestat_range;
+	struct equalizer_ops *eqops;
+	bool rx_quality_1, rx_quality_2;
+	bool is_ok, rx_good_quality;
+	u8 min_eq_gain, max_eq_gain;
+	u8 osestat_mid_low, osestat_mid_high;
+	u8 min_snp, max_snp;
+	s16 snapshot;
+	int i;
+
+	if (!priv) {
+		pr_err("%s: NULL private data\n", ALGORITHM_NAME);
+		return false;
+	}
+
+	/* Checking Bins/Gains after LP has updated its TX */
+	eqops = &priv->eq_setup.equalizer.ops;
+	if (!eqops)
+		return false;
+	gain_range = eqops->get_counter_range(EQC_GAIN_HF);
+	if (!gain_range)
+		return false;
+	osestat_range = eqops->get_counter_range(EQC_EQOFFSET);
+	if (!osestat_range)
+		return false;
+
+	min_eq_gain = (u8)gain_range->min;
+	max_eq_gain = (u8)gain_range->max;
+	osestat_mid_low = (u8)osestat_range->mid_low;
+	osestat_mid_high = (u8)osestat_range->mid_high;
+
+	/* CDR_LOCK must be 1 */
+	if (!backplane_is_cdr_lock(priv->eq_setup.krlane, true))
+		return false;
+
+	/* Offset Bin must NOT be 10 of the same value */
+	rx_good_quality = false;
+	snapshot = priv->bin_offset_snapshot[0];
+	for (i = 0; i < EQ_SNAPSHOTS_SIZE; i++) {
+		if (snapshot != priv->bin_offset_snapshot[i]) {
+			rx_good_quality = true;
+			break;
+		}
+	}
+	if (!rx_good_quality)
+		return false;
+
+	/* Offset status must dither (+/-2) around MidRange value
+	 * What we want to see is that the Offset has settled to a value
+	 * somewhere between: mid-range low and mid-range high and that
+	 * the series of snapshot values are +/-2 of the settled value.
+	 */
+	rx_good_quality = true;
+	min_snp = priv->osestat_snapshot[0];
+	max_snp = priv->osestat_snapshot[0];
+	for (i = 0; i < EQ_SNAPSHOTS_SIZE; i++) {
+		if (priv->osestat_snapshot[i] < osestat_mid_low ||
+		    priv->osestat_snapshot[i] > osestat_mid_high) {
+			rx_good_quality = false;
+			break;
+		}
+		if (priv->osestat_snapshot[i] < min_snp)
+			min_snp = priv->osestat_snapshot[i];
+		if (priv->osestat_snapshot[i] > max_snp)
+			max_snp = priv->osestat_snapshot[i];
+	}
+	if (max_snp - min_snp > 4)
+		rx_good_quality = false;
+	if (!rx_good_quality)
+		return false;
+
+	/* The Rx is in good quality if:
+	 * Bin1, Bin2, and Bin3 are toggling
+	 * Proceed to BinLong/BinM1 modules
+	 */
+	bin1_snapshot_state = get_bin_snapshots_state(priv, EQC_BIN_1);
+	bin2_snapshot_state = get_bin_snapshots_state(priv, EQC_BIN_2);
+	bin3_snapshot_state = get_bin_snapshots_state(priv, EQC_BIN_3);
+
+	rx_good_quality = (bin1_snapshot_state == BIN_TOGGLE &&
+			   bin2_snapshot_state == BIN_TOGGLE &&
+			   bin3_snapshot_state == BIN_TOGGLE);
+
+	/* If Rx is in good quality then proceed to BinLong/BinM1 */
+	if (rx_good_quality)
+		return true;
+
+#ifdef ENABLE_LESS_QUALITY_CONDITION
+	rx_quality_1 = false;
+	rx_quality_2 = false;
+	if (bin1_snapshot_state == BIN_TOGGLE) {
+		if (bin2_snapshot_state == BIN_EARLY &&
+		    bin3_snapshot_state == BIN_LATE) {
+			/* check if GainMF is stuck at max_eq_gain */
+			rx_quality_1 = true;
+			for (i = 0; i < EQ_SNAPSHOTS_SIZE; i++) {
+				if (priv->gain_mf_snapshot[i] != max_eq_gain) {
+					rx_quality_1 = false;
+					break;
+				}
+			}
+		}
+		if (bin2_snapshot_state == BIN_LATE &&
+		    bin3_snapshot_state == BIN_EARLY) {
+			/* check if GainMF is stuck at min_eq_gain */
+			rx_quality_2 = true;
+			for (i = 0; i < EQ_SNAPSHOTS_SIZE; i++) {
+				if (priv->gain_mf_snapshot[i] != min_eq_gain) {
+					rx_quality_2 = false;
+					break;
+				}
+			}
+		}
+	}
+
+	/* If Rx is less quality then proceed to BinLong/BinM1 */
+	if (rx_quality_1 || rx_quality_2)
+		return true;
+#endif
+
+#ifdef ENABLE_EVEN_LESS_QUALITY_CONDITION
+	rx_quality_1 = false;
+	rx_quality_2 = false;
+	if (bin1_snapshot_state == BIN_EARLY &&
+	    bin2_snapshot_state == BIN_LATE) {
+		/* check if GainHF is stuck at max_eq_gain */
+		is_ok = true;
+		for (i = 0; i < EQ_SNAPSHOTS_SIZE; i++) {
+			if (priv->gain_hf_snapshot[i] != max_eq_gain) {
+				is_ok = false;
+				break;
+			}
+		}
+		if (is_ok) {
+			/* check if GainMF is stuck at min_eq_gain */
+			is_ok = true;
+			for (i = 0; i < EQ_SNAPSHOTS_SIZE; i++) {
+				if (priv->gain_mf_snapshot[i] != min_eq_gain) {
+					is_ok = false;
+					break;
+				}
+			}
+			if (is_ok)
+				rx_quality_1 = true;
+		}
+	}
+	if (bin1_snapshot_state == BIN_LATE &&
+	    bin2_snapshot_state == BIN_EARLY) {
+		/* check if GainHF is stuck at min_eq_gain */
+		is_ok = true;
+		for (i = 0; i < EQ_SNAPSHOTS_SIZE; i++) {
+			if (priv->gain_hf_snapshot[i] != min_eq_gain) {
+				is_ok = false;
+				break;
+			}
+		}
+		if (is_ok) {
+			/* check if GainMF is stuck at max_eq_gain */
+			is_ok = true;
+			for (i = 0; i < EQ_SNAPSHOTS_SIZE; i++) {
+				if (priv->gain_mf_snapshot[i] != max_eq_gain) {
+					is_ok = false;
+					break;
+				}
+			}
+			if (is_ok)
+				rx_quality_2 = true;
+		}
+	}
+
+	/* If Rx is in good quality then proceed to BinLong/BinM1 */
+	if (rx_quality_1 || rx_quality_2)
+		return true;
+#endif
+
+#ifdef ENABLE_SEEMINGLY_QUALITY_CONDITION
+	rx_quality_1 = false;
+	if (bin1_snapshot_state == BIN_LATE &&
+	    bin2_snapshot_state == BIN_TOGGLE &&
+	    bin3_snapshot_state == BIN_TOGGLE) {
+		/* check if GainHF is stuck at min_eq_gain */
+		rx_quality_1 = true;
+		for (i = 0; i < EQ_SNAPSHOTS_SIZE; i++) {
+			if (priv->gain_hf_snapshot[i] != min_eq_gain) {
+				rx_quality_1 = false;
+				break;
+			}
+		}
+	}
+
+	if (rx_quality_1)
+		return true;
+#endif
+
+	return false;
+}
+
+static bool is_eq_done(struct eq_data_priv *priv)
+{
+	if (!priv) {
+		pr_err("%s: NULL private data\n", ALGORITHM_NAME);
+		return false;
+	}
+
+	return (priv->bin_m1_stop && priv->bin_long_stop);
+}
+
+/* BEE 3 TAP Algorithm API */
+
+/* Create BEE 3-TAP Equalization Algorithm */
+static struct eq_data_priv *create(struct eq_setup_info setup)
+{
+	struct eq_data_priv *bee_data;
+
+	bee_data = devm_kzalloc(&setup.bpphy->mdio.dev,
+				sizeof(*bee_data), GFP_KERNEL);
+	if (!bee_data)
+		return NULL;
+
+	/* initialize algorithm setup data */
+	bee_data->eq_setup = setup;
+
+	/* initialize specific BEE algorithm data */
+	bee_data->bin_m1_state = BIN_INVALID;
+	bee_data->bin_long_state = BIN_INVALID;
+	bee_data->prev_bin_m1_state = BIN_INVALID;
+	bee_data->prev_bin_long_state = BIN_INVALID;
+	bee_data->m1_min_max_cnt = 0;
+	bee_data->long_min_max_cnt = 0;
+	bee_data->bin_m1_stop = false;
+	bee_data->bin_long_stop = false;
+	bee_data->ld_update = 0;
+
+	return bee_data;
+}
+
+static void destroy(struct eq_data_priv *priv)
+{
+	if (!priv) {
+		pr_err("%s: NULL private data\n", ALGORITHM_NAME);
+		return;
+	}
+
+	kfree(priv);
+}
+
+static const struct equalization_algorithm eq_alg = {
+	.name = ALGORITHM_NAME,
+	.descr = ALGORITHM_DESCR,
+	.version = ALGORITHM_VERSION,
+	.use_local_tx_training = true,
+	.use_remote_tx_training = true,
+	.ops = {
+		.create = create,
+		.destroy = destroy,
+		.is_rx_ok = is_rx_ok,
+		.is_eq_done = is_eq_done,
+		.collect_statistics = collect_bit_edge_statistics,
+		.generate_request = generate_3taps_request,
+		.process_bad_state = process_bad_state,
+		.dump_algorithm_context = NULL,
+	}
+};
+
+static const char * const alg_keys[] = {
+	"bee",
+	"BEE",
+};
+
+static int __init bee_init(void)
+{
+	int i, err;
+
+	pr_info("%s: %s algorithm version %s\n",
+		ALGORITHM_NAME, ALGORITHM_DESCR, ALGORITHM_VERSION);
+
+	/* register BEE algorithm: */
+	for (i = 0; i < ARRAY_SIZE(alg_keys); i++) {
+		err = backplane_eq_register(alg_keys[i], &eq_alg);
+		if (err) {
+			pr_err("%s: '%s' equalization algorithm registration failed\n",
+			       ALGORITHM_NAME, alg_keys[i]);
+		}
+	}
+
+	return 0;
+}
+
+static void __exit bee_exit(void)
+{
+	int i;
+
+	/* unregister BEE algorithm: */
+	for (i = 0; i < ARRAY_SIZE(alg_keys); i++)
+		backplane_eq_unregister(alg_keys[i]);
+
+	pr_info("%s: %s algorithm version %s unloaded\n",
+		ALGORITHM_NAME, ALGORITHM_DESCR, ALGORITHM_VERSION);
+}
+
+module_init(bee_init);
+module_exit(bee_exit);
+
+MODULE_DESCRIPTION("Bit Edge Equalization Algorithm");
+MODULE_AUTHOR("Florinel Iordache <florinel.iordache@nxp.com>");
+MODULE_LICENSE("Dual BSD/GPL");
-- 
1.9.1

