Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F24463E557
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 00:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbiK3XUO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 30 Nov 2022 18:20:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbiK3XTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 18:19:49 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E930CF7
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 15:12:54 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-20-Ail7hLe4PC6pK14wdk6TGw-1; Wed, 30 Nov 2022 23:12:16 +0000
X-MC-Unique: Ail7hLe4PC6pK14wdk6TGw-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 30 Nov
 2022 23:12:15 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.044; Wed, 30 Nov 2022 23:12:15 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Andrew Lunn' <andrew@lunn.ch>, Brian Masney <bmasney@redhat.com>
CC:     "irusskikh@marvell.com" <irusskikh@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cth451@gmail.com" <cth451@gmail.com>
Subject: RE: [PATCH] net: atlantic: fix check for invalid ethernet addresses
Thread-Topic: [PATCH] net: atlantic: fix check for invalid ethernet addresses
Thread-Index: AQHZBQNlZXesXr8LFkOm0c8QYDoVsa5YF2cw
Date:   Wed, 30 Nov 2022 23:12:15 +0000
Message-ID: <3adb7dc622a3429782ca89e83c8e020d@AcuMS.aculab.com>
References: <20221130174259.1591567-1-bmasney@redhat.com>
 <Y4ex6WqiY8IdwfHe@lunn.ch> <Y4fGORYQRfYTabH1@x1> <Y4fMBl6sv+SUyt9Z@lunn.ch>
In-Reply-To: <Y4fMBl6sv+SUyt9Z@lunn.ch>
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
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,PDS_BAD_THREAD_QP_64,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn
> Sent: 30 November 2022 21:33
...
> > That won't work for this board since that function only checks that the
> > MAC "is not 00:00:00:00:00:00, is not a multicast address, and is not
> > FF:FF:FF:FF:FF:FF." The MAC address that we get on all of our boards is
> > 00:17:b6:00:00:00.
> 
> Which is a valid MAC address. So i don't see why the kernel should
> reject it and use a random one.

It isn't very valid...
The first three bytes are the mulicast, local and company bits.
So the last three bytes being zero indicate you have the
very first address the company allocated.
Pretty much zero chance of that board ever working well
enough to be in a system.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

