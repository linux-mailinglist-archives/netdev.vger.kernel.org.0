Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA48644AF65
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 15:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238024AbhKIOZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 09:25:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235273AbhKIOZn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 09:25:43 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E123CC061764;
        Tue,  9 Nov 2021 06:22:56 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id m14so76789169edd.0;
        Tue, 09 Nov 2021 06:22:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ZynCij5ndYEPj8PxM3zaKtR44Kq3dPb/JqQsNpSyMrg=;
        b=DECHzhgNAGI1/jrZye1cPPrCjyO95e9nyYNvxPATWIkEI6QPCfN70jf/jm2Mt4gaRM
         g2crgSiXereco+Lvt6qplnWJyRknLZZ5DQG06NSa3H1/iumTEnxEB2zQzL6zEVIiYShp
         SfRqgYWGsfwSF+6b1/0VtEQyLUxpNjdLDoPI44Qzk51aogRxehA7Ixyag5jSSVI1N/Ny
         x6FMIn4BnQFX7dk3CxiXo73kse5TkxO0qg7KeMWhFmodBrmDVcag5t/fx1NohWIg+ZkA
         P3bFWmw8Orcu3tM4jyr4F5B+vMRgPgnLZfw3U4/rLdfqWj9KkLk3jDUCkGwL2D+oWgYr
         ZWMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ZynCij5ndYEPj8PxM3zaKtR44Kq3dPb/JqQsNpSyMrg=;
        b=yqe8GVDmixs0PC/r+JW7OdB5K7hVNNcXUgRzTW8RgqDyerbzXLxa7ajWqiESSbx/JL
         2MmjbDWCX+rjsabDZBC2VOd9m+Z6I4JC5CETKTRIAKzvLIMzSBCHIt2wlv5MM3MfhXMO
         ELvvrR4oIkNgwDYlO5KCie4cPuwhJ0/sqVv1K8/PXo3CrQr1lDoFI3wt2ZFJnvQGA7Rv
         MXTG9VRnOhXL5I1GR95bHIPAp5iJaPGvFsKcH7O0kqmSlqtCiroFbq0Q8YCODib9zcEd
         buKLSyqEaKiLQMkTgWiIN/L1lsKSQJJoJvj9CfvlxjvF9IAlD0kN79fY6LdNKTLN4h5i
         j9eQ==
X-Gm-Message-State: AOAM533dzH6kwLBdm+ek5J0IUyKhoQxFfUUH0E8z38jwrnXo8PyPnBns
        BAkahxKDoTfEwfvZzCow2FM=
X-Google-Smtp-Source: ABdhPJwy6tsZzGp6udhzBkqCyd4JeRAYWhpPDgxPjQfds0NAE8Q+nYVYdDqQydQ7Nyz2fe31SpiNNQ==
X-Received: by 2002:a17:907:3e0a:: with SMTP id hp10mr10360720ejc.318.1636467775304;
        Tue, 09 Nov 2021 06:22:55 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id cw5sm3412877ejc.74.2021.11.09.06.22.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 06:22:54 -0800 (PST)
Date:   Tue, 9 Nov 2021 15:22:53 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [RFC PATCH v3 2/8] leds: add function to configure hardware
 controlled LED
Message-ID: <YYqEPZpGmjNgFj0L@Ansuel-xps.localdomain>
References: <20211109022608.11109-1-ansuelsmth@gmail.com>
 <20211109022608.11109-3-ansuelsmth@gmail.com>
 <20211109040103.7b56bf82@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211109040103.7b56bf82@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 09, 2021 at 04:01:03AM +0100, Marek Behún wrote:
> Hello Ansuel,
> 
> On Tue,  9 Nov 2021 03:26:02 +0100
> Ansuel Smith <ansuelsmth@gmail.com> wrote:
> 
> > Add hw_control_configure helper to configure how the LED should work in
> > hardware mode. The function require to support the particular trigger and
> > will use the passed flag to elaborate the data and apply the
> > correct configuration. This function will then be used by the trigger to
> > request and update hardware configuration.
> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> >  Documentation/leds/leds-class.rst | 25 ++++++++++++++++++++
> >  include/linux/leds.h              | 39 +++++++++++++++++++++++++++++++
> >  2 files changed, 64 insertions(+)
> > 
> > diff --git a/Documentation/leds/leds-class.rst b/Documentation/leds/leds-class.rst
> > index 645940b78d81..efd2f68c46a7 100644
> > --- a/Documentation/leds/leds-class.rst
> > +++ b/Documentation/leds/leds-class.rst
> > @@ -198,6 +198,31 @@ With HARDWARE_CONTROLLED blink_mode hw_control_status/start/stop is optional
> >  and any software only trigger will reject activation as the LED supports only
> >  hardware mode.
> >  
> > +A trigger once he declared support for hardware controlled blinks, will use the function
> > +hw_control_configure() provided by the driver to check support for a particular blink mode.
> > +This function passes as the first argument (flag) a u32 flag.
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
> > index cf0c6005c297..00bc4d6ed7ca 100644
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
> this is a strange proposal for the API.
> 
> Anyway, led_classdev already has the blink_set() method, which is documented as
> 	/*
> 	  * Activate hardware accelerated blink, delays are in milliseconds
> 	  * and if both are zero then a sensible default should be chosen.
> 	  * The call should adjust the timings in that case and if it can't
> 	  * match the values specified exactly.
> 	  * Deactivate blinking again when the brightness is set to LED_OFF
> 	  * via the brightness_set() callback.
> 	  */
> 	int		(*blink_set)(struct led_classdev *led_cdev,
> 				     unsigned long *delay_on,
> 				     unsigned long *delay_off);
> 
> So we already have a method to set hardware blkinking, we don't need
> another one.
> 
> Marek

But that is about hardware blink, not a LED controlled by hardware based
on some rules/modes.
Doesn't really match the use for the hardware control.
Blink_set makes the LED blink contantly at the declared delay.
The blink_mode_cmd are used to request stuff to a LED in hardware mode.

Doesn't seem correct to change/enhance the blink_set function with
something that would do something completely different.

-- 
	Ansuel
