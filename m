Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E126C2036D5
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 14:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbgFVMb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 08:31:59 -0400
Received: from lists.nic.cz ([217.31.204.67]:52592 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728044AbgFVMb7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 08:31:59 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id 68785140973;
        Mon, 22 Jun 2020 14:31:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1592829116; bh=eotTpP3pXkVVeSWWk96Qzik9d/A1axNuioIi+GVJUwE=;
        h=Date:From:To;
        b=IRV0sAgPzl1UMFtX7WWHZ+kbz440WD6+aqSuIf1eEcwU30AMWzIf7XhJ4HbX+TmhT
         s2WsM6du+F4yfZcgpjsSQy8UdMCRs4UUUpL6r+EqKCUxQ1JXFPY8tEJZSfgp2STP0u
         dW8443vhmuzNjQ9Jm0YlRTZx8k3lvbikwHo+ea2E=
Date:   Mon, 22 Jun 2020 14:31:55 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     =?UTF-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: secondary CPU port facing switch does not come up/online
Message-ID: <20200622143155.2d57d7f7@nic.cz>
In-Reply-To: <eb0b71bb-4df3-ff3e-2424-a0d92b26741a@gmx.net>
References: <d47ad9bb-280b-1c9c-a245-0aebd689ccf5@gmx.net>
        <8f29251c-d572-f37f-3678-85b68889fd61@gmail.com>
        <eb0b71bb-4df3-ff3e-2424-a0d92b26741a@gmx.net>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WHITELIST shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TurrisOS has patches adding multi-CPU DSA support, look at those if you
want this functionality.

These patches apply on openwrt, after patching there should be kernel
patches created in target/linux/mvebu/patches-{4.14,5.4}

For 4.14 kernel:
https://gitlab.labs.nic.cz/turris/turris-build/-/blob/hbd/patches/openwrt/w=
ip/0009-mvebu-turris-omnia-multi-cpu-dsa.patch

(this creates
target/linux/mvebu/patches-4.14/90500-net-dsa-multi-cpu.patch
target/linux/mvebu/patches-4.14/90501-omnia-dts-dsa-multi-cpu.patch
)

For 5.4 kernel:
https://gitlab.labs.nic.cz/turris/turris-build/-/blob/fix/hbd-omnia-5.4-ker=
nel/patches/openwrt/wip/0005-mvebu-initial-support-for-Omnia-on-5.4-kernel.=
patch

(this creates
target/linux/mvebu/patches-5.4/9950-net-dsa-allow-for-multiple-CPU-ports.pa=
tch
target/linux/mvebu/patches-5.4/9951-net-add-ndo-for-setting-the-iflink-prop=
erty.patch
target/linux/mvebu/patches-5.4/9952-net-dsa-implement-ndo_set_netlink-for-c=
haning-port-s.patch
target/linux/mvebu/patches-5.4/9953-net-dsa-mv88e6xxx-support-multi-CPU-DSA=
.patch
)

On Mon, 22 Jun 2020 07:39:00 +0000
=D1=BD=D2=89=E1=B6=AC=E1=B8=B3=E2=84=A0 <vtol@gmx.net> wrote:

> On 21/06/2020 21:08, Florian Fainelli wrote:
> > Le 2020-06-21 =C3=A0 13:24, =D1=BD=D2=89=E1=B6=AC=E1=B8=B3=E2=84=A0 a =
=C3=A9crit=C2=A0: =20
> >> {"kernel":"5.4.46","hostname":"OpenWrt","system":"ARMv7 Processor rev 1
> >> (v7l)","model":"Turris
> >> Omnia","board_name":"cznic,turris-omnia","release":{"distribution":"Op=
enWrt","version":"SNAPSHOT","revision":"r13600-9a477b833a","target":"mvebu/=
cortexa9","description":"OpenWrt
> >> SNAPSHOT r13600-9a477b833a"}}
> >> _____
> >>
> >> With the below cited DT both CPU ports facing the node's build-in swit=
ch
> >> are brought online at boot time with kernel 4.14 but since having
> >> switched to kernel 5.4 only one CPU port gets online. It is as if the
> >> kernel discards the presence of the secondary CPU port. Kernel log only
> >> prints for the offline port just a single entry:
> >>
> >> mvneta f1070000.ethernet eth0: Using hardware mac address
> >>
> >> Swapping eth1 to port6 and eth0 to port6 then eth0 is brought online b=
ut
> >> eth1 is not. Removing port5 then the port6 listed port is brought
> >> up/online.
> >>
> >> Once the node is booted the offline port can brought up with ip l set
> >> up. This seems like a regression bug in between the kernel versions. =
=20
> > There can only be one CPU port at a time active right now, so I am not
> > sure why it even worked with kernel 4.14. =20
>=20
> What is the reasoning, because DSA is not coded to handle multi-ports?=20
> DSA can be patched downstream (proposed patches to mainline kernel were=20
> not accepted) and is so is for the 4.14 instance but there is DSA patch=20
> available for the 5.4 instance yet. That aside I would assume that DSA=20
> is not in charge of handling the state of the CPU ports but rather PHY=20
> or PHYLINK?
>=20
> I understand that dual CPU port chipset design is somewhat unusual but=20
> it is something unique and therefore a fringe case that is not supported=
=20
> by the kernel?
>=20
> >   Could you please share kernel
> > logs and the output of ip link show in both working/non-working cases? =
=20
>=20
> Sure, does the ML accept attachments, if so which format, or you want=20
> two full kernel logs in the message body? Meantime, the short version:
>=20
> 4.14
> dmesg -t | grep mvneta
> mvneta f1070000.ethernet eth0: Using hardware mac address d8:58:d7:00:79:=
7c
> mvneta f1030000.ethernet eth1: Using hardware mac address d8:58:d7:00:79:=
7a
> mvneta f1034000.ethernet eth2: Using hardware mac address d8:58:d7:00:79:=
7b
> mvneta f1034000.ethernet eth2: switched to 802.3z/1000base-x link mode
> mvneta f1070000.ethernet eth0: configuring for fixed/rgmii link mode
> mvneta f1070000.ethernet eth0: Link is Up - 1Gbps/Full - flow control off
> mvneta f1030000.ethernet eth1: Disable IP checksum for MTU greater than=20
> 1600B
> mvneta f1030000.ethernet eth1: configuring for fixed/rgmii link mode
> mvneta f1030000.ethernet eth1: Link is Up - 1Gbps/Full - flow control off
> mvneta f1034000.ethernet eth2: configuring for 802.3z/1000base-x link mode
> mvneta f1034000.ethernet eth2: Link is Up - 1Gbps/Full - flow control off
> mvneta f1034000.ethernet eth2: Link is Down
> mvneta f1034000.ethernet eth2: configuring for 802.3z/1000base-x link mode
> mvneta f1034000.ethernet eth2: Link is Up - 1Gbps/Full - flow control off
> mvneta f1034000.ethernet eth2: Link is Down
> mvneta f1034000.ethernet eth2: configuring for 802.3z/1000base-x link mode
> mvneta f1034000.ethernet eth2: Link is Up - 1Gbps/Full - flow control off
>=20
> 5.4
> dmesg -t | grep mvneta
> mvneta f1070000.ethernet eth0: Using hardware mac address d8:58:d7:00:79:=
7c
> mvneta f1030000.ethernet eth1: Using hardware mac address d8:58:d7:00:79:=
7a
> mvneta f1034000.ethernet eth2: Using hardware mac address d8:58:d7:00:79:=
7b
> mvneta f1034000.ethernet eth2: switched to inband/1000base-x link mode
> mvneta f1030000.ethernet eth1: Disable IP checksum for MTU greater than=20
> 1600B
> mvneta f1030000.ethernet eth1: configuring for fixed/rgmii link mode
> mvneta f1030000.ethernet eth1: Link is Up - 1Gbps/Full - flow control off
> mvneta f1034000.ethernet eth2: configuring for inband/1000base-x link mode
> mvneta f1034000.ethernet eth2: Link is Up - 1Gbps/Full - flow control off
> mvneta f1034000.ethernet eth2: Link is Down
> mvneta f1034000.ethernet eth2: configuring for inband/1000base-x link mode
> mvneta f1034000.ethernet eth2: configuring for inband/1000base-x link mode
> mvneta f1034000.ethernet eth2: Link is Up - 1Gbps/Full - flow control off
> mvneta f1034000.ethernet eth2: Link is Down
> mvneta f1034000.ethernet eth2: configuring for inband/1000base-x link mode
> mvneta f1034000.ethernet eth2: configuring for inband/1000base-x link mode
> mvneta f1034000.ethernet eth2: Link is Up - 1Gbps/Full - flow control off
>=20
>=20

