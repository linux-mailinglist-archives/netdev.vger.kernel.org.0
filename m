Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEE74444B3
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 16:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbhKCPhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 11:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbhKCPhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 11:37:52 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D566BC061714
        for <netdev@vger.kernel.org>; Wed,  3 Nov 2021 08:35:15 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id bq14so2703329qkb.1
        for <netdev@vger.kernel.org>; Wed, 03 Nov 2021 08:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=QjHQdgmsFR+JwMd3T7br8czw0yXr8hxZ7tycJX2xn4A=;
        b=4rs+scY7MSzEIJefbGUbiIkzvUyYf94M4v98PTQ4q7Q1XlxPaCkuyHfhrdFUXNqgnx
         lRzMpPF9KdEwVsM8Thmxv6b/iKJAZ85Hy5aKC0nhZ/XhkcJhUksj5mAfhUIgE3LxGfHJ
         7hsY2IfM5bhCpNspnfVR5zD4NH1YJUL4Tg5kIqRJhweHb+ZJsWDoXAXUI7f+BxvJgsGz
         +S89otR/DFNYlhAQJjM65BPHvZ1boCdyagzMl7OB2smn8X04rODEeDJmuFc1+TdHpIOC
         uTwH3pjDr1nmeZ5iITMaF1z2UJy8521O/FQkQIzqOeRkbPHbEFlyW69prcUhmk3gEGmz
         Tcgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QjHQdgmsFR+JwMd3T7br8czw0yXr8hxZ7tycJX2xn4A=;
        b=0SxTGh0aHU4i2Bo3oxtVg8mcjB74/k6qjV99rME9iukJjuJjSMCFnD8FeiDE8gDcjP
         C2hLwIKV+Oeh7vVBFLvYC1Wjl8Fjkf6p4Tas/y3CC7SWBgIKXAQ/8eINTVcmWS0LrgZ+
         compARl4iyoOagAQX+hdffqtsOpc+ebboVYW951PPteHY100mnTPYqeoQBeqD/21LDHB
         btVGpMrMOpkLJR5S3vM5+KImoBBfMQwUB/1REwB7TGCGaKkcbdhSsvYZXwVCOPoabdNT
         frtV6SndCw/b1eJXnDRx/fHAp41nlx97CqkN6bknzp4Nr7UNvzd6Z6Ajvdj03h3f2bWz
         8Egw==
X-Gm-Message-State: AOAM532sFzoRUkU9vgSqh6SKOl5pG/tXFfYNirIlLwNcHTRyOM55OAr5
        I6ez4Ajf/GNilMBXHsIFa5rlTA==
X-Google-Smtp-Source: ABdhPJzmVRl2aHWLhAz8alTwH5JgMt38ki0G8mgHc+Y2ufk/qdAHApi94fwVusImtzeoYB+JgmVkkg==
X-Received: by 2002:ae9:dcc7:: with SMTP id q190mr36073856qkf.194.1635953714954;
        Wed, 03 Nov 2021 08:35:14 -0700 (PDT)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id b5sm1970243qtb.1.2021.11.03.08.35.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Nov 2021 08:35:14 -0700 (PDT)
Message-ID: <37b378de-efd7-8512-e322-78dfe07f977d@mojatatu.com>
Date:   Wed, 3 Nov 2021 11:35:13 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [RFC/PATCH net-next v3 8/8] flow_offload: validate flags of
 filter and actions
Content-Language: en-US
To:     Baowen Zheng <baowen.zheng@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        Vlad Buslov <vladbu@nvidia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roi Dayan <roid@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers <oss-drivers@corigine.com>,
        Oz Shlomo <ozsh@nvidia.com>
