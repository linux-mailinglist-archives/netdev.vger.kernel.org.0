Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9183B9FB0
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 13:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231816AbhGBLW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 07:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbhGBLW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 07:22:56 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9AF7C061762;
        Fri,  2 Jul 2021 04:20:23 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id e33so9236477pgm.3;
        Fri, 02 Jul 2021 04:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Pu6s/bZWRTuBtOPeO5jualkpubf/IINLtS9eFBKRQso=;
        b=l3DMROhBejaWiPdmTwkCprGmi0YvK+RFa9OYaKraCBuJCG9YkhEuY/ZMXihq+BG0QV
         GkzWGhg0ywqBoS8Q5M/GUOncX0qJtRivGiIqJ3QelCa+OVplrtK8POq2f33qeiD6H3vn
         du84c9DB/j6JOn2TWty1obMfenmdWptfu1xhu0fevQZrfFtpqPOlwrxldaNRBHw5+APr
         6OzwT0oSFUhds2WdWkBiMv3xKq/vgwNGK7xBuVn8xMwhbFxo8fe2hw9HZrmpaVU6G0vu
         w3xRPwZuCGtZUCz52E1ToYo17BGKG/ycirKmAxspvkwbhuW1lrnGyIv8tNZ0kFeU+gDd
         Lfjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pu6s/bZWRTuBtOPeO5jualkpubf/IINLtS9eFBKRQso=;
        b=Tv/gVbeFhH1H03HI6lMlyAiovDVs0IZokeQESOK7lvNM1NWnN0LxITmnNiNmGZfHBT
         hiybg2rZrM9XBwtYADNPh2+T+NAB+zqL7Ut6vKX2bR8wy5u3HmimXtEfpsTr6jLil1Rb
         eqM8mCFhwplR78vqZuwDFhcFqFmkS5NR+yZzkXbY3fL10awZuiD6GxlWrKKUr9ThMPAL
         aHi3/TD6RtEKNJkzXLt+15GV7moDseU53XdWhTZ3NnofKpuCeByfhvUzkB4rzQI5I3dA
         59hxKB8v2AE1Q3GPy02Cd5qrVBwj6qbVJeMk5rewJ9JZDvzlQkLi2x9eRKCMKpQH73G3
         D4GA==
X-Gm-Message-State: AOAM531Snzpy0iIN5BBiGfc2gWctJ409LVBUByS9qya4n6LjLl5bHiCS
        U3IcsDALypmVkAEuhCPoVL6M9/ax0Bg=
X-Google-Smtp-Source: ABdhPJyiJev5O+4QxZ88EgSuUy7G0OA5F1gH/tcqu4eBQCUZGBxBk2nsFLBBCP9ldc4fCPQwTsncxQ==
X-Received: by 2002:a63:1443:: with SMTP id 3mr1514771pgu.7.1625224823148;
        Fri, 02 Jul 2021 04:20:23 -0700 (PDT)
Received: from localhost ([2409:4063:4d83:c0b5:70cd:e919:ab0c:33ce])
        by smtp.gmail.com with ESMTPSA id 27sm3442869pgr.31.2021.07.02.04.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jul 2021 04:20:22 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Leblond <eric@regit.org>, bpf@vger.kernel.org
Subject: [PATCH net-next v6 1/5] net: core: split out code to run generic XDP prog
Date:   Fri,  2 Jul 2021 16:48:21 +0530
Message-Id: <20210702111825.491065-2-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210702111825.491065-1-memxor@gmail.com>
References: <20210702111825.491065-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/netdevice.h |  2 +
 net/core/dev.c            | 84 ++++++++++++++++++++++++---------------
 2 files changed, 55 insertions(+), 31 deletions(-)

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
index 991d09b67bd9..ad5ab33cbd39 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4740,45 +4740,18 @@ static struct netdev_rx_queue *netif_get_rxqueue(struct sk_buff *skb)
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
+	u32 metalen, act;
 	int off;
 
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
-
 	/* The XDP program wants to see the packet starting at the MAC
 	 * header.
 	 */
@@ -4833,6 +4806,13 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
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
@@ -4843,6 +4823,49 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
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
@@ -5308,7 +5331,6 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
 			ret = NET_RX_DROP;
 			goto out;
 		}
-		skb_reset_mac_len(skb);
 	}
 
 	if (eth_type_vlan(skb->protocol)) {
-- 
2.31.1

