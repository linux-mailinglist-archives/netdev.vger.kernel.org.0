Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BADC48F07E
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 20:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244119AbiANTfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 14:35:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244115AbiANTfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 14:35:17 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB23C061574;
        Fri, 14 Jan 2022 11:35:17 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id b1so9225887ilj.2;
        Fri, 14 Jan 2022 11:35:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WBw/MJ4zo+l9u4s/FhgIl55LwuJiTSEG+Eoot+09J00=;
        b=hNqBH+Y7PtAE1OvVLN+NpsTHz5pWo4kZs/75QRkYx0SumG60tqVHni5eEgjDEnQT6H
         YKZ6tYTr4mMjnNdJ8DQQ9wK12x/Vvz91h3u8qlDngr1OCzxL8EHPMLwoPCZEJdrNivtm
         KmMyvz0IlQD6kRsWAvapuuVPqIrU7Y1XlBbrhpU6ioIdGmlBe7pI07wxMw3l0S3/1pdi
         PWpUA0ISrfCjjERjxoL5iNXfJBUZzRNNvLw4X+vqCPDjfZ0uGMFRCJs4reg9HIW5bXu8
         Ued9mBXD60PDQF+p17BaWdGHTiCPP0p9oChsV1L+JFEp9Bwg0fld56uTiXiP2/1igtSv
         Jf6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WBw/MJ4zo+l9u4s/FhgIl55LwuJiTSEG+Eoot+09J00=;
        b=ZzrV+/A+zICU4f5A/y27dp6gCzZ2gK8qfTokrXKoxrgPD2zRe3myFmZmDnBmqTvdmC
         lBQh0N9MGiNk+2wDAWbt+fZ/WOQ0Tkt9Z1LPiMmRwTkgY0lFQJf+QBJXkO3seh2LBitA
         5G1axy4OTWCfUhiAMdN0Zz5M4nfXNyPsVU0p02alBpsBQTlEg+ZwqufY5OQmSdiXI5xO
         WqWA7n4XkcdoFsGUAh6pKjbY2Smoq67AhW+ehoa101cOzxvXn8Uvmbd98LRmVnQszYcu
         cjz4cAataqR5rknTF+95CByjbmAwBfX9j6NTY7ptHvvigXTI4wDKHNdFs0/pebdGypnY
         oDLw==
X-Gm-Message-State: AOAM530+CVlJ8QHuFK71/rAAWHWJy42Cq9NZ/jYq26ngo5rG0jpp9ymB
        EuGvTGx9X3N47SjL6OYa0Luq3Cj6zyOpwFC7/cE=
X-Google-Smtp-Source: ABdhPJxJXyaITHunJxH+EqKjzkvnJOBNbtfNhB9osLTt05b3H5jZIaR42V56VYrrSBef//NqTKDPXU/KwJgFJ+hr0+0=
X-Received: by 2002:a05:6e02:1c02:: with SMTP id l2mr5763618ilh.239.1642188916535;
 Fri, 14 Jan 2022 11:35:16 -0800 (PST)
MIME-Version: 1.0
References: <CAEf4Bza+WO5U+Kw=S+GvQBgu5VHfPL29u7eLSQq34jvYzGnbBA@mail.gmail.com>
 <CAADnVQLGxjvOO3Ae3mGTWTyd0aHnACxYoF8daNi+z56NQyYQug@mail.gmail.com>
 <CAEf4BzZ4c1VwPf9oBRRdN7jdBWrk4pg=mw_50LMjLr99Mb0yfw@mail.gmail.com>
 <CAADnVQ+BiMy4TZNocfFSvazh-QTFwMD-3uQ9LLiku7ePLDn=MQ@mail.gmail.com>
 <CAC1LvL0CeTw+YKjO6r0f68Ly3tK4qhDyjV0ak82e0PpHURVQOw@mail.gmail.com>
 <Yd82J8vxSAR9tvQt@lore-desk> <8735lshapk.fsf@toke.dk> <47a3863b-080c-3ac2-ff2d-466b74d82c1c@redhat.com>
 <Yd/9SPHAPH3CpSnN@lore-desk> <CAADnVQJaB8mmnD1Z4jxva0CqA2D0aQDmXggMEQPX2MRLZvoLzA@mail.gmail.com>
 <YeGmZDI6etoB0hKx@lore-desk>
