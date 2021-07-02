Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 037493B9FB8
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 13:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbhGBLXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 07:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbhGBLXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 07:23:08 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3162CC061762;
        Fri,  2 Jul 2021 04:20:36 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id y17so9198988pgf.12;
        Fri, 02 Jul 2021 04:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SkgpkHwukme+s+DiUo/QAxq3uuNb0i0Ju9uiWH1fc9E=;
        b=Wds0tv0VpjnRTGGDTF3gD6Qe8Sqs5n4XKQwCEvkVu3ogw8JmGaZiP4gOrcAgwy4h7t
         we3ZD6psZ/3t7oEobmei8f2V9VNkjlJcPkj5/mP5T32RDq5qIqZn7XeDIo7nyIT70LUc
         uSTNgaQUaXt7gXSn7nLjqvB9LiKzWfJ2KOY78TUrF8SPdHyYNorpTBHVpvHGRJyasHpq
         QzYviUhtt+TIKQerxnAzD+uwBpTeiAkDBpOIoMk8rjVThvgJaQca+mgHbZOQUzIRu21N
         dsGwpDQb+DDMkiGiEyznG+MYDwXLQ80edQ/M1GaUuFkgsLtxgpcAbszHLnKRQtukB+75
         j9Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SkgpkHwukme+s+DiUo/QAxq3uuNb0i0Ju9uiWH1fc9E=;
        b=raSrFpkSur9X2N6AtE02xPs3dabbJaZsiBJgcX5wfOmwSrquLFYy4Fc5P1D2r5ef9z
         jLR6LPgiZjN2sm3RM8yIYQL+Zd+R2twfUKGzBj51LNto3CnPPa7PP/FjWuL5a6samO2R
         4G0995YiyIIfSX1j531rccf3d9E3nEt6dSu1MohIcE+hggwQFPv2PAukEM4NHEVxPwdF
         n/Y+B8gmDC/xlfWNDyGQVM7H8IT5FdHqoz6ij9CTRXKpS9rIgkcL0T5fXbD1oVHZoukv
         AIEuhfYogP4cJOdYs4n9EIksV+Jt/exeI884FYb4DaSatTcvFHyIFXGmd10iwmFlHxv4
         fULQ==
X-Gm-Message-State: AOAM530jPvPjbqeA7NjK1UF9qnI3IQYITe+gzqwIzZQa6co53TKLwYSl
        pX6QGYBtx7CplX3lJ4szbmYYMeXsQ4U=
X-Google-Smtp-Source: ABdhPJxDFnGzoF0D9sB2S57EN99jsYRcVtYytNB8t1zsrtBgZ2Hwno4DX5XO5fGmmX965M1iI9QJaA==
X-Received: by 2002:a63:4b09:: with SMTP id y9mr1256322pga.350.1625224835607;
        Fri, 02 Jul 2021 04:20:35 -0700 (PDT)
Received: from localhost ([2409:4063:4d83:c0b5:70cd:e919:ab0c:33ce])
        by smtp.gmail.com with ESMTPSA id i1sm10592588pjs.31.2021.07.02.04.20.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jul 2021 04:20:35 -0700 (PDT)
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
Subject: [PATCH net-next v6 4/5] bpf: devmap: implement devmap prog execution for generic XDP
Date:   Fri,  2 Jul 2021 16:48:24 +0530
Message-Id: <20210702111825.491065-5-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210702111825.491065-1-memxor@gmail.com>
References: <20210702111825.491065-1-memxor@gmail.com>
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

