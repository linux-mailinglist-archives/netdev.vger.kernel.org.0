Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2F594EE27D
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 22:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241340AbiCaUSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 16:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241334AbiCaUSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 16:18:33 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967252414EB;
        Thu, 31 Mar 2022 13:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=7VBCA31FpqX4VxSqCvk77atHaNS3xbmc5QnA7WF+hnQ=; b=KY+0VSqMGVZexYHUN39Iy6MIxk
        s4/g3FnGOOAYI/HvjPFMl3AyuamKf89cRQqc+UVhHyP0Peciy3dUjIjn3OqkLHcD1iFuvoZKToKUn
        g3PGRTdQt0wnl6ZwKGK30Ka14kaV2miMFdaVIGtHnlxkUN07sSvkFyC2a9JIf6YX9Ong=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1na1Dd-00DWtj-JK; Thu, 31 Mar 2022 22:16:33 +0200
Date:   Thu, 31 Mar 2022 22:16:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Michael Walle <michael@walle.cc>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 2/3] dt-bindings: net: mscc-miim: add clock
 and clock-frequency
Message-ID: <YkYMIequbfAsELnf@lunn.ch>
References: <20220331151440.3643482-1-michael@walle.cc>
 <20220331151440.3643482-2-michael@walle.cc>
 <dfb10165-1987-84ae-d48a-dfb6b897e0a3@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dfb10165-1987-84ae-d48a-dfb6b897e0a3@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 31, 2022 at 10:05:48PM +0200, Krzysztof Kozlowski wrote:
> On 31/03/2022 17:14, Michael Walle wrote:
> > Add the (optional) clock input of the MDIO controller and indicate that
> > the common clock-frequency property is supported. The driver can use it
> > to set the desired MDIO bus frequency.
> > 
> > Signed-off-by: Michael Walle <michael@walle.cc>
> > ---
> >  Documentation/devicetree/bindings/net/mscc,miim.yaml | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/mscc,miim.yaml b/Documentation/devicetree/bindings/net/mscc,miim.yaml
> > index b52bf1732755..e9e8ddcdade9 100644
> > --- a/Documentation/devicetree/bindings/net/mscc,miim.yaml
> > +++ b/Documentation/devicetree/bindings/net/mscc,miim.yaml
> > @@ -32,6 +32,11 @@ properties:
> >  
> >    interrupts: true
> >  
> > +  clocks:
> > +    maxItems: 1
> > +
> > +  clock-frequency: true
> 
> This looks unusual clock-frequency is usually for clock providers but
> this is a consumer, so it is not a common frequency here. You mention
> that "driver can use it", so it's not a hardware description but some
> feature for the driver. We have this already - use assigned-clock* in
> your DTS.

Please see

Documentation/devicetree/bindings/net/mdio.yaml

  clock-frequency:
    description:
      Desired MDIO bus clock frequency in Hz. Values greater than IEEE 802.3
      defined 2.5MHz should only be used when all devices on the bus support
      the given clock speed.

The MDIO bus master provides the MDIO bus clock, so in a sense, the
device is a provider. although it does also make use of the clock
itself. It is a hardware description, because the users of the bus
make use of the clock, i.e. the PHY devices on the bus.

It is also identical to i2c bus masters
Documentation/devicetree/bindings/i2c/i2c.txt says:

- clock-frequency
        frequency of bus clock in Hz.

   Andrew
