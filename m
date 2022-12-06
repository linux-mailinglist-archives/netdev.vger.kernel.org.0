Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 549DD643B6F
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 03:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233881AbiLFCqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 21:46:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231923AbiLFCqB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 21:46:01 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1265C1CFCA
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 18:45:59 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id p7-20020a631e47000000b0047691854a86so11255031pgm.16
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 18:45:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2s5tkfUtrjY9e7dgcwIr7AZZzwkdx7V7QVbuyAt4CHQ=;
        b=WRTw0F739LQtFI0x9DzUVTTdXm/HtHGw+r0P81NoDmBvgkzeQI/gamFmmCTPvFs+mL
         p1TDW2fVOxYhqj0yH9/sfsiF6X73l4Dqxl1R0hDafoMO7nho/QTf9Nvi1yRdf6hdBmsO
         757K6tY7KcKC5GVphURQCJ98xhraMqBDwx/MIr+9Q41kMr2dmfPOw0+fCyE7y6O/ZhtG
         j24t0oiNUxr96WpMYJ6Nm+tjpVe7FwVnK69bKa85aItVum7Syilmy8tE8UXZQxjbX/WB
         Pk+5jN5psTlZa9ISciEBY+Hc14yy9iZmxVn0Ep9wzXdmBsccghYMOSllqCYcdoLB6XeG
         dxLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2s5tkfUtrjY9e7dgcwIr7AZZzwkdx7V7QVbuyAt4CHQ=;
        b=hmpGRXj+0UHeCg7r74FMXk3ucQN23cPqYosGrPzDZ1Ul+eW1ms1sbcwGu4pnfue7N3
         eugj1uoKbKQm0FG9yKvQZi/EJwZyQVYiaEEpMmOMOCVJj28edIEtRSXx+GeX8voMjpuv
         eJh5fR8cjyni/s4Aq9rdiFYFfGleMvu5USubWkkT7WeAdxOLCAHC+Mrm10ly+jTGDX+N
         KIeaLn7JC50jY+DzFBwzBZgfdnvdcmGAmxEadf6uZQZWibnOJZ5gFy0Ab9Qwjf6vhZdZ
         XjAJvGUKyth+6bI5Mg1nRUg/wqDPvZtf1c/ZqpdU8F1oLhic7SB6uewg3BX59MJt27rq
         71Eg==
X-Gm-Message-State: ANoB5pnDnuJxOKw6kX17HMClzB/EYglvOFmgc99rIGKGWbwaFC4MbSlQ
        NtYwDaRVMYuMrt26oVPhKfoMDo8=
X-Google-Smtp-Source: AA0mqf4xLGWgxfXypfdIFWbf+3hvHoAG6gf6hajKjfhPNo1co8iABwJeQa0IpP3eboR/MKY2dSAd0u8=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6a00:2918:b0:576:386d:8db1 with SMTP id
 cg24-20020a056a00291800b00576386d8db1mr21330091pfb.50.1670294759061; Mon, 05
 Dec 2022 18:45:59 -0800 (PST)
Date:   Mon,  5 Dec 2022 18:45:44 -0800
In-Reply-To: <20221206024554.3826186-1-sdf@google.com>
Mime-Version: 1.0
References: <20221206024554.3826186-1-sdf@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221206024554.3826186-3-sdf@google.com>
Subject: [PATCH bpf-next v3 02/12] bpf: Rename bpf_{prog,map}_is_dev_bound to is_offloaded
From:   Stanislav Fomichev <sdf@google.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF offloading infra will be reused to implement
bound-but-not-offloaded bpf programs. Rename existing
helpers for clarity. No functional changes.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Anatoly Burakov <anatoly.burakov@intel.com>
Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: Maryam Tahhan <mtahhan@redhat.com>
Cc: xdp-hints@xdp-project.net
Cc: netdev@vger.kernel.org

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/linux/bpf.h   |  8 ++++----
 kernel/bpf/core.c     |  4 ++--
 kernel/bpf/offload.c  |  4 ++--
 kernel/bpf/syscall.c  | 22 +++++++++++-----------
 kernel/bpf/verifier.c | 18 +++++++++---------
 net/core/dev.c        |  2 +-
 net/core/filter.c     |  2 +-
 7 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 4920ac252754..d5d479dae118 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2481,12 +2481,12 @@ void unpriv_ebpf_notify(int new_state);
 #if defined(CONFIG_NET) && defined(CONFIG_BPF_SYSCALL)
 int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr);
 
