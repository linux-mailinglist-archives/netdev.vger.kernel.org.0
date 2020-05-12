Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 215EB1CED11
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 08:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728678AbgELGfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 02:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727107AbgELGfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 02:35:33 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F981C061A0E
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 23:35:32 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id f3so12654247ioj.1
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 23:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hmqc9TQ9Quh7+US/Jmh4IXg0bVpfrPAKCJNshFYSv+Q=;
        b=NvN3bHIDGwK+p0qEwYf7zjtLlsxm2ceG5S0GYtDcV8aLAqcsJfqOTGl1gkyIlhzl56
         Z9+A/IMEvGy4ZRM0/h9CnkQShR6M/HA4DFloyhf88t+b64r/X4SaOrgaUi+rdf2GGmha
         cvaSBe+ut2HCvfoRg2GMxsWf6PqOgRKYk0l6PWeo1znnU/k7z8yLPqV2DkosG+22KThS
         +pXuvun5l0Uwje9BpaVzjG2kJpbk1JW2IVBJFyar1BKa7F61PvPqDdP1c4wfHS485XIc
         MlKgocOGFtkGz3BKYGLQ6g5TKWxZpOJYjdJlC9flK8333jlQOL1oOx4rRvibwF2SEbz1
         RWdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hmqc9TQ9Quh7+US/Jmh4IXg0bVpfrPAKCJNshFYSv+Q=;
        b=D9q1wu6JxZ56f6ZqSxx0OkhykSajog6JAxSzPI80ZdtlV4wFHHOFoZ8AwEkzz7Rc9Z
         TivCrqk5FPEUbialXDBJZf44VqhoqjmHa7E63/4JU1rU+DBmIhfvas2xPrb3+zlcDpBH
         TZRWGhUCptZuDBMDPTZ5cf6FP3dmEFRk4SsjehbppjxOYhyuWLe3cQ+wSCQPTcxdwmuP
         lidfbfYNlUQV+arGbv58eFEk6bpEXoEdaNG4m4IeyPANLds9i4wultwCmBX7NAOYSiWh
         pt12epeM4e9Pv04KImXjm2j437GmkY7gniepGcJGwAuWE7gBObflmRywBoe5lqpgMKaS
         jFXQ==
X-Gm-Message-State: AGi0PubMq/gEVzwBFLu1inH1RHGt5JxBUDGIha4BTuuu6PQLiXVzSZa5
        shLiR0uHyYFlNqOov9ZLYzYDdWK33QlP8+9teQsAbw==
X-Google-Smtp-Source: APiQypLWnzw4EWWNr1vmFUqwTdjDAprfuZXfBBKAg6Df7mrHkghpjwc+KH+GGaVrIhljRYARBkWpEGcIU/MDkPlDt6c=
X-Received: by 2002:a05:6638:68f:: with SMTP id i15mr19299578jab.136.1589265331761;
 Mon, 11 May 2020 23:35:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200511150759.18766-1-brgl@bgdev.pl> <20200511150759.18766-10-brgl@bgdev.pl>
 <dab80587-a196-e0ab-ae97-f8e5cc4a71d4@gmail.com>
