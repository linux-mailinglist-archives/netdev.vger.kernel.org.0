Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB722B5BB6
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 10:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbgKQJWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 04:22:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbgKQJWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 04:22:01 -0500
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62576C0613CF;
        Tue, 17 Nov 2020 01:22:01 -0800 (PST)
Received: by mail-lj1-x244.google.com with SMTP id p12so23450823ljc.9;
        Tue, 17 Nov 2020 01:22:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=anMWulhUxUbQQi+cP5uhburhWI4XjIxePPyIvO0m7GU=;
        b=PUgWnMmn/WYeE53XTcSvVHyIUxmxcHij3+gsaJpdmfry1KE/gwpRVDVLqx7tz8v5CR
         KXmzPirr07EhOgPEQyf4O04FhlXMciudEwlJ0j7OPfj181YuyY+1R/jfIVNKn/xXaUwU
         2/jwvqVwZ8eVbDQ8+03RVJ/Jgv/ojKFddhFlkgQ9j7DGrOZk+J6t8Ol937P7kFWWip+q
         wbPD+3ThJa015yc7f0G8loM29qZR8qQJRQTo49Kdj18NV9m2RBnkviSk6ZYMy9j3lyau
         x+pyQK0l+lpGRGp8QUVWOE/Z91a7m5H0mYJdc49xmtHtHDTl0KK+wDs0woa35e71DnqQ
         LJlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=anMWulhUxUbQQi+cP5uhburhWI4XjIxePPyIvO0m7GU=;
        b=mhPSIasDglWWdaS5d+IQP20pTWThqEdbTPSrj4nGYpP8CuPu3TKE2+X/Q6Up0jgvtW
         HyFOdo00fNJk8lFQRpljq7dN6WA4oABCQSaWsyc2ptkbV+XtggKBC77c/vTfi9e6QLqm
         GNUJ5jVAuln19ZSBoK12vADaOAtVBI0fJaNaHZKGW7FjGOjFJUp7L+jhzLg2pFCebtYm
         vnAXoWYyZGgXGnBlg3lc4rfxqNCVs7rR6Yq3s6izwxX6oKLX/LRKmQw79PDQS6+X/UKS
         sSAJgg5NqgyNnWCjZLkORZ9JdN6dLHRd7w2B1hQVW8OIfzIekskKR2+UUvHJIVIVY4Vm
         pM4w==
X-Gm-Message-State: AOAM531AIdMEZCzqvFWCrVjzxDd/RqC53Wl+stp7kpdU5y4ok6XDq1q/
        o6Lcj7LWfPIyarHw4h/o0CEBiYJnHaezt7GPz0Y=
X-Google-Smtp-Source: ABdhPJxz+8YUSmb6HMJ9ExSKuO6QmI8VFlrnHIjn+QEPjPmVr0gVmLwx77X+qiTlytwBYEnNljtvIrYqhKA9/c3IMIo=
X-Received: by 2002:a2e:6c11:: with SMTP id h17mr1547129ljc.25.1605604919844;
 Tue, 17 Nov 2020 01:21:59 -0800 (PST)
MIME-Version: 1.0
References: <1605581721-36028-1-git-send-email-zhangchangzhong@huawei.com>
 <34800149-ce40-b993-1d82-5f26abc61b28@gmail.com> <CAMXMK6v+nAdcChQ4wkc8gRt6i1uwGHgnmqBvZf9k-HFmPkSWcQ@mail.gmail.com>
 <7fae4733-570c-6cb1-5537-de6469afbea5@gmail.com>
In-Reply-To: <7fae4733-570c-6cb1-5537-de6469afbea5@gmail.com>
From:   Chris Snook <chris.snook@gmail.com>
Date:   Tue, 17 Nov 2020 01:21:48 -0800
Message-ID: <CAMXMK6uZvCJxUwgXth4sJxSN2-5KF9m9x6bADtKjuN5xVommSA@mail.gmail.com>
Subject: Re: [PATCH net] atl1c: fix error return code in atl1c_probe()
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, yanaijie@huawei.com,
        christophe.jaillet@wanadoo.fr, mst@redhat.com,
        Leon Romanovsky <leon@kernel.org>, jesse.brandeburg@intel.com,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 1:01 AM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> Am 17.11.2020 um 08:43 schrieb Chris Snook:
> > The full text of the preceding comment explains the need:
> >
> > /*
> > * The atl1c chip can DMA to 64-bit addresses, but it uses a single
> > * shared register for the high 32 bits, so only a single, aligned,
> > * 4 GB physical address range can be used at a time.
> > *
> > * Supporting 64-bit DMA on this hardware is more trouble than it's
> > * worth.  It is far easier to limit to 32-bit DMA than update
> > * various kernel subsystems to support the mechanics required by a
> > * fixed-high-32-bit system.
> > */
> >
> > Without this, we get data corruption and crashes on machines with 4 GB
> > of RAM or more.
> >
> > - Chris
> >
> > On Mon, Nov 16, 2020 at 11:14 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
> >>
> >> Am 17.11.2020 um 03:55 schrieb Zhang Changzhong:
> >>> Fix to return a negative error code from the error handling
> >>> case instead of 0, as done elsewhere in this function.
> >>>
> >>> Fixes: 85eb5bc33717 ("net: atheros: switch from 'pci_' to 'dma_' API")
> >>> Reported-by: Hulk Robot <hulkci@huawei.com>
> >>> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> >>> ---
> >>>  drivers/net/ethernet/atheros/atl1c/atl1c_main.c | 4 ++--
> >>>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> >>> index 0c12cf7..3f65f2b 100644
> >>> --- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> >>> +++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> >>> @@ -2543,8 +2543,8 @@ static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> >>>        * various kernel subsystems to support the mechanics required by a
> >>>        * fixed-high-32-bit system.
> >>>        */
> >>> -     if ((dma_set_mask(&pdev->dev, DMA_BIT_MASK(32)) != 0) ||
> >>> -         (dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32)) != 0)) {
> >>> +     err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
> >>
> >> I wonder whether you need this call at all, because 32bit is the default.
> >> See following
> >>
> >> "By default, the kernel assumes that your device can address 32-bits
> >> of DMA addressing."
> >>
> >> in https://www.kernel.org/doc/Documentation/DMA-API-HOWTO.txt
> >>
> >>> +     if (err) {
> >>>               dev_err(&pdev->dev, "No usable DMA configuration,aborting\n");
> >>>               goto err_dma;
> >>>       }
> >>>
> >>
>
> Please don't top-post.
> >From what I've seen the kernel configures 32bit as default DMA size.
> See beginning of pci_device_add(), there the coherent mask is set to 32bit.
>
> And in pci_setup_device() see the following:
>   /*
>          * Assume 32-bit PCI; let 64-bit PCI cards (which are far rarer)
>          * set this higher, assuming the system even supports it.
>          */
>         dev->dma_mask = 0xffffffff;
>
>
> That means if you would like to use 64bit DMA then you'd need to configure this explicitly.
> You could check to which mask dev->dma_mask and dev->coherent_dma_mask are set
> w/o the call to dma_set_mask_and_coherent.

I don't remember the exact history with atl1c, but we really did hit
this bug with atl1 and atl2. I'm not sure if that's because this
default wasn't there or if it's because because another call was
replaced with this call, but either way it's quite likely that at some
point in the future someone who doesn't even have test hardware will
try to port this to a newer interface that doesn't make the same
assumption, and bad things will happen. This isn't a hot path, so it's
better to be explicit. If dma_set_mask_and_coherent() ever takes a
long time or fails, something is seriously wrong and we probably want
to know about it before we start DMAing.

- Chris
