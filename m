Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE08E664091
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 13:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238387AbjAJMek convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 10 Jan 2023 07:34:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233172AbjAJMei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 07:34:38 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C153C382
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 04:34:35 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-319-CqCJCDyUO0CLmH1_J02gWQ-1; Tue, 10 Jan 2023 12:34:32 +0000
X-MC-Unique: CqCJCDyUO0CLmH1_J02gWQ-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 10 Jan
 2023 12:34:31 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.044; Tue, 10 Jan 2023 12:34:31 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Kalle Valo' <kvalo@kernel.org>
CC:     'Martin Blumenstingl' <martin.blumenstingl@googlemail.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "tehuang@realtek.com" <tehuang@realtek.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/4] rtw88: Add packed attribute to the eFuse structs
Thread-Topic: [PATCH 1/4] rtw88: Add packed attribute to the eFuse structs
Thread-Index: AQHZJOt8b7TA8qgUUEi14rUuSBslva6Xj6GQ
Date:   Tue, 10 Jan 2023 12:34:31 +0000
Message-ID: <7f75a99604394c47bd646c6a024cb27a@AcuMS.aculab.com>
References: <20221228133547.633797-1-martin.blumenstingl@googlemail.com>
        <20221228133547.633797-2-martin.blumenstingl@googlemail.com>
        <92eb7dfa8b7d447e966a2751e174b642@realtek.com>
        <87da8c82dec749dc826b5a1b4c4238aa@AcuMS.aculab.com>
        <eee17e2f4e44a2f38021a839dc39fedc1c1a4141.camel@realtek.com>
        <a86893f11fe64930897473a38226a9a8@AcuMS.aculab.com>
        <5c0c77240e7ddfdffbd771ee7e50d36ef3af9c84.camel@realtek.com>
        <CAFBinCC+1jGJx1McnBY+kr3RTQ-UpxW6JYNpHzStUTredDuCug@mail.gmail.com>
        <ec6a0988f3f943128e0122d50959185a@AcuMS.aculab.com>
 <87r0w2fvgz.fsf@kernel.org>
In-Reply-To: <87r0w2fvgz.fsf@kernel.org>
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

From: Kalle Valo
> Sent: 10 January 2023 12:03
...
> > Most hardware definitions align everything.
> >
> > What you may want to do is add compile-time asserts for the
> > sizes of the structures.
> >
> > Remember that if you have 16/32 bit fields in packed structures
> > on some architectures the compile has to generate code that does
> > byte loads and shifts.
> >
> > The 'misaligned' property is lost when you take the address - so
> > you can easily generate a fault.
> >
> > Adding __packed to a struct is a sledgehammer you really shouldn't need.
> 
> Avoiding use of __packed is news to me, but is this really a safe rule?
> Most of the wireless engineers are no compiler experts (myself included)
> so I'm worried. For example, in ath10k and ath11k I try to use __packed
> for all structs which are accessing hardware or firmware just to make
> sure that the compiler is not changing anything.

What may wish to do is get the compiler to generate an error if
it would add any padding - but that isn't what __packed is for
or what it does.

The compiler will only ever add padding to ensure that fields
are correctly aligned (usually a multiple of their size).
There can also be padding at the end of a structure so that arrays
are aligned.
There are some unusual ABI that align all structures on 4 byte
boundaries - but i don't think Linux has any of them.
In any case this rarely matters.

All structures that hardware/firmware access are very likely
to have everything on its natural alignment unless you have a very
old structure hat might have a 16bit aligned 32bit value that
was assumed to be two words.

Now if you have:
struct {
	char	a[4];
	int	b;
} __packed foo;
whenever you access foo.b the compiler might have to generate
4 separate byte memory accesses and a load of shift/and/or
instructions in order to avoid a misaligned address trap.
So you don't want to use __packed unless the field is actually
expected to be misaligned.
For most hardware/firmware structures this isn't true.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

