Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D21B551C025
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 15:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378584AbiEENGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 09:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378576AbiEENGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 09:06:32 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480665641A;
        Thu,  5 May 2022 06:02:52 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id ks9so2179729ejb.2;
        Thu, 05 May 2022 06:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=AbFnwpgbpRqbSZXuVlLTWLWaP6lQK++HkXyqf22kqsQ=;
        b=LmI1XLcYPUsd6b+Kf1EiUy3LasIdduWmdPZsMy5a+aNYJFkKZKAGn8ev15wqVdJzMg
         A9l1AqnuEtByWvUWqveJHmhee2iZNRTvyTf2Eg4k+WfOslOaD6KjMt94dFTg7OgXSUXp
         vsZo1EbipW0YAZ1c8OhGWrjW28aFQLnE+fPky3K+ok/3lkX/87Lpk0KK4uo6y0Jc8/QE
         GBZbkTOqWMpGkU4vVBEVk1qaNla56a8Nb8sHbS67sESlnKQoLuXTzaqAUMsphKAEcYHx
         OABWNGsjjEtThSAORuYBQ1IG4SMSXSccfvSHT9o9IIz9yULWqad9FABKCEJVTOFVKVgj
         K+KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=AbFnwpgbpRqbSZXuVlLTWLWaP6lQK++HkXyqf22kqsQ=;
        b=JcidLT3jJhmUxix7kBvnz9qjD+RSQB44N4VrTp0mF9R6c6uh7J8vmbYByM6apAIqgc
         /4rOgsYfeGec4P0TsFC5LVXMyTftxlMwvo0F1wyRgA+CI0JzRH8P0tMmYQljSmKflVRC
         CMDgvXoieXupqxm2LWEpy8BT/AWU6+mjCQTZccl/+7XZJ10mcA8uJQBFTS2KlnDeJ35h
         tCsgVSB/eH1T26Dn1doUnEiuVTx5Xq6vhlj3fx/z9GGq7orh0kaQg+UygVG/QAgEL8hq
         7REWyjijzbejX9ANlNnFE+6u8wUdTKD+HR7gXdIIecE/T1zqW/jvOelBv6JOHPbAFtQ4
         h/Qg==
X-Gm-Message-State: AOAM532jUh7kTbR+Qtr6ce/ezf89Bi7lr7j9Uz4QtgDlGT/p7stmF2gN
        dNNh9yf9u/oQnIbItSHlO+k=
X-Google-Smtp-Source: ABdhPJy4f71FWGOEthcUoo+qt2qVPI/iwGck2Qsia+jbgGFUA1PIJ0Xs5OMzphpi0xlu04famAgM8g==
X-Received: by 2002:a17:907:6e08:b0:6f4:a749:f483 with SMTP id sd8-20020a1709076e0800b006f4a749f483mr11187093ejc.225.1651755770706;
        Thu, 05 May 2022 06:02:50 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.gmail.com with ESMTPSA id p9-20020a170906140900b006f3ef214dcdsm725686ejc.51.2022.05.05.06.02.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 06:02:50 -0700 (PDT)
Message-ID: <6273cafa.1c69fb81.d4b56.3ff5@mx.google.com>
X-Google-Original-Message-ID: <YnPK+IKQ4l6dCf2k@Ansuel-xps.>
Date:   Thu, 5 May 2022 15:02:48 +0200
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
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [RFC PATCH v6 02/11] leds: add function to configure hardware
 controlled LED
References: <20220503151633.18760-1-ansuelsmth@gmail.com>
 <20220503151633.18760-3-ansuelsmth@gmail.com>
 <YnMK+EZDQXSGDXM1@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnMK+EZDQXSGDXM1@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 05, 2022 at 01:23:36AM +0200, Andrew Lunn wrote:
> > +In SUPPORTED hw_control_configure() should return 0 or 1 if the LED driver supports the
> > +requested blink mode (flags) or not.
> 
> -EOPNOTSUPP might be clearer.
> 
> 
> > +In ZERO hw_control_configure() should return 0 with success operation or error.
> > +
> > +The unsigned long flag is specific to the trigger and change across them. It's in the LED
> > +driver interest know how to elaborate this flag and to declare support for a
> > +particular trigger. For this exact reason explicit support for the specific
> > +trigger is mandatory or the driver returns -EOPNOTSUPP if asked to enter offload mode
> > +with a not supported trigger.
> > +If the driver returns -EOPNOTSUPP on hw_control_configure(), the trigger activation will
> > +fail as the driver doesn't support that specific offload trigger or doesn't know
> > +how to handle the provided flags.
> > +
> >  Known Issues
> >  ============
> >  
> > diff --git a/include/linux/leds.h b/include/linux/leds.h
> > index 09ff1dc6f48d..b5aad67fecfb 100644
> > --- a/include/linux/leds.h
> > +++ b/include/linux/leds.h
> > @@ -73,6 +73,16 @@ enum led_blink_modes {
> >  	SOFTWARE_HARDWARE_CONTROLLED,
> >  };
> >  
> > +#ifdef CONFIG_LEDS_HARDWARE_CONTROL
> > +enum blink_mode_cmd {
> > +	BLINK_MODE_ENABLE, /* Enable the hardware blink mode */
> > +	BLINK_MODE_DISABLE, /* Disable the hardware blink mode */
> > +	BLINK_MODE_READ, /* Read the status of the hardware blink mode */
> > +	BLINK_MODE_SUPPORTED, /* Ask the driver if the hardware blink mode is supported */
> > +	BLINK_MODE_ZERO, /* Disable any hardware blink active */
> > +};
> > +#endif
> 
> Skip the #ifdef. The enum itself takes no space if never used, and it
> makes the driver simpler if they always exist.
> 
> > +
> >  struct led_classdev {
> >  	const char		*name;
> >  	unsigned int brightness;
> > @@ -185,6 +195,17 @@ struct led_classdev {
> >  	 * the old status but that is not mandatory and also putting it off is accepted.
> >  	 */
> >  	int			(*hw_control_stop)(struct led_classdev *led_cdev);
> > +	/* This will be used to configure the various blink modes LED support in hardware
> > +	 * mode.
> > +	 * The LED driver require to support the active trigger and will elaborate the
> > +	 * unsigned long flag and do the operation based on the provided cmd.
> > +	 * Current operation are enable,disable,supported and status.
> > +	 * A trigger will use this to enable or disable the asked blink mode, check the
> > +	 * status of the blink mode or ask if the blink mode can run in hardware mode.
> > +	 */
> > +	int			(*hw_control_configure)(struct led_classdev *led_cdev,
> > +							unsigned long flag,
> > +							enum blink_mode_cmd cmd);
> >  #endif
> >  #endif
> >  
> > @@ -454,6 +475,24 @@ static inline void *led_get_trigger_data(struct led_classdev *led_cdev)
> >  	return led_cdev->trigger_data;
> >  }
> >  
> > +#ifdef CONFIG_LEDS_HARDWARE_CONTROL
> > +static inline bool led_trigger_blink_mode_is_supported(struct led_classdev *led_cdev,
> > +						       unsigned long flag)
> > +{
> > +	int ret;
> > +
> > +	/* Sanity check: make sure led support hw mode */
> > +	if (led_cdev->blink_mode == SOFTWARE_CONTROLLED)
> > +		return false;
> > +
> > +	ret = led_cdev->hw_control_configure(led_cdev, flag, BLINK_MODE_SUPPORTED);
> > +	if (ret > 0)
> > +		return true;
> > +
> > +	return false;
> > +}
> > +#endif
> 
> Please add a version which returns false when
> CONFIG_LEDS_HARDWARE_CONTROL is disabled.
> 
> Does this actually need to be an inline function?

Not at all... Originally it was a smaller function. Will drop it.

>
>      Andrew

-- 
	Ansuel
