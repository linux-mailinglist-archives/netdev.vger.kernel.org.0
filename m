Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 537C8225BBB
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 11:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728241AbgGTJeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 05:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727940AbgGTJeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 05:34:00 -0400
Received: from mail-ua1-x941.google.com (mail-ua1-x941.google.com [IPv6:2607:f8b0:4864:20::941])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF7DFC061794;
        Mon, 20 Jul 2020 02:33:59 -0700 (PDT)
Received: by mail-ua1-x941.google.com with SMTP id k7so4807813uan.13;
        Mon, 20 Jul 2020 02:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ODYab/70orF5HqomA3ceZEFfsWi7uZDmUBXTTbkr6AY=;
        b=l40X17yKiB1B6NYIsgs8+6PbWRqwRHh0wc6Hfx8Slwd3ZJ6+5iTVgA3I60YDU4DwF5
         20GdiwOrtN6zfFiydL/QF2/d7meMt726UI4u52KyViTXzrADy+dbhCEoymVhlRBV1XOE
         RmqLB/X1uMRrm1mprBiRyDlTEDZyhS63s+3EiZyvEdpjk2YFdpBzBl7tneF6HxFwKx95
         w7GY2QbanX8jgttCl41gHRPxtrb6EpogPQBTug49vb6YL2gDC+j8czySgKSBh2EYQ2ey
         GMIFb6g6/ZbxGJ5CI/E2Jn/bArxkT7VnRxLU2VpTsfyIZzvK2LVExwtYhEBMYhxwMz8U
         XEXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ODYab/70orF5HqomA3ceZEFfsWi7uZDmUBXTTbkr6AY=;
        b=S2zEmeT8Z2i9Y4vq+KNRHGHWRj30gV0gkFOvFZWDe1nEwAoUoIHsczwtw6nzQ8oBUb
         zSZZ341X7UuSgpx0yKUdJIek2s5JWXfZgC32gp8UUnLakprf1IlM4e/K4CykKp/TpuqR
         NzW5kDTOEoLm4yzLzeP6krwMTgO6wpe6XOU3kqYhVrXpjsnmge65YusSQ/38dpdqfd9q
         +1mzTZhEtqA6ocgeObHxsWMbvnTlPkjATtmN3KU8OG9y40gV2Fava1xgEBzBIX9w76y9
         Be+8eDVaFQXWvbaap86IJNW7nJDyYwfX94NINnXOAKb/soU43c8L+/wyM52gjdvXmNGv
         px/Q==
X-Gm-Message-State: AOAM532cnuC915/Vg+cYGaC7Oj7rYPAMLYhoWbvju59GvyB9WsbdQ/Jb
        cnMHTFRsQ8dxz6TNwoRxzCS+sczLCXSQXgRKcYg=
X-Google-Smtp-Source: ABdhPJw3AjC9UAHOORF9IdAJ4k/LkLIhTTlIPmcOfb30oZN+UHEvH09axHiuEB2mcfe2J7BmTeMWT1Qym7RTw++4zaY=
X-Received: by 2002:ab0:64cd:: with SMTP id j13mr13928068uaq.33.1595237638814;
 Mon, 20 Jul 2020 02:33:58 -0700 (PDT)
MIME-Version: 1.0
References: <1594390602-7635-1-git-send-email-magnus.karlsson@intel.com>
 <1594390602-7635-12-git-send-email-magnus.karlsson@intel.com>
 <fc6e254c-5153-aa72-77d1-693e24b49848@mellanox.com> <CAJ8uoz30f_jbtH4bM-YAxyPq2+zqC1CC3c+eQFg-ECwgkOfzSw@mail.gmail.com>
