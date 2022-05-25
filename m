Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3488D534262
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 19:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245758AbiEYRsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 13:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243025AbiEYRsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 13:48:14 -0400
Received: from fx308.security-mail.net (smtpout30.security-mail.net [85.31.212.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E2B20195
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 10:48:12 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by fx308.security-mail.net (Postfix) with ESMTP id 594E93D2D1F
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 19:48:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kalrayinc.com;
        s=sec-sig-email; t=1653500891;
        bh=THGEnkP6jQNqU4pw30Uab/g86RyOLVs+ccuR5EiNvTo=;
        h=Date:From:To:Cc:In-Reply-To:References:Subject;
        b=QZh7toqlzptxaOkCYxdmrVpSnCIm+jJ8umgIIn5FoAigGzdP6U5p2TfgktesPEnkA
         tdynIr+6nR5/YfpKT2wTt5Q5LnUQjlB/2nQE0i95zq0pvgHnYy6IANLOdZT5/ZUMko
         i/t/c8vUfp01LUjWkHznBoKjjpPRF+SHtbil3BVQ=
Received: from fx308 (localhost [127.0.0.1]) by fx308.security-mail.net
 (Postfix) with ESMTP id 1E6713D2D1D for <netdev@vger.kernel.org>; Wed, 25
 May 2022 19:48:11 +0200 (CEST)
Received: from zimbra2.kalray.eu (unknown [217.181.231.53]) by
 fx308.security-mail.net (Postfix) with ESMTPS id 9C1283D2D0F; Wed, 25 May
 2022 19:48:10 +0200 (CEST)
Received: from zimbra2.kalray.eu (localhost [127.0.0.1]) by
 zimbra2.kalray.eu (Postfix) with ESMTPS id 7BCCB27E04BA; Wed, 25 May 2022
 19:48:10 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1]) by zimbra2.kalray.eu
 (Postfix) with ESMTP id 61E9827E04B8; Wed, 25 May 2022 19:48:10 +0200 (CEST)
Received: from zimbra2.kalray.eu ([127.0.0.1]) by localhost
 (zimbra2.kalray.eu [127.0.0.1]) (amavisd-new, port 10026) with ESMTP id
 ej8DKzWa1RBU; Wed, 25 May 2022 19:48:10 +0200 (CEST)
Received: from zimbra2.kalray.eu (localhost [127.0.0.1]) by
 zimbra2.kalray.eu (Postfix) with ESMTP id 4897E27E04AF; Wed, 25 May 2022
 19:48:10 +0200 (CEST)
X-Virus-Scanned: E-securemail, by Secumail
Secumail-id: <2394.628e6bda.9ba20.0>
DKIM-Filter: OpenDKIM Filter v2.10.3 zimbra2.kalray.eu 61E9827E04B8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kalrayinc.com;
 s=4F334102-7B72-11EB-A74E-42D0B9747555; t=1653500890;
 bh=98sLDLAttGW0g4/5iPYbbEa7OlESqaNsLimjYQHMX9k=;
 h=Date:From:To:Message-ID:MIME-Version;
 b=ZFwCWaf5SE6aNTENB25H3D/clCdBUKBRZZGnn6hwLQibLXrLLNf7n7Ycztg5DBoh2
 epmF+iW9dbvzHWh56qQIuijUgShPI/M0yHAxCdnRcHtVQdoIoUi1704AcrFD7ORBGX
 y5/m5fm1MayvnIMGzlcHjBTaQ/T1lODGH13zmDhXgmsZtI+u+SrfSiNiKWxhcWZI4j
 RMb6bCWCQGtwv6QSi/2ZMLNLC8NNUKlDKNWC7CGQ4hOfq+g1pIqC+3IhhWElr3iwKS
 0+09L9QALGCdtRgkOpegAxjI/aKv7MgkZg3Sfi2/dG2FNP3vtO2cSnovtuGU99dk7R
 Ux/Jt6cLxrNSA==
