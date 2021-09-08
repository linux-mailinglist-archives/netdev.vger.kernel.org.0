Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFF6403E40
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 19:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351822AbhIHRR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 13:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349264AbhIHRRz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 13:17:55 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92EDC061575
        for <netdev@vger.kernel.org>; Wed,  8 Sep 2021 10:16:46 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id q3so4239810iot.3
        for <netdev@vger.kernel.org>; Wed, 08 Sep 2021 10:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wXplQMubjcd6fCTPFQofW1bbtwJw+knTkqPSzTUItas=;
        b=E/8T+sVaLCWx1hbAmMySx72lTe77R2eEaA5yZQMBxdWe+SS5W9ydqZ4BBpH4BqpJ1g
         5G8lncyz+I+uiGoXEcLL6IFbYIaSPzeHJDwxV4VH5CS1WqDoiemXe+95Vi+LwXeZNzUP
         xG7p+SZJeQ2la/u7TPBbqtdlAW5PNv2mJd+qg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wXplQMubjcd6fCTPFQofW1bbtwJw+knTkqPSzTUItas=;
        b=RQS23r2C/5Y8xLMEGv4dUePAUJxme7nJwcqAJKTkg92ZFOXr2wrMHkqfkICrCRHTB0
         PLhFNRx6ZRzUp2XqdvK+8Ye/+kFMscnwSIj861DjfEZohVyti9lz33XOUFk8M2UFWjCp
         d+8jYJtl7FNu3eZ2NP/EfFNsWL2N5dzCKDJ+4ugpV9hO2BhIWBHtVkVzkfkGJVfYoOsR
         /k5dZOJndDFF1riUFFB9E8JZOz4EEaRCoSgKEs7ybQPmlVZr8O6y7mW5/x7hufaDRaC+
         5IG84AlhgX8/YPM+GH2lW+GhnTnfRFZjthpVH9I5uwX1YiLge4UKeveQO0BmHurquuwa
         bLiw==
X-Gm-Message-State: AOAM533lDuVFLA8h53zWwuQUMiE1B3f2Anm6m9xeEBZTBICFn3sdazGl
        ncS7cTABPE/AjguyR2yzu2EYDA==
X-Google-Smtp-Source: ABdhPJw+fLIAgN6eXO/bn5p+o6ATA+ketYOj97BdB6Xy/+hUTMbGPzl+dajyYMJrnyELyJoR7Ov9Ng==
X-Received: by 2002:a6b:be02:: with SMTP id o2mr756764iof.103.1631121406277;
        Wed, 08 Sep 2021 10:16:46 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id m13sm1314633ilh.43.2021.09.08.10.16.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 10:16:45 -0700 (PDT)
Subject: Re: ipv4/tcp.c:4234:1: error: the frame size of 1152 bytes is larger
 than 1024 bytes [-Werror=frame-larger-than=]
To:     Arnd Bergmann <arnd@arndb.de>,
        Brendan Higgins <brendanhiggins@google.com>
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
        Shuah Khan <skhan@linuxfoundation.org>
References: <CA+G9fYtFvJdtBknaDKR54HHMf4XsXKD4UD3qXkQ1KhgY19n3tw@mail.gmail.com>
 <CAHk-=wisUqoX5Njrnnpp0pDx+bxSAJdPxfgEUv82tZkvUqoN1w@mail.gmail.com>
 <CAHk-=whF9F89vsfH8E9TGc0tZA-yhzi2Di8wOtquNB5vRkFX5w@mail.gmail.com>
 <36aa5cb7-e3d6-33cb-9ac6-c9ff1169d711@linuxfoundation.org>
 <CAK8P3a1vNx1s-tcjtu6VDxak4NHyztF0XZGe3wOrNbigx1f4tw@mail.gmail.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <120389b9-f90b-0fa3-21d5-1f789b4c984d@linuxfoundation.org>
Date:   Wed, 8 Sep 2021 11:16:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAK8P3a1vNx1s-tcjtu6VDxak4NHyztF0XZGe3wOrNbigx1f4tw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/8/21 11:05 AM, Arnd Bergmann wrote:
> On Wed, Sep 8, 2021 at 4:12 PM Shuah Khan <skhan@linuxfoundation.org> wrote:
>> On 9/7/21 5:14 PM, Linus Torvalds wrote:
>>> The KUNIT macros create all these individually reasonably small
>>> initialized structures on stack, and when you have more than a small
>>> handful of them the KUNIT infrastructure just makes the stack space
>>> explode. Sometimes the compiler will be able to re-use the stack
>>> slots, but it seems to be an iffy proposition to depend on it - it
>>> seems to be a combination of luck and various config options.
>>>
>>
>> I have been concerned about these macros creeping in for a while.
>> I will take a closer look and work with Brendan to come with a plan
>> to address it.
> 
> I've previously sent patches to turn off the structleak plugin for
> any kunit test file to work around this, but only a few of those patches
> got merged and new files have been added since. It would
> definitely help to come up with a proper fix, but my structleak-disable
> hack should be sufficient as a quick fix.
> 

Looks like these are RFC patches and the discussion went cold. Let's pick
this back up and we can make progress.

https://lore.kernel.org/lkml/CAFd5g45+JqKDqewqz2oZtnphA-_0w62FdSTkRs43K_NJUgnLBg@mail.gmail.com/

thanks,
-- Shuah

