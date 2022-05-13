Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F4024525BB6
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 08:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377412AbiEMGkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 02:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377409AbiEMGkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 02:40:18 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB7302A1FF5
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 23:40:15 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id qe3-20020a17090b4f8300b001dc24e4da73so7281631pjb.1
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 23:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LaI3WoJGVt28cor8mzjFeKlCPw870xKzF3pmeMk/wKY=;
        b=1gJPWxMu6fAn74+52mUuSodGzlFvKFuEgMUqbloqp59WvJjb6xTEweI2Z2zHtrcM1s
         XcCoA/VNkH3+xi6merS67PIjAx7vGEu+Ex8xTCBKXrZELtYoEjkf/2zZn2fi480yInKQ
         8ft4R9UOMFubrtb3EOsLOl3kl482io/vmLoWYE3Tq4/ucIVlF6WW0iGUISquIcL4WJMu
         LEktIpp2UFH3rkD/ZJ43/BMYlcTTA1w6vJaT6uDYk0vssCH0/LIv5y8Vq092OykSImZ5
         2pJnrI0MV18GSVxlkYCW2u49VYOjA0PjdrLpbyV6BxixRRZ0g32XxTDJikcYWWetrg6z
         HcCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LaI3WoJGVt28cor8mzjFeKlCPw870xKzF3pmeMk/wKY=;
        b=sI44pPT9Mpfst3YcJM8liNAYZrnXmtGQGZC/fc8cfNPuCXgoXkSHd1a20v0Lgez+F9
         YjcWWBPVsyFGwJr+vESEsznl61ucX5qHjWWyWp9y6C9mB0dyEKKwJ6H7FoCyouKczw+S
         SXqrQ1w9v/hP+815w4T/Rg5ONDHIeTPvwxEL9UgoQRIZYalOncu97OGuJHCQg7KIKc/6
         Luduia60CT59Dy/ZO6u+HUrpgZgVJ5BL86QK4Q8XTfz988OGaF5Qw6fgZVUoLEBP9xvv
         K+q5hf3Py7zwVZTsIncTZw32pU4wnAzvE/4igKGVKnxEeV8OJzCRfzvfY/Iljwajydlo
         Vo2A==
X-Gm-Message-State: AOAM531i4ec9YTpDTWANCjp4i1yCVhWNaXDRZpQOrf3NGPf3IScaetj5
        WISkuwvmVwubnNcFt+xN8nkFgjQju0enLrOH
X-Google-Smtp-Source: ABdhPJwhRI5OXkfDJBHmwcDGLkf0atj9iTbEFxYaDKmfJTbmm+P0hMhc+5y2dD73KgbEZAHWFS4DLg==
X-Received: by 2002:a17:902:c7cb:b0:15e:e0d0:c020 with SMTP id r11-20020a170902c7cb00b0015ee0d0c020mr3207389pla.51.1652424015088;
        Thu, 12 May 2022 23:40:15 -0700 (PDT)
Received: from C02F52LSML85.bytedance.net ([139.177.225.225])
        by smtp.gmail.com with ESMTPSA id 185-20020a6204c2000000b0050dc76281d8sm934990pfe.178.2022.05.12.23.40.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 May 2022 23:40:14 -0700 (PDT)
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
Subject: [PATCH bpf-next v3 1/2] bpf: add bpf_map_lookup_percpu_elem for percpu map
Date:   Fri, 13 May 2022 14:39:51 +0800
Message-Id: <20220513063952.41794-2-zhoufeng.zf@bytedance.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220513063952.41794-1-zhoufeng.zf@bytedance.com>
References: <20220513063952.41794-1-zhoufeng.zf@bytedance.com>
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
index 3ded8711457f..5061ccd8b2dc 100644
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

