Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8312763B30F
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 21:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234061AbiK1U0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 15:26:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233055AbiK1U0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 15:26:11 -0500
X-Greylist: delayed 193 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 28 Nov 2022 12:26:10 PST
Received: from smtp-8fad.mail.infomaniak.ch (smtp-8fad.mail.infomaniak.ch [83.166.143.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B744519C33
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 12:26:10 -0800 (PST)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4NLcS10MjxzMpnyP;
        Mon, 28 Nov 2022 21:26:09 +0100 (CET)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4NLcS01sNRzMppfT;
        Mon, 28 Nov 2022 21:26:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1669667168;
        bh=zsoORo6Emoc7NT2m5Eq078zHD35Y2de/BsGRdHteDto=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=MEcjvEEsbuEY0IAPiYehjM3f+tai3ClEGrWMTvUZwm2DYOC8dHkJdY/EtOFUG7uHv
         +OdKYthI9xLEIU4AY4C2gvoWwkbkVvDU5uGcUnDgv9NDY1Am7o8CT1Pel5G0NJ2rZh
         p25r83uTC2nkIt4EWwkolGZoCCVaPhiABx6KP5VU=
Message-ID: <53a55630-c4db-a79d-7be5-dc6026f92673@digikod.net>
Date:   Mon, 28 Nov 2022 21:26:07 +0100
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v8 07/12] landlock: Add network rules support
Content-Language: en-US
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, artem.kuzin@huawei.com,
        Linux API <linux-api@vger.kernel.org>,
        "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
References: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
 <20221021152644.155136-8-konstantin.meskhidze@huawei.com>
 <49391484-7401-e7c7-d909-3bd6bd024731@digikod.net>
 <ec43e2a7-72b7-54d2-4e8f-0e6553419a9a@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <ec43e2a7-72b7-54d2-4e8f-0e6553419a9a@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 28/11/2022 05:01, Konstantin Meskhidze (A) wrote:
> 
> 
> 11/17/2022 9:43 PM, Mickaël Salaün пишет:
>>
>> On 21/10/2022 17:26, Konstantin Meskhidze wrote:
>>> This commit adds network rules support in internal landlock functions
>>> (presented in ruleset.c) and landlock_create_ruleset syscall.
>>
>> …in the ruleset management helpers and the landlock_create_ruleset syscall.
>>
>>
>>> Refactors user space API to support network actions. Adds new network
>>
>> Refactor…
>>
>>> access flags, network rule and network attributes. Increments Landlock
>>
>> Increment…
> 
>     The commit's message will be fixed. Thank you!
>>
>>> ABI version.
>>>
>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>>> ---
>>>
>>> Changes since v7:
>>> * Squashes commits.
>>> * Increments ABI version to 4.
>>> * Refactors commit message.
>>> * Minor fixes.
>>>
>>> Changes since v6:
>>> * Renames landlock_set_net_access_mask() to landlock_add_net_access_mask()
>>>     because it OR values.
>>> * Makes landlock_add_net_access_mask() more resilient incorrect values.
>>> * Refactors landlock_get_net_access_mask().
>>> * Renames LANDLOCK_MASK_SHIFT_NET to LANDLOCK_SHIFT_ACCESS_NET and use
>>>     LANDLOCK_NUM_ACCESS_FS as value.
>>> * Updates access_masks_t to u32 to support network access actions.
>>> * Refactors landlock internal functions to support network actions with
>>>     landlock_key/key_type/id types.
>>>
>>> Changes since v5:
>>> * Gets rid of partial revert from landlock_add_rule
>>> syscall.
>>> * Formats code with clang-format-14.
>>>
>>> Changes since v4:
>>> * Refactors landlock_create_ruleset() - splits ruleset and
>>> masks checks.
>>> * Refactors landlock_create_ruleset() and landlock mask
>>> setters/getters to support two rule types.
>>> * Refactors landlock_add_rule syscall add_rule_path_beneath
>>> function by factoring out get_ruleset_from_fd() and
>>> landlock_put_ruleset().
>>>
>>> Changes since v3:
>>> * Splits commit.
>>> * Adds network rule support for internal landlock functions.
>>> * Adds set_mask and get_mask for network.
>>> * Adds rb_root root_net_port.
>>>
>>> ---
>>>    include/uapi/linux/landlock.h                | 49 ++++++++++++++
>>>    security/landlock/limits.h                   |  6 +-
>>>    security/landlock/ruleset.c                  | 55 ++++++++++++++--
>>>    security/landlock/ruleset.h                  | 68 ++++++++++++++++----
>>>    security/landlock/syscalls.c                 | 13 +++-
>>>    tools/testing/selftests/landlock/base_test.c |  2 +-
>>>    6 files changed, 170 insertions(+), 23 deletions(-)
>>>
>>> diff --git a/include/uapi/linux/landlock.h b/include/uapi/linux/landlock.h
>>> index f3223f964691..096b683c6ff3 100644
>>> --- a/include/uapi/linux/landlock.h
>>> +++ b/include/uapi/linux/landlock.h
>>> @@ -31,6 +31,13 @@ struct landlock_ruleset_attr {
>>>    	 * this access right.
>>>    	 */
>>>    	__u64 handled_access_fs;
>>> +
>>> +	/**
>>> +	 * @handled_access_net: Bitmask of actions (cf. `Network flags`_)
>>> +	 * that is handled by this ruleset and should then be forbidden if no
>>> +	 * rule explicitly allow them.
>>> +	 */
>>> +	__u64 handled_access_net;
>>>    };
>>>
>>>    /*
>>> @@ -54,6 +61,11 @@ enum landlock_rule_type {
>>>    	 * landlock_path_beneath_attr .
>>>    	 */
>>>    	LANDLOCK_RULE_PATH_BENEATH = 1,
>>> +	/**
>>> +	 * @LANDLOCK_RULE_NET_SERVICE: Type of a &struct
>>> +	 * landlock_net_service_attr .
>>> +	 */
>>> +	LANDLOCK_RULE_NET_SERVICE = 2,
>>>    };
>>>
>>>    /**
>>> @@ -79,6 +91,24 @@ struct landlock_path_beneath_attr {
>>>    	 */
>>>    } __attribute__((packed));
>>>
>>> +/**
>>> + * struct landlock_net_service_attr - TCP subnet definition
>>> + *
>>> + * Argument of sys_landlock_add_rule().
>>> + */
>>> +struct landlock_net_service_attr {
>>> +	/**
>>> +	 * @allowed_access: Bitmask of allowed access network for services
>>> +	 * (cf. `Network flags`_).
>>> +	 */
>>> +	__u64 allowed_access;
>>> +	/**
>>> +	 * @port: Network port.
>>> +	 */
>>> +	__u16 port;
>>
>>    From an UAPI point of view, I think the port field should be __be16, as
>> for sockaddr_in->port and other network-related APIs. This will require
>> some kernel changes to please sparse: make C=2 security/landlock/ must
>> not print any warning.
> 
>     Is sparse a default checker?

You should be able to easily install it with your Linux distro.
