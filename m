Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 902885B16F9
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 10:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiIHI3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 04:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbiIHI24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 04:28:56 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C5C8D7414;
        Thu,  8 Sep 2022 01:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662625736; x=1694161736;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pvXGhsXqCvFjOKMAYkU55/LhhJsCGqqMvwdYH1QyFjE=;
  b=XsJB6sJC19t/kpbDCyrQB023JSHuP4vtGyTMZm7NIyRGb1vY6pQHwruA
   Ds5rCa9zxMJ6fDhAhandI3bVaXrcASxuWJCCBuEL7nLE/YuY/+g2zwVr7
   RGFYVVbpaKk/TlxXoC9qv/pOKwm451iyw/MbVCqa1ntpfxefnYJAFTPwe
   dWLbXn94XEkckV6aeI+VyGHQHHRHizrY6aX2F92LJvL6AEhbAr0VF/HUS
   bD249orZj8KGS70bC62DpqLAi7FjEoj2Rkjcerv+P+8+xTmAy5TLPsyHh
   bqiVUU/ZQ+RZ223MJOlqJ97cd5MJE53vgxtHdngC9lO1v27GL7EiVJcM0
   w==;
X-IronPort-AV: E=Sophos;i="5.93,299,1654585200"; 
   d="scan'208";a="172912891"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Sep 2022 01:28:55 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 8 Sep 2022 01:28:54 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Thu, 8 Sep 2022 01:28:52 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <Ian.Saturley@microchip.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net-next V2 2/2] net: lan743x: Add support for Rx IP & TCP checksum offload
Date:   Thu, 8 Sep 2022 13:58:34 +0530
Message-ID: <20220908082834.5070-3-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220908082834.5070-1-Raju.Lakkaraju@microchip.com>
References: <20220908082834.5070-1-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Rx IP and TCP checksum offload

Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Reported-by: kernel test robot <lkp@intel.com>

---
Changes:
========
V1 -> V2:
 - Fix the sparse warnings
   (>> drivers/net/ethernet/microchip/lan743x_main.c:2600:28: sparse:
sparse: restricted __le32 degrades to integer)

 drivers/net/ethernet/microchip/lan743x_main.c | 14 +++++++++++++-
 drivers/net/ethernet/microchip/lan743x_main.h |  5 +++++
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 3f4e1ab63f8a..2599dfffd1da 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1585,6 +1585,9 @@ static void lan743x_rfe_set_multicast(struct lan743x_adapter *adapter)
 			rfctl |= RFE_CTL_AM_;
 	}
 
+	if (netdev->features & NETIF_F_RXCSUM)
+		rfctl |= RFE_CTL_IP_COE_ | RFE_CTL_TCP_UDP_COE_;
+
 	memset(hash_table, 0, DP_SEL_VHF_HASH_LEN * sizeof(u32));
 	if (netdev_mc_count(netdev)) {
 		struct netdev_hw_addr *ha;
@@ -2547,6 +2550,7 @@ static int lan743x_rx_process_buffer(struct lan743x_rx *rx)
 	int result = RX_PROCESS_RESULT_NOTHING_TO_DO;
 	struct lan743x_rx_buffer_info *buffer_info;
 	int frame_length, buffer_length;
+	bool is_ice, is_tce, is_icsm;
 	int extension_index = -1;
 	bool is_last, is_first;
 	struct sk_buff *skb;
@@ -2593,6 +2597,9 @@ static int lan743x_rx_process_buffer(struct lan743x_rx *rx)
 	frame_length =
 		RX_DESC_DATA0_FRAME_LENGTH_GET_(le32_to_cpu(descriptor->data0));
 	buffer_length = buffer_info->buffer_length;
+	is_ice = le32_to_cpu(descriptor->data1) & RX_DESC_DATA1_STATUS_ICE_;
+	is_tce = le32_to_cpu(descriptor->data1) & RX_DESC_DATA1_STATUS_TCE_;
+	is_icsm = le32_to_cpu(descriptor->data1) & RX_DESC_DATA1_STATUS_ICSM_;
 
 	netdev_dbg(netdev, "%s%schunk: %d/%d",
 		   is_first ? "first " : "      ",
@@ -2661,6 +2668,10 @@ static int lan743x_rx_process_buffer(struct lan743x_rx *rx)
 	if (is_last && rx->skb_head) {
 		rx->skb_head->protocol = eth_type_trans(rx->skb_head,
 							rx->adapter->netdev);
+		if (rx->adapter->netdev->features & NETIF_F_RXCSUM) {
+			if (!is_ice && !is_tce && !is_icsm)
+				skb->ip_summed = CHECKSUM_UNNECESSARY;
+		}
 		netdev_dbg(netdev, "sending %d byte frame to OS",
 			   rx->skb_head->len);
 		napi_gro_receive(&rx->napi, rx->skb_head);
@@ -3383,7 +3394,8 @@ static int lan743x_pcidev_probe(struct pci_dev *pdev,
 
 	adapter->netdev->netdev_ops = &lan743x_netdev_ops;
 	adapter->netdev->ethtool_ops = &lan743x_ethtool_ops;
-	adapter->netdev->features = NETIF_F_SG | NETIF_F_TSO | NETIF_F_HW_CSUM;
+	adapter->netdev->features = NETIF_F_SG | NETIF_F_TSO |
+				    NETIF_F_HW_CSUM | NETIF_F_RXCSUM;
 	adapter->netdev->hw_features = adapter->netdev->features;
 
 	/* carrier off reporting is important to ethtool even BEFORE open */
diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index 58eb7abf976b..67877d3b6dd9 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -266,6 +266,8 @@
 #define RFE_ADDR_FILT_LO(x)		(0x404 + (8 * (x)))
 
 #define RFE_CTL				(0x508)
+#define RFE_CTL_TCP_UDP_COE_		BIT(12)
+#define RFE_CTL_IP_COE_			BIT(11)
 #define RFE_CTL_AB_			BIT(10)
 #define RFE_CTL_AM_			BIT(9)
 #define RFE_CTL_AU_			BIT(8)
@@ -1121,6 +1123,9 @@ struct lan743x_tx_buffer_info {
 	(((data0) & RX_DESC_DATA0_FRAME_LENGTH_MASK_) >> 16)
 #define RX_DESC_DATA0_EXT_                (0x00004000)
 #define RX_DESC_DATA0_BUF_LENGTH_MASK_    (0x00003FFF)
+#define RX_DESC_DATA1_STATUS_ICE_         (0x00020000)
+#define RX_DESC_DATA1_STATUS_TCE_         (0x00010000)
+#define RX_DESC_DATA1_STATUS_ICSM_        (0x00000001)
 #define RX_DESC_DATA2_TS_NS_MASK_         (0x3FFFFFFF)
 
 #if ((NET_IP_ALIGN != 0) && (NET_IP_ALIGN != 2))
-- 
2.25.1

