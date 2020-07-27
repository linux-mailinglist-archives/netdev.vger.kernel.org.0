Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B092D22F73F
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 20:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730037AbgG0SDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 14:03:49 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:59096 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728313AbgG0SDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 14:03:49 -0400
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id B43A2556;
        Mon, 27 Jul 2020 20:03:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1595873025;
        bh=3APSL9AA27X7sVqq3bmWN3WGF/gxcwYBkmMxCcGI7B0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Zkt3fyi1P48hztOJc6Omj4PAv4UWfYsHKcEJZ/nzzDxopqu/IaCgVC+Jvoo7K2I1r
         eEXyPmDGg6weplvQYIpFClcZgtgxLqsWze9bYEjj0+tvsEkjm/1nVB7K/xjzX2qijH
         L9i9pbfjq/iCuQ+SK2NbjfN57HHNcvFd/0yqbQKo=
Date:   Mon, 27 Jul 2020 21:03:06 +0300
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Chris Healy <cphealy@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>
Subject: Re: [RESENT PATCH net--stat 1/1] net: ethernet: fec: Revert "net:
 ethernet: fec: Replace interrupt driven MDIO with polled IO"
Message-ID: <20200727180306.GA15448@pendragon.ideasonboard.com>
References: <20200727020631.GW28704@pendragon.ideasonboard.com>
 <20200727021432.GM1661457@lunn.ch>
 <20200727023310.GA23988@pendragon.ideasonboard.com>
 <CAFXsbZrf11Nj4rzLJfisPr-fFo-+stt-G3-XQ_Mwus_2z0nsAg@mail.gmail.com>
 <CAFXsbZrysb6SGisEhgXHzj8NZ5o_EjY-rtiqg3gypgr0w-d-dw@mail.gmail.com>
 <CAFXsbZpBP_kzsC_dLYezJWo7+dQufoRmaFpJgKJbnn6T=sc5QA@mail.gmail.com>
 <20200727120545.GN1661457@lunn.ch>
 <20200727152434.GF20890@pendragon.ideasonboard.com>
 <CAFXsbZo5ufE0v_dmzQU9oWBeeRj+DKzDoiMj6OjuiER0O7nFfQ@mail.gmail.com>
 <20200727173717.GJ17521@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200727173717.GJ17521@pendragon.ideasonboard.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 08:37:20PM +0300, Laurent Pinchart wrote:
> On Mon, Jul 27, 2020 at 08:41:23AM -0700, Chris Healy wrote:
> > On Mon, Jul 27, 2020 at 8:24 AM Laurent Pinchart wrote:
> > > On Mon, Jul 27, 2020 at 02:05:45PM +0200, Andrew Lunn wrote:
> > > > On Sun, Jul 26, 2020 at 08:01:25PM -0700, Chris Healy wrote:
> > > > > It appears quite a few boards were affected by this micrel PHY driver change:
> > > > >
> > > > > 2ccb0161a0e9eb06f538557d38987e436fc39b8d
> > > > > 80bf72598663496d08b3c0231377db6a99d7fd68
> > > > > 2de00450c0126ec8838f72157577578e85cae5d8
> > > > > 820f8a870f6575acda1bf7f1a03c701c43ed5d79
> > > > >
> > > > > I just updated the phy-mode with my board from rgmii to rgmii-id and
> > > > > everything started working fine with net-next again:
> > > >
> > > > Hi Chris
> > > >
> > > > Is this a mainline supported board? Do you plan to submit a patch?
> > > >
> > > > Laurent, does the change also work for your board? This is another one
> > > > of those cases were a bug in the PHY driver, not respecting the
> > > > phy-mode, has masked a bug in the device tree, using the wrong
> > > > phy-mode. We had the same issue with the Atheros PHY a while back.
> > >
> > > Yes, setting the phy-mode to rgmii-id fixes the issue.
> > >
> > > Thank you everybody for your quick responses and very useful help !
> > >
> > > On a side note, when the kernel boots, there's a ~10s delay for the
> > > ethernet connection to come up:
> > >
> > > [    4.050754] Micrel KSZ9031 Gigabit PHY 30be0000.ethernet-1:01: attached PHY driver [Micrel KSZ9031 Gigabit PHY] (mii_bus:phy_addr=30be0000.ethernet-1:01, irq=POLL)
> > > [   15.628528] fec 30be0000.ethernet eth0: Link is Up - 1Gbps/Full - flow control rx/tx
> > > [   15.676961] Sending DHCP requests ., OK
> > > [   15.720925] IP-Config: Got DHCP answer from 192.168.2.47, my address is 192.168.2.210
> > >
> > > The LED on the connected switch confirms this, it lits up synchronously
> > > with the "Link is up" message. It's not an urgent issue, but if someone
> > > had a few pointers on how I could debug that, it would be appreciated.
> > 
> > Here's a few suggestions that could help in learning more:
> > 
> > 1) Review the KSZ9031 HW errata and compare against the PHY driver
> > code.  There's a number of errata that could cause this from my quick
> > review.
> 
> I'll have a look at that, thanks.

