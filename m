Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEC271C3852
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 13:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728627AbgEDLh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 07:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728270AbgEDLhz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 07:37:55 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1481C061A0E;
        Mon,  4 May 2020 04:37:55 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id e6so3565110pjt.4;
        Mon, 04 May 2020 04:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Xf5IVy65g91vTTeHf6eCCGwgKbEgXAbfMU9L7r+bNeA=;
        b=mr4QAcFOdBia9LfA+fHWy2CbcHdS2c3QFIKOh5SqGARQDPtzA856/061UiiguYQ0f9
         FpZgVbOsewITkPjL0K/u+Fl9aC2mfz38P78PdegToi27+oeMUVd0TZS04Xsh56uqBGkU
         g5Ytn0Yxq4Z0CW/Bkn37a6oTDfUs8ualWfP8W7pBrj56J7vR8579UyADRV4THlEzluWE
         lkEYq1BaRIC8MBoiua7P3SuwsIkong06BRXNy1440KQIb8c6cTEZoUubvbqfKp20CvTZ
         BxHCQ+rvgJoGsLjyNLZCWs/MF2M+f6CDvqLiGhRmBlCiCcjIxz/F/MsNk1d1xCyEdWel
         8gow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xf5IVy65g91vTTeHf6eCCGwgKbEgXAbfMU9L7r+bNeA=;
        b=TLHQMDBJiCSLyPEBuKGMymGTnj/hKNjkt6KQFR6UbK3n78/A4tkMy1dOqCIOgYra5w
         vouQXp/u0NHOPubsATB6ZOXVwiOmVm3CZHMSAtqfCXX+9F70L13KN+li42oH+s1kbe0Q
         ZAgn1ejLB1JA0jUaE4x5nC3p11sC0fzSsvToo0PaToKCwzxsA1PYc1wOB8f+npEqmVZV
         oRVlZFSCCSUrfBgM5VIp2ixtc+eaJG5abP+36Jgv+YfuI7gqnwBmnNrnzpGgC+AOea1X
         q32dCDqNslFzc3TUEU5yhTxKbJw5jXZhgEcIbEuagGfC3SPTc+Q6XTbLS7reecv1hF0M
         H0dw==
X-Gm-Message-State: AGi0PubUF73kZwY7TuJFWcUj/Uz6KkoEnhy9aj5jEZN6TC+fY0m5/Z7X
        sF0+dMi0fyvbjUGcNC7EF0o=
X-Google-Smtp-Source: APiQypKFgVG919D7Ex7N7S8CUz2HW94fnhygvkVd4Me8XkMVTu+HMd4Rhdr7eKDxvg3VbKhuYIz4ZQ==
X-Received: by 2002:a17:902:c382:: with SMTP id g2mr16510484plg.228.1588592275089;
        Mon, 04 May 2020 04:37:55 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id x185sm8650789pfx.155.2020.05.04.04.37.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 04:37:54 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        maximmi@mellanox.com, maciej.fijalkowski@intel.com
Subject: [RFC PATCH bpf-next 01/13] xsk: move xskmap.c to net/xdp/
Date:   Mon,  4 May 2020 13:37:03 +0200
Message-Id: <20200504113716.7930-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200504113716.7930-1-bjorn.topel@gmail.com>
References: <20200504113716.7930-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The XSKMAP is partly implemented by net/xdp/xsk.c. Move xskmap.c from
kernel/bpf/ to net/xdp/, which is the logical place for AF_XDP related
code. Also, move AF_XDP struct definitions, and function declarations
only used by AF_XDP internals into net/xdp/xsk.h.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/net/xdp_sock.h           | 20 --------------------
 kernel/bpf/Makefile              |  3 ---
 net/xdp/Makefile                 |  2 +-
 net/xdp/xsk.h                    | 16 ++++++++++++++++
 {kernel/bpf => net/xdp}/xskmap.c |  2 ++
 5 files changed, 19 insertions(+), 24 deletions(-)
 rename {kernel/bpf => net/xdp}/xskmap.c (99%)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index e86ec48ef627..6575dc0d18d3 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -66,22 +66,12 @@ struct xdp_umem {
 	struct list_head xsk_list;
 };
 
-/* Nodes are linked in the struct xdp_sock map_list field, and used to
- * track which maps a certain socket reside in.
- */
-
 struct xsk_map {
 	struct bpf_map map;
 	spinlock_t lock; /* Synchronize map updates */
 	struct xdp_sock *xsk_map[];
 };
 
