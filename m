Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50B1B533A36
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 11:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241887AbiEYJpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 05:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242293AbiEYJpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 05:45:14 -0400
Received: from fx305.security-mail.net (smtpout30.security-mail.net [85.31.212.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A77DD91550
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 02:45:02 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by fx305.security-mail.net (Postfix) with ESMTP id B0C1230FF9C
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 11:45:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kalrayinc.com;
        s=sec-sig-email; t=1653471900;
        bh=D7OnqBeaCunQCMTpdOSdgREG5DFUSHXyAGxAzYeQA54=;
        h=Date:From:To:Cc:In-Reply-To:References:Subject;
        b=PjoM409/rrepxd8lzh9LD+PY4ybC+kcEsM6i+j7Tfk0G2gEfej3k+IoxI81OyNJB/
         PK7pcdNPiiImYjLzt8t2ksxTiKB+2RqgeKsSzrd14i0qUPcQu2PZIXEKDmw6/n5OUO
         KGq4lm/3WXfq3pKf7E2JoT1Z0NoRU2cAK1A+2QrM=
Received: from fx305 (localhost [127.0.0.1]) by fx305.security-mail.net
 (Postfix) with ESMTP id CE3DD30FF5D; Wed, 25 May 2022 11:44:58 +0200 (CEST)
Received: from zimbra2.kalray.eu (unknown [217.181.231.53]) by
 fx305.security-mail.net (Postfix) with ESMTPS id 0E85E30FF23; Wed, 25 May
 2022 11:44:58 +0200 (CEST)
Received: from zimbra2.kalray.eu (localhost [127.0.0.1]) by
 zimbra2.kalray.eu (Postfix) with ESMTPS id DDE6D27E04AF; Wed, 25 May 2022
 11:44:57 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1]) by zimbra2.kalray.eu
 (Postfix) with ESMTP id C34F027E04B4; Wed, 25 May 2022 11:44:57 +0200 (CEST)
Received: from zimbra2.kalray.eu ([127.0.0.1]) by localhost
 (zimbra2.kalray.eu [127.0.0.1]) (amavisd-new, port 10026) with ESMTP id
 Rf1L1t4ji49j; Wed, 25 May 2022 11:44:57 +0200 (CEST)
Received: from zimbra2.kalray.eu (localhost [127.0.0.1]) by
 zimbra2.kalray.eu (Postfix) with ESMTP id A6C5427E04AF; Wed, 25 May 2022
 11:44:57 +0200 (CEST)
X-Virus-Scanned: E-securemail, by Secumail
Secumail-id: <15834.628dfa9a.b47c.0>
DKIM-Filter: OpenDKIM Filter v2.10.3 zimbra2.kalray.eu C34F027E04B4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kalrayinc.com;
 s=4F334102-7B72-11EB-A74E-42D0B9747555; t=1653471897;
 bh=RyhDwXzgrMAOQGgbbs+MJeBkkXISmkrQqT6bvK26j3s=;
 h=Date:From:To:Message-ID:MIME-Version;
 b=NXBv1m8aeljYXei0aBAnUdouunhTPpUfgS+zMEtejwA38JqvFJJQOQkn8OWTUm9OD
 howjoLOCv88orMlYLcQKsSckjogTSvz7rnsURu/IkP/IlZCj3c83hwdtlcJ7qjXtuP
 JYhVVYJITdUwxeZrLPSQ1m3MUSCMT4VeE0J4JYLWkW/XCoK/FQWaHrSrgSixscGf7g
 mEKY1dGydBAuWetU3parRNEdUqL95OY/OTuHnqhRuh0a5bWm3735/698gP7OPlkzPL
 Q2iwwYx2/GZMYY/SpvSCLdHZn0G1K6gW/5ZPuKYT1lZSSFZwsMdi8c9g5ZsVh7Wz54
 csGYSTDGu2J0Q==
Date:   Wed, 25 May 2022 11:44:57 +0200 (CEST)
From:   Vincent Ray <vray@kalrayinc.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     linyunsheng <linyunsheng@huawei.com>, davem <davem@davemloft.net>,
        =?utf-8?b?5pa55Zu954Ks?= <guoju.fgj@alibaba-inc.com>,
        kuba <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        Samuel Jones <sjones@kalrayinc.com>,
        vladimir oltean <vladimir.oltean@nxp.com>,
        Guoju Fang <gjfang@linux.alibaba.com>,
        Remy Gauguey <rgauguey@kalrayinc.com>, will <will@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Message-ID: <1140270297.15304639.1653471897630.JavaMail.zimbra@kalray.eu>
