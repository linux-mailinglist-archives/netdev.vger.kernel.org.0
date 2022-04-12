Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C747E4FE592
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 18:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357496AbiDLQMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 12:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240516AbiDLQMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 12:12:19 -0400
Received: from smtp-8fa9.mail.infomaniak.ch (smtp-8fa9.mail.infomaniak.ch [83.166.143.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99BE84AE1B
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 09:10:00 -0700 (PDT)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4Kd9fZ4T2xzMqKrL;
        Tue, 12 Apr 2022 18:09:58 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4Kd9fZ0G0ZzljsV0;
        Tue, 12 Apr 2022 18:09:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1649779798;
        bh=rjmNslMl6N3fWg5T7Fr5nmkqlk6bozeTLtc7icUMyjA=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=ccJa5J0ct/QoZol+PWIYaFhliMBIBpZyqNiENzOk/RY9pvCr6VkI1l2ozdxqntSWn
         cFY+nX/e5bySFGhIWPpR9Cpo0G7tEFY4pi40tj2QYGd8+/HNFwg5winQMqmXCPtnY8
         EqBoqp8WR3WCe0IfJCBWUcFoGoZaj7NZ3MVYAjdI=
Message-ID: <dbe702e7-ee63-c665-a989-255b0c1212cc@digikod.net>
Date:   Tue, 12 Apr 2022 18:10:14 +0200
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com, anton.sirazetdinov@huawei.com
References: <20220309134459.6448-1-konstantin.meskhidze@huawei.com>
 <20220309134459.6448-8-konstantin.meskhidze@huawei.com>
 <d4724117-167d-00b0-1f10-749b35bffc2f@digikod.net>
 <1b1c5aaa-9d9a-e38e-42b4-bb0509eba4b5@digikod.net>
 <6db0b12b-aeaa-12b6-bf50-33f138a52360@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [RFC PATCH v4 07/15] landlock: user space API network support
In-Reply-To: <6db0b12b-aeaa-12b6-bf50-33f138a52360@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/04/2022 16:05, Konstantin Meskhidze wrote:
> 
> 
> 4/12/2022 4:48 PM, Mickaël Salaün пишет:
>>
>> On 12/04/2022 13:21, Mickaël Salaün wrote:
>>>
>>> On 09/03/2022 14:44, Konstantin Meskhidze wrote:
>>
>> [...]
>>
>>>> @@ -184,7 +185,7 @@ SYSCALL_DEFINE3(landlock_create_ruleset,
>>>>
>>>>       /* Checks content (and 32-bits cast). */
>>>>       if ((ruleset_attr.handled_access_fs | LANDLOCK_MASK_ACCESS_FS) !=
>>>> -            LANDLOCK_MASK_ACCESS_FS)
>>>> +             LANDLOCK_MASK_ACCESS_FS)
>>>
>>> Don't add cosmetic changes. FYI, I'm relying on the way Vim does line 
>>> cuts, which is mostly tabs. Please try to do the same.
>>
>> Well, let's make it simple and avoid tacit rules. I'll update most of 
>> the existing Landlock code and tests to be formatted with clang-format 
>> (-i *.[ch]), and I'll update the landlock-wip branch so that you can 
>> base your next patch series on it. There should be some exceptions 
>> that need customization but we'll see that in the next series. Anyway, 
>> don't worry too much, just make sure you don't have style-only changes 
>> in your patches.
> 
>    I have already rebased my next patch series on your landlock-wip 
> branch. So I will wait for your changes meanwhile refactoring my v5 
> patch series according your comments.

Good.

> 
> Also I want to discuss adding demo in sandboxer.c to show how landlock
> supports network sandboxing:
> 
>      - Add additional args like "LL_NET_BIND=port1:...:portN"
>      - Add additional args like "LL_NET_CONNECT=port1:...:portN"
>      - execv 2 bash procceses:
>          1. first bash listens in loop - $ nc -l -k -p <port1> -v
>          2. second bash to connects the first one - $ nc <ip> <port>
> 
> What do you think? its possible to present this demo in the next v5 
> patch series.

This looks good! I think LL_TCP_BIND and LL_TCP_CONNECT would fit better 
though.

I'm not sure if I already said that, but please remove the "RFC " part 
for the next series.
