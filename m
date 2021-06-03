Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33A2C39A2D0
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 16:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbhFCOI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 10:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbhFCOI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 10:08:56 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD451C06174A;
        Thu,  3 Jun 2021 07:07:08 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id i67so6006452qkc.4;
        Thu, 03 Jun 2021 07:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gBucM2tWIfE7RZufFyihAb1W7wKbEZlz8vfM9AwERz4=;
        b=fGK8XT6+BUSnhZ8oa5WyG3+FwOoVnO7kx1SWuB1mWpl8OSCDir9F25H536ejgTS5MW
         zEP18f/4RqSBokjZipKa28rD/yHbL40Ik1TtuOGvN3KhRjstap7dLalCasO3rKIZAyCT
         LGh3UhS3NyagGfg3oKKmXH48t5uKuo7WgRWy3ZZ1Nwsvcx9wakm79frr+jsaehC4LNPJ
         1BfFcn1OCaAyJjmWD6VQovcjuamQ2ZVwsF7QivS8uexgpAKYv3V7Eiwm1Qi/OQDgjkIS
         lCw/02Zs5IVl3EubFSsyWR84WtIcFcPCfCCpvoYGW0ff9hL+qAo1TZGkbFduwyBQ4XLX
         YLZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gBucM2tWIfE7RZufFyihAb1W7wKbEZlz8vfM9AwERz4=;
        b=B7uj0sdCGfmw/3QW5lw3Gvf19miPQvvPqAsWaJy8bd4A/CoEAaLT39LZZ3EjMMohyE
         NOg12kl1tFXOXg/4Ij08kiVIgjz1iEu63Wnx4UJz0aCL7sEmZimMQjdL9imxEqNzjJ5j
         tPdRMCz1hc/0O9bBsEqd+GajZFisNwC5W0Yc8UbWLEY6qVAzXEgqn2UgREIHdKlxN1EE
         qw3HsmUHwP56L9tnvJ/Q2jgz+eVy2XRsPZicblmErnJSoVQP8/ahTCX4CPrE7FhMH7e3
         E/Pp2X3irN9nGHA+3PpyrwRmsoMaBMkIr0cw0rKYcOgOfCmhs0aKUJTSqhje1PhRhRjs
         11lQ==
X-Gm-Message-State: AOAM532zrIn3pctLq7NUXl33HxjWg0gTJcN/IspCqIlkMn/o/f3+aAv1
        Uv3QLj2kvlugfc8wLG6LajLX0sSWpUJmm9JUuFc0TMKuMKYVhQ==
X-Google-Smtp-Source: ABdhPJyzJGfYVLXjE2rKVFFPW1eTVljleEGXu/Loi96HQQFmPgfV7xyiZKnx/eOHaIP5sMbJgN5cep7fHsDhQZO3IbA=
X-Received: by 2002:a05:620a:22f3:: with SMTP id p19mr32675566qki.281.1622729228073;
 Thu, 03 Jun 2021 07:07:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210603055341.24473-1-liuhangbin@gmail.com> <CAHmME9qXTYVLenPBfq2xpfq=DSJAsdUwSqP4Fzc=0YP6kW+QsQ@mail.gmail.com>
In-Reply-To: <CAHmME9qXTYVLenPBfq2xpfq=DSJAsdUwSqP4Fzc=0YP6kW+QsQ@mail.gmail.com>
From:   Hangbin Liu <liuhangbin@gmail.com>
Date:   Thu, 3 Jun 2021 22:06:56 +0800
Message-ID: <CAPwn2JQh2ahvSwJiuMNSeoVe7czM1x=Pt5jyXQBVxpPb5PbU1A@mail.gmail.com>
Subject: Re: [PATCH] crypto: x86/curve25519 - fix cpu feature checking logic
 in mod_exit
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Netdev <netdev@vger.kernel.org>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 3, 2021 at 6:24 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >         if (IS_REACHABLE(CONFIG_CRYPTO_KPP) &&
> > -           (boot_cpu_has(X86_FEATURE_BMI2) || boot_cpu_has(X86_FEATURE_ADX)))
> > +           static_branch_likely(&curve25519_use_bmi2_adx))
> >                 crypto_unregister_kpp(&curve25519_alg);
> >  }
>
> Looks like the error is actually that the `||` should be a `&&`. But
> if you'd like to branch on that static key instead, that's fine.

Yes, the code would be shorter by checking the static key :)

Thanks
hangbin
