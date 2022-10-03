Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA3B5F2E50
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 11:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiJCJnR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 3 Oct 2022 05:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbiJCJmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 05:42:49 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2B752467
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 02:37:18 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-164-EXXU3AVOMbmkJ1Ef--quHg-1; Mon, 03 Oct 2022 10:36:53 +0100
X-MC-Unique: EXXU3AVOMbmkJ1Ef--quHg-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Mon, 3 Oct
 2022 10:36:46 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.040; Mon, 3 Oct 2022 10:36:46 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Al Viro' <viro@zeniv.linux.org.uk>
CC:     "'Eric W. Biederman'" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: RE: [CFT][PATCH] proc: Update /proc/net to point at the accessing
 threads network namespace
Thread-Topic: [CFT][PATCH] proc: Update /proc/net to point at the accessing
 threads network namespace
Thread-Index: AQHY1Ogi381Lc0KOOEGaF1/0a4qSLq34eHYAgAGjVQCAAk+PUA==
Date:   Mon, 3 Oct 2022 09:36:46 +0000
Message-ID: <592405fa149247f58d05a213b8c6f711@AcuMS.aculab.com>
References: <YzXrOFpPStEwZH/O@ZenIV>
 <CAHk-=wjLgM06JrS21W4g2VquqCLab+qu_My67cv6xuH7NhgHpw@mail.gmail.com>
 <YzXzXNAgcJeJ3M0d@ZenIV> <YzYK7k3tgZy3Pwht@ZenIV>
 <CAHk-=wihPFFE5KcsmOnOm1CALQDWqC1JTvrwSGBS08N5avVmEA@mail.gmail.com>
 <871qrt4ymg.fsf@email.froward.int.ebiederm.org>
 <87ill53igy.fsf_-_@email.froward.int.ebiederm.org>
 <ea14288676b045c29960651a649d66b9@AcuMS.aculab.com>
 <87a66g25wm.fsf@email.froward.int.ebiederm.org>
 <9bf5e96b383e4a979618cb0f729cb833@AcuMS.aculab.com> <YzjJNnzRTiSpwXHV@ZenIV>
In-Reply-To: <YzjJNnzRTiSpwXHV@ZenIV>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

...
> * ability to chroot(2) had always been equivalent to ability to undo
> chroot(2).  If you want to prevent getting out of there, you need
> (among other things) to prevent the processes to be confined from
> further chroot(2).

Not always, certainly not historically.
chroot() inside a chroot() just constrained you further.
If fchdir() and openat() have broken that it is a serious
problem.

NetBSD certainly has checks to detect (log and fix)
programs that have (or might) escape from chroots.

unshare() seems to create a 'shadow' inode structure
for the chroot's "/" so at least some of the tests
when following ".." fail to detect it.

I also thought containers relied on the same scheme?
(But I'm too old fashioned to have looked into them!)

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

