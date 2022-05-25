Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2872533ACE
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 12:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237994AbiEYKpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 06:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiEYKpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 06:45:13 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C6F994CE
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 03:45:11 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4L7SLT3w3JzQk6q;
        Wed, 25 May 2022 18:42:09 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 25 May 2022 18:45:09 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 25 May
 2022 18:45:09 +0800
Subject: Re: packet stuck in qdisc : patch proposal
To:     Vincent Ray <vray@kalrayinc.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
CC:     davem <davem@davemloft.net>,
        =?UTF-8?B?5pa55Zu954Ks?= <guoju.fgj@alibaba-inc.com>,
        kuba <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        Samuel Jones <sjones@kalrayinc.com>,
        "vladimir oltean" <vladimir.oltean@nxp.com>,
        Guoju Fang <gjfang@linux.alibaba.com>,
        "Remy Gauguey" <rgauguey@kalrayinc.com>, will <will@kernel.org>,
        Eric Dumazet <edumazet@google.com>
References: <1359936158.10849094.1649854873275.JavaMail.zimbra@kalray.eu>
 <2b827f3b-a9db-e1a7-0dc9-65446e07bc63@linux.alibaba.com>
 <1684598287.15044793.1653314052575.JavaMail.zimbra@kalray.eu>
 <d374b806-1816-574e-ba8b-a750a848a6b3@huawei.com>
 <1758521608.15136543.1653380033771.JavaMail.zimbra@kalray.eu>
 <1675198168.15239468.1653411635290.JavaMail.zimbra@kalray.eu>
 <317a3e67-0956-e9c2-0406-9349844ca612@gmail.com>
 <1140270297.15304639.1653471897630.JavaMail.zimbra@kalray.eu>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <60d1e5b8-dae0-38ef-4b9d-f6419861fdab@huawei.com>
Date:   Wed, 25 May 2022 18:45:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <1140270297.15304639.1653471897630.JavaMail.zimbra@kalray.eu>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/5/25 17:44, Vincent Ray wrote:
> ----- On May 24, 2022, at 10:17 PM, Eric Dumazet eric.dumazet@gmail.com wrote:
> 
>> On 5/24/22 10:00, Vincent Ray wrote:
>>> All,
>>>
>>> I confirm Eric's patch works well too, and it's better and clearer than mine.
>>> So I think we should go for it, and the one from Guoju in addition.
>>>
>>> @Eric : I see you are one of the networking maintainers, so I have a few
>>> questions for you :
>>>
>>> a) are you going to take care of these patches directly yourself, or is there
>>> something Guoju or I should do to promote them ?
>>
>> I think this is totally fine you take ownership of the patch, please
>> send a formal V2.
>>
>> Please double check what patchwork had to say about your V1 :
>>
>>
>> https://patchwork.kernel.org/project/netdevbpf/patch/1684598287.15044793.1653314052575.JavaMail.zimbra@kalray.eu/
>>
>>
>> And make sure to address the relevant points
> 
> OK I will.
> If you agree, I will take your version of the fix (test_and_set_bit()), keeping the commit message
> similar to my original one.
> 
> What about Guoju's patch ? 

@Guoju, please speak up if you want to handle the patch yourself.

> (adding a smp_mb() between the spin_unlock() and test_bit() in qdisc_run_end()). 
> I think it is also necessary though potentially less critical.
> Do we embed it in the same patch ? or patch series ?

Guoju's patch fixes the commit a90c57f2cedd, so "patch series"
seems better if Guoju is not speaking up to handle the patch himself.


> 
> @Guoju : have you submitted it for integration ?
> 
> 
>> The most important one is the lack of 'Signed-off-by:' tag, of course.
>>
>>
>>> b) Can we expect to see them land in the mainline soon ?
>>
>> If your v2 submission is correct, it can be merged this week ;)
>>
>>
>>>
>>> c) Will they be backported to previous versions of the kernel ? Which ones ?
>>
>> You simply can include a proper Fixes: tag, so that stable teams can
>> backport
>>
>> the patch to all affected kernel versions.
>>
> 
> Here things get a little complicated in my head ;-)
> As explained, I think this mechanism has been bugged, in a way or an other, for some time, perhaps since the introduction
> of lockless qdiscs (4.16) or somewhere between 4.16 and 5.14.
> It's hard to tell at a glance since the code looks quite different back then.
> Because of these changes, a unique patch will also only apply up to a certain point in the past.
> 
> However, I think the bug became really critical only with the introduction of "true bypass" behavior 
> in lockless qdiscs by YunSheng in 5.14, though there may be scenarios where it is a big deal 
> even in no-bypass mode.


commit 89837eb4b246 tried to fix that, but it did not fix it completely, and that commit should has
been back-ported to the affected kernel versions as much as possible, so I think the Fixes tag
should be:

Fixes: 89837eb4b246 ("net: sched: add barrier to ensure correct ordering for lockless qdisc")

> 
> => I suggest we only tag it for backward fix up to the 5.14, where it should apply smoothly,
>  and we live with the bug for versions before that.
> This would mean that 5.15 LT can be patched but no earlier LT
>  
> What do you think ?
> 
> BTW : forgive my ignorance, but are there any kind of "Errata Sheet" or similar for known bugs that 
> won't be fixed in a given kernel ?
> 
>>
>>
>>>
>>> Thanks a lot, best,
>>
>> Thanks a lot for working on this long standing issue.
>>
>>
>>
>>
>> To declare a filtering error, please use the following link :
>> https://www.security-mail.net/reporter.php?mid=7009.628d3d4c.37c04.0&r=vray%40kalrayinc.com&s=eric.dumazet%40gmail.com&o=Re%3A+packet+stuck+in+qdisc+%3A+patch+proposal&verdict=C&c=0ca08e7b7e420d1ab014cda67db48db71df41f5f
> 
> 
> 
> 
> .
> 
