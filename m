Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 122CE3F4370
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 04:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233206AbhHWCkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 22:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbhHWCkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 22:40:13 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E369C061575;
        Sun, 22 Aug 2021 19:39:31 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id c19-20020a9d6153000000b0051829acbfc7so32446314otk.9;
        Sun, 22 Aug 2021 19:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8nF7kdFCjl2OPHzuPCskfbES3a0StxpuedhMGt2ws3Q=;
        b=lsW2a6KvJ5hmygtoHRsKAqLG3lgg43Sg446jSi1IvtO7D46E/b7+SP4gTTzGB8rJFK
         uzo51/cElEOWgfEuR4Iu1T9tyCyBOJqW7SJU3o2bAK7BrDGemqqj+fRyzkK4rvJWMQtM
         QgYwaLJD8GUmeRpVYEfhXk9RZJRvjqLB4kI0NdqpcEtldcLni+LsorH4dJ92O/gB/RKK
         3ieHzSjPZwfbEK9TSxBlkgOHex7vUMQfKCub6iFMDNKBBZvu2V9aReh+xMBpete8mwtk
         gkEpZB/8K4bnlkEWz6TgCIbzRz9mfl9ZaeCTn6r8vfWg0+n92B17ntJAyvCv4Azo7dWP
         eblw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8nF7kdFCjl2OPHzuPCskfbES3a0StxpuedhMGt2ws3Q=;
        b=mheuoicnpG4Tym6xfwJyw1lXGqWH/fW1gqOuwdaaBg8S9t3Zivkuzx1GYl1dmDpXh8
         LMlIl0JKtkUaSH9DZE5sNJmlFP9vkKbQazkaIfEIwJW/470+lSOrizA8eNAEoFFPyf5B
         qYZ7wy5ru75msQsBl48OpKe9hBYqlchjYo44EB9/lOq/Ch5rB+tXLhDuYQWrjJb8c8I7
         dJ9FDh8KiiEoLOtgUCmaQ1ORthtMBEptARMHEhD/ptbJJyI6POvRZ5oft8x20urmK3JV
         fj4jQKx2jC9XeyOy5D4K/QHNuU+3IcWk+2fIeAQMnOO80Vw1g2p+lCz7ccs5KFk6BZ38
         LZpw==
X-Gm-Message-State: AOAM531aq3dHmkK3kPqFYgKQxkfl90n7+QMZfFHv7P22pAK0LuCPPDmc
        y9hbS8tai8BhPXXPJQi6eIT99SkBaI6O7fyFwFc=
X-Google-Smtp-Source: ABdhPJxEtbNzpg7GbWLAzgmdSqwV7J4gZiC7QnXf3jpOThz3HHXR98nyGqluzKQJ1DyxYErz6bxLhBNRYgpc0ciDGRw=
X-Received: by 2002:a9d:541:: with SMTP id 59mr24316449otw.278.1629686370947;
 Sun, 22 Aug 2021 19:39:30 -0700 (PDT)
