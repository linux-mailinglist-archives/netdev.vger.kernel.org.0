Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A176244C9A1
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 20:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbhKJTyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 14:54:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbhKJTyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 14:54:04 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C88F0C061764;
        Wed, 10 Nov 2021 11:51:16 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id x15so15182865edv.1;
        Wed, 10 Nov 2021 11:51:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AIwVhU80Ia5fKIyWZamCIe2pa8PaPtqvkeHZOcxLT5Y=;
        b=op0VhOq9HQ07gFFeSB03mFTVr/YB0Wx7pQ6WL8DgGZhP1YVIQYifvNivKNkCjsydhG
         G9PAHRCrKD9frThSjco5V8h1Seug0SMkh0aoqwLfaGnSvR4DVXxG5gzH3zFMxc3A85Mo
         JVFHtJfzLb3EPGxXznJVZNNJY2OIpGftT2DmQp1z6S2+gSNuSO38Na6pNL6DTk8e8gQE
         jR7GFJKgzetr0AubaHfbsQrLPqIfJkFSpDuF5mdi92RZVKGt98nQwNOEzLTZPPqTCQnI
         i++ejAzmFRkdJYDGm0xJWFYXK9hSZI5Ztq3h14XJBO4zC989Sjfr330w7PNa6+bDzyaJ
         gmKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AIwVhU80Ia5fKIyWZamCIe2pa8PaPtqvkeHZOcxLT5Y=;
        b=61vIWy19aQEuIO5b9HwY8PGFyAAZY/6iHk+psDh6dHWGp2AzAROWPNUJMGRHN9UmVg
         HAYeahaxJ9N24csBVmXJKnt25yXSKrYHkluTT2BUaoGwD4qKYvD3ltoHaVAK72hQ8fuO
         zbyGzo45BQhbXxnpVuUUtn+WVivj7lmEVYrHBGKd044uVFmRd8ry25D1jp1UdVMDXKGE
         sVCSQanKTwCnZ1FMjnG90jYU6kWgsEQHXNYNCa0+fXpOurEKC6QY3J0ANrdOaAtg4vS1
         GYI6DlfVSRKfvUbzIvIYQXsvkIS5bOeOERzcAhVi4h2K5evcZ3vwrUgymyeinX/MRR86
         XfZg==
X-Gm-Message-State: AOAM530lmbNrNxkjD4DZI4j8aPYpwPhSfCiNr+SKHYjlYh39YyQZZGEu
        n8eF8NX8+C3aFzLLTyiAsIw=
X-Google-Smtp-Source: ABdhPJyJu7Lc//giq0/zGWFqRQrM7zoS3xqjdgfGFWTxQuumNnJciTh7owqupKLJwO9J6oPYjKANJA==
X-Received: by 2002:a50:8d4b:: with SMTP id t11mr1955391edt.371.1636573875210;
        Wed, 10 Nov 2021 11:51:15 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id m9sm314565eje.102.2021.11.10.11.51.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 11:51:14 -0800 (PST)
Date:   Wed, 10 Nov 2021 20:51:13 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
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
Message-ID: <YYwisR8XLL7TnwCB@Ansuel-xps.localdomain>
References: <20211109022608.11109-1-ansuelsmth@gmail.com>
 <20211109022608.11109-3-ansuelsmth@gmail.com>
 <20211109040103.7b56bf82@thinkpad>
 <YYqEPZpGmjNgFj0L@Ansuel-xps.localdomain>
 <YYre31rVDcs8OWre@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYre31rVDcs8OWre@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 09, 2021 at 09:49:35PM +0100, Andrew Lunn wrote:
> > > > +#ifdef CONFIG_LEDS_HARDWARE_CONTROL
> > > > +enum blink_mode_cmd {
> > > > +	BLINK_MODE_ENABLE, /* Enable the hardware blink mode */
> > > > +	BLINK_MODE_DISABLE, /* Disable the hardware blink mode */
> > > > +	BLINK_MODE_READ, /* Read the status of the hardware blink mode */
> > > > +	BLINK_MODE_SUPPORTED, /* Ask the driver if the hardware blink mode is supported */
> > > > +	BLINK_MODE_ZERO, /* Disable any hardware blink active */
> > > > +};
> > > > +#endif
> > > 
> > > this is a strange proposal for the API.
> > > 
> > > Anyway, led_classdev already has the blink_set() method, which is documented as
> > > 	/*
> > > 	  * Activate hardware accelerated blink, delays are in milliseconds
> > > 	  * and if both are zero then a sensible default should be chosen.
> > > 	  * The call should adjust the timings in that case and if it can't
> > > 	  * match the values specified exactly.
> > > 	  * Deactivate blinking again when the brightness is set to LED_OFF
> > > 	  * via the brightness_set() callback.
> > > 	  */
> > > 	int		(*blink_set)(struct led_classdev *led_cdev,
> > > 				     unsigned long *delay_on,
> > > 				     unsigned long *delay_off);
> > > 
> > > So we already have a method to set hardware blkinking, we don't need
> > > another one.
> > > 
> > > Marek
> > 
> > But that is about hardware blink, not a LED controlled by hardware based
> > on some rules/modes.
> > Doesn't really match the use for the hardware control.
> > Blink_set makes the LED blink contantly at the declared delay.
> > The blink_mode_cmd are used to request stuff to a LED in hardware mode.
> > 
> > Doesn't seem correct to change/enhance the blink_set function with
> > something that would do something completely different.
> 
> Humm. I can see merits for both.
> 
> What i like about reusing blink_set() is that it is well understood.
> There is a defined sysfs API for it. ledtrig-oneshot.c also uses it,
> for a non-repeating blink. So i think that also fits the PHY LED use
> case.
> 
> 	Andrew

If we should reuse blink_set to control hw blink I need to understand 2
thing.

The idea to implement the function hw_control_configure was to provide
the triggers some way to configure the various blink_mode. (and by using
the cmd enum provide different info based on the return value)

The advised path from Marek is to make the changes in the trigger_data
and the LED driver will then use that to configure blink mode.

I need to call an example to explain my concern:
qca8k switch. Can both run in hardware mode and software mode (by
controlling the reg to trigger manual blink) and also there is an extra
mode to blink permanently at 4hz.

Now someone would declare the brightness_set to control the led
manually and blink_set (for the permanent 4hz blink feature)
So that's where my idea comes about introducting another function and
the fact that it wouldn't match that well with blink_set with some LED.

I mean if we really want to use blink_set also for this(hw_control), we
can consider adding a bool to understand when hw_control is active or not.
So blink_set can be used for both feature.

Is that acceptable?

Also if we want to use blink_set I think we will have to drop all the
cmd mess and remove some error handling. Don't like that but if that's
what is needed for the feature, it's ok for me.

-- 
	Ansuel
