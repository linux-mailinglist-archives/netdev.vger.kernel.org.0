Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99C11489D3
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 19:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfFQRQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 13:16:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33944 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726005AbfFQRQZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 13:16:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=aShAcX1ffuYf6Z5/DgVB3utR2HkNASrMTMIer3eKoF8=; b=gaCazfKZMl0BC6BUVPomKGyfAZ
        s6TI55qr35Q6XghIVDlGxKCEOv/walOrXr1ZKZT1cYR3etwygW6HXcZCs88LWDjBiBBYFkv7ya7D1
        4PtdlSTIZdCwToEy880BPrroh7PTWFuTP5mIZbogQzCF7wWEFbVOlJ122p2YrYl4wXSE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hcvEr-0002Ac-Fy; Mon, 17 Jun 2019 19:16:13 +0200
Date:   Mon, 17 Jun 2019 19:16:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Jean Delvare <jdelvare@suse.com>, linux-hwmon@vger.kernel.org
Subject: Re: [PATCH V2] net: phy: tja11xx: Add IRQ support to the driver
Message-ID: <20190617171613.GJ17551@lunn.ch>
References: <4f33b529-6c3c-07ee-6177-2d332de514c6@denx.de>
 <cc8db234-4534-674d-eece-5a797a530cdf@gmail.com>
 <ca63964a-242c-bb46-bd4e-76a270dbedb3@denx.de>
 <20190528195806.GV18059@lunn.ch>
 <15906cc0-3d8f-7810-27ed-d64bdbcfa7e7@denx.de>
 <20190528212252.GW18059@lunn.ch>
 <fe6c4f2f-812d-61b8-3ffb-7ed7dd89d151@denx.de>
 <20190529232930.GF18059@lunn.ch>
 <19f9e596-5b51-8c76-396e-572d3e8da463@denx.de>
 <f9bb1f48-b69d-09b2-5b48-e3f09ce9107e@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9bb1f48-b69d-09b2-5b48-e3f09ce9107e@denx.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 05:42:53PM +0200, Marek Vasut wrote:
> On 5/30/19 1:46 AM, Marek Vasut wrote:
> > On 5/30/19 1:29 AM, Andrew Lunn wrote:
> >> On Tue, May 28, 2019 at 11:33:33PM +0200, Marek Vasut wrote:
> >>> On 5/28/19 11:22 PM, Andrew Lunn wrote:
> >>>>> The link detection on the TJA1100 (not TJA1101) seems unstable at best,
> >>>>> so I better use all the interrupt sources to nudge the PHY subsystem and
> >>>>> have it check the link change.
> >>>>
> >>>> Then it sounds like you should just ignore interrupts and stay will
> >>>> polling for the TJA1100.
> >>>
> >>> Polling for the link status change is slow(er) than the IRQ driven
> >>> operation, so I would much rather use the interrupts.
> >>
> >> I agree about the speed, but it seems like interrupts on this PHY are
> >> not so reliable. Polling always works. But unfortunately, you cannot
> >> have both interrupts and polling to fix up problems when interrupts
> >> fail. Your call, do you think interrupts really do work?
> > 
> > It works fine for me this way. And mind you, it's only the TJA1100
> > that's flaky, the TJA1101 is better.
> > 
> >> If you say that tja1101 works as expected, then please just use the
> >> link up/down bits for it.
> > 
> > I still don't know which bits really trigger link status changes, so I'd
> > like to play it safe and just trigger on all of them.
> 
> So what do we do here ?

Hi Marek

My personal preference would be to just enable what is needed. But
I won't block a patch which enables everything.

  Andrew
