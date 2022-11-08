Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF6146214F8
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 15:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235087AbiKHOHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 09:07:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235077AbiKHOHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 09:07:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD9169DE5
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 06:06:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667916367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xrFIBMqXX9h6pvecuxNnaKXU9eCfL4NHKAWPiOl9PKs=;
        b=hvtRPuKW7OBtipSeq53g5WiyArMgNlc3vQFp7t49DswaBIpWDX5mOQR62SEsBAYueEruyj
        STgv00v6RPT/xWvo8lmUPR5w7FkySx5Ntf/D9gfBxKLbj3bB9mUgyb0YmcWLpmzQsFCOv1
        EiyBPJ6XtWKHSIC1z+PWLobHLbOQ5Rk=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-214-nlUgQh1ZN8S12g4iCKxcmQ-1; Tue, 08 Nov 2022 09:06:06 -0500
X-MC-Unique: nlUgQh1ZN8S12g4iCKxcmQ-1
Received: by mail-ej1-f71.google.com with SMTP id nb1-20020a1709071c8100b007ae4083d6f5so5639147ejc.15
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 06:06:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xrFIBMqXX9h6pvecuxNnaKXU9eCfL4NHKAWPiOl9PKs=;
        b=Rxhru47UZAJFYVvemAQU22kVSflncLeUHxRfOYM7WaG2g5sQq33z25Z6alWudKHY/A
         tX6NH3j32gJw/SKiLuvcSs5ItEfy6ROQeUrdIGkIGz/wOHNDJqPpHjrY2LmFCVZzsR1s
         T50iKSFp9pehGNf3TDgrqb5AuU/AZvwdCvlDE6ijyjA3iyE690fjmcB1dhAA3Re+WA4X
         /FfOSLliZN0w0BYwVgOkhzH3BLfSj8JeYjXOcu9zfgedJ+DWrxBIaVQlf/jmPJ8EnyWe
         N8KXEmdBZbyCvLbNlxp0KxvVaFAfOoWutGGgKXSFedLX4D8k3wui7OSt73hHFbCpCi8m
         5YlQ==
X-Gm-Message-State: ACrzQf3vca04f0LTNc13jzS+6RDDJQGqfzdYuNxhplbRopaXMVpxwmvw
        7FOOeXnXpVgPOAGB188XIZwq7g1X2k7o3ie3iyi3arQObEouwdP5IecX+fsnVkrtroQiBBFGNnV
        Oz6jNZcllVGS6pURZ
X-Received: by 2002:a17:906:db0a:b0:781:f24:a782 with SMTP id xj10-20020a170906db0a00b007810f24a782mr53513532ejb.399.1667916364921;
        Tue, 08 Nov 2022 06:06:04 -0800 (PST)
X-Google-Smtp-Source: AMsMyM6FUzjrqav6a7ZobeEXWObV4PTUGcNxRWHoLlu6GN3MnIHnNXxESEiA0rdGuJqqpW2FS5S4Ww==
X-Received: by 2002:a17:906:db0a:b0:781:f24:a782 with SMTP id xj10-20020a170906db0a00b007810f24a782mr53513472ejb.399.1667916364399;
        Tue, 08 Nov 2022 06:06:04 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id cf20-20020a170906b2d400b007389c5a45f0sm4729629ejb.148.2022.11.08.06.06.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 06:06:04 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A45A378152F; Tue,  8 Nov 2022 15:06:03 +0100 (CET)
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
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v3 2/3] bpf: Expand map key argument of bpf_redirect_map to u64
Date:   Tue,  8 Nov 2022 15:06:00 +0100
Message-Id: <20221108140601.149971-3-toke@redhat.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108140601.149971-1-toke@redhat.com>
References: <20221108140601.149971-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For queueing packets in XDP we want to add a new redirect map type with
support for 64-bit indexes. To prepare fore this, expand the width of the
'key' argument to the bpf_redirect_map() helper. Since BPF registers are
always 64-bit, this should be safe to do after the fact.

