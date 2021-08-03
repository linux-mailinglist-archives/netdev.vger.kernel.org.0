Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9FEE3DF29F
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233424AbhHCQgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233325AbhHCQgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 12:36:14 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA5DFC061757
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 09:36:02 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id p5so26002033wro.7
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 09:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2BUPgsv1ezfcVvRUYGjGq/bK349pcuBGYv6GJMpEwjo=;
        b=ollK4aUJRa/zU0bmxNOOn96Ayjm0taA3P36QHPIRi42x52PEScLdS4V4RsiwxliMcP
         xp9CSElUbwBMc3COZ30vAaHDYOH7tnz3Yd1SEt5ggMm1HI9PEQcHtnTuad0BCpnFMa6D
         uH5bBrEiv+AtQL1TdtBBhK3cpUo6G15SMlcKZSarZ8wNCaEO7huEK1BLPI1ZxtieTl2F
         N+2ywpRttfbNa53QD64aDibw0lHe2JBeU+0b/rbAV7hfce2B52MOkgnDGFvswOa2xQk2
         VURCr6btbyUCFd3YqRp1/V+Wngdh4q+uquZrCGW8/1PndUSmngC/Tn83P12JPK9AX9ss
         4YMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2BUPgsv1ezfcVvRUYGjGq/bK349pcuBGYv6GJMpEwjo=;
        b=gB/ycU+9nS3JiVOXEXO9IPmllLatxTH6FRK8y4rQ2L/LpRW2KJiTH39bECG8Grvq+j
         KGkxMnlfa3nshbx1hMpoyYjqYkpO2Yr0p3fVQVSW0b1pyTGzfCXupTrsRo/Mqs/xbbkl
         Ob4BDQXEg9yEeEs64aol3TCIw04mIfYSPdZ4RLpVdKk2I/ZiBno3QbtDwFKQ6zt3owPC
         jfHonkIBkUn5woaMVe9rm+LaGLeTqDiD+QXo+NaJaqCWuAZ8SwNjOJFK7I8/ROFdIpK5
         nAB0G7bczui8HBFwXWjvdxMAfDSqFaRcJS5Dm4r97Zvqd2QwEX8NGgSToeE91VK5oQA5
         gq3g==
X-Gm-Message-State: AOAM532lRdJrlFJMwkNv75sh+ks8zP9iYzh+u7zXTLUVBgJ90WkGQUHm
        kmN/hLFNqvCQE6tD0U+5cz1YXTO9r6U=
X-Google-Smtp-Source: ABdhPJxj38FAOLwaKdXSTlZzAXaXloStf0mBks/4YAQz4I8eggyCco+nVrTQu2hMhsSMHco+biKEbA==
X-Received: by 2002:a5d:54c2:: with SMTP id x2mr24994916wrv.338.1628008561472;
        Tue, 03 Aug 2021 09:36:01 -0700 (PDT)
Received: from [10.0.0.18] ([37.165.199.45])
        by smtp.gmail.com with ESMTPSA id n186sm3593291wme.40.2021.08.03.09.35.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 09:36:00 -0700 (PDT)
Subject: Re: [RFC net-next] ipv6: Attempt to improve options code parsing
To:     Justin Iurman <justin.iurman@uliege.be>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, tom@herbertland.com
References: <20210802205133.24071-1-justin.iurman@uliege.be>
 <ce46ace3-11b9-6a75-b665-cee79252550e@gmail.com>
 <989297896.30838930.1628006793490.JavaMail.zimbra@uliege.be>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <aa58193c-0a8f-d11b-fb0c-bc41571e33ac@gmail.com>
Date:   Tue, 3 Aug 2021 18:35:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <989297896.30838930.1628006793490.JavaMail.zimbra@uliege.be>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/3/21 6:06 PM, Justin Iurman wrote:
>>> As per Eric's comment on a previous patchset that was adding a new HopbyHop
>>> option, i.e. why should a new option appear before or after existing ones in the
>>> list, here is an attempt to suppress such competition. It also improves the
>>> efficiency and fasten the process of matching a Hbh or Dst option, which is
>>> probably something we want regarding the list of new options that could quickly
>>> grow in the future.
>>>
>>> Basically, the two "lists" of options (Hbh and Dst) are replaced by two arrays.
>>> Each array has a size of 256 (for each code point). Each code point points to a
>>> function to process its specific option.
>>>
>>> Thoughts?
>>>
>> Hi Justin
>>
>> I think this still suffers from indirect call costs (CONFIG_RETPOLINE=y),
>> and eventually use more dcache.
> 
> Agree with both. It was the compromise for such a solution, unfortunately.
> 
>> Since we only deal with two sets/arrays, I would simply get rid of them
>> and inline the code using two switch() clauses.
> 
> Indeed, this is the more efficient. However, we still have two "issues":
>  - ip6_parse_tlv will keep growing and code could look ugly at some point

Well, in 10 years there has not been a lot of growth.

>  - there is still a "competition" between options, i.e. "I want to be at the top of the list"

Why would that be ?

A switch() is compiled with no particular order by the compiler.

Code generation depends on case density, and will use bisection-like strategy.

> 
> Anyway, your solution is better than the current one so it's probably the way to go right now.
> 
