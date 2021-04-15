Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4589E36119D
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 20:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234313AbhDOSCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 14:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233052AbhDOSCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 14:02:34 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 643A6C061574
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 11:02:09 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id x7so24157112wrw.10
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 11:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=huYuAH1P/lgZ/Vs1aFOYOAx9BxF3CXe6bBnoNGxrZ2s=;
        b=akB7SgCOravFbq4g62c/if12FFjK6/mtBLkw4J3n644OGI+rZbYASpgQ5smUqz3qOc
         Sq39LvqzowYM7uWgjpMylc7Chuy8hrs6M4KdNqkQyw98losrA2eZL8/5VOqFYllfnwTq
         gu52kz+UPHMOp1wX2TiUxyiE7KN889a7/qEcC3NkjUtbsveAgJuz3i/biG0IP+fOpBwc
         lNC8AlXLdBxah1QZJBR9NKv1m9Sju2j+MF/asnrT13WMyRdM8xvlYbrjJwddz/gLkF+E
         gpICXCyImjp7vXwgCH2pMeclsSkzDS5LB0UqgJJ940L69O5ZSzj5cazf0P2vRw9/bSM2
         2hHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=huYuAH1P/lgZ/Vs1aFOYOAx9BxF3CXe6bBnoNGxrZ2s=;
        b=grLF9BTpkErvYhshAHRJi2OwvAj6UlT6E8pHGWExS96iXIPZOszZ86PYIcmkbjx5UX
         r4HMmcTjBqMDVAYbwB/VVauN5IOpDR5heEsgtBa3gdnjm7T2pmyj1PO6iSptNQuDFgXe
         aKtFobF8gdiS4wcRKzP0pv1/dqOLCp9Uqo6L8ur3DeHditkLoFnazM8DTPvJO4gzokmY
         +nCjyyVORkxILLZoXLCmzvkLEMR6S9pK/zwCsMM8bxQetO0edGbut28AqaWVAL46fnGG
         AN4enyazqWdh+5nUKQBik0MWrgvpbwAZqCHLegOdrTIoHeO26bSppWVw/4+TFN68V0Gf
         87kw==
X-Gm-Message-State: AOAM530TorBwVMBLBxudJhjk6qL72m+07fy4Y2/Wr1NRKXiIHJGfPG61
        8Fw5Hml1IUjm/7+nxXZ7tts=
X-Google-Smtp-Source: ABdhPJzFaK79Vu/luMxh8C1Mb2viJ/vij7508HxvSuonT0FLWMYz1Njh2GdTxWZoRMLbpNgqYE0FRg==
X-Received: by 2002:a05:6000:24f:: with SMTP id m15mr4658244wrz.226.1618509728177;
        Thu, 15 Apr 2021 11:02:08 -0700 (PDT)
Received: from [192.168.1.101] ([37.173.146.249])
        by smtp.gmail.com with ESMTPSA id m67sm4605305wme.27.2021.04.15.11.02.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 11:02:07 -0700 (PDT)
Subject: Re: [PATCH] net: sched: tapr: remove WARN_ON() in
 taprio_get_start_time()
To:     Du Cheng <ducheng2@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        syzbot+d50710fd0873a9c6b40c@syzkaller.appspotmail.com
References: <20210415063914.66144-1-ducheng2@gmail.com>
 <5f9f5164-0247-8930-5400-90b7762247b1@gmail.com> <YHfwUmFODUHx8G5W@carbon>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <50562275-92ff-883f-91ca-5a7fc4382b80@gmail.com>
