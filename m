Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD4AD63FE4F
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 03:49:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbiLBCtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 21:49:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbiLBCts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 21:49:48 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD0C6A65B1;
        Thu,  1 Dec 2022 18:49:47 -0800 (PST)
Received: from frapeml100003.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NNcld4Psqz67L71;
        Fri,  2 Dec 2022 10:46:37 +0800 (CST)
Received: from lhrpeml500004.china.huawei.com (7.191.163.9) by
 frapeml100003.china.huawei.com (7.182.85.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 2 Dec 2022 03:49:45 +0100
Received: from [10.122.132.241] (10.122.132.241) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Fri, 2 Dec 2022 02:49:44 +0000
Message-ID: <de685f52-ab35-0dbe-46f2-4dd611999711@huawei.com>
Date:   Fri, 2 Dec 2022 05:49:43 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v8 01/12] landlock: Make ruleset's access masks more
 generic
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <artem.kuzin@huawei.com>
References: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
 <20221021152644.155136-2-konstantin.meskhidze@huawei.com>
 <94ed4212-c093-9c5c-089f-e9e4097e5bd6@digikod.net>
 <3f9fc69d-1604-d879-d341-8a831beabeea@huawei.com>
 <700956d7-9831-da1d-c397-d1fb45aaf5d7@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <700956d7-9831-da1d-c397-d1fb45aaf5d7@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhrpeml500004.china.huawei.com (7.191.163.9) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



