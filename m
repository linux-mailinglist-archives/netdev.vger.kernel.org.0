Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBBA781E34
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 15:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730370AbfHEN4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 09:56:19 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:17960 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729778AbfHENzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 09:55:41 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x75DqjgS015547;
        Mon, 5 Aug 2019 09:55:34 -0400
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2051.outbound.protection.outlook.com [104.47.36.51])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u6kb20e1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Aug 2019 09:55:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jaYpNzC7IKcEVJYDlxBM0Frm7tgdC8WP3QesAwT+mHiWRhXKM571dpu5Pus6WBk6x0Arvo7UjFEDbbP6lH9wl7NEcabvg1Qi8k5/Dsm7TcwHnxkSCTUFd9R66zFDPzS+kuhvJop7MxMSRWeou1lyc/lTGEqnPC5bJr9vdDP0rbr3qoNH2u5OLA5DMWsp02hdYzVL/tuh2Fo+9WJK4QXoEbiFRylk0XRVvbqgQJ0qrtQbIfRA7Qfipw4dRusNsVOH8EFizzLPBr8cCyDGWrgyXLRUg+6B91Bb0nyt7uG61FYkZwPopY9wxMDfrdYdO3b3rCXkO/k34iM5sDPXqT9scQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LfKvG3wp05mBR+Fcq6uHKd/mDqDzhkr2Zi/L5TYzUh4=;
 b=hWUvkfcc6sUS8IxR4RyhzvbIGdmsMHPd74WukJW0S90DYek/YJQvSjXZMGIG0fWh7DsQGaTBuG3uFo2WqLglEo/J8yf3L+/qEF570OpmH8SU5IbsF5bhjp2roqvqyudM7nJ2HCSwLI6YmuQ+oXCJoVCTgMU1qnvJCdaj17YXC13uT56KfO5hVidCgcyBKPIeUDmtaXDvNDrK6wU4vNpeIYLRmocKlV7NwGosEbJ4zUu2BqOxezGFDLp5RUpnTcAUZxq4uuOchzTvUjh9cfaH9IEuD5QlPOQ2LAdqtWgNGbulDT2qk+nIoL/veJkmK1hvawdQUvs6hV4kwlZAllxTtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=analog.com;dmarc=bestguesspass action=none
 header.from=analog.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LfKvG3wp05mBR+Fcq6uHKd/mDqDzhkr2Zi/L5TYzUh4=;
 b=Rq867kmCLCE5NJvj8pKmbOFFi2wRw4lBLP9RZHW+1ZPCSIq9O5Jk1YYK9k9C+TQnAo245dTu9r/S7cu3coHuN42bMMfrHvfDV+8q2ds+jWfbXY52Zj/Pw7PB+DYj/GrFuc6gUMIYFkfV2oQAKgEaKKBbjKZXzmnWv17ZfBrMzIo=
Received: from MWHPR03CA0033.namprd03.prod.outlook.com (2603:10b6:301:3b::22)
 by BYAPR03MB4613.namprd03.prod.outlook.com (2603:10b6:a03:12d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.17; Mon, 5 Aug
 2019 13:55:31 +0000
Received: from BL2NAM02FT058.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::205) by MWHPR03CA0033.outlook.office365.com
 (2603:10b6:301:3b::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2136.16 via Frontend
 Transport; Mon, 5 Aug 2019 13:55:31 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 BL2NAM02FT058.mail.protection.outlook.com (10.152.76.176) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2136.14
 via Frontend Transport; Mon, 5 Aug 2019 13:55:31 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x75DtSB3016238
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 5 Aug 2019 06:55:28 -0700
Received: from saturn.ad.analog.com (10.48.65.109) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Mon, 5 Aug 2019 09:55:30 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 12/16] net: phy: adin: read EEE setting from device-tree
Date:   Mon, 5 Aug 2019 19:54:49 +0300
Message-ID: <20190805165453.3989-13-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190805165453.3989-1-alexandru.ardelean@analog.com>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(39860400002)(346002)(376002)(136003)(396003)(2980300002)(189003)(199004)(26005)(186003)(8676002)(7636002)(48376002)(4326008)(50466002)(305945005)(107886003)(5660300002)(1076003)(478600001)(70586007)(70206006)(47776003)(8936002)(2870700001)(246002)(7696005)(51416003)(50226002)(356004)(316002)(6666004)(106002)(76176011)(110136005)(2906002)(54906003)(336012)(36756003)(426003)(14444005)(476003)(86362001)(44832011)(2616005)(446003)(11346002)(126002)(2201001)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR03MB4613;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d6bdf0ba-bf59-4094-cf8d-08d719ac9481
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(4709080)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328);SRVR:BYAPR03MB4613;
X-MS-TrafficTypeDiagnostic: BYAPR03MB4613:
X-Microsoft-Antispam-PRVS: <BYAPR03MB4613FC781B4C75C25B6BA051F9DA0@BYAPR03MB4613.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 01208B1E18
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: YmMCz17anzZV6/6j+LzIlmWfbiX1gtIgjkcCVqw67on0G3seqhv8g8Yd04aybGmT5SMEdte204qhtocO9Zv8I7+Hs6yWBz8GSzEjmPYq4l86f+9KvR0DxMo2T+caBJOXrOsgH7pDd0LOsIn1jVkNQaUH0z84kNbsDNVceeuvH6GcD4ZcL28lfqxt7362FWyw0KENrPIUIA9uR0thw6F4nnIhU3fxgPekdQYgyrmsX6Elf8bOO4sdS07haxk5o8qyOHDcWSW8SsTDD0C9YFdPPOGRddylfi7Mv4ZQo5Lr2ABnvtDOzlQRXBVS3txBTCCOT1PYsmtiEbG9p1Uq0pVtLwgVVwcQ35QiCnE6mUr5opYTm2bXxN/c/0ee1STkdXrLEYFEOR0KaVwriesu4EXWooF5v/m1Dn/iY/eRhoELoug=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2019 13:55:31.1848
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d6bdf0ba-bf59-4094-cf8d-08d719ac9481
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB4613
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-05_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=961 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908050154
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By default, EEE is not advertised on system init. This change allows the
user to specify a device property to enable EEE advertisements when the PHY
initializes.