-static inline bool bpf_prog_is_dev_bound(const struct bpf_prog_aux *aux)
+static inline bool bpf_prog_is_offloaded(const struct bpf_prog_aux *aux)
 {
 	return aux->offload_requested;
 }
 
-static inline bool bpf_map_is_dev_bound(struct bpf_map *map)
+static inline bool bpf_map_is_offloaded(struct bpf_map *map)
 {
 	return unlikely(map->ops == &bpf_map_offload_ops);
 }
@@ -2513,12 +2513,12 @@ static inline int bpf_prog_offload_init(struct bpf_prog *prog,
 	return -EOPNOTSUPP;
 }
 
-static inline bool bpf_prog_is_dev_bound(struct bpf_prog_aux *aux)
+static inline bool bpf_prog_is_offloaded(struct bpf_prog_aux *aux)
 {
 	return false;
 }
 
-static inline bool bpf_map_is_dev_bound(struct bpf_map *map)
+static inline bool bpf_map_is_offloaded(struct bpf_map *map)
 {
 	return false;
 }
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 2e57fc839a5c..641ab412ad7e 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2183,7 +2183,7 @@ struct bpf_prog *bpf_prog_select_runtime(struct bpf_prog *fp, int *err)
 	 * valid program, which in this case would simply not
 	 * be JITed, but falls back to the interpreter.
 	 */
