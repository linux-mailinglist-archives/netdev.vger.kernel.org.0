Return-Path: <netdev+bounces-9207-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DACA727F20
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 13:43:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 988821C21012
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 11:43:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0965C12B6F;
	Thu,  8 Jun 2023 11:42:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF56F12B6D;
	Thu,  8 Jun 2023 11:42:14 +0000 (UTC)
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E53926B9;
	Thu,  8 Jun 2023 04:42:09 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3f738f579ceso3102335e9.3;
        Thu, 08 Jun 2023 04:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686224527; x=1688816527;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QSHYo7cVWaoXbkTE6c6OtQbkqVlZzgy5m/dFCIALTNo=;
        b=cTyy82MKjyn7D/15N+4hlcyON8fdTbmI83nRjEQHdApEA+fCcL7Ex2tyA0bMLoRA6Z
         u+DTozV5fGJlXSsy+B/94nbgiGULRfa2r9fJNUgduYc0k8LwHJYYG1YU4QsIQAMH1Jdf
         A/3Xnu1XFTZA0u90/j4gWyo8w6EPTCRCDqz2rPg37Z33vL0hWqbGaABVQeeN1l7qyOMY
         9vf0L6QVMC30P6f27cpE86hQ0zdHKbYdnv8XEBPUSIm0NAp17wrt3CxVFN6JasOrXdXH
         hyWzYPQuAuKGEUJkHzi3b/TxGGgL7j3OQmDyVA1LNGBYITDxMcP0jGMTl3ttanzip419
         LP+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686224527; x=1688816527;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QSHYo7cVWaoXbkTE6c6OtQbkqVlZzgy5m/dFCIALTNo=;
        b=Zc85W3tOwbY9xq3b4NBdEcoIgaMLdNDJJQW5+CPItCNW4yEUWIcQEnLR3H1d8AT2ly
         4sVjBQuVA9NBDcbQMtM06flhPaNLC6J9eBbcyKY/uMes4MqfRvv0DHL50uMqu7VilNA9
         /x11fCiHwGoiq4wF/Dr+2jWcRhN27WwAZu27LAwoiP8LSX/hAx7IP1O7aRXTnD+U4p2y
         RZXTRBsIe2APezDtbg+xDX0MY0WF0YjhgB7COqiCziwdCeI9bZ44Bu6H7wNRJi0k9fcK
         3LeJtT0mJCDNX4A72Xx9UsZ2kabjHP6q2mcNd1tO/p3TPjgVrrDAGpxg7UhF1M+xHrJh
         fUgQ==
X-Gm-Message-State: AC+VfDxsC0eGFED5Za3wCzBAfJXNsyruljzfs5Sd00ZZGAfKJ9B8peqD
	dsWRScnwxFry/lsjGLlh7U0=
X-Google-Smtp-Source: ACHHUZ7G30H4QBlBdBgJtaDcfJPPzez5hZjjNOKyNaO7nPH1QXIj6PQOAB8jVNkodp9jPeGRnKmnZQ==
X-Received: by 2002:adf:f204:0:b0:30e:46bc:1bee with SMTP id p4-20020adff204000000b0030e46bc1beemr6185613wro.68.1686224527453;
        Thu, 08 Jun 2023 04:42:07 -0700 (PDT)
Received: from gsever-Latitude-7400.corp.proofpoint.com ([46.120.112.185])
        by smtp.gmail.com with ESMTPSA id s2-20020adfecc2000000b0030aed4223e0sm1326158wro.105.2023.06.08.04.42.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 04:42:07 -0700 (PDT)
From: Gilad Sever <gilad9366@gmail.com>
To: dsahern@kernel.org,
	martin.lau@linux.dev,
	daniel@iogearbox.net,
	john.fastabend@gmail.com,
	ast@kernel.org,
	andrii@kernel.org,
	song@kernel.org,
	yhs@fb.com,
	kpsingh@kernel.org,
	sdf@google.com,
	haoluo@google.com,
	jolsa@kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	mykolal@fb.com,
	shuah@kernel.org,
	hawk@kernel.org,
	joe@wand.net.nz
Cc: eyal.birger@gmail.com,
	shmulik.ladkani@gmail.com,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Gilad Sever <gilad9366@gmail.com>
