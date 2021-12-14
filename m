Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFD7474A3F
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 19:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236812AbhLNSAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 13:00:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233980AbhLNSAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 13:00:40 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0026EC061574;
        Tue, 14 Dec 2021 10:00:39 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id z7so4777553edc.11;
        Tue, 14 Dec 2021 10:00:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Jf9/Mox4KL/62xC50Mrh372DzPKEdFGUJXvc+BGzgWk=;
        b=GhKQYrnVLjaVzcGqjUJTTAqhPaifwQUxWafzt8TYRd1CW5E8yh33xnoHeFxPq4RaUM
         FN6+9Kb8TsfT0OIcKw81ERfx11g97Xqwqi28OOU2xrd6Qk/IRfR7HVPNl91BEwrOJoab
         zV8S6QmnISNov97IjBMq5Q/StaSzRDaW6UYyqpYiZetF3yfts+liGUukiMlRj+f+TtdL
         gcyZ3mVGNuwuMpvvvc+rjDvILmBNvP99t390huHx5We/6zqO1rmC3UxB6kQu3/3jkm3m
         +EjmBcb4untFzunlP+kjyHVmbtyiEWVPyx083kvSTAkSwif8sUPVX3M1dZFRIJxNijUA
         4ZwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Jf9/Mox4KL/62xC50Mrh372DzPKEdFGUJXvc+BGzgWk=;
        b=a7k4iCCEjQBfm2J2HWJpTlFzwh0Ch21b2atdGZwvmgcV5Yk1tuAk3gEt6hAYYMZ5Hg
         s0ufp84H85vIT3RDefte8VudtvILZ9yIZK5FQufImc7XjrjrKQwg8qF2D4JgWC9vkjhg
         4mO2e1G9Dzylty11NVgVCN9HuBuyt9HeY2NrHv9a4PKvqlKbymbbf6DXjwFQQZXqO2rq
         5TGmwZVX9majXc9no2iQGknuCRAyxeaCyJMTvxyES0zi5YjeTLe/eDutIeJjb67ln8A2
         o+UjSGXUo7aGF7alpY2Mbdnmpb2l0dDSsE1y3JNzdctrg+xgIThkjvVICpcK3SNDR+ji
         1RCw==
X-Gm-Message-State: AOAM5327d87WjNMQn2UXC1w0v6fo8uRZS4Qghmkx/Uf3w1B2ZULgSQdE
        8Cq9RDFEeKhESTpHpYqOqVZ81QxLMCI=
X-Google-Smtp-Source: ABdhPJyoUZaHM+6wKbhfA8fy04IlUBxzJDjYrOleFOAec0Rf01vvED0MzJGpxEtfNPtANo+AyzSsJw==
X-Received: by 2002:a05:6402:40d2:: with SMTP id z18mr9741870edb.395.1639504838620;
        Tue, 14 Dec 2021 10:00:38 -0800 (PST)
Received: from [192.168.8.198] ([148.252.129.75])
        by smtp.gmail.com with ESMTPSA id qw25sm163213ejc.185.2021.12.14.10.00.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Dec 2021 10:00:38 -0800 (PST)
Message-ID: <5e2bc4bc-e844-9a8c-2a95-0f55645b4392@gmail.com>
Date:   Tue, 14 Dec 2021 18:00:22 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [BPF PATCH for-next] cgroup/bpf: fast path for not loaded skb BPF
 filtering
Content-Language: en-US
To:     sdf@google.com
Cc:     Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, linux-kernel@vger.kernel.org
References: <d77b08bf757a8ea8dab3a495885c7de6ff6678da.1639102791.git.asml.silence@gmail.com>
 <20211211003838.7u4lcqghcq2gqvho@kafai-mbp.dhcp.thefacebook.com>
 <5f7d2f60-b833-04e5-7710-fdd2ef3b6f67@gmail.com>
 <20211211015656.tvufcnh5k4rrc7sw@kafai-mbp.dhcp.thefacebook.com>
 <fa707ef9-d612-a3a4-1b2a-fc2b28a3ec5f@gmail.com>
 <YbjaSNBlW03rX6c7@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <YbjaSNBlW03rX6c7@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/14/21 17:54, sdf@google.com wrote:
> On 12/11, Pavel Begunkov wrote:
>> On 12/11/21 01:56, Martin KaFai Lau wrote:
>> > On Sat, Dec 11, 2021 at 01:15:05AM +0000, Pavel Begunkov wrote:
>> > > That was the first idea, but it's still heavier than I'd wish. 0.3%-0.7%
>> > > in profiles, something similar in reqs/s. rcu_read_lock/unlock() pair is
>> > > cheap but anyway adds 2 barrier()s, and with bitmasks we can inline
>> > > the check.
>> > It sounds like there is opportunity to optimize
>> > __cgroup_bpf_prog_array_is_empty().
>> >
>> > How about using rcu_access_pointer(), testing with &empty_prog_array.hdr,
>> > and then inline it?  The cgroup prog array cannot be all
>> > dummy_bpf_prog.prog.  If that could be the case, it should be replaced
>> > with &empty_prog_array.hdr earlier, so please check.
> 
>> I'd need to expose and export empty_prog_array, but that should do.
>> Will try it out, thanks
> 
> Note that we already use __cgroup_bpf_prog_array_is_empty in
> __cgroup_bpf_run_filter_setsockopt/__cgroup_bpf_run_filter_getsockopt
> for exactly the same purpose. If you happen to optimize it, pls
> update these places as well.

Just like it's already done in the patch? Or maybe you mean something else?

-- 
Pavel Begunkov
