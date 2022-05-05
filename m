Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05B0F51C01E
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 15:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378490AbiEENF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 09:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378881AbiEENFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 09:05:17 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A4D5677D;
        Thu,  5 May 2022 06:01:23 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id n10so8587273ejk.5;
        Thu, 05 May 2022 06:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=+8Bn3kW6e0wg38EIvqrVCzIx965fXouRqL0MFSFcWLA=;
        b=J4uXpxzAF4fntLkmDVkXZMfd8yirdLuHYgKoHT0AaACWwDZrZ2htX8OXoxuig9GktV
         o8mW+TShx4kz2GkxSxexXi/KoWIPXCcUfC6KliLUj+n7x0QN5ZGexFxdaPnZ3w+Fb21l
         OO/u/VgF7caDVsdwDFMtao+6FA/f1jAr2asgHOVav2XDkroTYoRH+KQw1FuPect69Dui
         Was1/ggd389uk9xyaecMRk+z01QglbTngQ60pHuBXldwlWidSf+OFVsXdrmOq22dNfNG
         a+bUCfhFdyDO3Qh8n2waf4Rb4soLDhmFKSA6N4D7b/9MnpIFiddnmZkvR/fqSvsmO1Sm
         5o9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=+8Bn3kW6e0wg38EIvqrVCzIx965fXouRqL0MFSFcWLA=;
        b=5bhoOcsoTg/5cGXxGfr1eHPlYS/7sIOv+AET3mSW7I5fsimP9T1lVAA1nwe/aPgbe3
         dYug+n2BaMLk5D6gFqU8UnEGwHCftf4EdufY4f+ldkDBpNUVb6yPuWiMAVE0p6ozMEHj
         qN7irjUOiYJ73dfhz2/sQXIk+XgyUUiJox6YVDEYte8TyT0MnsTgObN96PEvUhgITDlt
         p7GWGMn7B1rkPmkQXo/LnzieS1VTT2l80gEAz1cBo5HK2a9cuBQCjjmhAbcaXB2VGyZz
         PY7lunl/kxapGdr82GRx3C2CT0UVTcoZxk2jclMmt1dwxntMnj3tEF4Q3TQc3vlhUx9h
         EPdA==
X-Gm-Message-State: AOAM533seXohz7Iz+tSffdiaeFdCC5vbIphUIEISSTwNEWOfgaJJdoya
        g0lvqqAcuw1nOP6ukwyuJ6Q=
X-Google-Smtp-Source: ABdhPJxF2OAZFYPrnxQxOo+ZEdFEnihNvhGqXp1BtBiI6HAAqPIH3LA2mibKtUkDnyPhffVR3ZOaNQ==
X-Received: by 2002:a17:907:97ce:b0:6f3:91d6:a8a1 with SMTP id js14-20020a17090797ce00b006f391d6a8a1mr7774669ejc.393.1651755681319;
        Thu, 05 May 2022 06:01:21 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.gmail.com with ESMTPSA id qp24-20020a170907a21800b006f3ef214e4bsm713586ejc.177.2022.05.05.06.01.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 06:01:20 -0700 (PDT)
Message-ID: <6273caa0.1c69fb81.b164f.3f11@mx.google.com>
X-Google-Original-Message-ID: <YnPKnpiyj5Wcj5i9@Ansuel-xps.>
Date:   Thu, 5 May 2022 15:01:18 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [RFC PATCH v6 01/11] leds: add support for hardware driven LEDs
References: <20220503151633.18760-1-ansuelsmth@gmail.com>
 <20220503151633.18760-2-ansuelsmth@gmail.com>
 <YnL73yOfh+wHQObm@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnL73yOfh+wHQObm@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 05, 2022 at 12:19:11AM +0200, Andrew Lunn wrote:
> > diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
> > index 6a8ea94834fa..3516ae3c4c3c 100644
> > --- a/drivers/leds/led-class.c
> > +++ b/drivers/leds/led-class.c
> > @@ -164,6 +164,27 @@ static void led_remove_brightness_hw_changed(struct led_classdev *led_cdev)
> >  }
> >  #endif
> >  
> > +#ifdef CONFIG_LEDS_HARDWARE_CONTROL
> > +static int led_classdev_check_blink_mode_functions(struct led_classdev *led_cdev)
> > +{
> > +	int mode = led_cdev->blink_mode;
> > +
> 
> We try to avoid #ifdef in code. I suggest you use
> 
>    if (IS_ENABLED(CONFIG_LEDS_HARDWARE_CONTROL)) {
>    }
> 
> You then get compiler coverage independent of if the option is on or
> off.
> 
> > +	if (mode == SOFTWARE_HARDWARE_CONTROLLED &&
> > +	    (!led_cdev->hw_control_status ||
> > +	    !led_cdev->hw_control_start ||
> > +	    !led_cdev->hw_control_stop))
> > +		return -EINVAL;
> > +
> > +	if (mode == SOFTWARE_CONTROLLED &&
> > +	    (led_cdev->hw_control_status ||
> > +	    led_cdev->hw_control_start ||
> > +	    led_cdev->hw_control_stop))
> > +		return -EINVAL;
> > +
> > +	return 0;
> > +}
> > +#endif
> > +
> >  /**
> >   * led_classdev_suspend - suspend an led_classdev.
> >   * @led_cdev: the led_classdev to suspend.
> > @@ -367,6 +388,12 @@ int led_classdev_register_ext(struct device *parent,
> >  	if (ret < 0)
> >  		return ret;
> >  
> > +#ifdef CONFIG_LEDS_HARDWARE_CONTROL
> > +	ret = led_classdev_check_blink_mode_functions(led_cdev);
> > +	if (ret < 0)
> > +		return ret;
> > +#endif
> 
> You can then drop this #ifdef, since it will return 0 by default when
> disabled, and the compiler should optimize it all out.
> 
> > @@ -154,6 +160,32 @@ struct led_classdev {
> >  
> >  	/* LEDs that have private triggers have this set */
> >  	struct led_hw_trigger_type	*trigger_type;
> > +
> > +	/* This report the supported blink_mode. The driver should report the
> > +	 * correct LED capabilities.
> > +	 * With this set to HARDWARE_CONTROLLED, LED is always in offload mode
> > +	 * and triggers can't be simulated by software.
> > +	 * If the led is HARDWARE_CONTROLLED, status/start/stop function
> > +	 * are optional.
> > +	 * By default SOFTWARE_CONTROLLED is set as blink_mode.
> > +	 */
> > +	enum led_blink_modes	blink_mode;
> > +#ifdef CONFIG_LEDS_HARDWARE_CONTROL
> > +	/* Ask the LED driver if hardware mode is enabled or not.
> > +	 * If the option is not declared by the LED driver, SOFTWARE_CONTROLLED
> > +	 * is assumed.
> > +	 * Triggers will check if the hardware mode is supported and will be
> > +	 * activated accordingly. If the trigger can't run in hardware mode,
> > +	 * return -EOPNOTSUPP as the blinking can't be simulated by software.
> > +	 */
> > +	bool			(*hw_control_status)(struct led_classdev *led_cdev);
> > +	/* Set LED in hardware mode */
> > +	int			(*hw_control_start)(struct led_classdev *led_cdev);
> > +	/* Disable hardware mode for LED. It's advised to the LED driver to put it to
> > +	 * the old status but that is not mandatory and also putting it off is accepted.
> > +	 */
> > +	int			(*hw_control_stop)(struct led_classdev *led_cdev);
> > +#endif
> 
> I'm surprised this builds. It looked like you accessed these two
> members even when the option was disabled. I would keep them even when
> the option is disabled. Two pointers don't add much overhead, and it
> makes the drivers simpler.
> 

Yhea sorry about this... I proposed this as an RFC as it was old code
that I just refreshed and I'm really checking the implementation...
Will do the ifdef changes in the next version.

> >  #ifdef CONFIG_LEDS_BRIGHTNESS_HW_CHANGED
> > @@ -215,7 +247,6 @@ extern struct led_classdev *of_led_get(struct device_node *np, int index);
> >  extern void led_put(struct led_classdev *led_cdev);
> >  struct led_classdev *__must_check devm_of_led_get(struct device *dev,
> >  						  int index);
> > -
> 
> Unrelated white space change.
> 
> 	  Andrew

-- 
	Ansuel
