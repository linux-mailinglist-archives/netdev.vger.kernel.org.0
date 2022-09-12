Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71A355B5F07
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 19:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiILRRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 13:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiILRRE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 13:17:04 -0400
Received: from smtp-42ab.mail.infomaniak.ch (smtp-42ab.mail.infomaniak.ch [IPv6:2001:1600:3:17::42ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3E03ECC7
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 10:17:02 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4MRCvH5vR6zMqjlr;
        Mon, 12 Sep 2022 19:16:59 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4MRCvH28g9zMpnPg;
        Mon, 12 Sep 2022 19:16:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1663003019;
        bh=lLc8OqXK1/4nu+Ro0iHjQMR+luFABUGRqGY3ZJypmq4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=F/YwKHVjB1ygpba2fT6SnmtNP0SB5Xp+l7VYq8y09C778DQszlNaL7kfXpIS+z0tm
         rmIQcEdeotXZmULBUxB9q/xajddW1PAZ/CrwsJS60Ky7UjqfUlbDLH7DZcc4hFEa6L
         SQFjI0wxLhft54sqtQEXHhU8U/u8K/Gp/auYi3S4=
Message-ID: <45dc56c9-f02d-8501-4175-42ff62e9f310@digikod.net>
Date:   Mon, 12 Sep 2022 19:16:58 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v7 01/18] landlock: rename access mask
Content-Language: en-US
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, anton.sirazetdinov@huawei.com
References: <20220829170401.834298-1-konstantin.meskhidze@huawei.com>
 <20220829170401.834298-2-konstantin.meskhidze@huawei.com>
 <818834fa-4460-214a-38ec-404c9abf71a3@digikod.net>
 <40095ab0-0faf-2630-eae2-ad9a9c4eab98@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <40095ab0-0faf-2630-eae2-ad9a9c4eab98@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 09/09/2022 12:42, Konstantin Meskhidze (A) wrote:
> 
> 
> 9/6/2022 11:06 AM, Mickaël Salaün пишет:
>> You can improve the subject with "landlock: Make ruleset's access masks
>> more generic".
>> Please capitalize all subjects this way.
>>
>> On 29/08/2022 19:03, Konstantin Meskhidze wrote:
>>> To support network type rules, this modification renames ruleset's
>>> access masks and modifies it's type to access_masks_t. This patch
>>> adds filesystem helper functions to add and get filesystem mask.
>>>
>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>>> ---
>>>
>>> Changes since v6:
>>> * Adds a new access_masks_t for struct ruleset.
>>> * Renames landlock_set_fs_access_mask() to landlock_add_fs_access_mask()
>>>     because it OR values.
>>> * Makes landlock_add_fs_access_mask() more resilient incorrect values.
>>> * Refactors landlock_get_fs_access_mask().
>>>
>>> Changes since v5:
>>> * Changes access_mask_t to u32.
>>> * Formats code with clang-format-14.
>>>
>>> Changes since v4:
>>> * Deletes struct landlock_access_mask.
>>>
>>> Changes since v3:
>>> * Splits commit.
>>> * Adds get_mask, set_mask helpers for filesystem.
>>> * Adds new struct landlock_access_mask.
>>>
>>> ---
>>>    security/landlock/fs.c       |  7 ++++---
>>>    security/landlock/limits.h   |  1 +
>>>    security/landlock/ruleset.c  | 17 +++++++++--------
>>>    security/landlock/ruleset.h  | 37 ++++++++++++++++++++++++++++++++----
>>>    security/landlock/syscalls.c |  7 ++++---
>>>    5 files changed, 51 insertions(+), 18 deletions(-)
>>
>> [...]
>>
>>> @@ -177,4 +182,28 @@ static inline void landlock_get_ruleset(struct landlock_ruleset *const ruleset)
>>>    		refcount_inc(&ruleset->usage);
>>>    }
>>>
>>> +/* A helper function to set a filesystem mask. */
>>> +static inline void
>>> +landlock_add_fs_access_mask(struct landlock_ruleset *const ruleset,
>>> +			    const access_mask_t fs_access_mask,
>>> +			    const u16 layer_level)
>>> +{
>>> +	access_mask_t fs_mask = fs_access_mask & LANDLOCK_MASK_ACCESS_FS;
>>> +
>>> +	/* Should already be checked in sys_landlock_create_ruleset(). */
>>> +	WARN_ON_ONCE(fs_access_mask != fs_mask);
>>> +	// TODO: Add tests to check "|=" and not "="
>>
>> Please add tests as I explained in a previous email.
> 
>     Do you mean to add this test into TEST_F_FORK(layout1, inval) in
> fs_test.c ???

This is unrelated to the layout1.inval tests. You can create a new 
TEST_F_FORK(layout1, with_net) that also handles TCP_BIND/CONNECT and 
checks a simple subset of TEST_F_FORK(layout1, effective_access) (e.g. 
only read access to dir_s1d2, but not to dir_s2d2). To test the 
complement, you can create a TEST_F_FORK(socket, with_fs) to check that 
bind() works as expected.
