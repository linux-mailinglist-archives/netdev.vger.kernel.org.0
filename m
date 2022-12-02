Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F40F640D49
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 19:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234122AbiLBScJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 13:32:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234536AbiLBScH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 13:32:07 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82FD8E7877;
        Fri,  2 Dec 2022 10:32:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=wvQ1xDmoE82XyHcjWzE7449aCw7Y023STVt3z9JJKBM=; b=0+fKDG/peW8yGj+nOx5Ta/F3Ga
        hpZtVtXheLMbgwgNPtHLyySm3ssFtkDql0TMug17WsbC46pwobKHMPcQdD4BSxbZ1ZKJb0ea0yRwH
        h2xxEy7UTm1YjpqZaHeQ0fLOd2lp0pKxG1AwfDopgP6IfrudxmrJ7McXOK57man1KGTQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p1Aow-004CpA-60; Fri, 02 Dec 2022 19:31:34 +0100
Date:   Fri, 2 Dec 2022 19:31:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     Xu Liang <lxu@maxlinear.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v1 3/4] dt-bindings: net: phy: add MaxLinear
 GPY2xx bindings
Message-ID: <Y4pEhjDOGmpmj/Kk@lunn.ch>
References: <20221202151204.3318592-1-michael@walle.cc>
 <20221202151204.3318592-4-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202151204.3318592-4-michael@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 04:12:03PM +0100, Michael Walle wrote:
> Add the device tree bindings for the MaxLinear GPY2xx PHYs.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
> 
> Is the filename ok? I was unsure because that flag is only for the GPY215
> for now. But it might also apply to others. Also there is no compatible
> string, so..
> 
>  .../bindings/net/maxlinear,gpy2xx.yaml        | 47 +++++++++++++++++++
>  1 file changed, 47 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/maxlinear,gpy2xx.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/maxlinear,gpy2xx.yaml b/Documentation/devicetree/bindings/net/maxlinear,gpy2xx.yaml
> new file mode 100644
> index 000000000000..d71fa9de2b64
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/maxlinear,gpy2xx.yaml
> @@ -0,0 +1,47 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/maxlinear,gpy2xx.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: MaxLinear GPY2xx PHY
> +
> +maintainers:
> +  - Andrew Lunn <andrew@lunn.ch>
> +  - Michael Walle <michael@walle.cc>
> +
> +allOf:
> +  - $ref: ethernet-phy.yaml#
> +
> +properties:
> +  maxlinear,use-broken-interrupts:
> +    description: |
> +      Interrupts are broken on some GPY2xx PHYs in that they keep the
> +      interrupt line asserted even after the interrupt status register is
> +      cleared. Thus it is blocking the interrupt line which is usually bad
> +      for shared lines. By default interrupts are disabled for this PHY and
> +      polling mode is used. If one can live with the consequences, this
> +      property can be used to enable interrupt handling.
> +
> +      Affected PHYs (as far as known) are GPY215B and GPY215C.
> +    type: boolean
> +
> +dependencies:
> +  maxlinear,use-broken-interrupts: [ interrupts ]
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    ethernet {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        ethernet-phy@0 {
> +            reg = <0>;
> +            interrupts-extended = <&intc 0>;
> +            maxlinear,use-broken-interrupts;
> +        };
> +    };

I'm wondering if we want this in the example. We probably don't want
people to use this property by accident, i.e. copy/paste without
reading the rest of the document. This will becomes a bigger problem
if more properties are added, RGMII delays etc.

So maybe just skip the example?

   Andrew
