Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9B426415
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 14:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729373AbfEVMyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 08:54:20 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43869 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728761AbfEVMyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 08:54:19 -0400
Received: by mail-pg1-f196.google.com with SMTP id f25so1278790pgv.10;
        Wed, 22 May 2019 05:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DVGvJxTDP7nH/RRrIdCMvLdzliezhNedXxv6jJYwjiI=;
        b=cK2Sh5Rem9Heh4VOUHJNYDh85u6c2yjNfMymOcxYAZGwjMkiple5Y00UJ8ZnilRIbx
         U5Z0MUNqywfzG8mzTYGhQJnWDiETEZ4J6YHwqaGEop/pthobwqWyR9eWg3fWOyFcE5pL
         IpzzWzjYYDeANzvkIBLXhPLUS4c+bkWtrsULbpV30ELiDbGgNrbvVBwqBC56Vm/7KoUw
         6vlZTA0qi1Cl98lcrp9ObafSkYFsQcRwnmdI93N6BHgvHpTJ0OuaNsM0t3RDUCrCXvGt
         Ul7COcKtz3+fL9o5D48HawskbjVpCp1SZiyQhMe6mnSMpJ3fQzx8ExVjF3JD9NEK+Dth
         fUFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DVGvJxTDP7nH/RRrIdCMvLdzliezhNedXxv6jJYwjiI=;
        b=gqlIV732UO5DDEzvIDWT3NK80y1EdvkyWIbspylcAe9ZgYAyH5Bkuiw6ZBcfsbpdFE
         NVWqPzpRAvvo6/n5n7UmqGPMYXhUtP7x8c6tH+vltGiQu3hC558Qjw494TURXxWTkcks
         XndGK7kvzevfxSztJCV2opPA4DRnHQJNsZobFNFyZSZQZBDduL90hiPoPRbGFcEEit9U
         xzi9DbWQAivnZyNVMb8A1hifRBDmsJKOnDo0rQB7kXv7nYjh1t0w6vSub9AJhiWxCfU8
         gfkiiSMNpoLdP//doXlc0xnj4N2Xn13TryjFw9Sx4hKdzoI5v8tilnnb6Z77dYpalK7E
         O2sw==
X-Gm-Message-State: APjAAAV85mhanhlJT70uOXALXCo/81YAfsB2EtiQk7h3rBRNUm20U9OD
        PZXK/PiuHve7EYx0XmK8uNI=
X-Google-Smtp-Source: APXvYqzZ7GWRxy1lfDOLKF+KHwY01RqTD4SrKeIVLostYgwzn4+UOUTdBc30sgDb4owix8zTXPW/Wg==
X-Received: by 2002:a62:e90b:: with SMTP id j11mr43813003pfh.88.1558529658563;
        Wed, 22 May 2019 05:54:18 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.43])
        by smtp.gmail.com with ESMTPSA id 127sm29671054pfc.159.2019.05.22.05.54.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 05:54:18 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     toke@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, brouer@redhat.com, bpf@vger.kernel.org,
        jakub.kicinski@netronome.com
Subject: [PATCH bpf-next 2/2] net: xdp: remove XDP_QUERY_PROG{,_HW}
Date:   Wed, 22 May 2019 14:53:52 +0200
Message-Id: <20190522125353.6106-3-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522125353.6106-1-bjorn.topel@gmail.com>
References: <20190522125353.6106-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Remove all use of XDP_QUERY_PROG{,_HW}, since it was moved to the
generic code path.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |  4 ----
 .../net/ethernet/cavium/thunder/nicvf_main.c  |  3 ---
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  3 ---
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  3 ---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  4 ----
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  4 ----
 .../net/ethernet/mellanox/mlx4/en_netdev.c    | 24 -------------------
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 18 --------------
 .../ethernet/netronome/nfp/nfp_net_common.c   |  4 ----
 .../net/ethernet/qlogic/qede/qede_filter.c    |  3 ---
 drivers/net/netdevsim/bpf.c                   |  4 ----
 drivers/net/netdevsim/netdevsim.h             |  2 +-
 drivers/net/tun.c                             | 15 ------------
 drivers/net/veth.c                            | 15 ------------
 drivers/net/virtio_net.c                      | 17 -------------
 include/linux/netdevice.h                     |  8 -------
 include/net/xdp.h                             |  2 --
 net/core/dev.c                                |  5 ----
 net/core/xdp.c                                |  9 -------
 19 files changed, 1 insertion(+), 146 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index 0184ef6f05a7..8b1e77522e18 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -217,10 +217,6 @@ int bnxt_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 	case XDP_SETUP_PROG:
 		rc = bnxt_xdp_set(bp, xdp->prog);
 		break;
