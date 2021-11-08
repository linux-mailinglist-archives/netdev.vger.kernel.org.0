Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8E7449C9A
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 20:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237725AbhKHTmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 14:42:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236276AbhKHTmT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 14:42:19 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77CBEC061570
        for <netdev@vger.kernel.org>; Mon,  8 Nov 2021 11:39:34 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id o4so2984990pfp.13
        for <netdev@vger.kernel.org>; Mon, 08 Nov 2021 11:39:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=qylr0GtQoWErVMeDcCgzgVsk6zbeljCVVpd0hIlmahg=;
        b=opOsGuiZwJE76pkOLXrxE5csUjTHUkNOJ5n85fb1DXx5ESteGIc41WzlcaDRJ+3lCq
         fZ9izXIYalrqAUB97d8uSpEaPM6VTKI0cwBjed7XxqQUKeD0e70I2TPQwG40DeVvNQcU
         1Rlg6PbXP3mkNSoU9zej5AOV4PYIIHVnPzRIyfRhFnJDavJ8NUyMw3AhepEuCUAkTJoz
         TbMU9J6UrNb+tNgrLhipSjpDoX21A+X9/gxxgxmF8tbkFIVg6ZKAG6SFrMsdcpg7bBVj
         nHC/tE3n8HIsNu3fUdz8cjdLNsVUORk/WSmfJviEjXtF/Zp/+d3aiG53j3kIpiGClsTf
         pkPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qylr0GtQoWErVMeDcCgzgVsk6zbeljCVVpd0hIlmahg=;
        b=IyZ7B+CLaqeE0JNpWzbERQ8XO2YvxvjI1W5BpT1ayx/uh0dqg6epTG0jBVvSOqcgpS
         swUji+yXCbkK/ve1qC4WI5ui4OKp/xzmxLC6moCe/6Rz1n69NC9cnP4KbYUn6G5CrnEB
         Ksava8+XRtMG+ve/T0r2ciqNPtIRgO7JXQHe9lxh2MLHExjc5rBKF2tg4In8wSuJfuvU
         GTWbWVG/jTbLe0vKgoiKpHzZvYaoTi0hE1+e77G4ruUumnplDt5Kk+CCDQFtqvFWiZi2
         DEDVyoK9TS+Luiin+KLRi1Xg9Fa2ojPEA4UG+cPMH9m0I+lWP8KAUOVvhRhqMdsQxDjW
         g5AQ==
X-Gm-Message-State: AOAM530LapZy1A2eq1gPH7pqi692abKcP5XPtEV/ssqXxUuRf6faaPkr
        CDkJnJLVwSVlh1BuZOlPGJPF/QIh0H4=
X-Google-Smtp-Source: ABdhPJzliCl+Z9kSAHQtBUhEOv2Fg6i2EhXpxG++Xu2NiRG6jJdWJl/xk+o/zn6JNe8U5bTYLu+TTA==
X-Received: by 2002:a63:fc48:: with SMTP id r8mr1433376pgk.339.1636400373856;
        Mon, 08 Nov 2021 11:39:33 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id s15sm142692pjs.51.2021.11.08.11.39.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 11:39:33 -0800 (PST)
Subject: Re: [RFC PATCH net-next 2/4] txhash: Add socket option to control TX
 hash rethink behavior
To:     Akhmat Karakotov <hmukos@yandex-team.ru>, netdev@vger.kernel.org
References: <20211025203521.13507-1-hmukos@yandex-team.ru>
 <20211025203521.13507-3-hmukos@yandex-team.ru>
 <f21dfe61-58e6-ba03-cc0a-b5d2fd0a88c6@gmail.com>
 <3EA39ACA-9935-4FB7-B89A-5F57D33BC069@yandex-team.ru>
 <D7FFC160-1DC3-42A5-BE0E-15FD81BEB1F3@yandex-team.ru>
 <A1CCE8E1-72B0-429C-BBD9-ABA31DE2EBE0@yandex-team.ru>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <e9ca04cd-ec21-43ad-fd99-11af754e3279@gmail.com>
Date:   Mon, 8 Nov 2021 11:39:31 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <A1CCE8E1-72B0-429C-BBD9-ABA31DE2EBE0@yandex-team.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/8/21 4:48 AM, Akhmat Karakotov wrote:
>> On Oct 29, 2021, at 13:01, Akhmat Karakotov <hmukos@yandex-team.ru> wrote:
>>
>>>
>>> On Oct 26, 2021, at 00:05, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>>
>>>
>>>
>>> On 10/25/21 1:35 PM, Akhmat Karakotov wrote:
>>>> Add the SO_TXREHASH socket option to control hash rethink behavior per socket.
>>>> When default mode is set, sockets disable rehash at initialization and use
>>>> sysctl option when entering listen state. setsockopt() overrides default
>>>> behavior.
>>>
>>> What values are accepted, and what are their meaning ?
>>>
>>> It seems weird to do anything in inet_csk_listen_start()
>>>
>>>
>>> For sockets that have not used SO_TXREHASH
>>> (this includes passive sockets where their parent did not use SO_TXREHASH),
>>> the sysctl _current_ value should be used every time we consider a rehash.
>> SO_TXREHASH_DEFAULT value means default behavior: for listening sockets
>> the sysctl value is taken, while for others rehash is disabled. The motivation
>> was to disallow hash rethink at the client-side to avoid connection timeout to
>> anycast services (as was stated in cover letter).
>> ENABLED and DISABLED values are for enforcing rehash option values.
>>
>> To be honest I didn't quite understand how you propose to change patch behaviour.
>>
>>>
>>>> #define SOCK_TXREHASH_DISABLED	0
>>>> #define SOCK_TXREHASH_ENABLED	1
>>>>
>>>> diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
>>>> index 0d833b861f00..537a8532ff8a 100644
>>>> --- a/net/core/net_namespace.c
>>>> +++ b/net/core/net_namespace.c
>>>> @@ -360,7 +360,7 @@ static int __net_init net_defaults_init_net(struct net *net)
>>>> {
>>>> 	net->core.sysctl_somaxconn = SOMAXCONN;
>>>>
>>>> -	net->core.sysctl_txrehash = SOCK_TXREHASH_DISABLED;
>>>> +	net->core.sysctl_txrehash = SOCK_TXREHASH_ENABLED;
>>>
>>> This is very confusing.
>>>
>>
>> Could you, please, elaborate what exactly is confusing?
> 
> Hi Eric,
> 
> I wonder if you have time to take a closer look at my last comments.
> 
> P. S.: resending this message without CC, because delivery system rejected it first time
> 

I guess the confusing part was that one patch sets SOCK_TXREHASH_DISABLED,
then a following one (in the series) sets it to SOCK_TXREHASH_ENABLED

My brain hurts.
