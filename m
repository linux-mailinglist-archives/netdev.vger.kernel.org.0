Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49DDA63BDD6
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 11:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbiK2KWw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 29 Nov 2022 05:22:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbiK2KWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 05:22:45 -0500
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F2325FB;
        Tue, 29 Nov 2022 02:22:40 -0800 (PST)
Received: from ip5b412258.dynamic.kabel-deutschland.de ([91.65.34.88] helo=diego.localnet)
        by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <heiko@sntech.de>)
        id 1ozxkz-0002zv-3A; Tue, 29 Nov 2022 11:22:29 +0100
From:   Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To:     Chukun Pan <amadeus@jmu.edu.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Wu <david.wu@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] dt-bindings: net: rockchip-dwmac: add rk3568 xpcs compatible
Date:   Tue, 29 Nov 2022 11:22:28 +0100
Message-ID: <3689593.Mh6RI2rZIc@diego>
In-Reply-To: <8eb78282-08c2-24bf-4049-5c610dd781fc@linaro.org>
References: <20221129072714.22880-1-amadeus@jmu.edu.cn> <4692527.5fSG56mABF@diego> <8eb78282-08c2-24bf-4049-5c610dd781fc@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_PASS,
        T_SPF_HELO_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Dienstag, 29. November 2022, 10:59:34 CET schrieb Krzysztof Kozlowski:
> On 29/11/2022 10:56, Heiko Stübner wrote:
> > Am Dienstag, 29. November 2022, 09:49:08 CET schrieb Krzysztof Kozlowski:
> >> On 29/11/2022 08:27, Chukun Pan wrote:
> >>> The gmac of RK3568 supports RGMII/SGMII/QSGMII interface.
> >>> This patch adds a compatible string for the required clock.
> >>>
> >>> Signed-off-by: Chukun Pan <amadeus@jmu.edu.cn>
> >>> ---
> >>>  Documentation/devicetree/bindings/net/rockchip-dwmac.yaml | 6 ++++++
> >>>  1 file changed, 6 insertions(+)
> >>>
> >>> diff --git a/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml b/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
> >>> index 42fb72b6909d..36b1e82212e7 100644
> >>> --- a/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
> >>> +++ b/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
> >>> @@ -68,6 +68,7 @@ properties:
> >>>          - mac_clk_rx
> >>>          - aclk_mac
> >>>          - pclk_mac
> >>> +        - pclk_xpcs
> >>>          - clk_mac_ref
> >>>          - clk_mac_refout
> >>>          - clk_mac_speed
> >>> @@ -90,6 +91,11 @@ properties:
> >>>        The phandle of the syscon node for the peripheral general register file.
> >>>      $ref: /schemas/types.yaml#/definitions/phandle
> >>>  
> >>> +  rockchip,xpcs:
> >>> +    description:
> >>> +      The phandle of the syscon node for the peripheral general register file.
> >>
> >> You used the same description as above, so no, you cannot have two
> >> properties which are the same. syscons for GRF are called
> >> "rockchip,grf", aren't they?
> > 
> > Not necessarily :-) .
> 
> OK, then description should have something like "...GRF for foo bar".

Actually looking deeper in the TRM, having these registers "just" written
to from the dwmac-glue-layer feels quite a bit like a hack.

The "pcs" thingy referenced in patch2 actually looks more like a real device
with its own section in the TRM and own iomem area. This pcs device then
itself has some more settings stored in said pipe-grf.

So this looks more like it wants to be an actual phy-driver.


@Chukun Pan: plase take a look at something like
https://elixir.bootlin.com/linux/latest/source/drivers/phy/mscc/phy-ocelot-serdes.c#L398
on how phy-drivers for ethernets could look like.

Aquiring such a phy from the dwmac-glue and calling phy_set_mode after
moving the xpcs_setup to a phy-driver shouldn't be too hard I think.


The qsgmii/sgmii_pcs list of registers in the TRM alone already takes up
4 A4 pages, so while using the PCS as syscon and just writing some values
into it might work now, this doesn't feel at all like a future-save handling.


Heiko


