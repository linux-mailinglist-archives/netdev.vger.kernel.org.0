Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB59A50A0FD
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 15:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386554AbiDUNnF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 21 Apr 2022 09:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236274AbiDUNmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 09:42:31 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1130436E38
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 06:39:40 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-53-Np9PkOOsNdmDk6-m1EH31g-1; Thu, 21 Apr 2022 14:39:38 +0100
X-MC-Unique: Np9PkOOsNdmDk6-m1EH31g-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Thu, 21 Apr 2022 14:39:37 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Thu, 21 Apr 2022 14:39:37 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Andrew Lunn' <andrew@lunn.ch>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eric Gratorp <Eric.Gratorp@infinera.com>
Subject: RE: Ethernet TX buffer crossing 4K boundary?
Thread-Topic: Ethernet TX buffer crossing 4K boundary?
Thread-Index: AQHYVXvl3rebTRAZhU2ZMhDjXdVWLaz6XoDw
Date:   Thu, 21 Apr 2022 13:39:37 +0000
Message-ID: <5f7abe88a55a40d9a6a7f03f9c6af48c@AcuMS.aculab.com>
References: <7e3fa36a3e16aca6fd7d00cadeeba8a8d71ceb0d.camel@infinera.com>
 <YmFO431VWIR7e2hi@lunn.ch>
In-Reply-To: <YmFO431VWIR7e2hi@lunn.ch>
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
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn
> Sent: 21 April 2022 13:33
> 
> On Wed, Apr 20, 2022 at 09:09:58PM +0000, Joakim Tjernlund wrote:
> > We have this custom Ethernet controller that cannot DMA a buffer if the buffer crosses 4K boundary.

Fix the hardware :-)

> > Any ideas how to deal with that limitation in the driver?
> 
> Does the DMA support scatter gather? You might be able to tweak the
> generic scatter gather code to generate two blocks if it crosses the
> boundary.

I'd also look at the USB3 xhci code.
That also has a perverse set of restrictions on buffer alignment.
Might give you some hints.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

