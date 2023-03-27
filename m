Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94AB76C98E8
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 02:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbjC0ADX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 20:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbjC0ADV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 20:03:21 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4395E1FC0;
        Sun, 26 Mar 2023 17:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=obMd8KxYaBJXLS2xOEVfqjlspcNMPlMz2DU/vmZvzIM=; b=I6n7Lh9tnllYJTO4KInJvH3BR2
        RLEDLmVeohYvkb0v9e3Fpkdq4TUKXmRA4FIAj1uL9v6KWehnGjNpR2KoUJQExYf4bvCMxde3OA47s
        LT/kh7BJX0cbk8sn2JoMJFKBgtKY/FKj76gfjB6VrskjgNOBxx5lEyaa55KulW5+o+Hk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pgaK7-008SvW-34; Mon, 27 Mar 2023 02:02:55 +0200
Date:   Mon, 27 Mar 2023 02:02:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        rafael@kernel.org, Colin Foster <colin.foster@in-advantage.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee@kernel.org>, davem@davemloft.net,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        thomas.petazzoni@bootlin.com
Subject: Re: [RFC 4/7] mfd: ocelot-spi: Change the regmap stride to reflect
 the real one
Message-ID: <826e295b-6a0b-4015-85bc-5ba6015678dc@lunn.ch>
References: <20230324093644.464704-1-maxime.chevallier@bootlin.com>
 <20230324093644.464704-5-maxime.chevallier@bootlin.com>
 <c87cd0b0-9ea4-493d-819d-217334c299dd@lunn.ch>
 <20230324134817.50358271@pc-7.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230324134817.50358271@pc-7.home>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > >  static const struct regmap_config ocelot_spi_regmap_config = {
> > >  	.reg_bits = 24,
> > > -	.reg_stride = 4,
> > > +	.reg_stride = 1,
> > >  	.reg_shift = REGMAP_DOWNSHIFT(2),
> > >  	.val_bits = 32,  
> > 
> > This does not look like a bisectable change? Or did it never work
> > before?
> 
> Actually this works in all cases because of "regmap: check for alignment
> on translated register addresses" in this series. Before this series,
> I think using a stride of 1 would have worked too, as any 4-byte-aligned
> accesses are also 1-byte aligned.

This is the sort of think which is good to explain in the commit
message. That is the place to answer questions reviewers are likely to
ask for things which are not obvious from just the patch.

    Andrew
