Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F388C4CC8B6
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 23:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236800AbiCCWUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 17:20:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234523AbiCCWUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 17:20:44 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC8A110A7E3
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 14:19:57 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id c23so7559141ioi.4
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 14:19:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Uy2afJ9ZPvmmHWI6b6VB2HM3H9arIDEQAaJ8qNi/u4s=;
        b=AlMT6ljgLpZMvzgD59xHREgkpKiwKbtEuapOcBDIpPtJKRqPOXV5oO+kmZCujKdnEM
         fD3joPO6+cvZ7l8OTW9lKXJOo2YStlCEYiRdIiJOCEnB7aHGVQhrJZTnpOunVg4cDg58
         ncYE0pwb5SnXjTa6giQK3X4pbcCr1szj2cyHg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Uy2afJ9ZPvmmHWI6b6VB2HM3H9arIDEQAaJ8qNi/u4s=;
        b=pwldLorVPfAHgr2QJfhptx71Wiigys4o8VrNmwLXFkMFgI6q4AcvGfu8Rikp0hA07k
         BNBVKkUyYKr/NKmQ0pXP6v4YKs4+XBgl6eBFu/TFn7UdDoWBiFmQww9Mt+6K72RaeCoT
         otqcKXMC5iaAQSDaYL1thxNdLD5KLTFOXsGrgD4eURjstAHCbuHQaZ9A+6rAgbrEV+j0
         PsHfnyjeL1AKW9eVJZ03IGBHk/+fT5WHpx4zjO2LyR7Iq/gCvrPiVlQVlcpnAku+JXfp
         Uatkqw4zVs1Rp46reLOrc1n4sDrmr+TxZoC+7A2jVmASzGugMfE2bFUVpVzohfvmIRlm
         KBiQ==
X-Gm-Message-State: AOAM533KsjeQhWYx0Czp8gEZNeD8lXGl/YNOpwFgm7NQEGJ+aOsJWn43
        KhN/D2Wus0XoaZt1paNn9bsYag==
X-Google-Smtp-Source: ABdhPJwyV0kCAYS8zhtpz6l8KGJh5RlhH2rviKwOeDCFKFlpKmMI3raFfSdWuPxguPN1PV2EMTVkDg==
X-Received: by 2002:a05:6602:242a:b0:640:746c:c2bd with SMTP id g10-20020a056602242a00b00640746cc2bdmr28851332iob.74.1646345997073;
        Thu, 03 Mar 2022 14:19:57 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id i14-20020a056e021d0e00b002c60beec66asm1878556ila.78.2022.03.03.14.19.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Mar 2022 14:19:56 -0800 (PST)
Subject: Re: [PATCH V2] selftests: Fix build when $(O) points to a relative
 path
To:     Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     kernel@collabora.com, kernelci@groups.io,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220216223817.1386745-1-usama.anjum@collabora.com>
 <46489cd9-fb7a-5a4b-7f36-1c9f6566bd93@collabora.com>
 <63870982-62ba-97f2-5ee2-d4457a7a5cdb@linuxfoundation.org>
 <9a643612-ea85-7b28-a792-770927836d43@linuxfoundation.org>
 <ddb52ffe-5016-cc5a-3af4-a0a8e7b3e119@collabora.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <a6096266-5063-d353-924d-cb0379d25380@linuxfoundation.org>
Date:   Thu, 3 Mar 2022 15:19:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <ddb52ffe-5016-cc5a-3af4-a0a8e7b3e119@collabora.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/26/22 12:32 AM, Muhammad Usama Anjum wrote:
> On 2/26/22 2:13 AM, Shuah Khan wrote:
>> On 2/25/22 11:01 AM, Shuah Khan wrote:
>>> On 2/25/22 10:22 AM, Muhammad Usama Anjum wrote:
>>>> Any thoughts about it?
>>>>
>>>
>>> No to post please.
>>>
>>>> On 2/17/22 3:38 AM, Muhammad Usama Anjum wrote:
>>>>> Build of bpf and tc-testing selftests fails when the relative path of
>>>>> the build directory is specified.
>>>>>
>>>>> make -C tools/testing/selftests O=build0
>>>>> make[1]: Entering directory
>>>>> '/linux_mainline/tools/testing/selftests/bpf'
>>>>> ../../../scripts/Makefile.include:4: *** O=build0 does not exist.
>>>>> Stop.
>>>>> make[1]: Entering directory
>>>>> '/linux_mainline/tools/testing/selftests/tc-testing'
>>>>> ../../../scripts/Makefile.include:4: *** O=build0 does not exist.
>>>>> Stop.
>>>>>
>>>>> Makefiles of bpf and tc-testing include scripts/Makefile.include file.
>>>>> This file has sanity checking inside it which checks the output path.
>>>>> The output path is not relative to the bpf or tc-testing. The sanity
>>>>> check fails. Expand the output path to get rid of this error. The
>>>>> fix is
>>>>> the same as mentioned in commit 150a27328b68 ("bpf, preload: Fix build
>>>>> when $(O) points to a relative path").
>>>>>
>>>>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
>>>>> ---
>>>>> Changes in V2:
>>>>> Add more explaination to the commit message.
>>>>> Support make install as well.
>>>
>>
>> Does the same happen when you use make kselftest-all?
> No, this problem doesn't appear when using make kselftest-all.
> 
> As separate output directory build was broken in kernel's top most
> Makefile i.e., make kselftest-all O=dir. (I've sent separate patch to
> fix this:
> https://lore.kernel.org/lkml/20220223191016.1658728-1-usama.anjum@collabora.com/)
> So people must have been using kselftest's internal Makefile directly to
> keep object files in separate directory i.e., make -C
> tools/testing/selftests O=dir and in this way the build of these tests
> (bpf, tc-testing) fail. This patch is fixing those build errors.
> 
>>
>> I am unable to reproduce what you are seeing?
> make -C tools/testing/selftests O=dir should reproduce this problem.
> 

Applied to linux-kselftest next for Linux 5.18-rc1.

thanks,
-- Shuah
