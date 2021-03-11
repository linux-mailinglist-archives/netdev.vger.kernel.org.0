Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB44C337EC9
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 21:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhCKUMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 15:12:03 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:52598 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229900AbhCKULx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 15:11:53 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12BK2cx5031497;
        Thu, 11 Mar 2021 15:11:49 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2055.outbound.protection.outlook.com [104.47.60.55])
        by mx0c-0054df01.pphosted.com with ESMTP id 375yymh7q7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Mar 2021 15:11:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A+bvSirp9S7Z2ybXUD0SPkmNE4asybQyf8bOXzfS7umX4BngIUNaJSisQiADG8SZHk43D5QAMt/Rl/962mncAlmM04UdEmZdaPM6mcA28Y5DALf4hcIzy0ZQs9YUGxOUke4uFYRCC+1OS1qkjy2czhnHDsa5K4ktej3KokvsObBXiA01hyY+Ux5ZJiJcOP/iOyHyNMKVQ2PX+BQgDfzoSUdluy3YlO7xpICN2D2l8xDfmOFWUWe7NIZdgojEV1BAbTlFUGCc8fS9zZTow+6yyI+AubVw0XRzvF1I5fKW+tQ8+uccukNBRBAMmBlGq6OjN294n73l5CIJsFIgzQAkWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7sp59zhl9kfnNJ2vSMXhsu/h1n7PmBzhLNrHkoxPJ3w=;
 b=XRciqBNMHJnkim5kuPujxzQlTeDO8ERTp3UhBlmulSWbUpUy+p78qkMXzHvI7bd3k+QcMCNrod0jN46hjjws4N2uxhWfNmLpiqwswOPxw20xihqf2/B0rGqmaYrDcqXQY1cFWj6P8EO2tv7fXCB7BnDqFdtAW3iYuNGjZWx0cPfxjvamQkoCarPGpQ3lq/1gFpTcpoTNsfLVQCmIVN+D+7GaN33NMZxhaP2sbQW7sR0ev94LaLN7KdMu/yv0RxDFiY75gV7VhhipDnDEZN1yThIEO3lHh0T4Gn7w5mQaPXdy7a7YLv4miCtEnBNIKHXwM/mHz7kuMQq6+VoEJptNwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7sp59zhl9kfnNJ2vSMXhsu/h1n7PmBzhLNrHkoxPJ3w=;
 b=w9t2slZlBnFfcorVwRB171hrFBxPCDll/IgdyXNDFo6bYkIzFh32rRh9UTNQdEpjPigr9VVlqjM8qIHUsOiWpp1I+cCw1dMoFqlQTW7CBSysJJYWqspsY5voDQ1zKjASw5QwuDnYIG2PYDts2j8wGbGU4KyvEfYkBS/tCftulF8=
Authentication-Results: xilinx.com; dkim=none (message not signed)
 header.d=none;xilinx.com; dmarc=none action=none header.from=calian.com;
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YTBPR01MB3983.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:1d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.26; Thu, 11 Mar
 2021 20:11:47 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::90d4:4d5b:b4c2:fdeb]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::90d4:4d5b:b4c2:fdeb%7]) with mapi id 15.20.3912.027; Thu, 11 Mar 2021
 20:11:47 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next 2/2] net: axienet: Enable more clocks
