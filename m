Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E038545B8EA
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 12:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240482AbhKXLNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 06:13:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240366AbhKXLNg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 06:13:36 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0EB9C061574
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 03:10:26 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id z9so2200398qtj.9
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 03:10:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=jgYLhQU1QcQ16+sYSDTfQf+bXsaV+p/ArPf3nYhwb/U=;
        b=tixzP8zijAS9+ctDMXfEsfL155TyzbR4CyfYrPtahrBF+CRvKYL8uHMHbs2wXCRRnL
         el7G8PaMIkT36/2r87Wm6CMoRE46GeKBHk64qxOZie0cpqiXoobdaulaNCz7kuPTXiuf
         ZkNyPnEzqRl1jHTLtRA+kj+smZ2J40NzbChbFOqokj2OAYTx42YdoAF+CyfCONiGqQ5r
         IRhnoXBuj/rbPevgJsXyXR5QaPQ4v87NhgrJl2mLLpUTP7mOWy8HIzJBuYYvTlMj9FPc
         ZpK9E9ESqfCVatiZdYw4rV26Zuf9EaQ9eVRqdjrz+OkCjq4I52+VACx4bd4J5ENLNe6d
         pq4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jgYLhQU1QcQ16+sYSDTfQf+bXsaV+p/ArPf3nYhwb/U=;
        b=ExIUnz9+zZSU3QMeSlvUVWwyRVGN3EbxWDSD16NSbsCtVbS5wduDIPSFGox7hl3mWy
         C2W/lp7cd/Jjp92pg630EOBfeeI/5cUDtmRYGvxmxWHzGzKaRdax6nauM72oqMOoQcY0
         sv0IeAuo+7ZQWo5lJngI8kU55vE2pCSQH+n3MMhcCYshVynJHY5X1QpngQp1/ymRuxUh
         pqBLGC+qZks1PcwT267/1473+aR6jslUzUpKu5zId3UpTPTRm9xzHtaQYtsgcEtLbeyc
         KlB1cPj/p6i0pCI1LgvvsO04/HLMWrmOGuXQitYBY+CTsG9tzYos4aLCo/Phvz2Bbw9m
         ZNDQ==
X-Gm-Message-State: AOAM532ZzFPc9VeT+0s+/Q5ZAIAOtXWz6pltgEU55ZzxG0DLtDYiWlz6
        AKvPUl9RixqF+L/oVTSvT3zm2g==
X-Google-Smtp-Source: ABdhPJwitGpEmkemiPIzKGaHsnaaXCsY2QI/fmj61DnfK50wvDZmy/kP1+iKjdobGPUMPUDUGi2shQ==
X-Received: by 2002:a05:622a:1350:: with SMTP id w16mr5940778qtk.394.1637752225861;
        Wed, 24 Nov 2021 03:10:25 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id s12sm7608225qtk.61.2021.11.24.03.10.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Nov 2021 03:10:25 -0800 (PST)
Message-ID: <07cd52bc-2e47-6365-db7e-076e8a9cfb51@mojatatu.com>
Date:   Wed, 24 Nov 2021 06:10:24 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v4 04/10] flow_offload: allow user to offload tc action to
 net device
Content-Language: en-US
To:     Baowen Zheng <baowen.zheng@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers <oss-drivers@corigine.com>
References: <20211118130805.23897-1-simon.horman@corigine.com>
 <20211118130805.23897-5-simon.horman@corigine.com>
 <cf194dc4-a7c9-5221-628b-ab26ceca9583@mojatatu.com>
 <DM5PR1301MB2172EFE3AC44E84D89D3D081E7609@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <404a4871-0e12-3cdc-e8c7-b0c85e068c53@mojatatu.com>
 <DM5PR1301MB21725BE79994CD548CEA0CC4E7619@DM5PR1301MB2172.namprd13.prod.outlook.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <DM5PR1301MB21725BE79994CD548CEA0CC4E7619@DM5PR1301MB2172.namprd13.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-11-23 21:11, Baowen Zheng wrote:
> On November 24, 2021 3:04 AM, Jamal Hadi Salim wrote:

[..]

>> The simplest approach seems to be adding a field in ops struct and call it
>> hw_id (we already have id which represents the s/w side).
>> All your code in flow_action_init() then becomes something like:
>>
>>          if (!fl_action)
>>                  return -EINVAL;
>>
>>          fl_action->extack = extack;
>>          fl_action->command = cmd;
>>          fl_action->index = act->tcfa_index;
>>
>>
>>          fl_action->id = act->hwid;
>>
>> And modules continue to work. Did i miss something?
>>
> Hi Jamal, for your suggestion, I think it will work for most of the case. But there maybe some kind of actions
> that will be assigned different hw_id in different case, such as the gact, we need to think about this case.
> So I will prefer to add a callback in action ops struct to implement the flow_action_init function for the new added
> Standalone action.
> WDYT?
> 

Yes, the callback makes sense. I imagine this would be needed also
if you offload mirred (selecting whether to mirror or redirect).

>>> Do you think it is proper to include this implement in our patch series or we
>> can delivery a new patch for this?
>>
>> Unless I am missing something basic, I dont see this as hard to do as explained
>> above in this patch series.
> I did not mean it is difficult.
> Since as my understanding, we will have the same problem in function of tc_setup_flow_action to
> Setup the actions for a to be offloaded flower. So my proposal is to add a callback in action ops to implement
> Both the function of flow_act_init and tc_setup_flow_action with a flag(maybe bind?) as a distinguish.
> What is your opinion?


See above. I agree with your suggestion.

cheers,
jamal
