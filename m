Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D78D3337EB2
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 21:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbhCKUGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 15:06:01 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:27317 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230300AbhCKUFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 15:05:51 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12BK1iHQ018259;
        Thu, 11 Mar 2021 15:05:48 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2053.outbound.protection.outlook.com [104.47.60.53])
        by mx0c-0054df01.pphosted.com with ESMTP id 376bes9hs8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Mar 2021 15:05:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fA3AIl2hu94rDZVM0yvWzJujsxsBt900jiuKdKNtvXChU4QLex8qBnI/bEr1vXtDtjC3xqQAT8fWqmGJAVCuF1i9P1au1EsOgR50VncMQ2tdCDJn/qUXHZNSv2L76fb+cxlW85Upo8o9iB6hNNJ/LfmVwJy0NgURYwN7QqRof1P/6KOPHHZKbSDc+AWbEkGFQHlU/Os/KFRmnquo1DHlkxkFses2In2GvAJ6XK6tgj2xdF1GXLN6kBAxw9oiyQ0FQxtYT7LhJxgSyEgd6oJwNbHvmuQLwjyPOitM9pD3bWAJCzUhm8H2Ufuu0fAzvjx2+tZKkdPiXcG8vwD03OznGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iowwEzv8TUQ2+2YylyBoLPTi2x4gDCPXSUMkdhtWvVs=;
 b=Bca/ICsknBHkQxPxg15D66OuURNRqyCWAfNcWWZGz8H2hAcZ8A/i1jMT7vRZwGysUjEgJ07uS30KY95e6IXcYW+EIEOTR4R5hMOWuPlha3HsyeWaOHM3pgAnx3R+YoMMVV9K+JjyS3yQ0JifO15Wic1fvhpfh7UbxqYukiJGscz8gCAVDIWN8Cxvl6cpj8xC8xOT8zQmSg0glMTPQs/3VrLLD+h3xD12IpzXjrAMhVa8kq9uTNRb1dm1hQ4tWnU+g0uSthZBuNlWWOxmBfMZXkFvaoglFL1i9KRhMPPixoszkSohCivAn69Y9iRp1qIDKnUzpb4MPSWhmf7AdbQRYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iowwEzv8TUQ2+2YylyBoLPTi2x4gDCPXSUMkdhtWvVs=;
 b=jg/F5byyzcvab7tzwpFPCv9udLQJEQvNm+jqootGkcjXQROw8NLFTkyVBpDsCpsiSW+eWvVodzCZ3tXvpZKe1hBHadpr205WOikHFESSCAFc6NJ7gB6dSnQj0wSZhIYFOtRLXgIcEVfquUms0p1w0dwpS8HfUaeFOr0Av7/cXRY=
Authentication-Results: xilinx.com; dkim=none (message not signed)
 header.d=none;xilinx.com; dmarc=none action=none header.from=calian.com;
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YT1PR01MB3289.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.25; Thu, 11 Mar
 2021 20:05:46 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::90d4:4d5b:b4c2:fdeb]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::90d4:4d5b:b4c2:fdeb%7]) with mapi id 15.20.3912.027; Thu, 11 Mar 2021
 20:05:46 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net] net: axienet: Fix probe error cleanup
