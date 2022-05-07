Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D17051E3A6
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 04:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443958AbiEGCw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 22:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243922AbiEGCw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 22:52:56 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC075EBE1
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 19:49:10 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id i1so9099970plg.7
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 19:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jiiIMtDdnC7GbPot76dL+87KG0oeoaodvbyjWhDNIDA=;
        b=fpa7NZs1sDGHMDnvRwRJqWR6qVZFRF0qGvDOGzjkfztgWwxK8y6pXb4pfsuX9/9shD
         rUaxa9uxxOOZCcJL0kvwW7s5vFJcZofa5SUhezsM+TN4+8HaHXbCVbGf/0gQjLgf5J0I
         n7VcrfKJ/aUCtqay9N7lTFKy12jk72VSwA9mTtgIRNghABd+nwvZ8OIjrkYQ5+685Ad9
         c6XA+AumK71ymOaRlyqovgP2fOW7Tfa7P6fGO3z187T6xAL5R5RIuEDspNZwy/JiQvUf
         AWUZRnCs6V2ONmlRo7HEVHr5k/eLBAQwtvf8bGzLD1ilU03GRfuIp4qI1VEYXy/0hHI3
         QxBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jiiIMtDdnC7GbPot76dL+87KG0oeoaodvbyjWhDNIDA=;
        b=76qOGhlc3BMGLKHB4OlHC6YM3HB7+c4oN3LWL4sXJDGFfAvYi7ZT4l3yl5ktNBpD4K
         ZX+7cDLe5WVBK++uFIzNpxrlHBtKLeuY1RjwgpktOcihy8OnY2uwU+UCOOJ55KhKAyb2
         fcnR1zuxpy/uirk5DB76qKnGa10Ghl+jg5lDxqvkfzNuvNTjXhKQlEo6CLf4j4FROkD0
         1SvehP/iDGxLvr8XxykIP4MKen4oz7FKbf8P4o9FekdyU9I63idy6XDb04VhH+EwhNPb
         CSPiTqIw0CoZbz4U/QefMkteDK4Xd81AblaDyXlkAQnw0RXeY9rdmQ981PXW6seb5VIy
         9dxw==
X-Gm-Message-State: AOAM530DKdulJ09MyGalfrs9thpxF/k/PwpNObFTXgqCML9x0mp3/Iwh
        WFR4+KZph2kJTgvy+FHncxE3mA==
X-Google-Smtp-Source: ABdhPJzbqgLzO8TYer6u2eYMMsu6Ei2HDCVPOv2W6rVKOJXSr5HuySVXJHN/BNEHpDWqT0ErND0LAg==
X-Received: by 2002:a17:902:e742:b0:15e:9a7b:24d5 with SMTP id p2-20020a170902e74200b0015e9a7b24d5mr6799971plf.139.1651891750148;
        Fri, 06 May 2022 19:49:10 -0700 (PDT)
Received: from localhost.localdomain ([139.177.225.235])
        by smtp.gmail.com with ESMTPSA id s82-20020a632c55000000b003c619f3d086sm4079143pgs.2.2022.05.06.19.49.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 May 2022 19:49:09 -0700 (PDT)
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
        zhoufeng.zf@bytedance.com
Subject: [PATCH bpf-next] bpf: add bpf_map_lookup_percpu_elem for percpu map
Date:   Sat,  7 May 2022 10:48:40 +0800
Message-Id: <20220507024840.42662-1-zhoufeng.zf@bytedance.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
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