Also, before resetting the PHY, the EEE settings are read, so that after
the reset is complete, they are written back into the EEE advertisement
register.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index 476a81ce9341..cf99ccacfeeb 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -94,9 +94,11 @@ static struct clause22_mmd_map clause22_mmd_map[] = {
 /**
  * struct adin_priv - ADIN PHY driver private data
  * gpiod_reset		optional reset GPIO, to be used in soft_reset() cb
+ * eee_modes		EEE modes to advertise after reset
  */
 struct adin_priv {
 	struct gpio_desc	*gpiod_reset;
+	u8			eee_modes;
 };
 
 static int adin_get_phy_internal_mode(struct phy_device *phydev)
@@ -216,6 +218,23 @@ static int adin_config_rmii_mode(struct phy_device *phydev,
 			     ADIN1300_GE_RMII_CFG_REG, reg);
 }
 
+static int adin_config_init_eee(struct phy_device *phydev)
+{
+	struct adin_priv *priv = phydev->priv;
+	int reg;
+
+	reg = phy_read_mmd(phydev, MDIO_MMD_VEND1, ADIN1300_EEE_ADV_REG);
+	if (reg < 0)
+		return reg;
+
+	if (priv->eee_modes)
+		reg |= priv->eee_modes;
+	else
+		reg &= ~(MDIO_EEE_100TX | MDIO_EEE_1000T);
+
+	return phy_write_mmd(phydev, MDIO_MMD_VEND1, ADIN1300_EEE_ADV_REG, reg);
+}
+
 static int adin_config_init(struct phy_device *phydev)
 {
 	phy_interface_t interface, rc;
@@ -238,6 +257,10 @@ static int adin_config_init(struct phy_device *phydev)
 	if (rc < 0)
 		return rc;
 
+	rc = adin_config_init_eee(phydev);
+	if (rc < 0)
+		return rc;
+
 	if (phydev->interface == interface)
 		dev_info(&phydev->mdio.dev, "PHY is using mode '%s'\n",
 			 phy_modes(phydev->interface));
@@ -473,6 +496,12 @@ static int adin_reset(struct phy_device *phydev)
 	struct adin_priv *priv = phydev->priv;
 	int ret;
 
+	/* Update EEE settings before resetting, in case ethtool changed them */
+	ret = phy_read_mmd(phydev, MDIO_MMD_VEND1, ADIN1300_EEE_ADV_REG);
+	if (ret < 0)
+		return ret;
+	priv->eee_modes = (ret & (MDIO_EEE_100TX | MDIO_EEE_1000T));
+
 	if (priv->gpiod_reset) {
 		/* GPIO reset requires min 10 uS low,
 		 * 5 msecs max before we know that the interface is up again
@@ -504,6 +533,8 @@ static int adin_probe(struct phy_device *phydev)
 		gpiod_reset = NULL;
 
 	priv->gpiod_reset = gpiod_reset;
+	if (device_property_read_bool(dev, "adi,eee-enabled"))
+		priv->eee_modes = (MDIO_EEE_100TX | MDIO_EEE_1000T);
 	phydev->priv = priv;
 
 	return adin_reset(phydev);
-- 
2.20.1

