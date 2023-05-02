Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 028566F47E1
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 18:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234669AbjEBQAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 12:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234661AbjEBQAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 12:00:36 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A36E40F7;
        Tue,  2 May 2023 09:00:33 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-3062c1e7df8so1815260f8f.1;
        Tue, 02 May 2023 09:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683043232; x=1685635232;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=k2Qjj4J2QVS6E2WwvS7hIj33LnIvaIzNxIftN5wfh5k=;
        b=B5tpiBn1yYsDx6uA2yL6fh/eKiWy7z1jl57c/Y/LBE+sMmdW/sxsuYXzTnLN1xAhUf
         aI8haoVSdQofqR8wCoHrVisw+ejVRZoRIkII4AXf9YnGJ9nso5oFESEKjfXtAxeM48Cq
         KQhB4Kb6Xt3trALiZSZUDJpS1T0LvKyNkEOLnoYD8BUMyPrLS96wWe9b5EXzAXamNhEz
         2x7b3GswjbkK6g5ouwND4PLtZV4oiG/DiuSu2vfBhlRlZDZ6PT+r/nB0FjTUsC2UJ9Ws
         864RwLoGZLVJJ3lFAlAoO831G56km3Y/LZe2B1gLy/lBzj0Elbfw9DvXWXe6he8mKVrH
         1xqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683043232; x=1685635232;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k2Qjj4J2QVS6E2WwvS7hIj33LnIvaIzNxIftN5wfh5k=;
        b=lwyV0e0ZX4X6qCEh2kWYmh5Y0j+GFW/dRFC6givjj02XRBVGv5PM2fEYYSnRLRvsD8
         /PBJR2s70OPaU7tTNKc5xlglPmJ1VrNmeB8vfFXvG1T7iFK+vR+PY1HDF1xCpNSDeMoR
         DX4y0D8n4QjrR4/MIJsF6VrsE17hHIddIKoWgt9MPSWc4Q6brUBURuW+52c4ygNuvIgs
         qvfYSdw1n3SSFlV6AL++DsoYYFYk9S4TI8pJ8f6wxz+htXnfTJ88o3MPsgevydwvgWp2
         E1K0/mJEmlBfr77BITliUIRLpE8UrnQgEn4KNb4o0Aho2PsFCDk/iEeP9sOAENAuQmoU
         WZWQ==
X-Gm-Message-State: AC+VfDxu1UhPS+VDdnfS55zZcWg6LyBtZIueoDeFmWcRJTxmuPNFMV+g
        eI6RUVArKuJ737OQHtnNciA=
X-Google-Smtp-Source: ACHHUZ6s1EAJEBgbHny09eQlPTJ+1OymgLdTQ2UByJxCsNR8mRXDrVDy5fn0HmL6hBnELTLmvUtf8Q==
X-Received: by 2002:a5d:4c8c:0:b0:306:2a46:4b11 with SMTP id z12-20020a5d4c8c000000b003062a464b11mr6178283wrs.43.1683043231975;
        Tue, 02 May 2023 09:00:31 -0700 (PDT)
Received: from Ansuel-xps. ([176.201.39.129])
        by smtp.gmail.com with ESMTPSA id o17-20020a5d4751000000b003063a92bbf5sm1297780wrs.70.2023.05.02.09.00.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 09:00:31 -0700 (PDT)
Message-ID: <6451339f.5d0a0220.88ec5.8829@mx.google.com>
X-Google-Original-Message-ID: <ZFEzncaVV/MqzQ69@Ansuel-xps.>
Date:   Tue, 2 May 2023 18:00:29 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        Lee Jones <lee@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 08/11] leds: trigger: netdev: add support for LED hw
 control
References: <20230427001541.18704-1-ansuelsmth@gmail.com>
 <20230427001541.18704-9-ansuelsmth@gmail.com>
 <d2c86cf0-d57f-4358-9765-3983a145e1ab@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2c86cf0-d57f-4358-9765-3983a145e1ab@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 30, 2023 at 07:55:13PM +0200, Andrew Lunn wrote:
> On Thu, Apr 27, 2023 at 02:15:38AM +0200, Christian Marangi wrote:
> > Add support for LED hw control for the netdev trigger.
> > 
> > The trigger on calling set_baseline_state to configure a new mode, will
> > do various check to verify if hw control can be used for the requested
> > mode in the validate_requested_mode() function.
> > 
> > It will first check if the LED driver supports hw control for the netdev
> > trigger, then will check if the requested mode are in the trigger mode
> > mask and finally will call hw_control_set() to apply the requested mode.
> > 
> > To use such mode, interval MUST be set to the default value and net_dev
> > MUST be empty. If one of these 2 value are not valid, hw control will
> > never be used and normal software fallback is used.
> > 
> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > ---
> >  drivers/leds/trigger/ledtrig-netdev.c | 52 +++++++++++++++++++++++++++
> >  1 file changed, 52 insertions(+)
> > 
> > diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
> > index 8cd876647a27..61bc19fd0c7a 100644
> > --- a/drivers/leds/trigger/ledtrig-netdev.c
> > +++ b/drivers/leds/trigger/ledtrig-netdev.c
> > @@ -68,6 +68,13 @@ static void set_baseline_state(struct led_netdev_data *trigger_data)
> >  	int current_brightness;
> >  	struct led_classdev *led_cdev = trigger_data->led_cdev;
> >  
> > +	/* Already validated, hw control is possible with the requested mode */
> > +	if (trigger_data->hw_control) {
> > +		led_cdev->hw_control_set(led_cdev, trigger_data->mode);
> > +
> > +		return;
> > +	}
> > +
> >  	current_brightness = led_cdev->brightness;
> >  	if (current_brightness)
> >  		led_cdev->blink_brightness = current_brightness;
> > @@ -95,6 +102,51 @@ static void set_baseline_state(struct led_netdev_data *trigger_data)
> >  static int validate_requested_mode(struct led_netdev_data *trigger_data,
> >  				   unsigned long mode, bool *can_use_hw_control)
> >  {
> > +	unsigned int interval = atomic_read(&trigger_data->interval);
> > +	unsigned long hw_supported_mode, hw_mode = 0, sw_mode = 0;
> > +	struct led_classdev *led_cdev = trigger_data->led_cdev;
> > +	unsigned long default_interval = msecs_to_jiffies(50);
> > +	bool force_sw = false;
> > +	int i, ret;
> > +
> > +	hw_supported_mode = led_cdev->trigger_supported_flags_mask;
> > +
> 
> > +		if (interval == default_interval && !trigger_data->net_dev &&
> > +		    !force_sw && test_bit(i, &hw_supported_mode))
> > +			set_bit(i, &hw_mode);
> > +		else
> > +			set_bit(i, &sw_mode);
> > +	}
> > +
> 
> > +	/* Check if the requested mode is supported */
> > +	ret = led_cdev->hw_control_is_supported(led_cdev, hw_mode);
> > +	if (ret)
> > +		return ret;
> 
> Hi Christian
> 
> What is the purpose of led_cdev->trigger_supported_flags_mask? I don't
> see why it is needed when you are also going to ask the PHY if it can
> support the specific blink pattern the user is requesting.

The idea is to have a place where a trigger can quickly check the single
mode supported before the entire mode map is validated, but I understand
that this can totally be dropped with some extra code from both trigger
and LED driver.

While refactoring the netdev triger mode validation I notice it was very
handy and simplified the check logic having a mask of the single mode
supported. But this might be not needed for now and we can think of a
better approach later when we will introduce hardware only modes.

> 
> The problem i have with the Marvell PHY, and other PHYs i've looked at
> datasheets for, is that hardware does not work like this. It has a
> collection of blinking modes, which are a mixture of link speeds, rx
> activity, and tx activity. It supports just a subset of all
> possibilities.
> 
> I think this function can be simplified. Simply ask the LED via
> hw_control_is_supported() does it support this mode. If yes, offload
> it, if not use software blinking.

Yep, I will consider dropping it to slim this series even further.

> 
>     Andrew

-- 
	Ansuel
