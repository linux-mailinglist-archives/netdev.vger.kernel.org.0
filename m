Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDE58258EF0
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 15:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgIANOj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 1 Sep 2020 09:14:39 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:43717 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728057AbgIANKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 09:10:34 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-124-RgJ3VotCP16CESXx20TH0w-1; Tue, 01 Sep 2020 14:10:19 +0100
X-MC-Unique: RgJ3VotCP16CESXx20TH0w-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 1 Sep 2020 14:10:18 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 1 Sep 2020 14:10:18 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Willy Tarreau' <w@1wt.eu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Sedat Dilek <sedat.dilek@gmail.com>, George Spelvin <lkml@sdf.org>,
        "Amit Klein" <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "tytso@mit.edu" <tytso@mit.edu>, Florian Westphal <fw@strlen.de>,
        Marc Plumb <lkml.mplumb@gmail.com>
Subject: RE: [PATCH 1/2] random32: make prandom_u32() output unpredictable
Thread-Topic: [PATCH 1/2] random32: make prandom_u32() output unpredictable
Thread-Index: AQHWgCtYkxpri6yNnUCyYLzB8IqNYqlTwT5w
Date:   Tue, 1 Sep 2020 13:10:18 +0000
Message-ID: <b460c51a3fa1473b8289d6030a46abdb@AcuMS.aculab.com>
References: <20200901064302.849-1-w@1wt.eu> <20200901064302.849-2-w@1wt.eu>
In-Reply-To: <20200901064302.849-2-w@1wt.eu>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willy Tarreau
> Sent: 01 September 2020 07:43
...
> +/*
> + *	Generate some initially weak seeding values to allow
> + *	the prandom_u32() engine to be started.
> + */
> +static int __init prandom_init_early(void)
> +{
> +	int i;
> +	unsigned long v0, v1, v2, v3;
> +
> +	if (!arch_get_random_long(&v0))
> +		v0 = jiffies;

Isn't jiffies likely to be zero here?

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

