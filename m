Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB75E682A0
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 05:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729307AbfGODTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jul 2019 23:19:22 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43064 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729072AbfGODTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jul 2019 23:19:22 -0400
Received: by mail-pf1-f193.google.com with SMTP id i189so6727585pfg.10;
        Sun, 14 Jul 2019 20:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=KS0cRXj3mMxfE5cJ9aFXhPRx/TLOXRFrYbz2+FXfqWY=;
        b=QozrcHXcvAQvW6SWxNprX74Ofrc4lKOl1EYHi6Suy9hGK6xzvQ9hUWuyVJSEBn3MnX
         IO2Qbv71En9rt31CVFtRk2WpNcBG78LS9pjzYSSuN5BuJcolpbRBwdliEZM9BJrl2f54
         H3hzJDb0kHUx3oPAa+ExfdzwUF9764ad/xsBxfsLuOan4DOpKjK7Xft7hs86Gkw7bE6A
         51w+IDht1yckqq6Ur/SMFTXH85V4Gy/HzwEv5ZRep4yvd4lC7lBHKP/LJZHx1wYhW24v
         AoZhFp19VF7O/jNkmAWf8XqSHffh+kMHvT1M/0WnwTg2GccVD9AsSI8fodQbDpcHhoZf
         1mEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KS0cRXj3mMxfE5cJ9aFXhPRx/TLOXRFrYbz2+FXfqWY=;
        b=Hve91/HwvBNSzHyNDm5/T6pbiJNpf/aTBE1xU1rJfiLZnPIvWI+Tahq4cuwJ/iblBq
         VqweiEIH4aT1kfj0u/gpbgUJmV+17Kjm7/GQQyy8MNbVgg1Fh9IJdkalDGliWPwyZohA
         RqDUcn23k0ks8wmmmNeyLxp6ocLz7ZR26i8RrIDp+7D968Ic54H0I2W45ZhTmlkdDMG7
         sRQlgOwp4OlAMlHquATdjsJFp1N+G7WusqnQjlYb4QlPTIyF2BeDfCAWyw6f6QjBpN0g
         U3cd5QizaMLexZ9a9R9j0ihJVcIt85iRqTH0P/JuULf08e0AauJxJk3ALKNqXjFOPu5Y
         PReA==
X-Gm-Message-State: APjAAAUTB5/06mi+AUkjZjcSv/O4LeQLAtYwcsKr0RHSSv5u80daoKZI
        N33bbZhxsfvyZJlubUhhECw=
X-Google-Smtp-Source: APXvYqwX2SmiBcWC9U4gKWgfI7KXr9BDwEfcOPAq48RrHqe11DbPklWYyVwDiJGJRr/3DodBIewt6g==
X-Received: by 2002:a17:90a:8c92:: with SMTP id b18mr26231057pjo.97.1563160760589;
        Sun, 14 Jul 2019 20:19:20 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id h16sm16389748pfo.34.2019.07.14.20.19.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 14 Jul 2019 20:19:20 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        Guo-Fu Tseng <cooldavid@cooldavid.org>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jon Mason <jdmason@kudzu.us>,
        Manish Chopra <manishc@marvell.com>,
        Rahul Verma <rahulv@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Samuel Chessman <chessman@tux.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH v3 17/24] ethernet: remove redundant memset
Date:   Mon, 15 Jul 2019 11:19:11 +0800
Message-Id: <20190715031911.6982-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kvzalloc already zeroes the memory during the allocation.
pci_alloc_consistent calls dma_alloc_coherent directly.
In commit 518a2f1925c3
("dma-mapping: zero memory returned from dma_alloc_*"),
dma_alloc_coherent has already zeroed the memory.
So the memset after these function is not needed.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
Changes in v3:
  - Use actual commit rather than the merge commit in the commit message

 drivers/net/ethernet/atheros/atlx/atl1.c                   | 2 --
 drivers/net/ethernet/atheros/atlx/atl2.c                   | 1 -
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                  | 2 --
 drivers/net/ethernet/chelsio/cxgb4/sched.c                 | 1 -
 drivers/net/ethernet/freescale/fec_main.c                  | 2 --
 drivers/net/ethernet/jme.c                                 | 5 -----
 drivers/net/ethernet/marvell/skge.c                        | 2 --
 drivers/net/ethernet/mellanox/mlx4/eq.c                    | 2 --
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c          | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 3 ---
 drivers/net/ethernet/mellanox/mlxsw/pci.c                  | 1 -
 drivers/net/ethernet/neterion/s2io.c                       | 1 -
 drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c        | 3 ---
 drivers/net/ethernet/ti/tlan.c                             | 1 -
 14 files changed, 27 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atlx/atl1.c b/drivers/net/ethernet/atheros/atlx/atl1.c
