Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A00A76E3C26
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 23:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjDPV3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 17:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDPV3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 17:29:53 -0400
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB0B1FEF;
        Sun, 16 Apr 2023 14:29:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1681680547; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=B1vxEcLr1ew7b2Ewu7S9F9yBNYySLw5WwOmnAMXPvREXFBiFGqfwsRLDEmVsHrqOU/KTagi79sMtgaXt4H/Jzmrn5bZL2482nUNnBIqTXrHv0J/4c5/llG92SfdkbU1Rc8gldd1oo7d74ExvZK4X06Qtefe8rf6tc5GHBuJeVEA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1681680547; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=dwGEPtLK0WYqjAT8ygXmQLZmIHK63VdeV8vdrcfKE+Q=; 
        b=Dx6N28WYQ/urtoRdB/eavwC1uAUwj1ecCmlqqLw8FWTPDe+x1XyODa6BwTZEUeGRwXgB4kj7sKda5b3WA+lDjyld40mRCV1Ipz3evK1FKMurwnnwF0NGwKuGvqMMeOgoPwjlsrmy64RNBq17l0ORw5Lfs976/QjQArr/6ZpZNgo=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1681680547;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=dwGEPtLK0WYqjAT8ygXmQLZmIHK63VdeV8vdrcfKE+Q=;
        b=J9dFI7GMpdKjo/LZGEX56d8lb1wmvcUhLaZ1ijccRLLa6BE1WPxG7HghVwstB+Xy
        //wbpUgB/80FIzYPlqO+KysiV6wvlncpxjiSU0TkVKvWmdfQVUlC7fSV/PV/r4kONZW
        OQ1JcldLcIKefpOxBV1Et7FfR9MkmuGrKbumCzoU=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1681680546151439.83375093791324; Sun, 16 Apr 2023 14:29:06 -0700 (PDT)
Message-ID: <f125954e-d4ac-121f-18c4-bc7db25efa1c@arinc9.com>
Date:   Mon, 17 Apr 2023 00:28:57 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net-next v2] net: dsa: mt7530: fix support for MT7531BE
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
References: <ZDvlLhhqheobUvOK@makrotopia.org>
 <8d36ff3b-e084-9f79-4c00-ec832f2cdbb3@arinc9.com>
 <ZDwDs6BHRo0ukfGF@makrotopia.org>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <ZDwDs6BHRo0ukfGF@makrotopia.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/04/2023 17:18, Daniel Golle wrote:
