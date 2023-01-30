Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6D1680A57
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 11:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236383AbjA3KEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 05:04:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236333AbjA3KEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 05:04:13 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C21974B;
        Mon, 30 Jan 2023 02:03:53 -0800 (PST)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4P53Z21Fb8z6J7dm;
        Mon, 30 Jan 2023 17:59:38 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Mon, 30 Jan 2023 10:03:50 +0000
Message-ID: <526a70a2-b0bc-f29a-6558-022ca12a6430@huawei.com>
Date:   Mon, 30 Jan 2023 13:03:49 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v9 12/12] landlock: Document Landlock's network support
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>,
        =?UTF-8?Q?G=c3=bcnther_Noack?= <gnoack3000@gmail.com>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>
References: <20230116085818.165539-1-konstantin.meskhidze@huawei.com>
 <20230116085818.165539-13-konstantin.meskhidze@huawei.com>
 <Y8xwLvDbhKPG8JqY@galopp> <eb33371b-551e-ae6c-d7e3-a3101644b7ec@huawei.com>
 <68f26cf2-f382-4d31-c80f-22392a85376f@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <68f26cf2-f382-4d31-c80f-22392a85376f@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml100005.china.huawei.com (7.191.160.25) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



1/27/2023 9:22 PM, Mickaël Salaün пишет:
> 
> On 23/01/2023 10:38, Konstantin Meskhidze (A) wrote:
>> 
>> 
>> 1/22/2023 2:07 AM, Günther Noack пишет:
> 
> [...]
> 
>>>> @@ -143,10 +157,24 @@ for the ruleset creation, by filtering access rights according to the Landlock
>>>>   ABI version.  In this example, this is not required because all of the requested
>>>>   ``allowed_access`` rights are already available in ABI 1.
>>>>   
>>>> -We now have a ruleset with one rule allowing read access to ``/usr`` while
>>>> -denying all other handled accesses for the filesystem.  The next step is to
>>>> -restrict the current thread from gaining more privileges (e.g. thanks to a SUID
>>>> -binary).
>>>> +For network access-control, we can add a set of rules that allow to use a port
>>>> +number for a specific action. All ports values must be defined in network byte
>>>> +order.
>>>
>>> What is the point of asking user space to convert this to network byte
>>> order? It seems to me that the kernel would be able to convert it to
>>> network byte order very easily internally and in a single place -- why
>>> ask all of the users to deal with that complexity? Am I overlooking
>>> something?
>> 
>>    I had a discussion about this issue with Mickaёl.
>>    Please check these threads:
>>    1.
>> https://lore.kernel.org/netdev/49391484-7401-e7c7-d909-3bd6bd024731@digikod.net/
>>    2.
>> https://lore.kernel.org/netdev/1ed20e34-c252-b849-ab92-78c82901c979@huawei.com/
> 
> I'm definitely not sure if this is the right solution, or if there is
> one. The rationale is to make it close to the current (POSIX) API. We
> didn't get many opinion about that but I'd really like to have a
> discussion about port endianness for this Landlock API.

   As for me, the kernel should take care about port converting. This 
work should be done under the hood.

   Any thoughts?

> 
> I looked at some code (e.g. see [1]) and it seems that using htons()
> might make application patching more complex after all. What do you
> think? Is there some network (syscall) API that don't use this convention?
> 
> [1] https://github.com/landlock-lsm/tuto-lighttpd
> 
>>>
>>>> +
>>>> +.. code-block:: c
>>>> +
>>>> +    struct landlock_net_service_attr net_service = {
>>>> +        .allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
>>>> +        .port = htons(8080),
>>>> +    };
>>>
>>> This is a more high-level comment:
>>>
>>> The notion of a 16-bit "port" seems to be specific to TCP and UDP --
>>> how do you envision this struct to evolve if other protocols need to
>>> be supported in the future?
>> 
>>     When TCP restrictions land into Linux, we need to think about UDP
>> support. Then other protocols will be on the road. Anyway you are right
>> this struct will be evolving in long term, but I don't have a particular
>> envision now. Thanks for the question - we need to think about it.
>>>
>>> Should this struct and the associated constants have "TCP" in its
>>> name, and other protocols use a separate struct in the future?
> 
> Other protocols such as AF_VSOCK uses a 32-bit port. We could use a
> 32-bits port field or ever a 64-bit one. The later could make more sense
> because each field would eventually be aligned on 64-bit. Picking a
> 16-bit value was to help developers (and compilers/linters) with the
> "correct" type (for TCP).
> 
> If we think about protocols other than TCP and UDP (e.g. AF_VSOCK), it
> could make sense to have a dedicated attr struct specifying other
> properties (e.g. CID). Anyway, the API is flexible but it would be nice
> to not mess with it too much. What do you think?
> 
> 
>>>
>>>> +
>>>> +    err = landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
>>>> +                            &net_service, 0);
>>>> +
>>>> +The next step is to restrict the current thread from gaining more privileges
>>>> +(e.g. thanks to a SUID binary). We now have a ruleset with the first rule allowing
>>>            ^^^^^^
>>>            "through" a SUID binary? "thanks to" sounds like it's desired
>>>            to do that, while we're actually trying to prevent it here?
>> 
>>     This is Mickaёl's part. Let's ask his opinion here.
>> 
>>     Mickaёl, any thoughts?
> 
> Yep, "through" looks better.
> .
