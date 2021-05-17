Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9ACC386DAD
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 01:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241157AbhEQXdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 19:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231543AbhEQXdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 19:33:52 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3730C061573;
        Mon, 17 May 2021 16:32:34 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id n40so7576087ioz.4;
        Mon, 17 May 2021 16:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=h13rmsMrSOuIdoaAkAi4bIZZYwWsQNek+pOTNI52ZT4=;
        b=O51onOmUelD618wNr4Hbm5Ht3MdcvVMDQHpfv2HY5g+UBbJwnXTRoktDI/UNa0x5hS
         DxiqD0OSyj0L0wXWoTV1A+zsD/xVKzKGp2nuHEQRza2NCdIMiuwzGaJROhAin2DIOMfT
         CrOKJiVgVYagXyMXLVDkYQLq0Gn1g15I+/rTxCI7bmO9m0muo27objmJLLTYjb9xzwEB
         ZtGyzZ7tmy2pndzhvd6EEYIQPKsVuQjf+d7tax17kj9mavQzw8l6WbrXxDFndA0oZQsf
         TKO51cdRVb8WAnWB5d9VC0KCBRG6BBQsiH0GjT3GFDCpqhn0hYauQAYhBUhxlrgIvCvm
         eXQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=h13rmsMrSOuIdoaAkAi4bIZZYwWsQNek+pOTNI52ZT4=;
        b=BzzVhGZ5pBPxLB8XxhlOP1cir7Y8zpDnmXzT9MIhHuy/CLlWm5LkFQLh++r/0Ae1T/
         aiB6M0pxI7hxFz2QcJYiq5Gk5mD2E4lio0KEHYXtGWFQK7orGT2k4kNvMQIIyiJNktkF
         T68nDbLEBjK21g2LtENslhv3vpd3bJL5D1oIF8OV9d5CoCj+jJh4btpJH8s80BJK/6z+
         uQ+ezZdszpCEbaNZ/rlpL4IpuHy0WQCH5E+6UUkS4Ev64nB8R8DudoHdQaHRFwY+ZOuf
         CFQkXXtfKk9ExZ7UVbdqpGeoMmq0PYPxSZx/x2/kAH3W7L7PFrYoyLrbmTAHjIN9X/5D
         KA6w==
X-Gm-Message-State: AOAM532PiKgD0JmOMg46UUgb36jXPXI+5e3qMzqGEL5Qb7qrVmMN4UpD
        nQ5EyUMbn5MCK2ukuP0kCZppboxnWiJnErQ4UuOIMKsX3rE=
X-Google-Smtp-Source: ABdhPJzwrRwZya8a/DpYrdPlK8BF61rtSTGtcCm2Cp4zYKhO7tYkJPYkIY55BU7Bfwli/u2ijSB0A5Oa/v7PoMgxKfE=
X-Received: by 2002:a6b:6905:: with SMTP id e5mr2019219ioc.100.1621294354111;
 Mon, 17 May 2021 16:32:34 -0700 (PDT)
MIME-Version: 1.0
References: <56270996-33a6-d71b-d935-452dad121df7@linux.alibaba.com>
 <CAA93jw6LUAnWZj0b5FvefpDKUyd6cajCNLoJ6OKrwbu-V_ffrA@mail.gmail.com>
 <CA+FuTSf0Af2RXEG=rCthNNEb5mwKTG37gpEBBZU16qKkvmF=qw@mail.gmail.com>
 <CAA93jw7Vr_pFMsPCrPadqaLGu0BdC-wtCmW2iyHFkHERkaiyWQ@mail.gmail.com> <20210517160036.4093d3f2@hermes.local>
In-Reply-To: <20210517160036.4093d3f2@hermes.local>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Mon, 17 May 2021 16:32:21 -0700
Message-ID: <CAA93jw4bSx=0gnJtNJLeS00ELMgo2Na+t7hYTNL3G3juDFvcNg@mail.gmail.com>
Subject: Re: [Bloat] virtio_net: BQL?
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Xianting Tian <xianting.tian@linux.alibaba.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        bloat <bloat@lists.bufferbloat.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 17, 2021 at 4:00 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Mon, 17 May 2021 14:48:46 -0700
> Dave Taht <dave.taht@gmail.com> wrote:
>
> > On Mon, May 17, 2021 at 1:23 PM Willem de Bruijn
> > <willemdebruijn.kernel@gmail.com> wrote:
> > >
> > > On Mon, May 17, 2021 at 2:44 PM Dave Taht <dave.taht@gmail.com> wrote=
:
> > > >
> > > > Not really related to this patch, but is there some reason why virt=
io
> > > > has no support for BQL?
> > >
> > > There have been a few attempts to add it over the years.
> > >
> > > Most recently, https://lore.kernel.org/lkml/20181205225323.12555-2-ms=
t@redhat.com/
> > >
> > > That thread has a long discussion. I think the key open issue remains
> > >
> > > "The tricky part is the mode switching between napi and no napi."
> >
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
> > http://fremont.starlink.taht.net/~d/virtio_nobql/rrul_-_evenroute_v3_se=
rver_fq_codel.png
> >
> > See the swings in latency there? that's symptomatic of tx/rx rings
> > filling and emptying.
> >
> > it wasn't until I switched my measurement server temporarily over to
> > sch_fq that I got a rrul result that was close to the results we used
> > to get from the virtualized e1000e drivers we were using in 2014.
> >
> > http://fremont.starlink.taht.net/~d/virtio_nobql/rrul_-_evenroute_v3_se=
rver_fq.png
> >
> > While I have long supported the use of sch_fq for tcp-heavy workloads,
> > it still behaves better with bql in place, and fq_codel is better for
> > generic workloads... but needs bql based backpressure to kick in.
> >
> > [1] I really hope I'm overreacting but, um, er, could someone(s) spin
> > up a new patch that does bql in some way even half right for this
> > driver and help test it? I haven't built a kernel in a while.
> >
>
> The Azure network driver (netvsc) also does not have BQL. Several years a=
go
> I tried adding it but it benchmarked worse and there is the added complex=
ity
> of handling the accelerated networking VF path.

I certainly agree it adds complexity, but the question is what sort of
network behavior resulted without backpressure inside the
vm?

What sorts of benchmarks did you do?

I will get setup to do some testing of this that is less adhoc.


--=20
Latest Podcast:
https://www.linkedin.com/feed/update/urn:li:activity:6791014284936785920/

Dave T=C3=A4ht CTO, TekLibre, LLC
