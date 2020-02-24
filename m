Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46DB316B3CC
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 23:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbgBXWXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 17:23:03 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:33988 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbgBXWXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 17:23:03 -0500
Received: by mail-yb1-f194.google.com with SMTP id u47so5453432ybi.1
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 14:23:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iIizJAEddYE5v2sRf7GK1m99egmUw1JIn0Bcjp91PV4=;
        b=OO0BIgOyMX6u0FWjNR04H+ROmegaW4ctwdstMEDamEI8u5ZW9lr8B8ps9XTHmNQWMm
         QZPw9guviba7sZsZoV5oSIUzmyztDGhVTrQiwYUe4Wg4mWUI5WRJ++YGBIHa1U+aGqee
         QGDQyTYFzemFM1GhfhzLW1uYFAd5spj36Ad2ViMf2Tjv6MRy4BBgLtKI9v7NUZj6cO2f
         XyhLn1YKMjAp3XlZVg6BqqrDonQR6TK5swVL+nr31U6MM7xAqjYpHCV6lCn0L6y7N8JN
         dyHPOBbobLB0rCyzfofj3n9R9LcfBRcWTi5yexgeSA/9ILM6QabFUQUNKuQt4bu9UjuI
         WW6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iIizJAEddYE5v2sRf7GK1m99egmUw1JIn0Bcjp91PV4=;
        b=OdlUNb0cmmCaQbPrNUjJ1fuu/hDweEbcw4bILKhTay5LgbfXn8ujMcqkKA+/CQ2228
         oWGszV0WRpVV0jxc1woHzAFpL9VHCJGvqztLzkEGuDsWpW2Ta5w4aFpzs6GhIA4huknS
         EMyrYX6ELGqHr8fvXVHxnvYyOJc+2/SoRK/9O3uq0lTnSPpz5CkgqRWVvQC/9zUNvxHE
         KmpbhpkHLLA0aL9Ixzb3R+mapFN7E+IL3XdCX6L79fmnIb9mqMa6U2n14tqjbE3RUiq2
         KOw9TRhRxDxTAtork4xWQnuhd/O6vY6+gi3/iz8XbXQCzUjQnLYMDU75p7tE9YdI+aeO
         klkg==
X-Gm-Message-State: APjAAAWdtOE15gXMjzw5K3Z7A5MXIsls/JTHWihEv4kWScWUK0xfRp+e
        zcAsJ75FPCwOrJ/R41VUsRqW4/ZF
X-Google-Smtp-Source: APXvYqwvIe+fxdlsLc6xizslOmu6bVAX6CdtEkCsvpSkWrgXhRZmQ2znGPaPnQxxvDmxY3lBpp3zLg==
X-Received: by 2002:a25:cc8a:: with SMTP id l132mr9273214ybf.178.1582582979805;
        Mon, 24 Feb 2020 14:22:59 -0800 (PST)
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com. [209.85.219.170])
        by smtp.gmail.com with ESMTPSA id p6sm5626662ywi.63.2020.02.24.14.22.59
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 14:22:59 -0800 (PST)
Received: by mail-yb1-f170.google.com with SMTP id u26so5445023ybd.3
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 14:22:59 -0800 (PST)
X-Received: by 2002:a25:1042:: with SMTP id 63mr47817640ybq.165.1582582977755;
 Mon, 24 Feb 2020 14:22:57 -0800 (PST)
MIME-Version: 1.0
References: <20200224132550.2083-1-anton.ivanov@cambridgegreys.com>
 <CA+FuTSd8P6uQnwisZEh7+nfowW9qKLBEvA4GPg+xUkjBa-6TDA@mail.gmail.com>
 <4e7757cf-148e-4585-b358-3b38f391275d@cambridgegreys.com> <CA+FuTSdOCJZCVS4xohx+BQmkmq8JALnK=gGc0=qy1TbjY707ag@mail.gmail.com>
 <93cb2b3f-6cae-8cf1-5fab-93fa34c14628@cambridgegreys.com>
