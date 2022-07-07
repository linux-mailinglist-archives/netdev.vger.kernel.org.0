Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFF83569E00
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 10:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235374AbiGGIq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 04:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235370AbiGGIqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 04:46:06 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FBCB205F7
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 01:46:02 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id r3so31354321ybr.6
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 01:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5cHJei8eL/XiwTDNpED+fxZcKWgVJ7HjqIIRFdQymYE=;
        b=Rwr/0xAbP22SkSO4ltQNd5DO9kOdCIPUX8eOWtlHwOdZ+eXUirzl5qg06j9V+Yiv3O
         cj7QAXKgcpDd8VICNliQszBCAfuOO4LZEpTjaWPrYa9merLlH9ymfe1gCJLK8816QNU/
         TN52ctMJoN3rUixBRY3lCznhnmS/VbStTrwRs0BgeY/EyE/CTatkYIj4zSvpxgx+pPnn
         tPxLB1SdDda2RY+mRf/sMVZ6PreLNpt/mvvd6bUWrj+nJMaosEedrdUWLVvYeyvr9AKx
         kMW2frNUT64iftKRxwYAo6Hhj0Co6UbznTiP1Gu8CHNGLcohgC/Bx0CprW20sB+U/MTj
         Mp8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5cHJei8eL/XiwTDNpED+fxZcKWgVJ7HjqIIRFdQymYE=;
        b=bSUkFoYYJUa3DjBBiUs9ezoFJgh+nCp4oonFGF8IIpnrHMlfLGzKQaEjLCesGt/YAn
         Rxd7e/WI0xqR7rYf3NstvwejfpDKNkzli89Z1vSJNWjr1T7Ius3AFXJAvhu5eDIjxBlv
         jtpXBMLqajSRQT6Rmgm4p5jeUNq+ylmK5peUaHb0wynEk8qQawj+uzOkDy2ufT76zDf8
         FYHZuk+Ktw9LiOHu4f7JU148dLJdg0mAuPQoxqZfA/gvuUZBiBrGtcQVoBZmmypaPTgV
         82L8eIcHRUBFdlwI0r3l2f64xYg1u3NRMl1f9uVFA4U+qzL5P+T3kZkUZDu9oOuQX69k
         7gCw==
X-Gm-Message-State: AJIora+WBhP0JBGVidQGwExeoEfo8F+TsmCRcsX1W2jxSolhcerQQVeH
        R1xb8SBvPnEO6mHv/noVVXeZJqHbB5hQSbNEwAypuQ==
X-Google-Smtp-Source: AGRyM1umnEo/DDoPW1gezdcq6NhnRjlJjrnSjug9dbwPv0bkQtbR3YYvr8jnWrkUAiqc8A/LvQP5N4QmUNAx7CqjhD0=
X-Received: by 2002:a25:d07:0:b0:66e:6c0e:a2d1 with SMTP id
 7-20020a250d07000000b0066e6c0ea2d1mr14360322ybn.369.1657183561693; Thu, 07
 Jul 2022 01:46:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220629035434.1891-1-luizluca@gmail.com> <CAJq09z44SNGFkCi_BCpQ+3DuXhKfGVsMubRYE7AezJsGGOboVA@mail.gmail.com>
 <20220629181455.boerjnqmvovmtzra@bang-olufsen.dk> <CAJq09z6iX9s75Y2G46V_CEMiAk2PSGW6fF4t4QSPbjEXgs1iTQ@mail.gmail.com>
 <20220706152923.mhc7vw7xkr7xkot4@skbuf>
In-Reply-To: <20220706152923.mhc7vw7xkr7xkot4@skbuf>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 7 Jul 2022 10:45:49 +0200
Message-ID: <CACRpkda6NSf+R22ioA7suqYLv8GB21NMwCNWR3arc8wo0_-fFw@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 0/3] net: dsa: realtek: drop custom slave MII
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 6, 2022 at 5:29 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> On Thu, Jun 30, 2022 at 02:05:39PM -0300, Luiz Angelo Daros de Luca wrote:

> > > In principle I like your changes, but I'm not sure if what you are doing
> > > is allowed, since DT is ABI. The fact that you have to split this into
> > > two steps, with the first step warning about old "incompatible" DTs
> > > (your point 3 below) before the second step breaks that compatibility,
> > > suggests that you are aware that you could be breaking old DTs.
> >
> > Thanks Alvin for your review. Yes, that is a good question for the ML.
> > I don't know at what level we can break compatibility (DT and driver).
> > That's why it is a RFC.
>
> DT bindings are only extended in backwards-compatible ways. Only in the
> case where you can prove that there is no DT user of a certain binding,
> and that none should appear either, is when you can consider breaking
> the backward compatibility. The idea here is that old DT blobs may live
> forever and be provided by fixed firmware such as U-Boot, you can't
> really force anyone to update them.

We break it when it makes sense.

The central question is to ascertain if there are actually binary DTBs
deployed with these bindings, in mass-market products, and these are
not upgraded in tandem with the kernel.

A mistake (IMO) in the early days of DT was to assume that
it was used with Open Firmware (OF) which is like ACPI, a kind of BIOS.
Most users of DT do not use OF, the only thing we ever see relating
to it is the of_* prefix.

People actually using open firmware would embed the DTB with the
open firmware and flash it into a (desktop) computer as a blob, pretty
much like how the ACPI BIOS works now.

It turns out the majority of contemporary users of DT don't use DTBs
like this at all: instead they compile the kernel and the DTB, then flash
both into the platform at the same time. There is even the FIT format for
U-Boot which is a package of both kernel and DT and whatnot.

Actually very few people flash their DTB in such a way that it cannot get
upgraded, and in fact most flash both at the same time, after building
both from source. In that case it doesn't matter if we break compatibility.

While we strive to keep DT schemas strict and compatible (it is a good
ambition) I would reverse the burden of proof for backward compatibility:
if it can not be proven that irrevocable DTBs have been deployed, and
that kernels may get upgraded independently of the DTB, using this
specific binding, then it is fine to change it in incompatible ways if
we need to.

It could also be that the DT bindings started to get used
with another operating system. But these things have to be demonstrated,
they are the rare cases and should not be the assumption, as if a
DT binding is immediately used in a myriad of places the second
we merge it to Torvald's tree. Such adoption in the real world happens
much later.

If the only specimens are inside a company that has not yet released
any products we can certainly change it. What we don't want is the
general public running into these incompatibilities.

Notice that as we discuss this, I see some people being requested to
reflash their (ACPI) bioses rather than put fixes in the kernel for
erroneous ACPI DSDT:s. Not for end users, but for people working
with prototypes still in development. "Go fix your DSDT BIOS tables".

Yours,
Linus Walleij
