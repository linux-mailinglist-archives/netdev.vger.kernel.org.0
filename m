Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 795F9368DE0
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 09:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241202AbhDWHY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 03:24:27 -0400
Received: from mail-bn7nam10on2042.outbound.protection.outlook.com ([40.107.92.42]:19834
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229982AbhDWHY0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 03:24:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IjoS0kcbA1NWbjgrfxNzJVf/JxZapC9Gk+2A1dcSMcU5Jq1MrJ2gq+aYlgwBMEoaoRKJMaHB9FW3gEEOb1SSvkLepcnHzIYawoLQM/0Cd3ta49SQYyA+CS5Ly7WgbefVwyr58Ca/wAFSMjzmSSqWpuEjxGibfMIlQy+p/sJGZwrjwbM55F9weUQbLZjvyX/ji7+bo1ilwK1Hc0cXOHLT4d4HjYgcDTTzD16zCJrR50OYXcIRonsjJgabRRHDX+2kYwBiPoz7/xV0Tu/ZIRkLMxIflGgpSzasnFxAz4U92jskDBxUElmm+0BzCvA7ENrHRCSXejwcGa3TKNLjmBLQ/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9F6jbetaVIfbamGKIXjHsiCLThWAhFTe5Ew+elNLrlw=;
 b=A/pSOgSsM9m3J3GmlOOhKJivsRKAMHaOmHr4CwKZqACfm5BmG/E1EkNkf2d6MQviZ07+Pdojw3DnUY2KCaXHDFwVtb7BAUunoQjybDmrXuwsT7mWlivvVC69u0rnQrx81ldoXvY8WglnKpRsUEqKsA1FPB+xeiG+RX/Atukvp9ty67PhasV5Uomdvtb8aALYS28QqTUSswUUy4BKMBPN4gkebmsn+UmumN4ElDKdQD7v7CBAbuxjgwrPycpNg4sUM2OOYLePHb1PBH/OtX9udyXT38FC852U7Xla07RtHaITz2D176ZlJd7hSonGePOClp/dDI9iePy/+lEx76GPMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=thebollingers.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9F6jbetaVIfbamGKIXjHsiCLThWAhFTe5Ew+elNLrlw=;
 b=V+D5Ph/f2BeBn04rpYePcS9ySNQS8jyEiOnOiwJxDjYLdY684NBgx3rVYJ8yLAs5RBxmPuzSP0VaRmvgGMQJ6z7sERYTXJwvwiPunDS8o+ioh50TfZagp+JWW6qEkRnI6m04EnYpE7rfHjBQdN1iuCjde8XpFP4cdWVT2CucuqTBU2Nd/N3iJ0JqIHdw3gVVCTDWAB4XUM2OUjmQ+5mpIIrV6byaZ7NHrSwcbhLH5MzUcXIhPf3bmqAaAUyaCiSnX383p9Kn6zt2349foSWzLz7f4PgIxCcmKhO1a4lAAd8IkX9hEGC0oTcNzFU1b4SX1vTk5YQG4jEWGKlAhmxiyQ==
Received: from DM5PR21CA0055.namprd21.prod.outlook.com (2603:10b6:3:129::17)
 by DM4PR12MB5312.namprd12.prod.outlook.com (2603:10b6:5:39d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Fri, 23 Apr
 2021 07:23:48 +0000
Received: from DM6NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:129:cafe::19) by DM5PR21CA0055.outlook.office365.com
 (2603:10b6:3:129::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.10 via Frontend
 Transport; Fri, 23 Apr 2021 07:23:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; thebollingers.org; dkim=none (message not signed)
 header.d=none;thebollingers.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT031.mail.protection.outlook.com (10.13.172.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Fri, 23 Apr 2021 07:23:48 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 23 Apr
 2021 00:23:47 -0700
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 23 Apr 2021 07:23:45 +0000
From:   Moshe Shemesh <moshe@nvidia.com>
To:     Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Don Bollinger <don@thebollingers.org>, <netdev@vger.kernel.org>
CC:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH ethtool-next 3/4] ethtool: Rename QSFP-DD identifiers to use CMIS 4.0
Date:   Fri, 23 Apr 2021 10:23:15 +0300
Message-ID: <1619162596-23846-4-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1619162596-23846-1-git-send-email-moshe@nvidia.com>
References: <1619162596-23846-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b53b23d-8d62-4cd0-3eb8-08d90628bcd9
X-MS-TrafficTypeDiagnostic: DM4PR12MB5312:
X-Microsoft-Antispam-PRVS: <DM4PR12MB531243065A5C105136986405D4459@DM4PR12MB5312.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:820;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T+U9QOt6H9aXrXRFkPtDVGq0G0Rycc8DTJRuIweQuxQAX2Ms1rWryytTw45tgQTS6tL3hLZ4g+myyxvcVPe2WWHnI6CxVKYlFAgwHnPvPaCCOO9BNajuHcUhS4gwNqwU82hPwmQb7lFKhI/2iahwEMzXr9gpGs9gesRIR9VlXil+Z3R5ABCGFmoQnzSKFkTuhtFm7Nq9BPswYfZpCyjQiPYiahjqjJ/TUc1JrEKK+JOqIVQIAt5BpwYTfJLMuPD77oiy4Qcg1gjMddMAJEUll/bIJD1C+uQOrL6P2PiOxqj40a+FJOyk2dynhWC7uLoDhnbGTxy7akNZp/KNA2/4sp2qz5zfIwPyjgqStOXoBpDBzT4c/AbDXEXitlfW5cNvIdm5E21gZ7SRV/Xb4pLhxijWdXWyHTx2X5ZAijwwvNX/5vRpPVVOweTMB/8IpyZNvdd6p7YuKld4Vll4mNJwtPNhK+F96GYNdYttH2kKr7S34Kac8t0D3cuVz5qOM2Lt16rE1GeNuQ1HABPFqZ4Am/hKCgtO9UGc9zHQdnRWKW920roM5CbrEH/XTjCfP6McZySE1UuQPkYcoU3QuVCQ0Sz5rLz1CVIM1Y7ypdnQIoRGXYj1dm6vyiIUuqIgXZkOP4GtKn44b19b93Zu6qXuQYNqHEv/ySKPE1VypE+kicw=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(39860400002)(376002)(46966006)(36840700001)(2616005)(26005)(7696005)(36756003)(2906002)(5660300002)(70206006)(336012)(30864003)(426003)(6666004)(356005)(186003)(86362001)(83380400001)(82740400003)(7636003)(54906003)(82310400003)(36860700001)(70586007)(8936002)(47076005)(316002)(4326008)(8676002)(107886003)(110136005)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 07:23:48.4919
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b53b23d-8d62-4cd0-3eb8-08d90628bcd9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5312
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>

QSFP-DD and DSFP EEPROM layout complies to CMIS 4.0 specification. As
DSFP support is added, there are currently two standards, which share
the same infrastructure. Rename QSFP_DD and qsfp_dd occurrences to use
CMIS4 or cmis4 respectively to make function names generic for any
module compliant to CMIS 4.0.

Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
---
 Makefile.am             |   2 +-
 qsfp-dd.c => cmis4.c    | 210 ++++++++++++++++++++--------------------
 cmis4.h                 | 128 ++++++++++++++++++++++++
 netlink/module-eeprom.c |   2 +-
 qsfp-dd.h               | 128 ------------------------
 qsfp.c                  |   2 +-
 6 files changed, 236 insertions(+), 236 deletions(-)
 rename qsfp-dd.c => cmis4.c (56%)
 create mode 100644 cmis4.h
 delete mode 100644 qsfp-dd.h

diff --git a/Makefile.am b/Makefile.am
index 9734bde..1913f84 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -17,7 +17,7 @@ ethtool_SOURCES += \
 		  smsc911x.c at76c50x-usb.c sfc.c stmmac.c	\
 		  sff-common.c sff-common.h sfpid.c sfpdiag.c	\
 		  ixgbevf.c tse.c vmxnet3.c qsfp.c qsfp.h fjes.c lan78xx.c \
-		  igc.c qsfp-dd.c qsfp-dd.h bnxt.c
+		  igc.c cmis4.c cmis4.h bnxt.c
 endif
 
 if ENABLE_BASH_COMPLETION
diff --git a/qsfp-dd.c b/cmis4.c
similarity index 56%
rename from qsfp-dd.c
rename to cmis4.c
index 5c2e4a0..7859217 100644
--- a/qsfp-dd.c
+++ b/cmis4.c
@@ -11,21 +11,21 @@
 #include <math.h>
 #include "internal.h"
 #include "sff-common.h"
-#include "qsfp-dd.h"
+#include "cmis4.h"
 
-static void qsfp_dd_show_identifier(const __u8 *id)
+static void cmis4_show_identifier(const __u8 *id)
 {
-	sff8024_show_identifier(id, QSFP_DD_ID_OFFSET);
+	sff8024_show_identifier(id, CMIS4_ID_OFFSET);
 }
 
-static void qsfp_dd_show_connector(const __u8 *id)
+static void cmis4_show_connector(const __u8 *id)
 {
-	sff8024_show_connector(id, QSFP_DD_CTOR_OFFSET);
+	sff8024_show_connector(id, CMIS4_CTOR_OFFSET);
 }
 
-static void qsfp_dd_show_oui(const __u8 *id)
+static void cmis4_show_oui(const __u8 *id)
 {
-	sff8024_show_oui(id, QSFP_DD_VENDOR_OUI_OFFSET);
+	sff8024_show_oui(id, CMIS4_VENDOR_OUI_OFFSET);
 }
 
 /**
@@ -33,9 +33,9 @@ static void qsfp_dd_show_oui(const __u8 *id)
  * [1] CMIS Rev. 3, pag. 45, section 1.7.2.1, Table 18
  * [2] CMIS Rev. 4, pag. 81, section 8.2.1, Table 8-2
  */
-static void qsfp_dd_show_rev_compliance(const __u8 *id)
+static void cmis4_show_rev_compliance(const __u8 *id)
 {
-	__u8 rev = id[QSFP_DD_REV_COMPLIANCE_OFFSET];
+	__u8 rev = id[CMIS4_REV_COMPLIANCE_OFFSET];
 	int major = (rev >> 4) & 0x0F;
 	int minor = rev & 0x0F;
 
@@ -49,17 +49,17 @@ static void qsfp_dd_show_rev_compliance(const __u8 *id)
  * [2] CMIS Rev. 4, pag. 94, section 8.3.9, Table 8-18
  * [3] QSFP-DD Hardware Rev 5.0, pag. 22, section 4.2.1
  */
-static void qsfp_dd_show_power_info(const __u8 *id)
+static void cmis4_show_power_info(const __u8 *id)
 {
 	float max_power = 0.0f;
 	__u8 base_power = 0;
 	__u8 power_class;
 
 	/* Get the power class (first 3 most significat bytes) */
-	power_class = (id[QSFP_DD_PWR_CLASS_OFFSET] >> 5) & 0x07;
+	power_class = (id[CMIS4_PWR_CLASS_OFFSET] >> 5) & 0x07;
 
 	/* Get the base power in multiples of 0.25W */
-	base_power = id[QSFP_DD_PWR_MAX_POWER_OFFSET];
+	base_power = id[CMIS4_PWR_MAX_POWER_OFFSET];
 	max_power = base_power * 0.25f;
 
 	printf("\t%-41s : %d\n", "Power class", power_class + 1);
@@ -74,30 +74,30 @@ static void qsfp_dd_show_power_info(const __u8 *id)
  * [1] CMIS Rev. 3, pag. 59, section 1.7.3.10, Table 31
  * [2] CMIS Rev. 4, pag. 94, section 8.3.10, Table 8-19
  */
-static void qsfp_dd_show_cbl_asm_len(const __u8 *id)
+static void cmis4_show_cbl_asm_len(const __u8 *id)
 {
 	static const char *fn = "Cable assembly length";
 	float mul = 1.0f;
 	float val = 0.0f;
 
 	/* Check if max length */
-	if (id[QSFP_DD_CBL_ASM_LEN_OFFSET] == QSFP_DD_6300M_MAX_LEN) {
+	if (id[CMIS4_CBL_ASM_LEN_OFFSET] == CMIS4_6300M_MAX_LEN) {
 		printf("\t%-41s : > 6.3km\n", fn);
 		return;
 	}
 
 	/* Get the multiplier from the first two bits */
-	switch (id[QSFP_DD_CBL_ASM_LEN_OFFSET] & QSFP_DD_LEN_MUL_MASK) {
-	case QSFP_DD_MULTIPLIER_00:
+	switch (id[CMIS4_CBL_ASM_LEN_OFFSET] & CMIS4_LEN_MUL_MASK) {
+	case CMIS4_MULTIPLIER_00:
 		mul = 0.1f;
 		break;
-	case QSFP_DD_MULTIPLIER_01:
+	case CMIS4_MULTIPLIER_01:
 		mul = 1.0f;
 		break;
-	case QSFP_DD_MULTIPLIER_10:
+	case CMIS4_MULTIPLIER_10:
 		mul = 10.0f;
 		break;
-	case QSFP_DD_MULTIPLIER_11:
+	case CMIS4_MULTIPLIER_11:
 		mul = 100.0f;
 		break;
 	default:
@@ -105,7 +105,7 @@ static void qsfp_dd_show_cbl_asm_len(const __u8 *id)
 	}
 
 	/* Get base value from first 6 bits and multiply by mul */
-	val = (id[QSFP_DD_CBL_ASM_LEN_OFFSET] & QSFP_DD_LEN_VAL_MASK);
+	val = (id[CMIS4_CBL_ASM_LEN_OFFSET] & CMIS4_LEN_VAL_MASK);
 	val = (float)val * mul;
 	printf("\t%-41s : %0.2fm\n", fn, val);
 }
@@ -117,18 +117,18 @@ static void qsfp_dd_show_cbl_asm_len(const __u8 *id)
  * [1] CMIS Rev. 3, pag. 63, section 1.7.4.2, Table 39
  * [2] CMIS Rev. 4, pag. 99, section 8.4.2, Table 8-27
  */
-static void qsfp_dd_print_smf_cbl_len(const __u8 *id)
+static void cmis4_print_smf_cbl_len(const __u8 *id)
 {
 	static const char *fn = "Length (SMF)";
 	float mul = 1.0f;
 	float val = 0.0f;
 
 	/* Get the multiplier from the first two bits */
-	switch (id[QSFP_DD_SMF_LEN_OFFSET] & QSFP_DD_LEN_MUL_MASK) {
-	case QSFP_DD_MULTIPLIER_00:
+	switch (id[CMIS4_SMF_LEN_OFFSET] & CMIS4_LEN_MUL_MASK) {
+	case CMIS4_MULTIPLIER_00:
 		mul = 0.1f;
 		break;
-	case QSFP_DD_MULTIPLIER_01:
+	case CMIS4_MULTIPLIER_01:
 		mul = 1.0f;
 		break;
 	default:
@@ -136,7 +136,7 @@ static void qsfp_dd_print_smf_cbl_len(const __u8 *id)
 	}
 
 	/* Get base value from first 6 bits and multiply by mul */
-	val = (id[QSFP_DD_SMF_LEN_OFFSET] & QSFP_DD_LEN_VAL_MASK);
+	val = (id[CMIS4_SMF_LEN_OFFSET] & CMIS4_LEN_VAL_MASK);
 	val = (float)val * mul;
 	printf("\t%-41s : %0.2fkm\n", fn, val);
 }
@@ -146,21 +146,21 @@ static void qsfp_dd_print_smf_cbl_len(const __u8 *id)
  * [1] CMIS Rev. 3, pag. 71, section 1.7.4.10, Table 46
  * [2] CMIS Rev. 4, pag. 105, section 8.4.10, Table 8-34
  */
-static void qsfp_dd_show_sig_integrity(const __u8 *id)
+static void cmis4_show_sig_integrity(const __u8 *id)
 {
 	/* CDR Bypass control: 2nd bit from each byte */
 	printf("\t%-41s : ", "Tx CDR bypass control");
-	printf("%s\n", YESNO(id[QSFP_DD_SIG_INTEG_TX_OFFSET] & 0x02));
+	printf("%s\n", YESNO(id[CMIS4_SIG_INTEG_TX_OFFSET] & 0x02));
 
 	printf("\t%-41s : ", "Rx CDR bypass control");
-	printf("%s\n", YESNO(id[QSFP_DD_SIG_INTEG_RX_OFFSET] & 0x02));
+	printf("%s\n", YESNO(id[CMIS4_SIG_INTEG_RX_OFFSET] & 0x02));
 
 	/* CDR Implementation: 1st bit from each byte */
 	printf("\t%-41s : ", "Tx CDR");
-	printf("%s\n", YESNO(id[QSFP_DD_SIG_INTEG_TX_OFFSET] & 0x01));
+	printf("%s\n", YESNO(id[CMIS4_SIG_INTEG_TX_OFFSET] & 0x01));
 
 	printf("\t%-41s : ", "Rx CDR");
-	printf("%s\n", YESNO(id[QSFP_DD_SIG_INTEG_RX_OFFSET] & 0x01));
+	printf("%s\n", YESNO(id[CMIS4_SIG_INTEG_RX_OFFSET] & 0x01));
 }
 
 /**
@@ -173,80 +173,80 @@ static void qsfp_dd_show_sig_integrity(const __u8 *id)
  * --> pag. 98, section 8.4, Table 8-25
  * --> page 100, section 8.4.3, 8.4.4
  */
-static void qsfp_dd_show_mit_compliance(const __u8 *id)
+static void cmis4_show_mit_compliance(const __u8 *id)
 {
 	static const char *cc = " (Copper cable,";
 
 	printf("\t%-41s : 0x%02x", "Transmitter technology",
-	       id[QSFP_DD_MEDIA_INTF_TECH_OFFSET]);
+	       id[CMIS4_MEDIA_INTF_TECH_OFFSET]);
 
-	switch (id[QSFP_DD_MEDIA_INTF_TECH_OFFSET]) {
-	case QSFP_DD_850_VCSEL:
+	switch (id[CMIS4_MEDIA_INTF_TECH_OFFSET]) {
+	case CMIS4_850_VCSEL:
 		printf(" (850 nm VCSEL)\n");
 		break;
-	case QSFP_DD_1310_VCSEL:
+	case CMIS4_1310_VCSEL:
 		printf(" (1310 nm VCSEL)\n");
 		break;
-	case QSFP_DD_1550_VCSEL:
+	case CMIS4_1550_VCSEL:
 		printf(" (1550 nm VCSEL)\n");
 		break;
-	case QSFP_DD_1310_FP:
+	case CMIS4_1310_FP:
 		printf(" (1310 nm FP)\n");
 		break;
-	case QSFP_DD_1310_DFB:
+	case CMIS4_1310_DFB:
 		printf(" (1310 nm DFB)\n");
 		break;
-	case QSFP_DD_1550_DFB:
+	case CMIS4_1550_DFB:
 		printf(" (1550 nm DFB)\n");
 		break;
-	case QSFP_DD_1310_EML:
+	case CMIS4_1310_EML:
 		printf(" (1310 nm EML)\n");
 		break;
-	case QSFP_DD_1550_EML:
+	case CMIS4_1550_EML:
 		printf(" (1550 nm EML)\n");
 		break;
-	case QSFP_DD_OTHERS:
+	case CMIS4_OTHERS:
 		printf(" (Others/Undefined)\n");
 		break;
-	case QSFP_DD_1490_DFB:
+	case CMIS4_1490_DFB:
 		printf(" (1490 nm DFB)\n");
 		break;
-	case QSFP_DD_COPPER_UNEQUAL:
+	case CMIS4_COPPER_UNEQUAL:
 		printf("%s unequalized)\n", cc);
 		break;
-	case QSFP_DD_COPPER_PASS_EQUAL:
+	case CMIS4_COPPER_PASS_EQUAL:
 		printf("%s passive equalized)\n", cc);
 		break;
-	case QSFP_DD_COPPER_NF_EQUAL:
+	case CMIS4_COPPER_NF_EQUAL:
 		printf("%s near and far end limiting active equalizers)\n", cc);
 		break;
-	case QSFP_DD_COPPER_F_EQUAL:
+	case CMIS4_COPPER_F_EQUAL:
 		printf("%s far end limiting active equalizers)\n", cc);
 		break;
-	case QSFP_DD_COPPER_N_EQUAL:
+	case CMIS4_COPPER_N_EQUAL:
 		printf("%s near end limiting active equalizers)\n", cc);
 		break;
-	case QSFP_DD_COPPER_LINEAR_EQUAL:
+	case CMIS4_COPPER_LINEAR_EQUAL:
 		printf("%s linear active equalizers)\n", cc);
 		break;
 	}
 
-	if (id[QSFP_DD_MEDIA_INTF_TECH_OFFSET] >= QSFP_DD_COPPER_UNEQUAL) {
+	if (id[CMIS4_MEDIA_INTF_TECH_OFFSET] >= CMIS4_COPPER_UNEQUAL) {
 		printf("\t%-41s : %udb\n", "Attenuation at 5GHz",
-		       id[QSFP_DD_COPPER_ATT_5GHZ]);
+		       id[CMIS4_COPPER_ATT_5GHZ]);
 		printf("\t%-41s : %udb\n", "Attenuation at 7GHz",
-		       id[QSFP_DD_COPPER_ATT_7GHZ]);
+		       id[CMIS4_COPPER_ATT_7GHZ]);
 		printf("\t%-41s : %udb\n", "Attenuation at 12.9GHz",
-		       id[QSFP_DD_COPPER_ATT_12P9GHZ]);
+		       id[CMIS4_COPPER_ATT_12P9GHZ]);
 		printf("\t%-41s : %udb\n", "Attenuation at 25.8GHz",
-		       id[QSFP_DD_COPPER_ATT_25P8GHZ]);
+		       id[CMIS4_COPPER_ATT_25P8GHZ]);
 	} else {
 		printf("\t%-41s : %.3lfnm\n", "Laser wavelength",
-		       (((id[QSFP_DD_NOM_WAVELENGTH_MSB] << 8) |
-				id[QSFP_DD_NOM_WAVELENGTH_LSB]) * 0.05));
+		       (((id[CMIS4_NOM_WAVELENGTH_MSB] << 8) |
+				id[CMIS4_NOM_WAVELENGTH_LSB]) * 0.05));
 		printf("\t%-41s : %.3lfnm\n", "Laser wavelength tolerance",
-		       (((id[QSFP_DD_WAVELENGTH_TOL_MSB] << 8) |
-		       id[QSFP_DD_WAVELENGTH_TOL_LSB]) * 0.005));
+		       (((id[CMIS4_WAVELENGTH_TOL_MSB] << 8) |
+		       id[CMIS4_WAVELENGTH_TOL_LSB]) * 0.005));
 	}
 }
 
@@ -266,24 +266,24 @@ static void qsfp_dd_show_mit_compliance(const __u8 *id)
  * [2] CMIS Rev. 4:
  * --> pag. 84, section 8.2.4, Table 8-6
  */
-static void qsfp_dd_show_mod_lvl_monitors(const __u8 *id)
+static void cmis4_show_mod_lvl_monitors(const __u8 *id)
 {
 	PRINT_TEMP("Module temperature",
-		   OFFSET_TO_TEMP(QSFP_DD_CURR_TEMP_OFFSET));
+		   OFFSET_TO_TEMP(CMIS4_CURR_TEMP_OFFSET));
 	PRINT_VCC("Module voltage",
-		  OFFSET_TO_U16(QSFP_DD_CURR_CURR_OFFSET));
+		  OFFSET_TO_U16(CMIS4_CURR_CURR_OFFSET));
 }
 
