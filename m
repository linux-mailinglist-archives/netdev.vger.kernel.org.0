Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FEED51C0A2
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 15:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379355AbiEENbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 09:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344383AbiEENbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 09:31:13 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B205F396BA;
        Thu,  5 May 2022 06:27:33 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id d6so5190634ede.8;
        Thu, 05 May 2022 06:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=nHOoHEGsmze3npyTXqLAhhEQTXnphFtBEWTNzFPda74=;
        b=Mezhonl9s+ngmGDudy8k86Kn3eW+tkU56/ONzMQ0K1mLP0MqNx3preIJZowyjqcsw3
         yBRue7jog50Vz3BTGKfNsAhQTGkkBmh6KAcE5xNAEmbctW+N1FlQXDNQXKs3G0nNEbxt
         /ymfB10N5xaUYFQEbEt+OJDJhXdM0hTQAfrxmKC/8j1f/etEEvfp/2HnZex9MB3SY1CQ
         n9FeskcHJEkGFnyuOlODQbSmVfIEXQMiy1FyEHsf5c7HLS3kQz5JpbP/X5h0Eoi06bDV
         QIjXGOzPWTeXDizrkoP41OW+o9OhGhxrFobiFTntRCxjGPNbWAbIcInJ0CuL3fwneTZ7
         jcwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=nHOoHEGsmze3npyTXqLAhhEQTXnphFtBEWTNzFPda74=;
        b=irLusaEin5Vl62ysrn+Rf8v4a7sJkCkhJ7/7iTZ33vCN6TyOjFOP5ehLCXDwsIRFS9
         FVTYpZ298F6gGXwXF8z8HRggYQgfEhqPiHRYWF4ZbnucZSHixOCkwvRTUbSZ7HeaLacU
         5eAPbmKqpftNcgrWyJH3KxLM6QVDF22vMCsmQb9n4TNZYRe4sOTXgth9Z0diiEOSfPSi
         l4IjiIIYfhDA8mbH8PBPCZ4kb/pUp1rEUd/yR/F3D6BAKdTloMmKMCgtNFaIZ+RC2bnG
         3jVRcIvE4FQi20XPPEixZzgEitLYLFROf1b5CNe7fkHShXg9zBevKls+r1sLpMdLsaBQ
         /vFw==
X-Gm-Message-State: AOAM530Zm75q9SAnVkZj46SKrAWLbQFvo08hmL0iB8lnKcYPgei1sC6Y
        pUQhuAFZ9+RKkidk3t/vkol6m1RXP30=
X-Google-Smtp-Source: ABdhPJyROXA8t7WlzuCAbTu5ISI005y3+7V4ktHxtr1SiTWSmxdCqv8qejbuNsoqSXhvOSfggPcevQ==
X-Received: by 2002:a05:6402:430f:b0:427:d034:295b with SMTP id m15-20020a056402430f00b00427d034295bmr19307387edc.126.1651757252134;
        Thu, 05 May 2022 06:27:32 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.gmail.com with ESMTPSA id p21-20020a17090653d500b006f3ef214e3csm717924ejo.162.2022.05.05.06.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 06:27:31 -0700 (PDT)
Message-ID: <6273d0c3.1c69fb81.19fc.3eaf@mx.google.com>
X-Google-Original-Message-ID: <YnPQwaynVpFOsJfX@Ansuel-xps.>
Date:   Thu, 5 May 2022 15:27:29 +0200
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
Subject: Re: [RFC PATCH v6 06/11] leds: trigger: netdev: add hardware control
 support
References: <20220503151633.18760-1-ansuelsmth@gmail.com>
 <20220503151633.18760-7-ansuelsmth@gmail.com>
 <YnMhk1F0LrIMK5hp@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnMhk1F0LrIMK5hp@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 05, 2022 at 03:00:03AM +0200, Andrew Lunn wrote:
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
> 
> hardware_only is never set. Maybe it is used in a later patch? If so,
> please introduce it there.
>

Is it better to introduce the hardware_only bool in the patch where the
additional "hardware only" modes are added?

> >  static void set_baseline_state(struct led_netdev_data *trigger_data)
> >  {
> > +	int i;
> >  	int current_brightness;
> > +	struct netdev_led_attr_detail *detail;
> >  	struct led_classdev *led_cdev = trigger_data->led_cdev;
> 
> This file mostly keeps with reverse christmas tree, probably because
> it was written by a netdev developer. It is probably not required for
> the LED subsystem, but it would be nice to keep the file consistent.
> 

The order is a bit mixed as you notice. Ok will stick to reverse
christmas.

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
> 
> You probably want to validate trigger_data->net_dev is not NULL first. The current code
> is a little odd with that, 
> 

The thing is that net_dev can be NULL and actually is a requirement for
hardware_mode to be triggered. (net_dev must be NULL or software mode is
forced)

> > +		/* Restore old net_dev and device_name */
> > +		if (trigger_data->net_dev)
> > +			dev_put(trigger_data->net_dev);
> > +
> > +		dev_hold(old_net);
> 
> This dev_hold() looks wrong. It is trying to undo a dev_put()
> somewhere? You should not actually do a put until you know you really
> do not old_net, otherwise there is a danger it disappears and you
> cannot undo.
> 

Yes if you notice some lines above, the first thing done is to dev_put
the current net_dev set. So on validation fail we restore the old state
with holding the old_net again and restoring the device_name.

But thanks for poiting it out... I should check if old_net is not NULL.
Also should i change the logic and just dev_put if all goes well? (for
example before the return size?) That way I should be able to skip this
additional dev_hold.

> > @@ -228,13 +349,22 @@ static ssize_t interval_store(struct device *dev,
> >  		return ret;
> >  
> >  	/* impose some basic bounds on the timer interval */
> > -	if (value >= 5 && value <= 10000) {
> > -		cancel_delayed_work_sync(&trigger_data->work);
> > +	if (value < 5 || value > 10000)
> > +		return -EINVAL;
> > +
> > +	cancel_delayed_work_sync(&trigger_data->work);
> > +
> > +	atomic_set(&trigger_data->interval, msecs_to_jiffies(value));
> >  
> > -		atomic_set(&trigger_data->interval, msecs_to_jiffies(value));
> > -		set_baseline_state(trigger_data);	/* resets timer */
> > +	if (!validate_baseline_state(trigger_data)) {
> > +		/* Restore old interval on validation error */
> > +		atomic_set(&trigger_data->interval, old_interval);
> > +		trigger_data->mode = old_mode;
> 
> I think you need to schedule the work again, since you cancelled
> it. It is at the end of the work that the next work is scheduled, and
> so it will not self recover.
> 

Ok I assume the correct way to handle this is to return error and still
use the set_baseline_state... Or Also move the validate_baseline_state
up before the cancel_delayed_work_sync. But considering we require
atomic_set for the validation to work I think the right way is to
set_baseline_state even with errors (as it will reschedule the work)

>    Andrew

-- 
	Ansuel
