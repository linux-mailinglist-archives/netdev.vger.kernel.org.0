Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAEC04CB07A
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 21:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245000AbiCBVAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 16:00:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234176AbiCBVAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 16:00:14 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E188D2050
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 12:59:30 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id i1so2654442plr.2
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 12:59:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=R/oQqieG0aXWXHs93Td97reRxAIjZoSgBmUtDJFVhjU=;
        b=d2ZFN7FzXJICmnX4Tyt0wAx0nHny3V7g7RBF7BzoFi4JqvMjvTlFe6r9CSmtZHYpfY
         sI7cCbacBhQSn0c2nYjk/wWGRSWn9quhJSSynH9lMYRKPPdVW/LYlF+HQ4F3tfS4GoN+
         rfxT6gA9HHGJJFfNnOWheyqKpysRyPxkd0f8U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R/oQqieG0aXWXHs93Td97reRxAIjZoSgBmUtDJFVhjU=;
        b=08F5qxdhx4CVWQZDDbR1UIpcq3Yuu4H7yS4mqr/Qaprwo5Pu2uxHQrXavKWr7AAJ5G
         Djkx0U/IlE83m67K84x086GOFxu0CWRQo4ruG8DcjMBYYCZbCyqjMXvL12fAPWz6/7oN
         32fcIXsfXApDk2pjuF9FN9+1K5b1d0dHwtNesDD4K13BMn/ma8EjY6BV3WvbjqrM9ZJq
         to+g6ZtOxbNrrYi+NW2U3eK9yFpQCpSVwudfmERLuZOp8ttF8lPd1B78+/BeLX6mXvHd
         wAwN60Mh8lhssjNjVP3ON1j0hwL9wskNkUJZwt6JYw3wkTPDry4Zf0SVILAozlfga0Rr
         pZgA==
X-Gm-Message-State: AOAM533S5It3aGoKgo/fd75Cfo0OPIH33SJQ/jqxeqFOtyqhOyXwNMvg
        F6/jnPfhx/bAG90ze/cHw5RFPQ==
X-Google-Smtp-Source: ABdhPJykkdhEEGUDkHycvSgNRuEs4QwrQaW1FnUc6uFGBxeAOPBVvK2/xrXBO3QxBQPFHyTwD4zC/w==
X-Received: by 2002:a17:90b:1bc2:b0:1bf:993:f736 with SMTP id oa2-20020a17090b1bc200b001bf0993f736mr1213267pjb.190.1646254769629;
        Wed, 02 Mar 2022 12:59:29 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id on18-20020a17090b1d1200b001b9cfbfbf00sm4525pjb.40.2022.03.02.12.59.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 12:59:29 -0800 (PST)
Date:   Wed, 2 Mar 2022 12:59:28 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        David Laight <David.Laight@aculab.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        KVM list <kvm@vger.kernel.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>,
        "linux1394-devel@lists.sourceforge.net" 
        <linux1394-devel@lists.sourceforge.net>,
        "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        "linux-staging@lists.linux.dev" <linux-staging@lists.linux.dev>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "kgdb-bugreport@lists.sourceforge.net" 
        <kgdb-bugreport@lists.sourceforge.net>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Arnd Bergman <arnd@arndb.de>,
        Linux PM <linux-pm@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        dma <dmaengine@vger.kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        "v9fs-developer@lists.sourceforge.net" 
        <v9fs-developer@lists.sourceforge.net>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux F2FS Dev Mailing List 
        <linux-f2fs-devel@lists.sourceforge.net>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Mike Rapoport <rppt@kernel.org>
Subject: Re: [PATCH 2/6] treewide: remove using list iterator after loop body
 as a ptr
Message-ID: <202203021256.69D7C4BCA6@keescook>
References: <7D0C2A5D-500E-4F38-AD0C-A76E132A390E@kernel.org>
 <73fa82a20910c06784be2352a655acc59e9942ea.camel@HansenPartnership.com>
 <CAHk-=wiT5HX6Kp0Qv4ZYK_rkq9t5fZ5zZ7vzvi6pub9kgp=72g@mail.gmail.com>
 <7dc860874d434d2288f36730d8ea3312@AcuMS.aculab.com>
 <CAHk-=whKqg89zu4T95+ctY-hocR6kDArpo2qO14-kV40Ga7ufw@mail.gmail.com>
 <0ced2b155b984882b39e895f0211037c@AcuMS.aculab.com>
 <CAHk-=wix0HLCBs5sxAeW3uckg0YncXbTjMsE-Tv8WzmkOgLAXQ@mail.gmail.com>
 <78ccb184-405e-da93-1e02-078f90d2b9bc@rasmusvillemoes.dk>
 <202203021158.DB5204A0@keescook>
 <CAHk-=wikKPC0LUqZ8++EC5JOvGdBqVH9uUaTX=DvBioDoReYww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wikKPC0LUqZ8++EC5JOvGdBqVH9uUaTX=DvBioDoReYww@mail.gmail.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 02, 2022 at 12:18:45PM -0800, Linus Torvalds wrote:
> On Wed, Mar 2, 2022 at 12:07 PM Kees Cook <keescook@chromium.org> wrote:
> >
> > I've long wanted to change kfree() to explicitly set pointers to NULL on
> > free. https://github.com/KSPP/linux/issues/87
> 
> We've had this discussion with the gcc people in the past, and gcc
> actually has some support for it, but it's sadly tied to the actual
> function name (ie gcc has some special-casing for "free()")
> 
> See
> 
>     https://gcc.gnu.org/bugzilla/show_bug.cgi?id=94527
> 
> for some of that discussion.
> 
> Oh, and I see some patch actually got merged since I looked there last
> so that you can mark "deallocator" functions, but I think it's only
> for the context matching, not for actually killing accesses to the
> pointer afterwards.

Ah! I missed that getting added in GCC 11. But yes, there it is:

https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-malloc-function-attribute

Hah, now we may need to split __malloc from __alloc_size. ;)

I'd still like the NULL assignment behavior, though, since some things
can easily avoid static analysis.

-- 
Kees Cook
