Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDA41D61AA
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 17:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgEPPFB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 16 May 2020 11:05:01 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:49886 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726504AbgEPPFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 11:05:00 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-16-wTkXdC20MN--lnUe8tS_XQ-1; Sat, 16 May 2020 16:04:56 +0100
X-MC-Unique: wTkXdC20MN--lnUe8tS_XQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Sat, 16 May 2020 16:04:55 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Sat, 16 May 2020 16:04:55 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Christoph Hellwig' <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: move the SIOCDELRT and SIOCADDRT compat_ioctl handlers v2
Thread-Topic: move the SIOCDELRT and SIOCADDRT compat_ioctl handlers v2
Thread-Index: AQHWKruRvQLEg1gZy0+5cm/GoTu+NqiqzzwA
Date:   Sat, 16 May 2020 15:04:55 +0000
Message-ID: <b2fe264bfbd34aa28da7de0a1cb2ddbf@AcuMS.aculab.com>
References: <20200515131925.3855053-1-hch@lst.de>
In-Reply-To: <20200515131925.3855053-1-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Hellwig
> Sent: 15 May 2020 14:19
>
> this series moves the compat_ioctl handlers into the protocol handlers,
> avoiding the need to override the address space limited as in the current
> handler.

Is it worth moving the user copies for the main ioctl buffer
into the sys_ioctl() entry code?
(As is done by the BSD kernels.)

This would allow the compat code to adjust the buffers and pass them on.
Most ioctls don't have indirect data buffers so wouldn't need to
do any further user copies.

This would be, of course, require far more changes (and require
more external modules be fixed) than the similar change I suggested
for [sg]et_sockopt().

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

