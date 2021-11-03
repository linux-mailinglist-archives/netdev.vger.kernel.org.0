Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05F7C444302
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 15:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbhKCOHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 10:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbhKCOHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 10:07:39 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA338C061714
        for <netdev@vger.kernel.org>; Wed,  3 Nov 2021 07:05:02 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id bp7so2330044qkb.10
        for <netdev@vger.kernel.org>; Wed, 03 Nov 2021 07:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=B0SrM2QN+7atJtgAI9Q/5kzScnLEGRL/NsgHheLoV88=;
        b=Nz08N1ONs6DWnmnfgdvcAZiAr59SGqja/vpN6auB8FTptYCeswp8ibfn0j0u5rqlpW
         pIzWr9aHnybmxmyK7TEgzx/ieeygLGjmV//d6yJXya7TWYL3rbYhPO3LvfoR7vuiFeYr
         y6ali2iS8FB3YWVdnPnmfQEwhnh5yllsVHWag8jz49IIZSe648YdbmmPUD2Jfb41l368
         XY+Seq/NFfvOzWDsdYQJ3LVtgA5sDlFUov7ONuBKZ61Rt6nj8ENf77mnuCLWduPLY48S
         OzraelqLELiZFIFUzZKOSd8mxzU8BdRX3Yzbh0JwxmNFf1CCh7oPfXTGzJgTDzm0e1jR
         DnKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=B0SrM2QN+7atJtgAI9Q/5kzScnLEGRL/NsgHheLoV88=;
        b=WPIys4kxUSs5wqEGC7gYbtBK5mzTieTnGcwunWoXWjaKWRUeKr5RAoTMBsdeiuhRwo
         UBS+3Ud9Qi6Z6rmx72LmkTWL+wGIm+EYUFH47gudhxzhotPDvWJYIUn6zidIWNbF51JT
         osNv89allk6978z6MWKUpT7VBs8kyoI6MUUFCVa8YE8mcQG6s+OuTOxZLQPaxCr/ghRJ
         xt8lOHNbfSVhOYcwaK8cBrA9iLwMC2XV1F9Cci4YUZ6vMc9/clRo0qZaNLLfunp4GLKB
         qSuI8FUa59Ea9Mi5gjorJGfWs8NchV64693TJ7SaOouROGeL/kgeclMOmugITQhxWw+O
         NOcg==
X-Gm-Message-State: AOAM531CH78WVW5VfWWaRu2x7ISGJZZTtVu8eyyBf66iG/DTtxam9VdF
        uyfbQZNb+Vi5M+/1tCKFJt7saw==
X-Google-Smtp-Source: ABdhPJwuWf5/U5i3V2cW72u4QYeoRr9cmzBKVDZbhIPb8+7uBzq6RgAswF9aixfGz4PsW3TUKusX0A==
X-Received: by 2002:a37:9307:: with SMTP id v7mr34945278qkd.371.1635948301921;
        Wed, 03 Nov 2021 07:05:01 -0700 (PDT)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id 10sm1620683qkv.37.2021.11.03.07.05.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Nov 2021 07:05:01 -0700 (PDT)
Message-ID: <b375d36a-a36c-1ac5-147d-40449987d14c@mojatatu.com>
Date:   Wed, 3 Nov 2021 10:05:00 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [RFC/PATCH net-next v3 8/8] flow_offload: validate flags of
 filter and actions
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Baowen Zheng <baowen.zheng@corigine.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roi Dayan <roid@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers <oss-drivers@corigine.com>,
        Oz Shlomo <ozsh@nvidia.com>
References: <DM5PR1301MB21722A85B19EE97EFE27A5BBE7899@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <d16042e3-bc1e-0a2b-043d-bbb62b1e68d7@mojatatu.com>
 <DM5PR1301MB21728931E03CFE4FA45C5DD3E78A9@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <ygnhcznk9vgl.fsf@nvidia.com> <20211102123957.GA7266@corigine.com>
 <DM5PR1301MB2172F4949E810BDE380AF800E78C9@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <428057ce-ccbc-3878-71aa-d5926f11248c@mojatatu.com>
 <DM5PR1301MB2172AD191B6A370C39641E3FE78C9@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <66f350c5-1fd7-6132-3791-390454c97256@mojatatu.com>
 <10dae364-b649-92f8-11b0-f3628a6f550a@mojatatu.com>
 <20211103133817.GB6555@corigine.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <20211103133817.GB6555@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-11-03 09:38, Simon Horman wrote:
> On Wed, Nov 03, 2021 at 09:33:52AM -0400, Jamal Hadi Salim wrote:
>> On 2021-11-03 08:33, Jamal Hadi Salim wrote:
>>> On 2021-11-03 07:30, Baowen Zheng wrote:
>>>> On November 3, 2021 6:14 PM, Jamal Hadi Salim wrote:
>>>>> On 2021-11-03 03:57, Baowen Zheng wrote:
>>>>>> On November 2, 2021 8:40 PM, Simon Horman wrote:
>>>>>>> On Mon, Nov 01, 2021 at 09:38:34AM +0200, Vlad Buslov wrote:
>>>>>>>> On Mon 01 Nov 2021 at 05:29, Baowen Zheng
>>>>>
>>>>> [..]
>>>>>>>>
>>>>>>>> My suggestion was to forgo the skip_sw flag for shared action
>>>>>>>> offload and, consecutively, remove the validation code, not to add
>>>>>>>> even more checks. I still don't see a practical case where skip_sw
>>>>>>>> shared action is useful. But I don't have any strong feelings about
>>>>>>>> this flag, so if Jamal thinks it is necessary, then fine by me.
>>>>>>>
>>>>>>> FWIIW, my feelings are the same as Vlad's.
>>>>>>>
>>>>>>> I think these flags add complexity that would be nice to avoid.
>>>>>>> But if Jamal thinks its necessary, then including the flags
>>>>>>> implementation is fine by me.
>>>>>> Thanks Simon. Jamal, do you think it is necessary to keep the skip_sw
>>>>>> flag for user to specify the action should not run in software?
>>>>>>
>>>>>
>>>>> Just catching up with discussion...
>>>>> IMO, we need the flag. Oz indicated with requirement to be able
>>>>> to identify
>>>>> the action with an index. So if a specific action is added for
>>>>> skip_sw (as
>>>>> standalone or alongside a filter) then it cant be used for
>>>>> skip_hw. To illustrate
>>>>> using extended example:
>>>>>
>>>>> #filter 1, skip_sw
>>>>> tc filter add dev $DEV1 proto ip parent ffff: flower \
>>>>>       skip_sw ip_proto tcp action police blah index 10
>>>>>
>>>>> #filter 2, skip_hw
>>>>> tc filter add dev $DEV1 proto ip parent ffff: flower \
>>>>>       skip_hw ip_proto udp action police index 10
>>>>>
>>>>> Filter2 should be illegal.
>>>>> And when i dump the actions as so:
>>>>> tc actions ls action police
>>>>>
>>>>> For debugability, I should see index 10 clearly marked with the
>>>>> flag as skip_sw
>>>>>
>>>>> The other example i gave earlier which showed the sharing of actions:
>>>>>
>>>>> #add a policer action and offload it
>>>>> tc actions add action police skip_sw rate ... index 20 #now add
>>>>> filter1 which is
>>>>> offloaded using offloaded policer tc filter add dev $DEV1 proto
>>>>> ip parent ffff:
>>>>> flower \
>>>>>       skip_sw ip_proto tcp action police index 20 #add filter2
>>>>> likewise offloaded
>>>>> tc filter add dev $DEV1 proto ip parent ffff: flower \
>>>>>       skip_sw ip_proto udp action police index 20
>>>>>
>>>>> All good and filter 1 and 2 are sharing policer instance with index 20.
>>>>>
>>>>> #Now add a filter3 which is s/w only
>>>>> tc filter add dev $DEV1 proto ip parent ffff: flower \
>>>>>       skip_hw ip_proto icmp action police index 20
>>>>>
>>>>> filter3 should not be allowed.
>>>> I think the use cases you mentioned above are clear for us. For the case:
>>>>
>>>> #add a policer action and offload it
>>>> tc actions add action police skip_sw rate ... index 20
>>>> #Now add a filter4 which has no flag
>>>> tc filter add dev $DEV1 proto ip parent ffff: flower \
>>>>        ip_proto icmp action police index 20
>>>>
>>>> Is filter4 legal?
>>>
>>> Yes it is _based on current semantics_.
>>> The reason is when adding a filter and specifying neither
>>> skip_sw nor skip_hw it defaults to allowing both.
>>> i.e is the same as skip_sw|skip_hw. You will need to have
>>> counters for both s/w and h/w (which i think is taken care of today).
>>>
>>>
>>
>> Apologies, i will like to take this one back. Couldnt stop thinking
>> about it while sipping coffee;->
>> To be safe that should be illegal. The flags have to match _exactly_
>> for both  action and filter to make any sense. i.e in the above case
>> they are not.
> 
> I could be wrong, but I would have thought that in this case the flow
> is legal but is only added to hw (because the action doesn't exist in sw).
> 

I was worried what would show up in a dump of the filter.
Would it show only the h/w counter? And if yes, is the s/w
version mutated with no policer (since the policer is only
in h/w)?

> But if you prefer to make it illegal I guess that is ok too.

It just seemed easier from manageability pov to make it illegal, no?
i.e if flags dont match exactly it is illegal is a simple check.

cheers,
jamal
