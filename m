Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A280716EB62
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 17:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730645AbgBYQ0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 11:26:43 -0500
Received: from mail-yw1-f41.google.com ([209.85.161.41]:39948 "EHLO
        mail-yw1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728065AbgBYQ0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 11:26:42 -0500
Received: by mail-yw1-f41.google.com with SMTP id i126so8391592ywe.7
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 08:26:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rL2KupnlYqJ2dvd/WydzRlF4ALj76HqAWQrRaiCSOiA=;
        b=OKvDPG0T/NdpGDbvKbWDtJm0WyckOwd2BNKQxvPehlONKdHAS9y54/AIfcBwfKY/S9
         kjpCOyRFb1IrGZ4sGYB2FK1WWHR/zsSJFLdSOTyuoQHB2uLJPddwkp26inIXC4IY8VQs
         anpoZBQpyOBqIBEQK88k4GqzrqcQGFJpER9MU2SyI+HDpfIqSboVH9xlOW0qn6ZI/1x4
         sL8f7HxQcF7Qtr8FEpHipb2RrxWy5LioHME0vpOrhthFA+0l0Y4ndCxnW35u1lrcDmGP
         /t+zNU67eCDcBwyXTt8zcXMeHduBCtboNFnsV9vnJc6LUmnwjQJsVBQkBaX48ebDRAKf
         uHvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rL2KupnlYqJ2dvd/WydzRlF4ALj76HqAWQrRaiCSOiA=;
        b=e8jsdb1fvWnhk03UrD6PwuoA2Z77MwmgTlJ6Y0E7NVdDwf/q0DsflIkrcKi8pFjHGn
         fK98HC4+aw9AN4sENyTpJS5mA5f5K/BxmngbKnAtaTLo/N//CUCz15oHWbpLfGfEm/2r
         38jBKtmPQg/X8Wq3jw707MYoWp7+8a62S3VVayVmYaCamgi+4Gas+6NeH6KpGEOezBHR
         Pe7lg1Joagtu4aNLpsW/SFb7Mn8Dkjxn8bgFVZtlc1PpKDjbEbH+BgL0Vxt47XcJw0Kc
         powIeteGK2fAdPR/iAmoKWhaXg8IUDZHCTurL930Ep2RVkohxGWjAYOo4HCAkQ7+MDnx
         ceeA==
X-Gm-Message-State: APjAAAUH1c2VHn3UG6NeJtrnvu3TMFMMDmQ3xzoKiahDQ9iLrtoFaTnF
        cFFD6nY48zM7vm8qx6xh2VtFSzq2
X-Google-Smtp-Source: APXvYqw/Zt6UYHojcGGElY0Cm9cWO6XCDYwW8m1tBg2gFgtUCcAxGxRybdu/4Msimj/yAN82GMviCg==
X-Received: by 2002:a25:238f:: with SMTP id j137mr87248ybj.115.1582648000292;
        Tue, 25 Feb 2020 08:26:40 -0800 (PST)
Received: from mail-yw1-f48.google.com (mail-yw1-f48.google.com. [209.85.161.48])
        by smtp.gmail.com with ESMTPSA id w132sm6479176ywc.51.2020.02.25.08.26.39
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 08:26:39 -0800 (PST)
Received: by mail-yw1-f48.google.com with SMTP id 192so8414604ywy.0
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 08:26:39 -0800 (PST)
X-Received: by 2002:a0d:dfc5:: with SMTP id i188mr48138488ywe.172.1582647998463;
 Tue, 25 Feb 2020 08:26:38 -0800 (PST)
MIME-Version: 1.0
References: <20200224132550.2083-1-anton.ivanov@cambridgegreys.com>
 <CA+FuTSd8P6uQnwisZEh7+nfowW9qKLBEvA4GPg+xUkjBa-6TDA@mail.gmail.com>
 <4e7757cf-148e-4585-b358-3b38f391275d@cambridgegreys.com> <CA+FuTSdOCJZCVS4xohx+BQmkmq8JALnK=gGc0=qy1TbjY707ag@mail.gmail.com>
 <93cb2b3f-6cae-8cf1-5fab-93fa34c14628@cambridgegreys.com> <CA+FuTScEXRwYtFzn-jtFhV0dNKNQqKPBwCWaNORJW=ERU=izMA@mail.gmail.com>
 <6b83116c-2cca-fb03-1c13-bb436dccf1b3@cambridgegreys.com> <cd1b4084-af6b-7fd9-f182-8b32a3c8d837@cambridgegreys.com>
In-Reply-To: <cd1b4084-af6b-7fd9-f182-8b32a3c8d837@cambridgegreys.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 25 Feb 2020 11:26:01 -0500
X-Gmail-Original-Message-ID: <CA+FuTSebC064cZXTz_n7jXLrtAcuXxp2N_jiAdi3v2=A6fBBJw@mail.gmail.com>
Message-ID: <CA+FuTSebC064cZXTz_n7jXLrtAcuXxp2N_jiAdi3v2=A6fBBJw@mail.gmail.com>
Subject: Re: [PATCH v3] virtio: Work around frames incorrectly marked as gso
To:     Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>, linux-um@lists.infradead.org,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >>>> An skb_dump() + dump_stack() when the packet socket gets such a
> >>>> packet may point us to the root cause and fix that.
> >>>
> >>> We tried dump stack, it was not informative - it was just the recvmmsg
> >>> call stack coming from the UML until it hits the relevant recv bit in
> >>> af_packet - it does not tell us where the packet is coming from.
> >>>
> >>> Quoting from the message earlier in the thread:
> >>>
> >>> [ 2334.180854] Call Trace:
> >>> [ 2334.181947]  dump_stack+0x5c/0x80
> >>> [ 2334.183021]  packet_recvmsg.cold+0x23/0x49
> >>> [ 2334.184063]  ___sys_recvmsg+0xe1/0x1f0
> >>> [ 2334.185034]  ? packet_poll+0xca/0x130
> >>> [ 2334.186014]  ? sock_poll+0x77/0xb0
> >>> [ 2334.186977]  ? ep_item_poll.isra.0+0x3f/0xb0
> >>> [ 2334.187936]  ? ep_send_events_proc+0xf1/0x240
> >>> [ 2334.188901]  ? dequeue_signal+0xdb/0x180
> >>> [ 2334.189848]  do_recvmmsg+0xc8/0x2d0
> >>> [ 2334.190728]  ? ep_poll+0x8c/0x470
> >>> [ 2334.191581]  __sys_recvmmsg+0x108/0x150
> >>> [ 2334.192441]  __x64_sys_recvmmsg+0x25/0x30
> >>> [ 2334.193346]  do_syscall_64+0x53/0x140
> >>> [ 2334.194262]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >>
> >> That makes sense. skb_dump might show more interesting details about
> >> the packet.
> >
> > I will add that and retest later today.
>
>
> skb len=818 headroom=2 headlen=818 tailroom=908
> mac=(2,14) net=(16,0) trans=16
> shinfo(txflags=0 nr_frags=0 gso(size=752 type=0 segs=1))
> csum(0x100024 ip_summed=3 complete_sw=0 valid=0 level=0)
> hash(0x0 sw=0 l4=0) proto=0x0800 pkttype=4 iif=0
> sk family=17 type=3 proto=0
>
> Deciphering the actual packet data gives a
>
> TCP packet, ACK and PSH set.
>
> The PSH flag looks like the only "interesting" thing about it in first read.

Thanks.

TCP always sets the PSH bit on a GSO packet as of commit commit
051ba67447de  ("tcp: force a PSH flag on TSO packets"), so that is
definitely informative.

The lower gso size might come from a path mtu probing depending on
tcp_base_mss, but that's definitely wild speculation. Increasing that
value to, say, 1024, could tell us.

In this case it may indeed not be a GSO packet. As 752 is the MSS + 28
B TCP header including timestamp + 20 B IPv4 header + 14B Eth header.
Which adds up to 814 already.

Not sure what those 2 B between skb->data and mac_header are. Was this
captured inside packet_rcv? network_header and transport_header both
at 16B offset is also sketchy, but again may be an artifact of where
exactly this is being read.

Perhaps this is a segment of a larger GSO packet that is retransmitted
in part. Like an mtu probe or loss probe. See for instance this in
tcp_send_loss_probe for  how a single MSS is extracted:

       if ((pcount > 1) && (skb->len > (pcount - 1) * mss)) {
                if (unlikely(tcp_fragment(sk, TCP_FRAG_IN_RTX_QUEUE, skb,
                                          (pcount - 1) * mss, mss,
                                          GFP_ATOMIC)))
                        goto rearm_timer;
                skb = skb_rb_next(skb);
        }

Note that I'm not implicating this specific code. I don't see anything
wrong with it. Just an indication that a trace would be very
informative, as it could tell if any of these edge cases is being hit.
