Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D077470FC9
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 02:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbhLKBUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 20:20:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbhLKBUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 20:20:02 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA5FC061714;
        Fri, 10 Dec 2021 17:16:26 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id t9so17700228wrx.7;
        Fri, 10 Dec 2021 17:16:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=AxHH9vRhwGPm07IcTQ8179blz4W0PQRKXmHxrqE6RV0=;
        b=Zi93Qq6kbzmeZ3a8kwu7GvF/hyjTId08dSEpD7ra0JMYcYOoGuotuMGIOHTPpN8W+R
         sCibSbKrDLpn9eRM8/I9w1POH2VS7kj8mVdBBLSW9GJO8Ik//FWcvuPffrKFWctjG/MN
         9jB3qYd5BRjleXEtnrVz1qhSh7Ck0wrHbYbl2HCeTf9rxdnlX19c/ux/ahin2MkjLBOG
         L9+NOSek8CkAELzO7TE93/6dJ5gTC84s8KAv46Y2z1PaHk/wxnr9ap9PQ0x0o7LTVmir
         lac61oGJblAi7a11bhV1uuT7ORn601bgKE/jHBrjUupX2xZgVLjhbbgzRthGVZ/Vddhn
         oDqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=AxHH9vRhwGPm07IcTQ8179blz4W0PQRKXmHxrqE6RV0=;
        b=hmr/BTXMwFORJtBkfRVsBcuYN9wBZqO221W69ilSJUBzhiAXERmu5hRqVKZJUZqD7Q
         NLr6iskvL1xniiDbTOafyYMaXhXugzKkUMZqyF3/GNfC0uCxIjes9HWZD8YT9I5jC6b4
         6XcrxLtSvrGi6kf33vcpvo1di/BiFhBWG8Uu34qsvJXPr05wLnZE7OkO3H0sfvqDDKW7
         4nifBKbUCdFf9auwTY/KRyEq5nVsG79sVX38C1p7NGBGOM7P4krD+HNM71iz3BayCF+7
         uDErNju49/RAPeJtbXm9ciKnxUH8l1ulIc5CR+2D0i3AO9fXDdpUbL8yDTOPQLhF8+YG
         6Z6g==
X-Gm-Message-State: AOAM5333VSpi3eIESDXmmDXkemqM3BxvLNvnFRLXZrPu70gFGUFTcSQh
        BAW9QB9fTY6wvy+ZRFqbjbYqQ1yvXVE=
X-Google-Smtp-Source: ABdhPJwjULJaUlasiw9uZ4BWHdTS3TgD58EgxtsTv8OAJ8IrRIwvfkL0u2MHk1DJanwNHJu0itE95w==
X-Received: by 2002:a05:6000:2af:: with SMTP id l15mr2863099wry.640.1639185385102;
        Fri, 10 Dec 2021 17:16:25 -0800 (PST)
Received: from [192.168.8.198] ([185.69.145.149])
        by smtp.gmail.com with ESMTPSA id r15sm255353wmh.13.2021.12.10.17.16.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 17:16:24 -0800 (PST)
Message-ID: <5f7d2f60-b833-04e5-7710-fdd2ef3b6f67@gmail.com>
Date:   Sat, 11 Dec 2021 01:15:05 +0000
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
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211211003838.7u4lcqghcq2gqvho@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/11/21 00:38, Martin KaFai Lau wrote:
> On Fri, Dec 10, 2021 at 02:23:34AM +0000, Pavel Begunkov wrote:
>> cgroup_bpf_enabled_key static key guards from overhead in cases where
>> no cgroup bpf program of a specific type is loaded in any cgroup. Turn
>> out that's not always good enough, e.g. when there are many cgroups but
>> ones that we're interesting in are without bpf. It's seen in server
>> environments, but the problem seems to be even wider as apparently
>> systemd loads some BPF affecting my laptop.
>>
>> Profiles for small packet or zerocopy transmissions over fast network
>> show __cgroup_bpf_run_filter_skb() taking 2-3%, 1% of which is from
>> migrate_disable/enable(), and similarly on the receiving side. Also
>> got +4-5% of t-put for local testing.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   include/linux/bpf-cgroup.h | 24 +++++++++++++++++++++---
>>   kernel/bpf/cgroup.c        | 23 +++++++----------------
>>   2 files changed, 28 insertions(+), 19 deletions(-)
>>
>> diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
>> index 11820a430d6c..99b01201d7db 100644
>> --- a/include/linux/bpf-cgroup.h
>> +++ b/include/linux/bpf-cgroup.h
>> @@ -141,6 +141,9 @@ struct cgroup_bpf {
>>   	struct list_head progs[MAX_CGROUP_BPF_ATTACH_TYPE];
>>   	u32 flags[MAX_CGROUP_BPF_ATTACH_TYPE];
>>   
>> +	/* for each type tracks whether effective prog array is not empty */
>> +	unsigned long enabled_mask;
>> +
>>   	/* list of cgroup shared storages */
>>   	struct list_head storages;
>>   
>> @@ -219,11 +222,25 @@ int bpf_percpu_cgroup_storage_copy(struct bpf_map *map, void *key, void *value);
>>   int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
>>   				     void *value, u64 flags);
>>   
>> +static inline bool __cgroup_bpf_type_enabled(struct cgroup_bpf *cgrp_bpf,
>> +					     enum cgroup_bpf_attach_type atype)
>> +{
>> +	return test_bit(atype, &cgrp_bpf->enabled_mask);
>> +}
>> +
>> +#define CGROUP_BPF_TYPE_ENABLED(sk, atype)				       \
>> +({									       \
>> +	struct cgroup *__cgrp = sock_cgroup_ptr(&(sk)->sk_cgrp_data);	       \
>> +									       \
>> +	__cgroup_bpf_type_enabled(&__cgrp->bpf, (atype));		       \
>> +})
> I think it should directly test if the array is empty or not instead of
> adding another bit.
> 
> Can the existing __cgroup_bpf_prog_array_is_empty(cgrp, ...) test be used instead?

That was the first idea, but it's still heavier than I'd wish. 0.3%-0.7%
in profiles, something similar in reqs/s. rcu_read_lock/unlock() pair is
cheap but anyway adds 2 barrier()s, and with bitmasks we can inline
the check.

-- 
Pavel Begunkov
