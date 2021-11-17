Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6909C454088
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 07:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233345AbhKQGDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 01:03:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232511AbhKQGDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 01:03:01 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD0AC061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 22:00:03 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id bf8so4008219oib.6
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 22:00:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kSGc4ZU3kMNV4pDWr3dTCqenmyUswpL++6XUnwpYb58=;
        b=7c7d9HtTbjMh1xMFTx5QGxIrdsXn1JI9YRElbu+ZqHFJsqK2AF17sH/DWoIcAvgO1L
         FUKjZ6HlMNIsRREeVQH86AcW1VL8HH3mT/9F8Fw09xBw1/cNGqBKlV01Zk9PYpIITM/n
         1PA5O0SPFyvEnx44UPrNPp2GJyX9kB7wvCzdxZpz/V8DwrCAhaa9ixkAWLRYejYpPfoO
         hxxvH37k+OMXfLmA5IKJV5bqUhY2ZXlEQsj0KUYy2nxapOOtl3keoGl6u+6R+amyebt4
         UAdiaraI25ZMwqbwnNvzH+IG/64wWtPcPfRSUuMuePLek4E3SJ+i2cmlWrgQP6M5Hxd1
         bjQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kSGc4ZU3kMNV4pDWr3dTCqenmyUswpL++6XUnwpYb58=;
        b=XYHYR5Cj5jY5fzKQa/DUBsc6mOP8VnP8r3JgnV6kIlFDDINI06EVz/b22NSIYP6ZWW
         iUUetJR3G34dtvigDM0CPQByAIc4RomNCWvnLmub59xrrLl+WS4jraor1htygOYWA7nv
         MiR9I5F9NFbrbIYGRUXLw29mdIucB/NEoQC56hD+TPDN9T6XrVEkyxfhWu8SSY4SHg27
         xjomNBd5TEN5EQqpVFvDZDaZmETPOfsu6xoRwjSeho6+tL/X6DilyTNJzfIr/M0D4pRr
         /V5Oo3pviwPWqKO6D4W1/rZ7oEXuq5KPj9YkYIKfxiaNdTZ2ZelWVNtxOPL4Lelczu2k
         QU2g==
X-Gm-Message-State: AOAM530kFRThac+FDo1rVTUsopSRVSkHomlvJ45/ZVgLOaQU83MQvFPu
        ulYjT2rI7hCJjalGxAVr7IG3LN4Zfj4aFPUnweXhuA==
X-Google-Smtp-Source: ABdhPJyY/WqLFoKyV7MDHc0Omfxi30xLTaWZemyxDXwUFuCZxXL/MS1QKFZhNHj9aUUnq4wuTADld82ehMllqGmhACk=
X-Received: by 2002:a54:4f8f:: with SMTP id g15mr11417825oiy.169.1637128802620;
 Tue, 16 Nov 2021 22:00:02 -0800 (PST)
MIME-Version: 1.0
References: <20211031045959.143001-1-andrew@daynix.com> <20211031045959.143001-3-andrew@daynix.com>
 <20211101044051-mutt-send-email-mst@kernel.org>
In-Reply-To: <20211101044051-mutt-send-email-mst@kernel.org>
From:   Andrew Melnichenko <andrew@daynix.com>
Date:   Wed, 17 Nov 2021 08:00:00 +0200
Message-ID: <CABcq3pGuM6tD3P+zfBE6SZ3y7uxV5wYUZZ6GVqRsydtHkeTM2Q@mail.gmail.com>
Subject: Re: [RFC PATCH 2/4] drivers/net/virtio_net: Changed mergeable buffer
 length calculation.
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

On Mon, Nov 1, 2021 at 10:44 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Sun, Oct 31, 2021 at 06:59:57AM +0200, Andrew Melnychenko wrote:
> > Now minimal virtual header length is may include the entire v1 header
> > if the hash report were populated.
> >
> > Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
>
> subject isn't really descriptive. changed it how?
>
> And I couldn't really decypher what this log entry means either.
>

I'll change it in the next patch.
So, I've tried to ensure that the v1 header with the hash report will
be available if required in new patches.

> > ---
> >  drivers/net/virtio_net.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index b72b21ac8ebd..abca2e93355d 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -393,7 +393,9 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
> >       hdr_p = p;
> >
> >       hdr_len = vi->hdr_len;
> > -     if (vi->mergeable_rx_bufs)
> > +     if (vi->has_rss_hash_report)
> > +             hdr_padded_len = sizeof(struct virtio_net_hdr_v1_hash);
> > +     else if (vi->mergeable_rx_bufs)
> >               hdr_padded_len = sizeof(*hdr);
> >       else
> >               hdr_padded_len = sizeof(struct padded_vnet_hdr);
> > @@ -1252,7 +1254,7 @@ static unsigned int get_mergeable_buf_len(struct receive_queue *rq,
> >                                         struct ewma_pkt_len *avg_pkt_len,
> >                                         unsigned int room)
> >  {
> > -     const size_t hdr_len = sizeof(struct virtio_net_hdr_mrg_rxbuf);
> > +     const size_t hdr_len = ((struct virtnet_info *)(rq->vq->vdev->priv))->hdr_len;
> >       unsigned int len;
> >
> >       if (room)
>
> Is this pointer chasing the best we can do?

I'll change that.

>
> > @@ -2817,7 +2819,7 @@ static void virtnet_del_vqs(struct virtnet_info *vi)
> >   */
> >  static unsigned int mergeable_min_buf_len(struct virtnet_info *vi, struct virtqueue *vq)
> >  {
> > -     const unsigned int hdr_len = sizeof(struct virtio_net_hdr_mrg_rxbuf);
> > +     const unsigned int hdr_len = vi->hdr_len;
> >       unsigned int rq_size = virtqueue_get_vring_size(vq);
> >       unsigned int packet_len = vi->big_packets ? IP_MAX_MTU : vi->dev->max_mtu;
> >       unsigned int buf_len = hdr_len + ETH_HLEN + VLAN_HLEN + packet_len;
> > --
> > 2.33.1
>
