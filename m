Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F586219598
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 03:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbgGIBYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 21:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725982AbgGIBYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 21:24:12 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D4EC061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 18:24:12 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id b9so137102plx.6
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 18:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=0Nj0ktv/rlc+R61V3NMXnCgAAQ1yfPIW7qtMIJSxMLM=;
        b=LGoj3rFnwu3rvJJCMNp/DzoLUtIejikW1axrcHjnxy6ZqYNPJgR3EDj9ka0DsEJuOL
         g3j3sNv6gKsOBNb8WKnXkj9JzFoCv7LipeR2DQ5Onqh8NGioG65r6Yi+wm50O56/7w12
         JSIYKN9rxJXlxxHrGqvkrKWJJKXMFvJS5h6ncX4t1PO9lluWZTChJwURh3LgCdvsQET/
         QwwsWqq1mFBel9sVrs3npkB8uV/lYMpCJpWpHzG6HKmW5ztKyG+q2zDOqbp0eaFBjV0j
         HFi49et+rnnn2qDt9bxqHI1e1x14z2NbCvVNr6Rviuwm4yLjVlx/WzAC3O4NTCSHWj8p
         DmEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0Nj0ktv/rlc+R61V3NMXnCgAAQ1yfPIW7qtMIJSxMLM=;
        b=dNJOjjD6Ynp5+m/SVe1YlcGK1YkXhrJGtysXfCcHuEM2TDJ1x8U6T27UcQS+R66bVy
         7+cUzLFpJNDAsZW1h7i/8qf1Qny9RcyOHM04HHAaospJQglyffhVZ0cv4Z3gZfg9Cb+V
         m+bjAzFL7qr1vKCS4fy4r/uOKv2N+GEPLQnK59EBgeTwHTmxKIt1ehG1lUlCgnoH26M8
         7EFiJMPHBJwzay5y7Vf/TIfZBuzHm4o4MaiyKQgvhdwYi2XnwHOKA1GsP08TTFWkW1p3
         L1vTKq0fIfg/NMfVMDaUbkizQKGbrz87QLKi8TCjq0OLjmJlU3ZnSAo4OuV2GG5Kcy64
         PHMQ==
X-Gm-Message-State: AOAM53057HmX4a4+DlvpN1aqioXrTIEWX2aSw8t6A1KZyZHeZR6HpimJ
        Ljn73AHfyGEKV2hWYvQbJy5Rd4vZ
X-Google-Smtp-Source: ABdhPJwg6f84LsKweWS7GVBKRBHBhnl1xx0Zws2x/uYAxzg71ADqn7ILlV0rLx9LmmiGBu9K+0rWSA==
X-Received: by 2002:a17:90a:4bc7:: with SMTP id u7mr12557701pjl.217.1594257851284;
        Wed, 08 Jul 2020 18:24:11 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id 7sm843511pgw.85.2020.07.08.18.24.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 18:24:10 -0700 (PDT)
Subject: Re: [PATCH net-next v2 2/2] net: sched: Lockless Token Bucket (LTB)
 qdisc
To:     "YU, Xiangning" <xiangning.yu@alibaba-inc.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <4835f4cb-eee0-81e7-d935-5ad85767802c@alibaba-inc.com>
 <554197ce-cef1-0e75-06d7-56dbef7c13cc@gmail.com>
 <d1716bc1-a975-54a3-8b7e-a3d3bcac69c5@alibaba-inc.com>
 <91fc642f-6447-4863-a182-388591cc1cc0@gmail.com>
 <387fe086-9596-c71e-d1d9-998749ae093c@alibaba-inc.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <c4796548-5c3b-f3db-a060-1e46fb42970a@gmail.com>
Date:   Wed, 8 Jul 2020 18:24:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <387fe086-9596-c71e-d1d9-998749ae093c@alibaba-inc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/8/20 5:58 PM, YU, Xiangning wrote:
> 
> 
> On 7/8/20 5:08 PM, Eric Dumazet wrote:
>>
>>
>> On 7/8/20 4:59 PM, YU, Xiangning wrote:
>>
>>>
>>> Yes, we are touching a cache line here to make sure aggregation tasklet is scheduled immediately. In most cases it is a call to test_and_set_bit(). 
>>
>>
>> test_and_set_bit() is dirtying the cache line even if the bit is already set.
>>
> 
> Yes. I do hope we can avoid this.
> 
>>>
>>> We might be able to do some inline processing without tasklet here, still we need to make sure the aggregation won't run simultaneously on multiple CPUs. 
>>
>> I am actually surprised you can reach 8 Mpps with so many cache line bouncing around.
>>
>> If you replace the ltb qdisc with standard mq+pfifo_fast, what kind of throughput do you get ?
>>
> 
> Just tried it using pktgen, we are far from baseline. I can get 13Mpps with 10 threads in my test setup.

This is quite low performance.

I suspect your 10 threads are sharing a smaller number of TX queues perhaps ?

