Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE4C2FDEEE
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 02:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728214AbhAUA4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 19:56:02 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:51172 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731354AbhAUACT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 19:02:19 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l2NPd-001iuK-A0; Thu, 21 Jan 2021 01:01:21 +0100
Date:   Thu, 21 Jan 2021 01:01:21 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        davem@davemloft.net, jacob.e.keller@intel.com, roopa@nvidia.com,
        mlxsw@nvidia.com
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <YAjEUdYnGSPjZSy5@lunn.ch>
References: <20210113121222.733517-1-jiri@resnulli.us>
 <X/+nVtRrC2lconET@lunn.ch>
 <20210119115610.GZ3565223@nanopsycho.orion>
 <YAbyBbEE7lbhpFkw@lunn.ch>
 <20210120083605.GB3565223@nanopsycho.orion>
 <YAg2ngUQIty8U36l@lunn.ch>
 <20210120154158.206b8752@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210120154158.206b8752@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 03:41:58PM -0800, Jakub Kicinski wrote:
> On Wed, 20 Jan 2021 14:56:46 +0100 Andrew Lunn wrote:
> > > No, the FW does not know. The ASIC is not physically able to get the
> > > linecard type. Yes, it is odd, I agree. The linecard type is known to
> > > the driver which operates on i2c. This driver takes care of power
> > > management of the linecard, among other tasks.  
> > 
> > So what does activated actually mean for your hardware? It seems to
> > mean something like: Some random card has been plugged in, we have no
> > idea what, but it has power, and we have enabled the MACs as
> > provisioned, which if you are lucky might match the hardware?
> > 
> > The foundations of this feature seems dubious.
> 
> But Jiri also says "The linecard type is known to the driver which
> operates on i2c." which sounds like there is some i2c driver (in user
> space?) which talks to the card and _does_ have the info? Maybe I'm
> misreading it. What's the i2c driver?

Hi Jakub

A complete guess, but i think it will be the BMC, not the ASIC. There
have been patches from Mellanox in the past for a BMC, i think sent to
arm-soc, for the ASPEED devices often used as BMCs. And the BMC is
often the device doing power management. So what might be missing is
an interface between the driver and the BMC. But that then makes the
driver system specific. A OEM who buys ASICs and makes their own board
could have their own BMC running there own BMC firmware.

All speculation...

      Andrew
