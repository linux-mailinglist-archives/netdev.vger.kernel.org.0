Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5CFE33954E
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 18:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232526AbhCLRo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 12:44:28 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:26667 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232363AbhCLRny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 12:43:54 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12CHbAuo017903;
        Fri, 12 Mar 2021 12:43:51 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2052.outbound.protection.outlook.com [104.47.60.52])
        by mx0c-0054df01.pphosted.com with ESMTP id 375yymhjj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Mar 2021 12:43:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ez29FIE4qYUtqLg2B7VB2b7LZSq7Ski+oTth8fVzzJE03MUMMoItxiZGvDH9jm2owEmJSU+FhLlglaWZmVGsFaIyLQBg6usf9HddkedIcn5ZVrIG+PCh7mK5LLQHhA5ENMI++J4YzcZhgNC1h44o+ZoS4qWpvwY+gCbq8mWa1CUWKy1JnySf6l9OJEVQ61uPdz4PAGJBxMgoTsD4AGoATAcDGj1PfTbpIhzHpeFUJe6BkHjekiOXZkMQ/7chRNRT996tAeVPRsfO1wsPCkXjCm/FrXiuGDZVf7Ra4XdGVFp/MXHr/0gTa0NQHQkZqnofj2Gss3KihKJLu8PHl6T39w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ayl5I131zrAVlvCSXK9ArD24wZUP7tRUHbCScetDGA=;
 b=mkTuMqBmeXw0iq4VB0rJWibD/p/M4z3XabS+DEX1UZVbM8ScM7eHzbbnm60pdVPNWSnR0Vwukc2u1IQDmxWdBrK8y+2kRTNg0piD/Xom5cfn/vB1pSbYlXM4yApQjGRxBus2XKWE6nNEtyN8rpQLhdE/+fpwuCPkV8yYWMt6tKuzjWsNT1FB3EQ1hZeXINEbaTh4F5xhoXCgbEwxyJydPoFTuhX3fywQIrasqXzXusu0ry5WnaZLJCB/1McfhsKSAsX5ktIOxzPgpfsJyZm/Ui47NX2rsXKssTx5R4ixbx7nxcdiME+TBrRGNC0ze9WL8/AN3inFERxUQbWC0jJ83Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ayl5I131zrAVlvCSXK9ArD24wZUP7tRUHbCScetDGA=;
 b=rmMik5luJItrWaBd9aKeJzZ5K5N0W9aRkpCO1RNx5U5Ew6zbpn/YD/3tpAfULg19h69Ys2hVX19OqiLv3ini08gjT8g+MvZtKJfqAx7fI/2z1JeeMVoKxNQucWFomNsrpPD+3EOpV9ts90Erx/1Uuy1sJbI1dARovjfx5VjWsFs=
Authentication-Results: xilinx.com; dkim=none (message not signed)
 header.d=none;xilinx.com; dmarc=none action=none header.from=calian.com;
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YT1PR01MB4440.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:43::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.2; Fri, 12 Mar
 2021 17:43:50 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::90d4:4d5b:b4c2:fdeb]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::90d4:4d5b:b4c2:fdeb%7]) with mapi id 15.20.3912.031; Fri, 12 Mar 2021
 17:43:50 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v2 2/2] net: axienet: Enable more clocks
