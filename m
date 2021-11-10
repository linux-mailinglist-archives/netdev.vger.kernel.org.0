Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD78F44C9EC
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 20:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbhKJUAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 15:00:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbhKJUAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 15:00:16 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7D4C061764;
        Wed, 10 Nov 2021 11:57:28 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id x15so15240800edv.1;
        Wed, 10 Nov 2021 11:57:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EU6qRCGKmOsD7M4nlNl8xZtfhKKTJDrdLwQ6tHtqau8=;
        b=HmsajFPz5u8KZGfSDlwOG70dFndlBn8lNACxHCAaZaxgzsCSx//qXtUQ6PzJ2hi0Ef
         QRFuhls6BJQqBe+9A3L89PYlRHWd83VdxeANpz7doHcblCkKpSg91pdGE9CkeiiNlFMP
         B24l9ux91p95f/063pN7uJLblerOIDikrRoQ6GAe4pecy0mC9dhMOYZy9mKlk4GGOkQX
         f5sbqNOiignnvdLEjX9liJJtP2JHW+YWtANoXlC0s/NZspNaeSxaC9xogMjXjkFw2ujY
         kWIDWplVOqeHw6EAfa0npYmbNTy+lK9Uyi0yljn9neJhn4iS2Y5HnnvFu5r7yrnw9Njt
         tRQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EU6qRCGKmOsD7M4nlNl8xZtfhKKTJDrdLwQ6tHtqau8=;
        b=SLrujYO2tAoVPvnNwLXy7z2rrFNVlcZl0HH3KvshM04IgiLdcicQZPkMdzLfXUkWnE
         WwpgOve03wSyHP2kOBea2fgKm59+GHp+49xLPIi18UmnMQifxz+Bmrhja02sGlT2Dwkm
         fUZV5MLBGpZCDzQX7u7lM9rAi+dl2bLANBaDU2HNhIHrbm078pC4frQ6llryjzfSFDUt
         h47Y+o3X8zeyYYK1J3c4rV6d0j9fMTGJCsGHtr4B6aLmbKLM0pNN78Ch+CvlKN0lX5Nd
         WAaKDF1PDlkJVqyLSJfuBQ9CP+fdtrr9TDEWmd+WDjgiEuRmaPe/zlKPVyZDlmOq4lbk
         txbQ==
X-Gm-Message-State: AOAM533dcDRTVlJ6YGdGn8mjCp6/TGBQQmMf89XxHo/aapGTl8u+woxN
        c08oWh13GHje86ZlWQFSx212cj5wpyc=
X-Google-Smtp-Source: ABdhPJx/zqq0oAEZw0FPESEHqBVLX7xbZbaLQDOoVprKI4/kf81vjA18xQFtIFm8rrj5No7RGcKT/g==
X-Received: by 2002:a05:6402:416:: with SMTP id q22mr2075002edv.382.1636574247165;
        Wed, 10 Nov 2021 11:57:27 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id d4sm378725edk.78.2021.11.10.11.57.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 11:57:26 -0800 (PST)
Date:   Wed, 10 Nov 2021 20:57:24 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
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
Subject: Re: [RFC PATCH v3 4/8] leds: trigger: netdev: rename and expose
 NETDEV trigger enum modes
Message-ID: <YYwkJPQeej3/eRUl@Ansuel-xps.localdomain>
References: <20211109022608.11109-1-ansuelsmth@gmail.com>
 <20211109022608.11109-5-ansuelsmth@gmail.com>
 <YYrg870zccL13+Mk@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYrg870zccL13+Mk@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 09, 2021 at 09:58:27PM +0100, Andrew Lunn wrote:
> On Tue, Nov 09, 2021 at 03:26:04AM +0100, Ansuel Smith wrote:
> > Rename NETDEV trigger enum modes to a more simbolic name and move them
> 
> symbolic. Randy is slipping :-)
> 
> > in leds.h to make them accessible by any user.
> 
> any user? I would be more specific than that. Other triggers dealing
> with netdev states?
>

Ok will be more specific. A LED driver require to explicitly support the
trigger to run in hardware mode. The LED driver will take the
trigger_data and elaborate his struct to parse all the option
(blink_mode bitmap, interval)

So the user would be a LED driver that adds support for that specific
trigger. That is also the reason we need to export them.

> > +++ b/include/linux/leds.h
> > @@ -548,6 +548,13 @@ static inline void *led_get_trigger_data(struct led_classdev *led_cdev)
> >  
> >  #endif /* CONFIG_LEDS_TRIGGERS */
> >  
> > +/* Trigger specific enum */
> 
> You probably want netdev in the comment above. Things could get
> interesting if other ledtrig-*.c started using them.
> 
> > +enum led_trigger_netdev_modes {
> > +	TRIGGER_NETDEV_LINK,
> > +	TRIGGER_NETDEV_TX,
> > +	TRIGGER_NETDEV_RX,
> > +};
> > +
> >  /* Trigger specific functions */
> >  #ifdef CONFIG_LEDS_TRIGGER_DISK
> >  void ledtrig_disk_activity(bool write);
> > -- 
> > 2.32.0
> > 

-- 
	Ansuel
