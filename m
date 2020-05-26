Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3771E2157
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 13:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731971AbgEZLx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 07:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731443AbgEZLx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 07:53:26 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38AEDC03E96E
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 04:53:25 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id p20so8169295iop.11
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 04:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hlMxfZxeMD+DKWmT3pt17RdFPN380iI2WVeOeZ79wkw=;
        b=t4kZrH+2brZaCI4MrOkR6KZfqPavGym3179KUX4j/ZvYjMZeGwNOrjXyEzeIGYdSAV
         5PSjV6gaZI3+EepcmOnwgmqSZhsuJiMkZi7Pd8CQCruTBzcT6c5Ley9CH2SsLVshyIt3
         QNsiKJjobAtOpmroQCiLNENOzYP0eYjZlDsUmDlIgRz7hEU6moYbMyw7UQaxsEmCHNA/
         qZOM3IaV+rOtSdd1HCCRWWUcEIllNbeZrBRMH2IICgG1iA6wF2ughWfOqEzUP8+mT3/1
         ycBv0p1napzjkUUxgXfJ/eXiWh48UrP1d6+OA7KfHNjYL+8zAtH4huoUG0QivvNCEAYz
         ekyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hlMxfZxeMD+DKWmT3pt17RdFPN380iI2WVeOeZ79wkw=;
        b=rKYRvYuu/3VkhGAV+syE7WGkVZMQ71slDRR4ZisE3eE8GHdZWBVRN5gGYuwj+bSQ+/
         wPT/YwRBGFrpQ85bgJKoNfgszbcUekF4OYjWpZhdKstli2bJk/59SdRcyLea6U17vuG+
         k77RQFZp+M08cF4LlzyuvNsdjhiFCCaHm1VFlASnQPysGMiihdon5IT101xwMeib0HOz
         gVYvfV5RNGXrFsfdJtAyn32CGmwhShBBAD/oNqkVZH5M6PeuwKJ+ExkY5rsGZ4fModF8
         hCLWFa/v+vA32zH8lIw0g5T6f67WO1VI0lZ+2ljUiNOD4dAOn6JZIqmn1nqLAr5NzVEw
         IL5g==
X-Gm-Message-State: AOAM531q/NRsu6XUrHUKPyqjF0PvzVJXuTGNJfUVadBDl42IiZW3+9PT
        ZI75CbMRkONWHoywFelOoBV7xw==
X-Google-Smtp-Source: ABdhPJysJNQt3T6dM953D88S5wdzxi/U/oshKuW/qDlHy6hbQRmFmerb1YPlez4lats+13/+SUWV/g==
X-Received: by 2002:a5e:a70b:: with SMTP id b11mr8299591iod.63.1590494004490;
        Tue, 26 May 2020 04:53:24 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id c7sm11123220ilf.36.2020.05.26.04.53.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 04:53:23 -0700 (PDT)
Subject: Re: [greybus-dev] [PATCH 1/8] driver core: Add helper for accessing
 Power Management callbacs
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?Q?Krzysztof_Wilczy=c5=84ski?= <kw@linux.com>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>, linux-pci@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org, Kevin Hilman <khilman@kernel.org>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        linux-acpi@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Len Brown <lenb@kernel.org>, linux-pm@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Johan Hovold <johan@kernel.org>, greybus-dev@lists.linaro.org,
        John Stultz <john.stultz@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Felipe Balbi <balbi@kernel.org>, Alex Elder <elder@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Karsten Graul <kgraul@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20200525182608.1823735-1-kw@linux.com>
 <20200525182608.1823735-2-kw@linux.com> <20200526063334.GB2578492@kroah.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <41c42552-0f4f-df6a-d587-5c62333aa6a8@linaro.org>
Date:   Tue, 26 May 2020 06:53:22 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200526063334.GB2578492@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/26/20 1:33 AM, Greg Kroah-Hartman wrote:
> On Mon, May 25, 2020 at 06:26:01PM +0000, Krzysztof Wilczyński wrote:
>> Add driver_to_pm() helper allowing for accessing the Power Management
>> callbacs for a particular device.  Access to the callbacs (struct
>> dev_pm_ops) is normally done through using the pm pointer that is
>> embedded within the device_driver struct.
>>
>> Helper allows for the code required to reference the pm pointer and
>> access Power Management callbas to be simplified.  Changing the
>> following:
>>
>>    struct device_driver *drv = dev->driver;
>>    if (dev->driver && dev->driver->pm && dev->driver->pm->prepare) {
>>        int ret = dev->driver->pm->prepare(dev);
>>
>> To:
>>
>>    const struct dev_pm_ops *pm = driver_to_pm(dev->driver);
>>    if (pm && pm->prepare) {
>>        int ret = pm->prepare(dev);
>>
>> Or, changing the following:
>>
>>       const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
>>
>> To:
>>       const struct dev_pm_ops *pm = driver_to_pm(dev->driver);
>>
>> Signed-off-by: Krzysztof Wilczyński <kw@linux.com>
>> ---
>>   include/linux/device/driver.h | 15 +++++++++++++++
>>   1 file changed, 15 insertions(+)
>>
>> diff --git a/include/linux/device/driver.h b/include/linux/device/driver.h
>> index ee7ba5b5417e..ccd0b315fd93 100644
>> --- a/include/linux/device/driver.h
>> +++ b/include/linux/device/driver.h
>> @@ -236,6 +236,21 @@ driver_find_device_by_acpi_dev(struct device_driver *drv, const void *adev)
>>   }
>>   #endif
>>   
>> +/**
>> + * driver_to_pm - Return Power Management callbacs (struct dev_pm_ops) for
>> + *                a particular device.
>> + * @drv: Pointer to a device (struct device_driver) for which you want to access
>> + *       the Power Management callbacks.
>> + *
>> + * Returns a pointer to the struct dev_pm_ops embedded within the device (struct
>> + * device_driver), or returns NULL if Power Management is not present and the
>> + * pointer is not valid.
>> + */
>> +static inline const struct dev_pm_ops *driver_to_pm(struct device_driver *drv)
>> +{
>> +	return drv && drv->pm ? drv->pm : NULL;

This could just be:

	if (drv)
		return drv->pm;

	return NULL;

Or if you want to evoke passion in Greg:

	return drv ? drv->pm : NULL;

					-Alex

> I hate ? : lines with a passion, as they break normal pattern mattching
> in my brain.  Please just spell this all out:
> 	if (drv && drv->pm)
> 		return drv->pm;
> 	return NULL;
> 
> Much easier to read, and the compiler will do the exact same thing.
> 
> Only place ? : are ok to use in my opinion, are as function arguments.
> 
> thanks,
> 
> greg k-h
> _______________________________________________
> greybus-dev mailing list
> greybus-dev@lists.linaro.org
> https://lists.linaro.org/mailman/listinfo/greybus-dev
> 

