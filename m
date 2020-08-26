Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A02252F88
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 15:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730239AbgHZNU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 09:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730174AbgHZNUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 09:20:23 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6643C061574;
        Wed, 26 Aug 2020 06:20:22 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 17so964938pfw.9;
        Wed, 26 Aug 2020 06:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R1taOkAwFV1KVpE9MBDA2IKivPG7n34ZgstgOj1vxxA=;
        b=E2+zyS8Jv9b1Mh+Q5XLjwCFWW3IU2EKXsv4wUA4e886fza3UalhVDCQIvm1FmJMLl5
         Hsa6Yu6RmKCpMnD26sMu/CFRM8yc0ab2hgdGXn+KLTa5dpy5eH+ZqNfNm8W4MLVDMRA3
         dFda5ntxcppD69u4lCUeyLJ5QeDfJP1nskStvGZws8PDruI0a0tDsO5V0k4AYkHucjGV
         uQOaZo/9qnYp6vZeAouMsqXNzvhjf5bH62iPWudqMGO0gikF4IOtfonn9K0nGLTh8NKK
         gKBkEideZh+bVPlzljO4+7P7p95yosqmVml/xQ2HH0xWjWzBoHP8bkgdKuRICFk59Lz8
         6kdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R1taOkAwFV1KVpE9MBDA2IKivPG7n34ZgstgOj1vxxA=;
        b=Dfjt6pYOlQRPipjajpoqzgSstO+w4P0Y8q/tyyRm6s6zpgXQdlHU/6alZriL9dfp9t
         TY936PM6kCcMyXoVVdZ+TuYRKGOReuKHqNNXSZkOFp3or1JIjAxXt6K8SBZYiHVWxZ2r
         BLs7lnZuQwcnQZ/PA/OzG6kWq/hHPLELSIEWTDRS2kulvVovzh8/mnbpcrX/8GaHjbwz
         ekdkXvWGW/yZYvf8Y/zXRIc01aAKdoW7CPPJAw5UxWN9W2x8qS+b8p0XVehcTTpE/qIu
         m/iwCBSdihYYl3EQ3x/dMBP89+QQ1t+8HpehwGCeguOX+UVWo00Jc5bEUh/wJly0SGXt
         0JqA==
X-Gm-Message-State: AOAM530erw/QdioOC3YvtbJQdA/qcVabT+8otbh50IGCpVC8ehurqZKX
        23H9i+22kta0bupLLuzwkV8Tqd9MdhB57Arr
X-Google-Smtp-Source: ABdhPJzFR1y0C3Ug7v+8XdiMztCgCCmmlR8I4lHkSrEdnSSwljoOgMj29hoFTLyyyw3PYX86I/yJhA==
X-Received: by 2002:a63:af01:: with SMTP id w1mr10712309pge.23.1598448022170;
        Wed, 26 Aug 2020 06:20:22 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s129sm3131794pfb.39.2020.08.26.06.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 06:20:21 -0700 (PDT)
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
        Andrii Nakryiko B <andrii.nakryiko@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv9 bpf-next 1/5] bpf: add a new bpf argument type ARG_CONST_MAP_PTR_OR_NULL
Date:   Wed, 26 Aug 2020 21:19:58 +0800
Message-Id: <20200826132002.2808380-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200826132002.2808380-1-liuhangbin@gmail.com>
References: <20200715130816.2124232-1-liuhangbin@gmail.com>
 <20200826132002.2808380-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new bpf argument type ARG_CONST_MAP_PTR_OR_NULL which could be
used when we want to allow NULL pointer for map parameter. The bpf helper
need to take care and check if the map is NULL when use this type.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---

v9: merge the patch from [1] in to this series.
v1-v8: no this patch

[1] https://lore.kernel.org/bpf/20200715070001.2048207-1-liuhangbin@gmail.com/
---
 include/linux/bpf.h   |  2 ++
 kernel/bpf/verifier.c | 23 ++++++++++++++++-------
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index a6131d95e31e..cb40a1281ea2 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -276,6 +276,7 @@ enum bpf_arg_type {
 	ARG_PTR_TO_ALLOC_MEM,	/* pointer to dynamically allocated memory */
 	ARG_PTR_TO_ALLOC_MEM_OR_NULL,	/* pointer to dynamically allocated memory or NULL */
 	ARG_CONST_ALLOC_SIZE_OR_ZERO,	/* number of allocated bytes requested */
+	ARG_CONST_MAP_PTR_OR_NULL,	/* const argument used as pointer to bpf_map or NULL */
 };
 
 /* type of values returned from helper functions */
