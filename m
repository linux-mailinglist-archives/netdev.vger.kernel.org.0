Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029E52FC968
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 04:49:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbhATDrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 22:47:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731653AbhATC3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 21:29:08 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A1AAC0613ED;
        Tue, 19 Jan 2021 18:28:08 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id o20so5153022pfu.0;
        Tue, 19 Jan 2021 18:28:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=COdHygh5SXZAy1IjmBHbAW9xrUGKsRNGux4dPQrjStQ=;
        b=sIm0NqqN6cdyjbArraEe2rWXoxzUWv/kU0r+NEoRjA4pnvooJ9HAhngqmzUlIRUSB0
         8lR+AzLnozz6AMMqSmP4/4/LF/BrAcI58KD2ll5fB2U+ru/iTmxXd1YBSRFN+KdvqGMq
         P+pOHegZD6eDioS/ZxLB+/xSnHTNeU4oEhynICqSuwzVD1/OlB5ZbWkfd/1UrGPw3t8L
         9Jy2u0HF8+nac+H0d7SZyHW29oVfgi1PfeV6CVFrOsytdVVkYxuppEDq4QGIHDwqvMgu
         4Wlu5xVhPulEdevuCPK7ELBf4SZW/LyI7NF4wcpICU8gMCyBo66iQfnE0KvDtHXO+GDX
         WYfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=COdHygh5SXZAy1IjmBHbAW9xrUGKsRNGux4dPQrjStQ=;
        b=mtYbqahT943Qu2ur7gr6+AY2KjTOn7/kLTAOma3Sm3p8wt3hqhZehSFb/dXMHkFBcu
         3buR6O1c+2rCqO29oKlCgJUY/DXi5EIX5NNXGbL8HUhPDp7CxFDaNBpzuKCkowyWN3UD
         wGyobiDd4JW2/l16lRaKqvDRhrK4jUYrIg3RbZGqqr7kkqV/boJEIpYX/S+X6bGKoqq8
         J8KvwAS+0/ff50DaXnViiONBADHUYpDZ9Z04HyA9+DLg/8HR2Szp/YqfRTlHzFlMAIPD
         DFnMV0XN0DTsRTk2Om86sPbLvNpqZ9eIZvdnyLd2rvmm4+eyBgQSqclYF2l3Mf3FEJ3c
         p6ww==
X-Gm-Message-State: AOAM530QVdAffRFXjyWJzDGxVgrAJrhRlqQ5Ixo00/iQlc3alNtDC+s+
        AhTyDHfzE8KnQwplypJkgalOOWTcojGb0bek
X-Google-Smtp-Source: ABdhPJxdyp5/8Zlpru15qDG4TyPHWd/wQ7k94Qhh4NMvjRVqpBXHz5aaQjYnsOfCaCkGSaOe1PChJA==
X-Received: by 2002:a62:d142:0:b029:19e:62a0:ca1a with SMTP id t2-20020a62d1420000b029019e62a0ca1amr6977006pfl.80.1611109688021;
        Tue, 19 Jan 2021 18:28:08 -0800 (PST)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 124sm378976pfd.59.2021.01.19.18.28.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 18:28:07 -0800 (PST)
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
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv15 bpf-next 2/6] bpf: add a new bpf argument type ARG_CONST_MAP_PTR_OR_NULL
Date:   Wed, 20 Jan 2021 10:25:10 +0800
Message-Id: <20210120022514.2862872-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210120022514.2862872-1-liuhangbin@gmail.com>
References: <20210114142321.2594697-1-liuhangbin@gmail.com>
 <20210120022514.2862872-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new bpf argument type ARG_CONST_MAP_PTR_OR_NULL which could be
used when we want to allow NULL pointer for map parameter. The bpf helper
need to take care and check if the map is NULL when use this type.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

---
v13-v15: no update
v11-v12: rebase the patch to latest bpf-next
v10: remove useless CONST_PTR_TO_MAP_OR_NULL and Copy-paste comment.
v9: merge the patch from [1] in to this series.
v1-v8: no this patch

[1] https://lore.kernel.org/bpf/20200715070001.2048207-1-liuhangbin@gmail.com/
---
 include/linux/bpf.h   |  1 +
 kernel/bpf/verifier.c | 10 ++++++----
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 1aac2af12fed..b75207a2484c 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -296,6 +296,7 @@ enum bpf_arg_type {
 	ARG_CONST_ALLOC_SIZE_OR_ZERO,	/* number of allocated bytes requested */
 	ARG_PTR_TO_BTF_ID_SOCK_COMMON,	/* pointer to in-kernel sock_common or bpf-mirrored bpf_sock */
 	ARG_PTR_TO_PERCPU_BTF_ID,	/* pointer to in-kernel percpu type */
+	ARG_CONST_MAP_PTR_OR_NULL,	/* const argument used as pointer to bpf_map or NULL */
 	__BPF_ARG_TYPE_MAX,
 };
 
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 0f82d5d46e2c..89c60494dd69 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -445,7 +445,8 @@ static bool arg_type_may_be_null(enum bpf_arg_type type)
 	       type == ARG_PTR_TO_MEM_OR_NULL ||
 	       type == ARG_PTR_TO_CTX_OR_NULL ||
 	       type == ARG_PTR_TO_SOCKET_OR_NULL ||
-	       type == ARG_PTR_TO_ALLOC_MEM_OR_NULL;
+	       type == ARG_PTR_TO_ALLOC_MEM_OR_NULL ||
+	       type == ARG_CONST_MAP_PTR_OR_NULL;
 }
 
 /* Determine whether the function releases some resources allocated by another
@@ -4106,6 +4107,7 @@ static const struct bpf_reg_types *compatible_reg_types[__BPF_ARG_TYPE_MAX] = {
 	[ARG_CONST_SIZE_OR_ZERO]	= &scalar_types,
 	[ARG_CONST_ALLOC_SIZE_OR_ZERO]	= &scalar_types,
 	[ARG_CONST_MAP_PTR]		= &const_map_ptr_types,
+	[ARG_CONST_MAP_PTR_OR_NULL]	= &const_map_ptr_types,
 	[ARG_PTR_TO_CTX]		= &context_types,
 	[ARG_PTR_TO_CTX_OR_NULL]	= &context_types,
 	[ARG_PTR_TO_SOCK_COMMON]	= &sock_types,
@@ -4251,9 +4253,9 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 		meta->ref_obj_id = reg->ref_obj_id;
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
-- 
2.26.2

