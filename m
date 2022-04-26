Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22BFB50F2ED
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 09:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344257AbiDZHtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 03:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343874AbiDZHtw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 03:49:52 -0400
Received: from mail.pr-group.ru (mail.pr-group.ru [178.18.215.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91B53193DE;
        Tue, 26 Apr 2022 00:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
        d=metrotek.ru; s=mail;
        h=from:subject:date:message-id:to:cc:mime-version:content-type:in-reply-to:
         references;
        bh=jdeIL4APlI7ICUopY2YQhQe6o+8TJoupKLnVkfKcSl4=;
        b=caZLIG7XwxfomNotUAL9qP9VTjUQIRfxK6A662fV6pAh8nRTlrbXhoDl6MX1FoHNzdpI/edmsUVWz
         ANqh+BZ5kd5pcHTvEmqXXLPDr4Sodl1s9gUtECWbmqIXyZj8ODcuvGhKRoutJ/bUuxBD+XI1wHWqEh
         u9GKJvP2jH0qLOGJc7P4h1kAi45kNiD4M9NlWL8b/raneXkP1atL1A2AjXOfX4T7DMA25mjeytkXMq
         oTocpm9oebiGNzy8VRS9ktV4/aDEKGaKsUt2+aUK2gGvtln0bS7fH1uRaTGM5F71HmFbku40i8UR4/
         C0/HQvE5kusrn2Bf4BY8xtQFuSa3tvA==
X-Kerio-Anti-Spam:  Build: [Engines: 2.16.2.1410, Stamp: 3], Multi: [Enabled, t: (0.000008,0.007255)], BW: [Enabled, t: (0.000015,0.000001)], RTDA: [Enabled, t: (0.063913), Hit: No, Details: v2.36.0; Id: 15.52k1ok.1g1idbgdp.3m7n0; mclb], total: 0(700)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Level: 
X-Footer: bWV0cm90ZWsucnU=
Received: from h-e2.ddg ([85.143.252.66])
        (authenticated user i.bornyakov@metrotek.ru)
        by mail.pr-group.ru with ESMTPSA
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256 bits));
        Tue, 26 Apr 2022 10:46:11 +0300
Date:   Tue, 26 Apr 2022 10:46:00 +0300
From:   Ivan Bornyakov <i.bornyakov@metrotek.ru>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, system@metrotek.ru
Subject: Re: [PATCH net-next RESEND] net: phy: marvell-88x2222: set proper
 phydev->port
Message-ID: <20220426074600.p3za7apdxxvjbq3z@h-e2.ddg>
References: <20220405150305.151573-1-i.bornyakov@metrotek.ru>
 <20220425041637.5946-1-i.bornyakov@metrotek.ru>
 <YmcTkkNcDrtdcGTM@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmcTkkNcDrtdcGTM@shell.armlinux.org.uk>
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 25, 2022 at 10:33:06PM +0100, Russell King (Oracle) wrote:
> On Mon, Apr 25, 2022 at 07:16:37AM +0300, Ivan Bornyakov wrote:
> > phydev->port was not set and always reported as PORT_TP.
> > Set phydev->port according to inserted SFP module.
> > 
> > Signed-off-by: Ivan Bornyakov <i.bornyakov@metrotek.ru>
> > ---
> >  drivers/net/phy/marvell-88x2222.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/net/phy/marvell-88x2222.c b/drivers/net/phy/marvell-88x2222.c
> > index ec4f1407a78c..9f971b37ec35 100644
> > --- a/drivers/net/phy/marvell-88x2222.c
> > +++ b/drivers/net/phy/marvell-88x2222.c
> > @@ -603,6 +603,7 @@ static int mv2222_sfp_insert(void *upstream, const struct sfp_eeprom_id *id)
> >  	dev = &phydev->mdio.dev;
> >  
> >  	sfp_parse_support(phydev->sfp_bus, id, sfp_supported);
> > +	phydev->port = sfp_parse_port(phydev->sfp_bus, id, sfp_supported);
> >  	sfp_interface = sfp_select_interface(phydev->sfp_bus, sfp_supported);
> >  
> >  	dev_info(dev, "%s SFP module inserted\n", phy_modes(sfp_interface));
> > @@ -639,6 +640,7 @@ static void mv2222_sfp_remove(void *upstream)
> >  
> >  	priv->line_interface = PHY_INTERFACE_MODE_NA;
> >  	linkmode_zero(priv->supported);
> > +	phydev->port = PORT_OTHER;
> 
> Can this PHY be used in dual-media mode, auto-switching between copper
> and fibre?

I believe, it can not.

> If so, is PORT_OTHER actually appropriate here, or should
> the old value be saved when the module is inserted and restored when
> it's removed?

Would PORT_NONE be appropriate? Saving old value would be ok also.

