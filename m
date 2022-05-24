Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5F7353250A
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 10:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbiEXIOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 04:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231759AbiEXIOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 04:14:00 -0400
Received: from fx408.security-mail.net (smtpout140.security-mail.net [85.31.212.148])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE36870914
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 01:13:57 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by fx408.security-mail.net (Postfix) with ESMTP id 0419A1B7B211
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 10:13:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kalrayinc.com;
        s=sec-sig-email; t=1653380036;
        bh=a9KQ8NGbD9qEbCX/qkgKwQJkOlefgoR6WoVJb/sGqJA=;
        h=Date:From:To:Cc:In-Reply-To:References:Subject;
        b=HjNo5oNd1vieD4dmYfBd/AUMPC3AgRmfsPheNDwwsFrx9fTXheG4+adwhgxmtgVOm
         wMbJzSIfy1o3vi2reUuaXeRuFKqnfl81I5T+IBr60vcWhVf2KaqjTdj5vvIOww5pog
         is5hej61KsOcwb7BjrizOvTO3/bAXRTFa0GYH0gE=
Received: from fx408 (localhost [127.0.0.1]) by fx408.security-mail.net
 (Postfix) with ESMTP id E03B81B7B1F1; Tue, 24 May 2022 10:13:54 +0200 (CEST)
Received: from zimbra2.kalray.eu (unknown [217.181.231.53]) by
 fx408.security-mail.net (Postfix) with ESMTPS id 4EFD51B7B175; Tue, 24 May
 2022 10:13:54 +0200 (CEST)
Received: from zimbra2.kalray.eu (localhost [127.0.0.1]) by
 zimbra2.kalray.eu (Postfix) with ESMTPS id 2DA0327E04AA; Tue, 24 May 2022
 10:13:54 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1]) by zimbra2.kalray.eu
 (Postfix) with ESMTP id 1378327E04AE; Tue, 24 May 2022 10:13:54 +0200 (CEST)
Received: from zimbra2.kalray.eu ([127.0.0.1]) by localhost
 (zimbra2.kalray.eu [127.0.0.1]) (amavisd-new, port 10026) with ESMTP id
 FHjPRb4ksrdl; Tue, 24 May 2022 10:13:54 +0200 (CEST)
Received: from zimbra2.kalray.eu (localhost [127.0.0.1]) by
 zimbra2.kalray.eu (Postfix) with ESMTP id F10FF27E04AA; Tue, 24 May 2022
 10:13:53 +0200 (CEST)
X-Virus-Scanned: E-securemail, by Secumail
Secumail-id: <5e06.628c93c2.4e13f.0>
DKIM-Filter: OpenDKIM Filter v2.10.3 zimbra2.kalray.eu 1378327E04AE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kalrayinc.com;
 s=4F334102-7B72-11EB-A74E-42D0B9747555; t=1653380034;
 bh=ry098VI81jXqIDcxQPF4W4BJR+PyeVJ7PLdnDrxWl+o=;
 h=Date:From:To:Message-ID:MIME-Version;
 b=ABeqCIdBjxqWVc1ILQFzXXRmF5XZTiP8ZGLtzuWd/H0O6Y17zfUj3hqun4KaEvM98
 uqL49+Ae5/3VGZY/EmDdPTcD2/NOCIPQUtOTrpVKv/Jprk6Gy/FTnEOWM5Rt52XrZw
 M15Xip0zta7CoS4vai5jQxehHDae3h14sKkpg9GgA5fdo/qSLOzKCz+W/nT8G68Ghb
 Xs1hD9LX+5UUNLXXghPYbxNQSBEBJ8eB58pn1DEQPUOgtchEIKSfuNGaxxVXv2tOOF
 7lXvUXqP6MvwWoekcmu797FvxSZraqt7aMY/+Php7P1BDD0f0pHG+a06OMRzMRlcce
 7EA5c7nXc6gkA==
Date:   Tue, 24 May 2022 10:13:53 +0200 (CEST)
From:   Vincent Ray <vray@kalrayinc.com>
To:     linyunsheng <linyunsheng@huawei.com>
Cc:     davem <davem@davemloft.net>,
        =?utf-8?b?5pa55Zu954Ks?= <guoju.fgj@alibaba-inc.com>,
        kuba <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        Samuel Jones <sjones@kalrayinc.com>,
        vladimir oltean <vladimir.oltean@nxp.com>,
        Guoju Fang <gjfang@linux.alibaba.com>,
        Remy Gauguey <rgauguey@kalrayinc.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, will@kernel.org
Message-ID: <1758521608.15136543.1653380033771.JavaMail.zimbra@kalray.eu>
In-Reply-To: <d374b806-1816-574e-ba8b-a750a848a6b3@huawei.com>
References: <1359936158.10849094.1649854873275.JavaMail.zimbra@kalray.eu>
 <2b827f3b-a9db-e1a7-0dc9-65446e07bc63@linux.alibaba.com>
 <1684598287.15044793.1653314052575.JavaMail.zimbra@kalray.eu>
 <d374b806-1816-574e-ba8b-a750a848a6b3@huawei.com>
Subject: Re: packet stuck in qdisc : patch proposal
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.40.202]
X-Mailer: Zimbra 9.0.0_GA_4126 (ZimbraWebClient - FF100
 (Linux)/9.0.0_GA_4126)
Thread-Topic: packet stuck in qdisc : patch proposal
Thread-Index: x6KQAMdWHpfJVSzfsa+krG4zXDsJSQ==
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

 
> Hi, thanks for the testing and debugging. So the main problem is that
> test_bit() is not an atomic operation, so using smp_mb __*_atomic() is
> not really helping, right?

Yes

> In that case we might only need to change smp_mb__before_atomic() to
> smp_rmb() in qdisc_run_begin(), as we only need to order test_bit()
> after set_bit() and clear_bit(), which is a read/write ordering?

I don't think so : we need to order test_bit() with respect to an earlier enqueue().
So we need a store/load barrier => smp_mb()

> By the way,  Guoju need to ensure ordering between spin_unlock() and
> test_bit() in qdisc_run_end(), which is a write/read ordering, so
> smp_mb() is used.

Agreed

But, for qdisc_run_begin(), I think Eric is right anyway, his fix, using test_and_set_bit() seems much better.
I'm going to try it and will tell you what it gives.

Thanks,

V




