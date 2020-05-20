Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 157711DAF31
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 11:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgETJs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 05:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbgETJsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 05:48:25 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74A4C061A0E;
        Wed, 20 May 2020 02:48:25 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id ci21so990252pjb.3;
        Wed, 20 May 2020 02:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NEmXkkfNcboYRC/+3os20y0XaKiQ3i8drWTE97EHaLI=;
        b=B9mdWPMLDiEYdbNCd9EfzwpZUI3lKTJvVptf1EeRd8tr259pJ24cQtzyh7eT9HiCLV
         BhbKJqmF0B5DHX9De10znfoD+PFG1yxpYwhX6Bx8jkyLuBi+3WxcwfHLzx+rpLTgFrXd
         w6dUVcdjuaBO/T5Hv6w/WHLjP7i+w02Y0wR9vfthIuLsD1zbg0awL49Rkwu0En6Ct+3a
         I7aH/yVmS2WWafqmy2Tjnw17UiKNGgWfQ7+C0stk96+yQsj15cppZ2OqUr9QQrR/5Y3r
         hIf58HOFZNM/F7m0SB25L2raTQMhr6DRJ2AAL4pQiGVYllS/12iTDz01oO16rrFKTVQT
         uNkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NEmXkkfNcboYRC/+3os20y0XaKiQ3i8drWTE97EHaLI=;
        b=PWaGiKDVOqtCUgK6yv44VIX5rOV1Y3S4lDd1nfS2goj0c4GY2dhzsSaYGT+5LJVzAS
         6vzLBgx9T+uORlaJbwt97FbZJ43yyXmLj26NHk3dWSFzgzKtEV5mgvO9kIL34uUsnhTQ
         soaThF+ip5A59z9IxnVyGw9utSwteU5cKGHND+RsXakLsnjrrRbfLLA5AQPd0dZTsYkk
         miBCUOkf+N+07kobFsKzwW5aB329sOy/PCbWOBGxCAZsDi9S2YEc8lB86ktQGfGSSJJz
         JSCqkdh8xAEviGqSNqk/VkRTs3AudkTQXqb/snb4mVezJLAxOMuPKmXSDk0H1drxu+th
         hx+w==
X-Gm-Message-State: AOAM532HmhGuAS1fsrS3Uz7M2AJFI1knAlvURiCDhbVIipyeonp6i5uM
        SA+JL5q5BBAxgZ/9r8ISaY8=
X-Google-Smtp-Source: ABdhPJz9gBTGqjHqe3PO4SAUMuYc4PElHDXL2Km5OVBLuStEF3/zXDLhbS5p+sjUQaE3rIO/BLy4GQ==
X-Received: by 2002:a17:902:209:: with SMTP id 9mr3661671plc.22.1589968103975;
        Wed, 20 May 2020 02:48:23 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id c124sm1707494pfb.187.2020.05.20.02.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 02:48:23 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        jeffrey.t.kirsher@intel.com
Cc:     maximmi@mellanox.com, maciej.fijalkowski@intel.com,
        bjorn.topel@intel.com
Subject: [PATCH bpf-next v4 03/15] xsk: move driver interface to xdp_sock_drv.h
Date:   Wed, 20 May 2020 11:47:30 +0200
Message-Id: <20200520094742.337678-4-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200520094742.337678-1-bjorn.topel@gmail.com>
References: <20200520094742.337678-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Move the AF_XDP zero-copy driver interface to its own include file
called xdp_sock_drv.h. This, hopefully, will make it more clear for
NIC driver implementors to know what functions to use for zero-copy
support.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c   |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c    |   2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c      |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |   2 +-
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.h   |   2 +-
 .../ethernet/mellanox/mlx5/core/en/xsk/tx.h   |   2 +-
 .../ethernet/mellanox/mlx5/core/en/xsk/umem.c |   2 +-
 include/net/xdp_sock.h                        | 214 +----------------
 include/net/xdp_sock_drv.h                    | 217 ++++++++++++++++++
 net/ethtool/channels.c                        |   2 +-
 net/ethtool/ioctl.c                           |   2 +-
 net/xdp/xdp_umem.h                            |   2 +-
 net/xdp/xsk.c                                 |   2 +-
 14 files changed, 237 insertions(+), 218 deletions(-)
 create mode 100644 include/net/xdp_sock_drv.h

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 2a037ec244b9..d6b2db4f2c65 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -11,7 +11,7 @@
 #include "i40e_diag.h"
 #include "i40e_xsk.h"
 #include <net/udp_tunnel.h>
