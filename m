Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D205C36BAA5
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 22:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241831AbhDZUXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 16:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241723AbhDZUXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 16:23:34 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5C3FC061574;
        Mon, 26 Apr 2021 13:22:52 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id e15so2989761pfv.10;
        Mon, 26 Apr 2021 13:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2E5BbTFu8TaHjbS762TAvdqoNpNI4ZEzM4XRhWBtwy8=;
        b=fOwTbLr451vqXXshunTNzQiYw3jOSOIg2AJN+nOT1u0s4YXICCD09DVFs8hMWqql/z
         uHy59DwCtW0s33j9siFRmpmoTKtQ5nXwGZJyT2kbrvIMyocH8Obu1EFTCyE6D7R3Nm94
         m73X2mjV4XZz7nIpdJRdEdYK3kBLmCXUX58vwxF9u8VVep+mAibDfPkpPYC5Sgc7Tmx5
         7k2kKfIk+slGd4Xgbt9ojaHW5w3+vWPnHXPwTnLAh6m5Izp9MrcqPKrejlyEkCOLccaR
         lZFV8ke10RJ0sHION4891aMi4GgpVKixFuF/VKV9tuu8lwKubRW6ja/GHmplynETU91L
         gGYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2E5BbTFu8TaHjbS762TAvdqoNpNI4ZEzM4XRhWBtwy8=;
        b=Gbz7u6OnvKo6C3cK8f3xpNH8PGc2Xdq+8mOrXdrchMVGFDXO0hRTiD9op+c+NcUBR7
         Bn2kQQEX1z0R5Q2a6EY9yo4vS5DY/qmqPUVYm4fizPKJBnr/VeNoyKsPP/PRjbk7grzm
         ic2hprKcNSKpjq4CSqTbasr2Dv5grhUaqRYMxqyQSYTReUiJxNsMlxM0AJGyZfM+JG5s
         wplJUIC1W90WY1bDIJNjgeEV1fUb+PnMj8m7XL8wvkoTCPQlDIy3vJelVWO9mWJ2L+Td
         eEhKdVmcoeVDBwxfHENgs5cLjbc8VgdRi63waO8dndknBTJUIyRky4WioWVnq5Jy/Jwk
         hPyw==
X-Gm-Message-State: AOAM5318Pt1qBtF9XAdyy0GI2xg7vWWTHms1oEPtZktdfSvsvv9KHEtv
        ZwxsmOzHFBVH7sUhqEIv5BY4GD2ivkQKpQ==
X-Google-Smtp-Source: ABdhPJxAQ700KV/bahEFk7Af0xFGfbAFi3yZTkviHS6yqgY/2lY38U097VlEjtWoAhjsSueX7zXk4Q==
X-Received: by 2002:a63:135d:: with SMTP id 29mr11836081pgt.83.1619468571871;
        Mon, 26 Apr 2021 13:22:51 -0700 (PDT)
Received: from localhost ([112.79.234.242])
        by smtp.gmail.com with ESMTPSA id p10sm12190694pgn.85.2021.04.26.13.22.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 13:22:51 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH] libbpf: export inline helpers as symbols for xsk
Date:   Tue, 27 Apr 2021 01:52:40 +0530
Message-Id: <20210426202240.518961-1-memxor@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This helps people writing language bindings to not have to rewrite C
wrappers for inline functions in the headers. We force inline the
definition from the header for C and C++ consumers, but also export a
symbol in the library for others. This keeps the performance
advantages similar to using static inline, while also allowing tools
like Rust's bindgen to generate wrappers for the functions.

Also see
https://lore.kernel.org/bpf/CAJ8uoz0QqR97qEYYK=VVCE9A=V=k2tKnH6wNM48jeak2RAmL0A@mail.gmail.com/
for some context.

Also see https://github.com/xdp-project/xdp-tools/pull/97 for more
discussion on the same.

extern inline is used as it's slightly better since it warns when an
inline definition is missing.

The fvisibility attribute goes on the inline definition, as essentially
it acts as a declaration for the function, while the extern inline
declaration ends up acting as a definition.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/libbpf.map | 16 ++++++++++++++
 tools/lib/bpf/xsk.c      | 24 +++++++++++++++++++++
 tools/lib/bpf/xsk.h      | 45 +++++++++++++++++++++++-----------------
 3 files changed, 66 insertions(+), 19 deletions(-)

diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index b9b29baf1df8..52ece4296f4b 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -361,4 +361,20 @@ LIBBPF_0.4.0 {
 		bpf_linker__new;
 		bpf_map__inner_map;
 		bpf_object__set_kversion;
+		xsk_cons_nb_avail;
+		xsk_prod_nb_free;
+		xsk_ring_cons__cancel;
+		xsk_ring_cons__comp_addr;
+		xsk_ring_cons__peek;
+		xsk_ring_cons__release;
+		xsk_ring_cons__rx_desc;
+		xsk_ring_prod__fill_addr;
+		xsk_ring_prod__needs_wakeup;
+		xsk_ring_prod__reserve;
+		xsk_ring_prod__submit;
+		xsk_ring_prod__tx_desc;
+		xsk_umem__add_offset_to_addr;
+		xsk_umem__extract_addr;
+		xsk_umem__extract_offset;
+		xsk_umem__get_data;
 } LIBBPF_0.3.0;
diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 95da0e19f4a5..ebe370837024 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -107,6 +107,30 @@ struct xdp_mmap_offsets_v1 {
 	struct xdp_ring_offset_v1 cr;
 };
 
+/* Export all inline helpers as symbols for use by language bindings. */
+extern inline __u64 *xsk_ring_prod__fill_addr(struct xsk_ring_prod *fill,
+					      __u32 idx);
+extern inline const __u64 *
+xsk_ring_cons__comp_addr(const struct xsk_ring_cons *comp, __u32 idx);
+extern inline struct xdp_desc *xsk_ring_prod__tx_desc(struct xsk_ring_prod *tx,
+						      __u32 idx);
+extern inline const struct xdp_desc *
+xsk_ring_cons__rx_desc(const struct xsk_ring_cons *rx, __u32 idx);
+extern inline int xsk_ring_prod__needs_wakeup(const struct xsk_ring_prod *r);
+extern inline __u32 xsk_prod_nb_free(struct xsk_ring_prod *r, __u32 nb);
+extern inline __u32 xsk_cons_nb_avail(struct xsk_ring_cons *r, __u32 nb);
+extern inline __u32 xsk_ring_prod__reserve(struct xsk_ring_prod *prod, __u32 nb,
+					   __u32 *idx);
+extern inline void xsk_ring_prod__submit(struct xsk_ring_prod *prod, __u32 nb);
+extern inline __u32 xsk_ring_cons__peek(struct xsk_ring_cons *cons, __u32 nb,
+					__u32 *idx);
+extern inline void xsk_ring_cons__cancel(struct xsk_ring_cons *cons, __u32 nb);
+extern inline void xsk_ring_cons__release(struct xsk_ring_cons *cons, __u32 nb);
+extern inline void *xsk_umem__get_data(void *umem_area, __u64 addr);
+extern inline __u64 xsk_umem__extract_addr(__u64 addr);
+extern inline __u64 xsk_umem__extract_offset(__u64 addr);
+extern inline __u64 xsk_umem__add_offset_to_addr(__u64 addr);
+
 int xsk_umem__fd(const struct xsk_umem *umem)
 {
 	return umem ? umem->fd : -EINVAL;
diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
index 01c12dca9c10..8ab1d0453fbe 100644
--- a/tools/lib/bpf/xsk.h
+++ b/tools/lib/bpf/xsk.h
@@ -111,15 +111,15 @@ DEFINE_XSK_RING(xsk_ring_cons);
 struct xsk_umem;
 struct xsk_socket;
 
-static inline __u64 *xsk_ring_prod__fill_addr(struct xsk_ring_prod *fill,
-					      __u32 idx)
+LIBBPF_API __always_inline __u64 *
+xsk_ring_prod__fill_addr(struct xsk_ring_prod *fill, __u32 idx)
 {
 	__u64 *addrs = (__u64 *)fill->ring;
 
 	return &addrs[idx & fill->mask];
 }
 
-static inline const __u64 *
+LIBBPF_API __always_inline const __u64 *
 xsk_ring_cons__comp_addr(const struct xsk_ring_cons *comp, __u32 idx)
 {
 	const __u64 *addrs = (const __u64 *)comp->ring;
@@ -127,15 +127,15 @@ xsk_ring_cons__comp_addr(const struct xsk_ring_cons *comp, __u32 idx)
 	return &addrs[idx & comp->mask];
 }
 
-static inline struct xdp_desc *xsk_ring_prod__tx_desc(struct xsk_ring_prod *tx,
-						      __u32 idx)
+LIBBPF_API __always_inline struct xdp_desc *
+xsk_ring_prod__tx_desc(struct xsk_ring_prod *tx, __u32 idx)
 {
 	struct xdp_desc *descs = (struct xdp_desc *)tx->ring;
 
 	return &descs[idx & tx->mask];
 }
 
-static inline const struct xdp_desc *
+LIBBPF_API __always_inline const struct xdp_desc *
 xsk_ring_cons__rx_desc(const struct xsk_ring_cons *rx, __u32 idx)
 {
 	const struct xdp_desc *descs = (const struct xdp_desc *)rx->ring;
@@ -143,12 +143,14 @@ xsk_ring_cons__rx_desc(const struct xsk_ring_cons *rx, __u32 idx)
 	return &descs[idx & rx->mask];
 }
 
-static inline int xsk_ring_prod__needs_wakeup(const struct xsk_ring_prod *r)
+LIBBPF_API __always_inline int
+xsk_ring_prod__needs_wakeup(const struct xsk_ring_prod *r)
 {
 	return *r->flags & XDP_RING_NEED_WAKEUP;
 }
 
-static inline __u32 xsk_prod_nb_free(struct xsk_ring_prod *r, __u32 nb)
+LIBBPF_API __always_inline __u32 xsk_prod_nb_free(struct xsk_ring_prod *r,
+						  __u32 nb)
 {
 	__u32 free_entries = r->cached_cons - r->cached_prod;
 
@@ -168,7 +170,8 @@ static inline __u32 xsk_prod_nb_free(struct xsk_ring_prod *r, __u32 nb)
 	return r->cached_cons - r->cached_prod;
 }
 
-static inline __u32 xsk_cons_nb_avail(struct xsk_ring_cons *r, __u32 nb)
+LIBBPF_API __always_inline __u32 xsk_cons_nb_avail(struct xsk_ring_cons *r,
+						   __u32 nb)
 {
 	__u32 entries = r->cached_prod - r->cached_cons;
 
@@ -180,7 +183,8 @@ static inline __u32 xsk_cons_nb_avail(struct xsk_ring_cons *r, __u32 nb)
 	return (entries > nb) ? nb : entries;
 }
 
-static inline __u32 xsk_ring_prod__reserve(struct xsk_ring_prod *prod, __u32 nb, __u32 *idx)
+LIBBPF_API __always_inline __u32
+xsk_ring_prod__reserve(struct xsk_ring_prod *prod, __u32 nb, __u32 *idx)
 {
 	if (xsk_prod_nb_free(prod, nb) < nb)
 		return 0;
@@ -191,7 +195,8 @@ static inline __u32 xsk_ring_prod__reserve(struct xsk_ring_prod *prod, __u32 nb,
 	return nb;
 }
 
-static inline void xsk_ring_prod__submit(struct xsk_ring_prod *prod, __u32 nb)
+LIBBPF_API __always_inline void
+xsk_ring_prod__submit(struct xsk_ring_prod *prod, __u32 nb)
 {
 	/* Make sure everything has been written to the ring before indicating
 	 * this to the kernel by writing the producer pointer.
@@ -199,7 +204,8 @@ static inline void xsk_ring_prod__submit(struct xsk_ring_prod *prod, __u32 nb)
 	libbpf_smp_store_release(prod->producer, *prod->producer + nb);
 }
 
-static inline __u32 xsk_ring_cons__peek(struct xsk_ring_cons *cons, __u32 nb, __u32 *idx)
+LIBBPF_API __always_inline __u32 xsk_ring_cons__peek(struct xsk_ring_cons *cons,
+						     __u32 nb, __u32 *idx)
 {
 	__u32 entries = xsk_cons_nb_avail(cons, nb);
 
@@ -211,36 +217,37 @@ static inline __u32 xsk_ring_cons__peek(struct xsk_ring_cons *cons, __u32 nb, __
 	return entries;
 }
 
-static inline void xsk_ring_cons__cancel(struct xsk_ring_cons *cons, __u32 nb)
+LIBBPF_API __always_inline void
+xsk_ring_cons__cancel(struct xsk_ring_cons *cons, __u32 nb)
 {
 	cons->cached_cons -= nb;
 }
 
-static inline void xsk_ring_cons__release(struct xsk_ring_cons *cons, __u32 nb)
+LIBBPF_API __always_inline void
+xsk_ring_cons__release(struct xsk_ring_cons *cons, __u32 nb)
 {
 	/* Make sure data has been read before indicating we are done
 	 * with the entries by updating the consumer pointer.
 	 */
 	libbpf_smp_store_release(cons->consumer, *cons->consumer + nb);
-
 }
 
-static inline void *xsk_umem__get_data(void *umem_area, __u64 addr)
+LIBBPF_API __always_inline void *xsk_umem__get_data(void *umem_area, __u64 addr)
 {
 	return &((char *)umem_area)[addr];
 }
 
-static inline __u64 xsk_umem__extract_addr(__u64 addr)
+LIBBPF_API __always_inline __u64 xsk_umem__extract_addr(__u64 addr)
 {
 	return addr & XSK_UNALIGNED_BUF_ADDR_MASK;
 }
 
-static inline __u64 xsk_umem__extract_offset(__u64 addr)
+LIBBPF_API __always_inline __u64 xsk_umem__extract_offset(__u64 addr)
 {
 	return addr >> XSK_UNALIGNED_BUF_OFFSET_SHIFT;
 }
 
-static inline __u64 xsk_umem__add_offset_to_addr(__u64 addr)
+LIBBPF_API __always_inline __u64 xsk_umem__add_offset_to_addr(__u64 addr)
 {
 	return xsk_umem__extract_addr(addr) + xsk_umem__extract_offset(addr);
 }
-- 
2.30.2

