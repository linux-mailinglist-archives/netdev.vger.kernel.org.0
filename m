Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B14E13090BD
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 00:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbhA2Xs4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 29 Jan 2021 18:48:56 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:59147 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231156AbhA2Xsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 18:48:53 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-174-N513bYxuPoqZK1qa1Axm_A-1; Fri, 29 Jan 2021 23:47:13 +0000
X-MC-Unique: N513bYxuPoqZK1qa1Axm_A-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 29 Jan 2021 23:47:14 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 29 Jan 2021 23:47:14 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Matthew Wilcox' <willy@infradead.org>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Shoaib Rao <rao.shoaib@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "andy.rudoff@intel.com" <andy.rudoff@intel.com>
Subject: RE: [PATCH] af_unix: Allow Unix sockets to raise SIGURG
Thread-Topic: [PATCH] af_unix: Allow Unix sockets to raise SIGURG
Thread-Index: AQHW9oaDqv48RJCczk2sHQ3JiT7IG6o/Q1OQ
Date:   Fri, 29 Jan 2021 23:47:14 +0000
Message-ID: <ee13e83b22b7411c97a2a961015343d1@AcuMS.aculab.com>
References: <20210122150638.210444-1-willy@infradead.org>
 <20210125153650.18c84b1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <23fc3de2-7541-04c9-a56f-4006a7dc773f@oracle.com>
 <20210129110605.54df8409@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <a21dc26a-87dc-18c8-b8bd-24f9797afbad@oracle.com>
 <20210129120250.269c366d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <cef52fb0-43cb-9038-7e48-906b58b356b6@oracle.com>
 <20210129121837.467280fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <e1047be3-2d53-49d3-67b4-a2a99e0c0f0f@oracle.com>
 <20210129131820.4b97fdeb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210129213217.GD308988@casper.infradead.org>
In-Reply-To: <20210129213217.GD308988@casper.infradead.org>
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
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I'd encourage anyone thinking about "using OOB" to read
> https://tools.ietf.org/html/rfc6093 first.  Basically, TCP does not
> actually provide an OOB mechanism, and frankly Unix sockets shouldn't
> try either.

OOB data maps much better onto ISO transport 'expedited data'
than anything in a bytestream protocol like TCP.
There you can send a message (it is message oriented) that isn't
subject to normal data flow control.
The length is limited (IIRC 32 bytes) and expedited data has
its own credit of one, but can overtake (and is expected to
overtake) flow control blocked normal data.

All TCP provides is a byte sequence number for OOB data.
This is just a marker in the bytestream.
It really doesn't map onto the socket OOB data data all.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

