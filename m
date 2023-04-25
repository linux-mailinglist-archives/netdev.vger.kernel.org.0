Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8711F6EEA60
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 00:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbjDYWpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 18:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231834AbjDYWpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 18:45:42 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C5714468
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 15:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=76fKLmrJHJNMXeN3DOO0CMsg+5iQ2AsESyo1fCvEls4=; b=S3TeXmQpIl/fq6yPVtXf3k0cZ2
        kp4GXRkg83vQKmHnyHQwwf/YCqWdHopFhkCG7qQNYPgk9nB6sSjqDhUiUlcpZNal24yTZ5zjgaMAH
        pLGuh9qg2HY2TZQ+MtO7Fz4Z5PHbLneUhhkj5KRtsubk2mqZdvdd1DWm+tIAoF7I4EGY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1prRPc-00BEFR-OW; Wed, 26 Apr 2023 00:45:28 +0200
Date:   Wed, 26 Apr 2023 00:45:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Paolo Abeni <pabeni@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next] net: phy: drop PHYLIB_LEDS knob
Message-ID: <ce193e89-0e20-4d9d-bdf5-e5151bee88e1@lunn.ch>
References: <c783f6b8d8cc08100b13ce50a1330913dd95dbce.1682457539.git.pabeni@redhat.com>
 <ce81b985-ebcf-46f7-b773-50e42d2d10e7@lunn.ch>
 <e1e1022a-da6e-4267-bca9-18cd76e0d218@app.fastmail.com>
 <20230425150111.1b17b17b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425150111.1b17b17b@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 03:01:11PM -0700, Jakub Kicinski wrote:
> On Tue, 25 Apr 2023 22:44:34 +0100 Arnd Bergmann wrote:
> > On Tue, Apr 25, 2023, at 22:38, Andrew Lunn wrote:
> > >>  
> > >> -config PHYLIB_LEDS
> > >> -	bool "Support probing LEDs from device tree"  
> > >
> > > I don't know Kconfig to well, but i think you just need to remove the
> > > text, just keep the bool.
> > >
> > > -       bool "Support probing LEDs from device tree"
> > > +       bool  
> > 
> > Right, that should work, or it can become
> > 
> >         def_bool y
> > 
> > or even
> > 
> >         def_bool OF
> > 
> > for brevity.
> 
> Hm, I think Paolo was concerned that we'd get PHYLIB_LEDS=y if PHYLIB=n
> and LEDS_CLASS=n. But that's not possible because the option is in the
> "if PHYLIB" section.
> 
> Is that right?

Seems correct to me.

But a randconfig test bot is who you really want conformation from.
The bot is probably harder to keep happy then Linus.

    Andrew

