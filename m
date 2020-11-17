Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9862B5A77
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 08:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgKQHnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 02:43:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbgKQHnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 02:43:41 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F31FC0613CF;
        Mon, 16 Nov 2020 23:43:39 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id s30so28801942lfc.4;
        Mon, 16 Nov 2020 23:43:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2bYscL4Jp7SddaM/+UCvKe7vphdZ1aHk3M18glPenPI=;
        b=ofFjjQAwnKy/jpRxA1Kdb2Tp6zCKCqOBd5Mx4g/+0LRbfNeVSVRcH8Mp24eMg5w40L
         YKLEvPC8VA6NHJkOb3snSt5DQbC8XLzvKpte5rrgp0Dvt4IlUOWfFXJPTRe+mqr6ItKm
         2x/WcPl8rvTYjzEQ/Oy3z8rFFXm0EPHTF8V7rzS1yWlj08004CcoEx5SF3KALVFusRoa
         28xsGUAaEASUoYg5xsOvbs+68POkUPtBIJldF0hC3XZ4szr8FJusTKAUn+FfYUx7BdMK
         JkQ24LO/NawSoDNl85Ir0EzJrwYOJbpwaEDyKIw3VA0eUzR2/n6m6rjuQ49C5Nb0Eo4j
         fE2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2bYscL4Jp7SddaM/+UCvKe7vphdZ1aHk3M18glPenPI=;
        b=iMsTI98wPbMHMDdI3AGXQnTzUhPAltD1odVzF18p5dIm6Jo2+BishU9880XjpxnOFj
         lOIGjRevriXUTKzlr/IYN7dqQqzoseLuQMJNAB3WTVxb5Tvk2geAz3RRU9h014+4/ry6
         z7W4+mZoOSLviPL1BjxZ5oYB8lmNNgdTz1Ne6TQFpy739j/Ru2dG0crCrfp0l4sLtpH8
         ndkqBj/RM4/EpKpVztUp8eByTUGOJlRluyHiqIaNaVTuHGzTQKEgy3PkFld0gjx/V3UM
         GYKX/cNo7Lb5WW0m8F9XiHacK/RjJ2u0bKco6aiwVfamQLY7MqGxGRJpmlmyNBr0OtK1
         DcWA==
X-Gm-Message-State: AOAM533dSEKrQSULNBpmfUJTgfkQbr5Tia2yVgXNObB0V2daq7OQr0Yp
        hWnbkx/Fa4pxkSWNcDHe2jvOSMKoQYeBaKhD4N0=
X-Google-Smtp-Source: ABdhPJx7mMbsjLyOB+9DvONEjfBmbllJO0hbgigmpx1hUXmytW0tE4zsPMiZ5GBudh+ejSOkP0yV7nVppK4vH93L964=
X-Received: by 2002:a05:6512:2103:: with SMTP id q3mr1322242lfr.11.1605599017588;
 Mon, 16 Nov 2020 23:43:37 -0800 (PST)
MIME-Version: 1.0
References: <1605581721-36028-1-git-send-email-zhangchangzhong@huawei.com> <34800149-ce40-b993-1d82-5f26abc61b28@gmail.com>
In-Reply-To: <34800149-ce40-b993-1d82-5f26abc61b28@gmail.com>
From:   Chris Snook <chris.snook@gmail.com>
Date:   Mon, 16 Nov 2020 23:43:25 -0800
Message-ID: <CAMXMK6v+nAdcChQ4wkc8gRt6i1uwGHgnmqBvZf9k-HFmPkSWcQ@mail.gmail.com>
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

The full text of the preceding comment explains the need:

/*
* The atl1c chip can DMA to 64-bit addresses, but it uses a single
* shared register for the high 32 bits, so only a single, aligned,
* 4 GB physical address range can be used at a time.
*
* Supporting 64-bit DMA on this hardware is more trouble than it's
* worth.  It is far easier to limit to 32-bit DMA than update
* various kernel subsystems to support the mechanics required by a
* fixed-high-32-bit system.
*/

Without this, we get data corruption and crashes on machines with 4 GB
of RAM or more.

- Chris

On Mon, Nov 16, 2020 at 11:14 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> Am 17.11.2020 um 03:55 schrieb Zhang Changzhong:
> > Fix to return a negative error code from the error handling
> > case instead of 0, as done elsewhere in this function.
> >
> > Fixes: 85eb5bc33717 ("net: atheros: switch from 'pci_' to 'dma_' API")
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> > ---
> >  drivers/net/ethernet/atheros/atl1c/atl1c_main.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> > index 0c12cf7..3f65f2b 100644
> > --- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> > +++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> > @@ -2543,8 +2543,8 @@ static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> >        * various kernel subsystems to support the mechanics required by a
> >        * fixed-high-32-bit system.
> >        */
> > -     if ((dma_set_mask(&pdev->dev, DMA_BIT_MASK(32)) != 0) ||
> > -         (dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32)) != 0)) {
> > +     err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
>
> I wonder whether you need this call at all, because 32bit is the default.
> See following
>
> "By default, the kernel assumes that your device can address 32-bits
> of DMA addressing."
>
> in https://www.kernel.org/doc/Documentation/DMA-API-HOWTO.txt
>
> > +     if (err) {
> >               dev_err(&pdev->dev, "No usable DMA configuration,aborting\n");
> >               goto err_dma;
> >       }
> >
>