Date:   Thu, 15 Apr 2021 20:02:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <YHfwUmFODUHx8G5W@carbon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/15/21 9:50 AM, Du Cheng wrote:
> Le Thu, Apr 15, 2021 at 08:56:09AM +0200, Eric Dumazet a écrit :
>>
>>
>> On 4/15/21 8:39 AM, Du Cheng wrote:
>>> There is a reproducible sequence from the userland that will trigger a WARN_ON()
>>> condition in taprio_get_start_time, which causes kernel to panic if configured
>>> as "panic_on_warn". Remove this WARN_ON() to prevent kernel from crashing by
>>> userland-initiated syscalls.
>>>
>>> Reported as bug on syzkaller:
>>> https://syzkaller.appspot.com/bug?extid=d50710fd0873a9c6b40c
>>>
>>> Reported-by: syzbot+d50710fd0873a9c6b40c@syzkaller.appspotmail.com
>>> Signed-off-by: Du Cheng <ducheng2@gmail.com>
>>> ---
>>> Detailed explanation:
>>>
>>> In net/sched/sched_taprio.c:999
>>> The condition WARN_ON(!cycle) will be triggered if cycle == 0. Value of cycle
>>> comes from sched->cycle_time, where sched is of type(struct sched_gate_list*).
>>>
>>> sched->cycle_time is accumulated within `parse_taprio_schedule()` during
>>> `taprio_init()`, in the following 2 ways:
>>>
>>> 1. from nla_get_s64(tb[TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME]);
>>> 2. (if zero) from parse_sched_list(..., tb[TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST], ...);
>>>
>>> note: tb is a map parsed from netlink attributes provided via sendmsg() from the userland:
>>>
>>> If both two attributes (TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME,
>>> TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST) contain 0 values or are missing, this will result
>>> in sched->cycle_time == 0 and hence trigger the WARN_ON(!cycle).
>>>
>>> Reliable reproducable steps:
>>> 1. add net device team0 
>>> 2. add team_slave_0, team_slave_1
>>> 3. sendmsg(struct msghdr {
>>> 	.iov = struct nlmsghdr {
>>> 		.type = RTM_NEWQDISC,
>>> 	}
>>> 	struct tcmsg {
>>> 		.tcm_ifindex = ioctl(SIOCGIFINDEX, "team0"),
>>> 		.nlattr[] = {
>>> 			TCA_KIND: "taprio",
>>> 			TCA_OPTIONS: {
>>> 				.nlattr = {
>>> 					TCA_TAPRIO_ATTR_PRIOMAP: ...,
>>> 					TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST: {0},
>>> 					TCA_TAPRIO_ATTR_SCHED_CLICKID: 0,
>>> 				}
>>> 			}
>>> 		}
>>> 	}
>>> }
>>>
>>> Callstack:
>>>
>>> parse_taprio_schedule()
>>> taprio_change()
>>> taprio_init()
>>> qdisc_create()
>>> tc_modify_qdisc()
>>> rtnetlink_rcv_msg()
>>> ...
>>> sendmsg()
>>>
>>> These steps are extracted from syzkaller reproducer:
>>> https://syzkaller.appspot.com/text?tag=ReproC&x=15727cf1900000
>>>
>>>  net/sched/sch_taprio.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
>>> index 8287894541e3..5f2ff0f15d5c 100644
>>> --- a/net/sched/sch_taprio.c
>>> +++ b/net/sched/sch_taprio.c
>>> @@ -996,7 +996,7 @@ static int taprio_get_start_time(struct Qdisc *sch,
>>>  	 * something went really wrong. In that case, we should warn about this
>>>  	 * inconsistent state and return error.
>>>  	 */
>>> -	if (WARN_ON(!cycle))
>>> +	if (!cycle) {
>>>  		return -EFAULT;
>>>  
>>>  	/* Schedule the start time for the beginning of the next
>>>
>>
>> This 'fix' is wrong, not even compiled, thus not tested.
>>
>>  sched->cycle_time MUST not be zero ever, there are plenty
>> of other places where other crashes will happen.
>>
>> You are silencing a condition that should be caught much earlier.
>>
>> There is even a fat comment to explain this, that can be partially seen in your patch.
>>
>>
>> Correct fix will probably be :
>>
>> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
>> index 8287894541e3ce5f290be2e592c0dcbdf2ec6b60..189c617a582a2eecc92e35187379d4c2889289df 100644
>> --- a/net/sched/sch_taprio.c
>> +++ b/net/sched/sch_taprio.c
>> @@ -901,6 +901,8 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
>>  
>>                 list_for_each_entry(entry, &new->entries, list)
>>                         cycle = ktime_add_ns(cycle, entry->interval);
>> +               if (!cycle)
>> +                       return -EINVAL;
>>                 new->cycle_time = cycle;
>>         }
>>  
>>
>>
> 
> Hi Eric,
> 
> Sorry for the typo in the previous PATCH, I must have let the '{' slip out
> , when I tried to cleanup my own debugging lines.
> 
> Anyway, my intention was indeed to silently return error back to the userland,
> if the cycle is 0. The removal of WARN_ON() is so that this would not cause the
> kernel to panic.
> 
> `cycle` can be 0 if the userland provides invalid input, which should be
> anticipated and gracefully handled, hence panic would be too dramatic.


No. Again your patch is completely wrong, even when typo is fixed.

> 
> With the removal of WARN_ON(), the original logic was not
> altered: return -EINVAL to the userland and abort subsequent steps.
> 
> I will later submit a v2 to correct my typo.
> Thank you for your input.
> 
> Regards,
> Du Cheng
> 
