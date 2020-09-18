Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9605C26E9EA
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 02:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbgIRASp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 20:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgIRASp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 20:18:45 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7D9C06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 17:18:45 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id t7so2184774pjd.3
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 17:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ijUN7Kv9bVS+drgMywd3RanRvlTJLxpIFnbTipEHWaA=;
        b=gCihyLR75hrpywSSrv33CESSi0GR9NW+rp5WDaZH17fdKFdqWT+9h1sJbjpGXXnqeB
         JGDRsAwe5XsPKvdIQVYyN2mMpKxFM+896jg7x3y+qJTps0rYTL/7TPSoq8tstN6j/CYh
         eVBoPwkYUQJ9vkEJyMG5BRXaHi7bDk286b5bPq7ulTc38zLafV1O+exWJrg/M71nVMyW
         Tk07cXoXirQmO9fUhcmPJzhMhIGti07q4NlT/oad71LtgmB6g0AWNeqfzV1A/NwzO7xT
         O0NqELTsWmAdLcbGcz+274vUBaPvfs+fc0dzZmU0kOa3xwYkkVsd9T+cCDCRpuwPlsP4
         BsqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ijUN7Kv9bVS+drgMywd3RanRvlTJLxpIFnbTipEHWaA=;
        b=V5I9s6Kg6A5tRXYK1Fca+Led3jwmgH66yRYUQYY75LDi/PK61twUCwEyIzVrvvl4Nr
         JvTKXROIMLihG4VxYnlUIb+VJ9KS0n8SOiVF4+DN5KlbTHc1SZi///eZJgNFyQMsOc/y
         EWuwdPZC0uPGa7ZcbxTjJMeBrP+KdO3JNx3LEywglDJZ8cnmJnr/WtVJ3/K+dpIF/zJX
         aodguXbMOCnUroL81R7zGw81egwXmkY0GQ5rC4+UTBrUJgYUfX/SXPF/Nk1z3VAkCJ0P
         7je+vsWGNzgdZrc/zAfzhT3crI2OahK+8955aDyYym4uWxxUPSXmGsz8eG2KuD+xh5pE
         AQ/g==
X-Gm-Message-State: AOAM53250Y7FV0Dv/YFIKN6JWiFf0hZ5wPc9AOe7E2WSfFYoPO+gIh/g
        1QOHhhJWDjDyJTeoNsTIfis=
X-Google-Smtp-Source: ABdhPJz66dJu3tJTJ5lZu5hQItnFfiVRF8AkNWZN2xJ+uLKl6tvJRfpddZCIXwVJbCwbq4tAE3BFQw==
X-Received: by 2002:a17:90b:3351:: with SMTP id lm17mr10330488pjb.151.1600388324690;
        Thu, 17 Sep 2020 17:18:44 -0700 (PDT)
Received: from [10.230.28.120] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x27sm814439pfp.128.2020.09.17.17.18.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2020 17:18:43 -0700 (PDT)
Subject: Re: [PATCH net-next 1/2] net: mdio: mdio-bcm-unimac: Turn on PHY
 clock before dummy read
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        kuba@kernel.org
References: <20200916204415.1831417-1-f.fainelli@gmail.com>
 <20200916204415.1831417-2-f.fainelli@gmail.com>
 <20200917.164011.166801140665121114.davem@davemloft.net>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <9d499cbc-9a6b-3543-1c28-0fd4689e13cc@gmail.com>
Date:   Thu, 17 Sep 2020 17:18:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200917.164011.166801140665121114.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/17/2020 4:40 PM, David Miller wrote:
> From: Florian Fainelli <f.fainelli@gmail.com>
> Date: Wed, 16 Sep 2020 13:44:14 -0700
> 
>> @@ -160,6 +160,7 @@ static int unimac_mdio_reset(struct mii_bus *bus)
>>   {
>>   	struct device_node *np = bus->dev.of_node;
>>   	struct device_node *child;
>> +	struct clk *clk;
>>   	u32 read_mask = 0;
>>   	int addr;
> 
> Please preserve the reverse christmas tree ordering of these local
> variables, thank you.

Looks like I used the same thread for all patches, the most recent is 
this one:

https://patchwork.ozlabs.org/project/netdev/patch/20200917020413.2313461-1-f.fainelli@gmail.com/

and is the one I would like to see you apply if you are happy with it.
-- 
Florian
