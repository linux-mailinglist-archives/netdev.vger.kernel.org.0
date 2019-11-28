Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA47A10D005
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 00:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbfK1X5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 18:57:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:49982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbfK1X5M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Nov 2019 18:57:12 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 030D72081B;
        Thu, 28 Nov 2019 23:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574985431;
        bh=edWTwfLQ26x6fZFRXwo6KBhZijf9kYSEdQlEERXKrSQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=NVcVIS57ikz6SpW1WqeyHONWoRdStFvstxZVI01EQAqQJbvtwRejZW+x2neD9GeFR
         I7sDkkyO3fvwtWjmUso1ZTAQtQjynpAdPRLBFU3obfB84m6T+89a7W2HjeOwbA1HF7
         WwKtRRxx2sssqcSLKILKspdWPBWRcwDeiOURoaDw=
Subject: Re: [PATCH 4.19 000/306] 4.19.87-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        jouni.hogander@unikie.com, "David S. Miller" <davem@davemloft.net>,
        lukas.bulwahn@gmail.com, shuah <shuah@kernel.org>
References: <20191127203114.766709977@linuxfoundation.org>
 <CA+G9fYuAY+14aPiRVUcXLbsr5zJ-GLjULX=s9jcGWcw_vb5Kzw@mail.gmail.com>
 <20191128073623.GE3317872@kroah.com>
 <b4e6e9df-7334-763a-170a-6758916f420a@kernel.org>
From:   shuah <shuah@kernel.org>
Message-ID: <ad21dd80-ac0c-a6c0-5e17-0814121bd33e@kernel.org>
Date:   Thu, 28 Nov 2019 16:57:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <b4e6e9df-7334-763a-170a-6758916f420a@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/28/19 8:56 AM, shuah wrote:
> On 11/28/19 12:36 AM, Greg Kroah-Hartman wrote:
>> On Thu, Nov 28, 2019 at 12:23:41PM +0530, Naresh Kamboju wrote:
>>> On Thu, 28 Nov 2019 at 02:25, Greg Kroah-Hartman
>>> <gregkh@linuxfoundation.org> wrote:
>>>>
>>>> This is the start of the stable review cycle for the 4.19.87 release.
>>>> There are 306 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>>
>>>> Responses should be made by Fri, 29 Nov 2019 20:18:09 +0000.
>>>> Anything received after that time might be too late.
>>>>
>>>> The whole patch series can be found in one patch at:
>>>>          
>>>> https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.87-rc1.gz 
>>>>
>>>> or in the git tree and branch at:
>>>>          
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git 
>>>> linux-4.19.y
>>>> and the diffstat can be found below.
>>>>
>>>> thanks,
>>>>
>>>> greg k-h
>>>
>>> Kernel BUG noticed on x86_64 device while booting 4.19.87-rc1 kernel.
>>>
>>> The problematic patch is,
>>>
>>>> Jouni Hogander <jouni.hogander@unikie.com>
>>>>      net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject
>>>
>>> And this kernel panic is been fixed by below patch,
>>>
>>> commit 48a322b6f9965b2f1e4ce81af972f0e287b07ed0
>>> Author: Eric Dumazet <edumazet@google.com>
>>> Date:   Wed Nov 20 19:19:07 2019 -0800
>>>
>>>      net-sysfs: fix netdev_queue_add_kobject() breakage
>>>
>>>      kobject_put() should only be called in error path.
>>>
>>>      Fixes: b8eb718348b8 ("net-sysfs: Fix reference count leak in
>>> rx|netdev_queue_add_kobject")
>>>      Signed-off-by: Eric Dumazet <edumazet@google.com>
>>>      Cc: Jouni Hogander <jouni.hogander@unikie.com>
>>>      Signed-off-by: David S. Miller <davem@davemloft.net>
>>
>> Now queued up, I'll push out -rc2 versions with this fix.
>>
>> greg k-h
>>
> 
> Ran into this on my test system. I will try rc2.
> 

rc2 worked for me.

thanks,
-- Shuah

