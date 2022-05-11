Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0A73522FA4
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 11:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241391AbiEKJkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 05:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242161AbiEKJju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 05:39:50 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A1A8D6AA
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 02:39:34 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id r71so988735pgr.0
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 02:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SFmfnA2AbiUjenaFSQFfeVxUim1UStEwsd2Nq7u7lQc=;
        b=5pxZakyesz+ihTSJOSgKjwLeA9fDnvpNWUj2CFaPty5NiNw/Zu5C82YzYnzmyx9f+9
         dw65j8B5x+itrtuSqqV3EawpZl7bQ5yNRyXFO5KtaMo3IsYVZkBlSmWVGsNqj1TfixzB
         vfWhJCXcOE/b0bb0CO6gglCkrIhvINnEMPyz9yBhRXwMGFGOPKYwdGw7cEeyE/ufg54q
         BFn8VLj9SAHoCQXT5PSixvasV1ShMoElSmL7uUM4gne+a4eFvPtLpVcvVf3fbFLcg6PV
         lZKBOqPg8Esp4G7HprNZs4DM0puzKNfGoRwIsaddHGNDyfa6J8u8n5NPMzurkmrhhw5M
         gYzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SFmfnA2AbiUjenaFSQFfeVxUim1UStEwsd2Nq7u7lQc=;
        b=y6WMINSdstuu8jw1MGrV3ywTY2CMIGjT7vjYe8obLLWeHI5i5xPRJfHlP3YFmsP3N+
         NlqkXl6mWOgCU7d8OsNjh/9t8n0bHoEmZIiMWBWSCGPmvZ6Lmbwxk9mdcK+qpuaOxXDh
         0pTfr+EXx66x3y+ORqbU6zLDy8b6kbMfjy6PrCfGsP9Zk/Yx3zGlcyLubmx8hTogCU5I
         k2Y9MLhRfAoGI0mbi+8MByCnAmVds/vrE3TGcnOYG/X7b98G3Hjo+kxn4oZFrWuwBaP0
         Fh3m9CK7WpMmYE+jk03ogTNoH/k0do0o3XYckCU6FHKpc4PJBd5+v375xPrvrEEnnJ0K
         Ck/w==
X-Gm-Message-State: AOAM5312hXokBJlUJ08N2zygpkqSj02Cm4U7+QvtkLXd3QLAIoLYhru1
        i0DRQFJu/vfvEpctV75jaufmjywvksQUmXbT
X-Google-Smtp-Source: ABdhPJwW3IGSCcrYJ/1XbEHBYJqxzOoyiRU8vLFG1M+bzstHNRJm7gDlyW4hqc0W6L0ncrLYo5yuPg==
X-Received: by 2002:a63:4459:0:b0:39d:3808:7c84 with SMTP id t25-20020a634459000000b0039d38087c84mr20180990pgk.130.1652261973589;
        Wed, 11 May 2022 02:39:33 -0700 (PDT)
Received: from C02F52LSML85.bytedance.net ([139.177.225.241])
        by smtp.gmail.com with ESMTPSA id k4-20020aa790c4000000b0050dc76281cdsm1159834pfk.167.2022.05.11.02.39.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 May 2022 02:39:33 -0700 (PDT)
From:   Feng zhou <zhoufeng.zf@bytedance.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, rostedt@goodmis.org,
        mingo@redhat.com, jolsa@kernel.org, davemarchevsky@fb.com,
        joannekoong@fb.com, geliang.tang@suse.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, duanxiongchun@bytedance.com,
        songmuchun@bytedance.com, wangdongdong.6@bytedance.com,
        cong.wang@bytedance.com, zhouchengming@bytedance.com,
        zhoufeng.zf@bytedance.com, yosryahmed@google.com
Subject: [PATCH bpf-next v2 1/2] bpf: add bpf_map_lookup_percpu_elem for percpu map
Date:   Wed, 11 May 2022 17:38:53 +0800
Message-Id: <20220511093854.411-2-zhoufeng.zf@bytedance.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220511093854.411-1-zhoufeng.zf@bytedance.com>
References: <20220511093854.411-1-zhoufeng.zf@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Feng Zhou <zhoufeng.zf@bytedance.com>

Add new ebpf helpers bpf_map_lookup_percpu_elem.