Date:   Fri, 12 Mar 2021 11:43:26 -0600
Message-Id: <20210312174326.3885532-3-robert.hancock@calian.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210312174326.3885532-1-robert.hancock@calian.com>
References: <20210312174326.3885532-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: DM5PR21CA0003.namprd21.prod.outlook.com
 (2603:10b6:3:ac::13) To YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:f::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by DM5PR21CA0003.namprd21.prod.outlook.com (2603:10b6:3:ac::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.3 via Frontend Transport; Fri, 12 Mar 2021 17:43:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ac43d6b-3fd4-49fc-366c-08d8e57e659c
X-MS-TrafficTypeDiagnostic: YT1PR01MB4440:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YT1PR01MB44401E44FE7C6303821496EFEC6F9@YT1PR01MB4440.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w/CpJxLCnV/wks7FRs/j3bRqn6kzvRPiudKhOWKbGOLn7EaWWRE8+2VqMDIgWq6nXzrYFuqVoahPv46BVTyDVG/un0j0+qs1FUdFjLuvIQw4QMLY7Xd1XAADdQ48JZDXyWnDa2EbS3CTeZqIUQ0JVRizC1fkOum9bxdSKOnlI9S+q3RU4hlLkdAAZy3E8FEDT8iDFT1x5EjL8ywmZX55qbKsMd8WYTwvbCsz7yTtwpCT2hLeiQnCEiyg5Fq9nXmqqV9SV+B0iMH6Mm4BtJp8qdYFXTHM6aOgmG5rJn5rTf2TlNGccEHkTtPz+8nac7FTqJ+hM2lWbkQfGfdnvkZyqZXN1S4lxxl9QHsVS5V8AYXcnLd+v7QXNTQIYh455BtSQCTCWWzd6ekZc2ShZA9X5EG7UM9joHqBxI/eG5LqcO3F5KWuclGVlhB2IyFjBIqAOTUOob7W6E/pKvf4VyR5utrQY86APpiy90Wpql3XZiJyOu1i1xoC0r2CsA4uy3jnWVoNbTAw0OTcE7K2zmOehtaJIRzoVmOzR9I2Qtk9GOleUY+NX+Cve9pS3wQAJoCe5R7rhwB+s6vTehNtdKJ05w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(346002)(376002)(366004)(396003)(8936002)(26005)(2616005)(8676002)(16526019)(107886003)(44832011)(4326008)(36756003)(956004)(186003)(83380400001)(2906002)(6486002)(69590400012)(5660300002)(6666004)(316002)(478600001)(6512007)(66946007)(86362001)(66476007)(66556008)(52116002)(1076003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?xnMbL03zz55QW4UvMck2FQAnCuJjg27hBmdetn9bri+0xzODgL1srpn1xoGm?=
 =?us-ascii?Q?rDEawYl8CycrwziWC/49TnkSRLYkY3a5WQSHkEGBStf5hdPQ3ZLpUeuXuivT?=
 =?us-ascii?Q?iz7hIOUELvViTVRMo7wJ29bhyLNT51jVreP1Wvk86+YWutWzHaAB+SPV2uEz?=
 =?us-ascii?Q?HYwd9FhoElUy1IOCAXVxWye6d+QKcKDO/ocCKw5bSRXRU8gJ3KgbPmRd5kdT?=
 =?us-ascii?Q?ZeQ6DiwG3ooz38cP+DW2//45bXPdH3+PbYt2T50RKwZb0MXkNpS3zlFOtezi?=
 =?us-ascii?Q?iPHTb+wWVPxtgaFRjPkwfesHGGsMrz6tkkeXQ5e6L51jR+ICXfVbqUdEN2Gi?=
 =?us-ascii?Q?2OYpJQLjFl6hMc7aGSyCF6i3UnOe4MZA3DRvOfp+PRh2Uu837BcrqelIlVxE?=
 =?us-ascii?Q?bDyNOM4tBMxLQjlrggD0uU19GmpKNQXUKJ++eOidcvdlmPaKDTNN4QA8hsfe?=
 =?us-ascii?Q?k/K2CmtXYC8diHV2IZNu/xkVbFOBhQnIDRSNiINoLc04C/dbi9pxL1kkKhHM?=
 =?us-ascii?Q?GwoeF+cQwQL3xKqkwf1l2jmTm5vlGKx9cbhFSUTdzK4mmSpQn+ZdmLMqUWJc?=
 =?us-ascii?Q?4H++tXI56TwqwfMynG5AEz7rfA+VYHmD7yUaBSpTTn9ArSdvgJdkI0Gt3zaZ?=
 =?us-ascii?Q?mN9sQCEQAcl5IzrieoUAU9+cnfp0k8d3tdgvZVvVjXKVhJLi5EHgXfUCKWPE?=
 =?us-ascii?Q?u+cMb9R2DsY9ff2QBHH/l72EcDPxP4JjLUZBEatKowO8uLUk3F/t90939koM?=
 =?us-ascii?Q?TgcP+Os2ROSvtXBj999npyD4m1fGLuTObxpVFatwk4MwYwatsT/E7XZQ6WqJ?=
 =?us-ascii?Q?Cz8GaFwAIQ6Tvzo2okn/xoh6t1uIgxD75kluVDM1gt88PxDxWd+BLMB1fj0g?=
 =?us-ascii?Q?7XgDdh7D8OocKPqYYPX3c7+xFrRWdNC2vG2naPiYxNdjNRGxlv/3RKvYlyg4?=
 =?us-ascii?Q?sDoKTE8pubmaBoa3g6yd3GKCVQPsbXDvfq+qWmJLkmvI1q0rG88F7ImJc33U?=
 =?us-ascii?Q?mUOs50jcQ6qws95vN74UdgJSJuxbTN7tsgGuXjwfUZMWKpRlWWeBi1tiDTMT?=
 =?us-ascii?Q?HLHtznedFyBcyNT1VMb9A7+hdK2gkpLzbYCvuF1tkRSScjMrsBcrcqEOxmEm?=
 =?us-ascii?Q?uMZuDdp0mXIuwjfAqBFbE/rHuFrLifGhrLPrSGMUdtudAXZHVevIMSK9+pWW?=
 =?us-ascii?Q?JiWCQmmzU87+5UGcL1GVZchtfYdzZYwDGrW2Inh5osUI/QUd/HlLgioyrrCU?=
 =?us-ascii?Q?uuxlJ6RWrdW70dQ4fzp+PYXvdXDZeyJgp9NBfCTaQQHLYKcRqATqZkmB09L8?=
 =?us-ascii?Q?CoRUp1iuTAmbk2KTEXjrJsj3?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ac43d6b-3fd4-49fc-366c-08d8e57e659c
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2021 17:43:50.7940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NHH6KCdpezBGchYv8EZz564B/IPQBpT+wsc4yT10a7kUIub/9usy/f6lFUMfXPBuM5IboX07D4bFRtAeIetiCXxkgQdEt9BOyHrWN46MS6U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB4440
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-12_06:2021-03-12,2021-03-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 spamscore=0 suspectscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 bulkscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103120129
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

