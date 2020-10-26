Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D032F2989B5
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 10:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1768344AbgJZJqW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 26 Oct 2020 05:46:22 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:44186 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1768336AbgJZJqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 05:46:21 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mtapsc-6-JpohbFICN5eunT0tPS-E1w-1; Mon, 26 Oct 2020 09:46:17 +0000
X-MC-Unique: JpohbFICN5eunT0tPS-E1w-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 26 Oct 2020 09:46:17 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 26 Oct 2020 09:46:17 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Stefano Garzarella' <sgarzare@redhat.com>
CC:     Colin King <colin.king@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] vsock: ratelimit unknown ioctl error message
Thread-Topic: [PATCH] vsock: ratelimit unknown ioctl error message
Thread-Index: AQHWqUY0CPRviIGx7UytnIgbPi7/0amltMKAgAPgtgCAAAejEIAACBeAgAAAcdA=
Date:   Mon, 26 Oct 2020 09:46:17 +0000
Message-ID: <3e34e4121f794355891fd7577c9dfbc0@AcuMS.aculab.com>
References: <20201023122113.35517-1-colin.king@canonical.com>
 <20201023140947.kurglnklaqteovkp@steredhat>
 <e535c07df407444880d8b678bc215d9f@AcuMS.aculab.com>
 <20201026084300.5ag24vck3zeb4mcz@steredhat>
 <d893e3251f804cffa797b6eb814944fd@AcuMS.aculab.com>
 <20201026093917.5zgginii65pq6ezd@steredhat>
In-Reply-To: <20201026093917.5zgginii65pq6ezd@steredhat>
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

From: Stefano Garzarella
> Sent: 26 October 2020 09:39
> 
> On Mon, Oct 26, 2020 at 09:13:23AM +0000, David Laight wrote:
> >From: Stefano Garzarella
> >> Sent: 26 October 2020 08:43
> >...
> >> >Isn't the canonical error for unknown ioctl codes -ENOTTY?
> >> >
> >>
> >> Oh, thanks for pointing that out!
> >>
> >> I had not paid attention to the error returned, but looking at it I
> >> noticed that perhaps the most appropriate would be -ENOIOCTLCMD.
> >> In the ioctl syscall we return -ENOTTY, if the callback returns
> >> -ENOIOCTLCMD.
> >>
> >> What do you think?
> >
> >It is 729 v 443 in favour of ENOTTY (based on grep).
> 
> Under net/ it is 6 vs 83 in favour of ENOIOCTLCMD.
> 
> >
> >No idea where ENOIOCTLCMD comes from, but ENOTTY probably
> >goes back to the early 1970s.
> 
> Me too.
> 
> >
> >The fact that the ioctl wrapper converts the value is a good
> >hint that userspace expects ENOTTY.
> 
> Agree on that, but since we are not interfacing directly with userspace,
> I think it is better to return the more specific error (ENOIOCTLCMD).

I bet Linux thought it could use a different error code then
found that 'unknown ioctl' was spelt ENOTTY.

Back in the old days error values were probably almost unique.
strerror(EAGIAN) was "No more processes" for a long time!

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