The implementation method is relatively simple, refer to the implementation
method of map_lookup_elem of percpu map, increase the parameters of cpu, and
obtain it according to the specified cpu.

Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
---
 include/linux/bpf.h            |  2 ++
 include/uapi/linux/bpf.h       |  9 +++++++++
 kernel/bpf/arraymap.c          | 15 +++++++++++++++
 kernel/bpf/core.c              |  1 +
 kernel/bpf/hashtab.c           | 32 ++++++++++++++++++++++++++++++++
 kernel/bpf/helpers.c           | 18 ++++++++++++++++++
 kernel/bpf/verifier.c          | 17 +++++++++++++++--
 kernel/trace/bpf_trace.c       |  2 ++
 tools/include/uapi/linux/bpf.h |  9 +++++++++
 9 files changed, 103 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index aba7ded56436..be7fa3afa353 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -89,6 +89,7 @@ struct bpf_map_ops {
 	int (*map_push_elem)(struct bpf_map *map, void *value, u64 flags);
 	int (*map_pop_elem)(struct bpf_map *map, void *value);
 	int (*map_peek_elem)(struct bpf_map *map, void *value);
+	void *(*map_lookup_percpu_elem)(struct bpf_map *map, void *key, u32 cpu);
 
 	/* funcs called by prog_array and perf_event_array map */
 	void *(*map_fd_get_ptr)(struct bpf_map *map, struct file *map_file,
@@ -2184,6 +2185,7 @@ extern const struct bpf_func_proto bpf_map_delete_elem_proto;
 extern const struct bpf_func_proto bpf_map_push_elem_proto;
 extern const struct bpf_func_proto bpf_map_pop_elem_proto;
 extern const struct bpf_func_proto bpf_map_peek_elem_proto;
+extern const struct bpf_func_proto bpf_map_lookup_percpu_elem_proto;
 
 extern const struct bpf_func_proto bpf_get_prandom_u32_proto;
 extern const struct bpf_func_proto bpf_get_smp_processor_id_proto;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index bc7f89948f54..0210f85131b3 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5164,6 +5164,14 @@ union bpf_attr {
  *		if not NULL, is a reference which must be released using its
  *		corresponding release function, or moved into a BPF map before
  *		program exit.
+ *
+ * void *bpf_map_lookup_percpu_elem(struct bpf_map *map, const void *key, u32 cpu)
+ * 	Description
+ * 		Perform a lookup in *percpu map* for an entry associated to
+ * 		*key* on *cpu*.
+ * 	Return
+ * 		Map value associated to *key* on *cpu*, or **NULL** if no entry
+ * 		was found or *cpu* is invalid.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5361,6 +5369,7 @@ union bpf_attr {
 	FN(skb_set_tstamp),		\
 	FN(ima_file_hash),		\
 	FN(kptr_xchg),			\
+	FN(map_lookup_percpu_elem),     \
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 724613da6576..fe40d3b9458f 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -243,6 +243,20 @@ static void *percpu_array_map_lookup_elem(struct bpf_map *map, void *key)
 	return this_cpu_ptr(array->pptrs[index & array->index_mask]);
 }
 
+static void *percpu_array_map_lookup_percpu_elem(struct bpf_map *map, void *key, u32 cpu)
+{
+	struct bpf_array *array = container_of(map, struct bpf_array, map);
+	u32 index = *(u32 *)key;
+
+	if (cpu >= nr_cpu_ids)
+		return NULL;
+
+	if (unlikely(index >= array->map.max_entries))
+		return NULL;
+
+	return per_cpu_ptr(array->pptrs[index & array->index_mask], cpu);
+}
+
 int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value)
 {
 	struct bpf_array *array = container_of(map, struct bpf_array, map);
@@ -725,6 +739,7 @@ const struct bpf_map_ops percpu_array_map_ops = {
 	.map_lookup_elem = percpu_array_map_lookup_elem,
 	.map_update_elem = array_map_update_elem,
 	.map_delete_elem = array_map_delete_elem,
+	.map_lookup_percpu_elem = percpu_array_map_lookup_percpu_elem,
 	.map_seq_show_elem = percpu_array_map_seq_show_elem,
 	.map_check_btf = array_map_check_btf,
 	.map_lookup_batch = generic_map_lookup_batch,
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 13e9dbeeedf3..76f68d0a7ae8 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2619,6 +2619,7 @@ const struct bpf_func_proto bpf_map_delete_elem_proto __weak;
 const struct bpf_func_proto bpf_map_push_elem_proto __weak;
 const struct bpf_func_proto bpf_map_pop_elem_proto __weak;
 const struct bpf_func_proto bpf_map_peek_elem_proto __weak;
+const struct bpf_func_proto bpf_map_lookup_percpu_elem_proto __weak;
 const struct bpf_func_proto bpf_spin_lock_proto __weak;
 const struct bpf_func_proto bpf_spin_unlock_proto __weak;
 const struct bpf_func_proto bpf_jiffies64_proto __weak;
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 705841279d16..17fb69c0e0dc 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -2199,6 +2199,20 @@ static void *htab_percpu_map_lookup_elem(struct bpf_map *map, void *key)
 		return NULL;
 }
 
+static void *htab_percpu_map_lookup_percpu_elem(struct bpf_map *map, void *key, u32 cpu)
+{
+	struct htab_elem *l;
+
+	if (cpu >= nr_cpu_ids)
+		return NULL;
+
+	l = __htab_map_lookup_elem(map, key);
+	if (l)
+		return per_cpu_ptr(htab_elem_get_ptr(l, map->key_size), cpu);
+	else
+		return NULL;
+}
+
 static void *htab_lru_percpu_map_lookup_elem(struct bpf_map *map, void *key)
 {
 	struct htab_elem *l = __htab_map_lookup_elem(map, key);
@@ -2211,6 +2225,22 @@ static void *htab_lru_percpu_map_lookup_elem(struct bpf_map *map, void *key)
 	return NULL;
 }
 
+static void *htab_lru_percpu_map_lookup_percpu_elem(struct bpf_map *map, void *key, u32 cpu)
+{
+	struct htab_elem *l;
+
+	if (cpu >= nr_cpu_ids)
+		return NULL;
+
+	l = __htab_map_lookup_elem(map, key);
+	if (l) {
+		bpf_lru_node_set_ref(&l->lru_node);
+		return per_cpu_ptr(htab_elem_get_ptr(l, map->key_size), cpu);
+	}
+
+	return NULL;
+}
+
 int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value)
 {
 	struct htab_elem *l;
@@ -2300,6 +2330,7 @@ const struct bpf_map_ops htab_percpu_map_ops = {
 	.map_lookup_and_delete_elem = htab_percpu_map_lookup_and_delete_elem,
 	.map_update_elem = htab_percpu_map_update_elem,
 	.map_delete_elem = htab_map_delete_elem,
+	.map_lookup_percpu_elem = htab_percpu_map_lookup_percpu_elem,
 	.map_seq_show_elem = htab_percpu_map_seq_show_elem,
 	.map_set_for_each_callback_args = map_set_for_each_callback_args,
 	.map_for_each_callback = bpf_for_each_hash_elem,
@@ -2318,6 +2349,7 @@ const struct bpf_map_ops htab_lru_percpu_map_ops = {
 	.map_lookup_and_delete_elem = htab_lru_percpu_map_lookup_and_delete_elem,
 	.map_update_elem = htab_lru_percpu_map_update_elem,
 	.map_delete_elem = htab_lru_map_delete_elem,
+	.map_lookup_percpu_elem = htab_lru_percpu_map_lookup_percpu_elem,
 	.map_seq_show_elem = htab_percpu_map_seq_show_elem,
 	.map_set_for_each_callback_args = map_set_for_each_callback_args,
 	.map_for_each_callback = bpf_for_each_hash_elem,
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 3e709fed5306..d5f104a39092 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -119,6 +119,22 @@ const struct bpf_func_proto bpf_map_peek_elem_proto = {
 	.arg2_type	= ARG_PTR_TO_UNINIT_MAP_VALUE,
 };
 
+BPF_CALL_3(bpf_map_lookup_percpu_elem, struct bpf_map *, map, void *, key, u32, cpu)
+{
+	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_bh_held());
+	return (unsigned long) map->ops->map_lookup_percpu_elem(map, key, cpu);
+}
+
+const struct bpf_func_proto bpf_map_lookup_percpu_elem_proto = {
+	.func		= bpf_map_lookup_percpu_elem,
+	.gpl_only	= false,
+	.pkt_access	= true,
+	.ret_type	= RET_PTR_TO_MAP_VALUE_OR_NULL,
+	.arg1_type	= ARG_CONST_MAP_PTR,
+	.arg2_type	= ARG_PTR_TO_MAP_KEY,
+	.arg3_type	= ARG_ANYTHING,
+};
+
 const struct bpf_func_proto bpf_get_prandom_u32_proto = {
 	.func		= bpf_user_rnd_u32,
 	.gpl_only	= false,
@@ -1420,6 +1436,8 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 		return &bpf_map_pop_elem_proto;
 	case BPF_FUNC_map_peek_elem:
 		return &bpf_map_peek_elem_proto;
+	case BPF_FUNC_map_lookup_percpu_elem:
+		return &bpf_map_lookup_percpu_elem_proto;
 	case BPF_FUNC_get_prandom_u32:
 		return &bpf_get_prandom_u32_proto;
 	case BPF_FUNC_get_smp_processor_id:
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index c27fee73a2cb..05c1b6656824 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6137,6 +6137,12 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 		    map->map_type != BPF_MAP_TYPE_BLOOM_FILTER)
 			goto error;
 		break;
+	case BPF_FUNC_map_lookup_percpu_elem:
+		if (map->map_type != BPF_MAP_TYPE_PERCPU_ARRAY &&
+		    map->map_type != BPF_MAP_TYPE_PERCPU_HASH &&
+		    map->map_type != BPF_MAP_TYPE_LRU_PERCPU_HASH)
+			goto error;
+		break;
 	case BPF_FUNC_sk_storage_get:
 	case BPF_FUNC_sk_storage_delete:
 		if (map->map_type != BPF_MAP_TYPE_SK_STORAGE)
@@ -6750,7 +6756,8 @@ record_func_map(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
 	    func_id != BPF_FUNC_map_pop_elem &&
 	    func_id != BPF_FUNC_map_peek_elem &&
 	    func_id != BPF_FUNC_for_each_map_elem &&
-	    func_id != BPF_FUNC_redirect_map)
+	    func_id != BPF_FUNC_redirect_map &&
+	    func_id != BPF_FUNC_map_lookup_percpu_elem)
 		return 0;
 
 	if (map == NULL) {
@@ -13810,7 +13817,8 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 		     insn->imm == BPF_FUNC_map_pop_elem    ||
 		     insn->imm == BPF_FUNC_map_peek_elem   ||
 		     insn->imm == BPF_FUNC_redirect_map    ||
-		     insn->imm == BPF_FUNC_for_each_map_elem)) {
+		     insn->imm == BPF_FUNC_for_each_map_elem ||
+		     insn->imm == BPF_FUNC_map_lookup_percpu_elem)) {
 			aux = &env->insn_aux_data[i + delta];
 			if (bpf_map_ptr_poisoned(aux))
 				goto patch_call_imm;
@@ -13859,6 +13867,8 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 					      bpf_callback_t callback_fn,
 					      void *callback_ctx,
 					      u64 flags))NULL));
