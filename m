Return-Path: <netdev+bounces-6022-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3D7871461D
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 10:09:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F542280AB6
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 08:09:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3235863A6;
	Mon, 29 May 2023 08:08:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DF8613E
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 08:08:54 +0000 (UTC)
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 59E2DAC;
	Mon, 29 May 2023 01:08:52 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="6.00,200,1681138800"; 
   d="scan'208";a="161242012"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 29 May 2023 17:08:49 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
	by relmlir5.idc.renesas.com (Postfix) with ESMTP id B69F6400C744;
	Mon, 29 May 2023 17:08:49 +0900 (JST)
From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To: s.shtylyov@omp.ru,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	robh+dt@kernel.org,
	krzysztof.kozlowski+dt@linaro.org,
	conor+dt@kernel.org,
	geert+renesas@glider.be,
	magnus.damm@gmail.com
Cc: netdev@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH net-next 2/5] net: renesas: rswitch: Rename GWCA related definitions
Date: Mon, 29 May 2023 17:08:37 +0900
Message-Id: <20230529080840.1156458-3-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230529080840.1156458-1-yoshihiro.shimoda.uh@renesas.com>
References: <20230529080840.1156458-1-yoshihiro.shimoda.uh@renesas.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Rename GWCA related definitions to improve readability.

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/net/ethernet/renesas/rswitch.c | 10 +++++-----
 drivers/net/ethernet/renesas/rswitch.h | 12 ++++++------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index 29afaddb598d..51df96de6fd5 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -95,7 +95,7 @@ static void rswitch_top_init(struct rswitch_private *priv)
 {
 	int i;
 
-	for (i = 0; i < RSWITCH_MAX_NUM_QUEUES; i++)
+	for (i = 0; i < GWCA_AXI_CHAIN_N; i++)
 		iowrite32((i / 16) << (GWCA_INDEX * 8), priv->addr + TPEMIMC7(i));
 }
 
@@ -179,7 +179,7 @@ static bool rswitch_is_any_data_irq(struct rswitch_private *priv, u32 *dis, bool
 	u32 *mask = tx ? priv->gwca.tx_irq_bits : priv->gwca.rx_irq_bits;
 	int i;
 
-	for (i = 0; i < RSWITCH_NUM_IRQ_REGS; i++) {
+	for (i = 0; i < GWCA_NUM_IRQ_REGS; i++) {
 		if (dis[i] & mask[i])
 			return true;
 	}
@@ -191,7 +191,7 @@ static void rswitch_get_data_irq_status(struct rswitch_private *priv, u32 *dis)
 {
 	int i;
 
-	for (i = 0; i < RSWITCH_NUM_IRQ_REGS; i++) {
+	for (i = 0; i < GWCA_NUM_IRQ_REGS; i++) {
 		dis[i] = ioread32(priv->addr + GWDIS(i));
 		dis[i] &= ioread32(priv->addr + GWDIE(i));
 	}
@@ -863,7 +863,7 @@ static irqreturn_t rswitch_data_irq(struct rswitch_private *priv, u32 *dis)
 static irqreturn_t rswitch_gwca_irq(int irq, void *dev_id)
 {
 	struct rswitch_private *priv = dev_id;
-	u32 dis[RSWITCH_NUM_IRQ_REGS];
+	u32 dis[GWCA_NUM_IRQ_REGS];
 	irqreturn_t ret = IRQ_NONE;
 
 	rswitch_get_data_irq_status(priv, dis);
@@ -1891,7 +1891,7 @@ static int renesas_eth_sw_probe(struct platform_device *pdev)
 
 	priv->gwca.index = AGENT_INDEX_GWCA;
 	priv->gwca.num_queues = min(RSWITCH_NUM_PORTS * NUM_QUEUES_PER_NDEV,
-				    RSWITCH_MAX_NUM_QUEUES);
+				    GWCA_AXI_CHAIN_N);
 	priv->gwca.queues = devm_kcalloc(&pdev->dev, priv->gwca.num_queues,
 					 sizeof(*priv->gwca.queues), GFP_KERNEL);
 	if (!priv->gwca.queues)
diff --git a/drivers/net/ethernet/renesas/rswitch.h b/drivers/net/ethernet/renesas/rswitch.h
index b3e0411b408e..550a6bff9078 100644
--- a/drivers/net/ethernet/renesas/rswitch.h
+++ b/drivers/net/ethernet/renesas/rswitch.h
@@ -10,8 +10,6 @@
 #include <linux/platform_device.h>
 #include "rcar_gen4_ptp.h"
 
-#define RSWITCH_MAX_NUM_QUEUES	128
-
 #define RSWITCH_NUM_PORTS	3
 #define rswitch_for_each_enabled_port(priv, i)		\
 	for (i = 0; i < RSWITCH_NUM_PORTS; i++)		\
@@ -50,6 +48,9 @@
 #define AGENT_INDEX_GWCA	3
 #define GWRO			RSWITCH_GWCA0_OFFSET
 
+#define GWCA_AXI_CHAIN_N	128
+#define GWCA_NUM_IRQ_REGS	(GWCA_AXI_CHAIN_N / BITS_PER_TYPE(u32))
+
 #define GWCA_TS_IRQ_RESOURCE_NAME	"gwca0_rxts0"
 #define GWCA_TS_IRQ_NAME		"rswitch: gwca0_rxts0"
 #define GWCA_TS_IRQ_BIT			BIT(0)
@@ -949,7 +950,6 @@ struct rswitch_gwca_ts_info {
 	u8 tag;
 };
 
-#define RSWITCH_NUM_IRQ_REGS	(RSWITCH_MAX_NUM_QUEUES / BITS_PER_TYPE(u32))
 struct rswitch_gwca {
 	int index;
 	struct rswitch_desc *linkfix_table;
@@ -959,9 +959,9 @@ struct rswitch_gwca {
 	int num_queues;
 	struct rswitch_gwca_queue ts_queue;
 	struct list_head ts_info_list;
-	DECLARE_BITMAP(used, RSWITCH_MAX_NUM_QUEUES);
-	u32 tx_irq_bits[RSWITCH_NUM_IRQ_REGS];
-	u32 rx_irq_bits[RSWITCH_NUM_IRQ_REGS];
+	DECLARE_BITMAP(used, GWCA_AXI_CHAIN_N);
+	u32 tx_irq_bits[GWCA_NUM_IRQ_REGS];
+	u32 rx_irq_bits[GWCA_NUM_IRQ_REGS];
 	int speed;
 };
 
-- 
2.25.1


