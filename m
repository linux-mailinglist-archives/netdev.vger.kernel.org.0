Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9CD3B5D57
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 13:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232875AbhF1LwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 07:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbhF1LwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 07:52:10 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E2FC061574;
        Mon, 28 Jun 2021 04:49:44 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id g6-20020a17090adac6b029015d1a9a6f1aso10509921pjx.1;
        Mon, 28 Jun 2021 04:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Pu6s/bZWRTuBtOPeO5jualkpubf/IINLtS9eFBKRQso=;
        b=FKX4bOUvX/qdEUIm3o5V52baO75jv5s9fHDcgHONCsvNRSbSpB4yYmJkLVFZTnPjuP
         6HaCvuUQvxR3jZA/MDbLGMO7bowbIaPnO63wHyT4eRR9eov9KFWGbTVhaPu5LlbNTTu0
         hXCJVReHZXm/2MwQBgxBFw2KrmUz7E8r7G4vSKjVTwQ8vL+LS7L0tNB5BABwP+9QppbE
         9PlfNl0MCA6wEpIV869pKEIPT03Q7vuflD1sY6+/YMPT70B4ZQ3IRFmauwTgUTQWuH3B
         FN9Lw7sUj9B25BY5U/s1PrT9shnU2kwFYpoHmuFw4mQx8JnHFIH6HPPjeO6A+2yBxn/i
         JBIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pu6s/bZWRTuBtOPeO5jualkpubf/IINLtS9eFBKRQso=;
        b=EsKs0solu5vSFj6RKgysUq5LE++TTNpNeNl03Nqzj5uecqpJwe80TJG6Dfxq7j0nsg
         FdpfSGZW6zU58MYPmCo+DbJ5El586AaDsF8IWiO+srIYH8C67VwU8I67BXv1Holz+CRa
         bIdkp9qvdi9x4nqC8UIF+GCCmWbdiSFPMnYPfxWZso0O9qLf7SdPX4cjqwM3wolIg0pQ
         ELFAw4GklVDBeMiDBDzt4+jFxOhcMWHTzE2luLk8KHNo9HUMXHinXoODNB6pKdB9/KP6
         UKvmn7Uw9hP2wMIxul29DRHQJg3qJvogZ4Gto56XYNqMHeP/OZoRinTCGDw+G0jdMNTj
         9mxg==
X-Gm-Message-State: AOAM533R4nr7Go6MBdidwgMdE++fPwFZh1HPEdUYjMj9jR+F1IL8Sotl
        6g0GzGJGZSIfjuahtXTfRal3kcHeyn0=
X-Google-Smtp-Source: ABdhPJzvhdCVGKbz7qGahTgfRkBWaFQ0s0w8N+oGooO8Q0Eot76XZirF7tdc67dQsAIpgmSgIdMngg==
X-Received: by 2002:a17:90b:33c4:: with SMTP id lk4mr37735198pjb.191.1624880984017;
        Mon, 28 Jun 2021 04:49:44 -0700 (PDT)
Received: from localhost ([2402:3a80:11da:c590:f80e:952e:84ac:ba3d])
        by smtp.gmail.com with ESMTPSA id 7sm14734686pfu.24.2021.06.28.04.49.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 04:49:43 -0700 (PDT)
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
        Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Subject: [PATCH net-next v4 1/5] net: core: split out code to run generic XDP prog
Date:   Mon, 28 Jun 2021 17:17:42 +0530
Message-Id: <20210628114746.129669-2-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210628114746.129669-1-memxor@gmail.com>
References: <20210628114746.129669-1-memxor@gmail.com>
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