index 7c767ce9aafa..b5c6dc914720 100644
--- a/drivers/net/ethernet/atheros/atlx/atl1.c
+++ b/drivers/net/ethernet/atheros/atlx/atl1.c
@@ -1060,8 +1060,6 @@ static s32 atl1_setup_ring_resources(struct atl1_adapter *adapter)
 		goto err_nomem;
 	}
 
-	memset(ring_header->desc, 0, ring_header->size);
-
 	/* init TPD ring */
 	tpd_ring->dma = ring_header->dma;
 	offset = (tpd_ring->dma & 0x7) ? (8 - (ring_header->dma & 0x7)) : 0;
diff --git a/drivers/net/ethernet/atheros/atlx/atl2.c b/drivers/net/ethernet/atheros/atlx/atl2.c
index 3a3fb5ce0fee..3aba38322717 100644
--- a/drivers/net/ethernet/atheros/atlx/atl2.c
+++ b/drivers/net/ethernet/atheros/atlx/atl2.c
@@ -291,7 +291,6 @@ static s32 atl2_setup_ring_resources(struct atl2_adapter *adapter)
 		&adapter->ring_dma);
 	if (!adapter->ring_vir_addr)
 		return -ENOMEM;
-	memset(adapter->ring_vir_addr, 0, adapter->ring_size);
 
 	/* Init TXD Ring */
 	adapter->txd_dma = adapter->ring_dma ;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 3f632028eff0..1069eb01cc55 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2677,8 +2677,6 @@ static int bnxt_alloc_tx_rings(struct bnxt *bp)
 			mapping = txr->tx_push_mapping +
 				sizeof(struct tx_push_bd);
 			txr->data_mapping = cpu_to_le64(mapping);
-
-			memset(txr->tx_push, 0, sizeof(struct tx_push_bd));
 		}
 		qidx = bp->tc_to_qidx[j];
 		ring->queue_id = bp->q_info[qidx].queue_id;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sched.c b/drivers/net/ethernet/chelsio/cxgb4/sched.c
index ba6c153ee45c..60218dc676a8 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sched.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sched.c
@@ -207,7 +207,6 @@ static int t4_sched_queue_bind(struct port_info *pi, struct ch_sched_queue *p)
 		goto out_err;
 
 	/* Bind queue to specified class */
-	memset(qe, 0, sizeof(*qe));
 	qe->cntxt_id = qid;
 	memcpy(&qe->param, p, sizeof(qe->param));
 
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 9d459ccf251d..e5610a4da539 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3144,8 +3144,6 @@ static int fec_enet_init(struct net_device *ndev)
 		return -ENOMEM;
 	}
 
-	memset(cbd_base, 0, bd_size);
-
 	/* Get the Ethernet address */
 	fec_get_mac(ndev);
 	/* make sure MAC we just acquired is programmed into the hw */
diff --git a/drivers/net/ethernet/jme.c b/drivers/net/ethernet/jme.c
index 76b7b7b85e35..0b668357db4d 100644
--- a/drivers/net/ethernet/jme.c
+++ b/drivers/net/ethernet/jme.c
@@ -582,11 +582,6 @@ jme_setup_tx_resources(struct jme_adapter *jme)
 	if (unlikely(!(txring->bufinf)))
 		goto err_free_txring;
 
-	/*
-	 * Initialize Transmit Descriptors
-	 */
-	memset(txring->alloc, 0, TX_RING_ALLOC_SIZE(jme->tx_ring_size));
-
 	return 0;
 
 err_free_txring:
diff --git a/drivers/net/ethernet/marvell/skge.c b/drivers/net/ethernet/marvell/skge.c
index 35a92fd2cf39..9ac854c2b371 100644
--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -2558,8 +2558,6 @@ static int skge_up(struct net_device *dev)
 		goto free_pci_mem;
 	}
 
-	memset(skge->mem, 0, skge->mem_size);
-
 	err = skge_ring_alloc(&skge->rx_ring, skge->mem, skge->dma);
 	if (err)
 		goto free_pci_mem;
