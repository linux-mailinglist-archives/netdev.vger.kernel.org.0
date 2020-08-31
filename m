Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E4525807E
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 20:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729472AbgHaSNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 14:13:00 -0400
Received: from inva020.nxp.com ([92.121.34.13]:41084 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729199AbgHaSM6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Aug 2020 14:12:58 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 817D61A0A9C;
        Mon, 31 Aug 2020 20:12:48 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 70D531A0A8C;
        Mon, 31 Aug 2020 20:12:48 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 335AC20304;
        Mon, 31 Aug 2020 20:12:48 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 2/3] dpaa2-eth: add a dpaa2_eth_ prefix to all functions in dpaa2-eth.c
Date:   Mon, 31 Aug 2020 21:12:39 +0300
Message-Id: <20200831181240.21527-3-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200831181240.21527-1-ioana.ciornei@nxp.com>
References: <20200831181240.21527-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some static functions in the dpaa2-eth driver don't have the dpaa2_eth_
prefix and this is becoming an inconvenience when looking at, for
example, a perf top output and trying to determine easily which entries
are dpaa2-eth related. Ammend this by adding the prefix to all the
functions.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 400 +++++++++---------
 1 file changed, 200 insertions(+), 200 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 457106e761be..cb3083d2b4ab 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -40,9 +40,9 @@ static void *dpaa2_iova_to_virt(struct iommu_domain *domain,
 	return phys_to_virt(phys_addr);
 }
 
