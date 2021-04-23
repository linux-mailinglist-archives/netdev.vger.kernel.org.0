Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3F3368DDF
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 09:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241188AbhDWHY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 03:24:26 -0400
Received: from mail-bn7nam10on2056.outbound.protection.outlook.com ([40.107.92.56]:14048
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241031AbhDWHYY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 03:24:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HRCXqfU10HSWKM27CC6DIT6xw8gptwcuC7bCoZ0NmftJu7QrKTjweYebx8iIz/iqeUkKToXGH9VkhPxud2WhPs1PsLNBzaFCoITaNgHSLsqi2uUzDmopVLqchYIoVnNEmoyi+JdRgylpQ4xjWl+lddi30RC5yPzFzJ/qbPMtM2y+/v6xv+IMLSDypBa8apUFXyHMtxfNK+CFQPFDF44OWsAI2QWSdXFMSjxRrGCLJsaDAXwE6Rjt47gUhnHKhofnJhD5dH9jdUPP9MZNRYowFsnurWReIHW6AE+oVLWhjxgs0DiDG5nDjBmLYM8kHNz7qa5iM8DBf3r4fzEUJtKlvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QMwd4LKivZEKk6R6fns7YLKDSwWwLFRIuNrPAUFmKxc=;
 b=fvwZh5QcdIr/WLeIbpuMUfpwkchOuPTlZkS/02ddFnG2JvketF4wpfJ2Lqs6lJOwxRgWdt1BRUs+Q1yyI0ev5FoI7Vt/Ww8Y51XXkm5xFgDQrq39N75mZdrZ5WCICLqGU40VIdLwEcXblEIPKCquoSefwL9mtNICirU65/dn07RZslN9CxMXh2r8LZsqSQUbJUBQGXX/FVz8tSjIfCNB1PFV/5T/1B/VJDdK8Lw1jKAXLjXO/8Q6iddLQW3TWlq+Mn9rk1/bk5CiNaeAbn8jcL6uLHPgzGuuX48GBZMipxfG03w3wCZynqP4D/5Is1i4ytLHqN0ZpvTiPAd06oGaGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=thebollingers.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QMwd4LKivZEKk6R6fns7YLKDSwWwLFRIuNrPAUFmKxc=;
 b=Z3714ZDee2Dhv8Dwm8c1qIXlZzUxX1ojfYE91t59WkFdcvWrtnyJvWv6wwdu8DjhEUbdDuy5jQkM2NwV+CsYJ+sdm6MTXff5Hu6WOWGLlSr+voCxfFupPpCePGm2PaQ80JhNCmZY/5hoJUxA0wgiB9OefkXaYRkMOorjxDZUhvWYaEWtN2taZfxpWaOdUVr+r3cpSAlUVMmi8Fm+BxjMG/O/vqkBsKubFXeWVOstkMLig20wq0avX+LQOBU7I/cj45TphyT/AI1YrTsi1yWPLCl2Efaln0Gd8cxm7M7VHNfY0T7MMXqdj4XiWEuGn3sJjP9alb8c05jTmK61E+av/Q==
Received: from DM5PR13CA0001.namprd13.prod.outlook.com (2603:10b6:3:23::11) by
 CH2PR12MB4645.namprd12.prod.outlook.com (2603:10b6:610:e::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4065.20; Fri, 23 Apr 2021 07:23:46 +0000
Received: from DM6NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:23:cafe::92) by DM5PR13CA0001.outlook.office365.com
 (2603:10b6:3:23::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.15 via Frontend
 Transport; Fri, 23 Apr 2021 07:23:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; thebollingers.org; dkim=none (message not signed)
 header.d=none;thebollingers.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT005.mail.protection.outlook.com (10.13.172.238) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Fri, 23 Apr 2021 07:23:46 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 23 Apr
 2021 07:23:45 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 23 Apr 2021 07:23:43 +0000
From:   Moshe Shemesh <moshe@nvidia.com>
To:     Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Don Bollinger <don@thebollingers.org>, <netdev@vger.kernel.org>
CC:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH ethtool-next 2/4] ethtool: Refactor human-readable module EEPROM output
Date:   Fri, 23 Apr 2021 10:23:14 +0300
Message-ID: <1619162596-23846-3-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1619162596-23846-1-git-send-email-moshe@nvidia.com>
References: <1619162596-23846-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 116dc497-ce08-401d-caaf-08d90628bb90
X-MS-TrafficTypeDiagnostic: CH2PR12MB4645:
X-Microsoft-Antispam-PRVS: <CH2PR12MB4645FAC5BC6C1195C8EAECDDD4459@CH2PR12MB4645.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /GsMSeCBpj6FbqOUVrUhmwQbHGdiTxc8DOkgmHgPyCeSPPNE7tFmuaRGREGBDjbRHu/ZO/HDabDJxoqsWwylzb6pyzCqSwQ1gqTX24Ln4Jqy9IEYPhWTDeAVSs+L+lq+IdzGlJWvgC8CsXdmwNLDkrtGYJfQFe6OKtaRp1ixkhzL0q2bSwJwKelTRIKfbPg0SquA+n4/hEuxqeiSkEtdQtqDw8wlItyVzsdzPjQF1SBXq7/nxiugvpyOwmQoYkwE5cqnbSn1j4+XBrUGQR0Db+p9icKMeUZYhTQgXoaBABAPsGPyWOtCI16/qrNUbgnktpnyUienIvXlCR6u0SUoL8LJ3dv+ntIFMUriwmcKhSB1Is5WYQoqdyEvH6LEx9V5Gle4ldiDMQR3jEYEy83RXRqg+4XM0ZR2Fv1uVGUId6+PjMkKy6CjmoIVScaS8um4P/OBywxptiSJSk86xiZxnh9/tkCJbuX57WS8c7frpq66mcUT5FZKkNn/a3Kll94iXyKGF1dHZoppehbf/vILXXCGwtXZ0WTWTfcxci7AfK4ov4EKZzdt1rhkLz17/BhF17jzMFd2jKdTW8vUkeX1kY43gbx5fZWJbuTbszTq92iRkCcS9qbK058NXLt6GYJ+84g5OmzQ6M/Y0dr3V/2BVsYbTvE3IAY63AzFCieMi0E=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(39860400002)(376002)(36840700001)(46966006)(2616005)(54906003)(70206006)(30864003)(86362001)(8676002)(7696005)(478600001)(8936002)(110136005)(336012)(107886003)(70586007)(6666004)(36756003)(5660300002)(4326008)(186003)(36906005)(426003)(83380400001)(2906002)(26005)(7636003)(82310400003)(36860700001)(47076005)(316002)(356005)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 07:23:46.3903
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 116dc497-ce08-401d-caaf-08d90628bb90
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4645
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
 netlink/module-eeprom.c |  13 ++++
 qsfp-dd.c               |  44 +++++++++++---
 qsfp-dd.h               |  29 +++++----
 qsfp.c                  | 127 +++++++++++++++++++++++-----------------
 qsfp.h                  |  52 ++++++++--------
 sff-common.c            |   3 +
 sff-common.h            |   3 +-
 8 files changed, 171 insertions(+), 102 deletions(-)

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
index 7298087..768a261 100644
--- a/netlink/module-eeprom.c
+++ b/netlink/module-eeprom.c
@@ -291,6 +291,7 @@ static bool page_available(struct ethtool_module_eeprom *which)
 	case SFF8024_ID_QSFP_PLUS:
 		return (!which->bank && which->page <= 3);
 	case SFF8024_ID_QSFP_DD:
+	case SFF8024_ID_DSFP:
 		return !(flat_mem && which->page);
 	default:
 		return true;
@@ -323,6 +324,7 @@ static int decoder_prefetch(struct nl_context *nlctx)
 		request.page = 3;
 		break;
 	case SFF8024_ID_QSFP_DD:
+	case SFF8024_ID_DSFP:
 		memset(&request, 0, sizeof(request));
 		request.i2c_address = ETH_I2C_ADDRESS_LOW;
 		request.offset = 128;
@@ -336,13 +338,24 @@ static int decoder_prefetch(struct nl_context *nlctx)
 
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
index f589c4e..fddb188 100644
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
+#define QSFP_DD_SMF_LEN_OFFSET			0x4
+#define QSFP_DD_OM5_LEN_OFFSET			0x5
+#define QSFP_DD_OM4_LEN_OFFSET			0x6
+#define QSFP_DD_OM3_LEN_OFFSET			0x7
+#define QSFP_DD_OM2_LEN_OFFSET			0x8
 
 /* Wavelength (Page 1) */
-#define QSFP_DD_NOM_WAVELENGTH_MSB		(PAG01H_UPPER_OFFSET + 0x8A)
-#define QSFP_DD_NOM_WAVELENGTH_LSB		(PAG01H_UPPER_OFFSET + 0x8B)
-#define QSFP_DD_WAVELENGTH_TOL_MSB		(PAG01H_UPPER_OFFSET + 0x8C)
-#define QSFP_DD_WAVELENGTH_TOL_LSB		(PAG01H_UPPER_OFFSET + 0x8D)
+#define QSFP_DD_NOM_WAVELENGTH_MSB		0xA
+#define QSFP_DD_NOM_WAVELENGTH_LSB		0xB
+#define QSFP_DD_WAVELENGTH_TOL_MSB		0xC
+#define QSFP_DD_WAVELENGTH_TOL_LSB		0xD
 
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
index 3c1a300..a4d7e08 100644
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
@@ -829,36 +866,16 @@ void sff8636_show_all(const __u8 *id, __u32 eeprom_len)
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
+		sff8636_show_dom(page_zero->data, page_three->data, ETH_MODULE_SFF_8636_MAX_LEN);
+}
diff --git a/qsfp.h b/qsfp.h
index 9636b0c..23d48f0 100644
--- a/qsfp.h
+++ b/qsfp.h
@@ -592,32 +592,36 @@
  * Offset - Page Num(3) * PageSize(0x80) + Page offset
  */
 