Date:   Thu, 11 Mar 2021 14:05:18 -0600
Message-Id: <20210311200518.3801916-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: MWHPR04CA0060.namprd04.prod.outlook.com
 (2603:10b6:300:6c::22) To YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:f::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by MWHPR04CA0060.namprd04.prod.outlook.com (2603:10b6:300:6c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Thu, 11 Mar 2021 20:05:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e6696b0-bc50-4ad5-9737-08d8e4c90ec8
X-MS-TrafficTypeDiagnostic: YT1PR01MB3289:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YT1PR01MB3289845BBD3393B08447FEE7EC909@YT1PR01MB3289.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FKeMhO6pGpWUMNIxICJd2ZrYs7kpn4/jF7QY/E7XdIbFCLu1bXBIYhpaduwpU68u7TSQaR2O+9uBHapxWnsx6fCIK/deUgREswKCUkMXlX0Vc6+CSQ5X3vBG9YH4L0axIg9s8nIgev4vB3MD4wCagmGGiVv5434HUXRd0Xq9RVtZVtX0O4Pq3VEPXlkOgt0Sjzma8vVUs1KqsDfiV24HmB2OlekYJPy/ZulS9xP6Z6EnJhyd/M6yhiyI7CtJkao3RMnhWXkLRy3d81b/LmA8OmoM3tpEy0Yabo0duu+lojm28bA0pnGsoJev0QXaSiWd5xLYa+ElgVdcH6ITcrYyFUN1ywx4JVyKtoC+/SUJn0Y9QcMxO+wAiBEOzRXymnU9GAbuRYv3gtjQrMEUSE8rKiWwDBFVzTNvtKN0e9b8yVX/GhhRP+ybBv1hstSHOuEvUlA0TtULMYlnPBFeN8vQdHwz1XGS1464VNVXDLAadwRpud7tR2bUN9OI9MHfGW3pRqQSxQnQLEuMrA6UvxIvCdnceXRuZtpRmdPrBtZrmmY1GMEhcxaLY60WO0BN2i7IYw7O4rFI4gOKGzfJpw/P7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(376002)(366004)(346002)(136003)(396003)(26005)(66556008)(6506007)(8936002)(83380400001)(316002)(66946007)(6486002)(6512007)(66476007)(107886003)(4326008)(52116002)(478600001)(1076003)(2906002)(69590400012)(5660300002)(2616005)(956004)(86362001)(16526019)(36756003)(8676002)(6666004)(44832011)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?OzGOXZxPaAW3QHhJL0lQaC0ULq2MlJzPgCt/OD1hgkldWL2YHR7Q+0PqzsLA?=
 =?us-ascii?Q?/fKdCVcL3g8aE3cXpBjEHG1epo/sGqAWMqTFWnY9P36GkBWG3r179bJKNLz5?=
 =?us-ascii?Q?Hq1eVepyBVE8QtjDEdsF8i/IC1imiP5nBGMsDdU82ukjoE4yY21ptMHNgA7Q?=
 =?us-ascii?Q?x5l+TTxPa+F1gBgrzN+m9Gujt3P+q689m12qzd9JLt8LHaKkqPrS6Ykff9iP?=
 =?us-ascii?Q?6npaKTF3Fxnms9RxpuxoHxoiRtfrXsv3u4AtO1zm7/gTffFts5QhGiXxVRFt?=
 =?us-ascii?Q?yPKYWUOxtYFcIr3vobrtUJnVS10Y9UPtAu/dOdyRuPeVxAxgud9fEr7DGF0b?=
 =?us-ascii?Q?PO8Hf9RH0zeizRU3A4ANICrZD9m3/yx9ya1PD+/VNME95XVwKBve3sHF4i6a?=
 =?us-ascii?Q?NoFAlZ1lDrb0+b6NZPUIFGo8lDoybyqVpiCQd9qG+U/jRh56+1jnbvyOwLYA?=
 =?us-ascii?Q?iSCNgoec168BsibGAS7KxCIvr9svFBGcR+211pEahjhce95OrPRBOaABaw8k?=
 =?us-ascii?Q?r4RqarcHBLyiSrrdJCdb+7wLUF++tazNiXtkUczla3w/4Yh/8Q5sln+keDss?=
 =?us-ascii?Q?p0EZSBu1DHi1hS4xR5UtHjqH45v+PGYkBrIUw2hx1hZ1IaGj7fQuA1W15bPv?=
 =?us-ascii?Q?FNZG+D0qz4cstJ4poz2sVvj2jMz9VhSKzypaFAF/Ya/hDe5RHgkzgEBuJWUs?=
 =?us-ascii?Q?6jFXrLcCqK/k83eUmpNbcNtY6ynL2kat1UCy0rIqy+vhkZGNtxBAy0KOy6mA?=
 =?us-ascii?Q?L9iOJALaAcNepe5uqCDRT9QqgR5EM+IQhoeF8637liKuWa7IIY3QimGzf0cE?=
 =?us-ascii?Q?ZexNSDD2p10JqwmYdebkXmEfMyAGWHRJiI5oc8EWuoWKfbyp8ugMUmrSd/oQ?=
 =?us-ascii?Q?JVmc2+/C5muiYShhU62YiTbgNDEXtzskswVN7v/ahz129kLnxVR0CBOEi01q?=
 =?us-ascii?Q?1I7ZfSKmgk1MvtS17GNB71/xzgHhzyH/qPM1vWqrwZbGY0w+STSVgWh3CHlA?=
 =?us-ascii?Q?SwP7bfht3AGx5daI0BTPpkS1AT3LTmw6WDgGV/TiC+/5qm075o23rV/WP9xc?=
 =?us-ascii?Q?Y1UiZFQ6FyDjm2OUxqQB4k90UufWrh0/IxQ/1cUwg/YtcbQBeB/YeUTmO6Hs?=
 =?us-ascii?Q?ANPtNjDG/seq/dqvLx3+Q9hDSSlJJiB+rJlOgnBZMlf4K755S+bVyp083Teq?=
 =?us-ascii?Q?Q7VAOFP6AjgBc+VYlSthdiP/iKwxKfmSADqH02cjS5ZSKt/NZcl7R64dIwO1?=
 =?us-ascii?Q?+hqAea7Yhvt/zDCyPC92CJqdjZUpF7zwadE3C4rFqmVJHDHwFd6cI3MjoOhZ?=
 =?us-ascii?Q?fOt4D29iaGX9ietsdUqEou+Q?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e6696b0-bc50-4ad5-9737-08d8e4c90ec8
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 20:05:46.2590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NS1F9pZIA/HQ4moRAiNv1CL5O3sD2fh4g92ZCw628UgEoq0NHNTwBkr5xI1XZ4oGCyH4jWRwA/d6d+l44II9ibVSN8Ra2IchhDHJnvcxKfA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB3289
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-11_08:2021-03-10,2021-03-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 phishscore=0
 priorityscore=1501 adultscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 clxscore=1011 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103110103
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver did not always clean up all allocated resources when probe
failed. Fix the probe cleanup path to clean up everything that was
allocated.

Fixes: 57baf8cc70 ("net: axienet: Handle deferred probe on clock properly")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 37 +++++++++++++------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 3a8775e0ca55..5d677db0aee5 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1880,7 +1880,7 @@ static int axienet_probe(struct platform_device *pdev)
 	if (IS_ERR(lp->regs)) {
 		dev_err(&pdev->dev, "could not map Axi Ethernet regs.\n");
 		ret = PTR_ERR(lp->regs);
-		goto free_netdev;
+		goto cleanup_clk;
 	}
 	lp->regs_start = ethres->start;
 
@@ -1958,18 +1958,18 @@ static int axienet_probe(struct platform_device *pdev)
 			break;
 		default:
 			ret = -EINVAL;
-			goto free_netdev;
+			goto cleanup_clk;
 		}
 	} else {
 		ret = of_get_phy_mode(pdev->dev.of_node, &lp->phy_mode);
 		if (ret)
-			goto free_netdev;
+			goto cleanup_clk;
 	}
 	if (lp->switch_x_sgmii && lp->phy_mode != PHY_INTERFACE_MODE_SGMII &&
 	    lp->phy_mode != PHY_INTERFACE_MODE_1000BASEX) {
 		dev_err(&pdev->dev, "xlnx,switch-x-sgmii only supported with SGMII or 1000BaseX\n");
 		ret = -EINVAL;
-		goto free_netdev;
+		goto cleanup_clk;
 	}
 
 	/* Find the DMA node, map the DMA registers, and decode the DMA IRQs */