-	case XDP_QUERY_PROG:
-		xdp->prog_id = bp->xdp_prog ? bp->xdp_prog->aux->id : 0;
-		rc = 0;
-		break;
 	default:
 		rc = -EINVAL;
 		break;
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index c032bef1b776..14c079538cb5 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -1914,9 +1914,6 @@ static int nicvf_xdp(struct net_device *netdev, struct netdev_bpf *xdp)
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return nicvf_xdp_setup(nic, xdp->prog);
-	case XDP_QUERY_PROG:
-		xdp->prog_id = nic->xdp_prog ? nic->xdp_prog->aux->id : 0;
-		return 0;
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 63b1ecc18c26..a00cf674b8c8 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1763,9 +1763,6 @@ static int dpaa2_eth_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return setup_xdp(dev, xdp->prog);
-	case XDP_QUERY_PROG:
-		xdp->prog_id = priv->xdp_prog ? priv->xdp_prog->aux->id : 0;
-		break;
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 320562b39686..3dd591068591 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -12302,9 +12302,6 @@ static int i40e_xdp(struct net_device *dev,
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return i40e_xdp_setup(vsi, xdp->prog);
-	case XDP_QUERY_PROG:
-		xdp->prog_id = vsi->xdp_prog ? vsi->xdp_prog->aux->id : 0;
-		return 0;
 	case XDP_SETUP_XSK_UMEM:
 		return i40e_xsk_umem_setup(vsi, xdp->xsk.umem,
 					   xdp->xsk.queue_id);
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 57fd9ee6de66..59dc82c71f9c 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -10284,10 +10284,6 @@ static int ixgbe_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return ixgbe_xdp_setup(dev, xdp->prog);
-	case XDP_QUERY_PROG:
-		xdp->prog_id = adapter->xdp_prog ?
-			adapter->xdp_prog->aux->id : 0;
-		return 0;
 	case XDP_SETUP_XSK_UMEM:
 		return ixgbe_xsk_umem_setup(adapter, xdp->xsk.umem,
 					    xdp->xsk.queue_id);
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index d189ed247665..80a22d638734 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -4485,10 +4485,6 @@ static int ixgbevf_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return ixgbevf_xdp_setup(dev, xdp->prog);
-	case XDP_QUERY_PROG:
-		xdp->prog_id = adapter->xdp_prog ?
-			       adapter->xdp_prog->aux->id : 0;
-		return 0;
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index c1438ae52a11..8850fc35510a 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -2883,35 +2883,11 @@ static int mlx4_xdp_set(struct net_device *dev, struct bpf_prog *prog)
 	return err;
 }
 
-static u32 mlx4_xdp_query(struct net_device *dev)
-{
-	struct mlx4_en_priv *priv = netdev_priv(dev);
-	struct mlx4_en_dev *mdev = priv->mdev;
-	const struct bpf_prog *xdp_prog;
-	u32 prog_id = 0;
-
-	if (!priv->tx_ring_num[TX_XDP])
-		return prog_id;
-
-	mutex_lock(&mdev->state_lock);
-	xdp_prog = rcu_dereference_protected(
-		priv->rx_ring[0]->xdp_prog,
-		lockdep_is_held(&mdev->state_lock));
-	if (xdp_prog)
-		prog_id = xdp_prog->aux->id;
-	mutex_unlock(&mdev->state_lock);
-
-	return prog_id;
-}
-
 static int mlx4_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 {
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return mlx4_xdp_set(dev, xdp->prog);
-	case XDP_QUERY_PROG:
-		xdp->prog_id = mlx4_xdp_query(dev);
-		return 0;
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 457cc39423f2..f1b80c1d9ca2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4237,29 +4237,11 @@ static int mlx5e_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
 	return err;
 }
 
