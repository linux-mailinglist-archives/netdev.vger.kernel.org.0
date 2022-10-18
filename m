Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 050B86027D4
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 11:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbiJRJCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 05:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbiJRJCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 05:02:37 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DFE2AA343
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 02:02:22 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d24so13215810pls.4
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 02:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GiF+HvtpV0USerhEY/2y6Nyo31ujO6NW/Gqobixjk20=;
        b=M898cJ+N8aqZbu8uG2BsQJHR954CJUcWg+vBzQiHzYXOxK8WbG+ffByNekaCFvB624
         mWx1t7cuv8EFoU1UrQW24Le+nk9Br0disJfftNCjAknvjKe0Zb8OJRbuRsBF0nm/ZaUz
         upsO5mTFRxvi72EEEeEO3JEO8Q0cX//ZZTSss=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GiF+HvtpV0USerhEY/2y6Nyo31ujO6NW/Gqobixjk20=;
        b=F5Ppi5FypCz9JZuXzVFmF++XuY8vqH40bEZIy4Symg8Cq+vvesgEe/x+jX3/RnaP/O
         SUl9wIp0qpipc0k47WDn4gxF3oDYTl7yQcTzy27RrrtuBVliMbbNEhaq+Z02fxMbWuG3
         VJ5Kv9CBR603bXmOQXNL5hvBOwcmxxbcFm31s3YLdTY6KGfOgGpQuZNI7dd6N7Z8vaVh
         B6Q/t4ykfutmEeojg+wwtv4pP88a4acLrUCgY9CbCic0PN5kL3nsNXaAJSiQIA+8byMx
         ddv2/VRZyQ3N1UvrhY2IwNiKvk0etl1gLU9rqNue10j3fOtUA36i2Vy020xWzJLGBfkG
         dl8g==
X-Gm-Message-State: ACrzQf1v0fkNOiw/jTstJNvDfrgOu6C5ZKaGePTDOFI0m1KtKlIrl8tJ
        3W3oR7+6s9tp/ZFD+eUJXAaXug==
X-Google-Smtp-Source: AMsMyM58liADUU50Ea2Gd+JZXS22BGSdjKX9AcDXIBSVzKkmnwiaund/40rnqLs4OzHfC9QIqN5x4w==
X-Received: by 2002:a17:902:db0b:b0:185:51cc:8113 with SMTP id m11-20020a170902db0b00b0018551cc8113mr1928957plx.64.1666083739303;
        Tue, 18 Oct 2022 02:02:19 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id x184-20020a6286c1000000b005622f99579esm8696464pfd.160.2022.10.18.02.02.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 02:02:18 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] bpf, test_run: Track allocation size of data
Date:   Tue, 18 Oct 2022 02:02:13 -0700
Message-Id: <20221018090205.never.090-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7305; h=from:subject:message-id; bh=DTRHDHBZPBBZwilPaMBacwv+Bvqcp0DeH6UmRbkd/rA=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjTmuV3TRMBUqW+B5RZpQe+7x8o5DbQTFlvjEuhea6 N/Q66bWJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCY05rlQAKCRCJcvTf3G3AJryAD/ 9VuAxCR5ybPIFdZwqttcTUU2fXGAh/Q2UqKV8K3lpm+kxJzdwfdDDpP5cn1AzZbG2v2XO5lVhpE+3N IaQbMsgYVBLcN1jc/srI2Xds34gJLg9RiaunIAykXIgraGrFjm3hfi4TKd9rh5svNwujf8OeR9Vsmw Utz031nC+3oClgpT8gkXjEAKUnenXbcEBV8SfOop+kHlD1pHwVKi6TvIkmWByP6Mk+azKBxpOOpvEk xzF0Jr/j2Qmyd0GA1KOIVF1v9uzVkRZ8DEBFNorRI0SV2aAcsIk8GizozXCJjKy457QqlayCLRSvai oBZJ2VUuvpY3iCzzXVDP4AgPFe4DjPHVuJAmUEselZFr9I10PPEHWYo/hoPzUysdtZ0LUKqofqjTla WyEG0NRhK2Xq3lTpt2YRp5nxhfuUmzBh8KjUuy2Y76Y9Vz6+qlf49BNdqafVr4RS38NAF+BDWsUB03 AURuD6iS9mUDR8KgKXoJrawEDRE/1JHREuxstdPAP0LgPyvi/LoWsfM70QQM+loqIjkdSeZcoX+ikc klRo27hKGywmQ7Ya4dKWcGKUvcI72rgKtz5G/FXhLa9XO8awqQiU+JX9usUTHGgKQO8QXE4ZY2Med/ vp/U+pm4XHGumrQmuZUahIAkW9lXti/xE5RZ2eiGr0J84evyXdkFmtD6/g6Q==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for requiring that build_skb() have a non-zero size
argument, track the data allocation size explicitly and pass it into
build_skb(). To retain the original result of using the ksize()
side-effect on the skb size, explicitly round up the size during
allocation.

Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Song Liu <song@kernel.org>
Cc: Yonghong Song <yhs@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Stanislav Fomichev <sdf@google.com>
Cc: Hao Luo <haoluo@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>
Cc: bpf@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/bpf/test_run.c | 84 +++++++++++++++++++++++++---------------------
 1 file changed, 46 insertions(+), 38 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 13d578ce2a09..299ff102f516 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -762,28 +762,38 @@ BTF_ID_FLAGS(func, bpf_kfunc_call_test_ref, KF_TRUSTED_ARGS)
 BTF_ID_FLAGS(func, bpf_kfunc_call_test_destructive, KF_DESTRUCTIVE)
 BTF_SET8_END(test_sk_check_kfunc_ids)
 
