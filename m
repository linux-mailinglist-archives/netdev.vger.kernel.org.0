Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7767249BB9D
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 19:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233776AbiAYSz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 13:55:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231865AbiAYSzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 13:55:40 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5448DC06173B;
        Tue, 25 Jan 2022 10:55:37 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id z22so64772509edd.12;
        Tue, 25 Jan 2022 10:55:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=dImgiAhROth/y9Q7puzLJb/vBES0iEIrDyLBhYakYAI=;
        b=ao7GO+W+V/9V61dpGwBLk1VnJMjMkObtBPM8LSgBA1NOJg4g0CV5aZ5b8CqYPxi8hw
         9p7F9ybxKmXn/MhvLyD6sWL5HBYg+OPH568Jt6EZmYIauUJH6XIl+YWUFlB/wFhNKfA+
         OjoL7RQrpjk4Iff5ENzadIn/p5qps08XEkUR8kwsLvYNB8D6y8bPbvZUxPF/gpwhvlSU
         xyh2RVp49O00ryc8UqbKwaVSIuYxFsB6SULWcPKZLHzRsW6Ij4ui7F7VKI7WkG5xyx4q
         qdltEkAYgfcS0IPIXByYLTcr9a+yWkWf5KtH/+ythLCH8BrK5wT2FtbEwSyPnb+bkaQH
         l9tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dImgiAhROth/y9Q7puzLJb/vBES0iEIrDyLBhYakYAI=;
        b=gixNnlKSKbXMfnHrwc4AnXm3J+XQstHu8F6gIXQ4OKCQW2Fxdv0oo+LsSI7QWKtNAI
         ZJOi14ERAiprl3PbA4HM6zdniG5j6QiyMIxTnDuYWABNS1aInrSGyEtb9JXfNr3vywEB
         F/SWhH6Gvsxvhs4cxnCaC0psudIM17bEMVoYKdLsnwEzjom/CWn+44DIL/q+/MGjPipE
         nIXiPUh03AEgR716qCiqTFUIrJJGVMcMf+YFqoGtKqEqa7njC+mx/0VxCMZz7l532iJ+
         EDJ6ivnMYinuLBjt62y0gWqiqX5v/v+GCKJOXRuliNhpJ8PYUfTjO2zG74s7eJn45yeE
         KKhw==
X-Gm-Message-State: AOAM530dynfUvVm18qKl02VAmzryGb6oqQsqwaV+OPr95mfi8+GezHAM
        acX5qZIFz6U66hifUh4priE=
X-Google-Smtp-Source: ABdhPJxQPbPHUSC1k2iBlm7YhwmNdqJ9aVrvQaAgARhfkch2YJaOGr9ttI0Na4589qbDfeGou65m9g==
X-Received: by 2002:a05:6402:2794:: with SMTP id b20mr11231560ede.340.1643136935787;
        Tue, 25 Jan 2022 10:55:35 -0800 (PST)
Received: from [192.168.8.198] ([85.255.233.187])
        by smtp.gmail.com with ESMTPSA id b30sm8725582edn.16.2022.01.25.10.55.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 10:55:35 -0800 (PST)