-static void validate_rx_csum(struct dpaa2_eth_priv *priv,
-			     u32 fd_status,
-			     struct sk_buff *skb)
+static void dpaa2_eth_validate_rx_csum(struct dpaa2_eth_priv *priv,
+				       u32 fd_status,
+				       struct sk_buff *skb)
 {
 	skb_checksum_none_assert(skb);
 
@@ -62,9 +62,9 @@ static void validate_rx_csum(struct dpaa2_eth_priv *priv,
 /* Free a received FD.
  * Not to be used for Tx conf FDs or on any other paths.
  */
-static void free_rx_fd(struct dpaa2_eth_priv *priv,
-		       const struct dpaa2_fd *fd,
-		       void *vaddr)
+static void dpaa2_eth_free_rx_fd(struct dpaa2_eth_priv *priv,
+				 const struct dpaa2_fd *fd,
+				 void *vaddr)
 {
 	struct device *dev = priv->net_dev->dev.parent;
 	dma_addr_t addr = dpaa2_fd_get_addr(fd);
@@ -100,9 +100,9 @@ static void free_rx_fd(struct dpaa2_eth_priv *priv,
 }
 
 /* Build a linear skb based on a single-buffer frame descriptor */
-static struct sk_buff *build_linear_skb(struct dpaa2_eth_channel *ch,
-					const struct dpaa2_fd *fd,
-					void *fd_vaddr)
+static struct sk_buff *dpaa2_eth_build_linear_skb(struct dpaa2_eth_channel *ch,
+						  const struct dpaa2_fd *fd,
+						  void *fd_vaddr)
 {
 	struct sk_buff *skb = NULL;
 	u16 fd_offset = dpaa2_fd_get_offset(fd);
@@ -121,9 +121,9 @@ static struct sk_buff *build_linear_skb(struct dpaa2_eth_channel *ch,
 }
 
 /* Build a non linear (fragmented) skb based on a S/G table */
-static struct sk_buff *build_frag_skb(struct dpaa2_eth_priv *priv,
-				      struct dpaa2_eth_channel *ch,
-				      struct dpaa2_sg_entry *sgt)
+static struct sk_buff *dpaa2_eth_build_frag_skb(struct dpaa2_eth_priv *priv,
+						struct dpaa2_eth_channel *ch,
+						struct dpaa2_sg_entry *sgt)
 {
 	struct sk_buff *skb = NULL;
 	struct device *dev = priv->net_dev->dev.parent;
@@ -204,7 +204,8 @@ static struct sk_buff *build_frag_skb(struct dpaa2_eth_priv *priv,
 /* Free buffers acquired from the buffer pool or which were meant to
  * be released in the pool
  */
-static void free_bufs(struct dpaa2_eth_priv *priv, u64 *buf_array, int count)
+static void dpaa2_eth_free_bufs(struct dpaa2_eth_priv *priv, u64 *buf_array,
+				int count)
 {
 	struct device *dev = priv->net_dev->dev.parent;
 	void *vaddr;
@@ -218,9 +219,9 @@ static void free_bufs(struct dpaa2_eth_priv *priv, u64 *buf_array, int count)
 	}
 }
 
-static void xdp_release_buf(struct dpaa2_eth_priv *priv,
-			    struct dpaa2_eth_channel *ch,
-			    dma_addr_t addr)
+static void dpaa2_eth_xdp_release_buf(struct dpaa2_eth_priv *priv,
+				      struct dpaa2_eth_channel *ch,
+				      dma_addr_t addr)
 {
 	int retries = 0;
 	int err;
@@ -238,7 +239,7 @@ static void xdp_release_buf(struct dpaa2_eth_priv *priv,
 	}
 
 	if (err) {
-		free_bufs(priv, ch->xdp.drop_bufs, ch->xdp.drop_cnt);
+		dpaa2_eth_free_bufs(priv, ch->xdp.drop_bufs, ch->xdp.drop_cnt);
 		ch->buf_count -= ch->xdp.drop_cnt;
 	}
 
@@ -274,9 +275,9 @@ static int dpaa2_eth_xdp_flush(struct dpaa2_eth_priv *priv,
 	return total_enqueued;
 }
 
-static void xdp_tx_flush(struct dpaa2_eth_priv *priv,
-			 struct dpaa2_eth_channel *ch,
-			 struct dpaa2_eth_fq *fq)
+static void dpaa2_eth_xdp_tx_flush(struct dpaa2_eth_priv *priv,
+				   struct dpaa2_eth_channel *ch,
+				   struct dpaa2_eth_fq *fq)
 {
 	struct rtnl_link_stats64 *percpu_stats;
 	struct dpaa2_fd *fds;
@@ -295,17 +296,17 @@ static void xdp_tx_flush(struct dpaa2_eth_priv *priv,
 		ch->stats.xdp_tx++;
 	}
 	for (i = enqueued; i < fq->xdp_tx_fds.num; i++) {
-		xdp_release_buf(priv, ch, dpaa2_fd_get_addr(&fds[i]));
+		dpaa2_eth_xdp_release_buf(priv, ch, dpaa2_fd_get_addr(&fds[i]));
 		percpu_stats->tx_errors++;
 		ch->stats.xdp_tx_err++;
 	}
 	fq->xdp_tx_fds.num = 0;
 }
 
-static void xdp_enqueue(struct dpaa2_eth_priv *priv,
-			struct dpaa2_eth_channel *ch,
-			struct dpaa2_fd *fd,
-			void *buf_start, u16 queue_id)
+static void dpaa2_eth_xdp_enqueue(struct dpaa2_eth_priv *priv,
+				  struct dpaa2_eth_channel *ch,
+				  struct dpaa2_fd *fd,
+				  void *buf_start, u16 queue_id)
 {
 	struct dpaa2_faead *faead;
 	struct dpaa2_fd *dest_fd;
@@ -333,13 +334,13 @@ static void xdp_enqueue(struct dpaa2_eth_priv *priv,
 	if (fq->xdp_tx_fds.num < DEV_MAP_BULK_SIZE)
 		return;
 
-	xdp_tx_flush(priv, ch, fq);
+	dpaa2_eth_xdp_tx_flush(priv, ch, fq);
 }
 
-static u32 run_xdp(struct dpaa2_eth_priv *priv,
-		   struct dpaa2_eth_channel *ch,
-		   struct dpaa2_eth_fq *rx_fq,
-		   struct dpaa2_fd *fd, void *vaddr)
+static u32 dpaa2_eth_run_xdp(struct dpaa2_eth_priv *priv,
+			     struct dpaa2_eth_channel *ch,
+			     struct dpaa2_eth_fq *rx_fq,
+			     struct dpaa2_fd *fd, void *vaddr)
 {
 	dma_addr_t addr = dpaa2_fd_get_addr(fd);
 	struct bpf_prog *xdp_prog;
@@ -372,7 +373,7 @@ static u32 run_xdp(struct dpaa2_eth_priv *priv,
 	case XDP_PASS:
 		break;
 	case XDP_TX:
-		xdp_enqueue(priv, ch, fd, vaddr, rx_fq->flowid);
+		dpaa2_eth_xdp_enqueue(priv, ch, fd, vaddr, rx_fq->flowid);
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(xdp_act);
@@ -381,7 +382,7 @@ static u32 run_xdp(struct dpaa2_eth_priv *priv,
 		trace_xdp_exception(priv->net_dev, xdp_prog, xdp_act);
 		/* fall through */
 	case XDP_DROP:
-		xdp_release_buf(priv, ch, addr);
+		dpaa2_eth_xdp_release_buf(priv, ch, addr);
 		ch->stats.xdp_drop++;
 		break;
 	case XDP_REDIRECT:
@@ -441,7 +442,7 @@ static void dpaa2_eth_rx(struct dpaa2_eth_priv *priv,
 	percpu_extras = this_cpu_ptr(priv->percpu_extras);
 
 	if (fd_format == dpaa2_fd_single) {
-		xdp_act = run_xdp(priv, ch, fq, (struct dpaa2_fd *)fd, vaddr);
+		xdp_act = dpaa2_eth_run_xdp(priv, ch, fq, (struct dpaa2_fd *)fd, vaddr);
 		if (xdp_act != XDP_PASS) {
 			percpu_stats->rx_packets++;
 			percpu_stats->rx_bytes += dpaa2_fd_get_len(fd);
@@ -450,13 +451,13 @@ static void dpaa2_eth_rx(struct dpaa2_eth_priv *priv,
 
 		dma_unmap_page(dev, addr, priv->rx_buf_size,
 			       DMA_BIDIRECTIONAL);
-		skb = build_linear_skb(ch, fd, vaddr);
+		skb = dpaa2_eth_build_linear_skb(ch, fd, vaddr);
 	} else if (fd_format == dpaa2_fd_sg) {
 		WARN_ON(priv->xdp_prog);
 
 		dma_unmap_page(dev, addr, priv->rx_buf_size,
 			       DMA_BIDIRECTIONAL);
-		skb = build_frag_skb(priv, ch, buf_data);
+		skb = dpaa2_eth_build_frag_skb(priv, ch, buf_data);
 		free_pages((unsigned long)vaddr, 0);
 		percpu_extras->rx_sg_frames++;
 		percpu_extras->rx_sg_bytes += dpaa2_fd_get_len(fd);
@@ -485,7 +486,7 @@ static void dpaa2_eth_rx(struct dpaa2_eth_priv *priv,
 	/* Check if we need to validate the L4 csum */
 	if (likely(dpaa2_fd_get_frc(fd) & DPAA2_FD_FRC_FASV)) {
 		status = le32_to_cpu(fas->status);
-		validate_rx_csum(priv, status, skb);
+		dpaa2_eth_validate_rx_csum(priv, status, skb);
 	}
 
 	skb->protocol = eth_type_trans(skb, priv->net_dev);
@@ -499,7 +500,7 @@ static void dpaa2_eth_rx(struct dpaa2_eth_priv *priv,
 	return;
 
 err_build_skb:
-	free_rx_fd(priv, fd, vaddr);
+	dpaa2_eth_free_rx_fd(priv, fd, vaddr);
 err_frame_format:
 	percpu_stats->rx_dropped++;
 }
@@ -510,8 +511,8 @@ static void dpaa2_eth_rx(struct dpaa2_eth_priv *priv,
  *
  * Observance of NAPI budget is not our concern, leaving that to the caller.
  */
-static int consume_frames(struct dpaa2_eth_channel *ch,
-			  struct dpaa2_eth_fq **src)
+static int dpaa2_eth_consume_frames(struct dpaa2_eth_channel *ch,
+				    struct dpaa2_eth_fq **src)
 {
 	struct dpaa2_eth_priv *priv = ch->priv;
 	struct dpaa2_eth_fq *fq = NULL;
@@ -560,7 +561,7 @@ static int consume_frames(struct dpaa2_eth_channel *ch,
 }
 
 /* Configure the egress frame annotation for timestamp update */
-static void enable_tx_tstamp(struct dpaa2_fd *fd, void *buf_start)
+static void dpaa2_eth_enable_tx_tstamp(struct dpaa2_fd *fd, void *buf_start)
 {
 	struct dpaa2_faead *faead;
 	u32 ctrl, frc;
@@ -582,9 +583,9 @@ static void enable_tx_tstamp(struct dpaa2_fd *fd, void *buf_start)
 }
 
 /* Create a frame descriptor based on a fragmented skb */
-static int build_sg_fd(struct dpaa2_eth_priv *priv,
-		       struct sk_buff *skb,
-		       struct dpaa2_fd *fd)
+static int dpaa2_eth_build_sg_fd(struct dpaa2_eth_priv *priv,
+				 struct sk_buff *skb,
+				 struct dpaa2_fd *fd)
 {
 	struct device *dev = priv->net_dev->dev.parent;
 	void *sgt_buf = NULL;
@@ -673,7 +674,7 @@ static int build_sg_fd(struct dpaa2_eth_priv *priv,
 	dpaa2_fd_set_ctrl(fd, FD_CTRL_PTA);
 
 	if (priv->tx_tstamp && skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)
-		enable_tx_tstamp(fd, sgt_buf);
+		dpaa2_eth_enable_tx_tstamp(fd, sgt_buf);
 
 	return 0;
 
@@ -692,9 +693,9 @@ static int build_sg_fd(struct dpaa2_eth_priv *priv,
  * enough for the HW requirements, thus instead of realloc-ing the skb we
  * create a SG frame descriptor with only one entry.
  */
-static int build_sg_fd_single_buf(struct dpaa2_eth_priv *priv,
-				  struct sk_buff *skb,
-				  struct dpaa2_fd *fd)
+static int dpaa2_eth_build_sg_fd_single_buf(struct dpaa2_eth_priv *priv,
+					    struct sk_buff *skb,
+					    struct dpaa2_fd *fd)
 {
 	struct device *dev = priv->net_dev->dev.parent;
 	struct dpaa2_eth_sgt_cache *sgt_cache;
@@ -751,7 +752,7 @@ static int build_sg_fd_single_buf(struct dpaa2_eth_priv *priv,
 	dpaa2_fd_set_ctrl(fd, FD_CTRL_PTA);
 
 	if (priv->tx_tstamp && skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)
-		enable_tx_tstamp(fd, sgt_buf);
+		dpaa2_eth_enable_tx_tstamp(fd, sgt_buf);
 
 	return 0;
 
@@ -767,9 +768,9 @@ static int build_sg_fd_single_buf(struct dpaa2_eth_priv *priv,
 }
 
 /* Create a frame descriptor based on a linear skb */
-static int build_single_fd(struct dpaa2_eth_priv *priv,
-			   struct sk_buff *skb,
-			   struct dpaa2_fd *fd)
+static int dpaa2_eth_build_single_fd(struct dpaa2_eth_priv *priv,
+				     struct sk_buff *skb,
+				     struct dpaa2_fd *fd)
 {
 	struct device *dev = priv->net_dev->dev.parent;
 	u8 *buffer_start, *aligned_start;
@@ -807,7 +808,7 @@ static int build_single_fd(struct dpaa2_eth_priv *priv,
 	dpaa2_fd_set_ctrl(fd, FD_CTRL_PTA);
 
 	if (priv->tx_tstamp && skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)
-		enable_tx_tstamp(fd, buffer_start);
+		dpaa2_eth_enable_tx_tstamp(fd, buffer_start);
 
 	return 0;
 }
@@ -819,9 +820,9 @@ static int build_single_fd(struct dpaa2_eth_priv *priv,
  * This can be called either from dpaa2_eth_tx_conf() or on the error path of
  * dpaa2_eth_tx().
  */
-static void free_tx_fd(const struct dpaa2_eth_priv *priv,
-		       struct dpaa2_eth_fq *fq,
-		       const struct dpaa2_fd *fd, bool in_napi)
+static void dpaa2_eth_free_tx_fd(const struct dpaa2_eth_priv *priv,
+				 struct dpaa2_eth_fq *fq,
+				 const struct dpaa2_fd *fd, bool in_napi)
 {
 	struct device *dev = priv->net_dev->dev.parent;
 	dma_addr_t fd_addr, sg_addr;
@@ -954,17 +955,17 @@ static netdev_tx_t dpaa2_eth_tx(struct sk_buff *skb, struct net_device *net_dev)
 	memset(&fd, 0, sizeof(fd));
 
 	if (skb_is_nonlinear(skb)) {
-		err = build_sg_fd(priv, skb, &fd);
+		err = dpaa2_eth_build_sg_fd(priv, skb, &fd);
 		percpu_extras->tx_sg_frames++;
 		percpu_extras->tx_sg_bytes += skb->len;
 	} else if (skb_headroom(skb) < needed_headroom) {
-		err = build_sg_fd_single_buf(priv, skb, &fd);
+		err = dpaa2_eth_build_sg_fd_single_buf(priv, skb, &fd);
 		percpu_extras->tx_sg_frames++;
 		percpu_extras->tx_sg_bytes += skb->len;
 		percpu_extras->tx_converted_sg_frames++;
 		percpu_extras->tx_converted_sg_bytes += skb->len;
 	} else {
-		err = build_single_fd(priv, skb, &fd);
+		err = dpaa2_eth_build_single_fd(priv, skb, &fd);
 	}
 
 	if (unlikely(err)) {
@@ -1010,7 +1011,7 @@ static netdev_tx_t dpaa2_eth_tx(struct sk_buff *skb, struct net_device *net_dev)
 	if (unlikely(err < 0)) {
 		percpu_stats->tx_errors++;
 		/* Clean up everything, including freeing the skb */
-		free_tx_fd(priv, fq, &fd, false);
+		dpaa2_eth_free_tx_fd(priv, fq, &fd, false);
 		netdev_tx_completed_queue(nq, 1, fd_len);
 	} else {
 		percpu_stats->tx_packets++;
@@ -1045,7 +1046,7 @@ static void dpaa2_eth_tx_conf(struct dpaa2_eth_priv *priv,
 
 	/* Check frame errors in the FD field */
 	fd_errors = dpaa2_fd_get_ctrl(fd) & DPAA2_FD_TX_ERR_MASK;
-	free_tx_fd(priv, fq, fd, true);
+	dpaa2_eth_free_tx_fd(priv, fq, fd, true);
 
 	if (likely(!fd_errors))
 		return;
@@ -1059,7 +1060,7 @@ static void dpaa2_eth_tx_conf(struct dpaa2_eth_priv *priv,
 	percpu_stats->tx_errors++;
 }
 
-static int set_rx_csum(struct dpaa2_eth_priv *priv, bool enable)
+static int dpaa2_eth_set_rx_csum(struct dpaa2_eth_priv *priv, bool enable)
 {
 	int err;
 
@@ -1082,7 +1083,7 @@ static int set_rx_csum(struct dpaa2_eth_priv *priv, bool enable)
 	return 0;
 }
 
-static int set_tx_csum(struct dpaa2_eth_priv *priv, bool enable)
+static int dpaa2_eth_set_tx_csum(struct dpaa2_eth_priv *priv, bool enable)
 {
 	int err;
 
@@ -1106,8 +1107,8 @@ static int set_tx_csum(struct dpaa2_eth_priv *priv, bool enable)
 /* Perform a single release command to add buffers
  * to the specified buffer pool
  */
-static int add_bufs(struct dpaa2_eth_priv *priv,
-		    struct dpaa2_eth_channel *ch, u16 bpid)
+static int dpaa2_eth_add_bufs(struct dpaa2_eth_priv *priv,
+			      struct dpaa2_eth_channel *ch, u16 bpid)
 {
 	struct device *dev = priv->net_dev->dev.parent;
 	u64 buf_array[DPAA2_ETH_BUFS_PER_CMD];
@@ -1155,7 +1156,7 @@ static int add_bufs(struct dpaa2_eth_priv *priv,
 	 * not much else we can do about it
 	 */
 	if (err) {
-		free_bufs(priv, buf_array, i);
+		dpaa2_eth_free_bufs(priv, buf_array, i);
 		return 0;
 	}
 
@@ -1173,7 +1174,7 @@ static int add_bufs(struct dpaa2_eth_priv *priv,
 	return 0;
 }
 
-static int seed_pool(struct dpaa2_eth_priv *priv, u16 bpid)
+static int dpaa2_eth_seed_pool(struct dpaa2_eth_priv *priv, u16 bpid)
 {
 	int i, j;
 	int new_count;
@@ -1181,7 +1182,7 @@ static int seed_pool(struct dpaa2_eth_priv *priv, u16 bpid)
 	for (j = 0; j < priv->num_channels; j++) {
 		for (i = 0; i < DPAA2_ETH_NUM_BUFS;
 		     i += DPAA2_ETH_BUFS_PER_CMD) {
-			new_count = add_bufs(priv, priv->channel[j], bpid);
+			new_count = dpaa2_eth_add_bufs(priv, priv->channel[j], bpid);
 			priv->channel[j]->buf_count += new_count;
 
 			if (new_count < DPAA2_ETH_BUFS_PER_CMD) {
@@ -1197,7 +1198,7 @@ static int seed_pool(struct dpaa2_eth_priv *priv, u16 bpid)
  * Drain the specified number of buffers from the DPNI's private buffer pool.
  * @count must not exceeed DPAA2_ETH_BUFS_PER_CMD
  */
-static void drain_bufs(struct dpaa2_eth_priv *priv, int count)
+static void dpaa2_eth_drain_bufs(struct dpaa2_eth_priv *priv, int count)
 {
 	u64 buf_array[DPAA2_ETH_BUFS_PER_CMD];
 	int retries = 0;
@@ -1213,17 +1214,17 @@ static void drain_bufs(struct dpaa2_eth_priv *priv, int count)
 			netdev_err(priv->net_dev, "dpaa2_io_service_acquire() failed\n");
 			return;
 		}
-		free_bufs(priv, buf_array, ret);
+		dpaa2_eth_free_bufs(priv, buf_array, ret);
 		retries = 0;
 	} while (ret);
 }
 
-static void drain_pool(struct dpaa2_eth_priv *priv)
+static void dpaa2_eth_drain_pool(struct dpaa2_eth_priv *priv)
 {
 	int i;
 
-	drain_bufs(priv, DPAA2_ETH_BUFS_PER_CMD);
-	drain_bufs(priv, 1);
+	dpaa2_eth_drain_bufs(priv, DPAA2_ETH_BUFS_PER_CMD);
+	dpaa2_eth_drain_bufs(priv, 1);
 
 	for (i = 0; i < priv->num_channels; i++)
 		priv->channel[i]->buf_count = 0;
@@ -1232,9 +1233,9 @@ static void drain_pool(struct dpaa2_eth_priv *priv)
 /* Function is called from softirq context only, so we don't need to guard
  * the access to percpu count
  */
-static int refill_pool(struct dpaa2_eth_priv *priv,
-		       struct dpaa2_eth_channel *ch,
-		       u16 bpid)
+static int dpaa2_eth_refill_pool(struct dpaa2_eth_priv *priv,
+				 struct dpaa2_eth_channel *ch,
+				 u16 bpid)
 {
 	int new_count;
 
@@ -1242,7 +1243,7 @@ static int refill_pool(struct dpaa2_eth_priv *priv,
 		return 0;
 
 	do {
-		new_count = add_bufs(priv, ch, bpid);
+		new_count = dpaa2_eth_add_bufs(priv, ch, bpid);
 		if (unlikely(!new_count)) {
 			/* Out of memory; abort for now, we'll try later on */
 			break;
@@ -1272,7 +1273,7 @@ static void dpaa2_eth_sgt_cache_drain(struct dpaa2_eth_priv *priv)
 	}
 }
 
-static int pull_channel(struct dpaa2_eth_channel *ch)
+static int dpaa2_eth_pull_channel(struct dpaa2_eth_channel *ch)
 {
 	int err;
 	int dequeues = -1;
@@ -1319,14 +1320,14 @@ static int dpaa2_eth_poll(struct napi_struct *napi, int budget)
 	ch->rx_list = &rx_list;
 
 	do {
-		err = pull_channel(ch);
+		err = dpaa2_eth_pull_channel(ch);
 		if (unlikely(err))
 			break;
 
 		/* Refill pool if appropriate */
-		refill_pool(priv, ch, priv->bpid);
+		dpaa2_eth_refill_pool(priv, ch, priv->bpid);
 
-		store_cleaned = consume_frames(ch, &fq);
+		store_cleaned = dpaa2_eth_consume_frames(ch, &fq);
 		if (store_cleaned <= 0)
 			break;
 		if (fq->type == DPAA2_RX_FQ) {
@@ -1375,12 +1376,12 @@ static int dpaa2_eth_poll(struct napi_struct *napi, int budget)
 	if (ch->xdp.res & XDP_REDIRECT)
 		xdp_do_flush_map();
 	else if (rx_cleaned && ch->xdp.res & XDP_TX)
-		xdp_tx_flush(priv, ch, &priv->fq[flowid]);
+		dpaa2_eth_xdp_tx_flush(priv, ch, &priv->fq[flowid]);
 
 	return work_done;
 }
 
-static void enable_ch_napi(struct dpaa2_eth_priv *priv)
+static void dpaa2_eth_enable_ch_napi(struct dpaa2_eth_priv *priv)
 {
 	struct dpaa2_eth_channel *ch;
 	int i;
@@ -1391,7 +1392,7 @@ static void enable_ch_napi(struct dpaa2_eth_priv *priv)
 	}
 }
 
-static void disable_ch_napi(struct dpaa2_eth_priv *priv)
+static void dpaa2_eth_disable_ch_napi(struct dpaa2_eth_priv *priv)
 {
 	struct dpaa2_eth_channel *ch;
 	int i;
@@ -1465,7 +1466,7 @@ void dpaa2_eth_set_rx_taildrop(struct dpaa2_eth_priv *priv,
 	priv->rx_cgtd_enabled = td.enable;
 }
 
-static int link_state_update(struct dpaa2_eth_priv *priv)
+static int dpaa2_eth_link_state_update(struct dpaa2_eth_priv *priv)
 {
 	struct dpni_link_state state = {0};
 	bool tx_pause;
@@ -1517,7 +1518,7 @@ static int dpaa2_eth_open(struct net_device *net_dev)
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
 	int err;
 
-	err = seed_pool(priv, priv->bpid);
+	err = dpaa2_eth_seed_pool(priv, priv->bpid);
 	if (err) {
 		/* Not much to do; the buffer pool, though not filled up,
 		 * may still contain some buffers which would enable us
@@ -1541,7 +1542,7 @@ static int dpaa2_eth_open(struct net_device *net_dev)
 		 */
 		netif_carrier_off(net_dev);
 	}
-	enable_ch_napi(priv);
+	dpaa2_eth_enable_ch_napi(priv);
 
 	err = dpni_enable(priv->mc_io, 0, priv->mc_token);
 	if (err < 0) {
@@ -1553,7 +1554,7 @@ static int dpaa2_eth_open(struct net_device *net_dev)
 		/* If the DPMAC object has already processed the link up
 		 * interrupt, we have to learn the link state ourselves.
 		 */
-		err = link_state_update(priv);
+		err = dpaa2_eth_link_state_update(priv);
 		if (err < 0) {
 			netdev_err(net_dev, "Can't update link state\n");
 			goto link_state_err;
@@ -1566,13 +1567,13 @@ static int dpaa2_eth_open(struct net_device *net_dev)
 
 link_state_err:
 enable_err:
-	disable_ch_napi(priv);
-	drain_pool(priv);
+	dpaa2_eth_disable_ch_napi(priv);
+	dpaa2_eth_drain_pool(priv);
 	return err;
 }
 
 /* Total number of in-flight frames on ingress queues */
-static u32 ingress_fq_count(struct dpaa2_eth_priv *priv)
+static u32 dpaa2_eth_ingress_fq_count(struct dpaa2_eth_priv *priv)
 {
 	struct dpaa2_eth_fq *fq;
 	u32 fcnt = 0, bcnt = 0, total = 0;
@@ -1591,13 +1592,13 @@ static u32 ingress_fq_count(struct dpaa2_eth_priv *priv)
 	return total;
 }
 
-static void wait_for_ingress_fq_empty(struct dpaa2_eth_priv *priv)
+static void dpaa2_eth_wait_for_ingress_fq_empty(struct dpaa2_eth_priv *priv)
 {
 	int retries = 10;
 	u32 pending;
 
 	do {
-		pending = ingress_fq_count(priv);
+		pending = dpaa2_eth_ingress_fq_count(priv);
 		if (pending)
 			msleep(100);
 	} while (pending && --retries);
@@ -1605,7 +1606,7 @@ static void wait_for_ingress_fq_empty(struct dpaa2_eth_priv *priv)
 
 #define DPNI_TX_PENDING_VER_MAJOR	7
 #define DPNI_TX_PENDING_VER_MINOR	13
-static void wait_for_egress_fq_empty(struct dpaa2_eth_priv *priv)
+static void dpaa2_eth_wait_for_egress_fq_empty(struct dpaa2_eth_priv *priv)
 {
 	union dpni_statistics stats;
 	int retries = 10;
@@ -1651,7 +1652,7 @@ static int dpaa2_eth_stop(struct net_device *net_dev)
 	 * on WRIOP. After it finishes, wait until all remaining frames on Rx
 	 * and Tx conf queues are consumed on NAPI poll.
 	 */
-	wait_for_egress_fq_empty(priv);
+	dpaa2_eth_wait_for_egress_fq_empty(priv);
 
 	do {
 		dpni_disable(priv->mc_io, 0, priv->mc_token);
@@ -1667,11 +1668,11 @@ static int dpaa2_eth_stop(struct net_device *net_dev)
 		 */
 	}
 
-	wait_for_ingress_fq_empty(priv);
-	disable_ch_napi(priv);
+	dpaa2_eth_wait_for_ingress_fq_empty(priv);
+	dpaa2_eth_disable_ch_napi(priv);
 
 	/* Empty the buffer pool */
-	drain_pool(priv);
+	dpaa2_eth_drain_pool(priv);
 
 	/* Empty the Scatter-Gather Buffer cache */
 	dpaa2_eth_sgt_cache_drain(priv);
@@ -1725,8 +1726,8 @@ static void dpaa2_eth_get_stats(struct net_device *net_dev,
 /* Copy mac unicast addresses from @net_dev to @priv.
  * Its sole purpose is to make dpaa2_eth_set_rx_mode() more readable.
  */
-static void add_uc_hw_addr(const struct net_device *net_dev,
-			   struct dpaa2_eth_priv *priv)
+static void dpaa2_eth_add_uc_hw_addr(const struct net_device *net_dev,
+				     struct dpaa2_eth_priv *priv)
 {
 	struct netdev_hw_addr *ha;
 	int err;
@@ -1744,8 +1745,8 @@ static void add_uc_hw_addr(const struct net_device *net_dev,
 /* Copy mac multicast addresses from @net_dev to @priv
  * Its sole purpose is to make dpaa2_eth_set_rx_mode() more readable.
  */
-static void add_mc_hw_addr(const struct net_device *net_dev,
-			   struct dpaa2_eth_priv *priv)
+static void dpaa2_eth_add_mc_hw_addr(const struct net_device *net_dev,
+				     struct dpaa2_eth_priv *priv)
 {
 	struct netdev_hw_addr *ha;
 	int err;
@@ -1810,7 +1811,7 @@ static void dpaa2_eth_set_rx_mode(struct net_device *net_dev)
 		err = dpni_clear_mac_filters(mc_io, 0, mc_token, 1, 0);
 		if (err)
 			netdev_warn(net_dev, "Can't clear uc filters\n");
-		add_uc_hw_addr(net_dev, priv);
+		dpaa2_eth_add_uc_hw_addr(net_dev, priv);
 
 		/* Finally, clear uc promisc and set mc promisc as requested. */
 		err = dpni_set_unicast_promisc(mc_io, 0, mc_token, 0);
@@ -1833,8 +1834,8 @@ static void dpaa2_eth_set_rx_mode(struct net_device *net_dev)
 	err = dpni_clear_mac_filters(mc_io, 0, mc_token, 1, 1);
 	if (err)
 		netdev_warn(net_dev, "Can't clear mac filters\n");
-	add_mc_hw_addr(net_dev, priv);
-	add_uc_hw_addr(net_dev, priv);
+	dpaa2_eth_add_mc_hw_addr(net_dev, priv);
+	dpaa2_eth_add_uc_hw_addr(net_dev, priv);
 
 	/* Now we can clear both ucast and mcast promisc, without risking
 	 * to drop legitimate frames anymore.
@@ -1868,14 +1869,14 @@ static int dpaa2_eth_set_features(struct net_device *net_dev,
 
 	if (changed & NETIF_F_RXCSUM) {
 		enable = !!(features & NETIF_F_RXCSUM);
-		err = set_rx_csum(priv, enable);
+		err = dpaa2_eth_set_rx_csum(priv, enable);
 		if (err)
 			return err;
 	}
 
 	if (changed & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)) {
 		enable = !!(features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM));
-		err = set_tx_csum(priv, enable);
+		err = dpaa2_eth_set_tx_csum(priv, enable);
 		if (err)
 			return err;
 	}
@@ -1944,7 +1945,7 @@ static bool xdp_mtu_valid(struct dpaa2_eth_priv *priv, int mtu)
 	return true;
 }
 
-static int set_rx_mfl(struct dpaa2_eth_priv *priv, int mtu, bool has_xdp)
+static int dpaa2_eth_set_rx_mfl(struct dpaa2_eth_priv *priv, int mtu, bool has_xdp)
 {
 	int mfl, err;
 
@@ -1978,7 +1979,7 @@ static int dpaa2_eth_change_mtu(struct net_device *dev, int new_mtu)
 	if (!xdp_mtu_valid(priv, new_mtu))
 		return -EINVAL;
 
-	err = set_rx_mfl(priv, new_mtu, true);
+	err = dpaa2_eth_set_rx_mfl(priv, new_mtu, true);
 	if (err)
 		return err;
 
@@ -1987,7 +1988,7 @@ static int dpaa2_eth_change_mtu(struct net_device *dev, int new_mtu)
 	return 0;
 }
 
-static int update_rx_buffer_headroom(struct dpaa2_eth_priv *priv, bool has_xdp)
+static int dpaa2_eth_update_rx_buffer_headroom(struct dpaa2_eth_priv *priv, bool has_xdp)
 {
 	struct dpni_buffer_layout buf_layout = {0};
 	int err;
@@ -2013,7 +2014,7 @@ static int update_rx_buffer_headroom(struct dpaa2_eth_priv *priv, bool has_xdp)
 	return 0;
 }
 
-static int setup_xdp(struct net_device *dev, struct bpf_prog *prog)
+static int dpaa2_eth_setup_xdp(struct net_device *dev, struct bpf_prog *prog)
 {
 	struct dpaa2_eth_priv *priv = netdev_priv(dev);
 	struct dpaa2_eth_channel *ch;
@@ -2039,10 +2040,10 @@ static int setup_xdp(struct net_device *dev, struct bpf_prog *prog)
 	 * so we are sure no old format buffers will be used from now on.
 	 */
 	if (need_update) {
-		err = set_rx_mfl(priv, dev->mtu, !!prog);
+		err = dpaa2_eth_set_rx_mfl(priv, dev->mtu, !!prog);
 		if (err)
 			goto out_err;
-		err = update_rx_buffer_headroom(priv, !!prog);
+		err = dpaa2_eth_update_rx_buffer_headroom(priv, !!prog);
 		if (err)
 			goto out_err;
 	}
@@ -2079,7 +2080,7 @@ static int dpaa2_eth_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 {
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
-		return setup_xdp(dev, xdp->prog);
+		return dpaa2_eth_setup_xdp(dev, xdp->prog);
 	default:
 		return -EINVAL;
 	}
@@ -2316,7 +2317,7 @@ static const struct net_device_ops dpaa2_eth_ops = {
 	.ndo_setup_tc = dpaa2_eth_setup_tc,
 };
 
-static void cdan_cb(struct dpaa2_io_notification_ctx *ctx)
+static void dpaa2_eth_cdan_cb(struct dpaa2_io_notification_ctx *ctx)
 {
 	struct dpaa2_eth_channel *ch;
 
@@ -2329,7 +2330,7 @@ static void cdan_cb(struct dpaa2_io_notification_ctx *ctx)
 }
 
 /* Allocate and configure a DPCON object */
-static struct fsl_mc_device *setup_dpcon(struct dpaa2_eth_priv *priv)
+static struct fsl_mc_device *dpaa2_eth_setup_dpcon(struct dpaa2_eth_priv *priv)
 {
 	struct fsl_mc_device *dpcon;
 	struct device *dev = priv->net_dev->dev.parent;
@@ -2373,16 +2374,15 @@ static struct fsl_mc_device *setup_dpcon(struct dpaa2_eth_priv *priv)
 	return ERR_PTR(err);
 }
 
-static void free_dpcon(struct dpaa2_eth_priv *priv,
-		       struct fsl_mc_device *dpcon)
+static void dpaa2_eth_free_dpcon(struct dpaa2_eth_priv *priv,
+				 struct fsl_mc_device *dpcon)
 {
 	dpcon_disable(priv->mc_io, 0, dpcon->mc_handle);
 	dpcon_close(priv->mc_io, 0, dpcon->mc_handle);
 	fsl_mc_object_free(dpcon);
 }
 
-static struct dpaa2_eth_channel *
-alloc_channel(struct dpaa2_eth_priv *priv)
+static struct dpaa2_eth_channel *dpaa2_eth_alloc_channel(struct dpaa2_eth_priv *priv)
 {
 	struct dpaa2_eth_channel *channel;
 	struct dpcon_attr attr;
@@ -2393,7 +2393,7 @@ alloc_channel(struct dpaa2_eth_priv *priv)
 	if (!channel)
 		return NULL;
 
-	channel->dpcon = setup_dpcon(priv);
+	channel->dpcon = dpaa2_eth_setup_dpcon(priv);
 	if (IS_ERR(channel->dpcon)) {
 		err = PTR_ERR(channel->dpcon);
 		goto err_setup;
@@ -2413,23 +2413,23 @@ alloc_channel(struct dpaa2_eth_priv *priv)
 	return channel;
 
 err_get_attr:
-	free_dpcon(priv, channel->dpcon);
+	dpaa2_eth_free_dpcon(priv, channel->dpcon);
 err_setup:
 	kfree(channel);
 	return ERR_PTR(err);
 }
 
-static void free_channel(struct dpaa2_eth_priv *priv,
-			 struct dpaa2_eth_channel *channel)
+static void dpaa2_eth_free_channel(struct dpaa2_eth_priv *priv,
+				   struct dpaa2_eth_channel *channel)
 {
-	free_dpcon(priv, channel->dpcon);
+	dpaa2_eth_free_dpcon(priv, channel->dpcon);
 	kfree(channel);
 }
 
 /* DPIO setup: allocate and configure QBMan channels, setup core affinity
  * and register data availability notifications
  */
-static int setup_dpio(struct dpaa2_eth_priv *priv)
+static int dpaa2_eth_setup_dpio(struct dpaa2_eth_priv *priv)
 {
 	struct dpaa2_io_notification_ctx *nctx;
 	struct dpaa2_eth_channel *channel;
@@ -2449,7 +2449,7 @@ static int setup_dpio(struct dpaa2_eth_priv *priv)
 	cpumask_clear(&priv->dpio_cpumask);
 	for_each_online_cpu(i) {
 		/* Try to allocate a channel */
-		channel = alloc_channel(priv);
+		channel = dpaa2_eth_alloc_channel(priv);
 		if (IS_ERR_OR_NULL(channel)) {
 			err = PTR_ERR_OR_ZERO(channel);
 			if (err != -EPROBE_DEFER)
@@ -2462,7 +2462,7 @@ static int setup_dpio(struct dpaa2_eth_priv *priv)
 
 		nctx = &channel->nctx;
 		nctx->is_cdan = 1;
-		nctx->cb = cdan_cb;
+		nctx->cb = dpaa2_eth_cdan_cb;
 		nctx->id = channel->ch_id;
 		nctx->desired_cpu = i;
 
@@ -2510,14 +2510,14 @@ static int setup_dpio(struct dpaa2_eth_priv *priv)
 err_set_cdan:
 	dpaa2_io_service_deregister(channel->dpio, nctx, dev);
 err_service_reg:
-	free_channel(priv, channel);
+	dpaa2_eth_free_channel(priv, channel);
 err_alloc_ch:
 	if (err == -EPROBE_DEFER) {
 		for (i = 0; i < priv->num_channels; i++) {
 			channel = priv->channel[i];
 			nctx = &channel->nctx;
 			dpaa2_io_service_deregister(channel->dpio, nctx, dev);
-			free_channel(priv, channel);
+			dpaa2_eth_free_channel(priv, channel);
 		}
 		priv->num_channels = 0;
 		return err;
@@ -2534,7 +2534,7 @@ static int setup_dpio(struct dpaa2_eth_priv *priv)
 	return 0;
 }
 
-static void free_dpio(struct dpaa2_eth_priv *priv)
+static void dpaa2_eth_free_dpio(struct dpaa2_eth_priv *priv)
 {
 	struct device *dev = priv->net_dev->dev.parent;
 	struct dpaa2_eth_channel *ch;
@@ -2544,12 +2544,12 @@ static void free_dpio(struct dpaa2_eth_priv *priv)
 	for (i = 0; i < priv->num_channels; i++) {
 		ch = priv->channel[i];
 		dpaa2_io_service_deregister(ch->dpio, &ch->nctx, dev);
-		free_channel(priv, ch);
+		dpaa2_eth_free_channel(priv, ch);
 	}
 }
 
-static struct dpaa2_eth_channel *get_affine_channel(struct dpaa2_eth_priv *priv,
-						    int cpu)
+static struct dpaa2_eth_channel *dpaa2_eth_get_affine_channel(struct dpaa2_eth_priv *priv,
+							      int cpu)
 {
 	struct device *dev = priv->net_dev->dev.parent;
 	int i;
@@ -2566,7 +2566,7 @@ static struct dpaa2_eth_channel *get_affine_channel(struct dpaa2_eth_priv *priv,
 	return priv->channel[0];
 }
 
-static void set_fq_affinity(struct dpaa2_eth_priv *priv)
+static void dpaa2_eth_set_fq_affinity(struct dpaa2_eth_priv *priv)
 {
 	struct device *dev = priv->net_dev->dev.parent;
 	struct dpaa2_eth_fq *fq;
@@ -2597,13 +2597,13 @@ static void set_fq_affinity(struct dpaa2_eth_priv *priv)
 		default:
 			dev_err(dev, "Unknown FQ type: %d\n", fq->type);
 		}
-		fq->channel = get_affine_channel(priv, fq->target_cpu);
+		fq->channel = dpaa2_eth_get_affine_channel(priv, fq->target_cpu);
 	}
 
 	update_xps(priv);
 }
 
-static void setup_fqs(struct dpaa2_eth_priv *priv)
+static void dpaa2_eth_setup_fqs(struct dpaa2_eth_priv *priv)
 {
 	int i, j;
 
@@ -2627,11 +2627,11 @@ static void setup_fqs(struct dpaa2_eth_priv *priv)
 	}
 
 	/* For each FQ, decide on which core to process incoming frames */
-	set_fq_affinity(priv);
+	dpaa2_eth_set_fq_affinity(priv);
 }
 
 /* Allocate and configure one buffer pool for each interface */
-static int setup_dpbp(struct dpaa2_eth_priv *priv)
+static int dpaa2_eth_setup_dpbp(struct dpaa2_eth_priv *priv)
 {
 	int err;
 	struct fsl_mc_device *dpbp_dev;
@@ -2690,15 +2690,15 @@ static int setup_dpbp(struct dpaa2_eth_priv *priv)
 	return err;
 }
 
-static void free_dpbp(struct dpaa2_eth_priv *priv)
+static void dpaa2_eth_free_dpbp(struct dpaa2_eth_priv *priv)
 {
-	drain_pool(priv);
+	dpaa2_eth_drain_pool(priv);
 	dpbp_disable(priv->mc_io, 0, priv->dpbp_dev->mc_handle);
 	dpbp_close(priv->mc_io, 0, priv->dpbp_dev->mc_handle);
 	fsl_mc_object_free(priv->dpbp_dev);
 }
 
-static int set_buffer_layout(struct dpaa2_eth_priv *priv)
+static int dpaa2_eth_set_buffer_layout(struct dpaa2_eth_priv *priv)
 {
 	struct device *dev = priv->net_dev->dev.parent;
 	struct dpni_buffer_layout buf_layout = {0};
@@ -2815,7 +2815,7 @@ static inline int dpaa2_eth_enqueue_fq_multiple(struct dpaa2_eth_priv *priv,
 	return 0;
 }
 
-static void set_enqueue_mode(struct dpaa2_eth_priv *priv)
+static void dpaa2_eth_set_enqueue_mode(struct dpaa2_eth_priv *priv)
 {
 	if (dpaa2_eth_cmp_dpni_ver(priv, DPNI_ENQUEUE_FQID_VER_MAJOR,
 				   DPNI_ENQUEUE_FQID_VER_MINOR) < 0)
@@ -2824,7 +2824,7 @@ static void set_enqueue_mode(struct dpaa2_eth_priv *priv)
 		priv->enqueue = dpaa2_eth_enqueue_fq_multiple;
 }
 
-static int set_pause(struct dpaa2_eth_priv *priv)
+static int dpaa2_eth_set_pause(struct dpaa2_eth_priv *priv)
 {
 	struct device *dev = priv->net_dev->dev.parent;
 	struct dpni_link_cfg link_cfg = {0};
@@ -2851,7 +2851,7 @@ static int set_pause(struct dpaa2_eth_priv *priv)
 	return 0;
 }
 
-static void update_tx_fqids(struct dpaa2_eth_priv *priv)
+static void dpaa2_eth_update_tx_fqids(struct dpaa2_eth_priv *priv)
 {
 	struct dpni_queue_id qid = {0};
 	struct dpaa2_eth_fq *fq;
@@ -2893,7 +2893,7 @@ static void update_tx_fqids(struct dpaa2_eth_priv *priv)
 }
 
 /* Configure ingress classification based on VLAN PCP */
-static int set_vlan_qos(struct dpaa2_eth_priv *priv)
+static int dpaa2_eth_set_vlan_qos(struct dpaa2_eth_priv *priv)
 {
 	struct device *dev = priv->net_dev->dev.parent;
 	struct dpkg_profile_cfg kg_cfg = {0};
@@ -3005,7 +3005,7 @@ static int set_vlan_qos(struct dpaa2_eth_priv *priv)
 }
 
 /* Configure the DPNI object this interface is associated with */
-static int setup_dpni(struct fsl_mc_device *ls_dev)
+static int dpaa2_eth_setup_dpni(struct fsl_mc_device *ls_dev)
 {
 	struct device *dev = &ls_dev->dev;
 	struct dpaa2_eth_priv *priv;
@@ -3053,20 +3053,20 @@ static int setup_dpni(struct fsl_mc_device *ls_dev)
 		goto close;
 	}
 
-	err = set_buffer_layout(priv);
+	err = dpaa2_eth_set_buffer_layout(priv);
 	if (err)
 		goto close;
 
-	set_enqueue_mode(priv);
+	dpaa2_eth_set_enqueue_mode(priv);
 
 	/* Enable pause frame support */
 	if (dpaa2_eth_has_pause_support(priv)) {
-		err = set_pause(priv);
+		err = dpaa2_eth_set_pause(priv);
 		if (err)
 			goto close;
 	}
 
-	err = set_vlan_qos(priv);
+	err = dpaa2_eth_set_vlan_qos(priv);
 	if (err && err != -EOPNOTSUPP)
 		goto close;
 
@@ -3086,7 +3086,7 @@ static int setup_dpni(struct fsl_mc_device *ls_dev)
 	return err;
 }
 
-static void free_dpni(struct dpaa2_eth_priv *priv)
+static void dpaa2_eth_free_dpni(struct dpaa2_eth_priv *priv)
 {
 	int err;
 
@@ -3098,8 +3098,8 @@ static void free_dpni(struct dpaa2_eth_priv *priv)
 	dpni_close(priv->mc_io, 0, priv->mc_token);
 }
 
-static int setup_rx_flow(struct dpaa2_eth_priv *priv,
-			 struct dpaa2_eth_fq *fq)
+static int dpaa2_eth_setup_rx_flow(struct dpaa2_eth_priv *priv,
+				   struct dpaa2_eth_fq *fq)
 {
 	struct device *dev = priv->net_dev->dev.parent;
 	struct dpni_queue queue;
@@ -3150,8 +3150,8 @@ static int setup_rx_flow(struct dpaa2_eth_priv *priv,
 	return 0;
 }
 
-static int setup_tx_flow(struct dpaa2_eth_priv *priv,
-			 struct dpaa2_eth_fq *fq)
+static int dpaa2_eth_setup_tx_flow(struct dpaa2_eth_priv *priv,
+				   struct dpaa2_eth_fq *fq)
 {
 	struct device *dev = priv->net_dev->dev.parent;
 	struct dpni_queue queue;
@@ -3266,7 +3266,7 @@ static const struct dpaa2_eth_dist_fields dist_fields[] = {
 };
 
 /* Configure the Rx hash key using the legacy API */
-static int config_legacy_hash_key(struct dpaa2_eth_priv *priv, dma_addr_t key)
+static int dpaa2_eth_config_legacy_hash_key(struct dpaa2_eth_priv *priv, dma_addr_t key)
 {
 	struct device *dev = priv->net_dev->dev.parent;
 	struct dpni_rx_tc_dist_cfg dist_cfg;
@@ -3291,7 +3291,7 @@ static int config_legacy_hash_key(struct dpaa2_eth_priv *priv, dma_addr_t key)
 }
 
 /* Configure the Rx hash key using the new API */
-static int config_hash_key(struct dpaa2_eth_priv *priv, dma_addr_t key)
+static int dpaa2_eth_config_hash_key(struct dpaa2_eth_priv *priv, dma_addr_t key)
 {
 	struct device *dev = priv->net_dev->dev.parent;
 	struct dpni_rx_dist_cfg dist_cfg;
@@ -3317,7 +3317,7 @@ static int config_hash_key(struct dpaa2_eth_priv *priv, dma_addr_t key)
 }
 
 /* Configure the Rx flow classification key */
-static int config_cls_key(struct dpaa2_eth_priv *priv, dma_addr_t key)
+static int dpaa2_eth_config_cls_key(struct dpaa2_eth_priv *priv, dma_addr_t key)
 {
 	struct device *dev = priv->net_dev->dev.parent;
 	struct dpni_rx_dist_cfg dist_cfg;
@@ -3452,11 +3452,11 @@ static int dpaa2_eth_set_dist_key(struct net_device *net_dev,
 
 	if (type == DPAA2_ETH_RX_DIST_HASH) {
 		if (dpaa2_eth_has_legacy_dist(priv))
-			err = config_legacy_hash_key(priv, key_iova);
+			err = dpaa2_eth_config_legacy_hash_key(priv, key_iova);
 		else
-			err = config_hash_key(priv, key_iova);
+			err = dpaa2_eth_config_hash_key(priv, key_iova);
 	} else {
-		err = config_cls_key(priv, key_iova);
+		err = dpaa2_eth_config_cls_key(priv, key_iova);
 	}
 
 	dma_unmap_single(dev, key_iova, DPAA2_CLASSIFIER_DMA_SIZE,
@@ -3531,7 +3531,7 @@ static int dpaa2_eth_set_default_cls(struct dpaa2_eth_priv *priv)
 /* Bind the DPNI to its needed objects and resources: buffer pool, DPIOs,
  * frame queues and channels
  */
-static int bind_dpni(struct dpaa2_eth_priv *priv)
+static int dpaa2_eth_bind_dpni(struct dpaa2_eth_priv *priv)
 {
 	struct net_device *net_dev = priv->net_dev;
 	struct device *dev = net_dev->dev.parent;
@@ -3579,10 +3579,10 @@ static int bind_dpni(struct dpaa2_eth_priv *priv)
 	for (i = 0; i < priv->num_fqs; i++) {
 		switch (priv->fq[i].type) {
 		case DPAA2_RX_FQ:
-			err = setup_rx_flow(priv, &priv->fq[i]);
+			err = dpaa2_eth_setup_rx_flow(priv, &priv->fq[i]);
 			break;
 		case DPAA2_TX_CONF_FQ:
-			err = setup_tx_flow(priv, &priv->fq[i]);
+			err = dpaa2_eth_setup_tx_flow(priv, &priv->fq[i]);
 			break;
 		default:
 			dev_err(dev, "Invalid FQ type %d\n", priv->fq[i].type);
@@ -3603,7 +3603,7 @@ static int bind_dpni(struct dpaa2_eth_priv *priv)
 }
 
 /* Allocate rings for storing incoming frame descriptors */
-static int alloc_rings(struct dpaa2_eth_priv *priv)
+static int dpaa2_eth_alloc_rings(struct dpaa2_eth_priv *priv)
 {
 	struct net_device *net_dev = priv->net_dev;
 	struct device *dev = net_dev->dev.parent;
@@ -3630,7 +3630,7 @@ static int alloc_rings(struct dpaa2_eth_priv *priv)
 	return -ENOMEM;
 }
 
-static void free_rings(struct dpaa2_eth_priv *priv)
+static void dpaa2_eth_free_rings(struct dpaa2_eth_priv *priv)
 {
 	int i;
 
@@ -3638,7 +3638,7 @@ static void free_rings(struct dpaa2_eth_priv *priv)
 		dpaa2_io_store_destroy(priv->channel[i]->store);
 }
 
-static int set_mac_addr(struct dpaa2_eth_priv *priv)
+static int dpaa2_eth_set_mac_addr(struct dpaa2_eth_priv *priv)
 {
 	struct net_device *net_dev = priv->net_dev;
 	struct device *dev = net_dev->dev.parent;
@@ -3703,7 +3703,7 @@ static int set_mac_addr(struct dpaa2_eth_priv *priv)
 	return 0;
 }
 
-static int netdev_init(struct net_device *net_dev)
+static int dpaa2_eth_netdev_init(struct net_device *net_dev)
 {
 	struct device *dev = net_dev->dev.parent;
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
@@ -3716,7 +3716,7 @@ static int netdev_init(struct net_device *net_dev)
 	net_dev->netdev_ops = &dpaa2_eth_ops;
 	net_dev->ethtool_ops = &dpaa2_ethtool_ops;
 
-	err = set_mac_addr(priv);
+	err = dpaa2_eth_set_mac_addr(priv);
 	if (err)
 		return err;
 
@@ -3771,13 +3771,13 @@ static int netdev_init(struct net_device *net_dev)
 	return 0;
 }
 
-static int poll_link_state(void *arg)
+static int dpaa2_eth_poll_link_state(void *arg)
 {
 	struct dpaa2_eth_priv *priv = (struct dpaa2_eth_priv *)arg;
 	int err;
 
 	while (!kthread_should_stop()) {
-		err = link_state_update(priv);
+		err = dpaa2_eth_link_state_update(priv);
 		if (unlikely(err))
 			return err;
 
@@ -3847,11 +3847,11 @@ static irqreturn_t dpni_irq0_handler_thread(int irq_num, void *arg)
 	}
 
 	if (status & DPNI_IRQ_EVENT_LINK_CHANGED)
-		link_state_update(netdev_priv(net_dev));
+		dpaa2_eth_link_state_update(netdev_priv(net_dev));
 
 	if (status & DPNI_IRQ_EVENT_ENDPOINT_CHANGED) {
-		set_mac_addr(netdev_priv(net_dev));
-		update_tx_fqids(priv);
+		dpaa2_eth_set_mac_addr(netdev_priv(net_dev));
+		dpaa2_eth_update_tx_fqids(priv);
 
 		rtnl_lock();
 		if (priv->mac)
@@ -3864,7 +3864,7 @@ static irqreturn_t dpni_irq0_handler_thread(int irq_num, void *arg)
 	return IRQ_HANDLED;
 }
 
-static int setup_irqs(struct fsl_mc_device *ls_dev)
+static int dpaa2_eth_setup_irqs(struct fsl_mc_device *ls_dev)
 {
 	int err = 0;
 	struct fsl_mc_device_irq *irq;
@@ -3910,7 +3910,7 @@ static int setup_irqs(struct fsl_mc_device *ls_dev)
 	return err;
 }
 
-static void add_ch_napi(struct dpaa2_eth_priv *priv)
+static void dpaa2_eth_add_ch_napi(struct dpaa2_eth_priv *priv)
 {
 	int i;
 	struct dpaa2_eth_channel *ch;
@@ -3923,7 +3923,7 @@ static void add_ch_napi(struct dpaa2_eth_priv *priv)
 	}
 }
 
-static void del_ch_napi(struct dpaa2_eth_priv *priv)
+static void dpaa2_eth_del_ch_napi(struct dpaa2_eth_priv *priv)
 {
 	int i;
 	struct dpaa2_eth_channel *ch;
@@ -3970,26 +3970,26 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 	}
 
 	/* MC objects initialization and configuration */
-	err = setup_dpni(dpni_dev);
+	err = dpaa2_eth_setup_dpni(dpni_dev);
 	if (err)
 		goto err_dpni_setup;
 
-	err = setup_dpio(priv);
+	err = dpaa2_eth_setup_dpio(priv);
 	if (err)
 		goto err_dpio_setup;
 
-	setup_fqs(priv);
+	dpaa2_eth_setup_fqs(priv);
 
-	err = setup_dpbp(priv);
+	err = dpaa2_eth_setup_dpbp(priv);
 	if (err)
 		goto err_dpbp_setup;
 
-	err = bind_dpni(priv);
+	err = dpaa2_eth_bind_dpni(priv);
 	if (err)
 		goto err_bind;
 
 	/* Add a NAPI context for each channel */
-	add_ch_napi(priv);
+	dpaa2_eth_add_ch_napi(priv);
 
 	/* Percpu statistics */
 	priv->percpu_stats = alloc_percpu(*priv->percpu_stats);
@@ -4012,21 +4012,21 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 		goto err_alloc_sgt_cache;
 	}
 
-	err = netdev_init(net_dev);
+	err = dpaa2_eth_netdev_init(net_dev);
 	if (err)
 		goto err_netdev_init;
 
 	/* Configure checksum offload based on current interface flags */
-	err = set_rx_csum(priv, !!(net_dev->features & NETIF_F_RXCSUM));
+	err = dpaa2_eth_set_rx_csum(priv, !!(net_dev->features & NETIF_F_RXCSUM));
 	if (err)
 		goto err_csum;
 
-	err = set_tx_csum(priv, !!(net_dev->features &
-				   (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)));
+	err = dpaa2_eth_set_tx_csum(priv,
+				    !!(net_dev->features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)));
 	if (err)
 		goto err_csum;
 
-	err = alloc_rings(priv);
+	err = dpaa2_eth_alloc_rings(priv);
 	if (err)
 		goto err_alloc_rings;
 
@@ -4039,10 +4039,10 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 	}
 #endif
 
-	err = setup_irqs(dpni_dev);
+	err = dpaa2_eth_setup_irqs(dpni_dev);
 	if (err) {
 		netdev_warn(net_dev, "Failed to set link interrupt, fall back to polling\n");
-		priv->poll_thread = kthread_run(poll_link_state, priv,
+		priv->poll_thread = kthread_run(dpaa2_eth_poll_link_state, priv,
 						"%s_poll_link", net_dev->name);
 		if (IS_ERR(priv->poll_thread)) {
 			dev_err(dev, "Error starting polling thread\n");
@@ -4076,7 +4076,7 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 	else
 		fsl_mc_free_irqs(dpni_dev);
 err_poll_thread:
-	free_rings(priv);
+	dpaa2_eth_free_rings(priv);
 err_alloc_rings:
 err_csum:
 err_netdev_init:
@@ -4086,13 +4086,13 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 err_alloc_percpu_extras:
 	free_percpu(priv->percpu_stats);
 err_alloc_percpu_stats:
-	del_ch_napi(priv);
+	dpaa2_eth_del_ch_napi(priv);
 err_bind:
-	free_dpbp(priv);
+	dpaa2_eth_free_dpbp(priv);
 err_dpbp_setup:
-	free_dpio(priv);
+	dpaa2_eth_free_dpio(priv);
 err_dpio_setup:
-	free_dpni(priv);
+	dpaa2_eth_free_dpni(priv);
 err_dpni_setup:
 	fsl_mc_portal_free(priv->mc_io);
 err_portal_alloc:
@@ -4126,15 +4126,15 @@ static int dpaa2_eth_remove(struct fsl_mc_device *ls_dev)
 	else
 		fsl_mc_free_irqs(ls_dev);
 
-	free_rings(priv);
+	dpaa2_eth_free_rings(priv);
 	free_percpu(priv->sgt_cache);
 	free_percpu(priv->percpu_stats);
 	free_percpu(priv->percpu_extras);
 
-	del_ch_napi(priv);
-	free_dpbp(priv);
-	free_dpio(priv);
-	free_dpni(priv);
+	dpaa2_eth_del_ch_napi(priv);
+	dpaa2_eth_free_dpbp(priv);
+	dpaa2_eth_free_dpio(priv);
+	dpaa2_eth_free_dpni(priv);
 
 	fsl_mc_portal_free(priv->mc_io);
 
-- 
2.25.1

