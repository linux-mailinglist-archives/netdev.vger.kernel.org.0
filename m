Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F61C58468D
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 21:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232721AbiG1TOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 15:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232465AbiG1TOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 15:14:31 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086A5691E2
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 12:14:30 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id o2so2099902iof.8
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 12:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mijN5A0yD2VsRSwGSCB3FzYP/zwj3UuehxyGWBcXqx0=;
        b=JjmKe3AcZDVVNKE58RN9cL7SZ5UO+cMl4+w/SsXrlnfqY37/r4Pw0CNad00DqM/LZU
         0ISXL5kCAl6WfyXoyJ2AQfLNhp+emxnlH2nKgkWw5qKozTyzPnoHmbEnOQMPsEGinF2H
         9Kq999MVGUz5ZMD1loJ5Vt2zZIjaMHdgF5MqVqY6cYCryHhsR/2A7cOo3jp6aQ1oDi5e
         7LcyCgadwCMbYbKMKAvfCI+4buAB95hg3moPH1wvXiqgHUV8eBTVS0Ueng6m+r1Gk6lz
         wlvCqO1un6Fe1rN1x9kLRXfT4taq7i8ljBNp5kWkAHnfDcQSkPwlDcSj/YwEzmCLEk33
         MTEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mijN5A0yD2VsRSwGSCB3FzYP/zwj3UuehxyGWBcXqx0=;
        b=dQ34u3w/qCciUb6ZJLyTMxL17pA+lyGPCTHDDDqvoXA3aAYortUKAA8MZCo/K0YZW2
         UiZ6lXxTrcAl5hw8cOEVyVAqQdB+qpZ1V3v6NYUxb9Lyi1YCWesLkIF+SZCaReRSN0W2
         v5FwzZ6zFDAGyO3hEXYM8oXCeqilycX+5WQhXt/XJd+kAQXmiFBfJFpmdFVJIftZvaGT
         vpt6o8np1rFAGXyhtw6Dc6KtvRpjd6Qxous65fBz1H9aUqHzA2MRGOgeJTTHO1PlYzTN
         2KqHRp8c3Qf5/7R38BskNmtGPV5pUzEeze5/Kq+H2OInDyuTb/6yZ/aUKoRPYhTx1tEV
         CunA==
X-Gm-Message-State: AJIora+kqWL3qfLSr5bd8O/S9YrMpuX/5BnUBZsPsG9NcbElehq7ydA2
        122mjm2w1kV6aNbNRxHlexekEd0al6qJl9midV8=
X-Google-Smtp-Source: AGRyM1ucBJvX3MhYA8CgnElSRJNqDjfsmqDCQmyt/D2zqAq+gL2jwkkyLfrisgWfU1MFXUEedqJSBHJC/TckXo7wlcw=
X-Received: by 2002:a05:6638:2a9:b0:33f:2d29:7546 with SMTP id
 d9-20020a05663802a900b0033f2d297546mr104189jaq.27.1659035669033; Thu, 28 Jul
 2022 12:14:29 -0700 (PDT)
MIME-Version: 1.0
References: <CAFZh4h-JVWt80CrQWkFji7tZJahMfOToUJQgKS5s0_=9zzpvYQ@mail.gmail.com>
 <fd16ebb3-2435-ef01-d9f1-b873c9c0b389@gmail.com> <CAFZh4h-FJHha_uo--jHQU3w4AWh2k3+D6Lrz=ce5sbu3=BmTTw@mail.gmail.com>
 <20220727233249.fpn7gyivnkdg5uhe@skbuf> <CAFZh4h-w739Xq6x13PpFvCFX=dCD571k1bdMyfk1Wvtkk_vvCw@mail.gmail.com>
In-Reply-To: <CAFZh4h-w739Xq6x13PpFvCFX=dCD571k1bdMyfk1Wvtkk_vvCw@mail.gmail.com>
From:   Brian Hutchinson <b.hutchman@gmail.com>
Date:   Thu, 28 Jul 2022 15:14:17 -0400
Message-ID: <CAFZh4h-3AaoQwJcaQoYc_e=yrR7a6d7Qr77R8o56mtbFye_0cw@mail.gmail.com>
Subject: Re: Bonded multicast traffic causing packet loss when using DSA with
 Microchip KSZ9567 switch
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        andrew@lunn.ch, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello netdev,

