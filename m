Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45E835F7FAF
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 23:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbiJGVRh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 17:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbiJGVRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 17:17:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327476745C;
        Fri,  7 Oct 2022 14:17:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC77661B86;
        Fri,  7 Oct 2022 21:17:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08267C433C1;
        Fri,  7 Oct 2022 21:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665177443;
        bh=NdTN1rJRVjwWbCds+aKCtjsrPJHC36DwsRDyq/yjEcM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WvIpI0oG/gjIti+rkj8Wf5M7C1JbY3GYncWq/hiYthoAT8Xj1wLp5LY+7+UsyXWv4
         PJdEwS2IDEHoDsQsp/+vJ/smsSpoVaeZX746jDY4/61qKQkvLeWLSRCUIfoSX5JB6a
         XpKsgI/he+cVWW55H+4e9My6pgLar2oIIk4LtxLpMqCwQAGYOyeCKsXtJtE0tRh/tZ
         jBEidU7YriwTHyzpjy/WQEcDxpjFFdy3lUIkvWXPC858LYibnylNJcRC/9bIaOyieI
         WAosrtInHBHCX0Q7mUSgAO5s3BOWODkWf0IGJ7mGUZ/cZn1WTs4qv5NLKizg/6a3kN
         97ny6FY3znzZw==
Date:   Fri, 7 Oct 2022 14:17:22 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        Andreas Noever <andreas.noever@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoph =?iso-8859-1?Q?B=F6hmwalder?= 
        <christoph.boehmwalder@linbit.com>, Christoph Hellwig <hch@lst.de>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dave Airlie <airlied@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Helge Deller <deller@gmx.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Huacai Chen <chenhuacai@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Jan Kara <jack@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        KP Singh <kpsingh@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Marco Elver <elver@google.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Weinberger <richard@nod.at>,
        Russell King <linux@armlinux.org.uk>,
        Theodore Ts'o <tytso@mit.edu>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thomas Graf <tgraf@suug.ch>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        WANG Xuerui <kernel@xen0n.name>, Will Deacon <will@kernel.org>,
        Yury Norov <yury.norov@gmail.com>,
        dri-devel@lists.freedesktop.org, kasan-dev@googlegroups.com,
        kernel-janitors@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-mm@kvack.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-nvme@lists.infradead.org, linux-parisc@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-um@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        loongarch@lists.linux.dev, netdev@vger.kernel.org,
        sparclinux@vger.kernel.org, x86@kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4 2/6] treewide: use prandom_u32_max() when possible
Message-ID: <Y0CXYjV8qMpJxxBa@magnolia>
References: <20221007180107.216067-1-Jason@zx2c4.com>
 <20221007180107.216067-3-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221007180107.216067-3-Jason@zx2c4.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 07, 2022 at 12:01:03PM -0600, Jason A. Donenfeld wrote:
> Rather than incurring a division or requesting too many random bytes for
> the given range, use the prandom_u32_max() function, which only takes
> the minimum required bytes from the RNG and avoids divisions.
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Reviewed-by: KP Singh <kpsingh@kernel.org>
> Reviewed-by: Christoph Böhmwalder <christoph.boehmwalder@linbit.com> # for drbd
> Reviewed-by: Jan Kara <jack@suse.cz> # for ext2, ext4, and sbitmap
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---

<snip, skip to the xfs part>

> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index e2bdf089c0a3..6261599bb389 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -1520,7 +1520,7 @@ xfs_alloc_ag_vextent_lastblock(
>  
>  #ifdef DEBUG
>  	/* Randomly don't execute the first algorithm. */
> -	if (prandom_u32() & 1)
> +	if (prandom_u32_max(2))

I wonder if these usecases (picking 0 or 1 randomly) ought to have a
trivial wrapper to make it more obvious that we want boolean semantics:

static inline bool prandom_bool(void)
{
	return prandom_u32_max(2);
}

	if (prandom_bool())
		use_crazy_algorithm(...);

But this translation change looks correct to me, so for the XFS parts:
Acked-by: Darrick J. Wong <djwong@kernel.org>

--D


>  		return 0;
>  #endif
>  
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 6cdfd64bc56b..7838b31126e2 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -636,7 +636,7 @@ xfs_ialloc_ag_alloc(
>  	/* randomly do sparse inode allocations */
>  	if (xfs_has_sparseinodes(tp->t_mountp) &&
>  	    igeo->ialloc_min_blks < igeo->ialloc_blks)
> -		do_sparse = prandom_u32() & 1;
> +		do_sparse = prandom_u32_max(2);
>  #endif
>  
>  	/*
> diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
> index 4b71a96190a8..66ee9b4b7925 100644
> --- a/include/linux/nodemask.h
> +++ b/include/linux/nodemask.h
> @@ -509,7 +509,7 @@ static inline int node_random(const nodemask_t *maskp)
>  	w = nodes_weight(*maskp);
>  	if (w)
>  		bit = bitmap_ord_to_pos(maskp->bits,
> -			get_random_int() % w, MAX_NUMNODES);
> +			prandom_u32_max(w), MAX_NUMNODES);
>  	return bit;
>  #else
>  	return 0;
> diff --git a/lib/cmdline_kunit.c b/lib/cmdline_kunit.c
> index e6a31c927b06..a72a2c16066e 100644
> --- a/lib/cmdline_kunit.c
> +++ b/lib/cmdline_kunit.c
> @@ -76,7 +76,7 @@ static void cmdline_test_lead_int(struct kunit *test)
>  		int rc = cmdline_test_values[i];
>  		int offset;
>  
> -		sprintf(in, "%u%s", prandom_u32_max(256), str);
> +		sprintf(in, "%u%s", get_random_int() % 256, str);
>  		/* Only first '-' after the number will advance the pointer */
>  		offset = strlen(in) - strlen(str) + !!(rc == 2);
>  		cmdline_do_one_test(test, in, rc, offset);
> @@ -94,7 +94,7 @@ static void cmdline_test_tail_int(struct kunit *test)
>  		int rc = strcmp(str, "") ? (strcmp(str, "-") ? 0 : 1) : 1;
>  		int offset;
>  
> -		sprintf(in, "%s%u", str, prandom_u32_max(256));
> +		sprintf(in, "%s%u", str, get_random_int() % 256);
>  		/*
>  		 * Only first and leading '-' not followed by integer
>  		 * will advance the pointer.
> diff --git a/lib/kobject.c b/lib/kobject.c
> index 5f0e71ab292c..a0b2dbfcfa23 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -694,7 +694,7 @@ static void kobject_release(struct kref *kref)
>  {
>  	struct kobject *kobj = container_of(kref, struct kobject, kref);
>  #ifdef CONFIG_DEBUG_KOBJECT_RELEASE
> -	unsigned long delay = HZ + HZ * (get_random_int() & 0x3);
> +	unsigned long delay = HZ + HZ * prandom_u32_max(4);
>  	pr_info("kobject: '%s' (%p): %s, parent %p (delayed %ld)\n",
>  		 kobject_name(kobj), kobj, __func__, kobj->parent, delay);
>  	INIT_DELAYED_WORK(&kobj->release, kobject_delayed_cleanup);
> diff --git a/lib/reed_solomon/test_rslib.c b/lib/reed_solomon/test_rslib.c
> index 6faf9c9a6215..4d241bdc88aa 100644
> --- a/lib/reed_solomon/test_rslib.c
> +++ b/lib/reed_solomon/test_rslib.c
> @@ -199,7 +199,7 @@ static int get_rcw_we(struct rs_control *rs, struct wspace *ws,
>  
>  		derrlocs[i] = errloc;
>  
> -		if (ewsc && (prandom_u32() & 1)) {
> +		if (ewsc && prandom_u32_max(2)) {
>  			/* Erasure with the symbol intact */
>  			errlocs[errloc] = 2;
>  		} else {
> diff --git a/lib/sbitmap.c b/lib/sbitmap.c
> index c4f04edf3ee9..ef0661504561 100644
> --- a/lib/sbitmap.c
> +++ b/lib/sbitmap.c
> @@ -21,7 +21,7 @@ static int init_alloc_hint(struct sbitmap *sb, gfp_t flags)
>  		int i;
>  
>  		for_each_possible_cpu(i)
> -			*per_cpu_ptr(sb->alloc_hint, i) = prandom_u32() % depth;
> +			*per_cpu_ptr(sb->alloc_hint, i) = prandom_u32_max(depth);
>  	}
>  	return 0;
>  }
> diff --git a/lib/test_hexdump.c b/lib/test_hexdump.c
> index 0927f44cd478..41a0321f641a 100644
> --- a/lib/test_hexdump.c
> +++ b/lib/test_hexdump.c
> @@ -208,7 +208,7 @@ static void __init test_hexdump_overflow(size_t buflen, size_t len,
>  static void __init test_hexdump_overflow_set(size_t buflen, bool ascii)
>  {
>  	unsigned int i = 0;
> -	int rs = (prandom_u32_max(2) + 1) * 16;
> +	int rs = prandom_u32_max(2) + 1 * 16;
>  
>  	do {
>  		int gs = 1 << i;
> diff --git a/lib/test_vmalloc.c b/lib/test_vmalloc.c
> index 4f2f2d1bac56..56ffaa8dd3f6 100644
> --- a/lib/test_vmalloc.c
> +++ b/lib/test_vmalloc.c
> @@ -151,9 +151,7 @@ static int random_size_alloc_test(void)
>  	int i;
>  
>  	for (i = 0; i < test_loop_count; i++) {
> -		n = prandom_u32();
> -		n = (n % 100) + 1;
> -
> +		n = prandom_u32_max(n % 100) + 1;
>  		p = vmalloc(n * PAGE_SIZE);
>  
>  		if (!p)
> @@ -293,16 +291,12 @@ pcpu_alloc_test(void)
>  		return -1;
>  
>  	for (i = 0; i < 35000; i++) {
> -		unsigned int r;
> -
> -		r = prandom_u32();
> -		size = (r % (PAGE_SIZE / 4)) + 1;
> +		size = prandom_u32_max(PAGE_SIZE / 4) + 1;
>  
>  		/*
>  		 * Maximum PAGE_SIZE
>  		 */
> -		r = prandom_u32();
> -		align = 1 << ((r % 11) + 1);
> +		align = 1 << (prandom_u32_max(11) + 1);
>  
>  		pcpu[i] = __alloc_percpu(size, align);
>  		if (!pcpu[i])
> @@ -393,14 +387,11 @@ static struct test_driver {
>  
>  static void shuffle_array(int *arr, int n)
>  {
> -	unsigned int rnd;
>  	int i, j;
>  
>  	for (i = n - 1; i > 0; i--)  {
> -		rnd = prandom_u32();
> -
>  		/* Cut the range. */
> -		j = rnd % i;
> +		j = prandom_u32_max(i);
>  
>  		/* Swap indexes. */
>  		swap(arr[i], arr[j]);
> diff --git a/net/core/pktgen.c b/net/core/pktgen.c
> index a13ee452429e..5ca4f953034c 100644
> --- a/net/core/pktgen.c
> +++ b/net/core/pktgen.c
> @@ -2469,11 +2469,11 @@ static void mod_cur_headers(struct pktgen_dev *pkt_dev)
>  	}
>  
>  	if ((pkt_dev->flags & F_VID_RND) && (pkt_dev->vlan_id != 0xffff)) {
> -		pkt_dev->vlan_id = prandom_u32() & (4096 - 1);
> +		pkt_dev->vlan_id = prandom_u32_max(4096);
>  	}
>  
>  	if ((pkt_dev->flags & F_SVID_RND) && (pkt_dev->svlan_id != 0xffff)) {
> -		pkt_dev->svlan_id = prandom_u32() & (4096 - 1);
> +		pkt_dev->svlan_id = prandom_u32_max(4096);
>  	}
>  
>  	if (pkt_dev->udp_src_min < pkt_dev->udp_src_max) {
> diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> index b9d995b5ce24..9dc070f2018e 100644
> --- a/net/ipv4/inet_hashtables.c
> +++ b/net/ipv4/inet_hashtables.c
> @@ -794,7 +794,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
>  	 * on low contention the randomness is maximal and on high contention
>  	 * it may be inexistent.
>  	 */
> -	i = max_t(int, i, (prandom_u32() & 7) * 2);
> +	i = max_t(int, i, prandom_u32_max(8) * 2);
>  	WRITE_ONCE(table_perturb[index], READ_ONCE(table_perturb[index]) + i + 2);
>  
>  	/* Head lock still held and bh's disabled */
> diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
> index c3c693b51c94..f075a9fb5ccc 100644
> --- a/net/sunrpc/cache.c
> +++ b/net/sunrpc/cache.c
> @@ -677,7 +677,7 @@ static void cache_limit_defers(void)
>  
>  	/* Consider removing either the first or the last */
>  	if (cache_defer_cnt > DFR_MAX) {
> -		if (prandom_u32() & 1)
> +		if (prandom_u32_max(2))
>  			discard = list_entry(cache_defer_list.next,
>  					     struct cache_deferred_req, recent);
>  		else
> diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
> index e976007f4fd0..c2caee703d2c 100644
> --- a/net/sunrpc/xprtsock.c
> +++ b/net/sunrpc/xprtsock.c
> @@ -1619,7 +1619,7 @@ static int xs_get_random_port(void)
>  	if (max < min)
>  		return -EADDRINUSE;
>  	range = max - min + 1;
> -	rand = (unsigned short) prandom_u32() % range;
> +	rand = (unsigned short) prandom_u32_max(range);
>  	return rand + min;
>  }
>  
> -- 
> 2.37.3
> 
