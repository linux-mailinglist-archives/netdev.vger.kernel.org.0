Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7B9349463
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 15:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbhCYOoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 10:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhCYOn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 10:43:57 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 284B1C06174A;
        Thu, 25 Mar 2021 07:43:57 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id c8so2522525wrq.11;
        Thu, 25 Mar 2021 07:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+/oyF6yi7l0geJaoCb9ZRQBZyjsAYsiewu6B3GYGpqo=;
        b=ov/PG+l6jBBwBPbFd11hC8WRgpUY3cPPaqE7tcTjsLIcE4qVeTBXnnugUOrpnV6SfY
         vjYPeAtX7x46pINz4jFf90aY2T8mlRpe5+mnLmU4rfXDDyecl40LhhluDpVvCBRXmvFr
         QKu6I8/mg3AkXdyrMHziuE3jvM/ksiolYSw4s2diSqG8NsYu0vPpNIE35GP56r492KOR
         qtOHJt/gctyVwE3gwn+0e3D+gfGVBesZ+gNK9b0JTFxtpWCS4uJt3u0whBjpOXCndekb
         gH3RUTAHAkDS86KD9RNsttxwx9hBnunOv7KOwY8etgkq3Ux+NVDDxYmfcmwpfMWBxZ3K
         j4vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+/oyF6yi7l0geJaoCb9ZRQBZyjsAYsiewu6B3GYGpqo=;
        b=kbtDRU9kfOC/GH62tUS10QwG0OEJTUq6NggkIpFGO8/Dqnxvvb2mvQPpkswuPj4jXv
         yxn9tm5xEciT91jymcEJQ9DPFfOF5NSyVluY9I+6Jc3kpdmhuPoiBP6pgdvwD4MuawNj
         k7efGgLhB+somnn8BfE+LXAW1So/DVnaprsbAU5fCnoQf5f3dG4CZfZaqx2isXb4EFgq
         saKDWwvzNhKfEq2gYMXOqRKC8rIh/rlRCbtDA0gM0EIozAuogDeFd1ZKLdoYOAS38kOk
         W41FEMi0Rc6VK9meGy7wPZhlKly35BKrHT0zFUYBh1Czm2eChR30cLYPGVInmxQU4xDV
         sf2w==
X-Gm-Message-State: AOAM5336aFEZD6kJAygjhALUK6K0+I5CmvIgUovur6sZ/+JqzzRA11Lu
        GOMkSmJlPbKW3hwb4goYZOsjJDr26TU=
X-Google-Smtp-Source: ABdhPJyK9bcZeVtN7cvCFnmNZSoP4WKuoY6V5wS4KgeqIzfY2flhZ9Dd6BInTKXSMqLm6cp6dew+BA==
X-Received: by 2002:adf:f010:: with SMTP id j16mr37709wro.251.1616683435607;
        Thu, 25 Mar 2021 07:43:55 -0700 (PDT)
Received: from [192.168.1.101] ([37.165.105.49])
        by smtp.gmail.com with ESMTPSA id f22sm6474237wmc.33.2021.03.25.07.43.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Mar 2021 07:43:55 -0700 (PDT)
Subject: Re: [PATCH] net: change netdev_unregister_timeout_secs min value to 1
To:     Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Leon Romanovsky <leon@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20210325103105.3090303-1-dvyukov@google.com>
 <651b7d2d-21b2-8bf4-3dc8-e351c35b5218@gmail.com>
 <CACT4Y+ad6bwMbQ6OwrdypCsNRvYTMtMf0KR2EpVOhPOZvnxeNA@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <c6e79b82-50dd-633c-8d63-77c059538338@gmail.com>
Date:   Thu, 25 Mar 2021 15:43:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <CACT4Y+ad6bwMbQ6OwrdypCsNRvYTMtMf0KR2EpVOhPOZvnxeNA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/25/21 3:38 PM, Dmitry Vyukov wrote:
> On Thu, Mar 25, 2021 at 3:34 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>> On 3/25/21 11:31 AM, Dmitry Vyukov wrote:
>>> netdev_unregister_timeout_secs=0 can lead to printing the
>>> "waiting for dev to become free" message every jiffy.
>>> This is too frequent and unnecessary.
>>> Set the min value to 1 second.
>>>
>>> Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
>>> Suggested-by: Eric Dumazet <edumazet@google.com>
>>> Fixes: 5aa3afe107d9 ("net: make unregister netdev warning timeout configurable")
>>> Cc: netdev@vger.kernel.org
>>> Cc: linux-kernel@vger.kernel.org
>>> ---
>>
>> Please respin your patch, and fix the merge issue [1]
> 
> Is net-next rebuilt and rebased? Do I send v4 of the whole change?
> I cannot base it on net-next now, because net-next already includes
> most of it... so what should I use as base then?
> 
>> For networking patches it is customary to tell if its for net or net-next tree.
>>
>> [1]
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index 4bb6dcdbed8b856c03dc4af8b7fafe08984e803f..7bb00b8b86c6494c033cf57460f96ff3adebe081 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -10431,7 +10431,7 @@ static void netdev_wait_allrefs(struct net_device *dev)
>>
>>                 refcnt = netdev_refcnt_read(dev);
>>
>> -               if (refcnt &&
>> +               if (refcnt != 1 &&
>>                     time_after(jiffies, warning_time +
>>                                netdev_unregister_timeout_secs * HZ)) {
>>                         pr_emerg("unregister_netdevice: waiting for %s to become free. Usage count = %d\n",

Please include my fix into your patch.

Send a V2, based on current net-next.

net-next is never rebased, we have to fix the bug by adding a fix on top of it.


