Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2D23D8FAA
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 15:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237525AbhG1NxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 09:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236923AbhG1NwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 09:52:05 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F89C0617A2
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 06:51:02 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id k13so1344541qth.10
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 06:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lPetoFezlmeURlecukvuIUPwVjxcaqJaSuhsU7QgrO4=;
        b=rjeqGBxOVthLe9HeMJE0fqsBxoIe2OAGCysKNL49KdDAdrm+iAtNJF/uNhs51bMhUm
         EpKDGesQ7mfPLZd2pESghN/MbeGOpscoINgBiAJ9l+l7GzjNHYWToHQBzbUZEry95xWd
         EPz2YKtyi9yToAmfa4SyQUG/mJa2FDB+66pbGZRRE8hAMDSrydEEtIU0DNfJQwjY5f5f
         hsO+tVsrDCStEeC9FEOH1QAXTSzcqIKedsttSdWxEG3Q+Zk1oxrRowpJNS5GRgl6PD3L
         G3c9jsHTBlksoxyt9l1a+yWA4s9MfbEhs0mkhnBs/PDEPRbCqE/8EsjpO19/rNzjtf25
         CefQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lPetoFezlmeURlecukvuIUPwVjxcaqJaSuhsU7QgrO4=;
        b=I/iu1vUEYk0Ga3yvJ1+a5tHDjf4xacDCc+9IyUdRuas467hh/f9CSBrB+PwGLq/AYd
         PuWYmmYvP+k/LK+73K6wa8TIPPv1aemngPvt/wEK/UXoqq8KTjoOh9Fl6s51zzqruLWi
         CF1JKIwqJbN4EhU2nsJizGk5NGwHzflVUrxM1LQkYiJSeb6cJI9tXrVTjn9DM4Y58LXX
         tTkPenDJSoe+ejOPga/dOmI8++PLMoNGz1120Rt6YHeP63EQESw3Jh0qh0sELfdmbiaK
         4Pf0GivYfyzkX8+bF60kjK57JQ0XeE+SKsUvNC5knqIyHjUfAuJB+LB4pcR2jFOWDqDZ
         PECg==
X-Gm-Message-State: AOAM530vQv77nWEYSP+ft2yfvooj2ZGM6BiSAD/R11CtF5M2NVKJ2hnF
        c1opEGadLmkQL/VCaOg4m9M8aQ==
X-Google-Smtp-Source: ABdhPJwcGz+5zfuUmvp04DR5aNo4brYhS8KOfpGCiXUPM1SEoc2Ne/6GeJJ3cnWVktJTy4qYtfANHA==
X-Received: by 2002:ac8:4986:: with SMTP id f6mr24017450qtq.125.1627480262071;
        Wed, 28 Jul 2021 06:51:02 -0700 (PDT)
Received: from [192.168.1.171] (bras-base-kntaon1617w-grc-28-184-148-47-47.dsl.bell.ca. [184.148.47.47])
        by smtp.googlemail.com with ESMTPSA id d25sm2786794qtq.55.2021.07.28.06.51.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jul 2021 06:51:01 -0700 (PDT)
Subject: Re: [PATCH net-next 1/3] flow_offload: allow user to offload tc
 action to net device
To:     Simon Horman <simon.horman@corigine.com>,
        Vlad Buslov <vladbu@nvidia.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>, Roopa Prabhu <roopa@nvidia.com>
References: <20210722091938.12956-1-simon.horman@corigine.com>
 <20210722091938.12956-2-simon.horman@corigine.com>
 <ygnhim12qxxy.fsf@nvidia.com>
 <13f494c9-e7f0-2fbb-89f9-b1500432a2f6@mojatatu.com>
 <20210727130419.GA6665@corigine.com> <ygnh7dhbrfd0.fsf@nvidia.com>
 <95d6873c-256c-0462-60f7-56dbffb8221b@mojatatu.com>
 <ygnh4kcfr9e8.fsf@nvidia.com> <20210728074616.GB18065@corigine.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <7004376d-5576-1b9c-21bc-beabd05fa5c9@mojatatu.com>
Date:   Wed, 28 Jul 2021 09:51:00 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210728074616.GB18065@corigine.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-07-28 3:46 a.m., Simon Horman wrote:
> On Tue, Jul 27, 2021 at 07:47:43PM +0300, Vlad Buslov wrote:
>> On Tue 27 Jul 2021 at 19:13, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>>> On 2021-07-27 10:38 a.m., Vlad Buslov wrote:
>>>> On Tue 27 Jul 2021 at 16:04, Simon Horman <simon.horman@corigine.com> wrote:

[..]

>>>> I think we have the same issue with filters - they might not be in
>>>> hardware after driver callback returned "success" (due to neigh state
>>>> being invalid for tunnel_key encap, for example).
>>>>
>>>
>>> Sounds like we need another state for this. Otherwise, how do you debug
>>> that something is sitting in the driver and not in hardware after you
>>> issued a command to offload it? How do i tell today?
>>> Also knowing reason why something is sitting in the driver would be
>>> helpful.
>>
>> It is not about just adding another state. The issue is that there is no
>> way for drivers to change the state of software filter dynamically.
> 
> I think it might be worth considering enhancing things at some point.
> But I agree that its more than a matter of adding an extra flag. And
> I think it's reasonable to implement something similar to the classifier
> current offload handling of IN_HW now and consider enhancements separately.
> 

Debugability is very important. If we have such gotchas we need to have
the admin at least be able to tell if the driver returns "success"
and the request is still sitting in the driver for whatever reason
At minimal there needs to be some indicator somewhere which say
"inprogress" or "waiting for resolution" etc.
If the control plane(user space app) starts making other decisions
based on assumptions that filter was successfully installed i.e
packets are being treated in the hardware then there could be
consequences when this assumption is wrong.

So if i undestood the challenge correctly it is: how do you relay
this info back so it is reflected in the filter details. Yes that
would require some mechanism to exist and possibly mapping state
between whats in the driver and in the cls layer.
If i am not mistaken, the switchdev folks handle this asynchronicty?
+Cc Ido, Jiri, Roopa

And it should be noted that: Yes, the filters have this
pre-existing condition but doesnt mean given the opportunity
to do actions we should replicate what they do.

[..]

> 
>>> I didnt follow this:
>>> Are we refering to the the "block" semantics (where a filter for
>>> example applies to multiple devices)?
>>
>> This uses indirect offload infrastructure, which means all drivers
>> in flow_block_indr_dev_list will receive action offload requests.
>>

Ok, understood.

[..]

>>
>> No. How would adding more flags improve h/w update rate? I was just
>> thinking that it is strange that users that are not interested in
>> offloads would suddenly have higher memory usage for their actions just
>> because they happen to have offload-capable driver loaded. But it is not
>> a major concern for me.
> 
> In that case can we rely on the global tc-offload on/off flag
> provided by ethtool? (I understand its not the same, but perhaps
> it is sufficient in practice.)
> 

ok.
So: I think i have seen this what is probably the spamming refered
with the intel (800?) driver ;-> Basically driver was reacting to
all filters regardless of need to offload or not.
I thought it was an oversight on their part and the driver needed
fixing. Are we invoking the offload regardless of whether h/w offload
is requested? In my naive view - at least when i looked at the intel
code - it didnt seem hard to avoid the spamming.


>>> I was looking at it more as a (currently missing) feature improvement.
>>> We already have a use case that is implemented by s/w today. The feature
>>> mimics it in h/w.
>>>
>>> At minimal all existing NICs should be able to support the counters
>>> as mapped to simple actions like drop. I understand for example if some
>>> cant support adding separately offloading of tunnels for example.
>>> So the syntax is something along the lines of:
>>>
>>> tc actions add action drop index 15 skip_sw
>>> tc filter add dev ...parent ... protocol ip prio X ..\
>>> u32/flower skip_sw match ... flowid 1:10 action gact index 15
>>>
>>> You get an error if counter index 15 is not offloaded or
>>> if skip_sw was left out..
>>>
>>> And then later on, if you support sharing of actions:
>>> tc filter add dev ...parent ... protocol ip prio X2 ..\
>>> u32/flower skip_sw match ... flowid 1:10 action gact index 15
> 
> Right, I understand that makes sense and is internally consistent.
> But I think that in practice it only makes a difference "Approach B"
> implementations, none of which currently exist.
> 

At minimal:
Shouldnt counters (easily correlated to basic actions like drop or
accept) fit the scenario of:
tc actions add action drop index 15 skip_sw
tc filter add dev ...parent ... protocol ip prio X .. \
u32/flower skip_sw match ... flowid 1:10 action gact index 15

?

> I would suggest we can add this when the need arises, rather than
> speculatively without hw/driver support. Its not precluded by the current
> model AFAIK.
> 

We are going to work on a driver that would have the "B" approach.
I am hoping - whatever the consensus here - it doesnt require a
surgery afterwards to make that work.

cheers,
jamal