Date:   Thu, 11 Mar 2021 14:11:17 -0600
Message-Id: <20210311201117.3802311-3-robert.hancock@calian.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210311201117.3802311-1-robert.hancock@calian.com>
References: <20210311201117.3802311-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: CO2PR04CA0101.namprd04.prod.outlook.com
 (2603:10b6:104:6::27) To YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:f::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by CO2PR04CA0101.namprd04.prod.outlook.com (2603:10b6:104:6::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Thu, 11 Mar 2021 20:11:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 059b7fe0-65a0-467e-450a-08d8e4c9e620
X-MS-TrafficTypeDiagnostic: YTBPR01MB3983:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YTBPR01MB3983A512D84C46B42C3D601BEC909@YTBPR01MB3983.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3HobgBrk0S3uTpM4TOM5CW/Bc52tZHFarHRiGpLyT/4l/t8RTJZDjb3extIu6Q/AWBZi8LgRC7q8zEey/h9pnnhqhNS2Yk3jjj+i/NfsJfYJiBhnMw42q2wzcKgRCRYdKoS5ny49WxgpQ8qcRh86Fxc6i5Y5ZbcRO8a2OrLPDnZ12F/pGT1uxLXERiTDIaUJhQ3jbJt5sJaKffwSyXcEetBYM76fgJtwYqq2QTZG4jPzConrDX2wGO0lywL7vWepMwRfNEnb2yskqmFBVif1KHaUYNJb5gjYj1SJOuUBtm/M1k0IfnIrqBx9+/8RojyTjqjIoiyN5V03YWzgkGxDmpL0jJ7u+KxWXV7JHcm5wo5hJUiRIxH9F5cDQctHyAo9LXEZErRbKRxvPID7baKAk5ApP0+6bL/zQbjN9PL5kv/eHpnbIfGPs+9Z4MfVYvBQkOxMcguCJ6XDdPIrGY/WnvFB6ArpXkxQldOzlILyIdb8ebRywnU5XxHrT06CctTWHTA2XOD/PZLJ7rHdNL6Of69WduiqsTQKkapiuxT5a8YQXhQsxCQYm3AeDIpulKX6fMj8PBgjls7hsPhoPVl+BA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(136003)(366004)(396003)(346002)(376002)(69590400012)(2906002)(66476007)(52116002)(316002)(66556008)(44832011)(4326008)(6486002)(5660300002)(86362001)(66946007)(16526019)(6666004)(2616005)(6506007)(1076003)(83380400001)(186003)(26005)(6512007)(8676002)(107886003)(8936002)(36756003)(956004)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?MIPGy0664Gxw/IOxuf+o5pZf62XnMFZi9GsRdaJiZrITKPx7CQo08WjA8aP7?=
 =?us-ascii?Q?tFUwbgcshvPLmGJEgUeOrg4uizOcbYMQKMfCtjh5FJEZc/tex8H1yVDprFxe?=
 =?us-ascii?Q?Zjgfm6Y2z/RaXsU2uC1dgOGvwImwmhLcJPA1u9AvPxftWQ/Y/8TWxVdlXZ/V?=
 =?us-ascii?Q?O3gCINb/AhvabVxHcFbmL+eTOiETMO2ZRxf21jKpiWCs3GoJAYuFffUwjv+V?=
 =?us-ascii?Q?mmm/Asfoo5jCDRCnifsLX+ZS9PfozHWbrxXjnbx06V1GWOuasXUN6fCJTu44?=
 =?us-ascii?Q?Mkglg8ed6IkRqdSWj++4KbfKSlrdHzOm5ccSjkUeXshurKpdMFVx9wlwwN/U?=
 =?us-ascii?Q?zo47pZBTvC65t7veEeb3kAhW5oj8TIoz3HXa9c8ClBAQdCmEA7hv3BPQaKvW?=
 =?us-ascii?Q?pUurvFnsZq797SFuoJJZRe70vS4fxjS4BQGBOG9A6LADKNQvLTbinWJMe/Ni?=
 =?us-ascii?Q?qhx31lsE2RPeZC0S84qocqEGTTxZLyu+Y4d5JZ+ydy5jYs9CMpAcd3HSNQvN?=
 =?us-ascii?Q?a7cVsSndYn6RW2Qd70w3zSXl1cw355GPYA1Ev30hIFr3dBGleUqNtNvqyOWf?=
 =?us-ascii?Q?nmk/WgmFsu7NeEoeeEYvNnokWcwkgzgwAKS5STYWq1l8r/e0n4Tq/wZT3Hmx?=
 =?us-ascii?Q?IOt/O/pGwi8/qa4GT20IpZ5gHG5w9ssbU1xek+bkUxQcelatvb3Jdzw5qsgQ?=
 =?us-ascii?Q?XOsTzVd1vwD2kagirEoDiovT3LG7LSgagxjpjNYrJTeXL59wsftwwHTcqLBG?=
 =?us-ascii?Q?Oudh1gwuua2CpRUIPTzWjZXSGd2OJ1LieQBq4t4+pRVoJq9eyVkvUQWjuH3e?=
 =?us-ascii?Q?4nUiroALalA2JvqsXnh1oFnA0LitD1hEjIGmWe8GJ8yr5VrfAsbbYMPD7CsY?=
 =?us-ascii?Q?1h9uW2G2YXIhL5zqCoeqBrtZKzPIi1Z476B7HLIWcRYIVHuJ4KfSh4/dDpGd?=
 =?us-ascii?Q?O5D27PNSmPsg440sJTN98982CHCDIA9pmXNi8TXFniai39eQrxLonvcytHnC?=
 =?us-ascii?Q?9UkPA9I90YnRe9FPm8XObRwdbN7RDgh9AUANx2PDNJ/zLcSx0YAVhQvNG9HO?=
 =?us-ascii?Q?kS1DiEwcZa7t9vOoUPvXYk3t4Fh/uVTo5FVJmxq4niv8qbBeIUCZmcj0D7/N?=
 =?us-ascii?Q?xieXnMrUs0lNNFqsLUR9eELOwpnhBrPqCFGnwnTFLogpH5rjScHZX++IwKQ6?=
 =?us-ascii?Q?rc5N3fLxfWHZ6pNAL0LalneA36bhjypemDiTMp2hkRsRXfwpHldJNag187b4?=
 =?us-ascii?Q?EISbx8vAC+6fXsNoWvwuP3V4OLGbP5M88t70kUpPgxoentKeIdpFj+CLDndu?=
 =?us-ascii?Q?BzMsECNuAfXU/vsIDqyo7SkS?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 059b7fe0-65a0-467e-450a-08d8e4c9e620
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 20:11:47.4868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WgXh7hi2hvImrHqwVG5Szup5nm2pvnANRtcqFk/mRR6mpYQVviR/bSogOEMtN22WkRwCXakaDNwF36epsGN0qu+c/rAA/AuQzYzJqekqX9A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTBPR01MB3983
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-11_08:2021-03-10,2021-03-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 spamscore=0 suspectscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 bulkscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103110103
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver was only enabling the first clock on the device, regardless
of its name. However, this controller logic can have multiple clocks
which should all be enabled. Add support for enabling additional clocks.
The clock names used are matching those used in the Xilinx version of this
driver as well as the Xilinx device tree generator, except for mgt_clk
which is not present there.

For backward compatibility, if no named clocks are present, the first
clock present is used for determining the MDIO bus clock divider.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h  |  8 +++--
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 34 +++++++++++++++----
 .../net/ethernet/xilinx/xilinx_axienet_mdio.c |  4 +--
 3 files changed, 35 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index 1e966a39967e..92f7cefb345e 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -376,6 +376,8 @@ struct axidma_bd {
 	struct sk_buff *skb;
 } __aligned(XAXIDMA_BD_MINIMUM_ALIGNMENT);
 
+#define XAE_NUM_MISC_CLOCKS 3
+
 /**
  * struct axienet_local - axienet private per device data
  * @ndev:	Pointer for net_device to which it will be attached.
@@ -385,7 +387,8 @@ struct axidma_bd {
  * @phylink_config: phylink configuration settings
  * @pcs_phy:	Reference to PCS/PMA PHY if used
  * @switch_x_sgmii: Whether switchable 1000BaseX/SGMII mode is enabled in the core
- * @clk:	Clock for AXI bus
+ * @axi_clk:	AXI bus clock
+ * @misc_clks:	Other device clocks
  * @mii_bus:	Pointer to MII bus structure
  * @mii_clk_div: MII bus clock divider value
  * @regs_start: Resource start for axienet device addresses
@@ -434,7 +437,8 @@ struct axienet_local {
 
 	bool switch_x_sgmii;
 
-	struct clk *clk;
+	struct clk *axi_clk;
+	struct clk_bulk_data misc_clks[XAE_NUM_MISC_CLOCKS];
 
 	struct mii_bus *mii_bus;
 	u8 mii_clk_div;
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 5d677db0aee5..9635101fbb88 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1863,17 +1863,35 @@ static int axienet_probe(struct platform_device *pdev)
 	lp->rx_bd_num = RX_BD_NUM_DEFAULT;
 	lp->tx_bd_num = TX_BD_NUM_DEFAULT;
 
-	lp->clk = devm_clk_get_optional(&pdev->dev, NULL);
-	if (IS_ERR(lp->clk)) {
-		ret = PTR_ERR(lp->clk);
+	lp->axi_clk = devm_clk_get_optional(&pdev->dev, "s_axi_lite_clk");
+	if (!lp->axi_clk) {
+		/* For backward compatibility, if named AXI clock is not present,
+		 * treat the first clock specified as the AXI clock.
+		 */
+		lp->axi_clk = devm_clk_get_optional(&pdev->dev, NULL);
+	}
+	if (IS_ERR(lp->axi_clk)) {
+		ret = PTR_ERR(lp->axi_clk);
 		goto free_netdev;
 	}
