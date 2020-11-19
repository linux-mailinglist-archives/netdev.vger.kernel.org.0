Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAC202B965A
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 16:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbgKSPiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 10:38:01 -0500
Received: from mail-eopbgr30043.outbound.protection.outlook.com ([40.107.3.43]:63580
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727016AbgKSPiA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 10:38:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NWwcT4NltxKJYRnqKLwUMYO9j+DMsSYgKh6KwdH35FI/FjB7U3w5xYacFPpISjQrVKk77/vZWJHoGUjGuuynQJ8uP/NXO2VESpA0avE+9h/8ONEioN5NWm+WlxRHPLqjM3OfxRWJE46KmYJ8tfz3MktwzpDplusti5H4M3HEjCB9IjLEDGcIZxBGkjiMoESTuvur3vFLPDE72d4T9qlSAvr6mKX7kxbMEjj0Hq5yG8vmIe9bvnZ7GXFEwPdxMJN/vyJJUTMgk5KU6Herj8cDmD6hHYX/bOICWyoWX74dcTzxvhIN9Uy2WdvhxOVFZQ0knTPHMgx0HNIrysuXnxLWLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PqN0pynoQM4bdZ44sHgGXwlRJVat2ItvolPlrDWeMto=;
 b=UGYzV3EIzjpseBSJFamgzCCvkORTtJIQBMhpzxSDAAjgdz6hpVPF3ObvBT7tmhjTLS/Dtkqy00+WlD9BLLUIyXlAvmCviGXOq+fsTB1ZRvyzCsKI0Bvd+gCn098/lS7OvH3irNhNKuCUfu+7KhV/YrYuJufDkXNui0zjevDWbI1/A5cbRIrcLjRvdR+IlubA+wyBavtRFWwu6q/SAmpB/gDQs4NAifZLCRxbPwA46vbpIQa4Yiv6KuhcAnVmANLv4o8qdXgNPC0yLMgC/fwOdo6lZ+3ExcDNZMeT4YiX2fbDClGet+RsvpzAMmbephOODCkJ3jRUkyFy502eji14wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ipetronik.com; dmarc=pass action=none
 header.from=ipetronik.com; dkim=pass header.d=ipetronik.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ipetronik.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PqN0pynoQM4bdZ44sHgGXwlRJVat2ItvolPlrDWeMto=;
 b=ZsuAFhYG50XGs+jZoox1oXlWk5qmE4So2mtVT0O5AwIF+1TqEkW/mYsU04fVrYhqwMXp1yBz7m3mKL019NRRrYAOxtJyy3jTxKjvOUnhjzDiFy2nXGTNZQae/fMS7w+4Igk/ivv66T2Z0eZnpDjxrAxo/rrRaak9dr9JfnANnYj75Afm0i04J6LeVS1jpEUlwt/iFwaHxdq3eKBh1JCsXvqDiEEVCcmqunLe3PjAlvSMU6q0Q68lHl+DVn0t04SrRf0ZwxrlXNhtA+44eLnxxEE9/Cszu64f1/cuCNfr1V+9duzUCYJBkGmoYKmOnBWU24n3CgqkZ+oyp/Pqp7ca1Q==
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=ipetronik.com;
Received: from AM0P193MB0531.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:16d::10)
 by AM8P193MB0932.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:1eb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Thu, 19 Nov
 2020 15:37:53 +0000
Received: from AM0P193MB0531.EURP193.PROD.OUTLOOK.COM
 ([fe80::6090:f5b2:5283:9b1b]) by AM0P193MB0531.EURP193.PROD.OUTLOOK.COM
 ([fe80::6090:f5b2:5283:9b1b%7]) with mapi id 15.20.3589.021; Thu, 19 Nov 2020
 15:37:53 +0000
