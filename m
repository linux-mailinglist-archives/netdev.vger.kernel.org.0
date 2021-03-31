Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A928734FB76
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 10:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232623AbhCaIVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 04:21:42 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15117 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234381AbhCaIVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 04:21:17 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F9K3L242Lz1BFw8;
        Wed, 31 Mar 2021 16:19:10 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Wed, 31 Mar 2021 16:21:05 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>,
        Yixing Liu <liuyixing1@huawei.com>,
        Weihang Li <liweihang@huawei.com>
Subject: [PATCH net-next 3/7] net: amd8111e: fix inappropriate spaces
Date:   Wed, 31 Mar 2021 16:18:30 +0800
Message-ID: <1617178714-14031-4-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1617178714-14031-1-git-send-email-liweihang@huawei.com>
References: <1617178714-14031-1-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yixing Liu <liuyixing1@huawei.com>

Delete unncecessary spaces and add some reasonable spaces according to the
coding-style of kernel.

Signed-off-by: Yixing Liu <liuyixing1@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/net/ethernet/amd/amd8111e.c | 362 ++++++++++++++++++------------------
 1 file changed, 177 insertions(+), 185 deletions(-)

diff --git a/drivers/net/ethernet/amd/amd8111e.c b/drivers/net/ethernet/amd/amd8111e.c
index 960d483..4a1220c 100644
--- a/drivers/net/ethernet/amd/amd8111e.c
+++ b/drivers/net/ethernet/amd/amd8111e.c
@@ -100,19 +100,19 @@ static int amd8111e_read_phy(struct amd8111e_priv *lp,
 {
 	void __iomem *mmio = lp->mmio;
 	unsigned int reg_val;
-	unsigned int repeat= REPEAT_CNT;
+	unsigned int repeat = REPEAT_CNT;
 
 	reg_val = readl(mmio + PHY_ACCESS);
 	while (reg_val & PHY_CMD_ACTIVE)
-		reg_val = readl( mmio + PHY_ACCESS );
+		reg_val = readl(mmio + PHY_ACCESS);
 
-	writel( PHY_RD_CMD | ((phy_id & 0x1f) << 21) |
-			   ((reg & 0x1f) << 16),  mmio +PHY_ACCESS);
-	do{
+	writel(PHY_RD_CMD | ((phy_id & 0x1f) << 21) |
+			   ((reg & 0x1f) << 16), mmio + PHY_ACCESS);
+	do {
 		reg_val = readl(mmio + PHY_ACCESS);
 		udelay(30);  /* It takes 30 us to read/write data */
 	} while (--repeat && (reg_val & PHY_CMD_ACTIVE));
-	if(reg_val & PHY_RD_ERR)
+	if (reg_val & PHY_RD_ERR)
 		goto err_phy_read;
 
 	*val = reg_val & 0xffff;
@@ -133,17 +133,17 @@ static int amd8111e_write_phy(struct amd8111e_priv *lp,
 
 	reg_val = readl(mmio + PHY_ACCESS);
 	while (reg_val & PHY_CMD_ACTIVE)
-		reg_val = readl( mmio + PHY_ACCESS );
+		reg_val = readl(mmio + PHY_ACCESS);
 
-	writel( PHY_WR_CMD | ((phy_id & 0x1f) << 21) |
+	writel(PHY_WR_CMD | ((phy_id & 0x1f) << 21) |
 			   ((reg & 0x1f) << 16)|val, mmio + PHY_ACCESS);
 
-	do{
+	do {
 		reg_val = readl(mmio + PHY_ACCESS);
 		udelay(30);  /* It takes 30 us to read/write the data */
 	} while (--repeat && (reg_val & PHY_CMD_ACTIVE));
 
-	if(reg_val & PHY_RD_ERR)
+	if (reg_val & PHY_RD_ERR)
 		goto err_phy_write;
 
 	return 0;
@@ -159,7 +159,7 @@ static int amd8111e_mdio_read(struct net_device *dev, int phy_id, int reg_num)
 	struct amd8111e_priv *lp = netdev_priv(dev);
 	unsigned int reg_val;
 
-	amd8111e_read_phy(lp,phy_id,reg_num,&reg_val);
+	amd8111e_read_phy(lp, phy_id, reg_num, &reg_val);
 	return reg_val;
 
 }
@@ -179,17 +179,17 @@ static void amd8111e_mdio_write(struct net_device *dev,
 static void amd8111e_set_ext_phy(struct net_device *dev)
 {
 	struct amd8111e_priv *lp = netdev_priv(dev);
-	u32 bmcr,advert,tmp;
+	u32 bmcr, advert, tmp;
 
 	/* Determine mii register values to set the speed */
 	advert = amd8111e_mdio_read(dev, lp->ext_phy_addr, MII_ADVERTISE);
 	tmp = advert & ~(ADVERTISE_ALL | ADVERTISE_100BASE4);
-	switch (lp->ext_phy_option){
+	switch (lp->ext_phy_option) {
 
 		default:
 		case SPEED_AUTONEG: /* advertise all values */
-			tmp |= ( ADVERTISE_10HALF|ADVERTISE_10FULL|
-				ADVERTISE_100HALF|ADVERTISE_100FULL) ;
+			tmp |= (ADVERTISE_10HALF | ADVERTISE_10FULL |
+				ADVERTISE_100HALF | ADVERTISE_100FULL);
 			break;
 		case SPEED10_HALF:
 			tmp |= ADVERTISE_10HALF;
@@ -224,20 +224,20 @@ static int amd8111e_free_skbs(struct net_device *dev)
 	int i;
 
 	/* Freeing transmit skbs */
-	for(i = 0; i < NUM_TX_BUFFERS; i++){
-		if(lp->tx_skbuff[i]){
+	for (i = 0; i < NUM_TX_BUFFERS; i++) {
+		if (lp->tx_skbuff[i]) {
 			dma_unmap_single(&lp->pci_dev->dev,
 					 lp->tx_dma_addr[i],
 					 lp->tx_skbuff[i]->len, DMA_TO_DEVICE);
-			dev_kfree_skb (lp->tx_skbuff[i]);
+			dev_kfree_skb(lp->tx_skbuff[i]);
 			lp->tx_skbuff[i] = NULL;
 			lp->tx_dma_addr[i] = 0;
 		}
 	}
 	/* Freeing previously allocated receive buffers */
-	for (i = 0; i < NUM_RX_BUFFERS; i++){
+	for (i = 0; i < NUM_RX_BUFFERS; i++) {
 		rx_skbuff = lp->rx_skbuff[i];
-		if(rx_skbuff != NULL){
+		if (rx_skbuff != NULL) {
 			dma_unmap_single(&lp->pci_dev->dev,
 					 lp->rx_dma_addr[i],
 					 lp->rx_buff_len - 2, DMA_FROM_DEVICE);
@@ -258,13 +258,13 @@ static inline void amd8111e_set_rx_buff_len(struct net_device *dev)
 	struct amd8111e_priv *lp = netdev_priv(dev);
 	unsigned int mtu = dev->mtu;
 
-	if (mtu > ETH_DATA_LEN){
+	if (mtu > ETH_DATA_LEN) {
 		/* MTU + ethernet header + FCS
 		 * + optional VLAN tag + skb reserve space 2
 		 */
 		lp->rx_buff_len = mtu + ETH_HLEN + 10;
 		lp->options |= OPTION_JUMBO_ENABLE;
-	} else{
+	} else {
 		lp->rx_buff_len = PKT_BUFF_SZ;
 		lp->options &= ~OPTION_JUMBO_ENABLE;
 	}
@@ -285,11 +285,11 @@ static int amd8111e_init_ring(struct net_device *dev)
 	lp->tx_ring_idx = 0;
 
 
-	if(lp->opened)
+	if (lp->opened)
 		/* Free previously allocated transmit and receive skbs */
 		amd8111e_free_skbs(dev);
 
-	else{
+	else {
 		/* allocate the tx and rx descriptors */
 		lp->tx_ring = dma_alloc_coherent(&lp->pci_dev->dev,
 			sizeof(struct amd8111e_tx_dr) * NUM_TX_RING_DR,
@@ -312,12 +312,12 @@ static int amd8111e_init_ring(struct net_device *dev)
 
 		lp->rx_skbuff[i] = netdev_alloc_skb(dev, lp->rx_buff_len);
 		if (!lp->rx_skbuff[i]) {
-				/* Release previos allocated skbs */
-				for(--i; i >= 0 ;i--)
-					dev_kfree_skb(lp->rx_skbuff[i]);
-				goto err_free_rx_ring;
+			/* Release previos allocated skbs */
+			for (--i; i >= 0; i--)
+				dev_kfree_skb(lp->rx_skbuff[i]);
+			goto err_free_rx_ring;
 		}
-		skb_reserve(lp->rx_skbuff[i],2);
+		skb_reserve(lp->rx_skbuff[i], 2);
 	}
         /* Initilaizing receive descriptors */
 	for (i = 0; i < NUM_RX_BUFFERS; i++) {
@@ -375,40 +375,40 @@ static int amd8111e_set_coalesce(struct net_device *dev, enum coal_mode cmod)
 		case RX_INTR_COAL :
 			timeout = coal_conf->rx_timeout;
 			event_count = coal_conf->rx_event_count;
-			if( timeout > MAX_TIMEOUT ||
-					event_count > MAX_EVENT_COUNT )
+			if (timeout > MAX_TIMEOUT ||
+			    event_count > MAX_EVENT_COUNT)
 				return -EINVAL;
 
 			timeout = timeout * DELAY_TIMER_CONV;
 			writel(VAL0|STINTEN, mmio+INTEN0);
-			writel((u32)DLY_INT_A_R0|( event_count<< 16 )|timeout,
-							mmio+DLY_INT_A);
+			writel((u32)DLY_INT_A_R0 | (event_count << 16) |
+				timeout, mmio + DLY_INT_A);
 			break;
 
-		case TX_INTR_COAL :
+		case TX_INTR_COAL:
 			timeout = coal_conf->tx_timeout;
 			event_count = coal_conf->tx_event_count;
-			if( timeout > MAX_TIMEOUT ||
-					event_count > MAX_EVENT_COUNT )
+			if (timeout > MAX_TIMEOUT ||
+			    event_count > MAX_EVENT_COUNT)
 				return -EINVAL;
 
 
 			timeout = timeout * DELAY_TIMER_CONV;
-			writel(VAL0|STINTEN,mmio+INTEN0);
-			writel((u32)DLY_INT_B_T0|( event_count<< 16 )|timeout,
-							 mmio+DLY_INT_B);
+			writel(VAL0 | STINTEN, mmio + INTEN0);
+			writel((u32)DLY_INT_B_T0 | (event_count << 16) |
+				timeout, mmio + DLY_INT_B);
 			break;
 
 		case DISABLE_COAL:
-			writel(0,mmio+STVAL);
-			writel(STINTEN, mmio+INTEN0);
-			writel(0, mmio +DLY_INT_B);
-			writel(0, mmio+DLY_INT_A);
+			writel(0, mmio + STVAL);
+			writel(STINTEN, mmio + INTEN0);
+			writel(0, mmio + DLY_INT_B);
+			writel(0, mmio + DLY_INT_A);
 			break;
 		 case ENABLE_COAL:
 		       /* Start the timer */
-			writel((u32)SOFT_TIMER_FREQ, mmio+STVAL); /*  0.5 sec */
-			writel(VAL0|STINTEN, mmio+INTEN0);
+			writel((u32)SOFT_TIMER_FREQ, mmio + STVAL); /* 0.5 sec */
+			writel(VAL0 | STINTEN, mmio + INTEN0);
 			break;
 		default:
 			break;
@@ -423,67 +423,67 @@ static int amd8111e_restart(struct net_device *dev)
 {
 	struct amd8111e_priv *lp = netdev_priv(dev);
 	void __iomem *mmio = lp->mmio;
-	int i,reg_val;
+	int i, reg_val;
 
 	/* stop the chip */
 	writel(RUN, mmio + CMD0);
 
-	if(amd8111e_init_ring(dev))
+	if (amd8111e_init_ring(dev))
 		return -ENOMEM;
 
 	/* enable the port manager and set auto negotiation always */
-	writel((u32) VAL1|EN_PMGR, mmio + CMD3 );
-	writel((u32)XPHYANE|XPHYRST , mmio + CTRL2);
+	writel((u32)VAL1 | EN_PMGR, mmio + CMD3);
+	writel((u32)XPHYANE | XPHYRST, mmio + CTRL2);
 
 	amd8111e_set_ext_phy(dev);
 
 	/* set control registers */
 	reg_val = readl(mmio + CTRL1);
 	reg_val &= ~XMTSP_MASK;
-	writel( reg_val| XMTSP_128 | CACHE_ALIGN, mmio + CTRL1 );
+	writel(reg_val | XMTSP_128 | CACHE_ALIGN, mmio + CTRL1);
 
 	/* enable interrupt */
-	writel( APINT5EN | APINT4EN | APINT3EN | APINT2EN | APINT1EN |
+	writel(APINT5EN | APINT4EN | APINT3EN | APINT2EN | APINT1EN |
 		APINT0EN | MIIPDTINTEN | MCCIINTEN | MCCINTEN | MREINTEN |
 		SPNDINTEN | MPINTEN | SINTEN | STINTEN, mmio + INTEN0);
 
 	writel(VAL3 | LCINTEN | VAL1 | TINTEN0 | VAL0 | RINTEN0, mmio + INTEN0);
 
 	/* initialize tx and rx ring base addresses */
-	writel((u32)lp->tx_ring_dma_addr,mmio + XMT_RING_BASE_ADDR0);
-	writel((u32)lp->rx_ring_dma_addr,mmio+ RCV_RING_BASE_ADDR0);
+	writel((u32)lp->tx_ring_dma_addr, mmio + XMT_RING_BASE_ADDR0);
+	writel((u32)lp->rx_ring_dma_addr, mmio + RCV_RING_BASE_ADDR0);
 
 	writew((u32)NUM_TX_RING_DR, mmio + XMT_RING_LEN0);
 	writew((u16)NUM_RX_RING_DR, mmio + RCV_RING_LEN0);
 
 	/* set default IPG to 96 */
-	writew((u32)DEFAULT_IPG,mmio+IPG);
+	writew((u32)DEFAULT_IPG, mmio + IPG);
 	writew((u32)(DEFAULT_IPG-IFS1_DELTA), mmio + IFS1);
 
-	if(lp->options & OPTION_JUMBO_ENABLE){
+	if (lp->options & OPTION_JUMBO_ENABLE) {
 		writel((u32)VAL2|JUMBO, mmio + CMD3);
 		/* Reset REX_UFLO */
-		writel( REX_UFLO, mmio + CMD2);
+		writel(REX_UFLO, mmio + CMD2);
 		/* Should not set REX_UFLO for jumbo frames */
-		writel( VAL0 | APAD_XMT|REX_RTRY , mmio + CMD2);
-	}else{
-		writel( VAL0 | APAD_XMT | REX_RTRY|REX_UFLO, mmio + CMD2);
+		writel(VAL0 | APAD_XMT | REX_RTRY, mmio + CMD2);
+	} else {
+		writel(VAL0 | APAD_XMT | REX_RTRY | REX_UFLO, mmio + CMD2);
 		writel((u32)JUMBO, mmio + CMD3);
 	}
 
 #if AMD8111E_VLAN_TAG_USED
-	writel((u32) VAL2|VSIZE|VL_TAG_DEL, mmio + CMD3);
+	writel((u32)VAL2 | VSIZE | VL_TAG_DEL, mmio + CMD3);
 #endif
-	writel( VAL0 | APAD_XMT | REX_RTRY, mmio + CMD2 );
+	writel(VAL0 | APAD_XMT | REX_RTRY, mmio + CMD2);
 
 	/* Setting the MAC address to the device */
 	for (i = 0; i < ETH_ALEN; i++)
-		writeb( dev->dev_addr[i], mmio + PADR + i );
+		writeb(dev->dev_addr[i], mmio + PADR + i);
 
 	/* Enable interrupt coalesce */
-	if(lp->options & OPTION_INTR_COAL_ENABLE){
+	if (lp->options & OPTION_INTR_COAL_ENABLE) {
 		netdev_info(dev, "Interrupt Coalescing Enabled.\n");
-		amd8111e_set_coalesce(dev,ENABLE_COAL);
+		amd8111e_set_coalesce(dev, ENABLE_COAL);
 	}
 
 	/* set RUN bit to start the chip */
@@ -499,11 +499,11 @@ static int amd8111e_restart(struct net_device *dev)
 static void amd8111e_init_hw_default(struct amd8111e_priv *lp)
 {
 	unsigned int reg_val;
-	unsigned int logic_filter[2] ={0,};
+	unsigned int logic_filter[2] = {0,};
 	void __iomem *mmio = lp->mmio;
 
 
-        /* stop the chip */
+	/* stop the chip */
 	writel(RUN, mmio + CMD0);
 
 	/* AUTOPOLL0 Register *//*TBD default value is 8100 in FPS */
@@ -519,13 +519,13 @@ static void amd8111e_init_hw_default(struct amd8111e_priv *lp)
 	writel(0, mmio + XMT_RING_BASE_ADDR3);
 
 	/* Clear CMD0  */
-	writel(CMD0_CLEAR,mmio + CMD0);
+	writel(CMD0_CLEAR, mmio + CMD0);
 
 	/* Clear CMD2 */
-	writel(CMD2_CLEAR, mmio +CMD2);
+	writel(CMD2_CLEAR, mmio + CMD2);
 
 	/* Clear CMD7 */
-	writel(CMD7_CLEAR , mmio + CMD7);
+	writel(CMD7_CLEAR, mmio + CMD7);
 
 	/* Clear DLY_INT_A and DLY_INT_B */
 	writel(0x0, mmio + DLY_INT_A);
@@ -542,16 +542,16 @@ static void amd8111e_init_hw_default(struct amd8111e_priv *lp)
 	writel(0x0, mmio + STVAL);
 
 	/* Clear INTEN0 */
-	writel( INTEN0_CLEAR, mmio + INTEN0);
+	writel(INTEN0_CLEAR, mmio + INTEN0);
 
 	/* Clear LADRF */
-	writel(0x0 , mmio + LADRF);
+	writel(0x0, mmio + LADRF);
 
 	/* Set SRAM_SIZE & SRAM_BOUNDARY registers  */
-	writel( 0x80010,mmio + SRAM_SIZE);
+	writel(0x80010, mmio + SRAM_SIZE);
 
 	/* Clear RCV_RING0_LEN */
-	writel(0x0, mmio +  RCV_RING_LEN0);
+	writel(0x0, mmio + RCV_RING_LEN0);
 
 	/* Clear XMT_RING0/1/2/3_LEN */
 	writel(0x0, mmio +  XMT_RING_LEN0);
@@ -571,10 +571,10 @@ static void amd8111e_init_hw_default(struct amd8111e_priv *lp)
 	/* SRAM_SIZE register */
 	reg_val = readl(mmio + SRAM_SIZE);
 
-	if(lp->options & OPTION_JUMBO_ENABLE)
-		writel( VAL2|JUMBO, mmio + CMD3);
+	if (lp->options & OPTION_JUMBO_ENABLE)
+		writel(VAL2 | JUMBO, mmio + CMD3);
 #if AMD8111E_VLAN_TAG_USED
-	writel(VAL2|VSIZE|VL_TAG_DEL, mmio + CMD3 );
+	writel(VAL2 | VSIZE | VL_TAG_DEL, mmio + CMD3);
 #endif
 	/* Set default value to CTRL1 Register */
 	writel(CTRL1_DEFAULT, mmio + CTRL1);
@@ -616,14 +616,14 @@ static void amd8111e_stop_chip(struct amd8111e_priv *lp)
 static void amd8111e_free_ring(struct amd8111e_priv *lp)
 {
 	/* Free transmit and receive descriptor rings */
-	if(lp->rx_ring){
+	if (lp->rx_ring) {
 		dma_free_coherent(&lp->pci_dev->dev,
 				  sizeof(struct amd8111e_rx_dr) * NUM_RX_RING_DR,
 				  lp->rx_ring, lp->rx_ring_dma_addr);
 		lp->rx_ring = NULL;
 	}
 
-	if(lp->tx_ring){
+	if (lp->tx_ring) {
 		dma_free_coherent(&lp->pci_dev->dev,
 				  sizeof(struct amd8111e_tx_dr) * NUM_TX_RING_DR,
 				  lp->tx_ring, lp->tx_ring_dma_addr);
@@ -643,11 +643,11 @@ static int amd8111e_tx(struct net_device *dev)
 	int tx_index;
 	int status;
 	/* Complete all the transmit packet */
-	while (lp->tx_complete_idx != lp->tx_idx){
+	while (lp->tx_complete_idx != lp->tx_idx) {
 		tx_index =  lp->tx_complete_idx & TX_RING_DR_MOD_MASK;
 		status = le16_to_cpu(lp->tx_ring[tx_index].tx_flags);
 
-		if(status & OWN_BIT)
+		if (status & OWN_BIT)
 			break;	/* It still hasn't been Txed */
 
 		lp->tx_ring[tx_index].buff_phy_addr = 0;
@@ -669,10 +669,10 @@ static int amd8111e_tx(struct net_device *dev)
 			le16_to_cpu(lp->tx_ring[tx_index].buff_count);
 
 		if (netif_queue_stopped(dev) &&
-			lp->tx_complete_idx > lp->tx_idx - NUM_TX_BUFFERS +2){
+			lp->tx_complete_idx > lp->tx_idx - NUM_TX_BUFFERS + 2) {
 			/* The ring is no longer full, clear tbusy. */
 			/* lp->tx_full = 0; */
-			netif_wake_queue (dev);
+			netif_wake_queue(dev);
 		}
 	}
 	return 0;
@@ -685,7 +685,7 @@ static int amd8111e_rx_poll(struct napi_struct *napi, int budget)
 	struct net_device *dev = lp->amd8111e_net_dev;
 	int rx_index = lp->rx_idx & RX_RING_DR_MOD_MASK;
 	void __iomem *mmio = lp->mmio;
-	struct sk_buff *skb,*new_skb;
+	struct sk_buff *skb, *new_skb;
 	int min_pkt_len, status;
 	int num_rx_pkt = 0;
 	short pkt_len;
@@ -710,7 +710,7 @@ static int amd8111e_rx_poll(struct napi_struct *napi, int budget)
 			goto err_next_pkt;
 		}
 		/* check for STP and ENP */
-		if (!((status & STP_BIT) && (status & ENP_BIT))){
+		if (!((status & STP_BIT) && (status & ENP_BIT))) {
 			/* resetting flags */
 			lp->rx_ring[rx_index].rx_flags &= RESET_RX_FLAGS;
 			goto err_next_pkt;
@@ -755,7 +755,7 @@ static int amd8111e_rx_poll(struct napi_struct *napi, int budget)
 		skb->protocol = eth_type_trans(skb, dev);
 
 #if AMD8111E_VLAN_TAG_USED
-		if (vtag == TT_VLAN_TAGGED){
+		if (vtag == TT_VLAN_TAGGED) {
 			u16 vlan_tag = le16_to_cpu(lp->rx_ring[rx_index].tag_ctrl_info);
 			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vlan_tag);
 		}
@@ -793,25 +793,25 @@ static int amd8111e_rx_poll(struct napi_struct *napi, int budget)
 static int amd8111e_link_change(struct net_device *dev)
 {
 	struct amd8111e_priv *lp = netdev_priv(dev);
-	int status0,speed;
+	int status0, speed;
 
 	/* read the link change */
-     	status0 = readl(lp->mmio + STAT0);
+	status0 = readl(lp->mmio + STAT0);
 
-	if(status0 & LINK_STATS){
-		if(status0 & AUTONEG_COMPLETE)
+	if (status0 & LINK_STATS) {
+		if (status0 & AUTONEG_COMPLETE)
 			lp->link_config.autoneg = AUTONEG_ENABLE;
 		else
 			lp->link_config.autoneg = AUTONEG_DISABLE;
 
-		if(status0 & FULL_DPLX)
+		if (status0 & FULL_DPLX)
 			lp->link_config.duplex = DUPLEX_FULL;
 		else
 			lp->link_config.duplex = DUPLEX_HALF;
 		speed = (status0 & SPEED_MASK) >> 7;
-		if(speed == PHY_SPEED_10)
+		if (speed == PHY_SPEED_10)
 			lp->link_config.speed = SPEED_10;
-		else if(speed == PHY_SPEED_100)
+		else if (speed == PHY_SPEED_100)
 			lp->link_config.speed = SPEED_100;
 
 		netdev_info(dev, "Link is Up. Speed is %s Mbps %s Duplex\n",
@@ -821,8 +821,7 @@ static int amd8111e_link_change(struct net_device *dev)
 							"Full" : "Half");
 
 		netif_carrier_on(dev);
-	}
-	else{
+	} else {
 		lp->link_config.speed = SPEED_INVALID;
 		lp->link_config.duplex = DUPLEX_INVALID;
 		lp->link_config.autoneg = AUTONEG_INVALID;
@@ -840,7 +839,7 @@ static int amd8111e_read_mib(void __iomem *mmio, u8 MIB_COUNTER)
 	unsigned  int data;
 	unsigned int repeat = REPEAT_CNT;
 
-	writew( MIB_RD_CMD | MIB_COUNTER, mmio + MIB_ADDR);
+	writew(MIB_RD_CMD | MIB_COUNTER, mmio + MIB_ADDR);
 	do {
 		status = readw(mmio + MIB_ADDR);
 		udelay(2);	/* controller takes MAX 2 us to get mib data */
@@ -863,7 +862,7 @@ static struct net_device_stats *amd8111e_get_stats(struct net_device *dev)
 
 	if (!lp->opened)
 		return new_stats;
-	spin_lock_irqsave (&lp->lock, flags);
+	spin_lock_irqsave(&lp->lock, flags);
 
 	/* stats.rx_packets */
 	new_stats->rx_packets = amd8111e_read_mib(mmio, rcv_broadcast_pkts)+
@@ -943,7 +942,7 @@ static struct net_device_stats *amd8111e_get_stats(struct net_device *dev)
 	/* Reset the mibs for collecting new statistics */
 	/* writew(MIB_CLEAR, mmio + MIB_ADDR);*/
 
-	spin_unlock_irqrestore (&lp->lock, flags);
+	spin_unlock_irqrestore(&lp->lock, flags);
 
 	return new_stats;
 }
@@ -974,96 +973,90 @@ static int amd8111e_calc_coalesce(struct net_device *dev)
 	rx_data_rate = coal_conf->rx_bytes - coal_conf->rx_prev_bytes;
 	coal_conf->rx_prev_bytes =  coal_conf->rx_bytes;
 
-	if(rx_pkt_rate < 800){
-		if(coal_conf->rx_coal_type != NO_COALESCE){
+	if (rx_pkt_rate < 800) {
+		if (coal_conf->rx_coal_type != NO_COALESCE) {
 
 			coal_conf->rx_timeout = 0x0;
 			coal_conf->rx_event_count = 0;
-			amd8111e_set_coalesce(dev,RX_INTR_COAL);
+			amd8111e_set_coalesce(dev, RX_INTR_COAL);
 			coal_conf->rx_coal_type = NO_COALESCE;
 		}
-	}
-	else{
+	} else {
 
 		rx_pkt_size = rx_data_rate/rx_pkt_rate;
-		if (rx_pkt_size < 128){
-			if(coal_conf->rx_coal_type != NO_COALESCE){
+		if (rx_pkt_size < 128) {
+			if (coal_conf->rx_coal_type != NO_COALESCE) {
 
 				coal_conf->rx_timeout = 0;
 				coal_conf->rx_event_count = 0;
-				amd8111e_set_coalesce(dev,RX_INTR_COAL);
+				amd8111e_set_coalesce(dev, RX_INTR_COAL);
 				coal_conf->rx_coal_type = NO_COALESCE;
 			}
 
-		}
-		else if ( (rx_pkt_size >= 128) && (rx_pkt_size < 512) ){
+		} else if ((rx_pkt_size >= 128) && (rx_pkt_size < 512)) {
 
-			if(coal_conf->rx_coal_type !=  LOW_COALESCE){
+			if (coal_conf->rx_coal_type !=  LOW_COALESCE) {
 				coal_conf->rx_timeout = 1;
 				coal_conf->rx_event_count = 4;
-				amd8111e_set_coalesce(dev,RX_INTR_COAL);
+				amd8111e_set_coalesce(dev, RX_INTR_COAL);
 				coal_conf->rx_coal_type = LOW_COALESCE;
 			}
-		}
-		else if ((rx_pkt_size >= 512) && (rx_pkt_size < 1024)){
+		} else if ((rx_pkt_size >= 512) && (rx_pkt_size < 1024)) {
 
-			if(coal_conf->rx_coal_type !=  MEDIUM_COALESCE){
+			if (coal_conf->rx_coal_type != MEDIUM_COALESCE) {
 				coal_conf->rx_timeout = 1;
 				coal_conf->rx_event_count = 4;
-				amd8111e_set_coalesce(dev,RX_INTR_COAL);
+				amd8111e_set_coalesce(dev, RX_INTR_COAL);
 				coal_conf->rx_coal_type = MEDIUM_COALESCE;
 			}
 
-		}
-		else if(rx_pkt_size >= 1024){
-			if(coal_conf->rx_coal_type !=  HIGH_COALESCE){
+		} else if (rx_pkt_size >= 1024) {
+
+			if (coal_conf->rx_coal_type !=  HIGH_COALESCE) {
 				coal_conf->rx_timeout = 2;
 				coal_conf->rx_event_count = 3;
-				amd8111e_set_coalesce(dev,RX_INTR_COAL);
+				amd8111e_set_coalesce(dev, RX_INTR_COAL);
 				coal_conf->rx_coal_type = HIGH_COALESCE;
 			}
 		}
 	}
-    	/* NOW FOR TX INTR COALESC */
-	if(tx_pkt_rate < 800){
-		if(coal_conf->tx_coal_type != NO_COALESCE){
+	/* NOW FOR TX INTR COALESC */
+	if (tx_pkt_rate < 800) {
+		if (coal_conf->tx_coal_type != NO_COALESCE) {
 
 			coal_conf->tx_timeout = 0x0;
 			coal_conf->tx_event_count = 0;
-			amd8111e_set_coalesce(dev,TX_INTR_COAL);
+			amd8111e_set_coalesce(dev, TX_INTR_COAL);
 			coal_conf->tx_coal_type = NO_COALESCE;
 		}
-	}
-	else{
+	} else {
 
 		tx_pkt_size = tx_data_rate/tx_pkt_rate;
-		if (tx_pkt_size < 128){
+		if (tx_pkt_size < 128) {
 
-			if(coal_conf->tx_coal_type != NO_COALESCE){
+			if (coal_conf->tx_coal_type != NO_COALESCE) {
 
 				coal_conf->tx_timeout = 0;
 				coal_conf->tx_event_count = 0;
-				amd8111e_set_coalesce(dev,TX_INTR_COAL);
+				amd8111e_set_coalesce(dev, TX_INTR_COAL);
 				coal_conf->tx_coal_type = NO_COALESCE;
 			}
 
-		}
-		else if ( (tx_pkt_size >= 128) && (tx_pkt_size < 512) ){
+		} else if ((tx_pkt_size >= 128) && (tx_pkt_size < 512)) {
 
-			if(coal_conf->tx_coal_type !=  LOW_COALESCE){
+			if (coal_conf->tx_coal_type != LOW_COALESCE) {
 				coal_conf->tx_timeout = 1;
 				coal_conf->tx_event_count = 2;
-				amd8111e_set_coalesce(dev,TX_INTR_COAL);
+				amd8111e_set_coalesce(dev, TX_INTR_COAL);
 				coal_conf->tx_coal_type = LOW_COALESCE;
 
 			}
-		}
-		else if ((tx_pkt_size >= 512) && (tx_pkt_size < 1024)){
+		} else if ((tx_pkt_size >= 512) && (tx_pkt_size < 1024)) {
 
-			if(coal_conf->tx_coal_type !=  MEDIUM_COALESCE){
+			if (coal_conf->tx_coal_type != MEDIUM_COALESCE) {
 				coal_conf->tx_timeout = 2;
 				coal_conf->tx_event_count = 5;
-				amd8111e_set_coalesce(dev,TX_INTR_COAL);
+				amd8111e_set_coalesce(dev, TX_INTR_COAL);
 				coal_conf->tx_coal_type = MEDIUM_COALESCE;
 			}
 		} else if (tx_pkt_size >= 1024) {
@@ -1091,7 +1084,7 @@ static irqreturn_t amd8111e_interrupt(int irq, void *dev_id)
 	unsigned int intr0, intren0;
 	unsigned int handled = 1;
 
-	if(unlikely(dev == NULL))
+	if (unlikely(dev == NULL))
 		return IRQ_NONE;
 
 	spin_lock(&lp->lock);
@@ -1105,7 +1098,7 @@ static irqreturn_t amd8111e_interrupt(int irq, void *dev_id)
 
 	/* Process all the INT event until INTR bit is clear. */
 
-	if (!(intr0 & INTR)){
+	if (!(intr0 & INTR)) {
 		handled = 0;
 		goto err_no_interrupt;
 	}
@@ -1140,7 +1133,7 @@ static irqreturn_t amd8111e_interrupt(int irq, void *dev_id)
 		amd8111e_calc_coalesce(dev);
 
 err_no_interrupt:
-	writel( VAL0 | INTREN,mmio + CMD0);
+	writel(VAL0 | INTREN, mmio + CMD0);
 
 	spin_unlock(&lp->lock);
 
@@ -1180,7 +1173,7 @@ static int amd8111e_close(struct net_device *dev)
 	netif_carrier_off(lp->amd8111e_net_dev);
 
 	/* Delete ipg timer */
-	if(lp->options & OPTION_DYN_IPG_ENABLE)
+	if (lp->options & OPTION_DYN_IPG_ENABLE)
 		del_timer_sync(&lp->ipg_data.ipg_timer);
 
 	spin_unlock_irq(&lp->lock);
@@ -1200,8 +1193,8 @@ static int amd8111e_open(struct net_device *dev)
 {
 	struct amd8111e_priv *lp = netdev_priv(dev);
 
-	if(dev->irq ==0 || request_irq(dev->irq, amd8111e_interrupt, IRQF_SHARED,
-					 dev->name, dev))
+	if (dev->irq == 0 || request_irq(dev->irq, amd8111e_interrupt,
+					 IRQF_SHARED, dev->name, dev))
 		return -EAGAIN;
 
 	napi_enable(&lp->napi);
@@ -1210,7 +1203,7 @@ static int amd8111e_open(struct net_device *dev)
 
 	amd8111e_init_hw_default(lp);
 
-	if(amd8111e_restart(dev)){
+	if (amd8111e_restart(dev)) {
 		spin_unlock_irq(&lp->lock);
 		napi_disable(&lp->napi);
 		if (dev->irq)
@@ -1218,7 +1211,7 @@ static int amd8111e_open(struct net_device *dev)
 		return -ENOMEM;
 	}
 	/* Start ipg timer */
-	if(lp->options & OPTION_DYN_IPG_ENABLE){
+	if (lp->options & OPTION_DYN_IPG_ENABLE) {
 		add_timer(&lp->ipg_data.ipg_timer);
 		netdev_info(dev, "Dynamic IPG Enabled\n");
 	}
@@ -1289,10 +1282,10 @@ static netdev_tx_t amd8111e_start_xmit(struct sk_buff *skb,
 	lp->tx_idx++;
 
 	/* Trigger an immediate send poll. */
-	writel( VAL1 | TDMD0, lp->mmio + CMD0);
-	writel( VAL2 | RDMD0,lp->mmio + CMD0);
+	writel(VAL1 | TDMD0, lp->mmio + CMD0);
+	writel(VAL2 | RDMD0, lp->mmio + CMD0);
 
-	if(amd8111e_tx_queue_avail(lp) < 0){
+	if (amd8111e_tx_queue_avail(lp) < 0) {
 		netif_stop_queue(dev);
 	}
 	spin_unlock_irqrestore(&lp->lock, flags);
@@ -1326,15 +1319,15 @@ static void amd8111e_set_multicast_list(struct net_device *dev)
 {
 	struct netdev_hw_addr *ha;
 	struct amd8111e_priv *lp = netdev_priv(dev);
-	u32 mc_filter[2] ;
+	u32 mc_filter[2];
 	int bit_num;
 
-	if(dev->flags & IFF_PROMISC){
-		writel( VAL2 | PROM, lp->mmio + CMD2);
+	if (dev->flags & IFF_PROMISC) {
+		writel(VAL2 | PROM, lp->mmio + CMD2);
 		return;
 	}
 	else
-		writel( PROM, lp->mmio + CMD2);
+		writel(PROM, lp->mmio + CMD2);
 	if (dev->flags & IFF_ALLMULTI ||
 	    netdev_mc_count(dev) > MAX_FILTER_SIZE) {
 		/* get all multicast packet */
@@ -1439,7 +1432,7 @@ static int amd8111e_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol_
 	if (wol_info->wolopts & WAKE_MAGIC)
 		lp->options |=
 			(OPTION_WOL_ENABLE | OPTION_WAKE_MAGIC_ENABLE);
-	else if(wol_info->wolopts & WAKE_PHY)
+	else if (wol_info->wolopts & WAKE_PHY)
 		lp->options |=
 			(OPTION_WOL_ENABLE | OPTION_WAKE_PHY_ENABLE);
 	else
@@ -1464,14 +1457,14 @@ static const struct ethtool_ops ops = {
  * gets/sets driver speed, gets memory mapped register values, forces
  * auto negotiation, sets/gets WOL options for ethtool application.
  */
-static int amd8111e_ioctl(struct net_device *dev , struct ifreq *ifr, int cmd)
+static int amd8111e_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
 	struct mii_ioctl_data *data = if_mii(ifr);
 	struct amd8111e_priv *lp = netdev_priv(dev);
 	int err;
 	u32 mii_regval;
 
-	switch(cmd) {
+	switch (cmd) {
 	case SIOCGMIIPHY:
 		data->phy_id = lp->ext_phy_addr;
 
@@ -1511,7 +1504,7 @@ static int amd8111e_set_mac_address(struct net_device *dev, void *p)
 	spin_lock_irq(&lp->lock);
 	/* Setting the MAC address to the device */
 	for (i = 0; i < ETH_ALEN; i++)
-		writeb( dev->dev_addr[i], lp->mmio + PADR + i );
+		writeb(dev->dev_addr[i], lp->mmio + PADR + i);
 
 	spin_unlock_irq(&lp->lock);
 
@@ -1536,22 +1529,22 @@ static int amd8111e_change_mtu(struct net_device *dev, int new_mtu)
 
 	spin_lock_irq(&lp->lock);
 
-        /* stop the chip */
+	/* stop the chip */
 	writel(RUN, lp->mmio + CMD0);
 
 	dev->mtu = new_mtu;
 
 	err = amd8111e_restart(dev);
 	spin_unlock_irq(&lp->lock);
-	if(!err)
+	if (!err)
 		netif_start_queue(dev);
 	return err;
 }
 
 static int amd8111e_enable_magicpkt(struct amd8111e_priv *lp)
 {
-	writel( VAL1|MPPLBA, lp->mmio + CMD3);
-	writel( VAL0|MPEN_SW, lp->mmio + CMD7);
+	writel(VAL1 | MPPLBA, lp->mmio + CMD3);
+	writel(VAL0 | MPEN_SW, lp->mmio + CMD7);
 
 	/* To eliminate PCI posting bug */
 	readl(lp->mmio + CMD7);
@@ -1562,7 +1555,7 @@ static int amd8111e_enable_link_change(struct amd8111e_priv *lp)
 {
 
 	/* Adapter is already stoped/suspended/interrupt-disabled */
-	writel(VAL0|LCMODE_SW,lp->mmio + CMD7);
+	writel(VAL0 | LCMODE_SW, lp->mmio + CMD7);
 
 	/* To eliminate PCI posting bug */
 	readl(lp->mmio + CMD7);
@@ -1584,7 +1577,7 @@ static void amd8111e_tx_timeout(struct net_device *dev, unsigned int txqueue)
 	spin_lock_irq(&lp->lock);
 	err = amd8111e_restart(dev);
 	spin_unlock_irq(&lp->lock);
-	if(!err)
+	if (!err)
 		netif_wake_queue(dev);
 }
 
@@ -1605,22 +1598,21 @@ static int __maybe_unused amd8111e_suspend(struct device *dev_d)
 
 	/* stop chip */
 	spin_lock_irq(&lp->lock);
-	if(lp->options & OPTION_DYN_IPG_ENABLE)
+	if (lp->options & OPTION_DYN_IPG_ENABLE)
 		del_timer_sync(&lp->ipg_data.ipg_timer);
 	amd8111e_stop_chip(lp);
 	spin_unlock_irq(&lp->lock);
 
-	if(lp->options & OPTION_WOL_ENABLE){
+	if (lp->options & OPTION_WOL_ENABLE) {
 		 /* enable wol */
-		if(lp->options & OPTION_WAKE_MAGIC_ENABLE)
+		if (lp->options & OPTION_WAKE_MAGIC_ENABLE)
 			amd8111e_enable_magicpkt(lp);
-		if(lp->options & OPTION_WAKE_PHY_ENABLE)
+		if (lp->options & OPTION_WAKE_PHY_ENABLE)
 			amd8111e_enable_link_change(lp);
 
 		device_set_wakeup_enable(dev_d, 1);
 
-	}
-	else{
+	} else {
 		device_set_wakeup_enable(dev_d, 0);
 	}
 
@@ -1640,7 +1632,7 @@ static int __maybe_unused amd8111e_resume(struct device *dev_d)
 	spin_lock_irq(&lp->lock);
 	amd8111e_restart(dev);
 	/* Restart ipg timer */
-	if(lp->options & OPTION_DYN_IPG_ENABLE)
+	if (lp->options & OPTION_DYN_IPG_ENABLE)
 		mod_timer(&lp->ipg_data.ipg_timer,
 				jiffies + IPG_CONVERGE_JIFFIES);
 	spin_unlock_irq(&lp->lock);
@@ -1657,14 +1649,14 @@ static void amd8111e_config_ipg(struct timer_list *t)
 	unsigned int total_col_cnt;
 	unsigned int tmp_ipg;
 
-	if(lp->link_config.duplex == DUPLEX_FULL){
+	if (lp->link_config.duplex == DUPLEX_FULL) {
 		ipg_data->ipg = DEFAULT_IPG;
 		return;
 	}
 
-	if(ipg_data->ipg_state == SSTATE){
+	if (ipg_data->ipg_state == SSTATE) {
 
-		if(ipg_data->timer_tick == IPG_STABLE_TIME){
+		if (ipg_data->timer_tick == IPG_STABLE_TIME) {
 
 			ipg_data->timer_tick = 0;
 			ipg_data->ipg = MIN_IPG - IPG_STEP;
@@ -1676,7 +1668,7 @@ static void amd8111e_config_ipg(struct timer_list *t)
 			ipg_data->timer_tick++;
 	}
 
-	if(ipg_data->ipg_state == CSTATE){
+	if (ipg_data->ipg_state == CSTATE) {
 
 		/* Get the current collision count */
 
@@ -1684,10 +1676,10 @@ static void amd8111e_config_ipg(struct timer_list *t)
 				amd8111e_read_mib(mmio, xmt_collisions);
 
 		if ((total_col_cnt - prev_col_cnt) <
-				(ipg_data->diff_col_cnt)){
+				(ipg_data->diff_col_cnt)) {
 
 			ipg_data->diff_col_cnt =
-				total_col_cnt - prev_col_cnt ;
+				total_col_cnt - prev_col_cnt;
 
 			ipg_data->ipg = ipg_data->current_ipg;
 		}
@@ -1696,7 +1688,7 @@ static void amd8111e_config_ipg(struct timer_list *t)
 
 		if (ipg_data->current_ipg <= MAX_IPG)
 			tmp_ipg = ipg_data->current_ipg;
-		else{
+		else {
 			tmp_ipg = ipg_data->ipg;
 			ipg_data->ipg_state = SSTATE;
 		}
@@ -1748,24 +1740,24 @@ static int amd8111e_probe_one(struct pci_dev *pdev,
 				  const struct pci_device_id *ent)
 {
 	int err, i;
-	unsigned long reg_addr,reg_len;
+	unsigned long reg_addr, reg_len;
 	struct amd8111e_priv *lp;
 	struct net_device *dev;
 
 	err = pci_enable_device(pdev);
-	if(err){
+	if (err) {
 		dev_err(&pdev->dev, "Cannot enable new PCI device\n");
 		return err;
 	}
 
-	if(!(pci_resource_flags(pdev, 0) & IORESOURCE_MEM)){
+	if (!(pci_resource_flags(pdev, 0) & IORESOURCE_MEM)) {
 		dev_err(&pdev->dev, "Cannot find PCI base address\n");
 		err = -ENODEV;
 		goto err_disable_pdev;
 	}
 
 	err = pci_request_regions(pdev, MODULE_NAME);
-	if(err){
+	if (err) {
 		dev_err(&pdev->dev, "Cannot obtain PCI resources\n");
 		goto err_disable_pdev;
 	}
@@ -1798,7 +1790,7 @@ static int amd8111e_probe_one(struct pci_dev *pdev,
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
 #if AMD8111E_VLAN_TAG_USED
-	dev->features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX ;
+	dev->features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
 #endif
 
 	lp = netdev_priv(dev);
@@ -1821,16 +1813,16 @@ static int amd8111e_probe_one(struct pci_dev *pdev,
 
 	/* Setting user defined parametrs */
 	lp->ext_phy_option = speed_duplex[card_idx];
-	if(coalesce[card_idx])
+	if (coalesce[card_idx])
 		lp->options |= OPTION_INTR_COAL_ENABLE;
-	if(dynamic_ipg[card_idx++])
+	if (dynamic_ipg[card_idx++])
 		lp->options |= OPTION_DYN_IPG_ENABLE;
 
 
 	/* Initialize driver entry points */
 	dev->netdev_ops = &amd8111e_netdev_ops;
 	dev->ethtool_ops = &ops;
-	dev->irq =pdev->irq;
+	dev->irq = pdev->irq;
 	dev->watchdog_timeo = AMD8111E_TX_TIMEOUT;
 	dev->min_mtu = AMD8111E_MIN_MTU;
 	dev->max_mtu = AMD8111E_MAX_MTU;
@@ -1861,7 +1853,7 @@ static int amd8111e_probe_one(struct pci_dev *pdev,
 	pci_set_drvdata(pdev, dev);
 
 	/* Initialize software ipg timer */
-	if(lp->options & OPTION_DYN_IPG_ENABLE){
+	if (lp->options & OPTION_DYN_IPG_ENABLE) {
 		timer_setup(&lp->ipg_data.ipg_timer, amd8111e_config_ipg, 0);
 		lp->ipg_data.ipg_timer.expires = jiffies +
 						 IPG_CONVERGE_JIFFIES;
@@ -1870,7 +1862,7 @@ static int amd8111e_probe_one(struct pci_dev *pdev,
 	}
 
 	/*  display driver and device information */
-    	chip_version = (readl(lp->mmio + CHIPID) & 0xf0000000)>>28;
+	chip_version = (readl(lp->mmio + CHIPID) & 0xf0000000) >> 28;
 	dev_info(&pdev->dev, "[ Rev %x ] PCI 10/100BaseT Ethernet %pM\n",
 		 chip_version, dev->dev_addr);
 	if (lp->ext_phy_id)
@@ -1879,7 +1871,7 @@ static int amd8111e_probe_one(struct pci_dev *pdev,
 	else
 		dev_info(&pdev->dev, "Couldn't detect MII PHY, assuming address 0x01\n");
 
-    	return 0;
+	return 0;
 
 err_free_dev:
 	free_netdev(dev);
@@ -1919,7 +1911,7 @@ MODULE_DEVICE_TABLE(pci, amd8111e_pci_tbl);
 static SIMPLE_DEV_PM_OPS(amd8111e_pm_ops, amd8111e_suspend, amd8111e_resume);
 
 static struct pci_driver amd8111e_driver = {
-	.name   	= MODULE_NAME,
+	.name		= MODULE_NAME,
 	.id_table	= amd8111e_pci_tbl,
 	.probe		= amd8111e_probe_one,
 	.remove		= amd8111e_remove_one,
-- 
2.8.1