-	if (!bpf_prog_is_dev_bound(fp->aux)) {
+	if (!bpf_prog_is_offloaded(fp->aux)) {
 		*err = bpf_prog_alloc_jited_linfo(fp);
 		if (*err)
 			return fp;
@@ -2554,7 +2554,7 @@ static void bpf_prog_free_deferred(struct work_struct *work)
 #endif
 	bpf_free_used_maps(aux);
 	bpf_free_used_btfs(aux);
-	if (bpf_prog_is_dev_bound(aux))
+	if (bpf_prog_is_offloaded(aux))
 		bpf_prog_offload_destroy(aux->prog);
 #ifdef CONFIG_PERF_EVENTS
 	if (aux->prog->has_callchain_buf)
diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
index 13e4efc971e6..f5769a8ecbee 100644
--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -549,7 +549,7 @@ static bool __bpf_offload_dev_match(struct bpf_prog *prog,
 	struct bpf_offload_netdev *ondev1, *ondev2;
 	struct bpf_prog_offload *offload;
 
-	if (!bpf_prog_is_dev_bound(prog->aux))
+	if (!bpf_prog_is_offloaded(prog->aux))
 		return false;
 
 	offload = prog->aux->offload;
@@ -581,7 +581,7 @@ bool bpf_offload_prog_map_match(struct bpf_prog *prog, struct bpf_map *map)
 	struct bpf_offloaded_map *offmap;
 	bool ret;
 
-	if (!bpf_map_is_dev_bound(map))
+	if (!bpf_map_is_offloaded(map))
 		return bpf_map_offload_neutral(map);
 	offmap = map_to_offmap(map);
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 35972afb6850..13bc96035116 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -181,7 +181,7 @@ static int bpf_map_update_value(struct bpf_map *map, struct file *map_file,
 	int err;
 
 	/* Need to create a kthread, thus must support schedule */
-	if (bpf_map_is_dev_bound(map)) {
+	if (bpf_map_is_offloaded(map)) {
 		return bpf_map_offload_update_elem(map, key, value, flags);
 	} else if (map->map_type == BPF_MAP_TYPE_CPUMAP ||
 		   map->map_type == BPF_MAP_TYPE_STRUCT_OPS) {
@@ -238,7 +238,7 @@ static int bpf_map_copy_value(struct bpf_map *map, void *key, void *value,
 	void *ptr;
 	int err;
 
-	if (bpf_map_is_dev_bound(map))
+	if (bpf_map_is_offloaded(map))
 		return bpf_map_offload_lookup_elem(map, key, value);
 
 	bpf_disable_instrumentation();
@@ -1483,7 +1483,7 @@ static int map_delete_elem(union bpf_attr *attr, bpfptr_t uattr)
 		goto err_put;
 	}
 
-	if (bpf_map_is_dev_bound(map)) {
+	if (bpf_map_is_offloaded(map)) {
 		err = bpf_map_offload_delete_elem(map, key);
 		goto out;
 	} else if (IS_FD_PROG_ARRAY(map) ||
@@ -1547,7 +1547,7 @@ static int map_get_next_key(union bpf_attr *attr)
 	if (!next_key)
 		goto free_key;
 
-	if (bpf_map_is_dev_bound(map)) {
+	if (bpf_map_is_offloaded(map)) {
 		err = bpf_map_offload_get_next_key(map, key, next_key);
 		goto out;
 	}
@@ -1605,7 +1605,7 @@ int generic_map_delete_batch(struct bpf_map *map,
 				   map->key_size))
 			break;
 
-		if (bpf_map_is_dev_bound(map)) {
+		if (bpf_map_is_offloaded(map)) {
 			err = bpf_map_offload_delete_elem(map, key);
 			break;
 		}
@@ -1851,7 +1851,7 @@ static int map_lookup_and_delete_elem(union bpf_attr *attr)
 		   map->map_type == BPF_MAP_TYPE_PERCPU_HASH ||
 		   map->map_type == BPF_MAP_TYPE_LRU_HASH ||
 		   map->map_type == BPF_MAP_TYPE_LRU_PERCPU_HASH) {
-		if (!bpf_map_is_dev_bound(map)) {
+		if (!bpf_map_is_offloaded(map)) {
 			bpf_disable_instrumentation();
 			rcu_read_lock();
 			err = map->ops->map_lookup_and_delete_elem(map, key, value, attr->flags);
@@ -1944,7 +1944,7 @@ static int find_prog_type(enum bpf_prog_type type, struct bpf_prog *prog)
 	if (!ops)
 		return -EINVAL;
 
-	if (!bpf_prog_is_dev_bound(prog->aux))
+	if (!bpf_prog_is_offloaded(prog->aux))
 		prog->aux->ops = ops;
 	else
 		prog->aux->ops = &bpf_offload_prog_ops;
@@ -2255,7 +2255,7 @@ bool bpf_prog_get_ok(struct bpf_prog *prog,
 
 	if (prog->type != *attach_type)
 		return false;
-	if (bpf_prog_is_dev_bound(prog->aux) && !attach_drv)
+	if (bpf_prog_is_offloaded(prog->aux) && !attach_drv)
 		return false;
 
 	return true;
@@ -2598,7 +2598,7 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 	atomic64_set(&prog->aux->refcnt, 1);
 	prog->gpl_compatible = is_gpl ? 1 : 0;
 
-	if (bpf_prog_is_dev_bound(prog->aux)) {
+	if (bpf_prog_is_offloaded(prog->aux)) {
 		err = bpf_prog_offload_init(prog, attr);
 		if (err)
 			goto free_prog_sec;
@@ -3997,7 +3997,7 @@ static int bpf_prog_get_info_by_fd(struct file *file,
 			return -EFAULT;
 	}
 
-	if (bpf_prog_is_dev_bound(prog->aux)) {
+	if (bpf_prog_is_offloaded(prog->aux)) {
 		err = bpf_prog_offload_info_fill(&info, prog);
 		if (err)
 			return err;
@@ -4225,7 +4225,7 @@ static int bpf_map_get_info_by_fd(struct file *file,
 	}
 	info.btf_vmlinux_value_type_id = map->btf_vmlinux_value_type_id;
 
-	if (bpf_map_is_dev_bound(map)) {
+	if (bpf_map_is_offloaded(map)) {
 		err = bpf_map_offload_info_fill(&info, map);
 		if (err)
 			return err;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 1d51bd9596da..fc4e313a4d2e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13648,7 +13648,7 @@ static int do_check(struct bpf_verifier_env *env)
 			env->prev_log_len = env->log.len_used;
 		}
 
-		if (bpf_prog_is_dev_bound(env->prog->aux)) {
+		if (bpf_prog_is_offloaded(env->prog->aux)) {
 			err = bpf_prog_offload_verify_insn(env, env->insn_idx,
 							   env->prev_insn_idx);
 			if (err)
@@ -14128,7 +14128,7 @@ static int check_map_prog_compatibility(struct bpf_verifier_env *env,
 		}
 	}
 
-	if ((bpf_prog_is_dev_bound(prog->aux) || bpf_map_is_dev_bound(map)) &&
+	if ((bpf_prog_is_offloaded(prog->aux) || bpf_map_is_offloaded(map)) &&
 	    !bpf_offload_prog_map_match(prog, map)) {
 		verbose(env, "offload device mismatch between prog and map\n");
 		return -EINVAL;
@@ -14609,7 +14609,7 @@ static int verifier_remove_insns(struct bpf_verifier_env *env, u32 off, u32 cnt)
 	unsigned int orig_prog_len = env->prog->len;
 	int err;
 
-	if (bpf_prog_is_dev_bound(env->prog->aux))
+	if (bpf_prog_is_offloaded(env->prog->aux))
 		bpf_prog_offload_remove_insns(env, off, cnt);
 
 	err = bpf_remove_insns(env->prog, off, cnt);
@@ -14690,7 +14690,7 @@ static void opt_hard_wire_dead_code_branches(struct bpf_verifier_env *env)
 		else
 			continue;
 
-		if (bpf_prog_is_dev_bound(env->prog->aux))
+		if (bpf_prog_is_offloaded(env->prog->aux))
 			bpf_prog_offload_replace_insn(env, i, &ja);
 
 		memcpy(insn, &ja, sizeof(ja));
@@ -14873,7 +14873,7 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 		}
 	}
 
-	if (bpf_prog_is_dev_bound(env->prog->aux))
+	if (bpf_prog_is_offloaded(env->prog->aux))
 		return 0;
 
 	insn = env->prog->insnsi + delta;
@@ -15273,7 +15273,7 @@ static int fixup_call_args(struct bpf_verifier_env *env)
 	int err = 0;
 
 	if (env->prog->jit_requested &&
-	    !bpf_prog_is_dev_bound(env->prog->aux)) {
+	    !bpf_prog_is_offloaded(env->prog->aux)) {
 		err = jit_subprogs(env);
 		if (err == 0)
 			return 0;
@@ -16747,7 +16747,7 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr, bpfptr_t uattr)
 	if (ret < 0)
 		goto skip_full_check;
 
-	if (bpf_prog_is_dev_bound(env->prog->aux)) {
+	if (bpf_prog_is_offloaded(env->prog->aux)) {
 		ret = bpf_prog_offload_verifier_prep(env->prog);
 		if (ret)
 			goto skip_full_check;
@@ -16760,7 +16760,7 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr, bpfptr_t uattr)
 	ret = do_check_subprogs(env);
 	ret = ret ?: do_check_main(env);
 
-	if (ret == 0 && bpf_prog_is_dev_bound(env->prog->aux))
+	if (ret == 0 && bpf_prog_is_offloaded(env->prog->aux))
 		ret = bpf_prog_offload_finalize(env);
 
 skip_full_check:
@@ -16795,7 +16795,7 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr, bpfptr_t uattr)
 	/* do 32-bit optimization after insn patching has done so those patched
 	 * insns could be handled correctly.
 	 */
-	if (ret == 0 && !bpf_prog_is_dev_bound(env->prog->aux)) {
+	if (ret == 0 && !bpf_prog_is_offloaded(env->prog->aux)) {
 		ret = opt_subreg_zext_lo32_rnd_hi32(env, attr);
 		env->prog->aux->verifier_zext = bpf_jit_needs_zext() ? !ret
 								     : false;
diff --git a/net/core/dev.c b/net/core/dev.c
index 7627c475d991..5b221568dfd4 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9224,7 +9224,7 @@ static int dev_xdp_attach(struct net_device *dev, struct netlink_ext_ack *extack
 			NL_SET_ERR_MSG(extack, "Native and generic XDP can't be active at the same time");
 			return -EEXIST;
 		}
-		if (!offload && bpf_prog_is_dev_bound(new_prog->aux)) {
+		if (!offload && bpf_prog_is_offloaded(new_prog->aux)) {
 			NL_SET_ERR_MSG(extack, "Using device-bound program without HW_MODE flag is not supported");
 			return -EINVAL;
 		}
diff --git a/net/core/filter.c b/net/core/filter.c
index 8607136b6e2c..d89c30ba2623 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8719,7 +8719,7 @@ static bool xdp_is_valid_access(int off, int size,
 	}
 
 	if (type == BPF_WRITE) {
-		if (bpf_prog_is_dev_bound(prog->aux)) {
+		if (bpf_prog_is_offloaded(prog->aux)) {
 			switch (off) {
 			case offsetof(struct xdp_md, rx_queue_index):
 				return __is_valid_xdp_access(off, size);
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