Date:   Wed, 25 May 2022 19:48:10 +0200 (CEST)
From:   Vincent Ray <vray@kalrayinc.com>
To:     Guoju Fang <gjfang@linux.alibaba.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        linyunsheng <linyunsheng@huawei.com>
Cc:     davem <davem@davemloft.net>,
        =?utf-8?b?5pa55Zu954Ks?= <guoju.fgj@alibaba-inc.com>,
        kuba <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        Samuel Jones <sjones@kalrayinc.com>,
        vladimir oltean <vladimir.oltean@nxp.com>,
        Remy Gauguey <rgauguey@kalrayinc.com>, will <will@kernel.org>,
        Eric Dumazet <edumazet@google.com>, pabeni <pabeni@redhat.com>
Message-ID: <151424689.15358643.1653500890228.JavaMail.zimbra@kalray.eu>
In-Reply-To: <1010638538.15358411.1653500629126.JavaMail.zimbra@kalray.eu>
References: <1359936158.10849094.1649854873275.JavaMail.zimbra@kalray.eu>
 <1758521608.15136543.1653380033771.JavaMail.zimbra@kalray.eu>
 <1675198168.15239468.1653411635290.JavaMail.zimbra@kalray.eu>
 <317a3e67-0956-e9c2-0406-9349844ca612@gmail.com>
 <1140270297.15304639.1653471897630.JavaMail.zimbra@kalray.eu>
 <60d1e5b8-dae0-38ef-4b9d-f6419861fdab@huawei.com>
 <90c70f7f-1f07-4cd7-bb41-0f708114bb80@linux.alibaba.com>
 <1010638538.15358411.1653500629126.JavaMail.zimbra@kalray.eu>
Subject: Re: packet stuck in qdisc : patch proposal
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.40.202]
X-Mailer: Zimbra 9.0.0_GA_4126 (ZimbraWebClient - FF100
 (Linux)/9.0.0_GA_4126)
Thread-Topic: packet stuck in qdisc : patch proposal
Thread-Index: vDuncPPq8VO2Ubr/r98NboMjPGD5/I1ihaBO
X-ALTERMIMEV2_out: done
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



----- On May 25, 2022, at 7:43 PM, Vincent Ray vray@kalrayinc.com wrote:

> ----- On May 25, 2022, at 2:40 PM, Guoju Fang gjfang@linux.alibaba.com wrote:
> 
>> On 2022/5/25 18:45, Yunsheng Lin wrote:
>>> On 2022/5/25 17:44, Vincent Ray wrote:
>>>> ----- On May 24, 2022, at 10:17 PM, Eric Dumazet eric.dumazet@gmail.com wrote:
>>>>
>>>>> On 5/24/22 10:00, Vincent Ray wrote:
>>>>>> All,
>>>>>>
>>>>>> I confirm Eric's patch works well too, and it's better and clearer than mine.
>>>>>> So I think we should go for it, and the one from Guoju in addition.
>>>>>>
>>>>>> @Eric : I see you are one of the networking maintainers, so I have a few
>>>>>> questions for you :
>>>>>>
>>>>>> a) are you going to take care of these patches directly yourself, or is there
>>>>>> something Guoju or I should do to promote them ?
>>>>>
>>>>> I think this is totally fine you take ownership of the patch, please
>>>>> send a formal V2.
>>>>>
>>>>> Please double check what patchwork had to say about your V1 :
>>>>>
>>>>>
>>>>> https://patchwork.kernel.org/project/netdevbpf/patch/1684598287.15044793.1653314052575.JavaMail.zimbra@kalray.eu/
>>>>>
>>>>>
>>>>> And make sure to address the relevant points
>>>>
>>>> OK I will.
>>>> If you agree, I will take your version of the fix (test_and_set_bit()), keeping
>>>> the commit message
>>>> similar to my original one.
>>>>
>>>> What about Guoju's patch ?
>>> 
>>> @Guoju, please speak up if you want to handle the patch yourself.
>> 
>> Hi Yunsheng, all,
>> 
>> I rewrite the comments of my patch and it looks a little clearer. :)
>> 
>> Thank you.
>> 
>> Best regards,
> 
> Guoju : shouldn't you also include the same Fixes tag suggested by YunSheng ?
> 
> Here's mine, attached. Hope it's well formatted this time. Tell me.
> I don't feel quite confident with the submission process to produce the series
> myself, so I'll let Eric handle it if it's ok.

