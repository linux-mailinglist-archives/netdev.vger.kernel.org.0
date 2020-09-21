Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2FB272BB4
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 18:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728011AbgIUQVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 12:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726795AbgIUQVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 12:21:51 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED9C8C061755;
        Mon, 21 Sep 2020 09:21:50 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id a15so11632667ljk.2;
        Mon, 21 Sep 2020 09:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1Rr9hM5e6lCwZ+Wb7iVZ2d8auenimpqljkFmliukLTU=;
        b=GdPlHZ3emy11C+0U4r6hITtJTVJP1ZNTv6uIUOsVePzNK4yvlkyvhaxzRJSd+pLTIT
         gG4U0KZZa+DlsOlK5tI8p9gw2iKNCrpVrVblbaBR6w+auOGueo9Nnzc1RkIaCJkozK7m
         PbGZB7yL+ndPO8wj066Sv52Y5g2A/8+0rpLofMyuAPHPYoLWGSnPe2afDAjEHyQJrU3t
         Uhhc8yd945V4Jrqg2YGqZ4mRaqtwNiwF2M+js2yOjrthDE4WKjo/6s/p7hmnoNnOexCW
         1oSoPQA26O3aGsZixD4hS/LwzleHJ8zH6gOdXMC0/IL4XYsvyDV2adQ/6cGedS/L/Vc2
         4U8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1Rr9hM5e6lCwZ+Wb7iVZ2d8auenimpqljkFmliukLTU=;
        b=W9vByir3Mb1UFniXmCTthkpWRU1Ct8k9wEV+Pw1i03nroqSpXQT7BeGKhCIk21x0rC
         2UR6tOlN2QyPDkiLXX73n3DuGS83OuTlnmRZPzLWLBPI/cVo9j6G79CorVjhsS553EZH
         6LkIk2pDLC3563txjwptDxBSacQGP7BupsXv6BVc/hu1PsmrEzmbRTF2tjgL1RHxSD9h
         HlkNgtDGmCsH682+qYNsPPuhaKLSfH5YwWKXUUZm6ERMpNl9JRgbZQbQDTIvqhEhaiAr
         9tbAPBHOwsjLhqDxM6TVDLSXTtytwbwXz18ZtJuUlIYg6wSTZlkE9McmAHJenMwrcqJ9
         frVQ==
X-Gm-Message-State: AOAM5310NyjfXmqeI/VBJBHDeIpn+iPlMbCG1enzNESak5pmkgkD7rNA
        gkJcKYtad3Wbfb5MWzlC+DKPbDBgYKG/6pIXZyY=
X-Google-Smtp-Source: ABdhPJxnzzrXPkdCDLa0vUtCa7d5T9mvolZIWLu/3d3Dw2gX7azzVGqjfhIESA68u6vmml2hKOWyiNvJOJ/IucAu77E=
X-Received: by 2002:a2e:760d:: with SMTP id r13mr141162ljc.67.1600705309083;
 Mon, 21 Sep 2020 09:21:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200917143846.37ce43a0@carbon> <CANP3RGcxM-Cno=Qw5Lut9DgmV=1suXqetnybA9RgxmW3KmwivQ@mail.gmail.com>
 <56ccfc21195b19d5b25559aca4cef5c450d0c402.camel@kernel.org>
 <20200918120016.7007f437@carbon> <CANP3RGfUj-KKHHQtbggiZ4V-Xrr_sk+TWyN5FgYUGZS6rOX1yw@mail.gmail.com>
 <CACAyw9-v_o+gPUpC-R9SXsfzMywrdGsWV13Nk=tx2aS-fEBFYg@mail.gmail.com>
 <20200921144953.6456d47d@carbon> <340f209d-58d4-52a6-0804-7102d80c1468@iogearbox.net>
In-Reply-To: <340f209d-58d4-52a6-0804-7102d80c1468@iogearbox.net>
From:   Marek Zavodsky <marek.zavodsky@gmail.com>
Date:   Mon, 21 Sep 2020 18:21:41 +0200
Message-ID: <CAG0p+LmqDXCJVygVtqvmsd2v4A=HRZdsGU3mSY0G=tGr2DoUvQ@mail.gmail.com>
Subject: Re: BPF redirect API design issue for BPF-prog MTU feedback?
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        BPF-dev-list <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shaun Crampton <shaun@tigera.io>,
        David Miller <davem@davemloft.net>,
        Marek Majkowski <marek@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi guys,

