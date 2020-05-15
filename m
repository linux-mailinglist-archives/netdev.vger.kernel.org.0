Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC68B1D46CE
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 09:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgEOHL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 03:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726390AbgEOHL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 03:11:26 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF44C05BD09
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 00:11:26 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id y10so1576502iov.4
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 00:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tt+z2QXtaemYOTrQbr/BmXHcmpgvLLmy4PAl95FbkpU=;
        b=L/Ca4AQayrVuzBB8yZyrO3D7tYVpozvH457DvHs352Wp1VSfJKm8r//QF6MSCmpbkH
         0GwKMVW57C2OfloktcoKGNArORBe5fgunch0drFGQ5xQZvaj+Eo8HRCS7xj+ctvvkO5o
         2Pe5cGM6oFzxGek6lVJCf1KttKUZYq8neXts0QXNfklSPVsqhXTtB/1JrNepfsrNYga7
         YpczpMFX1ULJhr9cmxc52UqZwthe1YHTnnpZ+ZjVS9E+vSf2AwDcRprBLx8kSPTvc3Py
         tBeq6vWaVZbzY8gqnDJ170TbOmDwO8jGNDHUHISIcc04uugvCAXmyyL9uypFw3DHPzIa
         ReJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tt+z2QXtaemYOTrQbr/BmXHcmpgvLLmy4PAl95FbkpU=;
        b=rgHR/PKDt1ArJ/QlCwK+qLO6ZLRKWOFxcXZWI267dLMR4NEksYW1BH8yD/2bDqn2QP
         HgeTUAjyL6DtI9wu+xnJtZ1yIvuodctV3NsVQ4enio2VPKWWytJYTDxHRNp0e0TUe+8c
         LrVbOjhTZ54SdQ8T5uQZ3iXTFHjNbZbnfDI6yduSuqt9kxsXU1qKwvu4HLER5Zv2w/Ps
         LFqM7CnTKVXYoKG10CADXQKEbsbaC3Uw+QX7VKHQpl/CLGKLAfViNigTy9616mfRBZg5
         At9j/nDjy6XSL2XIKixzeKkjlO8tjxjGioWu4g4DGAmsA4LykYbbsGaMK1cNjc8X2J0T
         JAiQ==
X-Gm-Message-State: AOAM531Fa1LrPtz1yZAK/6AifZ0PT+cURu3yG2S8hAEwZaxtNFYUiSWg
        y+5l8ko7YsGBPs82VHFYMB/p5Y+NQUMCzB7OLtMwmA==
X-Google-Smtp-Source: ABdhPJw2UZPqM2c9AdQ/V2iFTXgewM1zVBwPnll86PitN+1yQpAcr0xdHMo5F1vMIZ2tP/UG8KrfG8WtcaA8puMhawg=
X-Received: by 2002:a02:a60f:: with SMTP id c15mr552139jam.24.1589526685801;
 Fri, 15 May 2020 00:11:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200514075942.10136-1-brgl@bgdev.pl> <20200514075942.10136-11-brgl@bgdev.pl>
 <CAK8P3a3=xgbvqrSpCK5h96eRH32AA7xnoK2ossvT0-cLFLzmXA@mail.gmail.com>
In-Reply-To: <CAK8P3a3=xgbvqrSpCK5h96eRH32AA7xnoK2ossvT0-cLFLzmXA@mail.gmail.com>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Fri, 15 May 2020 09:11:14 +0200
Message-ID: <CAMRc=MeypzZBHo6dJGKm4JujYyejqHxtdo7Ts95DXuL0VuMYCw@mail.gmail.com>
Subject: Re: [PATCH v3 10/15] net: ethernet: mtk-eth-mac: new driver
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Jonathan Corbet <corbet@lwn.net>, Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Fabien Parent <fparent@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        DTML <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC..." 
        <linux-mediatek@lists.infradead.org>,
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

