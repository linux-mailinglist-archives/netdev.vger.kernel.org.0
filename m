Return-Path: <netdev+bounces-1373-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B94D76FD9F8
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 10:51:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D291D28130C
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 08:51:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8929648;
	Wed, 10 May 2023 08:50:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8E236E
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 08:50:59 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2086.outbound.protection.outlook.com [40.107.94.86])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291CB6189;
	Wed, 10 May 2023 01:50:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eyXn6PWvew6WbOwCQ3J+hsSa9qlGrjYPMWPfyotDm1Dhfa3gnFOgLvWhLjuqKS8k0a3B6LnYfksgpkkDoPj3wPadNCoc/ZFHJeYaDxepxwhsu/Of60/WOThQbriE/IAutvkVeiKouJieapoqQ7MNFQ5ItMWd24mrQ8JL8oAEDBWfbTUN+tIE+seh6ImI9ACOcv4eHyY6aqsuP1E35FQVKnDN+ocjIKsurWpF/eMqaNoQ2wNQ2NgCS3fq9C02gQ8KoaIaGfLDLmG4w4Qu+Qp743m+Nohv7SShJ31FHHGdDDW4arcBE47Thhwu5/r6KtjY2LqxAySRTSLJExAdMpiicQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mFyujdkTp+yiZjqCwuRb0XBgZZSOBgeLBZoElSIaXkc=;
 b=WMoKLhjnDLWEqlyG6WvNZVUWTlFEYBmP0Noguto5fZEqDKDYkX89wAWkxmRxUg+uRqrp90d5JIGW/Fd4XL3pFMwuawmcKA0ZDT2ssHXWnZcW0P2zJAuNRcGwYA9B50ZV68L9879cXRSa+2vbGCyzFp1qzvkRYwQXbrBwRxl6P+gh7DSrVAXz+3xxFxYKw3vcilK3KaKIRIR+VWQAYGnbewPPV/SdJBmcXyzKdtaLKyyoP8bS82fqyb9zPAf0stJcSxSAQJT4HXxIeRR1kCV5Pe+6B9jIxecNDRaLbYTNsuVMCEqTDg4ergUIWHJDmA3XFBGdsHEouMoJWZPKHsKT6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mFyujdkTp+yiZjqCwuRb0XBgZZSOBgeLBZoElSIaXkc=;
 b=RD/wThJq1PARbH6tiq9DCZySwXn5ICgWls6HpF901wzjl2XWMX3xgpHad/nhTmdQh+zikDDU6oyENW3Dv7aXmeF1r12H8I6QknUsCpsWTY4eTihKgf3VT3DdMfb9FO3V2STF3jRY6dyYjzMJFgW0JcUKi8M4vG31ElBB0fo3UW0=
