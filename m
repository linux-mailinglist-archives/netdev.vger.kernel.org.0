Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 252403CD68D
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 16:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241100AbhGSNoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 09:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241055AbhGSNoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 09:44:07 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD6DC061574;
        Mon, 19 Jul 2021 06:50:45 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id t5so22244575wrw.12;
        Mon, 19 Jul 2021 07:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iJb8k19Y68cQ26kCOkNjiEf5YK8/nAR7Q1gJ3928CnI=;
        b=T0oK4JxzZ8pyuYqCEuhGFUWAm90vPZvpJ5FopJBMYTz5T9joodP1iNPyT5Ax6p0g74
         +By7csl0eik1QDfi+zDKjaQKIuXBH25O32x/7UkAwxQFMbqyFcPLfDla+dio31lZ+Fws
         Ui3gsGNqqBB5ou20NAOWzjtv3G0+ApgVzXdFFoxtg92nRejmXWt0nayD8jGGerDm7Vq9
         a68UeqZTbj6jRIO0HTy6Rwe2D9hCEqe4jlMD8Ijmg3v43e+RG9tampTKS6mmSQScfLmM
         pxaK8qVMzxglGQrCBofgSuRCATOMzTMpp3DainE2CPsKLMub59e+fb+Qn2+pjKnDeRqj
         LlQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iJb8k19Y68cQ26kCOkNjiEf5YK8/nAR7Q1gJ3928CnI=;
        b=LXPvQj1L8Fd4cLJo02JnqEuhEkgQIduwpLnwKjps+LJ7aXTCAOvevUS0OqMBN59b2G
         M4UyiFojaxtW2KwAAa9ywbEnaCBgGYN7pHXx6vHAelBGWsgDAfYy+QNAurZXAKteJk+V
         lqNnea2AQENHlTCSmgfzocyb2XTUew/q0uYL54pFjAK2bmybb2Yk9blPNKiULa5hzkyh
         Z0HEPWbm5HQFNgOuWS2S3aEdMUqBfZexpeaDhsgbpfQuw0QcZ1aB/XK4Zvrqhn1SuEyX
         xC8b9kau5i5F+dgsWbQF+uz4gZ7xbRz9PmGv9xw4Xy8azK/Ea7F15yojvcmLEaiKmYHL
         tZTQ==
X-Gm-Message-State: AOAM533t22p6O4hdBpe+VW1vRE+eYLRkcjZTK/MgXIVqPCIO2lHUtpQy
        FCyfvvK9cbQsMwEIvzzXyk8=
X-Google-Smtp-Source: ABdhPJyfXD/w6U3/F6XPoN9fIiWMlAhlbVA27hk1etsCXW5M8H5KslQRnNDEhxnO5hOwcsC1A4KdNg==
X-Received: by 2002:adf:82f1:: with SMTP id 104mr30161129wrc.306.1626704685116;
        Mon, 19 Jul 2021 07:24:45 -0700 (PDT)
Received: from ?IPv6:2a02:8084:e84:2480:228:f8ff:fe6f:83a8? ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id p4sm20891339wrt.23.2021.07.19.07.24.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jul 2021 07:24:44 -0700 (PDT)
Subject: Re: [PATCH v5 02/16] memcg: enable accounting for IP address and
 routing-related objects
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Vasily Averin <vvs@virtuozzo.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Roman Gushchin <guro@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <CALvZod66KF-8xKB1dyY2twizDE=svE8iXT_nqvsrfWg1a92f4A@mail.gmail.com>
 <cover.1626688654.git.vvs@virtuozzo.com>
 <9123bca3-23bb-1361-c48f-e468c81ad4f6@virtuozzo.com>
 <CAJwJo6ZgXDoXevNRte4G3Phei8WcgJ897JebWDkQDnPYrgTTQA@mail.gmail.com>
 <CALvZod7YhG1Ojp2Eyk=30OBzWr5_AyEW-c1AhQVDn7zpd6mpww@mail.gmail.com>
From:   Dmitry Safonov <0x7f454c46@gmail.com>
Message-ID: <55811200-dfca-0cc6-9dd4-692066adf4c6@gmail.com>
Date:   Mon, 19 Jul 2021 15:24:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CALvZod7YhG1Ojp2Eyk=30OBzWr5_AyEW-c1AhQVDn7zpd6mpww@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/19/21 3:22 PM, Shakeel Butt wrote:
> On Mon, Jul 19, 2021 at 7:00 AM Dmitry Safonov <0x7f454c46@gmail.com> wrote:
>>
>> Hi Vasily,
>>
>> On Mon, 19 Jul 2021 at 11:45, Vasily Averin <vvs@virtuozzo.com> wrote:
>> [..]
>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>> index ae1f5d0..1bbf239 100644
>>> --- a/mm/memcontrol.c
>>> +++ b/mm/memcontrol.c
>>> @@ -968,7 +968,7 @@ static __always_inline bool memcg_kmem_bypass(void)
>>>                 return false;
>>>
>>>         /* Memcg to charge can't be determined. */
>>> -       if (in_interrupt() || !current->mm || (current->flags & PF_KTHREAD))
>>> +       if (!in_task() || !current->mm || (current->flags & PF_KTHREAD))
>>>                 return true;
>>
>> This seems to do two separate things in one patch.
>> Probably, it's better to separate them.
>> (I may miss how route changes are related to more generic
>> __alloc_pages() change)
>>
> 
> It was requested to squash them together in some previous versions.
> https://lore.kernel.org/linux-mm/YEiUIf0old+AZssa@dhcp22.suse.cz/
> 

Ah, alright, never mind than.

Thanks,
           Dmitry
