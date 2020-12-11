Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD7B2D8150
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 22:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406440AbgLKVws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 16:52:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391893AbgLKVwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 16:52:13 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01579C0613CF;
        Fri, 11 Dec 2020 13:51:13 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id b8so10138895ila.13;
        Fri, 11 Dec 2020 13:51:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2qTMCUhI0/YQewF/VCItkzyJf+kYlqXC/vL1LYH/k5U=;
        b=dDjJSvtLvuPChscPzyykjt7oV+4SFcMZTb7XeGwm0A+zISNUv62r2+uxjZVEojFVGE
         rDJxX8r7nyJQ+HOnMrOxvP96myLBn7KeTf8pKYsEjHJC+vwZkUdDlp33AezFLEIYpoey
         FDZSwg/hM0tnK+hoJOSKe1/Da5zFQSq1zwSwokSa18Yp1NPr66RtUNXyMREgXg+pFmcB
         WVmJwde5mYI/dJUDhSOuQLDY2bbcA4cd9fTmquVBMRgBQnai6KaogjDlbmrDi3YnEP++
         BTcncwBTXBq2fepO1ENQBKavvAtQscUFaSiQXR2rVmfKWMQoegJI+ts616EQJjH1e14r
         k43A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2qTMCUhI0/YQewF/VCItkzyJf+kYlqXC/vL1LYH/k5U=;
        b=RRmrvDRP9dRxKaGYRUI+WUYQW5ahgBfmr3uXiju2xtJkYJmC44kswZ+7dYN9YdjhLj
         JZwGeuGVZeGZlVhcicp6JCwQ/sbx0VSy6ZfCrz5SxdmTk+entk0BT+iO90fdto25y4yE
         k3EzRyGFd2Dp+uwSIlzvM7TgG/u5pRVwYkxccigLl2bD+DL0s0jxVdn+Al3aJYQZ1s7A
         o2qSUN6gR0llMAVzcFNzwL68XRqKVvluWnJUYbmzrzSTV4xMElIj6qF1H5LfSSkniJtK
         2z8RjmsHBSOMq0a6wMmJ0apNACvU/mlp3Ll5ay6O7KP9tYD/m3FvbCM7iCW0lGAv+Ezz
         SJ4g==
X-Gm-Message-State: AOAM531Yo9dIjLBM6Apzmk5szCbVefr0e5ujn2v28/MlkDal7HoWli5K
        B6bQ1xif82EjmsB+JR5aJJ0dxY2su0h1fXblfNw=
X-Google-Smtp-Source: ABdhPJwCtGSKUc/EOu8Tu0NYIKLY7+P8Ti3Qxg2wE8EctsXLINDw0dlf+mmrwpLaz+UKRYBz3JV/o45IAKg7w1Oewqg=
X-Received: by 2002:a92:730d:: with SMTP id o13mr17783084ilc.95.1607723472280;
 Fri, 11 Dec 2020 13:51:12 -0800 (PST)
MIME-Version: 1.0
References: <160765171921.6905.7897898635812579754.stgit@localhost.localdomain>
 <CANn89iJ5HnJYv6eWb1jm6rK173DFkp2GRnfvi9vnYwXZPzE4LQ@mail.gmail.com>
 <CAKgT0Uf_q=FgMHd9_wq5Bx8rCC-kS0Qz563rE9dL2hpQ6Evppg@mail.gmail.com>
 <CANn89iJUT6aWm75ZpU_Ggmuqbb+cbLSGj0Bxysu9_wXRgNS8MQ@mail.gmail.com>
 <CAKgT0Uecuh3mcGRpDAZzzbnQtOusc++H4SXAv2Scd297Ha5AYQ@mail.gmail.com> <CANn89iKfqKpXgCv_Z4iSt5RpjxYUvkYSoZKF3FZs+Jgev3aDgw@mail.gmail.com>
