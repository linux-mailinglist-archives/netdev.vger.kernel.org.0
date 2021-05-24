Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71C1E38E890
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 16:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232994AbhEXOVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 10:21:38 -0400
Received: from mail-mw2nam10on2084.outbound.protection.outlook.com ([40.107.94.84]:27104
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232997AbhEXOVd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 10:21:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F/GRZRR24jt7sMLQsidEUfK03SE4D8EVDjyoWFAEb1qN4QF/GAygR5L6c7HICwFWbMm78UVXUUVCUT23jrSp6uotGP2aRQjSqTxgJguFqtLMqLbm2r4wDpWU7XqtJiXDKPLavi+wp7LGUmH0GFsWcbhD1Kgi4OzGJ6O4LFhh8aBs/kGK3iYtzRyM4mUX97/yYnIdTu1PimQOsxzA+gLOQqk1lVMsCIYQCN3GGuFuezUgcCROiMmb/tsxmw4YuOPzSX/FnbhOZP16IfwF/roq7V4iUb559sbzPXNCzJiczWBteIg4DFSAt5LhVn6dsW4iVhtuCWKvTKMN+cp4MhkxIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iZXK4szqdpWl8b3xytePstHgAbbTDPSsu4cVM70Ryhw=;
 b=hOqnMshzJhWRmlKG6szaRRRozDPjzeKudTWiH3jmzE8zPJ7TUu33bO4RRNGGUN7mMRX2PPT96j/eirAdpP9yW4rn3Nd1ELCm/1/Ukj5Gcqu5/Xwis213JyeeNO8gW1W8zk1Pm5DNubDIQTSWut4bWkhMNSGGY0ZgXEU9tV2h00WnSpnLNl6uIZtn9SsPrRfKOYwR5gdKoY85iPWVWaATqBMIK076VSL6YAx9xdap5eQs8UxqTM+oX3cKEOUVSOKe5L1McGK1K4A3yAi1v1TLPNjoPGUSq34kP/u6/wMHdpiQeINM8IWO6q8oJqebo/haXmlSjZ+Yoy50VShWIfPPRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iZXK4szqdpWl8b3xytePstHgAbbTDPSsu4cVM70Ryhw=;
 b=r5a7iiLXSy7H2u9BuqY/jMi+4LvTs/KyRteESXALotmzhnR8RrkjMgcS9q1qfaX0VZfmeW9eS0kzGBcvS5DLE53iLSRe58KmQMu2w/FGE6jJoCqfVCWbG+W2fS1TeBB/Gf6i0HvgpM+fwG+7LOv9WSZMoDdL8CQVXrElGu4oxOFSCaFZ9HPcT99MONdp/ZqxP0IoX9/louPFH5R7eRNEDwYykdyZqbIcjwl0ybaZdD5HH2IfD/feebJNxh/tVhYvXXwjsBDclKQzq5GIb2lS1gD9CVkwDGP4rRkMxzAPVKwIsahaHFfHxADz7dc5rwObAKylkfbyNlKK5/VcbREvwA==
Received: from BN9PR03CA0210.namprd03.prod.outlook.com (2603:10b6:408:f9::35)
 by BYAPR12MB3496.namprd12.prod.outlook.com (2603:10b6:a03:d8::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Mon, 24 May
 2021 14:20:04 +0000
Received: from BN8NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f9:cafe::7e) by BN9PR03CA0210.outlook.office365.com
 (2603:10b6:408:f9::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend
 Transport; Mon, 24 May 2021 14:20:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT055.mail.protection.outlook.com (10.13.177.62) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Mon, 24 May 2021 14:20:03 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 24 May
 2021 14:20:03 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 24 May
 2021 14:20:02 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 24 May 2021 14:20:00 +0000
From:   Moshe Shemesh <moshe@nvidia.com>
To:     Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Don Bollinger <don@thebollingers.org>, <netdev@vger.kernel.org>
CC:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH ethtool v2 3/4] ethtool: Rename QSFP-DD identifiers to use CMIS 4.0
Date:   Mon, 24 May 2021 17:18:59 +0300
Message-ID: <1621865940-287332-4-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1621865940-287332-1-git-send-email-moshe@nvidia.com>
References: <1621865940-287332-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 32492cf2-2e61-4e07-ecb0-08d91ebf0615
X-MS-TrafficTypeDiagnostic: BYAPR12MB3496:
X-Microsoft-Antispam-PRVS: <BYAPR12MB34961F9AB79FCB52B1B4AB6CD4269@BYAPR12MB3496.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:820;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oTG/OB0JfmJdr5bAC2m3qzc+0kTPNigXFDR1Yrv1Tlf51qBvTptAGC7EzZVAVJFMR3Ew1xzpkWAnxdarbJib4T6domrmVbxrkjEWckxSFWfIXS/cC+zcRSumDd0AVQ2GYBOpkGY2Q5TiNi7wh/bG409xWGEfYL5kbTpojQZbZMhb5QJW8K8X04BeKVDu3skwAlSB4oFM4LCV94S5K3iaNCf4KjuaUOEa/nyQFJV0bU1HTTXHp5ZgLTIEHtptm4xEX3Q2UMXcf1zdyBVn+2p0s0nXuw81AZlJi8bjG4c9sDCKrkPZ7IzBAVE9x8T3aLlTqB57Bp6Yqulj+TKKGXiqgUhVe0t9gE/teGAtHVEQPL8sdbmyJoLLMhbIAAN3HrC5cO6HSkbuC9z0h7cq0gbUj+pXnGs4MpcyBvc55By64EJSUG18GP7gNkPmB97gcuFToPARqMLzSWwZnIuurDzDVSbONqERvqXw9FqkL6Och8XXuuuA2oEQxK6+VmiM7iqRjv0US6eMkGOnrqs+rSNCYqoIOzFtOwMyMVYVRsevok3MqQM0NSoe8ViUGImEdaFArLIjL0/weLbKAqb5e3ZaVkTHdwA1gZFWEksatUb0Z8FkcjjUjDmY/wrlnAP4pe5lGIhvtorI3GrmKpeVJcdUxv+uTLhLhf67w10qqe+DQaY=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39860400002)(396003)(46966006)(36840700001)(186003)(70586007)(70206006)(426003)(30864003)(5660300002)(36756003)(8676002)(26005)(47076005)(336012)(4326008)(8936002)(107886003)(2616005)(478600001)(316002)(110136005)(83380400001)(36906005)(2906002)(82740400003)(7636003)(356005)(7696005)(82310400003)(36860700001)(86362001)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2021 14:20:03.7593
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 32492cf2-2e61-4e07-ecb0-08d91ebf0615
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3496
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
 qsfp.c                  |   2 +-
 5 files changed, 236 insertions(+), 108 deletions(-)
 rename qsfp-dd.c => cmis4.c (56%)
 create mode 100644 cmis4.h

