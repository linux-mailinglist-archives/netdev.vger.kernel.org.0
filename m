Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 261F4735E5
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 19:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728874AbfGXRtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 13:49:13 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45690 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbfGXRtM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 13:49:12 -0400
Received: by mail-pl1-f196.google.com with SMTP id y8so22290971plr.12
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 10:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=MO10hIhJ5QTJqmCBQVMAgBt6uk2IhCfVu2T1vVLimBE=;
        b=ybIhu9ur2lrzcqkZHujuWV+h2+vZm+XvgAU/XkCg7FNQpOQzCIigh/xIljZ9o0DOvZ
         NvDjW5ows+qrGwj8I0O/vNhpl0kJX0uhy7JBFXPRjHKo+4/6/3s9LYuckVceD6ob4T6/
         PMRSdmg/xJrVR+4wcaa/OJlT1cqNj4AIJUtlH/1tUVhRQ6kVDJcgdlJJRsVwaQBEnbDo
         jtJnDPMjP9c1yJuY2oINKzJYIvwbvMBPjuJR/8pjnFqAutDI3S11cwUMYp8zmTUfX/ZG
         lVYHFxAjOqP1xCKBfY1LbMxaiTpAi9A5Gc0LT9rp3oZI4Lu+F52l1qjqmywpwk2+C59H
         GoGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=MO10hIhJ5QTJqmCBQVMAgBt6uk2IhCfVu2T1vVLimBE=;
        b=dlwOh2EQMJBFjaffNg7Ral91I6tZHkjQRJ7yoKX0m7pMwhqPc8sXnnwVF5b+MQmhqP
         Dy3V0UV2I+wyTRj4V/rR+qUAe2bMNVq4v+v7Sc87cOJi/jZN/iHfgsf18ssIG81Whvym
         A37McXGhQrEyz8DJvBPkXlYsyc/wXKEX/xLed8vbUsIhYKYuLXvzW5SIeMwsiZgAT4ag
         VECHjgoHEQPn/9YGUKZO3y+WOamGDw8AkGo4cBxQ1IoYr2srcmIeJyzozyV+rSdcdUEk
         qWZVkje6KkhwChcBVssmXYYgXYG6B8M27b1oLDXwfydviyHKjOeLnq9okmOKerdjK3SV
         zU6A==
X-Gm-Message-State: APjAAAXEqmpgmR4uqmW+nv/xo/PIMWlD8pTkkBRw5S8mK4puG4ngT/CP
        4mvmTZdoRdyrKph6Ocj40xLkOoJz40OdLg==
X-Google-Smtp-Source: APXvYqxBfwLWhx6+tBDnVdGuLAQoNffCUTk46tjgs5JaFAJA4LzzTMTQRbGXnJEiHHEg8U6Hh4x66A==
X-Received: by 2002:a17:902:ac87:: with SMTP id h7mr89912599plr.36.1563990551691;
        Wed, 24 Jul 2019 10:49:11 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id p15sm44533597pjf.27.2019.07.24.10.49.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 10:49:10 -0700 (PDT)
Subject: Re: [PATCH v4 net-next 02/19] ionic: Add hardware init and device
 commands
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <20190722214023.9513-3-snelson@pensando.io>
 <20190723.141833.384334163321137202.davem@davemloft.net>
 <59e45fd2-3c62-58cf-cf63-935d17703d2c@pensando.io>
 <20190723.160538.2065000079755912945.davem@davemloft.net>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <0ef47dc2-efdd-531f-d1a0-6f4d0d1b9f13@pensando.io>
Date:   Wed, 24 Jul 2019 10:49:09 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190723.160538.2065000079755912945.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/23/19 4:05 PM, David Miller wrote:
> From: Shannon Nelson <snelson@pensando.io>
> Date: Tue, 23 Jul 2019 15:50:22 -0700
>
>> On 7/23/19 2:18 PM, David Miller wrote:
>>> From: Shannon Nelson <snelson@pensando.io>
>>> Date: Mon, 22 Jul 2019 14:40:06 -0700
>>>
>>>> +void ionic_init_devinfo(struct ionic_dev *idev)
>>>> +{
>>>> + idev->dev_info.asic_type = ioread8(&idev->dev_info_regs->asic_type);
>>>> + idev->dev_info.asic_rev = ioread8(&idev->dev_info_regs->asic_rev);
>>>> +
>>>> +	memcpy_fromio(idev->dev_info.fw_version,
>>>> +		      idev->dev_info_regs->fw_version,
>>>> +		      IONIC_DEVINFO_FWVERS_BUFLEN);
>>>> +
>>>> +	memcpy_fromio(idev->dev_info.serial_num,
>>>> +		      idev->dev_info_regs->serial_num,
>>>> +		      IONIC_DEVINFO_SERIAL_BUFLEN);
>>>    ...
>>>> +	sig = ioread32(&idev->dev_info_regs->signature);
>>> I think if you are going to use the io{read,write}{8,16,32,64}()
>>> interfaces then you should use io{read,write}{8,16,32,64}_rep()
>>> instead of memcpy_{to,from}io().
>>>
>> Sure.
> Note, I could be wrong.  Please test.
>
> I think the operation of the two things might be different.
Yes, they are different things, the iowrite*_rep() functions write each 
value from a buffer all to the same single address, rather than copy a 
buffer into another buffer, and the ioread*_rep() functions repeatedly 
read from the same address to fill a buffer.

For example, the iowrite32_rep() boils down to this:
         do {
             __raw_writel(*buf++, addr);
         } while (--count);

Not quite what I need.

sln

