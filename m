Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5592D2F6277
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 14:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbhANNy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 08:54:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726367AbhANNy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 08:54:26 -0500
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E0EAC061574
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 05:53:46 -0800 (PST)
Received: by mail-qk1-x72e.google.com with SMTP id 143so7780011qke.10
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 05:53:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kIAFytbmdessnycAX3uiv8K2v11OZa0lD0LZwo7UvlY=;
        b=mz5JxaFYNPT8hU4q1+3PLIWIvHc8E5o2DMsk8qRNecVOn2WiWvDgfD5Pdqd5+jPYE2
         eFJm4Xgv8EorZboNWf/Tzj8kTo82XV2WvBK+0/cuxKN2HlmcjUBAQwG1mc5vzGQdROo5
         k6tkSkibseGgePfKDvO9N2hrw/MDLGgoPrq8AD+vuZYF5YYrTUeXE66C5KM3qQ7mftzt
         kpsytgT5irFE91YnDi/VT8nMbOqlCxHlRIszK9NHPlN5meTnNwNclJbCRcDfo3imiOLJ
         ETUeoTYAi/4Ey/7rpjI50rkwyQLSJ9Et808vSPPZRW0w2aIcTuPozrXFAoWJPFOypoH+
         qjmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kIAFytbmdessnycAX3uiv8K2v11OZa0lD0LZwo7UvlY=;
        b=tUjQAT1MwOhPQuPKYAt957oNA5UZ4WT39PTNpnhcslvQd/aScrR9JQv7bhbzEfBDDm
         keA99iqjH/XkMPQ1SvTrk0x+EPmQUrvuAq+ydSl8lj3o4XqZujnlY04dNqgxS6UEJCu0
         mdhc6JqkHhraUEeTuF1mIucSGe/2kMlsX9twlL9Zuzk6eLCWdG/A7+MRNk5V5TUgH0bO
         d9iTpD2GKmHS+zp5voZhEbwYD5l6zJo4qpqY6+g4cebeW7nbJ+UoMZtqpZjQ4iCUN1A8
         EWDnACKF4TJK6A8xD4+0Npr3LgkgMamCwMtNycKT1gLhsG/z8x8EFZrTEtzyKksVdKEE
         /JHg==
X-Gm-Message-State: AOAM531m7lc38nm/op09c5tze9QVc6Rva080k8pcF+TGeYTxwz7efM+h
        0PF+jg38qhVWBFhovfbon8y1zQ==
X-Google-Smtp-Source: ABdhPJyaCQkHjZcepjLt7LuIO2/GsaaKvMMFrN7NOjSs5joQs9U/04m6/sMdKagRl3ox6T1YZEUjEw==
X-Received: by 2002:a37:ae44:: with SMTP id x65mr7281762qke.347.1610632425803;
        Thu, 14 Jan 2021 05:53:45 -0800 (PST)
Received: from [192.168.2.48] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id k19sm2903502qkh.6.2021.01.14.05.53.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jan 2021 05:53:45 -0800 (PST)
Subject: Re: [PATCH net-next v1 1/2] net: core: count drops from GRO
To:     Shannon Nelson <snelson@pensando.io>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        Eric Dumazet <edumazet@google.com>
References: <20210106215539.2103688-1-jesse.brandeburg@intel.com>
 <20210106215539.2103688-2-jesse.brandeburg@intel.com>
 <1e4ee1cf-c2b7-8ba3-7cb1-5c5cb3ff1e84@pensando.io>
 <20210108102630.00004202@intel.com>
 <c11bb25a-f73d-3ae9-b1fd-7eb96bc79cc7@pensando.io>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <b940a75c-f00b-0dd8-ac33-01278c78210a@mojatatu.com>
Date:   Thu, 14 Jan 2021 08:53:44 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <c11bb25a-f73d-3ae9-b1fd-7eb96bc79cc7@pensando.io>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-08 2:21 p.m., Shannon Nelson wrote:
> On 1/8/21 10:26 AM, Jesse Brandeburg wrote:
>> Shannon Nelson wrote:
>>
>>> On 1/6/21 1:55 PM, Jesse Brandeburg wrote:
>>>> When drivers call the various receive upcalls to receive an skb
>>>> to the stack, sometimes that stack can drop the packet. The good
>>>> news is that the return code is given to all the drivers of
>>>> NET_RX_DROP or GRO_DROP. The bad news is that no drivers except
>>>> the one "ice" driver that I changed, check the stat and increment
>>> If the stack is dropping the packet, isn't it up to the stack to track
>>> that, perhaps with something that shows up in netstat -s?  We don't
>>> really want to make the driver responsible for any drops that happen
>>> above its head, do we?
>> I totally agree!
>>
>> In patch 2/2 I revert the driver-specific changes I had made in an
>> earlier patch, and this patch *was* my effort to make the stack show the
>> drops.
>>
>> Maybe I wasn't clear. I'm seeing packets disappear during TCP
>> workloads, and this GRO_DROP code was the source of the drops (I see it
>> returning infrequently but regularly)
>>
>> The driver processes the packet but the stack never sees it, and there
>> were no drop counters anywhere tracking it.
>>
> 
> My point is that the patch increments a netdev counter, which to my mind 
> immediately implicates the driver and hardware, rather than the stack. 
> As a driver maintainer, I don't want to be chasing driver packet drop 
> reports that are a stack problem.  I'd rather see a new counter in 
> netstat -s that reflects the stack decision and can better imply what 
> went wrong.  I don't have a good suggestion for a counter name at the 
> moment.
> 
> I guess part of the issue is that this is right on the boundary of 
> driver-stack.  But if we follow Eric's suggestions, maybe the problem 
> magically goes away :-) .
> 

So: How does one know that the stack-upcall dropped a packet because
of GRO issues? Debugging with kprobe or traces doesnt count as an
answer.

cheers,
jamal


