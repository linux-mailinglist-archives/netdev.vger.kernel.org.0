Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46BC3573524
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 13:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235969AbiGMLPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 07:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235968AbiGMLO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 07:14:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BD6F6F5116
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 04:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657710887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wuR8FXFo94ahyoYDajY486Whyu+YAqAq0MCiFtSIImw=;
        b=i5RfDA6C7l1ZFfb3IqN164f+1mwYhLmpmCrxQVx9v3uiU5NLrIUIW4bmNayjk8fTMQMTh3
        bTtNPbzA8NVbZ68Jylwn7/U99u3mI93Vg1mBukAS74uJzLciifu3CPNx3airNRLLjGMUrT
        9s+0W2+FG2I9N2dLqT2avgf2FT332HA=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-85-4cjoD0X0Mu6qbaljJRCrUw-1; Wed, 13 Jul 2022 07:14:43 -0400
X-MC-Unique: 4cjoD0X0Mu6qbaljJRCrUw-1
Received: by mail-ed1-f72.google.com with SMTP id c9-20020a05640227c900b0043ad14b1fa0so6003658ede.1
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 04:14:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wuR8FXFo94ahyoYDajY486Whyu+YAqAq0MCiFtSIImw=;
        b=N5aqQcuLZmmoXmmZ2NpWPNWOI3BVcZANpvbcEuQl8O3XphbJPjW4rYSYphZ3NojJ9e
         bqWYk6QW/WQKu9i/GUb7m3DlTtkmk5ay0CC3jbHAG2TvlT4TRXHOBSkbteu1SmH2jlrW
         F+6R4pERhh0PAZfqYEQn4reAeHsB6SA6+jU8pR2oTnTLi31iX/B6hKpbC53cQbeoe1/3
         99hTFDNe1ofKStaYm7DoaFKt8/kemrO0R1yrG3W+yEB1ojmtyvSCMAKo+8ZxOgJzBtC6
         61AyfHgGedWw5sJvJQhYWR7uH/nzxn07Ph4ID7gyJZQS3wnV8peL9S5D2qELH6xcinLf
         7MtQ==
X-Gm-Message-State: AJIora8Yj68daDlVukc1iWAHiqfX5EsMXf2Men2McwaqimXs4P2iAGoU
        LiS4c3DMwe7fSHhb1qSbRJ6L6LV4kbxeLX5j1jIOzIzjByXGIaqSiOZ41czY0EtB2kFM6rHQ+kA
        PWDKIO160++SDIPrY
X-Received: by 2002:a05:6402:1bda:b0:43a:55d7:9f2f with SMTP id ch26-20020a0564021bda00b0043a55d79f2fmr4005449edb.360.1657710881961;
        Wed, 13 Jul 2022 04:14:41 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vGpIBjNSgB/AtD/xtNF900ucY1jjJYDN6RHNmEioUCGKOiES+fu5fHCZFnL6rPgI98Qa+g/A==
X-Received: by 2002:a05:6402:1bda:b0:43a:55d7:9f2f with SMTP id ch26-20020a0564021bda00b0043a55d79f2fmr4005396edb.360.1657710881587;
        Wed, 13 Jul 2022 04:14:41 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id j20-20020a170906411400b00726e108b566sm4872706ejk.173.2022.07.13.04.14.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 04:14:39 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E35B34D990B; Wed, 13 Jul 2022 13:14:36 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Freysteinn Alfredsson <freysteinn.alfredsson@kau.se>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [RFC PATCH 08/17] bpf: Add helpers to dequeue from a PIFO map