In-Reply-To: <dab80587-a196-e0ab-ae97-f8e5cc4a71d4@gmail.com>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Tue, 12 May 2020 08:35:21 +0200
Message-ID: <CAMRc=MeAMHs3jYh5KpbO5pAqO_cTmc71US_aVAFqRpNBnEYVMg@mail.gmail.com>
Subject: Re: [PATCH v2 09/14] net: ethernet: mtk-eth-mac: new driver
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-mediatek@lists.infradead.org,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pon., 11 maj 2020 o 21:24 Florian Fainelli <f.fainelli@gmail.com> napisa=C5=
=82(a):
>
>
>
> On 5/11/2020 8:07 AM, Bartosz Golaszewski wrote:
> > From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> >
> > This adds the driver for the MediaTek Ethernet MAC used on the MT8* SoC
> > family. For now we only support full-duplex.
> >
> > Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> > ---
>
> [snip]
>
> > +static int mtk_mac_ring_pop_tail(struct mtk_mac_ring *ring,
> > +                              struct mtk_mac_ring_desc_data *desc_data=
)
> > +{
> > +     struct mtk_mac_ring_desc *desc =3D &ring->descs[ring->tail];
> > +     unsigned int status;
> > +
> > +     /* Let the device release the descriptor. */
> > +     dma_rmb();
> > +     status =3D desc->status;
> > +
> > +     if (!(status & MTK_MAC_DESC_BIT_COWN))
> > +             return -1;
> > +
> > +     desc_data->len =3D status & MTK_MAC_DESC_MSK_LEN;
> > +     desc_data->flags =3D status & ~MTK_MAC_DESC_MSK_LEN;
> > +     desc_data->dma_addr =3D desc->data_ptr;
> > +     desc_data->skb =3D ring->skbs[ring->tail];
> > +
> > +     desc->data_ptr =3D 0;
> > +     desc->status =3D MTK_MAC_DESC_BIT_COWN;
> > +     if (status & MTK_MAC_DESC_BIT_EOR)
> > +             desc->status |=3D MTK_MAC_DESC_BIT_EOR;
>
> Don't you need a dma_wmb() for the device to observe the new descriptor
> here?
>

HW has released the descriptor (set the COWN bit) and I just clear all
other bits here really. Yeah, I guess it won't hurt to make sure.

> [snip]
>
> > +static void mtk_mac_dma_unmap_tx(struct mtk_mac_priv *priv,
> > +                              struct mtk_mac_ring_desc_data *desc_data=
)
> > +{
> > +     struct device *dev =3D mtk_mac_get_dev(priv);
> > +
> > +     return dma_unmap_single(dev, desc_data->dma_addr,
> > +                             desc_data->len, DMA_TO_DEVICE);
>
> If you stored a pointer to the sk_buff you transmitted, then you would
> need an expensive read to the descriptor to determine the address and
> length, and you would also not be at the mercy of the HW putting
> incorrect values there.
>

You mean store the mapped addresses? Yeah I can do that but I'll still
need to read the descriptor memory to verify it was released by HW.

> sp
> > +static void mtk_mac_dma_init(struct mtk_mac_priv *priv)
> > +{
> > +     struct mtk_mac_ring_desc *desc;
> > +     unsigned int val;
> > +     int i;
> > +
> > +     priv->descs_base =3D (struct mtk_mac_ring_desc *)priv->ring_base;
> > +
> > +     for (i =3D 0; i < MTK_MAC_NUM_DESCS_TOTAL; i++) {
> > +             desc =3D &priv->descs_base[i];
> > +
> > +             memset(desc, 0, sizeof(*desc));
> > +             desc->status =3D MTK_MAC_DESC_BIT_COWN;
> > +             if ((i =3D=3D MTK_MAC_NUM_TX_DESCS - 1) ||
> > +                 (i =3D=3D MTK_MAC_NUM_DESCS_TOTAL - 1))
> > +                     desc->status |=3D MTK_MAC_DESC_BIT_EOR;
> > +     }
> > +
> > +     mtk_mac_ring_init(&priv->tx_ring, priv->descs_base, 0);
> > +     mtk_mac_ring_init(&priv->rx_ring,
> > +                       priv->descs_base + MTK_MAC_NUM_TX_DESCS,
> > +                       MTK_MAC_NUM_RX_DESCS);
> > +
> > +     /* Set DMA pointers. */
> > +     val =3D (unsigned int)priv->dma_addr;
>
> You would probably add a WARN_ON() or something that catches the upper
> 32-bits of the dma_addr being set, see my comment about the DMA mask
> setting.
>

Can it still happen if I check the return value of dma_set_mask_and_coheren=
t()?

> [snip]
>
> > +static void mtk_mac_tx_complete_all(struct mtk_mac_priv *priv)
> > +{
> > +     struct net_device *ndev =3D priv_to_netdev(priv);
> > +     struct mtk_mac_ring *ring =3D &priv->tx_ring;
> > +     int ret;
> > +
> > +     for (;;) {
> > +             mtk_mac_lock(priv);
> > +
> > +             if (!mtk_mac_ring_descs_available(ring)) {
> > +                     mtk_mac_unlock(priv);
> > +                     break;
> > +             }
> > +
> > +             ret =3D mtk_mac_tx_complete_one(priv);
> > +             if (ret) {
> > +                     mtk_mac_unlock(priv);
> > +                     break;
> > +             }
> > +
> > +             if (netif_queue_stopped(ndev))
> > +                     netif_wake_queue(ndev);
> > +
> > +             mtk_mac_unlock(priv);
> > +     }
>
> Where do you increment the net_device statistics to indicate the bytes
> and packets transmitted?
>

I don't. I use the counters provided by HW for that.

> [snip]
>
> > +     mtk_mac_set_mode_rmii(priv);
> > +
> > +     dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
>
> Your code assumes that DMA addresses are not going to be >=3D 4GB so you
> should be checking this function's return code and abort here otherwise
> your driver will fail in surprisingly difficult ways to debug.

Sure, thanks.

Bart
