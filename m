Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9A9A3AE122
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 01:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbhFTXf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 19:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbhFTXf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Jun 2021 19:35:57 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13188C061574;
        Sun, 20 Jun 2021 16:33:43 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id n12so3920869pgs.13;
        Sun, 20 Jun 2021 16:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZLWHESphb2ClX8iTasuyW7OwHgB916MzRAi3wFsX2qs=;
        b=qqekEJnsY+xVZAo8+5z2rquIbD8OBpXGDW+z3RyLcPaQQc7VCoWweCC5rsObVOQ4qP
         I4KE4JvOK+n/Z74Br8e81Ldgk0sF2AWXPwvrnf0f9s7TC22Rs6q/fHvLXDJJJR9YOrpA
         QzpVM9FiD+DBeyb5QG4myB8DfRTrk+tKYWgxO98umIPaqgc2LQPL6xv+HxR+b8oHh6/1
         xaVmfYRQbCDcmEvRL0yOmW2F1IlV0jZaHYNCUPc0cWEVaHzfXLvov+wMcS8hJLPIlRp4
         t/TYMEMyvzxV38fjMVjTTYxRno1uji8hbFPAWBYVseAgElHFpIuqGoqRI8JapIUHlY2x
         8pnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZLWHESphb2ClX8iTasuyW7OwHgB916MzRAi3wFsX2qs=;
        b=Ea+4wK6j7kzYi2ZrHKruHgqe2DmOSjM5Of02j5XF7fEbFV+sOgKjItt8vKUYzzkhQd
         dJjjpUV+L7gyFyuWPmp5IFO+gSrKDCR03/mXY53g/VeZdJgKpoXa5Tb5m//ZGksy8OPr
         7BGqIrxafAqD7EyHESI7Ju8Al8EbCVwpz+MId+wDtuB2K/0G85lEBSApgJtQKr5yG0mC
         /mxt2jl2p2ghKO1U0nxt1Jinz0FObEqgUHOKS9Vmqy7IPKuXzo3xGxioZLWkPlncuUBH
         bCB7nF5fh4YjsAamPMnbrDQVSmy+4Q2QXrPlY7108NAHTm7/mysSq6XpJ6xqrrerPtEd
         2TrA==
X-Gm-Message-State: AOAM530Ax2bKV5vqFE+vz+CvFviykLFRa5NrzxBfDpHIkqG6zH9Y84Tn
        5kUEP/zI1HIME1I6WkuxI+7JTxozoMg=
X-Google-Smtp-Source: ABdhPJwd2Q2EMInwhOcgwzVuPFLdlOXxUd7hNXuSaJ+GP8SRgedGzVc5lNbL5eZritZbLp9Lom5F1A==
X-Received: by 2002:a63:b54:: with SMTP id a20mr21259878pgl.407.1624232022489;
        Sun, 20 Jun 2021 16:33:42 -0700 (PDT)
Received: from localhost ([2409:4063:4d19:cf2b:5167:bcec:f927:8a69])
        by smtp.gmail.com with ESMTPSA id v129sm4208933pfc.71.2021.06.20.16.33.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Jun 2021 16:33:42 -0700 (PDT)
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
Subject: [PATCH net-next 3/4] bpf: devmap: implement devmap prog execution for generic XDP
Date:   Mon, 21 Jun 2021 05:01:59 +0530
Message-Id: <20210620233200.855534-4-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210620233200.855534-1-memxor@gmail.com>
References: <20210620233200.855534-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This lifts the restriction on running devmap BPF progs in generic
redirect mode. To match native XDP behavior, it is invoked right before
generic_xdp_tx is called, and only supports XDP_PASS/XDP_ABORTED/
XDP_DROP actions.

We also return 0 even if devmap program drops the packet, as
semantically redirect has already succeeded and the devmap prog is the
last point before TX of the packet to device where it can deliver a
verdict on the packet.

This also means it must take care of freeing the skb, as
xdp_do_generic_redirect callers only do that in case an error is
returned.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 kernel/bpf/devmap.c | 42 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 2a75e6c2d27d..db3ed8b20c8c 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -322,7 +322,8 @@ bool dev_map_can_have_prog(struct bpf_map *map)
 {
 	if ((map->map_type == BPF_MAP_TYPE_DEVMAP ||
 	     map->map_type == BPF_MAP_TYPE_DEVMAP_HASH) &&
-	    map->value_size != offsetofend(struct bpf_devmap_val, ifindex))
+	    map->value_size != offsetofend(struct bpf_devmap_val, ifindex) &&
+	    map->value_size != offsetofend(struct bpf_devmap_val, bpf_prog.fd))
 		return true;
 
 	return false;
@@ -499,6 +500,37 @@ static inline int __xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
 	return 0;
 }
 
+static u32 dev_map_bpf_prog_run_skb(struct sk_buff *skb, struct bpf_prog *xdp_prog)
+{
+	struct xdp_txq_info txq = { .dev = skb->dev };
+	struct xdp_buff xdp;
+	u32 act;
+
+	if (!xdp_prog)
+		return XDP_PASS;
+
+	__skb_pull(skb, skb->mac_len);
+	xdp.txq = &txq;
+
+	act = bpf_prog_run_generic_xdp(skb, &xdp, xdp_prog);
+	switch (act) {
+	case XDP_PASS:
+		__skb_push(skb, skb->mac_len);
+		break;
+	default:
+		bpf_warn_invalid_xdp_action(act);
+		fallthrough;
+	case XDP_ABORTED:
+		trace_xdp_exception(skb->dev, xdp_prog, act);
+		fallthrough;
+	case XDP_DROP:
+		kfree_skb(skb);
+		break;
+	}
+
+	return act;
+}
+
 int dev_xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
 		    struct net_device *dev_rx)
 {
@@ -615,6 +647,14 @@ int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
 	if (unlikely(err))
 		return err;
 	skb->dev = dst->dev;
+
+	/* Redirect has already succeeded semantically at this point, so we just
+	 * return 0 even if packet is dropped. Helper below takes care of
+	 * freeing skb.
+	 */
+	if (dev_map_bpf_prog_run_skb(skb, dst->xdp_prog) != XDP_PASS)
+		return 0;
+
 	generic_xdp_tx(skb, xdp_prog);
 
 	return 0;
-- 
2.31.1