Date:   Thu, 19 Nov 2020 16:37:51 +0100
From:   Markus =?utf-8?Q?Bl=C3=B6chl?= <Markus.Bloechl@ipetronik.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@idosch.org>, Andrew Lunn <andrew@lunn.ch>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: lan78xx: Disable hardware vlan filtering in
 promiscuous mode
Message-ID: <20201119153751.ix73o5h4n6dgv4az@ipetronik.com>
References: <20201110153958.ci5ekor3o2ekg3ky@ipetronik.com>
 <20201111074341.24cafaf3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3df0cfa6-cbc9-dddb-0283-9b48fb6516d8@gmail.com>
 <20201111164727.pqecvbnhk4qgantt@skbuf>
 <20201112105315.o5q3zqk4p57ddexs@ipetronik.com>
 <20201114181103.2eeh3eexcdnbcfj2@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201114181103.2eeh3eexcdnbcfj2@skbuf>
X-Originating-IP: [2001:16b8:2d25:fa00:228:f8ff:feed:2952]
X-ClientProxiedBy: AM0PR02CA0009.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::22) To AM0P193MB0531.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:16d::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ipetronik.com (2001:16b8:2d25:fa00:228:f8ff:feed:2952) by AM0PR02CA0009.eurprd02.prod.outlook.com (2603:10a6:208:3e::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Thu, 19 Nov 2020 15:37:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b4cf7434-6b42-4684-3fc5-08d88ca1146a
X-MS-TrafficTypeDiagnostic: AM8P193MB0932:
X-Microsoft-Antispam-PRVS: <AM8P193MB09327F49E2AFCEF3307700BC92E00@AM8P193MB0932.EURP193.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WQKa9ozuq64aLBDs0UTkpT7gjBqNIRh/sJMZc2fgYLrnvyaf8/AcYflzPn/2mtu1UYasN6lcJiPqz7tuNojib2ozeB2feGo0RweiHayNaLBdbvRqNCTRJyG+tuSsJnL33kMZ6n7mKQSDtnOwfo7efIRMxm41cX1HG8L7i7aeSyEHQb7gnDTcjnVdOAtJT/95+niKPxmhctHYEaafmb6MjwmpHxwUFiluurAyMfwvlhaFocHrXBzuXVdA6FNQpEOJuVhr1hF83gImKDTln10lCwEYXVNczd53fULA+pCxkKD3dIgZOhLb12WCNOjcoHeXe51yVYAkEkv/59IcUpBMS6hhpQVBpSkICd6ej95BJNn+celzHP8ZoGv0o98pGNhFPzZRskXoDDidBEP0Bz4htw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P193MB0531.EURP193.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(39840400004)(346002)(376002)(396003)(366004)(8936002)(7696005)(66476007)(52116002)(66946007)(7416002)(86362001)(1076003)(66574015)(83380400001)(966005)(54906003)(110136005)(2616005)(316002)(36756003)(55016002)(5660300002)(4326008)(30864003)(66556008)(8886007)(16526019)(8676002)(2906002)(186003)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 037L4KgCM4sp5bHjf3IkIAtDQybvgYkMdmwtu+rFwNwMOEq44fr18iXuC6XKRuwvrJvyuF8tx8nWKj6Z93BIEx1ElEsvT148LrJg2dCQOBCxVPXl2vEqNSJ0AEFpMZd8GIPmMP0QMs7SFhEAn7LiG+ANHXNwlPJaBxW7KR+w040SKMs7abIy5oRVcUFGYkw2JEu4XNswDrAh+40plj4wfxTR51y8GYQkBCg5Vp2BEIXnZQWHcr/MpL4XRigQcq1ztANoYuTA8lsTtfnOE33c87on/9CxjKzSmXAIu4E6VanuTDMNhHfr01ToPdsegki4lMiHQtQbqc3H6bczkTk5P00HOihqqUjRUD7g0T5+BfPwIXnOQ7e4gX+kVU/gu3MiWW/b6shDQFA+UJp196GK7F6sNavutu2RubxF0H91LFjvz3APe9hRw72i1FTiZXitqq9zk6n+oPb4Sbpv/y+4zsW9rhDiZqWTg9jh1QVD32hEBTwGMJZHMr2gRxTMt62QRkmTky+gRQvFzKV59DEuio4dS4aSOsn1dvOB7leLf85I/57HbXRT7cO51ekSFdW8DG9xAEd3EFcpE0F9cBo1aqfgphMG/ULkrN06JpwO+BKJQBhl61uXLfiQ0buOekdJVJWWDyaTsYPR/MZeU4knlIEXzwJ5pR+al6HnLsVccOfnBnALHjwcIbvqIwjMfO4/nAsxE0hD5/uHlU+65FlsZA==
X-OriginatorOrg: ipetronik.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4cf7434-6b42-4684-3fc5-08d88ca1146a
X-MS-Exchange-CrossTenant-AuthSource: AM0P193MB0531.EURP193.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2020 15:37:53.5535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 982fe058-7d80-4936-bdfa-9bed4f9ae127
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZcsTL0y9Wf5r1A1hYtaznbHqqKwVbc/N75DpeCVT6S3L6LU/Sdcaf8M1PzepLT8eB9aOoVXbSG18Z8D+94YrcvdSmhimjNeRlEiZ5x5fzso=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8P193MB0932
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 14, 2020 at 08:11:03PM +0200, Vladimir Oltean wrote:
> On Thu, Nov 12, 2020 at 11:53:15AM +0100, Markus Blöchl wrote:
> > From what I can see, most other drivers use a special hardware register
> > flag to enable promiscuous mode, which overrules all other filters.
> 
> Yes, but it may not mean what you think.
> 
> > e.g. from the ASIX AX88178 datasheet:
> >
> >   PRO:  PACKET_TYPE_PROMISCUOUS.
> >     1: All frames received by the ASIC are forwarded up toward the host.
> >     0: Disabled (default).
> 
> See, that's one definition of promiscuity that is really strange, and
> not backed by any standards body that I know of (if you know otherwise,
> please speak up).
> 
> > It is just so that the lan78xx controllers don't have this explicit flag.
> 
> Which is not surprising, at least under that description. Others may be
> inclined to call that behavior "packet trapping" when applying it to
> e.g. an Ethernet switch.
> 
> There might be an entire discussion about how promiscuity does _not_
> mean "deliver all packets to the CPU" that might be of interest to you:
> https://lkml.org/lkml/2019/8/29/255

If I glanced over this discussion correctly, it is about avoiding
promiscuity under certain circumstances (while promiscuity was
only requested for switching and not by userspace) because HW promiscuity
is not needed in that particular case.

As I currently see it, there are two common use cases for promiscuity:

1) Applying filtering, switching and other logic on the CPU.
   This could be due to limited resources in the NIC, e.g. when there
   are too many unicast addresses configured on that interface or
   simply an unavailable hardware capability.

