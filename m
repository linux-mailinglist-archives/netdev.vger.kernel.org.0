Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF61844B002
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 16:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237680AbhKIPHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 10:07:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237358AbhKIPHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 10:07:09 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94454C061764;
        Tue,  9 Nov 2021 07:04:23 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id c4so33547707wrd.9;
        Tue, 09 Nov 2021 07:04:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=lYfo9/64m/tKBgbtcaBOBqPoKGP+hSU3uWpmCakWw5A=;
        b=Vg5a8KzMTLjjJSHyUP4MSSRVrmGPbttzAAgwmMneAy32EOHxFIVDj3DItO2G/NfrPH
         Ni6SumZUBlRAZeB7HHq04zhhdJwt/BZc8qxGd2XqgNenrYkNDhKORyHd+ywEB5IcxaoC
         gyCBDou70t6iCPP2I0/JQxhlhAP8WxeiG48QwdT3KUQkFVuO0I3TSQ8gPwjpVuOLvdYw
         q8aID2rLkNsGnzYmaRt4b5FFRCS5yFBYZ3tHh+A8HVPJ3TIbJwyCZcYMP5LSJVlL3jOL
         TM598v5ZHzCpJrPNYlB2vqSoGo0NnV506CSFbf4vFpDxFVEWDNpbCjKZiqdG8LbKpHzg
         uLpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=lYfo9/64m/tKBgbtcaBOBqPoKGP+hSU3uWpmCakWw5A=;
        b=GW2cokl36dqTCodqa7antNX4rFrxmCuwHT43CZSdJd7gVpvjbFe2QnHNqaDFIn8rxq
         iVUo0WgHZ8fCYElLP0596+l+80sN05TUcAUMoLPHCzoPb+LkGExzBiDyN/46rDjdIo9y
         imoGDGwnlZQxruTyPXsGmGpRJqql+8Kgzb0mdD4WU50frg/XLMutNL49iQGbizpOWgBI
         vT72p8w/XjedHkarLsq0Yv6HOtWpvsFDXZlImfJ4wIMRU8cQ+hgiUnlRDpoKddKbyOCc
         7co0YiiUPJENaWKKf+zP/VIcluNKmnUpzmgtQfinU4lbD8SuuUm988pivqoCIfqJYpPN
         oqZg==
X-Gm-Message-State: AOAM532HOjfPcisHocgueuhTIBRc6kZ/qmDIMEt9QXX+hbBPspNenDXO
        ZOGKxiZ+uFKmHdsgBJyWw7s=
X-Google-Smtp-Source: ABdhPJxweqwUD6QFJCSj4l/KvanNHCFKDHg96xafzk7rERgk3rJKnn/NJUXsfqu8nfTDmpzxTScglg==
X-Received: by 2002:adf:da44:: with SMTP id r4mr10568234wrl.180.1636470261866;
        Tue, 09 Nov 2021 07:04:21 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id f19sm3855431wmq.34.2021.11.09.07.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 07:04:21 -0800 (PST)
Date:   Tue, 9 Nov 2021 16:02:47 +0100
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
Subject: Re: [RFC PATCH v3 5/8] leds: trigger: netdev: add hardware control
 support
Message-ID: <YYqNlzGqUFBed4P4@Ansuel-xps.localdomain>
References: <20211109022608.11109-1-ansuelsmth@gmail.com>
 <20211109022608.11109-6-ansuelsmth@gmail.com>
 <20211109041236.5bacbc19@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211109041236.5bacbc19@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 09, 2021 at 04:12:36AM +0100, Marek Behún wrote:
