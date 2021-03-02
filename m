Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93B0632B3CE
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1837072AbhCCEG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:06:58 -0500
Received: from smtp-17-i2.italiaonline.it ([213.209.12.17]:48667 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1574696AbhCBV5C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 16:57:02 -0500
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([87.20.116.197])
        by smtp-17.iol.local with ESMTPA
        id HCz0lBDmUlChfHCzClGa1g; Tue, 02 Mar 2021 22:55:22 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1614722122; bh=96bNPE5p77n9NSTEC2vRJMppfBiDkxxfSZBnZPG23Z4=;
        h=From;
        b=WGB6AL5sNFQUalhyIF+c6GjH5OZjw19SU/mWs5UnXMSvY1xhWm+7YnAdRicbhs9it
         /yadILZRker8RukHks7ZXg4eSlWjL8BEzlDl2TnwPW3r8UW8Bj7UKMIqWPT8zKq8eQ
         7pqnyUCfpshxFGWivCXdzfo44NU/Uu9lm4RIZu1OBdZ95tFmnFtvdixr/u9+tS6pBL
         S00MIf+YzmdkX/CG4LFnzb5XpAe3yEy9WU4bInsA6GMNVztKS3hCaFcAkmlWoX4aPA
         iP50Nlmj7t3S10gZGcpBh5DGHUmmK3nrabPv+/reLtQHubq81QKj2ii9JLgn+mQSBM
         6n5OVa4Wq4rvQ==
X-CNFS-Analysis: v=2.4 cv=S6McfKgP c=1 sm=1 tr=0 ts=603eb44a cx=a_exe
 a=AVqmXbCQpuNSdJmApS5GbQ==:117 a=AVqmXbCQpuNSdJmApS5GbQ==:17
 a=tUZDV6Rw8AmhtNJeqpIA:9 a=LQ2ymOy1cPXeYbwl:21 a=OSFjYBiQSmxbRpmb:21
From:   Dario Binacchi <dariobin@libero.it>
To:     linux-kernel@vger.kernel.org
Cc:     Alexander Stein <alexander.stein@systec-electronic.com>,
        Federico Vaga <federico.vaga@gmail.com>,
        Dario Binacchi <dariobin@libero.it>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v4 6/6] can: c_can: add support to 64 message objects
Date:   Tue,  2 Mar 2021 22:54:35 +0100
Message-Id: <20210302215435.18286-7-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210302215435.18286-1-dariobin@libero.it>
References: <20210302215435.18286-1-dariobin@libero.it>
X-CMAE-Envelope: MS4xfGkl4McvlMlllcR3UyCNT1nxEMU+GD3ecxFBo8K0nc9PC+sfdLnE2dvofZl8BybakUGYaz3iRxi/0QD1Eefucb+tTk32Ta6EsP2tH80r6AooSIZBMPVq
 w39mekN8TwuOZt01ACc6egFGyKsq8ITeu1cJT1bji3GIruk2zP7ioQXMP1KniobD4iWpNAFFdZ1MmwjXd/Z4Fw0pclZzomvXsM6et+6iuV4Bo5rDZMkr5Qob
 fZ8UJ8q9sz4/FGi7ovYzwJ4IKXqyotDPznJqdr9eXhQJgSFxYzTXYEbKrVQu0RXmDMTO+LcsPbr7KU+mpcBk3XpesZWQvh9NKDV/fJHa6ngGrnFs+Rm0uWsN
 8mLk/qZhgDeuggKVQBUoYbSfuWd5u+t4AGjvnXa4od2UCqKYLniS4MVQBzjWjyL9P+xADAsWGMSU0WKnT+GHrEO4q0VjyBE70AL1sPolagDQlgmj1yI/GkCU
 CIFHdBI16TEDzLO4QC5kjx+SFN6ap/kszLhm1KTgFFqXU8FkUl6js+zb08NOasxGgYMPTanVLZPVGhTGXy9oM4LL+ZypGsN2dU8WzYSPrgBHCeSwtfudDxip
 h1G1qFoAaTmwOjCfqYoqRe9sXm2Bi4u4ZHm7P+aJARWJvr903b+clEEmQM+qDkHMjhggq/uE01WgWmsP7FjVccgyC9BPB7lvoiBJVeH4TME3vQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

D_CAN controller supports 16, 32, 64 or 128 message objects, comparing
to 32 on C_CAN.
AM335x/AM437x Sitara processors and DRA7 SOC all instantiate a D_CAN
controller with 64 message objects, as described in the "DCAN features"
subsection of the CAN chapter of their technical reference manuals.

The driver policy has been kept unchanged, and as in the previous
version, the first half of the message objects is used for reception and
the second for transmission.

The I/O load is increased only in the case of 64 message objects,
keeping it unchanged in the case of 32. Two 32-bit read accesses are in
fact required, which however remained at 16-bit for configurations with
32 message objects.

Signed-off-by: Dario Binacchi <dariobin@libero.it>

---

