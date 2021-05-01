Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC57437079E
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 17:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231547AbhEAPER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 May 2021 11:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbhEAPEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 May 2021 11:04:13 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2488BC06174A;
        Sat,  1 May 2021 08:03:23 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id i11so1111456oig.8;
        Sat, 01 May 2021 08:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=itk308xolWb0TLt+lcTt/sNiGEmO6nGlr+yjY4aHcG8=;
        b=VsEAGg0soEemdmWiBYXZRWG7VDRwPSt6mUXRz6PnzT/xNhAV0JMhWs3rFu+iPyvdVn
         Vo1H5dzkB8c1kwQBkEmlVAyWpb48HkqRKQ9yYcw228a5CqT0m0iCMneEvKklwtbLMQ9k
         gncMjWdmbfOnG/z1KfxkfaMQ/0QORjYlGNSD/rzTp0iCAM8XW5bvqVQLDHt+n3/AhQ2n
         9W/rbaS8kNRebCnlnahVin2eIbvE1Ndz4BqeyDi7QI+7JTzNIHu5VsproNaJJUsMe2oh
         5vVnJp7uWwCPEHbqrMo++4jecDjedpP1T9Jd4TaCO7yI2mWY8cA6O5lS9sQNtf4SKrkB
         dX6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=itk308xolWb0TLt+lcTt/sNiGEmO6nGlr+yjY4aHcG8=;
        b=gZs7rVk4VvP7Dh2zSRq8NCB1Z+ztky86pRFFXBDonUzYSQiLWzY71UqgNShtWsI0QZ
         SHozzbORw+6/ekWhPzSg6nGdJt30CFJhgYFRpozP6+9vAcbkJzLc9f7/wJLEojEX4pAX
         D0efXMgMmUA9ju+9x897QQdzcahyu+MCbpcEKR+aOfJMqq0+u6+xYAFiVof+H8f81iDA
         FrApIVRQLsQempubu/GnzyBPi5Rjn2LpfSc58LhL19mRc0AMQ5OBOqT08ApCQ1jiXZN+
         EldyEFke4CJK2u0l7greNblAQdbIx+oeESOLXb65qK1b6NFrSsS+MmvaLAhf1MYg2L/V
         UXyw==
X-Gm-Message-State: AOAM530Y+7YLOJ+zAlqcJsfiMw9PGHmmT61z0XPvhlswnatGTTibbxay
        RWOC7qeAfsFSK6wROJgAIxY=
X-Google-Smtp-Source: ABdhPJxsBQLkvy27UcxQcVwVGxnqY77rTdX5OVIyxse6VjmSrB20S/ow+QAxXqo8CKfJDSFYBGW14w==
X-Received: by 2002:aca:bc42:: with SMTP id m63mr14592740oif.96.1619881402530;
        Sat, 01 May 2021 08:03:22 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id q130sm1513986oif.40.2021.05.01.08.03.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 May 2021 08:03:22 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v2] lib/fs: fix issue when
 {name,open}_to_handle_at() is not implemented
To:     Heiko Thiery <heiko.thiery@gmail.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        Petr Vorel <petr.vorel@gmail.com>
References: <20210430062632.21304-1-heiko.thiery@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0daa2b24-e326-05d2-c219-8a7ade7376e0@gmail.com>
Date:   Sat, 1 May 2021 09:03:20 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210430062632.21304-1-heiko.thiery@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/30/21 12:26 AM, Heiko Thiery wrote:
> With commit d5e6ee0dac64b64e the usage of functions name_to_handle_at() and

that is a change to ss:

d5e6ee0dac64 ss: introduce cgroup2 cache and helper functions


> open_by_handle_at() are introduced. But these function are not available
> e.g. in uclibc-ng < 1.0.35. To have a backward compatibility check for the
> availability in the configure script and in case of absence do a direct
> syscall.
> 

When you find the proper commit add a Fixes line before the Signed-off-by:

Fixes: <id> ("subject line")
> Signed-off-by: Heiko Thiery <heiko.thiery@gmail.com>
> ---

make sure you cc the author of the original commit.

> v2:
>  - small correction to subject
>  - removed IP_CONFIG_HANDLE_AT:=y option since it is not required
>  - fix indentation in check function
>  - removed empty lines (thanks to Petr Vorel)
>  - add #define _GNU_SOURCE in check (thanks to Petr Vorel)
>  - check only for name_to_handle_at (thanks to Peter Vorel)

you have 3 responses to this commit. Please send an updated patch with
all the changes and the the above comments addressed.

Thanks,