NB : from what I've understood reading some doc, as this is a fix, it's supposed to go 
in the "net" tree, so I tagged it accordingly in the Subject. Hope it's Ok

> 
>> 
>>> 
>>>> (adding a smp_mb() between the spin_unlock() and test_bit() in qdisc_run_end()).
>>>> I think it is also necessary though potentially less critical.
>>>> Do we embed it in the same patch ? or patch series ?
>>> 
>>> Guoju's patch fixes the commit a90c57f2cedd, so "patch series"
>>> seems better if Guoju is not speaking up to handle the patch himself.
>>> 
>>> 
>>>>
>>>> @Guoju : have you submitted it for integration ?
>>>>
>>>>
>>>>> The most important one is the lack of 'Signed-off-by:' tag, of course.
>>>>>
>>>>>
>>>>>> b) Can we expect to see them land in the mainline soon ?
>>>>>
>>>>> If your v2 submission is correct, it can be merged this week ;)
>>>>>
>>>>>
>>>>>>
>>>>>> c) Will they be backported to previous versions of the kernel ? Which ones ?
>>>>>
>>>>> You simply can include a proper Fixes: tag, so that stable teams can
>>>>> backport
>>>>>
>>>>> the patch to all affected kernel versions.
>>>>>
>>>>
>>>> Here things get a little complicated in my head ;-)
>>>> As explained, I think this mechanism has been bugged, in a way or an other, for
>>>> some time, perhaps since the introduction
>>>> of lockless qdiscs (4.16) or somewhere between 4.16 and 5.14.
>>>> It's hard to tell at a glance since the code looks quite different back then.
>>>> Because of these changes, a unique patch will also only apply up to a certain
>>>> point in the past.
>>>>
>>>> However, I think the bug became really critical only with the introduction of
>>>> "true bypass" behavior
>>>> in lockless qdiscs by YunSheng in 5.14, though there may be scenarios where it
>>>> is a big deal
>>>> even in no-bypass mode.
>>> 
>>> 
>>> commit 89837eb4b246 tried to fix that, but it did not fix it completely, and
>>> that commit should has
>>> been back-ported to the affected kernel versions as much as possible, so I think
>>> the Fixes tag
>>> should be:
>>> 
>>> Fixes: 89837eb4b246 ("net: sched: add barrier to ensure correct ordering for
>>> lockless qdisc")
>>> 
>>>>
>>>> => I suggest we only tag it for backward fix up to the 5.14, where it should
>>>> apply smoothly,
>>>>   and we live with the bug for versions before that.
>>>> This would mean that 5.15 LT can be patched but no earlier LT
>>>>   
>>>> What do you think ?
>>>>
>>>> BTW : forgive my ignorance, but are there any kind of "Errata Sheet" or similar
>>>> for known bugs that
>>>> won't be fixed in a given kernel ?
>>>>
>>>>>
>>>>>
>>>>>>
>>>>>> Thanks a lot, best,
>>>>>
>>>>> Thanks a lot for working on this long standing issue.
>>>>>
>>>>>
>>>>>
>>>>>
>>>>> To declare a filtering error, please use the following link :
>>>>> https://www.security-mail.net/reporter.php?mid=7009.628d3d4c.37c04.0&r=vray%40kalrayinc.com&s=eric.dumazet%40gmail.com&o=Re%3A+packet+stuck+in+qdisc+%3A+patch+proposal&verdict=C&c=0ca08e7b7e420d1ab014cda67db48db71df41f5f
>>>>
>>>>
>>>>
>>>>
>>>> .
>>>>
>> 
>> To declare a filtering error, please use the following link :
>> https://www.security-mail.net/reporter.php?mid=2c69.628e23bf.45908.0&r=vray%40kalrayinc.com&s=gjfang%40linux.alibaba.com&o=Re%3A+packet+stuck+in+qdisc+%3A+patch+proposal&verdict=C&c=6106070134039ab6725b6d3de67bd24d624c8b51




