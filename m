Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB9F1E3C77
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 10:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388200AbgE0IqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 04:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388107AbgE0IqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 04:46:20 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02E5CC061A0F
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 01:46:20 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id k18so25131116ion.0
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 01:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cpwITzrftWrJAY0LVaSeu6jYTmkJe1PVewzQjLawjdA=;
        b=GxKyCH668dBc5VipkdT8YFjPTCx5H6Ette6THzOjjs/DRDGNcXIMDQi5ZP5v3Sf9Oa
         mwVrP6RSqnYeL10DiHJM1SOkKIcn6brwgQRHX0b0oKqUeDUGj/rjNQW55Xq53NQfseRD
         vXhZTU3mB8ZA8VEHKczO26DPAktbj8hdettUmRE8i6vyRvcYoYFGvApZ8ukhZ5+bQK7D
         9L8+5xCW38IQadhYPoyI/PQs166Rw+w8+8SWRYvSIyYFnkV+77MOB9qUtGq2ER6cdPV/
         +/sr0UAOp1UfaGH7K0FiwaDoGqoJN+EI3wjFXv9n4Zv/oSigkjbvRq3z7WEgWAq+aZOX
         0EsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cpwITzrftWrJAY0LVaSeu6jYTmkJe1PVewzQjLawjdA=;
        b=NgPJtcJvX887u1MAWoRx6bViAixSn0ACW43Pk/cVN6cOgixDnqOnSF/NKydlyqjX/v
         3EWS8m3IFyAxWARZctEikRtRWxaieQk+YLWQi5un1N69N4hjLboKSPtw8fc20PW8AWjq
         Nuz57dfxAFNVwQdbRCM+EXbQ6c3/kNEfeOPan955damzK63jtYK4wcpuX/NGsh60X3qu
         swrayKLTBxKAD3dkMQDmvBcCsbI9+sEHdXpDrvcFdH7tZR0sOAtya6lX67BiMn/RX+VP
         E9rck4S/VW1eKXvoMLdWiM8ZppT++jXEJ0WOcgGcsp9/eKFUAXCfv8ovvZkkdNbqS0k5
         S5oQ==
X-Gm-Message-State: AOAM531+iL2Chn1UAA6xV3ylBqrtQmT+lzSNYU+Xqwvoox99Go09u6+W
        /FXe5DtH7Ah5+cliJvLX2NmNtffy1cmPcH9mHNS2FQ==
X-Google-Smtp-Source: ABdhPJwMXQdy6+RxEU74Dd9WQ5Tly2o2sH55kV9ZSrhh4NH0gl/D2WFHak2VKletNu2Ql3a2wNrDFJNkEIRMls/7rZo=
X-Received: by 2002:a02:3e06:: with SMTP id s6mr4481666jas.57.1590569179357;
 Wed, 27 May 2020 01:46:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200522120700.838-1-brgl@bgdev.pl> <20200522120700.838-7-brgl@bgdev.pl>
 <20200527073150.GA3384158@ubuntu-s3-xlarge-x86>
In-Reply-To: <20200527073150.GA3384158@ubuntu-s3-xlarge-x86>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Wed, 27 May 2020 10:46:08 +0200
Message-ID: <CAMRc=MevVsYZFDQif+8Zyv41sSkbS8XqWbKGdCvHooneXz88hg@mail.gmail.com>
Subject: Re: [PATCH v5 06/11] net: ethernet: mtk-star-emac: new driver
To:     Nathan Chancellor <natechancellor@gmail.com>
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
        "moderated list:ARM/Mediatek SoC..." 
        <linux-mediatek@lists.infradead.org>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=C5=9Br., 27 maj 2020 o 09:31 Nathan Chancellor <natechancellor@gmail.com>
