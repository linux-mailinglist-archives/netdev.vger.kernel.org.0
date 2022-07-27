Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BED9A5826F8
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 14:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233321AbiG0MsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 08:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232392AbiG0MsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 08:48:19 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B45A11D31D
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 05:48:17 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id bn9so13128823wrb.9
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 05:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=lTFRk3XR7YDLUaylorcu/dUFbXd/UNcCq4by2GHb65Y=;
        b=eSqDT0KE3ZmVNeBOsT72LeMAQqSYAeUJxsz6wzuXOZkQ84VHqeCEzEcV2Bvz7V63fZ
         0g95CKKyZeN/ArBj0cosd3vhfpsIXwoLkak11Gxlr7qxHGhOhn9ipCM3GnwoPG9Bdito
         waIcIRGrTvbsjWEcFhy2aA/IoG3hOacwhvXYUjRR52iHvDfbl2HJ5vX9qhunPjnLIgGX
         Q6X8LudGy5V5c5GZF1SjQzKE+jty704GIFZ4GxA+55adZpz1i7LgpFkHSDWwUKMGrJY4
         G52iqQm+j3ETsaBnU5KGJ1HBxb3+veIU/booUo588HpPrguuthJH2Jh5SfLBQ/035Y0j
         bIDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=lTFRk3XR7YDLUaylorcu/dUFbXd/UNcCq4by2GHb65Y=;
        b=ErVpo75XFuSWoQed3xasSJ8d8r7dOZrGEGYtBVVyXQlCU18JlfTAT5827PLN/E9kGb
         Iizy0I57QlFbRo+ijlLUnAIa26yTCzjE35y650Dxbx4t940JOb9NCQvU26bmm5rUq1f8
         RgeEGxa9Ilf85QXmg/k5qH+SYY5K1PMwCeuyaxJGOC12yyLGOUuImlafAe0ukIcVMQ44
         6c0VEeQvgL9zVVfSDYjlTsqssMIBb9x8jG5TaNHO6jGiQAQdxJJpa/hpwUQSdIQoRDQa
         gClQJszBmYOjielELXm0J7kGMIQc15oN5QQHPxj8b/FMSz8UKpLA9MuL1wuWEZFGxw3e
         qQIA==
X-Gm-Message-State: AJIora+iDijzog/uBs0sKqtRmyuVqc7P+pX/aCelWGwZH5ptyxuUxxrz
        ounT29ZcDLbZS12IrX0x5vRu1CdIq3pG74UvecAnJ6r0h2Y=
X-Google-Smtp-Source: AGRyM1u9fW/WoaOqxNScbRdaXhMc8+WYHzSQpGPPHXCe1+8RV1tMy7+xE0iDCnZvTjovhvv2G5Y6Muw+x3Y6ZE/1Xjk=
X-Received: by 2002:a5d:648c:0:b0:21e:9872:5a38 with SMTP id
 o12-20020a5d648c000000b0021e98725a38mr6916093wri.556.1658926095758; Wed, 27
 Jul 2022 05:48:15 -0700 (PDT)
MIME-Version: 1.0
References: <CAFZh4h-JVWt80CrQWkFji7tZJahMfOToUJQgKS5s0_=9zzpvYQ@mail.gmail.com>
 <fd16ebb3-2435-ef01-d9f1-b873c9c0b389@gmail.com>
In-Reply-To: <fd16ebb3-2435-ef01-d9f1-b873c9c0b389@gmail.com>
From:   Brian Hutchinson <b.hutchman@gmail.com>
Date:   Wed, 27 Jul 2022 08:48:04 -0400
Message-ID: <CAFZh4h9e6pY43oLMj4_Z-eiA_tA-e2mE=NpeZqat66b8TeukAw@mail.gmail.com>
Subject: Re: Bonded multicast traffic causing packet loss when using DSA with
 Microchip KSZ9567 switch
To:     netdev@vger.kernel.org
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

On Mon, Jul 25, 2022 at 5:35 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
.
.
.
> This is a red herring, we cannot tell the network stack without much special casing that the DSA network device must only transport tagged traffic to/from the switch, so the IPv6 stack still happily generates a link local address for your adapter.
>
> Any chance of getting the outputs of ethtool -S for lan1 and lan2, and eth0 so we could possibly glean something from the hardware maintained statistics?
>
As requested, statistics below:

I power cycled my board, ran my script to setup active-backup bond and
repeated the iperf test to obtain requested statistics.

