Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 057B762E800
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 23:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234851AbiKQWP7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 17 Nov 2022 17:15:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240496AbiKQWPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 17:15:47 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3075E7AF6A
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 14:15:41 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-135-r8pLcNsHMNSPwdstNZNmIw-1; Thu, 17 Nov 2022 22:15:38 +0000
X-MC-Unique: r8pLcNsHMNSPwdstNZNmIw-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Thu, 17 Nov
 2022 22:15:36 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.044; Thu, 17 Nov 2022 22:15:36 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Theodore Ts'o' <tytso@mit.edu>, Kees Cook <kees@kernel.org>
CC:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Kees Cook <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Thomas Bogendoerfer" <tsbogend@alpha.franken.de>,
        Heiko Carstens <hca@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        =?iso-8859-1?Q?Christoph_B=F6hmwalder?= 
        <christoph.boehmwalder@linbit.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        "Darrick J . Wong" <djwong@kernel.org>,
        SeongJae Park <sj@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Helge Deller <deller@gmx.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "ydroneaud@opteya.com" <ydroneaud@opteya.com>
Subject: RE: [PATCH v2 3/3] treewide: use get_random_u32_between() when
 possible
Thread-Topic: [PATCH v2 3/3] treewide: use get_random_u32_between() when
 possible
Thread-Index: AQHY+pt8WAMBAHgXDk6lkwvXqmmyGK5DraKg
Date:   Thu, 17 Nov 2022 22:15:36 +0000
Message-ID: <5b2afac148e24181a206e540768e465b@AcuMS.aculab.com>
References: <20221114164558.1180362-1-Jason@zx2c4.com>
 <20221114164558.1180362-4-Jason@zx2c4.com> <202211161436.A45AD719A@keescook>
 <Y3V4g8eorwiU++Y3@zx2c4.com> <Y3V6QtYMayODVDOk@zx2c4.com>
 <202211161628.164F47F@keescook> <Y3WDyl8ArQgeEoUU@zx2c4.com>
 <0EE39896-C7B6-4CB6-87D5-22AA787740A9@kernel.org> <Y3ZWbcoGOdFjlPhS@mit.edu>
In-Reply-To: <Y3ZWbcoGOdFjlPhS@mit.edu>
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
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,PDS_BAD_THREAD_QP_64,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Theodore Ts'o
> Sent: 17 November 2022 15:43
...
> The problem with "between", "ranged", "spanning" is that they don't
> tell the reader whether we're dealing with an "open interval" or a
> "closed interval".  They are just different ways of saying that it's a
> range between, say, 0 and 20.  But it doesn't tell you whether it
> includes 0 or 20 or not.
> 
> The only way I can see for making it ambiguous is either to use the
> terminology "closed interval" or "inclusive".  And "open" and "closed"
> can have other meanings, so get_random_u32_inclusive() is going to be
> less confusing than get_random_u32_closed().

It has to be said that removing the extra function and requiring
the callers use 'base + get_random_below(high [+1] - base)' is
likely to be the only way to succinctly make the code readable
and understandable.

Otherwise readers either have to look up another function to see
what it does or waste variable brain cells on more trivia.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

