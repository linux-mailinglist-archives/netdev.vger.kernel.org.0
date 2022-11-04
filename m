Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C952619BEA
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 16:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbiKDPlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 11:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232721AbiKDPlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 11:41:08 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B8D3205F
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 08:40:59 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id y4so5240756plb.2
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 08:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SXLt554ZgQrIuzXCPGPrd8ht1fbbRGnpRKmOyyXFSQU=;
        b=A47/1PEi+WlkhQm44Le3WI0jcJqACqqTBOjQlaSRZIbTHq88Te6HHhF6d3v2i9eg54
         0wncQZsnR+RnhQ3d/m6Nh+BCsHpRR7/sH3ld/xiOMGswP/NqIWp6r5J01T3XZzBA63o5
         dfoye+Ukc4JsvZRfIOUf6jTGS3Fb9ldtctpCWiNou6phzzwrpvam/TNYraBTDiAJj4ct
         ihgOJX+RoiOwWN3EMhnhG7oO8sAlMgq6XqsDMxRevR20X1qRlskjLNWVAFbBzbjajb0W
         QaN7pJV5csfCVVmKMMUw5wDVq5zDDAO0HUzJY4EdJrz8NdGW30x+AKZZLK2E2CavX+Yk
         5b6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SXLt554ZgQrIuzXCPGPrd8ht1fbbRGnpRKmOyyXFSQU=;
        b=zGXL5c/vYm9YWDRxloMh7mYo/Jw5HvML+riRY9HVZF3vfbuUcxVodxbJ5YFbD++a//
         BeyTjFgKbI8hUd5I7CSNSEI9ZsoWNHLcsn0zj0AZETiRo2tRPuoa+uCPNsJBb61pDgWV
         zbfVF8CTevsQ4QUQ/6emktcOz/ylEe1Vn+VD7qhmYbqGKhQ6E+ur9Ve48+kAouWTyNL7
         Gqk8UXyD5BN8l74OJ4TbEBb7TVyY2CbNKtUzIPKlVdTiF2UA9csFrrBjABa5JT7S8mE9
         RcahvvSx6hAmLRSZMBjxeDDosAt1h0BN1EuBz0AMOSCUKAriQeuCy8bcPzZ6iZmb7LJd
         ND5g==
X-Gm-Message-State: ACrzQf34OR12ESYqaXL/Edwxq86M4aBh7Jnux2a8ZDhjZ/AXXJHPhBnB
        VVvHnCObojw0XrAMfL+EnAM=
X-Google-Smtp-Source: AMsMyM7IyWybuW1FAN/4nzt320y4cJT/QMpKvQ3dxUIQNpoRBcnzr30Wuk6NgO+om7KoBaU3WqVo5g==
X-Received: by 2002:a17:90a:e297:b0:212:dc30:7fed with SMTP id d23-20020a17090ae29700b00212dc307fedmr55647429pjz.90.1667576458831;
        Fri, 04 Nov 2022 08:40:58 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:d113:4d5c:cb10:ba59? ([2600:8802:b00:4a48:d113:4d5c:cb10:ba59])
        by smtp.gmail.com with ESMTPSA id n62-20020a632741000000b0046feca0883fsm2477486pgn.64.2022.11.04.08.40.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Nov 2022 08:40:58 -0700 (PDT)
Message-ID: <7186132a-7040-7131-396d-f1d6321e39d7@gmail.com>
Date:   Fri, 4 Nov 2022 08:40:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next 4/4] net: dsa: remove phylink_validate() method
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20221101114806.1186516-1-vladimir.oltean@nxp.com>
 <20221101114806.1186516-5-vladimir.oltean@nxp.com>
 <Y2T2fIb5SBRQbn8I@shell.armlinux.org.uk>
 <Y2T47CorBztXGgS4@shell.armlinux.org.uk>
Content-Language: en-US
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <Y2T47CorBztXGgS4@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/4/2022 4:35 AM, Russell King (Oracle) wrote:
> On Fri, Nov 04, 2022 at 11:24:44AM +0000, Russell King (Oracle) wrote:
>> On Tue, Nov 01, 2022 at 01:48:06PM +0200, Vladimir Oltean wrote:
>>> As of now, all DSA drivers use phylink_generic_validate() and there is
>>> no known use case remaining for a driver-specific link mode validation
>>> procedure. As such, remove this DSA operation and let phylink determine
>>> what is supported based on config->mac_capabilities, which all drivers
>>> provide.
>>>
>>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>>> ---
>>> Not all DSA drivers provide config->mac_capabilities, for example
>>> mv88e6060, lan9303 and vsc73xx don't. However, there have been users of
>>> those drivers on recent kernels and no one reported that they fail to
>>> establish a link, so I'm guessing that they work (somehow). But I must
>>> admit I don't understand why phylink_generic_validate() works when
>>> mac_capabilities=0. Anyway, these drivers did not provide a
>>> phylink_validate() method before and do not provide one now, so nothing
>>> changes for them.
>>
>> There is one remaining issue that needs to be properly addressed,
>> which is the bcm_sf2 driver, which is basically buggy. The recent
>> kernel build bot reports reminded me of this.
>>
>> I've tried talking to Florian about it, and didn't make much progress,
>> so I'm carrying a patch in my tree which at least makes what is
>> provided to phylink correct.

Might be worth submitting as RFC/RFT and then just hunt me down until 
you get what you want from me?