-	ret = clk_prepare_enable(lp->clk);
+	ret = clk_prepare_enable(lp->axi_clk);
 	if (ret) {
-		dev_err(&pdev->dev, "Unable to enable clock: %d\n", ret);
+		dev_err(&pdev->dev, "Unable to enable AXI clock: %d\n", ret);
 		goto free_netdev;
 	}
 
+	lp->misc_clks[0].id = "axis_clk";
+	lp->misc_clks[1].id = "ref_clk";
+	lp->misc_clks[2].id = "mgt_clk";
+
+	ret = devm_clk_bulk_get_optional(&pdev->dev, XAE_NUM_MISC_CLOCKS, lp->misc_clks);
+	if (ret)
+		goto cleanup_clk;
+
+	ret = clk_bulk_prepare_enable(XAE_NUM_MISC_CLOCKS, lp->misc_clks);
+	if (ret)
+		goto cleanup_clk;
+
 	/* Map device registers */
 	ethres = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	lp->regs = devm_ioremap_resource(&pdev->dev, ethres);
@@ -2109,7 +2127,8 @@ static int axienet_probe(struct platform_device *pdev)
 	of_node_put(lp->phy_node);
 
 cleanup_clk:
-	clk_disable_unprepare(lp->clk);
+	clk_bulk_disable_unprepare(XAE_NUM_MISC_CLOCKS, lp->misc_clks);
+	clk_disable_unprepare(lp->axi_clk);
 
 free_netdev:
 	free_netdev(ndev);
@@ -2132,7 +2151,8 @@ static int axienet_remove(struct platform_device *pdev)
 
 	axienet_mdio_teardown(lp);
 
-	clk_disable_unprepare(lp->clk);
+	clk_bulk_disable_unprepare(XAE_NUM_MISC_CLOCKS, lp->misc_clks);
+	clk_disable_unprepare(lp->axi_clk);
 
 	of_node_put(lp->phy_node);
 	lp->phy_node = NULL;
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
index 9c014cee34b2..48f544f6c999 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
@@ -159,8 +159,8 @@ int axienet_mdio_enable(struct axienet_local *lp)
 
 	lp->mii_clk_div = 0;
 
-	if (lp->clk) {
-		host_clock = clk_get_rate(lp->clk);
+	if (lp->axi_clk) {
+		host_clock = clk_get_rate(lp->axi_clk);
 	} else {
 		struct device_node *np1;
 
-- 
2.27.0

