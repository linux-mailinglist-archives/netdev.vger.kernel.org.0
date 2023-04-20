Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 287A36E97A6
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 16:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232742AbjDTOvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 10:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbjDTOvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 10:51:14 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D2EE658B;
        Thu, 20 Apr 2023 07:51:09 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id ay3-20020a05600c1e0300b003f17289710aso1253580wmb.5;
        Thu, 20 Apr 2023 07:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682002268; x=1684594268;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x+CJkctN2B5FsSgvEbq8lrocG4HR+Tm3KsA/CYziZ4Q=;
        b=KDQBVGWd/pbAAIlG8oKpHQYDXvwJ2mSsScsa/WxRH7GpreI72U8bmYhiir4vA/M/GT
         5YT1wsc0hZuLlrmxw0Csgwor5RPsdGleWC9kMvbjLlG0ydwEJfyCm1TzsN6G7Ak5X4S1
         9FQJubcbsTZjqai1mFeoINCVlBpC+DMW3kW6vZYJmK2B61QVk11Cefx+SmtJDe8COsQA
         BWwDVK99o20ZEIyUDVrL+pXBjg/Qty7Ywp7ogKVWlYG/CqWf33euVK5Ju8FC2Nl1NGJb
         cp/hBU68V/8R0rY9yu584BKPDayp7nCGe2NoOiNiPFsAmTqRpS/daylTyCk7wHKzJ4fh
         TmZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682002268; x=1684594268;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x+CJkctN2B5FsSgvEbq8lrocG4HR+Tm3KsA/CYziZ4Q=;
        b=LsIqDvoCOgLuxc4r+IqfkkzXtuaEOuWBo/1qy9hMn9CwA5fN761VABg659erNw8YEc
         6TkU56XVeisp8Xqqm8Gzqj9Q34/7xHxt6WUjkZQTVFAO5ZUmmkhVWwVPmeZ3KTQ3HT8U
         b0ruGSgdU4GvV0neE9wC+VeySc22/+zl+VIePFjZrWJNYbkdCjOdCoqnP7E+eNIEfc51
         DOqVS6CQr9hBPy382spkHhHobnfiEgLMUo0gnJLhZb5E9kAXhhUnIb28GHgsSwP1mpSW
         6d8gqmp6vZA2nPb4UhxY/o2UQmbiWIBp3fCftiPAw56ie+FqkvZhzWLIQx4zwejmMKeb
         0BIg==
X-Gm-Message-State: AAQBX9fkmGDOayWCHL68NPgYR/B7LWpYz6IsraMbeMoeKIxabJ2TeGV3
        SQs1FY86FrBmyZv4wR6Mlqg=
X-Google-Smtp-Source: AKy350bN6KqubrZDkboMfpLSdIEr9Io5z8lCZnXyRpIT+H4NGDz2Ab+L6OoPfTzDgwmUDp4J5FUMNQ==
X-Received: by 2002:a05:600c:215:b0:3ef:6819:b2ad with SMTP id 21-20020a05600c021500b003ef6819b2admr1475788wmi.37.1682002268439;
        Thu, 20 Apr 2023 07:51:08 -0700 (PDT)
Received: from gsever-Latitude-7400.corp.proofpoint.com ([46.120.112.185])
        by smtp.gmail.com with ESMTPSA id n20-20020a7bc5d4000000b003f17b96793dsm5534619wmk.37.2023.04.20.07.51.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 07:51:07 -0700 (PDT)
From:   Gilad Sever <gilad9366@gmail.com>
To:     dsahern@kernel.org, martin.lau@linux.dev, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        mykolal@fb.com, shuah@kernel.org, hawk@kernel.org, joe@wand.net.nz
Cc:     eyal.birger@gmail.com, shmulik.ladkani@gmail.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Gilad Sever <gilad9366@gmail.com>
Subject: [PATCH bpf,v2 3/4] bpf: fix bpf socket lookup from tc/xdp to respect socket VRF bindings
Date:   Thu, 20 Apr 2023 17:50:40 +0300
Message-Id: <20230420145041.508434-4-gilad9366@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230420145041.508434-1-gilad9366@gmail.com>
References: <20230420145041.508434-1-gilad9366@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When calling bpf_sk_lookup_tcp(), bpf_sk_lookup_udp() or
bpf_skc_lookup_tcp() from tc/xdp ingress, VRF socket bindings aren't
respoected, i.e. unbound sockets are returned, and bound sockets aren't
found.

VRF binding is determined by the sdif argument to sk_lookup(), however
when called from tc the IP SKB control block isn't initialized and thus
inet{,6}_sdif() always returns 0.

Fix by calculating sdif for the tc/xdp flows by observing the device's
l3 enslaved state.

