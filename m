Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 672692E2C98
	for <lists+netdev@lfdr.de>; Sat, 26 Dec 2020 00:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbgLYXtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Dec 2020 18:49:18 -0500
Received: from mx.jh-inst.cas.cz ([147.231.28.3]:42046 "EHLO mx.jh-inst.cas.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725910AbgLYXtR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Dec 2020 18:49:17 -0500
X-Greylist: delayed 412 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Dec 2020 18:49:15 EST
Received: from mx.jh-inst.cas.cz (localhost [127.0.0.1])
        by mx.jh-inst.cas.cz (Postfix) with ESMTP id 4D2k463wQxz1X3Hw
        for <netdev@vger.kernel.org>; Sat, 26 Dec 2020 00:41:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=jh-inst.cas.cz;
         h=content-transfer-encoding:user-agent:message-id:subject
        :subject:to:from:from:date:date:content-type:content-type
        :mime-version; s=dkim; t=1608939701; x=1611531702; bh=ZiUu6VbZkQ
        IpXKQnQthg49DdyYDZCCx+tQ4xAkTFYA4=; b=Ed5mNjvxSbYLUkvLNUdfWs6HDt
        ATgPVfMuIrn/tKU7KoE0S613/0TuR6qYSSfXRB9Hd1yOLK1JYTMIdMuD+DSCJzLX
        VXupA2zabM/los+RYPS8qIrggWVLEhb+i3ejriJbsLs2YK6z4rOYrlmcn4DF5TFX
        b0IVPrn75FmIaaLzg=
X-Virus-Scanned: Debian amavisd-new at mx.jh-inst.cas.cz
Received: from mx.jh-inst.cas.cz ([127.0.0.1])
        by mx.jh-inst.cas.cz (mx.jh-inst.cas.cz [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id dVs10K_qYJTM for <netdev@vger.kernel.org>;
        Sat, 26 Dec 2020 00:41:41 +0100 (CET)
Received: from _ (localhost [127.0.0.1])
        by mx.jh-inst.cas.cz (Postfix) with ESMTPSA id 4D2k4550Scz1X3Hf;
        Sat, 26 Dec 2020 00:41:41 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date:   Sat, 26 Dec 2020 00:41:41 +0100
From:   Michal Tarana <michal.tarana@jh-inst.cas.cz>
To:     vfalico@gmail.com, andy@greyhouse.net
Cc:     netdev@vger.kernel.org
Subject: Link aggregation between Linux server and Netgear switch using
 802.3ad not working
Message-ID: <f0b24f711285856425a0d155243045f2@jh-inst.cas.cz>
X-Sender: michal.tarana@jh-inst.cas.cz
User-Agent: Roundcube Webmail
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I am trying to make the 802.3ad link aggregation working between my new=20
Debian server and the switch Netgear ProSafe GSM7248V2. I see some=20
strange behavior, the Linux Kernel says:

bond0: Warning: No 802.3ad response from the link partner for any=20
adapters in the bond

The connection itself is alive, I see packets flowing through both=20
interfaces involved. However, the links do not aggregate. It means that=20
when I open two simultaneous connections between the server and two=20
other machines (on the same switch), the total transfer rate equals the=20
speed of a single network interface. There is no other factor in these=20
tests that would significantly reduce the speed (no HDD or any storage=20
involved).

I would be very thankful for any advice or help. I have used the link=20
aggregation in this mode many times before, even using the very same=20
switch (different NICs and kernel versions, though). Until now, I always=20
was able to configure it without any issues. I think I tried everything=20
I considered possible in this configuration, so my "last instance" is=20
the developer of this kernel driver. Please, if this is not an=20
appropriate place to ask for help, would you be so kind and forwarded my=20
message to the right place or recommended me where to ask for help?


Here are further details:

On the side of the switch:
=3D-=3D-=3D
(GSM7248V2) #show port 0/9

                  Admin   Physical    Physical    Link   Link    LACP  =20
Actor
  Intf     Type    Mode    Mode        Status    Status  Trap    Mode  =20
Timeout
--------- ------ ------- ---------- ----------- ------ ------- -------=20
--------
0/9       PC Mbr Enable  Auto       1000 Full   Up     Enable  Enable =20
long

(GSM7248V2) #show port 0/10

                  Admin   Physical    Physical    Link   Link    LACP  =20
Actor
  Intf     Type    Mode    Mode        Status    Status  Trap    Mode  =20
Timeout
--------- ------ ------- ---------- ----------- ------ ------- -------=20
--------
0/10      PC Mbr Enable  Auto       1000 Full   Up     Enable  Enable =20
long

(GSM7248V2) #show port-channel 3/3


Local Interface................................ 3/3
Channel Name................................... gstlag
Link State..................................... Up
Admin Mode..................................... Enabled
Type........................................... Dynamic
Load Balance Option............................ 6
(Src/Dest IP and TCP/UDP Port fields)

Mbr    Device/       Port      Port
Ports  Timeout       Speed     Active
------ ------------- --------- -------
0/9    actor/long    Auto      True
        partner/long
0/10   actor/long    Auto      True
        partner/long

(GSM7248V2) #show lacp actor 0/9

          Sys    Admin   Port      Admin
  Intf  Priority  Key  Priority    State
------ -------- ----- -------- -----------
0/9    1        56    128      ACT|AGG|LTO

(GSM7248V2) #show lacp actor 0/10

          Sys    Admin   Port      Admin
  Intf  Priority  Key  Priority    State
------ -------- ----- -------- -----------
0/10   1        56    128      ACT|AGG|LTO

(GSM7248V2) #show lacp partner 0/9

        Sys      System       Admin Prt Prt     Admin
  Intf  Pri       ID          Key   Pri Id      State
------ --- ----------------- ----- --- ----- -----------
0/9    0   00:00:00:00:00:00 0     0   0     ACT|AGG|LTO

(GSM7248V2) #show lacp partner 0/10

        Sys      System       Admin Prt Prt     Admin
  Intf  Pri       ID          Key   Pri Id      State
------ --- ----------------- ----- --- ----- -----------
0/10   0   00:00:00:00:00:00 0     0   0     ACT|AGG|LTO

There are no VLANs or anything else configured. No port restrictions,=20
just the spanning-tree protocol is activated. There is one more LACP=20
port-channel (involving four different ports) configured on this switch=20
and connected to another device running Linux using ad802.3ad. That is=20
configured identically and does not have any issues.


On the side of the Linux server:
=3D-=3D-=3D-=3D-=3D
This is the output of the /proc/net/bonding/bond0:

Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)

Bonding Mode: IEEE 802.3ad Dynamic link aggregation
Transmit Hash Policy: layer3+4 (1)
MII Status: up
MII Polling Interval (ms): 100
Up Delay (ms): 3000
Down Delay (ms): 3000

802.3ad info
LACP rate: fast
Min links: 0
Aggregator selection policy (ad_select): stable
System priority: 65535
System MAC address: aa:aa:aa:aa:aa:88
Active Aggregator Info:
	Aggregator ID: 7
	Number of ports: 2
	Actor Key: 9
	Partner Key: 56
	Partner Mac Address: bb:bb:bb:bb:bb:6a

Slave Interface: eno1
MII Status: up
Speed: 1000 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: aa:aa:aa:aa:aa:88
Slave queue ID: 0
Aggregator ID: 7
Actor Churn State: none
Partner Churn State: none
Actor Churned Count: 0
Partner Churned Count: 0
details actor lacp pdu:
     system priority: 65535
     system mac address: aa:aa:aa:aa:aa:88
     port key: 9
     port priority: 255
     port number: 1
     port state: 63
details partner lacp pdu:
     system priority: 1
     system mac address: bb:bb:bb:bb:bb:6a
     oper key: 56
     port priority: 128
     port number: 10
     port state: 61

Slave Interface: eno2
MII Status: up
Speed: 1000 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: aa:aa:aa:aa:aa:89
Slave queue ID: 0
Aggregator ID: 7
Actor Churn State: none
Partner Churn State: none
Actor Churned Count: 0
Partner Churned Count: 0
details actor lacp pdu:
     system priority: 65535
     system mac address: aa:aa:aa:aa:aa:88
     port key: 9
     port priority: 255
     port number: 2
     port state: 63
details partner lacp pdu:
     system priority: 1
     system mac address: bb:bb:bb:bb:bb:6a
     oper key: 56
     port priority: 128
     port number: 9
     port state: 61

As far as I can see, the information automatically gathered by the=20
bondind driver matches the configuration of the switch. Here are the=20
parameters passed to the bonding driver - along with the configuration=20
of the network interfaces:

auto bond0
iface bond0 inet static
         address 192.168.2.15/24
         gateway 192.168.2.1
         dns-nameservers 8.8.8.8
         dns-search fubar-domain.info
         bond-slaves eno1 eno2
         bond-mode 4
         bond-miimon 100
         bond-updelay 3000
         bond-downdelay 3000
         bond-lacp-rate 1
         bond-xmit_hash_policy layer3+4
         hwaddress aa:aa:aa:aa:aa:90

This is the corresponding output of ip a:

2: eno1: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc mq=20
master bond0 state UP group default qlen 1000
     link/ether aa:aa:aa:aa:aa:90 brd ff:ff:ff:ff:ff:ff
3: eno2: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc mq=20
master bond0 state UP group default qlen 1000
     link/ether aa:aa:aa:aa:aa:90 brd ff:ff:ff:ff:ff:ff
4: bond0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc=20
noqueue state UP group default qlen 1000
     link/ether aa:aa:aa:aa:aa:90 brd ff:ff:ff:ff:ff:ff
     inet 192.168.2.15/24 brd 192.168.2.255 scope global bond0
        valid_lft forever preferred_lft forever
     inet6 fe80::ae1f:6bff:fedc:2e90/64 scope link
        valid_lft forever preferred_lft forever

The switch shows that the max frame size is 1518.


Here is the relevant part of dmesg:

igb: loading out-of-tree module taints kernel.
igb: module verification failed: signature and/or required key missing -=20
tainting kernel
Intel(R) Gigabit Ethernet Linux Driver - version 5.4.6
Copyright(c) 2007 - 2020 Intel Corporation.
igb 0000:04:00.0: added PHC on eth0
igb 0000:04:00.0: Intel(R) Gigabit Ethernet Linux Driver
igb 0000:04:00.0: eth0: (PCIe:2.5GT/s:Width x1)
igb 0000:04:00.0 eth0: MAC: aa:aa:aa:aa:aa:88
igb 0000:04:00.0: eth0: PBA No: 012700-000
igb 0000:04:00.0: LRO is disabled
igb 0000:04:00.0: Using MSI-X interrupts. 1 rx queue(s), 1 tx queue(s)
EDAC MC0: Giving out device to module skx_edac controller Skylake=20
Socket#0 IMC#0: DEV 0000:64:0a.0 (INTERRUPT)
EDAC MC1: Giving out device to module skx_edac controller Skylake=20
Socket#0 IMC#1: DEV 0000:64:0c.0 (INTERRUPT)
igb 0000:05:00.0: added PHC on eth1
igb 0000:05:00.0: Intel(R) Gigabit Ethernet Linux Driver
igb 0000:05:00.0: eth1: (PCIe:2.5GT/s:Width x1)
igb 0000:05:00.0 eth1: MAC: aa:aa:aa:aa:aa:89
igb 0000:05:00.0: eth1: PBA No: 012700-000
igb 0000:05:00.0: LRO is disabled
igb 0000:05:00.0: Using MSI-X interrupts. 1 rx queue(s), 1 tx queue(s)
igb 0000:05:00.0 eno2: renamed from eth1
igb 0000:04:00.0 eno1: renamed from eth0
Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)
bonding: bond0 is being created...
bond0: Enslaving eno1 as a backup interface with a down link
bond0: Enslaving eno2 as a backup interface with a down link
IPv6: ADDRCONF(NETDEV_UP): bond0: link is not ready
igb 0000:04:00.0 eno1: igb: eno1 NIC Link is Up 1000 Mbps Full Duplex,=20
Flow Control: None
bond0: link status up for interface eno1, enabling it in 0 ms
bond0: link status definitely up for interface eno1, 1000 Mbps full=20
duplex
bond0: Warning: No 802.3ad response from the link partner for any=20
adapters in the bond
bond0: first active interface up!
IPv6: ADDRCONF(NETDEV_CHANGE): bond0: link becomes ready
igb 0000:05:00.0 eno2: igb: eno2 NIC Link is Up 1000 Mbps Full Duplex,=20
Flow Control: None
bond0: link status up for interface eno2, enabling it in 3000 ms
bond0: invalid new link 3 on slave eno2
bond0: link status definitely up for interface eno2, 1000 Mbps full=20
duplex

Kernel version: Linux servername 4.19.0-13-amd64 #1 SMP Debian=20
4.19.160-2 (2020-11-28) x86_64 GNU/Linux
Version of the igb driver: 5.4.6

lspci of the Ethernet controllers:

04:00.0 Ethernet controller: Intel Corporation I210 Gigabit Network=20
Connection (rev 03)
	Subsystem: Super Micro Computer Inc I210 Gigabit Network Connection
	Flags: bus master, fast devsel, latency 0, IRQ 18, NUMA node 0
	Memory at aa200000 (32-bit, non-prefetchable) [size=3D512K]
	I/O ports at 2000 [size=3D32]
	Memory at aa280000 (32-bit, non-prefetchable) [size=3D16K]
	Capabilities: [40] Power Management version 3
	Capabilities: [50] MSI: Enable- Count=3D1/1 Maskable+ 64bit+
	Capabilities: [70] MSI-X: Enable+ Count=3D5 Masked-
	Capabilities: [a0] Express Endpoint, MSI 00
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [140] Device Serial Number aa-aa-aa-aa-aa-aa-aa-88
	Capabilities: [1a0] Transaction Processing Hints
	Kernel driver in use: igb
	Kernel modules: igb

05:00.0 Ethernet controller: Intel Corporation I210 Gigabit Network=20
Connection (rev 03)
	Subsystem: Super Micro Computer Inc I210 Gigabit Network Connection
	Flags: bus master, fast devsel, latency 0, IRQ 19, NUMA node 0
	Memory at aa100000 (32-bit, non-prefetchable) [size=3D512K]
	I/O ports at 1000 [size=3D32]
	Memory at aa180000 (32-bit, non-prefetchable) [size=3D16K]
	Capabilities: [40] Power Management version 3
	Capabilities: [50] MSI: Enable- Count=3D1/1 Maskable+ 64bit+
	Capabilities: [70] MSI-X: Enable+ Count=3D5 Masked-
	Capabilities: [a0] Express Endpoint, MSI 00
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [140] Device Serial Number aa-aa-aa-aa-aa-aa-aa-89
	Capabilities: [1a0] Transaction Processing Hints
	Kernel driver in use: igb
	Kernel modules: igb

Note that I used an upstream version of the igb driver. I was thinking=20
that maybe this is some bug in that driver, as I found the gymnastic, it=20
performs with the ethernet device upon bonding initialization, a bit=20
unusual. However, the behavior of the upstream version was identical to=20
the behavior of the NIC driver included in this kernel. I also tried a=20
newer version of the Linux Kernel from Debain testing (5.9.15). The=20
behavior was identical to that described above.

I also tried to turn on the debugging mode of the bonding driver. Since=20
I do not have access to the details of the corresponding IEEE standard,=20
I could not make much out of it. However, I noticed that at the=20
initialization of the bonding interface, the NICs were joining and=20
leaving different groups according to the functions=20
ad_port_selection_logic and ad_agg_selection_logic in bond_ad3.c. The=20
first aggregate was always in the individual mode ( ->is_individual was=20
true). That was when the warning about no 802.3ad partner was issued.=20
Later, the interfaces joined the LAG group where no member was in an=20
individual mode. That was after the no-802.3ad-partner warning was=20
issued. Would that (rather lengthy) output be helpful to you the=20
assessment of this issue, please? If so, I can provide it.

Is there anything else that would be helpful to provide you with at this=20
point please? If so, do not hesitate to let me know.

Thank you very much for reading this rather lengthy report and for any=20
reply. With wishing of all the best,
      Michal Tarana



--=20
Mgr. Michal Tarana, PhD

Department of Theoretical Chemistry

J Heyrovsk=C3=BD Institute of Physical Chemistry
Academy of Sciences of Czech Republic
Dolej=C5=A1kova 2155/3
182 82 Prague 8
Czech Republic

Skype: tarana.michal
