Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A09E9359218
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 04:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232815AbhDICmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 22:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232616AbhDICmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 22:42:06 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 697D9C061760;
        Thu,  8 Apr 2021 19:41:54 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id k23-20020a17090a5917b02901043e35ad4aso4217310pji.3;
        Thu, 08 Apr 2021 19:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=53BwNaw0ZTugPQlWPAilQFmOOWAgL95JEVRv3JGA4es=;
        b=GV8kVRNFi4KSzgFxR46dPd/oSpHGcmzyxVOrUV+xfbNZq2INAWTaI26zgNe+/u1N74
         S+r/3uwi0JD1HVAO4DYYoVzjmNCEpDUFvCHlzGvFvbWZ4iizF3SUcKR4/WfmOM1Rjz9v
         nUw88qYnLziF8NyEm4cTDlfRdndzApKMT4Z0Ws8/b8X6Z9D4xbR1AFBWmUEeUs9fDakG
         UqlOtzz/a5kmzHFgn1VyyqdKHF0DWOaZaGCP/W8ty7j1raNQhGT1ACDU5CnFBKjODnty
         xaQGMG2MNvWcpUTiQjbibtbIJ6rM1tubiqDgXyY5CNOaMNlAlGR8KjcvzjjsUFNYqYld
         QX4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=53BwNaw0ZTugPQlWPAilQFmOOWAgL95JEVRv3JGA4es=;
        b=NBrfdkQkMsguR4BlpQWK/U054Ftw4Kk8/iIm8O01IkFAUMaNt174rTyQQ910Ejgjd5
         1KBIVjbKRHDEoBc0FSaSoHLdCqra2vS9Z0fkFy4AZEKPHUYNl8sgPhoWmNGGc7fD7fRV
         I3YDCU88+4CMhJD6YxVX8PAOsyr5aCUv3GwQ3+uEgBxxmtdjHo0+S6s18Tl2IVRT2n96
         tVPFnM4OrpHCTTDwN0l0G3Ba4zg0Y9idQeE3acbkkYhL1IqHyn6XYUBAY//baECtZHXI
         7QvteqZILmvy9gK+ZFs/rA3K7fH7tm3iygvFoPCM8ZF8hyO5qv5sBepJotxNHU6Omq1j
         NT+Q==
X-Gm-Message-State: AOAM5326pGXV8F8hATeu/ichbdOUFz+LDvj7eVaWcg+yV+VyroVfm8l8
        TAN2vB75Le5wOqq3r8S2TdU=
X-Google-Smtp-Source: ABdhPJymTfL8RwboAE364zm3j85cj1m5VHwlKzWohi+a914LSbb20fxuRJcuTwW0Pfs/KAiiT89Zbw==
X-Received: by 2002:a17:90b:1946:: with SMTP id nk6mr9468088pjb.61.1617936113951;
        Thu, 08 Apr 2021 19:41:53 -0700 (PDT)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m1sm590685pjf.8.2021.04.08.19.41.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 19:41:53 -0700 (PDT)
Date:   Fri, 9 Apr 2021 10:41:43 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Simo Sorce <simo@redhat.com>, Netdev <netdev@vger.kernel.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH net-next] [RESEND] wireguard: disable in FIPS mode
Message-ID: <20210409024143.GL2900@Leo-laptop-t470s>
References: <20210407113920.3735505-1-liuhangbin@gmail.com>
 <CAHmME9p40M5oHDZXnFDXfO4-JuJ7bUB5BnsccGV1pksguz73sg@mail.gmail.com>
 <c47d99b9d0efeea4e6cd238c2affc0fbe296b53c.camel@redhat.com>
 <CAHmME9pRSOANrdvegLm9x8VTNWKcMtoymYrgStuSx+nsu=jpwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9pRSOANrdvegLm9x8VTNWKcMtoymYrgStuSx+nsu=jpwA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 08, 2021 at 03:55:59PM -0600, Jason A. Donenfeld wrote:
> On Thu, Apr 8, 2021 at 7:55 AM Simo Sorce <simo@redhat.com> wrote:
> > > I'm not sure this makes so much sense to do _in wireguard_. If you
> > > feel like the FIPS-allergic part is actually blake, 25519, chacha, and
> > > poly1305, then wouldn't it make most sense to disable _those_ modules
> > > instead? And then the various things that rely on those (such as
> > > wireguard, but maybe there are other things too, like
> > > security/keys/big_key.c) would be naturally disabled transitively?
> >
> > The reason why it is better to disable the whole module is that it
> > provide much better feedback to users. Letting init go through and then
> > just fail operations once someone tries to use it is much harder to
> > deal with in terms of figuring out what went wrong.
> > Also wireguard seem to be poking directly into the algorithms
> > implementations and not use the crypto API, so disabling individual
> > algorithm via the regular fips_enabled mechanism at runtime doesn't
> > work.
> 
> What I'm suggesting _would_ work in basically the exact same way as
> this patch. Namely, something like:

Hi Jason,

I agree that the best way is to disable the crypto modules in FIPS mode.
But the code in lib/crypto looks not the same with crypto/. For modules
in crypto, there is an alg_test() to check if the crytpo is FIPS allowed
when do register.

- crypto_register_alg()
  - crypto_wait_for_test()
    - crypto_probing_notify(CRYPTO_MSG_ALG_REGISTER, larval->adult)
      - cryptomgr_schedule_test()
        - cryptomgr_test()
          - alg_test()

But in lib/crypto the code are more like a library. We can call it anytime
and there is no register. Maybe we should add a similar check in lib/crypto.
But I'm not familiar with crypto code... Not sure if anyone in linux-crypto@
would like help do that.

> 
> diff --git a/lib/crypto/curve25519.c b/lib/crypto/curve25519.c
> index 288a62cd29b2..b794f49c291a 100644
> --- a/lib/crypto/curve25519.c
> +++ b/lib/crypto/curve25519.c
> @@ -12,11 +12,15 @@
>  #include <crypto/curve25519.h>
>  #include <linux/module.h>
>  #include <linux/init.h>
> +#include <linux/fips.h>
> 
>  bool curve25519_selftest(void);
> 
>  static int __init mod_init(void)
>  {
> + if (!fips_enabled)
> + return -EOPNOTSUPP;

Question here, why it is !fips_enabled? Shouldn't we return error when
fips_enabled?

Thanks
Hangbin
