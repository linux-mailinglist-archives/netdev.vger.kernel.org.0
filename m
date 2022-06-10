Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF1E546B2E
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 19:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346464AbiFJRAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 13:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349849AbiFJRA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 13:00:29 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7076338A5
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 10:00:27 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id j5-20020a05600c1c0500b0039c5dbbfa48so1423664wms.5
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 10:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=mxkfsPOt+1BiFyYRQAUT1EkyhPIhrJYMCJ92Su1aMxY=;
        b=LJO3jmKOWerFx3arypxcX4r5bwfzwip2rU2HA2Nk7sz+JJO9ztX+KpJfdlSH1dB1lt
         eRErQx71aRMDbF781RiPdkpXAmEHYu+jsi7/mlR5muapj40wAvUYTeS70mEw81h5zFSg
         niCJ+px+TExjUzm2WEGzMZJlLGfGl+n4HAcVjyXFmzJ9dV/AHkN3Y7wNJevrdQ+rCJbR
         c7K0p8mDq2DvcRO3CkM1zOvH/c5+IZf3evkw4fSGGJJARYFvYHtHTdTAz0gN75hCN7dJ
         bw5K+RlGBEFVXruE8G1l4NAfHKjy7ZmOmokHaWK2IP13kT98hkl5pcRPa2vnPawBdh7p
         CoCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mxkfsPOt+1BiFyYRQAUT1EkyhPIhrJYMCJ92Su1aMxY=;
        b=yLSQZlrTNS3LFXx6FoWL58wz6kgU+EReWXsVItZW0BQGAjnIB5CY9JKpaRJGb32doV
         orz78OA4cLLhVLtXfvRugfGrmiKlZMCpPu31nyu3YpNe5L6ts7omDrDI/Btz22/by5Fn
         WrwzhrREZE5hF+rHqriuVlIyRNMuBPz23n07pCMNFZd4/rwOTrExLJC9fKf8+fDkOlFH
         RHfxP/bMMVfMrfEYXyhns74bQthMyoc5mf1kNZQZGNO4p3bzT3k7ZcYPlvAh12ajrLf2
         DF8sucjCCsBcCxRPFOOFlrZWAbgCjRhFYWHjh8I6wBX5T5DyyJlFVQR8I7f/HoW7B8o2
         jeJg==
X-Gm-Message-State: AOAM531jmzMpGCQGbyaaOzOQD0vrZWQlqqaK8Dj+r8afC4TZyUOU+LqV
        O+r8W0ywvj+uoFErLCSXsWF2kQ==
X-Google-Smtp-Source: ABdhPJxBSwG/R7c5/8gnmc3VIvpFjAaaDK4o2lqKSoq4Q2auWa7nMVlNgwuebDXQqjbv+hmK59tVCw==
X-Received: by 2002:a05:600c:3790:b0:39c:62b9:b164 with SMTP id o16-20020a05600c379000b0039c62b9b164mr726820wmr.0.1654880426109;
        Fri, 10 Jun 2022 10:00:26 -0700 (PDT)
Received: from [192.168.178.21] ([51.155.200.13])
        by smtp.gmail.com with ESMTPSA id q17-20020adff951000000b002103bd9c5acsm27840901wrr.105.2022.06.10.10.00.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jun 2022 10:00:25 -0700 (PDT)
Message-ID: <71b56050-11ad-bd06-09c9-1a8c61b4c1b4@isovalent.com>
Date:   Fri, 10 Jun 2022 18:00:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH bpf-next 1/2] Revert "bpftool: Use libbpf 1.0 API mode
 instead of RLIMIT_MEMLOCK"
Content-Language: en-GB
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yafang Shao <laoar.shao@gmail.com>,
        Harsh Modi <harshmodi@google.com>,
        Paul Chaignon <paul@cilium.io>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20220610112648.29695-1-quentin@isovalent.com>
 <20220610112648.29695-2-quentin@isovalent.com> <YqNsWAH24bAIPjqy@google.com>
 <cb05a59e-07d5-ddd1-b028-82133faaf67e@isovalent.com>
 <CAKH8qBvvq0f+D8BXChw_8krH896J_cYg0yhRfnDOSO_U1n394w@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <CAKH8qBvvq0f+D8BXChw_8krH896J_cYg0yhRfnDOSO_U1n394w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022-06-10 09:46 UTC-0700 ~ Stanislav Fomichev <sdf@google.com>
