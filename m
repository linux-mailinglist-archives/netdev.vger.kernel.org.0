Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0B93AE11E
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 01:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbhFTXfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 19:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbhFTXft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Jun 2021 19:35:49 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F93C061574;
        Sun, 20 Jun 2021 16:33:35 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id x22so6006536pll.11;
        Sun, 20 Jun 2021 16:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0wVwVKGBl1QYKrKXBPYw1jrL4My9H+MtmykDPQrZHPs=;
        b=Fze3XTXJjyln5MLElDr+EA53Z52A8+fn5RyAIzWCjHxLAljvqi69bntzBkMxuGkgXn
         O5MIuTm1IukkmWMhIcgkjL0Mm/0hzhiLvAKx7Th4eMnWQL0Sy1C4jSPDrJKJh8ah2rdc
         2xZTSVZe137/5qQvtSvCj8HGgPMdNso3rl/NXaouryFjyYZR7vQIf0dLm7nPzVWFAYBA
         yw/AbDuF+BcWO6PjRwxnu7iAMhOZvZCKfIxMxlBlXcJvo2ve4rIIjPqma5w6glfZmc9N
         mr/FM3pMAIjGLLGC4GmbY3hB7w87HCbgrpbW66n81xf+k9hXDK4MA0FEHjiMYXqIBd0A
         N/bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0wVwVKGBl1QYKrKXBPYw1jrL4My9H+MtmykDPQrZHPs=;
        b=njmmNNFMobxZ3v51V2GCUhBpvVHdbNvDpXEke1LjIIwCYnox92c3P8D9TDqL48PVL3
         KC82hBi8cj+RVWd97XldVw6nsXKJwnvJiSL5d1I20Btct9ucDbg8VhGFw/ctr3Cngdua
         1o0wt0ioR/4OnEj1qXGT8BE4YgYdCLNjSZrqCWb7jZXEkgNS8+oJxzZesLuXieC5eHkP
         C1xAvrxLChiJ7HiDdrr63XHNOibNfVkHG9ggLGBcaOK+gb+4qCV1n+MAM8G8dWijYAnl
         Udx2zkEch7XVZ6o99NAC6MDh6gtEQB3mFxoV680gJ+/qonWP8JMGqigIXA5qtxUMiEJx
         3bJg==
X-Gm-Message-State: AOAM5338tAdRrHutYBA2C7d/64eiPfCL9VY4bK1mzmWRypFUmrFx7s5d
        twrZBX68XSzp1PN8QCZ6ZdSKWHNluIE=
X-Google-Smtp-Source: ABdhPJyTrl/K1HPaUlIe75Cy3JQuRPZMRUHCTFIx5x28RdpkN0VDwoPpRrffyPCECZcg1Vad3bZS8g==
X-Received: by 2002:a17:902:6b84:b029:ee:f966:1911 with SMTP id p4-20020a1709026b84b02900eef9661911mr15251611plk.69.1624232014990;
        Sun, 20 Jun 2021 16:33:34 -0700 (PDT)
Received: from localhost ([2409:4063:4d19:cf2b:5167:bcec:f927:8a69])
        by smtp.gmail.com with ESMTPSA id a187sm13344572pfb.66.2021.06.20.16.33.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Jun 2021 16:33:34 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Subject: [PATCH net-next 1/4] net: core: split out code to run generic XDP prog
Date:   Mon, 21 Jun 2021 05:01:57 +0530
Message-Id: <20210620233200.855534-2-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210620233200.855534-1-memxor@gmail.com>
References: <20210620233200.855534-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This helper can later be utilized in code that runs cpumap and devmap
programs in generic redirect mode and adjust skb based on changes made
to xdp_buff.

When returning XDP_REDIRECT/XDP_TX, it invokes __skb_push, so whenever a
generic redirect path invokes devmap/cpumap prog if set, it must
__skb_pull again as we expect mac header to be pulled.

It also drops the skb_reset_mac_len call after do_xdp_generic, as the
mac_header and network_header are advanced by the same offset, so the
difference (mac_len) remains constant.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
NB: I am not too sure why the skb_reset_mac_len was there, so I removed it since
the offset addition/subtraction should be same for network_header and
mac_header, but I could be missing something important...
---
 include/linux/netdevice.h |  2 +
 net/core/dev.c            | 86 ++++++++++++++++++++++++---------------
 2 files changed, 56 insertions(+), 32 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index be1dcceda5e4..90472ea70db2 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3984,6 +3984,8 @@ static inline void dev_consume_skb_any(struct sk_buff *skb)
 	__dev_kfree_skb_any(skb, SKB_REASON_CONSUMED);
 }

+u32 bpf_prog_run_generic_xdp(struct sk_buff *skb, struct xdp_buff *xdp,
+			     struct bpf_prog *xdp_prog);
 void generic_xdp_tx(struct sk_buff *skb, struct bpf_prog *xdp_prog);
 int do_xdp_generic(struct bpf_prog *xdp_prog, struct sk_buff *skb);
 int netif_rx(struct sk_buff *skb);
