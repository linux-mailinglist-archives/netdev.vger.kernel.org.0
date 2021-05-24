Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 950EC38E2F9
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 11:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232401AbhEXJLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 05:11:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29025 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232318AbhEXJLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 05:11:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621847407;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L3wSqyBZrZuWAaUg/+zzbLh1KHxQeq+UhWJvXbU1jvM=;
        b=AOc6yA9d8CWnbpaEMDEQ65RUpvAvvixHXf5nSo1ELU6DGwCZ4qz7YFZwGE1U/PVgLLamC7
        UpP7VRuiL3XrzyipRyRCnmMY8fS33ga/X4oHi0LdfHbeOQNmreAkoelfaiqMpruGGkAwN2
        faNkxaqP0BrmUWpTs5Hdrjp5kz24+8o=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-KFXFuErONWe7PWvbwCdRog-1; Mon, 24 May 2021 05:10:05 -0400
X-MC-Unique: KFXFuErONWe7PWvbwCdRog-1
Received: by mail-wr1-f70.google.com with SMTP id g3-20020adfd1e30000b02901122a4b850aso4782798wrd.20
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 02:10:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=L3wSqyBZrZuWAaUg/+zzbLh1KHxQeq+UhWJvXbU1jvM=;
        b=YXxIWJF4NIfgSz3aSQqAqMTzHVXAokTkaNKcpw7btsF8br75+IrrUzXGycxBC8TFHl
         NAHaTR3gToSXM38dhgJU+39tVlJa2kpI7YqKKXxMooNc2m8WNMr1mOvAcRFKr3zEo/DP
         To7CyYGnHQoo/HdcI10emLmmoy44xLcLTY04otyi1cwmVA5QQ1MSe39QWI5tKto/TsWA
         9XBv8mXJg1HGgb2o3rhLet/Rq6oEbk9ZA8OVW3gK9d1BA2YWU2RgRLtBg1Df07JV0DKE
         hrd03afTiytRxZfF/r/JKgpIxJ3xnlXN9HphcNBacFUoiY8vvncw4DcMzzCzOlb7k0qO
         WJZg==
X-Gm-Message-State: AOAM5331W5r20GyufqyrWdjIusbWsvzgdBuYqewjQmF5mhXQCxtb8p4L
        e6ZuUDroOGa0SYS1hk3IJfSONf46OzrvN4WEVyKxPfkLRBZrYjiEkIbhb6RAkaVovnM4f1C63AB
        z2Acoulg8wIdEkbZw
X-Received: by 2002:adf:f04f:: with SMTP id t15mr20315409wro.377.1621847403769;
        Mon, 24 May 2021 02:10:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJytbecMYMOBl3tQdN/Kb27iSiGCSiu57Cvca61WWGiciWSVF/D85dYw2RXxPRqM5ZPPEiFVYQ==
X-Received: by 2002:adf:f04f:: with SMTP id t15mr20315393wro.377.1621847403598;
        Mon, 24 May 2021 02:10:03 -0700 (PDT)
Received: from redhat.com ([2a10:8006:fcda:0:90d:c7e7:9e26:b297])
        by smtp.gmail.com with ESMTPSA id w25sm7397924wmk.25.2021.05.24.02.10.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 02:10:02 -0700 (PDT)
Date:   Mon, 24 May 2021 05:10:00 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Dave Taht <dave.taht@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Xianting Tian <xianting.tian@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        bloat <bloat@lists.bufferbloat.net>
Subject: Re: virtio_net: BQL?
Message-ID: <20210524050840-mutt-send-email-mst@kernel.org>
References: <56270996-33a6-d71b-d935-452dad121df7@linux.alibaba.com>
 <CAA93jw6LUAnWZj0b5FvefpDKUyd6cajCNLoJ6OKrwbu-V_ffrA@mail.gmail.com>
 <CA+FuTSf0Af2RXEG=rCthNNEb5mwKTG37gpEBBZU16qKkvmF=qw@mail.gmail.com>
 <CAA93jw7Vr_pFMsPCrPadqaLGu0BdC-wtCmW2iyHFkHERkaiyWQ@mail.gmail.com>
 <a3a9b036-14d1-2f4f-52e6-f0aa1b187003@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a3a9b036-14d1-2f4f-52e6-f0aa1b187003@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 24, 2021 at 10:53:08AM +0800, Jason Wang wrote:
