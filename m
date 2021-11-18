Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACAC345612F
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 18:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233971AbhKRRMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 12:12:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233970AbhKRRMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 12:12:41 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4405BC06173E
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 09:09:41 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id b68so6643555pfg.11
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 09:09:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=uAaNcFBaz8xMWJV2W+/3Uo4xhT4fDaoMNM5naM4cPuQ=;
        b=w6EnFf/fdmjFCnM1iJb91AZT+blHrRcY3EIZIQUSbym0jUmMaNDhxnTN5YT3rjGJjZ
         O2sbZPSr2wLkg241GbXHltpbkwwSwyOzSisKSuR5FicUCBycBDY3qwV+C9edY1Gdup4F
         g/9Niko3LRYs0PJP0OGHCagvEw7G7vj+3uu3KAOC6I+7UW29IgN3GctN2MV7L40S7Jp/
         Hqc+ylT81301Dvj5dWqPtjvdW/u1Z4aFhOlu80vYUfo+vNjxCBVTZXGxTFn5RFTxSYTU
         dHUMpvE93pDxSPaO/MblS3YFT3MRhrak9YLuQ3yJvGqgF2sv68CrivJYdtb1glLj5f1w
         IcuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uAaNcFBaz8xMWJV2W+/3Uo4xhT4fDaoMNM5naM4cPuQ=;
        b=kXYXYhFVnz6RvkG5Hd15txdHbLAxnRRmF8KXFG+irDo/pzmDfV9hKdCiYD61THNDBt
         E5oqmeJmCV1pSPIWsR++KR1jIQP/LH5RlA/9Nl20Fm2Ahafhv6wno2U0FpD88kl34oYp
         pPikBtGQwiQ44f/KRvGHqcCYB4XsjqY6vP4ByBUm2LhL/U9lGPKyF2+EVI/ZVJ72lb5c
         UB3HXlbobn3i5Bg91f7Cfhn6gkCd+n+JJfsMXcoa3VLd8RBu2pI5AQJQUrc1D/K+ryys
         JYRJ+AyltLndgQfHIPCOq391J9f0SWEvi0Tw3ZDI05nXS82L4WNNBCZbbTFIwuRbWpNY
         aSEQ==
X-Gm-Message-State: AOAM533XnW7AVPvB8EVRzyssCdLbHZQYz4uxeCgkdTQZiWgcL1aLfBCw
        1KThsYEvVPpe2J747bCFB3soSQ==
X-Google-Smtp-Source: ABdhPJzxXTTx9lD5m5ibuEEC/M2r0+XPA9yTZcSIonpEOusTjbzEAF3y84vs8GUFUvGBreRYNAaZCg==
X-Received: by 2002:aa7:9575:0:b0:49f:ddab:dcdb with SMTP id x21-20020aa79575000000b0049fddabdcdbmr16506842pfq.13.1637255379778;
        Thu, 18 Nov 2021 09:09:39 -0800 (PST)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id na13sm199705pjb.11.2021.11.18.09.09.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Nov 2021 09:09:39 -0800 (PST)
Message-ID: <e1235016-bcec-d7b4-ecbc-cf7e3365317e@linaro.org>
Date:   Thu, 18 Nov 2021 09:09:38 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] skbuff: suppress clang object-size-mismatch error
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     elver@google.com, nathan@kernel.org, ndesaulniers@google.com,
        jonathan.lemon@gmail.com, alobakin@pm.me, willemb@google.com,
        pabeni@redhat.com, cong.wang@bytedance.com, haokexin@gmail.com,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        keescook@chromium.org, edumazet@google.com
References: <CANpmjNNuWfauPoUxQ6BETrZ8JMjWgrAAhAEqEXW=5BNsfWfyDA@mail.gmail.com>
 <931f1038-d7ab-f236-8052-c5e5b9753b18@linaro.org>
 <20211111095444.461b900e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211112.154238.1786308722975241620.davem@davemloft.net>
 <90fece34-14af-8c91-98f5-daf6fad1825b@linaro.org>
 <20211118083833.3c2805d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <20211118083833.3c2805d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/21 08:38, Jakub Kicinski wrote:
> On Thu, 18 Nov 2021 08:05:01 -0800 Tadeusz Struk wrote:
>> On 11/12/21 07:42, David Miller wrote:
>>> From: Jakub Kicinski <kuba@kernel.org>
>>> Date: Thu, 11 Nov 2021 09:54:44 -0800
>>>    
>>>> I'm not sure if that stalled due to lack of time or some fundamental
>>>> problems.
>>>
>>> ran out of time, then had a stroke...
>>>    
>>>> Seems like finishing that would let us clean up such misuses?
>>>
>>> yes it would
>>
>> so since there is not better way of suppressing the issue atm are
>> you ok with taking this fix for now?
> 
> I vote no on sprinkling ugly tags around to silence some random
> checkers warning. We already have too many of them. They are
> meaningless and confusing to people reading the code.
> 
> This is not a fundamental problem, the solution is clear.
> 

Fair enough.

David, did you post your work somewhere if someone would like to pick
it up and finish it?

-- 
Thanks,
Tadeusz
