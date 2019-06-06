Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A670F380C2
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 00:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729340AbfFFW3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 18:29:54 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:39124 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727297AbfFFW3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 18:29:24 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x56MTHke005242
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 6 Jun 2019 16:29:20 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x56MTAP9028001
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 6 Jun 2019 16:29:17 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     anirudh@xilinx.com, John.Linn@xilinx.com, andrew@lunn.ch,
        davem@davemloft.net, Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next v5 10/20] net: axienet: Add DMA registers to ethtool register dump
Date:   Thu,  6 Jun 2019 16:28:14 -0600
Message-Id: <1559860104-927-11-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1559860104-927-1-git-send-email-hancock@sedsystems.ca>
References: <1559860104-927-1-git-send-email-hancock@sedsystems.ca>
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These registers are important for troubleshooting the state of the DMA
cores.

Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 2c2d626..4df424c 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -50,7 +50,7 @@
 #define DRIVER_DESCRIPTION	"Xilinx Axi Ethernet driver"
 #define DRIVER_VERSION		"1.00a"
 
-#define AXIENET_REGS_N		32
+#define AXIENET_REGS_N		40
 
 /* Match table for of_platform binding */
 static const struct of_device_id axienet_of_match[] = {
@@ -1179,6 +1179,14 @@ static void axienet_ethtools_get_regs(struct net_device *ndev,
 	data[29] = axienet_ior(lp, XAE_FMI_OFFSET);
 	data[30] = axienet_ior(lp, XAE_AF0_OFFSET);
 	data[31] = axienet_ior(lp, XAE_AF1_OFFSET);
+	data[32] = axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET);
+	data[33] = axienet_dma_in32(lp, XAXIDMA_TX_SR_OFFSET);
+	data[34] = axienet_dma_in32(lp, XAXIDMA_TX_CDESC_OFFSET);
+	data[35] = axienet_dma_in32(lp, XAXIDMA_TX_TDESC_OFFSET);
+	data[36] = axienet_dma_in32(lp, XAXIDMA_RX_CR_OFFSET);
+	data[37] = axienet_dma_in32(lp, XAXIDMA_RX_SR_OFFSET);
+	data[38] = axienet_dma_in32(lp, XAXIDMA_RX_CDESC_OFFSET);
+	data[39] = axienet_dma_in32(lp, XAXIDMA_RX_TDESC_OFFSET);
 }
 
 static void axienet_ethtools_get_ringparam(struct net_device *ndev,
-- 
1.8.3.1