MIME-Version: 1.0
References: <099a3b5974f6b2be8770e180823e2883209a3691.1629615550.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <099a3b5974f6b2be8770e180823e2883209a3691.1629615550.git.christophe.jaillet@wanadoo.fr>
From:   Zhu Yanjun <zyjzyj2000@gmail.com>
Date:   Mon, 23 Aug 2021 10:39:19 +0800
Message-ID: <CAD=hENe2OPUZCwL8fxBGGoLc6_1g0kqgo=GKebnot-5+W2n-LQ@mail.gmail.com>
Subject: Re: [PATCH] forcedeth: switch from 'pci_' to 'dma_' API
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Rain River <rain.1986.08.12@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 22, 2021 at 3:09 PM Christophe JAILLET
<christophe.jaillet@wanadoo.fr> wrote:
>
> The wrappers in include/linux/pci-dma-compat.h should go away.
>
> The patch has been generated with the coccinelle script below.
>
> It has been hand modified to use 'dma_set_mask_and_coherent()' instead of
> 'pci_set_dma_mask()/pci_set_consistent_dma_mask()' when applicable.
> This is less verbose.
>
> It has been compile tested.
>
>
> @@
> @@
> -    PCI_DMA_BIDIRECTIONAL
> +    DMA_BIDIRECTIONAL
>
> @@
> @@
> -    PCI_DMA_TODEVICE
> +    DMA_TO_DEVICE
>
> @@
> @@
> -    PCI_DMA_FROMDEVICE
> +    DMA_FROM_DEVICE
>
> @@
> @@
> -    PCI_DMA_NONE
> +    DMA_NONE
>
> @@
> expression e1, e2, e3;
> @@
> -    pci_alloc_consistent(e1, e2, e3)
> +    dma_alloc_coherent(&e1->dev, e2, e3, GFP_)
>
> @@
> expression e1, e2, e3;
> @@
> -    pci_zalloc_consistent(e1, e2, e3)
> +    dma_alloc_coherent(&e1->dev, e2, e3, GFP_)
>
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_free_consistent(e1, e2, e3, e4)
> +    dma_free_coherent(&e1->dev, e2, e3, e4)
>
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_map_single(e1, e2, e3, e4)
> +    dma_map_single(&e1->dev, e2, e3, e4)
>
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_unmap_single(e1, e2, e3, e4)
> +    dma_unmap_single(&e1->dev, e2, e3, e4)
>
> @@
> expression e1, e2, e3, e4, e5;
> @@
> -    pci_map_page(e1, e2, e3, e4, e5)
> +    dma_map_page(&e1->dev, e2, e3, e4, e5)
>
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_unmap_page(e1, e2, e3, e4)
> +    dma_unmap_page(&e1->dev, e2, e3, e4)
>
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_map_sg(e1, e2, e3, e4)
> +    dma_map_sg(&e1->dev, e2, e3, e4)
>
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_unmap_sg(e1, e2, e3, e4)
> +    dma_unmap_sg(&e1->dev, e2, e3, e4)
>
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_dma_sync_single_for_cpu(e1, e2, e3, e4)
> +    dma_sync_single_for_cpu(&e1->dev, e2, e3, e4)
>
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_dma_sync_single_for_device(e1, e2, e3, e4)
> +    dma_sync_single_for_device(&e1->dev, e2, e3, e4)
>
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_dma_sync_sg_for_cpu(e1, e2, e3, e4)
> +    dma_sync_sg_for_cpu(&e1->dev, e2, e3, e4)
>
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_dma_sync_sg_for_device(e1, e2, e3, e4)
> +    dma_sync_sg_for_device(&e1->dev, e2, e3, e4)
>
> @@
> expression e1, e2;
> @@
> -    pci_dma_mapping_error(e1, e2)
> +    dma_mapping_error(&e1->dev, e2)
>
> @@
> expression e1, e2;
> @@
> -    pci_set_dma_mask(e1, e2)
> +    dma_set_mask(&e1->dev, e2)
>
> @@
> expression e1, e2;
> @@
> -    pci_set_consistent_dma_mask(e1, e2)
> +    dma_set_coherent_mask(&e1->dev, e2)
>
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> If needed, see post from Christoph Hellwig on the kernel-janitors ML:
>    https://marc.info/?l=kernel-janitors&m=158745678307186&w=4
> ---
>  drivers/net/ethernet/nvidia/forcedeth.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
>
> diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
> index 8724d6a9ed02..ef3fb4cc90af 100644
> --- a/drivers/net/ethernet/nvidia/forcedeth.c
> +++ b/drivers/net/ethernet/nvidia/forcedeth.c
> @@ -5782,15 +5782,11 @@ static int nv_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
>                 np->desc_ver = DESC_VER_3;
>                 np->txrxctl_bits = NVREG_TXRXCTL_DESC_3;
>                 if (dma_64bit) {
> -                       if (pci_set_dma_mask(pci_dev, DMA_BIT_MASK(39)))
> +                       if (dma_set_mask_and_coherent(&pci_dev->dev, DMA_BIT_MASK(39)))
>                                 dev_info(&pci_dev->dev,
>                                          "64-bit DMA failed, using 32-bit addressing\n");
>                         else
>                                 dev->features |= NETIF_F_HIGHDMA;
> -                       if (pci_set_consistent_dma_mask(pci_dev, DMA_BIT_MASK(39))) {
> -                               dev_info(&pci_dev->dev,
> -                                        "64-bit DMA (consistent) failed, using 32-bit ring buffers\n");
> -                       }

From the commit log, "pci_set_consistent_dma_mask(e1, e2)" should be
replaced by "dma_set_coherent_mask(&e1->dev, e2)".
But in this snippet,  "pci_set_consistent_dma_mask(e1, e2)" is not
replaced by "dma_set_coherent_mask(&e1->dev, e2)".

Why?

Zhu Yanjun


>                 }
>         } else if (id->driver_data & DEV_HAS_LARGEDESC) {
>                 /* packet format 2: supports jumbo frames */
> --
> 2.30.2
>
