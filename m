Return-Path: <netdev+bounces-9206-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E72F8727F13
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 13:43:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4ACF61C20EA2
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 11:43:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61193125D0;
	Thu,  8 Jun 2023 11:42:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54478125CE;
	Thu,  8 Jun 2023 11:42:12 +0000 (UTC)
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ADA7270F;
	Thu,  8 Jun 2023 04:42:06 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-3f7f543fe2fso4330905e9.2;
        Thu, 08 Jun 2023 04:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686224525; x=1688816525;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iHPRs1MqZty/wg+jsAp8zNvbtNVXPPRgzXINsE+kXQE=;
        b=fsEx4JOtLPwV+iD93Nj3U/O3RXwOPlk6fgVfgL+ZeZQPdOuKV/0fFUK4FMrfazbjra
         o97yVq0gR4E2NKl3pp2pQ3ZbA8MI+FZIoWx/9IR507C7wb1js/rtx+/ZA/uDJdI8NclC
         yGYWozoYqCsqFuMXKayGrwEYK3Zb9F/c8yEBoocSs3L4kqwVzNLtc/XoAhg+0eepREHZ
         B3hf1fmW6fnRjqKZlZ/zJ5zPUa7lJM6zDRxU97dXmHVhZp1MhAC7PFNRS3HhxO6F8VRx
         yPOZ/TuTt3YtmI0SzPuAkAPPbRrLyh+K5im9psoXsXK/T20dLMRP2bbKVLOjuJB3fx9r
         TqpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686224525; x=1688816525;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iHPRs1MqZty/wg+jsAp8zNvbtNVXPPRgzXINsE+kXQE=;
        b=Xw3omen1u+a0fPt4CCdBn+5DpBY0k6HrIv0UywIdY3gIUSe+58KK2/5pxJ9V2Yx4SZ
         1ZyZBsdkasQh+yw4dbVOWnjmz5jZoiBTgL1a9NILo0wJxzufjFAo62BnSEPjKOfBbz1D
         NkboELhyxGoIn4hE4MezLfJH9tcv4ASVzu8P2dzBolQdQIocqzFWkQrm+WbaE7z/cqhb
         d3sMTrnnVTx2B2WcR8WFBCt4E04KxlFHxGSUrJoSJ0gg+Gdyjq6+4ZzLKtkESTIiG3/R
         LupwJWKwpxaaeKvzm5YLMawdEE5ihJ7qLm8M2gzmYa+0hQTXEHm2OTOOP1F/YjVwdhhd
         o93g==
X-Gm-Message-State: AC+VfDwwW1Mc+lgQsj7lsTS+hWFNfd6rlxPjpDsSY4wQSlh7BpR/I5Fo
	UD/UNLC+pChCmFA8/VvpzFI=
X-Google-Smtp-Source: ACHHUZ4KBsDu9oigJFcVGzjVOfAunZQRa0B6RK2fkUMwbk5VlSuwDcHeJ5THOSIaHkZQ2ggC4ZVoAg==
X-Received: by 2002:a5d:464c:0:b0:30d:779a:111d with SMTP id j12-20020a5d464c000000b0030d779a111dmr7223943wrs.17.1686224524890;
        Thu, 08 Jun 2023 04:42:04 -0700 (PDT)
Received: from gsever-Latitude-7400.corp.proofpoint.com ([46.120.112.185])
        by smtp.gmail.com with ESMTPSA id s2-20020adfecc2000000b0030aed4223e0sm1326158wro.105.2023.06.08.04.42.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 04:42:04 -0700 (PDT)
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
Subject: [PATCH bpf,v5 2/4] bpf: Call __bpf_sk_lookup()/__bpf_skc_lookup() directly via TC hookpoint
Date: Thu,  8 Jun 2023 14:41:53 +0300
Message-Id: <20230608114155.39367-3-gilad9366@gmail.com>
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

skb->dev always exists in the tc flow. There is no need to use
bpf_skc_lookup(), bpf_sk_lookup() from this code path.

This change facilitates fixing the tc flow to be VRF aware.

Acked-by: Stanislav Fomichev <sdf@google.com>
Reviewed-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Reviewed-by: Eyal Birger <eyal.birger@gmail.com>
Signed-off-by: Gilad Sever <gilad9366@gmail.com>
---
 net/core/filter.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 57d853460e12..e06547922edc 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6730,8 +6730,12 @@ static const struct bpf_func_proto bpf_sk_lookup_udp_proto = {
 BPF_CALL_5(bpf_tc_skc_lookup_tcp, struct sk_buff *, skb,
 	   struct bpf_sock_tuple *, tuple, u32, len, u64, netns_id, u64, flags)
 {
-	return (unsigned long)bpf_skc_lookup(skb, tuple, len, IPPROTO_TCP,
-					     netns_id, flags);
+	struct net *caller_net = dev_net(skb->dev);
+	int ifindex = skb->dev->ifindex;
+
+	return (unsigned long)__bpf_skc_lookup(skb, tuple, len, caller_net,
+					       ifindex, IPPROTO_TCP, netns_id,
+					       flags);
 }
 
 static const struct bpf_func_proto bpf_tc_skc_lookup_tcp_proto = {
@@ -6749,8 +6753,12 @@ static const struct bpf_func_proto bpf_tc_skc_lookup_tcp_proto = {
 BPF_CALL_5(bpf_tc_sk_lookup_tcp, struct sk_buff *, skb,
 	   struct bpf_sock_tuple *, tuple, u32, len, u64, netns_id, u64, flags)
 {
-	return (unsigned long)bpf_sk_lookup(skb, tuple, len, IPPROTO_TCP,
-					    netns_id, flags);
+	struct net *caller_net = dev_net(skb->dev);
+	int ifindex = skb->dev->ifindex;
+
+	return (unsigned long)__bpf_sk_lookup(skb, tuple, len, caller_net,
+					      ifindex, IPPROTO_TCP, netns_id,
+					      flags);
 }
 
 static const struct bpf_func_proto bpf_tc_sk_lookup_tcp_proto = {
@@ -6768,8 +6776,12 @@ static const struct bpf_func_proto bpf_tc_sk_lookup_tcp_proto = {
 BPF_CALL_5(bpf_tc_sk_lookup_udp, struct sk_buff *, skb,
 	   struct bpf_sock_tuple *, tuple, u32, len, u64, netns_id, u64, flags)
 {
-	return (unsigned long)bpf_sk_lookup(skb, tuple, len, IPPROTO_UDP,
-					    netns_id, flags);
+	struct net *caller_net = dev_net(skb->dev);
+	int ifindex = skb->dev->ifindex;
+
+	return (unsigned long)__bpf_sk_lookup(skb, tuple, len, caller_net,
+					      ifindex, IPPROTO_UDP, netns_id,
+					      flags);
 }
 
 static const struct bpf_func_proto bpf_tc_sk_lookup_udp_proto = {
-- 
2.34.1


