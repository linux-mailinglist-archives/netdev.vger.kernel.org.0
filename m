Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B194F312FA5
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 11:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbhBHKwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 05:52:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbhBHKtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 05:49:13 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6615C061788;
        Mon,  8 Feb 2021 02:48:18 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id k22so3232558pll.6;
        Mon, 08 Feb 2021 02:48:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0B6eZk+CFmLJpBGpxKL0YAXK1hsrLIaB1SPNfUe5Go4=;
        b=AaRWpx63D8+PqqoDwDK9881RBxyUEOvjk9v8igy5FbuxbI5PCPIZsPZ8qVng1OXyKh
         Zsz1UITp2WOQrwWf460MnZZYDN+w18e+H86mznfsf2PtVqtBC9qONANbyFWb+PYtgf0d
         kDbz1vMWvZz77MrzmFoQA+iSADDOAMT1Q/QUlH4ASuMa+O+XM6Gmcp6H8JgD1PLGETDx
         kh+TuWd+hKgioqdKnNUgiOx0wgqRHX366ZK0Y/He6kfN/YQx8Xd785GaRo1VJ+0Ao/dx
         o4hzS9Jk8JYGd9SPYJU5lfn5GiORZspmAduIlG0O7x5eAnyxJB6OYg2uxIPsuFdLRb5a
         lFNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0B6eZk+CFmLJpBGpxKL0YAXK1hsrLIaB1SPNfUe5Go4=;
        b=F7XK0t5RBwb0xkqvhqTfZmKYiFkuNjzMccgrpNiIgncycCyBsf10VvwZ87ZXFv7u95
         mkak/dw75D1VvuaPbqVK5MaAenvJIKOZox1RoXXx+EbOZmLiX8KAr9nVzubrr7XWZyh5
         5V+knAc59MEKC76N+bxLz72ec1atzvjAI6B7Pwaxr4Oc/oNdcdUDzaMZmL0+p5kYZ7B0
         RUfcDxM6veSiyh8QoNBdV5xF3myhMEHNyLZiimgYJHpnQ/Hqr2x6e9QHwnlGNTCrRcdm
         ju5UdVjR7O+esP6X0EDKvL11ECP7S8nABb+XmlXCC71Yc7yQ4F/nkzxWQ+Vj316a9RSC
         Coig==
X-Gm-Message-State: AOAM530noNzMyqFHIPFzZtqnwNz2ZDYOcPYZrEsB/gOg7toPVNipNn4V
        bgq3kvzGciuoFAbk9CAgMZSCnqmxixN0Rl4u
X-Google-Smtp-Source: ABdhPJwvp3H54a+aUvsG43AfkgB5pekD4KAmesH6BaNBEti0fL0HgN7CR/dAka9MpqVa3956+Qihew==
X-Received: by 2002:a17:90a:c08e:: with SMTP id o14mr6531995pjs.139.1612781298149;
        Mon, 08 Feb 2021 02:48:18 -0800 (PST)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v19sm15371024pjh.37.2021.02.08.02.48.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 02:48:17 -0800 (PST)
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
Subject: [PATCHv19 bpf-next 2/6] bpf: add a new bpf argument type ARG_CONST_MAP_PTR_OR_NULL
Date:   Mon,  8 Feb 2021 18:47:43 +0800
Message-Id: <20210208104747.573461-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210208104747.573461-1-liuhangbin@gmail.com>
References: <20210208104747.573461-1-liuhangbin@gmail.com>
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

---
v13-v19: no update
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
index 15694246f854..adc7a2b02a60 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -451,7 +451,8 @@ static bool arg_type_may_be_null(enum bpf_arg_type type)
 	       type == ARG_PTR_TO_MEM_OR_NULL ||
 	       type == ARG_PTR_TO_CTX_OR_NULL ||
 	       type == ARG_PTR_TO_SOCKET_OR_NULL ||
-	       type == ARG_PTR_TO_ALLOC_MEM_OR_NULL;
+	       type == ARG_PTR_TO_ALLOC_MEM_OR_NULL ||
+	       type == ARG_CONST_MAP_PTR_OR_NULL;
 }
 
 /* Determine whether the function releases some resources allocated by another
@@ -4114,6 +4115,7 @@ static const struct bpf_reg_types *compatible_reg_types[__BPF_ARG_TYPE_MAX] = {
 	[ARG_CONST_SIZE_OR_ZERO]	= &scalar_types,
 	[ARG_CONST_ALLOC_SIZE_OR_ZERO]	= &scalar_types,
 	[ARG_CONST_MAP_PTR]		= &const_map_ptr_types,
+	[ARG_CONST_MAP_PTR_OR_NULL]	= &const_map_ptr_types,
 	[ARG_PTR_TO_CTX]		= &context_types,
 	[ARG_PTR_TO_CTX_OR_NULL]	= &context_types,
 	[ARG_PTR_TO_SOCK_COMMON]	= &sock_types,
@@ -4259,9 +4261,9 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
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

