Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92E87BDA43
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 10:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393455AbfIYIwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 04:52:24 -0400
Received: from foss.arm.com ([217.140.110.172]:44498 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731047AbfIYIwF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Sep 2019 04:52:05 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A8C1E142F;
        Wed, 25 Sep 2019 01:51:57 -0700 (PDT)
Received: from [10.37.10.85] (unknown [10.37.10.85])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CD2CA3F59C;
        Wed, 25 Sep 2019 01:51:55 -0700 (PDT)
Subject: Re: Linux 5.4 - bpf test build fails
To:     Shuah Khan <skhan@linuxfoundation.org>, Tim.Bird@sony.com,
        alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     linux-kselftest@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net
References: <742ecabe-45ce-cf6e-2540-25d6dc23c45f@linuxfoundation.org>
 <1d1bbc01-5cf4-72e6-76b3-754d23366c8f@arm.com>
 <34a9bd63-a251-0b4f-73b6-06b9bbf9d3fa@linuxfoundation.org>
 <a603ee8e-b0af-6506-0667-77269b0951b2@linuxfoundation.org>
 <c3dda8d0-1794-ffd1-4d76-690ac2be8b8f@arm.com>
 <ECADFF3FD767C149AD96A924E7EA6EAF977BCBF5@USCULXMSG01.am.sony.com>
 <d4c916ec-14a5-1076-7b84-3ca42026dd19@linuxfoundation.org>
From:   Cristian Marussi <cristian.marussi@arm.com>
Message-ID: <44411794-cd4a-704b-c1c6-d77183240b34@arm.com>
Date:   Wed, 25 Sep 2019 09:52:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <d4c916ec-14a5-1076-7b84-3ca42026dd19@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Shuah, Tim

On 9/24/19 7:23 PM, Shuah Khan wrote:
> On 9/24/19 12:07 PM, Tim.Bird@sony.com wrote:
>>
>>
>>> -----Original Message-----
>>> From: Cristian Marussi on Tuesday, September 24, 2019 7:30 AM
>>>
>>> Hi Shuah
>>>
>>> On 24/09/2019 17:39, Shuah Khan wrote:
>>>> On 9/24/19 10:03 AM, Shuah Khan wrote:
>>>>> On 9/24/19 9:52 AM, Cristian Marussi wrote:
>>>>>> Hi Shuah
>>>>>>
>>>>>> On 24/09/2019 16:26, Shuah Khan wrote:
>>>>>>> Hi Alexei and Daniel,
>>>>>>>
>>>>>>> bpf test doesn't build on Linux 5.4 mainline. Do you know what's
>>>>>>> happening here.
>>>>>>>
>>>>>>>
>>>>>>> make -C tools/testing/selftests/bpf/
>>>>>>
>>>>>> side question, since I'm writing arm64/ tests.
>>>>>>
>>>>>> my "build-testcases" following the KSFT docs are:
>>>>>>
>>>>>> make kselftest
>>>>>> make TARGETS=arm64 kselftest
>>>>>> make -C tools/testing/selftests/
>>>>>> make -C tools/testing/selftests/ INSTALL_PATH=<install-path> install
>>>>>> make TARGETS=arm64 -C tools/testing/selftests/
>>>>>> make TARGETS=arm64 -C tools/testing/selftests/
>>>>>> INSTALL_PATH=<install-path> install
>>>>>> ./kselftest_install.sh <install-path>
>>>>
>>>> Cristian,
>>>>
>>>> That being said, I definitely want to see this list limited to
>>>> a few options.
>>>>
>>>> One problem is that if somebody wants to do just a build, there
>>>> is no option from the main makefile. I have sent support for that
>>>> a few months ago and the patch didn't got lost it appears. I am
>>>> working on resending those patches. The same is true for install.
>>>> I sent in a patch for that a while back and I am going to resend.
>>>> These will make it easier for users.
>>>>
>>>> I would really want to get to supporting only these options:
>>>>
>>>> These are supported now:
>>>>
>>>> make kselftest
>>>> make TARGETS=arm64 kselftest (one or more targets)
>>>>
>>>> Replace the following:
>>>>
>>>> make -C tools/testing/selftests/ with
>>>>
>>>> make kselftes_build option from main makefile
>>>>
>>>> Replace this:
>>>> make -C tools/testing/selftests/ INSTALL_PATH=<install-path> install
>>>>
>>>> with
>>>> make kselftest_install
>>>
>>> Yes these top level options would be absolutely useful to avoid multiplication
>>> of build targets to support and test.
>>>
>>> Moreover, currently, since there was a lot of test growing into arm64/
>>> inside subdirs like arm64/signal, I support (still under review in fact) in the
>>> arm64/
>>> toplevel makefile the possibility of building/installing by subdirs only, in order
>>> to be able to limit what you want to build/install of a TARGET (resulting in
>>> quicker devel),
>>> issuing something like:
>>>
>>> make TARGETS=arm64 SUBTARGETS=signal -C tools/testing/selftests/
>>>
>>> if possible, that would be useful if kept functional even in the
>>> new schema. I mean being able to still issue:
>>>
>>> make TARGETS=arm64 SUBTARGETS=signal kselftes_build
>>
>>  From a user perspective, instead of adding a new SUBTARGETS variable,
>> I would prefer something like the following:
>>
>> make TARGET=arm64/signal kselftest_build
>>
>> If you just add a single flat subsidiary namespace, then it doesn't support further
>> increasing the directory depth in the future.
>>
> 
> TARGETS is make variable. Adding sub-targets might not be easy without
> cluttering the selftests main Makefile. I will have to look into it.
> 

I was NOT proposing in fact to introduce handling of SUBTARGETS at the toplevel kselftest
Makefile, just not to kill the possibility for interested subsystems to handle it as they
wish in their own toplevel subsystem Makefile like in arm64/Makefile in:

https://lore.kernel.org/linux-kselftest/20190910123111.33478-2-cristian.marussi@arm.com/

(probably better renaming SUBTARGETS->ARM64_SUBTARGETS in the next v7 to avoid name clashing)

Because it's painful from the development perspective not having the possibility to selectively
build/install only a subset/subdir of the chosen TARGETS; but it's a very subsystem specific issue
and not everybody need it, so I'd let the respective TARGETS subsystems handle it if they want/need.

Thanks

Cristian

> thanks,
> -- Shuah
> 