-static void qsfp_dd_show_link_len_from_page(const __u8 *page_one_data)
+static void cmis4_show_link_len_from_page(const __u8 *page_one_data)
 {
-	qsfp_dd_print_smf_cbl_len(page_one_data);
-	sff_show_value_with_unit(page_one_data, QSFP_DD_OM5_LEN_OFFSET,
+	cmis4_print_smf_cbl_len(page_one_data);
+	sff_show_value_with_unit(page_one_data, CMIS4_OM5_LEN_OFFSET,
 				 "Length (OM5)", 2, "m");
-	sff_show_value_with_unit(page_one_data, QSFP_DD_OM4_LEN_OFFSET,
+	sff_show_value_with_unit(page_one_data, CMIS4_OM4_LEN_OFFSET,
 				 "Length (OM4)", 2, "m");
-	sff_show_value_with_unit(page_one_data, QSFP_DD_OM3_LEN_OFFSET,
+	sff_show_value_with_unit(page_one_data, CMIS4_OM3_LEN_OFFSET,
 				 "Length (OM3 50/125um)", 2, "m");
-	sff_show_value_with_unit(page_one_data, QSFP_DD_OM2_LEN_OFFSET,
+	sff_show_value_with_unit(page_one_data, CMIS4_OM2_LEN_OFFSET,
 				 "Length (OM2 50/125um)", 1, "m");
 }
 
@@ -295,9 +295,9 @@ static void qsfp_dd_show_link_len_from_page(const __u8 *page_one_data)
  * [1] CMIS Rev. 3, page 64, section 1.7.4.2, Table 39
  * [2] CMIS Rev. 4, page 99, section 8.4.2, Table 8-27
  */
-static void qsfp_dd_show_link_len(const __u8 *id)
+static void cmis4_show_link_len(const __u8 *id)
 {
-	qsfp_dd_show_link_len_from_page(id + PAG01H_UPPER_OFFSET);
+	cmis4_show_link_len_from_page(id + PAG01H_UPPER_OFFSET);
 }
 
 /**
@@ -305,37 +305,37 @@ static void qsfp_dd_show_link_len(const __u8 *id)
  * [1] CMIS Rev. 3, page 56, section 1.7.3, Table 27
  * [2] CMIS Rev. 4, page 91, section 8.2, Table 8-15
  */
-static void qsfp_dd_show_vendor_info(const __u8 *id)
+static void cmis4_show_vendor_info(const __u8 *id)
 {
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
+	sff_show_ascii(id, CMIS4_VENDOR_NAME_START_OFFSET,
+		       CMIS4_VENDOR_NAME_END_OFFSET, "Vendor name");
+	cmis4_show_oui(id);
+	sff_show_ascii(id, CMIS4_VENDOR_PN_START_OFFSET,
+		       CMIS4_VENDOR_PN_END_OFFSET, "Vendor PN");
+	sff_show_ascii(id, CMIS4_VENDOR_REV_START_OFFSET,
+		       CMIS4_VENDOR_REV_END_OFFSET, "Vendor rev");
+	sff_show_ascii(id, CMIS4_VENDOR_SN_START_OFFSET,
+		       CMIS4_VENDOR_SN_END_OFFSET, "Vendor SN");
+	sff_show_ascii(id, CMIS4_DATE_YEAR_OFFSET,
+		       CMIS4_DATE_VENDOR_LOT_OFFSET + 1, "Date code");
+
+	if (id[CMIS4_CLEI_PRESENT_BYTE] & CMIS4_CLEI_PRESENT_MASK)
+		sff_show_ascii(id, CMIS4_CLEI_START_OFFSET,
+			       CMIS4_CLEI_END_OFFSET, "CLEI code");
 }
 
 void qsfp_dd_show_all(const __u8 *id)
 {
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
+	cmis4_show_identifier(id);
+	cmis4_show_power_info(id);
+	cmis4_show_connector(id);
+	cmis4_show_cbl_asm_len(id);
+	cmis4_show_sig_integrity(id);
+	cmis4_show_mit_compliance(id);
+	cmis4_show_mod_lvl_monitors(id);
+	cmis4_show_link_len(id);
+	cmis4_show_vendor_info(id);
+	cmis4_show_rev_compliance(id);
 }
 
 void cmis4_show_all(const struct ethtool_module_eeprom *page_zero,
@@ -343,17 +343,17 @@ void cmis4_show_all(const struct ethtool_module_eeprom *page_zero,
 {
 	const __u8 *page_zero_data = page_zero->data;
 
-	qsfp_dd_show_identifier(page_zero_data);
-	qsfp_dd_show_power_info(page_zero_data);
-	qsfp_dd_show_connector(page_zero_data);
-	qsfp_dd_show_cbl_asm_len(page_zero_data);
-	qsfp_dd_show_sig_integrity(page_zero_data);
-	qsfp_dd_show_mit_compliance(page_zero_data);
-	qsfp_dd_show_mod_lvl_monitors(page_zero_data);
+	cmis4_show_identifier(page_zero_data);
+	cmis4_show_power_info(page_zero_data);
+	cmis4_show_connector(page_zero_data);
+	cmis4_show_cbl_asm_len(page_zero_data);
+	cmis4_show_sig_integrity(page_zero_data);
+	cmis4_show_mit_compliance(page_zero_data);
+	cmis4_show_mod_lvl_monitors(page_zero_data);
 
 	if (page_one)
-		qsfp_dd_show_link_len_from_page(page_one->data);
+		cmis4_show_link_len_from_page(page_one->data);
 
-	qsfp_dd_show_vendor_info(page_zero_data);
-	qsfp_dd_show_rev_compliance(page_zero_data);
+	cmis4_show_vendor_info(page_zero_data);
+	cmis4_show_rev_compliance(page_zero_data);
 }
diff --git a/cmis4.h b/cmis4.h
new file mode 100644
index 0000000..ba2b2e2
--- /dev/null
+++ b/cmis4.h
@@ -0,0 +1,128 @@
+#ifndef CMIS4_H__
+#define CMIS4_H__
+
+/* Identifier and revision compliance (Page 0) */
+#define CMIS4_ID_OFFSET				0x00
+#define CMIS4_REV_COMPLIANCE_OFFSET		0x01
+
+#define CMIS4_MODULE_TYPE_OFFSET		0x55
+#define CMIS4_MT_MMF				0x01
+#define CMIS4_MT_SMF				0x02
+
+/* Module-Level Monitors (Page 0) */
+#define CMIS4_CURR_TEMP_OFFSET			0x0E
+#define CMIS4_CURR_CURR_OFFSET			0x10
+
+#define CMIS4_CTOR_OFFSET			0xCB
+
+/* Vendor related information (Page 0) */
+#define CMIS4_VENDOR_NAME_START_OFFSET		0x81
+#define CMIS4_VENDOR_NAME_END_OFFSET		0x90
+
+#define CMIS4_VENDOR_OUI_OFFSET			0x91
+
+#define CMIS4_VENDOR_PN_START_OFFSET		0x94
+#define CMIS4_VENDOR_PN_END_OFFSET		0xA3
+
+#define CMIS4_VENDOR_REV_START_OFFSET		0xA4
+#define CMIS4_VENDOR_REV_END_OFFSET		0xA5
+
+#define CMIS4_VENDOR_SN_START_OFFSET		0xA6
+#define CMIS4_VENDOR_SN_END_OFFSET		0xB5
+
+#define CMIS4_DATE_YEAR_OFFSET			0xB6
+#define CMIS4_DATE_VENDOR_LOT_OFFSET		0xBC
+
+/* CLEI Code (Page 0) */
+#define CMIS4_CLEI_PRESENT_BYTE			0x02
+#define CMIS4_CLEI_PRESENT_MASK			0x20
+#define CMIS4_CLEI_START_OFFSET			0xBE
+#define CMIS4_CLEI_END_OFFSET			0xC7
+
+/* Cable assembly length */
+#define CMIS4_CBL_ASM_LEN_OFFSET		0xCA
+#define CMIS4_6300M_MAX_LEN			0xFF
+
+/* Cable length with multiplier */
+#define CMIS4_MULTIPLIER_00			0x00
+#define CMIS4_MULTIPLIER_01			0x40
+#define CMIS4_MULTIPLIER_10			0x80
+#define CMIS4_MULTIPLIER_11			0xC0
+#define CMIS4_LEN_MUL_MASK			0xC0
+#define CMIS4_LEN_VAL_MASK			0x3F
+
+/* Module power characteristics */
+#define CMIS4_PWR_CLASS_OFFSET			0xC8
+#define CMIS4_PWR_MAX_POWER_OFFSET		0xC9
+#define CMIS4_PWR_CLASS_MASK			0xE0
+#define CMIS4_PWR_CLASS_1			0x00
+#define CMIS4_PWR_CLASS_2			0x01
+#define CMIS4_PWR_CLASS_3			0x02
+#define CMIS4_PWR_CLASS_4			0x03
+#define CMIS4_PWR_CLASS_5			0x04
+#define CMIS4_PWR_CLASS_6			0x05
+#define CMIS4_PWR_CLASS_7			0x06
+#define CMIS4_PWR_CLASS_8			0x07
+
+/* Copper cable attenuation */
+#define CMIS4_COPPER_ATT_5GHZ			0xCC
+#define CMIS4_COPPER_ATT_7GHZ			0xCD
+#define CMIS4_COPPER_ATT_12P9GHZ		0xCE
+#define CMIS4_COPPER_ATT_25P8GHZ		0xCF
+
+/* Cable assembly lane */
+#define CMIS4_CABLE_ASM_NEAR_END_OFFSET		0xD2
+#define CMIS4_CABLE_ASM_FAR_END_OFFSET		0xD3
+
+/* Media interface technology */
+#define CMIS4_MEDIA_INTF_TECH_OFFSET		0xD4
+#define CMIS4_850_VCSEL				0x00
+#define CMIS4_1310_VCSEL			0x01
+#define CMIS4_1550_VCSEL			0x02
+#define CMIS4_1310_FP				0x03
+#define CMIS4_1310_DFB				0x04
+#define CMIS4_1550_DFB				0x05
+#define CMIS4_1310_EML				0x06
+#define CMIS4_1550_EML				0x07
+#define CMIS4_OTHERS				0x08
+#define CMIS4_1490_DFB				0x09
+#define CMIS4_COPPER_UNEQUAL			0x0A
+#define CMIS4_COPPER_PASS_EQUAL			0x0B
+#define CMIS4_COPPER_NF_EQUAL			0x0C
+#define CMIS4_COPPER_F_EQUAL			0x0D
+#define CMIS4_COPPER_N_EQUAL			0x0E
+#define CMIS4_COPPER_LINEAR_EQUAL		0x0F
+
+/*-----------------------------------------------------------------------
+ * Upper Memory Page 0x01: contains advertising fields that define properties
+ * that are unique to active modules and cable assemblies.
+ * GlobalOffset = 2 * 0x80 + LocalOffset
+ */
+#define PAG01H_UPPER_OFFSET			(0x02 * 0x80)
+
+/* Supported Link Length (Page 1) */
+#define CMIS4_SMF_LEN_OFFSET			0x4
+#define CMIS4_OM5_LEN_OFFSET			0x5
+#define CMIS4_OM4_LEN_OFFSET			0x6
+#define CMIS4_OM3_LEN_OFFSET			0x7
+#define CMIS4_OM2_LEN_OFFSET			0x8
+
+/* Wavelength (Page 1) */
+#define CMIS4_NOM_WAVELENGTH_MSB		0xA
+#define CMIS4_NOM_WAVELENGTH_LSB		0xB
+#define CMIS4_WAVELENGTH_TOL_MSB		0xC
+#define CMIS4_WAVELENGTH_TOL_LSB		0xD
+
+/* Signal integrity controls */
+#define CMIS4_SIG_INTEG_TX_OFFSET		0xA1
+#define CMIS4_SIG_INTEG_RX_OFFSET		0xA2
+
+#define YESNO(x) (((x) != 0) ? "Yes" : "No")
+#define ONOFF(x) (((x) != 0) ? "On" : "Off")
+
+void qsfp_dd_show_all(const __u8 *id);
+
+void cmis4_show_all(const struct ethtool_module_eeprom *page_zero,
+		    const struct ethtool_module_eeprom *page_one);
+
+#endif /* CMIS4_H__ */
diff --git a/netlink/module-eeprom.c b/netlink/module-eeprom.c
index 768a261..5f58125 100644
--- a/netlink/module-eeprom.c
+++ b/netlink/module-eeprom.c
@@ -11,7 +11,7 @@
 
 #include "../sff-common.h"
 #include "../qsfp.h"
-#include "../qsfp-dd.h"
+#include "../cmis4.h"
 #include "../internal.h"
 #include "../common.h"
 #include "../list.h"
diff --git a/qsfp-dd.h b/qsfp-dd.h
deleted file mode 100644
index fddb188..0000000
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
-#define QSFP_DD_SMF_LEN_OFFSET			0x4
-#define QSFP_DD_OM5_LEN_OFFSET			0x5
-#define QSFP_DD_OM4_LEN_OFFSET			0x6
-#define QSFP_DD_OM3_LEN_OFFSET			0x7
-#define QSFP_DD_OM2_LEN_OFFSET			0x8
-
-/* Wavelength (Page 1) */
-#define QSFP_DD_NOM_WAVELENGTH_MSB		0xA
-#define QSFP_DD_NOM_WAVELENGTH_LSB		0xB
-#define QSFP_DD_WAVELENGTH_TOL_MSB		0xC
-#define QSFP_DD_WAVELENGTH_TOL_LSB		0xD
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
-void cmis4_show_all(const struct ethtool_module_eeprom *page_zero,
-		    const struct ethtool_module_eeprom *page_one);
-
-#endif /* QSFP_DD_H__ */
diff --git a/qsfp.c b/qsfp.c
index a4d7e08..5923c0d 100644
--- a/qsfp.c
+++ b/qsfp.c
@@ -58,7 +58,7 @@
 #include "internal.h"
 #include "sff-common.h"
 #include "qsfp.h"
-#include "qsfp-dd.h"
+#include "cmis4.h"
 
 #define MAX_DESC_SIZE	42
 
-- 
2.26.2

