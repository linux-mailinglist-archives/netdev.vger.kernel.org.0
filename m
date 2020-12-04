Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B10432CEF16
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 14:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbgLDN4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 08:56:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbgLDN4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 08:56:40 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157BDC061A51;
        Fri,  4 Dec 2020 05:55:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=duzHGNybu0+/7CRkDtj2a0Fs85oO8ZX4hDmlm8XdAug=; b=jCpapWj+DOmYHHk456TEpRfkw
        t1QLxZAgSX0S0YtS+xzvxi7AyJPYh5kSiSuCQJVTSuksiLJL94uqByrIFGMqh1ti1N5BzFzgNLnyI
        uSJs8gIl0qSjHVebX6RvPMyFBPwf4q+aER0qT5jM6/el5cegStEcEZFQpLbnB1vvB6P2WOZu87lzT
        +UYrcFxVX0sUETEIV7hVlGbtmt5KDQnrykZ4eZpfSRDrHu3hUVguOgzynTU6K/WM/Gs1nvhMukbqG
        +bDH71IHQZZXBMbqVJiDMvTKep22xivdPlapV+cv2vV6yNWLTRwnHNUljha/lHBS8LcDGLNs8OhP2
        Din+6LL6A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:39692)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1klBYc-0004PB-LG; Fri, 04 Dec 2020 13:55:34 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1klBYb-0000iN-4v; Fri, 04 Dec 2020 13:55:33 +0000
Date:   Fri, 4 Dec 2020 13:55:33 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 3/4] phy: Add Sparx5 ethernet serdes PHY driver
Message-ID: <20201204135532.GK1551@shell.armlinux.org.uk>
References: <20201203103015.3735373-1-steen.hegelund@microchip.com>
 <20201203103015.3735373-4-steen.hegelund@microchip.com>
 <20201203215253.GL2333853@lunn.ch>
 <20201204134826.lnkdtj5nrygsngm2@mchp-dev-shegelun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201204134826.lnkdtj5nrygsngm2@mchp-dev-shegelun>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 02:48:26PM +0100, Steen Hegelund wrote:
> On 03.12.2020 22:52, Andrew Lunn wrote:
> > What i have not yet seen is how this code plugs together with
> > phylink_pcs_ops?
> > 
> > Can this hardware also be used for SATA, USB? As far as i understand,
> > the Marvell Comphy is multi-purpose, it is used for networking, USB,
> > and SATA, etc. Making it a generic PHY then makes sense, because
> > different subsystems need to use it.
> > 
> > But it looks like this is for networking only? So i'm wondering if it
> > belongs in driver/net/pcs and it should be accessed using
> > phylink_pcs_ops?
> > 
> >        Andrew
> 
> This is a PHY that communicates on a SerDes link to an ethernet PHY or a
> SFP. So I took the lead from earlier work: the Microsemi Ocelot SerDes driver,
> and added the Sparx5 SerDes PHY driver here since it is very similar in intent.
> It is not an ethernet PHY as such.

Okay, that is the normal situation in real hardware:

MAC <---> PCS PHY <---> SerDes PHY <---> SerDes lanes

where the PCS PHY handles the protocol level, and the SerDes PHY handles
the clocking and electrical characteristics of the SerDes lanes.

Maybe we should ask for a diagram of the setups when new support is
submitted to make the process of understanding the hardware easier?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
