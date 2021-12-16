Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4409477A09
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 18:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239951AbhLPRK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 12:10:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235904AbhLPRK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 12:10:28 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 135ACC061574
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 09:10:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=P2xXrEggFYLWjne2ReQXwUZsuYfZIsitNHAUYstnTw8=; b=lXaQ23vxUHQwribsBqLoqtncfd
        BgQmR8hSgLAGxIfntski07kBFD7iSc4XAjyD81eZAN0morT94G69ik5XuSUMjCy1TI9QLgKyVDi7s
        9q0Pt3W9E2+cbsiDdgi23HpZwZzCL4JzFK1/tepdkUAzQgjvptOsGL24Xvm1wgSOhA3e3jeE3mQOO
        NO/AHuUnGKnIn1ugwohfPfnvtfi8p5sVwwrj9XBZ8isLozajAJLSru8ZAA85YB9CbRPmFoJs2/0iQ
        pK3mXHFIRhQThUx1mBwj56AwZye2qnpp8UZ+tNu1ow1//uj9AtEApNhq24PtIN+fP8mxuCpRbQq8t
        MzlPnVNQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56324)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mxuGs-00087l-Qs; Thu, 16 Dec 2021 17:10:22 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mxuGp-0005Zy-Td; Thu, 16 Dec 2021 17:10:19 +0000
Date:   Thu, 16 Dec 2021 17:10:19 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH net-next 2/7] net: phylink: add pcs_validate() method
Message-ID: <Ybty+2r+adk574Dc@shell.armlinux.org.uk>
References: <Ybiue1TPCwsdHmV4@shell.armlinux.org.uk>
 <E1mx96A-00GCdF-Ei@rmk-PC.armlinux.org.uk>
 <0d7361a9-ea74-ce75-b5e0-904596fbefd1@seco.com>
 <YbkoWsMPgw5RsQCo@shell.armlinux.org.uk>
 <3a3716a1-54be-e218-5c1e-a794b208aa53@seco.com>
 <Ybk3kuKyynGQYjzh@shell.armlinux.org.uk>
 <99059dd8-808d-ddaf-3e65-85b1f7652b7d@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99059dd8-808d-ddaf-3e65-85b1f7652b7d@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 16, 2021 at 10:42:08AM -0500, Sean Anderson wrote:
> 
> 
> On 12/14/21 7:32 PM, Russell King (Oracle) wrote:
> > On Tue, Dec 14, 2021 at 06:54:16PM -0500, Sean Anderson wrote:
> > > On 12/14/21 6:27 PM, Russell King (Oracle) wrote:
> > > > On Tue, Dec 14, 2021 at 02:49:13PM -0500, Sean Anderson wrote:
> > > > > Hi Russell,
> > > > >
> > > > > On 12/14/21 9:48 AM, Russell King (Oracle) wrote:
> > > > > > Add a hook for PCS to validate the link parameters. This avoids MAC
> > > > > > drivers having to have knowledge of their PCS in their validate()
> > > > > > method, thereby allowing several MAC drivers to be simplfied.
> > > > > >
> > > > > > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > > > > > ---
> > > > > >   drivers/net/phy/phylink.c | 31 +++++++++++++++++++++++++++++++
> > > > > >   include/linux/phylink.h   | 20 ++++++++++++++++++++
> > > > > >   2 files changed, 51 insertions(+)
> > > > > >
> > > > > > diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> > > > > > index c7035d65e159..420201858564 100644
> > > > > > --- a/drivers/net/phy/phylink.c
> > > > > > +++ b/drivers/net/phy/phylink.c
> > > > > > @@ -424,13 +424,44 @@ static int phylink_validate_mac_and_pcs(struct phylink *pl,
> > > > > >   					struct phylink_link_state *state)
> > > > > >   {
> > > > > >   	struct phylink_pcs *pcs;
> > > > > > +	int ret;
> > > > > >
> > > > > > +	/* Get the PCS for this interface mode */
> > > > > >   	if (pl->mac_ops->mac_select_pcs) {
> > > > > >   		pcs = pl->mac_ops->mac_select_pcs(pl->config, state->interface);
> > > > > >   		if (IS_ERR(pcs))
> > > > > >   			return PTR_ERR(pcs);
> > > > > > +	} else {
> > > > > > +		pcs = pl->pcs;
> > > > > > +	}
> > > > > > +
> > > > > > +	if (pcs) {
> > > > > > +		/* The PCS, if present, must be setup before phylink_create()
> > > > > > +		 * has been called. If the ops is not initialised, print an
> > > > > > +		 * error and backtrace rather than oopsing the kernel.
> > > > > > +		 */
> > > > > > +		if (!pcs->ops) {
> > > > > > +			phylink_err(pl, "interface %s: uninitialised PCS\n",
> > > > > > +				    phy_modes(state->interface));
> > > > > > +			dump_stack();
> > > > > > +			return -EINVAL;
> > > > > > +		}
> > > > > > +
> > > > > > +		/* Validate the link parameters with the PCS */
> > > > > > +		if (pcs->ops->pcs_validate) {
> > > > > > +			ret = pcs->ops->pcs_validate(pcs, supported, state);
> > > > >
> > > > > I wonder if we can add a pcs->supported_interfaces. That would let me
> > > > > write something like
> > > >
> > > > I have two arguments against that:
> > > >
> > > > 1) Given that .mac_select_pcs should not return a PCS that is not
> > > >     appropriate for the provided state->interface, I don't see what
> > > >     use having a supported_interfaces member in the PCS would give.
> > > >     All that phylink would end up doing is validating that the MAC
> > > >     was giving us a sane PCS.
> > > 
> > > The MAC may not know what the PCS can support. For example, the xilinx
> > > PCS/PMA can be configured to support 1000BASE-X, SGMII, both, or
> > > neither. How else should the mac find out what is supported?
> > 
> > I'll reply by asking a more relevant question at this point.
> > 
> > If we've asked for a PCS for 1000BASE-X via .mac_select_pcs() and a
> > PCS is returned that does not support 1000BASE-X, what happens then?
> > The system level says 1000BASE-X was supported when it isn't...
> > That to me sounds like bug.
> 
> Well, there are two ways to approach this, IMO, and both involve some
> kind of supported_interfaces bitmap. The underlying constraint here is
> that the MAC doesn't really know/care at compile-time what the PCS
> supports.
> 
> - The MAC always returns the external PCS, since that is what the user
>   configured. In this case, the PCS is responsible for ensuring that the
>   interface is supported. If phylink does not do this check, then it
>   must be done in pcs_validate().
> - The MAC inspects the PCS's supported_interfaces bitmap, and only
>   returns it from mac_select_pcs if it matches.

Yes - we can do these sorts of things later if it turns out there is
a requirement to do so. At the moment, having been through all the
drivers recently, I don't see the need for it yet.

The only driver that may come close is xpcs, and the patches I've
proposed there don't need it - I just populate the PCS support 
by calling into xpcs.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
