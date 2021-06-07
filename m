Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A86DC39E0A5
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 17:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbhFGPh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 11:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbhFGPh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 11:37:27 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 212DEC061766;
        Mon,  7 Jun 2021 08:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=wiwtGBBtOy1eKpoT4ldaI9kf1JnbFr4Prhtmyk8X7b0=; b=hezBByk28dJaim4wWX//nPdaB
        eUXlFDKLe+deRHVKfwtzUOeomyD2iHvui3iOvQSon20CqOTBQuYfyz9b4v0VtZD6sNlpOrZT7WADq
        AxyfJKolzFtO1hyHI5QMAWQapr27gDeCVPnyI7LmaHh9Xm5Ia3xexNvqavASacapjme7jovGp3TKg
        /YlFhN346Go0o+5c2LWJKdkqlNW26GQ+rNba9pXwICkiXszuCl1BMQva+HXDP4luKSKT1M86+Zqej
        zVeopo78EaZLGUCfu7xiDcFnkhScATyD9+MsLuTuXLb/bywWYc7vbLfmlYPUHVwBUBnD2gVBNy5K0
        1IqiC09Sg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44796)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lqHHg-0000il-SR; Mon, 07 Jun 2021 16:35:24 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lqHHe-000627-G8; Mon, 07 Jun 2021 16:35:22 +0100
Date:   Mon, 7 Jun 2021 16:35:22 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Simon Horman <simon.horman@netronome.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: Re: [PATCH net-next v3 03/10] net: sparx5: add hostmode with phylink
 support
Message-ID: <20210607153522.GG22278@shell.armlinux.org.uk>
References: <20210604085600.3014532-1-steen.hegelund@microchip.com>
 <20210604085600.3014532-4-steen.hegelund@microchip.com>
 <20210607091536.GA30436@shell.armlinux.org.uk>
 <9f4fad323e17c8ba6ebde728fcc99c87dd06fc75.camel@microchip.com>
 <20210607130924.GE22278@shell.armlinux.org.uk>
 <7abe6b779c1432d9dfd2fc791d70c9443caec066.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7abe6b779c1432d9dfd2fc791d70c9443caec066.camel@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 07, 2021 at 05:12:07PM +0200, Steen Hegelund wrote:
> Hi Russell,
> 
> Thanks for your comments,
> 
> On Mon, 2021-06-07 at 14:09 +0100, Russell King (Oracle) wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > 
> > On Mon, Jun 07, 2021 at 02:45:01PM +0200, Steen Hegelund wrote:
> > > Hi Russell,
> > > 
> > > Thanks for your comments.
> > > 
> > > On Mon, 2021-06-07 at 10:15 +0100, Russell King (Oracle) wrote:
> > > > 3) I really don't get what's going on with setting the port mode to
> > > >    2500base-X and 1000base-X here when state->interface is 10GBASER.
> > > 
> > > The high speed interfaces (> 2.5G) do not support any in-band signalling, so the only way that
> > > e.g a
> > > 10G interface running at 2.5G will be able to link up with its partner is if both ends configure
> > > the
> > > speed manually via ethtool.
> > 
> > We really should not have drivers hacking around in this way. If we want
> > to operate in 2500base-x or 1000base-x, then that is what phylink should
> > be telling the MAC driver. The MAC driver should not be making these
> > decisions in its mac_config() callback. Doing so makes a joke of kernel
> > programming.
> 
> I have this scenario where two Sparx5 Devices are connected via a 25G DAC cable.
> Sparx5 Device A has the cable connected to one of its 25G Serdes devices, but Sparx5 Device B has
> the cable connected to one of its 10G Serdes devices.
> 
> By default the Sparx5 A device will configure the link to use a speed of 25G, but the Sparx5 device
> B will configure the link speed to 10G, so the link will remain down, as the two devices cannot
> communicate.
> 
> So to fix this the user will have to manually change the speed of the link on Device A to be 10G
> using ethtool.
> 
> I may have misunderstood the usage of the mac_config callback, but then where would the driver then
> use the speed information from the user to configure the Serdes?

How is this any different to the situation that we have on SolidRun
Clearfog platforms and the Macchiatobin where we have a SFP port
capable of 2500base-X and 1000base-X. If we plug in a 4.3Gbps
fiberchannel SFP, the port is able to run at either of those speeds.

We can control this via ethtool, changing between the two modes by
either forcing the speed to either 1000 or 2500, or switching the
"advertisement" between 1000base-X or 2500base-X - we enforce that
only one of these can be advertised at any one time. The switching
between them happens in the ->validate callback, but that may change
in the future (especially as there has been a report that making
this decision in ->validate causes some issues in a particular usage
scenarios.) It seems we need to solve that basic issue first, and
then expand it to cater for the case you have.

Phylink expects that the *_config and link_up callbacks are a "do
what I say" setup; they don't expect MAC or PCS drivers to start
making their own decisions at that point - because then the state
known to phylink and the actual hardware setup then differ.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