In-Reply-To: <93cb2b3f-6cae-8cf1-5fab-93fa34c14628@cambridgegreys.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 24 Feb 2020 17:22:21 -0500
X-Gmail-Original-Message-ID: <CA+FuTScEXRwYtFzn-jtFhV0dNKNQqKPBwCWaNORJW=ERU=izMA@mail.gmail.com>
Message-ID: <CA+FuTScEXRwYtFzn-jtFhV0dNKNQqKPBwCWaNORJW=ERU=izMA@mail.gmail.com>
Subject: Re: [PATCH v3] virtio: Work around frames incorrectly marked as gso
To:     Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        linux-um@lists.infradead.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 24, 2020 at 4:00 PM Anton Ivanov
<anton.ivanov@cambridgegreys.com> wrote:
>
> On 24/02/2020 20:20, Willem de Bruijn wrote:
> > On Mon, Feb 24, 2020 at 2:55 PM Anton Ivanov
> > <anton.ivanov@cambridgegreys.com> wrote:
> >> On 24/02/2020 19:27, Willem de Bruijn wrote:
> >>> On Mon, Feb 24, 2020 at 8:26 AM <anton.ivanov@cambridgegreys.com> wrote:
> >>>> From: Anton Ivanov <anton.ivanov@cambridgegreys.com>
> >>>>
> >>>> Some of the locally generated frames marked as GSO which
> >>>> arrive at virtio_net_hdr_from_skb() have no GSO_TYPE, no
> >>>> fragments (data_len = 0) and length significantly shorter
> >>>> than the MTU (752 in my experiments).
> >>> Do we understand how these packets are generated?
> >> No, we have not been able to trace them.
> >>
> >> The only thing we know is that this is specific to locally generated
> >> packets. Something arriving from the network does not show this.
> >>
> >>> Else it seems this
> >>> might be papering over a deeper problem.
> >>>
> >>> The stack should not create GSO packets less than or equal to
> >>> skb_shinfo(skb)->gso_size. See for instance the check in
> >>> tcp_gso_segment after pulling the tcp header:
> >>>
> >>>           mss = skb_shinfo(skb)->gso_size;
> >>>           if (unlikely(skb->len <= mss))
> >>>                   goto out;
> >>>
> >>> What is the gso_type, and does it include SKB_GSO_DODGY?
> >>>
> >>
> >> 0 - not set.
> > Thanks for the follow-up details. Is this something that you can trigger easily?
>
> Yes, if you have a UML instance handy.
>
> Running iperf between the host and a UML guest using raw socket
> transport triggers it immediately.
>
> This is my UML command line:
>
> vmlinux mem=2048M umid=OPX \
>      ubd0=OPX-3.0-Work.img \
> vec0:transport=raw,ifname=p-veth0,depth=128,gro=1,mac=92:9b:36:5e:38:69 \
>      root=/dev/ubda ro con=null con0=null,fd:2 con1=fd:0,fd:1
>
> p-right is a part of a vEth pair:
>
> ip link add l-veth0 type veth peer name p-veth0 && ifconfig p-veth0 up
>
> iperf server is on host, iperf -c in the guest.
>
> >
> > An skb_dump() + dump_stack() when the packet socket gets such a
> > packet may point us to the root cause and fix that.
>
> We tried dump stack, it was not informative - it was just the recvmmsg
> call stack coming from the UML until it hits the relevant recv bit in
> af_packet - it does not tell us where the packet is coming from.
>
> Quoting from the message earlier in the thread:
>
> [ 2334.180854] Call Trace:
> [ 2334.181947]  dump_stack+0x5c/0x80
> [ 2334.183021]  packet_recvmsg.cold+0x23/0x49
> [ 2334.184063]  ___sys_recvmsg+0xe1/0x1f0
> [ 2334.185034]  ? packet_poll+0xca/0x130
> [ 2334.186014]  ? sock_poll+0x77/0xb0
> [ 2334.186977]  ? ep_item_poll.isra.0+0x3f/0xb0
> [ 2334.187936]  ? ep_send_events_proc+0xf1/0x240
> [ 2334.188901]  ? dequeue_signal+0xdb/0x180
> [ 2334.189848]  do_recvmmsg+0xc8/0x2d0
> [ 2334.190728]  ? ep_poll+0x8c/0x470
> [ 2334.191581]  __sys_recvmmsg+0x108/0x150
> [ 2334.192441]  __x64_sys_recvmmsg+0x25/0x30
> [ 2334.193346]  do_syscall_64+0x53/0x140
> [ 2334.194262]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

That makes sense. skb_dump might show more interesting details about
the packet. From the previous thread, these are assumed to be TCP
packets?

I had missed the original thread. If the packet has

    sinfo(skb)->gso_size = 752.
    skb->len = 818

then this is a GSO packet. Even though UML will correctly process it
as a normal 818 B packet if psock_rcv pretends that it is, treating it
like that is not strictly correct. A related question is how the setup
arrived at that low MTU size, assuming that is not explicitly
configured that low.

As of commit 51466a7545b7 ("tcp: fill shinfo->gso_type at last
moment") tcp unconditionally sets gso_type, even for non gso packets.
So either this is not a tcp packet or the field gets zeroed somewhere
along the way. I could not quickly find a possible path to
skb_gso_reset or a raw write.

It may be useful to insert tests for this condition (skb_is_gso(skb)
&& !skb_shinfo(skb)->gso_type) that call skb_dump at other points in
the network stack. For instance in __ip_queue_xmit and
__dev_queue_xmit.

Since skb segmentation fails in tcp_gso_segment for such packets, it
may also be informative to disable TSO on the veth device and see if
the test fails.
