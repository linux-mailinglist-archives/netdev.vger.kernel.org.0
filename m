Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDD323E82F4
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 20:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233163AbhHJSZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 14:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241052AbhHJSYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 14:24:52 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 284CEC05177D;
        Tue, 10 Aug 2021 11:18:09 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id v24-20020a0568300918b02904f3d10c9742so145228ott.4;
        Tue, 10 Aug 2021 11:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=h9v8FYsMCG4jpPUCena7C9FCKGGo4qC1nmNGhWOqWag=;
        b=Lqm4Wg2VjekKTEiGhZJiUMZjgOZEJdfZjcB81CJghLMwVfbwXfc+aUgW4164lx7kG5
         iIIDFZ2HV0F2rBArYEqLzFWer1KQzqexaK3VTqHICAkmykq1blcJ0w+N9WCbAl9VcmN7
         m/Gv6h0cwh2SHI4ULEBWV9mKFG8R+3kFUqn0X6uUoMonCUa8a2lektk2UgoXMNTH2KnT
         4R0TdygCgmrrhhlra9tEACAYBRoA0UAkjGIG/gqpDCGy+yASA9ldHGU3TQGe28Mc1JJr
         d1PW4THt5oZijdFc4XR+qBhC0dIx3kOJWdTF5Aw840cfa/IONgo6EZ08qOCafyh02ox5
         qmww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:to:cc:references:from:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h9v8FYsMCG4jpPUCena7C9FCKGGo4qC1nmNGhWOqWag=;
        b=pyVcp4TvVMe2MjG3UxMgwhY+mb19HbAOuv+BGdNyymXJn38bs98goPeVOq0BzZXYjt
         ucF6iAB7Y+xBcE7YhlLD8iooZAu7Plk3GMzWsnHK3M6VR8YHeesidFYTl48iwuzGtJt8
         34Z97GJnix1f8ZuD12GMP8K0bOayZ9GJPabqYtOfXgiYWQ1loM/xZaKgdf8j6gtfOZ7p
         oGfNGQ8XYKxRInEx6S1LkmFqtwlT4W+zNr4AgIPSUPcmPgdyiaGb2J8eH21cr5UdPvAv
         HUWhBwLNA/XDXqi/YTef5/B/rfrAftSHE/VHrbHPAmsDy9CuGylhPcFlUh4no1EqjnS/
         6Stw==
X-Gm-Message-State: AOAM533uvnl5Q9lgiaBqNWKkxOy75jaVl7xM3yacznhOp4LvciD6HUKb
        AsIoeoFf4dBgmmcmZoT0lG13/MdRHC0=
X-Google-Smtp-Source: ABdhPJxyFQqDyWF0WCakJ66AvTdZk+P6VVaqcMEJZ4Zz8ouIGY6Xb/TRYwJfhQ8H839Il6NzmZ3faA==
X-Received: by 2002:a9d:6088:: with SMTP id m8mr16410613otj.70.1628619488299;
        Tue, 10 Aug 2021 11:18:08 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b14sm4053864oic.58.2021.08.10.11.18.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 11:18:07 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jean Delvare <jdelvare@suse.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Marek Vasut <marex@denx.de>, David Jander <david@protonic.nl>,
        linux-hwmon@vger.kernel.org
References: <20210810125618.20255-1-o.rempel@pengutronix.de>
 <YRKV05IoqtJYr6Cj@lunn.ch>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH net-next v1] net: phy: nxp-tja11xx: log critical health
 state
Message-ID: <04df44d9-f049-e87b-81de-5a9fe888a49b@roeck-us.net>
Date:   Tue, 10 Aug 2021 11:18:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YRKV05IoqtJYr6Cj@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/10/21 8:05 AM, Andrew Lunn wrote:
> Hi Oleksij
> 
>> @@ -89,6 +91,12 @@ static struct tja11xx_phy_stats tja11xx_hw_stats[] = {
>>   	{ "phy_polarity_detect", 25, 6, BIT(6) },
>>   	{ "phy_open_detect", 25, 7, BIT(7) },
>>   	{ "phy_short_detect", 25, 8, BIT(8) },
>> +	{ "phy_temp_warn (temp > 155C°)", 25, 9, BIT(9) },
>> +	{ "phy_temp_high (temp > 180C°)", 25, 10, BIT(10) },
>> +	{ "phy_uv_vddio", 25, 11, BIT(11) },
>> +	{ "phy_uv_vddd_1v8", 25, 13, BIT(13) },
>> +	{ "phy_uv_vdda_3v3", 25, 14, BIT(14) },
>> +	{ "phy_uv_vddd_3v3", 25, 15, BIT(15) },
>>   	{ "phy_rem_rcvr_count", 26, 0, GENMASK(7, 0) },
>>   	{ "phy_loc_rcvr_count", 26, 8, GENMASK(15, 8) },
> 
> I'm not so happy abusing the statistic counters like this. Especially
> when we have a better API for temperature and voltage: hwmon.
> 
> phy_temp_warn maps to hwmon_temp_max_alarm. phy_temp_high maps to
> either hwmon_temp_crit_alarm or hwmon_temp_emergency_alarm.
> 
> The under voltage maps to hwmon_in_lcrit_alarm.
> 

FWIW, the statistics counters in this driver are already abused
(phy_polarity_detect, phy_open_detect, phy_short_detect), so
I am not sure if adding more abuse makes a difference (and/or
if such abuse is common for phy drivers in general).

Guenter

>> @@ -630,6 +640,11 @@ static irqreturn_t tja11xx_handle_interrupt(struct phy_device *phydev)
>>   		return IRQ_NONE;
>>   	}
>>   
>> +	if (irq_status & MII_INTSRC_TEMP_ERR)
>> +		dev_err(dev, "Overtemperature error detected (temp > 155C°).\n");
>> +	if (irq_status & MII_INTSRC_UV_ERR)
>> +		dev_err(dev, "Undervoltage error detected.\n");
>> +
> 
> These are not actual errors, in the linux sense. So dev_warn() or
> maybe dev_info().
> 
>        Andrew
> 

