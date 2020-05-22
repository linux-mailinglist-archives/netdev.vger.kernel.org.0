Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3F031DE179
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 10:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728648AbgEVICQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 22 May 2020 04:02:16 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:45932 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728402AbgEVICP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 04:02:15 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-271-rF4uGb-jMuOP63oDQYxHmg-1; Fri, 22 May 2020 09:02:10 +0100
X-MC-Unique: rF4uGb-jMuOP63oDQYxHmg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 22 May 2020 09:02:09 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 22 May 2020 09:02:09 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Christoph Hellwig' <hch@lst.de>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: do a single memdup_user in sctp_setsockopt
Thread-Topic: do a single memdup_user in sctp_setsockopt
Thread-Index: AQHWL5hibpEyDKsV4UyRPKuzFFnyuaizvkKg
Date:   Fri, 22 May 2020 08:02:09 +0000
Message-ID: <348217b7a3e14c1fa4868e47362be9c5@AcuMS.aculab.com>
References: <20200521174724.2635475-1-hch@lst.de>
In-Reply-To: <20200521174724.2635475-1-hch@lst.de>
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

From: Christoph Hellwig
> Sent: 21 May 2020 18:47
> based on the review of Davids patch to do something similar I dusted off
> the series I had started a few days ago to move the memdup_user or
> copy_from_user from the inidividual sockopts into sctp_setsockopt,
> which is done with one patch per option, so it might suit Marcelo's
> taste a bit better.  I did not start any work on getsockopt.

I'm not sure that 49 patches is actually any easier to review.
Most of the patches are just repetitions of the same change.
If they were in different files it might be different.

If you try to do getsockopt() the same way it will be much
more complicated - you have to know whether the called function
did the copy_to_user() and then suppress it.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