Received: from DM6PR13CA0057.namprd13.prod.outlook.com (2603:10b6:5:134::34)
 by PH7PR12MB6587.namprd12.prod.outlook.com (2603:10b6:510:211::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Wed, 10 May
 2023 08:50:47 +0000
Received: from DM6NAM11FT104.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:134:cafe::1a) by DM6PR13CA0057.outlook.office365.com
 (2603:10b6:5:134::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.19 via Frontend
 Transport; Wed, 10 May 2023 08:50:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT104.mail.protection.outlook.com (10.13.173.232) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6387.20 via Frontend Transport; Wed, 10 May 2023 08:50:46 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 10 May
 2023 03:50:45 -0500
Received: from xhdsneeli40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Wed, 10 May 2023 03:50:41 -0500
From: Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
To: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <robh+dt@kernel.org>,
	<krzysztof.kozlowski+dt@linaro.org>
CC: <linux@armlinux.org.uk>, <michal.simek@amd.com>,
	<radhey.shyam.pandey@amd.com>, <netdev@vger.kernel.org>,
	<devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <anirudha.sarangi@amd.com>,
	<harini.katakam@amd.com>, <sarath.babu.naidu.gaddam@amd.com>, <git@amd.com>
Subject: [PATCH net-next V3 2/3] net: axienet: Preparatory changes for dmaengine support
Date: Wed, 10 May 2023 14:20:30 +0530
Message-ID: <20230510085031.1116327-3-sarath.babu.naidu.gaddam@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230510085031.1116327-1-sarath.babu.naidu.gaddam@amd.com>
References: <20230510085031.1116327-1-sarath.babu.naidu.gaddam@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT104:EE_|PH7PR12MB6587:EE_
X-MS-Office365-Filtering-Correlation-Id: 53ee1834-9b7d-492c-5bff-08db5133a5ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	kPAS9Irgq/QHwaK8XSf0V8A0grX+iL1Y+/VX4s2XEX8vL9P4ScAjQDAyq8QX9JGWijeyxD/T67KbbIpJbLZbOnK+2m6qtBCrQ+kAeeBxmf1oZJouCp8+/Keo+YHDBZw6rn44kU/gz2sX4COK12v4rY0AB7jQKkLDks3FwSXNqnVSAmwBN3P6Z90g5XEI6eWfijzh8ZBuHhConybJYDWpZDiXV2MwGu1d+msrGqjEDUi800B8E8qFOVZncVIHLr9gKPaEYfmJqBp1q1YWrpCbHRrj9bwYdOKuMe2X9J+eMe1XGmbpzkL0kkTQKZj4lH5d3qzZ2RDvAhbOHAMtSiQYmOri5Of1kZOESkXR8NFn7KT4jGnZ8sZrXXai88hjH+KnBBba9XYY/+M+D9GYfmc3jilYUD169XkPBj1VxGlI9K6b9R/lxwHi+P3ddymm4/kIgh2p7+ec10oBoqdo1X45wWSmcIgd+EpVwzWZelUyyfYYowGL2ObPyrOFf3bKei4bEOFUSr8s/mZxGpSBVnjHN5qc8yUQKFdvio/hGMKXuJ6oslPXWJijL/9ael9gPn+LsLk8Boi+3eE9Wa1jSX9M6a6nn6EUn+BHHxIVLeT5RIZ5RyQSUwPo4/cguH74JD/LlR3hOLgRJAAr1mrQ8+pIFLnripj5FXAYGIEHetg2JywCsr15wV4ulOZkx+jauep8CidiD9oHSoRt4FM7Gy5MK3kC31So/JVMMWaMTb4qV9g=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(346002)(136003)(376002)(451199021)(40470700004)(36840700001)(46966006)(103116003)(36756003)(336012)(4326008)(110136005)(54906003)(70206006)(316002)(86362001)(478600001)(70586007)(82310400005)(40480700001)(5660300002)(30864003)(8936002)(41300700001)(7416002)(8676002)(356005)(186003)(81166007)(2906002)(82740400003)(1076003)(36860700001)(83380400001)(2616005)(426003)(26005)(6666004)(47076005)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 08:50:46.7125
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 53ee1834-9b7d-492c-5bff-08db5133a5ae
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT104.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6587
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The axiethernet driver has in-built dma programming. The aim is to remove
axiethernet axidma programming  after some time and instead use the
dmaengine framework to communicate with existing xilinx DMAengine
controller(xilinx_dma) driver.

Keep the axidma programming code under AXIENET_USE_DMA check so that
dmaengine changes can be added later.

Perform minor code reordering to minimize conditional
AXIENET_USE_DMA checks and there is no functional change.

It uses "dmas" property to identify whether it should use a dmaengine
framework or axiethernet axidma programming.

Signed-off-by: Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
---
Changes in V3:
1) New Patch.
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h  |   2 +
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 317 +++++++++++-------
 2 files changed, 192 insertions(+), 127 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index 575ff9de8985..10917d997d27 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -435,6 +435,7 @@ struct axidma_bd {
  * @coalesce_usec_rx:	IRQ coalesce delay for RX
  * @coalesce_count_tx:	Store the irq coalesce on TX side.
  * @coalesce_usec_tx:	IRQ coalesce delay for TX
+ * @has_dmas:	flag to check dmaengine framework usage.
  */
 struct axienet_local {
 	struct net_device *ndev;
@@ -499,6 +500,7 @@ struct axienet_local {
 	u32 coalesce_usec_rx;
 	u32 coalesce_count_tx;
 	u32 coalesce_usec_tx;
+	u8  has_dmas;
 };
 
 /**
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 3e310b55bce2..8678fc09245a 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -54,6 +54,8 @@
 
 #define AXIENET_REGS_N		40
 
+#define AXIENET_USE_DMA(lp) ((lp)->has_dmas)
+
 /* Match table for of_platform binding */
 static const struct of_device_id axienet_of_match[] = {
 	{ .compatible = "xlnx,axi-ethernet-1.00.a", },
@@ -588,10 +590,6 @@ static int axienet_device_reset(struct net_device *ndev)
 	struct axienet_local *lp = netdev_priv(ndev);
 	int ret;
 
-	ret = __axienet_device_reset(lp);
-	if (ret)
-		return ret;
-
 	lp->max_frm_size = XAE_MAX_VLAN_FRAME_SIZE;
 	lp->options |= XAE_OPTION_VLAN;
 	lp->options &= (~XAE_OPTION_JUMBO);
@@ -605,11 +603,17 @@ static int axienet_device_reset(struct net_device *ndev)
 			lp->options |= XAE_OPTION_JUMBO;
 	}
 
-	ret = axienet_dma_bd_init(ndev);
-	if (ret) {
-		netdev_err(ndev, "%s: descriptor allocation failed\n",
-			   __func__);
-		return ret;
+	if (!AXIENET_USE_DMA(lp)) {
+		ret = __axienet_device_reset(lp);
+		if (ret)
+			return ret;
+
+		ret = axienet_dma_bd_init(ndev);
+		if (ret) {
+			netdev_err(ndev, "%s: descriptor allocation failed\n",
+				   __func__);
+			return ret;
+		}
 	}
 
 	axienet_status = axienet_ior(lp, XAE_RCW1_OFFSET);
@@ -775,7 +779,7 @@ static int axienet_tx_poll(struct napi_struct *napi, int budget)
 }
 
 /**
- * axienet_start_xmit - Starts the transmission.
+ * axienet_start_xmit_legacy - Starts the transmission.
  * @skb:	sk_buff pointer that contains data to be Txed.
  * @ndev:	Pointer to net_device structure.
  *
@@ -788,7 +792,7 @@ static int axienet_tx_poll(struct napi_struct *napi, int budget)
  * it populates AXI Stream Control fields with appropriate values.
  */
 static netdev_tx_t
-axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+axienet_start_xmit_legacy(struct sk_buff *skb, struct net_device *ndev)
 {
 	u32 ii;
 	u32 num_frag;
@@ -890,6 +894,27 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	return NETDEV_TX_OK;
 }
 
+/**
+ * axienet_start_xmit - Starts the transmission.
+ * @skb:        sk_buff pointer that contains data to be Txed.
+ * @ndev:       Pointer to net_device structure.
+ *
+ * Return: NETDEV_TX_OK, on success
+ *          NETDEV_TX_BUSY, if any of the descriptors are not free
+ *
+ * This function is invoked from upper layers to initiate transmission
+ */
+static netdev_tx_t
+axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+{
+	struct axienet_local *lp = netdev_priv(ndev);
+
+	if (!AXIENET_USE_DMA(lp))
+		return axienet_start_xmit_legacy(skb, ndev);
+	else
+		return NETDEV_TX_BUSY;
+}
+
 /**
  * axienet_rx_poll - Triggered by RX ISR to complete the BD processing.
  * @napi:	Pointer to NAPI structure.
@@ -1124,41 +1149,22 @@ static irqreturn_t axienet_eth_irq(int irq, void *_ndev)
 static void axienet_dma_err_handler(struct work_struct *work);
 
 /**
- * axienet_open - Driver open routine.
- * @ndev:	Pointer to net_device structure
+ * axienet_init_legacy_dma - init the dma legacy code.
+ * @ndev:       Pointer to net_device structure
  *
  * Return: 0, on success.
- *	    non-zero error value on failure
+ *          non-zero error value on failure
+ *
+ * This is the dma  initialization code. It also allocates interrupt
+ * service routines, enables the interrupt lines and ISR handling.
  *
- * This is the driver open routine. It calls phylink_start to start the
- * PHY device.
- * It also allocates interrupt service routines, enables the interrupt lines
- * and ISR handling. Axi Ethernet core is reset through Axi DMA core. Buffer
- * descriptors are initialized.
  */
-static int axienet_open(struct net_device *ndev)
+
+static inline int axienet_init_legacy_dma(struct net_device *ndev)
 {
 	int ret;
 	struct axienet_local *lp = netdev_priv(ndev);
 
-	dev_dbg(&ndev->dev, "axienet_open()\n");
-
-	/* When we do an Axi Ethernet reset, it resets the complete core
-	 * including the MDIO. MDIO must be disabled before resetting.
-	 * Hold MDIO bus lock to avoid MDIO accesses during the reset.
-	 */
-	axienet_lock_mii(lp);
-	ret = axienet_device_reset(ndev);
-	axienet_unlock_mii(lp);
-
-	ret = phylink_of_phy_connect(lp->phylink, lp->dev->of_node, 0);
-	if (ret) {
-		dev_err(lp->dev, "phylink_of_phy_connect() failed: %d\n", ret);
-		return ret;
-	}
-
-	phylink_start(lp->phylink);
-
 	/* Enable worker thread for Axi DMA error handling */
 	INIT_WORK(&lp->dma_err_task, axienet_dma_err_handler);
 
@@ -1192,13 +1198,62 @@ static int axienet_open(struct net_device *ndev)
 err_tx_irq:
 	napi_disable(&lp->napi_tx);
 	napi_disable(&lp->napi_rx);
-	phylink_stop(lp->phylink);
-	phylink_disconnect_phy(lp->phylink);
 	cancel_work_sync(&lp->dma_err_task);
 	dev_err(lp->dev, "request_irq() failed\n");
 	return ret;
 }
 
+/**
+ * axienet_open - Driver open routine.
+ * @ndev:	Pointer to net_device structure
+ *
+ * Return: 0, on success.
+ *	    non-zero error value on failure
+ *
+ * This is the driver open routine. It calls phylink_start to start the
+ * PHY device.
+ * It also allocates interrupt service routines, enables the interrupt lines
+ * and ISR handling. Axi Ethernet core is reset through Axi DMA core. Buffer
+ * descriptors are initialized.
+ */
+static int axienet_open(struct net_device *ndev)
+{
+	int ret;
+	struct axienet_local *lp = netdev_priv(ndev);
+
+	dev_dbg(&ndev->dev, "%s\n", __func__);
+
+	/* When we do an Axi Ethernet reset, it resets the complete core
+	 * including the MDIO. MDIO must be disabled before resetting.
+	 * Hold MDIO bus lock to avoid MDIO accesses during the reset.
+	 */
+	axienet_lock_mii(lp);
+	ret = axienet_device_reset(ndev);
+	axienet_unlock_mii(lp);
+
+	ret = phylink_of_phy_connect(lp->phylink, lp->dev->of_node, 0);
+	if (ret) {
+		dev_err(lp->dev, "phylink_of_phy_connect() failed: %d\n", ret);
+		return ret;
+	}
+
+	phylink_start(lp->phylink);
+
+	if (!AXIENET_USE_DMA(lp)) {
+		ret = axienet_init_legacy_dma(ndev);
+		if (ret)
+			goto error_code;
+	}
+
+	return 0;
+
+error_code:
+	phylink_stop(lp->phylink);
+	phylink_disconnect_phy(lp->phylink);
+
+	return ret;
+}
+
 /**
  * axienet_stop - Driver stop routine.
  * @ndev:	Pointer to net_device structure
@@ -1215,8 +1270,10 @@ static int axienet_stop(struct net_device *ndev)
 
 	dev_dbg(&ndev->dev, "axienet_close()\n");
 
-	napi_disable(&lp->napi_tx);
-	napi_disable(&lp->napi_rx);
+	if (!AXIENET_USE_DMA(lp)) {
+		napi_disable(&lp->napi_tx);
+		napi_disable(&lp->napi_rx);
+	}
 
 	phylink_stop(lp->phylink);
 	phylink_disconnect_phy(lp->phylink);
@@ -1224,18 +1281,18 @@ static int axienet_stop(struct net_device *ndev)
 	axienet_setoptions(ndev, lp->options &
 			   ~(XAE_OPTION_TXEN | XAE_OPTION_RXEN));
 
-	axienet_dma_stop(lp);
+	if (!AXIENET_USE_DMA(lp)) {
+		axienet_dma_stop(lp);
+		cancel_work_sync(&lp->dma_err_task);
+		free_irq(lp->tx_irq, ndev);
+		free_irq(lp->rx_irq, ndev);
+		axienet_dma_bd_release(ndev);
+	}
 
 	axienet_iow(lp, XAE_IE_OFFSET, 0);
 
-	cancel_work_sync(&lp->dma_err_task);
-
 	if (lp->eth_irq > 0)
 		free_irq(lp->eth_irq, ndev);
-	free_irq(lp->tx_irq, ndev);
-	free_irq(lp->rx_irq, ndev);
-
-	axienet_dma_bd_release(ndev);
 	return 0;
 }
 
@@ -1411,14 +1468,16 @@ static void axienet_ethtools_get_regs(struct net_device *ndev,
 	data[29] = axienet_ior(lp, XAE_FMI_OFFSET);
 	data[30] = axienet_ior(lp, XAE_AF0_OFFSET);
 	data[31] = axienet_ior(lp, XAE_AF1_OFFSET);
-	data[32] = axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET);
-	data[33] = axienet_dma_in32(lp, XAXIDMA_TX_SR_OFFSET);
-	data[34] = axienet_dma_in32(lp, XAXIDMA_TX_CDESC_OFFSET);
-	data[35] = axienet_dma_in32(lp, XAXIDMA_TX_TDESC_OFFSET);
-	data[36] = axienet_dma_in32(lp, XAXIDMA_RX_CR_OFFSET);
-	data[37] = axienet_dma_in32(lp, XAXIDMA_RX_SR_OFFSET);
-	data[38] = axienet_dma_in32(lp, XAXIDMA_RX_CDESC_OFFSET);
-	data[39] = axienet_dma_in32(lp, XAXIDMA_RX_TDESC_OFFSET);
+	if (!AXIENET_USE_DMA(lp)) {
+		data[32] = axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET);
+		data[33] = axienet_dma_in32(lp, XAXIDMA_TX_SR_OFFSET);
+		data[34] = axienet_dma_in32(lp, XAXIDMA_TX_CDESC_OFFSET);
+		data[35] = axienet_dma_in32(lp, XAXIDMA_TX_TDESC_OFFSET);
+		data[36] = axienet_dma_in32(lp, XAXIDMA_RX_CR_OFFSET);
+		data[37] = axienet_dma_in32(lp, XAXIDMA_RX_SR_OFFSET);
+		data[38] = axienet_dma_in32(lp, XAXIDMA_RX_CDESC_OFFSET);
+		data[39] = axienet_dma_in32(lp, XAXIDMA_RX_TDESC_OFFSET);
+	}
 }
 
 static void
@@ -1878,9 +1937,6 @@ static int axienet_probe(struct platform_device *pdev)
 	u64_stats_init(&lp->rx_stat_sync);
 	u64_stats_init(&lp->tx_stat_sync);
 
-	netif_napi_add(ndev, &lp->napi_rx, axienet_rx_poll);
-	netif_napi_add(ndev, &lp->napi_tx, axienet_tx_poll);
-
 	lp->axi_clk = devm_clk_get_optional(&pdev->dev, "s_axi_lite_clk");
 	if (!lp->axi_clk) {
 		/* For backward compatibility, if named AXI clock is not present,
@@ -2006,75 +2062,80 @@ static int axienet_probe(struct platform_device *pdev)
 		goto cleanup_clk;
 	}
 
-	/* Find the DMA node, map the DMA registers, and decode the DMA IRQs */
-	np = of_parse_phandle(pdev->dev.of_node, "axistream-connected", 0);
-	if (np) {
-		struct resource dmares;
+	if (!of_find_property(pdev->dev.of_node, "dmas", NULL)) {
+		/* Find the DMA node, map the DMA registers, and decode the DMA IRQs */
+		np = of_parse_phandle(pdev->dev.of_node, "axistream-connected", 0);
 
-		ret = of_address_to_resource(np, 0, &dmares);
-		if (ret) {
-			dev_err(&pdev->dev,
-				"unable to get DMA resource\n");
+		if (np) {
+			struct resource dmares;
+
+			ret = of_address_to_resource(np, 0, &dmares);
+			if (ret) {
+				dev_err(&pdev->dev,
+					"unable to get DMA resource\n");
+				of_node_put(np);
+				goto cleanup_clk;
+			}
+			lp->dma_regs = devm_ioremap_resource(&pdev->dev,
+							     &dmares);
+			lp->rx_irq = irq_of_parse_and_map(np, 1);
+			lp->tx_irq = irq_of_parse_and_map(np, 0);
 			of_node_put(np);
+			lp->eth_irq = platform_get_irq_optional(pdev, 0);
+		} else {
+			/* Check for these resources directly on the Ethernet node. */
+			lp->dma_regs = devm_platform_get_and_ioremap_resource(pdev, 1, NULL);
+			lp->rx_irq = platform_get_irq(pdev, 1);
+			lp->tx_irq = platform_get_irq(pdev, 0);
+			lp->eth_irq = platform_get_irq_optional(pdev, 2);
+		}
+		if (IS_ERR(lp->dma_regs)) {
+			dev_err(&pdev->dev, "could not map DMA regs\n");
+			ret = PTR_ERR(lp->dma_regs);
+			goto cleanup_clk;
+		}
+		if (lp->rx_irq <= 0 || lp->tx_irq <= 0) {
+			dev_err(&pdev->dev, "could not determine irqs\n");
+			ret = -ENOMEM;
 			goto cleanup_clk;
 		}
-		lp->dma_regs = devm_ioremap_resource(&pdev->dev,
-						     &dmares);
-		lp->rx_irq = irq_of_parse_and_map(np, 1);
-		lp->tx_irq = irq_of_parse_and_map(np, 0);
-		of_node_put(np);
-		lp->eth_irq = platform_get_irq_optional(pdev, 0);
-	} else {
-		/* Check for these resources directly on the Ethernet node. */
-		lp->dma_regs = devm_platform_get_and_ioremap_resource(pdev, 1, NULL);
-		lp->rx_irq = platform_get_irq(pdev, 1);
-		lp->tx_irq = platform_get_irq(pdev, 0);
-		lp->eth_irq = platform_get_irq_optional(pdev, 2);
-	}
-	if (IS_ERR(lp->dma_regs)) {
-		dev_err(&pdev->dev, "could not map DMA regs\n");
-		ret = PTR_ERR(lp->dma_regs);
-		goto cleanup_clk;
-	}
-	if ((lp->rx_irq <= 0) || (lp->tx_irq <= 0)) {
-		dev_err(&pdev->dev, "could not determine irqs\n");
-		ret = -ENOMEM;
-		goto cleanup_clk;
-	}
 
-	/* Autodetect the need for 64-bit DMA pointers.
-	 * When the IP is configured for a bus width bigger than 32 bits,
-	 * writing the MSB registers is mandatory, even if they are all 0.
-	 * We can detect this case by writing all 1's to one such register
-	 * and see if that sticks: when the IP is configured for 32 bits
-	 * only, those registers are RES0.
-	 * Those MSB registers were introduced in IP v7.1, which we check first.
-	 */
-	if ((axienet_ior(lp, XAE_ID_OFFSET) >> 24) >= 0x9) {
-		void __iomem *desc = lp->dma_regs + XAXIDMA_TX_CDESC_OFFSET + 4;
-
-		iowrite32(0x0, desc);
-		if (ioread32(desc) == 0) {	/* sanity check */
-			iowrite32(0xffffffff, desc);
-			if (ioread32(desc) > 0) {
-				lp->features |= XAE_FEATURE_DMA_64BIT;
-				addr_width = 64;
-				dev_info(&pdev->dev,
-					 "autodetected 64-bit DMA range\n");
-			}
+		/* Autodetect the need for 64-bit DMA pointers.
+		 * When the IP is configured for a bus width bigger than 32 bits,
+		 * writing the MSB registers is mandatory, even if they are all 0.
+		 * We can detect this case by writing all 1's to one such register
+		 * and see if that sticks: when the IP is configured for 32 bits
+		 * only, those registers are RES0.
+		 * Those MSB registers were introduced in IP v7.1, which we check first.
+		 */
+		if ((axienet_ior(lp, XAE_ID_OFFSET) >> 24) >= 0x9) {
+			void __iomem *desc = lp->dma_regs + XAXIDMA_TX_CDESC_OFFSET + 4;
+
 			iowrite32(0x0, desc);
+			if (ioread32(desc) == 0) {	/* sanity check */
+				iowrite32(0xffffffff, desc);
+				if (ioread32(desc) > 0) {
+					lp->features |= XAE_FEATURE_DMA_64BIT;
+					addr_width = 64;
+					dev_info(&pdev->dev,
+						 "autodetected 64-bit DMA range\n");
+				}
+				iowrite32(0x0, desc);
+			}
+		}
+		if (!IS_ENABLED(CONFIG_64BIT) && lp->features & XAE_FEATURE_DMA_64BIT) {
+			dev_err(&pdev->dev, "64-bit addressable DMA is not compatible with 32-bit archecture\n");
+			ret = -EINVAL;
+			goto cleanup_clk;
 		}
-	}
-	if (!IS_ENABLED(CONFIG_64BIT) && lp->features & XAE_FEATURE_DMA_64BIT) {
-		dev_err(&pdev->dev, "64-bit addressable DMA is not compatible with 32-bit archecture\n");
-		ret = -EINVAL;
-		goto cleanup_clk;
-	}
 
-	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(addr_width));
-	if (ret) {
-		dev_err(&pdev->dev, "No suitable DMA available\n");
-		goto cleanup_clk;
+		ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(addr_width));
+		if (ret) {
+			dev_err(&pdev->dev, "No suitable DMA available\n");
+			goto cleanup_clk;
+		}
+		netif_napi_add(ndev, &lp->napi_rx, axienet_rx_poll);
+		netif_napi_add(ndev, &lp->napi_tx, axienet_tx_poll);
 	}
 
 	/* Check for Ethernet core IRQ (optional) */
@@ -2092,14 +2153,16 @@ static int axienet_probe(struct platform_device *pdev)
 	}
 
 	lp->coalesce_count_rx = XAXIDMA_DFT_RX_THRESHOLD;
-	lp->coalesce_usec_rx = XAXIDMA_DFT_RX_USEC;
 	lp->coalesce_count_tx = XAXIDMA_DFT_TX_THRESHOLD;
-	lp->coalesce_usec_tx = XAXIDMA_DFT_TX_USEC;
 
-	/* Reset core now that clocks are enabled, prior to accessing MDIO */
-	ret = __axienet_device_reset(lp);
-	if (ret)
-		goto cleanup_clk;
+	if (!AXIENET_USE_DMA(lp)) {
+		lp->coalesce_usec_rx = XAXIDMA_DFT_RX_USEC;
+		lp->coalesce_usec_tx = XAXIDMA_DFT_TX_USEC;
+		/* Reset core now that clocks are enabled, prior to accessing MDIO */
+		ret = __axienet_device_reset(lp);
+		if (ret)
+			goto cleanup_clk;
+	}
 
 	ret = axienet_mdio_setup(lp);
 	if (ret)
-- 
2.25.1


