Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 630D947419B
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 12:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbhLNLkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 06:40:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbhLNLkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 06:40:32 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B63C061574;
        Tue, 14 Dec 2021 03:40:32 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id o13so31823125wrs.12;
        Tue, 14 Dec 2021 03:40:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=tZE9Uf/zO0inaZmRbvuRqxot+PIRh2tWu+dKPxMOdqc=;
        b=m9ZSdvRme+HRMZ2GdsjLYHJY3mI4qBPxRvPckASgY8ZNCLIx3j11u0lFbdzoC40D+3
         S7fSQdgzd6FROkrCjrj+G4fxwJl1YQ/pZiDgfHT3fxqgsSdIOmMtNj+sDUF4pm5dQ0ig
         JcB+Wyw+RguWuWxVoEtahQun9JAEMwLtDGYIYMsh8w360m88MlzM0aNoOolnE/PfsARr
         0rYTyxFUlHHB69NYPtuqx2cTpePfYt0KtsHU7pFtHC9o0c1puUglksQdwStcqi3KEwlE
         VnQ1fVe5hMNYIOkPZ9OEIySwhSSvytpNFczjpgr4qIziwNFzMS2AOoX7h3xRYVK8cqo6
         ENqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=tZE9Uf/zO0inaZmRbvuRqxot+PIRh2tWu+dKPxMOdqc=;
        b=l3FrIEb6RepgdxQ3hIZ3ocOUb/Bhgn99hURdc7MUaMqXsnbbCc7FWwEfIs7nHOPyZl
         4EI4JX1a22QuWsssxNNHnALsvSYsQ8/96CNxb5dPaM5evAmCPYK/hV1BrGUIvQFWsXZO
         nfbmMaiabyAhYRxY+5bSKkRvjKbeIBqYdXA14mKzKAB+WQhSJfQZFqrHortO7RaUNgm/
         4+6LUP+xwXAN7fZDOr2XM520bf2bj9PjxmAc53d9L9KDBBaRadrishev7ss4AA9RJOu3
         LUfwh0k59/5bqyUR64Sd9T7dPYhz9y56Ccq0iz+jjbp+U2MNKjzk8wIi1qvDy8lSYXAJ
         Okxg==
X-Gm-Message-State: AOAM532rDDq9VFwQUkYKXINju/Ouq4I4twid4/CotLkljbLrrRCfbDnv
        MKAdxYoULeh/4HqaG8gOC5M=
X-Google-Smtp-Source: ABdhPJxa/0zGOGZXPJd0U6H/QOjWyBxXx2O1XTJ6Cnuwc8L4zJpTPlFqlkO0yO4HCSu4RKWaL8RKTA==
X-Received: by 2002:a05:6000:1625:: with SMTP id v5mr5217846wrb.196.1639482030683;
        Tue, 14 Dec 2021 03:40:30 -0800 (PST)
Received: from [192.168.43.77] (82-132-228-129.dab.02.net. [82.132.228.129])
        by smtp.gmail.com with ESMTPSA id t189sm1852930wma.8.2021.12.14.03.40.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Dec 2021 03:40:30 -0800 (PST)
Message-ID: <3f89041e-685a-efa5-6405-8ea6a6cf83f3@gmail.com>
Date:   Tue, 14 Dec 2021 11:40:26 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v2] cgroup/bpf: fast path for not loaded skb BPF filtering
Content-Language: en-US
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, linux-kernel@vger.kernel.org
References: <d1b6d4756287c28faf9ad9ce824e1a62be9a5e84.1639200253.git.asml.silence@gmail.com>
 <20211214072716.jdemxmsavd6venci@kafai-mbp.dhcp.thefacebook.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211214072716.jdemxmsavd6venci@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/14/21 07:27, Martin KaFai Lau wrote:
> On Sat, Dec 11, 2021 at 07:17:49PM +0000, Pavel Begunkov wrote:
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
> What is t-put?  throughput?

yes

> Local testing means sending to lo/dummy?

yes, it was dummy specifically

> 
> [ ... ]
> 
>> diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
>> index 11820a430d6c..793e4f65ccb5 100644
>> --- a/include/linux/bpf-cgroup.h
>> +++ b/include/linux/bpf-cgroup.h
>> @@ -219,11 +219,28 @@ int bpf_percpu_cgroup_storage_copy(struct bpf_map *map, void *key, void *value);
>>   int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
>>   				     void *value, u64 flags);
>>   
>> +static inline bool
>> +__cgroup_bpf_prog_array_is_empty(struct cgroup_bpf *cgrp_bpf,
>> +				 enum cgroup_bpf_attach_type type)
> Lets remove this.
> 
>> +{
>> +	struct bpf_prog_array *array = rcu_access_pointer(cgrp_bpf->effective[type]);
>> +
>> +	return array == &empty_prog_array.hdr;
>> +}
>> +
>> +#define CGROUP_BPF_TYPE_ENABLED(sk, atype)				       \
> and change cgroup.c to directly use this instead, so
> everywhere holding a fullsock sk will use this instead
> of having two helpers for empty check.

Why? CGROUP_BPF_TYPE_ENABLED can't be a function atm because of header
dependency hell, and so it'd kill some of typization, which doesn't add
clarity. And also it imposes some extra overhead to *sockopt using
the first helper directly.

I think it's better with two of them. I could inline the second
one, but it wouldn't have been pretty.

> 
> [ ... ]
> 
>> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
>> index 2405e39d800f..fedc7b44a1a9 100644
>> --- a/kernel/bpf/core.c
>> +++ b/kernel/bpf/core.c
>> @@ -1967,18 +1967,10 @@ static struct bpf_prog_dummy {
>>   	},
>>   };
>>   
>> -/* to avoid allocating empty bpf_prog_array for cgroups that
>> - * don't have bpf program attached use one global 'empty_prog_array'
>> - * It will not be modified the caller of bpf_prog_array_alloc()
>> - * (since caller requested prog_cnt == 0)
>> - * that pointer should be 'freed' by bpf_prog_array_free()
>> - */
>> -static struct {
>> -	struct bpf_prog_array hdr;
>> -	struct bpf_prog *null_prog;
>> -} empty_prog_array = {
>> +struct bpf_empty_prog_array empty_prog_array = {
>>   	.null_prog = NULL,
>>   };
>> +EXPORT_SYMBOL(empty_prog_array);
> nit. Since it is exported, may be prefix it with 'bpf_'.

yeah, sure


-- 
Pavel Begunkov
