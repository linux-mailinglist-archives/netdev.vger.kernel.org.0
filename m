Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA1F545BFA7
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 13:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343600AbhKXNAq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 24 Nov 2021 08:00:46 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:48258 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347430AbhKXM6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 07:58:48 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-22-WKI3SBmSPiWUHhGnTY3BDg-1; Wed, 24 Nov 2021 12:55:34 +0000
X-MC-Unique: WKI3SBmSPiWUHhGnTY3BDg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Wed, 24 Nov 2021 12:55:33 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Wed, 24 Nov 2021 12:55:33 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Ido Schimmel' <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "nikolay@nvidia.com" <nikolay@nvidia.com>,
        "roopa@nvidia.com" <roopa@nvidia.com>,
        "bernard@vivo.com" <bernard@vivo.com>,
        "mlxsw@nvidia.com" <mlxsw@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: RE: [PATCH net-next] net: bridge: Allow base 16 inputs in sysfs
Thread-Topic: [PATCH net-next] net: bridge: Allow base 16 inputs in sysfs
Thread-Index: AQHX4Rux94C+/KMIJEaCQPzLh3oSqKwSofIg
Date:   Wed, 24 Nov 2021 12:55:33 +0000
Message-ID: <03c0d0b106954d24aba1f7417a41349f@AcuMS.aculab.com>
References: <20211124101122.3321496-1-idosch@idosch.org>
In-Reply-To: <20211124101122.3321496-1-idosch@idosch.org>
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

From: Ido Schimmel
> Sent: 24 November 2021 10:11
>
> Cited commit converted simple_strtoul() to kstrtoul() as suggested by
> the former's documentation. However, it also forced all the inputs to be
> decimal resulting in user space breakage.
> 
> Fix by setting the base to '0' so that the base is automatically
> detected.

Do both functions ignore leading whitespace?

I recently had to fix some code that did:
	if (write(sys_class_led_fd, on ? "255" : "  0", 3) != 3)
		return error.
I'm pretty sure I'd tested it before and it worked ok.
But I had to use "000" with a later kernel.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

