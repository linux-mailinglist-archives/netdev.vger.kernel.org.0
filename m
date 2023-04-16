Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44AFC6E3A21
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 18:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjDPQJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 12:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjDPQJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 12:09:33 -0400
Received: from smtp-8fab.mail.infomaniak.ch (smtp-8fab.mail.infomaniak.ch [IPv6:2001:1600:3:17::8fab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCEAF1FF5
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 09:09:31 -0700 (PDT)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4Pzw9k06M4zMqdXK;
        Sun, 16 Apr 2023 18:09:30 +0200 (CEST)
Received: from unknown by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4Pzw9g5qf9zMppDP;
        Sun, 16 Apr 2023 18:09:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1681661369;
        bh=bl090cWcqg/KPhSiPqAXrLgK7zsN8bX1R+IXbcvSQ8M=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=1A6VUFJyqE3tONpoLZfrgNcOW5ZbFPthbrHVLOobr0q8XjDD+7SSnqy1HpTVjSAww
         AV5ry4AjXigem45Pq1tgOK7pR5rI3x0uHwGQNDG5YeYpsmrvPLUMZ7mBhAaBprvkLb
         lrcFpbVTDQDqyQWj3Kr0LELRuM/q40h6x3/ZULeI=
Message-ID: <72ef81d8-b7a0-de1e-83b6-1bfe7028ad25@digikod.net>
Date:   Sun, 16 Apr 2023 18:09:34 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v10 03/13] landlock: Remove unnecessary inlining
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
References: <20230323085226.1432550-1-konstantin.meskhidze@huawei.com>
 <20230323085226.1432550-4-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <20230323085226.1432550-4-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unfortunately this patch could not be easily backported because it 
changes too much as the same time, and it would then be an issue for 
patches on top of it that would need to be backported. Please remove 
this patch for the next series, but keep the required changes for the 
function that are modified by the following patches, i.e. 
opportunistically remove inline function when changing their signature 
(which should be a subset of the same patch for v9). I'll take care of 
doing the remaining clean up.


On 23/03/2023 09:52, Konstantin Meskhidze wrote:
> Remove all "inline" keywords in all .c files. This should be simple
> for the compiler to inline them automatically, and it makes the
> code cleaner.
> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
> 
> Changes since v9:
> * Splits commit.
> 
> ---
>   security/landlock/fs.c      | 26 +++++++++++++-------------
>   security/landlock/ruleset.c |  2 +-
>   2 files changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/security/landlock/fs.c b/security/landlock/fs.c
> index 05a339bf2a7c..b5fa6f56665f 100644
> --- a/security/landlock/fs.c
> +++ b/security/landlock/fs.c
> @@ -191,7 +191,7 @@ int landlock_append_fs_rule(struct landlock_ruleset *const ruleset,
>    *
>    * Returns NULL if no rule is found or if @dentry is negative.
>    */
> -static inline const struct landlock_rule *
> +static const struct landlock_rule *
>   find_rule(const struct landlock_ruleset *const domain,
>   	  const struct dentry *const dentry)
>   {
> @@ -217,7 +217,7 @@ find_rule(const struct landlock_ruleset *const domain,
>    * Returns true if the request is allowed (i.e. relevant layer masks for the
>    * request are empty).
>    */
> -static inline bool
> +static bool
>   unmask_layers(const struct landlock_rule *const rule,
>   	      const access_mask_t access_request,
>   	      layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS])
> @@ -269,7 +269,7 @@ unmask_layers(const struct landlock_rule *const rule,
>    * sockfs, pipefs), but can still be reachable through
>    * /proc/<pid>/fd/<file-descriptor>
>    */
> -static inline bool is_nouser_or_private(const struct dentry *dentry)
> +static bool is_nouser_or_private(const struct dentry *dentry)
>   {
>   	return (dentry->d_sb->s_flags & SB_NOUSER) ||
>   	       (d_is_positive(dentry) &&
> @@ -301,7 +301,7 @@ get_raw_handled_fs_accesses(const struct landlock_ruleset *const domain)
>    * Returns: An access mask where each access right bit is set which is handled
>    * in any of the active layers in @domain.
>    */
> -static inline access_mask_t
> +static access_mask_t
>   init_layer_masks(const struct landlock_ruleset *const domain,
>   		 const access_mask_t access_request,
>   		 layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS])
> @@ -357,7 +357,7 @@ static const struct landlock_ruleset *get_current_fs_domain(void)
>    *
>    * @layer_masks_child2: Optional child masks.
>    */
> -static inline bool no_more_access(
> +static bool no_more_access(
>   	const layer_mask_t (*const layer_masks_parent1)[LANDLOCK_NUM_ACCESS_FS],
>   	const layer_mask_t (*const layer_masks_child1)[LANDLOCK_NUM_ACCESS_FS],
>   	const bool child1_is_directory,
> @@ -409,7 +409,7 @@ static inline bool no_more_access(
>    *
>    * Returns true if the request is allowed, false otherwise.
>    */
> -static inline bool
> +static bool
>   scope_to_request(const access_mask_t access_request,
>   		 layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS])
>   {
> @@ -428,7 +428,7 @@ scope_to_request(const access_mask_t access_request,
>    * Returns true if there is at least one access right different than
>    * LANDLOCK_ACCESS_FS_REFER.
>    */
> -static inline bool
> +static bool
>   is_eacces(const layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS],
>   	  const access_mask_t access_request)
>   {
> @@ -639,9 +639,9 @@ static bool is_access_to_paths_allowed(
>   	return allowed_parent1 && allowed_parent2;
>   }
> 
> -static inline int check_access_path(const struct landlock_ruleset *const domain,
> -				    const struct path *const path,
> -				    access_mask_t access_request)
> +static int check_access_path(const struct landlock_ruleset *const domain,
> +			     const struct path *const path,
> +			     access_mask_t access_request)
>   {
>   	layer_mask_t layer_masks[LANDLOCK_NUM_ACCESS_FS] = {};
> 
> @@ -662,7 +662,7 @@ static int current_check_access_path(const struct path *const path,
>   	return check_access_path(dom, path, access_request);
>   }
> 
> -static inline access_mask_t get_mode_access(const umode_t mode)
> +static access_mask_t get_mode_access(const umode_t mode)
>   {
>   	switch (mode & S_IFMT) {
>   	case S_IFLNK:
> @@ -687,7 +687,7 @@ static inline access_mask_t get_mode_access(const umode_t mode)
>   	}
>   }
> 
> -static inline access_mask_t maybe_remove(const struct dentry *const dentry)
> +static access_mask_t maybe_remove(const struct dentry *const dentry)
>   {
>   	if (d_is_negative(dentry))
>   		return 0;
> @@ -1171,7 +1171,7 @@ static int hook_path_truncate(const struct path *const path)
>    * Returns the access rights that are required for opening the given file,
>    * depending on the file type and open mode.
>    */
> -static inline access_mask_t
> +static access_mask_t
>   get_required_file_open_access(const struct file *const file)
>   {
>   	access_mask_t access = 0;
> diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
> index 1f3188b4e313..1f432a809ad5 100644
> --- a/security/landlock/ruleset.c
> +++ b/security/landlock/ruleset.c
> @@ -243,7 +243,7 @@ int landlock_insert_rule(struct landlock_ruleset *const ruleset,
>   	return insert_rule(ruleset, object, &layers, ARRAY_SIZE(layers));
>   }
> 
> -static inline void get_hierarchy(struct landlock_hierarchy *const hierarchy)
> +static void get_hierarchy(struct landlock_hierarchy *const hierarchy)
>   {
>   	if (hierarchy)
>   		refcount_inc(&hierarchy->usage);
> --
> 2.25.1
> 
