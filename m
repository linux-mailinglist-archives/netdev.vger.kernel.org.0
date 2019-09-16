Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 665A8B3515
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 09:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730272AbfIPHEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 03:04:42 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:53088 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726168AbfIPHEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 03:04:41 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8G73lxw003578;
        Mon, 16 Sep 2019 03:04:27 -0400
Received: from nam03-co1-obe.outbound.protection.outlook.com (mail-co1nam03lp2056.outbound.protection.outlook.com [104.47.40.56])
        by mx0a-00128a01.pphosted.com with ESMTP id 2v0t2936r2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Sep 2019 03:04:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hoqozMvNC/iR2lWQCuoY1tBx3heQDH5o91GWsbgBiDAHybfzjBm1oTgv4ztYS6fgrvQ6FZhCDF3lHthkSCCX5NXPNkPJXytKiM4VS05IEy+NbOK9Hs/8A92wRd9L+CBfUqnyCAmq/gs9Ls85v9HamJfq0A0I8EqlaT7cqv4XAJasiYHf86yU5iKulbJzXI7314n1UglaCz8YSpPzbgdbvkBue3H1t/a2u3tIuRROTcKIvZArWnt6Cxleri9gmuDKFQXhYakZkH9g7cvanQM6yZDgIzIRZqEForV+raP4dsst9OKwfgwJ6QDiIzlkkYMkxS+o2s2bmpW7Rq9+YfEaQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4GgBQSK3f6XqEjVjQ77pw1L1L4kdT+TopqaJw1r8yKc=;
 b=cbxHva/UWANKlzEXLM/dIm4nXBIk6PS8uueM41bYRwJthPlj2vbrR7ip41H0YfiPyq8AhPYI+7O2oS1n+B/yIfpBnxhGOFcIoSyU3eGPoh0BGYSsNlgBCvVfxR/5Hm14quigLGMhKBy7gTTVOxAcdNCYyovBwo2CB52gwaQsb6rNu6DxSCaQmPr+n+4HYM6jI426o9e8YIX+f1T++9+7T0DVlOKWB9r6K23dnS+gBfjkR2czJpvQgL9hEohEHvDEQ/qC2e+aNMYtWqXkUWNGq5wxJlfokvejIVHlVtVTpBy4+r87yrDeHE2FC3Q5TyBaiDtMbmTKm5GYevSQWORzQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4GgBQSK3f6XqEjVjQ77pw1L1L4kdT+TopqaJw1r8yKc=;
 b=giox+sxG1eUJoOWMI/Ny+3vUflvY8NfQJvmtfYhz8qv1Q0W3Fg68ugPBRNSRdP+e0bOWkty2ij8FalteB/0mT6KIyLb0x2IZgGmIAdZ1+IWgFhnUApb7plWBWb4uIT9lWpq2V8XMrn7DFikL69YvIPH35k+v+nY3wB9yn2Khvog=
Received: from MWHPR03CA0053.namprd03.prod.outlook.com (2603:10b6:301:3b::42)
 by CY4PR03MB2632.namprd03.prod.outlook.com (2603:10b6:903:68::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2263.21; Mon, 16 Sep
 2019 07:04:25 +0000
Received: from BL2NAM02FT018.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::203) by MWHPR03CA0053.outlook.office365.com
 (2603:10b6:301:3b::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2263.21 via Frontend
 Transport; Mon, 16 Sep 2019 07:04:25 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 BL2NAM02FT018.mail.protection.outlook.com (10.152.77.170) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2263.17
 via Frontend Transport; Mon, 16 Sep 2019 07:04:24 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x8G74I7F014794
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 16 Sep 2019 00:04:18 -0700
Received: from saturn.ad.analog.com (10.48.65.123) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Mon, 16 Sep 2019 03:04:23 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>,
        <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>,
        <davem@davemloft.net>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v3] net: stmmac: socfpga: re-use the `interface` parameter from platform data
Date:   Mon, 16 Sep 2019 10:04:00 +0300
Message-ID: <20190916070400.18721-1-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(39850400004)(346002)(376002)(396003)(189003)(199004)(54534003)(486006)(1076003)(2201001)(356004)(6666004)(48376002)(8676002)(110136005)(5660300002)(36756003)(86362001)(54906003)(426003)(186003)(8936002)(50226002)(44832011)(336012)(7636002)(476003)(2616005)(50466002)(106002)(2906002)(107886003)(4326008)(126002)(316002)(246002)(47776003)(51416003)(26005)(305945005)(7696005)(70586007)(70206006)(478600001)(2870700001)(81973001)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR03MB2632;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d489142-4141-4357-6f4f-08d73a741b80
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(4709080)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328);SRVR:CY4PR03MB2632;
X-MS-TrafficTypeDiagnostic: CY4PR03MB2632:
X-Microsoft-Antispam-PRVS: <CY4PR03MB2632006DD2FDC2D7E6912B23F98C0@CY4PR03MB2632.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0162ACCC24
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: ZcHveBaJ732e+7bdSgEvOpYlVnt5A0lHnt0zjaMOVCJa8gMhiSkrZiZiwEXh1U+R7kTEh78XzOeO/K60maTodRfc8d+xlb3Phjw5lO7UlKYm8D967Gdcg4xtc965nFGrxeov8sgeJwdqtdSeDrClRsxd4eTbZxphHUuPcappgr8GVA2hkm0dcl5FBwWqLZUlVQL+u9QYd1Nd4cm7mTpQfPO/+zBm4vFlUxMqsEEF6kO4qUliWPYNfJgtKuiKGVfBCUTK8uAgQTrhUCBLwxRswuWFop6D5eKM62rgXRHks/qjZm2qpuTr8g5WjltO3MAW1GoJsiA6rp6hqa4lxLciSbE7WtpuM0exZSopJXXQCX4T3HHFdpDiPlyP9G9RBBMIYK+nH+3U/8dCIM62vCz6EVamBM973I883NaXeNMlKDI=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2019 07:04:24.7743
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d489142-4141-4357-6f4f-08d73a741b80
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR03MB2632
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-16_04:2019-09-11,2019-09-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=832
 priorityscore=1501 clxscore=1015 malwarescore=0 suspectscore=0
 phishscore=0 lowpriorityscore=0 mlxscore=0 adultscore=0 bulkscore=0
 spamscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1909160076
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
Changelog v2 -> v3:
* drop `inline` keyword

Changelog v1 -> v2:
* initially, this patch was developed on a 4.14 kernel, and adapted (badly)
  to `net-next`, so it did not build ; the v2 has been fixed and adapted
  correctly

 .../net/ethernet/stmicro/stmmac/dwmac-socfpga.c   | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
index c141fe783e87..e0212d2fc2a1 100644
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
 
+static int socfpga_get_plat_phymode(struct socfpga_dwmac *dwmac)
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

