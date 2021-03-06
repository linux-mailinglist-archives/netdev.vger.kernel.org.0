Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F25E32F833
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 05:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhCFE1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 23:27:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbhCFE0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 23:26:49 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 334BFC06175F;
        Fri,  5 Mar 2021 20:26:49 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id kr3-20020a17090b4903b02900c096fc01deso213061pjb.4;
        Fri, 05 Mar 2021 20:26:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=C0fc0z8FwjdECdFL+lTC1saxBB6QAyp/014WA2umBAY=;
        b=DJUmIgPB6QVL8f1DEx3XLfY+Nu1TBOodVQjhORI4QPbPg5LC4hHAyjr5ZUScAnot5n
         IOUCU8cGNY5i48GsQ2r0F6L5CViJnjbSgQur5DNIjdznPkffRuTVUzASPUedqtHEZytj
         Mp+7COo2nu/UPpKjg9QnU4smjxFLT6xlPPR+q6ec3ZFFhxutmx+GDlVix2KHvKIyUxX4
         2qv+gikVKJnEhbBUG8xoJqSIgbFLAOUMMG+ZJby2oOcrMYu8B2eoVUNUVxO2Y0BX1dmU
         86T2whdAPYSqn4GkTH+mKyUCbbg79lCx6CoasDU9vDOoQ7zs4JFI5c7nj+tLRRIyDWUd
         YrRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C0fc0z8FwjdECdFL+lTC1saxBB6QAyp/014WA2umBAY=;
        b=Yzyfb14bKrmfasDEnAOHWPllj4fleyZfK3mGMKaTIN0qc/ondkW8++s1bJDkk76mnY
         Mi6yLNNFxmPmTYQI1PFUuaAEgDf69dDyQ0iK8T2ICUcaKgmrw2xccQAJIJlXoZuhL8ut
         eUK+lvDEtRP4rNfXXRMXjq1EZ8wljdP/FjQAeNS9clwijvOvzvhVyqmjMS5PcnDZj2HI
         vaQVnjgqDX3vez7PxUtsnUxdZpJEOdEtMUD2DD4AZdeg/PXfyaMkN19cjq2ev9ObCHbS
         1t6XUD/VM90oP9i9nehq3qTd7sApLMStJbRwdMiEF9jJv1mVWi6U/JGvqHOPmOJPqT3K
         1igQ==
X-Gm-Message-State: AOAM5314B/a1xS02fJ3DAJekPzX646B0w1brWUB1QGLt2F6SrA00qt7V
        QFeMnEblWZ569Q6WW1EzwQg=
X-Google-Smtp-Source: ABdhPJz4OoiLeNhbNJLVfW/+qy+iekVop9E1alzONPh8qwGHDpn2REE5h98elA8jq8NdWjzwb5EoPQ==
X-Received: by 2002:a17:90a:de90:: with SMTP id n16mr12860466pjv.10.1615004808579;
        Fri, 05 Mar 2021 20:26:48 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id mp1sm3381534pjb.48.2021.03.05.20.26.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Mar 2021 20:26:47 -0800 (PST)
Subject: Re: [PATCH net-next v2 3/3] net: phy: broadcom: Allow BCM54210E to
 configure APD
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <mchan@broadcom.com>,
        "open list:BROADCOM ETHERNET PHY DRIVERS" 
        <bcm-kernel-feedback-list@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>, michael@walle.cc
References: <20210213034632.2420998-1-f.fainelli@gmail.com>
 <20210213034632.2420998-4-f.fainelli@gmail.com>
 <20210213104245.uti4qb2u2r5nblef@skbuf>
 <4e1c1a4c-d276-c850-8e97-16ef1f08dcff@gmail.com>
 <99e28317-e93d-88fa-f43f-d1d072b61292@gmail.com>
 <20210305010845.blqccudijh6ezm6a@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <840bf142-d398-13cd-36a2-a013f6e44b53@gmail.com>
Date:   Fri, 5 Mar 2021 20:26:41 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210305010845.blqccudijh6ezm6a@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/4/2021 5:08 PM, Vladimir Oltean wrote:
> On Tue, Mar 02, 2021 at 07:37:34PM -0800, Florian Fainelli wrote:
>> Took a while but for the 54210E reference board here are the numbers,
>> your mileage will vary depending on the supplies, regulator efficiency
>> and PCB design around the PHY obviously:
>>
>> BMCR.PDOWN:			86.12 mW
>> auto-power down:		77.84 mW
> 
> Quite curious that the APD power is lower than the normal BMCR.PDOWN
> value. As far as my understanding goes, when in APD mode, the PHY even
> wakes up from time to time to send pulses to the link partner?

Auto-power down kicks in when the cable is disconnected. There is
another IDDQ mode that supports energy detection though I am unsure of
when it would be useful for most Linux enabled systems.

> 
>> auto-power-down, DLL disabled:  30.83 mW
> 
> The jump from simple APD to APD with DLL disabled is pretty big.
> Correct me if I'm wrong, but there's an intermediary step which was not
> measured, where the CLK125 is disabled but the internal DLL (Delay
> Locked Loop?) is still enabled. I think powering off the internal DLL
> also implies powering off the CLK125 pin, at least that's how the PHY
> driver treats things at the moment. But we don't know if the huge
> reduction in power is due just to CLK125 or the DLL (it's more likely
> it's due to both, in equal amounts).

Agree, I do not have the break down though.

> 
> Anyway, it's great to have some results which tell us exactly what is
> worthwhile and what isn't. In other news, I've added the BCM5464 to the
> list of PHYs with APD and I didn't see any issues thus far.
> 
>> IDDQ-low power:			 9.85 mW (requires a RESETn toggle)
>> IDDQ with soft recovery:	10.75 mW
>>
>> Interestingly, the 50212E that I am using requires writing the PDOWN bit
>> and only that bit (not a RMW) in order to get in a correct state, both
>> LEDs keep flashing when that happens, fixes coming.
>>
>> When net-next opens back up I will submit patches to support IDDQ with
>> soft recovery since that is clearly much better than the standard power
>> down and it does not require a RESETn toggle.
> 
> Iddq must be the quiescent supply current, isn't it (but in that case,
> I'm a bit confused to not see a value in mA)? Is it an actual operating
> mode (I don't see anything about that mentioned in the BCM5464 sheet)
> and if it is, what is there exactly to support?

You would put the PHY in IDDQ with soft recovery (or ultra low power)
when you are administratively bringing down the network interface (and
its PHY), or when suspending to a low power state where Wake-on-LAN is
not enabled.
-- 
Florian
