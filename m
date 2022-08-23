Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACC759E2B2
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 14:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355867AbiHWKpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 06:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236710AbiHWKm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 06:42:59 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFCC4AB042;
        Tue, 23 Aug 2022 02:10:21 -0700 (PDT)
Received: from fraeml734-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MBk2j2wN4z67Prq;
        Tue, 23 Aug 2022 17:10:05 +0800 (CST)
Received: from lhrpeml500004.china.huawei.com (7.191.163.9) by
 fraeml734-chm.china.huawei.com (10.206.15.215) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 23 Aug 2022 11:10:18 +0200
Received: from [10.122.132.241] (10.122.132.241) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 23 Aug 2022 10:10:17 +0100
Message-ID: <20126d38-a9d2-d805-6331-276fa436a172@huawei.com>
Date:   Tue, 23 Aug 2022 12:10:16 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v6 00/17] Network support for Landlock
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <anton.sirazetdinov@huawei.com>
References: <20220621082313.3330667-1-konstantin.meskhidze@huawei.com>
 <4c57a0c2-e207-10d6-c73d-bcda66bf3963@digikod.net>
 <6691d91f-c03b-30fa-2fa0-d062b3b234b9@digikod.net>
 <86db9124-ea11-0fa5-9dff-61744b2f80b4@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <86db9124-ea11-0fa5-9dff-61744b2f80b4@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhrpeml500004.china.huawei.com (7.191.163.9) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



