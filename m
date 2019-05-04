Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EEDA13731
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 05:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbfEDD5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 23:57:44 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43107 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbfEDD5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 23:57:44 -0400
Received: by mail-pg1-f195.google.com with SMTP id t22so3661266pgi.10;
        Fri, 03 May 2019 20:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=MpGeBmnAD3IdpKM/Ux4cDI5Oyl8dJfySPKH9DScovQw=;
        b=m648r1JFPdeVavMTYM0jrfIRknmMPsvHTNpJIdPfUHz8e0MO0l6WfVWAPFV/xoIze/
         /fL2P67/NxCULASrq+8PJi+A6azPQTyfO/OcCR9lfGN7/F1TBgBb8If27wTlBsKjtqFa
         lZ4VGq7YuXvd/zNBXWckB6iPZum7iQGcl37O8FeG1GdAmJVAoNI72/Yual65+ApUZEyt
         u8jvTyU84m6S+SOzQOPJFlh+kBhVZlghcx0pyZi3s+Osnb2S4rmqIMkTIrC6w9cO6GPr
         Ye+J8lwatDWgss2KKKMS5Y5Bq7mP8xonVbG1Mcp/MUuduIU0r3V/2fokz8/uVo8gm/SW
         qIrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=MpGeBmnAD3IdpKM/Ux4cDI5Oyl8dJfySPKH9DScovQw=;
        b=ZzlNxMP+IU/M2GzxhkMxejkxZHG+OUBqfUj8oOq3MI4hU4rjvpJJZxbRJ4WGE4mfOt
         +EJoZRSnau4dMjl/QujE3Lmq8zqrj2lxBLOjo9OTY0ZJzbqr2nn9CRbVpo7z8HdE0tl0
         HENP8ljT+hmB7UBETrxCwKnOcsx7owdrP/TBSbyHwr84k3hr8f9uZNg8/tTuXOqIRcp6
         q4NOZK8f0Wn90+aC9/0w3fJfu5C7vfYNKPTmlSL68pboygDIkKGM+aOMTv6VujKG2FCn
         xdLxDcTqn2gyqP/gHvYzfecwPjmg02WWHXJuSYc7x3/blCkNHbIHP6ceSwN1bwqHIa3L
         3Rmg==
X-Gm-Message-State: APjAAAUGPixPn1CrtVjl1Pu/nWH6ZSuM1a58Nw8IXqI5RR390FEsv5TN
        sgxyNJhJIlSAjgmrNl/6hDeWeVkK
X-Google-Smtp-Source: APXvYqzOaGOvjzbbv45uyOBSlrMpN5ECxTm5OlIrEf3MpNFr1r5O32OnQMSncWM8kAQ8kGuTVs5ZVA==
X-Received: by 2002:a62:6e05:: with SMTP id j5mr16233190pfc.5.1556942263589;
        Fri, 03 May 2019 20:57:43 -0700 (PDT)
Received: from ?IPv6:2402:f000:1:1501:200:5efe:166.111.71.43? ([2402:f000:1:1501:200:5efe:a66f:472b])
        by smtp.gmail.com with ESMTPSA id j9sm6954337pfc.43.2019.05.03.20.57.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 20:57:43 -0700 (PDT)
Subject: Re: [PATCH] net: via-rhine: net: Fix a resource leak in rhine_init()
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190504030813.17684-1-baijiaju1990@gmail.com>
 <20190503.231308.1440125282445011089.davem@davemloft.net>
 <f2e7c284-aa70-2b67-b9dd-461db102cbc5@gmail.com>
 <20190503.234131.1909607319842703379.davem@davemloft.net>
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Message-ID: <477140c2-841c-616f-fa25-faa428381111@gmail.com>
Date:   Sat, 4 May 2019 11:57:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20190503.234131.1909607319842703379.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/5/4 11:41, David Miller wrote:
> From: Jia-Ju Bai <baijiaju1990@gmail.com>
> Date: Sat, 4 May 2019 11:23:06 +0800
>
>>
>> On 2019/5/4 11:13, David Miller wrote:
>>> From: Jia-Ju Bai <baijiaju1990@gmail.com>
>>> Date: Sat,  4 May 2019 11:08:13 +0800
>>>
>>>> When platform_driver_register() fails, pci_unregister_driver() is not
>>>> called to release the resource allocated by pci_register_driver().
>>>>
>>>> To fix this bug, error handling code for platform_driver_register()
>>>> and
>>>> pci_register_driver() is separately implemented.
>>>>
>>>> This bug is found by a runtime fuzzing tool named FIZZER written by
>>>> us.
>>>>
>>>> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
>>> I think the idea here is that PCI is not enabled in the kernel, it is
>>> fine for the pci register to fail and only the platform register to
>>> succeed.
>>>
>>> You are breaking that.
>> Okay, I can understand it.
>> If so, I think that platform_driver_register() should be called before
>> pci_register_driver(), and it is still necessary to separately handle
>> their errors.
>> If you agree, I will send a v2 patch.
> It is only a failure if both fail.
>
> If at least one succeeds, the driver can potentially probe properly.

Thanks for the explanation, I understand now :)
The code logic seems a little strange, but it should be correct in 
rhine_init()...
If so, if one fails, I wonder whether it is correct for rhine_cleanup() 
to call both platform_driver_unregister() and pci_unregister_driver()?


Best wishes,
Jia-Ju Bai
