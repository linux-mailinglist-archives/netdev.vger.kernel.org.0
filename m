Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE7754B5FB
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 18:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243376AbiFNQZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 12:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240192AbiFNQZl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 12:25:41 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6F82980F
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 09:25:41 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id u37so592758pfg.3
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 09:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=JdvVTYP0ACaM6uOt685kAxxm8vkE7q+IZ8GZAXhWSoc=;
        b=mEHDpKEdZxJ+nmAGU+0V8BH+Y+MxGyZNrEiaqrJLn4iD3Ql5mhxGqN5lwFCHq/Ss9h
         K52vybpH9aIlOc/LFbGnby1O0XP5ZXJOqyJHnbD83UDLBgcVpNqJTFpW1F1kG/X+usaO
         NOaBZ/LmGw8otMk3UJCuZRSl9BOhaAZR6AZs/W1C+Copl+yT3uk6srL6N4bDbugx9lQu
         2x87zgY4i9d6zPE4Buclt5GfXMT3PdL01441oxSfgsIJoctf7IHlppR5O8kZIrVsUmo8
         MIgaGo9B6h3BDiriOS+JWP2IQwD8bSFYSesRsp4qAnZoJqXzFW4yP5rgdJOw6qbWZ/NN
         I4gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JdvVTYP0ACaM6uOt685kAxxm8vkE7q+IZ8GZAXhWSoc=;
        b=d3Dse9CaU9fWJ0+EnzQMCZinCQk3eUMt06RniWIgsB44WXuX737aDaM3Z/RZN3AY90
         /9qJt6noocRFp3zA3aFb4Gf/mEAIFkURChWf+KmNqdiqgCY4MMQEj65IK5v+/5Mjs2tq
         3zvq3/M7S8A3uO36w8lvFF9ZRsIVb7Ipv4Hkgl+uhW6WDxi+g3CYF+SsHgMnWTPP1tgG
         cNROTVoIeG98QoP9mHxbIH5H4+PkVX0NuGzZQj00xJPTi8FdiN1uDvGv28EeJIhXDdSh
         HhvHgZB+Swp0DMsfGW5bws1P1dcKyBDjlMgX5C1S6rq5rEPZtfs+x+nUxy2EBUAtJbVV
         psJQ==
X-Gm-Message-State: AOAM532YD1eGXCOPlxW4Fa340WdQjKuWWiiGFcvznqaLCO1GxQuaDa6w
        xePmF38t7cqpg5UjUCE9ZCU=
X-Google-Smtp-Source: ABdhPJzGthOYJxezu152S2P/BloHfPku75xIG9eGL1hSLgDJT4lNPvZ7K9Cy1hPPam6a5FwBnx11cA==
X-Received: by 2002:a63:7c4e:0:b0:380:8ae9:c975 with SMTP id l14-20020a637c4e000000b003808ae9c975mr5306668pgn.25.1655223940551;
        Tue, 14 Jun 2022 09:25:40 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ep11-20020a17090ae64b00b001eab4d6de9esm3190982pjb.3.2022.06.14.09.25.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 09:25:40 -0700 (PDT)
Message-ID: <81e43c3f-a10e-3167-a868-61794bd66466@gmail.com>
Date:   Tue, 14 Jun 2022 09:25:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH net-next v7 3/3] net: phy: Add support for 1PPS out and
 external timestamps
Content-Language: en-US
To:     Jonathan Lemon <jonathan.lemon@gmail.com>, netdev@vger.kernel.org
Cc:     kernel-team@fb.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Lasse Johnsen <l@ssejohnsen.me>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>
References: <20220614050810.54425-1-jonathan.lemon@gmail.com>
 <20220614050810.54425-4-jonathan.lemon@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220614050810.54425-4-jonathan.lemon@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/13/22 22:08, Jonathan Lemon wrote:
> The perout function is used to generate a 1PPS signal, synchronized
> to the PHC.  This is accomplished by a using the hardware oneshot
> functionality, which is reset by a timer.
> 
> The external timestamp function is set up for a 1PPS input pulse,
> and uses a timer to poll for temestamps.
> 
> Both functions use the SYNC_OUT/SYNC_IN1 pin, so cannot run
> simultaneously.
> 
> Co-developed-by: Lasse Johnsen <l@ssejohnsen.me>
> Signed-off-by: Lasse Johnsen <l@ssejohnsen.me>
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> Acked-by: Richard Cochran <richardcochran@gmail.com>

Not sure whether we could apply just patch 1 and 2 and leave this one 
aside as I do see a few things that IMHO would be worth updating before 
merging this one, more on the stylistic aspect though, so you be the judge.

> ---

[snip]


> +static int bcm_ptp_cancel_func(struct bcm_ptp_private *priv)
> +{
> +	if (priv->pin_active) {
> +		priv->pin_active = false;
> +		priv->nse_ctrl &= ~(NSE_SYNC_OUT_MASK | NSE_SYNC1_FRAMESYNC |
> +				    NSE_CAPTURE_EN);
> +		bcm_phy_write_exp(priv->phydev, NSE_CTRL, priv->nse_ctrl);
> +		cancel_delayed_work_sync(&priv->pin_work);
> +	}

Missing newline and you should consider reducing the indentation.

> +	return 0;
> +}
> +
> +static void bcm_ptp_perout_work(struct work_struct *pin_work)
> +{
> +	struct bcm_ptp_private *priv =
> +		container_of(pin_work, struct bcm_ptp_private, pin_work.work);
> +	struct phy_device *phydev = priv->phydev;
> +	struct timespec64 ts;
> +	u64 ns, next;
> +	u16 ctrl;
> +
> +	mutex_lock(&priv->mutex);
> +
> +	/* no longer running */
> +	if (!priv->pin_active) {
> +		mutex_unlock(&priv->mutex);
> +		return;
> +	}

[snip]

> +	if (!pulse)
> +		return -EINVAL;
> +
> +	if (pulse > period)
> +		return -EINVAL;
> +
> +	if (pulse > BCM_MAX_PULSE_8NS)
> +		return -EINVAL;

Consider combining all of these into a single line?
-- 
Florian
