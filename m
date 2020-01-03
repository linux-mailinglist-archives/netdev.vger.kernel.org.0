Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6E0B12F5B3
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 09:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727404AbgACIrp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 3 Jan 2020 03:47:45 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:55560 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725972AbgACIro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 03:47:44 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id uk-mta-4-jhwEWOrINo2lwVFTKiwkcA-1;
 Fri, 03 Jan 2020 08:47:41 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 3 Jan 2020 08:47:40 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 3 Jan 2020 08:47:40 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'Luck, Tony'" <tony.luck@intel.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>
CC:     David Miller <davem@davemloft.net>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "luto@kernel.org" <luto@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: RE: [PATCH] drivers/net/b44: Change to non-atomic bit operations
Thread-Topic: [PATCH] drivers/net/b44: Change to non-atomic bit operations
Thread-Index: AQHVt4u4RnJ8wHjyUkiWRBJZ56DwGKfKiKsAgAAOgACAAUJyAIAL6e1QgADxkEA=
Date:   Fri, 3 Jan 2020 08:47:40 +0000
Message-ID: <884d937e56ba4a91abad0d1e42cc2dd4@AcuMS.aculab.com>
References: <1576884551-9518-1-git-send-email-fenghua.yu@intel.com>
        <20191224.161826.37676943451935844.davem@davemloft.net>
        <20191225011020.GE241295@romley-ivt3.sc.intel.com>
 <20191225122424.5bc18036@hermes.lan>
 <3908561D78D1C84285E8C5FCA982C28F7F515CBB@ORSMSX115.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F7F515CBB@ORSMSX115.amr.corp.intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: jhwEWOrINo2lwVFTKiwkcA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luck, Tony
> Sent: 02 January 2020 18:23
> 
> > Why not just make pwol_pattern aligned and choose the right word to do
> > the operation on?
> 
> We use that approach for places where the operation needs to be atomic.
> 
> But this one doesn't need an atomic operation since there can be no other
> entity operating on the same bitmap in parallel.

From what I remember this code is setting up a bitmap that is transferred
to the hardware (it might be the multicast filter).
As such it shouldn't be relying on the implementation of the bitmap
functions (which operate on long[]) to generate the required byte map
required by the hardware.

The code is horrid.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