diff --git a/Makefile.am b/Makefile.am
index 6abd2b7..839c214 100644
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
index 5c2e4a0..417b916 100644
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
+		cmis4_show_link_len_from_page(page_one->data - 0x80);
 
-	qsfp_dd_show_vendor_info(page_zero_data);
-	qsfp_dd_show_rev_compliance(page_zero_data);
+	cmis4_show_vendor_info(page_zero_data);
+	cmis4_show_rev_compliance(page_zero_data);
 }
diff --git a/cmis4.h b/cmis4.h
new file mode 100644
index 0000000..2cc8e17
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
+#define CMIS4_SMF_LEN_OFFSET			0x84
+#define CMIS4_OM5_LEN_OFFSET			0x85
+#define CMIS4_OM4_LEN_OFFSET			0x86
+#define CMIS4_OM3_LEN_OFFSET			0x87
+#define CMIS4_OM2_LEN_OFFSET			0x88
+
+/* Wavelength (Page 1) */
+#define CMIS4_NOM_WAVELENGTH_MSB		0x8A
+#define CMIS4_NOM_WAVELENGTH_LSB		0x8B
+#define CMIS4_WAVELENGTH_TOL_MSB		0x8C
+#define CMIS4_WAVELENGTH_TOL_LSB		0x8D
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
index ccf5032..1debf32 100644
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
diff --git a/qsfp.c b/qsfp.c
index 211c2df..27723ae 100644
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
2.18.2

