Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09A842550D9
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 00:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbgH0WBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 18:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgH0WBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 18:01:20 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A62C061264;
        Thu, 27 Aug 2020 15:01:20 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id q93so3225974pjq.0;
        Thu, 27 Aug 2020 15:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=52NBTtZf5Xuj7TaI9QLahHUPbBXIXkSTAzZFMKvsUTo=;
        b=ORvRkjcQlY/t8K1HRhGiGJL9mAJiF8QAscIJFT/rRUeED1P39wlQaQYD1jR2IADY0H
         rskzddrArYm6igjfoctLRuRNFOOzcrkRyakEy8ZrNSb3VDbN0tfFi1FLEQ5E8bbZyHuN
         AYDZQKQrokH5kiWYa5Evv5T5F1s7UQ8YHdhzW/2wW4sM7Fjfq5Io0D6Kymhp6YmUrBMJ
         ghl5maxLJBp013CKDkybxVFQiXr7E1FWA09/hszhHG2wDiSpKY1PMcxOsQ9Ym/RgEHVa
         hs7TXI+I/C5HP6Y1e4HzIhUCWPb5gE0c9Xk2Gbt94iBYp9ZJI809kXvPmT1SpJHskjH6
         1erw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=52NBTtZf5Xuj7TaI9QLahHUPbBXIXkSTAzZFMKvsUTo=;
        b=FAGMF9TITZc/dK+TKeoVGA3GN3c8xVHHR/hnudJmLpj4dwC0eZic3HOXChdjvn6U4t
         g4rQ/Jhtz94/UFtmeqXCB35upFNSOtlnqzZyjaWmj7eFM75lhsGUHktGRQjyr8bci+Ui
         OXt/vpQsFy5IvkaDtXw4EnOV89hXdUzWbB0ah6B+d4JjENABZ0r4Hbdez4itMhRxU19q
         DDxtD+Z2PNMA7XnFmqrY96mvHV41N5RNEpM2910TBK/ZfU0D0sjKHLETUO+ERYPtLK/C
         3LhjAKAjRae/XkI5R0FqWCUkopBMKz+IEHI0IKY8Xtu4rceCtymNDAO8sEH/xOKZvMW4
         zmvQ==
X-Gm-Message-State: AOAM531ZhsBmY/TmTH+agniFvn+eg9Hk6CUaOnWVlTr+FUDMsjw0QVr8
        XNV6CIg8OKkwyq2Z7UrajEMFjeFtsAU=
X-Google-Smtp-Source: ABdhPJxtrHJY4U3RGYcFJ2ZzQkBP4MU0r8Z0T58BzYarX64ifAu9WVuw+78Zd3xlT+rCPQIm2Ma9gw==
X-Received: by 2002:a17:90b:94c:: with SMTP id dw12mr781520pjb.214.1598565680168;
        Thu, 27 Aug 2020 15:01:20 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id x28sm3997564pfq.62.2020.08.27.15.01.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Aug 2020 15:01:19 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, josef@toxicpanda.com, bpoirier@suse.com,
        akpm@linux-foundation.org, hannes@cmpxchg.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v3 bpf-next 1/5] mm/error_inject: Fix allow_error_inject function signatures.
Date:   Thu, 27 Aug 2020 15:01:10 -0700
Message-Id: <20200827220114.69225-2-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20200827220114.69225-1-alexei.starovoitov@gmail.com>
References: <20200827220114.69225-1-alexei.starovoitov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

'static' and 'static noinline' function attributes make no guarantees that
gcc/clang won't optimize them. The compiler may decide to inline 'static'
function and in such case ALLOW_ERROR_INJECT becomes meaningless. The compiler
could have inlined __add_to_page_cache_locked() in one callsite and didn't
inline in another. In such case injecting errors into it would cause
unpredictable behavior. It's worse with 'static noinline' which won't be
inlined, but it still can be optimized. Like the compiler may decide to remove
one argument or constant propagate the value depending on the callsite.

To avoid such issues make sure that these functions are global noinline.

Fixes: af3b854492f3 ("mm/page_alloc.c: allow error injection")
Fixes: cfcbfb1382db ("mm/filemap.c: enable error injection at add_to_page_cache()")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 mm/filemap.c    | 8 ++++----
 mm/page_alloc.c | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 1aaea26556cc..054d93a86f8a 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -827,10 +827,10 @@ int replace_page_cache_page(struct page *old, struct page *new, gfp_t gfp_mask)
 }
 EXPORT_SYMBOL_GPL(replace_page_cache_page);
 
-static int __add_to_page_cache_locked(struct page *page,
-				      struct address_space *mapping,
-				      pgoff_t offset, gfp_t gfp_mask,
-				      void **shadowp)
+noinline int __add_to_page_cache_locked(struct page *page,
+					struct address_space *mapping,
+					pgoff_t offset, gfp_t gfp_mask,
+					void **shadowp)
 {
 	XA_STATE(xas, &mapping->i_pages, offset);
 	int huge = PageHuge(page);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0e2bab486fea..cd8d8f0326fc 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3477,7 +3477,7 @@ static inline bool __should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
 
 #endif /* CONFIG_FAIL_PAGE_ALLOC */
 
-static noinline bool should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
+noinline bool should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
 {
 	return __should_fail_alloc_page(gfp_mask, order);
 }
-- 
2.23.0

