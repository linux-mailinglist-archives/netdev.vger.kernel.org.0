Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E94C953258D
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 10:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232694AbiEXIly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 04:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbiEXIlw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 04:41:52 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC8B2314F;
        Tue, 24 May 2022 01:41:51 -0700 (PDT)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4L6njZ1Mxfz688sL;
        Tue, 24 May 2022 16:41:22 +0800 (CST)
Received: from [10.122.132.241] (10.122.132.241) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Tue, 24 May 2022 10:41:48 +0200
Message-ID: <377fae5e-8427-c5aa-cab8-ecb5f7f897d1@huawei.com>
Date:   Tue, 24 May 2022 11:41:47 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v5 15/15] samples/landlock: adds network demo
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <anton.sirazetdinov@huawei.com>
References: <20220516152038.39594-1-konstantin.meskhidze@huawei.com>
 <20220516152038.39594-16-konstantin.meskhidze@huawei.com>
 <179ac2ee-37ff-92da-c381-c2c716725045@digikod.net>
 <7a5671cd-6bf3-9d17-ef17-ac9129386447@huawei.com>
 <0556b4ff-9a02-7095-e495-c713ca641356@digikod.net>
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
In-Reply-To: <0556b4ff-9a02-7095-e495-c713ca641356@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhreml753-chm.china.huawei.com (10.201.108.203) To
 fraeml704-chm.china.huawei.com (10.206.15.53)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



5/19/2022 6:09 PM, Mickaël Salaün пишет:
> 
> 
> On 19/05/2022 15:33, Konstantin Meskhidze wrote:
>>
>>
>> 5/17/2022 12:19 PM, Mickaël Salaün пишет:
>>>
>>>
>>> On 16/05/2022 17:20, Konstantin Meskhidze wrote:
>>>> This commit adds network demo. It's possible to
>>>> allow a sandoxer to bind/connect to a list of
>>>> particular ports restricting networks actions to
>>>> the rest of ports.
>>>>
>>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>>>> ---
>>>>
>>>> Changes since v4:
>>>> * Adds ENV_TCP_BIND_NAME "LL_TCP_BIND" and
>>>> ENV_TCP_CONNECT_NAME "LL_TCP_CONNECT" variables
>>>> to insert TCP ports.
>>>> * Renames populate_ruleset() to populate_ruleset_fs().
>>>> * Adds populate_ruleset_net() and parse_port_num() helpers.
>>>> * Refactoring main() to support network sandboxing.
>>>>
>>>> ---
> 
> [...]
> 
>>>>       if (ruleset_fd < 0) {
>>>>           perror("Failed to create a ruleset");
>>>>           return 1;
>>>>       }
>>>> -    if (populate_ruleset(ENV_FS_RO_NAME, ruleset_fd, access_fs_ro)) {
>>>> +    if (populate_ruleset_fs(ENV_FS_RO_NAME, ruleset_fd, access_fs_ro))
>>>>           goto err_close_ruleset;
>>>> -    }
>>>
>>> Why? I know that checkpatch.pl prints a warning for that but I 
>>> delibirately chooe to use curly braces even for "if" statements with 
>>> one line because it is safer. This code may be copied/pasted and I'd 
>>> like others to avoid introducing goto-fail-like issues.
>>>
>>
>>   It was done just to reduce the number of checkpatch.pl warnings.
>>   If you want it to be formated in your way I will fix it.
> 
> Yes please, checkpatch.pl helps to mantain kernel code but this is a 
> user space code and I prefer to follow safe practices for this kind of 
> checks.
> 
  Ok. I will keep you code here. Thanks.
> [...]
> 
>>>> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
>>>> index 916b30b31c06..e1ff40f238a6 100644
>>>> --- a/security/landlock/ruleset.h
>>>> +++ b/security/landlock/ruleset.h
>>>> @@ -19,7 +19,7 @@
>>>>   #include "limits.h"
>>>>   #include "object.h"
>>>>
>>>> -typedef u16 access_mask_t;
>>>> +typedef u32 access_mask_t;
>>>
>>> What‽
>>
>>    You are right. I will move this changes to another commit, related 
>> the kernel updates. I might have forgotten to rebase this change and 
>> left it in sandboxer patch. Thank you..
> 
> Indeed. Please check that every commit build (without warning) and that 
> the related tests are OK.

   Ok. I will. Thanks.
> 
> 
>>>
>>>
>>>>
>>>>   /* Makes sure all filesystem access rights can be stored. */
>>>>   static_assert(BITS_PER_TYPE(access_mask_t) >= 
>>>> LANDLOCK_NUM_ACCESS_FS);
>>>> @@ -157,7 +157,7 @@ struct landlock_ruleset {
>>>>                * layers are set once and never changed for the
>>>>                * lifetime of the ruleset.
>>>>                */
>>>> -            u32 access_masks[];
>>>> +            access_mask_t access_masks[];
>>>>           };
>>>>       };
>>>>   };
>>>> -- 
>>>> 2.25.1
>>>>
>>> .
> .