napisa=C5=82(a):
>
> On Fri, May 22, 2020 at 02:06:55PM +0200, Bartosz Golaszewski wrote:
>
> <snip>
>
> > diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/ne=
t/ethernet/mediatek/mtk_star_emac.c
> > new file mode 100644
> > index 000000000000..789c77af501f
> > --- /dev/null
> > +++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
> > @@ -0,0 +1,1678 @@
>
> <snip>
>
> I've searched netdev and I cannot find any reports from others but this
> function introduces a clang warning:
>
> drivers/net/ethernet/mediatek/mtk_star_emac.c:1296:6: warning: variable '=
new_dma_addr' is used uninitialized whenever 'if' condition is true [-Wsome=
times-uninitialized]
>         if (!new_skb) {
>             ^~~~~~~~
> drivers/net/ethernet/mediatek/mtk_star_emac.c:1321:23: note: uninitialize=
d use occurs here
>         desc_data.dma_addr =3D new_dma_addr;
>                              ^~~~~~~~~~~~
> drivers/net/ethernet/mediatek/mtk_star_emac.c:1296:2: note: remove the 'i=
f' if its condition is always false
>         if (!new_skb) {
>         ^~~~~~~~~~~~~~~
> drivers/net/ethernet/mediatek/mtk_star_emac.c:1285:6: warning: variable '=
new_dma_addr' is used uninitialized whenever 'if' condition is true [-Wsome=
times-uninitialized]
>         if ((desc_data.flags & MTK_STAR_DESC_BIT_RX_CRCE) ||
>             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/mediatek/mtk_star_emac.c:1321:23: note: uninitialize=
d use occurs here
>         desc_data.dma_addr =3D new_dma_addr;
>                              ^~~~~~~~~~~~
> drivers/net/ethernet/mediatek/mtk_star_emac.c:1285:2: note: remove the 'i=
f' if its condition is always false
>         if ((desc_data.flags & MTK_STAR_DESC_BIT_RX_CRCE) ||
>         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/mediatek/mtk_star_emac.c:1285:6: warning: variable '=
new_dma_addr' is used uninitialized whenever '||' condition is true [-Wsome=
times-uninitialized]
>         if ((desc_data.flags & MTK_STAR_DESC_BIT_RX_CRCE) ||
>             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/mediatek/mtk_star_emac.c:1321:23: note: uninitialize=
d use occurs here
>         desc_data.dma_addr =3D new_dma_addr;
>                              ^~~~~~~~~~~~
> drivers/net/ethernet/mediatek/mtk_star_emac.c:1285:6: note: remove the '|=
|' if its condition is always false
>         if ((desc_data.flags & MTK_STAR_DESC_BIT_RX_CRCE) ||
>             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/mediatek/mtk_star_emac.c:1274:25: note: initialize t=
he variable 'new_dma_addr' to silence this warning
>         dma_addr_t new_dma_addr;
>                                ^
>                                 =3D 0
> 3 warnings generated.
>
> > +static int mtk_star_receive_packet(struct mtk_star_priv *priv)
> > +{
> > +     struct mtk_star_ring *ring =3D &priv->rx_ring;
> > +     struct device *dev =3D mtk_star_get_dev(priv);
> > +     struct mtk_star_ring_desc_data desc_data;
> > +     struct net_device *ndev =3D priv->ndev;
> > +     struct sk_buff *curr_skb, *new_skb;
> > +     dma_addr_t new_dma_addr;
>
> Uninitialized here
>
> > +     int ret;
> > +
> > +     spin_lock(&priv->lock);
> > +     ret =3D mtk_star_ring_pop_tail(ring, &desc_data);
> > +     spin_unlock(&priv->lock);
> > +     if (ret)
> > +             return -1;
> > +
> > +     curr_skb =3D desc_data.skb;
> > +
> > +     if ((desc_data.flags & MTK_STAR_DESC_BIT_RX_CRCE) ||
> > +         (desc_data.flags & MTK_STAR_DESC_BIT_RX_OSIZE)) {
> > +             /* Error packet -> drop and reuse skb. */
> > +             new_skb =3D curr_skb;
> > +             goto push_new_skb;
>
> this goto
>
> > +     }
> > +
> > +     /* Prepare new skb before receiving the current one. Reuse the cu=
rrent
> > +      * skb if we fail at any point.
> > +      */
> > +     new_skb =3D mtk_star_alloc_skb(ndev);
> > +     if (!new_skb) {
> > +             ndev->stats.rx_dropped++;
> > +             new_skb =3D curr_skb;
> > +             goto push_new_skb;
>
> and this goto
>
> > +     }
> > +
> > +     new_dma_addr =3D mtk_star_dma_map_rx(priv, new_skb);
> > +     if (dma_mapping_error(dev, new_dma_addr)) {
> > +             ndev->stats.rx_dropped++;
> > +             dev_kfree_skb(new_skb);
> > +             new_skb =3D curr_skb;
> > +             netdev_err(ndev, "DMA mapping error of RX descriptor\n");
> > +             goto push_new_skb;
> > +     }
> > +
> > +     /* We can't fail anymore at this point: it's safe to unmap the sk=
b. */
> > +     mtk_star_dma_unmap_rx(priv, &desc_data);
> > +
> > +     skb_put(desc_data.skb, desc_data.len);
> > +     desc_data.skb->ip_summed =3D CHECKSUM_NONE;
> > +     desc_data.skb->protocol =3D eth_type_trans(desc_data.skb, ndev);
> > +     desc_data.skb->dev =3D ndev;
> > +     netif_receive_skb(desc_data.skb);
> > +
> > +push_new_skb:
> > +     desc_data.dma_addr =3D new_dma_addr;
>
> assign it uninitialized here.
>
> > +     desc_data.len =3D skb_tailroom(new_skb);
> > +     desc_data.skb =3D new_skb;
> > +
> > +     spin_lock(&priv->lock);
> > +     mtk_star_ring_push_head_rx(ring, &desc_data);
> > +     spin_unlock(&priv->lock);
> > +
> > +     return 0;
> > +}
>
> I don't know if there should be a new label that excludes that
> assignment for those particular gotos or if new_dma_addr should
> be initialized to something at the top. Please take a look at
> addressing this when you get a chance.
>
> Cheers,
> Nathan

Hi Nathan,

Thanks for reporting this! I have a fix ready and will send it shortly.

Bartosz
