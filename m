Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8492BD302
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 21:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437379AbfIXTs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 15:48:26 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:34201 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726829AbfIXTsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 15:48:25 -0400
Received: by mail-io1-f67.google.com with SMTP id q1so7509531ion.1
        for <netdev@vger.kernel.org>; Tue, 24 Sep 2019 12:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WLFw2SVVX0kQvrxHzIlzDBhL2m2rkHI2fm2b3O8cq3o=;
        b=FB5uHKExMXckVE07EJAbyDE07WgfHdvZYgI5iDxv2gf7ygNUl7sY+skMZCgt9b31OD
         tD7jPzJfU70wuoj/JP+x0jx9jldNZlsdbdrzc2e1g/HGDqY4cYFjmG/jwD/YS+3DoLBn
         7hcCn57Y0JrrCbjBLJnIk4Q1KitF5cx/XtL0M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WLFw2SVVX0kQvrxHzIlzDBhL2m2rkHI2fm2b3O8cq3o=;
        b=l5iieQ0EA3YW//KF0cokuHPrYJGF5nhCoyXW5GJkZlSzxzjI3Y50ph/opDCC6By3iC
         P0C6kQYwO9bahdAJgP/hXL1DsjOQOFtCaohAkjLL2/NYRZQLFab5fbNbkncM9uLhU5WA
         xshGD/scK0gexh7k9ylsavQZ5baJO9WO4xMXWKCwEJdGTlVhFal55NDS2UxDZEoslQ/q
         iBnkPTdpH1fAg4lr49FTbGQBrb+cT1uVDwBBnGwuJ03a5fumyMAkgbiNvSssInzLcAH/
         W9B0UtF+mMxns96VS4FSB4QQiIUEeY7UGPA3QFQwo8c7g5lka6ASAF8HfgggwTKMJSN3
         lI+Q==
X-Gm-Message-State: APjAAAXLrTFGEjY48QcZhwSIe1iewFyGUsDFCd8W8id8vPUH+0vWWa/Z
        eTYnVbG6UNqbECH9cvh74XMePA==
X-Google-Smtp-Source: APXvYqzBjOqn1deXR9hEiioeq7EqwoEbVRynYUN+BLzNZLOVNSRF26ydZVcgKMz2qP7M+ixvUyoU5w==
X-Received: by 2002:a6b:5a1a:: with SMTP id o26mr5123757iob.65.1569354504637;
        Tue, 24 Sep 2019 12:48:24 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id a14sm2990902ioo.85.2019.09.24.12.48.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Sep 2019 12:48:24 -0700 (PDT)
Subject: Re: Linux 5.4 - bpf test build fails
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "skh >> Shuah Khan" <skhan@linuxfoundation.org>
References: <742ecabe-45ce-cf6e-2540-25d6dc23c45f@linuxfoundation.org>
 <0a5bf608-bb15-c116-8e58-7224b6c3b62f@fb.com>
 <05b7830c-1fa8-b613-0535-1f5f5a40a25a@linuxfoundation.org>
 <20190924184946.GB5889@pc-63.home>
 <edb38c06-a75f-89df-60cd-d9d2de1879d6@linuxfoundation.org>
 <20190924191957.GD5889@pc-63.home>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <7c3cb2ff-e19c-6b2c-652a-870e73534099@linuxfoundation.org>