Acked-by: Song Liu <song@kernel.org>
Reviewed-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/bpf.h      |  2 +-
 include/linux/filter.h   | 12 ++++++------
 include/uapi/linux/bpf.h |  2 +-
 kernel/bpf/cpumap.c      |  4 ++--
 kernel/bpf/devmap.c      |  4 ++--
 kernel/bpf/verifier.c    |  2 +-
 net/core/filter.c        |  4 ++--
 net/xdp/xskmap.c         |  4 ++--
 8 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 798aec816970..863a5db1e370 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -135,7 +135,7 @@ struct bpf_map_ops {
 	struct bpf_local_storage __rcu ** (*map_owner_storage_ptr)(void *owner);
 
 	/* Misc helpers.*/
-	int (*map_redirect)(struct bpf_map *map, u32 ifindex, u64 flags);
+	int (*map_redirect)(struct bpf_map *map, u64 key, u64 flags);
 
 	/* map_meta_equal must be implemented for maps that can be
 	 * used as an inner map.  It is a runtime check to ensure
diff --git a/include/linux/filter.h b/include/linux/filter.h
index efc42a6e3aed..e6c1c277ffdc 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -643,13 +643,13 @@ struct bpf_nh_params {
 };
 
 struct bpf_redirect_info {
-	u32 flags;
-	u32 tgt_index;
+	u64 tgt_index;
 	void *tgt_value;
 	struct bpf_map *map;
+	u32 flags;
+	u32 kern_flags;
 	u32 map_id;
 	enum bpf_map_type map_type;
-	u32 kern_flags;
 	struct bpf_nh_params nh;
 };
 
@@ -1504,7 +1504,7 @@ static inline bool bpf_sk_lookup_run_v6(struct net *net, int protocol,
 }
 #endif /* IS_ENABLED(CONFIG_IPV6) */
 
-static __always_inline int __bpf_xdp_redirect_map(struct bpf_map *map, u32 ifindex,
+static __always_inline int __bpf_xdp_redirect_map(struct bpf_map *map, u64 index,
 						  u64 flags, const u64 flag_mask,
 						  void *lookup_elem(struct bpf_map *map, u32 key))
 {
@@ -1515,7 +1515,7 @@ static __always_inline int __bpf_xdp_redirect_map(struct bpf_map *map, u32 ifind
 	if (unlikely(flags & ~(action_mask | flag_mask)))
 		return XDP_ABORTED;
 
-	ri->tgt_value = lookup_elem(map, ifindex);
+	ri->tgt_value = lookup_elem(map, index);
 	if (unlikely(!ri->tgt_value) && !(flags & BPF_F_BROADCAST)) {
 		/* If the lookup fails we want to clear out the state in the
 		 * redirect_info struct completely, so that if an eBPF program
@@ -1527,7 +1527,7 @@ static __always_inline int __bpf_xdp_redirect_map(struct bpf_map *map, u32 ifind
 		return flags & action_mask;
 	}
 
-	ri->tgt_index = ifindex;
+	ri->tgt_index = index;
 	ri->map_id = map->id;
 	ri->map_type = map->map_type;
 
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 94659f6b3395..9fd462e2f8c0 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2647,7 +2647,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * long bpf_redirect_map(struct bpf_map *map, u32 key, u64 flags)
+ * long bpf_redirect_map(struct bpf_map *map, u64 key, u64 flags)
  * 	Description
  * 		Redirect the packet to the endpoint referenced by *map* at
  * 		index *key*. Depending on its type, this *map* can contain
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index bb03fdba73bb..fa9dc11d5d64 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -664,9 +664,9 @@ static int cpu_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
 	return 0;
 }
 
-static int cpu_map_redirect(struct bpf_map *map, u32 ifindex, u64 flags)
+static int cpu_map_redirect(struct bpf_map *map, u64 index, u64 flags)
 {
-	return __bpf_xdp_redirect_map(map, ifindex, flags, 0,
+	return __bpf_xdp_redirect_map(map, index, flags, 0,
 				      __cpu_map_lookup_elem);
 }
 
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index f9a87dcc5535..d01e4c55b376 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -992,14 +992,14 @@ static int dev_map_hash_update_elem(struct bpf_map *map, void *key, void *value,
 					 map, key, value, map_flags);
 }
 
-static int dev_map_redirect(struct bpf_map *map, u32 ifindex, u64 flags)
+static int dev_map_redirect(struct bpf_map *map, u64 ifindex, u64 flags)
 {
 	return __bpf_xdp_redirect_map(map, ifindex, flags,
 				      BPF_F_BROADCAST | BPF_F_EXCLUDE_INGRESS,
 				      __dev_map_lookup_elem);
 }
 
-static int dev_hash_map_redirect(struct bpf_map *map, u32 ifindex, u64 flags)
+static int dev_hash_map_redirect(struct bpf_map *map, u64 ifindex, u64 flags)
 {
 	return __bpf_xdp_redirect_map(map, ifindex, flags,
 				      BPF_F_BROADCAST | BPF_F_EXCLUDE_INGRESS,
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index d3b75aa0c54d..f81b70a8d4ea 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -14366,7 +14366,7 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 			BUILD_BUG_ON(!__same_type(ops->map_peek_elem,
 				     (int (*)(struct bpf_map *map, void *value))NULL));
 			BUILD_BUG_ON(!__same_type(ops->map_redirect,
-				     (int (*)(struct bpf_map *map, u32 ifindex, u64 flags))NULL));
+				     (int (*)(struct bpf_map *map, u64 index, u64 flags))NULL));
 			BUILD_BUG_ON(!__same_type(ops->map_for_each_callback,
 				     (int (*)(struct bpf_map *map,
 					      bpf_callback_t callback_fn,
diff --git a/net/core/filter.c b/net/core/filter.c
index cb3b635e35be..d062f85794f7 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4414,10 +4414,10 @@ static const struct bpf_func_proto bpf_xdp_redirect_proto = {
 	.arg2_type      = ARG_ANYTHING,
 };
 
-BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u32, ifindex,
+BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u64, key,
 	   u64, flags)
 {
-	return map->ops->map_redirect(map, ifindex, flags);
+	return map->ops->map_redirect(map, key, flags);
 }
 
 static const struct bpf_func_proto bpf_xdp_redirect_map_proto = {
diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
index acc8e52a4f5f..771d0fa90ef5 100644
--- a/net/xdp/xskmap.c
+++ b/net/xdp/xskmap.c
@@ -231,9 +231,9 @@ static int xsk_map_delete_elem(struct bpf_map *map, void *key)
 	return 0;
 }
 
-static int xsk_map_redirect(struct bpf_map *map, u32 ifindex, u64 flags)
+static int xsk_map_redirect(struct bpf_map *map, u64 index, u64 flags)
 {
-	return __bpf_xdp_redirect_map(map, ifindex, flags, 0,
+	return __bpf_xdp_redirect_map(map, index, flags, 0,
 				      __xsk_map_lookup_elem);
 }
 
-- 
2.38.1

