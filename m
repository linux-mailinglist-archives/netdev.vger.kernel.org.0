Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDB225520E
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 03:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728196AbgH1BBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 21:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgH1BBE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 21:01:04 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68FAFC061264
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 18:01:04 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id o2so3638749qvk.6
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 18:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tk6QtLhNuynZ2/uc5+DBO8C0QQRF5WYIgM4ZJQi4M3I=;
        b=iRUPG28Bu4FjAQK+lLcx02ZLMllmdQHUUSv7cCyiPd/9NOvUeLBOuGuf9+/BGhEYPG
         ezSx8HWqSYzfvKdogYC2V8siR+YmA5DzYlcYPP4Cuwvc0Qz12o7h7tBakb87qk4y2uH6
         tWOI3XWJkq5Qtm88WDBspgNaCy34nic5mgm2olagGoKLbSrFu8gBvZAQilm+OetrSuQQ
         osoAtGpLUhlDH/2QkWSlLo8mDD63fXWqal6gQvMFU94+neR0+glBYc8cZ2Ys/1518YPP
         iBAsrimD+NVDiN/XMM7w7JpsV1tNv0I7ZUXBHa2Nd6Q0zWk+1crA1X0BEpxjf6sbwWza
         8P2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tk6QtLhNuynZ2/uc5+DBO8C0QQRF5WYIgM4ZJQi4M3I=;
        b=Ivdk6xpZtC/IHL+rKgUtKTRN8jZnxB0ZmvO5eVXlD1VsQjTrF1OV2Nw71DhkSqZ/Cd
         h96ijUXlDA+6eCJTmU9PQowIYBW1WdhAjbEVWcOzuyNOm38WN9trR2FoXaAhdI83wpF3
         dST0MnVNEJDn7B3tKP1/qaWPyRbfGb41+Nf38lhUBBwENioYuualdq7+EJreFCRM9JGV
         Wmos5/8ZX4ZCcfy2CnKStTb6N/2sfXZ7iUK6Kg5/cHtWcpptQwafvUie3+OGs/YRQT9p
         SDRhJ6xrJ1YYLgCKTPdHfzVkfhAoMd63f553vrTOUCRC3BdA+qM39lnTnN48c+4U1Etj
         bA9Q==
X-Gm-Message-State: AOAM530QaYRD7Czhsy08nQv3oQRP7R9DAhQYLD4gLPL4lxrVGzowkOkd
        hqB0T6JIeH1LCHFHdSkN5lDc3Q==
X-Google-Smtp-Source: ABdhPJx9ajYxjiQersuHdj9ETp3u6apxR/0lOc1LUaQzaqSrOLDO1mr9iU6Qxo4PHK4ifTSaHFunow==
X-Received: by 2002:a0c:aedf:: with SMTP id n31mr21459300qvd.16.1598576463240;
        Thu, 27 Aug 2020 18:01:03 -0700 (PDT)
Received: from localhost.localdomain (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id d46sm3475565qtk.37.2020.08.27.18.01.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Aug 2020 18:01:02 -0700 (PDT)
Subject: Re: [PATCH v3 bpf-next 2/5] bpf: Introduce sleepable BPF programs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        davem@davemloft.net
Cc:     daniel@iogearbox.net, bpoirier@suse.com, akpm@linux-foundation.org,
        hannes@cmpxchg.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
References: <20200827220114.69225-1-alexei.starovoitov@gmail.com>
 <20200827220114.69225-3-alexei.starovoitov@gmail.com>
From:   Josef Bacik <josef@toxicpanda.com>
Message-ID: <cd620460-c7cf-eed8-6ae2-16477b311107@toxicpanda.com>
Date:   Thu, 27 Aug 2020 21:01:01 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200827220114.69225-3-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/27/20 6:01 PM, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Introduce sleepable BPF programs that can request such property for themselves
> via BPF_F_SLEEPABLE flag at program load time. In such case they will be able
> to use helpers like bpf_copy_from_user() that might sleep. At present only
> fentry/fexit/fmod_ret and lsm programs can request to be sleepable and only
> when they are attached to kernel functions that are known to allow sleeping.
> 
> The non-sleepable programs are relying on implicit rcu_read_lock() and
> migrate_disable() to protect life time of programs, maps that they use and
> per-cpu kernel structures used to pass info between bpf programs and the
> kernel. The sleepable programs cannot be enclosed into rcu_read_lock().
> migrate_disable() maps to preempt_disable() in non-RT kernels, so the progs
> should not be enclosed in migrate_disable() as well. Therefore
> rcu_read_lock_trace is used to protect the life time of sleepable progs.
> 
> There are many networking and tracing program types. In many cases the
> 'struct bpf_prog *' pointer itself is rcu protected within some other kernel
> data structure and the kernel code is using rcu_dereference() to load that
> program pointer and call BPF_PROG_RUN() on it. All these cases are not touched.
> Instead sleepable bpf programs are allowed with bpf trampoline only. The
> program pointers are hard-coded into generated assembly of bpf trampoline and
> synchronize_rcu_tasks_trace() is used to protect the life time of the program.
> The same trampoline can hold both sleepable and non-sleepable progs.
> 
> When rcu_read_lock_trace is held it means that some sleepable bpf program is
> running from bpf trampoline. Those programs can use bpf arrays and preallocated
> hash/lru maps. These map types are waiting on programs to complete via
> synchronize_rcu_tasks_trace();
> 
> Updates to trampoline now has to do synchronize_rcu_tasks_trace() and
> synchronize_rcu_tasks() to wait for sleepable progs to finish and for
> trampoline assembly to finish.
> 
> This is the first step of introducing sleepable progs. Eventually dynamically
> allocated hash maps can be allowed and networking program types can become
> sleepable too.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Acked-by: Andrii Nakryiko <andriin@fb.com>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
