Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9822165A5D7
	for <lists+netdev@lfdr.de>; Sat, 31 Dec 2022 17:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbiLaQ5V convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 31 Dec 2022 11:57:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231643AbiLaQ5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Dec 2022 11:57:20 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A3C7A47B
        for <netdev@vger.kernel.org>; Sat, 31 Dec 2022 08:57:19 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-318-x11UyM5QMUuLS9qRDumgGA-1; Sat, 31 Dec 2022 16:57:15 +0000
X-MC-Unique: x11UyM5QMUuLS9qRDumgGA-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Sat, 31 Dec
 2022 16:57:14 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.044; Sat, 31 Dec 2022 16:57:14 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Ping-Ke Shih' <pkshih@realtek.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "tehuang@realtek.com" <tehuang@realtek.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/4] rtw88: Add packed attribute to the eFuse structs
Thread-Topic: [PATCH 1/4] rtw88: Add packed attribute to the eFuse structs
Thread-Index: AQHZGsFtJHlbRNsmYUOpTa0F4ufSPq6EmMnggAOg+qA=
Date:   Sat, 31 Dec 2022 16:57:14 +0000
Message-ID: <87da8c82dec749dc826b5a1b4c4238aa@AcuMS.aculab.com>
References: <20221228133547.633797-1-martin.blumenstingl@googlemail.com>
 <20221228133547.633797-2-martin.blumenstingl@googlemail.com>
 <92eb7dfa8b7d447e966a2751e174b642@realtek.com>
In-Reply-To: <92eb7dfa8b7d447e966a2751e174b642@realtek.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,PDS_BAD_THREAD_QP_64,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ping-Ke Shih
> Sent: 29 December 2022 09:25
> 
> > -----Original Message-----
> > From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> > Sent: Wednesday, December 28, 2022 9:36 PM
> > To: linux-wireless@vger.kernel.org
> > Cc: tony0620emma@gmail.com; kvalo@kernel.org; Ping-Ke Shih <pkshih@realtek.com>;
> tehuang@realtek.com;
> > s.hauer@pengutronix.de; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Martin Blumenstingl
> > <martin.blumenstingl@googlemail.com>
> > Subject: [PATCH 1/4] rtw88: Add packed attribute to the eFuse structs
> >
> > The eFuse definitions in the rtw88 are using structs to describe the
> > eFuse contents. Add the packed attribute to all structs used for the
> > eFuse description so the compiler doesn't add gaps or re-order
> > attributes.
> >
> > Also change the type of the res2..res3 eFuse fields to u16 to avoid the
> > following warning, now that their surrounding struct has the packed
> > attribute:
> >   note: offset of packed bit-field 'res2' has changed in GCC 4.4
> >
> > Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
> > Fixes: ab0a031ecf29 ("rtw88: 8723d: Add read_efuse to recognize efuse info from map")
> > Fixes: 769a29ce2af4 ("rtw88: 8821c: add basic functions")
> > Fixes: 87caeef032fc ("wifi: rtw88: Add rtw8723du chipset support")
> > Fixes: aff5ffd718de ("wifi: rtw88: Add rtw8821cu chipset support")
> > Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> > ---
> >  drivers/net/wireless/realtek/rtw88/main.h     |  6 +++---
> >  drivers/net/wireless/realtek/rtw88/rtw8723d.h |  6 +++---
> >  drivers/net/wireless/realtek/rtw88/rtw8821c.h | 20 +++++++++----------
> >  drivers/net/wireless/realtek/rtw88/rtw8822b.h | 20 +++++++++----------
> >  drivers/net/wireless/realtek/rtw88/rtw8822c.h | 20 +++++++++----------
> >  5 files changed, 36 insertions(+), 36 deletions(-)
> >
> 
> [...]
> 
> > @@ -43,13 +43,13 @@ struct rtw8821ce_efuse {
> >  	u8 link_cap[4];
> >  	u8 link_control[2];
> >  	u8 serial_number[8];
> > -	u8 res0:2;			/* 0xf4 */
> > -	u8 ltr_en:1;
> > -	u8 res1:2;
> > -	u8 obff:2;
> > -	u8 res2:3;
> > -	u8 obff_cap:2;
> > -	u8 res3:4;
> > +	u16 res0:2;			/* 0xf4 */
> > +	u16 ltr_en:1;
> > +	u16 res1:2;
> > +	u16 obff:2;
> > +	u16 res2:3;
> > +	u16 obff_cap:2;
> > +	u16 res3:4;
> 
> These should be __le16. Though bit fields are suitable to efuse layout,
> we don't access these fields for now. It would be well.

IIRC the assignment of actual bits to bit-fields is (at best)
architecturally defined - so isn't really suitable for anything
where the bits have to match a portable memory buffer.
The bit allocation isn't tied to the byte endianness.

To get an explicit layout you have to do explicit masking.

You also don't need __packed unless the 'natural' alignment
of fields would need gaps or the actual structure itself might
be misaligned in memory.
While C compilers are allowed to add arbitrary padding the Linux kernel
requires that they don't.
I'm also pretty sure that compilers are not allowed to reorder fields.

Specifying __packed can add considerable run-time (and code size)
overhead on some architectures - it should only be used if actually
needed.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

