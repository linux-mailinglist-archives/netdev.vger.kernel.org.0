Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C19CA6AFBA6
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 02:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjCHBAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 20:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCHBAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 20:00:19 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A03B3A2F03;
        Tue,  7 Mar 2023 17:00:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=9LsH9bxzQxRa6XexS31QUN8oGOV4DBd08pYx72IfCSE=; b=v0epGVOXepxg708DlevkutYezC
        kG9fLvN/P/6txPYPf2coA24dGvs4WwFfKs8vAJ+SLxK1/JHjJQJPz8o5BfOc46kBhg3zgiTLIuNJZ
        33t4cZAFGk7ALxv4/CqvEQX2CxtSrnXbujpQ0lpFAuvV6IO96ep3fC5kHwCDDCQY0M5U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pZiA2-006iu2-Sl; Wed, 08 Mar 2023 02:00:06 +0100
Date:   Wed, 8 Mar 2023 02:00:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: Re: [net-next PATCH 08/11] dt-bindings: net: dsa: dsa-port: Document
 support for LEDs node
Message-ID: <33c40401-b9a9-456c-a1ae-f1fd2f0bb8d5@lunn.ch>
References: <20230307170046.28917-1-ansuelsmth@gmail.com>
 <20230307170046.28917-9-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230307170046.28917-9-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 06:00:43PM +0100, Christian Marangi wrote:
> Document support for LEDs node in dsa port.
> Switch may support different LEDs that can be configured for different
> operation like blinking on traffic event or port link.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
>  Documentation/devicetree/bindings/net/dsa/dsa-port.yaml | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
> index 480120469953..f813e1f64f75 100644
> --- a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
> @@ -59,6 +59,13 @@ properties:
>        - rtl8_4t
>        - seville
>  
> +  leds:
> +    type: object
> +
> +    patternProperties:
> +      '^led(@[a-f0-9]+)?$':
> +        $ref: /schemas/leds/common.yaml#

Please could you add a description here documenting that these are
LEDs the switch controls in its MACs. They are not LEDs in the
possibly integrated PHY, which the PHY driver controls.

We got this wrong, so i'm sure others will as well. So a bit of
documentation should help avoid this.

	Andrew