I thought issue 5 ("Auto-Negotiation link-up failure / long link-up time
due to default FLP interval setting") was a likely candidate, but it
seems it's already handled in the driver (implemented in
ksz9031_center_flp_timing()).

I've run a few more tests, adding a WARN_ON in ksz9031_config_init() to
trace its callers. It looks like the initial negotiation fails, until
ksz9031_read_status() restarts it after the maximum number of
iterations:

[    4.047515] ------------[ cut here ]------------
[    4.052388] WARNING: CPU: 0 PID: 1 at drivers/net/phy/micrel.c:693 ksz9031_config_init+0x34/0x344
[    4.061827] Modules linked in:
[    4.064932] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.8.0-rc6-00102-g6a84d7a1fa75-dirty #505
[    4.073570] Hardware name: Freescale i.MX7 Dual (Device Tree)
[    4.079364] [<c01119d4>] (unwind_backtrace) from [<c010c0d0>] (show_stack+0x10/0x14)
[    4.087147] [<c010c0d0>] (show_stack) from [<c055bd78>] (dump_stack+0xe8/0x120)
[    4.094498] [<c055bd78>] (dump_stack) from [<c0123888>] (__warn+0xc0/0x108)
[    4.101497] [<c0123888>] (__warn) from [<c0123c60>] (warn_slowpath_fmt+0x60/0xbc)
[    4.109018] [<c0123c60>] (warn_slowpath_fmt) from [<c0760558>] (ksz9031_config_init+0x34/0x344)
[    4.117754] [<c0760558>] (ksz9031_config_init) from [<c075b388>] (phy_attach_direct+0xfc/0x2b0)
[    4.126487] [<c075b388>] (phy_attach_direct) from [<c075b680>] (phy_connect_direct+0x1c/0x58)
[    4.135052] [<c075b680>] (phy_connect_direct) from [<c08d9bb8>] (of_phy_connect+0x38/0x60)
[    4.143354] [<c08d9bb8>] (of_phy_connect) from [<c0766920>] (fec_enet_mii_probe+0x40/0x1ac)
[    4.151741] [<c0766920>] (fec_enet_mii_probe) from [<c0769370>] (fec_enet_open+0x27c/0x340)
[    4.160130] [<c0769370>] (fec_enet_open) from [<c096f45c>] (__dev_open+0xd0/0x158)
[    4.167734] [<c096f45c>] (__dev_open) from [<c096f830>] (__dev_change_flags+0x168/0x1d4)
[    4.175860] [<c096f830>] (__dev_change_flags) from [<c096f8b4>] (dev_change_flags+0x18/0x48)
[    4.184338] [<c096f8b4>] (dev_change_flags) from [<c113d390>] (ip_auto_config+0x270/0x1068)
[    4.192727] [<c113d390>] (ip_auto_config) from [<c01021a4>] (do_one_initcall+0x80/0x348)
[    4.200855] [<c01021a4>] (do_one_initcall) from [<c1100fd0>] (kernel_init_freeable+0x15c/0x20c)
[    4.209591] [<c1100fd0>] (kernel_init_freeable) from [<c0bd7d44>] (kernel_init+0x8/0x114)
[    4.217804] [<c0bd7d44>] (kernel_init) from [<c0100134>] (ret_from_fork+0x14/0x20)
[    4.225402] Exception stack(0xec0edfb0 to 0xec0edff8)
[    4.230484] dfa0:                                     00000000 00000000 00000000 00000000
[    4.238692] dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    4.246899] dfe0: 00000000 00000000 00000000 00000000 00000013 00000000
[    4.254068] irq event stamp: 270123
[    4.257672] hardirqs last  enabled at (270141): [<c018dddc>] console_unlock+0x41c/0x5d8
[    4.265710] hardirqs last disabled at (270148): [<c018da68>] console_unlock+0xa8/0x5d8
[    4.273754] softirqs last  enabled at (270166): [<c0101580>] __do_softirq+0x2b8/0x508
[    4.281683] softirqs last disabled at (270177): [<c012b974>] irq_exit+0xfc/0x17c
[    4.289194] ---[ end trace 620517544bb2f528 ]---
[    4.295734] ksz9031_center_flp_timing
[    4.299781] ksz9031_center_flp_timing: restart negotiation
[    4.305402] ksz9031_config_init: 0
[    4.311116] Micrel KSZ9031 Gigabit PHY 30be0000.ethernet-1:01: attached PHY driver [Micrel KSZ9031 Gigabit PHY] (mii_bus:phy_addr=30be0000.ethernet-1:01, irq=POLL)
[   11.677512] ------------[ cut here ]------------
[   11.682341] WARNING: CPU: 0 PID: 12 at drivers/net/phy/micrel.c:693 ksz9031_config_init+0x34/0x344
[   11.691410] Modules linked in:
[   11.694515] CPU: 0 PID: 12 Comm: kworker/0:1 Tainted: G        W         5.8.0-rc6-00102-g6a84d7a1fa75-dirty #505
[   11.704803] Hardware name: Freescale i.MX7 Dual (Device Tree)
[   11.710591] Workqueue: events_power_efficient phy_state_machine
[   11.716561] [<c01119d4>] (unwind_backtrace) from [<c010c0d0>] (show_stack+0x10/0x14)
[   11.724346] [<c010c0d0>] (show_stack) from [<c055bd78>] (dump_stack+0xe8/0x120)
[   11.731699] [<c055bd78>] (dump_stack) from [<c0123888>] (__warn+0xc0/0x108)
[   11.738700] [<c0123888>] (__warn) from [<c0123c60>] (warn_slowpath_fmt+0x60/0xbc)
[   11.746223] [<c0123c60>] (warn_slowpath_fmt) from [<c0760558>] (ksz9031_config_init+0x34/0x344)
[   11.754960] [<c0760558>] (ksz9031_config_init) from [<c0760b78>] (ksz9031_read_status+0x40/0x84)
[   11.763785] [<c0760b78>] (ksz9031_read_status) from [<c0757414>] (phy_check_link_status+0x54/0xec)
[   11.772783] [<c0757414>] (phy_check_link_status) from [<c0758318>] (phy_state_machine+0x190/0x204)
[   11.781781] [<c0758318>] (phy_state_machine) from [<c0143a5c>] (process_one_work+0x2d0/0x778)
[   11.790343] [<c0143a5c>] (process_one_work) from [<c0143f30>] (worker_thread+0x2c/0x588)
[   11.798472] [<c0143f30>] (worker_thread) from [<c014b240>] (kthread+0x130/0x144)
[   11.805907] [<c014b240>] (kthread) from [<c0100134>] (ret_from_fork+0x14/0x20)
[   11.813159] Exception stack(0xec12bfb0 to 0xec12bff8)
[   11.818243] bfa0:                                     00000000 00000000 00000000 00000000
[   11.826454] bfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[   11.834662] bfe0: 00000000 00000000 00000000 00000000 00000013 00000000
[   11.841402] irq event stamp: 15245
[   11.844848] hardirqs last  enabled at (15253): [<c018dddc>] console_unlock+0x41c/0x5d8
[   11.852868] hardirqs last disabled at (15270): [<c018da68>] console_unlock+0xa8/0x5d8
[   11.860800] softirqs last  enabled at (15286): [<c0101580>] __do_softirq+0x2b8/0x508
[   11.868647] softirqs last disabled at (15297): [<c012b974>] irq_exit+0xfc/0x17c
[   11.875990] ---[ end trace 620517544bb2f529 ]---
[   11.881668] ksz9031_center_flp_timing
[   11.885649] ksz9031_center_flp_timing: restart negotiation
[   11.891308] ksz9031_config_init: 0
[   14.988788] fec 30be0000.ethernet eth0: Link is Up - 1Gbps/Full - flow control rx/tx

> > 2) Based on what I read in the HW errata, try different link partners
> > that utilize different copper PHYs to see if it results in different
> > behaviour.
> 
> I have limited available test equipment, but I can give it a try.
> 
> > 3) Try setting your autonegotiate advertisement to only advertise
> > 100Mbps and see if this affects the timing.  Obviously this would not
> > be a solution but might help in better understanding the issue.
> 
> I've tested this, and the link then comes up in ~2 seconds instead of
> ~10. That's clearly an improvement, but I have no idea what it implies
> :-)
> 
> [    4.090655] Micrel KSZ9031 Gigabit PHY 30be0000.ethernet-1:01: attached PHY driver [Micrel KSZ9031 Gigabit PHY] (mii_bus:phy_addr=30be0000.ethernet-1:01, irq=POLL)
> [    6.188347] fec 30be0000.ethernet eth0: Link is Up - 100Mbps/Full - flow control rx/tx
> [    6.236843] Sending DHCP requests ., OK
> [    6.280807] IP-Config: Got DHCP answer from 192.168.2.47, my address is 192.168.2.210

-- 
Regards,

Laurent Pinchart