My kernel knowledge is small, but I experienced this (similar) issue
with packet encapsulation (not a redirect), therefore modifying the
redirect branch would not help in my case.

I'm working on a TC program to do GUE encap/decap (IP + UDP + GUE,
outer header has extra 52B).
There are no issues with small packets. But when I use curl to
download big file HTTP server chunks data randomly. Some packets have
MTU size, others are even bigger. Big packets are not an issue,
however MTU sized packets fail on bpf_skb_adjust_room with -524
(ENOTSUPP).

Below are some (annotated) logs for small, MTU-sized and beefy packets
I collected from /sys/kernel/debug/tracing/trace.
Log is produced by egress TC on server side (node1 TX)

SMALL PACKET:
            curl-14470 [000] .Ns1   402.561940: 0: PFC ifindex 52, len
66                                            <- skb->ifindex,
skb->len
            curl-14470 [000] .Ns1   402.561940: 0:   gso_segs 1
                                                   <- skb->gso_segs
(no GSO)
            curl-14470 [000] .Ns1   402.561941: 0:   gso_size 0
                                                    <- skb->gso_size
(5.7+) ... skb_is_gso(skb) -> "false"
            curl-14470 [000] .Ns1   402.561941: 0: ID node1 TX
                                                  <- serverside egress
(GUE encap)
            curl-14470 [000] .Ns1   402.561942: 0: DUMP:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D            =
          <- original packet
            curl-14470 [000] .Ns1   402.561942: 0:   Size : 66 B
                                                    <- skb->len
            curl-14470 [000] .Ns1   402.561942: 0:   ETH  : ac010005
-> ac010002, proto 800
            curl-14470 [000] .Ns1   402.561943: 0:   IPv4 : 1010101 ->
ac010002, id 62439
            curl-14470 [000] .Ns1   402.561943: 0:     csum 0x98d7
            curl-14470 [000] .Ns1   402.561944: 0:   TCP  : 4000 ->
60296, Flags [A]
            curl-14470 [000] .Ns1   402.561944: 0:     csum 0xae2b
            curl-14470 [000] .Ns1   402.561944: 0: DUMP: =3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
            curl-14470 [000] .Ns1   402.561946: 0: GUE Encap Tunnel:
id 65636                               <- subject to encap...
            curl-14470 [000] .Ns1   402.561947: 0:     FROM ac010005:6000
            curl-14470 [000] .Ns1   402.561947: 0:     TO
ac010003:5000       (ac010003)
            curl-14470 [000] .Ns1   402.561948: 0: DUMP:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D            =
        <- encapsulated packet
            curl-14470 [000] .Ns1   402.561948: 0:   Size : 118 B
                                                  <- new skb->len
            curl-14470 [000] .Ns1   402.561948: 0:   ETH  : ac010005
-> ac010003, proto 800
            curl-14470 [000] .Ns1   402.561949: 0:   IPv4 : ac010005
-> ac010003, id 62439
            curl-14470 [000] .Ns1   402.561949: 0:     csum 0xee92
            curl-14470 [000] .Ns1   402.561949: 0:   UDP  : 6000 -> 5000
            curl-14470 [000] .Ns1   402.561950: 0:     csum 0x0
            curl-14470 [000] .Ns1   402.561950: 0: DUMP: =3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
            curl-14470 [000] .Ns1   402.561950: 0: Action: TC_ACT_OK

MTU-SIZED PACKET (orig-len <=3D MTU && orig-len + GUE-overhead > MTU):
         systemd-1693  [000] .Ns.   408.640488: 0: PFC ifindex 52, len 1502
         systemd-1693  [000] .Ns.   408.640540: 0:   gso_segs 1
                                                 <- skb->gso_segs (no
GSO)
         systemd-1693  [000] .Ns.   408.640561: 0:   gso_size 0
                                                  <- skb->gso_size
(5.7+) ... skb_is_gso(skb) -> "false"
         systemd-1693  [000] .Ns.   408.640582: 0: ID node1 TX
         systemd-1693  [000] .Ns.   408.640601: 0: DUMP: =3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
         systemd-1693  [000] .Ns.   408.640617: 0:   Size : 1502 B
         systemd-1693  [000] .Ns.   408.640632: 0:   ETH  : ac010005
-> ac010002, proto 800
         systemd-1693  [000] .Ns.   408.640646: 0:   IPv4 : 1010101 ->
