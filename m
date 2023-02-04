Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4264768AD7C
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 00:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbjBDXmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 18:42:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjBDXmQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 18:42:16 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE64D21952;
        Sat,  4 Feb 2023 15:42:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=a1uYd+o29Q7pkVIXovCbwFOCc6DFqpbczL55lI14mQ8=; b=0C68ALlUcoU31fLWmirm6nTXNK
        eziccq64O+XT9NJ+tsVGYDy1ava4KWiVfMFvAe/zKBo3Em/RJBTEuJu3OoIiyFk6BPfo2Ysq92ybF
        jQdxkSVHcRgnlizGQXQKoS4nwe9AmKI26hf9pAAZXUDfXqAWZsSy2T5iG1FMsz8w21D7kPxZuOT9q
        BHu9Vn5WsnkfFq0oL+1yd1FEdaDyWjO7VSKW10fs4JfikKHMycBi+lf8lhQwFDVVbWsMSdMvpUnY5
        pEhOPeDayTUo96PZ5HU539I69BZ58Cm5o3CbyIDYsMR7fm3tBpmiomlhH0w73lRnw66h4CqFGcP86
        e5VKabtw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36428)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pOSAV-0006xA-2u; Sat, 04 Feb 2023 23:42:02 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pOSAL-0008Hp-W5; Sat, 04 Feb 2023 23:41:54 +0000
Date:   Sat, 4 Feb 2023 23:41:53 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Jianhui Zhao <zhaojh329@gmail.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Subject: Re: [PATCH 9/9] net: dsa: mt7530: use external PCS driver
Message-ID: <Y97tQaMgU/aqEdN5@shell.armlinux.org.uk>
References: <cover.1675407169.git.daniel@makrotopia.org>
 <cover.1675407169.git.daniel@makrotopia.org>
 <677a5e37aab97a4f992d35c41329733c5f3082fb.1675407169.git.daniel@makrotopia.org>
 <677a5e37aab97a4f992d35c41329733c5f3082fb.1675407169.git.daniel@makrotopia.org>
 <20230203221915.tvg4rrjv5cnkshuf@skbuf>
 <Y95zaIJbCj3QIdqC@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y95zaIJbCj3QIdqC@makrotopia.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

I haven't reviewed the patches yet, and probably won't for a while.
(I'm recovering from Covid).

On Sat, Feb 04, 2023 at 03:02:00PM +0000, Daniel Golle wrote:
> Hi Vladimir,
> 
> thank you for the review!
> 
> On Sat, Feb 04, 2023 at 12:19:15AM +0200, Vladimir Oltean wrote:
> > On Fri, Feb 03, 2023 at 07:06:53AM +0000, Daniel Golle wrote:
> > > @@ -2728,11 +2612,14 @@ mt753x_phylink_mac_select_pcs(struct dsa_switch *ds, int port,
> > >  
> > >  	switch (interface) {
> > >  	case PHY_INTERFACE_MODE_TRGMII:
> > > +		return &priv->pcs[port].pcs;
> > >  	case PHY_INTERFACE_MODE_SGMII:
> > >  	case PHY_INTERFACE_MODE_1000BASEX:
> > >  	case PHY_INTERFACE_MODE_2500BASEX:
> > > -		return &priv->pcs[port].pcs;
> > > +		if (!mt753x_is_mac_port(port))
> > > +			return ERR_PTR(-EINVAL);
> > 
> > What is the reason for returning ERR_PTR(-EINVAL) to mac_select_pcs()?
> 
> The SerDes PCS units are only available for port 5 and 6. The code
> should make sure that the corresponding interface modes are only used
> on these two ports, so a BUG_ON(!mt753x_is_mac_port(port)) would also
> do the trick, I guess. However, as dsa_port_phylink_mac_select_pcs may
> also return ERR_PTR(-EOPNOTSUPP), returning ERR_PTR(-EINVAL) felt like
> the right thing to do in that case.
> Are you suggesting to use BUG_ON() instead or rather return
> ERR_PTR(-EOPNOTSUPP)?

Returning ERR_PTR(-EOPNOTSUPP) from mac_select_pcs() must not be done
conditionally - it means that "this instance does not support the
mac_select_pcs() interface" and phylink will never call it again.

It was implemented to provide DSA a way to tell phylink that the DSA
driver doesn't implement this interface - phylink originally checked
whether mac_ops->mac_select_pcs was NULL, but with DSA's layering,
such a check can only be made by a runtime call.

Returning NULL means "there is no PCS for this interface mode", and
returning any other error code essentially signifies that the
interface mode is not supported (even e.g. GMII or INTERNAL)...
which really *should* be handled by setting supported_interfaces
correctly in the first place.

I would much prefer drivers to just return NULL if they have no PCS,
even for ports where it's not possible, or not implement the
interface over returning some kind of error code.

The only time I would expect mac_select_pcs() to return an error is
where it needed to do something in order to evaluate whether to
return a PCS or not, and it encountered an error while trying to
evaluate that or some truely bizarre situation. E.g. a failed
memory allocation, or "we know that a PCS is required for this but
we're missing it". Something of that ilk.

Anyway, more rest needed.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
