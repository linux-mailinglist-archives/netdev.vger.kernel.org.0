Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5081A64E000
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 18:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbiLORuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 12:50:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbiLORuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 12:50:12 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451DA2A729;
        Thu, 15 Dec 2022 09:50:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=uVn/Pl53um1F/W4Lbsa2ds6oVdqY2RiRVQVPI9k4t+s=; b=iulAbGxlip+XUz9hkvsvrqXl/Q
        pVmaszNpjNbtu/gu4/0kHTlBGw+iVKa31KvKzguuGL9gzwAkSO77ftHmVB+93baASDyOZnNYmH0bZ
        SwKILYkT5D8HmncUOU0/Oavux3olEJYmTM4BBepYDhxBdQ7nbtVrW3Oh8oClWoibKoKuho2XFcJz4
        BnftWnrqakhBCQUiVXPRsJ5hY1n0zCgBMpDKE/pfua/IQxopElxEb0yeFTuIgttpp5Vdq53kb5sfc
        H/vSqF0bHEova8HJN+OdyinMLVPIIyaaONAl7VKJZMvR+oNaiLMDgw8azkTP/zQRMSsMcZCD/B7fA
        ekHLvbeA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35730)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p5sMp-0003Yv-UF; Thu, 15 Dec 2022 17:49:59 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p5sMo-000064-09; Thu, 15 Dec 2022 17:49:58 +0000
Date:   Thu, 15 Dec 2022 17:49:57 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: Re: [PATCH v7 10/11] net: dsa: qca8k: add LEDs support
Message-ID: <Y5teRQ5mv1aTix4w@shell.armlinux.org.uk>
References: <20221214235438.30271-1-ansuelsmth@gmail.com>
 <20221214235438.30271-11-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221214235438.30271-11-ansuelsmth@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Dec 15, 2022 at 12:54:37AM +0100, Christian Marangi wrote:
> +static int
> +qca8k_cled_hw_control_configure(struct led_classdev *ldev, unsigned long rules,
> +				enum blink_mode_cmd cmd)
> +{
> +	struct qca8k_led *led = container_of(ldev, struct qca8k_led, cdev);
> +	struct led_trigger *trigger = ldev->trigger;
> +	struct qca8k_led_pattern_en reg_info;
> +	struct qca8k_priv *priv = led->priv;
> +	u32 offload_trigger = 0, mask, val;
> +	int ret;
> +
> +	/* Check trigger compatibility */
> +	if (strcmp(trigger->name, "netdev"))
> +		return -EOPNOTSUPP;
> +
> +	if (!strcmp(trigger->name, "netdev"))
> +		ret = qca8k_parse_netdev(rules, &offload_trigger, &mask);

I'm not sure how well the compiler will spot that, but as far as
readability goes, that second if() statement appears to be redundant.

> +
> +	if (ret)
> +		return ret;
> +
> +	qca8k_get_control_led_reg(led->port_num, led->led_num, &reg_info);
> +
> +	switch (cmd) {
> +	case BLINK_MODE_SUPPORTED:
> +		/* We reach this point, we are sure the trigger is supported */
> +		return 1;
> +	case BLINK_MODE_ZERO:
> +		/* We set 4hz by default */
> +		u32 default_reg = QCA8K_LED_BLINK_4HZ;
> +
> +		ret = regmap_update_bits(priv->regmap, reg_info.reg,
> +					 QCA8K_LED_RULE_MASK << reg_info.shift,
> +					 default_reg << reg_info.shift);
> +		break;
> +	case BLINK_MODE_ENABLE:
> +		ret = regmap_update_bits(priv->regmap, reg_info.reg,
> +					 mask << reg_info.shift,
> +					 offload_trigger << reg_info.shift);
> +		break;
> +	case BLINK_MODE_DISABLE:
> +		ret = regmap_update_bits(priv->regmap, reg_info.reg,
> +					 mask << reg_info.shift,
> +					 0);
> +		break;

I think it needs to be made more clear in the documentation that if
this is called with ENABLE, then _only_ those modes in flags... (or
is it now called "rules"?) are to be enabled and all other modes
should be disabled. Conversely, DISABLE is used to disable all
modes. However, if that's the case, then ZERO was misdescribed, and
should probably be called DEFAULT. At least that's the impression
that I get from the above code.

> +	case BLINK_MODE_READ:
> +		ret = regmap_read(priv->regmap, reg_info.reg, &val);
> +		if (ret)
> +			return ret;
> +
> +		val >>= reg_info.shift;
> +		val &= offload_trigger;
> +
> +		/* Special handling for LED_BLINK_2HZ */
> +		if (!val && offload_trigger == QCA8K_LED_BLINK_2HZ)
> +			val = 1;

Hmm, so if a number of different modes is in flags or rules, then
as long as one matches, this returns 1? So it's an "any of these
modes is enabled" test.

> +
> +		return val;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return ret;
> +}
> +
> +static void
> +qca8k_led_brightness_set(struct qca8k_led *led,
> +			 enum led_brightness b)
> +{
> +	struct qca8k_led_pattern_en reg_info;
> +	struct qca8k_priv *priv = led->priv;
> +	u32 val = QCA8K_LED_ALWAYS_OFF;
> +
> +	qca8k_get_enable_led_reg(led->port_num, led->led_num, &reg_info);
> +
> +	if (b)
> +		val = QCA8K_LED_ALWAYS_ON;
> +
> +	regmap_update_bits(priv->regmap, reg_info.reg,
> +			   GENMASK(1, 0) << reg_info.shift,
> +			   val << reg_info.shift);
> +}
> +
> +static void
> +qca8k_cled_brightness_set(struct led_classdev *ldev,
> +			  enum led_brightness b)
> +{
> +	struct qca8k_led *led = container_of(ldev, struct qca8k_led, cdev);
> +
> +	return qca8k_led_brightness_set(led, b);
> +}
> +
> +static enum led_brightness
> +qca8k_led_brightness_get(struct qca8k_led *led)
> +{
> +	struct qca8k_led_pattern_en reg_info;
> +	struct qca8k_priv *priv = led->priv;
> +	u32 val;
> +	int ret;
> +
> +	qca8k_get_enable_led_reg(led->port_num, led->led_num, &reg_info);
> +
> +	ret = regmap_read(priv->regmap, reg_info.reg, &val);
> +	if (ret)
> +		return 0;
> +
> +	val >>= reg_info.shift;
> +	val &= GENMASK(1, 0);
> +
> +	return val > 0 ? 1 : 0;
> +}
> +
> +static enum led_brightness
> +qca8k_cled_brightness_get(struct led_classdev *ldev)
> +{
> +	struct qca8k_led *led = container_of(ldev, struct qca8k_led, cdev);
> +
> +	return qca8k_led_brightness_get(led);
> +}
> +
> +static int
> +qca8k_cled_blink_set(struct led_classdev *ldev,
> +		     unsigned long *delay_on,
> +		     unsigned long *delay_off)
> +{
> +	struct qca8k_led *led = container_of(ldev, struct qca8k_led, cdev);
> +	struct qca8k_led_pattern_en reg_info;
> +	struct qca8k_priv *priv = led->priv;
> +
> +	if (*delay_on == 0 && *delay_off == 0) {
> +		*delay_on = 125;
> +		*delay_off = 125;
> +	}
> +
> +	if (*delay_on != 125 || *delay_off != 125) {
> +		/* The hardware only supports blinking at 4Hz. Fall back
> +		 * to software implementation in other cases.
> +		 */
> +		return -EINVAL;
> +	}
> +
> +	qca8k_get_enable_led_reg(led->port_num, led->led_num, &reg_info);
> +
> +	regmap_update_bits(priv->regmap, reg_info.reg,
> +			   GENMASK(1, 0) << reg_info.shift,
> +			   QCA8K_LED_ALWAYS_BLINK_4HZ << reg_info.shift);
> +
> +	return 0;
> +}
> +
> +static int
> +qca8k_cled_trigger_offload(struct led_classdev *ldev, bool enable)
> +{
> +	struct qca8k_led *led = container_of(ldev, struct qca8k_led, cdev);
> +
> +	struct qca8k_led_pattern_en reg_info;
> +	struct qca8k_priv *priv = led->priv;
> +	u32 val = QCA8K_LED_ALWAYS_OFF;
> +
> +	qca8k_get_enable_led_reg(led->port_num, led->led_num, &reg_info);
> +
> +	if (enable)
> +		val = QCA8K_LED_RULE_CONTROLLED;
> +
> +	return regmap_update_bits(priv->regmap, reg_info.reg,
> +				  GENMASK(1, 0) << reg_info.shift,
> +				  val << reg_info.shift);

88e151x doesn't have the ability to change in this way - we have
a register with a 4-bit field which selects the LED mode from one
of many, or forces the LED on/off/hi-z/blink.

Not specifically for this patch, but talking generally about this
approach, the other issue I forsee with this is that yes, 88e151x has
three LEDs, but the LED modes are also used to implement control
signals (e.g., on a SFP, LOS can be implemented by programming mode
0 on LED2 (which makes it indicate link or not.) If we expose all the
LEDs we run the risk of the LED subsystem trampling over that
configuration and essentially messing up such modules. So the Marvell
PHY driver would need to know when it is appropriate to expose these
things to the LED subsystem.

I guess doing it dependent on firmware description as you do in
this driver would work - if there's no firmware description, they're
not exposed.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
