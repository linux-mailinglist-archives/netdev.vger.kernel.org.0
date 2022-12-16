Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31E5864EFE3
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 17:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbiLPQ6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 11:58:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231566AbiLPQ6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 11:58:05 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52DA455A95;
        Fri, 16 Dec 2022 08:58:01 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id m19so2297548wms.5;
        Fri, 16 Dec 2022 08:58:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=HEn5SyCtf5AYpp5F/wJFjKiMTWmWQwDsFpr363fO7CM=;
        b=gCwJP/1aMNQ1N0WnBwwVyLKU402QPSpruirgFxByN3ugQZdUrfQG/bqV4FJQ2QoKzy
         WX0ZM1A6fucbheX/9Y6KHr4LVwJ/t98irt2MQ7OmQ7LgUlI4Vrpxhuwz73a5zHtOSCXu
         DwhTKabSgNRFWKmPITb3BIKuvzvR28B1W5+/bxgP16AfFpky7GVfcD9Jzs8YfLUdWsok
         +NQ5RRyaqBKA04XEI+1GCfx7wnfkqmKN85RTIOFts3i0IAcGHEtFgWj+IEu8a3818zJS
         MZ/eljsW0DztmJstPuJSnoOuD2D2yZBX8mQn+H+6Odp7tQ+nrBMcSV8ScXkRcgpCcLMc
         2yWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HEn5SyCtf5AYpp5F/wJFjKiMTWmWQwDsFpr363fO7CM=;
        b=wRPz+zf2THPm8nGozYrs3qvMEnhKC+NnyxNfGTF+J2GZt8pxwOVXI1/abI3iQCbBT7
         JQ5FvBJWU3k8ucAg3kNws0qqY5pFwtOPfbBGqsqQn1kSXfbF68iS0zT0hjd1gKFmA9/L
         HTEWK/21gb7eSjvYgxnRoF3zHCM1EuGwmjA4nQFcx1Kq0GacCUUPbCILQKg7SCV0PPWv
         qeRxBqqsV9WWBXD+6GNvBiaXCFVJkCAMRuYLXLHgi7b0okN3g1CxUEXMbqOmJp1n6bzL
         HAT8yOcZQ+Uj3YMWnc3UQa5JqzyfcnmGBI2Nfkt7oss8bsnfdaYrU92Z39YCAWsr84OO
         W3tQ==
X-Gm-Message-State: ANoB5pm7FNy2oc56GctCuxYpQ/DpGS3QweVjFXXsCB0AimiUjMLHMgD8
        sLSxR7vmWlle5+79CLCxYVg=
X-Google-Smtp-Source: AA0mqf44DJ42/uwI/4pGD7q7CvI/kaHkchYIJ3GA23ub837lPAnNPlb6hz1WDUVJGq1piY2Vfhjngw==
X-Received: by 2002:a05:600c:4891:b0:3d1:fbf9:3bd4 with SMTP id j17-20020a05600c489100b003d1fbf93bd4mr25787753wmp.10.1671209879725;
        Fri, 16 Dec 2022 08:57:59 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-18.ip85.fastwebnet.it. [93.42.71.18])
        by smtp.gmail.com with ESMTPSA id y5-20020a056000108500b0023657e1b980sm2777405wrw.53.2022.12.16.08.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 08:57:59 -0800 (PST)
Message-ID: <639ca397.050a0220.77c8f.9870@mx.google.com>
X-Google-Original-Message-ID: <Y5yjmHPHkDKrpbPA@Ansuel-xps.>
Date:   Fri, 16 Dec 2022 17:58:00 +0100
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
Subject: Re: [PATCH v7 02/11] leds: add function to configure hardware
 controlled LED
References: <20221214235438.30271-1-ansuelsmth@gmail.com>
 <20221214235438.30271-3-ansuelsmth@gmail.com>
 <Y5tLuaqp9MHcW7rU@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5tLuaqp9MHcW7rU@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 15, 2022 at 04:30:49PM +0000, Russell King (Oracle) wrote:
> Hi Christian,
> 
> On Thu, Dec 15, 2022 at 12:54:29AM +0100, Christian Marangi wrote:
> > +A trigger once he declared support for hardware controlled blinks, will use the function
> > +hw_control_configure() provided by the driver to check support for a particular blink mode.
> 
> Please improve the above. I think what is actually meant is "Where a
> trigger has support for hardware controlled blink modes,
> hw_control_configure() will be used to check whether a particular blink
> mode is supported and configure the blink mode."
>

