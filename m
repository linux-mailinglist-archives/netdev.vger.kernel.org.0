Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB1B25F81EA
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 03:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiJHB32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 21:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiJHB3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 21:29:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDDADBC604;
        Fri,  7 Oct 2022 18:29:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60D8FB8248E;
        Sat,  8 Oct 2022 01:29:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C01C433C1;
        Sat,  8 Oct 2022 01:29:12 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="F0WFV840"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1665192550;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2a2X1YlfkZ0pGgKe1BT3qPauqYJUuDonzfwdbODwUj0=;
        b=F0WFV8408bfDyb840yWHYb2sS5Uszq0PMkkmtmrVRBUNL2FY49DLuZ3A8VZX01cjH92PRw
        963/yLDTfSbPjK9v/cSx6ClQtvwOaP31xlyhs5+LtAOzyMXtRqv5atZ8HOk8wnFIOFKYJl
        weXSG5WPTsM48QIVGdJf4b19sbZPAzo=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 08b122db (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sat, 8 Oct 2022 01:29:09 +0000 (UTC)
Date:   Fri, 7 Oct 2022 19:28:59 -0600
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        Andreas Noever <andreas.noever@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoph =?utf-8?Q?B=C3=B6hmwalder?= 
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
Message-ID: <Y0DSW4AAX/yA3CdI@zx2c4.com>
References: <20221007180107.216067-1-Jason@zx2c4.com>
 <20221007180107.216067-3-Jason@zx2c4.com>
 <Y0CXYjV8qMpJxxBa@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y0CXYjV8qMpJxxBa@magnolia>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 07, 2022 at 02:17:22PM -0700, Darrick J. Wong wrote:
> On Fri, Oct 07, 2022 at 12:01:03PM -0600, Jason A. Donenfeld wrote:
> > Rather than incurring a division or requesting too many random bytes for
> > the given range, use the prandom_u32_max() function, which only takes
> > the minimum required bytes from the RNG and avoids divisions.
> > 
> > Reviewed-by: Kees Cook <keescook@chromium.org>
> > Reviewed-by: KP Singh <kpsingh@kernel.org>
> > Reviewed-by: Christoph Böhmwalder <christoph.boehmwalder@linbit.com> # for drbd
> > Reviewed-by: Jan Kara <jack@suse.cz> # for ext2, ext4, and sbitmap
> > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> > ---
> 
> <snip, skip to the xfs part>
> 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index e2bdf089c0a3..6261599bb389 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -1520,7 +1520,7 @@ xfs_alloc_ag_vextent_lastblock(
> >  
> >  #ifdef DEBUG
> >  	/* Randomly don't execute the first algorithm. */
> > -	if (prandom_u32() & 1)
> > +	if (prandom_u32_max(2))
> 
> I wonder if these usecases (picking 0 or 1 randomly) ought to have a
> trivial wrapper to make it more obvious that we want boolean semantics:
> 
> static inline bool prandom_bool(void)
> {
> 	return prandom_u32_max(2);
> }
> 
> 	if (prandom_bool())
> 		use_crazy_algorithm(...);
> 

Yea, I've had a lot of similar ideas there. Part of doing this (initial)
patchset is to get an intuitive sense of what's actually used and how
often. On my list for investigation are a get_random_u32_max() to return
uniform numbers by rejection sampling (prandom_u32_max() doesn't do
that uniformly) and adding a function for booleans or bits < 8. Possible
ideas for the latter include:

   bool get_random_bool(void);
   bool get_random_bool(unsigned int probability);
   bool get_random_bits(u8 bits_less_than_eight);

With the core of all of those involving the same batching as the current
get_random_u{8,16,32,64}() functions, but also buffering the latest byte
and managing how many bits are left in it that haven't been shifted out
yet.

So API-wise, there are a few ways to go, so hopefully this series will
start to give a good picture of what's needed.

One thing I've noticed is that most of the prandom_u32_max(2)
invocations are in debug or test code, so that doesn't need to be
optimized. But kfence does that too in its hot path, so a
get_random_bool() function there would in theory lead to an 8x speed-up.
But I guess I just have to try some things and see.

Anyway, that is a long way to say, I share you curiosity on the matter
and I'm looking into it.

Jason
