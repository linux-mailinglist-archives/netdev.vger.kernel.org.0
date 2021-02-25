Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3F5325266
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 16:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232372AbhBYP05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 10:26:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232033AbhBYPZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 10:25:35 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C3FC061574
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 07:24:53 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id k13so9507699ejs.10
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 07:24:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eV8ZfLDH2sADRwQYB9EeEKkzInLgx8WucRP9R0/UwCc=;
        b=Ms9LteRaNuSL8A9am9ssEWOjj4vRGWN3X6+0PZJ+UJxI1kOgGc6xRdBWdAIWDBhG41
         gO0wLUzbZzSLDAyb1n9oKu5vpgZrScMG65N+Ojb3AlVvvaD/kbg7ha0S2oBT6p3TACwj
         a2qxCMNS+hTbB4QUx1NFuA7zfQ6e6mgwDlqgMx2tgwb4DJTc8ncWYnU43XTBRbJURBVU
         R9Kg/AcNVJRMstYNnoGPCBOIgOfnjGEUGKW/GJGP9x18IciPMazQb/6gP1LRQxCVhmzD
         1SN+xL1s0aJRVgfqqeaU6E4HtWwO6ZVtTSMREmBFsjmf4sV3xTIvdtbzYyEqCvh1v+Dh
         aEZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eV8ZfLDH2sADRwQYB9EeEKkzInLgx8WucRP9R0/UwCc=;
        b=Xg/sOXJ0MPCI6g/gZ4frqsyHRa8r6HqYp5jIBjI0LHxm9U+zvvpQzJgDFquG/WEeFK
         GffsbOALPcsnypitlrYXenPQ3gwOr2k/7r+kzbllkygRQzxrUiKiH2XjqN/cExaC9nW8
         VwuKfda0mkE3QEZimElim2fJOprH4WD43/OGxct0PitsxlqpcSVFCgJSZMR9RTNcwJdc
         i2pGAut1s0YBUQkT6z2cvROpdp7Q+kOL0UHiBPqMAfnJAfL66HfKBV91CwbqEP5yY3CR
         wUFTDC6//ehDx4agvgPjURMntHHA2upQ/OTI8Suq2GapAp79U98SnIICTctMT+VbeBm4
         BA2Q==
X-Gm-Message-State: AOAM531vXz7lmnNp9337gruGH4aA7I91dea2PDeRtP8b66DivBLqFfIY
        Z5iP7mXNwaFTn1NVIw2y42g=
X-Google-Smtp-Source: ABdhPJzd5Mv8NO2Rxt5rg2vAAeLles+odOOiL/YgOXFHyOZ61c8y0RkEEYKSWOmBD6Xar6B65nBywg==
X-Received: by 2002:a17:907:1607:: with SMTP id hb7mr3069180ejc.265.1614266692452;
        Thu, 25 Feb 2021 07:24:52 -0800 (PST)
Received: from [192.168.0.104] ([77.126.80.25])
        by smtp.gmail.com with ESMTPSA id s2sm3529160edt.35.2021.02.25.07.24.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Feb 2021 07:24:52 -0800 (PST)
Subject: Re: bug report: WARNING in bonding
To:     Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Moshe Shemesh <moshe@nvidia.com>,
        Itay Aveksis <itayav@nvidia.com>,
        Ran Rozenstein <ranro@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
References: <fb299ee2-4cf0-31d8-70f4-874da43e0021@gmail.com>
 <20201112154627.GA2138135@shredder>
 <e864f9a3-cda7-e498-91f4-894921527eaf@gmail.com>
 <20201112163307.GA2140537@shredder>
 <67b689d8-419b-78ec-0286-0983337ca3c1@gmail.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <d2979424-bb3e-3e1f-d53c-2b3580811533@gmail.com>
Date:   Thu, 25 Feb 2021 17:24:48 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <67b689d8-419b-78ec-0286-0983337ca3c1@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/18/2021 7:10 PM, Tariq Toukan wrote:
> 
> 
> On 11/12/2020 6:33 PM, Ido Schimmel wrote:
>> On Thu, Nov 12, 2020 at 05:54:30PM +0200, Tariq Toukan wrote:
>>>
>>>
>>> On 11/12/2020 5:46 PM, Ido Schimmel wrote:
>>>> On Thu, Nov 12, 2020 at 05:38:44PM +0200, Tariq Toukan wrote:
>>>>> Hi all,
>>>>>
>>>>> In the past ~2-3 weeks, we started seeing the following WARNING and 
>>>>> traces
>>>>> in our regression testing systems, almost every day.
>>>>>
>>>>> Reproduction is not stable, and not isolated to a specific test, so 
>>>>> it's
>>>>> hard to bisect.
>>>>>
>>>>> Any idea what could this be?
>>>>> Or what is the suspected offending patch?
>>>>
>>>> Do you have commit f8e48a3dca06 ("lockdep: Fix preemption WARN for 
>>>> spurious
>>>> IRQ-enable")? I think it fixed the issue for me
>>>>
>>>
>>> We do have it. Yet issue still exists.
>>
>> I checked my mail and apparently we stopped seeing this warning after I
>> fixed a lockdep issue (spin_lock() vs spin_lock_bh()) in a yet to be
>> submitted patch. Do you see any other lockdep warnings in the log
>> besides this one? Maybe something in mlx4/5 which is why syzbot didn't
>> hit it?
>>
> 
> Hi,
> 
> Issue still reproduces. Even in GA kernel.
> It is always preceded by some other lockdep warning.
> 
> So to get the reproduction:
> - First, have any lockdep issue.
> - Then, open bond interface.
> 
> Any idea what could it be?
> 
> We'll share any new info as soon as we have it.
> 
> Regards,
> Tariq


Bisect shows this is the offending commit:

commit 4d004099a668c41522242aa146a38cc4eb59cb1e
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Fri Oct 2 11:04:21 2020 +0200

     lockdep: Fix lockdep recursion

     Steve reported that lockdep_assert*irq*(), when nested inside lockdep
     itself, will trigger a false-positive.

     One example is the stack-trace code, as called from inside lockdep,
     triggering tracing, which in turn calls RCU, which then uses
    lockdep_assert_irqs_disabled().

     Fixes: a21ee6055c30 ("lockdep: Change hardirq{s_enabled,_context} 
to per-cpu variables")
     Reported-by: Steven Rostedt <rostedt@goodmis.org>
     Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
     Signed-off-by: Ingo Molnar <mingo@kernel.org>
