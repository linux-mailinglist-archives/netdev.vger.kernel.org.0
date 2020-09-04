Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00F6E25DAC6
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 15:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730536AbgIDN7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 09:59:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43008 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730504AbgIDN65 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 09:58:57 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kECEv-00DCfh-1Y; Fri, 04 Sep 2020 15:58:53 +0200
Date:   Fri, 4 Sep 2020 15:58:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, adam.rudzinski@arf.net.pl,
        m.felsch@pengutronix.de, hkallweit1@gmail.com,
        richard.leitner@skidata.com, zhengdejin5@gmail.com,
        devicetree@vger.kernel.org, kernel@pengutronix.de, kuba@kernel.org,
        robh+dt@kernel.org
Subject: Re: [PATCH net-next 0/3] net: phy: Support enabling clocks prior to
 bus probe
Message-ID: <20200904135853.GN3112546@lunn.ch>
References: <20200903043947.3272453-1-f.fainelli@gmail.com>
 <cc6fc0f6-d4ae-9fa1-052d-6ab8e00ab32f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc6fc0f6-d4ae-9fa1-052d-6ab8e00ab32f@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 03, 2020 at 09:04:11PM -0700, Florian Fainelli wrote:
> 
> 
> On 9/2/2020 9:39 PM, Florian Fainelli wrote:
> > Hi all,
> > 
> > This patch series takes care of enabling the Ethernet PHY clocks in
> > DT-based systems (we have no way to do it for ACPI, and ACPI would
> > likely keep all of this hardware enabled anyway).
> > 
> > Please test on your respective platforms, mine still seems to have
> > a race condition that I am tracking down as it looks like we are not
> > waiting long enough post clock enable.
> > 
> > The check on the clock reference count is necessary to avoid an
> > artificial bump of the clock reference count and to support the unbind
> > -> bind of the PHY driver. We could solve it in different ways.
> > 
> > Comments and test results welcome!
> 
> Andrew, while we figure out a proper way to support this with the Linux
> device driver model, would you be opposed in a single patch to
> drivers/net/mdio/mdio-bcm-unimac.c which takes care of enabling the PHY's
> clock during bus->reset just for the sake of getting those systems to work,
> and later on we move over to the pre-probe mechanism?
> 
> That would allow me to continue working with upstream kernels on these
> systems without carrying a big pile of patches.

We do have quite a need for the proper solution. I wouldn't want you
dropping the proper solution because you have a hack in place.

Please add a comment: "HORRIBLE TEMPORARY HACK", to give you
motivation to remove it again :-)

   Andrew
