Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1EB5F82DF
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 05:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbiJHDvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 23:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiJHDux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 23:50:53 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B4C50FB2
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 20:50:46 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id a23so6175494pgi.10
        for <netdev@vger.kernel.org>; Fri, 07 Oct 2022 20:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/+M2MWnKezzvwUdnzvMnzBe5u7rJCxF/Jt+qZLDkYO0=;
        b=FTiUCKipmqUFH72GOvNGAiS4z04PbOMknPHSePECxyT+NR1MKehdmNkDokls+RTwtz
         36ZKjqvAgPt8zH/PagzHgUWgsK7jRV+Fodw+XGTQ49lxGfaN2UCRznQ1vjEUvfGAJQxE
         GFWrUL9ion4oE/GNeI8pk6ab24JqoBKXYgp6c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/+M2MWnKezzvwUdnzvMnzBe5u7rJCxF/Jt+qZLDkYO0=;
        b=IgWd+EK1zwlG8eURJWJaKAsTNddn06l3MWt5vVI+J7F5KyvsAW81cyhq31rtjr45V3
         AhgDEwNgTEfSiWJCCsB0ML2tBLmTlD42FkJcO2qJApxT7p1ekC0zPHgMd8I87ZOPs06v
         Szf0SljGDlJa3X9gg9S0gboT4Hl0h20J9rhbcQtqEZ9HvmWFOnnxHYtbScBcuVTFNs+Z
         2r+/08r3/WK5M0JD/fdtFJ+kUdCTtzLUKzpjX62Mtz8lyBAzY7s/4AeH+bkWFP3TL3MX
         L+vQFiWCNkYLDBaOQS4mPXBS6IFkstu+LG2xGlCoEMS/yzj8i4aDXmQkLV8MFN9ydUs+
         kD/Q==
X-Gm-Message-State: ACrzQf3ydPJtEi+YLbVVCFq8+CVybTL6GchCw07UE1a5Pv57/SPBNPR2
        abhKX6K/C67sclhoeIWPWzOzRA==
X-Google-Smtp-Source: AMsMyM4INOCYNV6QQEtiLxqiwgdjxt33WIim/WmJWLMb2Koq8s6fKC3bMA6hT6FDEf46oKUeZwL22Q==
X-Received: by 2002:a05:6a00:1d83:b0:561:d2f8:b86d with SMTP id z3-20020a056a001d8300b00561d2f8b86dmr8148626pfw.57.1665201045445;
        Fri, 07 Oct 2022 20:50:45 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id i11-20020a17090332cb00b00174c235e1fdsm2288651plr.199.2022.10.07.20.50.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 20:50:44 -0700 (PDT)
Date:   Fri, 7 Oct 2022 20:50:43 -0700
From:   Kees Cook <keescook@chromium.org>
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
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Helge Deller <deller@gmx.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Huacai Chen <chenhuacai@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E. J. Bottomley" <jejb@linux.ibm.com>,
        Jan Kara <jack@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        KP Singh <kpsingh@kernel.org>, Marco Elver <elver@google.com>,
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
Message-ID: <53DD0148-ED15-4294-8496-9E4B4C7AD061@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[resending because I failed to CC]

On October 7, 2022 7:21:28 PM PDT, "Jason A. Donenfeld" <Jason@zx2c4.com> wrote:
>On Fri, Oct 07, 2022 at 03:47:44PM -0700, Kees Cook wrote:
>> On Fri, Oct 07, 2022 at 12:01:03PM -0600, Jason A. Donenfeld wrote:
>> > Rather than incurring a division or requesting too many random bytes for
>> > the given range, use the prandom_u32_max() function, which only takes
>> > the minimum required bytes from the RNG and avoids divisions.
>> 
>> I actually meant splitting the by-hand stuff by subsystem, but nearly
>> all of these can be done mechanically too, so it shouldn't be bad. Notes
>> below...
>
>Oh, cool, more coccinelle. You're basically giving me a class on these
>recipes. Much appreciated.

You're welcome! This was a fun exercise. :)

