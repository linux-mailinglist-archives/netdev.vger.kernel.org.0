Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 292234B783F
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235205AbiBOSoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 13:44:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240627AbiBOSoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 13:44:00 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF58827FF5
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 10:43:49 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id d7so9743437ilf.8
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 10:43:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=A0+kP93DPXHvr6brEvM8VXEFzWB0S5lRFdtA9kDJkyE=;
        b=VbnG0DTFoD5oInsLnSpyK8TY1b9yTtEV8jmDclcI0lVoHXaRfQ+1Kei06xf8rXYF7T
         Wg/jkDG2mswlylVxkUyUwagh7VpOigDobBSIN+ruOXrKdEbqescCjLVZjKa5xcviv9J2
         6BHdIVuOY/izVwkXKs6tMZ1SXb1wuGFnkP+R4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A0+kP93DPXHvr6brEvM8VXEFzWB0S5lRFdtA9kDJkyE=;
        b=m24fLa1yxqyuXl7GbVmL5VpfYu1tBh1lv5VrixEoMxI2z+K14puLa0Zc1k8g6k/yX7
         26FyhVlGli0yIL1v4qc+ebGBW99z62cDhAC/wEQnnWrn+2nKIqbRzGa6jQC9KM6q9VGd
         FCTikJOsqBWg5WNZz/NKpTz/XZy72KMQ72Y9SthB5d8eiYkI8/YidGt2SKyMteo9r4jZ
         xINv0iyVyHEp3msGxC8u2vyxj1AP5yvDOIXzs68oryeid1qaUyadNi+xLg9yPYROCBdJ
         2pwa4DFkNbTv+Xbdg5HIM6tKfOBXar7e4V9QLrvCcR5rHcvPnxXpVKAOXpbCGKp4ar8j
         P+xQ==
X-Gm-Message-State: AOAM532BugsYZ+7Ue4cF/n+aP/KjsZOEQ/T58E0S+2S+HYH/5xzdBOiR
        CegXVrdhwxXApoiZtRFqhg5f4A==
X-Google-Smtp-Source: ABdhPJy2vlGZWPGrF4v8TITllv20RRsSaBCpm9YRhgNODL/5uMIm2Jii7qjTHVGojYsoa6gztygi5g==
X-Received: by 2002:a05:6e02:1bc1:: with SMTP id x1mr258711ilv.268.1644950629300;
        Tue, 15 Feb 2022 10:43:49 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id s16sm12850411iow.10.2022.02.15.10.43.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Feb 2022 10:43:49 -0800 (PST)
Subject: Re: [PATCH v2] selftests/seccomp: Fix seccomp failure by adding
 missing headers
To:     Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Sherry Yang <sherry.yang@oracle.com>
Cc:     "shuah@kernel.org" <shuah@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        "luto@amacapital.net" <luto@amacapital.net>,
        "wad@chromium.org" <wad@chromium.org>,
        "christian@brauner.io" <christian@brauner.io>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220210203049.67249-1-sherry.yang@oracle.com>
 <755ec9b2-8781-a75a-4fd0-39fb518fc484@collabora.com>
 <85DF69B3-3932-4227-978C-C6DAC7CAE64D@oracle.com>
 <66140ffb-306e-2956-2f6b-c017a38e18f8@collabora.com>
 <4b739847-0622-c221-33b3-9fe428a52bc0@collabora.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <2f59f86c-dbd7-7dbf-021d-bc62ebbe2a43@linuxfoundation.org>
Date:   Tue, 15 Feb 2022 11:43:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <4b739847-0622-c221-33b3-9fe428a52bc0@collabora.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/15/22 11:17 AM, Muhammad Usama Anjum wrote:
> 
> On 2/14/22 9:12 PM, Muhammad Usama Anjum wrote:
>>>> "../../../../usr/include/" directory doesn't have header files if
>>>> different output directory is used for kselftests build like "make -C
>>>> tools/tests/selftest O=build". Can you try adding recently added
>>>> variable, KHDR_INCLUDES here which makes this kind of headers inclusion
>>>> easy and correct for other build combinations as well?
>>>>
>>>>
>>>
>>> Hi Muhammad,
>>>
>>> I just pulled linux-next, and tried with KHDR_INCLUDES. It works. Very nice
>>> work! I really appreciate you made headers inclusion compatible. However,
>>> my case is a little more complicated. It will throw warnings with -I, using
>>> -isystem can suppress these warnings, more details please refer to
>>> https://lore.kernel.org/all/C340461A-6FD2-440A-8EFC-D7E85BF48DB5@oracle.com/
>>>
>>> According to this case, do you think will it be better to export header path
>>> (KHDR_INCLUDES) without “-I”?
>> Well said. I've thought about it and it seems like -isystem is better
>> than -I. I've sent a patch:
>> https://lore.kernel.org/linux-kselftest/20220214160756.3543590-1-usama.anjum@collabora.com/
>> I'm looking forward to discussion on it.
> The patch has been accepted. It should appear in linux-next soon. You
> should be able to use KHDR_INCLUDES easily now.
> 

Sherry,

I pulled in your patch as a fix as is for 5.17-rc5.

Using KHDR_INCLUDES can be separate patch for next release.
This way the fix is going to be pulled for this release
without dependencies on other patches.

thanks,
-- Shuah
