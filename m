Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB5D64EFA5
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 17:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbiLPQpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 11:45:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiLPQp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 11:45:27 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 866CDBB;
        Fri, 16 Dec 2022 08:45:26 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id v7so2329571wmn.0;
        Fri, 16 Dec 2022 08:45:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=eX9gDMrjb0dlm+fGeQpaJwpVRDJbiB+iKFD2Hgyaj8E=;
        b=bZMV8GuerKAJ+RvZ9hN4D5/EWQgjcT4qIXCuUmTPrf+HzWvkNr8mKi/TGANpUaFDqF
         8PGe5k8BUrif0ZryGwPOQrsJsq1nE5tLZ+Hrd3rWSnCFIOMBDLJdmj/ZrmDpn3q2GvxG
         4+ShLoets4QEEKR5hUDfg63v5rAofZaC0yH4HbnsKy6pJfEZBiRMQZ6Rvw0DhB06S5uq
         ObssY3c5tGyQPL3TAMpPBbNDRP9C4JA13wFw56/Qbkric78It98RCTAcQl0yic1utIHm
         bGDBivV/pnnMEFYzoKJP5xOFqIT5Yk69/qegrNeXfwg04Ozt1HqzIQpFGlkDxDNaljV9
         Rt7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eX9gDMrjb0dlm+fGeQpaJwpVRDJbiB+iKFD2Hgyaj8E=;
        b=g2j1Srp62u4FeyM21nmbDRofyxVMXJoPYQkliWUydNjTMu5KraGZnfJDYDzEH/M5x/
         9hUrBA0wzcLhTydq6LAm7Ag+2FArKbRWGunq7tAhu0diEiqPWOsksSyaAIu/2Px6iWgM
         etmJqBntqg4aHsMOsE4iyzeCLsFTu/SDiXrYVphIBaeBO1ro1v2npPRnmKY651S9TVC9
         oHTxlE/9GpE01DPhKxtgMm1hbNuIJOY73ju8DAXgdqLpVytJqZYMOg5qbAxKbnWS0yh+
         Qt+Byig/GVuwcOz0Nr0Ffn+AW1HX8LGlOPdSlbs3YUZDEVeBnOXcDfMVw3ZEbwJrMxkQ
         k+rQ==
X-Gm-Message-State: ANoB5plVyTg7/sTXUy79lT/MDzM3DIGPm/bBL7w+WMBMdazngld141qb
        BN1iLnZRVu2jSxfh0rHJtTY=
X-Google-Smtp-Source: AA0mqf7BCsGOdSCOzoOY4kmYeOoNyyvOd3kkyowbLNaIe2ZXJin3XxGqYFY4hDH/XNSRDTtIOZdJYA==
X-Received: by 2002:a05:600c:6015:b0:3cf:ea76:1823 with SMTP id az21-20020a05600c601500b003cfea761823mr25891458wmb.41.1671209124853;
        Fri, 16 Dec 2022 08:45:24 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-18.ip85.fastwebnet.it. [93.42.71.18])
        by smtp.gmail.com with ESMTPSA id i12-20020a05600c354c00b003cfd64b6be1sm13870055wmq.27.2022.12.16.08.45.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 08:45:24 -0800 (PST)
Message-ID: <639ca0a4.050a0220.99395.8fd3@mx.google.com>
X-Google-Original-Message-ID: <Y5ygpT/2JqHREJ7L@Ansuel-xps.>
Date:   Fri, 16 Dec 2022 17:45:25 +0100
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
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [PATCH v7 01/11] leds: add support for hardware driven LEDs
References: <20221214235438.30271-1-ansuelsmth@gmail.com>
 <20221214235438.30271-2-ansuelsmth@gmail.com>
 <Y5tHjwx1Boj3xMok@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5tHjwx1Boj3xMok@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 15, 2022 at 04:13:03PM +0000, Russell King (Oracle) wrote:
> Hi Christian,
> 
> Thanks for the patch.
> 
> I think Andrew's email is offline at the moment.
>

Notice by gmail spamming me "I CAN'T SEND IT AHHHHH"
Holidy times I guess?

> On Thu, Dec 15, 2022 at 12:54:28AM +0100, Christian Marangi wrote:
> > +static bool led_trigger_is_supported(struct led_classdev *led_cdev,
> > +				     struct led_trigger *trigger)
> > +{
> > +	switch (led_cdev->blink_mode) {
> > +	case SOFTWARE_CONTROLLED:
> > +		if (trigger->supported_blink_modes == HARDWARE_ONLY)
> > +			return 0;
> > +		break;
> > +	case HARDWARE_CONTROLLED:
> > +		if (trigger->supported_blink_modes == SOFTWARE_ONLY)
> > +			return 0;
> > +		break;
> > +	case SOFTWARE_HARDWARE_CONTROLLED:
> > +		break;
> > +	default:
> > +		return 0;
> > +	}
> > +
> > +	return 1;
> 
> Should be returning true/false. I'm not sure I'm a fan of the style of
> this though - wouldn't the following be easier to read?
> 
> 	switch (led_cdev->blink_mode) {
> 	case SOFTWARE_CONTROLLED:
> 		return trigger->supported_blink_modes != HARDWARE_ONLY;
> 
> 	case HARDWARE_CONTROLLED:
> 		return trigger->supported_blink_modes != SOFTWARE_ONLY;
> 
> 	case SOFTWARE_HARDWARE_CONTROLLED:
> 		return true;
> 	}
> ?

Much better!

> 
> Also, does it really need a default case - without it, when the
> led_blink_modes enum is expanded and the switch statement isn't
> updated, we'll get a compiler warning which will prompt this to be
> updated - whereas, with a default case, it won't.
> 

I added the default just to mute some compiler warning. But guess if
every enum is handled the warning should not be reported.

> > @@ -188,6 +213,10 @@ int led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trig)
> >  		led_set_brightness(led_cdev, LED_OFF);
> >  	}
> >  	if (trig) {
> > +		/* Make sure the trigger support the LED blink mode */
> > +		if (!led_trigger_is_supported(led_cdev, trig))
> > +			return -EINVAL;
> 
> Shouldn't validation happen before we start taking any actions? In other
> words, before we remove the previous trigger?
> 

trigger_set first remove any trigger and set the led off. Then apply the
new trigger. So the validation is done only when a trigger is actually
applied. Think we should understand the best case here.

> > @@ -350,12 +381,26 @@ static inline bool led_sysfs_is_disabled(struct led_classdev *led_cdev)
> >  
> >  #define TRIG_NAME_MAX 50
> >  
> > +enum led_trigger_blink_supported_modes {
> > +	SOFTWARE_ONLY = SOFTWARE_CONTROLLED,
> > +	HARDWARE_ONLY = HARDWARE_CONTROLLED,
> > +	SOFTWARE_HARDWARE = SOFTWARE_HARDWARE_CONTROLLED,
> 
> I suspect all these generic names are asking for eventual namespace
> clashes. Maybe prefix them with LED_ ?

Agree they are pretty generic so I can see why... My only concern was
making them too long... Maybe reduce them to SW or HW? LEDS_SW_ONLY...
LEDS_SW_CONTROLLED?

> 
> Thanks.
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

-- 
	Ansuel
