Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 152623DB319
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 08:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237047AbhG3GA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 02:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbhG3GAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 02:00:55 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D424AC061798
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 23:00:50 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id q17-20020a17090a2e11b02901757deaf2c8so13032932pjd.0
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 23:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AkhIE+Z/B9o86qJ2h9HZNEp9cxXi2bxRLjCixTXYrfc=;
        b=Fh6OENhJi1c3RrFskVWW6a9K2LSOKkwhkO0I0QoeZawnKqIN6ZuzUUVNxbwiTtvNFz
         bMVWqh2xIMpsrdYmeJhT9uFMA1by20wu3sM3OAADk1KBtfN4Uu2cssSA0TWKloIc9Vey
         zfRQUlNDvpayDj2QUZLI50jUvarPm8pJnxzm8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AkhIE+Z/B9o86qJ2h9HZNEp9cxXi2bxRLjCixTXYrfc=;
        b=eiw4XfAwf8ipUhZFRbHC4duK4oHYGVPTVhOas50tj0NxNO8pDCPC41edSibIhFKYIf
         pLYSydvQMKiPMzDRp5wkWQrvdviZf6vyUR35VnbiURZf1bcjrhVx+0Ceo6qXJYIpbuLV
         aVicwkUo25ebFjSvNjGiH3AqtsCstWf3zs5+VzxRKyIGFdBIEqDCIgMe2xwJFSQNnG0d
         yry/92cvgJqhc5i/K4abWUoKl5NGtXX/IyQp2twC+oZl6mQkMhQtMujsqZ0hs70XfRuf
         ZChbToot/VIzgjqPfizi/Or8bKZwGIMjvs/AtRhKacDggcxmSyMNFtoMqllDMWhgMHVv
         IXOg==
X-Gm-Message-State: AOAM533ngzP1LRWtfAti5rc0MXlEBrKKfniVQ4WFXv80XvyKNOAxvkF7
        Yhub9KYQCHntmDlnkSWbTTFavA==
X-Google-Smtp-Source: ABdhPJyWC1FrO1Uo8OEqczQz/zwyPTutgGoQvmX1ca/HLGVAQy1qzKK0RhNumzH/6yied/9WmGxhOQ==
X-Received: by 2002:a17:902:a411:b029:12b:a4eb:5fcc with SMTP id p17-20020a170902a411b029012ba4eb5fccmr1190139plq.22.1627624850214;
        Thu, 29 Jul 2021 23:00:50 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id a22sm723870pfv.113.2021.07.29.23.00.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 23:00:49 -0700 (PDT)
Date:   Thu, 29 Jul 2021 23:00:48 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, dsterba@suse.cz,
        Bart Van Assche <bvanassche@acm.org>,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com,
        nborisov@suse.com
Subject: Re: [PATCH 01/64] media: omap3isp: Extract struct group for memcpy()
 region
Message-ID: <202107291952.C08EAE039B@keescook>
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-2-keescook@chromium.org>
 <20210728085921.GV5047@twin.jikos.cz>
 <20210728091434.GQ1931@kadam>
 <c52a52d9-a9e0-5020-80fe-4aada39035d3@acm.org>
 <20210728213730.GR5047@suse.cz>
 <YQJDCw01gSp1d1/M@kroah.com>
 <20210729082039.GX25548@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210729082039.GX25548@kadam>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 11:20:39AM +0300, Dan Carpenter wrote:
