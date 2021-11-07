Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC8044769A
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 23:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234291AbhKGXCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 18:02:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbhKGXCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 18:02:08 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5209C061570;
        Sun,  7 Nov 2021 14:59:24 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id g14so54643590edz.2;
        Sun, 07 Nov 2021 14:59:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=iCYpqVapJZ7YF8dwx95baPY+3/T5BeRg1fGve6upEeU=;
        b=ZZoGKQvKq/vjrBqSdn2H6lQZ2jSxbL3FN+sord7Npg7qsUTeLgCiHWwRIR5aPWU4l7
         x9oWMIDz4XJolq66gZGIAVYOPJs6M6I8lKxKl6CaWtJngCsODFY7BtdXgS5DzdzwQs1p
         +5tW/36wxs0O14WKK7olWtl69jVHi2QYbGYK2/hMmd9aLbcf5uPfMJCl0ePqD+2cF4gi
         FZ3YNz5LYLX2kG5jfjb0GSPaHy4uzB95RqMlXCvZajfG3mSJ1inS6xVP1v/o0levrqQU
         1aGC9IzQOqkBXtv3BPf/KNA9KqIXVnZoO8Tf6UobHm+QBK6QNaMsvCqaMszpSSDIhj/v
         iCWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=iCYpqVapJZ7YF8dwx95baPY+3/T5BeRg1fGve6upEeU=;
        b=6iLGoOQnMCrYyDk6HmBGMCzTRb6kLh6JSWFDyZaYuXjAxZJ3myV6i64dBL/Yd4zhs0
         MHSVmbVK3g9Ul927rzfxsepRnfQSqcD7Ro28oDoL9A41T2hE3HfroDZNiWRW/vW27eO8
         MizFvuQjD2/GkUWHLcsDL9Ux9ZmDBIB5lsTq0Q5IVYKS6fRx5WQQ9TTMFOSUoyhyj/oh
         c5w7WvdS/8Y+6OpIC60z5Vz4WZl/KrsLOEskRNuYJ8mgfCSfe4/mswazX5KV0VQnBs7S
         LF/e2p8754IGTch6nSIQXz8HX90GY5HAlKkXu9DOENEcSwRopsfyXbR+h2WIsd7Bfee+
         pm+g==
X-Gm-Message-State: AOAM530hkpUHuSFy9tMN3xEixy17lMQvwb0GMywu9GLOf4Zh9PtHWdE8
        JWJv017jWG+PUoWVo/HugNOtTatKvUc=
X-Google-Smtp-Source: ABdhPJz0QQ1VoyeOxWM1NwbddsNC5t/FZC3xjw35Evgh9wOycrsHVmXL52RCZRA+77+bvTIWOMastg==
X-Received: by 2002:a17:906:369a:: with SMTP id a26mr90414472ejc.539.1636325963367;
        Sun, 07 Nov 2021 14:59:23 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id sc7sm4470529ejc.50.2021.11.07.14.59.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Nov 2021 14:59:23 -0800 (PST)
Date:   Sun, 7 Nov 2021 23:59:16 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Randy Dunlap <rdunlap@infradead.org>
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
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [RFC PATCH 1/6] leds: trigger: add API for HW offloading of
 triggers
Message-ID: <YYhaRLakfFXTSetU@Ansuel-xps.localdomain>
References: <20211107175718.9151-1-ansuelsmth@gmail.com>
 <20211107175718.9151-2-ansuelsmth@gmail.com>
 <754414f1-d8f7-7100-0f2f-fad5430fbc86@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <754414f1-d8f7-7100-0f2f-fad5430fbc86@infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 07, 2021 at 02:52:12PM -0800, Randy Dunlap wrote:
