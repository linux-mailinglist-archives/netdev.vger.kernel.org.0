Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF4730F4B0
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 15:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236677AbhBDONi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 09:13:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236612AbhBDOEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 09:04:53 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C23C0613ED;
        Thu,  4 Feb 2021 06:04:12 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id z9so1848396pjl.5;
        Thu, 04 Feb 2021 06:04:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y6Alzar7nxFR6yfd+g+bMdscJ24HeOoxR0ChHyjquwc=;
        b=pZ++3WiaGJexzu75I6oWTI9tyK0tWnEB+WTpTaTU4Yo1EBrzNVN/l3AFhSkR5duvuW
         vCDXzjgRVyzhPDnxkrA0jhLAM4ulliKd820Bb5aE9+wkPhm8uoZkZ+KPgHL0CK0ORT5n
         lbxSVuEk1BBeW583Mi38hItlHbRkilEWhw3BG+ix7H06gUWEP72rdiwJ+HxlVzF1Zhjq
         X+JaUKqYOobhF7Bg+U4g3Guo9PNTy127m3/9bWxRc5Qf67ESjiM+IDynuhk93moSfKGE
         HnXpNLHNEBF32qiJ2d4dvJI8P+tsUFrdyAIbnem4+HC7mSuDHR534d+8G6iHhvsCdfmp
         K5qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y6Alzar7nxFR6yfd+g+bMdscJ24HeOoxR0ChHyjquwc=;
        b=rd8IB9oZI0+DUB9UaNWgCMLxlQVvn0cT+DaZ7wJ6CqQl4r8JkWAQqjxL3cJHoT9ZS6
         Kfx/zxwvafRSyBUw5RBDd6hoTjrGB8ZkLhBOGmofc0+bXydH3VP/MPJfx9e/MaYU/29k
         5isWPZZ2Kq+jn5nPNR0DYVANBaO0Xpn8OaSY4/4lnH/5bpNP8BkxtIl6pPZyZEp7RWo2
         6J4QAuA34U0kQatiMuM5fhiphqfbinuKjeeNNiOnhzg9Wai8/Oqud7zOVRewFR4MKm1J
         AevPvh9dmVQc552Ci7DLFLbVWN1/qEq4ZNAldP1cN2PwfqHZiFL+Yu9iQ5y4zLtTYUa7
         7yrQ==
X-Gm-Message-State: AOAM530v9rMAJ/zhNaQTL7JTsawppxoewSpAjh4gfZx6q0ZFp/EceqMY
        BkZX5aPpIMEHsZh30SHZkuWUYD8+uti/1EbB
X-Google-Smtp-Source: ABdhPJxBW2U3HPOXqgSwirGRwPirZVz1H8A1l981qml54XjxFrJwCLoUPZlrHagcf6kvaDxjERo1VA==
X-Received: by 2002:a17:90b:1495:: with SMTP id js21mr8827538pjb.127.1612447451633;
        Thu, 04 Feb 2021 06:04:11 -0800 (PST)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 21sm5889394pfh.56.2021.02.04.06.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 06:04:10 -0800 (PST)
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
Subject: [PATCHv18 bpf-next 2/6] bpf: add a new bpf argument type ARG_CONST_MAP_PTR_OR_NULL
Date:   Thu,  4 Feb 2021 22:03:13 +0800
Message-Id: <20210204140317.384296-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210204140317.384296-1-liuhangbin@gmail.com>
References: <20210125124516.3098129-1-liuhangbin@gmail.com>
 <20210204140317.384296-1-liuhangbin@gmail.com>
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
Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

v13-v18: no update
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
index 321966fc35db..b0777c8c03fd 100644
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
index 5e09632efddb..50a17f80358b 100644
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
@@ -4112,6 +4113,7 @@ static const struct bpf_reg_types *compatible_reg_types[__BPF_ARG_TYPE_MAX] = {
 	[ARG_CONST_SIZE_OR_ZERO]	= &scalar_types,
 	[ARG_CONST_ALLOC_SIZE_OR_ZERO]	= &scalar_types,
 	[ARG_CONST_MAP_PTR]		= &const_map_ptr_types,
+	[ARG_CONST_MAP_PTR_OR_NULL]	= &const_map_ptr_types,
 	[ARG_PTR_TO_CTX]		= &context_types,
 	[ARG_PTR_TO_CTX_OR_NULL]	= &context_types,
 	[ARG_PTR_TO_SOCK_COMMON]	= &sock_types,
@@ -4257,9 +4259,9 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
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

