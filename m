Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF4C75FAE7D
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 10:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbiJKIch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 04:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbiJKIcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 04:32:20 -0400
Received: from smtp-190a.mail.infomaniak.ch (smtp-190a.mail.infomaniak.ch [185.125.25.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B416385598
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 01:32:18 -0700 (PDT)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4MmptS4VwBzMqBCR;
        Tue, 11 Oct 2022 10:32:16 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4MmptS0XKTzMpprH;
        Tue, 11 Oct 2022 10:32:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1665477136;
        bh=i1QozCdbLF8mC5Ti7x3s/K4yPoiXCCNs7CBbe0ukwKU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=QgvNf4loK/J/M2hyRKHQOAJ4eZQvS2WProNRB8HTAxxoSu3JgVw2mjpWHXPztiOBP
         wiIsTfr1asYnA5WRZv41wxvwo93GrIzM8dJZzScdwOPsjL9V4/j1BSaBaXgq7QoeIH
         3vmX/o4OBe38G4u/LP+mLEXKPxE+TOC3ZA8Uj94U=
Message-ID: <1caf1972-4983-45ad-6050-47c44e1f41fb@digikod.net>
Date:   Tue, 11 Oct 2022 10:32:15 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v7 16/18] seltests/landlock: add invalid input data test
Content-Language: en-US
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, anton.sirazetdinov@huawei.com
References: <20220829170401.834298-1-konstantin.meskhidze@huawei.com>
 <20220829170401.834298-17-konstantin.meskhidze@huawei.com>
 <d91e3fcc-2320-e98c-7d54-458b749c87a8@digikod.net>
 <47ddb2ea-3bc7-533a-9b0d-2b2d3950644c@huawei.com>
 <36de86ad-460c-81d0-b5bd-4d54bd05d201@digikod.net>
 <b4b49d93-72a1-b7b4-68e4-2bd03034ee77@digikod.net>
 <4d97342e-0961-e691-40af-c007d02ea43c@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <4d97342e-0961-e691-40af-c007d02ea43c@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/10/2022 09:55, Konstantin Meskhidze (A) wrote:
> 
> 
> 10/10/2022 1:37 PM, Mickaël Salaün пишет:
>>
>> On 12/09/2022 19:22, Mickaël Salaün wrote:
>>>
>>> On 10/09/2022 22:51, Konstantin Meskhidze (A) wrote:
>>>>
>>>>
>>>> 9/6/2022 11:09 AM, Mickaël Salaün пишет:
>>>>>
>>>>> On 29/08/2022 19:03, Konstantin Meskhidze wrote:
>>>>>> This patch adds rules with invalid user space supplied data:
>>>>>>         - out of range ruleset attribute;
>>>>>>         - unhandled allowed access;
>>>>>>         - zero port value;
>>>>>>         - zero access value;
>>>>>>
>>>>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>>>>>> ---
>>>>>>
>>>>>> Changes since v6:
>>>>>> * Adds invalid ruleset attribute test.
>>>>>>
>>>>>> Changes since v5:
>>>>>> * Formats code with clang-format-14.
>>>>>>
>>>>>> Changes since v4:
>>>>>> * Refactors code with self->port variable.
>>>>>>
>>>>>> Changes since v3:
>>>>>> * Adds inval test.
>>>>>>
>>>>>> ---
>>>>>>      tools/testing/selftests/landlock/net_test.c | 66 ++++++++++++++++++++-
>>>>>>      1 file changed, 65 insertions(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
>>>>>> index a93224d1521b..067ba45f58a5 100644
>>>>>> --- a/tools/testing/selftests/landlock/net_test.c
>>>>>> +++ b/tools/testing/selftests/landlock/net_test.c
>>>>>> @@ -26,9 +26,12 @@
>>>>>>
>>>>>>      #define IP_ADDRESS "127.0.0.1"
>>>>>>
>>>>>> -/* Number pending connections queue to be hold */
>>>>>> +/* Number pending connections queue to be hold. */
>>>>>
>>>>> Patch of a previous patch?
>>>>>
>>>>>
>>>>>>      #define BACKLOG 10
>>>>>>
>>>>>> +/* Invalid attribute, out of landlock network access range. */
>>>>>> +#define LANDLOCK_INVAL_ATTR 7
>>>>>> +
>>>>>>      FIXTURE(socket)
>>>>>>      {
>>>>>>      	uint port[MAX_SOCKET_NUM];
>>>>>> @@ -719,4 +722,65 @@ TEST_F(socket, ruleset_expanding)
>>>>>>      	/* Closes socket 1. */
>>>>>>      	ASSERT_EQ(0, close(sockfd_1));
>>>>>>      }
>>>>>> +
>>>>>> +TEST_F(socket, inval)
>>>>>> +{
>>>>>> +	struct landlock_ruleset_attr ruleset_attr = {
>>>>>> +		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP
>>>>>> +	};
>>>>>> +	struct landlock_ruleset_attr ruleset_attr_inval = {
>>>>>> +		.handled_access_net = LANDLOCK_INVAL_ATTR
>>>>>
>>>>> Please add a test similar to TEST_F_FORK(layout1,
>>>>> file_and_dir_access_rights) instead of explicitly defining and only
>>>>> testing LANDLOCK_INVAL_ATTR.
>>>>>
>>>>       Do you want fs test to be in this commit or maybe its better to add
>>>> it into "[PATCH v7 01/18] landlock: rename access mask" one.
>>
>> Just to make it clear, I didn't suggested an FS test, but a new network
>> test similar to layout1.file_and_dir_access_rights but only related to
>> the network. It should replace/extend the content of this patch (16/18).
>>
>    Ok. I will check out out "layout1.file_and_dir_access_rights" one.
> But anyway we need some test like TEST_F_FORK(layout1, with_net) and
> TEST_F_FORK(socket, with_fs) with mixed attributes as you suggested.

Right, you can add that to the main test patch.
