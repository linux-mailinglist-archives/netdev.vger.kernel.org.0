Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6F8B0CE6
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 12:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731037AbfILK3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 06:29:10 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:2552 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730450AbfILK3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 06:29:10 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8CASlIH024068;
        Thu, 12 Sep 2019 06:28:56 -0400
Received: from nam03-dm3-obe.outbound.protection.outlook.com (mail-dm3nam03lp2057.outbound.protection.outlook.com [104.47.41.57])
        by mx0b-00128a01.pphosted.com with ESMTP id 2uv6a9r64v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 12 Sep 2019 06:28:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y2XWlC1g1TLRG8FkO4MqGYK8W8UBkh+RlaBsYbmN50rfY7wpr8q/vUta4UmEj1Mbz38tUcBsrxYxiK4DcyxfbcgmA7RhQSgXdhhBq4L1WSYuikXFRM+YsnW5kpyOvP0KyS6LVDICHe5wIuuj0MYqLIfBRQpOxyh+iN3d81lt1Nnebgv42QFGBizaMZLayFOD4WKKxkaZM1Ue48UYiMHVzvhXkDwoJdWZVwtfgvwLRZ6dyX70h0uQ1degUYfhvW8sz8CC/4kChqOyXt/rkYYTJSgIluZ0OeeRvbhHYxtMvnBTsE1ziobDNL1A5EQpo995/ZOpGjCCtuiRKJIHBWaL6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RQ0uzHRZGaUQlzUs+HXy+tvbdQgya2t3zqjsiawQh2E=;
 b=bxPpVBf1iq3kzAm8YhmUEIbpvSJqDSYxaBmlpi1i/cR9j/hePd7ZDGtAR4FocV2AooOWea5zAYrS4u2N0SXcmm0vkRdJQU9akzpDxwFBYP7TweqEFalfGpG5QrJD4dZ7ZQt7O3NHAz0es5NnvpiPfsqTKDaoKFJS8PMsfYSId/3Vz3tvbNTiGcfMRS101VGKkA/ygahMj5hN+Yg07oGZGSH3JxFhlr4JDJhKa1Cws4YZdd+tDCSFEwCJQGQQF4yxBdJqixFASoQ4bFkk5WtDx1S3Q+TJzUDbHzQccqiZ51OnjDZpdc1wP3omzQ5AA7HUptNltPer4HJf36jbIk2WZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RQ0uzHRZGaUQlzUs+HXy+tvbdQgya2t3zqjsiawQh2E=;
 b=qxKgbsPJzfrxOONGgtzTuotRJpWoYrlVUe08lyW/vRJ0RaGSmOD01UQVKVdRjrQ6fUR79V2852WxWOye7j8E2zNPA5/rg0Yzrd1OapNNf4eDixDF314A0313vZzmy130X4ZzrPUNHfeScaADDJUzwqkDhFcekAxjmnbv1MTFrok=
Received: from BN8PR03CA0034.namprd03.prod.outlook.com (2603:10b6:408:94::47)
 by BN3PR03MB2227.namprd03.prod.outlook.com (2a01:111:e400:7bba::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2263.17; Thu, 12 Sep
 2019 10:28:55 +0000
Received: from CY1NAM02FT004.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::201) by BN8PR03CA0034.outlook.office365.com
 (2603:10b6:408:94::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2199.21 via Frontend
 Transport; Thu, 12 Sep 2019 10:28:55 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT004.mail.protection.outlook.com (10.152.74.112) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2241.14
 via Frontend Transport; Thu, 12 Sep 2019 10:28:54 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x8CASndV012000
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Thu, 12 Sep 2019 03:28:49 -0700
Received: from saturn.ad.analog.com (10.48.65.123) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Thu, 12 Sep 2019 06:28:53 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>,
        <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>,
        <davem@davemloft.net>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v2] net: stmmac: socfpga: re-use the `interface` parameter from platform data
