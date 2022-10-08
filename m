Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3E6F5F820C
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 03:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbiJHBkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 21:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiJHBkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 21:40:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 292553C171;
        Fri,  7 Oct 2022 18:40:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE307B8242E;
        Sat,  8 Oct 2022 01:40:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F81CC433D6;
        Sat,  8 Oct 2022 01:40:20 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="m7dkF4Qq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1665193218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vNH2mnpIcj00WUdnQLlhiavniZvHilK6oGwgWIcL7uw=;
        b=m7dkF4QqvbJypdgEAbc35NBJnnqvQzB21sgNt0EURJQOR1FGkUsyi73yIMXgdPHVIIUlOg
        5CTO5f2vbWzw/vm/odmtp7dHuxfMwfhY9ZkhyfcncvX8HsEngEbDzs4FmPwfNkPExdyoZz
        X0uIWOW2Vu+MHRe3zl9le1EOdBfLqFs=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f0b17dc7 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sat, 8 Oct 2022 01:40:18 +0000 (UTC)
Date:   Fri, 7 Oct 2022 19:40:07 -0600
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc:     linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        andreas.noever@gmail.com, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, bp@alien8.de,
        catalin.marinas@arm.com, christoph.boehmwalder@linbit.com,
        hch@lst.de, christophe.leroy@csgroup.eu, daniel@iogearbox.net,
        airlied@redhat.com, dave.hansen@linux.intel.com,
        davem@davemloft.net, edumazet@google.com, fw@strlen.de,
        gregkh@linuxfoundation.org, hpa@zytor.com, hca@linux.ibm.com,
        deller@gmx.de, herbert@gondor.apana.org.au, chenhuacai@kernel.org,
        hughd@google.com, kuba@kernel.org, jejb@linux.ibm.com,
        jack@suse.com, jgg@ziepe.ca, axboe@kernel.dk,
        johannes@sipsolutions.net, corbet@lwn.net, kadlec@netfilter.org,
        kpsingh@kernel.org, keescook@chromium.org, elver@google.com,
        mchehab@kernel.org, mpe@ellerman.id.au, pablo@netfilter.org,
        pabeni@redhat.com, peterz@infradead.org, richard@nod.at,
        linux@armlinux.org.uk, tytso@mit.edu, tsbogend@alpha.franken.de,
        tglx@linutronix.de, tgraf@suug.ch, ulf.hansson@linaro.org,
        vigneshr@ti.com, kernel@xen0n.name, will@kernel.org,
        yury.norov@gmail.com, dri-devel@lists.freedesktop.org,
        kasan-dev@googlegroups.com, kernel-janitors@vger.kernel.org,
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
        sparclinux@vger.kernel.org, x86@kernel.org, toke@toke.dk,
        chuck.lever@oracle.com, jack@suse.cz,
        mika.westerberg@linux.intel.com
Subject: Re: [PATCH v4 4/6] treewide: use get_random_u32() when possible
Message-ID: <Y0DU93wMsDwlLmMP@zx2c4.com>
References: <20221007180107.216067-1-Jason@zx2c4.com>
 <20221007180107.216067-5-Jason@zx2c4.com>
 <3216619.44csPzL39Z@daneel.sf-tec.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3216619.44csPzL39Z@daneel.sf-tec.de>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 07, 2022 at 10:34:47PM +0200, Rolf Eike Beer wrote:
> > diff --git a/arch/parisc/kernel/process.c b/arch/parisc/kernel/process.c
> > index 7c37e09c92da..18c4f0e3e906 100644
> > --- a/arch/parisc/kernel/process.c
> > +++ b/arch/parisc/kernel/process.c
> > @@ -288,7 +288,7 @@ __get_wchan(struct task_struct *p)
> > 
> >  static inline unsigned long brk_rnd(void)
> >  {
> > -	return (get_random_int() & BRK_RND_MASK) << PAGE_SHIFT;
> > +	return (get_random_u32() & BRK_RND_MASK) << PAGE_SHIFT;
> >  }
> 
> Can't this be
> 
>   prandom_u32_max(BRK_RND_MASK + 1) << PAGE_SHIFT
> 
> ? More similar code with other masks follows below.

