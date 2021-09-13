Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D925409EA6
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 22:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244673AbhIMU5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 16:57:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241958AbhIMU5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 16:57:03 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9FDBC061760
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 13:55:47 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id c8-20020a9d6c88000000b00517cd06302dso15178378otr.13
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 13:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xlOUwRVv/SaM1ZoZrctrKFCQwOAIgRDrG+ihv2UpfRE=;
        b=hYpUq2fYnjWl98QExTA1Lcm3pKldkQlsz03K4Ceni+OVd4yS3nuQbH84FXn9mymrvU
         FHRAjNULnrb8zqGIaQf3IZLCJr1mdoFuMD8T8azOCroNQE2U0Z7jCawqQPmCMsajotSH
         o9p4ellOkdxtgZIeg0x3L9x1+ZZ6Dwtoj/LrA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xlOUwRVv/SaM1ZoZrctrKFCQwOAIgRDrG+ihv2UpfRE=;
        b=qn4l3Z+SfK0Cd+c8luo6jRZRqj+1UIVDe0zsXGjGfCQE9NMJOGuGt1QpCLopHKUBVj
         AvH/7u30XFg5xzo8vE+eM1xPvJaSGDGtLiB9rQwOLmnxdEPyjdibl2hemSO4FqzOCs9c
         c1UVkbmG55ceLwFWZdtUq7ixQ/Nv7zWMwGjqcQpwbRaJz/CkUZ0HAK3VFEO6Wphx5sev
         L++yd9QSMog/I69HhdpoGL8zbNNzFAXUxJh3jewpkO5XAVVTS2XvWPYJV7MIal4O626f
         YOV6uwvfOGlKncYNwKKTcQTAvQbBuWEgfXPITfS0j17ojkDXil+qID1iElVOP9ljBAbw
         Gq5Q==
X-Gm-Message-State: AOAM53249POB5MNyXdQyjWckFAN4VIB0gUJgzw7LGVTtHAyIZwBAodUl
        i/Vg3/Z8lUlQO0pGbQ1c58SqIA==
X-Google-Smtp-Source: ABdhPJxX6VLJs0ZE/xnRItZvUlnzABjm694fEoRvXc78iBIISqm0Sa0k2us+ag+7HT07CwsTKbCfmQ==
X-Received: by 2002:a05:6830:818:: with SMTP id r24mr11477370ots.2.1631566547004;
        Mon, 13 Sep 2021 13:55:47 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id z1sm2139510ooj.25.2021.09.13.13.55.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 13:55:46 -0700 (PDT)
Subject: Re: ipv4/tcp.c:4234:1: error: the frame size of 1152 bytes is larger
 than 1024 bytes [-Werror=frame-larger-than=]
To:     Brendan Higgins <brendanhiggins@google.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2@marvell.com, Wei Liu <wei.liu@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, lkft-triage@lists.linaro.org,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        KUnit Development <kunit-dev@googlegroups.com>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <CA+G9fYtFvJdtBknaDKR54HHMf4XsXKD4UD3qXkQ1KhgY19n3tw@mail.gmail.com>
 <CAHk-=wisUqoX5Njrnnpp0pDx+bxSAJdPxfgEUv82tZkvUqoN1w@mail.gmail.com>
 <CAHk-=whF9F89vsfH8E9TGc0tZA-yhzi2Di8wOtquNB5vRkFX5w@mail.gmail.com>
 <36aa5cb7-e3d6-33cb-9ac6-c9ff1169d711@linuxfoundation.org>
 <CAK8P3a1vNx1s-tcjtu6VDxak4NHyztF0XZGe3wOrNbigx1f4tw@mail.gmail.com>
 <120389b9-f90b-0fa3-21d5-1f789b4c984d@linuxfoundation.org>
 <CAFd5g47MgGCoenw08hehegstQSujT7AwksQkxA7mQgKhChimNw@mail.gmail.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <3bad5d2f-8ce7-d0b9-19ad-def68d4193dd@linuxfoundation.org>
Date:   Mon, 13 Sep 2021 14:55:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAFd5g47MgGCoenw08hehegstQSujT7AwksQkxA7mQgKhChimNw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/8/21 3:24 PM, Brendan Higgins wrote:
> On Wed, Sep 8, 2021 at 10:16 AM Shuah Khan <skhan@linuxfoundation.org> wrote:
>>
>> On 9/8/21 11:05 AM, Arnd Bergmann wrote:
>>> On Wed, Sep 8, 2021 at 4:12 PM Shuah Khan <skhan@linuxfoundation.org> wrote:
>>>> On 9/7/21 5:14 PM, Linus Torvalds wrote:
>>>>> The KUNIT macros create all these individually reasonably small
>>>>> initialized structures on stack, and when you have more than a small
>>>>> handful of them the KUNIT infrastructure just makes the stack space
>>>>> explode. Sometimes the compiler will be able to re-use the stack
>>>>> slots, but it seems to be an iffy proposition to depend on it - it
>>>>> seems to be a combination of luck and various config options.
>>>>>
>>>>
>>>> I have been concerned about these macros creeping in for a while.
>>>> I will take a closer look and work with Brendan to come with a plan
>>>> to address it.
>>>
>>> I've previously sent patches to turn off the structleak plugin for
>>> any kunit test file to work around this, but only a few of those patches
>>> got merged and new files have been added since. It would
>>> definitely help to come up with a proper fix, but my structleak-disable
>>> hack should be sufficient as a quick fix.
>>>
>>
>> Looks like these are RFC patches and the discussion went cold. Let's pick
>> this back up and we can make progress.
>>
>> https://lore.kernel.org/lkml/CAFd5g45+JqKDqewqz2oZtnphA-_0w62FdSTkRs43K_NJUgnLBg@mail.gmail.com/
> 
> I can try to get the patch reapplying and send it out (I just figured
> that Arnd or Kees would want to send it out :-)  since it was your
> idea).
> 

Brendan,

Would you like to send me the fix with Suggested-by for Arnd or Kees?

thanks,
-- Shuah