>
>> > [...]
>> > diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
>> > index 92bcc1768f0b..87203429f802 100644
>> > --- a/arch/arm64/kernel/process.c
>> > +++ b/arch/arm64/kernel/process.c
>> > @@ -595,7 +595,7 @@ unsigned long __get_wchan(struct task_struct *p)
>> >  unsigned long arch_align_stack(unsigned long sp)
>> >  {
>> >  	if (!(current->personality & ADDR_NO_RANDOMIZE) && randomize_va_space)
>> > -		sp -= get_random_int() & ~PAGE_MASK;
>> > +		sp -= prandom_u32_max(PAGE_SIZE);
>> >  	return sp & ~0xf;
>> >  }
>> >  
>> 
>> @mask@
>> expression MASK;
>> @@
>> 
>> - (get_random_int() & ~(MASK))
>> + prandom_u32_max(MASK)
>
>Not quite! PAGE_MASK != PAGE_SIZE. In this case, things get a litttttle
>more complicated where you can do:
>
>get_random_int() & MASK == prandom_u32_max(MASK + 1)
>*only if all the top bits of MASK are set* That is, if MASK one less

Oh whoops! Yes, right, I totally misread SIZE as MASK.

>than a power of two. Or if MASK & (MASK + 1) == 0.
>
>(If those top bits aren't set, you can technically do
>prandom_u32_max(MASK >> n + 1) << n. That'd be a nice thing to work out.
>But yeesh, maybe a bit much for the time being and probably a bit beyond
>coccinelle.)
>
>This case here, though, is a bit more special, where we can just rely on
>an obvious given kernel identity. Namely, PAGE_MASK == ~(PAGE_SIZE - 1).
>So ~PAGE_MASK == PAGE_SIZE - 1.
>So get_random_int() & ~PAGE_MASK == prandom_u32_max(PAGE_SIZE - 1 + 1).
>So get_random_int() & ~PAGE_MASK == prandom_u32_max(PAGE_SIZE).
>
>And most importantly, this makes the code more readable, since everybody
>knows what bounding by PAGE_SIZE means, where as what on earth is
>happening with the &~PAGE_MASK thing. So it's a good change. I'll try to
>teach coccinelle about that special case.

Yeah, it should be possible to just check for the literal.

