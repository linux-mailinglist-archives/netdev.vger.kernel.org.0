Return-Path: <netdev+bounces-8785-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DFC08725BBC
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 12:42:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B0442812B3
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 10:42:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2947779F7;
	Wed,  7 Jun 2023 10:42:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2BE6FBB
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 10:42:30 +0000 (UTC)
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE322125
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 03:42:19 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-3f7353993cbso3619015e9.0
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 03:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent.com; s=google; t=1686134537; x=1688726537;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N7LrhNNEdA24khblC9g8MfKa4jeWvLQ+nAT4hRuOUJI=;
        b=XIPDoVV88MC7ohXtbTc2BCAz536FGMFDcu4rdZ5ndoe8/wbuZh2LJ8yFLgMkgqX5xS
         vuNtpp04rDMuXb+tEbdw9+7DjSfzqX0KNlkMYA4fpekCV4J/KMpN3DPo1C6Hv7TSNhMC
         GsiaGDA1rl0Tv2jzQ7g1Ndhrq/QALkjJP+drhZaztLD/jNveiLBziLAsCrH65+ufAN3A
         2jBNTl3WUaFnzfWdmTs2XxvEcl/tZgfYEWYbejMAJbZ3S4V6hf1xIJyZz5zSJPUoFpDv
         /08sr83xx/vF3wFWesTcnJ9+s60XwYIm+MESMCKWGv88MeIAFjuKC+ZUAJNBPZbKu2HY
         SCNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686134537; x=1688726537;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N7LrhNNEdA24khblC9g8MfKa4jeWvLQ+nAT4hRuOUJI=;
        b=AnWxmj9rqcjMNp3VjlHnJOojno4aZgy0XhITue1vm27mw3gQijPysXVv1Wa+XCZkpG
         mg1FDktEnGWDGD6EXAtM+FQ1ei2VWMVk1tpm2GsqaEcUHMskRA+Era8Yv8c5k9tqOmLu
         UkWG4u5pIyylhxXHYU62/cs2oD/8oUA4hy4QqbSQ1vk8ippS6seTToLUoT25V1i0lCNq
         odvQ28dn6tOrjuhQfZCV24bglazN5FBuQZF00RRtDIIVsN9cPxrX6gj64OB5xLe9UoyT
         +9xU7dJvUmb28GRZSCCs4jcDJxsxgjiZBKM4txBkN+V75RZ4+JqpX1NACWeTvEvEvS8l
         YLIw==
X-Gm-Message-State: AC+VfDyp6T3aXM1+HX2O+QsvFJl6FOg/v4IDsSGRRPpl7cFosP68lE9I
	Meigox1czmVSwD/csq3RRiq7sl3+i3+OcELCRPhXxA==
X-Google-Smtp-Source: ACHHUZ4OhWn4Tb9E2A5DqtcylYLUxU5x86bnN3MT2KWvOc7EJ3AmkwX8cONOFSmSpNVgN9Yoho/ljw==
X-Received: by 2002:a7b:c3d4:0:b0:3f4:1ce0:a606 with SMTP id t20-20020a7bc3d4000000b003f41ce0a606mr4065558wmj.1.1686134537631;
        Wed, 07 Jun 2023 03:42:17 -0700 (PDT)
Received: from ?IPV6:2a02:8011:e80c:0:3d52:65d8:7088:94e9? ([2a02:8011:e80c:0:3d52:65d8:7088:94e9])
        by smtp.gmail.com with ESMTPSA id h18-20020a1ccc12000000b003f74eb308fasm1648829wmb.48.2023.06.07.03.42.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jun 2023 03:42:17 -0700 (PDT)
Message-ID: <a5d1512b-2c1b-1713-ae52-84fc148ecb5a@isovalent.com>
Date: Wed, 7 Jun 2023 11:42:16 +0100
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v2 bpf 03/11] bpftool: use a local bpf_perf_event_value to
 fix accessing its fields
Content-Language: en-GB
To: Nick Desaulniers <ndesaulniers@google.com>,
 Alexander Lobakin <alobakin@pm.me>
Cc: Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
 Song Liu <songliubraving@fb.com>, Kumar Kartikeya Dwivedi
 <memxor@gmail.com>, bpf@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, tpgxyz@gmail.com,
 Jiri Olsa <olsajiri@gmail.com>
References: <20220421003152.339542-1-alobakin@pm.me>
 <20220421003152.339542-4-alobakin@pm.me> <ZH+e9IYk+DIZzUFL@google.com>
From: Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <ZH+e9IYk+DIZzUFL@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

2023-06-06 14:02 UTC-0700 ~ Nick Desaulniers <ndesaulniers@google.com>
> On Thu, Apr 21, 2022 at 12:39:04AM +0000, Alexander Lobakin wrote:
>> Fix the following error when building bpftool:
>>
>>   CLANG   profiler.bpf.o
>>   CLANG   pid_iter.bpf.o
>> skeleton/profiler.bpf.c:18:21: error: invalid application of 'sizeof' to an incomplete type 'struct bpf_perf_event_value'
>>         __uint(value_size, sizeof(struct bpf_perf_event_value));
>>                            ^     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> tools/bpf/bpftool/bootstrap/libbpf/include/bpf/bpf_helpers.h:13:39: note: expanded from macro '__uint'
>> tools/bpf/bpftool/bootstrap/libbpf/include/bpf/bpf_helper_defs.h:7:8: note: forward declaration of 'struct bpf_perf_event_value'
>> struct bpf_perf_event_value;
>>        ^
>>
>> struct bpf_perf_event_value is being used in the kernel only when
>> CONFIG_BPF_EVENTS is enabled, so it misses a BTF entry then.
>> Define struct bpf_perf_event_value___local with the
>> `preserve_access_index` attribute inside the pid_iter BPF prog to
>> allow compiling on any configs. It is a full mirror of a UAPI
>> structure, so is compatible both with and w/o CO-RE.
>> bpf_perf_event_read_value() requires a pointer of the original type,
>> so a cast is needed.
>>
> 
> Hi Alexander,
> What's the status of this series? I wasn't able to find a v3 on lore.
> 
> We received a report that OpenMandriva is carrying around this patch.
> https://github.com/ClangBuiltLinux/linux/issues/1805.
> 
> + Tomasz
> 
> Tomasz, do you have more info which particular configs can reproduce
> this issue? Is this patch still necessary?
> 
>> Fixes: 47c09d6a9f67 ("bpftool: Introduce "prog profile" command")

Hi Nick,

This patch is still necessary if you attempt to compile bpftool with
skeletons support, on a host with a kernel version lower than 5.15.

I took over on the bpftool patches from this series, and sent a new
version last month. Given that it only contains the bpftool patches, the
series has a different title and is not tagged as v3, but you can find
it here:

https://lore.kernel.org/all/20230512103354.48374-1-quentin@isovalent.com/t/#u

Jiri (+Cc) found an issue with this set when CONFIG_BPF_EVENTS is
disabled. I need to replicate and investigate, but I've been short on
time to do that over the last few weeks.

Best,
Quentin