-static void *bpf_test_init(const union bpf_attr *kattr, u32 user_size,
-			   u32 size, u32 headroom, u32 tailroom)
+struct bpfalloc {
+	size_t len;
+	void  *data;
+};
+
+static int bpf_test_init(struct bpfalloc *alloc,
+			 const union bpf_attr *kattr, u32 user_size,
+			 u32 size, u32 headroom, u32 tailroom)
 {
 	void __user *data_in = u64_to_user_ptr(kattr->test.data_in);
-	void *data;
 
 	if (size < ETH_HLEN || size > PAGE_SIZE - headroom - tailroom)
-		return ERR_PTR(-EINVAL);
+		return -EINVAL;
 
 	if (user_size > size)
-		return ERR_PTR(-EMSGSIZE);
+		return -EMSGSIZE;
 
-	data = kzalloc(size + headroom + tailroom, GFP_USER);
-	if (!data)
-		return ERR_PTR(-ENOMEM);
+	alloc->len = kmalloc_size_roundup(size + headroom + tailroom);
+	alloc->data = kzalloc(alloc->len, GFP_USER);
+	if (!alloc->data) {
+		alloc->len = 0;
+		return -ENOMEM;
+	}
 
-	if (copy_from_user(data + headroom, data_in, user_size)) {
-		kfree(data);
-		return ERR_PTR(-EFAULT);
+	if (copy_from_user(alloc->data + headroom, data_in, user_size)) {
+		kfree(alloc->data);
+		alloc->data = NULL;
+		alloc->len = 0;
+		return -EFAULT;
 	}
 
-	return data;
+	return 0;
 }
 
 int bpf_prog_test_run_tracing(struct bpf_prog *prog,
@@ -1086,25 +1096,25 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 	u32 size = kattr->test.data_size_in;
 	u32 repeat = kattr->test.repeat;
 	struct __sk_buff *ctx = NULL;
+	struct bpfalloc alloc = { };
 	u32 retval, duration;
 	int hh_len = ETH_HLEN;
 	struct sk_buff *skb;
 	struct sock *sk;
-	void *data;
 	int ret;
 
 	if (kattr->test.flags || kattr->test.cpu || kattr->test.batch_size)
 		return -EINVAL;
 
-	data = bpf_test_init(kattr, kattr->test.data_size_in,
-			     size, NET_SKB_PAD + NET_IP_ALIGN,
-			     SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));
-	if (IS_ERR(data))
-		return PTR_ERR(data);
+	ret = bpf_test_init(&alloc, kattr, kattr->test.data_size_in,
+			    size, NET_SKB_PAD + NET_IP_ALIGN,
+			    SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));
+	if (ret)
+		return ret;
 
 	ctx = bpf_ctx_init(kattr, sizeof(struct __sk_buff));
 	if (IS_ERR(ctx)) {
-		kfree(data);
+		kfree(alloc.data);
 		return PTR_ERR(ctx);
 	}
 