> Hi,
> 
> On 11/7/21 9:57 AM, Ansuel Smith wrote:
> > From: Marek Behún <kabel@kernel.org>
> > 
> > Add method trigger_offload() and member variable `offloaded` to struct
> > led_classdev. Add helper functions led_trigger_offload() and
> > led_trigger_offload_stop().
> > 
> > The trigger_offload() method, when implemented by the LED driver, should
> > be called (via led_trigger_offload() function) from trigger code wanting
> > to be offloaded at the moment when configuration of the trigger changes.
> > 
> > If the trigger is successfully offloaded, this method returns 0 and the
> > trigger does not have to blink the LED in software.
> > 
> > If the trigger with given configuration cannot be offloaded, the method
> > should return -EOPNOTSUPP, in which case the trigger must blink the LED
> > in SW.
> > 
> > The second argument to trigger_offload() being false means that the
> > offloading is being disabled. In this case the function must return 0,
> > errors are not permitted.
> > 
> > An additional config CONFIG_LEDS_OFFLOAD_TRIGGERS is added to add support
> > for these special trigger offload driven.
> > 
> > Signed-off-by: Marek Behún <kabel@kernel.org>
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> >   Documentation/leds/leds-class.rst | 22 +++++++++++++++++++++
> >   drivers/leds/led-triggers.c       |  1 +
> >   drivers/leds/trigger/Kconfig      | 10 ++++++++++
> >   include/linux/leds.h              | 33 +++++++++++++++++++++++++++++++
> >   4 files changed, 66 insertions(+)
> > 
> > diff --git a/Documentation/leds/leds-class.rst b/Documentation/leds/leds-class.rst
> > index cd155ead8703..035a738afc4a 100644
> > --- a/Documentation/leds/leds-class.rst
> > +++ b/Documentation/leds/leds-class.rst
> > @@ -169,6 +169,28 @@ Setting the brightness to zero with brightness_set() callback function
> >   should completely turn off the LED and cancel the previously programmed
> >   hardware blinking function, if any.
> > +Hardware offloading of LED triggers
> > +===================================
> > +
> > +Some LEDs can offload SW triggers to hardware (for example a LED connected to
> 
> Better to s/SW/software/ and s/HW/hardware/ throughout the documentation file
> and Kconfig file(s).
> 
> > +an ethernet PHY or an ethernet switch can be configured to blink on activity on
> > +the network, which in software is done by the netdev trigger).
> > +
> > +To do such offloading, LED driver must support the this and a deficated offload
> 
>                                            drop:  the            dedicated
> 
> > +trigger must be used. The LED must implement the trigger_offload() method and
> 
> How does an LED implement the trigger_offload() method?
> They don't have very much logic in them AFAIK.
>

With trigger_offload here I meand activating that mode. So the function
will just do the required operation to set the LED in that specific
mode. Nothing else.

> > +the trigger code must try to call this method (via led_trigger_offload()
> > +function) when configuration of the trigger (trigger_data) changes.
> > +
> > +The implementation of the trigger_offload() method by the LED driver must return
> > +0 if the offload is successful and -EOPNOTSUPP if the requested trigger
> > +configuration is not supported and the trigger should be executed in software.
> > +If trigger_offload() returns negative value, the triggering will be done in
> > +software, so any active offloading must also be disabled.
> > +
> > +If the second argument (enable) to the trigger_offload() method is false, any
> > +active HW offloading must be deactivated. In this case errors are not permitted
> > +in the trigger_offload() method.
> 
> 
> > diff --git a/drivers/leds/trigger/Kconfig b/drivers/leds/trigger/Kconfig
> > index dc6816d36d06..c073e64e0a37 100644
> > --- a/drivers/leds/trigger/Kconfig
> > +++ b/drivers/leds/trigger/Kconfig
> > @@ -9,6 +9,16 @@ menuconfig LEDS_TRIGGERS
> >   if LEDS_TRIGGERS
> > +config LEDS_OFFLOAD_TRIGGERS
> > +	bool "LED Offload Trigger support"
> > +	help
> > +	  This option enabled offload triggers support used by leds that
> 
> 	                                                       LEDs
> 
> > +	  can be driven in HW by declaring some specific triggers.
> > +	  A offload trigger will expose a sysfs dir to configure the
> > +	  different blinking trigger and the available hw trigger.
> 
> Are the sysfs file values/meanings documented here?
> I seem to have missed them.
> 

The trigger should expose them and describe them. The idea is that the
LED driver need to explicitly support the trigger and the LED driver
will comunicate the trigger the supported offload trigger. And only then
the trigger will make them available via sysfs and set them
configurable. So all the sysfs stuff should be put in the trigger
Kconfig help. This is just to add support for the entire offload part.

> > +
> > +	  If unsure, say Y.
> > +
> 
> thanks.
> -- 
> ~Randy

-- 
	Ansuel