diff --git a/net/core/dev.c b/net/core/dev.c
index 50531a2d0b20..e86c6091f9cf 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4717,44 +4717,17 @@ static struct netdev_rx_queue *netif_get_rxqueue(struct sk_buff *skb)
 	return rxqueue;
 }

-static u32 netif_receive_generic_xdp(struct sk_buff *skb,
-				     struct xdp_buff *xdp,
-				     struct bpf_prog *xdp_prog)
+u32 bpf_prog_run_generic_xdp(struct sk_buff *skb, struct xdp_buff *xdp,
+			     struct bpf_prog *xdp_prog)
 {
 	void *orig_data, *orig_data_end, *hard_start;
 	struct netdev_rx_queue *rxqueue;
-	u32 metalen, act = XDP_DROP;
 	bool orig_bcast, orig_host;
 	u32 mac_len, frame_sz;
 	__be16 orig_eth_type;
 	struct ethhdr *eth;
-	int off;
-
-	/* Reinjected packets coming from act_mirred or similar should
-	 * not get XDP generic processing.
-	 */
-	if (skb_is_redirected(skb))
-		return XDP_PASS;
-
-	/* XDP packets must be linear and must have sufficient headroom
-	 * of XDP_PACKET_HEADROOM bytes. This is the guarantee that also
-	 * native XDP provides, thus we need to do it here as well.
-	 */
-	if (skb_cloned(skb) || skb_is_nonlinear(skb) ||
-	    skb_headroom(skb) < XDP_PACKET_HEADROOM) {
-		int hroom = XDP_PACKET_HEADROOM - skb_headroom(skb);
-		int troom = skb->tail + skb->data_len - skb->end;
-
-		/* In case we have to go down the path and also linearize,
-		 * then lets do the pskb_expand_head() work just once here.
-		 */
-		if (pskb_expand_head(skb,
-				     hroom > 0 ? ALIGN(hroom, NET_SKB_PAD) : 0,
-				     troom > 0 ? troom + 128 : 0, GFP_ATOMIC))
-			goto do_drop;
-		if (skb_linearize(skb))
-			goto do_drop;
-	}
+	u32 act = XDP_DROP;
+	int off, metalen;

 	/* The XDP program wants to see the packet starting at the MAC
 	 * header.
@@ -4810,6 +4783,13 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 		skb->protocol = eth_type_trans(skb, skb->dev);
 	}

+	/* Redirect/Tx gives L2 packet, code that will reuse skb must __skb_pull
+	 * before calling us again on redirect path. We do not call do_redirect
+	 * as we leave that up to the caller.
+	 *
+	 * Caller is responsible for managing lifetime of skb (i.e. calling
+	 * kfree_skb in response to actions it cannot handle/XDP_DROP).
+	 */
 	switch (act) {
 	case XDP_REDIRECT:
 	case XDP_TX:
@@ -4820,6 +4800,49 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 		if (metalen)
 			skb_metadata_set(skb, metalen);
 		break;
+	}
+
+	return act;
+}
+
+static u32 netif_receive_generic_xdp(struct sk_buff *skb,
+				     struct xdp_buff *xdp,
+				     struct bpf_prog *xdp_prog)
+{
+	u32 act = XDP_DROP;
+
+	/* Reinjected packets coming from act_mirred or similar should
+	 * not get XDP generic processing.
+	 */
+	if (skb_is_redirected(skb))
+		return XDP_PASS;
+
+	/* XDP packets must be linear and must have sufficient headroom
+	 * of XDP_PACKET_HEADROOM bytes. This is the guarantee that also
+	 * native XDP provides, thus we need to do it here as well.
+	 */
+	if (skb_cloned(skb) || skb_is_nonlinear(skb) ||
+	    skb_headroom(skb) < XDP_PACKET_HEADROOM) {
+		int hroom = XDP_PACKET_HEADROOM - skb_headroom(skb);
+		int troom = skb->tail + skb->data_len - skb->end;
+
+		/* In case we have to go down the path and also linearize,
+		 * then lets do the pskb_expand_head() work just once here.
+		 */
+		if (pskb_expand_head(skb,
+				     hroom > 0 ? ALIGN(hroom, NET_SKB_PAD) : 0,
+				     troom > 0 ? troom + 128 : 0, GFP_ATOMIC))
+			goto do_drop;
+		if (skb_linearize(skb))
+			goto do_drop;
+	}
+
+	act = bpf_prog_run_generic_xdp(skb, xdp, xdp_prog);
+	switch (act) {
+	case XDP_REDIRECT:
+	case XDP_TX:
+	case XDP_PASS:
+		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
 		fallthrough;
@@ -5285,7 +5308,6 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
 			ret = NET_RX_DROP;
 			goto out;
 		}
-		skb_reset_mac_len(skb);
 	}

 	if (eth_type_vlan(skb->protocol)) {
--
2.31.1

