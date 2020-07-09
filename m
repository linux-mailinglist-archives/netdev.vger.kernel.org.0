Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A746521A598
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 19:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728256AbgGIRPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 13:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727003AbgGIRPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 13:15:48 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A710C08C5CE
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 10:15:48 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id f16so1406770pjt.0
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 10:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=0KgDSGhjLaQJ06o6lZOgNZbTiNYF8AVuG8l0VzZEJOM=;
        b=RLuUWz4PTr94rLXT6lzxp7UewKum4bgXMAOFd2bBhekStY6AnYmf7Hskt6atnEwp1D
         C7RBto13VzewIynjESOEULF7W6zzN1o9HYBIAZK0gaZrAcjoZ/fXBgFcJnPpcmQ31D1C
         LrqlOCp7OQzkokCDAV4pMP2gC0c7AuNczO977K8SX0QC8KD82a3oUsBp0kDbohwj4Td2
         Cyv2K0Df4lCLvHit7cVOCC7+Php5GmGfH0tHVCT43g3HisfYI8fm/Agzm+Jisc1z/+sb
         ygpp9eibjLE4+LMxOYbofWBjHupPz+ljVJasmQnsYfsczMxTeR8tM3GvfeeXu5c+5w0I
         seHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0KgDSGhjLaQJ06o6lZOgNZbTiNYF8AVuG8l0VzZEJOM=;
        b=CTwSvmw7PfH3lAYjqQkNgut9meWBuULAPi/qp78tXwb/ANha7Fis0dHJuHixpJ1pWg
         cWrhHKaAcRUE5IaTNMxIDbfM5Tz4hEl7whtlsaMFk5KSb01V0+4572vuZbYLDroLVOMx
         JHCSFgGg4zdAJoMHIj7P5//maTKmBcUYL5bd61EHMRQfOycvYK2vp5zZxvd+ZHWg4/iv
         DI9dQLZPDmlbFGdATzWr3uVrmP6gmGtklyv/HYbepDv/TSCZlSGRn+P2JTVXFQTeCU4p
         Lofvxtyd+FBNSC7Kbzlb9NSz/eezxWd0hDHMvrx2651rhMQBWDZMqI6vdgSHphbSFaZV
         t3HQ==
X-Gm-Message-State: AOAM532mGtCPajrPdxm2GXBhfir7+l2b325zQ1WD+2zSXPX50cTCmCwd
        lEVr9MJVqjtFfk2bVuynfuJ0dfrH
X-Google-Smtp-Source: ABdhPJyg0BteZ1Dr6MPqJyVvv/Xbdhw6loK1+w789sWx6YbZ2VEaMXDkzpyiK6J5szzcjDmNKTnRfg==
X-Received: by 2002:a17:90b:142:: with SMTP id em2mr1070479pjb.236.1594314947187;
        Thu, 09 Jul 2020 10:15:47 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id n15sm3348994pjf.12.2020.07.09.10.15.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2020 10:15:46 -0700 (PDT)
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
 <c4796548-5c3b-f3db-a060-1e46fb42970a@gmail.com>
 <7ea368d0-d12c-2f04-17a7-1e31a61bbe2b@alibaba-inc.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <825c8af6-66b5-eaf4-2c46-76d018489ebd@gmail.com>
Date:   Thu, 9 Jul 2020 10:15:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <7ea368d0-d12c-2f04-17a7-1e31a61bbe2b@alibaba-inc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/9/20 10:04 AM, YU, Xiangning wrote:
> 
> 
> On 7/8/20 6:24 PM, Eric Dumazet wrote:
>>
>>
>> On 7/8/20 5:58 PM, YU, Xiangning wrote:
>>>
>>>
>>> On 7/8/20 5:08 PM, Eric Dumazet wrote:
>>>>
>>>>
>>>> On 7/8/20 4:59 PM, YU, Xiangning wrote:
>>>>
>>>>>
>>>>> Yes, we are touching a cache line here to make sure aggregation tasklet is scheduled immediately. In most cases it is a call to test_and_set_bit(). 
>>>>
>>>>
>>>> test_and_set_bit() is dirtying the cache line even if the bit is already set.
>>>>
>>>
>>> Yes. I do hope we can avoid this.
>>>
>>>>>
>>>>> We might be able to do some inline processing without tasklet here, still we need to make sure the aggregation won't run simultaneously on multiple CPUs. 
>>>>
>>>> I am actually surprised you can reach 8 Mpps with so many cache line bouncing around.
>>>>
>>>> If you replace the ltb qdisc with standard mq+pfifo_fast, what kind of throughput do you get ?
>>>>
>>>
>>> Just tried it using pktgen, we are far from baseline. I can get 13Mpps with 10 threads in my test setup.
>>
>> This is quite low performance.
>>
>> I suspect your 10 threads are sharing a smaller number of TX queues perhaps ?
>>
> 
> Thank you for the hint. Looks like pktgen only used the first 10 queues.
> 
> I fined tuned ltb to reach 10M pps with 10 threads last night. I can further push the limit. But we probably won't be able to get close to baseline. Rate limiting really brings a lot of headache, at least we are not burning CPUs to get this result.

Well, at Google we no longer have this issue.

We adopted EDT model, so that rate limiting can be done in eBPF, by simply adjusting skb->tstamp.

The qdisc is MQ + FQ.

Stanislas Fomichev will present this use case at netdev conference 

https://netdevconf.info/0x14/session.html?talk-replacing-HTB-with-EDT-and-BPF

