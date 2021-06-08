Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA3139F3A1
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 12:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbhFHKgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 06:36:05 -0400
Received: from mail-bn8nam12on2074.outbound.protection.outlook.com ([40.107.237.74]:43849
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231357AbhFHKgD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 06:36:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YNjZwTHzgedpQKI3O9eDRwQolvEK24gl6WM+gnmayQFa0UdNRWotmXg08KVywwj/4lwzgdUljrE/FDK/ZOQdK9tkL9zUKmiaNWB0FkQVgXTZC/ufxnXLBTPAzYiqr4o28NSDsaJEVrFwBWfUbnmBmj8vq6QyiSQuxyZ39LhigVQaCbDlTNP/d0PeJtK1Ola470swafCi7F30az2YB95TZ5lOG9hllr35PzwxYI8XuzK7oGPmmWaxAQThSpWuXb/wubtfczwr/j8rP/AHAQc63N/XRcWA1kZ/JJgeTLlnrHYKkIS++viE3KJl9EDpTc+El7P3Iuq3b2p5jJns0KF3Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0QBuh/VF6pcXFmWvP6wE9P10a4P/WnUm0rTOktyj+iQ=;
 b=ijXTrxH5/MsqoGRwolemPQq/abFTo7d93wtxS4dm0do0r9fDHQu/biymXCYIaBm0fPTMHmI+qS/ezzI640QcnCEUTpx/9AzCg34bKU+h8L4aydxU8HwlpIJMqFbBAJuhZet1m7hshy6RHNvsoFgXXWalkiMaKdoMqsTetgwaSTUuKYdw8kQf+u7gXaIeo2kPwlxsU/XNbWqOm+427PXa1Eo2ZN7JyG7qOTkdcZ8nIFq6ngJyDuv4rn5eaBNfNu0bb8DHCswAnkCzBBeptYogo82+r2x52nhLbCIRzYJ83Ns3wfCtb9ZDO51BdLr7pIzj67+mVhXfRjINjZBgHxyNSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=thebollingers.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0QBuh/VF6pcXFmWvP6wE9P10a4P/WnUm0rTOktyj+iQ=;
 b=j71yAJAnHiuhYoXGpJ9gfiFIUNNPmfrG+dA7AtjZ3zv2f/6IPzkvix0oowXPmXtt7KRC0nZZsMtnFswbYTO0PbQ7FEMlXjJfyeitHTXwJDRYnfU74Zez1wRVIEPJoFTsMrAltPW3/2aC4TjXkesH5ffU3X1UfkKOvB03zBu6fKSPJNAuKGb6BoSSWBDV7WjNBsuBMTXv0nSNFvh/F8Sv35XyEWJgLqd32e4yuEvs/+F5HqL8QLHWndncgGRuHvdxfOSImh9t2BC8Nas3QIWTro2kPtO+LYAol7i1O9Tu1d2dX0SgAfuO8A35NB9tWpUZDz5hEY2ELA2nG4EjNb0s4g==
Received: from DM6PR11CA0016.namprd11.prod.outlook.com (2603:10b6:5:190::29)
 by BY5PR12MB4129.namprd12.prod.outlook.com (2603:10b6:a03:213::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Tue, 8 Jun
 2021 10:34:09 +0000
Received: from DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:190:cafe::5f) by DM6PR11CA0016.outlook.office365.com
 (2603:10b6:5:190::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend
 Transport; Tue, 8 Jun 2021 10:34:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; thebollingers.org; dkim=none (message not signed)
 header.d=none;thebollingers.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT012.mail.protection.outlook.com (10.13.173.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Tue, 8 Jun 2021 10:34:08 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 8 Jun
 2021 03:34:07 -0700
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 8 Jun 2021 10:34:01 +0000
From:   Moshe Shemesh <moshe@nvidia.com>
To:     Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Don Bollinger <don@thebollingers.org>, <netdev@vger.kernel.org>
CC:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH ethtool v3 2/4] ethtool: Refactor human-readable module EEPROM output for new API
Date:   Tue, 8 Jun 2021 13:32:26 +0300
Message-ID: <1623148348-2033898-3-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1623148348-2033898-1-git-send-email-moshe@nvidia.com>
References: <1623148348-2033898-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4298e375-d467-4311-1ebc-08d92a68f2c6
X-MS-TrafficTypeDiagnostic: BY5PR12MB4129:
X-Microsoft-Antispam-PRVS: <BY5PR12MB4129CAE96F63F28CDCBC3B07D4379@BY5PR12MB4129.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z9SCHogRLXhUrP/MhFKR+fa64j57rm+zpCKwC8vl4/K/DDgRU/Y7w3C5uILfAh+o2IR1mIXWnTbwptdjJRH+MfA+YRZwQ7JpcBiLBFlip6eyQeAL9L4asXI8hyUzeY8Jqq6OM+vAhYnQBFgz7JC107EEivGpgImvjlwUR04b0w3HeGKOKxYLJyGLFSV5A3af9KeXJMuQ1PeYsUNBlZ/lHauRW27xoH8Mr6OJyUPSKteQlxW8C3OGVzvSfxMFmJAHvJqVgsoWe58aWf+zQRXEMn66pBTyaTkSzSgxsoyv7/65R6JdyvGWvcSiABC3fUASnA+GaQc3NdHtL4J8TNHusf3j3e8+RJeqff3Y0BaSSF3P+Yml/UKbyC6GyL7LU4WYZAm2OCsUwi/+Fie7Vm5FiNRgYsFj4l4KxbYisQ4Bgg9U/UoUv0VsEaZk3oeaBnkMPsQZSNOD9F1E0aki0/G1q933YZgQRqRpsgKpRB5/4qVoK56Oq+u6LzAvtcljSH2rWBUTSSfWtSXeOOLFT6yqzntbYPUvlVTA0nU0QKmz9uJWTwg6z9tI6Bd3Xw9iSbflmfY6OL0CSYwMIigzhJy0bC5X+N2ogUqe39A10/N+yTIU1clEO93/haVquXDdJLVW+BGtiNEtKGEqIXDKinzbb/WnUWUtuCc7fgx/2EaefC8=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(396003)(136003)(46966006)(36840700001)(110136005)(54906003)(2616005)(86362001)(36756003)(47076005)(30864003)(186003)(107886003)(36860700001)(2906002)(7696005)(336012)(478600001)(82310400003)(426003)(70206006)(83380400001)(70586007)(8936002)(6666004)(82740400003)(26005)(7636003)(8676002)(316002)(5660300002)(356005)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 10:34:08.6372
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4298e375-d467-4311-1ebc-08d92a68f2c6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4129
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
 netlink/module-eeprom.c |  12 +++++
 qsfp-dd.c               |  44 +++++++++++++----
 qsfp-dd.h               |  29 ++++++-----
 qsfp.c                  | 128 +++++++++++++++++++++++++++---------------------
 qsfp.h                  |  51 ++++++++++---------
 sff-common.c            |   3 ++
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
index 16fe09e..664f5c6 100644
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
+		cmis_show_all(page_zero, page_one);
+		break;
 	default:
 		dump_hex(stdout, page_zero->data, page_zero->length, page_zero->offset);
 		break;
diff --git a/qsfp-dd.c b/qsfp-dd.c
index 900bbb5..55adbcb 100644
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
+void cmis_show_all(const struct ethtool_module_eeprom *page_zero,
+		   const struct ethtool_module_eeprom *page_one)
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
index f589c4e..51f92fa 100644
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
 
+void cmis_show_all(const struct ethtool_module_eeprom *page_zero,
+		   const struct ethtool_module_eeprom *page_one);
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
1.8.2.3

