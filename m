Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EECB7480EB9
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 02:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238270AbhL2Bw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 20:52:28 -0500
Received: from out162-62-57-137.mail.qq.com ([162.62.57.137]:46905 "EHLO
        out162-62-57-137.mail.qq.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229908AbhL2Bw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 20:52:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1640742730;
        bh=F8+b1uMCCeVjYIZUdxgGucMNHmVUVe0YcOo9/SogGiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=pbxhwZvwO3gk6j0WrWPxCHrwYzwmmFrd7TKGFl9Vg69krkDwCwF7reH/98llnOP3G
         GoRu4YHxcYIxys59WL0Xki30jZX8ujSWcb8tmfIC3cXPEG0sGCeS7DF4oTZi8MrjEU
         1KaCaHiOAbhlLBxMFZEgNHcgdl944n3P64FCHiI0=
Received: from fedora.. ([119.33.249.242])
        by newxmesmtplogicsvrsza9.qq.com (NewEsmtp) with SMTP
        id AF600ACE; Wed, 29 Dec 2021 09:43:54 +0800
X-QQ-mid: xmsmtpt1640742234tzvz7h3n7
Message-ID: <tencent_DE05ADA53D5B084D4605BE6CB11E49EF7408@qq.com>
X-QQ-XMAILINFO: NcdhUYIpzyYI9rkeJeeRcnqPeb3nhXhgqzoWRYzZ3OzNCsf6zA91UtQFYqAcYa
         iXW+qsll9afR+EmzyYEw35nUSq/+8oTYA6e4u+APHYxVQPepxhxslo5kcH5W4JYC2cuApJtxVynz
         f2s7OxlA6ahYNShfiTz/EP22RcuAmgMbz6m2aSvudh6CzxiI3BPnNZb6nLaR7pz91UKYR6O7hnHS
         R7aliF2/LBMow0VPjtKF2DApbE6OMWivhzn4rMnoRTINaJ/2ALRnFsW/GWbENclEPXMxWRssQyv9
         0x1t93dvdtU+1yzr8+e0pRkSGC/+ryCPQiV3jMFfZIckTdJEkkNZj5O9QIO7vbg534e3e0bZy8iT
         pPv6VGrUgM3CfmUGOXlgIdgIf2zZeyjn+1WjxkrRDxZoNcyVmR4dMTspLFjbf160yLt/j3seal8E
         5LRLXbrKChf0kpKAx8K1nOUbigP804PCMReEQaLDvefXV2KW1ot0hL8Rw5nrzXJZvl/nEau4N1jQ
         r9I92mA7R/KDFmQ+EJSh67wDQo9tT4E9a0RpNSSGZo2/3W4F+Gg4o6U2cIHHSQOf3kaEMHqEz3XW
         P79+4y4aonOxoR23PWUs/bXuQeVvtdyOB9LvDIjn+TMnRnBaWc5tqcjvR/rvVN1GGkxJqryzczsF
         hV9aMg1EUHQM/VRaYUbrwT4Q9g3yqqn9GqEntk9Y9GzljfkRDLjs/ROk5KcXTQcxevIlPAbv0Wmx
         LBOAZ5v39dWUxI8BRZhE1YJLFHfzb10tLZYGYk1zaXvehKMJyJ+iXI4sT1TEbor9Q2cxvzkTkqQb
         y5DabbrhmKJj3Dx8R202wJ3E2qzAd5ZgqtGTfNnXu6pqeoTRQe3kgiuoFzAv9UOzUs9/6Y9wICyL
         Ymp8OIsnpZ7VAtPcxohK3Ss7/sJDU3PpFD43XV/uD2U1Au2+AABuQ=
From:   conleylee@foxmail.com
To:     davem@davemloft.net, kuba@kernel.org, mripard@kernel.org,
        wens@csie.org
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Conley Lee <conleylee@foxmail.com>
Subject: [PATCH v6] sun4i-emac.c: add dma support
Date:   Wed, 29 Dec 2021 09:43:51 +0800
X-OQ-MSGID: <20211229014351.501016-1-conleylee@foxmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211228164817.1297c1c9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20211228164817.1297c1c9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Conley Lee <conleylee@foxmail.com>

Thanks for your review. Here is the new version for this patch.

This patch adds support for the emac rx dma present on sun4i. The emac
is able to move packets from rx fifo to RAM by using dma.

Change since v4.
  - rename sbk field to skb
  - rename alloc_emac_dma_req to emac_alloc_dma_req
  - using kzalloc(..., GPF_ATOMIC) in interrupt context to avoid
    sleeping
  - retry by using emac_inblk_32bit when emac_dma_inblk_32bit fails
  - fix some code style issues 

Change since v5.
  - fix some code style issue

Signed-off-by: Conley Lee <conleylee@foxmail.com>
---
 drivers/net/ethernet/allwinner/sun4i-emac.c | 200 ++++++++++++++++++++
 1 file changed, 200 insertions(+)

diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.c b/drivers/net/ethernet/allwinner/sun4i-emac.c
index cccf8a3ead5e..964227e342ee 100644
--- a/drivers/net/ethernet/allwinner/sun4i-emac.c
+++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
@@ -29,6 +29,7 @@
 #include <linux/platform_device.h>
 #include <linux/phy.h>
 #include <linux/soc/sunxi/sunxi_sram.h>
+#include <linux/dmaengine.h>
 
 #include "sun4i-emac.h"
 
@@ -86,6 +87,16 @@ struct emac_board_info {
 	unsigned int		duplex;
 
 	phy_interface_t		phy_interface;
+	struct dma_chan	*rx_chan;
+	phys_addr_t emac_rx_fifo;
+};
+
+struct emac_dma_req {
+	struct emac_board_info *db;
+	struct dma_async_tx_descriptor *desc;
+	struct sk_buff *skb;
+	dma_addr_t rxbuf;
+	int count;
 };
 
 static void emac_update_speed(struct net_device *dev)
@@ -205,6 +216,117 @@ static void emac_inblk_32bit(void __iomem *reg, void *data, int count)
 	readsl(reg, data, round_up(count, 4) / 4);
 }
 
