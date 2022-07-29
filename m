Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC5C58496C
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 03:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232955AbiG2Brl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 21:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231720AbiG2Brk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 21:47:40 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 268484B4A9
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 18:47:39 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id p81so2721552iod.2
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 18:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:cc;
        bh=2LQXwx2QU2PHblGt7gCTFMwcqHDgNfVSq/p5tjvOjAs=;
        b=WL6myvceW1bTDYESCvNBi1RAnHTxn126WOLBKyP4KaqKiRDvzV4gXto9C7YsfMi3cQ
         ajQoQQDl62rqXd02DjUxTj1JwjYG3KjqW5xISTI3ZnGACpLsy3EEGuCZZzO+aMBQu74Y
         vFEWHT6chwKusL5N3x3D0yAtfsBjcYy/m4mzOfaEQKWHaF6hdamnytYHR8aTrUq5N7FI
         OXsmGkAsaCDRN4Auq2ceb9LYZTn2fFC3CBnVCanvCIJ47jK4bSZm5jnYnjYZRKy3ZOmq
         jksX/ihuHKns9CH6R18zAr63YvP46gWjJxpbfK4tGlm3PtQaRcAvMKPj1yeuTNmeoBU6
         SOtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:cc;
        bh=2LQXwx2QU2PHblGt7gCTFMwcqHDgNfVSq/p5tjvOjAs=;
        b=eY9C0VbGBOpMc3WsSXfcf77aF1p8RGa3hPkDPfJydnGK+nPMjoDuSdl+itL5FgO+Yo
         gBGmOtf9FdvIZYYstYZwxgLyk0JqR0I5qy797y1ZEUew7d+5BJ3ZDJlgDRQTYZ7L+pWn
         C/x8Yr8jikDZvQIC8OYS+/H4lSg/cPD5RLlE6iyq7mcD0PS9Mao5Rj/wxEFIylGckQgx
         pFQA3AQBzZCwQwyHkPKIGFxmpqUF+8MGoHwFDbywIYfQ1twNxf5lCLJhPAvSiwHNnS4X
         BjymNlf+kkR1JC/GGUIE8je0p1TX3zdeLoaCYomHTIRUlXy6b7VQ0EL0Wtw649i47zmL
         KwyQ==
X-Gm-Message-State: AJIora852OeqmbRGMaV8mP7tL+ne88B3at7QMunZZYvUHiNjg23F1VoK
        rei6QGJGCb6brZoeORq2stQ8LjmS2BHhJnxeiMg=
X-Received: by 2002:a02:cbcd:0:b0:33f:6f8c:f4a6 with SMTP id
 u13-20020a02cbcd000000b0033f6f8cf4a6mt541453jaq.300.1659059258330; Thu, 28
 Jul 2022 18:47:38 -0700 (PDT)
MIME-Version: 1.0
References: <CAFZh4h-JVWt80CrQWkFji7tZJahMfOToUJQgKS5s0_=9zzpvYQ@mail.gmail.com>
 <fd16ebb3-2435-ef01-d9f1-b873c9c0b389@gmail.com> <CAFZh4h-FJHha_uo--jHQU3w4AWh2k3+D6Lrz=ce5sbu3=BmTTw@mail.gmail.com>
 <20220727233249.fpn7gyivnkdg5uhe@skbuf> <CAFZh4h-w739Xq6x13PpFvCFX=dCD571k1bdMyfk1Wvtkk_vvCw@mail.gmail.com>
 <CAFZh4h-3AaoQwJcaQoYc_e=yrR7a6d7Qr77R8o56mtbFye_0cw@mail.gmail.com>
 <20220728222927.rc7yfkwinqoiec3w@skbuf> <CAFZh4h9i2e6Mvnnh0Go7Z3CZqRWVKVfBtAGbi05tYKBLqfig5Q@mail.gmail.com>