Bond setup script basically does:

# Load bonding kernel module
modprobe bonding

# Bring up CPU interface (cpu to switch port 7 - the RGMII link)
ip link set eth0 up

# Create a bond
echo +bond1 > /sys/class/net/bonding_masters

# Set mode to active-backup (redundancy failover)
echo active-backup > /sys/class/net/bond1/bonding/mode

# Set time it takes (in ms) for slave to move when a link goes down
echo 1000 > /sys/class/net/bond1/bonding/miimon

# Add slaves to bond

echo +lan1 > /sys/class/net/bond1/bonding/slaves
echo +lan2 > /sys/class/net/bond1/bonding/slaves

# Set IP and netmask of the bond
ip addr add 192.168.1.6/24 dev bond1

# And bring bond up.  Pings and network connectivity should work now
ip link set bond1 up

Things I noticed in the data:

1.  I'm getting rx_discards which in Microchip data sheet are called
RxDropPackets which are defined as "RX packets dropped due to lack of
resources."  I don't know what that means or how to fix it.
2. ifconfig stats show dropped counts for bond1 and lan2 interface.
3. lan1 was active interface during the test.

On PC I run iperf -s -u -B 239.0.0.67%enp4s0 -i 1
On my board I run iperf -B 192.168.1.6 -c 239.0.0.67 -u --ttl 3000 -t
30 -b 1M -i 1 (didn't let it run the full time, stopped it with
ctrl-c)

Ping from PC to board while iperf is running on my board shows packet loss:

ping 192.168.1.6
PING 192.168.1.6 (192.168.1.6) 56(84) bytes of data.
64 bytes from 192.168.1.6: icmp_seq=9 ttl=64 time=2.33 ms
64 bytes from 192.168.1.6: icmp_seq=35 ttl=64 time=4.53 ms
64 bytes from 192.168.1.6: icmp_seq=36 ttl=64 time=2.03 ms
64 bytes from 192.168.1.6: icmp_seq=37 ttl=64 time=2.01 ms
64 bytes from 192.168.1.6: icmp_seq=38 ttl=64 time=1.99 ms
64 bytes from 192.168.1.6: icmp_seq=39 ttl=64 time=2.00 ms
64 bytes from 192.168.1.6: icmp_seq=40 ttl=64 time=1.29 ms
64 bytes from 192.168.1.6: icmp_seq=41 ttl=64 time=2.05 ms
64 bytes from 192.168.1.6: icmp_seq=42 ttl=64 time=1.98 ms
64 bytes from 192.168.1.6: icmp_seq=43 ttl=64 time=1.98 ms
64 bytes from 192.168.1.6: icmp_seq=44 ttl=64 time=1.95 ms
64 bytes from 192.168.1.6: icmp_seq=45 ttl=64 time=2.00 ms
64 bytes from 192.168.1.6: icmp_seq=46 ttl=64 time=2.03 ms
64 bytes from 192.168.1.6: icmp_seq=47 ttl=64 time=1.95 ms
64 bytes from 192.168.1.6: icmp_seq=48 ttl=64 time=1.95 ms
64 bytes from 192.168.1.6: icmp_seq=49 ttl=64 time=1.96 ms
64 bytes from 192.168.1.6: icmp_seq=50 ttl=64 time=2.00 ms
64 bytes from 192.168.1.6: icmp_seq=51 ttl=64 time=2.00 ms
64 bytes from 192.168.1.6: icmp_seq=52 ttl=64 time=1.97 ms
64 bytes from 192.168.1.6: icmp_seq=53 ttl=64 time=1.96 ms
64 bytes from 192.168.1.6: icmp_seq=54 ttl=64 time=1.97 ms
64 bytes from 192.168.1.6: icmp_seq=55 ttl=64 time=2.03 ms
64 bytes from 192.168.1.6: icmp_seq=56 ttl=64 time=1.29 ms
64 bytes from 192.168.1.6: icmp_seq=57 ttl=64 time=2.04 ms
^C
--- 192.168.1.6 ping statistics ---
57 packets transmitted, 24 received, 57.8947% packet loss, time 56807ms
rtt min/avg/max/mdev = 1.285/2.054/4.532/0.558 ms

Board stats for eth0, lan1 and lan2:

# ethtool -S eth0 | grep -v ': 0'
NIC statistics:
    tx_packets: 2382
    tx_broadcast: 4
    tx_multicast: 2269
    tx_65to127byte: 156
    tx_128to255byte: 30
    tx_1024to2047byte: 2196
    tx_octets: 3354271
    IEEE_tx_frame_ok: 2382
    IEEE_tx_octets_ok: 3354271
    rx_packets: 2435
    rx_broadcast: 76
    rx_multicast: 2250
    rx_65to127byte: 222
    rx_128to255byte: 17
    rx_1024to2047byte: 2196
    rx_octets: 3354319
    IEEE_rx_frame_ok: 2435
    IEEE_rx_octets_ok: 3354319
    p06_rx_bcast: 4
    p06_rx_mcast: 2269
    p06_rx_ucast: 109
    p06_rx_65_127: 156
    p06_rx_128_255: 30
    p06_rx_1024_1522: 2196
    p06_tx_bcast: 76
    p06_tx_mcast: 2250
    p06_tx_ucast: 109
    p06_rx_total: 3354271
    p06_tx_total: 3354319

# ethtool -S lan1 | grep -v ': 0'
NIC statistics:
    tx_packets: 2326
    tx_bytes: 3334064
    rx_packets: 138
    rx_bytes: 10592
    rx_bcast: 63
    rx_mcast: 31
    rx_ucast: 133
    rx_64_or_less: 75
    rx_65_127: 139
    rx_128_255: 13
    tx_bcast: 4
    tx_mcast: 2245
    tx_ucast: 77
    rx_total: 21324
    tx_total: 3343572
    rx_discards: 89


# ethtool -S lan2 | grep -v ': 0'
NIC statistics:
    rx_packets: 2241
    rx_bytes: 3293222
    rx_bcast: 27
    rx_mcast: 2214
    rx_64_or_less: 26
    rx_65_127: 11
    rx_128_255: 8
    rx_1024_1522: 2196
    rx_total: 3333560

ifconfig stats:

# ifconfig
bond1: flags=5187<UP,BROADCAST,RUNNING,MASTER,MULTICAST>  mtu 1500  metric 1
       inet 192.168.1.6  netmask 255.255.255.0  broadcast 0.0.0.0
       inet6 fd1c:a799:6054:0:60e2:5ff:fe75:6716  prefixlen 64
scopeid 0x0<global>
       inet6 fe80::60e2:5ff:fe75:6716  prefixlen 64  scopeid 0x20<link>
       ether 62:e2:05:75:67:16  txqueuelen 1000  (Ethernet)
       RX packets 2557  bytes 3317974 (3.1 MiB)
       RX errors 0  dropped 2  overruns 0  frame 0
       TX packets 2370  bytes 3338160 (3.1 MiB)
       TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1506  metric 1
       inet6 fe80::f21f:afff:fe6b:b218  prefixlen 64  scopeid 0x20<link>
       ether f0:1f:af:6b:b2:18  txqueuelen 1000  (Ethernet)
       RX packets 2557  bytes 3371671 (3.2 MiB)
       RX errors 0  dropped 0  overruns 0  frame 0
       TX packets 2394  bytes 3345891 (3.1 MiB)
       TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lan1: flags=6211<UP,BROADCAST,RUNNING,SLAVE,MULTICAST>  mtu 1500  metric 1
       ether 62:e2:05:75:67:16  txqueuelen 1000  (Ethernet)
       RX packets 248  bytes 19384 (18.9 KiB)
       RX errors 0  dropped 0  overruns 0  frame 0
       TX packets 2370  bytes 3338160 (3.1 MiB)
       TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lan2: flags=6211<UP,BROADCAST,RUNNING,SLAVE,MULTICAST>  mtu 1500  metric 1
       ether 62:e2:05:75:67:16  txqueuelen 1000  (Ethernet)
       RX packets 2309  bytes 3298590 (3.1 MiB)
       RX errors 0  dropped 1  overruns 0  frame 0
       TX packets 0  bytes 0 (0.0 B)
       TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536  metric 1
       inet 127.0.0.1  netmask 255.0.0.0
       inet6 ::1  prefixlen 128  scopeid 0x10<host>
       loop  txqueuelen 1000  (Local Loopback)
       RX packets 1  bytes 112 (112.0 B)
       RX errors 0  dropped 0  overruns 0  frame 0
       TX packets 1  bytes 112 (112.0 B)
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
Link Failure Count: 0
Permanent HW addr: f0:1f:af:6b:b2:18
Slave queue ID: 0
