Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D44FB6F28E6
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 14:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbjD3Mom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 08:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjD3Mol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 08:44:41 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D367A19A6;
        Sun, 30 Apr 2023 05:44:39 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pt6PZ-0003Fb-2r;
        Sun, 30 Apr 2023 14:44:18 +0200
Date:   Sun, 30 Apr 2023 13:44:12 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     David Bauer <mail@david-bauer.net>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH 2/2] dt-bindings: net: dsa: mediatek,mt7530: document
 MDIO-bus
Message-ID: <ZE5inBwZrOE-9uyA@makrotopia.org>
References: <20230430112834.11520-1-mail@david-bauer.net>
 <20230430112834.11520-2-mail@david-bauer.net>
 <e4feeac2-636b-8b75-53a5-7603325fb411@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e4feeac2-636b-8b75-53a5-7603325fb411@arinc9.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 30, 2023 at 03:34:43PM +0300, Arınç ÜNAL wrote:
> On 30.04.2023 14:28, David Bauer wrote:
> > Document the ability to add nodes for the MDIO bus connecting the
> > switch-internal PHYs.
> 
> This is quite interesting. Currently the PHY muxing feature for the MT7530
> switch looks for some fake ethernet-phy definitions on the mdio-bus where
> the switch is also defined.
> 
> Looking at the binding here, there will be an mdio node under the switch
> node. This could be useful to define the ethernet-phys for PHY muxing here
> instead, so we don't waste the register addresses on the parent mdio-bus for
> fake things. It looks like this should work right out of the box. I will do
> some tests.
> 
> Are there any examples as to what to configure on the switch PHYs with this
> change?
> 
> > 
> > Signed-off-by: David Bauer <mail@david-bauer.net>
> > ---
> >   .../devicetree/bindings/net/dsa/mediatek,mt7530.yaml        | 6 ++++++
> >   1 file changed, 6 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> > index e532c6b795f4..50f8f83cc440 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> > +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> > @@ -128,6 +128,12 @@ properties:
> >         See Documentation/devicetree/bindings/regulator/mt6323-regulator.txt for
> >         details for the regulator setup on these boards.
> > +  mdio:
> > +    $ref: /schemas/net/mdio.yaml#
> > +    unevaluatedProperties: false
> > +    description:
> > +      Node for the internal MDIO bus connected to the embedded ethernet-PHYs.
> 
> Please set this property as false for mediatek,mt7988-switch as it doesn't
> use MDIO.

Well, quite the opposite is true. This change is **needed** on MT7988 as
the built-in 1GE PHYs of the MT7988 are connected to the (internal) MDIO
bus of the switch. And they do need calibration data assigned as nvmem
via device tree.

tl;dr: Despite not being connected via MDIO itself also MT7988 exposes an
internal MDIO bus for the switch PHYs.
