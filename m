Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32E8263B31C
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 21:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234096AbiK1U1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 15:27:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234131AbiK1U0s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 15:26:48 -0500
Received: from smtp-42ac.mail.infomaniak.ch (smtp-42ac.mail.infomaniak.ch [IPv6:2001:1600:4:17::42ac])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CBE02DAB4
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 12:26:43 -0800 (PST)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4NLcSf0142zMq4cB;
        Mon, 28 Nov 2022 21:26:42 +0100 (CET)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4NLcSd1bktzwy;
        Mon, 28 Nov 2022 21:26:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1669667201;
        bh=PYhARmPRWBAR3gdL8U39SstQEnPL+gynR2X4/0WHpoc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=CmSjedJNvuS3XEb1Y2Y2T0rYh+cTUOiVaMApMO22ISAmkKF4GeFr2btWYul19Z1fh
         YNHQKt1dZVVlTMSZGT//kwnRFJc31bEYqQoAOP7YT/H+KFEOoMp4Of+VncgnWhLUZI
         p5O52IFWmoX7jEOGWiow0PYEJC+uNkD+xMt8UZQc=
Message-ID: <2bce0b5a-a679-93f2-995c-cb0e80c82bf2@digikod.net>
Date:   Mon, 28 Nov 2022 21:26:40 +0100
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v8 12/12] landlock: Document Landlock's network support
Content-Language: en-US
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, artem.kuzin@huawei.com,
        linux-doc@vger.kernel.org
References: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
 <20221021152644.155136-13-konstantin.meskhidze@huawei.com>
 <8a8ba39f-c7c2-eca6-93b1-f36d982726ca@digikod.net>
 <73a8a2f2-0d59-970d-eaba-c0da38a1c38b@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <73a8a2f2-0d59-970d-eaba-c0da38a1c38b@huawei.com>
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


