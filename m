Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65160387007
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 04:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346262AbhERCtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 22:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241717AbhERCtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 22:49:32 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA2FC061760
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 19:48:14 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id m1so6134614ilg.10
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 19:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BRkks4605+UoXCWgr/rS+r0/gbRif4B+Nb12472cPkM=;
        b=EGRnf/dWcD1J6D90hSQhTZm534z305G6fSOkRQZ8l26m0liP6MYzsfNDeo14gZTSek
         zJHQez0UC3O9rhfxyECwXkN8s8uWmvuJnXSNyNpewsvHnz9dC5Hrg7gFg/rk2Ga9rYOi
         bXK0By4kDgHUgde+t0LdIIsQMIt04SxCfklwcIN6h+8AcbT8MF6VeaSJXyVIQZqC72jv
         Vz56n13fYWNLukTwkEYEpo87b2J983tPXuzxMpseNw7EtWIoDEZGlHdC8mlCdNEnT8Aw
         FjqkVjcL+WmayRZUDKop/tjh/e+a5noeJKbtcN7/neJMFhY12vpuKfNzafv2iApJzlvc
         c+GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BRkks4605+UoXCWgr/rS+r0/gbRif4B+Nb12472cPkM=;
        b=VK7O0lCGJnAtuW9l++P3hQo7KF/6yxrNjZyqw4Sut3aSPFwpxvnk0ac59U89nz9XZq
         33n4vcw5AtWiVon+rlTXsjt1q4D22izBgGVg/3e+c7323bCmYP3n2l26K/flzgLolGD/
         xf2d8iYnrJd3sQjYFSr7Wtm59xD975v/K2KKFaRKYirXlM6Y2h2RW1tlMVKWA9+Vo6DE
         A79V6I1OfuSX1GHV1rrH2gDjB3VRpvRJIsZbw7iVEWfusQNymUOvHSVHCnETmHVxB3Wa
         IgN3pFNTeGVZqi4hG6wR6h8bO0oLt3EmDH9DCvzoEpJib4hNTvF83vL2pgXLUld0Epxw
         DIig==
X-Gm-Message-State: AOAM533LIqyjXN6ugw7Vm074FeTdK+5Qbe11M7KbHFw1sD+p6JhIfbGh
        +preBHKC00ec9ptN9ZA1RceReg==
X-Google-Smtp-Source: ABdhPJw22/zkz1/TgVaG03mlPKr3hKpRnSstCMcOSyXOdi3X74PyPQdlQSvj2N3vahCgY/SRT/Pqcg==
X-Received: by 2002:a05:6e02:eb0:: with SMTP id u16mr2267775ilj.263.1621306093533;
        Mon, 17 May 2021 19:48:13 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id q5sm9580889ilv.19.2021.05.17.19.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 19:48:13 -0700 (PDT)
Date:   Mon, 17 May 2021 19:48:09 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Dave Taht <dave.taht@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Xianting Tian <xianting.tian@linux.alibaba.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        bloat <bloat@lists.bufferbloat.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [Bloat] virtio_net: BQL?
Message-ID: <20210517194809.071fc896@hermes.local>
In-Reply-To: <CAA93jw4bSx=0gnJtNJLeS00ELMgo2Na+t7hYTNL3G3juDFvcNg@mail.gmail.com>
References: <56270996-33a6-d71b-d935-452dad121df7@linux.alibaba.com>
        <CAA93jw6LUAnWZj0b5FvefpDKUyd6cajCNLoJ6OKrwbu-V_ffrA@mail.gmail.com>
        <CA+FuTSf0Af2RXEG=rCthNNEb5mwKTG37gpEBBZU16qKkvmF=qw@mail.gmail.com>
        <CAA93jw7Vr_pFMsPCrPadqaLGu0BdC-wtCmW2iyHFkHERkaiyWQ@mail.gmail.com>
        <20210517160036.4093d3f2@hermes.local>
        <CAA93jw4bSx=0gnJtNJLeS00ELMgo2Na+t7hYTNL3G3juDFvcNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 May 2021 16:32:21 -0700
Dave Taht <dave.taht@gmail.com> wrote:

> On Mon, May 17, 2021 at 4:00 PM Stephen Hemminger
> <stephen@networkplumber.org> wrote:
> >
> > On Mon, 17 May 2021 14:48:46 -0700
> > Dave Taht <dave.taht@gmail.com> wrote:
> >  
> > > On Mon, May 17, 2021 at 1:23 PM Willem de Bruijn
> > > <willemdebruijn.kernel@gmail.com> wrote:  
> > > >
> > > > On Mon, May 17, 2021 at 2:44 PM Dave Taht <dave.taht@gmail.com> wrote:  
> > > > >
> > > > > Not really related to this patch, but is there some reason why virtio
> > > > > has no support for BQL?  
> > > >
> > > > There have been a few attempts to add it over the years.
> > > >
> > > > Most recently, https://lore.kernel.org/lkml/20181205225323.12555-2-mst@redhat.com/
> > > >
> > > > That thread has a long discussion. I think the key open issue remains
> > > >
> > > > "The tricky part is the mode switching between napi and no napi."  
> > >
> > > Oy, vey.
> > >
> > > I didn't pay any attention to that discussion, sadly enough.
> > >
> > > It's been about that long (2018) since I paid any attention to
> > > bufferbloat in the cloud and my cloudy provider (linode) switched to
> > > using virtio when I wasn't looking. For over a year now, I'd been
> > > getting reports saying that comcast's pie rollout wasn't working as
> > > well as expected, that evenroute's implementation of sch_cake and sqm
> > > on inbound wasn't working right, nor pf_sense's and numerous other
> > > issues at Internet scale.
> > >
> > > Last week I ran a string of benchmarks against starlink's new services
> > > and was really aghast at what I found there, too. but the problem
> > > seemed deeper than in just the dishy...
> > >
> > > Without BQL, there's no backpressure for fq_codel to do its thing.
> > > None. My measurement servers aren't FQ-codeling
> > > no matter how much load I put on them. Since that qdisc is the default
> > > now in most linux distributions, I imagine that the bulk of the cloud
> > > is now behaving as erratically as linux was in 2011 with enormous
> > > swings in throughput and latency from GSO/TSO hitting overlarge rx/tx
> > > rings, [1], breaking various rate estimators in codel, pie and the tcp
> > > stack itself.
> > >
> > > See:
> > >
> > > http://fremont.starlink.taht.net/~d/virtio_nobql/rrul_-_evenroute_v3_server_fq_codel.png
> > >
> > > See the swings in latency there? that's symptomatic of tx/rx rings
> > > filling and emptying.
> > >
> > > it wasn't until I switched my measurement server temporarily over to
> > > sch_fq that I got a rrul result that was close to the results we used
> > > to get from the virtualized e1000e drivers we were using in 2014.
> > >
> > > http://fremont.starlink.taht.net/~d/virtio_nobql/rrul_-_evenroute_v3_server_fq.png
> > >
> > > While I have long supported the use of sch_fq for tcp-heavy workloads,
> > > it still behaves better with bql in place, and fq_codel is better for
> > > generic workloads... but needs bql based backpressure to kick in.
> > >
> > > [1] I really hope I'm overreacting but, um, er, could someone(s) spin
> > > up a new patch that does bql in some way even half right for this
> > > driver and help test it? I haven't built a kernel in a while.
> > >  
> >
> > The Azure network driver (netvsc) also does not have BQL. Several years ago
> > I tried adding it but it benchmarked worse and there is the added complexity
> > of handling the accelerated networking VF path.  
> 
> I certainly agree it adds complexity, but the question is what sort of
> network behavior resulted without backpressure inside the
> vm?
> 
> What sorts of benchmarks did you do?
> 
> I will get setup to do some testing of this that is less adhoc.

Less of an issue than it seems for must users.

For the most common case, all transmits are passed through to the underlying
VF network device (Mellanox). So since Mellanox supports BQL, that works.
The special case is if accelerated networking is disabled or host is being
serviced and the slow path is used. Optimizing the slow path is not that
interesting.

I wonder if the use of SRIOV with virtio (which requires another layer
with the failover device) behaves the same way?