In-Reply-To: <CAJ8uoz30f_jbtH4bM-YAxyPq2+zqC1CC3c+eQFg-ECwgkOfzSw@mail.gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 20 Jul 2020 11:33:47 +0200
Message-ID: <CAJ8uoz1HJuAz5Pu5Adyobt8QTLq=pT161w3R=G-dhTt49WUegQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 11/14] xsk: add shared umem support between devices
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>, jeffrey.t.kirsher@intel.com,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        cristian.dumitrescu@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 6:35 AM Magnus Karlsson
<magnus.karlsson@gmail.com> wrote:
>
> On Tue, Jul 14, 2020 at 12:18 PM Maxim Mikityanskiy
> <maximmi@mellanox.com> wrote:
> >
> > On 2020-07-10 17:16, Magnus Karlsson wrote:
> > > Add support to share a umem between different devices. This mode
> > > can be invoked with the XDP_SHARED_UMEM bind flag. Previously,
> > > sharing was only supported within the same device. Note that when
> > > sharing a umem between devices, just as in the case of sharing a
> > > umem between queue ids, you need to create a fill ring and a
> > > completion ring and tie them to the socket (with two setsockopts,
> > > one for each ring) before you do the bind with the
> > > XDP_SHARED_UMEM flag. This so that the single-producer
> > > single-consumer semantics of the rings can be upheld.
> >
> > I'm not sure if you saw my comment under v1 asking about performance.
> > Could you share what performance numbers (packet rate) you see when
> > doing forwarding with xsk_fwd? I'm interested in:
> >
> > 1. Forwarding between two queues of the same netdev.
> >
> > 2. Forwarding between two netdevs.
> >
> > 3. xdpsock -l as the baseline.
>
> Sorry for the delay Max, but it is all due to vacation. I will provide
> you with the numbers once the weather turns sour and/or the family
> gets tired of me ;-). From what I can remember, it did not scale
> perfectly linearly, instead it hit some other bottleneck, though I did
> not examine what at that time.

Some quick and dirty numbers from my testing of the v3. All from my
machine with an i40e and with 64 byte packets being.

xdpsock -l: 11 Mpps
xsk_fwd with one thread: 12 Mpps
xsk_fwd with two threads and two netdevs (two ports on the same NIC):
9 - 11 Mpps per thread
xsk_fwd with two thread and one netdev, each using one separate queue:
5 Mpps per thread

In summary:

* xsk_fwd delivers better performance compared to xdpsock performing
the same function.
* Using two netdevs does not scale linearly. One is 9 Mpps the other
11 Mpps. Have not examined why. There is a lock in the xsk_fwd code,
so do not expect perfect linearity, but thought the two netdevs would
show the same number at least.
* Something weird is happening when using two queues on the same
netdev. This is also present without the shared umem patch set (if you
register the umem multiple times). Can see that the application is
generating a lot of syscalls with a quick use of perf.

All in all, after this patch set and my vacation I will examine the
scalability of AF_XDP in this scenario and this will most likely lead
to a number of performance optimization patches to improve the
scalability. Would like to have the two last numbers to be closer to
12 Mpps on my machine.

/Magnus

> /Magnus
>
> > Thanks,
> > Max
> >
> > >
> > > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > > ---
> > >   net/xdp/xsk.c | 11 ++++-------
> > >   1 file changed, 4 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > > index 05fadd9..4bf47d3 100644
> > > --- a/net/xdp/xsk.c
> > > +++ b/net/xdp/xsk.c
> > > @@ -695,14 +695,11 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
> > >                       sockfd_put(sock);
> > >                       goto out_unlock;
> > >               }
> > > -             if (umem_xs->dev != dev) {
> > > -                     err = -EINVAL;
> > > -                     sockfd_put(sock);
> > > -                     goto out_unlock;
> > > -             }
> > >
> > > -             if (umem_xs->queue_id != qid) {
> > > -                     /* Share the umem with another socket on another qid */
> > > +             if (umem_xs->queue_id != qid || umem_xs->dev != dev) {
> > > +                     /* Share the umem with another socket on another qid
> > > +                      * and/or device.
> > > +                      */
> > >                       xs->pool = xp_create_and_assign_umem(xs,
> > >                                                            umem_xs->umem);
> > >                       if (!xs->pool) {
> > >
> >
