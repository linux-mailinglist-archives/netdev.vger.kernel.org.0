Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB477675509
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 13:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbjATMyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 07:54:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjATMx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 07:53:58 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F5F2739
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 04:53:55 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id fl11-20020a05600c0b8b00b003daf72fc844so5799266wmb.0
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 04:53:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jOX+k3UuKq4AwEVoTFGeP49p2J4horE9GcjRB3TErg8=;
        b=6mIwiuDEhMKmaNtOb1sJLQNd77+rqnoRCSVB5MRztejuX+Hlf3vFLBP5P464PdpeDa
         7nItUP0m9bE4UXvOZH/ziTt1JB+SsxYnbUJ1XuwTpkRlt3TK73LYzRqPkNJkYxRMQ8s9
         p0rrkC4mB/3xgLCUU6LOiNJzZeccwrhVE1Wm/hmE8sSBR0IJtVgdjXOagO6og8Ybhbad
         OVMDgRhWw8C5jd91zHBcp7XrlwQ062aUOcCRiFJU+II26iy1iZEutECvI8suKYp+gd/h
         vBkIE+OEn/qGVvlFTiUA0n2aadIT1C3jNE0ORmn1ZD05nZ+puLU342b4s/29rkxgxCOd
         OssQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jOX+k3UuKq4AwEVoTFGeP49p2J4horE9GcjRB3TErg8=;
        b=mfqUHnuwHvzrWwLOsy0hZT6uah4/wq8xIKlV1b1Zh107k1Tx+/D8VpviFU7vut9PQF
         zTCbt6bANyqEgNlhutIG0jvnqb8ATutHIcxvHlMhkWg77dAbdB+YJhe0thZr9s5Vw8Fh
         aYFHeq4EijzjM9iR0tSmv3rHIU/CcKI0TqY54YoLmAlzf/15L6ym1oMTeZX6tyINQl25
         egEUO0LPIPqttGxFIDNlo2Mqkj84EV9AqR2SzJWKMa9fEd23QAXsTvXMePeHfvyAwUMW
         nEypJp58fFVyNVbMpcqlDI5stRve11OG70LWCIxwnI9SEr7/Eomoz+xulx3rp+LWAncP
         tn6A==
X-Gm-Message-State: AFqh2koSP+SC52YqZVZE4dLT1WUMQbOzcqcUlHT57J/C3t/6a4amZo65
        zh2/YRU9VdaAAL853zE73lPfmQ==
X-Google-Smtp-Source: AMrXdXvxXHogpg2Chy4fm7mIBnCZs2OhxGPuTCu/oTa1HEP5vR8dZYsav6bFPBxnvI8nFU7v2WOFEw==
X-Received: by 2002:a05:600c:982:b0:3da:f5b5:13ec with SMTP id w2-20020a05600c098200b003daf5b513ecmr13434229wmp.34.1674219233935;
        Fri, 20 Jan 2023 04:53:53 -0800 (PST)
