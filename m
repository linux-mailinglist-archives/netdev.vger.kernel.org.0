Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C942B6752CB
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 11:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbjATKwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 05:52:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbjATKwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 05:52:19 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855A0B2E4D
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 02:52:16 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id vw16so12863249ejc.12
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 02:52:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:references:cc:to:from
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iN03NvQhT/BdhwfWBiypYa/s2Rg4sHw2i2q465Uwpwk=;
        b=g8V3jI2gTRF/dCqarJmm80abJW68h+PUsb4fJRMt3QsKZ1xKgBQQ2LSmizlzpGm9bb
         xU0a4fnSQbiG+b9Xxj77ldFNCHYJgGmLYYnkSBlvH1pyMQlksY/w4MyiYtOVKPMeBisr
         qMS6jQuf+sVWNzN++wOW97NY16mSFrrZPaSkEJckNrFS849wy+7VQKI3cjcz9UXKAxMU
         mFClo2+mz8cZvH7K9WiV0lmXz8GmU2mpnYU5CcAllWVQ3V9mCmEV0B1RK4yiNAOb4Cy+
         GHPAzG4oltNxHk6WLdycbPRz3fRUUwv1XnOcAJ19pr4JOpXHUIUgXYn5cOfivOvVEA05
         dEFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:references:cc:to:from
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iN03NvQhT/BdhwfWBiypYa/s2Rg4sHw2i2q465Uwpwk=;
        b=YgDLNtkPtrBROygbsenV2AgIfGol41G4UU+msCWxX3zSjGgewMLZk5AioTi6GNgJLe
         0rIpmoBkUQMuNuiwrHkqrbuwsibuTRh23AyRbUGvajguuRCJBXkD5Z55MTUV10SveMBT
         Fc9ICaa9ySgQ35n2NeBeCqBTgDTVLgr09tAdDFlkZ0xDgXV+9azKn6ehavXdMu/krtfZ
         7Ct0ylQTbFdu9oDJWaXCIbFgmWKIImGzUUhGTTN4/7Q64CCHW3SaMvfi5AdAATwtuS6F
         asHoDLcGfYo9xB/N3rG2PFSvE/e3F7dIZ7tKF0ixMN6SuBrb2XoZfyatTQJ2PCjBtyuW
         4bww==
X-Gm-Message-State: AFqh2kqB3g88vnBhAaMUZKy1k9zMvNTb3OxiGzFwgH9SUvCI7ThFtU9h
        wMR1O6IqVxGhBYz9Fpm4acU=
X-Google-Smtp-Source: AMrXdXssf4A0K3c+R5tSKAMUkP1XIc17VwKVdzDy8P+j0b+8/MfqruVLsVGW9lQkK2YqveBUF3IiEg==
X-Received: by 2002:a17:907:91d3:b0:86e:3e0c:ae50 with SMTP id h19-20020a17090791d300b0086e3e0cae50mr9421742ejz.14.1674211934885;
        Fri, 20 Jan 2023 02:52:14 -0800 (PST)
Received: from ?IPV6:2a01:c23:bc41:e300:8963:d1f4:1cd7:2821? (dynamic-2a01-0c23-bc41-e300-8963-d1f4-1cd7-2821.c23.pool.telefonica.de. [2a01:c23:bc41:e300:8963:d1f4:1cd7:2821])
        by smtp.googlemail.com with ESMTPSA id a8-20020aa7d908000000b0049dfd6bdc25sm7996301edr.84.2023.01.20.02.52.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Jan 2023 02:52:14 -0800 (PST)
Message-ID: <dc1ab1b9-347e-5d6f-670b-03057a98d2dd@gmail.com>
Date:   Fri, 20 Jan 2023 11:52:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jerome Brunet <jbrunet@baylibre.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kevin Hilman <khilman@baylibre.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>
References: <d75ef7df-a645-7fdd-491a-f89f70dbea01@gmail.com>
 <Y8Qwk5H8Yd7qiN0j@lunn.ch> <03ea260e-f03c-d9d7-6f5f-ff72836f5739@gmail.com>
 <51abd8ca-8172-edfa-1c18-b1e48231f316@linaro.org>
 <6de25c61-c187-fb88-5bd7-477b1db1510e@gmail.com>
 <e75ed56f-ba25-f337-e879-33cc2a784740@gmail.com>
 <1jo7qtwm1z.fsf@starbuckisacylon.baylibre.com>
 <eef8668d-a1f1-7b5d-1a15-ebf3a00d1e4b@gmail.com>
