Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6757945408D
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 07:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233152AbhKQGEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 01:04:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbhKQGEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 01:04:43 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 474CBC061746
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 22:01:45 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id m6so4076489oim.2
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 22:01:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VlZH+SjArM/+ypAkd0GkqnF+/8X0/LANVS817tn/Z6M=;
        b=uh8qtTLsquh/EZx+E9fM9iwATsMXMExVvsfTsH2Dx4lGVp8ngZnDfySMn+twM2jJyZ
         I/M5mWXJDABMPKRcDGW69gLwYu4xB6BTxQayphm/gDensbt5NojFMj9o6A9mnvkL1M11
         hHOPCtglWmO/FgubeQ/StiOjmeZ/xeXsHBbyXCBEcyBlqIyYjc3mqTaMLjK+svLedqG6
         r0PMecG3kbB4CQMkJSoP4CIQtNyKHdU/Sn8GfvPsP0sDnY05RejHXZbg4i4Xin67Dzlc
         DhRvSYl1Ti/HtCpwOT3vAtg4SAKzYqOEEbfWk7fHDHwPHkdE7Dn18d5xMdzfTDIEHNCB
         h2yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VlZH+SjArM/+ypAkd0GkqnF+/8X0/LANVS817tn/Z6M=;
        b=L/9aiaZXBv+FjKEUB6MF7ETQE/3k6Qs06jQH4fAE14GwFTdC14GQ2nYMLQLIpHgbrY
         GH9wShVojtI2Jdty2DEO4vlwfnSZmPoHY6C8tdps2PzoKd0Mj/p5v8AvpbBsGgdEiv1+
         EHuTfNH1XLZiFsrb1p8AocO4t8GoIQNNjyvB7DInoayy+pXxyTVJau76GdHUzwzlF3bJ
         6rMjhF6BUZHwlP1zYJvwf21KmS9JhBr2Ig6GfiMseKyambq3hqoKYMl5CLGFNUdDNX1G
         lonwz1OvOvbnfK84mm62dHFjxFjAd9HWxrkx3qGautZ0sqTuzM25BGl+l7nyfFzy8o0W
         CO/Q==
X-Gm-Message-State: AOAM533zeAgyy5np+IsDJqJSWEUypzDAlgaAMQQSYBr3dMwRDY5RahNr
        sL6cp9aAcVb+ZWpf20Cos2y04agPcr2t9X+EH+LK+Q==
X-Google-Smtp-Source: ABdhPJzRwMxi5Vhil0B4DEUfMMuTRi3VY7MLIEvgxCf9w8HuketPjUr+oWOSEK3nH61Fv5xXVvtfGeDjDQDbTozG4bM=
X-Received: by 2002:a05:6808:171c:: with SMTP id bc28mr58754765oib.18.1637128904727;
 Tue, 16 Nov 2021 22:01:44 -0800 (PST)
MIME-Version: 1.0
References: <20211031045959.143001-1-andrew@daynix.com> <20211031045959.143001-2-andrew@daynix.com>
 <20211101043723-mutt-send-email-mst@kernel.org>
In-Reply-To: <20211101043723-mutt-send-email-mst@kernel.org>
From:   Andrew Melnichenko <andrew@daynix.com>
Date:   Wed, 17 Nov 2021 08:00:00 +0200
Message-ID: <CABcq3pH8PCJwDQyusjQbW4Ds08YMjn8NSRM+Cf6NjA0hZHHMtw@mail.gmail.com>
Subject: Re: [RFC PATCH 1/4] drivers/net/virtio_net: Fixed vheader to use v1.
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yuri Benditovich <yuri.benditovich@daynix.com>,
        Yan Vugenfirer <yan@daynix.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 1, 2021 at 10:40 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Sun, Oct 31, 2021 at 06:59:56AM +0200, Andrew Melnychenko wrote:
> > The header v1 provides additional info about RSS.
> > Added changes to computing proper header length.
> > In the next patches, the header may contain RSS hash info
> > for the hash population.
> >
> > Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
> > ---
> >  drivers/net/virtio_net.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 4ad25a8b0870..b72b21ac8ebd 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -240,13 +240,13 @@ struct virtnet_info {
> >  };
> >
> >  struct padded_vnet_hdr {
> > -     struct virtio_net_hdr_mrg_rxbuf hdr;
> > +     struct virtio_net_hdr_v1_hash hdr;
> >       /*
> >        * hdr is in a separate sg buffer, and data sg buffer shares same page
> >        * with this header sg. This padding makes next sg 16 byte aligned
> >        * after the header.
> >        */
> > -     char padding[4];
> > +     char padding[12];
> >  };
> >
> >  static bool is_xdp_frame(void *ptr)
>
>
> This is not helpful as a separate patch, just reserving extra space.
> better squash with the patches making use of the change.

Ok.


>
> > @@ -1636,7 +1636,7 @@ static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
> >       const unsigned char *dest = ((struct ethhdr *)skb->data)->h_dest;
> >       struct virtnet_info *vi = sq->vq->vdev->priv;
> >       int num_sg;
> > -     unsigned hdr_len = vi->hdr_len;
> > +     unsigned int hdr_len = vi->hdr_len;
> >       bool can_push;
>
>
> if we want this, pls make it a separate patch.

Ok. I've added that change after checkpatch warnings. Technically,
checkpatch should not fail on the patch without that line.

>
>
> >
> >       pr_debug("%s: xmit %p %pM\n", vi->dev->name, skb, dest);
> > --
> > 2.33.1
>
