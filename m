Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8B44710CE
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 03:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241847AbhLKCZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 21:25:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233583AbhLKCZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 21:25:16 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C8FC061714;
        Fri, 10 Dec 2021 18:21:40 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id n33-20020a05600c502100b0032fb900951eso10281902wmr.4;
        Fri, 10 Dec 2021 18:21:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=/6yvBb+/c9OeTvJt4mvrjb1eKqBxOO4eWlVO74xpdFA=;
        b=dU/sLd/KkLsc1OLM1LXrGZF8C3ro1RTFkh5dZNGw21BGyZalONWfgFG19D8uWvwrLq
         APJz4LPDx9EHYz5wx5D0GWC4ghMWXmFJmAcdSPIjKpNr5cAeiS/ofiMUgu/5hl6q6SxP
         pTH6IbqJMtb4zhDO3ypmtHf8mlIXO8Q/Ks/pKDM/pQzDCL7RNCDXE6PYQqXQI57tdlCF
         UNiHbLtX6+EXUx4yFXqeZb8FW0p2bpmoTH3asv6ww6pIvbR6qMclhmQdULVx4DfgJJ46
         JyCpCULzgqwlOcfy+g5z9IzOKxziRFM04eNKMRs3WiO2+6awStpO3CRKgJRjqaSfKJYY
         0ALQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/6yvBb+/c9OeTvJt4mvrjb1eKqBxOO4eWlVO74xpdFA=;
        b=xQH4b+j0hdv/vQBJeTcl8SphRl0gu1phl/ZQd/brjc77d5KYHtE896PIMWfGSahSg1
         H0fUIKMHrwzswsu/z4JvuATRJqolvgvooY8+Aqf1n3vJYithKNpNq7JPL0ASW9LMgYBw
         K0aeyU1WQU/06syThuQ0Lw9dcr2tMu5UbTD3plTuNQSFHjehcz9JFAPs1qDzXBPdVhHp
         UbhajZIT1OHkw6TMwbfHpUKlJXx4cobxbV9eTZzsWc28Txfmhkd407PWVP0SPu8zXgbB
         D0j/jwvRZs0VNuosa1it+xriM0LuYLw0YO614UKeyAiWCWHuR1vKi5snMYZaM9UJKxmR
         EtMQ==
X-Gm-Message-State: AOAM5310poerDpoII2K2uJy50gqKc4WewPVhX5tOgxd6OFvDt5L7jdq7
        tXvMS3qYidLfk3AINODvmaM4BLegXc8=
X-Google-Smtp-Source: ABdhPJxdYMdqc3P6ViD1PV9Ls9B84yNVrmZKnjk0LAJtDpqiCr6quPSKIj/HxMFjUn1JrytkYtUufw==
X-Received: by 2002:a7b:c008:: with SMTP id c8mr21090564wmb.87.1639189299434;
        Fri, 10 Dec 2021 18:21:39 -0800 (PST)
Received: from [192.168.8.198] ([185.69.145.149])
        by smtp.gmail.com with ESMTPSA id j40sm350276wms.19.2021.12.10.18.21.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 18:21:39 -0800 (PST)
Message-ID: <fa707ef9-d612-a3a4-1b2a-fc2b28a3ec5f@gmail.com>
Date:   Sat, 11 Dec 2021 02:20:13 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [BPF PATCH for-next] cgroup/bpf: fast path for not loaded skb BPF
 filtering
Content-Language: en-US
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, linux-kernel@vger.kernel.org
References: <d77b08bf757a8ea8dab3a495885c7de6ff6678da.1639102791.git.asml.silence@gmail.com>
 <20211211003838.7u4lcqghcq2gqvho@kafai-mbp.dhcp.thefacebook.com>
 <5f7d2f60-b833-04e5-7710-fdd2ef3b6f67@gmail.com>
 <20211211015656.tvufcnh5k4rrc7sw@kafai-mbp.dhcp.thefacebook.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211211015656.tvufcnh5k4rrc7sw@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/11/21 01:56, Martin KaFai Lau wrote:
