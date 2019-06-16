Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3073F47403
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 11:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbfFPJmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 05:42:36 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:38694 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725888AbfFPJmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 05:42:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=EfrySKu19SISsRCiMT890kLcP5VO6QdbSWtZB5o1StI=; b=i3IhCPFBJr0BcpZASr7JAVg4Z
        7uJYk0sVjchEZYLsOHGPUAqIuHhrF6k708aQUeEU+eQNucR/WumEIVVZ8JoguyxUYBV8jD2ZZ9a1D
        4ded6TgWpZRDKtgg0XdWGc/4IZ71qlKBu63p8gzB6Rikz1cMfl2SuJbasafipuEyxKEbXU0I9gIu6
        vikU1jaM0ubaqE/VaDjvEY70Vbu7HsYS2nOfQxNaV8CnXPm0l1UHE8rHnBme8gshS1cF+00gqO0NU
        T2zEMUnDIk6ZbNABFFeo7deD15x5RYXBOVPlT7/JJGQYNK3FETzMLrUW02GL6XaWUxlXENF/U2uIk
        Uldue465A==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:56430)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hcRgD-0004sp-VY; Sun, 16 Jun 2019 10:42:30 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hcRgA-0003rx-Jj; Sun, 16 Jun 2019 10:42:26 +0100
Date:   Sun, 16 Jun 2019 10:42:26 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     David Miller <davem@davemloft.net>
Cc:     ioana.ciornei@nxp.com, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH] net: phylink: set the autoneg state in phylink_phy_change
Message-ID: <20190616094226.bnhivshhnzeokplu@shell.armlinux.org.uk>
References: <1560407871-5642-1-git-send-email-ioana.ciornei@nxp.com>
 <20190615.133021.572699563162351841.davem@davemloft.net>
 <20190615221328.4diebpopfzyfi4og@shell.armlinux.org.uk>
 <20190615.180854.999160704288745945.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190615.180854.999160704288745945.davem@davemloft.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 15, 2019 at 06:08:54PM -0700, David Miller wrote:
> From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> Date: Sat, 15 Jun 2019 23:13:28 +0100
> 
> > On Sat, Jun 15, 2019 at 01:30:21PM -0700, David Miller wrote:
> >> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> >> Date: Thu, 13 Jun 2019 09:37:51 +0300
> >> 
> >> > The phy_state field of phylink should carry only valid information
> >> > especially when this can be passed to the .mac_config callback.
> >> > Update the an_enabled field with the autoneg state in the
> >> > phylink_phy_change function.
> >> > 
> >> > Fixes: 9525ae83959b ("phylink: add phylink infrastructure")
> >> > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> >> 
> >> Applied and queued up for -stable, thanks.
> > 
> > This is not a fix; it is an attempt to make phylink work differently
> > from how it's been designed for the dpaa2 driver.  I've already stated
> > that this field is completely meaningless, so I'm surprised you
> > applied it.
> 
> I'm sorry, I did wait a day or so to see any direct responses to this
> patch and I saw no feedback.
> 
> I'll revert.

Hi Dave,

Thanks for the revert.  There was discussion surrounding this patch:

https://www.mail-archive.com/netdev@vger.kernel.org/thrd2.html#302220

It was then re-posted as part of a later RFC series ("DPAA2 MAC
Driver") which shows why the change was proposed, where the discussion
continued on Friday.  The patch ended up with a slightly different
subject line.

There is still further discussion required to try and work out a way
forward.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
