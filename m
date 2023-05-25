Return-Path: <netdev+bounces-5476-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D9CFE7118BF
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 23:03:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 854E91C20F5F
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 21:03:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A0D724EA3;
	Thu, 25 May 2023 21:02:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0829024EA2
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 21:02:37 +0000 (UTC)
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D562E7F
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 14:02:07 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-3f6da07feb2so862105e9.0
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 14:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685048523; x=1687640523;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5yd5GFYwo+GoQGW+GVNMXRxjYmno8HbnVIFzauexIZc=;
        b=X2twgWWVzQg+lwUgwq55xOfh0kQIBJN4BRJ18oHyyUeo8xoolzRR5hAFiPBXnm3krT
         vOhp4bdwldFwtw4LSG55eb3McKyoabsd7mTF36bUvxN23GvQ6NMMa0J5FQ0pxxXexBHN
         0eg45fwf9sejBIzinztNDOd0e991FcjrgIqbXp1ULN6hAti1En1wHjI7ctr05oEkBpWD
         1eX5pm7FmsZi3SBYHjtkq6pGB1PoWUXvDu++DTWeSpKnwTw6zywy4aIyijfKpY6+KKD3
         dOTYqDZaB6sOj//pqWCcKC1c2uFxqQC8SQDEaxFwdT5iSGsFkpNgF7F4n2UMSiPMWiBL
         QV6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685048523; x=1687640523;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5yd5GFYwo+GoQGW+GVNMXRxjYmno8HbnVIFzauexIZc=;
        b=I8jn2OFyACIDPXMTd8FlB417W+RE0oNCcTTh5IOvnFBXg8IHaXC0LFhBJGYz0GsWZX
         kE+25iLM5B4jZBgu7q6hW55y2SUFZzH6hTVXxUjj0++pLazs2CjrJBPhfcf0qeLvqEWx
         lTilIO/HB7OiTCZZnSBIimW5DwJs6zt2sVVQ+Nn22KTWBBVlCYZz4dg6M9eXDju2nudc
         Q2O66S4nShBi6R8eANZ0i1uS5SPfeIAF1naGfBED19f5HR7fpqdQJjbmSoKjoOxXfYSY
         dEdn1LpAcifyRWLGWeqm4dqUm9Zp0OH5I1zm3gYj+DoxKQfo3LY+VU4LzyFcCHpwl91v
         xg+Q==
X-Gm-Message-State: AC+VfDwudk3l0VAm2yjPD+Mk71AJ+SY6YGpCwBA395oskX6jFRukeEcM
	21gQCq63hbJjERLAl8qxril6uApGJNM=
X-Google-Smtp-Source: ACHHUZ4fyQYPokE4OuNc6XBLPeKdRG4uyCo5dkD8AoS8/zMk2+dW/R3e77x+ySYEDm6DGlWYxK3SUw==
X-Received: by 2002:a05:600c:ca:b0:3f6:41d:24d2 with SMTP id u10-20020a05600c00ca00b003f6041d24d2mr2845097wmm.39.1685048523061;
        Thu, 25 May 2023 14:02:03 -0700 (PDT)
Received: from localhost (2a01cb008a61c20131edd4c7b4534bba.ipv6.abo.wanadoo.fr. [2a01:cb00:8a61:c201:31ed:d4c7:b453:4bba])
        by smtp.gmail.com with ESMTPSA id u18-20020adfed52000000b003079986fd71sm2856620wro.88.2023.05.25.14.02.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 14:02:02 -0700 (PDT)
Date: Thu, 25 May 2023 23:02:02 +0200
From: Moviuro <moviuro@gmail.com>
To: Jay Vosburgh <jay.vosburgh@canonical.com>
Cc: netdev@vger.kernel.org
Subject: Re: Secondary bond slave receiving packets when preferred is up
Message-ID: <ZG_MyiWSARvzKOeT@toxoplasmosis>
References: <ZGzGngNhahy6kGBG@toxoplasmosis>
 <17785.1684882898@famine>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <17785.1684882898@famine>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 23-05-23 16:01:38, Jay Vosburgh wrote:
