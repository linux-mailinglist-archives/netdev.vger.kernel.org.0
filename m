Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33CA13A9545
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 10:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232087AbhFPIuJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 16 Jun 2021 04:50:09 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:32394 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232054AbhFPIuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 04:50:08 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-123-neNOsckdMEaptkxvYReotQ-1; Wed, 16 Jun 2021 09:48:00 +0100
X-MC-Unique: neNOsckdMEaptkxvYReotQ-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 16 Jun
 2021 09:47:59 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.018; Wed, 16 Jun 2021 09:47:59 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'liweihang' <liweihang@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>,
        liangwenpeng <liangwenpeng@huawei.com>,
        "quentin.schulz@bootlin.com" <quentin.schulz@bootlin.com>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>
Subject: RE: [PATCH net-next 8/8] net: phy: use '__packed' instead of
 '__attribute__((__packed__))'
Thread-Topic: [PATCH net-next 8/8] net: phy: use '__packed' instead of
 '__attribute__((__packed__))'
Thread-Index: AQHXXoypAvtg6ISf/0iVeDQMIX2EFasWVTWA
Date:   Wed, 16 Jun 2021 08:47:59 +0000
Message-ID: <30f32e888f9e40a5b78549609df936d0@AcuMS.aculab.com>
References: <1623393419-2521-1-git-send-email-liweihang@huawei.com>
 <1623393419-2521-9-git-send-email-liweihang@huawei.com>
 <7c07e865cfeb467c8f6a9eca218c5fdf@AcuMS.aculab.com>
 <fae9811cf0404034b0da9d14fb088df1@huawei.com>
In-Reply-To: <fae9811cf0404034b0da9d14fb088df1@huawei.com>
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

From: liweihang
> Sent: 16 June 2021 07:17
> 
> On 2021/6/14 22:28, David Laight wrote:
> > From: Weihang Li
> >> Sent: 11 June 2021 07:37
> >>
> >> Prefer __packed over __attribute__((__packed__)).
> >>
> >> Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
> >> Signed-off-by: Weihang Li <liweihang@huawei.com>
> >> ---
> >>  drivers/net/phy/mscc/mscc_ptp.h | 4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/net/phy/mscc/mscc_ptp.h b/drivers/net/phy/mscc/mscc_ptp.h
> >> index da34653..01f78b4 100644
> > ...
> >>  /* Represents an entry in the timestamping FIFO */
> >>  struct vsc85xx_ts_fifo {
> >>  	u32 ns;
> >>  	u64 secs:48;
> >>  	u8 sig[16];
> >> -} __attribute__((__packed__));
> >> +} __packed;
> >
> > Hmmmm I'd take some convincing that 'u64 secs:48' is anything
> > other than 'implementation defined'.
> > So using it to map a hardware structure seems wrong.
> >
> > If this does map a hardware structure it ought to have
> > 'endianness' annotations.
> > If it doesn't then why the bitfield and why packed?
> >
> > 	David
> 
> Hi David,
> 
> Thank you for your attention. You are right, I found the contents of structure
> vsc85xx_ts_fifo is got from hardware. But I'm not sure if any issues or warnings
> will be introduced into this driver after just changing 'u64 secs:48' to '__be64
> secs:48'.

I've just checked what this structure looks like - see https://godbolt.org/z/h4EqbMoso

Without any 'packed' annotations  'u64 secs:48' is aligned to an 8 byte
boundary, but is only 6 bytes wide (I don't use bitfields)
so the offset of 'sig' is 6 more than 'secs'.

But the size of the whole structure looks wrong.
I'd expect a hardware fifo so be a power of 2 big.
This one is 26 bytes (as above) or 28 bytes if the 'packed'
is only applied to 'secs' (which removed the 4 byte pad before
it while still allowing aligned 4-byte accesses to the structure.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

