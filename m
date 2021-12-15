Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB3A475FE6
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 18:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238892AbhLORxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 12:53:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238803AbhLORxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 12:53:43 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B2FC061574;
        Wed, 15 Dec 2021 09:53:42 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id t5so77512190edd.0;
        Wed, 15 Dec 2021 09:53:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=dj9STCW35+KV4XMZV8rynGnxwCmpuT57Z/AN2A/co+Y=;
        b=hZDTC2mwYNLPIX0WGNjZtZ/fgBJXfQHoePIkB/vl5StCCmvt3rauRKLaE6kz9R3Xy9
         8ewaZQIj6hbXttzELjKv9kyUrk07EwD/DXsPNikwaDEo7EZ4Fy8vQN27riP5eMMo0GKe
         kbMDP6rXhOb9HR7GRv/gCj5+9A+rZ1dQ5A9Aa6+Ys6FdBVVRFX21CJIxwuY7XebALQUH
         zVAeI+DnCDMDm7dQwFqp8XDszutG97H+VPQox1nYCJ7XPKc98tgZbnBTP3CpzCzBsc74
         Utvz/R6BcOCsmwpywzapl4NVMoxDvHAZVSDfswMHMQSmyoZYUX1bHrd0lobwjXJf7xmy
         6uUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dj9STCW35+KV4XMZV8rynGnxwCmpuT57Z/AN2A/co+Y=;
        b=Uj9/4m8PQ5fa3/UqeCgFfMeKS23N68DWoFDSFnb60fBGlhMXq1ckvKcqprrOu4TPu3
         CbwptYTlTQNjPWMwnsVBw6kH9dsY/xP3iDhyBcXA3FnZJ5aFPf9DzzMMZVzKYz0OASAo
         6xFBdArrSoMJK9SKG66mGZciiPiSsnR8S+GAtREd4XsY1P4q1R0DUKR9Tw/EsrrF6kfR
         z9pDVZD/7jtPeFPJv+ev5i1Al5hpCo7Qop92+qtBO82xHKkTzdIhYVQg8Ru1xw/mGMP+
         UPoyra4x/p6uFVI8ZF+4MmWwR8bELjn9Q61ltjqBUPosISr34NwdlMqKUDbBsMXL3w9C
         SI5A==
X-Gm-Message-State: AOAM533Tpp6ww6J1NyOHrGPYSGaHEwYAhVy/515fQ9NKjrudAQ09FBhe
        0v+GeuimND7RPEMrOYjD1FM=
X-Google-Smtp-Source: ABdhPJzKgF3EyroFIel5bWr74myfZL7WZCg8AM9F5DBSP21L60xAz7uimsnTvb711pXLosRbAHMFng==
X-Received: by 2002:a05:6402:270a:: with SMTP id y10mr16336123edd.152.1639590821591;
        Wed, 15 Dec 2021 09:53:41 -0800 (PST)
Received: from [192.168.8.198] ([148.252.129.75])
        by smtp.gmail.com with ESMTPSA id hs8sm1033737ejc.53.2021.12.15.09.53.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 09:53:41 -0800 (PST)
Message-ID: <634c2c87-84c9-0254-3f12-7d993037495c@gmail.com>
Date:   Wed, 15 Dec 2021 17:53:42 +0000
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
 <b2af633d-aaae-d0c5-72f9-0688b76b4505@gmail.com>
 <Ybom69OyOjsR7kmZ@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Ybom69OyOjsR7kmZ@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/15/21 17:33, sdf@google.com wrote:
> On 12/15, Pavel Begunkov wrote:
>> On 12/15/21 16:51, sdf@google.com wrote:
>> > On 12/15, Pavel Begunkov wrote:
>> > > � /* Wrappers for __cgroup_bpf_run_filter_skb() guarded by cgroup_bpf_enabled. */
>> > > � #define BPF_CGROUP_RUN_PROG_INET_INGRESS(sk, skb)����������������� \
>> > > � ({����������������������������������������� \
>> > > ����� int __ret = 0;��������������������������������� \
>> > > -��� if (cgroup_bpf_enabled(CGROUP_INET_INGRESS))������������� \
>> > > +��� if (cgroup_bpf_enabled(CGROUP_INET_INGRESS) && sk &&������������� \
>> > > +������� CGROUP_BPF_TYPE_ENABLED((sk), CGROUP_INET_INGRESS))���������� \
>> >
>> > Why not add this __cgroup_bpf_run_filter_skb check to
>> > __cgroup_bpf_run_filter_skb? Result of sock_cgroup_ptr() is already there
>> > and you can use it. Maybe move the things around if you want
>> > it to happen earlier.
> 
>> For inlining. Just wanted to get it done right, otherwise I'll likely be
>> returning to it back in a few months complaining that I see measurable
>> overhead from the function call :)
> 
> Do you expect that direct call to bring any visible overhead?
> Would be nice to compare that inlined case vs
> __cgroup_bpf_prog_array_is_empty inside of __cgroup_bpf_run_filter_skb
> while you're at it (plus move offset initialization down?).

Sorry but that would be waste of time. I naively hope it will be visible
with net at some moment (if not already), that's how it was with io_uring,
that's what I see in the block layer. And in anyway, if just one inlined
won't make a difference, then 10 will.

-- 
Pavel Begunkov