> 
> 在 2021/5/18 上午5:48, Dave Taht 写道:
> > On Mon, May 17, 2021 at 1:23 PM Willem de Bruijn
> > <willemdebruijn.kernel@gmail.com> wrote:
> > > On Mon, May 17, 2021 at 2:44 PM Dave Taht <dave.taht@gmail.com> wrote:
> > > > Not really related to this patch, but is there some reason why virtio
> > > > has no support for BQL?
> > > There have been a few attempts to add it over the years.
> > > 
> > > Most recently, https://lore.kernel.org/lkml/20181205225323.12555-2-mst@redhat.com/
> > > 
> > > That thread has a long discussion. I think the key open issue remains
> > > 
> > > "The tricky part is the mode switching between napi and no napi."
> > Oy, vey.
> > 
> > I didn't pay any attention to that discussion, sadly enough.
> > 
> > It's been about that long (2018) since I paid any attention to
> > bufferbloat in the cloud and my cloudy provider (linode) switched to
> > using virtio when I wasn't looking. For over a year now, I'd been
> > getting reports saying that comcast's pie rollout wasn't working as
> > well as expected, that evenroute's implementation of sch_cake and sqm
> > on inbound wasn't working right, nor pf_sense's and numerous other
> > issues at Internet scale.
> > 
> > Last week I ran a string of benchmarks against starlink's new services
> > and was really aghast at what I found there, too. but the problem
> > seemed deeper than in just the dishy...
> > 
> > Without BQL, there's no backpressure for fq_codel to do its thing.
> > None. My measurement servers aren't FQ-codeling
> > no matter how much load I put on them. Since that qdisc is the default
> > now in most linux distributions, I imagine that the bulk of the cloud
> > is now behaving as erratically as linux was in 2011 with enormous
> > swings in throughput and latency from GSO/TSO hitting overlarge rx/tx
> > rings, [1], breaking various rate estimators in codel, pie and the tcp
> > stack itself.
> > 
> > See:
> > 
> > http://fremont.starlink.taht.net/~d/virtio_nobql/rrul_-_evenroute_v3_server_fq_codel.png
> > 
> > See the swings in latency there? that's symptomatic of tx/rx rings
> > filling and emptying.
> > 
> > it wasn't until I switched my measurement server temporarily over to
> > sch_fq that I got a rrul result that was close to the results we used
> > to get from the virtualized e1000e drivers we were using in 2014.
> > 
> > http://fremont.starlink.taht.net/~d/virtio_nobql/rrul_-_evenroute_v3_server_fq.png
> > 
> > While I have long supported the use of sch_fq for tcp-heavy workloads,
> > it still behaves better with bql in place, and fq_codel is better for
> > generic workloads... but needs bql based backpressure to kick in.
> > 
> > [1] I really hope I'm overreacting but, um, er, could someone(s) spin
> > up a new patch that does bql in some way even half right for this
> > driver and help test it? I haven't built a kernel in a while.
> 
> 
> I think it's time to obsolete skb_orphan() for virtio-net to get rid of a
> brunch of tricky codes in the current virtio-net driver.
> 
> Then we can do BQL on top.
> 
> I will prepare some patches to do this (probably with Michael's BQL patch).
> 
> Thanks

First step would be to fix up and test the BQL part.
IIRC it didn't seem to help performance in our benchmarking,
and Eric seems to say that's expected ...


> 
> > 
> > 
> > > > On Mon, May 17, 2021 at 11:41 AM Xianting Tian
> > > > <xianting.tian@linux.alibaba.com> wrote:
> > > > > BUG_ON() uses unlikely in if(), which can be optimized at compile time.
> > > > > 
> > > > > Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
> > > > > ---
> > > > >    drivers/net/virtio_net.c | 5 ++---
> > > > >    1 file changed, 2 insertions(+), 3 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > > index c921ebf3ae82..212d52204884 100644
> > > > > --- a/drivers/net/virtio_net.c
> > > > > +++ b/drivers/net/virtio_net.c
> > > > > @@ -1646,10 +1646,9 @@ static int xmit_skb(struct send_queue *sq, struct
> > > > > sk_buff *skb)
> > > > >          else
> > > > >                  hdr = skb_vnet_hdr(skb);
> > > > > 
> > > > > -       if (virtio_net_hdr_from_skb(skb, &hdr->hdr,
> > > > > +       BUG_ON(virtio_net_hdr_from_skb(skb, &hdr->hdr,
> > > > >                                      virtio_is_little_endian(vi->vdev), false,
> > > > > -                                   0))
> > > > > -               BUG();
> > > > > +                                   0));
> > > > > 
> > > > >          if (vi->mergeable_rx_bufs)
> > > > >                  hdr->num_buffers = 0;
> > > > > --
> > > > > 2.17.1
> > > > > 
> > > > 
> > > > --
> > > > Latest Podcast:
> > > > https://www.linkedin.com/feed/update/urn:li:activity:6791014284936785920/
> > > > 
> > > > Dave Täht CTO, TekLibre, LLC
> > 
> > 
> > --
> > Latest Podcast:
> > https://www.linkedin.com/feed/update/urn:li:activity:6791014284936785920/
> > 
> > Dave Täht CTO, TekLibre, LLC
> > 

