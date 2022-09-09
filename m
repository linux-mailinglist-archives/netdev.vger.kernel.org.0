Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CAE25B3568
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 12:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbiIIKmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 06:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231124AbiIIKmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 06:42:53 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB7D4138111;
        Fri,  9 Sep 2022 03:42:51 -0700 (PDT)
Received: from fraeml736-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MPCC34cLYz688wM;
        Fri,  9 Sep 2022 18:38:39 +0800 (CST)
Received: from lhrpeml500004.china.huawei.com (7.191.163.9) by
 fraeml736-chm.china.huawei.com (10.206.15.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 9 Sep 2022 12:42:49 +0200
Received: from [10.122.132.241] (10.122.132.241) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 9 Sep 2022 11:42:48 +0100
Message-ID: <40095ab0-0faf-2630-eae2-ad9a9c4eab98@huawei.com>
Date:   Fri, 9 Sep 2022 13:42:47 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v7 01/18] landlock: rename access mask
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <anton.sirazetdinov@huawei.com>
References: <20220829170401.834298-1-konstantin.meskhidze@huawei.com>
 <20220829170401.834298-2-konstantin.meskhidze@huawei.com>
 <818834fa-4460-214a-38ec-404c9abf71a3@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <818834fa-4460-214a-38ec-404c9abf71a3@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhrpeml500005.china.huawei.com (7.191.163.240) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



9/6/2022 11:06 AM, Mickaël Salaün пишет:
> You can improve the subject with "landlock: Make ruleset's access masks
> more generic".
> Please capitalize all subjects this way.
> 
> On 29/08/2022 19:03, Konstantin Meskhidze wrote:
>> To support network type rules, this modification renames ruleset's
>> access masks and modifies it's type to access_masks_t. This patch
>> adds filesystem helper functions to add and get filesystem mask.
>> 
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> ---
>> 
>> Changes since v6:
>> * Adds a new access_masks_t for struct ruleset.
>> * Renames landlock_set_fs_access_mask() to landlock_add_fs_access_mask()
>>    because it OR values.
>> * Makes landlock_add_fs_access_mask() more resilient incorrect values.
>> * Refactors landlock_get_fs_access_mask().
>> 
>> Changes since v5:
>> * Changes access_mask_t to u32.
>> * Formats code with clang-format-14.
>> 
>> Changes since v4:
>> * Deletes struct landlock_access_mask.
>> 
>> Changes since v3:
>> * Splits commit.
>> * Adds get_mask, set_mask helpers for filesystem.
>> * Adds new struct landlock_access_mask.
>> 
>> ---
>>   security/landlock/fs.c       |  7 ++++---
>>   security/landlock/limits.h   |  1 +
>>   security/landlock/ruleset.c  | 17 +++++++++--------
>>   security/landlock/ruleset.h  | 37 ++++++++++++++++++++++++++++++++----
>>   security/landlock/syscalls.c |  7 ++++---
>>   5 files changed, 51 insertions(+), 18 deletions(-)
> 
> [...]
> 
>> @@ -177,4 +182,28 @@ static inline void landlock_get_ruleset(struct landlock_ruleset *const ruleset)
>>   		refcount_inc(&ruleset->usage);
>>   }
>> 
>> +/* A helper function to set a filesystem mask. */
>> +static inline void
>> +landlock_add_fs_access_mask(struct landlock_ruleset *const ruleset,
>> +			    const access_mask_t fs_access_mask,
>> +			    const u16 layer_level)
>> +{
>> +	access_mask_t fs_mask = fs_access_mask & LANDLOCK_MASK_ACCESS_FS;
>> +
>> +	/* Should already be checked in sys_landlock_create_ruleset(). */
>> +	WARN_ON_ONCE(fs_access_mask != fs_mask);
>> +	// TODO: Add tests to check "|=" and not "="
> 
> Please add tests as I explained in a previous email.

   Do you mean to add this test into TEST_F_FORK(layout1, inval) in 
fs_test.c ???
> .