>>
>> See
>> http://git.armlinux.org.uk/cgit/linux-arm.git/commit/?h=net-queue&id=63d77c1f9db167fd74994860a4a899df5c957aab
>> and all the FIXME comments in there.
>>
>> This driver really needs to be fixed before we kill DSA's
>> phylink_validate method (although doing so doesn't change anything
>> in mainline, but will remove my reminder that bcm_sf2 is still
>> technically broken.)
> 
> Here's the corrected patch, along with a bit more commentry about the
> problems that I had kicking around in another commit.
> 
> 8<=====
> From: Russell King <rmk+kernel@armlinux.org.uk>
> Subject: [PATCH] net: dsa: bcm_sf2: fix pause mode validation
> 
> The implementation appears not to appear to support pause modes on
> anything but RGMII, RGMII_TXID, MII and REVMII interface modes. Let
> phylink know that detail.
> 
> Moreover, RGMII_RXID and RGMII_ID appears to be unsupported.
> (This may not be correct; particularly see the FIXMEs in this patch.)
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>   drivers/net/dsa/bcm_sf2.c | 36 ++++++++++++++++++++++++++++++++++++
>   1 file changed, 36 insertions(+)
> 
> diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
> index 18a3847bd82b..6676971128d1 100644
> --- a/drivers/net/dsa/bcm_sf2.c
> +++ b/drivers/net/dsa/bcm_sf2.c
> @@ -727,6 +727,10 @@ static void bcm_sf2_sw_get_caps(struct dsa_switch *ds, int port,
>   		__set_bit(PHY_INTERFACE_MODE_MII, interfaces);
>   		__set_bit(PHY_INTERFACE_MODE_REVMII, interfaces);
>   		__set_bit(PHY_INTERFACE_MODE_GMII, interfaces);
> +
> +		/* FIXME 1: Are RGMII_RXID and RGMII_ID actually supported?
> +		 * See FIXME 2 and FIXME 3 below.
> +		 */

They are supported, just not tested and still don't have hardware to 
test, I suppose you can include both modes for simplicity if they end up 
being broken, a fix would be submitted.

>   		phy_interface_set_rgmii(interfaces);
>   	}
>   
> @@ -734,6 +738,28 @@ static void bcm_sf2_sw_get_caps(struct dsa_switch *ds, int port,
>   		MAC_10 | MAC_100 | MAC_1000;
>   }
>   
> +static void bcm_sf2_sw_validate(struct dsa_switch *ds, int port,
> +				unsigned long *supported,
> +				struct phylink_link_state *state)
> +{
> +	u32 caps;
> +
> +	caps = dsa_to_port(ds, port)->pl_config.mac_capabilities;
> +
> +	/* Pause modes are only programmed for these modes - see FIXME 3.
> +	 * So, as pause modes are not configured for other modes, disable
> +	 * support for them. If FIXME 3 is updated to allow the other RGMII
> +	 * modes, these should be included here as well.
> +	 */
> +	if (!(state->interface == PHY_INTERFACE_MODE_RGMII ||
> +	      state->interface == PHY_INTERFACE_MODE_RGMII_TXID ||
> +	      state->interface == PHY_INTERFACE_MODE_MII ||
> +	      state->interface == PHY_INTERFACE_MODE_REVMII))
> +		caps &= ~(MAC_ASYM_PAUSE | MAC_SYM_PAUSE);

Can be programmed on all ports.

> +
> +	phylink_validate_mask_caps(supported, state, caps);
> +}
> +
>   static void bcm_sf2_sw_mac_config(struct dsa_switch *ds, int port,
>   				  unsigned int mode,
>   				  const struct phylink_link_state *state)
> @@ -747,6 +773,11 @@ static void bcm_sf2_sw_mac_config(struct dsa_switch *ds, int port,
>   		return;
>   
>   	switch (state->interface) {
> +	/* FIXME 2: Are RGMII_RXID and RGMII_ID actually supported? This
> +	 * switch statement means that the RGMII control register does not
> +	 * get programmed in these two modes, but surely it needs to at least
> +	 * set the port mode to EXT_GPHY?
> +	 */
>   	case PHY_INTERFACE_MODE_RGMII:
>   		id_mode_dis = 1;
>   		fallthrough;
> @@ -850,6 +881,10 @@ static void bcm_sf2_sw_mac_link_up(struct dsa_switch *ds, int port,
>   		else
>   			offset = CORE_STS_OVERRIDE_GMIIP2_PORT(port);
>   
> +		/* FIXME 3: Are RGMII_RXID and RGMII_ID actually supported?
> +		 * Why are pause modes only supported for a couple of RGMII
> +		 * modes? Should this be using phy_interface_mode_is_rgmii()?
> +		 */
>   		if (interface == PHY_INTERFACE_MODE_RGMII ||
>   		    interface == PHY_INTERFACE_MODE_RGMII_TXID ||
>   		    interface == PHY_INTERFACE_MODE_MII ||
> @@ -1207,6 +1242,7 @@ static const struct dsa_switch_ops bcm_sf2_ops = {
>   	.get_ethtool_phy_stats	= b53_get_ethtool_phy_stats,
>   	.get_phy_flags		= bcm_sf2_sw_get_phy_flags,
>   	.phylink_get_caps	= bcm_sf2_sw_get_caps,
> +	.phylink_validate	= bcm_sf2_sw_validate,
>   	.phylink_mac_config	= bcm_sf2_sw_mac_config,
>   	.phylink_mac_link_down	= bcm_sf2_sw_mac_link_down,
>   	.phylink_mac_link_up	= bcm_sf2_sw_mac_link_up,

-- 
Florian