On Thu, Jul 28, 2022 at 10:45 AM Brian Hutchinson <b.hutchman@gmail.com> wrote:
>
> Hi Vladimir,
>
> On Wed, Jul 27, 2022 at 7:32 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> > > bond1: flags=5187<UP,BROADCAST,RUNNING,MASTER,MULTICAST>  mtu 1500  metric 1
> > >        inet 192.168.1.6  netmask 255.255.255.0  broadcast 0.0.0.0
> > >        inet6 fd1c:a799:6054:0:60e2:5ff:fe75:6716  prefixlen 64  scopeid 0x0<global>
> > >        inet6 fe80::60e2:5ff:fe75:6716  prefixlen 64  scopeid 0x20<link>
> > >        ether 62:e2:05:75:67:16  txqueuelen 1000  (Ethernet)
> >
> > I see bond1, lan1 and lan2 all have the same MAC address (62:e2:05:75:67:16).
> > Does this happen even when they are all different?
>
> So I have (when bond is setup using Systemd) assigned unique MAC
> addresses for eth0, lan1 and lan2 ... but default action of bonding is
> to assign the bond (bond1) and the slaves (lan1, lan2) a MAC that is
> all the same among all the interfaces.  There are settings (controlled
> by fail_over_mac) to specify which MAC is chosen to seed the MAC of
> the other interfaces but bottom line is bonding makes both the bond
> and active slave at a minimum the same MAC.
>
> >
> > >        RX packets 2557  bytes 3317974 (3.1 MiB)
> > >        RX errors 0  dropped 2  overruns 0  frame 0
> > >        TX packets 2370  bytes 3338160 (3.1 MiB)
> > >        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
> > >
> > > eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1506  metric 1
> > >        inet6 fe80::f21f:afff:fe6b:b218  prefixlen 64  scopeid 0x20<link>
> > >        ether f0:1f:af:6b:b2:18  txqueuelen 1000  (Ethernet)
> > >        RX packets 2557  bytes 3371671 (3.2 MiB)
> > >        RX errors 0  dropped 0  overruns 0  frame 0
> > >        TX packets 2394  bytes 3345891 (3.1 MiB)
> > >        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
> > >
> > > lan1: flags=6211<UP,BROADCAST,RUNNING,SLAVE,MULTICAST>  mtu 1500  metric 1
> > >        ether 62:e2:05:75:67:16  txqueuelen 1000  (Ethernet)
> > >        RX packets 248  bytes 19384 (18.9 KiB)
> > >        RX errors 0  dropped 0  overruns 0  frame 0
> > >        TX packets 2370  bytes 3338160 (3.1 MiB)
> > >        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
> > >
> > > lan2: flags=6211<UP,BROADCAST,RUNNING,SLAVE,MULTICAST>  mtu 1500  metric 1
> > >        ether 62:e2:05:75:67:16  txqueuelen 1000  (Ethernet)
> > >        RX packets 2309  bytes 3298590 (3.1 MiB)
> > >        RX errors 0  dropped 1  overruns 0  frame 0
> >
> > I find this extremely strange. AFAIK, ifconfig reads stats from /proc/net/dev,
> > which in turn takes them from the driver using dev_get_stats():
> > https://elixir.bootlin.com/linux/v5.10.69/source/net/core/net-procfs.c#L78
> >
> > But DSA didn't even report the "dropped" count via ndo_get_stats64 in 5.10...
> > https://elixir.bootlin.com/linux/v5.10.69/source/net/dsa/slave.c#L1257
> >
> > I have no idea why this shows 1. I'll have to ignore this information
> > for now.
> >
> .
> .
> .
> >
> > Would you mind trying to test the exact same scenario again with the
> > patch attached? (also pasted below in plain text) Still the same MAC
> > address for all interfaces for now.
>
> No problem at all.  I'm stumped too and welcome ideas to figure out
> what is going on.
>
> >
> > From 033e3a8650a498de73cd202375b2e3f843e9a376 Mon Sep 17 00:00:00 2001
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > Date: Thu, 28 Jul 2022 02:07:08 +0300
> > Subject: [PATCH] ksz9477: force-disable address learning
> >
> > I suspect that what Brian Hutchinson experiences with the rx_discards
> > counter incrementing is due to his setup, where 2 external switches
> > connect together 2 bonded KSZ9567 switch ports, in such a way that one
> > KSZ port is able to see packets sent by the other (this is probably
> > aggravated by the multicast sent at a high data rate, which is treated
> > as broadcast by the external switches and flooded).
>
> So I mentioned in a recent PM that I was looking at other vendor DSA
> drivers and I see code that smells like some of the concerns you have.
>
> I did some grepping on /drivers/net/dsa and while I get hits for
> things like 'flood', 'multicast', 'igmp' etc. in marvel and broadcom
> drivers ... I get nothing on microchip.  Hardware documentation has
> whole section on ingress and egress rate limiting and shaping but
> doesn't look like drivers use any of it.
>
> Example:
>
> /drivers/net/dsa/mv88e6xxx$ grep -i multicast *.c
> chip.c: { "in_multicasts",              4, 0x07, STATS_TYPE_BANK0, },
> chip.c: { "out_multicasts",             4, 0x12, STATS_TYPE_BANK0, },
> chip.c:                  is_multicast_ether_addr(addr))
> chip.c: /* Upstream ports flood frames with unknown unicast or multicast DA */
> chip.c:  * forwarding of unknown unicasts and multicasts.
> chip.c:         dev_err(ds->dev, "p%d: failed to load multicast MAC address\n",
> chip.c:                                  bool unicast, bool multicast)
> chip.c:                                                       multicast);
> global2.c:      /* Consider the frames with reserved multicast destination
> global2.c:      /* Consider the frames with reserved multicast destination
> port.c:                              bool unicast, bool multicast)
> port.c: if (unicast && multicast)
> port.c: else if (multicast)
> port.c:                                       int port, bool multicast)
> port.c: if (multicast)
> port.c:                              bool unicast, bool multicast)
> port.c: return mv88e6185_port_set_default_for
> ward(chip, port, multicast);
>
> Wondering if some needed support is missing.
>
> Will try your patch and report back.

I applied Vladimir's patch (had to edit it to change ksz9477.c to
ksz9477_main.c) ;)

I did the same steps as before but ran multicast iperf a bit longer as
I wasn't noticing packet loss this time.  I also fat fingered options
on first iperf run so if you focus on the number of datagrams iperf
sent below, the RX counts won't match that.

On PC ran: iperf -s -u -B 239.0.0.67%enp4s0 -i 1
On my board I ran: iperf -B 192.168.1.6 -c 239.0.0.67 -u --ttl 5 -t
3600 -b 1M -i 1 (I noticed I had a copy/paste error in previous email
... no I didn't use a -ttl of 3000!!!).  Again I didn't let iperf run
for 3600 sec., ctrl-c it early.

Pings from external PC to board while iperf multicast test was going
on resulted in zero dropped packets.

.
.
.
64 bytes from 192.168.1.6: icmp_seq=98 ttl=64 time=1.94 ms
64 bytes from 192.168.1.6: icmp_seq=99 ttl=64 time=1.91 ms
64 bytes from 192.168.1.6: icmp_seq=100 ttl=64 time=0.713 ms
64 bytes from 192.168.1.6: icmp_seq=101 ttl=64 time=1.95 ms
64 bytes from 192.168.1.6: icmp_seq=102 ttl=64 time=1.26 ms
^C
--- 192.168.1.6 ping statistics ---
102 packets transmitted, 102 received, 0% packet loss, time 101265ms
rtt min/avg/max/mdev = 0.253/1.451/2.372/0.414 ms

... I also noticed that the board's ping time greatly improved too.
I've noticed ping times are usually over 2ms and I'm not sure why or
what to do about it.

iperf on board sent 9901 datagrams:

.
.
.
[  3] 108.0-109.0 sec   128 KBytes  1.05 Mbits/sec
[  3] 109.0-110.0 sec   129 KBytes  1.06 Mbits/sec
[  3] 110.0-111.0 sec   128 KBytes  1.05 Mbits/sec
^C[  3]  0.0-111.0 sec  13.9 MBytes  1.05 Mbits/sec
[  3] Sent 9901 datagrams

ethtool statistics:

ethtool -S eth0 | grep -v ': 0'
NIC statistics:
    tx_packets: 32713
    tx_broadcast: 2
    tx_multicast: 32041
    tx_65to127byte: 719
    tx_128to255byte: 30
    tx_1024to2047byte: 31964
    tx_octets: 48598874
    IEEE_tx_frame_ok: 32713
    IEEE_tx_octets_ok: 48598874
    rx_packets: 33260
    rx_broadcast: 378
    rx_multicast: 32209
    rx_65to127byte: 1140
    rx_128to255byte: 136
    rx_256to511byte: 20
    rx_1024to2047byte: 31964
    rx_octets: 48624055
    IEEE_rx_frame_ok: 33260
    IEEE_rx_octets_ok: 48624055
    p06_rx_bcast: 2
    p06_rx_mcast: 32041
    p06_rx_ucast: 670
    p06_rx_65_127: 719
    p06_rx_128_255: 30
    p06_rx_1024_1522: 31964
    p06_tx_bcast: 378
    p06_tx_mcast: 32209
    p06_tx_ucast: 673
    p06_rx_total: 48598874
    p06_tx_total: 48624055

# ethtool -S lan1 | grep -v ': 0'
NIC statistics:
    tx_packets: 32711
    tx_bytes: 48401459
    rx_packets: 1011
    rx_bytes: 84159
    rx_bcast: 207
    rx_mcast: 111
    rx_ucast: 697
    rx_64_or_less: 234
    rx_65_127: 699
    rx_128_255: 70
    rx_256_511: 12
    tx_bcast: 2
    tx_mcast: 32015
    tx_ucast: 694
    rx_total: 103241
    tx_total: 48532849
    rx_discards: 4

# ethtool -S lan2 | grep -v ': 0'
NIC statistics:
    rx_packets: 32325
    rx_bytes: 47915110
    rx_bcast: 209
    rx_mcast: 32120
    rx_64_or_less: 212
    rx_65_127: 55
    rx_128_255: 86
    rx_256_511: 12
    rx_1024_1522: 31964
    rx_total: 48497844
    rx_discards: 4

ifconfig stats: (2 dropped packets on lan2.  Last time lan1 and lan2
about roughly same RX counts, this time lan1 significantly less)

# ifconfig
bond1: flags=5187<UP,BROADCAST,RUNNING,MASTER,MULTICAST>  mtu 1500  metric 1
       inet 192.168.1.6  netmask 255.255.255.0  broadcast 0.0.0.0
       inet6 fd1c:a799:6054:0:60e2:5ff:fe75:6716  prefixlen 64
scopeid 0x0<global>
       inet6 fe80::60e2:5ff:fe75:6716  prefixlen 64  scopeid 0x20<link>
       ether 62:e2:05:75:67:16  txqueuelen 1000  (Ethernet)
       RX packets 33392  bytes 48003505 (45.7 MiB)
       RX errors 0  dropped 4  overruns 0  frame 0
       TX packets 32723  bytes 48402583 (46.1 MiB)
       TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1506  metric 1
       inet6 fe80::f21f:afff:fe6b:b218  prefixlen 64  scopeid 0x20<link>
       ether f0:1f:af:6b:b2:18  txqueuelen 1000  (Ethernet)
       RX packets 33392  bytes 48704737 (46.4 MiB)
       RX errors 0  dropped 0  overruns 0  frame 0
       TX packets 32749  bytes 48471466 (46.2 MiB)
       TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lan1: flags=6211<UP,BROADCAST,RUNNING,SLAVE,MULTICAST>  mtu 1500  metric 1
       ether 62:e2:05:75:67:16  txqueuelen 1000  (Ethernet)
       RX packets 1045  bytes 86755 (84.7 KiB)
       RX errors 0  dropped 0  overruns 0  frame 0
       TX packets 32723  bytes 48402583 (46.1 MiB)
       TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lan2: flags=6211<UP,BROADCAST,RUNNING,SLAVE,MULTICAST>  mtu 1500  metric 1
       ether 62:e2:05:75:67:16  txqueuelen 1000  (Ethernet)
       RX packets 32347  bytes 47916750 (45.6 MiB)
       RX errors 0  dropped 2  overruns 0  frame 0
       TX packets 0  bytes 0 (0.0 B)
       TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536  metric 1
       inet 127.0.0.1  netmask 255.0.0.0
       inet6 ::1  prefixlen 128  scopeid 0x10<host>
       loop  txqueuelen 1000  (Local Loopback)
       RX packets 0  bytes 0 (0.0 B)
       RX errors 0  dropped 0  overruns 0  frame 0
       TX packets 0  bytes 0 (0.0 B)
       TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0



# cat /proc/net/bonding/bond1
Ethernet Channel Bonding Driver: v5.10.69-g472c99a84cb6-dirty

Bonding Mode: fault-tolerance (active-backup)
Primary Slave: None
Currently Active Slave: lan1
MII Status: up
MII Polling Interval (ms): 1000
Up Delay (ms): 0
Down Delay (ms): 0
Peer Notification Delay (ms): 0

Slave Interface: lan1
MII Status: up
Speed: 1000 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: f0:1f:af:6b:b2:18
Slave queue ID: 0

Slave Interface: lan2
MII Status: up
Speed: 1000 Mbps
Duplex: full
Link Failure Count: 1
Permanent HW addr: f0:1f:af:6b:b2:18
Slave queue ID: 0

*Note:  I did unplug lan2 interface before I ran test which is why
lan2 Link Failure Count is 1.

Regards,

Brian
