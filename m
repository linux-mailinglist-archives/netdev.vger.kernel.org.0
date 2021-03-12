Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80F483397CC
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 20:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234498AbhCLTxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 14:53:36 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:60399 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234427AbhCLTxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 14:53:14 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12CJqnec003114;
        Fri, 12 Mar 2021 14:53:09 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2059.outbound.protection.outlook.com [104.47.60.59])
        by mx0c-0054df01.pphosted.com with ESMTP id 375yymhm92-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Mar 2021 14:53:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AgF+cI8CzXvWhs3PEz8m7PLQOITkVIz9a5VKwyjIjpglJejmYYll8kTg7nu/2ESsMujTrXNz/B9aOg5WbfbABSMHccTtwZzel/dbh12YWKBu3auoA/Q3C4/pWamZ2IAnEPI9kGSXuboRRQYIEz4AlY+34NBxQa1JRHYP80Utb0f9B9RNJ/rM2B3JXDPb/2hXmEyHFXnYJd1+obL1uDPhAizw1hQpZbkDPSpIIjibflt7R3bPnMMBrxr6F4tEy05lNx/9APPePCrG0fhyz/EDOH8CzhJNjTeF/e7eds18x5Juo2hXBUihpuFsW9GAuVE+XsvLz/ghMto9yrwHeZjxfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ayl5I131zrAVlvCSXK9ArD24wZUP7tRUHbCScetDGA=;
 b=XuasdgVX2Hg+fgQcVMGaHStF49rMJdyaAKMp5sp3tML/uEFTG3WvUorgs9142sWNUM3FZp8mUeIZV2DSPFDrz8wtxQyXy3DPbkvfpgHbBuZycHSsTBurKhDCF2dE014vg5Fnjad2MBK9JRyun+IJrCc9BXnyv7Y5T0Z/x/AtorpqIGZzkChtJfz64sxkq1aTxuC7YTSw8/p2Go0nfaGUalWX+u07PLp6vqD8hUv0JKxXrmAPF8T/2GWB5hh5mbEyApSKqUbd2EXSOVlHuyjCBaVMEfWPqUvNu1rhLp47CmXODIg+No3+9xlHQWYTa0koUNZHbuzq8EPRyrkfXL1jIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ayl5I131zrAVlvCSXK9ArD24wZUP7tRUHbCScetDGA=;
 b=2lg0ON0n0d//U4BNs6yP2/vFrBdlg6XiufdLEVyWCkBU6H4zEoqEOya4uf+H4yRcX2y44E1yABG927PIUb/DFf3LvCcPl/l3eqskPGa3XDoPB6dED9NcKBKbJFSy1+ZRVXVgy08GRwX6M9EmNfjhbd76vRmIefwloESIuxW7X8M=
Authentication-Results: xilinx.com; dkim=none (message not signed)
 header.d=none;xilinx.com; dmarc=none action=none header.from=calian.com;
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YT2PR01MB4415.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:34::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.26; Fri, 12 Mar
 2021 19:53:08 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::90d4:4d5b:b4c2:fdeb]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::90d4:4d5b:b4c2:fdeb%7]) with mapi id 15.20.3912.031; Fri, 12 Mar 2021
 19:53:07 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v3 v3 2/2] net: axienet: Enable more clocks
