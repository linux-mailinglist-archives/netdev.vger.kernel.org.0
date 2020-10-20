Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41F1729446F
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 23:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409816AbgJTVSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 17:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409806AbgJTVSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 17:18:30 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D3DC0613CE;
        Tue, 20 Oct 2020 14:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=16NBwrINzxCN67ax/GI9ciKYrBgqrAffKyIGAaK8MRQ=; b=xVqwEDCh4CrkADdua1xzzgzCL
        pLqjTXbdJrhb1vCzuEm4HX08KGmOJioCu/rUq8ArcwrXgwlL6VJd6xgqMNMXUTAlq4XkRmXkd5OlL
        5aDa+9/6U59anH4Npafy030umAio5mumGxhyzTqMaTVqQ1rZnfiFMwm6EBJakzpb6Gz9h/KKqmcMv
        2xgQ+WlwPhjPbCkTqugou0JC0In2FPzXgYokFupwi0U+H7xGKnZUFjBfqmhX5vh7K8/8GtOF+sE/g
        1jVEaD1p8yWKHyIfHR/JBkQ/Cn3ou9/LYmlQDlAjLGLG833C4DTwflaA9ZYPz7mmjs635XmMsQeN9
        QJB7BcAbg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48814)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kUz1Q-0007zj-Bz; Tue, 20 Oct 2020 22:18:20 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kUz1K-0005cC-7p; Tue, 20 Oct 2020 22:18:14 +0100
Date:   Tue, 20 Oct 2020 22:18:14 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Cc:     Marek Behun <marek.behun@nic.cz>, Andrew Lunn <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/3] net: dsa: mv88e6xxx: Don't force link when using
 in-band-status
Message-ID: <20201020211814.GG1551@shell.armlinux.org.uk>
References: <20201020034558.19438-1-chris.packham@alliedtelesis.co.nz>
 <20201020034558.19438-2-chris.packham@alliedtelesis.co.nz>
 <20201020101552.GB1551@shell.armlinux.org.uk>
 <20201020154940.60357b6c@nic.cz>
 <20201020140535.GE139700@lunn.ch>
 <20201020141525.GD1551@shell.armlinux.org.uk>
 <20201020165115.3ecfd601@nic.cz>
 <95c8cbb8-2364-b47b-851d-61a2c2ccf508@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95c8cbb8-2364-b47b-851d-61a2c2ccf508@alliedtelesis.co.nz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 20, 2020 at 09:06:32PM +0000, Chris Packham wrote:
> 
> On 21/10/20 3:51 am, Marek Behun wrote:
> > On Tue, 20 Oct 2020 15:15:25 +0100
> > Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> >
> >> On Tue, Oct 20, 2020 at 04:05:35PM +0200, Andrew Lunn wrote:
> >>> On Tue, Oct 20, 2020 at 03:49:40PM +0200, Marek Behun wrote:
> >>>> On Tue, 20 Oct 2020 11:15:52 +0100
> >>>> Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> >>>>    
> >>>>> On Tue, Oct 20, 2020 at 04:45:56PM +1300, Chris Packham wrote:
> >>>>>> When a port is configured with 'managed = "in-band-status"' don't force
> >>>>>> the link up, the switch MAC will detect the link status correctly.
> >>>>>>
> >>>>>> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
> >>>>>> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> >>>>> I thought we had issues with the 88E6390 where the PCS does not
> >>>>> update the MAC with its results. Isn't this going to break the
> >>>>> 6390? Andrew?
> >>>>>    
> >>>> Russell, I tested this patch on Turris MOX with 6390 on port 9 (cpu
> >>>> port) which is configured in devicetree as 2500base-x, in-band-status,
> >>>> and it works...
> >>>>
> >>>> Or will this break on user ports?
> >>> User ports is what needs testing, ideally with an SFP.
> >>>
> >>> There used to be explicit code which when the SERDES reported link up,
> >>> the MAC was configured in software with the correct speed etc. With
> >>> the move to pcs APIs, it is less obvious how this works now, does it
> >>> still software configure the MAC, or do we have the right magic so
> >>> that the hardware updates itself.
> >> It's still there. The speed/duplex etc are read from the serdes PHY
> >> via mv88e6390_serdes_pcs_get_state(). When the link comes up, we
> >> pass the negotiated link parameters read from there to the link_up()
> >> functions. For ports where mv88e6xxx_port_ppu_updates() returns false
> >> (no external PHY) we update the port's speed and duplex setting and
> >> (currently, before this patch) force the link up.
> >>
> >> That was the behaviour before I converted the code, the one that you
> >> referred to. I had assumed the code was correct, and _none_ of the
> >> speed, duplex, nor link state was propagated from the serdes PCS to
> >> the port on the 88E6390 - hence why the code you refer to existed.
> >>
> > Russell, you are right.
> > SFP on 88E6390 does not work with this patch applied.
> > So this patch breaks 88E6390.
> Thanks for testing. It sounds like maybe if I make 
> mv88e6xxx_port_ppu_updates() return true for the 6097 in serdes mode I 
> can avoid the forced link up without affecting the 6390.

Another option would be to make mv88e6xxx_mac_link_up() call a
switch specific implementation function, which is probably way
cleaner than introducing conditionals on the switch type in
functions, and reflects the existing code structure.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