Date:   Tue, 24 Sep 2019 13:48:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190924191957.GD5889@pc-63.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/24/19 1:19 PM, Daniel Borkmann wrote:
> On Tue, Sep 24, 2019 at 12:56:53PM -0600, Shuah Khan wrote:
>> On 9/24/19 12:49 PM, Daniel Borkmann wrote:
>>> On Tue, Sep 24, 2019 at 09:48:35AM -0600, Shuah Khan wrote:
>>>> On 9/24/19 9:43 AM, Yonghong Song wrote:
>>>>> On 9/24/19 8:26 AM, Shuah Khan wrote:
>>>>>> Hi Alexei and Daniel,
>>>>>>
>>>>>> bpf test doesn't build on Linux 5.4 mainline. Do you know what's
>>>>>> happening here.
>>>>>>
>>>>>> make -C tools/testing/selftests/bpf/
>>>>>>
>>>>>> -c progs/test_core_reloc_ptr_as_arr.c -o - || echo "clang failed") | \
>>>>>> llc -march=bpf -mcpu=generic  -filetype=obj -o
>>>>>> /mnt/data/lkml/linux_5.4/tools/testing/selftests/bpf/test_core_reloc_ptr_as_arr.o
>>>>>>
>>>>>> progs/test_core_reloc_ptr_as_arr.c:25:6: error: use of unknown builtin
>>>>>>           '__builtin_preserve_access_index' [-Wimplicit-function-declaration]
>>>>>>             if (BPF_CORE_READ(&out->a, &in[2].a))
>>>>>>                 ^
>>>>>> ./bpf_helpers.h:533:10: note: expanded from macro 'BPF_CORE_READ'
>>>>>>                            __builtin_preserve_access_index(src))
>>>>>>                            ^
>>>>>> progs/test_core_reloc_ptr_as_arr.c:25:6: warning: incompatible integer to
>>>>>>           pointer conversion passing 'int' to parameter of type 'const void *'
>>>>>>           [-Wint-conversion]
>>>>>>             if (BPF_CORE_READ(&out->a, &in[2].a))
>>>>>>                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>>>>> ./bpf_helpers.h:533:10: note: expanded from macro 'BPF_CORE_READ'
>>>>>>                            __builtin_preserve_access_index(src))
>>>>>>                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>>>>> 1 warning and 1 error generated.
>>>>>> llc: error: llc: <stdin>:1:1: error: expected top-level entity
>>>>>> clang failed
>>>>>>
>>>>>> Also
>>>>>>
>>>>>> make TARGETS=bpf kselftest fails as well. Dependency between
>>>>>> tools/lib/bpf and the test. How can we avoid this type of
>>>>>> dependency or resolve it in a way it doesn't result in build
>>>>>> failures?
>>>>>
>>>>> Thanks, Shuah.
>>>>>
>>>>> The clang __builtin_preserve_access_index() intrinsic is
>>>>> introduced in LLVM9 (which just released last week) and
>>>>> the builtin and other CO-RE features are only supported
>>>>> in LLVM10 (current development branch) with more bug fixes
>>>>> and added features.
>>>>>
>>>>> I think we should do a feature test for llvm version and only
>>>>> enable these tests when llvm version >= 10.
>>>>
>>>> Yes. If new tests depend on a particular llvm revision, the failing
>>>> the build is a regression. I would like to see older tests that don't
>>>> have dependency build and run.
>>>
>>> So far we haven't made it a requirement as majority of BPF contributors
>>> that would run/add tests in here are also on bleeding edge LLVM anyway
>>> and other CIs like 0-day bot have simply upgraded their LLVM version
>>> from git whenever there was a failure similar to the one here so its
>>> ensured that really /all/ test cases are running and nothing would be
>>> skipped. There is worry to some degree that CIs just keep sticking to
>>> an old compiler since tests "just" pass and regressions wouldn't be
>>> caught on new releases for those that are skipped. >
>>
>> Sure. Bleeding edge is developer mode. We still have to be concerned
>> about users that might not upgrade quickly.
>>
>>> That said, for the C based tests, it should actually be straight forward
>>> to categorize them based on built-in macros like ...
>>>
>>> $ echo | clang -dM -E -
>>> [...]
>>> #define __clang_major__ 10
>>> #define __clang_minor__ 0
>>> [...]
>>
>> What would nice running the tests you can run and then say some tests
>> aren't going to run. Is this something you can support?
> 
> Once there is such infra in place, should be possible.

Can't you do it in bpf run-time or during build for dependency?
You should be able to handle this as a dependency and let users
know at least.

> 
>>> ... given there is now also bpf-gcc, the test matrix gets bigger anyway,
>>> so it might be worth rethinking to run the suite multiple times with
>>> different major llvm{,gcc} versions at some point to make sure their
>>> generated BPF bytecode keeps passing the verifier, and yell loudly if
>>> newer features had to be skipped due to lack of recent compiler version.
>>> This would be a super set of /just/ skipping tests and improve coverage
>>> at the same time.
>>
>> Probably. Reality is most users will just quit and add bpf to "hard to
>> run category" of tests.
> 
> I don't really worry too much about such users at this point, more important
> is that we have a way to test bpf-gcc and llvm behavior side by side to
> make sure behavior is consistent and to have some sort of automated CI
> integration that runs BPF kselftests before we even stare at a patch for
> review. These are right now the two highest prio items from BPF testing
> side where we need to get to.
> 

What happens if CI's can't upgrade quickly and newer versions aren't
supported on test machines that are in their test rings?

thanks,
-- Shuah

