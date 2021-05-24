Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8308238E88F
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 16:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232988AbhEXOVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 10:21:32 -0400
Received: from mail-mw2nam12on2040.outbound.protection.outlook.com ([40.107.244.40]:22241
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232486AbhEXOVa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 10:21:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ChB7EmL7VboF4Ax1vSvn4fpf3I1c4srAyXuI7mL/AGysgkBdrT4tMOE6eZCX9tcH7XXg8ngHglD5HzNTNM3Jo6WJE/mNl6gUUy8bldbIg4X23cI+JeshU0PReK0Fe4OTfU7lc1u1PVXz+ocNo7i/ltjMl3l5UHjtnI+qLJ/Ty5PfF1i0LdJfRzwiEhoS7Clw3Cc1AcprWPVmwM+AJiv3NgCpAcSC8AM7nHXCeyAM98CAO2sPMHAqIFduybDKvyrdwuqAbJNgqPFzg1duf/m4n3JpSN8HFKmnCmvEXUbsFtsLq/mncrGmkzJZcRCxWgDv57OASJDe/Y+sONFVRwk01w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ml4Lwi40DpdYT09nB4nxmjRwsUKJL26S10wNd9fydwQ=;
 b=Z1lR3hSclK2tRXusZnH4sfa9cUlV6mhOakh4USQPweRHSj3z+69R5QcNcpoL1WICa/DVquunJ9rTYsjq0zWJsvJN/smvTY9xxgDCmwIT61aZIzwtAhoB5agvppH9IspkEPr5Fm+IjgZTyT4Lu9mMCDcfKaX8v5gpdC15m1YUksjqdVUWgohTn7VlWjDkEi4IXfO74Kz37fmFZo2cy81XrtXn+11um5gePurWwjDXm2+xC1cSkqnLYOHc+xa1wyPUUMLPtS4pqk/KkKk6KaMjMAv0tXAdqJXTJVttCwzFa5pjuWBYgiXHR3NwR19wMaoSrVP5JcK6Q6W7y8Bc9EzCxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=thebollingers.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ml4Lwi40DpdYT09nB4nxmjRwsUKJL26S10wNd9fydwQ=;
 b=n6ZIEgYOpBvPAaYvYlQjHDKkovKn54h+1KsRY5NYBdsp3mJaUyjiHVJflT/LXyQ9PWrfg4bgsTPTtjtboI1RJ0xQfq+XEAGVwBORGuXpF/MgtvnUzUUStGXoeo16JPuRmZtFB8t0dgCLnZ0yN5S9/XdhNrU4ijceEth59C4vAyYSGeIUXlv0oaV0dK6YWqhNDhuYQGSuMPRXDNUTp0FmtQv686qRZ6Jv7lUy3gMMtz4Rn5OJPQpdjy9CcjST/WuYVW/KD2LCmPiDpTyLqlBw4cy3MIcHgiLMd+98jv6pymCaZPAlzhc3KF/GJgyS1+FlkYrJutsiQoOjQNmZ6bZAVg==
Received: from MW4PR03CA0245.namprd03.prod.outlook.com (2603:10b6:303:b4::10)
 by DM5PR1201MB2553.namprd12.prod.outlook.com (2603:10b6:3:eb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Mon, 24 May
 2021 14:20:01 +0000
Received: from CO1NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b4:cafe::81) by MW4PR03CA0245.outlook.office365.com
 (2603:10b6:303:b4::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend
 Transport; Mon, 24 May 2021 14:20:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; thebollingers.org; dkim=none (message not signed)
 header.d=none;thebollingers.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT021.mail.protection.outlook.com (10.13.175.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Mon, 24 May 2021 14:20:00 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 24 May
 2021 14:20:00 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 24 May 2021 14:19:58 +0000
From:   Moshe Shemesh <moshe@nvidia.com>
To:     Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Don Bollinger <don@thebollingers.org>, <netdev@vger.kernel.org>
CC:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH ethtool v2 2/4] ethtool: Refactor human-readable module EEPROM output for new API
Date:   Mon, 24 May 2021 17:18:58 +0300
Message-ID: <1621865940-287332-3-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1621865940-287332-1-git-send-email-moshe@nvidia.com>
References: <1621865940-287332-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb71a897-f139-4ec0-69b7-08d91ebf0446
X-MS-TrafficTypeDiagnostic: DM5PR1201MB2553:
X-Microsoft-Antispam-PRVS: <DM5PR1201MB2553C7F79B9D934DC770441ED4269@DM5PR1201MB2553.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6S3YzZpvXqkMfakmpHe6Xt+OGSTtqcfdCHkMMjNaLxRvZP8ZpxU1wv+mYmaBDrBjF5u3gfF945eLRIbHA/XGN2onBITnBVc1yyn/JuykKmbHWs9wenVNDvlhrUwGmovmnYHrH3sstN0ETSqRWdlUHWq326BJQ42PuUrP7DKugEa9fNxn7XZP+AKFFHlU7OwYPzOfDT4hqNoIpl4v0ythQCJd1ibj21FjMcqi09KWWzL6YRs0jlMPLIroUH5w2JDSUpcS1XaEWyXyIeQbHF84oSBZV5BmwGNkxI5ezDYCGlWb94s3H3ATE609NCViiBzqaxifEiu3R2L6vu67olXlUxbf2Z0UnlE8lH6jWQsR+hiHKGyogYrhJib4iUfqcgbI5yW6W3oChiwV0mmdHmFYvt9ukQMnoYOHn68i5wWKgdqU8ErziG2xxcnYrqEDKRx3W3Ea71USiEPBdkC+8flLsZCx/zxwE3JiGMxiGD1IULq5Tybmj0cq2L3gb8tORKwYCV3W38Zv3hubsLRyDu5fmwJZM3SjA5Fpof3LUgGyG4OBhDYuWWn8IAQiC7mxdRueuIWTPmH4yLd4lqIU0tH2MJ15UruvIVvtaH+Ji2rFjAbCmqUhYKmtGyQkfwPqik5wja51IfIxQHRTjY7AfJpWAe98zEED5lLRIeyH4tAKPfk=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(39860400002)(396003)(46966006)(36840700001)(186003)(7636003)(26005)(47076005)(36756003)(54906003)(107886003)(2616005)(8936002)(110136005)(5660300002)(426003)(30864003)(2906002)(82740400003)(70586007)(316002)(36906005)(83380400001)(7696005)(70206006)(36860700001)(8676002)(478600001)(86362001)(82310400003)(336012)(4326008)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2021 14:20:00.7616
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eb71a897-f139-4ec0-69b7-08d91ebf0446
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB2553
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>

Reuse existing SFF8636 and QSFP-DD infrastructures to implement
EEPROM decoders, which work with paged memory. Add support for
human-readable output for QSFP, QSFP28, QSFP Plus, QSFP-DD and DSFP
transreceivers from netlink 'ethtool -m' handler.

Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
---
 internal.h              |   2 +
 netlink/module-eeprom.c |  12 ++++
 qsfp-dd.c               |  44 +++++++++++---
 qsfp-dd.h               |  29 +++++----
 qsfp.c                  | 128 +++++++++++++++++++++++-----------------
 qsfp.h                  |  51 ++++++++--------
 sff-common.c            |   3 +
 sff-common.h            |   3 +-
 8 files changed, 170 insertions(+), 102 deletions(-)

diff --git a/internal.h b/internal.h
index 2affebe..33e619b 100644
--- a/internal.h
+++ b/internal.h
@@ -391,6 +391,8 @@ void sff8472_show_all(const __u8 *id);
 
 /* QSFP Optics diagnostics */
 void sff8636_show_all(const __u8 *id, __u32 eeprom_len);
+void sff8636_show_all_paged(const struct ethtool_module_eeprom *page_zero,
+			    const struct ethtool_module_eeprom *page_three);
 
 /* FUJITSU Extended Socket network device */
 int fjes_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs);
diff --git a/netlink/module-eeprom.c b/netlink/module-eeprom.c
index 16fe09e..ccf5032 100644
--- a/netlink/module-eeprom.c
+++ b/netlink/module-eeprom.c
@@ -302,6 +302,7 @@ static int decoder_prefetch(struct nl_context *nlctx)
 		request.page = 3;
 		break;
 	case SFF8024_ID_QSFP_DD:
+	case SFF8024_ID_DSFP:
 		memset(&request, 0, sizeof(request));
 		request.i2c_address = ETH_I2C_ADDRESS_LOW;
 		request.offset = 128;
@@ -315,13 +316,24 @@ static int decoder_prefetch(struct nl_context *nlctx)
 
 static void decoder_print(void)
 {
+	struct ethtool_module_eeprom *page_three = cache_get(3, 0, ETH_I2C_ADDRESS_LOW);
 	struct ethtool_module_eeprom *page_zero = cache_get(0, 0, ETH_I2C_ADDRESS_LOW);
+	struct ethtool_module_eeprom *page_one = cache_get(1, 0, ETH_I2C_ADDRESS_LOW);
 	u8 module_id = page_zero->data[SFF8636_ID_OFFSET];
 
 	switch (module_id) {
 	case SFF8024_ID_SFP:
 		sff8079_show_all(page_zero->data);
 		break;
+	case SFF8024_ID_QSFP:
+	case SFF8024_ID_QSFP28:
+	case SFF8024_ID_QSFP_PLUS:
+		sff8636_show_all_paged(page_zero, page_three);
+		break;
+	case SFF8024_ID_QSFP_DD:
+	case SFF8024_ID_DSFP:
+		cmis4_show_all(page_zero, page_one);
+		break;
 	default:
 		dump_hex(stdout, page_zero->data, page_zero->length, page_zero->offset);
 		break;
diff --git a/qsfp-dd.c b/qsfp-dd.c
index 900bbb5..5c2e4a0 100644
--- a/qsfp-dd.c
+++ b/qsfp-dd.c
@@ -274,6 +274,20 @@ static void qsfp_dd_show_mod_lvl_monitors(const __u8 *id)
 		  OFFSET_TO_U16(QSFP_DD_CURR_CURR_OFFSET));
 }
 
+static void qsfp_dd_show_link_len_from_page(const __u8 *page_one_data)
+{
+	qsfp_dd_print_smf_cbl_len(page_one_data);
+	sff_show_value_with_unit(page_one_data, QSFP_DD_OM5_LEN_OFFSET,
+				 "Length (OM5)", 2, "m");
+	sff_show_value_with_unit(page_one_data, QSFP_DD_OM4_LEN_OFFSET,
+				 "Length (OM4)", 2, "m");
+	sff_show_value_with_unit(page_one_data, QSFP_DD_OM3_LEN_OFFSET,
+				 "Length (OM3 50/125um)", 2, "m");
+	sff_show_value_with_unit(page_one_data, QSFP_DD_OM2_LEN_OFFSET,
+				 "Length (OM2 50/125um)", 1, "m");
+}
+
+
 /**
  * Print relevant info about the maximum supported fiber media length
  * for each type of fiber media at the maximum module-supported bit rate.
@@ -283,15 +297,7 @@ static void qsfp_dd_show_mod_lvl_monitors(const __u8 *id)
  */
 static void qsfp_dd_show_link_len(const __u8 *id)
 {
-	qsfp_dd_print_smf_cbl_len(id);
-	sff_show_value_with_unit(id, QSFP_DD_OM5_LEN_OFFSET,
-				 "Length (OM5)", 2, "m");
-	sff_show_value_with_unit(id, QSFP_DD_OM4_LEN_OFFSET,
-				 "Length (OM4)", 2, "m");
-	sff_show_value_with_unit(id, QSFP_DD_OM3_LEN_OFFSET,
-				 "Length (OM3 50/125um)", 2, "m");
-	sff_show_value_with_unit(id, QSFP_DD_OM2_LEN_OFFSET,
-				 "Length (OM2 50/125um)", 1, "m");
+	qsfp_dd_show_link_len_from_page(id + PAG01H_UPPER_OFFSET);
 }
 
 /**
@@ -331,3 +337,23 @@ void qsfp_dd_show_all(const __u8 *id)
 	qsfp_dd_show_vendor_info(id);
 	qsfp_dd_show_rev_compliance(id);
 }
+
+void cmis4_show_all(const struct ethtool_module_eeprom *page_zero,
+		    const struct ethtool_module_eeprom *page_one)
+{
+	const __u8 *page_zero_data = page_zero->data;
+
+	qsfp_dd_show_identifier(page_zero_data);
+	qsfp_dd_show_power_info(page_zero_data);
+	qsfp_dd_show_connector(page_zero_data);
+	qsfp_dd_show_cbl_asm_len(page_zero_data);
+	qsfp_dd_show_sig_integrity(page_zero_data);
+	qsfp_dd_show_mit_compliance(page_zero_data);
+	qsfp_dd_show_mod_lvl_monitors(page_zero_data);
+
+	if (page_one)
+		qsfp_dd_show_link_len_from_page(page_one->data);
+
+	qsfp_dd_show_vendor_info(page_zero_data);
+	qsfp_dd_show_rev_compliance(page_zero_data);
+}
diff --git a/qsfp-dd.h b/qsfp-dd.h
index f589c4e..72a7569 100644
--- a/qsfp-dd.h
+++ b/qsfp-dd.h
@@ -96,30 +96,33 @@
 /*-----------------------------------------------------------------------
  * Upper Memory Page 0x01: contains advertising fields that define properties
  * that are unique to active modules and cable assemblies.
- * RealOffset = 1 * 0x80 + LocalOffset
+ * GlobalOffset = 2 * 0x80 + LocalOffset
  */
-#define PAG01H_UPPER_OFFSET			(0x01 * 0x80)
+#define PAG01H_UPPER_OFFSET			(0x02 * 0x80)
 
 /* Supported Link Length (Page 1) */
-#define QSFP_DD_SMF_LEN_OFFSET			(PAG01H_UPPER_OFFSET + 0x84)
-#define QSFP_DD_OM5_LEN_OFFSET			(PAG01H_UPPER_OFFSET + 0x85)
-#define QSFP_DD_OM4_LEN_OFFSET			(PAG01H_UPPER_OFFSET + 0x86)
-#define QSFP_DD_OM3_LEN_OFFSET			(PAG01H_UPPER_OFFSET + 0x87)
-#define QSFP_DD_OM2_LEN_OFFSET			(PAG01H_UPPER_OFFSET + 0x88)
+#define QSFP_DD_SMF_LEN_OFFSET			0x84
+#define QSFP_DD_OM5_LEN_OFFSET			0x85
+#define QSFP_DD_OM4_LEN_OFFSET			0x86
+#define QSFP_DD_OM3_LEN_OFFSET			0x87
+#define QSFP_DD_OM2_LEN_OFFSET			0x88
 
 /* Wavelength (Page 1) */
-#define QSFP_DD_NOM_WAVELENGTH_MSB		(PAG01H_UPPER_OFFSET + 0x8A)
-#define QSFP_DD_NOM_WAVELENGTH_LSB		(PAG01H_UPPER_OFFSET + 0x8B)
-#define QSFP_DD_WAVELENGTH_TOL_MSB		(PAG01H_UPPER_OFFSET + 0x8C)
-#define QSFP_DD_WAVELENGTH_TOL_LSB		(PAG01H_UPPER_OFFSET + 0x8D)
+#define QSFP_DD_NOM_WAVELENGTH_MSB		0x8A
+#define QSFP_DD_NOM_WAVELENGTH_LSB		0x8B
+#define QSFP_DD_WAVELENGTH_TOL_MSB		0x8C
+#define QSFP_DD_WAVELENGTH_TOL_LSB		0x8D
 
 /* Signal integrity controls */
-#define QSFP_DD_SIG_INTEG_TX_OFFSET		(PAG01H_UPPER_OFFSET + 0xA1)
-#define QSFP_DD_SIG_INTEG_RX_OFFSET		(PAG01H_UPPER_OFFSET + 0xA2)
+#define QSFP_DD_SIG_INTEG_TX_OFFSET		0xA1
+#define QSFP_DD_SIG_INTEG_RX_OFFSET		0xA2
 
 #define YESNO(x) (((x) != 0) ? "Yes" : "No")
 #define ONOFF(x) (((x) != 0) ? "On" : "Off")
 
 void qsfp_dd_show_all(const __u8 *id);
 
+void cmis4_show_all(const struct ethtool_module_eeprom *page_zero,
+		    const struct ethtool_module_eeprom *page_one);
+
 #endif /* QSFP_DD_H__ */
diff --git a/qsfp.c b/qsfp.c
index 3c1a300..211c2df 100644
--- a/qsfp.c
+++ b/qsfp.c
@@ -672,38 +672,39 @@ static void sff8636_show_revision_compliance(const __u8 *id)
  * Second byte are 1/256th of degree, which are added to the dec part.
  */
 #define SFF8636_OFFSET_TO_TEMP(offset) ((__s16)OFFSET_TO_U16(offset))
+#define OFFSET_TO_U16_PTR(ptr, offset) (ptr[offset] << 8 | ptr[(offset) + 1])
 
-static void sff8636_dom_parse(const __u8 *id, struct sff_diags *sd)
+static void sff8636_dom_parse(const __u8 *id, const __u8 *page_three, struct sff_diags *sd)
 {
 	int i = 0;
 
 	/* Monitoring Thresholds for Alarms and Warnings */
-	sd->sfp_voltage[MCURR] = OFFSET_TO_U16(SFF8636_VCC_CURR);
-	sd->sfp_voltage[HALRM] = OFFSET_TO_U16(SFF8636_VCC_HALRM);
-	sd->sfp_voltage[LALRM] = OFFSET_TO_U16(SFF8636_VCC_LALRM);
-	sd->sfp_voltage[HWARN] = OFFSET_TO_U16(SFF8636_VCC_HWARN);
-	sd->sfp_voltage[LWARN] = OFFSET_TO_U16(SFF8636_VCC_LWARN);
+	sd->sfp_voltage[MCURR] = OFFSET_TO_U16_PTR(id, SFF8636_VCC_CURR);
+	sd->sfp_voltage[HALRM] = OFFSET_TO_U16_PTR(page_three, SFF8636_VCC_HALRM);
+	sd->sfp_voltage[LALRM] = OFFSET_TO_U16_PTR(page_three, SFF8636_VCC_LALRM);
+	sd->sfp_voltage[HWARN] = OFFSET_TO_U16_PTR(page_three, SFF8636_VCC_HWARN);
+	sd->sfp_voltage[LWARN] = OFFSET_TO_U16_PTR(page_three, SFF8636_VCC_LWARN);
 
 	sd->sfp_temp[MCURR] = SFF8636_OFFSET_TO_TEMP(SFF8636_TEMP_CURR);
-	sd->sfp_temp[HALRM] = SFF8636_OFFSET_TO_TEMP(SFF8636_TEMP_HALRM);
-	sd->sfp_temp[LALRM] = SFF8636_OFFSET_TO_TEMP(SFF8636_TEMP_LALRM);
-	sd->sfp_temp[HWARN] = SFF8636_OFFSET_TO_TEMP(SFF8636_TEMP_HWARN);
-	sd->sfp_temp[LWARN] = SFF8636_OFFSET_TO_TEMP(SFF8636_TEMP_LWARN);
+	sd->sfp_temp[HALRM] = (__s16)OFFSET_TO_U16_PTR(page_three, SFF8636_TEMP_HALRM);
+	sd->sfp_temp[LALRM] = (__s16)OFFSET_TO_U16_PTR(page_three, SFF8636_TEMP_LALRM);
+	sd->sfp_temp[HWARN] = (__s16)OFFSET_TO_U16_PTR(page_three, SFF8636_TEMP_HWARN);
+	sd->sfp_temp[LWARN] = (__s16)OFFSET_TO_U16_PTR(page_three, SFF8636_TEMP_LWARN);
 
-	sd->bias_cur[HALRM] = OFFSET_TO_U16(SFF8636_TX_BIAS_HALRM);
-	sd->bias_cur[LALRM] = OFFSET_TO_U16(SFF8636_TX_BIAS_LALRM);
-	sd->bias_cur[HWARN] = OFFSET_TO_U16(SFF8636_TX_BIAS_HWARN);
-	sd->bias_cur[LWARN] = OFFSET_TO_U16(SFF8636_TX_BIAS_LWARN);
+	sd->bias_cur[HALRM] = OFFSET_TO_U16_PTR(page_three, SFF8636_TX_BIAS_HALRM);
+	sd->bias_cur[LALRM] = OFFSET_TO_U16_PTR(page_three, SFF8636_TX_BIAS_LALRM);
+	sd->bias_cur[HWARN] = OFFSET_TO_U16_PTR(page_three, SFF8636_TX_BIAS_HWARN);
+	sd->bias_cur[LWARN] = OFFSET_TO_U16_PTR(page_three, SFF8636_TX_BIAS_LWARN);
 
-	sd->tx_power[HALRM] = OFFSET_TO_U16(SFF8636_TX_PWR_HALRM);
-	sd->tx_power[LALRM] = OFFSET_TO_U16(SFF8636_TX_PWR_LALRM);
-	sd->tx_power[HWARN] = OFFSET_TO_U16(SFF8636_TX_PWR_HWARN);
-	sd->tx_power[LWARN] = OFFSET_TO_U16(SFF8636_TX_PWR_LWARN);
+	sd->tx_power[HALRM] = OFFSET_TO_U16_PTR(page_three, SFF8636_TX_PWR_HALRM);
+	sd->tx_power[LALRM] = OFFSET_TO_U16_PTR(page_three, SFF8636_TX_PWR_LALRM);
+	sd->tx_power[HWARN] = OFFSET_TO_U16_PTR(page_three, SFF8636_TX_PWR_HWARN);
+	sd->tx_power[LWARN] = OFFSET_TO_U16_PTR(page_three, SFF8636_TX_PWR_LWARN);
 
-	sd->rx_power[HALRM] = OFFSET_TO_U16(SFF8636_RX_PWR_HALRM);
-	sd->rx_power[LALRM] = OFFSET_TO_U16(SFF8636_RX_PWR_LALRM);
-	sd->rx_power[HWARN] = OFFSET_TO_U16(SFF8636_RX_PWR_HWARN);
-	sd->rx_power[LWARN] = OFFSET_TO_U16(SFF8636_RX_PWR_LWARN);
+	sd->rx_power[HALRM] = OFFSET_TO_U16_PTR(page_three, SFF8636_RX_PWR_HALRM);
+	sd->rx_power[LALRM] = OFFSET_TO_U16_PTR(page_three, SFF8636_RX_PWR_LALRM);
+	sd->rx_power[HWARN] = OFFSET_TO_U16_PTR(page_three, SFF8636_RX_PWR_HWARN);
+	sd->rx_power[LWARN] = OFFSET_TO_U16_PTR(page_three, SFF8636_RX_PWR_LWARN);
 
 
 	/* Channel Specific Data */
@@ -740,7 +741,7 @@ static void sff8636_dom_parse(const __u8 *id, struct sff_diags *sd)
 
 }
 
-static void sff8636_show_dom(const __u8 *id, __u32 eeprom_len)
+static void sff8636_show_dom(const __u8 *id, const __u8 *page_three, __u32 eeprom_len)
 {
 	struct sff_diags sd = {0};
 	char *rx_power_string = NULL;
@@ -767,7 +768,7 @@ static void sff8636_show_dom(const __u8 *id, __u32 eeprom_len)
 	sd.tx_power_type = id[SFF8636_DIAG_TYPE_OFFSET] &
 						SFF8636_RX_PWR_TYPE_MASK;
 
-	sff8636_dom_parse(id, &sd);
+	sff8636_dom_parse(id, page_three, &sd);
 
 	PRINT_TEMP("Module temperature", sd.sfp_temp[MCURR]);
 	PRINT_VCC("Module voltage", sd.sfp_voltage[MCURR]);
@@ -818,6 +819,42 @@ static void sff8636_show_dom(const __u8 *id, __u32 eeprom_len)
 	}
 }
 
