Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E49D2DC236
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 15:31:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgLPObn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 09:31:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726398AbgLPObn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 09:31:43 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E3AC0617A7;
        Wed, 16 Dec 2020 06:31:03 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id l23so1715998pjg.1;
        Wed, 16 Dec 2020 06:31:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uDSjQ6eqNouGRWexyQUcNrTiRrg41nS2aMR+Xhy4/m4=;
        b=Zk8XwqvFTh/Gkr6bLxBAR9j/7I5t3lD/iRMNSPDKqpW60tG/22neKsHS5q61kK3Qwi
         TV1EFKFQO2eamPgO7vXRwzO52khRF3pPPmXi7ULJXqdCby1zDXA57siKdk6XgPUHT7h+
         HHozP0ikaGNj2qdAXNzdb7R6QscgvQnnvCa6AwxGgYvHMuBUw1l6JIbrvmSG7LsY/dAl
         BV2X5/47EBLKIJnzu/bb1rOSaSJhPC3wQK/Hw22XV60M2Xr/zC9uZ3dLfshimh79zcbW
         egphgVr3+xuiVV6yOK6pS8MgGPjLhwzvWpIKovydaqM2jUXMPIsQHUryEmipMM3RzCMp
         VB9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uDSjQ6eqNouGRWexyQUcNrTiRrg41nS2aMR+Xhy4/m4=;
        b=nWj0WAgjaY4p5MUG6ywZ2D5ewpJ0Qhs8kee0N6q0LJR4YLb1BNrl3AtDioAtJsVymM
         OK8fBUUnJKNITj7QAQCCGHyNfmuke0kISy+dY0e0x81sXktYhlKLZau+O0oX0kmdsNme
         372KMyPOIYhocJ6tdb56ueaVRmabqLhQYkRcpyIsDjKbCBlSCX7cYIjvwHdvjtbaFLOW
         O60bjIbjsOkLaFdiatvC3Shbr9Gfl0T2f8o7OApXwEpsuLGUoaFmsh2aGK9sM/Df3S7T
         Cq2nm/ND4lnNloVz4Yl8SgesmZCWin4QvEt0R7Z/Ggvy4p+37KLpQ/lx+LcDpQL7GXEk
         QmxQ==
X-Gm-Message-State: AOAM530iqU5yziC+bFKatfeSISsFU9b0O9Vn+Pek0EhtQfp1GlNGN66g
        UH4zhbDmouHJc2cuHECBqekX1T1ri0lkrTxH
X-Google-Smtp-Source: ABdhPJya2Ymw/iQOwGDn9RlXMTLzZ5uT2afFkHOj5zxUjKNNKtQtFJE9pk3/h7dzmDph21bM5hbXEg==
X-Received: by 2002:a17:902:b616:b029:da:fcfd:7568 with SMTP id b22-20020a170902b616b02900dafcfd7568mr31890951pls.35.1608129062688;
        Wed, 16 Dec 2020 06:31:02 -0800 (PST)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a141sm2858802pfa.189.2020.12.16.06.30.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 06:31:02 -0800 (PST)
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
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv12 bpf-next 2/6] bpf: add a new bpf argument type ARG_CONST_MAP_PTR_OR_NULL
Date:   Wed, 16 Dec 2020 22:30:32 +0800
Message-Id: <20201216143036.2296568-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201216143036.2296568-1-liuhangbin@gmail.com>
References: <20200907082724.1721685-1-liuhangbin@gmail.com>
 <20201216143036.2296568-1-liuhangbin@gmail.com>
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
index 07cb5d15e743..7850c87456fc 100644
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
index 17270b8404f1..9f6633c9ea12 100644
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
@@ -4065,6 +4066,7 @@ static const struct bpf_reg_types *compatible_reg_types[__BPF_ARG_TYPE_MAX] = {
 	[ARG_CONST_SIZE_OR_ZERO]	= &scalar_types,
 	[ARG_CONST_ALLOC_SIZE_OR_ZERO]	= &scalar_types,
 	[ARG_CONST_MAP_PTR]		= &const_map_ptr_types,
+	[ARG_CONST_MAP_PTR_OR_NULL]	= &const_map_ptr_types,
 	[ARG_PTR_TO_CTX]		= &context_types,
 	[ARG_PTR_TO_CTX_OR_NULL]	= &context_types,
 	[ARG_PTR_TO_SOCK_COMMON]	= &sock_types,
@@ -4210,9 +4212,9 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
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

