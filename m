Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14A46129755
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 15:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfLWOay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 09:30:54 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:41708 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726777AbfLWOay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 09:30:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=pdZ3BuuxpVapCxvBdAVMUi9tPzHQHaYDwu490xXxIf0=; b=Kd0+4lqGJwmug40BnNtP3IgP7
        aonsKBkyDdA6wQs/C3uABhYtqwSvmK2Pagd/LOHthiyBniuIbkf09knaLSaNwCOrWUWSVvltBDBbl
        0ETptaMupAmlsftbwlKPCObdZDZJb9DXZxfqLqHAf6vL+g8yfJS74gW8ydUzJsJaRHeK5p00a9d2A
        w0ymxhV7Ukbkz7Y+AMxFPDHfI/9/qZxGY6d1TZ0GsVQtUWuPC/mpt6BvqGyRSeSsxcLFwrvJq9cnk
        StfTYTcCDqpenzwCqp4U5VtXmLCe2Cv5ghi1uW3gTikwcVSNFdChx4HD3Z2V4ZcwvFTeiKgFiIOGv
        udEAGpIuQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:45290)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ijOjO-0002ML-J0; Mon, 23 Dec 2019 14:30:46 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ijOjK-0000sn-HR; Mon, 23 Dec 2019 14:30:42 +0000
Date:   Mon, 23 Dec 2019 14:30:42 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Madalin Bucur <madalin.bucur@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
Message-ID: <20191223143042.GQ25745@shell.armlinux.org.uk>
References: <1576768881-24971-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1576768881-24971-2-git-send-email-madalin.bucur@oss.nxp.com>
 <20191219172834.GC25745@shell.armlinux.org.uk>
 <VI1PR04MB5567FA3170CF45F877870E8CEC520@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <20191223120730.GO25745@shell.armlinux.org.uk>
 <20191223134634.GL32356@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191223134634.GL32356@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 23, 2019 at 02:46:34PM +0100, Andrew Lunn wrote:
> > Given that meeting these electrical characteristics involves the
> > effects of the board, and it is impractical for a board to switch
> > between different electrical characteristics at runtime (routing serdes
> > lanes to both a SFP+ and XFP cage is impractical due to reflections on
> > unterminated paths) I really don't see any reason why we need two
> > different phy_interface_t definitions for these.  As mentioned, the
> > difference between XFI and SFI is electrical, and involves the board
> > layout, which is a platform specific issue.
> 
> Hi Russell
> 
> So we make phy_interface_t define the protocol. We should clearly
> document that.

I really think so.

> Are we going to need another well defined DT property for the
> electrical interface? What is where we have XFI and SFI, etc?

It is conceivable that board firmware or a serdes driver needs to know
what settings to apply, but I think we need to think long and hard
about that. As I've pointed out, it's probably not going to be a one
size fits all thing, because the properties of the PCB come into play.

On the Armada 8040, the electrical configuration is part of the comphy
block. The kernel does contain code to configure it using fixed
settings, but that is just a fallback when there is no support in the
ATF firmware. ATF firmware added support, and I know that the
Macchiatobin support has different electrical values for the 10G
Ethernet ports compared to the Marvell default - because I did a lot
of reverse engineering with the poor Marvell documentation to figure
out how to get an eye diagram out of the hardware, and used that to
improve the reliability of the SFP+ ports on the Macchiatobin single
shot and GT-8k boards.

Marvell implemented automatic comphy tuning in u-boot/firwmare, which
improves the performance of comphy on Marvell's hardware, but actually
ends up making things worse on the Macchiatobin platforms compared to
my hand-tuned parameters, with errors and link failures becoming
common.

There are multiple parameters that need to be configured, it isn't
a simple "just use XFI" or "just use SFI" settings.

Given that the electrical parameters are board dependent, they can
even be interface dependent if a board has several different
interfaces, so what is compliant for XFI on one port may not be
compliant for XFI on a different port. Different routing of the
Serdes lines may mean crosstalk is different, or different trace
capacitance needing different emphasis settings.

What I'm getting at is, basically, I don't think a one-size-fits-all
"XFI" or "SFI" specifier makes any sense what so ever.

I also can't think how we'd generalise it - the parameters required
to set the serdes hardware are likely to be implementation dependent.
If you've ever looked at Marvell's COMPHY documentation, it has a
hundred or more registers controlling all sorts of different serdes
parameters, some of them in the analogue domain others in the digital
domain. Some FFE, CTLE, DFE etc parameters - and many without
anything but a brief description of the register.

There are some simpler implementations too.  For example, SATA is
another example of serdes, and just like XFI and SFI, it also has
its own specifications for the electrical side... and then there's
eSATA as well.  For the eSATA port on the Cubox-i, I ended up with:

        fsl,transmit-level-mV = <1104>;
        fsl,transmit-boost-mdB = <0>;
        fsl,transmit-atten-16ths = <9>;
        fsl,no-spread-spectrum;

which I arrived at by blind analysis and successive approximation,
and was later confirmed to be correct when Rabeeh eventually got
around to proving the eye mask. I doubt that having an "eSATA" vs
"SATA" mode setting for the driver would have worked: just as I'm
saying for XFI vs SFI, the correct set of parameters for one platform
is likely not correct for another platform.

So, I think it's up to the serdes/comphy/firmware to figure out how
to configure the electrical properties for a serdes lane to meet the
specification for the _platform_ in question, including where it gets
the data for that configuration, be it from DT or board firmware.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
