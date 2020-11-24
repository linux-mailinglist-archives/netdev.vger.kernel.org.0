Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 459C42C2CAF
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 17:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390331AbgKXQTx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 24 Nov 2020 11:19:53 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:39951 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390289AbgKXQTw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 11:19:52 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-240--1M7RfZEPdaZjSdutV-hqw-1; Tue, 24 Nov 2020 16:19:48 +0000
X-MC-Unique: -1M7RfZEPdaZjSdutV-hqw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 24 Nov 2020 16:19:47 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 24 Nov 2020 16:19:47 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Arnd Bergmann' <arnd@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>
Subject: RE: [PATCH v4 1/4] ethtool: improve compat ioctl handling
Thread-Topic: [PATCH v4 1/4] ethtool: improve compat ioctl handling
Thread-Index: AQHWwnVihBpZpY3N3UWbfisKlTppO6nXdVHA
Date:   Tue, 24 Nov 2020 16:19:47 +0000
Message-ID: <4d1a587e7a9e4b65ac3a0c20554abdd3@AcuMS.aculab.com>
References: <20201124151828.169152-1-arnd@kernel.org>
 <20201124151828.169152-2-arnd@kernel.org>
In-Reply-To: <20201124151828.169152-2-arnd@kernel.org>
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

From: Arnd Bergmann
> Sent: 24 November 2020 15:18
> 
> The ethtool compat ioctl handling is hidden away in net/socket.c,
> which introduces a couple of minor oddities:
> 
...
> +
> +static int ethtool_rxnfc_copy_from_compat(struct ethtool_rxnfc *rxnfc,
> +					  const struct compat_ethtool_rxnfc __user *useraddr,
> +					  size_t size)
> +{

I think this (and possibly others) want a 'noinline_for_stack'.
So that both the normal and compat structures aren't both on the
stack when the real code is called.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

