Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 956C53B0EC1
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 22:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbhFVUdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 16:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbhFVUdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 16:33:13 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 016A6C061574;
        Tue, 22 Jun 2021 13:30:57 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id w71so492676pfd.4;
        Tue, 22 Jun 2021 13:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LtOupg8zZLOGLS8qU72uV1cLOLhIh5uV+DMN2/xgYL4=;
        b=hHsRQnvVHV4DSWMUybuxzvxWkZ5vOYMrjgN0nSDMwgbWBGEED9lcwdT15Pe3KWwhkP
         2cP6Dv1N5eMhZA1S3LWDjW7DJTrYgwrolkBuQF5sq1LsoKbediYcxopObA3CNFY8G5zH
         uX+SueKdK6ZGPYUcO69Kx13uk88vhpD4vHefbTpU5fM8/LN4G9b/n/L4dRwKCHwyFtD7
         VA61U2vBz5mXlErKHbQIPgu6ogOREf0EB46SRp8HSDI4ZOKtE8Mcq4ytZPOtnQgr+axq
         93GY7vFHFq6cBfGQp2Rj4i/i5r5hejqmrymHlmZQvwviVvXBWlRGxDEq2YDDKvpE6a0o
         bBaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LtOupg8zZLOGLS8qU72uV1cLOLhIh5uV+DMN2/xgYL4=;
        b=uFDsZ3Ird3FSBXbYKwBHDcitQrfWKaVUvkMsy5UjcSNg1NKBWrLUk06gJsEa2dlY9E
         35f/r/FPSsrOP86XbxrNPyigbWO4/UWhO/GQfStxow3vFzfGSJQ+ZYrgXPouVVkcHI/l
         fdCfiK21sDRt86KXrkSnVKFzem4sMk5uIIeurhVQKFjUha3E0OG5g4g85dheUnn/d5i7
         3MWPcJrszc1kz9107Kv1PCaGrpVFirlPNdnMTifhpMA1qXnQNTbavN8Hl9iXQId1PfIe
         iW4Y8qxChXwIqGua00osiujJwQF0Mv9xIPEzykuCVqxamlPfEfXxNYB76yAYObs++Utm
         hVqA==
X-Gm-Message-State: AOAM533l6wkgmK2o/g3f5/gdjLA1M43Jlz4cDnAU8XnsGbSBSt8SoTNS
        M+7Ze85hieKZAbNA9IuV74QYr2Oln5U=
X-Google-Smtp-Source: ABdhPJzKEIFLukD/fT2Ehw00xlGN31jrXNzpFj/NtkK2uVEFEjHOgxacx6xpeNkRIaHWukGRdWi5PA==
X-Received: by 2002:a63:ff09:: with SMTP id k9mr423727pgi.113.1624393856386;
        Tue, 22 Jun 2021 13:30:56 -0700 (PDT)
Received: from localhost ([2402:3a80:11bb:33b3:7f0c:3646:8bde:417e])
        by smtp.gmail.com with ESMTPSA id z204sm189082pfc.84.2021.06.22.13.30.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 13:30:56 -0700 (PDT)
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
Subject: [PATCH net-next v3 1/5] net: core: split out code to run generic XDP prog
Date:   Wed, 23 Jun 2021 01:58:31 +0530
Message-Id: <20210622202835.1151230-2-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210622202835.1151230-1-memxor@gmail.com>
References: <20210622202835.1151230-1-memxor@gmail.com>
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
index 50531a2d0b20..c34ff1dbf6e6 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4717,45 +4717,18 @@ static struct netdev_rx_queue *netif_get_rxqueue(struct sk_buff *skb)
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

