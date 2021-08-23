Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 245053F448F
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 07:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232852AbhHWFEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 01:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbhHWFEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 01:04:54 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B2EC061575;
        Sun, 22 Aug 2021 22:04:12 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id x10-20020a056830408a00b004f26cead745so33225829ott.10;
        Sun, 22 Aug 2021 22:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=h0nu8O0IV9Ju5r/jh7IUEoDFiMzyXRLDYW5S2ZAYbw8=;
        b=jq1Fua5ivR9BaDEZOr5veYhdkCaMjmdPx1VgmdG0ybyX0T7q0xZpp8TGsMPAET0H4k
         2ylbiE7ceGZqF9SlMVrwhEGXrcjsO/bkhbWm9KetfAK1bl4Popz447H3sidDv63HTSqi
         bcQhXb6yrFBAoce9mAQ5YeBzld0TblhCuZ5RlR3iObkTNPNCBDakidgjWrdkJY4wfeCj
         0u0gSvsGO6Z0faPc2H+/u+kVplQBKCZwn2RehlJJsu6zDx9ySDLJ4rc8GrSfX1Jb/rV7
         K0Sq11bhxxPVy1E0GPWXX5eVHNn5aw+waLrVVrj/lP4ibmRBut7VRriau0mdNSLJFWBo
         faMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=h0nu8O0IV9Ju5r/jh7IUEoDFiMzyXRLDYW5S2ZAYbw8=;
        b=B1cxsyh3u/rj40ffqoHIQxfIoB4for/TXeXs5ZdV08ltCEU3L84qJoA5oRs8u2XECB
         7Fdl0ivPKkXyn2z5MAe6b1J8kq8X41vfYAomx63gQleqKKJwNjKLA6yfwHc7/hxaNUkC
         OOPDOSLNoSw/2pfbD8yBLAN73NREsTUtrwRYdKgXja4QR1NMuMGL1q/LICemMxZBrsHV
         q8j9GQXtueGYNUUe7EVItGf3OPAn2KXp6ZZP1339qLNkajIGr5Nzc5cugGPJBhpwpyT8
         KeoGV+QYPgBXSD9PUe8tpmXovSqPEhfAUM0T4EEaXWp2mFBDNz2Ksms93XVLWuESC6ry
         RtFw==
X-Gm-Message-State: AOAM531p5nL7WfuRsigm7tdzYjKuj6t5fbO3N4MVS2NQVHwLZP+jelgS
        y9vs3khsGTKtxrz6nOIA2ecAoTfSYcSGqD03o5w=
X-Google-Smtp-Source: ABdhPJysvtneWqkPE2bwu5uJViICd5pzVS3tTnEjHz5eXoBo3tLlVWIHhsxpZA7uyNIeVbupArF66y6xxFCmztFPGD0=
X-Received: by 2002:a05:6830:1f0a:: with SMTP id u10mr20615468otg.53.1629695051823;
 Sun, 22 Aug 2021 22:04:11 -0700 (PDT)
MIME-Version: 1.0
References: <099a3b5974f6b2be8770e180823e2883209a3691.1629615550.git.christophe.jaillet@wanadoo.fr>
 <CAD=hENe2OPUZCwL8fxBGGoLc6_1g0kqgo=GKebnot-5+W2n-LQ@mail.gmail.com> <6f0d95cc-3cb6-c166-7e82-b7914ad25f72@wanadoo.fr>
In-Reply-To: <6f0d95cc-3cb6-c166-7e82-b7914ad25f72@wanadoo.fr>
From:   Zhu Yanjun <zyjzyj2000@gmail.com>
Date:   Mon, 23 Aug 2021 13:04:00 +0800
Message-ID: <CAD=hENcZ=D58ZJY5iakbJ3eGmkP3EzUD2YvO0F9oBzZMc=YD4g@mail.gmail.com>
Subject: Re: [PATCH] forcedeth: switch from 'pci_' to 'dma_' API
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Rain River <rain.1986.08.12@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 23, 2021 at 12:35 PM Christophe JAILLET
<christophe.jaillet@wanadoo.fr> wrote:
>
> Le 23/08/2021 =C3=A0 04:39, Zhu Yanjun a =C3=A9crit :
> > On Sun, Aug 22, 2021 at 3:09 PM Christophe JAILLET
> > <christophe.jaillet@wanadoo.fr> wrote:
> >>
> >> The wrappers in include/linux/pci-dma-compat.h should go away.
> >>
> >> The patch has been generated with the coccinelle script below.
> >>
> >> It has been hand modified to use 'dma_set_mask_and_coherent()' instead=
 of