> Moviuro <moviuro@gmail.com> wrote:
> 
> >Hi there,
> >
> >On 2 similar machines, some (random?) packets are received on a wireless
> >bond slave when the preferred eth interface is connected: this causes
> >local packet loss and at worst, disconnects (e.g. SSH and KDEConnect).
> >
> >My setup looks fine, inspired by the Arch wiki[0], see
> >/proc/net/bonding/bond0 below. The archlinux community has not been able
> >to help so far[1].
> >
> >Sure enough, there's some noise on the WiFi interface:
> >
> >root@149 # tcpdump -ttttnei wlp3s0 host 192.168.1.149 and not arp
> >2023-05-23 09:29:46.771535 11:11:11:11:11:74 > BB:BB:BB:BB:BB:33, ethertype IPv4 (0x0800), length 98: 192.168.1.1 > 192.168.1.149: ICMP echo request , id 64306, seq 53425, length 64
> >2023-05-23 09:36:04.710859 bb:bb:bb:bb:bb:32 > BB:BB:BB:BB:BB:33, ethertype IPv4 (0x0800), length 98: 192.168.1.111 > 192.168.1.149: ICMP echo reque st, id 1, seq 2390, length 64
> 
> 	Some amount of random traffic arriving on the inactive interface
> of an active-backup bond is expected; switches send traffic to such
> places for various reasons.  My initial guess would be that the switch's
> forwarding entry for whatever BB:BB:BB:BB:BB:33 is expired, and the
> switch flooded traffic for that destination to all ports.  As an aside,
> what is that MAC address?  The last octet (33) doesn't appear in any of
> the bond info dumps you list later for the .149 host.

Hi Jay,

BB:BB:BB:BB:BB:33 is the MAC address that was assigned to the bond:

root@149 # ip a show dev bond0 
2: bond0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether BB:BB:BB:BB:BB:33 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.149/24 metric 1024 brd 192.168.1.255 scope global dynamic bond0
       valid_lft 30639sec preferred_lft 30639sec
    inet6 [...]

Similarly

* bb:bb:bb:bb:bb:32 is that of the bond on 111
* pp:pp:pp:pp:pp:af is that of my phone (173)
* 11:11:11:11:11:74 is that of my router (1)

