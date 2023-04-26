Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC936EF07D
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 10:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240047AbjDZIvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 04:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240190AbjDZIvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 04:51:39 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEFE04498;
        Wed, 26 Apr 2023 01:51:34 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-3f09b4a156eso45517285e9.3;
        Wed, 26 Apr 2023 01:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682499093; x=1685091093;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KGr5SgBXm0/c3pk6ZOsMNvbnJ2k0k6gIIMCtdzqVOR4=;
        b=a1Hf0TyYALZacjstoKTn6+Y5GPjCTg+Ij1k5WOe8rUobNujSVlKTCpR1nNnLtN4QLB
         yGyocSs60XXqFY7ZaZSMKG9JvpcyuLq8wq2nEqDnlZmVzlfK4kyiR0bEFLFOazt62x+T
         wSffsFM6/WvOMt26kpai9WhCmSunXrFGWxt1eLumXsKJG2q5iBs6sVAcX2j52JxKbpXr
         GoOIwiasV8T9gE3H6RecVPnmfDc274sR2GEdsXDGN1nzLv3QszZ1V64wZZvCoi74CzV1
         xSTT3YWm1yQhMtVFVbT2KDVFn0CAk8K5KhVJ6ejoHxXyYayZI/zL0UQSUzzfYcongv+c
         z9PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682499093; x=1685091093;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KGr5SgBXm0/c3pk6ZOsMNvbnJ2k0k6gIIMCtdzqVOR4=;
        b=ZwEESRc4dvVaAuDZ3VqdqMjrMgXfysqViwMPFaiD63jhAD0LtbHoGVWt1940yJivQU
         0KdkS+EYi6/X1/dZ4X2nr1365ch3y8ayIIlnnOTmaZ8nIfmVfAjinQpCQxMhZOmNlfBk
         xy/rB0kGHCwlCHoZQAK3AQfGM1TGVx79kLv/yFTgfruSBc4z+XCXejxTP8Ru3caNyiJm
         F/Nd5DLIO9TUjSuxooz6VdzDPWbjWUKZ7xEv5cArc2G/Gj7d4agutR3KxARqgEPHp9Ju
         1uGZLt4R51WbqMkRPaJy27+8I9brUxemvr/YTREUo6MzNfdjdQm56R9651XyUeAwhBFc
         hIBQ==
X-Gm-Message-State: AAQBX9dCcYkjMkAZCMEuAlgG+ZbkGEMJ13wEENgl+K+RdmFTdU3W79lI
        0fhBCAwwgYE7oQgA6HlbaqM=
X-Google-Smtp-Source: AKy350aLVjAUIQb6tasz1GfFJSe/tYm/qEounw51bIpCXhChTTtsnpMm1hAkfUSapYZMJtk1oxcDyQ==
X-Received: by 2002:a5d:58e3:0:b0:2ee:da1c:381a with SMTP id f3-20020a5d58e3000000b002eeda1c381amr13441455wrd.69.1682499093283;
        Wed, 26 Apr 2023 01:51:33 -0700 (PDT)
Received: from localhost.localdomain ([46.120.112.185])
        by smtp.gmail.com with ESMTPSA id q11-20020a5d574b000000b003049d7b9f4csm1229838wrw.32.2023.04.26.01.51.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 01:51:32 -0700 (PDT)
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
Subject: [PATCH bpf,v3 1/4] bpf: factor out socket lookup functions for the TC hookpoint.
Date:   Wed, 26 Apr 2023 11:51:19 +0300
Message-Id: <20230426085122.376768-2-gilad9366@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230426085122.376768-1-gilad9366@gmail.com>
References: <20230426085122.376768-1-gilad9366@gmail.com>
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

Change BPF helper socket lookup functions to use TC specific variants:
bpf_tc_sk_lookup_tcp() / bpf_tc_sk_lookup_udp() / bpf_tc_skc_lookup_tcp()
instead of sharing implementation with the cg / sk_skb hooking points.
This allows introducing a separate logic for the TC flow.

The tc functions are identical to the original code.

Reviewed-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Reviewed-by: Eyal Birger <eyal.birger@gmail.com>
Signed-off-by: Gilad Sever <gilad9366@gmail.com>
---
 net/core/filter.c | 63 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 60 insertions(+), 3 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 1d6f165923bf..5910956f4e0d 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6701,6 +6701,63 @@ static const struct bpf_func_proto bpf_sk_lookup_udp_proto = {
 	.arg5_type	= ARG_ANYTHING,
 };
 
