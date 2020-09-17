Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0398F26E6E1
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 22:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgIQUp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 16:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbgIQUp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 16:45:57 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D69AC06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 13:45:57 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id gf14so1809464pjb.5
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 13:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=foJ+lU9of3Z0w7uU++7iNpoAxFauzBfBINnD09vIHcw=;
        b=MLJoE/8xS74eCvFhQBHWDt6ZnzUCs1O+2ZLxR3YlJpsdf6B0e1AdNjCE1m0pHRkGfh
         BoWxD3c9gpWCd+dq/5iTZWyyUGkTKlvM6dVH+ZPuXHqm6UgG9RzcUWLhyEurt28uk1xl
         Ri69KS3ekaEkwZ6hpOrShGvLVVcxQYd0RFuyqHY38h54/OCGAy8qAmtDzOCMLfPQAWve
         woKbrTZL/i/uXxoNoAuaxdozDbaj9QW0oBLvJv9AieeaO71BFli2BOo0um1AdqyYAxp8
         V9r2n3eyd4cC5/v9OAfKiAJdxPa1r6QRjtOyUm54cdehsuBdrCTttP7tMKl5mWT8Bu2+
         GDPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=foJ+lU9of3Z0w7uU++7iNpoAxFauzBfBINnD09vIHcw=;
        b=BvHcKnVB9MlGQRa7s9lcPtscmTvC0j1xW/uMrfaQu7CijDmFcl1r9QDsawYLQlJhqh
         B/RpYWF85vNbg03gsvOaqFdC1Q29iVVGrrZ+PwGhGS0kns8EJLcwrWaBWycPQn4z/41k
         FhaooLOkFHqrpW7jJWYTc7omPA43854EOPbfL15bZ4X4FyQr/YNA/C70a/yekLZ/DvJc
         MBlEsoGX0agyqBiC9clZAy0it6ekYx+ZMZdEhZhHXFq51L8q/cPyNKFdKecMfeoyCZN2
         s6fABxIUuhfGp+lgNxDFeqUhW7eRlFWcyq57TqEi5QxC3xhc2+b1jx0K0XN6o7oxp1at
         VapA==
X-Gm-Message-State: AOAM531vf/FDXjC5zKUfU02Xl4lDHCBtltLyibQurPY+n3qO9b64RkzL
        IR2LwcAb1jr6WEZ94vnIDWK/og==
X-Google-Smtp-Source: ABdhPJxd/fZa1tPncp57SbyFFnXRPejo180VQh1ndfoW6fPONoXQneLOl+XNl9DzYKTWa/Dn+6ey2A==
X-Received: by 2002:a17:90b:357:: with SMTP id fh23mr9878197pjb.221.1600375556648;
        Thu, 17 Sep 2020 13:45:56 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id y1sm506238pgr.3.2020.09.17.13.45.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2020 13:45:56 -0700 (PDT)
Subject: Re: [PATCH v4 net-next 1/5] devlink: add timeout information to
 status_notify
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20200917030204.50098-1-snelson@pensando.io>
 <20200917030204.50098-2-snelson@pensando.io>
 <20200917124655.6bc16d99@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <1ad33f34-60e0-848f-a9b7-42869172e4b8@pensando.io>
Date:   Thu, 17 Sep 2020 13:45:55 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200917124655.6bc16d99@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/17/20 12:46 PM, Jakub Kicinski wrote:
> On Wed, 16 Sep 2020 20:02:00 -0700 Shannon Nelson wrote:
>> Add a timeout element to the DEVLINK_CMD_FLASH_UPDATE_STATUS
>> netlink message for use by a userland utility to show that
>> a particular firmware flash activity may take a long but
>> bounded time to finish.  Also add a handy helper for drivers
>> to make use of the new timeout value.
>>
>> UI usage hints:
>>   - if non-zero, add timeout display to the end of the status line
>>   	[component] status_msg  ( Xm Ys : Am Bs )
>>       using the timeout value for Am Bs and updating the Xm Ys
>>       every second
>>   - if the timeout expires while awaiting the next update,
>>     display something like
>>   	[component] status_msg  ( timeout reached : Am Bs )
>>   - if new status notify messages are received, remove
>>     the timeout and start over
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> Minor nits, otherwise LGTM:
>
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Thanks.


>
>> @@ -3052,6 +3054,9 @@ static int devlink_nl_flash_update_fill(struct sk_buff *msg,
>>   	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_FLASH_UPDATE_STATUS_TOTAL,
>>   			      total, DEVLINK_ATTR_PAD))
>>   		goto nla_put_failure;
>> +	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_FLASH_UPDATE_STATUS_TIMEOUT,
>> +			      timeout, DEVLINK_ATTR_PAD))
>> +		goto nla_put_failure;
> nit: since old kernels don't report this user space has to deal with it
>       not being present so I'd be tempted to only report it if timeout
>       is not 0

Hmmm... Unless there are any other comments on this, I think we can be 
consistent with the other fields here.

>
>> +void devlink_flash_update_timeout_notify(struct devlink *devlink,
>> +					 const char *status_msg,
>> +					 const char *component,
>> +					 unsigned long timeout)
>> +{
>> +	__devlink_flash_update_notify(devlink,
>> +				      DEVLINK_CMD_FLASH_UPDATE_STATUS,
>> +				      status_msg, component, 0, 0, timeout);
> nit: did we ever report cmd == UPDATE_STATUS and total == 0?
>       could this cause a division by zero in some unsuspecting
>       implementation? Perhaps we should pass 1 here?

Yes, there are several examples of this.  The userland devlink.c does a 
check for total == 0 before calculating the percentage.

sln