-static u32 mlx5e_xdp_query(struct net_device *dev)
-{
-	struct mlx5e_priv *priv = netdev_priv(dev);
-	const struct bpf_prog *xdp_prog;
-	u32 prog_id = 0;
-
-	mutex_lock(&priv->state_lock);
-	xdp_prog = priv->channels.params.xdp_prog;
-	if (xdp_prog)
-		prog_id = xdp_prog->aux->id;
-	mutex_unlock(&priv->state_lock);
-
-	return prog_id;
-}
-
 static int mlx5e_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 {
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return mlx5e_xdp_set(dev, xdp->prog);
-	case XDP_QUERY_PROG:
-		xdp->prog_id = mlx5e_xdp_query(dev);
-		return 0;
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index b82b684f52ce..2a9683db54e5 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -3548,10 +3548,6 @@ static int nfp_net_xdp(struct net_device *netdev, struct netdev_bpf *xdp)
 		return nfp_net_xdp_setup_drv(nn, xdp);
 	case XDP_SETUP_PROG_HW:
 		return nfp_net_xdp_setup_hw(nn, xdp);
-	case XDP_QUERY_PROG:
-		return xdp_attachment_query(&nn->xdp, xdp);
-	case XDP_QUERY_PROG_HW:
-		return xdp_attachment_query(&nn->xdp_hw, xdp);
 	default:
 		return nfp_app_bpf(nn->app, nn, xdp);
 	}
diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index add922b93d2c..69f4e7d37d01 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -1118,9 +1118,6 @@ int qede_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return qede_xdp_set(edev, xdp->prog);
-	case XDP_QUERY_PROG:
-		xdp->prog_id = edev->xdp_prog ? edev->xdp_prog->aux->id : 0;
-		return 0;
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/net/netdevsim/bpf.c b/drivers/net/netdevsim/bpf.c
index 2b74425822ab..d03d31721e38 100644
--- a/drivers/net/netdevsim/bpf.c
+++ b/drivers/net/netdevsim/bpf.c
@@ -549,10 +549,6 @@ int nsim_bpf(struct net_device *dev, struct netdev_bpf *bpf)
 	ASSERT_RTNL();
 
 	switch (bpf->command) {
-	case XDP_QUERY_PROG:
-		return xdp_attachment_query(&ns->xdp, bpf);
-	case XDP_QUERY_PROG_HW:
-		return xdp_attachment_query(&ns->xdp_hw, bpf);
 	case XDP_SETUP_PROG:
 		err = nsim_setup_prog_checks(ns, bpf);
 		if (err)
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 3f398797c2bc..3f75f50b3250 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -108,7 +108,7 @@ static inline void nsim_bpf_uninit(struct netdevsim *ns)
 
 static inline int nsim_bpf(struct net_device *dev, struct netdev_bpf *bpf)
 {
-	return bpf->command == XDP_QUERY_PROG ? 0 : -EOPNOTSUPP;
+	return -EOPNOTSUPP;
 }
 
 static inline int nsim_bpf_disable_tc(struct netdevsim *ns)
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index abae165dcca5..dbf115aa5c11 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1236,26 +1236,11 @@ static int tun_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 	return 0;
 }
 
-static u32 tun_xdp_query(struct net_device *dev)
-{
-	struct tun_struct *tun = netdev_priv(dev);
-	const struct bpf_prog *xdp_prog;
-
-	xdp_prog = rtnl_dereference(tun->xdp_prog);
-	if (xdp_prog)
-		return xdp_prog->aux->id;
-
-	return 0;
-}
-
 static int tun_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 {
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return tun_xdp_set(dev, xdp->prog, xdp->extack);
-	case XDP_QUERY_PROG:
-		xdp->prog_id = tun_xdp_query(dev);
-		return 0;
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 09a1433b0833..8fde5f319bfb 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1096,26 +1096,11 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 	return err;
 }
 
