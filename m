Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 529A86D003A
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 11:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbjC3Jx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 05:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbjC3JxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 05:53:14 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3634E83D4;
        Thu, 30 Mar 2023 02:53:12 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id A96F5C0010;
        Thu, 30 Mar 2023 09:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1680169991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qUGJbrLrPXEKOIeXx4NxTcTVc2hCXi7yu4QEbXuzUQg=;
        b=W8XKeyYSRkf9gcV/InEiRGIXlbnJDtkAChrARsUjGLYd+Dr+rcNX2IiQk4dBGXAL2o2FrX
        N1F5dElPR0hSoWyPAYhEfHPxlccWgMXNljHeUe0F39o3nn7DALh+o9k7GEoD29VwIWXNCk
        2XjHx5SAYS9Arw7QPAjBDpcp/72PFIRIWwEWokkpcibMt6THqGDrHJvenac8pXC0AOZWWp
        WuM8AlKymUZMCeK923FRn3KZUANDjUiHKJRs4dxjWDiMxFsr+TCnHHV0+otdMw4r2WR8I8
        Ssapw2Ud1c1cC0YHAlPAINt2PvNmrLtNIT0Va6gaLqv59Hnf4GGBRLOH39N/eg==
Date:   Thu, 30 Mar 2023 11:53:07 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        rafael@kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
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
Message-ID: <20230330115307.01d3dd6e@pc-7.home>
In-Reply-To: <ZB3kNXpNm9DTRxHH@euler>
References: <20230324093644.464704-1-maxime.chevallier@bootlin.com>
        <20230324093644.464704-5-maxime.chevallier@bootlin.com>
        <c87cd0b0-9ea4-493d-819d-217334c299dd@lunn.ch>
        <20230324134817.50358271@pc-7.home>
        <ZB3GQpdd/AicB84K@euler>
        <ZB3kNXpNm9DTRxHH@euler>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Mar 2023 10:56:05 -0700
Colin Foster <colin.foster@in-advantage.com> wrote:

> On Fri, Mar 24, 2023 at 08:48:18AM -0700, Colin Foster wrote:
> > Hi Maxime,
> > 
> > On Fri, Mar 24, 2023 at 01:48:17PM +0100, Maxime Chevallier wrote:  
> > > Hello Andrew,
> > > 
> > > On Fri, 24 Mar 2023 13:11:07 +0100
> > > Andrew Lunn <andrew@lunn.ch> wrote:
> > >   
> > > > >  	.reg_bits = 24,
> > > > > -	.reg_stride = 4,
> > > > > +	.reg_stride = 1,
> > > > >  	.reg_shift = REGMAP_DOWNSHIFT(2),
> > > > >  	.val_bits = 32,    
> > > > 
> > > > This does not look like a bisectable change? Or did it never
> > > > work before?  
> > > 
> > > Actually this works in all cases because of "regmap: check for
> > > alignment on translated register addresses" in this series.
> > > Before this series, I think using a stride of 1 would have worked
> > > too, as any 4-byte-aligned accesses are also 1-byte aligned.
> > > 
> > > But that's also why I need review on this, my understanding is
> > > that reg_stride is used just as a check for alignment, and I
> > > couldn't test this ocelot-related patch on the real HW, so please
> > > take it with a grain of salt :(  
> > 
> > You're exactly right. reg_stride wasn't used anywhere in the
> > ocelot-spi path before this patch series. When I build against
> > patch 3 ("regmap: allow upshifting register addresses before
> > performing operations") ocelot-spi breaks.
> > 
> > [    3.207711] ocelot-soc spi0.0: error -EINVAL: Error initializing
> > SPI bus
> > 
> > When I build against the whole series, or even just up to patch 4
> > ("mfd: ocelot-spi: Change the regmap stride to reflect the real
> > one") functionality returns.
> > 
> > If you keep patch 4 and apply it before patch 2, everything should
> > work.  
> 
> I replied too soon, before looking more into patch 2.
> 
> Some context from that patch:
> 
> --- a/drivers/base/regmap/regmap.c
> +++ b/drivers/base/regmap/regmap.c
> @@ -2016,7 +2016,7 @@ int regmap_write(struct regmap *map, unsigned
> int reg, unsigned int val) {
>         int ret;
> 
> -       if (!IS_ALIGNED(reg, map->reg_stride))
> +       if (!IS_ALIGNED(regmap_reg_addr(map, reg), map->reg_stride))
>                 return -EINVAL;
> 
>         map->lock(map->lock_arg);
> 
> 
> I don't know whether checking IS_ALIGNED before or after the shift is
> the right thing to do. My initial intention was to perform the shift
> at the last possible moment before calling into the read / write
> routines. That way it wouldn't interfere with any underlying regcache
> mechanisms (which aren't used by ocelot-spi)
> 
> But to me it seems like patch 2 changes this expected behavior, so the
> two patches should be squashed.
> 
> 
> ... Thinking more about it ...
> 
> 
> In ocelot-spi, at the driver layer, we're accessing two registers.
> They'd be at address 0x71070000 and 0x71070004. The driver uses those
> addresses, so there's a stride of 4. I can't access 0x71070001.
>
> The fact that the translation from "address" to "bits that go out the
> SPI bus" shifts out the last two bits and hacks off a couple of the
> MSBs doesn't seem like it should affect the 'reg_stride'.
> 
> 
> So maybe patches 2 and 4 should be dropped, and your patch 6
> alterra_tse_main should use a reg_stride of 1? That has a subtle
> benefit of not needing an additional operation or two from
> regmap_reg_addr().
> 
> Would that cause any issues? Hopefully there isn't something I'm
> missing.

Well here I guess it's also about the semantic of reg_stride. Should it
represent the alignment constraints of the register address we feed as
an input to a regmap_read/regmap_write operation, or the alignment
constraints of the underlying bus ? This is kind of a new concern, as
we are now translating register addresses.

I asked myself the same question, so I'm very open for discussion, but
my gut feeling is that the reg_stride is there to make sure we don't
perform an access whose alignment won't work with the bus we are using,
so using a stride of 1 on a memory-mapped device with 2 or 4 byte
register alignment is a bit counter-intuitive.

Thanks a lot for the review, suggestions and tests !

Best regards,

Maxime

> 
> (Aside: I'm now curious how the compiler will optimize
> regmap_reg_addr())
> 
> 
> Colin