In-Reply-To: <YeGmZDI6etoB0hKx@lore-desk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 14 Jan 2022 11:35:05 -0800
Message-ID: <CAEf4BzZFu-5FChGhQrHcu-2kJe-qO6xXCdmGO-L6cViMMmtbYg@mail.gmail.com>
Subject: Re: [PATCH v21 bpf-next 18/23] libbpf: Add SEC name for xdp_mb programs
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Zvi Effron <zeffron@riotgames.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Shay Agroskin <shayagr@amazon.com>,
        john fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        tirthendu.sarkar@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 14, 2022 at 8:35 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> > On Thu, Jan 13, 2022 at 2:22 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > > > > >
> > > > > > I would prefer to keep the "_mb" postfix, but naming is hard and I am
> > > > > > polarized :)
> > > > >
> > > > > I would lean towards keeping _mb as well, but if it does have to be
> > > > > changed why not _mbuf? At least that's not quite as verbose :)
> > > >
> > > > I dislike the "mb" abbreviation as I forget it stands for multi-buffer.
> > > > I like the "mbuf" suggestion, even-though it conflicts with (Free)BSD mbufs
> > > > (which is their SKB).
> > >
> > > If we all agree, I can go over the series and substitute mb postfix with mbuf.
> > > Any objections?
> >
> > mbuf has too much bsd taste.
> >
> > How about ".frags" instead?
> > Then xdp_buff_is_mb() will be xdp_buff_has_frags().
> >
> > I agree that it's not obvious what "mb" suffix stands for,
> > but I don't buy at all that it can be confused with "megabyte".
> > It's the context that matters.
> > In "100mb" it's obvious that "mb" is likely "megabyte",
> > but in "xdp.mb" it's certainly not "xdp megabyte".
> > Such a sentence has no meaning.
> > Imagine we used that suffix for "tc"...
> > it would be "tc.mb"... "Traffic Control Megabyte" ??
> >
> > Anyway "xdp.frags" ?
> >
> > Btw "xdp_cpumap" should be cleaned up.
> > xdp_cpumap is an attach type. It's not prog type.
> > Probably it should be "xdp/cpumap" to align with "cgroup/bind[46]" ?
>
> If we change xdp_devmap/ in xdp/devmap (and xdp_cpumap/ in xdp/cpumap),
> are we going to break backward compatibility?
> Maybe there are programs already deployed using it.
> This is not a xdp multi-buff problem since we are not breaking backward
> compatibility there, we can just use:
>
> xdp.frags/devmap
> xdp.frags/cpumap
>
> Moreover in samples/bpf we have something like:
>
> SEC("xdp_devmap/egress")
>
> It seems to me the egress postfix is not really used, right? Can we just drop
> it?

Yeah, by current rules it should be just SEC("xdp_devmap"). This will
break in libbpf 1.0 mode. For anyone who knows how to actually test
BPF samples, it would be great to add
libbpf_set_strict_mode(LIBBPF_STRICT_ALL); in every sample and make
sure everything is still working. We've cleaned up selftests and all
other places I knew about, but missed samples (and I can't test them
properly).


>
> Regards,
> Lorenzo
>
> >
> > In patch 22 there is a comment:
> > /* try to attach BPF_XDP_DEVMAP multi-buff program"
> >
> > It creates further confusion. There is no XDP_DEVMAP program type.
> > It should probably read
> > "Attach BPF_XDP program with frags to devmap"
> >
> > Patch 21 still has "CHECK". Pls replace it with ASSERT.
