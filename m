Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3B1F5E83C2
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 22:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233110AbiIWUct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 16:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232881AbiIWUc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 16:32:28 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56ABD147CFE
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:28:26 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id s90-20020a17090a2f6300b00203a685a1aaso1281137pjd.1
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=YGvtsu71vtHcP1IwH8KHiY99VHKmYF+/gM9Vu/q9kHU=;
        b=IFb3o6XSbaR/uQunXfgk/OAgUcbyiUG/neLZN7u63Mb8Dqi7z6PDoN9BNOVaTqa26y
         SRlzwgeKQKd7R1FctE6Aq8Of9Rx/sgZevcaBDxM7zwYZdr/ifKEynY9SIWqMo8+dRdxg
         Y1YODqFn9CHpITGWx8VNcWimDUOWaa7761v9Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=YGvtsu71vtHcP1IwH8KHiY99VHKmYF+/gM9Vu/q9kHU=;
        b=8J5RySbfhnzLARVUzglzrQcLSL0gI6F3drRUvOsD3MolghFR5m78hcRzn+Dw/hiALg
         +cdkS87GuDrdXCtzTCuHhjHvJ3clB8vD5begsCSs5rtvgo7mIw0GjYSd/VAzNRoDe0+S
         ka2qPozN1K6glOZlzkMQgwuOL50lJFMrz5cbB5ZXrzN9RnPkPRWf6ihQH5jg3fMG/iu0
         rMY7T3YjClbMJa/wulfUtv3w0xdYJ69XeRqCwC3rNxnJ0BBakb6y0EYNVq2N2mcBzWT5
         1ntVi/8b0H5QtsBxEAWMbCgqmj+c8TGtaYvLHxKvqw1NY+jDiQs9E/y2qbfzdx0WeyDk
         t3pQ==
X-Gm-Message-State: ACrzQf0meK/rbB86wk99jVBewVxqPLHsNYbGKlOU0rn5ueKMEH6bYvO2
        pQhlJRSuAsieCX3cIL0YyUPweQ==
X-Google-Smtp-Source: AMsMyM4GlI4eTJyA9jGLi9lKSnvEwSBc6wqIcYDsgYSV7Hnp4hgp4C2mRxXo8b79UHawMzdaoq59kQ==
X-Received: by 2002:a17:90a:e7c5:b0:200:ab1a:f32 with SMTP id kb5-20020a17090ae7c500b00200ab1a0f32mr22617314pjb.100.1663964905845;
        Fri, 23 Sep 2022 13:28:25 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id q9-20020a17090311c900b0017829f986a5sm6477104plh.133.2022.09.23.13.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 13:28:25 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Kees Cook <keescook@chromium.org>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Marco Elver <elver@google.com>, linux-mm@kvack.org,
        "Ruhl, Michael J" <michael.j.ruhl@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Alex Elder <elder@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Yonghong Song <yhs@fb.com>, Miguel Ojeda <ojeda@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-fsdevel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        dev@openvswitch.org, x86@kernel.org, llvm@lists.linux.dev,
        linux-hardening@vger.kernel.org
Subject: [PATCH v2 01/16] slab: Remove __malloc attribute from realloc functions
Date:   Fri, 23 Sep 2022 13:28:07 -0700
Message-Id: <20220923202822.2667581-2-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220923202822.2667581-1-keescook@chromium.org>
References: <20220923202822.2667581-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4158; h=from:subject; bh=MMNKX5wNJYq+FFEmxyLeG88Y0pnaYb/m5JRZI7mnarg=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjLhbj8zMWKpgfJIfLMPzhNCTicodYe34AHw5xM3H6 j5Q5e5iJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYy4W4wAKCRCJcvTf3G3AJkqXEA C0CZsQPuFBR2/YBQC6kBOKXs3AnUbDd1vBqtB/SiXvO/znjATFPdq/AAaSBC59HBiMKMePM5lvoiuf aYrT/n/J7UMzadTeGJDsCFyc95mxXFpunUjeXGaTgZojjSgAVg4DABiW54DaumW0lAWFAYegD26yeW JBuJYikNr/QTKW2lM4rlUyCE6YeklCEU+t6NysjAG5alyIx4W0dgH5pUSaAsO6hX65jz8XnK6X4gIg /ftbvkJQdCA8yp6HbKj3bRnJNwHhei3Ew8kR8tRkxr/QCstK0qco60yvO2mmfdDhJOTt8ljlhX+99P ki8iAJ2IUxqLrohWV0+vBNh/UwJAT/E2xl9J7vSz0a5lE1JDaJni0l7B9aWJ6wdTRIlb2RIw/25CU3 2jH0hGLqeXUGTIW8ZuajWL/FWv6nUhF3N+Zql34CZfjXaiVB/8urV6hGJYu0PjR4RhPJtooFtvcGnc NN4P/rvByw1L7/4EGJFqF8KQolNWMu558pdQ29AecI/zn4E9FW41pu2k0zXuekf9ZHdzPr//MRq0VK jji3tNn5ZbZXQWzbxXbbkECT6CK1qfq6Re4GlmJrjPbAnkWCC4gXdw7JW6JIg/Km6CtttHx519iZge eYs/03ai/ytBwKoKeQmOX9IHVAAm1pTNUYNBd0RtV+OAb1aVL8B7TsN5Okig==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The __malloc attribute should not be applied to "realloc" functions, as
the returned pointer may alias the storage of the prior pointer. Instead
of splitting __malloc from __alloc_size, which would be a huge amount of
churn, just create __realloc_size for the few cases where it is needed.