@@ -369,6 +370,7 @@ enum bpf_reg_type {
 	PTR_TO_RDONLY_BUF_OR_NULL, /* reg points to a readonly buffer or NULL */
 	PTR_TO_RDWR_BUF,	 /* reg points to a read/write buffer */
 	PTR_TO_RDWR_BUF_OR_NULL, /* reg points to a read/write buffer or NULL */
+	CONST_PTR_TO_MAP_OR_NULL, /* reg points to struct bpf_map or NULL */
 };
 
 /* The information passed from prog-specific *_is_valid_access
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 7e5908b83ec7..53a84335a8fd 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -411,7 +411,8 @@ static bool reg_type_may_be_null(enum bpf_reg_type type)
 	       type == PTR_TO_BTF_ID_OR_NULL ||
 	       type == PTR_TO_MEM_OR_NULL ||
 	       type == PTR_TO_RDONLY_BUF_OR_NULL ||
-	       type == PTR_TO_RDWR_BUF_OR_NULL;
+	       type == PTR_TO_RDWR_BUF_OR_NULL ||
+	       type == CONST_PTR_TO_MAP_OR_NULL;
 }
 
 static bool reg_may_point_to_spin_lock(const struct bpf_reg_state *reg)
@@ -427,7 +428,8 @@ static bool reg_type_may_be_refcounted_or_null(enum bpf_reg_type type)
 		type == PTR_TO_TCP_SOCK ||
 		type == PTR_TO_TCP_SOCK_OR_NULL ||
 		type == PTR_TO_MEM ||
-		type == PTR_TO_MEM_OR_NULL;
+		type == PTR_TO_MEM_OR_NULL ||
+		type == CONST_PTR_TO_MAP_OR_NULL;
 }
 
 static bool arg_type_may_be_refcounted(enum bpf_arg_type type)
@@ -509,6 +511,7 @@ static const char * const reg_type_str[] = {
 	[PTR_TO_RDONLY_BUF_OR_NULL] = "rdonly_buf_or_null",
 	[PTR_TO_RDWR_BUF]	= "rdwr_buf",
 	[PTR_TO_RDWR_BUF_OR_NULL] = "rdwr_buf_or_null",
+	[CONST_PTR_TO_MAP_OR_NULL] = "map_ptr_or_null",
 };
 
 static char slot_type_char[] = {
@@ -3957,9 +3960,13 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 		expected_type = SCALAR_VALUE;
 		if (type != expected_type)
 			goto err_type;
-	} else if (arg_type == ARG_CONST_MAP_PTR) {
+	} else if (arg_type == ARG_CONST_MAP_PTR ||
+		   arg_type == ARG_CONST_MAP_PTR_OR_NULL) {
 		expected_type = CONST_PTR_TO_MAP;
-		if (type != expected_type)
+		if (register_is_null(reg) &&
+		    arg_type == ARG_CONST_MAP_PTR_OR_NULL)
+			/* final test in check_stack_boundary() */;
+		else if (type != expected_type)
 			goto err_type;
 	} else if (arg_type == ARG_PTR_TO_CTX ||
 		   arg_type == ARG_PTR_TO_CTX_OR_NULL) {
@@ -4076,9 +4083,9 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 		return -EFAULT;
 	}
 
-	if (arg_type == ARG_CONST_MAP_PTR) {
-		/* bpf_map_xxx(map_ptr) call: remember that map_ptr */
-		meta->map_ptr = reg->map_ptr;
+	if (arg_type == ARG_CONST_MAP_PTR ||
+	    arg_type == ARG_CONST_MAP_PTR_OR_NULL) {
+		meta->map_ptr = register_is_null(reg) ? NULL : reg->map_ptr;
 	} else if (arg_type == ARG_PTR_TO_MAP_KEY) {
 		/* bpf_map_xxx(..., map_ptr, ..., key) call:
 		 * check that [key, key + map->key_size) are within
@@ -6977,6 +6984,8 @@ static void mark_ptr_or_null_reg(struct bpf_func_state *state,
 			reg->type = PTR_TO_RDONLY_BUF;
 		} else if (reg->type == PTR_TO_RDWR_BUF_OR_NULL) {
 			reg->type = PTR_TO_RDWR_BUF;
+		} else if (reg->type == CONST_PTR_TO_MAP_OR_NULL) {
+			reg->type = CONST_PTR_TO_MAP;
 		}
 		if (is_null) {
 			/* We don't need id and ref_obj_id from this point
-- 
2.25.4

