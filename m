Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFF77322B04
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 14:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232392AbhBWNAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 08:00:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232760AbhBWM7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 07:59:22 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A18A6C061786;
        Tue, 23 Feb 2021 04:58:42 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id t25so12307270pga.2;
        Tue, 23 Feb 2021 04:58:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dihGMqgCAhl6Z/n7/7U/oPTxicf4CzutJw8Ax83o2TQ=;
        b=bY6Wl3/7371EvQaFEbSUce0GL4jOKN8Q1DK1MIcQsjvy1Ww349JwtEOFQOQc0tr4+8
         1XD2zWnV3zc0iZLBsyY7EaysQYigzHykleOyeXFrRURXdxzOQCffxeOsTC84ZxffZ7zJ
         BiYJMtsLjWzO8p4hn1eD8xtyaUuni1r+XAV0hJ+ekwU02ESZMJlSyv8IAoqmvadmGraE
         u2VoEvCtVXPT5Z0gpZt09I171DY2qeGANez0K56VO6KVpoe4I/przAQVS6UJdIveFKbX
         KXJPcHQCvcCvVqNgQ1iqd9AYjUk61g1gGCEezMxx2C/0poM1C+ghinJ+3AKwuevjIHjL
         wp0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dihGMqgCAhl6Z/n7/7U/oPTxicf4CzutJw8Ax83o2TQ=;
        b=AKIN9UW30lqBhJvrbTH2kUmvlXniJJj3wEvb/b31ScT+3py7lraIKDzl1jyDImIsY/
         VyzN0MLlQ8ytjiIW8wGzR50mtrtVUGpE5uRWWgVo8nvSgRl79xjA0v+lPhbZCrg/MoUR
         W9TD/3vswscFkGGsje84jtOVE4QEddpYkIB123As3IIuAbs3ag47sAotHGb2qf2rZdf8
         q4vwwd+kF+gtecZHyovs/4jfNwjjEtKgArhYdrdLzzRTCIoBQK+/Rb0mgDKCraFz0nfb
         d0piAaGtGHyCD0gMm3XrYoIC0CVe0otVSX9748Yqd3Ov/7EGgTIMiIA6lhX0vsBwyftQ
         2fyA==
X-Gm-Message-State: AOAM530LdduMgOy3HsGkNlGc0dtgUCkAzESjzaaQAjtk11Q1He2NPHmO
        1P5gnltf+/TIYwvahiVMTFAorr9nq86LmLP5
X-Google-Smtp-Source: ABdhPJw5sKQ0EC/y+6P9u8qAuR2DT4LB/LySvsoYWw/N+32i/dfIVkywVHL9ZD0QqVdN90W69h2ZvQ==
X-Received: by 2002:a05:6a00:1681:b029:1ec:c756:7ec3 with SMTP id k1-20020a056a001681b02901ecc7567ec3mr26419480pfc.13.1614085122013;
        Tue, 23 Feb 2021 04:58:42 -0800 (PST)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i2sm3272699pjj.35.2021.02.23.04.58.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 04:58:41 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv20 bpf-next 2/6] bpf: add a new bpf argument type ARG_CONST_MAP_PTR_OR_NULL
Date:   Tue, 23 Feb 2021 20:58:05 +0800
Message-Id: <20210223125809.1376577-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210223125809.1376577-1-liuhangbin@gmail.com>
References: <20210223125809.1376577-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new bpf argument type ARG_CONST_MAP_PTR_OR_NULL which could be
used when we want to allow NULL pointer for map parameter. The bpf helper
need to take care and check if the map is NULL when use this type.

Add a new variable map_ptr_cnt in struct bpf_call_arg_meta to disable
key/value argument check if there are multiple map pointers in the same
function.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

---
v20: Fix multi map pointer compatibility check in check_helper_call()
v13-v19: no update
v11-v12: rebase the patch to latest bpf-next
v10: remove useless CONST_PTR_TO_MAP_OR_NULL and Copy-paste comment.
v9: merge the patch from [1] in to this series.
v1-v8: no this patch

