Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84E3635A5E5
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 20:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234393AbhDIShS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 14:37:18 -0400
Received: from mail.zx2c4.com ([104.131.123.232]:46534 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234273AbhDIShQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 14:37:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1617993421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oSVNwotPAPQJjl+GLbQuN3wvO2qB5A32VRDgEWPG81Q=;
        b=R5t3fUIg90+qupBtku5bsLYEV+nt2qW7JuUuvNzAi10GKENgHZH60f6G9A5no/Qn997+4j
        L37xAjd5OE/qhzc6lyIsHOYM983Z8t8qC8jQkCqcgfhQh+Ndu11lowdW33s6UJTOOEWbe5
        OMHykg3GgyzG+vJPNPucNV8w7uDkpZU=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 54dfcd07 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 9 Apr 2021 18:37:00 +0000 (UTC)
Received: by mail-yb1-f181.google.com with SMTP id o10so7585626ybb.10;
        Fri, 09 Apr 2021 11:37:00 -0700 (PDT)
X-Gm-Message-State: AOAM530TPfRltU9mXOJRECx5A1Rf02xiz3/eHYv5Rmbjs6tnyQPJbagr
        dMTvAKcvaVDMf04Eza6s5wyjaUFTKUamPqx9BeI=
X-Google-Smtp-Source: ABdhPJwk/MDUyxGAQVPcrk6s9phmYdpLpHbR9mLNDuiVI3g/Quu5obxcIhQdk/3kuJv59Ei2bU2uQFJjsQfvGTOFZ2M=
X-Received: by 2002:a25:ad0f:: with SMTP id y15mr17665460ybi.306.1617993420125;
 Fri, 09 Apr 2021 11:37:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210407113920.3735505-1-liuhangbin@gmail.com>
 <CAHmME9p40M5oHDZXnFDXfO4-JuJ7bUB5BnsccGV1pksguz73sg@mail.gmail.com>
 <c47d99b9d0efeea4e6cd238c2affc0fbe296b53c.camel@redhat.com>
 <CAHmME9pRSOANrdvegLm9x8VTNWKcMtoymYrgStuSx+nsu=jpwA@mail.gmail.com>
 <20210409024143.GL2900@Leo-laptop-t470s> <CAHmME9oqK9iXRn3wxAB-MZvX3k_hMbtjHF_V9UY96u6NLcczAw@mail.gmail.com>
 <20210409024907.GN2900@Leo-laptop-t470s> <YG/EAePSEeYdonA0@zx2c4.com>
 <CAMj1kXG-e_NtLkAdLYp70x5ft_Q1Bn9rmdXs4awt7FEd5PQ4+Q@mail.gmail.com> <0ef180dea02996fc5f4660405f2333220e8ae4c4.camel@redhat.com>
In-Reply-To: <0ef180dea02996fc5f4660405f2333220e8ae4c4.camel@redhat.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 9 Apr 2021 12:36:49 -0600
X-Gmail-Original-Message-ID: <CAHmME9opMi_2_cOS66U6jJvYZ=WJWv4E-mjYr20YaL=zzJxv+Q@mail.gmail.com>
Message-ID: <CAHmME9opMi_2_cOS66U6jJvYZ=WJWv4E-mjYr20YaL=zzJxv+Q@mail.gmail.com>
Subject: Re: [PATCH net-next] [RESEND] wireguard: disable in FIPS mode
To:     Simo Sorce <simo@redhat.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 9, 2021 at 6:47 AM Simo Sorce <simo@redhat.com> wrote:
> >   depends on m || !CRYPTO_FIPS
> >
> > but I am a bit concerned that the rather intricate kconfig
> > dependencies between the generic and arch-optimized versions of those
> > drivers get complicated even further.
>
> Actually this is the opposite direction we are planning to go for
> future fips certifications.
>
> Due to requirements about crypto module naming and versioning in the
> new FIPS-140-3 standard we are planning to always build all the CRYPTO
> as bultin (and maybe even forbid loading additional crypto modules in
> FIPS mode). This is clearly just a vendor choice and has no bearing on
> what upstream ultimately will do, but just throwing it here as a data
> point.

I'm wondering: do you intend to apply similar patches to all the other
uses of "non-FIPS-certified" crypto in the kernel? I've already
brought up big_key.c, for example. Also if you're intent on adding
this check to WireGuard, because it tunnels packets without using
FIPS-certified crypto primitives, do you also plan on adding this
check to other network tunnels that don't tunnel packets using
FIPS-certified crypto primitives? For example, GRE, VXLAN, GENEVE? I'd
be inclined to take this patch more seriously if it was exhaustive and
coherent for your use case. The targeted hit on WireGuard seems
incoherent as a standalone patch, making it hard to even evaluate. So
I think either you should send an exhaustive patch series that forbids
all use of non-FIPS crypto anywhere in the kernel (another example:
net/core/secure_seq.c) in addition to all tunneling modules that don't
use FIPS-certified crypto, or figure out how to disable the lib/crypto
primitives that you want to be disabled in "fips mode". With a
coherent patchset for either of these, we can then evaluate it.

Jason
