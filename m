Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E990D2D6C15
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 01:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393838AbgLJXmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 18:42:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733200AbgLJXmQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 18:42:16 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4506BC0613CF
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 15:41:36 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id y5so7587010iow.5
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 15:41:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=D+YhSlX5or0JW1xURpPGPblxjgLfMo6bpo3fSB24R/A=;
        b=AHRGDdVM+C4EyKqIUooNkgC4D71VevHDYHOBk3lZ6+PPF/6QeboUV+PZgyOB4rPsy1
         gX+80zy6p9xAVsm6BjDxMQ9FTDEj8OIY+PzXtW2IqZ9NEZWkgwVlegO0I/TwevYFWsI4
         RE0uNoR9DSwIZil6jigvASZXw4rhLbUL6CtJk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D+YhSlX5or0JW1xURpPGPblxjgLfMo6bpo3fSB24R/A=;
        b=qpEUvNzxol4urZYLq5cwdVORrJ2jhLheOiH62DQsCa5aiEffGRKkimPI8vFM0DYdhB
         JXys7fBSAsYpA/H1k20gVrIOHSjB8YXIpm3Jctll2+RKEwR1KlwEUz5u2IA7DWtf46Vz
         kqzfJ+PVb5reY8RLMYxojeKsVBZqwkircrW06VpWbGAkLAExuiWQUKzH4Y6nQtwQ/hiy
         PNtZ8UTwVC1JqYmNj7N0SPjaWlZcI++NOPFTs0MeU88YFo31gyjqufXwzjUMbXPfneEk
         NCarINxMfHcrkumDvEtWcST8rL1CKsLGrq7mxMbjgmZXgfeG+vt92hUcDn7+K9pZqseV
         RccQ==
X-Gm-Message-State: AOAM530RjAd0O197VVJ3yIJvDOqCuxyPFsC1xBkDuUUD8hNVD7HZTEs/
        ui+LtWUhZpoEIrq3UGyxyUQc5w==
X-Google-Smtp-Source: ABdhPJyJeGnPIekZ27frg1Vakk/fWvHxxinXGynYocWjZxvocLgbVm4FqBcWP1xCg2Z1DqJmh5TA/A==
X-Received: by 2002:a6b:5006:: with SMTP id e6mr11231520iob.79.1607643695505;
        Thu, 10 Dec 2020 15:41:35 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id f3sm2404389ilu.74.2020.12.10.15.41.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Dec 2020 15:41:34 -0800 (PST)
Subject: Re: [PATCH] selftests: Skip BPF seftests by default
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Mark Brown <broonie@kernel.org>
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Daniel Diaz <daniel.diaz@linaro.org>,
        Veronika Kabatova <vkabatov@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Guillaume Tucker <guillaume.tucker@collabora.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20201210185233.28091-1-broonie@kernel.org>
 <20201210191103.kfrna27kv3xwnshr@ast-mbp>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <7e0ca62b-ff63-7d26-355f-c49e98a0ef36@linuxfoundation.org>
Date:   Thu, 10 Dec 2020 16:41:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201210191103.kfrna27kv3xwnshr@ast-mbp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/10/20 12:11 PM, Alexei Starovoitov wrote:
> On Thu, Dec 10, 2020 at 06:52:33PM +0000, Mark Brown wrote:
>> The BPF selftests have build time dependencies on cutting edge versions
>> of tools in the BPF ecosystem including LLVM which are more involved
>> to satisfy than more typical requirements like installing a package from
>> your distribution.  This causes issues for users looking at kselftest in
>> as a whole who find that a default build of kselftest fails and that
>> resolving this is time consuming and adds administrative overhead.  The
>> fast pace of BPF development and the need for a full BPF stack to do
>> substantial development or validation work on the code mean that people
>> working directly on it don't see a reasonable way to keep supporting
>> older environments without causing problems with the usability of the
>> BPF tests in BPF development so these requirements are unlikely to be
>> relaxed in the immediate future.
>>
>> There is already support for skipping targets so in order to reduce the
>> barrier to entry for people interested in kselftest as a whole let's use
>> that to skip the BPF tests by default when people work with the top
>> level kselftest build system.  Users can still build the BPF selftests
>> as part of the wider kselftest build by specifying SKIP_TARGETS,
>> including setting an empty SKIP_TARGETS to build everything.  They can
>> also continue to build the BPF selftests individually in cases where
>> they are specifically focused on BPF.
>>
>> This isn't ideal since it means people will need to take special steps
>> to build the BPF tests but the dependencies mean that realistically this
>> is already the case to some extent and it makes it easier for people to
>> pick up and work with the other selftests which is hopefully a net win.
>>
>> Signed-off-by: Mark Brown <broonie@kernel.org>
>> ---
>>   tools/testing/selftests/Makefile | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
>> index afbab4aeef3c..8a917cb4426a 100644
>> --- a/tools/testing/selftests/Makefile
>> +++ b/tools/testing/selftests/Makefile
>> @@ -77,8 +77,10 @@ TARGETS += zram
>>   TARGETS_HOTPLUG = cpu-hotplug
>>   TARGETS_HOTPLUG += memory-hotplug
>>   
>> -# User can optionally provide a TARGETS skiplist.
>> -SKIP_TARGETS ?=
>> +# User can optionally provide a TARGETS skiplist.  By default we skip
>> +# BPF since it has cutting edge build time dependencies which require
>> +# more effort to install.
>> +SKIP_TARGETS ?= bpf
> 
> I'm fine with this, but I'd rather make an obvious second step right away
> and move selftests/bpf into a different directory.
> 

Why is this an obvious second step? If people want to run bpf, they can
build and run. How does moving it out of selftests directory help? It
would become harder on users that want to run the test.

I don't support moving bpf out of selftests directory in the interest
of Linux kernel quality and validation.

Let's think big picture and kernel community as a whole.

thanks,
-- Shuah
