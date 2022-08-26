Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5155A2244
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 09:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245617AbiHZHuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 03:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245560AbiHZHuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 03:50:05 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B444E637
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 00:50:02 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oRU64-0000y3-No; Fri, 26 Aug 2022 09:49:44 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oRU60-0004kp-Q4; Fri, 26 Aug 2022 09:49:40 +0200
Date:   Fri, 26 Aug 2022 09:49:40 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        David Jander <david@protonic.nl>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v2 1/7] dt-bindings: net: pse-dt: add bindings
 for generic PSE controller
Message-ID: <20220826074940.GC2116@pengutronix.de>
References: <20220825130211.3730461-1-o.rempel@pengutronix.de>
 <20220825130211.3730461-2-o.rempel@pengutronix.de>
 <Ywf3Z+1VFy/2+P78@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Ywf3Z+1VFy/2+P78@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 26, 2022 at 12:27:51AM +0200, Andrew Lunn wrote:
> > +  ieee802.3-pairs:
> > +    $ref: /schemas/types.yaml#/definitions/int8-array
> > +    description: Array of number of twisted-pairs capable to deliver power.
> > +      Since not all circuits are able to support all pair variants, the array of
> > +      supported variants should be specified.
> > +      Note - single twisted-pair PSE is formally know as PoDL PSE.
> > +    items:
> > +      enum: [1, 2, 4]
> 
> It is not clear to me what you are describing here. It looks like the
> number of pairs? That does not seem like a hardware property. The
> controller itself should be able to tell you how many pairs it can
> feed.
> 
> A hardware property would be which pairs of the socket are connected
> to a PSE and so can be used to deliver power.

Good point, this will be needed as well. But not right now.

> But i'm not sure how
> that would be useful to know. I suppose a controller capable of
> powering 4 pair, but connected to a socket only wired to supply 2, can
> then disable 2 pairs?

Not only. Here are following reasons:
- not all boards use a controller in form of IC. Some boards are the
  controller. So, there is no other place to describe, what kind of
  controller this board is. For example - currently there are no known
  ICs to support PoDL (ieee802.3-pairs == 1), early adopters are
  implementing it by using MOSFETs coupled with ADCs and some extra
  logic on CPU side:
  https://www.ti.com/lit/an/snla395/snla395.pdf
- not all ICs provide a way for advanced communication (I2C, SPI, MDIO).
  Some of them will provide only bootstrapping and some pin status
  feedback:
  https://www.analog.com/media/en/technical-documentation/data-sheets/4279fa.pdf
- Even if we are able to communicate with the IC, there are still board
  specific limitations.

I hope we can agree that some property is need to tell what kind of PSE
specification is used by this node.

The next challenge is to name it. We have following options:
1. PoE, PoE+, PoE++, 4PPoE, PoDL
2. 802.3af, 802.3at, 802.bt, 802.3bu, 802.3cg
3. Physical property of this specifications

Option 1 is mostly using marketing names, except of PoDL. This names are
not used in the ieee 802.3-2018 specification. Systematic research of
this marketing names would give following results:
- PoE is about delivering power over two twisted pairs and is related to
  802.3af and 802.3at specs.
- PoE+ is about delivering power over two twisted pairs and is related
  only to 802.3at.
- PoE++ is the same as 4PPoE or power over four twisted pairs and is related
  to 802.3bt.
- PoDL is related to 802.3bu and 802.3cg. Which is power over one
  twisted pair

All of this names combine different properties: number of twisted pairs
used to deliver power, maximal supported power by the system and
recommendation for digital interface to communicate with the PSE
controller (MDIO registers). Since system I currently use do not follow
all of this recommendations, it is needed to describe them separately.

Option 2 is interesting only for archaeological investigation. Final
snapshots of 802.3 specification do not provide mapping of extensions to
actual parts of the spec. I assume, no software developer will be able
to properly set the devicetree property by using specification extension
names.

Option 3 provide exact physical property of implementation by using same
wording provided by the  802.3-2018 spec. This option is easy to verify
by reviewing the board schematics and it is easy to understand without
doing historical analysis of 802.3 spec.

> > +
> > +  ieee802.3-pse-type:
> > +    $ref: /schemas/types.yaml#/definitions/uint8
> > +    minimum: 1
> > +    maximum: 2
> > +    description: PSE Type. Describes classification- and class-capabilities.
> > +      Not compatible with PoDL PSE Type.
> > +      Type 1 - provides a Class 0, 1, 2, or 3 signature during Physical Layer
> > +      classification.
> > +      Type 2 - provides a Class 4 signature during Physical Layer
> > +      classification, understands 2-Event classification, and is capable of
> > +      Data Link Layer classification.
> 
> Again, the controller should know what class it can support. Why do we
> need to specify it?  What could make sense is we want to limit the
> controller to a specific type? 

If we are using existing controller - yes. But this binding is designed for the
system where no special PSE IC is used. This Types and Classes depends on the
board implementation and should be provided by the vendor as part of
product certification. This information can be used by the system
administrators to verify compatibility between PSE and PD, especially if
no automatic classification is not implemented on this board.

And even if auto classification is implemented by the software, we need
to know which classes we should announce.

> > +  ieee802.3-podl-pse-class:
> > +    $ref: /schemas/types.yaml#/definitions/int8-array
> > +    items:
> > +      enum: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
> > +    description: PoDL PSE Class. Array of supported classes by the
> > +      single twisted-pair PoDL PSE.
> 
> Why? I could understand we might want to limit the higher classes,
> because the board is not designed for them, but the controller on the
> board can actually offer them. But if it tries to use them, the board
> will melt/blow a fuse.
> 
> So i'm wondering if it should actually be something like:
> 
> > +  ieee802.3-podl-limit-pse-classes:
> > +    $ref: /schemas/types.yaml#/definitions/int8-array
> > +    items:
> > +      enum: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
> > +    description: PoDL PSE Class. Limit the PoDL PSE to only these classes,
>          due to hardware design limitations. If not specified, the PoDL PSE
> 	 will offer all classes its supports.

Sounds good, this can be an extra property for PSE ICs, not for boards
without dedicated ICs.

> Remember, DT describes the hardware, not software configuration of the
> hardware.

Ack, I agree.

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
