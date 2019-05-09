Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6791D1941A
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 23:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfEIVHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 17:07:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59631 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726108AbfEIVHs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 May 2019 17:07:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=frCvs1qzhj9Qb4HlDyfIcHca4ygcTGupbMC2qr5ruHg=; b=STgpJEkOtD3My/SXktlVs9DUmw
        SKdf3+IG3Z/JAAsaU4m+kDBLW3Q573Jo1vzKvF4PkjlhiPh7wkTI7uMDGm0V/oY1mXbI+uB8cJafG
        mwUZntGSICGhfsGAVAvJ/zdeogD2Il4r3qpIqV6AyQFPMK3BjpA+S/8fSmg0X1NU1KB8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hOqGX-0005X4-KN; Thu, 09 May 2019 23:07:45 +0200
Date:   Thu, 9 May 2019 23:07:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Yuiko Oshino <yuiko.oshino@microchip.com>,
        netdev@vger.kernel.org, kernel@pengutronix.de
Subject: Re: net: micrel: confusion about phyids used in driver
Message-ID: <20190509210745.GD11588@lunn.ch>
References: <20190509202929.wg3slwnrfhu4f6no@pengutronix.de>
 <da599967-c423-80dd-945d-5b993c041e90@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <da599967-c423-80dd-945d-5b993c041e90@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 09, 2019 at 10:55:29PM +0200, Heiner Kallweit wrote:
> On 09.05.2019 22:29, Uwe Kleine-König wrote:
> > Hello,
> > 
> > I have a board here that has a KSZ8051MLL (datasheet:
> > http://ww1.microchip.com/downloads/en/DeviceDoc/ksz8051mll.pdf, phyid:
> > 0x0022155x) assembled. The actual phyid is 0x00221556.
> > 
> I think the datasheets are the source of the confusion. If the
> datasheets for different chips list 0x0022155x as PHYID each, and
> authors of support for additional chips don't check the existing code,
> then happens what happened.
> However it's not a rare exception and not Microchip-specific that
> sometimes vendors use the same PHYID for different chips.
> 
> And it seems you even missed one: KSZ8795
> It's a switch and the internal PHY's have id 0x00221550.
> 
> If the drivers for the respective chips are actually different then we
> may change the driver to match the exact model number only.
> However, if there should be a PHY with e.g. id 0x00221554 out there,
> it wouldn't be supported any longer and the generic PHY driver would
> be used (what may work or not).

Hi Heiner

We might also want to take a look at the code which matches a driver
to a PHY ID. Ideally we want the most specific match when looking at
the mask. We can then have device specific matches, and then a more
general fallback match using a wider mask.

No idea how to actually implement that :-(

   Andrew
