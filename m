Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAEBA3271F0
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 11:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbhB1KuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 05:50:19 -0500
Received: from smtp-17-i2.italiaonline.it ([213.209.12.17]:52305 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230489AbhB1Kj5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Feb 2021 05:39:57 -0500
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([87.20.116.197])
        by smtp-17.iol.local with ESMTPA
        id GJTalhz13lChfGJTklvZUX; Sun, 28 Feb 2021 11:39:13 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1614508753; bh=9lwYBOOlEan677NxFk9bvwSj+eCuiJFEvaAgvnHZsBU=;
        h=From;
        b=SPSMkpe0cXH7VMaezIvDEapxjQRTfRhRuCIRjCp3Y7q8UIcq+t6BcRM0Q4cTYtE0H
         qiaFDDIkwjZGMmFDaB8xsDsrNSOW0Cg/8QvzhhW8h03yrHE5820kC8jDSpB1YnTXC7
         JG/S2fvLLYJFCcZ7RaV9oHsMUxV8Jx6Ram7MK/+F9To71isAupyk+rPDbE4QkGyn5W
         9O7Zf6aLbeHAnWOnH9EGJ6yihezbx/bvK4eWpD013Qb1AFgPVuo0M3dzXMjCLtoTH/
         3L4TnLsc7zCxjyQGse+RBhDtNtJa/aH0T/C2NSOFJa0mym72/XXeaKW+IVuSUlq/YR
         fqhMobI7bJTJA==
X-CNFS-Analysis: v=2.4 cv=S6McfKgP c=1 sm=1 tr=0 ts=603b72d1 cx=a_exe
 a=AVqmXbCQpuNSdJmApS5GbQ==:117 a=AVqmXbCQpuNSdJmApS5GbQ==:17 a=QyXUC8HyAAAA:8
 a=3axKsbaXVfasLmrsgWoA:9 a=AlnpUAtRvUPw4hiF:21 a=7iL2R0msYJN4DsIq:21
From:   Dario Binacchi <dariobin@libero.it>
To:     linux-kernel@vger.kernel.org
Cc:     Federico Vaga <federico.vaga@gmail.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
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
Subject: [PATCH v3 5/6] can: c_can: prepare to up the message objects number
Date:   Sun, 28 Feb 2021 11:38:54 +0100
Message-Id: <20210228103856.4089-6-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210228103856.4089-1-dariobin@libero.it>
References: <20210228103856.4089-1-dariobin@libero.it>
X-CMAE-Envelope: MS4xfMtgfoD11GRmxmTwHk6CA4xJ2FIHUYbkitTuHRUiwJbQyZapeubBQKOEzBse9y8YAOvKlzS1nBNfmFJBK/VWJ7r/vNFegrFoARRvSos6N85xiRieDZIK
 wiPhUoqpGnlPATmGP6SI5dIhidQM0g5BMvgqJiGU6nJbzEMywIyzVlAywQ5DeL/7BrLJHgZeJQ8wajk6P4nIw89anL3Gn3coiB1O47kzlKShbVpKdN7j6niU
 AkZdxqSEAcL/U6itSQuB9QvO+2i62hNsXwKS0QtrTcOAni4yt5atoZrz0+Ut3DLmO0eHcXGiabDHbyC2w+Wfhd0aOwz7xmKEbpCQUY1qf5UcFZqNY5dwQbdt
 Zzn7c2gxv7H+MTXIzC9tZZBg0jrPKJZ6rqpXfwWCjrwXTRqwIBGhWtfMYpeUs0FLdcZbPXSvALtbPWvdbPIrutugMjuAPJ4LIIsLEglL+7Yma5loM3TaKeOY
 8ZQY5v8rUJZJQeOUEEHfeD6qePCgperhHWgZWOpRp0o5tiLMknQ2OtTBEllaOsITXQ50fGNrMaWsx926pJXUKkgcj/TDuDxZNDvP6VTKSvrXI9vDK5a31EuN
 Nwudre3C/Tjgi5dHSaVtZ5zz0YqX6JTFTaDMmDgDg4NFptBkgXMOCEbE1DZAId+CixAPyMbva+WliSMg0ISdg+06iCmx/tFDtSuLbuvhlcur6Q==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As pointed by commit c0a9f4d396c9 ("can: c_can: Reduce register access")
the "driver casts the 16 message objects in stone, which is completely
braindead as contemporary hardware has up to 128 message objects".

The patch prepares the module to extend the number of message objects
beyond the 32 currently managed. This was achieved by transforming the
constants used to manage RX/TX messages into variables without changing
the driver policy.

Signed-off-by: Dario Binacchi <dariobin@libero.it>
Reported-by: kernel test robot <lkp@intel.com>

---

Changes in v3:
- Use unsigned int instead of int as type of the msg_obj_* fields
  in the c_can_priv structure.
- Replace (u64)1 with 1UL in msg_obj_rx_mask setting.

Changes in v2:
- Fix compiling error reported by kernel test robot.
- Add Reported-by tag.
- Pass larger size to alloc_candev() routine to avoid an additional
  memory allocation/deallocation.

 drivers/net/can/c_can/c_can.c          | 50 ++++++++++++++++----------
 drivers/net/can/c_can/c_can.h          | 23 ++++++------
 drivers/net/can/c_can/c_can_pci.c      |  2 +-
 drivers/net/can/c_can/c_can_platform.c |  2 +-
 4 files changed, 43 insertions(+), 34 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 7081cfaf62e2..ede6f4d62095 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -173,9 +173,6 @@
 /* Wait for ~1 sec for INIT bit */
 #define INIT_WAIT_MS		1000
 
-/* napi related */
-#define C_CAN_NAPI_WEIGHT	C_CAN_MSG_OBJ_RX_NUM
-
 /* c_can lec values */
 enum c_can_lec_type {
 	LEC_NO_ERROR = 0,
@@ -325,7 +322,7 @@ static void c_can_setup_tx_object(struct net_device *dev, int iface,
 	 * first, i.e. clear the MSGVAL flag in the arbiter.
 	 */
 	if (rtr != (bool)test_bit(idx, &priv->tx_dir)) {
-		u32 obj = idx + C_CAN_MSG_OBJ_TX_FIRST;
+		u32 obj = idx + priv->msg_obj_tx_first;
 
 		c_can_inval_msg_object(dev, iface, obj);
 		change_bit(idx, &priv->tx_dir);
@@ -463,10 +460,10 @@ static netdev_tx_t c_can_start_xmit(struct sk_buff *skb,
 	 * prioritized. The lowest buffer number wins.
 	 */
 	idx = fls(atomic_read(&priv->tx_active));
-	obj = idx + C_CAN_MSG_OBJ_TX_FIRST;
+	obj = idx + priv->msg_obj_tx_first;
 
 	/* If this is the last buffer, stop the xmit queue */
-	if (idx == C_CAN_MSG_OBJ_TX_NUM - 1)
+	if (idx == priv->msg_obj_tx_num - 1)
 		netif_stop_queue(dev);
 	/*
 	 * Store the message in the interface so we can call
@@ -549,17 +546,18 @@ static int c_can_set_bittiming(struct net_device *dev)
  */
 static void c_can_configure_msg_objects(struct net_device *dev)
 {
+	struct c_can_priv *priv = netdev_priv(dev);
 	int i;
 
 	/* first invalidate all message objects */
-	for (i = C_CAN_MSG_OBJ_RX_FIRST; i <= C_CAN_NO_OF_OBJECTS; i++)
+	for (i = priv->msg_obj_rx_first; i <= priv->msg_obj_num; i++)
 		c_can_inval_msg_object(dev, IF_RX, i);
 
 	/* setup receive message objects */
-	for (i = C_CAN_MSG_OBJ_RX_FIRST; i < C_CAN_MSG_OBJ_RX_LAST; i++)
+	for (i = priv->msg_obj_rx_first; i < priv->msg_obj_rx_last; i++)
 		c_can_setup_receive_object(dev, IF_RX, i, 0, 0, IF_MCONT_RCV);
 
-	c_can_setup_receive_object(dev, IF_RX, C_CAN_MSG_OBJ_RX_LAST, 0, 0,
+	c_can_setup_receive_object(dev, IF_RX, priv->msg_obj_rx_last, 0, 0,
 				   IF_MCONT_RCV_EOB);
 }
 
@@ -730,7 +728,7 @@ static void c_can_do_tx(struct net_device *dev)
 	while ((idx = ffs(pend))) {
 		idx--;
 		pend &= ~(1 << idx);
-		obj = idx + C_CAN_MSG_OBJ_TX_FIRST;
+		obj = idx + priv->msg_obj_tx_first;
 		c_can_inval_tx_object(dev, IF_TX, obj);
 		can_get_echo_skb(dev, idx, NULL);
 		bytes += priv->dlc[idx];
@@ -740,7 +738,7 @@ static void c_can_do_tx(struct net_device *dev)
 	/* Clear the bits in the tx_active mask */
 	atomic_sub(clr, &priv->tx_active);
 
-	if (clr & (1 << (C_CAN_MSG_OBJ_TX_NUM - 1)))
+	if (clr & (1 << (priv->msg_obj_tx_num - 1)))
 		netif_wake_queue(dev);
 
 	if (pkts) {
@@ -755,11 +753,11 @@ static void c_can_do_tx(struct net_device *dev)
  * raced with the hardware or failed to readout all upper
  * objects in the last run due to quota limit.
  */
-static u32 c_can_adjust_pending(u32 pend)
+static u32 c_can_adjust_pending(u32 pend, u32 rx_mask)
 {
 	u32 weight, lasts;
 
-	if (pend == RECEIVE_OBJECT_BITS)
+	if (pend == rx_mask)
 		return pend;
 
 	/*
@@ -862,8 +860,7 @@ static int c_can_do_rx_poll(struct net_device *dev, int quota)
 	 * It is faster to read only one 16bit register. This is only possible
 	 * for a maximum number of 16 objects.
 	 */
-	BUILD_BUG_ON_MSG(C_CAN_MSG_OBJ_RX_LAST > 16,
-			"Implementation does not support more message objects than 16");
+	WARN_ON(priv->msg_obj_rx_last > 16);
 
 	while (quota > 0) {
 		if (!pend) {
@@ -874,7 +871,8 @@ static int c_can_do_rx_poll(struct net_device *dev, int quota)
 			 * If the pending field has a gap, handle the
 			 * bits above the gap first.
 			 */
-			toread = c_can_adjust_pending(pend);
+			toread = c_can_adjust_pending(pend,
+						      priv->msg_obj_rx_mask);
 		} else {
 			toread = pend;
 		}
@@ -1205,17 +1203,31 @@ static int c_can_close(struct net_device *dev)
 	return 0;
 }
 
-struct net_device *alloc_c_can_dev(void)
+struct net_device *alloc_c_can_dev(int msg_obj_num)
 {
 	struct net_device *dev;
 	struct c_can_priv *priv;
+	int msg_obj_tx_num = msg_obj_num / 2;
 
-	dev = alloc_candev(sizeof(struct c_can_priv), C_CAN_MSG_OBJ_TX_NUM);
+	dev = alloc_candev(sizeof(*priv) + sizeof(u32) * msg_obj_tx_num,
+			   msg_obj_tx_num);
 	if (!dev)
 		return NULL;
 
 	priv = netdev_priv(dev);
-	netif_napi_add(dev, &priv->napi, c_can_poll, C_CAN_NAPI_WEIGHT);
+	priv->msg_obj_num = msg_obj_num;
+	priv->msg_obj_rx_num = msg_obj_num - msg_obj_tx_num;
+	priv->msg_obj_rx_first = 1;
+	priv->msg_obj_rx_last =
+		priv->msg_obj_rx_first + priv->msg_obj_rx_num - 1;
+	priv->msg_obj_rx_mask = (1UL << priv->msg_obj_rx_num) - 1;
+
+	priv->msg_obj_tx_num = msg_obj_tx_num;
+	priv->msg_obj_tx_first = priv->msg_obj_rx_last + 1;
+	priv->msg_obj_tx_last =
+		priv->msg_obj_tx_first + priv->msg_obj_tx_num - 1;
+
+	netif_napi_add(dev, &priv->napi, c_can_poll, priv->msg_obj_rx_num);
 
 	priv->dev = dev;
 	priv->can.bittiming_const = &c_can_bittiming_const;
diff --git a/drivers/net/can/c_can/c_can.h b/drivers/net/can/c_can/c_can.h
index 90d3d2e7a086..68295fab83d9 100644
--- a/drivers/net/can/c_can/c_can.h
+++ b/drivers/net/can/c_can/c_can.h
@@ -22,18 +22,7 @@
 #ifndef C_CAN_H
 #define C_CAN_H
 
-/* message object split */
 #define C_CAN_NO_OF_OBJECTS	32
-#define C_CAN_MSG_OBJ_RX_NUM	16
-#define C_CAN_MSG_OBJ_TX_NUM	16
-
-#define C_CAN_MSG_OBJ_RX_FIRST	1
-#define C_CAN_MSG_OBJ_RX_LAST	(C_CAN_MSG_OBJ_RX_FIRST + \
-				C_CAN_MSG_OBJ_RX_NUM - 1)
-
-#define C_CAN_MSG_OBJ_TX_FIRST	(C_CAN_MSG_OBJ_RX_LAST + 1)
-
-#define RECEIVE_OBJECT_BITS	0x0000ffff
 
 enum reg {
 	C_CAN_CTRL_REG = 0,
@@ -193,6 +182,14 @@ struct c_can_priv {
 	struct napi_struct napi;
 	struct net_device *dev;
 	struct device *device;
+	unsigned int msg_obj_num;
+	unsigned int msg_obj_rx_num;
+	unsigned int msg_obj_tx_num;
+	unsigned int msg_obj_rx_first;
+	unsigned int msg_obj_rx_last;
+	unsigned int msg_obj_tx_first;
+	unsigned int msg_obj_tx_last;
+	u32 msg_obj_rx_mask;
 	atomic_t tx_active;
 	atomic_t sie_pending;
 	unsigned long tx_dir;
@@ -209,10 +206,10 @@ struct c_can_priv {
 	void (*raminit) (const struct c_can_priv *priv, bool enable);
 	u32 comm_rcv_high;
 	u32 rxmasked;
-	u32 dlc[C_CAN_MSG_OBJ_TX_NUM];
+	u32 dlc[];
 };
 
-struct net_device *alloc_c_can_dev(void);
+struct net_device *alloc_c_can_dev(int msg_obj_num);
 void free_c_can_dev(struct net_device *dev);
 int register_c_can_dev(struct net_device *dev);
 void unregister_c_can_dev(struct net_device *dev);
diff --git a/drivers/net/can/c_can/c_can_pci.c b/drivers/net/can/c_can/c_can_pci.c
index 406b4847e5dc..3752f68d095e 100644
--- a/drivers/net/can/c_can/c_can_pci.c
+++ b/drivers/net/can/c_can/c_can_pci.c
@@ -149,7 +149,7 @@ static int c_can_pci_probe(struct pci_dev *pdev,
 	}
 
 	/* allocate the c_can device */
-	dev = alloc_c_can_dev();
+	dev = alloc_c_can_dev(C_CAN_NO_OF_OBJECTS);
 	if (!dev) {
 		ret = -ENOMEM;
 		goto out_iounmap;
diff --git a/drivers/net/can/c_can/c_can_platform.c b/drivers/net/can/c_can/c_can_platform.c
index 05f425ceb53a..a5b9b1a93702 100644
--- a/drivers/net/can/c_can/c_can_platform.c
+++ b/drivers/net/can/c_can/c_can_platform.c
@@ -293,7 +293,7 @@ static int c_can_plat_probe(struct platform_device *pdev)
 	}
 
 	/* allocate the c_can device */
-	dev = alloc_c_can_dev();
+	dev = alloc_c_can_dev(C_CAN_NO_OF_OBJECTS);
 	if (!dev) {
 		ret = -ENOMEM;
 		goto exit;
-- 
2.17.1