[1] https://lore.kernel.org/bpf/20200715070001.2048207-1-liuhangbin@gmail.com/
---
 include/linux/bpf.h   |  1 +
 kernel/bpf/verifier.c | 31 +++++++++++++++++++++++--------
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index cccaef1088ea..60895848afee 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -295,6 +295,7 @@ enum bpf_arg_type {
 	ARG_CONST_ALLOC_SIZE_OR_ZERO,	/* number of allocated bytes requested */
 	ARG_PTR_TO_BTF_ID_SOCK_COMMON,	/* pointer to in-kernel sock_common or bpf-mirrored bpf_sock */
 	ARG_PTR_TO_PERCPU_BTF_ID,	/* pointer to in-kernel percpu type */
+	ARG_CONST_MAP_PTR_OR_NULL,	/* const argument used as pointer to bpf_map or NULL */
 	__BPF_ARG_TYPE_MAX,
 };
 
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 1dda9d81f12c..e46e45c2a4d8 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -186,6 +186,9 @@ struct bpf_verifier_stack_elem {
 					  POISON_POINTER_DELTA))
 #define BPF_MAP_PTR(X)		((struct bpf_map *)((X) & ~BPF_MAP_PTR_UNPRIV))
 
+static int check_map_func_compatibility(struct bpf_verifier_env *env,
+					struct bpf_map *map, int func_id);
+
 static bool bpf_map_ptr_poisoned(const struct bpf_insn_aux_data *aux)
 {
 	return BPF_MAP_PTR(aux->map_ptr_state) == BPF_MAP_PTR_POISON;
@@ -248,6 +251,7 @@ struct bpf_call_arg_meta {
 	u32 btf_id;
 	struct btf *ret_btf;
 	u32 ret_btf_id;
+	int map_ptr_cnt;
 };
 
 struct btf *btf_vmlinux;
@@ -451,7 +455,8 @@ static bool arg_type_may_be_null(enum bpf_arg_type type)
 	       type == ARG_PTR_TO_MEM_OR_NULL ||
 	       type == ARG_PTR_TO_CTX_OR_NULL ||
 	       type == ARG_PTR_TO_SOCKET_OR_NULL ||
-	       type == ARG_PTR_TO_ALLOC_MEM_OR_NULL;
+	       type == ARG_PTR_TO_ALLOC_MEM_OR_NULL ||
+	       type == ARG_CONST_MAP_PTR_OR_NULL;
 }
 
 /* Determine whether the function releases some resources allocated by another
@@ -4512,6 +4517,7 @@ static const struct bpf_reg_types *compatible_reg_types[__BPF_ARG_TYPE_MAX] = {
 	[ARG_CONST_SIZE_OR_ZERO]	= &scalar_types,
 	[ARG_CONST_ALLOC_SIZE_OR_ZERO]	= &scalar_types,
 	[ARG_CONST_MAP_PTR]		= &const_map_ptr_types,
+	[ARG_CONST_MAP_PTR_OR_NULL]	= &const_map_ptr_types,
 	[ARG_PTR_TO_CTX]		= &context_types,
 	[ARG_PTR_TO_CTX_OR_NULL]	= &context_types,
 	[ARG_PTR_TO_SOCK_COMMON]	= &sock_types,
@@ -4657,9 +4663,22 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 		meta->ref_obj_id = reg->ref_obj_id;
 	}
 
-	if (arg_type == ARG_CONST_MAP_PTR) {
-		/* bpf_map_xxx(map_ptr) call: remember that map_ptr */
-		meta->map_ptr = reg->map_ptr;
+	if (arg_type == ARG_CONST_MAP_PTR ||
+	    arg_type == ARG_CONST_MAP_PTR_OR_NULL) {
+		if (!register_is_null(reg)) {
+			err = check_map_func_compatibility(env, reg->map_ptr, meta->func_id);
+			if (err)
+				return err;
+			meta->map_ptr = reg->map_ptr;
+		}
+		/* With multiple map pointers in the same function signature,
+		 * any future checks using the cached map_ptr become ambiguous
+		 * (which of the maps would it be referring to?), so unset
+		 * map_ptr to trigger the error conditions in the checks that
+		 * use it.
+		 */
+		if (++meta->map_ptr_cnt > 1)
+			meta->map_ptr = NULL;
 	} else if (arg_type == ARG_PTR_TO_MAP_KEY) {
 		/* bpf_map_xxx(..., map_ptr, ..., key) call:
 		 * check that [key, key + map->key_size) are within
@@ -5717,10 +5736,6 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
 
 	do_refine_retval_range(regs, fn->ret_type, func_id, &meta);
 
-	err = check_map_func_compatibility(env, meta.map_ptr, func_id);
-	if (err)
-		return err;
-
 	if ((func_id == BPF_FUNC_get_stack ||
 	     func_id == BPF_FUNC_get_task_stack) &&
 	    !env->prog->has_callchain_buf) {
-- 
2.26.2