11/28/2022 11:22 PM, Mickaël Salaün пишет:
> 
> On 28/11/2022 03:53, Konstantin Meskhidze (A) wrote:
>> 
>> 
>> 11/17/2022 9:41 PM, Mickaël Salaün пишет:
>>>
>>> On 21/10/2022 17:26, Konstantin Meskhidze wrote:
>>>> To support network type rules, this modification renames ruleset's
>>>> access masks and modifies it's type to access_masks_t. This patch
>>>> adds filesystem helper functions to add and get filesystem mask.
>>>>
>>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>>>> ---
>>>>
>>>> Changes since v7:
>>>> * Refactors commit message.
>>>>
>>>> Changes since v6:
>>>> * Adds a new access_masks_t for struct ruleset.
>>>> * Renames landlock_set_fs_access_mask() to landlock_add_fs_access_mask()
>>>>     because it OR values.
>>>> * Makes landlock_add_fs_access_mask() more resilient incorrect values.
>>>> * Refactors landlock_get_fs_access_mask().
>>>>
>>>> Changes since v6:
>>>> * Adds a new access_masks_t for struct ruleset.
>>>> * Renames landlock_set_fs_access_mask() to landlock_add_fs_access_mask()
>>>>     because it OR values.
>>>> * Makes landlock_add_fs_access_mask() more resilient incorrect values.
>>>> * Refactors landlock_get_fs_access_mask().
>>>>
>>>> Changes since v5:
>>>> * Changes access_mask_t to u32.
>>>> * Formats code with clang-format-14.
>>>>
>>>> Changes since v4:
>>>> * Deletes struct landlock_access_mask.
>>>>
>>>> Changes since v3:
>>>> * Splits commit.
>>>> * Adds get_mask, set_mask helpers for filesystem.
>>>> * Adds new struct landlock_access_mask.
>>>>
>>>> ---
>>>>    security/landlock/fs.c       | 10 +++++-----
>>>>    security/landlock/limits.h   |  1 +
>>>>    security/landlock/ruleset.c  | 17 +++++++++--------
>>>>    security/landlock/ruleset.h  | 35 +++++++++++++++++++++++++++++++----
>>>>    security/landlock/syscalls.c |  7 ++++---
>>>>    5 files changed, 50 insertions(+), 20 deletions(-)
>>>>
>>>> diff --git a/security/landlock/fs.c b/security/landlock/fs.c
>>>> index adcea0fe7e68..0d57c6479d29 100644
>>>> --- a/security/landlock/fs.c
>>>> +++ b/security/landlock/fs.c
>>>> @@ -178,9 +178,9 @@ int landlock_append_fs_rule(struct landlock_ruleset *const ruleset,
>>>>    		return -EINVAL;
>>>>
>>>>    	/* Transforms relative access rights to absolute ones. */
>>>> -	access_rights |=
>>>> -		LANDLOCK_MASK_ACCESS_FS &
>>>> -		~(ruleset->fs_access_masks[0] | ACCESS_INITIALLY_DENIED);
>>>> +	access_rights |= LANDLOCK_MASK_ACCESS_FS &
>>>> +			 ~(landlock_get_fs_access_mask(ruleset, 0) |
>>>> +			   ACCESS_INITIALLY_DENIED);
>>>>    	object = get_inode_object(d_backing_inode(path->dentry));
>>>>    	if (IS_ERR(object))
>>>>    		return PTR_ERR(object);
>>>> @@ -294,7 +294,7 @@ get_handled_accesses(const struct landlock_ruleset *const domain)
>>>>    	size_t layer_level;
>>>>
>>>>    	for (layer_level = 0; layer_level < domain->num_layers; layer_level++)
>>>> -		access_dom |= domain->fs_access_masks[layer_level];
>>>> +		access_dom |= landlock_get_fs_access_mask(domain, layer_level);
>>>>    	return access_dom & LANDLOCK_MASK_ACCESS_FS;
>>>
>>> You can remove `& LANDLOCK_MASK_ACCESS_FS` here because it is now part
>>> of landlock_get_fs_access_mask().
>> 
>>     Ok. I got it. Thanks.
>>>
>>>
>>>>    }
>>>>
>>>> @@ -336,7 +336,7 @@ init_layer_masks(const struct landlock_ruleset *const domain,
>>>>    			 * access rights.
>>>>    			 */
>>>>    			if (BIT_ULL(access_bit) &
>>>> -			    (domain->fs_access_masks[layer_level] |
>>>> +			    (landlock_get_fs_access_mask(domain, layer_level) |
>>>>    			     ACCESS_INITIALLY_DENIED)) {
>>>>    				(*layer_masks)[access_bit] |=
>>>>    					BIT_ULL(layer_level);
>>>> diff --git a/security/landlock/limits.h b/security/landlock/limits.h
>>>> index 82288f0e9e5e..bafb3b8dc677 100644
>>>> --- a/security/landlock/limits.h
>>>> +++ b/security/landlock/limits.h
>>>> @@ -21,6 +21,7 @@
>>>>    #define LANDLOCK_LAST_ACCESS_FS		LANDLOCK_ACCESS_FS_TRUNCATE
>>>>    #define LANDLOCK_MASK_ACCESS_FS		((LANDLOCK_LAST_ACCESS_FS << 1) - 1)
>>>>    #define LANDLOCK_NUM_ACCESS_FS		__const_hweight64(LANDLOCK_MASK_ACCESS_FS)
>>>> +#define LANDLOCK_SHIFT_ACCESS_FS	0
>>>>
>>>>    /* clang-format on */
>>>>
>>>> diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
>>>> index 996484f98bfd..1f3188b4e313 100644
>>>> --- a/security/landlock/ruleset.c
>>>> +++ b/security/landlock/ruleset.c
>>>> @@ -29,7 +29,7 @@ static struct landlock_ruleset *create_ruleset(const u32 num_layers)
>>>>    	struct landlock_ruleset *new_ruleset;
>>>>
>>>>    	new_ruleset =
>>>> -		kzalloc(struct_size(new_ruleset, fs_access_masks, num_layers),
>>>> +		kzalloc(struct_size(new_ruleset, access_masks, num_layers),
>>>>    			GFP_KERNEL_ACCOUNT);
>>>>    	if (!new_ruleset)
>>>>    		return ERR_PTR(-ENOMEM);
>>>> @@ -40,7 +40,7 @@ static struct landlock_ruleset *create_ruleset(const u32 num_layers)
>>>>    	/*
>>>>    	 * hierarchy = NULL
>>>>    	 * num_rules = 0
>>>> -	 * fs_access_masks[] = 0
>>>> +	 * access_masks[] = 0
>>>>    	 */
>>>>    	return new_ruleset;
>>>>    }
>>>> @@ -55,7 +55,7 @@ landlock_create_ruleset(const access_mask_t fs_access_mask)
>>>>    		return ERR_PTR(-ENOMSG);
>>>>    	new_ruleset = create_ruleset(1);
>>>>    	if (!IS_ERR(new_ruleset))
>>>> -		new_ruleset->fs_access_masks[0] = fs_access_mask;
>>>> +		landlock_add_fs_access_mask(new_ruleset, fs_access_mask, 0);
>>>>    	return new_ruleset;
>>>>    }
>>>>
>>>> @@ -117,11 +117,12 @@ static void build_check_ruleset(void)
>>>>    		.num_rules = ~0,
>>>>    		.num_layers = ~0,
>>>>    	};
>>>> -	typeof(ruleset.fs_access_masks[0]) fs_access_mask = ~0;
>>>> +	typeof(ruleset.access_masks[0]) access_masks = ~0;
>>>>
>>>>    	BUILD_BUG_ON(ruleset.num_rules < LANDLOCK_MAX_NUM_RULES);
>>>>    	BUILD_BUG_ON(ruleset.num_layers < LANDLOCK_MAX_NUM_LAYERS);
>>>> -	BUILD_BUG_ON(fs_access_mask < LANDLOCK_MASK_ACCESS_FS);
>>>> +	BUILD_BUG_ON(access_masks <
>>>> +		     (LANDLOCK_MASK_ACCESS_FS << LANDLOCK_SHIFT_ACCESS_FS));
>>>>    }
>>>>
>>>>    /**
>>>> @@ -281,7 +282,7 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
>>>>    		err = -EINVAL;
>>>>    		goto out_unlock;
>>>>    	}
>>>> -	dst->fs_access_masks[dst->num_layers - 1] = src->fs_access_masks[0];
>>>> +	dst->access_masks[dst->num_layers - 1] = src->access_masks[0];
>>>>
>>>>    	/* Merges the @src tree. */
>>>>    	rbtree_postorder_for_each_entry_safe(walker_rule, next_rule, &src->root,
>>>> @@ -340,8 +341,8 @@ static int inherit_ruleset(struct landlock_ruleset *const parent,
>>>>    		goto out_unlock;
>>>>    	}
>>>>    	/* Copies the parent layer stack and leaves a space for the new layer. */
>>>> -	memcpy(child->fs_access_masks, parent->fs_access_masks,
>>>> -	       flex_array_size(parent, fs_access_masks, parent->num_layers));
>>>> +	memcpy(child->access_masks, parent->access_masks,
>>>> +	       flex_array_size(parent, access_masks, parent->num_layers));
>>>>
>>>>    	if (WARN_ON_ONCE(!parent->hierarchy)) {
>>>>    		err = -EINVAL;
>>>> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
>>>> index d43231b783e4..f2ad932d396c 100644
>>>> --- a/security/landlock/ruleset.h
>>>> +++ b/security/landlock/ruleset.h
>>>> @@ -25,6 +25,11 @@ static_assert(BITS_PER_TYPE(access_mask_t) >= LANDLOCK_NUM_ACCESS_FS);
>>>>    /* Makes sure for_each_set_bit() and for_each_clear_bit() calls are OK. */
>>>>    static_assert(sizeof(unsigned long) >= sizeof(access_mask_t));
>>>>
>>>> +/* Ruleset access masks. */
>>>> +typedef u16 access_masks_t;
>>>> +/* Makes sure all ruleset access rights can be stored. */
>>>> +static_assert(BITS_PER_TYPE(access_masks_t) >= LANDLOCK_NUM_ACCESS_FS);
>>>> +
>>>>    typedef u16 layer_mask_t;
>>>>    /* Makes sure all layers can be checked. */
>>>>    static_assert(BITS_PER_TYPE(layer_mask_t) >= LANDLOCK_MAX_NUM_LAYERS);
>>>> @@ -110,7 +115,7 @@ struct landlock_ruleset {
>>>>    		 * section.  This is only used by
>>>>    		 * landlock_put_ruleset_deferred() when @usage reaches zero.
>>>>    		 * The fields @lock, @usage, @num_rules, @num_layers and
>>>> -		 * @fs_access_masks are then unused.
>>>> +		 * @access_masks are then unused.
>>>>    		 */
>>>>    		struct work_struct work_free;
>>>>    		struct {
>>>> @@ -137,7 +142,7 @@ struct landlock_ruleset {
>>>>    			 */
>>>>    			u32 num_layers;
>>>>    			/**
>>>> -			 * @fs_access_masks: Contains the subset of filesystem
>>>> +			 * @access_masks: Contains the subset of filesystem
>>>>    			 * actions that are restricted by a ruleset.  A domain
>>>>    			 * saves all layers of merged rulesets in a stack
>>>>    			 * (FAM), starting from the first layer to the last
>>>> @@ -148,13 +153,13 @@ struct landlock_ruleset {
>>>>    			 * layers are set once and never changed for the
>>>>    			 * lifetime of the ruleset.
>>>>    			 */
>>>> -			access_mask_t fs_access_masks[];
>>>> +			access_masks_t access_masks[];
>>>>    		};
>>>>    	};
>>>>    };
>>>>
>>>>    struct landlock_ruleset *
>>>> -landlock_create_ruleset(const access_mask_t fs_access_mask);
>>>> +landlock_create_ruleset(const access_mask_t access_mask);
>>>>
>>>>    void landlock_put_ruleset(struct landlock_ruleset *const ruleset);
>>>>    void landlock_put_ruleset_deferred(struct landlock_ruleset *const ruleset);
>>>> @@ -177,4 +182,26 @@ static inline void landlock_get_ruleset(struct landlock_ruleset *const ruleset)
>>>>    		refcount_inc(&ruleset->usage);
>>>>    }
>>>>
>>>> +static inline void
>>>> +landlock_add_fs_access_mask(struct landlock_ruleset *const ruleset,
>>>> +			    const access_mask_t fs_access_mask,
>>>> +			    const u16 layer_level)
>>>> +{
>>>> +	access_mask_t fs_mask = fs_access_mask & LANDLOCK_MASK_ACCESS_FS;
>>>> +
>>>> +	/* Should already be checked in sys_landlock_create_ruleset(). */
>>>> +	WARN_ON_ONCE(fs_access_mask != fs_mask);
>>>> +	// TODO: Add tests to check "|=" and not "="
>>>
>>> This todo should be done and removed. No more todos must remain.
>>>
>>     I delete it in 10/12 Patch when add network seltests.
> 
> You can delete it in this patch then. I'm reviewing the tests.

   Ok. Thanks.
> .
