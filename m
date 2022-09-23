Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29B535E840E
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 22:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233008AbiIWUer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 16:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232804AbiIWUcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 16:32:47 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E792C14C071
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:28:34 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id l10so1152813plb.10
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=09XDqhCmbOxMmk4st3n1VevKxFvu8TBGt9LJYr24nIA=;
        b=C8a8bBwBCPpYqJC0ttlBfkppX2uMw5viHVMSx4NSUdlu6Mk2tJYnIkpj1O3sRUaf2n
         YvaKYhZaGs/8xWczPFhL4W6+saiCUf5KQGmW47sQE/VjI9iBzvPK3eyEePf3h3djFnDv
         4Xw5J5dvAI2eSiF2SIboitvBfMPVts9ASzBRc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=09XDqhCmbOxMmk4st3n1VevKxFvu8TBGt9LJYr24nIA=;
        b=oF5Dx6KtiDIT06fzLcP9nkI54TOkquERjDs824Y/eIx6hVbLE+Amyk7tFG0nrQURzy
         zNDOGDU0Ay3RCCvBNpCINddbYS6qrbsP5g13P8os/OZsov/K/gSyF9CZ7ispuk+EiANJ
         Bo5eNP746KFHvsjB+jYur5I4jKt4xqoXEGtzd9Zounf16/gEq1KJ1mVdLPjXM7b500fb
         suo0QQtiCD8HVeDEBnNUK5pTyMvTaaFv0w/Bn/y91Hv5JAiIT8hJtfthev5GQQVqolrb
         EvmpQQXd7lR7+dU+uJpJdYTZdZXTeQWI+ig991LLp3IAWvGX6Pj5jbjU+2A1eVWphESz
         hxcA==
X-Gm-Message-State: ACrzQf2W40fujC4viugQj9m9qQkX1EwgdL7dYOE98qpGt81MkE1Hm/gU
        +A8Rfp+xv/fY1DP7hc9j0zGM0Q==
X-Google-Smtp-Source: AMsMyM7DXBOfv6ahzpoYpFJ1XA+uXLlf1m80ImgaNTw1lXpXdBLHWAXCKtzP0wavX+dE1aJb2tOr4Q==
X-Received: by 2002:a17:903:2015:b0:178:8022:ff1 with SMTP id s21-20020a170903201500b0017880220ff1mr10285638pla.18.1663964913651;
        Fri, 23 Sep 2022 13:28:33 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id i3-20020aa796e3000000b00535da15a252sm6765031pfq.165.2022.09.23.13.28.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 13:28:32 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Kees Cook <keescook@chromium.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        bpf@vger.kernel.org, "Ruhl, Michael J" <michael.j.ruhl@intel.com>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
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
        Marco Elver <elver@google.com>,
        Miguel Ojeda <ojeda@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-fsdevel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        dev@openvswitch.org, x86@kernel.org, llvm@lists.linux.dev,
        linux-hardening@vger.kernel.org
Subject: [PATCH v2 11/16] bpf: Use kmalloc_size_roundup() to match ksize() usage
Date:   Fri, 23 Sep 2022 13:28:17 -0700
Message-Id: <20220923202822.2667581-12-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220923202822.2667581-1-keescook@chromium.org>
References: <20220923202822.2667581-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4987; h=from:subject; bh=+umEDwGyJCv3Ovyx4Pj2CYIL4lHo8xavtPhh0E8bcL8=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjLhblZrOjZBzDi2GSWosP6rXkUyCU3IxBEiC+Kuw9 wTqv/j+JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYy4W5QAKCRCJcvTf3G3AJjMAEA CfzaZuEjLR7HquBXo8+EM4GS8NWzszH99hX9xWPHebOuW16pmhNIEq+Aju+xJdnrhZANxwQ9Vh+iy8 ymNAeDJdi1cPUvm/XvEjIQdHYJrutoIiSKB2d0AEqLwbsec1LjBhbvhDu0LI7jqNxIfIv2/9Wt0lw+ FLC6qE+PRYixT6MQix4PHQQlKlYq57pj+xWZMmEn7EdqoqjCDsI3K/t90ikcx3WVUqhltKxdMQKBBV x5co1XdfKAeNPVoBf0Q4pGe8YOFn/SbYAQ3SUpg9WyQETPSbnLumwlf27mINUyCKWF27Tg53zEYExy CL2Y77JbZEY8nCSjb5ET/WZ4BJLz8w55BmqKLuG+LHoVxmG9As/KzYhd4wNeF/dVm0OLi7gOh89qzi GEU1kcMn/xDpv1MQ2jDoG8VufwjUDPawkqASsD3lyfggklYm5al7OV0DrKzqFXHwaeBjaWHmM6KLKe 37QfdNfUsWdCuBvcEjoUX7Za+u901T3eO2SKiBvJCpX2sc6vi67INLI4syc1DeZAWI+wioCztNVLto FEw2RcZEC86T5zincgBp5Ofm7ehCRUPa/wet1Ayqkgvsrtnt1X+1xS1o6I1ntxzju/C/TzBCm6nHcb R4gLY+rvdc1IBBznpLWzmV3Cz3ue47gmjjlvg+BX0gGRJVy0rhqVwTrXOpsA==
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