+
+static void sff6836_show_page_zero(const __u8 *id)
+{
+	sff8636_show_ext_identifier(id);
+	sff8636_show_connector(id);
+	sff8636_show_transceiver(id);
+	sff8636_show_encoding(id);
+	sff_show_value_with_unit(id, SFF8636_BR_NOMINAL_OFFSET,
+			"BR, Nominal", 100, "Mbps");
+	sff8636_show_rate_identifier(id);
+	sff_show_value_with_unit(id, SFF8636_SM_LEN_OFFSET,
+		     "Length (SMF,km)", 1, "km");
+	sff_show_value_with_unit(id, SFF8636_OM3_LEN_OFFSET,
+			"Length (OM3 50um)", 2, "m");
+	sff_show_value_with_unit(id, SFF8636_OM2_LEN_OFFSET,
+			"Length (OM2 50um)", 1, "m");
+	sff_show_value_with_unit(id, SFF8636_OM1_LEN_OFFSET,
+		     "Length (OM1 62.5um)", 1, "m");
+	sff_show_value_with_unit(id, SFF8636_CBL_LEN_OFFSET,
+		     "Length (Copper or Active cable)", 1, "m");
+	sff8636_show_wavelength_or_copper_compliance(id);
+	sff_show_ascii(id, SFF8636_VENDOR_NAME_START_OFFSET,
+		       SFF8636_VENDOR_NAME_END_OFFSET, "Vendor name");
+	sff8636_show_oui(id, SFF8636_VENDOR_OUI_OFFSET);
+	sff_show_ascii(id, SFF8636_VENDOR_PN_START_OFFSET,
+		       SFF8636_VENDOR_PN_END_OFFSET, "Vendor PN");
+	sff_show_ascii(id, SFF8636_VENDOR_REV_START_OFFSET,
+		       SFF8636_VENDOR_REV_END_OFFSET, "Vendor rev");
+	sff_show_ascii(id, SFF8636_VENDOR_SN_START_OFFSET,
+		       SFF8636_VENDOR_SN_END_OFFSET, "Vendor SN");
+	sff_show_ascii(id, SFF8636_DATE_YEAR_OFFSET,
+		       SFF8636_DATE_VENDOR_LOT_OFFSET + 1, "Date code");
+	sff8636_show_revision_compliance(id);
+
+}
+
 void sff8636_show_all(const __u8 *id, __u32 eeprom_len)
 {
 	if (id[SFF8636_ID_OFFSET] == SFF8024_ID_QSFP_DD) {
@@ -829,36 +866,17 @@ void sff8636_show_all(const __u8 *id, __u32 eeprom_len)
 	if ((id[SFF8636_ID_OFFSET] == SFF8024_ID_QSFP) ||
 		(id[SFF8636_ID_OFFSET] == SFF8024_ID_QSFP_PLUS) ||
 		(id[SFF8636_ID_OFFSET] == SFF8024_ID_QSFP28)) {
-		sff8636_show_ext_identifier(id);
-		sff8636_show_connector(id);
-		sff8636_show_transceiver(id);
-		sff8636_show_encoding(id);
-		sff_show_value_with_unit(id, SFF8636_BR_NOMINAL_OFFSET,
-				"BR, Nominal", 100, "Mbps");
-		sff8636_show_rate_identifier(id);
-		sff_show_value_with_unit(id, SFF8636_SM_LEN_OFFSET,
-			     "Length (SMF,km)", 1, "km");
-		sff_show_value_with_unit(id, SFF8636_OM3_LEN_OFFSET,
-				"Length (OM3 50um)", 2, "m");
-		sff_show_value_with_unit(id, SFF8636_OM2_LEN_OFFSET,
-				"Length (OM2 50um)", 1, "m");
-		sff_show_value_with_unit(id, SFF8636_OM1_LEN_OFFSET,
-			     "Length (OM1 62.5um)", 1, "m");
-		sff_show_value_with_unit(id, SFF8636_CBL_LEN_OFFSET,
-			     "Length (Copper or Active cable)", 1, "m");
-		sff8636_show_wavelength_or_copper_compliance(id);
-		sff_show_ascii(id, SFF8636_VENDOR_NAME_START_OFFSET,
-			       SFF8636_VENDOR_NAME_END_OFFSET, "Vendor name");
-		sff8636_show_oui(id, SFF8636_VENDOR_OUI_OFFSET);
-		sff_show_ascii(id, SFF8636_VENDOR_PN_START_OFFSET,
-			       SFF8636_VENDOR_PN_END_OFFSET, "Vendor PN");
-		sff_show_ascii(id, SFF8636_VENDOR_REV_START_OFFSET,
-			       SFF8636_VENDOR_REV_END_OFFSET, "Vendor rev");
-		sff_show_ascii(id, SFF8636_VENDOR_SN_START_OFFSET,
-			       SFF8636_VENDOR_SN_END_OFFSET, "Vendor SN");
-		sff_show_ascii(id, SFF8636_DATE_YEAR_OFFSET,
-			       SFF8636_DATE_VENDOR_LOT_OFFSET + 1, "Date code");
-		sff8636_show_revision_compliance(id);
-		sff8636_show_dom(id, eeprom_len);
+		sff6836_show_page_zero(id);
+		sff8636_show_dom(id, id + SFF8636_PAGE03H_OFFSET, eeprom_len);
 	}
 }
+
+void sff8636_show_all_paged(const struct ethtool_module_eeprom *page_zero,
+			    const struct ethtool_module_eeprom *page_three)
+{
+	sff8636_show_identifier(page_zero->data);
+	sff6836_show_page_zero(page_zero->data);
+	if (page_three)
+		sff8636_show_dom(page_zero->data, page_three->data - 0x80,
+				 ETH_MODULE_SFF_8636_MAX_LEN);
+}
diff --git a/qsfp.h b/qsfp.h
index 9636b0c..1d8f24b 100644
--- a/qsfp.h
+++ b/qsfp.h
@@ -592,32 +592,35 @@
  * Offset - Page Num(3) * PageSize(0x80) + Page offset
  */
 
+/* 3 * 128 + Lower page 00h(128) */
+#define SFF8636_PAGE03H_OFFSET (128 * 4)
+
 /* Module Thresholds (48 Bytes) 128-175 */
 /* MSB at low address, LSB at high address */
-#define	SFF8636_TEMP_HALRM		0x200
-#define	SFF8636_TEMP_LALRM		0x202
-#define	SFF8636_TEMP_HWARN		0x204
-#define	SFF8636_TEMP_LWARN		0x206
-
-#define	SFF8636_VCC_HALRM		0x210
-#define	SFF8636_VCC_LALRM		0x212
-#define	SFF8636_VCC_HWARN		0x214
-#define	SFF8636_VCC_LWARN		0x216
-
-#define	SFF8636_RX_PWR_HALRM		0x230
-#define	SFF8636_RX_PWR_LALRM		0x232
-#define	SFF8636_RX_PWR_HWARN		0x234
-#define	SFF8636_RX_PWR_LWARN		0x236
-
-#define	SFF8636_TX_BIAS_HALRM		0x238
-#define	SFF8636_TX_BIAS_LALRM		0x23A
-#define	SFF8636_TX_BIAS_HWARN		0x23C
-#define	SFF8636_TX_BIAS_LWARN		0x23E
-
-#define	SFF8636_TX_PWR_HALRM		0x240
-#define	SFF8636_TX_PWR_LALRM		0x242
-#define	SFF8636_TX_PWR_HWARN		0x244
-#define	SFF8636_TX_PWR_LWARN		0x246
+#define	SFF8636_TEMP_HALRM	0x80
+#define	SFF8636_TEMP_LALRM	0x82
+#define	SFF8636_TEMP_HWARN	0x84
+#define	SFF8636_TEMP_LWARN	0x86
+
+#define	SFF8636_VCC_HALRM	0x90
+#define	SFF8636_VCC_LALRM	0x92
+#define	SFF8636_VCC_HWARN	0x94
+#define	SFF8636_VCC_LWARN	0x96
+
+#define	SFF8636_RX_PWR_HALRM	0xB0
+#define	SFF8636_RX_PWR_LALRM	0xB2
+#define	SFF8636_RX_PWR_HWARN	0xB4
+#define	SFF8636_RX_PWR_LWARN	0xB6
+
+#define	SFF8636_TX_BIAS_HALRM	0xB8
+#define	SFF8636_TX_BIAS_LALRM	0xBA
+#define	SFF8636_TX_BIAS_HWARN	0xBC
+#define	SFF8636_TX_BIAS_LWARN	0xBE
+
+#define	SFF8636_TX_PWR_HALRM	0xC0
+#define	SFF8636_TX_PWR_LALRM	0xC2
+#define	SFF8636_TX_PWR_HWARN	0xC4
+#define	SFF8636_TX_PWR_LWARN	0xC6
 
 #define	ETH_MODULE_SFF_8636_MAX_LEN	640
 #define	ETH_MODULE_SFF_8436_MAX_LEN	640
diff --git a/sff-common.c b/sff-common.c
index 5285645..2815951 100644
--- a/sff-common.c
+++ b/sff-common.c
@@ -139,6 +139,9 @@ void sff8024_show_identifier(const __u8 *id, int id_offset)
 	case SFF8024_ID_QSFP_DD:
 		printf(" (QSFP-DD Double Density 8X Pluggable Transceiver (INF-8628))\n");
 		break;
+	case SFF8024_ID_DSFP:
+		printf(" (DSFP Dual Small Form Factor Pluggable Transceiver)\n");
+		break;
 	default:
 		printf(" (reserved or unknown)\n");
 		break;
diff --git a/sff-common.h b/sff-common.h
index cfb5d0e..2183f41 100644
--- a/sff-common.h
+++ b/sff-common.h
@@ -62,7 +62,8 @@
 #define  SFF8024_ID_CDFP_S3				0x16
 #define  SFF8024_ID_MICRO_QSFP			0x17
 #define  SFF8024_ID_QSFP_DD				0x18
-#define  SFF8024_ID_LAST				SFF8024_ID_QSFP_DD
+#define  SFF8024_ID_DSFP				0x1B
+#define  SFF8024_ID_LAST				SFF8024_ID_DSFP
 #define  SFF8024_ID_UNALLOCATED_LAST	0x7F
 #define  SFF8024_ID_VENDOR_START		0x80
 #define  SFF8024_ID_VENDOR_LAST			0xFF
-- 
2.18.2