> On Fri, Jun 10, 2022 at 9:34 AM Quentin Monnet <quentin@isovalent.com> wrote:
>>
>> 2022-06-10 09:07 UTC-0700 ~ sdf@google.com
>>> On 06/10, Quentin Monnet wrote:
>>>> This reverts commit a777e18f1bcd32528ff5dfd10a6629b655b05eb8.
>>>
>>>> In commit a777e18f1bcd ("bpftool: Use libbpf 1.0 API mode instead of
>>>> RLIMIT_MEMLOCK"), we removed the rlimit bump in bpftool, because the
>>>> kernel has switched to memcg-based memory accounting. Thanks to the
>>>> LIBBPF_STRICT_AUTO_RLIMIT_MEMLOCK, we attempted to keep compatibility
>>>> with other systems and ask libbpf to raise the limit for us if
>>>> necessary.
>>>
>>>> How do we know if memcg-based accounting is supported? There is a probe
>>>> in libbpf to check this. But this probe currently relies on the
>>>> availability of a given BPF helper, bpf_ktime_get_coarse_ns(), which
>>>> landed in the same kernel version as the memory accounting change. This
>>>> works in the generic case, but it may fail, for example, if the helper
>>>> function has been backported to an older kernel. This has been observed
>>>> for Google Cloud's Container-Optimized OS (COS), where the helper is
>>>> available but rlimit is still in use. The probe succeeds, the rlimit is
>>>> not raised, and probing features with bpftool, for example, fails.
>>>
>>>> A patch was submitted [0] to update this probe in libbpf, based on what
>>>> the cilium/ebpf Go library does [1]. It would lower the soft rlimit to
>>>> 0, attempt to load a BPF object, and reset the rlimit. But it may induce
>>>> some hard-to-debug flakiness if another process starts, or the current
>>>> application is killed, while the rlimit is reduced, and the approach was
>>>> discarded.
>>>
>>>> As a workaround to ensure that the rlimit bump does not depend on the
>>>> availability of a given helper, we restore the unconditional rlimit bump
>>>> in bpftool for now.
>>>
>>>> [0]
>>>> https://lore.kernel.org/bpf/20220609143614.97837-1-quentin@isovalent.com/
>>>> [1] https://github.com/cilium/ebpf/blob/v0.9.0/rlimit/rlimit.go#L39
>>>
>>>> Cc: Yafang Shao <laoar.shao@gmail.com>
>>>> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
>>>> ---
>>>>   tools/bpf/bpftool/common.c     | 8 ++++++++
>>>>   tools/bpf/bpftool/feature.c    | 2 ++
>>>>   tools/bpf/bpftool/main.c       | 6 +++---
>>>>   tools/bpf/bpftool/main.h       | 2 ++
>>>>   tools/bpf/bpftool/map.c        | 2 ++
>>>>   tools/bpf/bpftool/pids.c       | 1 +
>>>>   tools/bpf/bpftool/prog.c       | 3 +++
>>>>   tools/bpf/bpftool/struct_ops.c | 2 ++
>>>>   8 files changed, 23 insertions(+), 3 deletions(-)
>>>
>>>> diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
>>>> index a45b42ee8ab0..a0d4acd7c54a 100644
>>>> --- a/tools/bpf/bpftool/common.c
>>>> +++ b/tools/bpf/bpftool/common.c
>>>> @@ -17,6 +17,7 @@
>>>>   #include <linux/magic.h>
>>>>   #include <net/if.h>
>>>>   #include <sys/mount.h>
>>>> +#include <sys/resource.h>
>>>>   #include <sys/stat.h>
>>>>   #include <sys/vfs.h>
>>>
>>>> @@ -72,6 +73,13 @@ static bool is_bpffs(char *path)
>>>>       return (unsigned long)st_fs.f_type == BPF_FS_MAGIC;
>>>>   }
>>>
>>>> +void set_max_rlimit(void)
>>>> +{
>>>> +    struct rlimit rinf = { RLIM_INFINITY, RLIM_INFINITY };
>>>> +
>>>> +    setrlimit(RLIMIT_MEMLOCK, &rinf);
>>>
>>> Do you think it might make sense to print to stderr some warning if
>>> we actually happen to adjust this limit?
>>>
>>> if (getrlimit(MEMLOCK) != RLIM_INFINITY) {
>>>     fprintf(stderr, "Warning: resetting MEMLOCK rlimit to
>>>     infinity!\n");
>>>     setrlimit(RLIMIT_MEMLOCK, &rinf);
>>> }
>>>
>>> ?
>>>
>>> Because while it's nice that we automatically do this, this might still
>>> lead to surprises for some users. OTOH, not sure whether people
>>> actually read those warnings? :-/
>>
>> I'm not strictly opposed to a warning, but I'm not completely sure this
>> is desirable.
>>
>> Bpftool has raised the rlimit for a long time, it changed only in April,
>> so I don't think it would come up as a surprise for people who have used
>> it for a while. I think this is also something that several other
>> BPF-related applications (BCC I think?, bpftrace, Cilium come to mind)
>> have been doing too.
> 
> In this case ignore me and let's continue doing that :-)
> 
> Btw, eventually we'd still like to stop doing that I'd presume?

Agreed. I was thinking either finding a way to improve the probe in
libbpf, or waiting for some more time until 5.11 gets old, but this may
take years :/

> Should
> we at some point follow up with something like:
> 
> if (kernel_version >= 5.11) { don't touch memlock; }
> 
> ?
> 
> I guess we care only about <5.11 because of the backports, but 5.11+
> kernels are guaranteed to have memcg.

You mean from uname() and parsing the release? Yes I suppose we could do
that, can do as a follow-up.

> 
> I'm not sure whether memlock is used out there in the distros (and
> especially for root/bpf_capable), so I'm also not sure whether we
> really care or not.

Not sure either. For what it's worth, I've never seen complaints so far
from users about the rlimit being raised (from bpftool or other BPF apps).