7/28/2022 4:17 PM, Mickaël Salaün пишет:
> 
> On 27/07/2022 21:54, Mickaël Salaün wrote:
>> 
>> 
>> On 26/07/2022 19:43, Mickaël Salaün wrote:
>>>
>>> On 21/06/2022 10:22, Konstantin Meskhidze wrote:
>>>> Hi,
>>>> This is a new V6 patch related to Landlock LSM network confinement.
>>>> It is based on the latest landlock-wip branch on top of v5.19-rc2:
>>>> https://git.kernel.org/pub/scm/linux/kernel/git/mic/linux.git/log/?h=landlock-wip
>>>>
>>>> It brings refactoring of previous patch version V5:
>>>>       - Fixes some logic errors and typos.
>>>>       - Adds additional FIXTURE_VARIANT and FIXTURE_VARIANT_ADD helpers
>>>>       to support both ip4 and ip6 families and shorten seltests' code.
>>>>       - Makes TCP sockets confinement support optional in sandboxer demo.
>>>>       - Formats the code with clang-format-14
>>>>
>>>> All test were run in QEMU evironment and compiled with
>>>>    -static flag.
>>>>    1. network_test: 18/18 tests passed.
>>>>    2. base_test: 7/7 tests passed.
>>>>    3. fs_test: 59/59 tests passed.
>>>>    4. ptrace_test: 8/8 tests passed.
>>>>
>>>> Still have issue with base_test were compiled without -static flag
>>>> (landlock-wip branch without network support)
>>>> 1. base_test: 6/7 tests passed.
>>>>    Error:
>>>>    #  RUN           global.inconsistent_attr ...
>>>>    # base_test.c:54:inconsistent_attr:Expected ENOMSG (42) == errno (22)
>>>>    # inconsistent_attr: Test terminated by assertion
>>>>    #          FAIL  global.inconsistent_attr
>>>> not ok 1 global.inconsistent_attr
>>>>
>>>> LCOV - code coverage report:
>>>>               Hit  Total  Coverage
>>>> Lines:      952  1010    94.3 %
>>>> Functions:  79   82      96.3 %
>>>>
>>>> Previous versions:
>>>> v5:
>>>> https://lore.kernel.org/linux-security-module/20220516152038.39594-1-konstantin.meskhidze@huawei.com
>>>> v4:
>>>> https://lore.kernel.org/linux-security-module/20220309134459.6448-1-konstantin.meskhidze@huawei.com/
>>>> v3:
>>>> https://lore.kernel.org/linux-security-module/20220124080215.265538-1-konstantin.meskhidze@huawei.com/
>>>> v2:
>>>> https://lore.kernel.org/linux-security-module/20211228115212.703084-1-konstantin.meskhidze@huawei.com/
>>>> v1:
>>>> https://lore.kernel.org/linux-security-module/20211210072123.386713-1-konstantin.meskhidze@huawei.com/
>>>>
>>>> Konstantin Meskhidze (17):
>>>>     landlock: renames access mask
>>>>     landlock: refactors landlock_find/insert_rule
>>>>     landlock: refactors merge and inherit functions
>>>>     landlock: moves helper functions
>>>>     landlock: refactors helper functions
>>>>     landlock: refactors landlock_add_rule syscall
>>>>     landlock: user space API network support
>>>>     landlock: adds support network rules
>>>>     landlock: implements TCP network hooks
>>>>     seltests/landlock: moves helper function
>>>>     seltests/landlock: adds tests for bind() hooks
>>>>     seltests/landlock: adds tests for connect() hooks
>>>>     seltests/landlock: adds AF_UNSPEC family test
>>>>     seltests/landlock: adds rules overlapping test
>>>>     seltests/landlock: adds ruleset expanding test
>>>>     seltests/landlock: adds invalid input data test
>>>>     samples/landlock: adds network demo
>>>>
>>>>    include/uapi/linux/landlock.h               |  49 ++
>>>>    samples/landlock/sandboxer.c                | 118 ++-
>>>>    security/landlock/Kconfig                   |   1 +
>>>>    security/landlock/Makefile                  |   2 +
>>>>    security/landlock/fs.c                      | 162 +---
>>>>    security/landlock/limits.h                  |   8 +-
>>>>    security/landlock/net.c                     | 155 ++++
>>>>    security/landlock/net.h                     |  26 +
>>>>    security/landlock/ruleset.c                 | 448 +++++++++--
>>>>    security/landlock/ruleset.h                 |  91 ++-
>>>>    security/landlock/setup.c                   |   2 +
>>>>    security/landlock/syscalls.c                | 168 +++--
>>>>    tools/testing/selftests/landlock/common.h   |  10 +
>>>>    tools/testing/selftests/landlock/config     |   4 +
>>>>    tools/testing/selftests/landlock/fs_test.c  |  10 -
>>>>    tools/testing/selftests/landlock/net_test.c | 774 ++++++++++++++++++++
>>>>    16 files changed, 1737 insertions(+), 291 deletions(-)
>>>>    create mode 100644 security/landlock/net.c
>>>>    create mode 100644 security/landlock/net.h
>>>>    create mode 100644 tools/testing/selftests/landlock/net_test.c
>>>>
>>>> -- 
>>>> 2.25.1
>>>>
>>>
>>> I did a thorough review of all the code. I found that the main issue
>>> with this version is that we stick to the layers limit whereas it is
>>> only relevant for filesystem hierarchies. You'll find in the following
>>> patch miscellaneous fixes and improvement, with some TODOs to get rid of
>>> this layer limit. We'll need a test to check that too. You'll need to
>>> integrate this diff into your patches though.
>> 
>> You can find the related patch here:
>> https://git.kernel.org/mic/c/8f4104b3dc59e7f110c9b83cdf034d010a2d006f
> 
> Thinking more about the layer limit, I think you should keep your
> changes and continue using ruleset.access_masks . Indeed, while it might
> be a good thing to not be limited by the 16 layers, it would be an issue
> with the upcoming audit feature, i.e. being able to point to the ruleset
> responsible for a denied access. Here is a new patch (on top of the
> other) to improve the current code:
> https://git.kernel.org/mic/c/7d6cf40a6f81adf607ad3cc17aaa11e256beeea4
> 
   Thank you for help here. I have been refactoring my commits with your 
