Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F1B2F6307
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 15:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728814AbhANOYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 09:24:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbhANOYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 09:24:35 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A9AEC0613CF;
        Thu, 14 Jan 2021 06:23:55 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id z21so3896624pgj.4;
        Thu, 14 Jan 2021 06:23:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ttBCxrLsd9PpFc5KTgvDVZXUWJzkwUBwq96ScPOaKyI=;
        b=qL2QoyqHA2LICLBCUS55EHCxcMrYeHER71nft5KMZQoeuU4BhyDANI8jx6x/4a2t+t
         p6a20Xykx4cA6FdWL9zLytzESwcogW7GHytCuG2tsns21teepqj7oamYHbSRwXGIr/+1
         x43ED2AjTKAVfZVF3x0Mcl3NCTJJ1oKOgO1uKICBJA0LLMTIcnqp7AGlZRoZPHqdX1th
         yxqgNEFU+expTP2VmpSoANzKoDEre7ohksfOk3rv8FxmIXpG40/nrEysI44ngnhnKgHe
         CoHXcJMOTgqJ6dHdKO6qvVjQj78nkkYSHxXOjj0efcr4XLXntnScFSOFTNtCFdyX/4ML
         ytKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ttBCxrLsd9PpFc5KTgvDVZXUWJzkwUBwq96ScPOaKyI=;
        b=HszVliSfCfGVo1UDhr4+i95hmocbHW/saUnTzzNdEIjhJeV84AFzyHJqKcVummdNAc
         JhESyWOOXHeTeYFMLosxJ7MAiqMK0DRTgTnZ684oI7ptyNo5aeeBsvPwCo4HHATxO6aK
         GKSb2tYdD8/w780xEoYXooRbRrWtFbg/sUF1MqFGPqoSaX6Nux+TrwPvBf2VQxOfbJr9
         oVR2LFHqfEwVj9Cm0Kj5FCEv8FgTnvPm4gHndELjBdvHOpRF92pv/ayVIgX81KFsXFY3
         ofx9kjFYSTgH5iRKd12LOVbIetVtPICr1fKWx6mfsYuqgfiSPjLcgFBM0BGrBQkXqO5O
         D/Ug==
X-Gm-Message-State: AOAM5336BAqd/L6sjqvE5XffjXoHuPj+UqEzLdEmKvE5RZrkrH5V2aHI
        HjPgQqRlFaXT7iDDoSaF/oIbe6bSxv2IGfWO
X-Google-Smtp-Source: ABdhPJwaZDqP1jObj30zw+CupmAWNyAXqBY6XSYIwHRqShPqFQYaXvXIb5rqj5Uzfl58AoXvi7uyyw==
X-Received: by 2002:a63:d917:: with SMTP id r23mr7926381pgg.126.1610634234524;
        Thu, 14 Jan 2021 06:23:54 -0800 (PST)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t206sm5601827pgb.84.2021.01.14.06.23.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 06:23:54 -0800 (PST)
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
Subject: [PATCHv14 bpf-next 2/6] bpf: add a new bpf argument type ARG_CONST_MAP_PTR_OR_NULL
Date:   Thu, 14 Jan 2021 22:23:17 +0800
Message-Id: <20210114142321.2594697-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210114142321.2594697-1-liuhangbin@gmail.com>
References: <20201221123505.1962185-1-liuhangbin@gmail.com>
 <20210114142321.2594697-1-liuhangbin@gmail.com>
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
v11-v14: rebase the patch to latest bpf-next
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
index ae2aee48cf82..3e4b5d9fce78 100644
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

