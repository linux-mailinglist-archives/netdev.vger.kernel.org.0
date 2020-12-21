Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE572DFBE9
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 13:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgLUMgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 07:36:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726598AbgLUMgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 07:36:13 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDBA0C061793;
        Mon, 21 Dec 2020 04:35:32 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id y8so5535344plp.8;
        Mon, 21 Dec 2020 04:35:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mnS0cbhF9F9f8JFkWlBGpOS00NB+6VMLZXQWUjcxj+I=;
        b=rcjzOjylf43DCzqqP+it25avfQNAhLULZPbSkfGuh9CADVWBq1o6PhvLGSRiEWlrZF
         xXapOyIDrp+55Xu6uoU7JN3j1o9oK5+vy3S3cKroH5krVAbe3S4bDthEV3u8oIdNzM6s
         RXIFS4KrMtMzBl2kAMAAYSYlg66jq/3FZfZsGiH5fwmGBSdLxISmF2xZYkuPkrnXUyp4
         qknQxfXSy1zzziK4u7skeoelP6g1XJhM8jO2RhlZyyilO7aZ45Vx8QDRfJrq5De6cA++
         gzg2+W5olLEl+jZ5f0BaEEIELPEy+dToGi44P2EhIPh1IZ1v/mgvFboxTkXtTjFR35yY
         cTdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mnS0cbhF9F9f8JFkWlBGpOS00NB+6VMLZXQWUjcxj+I=;
        b=oF56XQBWRYTT6k4BeGjLf4txFOI/5kAdq/nx6ugBB4u4kB/2Fm9fVcqwUQ2+rwDzL0
         NUuOr1pH3t9/WCR5P0VbREVLCbRT/xqueB8YGh2Y4smxoDWcgYrHsAc+psFZ9hd02qzY
         zJjwtm3HXLn2mLbHALYI11N6nKK3NqKd9H0vy6M8kUA+0tMGJTKZ7QGTcZMwElFVYRum
         h3hehYPyQnWYGVfrKo++ZRVNtTP7qsaqGw6ibdepL+MN4BL9DpA8gORx9AmcU3jtytFA
         u4wiEVG/rIBpTq9XYdL1WJW1LCcCqhZEFdAKTfyeyu4p3AufGWoLu7c3mS34CxRRygHe
         cvyA==
X-Gm-Message-State: AOAM531P8+ac9wM3AC51PWK2TarXC3T/ZAJ+Rm/zkEMAJVVPIYIhW20d
        fJdBm0rZQAr+VwpbFdc2NjXvcODhb4LpUmn8
X-Google-Smtp-Source: ABdhPJz/0kRKektVjlPNWgZOqSptQj0ONcmOkZCAlzi7dAwzZYl59+opI2iaXa0ovR9E//8b5dAyXg==
X-Received: by 2002:a17:902:9a86:b029:dc:104:1902 with SMTP id w6-20020a1709029a86b02900dc01041902mr16296020plp.50.1608554131734;
        Mon, 21 Dec 2020 04:35:31 -0800 (PST)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a26sm15382204pgd.64.2020.12.21.04.35.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 04:35:31 -0800 (PST)
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
Subject: [PATCHv13 bpf-next 2/6] bpf: add a new bpf argument type ARG_CONST_MAP_PTR_OR_NULL
Date:   Mon, 21 Dec 2020 20:35:01 +0800
Message-Id: <20201221123505.1962185-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201221123505.1962185-1-liuhangbin@gmail.com>
References: <20201216143036.2296568-1-liuhangbin@gmail.com>
 <20201221123505.1962185-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new bpf argument type ARG_CONST_MAP_PTR_OR_NULL which could be
used when we want to allow NULL pointer for map parameter. The bpf helper
need to take care and check if the map is NULL when use this type.

[1] https://lore.kernel.org/bpf/20200715070001.2048207-1-liuhangbin@gmail.com/

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---

v11-v12: rebase the patch to latest bpf-next
v10: remove useless CONST_PTR_TO_MAP_OR_NULL and Copy-paste comment.
v9: merge the patch from [1] in to this series.
v1-v8: no this patch

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

