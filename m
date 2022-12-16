Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B728164F0A1
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 18:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbiLPRtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 12:49:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbiLPRss (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 12:48:48 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC73975096;
        Fri, 16 Dec 2022 09:48:36 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id ay14-20020a05600c1e0e00b003cf6ab34b61so4649477wmb.2;
        Fri, 16 Dec 2022 09:48:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=8zWJfmGJB8jfPH50vyYfP5Ey+tTmkUfqlzx6LleQ+S8=;
        b=lrx9iZ4hdiaz7S+3dS9g7iVkeHOEIGR3an1TsGz7KMYt7BgQOcZIcaglJn5D299NsU
         WXyML7zPnKGqQKkkEMdGTcUpu89azoy/Z070dyTFy733n8fw+SMSRCZMul6gQfah/xwb
         g9TD5pL8bp10oEuoLeYtzXcuXi8GxTguRJg653hVjHwSnh8x9TfkVMnFsi17QulIOGaR
         1Aa4k6W4jeBn3l+iZJVFjRmz0HPo20I6R4SJDMk9Y74l2SmKqhs0ALq3OsEZfUqAMa4q
         2GGW1OzsKM0d0dI3+DfnZ2dFkjggfWMmRxWFYBpWIM3qMNpPxheNmimwmmkTLSEm/l19
         D8Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8zWJfmGJB8jfPH50vyYfP5Ey+tTmkUfqlzx6LleQ+S8=;
        b=k/mMkcDrTvUNq3+ZkWzGQbh3vQAfALnvXgIlvpFAVfCh8JkUPV7lBM5lJT2+agsPSK
         usCYHblBOyL5TRuEsFkWLoihcDfD8VLph++BJmSjLyDsXn0ZxR6eihVhH0pL6oqg9QvE
         ISAaPTaEvcrv9DER4x4xWxDrMCo4SQtCXTL+wS0dOE4WoL/US7iq3B/i5ke8JEn9j1lK
         +t4lk6LHFPmB+hRfj5j36vHQqYXpHLy9AanT8/5g68dYCcyXAx8LuIgXX7sR2HLWDfq8
         KH2bvykCyrBWZGzNeTSDMEUIussWg+yihe2Wgczthrp51i2pT44OwpwPn+8A9eqHkO3+
         Faag==
X-Gm-Message-State: ANoB5pl0wAIc/lve0Dfvwe/X6EnqshKUF4Q4LgnDY5e88qDsNdx7Ot9v
        1LHAAaD64IwKUW/yrmSKvRA=
X-Google-Smtp-Source: AA0mqf7k2Crj5d7n+weeeEhbDEz6FWokKcOlQ+o/Mi0kDYBhYsFqKRgSQoEPJAMEVtDF/DdZaH/d8g==
X-Received: by 2002:a05:600c:1c87:b0:3cf:ae53:9193 with SMTP id k7-20020a05600c1c8700b003cfae539193mr27635762wms.39.1671212915241;
        Fri, 16 Dec 2022 09:48:35 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-18.ip85.fastwebnet.it. [93.42.71.18])
        by smtp.gmail.com with ESMTPSA id t187-20020a1c46c4000000b003d21759db42sm10676460wma.5.2022.12.16.09.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 09:48:34 -0800 (PST)
Message-ID: <639caf72.1c0a0220.cda85.0678@mx.google.com>
X-Google-Original-Message-ID: <Y5yvc8VBzH/IMswW@Ansuel-xps.>
Date:   Fri, 16 Dec 2022 18:48:35 +0100
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
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
References: <20221214235438.30271-1-ansuelsmth@gmail.com>
 <20221214235438.30271-11-ansuelsmth@gmail.com>
 <Y5teRQ5mv1aTix4w@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5teRQ5mv1aTix4w@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 15, 2022 at 05:49:57PM +0000, Russell King (Oracle) wrote:
> Hi,
> 
> On Thu, Dec 15, 2022 at 12:54:37AM +0100, Christian Marangi wrote:
> > +static int
> > +qca8k_cled_hw_control_configure(struct led_classdev *ldev, unsigned long rules,
> > +				enum blink_mode_cmd cmd)
> > +{
> > +	struct qca8k_led *led = container_of(ldev, struct qca8k_led, cdev);
> > +	struct led_trigger *trigger = ldev->trigger;
> > +	struct qca8k_led_pattern_en reg_info;
> > +	struct qca8k_priv *priv = led->priv;
> > +	u32 offload_trigger = 0, mask, val;
> > +	int ret;
> > +
> > +	/* Check trigger compatibility */
> > +	if (strcmp(trigger->name, "netdev"))
> > +		return -EOPNOTSUPP;
> > +
> > +	if (!strcmp(trigger->name, "netdev"))
> > +		ret = qca8k_parse_netdev(rules, &offload_trigger, &mask);
> 
> I'm not sure how well the compiler will spot that, but as far as
> readability goes, that second if() statement appears to be redundant.
>

Leftover when the driver supported 2 trigger. The idea was to provide a
"template" to show the flow of the function.

> > +
> > +	if (ret)
> > +		return ret;
> > +
> > +	qca8k_get_control_led_reg(led->port_num, led->led_num, &reg_info);
> > +
> > +	switch (cmd) {
> > +	case BLINK_MODE_SUPPORTED:
> > +		/* We reach this point, we are sure the trigger is supported */
> > +		return 1;
> > +	case BLINK_MODE_ZERO:
> > +		/* We set 4hz by default */
> > +		u32 default_reg = QCA8K_LED_BLINK_4HZ;
> > +
> > +		ret = regmap_update_bits(priv->regmap, reg_info.reg,
> > +					 QCA8K_LED_RULE_MASK << reg_info.shift,
> > +					 default_reg << reg_info.shift);
> > +		break;
> > +	case BLINK_MODE_ENABLE:
> > +		ret = regmap_update_bits(priv->regmap, reg_info.reg,
> > +					 mask << reg_info.shift,
> > +					 offload_trigger << reg_info.shift);
> > +		break;
> > +	case BLINK_MODE_DISABLE:
> > +		ret = regmap_update_bits(priv->regmap, reg_info.reg,
> > +					 mask << reg_info.shift,
> > +					 0);
> > +		break;
> 
> I think it needs to be made more clear in the documentation that if
> this is called with ENABLE, then _only_ those modes in flags... (or
> is it now called "rules"?) are to be enabled and all other modes
> should be disabled. Conversely, DISABLE is used to disable all
> modes. However, if that's the case, then ZERO was misdescribed, and
> should probably be called DEFAULT. At least that's the impression
> that I get from the above code.
> 

ZERO disable all the rules. Driver can keep some rule enabled (this is
the case for qca8k blink mode at 4hz by default)

ENABLE/DISABLE only act on the provided thing in rules. In the current
imlementation parse rules, generate a mask and update the values
accordingly. Other rules are not touched. This is based on the fact that
the first and the last thing done is calling ZERO to reset all the rules
to a known state.

I will try to improve the Documentation on this aspect.
Hope you know understand better the calling flow.

> > +	case BLINK_MODE_READ:
> > +		ret = regmap_read(priv->regmap, reg_info.reg, &val);
> > +		if (ret)
> > +			return ret;
> > +
> > +		val >>= reg_info.shift;
> > +		val &= offload_trigger;
> > +
> > +		/* Special handling for LED_BLINK_2HZ */
> > +		if (!val && offload_trigger == QCA8K_LED_BLINK_2HZ)
> > +			val = 1;
> 
> Hmm, so if a number of different modes is in flags or rules, then
> as long as one matches, this returns 1? So it's an "any of these
> modes is enabled" test.
> 

Ok this should be changed and you are right. READ should return true or
false if the rule (or rules) are enabled. This work for a single rule
but doesn't if multiple rules are provided.

Will fix that since this is wrong.

> > +
> > +		return val;
> > +	default:
> > +		return -EOPNOTSUPP;
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +static void
> > +qca8k_led_brightness_set(struct qca8k_led *led,
> > +			 enum led_brightness b)
> > +{
> > +	struct qca8k_led_pattern_en reg_info;
> > +	struct qca8k_priv *priv = led->priv;
> > +	u32 val = QCA8K_LED_ALWAYS_OFF;
> > +
> > +	qca8k_get_enable_led_reg(led->port_num, led->led_num, &reg_info);
> > +
> > +	if (b)
> > +		val = QCA8K_LED_ALWAYS_ON;
> > +
> > +	regmap_update_bits(priv->regmap, reg_info.reg,
> > +			   GENMASK(1, 0) << reg_info.shift,
> > +			   val << reg_info.shift);
> > +}
> > +
> > +static void
> > +qca8k_cled_brightness_set(struct led_classdev *ldev,
> > +			  enum led_brightness b)
> > +{
> > +	struct qca8k_led *led = container_of(ldev, struct qca8k_led, cdev);
> > +
> > +	return qca8k_led_brightness_set(led, b);
> > +}
> > +
> > +static enum led_brightness
> > +qca8k_led_brightness_get(struct qca8k_led *led)
> > +{
> > +	struct qca8k_led_pattern_en reg_info;
> > +	struct qca8k_priv *priv = led->priv;
> > +	u32 val;
> > +	int ret;
> > +
> > +	qca8k_get_enable_led_reg(led->port_num, led->led_num, &reg_info);
> > +
> > +	ret = regmap_read(priv->regmap, reg_info.reg, &val);
> > +	if (ret)
> > +		return 0;
> > +
> > +	val >>= reg_info.shift;
> > +	val &= GENMASK(1, 0);
> > +
> > +	return val > 0 ? 1 : 0;
> > +}
> > +
> > +static enum led_brightness
> > +qca8k_cled_brightness_get(struct led_classdev *ldev)
> > +{
> > +	struct qca8k_led *led = container_of(ldev, struct qca8k_led, cdev);
> > +
> > +	return qca8k_led_brightness_get(led);
> > +}
> > +
> > +static int
> > +qca8k_cled_blink_set(struct led_classdev *ldev,
> > +		     unsigned long *delay_on,
> > +		     unsigned long *delay_off)
> > +{
> > +	struct qca8k_led *led = container_of(ldev, struct qca8k_led, cdev);
> > +	struct qca8k_led_pattern_en reg_info;
> > +	struct qca8k_priv *priv = led->priv;
> > +
> > +	if (*delay_on == 0 && *delay_off == 0) {
> > +		*delay_on = 125;
> > +		*delay_off = 125;
> > +	}
> > +
> > +	if (*delay_on != 125 || *delay_off != 125) {
> > +		/* The hardware only supports blinking at 4Hz. Fall back
> > +		 * to software implementation in other cases.
> > +		 */
> > +		return -EINVAL;
> > +	}
> > +
> > +	qca8k_get_enable_led_reg(led->port_num, led->led_num, &reg_info);
> > +
> > +	regmap_update_bits(priv->regmap, reg_info.reg,
> > +			   GENMASK(1, 0) << reg_info.shift,
> > +			   QCA8K_LED_ALWAYS_BLINK_4HZ << reg_info.shift);
> > +
> > +	return 0;
> > +}
> > +
> > +static int
> > +qca8k_cled_trigger_offload(struct led_classdev *ldev, bool enable)
> > +{
> > +	struct qca8k_led *led = container_of(ldev, struct qca8k_led, cdev);
> > +
> > +	struct qca8k_led_pattern_en reg_info;
> > +	struct qca8k_priv *priv = led->priv;
> > +	u32 val = QCA8K_LED_ALWAYS_OFF;
> > +
> > +	qca8k_get_enable_led_reg(led->port_num, led->led_num, &reg_info);
> > +
> > +	if (enable)
> > +		val = QCA8K_LED_RULE_CONTROLLED;
> > +
> > +	return regmap_update_bits(priv->regmap, reg_info.reg,
> > +				  GENMASK(1, 0) << reg_info.shift,
> > +				  val << reg_info.shift);
> 
> 88e151x doesn't have the ability to change in this way - we have
> a register with a 4-bit field which selects the LED mode from one
> of many, or forces the LED on/off/hi-z/blink.
> 
> Not specifically for this patch, but talking generally about this
> approach, the other issue I forsee with this is that yes, 88e151x has
> three LEDs, but the LED modes are also used to implement control
> signals (e.g., on a SFP, LOS can be implemented by programming mode
> 0 on LED2 (which makes it indicate link or not.) If we expose all the
> LEDs we run the risk of the LED subsystem trampling over that
> configuration and essentially messing up such modules. So the Marvell
> PHY driver would need to know when it is appropriate to expose these
> things to the LED subsystem.
> 
> I guess doing it dependent on firmware description as you do in
> this driver would work - if there's no firmware description, they're
> not exposed.
> 

The idea is to provide a way to tell the driver what should be done and
tell the trigger that something is not doable and to revert to sw mode.

keeping the thing as simple and direct as possible and leave the rest to
the driver by doing minimal validation on the trigger side.

Do you have suggestion on how this can be improved even more and be more
flexible? 

-- 
	Ansuel
