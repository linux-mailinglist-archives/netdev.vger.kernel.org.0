Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 054394AD8C9
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 14:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343792AbiBHNPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 08:15:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349374AbiBHMJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 07:09:19 -0500
Received: from smtp-bc0a.mail.infomaniak.ch (smtp-bc0a.mail.infomaniak.ch [IPv6:2001:1600:4:17::bc0a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76021C03FEC0
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 04:09:16 -0800 (PST)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4JtMHt5rdrzMpxpF;
        Tue,  8 Feb 2022 13:09:14 +0100 (CET)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4JtMHt2YwkzlhSMm;
        Tue,  8 Feb 2022 13:09:14 +0100 (CET)
Message-ID: <a08cd5ec-8bbd-3984-a189-f1e436d09ae8@digikod.net>
Date:   Tue, 8 Feb 2022 13:09:55 +0100
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
References: <20220124080215.265538-1-konstantin.meskhidze@huawei.com>
 <20220124080215.265538-2-konstantin.meskhidze@huawei.com>
 <ed2bd420-a22b-2912-1ff5-f48ab352d8e7@digikod.net>
 <5cd5b983-32a5-97ec-0835-f0c96d86e805@huawei.com>
 <10999c72-93eb-4db2-e536-a92187545bdb@digikod.net>
 <cc023cc4-043b-c67e-1e6e-acf1eb18d155@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [RFC PATCH 1/2] landlock: TCP network hooks implementation
In-Reply-To: <cc023cc4-043b-c67e-1e6e-acf1eb18d155@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 08/02/2022 08:55, Konstantin Meskhidze wrote:
> 
> 
> 2/7/2022 5:17 PM, Mickaël Salaün пишет:
>>
>> On 07/02/2022 14:09, Konstantin Meskhidze wrote:
>>>
>>>
>>> 2/1/2022 3:13 PM, Mickaël Salaün пишет:
>>>>
>>>> On 24/01/2022 09:02, Konstantin Meskhidze wrote:
>>>>> Support of socket_bind() and socket_connect() hooks.
>>>>> Current prototype can restrict binding and connecting of TCP
>>>>> types of sockets. Its just basic idea how Landlock could support
>>>>> network confinement.
>>>>>
>>>>> Changes:
>>>>> 1. Access masks array refactored into 1D one and changed
>>>>> to 32 bits. Filesystem masks occupy 16 lower bits and network
>>>>> masks reside in 16 upper bits.
>>>>> 2. Refactor API functions in ruleset.c:
>>>>>      1. Add void *object argument.
>>>>>      2. Add u16 rule_type argument.
>>>>> 3. Use two rb_trees in ruleset structure:
>>>>>      1. root_inode - for filesystem objects
>>>>>      2. root_net_port - for network port objects
>>>>
>>>> It's good to add a changelog, but they must not be in commit 
>>>> messages that get copied by git am. Please use "---" to separate 
>>>> this additionnal info (but not the Signed-off-by). Please also 
>>>> include a version in the email subjects (this one should have been 
>>>> "[RFC PATCH v3 1/2] landlock: …"), e.g. using git format-patch 
>>>> --reroll-count=X .
>>>>
>>>> Please follow these rules: 
>>>> https://www.kernel.org/doc/html/latest/process/submitting-patches.html
>>>> You can take some inspiration from this patch series: 
>>>> https://lore.kernel.org/lkml/20210422154123.13086-1-mic@digikod.net/
>>>
>>>   Ok. I will add patch vervison in next patch. So it will be "[RFC PATCH
>>>   v4 ../..] landlock: ..."
>>>   But the previous patches remain with no version, correct?
>>
>> Right, you can't change the subject of already sent emails. ;)
> 
>    Ok. But I can add previous patches like:
>     v1: 
> https://lore.kernel.org/linux-security-module/20211210072123.386713-1-konstantin.meskhidze@huawei.com 
> 
>     v2: 
> https://lore.kernel.org/netdev/20211228115212.703084-1-konstantin.meskhidze@huawei.com/ 
> 
>     v3: ....
> 
>   right ?

Absolutely! This is a good practice (and would be better in reverse order).


>> [...]
>>
>>>>> @@ -67,10 +76,11 @@ static void build_check_rule(void)
>>>>>   }
>>>>>   static struct landlock_rule *create_rule(
>>>>> -        struct landlock_object *const object,
>>>>> +        void *const object,
>>>>
>>>> Instead of shoehorning two different types into one (and then 
>>>> loosing the typing), you should rename object to object_ptr and add 
>>>> a new object_data argument. Only one of these should be set 
>>>> according to the rule_type. However, if there is no special action 
>>>> performed on one of these type (e.g. landlock_get_object), only one 
>>>> uintptr_t argument should be enough.
>>>>
>>>   Do you mean using 2 object arguments in create_rule():
>>>
>>>      1. create_rule( object_ptr = landlock_object , object_data = 0,
>>>                                 ...,  fs_rule_type);
>>>          2. create_rule( object_ptr = NULL , object_data = port, .... ,
>>>                           net_rule_type);
>>
>> Yes, and you can add a WARN_ON_ONCE() in these function to check that 
>> only one argument is set (but object_data could be 0 in each case). 
>> The landlock_get_object() function should only require an object_data 
>> though.
>>
>    Sorry. As you said in previous comment in landlock_get_object, only
>    one  uintptr_t argument should be enough. But, I did not get: "The
>    landlock_get_object() function should only require an object_data
>    though".
>    uintptr_t is the only argument in landlock_get_object?

I was thinking about landlock_find_rule(), not landlock_get_object():
const struct landlock_rule *landlock_find_rule(
		const struct landlock_ruleset *const ruleset,
		const uintptr_t object_data)


>> [...]
>>
>>>>> @@ -317,47 +331,91 @@ SYSCALL_DEFINE4(landlock_add_rule,
>>>>>       if (flags)
>>>>>           return -EINVAL;
>>>>> -    if (rule_type != LANDLOCK_RULE_PATH_BENEATH)
>>>>> +    if ((rule_type != LANDLOCK_RULE_PATH_BENEATH) &&
>>>>> +        (rule_type != LANDLOCK_RULE_NET_SERVICE))
>>>>
>>>> Please replace with a switch/case.
>>>
>>>    Ok. I got it.
>>>>
>>>>
>>>>>           return -EINVAL;
>>>>> -    /* Copies raw user space buffer, only one type for now. */
>>>>> -    res = copy_from_user(&path_beneath_attr, rule_attr,
>>>>> -            sizeof(path_beneath_attr));
>>>>> -    if (res)
>>>>> -        return -EFAULT;
>>>>> -
>>>>> -    /* Gets and checks the ruleset. */
>>>>> -    ruleset = get_ruleset_from_fd(ruleset_fd, FMODE_CAN_WRITE);
>>>>> -    if (IS_ERR(ruleset))
>>>>> -        return PTR_ERR(ruleset);
>>>>> -
>>>>> -    /*
>>>>> -     * Informs about useless rule: empty allowed_access (i.e. deny 
>>>>> rules)
>>>>> -     * are ignored in path walks.
>>>>> -     */
>>>>> -    if (!path_beneath_attr.allowed_access) {
>>>>> -        err = -ENOMSG;
>>>>> -        goto out_put_ruleset;
>>>>> -    }
>>>>> -    /*
>>>>> -     * Checks that allowed_access matches the @ruleset constraints
>>>>> -     * (ruleset->fs_access_masks[0] is automatically upgraded to 
>>>>> 64-bits).
>>>>> -     */
>>>>> -    if ((path_beneath_attr.allowed_access | 
>>>>> ruleset->fs_access_masks[0]) !=
>>>>> -            ruleset->fs_access_masks[0]) {
>>>>> -        err = -EINVAL;
>>>>> -        goto out_put_ruleset;
>>>>> +    switch (rule_type) {
>>>>> +    case LANDLOCK_RULE_PATH_BENEATH:
>>>>> +        /* Copies raw user space buffer, for fs rule type. */
>>>>> +        res = copy_from_user(&path_beneath_attr, rule_attr,
>>>>> +                    sizeof(path_beneath_attr));
>>>>> +        if (res)
>>>>> +            return -EFAULT;
>>>>> +        break;
>>>>> +
>>>>> +    case LANDLOCK_RULE_NET_SERVICE:
>>>>> +        /* Copies raw user space buffer, for net rule type. */
>>>>> +        res = copy_from_user(&net_service_attr, rule_attr,
>>>>> +                sizeof(net_service_attr));
>>>>> +        if (res)
>>>>> +            return -EFAULT;
>>>>> +        break;
>>>>>       }
>>>>> -    /* Gets and checks the new rule. */
>>>>> -    err = get_path_from_fd(path_beneath_attr.parent_fd, &path);
>>>>> -    if (err)
>>>>> -        goto out_put_ruleset;
>>>>> +    if (rule_type == LANDLOCK_RULE_PATH_BENEATH) {
>>>>> +        /* Gets and checks the ruleset. */
>>>>> +        ruleset = get_ruleset_from_fd(ruleset_fd, FMODE_CAN_WRITE);
>>>>> +        if (IS_ERR(ruleset))
>>>>> +            return PTR_ERR(ruleset);
>>>>> +
>>>>> +        /*
>>>>> +         * Informs about useless rule: empty allowed_access (i.e. 
>>>>> deny rules)
>>>>> +         * are ignored in path walks.
>>>>> +         */
>>>>> +        if (!path_beneath_attr.allowed_access) {
>>>>> +            err = -ENOMSG;
>>>>> +            goto out_put_ruleset;
>>>>> +        }
>>>>> +        /*
>>>>> +         * Checks that allowed_access matches the @ruleset 
>>>>> constraints
>>>>> +         * (ruleset->access_masks[0] is automatically upgraded to 
>>>>> 64-bits).
>>>>> +         */
>>>>> +        if ((path_beneath_attr.allowed_access | 
>>>>> ruleset->access_masks[0]) !=
>>>>> +                            ruleset->access_masks[0]) {
>>>>> +            err = -EINVAL;
>>>>> +            goto out_put_ruleset;
>>>>> +        }
>>>>> +
>>>>> +        /* Gets and checks the new rule. */
>>>>> +        err = get_path_from_fd(path_beneath_attr.parent_fd, &path);
>>>>> +        if (err)
>>>>> +            goto out_put_ruleset;
>>>>> +
>>>>> +        /* Imports the new rule. */
>>>>> +        err = landlock_append_fs_rule(ruleset, &path,
>>>>> +                path_beneath_attr.allowed_access);
>>>>> +        path_put(&path);
>>>>> +    }
>>>>> -    /* Imports the new rule. */
>>>>> -    err = landlock_append_fs_rule(ruleset, &path,
>>>>> -            path_beneath_attr.allowed_access);
>>>>> -    path_put(&path);
>>>>> +    if (rule_type == LANDLOCK_RULE_NET_SERVICE) {
>>>>> +        /* Gets and checks the ruleset. */
>>>>> +        ruleset = get_ruleset_from_fd(ruleset_fd, FMODE_CAN_WRITE);
>>>>
>>>> You need to factor out more code.
>>>
>>>    Sorry. I did not get you here. Please could you explain more 
>>> detailed?
>>
>> Instead of duplicating similar function calls (e.g. 
>> get_ruleset_from_fd) or operations, try to use one switch statement 
>> where you put the checks that are different (you can move the 
>> copy_from_user(&path_beneath_attr...) call). It may be a good idea to 
>> split this function into 3: one handling each rule_attr, which enables 
>> to not mix different attr types in the same function. A standalone 
>> patch should be refactoring the code to add and use a new function 
>> add_rule_path_beneath(ruleset, rule_attr) (only need the "landlock_" 
>> prefix for exported functions).
> 
>    Sorry again. Still don't get the point. What function do you suggetst
>    to split in 3? Can you please give detailed template of these
>    functions and the logic?

You can split SYSCALL_DEFINE4(landlock_add_rule) in 3:
- a lighten version of SYSCALL_DEFINE4(landlock_add_rule) containing 
switch cases for rule_type (almost what you did but with the 
get_ruleset_from_fd moved before);
- a new add_rule_path_beneath(ruleset, rule_attr) which will be called 
by the switch case;
- a new add_rule_net_service(ruleset, rule_attr) which will be called by 
the switch case.
