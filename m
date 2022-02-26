Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24CAA4C5468
	for <lists+netdev@lfdr.de>; Sat, 26 Feb 2022 08:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbiBZHdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Feb 2022 02:33:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiBZHdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Feb 2022 02:33:16 -0500
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [46.235.227.227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5D5E29;
        Fri, 25 Feb 2022 23:32:33 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: usama.anjum)
        with ESMTPSA id 9BF0D1F467EE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1645860752;
        bh=pkiELR9DhTQvRNgxhSnFGTRWf9t9Px/bkmVM9uFDx0s=;
        h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
        b=Xn9QwQfM2sX+J9TBkV0MJldNdwZS66ytIF0Nhk7uimN7o/Bvde6mkwbgKDD5vRAO5
         jxFz4Iok+PElmZTYbj/S98NUJ1JKBV6xbUPDpqyFRFCp7c2E7o6qsZ4uPpuNLQjcFk
         xAPgftBpgOa/kFXKLHdZzRJ5T31xPBIvH1DfwkEPjmVZUnkGYJ+dPaT3aOVqBc58rQ
         tLLDWhma7wbGPF238K3kwrVKI9Rvm7cDu9KWhKMNEMSZ4wEEJQ+GB+OV2p+Bq+6uG9
         mnK0P8mk2WvJsKgRNRqt8a38Aqox1Q0wYhRWlLSN1BDSeyHdtAnuFxh46Nuc4R7l3v
         5w2XnRAG5F3rw==
Message-ID: <ddb52ffe-5016-cc5a-3af4-a0a8e7b3e119@collabora.com>
Date:   Sat, 26 Feb 2022 12:32:23 +0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Cc:     usama.anjum@collabora.com, kernel@collabora.com,
        kernelci@groups.io, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH V2] selftests: Fix build when $(O) points to a relative
 path
Content-Language: en-US
To:     Shuah Khan <skhan@linuxfoundation.org>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
References: <20220216223817.1386745-1-usama.anjum@collabora.com>
 <46489cd9-fb7a-5a4b-7f36-1c9f6566bd93@collabora.com>
 <63870982-62ba-97f2-5ee2-d4457a7a5cdb@linuxfoundation.org>
 <9a643612-ea85-7b28-a792-770927836d43@linuxfoundation.org>
From:   Muhammad Usama Anjum <usama.anjum@collabora.com>
In-Reply-To: <9a643612-ea85-7b28-a792-770927836d43@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/26/22 2:13 AM, Shuah Khan wrote:
> On 2/25/22 11:01 AM, Shuah Khan wrote:
>> On 2/25/22 10:22 AM, Muhammad Usama Anjum wrote:
>>> Any thoughts about it?
>>>
>>
>> No to post please.
>>
>>> On 2/17/22 3:38 AM, Muhammad Usama Anjum wrote:
>>>> Build of bpf and tc-testing selftests fails when the relative path of
>>>> the build directory is specified.
>>>>
>>>> make -C tools/testing/selftests O=build0
>>>> make[1]: Entering directory
>>>> '/linux_mainline/tools/testing/selftests/bpf'
>>>> ../../../scripts/Makefile.include:4: *** O=build0 does not exist. 
>>>> Stop.
>>>> make[1]: Entering directory
>>>> '/linux_mainline/tools/testing/selftests/tc-testing'
>>>> ../../../scripts/Makefile.include:4: *** O=build0 does not exist. 
>>>> Stop.
>>>>
>>>> Makefiles of bpf and tc-testing include scripts/Makefile.include file.
>>>> This file has sanity checking inside it which checks the output path.
>>>> The output path is not relative to the bpf or tc-testing. The sanity
>>>> check fails. Expand the output path to get rid of this error. The
>>>> fix is
>>>> the same as mentioned in commit 150a27328b68 ("bpf, preload: Fix build
>>>> when $(O) points to a relative path").
>>>>
>>>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
>>>> ---
>>>> Changes in V2:
>>>> Add more explaination to the commit message.
>>>> Support make install as well.
>>
> 
> Does the same happen when you use make kselftest-all?
No, this problem doesn't appear when using make kselftest-all.

As separate output directory build was broken in kernel's top most
Makefile i.e., make kselftest-all O=dir. (I've sent separate patch to
fix this:
https://lore.kernel.org/lkml/20220223191016.1658728-1-usama.anjum@collabora.com/)
So people must have been using kselftest's internal Makefile directly to
keep object files in separate directory i.e., make -C
tools/testing/selftests O=dir and in this way the build of these tests
(bpf, tc-testing) fail. This patch is fixing those build errors.

> 
> I am unable to reproduce what you are seeing?
make -C tools/testing/selftests O=dir should reproduce this problem.

> 
> thanks,
> -- Shuah
> 