> On Tue,  9 Nov 2021 03:26:05 +0100
> Ansuel Smith <ansuelsmth@gmail.com> wrote:
> 
> > Add hardware control support for the Netdev trigger.
> > The trigger on config change will check if the requested trigger can set
> > to blink mode using LED hardware mode and if every blink mode is supported,
> > the trigger will enable hardware mode with the requested configuration.
> > If there is at least one trigger that is not supported and can't run in
> > hardware mode, then software mode will be used instead.
> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> >  drivers/leds/trigger/ledtrig-netdev.c | 61 ++++++++++++++++++++++++++-
> >  1 file changed, 60 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
> > index 0a3c0b54dbb9..28d9def2fbd0 100644
> > --- a/drivers/leds/trigger/ledtrig-netdev.c
> > +++ b/drivers/leds/trigger/ledtrig-netdev.c
> > @@ -37,6 +37,7 @@
> >   */
> >  
> >  struct led_netdev_data {
> > +	bool hw_mode_supported;
> >  	spinlock_t lock;
> >  
> >  	struct delayed_work work;
> > @@ -61,9 +62,52 @@ enum netdev_led_attr {
> >  
> >  static void set_baseline_state(struct led_netdev_data *trigger_data)
> >  {
> > +	bool can_offload;
> >  	int current_brightness;
> > +	u32 hw_blink_mode_supported;
> >  	struct led_classdev *led_cdev = trigger_data->led_cdev;
> >  
> > +	if (trigger_data->hw_mode_supported) {
> > +		if (test_bit(TRIGGER_NETDEV_LINK, &trigger_data->mode) &&
> > +		    led_trigger_blink_mode_is_supported(led_cdev, TRIGGER_NETDEV_LINK))
> > +			hw_blink_mode_supported |= TRIGGER_NETDEV_LINK;
> > +		if (test_bit(TRIGGER_NETDEV_TX, &trigger_data->mode) &&
> > +		    led_trigger_blink_mode_is_supported(led_cdev, TRIGGER_NETDEV_TX))
> > +			hw_blink_mode_supported |= TRIGGER_NETDEV_TX;
> > +		if (test_bit(TRIGGER_NETDEV_RX, &trigger_data->mode) &&
> > +		    led_trigger_blink_mode_is_supported(led_cdev, TRIGGER_NETDEV_RX))
> > +			hw_blink_mode_supported |= TRIGGER_NETDEV_RX;
> > +
> > +		/* All the requested blink mode can be triggered by hardware.
> > +		 * Put it in hardware mode.
> > +		 */
> > +		if (hw_blink_mode_supported == trigger_data->mode)
> > +			can_offload = true;
> > +
> > +		if (can_offload) {
> > +			/* We are refreshing the blink modes. Reset them */
> > +			led_cdev->hw_control_configure(led_cdev, TRIGGER_NETDEV_LINK,
> > +						       BLINK_MODE_ZERO);
> > +
> > +			if (test_bit(TRIGGER_NETDEV_LINK, &trigger_data->mode))
> > +				led_cdev->hw_control_configure(led_cdev, TRIGGER_NETDEV_LINK,
> > +							       BLINK_MODE_ENABLE);
> > +			if (test_bit(TRIGGER_NETDEV_TX, &trigger_data->mode))
> > +				led_cdev->hw_control_configure(led_cdev, TRIGGER_NETDEV_TX,
> > +							       BLINK_MODE_ENABLE);
> > +			if (test_bit(TRIGGER_NETDEV_RX, &trigger_data->mode))
> > +				led_cdev->hw_control_configure(led_cdev, TRIGGER_NETDEV_RX,
> > +							       BLINK_MODE_ENABLE);
> > +			led_cdev->hw_control_start(led_cdev);
> 
> Please nooo :)
> This is exactly what I wanted to avoid, this logic should be in the LED
> driver itself.
>

Don't know about this. Honestly I think a better way would be to make
the LED driver very stupid (current way) and just leave to the trigger
how to handle the different case.
My idea is that LED driver should declare feature and do operation and
then the trigger should elaborate them.

> Can you please at least read my last proposal?
> 

About this sorry but I lost track of it. Thanks for posting it here.

> patch 2
> https://lore.kernel.org/linux-leds/20210601005155.27997-3-kabel@kernel.org/
> adds the trigger_offload() method. This may need to get changed to
> trigger_offload_start() and trigger_offload_stop(), as per Andrew's
> request.
> 
> patch 3
> https://lore.kernel.org/linux-leds/20210601005155.27997-4-kabel@kernel.org/
> moves the whole struct led_netdev_data to global include file
> include/linux/ledtrig-netdev.h
> 
> patch 4
> https://lore.kernel.org/linux-leds/20210601005155.27997-5-kabel@kernel.org/
> makes netdev trigger to try to call the trigger_offload() method.
> 
> So after patch 4, netdev trigger calls trigger_offload() methods and
> passes itself into it.
> 
> Example implementation is then in patch 10 of the series
> https://lore.kernel.org/linux-leds/20210601005155.27997-11-kabel@kernel.org/
> Look at omnia_led_trig_offload() function.
> 
> The benefit of this API is that it is flexible - all existing triggers
> an be theoretically offloaded to HW (if there is HW that supports it)
> without change to this API, and with minimal changes to the sw
> implementations of the triggers.

Looking at the patchset the main problem with my implementation is that
a LED driver would benefits by having more data as it can also configure
other stuff. So I see using the logic of using directly the trigger
data instead of some values correct.
What I still don't like is the fact that moving the entire logic to the
LED driver doesn't seems correct. 
We can mix the 2 logic and create an hybrid.
- I would still have some type of direct control from a trigger.
  (We reduce the current cmd enum to something like APPLY, ZERO,
  SUPPORTED) just so the hardware configure part is not a big blackbox
  that do thing and we doesn't really know what happen on any error.
- On the LED driver part, it will use the data from the trigger and
  report what it was asked.

That would change the LED trigger transaction to.
1. Set the bitmap in the trigger data
2. Send supported command (the LED driver do his check and return a
   bool)
3. Send apply command (the LED driver actually apply the config)

Also the trigger will ZERO any blink configuration on init.
(to handle LEDs that configure some blink mode by default in hardware
mode)

The first question would be why have all these extra modes when we can
just use one function like hw_control_setup. Well some other trigger
would benefit from having more control and we would get better error
handling by separating the main operation (supported and apply)

What do you think? This should be even more flexible than before and
would also remove the flag problem (or better saying moving it to
exporting the entire trigger struct)

Also about exporting struct. Should we really create another include or
should we just put it in the generic led include?

> 
> Could you please at least try it?
> 

If you are fine with the idea I have in mind, I will start working on v4
ASAP.

> I am willing to work with you on this. We can make a conference call
> tomorrow, if you are able to.
> 

A bit busy so I work on this on very late night but I think the way we
are comunicating is fine. Lets continue like that.

> Marek

-- 
	Ansuel
