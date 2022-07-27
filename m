Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5E95835A5
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 01:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbiG0Xc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 19:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbiG0Xcz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 19:32:55 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E49550B3
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 16:32:53 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id bp15so300515ejb.6
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 16:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3mX4GI9ltxPNf45qbR5ksxNfHcMpmRrdaU0qnvWRmXc=;
        b=hb5d1L6+QVjfsFqjDk9SQCovzvmzy1PnrVFSulTTb+4V17iFRn97uMrxIVIiYFV5EF
         PIZZiG6eJKQO9cUzBEe9lasHIYhHzpf3/nxOuFNDcAjbCP7l8TJHaxGflrtkkPtuDpsD
         Do1IQCYfKftNjhDcFAsfjCJ1lsc90Ub2MU9gIlg+M/Ic3UIGOLfMCQufT5vjqoOmlwLb
         ZUGyLabeUMyavu1gjzvhvflud+9sSTS+vJXKIpMTQzXeclvVcYC3otoqMYBd5dJoPZoD
         GuLBkPYDYfqbe88MVqRp+1Uhj5GzkNMjoiQjryS07gERULi+HuF7t3oSUx3aaEFokRqV
         q5Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3mX4GI9ltxPNf45qbR5ksxNfHcMpmRrdaU0qnvWRmXc=;
        b=u0+kgZoMDswd3EqUHDlvjZmSsPrOjj5suFcsaLcoe7qMkIk7+5jdi78of1kPK70brp
         J+ybgi5ky3YbTU1lS4bwxvB+a8eJJxO/OtZqe6sGRZZO8SCcZzb6JvpKbUg0rUoj5hqc
         DFABoe65ew2fPWQyjDAsuNqK9qF+HTZ0dwVxTk1x+ovsFlvHZ1d/XKJrTcB62zC4yWyF
         whjnuiP9ZueSyVTNZGnzO7PfrdVEPmC2mm+uRXErsbzQHsZoZha7pfqZFzxfU+ygGqBz
         9B54hVqDmSS6FaXev2F+lyWmg01nH7bKeznXFvsvwal3volndcNZGtJojkYOyowA/APL
         M14g==
X-Gm-Message-State: AJIora/8hhziryRm4L7VuHUE2RLAELHJlqVcE+uK0ucGy95MncNsE3CF
        lHYSdZ9Lm7tcjQKhv6oCHSg=
X-Google-Smtp-Source: AGRyM1uVu+95vidHWLcbXuDHfFN5pZTHYcLKE4eNW9sw1jpzy0cn5k11lBRegkYRMoS/S6qt2Gm+bQ==
X-Received: by 2002:a17:906:9b0a:b0:72b:4fc2:4b07 with SMTP id eo10-20020a1709069b0a00b0072b4fc24b07mr19991230ejc.700.1658964772218;
        Wed, 27 Jul 2022 16:32:52 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id k20-20020a17090632d400b0072f32a84e75sm8084701ejk.110.2022.07.27.16.32.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 16:32:51 -0700 (PDT)
Date:   Thu, 28 Jul 2022 02:32:49 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Brian Hutchinson <b.hutchman@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        andrew@lunn.ch, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org
Subject: Re: Bonded multicast traffic causing packet loss when using DSA with
 Microchip KSZ9567 switch
Message-ID: <20220727233249.fpn7gyivnkdg5uhe@skbuf>
References: <CAFZh4h-JVWt80CrQWkFji7tZJahMfOToUJQgKS5s0_=9zzpvYQ@mail.gmail.com>
 <fd16ebb3-2435-ef01-d9f1-b873c9c0b389@gmail.com>
 <CAFZh4h-FJHha_uo--jHQU3w4AWh2k3+D6Lrz=ce5sbu3=BmTTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="55ommv3cfdwu3hlp"
Content-Disposition: inline
In-Reply-To: <CAFZh4h-FJHha_uo--jHQU3w4AWh2k3+D6Lrz=ce5sbu3=BmTTw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--55ommv3cfdwu3hlp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Brian,

