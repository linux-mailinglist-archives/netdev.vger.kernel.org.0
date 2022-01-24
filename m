Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 373724983C9
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 16:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235422AbiAXPtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 10:49:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbiAXPtW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 10:49:22 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA095C06173B;
        Mon, 24 Jan 2022 07:49:21 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id s18so14397881wrv.7;
        Mon, 24 Jan 2022 07:49:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=KF14cNo922qXUySZr8b4eXt5binLR7ntNn5ZLkuqMxI=;
        b=eW+zvFkn6EuVlgQoGWuKofVxTrQUe8wrRC5FTXhzP2PAchRpQl6gb/Hf+juoOrEKJK
         dBrlBWbnXxM4H1fTG8sZkp6iMQre309r6kzFgqJvwv1J22wfwm2ia7wulie+AQUjDSrJ
         uDCJuro0/0iC9q80ODMDTr0VI+2xUKai0Fb7AzfH5OE4Lg/Um9tf4CDaocbm1PfBG9bh
         2hENG6ikDn+Ax0WtSDyWucUcOinTy1xdCUmiEXgtZoU0skHKh1VPABeynDMoFj6C6SS2
         Vk6HBEFwNJE+pxZn88P2WW+gClxzbSsWFlvTP0ZBhKtGiI3/nYi0jcwlAcuQlc8N7aX/
         Lakw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KF14cNo922qXUySZr8b4eXt5binLR7ntNn5ZLkuqMxI=;
        b=FzJDKonQsnJfeAjHk7LKuF4mCQLDj0sqbxk4giNr9rpQoKTrQJoDXP5iZZY0GonyB0
         kfzESiapBdjKKu/Mqy0bVg3n2/zplmeqsvX686700kkFVc/wv00QakoqCxaqi+QHOqE8
         85dwnnx8dUDRYY8nWjTWKUWegq9FD86X0ZsLk2uFRHKR+IfH6xDeDTi/oR/jy5/E49Nt
         YnaXu4SAfGp1JydZj+HAGuMHmu7jHT0GnRbgCP3iWeW9cqH8mPkOTdHSPTLGMwIKayap
         +QQhbsK471oa+MpbNoDaYNq3ihVPWC4C19Myh1jYED0rj1YYltQz7hQJ5zhu284y1+B6
         tgMw==
X-Gm-Message-State: AOAM533/KQcqgLAyex9S3yWXw5tvUj6TgxKYAWXlCsmB7Q6E+DBpMlNn
        WtCj979bTex00PT1JLtNsb7MjU+WKDI=
X-Google-Smtp-Source: ABdhPJzP0ILdTkVAtjOkBVjTwukCZ7FikdQlrYj05PTF/qb+D2b96+lAqTig6V3ZB3XYSij8vk4N1A==
X-Received: by 2002:adf:e2c4:: with SMTP id d4mr14294936wrj.247.1643039360422;
        Mon, 24 Jan 2022 07:49:20 -0800 (PST)
Received: from [192.168.8.198] ([148.252.132.47])
        by smtp.gmail.com with ESMTPSA id 31sm17685504wrl.27.2022.01.24.07.49.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 07:49:20 -0800 (PST)
Message-ID: <9b8632f9-6d7a-738f-78dc-0287d441d1cc@gmail.com>
Date:   Mon, 24 Jan 2022 15:46:33 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3] cgroup/bpf: fast path skb BPF filtering
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
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
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAKH8qBuAZoVQddMUkyhur=WyQO5b=z9eom1RAwgwraXg2WTj5w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/16/21 18:24, Stanislav Fomichev wrote:
> On Thu, Dec 16, 2021 at 10:14 AM Martin KaFai Lau <kafai@fb.com> wrote:
>> On Thu, Dec 16, 2021 at 01:21:26PM +0000, Pavel Begunkov wrote:
>>> On 12/15/21 22:07, Stanislav Fomichev wrote:
>>>>> I'm skeptical I'll be able to measure inlining one function,
>>>>> variability between boots/runs is usually greater and would hide it.
>>>>
>>>> Right, that's why I suggested to mirror what we do in set/getsockopt
>>>> instead of the new extra CGROUP_BPF_TYPE_ENABLED. But I'll leave it up
>>>> to you, Martin and the rest.
>> I also suggested to try to stay with one way for fullsock context in v2
>> but it is for code readability reason.
>>
>> How about calling CGROUP_BPF_TYPE_ENABLED() just next to cgroup_bpf_enabled()
>> in BPF_CGROUP_RUN_PROG_*SOCKOPT_*() instead ?
> 
> SG!
> 
>> It is because both cgroup_bpf_enabled() and CGROUP_BPF_TYPE_ENABLED()
>> want to check if there is bpf to run before proceeding everything else
>> and then I don't need to jump to the non-inline function itself to see
>> if there is other prog array empty check.
>>
>> Stan, do you have concern on an extra inlined sock_cgroup_ptr()
>> when there is bpf prog to run for set/getsockopt()?  I think
>> it should be mostly noise from looking at
>> __cgroup_bpf_run_filter_*sockopt()?
> 
> Yeah, my concern is also mostly about readability/consistency. Either
> __cgroup_bpf_prog_array_is_empty everywhere or this new
> CGROUP_BPF_TYPE_ENABLED everywhere. I'm slightly leaning towards
> __cgroup_bpf_prog_array_is_empty because I don't believe direct
> function calls add any visible overhead and macros are ugly :-) But
> either way is fine as long as it looks consistent.

Martin, Stanislav, do you think it's good to go? Any other concerns?
It feels it might end with bikeshedding and would be great to finally
get it done, especially since I find the issue to be pretty simple.

-- 
Pavel Begunkov