-static u32 veth_xdp_query(struct net_device *dev)
-{
-	struct veth_priv *priv = netdev_priv(dev);
-	const struct bpf_prog *xdp_prog;
-
-	xdp_prog = priv->_xdp_prog;
-	if (xdp_prog)
-		return xdp_prog->aux->id;
-
-	return 0;
-}
-
 static int veth_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 {
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return veth_xdp_set(dev, xdp->prog, xdp->extack);
-	case XDP_QUERY_PROG:
-		xdp->prog_id = veth_xdp_query(dev);
-		return 0;
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 559c48e66afc..f201d5a19cd3 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2525,28 +2525,11 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 	return err;
 }
 
-static u32 virtnet_xdp_query(struct net_device *dev)
-{
-	struct virtnet_info *vi = netdev_priv(dev);
-	const struct bpf_prog *xdp_prog;
-	int i;
-
-	for (i = 0; i < vi->max_queue_pairs; i++) {
-		xdp_prog = rtnl_dereference(vi->rq[i].xdp_prog);
-		if (xdp_prog)
-			return xdp_prog->aux->id;
-	}
-	return 0;
-}
-
 static int virtnet_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 {
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return virtnet_xdp_set(dev, xdp->prog, xdp->extack);
-	case XDP_QUERY_PROG:
-		xdp->prog_id = virtnet_xdp_query(dev);
-		return 0;
 	default:
 		return -EINVAL;
 	}
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index bdcb20a3946c..fa944bc507cd 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -864,8 +864,6 @@ enum bpf_netdev_command {
 	 */
 	XDP_SETUP_PROG,
 	XDP_SETUP_PROG_HW,
-	XDP_QUERY_PROG,
-	XDP_QUERY_PROG_HW,
 	/* BPF program for offload callbacks, invoked at program load time. */
 	BPF_OFFLOAD_MAP_ALLOC,
 	BPF_OFFLOAD_MAP_FREE,
@@ -885,12 +883,6 @@ struct netdev_bpf {
 			struct bpf_prog *prog;
 			struct netlink_ext_ack *extack;
 		};
-		/* XDP_QUERY_PROG, XDP_QUERY_PROG_HW */
-		struct {
-			u32 prog_id;
-			/* flags with which program was installed */
-			u32 prog_flags;
-		};
 		/* BPF_OFFLOAD_MAP_ALLOC, BPF_OFFLOAD_MAP_FREE */
 		struct {
 			struct bpf_offloaded_map *offmap;
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 0f25b3675c5c..4ad4b20fe2c0 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -159,8 +159,6 @@ struct xdp_attachment_info {
 };
 
 struct netdev_bpf;
-int xdp_attachment_query(struct xdp_attachment_info *info,
-			 struct netdev_bpf *bpf);
 bool xdp_attachment_flags_ok(struct xdp_attachment_info *info,
 			     struct netdev_bpf *bpf);
 void xdp_attachment_setup(struct xdp_attachment_info *info,
diff --git a/net/core/dev.c b/net/core/dev.c
index ead16c3f955c..33792b495ce4 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5156,11 +5156,6 @@ static int generic_xdp_install(struct net_device *dev, struct netdev_bpf *xdp)
 			dev_disable_gro_hw(dev);
 		}
 		break;
-
-	case XDP_QUERY_PROG:
-		xdp->prog_id = old ? old->aux->id : 0;
-		break;
-
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 4b2b194f4f1f..6f76ad995fef 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -379,15 +379,6 @@ void xdp_return_buff(struct xdp_buff *xdp)
 }
 EXPORT_SYMBOL_GPL(xdp_return_buff);
 
-int xdp_attachment_query(struct xdp_attachment_info *info,
-			 struct netdev_bpf *bpf)
-{
-	bpf->prog_id = info->prog ? info->prog->aux->id : 0;
-	bpf->prog_flags = info->prog ? info->flags : 0;
-	return 0;
-}
-EXPORT_SYMBOL_GPL(xdp_attachment_query);
-
 bool xdp_attachment_flags_ok(struct xdp_attachment_info *info,
 			     struct netdev_bpf *bpf)
 {
-- 
2.20.1

