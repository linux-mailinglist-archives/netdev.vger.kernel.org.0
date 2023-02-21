Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32F5E69E6D9
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 19:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231540AbjBUSH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 13:07:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbjBUSHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 13:07:22 -0500
Received: from smtp-1909.mail.infomaniak.ch (smtp-1909.mail.infomaniak.ch [IPv6:2001:1600:3:17::1909])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDEAB30188;
        Tue, 21 Feb 2023 10:07:19 -0800 (PST)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4PLnLZ4wkwzMrDZH;
        Tue, 21 Feb 2023 19:07:18 +0100 (CET)
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4PLnLY70qyz1c9S;
        Tue, 21 Feb 2023 19:07:17 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1677002838;
        bh=zXJIin2CHxFo9lK7CQ2jXmL3VUqX/fQEaz+z1MwBk38=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ogncoP81p7OvYpG5VwzasszV13hStgg5LIhSdMh6BP3WvCelY5iUubUU/7hLnSb0s
         U/iWUR0WjR7u/cupuwtt0zt9IuJXMQo/2j3ye8+f2YJffmsB/AxjSQr0mdLdLoRu22
         AvUkSaR2g7h1xg8nLUsx8EeOHxL20qPN77s6uZ7c=
Message-ID: <3e9ef23b-c599-6ba1-1d18-a615f53b6e7b@digikod.net>
Date:   Tue, 21 Feb 2023 19:07:17 +0100
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v9 06/12] landlock: Refactor _unmask_layers() and
 _init_layer_masks()
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
References: <20230116085818.165539-1-konstantin.meskhidze@huawei.com>
 <20230116085818.165539-7-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <20230116085818.165539-7-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's not "_unmask_layers() and _init_layer_masks()": there is no "_" 
prefixes.
Using "landlock_unmask_layers()" in the subject would be too long, so 
you can replace it with "landlock: Refactor layer helpers".
For consistency, you can change the previous patch's subject to 
"landlock: Move and rename layer helpers"

Anyway, please send a new patch series. Most of the kernel code should 
be good and I could then push it to -next for testing while reviewing 
the last parts.


