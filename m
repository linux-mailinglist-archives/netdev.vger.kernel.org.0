Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFB264F012
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 18:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbiLPRKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 12:10:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231409AbiLPRKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 12:10:00 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DBBFEBC;
        Fri, 16 Dec 2022 09:09:59 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id c65-20020a1c3544000000b003cfffd00fc0so4588332wma.1;
        Fri, 16 Dec 2022 09:09:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=OXy3ueBR6wVuG2/VKlVCadT8O9k0LlAEa6JC/bhnWWU=;
        b=UPDazBaIu2fSoFAJTa3/jRCwU2RidcAsN2nptPwpQjmq1HgvuBR+9sAL67wxnBZF2Z
         2VLSoZxJOU/XlBq/2NACYNyF4kelML7EjUv9Er7GCd6hpwEcoXp3yN02nNi4khP05aM8
         47S8oyXBsbTGUJAzXFquufbya7hf5Z2S+8LH+j+H1CV4gMrYSwpI93OuqUWH0b+Ey16t
         iS3yBgKgGlCQYK7c5pxqV18EfDaPolW/bG26z+cz1D2BtaAOsqtwaz/HHbNO7PkncUl1
         OWKmk9++9V7JDWaru6WQZBnu0KB+pTtgCOaMPJt/sjtTLjQklpol+uQRNy8L2XKO06dD
         WTfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OXy3ueBR6wVuG2/VKlVCadT8O9k0LlAEa6JC/bhnWWU=;
        b=VhMzC15pDDU2ab5Mx+QIKGMCX5olJs5HFAb0268pSRqY4diUwtr+g6Kr6A3JmtzfWq
         vvKwDOzzjtPLtxag00lrTFsK/q1GxmPtfrxswMlpGCboqXfYAHy6bxC4Kq+6c8MJaEe3
         ezXw2Do+r/EHmG1Pi20ONtOaCbFgccU+oufMLvKj2uX99BSp1YDcZlK4Q0lterjLN3xX
         0fBgRjfkl5xzBjF8IibQulGclwKTS+nlZTEUG7sMWe76UFnS3TocSxeoH9DA8NyYCAsg
         F+jmqUPctMVZ1aUFTM+nijz/SD/pLlNprCd+uFojT/ERTLH+bl0RAlMH0ceCm/eNaBOW
         ApOA==
X-Gm-Message-State: ANoB5pn8XuosXMV2HuY0Wk652cKgwdXnq6CMrfndkmi4LewoaO/0IiOy
        HdvUrEXpxbx98SaMJFoY6ZA=
X-Google-Smtp-Source: AA0mqf7DL/q+ypNtUscw8zIxIxzhSoxHKhZA3dgZSCQ2F+VBE494romYvBslK3IuiLIjL7OBN2kcCA==
X-Received: by 2002:a05:600c:4f05:b0:3cf:6f4d:c25d with SMTP id l5-20020a05600c4f0500b003cf6f4dc25dmr24674139wmq.21.1671210597519;
        Fri, 16 Dec 2022 09:09:57 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-18.ip85.fastwebnet.it. [93.42.71.18])
        by smtp.gmail.com with ESMTPSA id f24-20020a1c6a18000000b003b95ed78275sm3061225wmc.20.2022.12.16.09.09.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 09:09:57 -0800 (PST)
Message-ID: <639ca665.1c0a0220.ae24f.9d06@mx.google.com>
X-Google-Original-Message-ID: <Y5ymZnJWpRMdigsd@Ansuel-xps.>
Date:   Fri, 16 Dec 2022 18:09:58 +0100
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
Subject: Re: [PATCH v7 06/11] leds: trigger: netdev: add hardware control
 support
References: <20221214235438.30271-1-ansuelsmth@gmail.com>
 <20221214235438.30271-7-ansuelsmth@gmail.com>
 <Y5tUU5zA/lkYJza+@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5tUU5zA/lkYJza+@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 15, 2022 at 05:07:31PM +0000, Russell King (Oracle) wrote:
> On Thu, Dec 15, 2022 at 12:54:33AM +0100, Christian Marangi wrote:
> > Add hardware control support for the Netdev trigger.
> > The trigger on config change will check if the requested trigger can set
> > to blink mode using LED hardware mode and if every blink mode is supported,
> > the trigger will enable hardware mode with the requested configuration.
> > If there is at least one trigger that is not supported and can't run in
> > hardware mode, then software mode will be used instead.
> > A validation is done on every value change and on fail the old value is
> > restored and -EINVAL is returned.
> > 
> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > ---
> >  drivers/leds/trigger/ledtrig-netdev.c | 155 +++++++++++++++++++++++++-
> >  1 file changed, 149 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
> > index dd63cadb896e..ed019cb5867c 100644
> > --- a/drivers/leds/trigger/ledtrig-netdev.c
> > +++ b/drivers/leds/trigger/ledtrig-netdev.c
> > @@ -37,6 +37,7 @@
> >   */
> >  
> >  struct led_netdev_data {
> > +	enum led_blink_modes blink_mode;
> >  	spinlock_t lock;
> >  
> >  	struct delayed_work work;
> > @@ -53,11 +54,105 @@ struct led_netdev_data {
> >  	bool carrier_link_up;
> >  };
> >  
> > +struct netdev_led_attr_detail {
> > +	char *name;
> > +	bool hardware_only;
> > +	enum led_trigger_netdev_modes bit;
> > +};
> > +
> > +static struct netdev_led_attr_detail attr_details[] = {
> > +	{ .name = "link", .bit = TRIGGER_NETDEV_LINK},
> > +	{ .name = "tx", .bit = TRIGGER_NETDEV_TX},
> > +	{ .name = "rx", .bit = TRIGGER_NETDEV_RX},
> > +};
> > +
> > +static bool validate_baseline_state(struct led_netdev_data *trigger_data)
> > +{
> > +	struct led_classdev *led_cdev = trigger_data->led_cdev;
> > +	struct netdev_led_attr_detail *detail;
> > +	u32 hw_blink_mode_supported = 0;
> > +	bool force_sw = false;
> > +	int i;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(attr_details); i++) {
> > +		detail = &attr_details[i];
> > +
> > +		/* Mode not active, skip */
> > +		if (!test_bit(detail->bit, &trigger_data->mode))
> > +			continue;
> > +
> > +		/* Hardware only mode enabled on software controlled led */
> > +		if (led_cdev->blink_mode == SOFTWARE_CONTROLLED &&
> > +		    detail->hardware_only)
> > +			return false;
> > +
> > +		/* Check if the mode supports hardware mode */
> > +		if (led_cdev->blink_mode != SOFTWARE_CONTROLLED) {
> > +			/* With a net dev set, force software mode.
> > +			 * With modes are handled by hardware, led will blink
> > +			 * based on his own events and will ignore any event
> > +			 * from the provided dev.
> > +			 */
> > +			if (trigger_data->net_dev) {
> > +				force_sw = true;
> > +				continue;
> > +			}
> > +
> > +			/* With empty dev, check if the mode is supported */
> > +			if (led_trigger_blink_mode_is_supported(led_cdev, detail->bit))
> > +				hw_blink_mode_supported |= BIT(detail->bit);
> > +		}
> > +	}
> > +
> > +	/* We can't run modes handled by both software and hardware.
> > +	 * Check if we run hardware modes and check if all the modes
> > +	 * can be handled by hardware.
> > +	 */
> > +	if (hw_blink_mode_supported && hw_blink_mode_supported != trigger_data->mode)
> > +		return false;
> > +
> > +	/* Modes are valid. Decide now the running mode to later
> > +	 * set the baseline.
> > +	 * Software mode is enforced with net_dev set. With an empty
> > +	 * one hardware mode is selected by default (if supported).
> > +	 */
> > +	if (force_sw || led_cdev->blink_mode == SOFTWARE_CONTROLLED)
> > +		trigger_data->blink_mode = SOFTWARE_CONTROLLED;
> > +	else
> > +		trigger_data->blink_mode = HARDWARE_CONTROLLED;
> > +
> > +	return true;
> > +}
> > +
> >  static void set_baseline_state(struct led_netdev_data *trigger_data)
> >  {
> > +	int i;
> >  	int current_brightness;
> > +	struct netdev_led_attr_detail *detail;
> >  	struct led_classdev *led_cdev = trigger_data->led_cdev;
> >  
> > +	/* Modes already validated. Directly apply hw trigger modes */
> > +	if (trigger_data->blink_mode == HARDWARE_CONTROLLED) {
> > +		/* We are refreshing the blink modes. Reset them */
> > +		led_cdev->hw_control_configure(led_cdev, BIT(TRIGGER_NETDEV_LINK),
> > +					       BLINK_MODE_ZERO);
> > +
> > +		for (i = 0; i < ARRAY_SIZE(attr_details); i++) {
> > +			detail = &attr_details[i];
> > +
> > +			if (!test_bit(detail->bit, &trigger_data->mode))
> > +				continue;
> > +
> > +			led_cdev->hw_control_configure(led_cdev, BIT(detail->bit),
> > +						       BLINK_MODE_ENABLE);
> > +		}
> > +
> > +		led_cdev->hw_control_start(led_cdev);
> > +
> > +		return;
> > +	}
> > +
> > +	/* Handle trigger modes by software */
> >  	current_brightness = led_cdev->brightness;
> >  	if (current_brightness)
> >  		led_cdev->blink_brightness = current_brightness;
> > @@ -100,10 +195,15 @@ static ssize_t device_name_store(struct device *dev,
> >  				 size_t size)
> >  {
> >  	struct led_netdev_data *trigger_data = led_trigger_get_drvdata(dev);
> > +	struct net_device *old_net = trigger_data->net_dev;
> > +	char old_device_name[IFNAMSIZ];
> >  
> >  	if (size >= IFNAMSIZ)
> >  		return -EINVAL;
> >  
> > +	/* Backup old device name */
> > +	memcpy(old_device_name, trigger_data->device_name, IFNAMSIZ);
> > +
> >  	cancel_delayed_work_sync(&trigger_data->work);
> >  
> >  	spin_lock_bh(&trigger_data->lock);
> > @@ -122,6 +222,19 @@ static ssize_t device_name_store(struct device *dev,
> >  		trigger_data->net_dev =
> >  		    dev_get_by_name(&init_net, trigger_data->device_name);
> >  
> > +	if (!validate_baseline_state(trigger_data)) {
> > +		/* Restore old net_dev and device_name */
> > +		if (trigger_data->net_dev)
> > +			dev_put(trigger_data->net_dev);
> > +
> > +		dev_hold(old_net);
> > +		trigger_data->net_dev = old_net;
> > +		memcpy(trigger_data->device_name, old_device_name, IFNAMSIZ);
> > +
> > +		spin_unlock_bh(&trigger_data->lock);
> > +		return -EINVAL;
> 
> I'm not sure this is the best way... putting the net_dev but holding a
> reference, to leter regain the reference via dev_hold() just feels
> wrong. Also, I wonder what happens if two threads try to change the
> netdev together - will the read of the old device name be potentially
> corrupted (since we're not holding the trigger's lock?)
> 
> Maybe instead:
> 
> +	struct net_device *old_net;
> ...
> -	if (trigger_data->net_dev) {
> -		dev_put(trigger_data->net_dev);
> -		trigger_data->net_dev = NULL;
> -	}
> +	old_net = trigger_data->net_dev;
> +	trigger_data->net_dev = NULL;
> +	memcpy(old_device_name, trigger_data->device_name, IFNAMSIZ);
> ...
> 	... extract out the setup of trigger_data->device_name
> ...
> +	if (!validate_baseline_state(trigger_data)) {
> +		if (trigger_data->net_dev)
> +			dev_put(trigger_data->net_dev);
> +
> +		/* Restore device settings */
> +		trigger_data->net_dev = old_dev;
> +		memcpy(trigger_data->device_name, old_device_name, IFNAMSIZ);
> +		spin_unlock_bh(&trigger_data->lock);
> +		return -EINVAL;
> +	} else {
> +		dev_put(old_net);
> +	}
> 
> would be safer all round?

Need to check but if I'm not wrong all this thing was to handle the very
corner case where net can be removed while we are changing trigger and
something goes wrong down the line... Holding that means it won't get
actually removed till everything is ok.

> 
> One thought on this approach though - if one has a PHY that supports
> "activity" but not independent "rx" and "tx" activity indications
> and it doesn't support software control, how would one enable activity
> mode? There isn't a way to simultaneously enable both at the same
> time... However, I need to check whether there are any PHYs that fall
> into this category.
>

Problem is that for such feature and to have at least something working
we need to face compromise. We really can't support each switch feature
and have a generic API for everything. My original idea was to have
something VERY dynamic with a totally dedicated and dumb trigger... But
that was NACK as netdev was the correct way to handle these stuff...

But adapting everything to netdev trigger is hard since you have just
another generic abstraction layer. My idea at times was that in such
case the trigger rule will be rejected and only enabled if both tx and
rx were enabled. An alternative is to add another flag for activity
rule. (for switch supporting independent tx and rx with activity rule
enable both tx and rx event are enabled. for switch not supporting
independent tx and rx just fallback to sw and say that the mode is not
suported.)

I already had the idea of Documenting all this case but if we decide to
follow this approach then creating a schema file is a must at this
point. (but wanted to introduce that later if and ever this feature will
be accepted to permit to set trigger rules directly in DT following
something like linux,default-trigger.

-- 
	Ansuel