2) Sniffing the wire.

The kernel uses IFF_PROMISC (or `__dev_set_promiscuity()`) for both,
which obviously can be overkill in the first case.
The question remains, what does IFF_PROMISC exactly mean for userspace
(which, I guess, most often uses it for 2)?

> 
> > But since my change is more controversial than I anticipated, I would like
> > to take a step back and ask some general questions first:
> >
> > We used to connect something akin to a port mirror to a lan7800 NIC
> > (and a few others) in order to record and debug some VLAN heavy traffic.
> > On older kernel versions putting the interface into promiscuous mode
> > and opening and binding an AF_PACKET socket (or just throwing tcpdump
> > or libpcap at it) was sufficient.
> > After a kernel upgrade the same setup missed most of the traffic.
> > Does this qualify as a regression? Why not?
> 
> If something used to work but no longer does, that's what a regression
> is. But fixing it depends on whether it should have worked like that in
> the first place or not. That we don't know.

Admittedly, I certainly don't know, but hoped to find whom who does on
this list. ;-)

> 
> > Should there be a documented and future proof way to receive *all*
> > valid ethernet frames from an interface?
> 
> Yes, there should.
> 
> > This could be something like:
> >
> > a) - Bring up the interface
> >    - Put the interface into promiscuous mode
> 
> This one would be necessary in order to not drop packets with unknown
> addresses, not more.
> 
> >    - Open, bind and read a raw AF_PACKET socket with ETH_P_ALL
> >    - Patch up the 801.1Q headers if required.
> 
> What do you mean by "patching up"? Are you talking about the fact that
> packets are untagged by the stack in the receive path anyway, and the
> VLAN header would need to be reconstructed?
> https://patchwork.ozlabs.org/project/netdev/patch/e06dbb47-2d1c-03ca-4cd7-cc958b6a939e@gmail.com/

