Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 890C23FAFAF
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 04:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234214AbhH3CKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 22:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbhH3CKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 22:10:39 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8F5AC061575
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 19:09:46 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id r13so10570888pff.7
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 19:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=MNnaJpBEWFElTOsSka1jtON3K7EKeZX+2oTL5KqAaz8=;
        b=dqwJd2/WNCnuuxK+StHtfL28pLy97nFL8LFMf2J5+Cg/+6IOPFyUWGu55/5DzrQDXY
         0l0Wcuyhz/aFUi76LMs0th1MP1tTY/Hbik+cdhJgQ5Z3+gag63xwham0DtQ7/KGAxm8B
         vJ2fL5Rgl1Xerolmm5WS+z9ZRfesTuPa2lkoXi+GvJ/wVw07l3l5M2sW4fVUzBhA7JMd
         HD9t4uXOFoWDoeVq8kNfSJIwRhLPk3ONgpNgBLc+fuySs6QCSA2+mEiTonlTXXzHOz5h
         jrNO4tIb4/oGn6D2E1JjF/X8FNEm9ZDlr1EOJZZAN44GnY1IiI4CYa3WTlKFIRbn5E16
         Ol6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=MNnaJpBEWFElTOsSka1jtON3K7EKeZX+2oTL5KqAaz8=;
        b=RvPriNdOg/XoYn00PTc8fuOBWOzDqEznYhUJs5NoVkYPUAJFxzyb3B7SG+D9LXhvs+
         q22LLBUzzZS/Szf+R1YDaUHSo96pO7BTorBNcfzy2LudNjxdiiDxGrIkt25/5hQAtxtR
         mPUc4/z8MFotfTWC62Xg3LupjzJjhNvDLNsvHe2ThGw46YnuNwsulPIjl8nyXlYDnclX
         KykA6t/q0A73BCnPy426e+VJ+YIXrlyDunisaCm7lYNFnJv1xcJP8oD2liML1AtH7qc7
         Ug4gSrTvl4yF57/vkx/oUx14aBo0x3kXcgK4QeGKIF5t9Wy9oFYnGUQ3zvFAOJFlxxHP
         r6NA==
X-Gm-Message-State: AOAM530MZPovL9V2R/YVsKZVEJJAlI8gPCBU7JQkO4dHpb4ZvHSSPrSo
        VbtNzoHJPYqCPFyPSfJKT0A=
X-Google-Smtp-Source: ABdhPJz/5oM6aRFg1/PgGcwOkpRcJwIpL0I04uLad8EhtnNAtU6mF40c262FFcfiF2k/3eh1eWHZ3g==
X-Received: by 2002:a63:5942:: with SMTP id j2mr19809673pgm.78.1630289386292;
        Sun, 29 Aug 2021 19:09:46 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.31])
        by smtp.gmail.com with ESMTPSA id l18sm12631847pff.24.2021.08.29.19.09.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Aug 2021 19:09:45 -0700 (PDT)
Subject: Re: [PATCH] net:sched fix array-index-out-of-bounds in taprio_change
From:   Haimin Zhang <tcs.kernel@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>, vinicius.gomes@intel.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     Haimin Zhang <tcs_kernel@tencent.com>
References: <1628658609-1208-1-git-send-email-tcs_kernel@tencent.com>
 <303b095e-3342-9461-16ae-86d0923b7dc7@gmail.com>
 <e965fed3-89c3-ff58-a678-dd715a2b9fcd@gmail.com>
Message-ID: <66e9214c-7c70-eec6-5028-bab137754bd3@gmail.com>
Date:   Mon, 30 Aug 2021 10:09:38 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <e965fed3-89c3-ff58-a678-dd715a2b9fcd@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi，i wonder to know what‘s going on with this patch ?
are you plannig to merge it ?


在 2021/8/11 16:36, Haimin Zhang 写道:
> 
> 
> 在 2021/8/11 15:44, Eric Dumazet 写道:
>>
>>
>> On 8/11/21 7:10 AM, tcs.kernel@gmail.com wrote:
>>> From: Haimin Zhang <tcs_kernel@tencent.com>
>>>
>>> syzbot report an array-index-out-of-bounds in taprio_change
>>> index 16 is out of range for type '__u16 [16]'
>>> that's because mqprio->num_tc is lager than TC_MAX_QUEUE,so we check
>>> the return value of netdev_set_num_tc.
>>>
>>> Reported-by: syzbot+2b3e5fb6c7ef285a94f6@syzkaller.appspotmail.com
>>> Signed-off-by: Haimin Zhang <tcs_kernel@tencent.com>
>>> ---
>>>   net/sched/sch_taprio.c | 4 +++-
>>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
>>> index 9c79374..1ab2fc9 100644
>>> --- a/net/sched/sch_taprio.c
>>> +++ b/net/sched/sch_taprio.c
>>> @@ -1513,7 +1513,9 @@ static int taprio_change(struct Qdisc *sch, 
>>> struct nlattr *opt,
>>>       taprio_set_picos_per_byte(dev, q);
>>>       if (mqprio) {
>>> -        netdev_set_num_tc(dev, mqprio->num_tc);
>>> +        err = netdev_set_num_tc(dev, mqprio->num_tc);
>>> +        if (err)
>>> +            goto free_sched;
>>>           for (i = 0; i < mqprio->num_tc; i++)
>>>               netdev_set_tc_queue(dev, i,
>>>                           mqprio->count[i],
>>>
>>
>> When was the bug added ?
>>
>> Hint: Please provide a Fixes: tag
>>
>> taprio_parse_mqprio_opt() already checks :
>>
>> /* Verify num_tc is not out of max range */
>> if (qopt->num_tc > TC_MAX_QUEUE) {
>>      NL_SET_ERR_MSG(extack, "Number of traffic classes is outside 
>> valid range");
>>      return -EINVAL;
>> }
>>
>> So what is happening exactly ?
>>
>>
>>
>>
> syzkaller reported this problem,the log shows mqprio->count[16] is 
> accessed.
> here is the log
> https://syzkaller.appspot.com/bug?id=3a3677d4e7539ec5e671a81e32882ad40b5f7b64 
> 
> 
> the added check logic is hurtlessness,and netdev_set_num_tc does have a 
> return value.
