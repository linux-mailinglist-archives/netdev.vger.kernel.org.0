Return-Path: <netdev+bounces-6783-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 867C1717F6F
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 14:03:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2210A1C20DEF
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 12:03:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3F6914283;
	Wed, 31 May 2023 12:03:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D0612B8C
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 12:03:09 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECACC101
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 05:03:06 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8F9A82186F;
	Wed, 31 May 2023 12:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1685534585; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V1MgUINu6VN5FOnOzZYKCCSI90Win23BAGRGSHk2NhM=;
	b=YeG01zv5E06hAk2B+F6RsmzWsLfK1As+brW+QGXuVqEO0vnitZbi8chts9WT4VQtLMCQDs
	9wdelJYryAp6yepqeLVmhRs5OY/wLKrO0CMoain1NQSRLzFLdH8KT7S3lNfaJGotyV7FBp
	5cLxxoeJX0l0XStKJMSdDX4FwfGrkpg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1685534585;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V1MgUINu6VN5FOnOzZYKCCSI90Win23BAGRGSHk2NhM=;
	b=GI4HuYm5gHk3+dqrbtLqjGhg9bomTJrI28yBgAEGfD/Osq1HAar7EBX70u9h817kCS1Mgh
	zX8qW4/AtecpWgBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 570BE138E8;
	Wed, 31 May 2023 12:03:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id 0a5FFHk3d2SlWQAAMHmgww
	(envelope-from <vbabka@suse.cz>); Wed, 31 May 2023 12:03:05 +0000
Message-ID: <81597717-0fed-5fd0-37d0-857d976b9d40@suse.cz>
Date: Wed, 31 May 2023 14:03:05 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH RFC] mm+net: allow to set kmem_cache create flag for
 SLAB_NEVER_MERGE
To: Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
 linux-mm@kvack.org
Cc: Christoph Lameter <cl@linux.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Mel Gorman <mgorman@techsingularity.net>,
 Joonsoo Kim <iamjoonsoo.kim@lge.com>, penberg@kernel.org,
 Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>,
 edumazet@google.com, pabeni@redhat.com, Matthew Wilcox
 <willy@infradead.org>, Hyeonggon Yoo <42.hyeyoo@gmail.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, David Sterba <dsterba@suse.com>
References: <167396280045.539803.7540459812377220500.stgit@firesoul>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <167396280045.539803.7540459812377220500.stgit@firesoul>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 1/17/23 14:40, Jesper Dangaard Brouer wrote:
> Allow API users of kmem_cache_create to specify that they don't want
> any slab merge or aliasing (with similar sized objects). Use this in
> network stack and kfence_test.
> 
> The SKB (sk_buff) kmem_cache slab is critical for network performance.
> Network stack uses kmem_cache_{alloc,free}_bulk APIs to gain
> performance by amortising the alloc/free cost.
> 
> For the bulk API to perform efficiently the slub fragmentation need to
> be low. Especially for the SLUB allocator, the efficiency of bulk free
> API depend on objects belonging to the same slab (page).
> 
> When running different network performance microbenchmarks, I started
> to notice that performance was reduced (slightly) when machines had
> longer uptimes. I believe the cause was 'skbuff_head_cache' got
> aliased/merged into the general slub for 256 bytes sized objects (with
> my kernel config, without CONFIG_HARDENED_USERCOPY).
> 
> For SKB kmem_cache network stack have reasons for not merging, but it
> varies depending on kernel config (e.g. CONFIG_HARDENED_USERCOPY).
> We want to explicitly set SLAB_NEVER_MERGE for this kmem_cache.
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Since this idea was revived by David [1], and neither patch worked as is,
but yours was more complete and first, I have fixed it up as below. The
skbuff part itself will be best submitted separately afterwards so we don't
get conflicts between trees etc. Comments?

----8<----
From 485d3f58f3e797306b803102573e7f1367af2ad2 Mon Sep 17 00:00:00 2001
From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Tue, 17 Jan 2023 14:40:00 +0100
Subject: [PATCH] mm/slab: introduce kmem_cache flag SLAB_NO_MERGE

Allow API users of kmem_cache_create to specify that they don't want
any slab merge or aliasing (with similar sized objects). Use this in
kfence_test.

The SKB (sk_buff) kmem_cache slab is critical for network performance.
Network stack uses kmem_cache_{alloc,free}_bulk APIs to gain
performance by amortising the alloc/free cost.

For the bulk API to perform efficiently the slub fragmentation need to
be low. Especially for the SLUB allocator, the efficiency of bulk free
API depend on objects belonging to the same slab (page).

When running different network performance microbenchmarks, I started
to notice that performance was reduced (slightly) when machines had
longer uptimes. I believe the cause was 'skbuff_head_cache' got
aliased/merged into the general slub for 256 bytes sized objects (with
my kernel config, without CONFIG_HARDENED_USERCOPY).

For SKB kmem_cache network stack have reasons for not merging, but it
varies depending on kernel config (e.g. CONFIG_HARDENED_USERCOPY).
We want to explicitly set SLAB_NO_MERGE for this kmem_cache.

Another use case for the flag has been described by David Sterba [1]:

> This can be used for more fine grained control over the caches or for
> debugging builds where separate slabs can verify that no objects leak.

> The slab_nomerge boot option is too coarse and would need to be
> enabled on all testing hosts. There are some other ways how to disable
> merging, e.g. a slab constructor but this disables poisoning besides
> that it adds additional overhead. Other flags are internal and may
> have other semantics.

> A concrete example what motivates the flag. During 'btrfs balance'
> slab top reported huge increase in caches like