-struct xsk_map_node {
-	struct list_head node;
-	struct xsk_map *map;
-	struct xdp_sock **map_entry;
-};
-
 struct xdp_sock {
 	/* struct sock must be the first member of struct xdp_sock */
 	struct sock sk;
@@ -115,7 +105,6 @@ struct xdp_sock {
 struct xdp_buff;
 #ifdef CONFIG_XDP_SOCKETS
 int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp);
-bool xsk_is_setup_for_bpf_map(struct xdp_sock *xs);
 /* Used from netdev driver */
 bool xsk_umem_has_addrs(struct xdp_umem *umem, u32 cnt);
 bool xsk_umem_peek_addr(struct xdp_umem *umem, u64 *addr);
@@ -134,10 +123,6 @@ void xsk_clear_rx_need_wakeup(struct xdp_umem *umem);
 void xsk_clear_tx_need_wakeup(struct xdp_umem *umem);
 bool xsk_umem_uses_need_wakeup(struct xdp_umem *umem);
 
-void xsk_map_try_sock_delete(struct xsk_map *map, struct xdp_sock *xs,
-			     struct xdp_sock **map_entry);
-int xsk_map_inc(struct xsk_map *map);
-void xsk_map_put(struct xsk_map *map);
 int __xsk_map_redirect(struct xdp_sock *xs, struct xdp_buff *xdp);
 void __xsk_map_flush(void);
 
@@ -243,11 +228,6 @@ static inline int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 	return -ENOTSUPP;
 }
 
-static inline bool xsk_is_setup_for_bpf_map(struct xdp_sock *xs)
-{
-	return false;
-}
-
 static inline bool xsk_umem_has_addrs(struct xdp_umem *umem, u32 cnt)
 {
 	return false;
diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index f2d7be596966..c4334132816e 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -12,9 +12,6 @@ obj-$(CONFIG_BPF_JIT) += dispatcher.o
 ifeq ($(CONFIG_NET),y)
 obj-$(CONFIG_BPF_SYSCALL) += devmap.o
 obj-$(CONFIG_BPF_SYSCALL) += cpumap.o
-ifeq ($(CONFIG_XDP_SOCKETS),y)
-obj-$(CONFIG_BPF_SYSCALL) += xskmap.o
-endif
 obj-$(CONFIG_BPF_SYSCALL) += offload.o
 endif
 ifeq ($(CONFIG_PERF_EVENTS),y)
diff --git a/net/xdp/Makefile b/net/xdp/Makefile
index 71e2bdafb2ce..90b5460d6166 100644
--- a/net/xdp/Makefile
+++ b/net/xdp/Makefile
@@ -1,3 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-$(CONFIG_XDP_SOCKETS) += xsk.o xdp_umem.o xsk_queue.o
+obj-$(CONFIG_XDP_SOCKETS) += xsk.o xdp_umem.o xsk_queue.o xskmap.o
 obj-$(CONFIG_XDP_SOCKETS_DIAG) += xsk_diag.o
diff --git a/net/xdp/xsk.h b/net/xdp/xsk.h
index 4cfd106bdb53..d6a0979050e6 100644
--- a/net/xdp/xsk.h
+++ b/net/xdp/xsk.h
@@ -17,9 +17,25 @@ struct xdp_mmap_offsets_v1 {
 	struct xdp_ring_offset_v1 cr;
 };
 
+/* Nodes are linked in the struct xdp_sock map_list field, and used to
+ * track which maps a certain socket reside in.
+ */
+
+struct xsk_map_node {
+	struct list_head node;
+	struct xsk_map *map;
+	struct xdp_sock **map_entry;
+};
+
 static inline struct xdp_sock *xdp_sk(struct sock *sk)
 {
 	return (struct xdp_sock *)sk;
 }
 
+bool xsk_is_setup_for_bpf_map(struct xdp_sock *xs);
+void xsk_map_try_sock_delete(struct xsk_map *map, struct xdp_sock *xs,
+			     struct xdp_sock **map_entry);
+int xsk_map_inc(struct xsk_map *map);
+void xsk_map_put(struct xsk_map *map);
+
 #endif /* XSK_H_ */
diff --git a/kernel/bpf/xskmap.c b/net/xdp/xskmap.c
similarity index 99%
rename from kernel/bpf/xskmap.c
rename to net/xdp/xskmap.c
index 2cc5c8f4c800..1dc7208c71ba 100644
--- a/kernel/bpf/xskmap.c
+++ b/net/xdp/xskmap.c
@@ -9,6 +9,8 @@
 #include <linux/slab.h>
 #include <linux/sched.h>
 
+#include "xsk.h"
+
 int xsk_map_inc(struct xsk_map *map)
 {
 	bpf_map_inc(&map->map);
-- 
2.25.1