Subject: Re: [PATCH net-next] net: phy: meson-gxl: support more G12A-internal
 PHY versions
In-Reply-To: <eef8668d-a1f1-7b5d-1a15-ebf3a00d1e4b@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.01.2023 11:22, Heiner Kallweit wrote:
> On 20.01.2023 11:01, Jerome Brunet wrote:
>>
>> On Thu 19 Jan 2023 at 23:42, Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>
>>> On 15.01.2023 21:38, Heiner Kallweit wrote:
>>>> On 15.01.2023 19:43, Neil Armstrong wrote:
>>>>> Hi Heiner,
>>>>>
>>>>> Le 15/01/2023 à 18:09, Heiner Kallweit a écrit :
>>>>>> On 15.01.2023 17:57, Andrew Lunn wrote:
>>>>>>> On Sun, Jan 15, 2023 at 04:19:37PM +0100, Heiner Kallweit wrote:
>>>>>>>> On my SC2-based system the genphy driver was used because the PHY
>>>>>>>> identifies as 0x01803300. It works normal with the meson g12a
>>>>>>>> driver after this change.
>>>>>>>> Switch to PHY_ID_MATCH_MODEL to cover the different sub-versions.
>>>>>>>
>>>>>>> Hi Heiner
>>>>>>>
>>>>>>> Are there any datasheets for these devices? Anything which documents
>>>>>>> the lower nibble really is a revision?
>>>>>>>
>>>>>>> I'm just trying to avoid future problems where we find it is actually
>>>>>>> a different PHY, needs its own MATCH_EXACT entry, and then we find we
>>>>>>> break devices using 0x01803302 which we had no idea exists, but got
>>>>>>> covered by this change.
>>>>>>>
>>>>>> The SC2 platform inherited a lot from G12A, therefore it's plausible
>>>>>> that it's the same PHY. Also the vendor driver for SC2 gives a hint
>>>>>> as it has the following compatible for the PHY:
>>>>>>
>>>>>> compatible = "ethernet-phy-id0180.3301", "ethernet-phy-ieee802.3-c22";
>>>>>>
>>>>>> But you're right, I can't say for sure as I don't have the datasheets.
>>>>>
>>>>> On G12A (& GXL), the PHY ID is set in the MDIO MUX registers,
>>>>> please see:
>>>>> https://elixir.bootlin.com/linux/latest/source/drivers/net/mdio/mdio-mux-meson-g12a.c#L36
>>>>>
>>>>> So you should either add support for the PHY mux in SC2 or check
>>>>> what is in the ETH_PHY_CNTL0 register.
>>>>>
>>>> Thanks for the hint. I just checked and reading back ETH_PHY_CNTL0 at the
>>>> end of g12a_enable_internal_mdio() gives me the expected result of 0x33010180.
>>>> But still the PHY reports 3300.
>>>> Even if I write some other random value to ETH_PHY_CNTL0, I get 0180/3300
>>>> as PHY ID.
>>>>
>>>> For u-boot I found the following:
>>>>
>>>> https://github.com/khadas/u-boot/blob/khadas-vim4-r-64bit/drivers/net/phy/amlogic.c
>>>>
>>>> static struct phy_driver amlogic_internal_driver = {
>>>> 	.name = "Meson GXL Internal PHY",
>>>> 	.uid = 0x01803300,
>>>> 	.mask = 0xfffffff0,
>>>> 	.features = PHY_BASIC_FEATURES,
>>>> 	.config = &meson_phy_config,
>>>> 	.startup = &meson_aml_startup,
>>>> 	.shutdown = &genphy_shutdown,
>>>> };
>>>>
>>>> So it's the same PHY ID I'm seeing in Linux.
>>>>
>>>> My best guess is that the following is the case:
>>>>
>>>> The PHY compatible string in DT is the following in all cases:
>>>> compatible = "ethernet-phy-id0180.3301", "ethernet-phy-ieee802.3-c22";
>>>>
>>>> Therefore id 0180/3301 is used even if the PHY reports something else.
>>>> Means it doesn't matter which value you write to ETH_PHY_CNTL0.
>>>>
>>>> I reduced the compatible string to compatible = "ethernet-phy-ieee802.3-c22"
>>>> and this resulted in the actual PHY ID being used.
>>>> You could change the compatible in dts the same way for any g12a system
>>>> and I assume you would get 0180/3300 too.
>>>>
>>>> Remaining question is why the value in ETH_PHY_CNTL0 is ignored.
>>>>
>>>
>>> I think I found what's going on. The PHY ID written to SoC register
>>> ETH_PHY_CNTL0 isn't effective immediately. It takes a PHY soft reset before
>>> it reports the new PHY ID. Would be good to have a comment in the
>>> g12a mdio mux code mentioning this constraint.
>>>
>>> I see no easy way to trigger a soft reset early enough. Therefore it's indeed
>>> the simplest option to specify the new PHY ID in the compatible.
>>
>> This is because (I guess) the PHY only picks ups the ID from the glue
>> when it powers up. After that the values are ignored.
>>
> I tested and a PHY soft reset is also sufficient to pick up the new PHY ID.
> Supposedly everything executing the soft reset logic is sufficient:
> power-up, soft reset, coming out of suspend/power-down
> 
> 
>> Remember the PHY is a "bought" IP, the glue/mux provides the input
>> settings required by the PHY provider.
>>
>> Best would be to trigger an HW reset of PHY from glue after setting the
>> register ETH_PHY_CNTL0.
>>
>> Maybe this patch could help : ?
>> https://gitlab.com/jbrunet/linux/-/commit/ccbb07b0c9eb2de26818eb4f8aa1fd0e5b31e6db.patch
>>
> Thanks for the hint, I'll look at it and test.
> 
>> I tried this when we debugged the connectivity issue on the g12 earlier
>> this spring. I did not send it because the problem was found to be in
>> stmmac.
>>
> 

