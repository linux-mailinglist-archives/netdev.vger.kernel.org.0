Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89AB234FBD9
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 10:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234346AbhCaIrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 04:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbhCaIqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 04:46:53 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69534C061574
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 01:46:53 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id z1so20368599ybf.6
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 01:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lAX0mvE4XJ98PCjKRFGpZi58UBQ0jK3jwpV5j3+uyAw=;
        b=r8/5uvPAVqNCKuJImmm4N2gaESZPlFOdQzZ0/OxkTcF5s/CT5FyDAmEWO4mXDa/LlH
         ty0HQSWbOL+FfTsHHCXz2CcEdvYqegk2D2oWYEhj4GlIr5oaAJ5G8Wn/qZmpL/GRqCOR
         Xk2SfgMQgsX8GMwxH+UXsoL5d3dDMPANfRtKsZ3rX3ZkDm9FPNHGHpF8nldE9Pxs7ONn
         BPJfhfinmhmBmR6CRoIrULNFE4szmrDvB64dKMJzaNfnZ553v+c54ugNEAcg/pCcueAs
         NvRRV10zE0HaWxmq0xINA8QcG7/FdfEh5DLePI5Pj1KdIO8eyJStE7yYOc9EJ1PAxdpA
         jUFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lAX0mvE4XJ98PCjKRFGpZi58UBQ0jK3jwpV5j3+uyAw=;
        b=ZmZ3hFjgELcKRhQNHIhFtF4lutCRPlCMFJEHnKirZmAmccrhvj0BQknwdjO9/E2RCU
         r/HpwPtYUJV2ja38Zo1pkPjR+rEEf6Ng90ofHGbw/gba+eSqZPArjh3E0FvnpCV1T22K
         jT6KVkm9lU8mc6MwMRQ4LpHpn4c8Di6l1sa/fXCznD8aTOKLOeDqZ22NcGUNFgSU7sf2
         Iu0qrDP8h3tIP+jyrUcSy0joypeJKlpTve5fpKPXZwdkpZmiLGX+BOPSoTrjHw/aOn+N
         +rpzUuml+j6CwjNktb6QKXVq/ZNEQeikaD8G+7GtWqyMJoqVqmD/AN4yMQknfrZ8Am9l
         /J4w==
X-Gm-Message-State: AOAM533HyNRygklxa19/MKuydIJNa2TTFpUch+2oJUwMK+1bReX2mTEu
        tGbMvokQGwHtTv9j9mlM9c8FTtvMHOAtYPbmqmTTGQ==
X-Google-Smtp-Source: ABdhPJwKBONlP1LCJxdL4qOkRSYkpItpCN5XaQuHOQdPfTlPsGqwJJ/LUX10JyKqHRf5R4FSN3la4EV9KfnEKAadZ80=
X-Received: by 2002:a25:7e01:: with SMTP id z1mr3297605ybc.253.1617180412366;
 Wed, 31 Mar 2021 01:46:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210113161819.1155526-1-eric.dumazet@gmail.com>
 <1617007696.5731978-1-xuanzhuo@linux.alibaba.com> <CANn89iLXfu7mdk+cxqVYxtJhfBQtpho6i2kyOEUbEGPXBQj+jg@mail.gmail.com>
 <20210331040405-mutt-send-email-mst@kernel.org> <CANn89iJN3SQDctZxaPdZMSPGRbjLrsYGM7=Y2POv-3Ysw-EZ_w@mail.gmail.com>
In-Reply-To: <CANn89iJN3SQDctZxaPdZMSPGRbjLrsYGM7=Y2POv-3Ysw-EZ_w@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 31 Mar 2021 10:46:41 +0200
Message-ID: <CANn89i+E=Bu4zPwtQGNZzoPdTzsb+9rWx0d73ZHm_nWQfHRHMA@mail.gmail.com>
Subject: Re: [PATCH net] net: avoid 32 x truesize under-estimation for tiny skbs
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Thelen <gthelen@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, su-lifan@linux.alibaba.com,
        "dust.li" <dust.li@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 10:36 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Wed, Mar 31, 2021 at 10:11 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Mon, Mar 29, 2021 at 11:06:09AM +0200, Eric Dumazet wrote:
