Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A48C82B0445
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 12:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbgKLLrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 06:47:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728062AbgKLLlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 06:41:51 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2955DC061A04;
        Thu, 12 Nov 2020 03:41:51 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id b63so671963pfg.12;
        Thu, 12 Nov 2020 03:41:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nYskcLFyc6szi7Z9xpAptKa+a4JeRd4qlkl7qFKCSsw=;
        b=CnIKVXFYMGIypsRSiIEmXq88iabHd5Ois/6P8SWz6BwxeRgJEaaTXD0nJWn0LUya/D
         JETb+UqA5Vba8MvT6YlJpU/NYIyl5LCfOD6Rp1O2fJjLTNP7ie9yRa9qZHfyxNeNMyaY
         YcyD8SEcAjSO/NXRodrftbn5GsjE9OeyzRk4lRDjfhCvfnnrlO0Y5LqDyGwQS25lgtS4
         C76/I1JfXkhjA6mCH9bNyWd9BKQkPpXdzP+bW2paFwviuq8bZUckGOUtDfgpOknLKDul
         QypYgqd5slDx5y5tggJiUmY0E08QfvKl1w7jXsnT+Gjw8MicRRWBkZEWgoWJXpfkm/gi
         rg4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nYskcLFyc6szi7Z9xpAptKa+a4JeRd4qlkl7qFKCSsw=;
        b=RcMx9Nx61O3/KnHvM4op19CMZ0tzm5M3Mf3TlOkROVidDOUEL+5WZ5eN2PKv5mE5Qq
         2plbybqR3UvJ0zbXXG+2atzkRYPs4Lv05S34Vnf0A/IgDiuQez64jFKjrPf9TNGiyck4
         X/hPN35o/FhRaRXAKaPQ+WeTul8jBHbFTPgcr89xs1eFlSSXjy6Cz76C54M/i+LxJDQS
         NPUTXKMb5wUM0S7RU6my3i4JzU7kkFrJE3pvVN4AtIb60C63uCB8Pc9zcz9DITHttxUp
         0mzG3Sc0gKyHt7nH+uusk4uZHNHQodKCkvEgMxOhxmvh2GMmEu04ja3NnLcyEMp14QvS
         ibmQ==
X-Gm-Message-State: AOAM533rAa5XyuODFp9YVkKdYCaLrSlpNMmGRtk5BDWlF4a1uMw2p1GA
        7f4c3n6RKZU0lbIXedQXgFi4rW9qutYcHK7p
X-Google-Smtp-Source: ABdhPJxFNhs5fN8c0MKKlrJyugO+v/7jNyo73p7yx+RU+3wenhNxS5d+kSDe2ojfg0Ajp+HJ6O50ZA==
X-Received: by 2002:a17:90a:c401:: with SMTP id i1mr8765325pjt.184.1605181309873;
        Thu, 12 Nov 2020 03:41:49 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id y8sm6161629pfe.33.2020.11.12.03.41.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 03:41:48 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, jonathan.lemon@gmail.com, maximmi@nvidia.com,
        intel-wired-lan@lists.osuosl.org, netanel@amazon.com,
        akiyano@amazon.com, michael.chan@broadcom.com,
        sgoutham@marvell.com, ioana.ciornei@nxp.com,
        ruxandra.radulescu@nxp.com, thomas.petazzoni@bootlin.com,
        mcroce@microsoft.com, saeedm@nvidia.com, tariqt@nvidia.com,
        aelior@marvell.com, ecree@solarflare.com,
        ilias.apalodimas@linaro.org, grygorii.strashko@ti.com,
        sthemmin@microsoft.com, mst@redhat.com, kda@linux-powerpc.org
