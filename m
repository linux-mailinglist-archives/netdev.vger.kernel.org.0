Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE5AE69631A
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 13:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbjBNMHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 07:07:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbjBNMHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 07:07:39 -0500
Received: from smtp-8fae.mail.infomaniak.ch (smtp-8fae.mail.infomaniak.ch [IPv6:2001:1600:4:17::8fae])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B2F2241F8
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 04:07:36 -0800 (PST)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4PGKhh4qTRzMq2h3;
        Tue, 14 Feb 2023 13:07:32 +0100 (CET)
Received: from unknown by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4PGKhg6Qt1zMrY7q;
        Tue, 14 Feb 2023 13:07:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1676376452;
        bh=gqIDRvWGTzT4nklKmWvFibafE6/JDz2MqIevgZJRG2U=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=moSXJG+9/kIX5O4QFtTZZNEudfDUK8enluJSh4YRMvlKmbf3YI6PymqWPirLRDFQi
         75yVJ4CFk/lm70U06xor75sQPDi77butsXBn9/foZtYg/w6UgNyoCd1Rno0KWWjQE3
         ZlsLQbwvfYFLQtGNtg2xkiJxvXH1vYQJ5gju4GUk=
Message-ID: <e4008258-aad3-02d2-86fa-9c8118dcbd9e@digikod.net>
Date:   Tue, 14 Feb 2023 13:07:31 +0100
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v9 02/12] landlock: Allow filesystem layout changes for
 domains without such rule type
Content-Language: en-US
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
References: <20230116085818.165539-1-konstantin.meskhidze@huawei.com>
 <20230116085818.165539-3-konstantin.meskhidze@huawei.com>
 <97ff3f0f-1704-3003-fe60-d7444579e0d7@digikod.net>
 <f60af74e-bfdc-8e4b-03dd-2355c648588a@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <f60af74e-bfdc-8e4b-03dd-2355c648588a@huawei.com>
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


On 14/02/2023 09:51, Konstantin Meskhidze (A) wrote:
> 
> 
> 2/10/2023 8:34 PM, Mickaël Salaün пишет:
>> Hi Konstantin,
>>
>> I think this patch series is almost ready. Here is a first batch of
>> review, I'll send more next week.
>>
>     Hi Mickaёl.
>     thnaks for the review.
> 
>>
>> I forgot to update the documentation. Can you please squash the
>> following patch into this one?
> 
>     No problem. I will squash.
>     Can I download this doc patch from your repo or I can use the diff below?

You can take the diff below.

>>
>>
>> diff --git a/Documentation/userspace-api/landlock.rst
>> b/Documentation/userspace-api/landlock.rst
>> index 980558b879d6..fc2be89b423f 100644
>> --- a/Documentation/userspace-api/landlock.rst
>> +++ b/Documentation/userspace-api/landlock.rst
>> @@ -416,9 +416,9 @@ Current limitations
>>     Filesystem topology modification
>>     --------------------------------
>>
>> -As for file renaming and linking, a sandboxed thread cannot modify its
>> -filesystem topology, whether via :manpage:`mount(2)` or
>> -:manpage:`pivot_root(2)`.  However, :manpage:`chroot(2)` calls are not
>> denied.
>> +Threads sandboxed with filesystem restrictions cannot modify filesystem
>> +topology, whether via :manpage:`mount(2)` or :manpage:`pivot_root(2)`.
>> +However, :manpage:`chroot(2)` calls are not denied.
>>
>>     Special filesystems
>>     -------------------
>>
>>
>> On 16/01/2023 09:58, Konstantin Meskhidze wrote:
>>> From: Mickaël Salaün <mic@digikod.net>
>>>
>>> Allow mount point and root directory changes when there is no filesystem
>>> rule tied to the current Landlock domain.  This doesn't change anything
>>> for now because a domain must have at least a (filesystem) rule, but
>>> this will change when other rule types will come.  For instance, a
>>> domain only restricting the network should have no impact on filesystem
>>> restrictions.
>>>
>>> Add a new get_current_fs_domain() helper to quickly check filesystem
>>> rule existence for all filesystem LSM hooks.
>>>
>>> Remove unnecessary inlining.
>>>
>>> Signed-off-by: Mickaël Salaün <mic@digikod.net>
>>> ---
>>>
>>> Changes since v8:
>>> * Refactors get_handled_fs_accesses().
>>> * Adds landlock_get_raw_fs_access_mask() helper.
>>>
>> .
