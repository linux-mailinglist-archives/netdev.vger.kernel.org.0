Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA583A68FD
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 16:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232869AbhFNOas convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 14 Jun 2021 10:30:48 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:33372 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232789AbhFNOas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 10:30:48 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-11-lkZWILkuM9CPWNApqEs0ww-1; Mon, 14 Jun 2021 15:28:37 +0100
X-MC-Unique: lkZWILkuM9CPWNApqEs0ww-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 14 Jun
 2021 15:28:36 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.018; Mon, 14 Jun 2021 15:28:36 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Weihang Li' <liweihang@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        Wenpeng Liang <liangwenpeng@huawei.com>
Subject: RE: [PATCH net-next 8/8] net: phy: use '__packed' instead of
 '__attribute__((__packed__))'
Thread-Topic: [PATCH net-next 8/8] net: phy: use '__packed' instead of
 '__attribute__((__packed__))'
Thread-Index: AQHXXoypAvtg6ISf/0iVeDQMIX2EFasTlSVA
Date:   Mon, 14 Jun 2021 14:28:36 +0000
Message-ID: <7c07e865cfeb467c8f6a9eca218c5fdf@AcuMS.aculab.com>
References: <1623393419-2521-1-git-send-email-liweihang@huawei.com>
 <1623393419-2521-9-git-send-email-liweihang@huawei.com>
In-Reply-To: <1623393419-2521-9-git-send-email-liweihang@huawei.com>
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

From: Weihang Li
> Sent: 11 June 2021 07:37
> 
> Prefer __packed over __attribute__((__packed__)).
> 
> Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
> Signed-off-by: Weihang Li <liweihang@huawei.com>
> ---
>  drivers/net/phy/mscc/mscc_ptp.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/mscc/mscc_ptp.h b/drivers/net/phy/mscc/mscc_ptp.h
> index da34653..01f78b4 100644
...
>  /* Represents an entry in the timestamping FIFO */
>  struct vsc85xx_ts_fifo {
>  	u32 ns;
>  	u64 secs:48;
>  	u8 sig[16];
> -} __attribute__((__packed__));
> +} __packed;

Hmmmm I'd take some convincing that 'u64 secs:48' is anything
other than 'implementation defined'.
So using it to map a hardware structure seems wrong.

If this does map a hardware structure it ought to have
'endianness' annotations.
If it doesn't then why the bitfield and why packed?

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