Subject: [PATCH bpf-next 6/9] xsk: propagate napi_id to XDP socket Rx path
Date:   Thu, 12 Nov 2020 12:40:38 +0100
Message-Id: <20201112114041.131998-7-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201112114041.131998-1-bjorn.topel@gmail.com>
References: <20201112114041.131998-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Add napi_id to the xdp_rxq_info structure, and make sure the XDP
socket pick up the napi_id in the Rx path. The napi_id is used to find
the corresponding NAPI structure for socket busy polling.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  2 +-
 .../ethernet/cavium/thunder/nicvf_queues.c    |  2 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   |  2 +-
 drivers/net/ethernet/intel/ice/ice_base.c     |  4 ++--
 drivers/net/ethernet/intel/ice/ice_txrx.c     |  2 +-
 drivers/net/ethernet/intel/igb/igb_main.c     |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  2 +-
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  2 +-
 drivers/net/ethernet/marvell/mvneta.c         |  2 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  4 ++--
 drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  2 +-
 .../ethernet/netronome/nfp/nfp_net_common.c   |  2 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c  |  2 +-
 drivers/net/ethernet/sfc/rx_common.c          |  2 +-
 drivers/net/ethernet/socionext/netsec.c       |  2 +-
 drivers/net/ethernet/ti/cpsw_priv.c           |  2 +-
 drivers/net/hyperv/netvsc.c                   |  2 +-
 drivers/net/tun.c                             |  2 +-
 drivers/net/veth.c                            |  2 +-
 drivers/net/virtio_net.c                      |  2 +-
 drivers/net/xen-netfront.c                    |  2 +-
 include/net/busy_poll.h                       | 19 +++++++++++++++----
 include/net/xdp.h                             |  3 ++-
 net/core/dev.c                                |  2 +-
 net/core/xdp.c                                |  3 ++-
 net/xdp/xsk.c                                 |  1 +
 29 files changed, 47 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index e8131dadc22c..6ad59f0068f6 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -416,7 +416,7 @@ static int ena_xdp_register_rxq_info(struct ena_ring *rx_ring)
 {
 	int rc;
 
-	rc = xdp_rxq_info_reg(&rx_ring->xdp_rxq, rx_ring->netdev, rx_ring->qid);
+	rc = xdp_rxq_info_reg(&rx_ring->xdp_rxq, rx_ring->netdev, rx_ring->qid, 0);
 
 	if (rc) {
 		netif_err(rx_ring->adapter, ifup, rx_ring->netdev,
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index fa147865e33f..5df13387ab74 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2894,7 +2894,7 @@ static int bnxt_alloc_rx_rings(struct bnxt *bp)
 		if (rc)
 			return rc;
 
-		rc = xdp_rxq_info_reg(&rxr->xdp_rxq, bp->dev, i);
+		rc = xdp_rxq_info_reg(&rxr->xdp_rxq, bp->dev, i, 0);
 		if (rc < 0)
 			return rc;
 
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_queues.c b/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
index 7a141ce32e86..f782e6af45e9 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
@@ -770,7 +770,7 @@ static void nicvf_rcv_queue_config(struct nicvf *nic, struct queue_set *qs,
 	rq->caching = 1;
 
 	/* Driver have no proper error path for failed XDP RX-queue info reg */
-	WARN_ON(xdp_rxq_info_reg(&rq->xdp_rxq, nic->netdev, qidx) < 0);
+	WARN_ON(xdp_rxq_info_reg(&rq->xdp_rxq, nic->netdev, qidx, 0) < 0);
 
 	/* Send a mailbox msg to PF to config RQ */
 	mbx.rq.msg = NIC_MBOX_MSG_RQ_CFG;
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index cf9400a9886d..40953980e846 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -3334,7 +3334,7 @@ static int dpaa2_eth_setup_rx_flow(struct dpaa2_eth_priv *priv,
 		return 0;
 
 	err = xdp_rxq_info_reg(&fq->channel->xdp_rxq, priv->net_dev,
-			       fq->flowid);
+			       fq->flowid, 0);
 	if (err) {
 		dev_err(dev, "xdp_rxq_info_reg failed\n");
 		return err;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index d43ce13a93c9..a3d5bdaca2f5 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1436,7 +1436,7 @@ int i40e_setup_rx_descriptors(struct i40e_ring *rx_ring)
 	/* XDP RX-queue info only needed for RX rings exposed to XDP */
 	if (rx_ring->vsi->type == I40E_VSI_MAIN) {
 		err = xdp_rxq_info_reg(&rx_ring->xdp_rxq, rx_ring->netdev,
-				       rx_ring->queue_index);
+				       rx_ring->queue_index, rx_ring->q_vector->napi.napi_id);
 		if (err < 0)
 			return err;
 	}
diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index fe4320e2d1f2..3124a3bf519a 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -306,7 +306,7 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 		if (!xdp_rxq_info_is_reg(&ring->xdp_rxq))
 			/* coverity[check_return] */
 			xdp_rxq_info_reg(&ring->xdp_rxq, ring->netdev,
-					 ring->q_index);
+					 ring->q_index, ring->q_vector->napi.napi_id);
 
 		ring->xsk_pool = ice_xsk_pool(ring);
 		if (ring->xsk_pool) {
@@ -333,7 +333,7 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 				/* coverity[check_return] */
 				xdp_rxq_info_reg(&ring->xdp_rxq,
 						 ring->netdev,
-						 ring->q_index);
+						 ring->q_index, ring->q_vector->napi.napi_id);
 
 			err = xdp_rxq_info_reg_mem_model(&ring->xdp_rxq,
 							 MEM_TYPE_PAGE_SHARED,
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index eae75260fe20..77d5eae6b4c2 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -483,7 +483,7 @@ int ice_setup_rx_ring(struct ice_ring *rx_ring)
 	if (rx_ring->vsi->type == ICE_VSI_PF &&
 	    !xdp_rxq_info_is_reg(&rx_ring->xdp_rxq))
 		if (xdp_rxq_info_reg(&rx_ring->xdp_rxq, rx_ring->netdev,
-				     rx_ring->q_index))
+				     rx_ring->q_index, rx_ring->q_vector->napi.napi_id))
 			goto err;
 	return 0;
 
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 5fc2c381da55..6a4ef4934fcf 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -4352,7 +4352,7 @@ int igb_setup_rx_resources(struct igb_ring *rx_ring)
 
 	/* XDP RX-queue info */
 	if (xdp_rxq_info_reg(&rx_ring->xdp_rxq, rx_ring->netdev,
-			     rx_ring->queue_index) < 0)
+			     rx_ring->queue_index, 0) < 0)
 		goto err;
 
 	return 0;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 45ae33e15303..50e6b8b6ba7b 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -6577,7 +6577,7 @@ int ixgbe_setup_rx_resources(struct ixgbe_adapter *adapter,
 
 	/* XDP RX-queue info */
 	if (xdp_rxq_info_reg(&rx_ring->xdp_rxq, adapter->netdev,
-			     rx_ring->queue_index) < 0)
+			     rx_ring->queue_index, rx_ring->q_vector->napi.napi_id) < 0)
 		goto err;
 
 	rx_ring->xdp_prog = adapter->xdp_prog;
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 82fce27f682b..4061cd7db5dd 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -3493,7 +3493,7 @@ int ixgbevf_setup_rx_resources(struct ixgbevf_adapter *adapter,
 
 	/* XDP RX-queue info */
 	if (xdp_rxq_info_reg(&rx_ring->xdp_rxq, adapter->netdev,
-			     rx_ring->queue_index) < 0)
+			     rx_ring->queue_index, 0) < 0)
 		goto err;
 
 	rx_ring->xdp_prog = adapter->xdp_prog;
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 54b0bf574c05..7d0098f4ef9d 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3219,7 +3219,7 @@ static int mvneta_create_page_pool(struct mvneta_port *pp,
 		return err;
 	}
 
