Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9B341AE18
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 13:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240424AbhI1LuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 07:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240380AbhI1LuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 07:50:19 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A21FC061575;
        Tue, 28 Sep 2021 04:48:40 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id s16so18772048pfk.0;
        Tue, 28 Sep 2021 04:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JodMN2j9NOHbjPYuUUfH/OzRsSQnzAOkc7uqM+MkDlw=;
        b=bg4FwRg4CLUcOANGYPgDxb3Mkehm+nlYmJrCZqMohUXWZ1uZ2yPWko0PfVKxiqFjxx
         YV9VHUe0CGh0m4PIqTjthvZStLYWdSfCwXuQ7r8XuYsjambL8zsuiz7L/fnQYYG5zhuW
         ZDACNWywxkpQQEJxTMsavAhQMfWy+TCkIHazTz2BCXOdvKToM9hbFdiy6NbJPrnC/CKb
         wEJ5hYLbc28Tyb8c5Rlrbet0Kpeze40a5M2NxhNZdG19Gl6TmkS7MwwqRunAnEU2Mw4K
         /jL1yf3xgCstcZi2d9x8HEwnf7wvouSCXVbZsOA3C11VX3eaYWVgsy5GO6bYdG+Pwn5G
         DbFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JodMN2j9NOHbjPYuUUfH/OzRsSQnzAOkc7uqM+MkDlw=;
        b=yN7+qVKymTs92NBzf8lsv4+ZUln5hO/dlfRbMfn+1uqZYO7+DEOf0BZRzVy4WYcimL
         3GL8Hmq/zCi/N+xQShXn7TbOyCmBlFvrTqsD7F67f3v5nnZBnltwrEGbd7VRemYija0L
         hmwJk3PX/8nl/cIr6zMFUBbvpqq1DYpnv9MRIKVTvgxwKcwpugPG/dEw7dUYtO99y2b4
         8N2qRo+sYkBon1VvAG9tZGrwRks3vJfvKTU5LL62oOBOmtqVqdr9B0BkumOfgxUJCg8D
         QL/mBfHKSOcyLzJD9696GCbSk6ASE1pVcY1yzNOgZCnatdBnf1AAuvvHmKX23IN387/O
         eG4Q==
X-Gm-Message-State: AOAM5313HHGFd9Zpmorgg1gtIHQT52EcT7S27IEANkV84xcHD1gNA+T9
        axvxUh4kJIYY/lsuGwD68KyoMHwTwl1CSa7V2n4LoqGEcn9V51EZ
X-Google-Smtp-Source: ABdhPJyYR/tTuKSPcF/5j2sNBafOEkO9GArWHqPfDdq/61i20UZ3HLJiIBGVL+rJzM0POmK1BbmilFb/RrZWMXM1oZI=
X-Received: by 2002:a63:e74b:: with SMTP id j11mr4229450pgk.322.1632829719992;
 Tue, 28 Sep 2021 04:48:39 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1631289870.git.lorenzo@kernel.org> <20210916095539.4696ae27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YUSrWiWh57Ys7UdB@lore-desk> <20210917113310.4be9b586@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAADnVQL15NAqbswXedF0r2om8SOiMQE80OSjbyCA56s-B4y8zA@mail.gmail.com>
 <20210917120053.1ec617c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAADnVQKbrkOxfNoixUx-RLJEWULJLyhqjZ=M_X2cFG_APwNyCg@mail.gmail.com>
 <614511bc3408b_8d5120862@john-XPS-13-9370.notmuch> <8735q25ccg.fsf@toke.dk>
 <20210920110216.4c54c9a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87lf3r3qrn.fsf@toke.dk> <20210920142542.7b451b78@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87ilyu50kl.fsf@toke.dk> <2C4CB8CA-1234-4761-8F74-49A198F94880@redhat.com>
In-Reply-To: <2C4CB8CA-1234-4761-8F74-49A198F94880@redhat.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 28 Sep 2021 13:48:28 +0200
Message-ID: <CAJ8uoz3Dfz=RGoF2zqhVBXYA+AfPYvVu_SqcrEnKZY1QHxNdJQ@mail.gmail.com>
Subject: Re: [PATCH v14 bpf-next 00/18] mvneta: introduce XDP multi-buffer support
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Tirthendu <tirthendu.sarkar@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 21, 2021 at 12:04 PM Eelco Chaudron <echaudro@redhat.com> wrote=
:
>
>
>
> On 21 Sep 2021, at 0:44, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>
> > Jakub Kicinski <kuba@kernel.org> writes:
> >
> >> On Mon, 20 Sep 2021 23:01:48 +0200 Toke H=C3=B8iland-J=C3=B8rgensen wr=
ote:
> >>>> In fact I don't think there is anything infra can do better for
> >>>> flushing than the prog itself:
> >>>>
> >>>>    bool mod =3D false;
> >>>>
> >>>>    ptr =3D bpf_header_pointer(...);
> >>>>    ...
> >>>>    if (some_cond(...)) {
> >>>>            change_packet(...);
> >>>>            mod =3D true;
> >>>>    }
> >>>>    ...
> >>>>    if (mod)
> >>>
> >>> to have an additional check like:
> >>>
> >>> if (mod && ptr =3D=3D stack)
> >>>
> >>> (or something to that effect). No?
> >>
> >> Good point. Do you think we should have the kernel add/inline this
> >> optimization or have the user do it explicitly.
> >
> > Hmm, good question. On the one hand it seems like an easy optimisation
> > to add, but on the other hand maybe the caller has other logic that can
> > better know how/when to omit the check.
> >
> > Hmm, but the helper needs to check it anyway, doesn't it? At least it
> > can't just blindly memcpy() if the source and destination would be the
> > same...
> >
> >> The draft API was:
> >>
> >> void *xdp_mb_pointer_flush(struct xdp_buff *xdp_md, u32 flags,
> >>                            u32 offset, u32 len, void *stack_buf)
> >>
> >> Which does not take the ptr returned by header_pointer(), but that's
> >> easy to add (well, easy other than the fact it'd be the 6th arg).
> >
> > I guess we could play some trickery with stuffing offset/len/flags into
> > one or two u64s to save an argument or two?
> >
> >> BTW I drafted the API this way to cater to the case where flush()
> >> is called without a prior call to header_pointer(). For when packet
> >> trailer or header is populated directly from a map value. Dunno if
> >> that's actually useful, either.
> >
> > Ah, didn't think of that; so then it really becomes a generic
> > xdp_store_bytes()-type helper? Might be useful, I suppose. Adding
> > headers is certainly a fairly common occurrence, but dunno to what
> > extent they'd be copied wholesale from a map (hadn't thought about doin=
g
> > that before either).
>
>
> Sorry for commenting late but I was busy and had to catch up on emails...
>
> I like the idea, as these APIs are exactly what I proposed in April, http=
s://lore.kernel.org/bpf/FD3E6E08-DE78-4FBA-96F6-646C93E88631@redhat.com/
>
> I did not call it flush, as it can be used as a general function to copy =
data to a specific location.

Here is some performance data (throughput) for this patch set on i40e
(40 Gbit/s NIC). All using the xdp_rxq_info sample and NO multi-buffer
packets.

With v14 only:

XDP_DROP: +4%
XDP_TX: +1%
XDP_PASS: -1%

With v14 plus multi-buffer support implemented in i40e courtesy of Tirtha:

XDP_DROP: +3%
XDP_TX: -1%
XDP_PASS: -2%

/Magnus

>
> //Eelco
>
