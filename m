Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC3CD2FFD98
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 08:49:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbhAVHss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 02:48:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726648AbhAVHsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 02:48:13 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71EA4C061788;
        Thu, 21 Jan 2021 23:47:33 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id 15so3176748pgx.7;
        Thu, 21 Jan 2021 23:47:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cIZaJy4flROQZtXRFz2YzXJW6zfW1SurVVchuw9ze+g=;
        b=C01ymNfiwCTtHEluHXHEVTL85gw6GQQ6cwSeLp+7TecPU6xxTkg+WKwjxYnfZQV5pG
         o9DCHDLNUJEC0hO1I0Dn5bYojyJYQRAB/Tb0Z0DAYeoeHRA8l0gED7PyQu4mse56gnF8
         u6isGGsyJW404AYZWpR3pMzsoHDqo+AXhfptSN99hxkAkz4bQdHiXFlstaEhf8vhua2O
         zO8qmNDPVBsDe+PofiLUonjEz+YcK1tJqqyWESDkRPWqKPPgr0gQJxySN6e85T9lzgjw
         f1l9GkJdoaEB48xbLLNlUVg2fJe6a4Vaua+roPvDzOrKJuxcHZ//nU1DbJfOPz+0lL8t
         W8CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cIZaJy4flROQZtXRFz2YzXJW6zfW1SurVVchuw9ze+g=;
        b=fN04yWR2+sDhySbtBaGFFsbXOvICOlSmiZ1ALj9qmf27ECWmtfGHLWH3rj2uImopp5
         6nQi64f7SuY6nE7Hnf3BRygdUp6e44rSJ+0W1xdp4XHtdf76mVhnFO2TngzY/X+Kk+6e
         e0NapZVv63O97TBqnLM4LM1uVqFcclquvonk0Mj6vBb8QC0U3KpOFLruwmbL7mSvpuI6
         bHQA6sRJnqK1Dw2T1JIdvetiZt0y9sIov80k7BKZjPRVD9ov9lNhu/qXj/5nxLEanNDS
         3lL7eMB0KmeMTLAhtoSlolgz15p5eO4qHz7+vq1eGgPmFmdG3FE/RAfLjE3Y/e4sQ+lk
         LzbQ==
X-Gm-Message-State: AOAM530WQ3tqXGHAkwflJYO7WNBZbKiD+9II6vxJT0oYAPFQ4yzEcACw
        zQKMblE/OCi5d40xZE/LKsB77O4pVY00kA==
X-Google-Smtp-Source: ABdhPJwz2I3NcG97AdrV3Gudi6k7MT6cSgHvPVmkt6eSXxXirYTLOolt7wJ7+7cNKol0uYVQw5b3cw==
X-Received: by 2002:a62:5547:0:b029:1a4:cb2a:2833 with SMTP id j68-20020a6255470000b02901a4cb2a2833mr3512101pfb.35.1611301652694;
        Thu, 21 Jan 2021 23:47:32 -0800 (PST)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 145sm8081384pge.88.2021.01.21.23.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 23:47:32 -0800 (PST)
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
Subject: [PATCHv16 bpf-next 2/6] bpf: add a new bpf argument type ARG_CONST_MAP_PTR_OR_NULL
Date:   Fri, 22 Jan 2021 15:46:48 +0800
Message-Id: <20210122074652.2981711-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210122074652.2981711-1-liuhangbin@gmail.com>
References: <20210120022514.2862872-1-liuhangbin@gmail.com>
 <20210122074652.2981711-1-liuhangbin@gmail.com>
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
index 785d25392ead..62920bea2454 100644
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