On 16/01/2023 09:58, Konstantin Meskhidze wrote:
> Add new key_type argument to the landlock_init_layer_masks() helper.
> Add a masks_array_size argument to the landlock_unmask_layers() helper.
> These modifications support implementing new rule types in the next
> Landlock versions.
> 
> Signed-off-by: Mickaël Salaün <mic@digikod.net>
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
> 
> Changes since v8:
> * None.
> 
> Changes since v7:
> * Refactors commit message, adds a co-developer.
> * Minor fixes.
> 
> Changes since v6:
> * Removes masks_size attribute from init_layer_masks().
> * Refactors init_layer_masks() with new landlock_key_type.
> 
> Changes since v5:
> * Splits commit.
> * Formats code with clang-format-14.
> 
> Changes since v4:
> * Refactors init_layer_masks(), get_handled_accesses()
> and unmask_layers() functions to support multiple rule types.
> * Refactors landlock_get_fs_access_mask() function with
> LANDLOCK_MASK_ACCESS_FS mask.
> 
> Changes since v3:
> * Splits commit.
> * Refactors landlock_unmask_layers functions.
> 
> ---
>   security/landlock/fs.c      | 43 ++++++++++++++++--------------
>   security/landlock/ruleset.c | 52 ++++++++++++++++++++++++++-----------
>   security/landlock/ruleset.h | 17 ++++++------
>   3 files changed, 70 insertions(+), 42 deletions(-)
> 
> diff --git a/security/landlock/fs.c b/security/landlock/fs.c
> index 73a7399f93ba..a73dbd3f9ddb 100644
> --- a/security/landlock/fs.c
> +++ b/security/landlock/fs.c
> @@ -441,20 +441,22 @@ static bool is_access_to_paths_allowed(
>   	}
>   
>   	if (unlikely(dentry_child1)) {
> -		landlock_unmask_layers(find_rule(domain, dentry_child1),
> -				       landlock_init_layer_masks(
> -					       domain, LANDLOCK_MASK_ACCESS_FS,
> -					       &_layer_masks_child1),
> -				       &_layer_masks_child1);
> +		landlock_unmask_layers(
> +			find_rule(domain, dentry_child1),
> +			landlock_init_layer_masks(
> +				domain, LANDLOCK_MASK_ACCESS_FS,
> +				&_layer_masks_child1, LANDLOCK_KEY_INODE),
> +			&_layer_masks_child1, ARRAY_SIZE(_layer_masks_child1));
>   		layer_masks_child1 = &_layer_masks_child1;
>   		child1_is_directory = d_is_dir(dentry_child1);
>   	}
>   	if (unlikely(dentry_child2)) {
> -		landlock_unmask_layers(find_rule(domain, dentry_child2),
> -				       landlock_init_layer_masks(
> -					       domain, LANDLOCK_MASK_ACCESS_FS,
> -					       &_layer_masks_child2),
> -				       &_layer_masks_child2);
> +		landlock_unmask_layers(
> +			find_rule(domain, dentry_child2),
> +			landlock_init_layer_masks(
> +				domain, LANDLOCK_MASK_ACCESS_FS,
> +				&_layer_masks_child2, LANDLOCK_KEY_INODE),
> +			&_layer_masks_child2, ARRAY_SIZE(_layer_masks_child2));
>   		layer_masks_child2 = &_layer_masks_child2;
>   		child2_is_directory = d_is_dir(dentry_child2);
>   	}
> @@ -507,14 +509,15 @@ static bool is_access_to_paths_allowed(
>   
>   		rule = find_rule(domain, walker_path.dentry);
>   		allowed_parent1 = landlock_unmask_layers(
> -			rule, access_masked_parent1, layer_masks_parent1);
> +			rule, access_masked_parent1, layer_masks_parent1,
> +			ARRAY_SIZE(*layer_masks_parent1));
>   		allowed_parent2 = landlock_unmask_layers(
> -			rule, access_masked_parent2, layer_masks_parent2);
> +			rule, access_masked_parent2, layer_masks_parent2,
> +			ARRAY_SIZE(*layer_masks_parent2));
>   
>   		/* Stops when a rule from each layer grants access. */
>   		if (allowed_parent1 && allowed_parent2)
>   			break;
> -
>   jump_up:
>   		if (walker_path.dentry == walker_path.mnt->mnt_root) {
>   			if (follow_up(&walker_path)) {
> @@ -553,8 +556,8 @@ static int check_access_path(const struct landlock_ruleset *const domain,
>   {
>   	layer_mask_t layer_masks[LANDLOCK_NUM_ACCESS_FS] = {};
>   
> -	access_request =
> -		landlock_init_layer_masks(domain, access_request, &layer_masks);
> +	access_request = landlock_init_layer_masks(
> +		domain, access_request, &layer_masks, LANDLOCK_KEY_INODE);
>   	if (is_access_to_paths_allowed(domain, path, access_request,
>   				       &layer_masks, NULL, 0, NULL, NULL))
>   		return 0;
> @@ -640,7 +643,8 @@ static bool collect_domain_accesses(
>   		return true;
>   
>   	access_dom = landlock_init_layer_masks(domain, LANDLOCK_MASK_ACCESS_FS,
> -					       layer_masks_dom);
> +					       layer_masks_dom,
> +					       LANDLOCK_KEY_INODE);
>   
>   	dget(dir);
>   	while (true) {
> @@ -648,7 +652,8 @@ static bool collect_domain_accesses(
>   
>   		/* Gets all layers allowing all domain accesses. */
>   		if (landlock_unmask_layers(find_rule(domain, dir), access_dom,
> -					   layer_masks_dom)) {
> +					   layer_masks_dom,
> +					   ARRAY_SIZE(*layer_masks_dom))) {
>   			/*
>   			 * Stops when all handled accesses are allowed by at
>   			 * least one rule in each layer.
> @@ -763,7 +768,7 @@ static int current_check_refer_path(struct dentry *const old_dentry,
>   		 */
>   		access_request_parent1 = landlock_init_layer_masks(
>   			dom, access_request_parent1 | access_request_parent2,
> -			&layer_masks_parent1);
> +			&layer_masks_parent1, LANDLOCK_KEY_INODE);
>   		if (is_access_to_paths_allowed(
>   			    dom, new_dir, access_request_parent1,
>   			    &layer_masks_parent1, NULL, 0, NULL, NULL))
> @@ -1139,7 +1144,7 @@ static int hook_file_open(struct file *const file)
>   	if (is_access_to_paths_allowed(
>   		    dom, &file->f_path,
>   		    landlock_init_layer_masks(dom, full_access_request,
> -					      &layer_masks),
> +					      &layer_masks, LANDLOCK_KEY_INODE),
>   		    &layer_masks, NULL, 0, NULL, NULL)) {
>   		allowed_access = full_access_request;
>   	} else {
> diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
> index 22590cac3d56..9748b54b42fe 100644
> --- a/security/landlock/ruleset.c
> +++ b/security/landlock/ruleset.c
> @@ -576,14 +576,15 @@ landlock_find_rule(const struct landlock_ruleset *const ruleset,
>   /*
>    * @layer_masks is read and may be updated according to the access request and
>    * the matching rule.
> + * @masks_array_size must be equal to ARRAY_SIZE(*layer_masks).
>    *
>    * Returns true if the request is allowed (i.e. relevant layer masks for the
>    * request are empty).
>    */
> -bool landlock_unmask_layers(
> -	const struct landlock_rule *const rule,
> -	const access_mask_t access_request,
> -	layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS])
> +bool landlock_unmask_layers(const struct landlock_rule *const rule,
> +			    const access_mask_t access_request,
> +			    layer_mask_t (*const layer_masks)[],
> +			    const size_t masks_array_size)
>   {
>   	size_t layer_level;
>   
> @@ -615,8 +616,7 @@ bool landlock_unmask_layers(
>   		 * requested access.
>   		 */
>   		is_empty = true;
> -		for_each_set_bit(access_bit, &access_req,
> -				 ARRAY_SIZE(*layer_masks)) {
> +		for_each_set_bit(access_bit, &access_req, masks_array_size) {
>   			if (layer->access & BIT_ULL(access_bit))
>   				(*layer_masks)[access_bit] &= ~layer_bit;
>   			is_empty = is_empty && !(*layer_masks)[access_bit];
> @@ -627,6 +627,10 @@ bool landlock_unmask_layers(
>   	return false;
>   }
>   
> +typedef access_mask_t
> +get_access_mask_t(const struct landlock_ruleset *const ruleset,
> +		  const u16 layer_level);
> +
>   /*
>    * init_layer_masks - Initialize layer masks from an access request
>    *
> @@ -636,19 +640,34 @@ bool landlock_unmask_layers(
>    * @domain: The domain that defines the current restrictions.
>    * @access_request: The requested access rights to check.
>    * @layer_masks: The layer masks to populate.
> + * @key_type: The key type to switch between access masks of different types.
>    *
>    * Returns: An access mask where each access right bit is set which is handled
>    * in any of the active layers in @domain.
>    */
> -access_mask_t landlock_init_layer_masks(
> -	const struct landlock_ruleset *const domain,
> -	const access_mask_t access_request,
> -	layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS])
> +access_mask_t
> +landlock_init_layer_masks(const struct landlock_ruleset *const domain,
> +			  const access_mask_t access_request,
> +			  layer_mask_t (*const layer_masks)[],
> +			  const enum landlock_key_type key_type)
>   {
>   	access_mask_t handled_accesses = 0;
> -	size_t layer_level;
> +	size_t layer_level, num_access;
> +	get_access_mask_t *get_access_mask;
> +
> +	switch (key_type) {
> +	case LANDLOCK_KEY_INODE:
> +		get_access_mask = landlock_get_fs_access_mask;
> +		num_access = LANDLOCK_NUM_ACCESS_FS;
> +		break;
> +	default:
> +		WARN_ON_ONCE(1);
> +		return 0;
> +	}
> +
> +	memset(layer_masks, 0,
> +	       array_size(sizeof((*layer_masks)[0]), num_access));
>   
> -	memset(layer_masks, 0, sizeof(*layer_masks));
>   	/* An empty access request can happen because of O_WRONLY | O_RDWR. */
>   	if (!access_request)
>   		return 0;
> @@ -658,10 +677,13 @@ access_mask_t landlock_init_layer_masks(
>   		const unsigned long access_req = access_request;
>   		unsigned long access_bit;
>   
> -		for_each_set_bit(access_bit, &access_req,
> -				 ARRAY_SIZE(*layer_masks)) {
> +		for_each_set_bit(access_bit, &access_req, num_access) {
> +			/*
> +			 * Artificially handles all initially denied by default
> +			 * access rights.
> +			 */
>   			if (BIT_ULL(access_bit) &
> -			    landlock_get_fs_access_mask(domain, layer_level)) {
> +			    get_access_mask(domain, layer_level)) {
>   				(*layer_masks)[access_bit] |=
>   					BIT_ULL(layer_level);
>   				handled_accesses |= BIT_ULL(access_bit);
> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
> index 60a3c4d4d961..77349764e111 100644
> --- a/security/landlock/ruleset.h
> +++ b/security/landlock/ruleset.h
> @@ -266,14 +266,15 @@ landlock_get_fs_access_mask(const struct landlock_ruleset *const ruleset,
>   	return landlock_get_raw_fs_access_mask(ruleset, layer_level) |
>   	       ACCESS_FS_INITIALLY_DENIED;
>   }
> -bool landlock_unmask_layers(
> -	const struct landlock_rule *const rule,
> -	const access_mask_t access_request,
> -	layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS]);
> +bool landlock_unmask_layers(const struct landlock_rule *const rule,
> +			    const access_mask_t access_request,
> +			    layer_mask_t (*const layer_masks)[],
> +			    const size_t masks_array_size);
>   
> -access_mask_t landlock_init_layer_masks(
> -	const struct landlock_ruleset *const domain,
> -	const access_mask_t access_request,
> -	layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS]);
> +access_mask_t
> +landlock_init_layer_masks(const struct landlock_ruleset *const domain,
> +			  const access_mask_t access_request,
> +			  layer_mask_t (*const layer_masks)[],
> +			  const enum landlock_key_type key_type);
>   
>   #endif /* _SECURITY_LANDLOCK_RULESET_H */
