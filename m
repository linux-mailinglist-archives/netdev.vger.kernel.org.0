Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2720459C900
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 21:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238723AbiHVTfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 15:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbiHVTfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 15:35:06 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87E52DF8;
        Mon, 22 Aug 2022 12:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=s+WOD4snVC2BO4C8+qcd2CiG5Hiex2If1dPYRMgMw+o=; b=sASj/zfdSac/ORxHDWtaQhrBc7
        JXKbH6Asx8kxMk/iucxS7jiIZBR9/M5gHblzOGGqjKf80/VkCvWELJiZagYmWOkxRYD9hm1NC8qGr
        mWKrSzDgSPydFgDQSMjFMSSS5BQ+/u9YO1Ynk2/ulIvp7tH6ZYc+esBER5ZEmDfqmn2c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oQDCB-00EFxo-VL; Mon, 22 Aug 2022 21:34:47 +0200
Date:   Mon, 22 Aug 2022 21:34:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rob Herring <robh@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        David Jander <david@protonic.nl>
Subject: Re: [PATCH net-next v1 2/7] dt-bindings: net: phy: add PoDL PSE
 property
Message-ID: <YwPaV2Frj+b++8hZ@lunn.ch>
References: <20220819120109.3857571-1-o.rempel@pengutronix.de>
 <20220819120109.3857571-3-o.rempel@pengutronix.de>
 <20220822184534.GB113650-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220822184534.GB113650-robh@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 22, 2022 at 01:45:34PM -0500, Rob Herring wrote:
> On Fri, Aug 19, 2022 at 02:01:04PM +0200, Oleksij Rempel wrote:
> > Add property to reference node representing a PoDL Power Sourcing Equipment.
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> >  Documentation/devicetree/bindings/net/ethernet-phy.yaml | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> > index ed1415a4381f2..49c74e177c788 100644
> > --- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> > +++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> > @@ -144,6 +144,12 @@ properties:
> >        Mark the corresponding energy efficient ethernet mode as
> >        broken and request the ethernet to stop advertising it.
> >  
> > +  ieee802.3-podl-pse:
> > +    $ref: /schemas/types.yaml#/definitions/phandle
> > +    description:
> > +      Specifies a reference to a node representing a Power over Data Lines
> > +      Power Sourcing Equipment.
> 
> Ah, here is the consumer.
> 
> Why do you anything more than just a -supply property here for the 
> PoE/PoDL supply? The only reason I see is you happen to want a separate 
> driver for this and a separate node happens to be a convenient way to 
> instantiate drivers in Linux. Convince me otherwise.

The regulator binding provides a lot of very useful properties, which
look to do a good job describing the regulator part of a PoE/PeDL
supplier side. What however is missing is the communication part, the
power provider and the power consumer communicate with each other, via
a serial protocol. They negotiate the supply of power, a sleep mode
where power is reduced, but not removed, etc.

So a Power Sourcing Equipment driver is very likely to have a
regulator embedded in it, but its more than a regulator.

	 Andrew
