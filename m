Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 515835E8437
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 22:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233236AbiIWUkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 16:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233194AbiIWUkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 16:40:25 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED05814F83C
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:35:37 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id s14-20020a17090a6e4e00b0020057c70943so6966317pjm.1
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=KTqecIsN+rZ/r5vRTPXwhG2Fjp/tipSlLDdfMKYcgLM=;
        b=f94Wfd7xAB1tMy6calf6l5p3x+2in7DyzsV50yDKB7taURdsPaCM2OydY1fFaru/ZW
         GjJIt1JF0yieLkvcBlF4pMte8sdTYkDdvEAsIZ7RUdwd9PufKMe5RpGZe3MTKJDT6pI8
         HpvD4dvO90+mj+6aFpo4NQqtgUTesDjf+bmbw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=KTqecIsN+rZ/r5vRTPXwhG2Fjp/tipSlLDdfMKYcgLM=;
        b=cg0/4J7EgksQ1mgq6Qxk4H3UWw/HjTTiI43J/aOVr63/Bssl90h5ak/VJz4QU3/Ea2
         CqPxXdKWHLUt4JfxKIpl4nffRqTXFAGfji4fATw7QZUPe6m9Bnu2hJtN53p2S7diUR2e
         zBsFLQnZgm7OOV5GLJ5djYZqWyvdoCshSmmQkPwj03eNXsEneWPjaTWXxraHL+LK1zAf
         EgzBi/1TOuMbTWcMzf/jHwDdw2Y6sOTgzjKC3ROu7BNbDyyupM1n0Ng1/5HCzJIIupxm
         dPi+Cp0yL4RokyeCHDh86TLhLxsJgH9IgsMl4EaIBktzMXxjG4ODq0Qd/VGPwDLE0l7o
         rWaw==
X-Gm-Message-State: ACrzQf3w0BYYdqbIuR41Ms7foTHuoDGzp57srnxEXr2xxTNYI/Ty9NLj
        /DajuZVIhbXbb+rNnTcTodcmrg==
X-Google-Smtp-Source: AMsMyM7vRbdvmLwAu4r0h4O20VFgjtnhlCkk0pZbrUyBGB40i196nKU6gbtNpTH2GFxoX0kIPq3SIA==
X-Received: by 2002:a17:903:244d:b0:178:a0eb:d4bc with SMTP id l13-20020a170903244d00b00178a0ebd4bcmr10401235pls.33.1663965329543;
        Fri, 23 Sep 2022 13:35:29 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id n2-20020a170902d2c200b001715a939ac5sm6372093plc.295.2022.09.23.13.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 13:35:28 -0700 (PDT)
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
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        linux-mm@kvack.org, kasan-dev@googlegroups.com,
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
        Yonghong Song <yhs@fb.com>, Marco Elver <elver@google.com>,
        Miguel Ojeda <ojeda@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-fsdevel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, dev@openvswitch.org,
        x86@kernel.org, llvm@lists.linux.dev,
        linux-hardening@vger.kernel.org
Subject: [PATCH v2 15/16] mm: Make ksize() a reporting-only function
Date:   Fri, 23 Sep 2022 13:28:21 -0700
Message-Id: <20220923202822.2667581-16-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220923202822.2667581-1-keescook@chromium.org>
References: <20220923202822.2667581-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4409; h=from:subject; bh=eTOvroLnBC5lEfD5J+pHwkaq4l0Z2pdeLmvVu9h6d+U=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjLhbmYN/aRzOKQ1vH75NEteIR/Vhz22yGW0UEIcgR Yp367AqJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYy4W5gAKCRCJcvTf3G3AJiNkD/ 92DJis5bkVWVuBFAf6aPfGIKZn18fqqWhgDNIB1gL3+/JoYlzCund6gFEcY8zTobmS/RbZGu3aZ6aG eGxVM7yZ+jxRPM4eiG3l1HwhmL3cHQjHtqkRmDgIyPZ9xwxYKivuUOcVZws84e+7hawBwlAhMt8li+ bgO93T234fS5FLzN/RobhSkg6ISNsI03S8QmlYHytLaSLXUZwSR0/mPUZnFFUrJZk61wAHwMxs68nu PInfWb4QkBwNwAwxJn7jG6OEI5/PSX0n80TMD9CEDNK8sroaMS2C4k5gxVvI8qQZGlT6YpdDGy5BFI oEYbO9baL9bYedtNrwWblW1L3ZmdrGVL1MbXkb3ToBxpDPvQrgQHkNTDqQsY4nttLsp3PP7SZolYSA EuyQgZv8SE2uzK0Y60dBBdrNDexKK0+R5g1mk0Fk/fCLG+1/b859Ulh7OdVyoMlBRQRnPMPCaAyju1 28AEPnC9DBu3Gim8BVHKN3GTgZ0QlUPONvmBGSbAWx359vzIQcmmHIqEMaug8yVrFqRB+cIVXcvtuT EI3ZSAAQpODVZpTsW0ZJatcd0IVMg0oWKcDLxZqolmsP3Ns+cC1eix7TMk2B/1g377zgGeJaByDfib tGymOAoaYv3yr/v92FdCHUFaW37DaZ7ARFElDKWqSBGJtj//OOcTik6X79dA==
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

