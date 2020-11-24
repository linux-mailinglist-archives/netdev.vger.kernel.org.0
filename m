Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D66CC2C29A6
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 15:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388265AbgKXOaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 09:30:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbgKXOaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 09:30:08 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA83C0613D6
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 06:30:08 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id i19so28758163ejx.9
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 06:30:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HA/SrIK113BuXrImyLyO23K25JxNPP6srrWYVaCENIw=;
        b=bYW1lAY//P1VUkd3XTKs5RKKiBBoc2DG04fyDsqNr/mQYrbfBWuzkZkAN9d04tpXgM
         DRW6DuHI1mgqX5H/GF44CqmNmH6qpW6k8cLYhlzWdpl38i3cY/uAKfGAYYp5vPbgMg9p
         T7hxL7lhYAUpYXPd08zECOTmR8T2wWZ6eUXa6IRZqC37/HTr6iAuQm87Kq1H0uDT9x5x
         m8XHbU6zZvvBXcYqX0ymi8aoNJllIYHha+snfbfsCbQyxz/HHlGhFemYvtqEgO8WtvoO
         jmHl9S7dJiVbewuk1caJq2BGVQtGz1hV/rzGAFoKg4cH32/hLKibVFJxeNqOmzmQhCqN
         7ycA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HA/SrIK113BuXrImyLyO23K25JxNPP6srrWYVaCENIw=;
        b=Gux5yJANEtbPkiLAQAaNUTshPph4EnZDFhQqmmZlvp9jkvjAo1Z8PUFTAt1rvUgaVV
         yWZdsp4KBp5VLVM0++L55CYRGxUH5EjOCb9dYl0vjD6bIAxvdpCfa3SCHPpCPa8zlcC/
         yiDGal/DaNhxA2dfx96BwOcX1c4JhZzlCRi52uOO39RodiRZ8t1oMdMtHdds1aARKndr
         Kp2+K/ZU23jeT1USoVmobDd2hZGmpcjG0rLVoJoX+l2PyOvwG7FE4lvN2y9p27MLa+ex
         OJ02AEIb4ykNkerswwCQLyVxLTOtPQcw07vLtX0dcgN/O5LuCkcXMSQPNQtAvArXeoGd
         s2lg==
X-Gm-Message-State: AOAM53119ZeLOa/yofbysU9kEJ/a+IyROjU0irI/jxkHltEYd3GAk68x
        tcNwL/RYz4LcUyQp6EMRpJM=
X-Google-Smtp-Source: ABdhPJw610QyVYVUlTCpXmgiaoZv0tALtURR3qFzDv6TvHRkrItpJIRarx+fR+9sL47VbY6iqFZiXw==
X-Received: by 2002:a17:906:bcd4:: with SMTP id lw20mr4231466ejb.527.1606228207133;
        Tue, 24 Nov 2020 06:30:07 -0800 (PST)
Received: from [192.168.1.110] ([77.124.63.70])
        by smtp.gmail.com with ESMTPSA id s20sm7029081edw.26.2020.11.24.06.30.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2020 06:30:06 -0800 (PST)
Subject: Re: [PATCH net] netdevice.h: Fix unintentional disable of ALL_FOR_ALL
 features on upper device
To:     Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Moshe Shemesh <moshe@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20201123141256.14208-1-tariqt@nvidia.com>
 <CANn89iKRVyTZg-tNQvo_Ub-RZ_A+OOQQY8Py3J9fx=NOZXF9Qw@mail.gmail.com>
 <9bf8ba40-cd40-2af6-d358-48dd98526434@gmail.com>
 <CANn89iK8MXp0QmZbBKdMDHxi7A4afrVdBtgQq7cSY5SRefwraA@mail.gmail.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <4a2fb20f-3112-ce9d-abf8-f0a1e0f80656@gmail.com>
Date:   Tue, 24 Nov 2020 16:30:03 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <CANn89iK8MXp0QmZbBKdMDHxi7A4afrVdBtgQq7cSY5SRefwraA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/24/2020 12:48 PM, Eric Dumazet wrote:
> On Mon, Nov 23, 2020 at 5:15 PM Tariq Toukan <ttoukan.linux@gmail.com> wrote:
>>
>>
>>
>> On 11/23/2020 4:55 PM, Eric Dumazet wrote:
>>> On Mon, Nov 23, 2020 at 3:13 PM Tariq Toukan <tariqt@nvidia.com> wrote:
>>>>
>>>> Calling netdev_increment_features() on upper/master device from
>>>> netdev_add_tso_features() implies unintentional clearance of ALL_FOR_ALL
>>>> features supported by all slaves.  Fix it by passing ALL_FOR_ALL in
>>>> addition to ALL_TSO.
>>>>
>>>> Fixes: b0ce3508b25e ("bonding: allow TSO being set on bonding master")
>>>
>>> I think you should give more details to your bug report, because
>>> netdev_add_tso_features() is used from different
>>> places.
>>>
>>> Thanks.
>>>
>>
>> Right. I'll include these in the re-spin:
>> Fixes: 247f6d0f8667 ("team: allow TSO being set on master")
>> Fixes: f902e8812ef6 ("bridge: Add ability to enable TSO")
> 
> I was more thinking about what exact issue you had, and how we can
> reproduce it, and test the fix.
> 

Issue reproduction is very simple:
Pick any of the features under ALL_FOR_ALL, like tx-nocache-copy.
Turn it on for all slaves.
Turn it on for the bond.
You'll still not be able to use it:
     tx-nocache-copy: off [requested on]

Reason is that the call to netdev_add_tso_features() being considered as 
a "dummy" slave that has this feature bit cleared, breaking ALL_FOR_ALL 
logic.

>>
>> I wonder though if netdev_increment_features() is expected to clear
>> features that are not part of the mask.
> 
> Well, the 'increment' part was suggesting the function was adding
> flags, not removing them.
> 

Yes, that's confusing... Although ALL_FOR_ALL logic is just about 
removing, unlike ONE_FOR_ALL.

> We might ask Herbert Xu if we :
> 
> 1) Need to comment the function, or change its name to be more descriptive.
> 2) Change the behavior (as you suggested)
> 3) Other choice.
> 


