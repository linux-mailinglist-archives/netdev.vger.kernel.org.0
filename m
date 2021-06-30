Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5813B3B8198
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 14:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234435AbhF3MGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 08:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234413AbhF3MGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 08:06:36 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2646DC061766
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 05:04:07 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id x141so1532365vsx.2
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 05:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mSTV53Ormamnz9oqAVbKwPR4krBuUta3co+KXeJPHTg=;
        b=i3YCo3zIZgM/TMmAMT/nWKjm1SEkngb8OZSJX7RhK6wVQWHAk6bOvgLXemQd6NlQ0b
         1sHUk+7+VWxqSrtLtCtlrBFMv9ndzit/PePEAJ+O0lUR/UELemODu5Oq38UosW6pW7HZ
         ix7pjqv7BOZ5swTxXcw/23GnY+SD1sb2e6Va+Wyub7ch1vP090r1d9InhXHQKaWy8XPj
         Ra4XvoFao/g66k9qMa0f4xjS+UCrKsvPGYKfBExOuy56ICJ/cb/+EDo2w85l+hosGr7Q
         llEWVobxh6V2Wj1TeCbtAxSj3UWN4BlbJD3ngagjmJRfshWS1gynqd9j26FvU4Eyq8ed
         4jBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mSTV53Ormamnz9oqAVbKwPR4krBuUta3co+KXeJPHTg=;
        b=e2VC7UPL5O8QmI41OJJw6V0n00UexZ48y5TXYD4SOaa1eJMzXJpBo27J5OyQpy/hwf
         I7lIp8RiKC8+g4buylrElXFVx4KWzYDTxSH+X20fTpPjpKaWTX1lY8E3U6q2nNzAkZbl
         BUon+PDe7Z11UDoRpgTYlPTR8XKO+XRpOAK0dov2qaAOCPPjjTPMwNHQE9pVXJErwXY7
         +aTAPKJ/QVmgRcrXsNdSZUYEoe6fxhBCAtmOAKdlTpYS6yOnUImRWUsLSMPpjKdXxK1T
         MJ3JFb0eJCHfOKty8Pc6ZcPptc9B8nkm8wPXTnLy9iaBxMai0Bc6+Et7PSQmK9ZnNPyt
         N61Q==
X-Gm-Message-State: AOAM531WuLjqjlOp/nop60qARvA8i9oBZQM0zegPUlE4ALZE/OVMUjLR
        vI/JqtaeD1QO2Vzvb6KtESagGv4AdZkLcW1lOj3Elw==
X-Google-Smtp-Source: ABdhPJyXl4iLVbk5mGr0+59tFQmdQGrW1ymmtZZdl8lmpno5eXnWmnqUpraj4mElrt1qUMlbrqdtgti5y9uGGTw4nbs=
X-Received: by 2002:a67:ee54:: with SMTP id g20mr22316142vsp.55.1625054646254;
 Wed, 30 Jun 2021 05:04:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210622202345.795578-1-jernej.skrabec@gmail.com>
 <CAK8P3a1mvRTTFHtxqREmcbgJS+e94BHajCtAU_fzBhNNKjJBcg@mail.gmail.com>
 <CAPDyKFqFTCzXFMar88CYdZKc=eMjKszsOCS1LwLmnF0uNQyPAw@mail.gmail.com> <CAK8P3a2yo6eAe+jZQ7XB9ERYOYvBdCfjMKCYgm=gh-Ekd=SQ3Q@mail.gmail.com>
In-Reply-To: <CAK8P3a2yo6eAe+jZQ7XB9ERYOYvBdCfjMKCYgm=gh-Ekd=SQ3Q@mail.gmail.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Wed, 30 Jun 2021 14:03:29 +0200
Message-ID: <CAPDyKFp4BkfEW+wKwED97FNvnb4_5AWDO8KwpQvVXaHa7pSywQ@mail.gmail.com>
Subject: Re: [RFC PATCH] cw1200: use kmalloc() allocation instead of stack
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Jernej Skrabec <jernej.skrabec@gmail.com>, pizza@shaftnet.org,
        Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Jun 2021 at 13:30, Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Wed, Jun 30, 2021 at 11:56 AM Ulf Hansson <ulf.hansson@linaro.org> wrote:
> >
> > On Tue, 22 Jun 2021 at 22:33, Arnd Bergmann <arnd@arndb.de> wrote:
> > >
> > > On Tue, Jun 22, 2021 at 10:24 PM Jernej Skrabec
> > > <jernej.skrabec@gmail.com> wrote:
> > > >
> > > > It turns out that if CONFIG_VMAP_STACK is enabled and src or dst is
> > > > memory allocated on stack, SDIO operations fail due to invalid memory
> > > > address conversion:
> > >
> > > Thank you for sending this!
> > >
> > > It's worth pointing out that even without CONFIG_VMAP_STACK, using
> > > dma_map_sg() on a stack variable is broken, though it will appear to
> > > work most of the time but rarely cause a stack data corruption when
> > > the cache management goes wrong.
> > >
> > > This clearly needs to be fixed somewhere, if not with your patch, then
> > > a similar one.
> > >
> > > > diff --git a/drivers/net/wireless/st/cw1200/hwio.c b/drivers/net/wireless/st/cw1200/hwio.c
> > > > index 3ba462de8e91..5521cb7f2233 100644
> > > > --- a/drivers/net/wireless/st/cw1200/hwio.c
> > > > +++ b/drivers/net/wireless/st/cw1200/hwio.c
> > > > @@ -66,33 +66,65 @@ static int __cw1200_reg_write(struct cw1200_common *priv, u16 addr,
> > > >  static inline int __cw1200_reg_read_32(struct cw1200_common *priv,
> > > >                                         u16 addr, u32 *val)
> > > >  {
> > > > -       __le32 tmp;
> > > > -       int i = __cw1200_reg_read(priv, addr, &tmp, sizeof(tmp), 0);
> > > > -       *val = le32_to_cpu(tmp);
> > > > +       __le32 *tmp;
> > > > +       int i;
> > > > +
> > > > +       tmp = kmalloc(sizeof(*tmp), GFP_KERNEL);
> > > > +       if (!tmp)
> > > > +               return -ENOMEM;
> > > > +
> > > > +       i = __cw1200_reg_read(priv, addr, tmp, sizeof(*tmp), 0);
> > > > +       *val = le32_to_cpu(*tmp);
> > > > +       kfree(tmp);
> > > >         return i;
> > > >  }
> > >
> > > There is a possible problem here when the function gets called from
> > > atomic context, so it might need to use GFP_ATOMIC instead of
> > > GFP_KERNEL. If it's never called from atomic context, then this patch
> > > looks correct to me.
> >
> > I would be surprised if this is called from atomic context (when IRQs
> > are turned off), because in most cases, to complete the read/write
> > request the mmc controller driver relies on IRQs being delivered.
>
> I thought I had seen a spinlock in the forked driver, but I don't see
> it now, so I probably misremembered that bit.
>
> > > The alternative would be to add a bounce buffer check based on
> > > is_vmalloc_or_module_addr() in sdio_io_rw_ext_helper(), which would
> > > add a small bit of complexity there but solve the problem for
> > > all drivers at once. In this case, it would probably have to use
> > > GFP_ATOMIC regardless of whether __cw1200_reg_read_32()
> > > is allowed to sleep, since other callers might not.
> >
> > I like the idea, but...
> >
> > I don't think we should see this as an alternative, but rather as a
> > complement which would have performance issues. A warning should be
> > printed, if the buffer isn't properly allocated.
>
> Fair enough. I found the function call I was looking for: object_is_on_stack(),
> the patch below should print a warning once when a driver passes
> a bad buffer, but I did not test that.
>
> There are some possible variations on that: an on-stack buffer by
> itself can work as long as the DMA is cache-coherent and stacks
> are not vmapped. For the is_vmalloc_or_module_addr() case,
> we may decide to just return an error, rather than running into
> a kernel oops.
>
> > Additionally, I don't think GFT_ATOMIC should be needed.
>
> Ok, I now see the mmc_wait_for_req() in mmc_io_rw_extended()
> that probably means it can not be called in atomic context at all,
> and that GFP_KERNEL is safe, and that any driver calling it with
> a spinlock held is already broken.
>
>        Arnd
>
> 8<---
> diff --git a/drivers/mmc/core/sdio_ops.c b/drivers/mmc/core/sdio_ops.c
> index 4c229dd2b6e5..845f9ca3b200 100644
> --- a/drivers/mmc/core/sdio_ops.c
> +++ b/drivers/mmc/core/sdio_ops.c
> @@ -124,6 +124,7 @@ int mmc_io_rw_extended(struct mmc_card *card, int
> write, unsigned fn,
>         int err;
>
>         WARN_ON(blksz == 0);
> +       WARN_ON_ONCE(is_vmalloc_or_module_addr(buf) || object_is_on_stack(buf));

Looks reasonable to me, at least we should start giving a warning.
Would you like to send a formal patch that we can test?

Kind regards
Uffe