Subject: [PATCH bpf,v5 3/4] bpf: fix bpf socket lookup from tc/xdp to respect socket VRF bindings
Date: Thu,  8 Jun 2023 14:41:54 +0300
Message-Id: <20230608114155.39367-4-gilad9366@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230608114155.39367-1-gilad9366@gmail.com>
References: <20230608114155.39367-1-gilad9366@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

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
Acked-by: Stanislav Fomichev <sdf@google.com>
Reviewed-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Reviewed-by: Eyal Birger <eyal.birger@gmail.com>
Signed-off-by: Gilad Sever <gilad9366@gmail.com>
---
v5: Use reverse xmas tree indentation

v4: Move dev_sdif() to include/linux/netdevice.h as suggested by Stanislav Fomichev

v3: Rename bpf_l2_sdif() to dev_sdif() as suggested by Stanislav Fomichev
---
 include/linux/netdevice.h |  9 +++++++
 net/core/filter.c         | 54 ++++++++++++++++++++++++---------------
 2 files changed, 42 insertions(+), 21 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index c2f0c6002a84..db1bfca6b8b4 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -5093,6 +5093,15 @@ static inline bool netif_is_l3_slave(const struct net_device *dev)
 	return dev->priv_flags & IFF_L3MDEV_SLAVE;
 }
 
+static inline int dev_sdif(const struct net_device *dev)
+{
+#if IS_ENABLED(CONFIG_NET_L3_MASTER_DEV)
+	if (netif_is_l3_slave(dev))
+		return dev->ifindex;
+#endif
+	return 0;
+}
+
 static inline bool netif_is_bridge_master(const struct net_device *dev)
 {
 	return dev->priv_flags & IFF_EBRIDGE;
diff --git a/net/core/filter.c b/net/core/filter.c
index e06547922edc..5f665845ae45 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6555,12 +6555,11 @@ static struct sock *sk_lookup(struct net *net, struct bpf_sock_tuple *tuple,
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
@@ -6572,10 +6571,12 @@ __bpf_skc_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
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
@@ -6595,10 +6596,11 @@ __bpf_skc_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
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
@@ -6638,7 +6640,7 @@ bpf_skc_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
 	}
 
 	return __bpf_skc_lookup(skb, tuple, len, caller_net, ifindex, proto,
-				netns_id, flags);
+				netns_id, flags, -1);
 }
 
 static struct sock *
