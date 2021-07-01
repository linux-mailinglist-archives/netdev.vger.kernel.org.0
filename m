Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC6083B8B4E
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 02:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238244AbhGAAcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 20:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238224AbhGAAcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 20:32:41 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF98C061756;
        Wed, 30 Jun 2021 17:30:10 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id t9so4436451pgn.4;
        Wed, 30 Jun 2021 17:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SkgpkHwukme+s+DiUo/QAxq3uuNb0i0Ju9uiWH1fc9E=;
        b=qTYnPkb90Gwe6s1eVuvrmLmrqyjctqLVk/ta1z+WXptREFN1taVF4hgAcWFEKYHNZr
         9m58rW4DyOPBx8xpghN3M75vJzs5lrHysQa2HZhyEf+i3IcMx1n9Alz3qYizNFiDGllr
         W+jPMsgs3qccxiL72n81muAa7LHo+UasIFU3Xts1zqGWMSx+aPKq0+R7S77Ccn8wX74m
         MwJyBQA8rknZdMbBRpBeJX78YhDJxzB4mzJdy2aNFEOwQDN2ZUdChagKRqeJ74k0ixhp
         aeafsxnBLAJVnn4gEaeO+PHLrh3nEH1lC3pjpak5Fkz4f6D14c6pLupbo5coZcBwJZbK
         xoKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SkgpkHwukme+s+DiUo/QAxq3uuNb0i0Ju9uiWH1fc9E=;
        b=UdvaqkIDypuR4hTg2xu2oYTmbGFwGX7zYyfcTYsoYp8BUDxazoqYSsuC/KLFSsGaZD
         Yv6YJeu9rMNFsoI2mr6XcwOZ/RHQCCActDHmMczFrOOE/dOMnt7FRmNbOyFocsWYDiHI
         qM0+gjVetzxQlAk3cmCC2tyd/r4pG63xHE6zRHNCzfq4iYbTV+yoS1kHd99fQChpbti+
         W/abW4dWMOzBj/fZfMH+kfBEcs/rb8ocUuNSofKs4SVRnorbD/pXHe5GJH84wcVaO3uc
         4kc5WfJkDH+OlcFiQ1vGypMXuVwTImfCbLaldTwTyuSlo0BsvMuz/9uPFPEgabtgs7t3
         TIfw==
X-Gm-Message-State: AOAM532xv9PRmMDtHEVRp3Lq71QvLqPQNSZkGXQddj52MCfsQGu2ioXd
        rkrpqMQ4okUr6gsg8p0+AyOsR1wXhuk=
X-Google-Smtp-Source: ABdhPJx1oPfh3CMSQbayS4D1qA8/l8j41gvWPRcV9+uKl/GEIaXnR09ZRYSmwcKQ1n98dEivdTEopQ==
X-Received: by 2002:a63:f10:: with SMTP id e16mr6243928pgl.163.1625099410254;
        Wed, 30 Jun 2021 17:30:10 -0700 (PDT)
Received: from localhost ([2402:3a80:11db:6f6:e6a8:37a6:1da7:fbc7])
        by smtp.gmail.com with ESMTPSA id na7sm7467224pjb.36.2021.06.30.17.30.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 17:30:09 -0700 (PDT)
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
Subject: [PATCH net-next v5 4/5] bpf: devmap: implement devmap prog execution for generic XDP
Date:   Thu,  1 Jul 2021 05:57:58 +0530
Message-Id: <20210701002759.381983-5-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210701002759.381983-1-memxor@gmail.com>
References: <20210701002759.381983-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Since devmap entry prog is supported, remove the check in
generic_xdp_install entirely.

Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/bpf.h |  1 -
 kernel/bpf/devmap.c | 49 ++++++++++++++++++++++++++++++++++++---------
 net/core/dev.c      | 18 -----------------
 3 files changed, 39 insertions(+), 29 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 095aaa104c56..4afbff308ca3 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1508,7 +1508,6 @@ int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
 int dev_map_redirect_multi(struct net_device *dev, struct sk_buff *skb,
 			   struct bpf_prog *xdp_prog, struct bpf_map *map,
 			   bool exclude_ingress);
-bool dev_map_can_have_prog(struct bpf_map *map);
 
 void __cpu_map_flush(void);
 int cpu_map_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_buff *xdp,
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 2a75e6c2d27d..49f03e8e5561 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -318,16 +318,6 @@ static int dev_map_hash_get_next_key(struct bpf_map *map, void *key,
 	return -ENOENT;
 }
 
-bool dev_map_can_have_prog(struct bpf_map *map)
-{
-	if ((map->map_type == BPF_MAP_TYPE_DEVMAP ||
-	     map->map_type == BPF_MAP_TYPE_DEVMAP_HASH) &&
-	    map->value_size != offsetofend(struct bpf_devmap_val, ifindex))
-		return true;
-
-	return false;
-}
-
 static int dev_map_bpf_prog_run(struct bpf_prog *xdp_prog,
 				struct xdp_frame **frames, int n,
 				struct net_device *dev)
@@ -499,6 +489,37 @@ static inline int __xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
 	return 0;
 }
 
+static u32 dev_map_bpf_prog_run_skb(struct sk_buff *skb, struct bpf_dtab_netdev *dst)
+{
+	struct xdp_txq_info txq = { .dev = dst->dev };
+	struct xdp_buff xdp;
+	u32 act;
+
+	if (!dst->xdp_prog)
+		return XDP_PASS;
+
+	__skb_pull(skb, skb->mac_len);
+	xdp.txq = &txq;
+
+	act = bpf_prog_run_generic_xdp(skb, &xdp, dst->xdp_prog);
+	switch (act) {
+	case XDP_PASS:
+		__skb_push(skb, skb->mac_len);
+		break;
+	default:
+		bpf_warn_invalid_xdp_action(act);
+		fallthrough;
+	case XDP_ABORTED:
+		trace_xdp_exception(dst->dev, dst->xdp_prog, act);
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
@@ -614,6 +635,14 @@ int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
 	err = xdp_ok_fwd_dev(dst->dev, skb->len);
 	if (unlikely(err))
 		return err;
+
+	/* Redirect has already succeeded semantically at this point, so we just
+	 * return 0 even if packet is dropped. Helper below takes care of
+	 * freeing skb.
+	 */
+	if (dev_map_bpf_prog_run_skb(skb, dst) != XDP_PASS)
+		return 0;
+
 	skb->dev = dst->dev;
 	generic_xdp_tx(skb, xdp_prog);
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 8521936414f2..c674fe191e8a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5656,24 +5656,6 @@ static int generic_xdp_install(struct net_device *dev, struct netdev_bpf *xdp)
 	struct bpf_prog *new = xdp->prog;
 	int ret = 0;
 
-	if (new) {
-		u32 i;
-
-		mutex_lock(&new->aux->used_maps_mutex);
-
-		/* generic XDP does not work with DEVMAPs that can
-		 * have a bpf_prog installed on an entry
-		 */
-		for (i = 0; i < new->aux->used_map_cnt; i++) {
-			if (dev_map_can_have_prog(new->aux->used_maps[i])) {
-				mutex_unlock(&new->aux->used_maps_mutex);
-				return -EINVAL;
-			}
-		}
-
-		mutex_unlock(&new->aux->used_maps_mutex);
-	}
-
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		rcu_assign_pointer(dev->xdp_prog, new);
-- 
2.31.1