I guess it can, because BRK_RND_MASK happens to have all its lower bits
set. But as a "_MASK" maybe this isn't a given, and I don't want to
change intended semantics in this patchset. It's also not more
efficient, because BRK_RND_MASK is actually an expression:

    #define BRK_RND_MASK        (is_32bit_task() ? 0x07ffUL : 0x3ffffUL)

So at compile-time, the compiler can't prove that it's <= U16_MAX, since
it isn't always the case, so it'll use get_random_u32() anyway.

[Side note: maybe that compile-time check should become a runtime check,
 but I'll need to do some benchmarking before changing that and
 introducing two added branches to every non-constant invocation, so for
 now it's a compile-time check. Fortunately the vast majority of uses
 are done on inputs the compiler can prove something about.]

> 
> > diff --git a/drivers/gpu/drm/i915/i915_gem_gtt.c
> > b/drivers/gpu/drm/i915/i915_gem_gtt.c index 329ff75b80b9..7bd1861ddbdf
> > 100644
> > --- a/drivers/gpu/drm/i915/i915_gem_gtt.c
> > +++ b/drivers/gpu/drm/i915/i915_gem_gtt.c
> > @@ -137,12 +137,12 @@ static u64 random_offset(u64 start, u64 end, u64 len,
> > u64 align) range = round_down(end - len, align) - round_up(start, align);
> >  	if (range) {
> >  		if (sizeof(unsigned long) == sizeof(u64)) {
> > -			addr = get_random_long();
> > +			addr = get_random_u64();
> >  		} else {
> > -			addr = get_random_int();
> > +			addr = get_random_u32();
> >  			if (range > U32_MAX) {
> >  				addr <<= 32;
> > -				addr |= get_random_int();
> > +				addr |= get_random_u32();
> >  			}
> >  		}
> >  		div64_u64_rem(addr, range, &addr);
> 
> How about 
> 
>  		if (sizeof(unsigned long) == sizeof(u64) || range > 
> U32_MAX)
> 			addr = get_random_u64();
>  		else
> 			addr = get_random_u32();
> 

Yes, maybe, probably, indeed... But I don't want to go wild and start
fixing all the weird algorithms everywhere. My goal is to only make
changes that are "obviously right". But maybe after this lands this is
something that you or I can submit to the i915 people as an
optimization.

> > diff --git a/drivers/infiniband/hw/cxgb4/cm.c
> > b/drivers/infiniband/hw/cxgb4/cm.c index 14392c942f49..499a425a3379 100644
> > --- a/drivers/infiniband/hw/cxgb4/cm.c
> > +++ b/drivers/infiniband/hw/cxgb4/cm.c
> > @@ -734,7 +734,7 @@ static int send_connect(struct c4iw_ep *ep)
> >  				   &ep->com.remote_addr;
> >  	int ret;
> >  	enum chip_type adapter_type = ep->com.dev->rdev.lldi.adapter_type;
> > -	u32 isn = (prandom_u32() & ~7UL) - 1;
> > +	u32 isn = (get_random_u32() & ~7UL) - 1;
> >  	struct net_device *netdev;
> >  	u64 params;
> > 
> > @@ -2469,7 +2469,7 @@ static int accept_cr(struct c4iw_ep *ep, struct
> > sk_buff *skb, }
> > 
> >  	if (!is_t4(adapter_type)) {
> > -		u32 isn = (prandom_u32() & ~7UL) - 1;
> > +		u32 isn = (get_random_u32() & ~7UL) - 1;
> 
> u32 isn = get_random_u32() | 0x7;

Again, maybe so, but same rationale as above.

> >  static void ns_do_bit_flips(struct nandsim *ns, int num)
> >  {
> > -	if (bitflips && prandom_u32() < (1 << 22)) {
> > +	if (bitflips && get_random_u32() < (1 << 22)) {
> 
> Doing "get_random_u16() < (1 << 6)" should have the same probability with only 
> 2 bytes of random, no?

That's very clever. (1<<22)/(1<<32) == (1<<6)/(1<<16). But also, same
rationale as above for not doing that.

Anyway, I realize this is probably disappointing to read. But also, we
can come back to those optimization cases later pretty easily.

Jason