Changes in v4:
- Use BIT() for setting single bits and GENMASK() for setting masks.

Changes in v3:
- Use unsigned int instead of int as type of the msg_obj_num field
  in c_can_driver_data and c_can_pci_data structures.

Changes in v2:
- Add message objects number to PCI driver data.

 drivers/net/can/c_can/c_can.c          | 30 +++++++++++++++-----------
 drivers/net/can/c_can/c_can.h          |  5 +++--
 drivers/net/can/c_can/c_can_pci.c      |  6 +++++-
 drivers/net/can/c_can/c_can_platform.c |  6 +++++-
 4 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 0052ba5197e0..41e4ec6ab0aa 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -475,7 +475,7 @@ static netdev_tx_t c_can_start_xmit(struct sk_buff *skb,
 	can_put_echo_skb(skb, dev, idx, 0);
 
 	/* Update the active bits */
-	atomic_add((1 << idx), &priv->tx_active);
+	atomic_add(BIT(idx), &priv->tx_active);
 	/* Start transmission */
 	c_can_object_put(dev, IF_TX, obj, IF_COMM_TX);
 
@@ -723,11 +723,15 @@ static void c_can_do_tx(struct net_device *dev)
 	struct net_device_stats *stats = &dev->stats;
 	u32 idx, obj, pkts = 0, bytes = 0, pend, clr;
 
-	clr = pend = priv->read_reg(priv, C_CAN_INTPND2_REG);
+	if (priv->msg_obj_tx_last > 32)
+		pend = priv->read_reg32(priv, C_CAN_INTPND3_REG);
+	else
+		pend = priv->read_reg(priv, C_CAN_INTPND2_REG);
 
+	clr = pend;
 	while ((idx = ffs(pend))) {
 		idx--;
-		pend &= ~(1 << idx);
+		pend &= ~BIT(idx);
 		obj = idx + priv->msg_obj_tx_first;
 
 		/*
@@ -744,7 +748,7 @@ static void c_can_do_tx(struct net_device *dev)
 	/* Clear the bits in the tx_active mask */
 	atomic_sub(clr, &priv->tx_active);
 
-	if (clr & (1 << (priv->msg_obj_tx_num - 1)))
+	if (clr & BIT(priv->msg_obj_tx_num - 1))
 		netif_wake_queue(dev);
 
 	if (pkts) {
@@ -781,9 +785,10 @@ static u32 c_can_adjust_pending(u32 pend, u32 rx_mask)
 	 * Find the first set bit after the gap. We walk backwards
 	 * from the last set bit.
 	 */
-	for (lasts--; pend & (1 << (lasts - 1)); lasts--);
+	for (lasts--; pend & BIT(lasts - 1); lasts--)
+		;
 
-	return pend & ~((1 << lasts) - 1);
+	return pend & ~GENMASK(lasts - 1, 0);
 }
 
 static inline void c_can_rx_object_get(struct net_device *dev,
@@ -840,7 +845,12 @@ static int c_can_read_objects(struct net_device *dev, struct c_can_priv *priv,
 
 static inline u32 c_can_get_pending(struct c_can_priv *priv)
 {
-	u32 pend = priv->read_reg(priv, C_CAN_NEWDAT1_REG);
+	u32 pend;
+
+	if (priv->msg_obj_rx_last > 16)
+		pend = priv->read_reg32(priv, C_CAN_NEWDAT1_REG);
+	else
+		pend = priv->read_reg(priv, C_CAN_NEWDAT1_REG);
 
 	return pend;
 }
@@ -862,12 +872,6 @@ static int c_can_do_rx_poll(struct net_device *dev, int quota)
 	struct c_can_priv *priv = netdev_priv(dev);
 	u32 pkts = 0, pend = 0, toread, n;
 
-	/*
-	 * It is faster to read only one 16bit register. This is only possible
-	 * for a maximum number of 16 objects.
-	 */
-	WARN_ON(priv->msg_obj_rx_last > 16);
-
 	while (quota > 0) {
 		if (!pend) {
 			pend = c_can_get_pending(priv);
diff --git a/drivers/net/can/c_can/c_can.h b/drivers/net/can/c_can/c_can.h
index 68295fab83d9..bd291e998a51 100644
--- a/drivers/net/can/c_can/c_can.h
+++ b/drivers/net/can/c_can/c_can.h
@@ -22,8 +22,6 @@
 #ifndef C_CAN_H
 #define C_CAN_H
 
-#define C_CAN_NO_OF_OBJECTS	32
-
 enum reg {
 	C_CAN_CTRL_REG = 0,
 	C_CAN_CTRL_EX_REG,
@@ -61,6 +59,7 @@ enum reg {
 	C_CAN_NEWDAT2_REG,
 	C_CAN_INTPND1_REG,
 	C_CAN_INTPND2_REG,
+	C_CAN_INTPND3_REG,
 	C_CAN_MSGVAL1_REG,
 	C_CAN_MSGVAL2_REG,
 	C_CAN_FUNCTION_REG,
@@ -122,6 +121,7 @@ static const u16 __maybe_unused reg_map_d_can[] = {
 	[C_CAN_NEWDAT2_REG]	= 0x9E,
 	[C_CAN_INTPND1_REG]	= 0xB0,
 	[C_CAN_INTPND2_REG]	= 0xB2,
+	[C_CAN_INTPND3_REG]	= 0xB4,
 	[C_CAN_MSGVAL1_REG]	= 0xC4,
 	[C_CAN_MSGVAL2_REG]	= 0xC6,
 	[C_CAN_IF1_COMREQ_REG]	= 0x100,
@@ -161,6 +161,7 @@ struct raminit_bits {
 
 struct c_can_driver_data {
 	enum c_can_dev_id id;
+	unsigned int msg_obj_num;
 
 	/* RAMINIT register description. Optional. */
 	const struct raminit_bits *raminit_bits; /* Array of START/DONE bit positions */
diff --git a/drivers/net/can/c_can/c_can_pci.c b/drivers/net/can/c_can/c_can_pci.c
index 3752f68d095e..9415b12d26c8 100644
--- a/drivers/net/can/c_can/c_can_pci.c
+++ b/drivers/net/can/c_can/c_can_pci.c
@@ -31,6 +31,8 @@ enum c_can_pci_reg_align {
 struct c_can_pci_data {
 	/* Specify if is C_CAN or D_CAN */
 	enum c_can_dev_id type;
+	/* Number of message objects */
+	unsigned int msg_obj_num;
 	/* Set the register alignment in the memory */
 	enum c_can_pci_reg_align reg_align;
 	/* Set the frequency */
@@ -149,7 +151,7 @@ static int c_can_pci_probe(struct pci_dev *pdev,
 	}
 
 	/* allocate the c_can device */
-	dev = alloc_c_can_dev(C_CAN_NO_OF_OBJECTS);
+	dev = alloc_c_can_dev(c_can_pci_data->msg_obj_num);
 	if (!dev) {
 		ret = -ENOMEM;
 		goto out_iounmap;
@@ -253,6 +255,7 @@ static void c_can_pci_remove(struct pci_dev *pdev)
 
 static const struct c_can_pci_data c_can_sta2x11= {
 	.type = BOSCH_C_CAN,
+	.msg_obj_num = 32,
 	.reg_align = C_CAN_REG_ALIGN_32,
 	.freq = 52000000, /* 52 Mhz */
 	.bar = 0,
@@ -260,6 +263,7 @@ static const struct c_can_pci_data c_can_sta2x11= {
 
 static const struct c_can_pci_data c_can_pch = {
 	.type = BOSCH_C_CAN,
+	.msg_obj_num = 32,
 	.reg_align = C_CAN_REG_32,
 	.freq = 50000000, /* 50 MHz */
 	.init = c_can_pci_reset_pch,
diff --git a/drivers/net/can/c_can/c_can_platform.c b/drivers/net/can/c_can/c_can_platform.c
index a5b9b1a93702..87a145b67a2f 100644
--- a/drivers/net/can/c_can/c_can_platform.c
+++ b/drivers/net/can/c_can/c_can_platform.c
@@ -192,10 +192,12 @@ static void c_can_hw_raminit(const struct c_can_priv *priv, bool enable)
 
 static const struct c_can_driver_data c_can_drvdata = {
 	.id = BOSCH_C_CAN,
+	.msg_obj_num = 32,
 };
 
 static const struct c_can_driver_data d_can_drvdata = {
 	.id = BOSCH_D_CAN,
+	.msg_obj_num = 32,
 };
 
 static const struct raminit_bits dra7_raminit_bits[] = {
@@ -205,6 +207,7 @@ static const struct raminit_bits dra7_raminit_bits[] = {
 
 static const struct c_can_driver_data dra7_dcan_drvdata = {
 	.id = BOSCH_D_CAN,
+	.msg_obj_num = 64,
 	.raminit_num = ARRAY_SIZE(dra7_raminit_bits),
 	.raminit_bits = dra7_raminit_bits,
 	.raminit_pulse = true,
@@ -217,6 +220,7 @@ static const struct raminit_bits am3352_raminit_bits[] = {
 
 static const struct c_can_driver_data am3352_dcan_drvdata = {
 	.id = BOSCH_D_CAN,
+	.msg_obj_num = 64,
 	.raminit_num = ARRAY_SIZE(am3352_raminit_bits),
 	.raminit_bits = am3352_raminit_bits,
 };
@@ -293,7 +297,7 @@ static int c_can_plat_probe(struct platform_device *pdev)
 	}
 
 	/* allocate the c_can device */
-	dev = alloc_c_can_dev(C_CAN_NO_OF_OBJECTS);
+	dev = alloc_c_can_dev(drvdata->msg_obj_num);
 	if (!dev) {
 		ret = -ENOMEM;
 		goto exit;
-- 
2.17.1

