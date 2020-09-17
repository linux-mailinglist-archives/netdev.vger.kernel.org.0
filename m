Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EAFD26E6E9
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 22:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgIQUsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 16:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbgIQUsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 16:48:18 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0223EC06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 13:48:18 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id x18so1760568pll.6
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 13:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=ZUBu9tP6qD05G1XgazYU6XgKBCzSxjM/sY2+RtcuFE4=;
        b=s39PfAPlKL6fxSBpeGDDXR0CTstPEvPjTpu1RbiCpX/NvK+XTur8XL5I+hM9XUdztb
         AGwK52R8a4GvUJ/SCxCrVGYGFZCK6vihM5RZ6ltdxdDykl2wOTw2rxpOdyuCEue5VeZ/
         A201E+Y6MkX3ig9Y6dJHV6UDKsXE++I2D1ePkNqJRC5sEBE57TvMTj3HDnuYa0FudpBK
         D9N5px1x5oNusvraCUc9DterPmthARGgH/GQRIneDYDTpYwQP5ilevlWHJwKSbB/APlK
         gD1qXZPD9lWX55LjzrVQubN3Zo6LvsG5xv45y7kzV83Y6y1DUeIApGaYaMnwjgPYqt7U
         kd+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ZUBu9tP6qD05G1XgazYU6XgKBCzSxjM/sY2+RtcuFE4=;
        b=TgV0KrAaO7fLKyj9vqRo9rjpqkxg83i9tNqvHsd8GKrNYOKgkMgXKbopwODpFgjM/S
         9MdknMs3YBjW+luSZDPtM9wnWpww0GOo+LBhN2f2jMvRwi1gHuTTa1cW5FHs/dhnigU7
         RM9k+Rni6XaL3ixtL18qjH3qezVRfHjXHXb4Dcip26K7BuD64lsLWI0JJhIXd3DGwJ+W
         V/tBK0yQcQaQrMxT9Ef38GCYjW6TXTB4vRKl5j9KxiwJJkTu+gyYgDNKC/wkaeENCT4o
         9gyXCZVSUveuKC8iyX0wMojT6XfjyztKDIUDN1RxWfbDmmafXAkcC0Zve82UeeckZZzY
         5PTA==
X-Gm-Message-State: AOAM532JX5irVGdJOkKMueconDxp71WREgsb+6BkgDAkRvWdqdeLnFNY
        LPI54EZxt+k4ZgDquownW0s57g==
X-Google-Smtp-Source: ABdhPJwmJB+Q/qLfI8KaD1LeisuiFDkZe/D10RnDDVTIhxH+ZVqcHicwhPnJconx3ck9kobOXb0kLQ==
X-Received: by 2002:a17:902:7484:b029:d1:dea3:a490 with SMTP id h4-20020a1709027484b02900d1dea3a490mr14410945pll.30.1600375697595;
        Thu, 17 Sep 2020 13:48:17 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id c22sm483116pgb.52.2020.09.17.13.48.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2020 13:48:17 -0700 (PDT)
Subject: Re: [PATCH v4 net-next 1/5] devlink: add timeout information to
 status_notify
To:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        davem@davemloft.net
References: <20200917030204.50098-1-snelson@pensando.io>
 <20200917030204.50098-2-snelson@pensando.io>
 <4036d5eb-2e12-b4e2-03b1-94d6a93af0b6@intel.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <e3bb96b4-a2ad-df24-8b3e-6a05e58950ce@pensando.io>
Date:   Thu, 17 Sep 2020 13:48:16 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <4036d5eb-2e12-b4e2-03b1-94d6a93af0b6@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/17/20 12:50 PM, Jacob Keller wrote:
> On 9/16/2020 8:02 PM, Shannon Nelson wrote:
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
>> ---
> This one looks good to me. I think the only other things that I saw from
> previous discussion are:
>
> a) we could convert the internal helper devlink_nl_flash_update_fill and
> __devlink_flash_update_notify to use structs for their fields, and..
>
> b) Jakub pointed out that most drivers don't currently use the component
> field so we could remove that from the helpers.
>
> However, I don't have strong feelings about those either way, so:
>
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
>
>
Thanks,
sln

