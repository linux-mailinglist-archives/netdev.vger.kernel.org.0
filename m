Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1943F31CEA3
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 18:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbhBPRGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 12:06:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbhBPRGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 12:06:10 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C545DC061574
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 09:05:29 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id 189so6525502pfy.6
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 09:05:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=b38rn9MQQd84lqiSfFRnJGNbd7oukI55cI5dqQ1W5nQ=;
        b=ezcJzZ/CRBaMfoRymmQ+4tw6o3bo8IATDp5CvJk1+o3a91wdJ9DGMqqxtMUlfoMsjf
         lYmPO0YR+LYFmFkGKI4P0gQDoZULQtcyn+I/+3qOzdE6zO9C8eNtQrEhR7PUT3WLg7gK
         /Xf8wju2weTCWmEDl7vQCs8kL/yR86TgPUul1sElooO9mawylN2qrRELg41lzXr3UB/3
         KENcVSJoBWYhrlttTHG+cgHwSp8MOg+FGzB2oAO+MGYQJoIHD/vWhgPrw2dSwbO0REia
         wnJ3y8mc8UJO9tBxMBqBkSSWe2HsTlA6EUegU1gljRtzzsZTU28rszejb3NHG0AQ+le8
         t1hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b38rn9MQQd84lqiSfFRnJGNbd7oukI55cI5dqQ1W5nQ=;
        b=L50DA6Tiufpc6DMW8PH8ssaz38P5M0QJ8bn07hjfrLSFCmjaeiCysnTwpA2mnbPkoR
         e2IlJi9IJf0O+sRxrBVqJAvFC/zgcjK1FLLyzA9rrfiMzdtE9lVan7OiZ6GzY5/mMdbC
         iOPrP7hCjXaWDygHEUMD3ZFNUkHZBmc7g9F0jvxrCUhsWgWmO8U33x9f5fiip3DaM9/s
         rfGYzlHpfputHqI4dd21e1+3bAmvA7M+NatZzfeUZ1jN3Q2IwffVW2bLMChQXrCr2tpg
         sYdpB9KNzTQoONrnyEJWo3TjQ7TfU1uEz3hZvcNfZxZ6SaAtAOmgpW84zih3/VxuprEO
         mT+g==
X-Gm-Message-State: AOAM533YJ7zc+mRXKbZ1tHupOBwg+z7tMeq3/Qx23KzUJLSKpQ7Lv3lW
        5UjBiE13DjkJqQWXlhuFDDs5+I/T4So=
X-Google-Smtp-Source: ABdhPJyp0Lqgd0SisgkJMlA0SA4psHozCD8fBGWemm6TDKIkMhIuYg4W1frXU54ogkBfHEmHyRaFgA==
X-Received: by 2002:a63:f614:: with SMTP id m20mr20019476pgh.200.1613495128764;
        Tue, 16 Feb 2021 09:05:28 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u142sm21476799pfc.37.2021.02.16.09.05.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Feb 2021 09:05:28 -0800 (PST)
Subject: Re: [PATCH net-next v2 2/2] net: phy: broadcom: Do not modify LED
 configuration for SFP module PHYs
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Robert Hancock <robert.hancock@calian.com>
Cc:     "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20210213021840.2646187-1-robert.hancock@calian.com>
 <20210213021840.2646187-3-robert.hancock@calian.com>
 <20210213104537.GP1463@shell.armlinux.org.uk>
 <fc3b75ed82a38b5fbf216893f52b3b24531db148.camel@calian.com>
 <20210216170414.GC1463@shell.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e4033b3b-afb2-e89a-b852-a972c3d1b0cd@gmail.com>
Date:   Tue, 16 Feb 2021 09:05:26 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210216170414.GC1463@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/16/2021 9:04 AM, Russell King - ARM Linux admin wrote:
> On Tue, Feb 16, 2021 at 04:52:13PM +0000, Robert Hancock wrote:
>> On Sat, 2021-02-13 at 10:45 +0000, Russell King - ARM Linux admin wrote:
>>> On Fri, Feb 12, 2021 at 08:18:40PM -0600, Robert Hancock wrote:
>>>> +	if (!phydev->sfp_bus &&
>>>> +	    (!phydev->attached_dev || !phydev->attached_dev->sfp_bus)) {
>>>
>>> First, do we want this to be repeated in every driver?
>>>
>>> Second, are you sure this is the correct condition to be using for
>>> this?  phydev->sfp_bus is non-NULL when _this_ PHY has a SFP bus
>>> connected to its fibre side, it will never be set for a PHY on a
>>> SFP. The fact that it is non-NULL or NULL shouldn't have a bearing
>>> on whether we configure the LED register.
>>
>> I think you're correct, the phydev->sfp_bus portion is probably not useful and
>> could be dropped. What we're really concerned about is whether this PHY is on
>> an SFP module or not. I'm not sure that a module-specific quirk makes sense
>> here since there are probably other models which have a similar design where
>> the LED outputs from the PHY are used for other purposes, and there's really no
>> benefit to playing with the LED outputs on SFP modules in any case, so it would
>> be safer to skip the LED reconfiguration for anything on an SFP. So we could
>> either have a condition for "!phydev->attached_dev || !phydev->attached_dev-
>>> sfp_bus" here and anywhere else that needs a similar check, or we do something
>> different, like have a specific flag to indicate that this PHY is on an SFP
>> module? What do people think is best here?
> 
> I don't think relying on phydev->attached_dev in any way is a good
> idea, and I suspect a flag is going to be way better. One of the
> problems is that phydev->dev_flags are PHY specific at the moment.
> Not sure if we can do anything about that.

I have some ideas on how we can improve that and hope to be able to post
something by the end of the week.

> 
> In the short term, at the very least, I think we should wrap whatever
> test we use in a "phy_on_sfp(phydev)" helper so that we have a standard
> helper for this.
> 

Sounds reasonable.
-- 
Florian