Trace some functions, such as enqueue_task_fair, need to access the
corresponding cpu, not the current cpu, and bpf_map_lookup_elem percpu map
cannot do it. So add bpf_map_lookup_percpu_elem to accomplish it for
percpu_array_map, percpu_hash_map, lru_percpu_hash_map.

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
index be94833d390a..6b5cf5a90d73 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -89,6 +89,7 @@ struct bpf_map_ops {
 	int (*map_push_elem)(struct bpf_map *map, void *value, u64 flags);
 	int (*map_pop_elem)(struct bpf_map *map, void *value);
 	int (*map_peek_elem)(struct bpf_map *map, void *value);
+	void *(*map_lookup_percpu_elem)(struct bpf_map *map, void *key, u32 cpu);
 
 	/* funcs called by prog_array and perf_event_array map */
 	void *(*map_fd_get_ptr)(struct bpf_map *map, struct file *map_file,
@@ -2161,6 +2162,7 @@ extern const struct bpf_func_proto bpf_map_delete_elem_proto;
 extern const struct bpf_func_proto bpf_map_push_elem_proto;
 extern const struct bpf_func_proto bpf_map_pop_elem_proto;
 extern const struct bpf_func_proto bpf_map_peek_elem_proto;
+extern const struct bpf_func_proto bpf_map_lookup_percpu_elem_proto;
 
 extern const struct bpf_func_proto bpf_get_prandom_u32_proto;
 extern const struct bpf_func_proto bpf_get_smp_processor_id_proto;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 444fe6f1cf35..024fb9f319a8 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5154,6 +5154,14 @@ union bpf_attr {
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
@@ -5351,6 +5359,7 @@ union bpf_attr {
 	FN(skb_set_tstamp),		\
 	FN(ima_file_hash),		\
 	FN(kptr_xchg),			\
+	FN(map_lookup_percpu_elem),     \
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index b3bf31fd9458..71d9db976ab0 100644
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
index 3e00e62b2218..9c45b07dd5b6 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -2191,6 +2191,20 @@ static void *htab_percpu_map_lookup_elem(struct bpf_map *map, void *key)
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
@@ -2203,6 +2217,22 @@ static void *htab_lru_percpu_map_lookup_elem(struct bpf_map *map, void *key)
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
@@ -2292,6 +2322,7 @@ const struct bpf_map_ops htab_percpu_map_ops = {
 	.map_lookup_and_delete_elem = htab_percpu_map_lookup_and_delete_elem,
 	.map_update_elem = htab_percpu_map_update_elem,
 	.map_delete_elem = htab_map_delete_elem,
+	.map_lookup_percpu_elem = htab_percpu_map_lookup_percpu_elem,
 	.map_seq_show_elem = htab_percpu_map_seq_show_elem,
 	.map_set_for_each_callback_args = map_set_for_each_callback_args,
 	.map_for_each_callback = bpf_for_each_hash_elem,
@@ -2310,6 +2341,7 @@ const struct bpf_map_ops htab_lru_percpu_map_ops = {
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
index 813f6ee80419..67ac0b047caf 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6138,6 +6138,12 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
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
@@ -6751,7 +6757,8 @@ record_func_map(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
 	    func_id != BPF_FUNC_map_pop_elem &&
 	    func_id != BPF_FUNC_map_peek_elem &&
 	    func_id != BPF_FUNC_for_each_map_elem &&
-	    func_id != BPF_FUNC_redirect_map)
+	    func_id != BPF_FUNC_redirect_map &&
+	    func_id != BPF_FUNC_map_lookup_percpu_elem)
 		return 0;
 
 	if (map == NULL) {
@@ -13811,7 +13818,8 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 		     insn->imm == BPF_FUNC_map_pop_elem    ||
 		     insn->imm == BPF_FUNC_map_peek_elem   ||
 		     insn->imm == BPF_FUNC_redirect_map    ||
-		     insn->imm == BPF_FUNC_for_each_map_elem)) {
+		     insn->imm == BPF_FUNC_for_each_map_elem ||
+		     insn->imm == BPF_FUNC_map_lookup_percpu_elem)) {
 			aux = &env->insn_aux_data[i + delta];
 			if (bpf_map_ptr_poisoned(aux))
 				goto patch_call_imm;
@@ -13860,6 +13868,8 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 					      bpf_callback_t callback_fn,
 					      void *callback_ctx,
 					      u64 flags))NULL));
+			BUILD_BUG_ON(!__same_type(ops->map_lookup_percpu_elem,
+				     (void *(*)(struct bpf_map *map, void *key, u32 cpu))NULL));
 
 patch_map_ops_generic:
 			switch (insn->imm) {
@@ -13887,6 +13897,9 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 			case BPF_FUNC_for_each_map_elem:
 				insn->imm = BPF_CALL_IMM(ops->map_for_each_callback);
 				continue;
+			case BPF_FUNC_map_lookup_percpu_elem:
+				insn->imm = BPF_CALL_IMM(ops->map_lookup_percpu_elem);
+				continue;
 			}
 
 			goto patch_call_imm;
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index f15b826f9899..af4125407c20 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1182,6 +1182,8 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_map_pop_elem_proto;
 	case BPF_FUNC_map_peek_elem:
 		return &bpf_map_peek_elem_proto;
+	case BPF_FUNC_map_lookup_percpu_elem:
+		return &bpf_map_lookup_percpu_elem_proto;
 	case BPF_FUNC_ktime_get_ns:
 		return &bpf_ktime_get_ns_proto;
 	case BPF_FUNC_ktime_get_boot_ns:
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 444fe6f1cf35..024fb9f319a8 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5154,6 +5154,14 @@ union bpf_attr {
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
@@ -5351,6 +5359,7 @@ union bpf_attr {
 	FN(skb_set_tstamp),		\
 	FN(ima_file_hash),		\
 	FN(kptr_xchg),			\
+	FN(map_lookup_percpu_elem),     \
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.20.1

