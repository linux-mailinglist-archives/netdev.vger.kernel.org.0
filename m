Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6C764AFF9
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 07:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234504AbiLMGjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 01:39:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234299AbiLMGjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 01:39:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A6FAB1E4
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 22:38:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670913513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pG8pk6806WunH38LK3XOKaKNRvcbToIEcrDuqWIIVJA=;
        b=WPv/CugNotPkU+9cXluW0NQxlp2YZPVS4xulEBtd3ycVegMfgnqJJmkyJ7w7TXO57qHwha
        Rjxw8ojjRz7oS5TFR6IFcaHByY0i/cWRoS7g7J5jUAOBCi8Bnbh+w6g3hFX1GZNMubfBBm
        4LczDlgmO0MD6cgAq4espswqjnju3so=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-670-UhN-p7reO0mCLV92wg15sA-1; Tue, 13 Dec 2022 01:38:32 -0500
X-MC-Unique: UhN-p7reO0mCLV92wg15sA-1
Received: by mail-wm1-f71.google.com with SMTP id p14-20020a05600c204e00b003cf4cce4da5so2612761wmg.0
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 22:38:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pG8pk6806WunH38LK3XOKaKNRvcbToIEcrDuqWIIVJA=;
        b=dviVq3pFdCqI+NE89l8l5PP0edreZYbvcRsrwKwyysHaN2LGOI48zYFzzkhBFHXPT1
         7nLQpmLArM3PAk8uV/30cTILLUFJivnb/tUXnkkxDxzOaRU+B9djHYp0QmK3kDxfH+0R
         UlLUjlMis7HG/4RKgnLPvbqoUkGIqG1nRoKWmSrGoAPlSXvUR7GxuAwwGxybwKQroAHB
         o4YXxQJKowjrPJCXAfBOL23jeNnzATK9rveK0QN7OWDU3WbZ7GupCX/OHUywwhKuIKb/
         u4QO7GcqhnKdU87D7lqFVw6NoexEvP3hm+wj2eTZXYc3h6RY8Ph6oba/j1u3V+JpysPK
         Tjyw==
X-Gm-Message-State: ANoB5pm3a7BFSFFjk2OMEU3NYwlallDPIAOCI3Rj8IMdR3cxLza4beu9
        tuLICjU2g8AH9CsE+83nyV8i5IUJwczj9XLozQvchPT5KdFAE6UvukVTfd65spa7Si5H3yiqSPZ
        UeEdxadV6HH4Do8rM
X-Received: by 2002:a05:600c:5011:b0:3cf:91e9:f771 with SMTP id n17-20020a05600c501100b003cf91e9f771mr14680177wmr.36.1670913511086;
        Mon, 12 Dec 2022 22:38:31 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7a0Jg5I3qlu4+RONkY5PwQtc+kv3pnp/OWxrJYOaFho0Wyum/OG/OEnozMktADLH8herMaKg==
X-Received: by 2002:a05:600c:5011:b0:3cf:91e9:f771 with SMTP id n17-20020a05600c501100b003cf91e9f771mr14680167wmr.36.1670913510863;
        Mon, 12 Dec 2022 22:38:30 -0800 (PST)
Received: from redhat.com ([2.52.138.183])
        by smtp.gmail.com with ESMTPSA id g23-20020a05600c4c9700b003cf4ec90938sm11063543wmp.21.2022.12.12.22.38.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 22:38:30 -0800 (PST)
Date:   Tue, 13 Dec 2022 01:38:27 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Subject: Re: [PATCH net] virtio-net: correctly enable callback during
 start_xmit
Message-ID: <20221213013231-mutt-send-email-mst@kernel.org>
References: <20221212091029.54390-1-jasowang@redhat.com>
 <20221212042144-mutt-send-email-mst@kernel.org>
 <1670902391.9610498-1-xuanzhuo@linux.alibaba.com>
 <CACGkMEu=1CcoNvvV9M+QrG5sLUBoPYkZ3DvUe+pLc1fSvgLuHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEu=1CcoNvvV9M+QrG5sLUBoPYkZ3DvUe+pLc1fSvgLuHA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 13, 2022 at 11:43:36AM +0800, Jason Wang wrote:
> On Tue, Dec 13, 2022 at 11:38 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
> >
> > On Mon, 12 Dec 2022 04:25:22 -0500, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > On Mon, Dec 12, 2022 at 05:10:29PM +0800, Jason Wang wrote:
> > > > Commit a7766ef18b33("virtio_net: disable cb aggressively") enables
> > > > virtqueue callback via the following statement:
> > > >
> > > >         do {
> > > >            ......
> > > >     } while (use_napi && kick &&
> > > >                unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
> > > >
> > > > This will cause a missing call to virtqueue_enable_cb_delayed() when
> > > > kick is false. Fixing this by removing the checking of the kick from
> > > > the condition to make sure callback is enabled correctly.
> > > >
> > > > Fixes: a7766ef18b33 ("virtio_net: disable cb aggressively")
> > > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > > ---
> > > > The patch is needed for -stable.
> > >
> > > stable rules don't allow for theoretical fixes. Was a problem observed?
> 
> Yes, running a pktgen sample script can lead to a tx timeout.

Since April 2021 and we only noticed now? Are you sure it's the
right Fixes tag?

> > >
> > > > ---
> > > >  drivers/net/virtio_net.c | 4 ++--
> > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > index 86e52454b5b5..44d7daf0267b 100644
> > > > --- a/drivers/net/virtio_net.c
> > > > +++ b/drivers/net/virtio_net.c
> > > > @@ -1834,8 +1834,8 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
> > > >
> > > >             free_old_xmit_skbs(sq, false);
> > > >
> > > > -   } while (use_napi && kick &&
> > > > -          unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
> > > > +   } while (use_napi &&
> > > > +            unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
> > > >
> > >
> > > A bit more explanation pls.  kick simply means !netdev_xmit_more -
> > > if it's false we know there will be another packet, then transmissing
> > > that packet will invoke virtqueue_enable_cb_delayed. No?
> >
> > It's just that there may be a next packet, but in fact there may not be.
> > For example, the vq is full, and the driver stops the queue.
> 
> Exactly, when the queue is about to be full we disable tx and wait for
> the next tx interrupt to re-enable tx.
> 
> Thanks

OK, it's a good idea to document that.
And we should enable callbacks at that point, not here on data path.


> >
> > Thanks.
> >
> > >
> > >
> > >
> > >
> > >
> > > >     /* timestamp packet in software */
> > > >     skb_tx_timestamp(skb);
> > > > --
> > > > 2.25.1
> > >
> > > _______________________________________________
> > > Virtualization mailing list
> > > Virtualization@lists.linux-foundation.org
> > > https://lists.linuxfoundation.org/mailman/listinfo/virtualization
> >

