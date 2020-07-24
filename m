Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41EA022D1FF
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 00:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgGXWvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 18:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726274AbgGXWvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 18:51:07 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD148C0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 15:51:06 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id r2so4522973wrs.8
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 15:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ruj8EYEiWHdbX8cVKExpMXGWbYlVCUQm2ZkfCPXmZ38=;
        b=bU53epG/Dcbc2mi4nsvAdFB82Yfl3Zu6QUkNmNQsIx9cYrFTlm9RSaP/faKiUKXs1X
         NAxYiWJLtfnpm0rwFg5ea6jdOKq0KwQ7530wrvD2bnSKeG1jHQ4AuziZjinCJr/uLNco
         yHfEuc2DbxtVdZs01Qb2/DQyRQuH7y3mR5zGI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ruj8EYEiWHdbX8cVKExpMXGWbYlVCUQm2ZkfCPXmZ38=;
        b=QfKAsLGSWGLEW8rk7jbOtMkb9PRWum4nAonyvtoBlQXzILl6f6KoURGooDPnhAdk4f
         UHqtztvh9ZzxrYecO50Tb17S96I7VaVl2e8ymu1HhcUVYPy27MgSFJQk+AgJzO72fGK1
         CLXdty7rkGlcOL+UH6TU8tknLdetM67MzmL5hrQIjDl2KPmkZZb7WJnKSEkRtPGToF9n
         +/U8IILMnXy+yR33Jhxbk/2ry64fQ/C7PAu7Bj8KnNWzl/T8ZUvjH/Vd/5JJ+kOakYLe
         oGtQFHMAXbmGRPOu1UIdqowwGXcUvotu7DvA7aVTaAnfqX0gPczbtXn42W2NPG5Xf4ls
         3CLg==
X-Gm-Message-State: AOAM531twsl+X3Ew4+IBOtjAI2zw/81830Xb+Aq3Z3G3EUAwT/Fj/BJ0
        sXusNqkWPQzE3v6c7NctNiQLRCrPxDw=
X-Google-Smtp-Source: ABdhPJzhT/uIbjy1JYtW4OFTdVjR2dRSOYeNdBD1gDVOCaKUtzCzI5NnZjLlRbfWK20aovhaB1zZCw==
X-Received: by 2002:adf:a15c:: with SMTP id r28mr10307586wrr.151.1595631064393;
        Fri, 24 Jul 2020 15:51:04 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id y20sm8099267wmi.8.2020.07.24.15.51.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jul 2020 15:51:03 -0700 (PDT)
Subject: Re: [RFT iproute2] iplink_bridge: scale all time values by USER_HZ
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     George Shuklin <amarao@servers.com>, netdev@vger.kernel.org,
        jiri@resnulli.us
References: <869fed82-bb31-589f-bd26-591ccfa976ed@servers.com>
 <20200724091517.7f5c2c9c@hermes.lan>
 <F074B3B5-1B07-490F-87B8-887E2EFB32F3@cumulusnetworks.com>
 <20200724120513.13d4b3b1@hermes.lan>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <eb3056d2-67ae-3706-169f-31159f707cc1@cumulusnetworks.com>
Date:   Sat, 25 Jul 2020 01:51:02 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200724120513.13d4b3b1@hermes.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/07/2020 22:05, Stephen Hemminger wrote:
> On Fri, 24 Jul 2020 19:24:35 +0300
> nikolay@cumulusnetworks.com wrote:
> 
>> On 24 July 2020 19:15:17 EEST, Stephen Hemminger <stephen@networkplumber.org> wrote:
>>>
>>> The bridge portion of ip command was not scaling so the
>>> values were off.
>>>
>>> The netlink API's for setting and reading timers all conform
>>> to the kernel standard of scaling the values by USER_HZ (100).
>>>
>>> Fixes: 28d84b429e4e ("add bridge master device support")
>>> Fixes: 7f3d55922645 ("iplink: bridge: add support for
>>> IFLA_BR_MCAST_MEMBERSHIP_INTVL")
>>> Fixes: 10082a253fb2 ("iplink: bridge: add support for
>>> IFLA_BR_MCAST_LAST_MEMBER_INTVL")
>>> Fixes: 1f2244b851dd ("iplink: bridge: add support for
>>> IFLA_BR_MCAST_QUERIER_INTVL")
>>> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
>>> ---  
>>
>> While I agree this should have been done from the start, it's too late to change. 
>> We'll break everyone using these commands. 
>> We have been discussing to add _ms version of all these which do the proper scaling. I'd prefer that, it's least disruptive
>> to users. 
>>
>> Every user of the old commands scales the values by now.
> 
> So bridge is inconsistent with all other api's in iproute2!
> And the bridge option in ip link is scaled differently than the bridge-utils or sysfs.
> 

Yeah, that is not new, it's been like that for years.

> Maybe an environment variable?
> Or add new fixed syntax option and don't show the old syntax?
> 

Anything that doesn't disrupt normal processing sounds good.
So it must be opt-in, we can't just change the default overnight.

The _ms version of all values is that - new fixed syntax options for all current options
and anyone who wants to use a "normal" time-based option would use those as they'll be
automatically scaled.