References: <20211028110646.13791-1-simon.horman@corigine.com>
 <7147daf1-2546-a6b5-a1ba-78dfb4af408a@mojatatu.com>
 <ygnhfssia7vd.fsf@nvidia.com>
 <DM5PR1301MB21722A85B19EE97EFE27A5BBE7899@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <d16042e3-bc1e-0a2b-043d-bbb62b1e68d7@mojatatu.com>
 <DM5PR1301MB21728931E03CFE4FA45C5DD3E78A9@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <ygnhcznk9vgl.fsf@nvidia.com> <20211102123957.GA7266@corigine.com>
 <DM5PR1301MB2172F4949E810BDE380AF800E78C9@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <428057ce-ccbc-3878-71aa-d5926f11248c@mojatatu.com>
 <DM5PR1301MB2172AD191B6A370C39641E3FE78C9@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <66f350c5-1fd7-6132-3791-390454c97256@mojatatu.com>
 <10dae364-b649-92f8-11b0-f3628a6f550a@mojatatu.com>
 <DM5PR1301MB2172BFF79D57D28F34DC6A0AE78C9@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <cd624f2b-a693-84eb-d3f4-81d869caad93@mojatatu.com>
 <DM5PR1301MB2172BBAA594802D4F8F88670E78C9@DM5PR1301MB2172.namprd13.prod.outlook.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <DM5PR1301MB2172BBAA594802D4F8F88670E78C9@DM5PR1301MB2172.namprd13.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-11-03 10:48, Baowen Zheng wrote:
> On November 3, 2021 10:16 PM, Jamal Hadi Salim wrote:
>> On 2021-11-03 10:03, Baowen Zheng wrote:
>>> Thanks for your reply.
>>> On November 3, 2021 9:34 PM, Jamal Hadi Salim wrote:
>>>> On 2021-11-03 08:33, Jamal Hadi Salim wrote:
>>>>> On 2021-11-03 07:30, Baowen Zheng wrote:
>>>>>> On November 3, 2021 6:14 PM, Jamal Hadi Salim wrote:
>>
>>
>> [..]
>>
>>> Sorry for more clarification about another case that Vlad mentioned:
>>> #add a policer action with skip_hw
>>> tc actions add action police skip_hw rate ... index 20 #Now add a
>>> filter5 which has no flag tc filter add dev $DEV1 proto ip parent
>>> ffff: flower \
>>>          ip_proto icmp action police index 20 I think the filter5 could
>>> be legal, since it will not run in hardware.
>>> Driver will check failed when try to offload this filter. So the filter5 will only
>> run in software.
>>> WDYT?
>>>
>>
>> I think this one also has ambiguity. If the filter doesnt specify skip_sw or
>> skip_hw it will run both in s/w and h/w. I am worried if that looks suprising to
>> someone debugging after because in h/w there is filter 5 but no policer but in
>> s/w twin we have filter 5 and policer index 20.
> In this case, the filter will not in h/w because when the driver tries to offload the filter,
> It will found the action is not in h/w and return failed, then the filter will not in h/w, so the filter will only
> In software.

So you have partial failure? That doesnt sound good. What do you return
to the user - "success" or "somehow success"?
I worry it is still ambigous. Did the user really intend to do that?
If they did maybe they should have just added it to s/w instead of h/w
and s/w and then get saved by the driver?

>> It could be design intent, but in my opinion we have priorities to resolve such
>> ambiguities in policies.
>>
>> If we use the rule which says the flags have to match exactly then we can
>> simplify resolving any ambiguity - which will make it illegal, no?
> When you mentioned " match exactly ", do you mean the flags of the filter and the actions should be
> exactly same?
> Please consider the case that filter has flag and the action does not have any flag. 

See above.

> I think we should allow this case.
> Because it is legal before our patch, we do not expect to break this use case, yes?
> So maybe the "match exactly" just limits action flags, when action has flags(skip_sw or skip_hw), the filter must have
> exactly the same flags.

Maybe i am missing something but nothing should break.
I think what you mean is when the action is specified with
the filter. The flags should be the same in that case.

Example, filter 1:
tc filter add dev $DEV1 proto ip paren ffff: flower \
ip_proto icmp action police blah

where flag is 0 implies this filter goes both in h/w and s/w.
If i dump the policer or the filter i will see some index provided by
the kernel and i should be able to see both s/w and h/w
counters.

Same thing if i did:

Example filter 2:
tc filter add dev $DEV1 proto ip paren ffff: flower \
skip_sw ip_proto udp action police blah

both filter + action will have where flag of skip_sw when i dump
implies this filter goes only in h/w and any displayed index
is allocated by the kernel.


Our challenge is when someone specifies a specific action by index
and tries to use it ambigously.

cheers,
jamal
