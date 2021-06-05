Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 794E739C8D1
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 15:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbhFENdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 09:33:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:38138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229931AbhFENdE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Jun 2021 09:33:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9BBB613D8;
        Sat,  5 Jun 2021 13:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622899876;
        bh=bsrt0jcKI0jjKkBzxp17PWlnlhWBCOY6fqcVWXzFkko=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WBRAmsel9z8segme8H2M/zOmgvtLJp+9pnqoV2WZfV559UYaiOETiRRRyM33h84UO
         bBq2KJvEiu22gYdqZRjIcMPZ7j5qTrsra+fZjUqTuT4CXjlDzpKn4wnd1JLjWLKal1
         gRbbMss/JOhUtg1JHQRmvkbD9F5mhvj4q4/+ZdJcc6uLHtlugBt/16l3tibWcdEVAQ
         KXG+EA239371FbmRSadybfPAICX468lkIqZyFlottP5F6HS28yNnd6wUPHCwCkQfP5
         4dhBG8XYGhB0ZKiy96Kc0hKYR3lu6FTVc3C/8fKih2GrrELBajc69RMC2R5wsxZ1Bh
         zLq5fxWssr+7g==
Received: by pali.im (Postfix)
        id 51C66857; Sat,  5 Jun 2021 15:31:13 +0200 (CEST)
Date:   Sat, 5 Jun 2021 15:31:13 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Hauke Mehrtens <hauke@hauke-m.de>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Igal Liberman <Igal.Liberman@freescale.com>,
        Shruti Kanetkar <Shruti@freescale.com>,
        Emil Medve <Emilian.Medve@freescale.com>,
        Scott Wood <oss@buserror.net>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Camelia Alexandra Groza (OSS)" <camelia.groza@oss.nxp.com>
Subject: Re: What is inside GPON SFP module?
Message-ID: <20210605133113.j4gyjo4pnmxpxbqe@pali>
References: <AM6PR04MB3976B62084EC462BA02F0C4CEC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <20210604192732.GW30436@shell.armlinux.org.uk>
 <AM6PR04MB39768A569CE3CC4EC61A8769EC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <YLqLzOltcb6jan+B@lunn.ch>
 <AM6PR04MB39760B986E86BA9169DEECC5EC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <20210604233455.fwcu2chlsed2gwmu@pali>
 <20210605003306.GY30436@shell.armlinux.org.uk>
 <20210605122639.4lpox5bfppoyynl3@skbuf>
 <20210605125004.v6njqob6prb7k75k@pali>
 <80966478-8a7c-b66f-50b7-e50fc00b1784@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <80966478-8a7c-b66f-50b7-e50fc00b1784@hauke-m.de>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Saturday 05 June 2021 15:04:55 Hauke Mehrtens wrote:
> On 6/5/21 2:50 PM, Pali Rohár wrote:
> > On Saturday 05 June 2021 15:26:39 Vladimir Oltean wrote:
> > > On Sat, Jun 05, 2021 at 01:33:07AM +0100, Russell King (Oracle) wrote:
> > > > It started out as described - literally, 1000base-X multiplied by 2.5x.
> > > > There are setups where that is known to work - namely GPON SFPs that
> > > > support 2500base-X. What that means is that we know the GPON SFP
> > > > module negotiates in-band AN with 2500base-X. However, we don't know
> > > > whether the module will work if we disable in-band AN.
> > > 
> > > Pardon my ignorance, but what is inside a GPON ONT module? Just a laser
> > > and some amplifiers? So it would still be the MAC PCS negotiating flow
> > > control with the remote link partner? That's a different use case
> > > from
> a
> > > PHY transmitting the negotiated link modes to the MAC.
> > 
> > Hello Vladimir! All GPON ONU/ONT SFP modules which I have tested, are
> > fully featured mini computers. It is some SoC with powerful CPU, fiber
> > part, at least two NICs and then two phys, one for fiber part and one
> > for "SFP"-part (in most cases 1000base-x or 2500base-x). On SoC inside
> > is running fully featured operating system, in most cases Linux kernel
> > 2.6.3x and tons of userspace applications which implements "application"
> > layer of GPON protocol -- the most important part. If OEM vendor of GPON
> > SFP stick did not locked it, you can connect to this "computer" via
> > telnet or web browser and configure some settings, including GPON stuff
> > and also how GPON network is connected to SFP part -- e.g. it can be
> > fully featured IPv4 router with NAT or just plain bridge mode where
> > "ethernet data packets" (those which are not part of ISP configuration
> > protocol) are pass-throw to SFP phy 1000base-x to host CPU. GPON is not
> > ethernet, it is some incompatible and heavily layered extension on ATM.
> > Originally I thought that ATM is long ago dead (as I saw it in used last
> > time in ADSL2) but it is still alive and cause issues... I think it does
> > not use 8b/10b encoding and therefore cannot be directly mapped to
> > 1000base-x. Also GPON uses different wavelengths for inbound and
> > outbound traffic. And to make it even more complicated it uses totally
> > nonstandard asynchronous speeds, inbound is 2488.32Mbit/s, outbound is
> > 1244.16Mbit/s. So I guess CPU/SoC with GPON support (something which is
> > inside that GPON ONU/ONT stick) must use totally different modes for
> > which we do not have any option in DTS yet.
> > 
> > So once mainline kernel will support these "computers" with GPON support
> > it would be required to define new kind of phy modes... But I do not
> > think it happens and all OEM vendors are using 2.6.3x kernels their
> > userspace GPON implementation is closed has tons of secrets.
> > 
> 
> Hi,
> 
> This description of the GPON SFP sticks is correct, but it misses some of
> the complexity. ;-) GPON is also a shared medium like DOCSIS, you can not
> always send, but you have to wait till you get your time slice over PLOAM.

Hello!

I think same applies also for 1000BASE-PX or 10GBASE-PR GEPON passive
ethernet networks (Beware GPON != GEPON).

But I think this is not an issue. There are also other "shared medium"
technologies (e.g. mobile network; or WiFi on DFS channels) for which
exists hardware supported by mainline kernel (3G/LTE modems).

> In addition the GPON SFP stick also have to talk the OMCI protocol which
> allows to operator to configure all sorts of layer 2 things. They can also
> login to your SFP stick. ;-)

Yes, I just described it as "application" layer. It is complicated and
basically something which is not suppose to be implemented in kernel.
Plus GPON vendors extends (standardized) OMCI protocol with their own
extension which means that without their implementation on client side
it is impossible to fully establish connection to "server" OLT part.

> There are also some passive GPON SFP sticks which just translate between
> electrical and optical signals, but to operate them you need a GPON MAC and
> managed layer on your host.

Interesting... Do you know where to buy or test such passive GPON SFP sticks?

And is there some documentation how these sticks works? And what kind of
phy mode they are using over SerDes? Because due to different inbound
and outbound speeds it cannot be neither 1000base-x nor 2500base-x.

> Adding GPON support properly into Linux is not an easy task, Linux would
> probably need a subsystem with a complexity compared to cfg80211 + hostapd.

Yea... But maybe it could be easier to implement just "client part"
(ONU/ONT) without "server part" (OLT).

> Is there a list of things these GPON sticks running Linux should do better
> in the future? For example what to avoid in the EEPROM emulation handling?

Well... If you think that it is possible to address these issues
directly to GPON vendors and they will fix them in next version of GPON
SFP sticks, I could try to find some time and prepare list of lot of
issues...
