Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65DCA44086C
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 12:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbhJ3K47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 06:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231792AbhJ3K46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Oct 2021 06:56:58 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A8FC061570
        for <netdev@vger.kernel.org>; Sat, 30 Oct 2021 03:54:28 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id bj20so664611qkb.11
        for <netdev@vger.kernel.org>; Sat, 30 Oct 2021 03:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=OjsYwFbOPuJIikp5xBzjK59+hk61oiFo9XpTCYbCkWo=;
        b=xVVY6M4fIxtlwP6ZkcpevOjon5xpyEfo+8LLz+Ll+GTd4Q+qHjoTEu9xgsvu6UrdDo
         svMgdbAJKBAk1uM2d4EJwoAeapVz7h7MGyzRRXj+lPUEEzouqDvBomU+t+80HUdZmYBG
         ZE28OgR9kfXnNChWEGN6Ukh/n1MQFep2VmpTAkc8KqPD5uh90jat0piq6BNXF1pGky/z
         nXQ04cLSsQTR1h/Cy8tIMxISfqsI2mwKSifOaHocIWiIAjGU0i1xmE2mdXGos5HwZZQM
         BwNBkwvBA3xJHgrWKbDY+UJibY86CCSeaxvGeK8eENjoJKhB06oSZeU6eDvgXs5fwPHC
         n7Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OjsYwFbOPuJIikp5xBzjK59+hk61oiFo9XpTCYbCkWo=;
        b=VesOUuHyta2Rkd24KBCFBlN8RZxH7iHCtIc6rGTXFhPs+dQowPiPe8GJpgz6FOfRZb
         pvinMjIi7FgwrX/FJmaRWsTapGLXTfDY2frvyEJkoqMj3HoKJ2Gw/mEhTZUZf47CkOf2
         aqpJxzRWNTedNXNH9a3xyRqziKOJovG994291NKKLCTTJsGUPMVe9bzsQHzwnZuF0aNd
         Jsh5qtfLgYmIZfk+bWtVAEcUIX2HYhBipCzHI+JemEpF2CoZdfsIp0NPHixaAf8vKFR0
         vnuomSOtfNI0mR6OG8uEfWV3on3b6FH+pQ6xVAFlOepTk+3oDeYUcsYDU81n1l7JBjzE
         bh3g==
X-Gm-Message-State: AOAM531RF73inLPz2TeSN7MJqOEYFhnv5BOw+YwdGGweBApQ6PLacZRu
        edgWiA2KRSuPNaGMvFkWF18ZFtn8gAdmFQ==
X-Google-Smtp-Source: ABdhPJwmnJESceO4OWYR/9s4xF2CiJoQx9LVeo2AsgUJPoDe3p+Cc0qq6l7OUGZFDiYAWFjL+l83bg==
X-Received: by 2002:a37:ae41:: with SMTP id x62mr13550521qke.241.1635591267977;
        Sat, 30 Oct 2021 03:54:27 -0700 (PDT)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id o14sm6585932qtv.91.2021.10.30.03.54.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Oct 2021 03:54:27 -0700 (PDT)
Message-ID: <7147daf1-2546-a6b5-a1ba-78dfb4af408a@mojatatu.com>
Date:   Sat, 30 Oct 2021 06:54:25 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [RFC/PATCH net-next v3 8/8] flow_offload: validate flags of
 filter and actions
Content-Language: en-US
To:     Vlad Buslov <vladbu@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com, Baowen Zheng <baowen.zheng@corigine.com>
References: <20211028110646.13791-1-simon.horman@corigine.com>
 <20211028110646.13791-9-simon.horman@corigine.com>
 <ygnhilxfaexq.fsf@nvidia.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <ygnhilxfaexq.fsf@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-10-29 14:01, Vlad Buslov wrote:
> On Thu 28 Oct 2021 at 14:06, Simon Horman <simon.horman@corigine.com> wrote:
>> From: Baowen Zheng <baowen.zheng@corigine.com>
>>
>> Add process to validate flags of filter and actions when adding
>> a tc filter.
>>
>> We need to prevent adding filter with flags conflicts with its actions.
>>
>> Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
>> Signed-off-by: Louis Peens <louis.peens@corigine.com>
>> Signed-off-by: Simon Horman <simon.horman@corigine.com>
>> ---
>>   net/sched/cls_api.c      | 26 ++++++++++++++++++++++++++
>>   net/sched/cls_flower.c   |  3 ++-
>>   net/sched/cls_matchall.c |  4 ++--
>>   net/sched/cls_u32.c      |  7 ++++---
>>   4 files changed, 34 insertions(+), 6 deletions(-)
>>
>> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
>> index 351d93988b8b..80647da9713a 100644
>> --- a/net/sched/cls_api.c
>> +++ b/net/sched/cls_api.c
>> @@ -3025,6 +3025,29 @@ void tcf_exts_destroy(struct tcf_exts *exts)
>>   }
>>   EXPORT_SYMBOL(tcf_exts_destroy);
>>   
>> +static bool tcf_exts_validate_actions(const struct tcf_exts *exts, u32 flags)
>> +{
>> +#ifdef CONFIG_NET_CLS_ACT
>> +	bool skip_sw = tc_skip_sw(flags);
>> +	bool skip_hw = tc_skip_hw(flags);
>> +	int i;
>> +
>> +	if (!(skip_sw | skip_hw))
>> +		return true;
>> +
>> +	for (i = 0; i < exts->nr_actions; i++) {
>> +		struct tc_action *a = exts->actions[i];
>> +
>> +		if ((skip_sw && tc_act_skip_hw(a->tcfa_flags)) ||
>> +		    (skip_hw && tc_act_skip_sw(a->tcfa_flags)))
>> +			return false;
>> +	}
>> +	return true;
>> +#else
>> +	return true;
>> +#endif
>> +}
>> +
> 
> I know Jamal suggested to have skip_sw for actions, but it complicates
> the code and I'm still not entirely understand why it is necessary.

If the hardware can independently accept an action offload then
skip_sw per action makes total sense. BTW, my understanding is
_your_ hardware is capable as such at least for policers ;->
And such policers are then shared across filters.
Other than the architectural reason I may have missed something
because I dont see much complexity added as a result.
Are you more worried about slowing down the update rate?

cheers,
jamal
