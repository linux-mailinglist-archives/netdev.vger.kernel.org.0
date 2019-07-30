Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21BE67A2B6
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 10:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730763AbfG3IDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 04:03:01 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35658 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729810AbfG3IDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 04:03:01 -0400
Received: by mail-pg1-f196.google.com with SMTP id s1so23331058pgr.2;
        Tue, 30 Jul 2019 01:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=VChiJaSG46ybZALSFOV8/YPDL/6pdPPKzTJ+KlFjbec=;
        b=JXtXAVMkkw5n/mrWdLnavDkNKc9V87C4Koawc720nJ2ynLsSg+yvLSEpfiVYghyOzj
         s2y64EygboGQCSPzeB7ai/5a1Vcc0xsMuuGZka9xo3fIEvYDsvLpBPj3G3WdNK91oDYP
         Iw7MPSnE46V7MKFt5ziBNtVOXoONAHNK6S4YC0WEmzqbKM2PZLfezS0v2nYg6BHjYQ3R
         hatIE3AU+bAR25ExlwAYeHX5/y5HriF19R3sIwwbb9dxZMsCnfszGPq1Ch4M1EgsbnDm
         MuCXtcyxbkN87YKJrAjUoXfYzbGUYq8wVHqzNPcPkvvVPaTz7q5IZfABOq3tT+rOu3bb
         OfzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=VChiJaSG46ybZALSFOV8/YPDL/6pdPPKzTJ+KlFjbec=;
        b=MqvMnb/3Dae2yrBG+Hz7/lLGOVxtv+86ApgvdPzvQ9o+Uduelg5VPGwxEa++Sh36xP
         PY0zz39cf8VMJIVqbhXXXZDAZhFN3284PP/b/R3i9OkLCnLeHAzy6sGTTs3Y9ZY8+9P9
         MSzO3hyHhj2JkGudj96vCVzIZIImO6iDXSjsEj34uUBEDnzB+23P9aORnbBAiyFW8wx3
         ZDAFqJxKO6A8VsfQYjoc7Qd3lCgVf4261uv5ItlbC/GYeXVDhn8kmWGIq7/AKkJ6z/d1
         DZB72ld5oi6om0d8VXmQzXbEs7Bt/Wqi8PB0Zwrn6QR5du5LFDyGGC0Hhh5xpnHV33p3
         i5yQ==
X-Gm-Message-State: APjAAAVdjNRGAxjhz5udOqj/MMfh7QkmnxWjqz5gIS6jdESD7rIYDD3T
        MQxV7YtV3cuSDRknQAGS8AoRX7PpBqM=
X-Google-Smtp-Source: APXvYqzPNNwXVdfbBcDk92EEN5saUEUUJ8JLGm3xhnsvnw+wFq2WeTaR3y51UIFLTSSPf8PjTGxU2A==
X-Received: by 2002:a65:4948:: with SMTP id q8mr49355881pgs.214.1564473780195;
        Tue, 30 Jul 2019 01:03:00 -0700 (PDT)
Received: from ?IPv6:2402:f000:4:72:808::177e? ([2402:f000:4:72:808::177e])
        by smtp.gmail.com with ESMTPSA id v184sm59805009pgd.34.2019.07.30.01.02.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 01:02:59 -0700 (PDT)
Subject: Re: [PATCH] net: phy: phy_led_triggers: Fix a possible null-pointer
 dereference in phy_led_trigger_change_speed()
To:     David Miller <davem@davemloft.net>, andrew@lunn.ch
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190729134553.GC4110@lunn.ch>
 <f603f3c3-f7c9-8dff-5f30-74174282819c@gmail.com>
 <20190730033229.GA20628@lunn.ch>
 <20190729.204113.316505378355498068.davem@davemloft.net>
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Message-ID: <c41475ec-b418-7874-9150-3a6eef125365@gmail.com>
Date:   Tue, 30 Jul 2019 16:03:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190729.204113.316505378355498068.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/7/30 11:41, David Miller wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> Date: Tue, 30 Jul 2019 05:32:29 +0200
>
>> On Tue, Jul 30, 2019 at 10:25:36AM +0800, Jia-Ju Bai wrote:
>>>
>>> On 2019/7/29 21:45, Andrew Lunn wrote:
>>>> On Mon, Jul 29, 2019 at 05:24:24PM +0800, Jia-Ju Bai wrote:
>>>>> In phy_led_trigger_change_speed(), there is an if statement on line 48
>>>>> to check whether phy->last_triggered is NULL:
>>>>>      if (!phy->last_triggered)
>>>>>
>>>>> When phy->last_triggered is NULL, it is used on line 52:
>>>>>      led_trigger_event(&phy->last_triggered->trigger, LED_OFF);
>>>>>
>>>>> Thus, a possible null-pointer dereference may occur.
>>>>>
>>>>> To fix this bug, led_trigger_event(&phy->last_triggered->trigger,
>>>>> LED_OFF) is called when phy->last_triggered is not NULL.
>>>>>
>>>>> This bug is found by a static analysis tool STCheck written by us.
>>>> Who is 'us'?
>>> Me and my colleague...
>> Well, we can leave it very vague, giving no idea who 'us' is. But
>> often you want to name the company behind it, or the university, or
>> the sponsor, etc.
> I agree, if you are going to mention that there is a tool you should be
> clear exactly who and what organization are behind it

Thanks for the advice.
I will add my organization in the patch.


Best wishes,
Jia-Ju Bai