Message-ID: <ea0b2f62-9145-575e-d007-cce2c7244f77@gmail.com>
Date:   Tue, 25 Jan 2022 18:54:23 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3] cgroup/bpf: fast path skb BPF filtering
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, linux-kernel@vger.kernel.org
References: <Yboc/G18R1Vi1eQV@google.com>
 <b2af633d-aaae-d0c5-72f9-0688b76b4505@gmail.com>
 <Ybom69OyOjsR7kmZ@google.com>
 <634c2c87-84c9-0254-3f12-7d993037495c@gmail.com>
 <Yboy2WwaREgo95dy@google.com>
 <e729a63a-cded-da9c-3860-a90013b87e2d@gmail.com>
 <CAKH8qBv+GsPz3JTTmLZ+Q2iMSC3PS+bE1xOLbxZyjfno7hqpSA@mail.gmail.com>
 <92f69969-42dc-204a-4138-16fdaaebb78d@gmail.com>
 <CAKH8qBuZxBen871AWDK1eDcxJenK7UkSQCZQsHCPhk6nk9e=Ng@mail.gmail.com>
 <7ca623df-73ed-9191-bec7-a4728f2f95e6@gmail.com>
 <20211216181449.p2izqxgzmfpknbsw@kafai-mbp.dhcp.thefacebook.com>
 <CAKH8qBuAZoVQddMUkyhur=WyQO5b=z9eom1RAwgwraXg2WTj5w@mail.gmail.com>
 <9b8632f9-6d7a-738f-78dc-0287d441d1cc@gmail.com>
 <CAKH8qBvX8_vy0aYhiO-do0rh3y3CzgDGfHqt1bB6uRcr_DxncQ@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAKH8qBvX8_vy0aYhiO-do0rh3y3CzgDGfHqt1bB6uRcr_DxncQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/24/22 18:25, Stanislav Fomichev wrote:
> On Mon, Jan 24, 2022 at 7:49 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 12/16/21 18:24, Stanislav Fomichev wrote:
>>> On Thu, Dec 16, 2021 at 10:14 AM Martin KaFai Lau <kafai@fb.com> wrote:
>>>> On Thu, Dec 16, 2021 at 01:21:26PM +0000, Pavel Begunkov wrote:
>>>>> On 12/15/21 22:07, Stanislav Fomichev wrote:
>>>>>>> I'm skeptical I'll be able to measure inlining one function,
>>>>>>> variability between boots/runs is usually greater and would hide it.
>>>>>>
>>>>>> Right, that's why I suggested to mirror what we do in set/getsockopt
>>>>>> instead of the new extra CGROUP_BPF_TYPE_ENABLED. But I'll leave it up
>>>>>> to you, Martin and the rest.
>>>> I also suggested to try to stay with one way for fullsock context in v2
>>>> but it is for code readability reason.
>>>>
>>>> How about calling CGROUP_BPF_TYPE_ENABLED() just next to cgroup_bpf_enabled()
>>>> in BPF_CGROUP_RUN_PROG_*SOCKOPT_*() instead ?
>>>
>>> SG!
>>>
>>>> It is because both cgroup_bpf_enabled() and CGROUP_BPF_TYPE_ENABLED()
>>>> want to check if there is bpf to run before proceeding everything else
>>>> and then I don't need to jump to the non-inline function itself to see
>>>> if there is other prog array empty check.
>>>>
>>>> Stan, do you have concern on an extra inlined sock_cgroup_ptr()
>>>> when there is bpf prog to run for set/getsockopt()?  I think
>>>> it should be mostly noise from looking at
>>>> __cgroup_bpf_run_filter_*sockopt()?
>>>
>>> Yeah, my concern is also mostly about readability/consistency. Either
>>> __cgroup_bpf_prog_array_is_empty everywhere or this new
>>> CGROUP_BPF_TYPE_ENABLED everywhere. I'm slightly leaning towards
>>> __cgroup_bpf_prog_array_is_empty because I don't believe direct
>>> function calls add any visible overhead and macros are ugly :-) But
>>> either way is fine as long as it looks consistent.
>>
>> Martin, Stanislav, do you think it's good to go? Any other concerns?
>> It feels it might end with bikeshedding and would be great to finally
>> get it done, especially since I find the issue to be pretty simple.
> 
> I'll leave it up to the bpf maintainers/reviewers. Personally, I'd
> still prefer a respin with a consistent
> __cgroup_bpf_prog_array_is_empty or CGROUP_BPF_TYPE_ENABLED everywhere
> (shouldn't be a lot of effort?)

I can make CGROUP_BPF_TYPE_ENABLED() used everywhere, np.

I'll leave out unification with cgroup_bpf_enabled() as don't
really understand the fullsock dancing in
BPF_CGROUP_RUN_PROG_INET_EGRESS(). Any idea whether it's needed
and/or how to shove it out of inlined checks?

-- 
Pavel Begunkov