Yes, that's exactly what I was referring to.
I find it slightly annoying on RAW sockets, but it's documented and
(hopefully) consistent behaviour now, so okay for me.

> 
> >
> > b) - The same as a)
> >    - Additionally enumerate and disable all available offloading features
> 
> If said offloading features have to do with the CPU not receiving some
> frames any longer, and you _do_ want the CPU to see them, then obviously
> said offloading features should be disabled. This includes not only VLAN
> filtering, but also bridging offload, IP forwarding offload, etc.
> 
> I'd say that (b) should be sufficient, but not future-proof in the sense
> that new offloading features might come every day, and they would need
> to be disabled on a case-by-case basis.
> 
> For the forwarding offload, there would be no question whatsoever that
> you'd need to turn it off, or add a mirroring rule towards the CPU, or
> do _something_ user-visible, to get that traffic. But as for VLAN
> filtering offload in particular, there's the (not negligible at all)
> precedent created by the bridge driver, that Ido pointed out. That would
> be a decision for the maintainers to make, if the Linux network stack
> creates its own definition of promiscuity which openly contradicts IEEE's.
> One might perhaps try to argue that the VLAN ID is an integral part of
> the station's address (which is true if you look at it from the
> perspective of an IEEE 802.1Q bridge), and therefore promiscuity should
> apply on the VLAN ID too, not just the MAC address. Either way, that
> should be made more clear than it currently is, once a decision is
> taken.

In that case, maybe new features which could alter user-visible behaviour
should not be enabled by default?
If I am not mistaken, bridging offload, IP forwarding offload and
similar have to be enabled explicitly, at least.

I am not convinced that this definition would indeed contradict the
IEEE standard. It might just be a stronger one with more guarantees.
Assuming you have a very stupid NIC without any filtering or offloading
capabilities, which would always forward all frames to the CPU.
Would this NIC not comply to the standard?

@Jakub
May I take your answer as a final decision or would you prefer some more
input on this?

> 
> > c) - Use libpcap / Do whatever libpcap does (like with TPACKET)
> >    In this case you need to help me convince the tcpdump folks that this
> >    is a bug on their side... ;-)
> 
> Well, that assumes that today, tcpdump can always capture all traffic on
> all types of interfaces, something which is already false (see bridging
> offload / IP forwarding offload). There, it was even argued that you'd
> better be 100% sure that you want to see all received traffic, as the
> interfaces can be very high-speed, and not even a mirroring rule might
> guarantee reception of 100% of the traffic. That's why things like sFlow
> / tc-sample exist.
> 
> > d) - Read the controller datasheet
> >    - Read the kernel documentation
> >    - Read your kernels and drivers sources
> >    - Do whatever might be necessary
> 
> Yes, in general reading is helpful, but I'm not quite sure where you're
> going with this?

Well, that just meant, that there should always be a way, but no
universal one.
Which one depends on your exact hardware setup or maybe even the current
constellation of stars...

