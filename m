Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC0F0533A86
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 12:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242024AbiEYKS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 06:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236640AbiEYKS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 06:18:56 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D7E97288
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 03:18:53 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id z15so5616981wrg.11
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 03:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=IKO1wQPqNeafXW7ePx/p6H6D1wFfnLpkgbfwaCOWD9o=;
        b=CWTtkvYFGef5ey+p035Mn9qClBe5IM61n2d51HyOo6ItqkiavbGG73JXbcGaExiw9d
         wg00mxcAerlPgWUpzrJ8w6fSjW5TntE/H91PCb0KJYsCdbsqhG0HHYHt/TcVL2g0w/Ot
         8nHb+85XPzoFVRbf6s2E5ctugD4BfMmxQVRESSUjYMiYDY/bubJsIu4u80siyLDjTWK7
         4OD/HyNkz1YL4xJBkatPj577T+sZwbDw+4yMFfuIjDdoCJFGA2lsiOjm2TkIgWZHwn+I
         7ldZ4aH+oyR7xWefpMIn+gtNyZDyj3AkIES6acDXz1k4cAxWd0aCtMJYx0SfvYWgZ9nN
         J77w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IKO1wQPqNeafXW7ePx/p6H6D1wFfnLpkgbfwaCOWD9o=;
        b=Y/Gn8ydC4meRJke5ppfN8YDDncCoIc7CcNMG2btL7SqkKYrDYpDtPqVmxbFuB3BrNz
         dNDTszMi3ji0dIMwNDHSvBZ/QYSzFdQlc0yIjQWMg+9XiIKUGbAolDH0LoHchMNNPeZn
         8xihQX8qEnnPecSQorXzZ8Ex+D1stPlHSbjbDVPxMPx9VMoGLb5Qw+VpZyYZSIKu93Zz
         GYOdLxr/RIrrW5q3OMDVYDN+G66jHc1oJKqwvyhmT8gYTrd4xZ8sCkNWy0aB0sqhzFjt
         U5gdzwDs7pC1xIYu3qqCTiRLhvQiQVri3zc/nYz5cMCDb0KGQqJONRAyWc2QpEo4ilx8
         J8gw==
X-Gm-Message-State: AOAM533NG1fq5OKzVuQcuV2sBF17K27x8bQeurG8PSuxHqj8/zP3apjT
        sGggSnigT51Dv5JztHGmqPN6CA==
X-Google-Smtp-Source: ABdhPJxgtLZHCd6/bHzg9r3GWuTdZpprQ2vQ2cJsbS0c885HtYWHWfg4GYMB8tQn4zKYJcJdaeJoiA==
X-Received: by 2002:adf:fc01:0:b0:20c:ff9a:2c53 with SMTP id i1-20020adffc01000000b0020cff9a2c53mr26042048wrr.142.1653473931814;
        Wed, 25 May 2022 03:18:51 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id p3-20020a1c7403000000b0039744664af7sm1749957wmc.1.2022.05.25.03.18.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 May 2022 03:18:51 -0700 (PDT)
Message-ID: <4bf1c80d-0f18-f444-3005-59a45797bcfd@blackwall.org>
Date:   Wed, 25 May 2022 13:18:49 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH V3 net-next 1/4] net: bridge: add fdb flag to extent
 locked port feature
Content-Language: en-US
To:     Hans Schultz <schultz.hans@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
References: <20220524152144.40527-1-schultz.hans+netdev@gmail.com>
 <20220524152144.40527-2-schultz.hans+netdev@gmail.com>
 <01e6e35c-f5c9-9776-1263-058f84014ed9@blackwall.org>
 <86zgj6oqa9.fsf@gmail.com>
 <b78fb006-04c4-5a25-7ba5-94428cc9591a@blackwall.org>
 <86fskyggdo.fsf@gmail.com>
 <040a1551-2a9f-18d0-9987-f196bb429c1b@blackwall.org>
 <86v8tu7za3.fsf@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <86v8tu7za3.fsf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/05/2022 12:11, Hans Schultz wrote:
