Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF88731FC02
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 16:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbhBSPdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 10:33:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbhBSPdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 10:33:16 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B62EC061574;
        Fri, 19 Feb 2021 07:32:36 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id a4so6882083wro.8;
        Fri, 19 Feb 2021 07:32:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xhZ86LSvSFpB1ncs9HLMCOJV7EvF9ulw0bvkQn5EhBM=;
        b=CCh3tvBRJoUGPyVwF/Ly82OpDcjX13g6K5+UuBlUSdYytKByL/6n0G1+lueiddtmZS
         N8wojjBtEv622Vi3P06Bn/rf8LtiZD/gTGtc6+haiHSxzRTJgbQGrJ5gmq/S0gtHw6DI
         GxBnI4bniIIiZJb5pYbGWFRDr643RBjcwUzkIBNI/iTGNfaeIhOf0puHx7ifxhGstLro
         oPT84czE8gpfpV2PRmjF4laWXr64ETxKtnvblfqZuNWvcGK19ItoZLnQtLnQtN9HZ480
         hHPTLPaLjXOiaC8Jmp2PxGmqGWPrRmgonN5pES7x89/nmWE7Fn2mEQtdcjB29veoiUIy
         pxEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xhZ86LSvSFpB1ncs9HLMCOJV7EvF9ulw0bvkQn5EhBM=;
        b=Q/2Hfs60T7u490JRGv9ia/yTnRezV+plGwbvZXYKanIe4fVCvKR/XbzePLVNoD/6yA
         C0444pXnJ5KiPVZbW0UGO0QejGpNl4Q3zL+s8OpT91bE+JyUsafZI0qnO+xleNeUbuti
         GeIw7dmIJMFTaq7kqKFgQQSjPvB/fYUuEOVj/DR4iOiqALF0NpTyvllUraCAQ8qd99M4
         /RbrZnpSroLb34ak9U3hk6x/bmxMPtxcfLl7HkJIBcVlpFU8jMQn2bupGTxs57h1H6tf
         LXhIgFa9BGiRDBHgf/1C6oJd2VmfQniNTeZi74MFcSMqJG5aARTzF9dIZ+I3Xo0u2Qey
         7klA==
X-Gm-Message-State: AOAM5328jTDHr9gMuZ/TFZ0FSBn1ooJqd8YqadOYllREDyDetW1UprD+
        gBvmrAHuhAo5vT/4TT/uCYs=
X-Google-Smtp-Source: ABdhPJzm8O7Nz8oDzwv0a8GKdXXz7l2NlrEci+QKRvLxA2Iu1yPselt2Xwm4E9ARItxez8CbGmc6fw==
X-Received: by 2002:adf:fa91:: with SMTP id h17mr9586162wrr.257.1613748754826;
        Fri, 19 Feb 2021 07:32:34 -0800 (PST)
Received: from [192.168.1.101] ([37.170.232.180])
        by smtp.gmail.com with ESMTPSA id t11sm1945644wmb.32.2021.02.19.07.32.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Feb 2021 07:32:34 -0800 (PST)
Subject: Re: [PATCH bpf-next v2 1/4] net: add SO_NETNS_COOKIE socket option
To:     Lorenz Bauer <lmb@cloudflare.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
References: <20210219095149.50346-1-lmb@cloudflare.com>
 <20210219095149.50346-2-lmb@cloudflare.com>
 <00f63863-34ae-aa25-6a36-376db62de510@gmail.com>
 <CACAyw9_kY9fPdC5DLz4GKiBR8B4mCCnknB2xY1DSKYwkridgFQ@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <f4ac5b02-3821-787c-6da9-50aa44d2847b@gmail.com>
Date:   Fri, 19 Feb 2021 16:32:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CACAyw9_kY9fPdC5DLz4GKiBR8B4mCCnknB2xY1DSKYwkridgFQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/19/21 1:23 PM, Lorenz Bauer wrote:
> On Fri, 19 Feb 2021 at 11:49, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>
>>> +     case SO_NETNS_COOKIE:
>>> +             lv = sizeof(u64);
>>> +             if (len < lv)
>>> +                     return -EINVAL;
>>
>>         if (len != lv)
>>                 return -EINVAL;
>>
>> (There is no reason to support bigger value before at least hundred years)
> 
> Sorry that was copy pasta from SO_COOKIE which uses the same check. I'll
> change it to your suggestion. Want me to fix SO_COOKIE as well?

Unfortunately it is too late for SO_COOKIE

Some applications might use len = 256, and just look at what the kernel
gives back.

Better be strict at the time a feature is added, instead of having
to maintain legacy stuff.