Date:   Fri, 12 Mar 2021 13:52:14 -0600
Message-Id: <20210312195214.4002847-3-robert.hancock@calian.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210312195214.4002847-1-robert.hancock@calian.com>
References: <20210312195214.4002847-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: MW4PR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:303:8f::30) To YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:f::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by MW4PR03CA0025.namprd03.prod.outlook.com (2603:10b6:303:8f::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Fri, 12 Mar 2021 19:53:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57c83c2e-50a3-48ee-7ff2-08d8e5907528
X-MS-TrafficTypeDiagnostic: YT2PR01MB4415:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YT2PR01MB4415600420116A11A869764DEC6F9@YT2PR01MB4415.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VFojZvDJHMtvoaT67xpANYs/0mCO0FNhiv0sTq3OcEVbWVo7W3d2RJfuWXGit0A+zraBd/wTZ6CtEPEmuG6hHTfE1igDbV/oq5jHJz4pv+kfaMGZRCF5Q6l6u/Y7eeQexYxoR4puxiWGElnMjfMjIWFYYznsNqxZOzPDS6qAfUpRPIMKQ6jvqIjWTlcVsVRCVkUXZ1FJ/EuvqMB4tKLjymtsAQSRRCbTrxk6B7V5N9VqgQQusiWjDAmc9Ri2XqN3+AFmojb8AAW0avcdrrcEsUFVbX3vBMjq+TYV+2fXNLBI2KJQJ3be9n3r/zhf69/yxC7E3hep4jNdv9vKf9SjfjnHDKu0qh9rZfOBijUZgjJ7Ny3/bXwvKc5zhJ3GOSZz3F0YvPfDOiFOBQoPi32+yqNzkO8ptoM0Bssiu2TqHoMCe6Bzfn+zfYFg+kwEE10M92CyzqwRoteUc+ovPXSuWID0PhHuwBJG1Ku5ATcZEoMgJA/EkXvv+YK5MZxqZsqYNXczDVHi1HGsvZ4VSvxwfR9WgIxNdBoKW/JwxzPHd0GNy3Ai9cgYhka7SbRIUmQx3AbS3eZbT+HQsG5zzcygUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39850400004)(376002)(346002)(396003)(6512007)(69590400012)(86362001)(66946007)(66476007)(186003)(26005)(6506007)(8936002)(66556008)(478600001)(4326008)(956004)(44832011)(5660300002)(2616005)(6666004)(6486002)(1076003)(107886003)(83380400001)(16526019)(52116002)(36756003)(8676002)(316002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?LYLMjTs3yr7SoarIIXc1nUde7QEOP09cIXCnSkwyoRgJae/AckiqjmYug+ZM?=
 =?us-ascii?Q?x/ESgENspJseJ9Wkljshq1+u4KriGDq0DKgWpQbyJbcoKdh3iIzsWXx05WDG?=
 =?us-ascii?Q?22U7JymDrp5T1f2IsfWXH0lNdc6BxNS3LmxrwcOpRwhqmqo3vfifM+R0f/4J?=
 =?us-ascii?Q?yN7NYbPFlUMq+XqMDRjeMYls/xGSTIqLwqs8iqmbUHP4fuWfFC7FEYenuo2A?=
 =?us-ascii?Q?fUQqAAk4d1JRcyuvgFz7sGtq96Bs8CY2OjxYXa4tM7Xb4SAUZLLzalqct3WY?=
 =?us-ascii?Q?lybXlWSRu713cIgsRXcE7YQIgN8AVwFhxojSH/xFharVCcZcTShp3LW+/2FC?=
 =?us-ascii?Q?PrqXWQrqQYYIt4PBMg3K1AKRpSeh4xFTNOrHtCSfqQlguA1wX0babLfxtumZ?=
 =?us-ascii?Q?TrnkWrBthMv3aNCLHtcLZ4W5auce7y1W2uw0Qu97T5Nu+I9PF0zhnxKK8BXf?=
 =?us-ascii?Q?FV/AWFWghywcH7KLWBO1ti41ocht6oItzUqQEqxfy3IcQqKOz0KuRgXs+VHL?=
 =?us-ascii?Q?EX1kp+q/azW0i1BjZPfvIM7uzLQpe69uVkGGpb4l8SKLqIfaFaCTxM4Gp5Gh?=
 =?us-ascii?Q?hRESElpgHLTetbeBQr7cAW2kX6xVuu7GpbHPQytqJyN0hDcjFuXDvsOOwseP?=
 =?us-ascii?Q?C6hNvCBWIHaU1HVqY5T8n3pmBo+2vgRHmksaTNW+kiSt0wdp4CzpeeZKK494?=
 =?us-ascii?Q?rVR9O5hs15AJoenP8XWUrElnLV4kOrqZ8+ntA9J6+Q3hAbAU/CCwu7spXaey?=
 =?us-ascii?Q?3Lj9Y3rY0sNGdkLiyZHfU194T8PIYCpyYVOVezZilyVhg3O6CIjZ/s4pBqus?=
 =?us-ascii?Q?cjhn15KfpikdxbnnQ32Jl6VmNpwBgxyqxR8SHZ/WzVjjlKngbubAmpb1OrwD?=
 =?us-ascii?Q?UrUL654gZi52cqcPSJdLphhJHF9fukf5jf6eeBwLpi9AE27OXGgJm1wqAwLZ?=
 =?us-ascii?Q?yQDekxVEOqLdIjFVXpm6zl+6DiF347MRHtRpJWPSUEmfcOaU8qUerB2tn+eB?=
 =?us-ascii?Q?yrh91TiZUoahBg/xSITr+mDbevwEmL0Jtrk78QAnNVCd4dmntJbKtYop+16s?=
 =?us-ascii?Q?lRykzQpmQbEBEKrEXnWbxc6l7WKHveo5/ZWNswYwGUG91TjjtYBHa3kMTWR+?=
 =?us-ascii?Q?a2DLnTLUBvkkVOa4+CdBTrdUEaj9QxfkrqgpQkMwiTwsCPT+y1WQfCY5QcCJ?=
 =?us-ascii?Q?Xmd7dt+T6iKOra1nIg3h0DYjcYJ0nD7fSUJ0/wlyAj3vBpQLskOYsWAEDAxP?=
 =?us-ascii?Q?d81TlcHSkewt1gxkw2BZjftnla/0vXfy2tzeD3zone8Hj9BZVo05VBM2dQxI?=
 =?us-ascii?Q?B4e2zza9eAh30kcP0UfodKue?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57c83c2e-50a3-48ee-7ff2-08d8e5907528
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2021 19:53:07.8703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 16kkz+60Vj1ooPUjfuzE07/j7Pqa7GN47mnKV6oy8u6KSJfyMT/g96/H6b9vzyIPS18AbnniJYyeKNyYfQkAHIEj5hauSFZre1RXt2ggOmE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB4415
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-12_12:2021-03-12,2021-03-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 spamscore=0 suspectscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 bulkscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103120144
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

Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h  |  8 +++--
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 34 +++++++++++++++----
 .../net/ethernet/xilinx/xilinx_axienet_mdio.c |  4 +--
 3 files changed, 35 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index 1e966a39967e..708769349f76 100644
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
+ * @axi_clk:	AXI4-Lite bus clock
+ * @misc_clks:	Misc ethernet clocks (AXI4-Stream, Ref, MGT clocks)
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

