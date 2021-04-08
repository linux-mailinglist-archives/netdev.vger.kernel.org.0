Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 241E8358290
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 13:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbhDHL7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 07:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbhDHL7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 07:59:41 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E96E1C061760
        for <netdev@vger.kernel.org>; Thu,  8 Apr 2021 04:59:29 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id f12so1137630qtq.4
        for <netdev@vger.kernel.org>; Thu, 08 Apr 2021 04:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Jzils9XxfZ0YfLvTaV3EQIif0r7otuWhqOk5WG/muaU=;
        b=Iy+Aw/Xaib6mr/ODr0ZfcItEzB8Np0XizGb9Hrqsq56f4E+SyMRmethv2KT0OfiS9/
         Kw+VJ6OwaDNuSHLbPWAXm/olhh4nkZwMp/ako1cwEhgxAUI08OYcferb29gFC2w9Xq8u
         KAtg8O/CQiJYqU3GOBNQSQkVr9jW18cJNHiw1T84euIdXsP4kqOmXBFQaydb4GKdS+s6
         GpGZiRz51SeLiF9V7zbuR8UQeXjW3XwWSr3nUViYI2wyUcHlWTwLHudSFmNZZeGTos7A
         ON9c/yqPvuWaTp+EnWskYAkMiNyVQnZc5oCAuFlWh4BZOJH29F7u6izCocxUEfNSN9/p
         znRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Jzils9XxfZ0YfLvTaV3EQIif0r7otuWhqOk5WG/muaU=;
        b=YNd3V+gG6yjPdQhjO4Clt//2709M1w8Usn8IzArriIrtosvaR8qHLw7rrA9V1Nx4tF
         OqaNjOb/xwDd+4uyRRHHR25XetNhOLztsOdV4/8qWsRndM3PuWLrsHYN2vUQNoWaBOKq
         nPjGlSN6yT6AsLXSsoHkrFeAzHuOTRy9/w6zeJZlPFbXWMKMfIPuJ5J2zo6ZS2dvQZ7w
         2YHgytOXdB1BNnrV15pVAvO4GIl/1WBI/aGvmlDE+Jeqv7m4EUlKjk4KS5OWdwfrRwhH
         IGJ8IliXOZd31WkVW/Cc2+01DimvwGJ+TNTF2Q8i1KG8C8nsvPkdZYe+fZt2STxW/jrH
         Dawg==
X-Gm-Message-State: AOAM5321Ugs5p1Az6EPnkdziqqgblHxwHolScRUaLtdTX+JzIZkBdbax
        tDULovuN+UO07lAyekfoPSClKg==
X-Google-Smtp-Source: ABdhPJyCHQfrcu8lFpUHGXa58lilGKK0pvlusc1ExyXbBf2mUBcYD1YuegnPTyXws7yN7EMcJFdoPA==
X-Received: by 2002:ac8:5745:: with SMTP id 5mr6946882qtx.252.1617883169227;
        Thu, 08 Apr 2021 04:59:29 -0700 (PDT)
Received: from [192.168.1.79] (bras-base-kntaon1617w-grc-22-184-144-36-31.dsl.bell.ca. [184.144.36.31])
        by smtp.googlemail.com with ESMTPSA id o76sm20718254qke.79.2021.04.08.04.59.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Apr 2021 04:59:28 -0700 (PDT)
Subject: Re: [PATCH net v2 2/3] net: sched: fix action overwrite reference
 counting
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgense?= =?UTF-8?Q?n?= 
        <toke@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>
References: <20210407153604.1680079-1-vladbu@nvidia.com>
 <20210407153604.1680079-3-vladbu@nvidia.com>
 <CAM_iQpXEGs-Sq-SjNrewEyQJ7p2-KUxL5-eUvWs0XTKGoh7BsQ@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <6dd90b61-ad41-6e3a-bab7-1f6da2ed1905@mojatatu.com>
Date:   Thu, 8 Apr 2021 07:59:27 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpXEGs-Sq-SjNrewEyQJ7p2-KUxL5-eUvWs0XTKGoh7BsQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-04-07 7:50 p.m., Cong Wang wrote:
> On Wed, Apr 7, 2021 at 8:36 AM Vlad Buslov <vladbu@nvidia.com> wrote:
>>
>> Action init code increments reference counter when it changes an action.
>> This is the desired behavior for cls API which needs to obtain action
>> reference for every classifier that points to action. However, act API just
>> needs to change the action and releases the reference before returning.
>> This sequence breaks when the requested action doesn't exist, which causes
>> act API init code to create new action with specified index, but action is
>> still released before returning and is deleted (unless it was referenced
>> concurrently by cls API).
>>
>> Reproduction:
>>
>> $ sudo tc actions ls action gact
>> $ sudo tc actions change action gact drop index 1
>> $ sudo tc actions ls action gact
>>
> 
> I didn't know 'change' could actually create an action when
> it does not exist. So it sets NLM_F_REPLACE, how could it
> replace a non-existing one? Is this the right behavior or is it too
> late to change even if it is not?

Thats expected behavior for "change" essentially mapping
to classical "SET" i.e.
"create if it doesnt exist, replace if it exists"
i.e NLM_F_CREATE | NLM_F_REPLACE

In retrospect, "replace" should probably have been just NLM_F_REPLACE
"replace if it exists, error otherwise".
Currently there is no distinction between the two.

"Add" is classical "CREATE" i.e "create if doesnt exist, otherwise
error"

It may be feasible to fix "replace" but not sure how many scripts over
the years are now dependent on that behavior.

cheers,
jamal