ac010002, id 62737
         systemd-1693  [000] .Ns.   408.640659: 0:     csum 0x9211
         systemd-1693  [000] .Ns.   408.640670: 0:   TCP  : 4000 ->
60296, Flags [A]
         systemd-1693  [000] .Ns.   408.640681: 0:     csum 0xb3c7
         systemd-1693  [000] .Ns.   408.640690: 0: DUMP: =3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
         systemd-1693  [000] .Ns.   408.640729: 0: GUE Encap Tunnel: id 656=
36
         systemd-1693  [000] .Ns.   408.640735: 0:     FROM ac010005:6000
         systemd-1693  [000] .Ns.   408.640740: 0:     TO
ac010003:5000       (ac010003)
         systemd-1693  [000] .Ns.   408.640746: 0:
bpf_skb_adjust_room: -524                                    <- FAILED
to enlarge skbuff
         systemd-1693  [000] .Ns.   408.640750: 0: GUE Encap Failed!
         systemd-1693  [000] .Ns.   408.640755: 0: Action: TC_ACT_SHOT

HUGE PACKET:
            curl-14470 [000] ..s1   402.566490: 0: PFC ifindex 52, len 6377=
8
            curl-14470 [000] ..s1   402.566491: 0:   gso_segs 44
                                                  <- skb->gso_segs
(GSO in progress)
            curl-14470 [000] ..s1   402.566491: 0:   gso_size 1448
                                                 <- skb->gso_size
(5.7+) ... skb_is_gso(skb) -> "true"
            curl-14470 [000] ..s1   402.566492: 0: ID node1 TX
            curl-14470 [000] ..s1   402.566492: 0: DUMP: =3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
            curl-14470 [000] ..s1   402.566493: 0:   Size : 63778 B
            curl-14470 [000] ..s1   402.566493: 0:   ETH  : ac010005
-> ac010002, proto 800
            curl-14470 [000] ..s1   402.566493: 0:   IPv4 : 1010101 ->
ac010002, id 62674
            curl-14470 [000] ..s1   402.566494: 0:     csum 0x9f0b
            curl-14470 [000] ..s1   402.566494: 0:   TCP  : 4000 ->
60296, Flags [A]
            curl-14470 [000] ..s1   402.566494: 0:     csum 0xa70c
            curl-14470 [000] ..s1   402.566495: 0: DUMP: =3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
            curl-14470 [000] ..s1   402.566497: 0: GUE Encap Tunnel: id 656=
36
            curl-14470 [000] ..s1   402.566497: 0:     FROM ac010005:6000
            curl-14470 [000] ..s1   402.566497: 0:     TO
ac010003:5000       (ac010003)
            curl-14470 [000] ..s1   402.566498: 0: DUMP: =3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
            curl-14470 [000] ..s1   402.566498: 0:   Size : 63830 B
                                                      <- and it still
works
            curl-14470 [000] ..s1   402.566499: 0:   ETH  : ac010005
-> ac010003, proto 800
            curl-14470 [000] ..s1   402.566499: 0:   IPv4 : ac010005
-> ac010003, id 62674
            curl-14470 [000] ..s1   402.566499: 0:     csum 0xf4c6
            curl-14470 [000] ..s1   402.566500: 0:   UDP  : 6000 -> 5000
            curl-14470 [000] ..s1   402.566500: 0:     csum 0x0
            curl-14470 [000] ..s1   402.566500: 0: DUMP: =3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
            curl-14470 [000] ..s1   402.566500: 0: Action: TC_ACT_OK

I tried kernels from 5.2 to 5.8 and they behave the same, only
difference I noticed is skb->gso_size is supported by 5.7+.
bpf_skb_net_grow should recompute GSO, but base on visual code check
it not getting there because of:
https://github.com/torvalds/linux/blob/9907ab371426da8b3cffa6cc3e4ae5482955=
9207/net/core/filter.c
  line: 3256
    if ((shrink && (len_diff_abs >=3D len_cur ||
            len_cur - len_diff_abs < len_min)) ||
        (!shrink && (skb->len + len_diff_abs > len_max &&          <-
enlarge && new-size-exceeds-MTU && gso-size is not set yet
             !skb_is_gso(skb))))
        return -ENOTSUPP;

