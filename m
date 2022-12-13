Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD4564B017
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 07:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234615AbiLMG7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 01:59:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbiLMG7F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 01:59:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A311519021
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 22:58:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670914687;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TG6nTIySLJL4GzMcoFkoHrZJOcHOyrIknDZjMAhUKq0=;
        b=G/kna0llW/rX0exl6hO8JfMxQcA7Ic27cKyK/YC1OMivds3007l9PkqiXavZnTh9T74k/N
        2y6Pkr0YFc09zlMPiJ6BcnNB5W7U8522zhSzfvjq2c6M/3p+O/6Rtryr0vR3bX8HW6jZ/D
        AueXsPvH8xsxzUfbLXwh/ZDQ/qaVdgY=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-172-6mKfj2k3NOqY8h0zoBgcUg-1; Tue, 13 Dec 2022 01:58:06 -0500
X-MC-Unique: 6mKfj2k3NOqY8h0zoBgcUg-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-144da30bb39so3399037fac.10
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 22:58:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TG6nTIySLJL4GzMcoFkoHrZJOcHOyrIknDZjMAhUKq0=;
        b=e2wxirJeYNbEAsgSaOMBo7U5Xhb3dnrt615Eta8EcV9hVNOBh8mYCMv0Mou22XiQdL
         yalty4wAhatZ5isulCTqElQWG6XEtOKLXI1ailVym7ra+pbtSheU7GkJ0ySMCzIHL5z2
         xT+dDhCFwD1tdU6bt8QrDkug+xEBQQB7rWxLV9NwNjoiGBgBWv6PqDrcNLa0WMkrYyjh
         KKNMcIKb/s7Kma2Fy6s8JZ/hgi1gHYzWYjC1A0hcp+9sjfCFnxCRQ2MTaFX1uYEWoufJ
         Avczzhd9OPzlm94SJAFv6noavFYwhcPUhzXMw3t/Rmh+xOj6yqNlCHXQ6K0zvInTLYi2
         m8jw==
X-Gm-Message-State: ANoB5pkJFyYdeJPYzkcq80P3urz4wRuEldSKwJchKLYixpdZpLrf0Oce
        4GoqPaYTHNRLdotmOj6b22w+t7LqQZAJI3dxZ8QqwvT1LD/IpHentbRf4GRfhTrQLOEDRRAMWDQ
        fUfSUBh9GN8RwtikIQwPOnWO2XY90WoUC
X-Received: by 2002:a05:6870:170e:b0:144:a97b:1ae2 with SMTP id h14-20020a056870170e00b00144a97b1ae2mr124203oae.35.1670914685835;
        Mon, 12 Dec 2022 22:58:05 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4q5+B7Fl7DK/u/JIISxL//DMMmbkyJdDsxO+tjxYnaAJ9f8ZhI/Xt7Ljn+PCpZVIIixCW/Btptl5YKy40YUOc=
X-Received: by 2002:a05:6870:170e:b0:144:a97b:1ae2 with SMTP id
 h14-20020a056870170e00b00144a97b1ae2mr124202oae.35.1670914685564; Mon, 12 Dec
 2022 22:58:05 -0800 (PST)
MIME-Version: 1.0
References: <20221212091029.54390-1-jasowang@redhat.com> <20221212042144-mutt-send-email-mst@kernel.org>
 <1670902391.9610498-1-xuanzhuo@linux.alibaba.com> <CACGkMEu=1CcoNvvV9M+QrG5sLUBoPYkZ3DvUe+pLc1fSvgLuHA@mail.gmail.com>
 <20221213013231-mutt-send-email-mst@kernel.org>