>
>
>
>> > diff --git a/arch/loongarch/kernel/vdso.c b/arch/loongarch/kernel/vdso.c
>> > index f32c38abd791..8c9826062652 100644
>> > --- a/arch/loongarch/kernel/vdso.c
>> > +++ b/arch/loongarch/kernel/vdso.c
>> > @@ -78,7 +78,7 @@ static unsigned long vdso_base(void)
>> >  	unsigned long base = STACK_TOP;
>> >  
>> >  	if (current->flags & PF_RANDOMIZE) {
>> > -		base += get_random_int() & (VDSO_RANDOMIZE_SIZE - 1);
>> > +		base += prandom_u32_max(VDSO_RANDOMIZE_SIZE);
>> >  		base = PAGE_ALIGN(base);
>> >  	}
>> >  
>> 
>> @minus_one@
>> expression FULL;
>> @@
>> 
>> - (get_random_int() & ((FULL) - 1)
>> + prandom_u32_max(FULL)
>
>Ahh, well, okay, this is the example I mentioned above. Only works if
>FULL is saturated. Any clever way to get coccinelle to prove that? Can
>it look at the value of constants?

I'm not sure if Cocci will do that without a lot of work. The literals trick I used below would need a lot of fanciness. :)

>
>> 
>> > diff --git a/arch/parisc/kernel/vdso.c b/arch/parisc/kernel/vdso.c
>> > index 63dc44c4c246..47e5960a2f96 100644
>> > --- a/arch/parisc/kernel/vdso.c
>> > +++ b/arch/parisc/kernel/vdso.c
>> > @@ -75,7 +75,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm,
>> >  
>> >  	map_base = mm->mmap_base;
>> >  	if (current->flags & PF_RANDOMIZE)
>> > -		map_base -= (get_random_int() & 0x1f) * PAGE_SIZE;
>> > +		map_base -= prandom_u32_max(0x20) * PAGE_SIZE;
>> >  
>> >  	vdso_text_start = get_unmapped_area(NULL, map_base, vdso_text_len, 0, 0);
>> >  
>> 
>> These are more fun, but Coccinelle can still do them with a little
>> Pythonic help:
>> 
>> // Find a potential literal
>> @literal_mask@
>> expression LITERAL;
>> identifier randfunc =~ "get_random_int|prandom_u32|get_random_u32";
>> position p;
>> @@
>> 
>>         (randfunc()@p & (LITERAL))
>> 
>> // Add one to the literal.
>> @script:python add_one@
>> literal << literal_mask.LITERAL;
>> RESULT;
>> @@
>> 
>> if literal.startswith('0x'):
>>         value = int(literal, 16) + 1
>>         coccinelle.RESULT = cocci.make_expr("0x%x" % (value))
>> elif literal[0] in '123456789':
>>         value = int(literal, 10) + 1
>>         coccinelle.RESULT = cocci.make_expr("%d" % (value))
>> else:
>>         print("I don't know how to handle: %s" % (literal))
>> 
>> // Replace the literal mask with the calculated result.
>> @plus_one@
>> expression literal_mask.LITERAL;
>> position literal_mask.p;
>> expression add_one.RESULT;
>> identifier FUNC;
>> @@
>> 
>> -       (FUNC()@p & (LITERAL))
>> +       prandom_u32_max(RESULT)
>
>Oh that's pretty cool. I can do the saturation check in python, since
>`value` holds the parsed result. Neat.

It is (at least how I have it here) just the string, so YMMV.

>
>> > diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
>> > index 998dd2ac8008..f4944c4dee60 100644
>> > --- a/fs/ext2/ialloc.c
>> > +++ b/fs/ext2/ialloc.c
>> > @@ -277,8 +277,7 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent)
>> >  		int best_ndir = inodes_per_group;
>> >  		int best_group = -1;
>> >  
>> > -		group = prandom_u32();
>> > -		parent_group = (unsigned)group % ngroups;
>> > +		parent_group = prandom_u32_max(ngroups);
>> >  		for (i = 0; i < ngroups; i++) {
>> >  			group = (parent_group + i) % ngroups;
>> >  			desc = ext2_get_group_desc (sb, group, NULL);
>> 
>> Okay, that one is too much for me -- checking that group is never used
>> after the assignment removal is likely possible, but beyond my cocci
>> know-how. :)
>
>Yea this is a tricky one, which I initially didn't do by hand, but Jan
>seemed fine with it, and it's clear if you look at it. Trixy cocci
>indeed.

I asked on the Cocci list[1], since by the time I got to the end of your "by hand" patch I *really* wanted to have it work. I was so close!


>
>> > diff --git a/lib/test_hexdump.c b/lib/test_hexdump.c
>> > index 0927f44cd478..41a0321f641a 100644
>> > --- a/lib/test_hexdump.c
>> > +++ b/lib/test_hexdump.c
>> > @@ -208,7 +208,7 @@ static void __init test_hexdump_overflow(size_t buflen, size_t len,
>> >  static void __init test_hexdump_overflow_set(size_t buflen, bool ascii)
>> >  {
>> >  	unsigned int i = 0;
>> > -	int rs = (prandom_u32_max(2) + 1) * 16;
>> > +	int rs = prandom_u32_max(2) + 1 * 16;
>> >  
>> >  	do {
>> >  		int gs = 1 << i;
>> 
>> This looks wrong. Cocci says:
>> 
>> -       int rs = (get_random_int() % 2 + 1) * 16;
>> +       int rs = (prandom_u32_max(2) + 1) * 16;
>
>!! Nice catch.
>
>Alright, I'll give this a try with more cocci. The big difficulty at the
>moment is the power of 2 constant checking thing. If you have any
>pointers on that, would be nice.
>
>Thanks a bunch for the guidance.

Sure thing! I was pleased to figure out how to do the python bit.

-Kees

[1] actually, I don't see it on lore... I will resend it

-- 
Kees Cook