On Wed, Jul 27, 2022 at 08:37:55AM -0400, Brian Hutchinson wrote:
> As requested, statistics below:
> 
> I power cycled my board, ran my script to setup active-backup bond and
> repeated the iperf test to obtain requested statistics.
> 
> Bond setup script basically does:
> 
> # Load bonding kernel module
> modprobe bonding
> 
> # Bring up CPU interface (cpu to switch port 7 - the RGMII link)
> ip link set eth0 up
> 
> # Create a bond
> echo +bond1 > /sys/class/net/bonding_masters
> 
> # Set mode to active-backup (redundancy failover)
> echo active-backup > /sys/class/net/bond1/bonding/mode
> 
> # Set time it takes (in ms) for slave to move when a link goes down
> echo 1000 > /sys/class/net/bond1/bonding/miimon
> 
> # Add slaves to bond
> 
> echo +lan1 > /sys/class/net/bond1/bonding/slaves
> echo +lan2 > /sys/class/net/bond1/bonding/slaves
> 
> # Set IP and netmask of the bond
> ip addr add 192.168.1.6/24 dev bond1
> 
> # And bring bond up.  Pings and network connectivity should work now
> ip link set bond1 up
> 
> Things I noticed in the data:
> 
> 1.  I'm getting rx_discards which in Microchip data sheet are called
> RxDropPackets
> which are defined as "RX packets dropped due to lack of resources."  I
> don't know what that means or how to fix it.
> 2. ifconfig stats show dropped counts for bond1 and lan2 interface.
> 3. lan1 was active interface during the test.
> 
> On PC I run iperf -s -u -B 239.0.0.67%enp4s0 -i 1
> On my board I run iperf -B 192.168.1.6 -c 239.0.0.67 -u --ttl 3000 -t 30 -b
> 1M -i 1 (didn't let it run the full time, stopped it with ctrl-c)
> 
> Ping from PC to board while iperf is running on my board shows packet loss:
> 
> ping 192.168.1.6
> PING 192.168.1.6 (192.168.1.6) 56(84) bytes of data.
> 64 bytes from 192.168.1.6: icmp_seq=9 ttl=64 time=2.33 ms
> 64 bytes from 192.168.1.6: icmp_seq=35 ttl=64 time=4.53 ms
> 64 bytes from 192.168.1.6: icmp_seq=36 ttl=64 time=2.03 ms
> 64 bytes from 192.168.1.6: icmp_seq=37 ttl=64 time=2.01 ms
> 64 bytes from 192.168.1.6: icmp_seq=38 ttl=64 time=1.99 ms
> 64 bytes from 192.168.1.6: icmp_seq=39 ttl=64 time=2.00 ms
> 64 bytes from 192.168.1.6: icmp_seq=40 ttl=64 time=1.29 ms
> 64 bytes from 192.168.1.6: icmp_seq=41 ttl=64 time=2.05 ms
> 64 bytes from 192.168.1.6: icmp_seq=42 ttl=64 time=1.98 ms
> 64 bytes from 192.168.1.6: icmp_seq=43 ttl=64 time=1.98 ms
> 64 bytes from 192.168.1.6: icmp_seq=44 ttl=64 time=1.95 ms
> 64 bytes from 192.168.1.6: icmp_seq=45 ttl=64 time=2.00 ms
> 64 bytes from 192.168.1.6: icmp_seq=46 ttl=64 time=2.03 ms
> 64 bytes from 192.168.1.6: icmp_seq=47 ttl=64 time=1.95 ms
> 64 bytes from 192.168.1.6: icmp_seq=48 ttl=64 time=1.95 ms
> 64 bytes from 192.168.1.6: icmp_seq=49 ttl=64 time=1.96 ms
> 64 bytes from 192.168.1.6: icmp_seq=50 ttl=64 time=2.00 ms
> 64 bytes from 192.168.1.6: icmp_seq=51 ttl=64 time=2.00 ms
> 64 bytes from 192.168.1.6: icmp_seq=52 ttl=64 time=1.97 ms
> 64 bytes from 192.168.1.6: icmp_seq=53 ttl=64 time=1.96 ms
> 64 bytes from 192.168.1.6: icmp_seq=54 ttl=64 time=1.97 ms
> 64 bytes from 192.168.1.6: icmp_seq=55 ttl=64 time=2.03 ms
> 64 bytes from 192.168.1.6: icmp_seq=56 ttl=64 time=1.29 ms
> 64 bytes from 192.168.1.6: icmp_seq=57 ttl=64 time=2.04 ms
> ^C
> --- 192.168.1.6 ping statistics ---
> 57 packets transmitted, 24 received, 57.8947% packet loss, time 56807ms
> rtt min/avg/max/mdev = 1.285/2.054/4.532/0.558 ms
> 
> Board stats for eth0, lan1 and lan2:
> 
> # ethtool -S eth0 | grep -v ': 0'
> NIC statistics:
>     tx_packets: 2382
>     tx_broadcast: 4
>     tx_multicast: 2269
>     tx_65to127byte: 156
>     tx_128to255byte: 30
>     tx_1024to2047byte: 2196
>     tx_octets: 3354271
>     IEEE_tx_frame_ok: 2382
>     IEEE_tx_octets_ok: 3354271
>     rx_packets: 2435
>     rx_broadcast: 76
>     rx_multicast: 2250
>     rx_65to127byte: 222
>     rx_128to255byte: 17
>     rx_1024to2047byte: 2196
>     rx_octets: 3354319
>     IEEE_rx_frame_ok: 2435
>     IEEE_rx_octets_ok: 3354319
>     p06_rx_bcast: 4
>     p06_rx_mcast: 2269
>     p06_rx_ucast: 109
>     p06_rx_65_127: 156
>     p06_rx_128_255: 30
>     p06_rx_1024_1522: 2196
>     p06_tx_bcast: 76
>     p06_tx_mcast: 2250
>     p06_tx_ucast: 109
>     p06_rx_total: 3354271
>     p06_tx_total: 3354319
> 
> # ethtool -S lan1 | grep -v ': 0'
> NIC statistics:
>     tx_packets: 2326
>     tx_bytes: 3334064
>     rx_packets: 138
>     rx_bytes: 10592
>     rx_bcast: 63
>     rx_mcast: 31
>     rx_ucast: 133
>     rx_64_or_less: 75
>     rx_65_127: 139
>     rx_128_255: 13
>     tx_bcast: 4
>     tx_mcast: 2245
>     tx_ucast: 77
>     rx_total: 21324
>     tx_total: 3343572
>     rx_discards: 89
> 
> 
> # ethtool -S lan2 | grep -v ': 0'
> NIC statistics:
>     rx_packets: 2241
>     rx_bytes: 3293222
>     rx_bcast: 27
>     rx_mcast: 2214
>     rx_64_or_less: 26
>     rx_65_127: 11
>     rx_128_255: 8
>     rx_1024_1522: 2196
>     rx_total: 3333560
> 
> ifconfig stats:
> 
> # ifconfig
> bond1: flags=5187<UP,BROADCAST,RUNNING,MASTER,MULTICAST>  mtu 1500  metric 1
>        inet 192.168.1.6  netmask 255.255.255.0  broadcast 0.0.0.0
>        inet6 fd1c:a799:6054:0:60e2:5ff:fe75:6716  prefixlen 64  scopeid 0x0<global>
>        inet6 fe80::60e2:5ff:fe75:6716  prefixlen 64  scopeid 0x20<link>
>        ether 62:e2:05:75:67:16  txqueuelen 1000  (Ethernet)

I see bond1, lan1 and lan2 all have the same MAC address (62:e2:05:75:67:16).
Does this happen even when they are all different?

>        RX packets 2557  bytes 3317974 (3.1 MiB)
>        RX errors 0  dropped 2  overruns 0  frame 0
>        TX packets 2370  bytes 3338160 (3.1 MiB)
>        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
> 
> eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1506  metric 1
>        inet6 fe80::f21f:afff:fe6b:b218  prefixlen 64  scopeid 0x20<link>
>        ether f0:1f:af:6b:b2:18  txqueuelen 1000  (Ethernet)
>        RX packets 2557  bytes 3371671 (3.2 MiB)
>        RX errors 0  dropped 0  overruns 0  frame 0
>        TX packets 2394  bytes 3345891 (3.1 MiB)
>        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
> 
> lan1: flags=6211<UP,BROADCAST,RUNNING,SLAVE,MULTICAST>  mtu 1500  metric 1
>        ether 62:e2:05:75:67:16  txqueuelen 1000  (Ethernet)
>        RX packets 248  bytes 19384 (18.9 KiB)
>        RX errors 0  dropped 0  overruns 0  frame 0
>        TX packets 2370  bytes 3338160 (3.1 MiB)
>        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
> 
> lan2: flags=6211<UP,BROADCAST,RUNNING,SLAVE,MULTICAST>  mtu 1500  metric 1
>        ether 62:e2:05:75:67:16  txqueuelen 1000  (Ethernet)
>        RX packets 2309  bytes 3298590 (3.1 MiB)
>        RX errors 0  dropped 1  overruns 0  frame 0

I find this extremely strange. AFAIK, ifconfig reads stats from /proc/net/dev,
which in turn takes them from the driver using dev_get_stats():
https://elixir.bootlin.com/linux/v5.10.69/source/net/core/net-procfs.c#L78

But DSA didn't even report the "dropped" count via ndo_get_stats64 in 5.10...
https://elixir.bootlin.com/linux/v5.10.69/source/net/dsa/slave.c#L1257

I have no idea why this shows 1. I'll have to ignore this information
for now.

>        TX packets 0  bytes 0 (0.0 B)
>        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
> 
> lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536  metric 1
>        inet 127.0.0.1  netmask 255.0.0.0
>        inet6 ::1  prefixlen 128  scopeid 0x10<host>
>        loop  txqueuelen 1000  (Local Loopback)
>        RX packets 1  bytes 112 (112.0 B)
>        RX errors 0  dropped 0  overruns 0  frame 0
>        TX packets 1  bytes 112 (112.0 B)
>        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
> 
> # cat /proc/net/bonding/bond1
> Ethernet Channel Bonding Driver: v5.10.69-g472c99a84cb6-dirty
> 
> Bonding Mode: fault-tolerance (active-backup)
> Primary Slave: None
> Currently Active Slave: lan1
> MII Status: up
> MII Polling Interval (ms): 1000
> Up Delay (ms): 0
> Down Delay (ms): 0
> Peer Notification Delay (ms): 0
> 
> Slave Interface: lan1
> MII Status: up
> Speed: 1000 Mbps
> Duplex: full
> Link Failure Count: 0
> Permanent HW addr: f0:1f:af:6b:b2:18
> Slave queue ID: 0
> 
> Slave Interface: lan2
> MII Status: up
> Speed: 1000 Mbps
> Duplex: full
> Link Failure Count: 0
> Permanent HW addr: f0:1f:af:6b:b2:18
> Slave queue ID: 0

Would you mind trying to test the exact same scenario again with the
patch attached? (also pasted below in plain text) Still the same MAC
address for all interfaces for now.

From 033e3a8650a498de73cd202375b2e3f843e9a376 Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Thu, 28 Jul 2022 02:07:08 +0300
Subject: [PATCH] ksz9477: force-disable address learning

I suspect that what Brian Hutchinson experiences with the rx_discards
counter incrementing is due to his setup, where 2 external switches
connect together 2 bonded KSZ9567 switch ports, in such a way that one
KSZ port is able to see packets sent by the other (this is probably
aggravated by the multicast sent at a high data rate, which is treated
as broadcast by the external switches and flooded).

If we don't turn address learning off on standalone ports, this results
in the switch learning that a packet with this MAC SA came from the
outside world (when the MAC address actually belongs to Linux, and must
be forwarded to Linux). Then when the outside world actually tries to
reach Linux' MAC address, the KSZ switch finds that MAC address in the
FDB, but it points towards the outside world port, from which the packet
was received. 'Hey are you crazy, do you want me to loop back this
packet? No, let me just drop it" - is what I suspect the KSZ switch
would say, and a valid reason why it would increment rx_discards.

To prove this, hack the ksz9477_port_stp_state_set() method from
v5.10.69 such as to force-disable address learning on all KSZ ports.
Ports that are standalone have their STP state set to FORWARDING by DSA
through dsa_port_enable_rt() -> dsa_port_set_state_now(dp, BR_STATE_FORWARDING),
so I find it reasonable that this patch takes effect if that is the
problem.

I've disabled learning for all STP states just to make sure the driver
doesn't transition through some STP states in which it learns something,
and then it doesn't get rid of those addresses, corrupting the test.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/microchip/ksz9477.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index b3aa99eb6c2c..c20ee86c98c0 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -419,10 +419,10 @@ static void ksz9477_port_stp_state_set(struct dsa_switch *ds, int port,
 			member = dev->host_mask | p->vid_member;
 		break;
 	case BR_STATE_LEARNING:
-		data |= PORT_RX_ENABLE;
+		data |= PORT_RX_ENABLE | PORT_LEARN_DISABLE;
 		break;
 	case BR_STATE_FORWARDING:
-		data |= (PORT_TX_ENABLE | PORT_RX_ENABLE);
+		data |= (PORT_TX_ENABLE | PORT_RX_ENABLE | PORT_LEARN_DISABLE);
 
 		/* This function is also used internally. */
 		if (port == dev->cpu_port)
-- 
2.34.1

--55ommv3cfdwu3hlp
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-ksz9477-force-disable-address-learning.patch"

From 033e3a8650a498de73cd202375b2e3f843e9a376 Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Thu, 28 Jul 2022 02:07:08 +0300
Subject: [PATCH] ksz9477: force-disable address learning

I suspect that what Brian Hutchinson experiences with the rx_discards
counter incrementing is due to his setup, where 2 external switches
connect together 2 bonded KSZ9567 switch ports, in such a way that one
KSZ port is able to see packets sent by the other (this is probably
aggravated by the multicast sent at a high data rate, which is treated
as broadcast by the external switches and flooded).

If we don't turn address learning off on standalone ports, this results
in the switch learning that a packet with this MAC SA came from the
outside world (when the MAC address actually belongs to Linux, and must
be forwarded to Linux). Then when the outside world actually tries to
reach Linux' MAC address, the KSZ switch finds that MAC address in the
FDB, but it points towards the outside world port, from which the packet
was received. 'Hey are you crazy, do you want me to loop back this
packet? No, let me just drop it" - is what I suspect the KSZ switch
would say, and a valid reason why it would increment rx_discards.

To prove this, hack the ksz9477_port_stp_state_set() method from
v5.10.69 such as to force-disable address learning on all KSZ ports.
Ports that are standalone have their STP state set to FORWARDING by DSA
through dsa_port_enable_rt() -> dsa_port_set_state_now(dp, BR_STATE_FORWARDING),
so I find it reasonable that this patch takes effect if that is the
problem.

I've disabled learning for all STP states just to make sure the driver
doesn't transition through some STP states in which it learns something,
and then it doesn't get rid of those addresses, corrupting the test.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/microchip/ksz9477.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index b3aa99eb6c2c..c20ee86c98c0 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -419,10 +419,10 @@ static void ksz9477_port_stp_state_set(struct dsa_switch *ds, int port,
 			member = dev->host_mask | p->vid_member;
 		break;
 	case BR_STATE_LEARNING:
-		data |= PORT_RX_ENABLE;
+		data |= PORT_RX_ENABLE | PORT_LEARN_DISABLE;
 		break;
 	case BR_STATE_FORWARDING:
-		data |= (PORT_TX_ENABLE | PORT_RX_ENABLE);
+		data |= (PORT_TX_ENABLE | PORT_RX_ENABLE | PORT_LEARN_DISABLE);
 
 		/* This function is also used internally. */
 		if (port == dev->cpu_port)
-- 
2.34.1


--55ommv3cfdwu3hlp--
