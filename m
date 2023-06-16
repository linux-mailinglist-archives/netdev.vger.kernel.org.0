Return-Path: <netdev+bounces-11625-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14348733C22
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 00:14:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 43E0C2818BD
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:14:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BD836FD9;
	Fri, 16 Jun 2023 22:14:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270566FD1
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 22:14:23 +0000 (UTC)
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03AC81FD7;
	Fri, 16 Jun 2023 15:14:22 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-3f8c65020dfso11152955e9.2;
        Fri, 16 Jun 2023 15:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686953660; x=1689545660;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=tT6ObQCSQqj+wxVkfoL0mcp4+39BD0tg2ud99zqanQk=;
        b=jFtHLeHp/x6+zDJx8LT5tFnxLhYrna3jSCJKiSFKkveDkm+FDvcPIXQiAgr5DdLwX+
         6uow5DqJUxee2fzm98kcfgYXF/G4S7MZrTSXylsga+4ruWtaJ88Vgt51BnAh6NdlyjF2
         ADKUmyHwzWv0Hk1pP2Ry1+IeJSplsPD63l0lzD0GD9kUkfGZq47ooQpP47wVsMckfB4S
         z4CKCuTTr1Z7wzSsxS4He67IJhZBLqT8GaWwAHpvsYPT6LVUJqM/+zPN09nECr+E0jBt
         AKaZ5iAwdeqkBiwAktpKEtFFrrtFGbRugVC+p8R942K/eY4klFRC3jX0SX39W7o+VrCO
         hxPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686953660; x=1689545660;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tT6ObQCSQqj+wxVkfoL0mcp4+39BD0tg2ud99zqanQk=;
        b=H54K552jg5vQ8wWi9neR4lDqQVoK7lnOhvO1gqesr6eL7ZVYPfSk2XuUvjpD1AYZa9
         1YJcjhzrJ7AhFlJutaDxl0dbuxaZChVciqT/HLvyXdFMj9rBCGjiRR6HIWptUWoYU4XE
         gLdFYYXsBh0ayfd5Ut/XQiC/XqZpfptL+RTLwgNpI+Ie8QnEVb9rajTY0rzeK4Dl6zkD
         lZoaRzCoj/+cLnJP9A8O3HzMEr4O8tLPviVWL7kIetK15cy+dOH74oxGfM31RhKiDhLg
         0sdLSCsF7Dlf/v49dAf32+oCXLGnLenRV+A8cN/t0f0ivfwZjiJ8Rgax/ALhvcwIlLNm
         yYlw==
X-Gm-Message-State: AC+VfDxnpreHHtkODuewhhr+hAAWsgYwQJ8kZEzF4YeaW2W+Wd9IOchs
	pYCKSKHi2uDcgVVzpMeGuxI=
X-Google-Smtp-Source: ACHHUZ443J3rJAiWjyHbG8G9CKQv+opL+1Z/scP/JsH3FhFXwZC/8XLMBg6O2u920MbvcbuIrH4mwQ==
X-Received: by 2002:a5d:6ad1:0:b0:2f5:d3d7:7af4 with SMTP id u17-20020a5d6ad1000000b002f5d3d77af4mr2290949wrw.63.1686953660049;
        Fri, 16 Jun 2023 15:14:20 -0700 (PDT)
