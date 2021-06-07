Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3A039DD4F
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 15:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbhFGNL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 09:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbhFGNL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 09:11:28 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 987C9C061766;
        Mon,  7 Jun 2021 06:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=vbgOzbtmK58ivP99PkrwPY3SZvVaeQG4u1eF2Jf+fZY=; b=OcCrKMaH36LqXSa70uu0yk6vd
        Zij7bwVolkc0d3fTU3An7/IFuQpoTo51lQ9PuQSvtPbY6/W2NbtvUEtowi4YVn7bQWXqeBtT35D3D
        aRHX+OukHQLa0wbUkSdiJw9jrM1x+uu37vqWwAu9mIF1njMIpV4tNQu/nnjNJ01yXYpzuWerxFNdt
        IEpbaTY7+R5C496dIX5KdDB2Honj/5yeBY4tDv5sz9eBvl/EYVez1hUVKqHoadDi98xrroDC8aDXz
        SFRUogOzph3IeUZS2NfK718XYkUWSuq2Y3Rh1vcHvfL6n+tZUds2W6xDc2+VCm/thYFtCMYP+lgVZ
        Ue0vwJVFg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44792)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lqF0R-0000XY-5z; Mon, 07 Jun 2021 14:09:27 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lqF0O-0005x1-LV; Mon, 07 Jun 2021 14:09:24 +0100
Date:   Mon, 7 Jun 2021 14:09:24 +0100
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
Message-ID: <20210607130924.GE22278@shell.armlinux.org.uk>
References: <20210604085600.3014532-1-steen.hegelund@microchip.com>
 <20210604085600.3014532-4-steen.hegelund@microchip.com>
 <20210607091536.GA30436@shell.armlinux.org.uk>
 <9f4fad323e17c8ba6ebde728fcc99c87dd06fc75.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f4fad323e17c8ba6ebde728fcc99c87dd06fc75.camel@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 07, 2021 at 02:45:01PM +0200, Steen Hegelund wrote:
> Hi Russell,
> 
> Thanks for your comments.
> 
> On Mon, 2021-06-07 at 10:15 +0100, Russell King (Oracle) wrote:
> > 3) I really don't get what's going on with setting the port mode to
> >    2500base-X and 1000base-X here when state->interface is 10GBASER.
> 
> The high speed interfaces (> 2.5G) do not support any in-band signalling, so the only way that e.g a
> 10G interface running at 2.5G will be able to link up with its partner is if both ends configure the
> speed manually via ethtool.

We really should not have drivers hacking around in this way. If we want
to operate in 2500base-x or 1000base-x, then that is what phylink should
be telling the MAC driver. The MAC driver should not be making these
decisions in its mac_config() callback. Doing so makes a joke of kernel
programming.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
