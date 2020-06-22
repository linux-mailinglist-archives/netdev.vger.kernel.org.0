Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C7A2038C5
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 16:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729182AbgFVOHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 10:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728977AbgFVOHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 10:07:31 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E85C061573
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 07:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=tHFtrSRL+Cgreus/WYwc6ZQ7554pVlt31JCj9z98cSk=; b=iJSHRxqQY3kbTY1PaznzQ9z0b
        1pLie1r/LI1PfiVluM4i6OSa1xtZrqtLJ4rPO054lm5Adp97XCVjWz6r09W86EPA+aUjZhOrLT/FZ
        EKRO4MaJr+2WJs0qXWc7OzWsX9Sp4HYjgeOttH2Pl9BQHGiMAgOBNuIIz9mlTuiQkTdQuT3nShk06
        lRBcCB6pM2tWL76E6Lhf9UD1JeCYdugdlarXmYND2RAjzylfQRWbBolShj3tTdAjt23GmF/qoeB/l
        x3CeAnE0FrPtHJVkDBJ85mMg6SiLe9Tt6pBt+rL2ZF8vruTjbu5ckfnnHDpngUHyWFWSujN2URfXu
        NPtwgejqQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58972)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jnN6f-0000PB-EO; Mon, 22 Jun 2020 15:07:29 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jnN6e-000072-Mm; Mon, 22 Jun 2020 15:07:28 +0100
Date:   Mon, 22 Jun 2020 15:07:28 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>
Subject: Re: [PATCH net-next v3 5/9] net: dsa: add support for phylink_pcs_ops
Message-ID: <20200622140728.GL1551@shell.armlinux.org.uk>
References: <20200621225451.12435-1-ioana.ciornei@nxp.com>
 <20200621225451.12435-6-ioana.ciornei@nxp.com>
 <20200622102213.GD1551@shell.armlinux.org.uk>
 <20200622111057.GM1605@shell.armlinux.org.uk>
 <20200622121609.GN1605@shell.armlinux.org.uk>
 <VI1PR0402MB3871B441D15250A8970DD5A4E0970@VI1PR0402MB3871.eurprd04.prod.outlook.com>
 <20200622131412.GF1551@shell.armlinux.org.uk>
 <VI1PR0402MB3871A4AD4767194D1CCA6AFEE0970@VI1PR0402MB3871.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB3871A4AD4767194D1CCA6AFEE0970@VI1PR0402MB3871.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 01:51:55PM +0000, Ioana Ciornei wrote:
> > Right, but we're talking about hardware that is common not only in DSA but
> > elsewhere - and we already deal with that outside of DSA with PHYs.
> 
> I said before why the PHY use case is different from a PCS tightly
> coupled inside the SoC.

Yes, however, I'm responding to your point about whether DSA maintainers
would be happy with it, so I've used the already existing example with
phylib to illustrate that this already happens in DSA-land.  I was not
meaning to refer to your point about the PCS being tightly coupled
inside the SoC.  That should've been clear by the comment immediately
below:

> > So, what I'm proposing is really nothing new for DSA.


> > Do you know what those errata would be?  I'm only aware of A-011118 in the
> > LX2160A which I don't believe will impact this code.  I don't have visibility of
> > Ocelot/Felix.
> 
> I was mainly looking at this from a software architecture perspective,
> not having any explicit erratum in mind.

Ok.

> > > On the other hand, I am not sure what is the concrete benefit of doing
> > > it your way. I understand that for a PHY device the MAC is not
> > > involved in the call path but in the case of the PCS the expectation
> > > is that it's tightly coupled in the silicon and not plug-and-play.
> > 
> > The advantage is less lines of code to maintain, and a more efficient and
> > understandable code structure.  I would much rather start off simple and then
> > augment rather than start off with unnecessary complexity and then get stuck
> > with it while not really needing it.
> > 
> 
> I am not going to argue ad infinitum on this. If you think keeping the
> phylink_pcs_ops structure outside is the better approach then let's
> take that route.
> 
> I will go through your feedback on the actual Lynx module and respond/make the
> necessary adjustments.
> 
> Beside this, what should be our next move? Will you submit the new method of
> working with the phylink_pcs_ops structure?

I do think it is the best approach _at the moment_ given what we know
at this time - without over-designing for situations that we don't know.

So, I'll take this as tentative agreement, and I'll begin work on
converting my local users, testing, and then sending a finished
patch.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
