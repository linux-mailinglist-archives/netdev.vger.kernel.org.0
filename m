Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF1416E9469
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 14:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234358AbjDTMcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 08:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234571AbjDTMct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 08:32:49 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 672A26595;
        Thu, 20 Apr 2023 05:32:29 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-2fa36231b1cso350020f8f.2;
        Thu, 20 Apr 2023 05:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681993948; x=1684585948;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KGr5SgBXm0/c3pk6ZOsMNvbnJ2k0k6gIIMCtdzqVOR4=;
        b=ka98ufLobq6KQna8mnYMZJk3voRvhAsbxgwLjhri8Uh+5XpOkfVAijgHN2AWsAwFL5
         E5IJshXSK/N50ZZaoOPT13ENyj+W4/e++S2K0Ihlg4ZKg6ZAnlQvb7wxlQivZAHCosY2
         vbxfra0+0buJKt0xKLxhsjsVMgcc1i5KMjU1yvhzOZ6YnIHNpkUb05fapnRj2/TGCGPd
         yoynKDWGMSlRGNHH83rKJSn0tUqZcZbe11ziwraqwhInKtwzPjP6jAbsn3CzY3hyl6/u
         CX+UzYuumtrRxWv/Eh/81W+XCFH2X/Uf3FDPkJvbspEqvhIebXQPeAXVJT8GmphZXOfp
         tnOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681993948; x=1684585948;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KGr5SgBXm0/c3pk6ZOsMNvbnJ2k0k6gIIMCtdzqVOR4=;
        b=KNHFM3FjLfRk3h8TW2W1ZJpqQzVY7i6GL83+DdBzdTiNkzAQgHRhqFNdArTxL7mx4P
         ZMCEQKQzN29icURrWGxBDkhmEvDssSUsroi9zwVJ/LTEKrnEEDiz1mg6xZul3kE1jYKm
         yY++ZG3rFmGKW4o1E2zZ3Y8uhR2WVwhnVm9s9nUyxDsCzKPoVfr6MXOyApCB6zcWHT1y
         ctuCR4ZfUwIojjnC1dwokoA+Uw91DVmsV43BvcHHelSIR8to+lZXDN7X9YLtsWSlkrxL
         B+UQOARJf7CDokMH2ME9KlsyCReFvMwfYjr6qEbjdYTFgM7ec0QJQqgt7eQgbwoU/1Zc
         dTHA==
X-Gm-Message-State: AAQBX9dDABlii5A9QLNjpH5cAi3WOsPkbx0ooLKIpVGjCXxqoOVmHsCJ
        vFvmnOMfwgybHvVRzQEGLbw=
X-Google-Smtp-Source: AKy350ahVieMOvE7Ut8giQxGLOLF/E9mDfuyvHzGdmHHG6EUvxsSmvN7DGOioRp3oZJ66Xo5OrVJzQ==
X-Received: by 2002:a05:6000:50:b0:2f6:a7a:1df5 with SMTP id k16-20020a056000005000b002f60a7a1df5mr1156146wrx.70.1681993947577;
        Thu, 20 Apr 2023 05:32:27 -0700 (PDT)
Received: from gsever-Latitude-7400.corp.proofpoint.com ([46.120.112.185])
        by smtp.gmail.com with ESMTPSA id z16-20020a5d4410000000b002f79ea6746asm1835081wrq.94.2023.04.20.05.32.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 05:32:27 -0700 (PDT)
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
Subject: [PATCH bpf 1/4] bpf: factor out socket lookup functions for the TC hookpoint.
Date:   Thu, 20 Apr 2023 15:31:52 +0300
Message-Id: <20230420123155.497634-2-gilad9366@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230420123155.497634-1-gilad9366@gmail.com>
References: <20230420123155.497634-1-gilad9366@gmail.com>
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

