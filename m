Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F637537860
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 12:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233882AbiE3JgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 05:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233330AbiE3JgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 05:36:17 -0400
Received: from fx303.security-mail.net (mxout.security-mail.net [85.31.212.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC4870908
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 02:36:14 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by fx303.security-mail.net (Postfix) with ESMTP id AECF132388E
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 11:36:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kalrayinc.com;
        s=sec-sig-email; t=1653903372;
        bh=se6sRXbLvh+mVxzNTzldYT4/Upx5KElyIqcq4AzKa64=;
        h=Date:From:To:Cc:In-Reply-To:References:Subject;
        b=eAW02+Kf3r2rHep2j8v+BySaO1LrcuiGOxud0XbeWwXkKZtWSEVG6f0zk5syS/8Dz
         AfvB7i2nWLOuVEwtEHz5kmaZJsb3cJgV9ps5Yy3UbipNaVPPQqBo8duYe4odz4IcZO
         wfdiBLSNdhe1j1Gb8p+ZrhY/SRCrlp8E2GU4Sy/k=
Received: from fx303 (localhost [127.0.0.1]) by fx303.security-mail.net
 (Postfix) with ESMTP id CC06E3238A9 for <netdev@vger.kernel.org>; Mon, 30
 May 2022 11:36:08 +0200 (CEST)
Received: from zimbra2.kalray.eu (unknown [217.181.231.53]) by
 fx303.security-mail.net (Postfix) with ESMTPS id 1E517323884; Mon, 30 May
 2022 11:36:08 +0200 (CEST)
Received: from zimbra2.kalray.eu (localhost [127.0.0.1]) by
 zimbra2.kalray.eu (Postfix) with ESMTPS id EFC4A27E04AC; Mon, 30 May 2022
 11:36:07 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1]) by zimbra2.kalray.eu
 (Postfix) with ESMTP id D503D27E04AD; Mon, 30 May 2022 11:36:07 +0200 (CEST)
Received: from zimbra2.kalray.eu ([127.0.0.1]) by localhost
 (zimbra2.kalray.eu [127.0.0.1]) (amavisd-new, port 10026) with ESMTP id
 qTYeLx9nQsxQ; Mon, 30 May 2022 11:36:07 +0200 (CEST)
Received: from zimbra2.kalray.eu (localhost [127.0.0.1]) by
 zimbra2.kalray.eu (Postfix) with ESMTP id BD80F27E04AC; Mon, 30 May 2022
 11:36:07 +0200 (CEST)
X-Virus-Scanned: E-securemail, by Secumail
Secumail-id: <3497.62949008.1d6b1.0>
DKIM-Filter: OpenDKIM Filter v2.10.3 zimbra2.kalray.eu D503D27E04AD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kalrayinc.com;
 s=4F334102-7B72-11EB-A74E-42D0B9747555; t=1653903367;
 bh=DW8o74ZoPQsODTd5tFB9C5MDWZFU99MRl1JA3KTcrqQ=;
 h=Date:From:To:Message-ID:MIME-Version;
 b=mMILpVmg3+DeLjIL+CYjw/soHiqJMH1VXqfK2ODGjhLNeEKZ45DSnX05X6HgfdB4g
 U5p4Phc0R5cV6ORWgO/M1a0TA/v/a2OMSNOxaHavsbvVqk1/plXVUKmd9S83HK+31o
 V1Q40c4bATfCQ61sMq/XsDecJNrHxqYZt3WD1nmkbbJnF42gkbXGo5/LpsQntuJOtb
 5LaQB20Y8DpPEoi7fZ1O8ba8z+zDj237Tpcw3gwU+BiPE/dMhjU4UGc6Bs2sWdSyA9
 63X7IMZKzBa8ZK2VHseXIN9vK8EJ42hn92FRC/Ns6Bj6QIlnKwTxZwEeRUajVO4D1A
 JdGcwjiU4LGKQ==
Date:   Mon, 30 May 2022 11:36:07 +0200 (CEST)
From:   Vincent Ray <vray@kalrayinc.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Guoju Fang <gjfang@linux.alibaba.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        linyunsheng <linyunsheng@huawei.com>,
        davem <davem@davemloft.net>,
        =?utf-8?b?5pa55Zu954Ks?= <guoju.fgj@alibaba-inc.com>,
        kuba <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        Samuel Jones <sjones@kalrayinc.com>,
        vladimir oltean <vladimir.oltean@nxp.com>,
        Remy Gauguey <rgauguey@kalrayinc.com>, will <will@kernel.org>,
        pabeni <pabeni@redhat.com>
Message-ID: <922404997.15539544.1653903367572.JavaMail.zimbra@kalray.eu>
In-Reply-To: <CANn89iKTv9nGqnUerWKm-GZvCQGoTrDA_HNZda3REwo0pLwXrg@mail.gmail.com>
References: <1359936158.10849094.1649854873275.JavaMail.zimbra@kalray.eu>
 <317a3e67-0956-e9c2-0406-9349844ca612@gmail.com>
 <1140270297.15304639.1653471897630.JavaMail.zimbra@kalray.eu>
 <60d1e5b8-dae0-38ef-4b9d-f6419861fdab@huawei.com>
 <90c70f7f-1f07-4cd7-bb41-0f708114bb80@linux.alibaba.com>
 <1010638538.15358411.1653500629126.JavaMail.zimbra@kalray.eu>
 <151424689.15358643.1653500890228.JavaMail.zimbra@kalray.eu>
 <CANn89iKTv9nGqnUerWKm-GZvCQGoTrDA_HNZda3REwo0pLwXrg@mail.gmail.com>
Subject: Re: packet stuck in qdisc : patch proposal
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.40.202]
X-Mailer: Zimbra 9.0.0_GA_4126 (ZimbraWebClient - FF100
 (Linux)/9.0.0_GA_4126)
Thread-Topic: packet stuck in qdisc : patch proposal
Thread-Index: I47pyoq8e8GokK0SODJ8BbskUeaeGw==
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



----- On May 26, 2022, at 2:17 AM, Eric Dumazet edumazet@google.com wrote:

> On Wed, May 25, 2022 at 10:48 AM Vincent Ray <vray@kalrayinc.com> wrote:
>>
> 
>> >
>> > Guoju : shouldn't you also include the same Fixes tag suggested by YunSheng ?
>> >
>> > Here's mine, attached. Hope it's well formatted this time. Tell me.
>> > I don't feel quite confident with the submission process to produce the series
>> > myself, so I'll let Eric handle it if it's ok.
>>
>> NB : from what I've understood reading some doc, as this is a fix, it's supposed
>> to go
>> in the "net" tree, so I tagged it accordingly in the Subject. Hope it's Ok
> 
> Patch was not delivered to patchwork this time.
> 
> I will resend it.
> 
> Next time, please take the time to read
> Documentation/process/submitting-patches.rst, thanks.
> 
> (line 276: No MIME, no links, no compression, no attachments.  Just plain text)
> 
> Thanks.

Yes, sorry about that Eric.
I did read the howto but somehow convinced myself that plain-text attachment was ok, and 
was confused about how / if the patch would be correctly merged into the mail thread if inlined.
Will do better next time !
Thanks,

V 

> 
> 
> To declare a filtering error, please use the following link :
> https://www.security-mail.net/reporter.php?mid=f3cf.628ec731.cdb4a.0&r=vray%40kalrayinc.com&s=edumazet%40google.com&o=Re%3A+packet+stuck+in+qdisc+%3A+patch+proposal&verdict=C&c=08b5406354e783e551d3ed8910b4278bf54f89d9




