Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3F138BB19
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 02:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235733AbhEUA6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 20:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235619AbhEUA6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 20:58:16 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48175C061574;
        Thu, 20 May 2021 17:56:54 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id v12so19363590wrq.6;
        Thu, 20 May 2021 17:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CmO2iZn0doU+XEZ1U69HTPgNIFN0orod8O0krl5SrrU=;
        b=GSNLUBtFL7ZVBOGV5h/gE94LunQioX+9y+HZkdQSmy6tLmFSZtamXd9C3NOZPwciFK
         z08roI9ZHCIMINOQfih7EMQN/thr7L3nhTdqRu1rQExwNw9G2t9kr3fye5RwuuD7Ebg3
         X2uYQTJs9ajdJ+yAKl7s1A9RHc5NohZ6dN9HfrKfBNM59tCGuHNG0a8L4t8Tc3ggZ8Yo
         Cvz6xVMf0p6NHqYNX1VWOH47j79o8MsVKKXm0+/GfaKRUbjm7CSdw/5DozSKAKe35uGZ
         2BPVGan2uMTnuundRVHIcgOQqEezt/bGzkTOGFxpRoEQ0jjXXp1GoAGSLblXgK4wkrbG
         a26A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CmO2iZn0doU+XEZ1U69HTPgNIFN0orod8O0krl5SrrU=;
        b=BF4qZxb7pSo2ZiCWPZBzL0T2eNlqw+CjAzpUDWDhpvrMdU7643s3RAx9YaoM30rmet
         l9PeUWIpJ1CCidZKR6JAK4qk3u8ZGdz0tgkFmipoV40rrWg32B0+t7Wl630Ek6G1Op6y
         FbaR6xbSsb8Vd7E4SfI4hyMs5lkntWRkDlySyWWppKfsoD/T8+MF5c6fK+sEqyIsOqco
         mh18QnYkkVZH/IcaskgfhLzM+9pNuzf/wzorfuxaQ8LNTvNrUy6o4KUUF3fjVCicGNF1
         hrVN1dH/mwrztx409k4fgpYFgv9NF33RK8hhMnjF1I9yXr1Qdfokgp+2jdZEPY99LOcE
         A2dg==
X-Gm-Message-State: AOAM530YXUQC7X9vAi3NYOnF3+Qy41UjeDMQgzQQpgkDdDF8JyrN5U/o
        azyydFtaWHKjBiVbg/LLaNA=
X-Google-Smtp-Source: ABdhPJyBxjEgx6rylBnehbzuYxsnoh5+xvZB/KbtC0wxiYhHpVYOa3pXapskFotw/DfIGlqsnTYZVg==
X-Received: by 2002:a5d:6d8f:: with SMTP id l15mr6665262wrs.313.1621558612887;
        Thu, 20 May 2021 17:56:52 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.236.182])
        by smtp.gmail.com with ESMTPSA id y2sm12356926wmq.45.2021.05.20.17.56.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 May 2021 17:56:52 -0700 (PDT)
To:     Song Liu <songliubraving@fb.com>
Cc:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        "Franz-B . Tuneke" <franz-bernhard.tuneke@tu-dortmund.de>,
        Christian Dietrich <stettberger@dokucode.de>
References: <cover.1621424513.git.asml.silence@gmail.com>
 <3883680d4638504e3dcf79bf1c15d548a9cb7f3e.1621424513.git.asml.silence@gmail.com>
 <5F31E9DE-9DB5-4FEB-AFAD-685F71093105@fb.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 12/23] bpf: add IOURING program type
Message-ID: <401b6453-2ee8-0a1e-1e83-221650e757b4@gmail.com>
Date:   Fri, 21 May 2021 01:56:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <5F31E9DE-9DB5-4FEB-AFAD-685F71093105@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/21/21 12:34 AM, Song Liu wrote:
>> On May 19, 2021, at 7:13 AM, Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> Draft a new program type BPF_PROG_TYPE_IOURING, which will be used by
>> io_uring to execute BPF-based requests.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>> fs/io_uring.c             | 21 +++++++++++++++++++++
>> include/linux/bpf_types.h |  2 ++
>> include/uapi/linux/bpf.h  |  1 +
>> kernel/bpf/syscall.c      |  1 +
>> kernel/bpf/verifier.c     |  5 ++++-
>> 5 files changed, 29 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 1a4c9e513ac9..882b16b5e5eb 100644
[...]
>> +BPF_PROG_TYPE(BPF_PROG_TYPE_IOURING, bpf_io_uring,
>> +	      void *, void *)
>>
>> BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY, array_map_ops)
>> BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_ARRAY, percpu_array_map_ops)
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index 4ba4ef0ff63a..de544f0fbeef 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -206,6 +206,7 @@ enum bpf_prog_type {
>> 	BPF_PROG_TYPE_EXT,
>> 	BPF_PROG_TYPE_LSM,
>> 	BPF_PROG_TYPE_SK_LOOKUP,
>> +	BPF_PROG_TYPE_IOURING,
>> };
>>
>> enum bpf_attach_type {
>> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
>> index 250503482cda..6ef7a26f4dc3 100644
>> --- a/kernel/bpf/syscall.c
>> +++ b/kernel/bpf/syscall.c
>> @@ -2041,6 +2041,7 @@ static bool is_net_admin_prog_type(enum bpf_prog_type prog_type)
>> 	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
>> 	case BPF_PROG_TYPE_CGROUP_SYSCTL:
>> 	case BPF_PROG_TYPE_SOCK_OPS:
>> +	case BPF_PROG_TYPE_IOURING:
>> 	case BPF_PROG_TYPE_EXT: /* extends any prog */
>> 		return true;
>> 	case BPF_PROG_TYPE_CGROUP_SKB:
>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>> index 0399ac092b36..2a53f44618a7 100644
>> --- a/kernel/bpf/verifier.c
>> +++ b/kernel/bpf/verifier.c
>> @@ -8558,6 +8558,9 @@ static int check_return_code(struct bpf_verifier_env *env)
>> 	case BPF_PROG_TYPE_SK_LOOKUP:
>> 		range = tnum_range(SK_DROP, SK_PASS);
>> 		break;
>> +	case BPF_PROG_TYPE_IOURING:
>> +		range = tnum_const(0);
>> +		break;
>> 	case BPF_PROG_TYPE_EXT:
>> 		/* freplace program can return anything as its return value
>> 		 * depends on the to-be-replaced kernel func or bpf program.
>> @@ -12560,7 +12563,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
>> 	u64 key;
>>
>> 	if (prog->aux->sleepable && prog->type != BPF_PROG_TYPE_TRACING &&
>> -	    prog->type != BPF_PROG_TYPE_LSM) {
>> +	    prog->type != BPF_PROG_TYPE_LSM && prog->type != BPF_PROG_TYPE_IOURING) {
> 
> Is IOURING program sleepable? If so, please highlight that in the commit log 

Supposed to work with both, sleepable and not, but with different set
of helpers. e.g. can't submit requests nor do bpf_copy_from_user() if
can't sleep. The only other difference in handling is rcu around
non-sleepable, but please shut out if I forgot anything

> and update the warning below. 

Sure

> 
>> 		verbose(env, "Only fentry/fexit/fmod_ret and lsm programs can be sleepable\n");
>> 		return -EINVAL;
>> 	}
>> -- 
>> 2.31.1
>>
> 

-- 
Pavel Begunkov