In-Reply-To: <317a3e67-0956-e9c2-0406-9349844ca612@gmail.com>
References: <1359936158.10849094.1649854873275.JavaMail.zimbra@kalray.eu>
 <2b827f3b-a9db-e1a7-0dc9-65446e07bc63@linux.alibaba.com>
 <1684598287.15044793.1653314052575.JavaMail.zimbra@kalray.eu>
 <d374b806-1816-574e-ba8b-a750a848a6b3@huawei.com>
 <1758521608.15136543.1653380033771.JavaMail.zimbra@kalray.eu>
 <1675198168.15239468.1653411635290.JavaMail.zimbra@kalray.eu>
 <317a3e67-0956-e9c2-0406-9349844ca612@gmail.com>
Subject: Re: packet stuck in qdisc : patch proposal
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.40.202]
X-Mailer: Zimbra 9.0.0_GA_4126 (ZimbraWebClient - FF100
 (Linux)/9.0.0_GA_4126)
Thread-Topic: packet stuck in qdisc : patch proposal
Thread-Index: FV/7/iaaKOuW1iLl/hf49KySDvwv6w==
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

----- On May 24, 2022, at 10:17 PM, Eric Dumazet eric.dumazet@gmail.com wrote:

> On 5/24/22 10:00, Vincent Ray wrote:
>> All,
>>
>> I confirm Eric's patch works well too, and it's better and clearer than mine.
>> So I think we should go for it, and the one from Guoju in addition.
>>
>> @Eric : I see you are one of the networking maintainers, so I have a few
>> questions for you :
>>
>> a) are you going to take care of these patches directly yourself, or is there
>> something Guoju or I should do to promote them ?
> 
> I think this is totally fine you take ownership of the patch, please
> send a formal V2.
> 
> Please double check what patchwork had to say about your V1 :
> 
> 
> https://patchwork.kernel.org/project/netdevbpf/patch/1684598287.15044793.1653314052575.JavaMail.zimbra@kalray.eu/
> 
> 
> And make sure to address the relevant points

OK I will.
If you agree, I will take your version of the fix (test_and_set_bit()), keeping the commit message
similar to my original one.

What about Guoju's patch ? 
(adding a smp_mb() between the spin_unlock() and test_bit() in qdisc_run_end()). 
I think it is also necessary though potentially less critical.
Do we embed it in the same patch ? or patch series ?

@Guoju : have you submitted it for integration ?


> The most important one is the lack of 'Signed-off-by:' tag, of course.
> 
> 
>> b) Can we expect to see them land in the mainline soon ?
> 
> If your v2 submission is correct, it can be merged this week ;)
> 
> 
>>
>> c) Will they be backported to previous versions of the kernel ? Which ones ?
> 
> You simply can include a proper Fixes: tag, so that stable teams can
> backport
> 
> the patch to all affected kernel versions.
> 

Here things get a little complicated in my head ;-)
As explained, I think this mechanism has been bugged, in a way or an other, for some time, perhaps since the introduction
of lockless qdiscs (4.16) or somewhere between 4.16 and 5.14.
It's hard to tell at a glance since the code looks quite different back then.
Because of these changes, a unique patch will also only apply up to a certain point in the past.

However, I think the bug became really critical only with the introduction of "true bypass" behavior 
in lockless qdiscs by YunSheng in 5.14, though there may be scenarios where it is a big deal 
even in no-bypass mode.

=> I suggest we only tag it for backward fix up to the 5.14, where it should apply smoothly,
 and we live with the bug for versions before that.
This would mean that 5.15 LT can be patched but no earlier LT
 
What do you think ?

BTW : forgive my ignorance, but are there any kind of "Errata Sheet" or similar for known bugs that 
won't be fixed in a given kernel ?

> 
> 
>>
>> Thanks a lot, best,
> 
> Thanks a lot for working on this long standing issue.
> 
> 
> 
> 
> To declare a filtering error, please use the following link :
> https://www.security-mail.net/reporter.php?mid=7009.628d3d4c.37c04.0&r=vray%40kalrayinc.com&s=eric.dumazet%40gmail.com&o=Re%3A+packet+stuck+in+qdisc+%3A+patch+proposal&verdict=C&c=0ca08e7b7e420d1ab014cda67db48db71df41f5f