The cg/sk_skb hooking points which are expected to support
inet{,6}_sdif() pass sdif=-1 which makes __bpf_skc_lookup() use the
existing logic.

Fixes: 6acc9b432e67 ("bpf: Add helper to retrieve socket in BPF")
Signed-off-by: Gilad Sever <gilad9366@gmail.com>
---
 net/core/filter.c | 63 +++++++++++++++++++++++++++++++----------------
 1 file changed, 42 insertions(+), 21 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index f43f86fc1235..d68e14ff1e55 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6529,12 +6529,11 @@ static struct sock *sk_lookup(struct net *net, struct bpf_sock_tuple *tuple,
 static struct sock *
 __bpf_skc_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
 		 struct net *caller_net, u32 ifindex, u8 proto, u64 netns_id,
-		 u64 flags)
+		 u64 flags, int sdif)
 {
 	struct sock *sk = NULL;
 	struct net *net;
 	u8 family;
-	int sdif;
 
 	if (len == sizeof(tuple->ipv4))
 		family = AF_INET;
@@ -6546,10 +6545,12 @@ __bpf_skc_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
 	if (unlikely(flags || !((s32)netns_id < 0 || netns_id <= S32_MAX)))
 		goto out;
 
-	if (family == AF_INET)
-		sdif = inet_sdif(skb);
-	else
-		sdif = inet6_sdif(skb);
+	if (sdif < 0) {
+		if (family == AF_INET)
+			sdif = inet_sdif(skb);
+		else
+			sdif = inet6_sdif(skb);
+	}
 
 	if ((s32)netns_id < 0) {
 		net = caller_net;
@@ -6569,10 +6570,11 @@ __bpf_skc_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
 static struct sock *
 __bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
 		struct net *caller_net, u32 ifindex, u8 proto, u64 netns_id,
-		u64 flags)
+		u64 flags, int sdif)
 {
 	struct sock *sk = __bpf_skc_lookup(skb, tuple, len, caller_net,
-					   ifindex, proto, netns_id, flags);
+					   ifindex, proto, netns_id, flags,
+					   sdif);
 
 	if (sk) {
 		struct sock *sk2 = sk_to_full_sk(sk);
@@ -6612,7 +6614,7 @@ bpf_skc_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
 	}
 
 	return __bpf_skc_lookup(skb, tuple, len, caller_net, ifindex, proto,
-				netns_id, flags);
+				netns_id, flags, -1);
 }
 
 static struct sock *
@@ -6701,15 +6703,25 @@ static const struct bpf_func_proto bpf_sk_lookup_udp_proto = {
 	.arg5_type	= ARG_ANYTHING,
 };
 
