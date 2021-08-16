Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D91EB3ECD82
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 06:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbhHPEPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 00:15:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51292 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229485AbhHPEPi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 00:15:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=TgYp5KlBgM6ihg6kSt0vs/POhvksb9iqkijafDTebMQ=; b=hneJA1oyFY4QN5sD+5+RwTgulP
        sVqvKWdDiatyOWsPaikLvbGx51TuWsFAFCxRxH/+qupxgToaZD2wNVpZHAw2cSEwBSd6s3VN6vHFH
        9bgTmsaTIKn7eAR+YCdppY8eWhEsnmgD/IHj0wp7gUPv8Yv87O0lC3qJj1ZqYsZQ3zpU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mFU1e-000KnF-UU; Mon, 16 Aug 2021 06:15:02 +0200
Date:   Mon, 16 Aug 2021 06:15:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Song, Yoong Siang" <yoong.siang.song@intel.com>
Cc:     Russell King <linux@armlinux.org.uk>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 1/1] net: phy: marvell10g: Add WAKE_PHY support
 to WOL event
Message-ID: <YRnmRp92j7Qpir7N@lunn.ch>
References: <20210813084536.182381-1-yoong.siang.song@intel.com>
 <20210814172656.GA22278@shell.armlinux.org.uk>
 <YRgFxzIB3v8wS4tF@lunn.ch>
 <20210814194916.GB22278@shell.armlinux.org.uk>
 <PH0PR11MB4950652B4D07C189508767F1D8FD9@PH0PR11MB4950.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR11MB4950652B4D07C189508767F1D8FD9@PH0PR11MB4950.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 03:52:06AM +0000, Song, Yoong Siang wrote:
> > > Agreed. If the interrupt register is being used, i think we need this
> > > patchset to add proper interrupt support. Can you recommend a board
> > > they can buy off the shelf with the interrupt wired up? Or maybe Intel
> > > can find a hardware engineer to add a patch wire to link the interrupt
> > > output to a SoC pin that can do interrupts.
> > 
> > The only board I'm aware of with the 88x3310 interrupt wired is the
> > Macchiatobin double-shot. :)
> > 
> > I forget why I didn't implement interrupt support though - I probably need to
> > revisit that. Sure enough, looking at the code I was tinkering with, adding
> > interrupt support would certainly conflict with this patch.
> 
> Hi Russell,
> 
> For EHL board, both WoL interrupt and link change interrupt are the same pin.
> Based on your knowledge, is this common across other platforms?

Other PHYs? Yes. WoL is just another interrupt, and any interrupt can
wake the system, so longer as the interrupt controller can actually wake the system.

> Can we take set wol function as one of the ways to control the
> interrupts?

WOl does not control the interrupt, it is an interrupt source. And you
need to service it as an interrupt. So long as your PMC is also an
interrupt controller, it should all work.

	  Andrew