-#include <net/xdp_sock.h>
+#include <net/xdp_sock_drv.h>
 /* All i40e tracepoints are defined by the include below, which
  * must be included exactly once across the whole kernel with
  * CREATE_TRACE_POINTS defined
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 2b9184aead5f..d8b0be29099a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -2,7 +2,7 @@
 /* Copyright(c) 2018 Intel Corporation. */
 
 #include <linux/bpf_trace.h>
-#include <net/xdp_sock.h>
+#include <net/xdp_sock_drv.h>
 #include <net/xdp.h>
 
 #include "i40e.h"
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 23e5515d4527..70e204307a93 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -2,7 +2,7 @@
 /* Copyright (c) 2019, Intel Corporation. */
 
 #include <linux/bpf_trace.h>
-#include <net/xdp_sock.h>
+#include <net/xdp_sock_drv.h>
 #include <net/xdp.h>
 #include "ice.h"
 #include "ice_base.h"
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index a656ee9a1fae..82e4effae704 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -2,7 +2,7 @@
 /* Copyright(c) 2018 Intel Corporation. */
 
 #include <linux/bpf_trace.h>
-#include <net/xdp_sock.h>
+#include <net/xdp_sock_drv.h>
 #include <net/xdp.h>
 
 #include "ixgbe.h"
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 761c8979bd41..3507d23f0eb8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -31,7 +31,7 @@
  */
 
 #include <linux/bpf_trace.h>
-#include <net/xdp_sock.h>
+#include <net/xdp_sock_drv.h>
 #include "en/xdp.h"
 #include "en/params.h"
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
index cab0e93497ae..a8e11adbf426 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
@@ -5,7 +5,7 @@
 #define __MLX5_EN_XSK_RX_H__
 
 #include "en.h"
-#include <net/xdp_sock.h>
+#include <net/xdp_sock_drv.h>
 
 /* RX data path */
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h
index 79b487d89757..39fa0a705856 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h
@@ -5,7 +5,7 @@
 #define __MLX5_EN_XSK_TX_H__
 
 #include "en.h"
-#include <net/xdp_sock.h>
+#include <net/xdp_sock_drv.h>
 
 /* TX data path */
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c
index 4baaa5788320..5e49fdb564b3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 /* Copyright (c) 2019 Mellanox Technologies. */
 
-#include <net/xdp_sock.h>
+#include <net/xdp_sock_drv.h>
 #include "umem.h"
 #include "setup.h"
 #include "en/params.h"
diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index 8f3f6f5b0dfe..6a986dcbc336 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -15,6 +15,7 @@
 
 struct net_device;
 struct xsk_queue;
+struct xdp_buff;
 
 /* Masks for xdp_umem_page flags.
  * The low 12-bits of the addr will be 0 since this is the page address, so we
@@ -101,27 +102,9 @@ struct xdp_sock {
 	spinlock_t map_list_lock;
 };
 
-struct xdp_buff;
 #ifdef CONFIG_XDP_SOCKETS
-int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp);
-/* Used from netdev driver */
-bool xsk_umem_has_addrs(struct xdp_umem *umem, u32 cnt);
-bool xsk_umem_peek_addr(struct xdp_umem *umem, u64 *addr);
-void xsk_umem_release_addr(struct xdp_umem *umem);
-void xsk_umem_complete_tx(struct xdp_umem *umem, u32 nb_entries);
-bool xsk_umem_consume_tx(struct xdp_umem *umem, struct xdp_desc *desc);
-void xsk_umem_consume_tx_done(struct xdp_umem *umem);
-struct xdp_umem_fq_reuse *xsk_reuseq_prepare(u32 nentries);
-struct xdp_umem_fq_reuse *xsk_reuseq_swap(struct xdp_umem *umem,
-					  struct xdp_umem_fq_reuse *newq);
-void xsk_reuseq_free(struct xdp_umem_fq_reuse *rq);
-struct xdp_umem *xdp_get_umem_from_qid(struct net_device *dev, u16 queue_id);
-void xsk_set_rx_need_wakeup(struct xdp_umem *umem);
-void xsk_set_tx_need_wakeup(struct xdp_umem *umem);
-void xsk_clear_rx_need_wakeup(struct xdp_umem *umem);
-void xsk_clear_tx_need_wakeup(struct xdp_umem *umem);
-bool xsk_umem_uses_need_wakeup(struct xdp_umem *umem);
 