On 28/11/2022 07:44, Konstantin Meskhidze (A) wrote:
> 
> 
> 11/17/2022 9:44 PM, Mickaël Salaün пишет:
>>
>> On 21/10/2022 17:26, Konstantin Meskhidze wrote:
>>> Describes network access rules for TCP sockets. Adds network access
>>> example in the tutorial. Points out AF_UNSPEC socket family behaviour.
>>> Adds kernel configuration support for network.
>>>
>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>>> ---
>>>
>>> Changes since v7:
>>> * Fixes documentaion logic errors and typos as Mickaёl suggested:
>>> https://lore.kernel.org/netdev/9f354862-2bc3-39ea-92fd-53803d9bbc21@digikod.net/
>>>
>>> Changes since v6:
>>> * Adds network support documentaion.
>>>
>>> ---
>>>    Documentation/userspace-api/landlock.rst | 72 +++++++++++++++++++-----
>>>    1 file changed, 59 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/Documentation/userspace-api/landlock.rst b/Documentation/userspace-api/landlock.rst
>>> index d8cd8cd9ce25..d0610ec9ce05 100644
>>> --- a/Documentation/userspace-api/landlock.rst
>>> +++ b/Documentation/userspace-api/landlock.rst
>>> @@ -11,10 +11,10 @@ Landlock: unprivileged access control
>>>    :Date: October 2022
>>>
>>>    The goal of Landlock is to enable to restrict ambient rights (e.g. global
>>> -filesystem access) for a set of processes.  Because Landlock is a stackable
>>> -LSM, it makes possible to create safe security sandboxes as new security layers
>>> -in addition to the existing system-wide access-controls. This kind of sandbox
>>> -is expected to help mitigate the security impact of bugs or
>>> +filesystem or network access) for a set of processes.  Because Landlock
>>> +is a stackable LSM, it makes possible to create safe security sandboxes as new
>>> +security layers in addition to the existing system-wide access-controls. This
>>> +kind of sandbox is expected to help mitigate the security impact of bugs or
>>>    unexpected/malicious behaviors in user space applications.  Landlock empowers
>>>    any process, including unprivileged ones, to securely restrict themselves.
>>>
>>> @@ -30,18 +30,20 @@ Landlock rules
>>>
>>>    A Landlock rule describes an action on an object.  An object is currently a
>>>    file hierarchy, and the related filesystem actions are defined with `access
>>> -rights`_.  A set of rules is aggregated in a ruleset, which can then restrict
>>> -the thread enforcing it, and its future children.
>>> +rights`_.  Since ABI version 4 a port data appears with related network actions
>>> +for TCP socket families.  A set of rules is aggregated in a ruleset, which
>>> +can then restrict the thread enforcing it, and its future children.
>>>
>>>    Defining and enforcing a security policy
>>>    ----------------------------------------
>>>
>>>    We first need to define the ruleset that will contain our rules.  For this
>>>    example, the ruleset will contain rules that only allow read actions, but write
>>> -actions will be denied.  The ruleset then needs to handle both of these kind of
>>> +actions will be denied. The ruleset then needs to handle both of these kind of
>>>    actions.  This is required for backward and forward compatibility (i.e. the
>>>    kernel and user space may not know each other's supported restrictions), hence
>>> -the need to be explicit about the denied-by-default access rights.
>>> +the need to be explicit about the denied-by-default access rights.  Also ruleset
>>> +will have network rules for specific ports, so it should handle network actions.
>>>
>>>    .. code-block:: c
>>>
>>> @@ -62,6 +64,9 @@ the need to be explicit about the denied-by-default access rights.
>>>                LANDLOCK_ACCESS_FS_MAKE_SYM |
>>>                LANDLOCK_ACCESS_FS_REFER |
>>>                LANDLOCK_ACCESS_FS_TRUNCATE,
>>> +        .handled_access_net =
>>> +            LANDLOCK_ACCESS_NET_BIND_TCP |
>>> +            LANDLOCK_ACCESS_NET_CONNECT_TCP,
>>>        };
>>>
>>>    Because we may not know on which kernel version an application will be
>>> @@ -70,14 +75,18 @@ should try to protect users as much as possible whatever the kernel they are
>>>    using.  To avoid binary enforcement (i.e. either all security features or
>>>    none), we can leverage a dedicated Landlock command to get the current version
>>>    of the Landlock ABI and adapt the handled accesses.  Let's check if we should
>>> -remove the ``LANDLOCK_ACCESS_FS_REFER`` or ``LANDLOCK_ACCESS_FS_TRUNCATE``
>>> -access rights, which are only supported starting with the second and third
>>> -version of the ABI.
>>> +remove the `LANDLOCK_ACCESS_FS_REFER` or `LANDLOCK_ACCESS_FS_TRUNCATE` or
>>> +network access rights, which are only supported starting with the second,
>>
>> This is a bad rebase.
> 
>     Sorry. Did not get it.

This hunk (and maybe others) changes unrelated things (e.g. back quotes).


>>
>>
>>> +third and fourth version of the ABI.
>>>
>>>    .. code-block:: c
>>>
>>>        int abi;
>>>
>>> +    #define ACCESS_NET_BIND_CONNECT ( \
>>> +    LANDLOCK_ACCESS_NET_BIND_TCP | \
>>> +    LANDLOCK_ACCESS_NET_CONNECT_TCP)
>>
>> Please add a 4-spaces prefix for these two lines.
> 
>     Like this??
> 	#define ACCESS_NET_BIND_CONNECT ( \
>               LANDLOCK_ACCESS_NET_BIND_TCP | \
>               LANDLOCK_ACCESS_NET_CONNECT_TCP)

Like for other indentations in the documentation (e.g. ruleset_attr 
definition):

#define ACCESS_NET_BIND_CONNECT ( \
     LANDLOCK_ACCESS_NET_BIND_TCP | \
     LANDLOCK_ACCESS_NET_CONNECT_TCP)
