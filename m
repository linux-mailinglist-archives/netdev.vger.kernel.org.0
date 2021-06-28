Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 056723B5D5E
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 13:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbhF1Lw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 07:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232908AbhF1LwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 07:52:21 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC9DC061768;
        Mon, 28 Jun 2021 04:49:55 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id y4so13857526pfi.9;
        Mon, 28 Jun 2021 04:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SkgpkHwukme+s+DiUo/QAxq3uuNb0i0Ju9uiWH1fc9E=;
        b=cmXwWu2XC1BYxEwjkOytA2LqZr71VWPh8d7VeL14WJpA4NaFQOiFO4Ebp8BLfSUjmW
         UCz3YgWbAmsJ9xyKeIxKWWf0oZtjTdiUsqDp0LgN9Ri3pVUiIKogOvoB5sMZYn7O4q7w
         fct1hBedEPDcFn9vRSEEm/bg0R/t2Y/X1KBUeCA2K//a6YwKf02iwH3KWjYfftBxMMQr
         QAl+OGoNliVs6logYvQRCPPY3sO3weLJnwRpB2vK6JFRceWzPcUhL+ig2PZO53SJZ2Cr
         7BJtZ4n+yJCEUzluqMeYzZH0s9wch1StiQ3T7nqGjh3Iz6OaM858Ots1aAIHk4R7YbBd
         wcCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SkgpkHwukme+s+DiUo/QAxq3uuNb0i0Ju9uiWH1fc9E=;
        b=kQUGMC+uRcjDH7mm5T2WgT2QrLKaKji8RdTOECspsxX6AgPir+6Fz6OLxjybh1tUWJ
         aFTCdUDXQdKu2+77x4QCMUrn85OFrYKXjsBuPvWETqnBLdi3f4B8+dVCyYaqM9dbqSfX
         +zMzt5UAoxi3MrqxMDSvFq4PP//h3XynpOVjeozKwCoWV34UoksJB4rgirPDXnwotSdE
         sM8Podg9U2RquJhy5//X7obPz6+v7PkLYJbFNBD2z5d1sCRYBj2tYYZox5pCyLEBv8Hc
         +rInLNybItimqo72tcinB2JpewIZjVFg0hxwSw2gtzyzPDCyhMOgjlw9enms9YELH4Zx
         /R7w==
X-Gm-Message-State: AOAM532bzWuE2p7XUWCra8+HgHCUJ+6u0unAOAg+SLZpsGOwvzl57X5O
        Za/537h9h3Hamms6a6278YrN+EDcTBY=
X-Google-Smtp-Source: ABdhPJzhKJ7aqGSJYfV+veBGXNN73QnIRENWvMglbdF+XjpOzYmVAddcNbHF88vsdRi3p2y+d2/Scw==
X-Received: by 2002:a62:14d4:0:b029:307:1c6a:ae7d with SMTP id 203-20020a6214d40000b02903071c6aae7dmr24310886pfu.78.1624880995301;
        Mon, 28 Jun 2021 04:49:55 -0700 (PDT)
Received: from localhost ([2402:3a80:11da:c590:f80e:952e:84ac:ba3d])
        by smtp.gmail.com with ESMTPSA id y5sm11133279pjy.2.2021.06.28.04.49.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 04:49:55 -0700 (PDT)
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
Subject: [PATCH net-next v4 4/5] bpf: devmap: implement devmap prog execution for generic XDP
Date:   Mon, 28 Jun 2021 17:17:45 +0530
Message-Id: <20210628114746.129669-5-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210628114746.129669-1-memxor@gmail.com>
References: <20210628114746.129669-1-memxor@gmail.com>
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