> 
> > e) - No, there is no guaranteed way to to this
> 
> No, there should be a way to achieve that through some sort of
> configuration.
> 
> > Any opinions on these questions?
> 
> My 2 cents have just been shared.
> 
> > After those are answered, I am open to suggestions on how to fix this
> > differently (if still needed).
> 
> Turn off VLAN filtering, or get a commonly accepted definition of
> promiscuity?


Other Drivers
=============

So I tried to figure out what other existing hardware drivers do
by grepping for drivers which do something on a change to
NETIF_F_HW_VLAN_CTAG_FILTER.

Here are the results of me trying to understand the drivers quickly.
I hope it's somewhat close and helps:

1) aqc111
   This controller has a HW register flag for promiscuous mode.
   I am not sure what it does, but since this is another ASIX
   device, the documentation from above should apply.

2) lan78xx
   Here it began ...

3) ixgbe
   This driver disables HW_VLAN_CTAG_FILTER if IFF_PROMISC is set.

4) ice
   I don't know.

5) ocelot_net
   This driver does not support promiscuous mode with the following
   explanation:
	/* This doesn't handle promiscuous mode because the bridge core is
	 * setting IFF_PROMISC on all slave interfaces and all frames would be
	 * forwarded to the CPU port.
	 */
   See the already mentioned discussion https://lkml.org/lkml/2019/8/29/255
   for more.

6) liquidio
   This driver also has a HW flag for promiscuous mode.
   I don't know what it does, though.

7) mvpp2
   This driver disables vid filtering if IFF_PROMISC is set.

8) efx
	/* Disable VLAN filtering by default.  It may be enforced if
	 * the feature is fixed (i.e. VLAN filters are required to
	 * receive VLAN tagged packets due to vPort restrictions).
	 */
   I did not find a variant that really honors this feature.

9) ef100
   I don't know.

10) mlx5
   This driver sets a HW promisc flag, adds an `ANY` vlan filter rule
   and ignores further changes to vlan filtering if IFF_PROMISC is set.

11) nfp
   This driver uses a HW promisc flag.

12) atlantic
   I don't know.

13) xlgmac
   This one has an interesting comment in `xlgmac_set_promiscuous_mode`:
	/* Hardware will still perform VLAN filtering in promiscuous mode */
	if (enable) {
		xlgmac_disable_rx_vlan_filtering(pdata);
	} else {
		if (pdata->netdev->features & NETIF_F_HW_VLAN_CTAG_FILTER)
			xlgmac_enable_rx_vlan_filtering(pdata);
	}

14) enetc
   I think, the feature is overridden everytime in `set_rx_mode` as long
   as IFF_PROMISC is set.

15) xgbe
   In `xgbe_set_promiscuous_mode` once again:
	/* Hardware will still perform VLAN filtering in promiscuous mode */
	if (enable) {
		xgbe_disable_rx_vlan_filtering(pdata);
	} else {
		if (pdata->netdev->features & NETIF_F_HW_VLAN_CTAG_FILTER)
			xgbe_enable_rx_vlan_filtering(pdata);
	}


Implementation
==============

I then tried to come up with a solution in net/core that would
universally disable vlan filtering in promiscuous mode.
Removing the features in `netdev_fix_features` is easily done, but
updating the active set of features whenever IFF_PROMISC changes
seems hard.

`__dev_set_promiscuity` is often called in atomic context but
`.ndo_set_features` can sleep in many drivers.

Adding a work_queue or similar to every net_device seems clumsy and
inappropriate.

Rewriting ndo_set_features of all drivers to be atomic is not a task
you should ask from me...

Calling `netdev_update_features` after every entrypoint that locks
the rtnl seems too error-prone and also clumsy.

Only updating the features when promiscuity was explicitly requested
by userspace in `dev_change_flags` might leave the device in a
weird inconsistent state.

Continue to let each driver enforce the kernels definition of
promiscuity. They know how to update the features atomically.
Then I am back at my original patch...

I'm afraid, I might need some guidance on how to approach this.


Thanks for your help and all of your responses

Markus
