Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44FE927293B
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 16:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727666AbgIUO56 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 21 Sep 2020 10:57:58 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:28675 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726430AbgIUO56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 10:57:58 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-131-fTlCPAkmNqyVcSMjZfvb1A-1; Mon, 21 Sep 2020 15:57:54 +0100
X-MC-Unique: fTlCPAkmNqyVcSMjZfvb1A-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 21 Sep 2020 15:57:53 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 21 Sep 2020 15:57:53 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Christoph Hellwig' <hch@infradead.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: RE: [PATCH 3/9 next] lib/iov_iter: Improved function for importing
 iovec[] from userpace.
Thread-Topic: [PATCH 3/9 next] lib/iov_iter: Improved function for importing
 iovec[] from userpace.
Thread-Index: AdaLbgrHxt5yVpCaR/OQiuIAS4DQuQEqpZKAAAOMgSA=
Date:   Mon, 21 Sep 2020 14:57:53 +0000
Message-ID: <715ff68740fe4f1eb2c7713584450f1e@AcuMS.aculab.com>
References: <a24498efacd94e61a2af9df3976b0de6@AcuMS.aculab.com>
 <20200921141051.GC24515@infradead.org>
In-Reply-To: <20200921141051.GC24515@infradead.org>
Accept-Language: en-GB, en-US
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
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Hellwig
> Sent: 21 September 2020 15:11
> 
> On Tue, Sep 15, 2020 at 02:55:17PM +0000, David Laight wrote:
> >
> > import_iovec() has a 'pointer by reference' parameter to pass in the
> > (on-stack) iov[] cache and return the address of a larger copy that
> > the caller must free.
> > This is non-intuitive, faffy to setup, and not that efficient.
> > Instead just pass in the address of the cache and return the address
> > to free (on success) or PTR_ERR() (on error).
> 
> To me it seems pretty sensible, and in fact the conversions to your
> new API seem to add more lines than they remove.

They probably add a line because the two variables get defined on
separate lines.

The problem is the inefficiency of passing the addresses by 'double
reference'.
Although your suggestion of putting the 'address to free' in the
same structure as the cache does resolve that.
It also gets rid of all the PTR_ERR() faffing.
Still probably best to return 0 on success.
Plenty of code was converting the +ve to 0.

I might to a v2 on top of your compat iovec changes - once they
hit Linus's tree.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