Date:   Wed, 13 Jul 2022 13:14:16 +0200
Message-Id: <20220713111430.134810-9-toke@redhat.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220713111430.134810-1-toke@redhat.com>
References: <20220713111430.134810-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a new helper to dequeue a packet from a PIFO map,
bpf_packet_dequeue(). The helper returns a refcounted pointer to the packet
dequeued from the map; the reference must be released either by dropping
the packet (using bpf_packet_drop()), or by returning it to the caller.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/uapi/linux/bpf.h       | 19 +++++++++++++++
 kernel/bpf/verifier.c          | 13 +++++++---
 net/core/filter.c              | 43 +++++++++++++++++++++++++++++++++-
 tools/include/uapi/linux/bpf.h | 19 +++++++++++++++
 4 files changed, 90 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 974fb5882305..d44382644391 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5341,6 +5341,23 @@ union bpf_attr {
  *		**-EACCES** if the SYN cookie is not valid.
  *
  *		**-EPROTONOSUPPORT** if CONFIG_IPV6 is not builtin.
+ *
+ * long bpf_packet_dequeue(void *ctx, struct bpf_map *map, u64 flags, u64 *rank)
+ *	Description
+ *		Dequeue the packet at the head of the PIFO in *map* and return a pointer
+ *		to the packet (or NULL if the PIFO is empty).
+ *	Return
+ *		On success, a pointer to the packet, or NULL if the PIFO is empty. The
+ *		packet pointer must be freed using *bpf_packet_drop()* or returning
+ *		the packet pointer. The *rank* pointer will be set to the rank of
+ *		the dequeued packet on success, or a negative error code on error.
+ *
+ * long bpf_packet_drop(void *ctx, void *pkt)
+ *	Description
+ *		Drop *pkt*, which must be a reference previously returned by
+ *		*bpf_packet_dequeue()* (and checked to not be NULL).
+ *	Return
+ *		This always succeeds and returns zero.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5551,6 +5568,8 @@ union bpf_attr {
 	FN(tcp_raw_gen_syncookie_ipv6),	\
 	FN(tcp_raw_check_syncookie_ipv4),	\
 	FN(tcp_raw_check_syncookie_ipv6),	\
+	FN(packet_dequeue),		\
+	FN(packet_drop),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index e3662460a095..68f98d76bc78 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -483,7 +483,8 @@ static bool may_be_acquire_function(enum bpf_func_id func_id)
 		func_id == BPF_FUNC_sk_lookup_udp ||
 		func_id == BPF_FUNC_skc_lookup_tcp ||
 		func_id == BPF_FUNC_map_lookup_elem ||
-	        func_id == BPF_FUNC_ringbuf_reserve;
+		func_id == BPF_FUNC_ringbuf_reserve ||
+		func_id == BPF_FUNC_packet_dequeue;
 }
 
 static bool is_acquire_function(enum bpf_func_id func_id,
@@ -495,7 +496,8 @@ static bool is_acquire_function(enum bpf_func_id func_id,
 	    func_id == BPF_FUNC_sk_lookup_udp ||
 	    func_id == BPF_FUNC_skc_lookup_tcp ||
 	    func_id == BPF_FUNC_ringbuf_reserve ||
-	    func_id == BPF_FUNC_kptr_xchg)
+	    func_id == BPF_FUNC_kptr_xchg ||
+	    func_id == BPF_FUNC_packet_dequeue)
 		return true;
 
 	if (func_id == BPF_FUNC_map_lookup_elem &&
@@ -6276,7 +6278,8 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 			goto error;
 		break;
 	case BPF_MAP_TYPE_PIFO_XDP:
-		if (func_id != BPF_FUNC_redirect_map)
+		if (func_id != BPF_FUNC_redirect_map &&
+		    func_id != BPF_FUNC_packet_dequeue)
 			goto error;
 		break;
 	default:
@@ -6385,6 +6388,10 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 		if (map->map_type != BPF_MAP_TYPE_TASK_STORAGE)
 			goto error;
 		break;
+	case BPF_FUNC_packet_dequeue:
+		if (map->map_type != BPF_MAP_TYPE_PIFO_XDP)
+			goto error;
+		break;
 	default:
 		break;
 	}
diff --git a/net/core/filter.c b/net/core/filter.c
index 30bd3a6aedab..893b75515859 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4430,6 +4430,40 @@ static const struct bpf_func_proto bpf_xdp_redirect_map_proto = {
 	.arg3_type      = ARG_ANYTHING,
 };
 
+BTF_ID_LIST_SINGLE(xdp_md_btf_ids, struct, xdp_md)
+
+BPF_CALL_4(bpf_packet_dequeue, struct dequeue_data *, ctx, struct bpf_map *, map,
+	   u64, flags, u64 *, rank)
+{
+	return (unsigned long)pifo_map_dequeue(map, flags, rank);
+}
+
+static const struct bpf_func_proto bpf_packet_dequeue_proto = {
+	.func           = bpf_packet_dequeue,
+	.gpl_only       = false,
+	.ret_type       = RET_PTR_TO_BTF_ID_OR_NULL,
+	.ret_btf_id	= xdp_md_btf_ids,
+	.arg1_type      = ARG_PTR_TO_CTX,
+	.arg2_type      = ARG_CONST_MAP_PTR,
+	.arg3_type      = ARG_ANYTHING,
+	.arg4_type      = ARG_PTR_TO_LONG,
+};
+
+BPF_CALL_2(bpf_packet_drop, struct dequeue_data *, ctx, struct xdp_frame *, pkt)
+{
+	xdp_return_frame(pkt);
+	return 0;
+}
+
+static const struct bpf_func_proto bpf_packet_drop_proto = {
+	.func           = bpf_packet_drop,
+	.gpl_only       = false,
+	.ret_type       = RET_INTEGER,
+	.arg1_type      = ARG_PTR_TO_CTX,
+	.arg2_type      = ARG_PTR_TO_BTF_ID | OBJ_RELEASE,
+	.arg2_btf_id	= xdp_md_btf_ids,
+};
+
 static unsigned long bpf_skb_copy(void *dst_buff, const void *skb,
 				  unsigned long off, unsigned long len)
 {
@@ -8065,7 +8099,14 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 static const struct bpf_func_proto *
 dequeue_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
-	return bpf_base_func_proto(func_id);
+	switch (func_id) {
+	case BPF_FUNC_packet_dequeue:
+		return &bpf_packet_dequeue_proto;
+	case BPF_FUNC_packet_drop:
+		return &bpf_packet_drop_proto;
+	default:
+		return bpf_base_func_proto(func_id);
+	}
 }
 
 const struct bpf_func_proto bpf_sock_map_update_proto __weak;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 4dd8a563f85d..1dab68a89e18 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5341,6 +5341,23 @@ union bpf_attr {
  *		**-EACCES** if the SYN cookie is not valid.
  *
  *		**-EPROTONOSUPPORT** if CONFIG_IPV6 is not builtin.
+ *
+ * long bpf_packet_dequeue(void *ctx, struct bpf_map *map, u64 flags, u64 *rank)
+ *	Description
+ *		Dequeue the packet at the head of the PIFO in *map* and return a pointer
+ *		to the packet (or NULL if the PIFO is empty).
+ *	Return
+ *		On success, a pointer to the packet, or NULL if the PIFO is empty. The
+ *		packet pointer must be freed using *bpf_packet_drop()* or returning
+ *		the packet pointer. The *rank* pointer will be set to the rank of
+ *		the dequeued packet on success, or a negative error code on error.
+ *
+ * long bpf_packet_drop(void *ctx, void *pkt)
+ *	Description
+ *		Drop *pkt*, which must be a reference previously returned by
+ *		*bpf_packet_dequeue()* (and checked to not be NULL).
+ *	Return
+ *		This always succeeds and returns zero.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5551,6 +5568,8 @@ union bpf_attr {
 	FN(tcp_raw_gen_syncookie_ipv6),	\
 	FN(tcp_raw_check_syncookie_ipv4),	\
 	FN(tcp_raw_check_syncookie_ipv6),	\
+	FN(packet_dequeue),		\
+	FN(packet_drop),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.37.0