+static struct emac_dma_req *
+emac_alloc_dma_req(struct emac_board_info *db,
+		   struct dma_async_tx_descriptor *desc, struct sk_buff *skb,
+		   dma_addr_t rxbuf, int count)
+{
+	struct emac_dma_req *req;
+
+	req = kzalloc(sizeof(struct emac_dma_req), GFP_ATOMIC);
+	if (!req)
+		return NULL;
+
+	req->db = db;
+	req->desc = desc;
+	req->skb = skb;
+	req->rxbuf = rxbuf;
+	req->count = count;
+	return req;
+}
+
+static void emac_free_dma_req(struct emac_dma_req *req)
+{
+	kfree(req);
+}
+
+static void emac_dma_done_callback(void *arg)
+{
+	struct emac_dma_req *req = arg;
+	struct emac_board_info *db = req->db;
+	struct sk_buff *skb = req->skb;
+	struct net_device *dev = db->ndev;
+	int rxlen = req->count;
+	u32 reg_val;
+
+	dma_unmap_single(db->dev, req->rxbuf, rxlen, DMA_FROM_DEVICE);
+
+	skb->protocol = eth_type_trans(skb, dev);
+	netif_rx(skb);
+	dev->stats.rx_bytes += rxlen;
+	/* Pass to upper layer */
+	dev->stats.rx_packets++;
+
+	/* re enable cpu receive */
+	reg_val = readl(db->membase + EMAC_RX_CTL_REG);
+	reg_val &= ~EMAC_RX_CTL_DMA_EN;
+	writel(reg_val, db->membase + EMAC_RX_CTL_REG);
+
+	/* re enable interrupt */
+	reg_val = readl(db->membase + EMAC_INT_CTL_REG);
+	reg_val |= (0x01 << 8);
+	writel(reg_val, db->membase + EMAC_INT_CTL_REG);
+
+	db->emacrx_completed_flag = 1;
+	emac_free_dma_req(req);
+}
+
+static int emac_dma_inblk_32bit(struct emac_board_info *db,
+		struct sk_buff *skb, void *rdptr, int count)
+{
+	struct dma_async_tx_descriptor *desc;
+	dma_cookie_t cookie;
+	dma_addr_t rxbuf;
+	struct emac_dma_req *req;
+	int ret = 0;
+
+	rxbuf = dma_map_single(db->dev, rdptr, count, DMA_FROM_DEVICE);
+	ret = dma_mapping_error(db->dev, rxbuf);
+	if (ret) {
+		dev_err(db->dev, "dma mapping error.\n");
+		return ret;
+	}
+
+	desc = dmaengine_prep_slave_single(db->rx_chan, rxbuf, count,
+					   DMA_DEV_TO_MEM,
+					   DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	if (!desc) {
+		dev_err(db->dev, "prepare slave single failed\n");
+		ret = -ENOMEM;
+		goto prepare_err;
+	}
+
+	req = emac_alloc_dma_req(db, desc, skb, rxbuf, count);
+	if (!req) {
+		dev_err(db->dev, "alloc emac dma req error.\n");
+		ret = -ENOMEM;
+		goto alloc_req_err;
+	}
+
+	desc->callback_param = req;
+	desc->callback = emac_dma_done_callback;
+
+	cookie = dmaengine_submit(desc);
+	ret = dma_submit_error(cookie);
+	if (ret) {
+		dev_err(db->dev, "dma submit error.\n");
+		goto submit_err;
+	}
+
+	dma_async_issue_pending(db->rx_chan);
+	return ret;
+
+submit_err:
+	emac_free_dma_req(req);
+
+alloc_req_err:
+	dmaengine_desc_free(desc);
+
+prepare_err:
+	dma_unmap_single(db->dev, rxbuf, count, DMA_FROM_DEVICE);
+	return ret;
+}
+
 /* ethtool ops */
 static void emac_get_drvinfo(struct net_device *dev,
 			      struct ethtool_drvinfo *info)
@@ -605,6 +727,19 @@ static void emac_rx(struct net_device *dev)
 			if (netif_msg_rx_status(db))
 				dev_dbg(db->dev, "RxLen %x\n", rxlen);
 
+			if (rxlen >= dev->mtu && db->rx_chan) {
+				reg_val = readl(db->membase + EMAC_RX_CTL_REG);
+				reg_val |= EMAC_RX_CTL_DMA_EN;
+				writel(reg_val, db->membase + EMAC_RX_CTL_REG);
+				if (!emac_dma_inblk_32bit(db, skb, rdptr, rxlen))
+					break;
+
+				/* re enable cpu receive. then try to receive by emac_inblk_32bit */
+				reg_val = readl(db->membase + EMAC_RX_CTL_REG);
+				reg_val &= ~EMAC_RX_CTL_DMA_EN;
+				writel(reg_val, db->membase + EMAC_RX_CTL_REG);
+			}
+
 			emac_inblk_32bit(db->membase + EMAC_RX_IO_DATA_REG,
 					rdptr, rxlen);
 			dev->stats.rx_bytes += rxlen;
@@ -659,7 +794,12 @@ static irqreturn_t emac_interrupt(int irq, void *dev_id)
 		reg_val = readl(db->membase + EMAC_INT_CTL_REG);
 		reg_val |= (0xf << 0) | (0x01 << 8);
 		writel(reg_val, db->membase + EMAC_INT_CTL_REG);
+	} else {
+		reg_val = readl(db->membase + EMAC_INT_CTL_REG);
+		reg_val |= (0xf << 0);
+		writel(reg_val, db->membase + EMAC_INT_CTL_REG);
 	}