-	err = xdp_rxq_info_reg(&rxq->xdp_rxq, pp->dev, rxq->id);
+	err = xdp_rxq_info_reg(&rxq->xdp_rxq, pp->dev, rxq->id, 0);
 	if (err < 0)
 		goto err_free_pp;
 
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index f6616c8933ca..ff8729b6c414 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -2606,11 +2606,11 @@ static int mvpp2_rxq_init(struct mvpp2_port *port,
 	mvpp2_rxq_status_update(port, rxq->id, 0, rxq->size);
 
 	if (priv->percpu_pools) {
-		err = xdp_rxq_info_reg(&rxq->xdp_rxq_short, port->dev, rxq->id);
+		err = xdp_rxq_info_reg(&rxq->xdp_rxq_short, port->dev, rxq->id, 0);
 		if (err < 0)
 			goto err_free_dma;
 
-		err = xdp_rxq_info_reg(&rxq->xdp_rxq_long, port->dev, rxq->id);
+		err = xdp_rxq_info_reg(&rxq->xdp_rxq_long, port->dev, rxq->id, 0);
 		if (err < 0)
 			goto err_unregister_rxq_short;
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index 502d1b97855c..f561979e5731 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -283,7 +283,7 @@ int mlx4_en_create_rx_ring(struct mlx4_en_priv *priv,
 	ring->log_stride = ffs(ring->stride) - 1;
 	ring->buf_size = ring->size * ring->stride + TXBB_SIZE;
 
-	if (xdp_rxq_info_reg(&ring->xdp_rxq, priv->dev, queue_index) < 0)
+	if (xdp_rxq_info_reg(&ring->xdp_rxq, priv->dev, queue_index, 0) < 0)
 		goto err_ring;
 
 	tmp = size * roundup_pow_of_two(MLX4_EN_MAX_RX_FRAGS *
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index b3f02aac7f26..3e7ecd7f0290 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -434,7 +434,7 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 	rq_xdp_ix = rq->ix;
 	if (xsk)
 		rq_xdp_ix += params->num_channels * MLX5E_RQ_GROUP_XSK;
-	err = xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq_xdp_ix);
+	err = xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq_xdp_ix, 0);
 	if (err < 0)
 		goto err_rq_xdp_prog;
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index b150da43adb2..b4acf2f41e84 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2533,7 +2533,7 @@ nfp_net_rx_ring_alloc(struct nfp_net_dp *dp, struct nfp_net_rx_ring *rx_ring)
 
 	if (dp->netdev) {
 		err = xdp_rxq_info_reg(&rx_ring->xdp_rxq, dp->netdev,
-				       rx_ring->idx);
+				       rx_ring->idx, rx_ring->r_vec->napi.napi_id);
 		if (err < 0)
 			return err;
 	}
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 05e3a3b60269..9cf960a6d007 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1762,7 +1762,7 @@ static void qede_init_fp(struct qede_dev *edev)
 
 			/* Driver have no error path from here */
 			WARN_ON(xdp_rxq_info_reg(&fp->rxq->xdp_rxq, edev->ndev,
-						 fp->rxq->rxq_id) < 0);
+						 fp->rxq->rxq_id, 0) < 0);
 
 			if (xdp_rxq_info_reg_mem_model(&fp->rxq->xdp_rxq,
 						       MEM_TYPE_PAGE_ORDER0,
diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
index 19cf7cac1e6e..68fc7d317693 100644
--- a/drivers/net/ethernet/sfc/rx_common.c
+++ b/drivers/net/ethernet/sfc/rx_common.c
@@ -262,7 +262,7 @@ void efx_init_rx_queue(struct efx_rx_queue *rx_queue)
 
 	/* Initialise XDP queue information */
 	rc = xdp_rxq_info_reg(&rx_queue->xdp_rxq_info, efx->net_dev,
-			      rx_queue->core_index);
+			      rx_queue->core_index, 0);
 
 	if (rc) {
 		netif_err(efx, rx_err, efx->net_dev,
diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 1503cc9ec6e2..80ab24658e87 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -1304,7 +1304,7 @@ static int netsec_setup_rx_dring(struct netsec_priv *priv)
 		goto err_out;
 	}
 
-	err = xdp_rxq_info_reg(&dring->xdp_rxq, priv->ndev, 0);
+	err = xdp_rxq_info_reg(&dring->xdp_rxq, priv->ndev, 0, 0);
 	if (err)
 		goto err_out;
 
diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
index 51cc29f39038..d8f287c88d77 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -1189,7 +1189,7 @@ static int cpsw_ndev_create_xdp_rxq(struct cpsw_priv *priv, int ch)
 	pool = cpsw->page_pool[ch];
 	rxq = &priv->xdp_rxq[ch];
 
-	ret = xdp_rxq_info_reg(rxq, priv->ndev, ch);
+	ret = xdp_rxq_info_reg(rxq, priv->ndev, ch, 0);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 0c3de94b5178..fa8341f8359a 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -1499,7 +1499,7 @@ struct netvsc_device *netvsc_device_add(struct hv_device *device,
 		u64_stats_init(&nvchan->tx_stats.syncp);
 		u64_stats_init(&nvchan->rx_stats.syncp);
 
-		ret = xdp_rxq_info_reg(&nvchan->xdp_rxq, ndev, i);
+		ret = xdp_rxq_info_reg(&nvchan->xdp_rxq, ndev, i, 0);
 
 		if (ret) {
 			netdev_err(ndev, "xdp_rxq_info_reg fail: %d\n", ret);
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index be69d272052f..f2541d645707 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -791,7 +791,7 @@ static int tun_attach(struct tun_struct *tun, struct file *file,
 	} else {
 		/* Setup XDP RX-queue info, for new tfile getting attached */
 		err = xdp_rxq_info_reg(&tfile->xdp_rxq,
-				       tun->dev, tfile->queue_index);
+				       tun->dev, tfile->queue_index, 0);
 		if (err < 0)
 			goto out;
 		err = xdp_rxq_info_reg_mem_model(&tfile->xdp_rxq,
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 8c737668008a..04d20e9d8431 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -926,7 +926,7 @@ static int veth_enable_xdp(struct net_device *dev)
 		for (i = 0; i < dev->real_num_rx_queues; i++) {
 			struct veth_rq *rq = &priv->rq[i];
 
-			err = xdp_rxq_info_reg(&rq->xdp_rxq, dev, i);
+			err = xdp_rxq_info_reg(&rq->xdp_rxq, dev, i, 0);
 			if (err < 0)
 				goto err_rxq_reg;
 
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 21b71148c532..d71fe41595b7 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1485,7 +1485,7 @@ static int virtnet_open(struct net_device *dev)
 			if (!try_fill_recv(vi, &vi->rq[i], GFP_KERNEL))
 				schedule_delayed_work(&vi->refill, 0);
 
-		err = xdp_rxq_info_reg(&vi->rq[i].xdp_rxq, dev, i);
+		err = xdp_rxq_info_reg(&vi->rq[i].xdp_rxq, dev, i, 0);
 		if (err < 0)
 			return err;
 
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 3e9895bec15f..28714a48f5d0 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -2014,7 +2014,7 @@ static int xennet_create_page_pool(struct netfront_queue *queue)
 	}
 
 	err = xdp_rxq_info_reg(&queue->xdp_rxq, queue->info->netdev,
-			       queue->id);
+			       queue->id, 0);
 	if (err) {
 		netdev_err(queue->info->netdev, "xdp_rxq_info_reg failed\n");
 		goto err_free_pp;
diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
index b4f653cc15a7..2dd8c2c90c0c 100644
--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -135,14 +135,25 @@ static inline void sk_mark_napi_id(struct sock *sk, const struct sk_buff *skb)
 	sk_rx_queue_set(sk, skb);
 }
 
-/* variant used for unconnected sockets */
-static inline void sk_mark_napi_id_once(struct sock *sk,
-					const struct sk_buff *skb)
+static inline void __sk_mark_napi_id_once_xdp(struct sock *sk, unsigned int napi_id)
 {
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	if (!READ_ONCE(sk->sk_napi_id))
-		WRITE_ONCE(sk->sk_napi_id, skb->napi_id);
+		WRITE_ONCE(sk->sk_napi_id, napi_id);
 #endif
 }
 
+/* variant used for unconnected sockets */
+static inline void sk_mark_napi_id_once(struct sock *sk,
+					const struct sk_buff *skb)
+{
+	__sk_mark_napi_id_once_xdp(sk, skb->napi_id);
+}
+
+static inline void sk_mark_napi_id_once_xdp(struct sock *sk,
+					    const struct xdp_buff *xdp)
+{
+	__sk_mark_napi_id_once_xdp(sk, xdp->rxq->napi_id);
+}
+
 #endif /* _LINUX_NET_BUSY_POLL_H */
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 3814fb631d52..4d4255a94773 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -59,6 +59,7 @@ struct xdp_rxq_info {
 	u32 queue_index;
 	u32 reg_state;
 	struct xdp_mem_info mem;
+	unsigned int napi_id;
 } ____cacheline_aligned; /* perf critical, avoid false-sharing */
 
 struct xdp_txq_info {
@@ -211,7 +212,7 @@ static inline void xdp_release_frame(struct xdp_frame *xdpf)
 }
 
 int xdp_rxq_info_reg(struct xdp_rxq_info *xdp_rxq,
-		     struct net_device *dev, u32 queue_index);
+		     struct net_device *dev, u32 queue_index, unsigned int napi_id);
 void xdp_rxq_info_unreg(struct xdp_rxq_info *xdp_rxq);
 void xdp_rxq_info_unused(struct xdp_rxq_info *xdp_rxq);
 bool xdp_rxq_info_is_reg(struct xdp_rxq_info *xdp_rxq);
diff --git a/net/core/dev.c b/net/core/dev.c
index 33c67004f2ad..6635c92935bc 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9806,7 +9806,7 @@ static int netif_alloc_rx_queues(struct net_device *dev)
 		rx[i].dev = dev;
 
 		/* XDP RX-queue setup */
-		err = xdp_rxq_info_reg(&rx[i].xdp_rxq, dev, i);
+		err = xdp_rxq_info_reg(&rx[i].xdp_rxq, dev, i, 0);
 		if (err < 0)
 			goto err_rxq_info;
 	}
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 48aba933a5a8..7cca7cb5b65f 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -158,7 +158,7 @@ static void xdp_rxq_info_init(struct xdp_rxq_info *xdp_rxq)
 
 /* Returns 0 on success, negative on failure */
 int xdp_rxq_info_reg(struct xdp_rxq_info *xdp_rxq,
-		     struct net_device *dev, u32 queue_index)
+		     struct net_device *dev, u32 queue_index, unsigned int napi_id)
 {
 	if (xdp_rxq->reg_state == REG_STATE_UNUSED) {
 		WARN(1, "Driver promised not to register this");
@@ -179,6 +179,7 @@ int xdp_rxq_info_reg(struct xdp_rxq_info *xdp_rxq,
 	xdp_rxq_info_init(xdp_rxq);
 	xdp_rxq->dev = dev;
 	xdp_rxq->queue_index = queue_index;
+	xdp_rxq->napi_id = napi_id;
 
 	xdp_rxq->reg_state = REG_STATE_REGISTERED;
 	return 0;
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 00663390a4a8..5c90e5993ddb 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -233,6 +233,7 @@ static int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp,
 	if (xs->dev != xdp->rxq->dev || xs->queue_id != xdp->rxq->queue_index)
 		return -EINVAL;
 
+	sk_mark_napi_id_once_xdp(&xs->sk, xdp);
 	len = xdp->data_end - xdp->data;
 
 	return xdp->rxq->mem.type == MEM_TYPE_XSK_BUFF_POOL ?
-- 
2.27.0