+static int bpf_l2_sdif(const struct net_device *dev)
+{
+#if IS_ENABLED(CONFIG_NET_L3_MASTER_DEV)
+	if (netif_is_l3_slave(dev))
+		return dev->ifindex;
+#endif
+	return 0;
+}
+
 BPF_CALL_5(bpf_tc_skc_lookup_tcp, struct sk_buff *, skb,
 	   struct bpf_sock_tuple *, tuple, u32, len, u64, netns_id, u64, flags)
 {
 	struct net *caller_net = dev_net(skb->dev);
+	int sdif = bpf_l2_sdif(skb->dev);
 	int ifindex = skb->dev->ifindex;
 
 	return (unsigned long)__bpf_skc_lookup(skb, tuple, len, caller_net,
 					       ifindex, IPPROTO_TCP, netns_id,
-					       flags);
+					       flags, sdif);
 }
 
 static const struct bpf_func_proto bpf_tc_skc_lookup_tcp_proto = {
@@ -6728,11 +6740,12 @@ BPF_CALL_5(bpf_tc_sk_lookup_tcp, struct sk_buff *, skb,
 	   struct bpf_sock_tuple *, tuple, u32, len, u64, netns_id, u64, flags)
 {
 	struct net *caller_net = dev_net(skb->dev);
+	int sdif = bpf_l2_sdif(skb->dev);
 	int ifindex = skb->dev->ifindex;
 
 	return (unsigned long)__bpf_sk_lookup(skb, tuple, len, caller_net,
 					      ifindex, IPPROTO_TCP, netns_id,
-					      flags);
+					      flags, sdif);
 }
 
 static const struct bpf_func_proto bpf_tc_sk_lookup_tcp_proto = {
@@ -6751,11 +6764,12 @@ BPF_CALL_5(bpf_tc_sk_lookup_udp, struct sk_buff *, skb,
 	   struct bpf_sock_tuple *, tuple, u32, len, u64, netns_id, u64, flags)
 {
 	struct net *caller_net = dev_net(skb->dev);
+	int sdif = bpf_l2_sdif(skb->dev);
 	int ifindex = skb->dev->ifindex;
 
 	return (unsigned long)__bpf_sk_lookup(skb, tuple, len, caller_net,
 					      ifindex, IPPROTO_UDP, netns_id,
-					      flags);
+					      flags, sdif);
 }
 
 static const struct bpf_func_proto bpf_tc_sk_lookup_udp_proto = {
@@ -6788,11 +6802,13 @@ BPF_CALL_5(bpf_xdp_sk_lookup_udp, struct xdp_buff *, ctx,
 	   struct bpf_sock_tuple *, tuple, u32, len, u32, netns_id, u64, flags)
 {
 	struct net *caller_net = dev_net(ctx->rxq->dev);
-	int ifindex = ctx->rxq->dev->ifindex;
+	struct net_device *dev = ctx->rxq->dev;
+	int sdif = bpf_l2_sdif(dev);
+	int ifindex = dev->ifindex;
 
 	return (unsigned long)__bpf_sk_lookup(NULL, tuple, len, caller_net,
 					      ifindex, IPPROTO_UDP, netns_id,
-					      flags);
+					      flags, sdif);
 }
 
 static const struct bpf_func_proto bpf_xdp_sk_lookup_udp_proto = {
@@ -6811,11 +6827,13 @@ BPF_CALL_5(bpf_xdp_skc_lookup_tcp, struct xdp_buff *, ctx,
 	   struct bpf_sock_tuple *, tuple, u32, len, u32, netns_id, u64, flags)
 {
 	struct net *caller_net = dev_net(ctx->rxq->dev);
-	int ifindex = ctx->rxq->dev->ifindex;
+	struct net_device *dev = ctx->rxq->dev;
+	int sdif = bpf_l2_sdif(dev);
+	int ifindex = dev->ifindex;
 
 	return (unsigned long)__bpf_skc_lookup(NULL, tuple, len, caller_net,
 					       ifindex, IPPROTO_TCP, netns_id,
-					       flags);
+					       flags, sdif);
 }
 
 static const struct bpf_func_proto bpf_xdp_skc_lookup_tcp_proto = {
@@ -6834,11 +6852,13 @@ BPF_CALL_5(bpf_xdp_sk_lookup_tcp, struct xdp_buff *, ctx,
 	   struct bpf_sock_tuple *, tuple, u32, len, u32, netns_id, u64, flags)
 {
 	struct net *caller_net = dev_net(ctx->rxq->dev);
-	int ifindex = ctx->rxq->dev->ifindex;
+	struct net_device *dev = ctx->rxq->dev;
+	int sdif = bpf_l2_sdif(dev);
+	int ifindex = dev->ifindex;
 
 	return (unsigned long)__bpf_sk_lookup(NULL, tuple, len, caller_net,
 					      ifindex, IPPROTO_TCP, netns_id,
-					      flags);
+					      flags, sdif);
 }
 
 static const struct bpf_func_proto bpf_xdp_sk_lookup_tcp_proto = {
@@ -6858,7 +6878,8 @@ BPF_CALL_5(bpf_sock_addr_skc_lookup_tcp, struct bpf_sock_addr_kern *, ctx,
 {
 	return (unsigned long)__bpf_skc_lookup(NULL, tuple, len,
 					       sock_net(ctx->sk), 0,
-					       IPPROTO_TCP, netns_id, flags);
+					       IPPROTO_TCP, netns_id, flags,
+					       -1);
 }
 
 static const struct bpf_func_proto bpf_sock_addr_skc_lookup_tcp_proto = {
@@ -6877,7 +6898,7 @@ BPF_CALL_5(bpf_sock_addr_sk_lookup_tcp, struct bpf_sock_addr_kern *, ctx,
 {
 	return (unsigned long)__bpf_sk_lookup(NULL, tuple, len,
 					      sock_net(ctx->sk), 0, IPPROTO_TCP,
-					      netns_id, flags);
+					      netns_id, flags, -1);
 }
 
 static const struct bpf_func_proto bpf_sock_addr_sk_lookup_tcp_proto = {
@@ -6896,7 +6917,7 @@ BPF_CALL_5(bpf_sock_addr_sk_lookup_udp, struct bpf_sock_addr_kern *, ctx,
 {
 	return (unsigned long)__bpf_sk_lookup(NULL, tuple, len,
 					      sock_net(ctx->sk), 0, IPPROTO_UDP,
-					      netns_id, flags);
+					      netns_id, flags, -1);
 }
 
 static const struct bpf_func_proto bpf_sock_addr_sk_lookup_udp_proto = {
-- 
2.34.1

