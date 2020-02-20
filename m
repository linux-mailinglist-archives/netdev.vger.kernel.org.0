Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6459166144
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 16:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728578AbgBTPpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 10:45:39 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:33528 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728558AbgBTPph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 10:45:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Er5b7C2Vg0sKMqzkkYNh7tRlDo858FST+Onhm5yHUqE=; b=AKMGM5iNZgniau8cfoh3/v3d9
        Ntg3V1cmIix8ZKpzx9XcjW5DOvtiOzOOf1oEsQsbMx97tHnG0wLjEqMOqEJex/Td/72W22lIqAWOU
        DLEPaN558TMLEh8Ne0/P6f0kbKYcRxQ6Dcjrez4cQYAY4ArmX2nXQvxp/dSBQyc2YobPBMSi/tETh
        aMwRqOHwox4hIHl41wlVf2OzotNBp3CPNwj/tCLz/4efZx9rN6lmqf266PKlqSEiyOV+KaYUT/9nD
        +898bu8nfV31ioSQU+F7jPwNbBdGX730M+pDuHGqjM2le6GH+jKIeyb3Cp1zbKhIJH+KBsFILqZYW
        7+3tcuAdw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54584)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j4o0z-00046k-AT; Thu, 20 Feb 2020 15:45:25 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j4o0v-0002di-Q3; Thu, 20 Feb 2020 15:45:21 +0000
Date:   Thu, 20 Feb 2020 15:45:21 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Joel Johnson <mrjoel@lixil.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Baruch Siach <baruch@tkos.co.il>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Rob Herring <robh@kernel.org>, netdev@vger.kernel.org
Subject: Re: mvneta: comphy regression with SolidRun ClearFog
Message-ID: <20200220154521.GB25745@shell.armlinux.org.uk>
References: <af7602ae737cbc21ce7f01318105ae73@lixil.net>
 <20200219092227.GR25745@shell.armlinux.org.uk>
 <8099d231594f1785e7149e4c6c604a5c@lixil.net>
 <20200220101232.GU25745@shell.armlinux.org.uk>
 <9c61fda15f89a69989c0d80fda33ea47@lixil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c61fda15f89a69989c0d80fda33ea47@lixil.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 20, 2020 at 08:34:07AM -0700, Joel Johnson wrote:
> On 2020-02-20 03:12, Russell King - ARM Linux admin wrote:
> > On Wed, Feb 19, 2020 at 06:49:51AM -0700, Joel Johnson wrote:
> > > On 2020-02-19 02:22, Russell King - ARM Linux admin wrote:
> > > > On Tue, Feb 18, 2020 at 10:14:48PM -0700, Joel Johnson wrote:
> > > > Does debian have support for the comphy enabled in their kernel,
> > > > which is controlled by CONFIG_PHY_MVEBU_A38X_COMPHY ?
> > > 
> > > Well, doh! I stared at the patch series for way to long, but the added
> > > Kconfig symbol failed to register mentally somehow. I had been using
> > > the
> > > last known good Debian config with make olddefconfig, but it obviously
> > > wasn't included in earlier configs and not enabled by default.
> > > 
> > > Many thanks to you and Willy Tarreau for pointing out my glaring
> > > omission!
> > 
> > Thanks for letting us know that you've fixed it now.
> 
> Sure thing, I've submitted a Debian patch, and was pointed to an existing
> Debian bug with the same issue and patch, so hopefully that will get
> incorporated soon. I'll also keep an eye on OpenWRT when they move to an
> affected kernel version to make sure it's included.
> 
> One lingering question that wasn't clear to me is the apparent inconsistency
> in default enablement for PHYs in drivers/phy/marvell/Kconfig. Is there a
> technical reason why PHY_MVEBU_A3700_COMPHY defaults to 'y' but
> PHY_MVEBU_A38X_COMPHY (and PHY_MVEBU_CP110_COMPHY) default to 'n', or is it
> just an artifact of being added at different times? Similarly, is there a
> reason that PHY_MVEBU_A3700_COMPHY and PHY_MVEBU_A3700_UTMI default to 'y'
> instead of 'm' for all ARCH_MVEBU builds? In my testing, building with
> PHY_MVEBU_A38X_COMPHY as a module still seemed to autoload the module as
> needed on boot, so modules for different platforms seems off-hand more
> lightweight that building the driver in for all MVEBU boards which don't use
> all drivers.
> 
> With the current defaults, it seems like PHY_MVEBU_CP110_COMPHY may be
> affected in Debian the same way as PHY_MVEBU_A38X_COMPHY, but I don't have
> available Armada 7K/8K hardware yet to confirm.

There is no clear answer to whether should something default to Y,
M or N - different people have different ideas and different levels
of frustration with which-ever are picked.

The root problem is that there are way too many configuration
options that it's become quite time consuming to put together the
proper kernel configuration for any particular platform, and things
get even more interesting when it comes to a kernel supporting
multiple platforms, where one may wish to avoid having a huge
kernel image, but want to use modules for the platform specific
bits.

I wonder whether we ought to be considering something like:

menuconfig ARCH_MVEBU_DEFAULTS
	tristate "Marvell Engineering Business Unit (MVEBU) SoCs"

config ARCH_MVEBU
	def_bool y if ARCH_MVEBU_DEFAULTS
	...

and then have mvebu drivers default to the state of
ARCH_MVEBU_DEFAULTS.  That means, if you want to build the
platform with modular drivers, or built-in drivers there's one top
level config that will default all the appropriate options that way,
and any new drivers added later can pick up on the state of that
option.

Just a thought.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
