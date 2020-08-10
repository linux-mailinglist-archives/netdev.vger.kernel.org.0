Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A513324076A
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 16:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgHJOYY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 10 Aug 2020 10:24:24 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:51575 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725979AbgHJOYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 10:24:24 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-242-D0VOpUn6OFmf6ao8J9EViQ-1; Mon, 10 Aug 2020 15:24:20 +0100
X-MC-Unique: D0VOpUn6OFmf6ao8J9EViQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 10 Aug 2020 15:24:20 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 10 Aug 2020 15:24:20 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Andrew Lunn' <andrew@lunn.ch>, Michal Kubecek <mkubecek@suse.cz>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH ethtool 3/7] ioctl: get rid of signed/unsigned comparison
 warnings
Thread-Topic: [PATCH ethtool 3/7] ioctl: get rid of signed/unsigned comparison
 warnings
Thread-Index: AQHWbyFCThu+BujXUUWrelU941xeIakxZMRQ
Date:   Mon, 10 Aug 2020 14:24:20 +0000
Message-ID: <b94959fddb0a4077b9e562704e6344e3@AcuMS.aculab.com>
References: <cover.1597007532.git.mkubecek@suse.cz>
 <0365573afe3649e47c1aa2490e1818a50613ee0a.1597007533.git.mkubecek@suse.cz>
 <20200810141924.GF2123435@lunn.ch>
In-Reply-To: <20200810141924.GF2123435@lunn.ch>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn
> > -	while (arg_num < ctx->argc) {
> > +	while (arg_num < (unsigned int)ctx->argc) {
> 
> Did you try changing ctx->argc to an unsigned int? I guess there would
> be less casts that way, and it is a more logical type for this.

My favourite solution is to use '+ 0u' to force the signed
integer to unsigned.
Less likely to hide another bug than the cast.

But changing the type is better.
I just wish they'd fix gcc so that it didn't complain
if you'd just done a test that excluded negative values.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

