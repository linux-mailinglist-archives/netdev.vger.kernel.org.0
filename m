Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBAE948ED6C
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 16:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242656AbiANPu4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 14 Jan 2022 10:50:56 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:31915 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235921AbiANPuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 10:50:55 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-253-GIvS9ALiNESe27UbGfp3lA-1; Fri, 14 Jan 2022 15:50:53 +0000
X-MC-Unique: GIvS9ALiNESe27UbGfp3lA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Fri, 14 Jan 2022 15:50:53 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Fri, 14 Jan 2022 15:50:53 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Eric Dumazet' <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "Jiri Pirko" <jiri@mellanox.com>
Subject: RE: [PATCH net] ipv4: make fib_info_cnt atomic
Thread-Topic: [PATCH net] ipv4: make fib_info_cnt atomic
Thread-Index: AQHYCVzfksLEUKQs60+YleAr3D+cVKxiqY3A
Date:   Fri, 14 Jan 2022 15:50:52 +0000
Message-ID: <2f8ea7358c17449682f7e72eaed1ce54@AcuMS.aculab.com>
References: <20220114153902.1989393-1-eric.dumazet@gmail.com>
In-Reply-To: <20220114153902.1989393-1-eric.dumazet@gmail.com>
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

From: Eric Dumazet
> Sent: 14 January 2022 15:39
> 
> Instead of making sure all free_fib_info() callers
> hold rtnl, it seems better to convert fib_info_cnt
> to an atomic_t.

Since fib_info_cnt is only used to control the size of the hash table
could it be incremented when a fid is added to the hash table and
decremented when it is removed.

This is all inside the fib_info_lock.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