czw., 14 maj 2020 o 18:19 Arnd Bergmann <arnd@arndb.de> napisa=C5=82(a):
>
> On Thu, May 14, 2020 at 10:00 AM Bartosz Golaszewski <brgl@bgdev.pl> wrot=
e:
> >
> > From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> >
> > This adds the driver for the MediaTek Ethernet MAC used on the MT8* SoC
> > family. For now we only support full-duplex.
> >
> > Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
>
> Looks very nice overall. Just a few things I noticed, and some ideas
> that may or may not make sense:
>
> > +/* This is defined to 0 on arm64 in arch/arm64/include/asm/processor.h=
 but
> > + * this IP doesn't work without this alignment being equal to 2.
> > + */
> > +#ifdef NET_IP_ALIGN
> > +#undef NET_IP_ALIGN
> > +#endif
> > +#define NET_IP_ALIGN                           2
>
> Maybe you should just define your own macro instead of replacing
> the normal one then?
>

I did in an earlier version and was told to use NET_IP_ALIGN but then
found out its value on arm64 doesn't work for me so I did the thing
that won't make anybody happy - redefine the existing constant. :)

> > +static void mtk_mac_lock(struct mtk_mac_priv *priv)
> > +{
> > +       spin_lock_irqsave(&priv->lock, priv->lock_flags);
> > +}
> > +
> > +static void mtk_mac_unlock(struct mtk_mac_priv *priv)
> > +{
> > +       spin_unlock_irqrestore(&priv->lock, priv->lock_flags);
> > +}
>
> This looks wrong: you should not have shared 'flags' passed into
> spin_lock_irqsave(), and I don't even see a need to use the
> irqsave variant of the lock in the first place.
>
> Maybe start by open-coding the lock and remove the wrappers
> above.
>
> Then see if you can use a cheaper spin_lock_bh() or plain spin_lock()
> instead of irqsave.
>

This is from an earlier version where I did a lot more in hard irq
context. Now that almost all of the processing happens in soft-irq
context I guess you're right - I can go with a regular spin_lock().

> Finally, see if this can be done in a lockless way by relying on
> appropriate barriers and separating the writers into separate
> cache lines. From a brief look at the driver I think it can be done
> without too much trouble.
>

Unfortunately I do need some locking. Accessing RX and TX descriptors
at the same time seems to upset the controller. I experimented a lot
with barriers but it turned out that I got a lot of weird bugs at high
throughput.

> > +static unsigned int mtk_mac_intr_read_and_clear(struct mtk_mac_priv *p=
riv)
> > +{
> > +       unsigned int val;
> > +
> > +       regmap_read(priv->regs, MTK_MAC_REG_INT_STS, &val);
> > +       regmap_write(priv->regs, MTK_MAC_REG_INT_STS, val);
> > +
> > +       return val;
> > +}
>
> Do you actually need to read the register? That is usually a relatively
> expensive operation, so if possible try to use clear the bits when
> you don't care which bits were set.
>

I do care, I'm afraid. The returned value is being used in the napi
poll callback to see which ring to process.