@@ -1124,15 +1134,15 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 
 	sk = sk_alloc(net, AF_UNSPEC, GFP_USER, &bpf_dummy_proto, 1);
 	if (!sk) {
-		kfree(data);
+		kfree(alloc.data);
 		kfree(ctx);
 		return -ENOMEM;
 	}
 	sock_init_data(NULL, sk);
 
-	skb = build_skb(data, 0);
+	skb = build_skb(alloc.data, alloc.len);
 	if (!skb) {
-		kfree(data);
+		kfree(alloc.data);
 		kfree(ctx);
 		sk_free(sk);
 		return -ENOMEM;
@@ -1283,10 +1293,10 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 	u32 repeat = kattr->test.repeat;
 	struct netdev_rx_queue *rxqueue;
 	struct skb_shared_info *sinfo;
+	struct bpfalloc alloc = {};
 	struct xdp_buff xdp = {};
 	int i, ret = -EINVAL;
 	struct xdp_md *ctx;
-	void *data;
 
 	if (prog->expected_attach_type == BPF_XDP_DEVMAP ||
 	    prog->expected_attach_type == BPF_XDP_CPUMAP)
@@ -1329,16 +1339,14 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 		size = max_data_sz;
 	}
 
-	data = bpf_test_init(kattr, size, max_data_sz, headroom, tailroom);
-	if (IS_ERR(data)) {
-		ret = PTR_ERR(data);
+	ret = bpf_test_init(&alloc, kattr, size, max_data_sz, headroom, tailroom);
+	if (ret)
 		goto free_ctx;
-	}
 
 	rxqueue = __netif_get_rx_queue(current->nsproxy->net_ns->loopback_dev, 0);
 	rxqueue->xdp_rxq.frag_size = headroom + max_data_sz + tailroom;
 	xdp_init_buff(&xdp, rxqueue->xdp_rxq.frag_size, &rxqueue->xdp_rxq);
-	xdp_prepare_buff(&xdp, data, headroom, size, true);
+	xdp_prepare_buff(&xdp, alloc.data, headroom, size, true);
 	sinfo = xdp_get_shared_info_from_buff(&xdp);
 
 	ret = xdp_convert_md_to_buff(ctx, &xdp);
@@ -1410,7 +1418,7 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 free_data:
 	for (i = 0; i < sinfo->nr_frags; i++)
 		__free_page(skb_frag_page(&sinfo->frags[i]));
-	kfree(data);
+	kfree(alloc.data);
 free_ctx:
 	kfree(ctx);
 	return ret;
@@ -1441,10 +1449,10 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
 	u32 repeat = kattr->test.repeat;
 	struct bpf_flow_keys *user_ctx;
 	struct bpf_flow_keys flow_keys;
+	struct bpfalloc alloc = {};
 	const struct ethhdr *eth;
 	unsigned int flags = 0;
 	u32 retval, duration;
-	void *data;
 	int ret;
 
 	if (kattr->test.flags || kattr->test.cpu || kattr->test.batch_size)
@@ -1453,18 +1461,18 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
 	if (size < ETH_HLEN)
 		return -EINVAL;
 
-	data = bpf_test_init(kattr, kattr->test.data_size_in, size, 0, 0);
-	if (IS_ERR(data))
-		return PTR_ERR(data);
+	ret = bpf_test_init(&alloc, kattr, kattr->test.data_size_in, size, 0, 0);
+	if (ret)
+		return ret;
 
-	eth = (struct ethhdr *)data;
+	eth = (struct ethhdr *)alloc.data;
 
 	if (!repeat)
 		repeat = 1;
 
 	user_ctx = bpf_ctx_init(kattr, sizeof(struct bpf_flow_keys));
 	if (IS_ERR(user_ctx)) {
-		kfree(data);
+		kfree(alloc.data);
 		return PTR_ERR(user_ctx);
 	}
 	if (user_ctx) {
@@ -1475,8 +1483,8 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
 	}
 
 	ctx.flow_keys = &flow_keys;
-	ctx.data = data;
-	ctx.data_end = (__u8 *)data + size;
+	ctx.data = alloc.data;
+	ctx.data_end = (__u8 *)alloc.data + size;
 
 	bpf_test_timer_enter(&t);
 	do {
@@ -1496,7 +1504,7 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
 
 out:
 	kfree(user_ctx);
-	kfree(data);
+	kfree(alloc.data);
 	return ret;
 }
 
-- 
2.34.1

