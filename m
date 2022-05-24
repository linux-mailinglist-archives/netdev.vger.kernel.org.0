Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5EB7532F56
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 19:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238830AbiEXRAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 13:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237197AbiEXRAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 13:00:43 -0400
Received: from fx302.security-mail.net (mxout.security-mail.net [85.31.212.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6E86EB3D
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 10:00:39 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by fx302.security-mail.net (Postfix) with ESMTP id 68BA73D3B177
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 19:00:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kalrayinc.com;
        s=sec-sig-email; t=1653411637;
        bh=aVY+i1X5V0XUSDmj4kelG/i+2Fu8vfNq30cjP/a/gjk=;
        h=Date:From:To:Cc:In-Reply-To:References:Subject;
        b=U5ETibuucdzi6p2ypEJWqvePdHmiLmc0qjc0QUKcYH0cJRxq9RNAfpdN5HfjPpvJM
         tsqRpE5mqYuRrYewJ/jyXVP4ofOEqV+Pml/yB6NB+CMfoqgAN6UZ5W0tZvrobrlukW
         gJIebGZEWEcwsXg/wn1X2Q9yVwmanDNLZO/x0kfw=
Received: from fx302 (localhost [127.0.0.1]) by fx302.security-mail.net
 (Postfix) with ESMTP id 5A1F63D3B13D; Tue, 24 May 2022 19:00:36 +0200 (CEST)
Received: from zimbra2.kalray.eu (unknown [217.181.231.53]) by
 fx302.security-mail.net (Postfix) with ESMTPS id AF26C3D3B0F0; Tue, 24 May
 2022 19:00:35 +0200 (CEST)
Received: from zimbra2.kalray.eu (localhost [127.0.0.1]) by
 zimbra2.kalray.eu (Postfix) with ESMTPS id 8F35E27E04AF; Tue, 24 May 2022
 19:00:35 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1]) by zimbra2.kalray.eu
 (Postfix) with ESMTP id 74CAD27E04B1; Tue, 24 May 2022 19:00:35 +0200 (CEST)
Received: from zimbra2.kalray.eu ([127.0.0.1]) by localhost
 (zimbra2.kalray.eu [127.0.0.1]) (amavisd-new, port 10026) with ESMTP id
 9j9jpItqMQ5l; Tue, 24 May 2022 19:00:35 +0200 (CEST)
Received: from zimbra2.kalray.eu (localhost [127.0.0.1]) by
 zimbra2.kalray.eu (Postfix) with ESMTP id 5D51827E04AF; Tue, 24 May 2022
 19:00:35 +0200 (CEST)
X-Virus-Scanned: E-securemail, by Secumail
Secumail-id: <9c61.628d0f33.ade1a.0>
DKIM-Filter: OpenDKIM Filter v2.10.3 zimbra2.kalray.eu 74CAD27E04B1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kalrayinc.com;
 s=4F334102-7B72-11EB-A74E-42D0B9747555; t=1653411635;
 bh=aVY+i1X5V0XUSDmj4kelG/i+2Fu8vfNq30cjP/a/gjk=;
 h=Date:From:To:Message-ID:MIME-Version;
 b=Cc3WoxGOIH/eJ50CpohEs0cccE0X9n7Hwwpe01l+mfB+04qWPnpjyGBDpqu87/EEV
 oUYG4RrT10kdpNKF87WyroJEbmuT0EeH+EZkIKO/b9bWlIuv75SzS2Pxb1tDKJuMqK
 kjRbIQnoc5v6mCEGrLUPLU0EJrbPx58odbWJpsgN7QuzggYA6Mb/nARA7cBI50B6LE
 tVayn397aFMs+Dc9jdkiLb6ly1d/ahZBN0q2Ie1GH2hPsM9sJjjWCR1gAVzmlugr6h
 cMII+/DqK3OzTPC4IJ2fa3M6IR1IZTzUvRJM/yXwgzvaix+r15fZrQX93kZ4KexLTo
 s/MGTzOgOhXAQ==
Date:   Tue, 24 May 2022 19:00:35 +0200 (CEST)
From:   Vincent Ray <vray@kalrayinc.com>
To:     linyunsheng <linyunsheng@huawei.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem <davem@davemloft.net>,
        =?utf-8?b?5pa55Zu954Ks?= <guoju.fgj@alibaba-inc.com>,
        kuba <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        Samuel Jones <sjones@kalrayinc.com>,
        vladimir oltean <vladimir.oltean@nxp.com>,
        Guoju Fang <gjfang@linux.alibaba.com>,
        Remy Gauguey <rgauguey@kalrayinc.com>, will <will@kernel.org>
Message-ID: <1675198168.15239468.1653411635290.JavaMail.zimbra@kalray.eu>
In-Reply-To: <1758521608.15136543.1653380033771.JavaMail.zimbra@kalray.eu>
References: <1359936158.10849094.1649854873275.JavaMail.zimbra@kalray.eu>
 <2b827f3b-a9db-e1a7-0dc9-65446e07bc63@linux.alibaba.com>
 <1684598287.15044793.1653314052575.JavaMail.zimbra@kalray.eu>
 <d374b806-1816-574e-ba8b-a750a848a6b3@huawei.com>
 <1758521608.15136543.1653380033771.JavaMail.zimbra@kalray.eu>
Subject: Re: packet stuck in qdisc : patch proposal
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.40.202]
X-Mailer: Zimbra 9.0.0_GA_4126 (ZimbraWebClient - FF100
 (Linux)/9.0.0_GA_4126)
Thread-Topic: packet stuck in qdisc : patch proposal
Thread-Index: x6KQAMdWHpfJVSzfsa+krG4zXDsJSVJHpQNA
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

All,

I confirm Eric's patch works well too, and it's better and clearer than mine.
So I think we should go for it, and the one from Guoju in addition.

@Eric : I see you are one of the networking maintainers, so I have a few questions for you :

a) are you going to take care of these patches directly yourself, or is there something Guoju or I should do to promote them ?

b) Can we expect to see them land in the mainline soon ?

c) Will they be backported to previous versions of the kernel ? Which ones ?

Thanks a lot, best,

V




