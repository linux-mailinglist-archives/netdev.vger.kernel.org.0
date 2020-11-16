Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCA452B4B7B
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 17:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732266AbgKPQmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 11:42:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729689AbgKPQmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 11:42:10 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10720C0613CF
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 08:42:10 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id n5so15855274ile.7
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 08:42:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IEjm1oIUbC9ClxlE2u2GKE3Z9asUNRZSfryIpXi58c4=;
        b=adIgFX6XDXJfZo4/9MP5TA9FbLXm0wPPdhGPctULurb7SLIktgF3KVac/O37suAzIO
         kopSf+BHLuN2T8jVA6xTsl0nKPpwt3KA8BmQabUaIh0KYOr6U+RrUx75jJuPr5mH65k7
         pWCcmlZ+EJUT6Oo7Jc23nMoHhQVS3m6BKkpwF0mJBl85C5QLJWr0uPlZ4h2uswP5E7Xx
         1aBy+owdSFmzHKR/ktCxMlln7FdSVJKXfVpBEv1s/nRikN/jLLU/ewzSR5k9p3mm7CfE
         M3P4xslCQNCpQkbza8ke+bWFC2Jxuz/5vv87OGOtpxSa+Ra5Zf/wuO7nrCKDI/NsxpEP
         3SgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IEjm1oIUbC9ClxlE2u2GKE3Z9asUNRZSfryIpXi58c4=;
        b=eZBCeTFavpsDHRt570Ptni7GtTp7VHYUwULK+mcKF/hIumdWRpw2bKK7N4zewr5tiP
         Q7Anr0csnhBSo8/q8nxLufkWCOMQBS9qhqpSrUqMFOswSBjOjXtQIh8yWuaqLuhHsjpy
         Sl28118tM+e1DpUHW8RzG4Dh7EJPtqEcuClH4dhMcn/qE81jABMiGnpJHPz7vDNayn8D
         RKt/ZCT0joiY/cXkRpP67l8BxLR8re+3FHItgjjmHTWv1TNy6PPby/8QRZfGQXBk0W/p
         kBHPnip+zLY6bdnGpRgOYL/NgNzieA6PnDYOB4mTJYAcQK7b49vaU+OokCJtvCgZfKhR
         z9UA==
X-Gm-Message-State: AOAM531XOUWGYFH0ciKxTGtnlkv6EjpPn9B5k6TgOS3HgQQ47DobjOem
        ZBCvvcxE9exhgSBN5ZM/6/ivxYc6p6Bso90Gnlo=
X-Google-Smtp-Source: ABdhPJwMzhjYUK72UJewwFVkuZKkIUJBONPLfxxRqdGN2i6vf8Sus+wmGPipHsOc9d6IoE8Tx4kMDejooT4Mptgn+5U=
X-Received: by 2002:a92:4993:: with SMTP id k19mr9028839ilg.237.1605544929328;
 Mon, 16 Nov 2020 08:42:09 -0800 (PST)
MIME-Version: 1.0
References: <eda2de73-edf2-8b92-edb9-099ebda09ebc@solarflare.com>
 <5ce9986a-4c5c-9ffd-e83d-e6782ff370ba@solarflare.com> <CAKgT0UciV2rSiNBHQOhqHkrx=XBLzOTdHmKXZ6fTxdt1D3c0Gg@mail.gmail.com>
 <72c7dac3-9744-0006-b859-50b4e3ccf5bf@solarflare.com>
In-Reply-To: <72c7dac3-9744-0006-b859-50b4e3ccf5bf@solarflare.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 16 Nov 2020 08:41:58 -0800
Message-ID: <CAKgT0UeGPuH=E3ny1yyB0Az11GssOZmTPqmBW9ccksr5Z8x6sg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] sfc: extend bitfield macros to 19 fields
To:     Edward Cree <ecree@solarflare.com>
Cc:     Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 4:27 AM Edward Cree <ecree@solarflare.com> wrote:
>
> On 13/11/2020 19:06, Alexander Duyck wrote:
> > On Thu, Nov 12, 2020 at 7:23 AM Edward Cree <ecree@solarflare.com> wrote:
> >> @@ -348,7 +352,11 @@ typedef union efx_oword {
> >>  #endif
> >>
> >>  /* Populate an octword field with various numbers of arguments */
> >> -#define EFX_POPULATE_OWORD_17 EFX_POPULATE_OWORD
> >> +#define EFX_POPULATE_OWORD_19 EFX_POPULATE_OWORD
> >> +#define EFX_POPULATE_OWORD_18(oword, ...) \
> >> +       EFX_POPULATE_OWORD_19(oword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
> >> +#define EFX_POPULATE_OWORD_17(oword, ...) \
> >> +       EFX_POPULATE_OWORD_18(oword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
> >>  #define EFX_POPULATE_OWORD_16(oword, ...) \
> >>         EFX_POPULATE_OWORD_17(oword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
> >>  #define EFX_POPULATE_OWORD_15(oword, ...) \
> > Are all these macros really needed? It seems like this is adding a
> > bunch of noise in order to add support for a few additional fields.
> > Wouldn't it be possible to just define the ones that are actually
> > needed and add multiple dummy values to fill in the gaps instead of
> > defining every macro between zero and 19? For example this patch set
> > adds an option for setting 18 fields, but from what I can tell it is
> > never used.
> I guess the reasoningoriginally was that it's easier to read and
>  v-lint if it's just n repetitions of the same pattern.  Whereas if
>  there were jumps, it'd be more likely for a typo to slip through
>  unnoticed and subtly corrupt all the values.

I'm not sure the typo argument holds much water. The fact is it is
pretty easy to just count the variables doing something like the
following:
#define EFX_POPULATE_OWORD_10(oword, ...) \
        EFX_POPULATE_OWORD_19(oword, \
                              EFX_DUMMY_FIELD, 0, \
                              EFX_DUMMY_FIELD, 0, \
                              EFX_DUMMY_FIELD, 0, \
                              EFX_DUMMY_FIELD, 0, \
                              EFX_DUMMY_FIELD, 0, \
                              EFX_DUMMY_FIELD, 0, \
                              EFX_DUMMY_FIELD, 0, \
                              EFX_DUMMY_FIELD, 0, \
                              EFX_DUMMY_FIELD, 0, \
                              __VA_ARGS__)

Any change is basically update the 19 to whatever and add/subtract
lines using a simple copy/paste.

> But tbh I don't know, it's been like that since the driver was added
>  twelve years ago (8ceee660aacb) when it had all from 0 to 10.  All
>  we've done since then is extend that pattern.

The reason I bring it up is that it seems like it is dragging  a bunch
of macros that will likely never need 19 variables forward along with
it. For example the EFX_POPULATE_[DQ]WORD_<n> seems to only go as high
as 7. I'm not sure it makes much sense to keep defining new versions
of the macro when you could just be adding the needed lines to the 7
variable version of the macro and and come up with something that
looks like the definition of EFX_SET_OWORD where you could just add an
EFX_DUMMY_FIELD, 0, for each new variable added. The
EFX_POPULATE_OWORD_<X> goes all the way to 17 currently, however if we
exclude that the real distribution seems to be 1 - 10, with just the
one lone call to the 17 case which is becoming 19 with your patch.

The one issue I can think of is the fact that you will need the 17
variable version until you change it to the 19, but even then dropping
the 17 afterwards and adding the 2 additional sets of dummy variables
to the 10 should be straight forward and still pretty easy to review.