updates. Sorry for delay, had to deal with another issues.
> 
> * Add a new access_masks_t for struct ruleset.  This is now u16 but
>     would soon need to change to u32 (because of the upcoming
>     LANDLOCK_ACCESS_FS_TRUNCATE).  Set back rules' access_masks_t to u16,
>     it should be enough for a while.
> * Rename LANDLOCK_MASK_SHIFT_NET to LANDLOCK_SHIFT_ACCESS_NET and use
>     LANDLOCK_NUM_ACCESS_FS as value.
> * Rename landlock_set_*_access_mask() to landlock_add_*_access_mask()
>     because it OR values.
> * Make landlock_add_*_access_mask() more resilient incorrect values.
> * Rename some variable to make them more consistent with the rest of the
>     code.
> * Add and update kernel documentation.
> * Remove unused code.
> ---
>    security/landlock/limits.h  |   8 +-
>    security/landlock/ruleset.c |  31 +++-----
>    security/landlock/ruleset.h | 150 +++++++++++++++++++++---------------
>    3 files changed, 105 insertions(+), 84 deletions(-)
> 
> diff --git a/security/landlock/limits.h b/security/landlock/limits.h
> index 660335258466..e50a12c1b797 100644
> --- a/security/landlock/limits.h
> +++ b/security/landlock/limits.h
> @@ -21,15 +21,13 @@
>    #define LANDLOCK_LAST_ACCESS_FS		LANDLOCK_ACCESS_FS_REFER
>    #define LANDLOCK_MASK_ACCESS_FS		((LANDLOCK_LAST_ACCESS_FS << 1) - 1)
>    #define LANDLOCK_NUM_ACCESS_FS		__const_hweight64(LANDLOCK_MASK_ACCESS_FS)
> +#define LANDLOCK_SHIFT_ACCESS_FS	0
>    
>    #define LANDLOCK_LAST_ACCESS_NET	LANDLOCK_ACCESS_NET_CONNECT_TCP
>    #define LANDLOCK_MASK_ACCESS_NET	((LANDLOCK_LAST_ACCESS_NET << 1) - 1)
>    #define LANDLOCK_NUM_ACCESS_NET		__const_hweight64(LANDLOCK_MASK_ACCESS_NET)
> -// TODO: LANDLOCK_MASK_SHIFT_NET will not be useful with the new
> -// ruleset->net_access_mask
> -#define LANDLOCK_MASK_SHIFT_NET		16
> -
> -#define LANDLOCK_RULE_TYPE_NUM		LANDLOCK_RULE_NET_SERVICE
> +#define LANDLOCK_SHIFT_ACCESS_NET	LANDLOCK_NUM_ACCESS_FS
>    
>    /* clang-format on */
> +
>    #endif /* _SECURITY_LANDLOCK_LIMITS_H */
> diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
> index e7555b16069a..1b3433ea4c61 100644
> --- a/security/landlock/ruleset.c
> +++ b/security/landlock/ruleset.c
> @@ -47,21 +47,21 @@ static struct landlock_ruleset *create_ruleset(const u32 num_layers)
>    }
>    
>    struct landlock_ruleset *
> -landlock_create_ruleset(const access_mask_t access_mask_fs,
> -			const access_mask_t access_mask_net)
> +landlock_create_ruleset(const access_mask_t fs_access_mask,
> +			const access_mask_t net_access_mask)
>    {
>    	struct landlock_ruleset *new_ruleset;
>    
>    	/* Informs about useless ruleset. */
> -	if (!access_mask_fs && !access_mask_net)
> +	if (!fs_access_mask && !net_access_mask)
>    		return ERR_PTR(-ENOMSG);
>    	new_ruleset = create_ruleset(1);
>    	if (IS_ERR(new_ruleset))
>    		return new_ruleset;
> -	if (access_mask_fs)
> -		landlock_set_fs_access_mask(new_ruleset, access_mask_fs, 0);
> -	if (access_mask_net)
> -		landlock_set_net_access_mask(new_ruleset, access_mask_net, 0);
> +	if (fs_access_mask)
> +		landlock_add_fs_access_mask(new_ruleset, fs_access_mask, 0);
> +	if (net_access_mask)
> +		landlock_add_net_access_mask(new_ruleset, net_access_mask, 0);
>    	return new_ruleset;
>    }
>    
> @@ -160,13 +160,14 @@ static void build_check_ruleset(void)
>    		.num_rules = ~0,
>    		.num_layers = ~0,
>    	};
> -	typeof(ruleset.access_masks[0]) fs_access_mask = ~0;
> -	typeof(ruleset.access_masks[0]) net_access_mask = ~0;
> +	typeof(ruleset.access_masks[0]) access_masks = ~0;
>    
>    	BUILD_BUG_ON(ruleset.num_rules < LANDLOCK_MAX_NUM_RULES);
>    	BUILD_BUG_ON(ruleset.num_layers < LANDLOCK_MAX_NUM_LAYERS);
> -	BUILD_BUG_ON(fs_access_mask < LANDLOCK_MASK_ACCESS_FS);
> -	BUILD_BUG_ON(net_access_mask < LANDLOCK_MASK_ACCESS_NET);
> +	BUILD_BUG_ON(access_masks <
> +		     (LANDLOCK_MASK_ACCESS_FS << LANDLOCK_SHIFT_ACCESS_FS) +
> +			     (LANDLOCK_MASK_ACCESS_NET
> +			      << LANDLOCK_SHIFT_ACCESS_NET));
>    }
>    
>    /**
> @@ -250,8 +251,6 @@ static int insert_rule(struct landlock_ruleset *const ruleset,
>    		 * Intersects access rights when it is a merge between a
>    		 * ruleset and a domain.
>    		 */
> -		// TODO: Don't create a new rule but AND accesses (of the first
> -		// and only layer) if !is_object_pointer(id.type)
>    		new_rule = create_rule(id, &this->layers, this->num_layers,
>    				       &(*layers)[0]);
>    		if (IS_ERR(new_rule))
> @@ -332,7 +331,6 @@ static int merge_tree(struct landlock_ruleset *const dst,
>    	rbtree_postorder_for_each_entry_safe(walker_rule, next_rule, src_root,
>    					     node) {
>    		struct landlock_layer layers[] = { {
> -			// TODO: Set level to 1 if !is_object_pointer(key_type).
>    			.level = dst->num_layers,
>    		} };
>    		const struct landlock_id id = {
> @@ -531,7 +529,6 @@ landlock_merge_ruleset(struct landlock_ruleset *const parent,
>    		if (parent->num_layers >= LANDLOCK_MAX_NUM_LAYERS)
>    			return ERR_PTR(-E2BIG);
>    		num_layers = parent->num_layers + 1;
> -		// TODO: Don't increment num_layers if RB_EMPTY_ROOT(&ruleset->root_inode).
>    	} else {
>    		num_layers = 1;
>    	}
> @@ -698,10 +695,6 @@ access_mask_t init_layer_masks(const struct landlock_ruleset *const domain,
>    
>    	switch (key_type) {
>    	case LANDLOCK_KEY_INODE:
> -		// XXX: landlock_get_fs_access_mask() should not be removed
> -		// once we use ruleset->net_access_mask, and we can then
> -		// replace the @key_type argument with num_access to make the
> -		// code simpler.
>    		get_access_mask = landlock_get_fs_access_mask;
>    		num_access = LANDLOCK_NUM_ACCESS_FS;
>    		break;
> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
> index 59229be378d6..669de66094ed 100644
> --- a/security/landlock/ruleset.h
> +++ b/security/landlock/ruleset.h
> @@ -19,8 +19,8 @@
>    #include "limits.h"
>    #include "object.h"
>    
> -// TODO: get back to u16 thanks to ruleset->net_access_mask
> -typedef u32 access_mask_t;
> +/* Rule access mask. */
> +typedef u16 access_mask_t;
>    /* Makes sure all filesystem access rights can be stored. */
>    static_assert(BITS_PER_TYPE(access_mask_t) >= LANDLOCK_NUM_ACCESS_FS);
>    /* Makes sure all network access rights can be stored. */
> @@ -28,6 +28,12 @@ static_assert(BITS_PER_TYPE(access_mask_t) >= LANDLOCK_NUM_ACCESS_NET);
>    /* Makes sure for_each_set_bit() and for_each_clear_bit() calls are OK. */
>    static_assert(sizeof(unsigned long) >= sizeof(access_mask_t));
>    
> +/* Ruleset access masks. */
> +typedef u16 access_masks_t;
> +/* Makes sure all ruleset access rights can be stored. */
> +static_assert(BITS_PER_TYPE(access_masks_t) >=
> +	      LANDLOCK_NUM_ACCESS_FS + LANDLOCK_NUM_ACCESS_NET);
> +
>    typedef u16 layer_mask_t;
>    /* Makes sure all layers can be checked. */
>    static_assert(BITS_PER_TYPE(layer_mask_t) >= LANDLOCK_MAX_NUM_LAYERS);
> @@ -47,16 +53,33 @@ struct landlock_layer {
>    	access_mask_t access;
>    };
>    
> +/**
> + * union landlock_key - Key of a ruleset's red-black tree
> + */
>    union landlock_key {
>    	struct landlock_object *object;
>    	uintptr_t data;
>    };
>    
> +/**
> + * enum landlock_key_type - Type of &union landlock_key
> + */
>    enum landlock_key_type {
> +	/**
> +	 * @LANDLOCK_KEY_INODE: Type of &landlock_ruleset.root_inode's node
> +	 * keys.
> +	 */
>    	LANDLOCK_KEY_INODE = 1,
> +	/**
> +	 * @LANDLOCK_KEY_NET_PORT: Type of &landlock_ruleset.root_net_port's
> +	 * node keys.
> +	 */
>    	LANDLOCK_KEY_NET_PORT = 2,
>    };
>    
> +/**
> + * struct landlock_id - Unique rule identifier for a ruleset
> + */
>    struct landlock_id {
>    	union landlock_key key;
>    	const enum landlock_key_type type;
> @@ -113,15 +136,17 @@ struct landlock_hierarchy {
>     */
>    struct landlock_ruleset {
>    	/**
> -	 * @root: Root of a red-black tree containing &struct landlock_rule
> -	 * nodes.  Once a ruleset is tied to a process (i.e. as a domain), this
> -	 * tree is immutable until @usage reaches zero.
> +	 * @root_inode: Root of a red-black tree containing &struct
> +	 * landlock_rule nodes with inode object.  Once a ruleset is tied to a
> +	 * process (i.e. as a domain), this tree is immutable until @usage
> +	 * reaches zero.
>    	 */
>    	struct rb_root root_inode;
>    	/**
> -	 * @root_net_port: Root of a red-black tree containing object nodes
> -	 * for network port. Once a ruleset is tied to a process (i.e. as a domain),
> -	 * this tree is immutable until @usage reaches zero.
> +	 * @root_net_port: Root of a red-black tree containing &struct
> +	 * landlock_rule nodes with network port. Once a ruleset is tied to a
> +	 * process (i.e. as a domain), this tree is immutable until @usage
> +	 * reaches zero.
>    	 */
>    	struct rb_root root_net_port;
>    	/**
> @@ -162,32 +187,25 @@ struct landlock_ruleset {
>    			 */
>    			u32 num_layers;
>    			/**
> -			 * TODO: net_access_mask: Contains the subset of network
> -			 * actions that are restricted by a ruleset.
> -			 */
> -			access_mask_t net_access_mask;
> -			/**
> -			 * @access_masks: Contains the subset of filesystem
> -			 * actions that are restricted by a ruleset.  A domain
> -			 * saves all layers of merged rulesets in a stack
> -			 * (FAM), starting from the first layer to the last
> -			 * one.  These layers are used when merging rulesets,
> -			 * for user space backward compatibility (i.e.
> -			 * future-proof), and to properly handle merged
> +			 * @access_masks: Contains the subset of filesystem and
> +			 * network actions that are restricted by a ruleset.
> +			 * A domain saves all layers of merged rulesets in a
> +			 * stack (FAM), starting from the first layer to the
> +			 * last one.  These layers are used when merging
> +			 * rulesets, for user space backward compatibility
> +			 * (i.e. future-proof), and to properly handle merged
>    			 * rulesets without overlapping access rights.  These
>    			 * layers are set once and never changed for the
>    			 * lifetime of the ruleset.
>    			 */
> -			// TODO: rename (back) to fs_access_mask because layers
> -			// are only useful for file hierarchies.
> -			access_mask_t access_masks[];
> +			access_masks_t access_masks[];
>    		};
>    	};
>    };
>    
>    struct landlock_ruleset *
> -landlock_create_ruleset(const access_mask_t access_mask_fs,
> -			const access_mask_t access_mask_net);
> +landlock_create_ruleset(const access_mask_t fs_access_mask,
> +			const access_mask_t net_access_mask);
>    
>    void landlock_put_ruleset(struct landlock_ruleset *const ruleset);
>    void landlock_put_ruleset_deferred(struct landlock_ruleset *const ruleset);
> @@ -210,41 +228,7 @@ static inline void landlock_get_ruleset(struct landlock_ruleset *const ruleset)
>    		refcount_inc(&ruleset->usage);
>    }
>    
> -// TODO: These helpers should not be required thanks to the new ruleset->net_access_mask.
> -/* A helper function to set a filesystem mask. */
> -static inline void
> -landlock_set_fs_access_mask(struct landlock_ruleset *ruleset,
> -			    const access_mask_t access_mask_fs, u16 mask_level)
> -{
> -	ruleset->access_masks[mask_level] = access_mask_fs;
> -}
> -
> -/* A helper function to get a filesystem mask. */
> -static inline u32
> -landlock_get_fs_access_mask(const struct landlock_ruleset *ruleset,
> -			    u16 mask_level)
> -{
> -	return (ruleset->access_masks[mask_level] & LANDLOCK_MASK_ACCESS_FS);
> -}
> -
> -/* A helper function to set a network mask. */
> -static inline void
> -landlock_set_net_access_mask(struct landlock_ruleset *ruleset,
> -			     const access_mask_t access_mask_net,
> -			     u16 mask_level)
> -{
> -	ruleset->access_masks[mask_level] |=
> -		(access_mask_net << LANDLOCK_MASK_SHIFT_NET);
> -}
> -
> -/* A helper function to get a network mask. */
> -static inline u32
> -landlock_get_net_access_mask(const struct landlock_ruleset *ruleset,
> -			     u16 mask_level)
> -{
> -	return (ruleset->access_masks[mask_level] >> LANDLOCK_MASK_SHIFT_NET);
> -}
> -
> +// TODO: Remove if only relevant for fs.c
>    access_mask_t get_handled_accesses(const struct landlock_ruleset *const domain,
>    				   const u16 rule_type, const u16 num_access);
>    
> @@ -258,4 +242,50 @@ access_mask_t init_layer_masks(const struct landlock_ruleset *const domain,
>    			       layer_mask_t (*const layer_masks)[],
>    			       const enum landlock_key_type key_type);
>    
> +static inline void
> +landlock_add_fs_access_mask(struct landlock_ruleset *const ruleset,
> +			    const access_mask_t fs_access_mask,
> +			    const u16 layer_level)
> +{
> +	access_mask_t fs_mask = fs_access_mask & LANDLOCK_MASK_ACCESS_FS;
> +
> +	/* Should already be checked in sys_landlock_create_ruleset(). */
> +	WARN_ON_ONCE(fs_access_mask != fs_mask);
> +	// TODO: Add tests to check "|=" and not "="
> +	ruleset->access_masks[layer_level] |=
> +		(fs_mask << LANDLOCK_SHIFT_ACCESS_FS);
> +}
> +
> +static inline void
> +landlock_add_net_access_mask(struct landlock_ruleset *const ruleset,
> +			     const access_mask_t net_access_mask,
> +			     const u16 layer_level)
> +{
> +	access_mask_t net_mask = net_access_mask & LANDLOCK_MASK_ACCESS_NET;
> +
> +	/* Should already be checked in sys_landlock_create_ruleset(). */
> +	WARN_ON_ONCE(net_access_mask != net_mask);
> +	// TODO: Add tests to check "|=" and not "="
> +	ruleset->access_masks[layer_level] |=
> +		(net_mask << LANDLOCK_SHIFT_ACCESS_NET);
> +}
> +
> +static inline access_mask_t
> +landlock_get_fs_access_mask(const struct landlock_ruleset *const ruleset,
> +			    const u16 layer_level)
> +{
> +	return (ruleset->access_masks[layer_level] >>
> +		LANDLOCK_SHIFT_ACCESS_FS) &
> +	       LANDLOCK_MASK_ACCESS_FS;
> +}
> +
> +static inline access_mask_t
> +landlock_get_net_access_mask(const struct landlock_ruleset *const ruleset,
> +			     const u16 layer_level)
> +{
> +	return (ruleset->access_masks[layer_level] >>
> +		LANDLOCK_SHIFT_ACCESS_NET) &
> +	       LANDLOCK_MASK_ACCESS_NET;
> +}
> +
>    #endif /* _SECURITY_LANDLOCK_RULESET_H */
> .