Ok I will improve!

> > +This function passes as the first argument (flag) a u32 flag.
> 
> I don't think "(flag)" is necessary, as I think "a u32 flag"
> sufficiently suggests that it's called "flag". In any case, it doesn't
> appear to be a "u32" but an "unsigned long".
> 

Will drop flag and fix the type.

> > +The second argument (cmd) of hw_control_configure() method can be used to do various
> > +operations for the specific blink mode. We currently support ENABLE, DISABLE, READ, ZERO
> > +and SUPPORTED to enable, disable, read the state of the blink mode, ask the LED
> > +driver if it does supports the specific blink mode and to reset any blink mode active.
> > +
> > +In ENABLE/DISABLE hw_control_configure() should configure the LED to enable/disable the
> > +requested blink mode (flag).
> > +In READ hw_control_configure() should return 0 or 1 based on the status of the requested
> > +blink mode (flag).
> > +In SUPPORTED hw_control_configure() should return 0 or 1 if the LED driver supports the
> > +requested blink mode (flags) or not.
> > +In ZERO hw_control_configure() should return 0 with success operation or error.
> 
> I think some kind of tabular description of this would be better.
> Something like this but on docbook format:
> 
> hw_control_configure()'s second argument, cmd, is used to specify
> various operations for the LED blink mode, and will be one of:
> 
> ENABLE - to enable the blink mode requested in flag. Returns ?
> DISABLE - to disable the blink mode requested in flag. Returbns ?
> READ - to indicate whether the blink mode requested in flag is enabled.
>        Returns 0 if disabled or 1 if enabled.
> SUPPORTED - to indicate whether the blink mode requested in flag is
>             supported. Returns 0 if unsupported or 1 if supported.
> ZERO - to disable all blink modes. Returns 0 or negative errno.
> 
> The problem with the way you've listed it is you've listed the
> operations in a different order to the description in the same sentence,
> so effectiely ZERO means to report whether supported and SUPPORTED means
> to reset all blink modes!
> 
> > +
> > +The unsigned long flag is specific to the trigger and change across them. It's in the LED
> > +driver interest know how to elaborate this flag and to declare support for a
> > +particular trigger.
> 
> Hmm, as a casual observer, this doesn't really give much information.
> Does this mean that it's up to the hardware LED driver to decide what
> each bit in the "flag" argument means? If not, I think this needs to
> be worded better!
> 

The idea behind this is that the leds driver needs to have some code to
parse the flag provided by the supported trigger...

Example:
- netdev trigger provide flag with BLINK_TX BLINK_RX
- driver needs to have explicit support for netdev trigger and will
  parse the passed flag to enable the function internally.

So no the driver needs to just reflect what it was requested by the
trigger. It's the trigger the one that define flags structure.

Ideally the driver will just include the trigger header and refer to the
same bits the trigger declare in the flag.

> > For this exact reason explicit support for the specific
> > +trigger is mandatory or the driver returns -EOPNOTSUPP if asked to enter offload mode
> > +with a not supported trigger.
> 
> Seems to be a change in terminology - weren't we using "HARDWARE" and
> "SOFTWARE" to describe the mode, rather than "offload" ?
> 

Will fix!

> > +If the driver returns -EOPNOTSUPP on hw_control_configure(), the trigger activation will
> > +fail as the driver doesn't support that specific offload trigger or doesn't know
> > +how to handle the provided flags.
> 
> This gets rather ambiguous. When can -EOPNOTSUPP be returned - for which
> cmds? Surely, if we have already tested for support using the SUPPORTED
> cmd which returns a 0/1 value, we should not be going on to trigger a
> request to enable something that isn't supported?
> 

Currently we report -EOPNOTSUPP when a trigger is not
supported. hw_control_start/stop/status is just related to activate the
hw_control but not configuring it. In old implementation it was
suggested to have this kind of split and separation to not overload the
configure function and have them split.

(configure enable/disable are about specific trigger rules not the hw
control mode)

I will try to refactor this to be more explicit.

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
> Generally not a good idea to make definitions in header files
> conditional on configuration symbols - it makes build-testing more
> problematical.

Guess I will have to add namespace tag and drop the ifdef.

> 
> Thanks.
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

-- 
	Ansuel
