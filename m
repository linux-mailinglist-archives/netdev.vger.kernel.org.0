Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF23E231ACD
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 10:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgG2IE4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 29 Jul 2020 04:04:56 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:34525 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727986AbgG2IE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 04:04:56 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-45-qIJU1oueNGy7yWn355AN7g-1; Wed, 29 Jul 2020 09:04:52 +0100
X-MC-Unique: qIJU1oueNGy7yWn355AN7g-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 29 Jul 2020 09:04:51 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 29 Jul 2020 09:04:51 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Christoph Hellwig' <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>
CC:     Jan Engelhardt <jengelh@inai.de>, Ido Schimmel <idosch@idosch.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 2/4] net: make sockptr_is_null strict aliasing safe
Thread-Topic: [PATCH 2/4] net: make sockptr_is_null strict aliasing safe
Thread-Index: AQHWZP2RsGxHcG/UyUeqg6JjSFUVv6keMsow
Date:   Wed, 29 Jul 2020 08:04:51 +0000
Message-ID: <63bc30d717314a378064953879605e7c@AcuMS.aculab.com>
References: <20200728163836.562074-1-hch@lst.de>
 <20200728163836.562074-3-hch@lst.de>
In-Reply-To: <20200728163836.562074-3-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
> Sent: 28 July 2020 17:39
> 
> While the kernel in general is not strict aliasing safe we can trivially
> do that in sockptr_is_null without affecting code generation, so always
> check the actually assigned union member.

Even with 'strict aliasing' gcc (at least) guarantees that
the members of a union alias each other.
It is about the only way so safely interpret a float as an int.

So when sockptr_t is a union testing either member is enough.

When it is a structure the changed form almost certainly adds code.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