In-Reply-To: <20221213013231-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 13 Dec 2022 14:57:54 +0800
Message-ID: <CACGkMEukRrOWghcBXiqPrOtNbdjdDJUW7-cg9PsdtsVs1SuCyQ@mail.gmail.com>
Subject: Re: [PATCH net] virtio-net: correctly enable callback during start_xmit
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 13, 2022 at 2:38 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Tue, Dec 13, 2022 at 11:43:36AM +0800, Jason Wang wrote:
> > On Tue, Dec 13, 2022 at 11:38 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
> > >
> > > On Mon, 12 Dec 2022 04:25:22 -0500, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > > On Mon, Dec 12, 2022 at 05:10:29PM +0800, Jason Wang wrote:
> > > > > Commit a7766ef18b33("virtio_net: disable cb aggressively") enables
> > > > > virtqueue callback via the following statement:
> > > > >
> > > > >         do {
> > > > >            ......
> > > > >     } while (use_napi && kick &&
> > > > >                unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
> > > > >
> > > > > This will cause a missing call to virtqueue_enable_cb_delayed() when
> > > > > kick is false. Fixing this by removing the checking of the kick from
> > > > > the condition to make sure callback is enabled correctly.
> > > > >
> > > > > Fixes: a7766ef18b33 ("virtio_net: disable cb aggressively")
> > > > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > > > ---
> > > > > The patch is needed for -stable.
> > > >
> > > > stable rules don't allow for theoretical fixes. Was a problem observed?
> >
> > Yes, running a pktgen sample script can lead to a tx timeout.
>
> Since April 2021 and we only noticed now? Are you sure it's the
> right Fixes tag?

Well, reverting a7766ef18b33 makes pktgen work again.

The reason we doesn't notice is probably because:

1) We don't support BQL, so no bulk dequeuing (skb list) in normal traffic
2) When burst is enabled for pktgen, it can do bulk xmit via skb list by its own

>
> > > >
> > > > > ---
> > > > >  drivers/net/virtio_net.c | 4 ++--
> > > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > > >
> > > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > > index 86e52454b5b5..44d7daf0267b 100644
> > > > > --- a/drivers/net/virtio_net.c
> > > > > +++ b/drivers/net/virtio_net.c
> > > > > @@ -1834,8 +1834,8 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
> > > > >
> > > > >             free_old_xmit_skbs(sq, false);
> > > > >
> > > > > -   } while (use_napi && kick &&
> > > > > -          unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
> > > > > +   } while (use_napi &&
> > > > > +            unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
> > > > >
> > > >
> > > > A bit more explanation pls.  kick simply means !netdev_xmit_more -
> > > > if it's false we know there will be another packet, then transmissing
> > > > that packet will invoke virtqueue_enable_cb_delayed. No?
> > >
> > > It's just that there may be a next packet, but in fact there may not be.
> > > For example, the vq is full, and the driver stops the queue.
> >
> > Exactly, when the queue is about to be full we disable tx and wait for
> > the next tx interrupt to re-enable tx.
> >
> > Thanks
>
> OK, it's a good idea to document that.

Will do.

> And we should enable callbacks at that point, not here on data path.

I'm not sure I understand here. Are you suggesting removing the
!user_napi check here?

                if (!use_napi &&
                    unlikely(!virtqueue_enable_cb_delayed(sq->vq))) {
                        /* More just got used, free them then recheck. */
                        free_old_xmit_skbs(sq, false);
                        if (sq->vq->num_free >= 2+MAX_SKB_FRAGS) {
                                netif_start_subqueue(dev, qnum);
                                virtqueue_disable_cb(sq->vq);
                        }
                }

Btw, it doesn't differ too much as kick is always true without pktgen
and that may even need more comments or make the code even harder to
read. We need a patch for -stable at least so I prefer to let this
patch go first and do optimization on top.

Thanks

>
>
> > >
> > > Thanks.
> > >
> > > >
> > > >
> > > >
> > > >
> > > >
> > > > >     /* timestamp packet in software */
> > > > >     skb_tx_timestamp(skb);
> > > > > --
> > > > > 2.25.1
> > > >
> > > > _______________________________________________
> > > > Virtualization mailing list
> > > > Virtualization@lists.linux-foundation.org
> > > > https://lists.linuxfoundation.org/mailman/listinfo/virtualization
> > >
>

