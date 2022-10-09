Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEB8D5F889F
	for <lists+netdev@lfdr.de>; Sun,  9 Oct 2022 02:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiJIA0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Oct 2022 20:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiJIA0Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Oct 2022 20:26:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F5D22E9FB;
        Sat,  8 Oct 2022 17:26:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA4A960B29;
        Sun,  9 Oct 2022 00:26:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A7A8C43142;
        Sun,  9 Oct 2022 00:26:21 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="PX4nnIOK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1665275176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7zZXtzJcFLYkSrXJJYKIVFffp4v7t60F00p3NU1sSks=;
        b=PX4nnIOKh3FHa9d1G132kBTXFxz7qYQBOTukTgSGG6fc4aKl+1ua8ttlw/vsoBqgsW+CHC
        NTGzZbQmolIFuqf8+kDGOqJtdV61Oxsts7vNgF2zGCk6Fi2PVF9YyHTL3BJyD+I6xXQNse
        S5HVOwfe+G2V37JJFP20h8mZS0WLTwM=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 9a9a9268 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sun, 9 Oct 2022 00:26:15 +0000 (UTC)
Received: by mail-ua1-f42.google.com with SMTP id i20so2853853ual.4;
        Sat, 08 Oct 2022 17:26:12 -0700 (PDT)
X-Gm-Message-State: ACrzQf3Wjg3OFrVFWd3xt6aGIRFkt/c9uMxhTuPtcyIAkwN2yc3FLGiN
        2KRFuspzQ4ilrmTnT6wNLAZnPPKKcFMMdZKoRuc=
X-Google-Smtp-Source: AMsMyM7Ghd+rNLLkdUe772S1SZ8rADl1G6UAF0aO2TFON1i86eRArx6SOwts50zdZDWmmLpyXWt8nLKkLulPCRn4G5w=
X-Received: by 2002:ab0:70b9:0:b0:3d7:84d8:35ae with SMTP id
 q25-20020ab070b9000000b003d784d835aemr6771029ual.24.1665275171232; Sat, 08
 Oct 2022 17:26:11 -0700 (PDT)
MIME-Version: 1.0
References: <20221007180107.216067-1-Jason@zx2c4.com> <20221007180107.216067-5-Jason@zx2c4.com>
 <f1ca1b53bc104065a83da60161a4c7b6@AcuMS.aculab.com> <Y0H7rcJ3/JOyDYU8@zx2c4.com>
In-Reply-To: <Y0H7rcJ3/JOyDYU8@zx2c4.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sat, 8 Oct 2022 18:26:00 -0600
X-Gmail-Original-Message-ID: <CAHmME9ojgUnrp+Mys3pzJZ=0C7RHbgsm-wOkWk-GdW2dnJwf8g@mail.gmail.com>
Message-ID: <CAHmME9ojgUnrp+Mys3pzJZ=0C7RHbgsm-wOkWk-GdW2dnJwf8g@mail.gmail.com>
Subject: Re: [PATCH v4 4/6] treewide: use get_random_u32() when possible
To:     David Laight <David.Laight@aculab.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>,
        Andreas Noever <andreas.noever@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        =?UTF-8?Q?Christoph_B=C3=B6hmwalder?= 
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
        "Theodore Ts'o" <tytso@mit.edu>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thomas Graf <tgraf@suug.ch>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        WANG Xuerui <kernel@xen0n.name>, Will Deacon <will@kernel.org>,
        Yury Norov <yury.norov@gmail.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "kasan-dev@googlegroups.com" <kasan-dev@googlegroups.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-um@lists.infradead.org" <linux-um@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        Chuck Lever <chuck.lever@oracle.com>, Jan Kara <jack@suse.cz>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 8, 2022 at 4:37 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Sat, Oct 08, 2022 at 10:18:45PM +0000, David Laight wrote:
> > From: Jason A. Donenfeld
> > > Sent: 07 October 2022 19:01
> > >
> > > The prandom_u32() function has been a deprecated inline wrapper around
> > > get_random_u32() for several releases now, and compiles down to the
> > > exact same code. Replace the deprecated wrapper with a direct call to
> > > the real function. The same also applies to get_random_int(), which is
> > > just a wrapper around get_random_u32().
> > >
> > ...
> > > diff --git a/net/802/garp.c b/net/802/garp.c
> > > index f6012f8e59f0..c1bb67e25430 100644
> > > --- a/net/802/garp.c
> > > +++ b/net/802/garp.c
> > > @@ -407,7 +407,7 @@ static void garp_join_timer_arm(struct garp_applicant *app)
> > >  {
> > >     unsigned long delay;
> > >
> > > -   delay = (u64)msecs_to_jiffies(garp_join_time) * prandom_u32() >> 32;
> > > +   delay = (u64)msecs_to_jiffies(garp_join_time) * get_random_u32() >> 32;
> > >     mod_timer(&app->join_timer, jiffies + delay);
> > >  }
> > >
> > > diff --git a/net/802/mrp.c b/net/802/mrp.c
> > > index 35e04cc5390c..3e9fe9f5d9bf 100644
> > > --- a/net/802/mrp.c
> > > +++ b/net/802/mrp.c
> > > @@ -592,7 +592,7 @@ static void mrp_join_timer_arm(struct mrp_applicant *app)
> > >  {
> > >     unsigned long delay;
> > >
> > > -   delay = (u64)msecs_to_jiffies(mrp_join_time) * prandom_u32() >> 32;
> > > +   delay = (u64)msecs_to_jiffies(mrp_join_time) * get_random_u32() >> 32;
> > >     mod_timer(&app->join_timer, jiffies + delay);
> > >  }
> > >
> >
> > Aren't those:
> >       delay = prandom_u32_max(msecs_to_jiffies(xxx_join_time));
>
> Probably, but too involved and peculiar for this cleanup.
>
> Feel free to send a particular patch to that maintainer.

I guess the cocci patch looks like this, so maybe I'll put that in 1/7
if I respin this.

@@
expression E;
identifier get_random_u32 =~ "get_random_int|prandom_u32|get_random_u32";
typedef u64;
@@
- ((u64)(E) * get_random_u32() >> 32)
+ prandom_u32_max(E)
