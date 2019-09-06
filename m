Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40423AB82B
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 14:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404257AbfIFMbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 08:31:23 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:49680 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731811AbfIFMbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 08:31:23 -0400
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x86CSPrZ017800;
        Fri, 6 Sep 2019 08:31:05 -0400
Received: from nam04-bn3-obe.outbound.protection.outlook.com (mail-bn3nam04lp2055.outbound.protection.outlook.com [104.47.46.55])
        by mx0a-00128a01.pphosted.com with ESMTP id 2uqnt8m7jj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Sep 2019 08:31:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FdyAQGtrhhssV1DKdOYYCBS4qV8qxm2VoQ4QST5aIpgISXKz6h6DigU+vCD4s4pyOkLhj9Tj1PQCnkjKDYlc70IUjSsGkbdGNYiugm+Gc51OwNFzQjAEIcgW8iVE0vSJQ4tQI7v7xUgzYLwzYn2wDVRhwLGm8Puf1VAgeJacDz9zigGQ14Ccg1ZFK8j7YOISHM/Ec5v2URfPYuBkMfkl76ZJU6T3/u2JFRixoFrMLYUx4rbNRdU0KtiIV+lBzdufII13BQVEHM815ZWfjpQ+03kJvG7K1tBJrhpx8zWNJSPOj9JLBZHeV6wpWbn1hl42IJa6ZFCQsLtJfI8Fqk+Lmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cmYmdUDYrg+4d3nvWf1pvVITUqE3ubU8lBQlktAxug4=;
 b=G6D4vxgiCBSGYxrg6SKe97cjRF/DY0QL64S3E5Zd5JNtB+DjG8zm/ozGvko3BZ1szG/mzWj6FMW1yFIed/0OjSUJIK2uVk3mOyR8LQMNKXPbnnIUMBl0F2bWrL1hLn3h/48QV6ZEvYPn5oZzEsY/afo5aob62uB1TjLKaux1ic5yXl9gr8tEl+ZFrCkwi35YuTMQ2dDVk6b5rIwpsOa7ISZZQrcylzIVqNUN0uYvhO9tDokpIEpOH33C/5Wc0rOrcGRiMatxmwfBMaSIzC3ngvlf2BYYuX8qG9uS7WC9sm+YSEkx5giinzQFWfIzrUz5NrwiVDI2q5tvdLMvcWVzcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cmYmdUDYrg+4d3nvWf1pvVITUqE3ubU8lBQlktAxug4=;
 b=Xi6RVJdypotiX1F5DLeS2othyrq01Ckk3z14e390MRCt7Z380kXC3UBMErwEyoaH5bHoUBXjIotPiXlhDfF0vOY2+P7t8z+zowa0ktdijwxV0miuSb3B/6QiApDpvAZHL+f6pYov7Kz18Js9a9UCaAPcY5+dJKHeb3map5RfYBs=
Received: from BN6PR03CA0098.namprd03.prod.outlook.com (2603:10b6:404:10::12)
 by DM6PR03MB4700.namprd03.prod.outlook.com (2603:10b6:5:180::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2241.15; Fri, 6 Sep
 2019 12:31:03 +0000
Received: from BL2NAM02FT041.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::203) by BN6PR03CA0098.outlook.office365.com
 (2603:10b6:404:10::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2241.14 via Frontend
 Transport; Fri, 6 Sep 2019 12:31:03 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 BL2NAM02FT041.mail.protection.outlook.com (10.152.77.122) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2241.14
 via Frontend Transport; Fri, 6 Sep 2019 12:31:03 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x86CV2Sm023246
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 6 Sep 2019 05:31:02 -0700
Received: from saturn.ad.analog.com (10.48.65.123) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Fri, 6 Sep 2019 08:31:02 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>,
        <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>,
        <davem@davemloft.net>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH] net: stmmac: socfpga: re-use the `interface` parameter from platform data
