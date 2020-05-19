Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B413C1D94AB
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 12:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728769AbgESKrW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 19 May 2020 06:47:22 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:36498 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726494AbgESKrV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 06:47:21 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-144-vWr0GKQJMfuAIEY_8Ti9yg-1; Tue, 19 May 2020 11:47:18 +0100
X-MC-Unique: vWr0GKQJMfuAIEY_8Ti9yg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 19 May 2020 11:47:18 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 19 May 2020 11:47:18 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>
CC:     Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: sctp doesn't honour net.ipv6.bindv6only
Thread-Topic: sctp doesn't honour net.ipv6.bindv6only
Thread-Index: AdYtySwMD5fuoEShRtCmkqkLr9/ogQ==
Date:   Tue, 19 May 2020 10:47:17 +0000
Message-ID: <62ff05456c5d4ab5953b85fff3934ba9@AcuMS.aculab.com>
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

The sctp code doesn't use sk->sk_ipv6only (which is initialised
from net.ipv6.bindv6only) but instead uses its own flag
sp->v4mapped which always defaults to 1.

There may also be an expectation that
  [gs]etsockopt(sctp_fd, IPPROTO_IPV6, IPV6_V6ONLY,...)
will access the flag that sctp uses internally.
(Matching TCP and UDP.)

Patch is trivial (remembering the inverted state)
but I don't have a clean enough source tree :-(

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

