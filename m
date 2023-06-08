Return-Path: <netdev+bounces-9205-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 68BE0727F11
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 13:42:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 208852816F9
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 11:42:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 403F2125B5;
	Thu,  8 Jun 2023 11:42:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C68911CA0;
	Thu,  8 Jun 2023 11:42:11 +0000 (UTC)
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C38226BA;
	Thu,  8 Jun 2023 04:42:04 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-3f623adec61so4537085e9.0;
        Thu, 08 Jun 2023 04:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686224523; x=1688816523;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nniAcfc0pGJ2zeNQrhfgwRlH/v4XnVj4PMgap0ZSAzk=;
        b=f8nLG90yWVpUyE91Erii6A0yfOkOrCmseC/zR4rv0x0Lo9GQhakzOI3aoQt2oNkeku
         lYnUxOL5SvJMI+vL9O3DmFkZK3RAfd8wquJrvwZxbfez9M0APdNQPbTp77u2qSU25odp
         XdLPXykQTcVYRMcJChXFslhQggmCQx+pNDefuQS9NZcZUVPzOHCFLDPHEKBeAG0MF2zn
         /SxkAbXZr3HXFt0bm7L4Rqf27ZNsoqUtn2HJrZW0cRgnhPCU8Gsn/Js5Mp+A3O/9MBoM
         NiLD4PgCDHbrqFGCV4M2nuKsdEFP1bkCevURH7k937RsU1VpLBwRo4QPjlbxiZYtZGXT
         PIFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686224523; x=1688816523;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nniAcfc0pGJ2zeNQrhfgwRlH/v4XnVj4PMgap0ZSAzk=;
        b=KpSJidxa9GcpCFtihF/TIPnWN0o27BFP/1xvRYaywo5OfC/PtBM+I/g6WptptdQSnI
         fSvuobmfzcdueh63ArYsYt+OuVWx34p1NVVmk2P8rwunoEJv9gifJVz/P0y6knoUzoYe
         iebEmQ4q7nFO1Ec2LQqShHbRuVFkhlPhJgGQBseeheV4ge8fus5nPl4EkN1oS+vIK/D0
         ZT+WptimfNVGo3xUUvkLrWx/psIzt8B9bpV/5MCj/nzr+GMdy1/hfaE9loj/aX9JGNhn
         dnw6PJwX5hBIYaEDdHAqc5B0UlY/usAmvtxu37sPaKk5cJZ7ATKmVm0Mhqzueknn1I+0
         VlSg==
X-Gm-Message-State: AC+VfDxoZxUKXev42ArR0l2OVB7SMGFUFZAIxntELN1U8qpEt9lMemIG
	r1ky5QxtoEr+gdOOWaxg9Ds=
X-Google-Smtp-Source: ACHHUZ6o5xABODoqmdLVSiXqxpXa2pUTcyIJfrmp//lTRFd1k+/OgKsc4dLa+/dYyQ67/pGdknTUuw==
X-Received: by 2002:a05:600c:2948:b0:3f6:476:915 with SMTP id n8-20020a05600c294800b003f604760915mr1232070wmd.6.1686224522545;
        Thu, 08 Jun 2023 04:42:02 -0700 (PDT)
Received: from gsever-Latitude-7400.corp.proofpoint.com ([46.120.112.185])
        by smtp.gmail.com with ESMTPSA id s2-20020adfecc2000000b0030aed4223e0sm1326158wro.105.2023.06.08.04.42.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 04:42:02 -0700 (PDT)
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
Subject: [PATCH bpf,v5 1/4] bpf: factor out socket lookup functions for the TC hookpoint.
Date: Thu,  8 Jun 2023 14:41:52 +0300
Message-Id: <20230608114155.39367-2-gilad9366@gmail.com>
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

Change BPF helper socket lookup functions to use TC specific variants:
bpf_tc_sk_lookup_tcp() / bpf_tc_sk_lookup_udp() / bpf_tc_skc_lookup_tcp()
instead of sharing implementation with the cg / sk_skb hooking points.
This allows introducing a separate logic for the TC flow.

The tc functions are identical to the original code.

Acked-by: Stanislav Fomichev <sdf@google.com>
Reviewed-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Reviewed-by: Eyal Birger <eyal.birger@gmail.com>
Signed-off-by: Gilad Sever <gilad9366@gmail.com>
---
 net/core/filter.c | 63 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 60 insertions(+), 3 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index d9ce04ca22ce..57d853460e12 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6727,6 +6727,63 @@ static const struct bpf_func_proto bpf_sk_lookup_udp_proto = {
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
@@ -7980,9 +8037,9 @@ tc_cls_act_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
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
@@ -7990,7 +8047,7 @@ tc_cls_act_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
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