+BPF_CALL_5(bpf_tc_skc_lookup_tcp, struct sk_buff *, skb,
+	   struct bpf_sock_tuple *, tuple, u32, len, u64, netns_id, u64, flags)
+{
+	return (unsigned long)bpf_skc_lookup(skb, tuple, len, IPPROTO_TCP,
+					     netns_id, flags);
+}
+
+static const struct bpf_func_proto bpf_tc_skc_lookup_tcp_proto = {
+	.func		= bpf_tc_skc_lookup_tcp,
+	.gpl_only	= false,
+	.pkt_access	= true,
+	.ret_type	= RET_PTR_TO_SOCK_COMMON_OR_NULL,
+	.arg1_type	= ARG_PTR_TO_CTX,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
+	.arg3_type	= ARG_CONST_SIZE,
+	.arg4_type	= ARG_ANYTHING,
+	.arg5_type	= ARG_ANYTHING,
+};
+
+BPF_CALL_5(bpf_tc_sk_lookup_tcp, struct sk_buff *, skb,
+	   struct bpf_sock_tuple *, tuple, u32, len, u64, netns_id, u64, flags)
+{
+	return (unsigned long)bpf_sk_lookup(skb, tuple, len, IPPROTO_TCP,
+					    netns_id, flags);
+}
+
+static const struct bpf_func_proto bpf_tc_sk_lookup_tcp_proto = {
+	.func		= bpf_tc_sk_lookup_tcp,
+	.gpl_only	= false,
+	.pkt_access	= true,
+	.ret_type	= RET_PTR_TO_SOCKET_OR_NULL,
+	.arg1_type	= ARG_PTR_TO_CTX,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
+	.arg3_type	= ARG_CONST_SIZE,
+	.arg4_type	= ARG_ANYTHING,
+	.arg5_type	= ARG_ANYTHING,
+};
+
+BPF_CALL_5(bpf_tc_sk_lookup_udp, struct sk_buff *, skb,
+	   struct bpf_sock_tuple *, tuple, u32, len, u64, netns_id, u64, flags)
+{
+	return (unsigned long)bpf_sk_lookup(skb, tuple, len, IPPROTO_UDP,
+					    netns_id, flags);
+}
+
+static const struct bpf_func_proto bpf_tc_sk_lookup_udp_proto = {
+	.func		= bpf_tc_sk_lookup_udp,
+	.gpl_only	= false,
+	.pkt_access	= true,
+	.ret_type	= RET_PTR_TO_SOCKET_OR_NULL,
+	.arg1_type	= ARG_PTR_TO_CTX,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
+	.arg3_type	= ARG_CONST_SIZE,
+	.arg4_type	= ARG_ANYTHING,
+	.arg5_type	= ARG_ANYTHING,
+};
+
 BPF_CALL_1(bpf_sk_release, struct sock *, sk)
 {
 	if (sk && sk_is_refcounted(sk))
@@ -7954,9 +8011,9 @@ tc_cls_act_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 #endif
 #ifdef CONFIG_INET
 	case BPF_FUNC_sk_lookup_tcp:
-		return &bpf_sk_lookup_tcp_proto;
+		return &bpf_tc_sk_lookup_tcp_proto;
 	case BPF_FUNC_sk_lookup_udp:
-		return &bpf_sk_lookup_udp_proto;
+		return &bpf_tc_sk_lookup_udp_proto;
 	case BPF_FUNC_sk_release:
 		return &bpf_sk_release_proto;
 	case BPF_FUNC_tcp_sock:
@@ -7964,7 +8021,7 @@ tc_cls_act_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	case BPF_FUNC_get_listener_sock:
 		return &bpf_get_listener_sock_proto;
 	case BPF_FUNC_skc_lookup_tcp:
-		return &bpf_skc_lookup_tcp_proto;
+		return &bpf_tc_skc_lookup_tcp_proto;
 	case BPF_FUNC_tcp_check_syncookie:
 		return &bpf_tcp_check_syncookie_proto;
 	case BPF_FUNC_skb_ecn_set_ce:
-- 
2.34.1