Received: from Ansuel-xps. (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.gmail.com with ESMTPSA id u9-20020a5d4349000000b003079c402762sm24550729wrr.19.2023.06.16.15.14.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 15:14:19 -0700 (PDT)
Message-ID: <648cdebb.5d0a0220.be7f8.a096@mx.google.com>
X-Google-Original-Message-ID: <ZIxI6Eo0q8sbJMDs@Ansuel-xps.>
Date: Fri, 16 Jun 2023 13:35:04 +0200
From: Christian Marangi <ansuelsmth@gmail.com>
To: Kalle Valo <kvalo@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-kernel@vger.kernel.org, ath10k@lists.infradead.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Sebastian Gottschall <s.gottschall@dd-wrt.com>,
	Steve deRosier <derosier@cal-sierra.com>,
	Stefan Lippers-Hollmann <s.l-h@gmx.de>
Subject: Re: [PATCH v14] ath10k: add LED and GPIO controlling support for
 various chipsets
References: <20230611080505.17393-1-ansuelsmth@gmail.com>
 <878rcjbaqs.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878rcjbaqs.fsf@kernel.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 08:03:23PM +0300, Kalle Valo wrote:
> Christian Marangi <ansuelsmth@gmail.com> writes:
> 
> > From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
> >
> > Adds LED and GPIO Control support for 988x, 9887, 9888, 99x0, 9984
> > based chipsets with on chipset connected led's using WMI Firmware API.
> > The LED device will get available named as "ath10k-phyX" at sysfs and
> > can be controlled with various triggers.
> > Adds also debugfs interface for gpio control.
> >
> > Signed-off-by: Sebastian Gottschall <s.gottschall@dd-wrt.com>
> > Reviewed-by: Steve deRosier <derosier@cal-sierra.com>
> > [kvalo: major reorg and cleanup]
> > Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> > [ansuel: rebase and small cleanup]
> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > Tested-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>
> > ---
> >
> > Hi,
> > this is a very old patch from 2018 that somehow was talked till 2020
> > with Kavlo asked to rebase and resubmit and nobody did.
> > So here we are in 2023 with me trying to finally have this upstream.
> >
> > A summarize of the situation.
> > - The patch is from years in OpenWRT. Used by anything that has ath10k
> >   card and a LED connected.
> > - This patch is also used by the fw variant from Candela Tech with no
> >   problem reported.
> > - It was pointed out that this caused some problem with ipq4019 SoC
> >   but the problem was actually caused by a different bug related to
> >   interrupts.
> >
> > I honestly hope we can have this feature merged since it's really
> > funny to have something that was so near merge and jet still not
> > present and with devices not supporting this simple but useful
> > feature.
> 
> Indeed, we should finally get this in. Thanks for working on it.
> 
> I did some minor changes to the patch, they are in my pending branch:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=686464864538158f22842dc49eddea6fa50e59c1
> 
> My comments below, please review my changes. No need to resend because
> of these.
>

Hi,
very happy this is going further.

> > --- a/drivers/net/wireless/ath/ath10k/Kconfig
> > +++ b/drivers/net/wireless/ath/ath10k/Kconfig
> > @@ -67,6 +67,23 @@ config ATH10K_DEBUGFS
> >  
> >  	  If unsure, say Y to make it easier to debug problems.
> >  
> > +config ATH10K_LEDS
> > +	bool "Atheros ath10k LED support"
> > +	depends on ATH10K
> > +	select MAC80211_LEDS
> > +	select LEDS_CLASS
> > +	select NEW_LEDS
> > +	default y
> > +	help
> > +	  This option enables LEDs support for chipset LED pins.
> > +	  Each pin is connected via GPIO and can be controlled using
> > +	  WMI Firmware API.
> > +
> > +	  The LED device will get available named as "ath10k-phyX" at sysfs and
> > +    	  can be controlled with various triggers.
> > +
> > +	  Say Y, if you have LED pins connected to the ath10k wireless card.
> 
> I'm not sure anymore if we should ask anything from the user, better to
> enable automatically if LED support is enabled in the kernel. So I
> simplified this to:
> 
> config ATH10K_LEDS
> 	bool
> 	depends on ATH10K
> 	depends on LEDS_CLASS=y || LEDS_CLASS=MAC80211
> 	default y
> 
> This follows what mt76 does:
> 
> config MT76_LEDS
> 	bool
> 	depends on MT76_CORE
> 	depends on LEDS_CLASS=y || MT76_CORE=LEDS_CLASS
> 	default y
> 

I remember there was the same discussion in a previous series. OK for me
for making this by default, only concern is any buildbot error (if any)

Anyway OK for the change.

> > @@ -65,6 +66,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
> >  		.dev_id = QCA988X_2_0_DEVICE_ID,
> >  		.bus = ATH10K_BUS_PCI,
> >  		.name = "qca988x hw2.0",
> > +		.led_pin = 1,
> >  		.patch_load_addr = QCA988X_HW_2_0_PATCH_LOAD_ADDR,
> >  		.uart_pin = 7,
> >  		.cc_wraparound_type = ATH10K_HW_CC_WRAP_SHIFTED_ALL,
> 
> I prefer following the field order from struct ath10k_hw_params
> declaration and also setting fields explicitly to zero (even though
> there are gaps still) so I changed that for every entry.
> 

Thanks for the change, np for me.

> > +int ath10k_leds_register(struct ath10k *ar)
> > +{
> > +	int ret;
> > +
> > +	if (ar->hw_params.led_pin == 0)
> > +		/* leds not supported */
> > +		return 0;
> > +
> > +	snprintf(ar->leds.label, sizeof(ar->leds.label), "ath10k-%s",
> > +		 wiphy_name(ar->hw->wiphy));
> > +	ar->leds.wifi_led.active_low = 1;
> > +	ar->leds.wifi_led.gpio = ar->hw_params.led_pin;
> > +	ar->leds.wifi_led.name = ar->leds.label;
> > +	ar->leds.wifi_led.default_state = LEDS_GPIO_DEFSTATE_KEEP;
> > +
> > +	ar->leds.cdev.name = ar->leds.label;
> > +	ar->leds.cdev.brightness_set_blocking = ath10k_leds_set_brightness_blocking;
> > +
> > +	/* FIXME: this assignment doesn't make sense as it's NULL, remove it? */
> > +	ar->leds.cdev.default_trigger = ar->leds.wifi_led.default_trigger;
> 
> But what to do with this FIXME?
>

It was pushed by you in v13.

I could be wrong but your idea was to prepare for future support of
other patch that would set the default_trigger to the mac80211 tpt.

We might got both confused by default_trigger and default_state.
default_trigger is actually never set and is NULL (actually it's 0)

We have other 2 patch that adds tpt rates for the mac80211 LED trigger
and set this trigger as the default one but honestly I would chose a
different implementation than hardcoding everything.

If it's ok for you, I would drop the comment and the default_trigger and
I will send a follow-up patch to this adding DT support by using
led_classdev_register_ext and defining init_data.
(and this indirectly would permit better LED naming and defining of
default-trigger in DT)

Also ideally I will also send a patch for default_state following
standard LED implementation. (to set default_state in DT)

I would prefer this approach as the LED patch already took way too much
time and I think it's better to merge this initial version and then
improve it.

-- 
	Ansuel