> > +/* All processing for TX and RX happens in the napi poll callback. */
> > +static irqreturn_t mtk_mac_handle_irq(int irq, void *data)
> > +{
> > +       struct mtk_mac_priv *priv;
> > +       struct net_device *ndev;
> > +
> > +       ndev =3D data;
> > +       priv =3D netdev_priv(ndev);
> > +
> > +       if (netif_running(ndev)) {
> > +               mtk_mac_intr_mask_all(priv);
> > +               napi_schedule(&priv->napi);
> > +       }
> > +
> > +       return IRQ_HANDLED;
>
>
> > +static int mtk_mac_netdev_start_xmit(struct sk_buff *skb,
> > +                                    struct net_device *ndev)
> > +{
> > +       struct mtk_mac_priv *priv =3D netdev_priv(ndev);
> > +       struct mtk_mac_ring *ring =3D &priv->tx_ring;
> > +       struct device *dev =3D mtk_mac_get_dev(priv);
> > +       struct mtk_mac_ring_desc_data desc_data;
> > +
> > +       desc_data.dma_addr =3D mtk_mac_dma_map_tx(priv, skb);
> > +       if (dma_mapping_error(dev, desc_data.dma_addr))
> > +               goto err_drop_packet;
> > +
> > +       desc_data.skb =3D skb;
> > +       desc_data.len =3D skb->len;
> > +
> > +       mtk_mac_lock(priv);
> > +       mtk_mac_ring_push_head_tx(ring, &desc_data);
> > +
> > +       if (mtk_mac_ring_full(ring))
> > +               netif_stop_queue(ndev);
> > +       mtk_mac_unlock(priv);
> > +
> > +       mtk_mac_dma_resume_tx(priv);
> > +
> > +       return NETDEV_TX_OK;
> > +
> > +err_drop_packet:
> > +       dev_kfree_skb(skb);
> > +       ndev->stats.tx_dropped++;
> > +       return NETDEV_TX_BUSY;
> > +}
>
> I would always add BQL flow control in new drivers, using
> netdev_sent_queue here...
>

Ok, will do.

> > +static int mtk_mac_tx_complete_one(struct mtk_mac_priv *priv)
> > +{
> > +       struct mtk_mac_ring *ring =3D &priv->tx_ring;
> > +       struct mtk_mac_ring_desc_data desc_data;
> > +       int ret;
> > +
> > +       ret =3D mtk_mac_ring_pop_tail(ring, &desc_data);
> > +       if (ret)
> > +               return ret;
> > +
> > +       mtk_mac_dma_unmap_tx(priv, &desc_data);
> > +       dev_kfree_skb_irq(desc_data.skb);
> > +
> > +       return 0;
> > +}
>
> ... and netdev_completed_queue()  here.
>

Same here.

> > +static void mtk_mac_tx_complete_all(struct mtk_mac_priv *priv)
> > +{
> > +       struct mtk_mac_ring *ring =3D &priv->tx_ring;
> > +       struct net_device *ndev =3D priv->ndev;
> > +       int ret;
> > +
> > +       for (;;) {
> > +               mtk_mac_lock(priv);
> > +
> > +               if (!mtk_mac_ring_descs_available(ring)) {
> > +                       mtk_mac_unlock(priv);
> > +                       break;
> > +               }
> > +
> > +               ret =3D mtk_mac_tx_complete_one(priv);
> > +               if (ret) {
> > +                       mtk_mac_unlock(priv);
> > +                       break;
> > +               }
> > +
> > +               if (netif_queue_stopped(ndev))
> > +                       netif_wake_queue(ndev);
> > +
> > +               mtk_mac_unlock(priv);
> > +       }
> > +}
>
> It looks like most of the stuff inside of the loop can be pulled out
> and only done once here.
>

I did that in one of the previous submissions but it was pointed out
to me that a parallel TX path may fill up the queue before I wake it.

> > +static int mtk_mac_poll(struct napi_struct *napi, int budget)
> > +{
> > +       struct mtk_mac_priv *priv;
> > +       unsigned int status;
> > +       int received =3D 0;
> > +
> > +       priv =3D container_of(napi, struct mtk_mac_priv, napi);
> > +
> > +       status =3D mtk_mac_intr_read_and_clear(priv);
> > +
> > +       /* Clean up TX */
> > +       if (status & MTK_MAC_BIT_INT_STS_TNTC)
> > +               mtk_mac_tx_complete_all(priv);
> > +
> > +       /* Receive up to $budget packets */
> > +       if (status & MTK_MAC_BIT_INT_STS_FNRC)
> > +               received =3D mtk_mac_process_rx(priv, budget);
> > +
> > +       /* One of the counter reached 0x8000000 - update stats and rese=
t all
> > +        * counters.
> > +        */
> > +       if (status & MTK_MAC_REG_INT_STS_MIB_CNT_TH) {
> > +               mtk_mac_update_stats(priv);
> > +               mtk_mac_reset_counters(priv);
> > +       }
> > +
> > +       if (received < budget)
> > +               napi_complete_done(napi, received);
> > +
> > +       mtk_mac_intr_unmask_all(priv);
> > +
> > +       return received;
> > +}
>
> I think you want to leave (at least some of) the interrupts masked
> if your budget is exhausted, to avoid generating unnecessary
> irqs.
>

The networking stack shouldn't queue any new TX packets if the queue
is stopped - is this really worth complicating the code? Looks like
premature optimization IMO.

> It may also be faster to not mask/unmask at all but just
> clear the interrupts that you have finished processing
>

Bart
