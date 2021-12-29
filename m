Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A28D481528
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 17:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240840AbhL2QkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 11:40:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240794AbhL2QkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 11:40:10 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F24C061574
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 08:40:10 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id 196so19149659pfw.10
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 08:40:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=jin73F7ZfhBvwpBkId2yd1nLKoteULf0CVHPl8kI8BA=;
        b=pGzsJ8oE903rOgpFVDJPo3IMvWm0gP+NZ3VrXzJ8pUqB1RLRYQdfWVLS7YYEGtI9V6
         7MiOmtDyG5/lKDyCwotwCT5aeCpdbSP/M7gAO+IwsEhRCelg1WeYYOuSVqHFhnCaw/my
         bavLHCnuFcS4sBdJPXea73YoCRqVaR/6P9Rj/hnTyFP4SQWmU7JfbRE1NvX3AR4GAPjS
         SyekDfQ15B5ivro8sYPpIVF6+0E0roCydqJOwvQKG4HTDjbmhzrp6aJCRHaRITiKfV56
         cdIAwjZluGWO89hq0g1gB8EuI82olbOD8uGqMgUJZzpqHhZnOtZZjp7TItO72cjc5/G3
         NSig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jin73F7ZfhBvwpBkId2yd1nLKoteULf0CVHPl8kI8BA=;
        b=OMQ30Vx7heJvqKUu23v4vSWH0KtrFjTKaVxprv13lEQanG6WRHky7SBoF5uC6xmomc
         BMiPTQRn1Q7+9THUB8JryX+7Cv3hB5mPfnoI97Cqnscj4TBC14cZnpsycWbQ9XNeVrdZ
         1AEMEdyqN03gOXHqVW8W3yGhTMLjr9Rp379qx6YeR+BEz+F0ofAzvRt8mTVJxkrgY4Bl
         8VCDP8adjXucWGwln7SPRDwBE9Of2BFuNZPR10WbOFzm5W5/RnFE9hOP5ChfimB319Te
         btv0eptbQQGLbwpbmWmWvXi/Ru+Rl3sv6ova4ZWVmBH95Ec6Uhj7eVk7EYe4F1ams3Ew
         tUeg==
X-Gm-Message-State: AOAM5329fdNyXliqYW0GAZMrv0rf9/BBTWlcsJKyHdS2hL/Zdl8f78IQ
        pXe17v8C9Z3ONE9zuVhbHzA=
X-Google-Smtp-Source: ABdhPJx+pssjN1kAFOZ+uLCHpmfVx3qEF6sOHoHxoKYkeOOwckIr5TNXQFmDukjuGggby3angJ6BTA==
X-Received: by 2002:a63:6942:: with SMTP id e63mr23843737pgc.451.1640796010172;
        Wed, 29 Dec 2021 08:40:10 -0800 (PST)
Received: from [10.230.2.158] ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id f10sm27502351pfj.145.2021.12.29.08.40.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Dec 2021 08:40:09 -0800 (PST)
Message-ID: <097bb80d-a5c5-3884-4ce4-64c9fec1b26a@gmail.com>
Date:   Wed, 29 Dec 2021 08:40:08 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH] net: dsa: bcm_sf2: refactor LED regs access
Content-Language: en-US
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20211228220951.17751-1-zajec5@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211228220951.17751-1-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/28/2021 2:09 PM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> 1. Define more regs. Some switches (e.g. BCM4908) have up to 6 regs.
> 2. Add helper for handling non-lineral port <-> reg mappings.
> 3. Add support for 12 B LED reg blocks on BCM4908 (different layout)
> 
> Complete support for LEDs setup will be implemented once Linux receives
> a proper design & implementation for "hardware" LEDs.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

This looks good for the most part, just one nit below:

> ---
>   drivers/net/dsa/bcm_sf2.c      | 60 +++++++++++++++++++++++++++----
>   drivers/net/dsa/bcm_sf2.h      | 10 ++++++
>   drivers/net/dsa/bcm_sf2_regs.h | 65 +++++++++++++++++++++++++++++++---
>   3 files changed, 125 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
> index 13aa43b5cffd..c2447de9d441 100644
> --- a/drivers/net/dsa/bcm_sf2.c
> +++ b/drivers/net/dsa/bcm_sf2.c
> @@ -62,6 +62,44 @@ static u16 bcm_sf2_reg_rgmii_cntrl(struct bcm_sf2_priv *priv, int port)
>   	return REG_SWITCH_STATUS;
>   }
>   
> +static u16 bcm_sf2_reg_led_base(struct bcm_sf2_priv *priv, int port)
> +{
> +	switch (priv->type) {
> +	case BCM4908_DEVICE_ID:
> +		switch (port) {
> +		case 0:
> +			return REG_LED_0_CNTRL;
> +		case 1:
> +			return REG_LED_1_CNTRL;
> +		case 2:
> +			return REG_LED_2_CNTRL;

Up until that port count, we have a common path, it is only after port > 
2 that we stop having a common path. Only BCM7445 and BCM7278 have two 
external ports, 63138 (and 63148 when that gets added eventually) as 
well as a 4908 have more ports, so I would do something like this:

switch (port) {
case 0:
	return REG_LED_0_CNTRL;
case 1:
	return REG_LED_1_CNTRL;
case 2:
	return REG_LED_2_CNTRL;
default:
	break;
}

if (priv->type == BCM7445_DEVICE_ID || priv->type == BCM7278_DEVICE_ID)
	goto out;

Also, this LED controller is also present in the GENETv5 adapters, so we 
may have some value in writing a common LED framework driver for it at 
some point.

Thanks!
-- 
Florian
