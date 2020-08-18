Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4955249094
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 00:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgHRWKt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 18 Aug 2020 18:10:49 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:52228 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726617AbgHRWKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 18:10:49 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-191-MOpsCAT6OD-yFq5I57dCzQ-1; Tue, 18 Aug 2020 23:10:45 +0100
X-MC-Unique: MOpsCAT6OD-yFq5I57dCzQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 18 Aug 2020 23:10:44 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 18 Aug 2020 23:10:44 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
CC:     "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>
Subject: RE: [PATCH] net: sctp: Fix negotiation of the number of data streams.
Thread-Topic: [PATCH] net: sctp: Fix negotiation of the number of data
 streams.
Thread-Index: AdZ1bPXrgdZCqbhgQru55h+86tsQbgAM7skAAAJ8QtA=
Date:   Tue, 18 Aug 2020 22:10:44 +0000
Message-ID: <a71c0fced85a4f0f98b954b37c3a76ae@AcuMS.aculab.com>
References: <46079a126ad542d380add5f9ba6ffa85@AcuMS.aculab.com>
 <20200818214648.GJ3399@localhost.localdomain>
In-Reply-To: <20200818214648.GJ3399@localhost.localdomain>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0.001
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: 'Marcelo Ricardo Leitner'
> Sent: 18 August 2020 22:47
> 
> On Tue, Aug 18, 2020 at 02:36:58PM +0000, David Laight wrote:
> > The number of streams offered by the remote system was being ignored.
> > Any data sent on those streams would get discarded by the remote system.
> 
> That's quite brief and not accurate: it was only ignored if 'Xcnt <=
> stream->Xcnt'.

The number of streams (esp out ones) received from the remote
system in an INIT or INIT_ACK was ignored.
So it would always send data chunks using the number of streams
requested by the local user.
I managed to tweak our M3UA config to get invalid stream numbers
sent on both inwards and outwards connections.

I only noticed because of testing a (slightly horrid) workaround
for no longer being able to use kernel_getsockopt() to retrieve
the number of ostreams.
The number of ostreams was about the only thing we didn't trace :-(
At least my code can now obtain the correct value even for buggy
kernels.

> Other than this and the Fixes tag, LGTM. Passes the tests here. I'll
> ack the v2 then.

I wasn't sure whether DM actually wanted a V2 with the fixes
tag fixed.
I can send one tomorrow.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