IMHO len_max could help, but I do not understand the
"!skb_is_gso(skb)" check under current conditions. I'm probably
missing something here, but if it was a "system wide" setting it would
make sense (we can handle > MTU packets because GSO kicks in OR we
can't because of no GSO). But it doesn't make sense to me why some
packets in the same stream support GSO and others do not.

https://github.com/torvalds/linux/blob/3e8d3bdc2a757cc6be5470297947799a7df4=
45cc/include/linux/skbuff.h
static inline bool skb_is_gso(const struct sk_buff *skb)
{
    return skb_shinfo(skb)->gso_size;
}

Regards,
Marek

On Mon, Sep 21, 2020 at 5:09 PM Daniel Borkmann <daniel@iogearbox.net> wrot=
e:
>
> On 9/21/20 2:49 PM, Jesper Dangaard Brouer wrote:
> > On Mon, 21 Sep 2020 11:37:18 +0100
> > Lorenz Bauer <lmb@cloudflare.com> wrote:
> >> On Sat, 19 Sep 2020 at 00:06, Maciej =C5=BBenczykowski <maze@google.co=
m> wrote:
> >>>
> >>>> This is a good point.  As bpf_skb_adjust_room() can just be run afte=
r
> >>>> bpf_redirect() call, then a MTU check in bpf_redirect() actually
> >>>> doesn't make much sense.  As clever/bad BPF program can then avoid t=
he
> >>>> MTU check anyhow.  This basically means that we have to do the MTU
> >>>> check (again) on kernel side anyhow to catch such clever/bad BPF
> >>>> programs.  (And I don't like wasting cycles on doing the same check =
two
> >>>> times).
> >>>
> >>> If you get rid of the check in bpf_redirect() you might as well get
> >>> rid of *all* the checks for excessive mtu in all the helpers that
> >>> adjust packet size one way or another way.  They *all* then become
> >>> useless overhead.
> >>>
> >>> I don't like that.  There may be something the bpf program could do t=
o
> >>> react to the error condition (for example in my case, not modify
> >>> things and just let the core stack deal with things - which will
> >>> probably just generate packet too big icmp error).
> >>>
> >>> btw. right now our forwarding programs first adjust the packet size
> >>> then call bpf_redirect() and almost immediately return what it
> >>> returned.
> >>>
> >>> but this could I think easily be changed to reverse the ordering, so
> >>> we wouldn't increase packet size before the core stack was informed w=
e
> >>> would be forwarding via a different interface.
> >>
> >> We do the same, except that we also use XDP_TX when appropriate. This
> >> complicates the matter, because there is no helper call we could
> >> return an error from.
> >
> > Do notice that my MTU work is focused on TC-BPF.  For XDP-redirect the
> > MTU check is done in xdp_ok_fwd_dev() via __xdp_enqueue(), which also
> > happens too late to give BPF-prog knowledge/feedback.  For XDP_TX I
> > audited the drivers when I implemented xdp_buff.frame_sz, and they
> > handled (or I added) handling against max HW MTU. E.g. mlx5 [1].
> >
> > [1] https://elixir.bootlin.com/linux/v5.9-rc6/source/drivers/net/ethern=
et/mellanox/mlx5/core/en/xdp.c#L267
> >
> >> My preference would be to have three helpers: get MTU for a device,
> >> redirect ctx to a device (with MTU check), resize ctx (without MTU
> >> check) but that doesn't work with XDP_TX. Your idea of doing checks
> >> in redirect and adjust_room is pragmatic and seems easier to
> >> implement.
> >
> > I do like this plan/proposal (with 3 helpers), but it is not possible
> > with current API.  The main problem is the current bpf_redirect API
> > doesn't provide the ctx, so we cannot do the check in the BPF-helper.
> >
> > Are you saying we should create a new bpf_redirect API (that incl packe=
t ctx)?
>
> Sorry for jumping in late here... one thing that is not clear to me is th=
at if
> we are fully sure that skb is dropped by stack anyway due to invalid MTU =
(redirect
> to ingress does this via dev_forward_skb(), it's not fully clear to me wh=
ether it's
> also the case for the dev_queue_xmiy()), then why not dropping all the MT=
U checks
> aside from SKB_MAX_ALLOC sanity check for BPF helpers and have something =
like a
> device object (similar to e.g. TCP sockets) exposed to BPF prog where we =
can retrieve
> the object and read dev->mtu from the prog, so the BPF program could then=
 do the
> "exception" handling internally w/o extra prog needed (we also already ex=
pose whether
> skb is GSO or not).
>
> Thanks,
> Daniel
