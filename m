Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 233D2343F9E
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 12:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbhCVLYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 07:24:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:37200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229931AbhCVLYh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 07:24:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D9416191F;
        Mon, 22 Mar 2021 11:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616412277;
        bh=NMdc5lCANq7g/MqpzuyP26nixYfnVZ7Ldnb4i+7L3aE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ByzrHUnro6bmY3Bn6QbeZdYPNRrnXouXTxUzCF8jSmeg/eMeCD5TpyaVHJyWZqgZm
         KnEZVE5FtlZFPAZylsrLTlpDW68NhUWcs0hJZsD83HU93yNywmt3VPP24sViHvaq5C
         KI4SQifqwJWqr5k9TLiRKsedx2YczMnwKdQVp8GjO3FGaAzmWzVUA0IyjhWH5jB19f
         XlhxQBYD7VRyf6FATgC08KFxpQphXWW0bD+3UWRfoXib1+jXOG3pWKLPhMY+imR9/K
         /9/Ivc9K6Vp9uqHYE+HL3AS/TDPAmbg7jMH5bUoj2KhFgkO5JdfDQT3dWiTgHEWXod
         fYxN+vFTT4bfA==
Received: by mail-oi1-f179.google.com with SMTP id l79so12640550oib.1;
        Mon, 22 Mar 2021 04:24:37 -0700 (PDT)
X-Gm-Message-State: AOAM531APm1P99m2nMvyjWaVGhXC/hYJByR4YQ1bUcnHq/VhoTNppOD0
        bWXCgVoatSXmCD5DyBHqdLx7ilJ9jFGRTf5uzlw=
X-Google-Smtp-Source: ABdhPJwr66Z36fB+BXUUOnJpLnIxz0kqOEvPXWBbl40dBClqSGVUiInBjP6i3wsEn8XJqlw8NQk9317EoDhUrbDRNQQ=
X-Received: by 2002:a05:6808:3d9:: with SMTP id o25mr9589084oie.4.1616412276790;
 Mon, 22 Mar 2021 04:24:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210322104343.948660-1-arnd@kernel.org> <YFh3heNXq6mqYqzI@unreal>
In-Reply-To: <YFh3heNXq6mqYqzI@unreal>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Mon, 22 Mar 2021 12:24:20 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3WZmBB=bxNc=taaDwBksLOPVPzhXPAFJ3QCG+eA+Xxww@mail.gmail.com>
Message-ID: <CAK8P3a3WZmBB=bxNc=taaDwBksLOPVPzhXPAFJ3QCG+eA+Xxww@mail.gmail.com>
Subject: Re: [PATCH net-next 1/5] misdn: avoid -Wempty-body warning
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Networking <netdev@vger.kernel.org>,
        Karsten Keil <isdn@linux-pingi.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 11:55 AM Leon Romanovsky <leon@kernel.org> wrote:
> On Mon, Mar 22, 2021 at 11:43:31AM +0100, Arnd Bergmann wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> > gcc warns about a pointless condition:
> >
> > drivers/isdn/hardware/mISDN/hfcmulti.c: In function 'hfcmulti_interrupt':
> > drivers/isdn/hardware/mISDN/hfcmulti.c:2752:17: error: suggest braces around empty body in an 'if' statement [-Werror=empty-body]
> >  2752 |                 ; /* external IRQ */
> >
> > Change this as suggested by gcc, which also fits the style of the
> > other conditions in this function.
> >
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> >  drivers/isdn/hardware/mISDN/hfcmulti.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
> > index 7013a3f08429..8ab0fde758d2 100644
> > --- a/drivers/isdn/hardware/mISDN/hfcmulti.c
> > +++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
> > @@ -2748,8 +2748,9 @@ hfcmulti_interrupt(int intno, void *dev_id)
> >               if (hc->ctype != HFC_TYPE_E1)
> >                       ph_state_irq(hc, r_irq_statech);
> >       }
> > -     if (status & V_EXT_IRQSTA)
> > -             ; /* external IRQ */
> > +     if (status & V_EXT_IRQSTA) {
> > +             /* external IRQ */
> > +     }
>
> Any reason do not delete this hunk?

I don't care either way, I only kept it because it was apparently left there
on purpose by the original author, as seen by the comment.

        Arnd
