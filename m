Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0A94C506A
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 22:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238099AbiBYVNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 16:13:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238027AbiBYVNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 16:13:45 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B3A182D89
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 13:13:12 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id d3so5287937ilr.10
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 13:13:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WYW51JD9bbPEQ4lnb5EQmERyn2Zcwqc61RWoRLurrq8=;
        b=HHnODJ3qiuqSo7UIQya4dlBAsYrgNK8HXIoHRrZn/6MA+vMXF7v16ZhVdvOu8UL+fI
         Vj0FULIVOAOdxgfBoyo+HhQhl95M5EMHhHHLsiLX3wyA3Rgy0wmHNKcaEGK0Rvt/bFjM
         HEifVucNoVhCZnNspWvAH5gZOr/wO+DNVXU9g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WYW51JD9bbPEQ4lnb5EQmERyn2Zcwqc61RWoRLurrq8=;
        b=S+F8H1yW3mIBLNcOsXS64lLKOKmngMVJwrMucTr7rNBqXlXOiP2317HE342dnMMEsj
         Wx3QxXgCDznt/3ROohFAAezQFM1K27X1RnPypfNerhz0//lS1I2TQ/1I271Qa8L0AmOk
         E7jB2v3rlYvB0HMm4ATksfNdQ75XIkjN99pKgJNmBhgU5GVBrZN2l68uZAHYczA4zJQh
         VQIODm+C7X1E5OUr/rOCz/x9tnmn5cNLgdvJNzDjcf0WTuxhHPYXB+oiJYnRE4jr52+B
         yiMgNI274SJ7hqKdPfYcPcs2ocjb3A2Ngs9qoimCEQ8sW7tBxfabq8219DiEOTfx728+
         Zccg==
X-Gm-Message-State: AOAM533ShmG/55mERh6SNjVvLYwqSwgaWFyD7QNEWKZQid3cp7urfICX
        UmCO3daqEUI6WiyWBZ6ICWzyjg==
X-Google-Smtp-Source: ABdhPJwkwthxHErq15favBEsQG6uVFyjOR90Yv8knXt32vNlTmla+qY7A+YblVRqe/QVDDRbOsnmGg==
X-Received: by 2002:a92:8e4a:0:b0:2bc:1a0d:ed41 with SMTP id k10-20020a928e4a000000b002bc1a0ded41mr8097251ilh.96.1645823591441;
        Fri, 25 Feb 2022 13:13:11 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id c9-20020a92b749000000b002c22c39554fsm1930048ilm.31.2022.02.25.13.13.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Feb 2022 13:13:11 -0800 (PST)
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
        KP Singh <kpsingh@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>
Cc:     kernel@collabora.com, kernelci@groups.io,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20220216223817.1386745-1-usama.anjum@collabora.com>
 <46489cd9-fb7a-5a4b-7f36-1c9f6566bd93@collabora.com>
 <63870982-62ba-97f2-5ee2-d4457a7a5cdb@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <9a643612-ea85-7b28-a792-770927836d43@linuxfoundation.org>
Date:   Fri, 25 Feb 2022 14:13:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <63870982-62ba-97f2-5ee2-d4457a7a5cdb@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/25/22 11:01 AM, Shuah Khan wrote:
> On 2/25/22 10:22 AM, Muhammad Usama Anjum wrote:
>> Any thoughts about it?
>>
> 
> No to post please.
> 
>> On 2/17/22 3:38 AM, Muhammad Usama Anjum wrote:
>>> Build of bpf and tc-testing selftests fails when the relative path of
>>> the build directory is specified.
>>>
>>> make -C tools/testing/selftests O=build0
>>> make[1]: Entering directory '/linux_mainline/tools/testing/selftests/bpf'
>>> ../../../scripts/Makefile.include:4: *** O=build0 does not exist.  Stop.
>>> make[1]: Entering directory '/linux_mainline/tools/testing/selftests/tc-testing'
>>> ../../../scripts/Makefile.include:4: *** O=build0 does not exist.  Stop.
>>>
>>> Makefiles of bpf and tc-testing include scripts/Makefile.include file.
>>> This file has sanity checking inside it which checks the output path.
>>> The output path is not relative to the bpf or tc-testing. The sanity
>>> check fails. Expand the output path to get rid of this error. The fix is
>>> the same as mentioned in commit 150a27328b68 ("bpf, preload: Fix build
>>> when $(O) points to a relative path").
>>>
>>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
>>> ---
>>> Changes in V2:
>>> Add more explaination to the commit message.
>>> Support make install as well.
> 

Does the same happen when you use make kselftest-all?

I am unable to reproduce what you are seeing?

thanks,
-- Shuah

