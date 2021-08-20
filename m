Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 656633F32E0
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 20:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235779AbhHTSPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 14:15:38 -0400
Received: from linux.microsoft.com ([13.77.154.182]:42732 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbhHTSPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 14:15:37 -0400
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
        by linux.microsoft.com (Postfix) with ESMTPSA id 325D720C33D4;
        Fri, 20 Aug 2021 11:14:59 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 325D720C33D4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1629483299;
        bh=UW5TElFP/RTBb2KKkUeXBfbuUlBUxtX/AtHK8rIv3Q4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=aNmfrAPThbvUKjB9EGI1zxxmKNepmRru9jyeoYK8nXHg6Q2RedfVl5EcB1xemLSaq
         DbQTnbHXVHXWwEAQY9Q4/D8tVgWkuQDpi7Uyf4x+9DFulxTyFoOuFttTVtjWhiebGj
         oIxl9oP+FT3euE8AmTTye79Si6UnS8W8HqK37XuM=
Received: by mail-pg1-f170.google.com with SMTP id e7so9967134pgk.2;
        Fri, 20 Aug 2021 11:14:59 -0700 (PDT)
X-Gm-Message-State: AOAM5320rLk4nj3ccULo0+vOtWBAh2YwMXxsUYp4U9sg+lswvsDkC4QU
        oWyXwA2EzckdZxsfBD9abCywXtG6+fg9GCR4lRk=
X-Google-Smtp-Source: ABdhPJxNyaoyJdeQdc0Du7UXqISNDylKZ5mZPUA04QcpgA8wWE4WpdOtzpukf9L0Qf4T9l50VfZH0RRUbWQzCTuSvZ0=
X-Received: by 2002:a05:6a00:225c:b0:3e1:a127:dd96 with SMTP id
 i28-20020a056a00225c00b003e1a127dd96mr21298632pfu.0.1629483298725; Fri, 20
 Aug 2021 11:14:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210614022504.24458-1-mcroce@linux.microsoft.com>
 <871r71azjw.wl-maz@kernel.org> <YROmOQ+4Kqukgd6z@orome.fritz.box>
 <202417ef-f8ae-895d-4d07-1f9f3d89b4a4@gmail.com> <87o8a49idp.wl-maz@kernel.org>
 <fe5f99c8-5655-7fbb-a64e-b5f067c3273c@gmail.com> <20210812121835.405d2e37@linux.microsoft.com>
 <874kbuapod.wl-maz@kernel.org> <CAFnufp2=1t2+fmxyGJ0Qu3Z+=wRwAX8faaPvrJdFpFeTS3J7Uw@mail.gmail.com>
 <87wnohqty1.wl-maz@kernel.org> <CAFnufp3xjYqe_iVfbmdjz4-xN2UX_oo3GUw4Z4M_q-R38EN+uQ@mail.gmail.com>
 <87fsv4qdzm.wl-maz@kernel.org> <CAFnufp2T75cvDLUx+ZyPQbkaNeY_S1OJ7KTJe=2EK-qXRNkwyw@mail.gmail.com>
 <87mtpcyrdv.wl-maz@kernel.org> <CAFnufp0N2MzaTjF95tx9Q1D33z9f9AAK6UHbhU9rhG1ue_r1ug@mail.gmail.com>
 <87h7fkyqpv.wl-maz@kernel.org> <CAFnufp3HbyeTGhxB33mej4Y4G2T2Yv5swKCx_C41zfc71Kj11A@mail.gmail.com>
 <87fsv4ypfn.wl-maz@kernel.org> <CAFnufp2qFuhMDae20u_dV+aOPfB+zpcEK8D-=8ACE6r4kDn2rw@mail.gmail.com>
 <87eeaoyon3.wl-maz@kernel.org>
In-Reply-To: <87eeaoyon3.wl-maz@kernel.org>
From:   Matteo Croce <mcroce@linux.microsoft.com>
Date:   Fri, 20 Aug 2021 20:14:22 +0200
X-Gmail-Original-Message-ID: <CAFnufp22=M0NRvaAcXgfUVzA2HNFLwxO6Bwp+GZk56S3ycLbNQ@mail.gmail.com>
Message-ID: <CAFnufp22=M0NRvaAcXgfUVzA2HNFLwxO6Bwp+GZk56S3ycLbNQ@mail.gmail.com>
Subject: Re: [PATCH net-next] stmmac: align RX buffers
To:     Marc Zyngier <maz@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Drew Fustini <drew@beagleboard.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Jon Hunter <jonathanh@nvidia.com>,
        Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 20, 2021 at 8:09 PM Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 20 Aug 2021 18:56:33 +0100,
> Matteo Croce <mcroce@linux.microsoft.com> wrote:
> >
> > On Fri, Aug 20, 2021 at 7:51 PM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > On Fri, 20 Aug 2021 18:35:45 +0100,
> > > Matteo Croce <mcroce@linux.microsoft.com> wrote:
> > > >
> > > > > > I think it's wrong. The original offset was 0, and to align it to the
> > > > > > boundary we need to add just NET_IP_ALIGN, which is two.
> > > > > > NET_SKB_PAD is a much bigger value, (I think 64), which is used to
> > > > > > reserve space to prepend an header, e.g. with tunnels.
> > > > >
> > > > > How about the other adjustments that Eric mentioned regarding the size
> > > > > of the buffer? Aren't they required?
> > > > >
> > > >
> > > > I guess that if stmmac_rx_buf1_len() needed such adjustment, it would
> > > > be already broken when XDP is in use.
> > > > When you use XDP, stmmac_rx_offset() adds a pretty big headroom of 256
> > > > byte, which would easily trigger an overflow if not accounted.
> > > > Did you try attaching a simple XDP program on a stock 5.13 kernel?
> > >
> > > Yes, as mentioned in [1], to which you replied...
> > >
> > >         M.
> > >
> > > [1] https://lore.kernel.org/r/87wnohqty1.wl-maz@kernel.org
> > >
> >
> > Great.
> > So I doubt that the adjustment is needed.
> > Does it work with all the frame size?
>
> I have no idea. Honestly, you are the one who should be able to answer
> these questions, given that you should have worked out how the buffer
> allocations work in this particular driver.
>
> This whole "let's try another random set of values until something
> sticks" is not how things ought to be done, and doesn't fill me with
> the utmost confidence that 5.14 (which apparently may well be cut in
> *two days*) is going to have a solid stmmac driver.
>
> I re-re-request that this patch gets reverted until you figure out
> what is wrong with the initial patch.
>
> Thanks,
>

I would have done it, but I'll not have the hardware until next week at least,
otherwise I'd have tried all these tests myself.

I'm sure that NET_SKB_PAD doesn't need to be there, if just removing
it fixes the problem, consider applying it and put a Fixes tag.

-- 
per aspera ad upstream
