Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEE1339F3A2
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 12:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbhFHKgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 06:36:12 -0400
Received: from mail-co1nam11on2082.outbound.protection.outlook.com ([40.107.220.82]:2369
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229536AbhFHKgK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 06:36:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aweSuLmjc32KXSo6eF6opebf5IoQUGVLleGDZlo6t59Mids8wlsZy6rSlQ+NnU9aVC+egeDbbxS7xDiGt2QA0cK5XV0VJPa9rajIVakGtZjVUcOYAoAsEur7MpZaeGe9/BCP+RqpUZGLASzXj1U2oqGVPLE3DOcvYGRNskKbM9WbBBN9yuIM9if1eegKkqvviu+LiBEqBTRDPZnwXdpLoRGc9D8jFrkYtPD4tS38Lxy3ewtOebFbV3OChqHs4bKGUP/MGMnyx2SNHE/RhgUpi3qovTwHQaPWeI4KId7pdjQ9aVK5PgZg4j9eVxuI2MQAO8MGrK2gV0QDvrkj6jW3Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FxcHnHz2owbLfC/zo6w0n2wuNmzuJVuUy/6CbDzmE3U=;
 b=OcUponVtWhyfif7t2e/OByq0q4b3kNMvS9zWZ92hyeDjcudEoEzDQ3/o7HMFPNQnF17keE4v4s1X8zWsYXVjDUu972vPYCcT0GxflpoCGnlJgykfmDLQAnYAOPJWNChyRHw6jdleGUCFNLeokg5x/4O5QHE6CFxKH6hrmCQ2JLNFJSmOobNq/eVFcRODjwxC346sEOWPQ2TdalvV3AF6b7gofZlGoAMCY4jwWY8oiGm1ogCUa9cF2YxmcH6pe6FO2HodADGm+LEelWcFlpeNKNO3xdxxeQb7wstQHAT1zIjWHnSJ5ZyjqEiYWyNMwtiLpF2nnFvoUnDjSaWxrj1QCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=thebollingers.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FxcHnHz2owbLfC/zo6w0n2wuNmzuJVuUy/6CbDzmE3U=;
 b=neF1qMl6K74VtyBJeH2wk3BCvIn23jGwh2180L8uBNWluEWQWvOM1wC5PMrrVVbWRNSZqsg78oaEEAXR6Yhv5zdlLm1mw9fc92vFLWifXvAI/HraDZKBcShNIBkQOH3htaMMN7qoEs3EnIjgVYQZPUggUakyCLeHtUsN96AFvME1RP6KucsMyrThDSjhD8yBfeq0u+Cu61Oy6tWLpYnY0gYoD9qmYC3pvEuTme8irDUnYRxi5o3YfLy9uWBMZTNx3igCxtyRFOy6OLql2fWnjnJIScIC3cXXDoyFeNtdOFuw4omXOhldn6gA0vhhpxqwms+Gqbh33MOOnegJiF69QA==
Received: from MW4PR03CA0317.namprd03.prod.outlook.com (2603:10b6:303:dd::22)
 by DM4PR12MB5389.namprd12.prod.outlook.com (2603:10b6:5:39a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Tue, 8 Jun
 2021 10:34:16 +0000
Received: from CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dd:cafe::31) by MW4PR03CA0317.outlook.office365.com
 (2603:10b6:303:dd::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend
 Transport; Tue, 8 Jun 2021 10:34:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; thebollingers.org; dkim=none (message not signed)
 header.d=none;thebollingers.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT036.mail.protection.outlook.com (10.13.174.124) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Tue, 8 Jun 2021 10:34:16 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 8 Jun
 2021 10:34:15 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 8 Jun 2021 10:34:09 +0000
From:   Moshe Shemesh <moshe@nvidia.com>
To:     Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Don Bollinger <don@thebollingers.org>, <netdev@vger.kernel.org>
CC:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH ethtool v3 3/4] ethtool: Rename QSFP-DD identifiers to use CMIS
Date:   Tue, 8 Jun 2021 13:32:27 +0300
Message-ID: <1623148348-2033898-4-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1623148348-2033898-1-git-send-email-moshe@nvidia.com>
References: <1623148348-2033898-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9ca935c-6d0f-4cb1-da7f-08d92a68f72e
X-MS-TrafficTypeDiagnostic: DM4PR12MB5389:
X-Microsoft-Antispam-PRVS: <DM4PR12MB53896EF3A52C8AAB27037A84D4379@DM4PR12MB5389.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xfpKCRgR4rkSwvSXttyfcocaAEGPyXhe5+vpNCLZXmhs+6vzMe6rUFwMerR7sJvHPzGRUAEl9q2Jk/OeLl4BWTwtD4FZMD6EsipIDFa8E0APXFVv7th/LhIWKAWuNZUitATFKZtUvDfJSApJVWqlLDvL6O65xmz4tw/QdDmJQwhcfgS1u6KVFomVz/4Dmyc/wjG4PgsbcMhU1gQu7qemyeO3EdCpP7o9OLThMVkT0QYhTyUuTN93nQVijf+3YhZ1kW6kyXI81IsDcYBi2Y8LuUVVyzQ026SkKngGHNF+oPGY+THpw7QUc5AiErzyImZ7hUFcLoO9np2v2YY2V9SPdJ1P0RVjZ50rtssL91LpX5qLiu00UQLaZLabrQmeZo2X85k5boVmlaamOFdqMp12CQiP8clq8NLkRCU9kdj7JkHYLXb6RD6XHTYk0p3fFxXn0cPbg17F+SDA7X0fz8pM+4BDegNVm4/j75Hu/Epft3pgvOlPOac0Sj/ox3bZZWpFKbW6lp9axkqGMwdZbiUyTIAYe8N+iBD/ma/4AgolOblpubm12gwPpUiOuzty2yNMO3jNSCG5uSxavQxm1UO4SlyR3y6GgfDQ5MgTnrBTaRS9MH55Yix32VExahxYbC/RRKm4iu2eSaKCj+GXQz35Yf4MRJBirVdGJLg25uqKTJs=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(396003)(346002)(46966006)(36840700001)(107886003)(83380400001)(30864003)(82310400003)(82740400003)(2616005)(36756003)(426003)(26005)(70206006)(8936002)(6666004)(7636003)(356005)(54906003)(2906002)(36906005)(336012)(316002)(8676002)(70586007)(186003)(110136005)(7696005)(4326008)(86362001)(47076005)(478600001)(5660300002)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 10:34:16.0554
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9ca935c-6d0f-4cb1-da7f-08d92a68f72e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5389
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>

QSFP-DD and DSFP EEPROM layout complies to CMIS specification. As DSFP
support is added, there are currently two standards, which share the
same infrastructure. Rename QSFP_DD and qsfp_dd occurrences to use CMIS
or cmis respectively to make function names generic for any module
compliant to CMIS 4.0 or future CMIS versions.

Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
---
 Makefile.am             |   2 +-
 cmis.c                  | 359 ++++++++++++++++++++++++++++++++++++++++++++++++
 cmis.h                  | 128 +++++++++++++++++
 netlink/module-eeprom.c |   2 +-
 qsfp-dd.c               | 359 ------------------------------------------------
 qsfp-dd.h               | 128 -----------------
 qsfp.c                  |   2 +-
 7 files changed, 490 insertions(+), 490 deletions(-)
 create mode 100644 cmis.c
 create mode 100644 cmis.h
 delete mode 100644 qsfp-dd.c
 delete mode 100644 qsfp-dd.h

diff --git a/Makefile.am b/Makefile.am
index 6abd2b7..73233fb 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -17,7 +17,7 @@ ethtool_SOURCES += \
 		  smsc911x.c at76c50x-usb.c sfc.c stmmac.c	\
 		  sff-common.c sff-common.h sfpid.c sfpdiag.c	\
 		  ixgbevf.c tse.c vmxnet3.c qsfp.c qsfp.h fjes.c lan78xx.c \
-		  igc.c qsfp-dd.c qsfp-dd.h bnxt.c
+		  igc.c cmis.c cmis.h bnxt.c
 endif
 
 if ENABLE_BASH_COMPLETION
diff --git a/cmis.c b/cmis.c
new file mode 100644
index 0000000..361b721
--- /dev/null
+++ b/cmis.c
@@ -0,0 +1,359 @@
+/**
+ * Description:
+ *
+ * This module adds QSFP-DD support to ethtool. The changes are similar to
+ * the ones already existing in qsfp.c, but customized to use the memory
+ * addresses and logic as defined in the specification's document.
+ *
+ */
+
+#include <stdio.h>
+#include <math.h>
+#include "internal.h"
+#include "sff-common.h"
+#include "cmis.h"
+
+static void cmis_show_identifier(const __u8 *id)
+{
+	sff8024_show_identifier(id, CMIS_ID_OFFSET);
+}
+
+static void cmis_show_connector(const __u8 *id)
+{
+	sff8024_show_connector(id, CMIS_CTOR_OFFSET);
+}
+
+static void cmis_show_oui(const __u8 *id)
+{
+	sff8024_show_oui(id, CMIS_VENDOR_OUI_OFFSET);
+}
+
+/**
+ * Print the revision compliance. Relevant documents:
+ * [1] CMIS Rev. 3, pag. 45, section 1.7.2.1, Table 18
+ * [2] CMIS Rev. 4, pag. 81, section 8.2.1, Table 8-2
+ */
+static void cmis_show_rev_compliance(const __u8 *id)
+{
+	__u8 rev = id[CMIS_REV_COMPLIANCE_OFFSET];
+	int major = (rev >> 4) & 0x0F;
+	int minor = rev & 0x0F;
+
+	printf("\t%-41s : Rev. %d.%d\n", "Revision compliance", major, minor);
+}
+
+/**
+ * Print information about the device's power consumption.
+ * Relevant documents:
+ * [1] CMIS Rev. 3, pag. 59, section 1.7.3.9, Table 30
+ * [2] CMIS Rev. 4, pag. 94, section 8.3.9, Table 8-18
+ * [3] QSFP-DD Hardware Rev 5.0, pag. 22, section 4.2.1
+ */
+static void cmis_show_power_info(const __u8 *id)
+{
+	float max_power = 0.0f;
+	__u8 base_power = 0;
+	__u8 power_class;
+
+	/* Get the power class (first 3 most significat bytes) */
+	power_class = (id[CMIS_PWR_CLASS_OFFSET] >> 5) & 0x07;
+
+	/* Get the base power in multiples of 0.25W */
+	base_power = id[CMIS_PWR_MAX_POWER_OFFSET];
+	max_power = base_power * 0.25f;
+
+	printf("\t%-41s : %d\n", "Power class", power_class + 1);
+	printf("\t%-41s : %.02fW\n", "Max power", max_power);
+}
+
+/**
+ * Print the cable assembly length, for both passive copper and active
+ * optical or electrical cables. The base length (bits 5-0) must be
+ * multiplied with the SMF length multiplier (bits 7-6) to obtain the
+ * correct value. Relevant documents:
+ * [1] CMIS Rev. 3, pag. 59, section 1.7.3.10, Table 31
+ * [2] CMIS Rev. 4, pag. 94, section 8.3.10, Table 8-19
+ */
+static void cmis_show_cbl_asm_len(const __u8 *id)
+{
+	static const char *fn = "Cable assembly length";
+	float mul = 1.0f;
+	float val = 0.0f;
+
+	/* Check if max length */
+	if (id[CMIS_CBL_ASM_LEN_OFFSET] == CMIS_6300M_MAX_LEN) {
+		printf("\t%-41s : > 6.3km\n", fn);
+		return;
+	}
+
+	/* Get the multiplier from the first two bits */
+	switch (id[CMIS_CBL_ASM_LEN_OFFSET] & CMIS_LEN_MUL_MASK) {
+	case CMIS_MULTIPLIER_00:
+		mul = 0.1f;
+		break;
+	case CMIS_MULTIPLIER_01:
+		mul = 1.0f;
+		break;
+	case CMIS_MULTIPLIER_10:
+		mul = 10.0f;
+		break;
+	case CMIS_MULTIPLIER_11:
+		mul = 100.0f;
+		break;
+	default:
+		break;
+	}
+
+	/* Get base value from first 6 bits and multiply by mul */
+	val = (id[CMIS_CBL_ASM_LEN_OFFSET] & CMIS_LEN_VAL_MASK);
+	val = (float)val * mul;
+	printf("\t%-41s : %0.2fm\n", fn, val);
+}
+
+/**
+ * Print the length for SMF fiber. The base length (bits 5-0) must be
+ * multiplied with the SMF length multiplier (bits 7-6) to obtain the
+ * correct value. Relevant documents:
+ * [1] CMIS Rev. 3, pag. 63, section 1.7.4.2, Table 39
+ * [2] CMIS Rev. 4, pag. 99, section 8.4.2, Table 8-27
+ */
+static void cmis_print_smf_cbl_len(const __u8 *id)
+{
+	static const char *fn = "Length (SMF)";
+	float mul = 1.0f;
+	float val = 0.0f;
+
+	/* Get the multiplier from the first two bits */
+	switch (id[CMIS_SMF_LEN_OFFSET] & CMIS_LEN_MUL_MASK) {
+	case CMIS_MULTIPLIER_00:
+		mul = 0.1f;
+		break;
+	case CMIS_MULTIPLIER_01:
+		mul = 1.0f;
+		break;
+	default:
+		break;
+	}
+
+	/* Get base value from first 6 bits and multiply by mul */
+	val = (id[CMIS_SMF_LEN_OFFSET] & CMIS_LEN_VAL_MASK);
+	val = (float)val * mul;
+	printf("\t%-41s : %0.2fkm\n", fn, val);
+}
+
+/**
+ * Print relevant signal integrity control properties. Relevant documents:
+ * [1] CMIS Rev. 3, pag. 71, section 1.7.4.10, Table 46
+ * [2] CMIS Rev. 4, pag. 105, section 8.4.10, Table 8-34
+ */
+static void cmis_show_sig_integrity(const __u8 *id)
+{
+	/* CDR Bypass control: 2nd bit from each byte */
+	printf("\t%-41s : ", "Tx CDR bypass control");
+	printf("%s\n", YESNO(id[CMIS_SIG_INTEG_TX_OFFSET] & 0x02));
+
+	printf("\t%-41s : ", "Rx CDR bypass control");
+	printf("%s\n", YESNO(id[CMIS_SIG_INTEG_RX_OFFSET] & 0x02));
+
+	/* CDR Implementation: 1st bit from each byte */
+	printf("\t%-41s : ", "Tx CDR");
+	printf("%s\n", YESNO(id[CMIS_SIG_INTEG_TX_OFFSET] & 0x01));
+
+	printf("\t%-41s : ", "Rx CDR");
+	printf("%s\n", YESNO(id[CMIS_SIG_INTEG_RX_OFFSET] & 0x01));
+}
+
+/**
+ * Print relevant media interface technology info. Relevant documents:
+ * [1] CMIS Rev. 3
+ * --> pag. 61, section 1.7.3.14, Table 36
+ * --> pag. 64, section 1.7.4.3, 1.7.4.4
+ * [2] CMIS Rev. 4
+ * --> pag. 97, section 8.3.14, Table 8-24
+ * --> pag. 98, section 8.4, Table 8-25
+ * --> page 100, section 8.4.3, 8.4.4
+ */
+static void cmis_show_mit_compliance(const __u8 *id)
+{
+	static const char *cc = " (Copper cable,";
+
+	printf("\t%-41s : 0x%02x", "Transmitter technology",
+	       id[CMIS_MEDIA_INTF_TECH_OFFSET]);
+
+	switch (id[CMIS_MEDIA_INTF_TECH_OFFSET]) {
+	case CMIS_850_VCSEL:
+		printf(" (850 nm VCSEL)\n");
+		break;
+	case CMIS_1310_VCSEL:
+		printf(" (1310 nm VCSEL)\n");
+		break;
+	case CMIS_1550_VCSEL:
+		printf(" (1550 nm VCSEL)\n");
+		break;
+	case CMIS_1310_FP:
+		printf(" (1310 nm FP)\n");
+		break;
+	case CMIS_1310_DFB:
+		printf(" (1310 nm DFB)\n");
+		break;
+	case CMIS_1550_DFB:
+		printf(" (1550 nm DFB)\n");
+		break;
+	case CMIS_1310_EML:
+		printf(" (1310 nm EML)\n");
+		break;
+	case CMIS_1550_EML:
+		printf(" (1550 nm EML)\n");
+		break;
+	case CMIS_OTHERS:
+		printf(" (Others/Undefined)\n");
+		break;
+	case CMIS_1490_DFB:
+		printf(" (1490 nm DFB)\n");
+		break;
+	case CMIS_COPPER_UNEQUAL:
+		printf("%s unequalized)\n", cc);
+		break;
+	case CMIS_COPPER_PASS_EQUAL:
+		printf("%s passive equalized)\n", cc);
+		break;
+	case CMIS_COPPER_NF_EQUAL:
+		printf("%s near and far end limiting active equalizers)\n", cc);
+		break;
+	case CMIS_COPPER_F_EQUAL:
+		printf("%s far end limiting active equalizers)\n", cc);
+		break;
+	case CMIS_COPPER_N_EQUAL:
+		printf("%s near end limiting active equalizers)\n", cc);
+		break;
+	case CMIS_COPPER_LINEAR_EQUAL:
+		printf("%s linear active equalizers)\n", cc);
+		break;
+	}
+
+	if (id[CMIS_MEDIA_INTF_TECH_OFFSET] >= CMIS_COPPER_UNEQUAL) {
+		printf("\t%-41s : %udb\n", "Attenuation at 5GHz",
+		       id[CMIS_COPPER_ATT_5GHZ]);
+		printf("\t%-41s : %udb\n", "Attenuation at 7GHz",
+		       id[CMIS_COPPER_ATT_7GHZ]);
+		printf("\t%-41s : %udb\n", "Attenuation at 12.9GHz",
+		       id[CMIS_COPPER_ATT_12P9GHZ]);
+		printf("\t%-41s : %udb\n", "Attenuation at 25.8GHz",
+		       id[CMIS_COPPER_ATT_25P8GHZ]);
+	} else {
+		printf("\t%-41s : %.3lfnm\n", "Laser wavelength",
+		       (((id[CMIS_NOM_WAVELENGTH_MSB] << 8) |
+				id[CMIS_NOM_WAVELENGTH_LSB]) * 0.05));
+		printf("\t%-41s : %.3lfnm\n", "Laser wavelength tolerance",
+		       (((id[CMIS_WAVELENGTH_TOL_MSB] << 8) |
+		       id[CMIS_WAVELENGTH_TOL_LSB]) * 0.005));
+	}
+}
+
+/*
+ * 2-byte internal temperature conversions:
+ * First byte is a signed 8-bit integer, which is the temp decimal part
+ * Second byte is a multiple of 1/256th of a degree, which is added to
+ * the dec part.
+ */
+#define OFFSET_TO_TEMP(offset) ((__s16)OFFSET_TO_U16(offset))
+
+/**
+ * Print relevant module level monitoring values. Relevant documents:
+ * [1] CMIS Rev. 3:
+ * --> pag. 50, section 1.7.2.4, Table 22
+ *
+ * [2] CMIS Rev. 4:
+ * --> pag. 84, section 8.2.4, Table 8-6
+ */
+static void cmis_show_mod_lvl_monitors(const __u8 *id)
+{
+	PRINT_TEMP("Module temperature",
+		   OFFSET_TO_TEMP(CMIS_CURR_TEMP_OFFSET));
+	PRINT_VCC("Module voltage",
+		  OFFSET_TO_U16(CMIS_CURR_CURR_OFFSET));
+}
+
+static void cmis_show_link_len_from_page(const __u8 *page_one_data)
+{
+	cmis_print_smf_cbl_len(page_one_data);
+	sff_show_value_with_unit(page_one_data, CMIS_OM5_LEN_OFFSET,
+				 "Length (OM5)", 2, "m");
+	sff_show_value_with_unit(page_one_data, CMIS_OM4_LEN_OFFSET,
+				 "Length (OM4)", 2, "m");
+	sff_show_value_with_unit(page_one_data, CMIS_OM3_LEN_OFFSET,
+				 "Length (OM3 50/125um)", 2, "m");
+	sff_show_value_with_unit(page_one_data, CMIS_OM2_LEN_OFFSET,
+				 "Length (OM2 50/125um)", 1, "m");
+}
+
+
+/**
+ * Print relevant info about the maximum supported fiber media length
+ * for each type of fiber media at the maximum module-supported bit rate.
+ * Relevant documents:
+ * [1] CMIS Rev. 3, page 64, section 1.7.4.2, Table 39
+ * [2] CMIS Rev. 4, page 99, section 8.4.2, Table 8-27
+ */
+static void cmis_show_link_len(const __u8 *id)
+{
+	cmis_show_link_len_from_page(id + PAG01H_UPPER_OFFSET);
+}
+
+/**
+ * Show relevant information about the vendor. Relevant documents:
+ * [1] CMIS Rev. 3, page 56, section 1.7.3, Table 27
+ * [2] CMIS Rev. 4, page 91, section 8.2, Table 8-15
+ */
+static void cmis_show_vendor_info(const __u8 *id)
+{
+	sff_show_ascii(id, CMIS_VENDOR_NAME_START_OFFSET,
+		       CMIS_VENDOR_NAME_END_OFFSET, "Vendor name");
+	cmis_show_oui(id);
+	sff_show_ascii(id, CMIS_VENDOR_PN_START_OFFSET,
+		       CMIS_VENDOR_PN_END_OFFSET, "Vendor PN");
+	sff_show_ascii(id, CMIS_VENDOR_REV_START_OFFSET,
+		       CMIS_VENDOR_REV_END_OFFSET, "Vendor rev");
+	sff_show_ascii(id, CMIS_VENDOR_SN_START_OFFSET,
+		       CMIS_VENDOR_SN_END_OFFSET, "Vendor SN");
+	sff_show_ascii(id, CMIS_DATE_YEAR_OFFSET,
+		       CMIS_DATE_VENDOR_LOT_OFFSET + 1, "Date code");
+
+	if (id[CMIS_CLEI_PRESENT_BYTE] & CMIS_CLEI_PRESENT_MASK)
+		sff_show_ascii(id, CMIS_CLEI_START_OFFSET,
+			       CMIS_CLEI_END_OFFSET, "CLEI code");
+}
+
+void qsfp_dd_show_all(const __u8 *id)
+{
+	cmis_show_identifier(id);
+	cmis_show_power_info(id);
+	cmis_show_connector(id);
+	cmis_show_cbl_asm_len(id);
+	cmis_show_sig_integrity(id);
+	cmis_show_mit_compliance(id);
+	cmis_show_mod_lvl_monitors(id);
+	cmis_show_link_len(id);
+	cmis_show_vendor_info(id);
+	cmis_show_rev_compliance(id);
+}
+
+void cmis_show_all(const struct ethtool_module_eeprom *page_zero,
+		   const struct ethtool_module_eeprom *page_one)
+{
+	const __u8 *page_zero_data = page_zero->data;
+
+	cmis_show_identifier(page_zero_data);
+	cmis_show_power_info(page_zero_data);
+	cmis_show_connector(page_zero_data);
+	cmis_show_cbl_asm_len(page_zero_data);
+	cmis_show_sig_integrity(page_zero_data);
+	cmis_show_mit_compliance(page_zero_data);
+	cmis_show_mod_lvl_monitors(page_zero_data);
+
+	if (page_one)
+		cmis_show_link_len_from_page(page_one->data - 0x80);
+
+	cmis_show_vendor_info(page_zero_data);
+	cmis_show_rev_compliance(page_zero_data);
+}
diff --git a/cmis.h b/cmis.h
new file mode 100644
index 0000000..5b7ac38
--- /dev/null
+++ b/cmis.h
@@ -0,0 +1,128 @@
+#ifndef CMIS_H__
+#define CMIS_H__
+
+/* Identifier and revision compliance (Page 0) */
+#define CMIS_ID_OFFSET				0x00
+#define CMIS_REV_COMPLIANCE_OFFSET		0x01
+
+#define CMIS_MODULE_TYPE_OFFSET			0x55
+#define CMIS_MT_MMF				0x01
+#define CMIS_MT_SMF				0x02
+
+/* Module-Level Monitors (Page 0) */
+#define CMIS_CURR_TEMP_OFFSET			0x0E
+#define CMIS_CURR_CURR_OFFSET			0x10
+
+#define CMIS_CTOR_OFFSET			0xCB
+
+/* Vendor related information (Page 0) */
+#define CMIS_VENDOR_NAME_START_OFFSET		0x81
+#define CMIS_VENDOR_NAME_END_OFFSET		0x90
+
+#define CMIS_VENDOR_OUI_OFFSET			0x91
+
+#define CMIS_VENDOR_PN_START_OFFSET		0x94
+#define CMIS_VENDOR_PN_END_OFFSET		0xA3
+
+#define CMIS_VENDOR_REV_START_OFFSET		0xA4
+#define CMIS_VENDOR_REV_END_OFFSET		0xA5
+
+#define CMIS_VENDOR_SN_START_OFFSET		0xA6
+#define CMIS_VENDOR_SN_END_OFFSET		0xB5
+
+#define CMIS_DATE_YEAR_OFFSET			0xB6
+#define CMIS_DATE_VENDOR_LOT_OFFSET		0xBC
+
+/* CLEI Code (Page 0) */
+#define CMIS_CLEI_PRESENT_BYTE			0x02
+#define CMIS_CLEI_PRESENT_MASK			0x20
+#define CMIS_CLEI_START_OFFSET			0xBE
+#define CMIS_CLEI_END_OFFSET			0xC7
+
+/* Cable assembly length */
+#define CMIS_CBL_ASM_LEN_OFFSET			0xCA
+#define CMIS_6300M_MAX_LEN			0xFF
+
+/* Cable length with multiplier */
+#define CMIS_MULTIPLIER_00			0x00
+#define CMIS_MULTIPLIER_01			0x40
+#define CMIS_MULTIPLIER_10			0x80
+#define CMIS_MULTIPLIER_11			0xC0
+#define CMIS_LEN_MUL_MASK			0xC0
+#define CMIS_LEN_VAL_MASK			0x3F
+
+/* Module power characteristics */
+#define CMIS_PWR_CLASS_OFFSET			0xC8
+#define CMIS_PWR_MAX_POWER_OFFSET		0xC9
+#define CMIS_PWR_CLASS_MASK			0xE0
+#define CMIS_PWR_CLASS_1			0x00
+#define CMIS_PWR_CLASS_2			0x01
+#define CMIS_PWR_CLASS_3			0x02
+#define CMIS_PWR_CLASS_4			0x03
+#define CMIS_PWR_CLASS_5			0x04
+#define CMIS_PWR_CLASS_6			0x05
+#define CMIS_PWR_CLASS_7			0x06
+#define CMIS_PWR_CLASS_8			0x07
+
+/* Copper cable attenuation */
+#define CMIS_COPPER_ATT_5GHZ			0xCC
+#define CMIS_COPPER_ATT_7GHZ			0xCD
+#define CMIS_COPPER_ATT_12P9GHZ			0xCE
+#define CMIS_COPPER_ATT_25P8GHZ			0xCF
+
+/* Cable assembly lane */
+#define CMIS_CABLE_ASM_NEAR_END_OFFSET		0xD2
+#define CMIS_CABLE_ASM_FAR_END_OFFSET		0xD3
+
+/* Media interface technology */
+#define CMIS_MEDIA_INTF_TECH_OFFSET		0xD4
+#define CMIS_850_VCSEL				0x00
+#define CMIS_1310_VCSEL				0x01
+#define CMIS_1550_VCSEL				0x02
+#define CMIS_1310_FP				0x03
+#define CMIS_1310_DFB				0x04
+#define CMIS_1550_DFB				0x05
+#define CMIS_1310_EML				0x06
+#define CMIS_1550_EML				0x07
+#define CMIS_OTHERS				0x08
+#define CMIS_1490_DFB				0x09
+#define CMIS_COPPER_UNEQUAL			0x0A
+#define CMIS_COPPER_PASS_EQUAL			0x0B
+#define CMIS_COPPER_NF_EQUAL			0x0C
+#define CMIS_COPPER_F_EQUAL			0x0D
+#define CMIS_COPPER_N_EQUAL			0x0E
+#define CMIS_COPPER_LINEAR_EQUAL		0x0F
+
+/*-----------------------------------------------------------------------
+ * Upper Memory Page 0x01: contains advertising fields that define properties
+ * that are unique to active modules and cable assemblies.
+ * GlobalOffset = 2 * 0x80 + LocalOffset
+ */
+#define PAG01H_UPPER_OFFSET			(0x02 * 0x80)
+
+/* Supported Link Length (Page 1) */
+#define CMIS_SMF_LEN_OFFSET			0x84
+#define CMIS_OM5_LEN_OFFSET			0x85
+#define CMIS_OM4_LEN_OFFSET			0x86
+#define CMIS_OM3_LEN_OFFSET			0x87
+#define CMIS_OM2_LEN_OFFSET			0x88
+
+/* Wavelength (Page 1) */
+#define CMIS_NOM_WAVELENGTH_MSB			0x8A
+#define CMIS_NOM_WAVELENGTH_LSB			0x8B
+#define CMIS_WAVELENGTH_TOL_MSB			0x8C
+#define CMIS_WAVELENGTH_TOL_LSB			0x8D
+
+/* Signal integrity controls */
+#define CMIS_SIG_INTEG_TX_OFFSET		0xA1
+#define CMIS_SIG_INTEG_RX_OFFSET		0xA2
+
+#define YESNO(x) (((x) != 0) ? "Yes" : "No")
+#define ONOFF(x) (((x) != 0) ? "On" : "Off")
+
+void qsfp_dd_show_all(const __u8 *id);
+
+void cmis4_show_all(const struct ethtool_module_eeprom *page_zero,
+		    const struct ethtool_module_eeprom *page_one);
+
+#endif /* CMIS_H__ */
diff --git a/netlink/module-eeprom.c b/netlink/module-eeprom.c
index 664f5c6..355d1de 100644
--- a/netlink/module-eeprom.c
+++ b/netlink/module-eeprom.c
@@ -11,7 +11,7 @@
 
 #include "../sff-common.h"
 #include "../qsfp.h"
-#include "../qsfp-dd.h"
+#include "../cmis.h"
 #include "../internal.h"
 #include "../common.h"
 #include "../list.h"
diff --git a/qsfp-dd.c b/qsfp-dd.c
deleted file mode 100644
index 55adbcb..0000000
--- a/qsfp-dd.c
+++ /dev/null
@@ -1,359 +0,0 @@
-/**
- * Description:
- *
- * This module adds QSFP-DD support to ethtool. The changes are similar to
- * the ones already existing in qsfp.c, but customized to use the memory
- * addresses and logic as defined in the specification's document.
- *
- */
-
-#include <stdio.h>
-#include <math.h>
-#include "internal.h"
-#include "sff-common.h"
-#include "qsfp-dd.h"
-
-static void qsfp_dd_show_identifier(const __u8 *id)
-{
-	sff8024_show_identifier(id, QSFP_DD_ID_OFFSET);
-}
-
-static void qsfp_dd_show_connector(const __u8 *id)
-{
-	sff8024_show_connector(id, QSFP_DD_CTOR_OFFSET);
-}
-
-static void qsfp_dd_show_oui(const __u8 *id)
-{
-	sff8024_show_oui(id, QSFP_DD_VENDOR_OUI_OFFSET);
-}
-
-/**
- * Print the revision compliance. Relevant documents:
- * [1] CMIS Rev. 3, pag. 45, section 1.7.2.1, Table 18
- * [2] CMIS Rev. 4, pag. 81, section 8.2.1, Table 8-2
- */
-static void qsfp_dd_show_rev_compliance(const __u8 *id)
-{
-	__u8 rev = id[QSFP_DD_REV_COMPLIANCE_OFFSET];
-	int major = (rev >> 4) & 0x0F;
-	int minor = rev & 0x0F;
-
-	printf("\t%-41s : Rev. %d.%d\n", "Revision compliance", major, minor);
-}
-
-/**
- * Print information about the device's power consumption.
- * Relevant documents:
- * [1] CMIS Rev. 3, pag. 59, section 1.7.3.9, Table 30
- * [2] CMIS Rev. 4, pag. 94, section 8.3.9, Table 8-18
- * [3] QSFP-DD Hardware Rev 5.0, pag. 22, section 4.2.1
- */
-static void qsfp_dd_show_power_info(const __u8 *id)
-{
-	float max_power = 0.0f;
-	__u8 base_power = 0;
-	__u8 power_class;
-
-	/* Get the power class (first 3 most significat bytes) */
-	power_class = (id[QSFP_DD_PWR_CLASS_OFFSET] >> 5) & 0x07;
-
-	/* Get the base power in multiples of 0.25W */
-	base_power = id[QSFP_DD_PWR_MAX_POWER_OFFSET];
-	max_power = base_power * 0.25f;
-
-	printf("\t%-41s : %d\n", "Power class", power_class + 1);
-	printf("\t%-41s : %.02fW\n", "Max power", max_power);
-}
-
-/**
- * Print the cable assembly length, for both passive copper and active
- * optical or electrical cables. The base length (bits 5-0) must be
- * multiplied with the SMF length multiplier (bits 7-6) to obtain the
- * correct value. Relevant documents:
- * [1] CMIS Rev. 3, pag. 59, section 1.7.3.10, Table 31
- * [2] CMIS Rev. 4, pag. 94, section 8.3.10, Table 8-19
- */
-static void qsfp_dd_show_cbl_asm_len(const __u8 *id)
-{
-	static const char *fn = "Cable assembly length";
-	float mul = 1.0f;
-	float val = 0.0f;
-
-	/* Check if max length */
-	if (id[QSFP_DD_CBL_ASM_LEN_OFFSET] == QSFP_DD_6300M_MAX_LEN) {
-		printf("\t%-41s : > 6.3km\n", fn);
-		return;
-	}
-
-	/* Get the multiplier from the first two bits */
-	switch (id[QSFP_DD_CBL_ASM_LEN_OFFSET] & QSFP_DD_LEN_MUL_MASK) {
-	case QSFP_DD_MULTIPLIER_00:
-		mul = 0.1f;
-		break;
-	case QSFP_DD_MULTIPLIER_01:
-		mul = 1.0f;
-		break;
-	case QSFP_DD_MULTIPLIER_10:
-		mul = 10.0f;
-		break;
-	case QSFP_DD_MULTIPLIER_11:
-		mul = 100.0f;
-		break;
-	default:
-		break;
-	}
-
-	/* Get base value from first 6 bits and multiply by mul */
-	val = (id[QSFP_DD_CBL_ASM_LEN_OFFSET] & QSFP_DD_LEN_VAL_MASK);
-	val = (float)val * mul;
-	printf("\t%-41s : %0.2fm\n", fn, val);
-}
-
-/**
- * Print the length for SMF fiber. The base length (bits 5-0) must be
- * multiplied with the SMF length multiplier (bits 7-6) to obtain the
- * correct value. Relevant documents:
- * [1] CMIS Rev. 3, pag. 63, section 1.7.4.2, Table 39
- * [2] CMIS Rev. 4, pag. 99, section 8.4.2, Table 8-27
- */
-static void qsfp_dd_print_smf_cbl_len(const __u8 *id)
-{
-	static const char *fn = "Length (SMF)";
-	float mul = 1.0f;
-	float val = 0.0f;
-
-	/* Get the multiplier from the first two bits */
-	switch (id[QSFP_DD_SMF_LEN_OFFSET] & QSFP_DD_LEN_MUL_MASK) {
-	case QSFP_DD_MULTIPLIER_00:
-		mul = 0.1f;
-		break;
-	case QSFP_DD_MULTIPLIER_01:
-		mul = 1.0f;
-		break;
-	default:
-		break;
-	}
-
-	/* Get base value from first 6 bits and multiply by mul */
-	val = (id[QSFP_DD_SMF_LEN_OFFSET] & QSFP_DD_LEN_VAL_MASK);
-	val = (float)val * mul;
-	printf("\t%-41s : %0.2fkm\n", fn, val);
-}
-
-/**
- * Print relevant signal integrity control properties. Relevant documents:
- * [1] CMIS Rev. 3, pag. 71, section 1.7.4.10, Table 46
- * [2] CMIS Rev. 4, pag. 105, section 8.4.10, Table 8-34
- */
-static void qsfp_dd_show_sig_integrity(const __u8 *id)
-{
-	/* CDR Bypass control: 2nd bit from each byte */
-	printf("\t%-41s : ", "Tx CDR bypass control");
-	printf("%s\n", YESNO(id[QSFP_DD_SIG_INTEG_TX_OFFSET] & 0x02));
-
-	printf("\t%-41s : ", "Rx CDR bypass control");
-	printf("%s\n", YESNO(id[QSFP_DD_SIG_INTEG_RX_OFFSET] & 0x02));
-
-	/* CDR Implementation: 1st bit from each byte */
-	printf("\t%-41s : ", "Tx CDR");
-	printf("%s\n", YESNO(id[QSFP_DD_SIG_INTEG_TX_OFFSET] & 0x01));
-
-	printf("\t%-41s : ", "Rx CDR");
-	printf("%s\n", YESNO(id[QSFP_DD_SIG_INTEG_RX_OFFSET] & 0x01));
-}
-
-/**
- * Print relevant media interface technology info. Relevant documents:
- * [1] CMIS Rev. 3
- * --> pag. 61, section 1.7.3.14, Table 36
- * --> pag. 64, section 1.7.4.3, 1.7.4.4
- * [2] CMIS Rev. 4
- * --> pag. 97, section 8.3.14, Table 8-24
- * --> pag. 98, section 8.4, Table 8-25
- * --> page 100, section 8.4.3, 8.4.4
- */
-static void qsfp_dd_show_mit_compliance(const __u8 *id)
-{
-	static const char *cc = " (Copper cable,";
-
-	printf("\t%-41s : 0x%02x", "Transmitter technology",
-	       id[QSFP_DD_MEDIA_INTF_TECH_OFFSET]);
-
-	switch (id[QSFP_DD_MEDIA_INTF_TECH_OFFSET]) {
-	case QSFP_DD_850_VCSEL:
-		printf(" (850 nm VCSEL)\n");
-		break;
-	case QSFP_DD_1310_VCSEL:
-		printf(" (1310 nm VCSEL)\n");
-		break;
-	case QSFP_DD_1550_VCSEL:
-		printf(" (1550 nm VCSEL)\n");
-		break;
-	case QSFP_DD_1310_FP:
-		printf(" (1310 nm FP)\n");
-		break;
-	case QSFP_DD_1310_DFB:
-		printf(" (1310 nm DFB)\n");
-		break;
-	case QSFP_DD_1550_DFB:
-		printf(" (1550 nm DFB)\n");
-		break;
-	case QSFP_DD_1310_EML:
-		printf(" (1310 nm EML)\n");
-		break;
-	case QSFP_DD_1550_EML:
-		printf(" (1550 nm EML)\n");
-		break;
-	case QSFP_DD_OTHERS:
-		printf(" (Others/Undefined)\n");
-		break;
-	case QSFP_DD_1490_DFB:
-		printf(" (1490 nm DFB)\n");
-		break;
-	case QSFP_DD_COPPER_UNEQUAL:
-		printf("%s unequalized)\n", cc);
-		break;
-	case QSFP_DD_COPPER_PASS_EQUAL:
-		printf("%s passive equalized)\n", cc);
-		break;
-	case QSFP_DD_COPPER_NF_EQUAL:
-		printf("%s near and far end limiting active equalizers)\n", cc);
-		break;
-	case QSFP_DD_COPPER_F_EQUAL:
-		printf("%s far end limiting active equalizers)\n", cc);
-		break;
-	case QSFP_DD_COPPER_N_EQUAL:
-		printf("%s near end limiting active equalizers)\n", cc);
-		break;
-	case QSFP_DD_COPPER_LINEAR_EQUAL:
-		printf("%s linear active equalizers)\n", cc);
-		break;
-	}
-
-	if (id[QSFP_DD_MEDIA_INTF_TECH_OFFSET] >= QSFP_DD_COPPER_UNEQUAL) {
-		printf("\t%-41s : %udb\n", "Attenuation at 5GHz",
-		       id[QSFP_DD_COPPER_ATT_5GHZ]);
-		printf("\t%-41s : %udb\n", "Attenuation at 7GHz",
-		       id[QSFP_DD_COPPER_ATT_7GHZ]);
-		printf("\t%-41s : %udb\n", "Attenuation at 12.9GHz",
-		       id[QSFP_DD_COPPER_ATT_12P9GHZ]);
-		printf("\t%-41s : %udb\n", "Attenuation at 25.8GHz",
-		       id[QSFP_DD_COPPER_ATT_25P8GHZ]);
-	} else {
-		printf("\t%-41s : %.3lfnm\n", "Laser wavelength",
-		       (((id[QSFP_DD_NOM_WAVELENGTH_MSB] << 8) |
-				id[QSFP_DD_NOM_WAVELENGTH_LSB]) * 0.05));
-		printf("\t%-41s : %.3lfnm\n", "Laser wavelength tolerance",
-		       (((id[QSFP_DD_WAVELENGTH_TOL_MSB] << 8) |
-		       id[QSFP_DD_WAVELENGTH_TOL_LSB]) * 0.005));
-	}
-}
-
-/*
- * 2-byte internal temperature conversions:
- * First byte is a signed 8-bit integer, which is the temp decimal part
- * Second byte is a multiple of 1/256th of a degree, which is added to
- * the dec part.
- */
-#define OFFSET_TO_TEMP(offset) ((__s16)OFFSET_TO_U16(offset))
-
-/**
- * Print relevant module level monitoring values. Relevant documents:
- * [1] CMIS Rev. 3:
- * --> pag. 50, section 1.7.2.4, Table 22
- *
- * [2] CMIS Rev. 4:
- * --> pag. 84, section 8.2.4, Table 8-6
- */
-static void qsfp_dd_show_mod_lvl_monitors(const __u8 *id)
-{
-	PRINT_TEMP("Module temperature",
-		   OFFSET_TO_TEMP(QSFP_DD_CURR_TEMP_OFFSET));
-	PRINT_VCC("Module voltage",
-		  OFFSET_TO_U16(QSFP_DD_CURR_CURR_OFFSET));
-}
-
-static void qsfp_dd_show_link_len_from_page(const __u8 *page_one_data)
-{
-	qsfp_dd_print_smf_cbl_len(page_one_data);
-	sff_show_value_with_unit(page_one_data, QSFP_DD_OM5_LEN_OFFSET,
-				 "Length (OM5)", 2, "m");
-	sff_show_value_with_unit(page_one_data, QSFP_DD_OM4_LEN_OFFSET,
-				 "Length (OM4)", 2, "m");
-	sff_show_value_with_unit(page_one_data, QSFP_DD_OM3_LEN_OFFSET,
-				 "Length (OM3 50/125um)", 2, "m");
-	sff_show_value_with_unit(page_one_data, QSFP_DD_OM2_LEN_OFFSET,
-				 "Length (OM2 50/125um)", 1, "m");
-}
-
-
-/**
- * Print relevant info about the maximum supported fiber media length
- * for each type of fiber media at the maximum module-supported bit rate.
- * Relevant documents:
- * [1] CMIS Rev. 3, page 64, section 1.7.4.2, Table 39
- * [2] CMIS Rev. 4, page 99, section 8.4.2, Table 8-27
- */
-static void qsfp_dd_show_link_len(const __u8 *id)
-{
-	qsfp_dd_show_link_len_from_page(id + PAG01H_UPPER_OFFSET);
-}
-
-/**
- * Show relevant information about the vendor. Relevant documents:
- * [1] CMIS Rev. 3, page 56, section 1.7.3, Table 27
- * [2] CMIS Rev. 4, page 91, section 8.2, Table 8-15
- */
-static void qsfp_dd_show_vendor_info(const __u8 *id)
-{
-	sff_show_ascii(id, QSFP_DD_VENDOR_NAME_START_OFFSET,
-		       QSFP_DD_VENDOR_NAME_END_OFFSET, "Vendor name");
-	qsfp_dd_show_oui(id);
-	sff_show_ascii(id, QSFP_DD_VENDOR_PN_START_OFFSET,
-		       QSFP_DD_VENDOR_PN_END_OFFSET, "Vendor PN");
-	sff_show_ascii(id, QSFP_DD_VENDOR_REV_START_OFFSET,
-		       QSFP_DD_VENDOR_REV_END_OFFSET, "Vendor rev");
-	sff_show_ascii(id, QSFP_DD_VENDOR_SN_START_OFFSET,
-		       QSFP_DD_VENDOR_SN_END_OFFSET, "Vendor SN");
-	sff_show_ascii(id, QSFP_DD_DATE_YEAR_OFFSET,
-		       QSFP_DD_DATE_VENDOR_LOT_OFFSET + 1, "Date code");
-
-	if (id[QSFP_DD_CLEI_PRESENT_BYTE] & QSFP_DD_CLEI_PRESENT_MASK)
-		sff_show_ascii(id, QSFP_DD_CLEI_START_OFFSET,
-			       QSFP_DD_CLEI_END_OFFSET, "CLEI code");
-}
-
-void qsfp_dd_show_all(const __u8 *id)
-{
-	qsfp_dd_show_identifier(id);
-	qsfp_dd_show_power_info(id);
-	qsfp_dd_show_connector(id);
-	qsfp_dd_show_cbl_asm_len(id);
-	qsfp_dd_show_sig_integrity(id);
-	qsfp_dd_show_mit_compliance(id);
-	qsfp_dd_show_mod_lvl_monitors(id);
-	qsfp_dd_show_link_len(id);
-	qsfp_dd_show_vendor_info(id);
-	qsfp_dd_show_rev_compliance(id);
-}
-
-void cmis_show_all(const struct ethtool_module_eeprom *page_zero,
-		   const struct ethtool_module_eeprom *page_one)
-{
-	const __u8 *page_zero_data = page_zero->data;
-
-	qsfp_dd_show_identifier(page_zero_data);
-	qsfp_dd_show_power_info(page_zero_data);
-	qsfp_dd_show_connector(page_zero_data);
-	qsfp_dd_show_cbl_asm_len(page_zero_data);
-	qsfp_dd_show_sig_integrity(page_zero_data);
-	qsfp_dd_show_mit_compliance(page_zero_data);
-	qsfp_dd_show_mod_lvl_monitors(page_zero_data);
-
-	if (page_one)
-		qsfp_dd_show_link_len_from_page(page_one->data);
-
-	qsfp_dd_show_vendor_info(page_zero_data);
-	qsfp_dd_show_rev_compliance(page_zero_data);
-}
diff --git a/qsfp-dd.h b/qsfp-dd.h
deleted file mode 100644
index 51f92fa..0000000
--- a/qsfp-dd.h
+++ /dev/null
@@ -1,128 +0,0 @@
-#ifndef QSFP_DD_H__
-#define QSFP_DD_H__
-
-/* Identifier and revision compliance (Page 0) */
-#define QSFP_DD_ID_OFFSET			0x00
-#define QSFP_DD_REV_COMPLIANCE_OFFSET		0x01
-
-#define QSFP_DD_MODULE_TYPE_OFFSET		0x55
-#define QSFP_DD_MT_MMF				0x01
-#define QSFP_DD_MT_SMF				0x02
-
-/* Module-Level Monitors (Page 0) */
-#define QSFP_DD_CURR_TEMP_OFFSET		0x0E
-#define QSFP_DD_CURR_CURR_OFFSET		0x10
-
-#define QSFP_DD_CTOR_OFFSET			0xCB
-
-/* Vendor related information (Page 0) */
-#define QSFP_DD_VENDOR_NAME_START_OFFSET	0x81
-#define QSFP_DD_VENDOR_NAME_END_OFFSET		0x90
-
-#define QSFP_DD_VENDOR_OUI_OFFSET		0x91
-
-#define QSFP_DD_VENDOR_PN_START_OFFSET		0x94
-#define QSFP_DD_VENDOR_PN_END_OFFSET		0xA3
-
-#define QSFP_DD_VENDOR_REV_START_OFFSET		0xA4
-#define QSFP_DD_VENDOR_REV_END_OFFSET		0xA5
-
-#define QSFP_DD_VENDOR_SN_START_OFFSET		0xA6
-#define QSFP_DD_VENDOR_SN_END_OFFSET		0xB5
-
-#define QSFP_DD_DATE_YEAR_OFFSET		0xB6
-#define QSFP_DD_DATE_VENDOR_LOT_OFFSET		0xBC
-
-/* CLEI Code (Page 0) */
-#define QSFP_DD_CLEI_PRESENT_BYTE		0x02
-#define QSFP_DD_CLEI_PRESENT_MASK		0x20
-#define QSFP_DD_CLEI_START_OFFSET		0xBE
-#define QSFP_DD_CLEI_END_OFFSET			0xC7
-
-/* Cable assembly length */
-#define QSFP_DD_CBL_ASM_LEN_OFFSET		0xCA
-#define QSFP_DD_6300M_MAX_LEN			0xFF
-
-/* Cable length with multiplier */
-#define QSFP_DD_MULTIPLIER_00			0x00
-#define QSFP_DD_MULTIPLIER_01			0x40
-#define QSFP_DD_MULTIPLIER_10			0x80
-#define QSFP_DD_MULTIPLIER_11			0xC0
-#define QSFP_DD_LEN_MUL_MASK			0xC0
-#define QSFP_DD_LEN_VAL_MASK			0x3F
-
-/* Module power characteristics */
-#define QSFP_DD_PWR_CLASS_OFFSET		0xC8
-#define QSFP_DD_PWR_MAX_POWER_OFFSET		0xC9
-#define QSFP_DD_PWR_CLASS_MASK			0xE0
-#define QSFP_DD_PWR_CLASS_1			0x00
-#define QSFP_DD_PWR_CLASS_2			0x01
-#define QSFP_DD_PWR_CLASS_3			0x02
-#define QSFP_DD_PWR_CLASS_4			0x03
-#define QSFP_DD_PWR_CLASS_5			0x04
-#define QSFP_DD_PWR_CLASS_6			0x05
-#define QSFP_DD_PWR_CLASS_7			0x06
-#define QSFP_DD_PWR_CLASS_8			0x07
-
-/* Copper cable attenuation */
-#define QSFP_DD_COPPER_ATT_5GHZ			0xCC
-#define QSFP_DD_COPPER_ATT_7GHZ			0xCD
-#define QSFP_DD_COPPER_ATT_12P9GHZ		0xCE
-#define QSFP_DD_COPPER_ATT_25P8GHZ		0xCF
-
-/* Cable assembly lane */
-#define QSFP_DD_CABLE_ASM_NEAR_END_OFFSET	0xD2
-#define QSFP_DD_CABLE_ASM_FAR_END_OFFSET	0xD3
-
-/* Media interface technology */
-#define QSFP_DD_MEDIA_INTF_TECH_OFFSET		0xD4
-#define QSFP_DD_850_VCSEL			0x00
-#define QSFP_DD_1310_VCSEL			0x01
-#define QSFP_DD_1550_VCSEL			0x02
-#define QSFP_DD_1310_FP				0x03
-#define QSFP_DD_1310_DFB			0x04
-#define QSFP_DD_1550_DFB			0x05
-#define QSFP_DD_1310_EML			0x06
-#define QSFP_DD_1550_EML			0x07
-#define QSFP_DD_OTHERS				0x08
-#define QSFP_DD_1490_DFB			0x09
-#define QSFP_DD_COPPER_UNEQUAL			0x0A
-#define QSFP_DD_COPPER_PASS_EQUAL		0x0B
-#define QSFP_DD_COPPER_NF_EQUAL			0x0C
-#define QSFP_DD_COPPER_F_EQUAL			0x0D
-#define QSFP_DD_COPPER_N_EQUAL			0x0E
-#define QSFP_DD_COPPER_LINEAR_EQUAL		0x0F
-
-/*-----------------------------------------------------------------------
- * Upper Memory Page 0x01: contains advertising fields that define properties
- * that are unique to active modules and cable assemblies.
- * GlobalOffset = 2 * 0x80 + LocalOffset
- */
-#define PAG01H_UPPER_OFFSET			(0x02 * 0x80)
-
-/* Supported Link Length (Page 1) */
-#define QSFP_DD_SMF_LEN_OFFSET			0x84
-#define QSFP_DD_OM5_LEN_OFFSET			0x85
-#define QSFP_DD_OM4_LEN_OFFSET			0x86
-#define QSFP_DD_OM3_LEN_OFFSET			0x87
-#define QSFP_DD_OM2_LEN_OFFSET			0x88
-
-/* Wavelength (Page 1) */
-#define QSFP_DD_NOM_WAVELENGTH_MSB		0x8A
-#define QSFP_DD_NOM_WAVELENGTH_LSB		0x8B
-#define QSFP_DD_WAVELENGTH_TOL_MSB		0x8C
-#define QSFP_DD_WAVELENGTH_TOL_LSB		0x8D
-
-/* Signal integrity controls */
-#define QSFP_DD_SIG_INTEG_TX_OFFSET		0xA1
-#define QSFP_DD_SIG_INTEG_RX_OFFSET		0xA2
-
-#define YESNO(x) (((x) != 0) ? "Yes" : "No")
-#define ONOFF(x) (((x) != 0) ? "On" : "Off")
-
-void qsfp_dd_show_all(const __u8 *id);
-
-void cmis_show_all(const struct ethtool_module_eeprom *page_zero,
-		   const struct ethtool_module_eeprom *page_one);
-
-#endif /* QSFP_DD_H__ */
diff --git a/qsfp.c b/qsfp.c
index 211c2df..644fe14 100644
--- a/qsfp.c
+++ b/qsfp.c
@@ -58,7 +58,7 @@
 #include "internal.h"
 #include "sff-common.h"
 #include "qsfp.h"
-#include "qsfp-dd.h"
+#include "cmis.h"
 
 #define MAX_DESC_SIZE	42
 
-- 
1.8.2.3

