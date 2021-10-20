Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 338D543553C
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 23:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbhJTV1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 17:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbhJTV1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 17:27:31 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF06C06161C
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 14:25:15 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id y4so17085058plb.0
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 14:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=78V9YIO5FPIawjGVS68FFPXyo3H7fgCnSFiB6tXEYKc=;
        b=VqHHU47vzAD7B5m67h2NOtiRHJ+7Igcq4YZ39A4akkcnXBVV9Y3ChrVjTFVQT264Io
         QayCW0f6f1oKkaBkTqziVhaRjLU+4Er4HNnd/k1w1fuwJMGSQv5+/Ivdm/4k3j/9tuu4
         ajlyXJAzrZj2MdOioFGC3e8+5nxgrclwfkljWN4vzLWbPvDGnh6yAmFM8bzjt0EXSFQo
         wUB3KlfCDc8hYeS+afBbdzv5HSuBiHAZytt0MA0o8YoDh2YfXuI7s1xcIVsXTaMVDl7G
         UJsES3zS2zwZ58BD8gV/3yvl3GNePcuzwZCLi8GEXZLv3Kho89Y0lGgZaJNF6Z8IAG14
         ftIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=78V9YIO5FPIawjGVS68FFPXyo3H7fgCnSFiB6tXEYKc=;
        b=D4o20tWUVXUKRZRduCPR9iIZZ1lRAHGimraV192r62pICcwY4rdNwL7dmPHBKACQ4p
         JF83NdOPTSMrp6f2ciLZv1gHJ4USHKya3KALNhm9dGh9F5X6Ec7KT2ti7RhE5eY5aiC5
         zUo4HkBWf+qN0Y/RhF2GSuZUnmGSvL0+DC/zERnbcAag7zgu77lAgfTOBBI42R9aQOch
         qaxqh2ewVyCiMD/2hgOYZbj1ykhYMKMvEoVmkLRWyLnoMaqq4yrcDFd8Mnlbv2PHahob
         Ivr3pz7DYs+uOgAsAXN+SQvchsSfci01r340RTJH6GINbOIrKARC0RSTIQ8hsfAltZOm
         DC/g==
X-Gm-Message-State: AOAM530ZNmk0TB+H/R+icXhx0WAnH2wQZqhcECjFZskQj4cJ7nBpFxzQ
        b1GT3UbJfc+uWmC/gV2LGCc=
X-Google-Smtp-Source: ABdhPJw39IS6D0i7bXWF20gW3GnicW9MANWb3y3H+GAUj3jbraCLiLvrRvjxYa+ceHCbf/JWafdQWA==
X-Received: by 2002:a17:90b:3588:: with SMTP id mm8mr1676089pjb.238.1634765115372;
        Wed, 20 Oct 2021 14:25:15 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id x13sm3113731pgt.80.2021.10.20.14.25.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 14:25:14 -0700 (PDT)
Subject: Re: [PATCH net-next v2] fq_codel: generalise ce_threshold marking for
 subset of traffic
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, edumazet@google.com
References: <20211019174709.69081-1-toke@redhat.com>
 <9cec30c9-ede1-82aa-9eca-ca76bcb206d5@gmail.com> <87ilxre6rz.fsf@toke.dk>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <190a2292-8903-b4e9-954e-d07f5dbd8693@gmail.com>
Date:   Wed, 20 Oct 2021 14:25:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <87ilxre6rz.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/20/21 2:16 PM, Toke Høiland-Jørgensen wrote:
> Eric Dumazet <eric.dumazet@gmail.com> writes:
> 
>> On 10/19/21 10:47 AM, Toke Høiland-Jørgensen wrote:
>>> The commit in the Fixes tag expanded the ce_threshold feature of FQ-CoDel
>>> so it can be applied to a subset of the traffic, using the ECT(1) bit of
>>> the ECN field as the classifier. However, hard-coding ECT(1) as the only
>>> classifier for this feature seems limiting, so let's expand it to be more
>>> general.
>>>
>>> To this end, change the parameter from a ce_threshold_ect1 boolean, to a
>>> one-byte selector/mask pair (ce_threshold_{selector,mask}) which is applied
>>> to the whole diffserv/ECN field in the IP header. This makes it possible to
>>> classify packets by any value in either the ECN field or the diffserv
>>> field. In particular, setting a selector of INET_ECN_ECT_1 and a mask of
>>> INET_ECN_MASK corresponds to the functionality before this patch, and a
>>> mask of ~INET_ECN_MASK allows using the selector as a straight-forward
>>> match against a diffserv code point:
>>>
>>>  # apply ce_threshold to ECT(1) traffic
>>>  tc qdisc replace dev eth0 root fq_codel ce_threshold 1ms ce_threshold_selector 0x1/0x3
>>>
>>>  # apply ce_threshold to ECN-capable traffic marked as diffserv AF22
>>>  tc qdisc replace dev eth0 root fq_codel ce_threshold 1ms ce_threshold_selector 0x50/0xfc
>>>
>>> Regardless of the selector chosen, the normal rules for ECN-marking of
>>> packets still apply, i.e., the flow must still declare itself ECN-capable
>>> by setting one of the bits in the ECN field to get marked at all.
>>>
>>> v2:
>>> - Add tc usage examples to patch description
>>>
>>> Fixes: e72aeb9ee0e3 ("fq_codel: implement L4S style ce_threshold_ect1 marking")
>>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>>> ---
>>
>> Reviewed-by: Eric Dumazet <edumazet@google.com>
> 
> Thanks!
> 
>> BTW, the Fixes: tag seems not really needed, your patch is a
>> followup/generalization.
> 
> Yeah, I included it because I don't know of any other way to express
> "this is a follow-up commit to this other one, and the two should be
> kept together" - for e.g., backports. And I figured that since this
> changes the UAPI from your initial patch, this was important to express
> in case someone does backport that.

The patch targeted net-next, and was not stable material.

Also, this is pure opt-in behavior, so there was no risk
of breaking something.

Note that I have not provided yet an iproute2 patch, so only your
iproute2 change will possibly enable the new behavior.

> 
> Is there another way to express this that I'm not aware of?

Just mentioning the commit directly in the changelog is what I
do for followups.