Additionally removes the conditional test for __alloc_size__, which is
always defined now.

Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Marco Elver <elver@google.com>
Cc: linux-mm@kvack.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/compiler_types.h | 13 +++++--------
 include/linux/slab.h           | 12 ++++++------
 mm/slab_common.c               |  4 ++--
 3 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
index 4f2a819fd60a..f141a6f6b9f6 100644
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -271,15 +271,12 @@ struct ftrace_likely_data {
 
 /*
  * Any place that could be marked with the "alloc_size" attribute is also
- * a place to be marked with the "malloc" attribute. Do this as part of the
- * __alloc_size macro to avoid redundant attributes and to avoid missing a
- * __malloc marking.
+ * a place to be marked with the "malloc" attribute, except those that may
+ * be performing a _reallocation_, as that may alias the existing pointer.
+ * For these, use __realloc_size().
  */
-#ifdef __alloc_size__
-# define __alloc_size(x, ...)	__alloc_size__(x, ## __VA_ARGS__) __malloc
-#else
-# define __alloc_size(x, ...)	__malloc
-#endif
+#define __alloc_size(x, ...)	__alloc_size__(x, ## __VA_ARGS__) __malloc
+#define __realloc_size(x, ...)	__alloc_size__(x, ## __VA_ARGS__)
 
 #ifndef asm_volatile_goto
 #define asm_volatile_goto(x...) asm goto(x)
diff --git a/include/linux/slab.h b/include/linux/slab.h
index 0fefdf528e0d..41bd036e7551 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -184,7 +184,7 @@ int kmem_cache_shrink(struct kmem_cache *s);
 /*
  * Common kmalloc functions provided by all allocators
  */
-void * __must_check krealloc(const void *objp, size_t new_size, gfp_t flags) __alloc_size(2);
+void * __must_check krealloc(const void *objp, size_t new_size, gfp_t flags) __realloc_size(2);
 void kfree(const void *objp);
 void kfree_sensitive(const void *objp);
 size_t __ksize(const void *objp);
@@ -647,10 +647,10 @@ static inline __alloc_size(1, 2) void *kmalloc_array(size_t n, size_t size, gfp_
  * @new_size: new size of a single member of the array
  * @flags: the type of memory to allocate (see kmalloc)
  */
-static inline __alloc_size(2, 3) void * __must_check krealloc_array(void *p,
-								    size_t new_n,
-								    size_t new_size,
-								    gfp_t flags)
+static inline __realloc_size(2, 3) void * __must_check krealloc_array(void *p,
+								      size_t new_n,
+								      size_t new_size,
+								      gfp_t flags)
 {
 	size_t bytes;
 
@@ -774,7 +774,7 @@ static inline __alloc_size(1, 2) void *kvcalloc(size_t n, size_t size, gfp_t fla
 }
 
 extern void *kvrealloc(const void *p, size_t oldsize, size_t newsize, gfp_t flags)
-		      __alloc_size(3);
+		      __realloc_size(3);
 extern void kvfree(const void *addr);
 extern void kvfree_sensitive(const void *addr, size_t len);
 
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 17996649cfe3..457671ace7eb 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1134,8 +1134,8 @@ module_init(slab_proc_init);
 
 #endif /* CONFIG_SLAB || CONFIG_SLUB_DEBUG */
 
-static __always_inline void *__do_krealloc(const void *p, size_t new_size,
-					   gfp_t flags)
+static __always_inline __realloc_size(2) void *
+__do_krealloc(const void *p, size_t new_size, gfp_t flags)
 {
 	void *ret;
 	size_t ks;
-- 
2.34.1