Round up allocations with kmalloc_size_roundup() so that the verifier's
use of ksize() is always accurate and no special handling of the memory
is needed by KASAN, UBSAN_BOUNDS, nor FORTIFY_SOURCE. Pass the new size
information back up to callers so they can use the space immediately,
so array resizing to happen less frequently as well. Explicitly zero
any trailing bytes in new allocations.

Additionally fix a memory allocation leak: if krealloc() fails, "arr"
wasn't freed, but NULL was return to the caller of realloc_array() would
be writing NULL to the lvalue, losing the reference to the original
memory.

Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Song Liu <song@kernel.org>
Cc: Yonghong Song <yhs@fb.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Stanislav Fomichev <sdf@google.com>
Cc: Hao Luo <haoluo@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: bpf@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 kernel/bpf/verifier.c | 49 +++++++++++++++++++++++++++----------------
 1 file changed, 31 insertions(+), 18 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 096fdac70165..80531f8f0d36 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -978,42 +978,53 @@ static void print_insn_state(struct bpf_verifier_env *env,
  */
 static void *copy_array(void *dst, const void *src, size_t n, size_t size, gfp_t flags)
 {
-	size_t bytes;
+	size_t src_bytes, dst_bytes;
 
 	if (ZERO_OR_NULL_PTR(src))
 		goto out;
 
-	if (unlikely(check_mul_overflow(n, size, &bytes)))
+	if (unlikely(check_mul_overflow(n, size, &src_bytes)))
 		return NULL;
 
-	if (ksize(dst) < bytes) {
+	dst_bytes = kmalloc_size_roundup(src_bytes);
+	if (ksize(dst) < dst_bytes) {
 		kfree(dst);
-		dst = kmalloc_track_caller(bytes, flags);
+		dst = kmalloc_track_caller(dst_bytes, flags);
 		if (!dst)
 			return NULL;
 	}
 
-	memcpy(dst, src, bytes);
+	memcpy(dst, src, src_bytes);
+	memset(dst + src_bytes, 0, dst_bytes - src_bytes);
 out:
 	return dst ? dst : ZERO_SIZE_PTR;
 }
 
-/* resize an array from old_n items to new_n items. the array is reallocated if it's too
- * small to hold new_n items. new items are zeroed out if the array grows.
+/* Resize an array from old_n items to *new_n items. The array is reallocated if it's too
+ * small to hold *new_n items. New items are zeroed out if the array grows. Allocation
+ * is rounded up to next kmalloc bucket size to reduce frequency of resizing. *new_n
+ * contains the new total number of items that will fit.
  *
- * Contrary to krealloc_array, does not free arr if new_n is zero.
+ * Contrary to krealloc, does not free arr if new_n is zero.
  */
-static void *realloc_array(void *arr, size_t old_n, size_t new_n, size_t size)
+static void *realloc_array(void *arr, size_t old_n, size_t *new_n, size_t size)
 {
-	if (!new_n || old_n == new_n)
+	void *old_arr = arr;
+	size_t alloc_size;
+
+	if (!new_n || !*new_n || old_n == *new_n)
 		goto out;
 
-	arr = krealloc_array(arr, new_n, size, GFP_KERNEL);
-	if (!arr)
+	alloc_size = kmalloc_size_roundup(size_mul(*new_n, size));
+	arr = krealloc(old_arr, alloc_size, GFP_KERNEL);
+	if (!arr) {
+		kfree(old_arr);
 		return NULL;
+	}
 
-	if (new_n > old_n)
-		memset(arr + old_n * size, 0, (new_n - old_n) * size);
+	*new_n = alloc_size / size;
+	if (*new_n > old_n)
+		memset(arr + old_n * size, 0, (*new_n - old_n) * size);
 
 out:
 	return arr ? arr : ZERO_SIZE_PTR;
@@ -1045,7 +1056,7 @@ static int copy_stack_state(struct bpf_func_state *dst, const struct bpf_func_st
 
 static int resize_reference_state(struct bpf_func_state *state, size_t n)
 {
-	state->refs = realloc_array(state->refs, state->acquired_refs, n,
+	state->refs = realloc_array(state->refs, state->acquired_refs, &n,
 				    sizeof(struct bpf_reference_state));
 	if (!state->refs)
 		return -ENOMEM;
@@ -1061,11 +1072,11 @@ static int grow_stack_state(struct bpf_func_state *state, int size)
 	if (old_n >= n)
 		return 0;
 
-	state->stack = realloc_array(state->stack, old_n, n, sizeof(struct bpf_stack_state));
+	state->stack = realloc_array(state->stack, old_n, &n, sizeof(struct bpf_stack_state));
 	if (!state->stack)
 		return -ENOMEM;
 
-	state->allocated_stack = size;
+	state->allocated_stack = n * BPF_REG_SIZE;
 	return 0;
 }
 
@@ -2472,9 +2483,11 @@ static int push_jmp_history(struct bpf_verifier_env *env,
 {
 	u32 cnt = cur->jmp_history_cnt;
 	struct bpf_idx_pair *p;
+	size_t size;
 
 	cnt++;
-	p = krealloc(cur->jmp_history, cnt * sizeof(*p), GFP_USER);
+	size = kmalloc_size_roundup(size_mul(cnt, sizeof(*p)));
+	p = krealloc(cur->jmp_history, size, GFP_USER);
 	if (!p)
 		return -ENOMEM;
 	p[cnt - 1].idx = env->insn_idx;
-- 
2.34.1

