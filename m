Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8469D13D674
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 10:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731109AbgAPJNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 04:13:09 -0500
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:28296 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730741AbgAPJNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 04:13:08 -0500
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00G99wnA010395;
        Thu, 16 Jan 2020 04:13:04 -0500
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by mx0a-00128a01.pphosted.com with ESMTP id 2xf93b59cp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jan 2020 04:13:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kavSkD2aY0TfnNkIlDR+6BMiWrmRMY5drZO+ESX/7piEQQQRt00j3MG61HZpVyl9VyOMW6UNWC4hQ+W2oNOYzVxYO7g0GdbbDxmbLCDLYuMZYsk9J/U/w56ryF989iYCtCROUk0BSgr1Iua3aAhCTTnz04I0BQi6UKWPBqYhFNIT9bsZ7Cn6oQCItpd5CSACrwK+DTDG4TOYwf1/xcGwaCltiQOOE7EdqfNF56Fkjw91k/3yrQQBabOefbJs2JGrehmO14z7nLViBYTsVuQBr7wnpQ3eSJvIPMFJeeS9Jb2DIQN5A14kG1ZGziI58Bum1sYdVW/nLFU4aHzr45gkBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gr1bMg/WQ3g9sQw4N8NqWj4BHtLBykiELSSvg5N0y38=;
 b=SS/iH03bsLQ/1xQC/I7lMSzuHLiudqTOUGT2xBp7S6HCuxPOJ5b7OKivxre3Ywv8tax49tHdeMLkscfuMpeZDQrvV/diGy9WUhUpEJf04gZ0XTcu8ixuv/i9kttNvnRSG0hJhIWTYP488hM+Quptc98Azf7aGVQ7A8LMTJMh6Tro4RhOwcziUr+Gy+W67uRLyUrjlgPlzAcdX8IoA2bDBxX6q0v48mqvdPmn8oBwdlZpmHGpROojH58UpMmBQ3qClbFue13E47pRV405fPrLFSLnqsV0PAHuzGUNqWjCbvFRSeURfVP6BFmpK2rEji4tqpXqc+cHG/gii6TEVWTB6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gr1bMg/WQ3g9sQw4N8NqWj4BHtLBykiELSSvg5N0y38=;
 b=cCvy15urbv2ZT+oM+rPqt8Vh6INiLjlkYGEm2DhQVVjcAzvIDdYBTCR7jUOX1AkKa8dVmRt62qqw9dni1JXENCncBoSkBgKqAR8R2A5DjlpQZQL7UF4tlcUaUdJJocm0iICydMlGsPbrIhh/bGv53a1ZhG3WZ/y60kMptnCsDvs=
Received: from BN6PR03CA0018.namprd03.prod.outlook.com (2603:10b6:404:23::28)
 by BYAPR03MB4406.namprd03.prod.outlook.com (2603:10b6:a03:d0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18; Thu, 16 Jan
 2020 09:13:01 +0000
Received: from SN1NAM02FT038.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::208) by BN6PR03CA0018.outlook.office365.com
 (2603:10b6:404:23::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.19 via Frontend
 Transport; Thu, 16 Jan 2020 09:13:01 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 SN1NAM02FT038.mail.protection.outlook.com (10.152.72.69) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2644.19
 via Frontend Transport; Thu, 16 Jan 2020 09:13:00 +0000
Received: from SCSQMBX10.ad.analog.com (scsqmbx10.ad.analog.com [10.77.17.5])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id 00G9Clgv032333
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL);
        Thu, 16 Jan 2020 01:12:48 -0800
