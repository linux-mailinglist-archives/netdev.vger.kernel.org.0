Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6FD4926FE
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 14:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242390AbiARNTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 08:19:19 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:36902 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242302AbiARNTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 08:19:12 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: usama.anjum)
        with ESMTPSA id 283A01F43568
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1642511949;
        bh=NnA8DF5nv67Abok07B1FDD4ZaMq6Cy3stGYg/JYq7G0=;
        h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
        b=gOOtBoB+LqcCGqcgcyaKvqu7qG58u5YJiGrs4xSCpwjbLSoAmu8d+ghKU2xzdrjGL
         csHm1zQ4M9Wc1QqBiTxySkXIRBRsukryioI8Rf7kmqWuBU5sPYRtaI078IAg6rECbj
         D0gSKpSnJE+wtTS6FKb9dGrhhjeSNSmKcI4rnGjdh56Eh3xAe8AOwK0B6pbhDNtkfH
         4eUo0EBztcjo8Q7PvxJkf+3GUsCh7aiMJ49lTs1VYa3O+u/EVWLjGpvw4FLpQb3/8S
         pg1o3CQba6wq9aviWjsg+dSN1rYUlNPGRE0vNwYjm+9EauBsD47BsSEwipQfRVWuh7
         YyZXm6BLQxY/g==
Message-ID: <a9f7185f-0a7f-3133-fcdd-bd790b51e6ae@collabora.com>
Date:   Tue, 18 Jan 2022 18:18:59 +0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Cc:     usama.anjum@collabora.com, kernel@collabora.com
Subject: Re: [PATCH 06/10] selftests: landlock: Add the uapi headers include
 variable
Content-Language: en-US
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>,
        Shuah Khan <shuah@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        =?UTF-8?Q?Andr=c3=a9_Almeida?= <andrealmeid@collabora.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        chiminghao <chi.minghao@zte.com.cn>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        "open list:LANDLOCK SECURITY MODULE" 
        <linux-security-module@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "open list:NETWORKING [MPTCP]" <mptcp@lists.linux.dev>,
        "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>
References: <20220118112909.1885705-1-usama.anjum@collabora.com>
 <20220118112909.1885705-7-usama.anjum@collabora.com>
 <8ea3bd61-8251-a5b6-c0b4-6d15bac4d2c5@digikod.net>
From:   Muhammad Usama Anjum <usama.anjum@collabora.com>
In-Reply-To: <8ea3bd61-8251-a5b6-c0b4-6d15bac4d2c5@digikod.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/18/22 5:35 PM, Mickaël Salaün wrote:
> 
> On 18/01/2022 12:29, Muhammad Usama Anjum wrote:
>> Out of tree build of this test fails if relative path of the output
>> directory is specified. Remove the un-needed include paths and use
>> KHDR_INCLUDES to correctly reach the headers.
>>
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
>> ---
>>   tools/testing/selftests/landlock/Makefile | 11 +++--------
>>   1 file changed, 3 insertions(+), 8 deletions(-)
>>
>> diff --git a/tools/testing/selftests/landlock/Makefile
>> b/tools/testing/selftests/landlock/Makefile
>> index a99596ca9882..44c724b38a37 100644
>> --- a/tools/testing/selftests/landlock/Makefile
>> +++ b/tools/testing/selftests/landlock/Makefile
>> @@ -1,6 +1,6 @@
>>   # SPDX-License-Identifier: GPL-2.0
>>   -CFLAGS += -Wall -O2
>> +CFLAGS += -Wall -O2 $(KHDR_INCLUDES)
>>     src_test := $(wildcard *_test.c)
>>   @@ -12,13 +12,8 @@ KSFT_KHDR_INSTALL := 1
>>   OVERRIDE_TARGETS := 1
>>   include ../lib.mk
>>   -khdr_dir = $(top_srcdir)/usr/include
> 
> This should be updated to:
> khdr_dir = ${abs_srctree}/usr/include
> 
> Using a global KHDR_DIR instead of khdr_dir could be useful for others too.
> 
>> -
>> -$(khdr_dir)/linux/landlock.h: khdr
>> -    @:
> 
> This should be kept as is, otherwise we loose this check to rebuild the
> headers if linux/landlock.h is updated, which is handy for development.
> KVM lost a similar behavior with this patch series.
> 
>> -
>>   $(OUTPUT)/true: true.c
>>       $(LINK.c) $< $(LDLIBS) -o $@ -static
>>   -$(OUTPUT)/%_test: %_test.c $(khdr_dir)/linux/landlock.h
>> ../kselftest_harness.h common.h
> 
> This should not be changed.
> 
>> -    $(LINK.c) $< $(LDLIBS) -o $@ -lcap -I$(khdr_dir)
>> +$(OUTPUT)/%_test: %_test.c ../kselftest_harness.h common.h
>> +    $(LINK.c) $< $(LDLIBS) -o $@ -lcap
> 
> This doesn't work when building in the local directory because
> $abs_srctree and $KHDR_INCLUDES are empty:
> cd tools/testing/selftests/landlock && make
Hi,

Thank you. I'll update this path and the kvm one. I'll send a V2.

Thanks,
Usama