> On Sun, Apr 16, 2023 at 04:48:23PM +0300, Arınç ÜNAL wrote:
>> On 16.04.2023 15:08, Daniel Golle wrote:
>>> There are two variants of the MT7531 switch IC which got different
>>> features (and pins) regarding port 5:
>>>    * MT7531AE: SGMII/1000Base-X/2500Base-X SerDes PCS
>>>    * MT7531BE: RGMII
>>>
>>> Moving the creation of the SerDes PCS from mt753x_setup to mt7530_probe
>>> with commit 6de285229773 ("net: dsa: mt7530: move SGMII PCS creation
>>> to mt7530_probe function") works fine for MT7531AE which got two
>>> instances of mtk-pcs-lynxi, however, MT7531BE requires mt7531_pll_setup
>>> to setup clocks before the single PCS on port 6 (usually used as CPU
>>> port) starts to work and hence the PCS creation failed on MT7531BE.
>>>
>>> Fix this by introducing a pointer to mt7531_create_sgmii function in
>>> struct mt7530_priv and call it again at the end of mt753x_setup like it
>>> was before commit 6de285229773 ("net: dsa: mt7530: move SGMII PCS
>>> creation to mt7530_probe function").
>>>
>>> Fixes: 6de285229773 ("net: dsa: mt7530: move SGMII PCS creation to mt7530_probe function")
>>> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
>>
>> I'll put my 2 cents about the patch along with responding to your points on
>> the other thread here.
>>
>>> Why don't we use my original solution [1] which has some advantages:
>>>
>>>   * It doesn't requrire additional export of mt7530_regmap_bus
>>>
>>>   * It doesn't move PCS creation to mt7530.c, hence PCS_MTK_LYNXI is
>>>     only required for MDIO-connected switches
>>>     (with your patch we would have to move the dependency on PCS_MTK_LYNXI
>>>     from NET_DSA_MT7530_MDIO to NET_DSA_MT7530)
>>
>> Maybe this is what should happen. Maybe the PCS creation (and therefore
>> mt7530_regmap_bus) should be on the core driver. Both are on the MDIO driver
>> for the sole reason of only the devices on the MDIO driver currently using
>> it. It's not an MDIO-specific operation as far as I can tell. Having it on
>> the core driver would make more sense in the long run.
> 
> Which "long run" are you talking about?
> regmap creation is bus-specific, and so is the existence of LynxI PCS.
> There simply aren't any MMIO-connected switches which come with that IP.
> And I strongly doubt there ever will be. And even if, why should we now
> prepare for an entirely speculative future? If it actually happens, ie.
> in case there is going to be a new SoC with MMIO-connected switch which
> does comes with LynxI PCS (e.g. for port 5 only) we can still move the
> code.

Makes sense.

> 
>>
>>>
>>>   * It doesn't expose the dysfunctional SerDes PCS for port 5 on MT7531BE
>>>     This will still fail and hence result in probing on MT7531 to exit
>>>     prematurely, preventing the switch driver from being loaded.
>>>     Before 9ecc00164dc23 ("net: dsa: mt7530: refactor SGMII PCS creation")
>>>     the return value of mtk_pcs_lynxi_create was ignored, now it isn't...
>>
>> Ok, so checking whether port 5 is SGMII or not on the PCS creation code
>> should be done on the same patch that fixes this issue.
>>
>>>
>>>   * It changes much less in terms of LoC
>>
>> I'd rather prefer a better logic than the "least amount of changes possible"
>> approach.
>>
>> Let's analyse what this patch does:
>>
>> With this patch, mt7531_create_sgmii() is run after mt7530_setup_mdio is
>> run, under mt753x_setup(). mt7531_pll_setup() and, as the last requirement,
>> mt7530_setup_mdio() must be run to be able to create the PCS instances. That
>> also means running mt7530_free_irq_common must be avoided since the device
>> uses MDIO so mt7530_free_mdio_irq needs to be run too.
>>
>> While probing the driver, the priv->create_sgmii pointer will be made to
>> point to mt7531_create_sgmii, if MT7531 is detected. Why? This pointer won't
>> be used for any other devices and sgmii will always be created for any
>> MT7531 variants, so it's always going to point to mt7531_create_sgmii when
>> priv->id is ID_MT7531. So you're introducing a new pointer just to be able
>> to call mt7531_create_sgmii() on mt7530-mdio.c from mt7530.c.
>>
>> On mt753x_setup(), if priv->create_sgmii is pointing to something it will
>> now run whatever it points to with two arguments. One being the priv table
>> and the other being mt7531_dual_sgmii_supported() which returns 1 or 0 by
>> looking at the very same priv table. That looks bad. What could be done
>> instead is introduce a new field on the priv table that keeps the
>> information of whether port 5 on the MT7531 switch is SGMII or not.
> 
> Yes, and on a 64-bit system that means 8 bytes of memory for each instance.
> Exporting a function or const implies significantly more overhead, and
> it would not be as nicely limited in scope as a function pointer would be.
> 
> There are no other users in the kernel of the const you would export in
> your variant of the fix, so why have it exported?
> 
>>
>> A similar logic is already there on the U-Boot MediaTek ethernet driver.
>>
>> https://github.com/u-boot/u-boot/blob/a94ab561e2f49a80d8579930e840b810ab1a1330/drivers/net/mtk_eth.c#L903
>>
>> So this patch fixes the issue with the only consideration being changing as
>> less lines of code as possible.
> 
> You are ignore two more important arguments:
>   * It doesn't requrire additional export of mt7530_regmap_bus
>     (which would imply significantly more storage overhead compared to
>     an additional function pointer in a priv struct)
> 
>   * It doesn't move PCS creation to mt7530.c, hence PCS_MTK_LYNXI is
>     only required for MDIO-connected switches
>     (with your patch we would have to move the dependency on PCS_MTK_LYNXI
>     from NET_DSA_MT7530_MDIO to NET_DSA_MT7530)

Understood.

> 
>> And that's okay. We can make the least
>> amount of changes to fix the issue first, then improve the driver. But
>> there's nothing new made on the driver after the commit that caused this
>> issue, backportability to the stable trees is a non-issue. So why not do it
>> properly the first time?
> 
> Most of all I'd rather have it fixed before net-next is merged to Linus'
> tree and also before net-next will close again.
> 
> However, I also simply don't see what would be more "proper" about your
> solution.

Nothing. Your patch here is perfectly fine after reading your points. 
One thing I'd like to ask is, if I understand correctly, instead of 
exporting mt7531_create_sgmii(), defining a pointer that points to it 
causes less overhead?

The current patch looks very similar to exporting a function. Instead of 
putting EXPORT_SYMBOL_GPL and declaring the function prototype on the 
header file, you declare a function pointer on the priv structure, then 
assign it to the function.

> 
>>
>> Whatever the outcome with this patch is, on my upcoming patch series, I
>> intend to move mt7531_create_sgmii to mt7530.c. Then introduce
>> priv->p5_sgmii to get rid of mt7531_dual_sgmii_supported().
> 
> What is the argument for that?

Nothing for moving mt7531_create_sgmii() but I think introducing 
priv->p5_sgmii with later patches is in the clear?

> 
> There is not a single MMIO-connected switch which comes with LynxI PCS.
> (see above)
> 
> Imho we should rather try to work into the opposite direction and move
> more code only used on either MDIO or MMIO from core to the
> bus-specific drivers. If needed we can even split them more, eg. have
> different modules for MT7530 and MT7531, so that even the driver for
> MDIO-connected MT7530 would not require MTK_PCS_LYNXI.

Interesting, I may work on this in the future. This could benefit my 
folks too.

> 
> In that sense I'm a big fan of the structure of the mt76 wireless
> driver: Have a core module for shared helper functions and then
> device-specific driver modules. Unfortunately many if not most drivers
> are doing the exact opposite approach, ie. having some abstration layer
> which will always need to be extended and changed with every
> unforeseeable new hardware to be supported which just results in lots
> of overhead and is a burden to maintain. You can see that in the rt2x00
> wireless driver which I also worked on a lot: Most of the abstractions
> aren't even useful with any of the latest hardware generations.
> 
> tl;dr: What's wrong with moving functions specific to either variant
> (MMIO vs. MDIO) into the corresponding modules and keeping the core
> slim and really only cover shared functionality? This is also why I
> originally wanted the names of files and Kconfig symbols to reflect the
> supported hardware rather than the supported bus-type -- I've changed
> that upon your request and now believe I should have argued more
> clearly why I made my choice like I did...

Ah that makes sense. I'd like to address this. I was already planning to 
to do some renaming on the driver. Please, allow me to do the work.

I intend to do this slightly different than your initial patch series 
though. Like calling the core driver core, instead of common, and making 
it selectable, and only imply the MT7530 MDIO driver.

We could split the core and mdio/mmio drivers in a way that there's just 
the core, then the device-specific driver modules. This would mean 
splitting the MT7530 MDIO driver to MT7530 and MT7531 along with moving 
code from core to these two drivers. I believe this would apply for 
MT7988 too. There would be a bit of reused code but it should follow the 
idea of what you say above. Then we can configure the kconfig accordingly.

Arınç
