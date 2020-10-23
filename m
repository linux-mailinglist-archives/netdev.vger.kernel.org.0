Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 066112978ED
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 23:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1756718AbgJWVbE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 23 Oct 2020 17:31:04 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:22077 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S463362AbgJWVbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 17:31:04 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-225-2zJy8eU6MGK-8PbmwxTpVQ-1; Fri, 23 Oct 2020 22:31:00 +0100
X-MC-Unique: 2zJy8eU6MGK-8PbmwxTpVQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 23 Oct 2020 22:30:59 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 23 Oct 2020 22:30:59 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Stefano Garzarella' <sgarzare@redhat.com>,
        Colin King <colin.king@canonical.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] vsock: ratelimit unknown ioctl error message
Thread-Topic: [PATCH] vsock: ratelimit unknown ioctl error message
Thread-Index: AQHWqUY0CPRviIGx7UytnIgbPi7/0amltMKA
Date:   Fri, 23 Oct 2020 21:30:59 +0000
Message-ID: <e535c07df407444880d8b678bc215d9f@AcuMS.aculab.com>
References: <20201023122113.35517-1-colin.king@canonical.com>
 <20201023140947.kurglnklaqteovkp@steredhat>
In-Reply-To: <20201023140947.kurglnklaqteovkp@steredhat>
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
> Sent: 23 October 2020 15:10
> 
> On Fri, Oct 23, 2020 at 01:21:13PM +0100, Colin King wrote:
> >From: Colin Ian King <colin.king@canonical.com>
> >
> >When exercising the kernel with stress-ng with some ioctl tests the
> >"Unknown ioctl" error message is spamming the kernel log at a high
> >rate. Rate limit this message to reduce the noise.
> >
> >Signed-off-by: Colin Ian King <colin.king@canonical.com>
> >---
> > net/vmw_vsock/af_vsock.c | 2 +-
> > 1 file changed, 1 insertion(+), 1 deletion(-)
> >
> >diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> >index 9e93bc201cc0..b8feb9223454 100644
> >--- a/net/vmw_vsock/af_vsock.c
> >+++ b/net/vmw_vsock/af_vsock.c
> >@@ -2072,7 +2072,7 @@ static long vsock_dev_do_ioctl(struct file *filp,
> > 		break;
> >
> > 	default:
> >-		pr_err("Unknown ioctl %d\n", cmd);
> >+		pr_err_ratelimited("Unknown ioctl %d\n", cmd);
> 
> Make sense, or maybe can we remove the error message returning only the
> -EINVAL?

Isn't the canonical error for unknown ioctl codes -ENOTTY?

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