You write about my switch possibly flooding its ports to find the host,
but here's a capture (173 is my phone which is trying to use KDEConnect[0]):
(wireshark's "summary" of packets, captured with `tcpdump -tttnei $iface
host 192.168.1.173 and not arp`)

if   num   time            src           dst
eth  6147  18:07:13,711496 192.168.1.111 192.168.1.173 TCP 66  [TCP Keep-Alive] 43768 → 1716 [ACK] Seq=1614043844 Ack=2714768918 Win=75776 Len=0 TSval=277775293 TSecr=3246552226
wlp  13    18:07:13,790981 192.168.1.173 192.168.1.111 TCP 66  [TCP Previous segment not captured] 1716 → 43768 [ACK] Seq=2714768918 Ack=1614043845 Win=1026 Len=0 TSval=3246562426 TSecr=277642263
eth  6148  18:07:18,831498 192.168.1.111 192.168.1.173 TCP 66  [TCP Keep-Alive] 43768 → 1716 [ACK] Seq=1614043844 Ack=2714768918 Win=75776 Len=0 TSval=277780413 TSecr=3246552226
wlp  14    18:07:18,837907 192.168.1.173 192.168.1.111 TCP 66  [TCP Dup ACK 13#1] 1716 → 43768 [ACK] Seq=2714768918 Ack=1614043845 Win=1026 Len=0 TSval=3246567474 TSecr=277642263
eth  6149  18:07:23,951497 192.168.1.111 192.168.1.173 TCP 66  [TCP Keep-Alive] 43768 → 1716 [ACK] Seq=1614043844 Ack=2714768918 Win=75776 Len=0 TSval=277785533 TSecr=3246552226
wlp  15    18:07:23,968739 192.168.1.173 192.168.1.111 TCP 66  [TCP Dup ACK 13#2] 1716 → 43768 [ACK] Seq=2714768918 Ack=1614043845 Win=1026 Len=0 TSval=3246572602 TSecr=277642263
eth  6150  18:11:02,898406 192.168.1.173 192.168.1.111 TLSv1.2 220 Application Data
eth  6151  18:11:02,902377 192.168.1.111 192.168.1.173 TCP 54  43768 → 1716 [RST] Seq=1614043845 Win=0 Len=0

There are a few packets (13..15) that only appear on the wifi capture,
there are no similar packets on the eth capture, ending with a RST
instead.

I can share the full captures with you if needed.

> 	In any event, an inactive bond interface will pass incoming
> traffic in two cases:
> 
> 	1) its destination MAC address is in the link local reserved
> range, 01:80:c2:00:00:0?, which is used for things like Spanning Tree or
> LACP; the complete list can be found at
> 
> https://standards.ieee.org/products-programs/regauth/grpmac/public/
> 
> 	These should not be ARP or IP, and this is unlikely to be your
> situation.
> 
> 	2) Something is bound directly to the bond interface itself via
> a raw socket or the like; an example of this is LLDP, which needs to
> exchange protocol frames at the interface level.

I had to look it up, but nothing running on my own machines as far as I
can tell.

root@111 # tcpdump -i wlp5s0 ether proto 0x88cc
19:01:01.309306 LLDP, length 129: U6Piano
19:01:31.277979 LLDP, length 129: U6Piano
[...]
root@111 # tcpdump -i enp4s0 ether proto 0x88cc
19:12:42.796503 LLDP, length 93: USW-24-PoE
19:13:12.798349 LLDP, length 93: USW-24-PoE
[...]
root@111 # tcpdump -i bond0 ether proto 0x88cc
19:13:12.798349 LLDP, length 93: USW-24-PoE
19:13:42.800450 LLDP, length 93: USW-24-PoE
[...]

# cat /proc/net/raw
  sl  local_address rem_address   st tx_queue rx_queue tr tm->when retrnsmt   uid  timeout inode ref pointer drops

> 	Even if the bond accepted some IP traffic on the inactive
> interface and sent it up the stack, any reply should go back out the
> active interface.  This is based on the lack of failovers in the bond
> status stuff, and presuming that the routing table on .111 and .149 is
> what I'd expect (basically, a default route and subnet route for
> 192.168.1.0/24 that go through the bond only).

Indeed, nothing weird:

root@149 # ip ro show
default via 192.168.1.1 dev bond0 proto dhcp src 192.168.1.149 metric 1024 
192.168.1.0/24 dev bond0 proto kernel scope link src 192.168.1.149 metric 1024 
192.168.1.1 dev bond0 proto dhcp scope link src 192.168.1.149 metric 1024

root@111 # ip ro show
default via 192.168.1.1 dev bond0 proto dhcp src 192.168.1.111 metric 1024 
10.5.0.0/24 dev wg0 proto kernel scope link src 10.5.0.35 
10.10.10.0/24 via 10.5.0.1 dev wg0 proto static onlink 
10.10.20.0/24 via 10.5.0.1 dev wg0 proto static onlink 
10.10.30.0/24 via 10.5.0.1 dev wg0 proto static onlink 
10.10.40.0/24 via 10.5.0.1 dev wg0 proto static onlink 
192.168.1.0/24 dev bond0 proto kernel scope link src 192.168.1.111 metric 1024 
192.168.1.1 dev bond0 proto dhcp scope link src 192.168.1.111 metric 1024

> 	Some suggestions that might help:
> 
> 	1) Check rp_filter; if it's not enabled, then turn it on in
> strict mode.  This means insuring that the sysctls for .all, the bond
> and its interfaces are all set to 1, e.g.,
> 
> net.ipv4.conf.all.rp_filter = 1
> net.ipv4.conf.bond0.rp_filter = 1
> net.ipv4.conf.wlp5s0.rp_filter = 1
> [... and so on ...]
> 
> 	Setting any of them to 2 will enable loose mode (the maximum
> value between .all and the interface is what counts).  Loose mode, or
> rp_filter being off entirely, might be your problem if your routing is
> not simple (e.g., you've got other IP networks that you didn't
> describe).  The docs for this can be found at
> 
> https://docs.kernel.org/networking/ip-sysctl.html

After a few changes:

root@111 # sysctl -a|grep '\.rp_filter'
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.bond0.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.enp4s0.rp_filter = 1
net.ipv4.conf.lo.rp_filter = 2
net.ipv4.conf.wg0.rp_filter = 1
net.ipv4.conf.wlp5s0.rp_filter = 1

But tcpdump(8) still shows some traffic on the wifi interface (see
above).

> 	2) Enable the bonding option fail_over_mac = follow, this will
> cause the MAC of the bond interfaces to not be all set to the same MAC.
> If somehow the switch is getting confused by seeing the same MAC from
> multiple ports, this may help.

This change caused the failover to not work.

root@149 # cat /proc/net/bonding/bond0
Ethernet Channel Bonding Driver: v6.3.2-zen1-1.1-zen

Bonding Mode: fault-tolerance (active-backup) (fail_over_mac follow)
[...]

# journalctl
[...]
May 24 12:00:35 houndsditch systemd-networkd[276]: enp0s31f6: Lost carrier
May 24 12:00:36 houndsditch kernel: bond0: (slave enp0s31f6): link status definitely down, disabling slave
May 24 12:00:36 houndsditch kernel: bond0: (slave wlp3s0): making interface the new active one
May 24 12:00:36 houndsditch kernel: bond0: (slave wlp3s0): Error 16 setting MAC of new active slave
[...]

After that, networking stays down. The router doesn't see any DHCP
requests, the machine is unable to reach the network.

Same if I tried to unplug replug the eth interface:

May 24 14:21:31 houndsditch systemd-networkd[271]: enp0s31f6: Lost carrier
May 24 14:21:31 houndsditch kernel: e1000e 0000:00:1f.6 enp0s31f6: NIC Link is Down
May 24 14:21:31 houndsditch kernel: bond0: (slave enp0s31f6): link status definitely down, disabling slave
May 24 14:21:31 houndsditch kernel: bond0: (slave wlp3s0): making interface the new active one
May 24 14:21:31 houndsditch kernel: bond0: (slave wlp3s0): Error 16 setting MAC of new active slave
May 24 14:21:40 houndsditch kernel: e1000e 0000:00:1f.6 enp0s31f6: NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
May 24 14:21:40 houndsditch systemd-networkd[271]: enp0s31f6: Gained carrier
May 24 14:21:41 houndsditch kernel: bond0: (slave enp0s31f6): link status definitely up, 1000 Mbps full duplex
May 24 14:21:41 houndsditch kernel: bond0: (slave enp0s31f6): making interface the new active one
May 24 14:21:41 houndsditch kernel: bond0: (slave wlp3s0): Error 16 setting MAC of old active slave
May 24 14:21:41 houndsditch sshfs[1013]: Timeout, server 192.168.1.100 not responding.

However, that change (fail_over_mac follow) made it so that unifi (the
software config util for my switch and WAPs[1]) was no longer confused
about where in the topology the machine was. With fail_over_mac=follow,
149 was properly shown as connected to a port on the switch instead of
connected by WiFi to the WAP (which is also somewhat correct?).

I have a limited shell access to my WAP and switch, maybe I'd have to
look in there?

[0] https://kdeconnect.kde.org/ ; https://github.com/bboozzoo/mconnect
[1] https://community.ui.com/releases/UniFi-Network-Application-7-3-83/88f5ff3f-4c13-45e2-b57e-ad04b4140528;
also https://ui.com/consoles

