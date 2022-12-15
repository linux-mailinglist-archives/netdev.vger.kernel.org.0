Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBB064D864
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 10:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiLOJRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 04:17:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbiLOJQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 04:16:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D64761BEA7
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 01:15:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671095757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lC0q2v1Ms1RwMBWk+EIJ5wdM8fzD9SD5v3dqY2kTOsc=;
        b=EI4jYyaVyrJ7Bvg8cfz5JEZD9Fqk/ffp+4eAw91sKGMM3g5/mKCGtNNArizKicbwx9h28H
        vCEMNLDspfYW42fy9I32Msv3bPyn54mttWXymUrCK+R0R6KEGEatRCluAIWRnbBu6mIFib
        RpwobrSDzpgVJ/5eK5L0Bnk+FO6FMpQ=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-277-ZFYv5xpYPZ-A8yLkxMgdLg-1; Thu, 15 Dec 2022 04:15:55 -0500
X-MC-Unique: ZFYv5xpYPZ-A8yLkxMgdLg-1
Received: by mail-ot1-f71.google.com with SMTP id x26-20020a9d629a000000b0066ea531ed32so3100383otk.6
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 01:15:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lC0q2v1Ms1RwMBWk+EIJ5wdM8fzD9SD5v3dqY2kTOsc=;
        b=XyqcEQclbU++86zptYAYDhVoR7meBKqNA5hf4yBNLnrvLOLSCGLhh++Bdb8QUMxH0h
         QFP4aky7EphJPJOPfUj82hphGJEaGxCRi7mx2FLQmbPhPA+N2KKswn79CPnvJCOFXktH
         rfrvmANNm/CGjnKqQCrI3+3boQ76tFORHdg9KdsVW0v4HKgICh+iy/RH9VQKXCD+8Xrr
         KSuSatN0+MxyO0yVmP0FSqk/ajIl9kr27GKy8VHJdIj2BMrimrEEe0b7gtMAGtZ9Cs5y
         RlrBXHmJTVm2VMR8ODjrP32qx87ZSkqiGFEHleULskhRu3TFw5Mhjyz5HUc9rft3lJ8z
         iTNQ==
X-Gm-Message-State: ANoB5pnmK2Jrs84iosFyx8wLDEXAEQZPrMnDlFIoj6Og/5hsznQuQzus
        wX7353lcuux26FnbPBLqnWeu2TxXk5N7dWh63dcILyd4AF0UgLMfjPkJvDhRhmpjhdSmQ0P+Hfo
        zrCNSSY62pUXgJWGYJi42WCAxO+UmyXgl
X-Received: by 2002:a05:6870:9e8f:b0:144:a97b:1ae2 with SMTP id pu15-20020a0568709e8f00b00144a97b1ae2mr95012oab.35.1671095754731;
        Thu, 15 Dec 2022 01:15:54 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5EHbNOPkZfylg33J79++dPcOATXw0I6yodET6T4YfzW2bTB6xnRR0Mde8v49QFni7U7MDkwOsKmYmKzb3k5JU=
X-Received: by 2002:a05:6870:9e8f:b0:144:a97b:1ae2 with SMTP id
 pu15-20020a0568709e8f00b00144a97b1ae2mr95002oab.35.1671095754482; Thu, 15 Dec
 2022 01:15:54 -0800 (PST)
MIME-Version: 1.0
References: <20221215032719.72294-1-jasowang@redhat.com> <20221215034740-mutt-send-email-mst@kernel.org>
In-Reply-To: <20221215034740-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 15 Dec 2022 17:15:43 +0800
Message-ID: <CACGkMEsLeCRDqyuyGzWw+kjYrTVDjUjOw6+xHESPT2D1p03=sQ@mail.gmail.com>
Subject: Re: [PATCH net V2] virtio-net: correctly enable callback during start_xmit
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xuanzhuo@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 15, 2022 at 5:02 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Thu, Dec 15, 2022 at 11:27:19AM +0800, Jason Wang wrote:
> > Commit a7766ef18b33("virtio_net: disable cb aggressively") enables
> > virtqueue callback via the following statement:
> >
> >         do {
> >            ......
> >       } while (use_napi && kick &&
> >                unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
> >
> > When NAPI is used and kick is false, the callback won't be enabled
> > here. And when the virtqueue is about to be full, the tx will be
> > disabled, but we still don't enable tx interrupt which will cause a TX
> > hang. This could be observed when using pktgen with burst enabled.
> >
> > Fixing this by trying to enable tx interrupt after we disable TX when
> > we're not using napi or kick is false.
> >
> > Fixes: a7766ef18b33 ("virtio_net: disable cb aggressively")
> > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > ---
> > The patch is needed for -stable.
> > Changes since V1:
> > - enable tx interrupt after we disable tx
> > ---
> >  drivers/net/virtio_net.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 86e52454b5b5..dcf3a536d78a 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -1873,7 +1873,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
> >        */
> >       if (sq->vq->num_free < 2+MAX_SKB_FRAGS) {
> >               netif_stop_subqueue(dev, qnum);
> > -             if (!use_napi &&
> > +             if ((!use_napi || !kick) &&
> >                   unlikely(!virtqueue_enable_cb_delayed(sq->vq))) {
> >                       /* More just got used, free them then recheck. */
> >                       free_old_xmit_skbs(sq, false);
>
> This will work but the following lines are:
>
>                        if (sq->vq->num_free >= 2+MAX_SKB_FRAGS) {
>                                 netif_start_subqueue(dev, qnum);
>                                 virtqueue_disable_cb(sq->vq);
>                         }
>
>
> and I thought we are supposed to keep callbacks enabled with napi?

This seems to be the opposite logic of commit a7766ef18b33 that
disables callbacks for NAPI.

It said:

    There are currently two cases where we poll TX vq not in response to a
    callback: start xmit and rx napi.  We currently do this with callbacks
    enabled which can cause extra interrupts from the card.  Used not to be
    a big issue as we run with interrupts disabled but that is no longer the
    case, and in some cases the rate of spurious interrupts is so high
    linux detects this and actually kills the interrupt.

My undersatnding is that it tries to disable callbacks on TX.

> One of the ideas of napi is to free on napi callback, not here
> immediately.
>
> I think it is easier to just do a separate branch here. Along the
> lines of:
>
>                 if (use_napi) {
>                         if (unlikely(!virtqueue_enable_cb_delayed(sq->vq)))
>                                 virtqueue_napi_schedule(napi, vq);

This seems to be a new logic and it causes some delay in processing TX
(unnecessary NAPI).

>                 } else {
>                         ... old code ...
>                 }
>
> also reduces chances of regressions on !napi (which is not well tested)
> and keeps callbacks off while we free skbs.

I think my patch doesn't change the logic of !napi? (It checks !napi || kick).

Thanks

>
> No?
>
>
> > --
> > 2.25.1
>

