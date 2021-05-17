Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04D24386C9A
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 23:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245627AbhEQVuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 17:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbhEQVuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 17:50:17 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9AF7C061573;
        Mon, 17 May 2021 14:48:59 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id e14so7326435ils.12;
        Mon, 17 May 2021 14:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5k+CB7+a281FNvx4AyiO3QnFARm73PakcEl2o60CjU0=;
        b=Byg+eK9Ri8MLuHrFeOzSlMEqt8c+nOthtNHB2zWpR2gdR9+jDhnbv3eQz6Bz3e6KfT
         O5nmBP3lCxBqBCGs5iKzyQIwF9mttkHstrRTusVt0o3r/NqTGJY7jcyRsV3MfKutz8sz
         Dz+j9p0UPByLCL+3nS99hkh5KufrlEbig5C94K1F45f7w6fiUNaaFhGdo62My7Y8jdaC
         7dt4Koiu0YT60GRN56mnhv/OuVl2SqRaua3+OWPvjhFQnaJ7+56Dv2KvfxpL+YiRtoAT
         nmNIK6EzoWNt1bjwmhuis+pSZ24mJKrFiKKVU0UcQJ78nZZAoHVpt5OhUfLeGTFds6sm
         KBPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5k+CB7+a281FNvx4AyiO3QnFARm73PakcEl2o60CjU0=;
        b=Spot7NZ1Mp3kJYI1usLpHMaSm9DOAB16ytvWPkueRhXIH9qIiUof0v3Eucjr2rwR8Q
         bEu6Efv102NUUkUj2/UUWO4CPytRuwxHSMQHUTGkNUWn9Qb8YIw05rvYrNmNBCpGH173
         zsNFMbLp8yleucrUUi3eTg+PK0hZ2MRqSDFWNL+pJADsdssxbJlgkkDAnqOyAC/fBcXk
         vSPQAfiZFbxWWK8Xrd4DCA0i31yaj0T4Nal6gcY2l5LYgmvB4S97pYfIejXNHsgg6U2l
         Vyj/OhEaRT6ykcJ+a+BxpYqmNnunK0VcqQ95SF8pVJPQVJaYwboXPy6L1d5x7Od8y4Kv
         L2CA==
X-Gm-Message-State: AOAM530M+MOYTTYja8yCtASZDhmqLfh9jeBUxQdf4WWLzEOeTEnJAJ5x
        MSEhp7MX2iZdWY7uiFE7KeABL2FsoYzutiI4gIc=
X-Google-Smtp-Source: ABdhPJwXdm3VL7bieUMtr1BfTjcSmohISUpITGC6QuDiCZ7r6aZrLr+fVUI/Vhh97A0izC4hduG3W7JYPpTz6MfQ1ZI=
X-Received: by 2002:a05:6e02:1ba5:: with SMTP id n5mr1392214ili.45.1621288139279;
 Mon, 17 May 2021 14:48:59 -0700 (PDT)
MIME-Version: 1.0
References: <56270996-33a6-d71b-d935-452dad121df7@linux.alibaba.com>
 <CAA93jw6LUAnWZj0b5FvefpDKUyd6cajCNLoJ6OKrwbu-V_ffrA@mail.gmail.com> <CA+FuTSf0Af2RXEG=rCthNNEb5mwKTG37gpEBBZU16qKkvmF=qw@mail.gmail.com>
In-Reply-To: <CA+FuTSf0Af2RXEG=rCthNNEb5mwKTG37gpEBBZU16qKkvmF=qw@mail.gmail.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Mon, 17 May 2021 14:48:46 -0700
Message-ID: <CAA93jw7Vr_pFMsPCrPadqaLGu0BdC-wtCmW2iyHFkHERkaiyWQ@mail.gmail.com>
Subject: Re: virtio_net: BQL?
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        bloat <bloat@lists.bufferbloat.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 17, 2021 at 1:23 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Mon, May 17, 2021 at 2:44 PM Dave Taht <dave.taht@gmail.com> wrote:
> >
> > Not really related to this patch, but is there some reason why virtio
> > has no support for BQL?
>
> There have been a few attempts to add it over the years.
>
> Most recently, https://lore.kernel.org/lkml/20181205225323.12555-2-mst@re=
dhat.com/
>
> That thread has a long discussion. I think the key open issue remains
>
> "The tricky part is the mode switching between napi and no napi."

