Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95B2F475E6D
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 18:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245240AbhLORSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 12:18:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235266AbhLORSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 12:18:07 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE784C061574;
        Wed, 15 Dec 2021 09:18:06 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id g14so76429155edb.8;
        Wed, 15 Dec 2021 09:18:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=R6JXxO0z/aU0JUYWCi/S32PK2Eed5dPgoRU+PPyekKQ=;
        b=MfCEEiy5VLUR51ho/kqi8XwRfkj/qds68rR2pLPtKRnBkh5r1De7bUWtXmWJcnrCuc
         BKu5VvFE4vW3Uskh+24hyV5emoW4L+z6XFjcFTunXythtzMrkqHmQxPRhdljaQjaOZx8
         5hKHisfaMm09I3BlyPmvG/ropaUF4MXixMLIKYdNfAIg36rjrtyt4ZIxmEgC4ZTE4BAm
         Qakj7VJc3ugOzFuUJwTVki8yj5NxL0ShcsePA9kmV0m9E30xTflE/oRcw/My4taZ3eIa
         ASuW5IT4hwNgfqVIMnOjBd7dd6h2FprSdV2OSR0jmXMRHxOyMlxUy0hoSbn5U/HP9bMq
         iB8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=R6JXxO0z/aU0JUYWCi/S32PK2Eed5dPgoRU+PPyekKQ=;
        b=wCystA4upgOHYmkvTixByJrHSj9uMUAvxwAi31UOuauHe8WOyo06D7crJIH2hW41GI
         eKImC0ookoPiY3NBRBTvZuwzX8Ck4qPFnrqEHR66SGJXQvNkusXAYzbEBU4OeY7e/QQM
         uND/imVC1j/7oxZjQlS5ndnSNPLZg9lPpOztOeDrStRhpWrXxyVPw8J+2Iij9/VqPOi4
         0GDgXMdRBPJggtJMHiookUelPEOmHy5vr+EFWSswndQSLINQqmA8cQ95VGDKtTy7p7GV
         ssX9EkEFEV9UndrLKVqKOSnbM+JB0N3lCB5Nh/6unfBlqETeNM6sJIBsD3/UWAxzdLYY
         2XhQ==
X-Gm-Message-State: AOAM533OdilL5+d4SIFCU1qRdb2mQz/opzlqLeKg6yCYQMiM01BYHJdH
        OMQELjY03NpwYB8T5Q5Q9NI=
X-Google-Smtp-Source: ABdhPJxzH0drEvLcsDg93dMbOvVRIifpZ4Vl/jQcYozqfy3/IJWKsdNxjTw32CwOdxMFDPf/6N1rmQ==
X-Received: by 2002:a50:d594:: with SMTP id v20mr15537511edi.401.1639588683201;
        Wed, 15 Dec 2021 09:18:03 -0800 (PST)
Received: from [192.168.8.198] ([148.252.129.75])
        by smtp.gmail.com with ESMTPSA id t5sm1306591edd.68.2021.12.15.09.18.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 09:18:02 -0800 (PST)
Message-ID: <b2af633d-aaae-d0c5-72f9-0688b76b4505@gmail.com>
Date:   Wed, 15 Dec 2021 17:18:03 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v3] cgroup/bpf: fast path skb BPF filtering
Content-Language: en-US
To:     sdf@google.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, linux-kernel@vger.kernel.org
References: <462ce9402621f5e32f08cc8acbf3d9da4d7d69ca.1639579508.git.asml.silence@gmail.com>
 <Yboc/G18R1Vi1eQV@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Yboc/G18R1Vi1eQV@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/15/21 16:51, sdf@google.com wrote:
> On 12/15, Pavel Begunkov wrote:
>> Add per socket fast path for not enabled BPF skb filtering, which sheds
>> a nice chunk of send/recv overhead when affected. Testing udp with 128
>> byte payload and/or zerocopy with any payload size showed 2-3%
>> improvement in requests/s on the tx side using fast NICs across network,
>> and around 4% for dummy device. Same goes for rx, not measured, but
>> numbers should be relatable.
>> In my understanding, this should affect a good share of machines, and at
>> least it includes my laptops and some checked servers.
> 
>> The core of the problem is that even though there is
>> cgroup_bpf_enabled_key guarding from __cgroup_bpf_run_filter_skb()
>> overhead, there are cases where we have several cgroups and loading a
>> BPF program to one also makes all others to go through the slow path
>> even when they don't have any BPF attached. It's even worse, because
>> apparently systemd or some other early init loads some BPF and so
>> triggers exactly this situation for normal networking.
> 
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
> 
>> v2: replace bitmask appoach with empty_prog_array (suggested by Martin)
>> v3: add "bpf_" prefix to empty_prog_array (Martin)
> 
>>   include/linux/bpf-cgroup.h | 24 +++++++++++++++++++++---
>>   include/linux/bpf.h        | 13 +++++++++++++
>>   kernel/bpf/cgroup.c        | 18 ++----------------
>>   kernel/bpf/core.c          | 16 ++++------------
>>   4 files changed, 40 insertions(+), 31 deletions(-)
> 
>> diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
>> index 11820a430d6c..c6dacdbdf565 100644
>> --- a/include/linux/bpf-cgroup.h
>> +++ b/include/linux/bpf-cgroup.h
>> @@ -219,11 +219,28 @@ int bpf_percpu_cgroup_storage_copy(struct bpf_map *map, void *key, void *value);
>>   int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
>>                        void *value, u64 flags);
> 
>> +static inline bool
>> +__cgroup_bpf_prog_array_is_empty(struct cgroup_bpf *cgrp_bpf,
>> +                 enum cgroup_bpf_attach_type type)
>> +{
>> +    struct bpf_prog_array *array = rcu_access_pointer(cgrp_bpf->effective[type]);
>> +
>> +    return array == &bpf_empty_prog_array.hdr;
>> +}
>> +
>> +#define CGROUP_BPF_TYPE_ENABLED(sk, atype)                       \
>> +({                                           \
>> +    struct cgroup *__cgrp = sock_cgroup_ptr(&(sk)->sk_cgrp_data);           \
>> +                                           \
>> +    !__cgroup_bpf_prog_array_is_empty(&__cgrp->bpf, (atype));           \
>> +})
>> +
>>   /* Wrappers for __cgroup_bpf_run_filter_skb() guarded by cgroup_bpf_enabled. */
>>   #define BPF_CGROUP_RUN_PROG_INET_INGRESS(sk, skb)                  \
>>   ({                                          \
>>       int __ret = 0;                                  \
>> -    if (cgroup_bpf_enabled(CGROUP_INET_INGRESS))              \
>> +    if (cgroup_bpf_enabled(CGROUP_INET_INGRESS) && sk &&              \
>> +        CGROUP_BPF_TYPE_ENABLED((sk), CGROUP_INET_INGRESS))           \
> 
> Why not add this __cgroup_bpf_run_filter_skb check to
> __cgroup_bpf_run_filter_skb? Result of sock_cgroup_ptr() is already there
> and you can use it. Maybe move the things around if you want
> it to happen earlier.

For inlining. Just wanted to get it done right, otherwise I'll likely be
returning to it back in a few months complaining that I see measurable
overhead from the function call :)

-- 
Pavel Begunkov