+			BUILD_BUG_ON(!__same_type(ops->map_lookup_percpu_elem,
+				     (void *(*)(struct bpf_map *map, void *key, u32 cpu))NULL));
 
 patch_map_ops_generic:
 			switch (insn->imm) {
@@ -13886,6 +13896,9 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 			case BPF_FUNC_for_each_map_elem:
 				insn->imm = BPF_CALL_IMM(ops->map_for_each_callback);
 				continue;
+			case BPF_FUNC_map_lookup_percpu_elem:
+				insn->imm = BPF_CALL_IMM(ops->map_lookup_percpu_elem);
+				continue;
 			}
 
 			goto patch_call_imm;
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 2eaac094caf8..7141ca8a1c2d 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1197,6 +1197,8 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_map_pop_elem_proto;
 	case BPF_FUNC_map_peek_elem:
 		return &bpf_map_peek_elem_proto;
+	case BPF_FUNC_map_lookup_percpu_elem:
+		return &bpf_map_lookup_percpu_elem_proto;
 	case BPF_FUNC_ktime_get_ns:
 		return &bpf_ktime_get_ns_proto;
 	case BPF_FUNC_ktime_get_boot_ns:
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index bc7f89948f54..0210f85131b3 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5164,6 +5164,14 @@ union bpf_attr {
  *		if not NULL, is a reference which must be released using its
  *		corresponding release function, or moved into a BPF map before
  *		program exit.
+ *
+ * void *bpf_map_lookup_percpu_elem(struct bpf_map *map, const void *key, u32 cpu)
+ * 	Description
+ * 		Perform a lookup in *percpu map* for an entry associated to
+ * 		*key* on *cpu*.
+ * 	Return
+ * 		Map value associated to *key* on *cpu*, or **NULL** if no entry
+ * 		was found or *cpu* is invalid.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5361,6 +5369,7 @@ union bpf_attr {
 	FN(skb_set_tstamp),		\
 	FN(ima_file_hash),		\
 	FN(kptr_xchg),			\
+	FN(map_lookup_percpu_elem),     \
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.20.1

