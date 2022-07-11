Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50196570503
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 16:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbiGKOFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 10:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiGKOFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 10:05:17 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D4010548;
        Mon, 11 Jul 2022 07:05:15 -0700 (PDT)
Received: from fraeml744-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LhQbY0V8hz6HJdj;
        Mon, 11 Jul 2022 22:03:53 +0800 (CST)
Received: from lhreml745-chm.china.huawei.com (10.201.108.195) by
 fraeml744-chm.china.huawei.com (10.206.15.225) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 11 Jul 2022 16:05:12 +0200
Received: from [10.122.132.241] (10.122.132.241) by
 lhreml745-chm.china.huawei.com (10.201.108.195) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 11 Jul 2022 15:05:11 +0100
Message-ID: <223e6a19-058e-439e-ef29-a53d086838d9@huawei.com>
Date:   Mon, 11 Jul 2022 17:05:11 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v6 02/17] landlock: refactors landlock_find/insert_rule
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <anton.sirazetdinov@huawei.com>
References: <20220621082313.3330667-1-konstantin.meskhidze@huawei.com>
 <20220621082313.3330667-3-konstantin.meskhidze@huawei.com>
 <0bbbcf21-1e7d-5585-545f-bf89d8ebd527@digikod.net>
 <7735ae47-9088-be29-2696-c5170031d7c2@huawei.com>
 <b08fe5cc-3be0-390b-3575-4f27f795f609@digikod.net>
 <6ee7e769-ce91-a6cc-378b-f206e04d112a@huawei.com>
 <582f8ace-1f95-16a6-fa9e-4014ddd8b7f2@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <582f8ace-1f95-16a6-fa9e-4014ddd8b7f2@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhreml753-chm.china.huawei.com (10.201.108.203) To
 lhreml745-chm.china.huawei.com (10.201.108.195)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



