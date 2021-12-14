Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 822324744FF
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 15:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbhLNO3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 09:29:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbhLNO3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 09:29:18 -0500
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27E5C06173E
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 06:29:17 -0800 (PST)
Received: by mail-qk1-x72d.google.com with SMTP id a11so16832383qkh.13
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 06:29:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=yjWUXlXQ2mJxQZAi1VxuwDCLEOYgFs5wPpV16015MAs=;
        b=Z9cYnW1t2XJi/+mQ+DN7T2tPMp/5+IuWariSwWsU2g7YO1L9NBTFBiAdGT2JldV77C
         kYGPrMzcqCnhcEV+l0FHYYStTd7Rz+laPIIxJdObQJm/bjpLu/asPFL/kO0HrmMSZfAT
         qpod+SuBtYk9c0a2sX1gWOIsGRSdF35y4+9ltbfr/Z305LA+qf2Pv3zpw3vTdHSF4qOW
         haAnfb+KinSIhbMV4Gn+xanorrOfXCYpjFDqPQ5tP7jbbZqcYp4MAXngqAr5djZ0Ymbd
         cTuEpWQzvm1AkGDNKJcPvIXuYq3zNbTXArBaoeoxhqE2ljQEhC5Sw3juvDXqyjV7V0Q2
         TkYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yjWUXlXQ2mJxQZAi1VxuwDCLEOYgFs5wPpV16015MAs=;
        b=1LpfA6acD/eMgJK3Q4PtgyD4N5bZPrPcMu6S+9Mv6H9eOzETCWIRDiGBqwzZyS6Lt4
         LGekQfhOZ1nRh8nSXj5yeW3BOOVhZYoa6lsQbeRC+Qtx+esHBmMbXaBGN0ZMSMA67O9R
         W/RCiyjHc/J/I+QwUe53fJP2BbBfEmI8lX8xF2LrW8QYJz3JaHs4N/RaaO/x/5v41Q+Q
         +zCiIm7Dp8mqNJ2gU5Cr4ESEYgF60DPWTLqG4kJFO5qW1QZrbwGZZfOocWEViZEdGHJK
         iUXzo/xIoqHIDb7jYFk8PiskWZYHW5LKbm3gVG8pKqZ98ug3TlJgh62A+DhYHIvr/HAE
         1ZMQ==
X-Gm-Message-State: AOAM532zmqYG0ndt0OOJugtGAIA+tvNXaTxnVMIboAxotgWksZCMWgN/
        B09j/r2lMHVNIuNJaIRNdRIXQQ==
X-Google-Smtp-Source: ABdhPJzB26hYIcZtwX+JRuX/XjqtFnWcyoNli8VoljQ3n+oJemV8HLucCfVP1MBTkmueaR41jeDFIw==
X-Received: by 2002:a05:620a:3dd:: with SMTP id r29mr4352157qkm.208.1639492156862;
        Tue, 14 Dec 2021 06:29:16 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id t18sm25487qtw.64.2021.12.14.06.29.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Dec 2021 06:29:16 -0800 (PST)
Message-ID: <06a6d105-0661-81c1-350a-17d964931dc5@mojatatu.com>
Date:   Tue, 14 Dec 2021 09:29:15 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v6 net-next 08/12] flow_offload: add process to update
 action stats from hardware
Content-Language: en-US
To:     Baowen Zheng <baowen.zheng@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers <oss-drivers@corigine.com>
References: <20211209092806.12336-1-simon.horman@corigine.com>
 <20211209092806.12336-9-simon.horman@corigine.com>
 <c03a786e-6d21-1d93-2b97-9bf9a13250ef@mojatatu.com>
 <DM5PR1301MB2172002C966B5CC41EA6537AE7739@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <4a909bf2-a7a1-67f9-2d62-d6858d3553b9@mojatatu.com>
 <DM5PR1301MB2172C97E25E66520DEC901CFE7759@DM5PR1301MB2172.namprd13.prod.outlook.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <DM5PR1301MB2172C97E25E66520DEC901CFE7759@DM5PR1301MB2172.namprd13.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-12-14 08:43, Baowen Zheng wrote:
> On December 14, 2021 8:01 PM, Jamal Hadi Salim wrote:
>> On 2021-12-12 04:00, Baowen Zheng wrote:

[..]
>>
>> Still confused probably because this is one of those functions that are badly
>> named. Initially i thought that it was useful to call this function for both
>> offloaded vs non-offloaded stats. But it seems it is only useful for hw
>> offloaded stats? If so, please consider a patch for renaming this appropriately
>> for readability.
> Yes, it is only for hw offload stats and is used to sync the stats information from the
> Offloaded filter to the actions the filter referred to.
> 
> We will consider to add a patch to rename this function for readability.
>>
>> Regardless, two things:
>>
>> 1) In the old code the last two lines
>> +			a->used_hw_stats = used_hw_stats;
>> +			a->used_hw_stats_valid = used_hw_stats_valid;
>> inside the preempt check and with this they are outside.
>>
>> This is fine if the only reason we have this function is for h/w offload.
>>
>> 2) You introduced tcf_action_update_hw_stats() which also does preempt
>> disable/enable and seems to repeat some of the things you are doing as well
>> in this function?
> As I mentioned above, the function of tcf_exts_stats_update is used to sync the stats
> information from the offloaded filter to the actions the filter referred to.
> Then the new added function tcf_action_update_hw_stats() is used to sync the stats
> Information from the hw device that offloads this action.  So if the action is offloaded
> to hw as a single action, then it will not sync the stats from the hw filter.
>>
>>> Actually, since there is no vendor to support update single action stats from
>> hardware, so it is not obvious, we will post our implement support after these
>> patches set.
>>> Do you think if it make sense?
>>
>> Since you plan to have more patches:
>> If it doesnt affect your current goals then i would suggest you leave it to later.
>> The question is, with what you already have in this patchset, do we get
>> something functional and standalone?
>>
> What we will post later to support update single action stats from hardware is code for driver side,
> It will mainly implement the flow_offload_act_command of stats an action from hw in driver.
> 
> So i think it will proper to post the whole framework code in act_api and cls_api in this series.
> Then when we post the driver patch, we will not need to change the act/cls implement.
> 
> WDYT?

ok.

cheers,
jamal