+int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp);
 int __xsk_map_redirect(struct xdp_sock *xs, struct xdp_buff *xdp);
 void __xsk_map_flush(void);
 
@@ -153,131 +136,24 @@ static inline u64 xsk_umem_add_offset_to_addr(u64 addr)
 	return xsk_umem_extract_addr(addr) + xsk_umem_extract_offset(addr);
 }
 
-static inline char *xdp_umem_get_data(struct xdp_umem *umem, u64 addr)
-{
-	unsigned long page_addr;
-
-	addr = xsk_umem_add_offset_to_addr(addr);
-	page_addr = (unsigned long)umem->pages[addr >> PAGE_SHIFT].addr;
-
-	return (char *)(page_addr & PAGE_MASK) + (addr & ~PAGE_MASK);
-}
-
-static inline dma_addr_t xdp_umem_get_dma(struct xdp_umem *umem, u64 addr)
-{
-	addr = xsk_umem_add_offset_to_addr(addr);
-
-	return umem->pages[addr >> PAGE_SHIFT].dma + (addr & ~PAGE_MASK);
-}
-
-/* Reuse-queue aware version of FILL queue helpers */
-static inline bool xsk_umem_has_addrs_rq(struct xdp_umem *umem, u32 cnt)
-{
-	struct xdp_umem_fq_reuse *rq = umem->fq_reuse;
-
-	if (rq->length >= cnt)
-		return true;
-
-	return xsk_umem_has_addrs(umem, cnt - rq->length);
-}
-
-static inline bool xsk_umem_peek_addr_rq(struct xdp_umem *umem, u64 *addr)
-{
-	struct xdp_umem_fq_reuse *rq = umem->fq_reuse;
-
-	if (!rq->length)
-		return xsk_umem_peek_addr(umem, addr);
-
-	*addr = rq->handles[rq->length - 1];
-	return addr;
-}
-
-static inline void xsk_umem_release_addr_rq(struct xdp_umem *umem)
-{
-	struct xdp_umem_fq_reuse *rq = umem->fq_reuse;
-
-	if (!rq->length)
-		xsk_umem_release_addr(umem);
-	else
-		rq->length--;
-}
-
-static inline void xsk_umem_fq_reuse(struct xdp_umem *umem, u64 addr)
-{
-	struct xdp_umem_fq_reuse *rq = umem->fq_reuse;
-
-	rq->handles[rq->length++] = addr;
-}
-
-/* Handle the offset appropriately depending on aligned or unaligned mode.
- * For unaligned mode, we store the offset in the upper 16-bits of the address.
- * For aligned mode, we simply add the offset to the address.
- */
-static inline u64 xsk_umem_adjust_offset(struct xdp_umem *umem, u64 address,
-					 u64 offset)
-{
-	if (umem->flags & XDP_UMEM_UNALIGNED_CHUNK_FLAG)
-		return address + (offset << XSK_UNALIGNED_BUF_OFFSET_SHIFT);
-	else
-		return address + offset;
-}
-
-static inline u32 xsk_umem_xdp_frame_sz(struct xdp_umem *umem)
-{
-	return umem->chunk_size_nohr;
-}
-
 #else
+
 static inline int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 {
 	return -ENOTSUPP;
 }
 
-static inline bool xsk_umem_has_addrs(struct xdp_umem *umem, u32 cnt)
-{
-	return false;
-}
-
-static inline u64 *xsk_umem_peek_addr(struct xdp_umem *umem, u64 *addr)
-{
-	return NULL;
-}
-
-static inline void xsk_umem_release_addr(struct xdp_umem *umem)
-{
-}
-
-static inline void xsk_umem_complete_tx(struct xdp_umem *umem, u32 nb_entries)
-{
-}
-
-static inline bool xsk_umem_consume_tx(struct xdp_umem *umem,
-				       struct xdp_desc *desc)
-{
-	return false;
-}
-
-static inline void xsk_umem_consume_tx_done(struct xdp_umem *umem)
-{
-}
-
-static inline struct xdp_umem_fq_reuse *xsk_reuseq_prepare(u32 nentries)
+static inline int __xsk_map_redirect(struct xdp_sock *xs, struct xdp_buff *xdp)
 {
-	return NULL;
+	return -EOPNOTSUPP;
 }
 