> > > On Mon, Mar 29, 2021 at 10:52 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
> > > >
> > > > On Wed, 13 Jan 2021 08:18:19 -0800, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > > > > From: Eric Dumazet <edumazet@google.com>
> > > > >
> > > > > Both virtio net and napi_get_frags() allocate skbs
> > > > > with a very small skb->head
> > > > >
> > > > > While using page fragments instead of a kmalloc backed skb->head might give
> > > > > a small performance improvement in some cases, there is a huge risk of
> > > > > under estimating memory usage.
> > > > >
> > > > > For both GOOD_COPY_LEN and GRO_MAX_HEAD, we can fit at least 32 allocations
> > > > > per page (order-3 page in x86), or even 64 on PowerPC
> > > > >
> > > > > We have been tracking OOM issues on GKE hosts hitting tcp_mem limits
> > > > > but consuming far more memory for TCP buffers than instructed in tcp_mem[2]
> > > > >
> > > > > Even if we force napi_alloc_skb() to only use order-0 pages, the issue
> > > > > would still be there on arches with PAGE_SIZE >= 32768
> > > > >
> > > > > This patch makes sure that small skb head are kmalloc backed, so that
> > > > > other objects in the slab page can be reused instead of being held as long
> > > > > as skbs are sitting in socket queues.
> > > > >
> > > > > Note that we might in the future use the sk_buff napi cache,
> > > > > instead of going through a more expensive __alloc_skb()
> > > > >
> > > > > Another idea would be to use separate page sizes depending
> > > > > on the allocated length (to never have more than 4 frags per page)
> > > > >
> > > > > I would like to thank Greg Thelen for his precious help on this matter,
> > > > > analysing crash dumps is always a time consuming task.
> > > >
> > > >
> > > > This patch causes a performance degradation of about 10% in the scenario of
> > > > virtio-net + GRO.
> > > >
> > > > For GRO, there is no way to merge skbs based on frags with this patch, only
> > > > frag_list can be used to link skbs. The problem that this cause are that compared
> > > > to the GRO package merged into the frags way, the current skb needs to call
> > > > kfree_skb_list to release each skb, resulting in performance degradation.
> > > >
> > > > virtio-net will store some data onto the linear space after receiving it. In
> > > > addition to the header, there are also some payloads, so "headlen <= offset"
> > > > fails. And skb->head_frag is failing when use kmalloc() for skb->head allocation.
> > > >
> > >
> > > Thanks for the report.
> > >
> > > There is no way we can make things both fast for existing strategies
> > > used by _insert_your_driver
> > > and malicious usages of data that can sit for seconds/minutes in socket queues.
> > >
> > > I think that if you want to gain this 10% back, you have to change
> > > virtio_net to meet optimal behavior.
> > >
> > > Normal drivers make sure to not pull payload in skb->head, only headers.
> >
> > Hmm we do have hdr_len field, but seem to ignore it on RX.
> > Jason do you see any issues with using it for the head len?
> >
>
> I was looking at this code (page_to_skb())  a few minutes ago ;)
>
> pulling payload would make sense only if can pull of of it (to free the page)
> (This is what some drivers implement and call copybreak)
>
> Even if we do not have an accurate knowledge of header sizes,
> it would be better to pull only the Ethernet header and let GRO do the
> rest during its dissection.
>
> Once fixed, virtio_net will reduce by 2x number of frags per skb,
> compared to the situation before "net: avoid 32 x truesize
> under-estimation for tiny skbs"

Ie I suspect the simple way to fix this would be :

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index bb4ea9dbc16bcb19c5969fc8247478aa66c63fce..a5500bf6ac01051be949edf9fead934a90335f4f
100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -409,9 +409,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
        offset += hdr_padded_len;
        p += hdr_padded_len;

-       copy = len;
-       if (copy > skb_tailroom(skb))
-               copy = skb_tailroom(skb);
+       copy = min_t(int, len, ETH_HLEN);
        skb_put_data(skb, p, copy);

        if (metasize) {
