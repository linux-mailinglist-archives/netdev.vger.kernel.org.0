Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3773C44B289
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 19:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242074AbhKISQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 13:16:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239343AbhKISQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 13:16:08 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 534B5C061764;
        Tue,  9 Nov 2021 10:13:22 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id 188so6864240pgb.7;
        Tue, 09 Nov 2021 10:13:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KZpT8QxJXvPZ/vEQ7mL1NDSD1H6v3kFSlru2WIxlImg=;
        b=I24IEE5sw+29rchnsfUWJOP2lxRNVKeTIACbyXUNcPHVd/ygD1u6SozwQgdzuBmdVs
         ky5c/I2X2k7GMG4aGfpwm0VepagVzvlbV9JNDr5VyjtzHLvP9X2hDBymZdAP9FoJzsW1
         V5icp4ubGcx1y4wUJ+/1R+i6nZ3AxIHaMbKsecxpCje3UJ0hp3yu+mPdDjM00evtTZAn
         MCzMU7AqHbiOQ5QuMB9o0K5MiZU2Rds3UmGXfEs6oxlpdu0k/vcn4csUX+sxzmn+WT8J
         7yWgJieh6qEHuBMMmrsCnOH/YY2HeSf/osMqhjgBpOuMW+uNNQHeZ91e6PgLwYcbbLU3
         XqMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KZpT8QxJXvPZ/vEQ7mL1NDSD1H6v3kFSlru2WIxlImg=;
        b=Gzbsg99gXiLB4Bbsl5PyAnHy82sz10IxcQz9TDDLXvBgFnw36jBRVT+KliDECPLaEO
         WaMVuZzrcK9yjS8YsD5XG4kYX9zyn31vwOfJK7+33kJzyf75m9u9kfMUH+8TGO+6WpmF
         5sz7pe8NZeD5gyatIPiz5z7SLFqeeSgfhx4yTTc3+NAzNxtZkAFyIDJybo2kQpQ3xT2I
         3ULYADevBLks808KkEBfzAPzVvLmwy6kqAL5Q2PrqSq/PUoPTKThNuQsF0DxyM7tZl/x
         71H4f8ng9oqWYWZSgSpjyRom/frCbYpr9KkaeS2Z+T36rmF8qUfYtk38O+Iqd+n4DGIi
         afAw==
X-Gm-Message-State: AOAM530wjPsuNkSKgMzJVdi/4V82vmp015XRYc0loGI2IKya67nnMsWJ
        ezPOhG432lFOGyZfTgQZNKnlPZ7vpL8=
X-Google-Smtp-Source: ABdhPJzHPswmBeRQ4Hl2iBooH52FvSv+PcfKbgWOy74Y2RfYl2ztYRD4h4vq8qCCnqRCsxS3lMZ7MQ==
X-Received: by 2002:a62:dd0d:0:b0:494:6e7a:23d with SMTP id w13-20020a62dd0d000000b004946e7a023dmr10302474pff.17.1636481601344;
        Tue, 09 Nov 2021 10:13:21 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id pf15sm3609442pjb.40.2021.11.09.10.13.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Nov 2021 10:13:20 -0800 (PST)
Subject: Re: [PATCH v2 0/7] Add PTP support for BCM53128 switch
To:     Martin Kaistra <martin.kaistra@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20211109095013.27829-1-martin.kaistra@linutronix.de>
 <20211109103936.2wjvvwhihhfqjfot@skbuf>
 <eb5836a7-fe08-7764-596b-f3941128f89c@linutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f88555e0-88b7-d01c-92ed-33729f704c4c@gmail.com>
Date:   Tue, 9 Nov 2021 10:13:18 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <eb5836a7-fe08-7764-596b-f3941128f89c@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/9/21 3:13 AM, Martin Kaistra wrote:
> 
> 
> Am 09.11.21 um 11:39 schrieb Vladimir Oltean:
>> On Tue, Nov 09, 2021 at 10:50:02AM +0100, Martin Kaistra wrote:
>>> Ideally, for the B53=m case, I would have liked to include the PTP
>>> support in the b53_module itself, however I couldn't find a way to do
>>> that without renaming either the common source file or the module, which
>>> I didn't want to do.
>>>
>>> Instead, b53_ptp will be allowed as a loadable module, but only if
>>> b53_common is also a module, otherwise it will be built-in.
>>
>> Does this not work?
>>
>> obj-$(CONFIG_B53)        += b53_common.o
>>
>> ifdef CONFIG_B53_PTP
>> b53_common-objs += b53_ptp.o
>> endif
>>
>> (haven't tried though)
>>
> 
> I get:
> 
> arm-linux-gnueabihf-ld  -EL    -r -o drivers/net/dsa/b53/b53_common.o
> drivers/net/dsa/b53/b53_ptp.o
> 
> 
> 
> and
> 
> 
> 
> ERROR: modpost: "b53_switch_register" [drivers/net/dsa/b53/b53_mdio.ko]
> undefined!
> 
> ERROR: modpost: "b53_switch_alloc" [drivers/net/dsa/b53/b53_mdio.ko]
> undefined!
> 
> ERROR: modpost: "b53_switch_register" [drivers/net/dsa/b53/b53_spi.ko]
> undefined!
> 
> ERROR: modpost: "b53_switch_alloc" [drivers/net/dsa/b53/b53_spi.ko]
> undefined!
> 
> It seems to me, that b53_common.c does not get included at all.

You need to play tricks with '-' and '_' and do something like this:

obj-$(CONFIG_B53)	+= b53-common.o

b53-common-objs		+= b53_common.o b53_ptp.o

and that should result in a b53-common.ko which would be accepted by
modprobe b53_common or b53-common AFAICT.
-- 
Florian
