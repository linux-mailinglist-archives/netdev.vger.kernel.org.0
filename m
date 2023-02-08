Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8AEE68FA43
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 23:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbjBHWb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 17:31:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbjBHWb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 17:31:27 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4790325BA5;
        Wed,  8 Feb 2023 14:31:23 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pPsyA-0007y7-1W;
        Wed, 08 Feb 2023 23:31:14 +0100
Date:   Wed, 8 Feb 2023 22:30:52 +0000
From:   Daniel Golle <daniel@makrotopia.org>
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Jianhui Zhao <zhaojh329@gmail.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Subject: Re: [PATCH v2 03/11] dt-bindings: arm: mediatek: add
 'mediatek,pn_swap' property
Message-ID: <Y+QinJ9W8hIIF9Ni@makrotopia.org>
References: <cover.1675779094.git.daniel@makrotopia.org>
 <a8c567cf8c3ec6fef426b64fb1ab7f6e63a0cc07.1675779094.git.daniel@makrotopia.org>
 <ad09a065-c10d-3061-adbe-c58724cdfde0@kernel.org>
 <Y+KR26aepqlfsjYG@makrotopia.org>
 <b6d782ef-b375-1e73-a384-1ff37c1548a7@kernel.org>
 <Y+Oo9HaqPeNVUANR@makrotopia.org>
 <514ec4b8-ef78-35c1-2215-22884fca87d4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <514ec4b8-ef78-35c1-2215-22884fca87d4@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Krzysztof,

thank you for taking the time to review and explain.

On Wed, Feb 08, 2023 at 09:08:40PM +0100, Krzysztof Kozlowski wrote:
> On 08/02/2023 14:51, Daniel Golle wrote:
> > On Wed, Feb 08, 2023 at 10:32:53AM +0100, Krzysztof Kozlowski wrote:
> >> On 07/02/2023 19:00, Daniel Golle wrote:
> >>> ...
> >>>> 3. Does not look like property of this node. This is a clock controller
> >>>> or system controller, not SGMII/phy etc.
> >>>
> >>> The register range referred to by this node *does* represent also an
> >>> SGMII phy. These sgmiisys nodes also carry the 'syscon' compatible, and
> >>> are referenced in the node of the Ethernet core, and then used by
> >>> drivers/net/ethernet/mediatek/mtk_sgmii.c using syscon_node_to_regmap.
> >>> (This is the current situation already, and not related to the patchset
> >>> now adding only a new property to support hardware which needs that)
> >>
> >> Just because a register is located in syscon block, does not mean that
> >> SGMII configuration is a property of this device.
> > 
> > It's not just one register, the whole SGMII PCS is located in those
> > mediatek,sgmiisys syscon nodes.
> 
> Then maybe this should be a PCS PHY device instead of adding properties
> unrelated to clock/system controller? I don't know, currently this
> binding says it is a provider of clocks...

As in reality it is really a clock provider and also SGMII PCS at the
same time, maybe we should just update the description of the binding
to match that:

diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.txt b/Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.txt
index d2c24c2775141..db6f75df200ba 100644
--- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.txt
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.txt
@@ -2,6 +2,7 @@ MediaTek SGMIISYS controller
 ============================
 
 The MediaTek SGMIISYS controller provides various clocks to the system.
+It also represents the SGMII PCS used by the Ethernet core.
 
 Required Properties:
 

See

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/ethernet/mediatek/mtk_sgmii.c#n179

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm64/boot/dts/mediatek/mt7986a.dtsi#n409


> 
> > 
> >>
> >>>
> >>> So: Should I introduce a new binding for the same compatible strings
> >>> related to the SGMII PHY features? Or is it fine in this case to add
> >>> this property to the existing binding?
> >>
> >> The user of syscon should configure it. I don't think you need new
> >> binding. You just have to update the user of this syscon.
> > 
> > Excuse my confusion, but it's still not entirely clear to me.
> > So in this case I should add the description of the added propterty of
> > the individual SGMII units (there can be more than one) to
> > Documentation/devicetree/bindings/net/mediatek,net.yaml
> > eventhough the properties are in the sgmiisys syscon nodes?
> 
> I guess the property should be in the node representing the SGMII. You
> add it now to the clock (or system) controller, so it does not look
> right. It's not a property of a clock controller.

Well maybe this node needs to be split then into one node representing
only the clock controller and another node representing the SGMII PCS?
I'm not sure if this is even possible, some registers in this range
represent clocks, other registers are accessed using regmap API in
mtk_sgmii.c.

And (see the rest of this series) the exact same SGMII PCS can also be
found in MT7531 switch IC which has it's own (a bit odd) way to access
32-bit registers over MDIO, also in this case it is simply not easily
possible to represent the SGMII PCS in device tree.

> 
> Now which node should have this property depends on your devices - which
> I have no clue about, I read what is in the bindings.

There isn't any other node exclusively representing the SGMII PCS.
I guess the only other option would be to move the property to the
Ethernet controller node, which imho complicates things as it is
really a property of an individual SGMII PHY (of which there can be
more than one).

> 
> > 
> > If so I will have to figure out how to describe properties of other
> > nodes in the binding of the node referencing them. Are there any
> > good examples for that?
> 
> phys and pcs'es?

Hm, none of the current PCS (or PHY) drivers are represented by a
syscon node... (and maybe that's the mistake in first place?)

> 
> > 
> > Or should the property itself be moved into yet another array of
> > booleans which should be added in the node describing the ethernet
> > controller and referencing these sgmiisys syscons using phandles?
> 
> Best regards,
> Krzysztof
> 
