Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08330598980
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 19:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345188AbiHRQ7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345189AbiHRQ7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:59:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9DDF61105
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 09:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660841957;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cI4WemkxCdSKaQbKj6Ayz+wnZETuS5vJ0iFt5FUmQ1U=;
        b=Ww6W901PmRTbO0rmougtafNi5wK3ZCqhbEFdUD9foiF5C3W6/XlM0Qdt+fCe1OXUZg8x9F
        rzbUeP7zZcy+p5IsFw2eSaH1gp4DpFhGkloOsqxav4R4fiPyhiawGNo+3FcT+DoCjf7SO3
        R41jYgm199nH1JYudeqOG8Rot2PNx4c=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-159-yNKN-UtuMxquQqwqFyfabg-1; Thu, 18 Aug 2022 12:59:15 -0400
X-MC-Unique: yNKN-UtuMxquQqwqFyfabg-1
Received: by mail-ed1-f70.google.com with SMTP id q18-20020a056402519200b0043dd2ff50feso1266965edd.9
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 09:59:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=cI4WemkxCdSKaQbKj6Ayz+wnZETuS5vJ0iFt5FUmQ1U=;
        b=YSrmw8VyJXNcoYiazttSSI9DofH/BsXq21nH+5+jP3loghUwz/uSiXPRz26zmkF/qV
         mLY2NXSgBW83kUUQqtVsZLF9IPXSpv7stzS0Vzrvgx+Y6RrCB1/lNieCfJlKBUFBqzHg
         KOu0yzcAOVR02V/7KdJEh7x3AsZN8yHzf0Y6Sg15wDVDIs/C5h2Qp0V1nHvkXTYqsr90
         O3o3+l95cR4uszfIc90RpzgltfjVugiJPwkYkQPpgeefBcZxcfwG1lflVDNW/HiTe4ju
         IfH8Mg2Xd8YcGx6MAR4vEb4KS8qCJRF7EXBNIFPW2Qi+gsSJ6DOhZzTV2tZ8UmWJJKKO
         OdDg==
X-Gm-Message-State: ACgBeo0NYaX9QlSPFffIFMoWooq7/qTwwwB9hXXdHDkY/LI4IM2gKAkM
        uMWC2gYbmSAMA0Bdt3g6JG170x1BOU9wZMfYj1jgnx357RmSqBGXLv37lXHM6SDV21zaJadrblr
        DYScEgZ3xk8US+/pN
X-Received: by 2002:a05:6402:4414:b0:434:f58c:ee2e with SMTP id y20-20020a056402441400b00434f58cee2emr2951817eda.362.1660841952115;
        Thu, 18 Aug 2022 09:59:12 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5LBzsdDKLNn2zmBPXw0tBkX/L2HTSQ2cKD9jWvhghPRC2K+rUCuoyiDtWptkPo26v5iHQCfg==
X-Received: by 2002:a05:6402:4414:b0:434:f58c:ee2e with SMTP id y20-20020a056402441400b00434f58cee2emr2951757eda.362.1660841951269;
        Thu, 18 Aug 2022 09:59:11 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id cz11-20020a0564021cab00b0043d5ead65a6sm1456499edb.84.2022.08.18.09.59.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 09:59:10 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C78F155FA99; Thu, 18 Aug 2022 18:59:09 +0200 (CEST)
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
Subject: [PATCH bpf-next 2/3] bpf: Expand map key argument of bpf_redirect_map to u64
Date:   Thu, 18 Aug 2022 18:59:04 +0200
Message-Id: <20220818165906.64450-3-toke@redhat.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220818165906.64450-1-toke@redhat.com>
References: <20220818165906.64450-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
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
index a627a02cf8ab..9868dacce9c8 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -133,7 +133,7 @@ struct bpf_map_ops {
 	struct bpf_local_storage __rcu ** (*map_owner_storage_ptr)(void *owner);
 
 	/* Misc helpers.*/
-	int (*map_redirect)(struct bpf_map *map, u32 ifindex, u64 flags);
+	int (*map_redirect)(struct bpf_map *map, u64 key, u64 flags);
 
 	/* map_meta_equal must be implemented for maps that can be
 	 * used as an inner map.  It is a runtime check to ensure
diff --git a/include/linux/filter.h b/include/linux/filter.h
index a5f21dc3c432..bd47a3ed681a 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -637,13 +637,13 @@ struct bpf_nh_params {
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
 
@@ -1494,7 +1494,7 @@ static inline bool bpf_sk_lookup_run_v6(struct net *net, int protocol,
 }
 #endif /* IS_ENABLED(CONFIG_IPV6) */
 
-static __always_inline int __bpf_xdp_redirect_map(struct bpf_map *map, u32 ifindex,
+static __always_inline int __bpf_xdp_redirect_map(struct bpf_map *map, u64 index,
 						  u64 flags, const u64 flag_mask,
 						  void *lookup_elem(struct bpf_map *map, u32 key))
 {
@@ -1505,7 +1505,7 @@ static __always_inline int __bpf_xdp_redirect_map(struct bpf_map *map, u32 ifind
 	if (unlikely(flags & ~(action_mask | flag_mask)))
 		return XDP_ABORTED;
 
-	ri->tgt_value = lookup_elem(map, ifindex);
+	ri->tgt_value = lookup_elem(map, index);
 	if (unlikely(!ri->tgt_value) && !(flags & BPF_F_BROADCAST)) {
 		/* If the lookup fails we want to clear out the state in the
 		 * redirect_info struct completely, so that if an eBPF program
@@ -1517,7 +1517,7 @@ static __always_inline int __bpf_xdp_redirect_map(struct bpf_map *map, u32 ifind
 		return flags & action_mask;
 	}
 
-	ri->tgt_index = ifindex;
+	ri->tgt_index = index;
 	ri->map_id = map->id;
 	ri->map_type = map->map_type;
 
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 934a2a8beb87..525b7b07830b 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2610,7 +2610,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * long bpf_redirect_map(struct bpf_map *map, u32 key, u64 flags)
+ * long bpf_redirect_map(struct bpf_map *map, u64 key, u64 flags)
  * 	Description
  * 		Redirect the packet to the endpoint referenced by *map* at
  * 		index *key*. Depending on its type, this *map* can contain
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index b5ba34ddd4b6..39ed08a2bb52 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -668,9 +668,9 @@ static int cpu_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
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
index 2c1f8069f7b7..db9938fc8a3b 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -14197,7 +14197,7 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 			BUILD_BUG_ON(!__same_type(ops->map_peek_elem,
 				     (int (*)(struct bpf_map *map, void *value))NULL));
 			BUILD_BUG_ON(!__same_type(ops->map_redirect,
-				     (int (*)(struct bpf_map *map, u32 ifindex, u64 flags))NULL));
+				     (int (*)(struct bpf_map *map, u64 index, u64 flags))NULL));
 			BUILD_BUG_ON(!__same_type(ops->map_for_each_callback,
 				     (int (*)(struct bpf_map *map,
 					      bpf_callback_t callback_fn,
diff --git a/net/core/filter.c b/net/core/filter.c
index 5669248aff25..d68df8dc0c8a 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4408,10 +4408,10 @@ static const struct bpf_func_proto bpf_xdp_redirect_proto = {
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
2.37.2

