Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 764925AE234
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 10:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233978AbiIFINO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 04:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238924AbiIFINI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 04:13:08 -0400
Received: from smtp-bc0b.mail.infomaniak.ch (smtp-bc0b.mail.infomaniak.ch [IPv6:2001:1600:3:17::bc0b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D4F6F249
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 01:13:06 -0700 (PDT)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4MMHzR1lTdzMqj75;
        Tue,  6 Sep 2022 10:06:59 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4MMHzQ4NwNz14H;
        Tue,  6 Sep 2022 10:06:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1662451619;
        bh=/t04YNXtDHIuTvrQugY5DE4UMW6qw5t0dqEpNR12DZA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=uf3HZBbbzCUwFvT1PXnU0iEDiaUAZk3BLTAzlKdV083lN+krWtSxMX2uFiNGAi+lX
         KKY01J47ZnWw5MYLz369HpEV474sF8jxnYn9SwhiXD//qJfb+Xl8Mng4vfdxRGxgnA
         U9ukBMbzd78Ake/xbldzOnowbCxCiHSvTJ36VCCI=
Message-ID: <818834fa-4460-214a-38ec-404c9abf71a3@digikod.net>
Date:   Tue, 6 Sep 2022 10:06:57 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v7 01/18] landlock: rename access mask
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        hukeping@huawei.com, anton.sirazetdinov@huawei.com
References: <20220829170401.834298-1-konstantin.meskhidze@huawei.com>
 <20220829170401.834298-2-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <20220829170401.834298-2-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

You can improve the subject with "landlock: Make ruleset's access masks 
more generic".
Please capitalize all subjects this way.

On 29/08/2022 19:03, Konstantin Meskhidze wrote:
> To support network type rules, this modification renames ruleset's
> access masks and modifies it's type to access_masks_t. This patch
> adds filesystem helper functions to add and get filesystem mask.
> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
> 
> Changes since v6:
> * Adds a new access_masks_t for struct ruleset.
> * Renames landlock_set_fs_access_mask() to landlock_add_fs_access_mask()
>    because it OR values.
> * Makes landlock_add_fs_access_mask() more resilient incorrect values.
> * Refactors landlock_get_fs_access_mask().
> 
> Changes since v5:
> * Changes access_mask_t to u32.
> * Formats code with clang-format-14.
> 
> Changes since v4:
> * Deletes struct landlock_access_mask.
> 
> Changes since v3:
> * Splits commit.
> * Adds get_mask, set_mask helpers for filesystem.
> * Adds new struct landlock_access_mask.
> 
> ---
>   security/landlock/fs.c       |  7 ++++---
>   security/landlock/limits.h   |  1 +
>   security/landlock/ruleset.c  | 17 +++++++++--------
>   security/landlock/ruleset.h  | 37 ++++++++++++++++++++++++++++++++----
>   security/landlock/syscalls.c |  7 ++++---
>   5 files changed, 51 insertions(+), 18 deletions(-)

[...]

> @@ -177,4 +182,28 @@ static inline void landlock_get_ruleset(struct landlock_ruleset *const ruleset)
>   		refcount_inc(&ruleset->usage);
>   }
> 
> +/* A helper function to set a filesystem mask. */
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

Please add tests as I explained in a previous email.