+
 	spin_unlock(&db->lock);
 
 	return IRQ_HANDLED;
@@ -764,6 +904,58 @@ static const struct net_device_ops emac_netdev_ops = {
 #endif
 };
 
+static int emac_configure_dma(struct emac_board_info *db)
+{
+	struct platform_device *pdev = db->pdev;
+	struct net_device *ndev = db->ndev;
+	struct dma_slave_config conf = {};
+	struct resource *regs;
+	int err = 0;
+
+	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!regs) {
+		netdev_err(ndev, "get io resource from device failed.\n");
+		err = -ENOMEM;
+		goto out_clear_chan;
+	}
+
+	netdev_info(ndev, "get io resource from device: 0x%x, size = %u\n",
+		    regs->start, resource_size(regs));
+	db->emac_rx_fifo = regs->start + EMAC_RX_IO_DATA_REG;
+
+	db->rx_chan = dma_request_chan(&pdev->dev, "rx");
+	if (IS_ERR(db->rx_chan)) {
+		netdev_err(ndev,
+			   "failed to request dma channel. dma is disabled\n");
+		err = PTR_ERR(db->rx_chan);
+		goto out_clear_chan;
+	}
+
+	conf.direction = DMA_DEV_TO_MEM;
+	conf.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+	conf.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+	conf.src_addr = db->emac_rx_fifo;
+	conf.dst_maxburst = 4;
+	conf.src_maxburst = 4;
+	conf.device_fc = false;
+
+	err = dmaengine_slave_config(db->rx_chan, &conf);
+	if (err) {
+		netdev_err(ndev, "config dma slave failed\n");
+		err = -EINVAL;
+		goto out_slave_configure_err;
+	}
+
+	return err;
+
+out_slave_configure_err:
+	dma_release_channel(db->rx_chan);
+
+out_clear_chan:
+	db->rx_chan = NULL;
+	return err;
+}
+
 /* Search EMAC board, allocate space and register it
  */
 static int emac_probe(struct platform_device *pdev)
@@ -806,6 +998,9 @@ static int emac_probe(struct platform_device *pdev)
 		goto out_iounmap;
 	}
 
+	if (emac_configure_dma(db))
+		netdev_info(ndev, "configure dma failed. disable dma.\n");
+
 	db->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(db->clk)) {
 		ret = PTR_ERR(db->clk);
@@ -888,6 +1083,11 @@ static int emac_remove(struct platform_device *pdev)
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct emac_board_info *db = netdev_priv(ndev);
 
+	if (db->rx_chan) {
+		dmaengine_terminate_all(db->rx_chan);
+		dma_release_channel(db->rx_chan);
+	}
+
 	unregister_netdev(ndev);
 	sunxi_sram_release(&pdev->dev);
 	clk_disable_unprepare(db->clk);
-- 
2.31.1