> On ons, maj 25, 2022 at 11:38, Nikolay Aleksandrov <razor@blackwall.org> wrote:
>> On 25/05/2022 11:34, Hans Schultz wrote:
>>> On ons, maj 25, 2022 at 11:06, Nikolay Aleksandrov <razor@blackwall.org> wrote:
>>>> On 24/05/2022 19:21, Hans Schultz wrote:
>>>>>>
>>>>>> Hi Hans,
>>>>>> So this approach has a fundamental problem, f->dst is changed without any synchronization
>>>>>> you cannot rely on it and thus you cannot account for these entries properly. We must be very
>>>>>> careful if we try to add any new synchronization not to affect performance as well.
>>>>>> More below...
>>>>>>
>>>>>>> @@ -319,6 +326,9 @@ static void fdb_delete(struct net_bridge *br, struct net_bridge_fdb_entry *f,
>>>>>>>  	if (test_bit(BR_FDB_STATIC, &f->flags))
>>>>>>>  		fdb_del_hw_addr(br, f->key.addr.addr);
>>>>>>>  
>>>>>>> +	if (test_bit(BR_FDB_ENTRY_LOCKED, &f->flags) && !test_bit(BR_FDB_OFFLOADED, &f->flags))
>>>>>>> +		atomic_dec(&f->dst->locked_entry_cnt);
>>>>>>
>>>>>> Sorry but you cannot do this for multiple reasons:
>>>>>>  - f->dst can be NULL
>>>>>>  - f->dst changes without any synchronization
>>>>>>  - there is no synchronization between fdb's flags and its ->dst
>>>>>>
>>>>>> Cheers,
>>>>>>  Nik
>>>>>
>>>>> Hi Nik,
>>>>>
>>>>> if a port is decoupled from the bridge, the locked entries would of
>>>>> course be invalid, so maybe if adding and removing a port is accounted
>>>>> for wrt locked entries and the count of locked entries, would that not
>>>>> work?
>>>>>
>>>>> Best,
>>>>> Hans
>>>>
>>>> Hi Hans,
>>>> Unfortunately you need the correct amount of locked entries per-port if you want
>>>> to limit their number per-port, instead of globally. So you need a
>>>> consistent
>>>
>>> Hi Nik,
>>> the used dst is a port structure, so it is per-port and not globally.
>>>
>>> Best,
>>> Hans
>>>
>>
>> Yeah, I know. :) That's why I wrote it, if the limit is not a feature requirement I'd suggest
>> dropping it altogether, it can be enforced externally (e.g. from user-space) if needed.
>>
>> By the way just fyi net-next is closed right now due to merge window. And one more
>> thing please include a short log of changes between versions when you send a new one.
>> I had to go look for v2 to find out what changed.
>>
> 
> Okay, I will drop the limit in the bridge module, which is an easy thing
> to do. :) (It is mostly there to ensure against DOS attacks if someone
> bombards a locked port with random mac addresses.)
> I have a similar limitation in the driver, which should then probably be
> dropped too?
> 

That is up to you/driver, I'd try looking for similar problems in other switch drivers
and check how those were handled. There are people in the CC above that can
directly answer that. :)

> The mayor difference between v2 and v3 is in the mv88e6xxx driver, where
> I now keep an inventory of locked ATU entries and remove them based on a
> timer (mv88e6xxx_switchcore.c).
> 

ack

> I guess the mentioned log should be in the cover letter part?
> 

Yep, usually a short mention of what changed to make it easier for reviewers.
Some people also add the patch-specific changes to each patch under the ---
so they're not included in the log, but I'm fine either way as long as I don't
have to go digging up the old versions.

> 
>>>> fdb view with all its attributes when changing its dst in this case, which would
>>>> require new locking because you have multiple dependent struct fields and it will
>>>> kill roaming/learning scalability. I don't think this use case is worth the complexity it
>>>> will bring, so I'd suggest an alternative - you can monitor the number of locked entries
>>>> per-port from a user-space agent and disable port learning or some similar solution that
>>>> doesn't require any complex kernel changes. Is the limit a requirement to add the feature?
>>>>
>>>> I have an idea how to do it and to minimize the performance hit if it really is needed
>>>> but it'll add a lot of complexity which I'd like to avoid if possible.
>>>>
>>>> Cheers,
>>>>  Nik

