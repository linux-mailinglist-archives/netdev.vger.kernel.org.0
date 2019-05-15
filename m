Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5817F1F85D
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 18:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbfEOQTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 12:19:39 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:54138 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725953AbfEOQTj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 12:19:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Oay0ZFYK+qpJY6IgxZktlnKYzLz9OzYOEg6wDi+Wcuk=; b=hAVNI8nURzhgvpwtARoZaw6Z1
        mSpsFXBreZfCjuGLpBrglEnE0aJf05IECVKVv95UYYrToC2lE1NC2eeeN8qsOsB298uEmccLQAM8O
        O3oRajzUEr1NgrjMvVn2wxX6yyBH9dZr+bS+3tyFNQAXHJ3x4WW43MQER0nzYa4px00l+nv9wQg7o
        hG8j6hlfDX2WuXaxLvFKZAY+uWpkxdrsUAGSoF/Uxj8bUKbzpJU3Jz9QZZsP8Pi0dy5+3dVru0puV
        6HHUGbUnvZiaU1XrP+hI5K2x4dDzAEVmad0HDUnNhpE9nEC+WSDnF2nafO7VyO9kelemOoR7FxQ01
        /lQSgL+4w==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:55794)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hQwcu-0005BF-Vw; Wed, 15 May 2019 17:19:33 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hQwct-0000ZF-GQ; Wed, 15 May 2019 17:19:31 +0100
Date:   Wed, 15 May 2019 17:19:31 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: dsa: using multi-gbps speeds on CPU port
Message-ID: <20190515161931.ul2fmkfxmyumfli5@shell.armlinux.org.uk>
References: <20190515143936.524acd4e@bootlin.com>
 <20190515132701.GD23276@lunn.ch>
 <20190515160214.1aa5c7d9@bootlin.com>
 <35daa9e7-8b97-35dd-bc95-bab57ef401cd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35daa9e7-8b97-35dd-bc95-bab57ef401cd@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 15, 2019 at 09:09:26AM -0700, Florian Fainelli wrote:
> Vladimir mentioned a few weeks ago that he is considering adding support
> for PHYLIB and PHYLINK to run without a net_device instance, you two
> should probably coordinate with each other and make sure both of your
> requirements (which are likely the same) get addressed.

I don't see how that's sane unless we just replace the "netdevice" in
there with an opaque "void *" and lose the typechecking.

That then means we'd need to eradicate all the messages therein, since
we can't use netdev_*() functions to print.

Then there's the patches I still have, that were rejected, and have had
no progress to get SFP working on 88x3310 - I'm just not bothering to
push them due to the rejection, and the lack of any ideas how to
approach this problem.  So we have the Macchiatobin which has now been
around for quite some time with SFP+ slots that are not particularly
functional with mainline kernels (but hey, I don't care, because they
work for me, because I have the patches that work!)

You all know where that is, I've tried pointing it out several times...

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
