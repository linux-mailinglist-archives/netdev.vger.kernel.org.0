Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 826E039F238
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 11:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbhFHJ0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 05:26:45 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:57863 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhFHJ0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 05:26:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1623144292; x=1654680292;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4GZRJHVIFtSMABP8UBPCOQ8fkASHAEgbyI3U0o++cUo=;
  b=jCd2O1SU1Og+YmdUimDmGpgwaPk4SWV3yRbdtI0d2XbH4MEZPSJ01cHu
   konyL6YJ2crI7D92LVWTnQT6Pws3RNwdhPg521WasUihOmDyyvjNZu2+9
   QQoskOJzj5806FQLT3SUVCh/2R7w8aQCV8FYah+S9jgdtM+ylgJfrH90T
   fIEby/vx/DGYSFYF+ZCRLOXmM6taRmFyr77+pNa6AAROQR2lrkVexm5vC
   CID+QPXmHuhmjeYHFVJElQlCw4lV0NAmlRSIcdoc2Yf8KEMTAMUvFHX0r
   VKbtI1F0owayBGOwa/TP2CFGp7Okwup4kPgF2/elIqb+UW8zB3OyY/2W+
   g==;
IronPort-SDR: iDLBmDMo95+y4vEww1tRm53c/XaBH8pkm0X23LvpmXhjvUHTXQbyY8NLGU+aW7I4Ddzc6/qTvt
 ZbQ1anfGbdzNzUOGz46e88EyGh1ykX+itKaWJm01xuIDwty9S+S8gC7DBEJgikDnRdNIULGmq9
 HVlZOageaKxK4Sty55Xox5Q9LyxAzEzHOkH+riZDkZK+Pd30TZ6LlStQWjR9e5xY65DrGwTwDE
 1UxYOCdMAZGQnuhSK8CsijyWWUN6HRfOFwRWlaBihRHEAmootV0+8X9ieE4tjvDb2Z36TJW0G4
 kRQ=
X-IronPort-AV: E=Sophos;i="5.83,257,1616482800"; 
   d="scan'208";a="58192265"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Jun 2021 02:24:51 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 8 Jun 2021 02:24:51 -0700
Received: from den-her-m31857h.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Tue, 8 Jun 2021 02:24:47 -0700
Message-ID: <f9b254936d21ea1cc13f174525a97847378afef4.camel@microchip.com>
Subject: Re: [PATCH net-next v3 03/10] net: sparx5: add hostmode with
 phylink support
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Simon Horman" <simon.horman@netronome.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Date:   Tue, 8 Jun 2021 11:24:46 +0200
In-Reply-To: <20210607153522.GG22278@shell.armlinux.org.uk>
References: <20210604085600.3014532-1-steen.hegelund@microchip.com>
         <20210604085600.3014532-4-steen.hegelund@microchip.com>
         <20210607091536.GA30436@shell.armlinux.org.uk>
         <9f4fad323e17c8ba6ebde728fcc99c87dd06fc75.camel@microchip.com>
         <20210607130924.GE22278@shell.armlinux.org.uk>
         <7abe6b779c1432d9dfd2fc791d70c9443caec066.camel@microchip.com>
         <20210607153522.GG22278@shell.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

Thanks for your comments,

On Mon, 2021-06-07 at 16:35 +0100, Russell King (Oracle) wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Mon, Jun 07, 2021 at 05:12:07PM +0200, Steen Hegelund wrote:
> > Hi Russell,
> > 
> > Thanks for your comments,
> > 
> > On Mon, 2021-06-07 at 14:09 +0100, Russell King (Oracle) wrote:
> > > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > > 
> > > On Mon, Jun 07, 2021 at 02:45:01PM +0200, Steen Hegelund wrote:
> > > > Hi Russell,
> > > > 
> > > > Thanks for your comments.
> > > > 
> > > > On Mon, 2021-06-07 at 10:15 +0100, Russell King (Oracle) wrote:
> > > > > 3) I really don't get what's going on with setting the port mode to
> > > > >    2500base-X and 1000base-X here when state->interface is 10GBASER.
> > > > 
> > > > The high speed interfaces (> 2.5G) do not support any in-band signalling, so the only way
> > > > that
> > > > e.g a
> > > > 10G interface running at 2.5G will be able to link up with its partner is if both ends
> > > > configure
> > > > the
> > > > speed manually via ethtool.
> > > 
> > > We really should not have drivers hacking around in this way. If we want
> > > to operate in 2500base-x or 1000base-x, then that is what phylink should
> > > be telling the MAC driver. The MAC driver should not be making these
> > > decisions in its mac_config() callback. Doing so makes a joke of kernel
> > > programming.
> > 
> > I have this scenario where two Sparx5 Devices are connected via a 25G DAC cable.
> > Sparx5 Device A has the cable connected to one of its 25G Serdes devices, but Sparx5 Device B
> > has
> > the cable connected to one of its 10G Serdes devices.
> > 
> > By default the Sparx5 A device will configure the link to use a speed of 25G, but the Sparx5
> > device
> > B will configure the link speed to 10G, so the link will remain down, as the two devices cannot
> > communicate.
> > 
> > So to fix this the user will have to manually change the speed of the link on Device A to be 10G
> > using ethtool.
> > 
> > I may have misunderstood the usage of the mac_config callback, but then where would the driver
> > then
> > use the speed information from the user to configure the Serdes?
> 
> How is this any different to the situation that we have on SolidRun
> Clearfog platforms and the Macchiatobin where we have a SFP port
> capable of 2500base-X and 1000base-X. If we plug in a 4.3Gbps
> fiberchannel SFP, the port is able to run at either of those speeds.
> 
> We can control this via ethtool, changing between the two modes by
> either forcing the speed to either 1000 or 2500, or switching the
> "advertisement" between 1000base-X or 2500base-X - we enforce that
> only one of these can be advertised at any one time. The switching
> between them happens in the ->validate callback, but that may change
> in the future (especially as there has been a report that making
> this decision in ->validate causes some issues in a particular usage
> scenarios.) It seems we need to solve that basic issue first, and
> then expand it to cater for the case you have.
> 
> Phylink expects that the *_config and link_up callbacks are a "do
> what I say" setup; they don't expect MAC or PCS drivers to start
> making their own decisions at that point - because then the state
> known to phylink and the actual hardware setup then differ.

I will change the implementation to use the PCS operations, add the 25GBASER value and avoid making
any phy_interface_t mode changes in the config function.

But it looks like there is a general need for adjusting the phy_interface_t value (and the mode
bits) based on ethtool input like speed (similar to what the phylink_helper_basex_speed function
does), also for the nBASER case, so that would be a useful addition to phylink, to support some of
the usecases we have.

Should I add the phylink_helper_basex_speed call to the implementation now?

> 
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!


-- 
BR
Steen

-=-=-=-=-=-=-=-=-=-=-=-=-=-=
steen.hegelund@microchip.com