@@ -1982,7 +1982,7 @@ static int axienet_probe(struct platform_device *pdev)
 			dev_err(&pdev->dev,
 				"unable to get DMA resource\n");
 			of_node_put(np);
-			goto free_netdev;
+			goto cleanup_clk;
 		}
 		lp->dma_regs = devm_ioremap_resource(&pdev->dev,
 						     &dmares);
@@ -2002,12 +2002,12 @@ static int axienet_probe(struct platform_device *pdev)
 	if (IS_ERR(lp->dma_regs)) {
 		dev_err(&pdev->dev, "could not map DMA regs\n");
 		ret = PTR_ERR(lp->dma_regs);
-		goto free_netdev;
+		goto cleanup_clk;
 	}
 	if ((lp->rx_irq <= 0) || (lp->tx_irq <= 0)) {
 		dev_err(&pdev->dev, "could not determine irqs\n");
 		ret = -ENOMEM;
-		goto free_netdev;
+		goto cleanup_clk;
 	}
 
 	/* Autodetect the need for 64-bit DMA pointers.
@@ -2037,7 +2037,7 @@ static int axienet_probe(struct platform_device *pdev)
 	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(addr_width));
 	if (ret) {
 		dev_err(&pdev->dev, "No suitable DMA available\n");
-		goto free_netdev;
+		goto cleanup_clk;
 	}
 
 	/* Check for Ethernet core IRQ (optional) */
@@ -2068,12 +2068,12 @@ static int axienet_probe(struct platform_device *pdev)
 		if (!lp->phy_node) {
 			dev_err(&pdev->dev, "phy-handle required for 1000BaseX/SGMII\n");
 			ret = -EINVAL;
-			goto free_netdev;
+			goto cleanup_mdio;
 		}
 		lp->pcs_phy = of_mdio_find_device(lp->phy_node);
 		if (!lp->pcs_phy) {
 			ret = -EPROBE_DEFER;
-			goto free_netdev;
+			goto cleanup_mdio;
 		}
 		lp->phylink_config.pcs_poll = true;
 	}
@@ -2087,17 +2087,30 @@ static int axienet_probe(struct platform_device *pdev)
 	if (IS_ERR(lp->phylink)) {
 		ret = PTR_ERR(lp->phylink);
 		dev_err(&pdev->dev, "phylink_create error (%i)\n", ret);
-		goto free_netdev;
+		goto cleanup_mdio;
 	}
 
 	ret = register_netdev(lp->ndev);
 	if (ret) {
 		dev_err(lp->dev, "register_netdev() error (%i)\n", ret);
-		goto free_netdev;
+		goto cleanup_phylink;
 	}
 
 	return 0;
 
+cleanup_phylink:
+	phylink_destroy(lp->phylink);
+
+cleanup_mdio:
+	if (lp->pcs_phy)
+		put_device(&lp->pcs_phy->dev);
+	if (lp->mii_bus)
+		axienet_mdio_teardown(lp);
+	of_node_put(lp->phy_node);
+
+cleanup_clk:
+	clk_disable_unprepare(lp->clk);
+
 free_netdev:
 	free_netdev(ndev);
 
-- 
2.27.0

