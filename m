Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46B4D63F79B
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 19:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbiLASlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 13:41:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiLASlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 13:41:16 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4540BBBD4
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 10:41:15 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id q79so602537iod.4
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 10:41:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FJcBqkJuc1O3n5xY+XGahxTgpCrWh2DUx8QxErVJvjI=;
        b=5ZelWTK9N5aqGvkSgZAU0x3yqA3FgGhaYF70hbG1rXpM2OciDQ3QPvIoWnFsVCBsW7
         nGSCU9A757Z7mGhq0N4B1OMMwAOwiiGEyn9wMuBwuSp2CxsOJsMgEw9tJ9jXuUbyS9PF
         HtmAM5Wsjwc+i5nrNuR0CO5t9OT3GqmNTuGFmxoc/wGVkVYxSZd8KyBHKPO2SLQIw2sa
         vbK//4f/er5pz2KCZTOonrELgX7vtUb/ygq5w6+M5GFsnjonzY1hkv2p7o8yEv6cNpvy
         ojv5o28x2Ds6RUBC8uDS/Av0RsDhYmgrrt0BsIMIbwKJ4TnUDiqdtdSAVrtA6sCra4Uo
         XyHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FJcBqkJuc1O3n5xY+XGahxTgpCrWh2DUx8QxErVJvjI=;
        b=d/SiFJYDpxIpa0paCuf2+N1Gwn2l58cU83iWaV4YsPsOk/0X606U5jlY48wV/Mnq07
         tNcPPRDvPp2vwKd4NAyNeEw9kbX2/22xREwtU3Ja3NdwKG1urpaj3QlFOiaXJ+OXmJ5Z
         uau8hwLdmyqvX+Z1sYycVs7jcYhTXDnpjShGMXUAynca3GpjhOLgl6b0pfngNrwk1xcY
         ozeTyoUS4HyCTV635GYz5f94ruGgBdlO0i0VF+CTgvG+01X3YYC7pyCCBRY8yiZAWF8Y
         JpDau65wjA3Sl+UXe1B7YzUEFSy3Woxrl0tRgzgyTevNyaaQYQqJ0xoyYxXXQzD0hBdN
         lhDw==
X-Gm-Message-State: ANoB5plzXPKIowS5qLranUw0e97DY+4nJGNgOzVarLiKr6XljMt3UXYw
        jBU8vg8JlZVNX1UXogHJbfOWlA==
X-Google-Smtp-Source: AA0mqf4HLgYNYDjyELelhCkWMtLx4c8wyj24KGj8KIHy9QjMYn0XtSZvrgYqG8Jfh8WgMvo3/CBClA==
X-Received: by 2002:a02:5442:0:b0:389:d81a:1d80 with SMTP id t63-20020a025442000000b00389d81a1d80mr11528617jaa.80.1669920074867;
        Thu, 01 Dec 2022 10:41:14 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id cn23-20020a0566383a1700b00374bf3b62a0sm1889875jab.99.2022.12.01.10.41.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 10:41:14 -0800 (PST)
Message-ID: <d14164e3-dd51-56f9-9df4-40064fb2a1c2@kernel.dk>
Date:   Thu, 1 Dec 2022 11:41:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 6/6] eventpoll: add support for min-wait
Content-Language: en-US
To:     Soheil Hassas Yeganeh <soheil@google.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>,
        Shakeel Butt <shakeelb@google.com>
References: <20221030220203.31210-1-axboe@kernel.dk>
 <20221030220203.31210-7-axboe@kernel.dk> <Y2rUsi5yrhDZYpf/@google.com>
 <4764dcbf-c735-bbe2-b60e-b64c789ffbe6@kernel.dk>
 <8d195905-a93f-d342-abb0-dd0e0f5a5764@kernel.dk>
 <CACSApvZU0o3MSp33G0Ld+1dr-k82UCcJqF=40AVL-F6UXHpGgg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CACSApvZU0o3MSp33G0Ld+1dr-k82UCcJqF=40AVL-F6UXHpGgg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/1/22 11:39 AM, Soheil Hassas Yeganeh wrote:
> On Thu, Dec 1, 2022 at 1:00 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>>>>> @@ -1845,6 +1891,18 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
>>>>>             ewq.timed_out = true;
>>>>>     }
>>>>>
>>>>> +   /*
>>>>> +    * If min_wait is set for this epoll instance, note the min_wait
>>>>> +    * time. Ensure the lowest bit is set in ewq.min_wait_ts, that's
>>>>> +    * the state bit for whether or not min_wait is enabled.
>>>>> +    */
>>>>> +   if (ep->min_wait_ts) {
>>>>
>>>> Can we limit this block to "ewq.timed_out && ep->min_wait_ts"?
>>>> AFAICT, the code we run here is completely wasted if timeout is 0.
>>>
>>> Yep certainly, I can gate it on both of those conditions.
>> Looking at this for a respin, I think it should be gated on
>> !ewq.timed_out? timed_out == true is the path that it's wasted on
>> anyway.
> 
> Ah, yes, that's a good point. The check should be !ewq.timed_out.

The just posted v4 has the check (and the right one :-))

-- 
Jens Axboe