Received: from localhost (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.gmail.com with ESMTPSA id i22-20020a05600c355600b003a84375d0d1sm2415952wmq.44.2023.01.20.04.53.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 04:53:53 -0800 (PST)
References: <d75ef7df-a645-7fdd-491a-f89f70dbea01@gmail.com>
 <Y8Qwk5H8Yd7qiN0j@lunn.ch>
 <03ea260e-f03c-d9d7-6f5f-ff72836f5739@gmail.com>
 <51abd8ca-8172-edfa-1c18-b1e48231f316@linaro.org>
 <6de25c61-c187-fb88-5bd7-477b1db1510e@gmail.com>
 <e75ed56f-ba25-f337-e879-33cc2a784740@gmail.com>
 <1jo7qtwm1z.fsf@starbuckisacylon.baylibre.com>
 <eef8668d-a1f1-7b5d-1a15-ebf3a00d1e4b@gmail.com>
 <dc1ab1b9-347e-5d6f-670b-03057a98d2dd@gmail.com>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Jerome Brunet <jbrunet@baylibre.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
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
Subject: Re: [PATCH net-next] net: phy: meson-gxl: support more
 G12A-internal PHY versions
Date:   Fri, 20 Jan 2023 13:48:31 +0100
In-reply-to: <dc1ab1b9-347e-5d6f-670b-03057a98d2dd@gmail.com>
Message-ID: <1j4jslwen5.fsf@starbuckisacylon.baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri 20 Jan 2023 at 11:52, Heiner Kallweit <hkallweit1@gmail.com> wrote:

> On 20.01.2023 11:22, Heiner Kallweit wrote:
>> On 20.01.2023 11:01, Jerome Brunet wrote:
>>>
>>> On Thu 19 Jan 2023 at 23:42, Heiner Kallweit <hkallweit1@gmail.com> wro=
te:
>>>
>>>> On 15.01.2023 21:38, Heiner Kallweit wrote:
>>>>> On 15.01.2023 19:43, Neil Armstrong wrote:
>>>>>> Hi Heiner,
>>>>>>
>>>>>> Le 15/01/2023 =C3=A0 18:09, Heiner Kallweit a =C3=A9crit=C2=A0:
>>>>>>> On 15.01.2023 17:57, Andrew Lunn wrote:
>>>>>>>> On Sun, Jan 15, 2023 at 04:19:37PM +0100, Heiner Kallweit wrote:
>>>>>>>>> On my SC2-based system the genphy driver was used because the PHY
>>>>>>>>> identifies as 0x01803300. It works normal with the meson g12a
>>>>>>>>> driver after this change.
>>>>>>>>> Switch to PHY_ID_MATCH_MODEL to cover the different sub-versions.
>>>>>>>>
>>>>>>>> Hi Heiner
>>>>>>>>
>>>>>>>> Are there any datasheets for these devices? Anything which documen=
ts
>>>>>>>> the lower nibble really is a revision?
>>>>>>>>
>>>>>>>> I'm just trying to avoid future problems where we find it is actua=
lly
>>>>>>>> a different PHY, needs its own MATCH_EXACT entry, and then we find=
 we
>>>>>>>> break devices using 0x01803302 which we had no idea exists, but got
>>>>>>>> covered by this change.
>>>>>>>>
>>>>>>> The SC2 platform inherited a lot from G12A, therefore it's plausible
>>>>>>> that it's the same PHY. Also the vendor driver for SC2 gives a hint
>>>>>>> as it has the following compatible for the PHY:
>>>>>>>
>>>>>>> compatible =3D "ethernet-phy-id0180.3301", "ethernet-phy-ieee802.3-=
c22";
>>>>>>>
>>>>>>> But you're right, I can't say for sure as I don't have the datashee=
ts.
>>>>>>
>>>>>> On G12A (& GXL), the PHY ID is set in the MDIO MUX registers,
>>>>>> please see:
>>>>>> https://elixir.bootlin.com/linux/latest/source/drivers/net/mdio/mdio=
-mux-meson-g12a.c#L36
>>>>>>
>>>>>> So you should either add support for the PHY mux in SC2 or check
>>>>>> what is in the ETH_PHY_CNTL0 register.
>>>>>>
>>>>> Thanks for the hint. I just checked and reading back ETH_PHY_CNTL0 at=
 the
>>>>> end of g12a_enable_internal_mdio() gives me the expected result of 0x=
33010180.
>>>>> But still the PHY reports 3300.
>>>>> Even if I write some other random value to ETH_PHY_CNTL0, I get 0180/=
3300
>>>>> as PHY ID.
>>>>>
>>>>> For u-boot I found the following:
>>>>>
>>>>> https://github.com/khadas/u-boot/blob/khadas-vim4-r-64bit/drivers/net=
/phy/amlogic.c
>>>>>
>>>>> static struct phy_driver amlogic_internal_driver =3D {
>>>>> 	.name =3D "Meson GXL Internal PHY",
>>>>> 	.uid =3D 0x01803300,
>>>>> 	.mask =3D 0xfffffff0,
>>>>> 	.features =3D PHY_BASIC_FEATURES,
>>>>> 	.config =3D &meson_phy_config,
>>>>> 	.startup =3D &meson_aml_startup,
>>>>> 	.shutdown =3D &genphy_shutdown,
>>>>> };
>>>>>
>>>>> So it's the same PHY ID I'm seeing in Linux.
>>>>>
>>>>> My best guess is that the following is the case:
>>>>>
>>>>> The PHY compatible string in DT is the following in all cases:
>>>>> compatible =3D "ethernet-phy-id0180.3301", "ethernet-phy-ieee802.3-c2=
2";
>>>>>
>>>>> Therefore id 0180/3301 is used even if the PHY reports something else.
>>>>> Means it doesn't matter which value you write to ETH_PHY_CNTL0.
>>>>>
>>>>> I reduced the compatible string to compatible =3D "ethernet-phy-ieee8=
02.3-c22"
>>>>> and this resulted in the actual PHY ID being used.
>>>>> You could change the compatible in dts the same way for any g12a syst=
em
>>>>> and I assume you would get 0180/3300 too.
>>>>>
>>>>> Remaining question is why the value in ETH_PHY_CNTL0 is ignored.
>>>>>
>>>>
>>>> I think I found what's going on. The PHY ID written to SoC register
>>>> ETH_PHY_CNTL0 isn't effective immediately. It takes a PHY soft reset b=
efore
>>>> it reports the new PHY ID. Would be good to have a comment in the
>>>> g12a mdio mux code mentioning this constraint.
>>>>
>>>> I see no easy way to trigger a soft reset early enough. Therefore it's=
 indeed
>>>> the simplest option to specify the new PHY ID in the compatible.
>>>
>>> This is because (I guess) the PHY only picks ups the ID from the glue
>>> when it powers up. After that the values are ignored.
>>>
>> I tested and a PHY soft reset is also sufficient to pick up the new PHY =
ID.
>> Supposedly everything executing the soft reset logic is sufficient:
>> power-up, soft reset, coming out of suspend/power-down
>>=20
>>=20
>>> Remember the PHY is a "bought" IP, the glue/mux provides the input
>>> settings required by the PHY provider.
>>>
>>> Best would be to trigger an HW reset of PHY from glue after setting the
>>> register ETH_PHY_CNTL0.
>>>
>>> Maybe this patch could help : ?
>>> https://gitlab.com/jbrunet/linux/-/commit/ccbb07b0c9eb2de26818eb4f8aa1f=
d0e5b31e6db.patch
>>>
>> Thanks for the hint, I'll look at it and test.
>>=20
>>> I tried this when we debugged the connectivity issue on the g12 earlier
>>> this spring. I did not send it because the problem was found to be in
>>> stmmac.
>>>
>>=20
>
> I tested the patch with a slight modification. Maybe the PHY picks up oth=
er
> settings also on power-up/soft-reset only. Therefore I moved setting
> ETH_PHY_CNTL2 to before powering up the PHY. Do you think that's needed/b=
etter?

Something in between.
The first write to CNTL1 powers off the PHY if it was on.
I think I'll change CNTL2 while the PHY is down and then power it back up

>
> With this patch the new PHY ID is effective early enough and the right
> PHY driver is loaded also w/o overriding the PHY ID with a compatible.
>
> Based on which version of the patch you prefer, are you going to submit i=
t?
> Else I can do it too, just let me know.

Thanks for testing. I will submit it soon.

>
>
> diff --git a/drivers/net/mdio/mdio-mux-meson-g12a.c b/drivers/net/mdio/md=
io-mux-meson-g12a.c
> index 9d21fdf85..7882dcce2 100644
> --- a/drivers/net/mdio/mdio-mux-meson-g12a.c
> +++ b/drivers/net/mdio/mdio-mux-meson-g12a.c
> @@ -6,6 +6,7 @@
>  #include <linux/bitfield.h>
>  #include <linux/clk.h>
>  #include <linux/clk-provider.h>
> +#include <linux/delay.h>
>  #include <linux/device.h>
>  #include <linux/io.h>
>  #include <linux/iopoll.h>
> @@ -148,6 +149,7 @@ static const struct clk_ops g12a_ephy_pll_ops =3D {
>=20=20
>  static int g12a_enable_internal_mdio(struct g12a_mdio_mux *priv)
>  {
> +	u32 val;
>  	int ret;
>=20=20
>  	/* Enable the phy clock */
> @@ -159,17 +161,19 @@ static int g12a_enable_internal_mdio(struct g12a_md=
io_mux *priv)
>=20=20
>  	/* Initialize ephy control */
>  	writel(EPHY_G12A_ID, priv->regs + ETH_PHY_CNTL0);
> -	writel(FIELD_PREP(PHY_CNTL1_ST_MODE, 3) |
> -	       FIELD_PREP(PHY_CNTL1_ST_PHYADD, EPHY_DFLT_ADD) |
> -	       FIELD_PREP(PHY_CNTL1_MII_MODE, EPHY_MODE_RMII) |
> -	       PHY_CNTL1_CLK_EN |
> -	       PHY_CNTL1_CLKFREQ |
> -	       PHY_CNTL1_PHY_ENB,
> -	       priv->regs + ETH_PHY_CNTL1);
>  	writel(PHY_CNTL2_USE_INTERNAL |
>  	       PHY_CNTL2_SMI_SRC_MAC |
>  	       PHY_CNTL2_RX_CLK_EPHY,
>  	       priv->regs + ETH_PHY_CNTL2);
> +	val =3D FIELD_PREP(PHY_CNTL1_ST_MODE, 3) |
> +	      FIELD_PREP(PHY_CNTL1_ST_PHYADD, EPHY_DFLT_ADD) |
> +	      FIELD_PREP(PHY_CNTL1_MII_MODE, EPHY_MODE_RMII) |
> +	      PHY_CNTL1_CLK_EN |
> +	      PHY_CNTL1_CLKFREQ;
> +	writel(val, priv->regs + ETH_PHY_CNTL1);
> +	val |=3D PHY_CNTL1_PHY_ENB;
> +	writel(val, priv->regs + ETH_PHY_CNTL1);
> +	mdelay(10);
>=20=20
>  	return 0;
>  }

