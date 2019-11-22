Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 043C51068BE
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 10:22:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfKVJWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 04:22:02 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:42370 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbfKVJWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 04:22:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=SWbmUilvZWyu9G5awdEU2KvPZeq3aeg+c1C4lJEnjoo=; b=an41Zr2/uNxSIUfMI75HmnIqV
        Gdh4kdDw4HAonLEtaGjxH9/njeLzh1GpRZf0SdfF3fR2JOqSPElZfwlBFHwa/As7LqES2oxUVPEgq
        lddNaJanCjc5wYIDGjIC6vp/7cs3bWV0EO6UQnizW+CueuuyXnvdNQV/pi8CzUwU8DlC0rh6gDmZ1
        3czSPX/k0lEm6+tq7d/3jiRJ4d4qIWMKj98kTVi55jDe/fx0aIEp9e0NpBdiBblRVh8AqwC9lFmii
        C0NYYCbzgJdJnfp2kZxdu3CcqNMvAR7V2i6h4Fcg2aJSzTu3H2Np+acyCy0rAWe9S3KvME8OebaDh
        lt4WPkmBg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43048)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iY58L-000490-9z; Fri, 22 Nov 2019 09:21:45 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iY58D-0003Yo-1A; Fri, 22 Nov 2019 09:21:37 +0000
Date:   Fri, 22 Nov 2019 09:21:37 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     David Miller <davem@davemloft.net>, andrew@lunn.ch,
        nbd@openwrt.org, radhey.shyam.pandey@xilinx.com,
        alexandre.torgue@st.com, netdev@vger.kernel.org,
        sean.wang@mediatek.com, linux-stm32@st-md-mailman.stormreply.com,
        vivien.didelot@gmail.com, michal.simek@xilinx.com,
        joabreu@synopsys.com, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, thomas.petazzoni@bootlin.com,
        john@phrozen.org, matthias.bgg@gmail.com, peppe.cavallaro@st.com,
        Mark-MC.Lee@mediatek.com, mcoquelin.stm32@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [CFT PATCH net-next v2] net: phylink: rename mac_link_state() op
 to mac_pcs_get_state()
Message-ID: <20191122092136.GJ25745@shell.armlinux.org.uk>
References: <E1iXaSM-0004t1-9L@rmk-PC.armlinux.org.uk>
 <20191121.191417.1339124115325210078.davem@davemloft.net>
 <0a9e016b-4ee3-1f1c-0222-74180f130e6c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a9e016b-4ee3-1f1c-0222-74180f130e6c@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 07:36:44PM -0800, Florian Fainelli wrote:
> 
> 
> On 11/21/2019 7:14 PM, David Miller wrote:
> > From: Russell King <rmk+kernel@armlinux.org.uk>
> > Date: Thu, 21 Nov 2019 00:36:22 +0000
> > 
> >> Rename the mac_link_state() method to mac_pcs_get_state() to make it
> >> clear that it should be returning the MACs PCS current state, which
> >> is used for inband negotiation rather than just reading back what the
> >> MAC has been configured for. Update the documentation to explicitly
> >> mention that this is for inband.
> >>
> >> We drop the return value as well; most of phylink doesn't check the
> >> return value and it is not clear what it should do on error - instead
> >> arrange for state->link to be false.
> >>
> >> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> >> ---
> >> This is something I'd like to do to make it clearer what phylink
> >> expects of this function, and that it shouldn't just read-back how
> >> the MAC was configured.
> >>
> >> This version drops the deeper changes, concentrating just on the
> >> phylink API rather than delving deeper into drivers, as I haven't
> >> received any feedback on that patch.
> >>
> >> It would be nice to see all these drivers tested with this change.
> > 
> > I'm tempted to just apply this, any objections?
> > 
> 
> Russell, which of this patch or: http://patchwork.ozlabs.org/patch/1197425/
> 
> would you consider worthy of merging?

Let's go with v2 for now - it gets the rename done with less risk that
there'll be a problem.  I can always do the remainder in a separate
patch after the merge window as a separate patch.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
