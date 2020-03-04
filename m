Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E87A3178DAE
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 10:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729262AbgCDJoM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 4 Mar 2020 04:44:12 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:53325 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729131AbgCDJoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 04:44:12 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-122-bhtjyi1VOFWcH7O_vPERPQ-1; Wed, 04 Mar 2020 09:44:08 +0000
X-MC-Unique: bhtjyi1VOFWcH7O_vPERPQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 4 Mar 2020 09:44:08 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 4 Mar 2020 09:44:08 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'David Miller' <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bruce.w.allan@intel.com" <bruce.w.allan@intel.com>,
        "jeffrey.e.pieper@intel.com" <jeffrey.e.pieper@intel.com>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>
Subject: RE: [PATCH net 1/1] e1000e: Stop tx/rx setup spinning for upwards of
 300us.
Thread-Topic: [PATCH net 1/1] e1000e: Stop tx/rx setup spinning for upwards of
 300us.
Thread-Index: AdXxfY9+FmJkPOq/QT2LrEdhM24vhgAOpSkAABQ07mA=
Date:   Wed, 4 Mar 2020 09:44:08 +0000
Message-ID: <ee1f7e3e088e49478734d46dfcb8deb8@AcuMS.aculab.com>
References: <6ef1e257642743a786c8ddd39645bba3@AcuMS.aculab.com>
 <20200303.160206.1467881674346759532.davem@davemloft.net>
In-Reply-To: <20200303.160206.1467881674346759532.davem@davemloft.net>
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

From: David Miller
> Sent: 04 March 2020 00:02
> 
> I'll let the Intel folks review and integrate this as it's a
> non-trivial change honestly.

Unfortunately I don't think anyone else properly reviewed the
original patch.

I suspect the real fix is to do a readback and rewrite.
(Assuming the hardware is ignoring the writes.)

For the 'interrupt enable' write, possibly get a reschedule
of the poll function by pretending there is more in the rx ring.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