@@ -6732,10 +6734,11 @@ BPF_CALL_5(bpf_tc_skc_lookup_tcp, struct sk_buff *, skb,
 {
 	struct net *caller_net = dev_net(skb->dev);
 	int ifindex = skb->dev->ifindex;
+	int sdif = dev_sdif(skb->dev);
 
 	return (unsigned long)__bpf_skc_lookup(skb, tuple, len, caller_net,
 					       ifindex, IPPROTO_TCP, netns_id,
-					       flags);
+					       flags, sdif);
 }
 
 static const struct bpf_func_proto bpf_tc_skc_lookup_tcp_proto = {
@@ -6755,10 +6758,11 @@ BPF_CALL_5(bpf_tc_sk_lookup_tcp, struct sk_buff *, skb,
 {
 	struct net *caller_net = dev_net(skb->dev);
 	int ifindex = skb->dev->ifindex;
+	int sdif = dev_sdif(skb->dev);
 
 	return (unsigned long)__bpf_sk_lookup(skb, tuple, len, caller_net,
 					      ifindex, IPPROTO_TCP, netns_id,
-					      flags);
+					      flags, sdif);
 }
 
 static const struct bpf_func_proto bpf_tc_sk_lookup_tcp_proto = {
@@ -6778,10 +6782,11 @@ BPF_CALL_5(bpf_tc_sk_lookup_udp, struct sk_buff *, skb,
 {
 	struct net *caller_net = dev_net(skb->dev);
 	int ifindex = skb->dev->ifindex;
+	int sdif = dev_sdif(skb->dev);
 
 	return (unsigned long)__bpf_sk_lookup(skb, tuple, len, caller_net,
 					      ifindex, IPPROTO_UDP, netns_id,
-					      flags);
+					      flags, sdif);
 }
 
 static const struct bpf_func_proto bpf_tc_sk_lookup_udp_proto = {
@@ -6814,11 +6819,13 @@ BPF_CALL_5(bpf_xdp_sk_lookup_udp, struct xdp_buff *, ctx,
 	   struct bpf_sock_tuple *, tuple, u32, len, u32, netns_id, u64, flags)
 {
 	struct net *caller_net = dev_net(ctx->rxq->dev);
-	int ifindex = ctx->rxq->dev->ifindex;
+	struct net_device *dev = ctx->rxq->dev;
+	int ifindex = dev->ifindex;
+	int sdif = dev_sdif(dev);
 
 	return (unsigned long)__bpf_sk_lookup(NULL, tuple, len, caller_net,
 					      ifindex, IPPROTO_UDP, netns_id,
-					      flags);
+					      flags, sdif);
 }
 
 static const struct bpf_func_proto bpf_xdp_sk_lookup_udp_proto = {
@@ -6837,11 +6844,13 @@ BPF_CALL_5(bpf_xdp_skc_lookup_tcp, struct xdp_buff *, ctx,
 	   struct bpf_sock_tuple *, tuple, u32, len, u32, netns_id, u64, flags)
 {
 	struct net *caller_net = dev_net(ctx->rxq->dev);
-	int ifindex = ctx->rxq->dev->ifindex;
+	struct net_device *dev = ctx->rxq->dev;
+	int ifindex = dev->ifindex;
+	int sdif = dev_sdif(dev);
 
 	return (unsigned long)__bpf_skc_lookup(NULL, tuple, len, caller_net,
 					       ifindex, IPPROTO_TCP, netns_id,
-					       flags);
+					       flags, sdif);
 }
 
 static const struct bpf_func_proto bpf_xdp_skc_lookup_tcp_proto = {
@@ -6860,11 +6869,13 @@ BPF_CALL_5(bpf_xdp_sk_lookup_tcp, struct xdp_buff *, ctx,
 	   struct bpf_sock_tuple *, tuple, u32, len, u32, netns_id, u64, flags)
 {
 	struct net *caller_net = dev_net(ctx->rxq->dev);
-	int ifindex = ctx->rxq->dev->ifindex;
+	struct net_device *dev = ctx->rxq->dev;
+	int ifindex = dev->ifindex;
+	int sdif = dev_sdif(dev);
 
 	return (unsigned long)__bpf_sk_lookup(NULL, tuple, len, caller_net,
 					      ifindex, IPPROTO_TCP, netns_id,
-					      flags);
+					      flags, sdif);
 }
 
 static const struct bpf_func_proto bpf_xdp_sk_lookup_tcp_proto = {
@@ -6884,7 +6895,8 @@ BPF_CALL_5(bpf_sock_addr_skc_lookup_tcp, struct bpf_sock_addr_kern *, ctx,
 {
 	return (unsigned long)__bpf_skc_lookup(NULL, tuple, len,
 					       sock_net(ctx->sk), 0,
-					       IPPROTO_TCP, netns_id, flags);
+					       IPPROTO_TCP, netns_id, flags,
+					       -1);
 }
 
 static const struct bpf_func_proto bpf_sock_addr_skc_lookup_tcp_proto = {
@@ -6903,7 +6915,7 @@ BPF_CALL_5(bpf_sock_addr_sk_lookup_tcp, struct bpf_sock_addr_kern *, ctx,
 {
 	return (unsigned long)__bpf_sk_lookup(NULL, tuple, len,
 					      sock_net(ctx->sk), 0, IPPROTO_TCP,
-					      netns_id, flags);
+					      netns_id, flags, -1);
 }
 
 static const struct bpf_func_proto bpf_sock_addr_sk_lookup_tcp_proto = {
@@ -6922,7 +6934,7 @@ BPF_CALL_5(bpf_sock_addr_sk_lookup_udp, struct bpf_sock_addr_kern *, ctx,
 {
 	return (unsigned long)__bpf_sk_lookup(NULL, tuple, len,
 					      sock_net(ctx->sk), 0, IPPROTO_UDP,
-					      netns_id, flags);
+					      netns_id, flags, -1);
 }
 
 static const struct bpf_func_proto bpf_sock_addr_sk_lookup_udp_proto = {
-- 
2.34.1