Date:   Thu, 12 Sep 2019 16:28:50 +0300
Message-ID: <20190912132850.10585-1-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(346002)(376002)(39860400002)(396003)(136003)(189003)(199004)(54534003)(336012)(305945005)(44832011)(36756003)(476003)(478600001)(5660300002)(486006)(70206006)(8936002)(26005)(70586007)(50466002)(7636002)(426003)(107886003)(186003)(48376002)(86362001)(2616005)(8676002)(126002)(2201001)(246002)(2870700001)(316002)(4326008)(51416003)(50226002)(7696005)(1076003)(47776003)(54906003)(110136005)(106002)(2906002)(356004)(81973001)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN3PR03MB2227;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d139b25e-fb44-4f23-be7a-08d7376c035c
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(4709080)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328);SRVR:BN3PR03MB2227;
X-MS-TrafficTypeDiagnostic: BN3PR03MB2227:
X-Microsoft-Antispam-PRVS: <BN3PR03MB2227AD1C979C15CD48365E62F9B00@BN3PR03MB2227.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 01583E185C
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: dR5zoj/n96O+PARMvuXpRTEyu9AunmOyaCMJx9fmpm14Ywqk+4gqUQzrtOaR6bjiD40IXlBkZS3Nka/ZUoRSbqD45v7A0iUtYf5exOYk1f7KgX3j1Y/6E3B+CBDvKyrI8vDFY1dGaQ43k6b2UpxeIc973eqM3UbmjHV9ATOKJBf7IolloE73mfOkba1PryNvIZSpR+y5Q68QXj8Iat94UHuU+iO68m5TJ2uRdS7eWevAg7I6b2I2BwJhh7cEYdh6SX/EkX9TOGcUT/PWR3BxsH2bloH18GRx1ei1e43qxzlr1MyfYSBhbt8ixNyFa4b8fYsoOD2Hrj66AGSBo5dCjkBvFW9ngHkShtxJJdduLv+FSiiAxSW8eOJrx/bCbPr6lY04+qmTL3X3tGrNerobuM8ov2QOcntmuDBzxp5/F7U=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2019 10:28:54.7368
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d139b25e-fb44-4f23-be7a-08d7376c035c
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR03MB2227
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-12_05:2019-09-11,2019-09-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 mlxscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0 phishscore=0
 suspectscore=0 priorityscore=1501 impostorscore=0 mlxlogscore=889
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909120111
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The socfpga sub-driver defines an `interface` field in the `socfpga_dwmac`
struct and parses it on init.

The shared `stmmac_probe_config_dt()` function also parses this from the
device-tree and makes it available on the returned `plat_data` (which is
the same data available via `netdev_priv()`).

All that's needed now is to dig that information out, via some
`dev_get_drvdata()` && `netdev_priv()` calls and re-use it.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---

Changelog v1 -> v2:
* initially, this patch was developed on a 4.14 kernel, and adapted (badly)
  to `net-next`, so it did not build ; the v2 has been fixed and adapted
  correctly

 .../net/ethernet/stmicro/stmmac/dwmac-socfpga.c   | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
index c141fe783e87..5b6213207c43 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
@@ -46,7 +46,6 @@ struct socfpga_dwmac_ops {
 };
 
 struct socfpga_dwmac {
-	int	interface;
 	u32	reg_offset;
 	u32	reg_shift;
 	struct	device *dev;
@@ -110,8 +109,6 @@ static int socfpga_dwmac_parse_data(struct socfpga_dwmac *dwmac, struct device *
 	struct resource res_tse_pcs;
 	struct resource res_sgmii_adapter;
 
-	dwmac->interface = of_get_phy_mode(np);
-
 	sys_mgr_base_addr =
 		altr_sysmgr_regmap_lookup_by_phandle(np, "altr,sysmgr-syscon");
 	if (IS_ERR(sys_mgr_base_addr)) {
@@ -231,6 +228,14 @@ static int socfpga_dwmac_parse_data(struct socfpga_dwmac *dwmac, struct device *
 	return ret;
 }
 
+static inline int socfpga_get_plat_phymode(struct socfpga_dwmac *dwmac)
+{
+	struct net_device *ndev = dev_get_drvdata(dwmac->dev);
+	struct stmmac_priv *priv = netdev_priv(ndev);
+
+	return priv->plat->interface;
+}
+
 static int socfpga_set_phy_mode_common(int phymode, u32 *val)
 {
 	switch (phymode) {
@@ -255,7 +260,7 @@ static int socfpga_set_phy_mode_common(int phymode, u32 *val)
 static int socfpga_gen5_set_phy_mode(struct socfpga_dwmac *dwmac)
 {
 	struct regmap *sys_mgr_base_addr = dwmac->sys_mgr_base_addr;
-	int phymode = dwmac->interface;
+	int phymode = socfpga_get_plat_phymode(dwmac);
 	u32 reg_offset = dwmac->reg_offset;
 	u32 reg_shift = dwmac->reg_shift;
 	u32 ctrl, val, module;
@@ -314,7 +319,7 @@ static int socfpga_gen5_set_phy_mode(struct socfpga_dwmac *dwmac)
 static int socfpga_gen10_set_phy_mode(struct socfpga_dwmac *dwmac)
 {
 	struct regmap *sys_mgr_base_addr = dwmac->sys_mgr_base_addr;
-	int phymode = dwmac->interface;
+	int phymode = socfpga_get_plat_phymode(dwmac);
 	u32 reg_offset = dwmac->reg_offset;
 	u32 reg_shift = dwmac->reg_shift;
 	u32 ctrl, val, module;
-- 
2.20.1