diff --git a/drivers/net/ethernet/mellanox/mlx4/eq.c b/drivers/net/ethernet/mellanox/mlx4/eq.c
index a5be27772b8e..c790a5fcea73 100644
--- a/drivers/net/ethernet/mellanox/mlx4/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/eq.c
@@ -1013,8 +1013,6 @@ static int mlx4_create_eq(struct mlx4_dev *dev, int nent,
 
 		dma_list[i] = t;
 		eq->page_list[i].map = t;
-
-		memset(eq->page_list[i].buf, 0, PAGE_SIZE);
 	}
 
 	eq->eqn = mlx4_bitmap_alloc(&priv->eq_table.bitmap);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 3b04d8927fb1..1f3891fde2eb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -2450,7 +2450,6 @@ int mlx5_eswitch_get_vport_stats(struct mlx5_eswitch *esw,
 	MLX5_SET(query_vport_counter_in, in, vport_number, vport->vport);
 	MLX5_SET(query_vport_counter_in, in, other_vport, 1);
 
-	memset(out, 0, outlen);
 	err = mlx5_cmd_exec(esw->dev, in, sizeof(in), out, outlen);
 	if (err)
 		goto free_out;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 957d9b09dc3f..089ae4d48a82 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1134,7 +1134,6 @@ static int esw_create_offloads_fdb_tables(struct mlx5_eswitch *esw, int nvports)
 	}
 
 	/* create send-to-vport group */
-	memset(flow_group_in, 0, inlen);
 	MLX5_SET(create_flow_group_in, flow_group_in, match_criteria_enable,
 		 MLX5_MATCH_MISC_PARAMETERS);
 
@@ -1293,8 +1292,6 @@ static int esw_create_vport_rx_group(struct mlx5_eswitch *esw, int nvports)
 		return -ENOMEM;
 
 	/* create vport rx group */
-	memset(flow_group_in, 0, inlen);
-
 	esw_set_flow_group_source_port(esw, flow_group_in);
 
 	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 0);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index 051b19388a81..615455a21567 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -847,7 +847,6 @@ static int mlxsw_pci_queue_init(struct mlxsw_pci *mlxsw_pci, char *mbox,
 					     &mem_item->mapaddr);
 	if (!mem_item->buf)
 		return -ENOMEM;
-	memset(mem_item->buf, 0, mem_item->size);
 
 	q->elem_info = kcalloc(q->count, sizeof(*q->elem_info), GFP_KERNEL);
 	if (!q->elem_info) {
diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index 3b2ae1a21678..e0b2bf327905 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -747,7 +747,6 @@ static int init_shared_mem(struct s2io_nic *nic)
 				return -ENOMEM;
 			}
 			mem_allocated += size;
-			memset(tmp_v_addr, 0, size);
 
 			size = sizeof(struct rxd_info) *
 				rxd_count[nic->rxd_mode];
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c
index 433052f734ed..5e9f8ee99800 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c
@@ -442,10 +442,8 @@ nx_fw_cmd_create_tx_ctx(struct netxen_adapter *adapter)
 		goto out_free_rq;
 	}
 
-	memset(rq_addr, 0, rq_size);
 	prq = rq_addr;
 
-	memset(rsp_addr, 0, rsp_size);
 	prsp = rsp_addr;
 
 	prq->host_rsp_dma_addr = cpu_to_le64(rsp_phys_addr);
@@ -755,7 +753,6 @@ int netxen_alloc_hw_resources(struct netxen_adapter *adapter)
 		return -ENOMEM;
 	}
 
-	memset(addr, 0, sizeof(struct netxen_ring_ctx));
 	recv_ctx->hwctx = addr;
 	recv_ctx->hwctx->ctx_id = cpu_to_le32(port);
 	recv_ctx->hwctx->cmd_consumer_offset =
diff --git a/drivers/net/ethernet/ti/tlan.c b/drivers/net/ethernet/ti/tlan.c
index b4ab1a5f6cd0..78f0f2d59e22 100644
--- a/drivers/net/ethernet/ti/tlan.c
+++ b/drivers/net/ethernet/ti/tlan.c
@@ -855,7 +855,6 @@ static int tlan_init(struct net_device *dev)
 		       dev->name);
 		return -ENOMEM;
 	}
-	memset(priv->dma_storage, 0, dma_size);
 	priv->rx_list = (struct tlan_list *)
 		ALIGN((unsigned long)priv->dma_storage, 8);
 	priv->rx_list_dma = ALIGN(priv->dma_storage_dma, 8);
-- 
2.11.0

