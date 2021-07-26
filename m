Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A26D3D6852
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 22:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232877AbhGZUSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 16:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232597AbhGZUSr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 16:18:47 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31463C061757;
        Mon, 26 Jul 2021 13:59:15 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id b128so6150484wmb.4;
        Mon, 26 Jul 2021 13:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=R9+/OkDWq1U3L4FDn4wnvYqUwRAVYSebcgs1aKFvCto=;
        b=TZNDnn/XY7qO8s6WvP7JIUtodqB9WY8kb4057YYMfNr90nYNUIs0z7mhTjdlZ2Izos
         cp5NNIQYbNR3crt/d7Mn3NB0Jpu4Xwfx5TRsaZANeykzE+2hs9qrP4R5oqwDi1hf1oFG
         IQBpTokB2lweGEovx9kteLRr96K9PQAxLmhCOrXYihHEFixPivb7ITGEbCVXO/dpsKnw
         f1Z93Un/a7CoHcq1Bae+G1epdIZVllc7xmyVxcRZBtZIvNN1WSIlEy8iZdoIurS+aQyF
         2o0FPgkHn31QnjVlt/nJ5jhiSoNI0vBCu96PMhWrNhUemT58YKv0b0/G41rsNIh1jkXf
         00sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R9+/OkDWq1U3L4FDn4wnvYqUwRAVYSebcgs1aKFvCto=;
        b=Wjrk4YK8o+ek/7W3JRzWWBEG7D0eOmGJ8YJVNsUxwIque4TJBnBPwGArcHXkYbLf/q
         5aQZpQGV8r55aPa7bSaUhsDX9axx4mL70+FGPFq6858oPEwmkjyJATbRCtyFShLDq+FF
         oa3UH6uOuhJEz6Ov45Dc1hAymtTy3nSzejrUA7y0Uz4JyAUMw3JYfAukiVP3qWFTo+JO
         sdd8C63vSv7cnrWMlUF4v2wCu+tbgz05N0GVM0A0ICUvbU2rHsYuAsqZiJzivpQ9Sp73
         dtTv7ARV32MB+86NyMS8r0DDaSWBTxoIESjH2GCF12/vkNnKUNRU1MHHPg9ZVRIvoGHN
         oBFg==
X-Gm-Message-State: AOAM530e0WJQhr/L9oBbTKVYRMebZN2gPZ/8Kd22IcUi6pyvKWckv/64
        Ux2KTbF2CINeVtxnb7Y86Rw+6w//ox/ixw==
X-Google-Smtp-Source: ABdhPJzeNqCUIA8aNn0cV54M9NlO7QQraCAQv1y2iAEfMSrH2qlA4t9IpLCspUdBDis/k9c5fR7Iag==
X-Received: by 2002:a1c:494:: with SMTP id 142mr19098834wme.60.1627333153453;
        Mon, 26 Jul 2021 13:59:13 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f3a:f500:a0c3:d466:871c:51b2? (p200300ea8f3af500a0c3d466871c51b2.dip0.t-ipconnect.de. [2003:ea:8f3a:f500:a0c3:d466:871c:51b2])
        by smtp.googlemail.com with ESMTPSA id w9sm842882wmc.19.2021.07.26.13.59.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 13:59:12 -0700 (PDT)
To:     Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Pavel Machek <pavel@ucw.cz>,
        Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, Kurt Kanzenbach <kurt@linutronix.de>,
        netdev@vger.kernel.org, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, vinicius.gomes@intel.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
References: <20210716212427.821834-1-anthony.l.nguyen@intel.com>
 <20210716212427.821834-6-anthony.l.nguyen@intel.com>
 <f705bcd6-c55c-0b07-612f-38348d85bbee@gmail.com> <YPTKB0HGEtsydf9/@lunn.ch>
 <88d23db8-d2d2-5816-6ba1-3bd80738c398@gmail.com> <YPbu8xOFDRZWMTBe@lunn.ch>
 <3b7ad100-643e-c173-0d43-52e65d41c8c3@gmail.com>
 <20210721204543.08e79fac@thinkpad> <YPh6b+dTZqQNX+Zk@lunn.ch>
 <20210721220716.539f780e@thinkpad>
 <4d8db4ce-0413-1f41-544d-fe665d3e104c@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
Message-ID: <6d2697b1-f0f6-aa9f-579c-48a7abb8559d@gmail.com>
Date:   Mon, 26 Jul 2021 22:59:05 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <4d8db4ce-0413-1f41-544d-fe665d3e104c@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.07.2021 19:42, Jacek Anaszewski wrote:
> Hi Marek,
> 
> On 7/21/21 10:07 PM, Marek Behún wrote:
>> On Wed, 21 Jul 2021 21:50:07 +0200
>> Andrew Lunn <andrew@lunn.ch> wrote:
>>
>>>> Hi Heiner,
>>>>
>>>> in sysfs, all devices registered under LED class will have symlinks in
>>>> /sys/class/leds. This is how device classes work in Linux.
>>>>
>>>> There is a standardized format for LED device names, please look at
>>>> Documentation/leds/leds-class.rst.
>>>>
>>>> Basically the LED name is of the format
>>>>    devicename:color:function
>>>
>>> The interesting part here is, what does devicename mean, in this
>>> context?
>>>
>>> We cannot use the interface name, because it is not unique, and user
>>> space can change it whenever it wants. So we probably need to build
>>> something around the bus ID, e.g. pci_id. Which is not very friendly
>>> :-(
>>
>> Unfortunately there isn't consensus about what the devicename should
>> mean. There are two "schools of thought":
>>
>> 1. device name of the trigger source for the LED, i.e. if the LED
>>     blinks on activity on mmc0, the devicename should be mmc0. We have
>>     talked about this in the discussions about ethernet PHYs.
>>     In the case of the igc driver if the LEDs are controlled by the MAC,
>>     I guess some PCI identifier would be OK. Or maybe ethernet-mac
>>     identifier, if we have something like that? (Since we can't use
>>     interface names due to the possibility of renaming.)
>>
>>     Pavel and I are supporters of this scheme.
>>
>> 2. device name of the LED controller. For example LEDs controlled by
>>     the maxim,max77650-led controller (leds-max77650.c) define device
>>     name as "max77650"
>>
>>     Jacek supports this scheme.
> 
> I believe you must have misinterpreted some my of my statements.
> The whole effort behind LED naming unification was getting rid of
> hardware device names in favour of Linux provided device names.
> See e.g. the excerpt from Documentation/leds/leds-class.rst:
> 
> - devicename:
>         it should refer to a unique identifier created by the kernel,
>         like e.g. phyN for network devices or inputN for input devices, rather
>         than to the hardware; the information related to the product and the bus
>         to which given device is hooked is available in sysfs and can be
>         retrieved using get_led_device_info.sh script from tools/leds; generally
>         this section is expected mostly for LEDs that are somehow associated with
>         other devices.
> 
> 
The issue with this is mentioned by Andrew a few lines before. At least in
network subsystem the kernel identifiers can be changed from userspace.
Typical example is the interface renaming from eth0 to e.g. enp1s0.
Then a LED eth0-led1 would have to be automagically renamed to enp1s0-led1.
An option for this could be to make a LED renaming function subscribe to
interface name change notifications. But this looks to me to like using a
quite big hammer for a rather small nail.
