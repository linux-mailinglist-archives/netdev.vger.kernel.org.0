Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F37D25BF0C
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 12:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgICK1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 06:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbgICK1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 06:27:33 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD74C061245;
        Thu,  3 Sep 2020 03:27:33 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id gf14so1251528pjb.5;
        Thu, 03 Sep 2020 03:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pJR7Ul/+CGM9FWGYrNSv/ATk2xrJdf1Es7+hcDay9oE=;
        b=BjOzaMkhWgB6q4mIx3risUS55Sy4/pEgifR/ofvHFZ2I2okovPoCLFFd+Ej5fQOWsw
         LOf2UjmAI1x/Vi/0GFEXCF9nZOd02fUbc6arvqPCiQL+Layn0BbbXySLRf9Y/X98rGdF
         51nPr3sniEH+l/Ybaa+D/WJw6yYYSFPdtlIAZhC+r3ipdomoVH9LvbPtRzUowqkNhmUB
         S55xf2t4+KzraYMtsPM+ISgHzo/jhZM1cHJj0p8mozgMaCoSrB/fG2aEkAmJSAtGKIBi
         WiXWmFFrkT+NrRVDEK9OW0jkzX54wnJvhwy+ZhepO+HqkfrCpdW/9ZGw9+FDG/A73rru
         8dBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pJR7Ul/+CGM9FWGYrNSv/ATk2xrJdf1Es7+hcDay9oE=;
        b=GlPd9QmvLUc8QJyWH8oaFu46JsIq6N7whZBHcnua0kJSn7I0RBc5STwDLTa+pMlm8x
         qVCSx6tzul1K9l/g1yLNTh/NQQ/EzGU5XrtbI/8W+GTnrxVKwfIN8XreTuWrqzxBDAZE
         Fs2fdU22iJcOGO+PPdeX/pmGxuRrb2ugB8OqntVic9v76Z4Cb399hlcRLp5IYPBB+3Nt
         owslEhGrVkGVDKLhNOzTJthL0Bds6fM5gQVYbLDos4A4IUuXMtKcTSEoJvT3fH7fMXl6
         akQqHx89+hIz+i6xATXYwRDV5T1fDV+7WMpb3A2tEqHInJdyJM7JrAfCBiE7YUSnvSvi
         AK3Q==
X-Gm-Message-State: AOAM533KrOCTsG6qmMzWkHgkesp9HFowblDAjnfURTnAAq2r3Wi9uGPU
        uyGi3ZFhGQmadsppqUS+Pxa7FjCtoHM8B4iu
X-Google-Smtp-Source: ABdhPJzhG5YHKMvJ2eAiCeFv1vzprjEifN/7zXYsFXWAGLM5e1gnf/DwFjYLzcyCjNI7gaQ8tn0pHg==
X-Received: by 2002:a17:90a:2bc8:: with SMTP id n8mr2643306pje.189.1599128852477;
        Thu, 03 Sep 2020 03:27:32 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x3sm2131929pgg.54.2020.09.03.03.27.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 03:27:31 -0700 (PDT)
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
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv10 bpf-next 1/5] bpf: add a new bpf argument type ARG_CONST_MAP_PTR_OR_NULL
Date:   Thu,  3 Sep 2020 18:26:57 +0800
Message-Id: <20200903102701.3913258-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200903102701.3913258-1-liuhangbin@gmail.com>
References: <20200826132002.2808380-1-liuhangbin@gmail.com>
 <20200903102701.3913258-1-liuhangbin@gmail.com>
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

v10: remove useless CONST_PTR_TO_MAP_OR_NULL and Copy-paste comment.
v9: merge the patch from [1] in to this series.
v1-v8: no this patch

[1] https://lore.kernel.org/bpf/20200715070001.2048207-1-liuhangbin@gmail.com/

---
 include/linux/bpf.h   |  1 +
 kernel/bpf/verifier.c | 14 +++++++++-----
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index c6d9f2c444f4..884392297874 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -292,6 +292,7 @@ enum bpf_arg_type {
 	ARG_PTR_TO_ALLOC_MEM,	/* pointer to dynamically allocated memory */
 	ARG_PTR_TO_ALLOC_MEM_OR_NULL,	/* pointer to dynamically allocated memory or NULL */
 	ARG_CONST_ALLOC_SIZE_OR_ZERO,	/* number of allocated bytes requested */
+	ARG_CONST_MAP_PTR_OR_NULL,	/* const argument used as pointer to bpf_map or NULL */
 };
 
 /* type of values returned from helper functions */
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index b4e9c56b8b32..95444022f74c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3966,9 +3966,13 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
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
+			/* fall through to next check */;
+		else if (type != expected_type)
 			goto err_type;
 	} else if (arg_type == ARG_PTR_TO_CTX ||
 		   arg_type == ARG_PTR_TO_CTX_OR_NULL) {
@@ -4085,9 +4089,9 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
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
-- 
2.25.4