Oy, vey.

I didn't pay any attention to that discussion, sadly enough.

It's been about that long (2018) since I paid any attention to
bufferbloat in the cloud and my cloudy provider (linode) switched to
using virtio when I wasn't looking. For over a year now, I'd been
getting reports saying that comcast's pie rollout wasn't working as
well as expected, that evenroute's implementation of sch_cake and sqm
on inbound wasn't working right, nor pf_sense's and numerous other
issues at Internet scale.

Last week I ran a string of benchmarks against starlink's new services
and was really aghast at what I found there, too. but the problem
seemed deeper than in just the dishy...

Without BQL, there's no backpressure for fq_codel to do its thing.
None. My measurement servers aren't FQ-codeling
no matter how much load I put on them. Since that qdisc is the default
now in most linux distributions, I imagine that the bulk of the cloud
is now behaving as erratically as linux was in 2011 with enormous
swings in throughput and latency from GSO/TSO hitting overlarge rx/tx
rings, [1], breaking various rate estimators in codel, pie and the tcp
stack itself.

See:

http://fremont.starlink.taht.net/~d/virtio_nobql/rrul_-_evenroute_v3_server=
_fq_codel.png

See the swings in latency there? that's symptomatic of tx/rx rings
filling and emptying.

it wasn't until I switched my measurement server temporarily over to
sch_fq that I got a rrul result that was close to the results we used
to get from the virtualized e1000e drivers we were using in 2014.

http://fremont.starlink.taht.net/~d/virtio_nobql/rrul_-_evenroute_v3_server=
_fq.png

While I have long supported the use of sch_fq for tcp-heavy workloads,
it still behaves better with bql in place, and fq_codel is better for
generic workloads... but needs bql based backpressure to kick in.

[1] I really hope I'm overreacting but, um, er, could someone(s) spin
up a new patch that does bql in some way even half right for this
driver and help test it? I haven't built a kernel in a while.


> > On Mon, May 17, 2021 at 11:41 AM Xianting Tian
> > <xianting.tian@linux.alibaba.com> wrote:
> > >
> > > BUG_ON() uses unlikely in if(), which can be optimized at compile tim=
e.
> > >
> > > Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
> > > ---
> > >   drivers/net/virtio_net.c | 5 ++---
> > >   1 file changed, 2 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index c921ebf3ae82..212d52204884 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -1646,10 +1646,9 @@ static int xmit_skb(struct send_queue *sq, str=
uct
> > > sk_buff *skb)
> > >         else
> > >                 hdr =3D skb_vnet_hdr(skb);
> > >
> > > -       if (virtio_net_hdr_from_skb(skb, &hdr->hdr,
> > > +       BUG_ON(virtio_net_hdr_from_skb(skb, &hdr->hdr,
> > >                                     virtio_is_little_endian(vi->vdev)=
, false,
> > > -                                   0))
> > > -               BUG();
> > > +                                   0));
> > >
> > >         if (vi->mergeable_rx_bufs)
> > >                 hdr->num_buffers =3D 0;
> > > --
> > > 2.17.1
> > >
> >
> >
> > --
> > Latest Podcast:
> > https://www.linkedin.com/feed/update/urn:li:activity:679101428493678592=
0/
> >
> > Dave T=C3=A4ht CTO, TekLibre, LLC



--
Latest Podcast:
https://www.linkedin.com/feed/update/urn:li:activity:6791014284936785920/

Dave T=C3=A4ht CTO, TekLibre, LLC
