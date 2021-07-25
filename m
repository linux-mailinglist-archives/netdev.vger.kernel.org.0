Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8B693D4B02
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 04:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbhGYBpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Jul 2021 21:45:52 -0400
Received: from tulum.helixd.com ([162.252.81.98]:48604 "EHLO tulum.helixd.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229665AbhGYBpv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Jul 2021 21:45:51 -0400
Received: from [IPv6:2600:8801:8800:12e8:3407:b7f2:b44b:78da] (unknown [IPv6:2600:8801:8800:12e8:3407:b7f2:b44b:78da])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        (Authenticated sender: dalcocer@helixd.com)
        by tulum.helixd.com (Postfix) with ESMTPSA id D96592045C;
        Sat, 24 Jul 2021 19:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tulum.helixd.com;
        s=mail; t=1627179975;
        bh=cfpRxkcSw57eo01HmSNH4tyIPM29kXJHvHSYpDtVT4g=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=oEUuw/pgKRsLAV+A/25Axx0e0fEhibc+EW4XzSWFDIaKFihQzjlOni24wczIxD0h9
         yJlupKA6OP1zoPz+hdCoUiZPb2U+7q2HnRZcbdkyPteaszJuO5hN3MEZQiK2MnfHOI
         kcMg1+aDbfhu/9eSvg5JCPEty7gkk80DjuXLPFBk=
Subject: Re: Marvell switch port shows LOWERLAYERDOWN, ping fails
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
References: <6a70869d-d8d5-4647-0640-4e95866a0392@helixd.com>
 <YPrHJe+zJGJ7oezW@lunn.ch> <0188e53d-1535-658a-4134-a5f05f214bef@helixd.com>
 <YPsJnLCKVzEUV5cb@lunn.ch> <b5d1facd-470b-c45f-8ce7-c7df49267989@helixd.com>
 <82974be6-4ccc-3ae1-a7ad-40fd2e134805@helixd.com> <YPxPF2TFSDX8QNEv@lunn.ch>
From:   Dario Alcocer <dalcocer@helixd.com>
Message-ID: <f8ee6413-9cf5-ce07-42f3-6cc670c12824@helixd.com>
Date:   Sat, 24 Jul 2021 19:26:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YPxPF2TFSDX8QNEv@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/24/21 10:34 AM, Andrew Lunn wrote:
>> root@dali:~# ip link
>> 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode
>> DEFAULT group default qlen 1000
>>      link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
>> 2: can0: <NOARP,ECHO> mtu 16 qdisc noop state DOWN mode DEFAULT group
>> default qlen 10
>>      link/can
>> 3: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1508 qdisc mq state UP mode
>> DEFAULT group default qlen 1000
>>      link/ether b6:07:dc:be:30:f9 brd ff:ff:ff:ff:ff:ff
>> 4: sit0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group
>> default qlen 1000
>>      link/sit 0.0.0.0 brd 0.0.0.0
>> 5: lan1@eth0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue
>> state LOWERLAYERDOWN mode DEFAULT group default qlen 1000
>>      link/ether b6:07:dc:be:30:f9 brd ff:ff:ff:ff:ff:ff
>> 6: lan2@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode
>> DEFAULT group default qlen 1000
>>      link/ether b6:07:dc:be:30:f9 brd ff:ff:ff:ff:ff:ff
>> 7: lan3@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode
>> DEFAULT group default qlen 1000
>>      link/ether b6:07:dc:be:30:f9 brd ff:ff:ff:ff:ff:ff
>> 8: lan4@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode
>> DEFAULT group default qlen 1000
>>      link/ether b6:07:dc:be:30:f9 brd ff:ff:ff:ff:ff:ff
>> 9: dmz@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode
>> DEFAULT group default qlen 1000
>>      link/ether b6:07:dc:be:30:f9 brd ff:ff:ff:ff:ff:ff
> I would suggest you configure all the interfaces up. I've made the
> stupid mistake of thinking the right most RJ-45 socket is lan1 when it
> is in fact dmz, etc. If you configure them all up, you should see
> kernel messages if any go up, and you can see LOWER_UP, etc.

As suggested, I brought up all the interfaces after rebooting and 
logging in. All interfaces report NO-CARRIER:

root@dali:~# ip addr add 192.0.2.1/24 dev lan1
root@dali:~# ip addr add 192.0.3.1/24 dev lan2
root@dali:~# ip addr add 192.0.4.1/24 dev lan3
root@dali:~# ip addr add 192.0.5.1/24 dev lan4
root@dali:~# ip addr add 192.0.6.1/24 dev dmz
root@dali:~# ip link set lan1 up
[  100.725374] mv88e6085 stmmac-0:1a lan1: configuring for phy/gmii link 
mode
[  100.734414] 8021q: adding VLAN 0 to HW filter on device lan1
root@dali:~# ip link set lan2 up
[  104.765609] mv88e6085 stmmac-0:1a lan2: configuring for phy/gmii link 
mode
[  104.774623] 8021q: adding VLAN 0 to HW filter on device lan2
root@dali:~# ip link set lan3 up
[  109.175228] mv88e6085 stmmac-0:1a lan3: configuring for phy/gmii link 
mode
[  109.184329] 8021q: adding VLAN 0 to HW filter on device lan3
root@dali:~# ip link set lan4 up
[  113.805224] mv88e6085 stmmac-0:1e lan4: configuring for phy/gmii link 
mode
[  113.816757] 8021q: adding VLAN 0 to HW filter on device lan4
root@dali:~# ip link set dmz up
[  118.695089] mv88e6085 stmmac-0:1e dmz: configuring for phy/gmii link mode
[  118.704109] 8021q: adding VLAN 0 to HW filter on device dmz
root@dali:~# ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode 
DEFAULT group default qlen 1000
     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: can0: <NOARP,ECHO> mtu 16 qdisc noop state DOWN mode DEFAULT group 
default qlen 10
     link/can
3: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1508 qdisc mq state UP 
mode DEFAULT group default qlen 1000
     link/ether 42:19:da:37:69:37 brd ff:ff:ff:ff:ff:ff
4: sit0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group 
default qlen 1000
     link/sit 0.0.0.0 brd 0.0.0.0
5: lan1@eth0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue 
state LOWERLAYERDOWN mode DEFAULT group default qlen 1000
     link/ether 42:19:da:37:69:37 brd ff:ff:ff:ff:ff:ff
6: lan2@eth0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue 
state LOWERLAYERDOWN mode DEFAULT group default qlen 1000
     link/ether 42:19:da:37:69:37 brd ff:ff:ff:ff:ff:ff
7: lan3@eth0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue 
state LOWERLAYERDOWN mode DEFAULT group default qlen 1000
     link/ether 42:19:da:37:69:37 brd ff:ff:ff:ff:ff:ff
8: lan4@eth0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue 
state LOWERLAYERDOWN mode DEFAULT group default qlen 1000
     link/ether 42:19:da:37:69:37 brd ff:ff:ff:ff:ff:ff
9: dmz@eth0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue 
state LOWERLAYERDOWN mode DEFAULT group default qlen 1000
     link/ether 42:19:da:37:69:37 brd ff:ff:ff:ff:ff:ff

> What does the link peer think? Does it think there is link? I think
> for this generation of switch, the PHYs by default are enabled and
> will perform autoneg, even if the interface is down. But if the
> interface is down, phylib will not be monitoring it, and so you don't
> see any kernel messages.

Only lan1, lan2, and lan3 have link peers. All of these peers report 
NO-CARRIER as well on their end.

I'll see if I can find a couple more devices to connect lan4 and dmz.

> You might want to enable dbg prints in driver/nets/phy/phy.c, so you
> can see the state machine changes.

Great suggestion. I added the following to the boot options:

dyndbg="file net/dsa/* +p; file drivers/net/phy/phy.c +p"

The relevant messages collected from the system log are below. 
Interestingly, all of the ports go from UP to NOLINK. In addition, 
"breaking chain for DSA event 7" is reported, once for each port.

I'll dig into the DSA sources to see the significance of event 7.

Jan  1 00:00:10 (none) user.info kernel: [    3.916429] mv88e6085 
stmmac-0:1e: switch 0x1760 detected: Marvell 88E6176, revision 1
Jan  1 00:00:10 (none) user.info kernel: [    4.112181] libphy: 
mv88e6xxx SMI: probed
Jan  1 00:00:10 (none) user.info kernel: [    5.604619] mv88e6085 
stmmac-0:1a lan1 (uninitialized): PHY [mv88e6xxx-0:00] driver [Marvell 
88E1540]
Jan  1 00:00:10 (none) user.info kernel: [    5.653303] mv88e6085 
stmmac-0:1a lan2 (uninitialized): PHY [mv88e6xxx-0:01] driver [Marvell 
88E1540]
Jan  1 00:00:10 (none) user.info kernel: [    5.701971] mv88e6085 
stmmac-0:1a lan3 (uninitialized): PHY [mv88e6xxx-0:02] driver [Marvell 
88E1540]
Jan  1 00:00:10 (none) user.info kernel: [    5.777739] mv88e6085 
stmmac-0:1a: configuring for fixed/1000base-x link mode
Jan  1 00:00:10 (none) user.info kernel: [    5.845517] mv88e6085 
stmmac-0:1a: Link is Up - 1Gbps/Full - flow control off
Jan  1 00:00:10 (none) user.info kernel: [    7.075948] mv88e6085 
stmmac-0:1e lan4 (uninitialized): PHY [mv88e6xxx-2:00] driver [Marvell 
88E1540]
Jan  1 00:00:10 (none) user.info kernel: [    7.124591] mv88e6085 
stmmac-0:1e dmz (uninitialized): PHY [mv88e6xxx-2:01] driver [Marvell 
88E1540]
Jan  1 00:00:10 (none) user.info kernel: [    7.216056] mv88e6085 
stmmac-0:1e: configuring for fixed/1000base-x link mode
Jan  1 00:00:10 (none) user.info kernel: [    7.305154] mv88e6085 
stmmac-0:1e: Link is Up - 1Gbps/Full - flow control off
Jan  1 00:00:10 (none) user.err kernel: [    7.348496] debugfs: 
Directory 'switch0' with parent 'dsa' already present!
Jan  1 00:00:10 (none) user.warn kernel: [    7.355442] DSA: failed to 
create debugfs interface for switch 0 (-14)
Jan  1 00:00:10 (none) user.info kernel: [    7.362201] DSA: tree 0 setup
Nov  1 12:00:00 (none) user.info kernel: [   10.924223] socfpga-dwmac 
ff700000.ethernet eth0: No Safety Features support found
Nov  1 12:00:00 (none) user.info kernel: [   10.932024] socfpga-dwmac 
ff700000.ethernet eth0: registered PTP clock
Nov  1 12:00:00 (none) user.info kernel: [   10.938606] socfpga-dwmac 
ff700000.ethernet eth0: configuring for fixed/gmii link mode
Nov  1 12:00:00 (none) user.info kernel: [   10.947521] socfpga-dwmac 
ff700000.ethernet eth0: Link is Up - 1Gbps/Full - flow control rx/tx
Nov  1 12:00:00 (none) user.info kernel: [   10.956420] IPv6: 
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
Nov  1 12:01:30 (none) user.info kernel: [  100.725374] mv88e6085 
stmmac-0:1a lan1: configuring for phy/gmii link mode
Nov  1 12:01:30 (none) user.info kernel: [  100.734414] 8021q: adding 
VLAN 0 to HW filter on device lan1
Nov  1 12:01:30 (none) user.debug kernel: [  100.740065] mv88e6085 
stmmac-0:1a: breaking chain for DSA event 7 (-95)
Nov  1 12:01:30 (none) user.debug kernel: [  100.792228] Marvell 88E1540 
mv88e6xxx-0:00: PHY state change UP -> NOLINK
Nov  1 12:01:34 (none) user.info kernel: [  104.765609] mv88e6085 
stmmac-0:1a lan2: configuring for phy/gmii link mode
Nov  1 12:01:34 (none) user.debug kernel: [  104.780274] mv88e6085 
stmmac-0:1a: breaking chain for DSA event 7 (-95)
Nov  1 12:01:34 (none) user.debug kernel: [  104.832491] Marvell 88E1540 
mv88e6xxx-0:01: PHY state change UP -> NOLINK
Nov  1 12:01:38 (none) user.info kernel: [  109.175228] mv88e6085 
stmmac-0:1a lan3: configuring for phy/gmii link mode
Nov  1 12:01:38 (none) user.info kernel: [  109.184329] 8021q: adding 
VLAN 0 to HW filter on device lan3
Nov  1 12:01:38 (none) user.debug kernel: [  109.189986] mv88e6085 
stmmac-0:1a: breaking chain for DSA event 7 (-95)
Nov  1 12:01:38 (none) user.debug kernel: [  109.240647] Marvell 88E1540 
mv88e6xxx-0:02: PHY state change UP -> NOLINK
Nov  1 12:01:43 (none) user.info kernel: [  113.805224] mv88e6085 
stmmac-0:1e lan4: configuring for phy/gmii link mode
Nov  1 12:01:43 (none) user.info kernel: [  113.816757] 8021q: adding 
VLAN 0 to HW filter on device lan4
Nov  1 12:01:43 (none) user.debug kernel: [  113.822414] mv88e6085 
stmmac-0:1e: breaking chain for DSA event 7 (-95)
Nov  1 12:01:43 (none) user.debug kernel: [  113.874108] Marvell 88E1540 
mv88e6xxx-2:00: PHY state change UP -> NOLINK
Nov  1 12:01:48 (none) user.info kernel: [  118.695089] mv88e6085 
stmmac-0:1e dmz: configuring for phy/gmii link mode
Nov  1 12:01:48 (none) user.info kernel: [  118.704109] 8021q: adding 
VLAN 0 to HW filter on device dmz
Nov  1 12:01:48 (none) user.debug kernel: [  118.709679] mv88e6085 
stmmac-0:1e: breaking chain for DSA event 7 (-95)
Nov  1 12:01:48 (none) user.debug kernel: [  118.763988] Marvell 88E1540 
mv88e6xxx-2:01: PHY state change UP -> NOLINK

I've been reading up on kernel tracing. Perhaps some well-crafted trace 
queries would help narrow down what's happening with the port PHYs.

