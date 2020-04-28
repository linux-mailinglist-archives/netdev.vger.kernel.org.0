Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2551BC4C9
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 18:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728307AbgD1QPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 12:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728300AbgD1QPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 12:15:23 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A37DC03C1AB
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 09:15:23 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id 19so23493752ioz.10
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 09:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MT46h/9sh3htYvv1ttQSn0o5BnyglQi3SnN5/QwyERE=;
        b=VwSceNCVOsBaOHG9Jrn4w/xqHjZiqVRMTSUhrChS/MO2lVKfgwbrSFVUi7xr94P62U
         KimxwjTm7Uojyso/0vhF37Qy8GZjeKxNgJxG1woHKDm9yFVSEggQUTMvqzUX6nvj1V9F
         YgG0R8wW9d27+/Jh1/SBYmA0NEnXHvUo6ynFb6JAQKd7aAjfS1yqAZliXGU07bIjJ7OX
         USqC3E/KWKoGRMMPet0Xu5nguCubOK6r3gXZs2g478w4QLy88vua0kXyScBpXfliAc/G
         KxRmrqgKJLiSQHSx804kD+LYIknn54x/6R4oBszfIEO0im5V4bCdPzIL3wpRSlwxpPLu
         SQgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MT46h/9sh3htYvv1ttQSn0o5BnyglQi3SnN5/QwyERE=;
        b=YMm0W8bIOjvBLazq95PKnNQu37L5YU43HvMuNYhtSMXW2fJpbmL1BMme3rZrrrNWTj
         OpefXQ+8tAlJUfIKHYpP/HPZDcjkNjtSiG/ayiMq5YkLv6/qosIoXZr070r/5yOgRrh9
         RjhLo3yNlDGgk/HzBqwgtQzuaYZMiWvzvmwL2cWPQWLp2ZfOmDnqFyVu7F1DGzzeLFgz
         63AII5El5FRkNwwavcxIURyn1SBMjbnzItfMFxZ+fn3frCfguqWxEfgLWf9ViN/2Iv+J
         g/IDPbMZKP4om4Z1nBbRP4taAPbKdHJXiQ9n8pE7oKyXqI0FmxhNDCQth2j7lS7YPubG
         hGCg==
X-Gm-Message-State: AGi0PuZzOhI7EA+09ftUw4eeQNXfO2tL32fIkjJ21lCvN0vngKrTBu+A
        uwzHVlStsunJ5jYTBJlZ1a0BdA==
X-Google-Smtp-Source: APiQypIFCsMKWyYKdJgjRAUck8rugpuyDklCzyFDtWUKvWh012o+o7FPjXhJ5oiS0vF8vGFk+1q+dA==
X-Received: by 2002:a02:1a01:: with SMTP id 1mr26555223jai.26.1588090522999;
        Tue, 28 Apr 2020 09:15:22 -0700 (PDT)
Received: from [10.0.0.125] (23-233-27-60.cpe.pppoe.ca. [23.233.27.60])
        by smtp.googlemail.com with ESMTPSA id r18sm6083126ioj.15.2020.04.28.09.15.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2020 09:15:22 -0700 (PDT)
Subject: Re: [PATCH iproute2 v3 0/2] bpf: memory access fixes
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, aclaudi@redhat.com,
        daniel@iogearbox.net, asmadeus@codewreck.org
References: <20200423175857.20180-1-jhs@emojatatu.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <125e68f2-2868-34c1-7c13-f3fcdf844835@mojatatu.com>
Date:   Tue, 28 Apr 2020 12:15:21 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200423175857.20180-1-jhs@emojatatu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stephen,
What happened to this?

cheers,
jamal

On 2020-04-23 1:58 p.m., Jamal Hadi Salim wrote:
> From: Jamal Hadi Salim <jhs@mojatatu.com>
> 
> Changes from V2:
>   1) Dont initialize tmp on stack (Stephen)
>   2) Dont look at the return code of snprintf (Dominique)
>   3) Set errno to EINVAL instead of returning -EINVAL for consistency (Dominique)
> 
> Changes from V1:
>   1) use snprintf instead of sprintf and fix corresponding error message.
>   Caught-by: Dominique Martinet <asmadeus@codewreck.org>
>   2) Fix memory leak and extraneous free() in error path
> 
> Jamal Hadi Salim (2):
>    bpf: Fix segfault when custom pinning is used
>    bpf: Fix mem leak and extraneous free() in error path
> 
>   lib/bpf.c | 17 +++++++----------
>   1 file changed, 7 insertions(+), 10 deletions(-)
> 