>  1330095 1330095 100%    0.10K  34105       39    136420K Acpi-ParseExt
>  1734684 1734684 100%    0.14K  61953       28    247812K pid_namespace
>  8244036 6873075  83%    0.11K 229001       36    916004K khugepaged_mm_slot

> which was confusing and that it's because of slab merging was not the
> first idea.  After rebooting with slab_nomerge all the caches were
> from btrfs_ namespace as expected.

[1] https://lore.kernel.org/all/20230524101748.30714-1-dsterba@suse.com/

[ vbabka@suse.cz: rename to SLAB_NO_MERGE, change the flag value to the
  one proposed by David so it does not collide with internal SLAB/SLUB
  flags, write a comment for the flag, expand changelog, drop the skbuff
  part to be handled spearately ]

Reported-by: David Sterba <dsterba@suse.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 include/linux/slab.h    | 12 ++++++++++++
 mm/kfence/kfence_test.c |  7 +++----
 mm/slab.h               |  5 +++--
 mm/slab_common.c        |  2 +-
 4 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 6b3e155b70bf..72bc906d8bc7 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -106,6 +106,18 @@
 /* Avoid kmemleak tracing */
 #define SLAB_NOLEAKTRACE	((slab_flags_t __force)0x00800000U)
 
+/*
+ * Prevent merging with compatible kmem caches. This flag should be used
+ * cautiously. Valid use cases:
+ *
+ * - caches created for self-tests (e.g. kunit)
+ * - general caches created and used by a subsystem, only when a
+ *   (subsystem-specific) debug option is enabled
+ * - performance critical caches, should be very rare and consulted with slab
+ *   maintainers, and not used together with CONFIG_SLUB_TINY
+ */
+#define SLAB_NO_MERGE		((slab_flags_t __force)0x01000000U)
+
 /* Fault injection mark */
 #ifdef CONFIG_FAILSLAB
 # define SLAB_FAILSLAB		((slab_flags_t __force)0x02000000U)
diff --git a/mm/kfence/kfence_test.c b/mm/kfence/kfence_test.c
index 6aee19a79236..9e008a336d9f 100644
--- a/mm/kfence/kfence_test.c
+++ b/mm/kfence/kfence_test.c
@@ -191,11 +191,10 @@ static size_t setup_test_cache(struct kunit *test, size_t size, slab_flags_t fla
 	kunit_info(test, "%s: size=%zu, ctor=%ps\n", __func__, size, ctor);
 
 	/*
-	 * Use SLAB_NOLEAKTRACE to prevent merging with existing caches. Any
-	 * other flag in SLAB_NEVER_MERGE also works. Use SLAB_ACCOUNT to
-	 * allocate via memcg, if enabled.
+	 * Use SLAB_NO_MERGE to prevent merging with existing caches.
+	 * Use SLAB_ACCOUNT to allocate via memcg, if enabled.
 	 */
-	flags |= SLAB_NOLEAKTRACE | SLAB_ACCOUNT;
+	flags |= SLAB_NO_MERGE | SLAB_ACCOUNT;
 	test_cache = kmem_cache_create("test", size, 1, flags, ctor);
 	KUNIT_ASSERT_TRUE_MSG(test, test_cache, "could not create cache");
 
diff --git a/mm/slab.h b/mm/slab.h
index f01ac256a8f5..9005ddc51cf8 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -294,11 +294,11 @@ static inline bool is_kmalloc_cache(struct kmem_cache *s)
 #if defined(CONFIG_SLAB)
 #define SLAB_CACHE_FLAGS (SLAB_MEM_SPREAD | SLAB_NOLEAKTRACE | \
 			  SLAB_RECLAIM_ACCOUNT | SLAB_TEMPORARY | \
-			  SLAB_ACCOUNT)
+			  SLAB_ACCOUNT | SLAB_NO_MERGE)
 #elif defined(CONFIG_SLUB)
 #define SLAB_CACHE_FLAGS (SLAB_NOLEAKTRACE | SLAB_RECLAIM_ACCOUNT | \
 			  SLAB_TEMPORARY | SLAB_ACCOUNT | \
-			  SLAB_NO_USER_FLAGS | SLAB_KMALLOC)
+			  SLAB_NO_USER_FLAGS | SLAB_KMALLOC | SLAB_NO_MERGE)
 #else
 #define SLAB_CACHE_FLAGS (SLAB_NOLEAKTRACE)
 #endif
@@ -319,6 +319,7 @@ static inline bool is_kmalloc_cache(struct kmem_cache *s)
 			      SLAB_TEMPORARY | \
 			      SLAB_ACCOUNT | \
 			      SLAB_KMALLOC | \
+			      SLAB_NO_MERGE | \
 			      SLAB_NO_USER_FLAGS)
 
 bool __kmem_cache_empty(struct kmem_cache *);
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 607249785c07..0e0a617eae7d 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -47,7 +47,7 @@ static DECLARE_WORK(slab_caches_to_rcu_destroy_work,
  */
 #define SLAB_NEVER_MERGE (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
 		SLAB_TRACE | SLAB_TYPESAFE_BY_RCU | SLAB_NOLEAKTRACE | \
-		SLAB_FAILSLAB | kasan_never_merge())
+		SLAB_FAILSLAB | SLAB_NO_MERGE | kasan_never_merge())
 
 #define SLAB_MERGE_SAME (SLAB_RECLAIM_ACCOUNT | SLAB_CACHE_DMA | \
 			 SLAB_CACHE_DMA32 | SLAB_ACCOUNT)
-- 
2.40.1



