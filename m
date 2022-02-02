Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE6634A7656
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 17:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345937AbiBBQ62 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 2 Feb 2022 11:58:28 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:40727 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346070AbiBBQ60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 11:58:26 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-191-lpJoF_iXPem6MDZ-pELlZA-1; Wed, 02 Feb 2022 16:58:24 +0000
X-MC-Unique: lpJoF_iXPem6MDZ-pELlZA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Wed, 2 Feb 2022 16:58:22 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Wed, 2 Feb 2022 16:58:22 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>
Subject: Getting the IPv6 'prefix_len' for DHCP6 assigned addresses.
Thread-Topic: Getting the IPv6 'prefix_len' for DHCP6 assigned addresses.
Thread-Index: AdgYVDaKcmxvhRE6TKuESvE9KYEi9Q==
Date:   Wed, 2 Feb 2022 16:58:22 +0000
Message-ID: <58dfe4b57faa4ead8a90c3fe924850c2@AcuMS.aculab.com>
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

I'm trying to work out how DHCP6 is supposed to work.

I've a test network with the ISC dhcp6 server and radvd running.
If I enable 'autoconf' I get a nice address with the prefix from
radvd and the last 8 bytes from my mac address, prefix_len 64.
I get a nice address from dhcp6 (busybox udhcpc6) with the same prefix.

udhcpc6 runs my scripts and 'ip add $ipv6 dev $interface' adds the address.
But the associated prefix_len is /128.

All the documentation for DHCP6 says the prefix_len (and probably the
default route - but I've not got that far) should come from the network
(I think from RA messages).

But I can't get it to work, and google searches just seem to show
everyone else having the same problem.

The only code I've found that looks at the prefix_len from RA messages
is that which adds to 'autoconf' addresses - and that refuses to do
anything unless the prefix_len is 64.

I can't see anything that would change the prefix_len of an address
that dhcp6 added.

Has something fallen down a big crack?

Kernel is 5.10.84 (LTS) - but I don't think anything relevant
will have changed.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