Received: from SCSQMBX11.ad.analog.com (10.77.17.10) by
 SCSQMBX10.ad.analog.com (10.77.17.5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 16 Jan 2020 01:12:57 -0800
Received: from zeus.spd.analog.com (10.64.82.11) by SCSQMBX11.ad.analog.com
 (10.77.17.10) with Microsoft SMTP Server id 15.1.1779.2 via Frontend
 Transport; Thu, 16 Jan 2020 01:12:57 -0800
Received: from saturn.ad.analog.com ([10.48.65.124])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 00G9CkjY020088;
        Thu, 16 Jan 2020 04:12:54 -0500
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 3/4] net: phy: adin: implement support for 1588 start-of-packet indication
Date:   Thu, 16 Jan 2020 11:14:53 +0200
Message-ID: <20200116091454.16032-4-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116091454.16032-1-alexandru.ardelean@analog.com>
References: <20200116091454.16032-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(396003)(136003)(39860400002)(376002)(346002)(189003)(199004)(426003)(478600001)(26005)(2616005)(86362001)(336012)(8676002)(5660300002)(356004)(186003)(44832011)(246002)(4326008)(70586007)(316002)(8936002)(1076003)(110136005)(54906003)(36756003)(7696005)(70206006)(2906002)(107886003)(7636002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR03MB4406;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: edb58788-8a05-4ae2-efba-08d79a6448ed
X-MS-TrafficTypeDiagnostic: BYAPR03MB4406:
X-Microsoft-Antispam-PRVS: <BYAPR03MB44068837D72F6F32E4665CD7F9360@BYAPR03MB4406.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:800;
X-Forefront-PRVS: 02843AA9E0
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lEYOmJJB7k8ZpWWm7plf4vJlDbMg0xnl14Su+MrLPmk0Ij9nT2pPlmyZ3Q0heMo/zk01qnczhyzAueCVziTxK7ukGBcExNgBeBTzZQUMtP/WROUmbPsgiiYgpq6VG8hfPL0TaFbBDV7G+UWR/EwbCh96PMZbzMEf8WbHi5udoS4X9IxOw99LjQFUP3QiQpOJijj9khYj7cz3gmK3FoTo0KFwSIwY0nqScP5y7rv8knFI6zzdIVydXfksrvCgfrQnqYPCX07pfJJM8KHViOtdglGRSWil/nAURtgQMrujZh+gX/7yL0Xcxg/3D8RReOKNz/ZGwvtT4MkE2Hj6Z7MnQZ7AEzkHT+gTr3DjnSGGyiEfhXjyZ5GEFMEgs6OaJRrnV3cFfvIqPBz3ySDHziK6YRoWZ2N7WoGIDu0btpoo79OaljQIAvq8JrSSeOCXQgOK
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2020 09:13:00.5993
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: edb58788-8a05-4ae2-efba-08d79a6448ed
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB4406
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-16_02:2020-01-16,2020-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 phishscore=0 priorityscore=1501 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001160078
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ADIN1300 & ADIN1200 PHYs support detection of IEEE 1588 time stamp
packets. This mechanism can be used to signal the MAC via a pulse-signal
when the PHY detects such a packet.
This reduces the time when the MAC can check these packets and can improve
the accuracy of the PTP algorithm.

The PHYs support configurable delays for when the signaling happens to the
MAC. These delays would typically get adjusted using a userspace phytool to
identify the best value for the setup. That values can then be added in the
system configuration via device-tree or ACPI and read as an array of 3
elements.

For the RX delays, the units are in MII clock cycles, while for TX delays
the units are in 8 nano-second intervals.

The indication of either RX or TX must use one of 4 pins from the device:
LED_0, LINK_ST, GP_CLK and INT_N.

The driver will make sure that TX SOP & RX SOP will not use the same pin.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 201 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 201 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index 11ffeaa665a1..4247fe5d813a 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -69,6 +69,42 @@
 #define ADIN1300_CLOCK_STOP_REG			0x9400
 #define ADIN1300_LPI_WAKE_ERR_CNT_REG		0xa000
 
+#define ADIN1300_SOP_CTRL			0x9428
+#define   ADIN1300_SOP_N_8_CYCM_1		GENMASK(6, 4)
+#define   ADIN1300_SOP_NCYC_EN			BIT(3)
+#define   ADIN1300_SOP_SFD_EN			BIT(2)
+#define   ADIN1300_SOP_RX_EN			BIT(1)
+#define   ADIN1300_SOP_TX_EN			BIT(0)
+
+enum {
+	SOP_DELAY_10,
+	SOP_DELAY_100,
+	SOP_DELAY_1000,
+	__SOP_DELAY_MAX,
+};
+
+#define ADIN1300_SOP_RX_DELAY			0x9429
+#define   ADIN1300_SOP_RX_10_DEL_NCYC_MSK	GENMASK(15, 11)
+#define   ADIN1300_SOP_RX_10_DEL_NCYC_SEL(x)	\
+		FIELD_PREP(ADIN1300_SOP_RX_10_DEL_NCYC_MSK, x)
+#define   ADIN1300_SOP_RX_100_DEL_NCYC_MSK	GENMASK(10, 6)
+#define   ADIN1300_SOP_RX_100_DEL_NCYC_SEL(x)	\
+		FIELD_PREP(ADIN1300_SOP_RX_100_DEL_NCYC_MSK, x)
+#define   ADIN1300_SOP_RX_1000_DEL_NCYC_MSK	GENMASK(5, 0)
+#define   ADIN1300_SOP_RX_1000_DEL_NCYC_SEL(x)	\
+		FIELD_PREP(ADIN1300_SOP_RX_1000_DEL_NCYC_MSK, x)
+
+#define ADIN1300_SOP_TX_DELAY			0x942a
+#define   ADIN1300_SOP_TX_10_DEL_N_8_NS_MSK	GENMASK(12, 8)
+#define   ADIN1300_SOP_TX_10_DEL_N_8_NS_SEL(x)	\
+		FIELD_PREP(ADIN1300_SOP_TX_10_DEL_N_8_NS_MSK, x)
+#define   ADIN1300_SOP_TX_100_DEL_N_8_NS_MSK	GENMASK(7, 4)
+#define   ADIN1300_SOP_TX_100_DEL_N_8_NS_SEL(x)	\
+		FIELD_PREP(ADIN1300_SOP_TX_100_DEL_N_8_NS_MSK, x)
+#define   ADIN1300_SOP_TX_1000_DEL_N_8_NS_MSK	GENMASK(3, 0)
+#define   ADIN1300_SOP_TX_1000_DEL_N_8_NS_SEL(x)\
+		FIELD_PREP(ADIN1300_SOP_TX_1000_DEL_N_8_NS_MSK, x)
+
 #define ADIN1300_GE_SOFT_RESET_REG		0xff0c
 #define   ADIN1300_GE_SOFT_RESET		BIT(0)
 
@@ -104,6 +140,21 @@
 #define ADIN1300_RMII_20_BITS			0x0004
 #define ADIN1300_RMII_24_BITS			0x0005
 
+#define ADIN1300_GE_IO_GP_CLK_OR_CNTRL		0xff3d
+#define ADIN1300_GE_IO_GP_OUT_OR_CNTRL		0xff3e
+#define ADIN1300_GE_IO_INT_N_OR_CNTRL		0xff3f
+#define ADIN1300_GE_IO_LED_A_OR_CNTRL		0xff41
+
+/* Common definitions for ADIN1300_GE_IO_* regs */
+enum ge_io_fn {
+	GE_IO_FN_DFLT,
+	GE_IO_FN_LINK_STATUS,
+	GE_IO_FN_TX_SOP_IND,
+	GE_IO_FN_RX_SOP_IND,
+	GE_IO_FN_CRS,
+	GE_IO_FN_COL,
+};
+
 /**
  * struct adin_cfg_reg_map - map a config value to aregister value
  * @cfg		value in device configuration
@@ -172,6 +223,13 @@ static const struct adin_map adin_hw_stats[] = {
 	{ "false_carrier_events_count",		0x9414 },
 };
 
+static const struct adin_map adin_ge_io_pins[] = {
+	{ "gp_clk",	ADIN1300_GE_IO_GP_CLK_OR_CNTRL,	GENMASK(2, 0) },
+	{ "link_st",	ADIN1300_GE_IO_GP_OUT_OR_CNTRL,	GENMASK(2, 0) },
+	{ "int_n",	ADIN1300_GE_IO_INT_N_OR_CNTRL,	GENMASK(2, 0) },
+	{ "led_0",	ADIN1300_GE_IO_LED_A_OR_CNTRL,	GENMASK(3, 0) },
+};
+
 /**
  * struct adin_priv - ADIN PHY driver private data
  * stats		statistic counters for the PHY
@@ -381,6 +439,145 @@ static int adin_set_edpd(struct phy_device *phydev, u16 tx_interval)
 			  val);
 }
 
+static int adin_set_pin_function(struct phy_device *phydev,
+				 const char *prop_name,
+				 enum ge_io_fn ge_io_fn,
+				 int *selected_pin)
+{
+	struct device *dev = &phydev->mdio.dev;
+	const struct adin_map *p;
+	const char *pin_name;
+	int i, rc;
+
+	rc = device_property_read_string(dev, prop_name, &pin_name);
+	if (rc) {
+		phydev_err(phydev, "Could not get property '%s', error: %d\n",
+			   prop_name, rc);
+		return rc;
+	}
+
+	p = NULL;
+	for (i = 0; i < ARRAY_SIZE(adin_ge_io_pins); i++) {
+		if (strcmp(adin_ge_io_pins[i].string, pin_name) == 0) {
+			if (selected_pin)
+				*selected_pin = i;
+			p = &adin_ge_io_pins[i];
+			break;
+		}
+	}
+
+	if (!p) {
+		phydev_err(phydev, "Invalid pin name %s\n", pin_name);
+		return -EINVAL;
+	}
+
+	return phy_modify_mmd(phydev, MDIO_MMD_VEND1, p->val1, p->val2,
+			      ge_io_fn);
+}
+
+static int adin_config_1588_sop_rx(struct phy_device *phydev, int *rx_sop_pin)
+{
+	struct device *dev = &phydev->mdio.dev;
+	u8 values[__SOP_DELAY_MAX];
+	u16 val;
+	int rc;
+
+	rc = device_property_read_u8_array(dev,
+					   "adi,1588-rx-sop-delays-cycles",
+					   values, ARRAY_SIZE(values));
+	if (rc)
+		return 0;
+
+	rc = adin_set_pin_function(phydev, "adi,1588-rx-sop-pin-name",
+				   GE_IO_FN_RX_SOP_IND, rx_sop_pin);
+	if (rc)
+		return rc;
+
+	val = ADIN1300_SOP_RX_10_DEL_NCYC_SEL(values[SOP_DELAY_10]) |
+	      ADIN1300_SOP_RX_100_DEL_NCYC_SEL(values[SOP_DELAY_100]) |
+	      ADIN1300_SOP_RX_1000_DEL_NCYC_SEL(values[SOP_DELAY_1000]);
+
+	rc = phy_write_mmd(phydev, MDIO_MMD_VEND1, ADIN1300_SOP_RX_DELAY, val);
+	if (rc < 0) {
+		adin_set_pin_function(phydev, "adi,1588-rx-sop-pin-name",
+				      GE_IO_FN_DFLT, NULL);
+		return rc;
+	}
+
+	return 1;
+}
+
+static int adin_config_1588_sop_tx(struct phy_device *phydev, int rx_sop_pin)
+{
+	struct device *dev = &phydev->mdio.dev;
+	u8 values[__SOP_DELAY_MAX];
+	int tx_sop_pin = -1;
+	u16 val;
+	int i, rc;
+
+	rc = device_property_read_u8_array(dev,
+					   "adi,1588-tx-sop-delays-ns",
+					   values, ARRAY_SIZE(values));
+	if (rc)
+		return 0;
+
+	for (i = 0; i < __SOP_DELAY_MAX; i++) {
+		if (values[i] % 8 != 0) {
+			phydev_err(phydev,
+				   "SOP TX delays must be multiples of 8\n");
+			return -EINVAL;
+		}
+	}
+
+	val = ADIN1300_SOP_TX_10_DEL_N_8_NS_SEL(values[SOP_DELAY_10] / 8) |
+	      ADIN1300_SOP_TX_100_DEL_N_8_NS_SEL(values[SOP_DELAY_100] / 8) |
+	      ADIN1300_SOP_TX_1000_DEL_N_8_NS_SEL(values[SOP_DELAY_1000] / 8);
+
+	rc = adin_set_pin_function(phydev, "adi,1588-tx-sop-pin-name",
+				   GE_IO_FN_TX_SOP_IND, &tx_sop_pin);
+	if (rc)
+		return rc;
+
+	if (rx_sop_pin == tx_sop_pin) {
+		phydev_err(phydev,
+			   "TX SOP can't use the same pin as RX SOP\n");
+		return -EFAULT;
+	}
+
+	rc = phy_write_mmd(phydev, MDIO_MMD_VEND1, ADIN1300_SOP_TX_DELAY, val);
+	if (rc < 0) {
+		adin_set_pin_function(phydev, "adi,1588-tx-sop-pin-name",
+				      GE_IO_FN_DFLT, NULL);
+		return rc;
+	}
+
+	return 1;
+}
+
+static int adin_config_1588_sop(struct phy_device *phydev)
+{
+	int rx_sop_pin = -1;
+	u16 val = 0;
+	int rc;
+
+	rc = adin_config_1588_sop_rx(phydev, &rx_sop_pin);
+	if (rc < 0)
+		return rc;
+	if (rc == 1)
+		val |= ADIN1300_SOP_RX_EN;
+
+	rc = adin_config_1588_sop_tx(phydev, rx_sop_pin);
+	if (rc < 0)
+		return rc;
+	if (rc == 1)
+		val |= ADIN1300_SOP_TX_EN;
+
+	if (val)
+		val |= ADIN1300_SOP_SFD_EN;
+
+	return phy_write_mmd(phydev, MDIO_MMD_VEND1, ADIN1300_SOP_CTRL, val);
+}
+
 static int adin_get_tunable(struct phy_device *phydev,
 			    struct ethtool_tunable *tuna, void *data)
 {
@@ -429,6 +626,10 @@ static int adin_config_init(struct phy_device *phydev)
 	if (rc < 0)
 		return rc;
 
+	rc = adin_config_1588_sop(phydev);
+	if (rc < 0)
+		return rc;
+
 	phydev_dbg(phydev, "PHY is using mode '%s'\n",
 		   phy_modes(phydev->interface));
 
-- 
2.20.1

