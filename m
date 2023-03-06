Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A56E26AC772
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 17:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbjCFQPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 11:15:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbjCFQPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 11:15:15 -0500
Received: from smtp-42ab.mail.infomaniak.ch (smtp-42ab.mail.infomaniak.ch [IPv6:2001:1600:3:17::42ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A4DF22787
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 08:11:40 -0800 (PST)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4PVk6n0ydDzMqFhm;
        Mon,  6 Mar 2023 17:09:37 +0100 (CET)
Received: from unknown by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4PVk6m2GZzzMs97C;
        Mon,  6 Mar 2023 17:09:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1678118977;
        bh=4ihYqjRB0GwxSKQIQyW2AaDLli+JWwa70EQF7JSXzrs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=kyCrErUHhfqkF3dxojq4RbhmrHW/4IM5zaTKPqZb/IJ0GZv3Bn0F2yVqWO7h/gOWD
         ptPE8l2aHwaTpcBLPsRlPaLpRoE5Lr2TRFp6+2A98JAheJxH938oErCHomgipSDVuA
         YItj3eDRmTQ47qjr9gWji9v6greGB1VSvsBOfn4A=
Message-ID: <950d64ee-5b17-af81-8b85-dd2b392c7487@digikod.net>
Date:   Mon, 6 Mar 2023 17:09:35 +0100
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v9 12/12] landlock: Document Landlock's network support
Content-Language: en-US
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>,
        =?UTF-8?Q?G=c3=bcnther_Noack?= <gnoack3000@gmail.com>
Cc:     willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
References: <20230116085818.165539-1-konstantin.meskhidze@huawei.com>
 <20230116085818.165539-13-konstantin.meskhidze@huawei.com>
 <Y8xwLvDbhKPG8JqY@galopp> <eb33371b-551e-ae6c-d7e3-a3101644b7ec@huawei.com>
 <68f26cf2-f382-4d31-c80f-22392a85376f@digikod.net>
 <526a70a2-b0bc-f29a-6558-022ca12a6430@huawei.com>
 <278ab07f-7583-a4e0-3d37-1bacd091531d@digikod.net>
 <85b31cb8-1aeb-d6f0-6c7d-91cea6b563d4@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <85b31cb8-1aeb-d6f0-6c7d-91cea6b563d4@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 06/03/2023 14:43, Konstantin Meskhidze (A) wrote:
> 
> 
> 2/21/2023 7:16 PM, Mickaël Salaün пишет:
>>
>> On 30/01/2023 11:03, Konstantin Meskhidze (A) wrote:
>>>
>>>
>>> 1/27/2023 9:22 PM, Mickaël Salaün пишет:
>>>>
>>>> On 23/01/2023 10:38, Konstantin Meskhidze (A) wrote:
>>>>>
>>>>>
>>>>> 1/22/2023 2:07 AM, Günther Noack пишет:
>>>>
>>>> [...]
>>>>
>>>>>>> @@ -143,10 +157,24 @@ for the ruleset creation, by filtering access rights according to the Landlock
>>>>>>>     ABI version.  In this example, this is not required because all of the requested
>>>>>>>     ``allowed_access`` rights are already available in ABI 1.
>>>>>>>     
>>>>>>> -We now have a ruleset with one rule allowing read access to ``/usr`` while
>>>>>>> -denying all other handled accesses for the filesystem.  The next step is to
>>>>>>> -restrict the current thread from gaining more privileges (e.g. thanks to a SUID
>>>>>>> -binary).
>>>>>>> +For network access-control, we can add a set of rules that allow to use a port
>>>>>>> +number for a specific action. All ports values must be defined in network byte
>>>>>>> +order.
>>>>>>
>>>>>> What is the point of asking user space to convert this to network byte
>>>>>> order? It seems to me that the kernel would be able to convert it to
>>>>>> network byte order very easily internally and in a single place -- why
>>>>>> ask all of the users to deal with that complexity? Am I overlooking
>>>>>> something?
>>>>>
>>>>>      I had a discussion about this issue with Mickaёl.
>>>>>      Please check these threads:
>>>>>      1.
>>>>> https://lore.kernel.org/netdev/49391484-7401-e7c7-d909-3bd6bd024731@digikod.net/
>>>>>      2.
>>>>> https://lore.kernel.org/netdev/1ed20e34-c252-b849-ab92-78c82901c979@huawei.com/
>>>>
>>>> I'm definitely not sure if this is the right solution, or if there is
>>>> one. The rationale is to make it close to the current (POSIX) API. We
>>>> didn't get many opinion about that but I'd really like to have a
>>>> discussion about port endianness for this Landlock API.
>>>
>>>      As for me, the kernel should take care about port converting. This
>>> work should be done under the hood.
>>>
>>>      Any thoughts?
>>>
>>>>
>>>> I looked at some code (e.g. see [1]) and it seems that using htons()
>>>> might make application patching more complex after all. What do you
>>>> think? Is there some network (syscall) API that don't use this convention?
>>>>
>>>> [1] https://github.com/landlock-lsm/tuto-lighttpd
>>>>
>>>>>>
>>>>>>> +
>>>>>>> +.. code-block:: c
>>>>>>> +
>>>>>>> +    struct landlock_net_service_attr net_service = {
>>>>>>> +        .allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
>>>>>>> +        .port = htons(8080),
>>>>>>> +    };
>>>>>>
>>>>>> This is a more high-level comment:
>>>>>>
>>>>>> The notion of a 16-bit "port" seems to be specific to TCP and UDP --
>>>>>> how do you envision this struct to evolve if other protocols need to
>>>>>> be supported in the future?
>>>>>
>>>>>       When TCP restrictions land into Linux, we need to think about UDP
>>>>> support. Then other protocols will be on the road. Anyway you are right
>>>>> this struct will be evolving in long term, but I don't have a particular
>>>>> envision now. Thanks for the question - we need to think about it.
>>>>>>
>>>>>> Should this struct and the associated constants have "TCP" in its
>>>>>> name, and other protocols use a separate struct in the future?
>>>>
>>>> Other protocols such as AF_VSOCK uses a 32-bit port. We could use a
>>>> 32-bits port field or ever a 64-bit one. The later could make more sense
>>>> because each field would eventually be aligned on 64-bit. Picking a
>>>> 16-bit value was to help developers (and compilers/linters) with the
>>>> "correct" type (for TCP).
>>
>> Thinking more about this, let's use a __u64 port (and remove the
>> explicit packing). The landlock_append_net_rule() function should use a
>> __u16 port argument, but the add_rule_net_service() function should
>> check that there is no overflow with the port attribute (not higher than
>> U16_MAX) before passing it to landlock_append_net_rule(). We should
>> prioritize flexibility for the kernel UAPI over stricter types. User
>> space libraries can improve this kind of types with a more complex API.
>>
>> Big endian can make sense for a pure network API because the port value
>> (and the IP address) is passed to other machines through the network,
>> as-is. However, with Landlock, the port value is only used by the
>> kernel. Moreover, in practice, port values are mostly converted when
>> filling the sockaddr*_in structs. It would then make it more risky to
>> ask developers another explicit htons() conversion for Landlock
>> syscalls. Let's stick to the host endianess and let the kernel do the
>> conversion.
>>
>> Please include these rationales in code comments. We also need to update
>> the tests for endianess, but still check big and little endian
>> consistency as it is currently done in these tests. A new test should be
>> added to check port boundaries with:
>> - port = 0
>> - port = U16_MAX
>       port = U16_MAX value passes.

