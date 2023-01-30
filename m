Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 329D2680F4D
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 14:49:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235472AbjA3NtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 08:49:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbjA3NtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 08:49:13 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B2437556;
        Mon, 30 Jan 2023 05:49:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Uz0rS13sZn6W3GLJhzVYyYt2P+D5LMPg6daHnApH/qI=; b=I/Gl7Mypfh2GbCGKvoqfKnf/mO
        Dk3R7Jf2jJyuPmjVvG32uHeO6huTbQoxXATic6aFd9j+35JBv1eHmiqOWB5PkzJI6z9dpS5R5wkJY
        ILKJUFVCzokxOkSiXLPsKXtOQYkXQid2WqF7Ek5QctA5WG/YJr/iehghN7qeRu/h2ErI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pMUWh-003Zvv-Ej; Mon, 30 Jan 2023 14:48:51 +0100
Date:   Mon, 30 Jan 2023 14:48:51 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sander Vanheule <sander@svanheule.net>
Cc:     Christian Marangi <ansuelsmth@gmail.com>,
        Rob Herring <robh@kernel.org>,
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
Message-ID: <Y9fKwzMyHK7kRjei@lunn.ch>
References: <20221214235438.30271-1-ansuelsmth@gmail.com>
 <20221214235438.30271-12-ansuelsmth@gmail.com>
 <20221220173958.GA784285-robh@kernel.org>
 <Y6JDOFmcEQ3FjFKq@lunn.ch>
 <Y6JkXnp0/lF4p0N1@lunn.ch>
 <63a30221.050a0220.16e5f.653a@mx.google.com>
 <c609a7f865ab48f858adafdd9c1014dda8ec82d6.camel@svanheule.net>
 <Y9bs53a9zyqEU9Xw@lunn.ch>
 <f854183545a6ff55235c9f2264af97c1a7f530c3.camel@svanheule.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f854183545a6ff55235c9f2264af97c1a7f530c3.camel@svanheule.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Thanks for the quick clarification. Because you mention this, I realised that
> the RTL8382's LED controller is actually not in the PHYs. These SoCs use
> external PHYs, which may have their own, independent, LED controllers. For
> example the RTL8212D [1].
> 
> [1]
> https://datasheet.lcsc.com/lcsc/2203252253_Realtek-Semicon-RTL8218D-CG_C2901898.pdf
> 
> > 
> > But the point is, the PHYs will probe if listed. They don't have to
> > have a MAC pointing to them with a phandle. So the phydev will exist,
> > and that should be enough to get the LED class device registered. If
> > there is basic on/off support, that should be enough for you to attach
> > the Morse code panic trigger, the heartbeat handler, or any other LED
> > trigger.
> 
> OK, this makes sense for (external) PHYs which need to be probed anyway to have
> access to the LEDs.
> 
> Looking at the RTL8212D's datasheet (Table 11, p. 24), it appears to be possible
> to assign an LED to any of the eight PHYs. Perhaps to allow more freedom in the
> board layout. Maybe I'm just not seeing it, but I don't think the example with
> an 'leds' node under a PHY contains enough information to perform such a non-
> trivial mapping. On the other hand, I'm not sure where else that info might go.

The binding is defining all the generic properties need for generic
PHY LED. For most PHYs, it is probably sufficient. However, there is
nothing stopping you from adding PHY specific properties. So for
example, for each PHY LED you could have a property which maps it to
a LED00-LED35.

So propose a binding for the RTL8218D with whatever extra properties
you think are needed, and it will be reviewed in the normal way.

    Andrew