> On Sat, Dec 11, 2021 at 01:15:05AM +0000, Pavel Begunkov wrote:
>> On 12/11/21 00:38, Martin KaFai Lau wrote:
>>> On Fri, Dec 10, 2021 at 02:23:34AM +0000, Pavel Begunkov wrote:
>>>> cgroup_bpf_enabled_key static key guards from overhead in cases where
>>>> no cgroup bpf program of a specific type is loaded in any cgroup. Turn
>>>> out that's not always good enough, e.g. when there are many cgroups but
>>>> ones that we're interesting in are without bpf. It's seen in server
>>>> environments, but the problem seems to be even wider as apparently
>>>> systemd loads some BPF affecting my laptop.
>>>>
>>>> Profiles for small packet or zerocopy transmissions over fast network
>>>> show __cgroup_bpf_run_filter_skb() taking 2-3%, 1% of which is from
>>>> migrate_disable/enable(), and similarly on the receiving side. Also
>>>> got +4-5% of t-put for local testing.
>>>>
>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>> ---
>>>>    include/linux/bpf-cgroup.h | 24 +++++++++++++++++++++---
>>>>    kernel/bpf/cgroup.c        | 23 +++++++----------------
>>>>    2 files changed, 28 insertions(+), 19 deletions(-)
>>>>
>>>> diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
>>>> index 11820a430d6c..99b01201d7db 100644
>>>> --- a/include/linux/bpf-cgroup.h
>>>> +++ b/include/linux/bpf-cgroup.h
>>>> @@ -141,6 +141,9 @@ struct cgroup_bpf {
>>>>    	struct list_head progs[MAX_CGROUP_BPF_ATTACH_TYPE];
>>>>    	u32 flags[MAX_CGROUP_BPF_ATTACH_TYPE];
>>>> +	/* for each type tracks whether effective prog array is not empty */
>>>> +	unsigned long enabled_mask;
>>>> +
>>>>    	/* list of cgroup shared storages */
>>>>    	struct list_head storages;
>>>> @@ -219,11 +222,25 @@ int bpf_percpu_cgroup_storage_copy(struct bpf_map *map, void *key, void *value);
>>>>    int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
>>>>    				     void *value, u64 flags);
>>>> +static inline bool __cgroup_bpf_type_enabled(struct cgroup_bpf *cgrp_bpf,
>>>> +					     enum cgroup_bpf_attach_type atype)
>>>> +{
>>>> +	return test_bit(atype, &cgrp_bpf->enabled_mask);
>>>> +}
>>>> +
>>>> +#define CGROUP_BPF_TYPE_ENABLED(sk, atype)				       \
>>>> +({									       \
>>>> +	struct cgroup *__cgrp = sock_cgroup_ptr(&(sk)->sk_cgrp_data);	       \
>>>> +									       \
>>>> +	__cgroup_bpf_type_enabled(&__cgrp->bpf, (atype));		       \
>>>> +})
>>> I think it should directly test if the array is empty or not instead of
>>> adding another bit.
>>>
>>> Can the existing __cgroup_bpf_prog_array_is_empty(cgrp, ...) test be used instead?
>>
>> That was the first idea, but it's still heavier than I'd wish. 0.3%-0.7%
>> in profiles, something similar in reqs/s. rcu_read_lock/unlock() pair is
>> cheap but anyway adds 2 barrier()s, and with bitmasks we can inline
>> the check.
> It sounds like there is opportunity to optimize
> __cgroup_bpf_prog_array_is_empty().
> 
> How about using rcu_access_pointer(), testing with &empty_prog_array.hdr,
> and then inline it?  The cgroup prog array cannot be all
> dummy_bpf_prog.prog.  If that could be the case, it should be replaced
> with &empty_prog_array.hdr earlier, so please check.

I'd need to expose and export empty_prog_array, but that should do.
Will try it out, thanks

-- 
Pavel Begunkov
