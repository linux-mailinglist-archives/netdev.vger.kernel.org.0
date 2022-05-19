Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59CDF52D704
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 17:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236747AbiESPJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 11:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234717AbiESPJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 11:09:25 -0400
Received: from smtp-190d.mail.infomaniak.ch (smtp-190d.mail.infomaniak.ch [IPv6:2001:1600:3:17::190d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DBB8515A7
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 08:09:24 -0700 (PDT)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4L3tYZ5FTBzMqD8G;
        Thu, 19 May 2022 17:09:22 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4L3tYZ1Sz6zljsV7;
        Thu, 19 May 2022 17:09:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1652972962;
        bh=3JJvG/e1mf+A4y7J66g9bLLUz5/wTD9IGOZNtpfhUnk=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=LAmLaRfvpj+TWCHOkPM8G0Adt4qdtdhScNUtmf/H2wYmRK4S5E67eswxba8cle7mO
         jIjfsdKIGBYRBTkcsuq545fU2uV3AIyMRwiO8CLXW4MdMpyfr+4zH+gyx4v+YTUJlG
         3JRIHviccHcaZ9IsdzJHBiR2UVv+H/KGTUifFwQA=
Message-ID: <0556b4ff-9a02-7095-e495-c713ca641356@digikod.net>
Date:   Thu, 19 May 2022 17:09:21 +0200
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        anton.sirazetdinov@huawei.com
References: <20220516152038.39594-1-konstantin.meskhidze@huawei.com>
 <20220516152038.39594-16-konstantin.meskhidze@huawei.com>
 <179ac2ee-37ff-92da-c381-c2c716725045@digikod.net>
 <7a5671cd-6bf3-9d17-ef17-ac9129386447@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [PATCH v5 15/15] samples/landlock: adds network demo
In-Reply-To: <7a5671cd-6bf3-9d17-ef17-ac9129386447@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 19/05/2022 15:33, Konstantin Meskhidze wrote:
> 
> 
> 5/17/2022 12:19 PM, Mickaël Salaün пишет:
>>
>>
>> On 16/05/2022 17:20, Konstantin Meskhidze wrote:
>>> This commit adds network demo. It's possible to
>>> allow a sandoxer to bind/connect to a list of
>>> particular ports restricting networks actions to
>>> the rest of ports.
>>>
>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>>> ---
>>>
>>> Changes since v4:
>>> * Adds ENV_TCP_BIND_NAME "LL_TCP_BIND" and
>>> ENV_TCP_CONNECT_NAME "LL_TCP_CONNECT" variables
>>> to insert TCP ports.
>>> * Renames populate_ruleset() to populate_ruleset_fs().
>>> * Adds populate_ruleset_net() and parse_port_num() helpers.
>>> * Refactoring main() to support network sandboxing.
>>>
>>> ---

[...]

>>>       if (ruleset_fd < 0) {
>>>           perror("Failed to create a ruleset");
>>>           return 1;
>>>       }
>>> -    if (populate_ruleset(ENV_FS_RO_NAME, ruleset_fd, access_fs_ro)) {
>>> +    if (populate_ruleset_fs(ENV_FS_RO_NAME, ruleset_fd, access_fs_ro))
>>>           goto err_close_ruleset;
>>> -    }
>>
>> Why? I know that checkpatch.pl prints a warning for that but I 
>> delibirately chooe to use curly braces even for "if" statements with 
>> one line because it is safer. This code may be copied/pasted and I'd 
>> like others to avoid introducing goto-fail-like issues.
>>
> 
>   It was done just to reduce the number of checkpatch.pl warnings.
>   If you want it to be formated in your way I will fix it.

Yes please, checkpatch.pl helps to mantain kernel code but this is a 
user space code and I prefer to follow safe practices for this kind of 
checks.

[...]

>>> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
>>> index 916b30b31c06..e1ff40f238a6 100644
>>> --- a/security/landlock/ruleset.h
>>> +++ b/security/landlock/ruleset.h
>>> @@ -19,7 +19,7 @@
>>>   #include "limits.h"
>>>   #include "object.h"
>>>
>>> -typedef u16 access_mask_t;
>>> +typedef u32 access_mask_t;
>>
>> What‽
> 
>    You are right. I will move this changes to another commit, related 
> the kernel updates. I might have forgotten to rebase this change and 
> left it in sandboxer patch. Thank you..

Indeed. Please check that every commit build (without warning) and that 
the related tests are OK.


>>
>>
>>>
>>>   /* Makes sure all filesystem access rights can be stored. */
>>>   static_assert(BITS_PER_TYPE(access_mask_t) >= LANDLOCK_NUM_ACCESS_FS);
>>> @@ -157,7 +157,7 @@ struct landlock_ruleset {
>>>                * layers are set once and never changed for the
>>>                * lifetime of the ruleset.
>>>                */
>>> -            u32 access_masks[];
>>> +            access_mask_t access_masks[];
>>>           };
>>>       };
>>>   };
>>> -- 
>>> 2.25.1
>>>
>> .