+/* 3 * 128 + Lower page 00h(128) */
+#define SFF8636_PAGE03H_OFFSET (128 * 4)
+
 /* Module Thresholds (48 Bytes) 128-175 */
+/* Offset relative to half page boundary at offset 128 */
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
+#define	SFF8636_TEMP_HALRM	0x0
+#define	SFF8636_TEMP_LALRM	0x2
+#define	SFF8636_TEMP_HWARN	0x4
+#define	SFF8636_TEMP_LWARN	0x6
+
+#define	SFF8636_VCC_HALRM	0x10
+#define	SFF8636_VCC_LALRM	0x12
+#define	SFF8636_VCC_HWARN	0x14
+#define	SFF8636_VCC_LWARN	0x16
+
+#define	SFF8636_RX_PWR_HALRM	0x30
+#define	SFF8636_RX_PWR_LALRM	0x32
+#define	SFF8636_RX_PWR_HWARN	0x34
+#define	SFF8636_RX_PWR_LWARN	0x36
+
+#define	SFF8636_TX_BIAS_HALRM	0x38
+#define	SFF8636_TX_BIAS_LALRM	0x3A
+#define	SFF8636_TX_BIAS_HWARN	0x3C
+#define	SFF8636_TX_BIAS_LWARN	0x3E
+
+#define	SFF8636_TX_PWR_HALRM	0x40
+#define	SFF8636_TX_PWR_LALRM	0x42
+#define	SFF8636_TX_PWR_HWARN	0x44
+#define	SFF8636_TX_PWR_LWARN	0x46
 
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
2.26.2