> On Thu, Jul 29, 2021 at 07:56:27AM +0200, Greg Kroah-Hartman wrote:
> > On Wed, Jul 28, 2021 at 11:37:30PM +0200, David Sterba wrote:
> > > On Wed, Jul 28, 2021 at 02:37:20PM -0700, Bart Van Assche wrote:
> > > > On 7/28/21 2:14 AM, Dan Carpenter wrote:
> > > > > On Wed, Jul 28, 2021 at 10:59:22AM +0200, David Sterba wrote:
> > > > >>>   drivers/media/platform/omap3isp/ispstat.c |  5 +--
> > > > >>>   include/uapi/linux/omap3isp.h             | 44 +++++++++++++++++------
> > > > >>>   2 files changed, 36 insertions(+), 13 deletions(-)
> > > > >>>
> > > > >>> diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
> > > > >>> index 5b9b57f4d9bf..ea8222fed38e 100644
> > > > >>> --- a/drivers/media/platform/omap3isp/ispstat.c
> > > > >>> +++ b/drivers/media/platform/omap3isp/ispstat.c
> > > > >>> @@ -512,7 +512,7 @@ int omap3isp_stat_request_statistics(struct ispstat *stat,
> > > > >>>   int omap3isp_stat_request_statistics_time32(struct ispstat *stat,
> > > > >>>   					struct omap3isp_stat_data_time32 *data)
> > > > >>>   {
> > > > >>> -	struct omap3isp_stat_data data64;
> > > > >>> +	struct omap3isp_stat_data data64 = { };
> > > > >>
> > > > >> Should this be { 0 } ?
> > > > >>
> > > > >> We've seen patches trying to switch from { 0 } to {  } but the answer
> > > > >> was that { 0 } is supposed to be used,
> > > > >> http://www.ex-parrot.com/~chris/random/initialise.html 
> > > > >>
> > > > >> (from https://lore.kernel.org/lkml/fbddb15a-6e46-3f21-23ba-b18f66e3448a@suse.com/ )
> > > > > 
> > > > > In the kernel we don't care about portability so much.  Use the = { }
> > > > > GCC extension.  If the first member of the struct is a pointer then
> > > > > Sparse will complain about = { 0 }.
> > > > 
> > > > +1 for { }.
> > > 
> > > Oh, I thought the tendency is is to use { 0 } because that can also
> > > intialize the compound members, by a "scalar 0" as it appears in the
> > > code.
> > > 
> > 
> > Holes in the structure might not be initialized to anything if you do
> > either one of these as well.
> > 
> > Or did we finally prove that is not the case?  I can not remember
> > anymore...
> 
> Yep.  The C11 spec says that struct holes are initialized.
> 
> https://lore.kernel.org/netdev/20200731140452.GE24045@ziepe.ca/

This is, unfortunately, misleading. The frustrating key word is
"partial" in "updated in C11 to require zero'ing padding when doing
partial initialization of aggregates". If one initializes _all_ the
struct members ... the padding doesn't get initialized. :( (And until
recently, _trailing_ padding wasn't getting initialized even when other
paddings were.)

I've tried to collect all the different ways the compiler might initialize
a variable in this test:
https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/tree/lib/test_stackinit.c?h=for-next/kspp

FWIW, there's no difference between -std=gnu99 and -std=c11, and the
test shows that padding is _not_ universally initialized (unless your
compiler supports -ftrivial-auto-var-init=zero, which Clang does, and
GCC will shortly[1]). Running this with GCC 10.3.0, I see this...

As expected, having no initializer leaves padding (as well as members)
uninitialized:

stackinit: small_hole_none FAIL (uninit bytes: 24)
stackinit: big_hole_none FAIL (uninit bytes: 128)
stackinit: trailing_hole_none FAIL (uninit bytes: 32)

Here, "zero" means  "= { };" and they get padding initialized:

stackinit: small_hole_zero ok
stackinit: big_hole_zero ok
stackinit: trailing_hole_zero ok

Here, "static_partial" means "= { .one_member = 0 };", and
"dynamic_partial" means "= { .one_member = some_variable };". These are
similarly initialized:

stackinit: small_hole_static_partial ok
stackinit: big_hole_static_partial ok
stackinit: trailing_hole_static_partial ok

stackinit: small_hole_dynamic_partial ok
stackinit: big_hole_dynamic_partial ok
stackinit: trailing_hole_dynamic_partial ok

But when _all_ members are initialized, the padding is _not_:

stackinit: small_hole_static_all FAIL (uninit bytes: 3)
stackinit: big_hole_static_all FAIL (uninit bytes: 124)
stackinit: trailing_hole_static_all FAIL (uninit bytes: 7)

stackinit: small_hole_dynamic_all FAIL (uninit bytes: 3)
stackinit: big_hole_dynamic_all FAIL (uninit bytes: 124)
stackinit: trailing_hole_dynamic_all FAIL (uninit bytes: 7)

As expected, assigning to members outside of initialization leaves
padding uninitialized:

stackinit: small_hole_runtime_partial FAIL (uninit bytes: 23)
stackinit: big_hole_runtime_partial FAIL (uninit bytes: 127)
stackinit: trailing_hole_runtime_partial FAIL (uninit bytes: 24)

stackinit: small_hole_runtime_all FAIL (uninit bytes: 3)
stackinit: big_hole_runtime_all FAIL (uninit bytes: 124)
stackinit: trailing_hole_runtime_all FAIL (uninit bytes: 7)

> What doesn't initialize struct holes is assignments:
> 
> 	struct foo foo = *bar;

Right. Object to object assignments do not clear padding:

stackinit: small_hole_assigned_copy XFAIL (uninit bytes: 3)
stackinit: big_hole_assigned_copy XFAIL (uninit bytes: 124)
stackinit: trailing_hole_assigned_copy XFAIL (uninit bytes: 7)

And whole-object assignments of cast initializers follow the pattern of
basic initializers, which makes sense given the behavior of initializers
and direct assignment tests above. e.g.:
	obj = (type){ .member = ... };

stackinit: small_hole_assigned_static_partial ok
stackinit: small_hole_assigned_dynamic_partial ok
stackinit: big_hole_assigned_dynamic_partial ok
stackinit: big_hole_assigned_static_partial ok
stackinit: trailing_hole_assigned_dynamic_partial ok
stackinit: trailing_hole_assigned_static_partial ok

stackinit: small_hole_assigned_static_all FAIL (uninit bytes: 3)
stackinit: small_hole_assigned_dynamic_all FAIL (uninit bytes: 3)
stackinit: big_hole_assigned_static_all FAIL (uninit bytes: 124)
stackinit: big_hole_assigned_dynamic_all FAIL (uninit bytes: 124)
stackinit: trailing_hole_assigned_dynamic_all FAIL (uninit bytes: 7)
stackinit: trailing_hole_assigned_static_all FAIL (uninit bytes: 7)

So, yeah, it's not very stable.

-Kees

[1] https://gcc.gnu.org/pipermail/gcc-patches/2021-July/576341.html

-- 
Kees Cook
