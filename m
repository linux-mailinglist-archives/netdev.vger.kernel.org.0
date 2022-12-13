Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4628164AE60
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 04:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233770AbiLMDp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 22:45:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiLMDp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 22:45:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F5EC1C11A
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 19:45:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670903100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=256Ct247/EiVmrEdEn67dwnBON0/XMOLy97CHVgBe6k=;
        b=hEaG0tWb+FThG+/4Pgex64ksnwJpEDOPZMu3+8ASFbBlQ6Le38pglPVUuGEUwkEWIj3STg
        JFVVqP8H1t7d5lOXgebQ5g8TUkiu492/CHvAXP9vruBgQnC4d0Yz6EesZ+zCCG9Aee4ryG
        2NzRKAxRMXSv7LGkWHwb7DafwtD8pB0=
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com
 [209.85.160.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-2-6xdee6HRPvW_1Tk3HqaBcQ-1; Mon, 12 Dec 2022 22:43:47 -0500
X-MC-Unique: 6xdee6HRPvW_1Tk3HqaBcQ-1
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-1438729f685so3253367fac.19
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 19:43:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=256Ct247/EiVmrEdEn67dwnBON0/XMOLy97CHVgBe6k=;
        b=dlsIRJZ9dZyEkPihuS+ECyiAdYIfERe+3NiDUhPZuYZ84lijosQRBngCV4sTLTD/DR
         bPbnnrXe6puplJVrnjBNYeVhhchLzeMpCPuWb2xgT6n1eP0GeGmLUoBEE+GD5KpEXVHZ
         KPrzU0kgXtnJ/Hm9Kd9sbz8BqMU74JVa7YOD6VbLMBlhuGJv+hKtEtmlSvDN+zWvJ1zJ
         UMz/SS+1iPtevj17GI0wWyy15J97wJJiEvRY12E7VqWoBicNlT2UUoOVJhJo7N6HZO4F
         V05uR72+1bmu/FoY0r6ZUbmaYxG3VEEZUIUR5bxUunsdeNqhLjjrpUhFS0qMEImzS5+1
         eASA==
X-Gm-Message-State: ANoB5plx0zHPsjXKCmLYWrD78JrCrc7gQDFdbYFhs7RKieO2doLBONbR
        lO9FWJbWxvOMMewpuduM1F3bMvesMCzkqU6Uw1as2zyL+EvpKoaAZVob5WjMaCMCAUip/SxpptE
        1nIaIs3RhsvzSQ/y/6Vph9ZClMc2I5r94
X-Received: by 2002:a05:6808:114c:b0:35e:7a42:7ab5 with SMTP id u12-20020a056808114c00b0035e7a427ab5mr78515oiu.280.1670903027122;
        Mon, 12 Dec 2022 19:43:47 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4i4kic2ykAAWbr0s266j2XeYnzV4cUv9APvGz4jsQq5Lkz/4gL5C2yVDhzy6BQW2tEKIdWrVGMCJkUIbL2Bvk=
X-Received: by 2002:a05:6808:114c:b0:35e:7a42:7ab5 with SMTP id
 u12-20020a056808114c00b0035e7a427ab5mr78511oiu.280.1670903026927; Mon, 12 Dec
 2022 19:43:46 -0800 (PST)
MIME-Version: 1.0
References: <20221212091029.54390-1-jasowang@redhat.com> <20221212042144-mutt-send-email-mst@kernel.org>
 <1670902391.9610498-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1670902391.9610498-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 13 Dec 2022 11:43:36 +0800
Message-ID: <CACGkMEu=1CcoNvvV9M+QrG5sLUBoPYkZ3DvUe+pLc1fSvgLuHA@mail.gmail.com>
Subject: Re: [PATCH net] virtio-net: correctly enable callback during start_xmit
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
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

On Tue, Dec 13, 2022 at 11:38 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>
> On Mon, 12 Dec 2022 04:25:22 -0500, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > On Mon, Dec 12, 2022 at 05:10:29PM +0800, Jason Wang wrote:
> > > Commit a7766ef18b33("virtio_net: disable cb aggressively") enables
> > > virtqueue callback via the following statement:
> > >
> > >         do {
> > >            ......
> > >     } while (use_napi && kick &&
> > >                unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
> > >
> > > This will cause a missing call to virtqueue_enable_cb_delayed() when
> > > kick is false. Fixing this by removing the checking of the kick from
> > > the condition to make sure callback is enabled correctly.
> > >
> > > Fixes: a7766ef18b33 ("virtio_net: disable cb aggressively")
> > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > ---
> > > The patch is needed for -stable.
> >
> > stable rules don't allow for theoretical fixes. Was a problem observed?

Yes, running a pktgen sample script can lead to a tx timeout.

> >
> > > ---
> > >  drivers/net/virtio_net.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index 86e52454b5b5..44d7daf0267b 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -1834,8 +1834,8 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
> > >
> > >             free_old_xmit_skbs(sq, false);
> > >
> > > -   } while (use_napi && kick &&
> > > -          unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
> > > +   } while (use_napi &&
> > > +            unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
> > >
> >
> > A bit more explanation pls.  kick simply means !netdev_xmit_more -
> > if it's false we know there will be another packet, then transmissing
> > that packet will invoke virtqueue_enable_cb_delayed. No?
>
> It's just that there may be a next packet, but in fact there may not be.
> For example, the vq is full, and the driver stops the queue.

Exactly, when the queue is about to be full we disable tx and wait for
the next tx interrupt to re-enable tx.

Thanks

>
> Thanks.
>
> >
> >
> >
> >
> >
> > >     /* timestamp packet in software */
> > >     skb_tx_timestamp(skb);
> > > --
> > > 2.25.1
> >
> > _______________________________________________
> > Virtualization mailing list
> > Virtualization@lists.linux-foundation.org
> > https://lists.linuxfoundation.org/mailman/listinfo/virtualization
>