-static inline struct xdp_umem_fq_reuse *xsk_reuseq_swap(
-	struct xdp_umem *umem,
-	struct xdp_umem_fq_reuse *newq)
-{
-	return NULL;
-}
-static inline void xsk_reuseq_free(struct xdp_umem_fq_reuse *rq)
+static inline void __xsk_map_flush(void)
 {
 }
 
-static inline struct xdp_umem *xdp_get_umem_from_qid(struct net_device *dev,
-						     u16 queue_id)
+static inline struct xdp_sock *__xsk_map_lookup_elem(struct bpf_map *map,
+						     u32 key)
 {
 	return NULL;
 }
@@ -297,80 +173,6 @@ static inline u64 xsk_umem_add_offset_to_addr(u64 addr)
 	return 0;
 }
 
-static inline char *xdp_umem_get_data(struct xdp_umem *umem, u64 addr)
-{
-	return NULL;
-}
-
-static inline dma_addr_t xdp_umem_get_dma(struct xdp_umem *umem, u64 addr)
-{
-	return 0;
-}
-
-static inline bool xsk_umem_has_addrs_rq(struct xdp_umem *umem, u32 cnt)
-{
-	return false;
-}
-
-static inline u64 *xsk_umem_peek_addr_rq(struct xdp_umem *umem, u64 *addr)
-{
-	return NULL;
-}
-
-static inline void xsk_umem_release_addr_rq(struct xdp_umem *umem)
-{
-}
-
-static inline void xsk_umem_fq_reuse(struct xdp_umem *umem, u64 addr)
-{
-}
-
-static inline void xsk_set_rx_need_wakeup(struct xdp_umem *umem)
-{
-}
-
-static inline void xsk_set_tx_need_wakeup(struct xdp_umem *umem)
-{
-}
-
-static inline void xsk_clear_rx_need_wakeup(struct xdp_umem *umem)
-{
-}
-
-static inline void xsk_clear_tx_need_wakeup(struct xdp_umem *umem)
-{
-}
-
-static inline bool xsk_umem_uses_need_wakeup(struct xdp_umem *umem)
-{
-	return false;
-}
-
-static inline u64 xsk_umem_adjust_offset(struct xdp_umem *umem, u64 handle,
-					 u64 offset)
-{
-	return 0;
-}
-
-static inline u32 xsk_umem_xdp_frame_sz(struct xdp_umem *umem)
-{
-	return 0;
-}
-
-static inline int __xsk_map_redirect(struct xdp_sock *xs, struct xdp_buff *xdp)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline void __xsk_map_flush(void)
-{
-}
-
-static inline struct xdp_sock *__xsk_map_lookup_elem(struct bpf_map *map,
-						     u32 key)
-{
-	return NULL;
-}
 #endif /* CONFIG_XDP_SOCKETS */
 
 #endif /* _LINUX_XDP_SOCK_H */
diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
new file mode 100644
index 000000000000..d67f2361937a
--- /dev/null
+++ b/include/net/xdp_sock_drv.h
@@ -0,0 +1,217 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Interface for implementing AF_XDP zero-copy support in drivers.
+ * Copyright(c) 2020 Intel Corporation.
+ */
+
+#ifndef _LINUX_XDP_SOCK_DRV_H
+#define _LINUX_XDP_SOCK_DRV_H
+
+#include <net/xdp_sock.h>
+
+#ifdef CONFIG_XDP_SOCKETS
+
+bool xsk_umem_has_addrs(struct xdp_umem *umem, u32 cnt);
+bool xsk_umem_peek_addr(struct xdp_umem *umem, u64 *addr);
+void xsk_umem_release_addr(struct xdp_umem *umem);
+void xsk_umem_complete_tx(struct xdp_umem *umem, u32 nb_entries);
+bool xsk_umem_consume_tx(struct xdp_umem *umem, struct xdp_desc *desc);
+void xsk_umem_consume_tx_done(struct xdp_umem *umem);
+struct xdp_umem_fq_reuse *xsk_reuseq_prepare(u32 nentries);
+struct xdp_umem_fq_reuse *xsk_reuseq_swap(struct xdp_umem *umem,
+					  struct xdp_umem_fq_reuse *newq);
+void xsk_reuseq_free(struct xdp_umem_fq_reuse *rq);
+struct xdp_umem *xdp_get_umem_from_qid(struct net_device *dev, u16 queue_id);
+void xsk_set_rx_need_wakeup(struct xdp_umem *umem);
+void xsk_set_tx_need_wakeup(struct xdp_umem *umem);
+void xsk_clear_rx_need_wakeup(struct xdp_umem *umem);
+void xsk_clear_tx_need_wakeup(struct xdp_umem *umem);
+bool xsk_umem_uses_need_wakeup(struct xdp_umem *umem);
+
+static inline char *xdp_umem_get_data(struct xdp_umem *umem, u64 addr)
+{
+	unsigned long page_addr;
+
+	addr = xsk_umem_add_offset_to_addr(addr);
+	page_addr = (unsigned long)umem->pages[addr >> PAGE_SHIFT].addr;
+
+	return (char *)(page_addr & PAGE_MASK) + (addr & ~PAGE_MASK);
+}
+
+static inline dma_addr_t xdp_umem_get_dma(struct xdp_umem *umem, u64 addr)
+{
+	addr = xsk_umem_add_offset_to_addr(addr);
+
+	return umem->pages[addr >> PAGE_SHIFT].dma + (addr & ~PAGE_MASK);
+}
+
+/* Reuse-queue aware version of FILL queue helpers */
+static inline bool xsk_umem_has_addrs_rq(struct xdp_umem *umem, u32 cnt)
+{
+	struct xdp_umem_fq_reuse *rq = umem->fq_reuse;
+
+	if (rq->length >= cnt)
+		return true;
+
+	return xsk_umem_has_addrs(umem, cnt - rq->length);
+}
+
+static inline bool xsk_umem_peek_addr_rq(struct xdp_umem *umem, u64 *addr)
+{
+	struct xdp_umem_fq_reuse *rq = umem->fq_reuse;
+
+	if (!rq->length)
+		return xsk_umem_peek_addr(umem, addr);
+
+	*addr = rq->handles[rq->length - 1];
+	return addr;
+}
+
+static inline void xsk_umem_release_addr_rq(struct xdp_umem *umem)
+{
+	struct xdp_umem_fq_reuse *rq = umem->fq_reuse;
+
+	if (!rq->length)
+		xsk_umem_release_addr(umem);
+	else
+		rq->length--;
+}
+
+static inline void xsk_umem_fq_reuse(struct xdp_umem *umem, u64 addr)
+{
+	struct xdp_umem_fq_reuse *rq = umem->fq_reuse;
+
+	rq->handles[rq->length++] = addr;
+}
+
+/* Handle the offset appropriately depending on aligned or unaligned mode.
+ * For unaligned mode, we store the offset in the upper 16-bits of the address.
+ * For aligned mode, we simply add the offset to the address.
+ */
+static inline u64 xsk_umem_adjust_offset(struct xdp_umem *umem, u64 address,
+					 u64 offset)
+{
+	if (umem->flags & XDP_UMEM_UNALIGNED_CHUNK_FLAG)
+		return address + (offset << XSK_UNALIGNED_BUF_OFFSET_SHIFT);
+	else
+		return address + offset;
+}
+
+static inline u32 xsk_umem_xdp_frame_sz(struct xdp_umem *umem)
+{
+	return umem->chunk_size_nohr;
+}
+
+#else
+
+static inline bool xsk_umem_has_addrs(struct xdp_umem *umem, u32 cnt)
+{
+	return false;
+}
+
+static inline u64 *xsk_umem_peek_addr(struct xdp_umem *umem, u64 *addr)
+{
+	return NULL;
+}
+
+static inline void xsk_umem_release_addr(struct xdp_umem *umem)
+{
+}
+
+static inline void xsk_umem_complete_tx(struct xdp_umem *umem, u32 nb_entries)
+{
+}
+
+static inline bool xsk_umem_consume_tx(struct xdp_umem *umem,
+				       struct xdp_desc *desc)
+{
+	return false;
+}
+
+static inline void xsk_umem_consume_tx_done(struct xdp_umem *umem)
+{
+}
+
+static inline struct xdp_umem_fq_reuse *xsk_reuseq_prepare(u32 nentries)
+{
+	return NULL;
+}
+
+static inline struct xdp_umem_fq_reuse *xsk_reuseq_swap(
+	struct xdp_umem *umem, struct xdp_umem_fq_reuse *newq)
+{
+	return NULL;
+}
+
+static inline void xsk_reuseq_free(struct xdp_umem_fq_reuse *rq)
+{
+}
+
+static inline struct xdp_umem *xdp_get_umem_from_qid(struct net_device *dev,
+						     u16 queue_id)
+{
+	return NULL;
+}
+
+static inline char *xdp_umem_get_data(struct xdp_umem *umem, u64 addr)
+{
+	return NULL;
+}
+
+static inline dma_addr_t xdp_umem_get_dma(struct xdp_umem *umem, u64 addr)
+{
+	return 0;
+}
+
+static inline bool xsk_umem_has_addrs_rq(struct xdp_umem *umem, u32 cnt)
+{
+	return false;
+}
+
+static inline u64 *xsk_umem_peek_addr_rq(struct xdp_umem *umem, u64 *addr)
+{
+	return NULL;
+}
+
+static inline void xsk_umem_release_addr_rq(struct xdp_umem *umem)
+{
+}
+
+static inline void xsk_umem_fq_reuse(struct xdp_umem *umem, u64 addr)
+{
+}
+
+static inline void xsk_set_rx_need_wakeup(struct xdp_umem *umem)
+{
+}
+
+static inline void xsk_set_tx_need_wakeup(struct xdp_umem *umem)
+{
+}
+
+static inline void xsk_clear_rx_need_wakeup(struct xdp_umem *umem)
+{
+}
+
+static inline void xsk_clear_tx_need_wakeup(struct xdp_umem *umem)
+{
+}
+
+static inline bool xsk_umem_uses_need_wakeup(struct xdp_umem *umem)
+{
+	return false;
+}
+
+static inline u64 xsk_umem_adjust_offset(struct xdp_umem *umem, u64 handle,
+					 u64 offset)
+{
+	return 0;
+}
+
+static inline u32 xsk_umem_xdp_frame_sz(struct xdp_umem *umem)
+{
+	return 0;
+}
+
+#endif /* CONFIG_XDP_SOCKETS */
+
+#endif /* _LINUX_XDP_SOCK_DRV_H */
diff --git a/net/ethtool/channels.c b/net/ethtool/channels.c
index 389924b65d05..658a8580b464 100644
--- a/net/ethtool/channels.c
+++ b/net/ethtool/channels.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
-#include <net/xdp_sock.h>
+#include <net/xdp_sock_drv.h>
 
 #include "netlink.h"
 #include "common.h"
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 52102ab1709b..74892623bacd 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -24,7 +24,7 @@
 #include <linux/sched/signal.h>
 #include <linux/net.h>
 #include <net/devlink.h>
-#include <net/xdp_sock.h>
+#include <net/xdp_sock_drv.h>
 #include <net/flow_offload.h>
 #include <linux/ethtool_netlink.h>
 #include <generated/utsrelease.h>
diff --git a/net/xdp/xdp_umem.h b/net/xdp/xdp_umem.h
index a63a9fb251f5..32067fe98f65 100644
--- a/net/xdp/xdp_umem.h
+++ b/net/xdp/xdp_umem.h
@@ -6,7 +6,7 @@
 #ifndef XDP_UMEM_H_
 #define XDP_UMEM_H_
 
-#include <net/xdp_sock.h>
+#include <net/xdp_sock_drv.h>
 
 int xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device *dev,
 			u16 queue_id, u16 flags);
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 45ffd67b367d..8bda654e82ec 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -22,7 +22,7 @@
 #include <linux/net.h>
 #include <linux/netdevice.h>
 #include <linux/rculist.h>
-#include <net/xdp_sock.h>
+#include <net/xdp_sock_drv.h>
 #include <net/xdp.h>
 
 #include "xsk_queue.h"
-- 
2.25.1