With all "silently resizing" callers of ksize() refactored, remove the
logic in ksize() that would allow it to be used to effectively change
the size of an allocation (bypassing __alloc_size hints, etc). Users
wanting this feature need to either use kmalloc_size_roundup() before an
allocation, or call krealloc() directly.

For kfree_sensitive(), move the unpoisoning logic inline. Replace the
open-coded ksize() in __do_krealloc with ksize() now that it doesn't
perform unpoisoning.

Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: linux-mm@kvack.org
Cc: kasan-dev@googlegroups.com
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 mm/slab_common.c | 38 ++++++++++++++------------------------
 1 file changed, 14 insertions(+), 24 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index d7420cf649f8..60b77bcdc2e3 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1160,13 +1160,8 @@ __do_krealloc(const void *p, size_t new_size, gfp_t flags)
 	void *ret;
 	size_t ks;
 
-	/* Don't use instrumented ksize to allow precise KASAN poisoning. */
-	if (likely(!ZERO_OR_NULL_PTR(p))) {
-		if (!kasan_check_byte(p))
-			return NULL;
-		ks = kfence_ksize(p) ?: __ksize(p);
-	} else
-		ks = 0;
+	/* How large is the allocation actually? */
+	ks = ksize(p);
 
 	/* If the object still fits, repoison it precisely. */
 	if (ks >= new_size) {
@@ -1232,8 +1227,10 @@ void kfree_sensitive(const void *p)
 	void *mem = (void *)p;
 
 	ks = ksize(mem);
-	if (ks)
+	if (ks) {
+		kasan_unpoison_range(mem, ks);
 		memzero_explicit(mem, ks);
+	}
 	kfree(mem);
 }
 EXPORT_SYMBOL(kfree_sensitive);
@@ -1242,10 +1239,11 @@ EXPORT_SYMBOL(kfree_sensitive);
  * ksize - get the actual amount of memory allocated for a given object
  * @objp: Pointer to the object
  *
- * kmalloc may internally round up allocations and return more memory
+ * kmalloc() may internally round up allocations and return more memory
  * than requested. ksize() can be used to determine the actual amount of
- * memory allocated. The caller may use this additional memory, even though
- * a smaller amount of memory was initially specified with the kmalloc call.
+ * allocated memory. The caller may NOT use this additional memory, unless
+ * it calls krealloc(). To avoid an alloc/realloc cycle, callers can use
+ * kmalloc_size_roundup() to find the size of the associated kmalloc bucket.
  * The caller must guarantee that objp points to a valid object previously
  * allocated with either kmalloc() or kmem_cache_alloc(). The object
  * must not be freed during the duration of the call.
@@ -1254,13 +1252,11 @@ EXPORT_SYMBOL(kfree_sensitive);
  */
 size_t ksize(const void *objp)
 {
-	size_t size;
-
 	/*
-	 * We need to first check that the pointer to the object is valid, and
-	 * only then unpoison the memory. The report printed from ksize() is
-	 * more useful, then when it's printed later when the behaviour could
-	 * be undefined due to a potential use-after-free or double-free.
+	 * We need to first check that the pointer to the object is valid.
+	 * The KASAN report printed from ksize() is more useful, then when
+	 * it's printed later when the behaviour could be undefined due to
+	 * a potential use-after-free or double-free.
 	 *
 	 * We use kasan_check_byte(), which is supported for the hardware
 	 * tag-based KASAN mode, unlike kasan_check_read/write().
@@ -1274,13 +1270,7 @@ size_t ksize(const void *objp)
 	if (unlikely(ZERO_OR_NULL_PTR(objp)) || !kasan_check_byte(objp))
 		return 0;
 
-	size = kfence_ksize(objp) ?: __ksize(objp);
-	/*
-	 * We assume that ksize callers could use whole allocated area,
-	 * so we need to unpoison this area.
-	 */
-	kasan_unpoison_range(objp, size);
-	return size;
+	return kfence_ksize(objp) ?: __ksize(objp);
 }
 EXPORT_SYMBOL(ksize);
 
-- 
2.34.1