I tested the patch with a slight modification. Maybe the PHY picks up other
settings also on power-up/soft-reset only. Therefore I moved setting
ETH_PHY_CNTL2 to before powering up the PHY. Do you think that's needed/better?

With this patch the new PHY ID is effective early enough and the right
PHY driver is loaded also w/o overriding the PHY ID with a compatible.

Based on which version of the patch you prefer, are you going to submit it?
Else I can do it too, just let me know.


diff --git a/drivers/net/mdio/mdio-mux-meson-g12a.c b/drivers/net/mdio/mdio-mux-meson-g12a.c
index 9d21fdf85..7882dcce2 100644
--- a/drivers/net/mdio/mdio-mux-meson-g12a.c
+++ b/drivers/net/mdio/mdio-mux-meson-g12a.c
@@ -6,6 +6,7 @@
 #include <linux/bitfield.h>
 #include <linux/clk.h>
 #include <linux/clk-provider.h>
+#include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/io.h>
 #include <linux/iopoll.h>
@@ -148,6 +149,7 @@ static const struct clk_ops g12a_ephy_pll_ops = {
 
 static int g12a_enable_internal_mdio(struct g12a_mdio_mux *priv)
 {
+	u32 val;
 	int ret;
 
 	/* Enable the phy clock */
@@ -159,17 +161,19 @@ static int g12a_enable_internal_mdio(struct g12a_mdio_mux *priv)
 
 	/* Initialize ephy control */
 	writel(EPHY_G12A_ID, priv->regs + ETH_PHY_CNTL0);
-	writel(FIELD_PREP(PHY_CNTL1_ST_MODE, 3) |
-	       FIELD_PREP(PHY_CNTL1_ST_PHYADD, EPHY_DFLT_ADD) |
-	       FIELD_PREP(PHY_CNTL1_MII_MODE, EPHY_MODE_RMII) |
-	       PHY_CNTL1_CLK_EN |
-	       PHY_CNTL1_CLKFREQ |
-	       PHY_CNTL1_PHY_ENB,
-	       priv->regs + ETH_PHY_CNTL1);
 	writel(PHY_CNTL2_USE_INTERNAL |
 	       PHY_CNTL2_SMI_SRC_MAC |
 	       PHY_CNTL2_RX_CLK_EPHY,
 	       priv->regs + ETH_PHY_CNTL2);
+	val = FIELD_PREP(PHY_CNTL1_ST_MODE, 3) |
+	      FIELD_PREP(PHY_CNTL1_ST_PHYADD, EPHY_DFLT_ADD) |
+	      FIELD_PREP(PHY_CNTL1_MII_MODE, EPHY_MODE_RMII) |
+	      PHY_CNTL1_CLK_EN |
+	      PHY_CNTL1_CLKFREQ;
+	writel(val, priv->regs + ETH_PHY_CNTL1);
+	val |= PHY_CNTL1_PHY_ENB;
+	writel(val, priv->regs + ETH_PHY_CNTL1);
+	mdelay(10);
 
 	return 0;
 }
-- 
2.39.0


