Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 498123E8BE6
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 10:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236106AbhHKIhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 04:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233112AbhHKIhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 04:37:24 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09872C061765;
        Wed, 11 Aug 2021 01:37:01 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 203-20020a1c00d40000b02902e6a4e244e4so1374173wma.4;
        Wed, 11 Aug 2021 01:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=r2N2lJNtd9ZVoClfrfgh876Vfdtyeq7ZHkyk/68V1gA=;
        b=dSYtxaXDCl25xHC0RUhzvW1jjtWK0C461gFRD7NdUbEikkzJ0Fq2JFdLgvgeZTSYPt
         vGbHkLazdljjkjZgnlAOEJPz90n7dwcNji7tOWR2r0zV8KjMQiNCMQeZiHbhafyPm4e2
         HbdN7bYSWTwGCaLzlZAjivjzq536vg0oBvWAeflq9zyo7rzP9ZliT8rW5e1rAh+jI+y0
         qm1Z3ltM8zkefRQ9DwenwuOH+arhQ526i2rxdWGu5ooK7ns/Ov5Vmd/xUp06ZurBOKcK
         HyTVfTQvaae4haJmjC8Mt65Ha7htxJoCWH4ZIJ6dY4e0ytXFv70jJC2XLg9BqvWLvxJ/
         ROBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r2N2lJNtd9ZVoClfrfgh876Vfdtyeq7ZHkyk/68V1gA=;
        b=Cmytka3+Zyi/vuO+Ra4yYnd3C782al4JvHephR/AbnXnUsCGOPaDkKYdsg4h7et/9y
         AX+7m6a1N96ljBCQNRnJ6yugWyPk1ygWEG7+8TAkFkdlgDNV8Q3h7Y7B7lzuKsuNLDWK
         TpwuBSinOSXgGAIHxoAgKq2GitP/zX+hzH9b1p607+6KBcyzg5X3xqz2Qsjw9reoLvEr
         03SSJHVIAs+J/WfoB9K6SoeT42371wrzk0wk8pavOuAWm/5cuXt2MHYhxIhbzVHcZyPq
         c8+BMnCqqPwmUbkyAA/P9NWZWmc66jpk0zud/SJfj6kafNrmRSGdONyBCMIkoz1SkaUq
         Fqjg==
X-Gm-Message-State: AOAM530/a8cnvULKsDvnkoLL1BHXVOkO+ZWE8DZFQvYBi0PuHxwRzxFF
        a/Cjdk0PKKcDeEr+lLBjuiNq7hUkkSkXdw==
X-Google-Smtp-Source: ABdhPJx+Bhx60Go2TR/I/ARqxGl4Pjqxf0dXF/m8YuYGiTNSgcVyZOkKXRwpDNnxmKXEbaUEtP7BXA==
X-Received: by 2002:a1c:ed03:: with SMTP id l3mr25447530wmh.56.1628671019135;
        Wed, 11 Aug 2021 01:36:59 -0700 (PDT)
Received: from ?IPv6:2a01:cb05:8192:e700:90a4:fe44:d3d1:f079? (2a01cb058192e70090a4fe44d3d1f079.ipv6.abo.wanadoo.fr. [2a01:cb05:8192:e700:90a4:fe44:d3d1:f079])
        by smtp.gmail.com with ESMTPSA id u6sm11308532wrp.83.2021.08.11.01.36.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 01:36:58 -0700 (PDT)
Subject: Re: [PATCH net-next 1/2] net: pcs: xpcs: enable skip xPCS soft reset
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210809102229.933748-1-vee.khee.wong@linux.intel.com>
 <20210809102229.933748-2-vee.khee.wong@linux.intel.com>
 <YREvDRkiuScyN8Ws@lunn.ch> <20210810235529.GB30818@linux.intel.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f2a1f135-b77a-403d-5d2e-c497efc99df7@gmail.com>
Date:   Wed, 11 Aug 2021 01:36:56 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210810235529.GB30818@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/10/2021 4:55 PM, Wong Vee Khee wrote:
> Hi Andrew,
> On Mon, Aug 09, 2021 at 03:35:09PM +0200, Andrew Lunn wrote:
>> On Mon, Aug 09, 2021 at 06:22:28PM +0800, Wong Vee Khee wrote:
>>> From: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
>>>
>>> Unlike any other platforms, Intel AlderLake-S uses Synopsys SerDes where
>>> all the SerDes PLL configurations are controlled by the xPCS at the BIOS
>>> level. If the driver perform a xPCS soft reset on initialization, these
>>> settings will be switched back to the power on reset values.
>>>
>>> This changes the xpcs_create function to take in an additional argument
>>> to check if the platform request to skip xPCS soft reset during device
>>> initialization.
>>
>> Why not just call into the BIOS and ask it to configure the SERDES?
>> Isn't that what ACPI is all about, hiding the details from the OS? Or
>> did the BIOS writers not add a control method to do this?
>>
>>      Andrew
> 
> BIOS does configured the SerDes. The problem here is that all the
> configurations done by BIOS are being reset at xpcs_create().
> 
> We would want user of the pcs-xpcs module (stmmac, sja1105) to have
> control whether or not we need to perform to the soft reset in the
> xpcs_create() call.

I understood Andrew's response as suggesting to introduce the ability 
for xpcs_create() to make a BIOS call which would configure the SerDes 
after xpcs_soft_reset(). That way the current xpcs_create() signature 
would remain the same, but you could easily hook any post-reset 
initialization by making an appropriate BIOS call.
-- 
Florian
