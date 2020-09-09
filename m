Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2718B2638E1
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 00:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728970AbgIIWMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 18:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbgIIWMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 18:12:44 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D1ABC061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 15:12:43 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id b17so3864314ilh.4
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 15:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MUfkY8G4pytBiiWUddSSH1Cllrm00c0MVNk7lfg6cSM=;
        b=cpOvw6bnaoFG2hdnSFJrTDOU8HoapV0TyMFCiW/Fn9zP02e0wpLJDmJZGkqnxUhKuZ
         7WuujOIUgMgHq0UVxacetM/sGiy7/SlXrS7uDr0fLFYhtfnwqaav/IJgd0g2M88mpSxs
         QTJvhYD14CkeqwKp41/gxXnXle0f945UEcayaXiETpgBV41SXLx+lUZ6oN3fT2189R3u
         9ysnQsVoIf1vj0dkYXwQnezDTYYZhd0EgCW0Afi8LRRs1L+/AqO8zXKubz2OzyRat9P5
         NvwSgArevyDVvJxK2LZSwi6vROwow8XPpg4JvVjJx2lxlNXUVhRBIyrSurNkNy+AiDGb
         IerQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MUfkY8G4pytBiiWUddSSH1Cllrm00c0MVNk7lfg6cSM=;
        b=A9Af3fOQlY07iP7tiSc0lGhLpi7KeHJdUVY1xidAanFIIyvyqCaBoidoUEt2O7AgWF
         zC5570H/bxkgZQT3nzL3LhMJJZTJ+trTJMxIznAQ/4ePGm7Bcg0xQpG4sTiZouYWjxtK
         rlLHtcyuBGATJWBLHNhD34YD/z5mDfUYRCPnaPEZB9lvpT6MYjcRWPsbaJmaqW5027u4
         2LWp9pap9gV68w5bJfdtLnsVlpcpGhswO8ayh71MUD1Fd7+3hSkDbLl1eF87t6CInz9R
         +7lJbkRjdJ97A/BEQmWkgj76KBCbYYjI4J4lCImASy7s9JlV4TXNREpXwnV6oitepH/O
         vE9w==
X-Gm-Message-State: AOAM530NGywyHLGeOr7+AAMUrXmrt0zOP5E1XNuIYfdntVx6PmSv6srR
        4mBnkXsE80nF3Omx9lJ+XSPM/46bcKzZC9MgV2Ur2g==
X-Google-Smtp-Source: ABdhPJwL9KhBP8iIfUJPkhA+E+Pq3mpGrxFjHKVH8tuXHiNQaMRKrjD3VFCfaYC9e6XO7sexBiHY4t/5GKvSOI8rEuY=
X-Received: by 2002:a92:d1cb:: with SMTP id u11mr5002537ilg.15.1599689562576;
 Wed, 09 Sep 2020 15:12:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200908183909.4156744-1-awogbemila@google.com>
 <20200908183909.4156744-5-awogbemila@google.com> <20200908121457.0dc67f75@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200908121457.0dc67f75@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Awogbemila <awogbemila@google.com>
Date:   Wed, 9 Sep 2020 15:12:31 -0700
Message-ID: <CAL9ddJfadRfo-Q1-SoL9uhCYDSXTGpY8RHjvuRz3yRzyVvRfag@mail.gmail.com>
Subject: Re: [PATCH net-next v3 4/9] gve: Add support for dma_mask register
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 8, 2020 at 12:15 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue,  8 Sep 2020 11:39:04 -0700 David Awogbemila wrote:
> > +     dma_mask = readb(&reg_bar->dma_mask);
> > +     // Default to 64 if the register isn't set
> > +     if (!dma_mask)
> > +             dma_mask = 64;
> >       gve_write_version(&reg_bar->driver_version);
> >       /* Get max queues to alloc etherdev */
> >       max_rx_queues = ioread32be(&reg_bar->max_tx_queues);
> >       max_tx_queues = ioread32be(&reg_bar->max_rx_queues);
> > +
> > +     err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
>
> You use the constant 64, not dma_mask?
>
> You jump through hoops to get GFP_DMA allocations yet you don't set the
> right DMA mask. Why would swiotlb become an issue to you if there never
> was any reasonable mask set?
>
> > +     if (err) {
> > +             dev_err(&pdev->dev, "Failed to set dma mask: err=%d\n", err);
> > +             goto abort_with_reg_bar;
> > +     }
> > +
> > +     err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
>
> dma_set_mask_and_coherent()
>
> > +     if (err) {
> > +             dev_err(&pdev->dev,
> > +                     "Failed to set consistent dma mask: err=%d\n", err);
> > +             goto abort_with_reg_bar;
> > +     }

I think you're right. Setting dma_set_mask_and_coherent(dev, 64)
should mean we no longer have the swiotlb issue. I will drop this
patch altogether.
