Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3118644B008
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 16:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232521AbhKIPJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 10:09:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236716AbhKIPJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 10:09:31 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6D9C061764;
        Tue,  9 Nov 2021 07:06:45 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id v11so75543299edc.9;
        Tue, 09 Nov 2021 07:06:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8IS6UH1QtcvVYmFbF/cY65EeLfvpjF+Q9PQUnNnTH2I=;
        b=YDogRuvSB7vifNWCOBhz7i0wJJR60jQLU1ekO5CEaBpXlQzGHmoZoB8Crz4b0ZQ6tY
         sI8XaejfB0tK1W0/WJ67e4k0U29pqcUC5TX+qLSn3vOtley9kQaJ4jHPT34kXw3AOC6S
         fetQLAz/nPO7g+oMluqfcK4OnF24q5azQd6bTCQbwZyHcf2402GNHRb0ncvZdKnZ1wyE
         OCOhj7KLafDs98Lxuvcy+Y10i5YOZoYBxXKWfWjWk5mQSIW5e/yaQbBz24CKL0Ov9e5u
         g1IhrN0WxTA2p6Y8XHiCb/4BMmv7y2Gij8Yjyz6ad91og4ED3ivqyfzE+5oAGhOlorlf
         M3Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8IS6UH1QtcvVYmFbF/cY65EeLfvpjF+Q9PQUnNnTH2I=;
        b=pkwcyg+YHaJOTX4j7sZpV+du4swY0bopLbjlg7I7O6H38YtZe+kLjpSkMz7fEobUCJ
         BXE1BaonUoiW4S/TzIWM6mZcYdMN9tC38Gd4wihwDKkKtK3Gx/VqxATrKdnhBBCFRXWd
         J2BOX9BpYzXFO+fJeL6FfsQatyg7gs0B00elpDavi/c5MVbM/eOEGzY5FQ2zjL16vm4w
         E3za2q+DZqFZc9I/c6DZX1ZgF/K/2hwty3EiEt77/vShWbgN/7Exjj5Qyv2EEtJvM6fN
         6T8UFmReoXahCs6XHqNptOrNnmQew0X27S99kzOp67EHSAdmUa5RMvYRCgAQ2ea1e7eK
         +VJA==
X-Gm-Message-State: AOAM533AXberXdAigr2aB21BV698MHj68R1czpTLL0UMHnCyuyOLzJgZ
        2fdJOLpGzHcjXXw5qlk5oLU=
X-Google-Smtp-Source: ABdhPJxg/rBo/a2w+SeQaLCdemY6uOaVQyLD/JBSkjkYW8IRad8II3G7i2hXJ8NQiAc5OEEs6eG0pg==
X-Received: by 2002:a05:6402:95b:: with SMTP id h27mr11363913edz.116.1636470403328;
        Tue, 09 Nov 2021 07:06:43 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id z7sm4815344edj.51.2021.11.09.07.06.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 07:06:42 -0800 (PST)
Date:   Tue, 9 Nov 2021 16:06:41 +0100
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
Subject: Re: [RFC PATCH v3 6/8] leds: trigger: add hardware-phy-activity
 trigger
Message-ID: <YYqOgTgCcRtj7KqC@Ansuel-xps.localdomain>
References: <20211109022608.11109-1-ansuelsmth@gmail.com>
 <20211109022608.11109-7-ansuelsmth@gmail.com>
 <28048612-a7d2-19e0-a632-a5ae061819cd@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28048612-a7d2-19e0-a632-a5ae061819cd@infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 08, 2021 at 10:02:22PM -0800, Randy Dunlap wrote:
> On 11/8/21 6:26 PM, Ansuel Smith wrote:
> > diff --git a/drivers/leds/trigger/Kconfig b/drivers/leds/trigger/Kconfig
> > index dc6816d36d06..b947b238be3f 100644
> > --- a/drivers/leds/trigger/Kconfig
> > +++ b/drivers/leds/trigger/Kconfig
> > @@ -154,4 +154,32 @@ config LEDS_TRIGGER_TTY
> >   	  When build as a module this driver will be called ledtrig-tty.
> > +config LEDS_TRIGGER_HARDWARE_PHY_ACTIVITY
> > +	tristate "LED Trigger for PHY Activity for Hardware Controlled LED"
> > +	depends on LEDS_HARDWARE_CONTROL
> > +	help
> > +	  This allows LEDs to be configured to run by hardware and offloaded
> > +	  based on some rules. The LED will blink or be on based on the PHY
> 
> 	                                          or be "on" based on the PHY
> 
> > +	  Activity for example on packet receive or based on the link speed.
> 
> 	  activity
> 
> > +
> > +	  The current supported offload triggers are:
> > +	  - blink_tx: Blink LED on tx packet receive
> > +	  - blink_rx: Blink LED on rx packet receive
> > +	  - keep_link_10m: Keep LED on with 10m link speed
> > +	  - keep_link_100m: Keep LED on with 100m link speed
> > +	  - keep_link_1000m: Keep LED on with 1000m link speed
> > +	  - keep_half_duplex: Keep LED on with half duplex link
> > +	  - keep_full_duplex: Keep LED on with full duplex link
> > +	  - option_linkup_over: Blink rules are ignored with absent link
> > +	  - option_power_on_reset: Power ON Led on Switch/PHY reset
> > +	  - option_blink_2hz: Set blink speed at 2hz for every blink event
> > +	  - option_blink_4hz: Set blink speed at 4hz for every blink event
> > +	  - option_blink_8hz: Set blink speed at 8hz for every blink event
> > +
> > +	  These blink modes are present in the LED sysfs dir under
> > +	  hardware-phy-activity if supported by the LED driver.
> > +
> > +	  This trigger can be used only by LEDs that supports Hardware mode
> 
> 	                                             support Hardware mode.
> 
> 
> Ansuel, do you read and consider these comments?
> It's difficult to tell if you do or not.
>

Yes and with every new version I'm fixing the errors.
Just we are changing implementation many times and more errors comes up.
Thanks a lot for the comments and sorry if I'm not answering them.

> thanks.
> -- 
> ~Randy

-- 
	Ansuel