In-Reply-To: <CANn89iKfqKpXgCv_Z4iSt5RpjxYUvkYSoZKF3FZs+Jgev3aDgw@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 11 Dec 2020 13:51:01 -0800
Message-ID: <CAKgT0Uc6gVOL5VWpsD54WiAvop9WQEudNsJNh9=Fr9PunJevWw@mail.gmail.com>
Subject: Re: [net PATCH] tcp: Mark fastopen SYN packet as lost when receiving ICMP_TOOBIG/ICMP_FRAG_NEEDED
To:     Eric Dumazet <edumazet@google.com>
Cc:     Yuchung Cheng <ycheng@google.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        kernel-team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 11:18 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Fri, Dec 11, 2020 at 6:15 PM Alexander Duyck
> <alexander.duyck@gmail.com> wrote:
> >
> > On Fri, Dec 11, 2020 at 8:22 AM Eric Dumazet <edumazet@google.com> wrote:
> > >
> > > On Fri, Dec 11, 2020 at 5:03 PM Alexander Duyck
> > > <alexander.duyck@gmail.com> wrote:
> > >
> > > > That's fine. I can target this for net-next. I had just selected net
> > > > since I had considered it a fix, but I suppose it could be considered
> > > > a behavioral change.
> > >
> > > We are very late in the 5.10 cycle, and we never handled ICMP in this
> > > state, so net-next is definitely better.
> > >
> > > Note that RFC 7413 states in 4.1.3 :
> > >
> > >  The client MUST cache cookies from servers for later Fast Open
> > >    connections.  For a multihomed client, the cookies are dependent on
> > >    the client and server IP addresses.  Hence, the client should cache
> > >    at most one (most recently received) cookie per client and server IP
> > >    address pair.
> > >
> > >    When caching cookies, we recommend that the client also cache the
> > >    Maximum Segment Size (MSS) advertised by the server.  The client can
> > >    cache the MSS advertised by the server in order to determine the
> > >    maximum amount of data that the client can fit in the SYN packet in
> > >    subsequent TFO connections.  Caching the server MSS is useful
> > >    because, with Fast Open, a client sends data in the SYN packet before
> > >    the server announces its MSS in the SYN-ACK packet.  If the client
> > >    sends more data in the SYN packet than the server will accept, this
> > >    will likely require the client to retransmit some or all of the data.
> > >    Hence, caching the server MSS can enhance performance.
> > >
> > >    Without a cached server MSS, the amount of data in the SYN packet is
> > >    limited to the default MSS of 536 bytes for IPv4 [RFC1122] and 1220
> > >    bytes for IPv6 [RFC2460].  Even if the client complies with this
> > >    limit when sending the SYN, it is known that an IPv4 receiver
> > >    advertising an MSS less than 536 bytes can receive a segment larger
> > >    than it is expecting.
> > >
> > >    If the cached MSS is larger than the typical size (1460 bytes for
> > >    IPv4 or 1440 bytes for IPv6), then the excess data in the SYN packet
> > >    may cause problems that offset the performance benefit of Fast Open.
> > >    For example, the unusually large SYN may trigger IP fragmentation and
> > >    may confuse firewalls or middleboxes, causing SYN retransmission and
> > >    other side effects.  Therefore, the client MAY limit the cached MSS
> > >    to 1460 bytes for IPv4 or 1440 for IPv6.
> > >
> > >
> > > Relying on ICMP is fragile, since they can be filtered in some way.
> >
> > In this case I am not relying on the ICMP, but thought that since I
> > have it I should make use of it. WIthout the ICMP we would still just
> > be waiting on the retransmit timer.
> >
> > The problem case has a v6-in-v6 tunnel between the client and the
> > endpoint so both ends assume an MTU 1500 and advertise a 1440 MSS
> > which works fine until they actually go to send a large packet between
> > the two. At that point the tunnel is triggering an ICMP_TOOBIG and the
> > endpoint is stalling since the MSS is dropped to 1400, but the SYN and
> > data payload were already smaller than that so no retransmits are
> > being triggered. This results in TFO being 1s slower than non-TFO
> > because of the failure to trigger the retransmit for the frame that
> > violated the PMTU. The patch is meant to get the two back into
> > comparable times.
>
> Okay... Have you studied why tcp_v4_mtu_reduced() (and IPv6 equivalent)
> code does not yet handle the retransmit in TCP_SYN_SENT state ?

The problem lies in tcp_simple_retransmit(). Specifically the loop at
the start of the function goes to check the retransmit queue to see if
there are any packets larger than MSS and finds none since we don't
place the SYN w/ data in there and instead have a separate SYN and
data packet.

I'm debating if I should take an alternative approach and modify the
loop at the start of tcp_simple_transmit to add a check for a SYN
packet, tp->syn_data being set, and then comparing the next frame
length + MAX_TCP_HEADER_OPTIONS versus mss.
