Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84EAC180C1E
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 00:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbgCJXLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 19:11:50 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:46200 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbgCJXLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 19:11:50 -0400
Received: by mail-il1-f195.google.com with SMTP id e8so197356ilc.13
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 16:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7EYAI63zd18SBq8FB4fUfNf0NU8spud30w3445VcWaM=;
        b=SOuRvF3fvTblm9CeWolyerj2zGaD3saqUhIuWhjObHc3jGGTBh/v+0w6d+z78Y503p
         QYu4SglBDGCKdB5ZGG73RSsATC3wnkZEXsCFmLvix43Fa+fpdLPCVWYl5b4EXLJk1Q3Y
         ew0AE4RdaYLyWgeuhoV35GaoA5m2bPOwMHDj8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7EYAI63zd18SBq8FB4fUfNf0NU8spud30w3445VcWaM=;
        b=rt5fXdc8CON3CA5WzSL/iE1fH877Hj8u+4F2wpipTap5DDp7+NJ+XZD2Xh5mFiLMll
         XwAMKGOd4jhxb9+IvLmhDbAwDvgbqp1jMo7LdbAQfHpCdFbyNMdOBtef75g7s698A+Ll
         HzgvaeAgBDlDacIP00GIG+pSk+nZNHVxjeO5/1FuCQoRg4m/bZ/4cB8aDkgFzgpzNIEz
         CCwEokBwhI1rPfi3se4O12SrH0CKI85EcaXN6FhrHlmOf5/HwSTxk7ULpF0Shbi+Pksv
         mQqHeA+c+ZDVuY0bugixJZtPIcrWSGDpkTPxS2BEDIkzCLE4HbGmtD2SXP9Ah8WGLncw
         GtFA==
X-Gm-Message-State: ANhLgQ3iFnmPm03yxdWJHeQGcf+CqoWa+TXpk/CrEEg0sByPMK4zH/Nl
        O3U+Psypb9f8toXeeK9WKwsBbw==
X-Google-Smtp-Source: ADFU+vuKjc/Vi167HrNsokZgPEQVficFdi3AwhXRn8+hgEKbKqkwlsSrlMStlkPyqiz7BfLaie+1fw==
X-Received: by 2002:a92:5c5c:: with SMTP id q89mr382168ilb.195.1583881909799;
        Tue, 10 Mar 2020 16:11:49 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id z14sm8703570iln.17.2020.03.10.16.11.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2020 16:11:49 -0700 (PDT)
Subject: Re: [PATCH v2 2/4] selftests: Fix seccomp to support relocatable
 build (O=objdir)
To:     Kees Cook <keescook@chromium.org>
Cc:     shuah@kernel.org, luto@amacapital.net, wad@chromium.org,
        daniel@iogearbox.net, kafai@fb.com, yhs@fb.com, andriin@fb.com,
        gregkh@linuxfoundation.org, tglx@linutronix.de,
        khilman@baylibre.com, mpe@ellerman.id.au,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        "skh >> Shuah Khan" <skhan@linuxfoundation.org>
References: <20200305003627.31900-1-skhan@linuxfoundation.org>
 <202003041815.B8C73DEC@keescook>
 <f4cf1527-4565-9f08-a8a2-9f51022eac63@linuxfoundation.org>
 <202003050937.BA14B70DEB@keescook>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <d125a38f-50aa-dbf1-0fcf-59d4ad4a1441@linuxfoundation.org>
Date:   Tue, 10 Mar 2020 17:11:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <202003050937.BA14B70DEB@keescook>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/5/20 10:42 AM, Kees Cook wrote:
> On Thu, Mar 05, 2020 at 09:41:34AM -0700, Shuah Khan wrote:
>> On 3/4/20 7:20 PM, Kees Cook wrote:
>>> Instead of the TEST_CUSTOM_PROGS+all dance, you can just add an explicit
>>> dependency, with the final seccomp/Makefile looking like this:
>>>
>>>
>>> # SPDX-License-Identifier: GPL-2.0
>>> CFLAGS += -Wl,-no-as-needed -Wall
>>> LDFLAGS += -lpthread
>>>
>>> TEST_GEN_PROGS := seccomp_bpf seccomp_benchmark
>>>
>>
>> TEST_CUSTOM_PROGS is for differentiating test programs that
>> can't use lib.mk generic rules. It is appropriate to use
>> for seccomp_bpf
> 
> I don't follow? This suggested Makefile works for me (i.e. it can use
> the lib.mk generic rules since CFLAGS and LDFLAGS can be customized
> first, and it just adds an additional dependency).
> 

Yeah. TEST_CUSTOM_PROGS isn't really needed for this custom case.
I can refine it and get rid of the dependency.

>>> include ../lib.mk
>>>
>>> # Additional dependencies
>>> $(OUTPUT)/seccomp_bpf: ../kselftest_harness.h
> 
> BTW, I see a lot of other targets that use kselftest_harness.h appear to
> be missing this Makefile dependency, but that's a different problem. :)
> 
>>> (Though this fails in the same way as above when run from the top-level
>>> directory.)
>>>
>>
>> I didn't see this because I have been the same directory I used
>> for relocated cross-build kernel. :(
>>
>> Thanks for testing this. I know the problem here. all is a dependency
>> for install step and $(OUTPUT) is referencing the objdir before it
>> gets created. It is a Makefile/lib.mk problem to fix.
>>

I was way off with my analysis. :(

>> I will do a separate patch for this. This will show up in any test
>> that is using $(OUTPUT) to relocate objects mainly the ones that
>> require custom build rule like seeccomp.
> 
> Okay, cool. It looked to me like it lost track of the top level source
> directory (i.e. "make: entering $output" ... "can't find
> ../other/files")
> 

Odd that you would have empty objdir in the cross-compile case.

In the cross-compile case, you would have cross-built kernel first in
the object directory. Your objdir won't be empty.

This is no different from kselftest build dependency on kernel build
even when srcdir=objdir

So for cross-build case, the following  is the workflow to build kernel
first and then the tests:

make O=/../objdir ARCH=arm64 HOSTCC=gcc CROSS_COMPILE=aarch64-linux-gnu- 
defconfig

make O=/../objdir ARCH=arm64 HOSTCC=gcc CROSS_COMPILE=aarch64-linux-gnu- all

make kselftest-install O=/../objdir ARCH=arm64 HOSTCC=gcc 
CROSS_COMPILE=aarch64-linux-gnu- TARGETS=seccomp

You can isolate a single test when you are do native build:

make kselftest-install O=/../objdir TARGETS=seccomp

The above won't fail even if objdir doesn't exist and/or empty.

thanks,
-- Shuah







