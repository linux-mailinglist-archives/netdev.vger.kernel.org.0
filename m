Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE5E371E41
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 19:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231638AbhECRR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 13:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232176AbhECRRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 13:17:45 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED568C061348
        for <netdev@vger.kernel.org>; Mon,  3 May 2021 10:16:43 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id q7-20020a9d57870000b02902a5c2bd8c17so5091345oth.5
        for <netdev@vger.kernel.org>; Mon, 03 May 2021 10:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=i6f4BsjlUlI0OqtbX1WlaY1k+DwIRLZD4GZR/Bmgl68=;
        b=iiYCg4n605O8nKQjD/59zwQtO7GAqi5VKpgm8xFBVCmsGXShRVMhPCNEKn7id+EjHX
         igj3b+ENnOwx6qjPwmxI6OfsPni3LBuOdVQgZPw/KDrvWnoBYy04nZYQZfELKxPYRpit
         P0V7HxILgkKO5oFaULLJM+1c/GiLF1F4swq1Bl9vWswygVHRK1UwJqOEf44kg2cz4qTx
         lpMLNzZKc2rHAdE4WuFdN1SsWQiK+R+Ks1tINrrm5MIs0X2QiJOn75at6ZncZJpeHMMk
         xFOBPrexdYxV3wQb4cYQhsutpAt6zDou+p5GV3lkbnYpLfko+BW2T0bhB8aTXODecEgp
         b/mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i6f4BsjlUlI0OqtbX1WlaY1k+DwIRLZD4GZR/Bmgl68=;
        b=RybZ+68s26JNi4ZT3hV7lgt5zOR34UWlQRiSjpqDl2qZwFRUZhTHggMi0yGAX92tj2
         0fPCakEuHyVI+CNbJiFccosNY26JzccSX59IhNty1Bxt4EEppb3AWdiS1k/qFguspnqQ
         Kb42Km+lmZQQWyTNXTqRXxlFaCFJmOHIHew3OCvM+dJ5y+Uf0MvAI39555Es4t18UFqc
         JMgFkeICYAVCyP/zg5YOrc4UT9kFhWBn5A0oUPk/RY52wjzWDlN4wt+tHGbgrgABYkJT
         /vhYJ7pJe2ZgYvvmPKf5MRrYxi2HtLyLMUipFtGSMwKcK+2bfSOuNiKxF/1vIqresdWH
         ry9A==
X-Gm-Message-State: AOAM531FXUC0L2zUVA/PKqvrjfyjNIWJ9UOuDEfdfvV8e0UM3DkJI1qU
        Wk3iXQh6aF3znZ/FYD3W0FyoUoSuMGkf7g==
X-Google-Smtp-Source: ABdhPJwDWLK3wSfX44wJEX/SuFyFNKzxWAmg+1gBzs0xyvJyxln9LJkZpXDjDWcyJQ1qmT2wVGoEUw==
X-Received: by 2002:a9d:17e9:: with SMTP id j96mr15818192otj.143.1620062203229;
        Mon, 03 May 2021 10:16:43 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id a15sm76715oid.39.2021.05.03.10.16.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 May 2021 10:16:42 -0700 (PDT)
Subject: Re: [PACTH iproute2-next] ip: dynamically size columns when printing
 stats
To:     Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
References: <20210501031059.529906-1-kuba@kernel.org>
 <20210503075739.46654252@hermes.local>
 <20210503090059.2cea3840@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <be91d0cd-6233-3c8d-e310-a1b7fc842b48@gmail.com>
Date:   Mon, 3 May 2021 11:16:41 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210503090059.2cea3840@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/3/21 10:00 AM, Jakub Kicinski wrote:
> On Mon, 3 May 2021 07:57:39 -0700 Stephen Hemminger wrote:
>> Maybe good time to refactor the code to make it table driven rather
>> than individual statistic items.
> 
> 🤔 should be doable.
> 
> Can I do it on top or before making the change to the columns?
> 

I think it can be a follow on change. This one is clearly an improvement
for large numbers.