In-Reply-To: <CAFZh4h9i2e6Mvnnh0Go7Z3CZqRWVKVfBtAGbi05tYKBLqfig5Q@mail.gmail.com>
From:   Brian Hutchinson <b.hutchman@gmail.com>
Date:   Thu, 28 Jul 2022 21:47:27 -0400
Message-ID: <CAFZh4h81LUsSB37LxzfxMBvewd8aW47SgjTt3=G-hO-ZYa5vkg@mail.gmail.com>
Subject: Re: Bonded multicast traffic causing packet loss when using DSA with
 Microchip KSZ9567 switch
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        andrew@lunn.ch, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,MISSING_HEADERS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 28, 2022 at 9:11 PM Brian Hutchinson <b.hutchman@gmail.com> wrote:
>
> Hi Vladimir,
>
> On Thu, Jul 28, 2022 at 6:29 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > Hi Brian,
> >
> > On Thu, Jul 28, 2022 at 03:14:17PM -0400, Brian Hutchinson wrote:
> > > > So I mentioned in a recent PM that I was looking at other vendor DSA
> > > > drivers and I see code that smells like some of the concerns you have.
> > > >
> > > > I did some grepping on /drivers/net/dsa and while I get hits for
> > > > things like 'flood', 'multicast', 'igmp' etc. in marvel and broadcom
> > > > drivers ... I get nothing on microchip.  Hardware documentation has
> > > > whole section on ingress and egress rate limiting and shaping but
> > > > doesn't look like drivers use any of it.
> > > >
> > > > Example:
> > > >
> > > > /drivers/net/dsa/mv88e6xxx$ grep -i multicast *.c
> > > > chip.c: { "in_multicasts",              4, 0x07, STATS_TYPE_BANK0, },
> > > > chip.c: { "out_multicasts",             4, 0x12, STATS_TYPE_BANK0, },
> > > > chip.c:                  is_multicast_ether_addr(addr))
> > > > chip.c: /* Upstream ports flood frames with unknown unicast or multicast DA */
> > > > chip.c:  * forwarding of unknown unicasts and multicasts.
> > > > chip.c:         dev_err(ds->dev, "p%d: failed to load multicast MAC address\n",
> > > > chip.c:                                  bool unicast, bool multicast)
> > > > chip.c:                                                       multicast);
> > > > global2.c:      /* Consider the frames with reserved multicast destination
> > > > global2.c:      /* Consider the frames with reserved multicast destination
> > > > port.c:                              bool unicast, bool multicast)
> > > > port.c: if (unicast && multicast)
> > > > port.c: else if (multicast)
> > > > port.c:                                       int port, bool multicast)
> > > > port.c: if (multicast)
> > > > port.c:                              bool unicast, bool multicast)
> > > > port.c: return mv88e6185_port_set_default_for
> > > > ward(chip, port, multicast);
> > > >
> > > > Wondering if some needed support is missing.
> >
> > I know it's tempting to look at other drivers and think "whoah, how much
> > code these guys have! and I went for the cheaper switch!", but here it
> > really does not matter in the slightest.
> >
> > Your application, as far as I understand it, requires the KSZ switch to
> > operate as a simple port multiplexer, with no hardware offloading of
> > packet processing (essentially all ports operate as what we call
> > 'standalone'). It's quite sad that this mode didn't work with the KSZ
> > driver. But what you're looking at, 'multicast', 'igmp', things like
> > that, only matter if you instruct the switch to forward packets in
> > hardware, trap packets for control protocols, things like that.
> > Not applicable.
>
> Our use case in this instance is basically to use the two ports
> exposed by hardware as NICs (standalone) bonded together for
> redundancy ... and doing 1588 and 1PPS.
>
> It's kinda funny, our hardware guy worked with Microchip before we
> spun a board and they said get this switch.  Later they told us we
> picked the wrong switch ha, ha.  This was before I got involved ...
> but we have another board that uses it too as just a dumb switch so
> that influenced things I think ... or I probably would of suggested a
> different one.
>
> >
> > > > Will try your patch and report back.
> > >
> > > I applied Vladimir's patch (had to edit it to change ksz9477.c to
> > > ksz9477_main.c) ;)
> > >
> > > I did the same steps as before but ran multicast iperf a bit longer as
> > > I wasn't noticing packet loss this time.  I also fat fingered options
> > > on first iperf run so if you focus on the number of datagrams iperf
> > > sent below, the RX counts won't match that.
> > >
> > > On PC ran: iperf -s -u -B 239.0.0.67%enp4s0 -i 1
> > > On my board I ran: iperf -B 192.168.1.6 -c 239.0.0.67 -u --ttl 5 -t
> > > 3600 -b 1M -i 1 (I noticed I had a copy/paste error in previous email
> > > ... no I didn't use a -ttl of 3000!!!).  Again I didn't let iperf run
> > > for 3600 sec., ctrl-c it early.
> > >
> > > Pings from external PC to board while iperf multicast test was going
> > > on resulted in zero dropped packets.
> >
> > Can you please reword this so that I can understand beyond any doubt
> > that you're saying that the patch has fixed the problem?
>
> Sure, let me try again.  Prior to Vladimir's patch, I noticed that
> running our application, which uses multicast sockets or LinuxPTP
> (ptp4l) would cause packet loss only when lan2 was connected.  Didn't
> experience packet loss if we had just lan1 connected ... or stopped
> our application and ptp4l.  I watched wireshark and noticed only
> difference in traffic pattern was multicast.  The did iperf tests to
> see if it was truly a multicast issue or a loading issue.  I could run
> iperf with multicast packets and pretty much cause 100% packet loss.
>
> After applying Vladimir's patch to turn off STP, the same iperf test

I don't know why I said STP, I meant port address learning, which
defaulted to 'enabled'.

I was talking earlier about also having to turn off STP on smart
switches so I guess I still had that on the brain.


> with multicast packets didn't experience any packet loss.  It works
> like a champ.  You're the greatest!  How's that?
>
> >
> > > .
> > > .
> > > .
> > > 64 bytes from 192.168.1.6: icmp_seq=98 ttl=64 time=1.94 ms
> > > 64 bytes from 192.168.1.6: icmp_seq=99 ttl=64 time=1.91 ms
> > > 64 bytes from 192.168.1.6: icmp_seq=100 ttl=64 time=0.713 ms
> > > 64 bytes from 192.168.1.6: icmp_seq=101 ttl=64 time=1.95 ms
> > > 64 bytes from 192.168.1.6: icmp_seq=102 ttl=64 time=1.26 ms
> > > ^C
> > > --- 192.168.1.6 ping statistics ---
> > > 102 packets transmitted, 102 received, 0% packet loss, time 101265ms
> > > rtt min/avg/max/mdev = 0.253/1.451/2.372/0.414 ms
> > >
> > > ... I also noticed that the board's ping time greatly improved too.
> > > I've noticed ping times are usually over 2ms and I'm not sure why or
> > > what to do about it.
> >
> > So they're usually over 2 ms now, or were before? I see 1.95 ms, that's
> > not too far.
>
> So "before" patch pings in earlier post looks like avg time of 2.054ms
> and "after" patch test looks like avg time of 1.451ms so that got my
> attention.  I guess more stuff is rattling around inside this switch.
>
> >
> > I think "rteval" / "cyclictest" / "perf" are the kind of tools you need
> > to look at, if you want to improve this RTT.
>
> Indeed.  I have Ftrace/trace-cmd and LTTng working.
>
> >
> > > iperf on board sent 9901 datagrams:
> > >
> > > .
> > > .
> > > .
> > > [  3] 108.0-109.0 sec   128 KBytes  1.05 Mbits/sec
> > > [  3] 109.0-110.0 sec   129 KBytes  1.06 Mbits/sec
> > > [  3] 110.0-111.0 sec   128 KBytes  1.05 Mbits/sec
> > > ^C[  3]  0.0-111.0 sec  13.9 MBytes  1.05 Mbits/sec
> > > [  3] Sent 9901 datagrams
> > >
> > > ethtool statistics:
> > >
> > > ethtool -S eth0 | grep -v ': 0'
> > > NIC statistics:
> > >     tx_packets: 32713
> > >     tx_broadcast: 2
> > >     tx_multicast: 32041
> > >     tx_65to127byte: 719
> > >     tx_128to255byte: 30
> > >     tx_1024to2047byte: 31964
> > >     tx_octets: 48598874
> > >     IEEE_tx_frame_ok: 32713
> > >     IEEE_tx_octets_ok: 48598874
> > >     rx_packets: 33260
> > >     rx_broadcast: 378
> > >     rx_multicast: 32209
> > >     rx_65to127byte: 1140
> > >     rx_128to255byte: 136
> > >     rx_256to511byte: 20
> > >     rx_1024to2047byte: 31964
> > >     rx_octets: 48624055
> > >     IEEE_rx_frame_ok: 33260
> > >     IEEE_rx_octets_ok: 48624055
> > >     p06_rx_bcast: 2
> > >     p06_rx_mcast: 32041
> > >     p06_rx_ucast: 670
> > >     p06_rx_65_127: 719
> > >     p06_rx_128_255: 30
> > >     p06_rx_1024_1522: 31964
> > >     p06_tx_bcast: 378
> > >     p06_tx_mcast: 32209
> > >     p06_tx_ucast: 673
> > >     p06_rx_total: 48598874
> > >     p06_tx_total: 48624055
> >
> > (unrelated: the octet counts reported by the FEC match those of the KSZ switch; I'm impressed)
> >
>
> Always a plus!
>
> > > # ethtool -S lan1 | grep -v ': 0'
> > > NIC statistics:
> > >     tx_packets: 32711
> > >     tx_bytes: 48401459
> > >     rx_packets: 1011
> > >     rx_bytes: 84159
> > >     rx_bcast: 207
> > >     rx_mcast: 111
> > >     rx_ucast: 697
> > >     rx_64_or_less: 234
> > >     rx_65_127: 699
> > >     rx_128_255: 70
> > >     rx_256_511: 12
> > >     tx_bcast: 2
> > >     tx_mcast: 32015
> > >     tx_ucast: 694
> > >     rx_total: 103241
> > >     tx_total: 48532849
> > >     rx_discards: 4
> > >
> > > # ethtool -S lan2 | grep -v ': 0'
> > > NIC statistics:
> > >     rx_packets: 32325
> > >     rx_bytes: 47915110
> > >     rx_bcast: 209
> > >     rx_mcast: 32120
> > >     rx_64_or_less: 212
> > >     rx_65_127: 55
> > >     rx_128_255: 86
> > >     rx_256_511: 12
> > >     rx_1024_1522: 31964
> > >     rx_total: 48497844
> > >     rx_discards: 4
> >
> > Still 4 rx_discards here and on lan1. Not sure exactly when those
> > packets were discarded, or what those were.
> >
> > Generally what I do to observe this kind of thing is to run
> > watch -n 1 "ethtool -S lan1 | grep -v ': 0'"
> >
> > and see what actually increments, in real time.
> >
> > It would be helpful if you could definitely say that those drops were
> > there even prior to you running the test (packets received by MAC while
> > port was down?), or if we need to look further into the problem there.
> >
>
> I'll do some more tests.  I'll commit it and run our application with
> it and see if we are still getting packet loss.
>
> > > ifconfig stats: (2 dropped packets on lan2.  Last time lan1 and lan2
> > > about roughly same RX counts, this time lan1 significantly less)
> >
> > I've no idea where the 'dropped' packets as reported by ifconfig come
> > from. I'm almost certain it's not from DSA.
>
> Thanks everyone!  Thank you again Vladimir.
>
> Sorry I hosed up and posted html to the list once and got bounced.  I
> was out of the office and trying to respond from my phone.
>
> I'll keep testing and report back again after we get more stick time.
>
> Regards,
>
> Brian
