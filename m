Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60493304A70
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 21:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730867AbhAZFEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:04:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728322AbhAYMrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 07:47:46 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086E8C0617A7;
        Mon, 25 Jan 2021 04:46:32 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id i5so8824851pgo.1;
        Mon, 25 Jan 2021 04:46:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KRTi5QtVagG/BSRY3WSm4j26RbGlYPGrRTel65RW+7s=;
        b=QhmFbCe8Zr9jAH46q8hSr0x4zYkWK52NU0KtKH4pHd2NYZMqScBk3knGdg9Wem4dES
         ZS8YxTDj64azmeQI667ll481tHnGJ2taS6GpBLwtAq8+ajTTsMJFzDAtu7cTfpkgcUXz
         frk6QYpt7CxrBumdGpyFVaE23gzAnOQv7kJg8LIPSY/xGkqHwuaSL3/h/WLwyPS6QMeW
         pzH5Ab6GaX3FDlSU6rj+GZzzO72POP9SoPf1Dp7bjyQa9RDN8UD7hdPjf84cSULRBJyU
         k/d4z99LT039saO2CDiSERa/VP91sKa69J0wKT730LvCxnl9R6I5WA6bRGzd9fQWC2jz
         FndQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KRTi5QtVagG/BSRY3WSm4j26RbGlYPGrRTel65RW+7s=;
        b=CLuI1oOABpkJxDBjtJOT3HsUkHSxpD+N/vflIxIPYTjJxO/ezJBFp3N0XF+gigcRsl
         TE0gqoE8qE3cBT9KLdmwZaANupCgbvKdmVFDvGBTpmlfkjzND1eOorPCxGMkLm0bTCkT
         WOpNy3AFFbHPoXNz8rr8JHW+CqPr5qr+a1akx9i8R/AFxznfSvI+2eumzWyo3/d0GOw8
         fIbmdzKH7ERhy3z1Dl1jmH+Q9F2F51/2HZKl9L1d0DQaqDu4r7ZZX52GM7JAx4WfDkFS
         39Jmdg4Z7v82j9hD9GT6+F3mly2lv/7496qgPxgcsqTPfdCXrYwsTslSijn8+IsYK4+A
         LlBQ==
X-Gm-Message-State: AOAM533b0tkMx5Aw7hBeQBJDR7IPcB2KO+e1udea1Pz6PjuVx5oApToA
        8123RdoZIPUXLNzXSofDJGE+aaUd45TpKUQq
X-Google-Smtp-Source: ABdhPJzUeFjuwH0Zjkh3gxresTFfim3rgAx82S43dhS/Q2tN0ATNId+FLAAvAPugDsUUrBNk9JQcmQ==
X-Received: by 2002:a63:d903:: with SMTP id r3mr428606pgg.445.1611578791407;
        Mon, 25 Jan 2021 04:46:31 -0800 (PST)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j123sm17815466pfg.36.2021.01.25.04.46.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 04:46:30 -0800 (PST)
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
Subject: [PATCHv17 bpf-next 2/6] bpf: add a new bpf argument type ARG_CONST_MAP_PTR_OR_NULL
Date:   Mon, 25 Jan 2021 20:45:12 +0800
Message-Id: <20210125124516.3098129-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210125124516.3098129-1-liuhangbin@gmail.com>
References: <20210122074652.2981711-1-liuhangbin@gmail.com>
 <20210125124516.3098129-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new bpf argument type ARG_CONST_MAP_PTR_OR_NULL which could be
used when we want to allow NULL pointer for map parameter. The bpf helper
need to take care and check if the map is NULL when use this type.

Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

---
v13-v17: no update
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
index d0eae51b31e4..4d147f39bfe7 100644
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
@@ -4108,6 +4109,7 @@ static const struct bpf_reg_types *compatible_reg_types[__BPF_ARG_TYPE_MAX] = {
 	[ARG_CONST_SIZE_OR_ZERO]	= &scalar_types,
 	[ARG_CONST_ALLOC_SIZE_OR_ZERO]	= &scalar_types,
 	[ARG_CONST_MAP_PTR]		= &const_map_ptr_types,
+	[ARG_CONST_MAP_PTR_OR_NULL]	= &const_map_ptr_types,
 	[ARG_PTR_TO_CTX]		= &context_types,
 	[ARG_PTR_TO_CTX_OR_NULL]	= &context_types,
 	[ARG_PTR_TO_SOCK_COMMON]	= &sock_types,
@@ -4253,9 +4255,9 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
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