> >> 'pci_set_dma_mask()/pci_set_consistent_dma_mask()' when applicable.
> >> This is less verbose.
> >>
> >> It has been compile tested.
> >>
> >>
> >> @@
> >> @@
> >> -    PCI_DMA_BIDIRECTIONAL
> >> +    DMA_BIDIRECTIONAL
> >>
> >> @@
> >> @@
> >> -    PCI_DMA_TODEVICE
> >> +    DMA_TO_DEVICE
> >>
> >> @@
> >> @@
> >> -    PCI_DMA_FROMDEVICE
> >> +    DMA_FROM_DEVICE
> >>
> >> @@
> >> @@
> >> -    PCI_DMA_NONE
> >> +    DMA_NONE
> >>
> >> @@
> >> expression e1, e2, e3;
> >> @@
> >> -    pci_alloc_consistent(e1, e2, e3)
> >> +    dma_alloc_coherent(&e1->dev, e2, e3, GFP_)
> >>
> >> @@
> >> expression e1, e2, e3;
> >> @@
> >> -    pci_zalloc_consistent(e1, e2, e3)
> >> +    dma_alloc_coherent(&e1->dev, e2, e3, GFP_)
> >>
> >> @@
> >> expression e1, e2, e3, e4;
> >> @@
> >> -    pci_free_consistent(e1, e2, e3, e4)
> >> +    dma_free_coherent(&e1->dev, e2, e3, e4)
> >>
> >> @@
> >> expression e1, e2, e3, e4;
> >> @@
> >> -    pci_map_single(e1, e2, e3, e4)
> >> +    dma_map_single(&e1->dev, e2, e3, e4)
> >>
> >> @@
> >> expression e1, e2, e3, e4;
> >> @@
> >> -    pci_unmap_single(e1, e2, e3, e4)
> >> +    dma_unmap_single(&e1->dev, e2, e3, e4)
> >>
> >> @@
> >> expression e1, e2, e3, e4, e5;
> >> @@
> >> -    pci_map_page(e1, e2, e3, e4, e5)
> >> +    dma_map_page(&e1->dev, e2, e3, e4, e5)
> >>
> >> @@
> >> expression e1, e2, e3, e4;
> >> @@
> >> -    pci_unmap_page(e1, e2, e3, e4)
> >> +    dma_unmap_page(&e1->dev, e2, e3, e4)
> >>
> >> @@
> >> expression e1, e2, e3, e4;
> >> @@
> >> -    pci_map_sg(e1, e2, e3, e4)
> >> +    dma_map_sg(&e1->dev, e2, e3, e4)
> >>
> >> @@
> >> expression e1, e2, e3, e4;
> >> @@
> >> -    pci_unmap_sg(e1, e2, e3, e4)
> >> +    dma_unmap_sg(&e1->dev, e2, e3, e4)
> >>
> >> @@
> >> expression e1, e2, e3, e4;
> >> @@
> >> -    pci_dma_sync_single_for_cpu(e1, e2, e3, e4)
> >> +    dma_sync_single_for_cpu(&e1->dev, e2, e3, e4)
> >>
> >> @@
> >> expression e1, e2, e3, e4;
> >> @@
> >> -    pci_dma_sync_single_for_device(e1, e2, e3, e4)
> >> +    dma_sync_single_for_device(&e1->dev, e2, e3, e4)
> >>
> >> @@
> >> expression e1, e2, e3, e4;
> >> @@
> >> -    pci_dma_sync_sg_for_cpu(e1, e2, e3, e4)
> >> +    dma_sync_sg_for_cpu(&e1->dev, e2, e3, e4)
> >>
> >> @@
> >> expression e1, e2, e3, e4;
> >> @@
> >> -    pci_dma_sync_sg_for_device(e1, e2, e3, e4)
> >> +    dma_sync_sg_for_device(&e1->dev, e2, e3, e4)
> >>
> >> @@
> >> expression e1, e2;
> >> @@
> >> -    pci_dma_mapping_error(e1, e2)
> >> +    dma_mapping_error(&e1->dev, e2)
> >>
> >> @@
> >> expression e1, e2;
> >> @@
> >> -    pci_set_dma_mask(e1, e2)
> >> +    dma_set_mask(&e1->dev, e2)
> >>
> >> @@
> >> expression e1, e2;
> >> @@
> >> -    pci_set_consistent_dma_mask(e1, e2)
> >> +    dma_set_coherent_mask(&e1->dev, e2)
> >>
> >> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> >> ---
> >> If needed, see post from Christoph Hellwig on the kernel-janitors ML:
> >>     https://marc.info/?l=3Dkernel-janitors&m=3D158745678307186&w=3D4
> >> ---
> >>   drivers/net/ethernet/nvidia/forcedeth.c | 6 +-----
> >>   1 file changed, 1 insertion(+), 5 deletions(-)
> >>
> >> diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/eth=
ernet/nvidia/forcedeth.c
> >> index 8724d6a9ed02..ef3fb4cc90af 100644
> >> --- a/drivers/net/ethernet/nvidia/forcedeth.c
> >> +++ b/drivers/net/ethernet/nvidia/forcedeth.c
> >> @@ -5782,15 +5782,11 @@ static int nv_probe(struct pci_dev *pci_dev, c=
onst struct pci_device_id *id)
> >>                  np->desc_ver =3D DESC_VER_3;
> >>                  np->txrxctl_bits =3D NVREG_TXRXCTL_DESC_3;
> >>                  if (dma_64bit) {
> >> -                       if (pci_set_dma_mask(pci_dev, DMA_BIT_MASK(39)=
))
> >> +                       if (dma_set_mask_and_coherent(&pci_dev->dev, D=
MA_BIT_MASK(39)))
> >>                                  dev_info(&pci_dev->dev,
> >>                                           "64-bit DMA failed, using 32=
-bit addressing\n");
> >>                          else
> >>                                  dev->features |=3D NETIF_F_HIGHDMA;
> >> -                       if (pci_set_consistent_dma_mask(pci_dev, DMA_B=
IT_MASK(39))) {
> >> -                               dev_info(&pci_dev->dev,
> >> -                                        "64-bit DMA (consistent) fail=
ed, using 32-bit ring buffers\n");
> >> -                       }
> >
> >  From the commit log, "pci_set_consistent_dma_mask(e1, e2)" should be
> > replaced by "dma_set_coherent_mask(&e1->dev, e2)".
> > But in this snippet,  "pci_set_consistent_dma_mask(e1, e2)" is not
> > replaced by "dma_set_coherent_mask(&e1->dev, e2)".
> >
> > Why?
>
> Hi,
> in the commit log I said that:
>      The patch has been generated with the coccinelle script below.
>
>      It has been hand modified to use 'dma_set_mask_and_coherent()'
>      instead of 'pci_set_dma_mask()/pci_set_consistent_dma_mask()' when
>      applicable.
>      This is less verbose.

Got it, thanks!

Reviewed-by: Zhu Yanjun <zyjzyj2000@gmail.com>

Zhu Yanjun

>
> When I started this task proposed by Christoph Hellwig ([1]), their were
> 150 files using using 'pci_set_dma_mask()' ([2]). Many of them were good
> candidate for using 'dma_set_mask_and_coherent()' but this
> transformation can not easily be done by coccinelle because it depends
> on the way the code has been written.
>
> So, I decided to hand modify and include the transformation in the many
> patches have sent to remove this deprecated API.
> Up to now, it has never been an issue.
>
> I *DO* know that it should have been a 2 steps process but this clean-up
> was too big for me (i.e. 150 files) and doing the job twice was
> discouraging.
>
> My first motivation was to remove the deprecated API. Simplifying code
> and using 'dma_set_mask_and_coherent()' when applicable was just a bonus.
>
> So, if desired, I can send a v2 without the additional transformation
> but I won't send 2 patches for that. The 'dma_set_mask_and_coherent()'
> transformation would be left apart, for whoever feels like cleaning it.
>
> CJ
>
>
> [1]: https://marc.info/?l=3Dkernel-janitors&m=3D158745678307186&w=3D4
> [2]: https://elixir.bootlin.com/linux/v5.8/A/ident/pci_set_dma_mask
>
>
> >
> > Zhu Yanjun
> >
> >
> >>                  }
> >>          } else if (id->driver_data & DEV_HAS_LARGEDESC) {
> >>                  /* packet format 2: supports jumbo frames */
> >> --
> >> 2.30.2
> >>
> >
>
