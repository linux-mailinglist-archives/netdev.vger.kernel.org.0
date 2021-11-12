Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74C8544E047
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 03:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231965AbhKLCal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 21:30:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233638AbhKLCal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 21:30:41 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C16C061766
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 18:27:51 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id q124so15218183oig.3
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 18:27:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=SjyauEv+E4VZxaW4hhra9vLv0tm876Xi5p2mVPiJ/yE=;
        b=GNfZcYNd4x2wsCJO52SKbIt73ABkOZzWFm+JRvLPPnLbJcAqKcvy6c809wlkg1HsDB
         CXzWlJjlzcT+r+NBzSbkMUEtIE4TAdeqdZJTldw6/ARbnmjoGbT+xoCGqGkoKCCP6Ik/
         05dkpUBo9osG8LdTmKEVMnT1AN2mvK+LT5Vh29/HhYeUG9jOLtxeAp3qO1MATTnOwH3e
         idcT89jnSHYlETglkhexHh+BAJgzqaJyGcNpFLaG/0oBYbCBBte9+TMT4qoPtpGTpYwm
         jx/Ktwr2RGJmUfsOpHjq6sG0W824Yj4u5tYUbZOP4G9GyDug1NEk4XM2k1gYZpfB2Eah
         b/hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SjyauEv+E4VZxaW4hhra9vLv0tm876Xi5p2mVPiJ/yE=;
        b=cjGgiuCHHgJUyyP/DybXXzq8irLp23lS04qs7dgrYQYNjvEhW5a+MwLy4RyKL8Z11Q
         D46YhfUeojaeoHMu4UDxD38RMiMWMulhU/8eaXZZYYgk9Lae/+ehWID6kIFdg0wItMTc
         fNVTJi/A6cBHbC/yMvTNtZRC/SLpfREMXTPdvXEiVaPGV9P1m98RTgdUtggBBOErYsrR
         Y+nVGEgzdmXzPXBn1bORN5SVKGmqGc7uODRul6EmOMd4q/79kBOQWTikah5TYo2QaCtC
         UEyrW+njWDUWVl0epn4Xei+EcT0ojT4KeivwH6e2dC+HbJmnazbsVwL+vbupX2+GoUNH
         ZowA==
X-Gm-Message-State: AOAM533Hey9rpdMHfvhm5uoPOGZGaujnmFW+U4tiUJT1YDnu6XtZE58u
        lJyc0AcTow90ZOU0bhYM6+Y=
X-Google-Smtp-Source: ABdhPJw0Y69yAE9eTqfKpN+G90Bhqnb+/XA5J7RjHpdY5g3wADEmQqCKEEBQTumTPN4xtWgWMxvzkw==
X-Received: by 2002:aca:61c6:: with SMTP id v189mr9674228oib.103.1636684070590;
        Thu, 11 Nov 2021 18:27:50 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id 3sm978769otl.60.2021.11.11.18.27.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Nov 2021 18:27:50 -0800 (PST)
Message-ID: <d7c2d8fa-052e-b941-2ef1-830c1ba655c1@gmail.com>
Date:   Thu, 11 Nov 2021 19:27:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [RFC PATCH net-next] rtnetlink: add RTNH_F_REJECT_MASK
Content-Language: en-US
To:     Roopa Prabhu <roopa@nvidia.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
References: <20211111160240.739294-1-alexander.mikhalitsyn@virtuozzo.com>
 <20211111160240.739294-2-alexander.mikhalitsyn@virtuozzo.com>
 <1f4b9028-8dec-0b14-105a-3425898798c9@gmail.com>
 <CAJqdLrqvNYm1YTA-dgGsrjsPG6efA8nsUCQLKmGXqoDM+dfpRQ@mail.gmail.com>
 <b90e874b-30a7-81bb-a94f-b6cebda87e99@gmail.com>
 <ff405eae-21d9-35f4-1397-b6f9a29a57ff@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <ff405eae-21d9-35f4-1397-b6f9a29a57ff@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/11/21 6:02 PM, Roopa Prabhu wrote:
> 
> On 11/11/21 2:19 PM, David Ahern wrote:
>> [ cc roopa]
>>
>> On 11/11/21 12:23 PM, Alexander Mikhalitsyn wrote:
>>> On Thu, Nov 11, 2021 at 10:13 PM David Ahern <dsahern@gmail.com> wrote:
>>>> On 11/11/21 9:02 AM, Alexander Mikhalitsyn wrote:
>>>>> diff --git a/include/uapi/linux/rtnetlink.h
>>>>> b/include/uapi/linux/rtnetlink.h
>>>>> index 5888492a5257..c15e591e5d25 100644
>>>>> --- a/include/uapi/linux/rtnetlink.h
>>>>> +++ b/include/uapi/linux/rtnetlink.h
>>>>> @@ -417,6 +417,9 @@ struct rtnexthop {
>>>>>   #define RTNH_COMPARE_MASK    (RTNH_F_DEAD | RTNH_F_LINKDOWN | \
>>>>>                                 RTNH_F_OFFLOAD | RTNH_F_TRAP)
>>>>>
>>>>> +/* these flags can't be set by the userspace */
>>>>> +#define RTNH_F_REJECT_MASK   (RTNH_F_DEAD | RTNH_F_LINKDOWN)
>>>>> +
>>>>>   /* Macros to handle hexthops */
>>>> Userspace can not set any of the flags in RTNH_COMPARE_MASK.
>>> Hi David,
>>>
>>> thanks! So, I have to prepare a patch which fixes current checks for
>>> rtnh_flags
>>> against RTNH_COMPARE_MASK. So, there is no need to introduce a separate
>>> RTNH_F_REJECT_MASK.
>>> Am I right?
>>>
>> Added Roopa to double check if Cumulus relies on this for their switchd.
>>
>> If that answer is no, then there is no need for a new mask.
>>
> 
> yes, these flags are already exposed to userspace and we do use it.
> 
> We have also considered optimizations where routing daemons set OFFLOAD
> and drivers clear it when offload fails.
> 
> I wont be surprised if other open network os distributions are also
> using it.
> 
> 
> Thanks for the headsup David.
> 

Thanks, Roopa. So then the separate mask is needed.
