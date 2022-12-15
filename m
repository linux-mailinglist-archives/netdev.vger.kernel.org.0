Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4604B64DE4C
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 17:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbiLOQN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 11:13:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiLOQNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 11:13:23 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ADC131EE4;
        Thu, 15 Dec 2022 08:13:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=pQq23aBLz2m2Qb/o0dxmFq0n0pj+yPa65DscBOK8wdk=; b=ph8Zhq1SIqIA9pbenDsYgg/e2H
        KleIJOozdYhH1f/ZplayPuwLMlUiLf6z3/WUgtW1YO4UFanERFzVrGKkU+Zt92bejno3Zpiju+npB
        a1SGBHcNnhkR/EhXe//Rjf7sqJ15yWhH6EjN/Xypu400PHhv/5iu25gJRjjV+A5dtn+KV+TjFvTYW
        BFAOVOacBZYSC30bU8TQ7ZLbKjb54dQfOOFu7R7aU2ku8lrlBz9yKXD7hw8JKXXSC73SuPPrLk70O
        FnmSpWcKYKxFLxVUwF4PFSxjj4dFIcp1jl5QhCxD9sYBS7q7DmehdqtFVE7uYbChwsHivjAvj43Zq
        Q1oQVTfQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35720)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p5qr6-0003Hw-BH; Thu, 15 Dec 2022 16:13:08 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p5qr1-0008U9-BS; Thu, 15 Dec 2022 16:13:03 +0000
Date:   Thu, 15 Dec 2022 16:13:03 +0000
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
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [PATCH v7 01/11] leds: add support for hardware driven LEDs
Message-ID: <Y5tHjwx1Boj3xMok@shell.armlinux.org.uk>
References: <20221214235438.30271-1-ansuelsmth@gmail.com>
 <20221214235438.30271-2-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221214235438.30271-2-ansuelsmth@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christian,

Thanks for the patch.

I think Andrew's email is offline at the moment.

On Thu, Dec 15, 2022 at 12:54:28AM +0100, Christian Marangi wrote:
> +static bool led_trigger_is_supported(struct led_classdev *led_cdev,
> +				     struct led_trigger *trigger)
> +{
> +	switch (led_cdev->blink_mode) {
> +	case SOFTWARE_CONTROLLED:
> +		if (trigger->supported_blink_modes == HARDWARE_ONLY)
> +			return 0;
> +		break;
> +	case HARDWARE_CONTROLLED:
> +		if (trigger->supported_blink_modes == SOFTWARE_ONLY)
> +			return 0;
> +		break;
> +	case SOFTWARE_HARDWARE_CONTROLLED:
> +		break;
> +	default:
> +		return 0;
> +	}
> +
> +	return 1;

Should be returning true/false. I'm not sure I'm a fan of the style of
this though - wouldn't the following be easier to read?

	switch (led_cdev->blink_mode) {
	case SOFTWARE_CONTROLLED:
		return trigger->supported_blink_modes != HARDWARE_ONLY;

	case HARDWARE_CONTROLLED:
		return trigger->supported_blink_modes != SOFTWARE_ONLY;

	case SOFTWARE_HARDWARE_CONTROLLED:
		return true;
	}
?

Also, does it really need a default case - without it, when the
led_blink_modes enum is expanded and the switch statement isn't
updated, we'll get a compiler warning which will prompt this to be
updated - whereas, with a default case, it won't.

> @@ -188,6 +213,10 @@ int led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trig)
>  		led_set_brightness(led_cdev, LED_OFF);
>  	}
>  	if (trig) {
> +		/* Make sure the trigger support the LED blink mode */
> +		if (!led_trigger_is_supported(led_cdev, trig))
> +			return -EINVAL;

Shouldn't validation happen before we start taking any actions? In other
words, before we remove the previous trigger?

> @@ -350,12 +381,26 @@ static inline bool led_sysfs_is_disabled(struct led_classdev *led_cdev)
>  
>  #define TRIG_NAME_MAX 50
>  
> +enum led_trigger_blink_supported_modes {
> +	SOFTWARE_ONLY = SOFTWARE_CONTROLLED,
> +	HARDWARE_ONLY = HARDWARE_CONTROLLED,
> +	SOFTWARE_HARDWARE = SOFTWARE_HARDWARE_CONTROLLED,

I suspect all these generic names are asking for eventual namespace
clashes. Maybe prefix them with LED_ ?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
