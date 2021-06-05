Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B26FE39C83C
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 14:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbhFEMv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 08:51:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:59386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229959AbhFEMv4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Jun 2021 08:51:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0A5761357;
        Sat,  5 Jun 2021 12:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622897409;
        bh=sBCXy98TXNjHjqaXut+0eax6C+KRlQ6QhUxOlmP6tIA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YuXpykyC7pMCTn4fVl+cOvk017Rl0N4iwl++9EAPcV5RjCuAV4ZntPYYZttWBVAM6
         K4MyRBB5iomV9ufuH0Lc8xCCl3GKmSIlF26JT0GYsqtZbj25CFCA7FeNDV4/YAXj+q
         eEUhAJKZ5x7bIom9KIcrvo54bYAVtn2OiHNjg3W79LkWDC/u1SpvBeSBk+vX+wz09A
         wvhFB7BV2iZO94YM8ggEuVmia9mBYa/P2Fm1gLx0nVOcOPfm6bMKAjXhoz/xlvRyt3
         PxYy1ze3LZQWFdWtgI0FaIsN4zgmhk1UOBmUJTYKgOuU3JSZYoFg+p5J9DotIdSHDU
         7cvC0aJh3fUXg==
Received: by pali.im (Postfix)
        id 2B23E857; Sat,  5 Jun 2021 14:50:05 +0200 (CEST)
Date:   Sat, 5 Jun 2021 14:50:04 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
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
Subject: What is inside GPON SFP module? (Was: Re: Unsupported
 phy-connection-type sgmii-2500 in arch/powerpc/boot/dts/fsl/t1023rdb.dts)
Message-ID: <20210605125004.v6njqob6prb7k75k@pali>
References: <YLjxX/XPDoRRIvYf@lunn.ch>
 <20210603194853.ngz4jdso3kfncnj4@pali>
 <AM6PR04MB3976B62084EC462BA02F0C4CEC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <20210604192732.GW30436@shell.armlinux.org.uk>
 <AM6PR04MB39768A569CE3CC4EC61A8769EC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <YLqLzOltcb6jan+B@lunn.ch>
 <AM6PR04MB39760B986E86BA9169DEECC5EC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <20210604233455.fwcu2chlsed2gwmu@pali>
 <20210605003306.GY30436@shell.armlinux.org.uk>
 <20210605122639.4lpox5bfppoyynl3@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210605122639.4lpox5bfppoyynl3@skbuf>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Saturday 05 June 2021 15:26:39 Vladimir Oltean wrote:
> On Sat, Jun 05, 2021 at 01:33:07AM +0100, Russell King (Oracle) wrote:
> > It started out as described - literally, 1000base-X multiplied by 2.5x.
> > There are setups where that is known to work - namely GPON SFPs that
> > support 2500base-X. What that means is that we know the GPON SFP
> > module negotiates in-band AN with 2500base-X. However, we don't know
> > whether the module will work if we disable in-band AN.
> 
> Pardon my ignorance, but what is inside a GPON ONT module? Just a laser
> and some amplifiers? So it would still be the MAC PCS negotiating flow
> control with the remote link partner? That's a different use case from a
> PHY transmitting the negotiated link modes to the MAC.

Hello Vladimir! All GPON ONU/ONT SFP modules which I have tested, are
fully featured mini computers. It is some SoC with powerful CPU, fiber
part, at least two NICs and then two phys, one for fiber part and one
for "SFP"-part (in most cases 1000base-x or 2500base-x). On SoC inside
is running fully featured operating system, in most cases Linux kernel
2.6.3x and tons of userspace applications which implements "application"
layer of GPON protocol -- the most important part. If OEM vendor of GPON
SFP stick did not locked it, you can connect to this "computer" via
telnet or web browser and configure some settings, including GPON stuff
and also how GPON network is connected to SFP part -- e.g. it can be
fully featured IPv4 router with NAT or just plain bridge mode where
"ethernet data packets" (those which are not part of ISP configuration
protocol) are pass-throw to SFP phy 1000base-x to host CPU. GPON is not
ethernet, it is some incompatible and heavily layered extension on ATM.
Originally I thought that ATM is long ago dead (as I saw it in used last
time in ADSL2) but it is still alive and cause issues... I think it does
not use 8b/10b encoding and therefore cannot be directly mapped to
1000base-x. Also GPON uses different wavelengths for inbound and
outbound traffic. And to make it even more complicated it uses totally
nonstandard asynchronous speeds, inbound is 2488.32Mbit/s, outbound is
1244.16Mbit/s. So I guess CPU/SoC with GPON support (something which is
inside that GPON ONU/ONT stick) must use totally different modes for
which we do not have any option in DTS yet.

So once mainline kernel will support these "computers" with GPON support
it would be required to define new kind of phy modes... But I do not
think it happens and all OEM vendors are using 2.6.3x kernels their
userspace GPON implementation is closed has tons of secrets.
