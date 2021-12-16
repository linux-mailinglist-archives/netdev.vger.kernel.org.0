Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97FA4477307
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 14:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237229AbhLPNWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 08:22:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232110AbhLPNWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 08:22:05 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B1A4C061574;
        Thu, 16 Dec 2021 05:22:05 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id x15so87838339edv.1;
        Thu, 16 Dec 2021 05:22:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=60XSf9cHzUxT6ZkrcHjpgYMJcYBfPDQTULwlGLQzSnM=;
        b=kCx+JYRzpt9IsbUnF/BkdXilxvx4imVH7NBWYFmU9VtfhpKLH1EM4q0RvV1irbcAt2
         4OUo4eyzE7sMOK6tRXsc4xLVv/qtM792nz5NtADQWBjrap89Y/9E/DZxSBIHu7325r/R
         hIC/sGcS9qEiPwBXZAW5NovkyMWfLumPUtQmunPWnVoQUBiERx3rk/VkbLYBfkwVGO9y
         EsKuunqOtjcdR6HyMyyx/bPiRPdWzMwghOLxbC9p5Js1T6rGt75sjMvVBIJB63A2ZgLe
         5aMLTapxYRh8oYTA1blPPWVmnTomQhw8jhKlzJ1REvymCEuTgBEiSQF+CTWuRXtm5xsl
         2mGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=60XSf9cHzUxT6ZkrcHjpgYMJcYBfPDQTULwlGLQzSnM=;
        b=3F5Tup9UV2RED/P0mk5FA7AM5/ufsoxvyuKPjqylUTbFn7Mvgx82LG+2wzoJT/mKXo
         xDMWxl0QgvNOnbc64WYV/5YdqLzYmrsfLpXo+lhV5hX03c0dcR3Yxujbj0DgwWwxvZKJ
         kseEn2OxP+g0ThWs4gMx8USbqhAgmkFahl+GwNPRIWa8WGiC6ktBAHl41hgDpxNhO9f4
         0D6ZoEzKYRKso9r2uktbC00fLcQOCjQ7v56MiXShu7AJNShQPRuPXOa5FSK0gd+XrfB+
         SZ/2zYSVA6gPJHuPx/GzTevqvUZIcPRuCUTldA01u4qAKUXph+X2MwQVKMjOl/nDb9od
         5Iyg==
X-Gm-Message-State: AOAM533jfoUxBFP7DXZji6SqJrP5NcF3es96+NI9fuG40Mkfl6FJZvPU
        opTYy7h01uH4MqaUfUcCfvs=
X-Google-Smtp-Source: ABdhPJzNKXQY5diG8Cxb9pHPRUB7F1RD08f1ZucgR2b3lGFQEqnZF+Gahv7l9l3FM9jf/FfHySZvDQ==
X-Received: by 2002:a05:6402:1768:: with SMTP id da8mr20810877edb.252.1639660923591;
        Thu, 16 Dec 2021 05:22:03 -0800 (PST)
Received: from [192.168.8.198] ([185.69.144.117])
        by smtp.gmail.com with ESMTPSA id sd2sm1857108ejc.22.2021.12.16.05.22.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Dec 2021 05:22:02 -0800 (PST)
Message-ID: <7ca623df-73ed-9191-bec7-a4728f2f95e6@gmail.com>
Date:   Thu, 16 Dec 2021 13:21:26 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v3] cgroup/bpf: fast path skb BPF filtering
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, linux-kernel@vger.kernel.org
References: <462ce9402621f5e32f08cc8acbf3d9da4d7d69ca.1639579508.git.asml.silence@gmail.com>
 <Yboc/G18R1Vi1eQV@google.com>
 <b2af633d-aaae-d0c5-72f9-0688b76b4505@gmail.com>
 <Ybom69OyOjsR7kmZ@google.com>
 <634c2c87-84c9-0254-3f12-7d993037495c@gmail.com>
 <Yboy2WwaREgo95dy@google.com>
 <e729a63a-cded-da9c-3860-a90013b87e2d@gmail.com>
 <CAKH8qBv+GsPz3JTTmLZ+Q2iMSC3PS+bE1xOLbxZyjfno7hqpSA@mail.gmail.com>
 <92f69969-42dc-204a-4138-16fdaaebb78d@gmail.com>
 <CAKH8qBuZxBen871AWDK1eDcxJenK7UkSQCZQsHCPhk6nk9e=Ng@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAKH8qBuZxBen871AWDK1eDcxJenK7UkSQCZQsHCPhk6nk9e=Ng@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/15/21 22:07, Stanislav Fomichev wrote:
> On Wed, Dec 15, 2021 at 11:55 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 12/15/21 19:15, Stanislav Fomichev wrote:
>>> On Wed, Dec 15, 2021 at 10:54 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>>
>>>> On 12/15/21 18:24, sdf@google.com wrote:
[...]
>>>>> I can probably do more experiments on my side once your patch is
>>>>> accepted. I'm mostly concerned with getsockopt(TCP_ZEROCOPY_RECEIVE).
>>>>> If you claim there is visible overhead for a direct call then there
>>>>> should be visible benefit to using CGROUP_BPF_TYPE_ENABLED there as
>>>>> well.
>>>>
>>>> Interesting, sounds getsockopt might be performance sensitive to
>>>> someone.
>>>>
>>>> FWIW, I forgot to mention that for testing tx I'm using io_uring
>>>> (for both zc and not) with good submission batching.
>>>
>>> Yeah, last time I saw 2-3% as well, but it was due to kmalloc, see
>>> more details in 9cacf81f8161, it was pretty visible under perf.
>>> That's why I'm a bit skeptical of your claims of direct calls being
>>> somehow visible in these 2-3% (even skb pulls/pushes are not 2-3%?).
>>
>> migrate_disable/enable together were taking somewhat in-between
>> 1% and 1.5% in profiling, don't remember the exact number. The rest
>> should be from rcu_read_lock/unlock() in BPF_PROG_RUN_ARRAY_CG_FLAGS()
>> and other extra bits on the way.
> 
> You probably have a preemptiple kernel and preemptible rcu which most
> likely explains why you see the overhead and I won't (non-preemptible
> kernel in our env, rcu_read_lock is essentially a nop, just a compiler
> barrier).

Right. For reference tried out non-preemptible, perf shows the function
taking 0.8% with a NIC and 1.2% with a dummy netdev.


>> I'm skeptical I'll be able to measure inlining one function,
>> variability between boots/runs is usually greater and would hide it.
> 
> Right, that's why I suggested to mirror what we do in set/getsockopt
> instead of the new extra CGROUP_BPF_TYPE_ENABLED. But I'll leave it up
> to you, Martin and the rest.

-- 
Pavel Begunkov