7/8/2022 5:35 PM, Mickaël Salaün пишет:
> 
> On 08/07/2022 16:14, Konstantin Meskhidze (A) wrote:
>> 
>> 
>> 7/8/2022 4:59 PM, Mickaël Salaün пишет:
>>>
>>> On 08/07/2022 15:10, Konstantin Meskhidze (A) wrote:
>>>>
>>>>
>>>> 7/7/2022 7:44 PM, Mickaël Salaün пишет:
>>>>>
>>>>> On 21/06/2022 10:22, Konstantin Meskhidze wrote:
>>>>>> Adds a new object union to support a socket port
>>>>>> rule type. Refactors landlock_insert_rule() and
>>>>>> landlock_find_rule() to support coming network
>>>>>> modifications. Now adding or searching a rule
>>>>>> in a ruleset depends on a rule_type argument
>>>>>> provided in refactored functions mentioned above.
>>>>>>
>>>>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>>>>>> ---
>>>>>>
>>>>>> Changes since v5:
>>>>>> * Formats code with clang-format-14.
>>>>>>
>>>>>> Changes since v4:
>>>>>> * Refactors insert_rule() and create_rule() functions by deleting
>>>>>> rule_type from their arguments list, it helps to reduce useless code.
>>>>>>
>>>>>> Changes since v3:
>>>>>> * Splits commit.
>>>>>> * Refactors landlock_insert_rule and landlock_find_rule functions.
>>>>>> * Rename new_ruleset->root_inode.
>>>>>>
>>>>>> ---
>>>>>>   security/landlock/fs.c      |   7 ++-
>>>>>>   security/landlock/ruleset.c | 105 
>>>>>> ++++++++++++++++++++++++++----------
>>>>>>   security/landlock/ruleset.h |  27 +++++-----
>>>>>>   3 files changed, 96 insertions(+), 43 deletions(-)
>>>>>>
>>>>>> diff --git a/security/landlock/fs.c b/security/landlock/fs.c
>>>>>> index e6da08ed99d1..46aedc2a05a8 100644
>>>>>> --- a/security/landlock/fs.c
>>>>>> +++ b/security/landlock/fs.c
>>>>>> @@ -173,7 +173,8 @@ int landlock_append_fs_rule(struct 
>>>>>> landlock_ruleset *const ruleset,
>>>>>>       if (IS_ERR(object))
>>>>>>           return PTR_ERR(object);
>>>>>>       mutex_lock(&ruleset->lock);
>>>>>> -    err = landlock_insert_rule(ruleset, object, access_rights);
>>>>>> +    err = landlock_insert_rule(ruleset, object, 0, access_rights,
>>>>>> +                   LANDLOCK_RULE_PATH_BENEATH);
>>>>>>       mutex_unlock(&ruleset->lock);
>>>>>>       /*
>>>>>>        * No need to check for an error because landlock_insert_rule()
>>>>>> @@ -204,7 +205,9 @@ find_rule(const struct landlock_ruleset *const 
>>>>>> domain,
>>>>>>       inode = d_backing_inode(dentry);
>>>>>>       rcu_read_lock();
>>>>>>       rule = landlock_find_rule(
>>>>>> -        domain, rcu_dereference(landlock_inode(inode)->object));
>>>>>> +        domain,
>>>>>> +        (uintptr_t)rcu_dereference(landlock_inode(inode)->object),
>>>>>> +        LANDLOCK_RULE_PATH_BENEATH);
>>>>>>       rcu_read_unlock();
>>>>>>       return rule;
>>>>>>   }
>>>>>> diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
>>>>>> index a3fd58d01f09..5f13f8a12aee 100644
>>>>>> --- a/security/landlock/ruleset.c
>>>>>> +++ b/security/landlock/ruleset.c
>>>>>> @@ -35,7 +35,7 @@ static struct landlock_ruleset 
>>>>>> *create_ruleset(const u32 num_layers)
>>>>>>           return ERR_PTR(-ENOMEM);
>>>>>>       refcount_set(&new_ruleset->usage, 1);
>>>>>>       mutex_init(&new_ruleset->lock);
>>>>>> -    new_ruleset->root = RB_ROOT;
>>>>>> +    new_ruleset->root_inode = RB_ROOT;
>>>>>>       new_ruleset->num_layers = num_layers;
>>>>>>       /*
>>>>>>        * hierarchy = NULL
>>>>>> @@ -69,7 +69,8 @@ static void build_check_rule(void)
>>>>>>   }
>>>>>>
>>>>>>   static struct landlock_rule *
>>>>>> -create_rule(struct landlock_object *const object,
>>>>>> +create_rule(struct landlock_object *const object_ptr,
>>>>>> +        const uintptr_t object_data,
>>>>>>           const struct landlock_layer (*const layers)[], const u32 
>>>>>> num_layers,
>>>>>>           const struct landlock_layer *const new_layer)
>>>>>>   {
>>>>>> @@ -90,8 +91,15 @@ create_rule(struct landlock_object *const object,
>>>>>>       if (!new_rule)
>>>>>>           return ERR_PTR(-ENOMEM);
>>>>>>       RB_CLEAR_NODE(&new_rule->node);
>>>>>> -    landlock_get_object(object);
>>>>>> -    new_rule->object = object;
>>>>>> +
>>>>>> +    if (object_ptr) {
>>>>>> +        landlock_get_object(object_ptr);
>>>>>> +        new_rule->object.ptr = object_ptr;
>>>>>> +    } else if (object_ptr && object_data) {
>>>>>
>>>>> Something is wrong with this second check: else + object_ptr?
>>>>
>>>>   Sorry. Do you mean logical error here? I got your point.
>>>>   You are right!
>>>>
>>>>   I think it must be refactored like this:
>>>>
>>>>      if (object_ptr && !object_data) {
>>>>          landlock_get_object(object_ptr);
>>>>          new_rule->object.ptr = object_ptr;
>>>>      } else if (object_ptr && object_data) {
>>>>          ...
>>>>      }
>>>
>>> There is indeed a logical error but this doesn't fix everything. Please
>>> include my previous suggestion instead.
>>>
>>     By the way, in the next commits I have fixed this logic error.
>> Anyway I will refactor this one also. Thanks.
>>>
>>>> Plus, I will add a test for this case.
>>>
>>> That would be great but I don't think this code is reachable from user
>>> space. I think that would require kunit but I may be missing something.
>>> How would you test this?
>> 
>> You are correct. I checked it. It's impossible to reach this line from 
>> userpace (insert both object_ptr and object_data). But create_rule() 
>> must be used carefuly by other developers (if any in future). Do you 
>> think if its possible to have some internal kernel tests that could 
>> handle this issue?
> 
> We can use kunit tests for such kernel functions, but in this case I'm
> not sure what could be tested. I started working on bringing kunit tests
> to Landlock but it's not ready yet. Please list all non-userspace tests
> you can think about.

  I'm thinking about ones that we can't reach from the userspace.
  I analyzed test coverage logs finding lines that are untouched by the 
userspace tests.
  Let's discus this list:

	1. create_rule():  - insert both  object_ptr and object_data.

	2. insert_rule():  - insert both  object_ptr and object_data.
			   - insert NULL (*const layers).
			   - insert layers[0].level != 0.
			   - insert num_layers != 1.
			   - insert default rule_type.
	
	3. tree_merge():   - insert default rule_type.
			   - insert walker_rule->num_layers != 1.
			   - insert walker_rule->layers[0].level != 0.
	
	4. tree_copy():    - insert default rule_type.
	
	5. merge_ruleset:  - insert !dst || !dst->hierarchy.
			   - insert src->num_layers != 1 ||
                                     dst->num_layers < 1.

	6. inherit_ruleset(): - insert child->num_layers <=
				   parent->num_layers.
  			      - insert parent->hierarchy = NULL.

	7. landlock_merge_ruleset(): - insert ruleset = NULL.
				     - insert parent = ruleset

	8. landlock_find_rule(): - insert default rule_type.

  Please your opinion?
> .