Date:   Fri, 6 Sep 2019 15:30:54 +0300
Message-ID: <20190906123054.5514-1-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(39860400002)(396003)(376002)(346002)(2980300002)(189003)(199004)(5660300002)(8936002)(8676002)(47776003)(26005)(4326008)(478600001)(50226002)(7636002)(246002)(70586007)(107886003)(36756003)(70206006)(305945005)(486006)(44832011)(476003)(336012)(2906002)(2616005)(6666004)(356004)(1076003)(426003)(86362001)(50466002)(48376002)(7696005)(51416003)(2870700001)(106002)(316002)(110136005)(126002)(54906003)(186003)(2201001)(81973001)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR03MB4700;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 81df5308-7871-41e9-042e-08d732c614f2
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(4709080)(1401327)(4618075)(2017052603328);SRVR:DM6PR03MB4700;
X-MS-TrafficTypeDiagnostic: DM6PR03MB4700:
X-Microsoft-Antispam-PRVS: <DM6PR03MB4700F9344C52C32DB291E865F9BA0@DM6PR03MB4700.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 0152EBA40F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 4elzOFMw439Z/orIXPc1TbHcVg83DafU9jWaxyxYE2XB4XcGCkWoLaU7oJB4pVncO/m1kNmnxQKQOQPg9x4uP4wbFUeTUmkfIaYPnKkDPkdmaEhCsnPNz88xNWXt2QI2Bsbv+IM+QNLJy9n+PRpPG4Ph6Mx3uYZBT64jAqNo+2t7bwu/EHSh4qmrQVr8lZaeL+ve+v6GkK1nQpihhJSuNHB3sV+inGAR09dhw1odrT0MfAP1SLZ/7ohlRNUegTDloojcmw0z+DH5A08axy3EGUPQlR+NZuxN4EGxbHsJzktmvnKTCbhwNjkvhaWpz+HEHOIhLJCUAjChaU1ODhy1v4SQKFYlOJwQUGpnUrnXLD3EyB6tDZ72JJ8lFL/HIAiuAdms7iPbZXHkgfZaNaj+8Ub3vr+5HTXHTeVfKCgoHrM=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2019 12:31:03.1512
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 81df5308-7871-41e9-042e-08d732c614f2
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR03MB4700
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-06_06:2019-09-04,2019-09-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1011
 suspectscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1906280000
 definitions=main-1909060131
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
 .../net/ethernet/stmicro/stmmac/dwmac-socfpga.c   | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
index c141fe783e87..3094bb1f77e5 100644
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
@@ -231,8 +228,12 @@ static int socfpga_dwmac_parse_data(struct socfpga_dwmac *dwmac, struct device *
 	return ret;
 }
 
-static int socfpga_set_phy_mode_common(int phymode, u32 *val)
+static int socfpga_set_phy_mode_common(struct socfpga_dwmac *dwmac, u32 *val)
 {
+	struct net_device *ndev = dev_get_drvdata(dwmac->dev);
+	struct stmmac_priv *priv = netdev_priv(ndev);
+	int phymode = priv->plat->interface;
+
 	switch (phymode) {
 	case PHY_INTERFACE_MODE_RGMII:
 	case PHY_INTERFACE_MODE_RGMII_ID:
@@ -255,12 +256,11 @@ static int socfpga_set_phy_mode_common(int phymode, u32 *val)
 static int socfpga_gen5_set_phy_mode(struct socfpga_dwmac *dwmac)
 {
 	struct regmap *sys_mgr_base_addr = dwmac->sys_mgr_base_addr;
-	int phymode = dwmac->interface;
 	u32 reg_offset = dwmac->reg_offset;
 	u32 reg_shift = dwmac->reg_shift;
 	u32 ctrl, val, module;
 
-	if (socfpga_set_phy_mode_common(phymode, &val)) {
+	if (socfpga_set_phy_mode_common(dwmac, &val)) {
 		dev_err(dwmac->dev, "bad phy mode %d\n", phymode);
 		return -EINVAL;
 	}
@@ -314,12 +314,11 @@ static int socfpga_gen5_set_phy_mode(struct socfpga_dwmac *dwmac)
 static int socfpga_gen10_set_phy_mode(struct socfpga_dwmac *dwmac)
 {
 	struct regmap *sys_mgr_base_addr = dwmac->sys_mgr_base_addr;
-	int phymode = dwmac->interface;
 	u32 reg_offset = dwmac->reg_offset;
 	u32 reg_shift = dwmac->reg_shift;
 	u32 ctrl, val, module;
 
-	if (socfpga_set_phy_mode_common(phymode, &val))
+	if (socfpga_set_phy_mode_common(dwmac, &val))
 		return -EINVAL;
 
 	/* Overwrite val to GMII if splitter core is enabled. The phymode here
-- 
2.20.1

