Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C563C652B14
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 02:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234294AbiLUBmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 20:42:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiLUBmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 20:42:09 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0729F1928E;
        Tue, 20 Dec 2022 17:42:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=59sGi5wsFZmEQD/ZiTGyF0MkmR+ZW973oaLWGzOPSbQ=; b=2VjeEhvCOFLVL/UsfvefI9AQlt
        h032f0NJp/mTS8R7vLner+lAcqTpwqECb2yA5Hex0BwhUKzHqFNVBt4eteKZC0YwwRkuNmC/dlBIB
        B7R8W9DiEtgGOnrYA/MAV2N7aTnM6XnDnNMe1lZ6zyP+al6n+cXBLShUJpBDmhjSUm3k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p7o7C-0008dE-PW; Wed, 21 Dec 2022 02:41:50 +0100
Date:   Wed, 21 Dec 2022 02:41:50 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rob Herring <robh@kernel.org>
Cc:     Christian Marangi <ansuelsmth@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: Re: [PATCH v7 11/11] dt-bindings: net: dsa: qca8k: add LEDs
 definition example
Message-ID: <Y6JkXnp0/lF4p0N1@lunn.ch>
References: <20221214235438.30271-1-ansuelsmth@gmail.com>
 <20221214235438.30271-12-ansuelsmth@gmail.com>
 <20221220173958.GA784285-robh@kernel.org>
 <Y6JDOFmcEQ3FjFKq@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6JDOFmcEQ3FjFKq@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +                        };
> > > +
> > > +                        led@1 {
> > > +                            reg = <1>;
> > > +                            color = <LED_COLOR_ID_AMBER>;
> > > +                            function = LED_FUNCTION_LAN;
> > > +                            function-enumerator = <1>;
> > 
> > Typo? These are supposed to be unique. Can't you use 'reg' in your case?
> 
> reg in this context is the address of the PHY on the MDIO bus. This is
> an Ethernet switch, so has many PHYs, each with its own address.

Actually, i'm wrong about that. reg in this context is the LED number
of the PHY. Typically there are 2 or 3 LEDs per PHY.

There is no reason the properties need to be unique. Often the LEDs
have 8 or 16 functions, identical for each LED, but with different
reset defaults so they show different things.

   Andrew