correct

> 
>> - port = U16_MAX + 1 (which should get an EINVAL)
>       port = U16_MAX + 1 after casting is 0, EINVAL is returned.

In the tests, we want the casting to be be done by the kernel. The test 
should then pass 0x10000 to the struct and the kernel should return 
EINVAL because it is greater than U16_MAX, not because it is zero.

> 
>> - port = U16_MAX + 2 (to check u16 casting != 0)
>       port = U16_MAX + 2 after casting is 1, is it passes?

In this case, 0x10001 should be rejected by the kernel (and return 
EINVAL) because it is greater than U16_MAX.

> 
>> - port = U32_MAX + 1
>> - port = U32_MAX + 2
> 
>       Don't you think that all port values >= U16_MAX + 1, EINVAL should
>       be returned?

All port values > U16_MAX should indeed return EINVAL, and tests should 
check kernel casting (i.e. the kernel must check the 64-bit value before 
casting it to a 16-bit value and only check the casted zero). I didn't 
mean that these cases should pass, only that they should be tested, but 
I think you got it. ;)

>>
>>
>>>>
>>>> If we think about protocols other than TCP and UDP (e.g. AF_VSOCK), it
>>>> could make sense to have a dedicated attr struct specifying other
>>>> properties (e.g. CID). Anyway, the API is flexible but it would be nice
>>>> to not mess with it too much. What do you think?
>>>>
>>>>
>>>>>>
>>>>>>> +
>>>>>>> +    err = landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
>>>>>>> +                            &net_service, 0);
>>>>>>> +
>>>>>>> +The next step is to restrict the current thread from gaining more privileges
>>>>>>> +(e.g. thanks to a SUID binary). We now have a ruleset with the first rule allowing
>>>>>>              ^^^^^^
>>>>>>              "through" a SUID binary? "thanks to" sounds like it's desired
>>>>>>              to do that, while we're actually trying to prevent it here?
>>>>>
>>>>>       This is Mickaёl's part. Let's ask his opinion here.
>>>>>
>>>>>       Mickaёl, any thoughts?
>>>>
>>>> Yep, "through" looks better.
>>>> .
>> .
