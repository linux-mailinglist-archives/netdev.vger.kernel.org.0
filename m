Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1873D3B8152
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 13:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234353AbhF3LdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 07:33:23 -0400
Received: from mout.kundenserver.de ([217.72.192.74]:59217 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234148AbhF3LdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 07:33:22 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]) by
 mrelayeu.kundenserver.de (mreue109 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1MDQqe-1m6psw2LG2-00AWHl; Wed, 30 Jun 2021 13:30:52 +0200
Received: by mail-wr1-f52.google.com with SMTP id u6so3201405wrs.5;
        Wed, 30 Jun 2021 04:30:52 -0700 (PDT)
X-Gm-Message-State: AOAM530OhqXx3vl/xZ5Z29wGFfZDz2BMd5FcuPz35A3NC5FGYgaNCJMg
        YqSqCKEywXCagFCLj4EXWTGSViZLRLJ1hvYApvg=
X-Google-Smtp-Source: ABdhPJzYNXi8j/ffCK4PMxsUHoWIPd5fACyahpwza/FwkvHRHJts4aBYBClRyUAZ/tIYQgNnVrENUgbPJf4+hiQbbxo=
X-Received: by 2002:adf:fd8e:: with SMTP id d14mr18937848wrr.361.1625052652138;
 Wed, 30 Jun 2021 04:30:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210622202345.795578-1-jernej.skrabec@gmail.com>
 <CAK8P3a1mvRTTFHtxqREmcbgJS+e94BHajCtAU_fzBhNNKjJBcg@mail.gmail.com> <CAPDyKFqFTCzXFMar88CYdZKc=eMjKszsOCS1LwLmnF0uNQyPAw@mail.gmail.com>
In-Reply-To: <CAPDyKFqFTCzXFMar88CYdZKc=eMjKszsOCS1LwLmnF0uNQyPAw@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 30 Jun 2021 13:30:36 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2yo6eAe+jZQ7XB9ERYOYvBdCfjMKCYgm=gh-Ekd=SQ3Q@mail.gmail.com>
Message-ID: <CAK8P3a2yo6eAe+jZQ7XB9ERYOYvBdCfjMKCYgm=gh-Ekd=SQ3Q@mail.gmail.com>
Subject: Re: [RFC PATCH] cw1200: use kmalloc() allocation instead of stack
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Jernej Skrabec <jernej.skrabec@gmail.com>, pizza@shaftnet.org,
        Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:SJs4H3RGqU37iJSYEnhIG4mpbI6+IUtkj7f9Rctv24LvQnej3gM
 u+NLdKOYAECXRtMnhvT+qDA8fNxKXa9DA+LcsRW1Uq5zrIUy21euoaXoRK6qpWyyxzSJq11
 MfzeJq7Xbs2vb3qRgJvTHttf8PpC0PQGYUwVQbEmgxsqAuEeMHe6yUkjV4pm326ek8xsf3/
 BylUSSkP6XUj3zsrSuqbQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:y38oMd2jbMw=:C83AR+yAfBf0FglJ4C4gm3
 Ci6MFBwZSXxxyAiCUtSeyiGIvbtjA0qwn8FrpyBMaLLZlGDcCFAXAr/Zagu6BwAjw320//pkX
 NzqJMYO6WSDEID231NK/dSl25CEsBuJa76bYVld3UvLgHxiYoNyxEUUmnQrhxops0ewyRjgPn
 wPK8y0ddqREZEkCRk+JZVzHXXvKPHSBd41cY613uVYJAoi/cFp02Z2KaBJs0wzHTwbrrCZQOO
 8Qpa1IY2AGpqvdJevfskOIuseUTHdBkE5+fTwBs9Bqjzty+4sZ8Vo3FUKGQcA51/GgZCRE6ro
 AyIm+cGdP+La5U3LcKgiijdcSbJLH1n1yhaTlCAw+ne9Bn1vhbjxYs3hgEMl1O1V4w0DZrHb9
 iwmBC5rbDK4geWNrfdLA4I65sJYeQLeWbo7SMfjB0CZAVvnmsa8dAftlKnpwf9fFoy4a09f6i
 2+RYrapqC9YvA+o3qhrgP2kaLoy1BIEEDYbCHSQgR9UPOzNs/6nmNhrFzZNTerh+Dq7VgcOhY
 TYnH5SmIXpCbAofy2sn/n3Iqq8aKfqNDmb3rDFOaDjzq4bcGGRLQSlLNnSGzTUqdJgVOwLSjI
 nqhXAN92M/DiVrkuCM6ui7NVJQa8PfpHJUOCL3ixrQkWyA4IAUzNDoSB5Wt59OJ+gf2mjszlX
 1PM4=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 30, 2021 at 11:56 AM Ulf Hansson <ulf.hansson@linaro.org> wrote:
>
> On Tue, 22 Jun 2021 at 22:33, Arnd Bergmann <arnd@arndb.de> wrote:
> >
> > On Tue, Jun 22, 2021 at 10:24 PM Jernej Skrabec
> > <jernej.skrabec@gmail.com> wrote:
> > >
> > > It turns out that if CONFIG_VMAP_STACK is enabled and src or dst is
> > > memory allocated on stack, SDIO operations fail due to invalid memory
> > > address conversion:
> >
> > Thank you for sending this!
> >
> > It's worth pointing out that even without CONFIG_VMAP_STACK, using
> > dma_map_sg() on a stack variable is broken, though it will appear to
> > work most of the time but rarely cause a stack data corruption when
> > the cache management goes wrong.
> >
> > This clearly needs to be fixed somewhere, if not with your patch, then
> > a similar one.
> >
> > > diff --git a/drivers/net/wireless/st/cw1200/hwio.c b/drivers/net/wireless/st/cw1200/hwio.c
> > > index 3ba462de8e91..5521cb7f2233 100644
> > > --- a/drivers/net/wireless/st/cw1200/hwio.c
> > > +++ b/drivers/net/wireless/st/cw1200/hwio.c
> > > @@ -66,33 +66,65 @@ static int __cw1200_reg_write(struct cw1200_common *priv, u16 addr,
> > >  static inline int __cw1200_reg_read_32(struct cw1200_common *priv,
> > >                                         u16 addr, u32 *val)
> > >  {
> > > -       __le32 tmp;
> > > -       int i = __cw1200_reg_read(priv, addr, &tmp, sizeof(tmp), 0);
> > > -       *val = le32_to_cpu(tmp);
> > > +       __le32 *tmp;
> > > +       int i;
> > > +
> > > +       tmp = kmalloc(sizeof(*tmp), GFP_KERNEL);
> > > +       if (!tmp)
> > > +               return -ENOMEM;
> > > +
> > > +       i = __cw1200_reg_read(priv, addr, tmp, sizeof(*tmp), 0);
> > > +       *val = le32_to_cpu(*tmp);
> > > +       kfree(tmp);
> > >         return i;
> > >  }
> >
> > There is a possible problem here when the function gets called from
> > atomic context, so it might need to use GFP_ATOMIC instead of
> > GFP_KERNEL. If it's never called from atomic context, then this patch
> > looks correct to me.
>
> I would be surprised if this is called from atomic context (when IRQs
> are turned off), because in most cases, to complete the read/write
> request the mmc controller driver relies on IRQs being delivered.

I thought I had seen a spinlock in the forked driver, but I don't see
it now, so I probably misremembered that bit.

> > The alternative would be to add a bounce buffer check based on
> > is_vmalloc_or_module_addr() in sdio_io_rw_ext_helper(), which would
> > add a small bit of complexity there but solve the problem for
> > all drivers at once. In this case, it would probably have to use
> > GFP_ATOMIC regardless of whether __cw1200_reg_read_32()
> > is allowed to sleep, since other callers might not.
>
> I like the idea, but...
>
> I don't think we should see this as an alternative, but rather as a
> complement which would have performance issues. A warning should be
> printed, if the buffer isn't properly allocated.

Fair enough. I found the function call I was looking for: object_is_on_stack(),
the patch below should print a warning once when a driver passes
a bad buffer, but I did not test that.

There are some possible variations on that: an on-stack buffer by
itself can work as long as the DMA is cache-coherent and stacks
are not vmapped. For the is_vmalloc_or_module_addr() case,
we may decide to just return an error, rather than running into
a kernel oops.

> Additionally, I don't think GFT_ATOMIC should be needed.

Ok, I now see the mmc_wait_for_req() in mmc_io_rw_extended()
that probably means it can not be called in atomic context at all,
and that GFP_KERNEL is safe, and that any driver calling it with
a spinlock held is already broken.

       Arnd

8<---
diff --git a/drivers/mmc/core/sdio_ops.c b/drivers/mmc/core/sdio_ops.c
index 4c229dd2b6e5..845f9ca3b200 100644
--- a/drivers/mmc/core/sdio_ops.c
+++ b/drivers/mmc/core/sdio_ops.c
@@ -124,6 +124,7 @@ int mmc_io_rw_extended(struct mmc_card *card, int
write, unsigned fn,
        int err;

        WARN_ON(blksz == 0);
+       WARN_ON_ONCE(is_vmalloc_or_module_addr(buf) || object_is_on_stack(buf));

        /* sanity check */
        if (addr & ~0x1FFFF)
