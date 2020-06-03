Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470AF1ECB13
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 10:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbgFCIIb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 3 Jun 2020 04:08:31 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:21191 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725828AbgFCIIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 04:08:30 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-172-_4y6Z0HxOsCLflypv4x5zQ-1; Wed, 03 Jun 2020 09:08:17 +0100
X-MC-Unique: _4y6Z0HxOsCLflypv4x5zQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 3 Jun 2020 09:08:17 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 3 Jun 2020 09:08:17 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Al Viro' <viro@zeniv.linux.org.uk>
CC:     "'Michael S. Tsirkin'" <mst@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Subject: RE: [PATCH RFC] uaccess: user_access_begin_after_access_ok()
Thread-Topic: [PATCH RFC] uaccess: user_access_begin_after_access_ok()
Thread-Index: AQHWOR0GBiAzsIPf10apeP3ZClgqcqjFyCZAgAAGv4CAALncwA==
Date:   Wed, 3 Jun 2020 08:08:17 +0000
Message-ID: <a6d865f0dc7a427bb180cf451b8d470f@AcuMS.aculab.com>
References: <20200602084257.134555-1-mst@redhat.com>
 <fc204429-7a6e-8214-a66f-bf2676018aae@redhat.com>
 <20200602163306.GM23230@ZenIV.linux.org.uk>
 <CAHk-=wjgg0bpD0qjYF=twJNXmRXYPjXqO1EFLL-mS8qUphe0AQ@mail.gmail.com>
 <20200602162931-mutt-send-email-mst@kernel.org>
 <950896ceff2d44e8aaf6f9f5fab210e4@AcuMS.aculab.com>
 <20200602215827.GP23230@ZenIV.linux.org.uk>
In-Reply-To: <20200602215827.GP23230@ZenIV.linux.org.uk>
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

From: Al Viro <viro@ftp.linux.org.uk> On Behalf Of Al Viro
> Sent: 02 June 2020 22:58
> On Tue, Jun 02, 2020 at 08:41:38PM +0000, David Laight wrote:
> 
> > In which case you need a 'user_access_begin' that takes the mm
> > as an additional parameter.
> 
> 	What does any of that have to do with mm?  Details, please.

Actually probably nothing.

I was sort of thinking that maybe the user process's memory
map (mm?) would be temporarily 'attached' to the kernel thread
so that it used the normal copy_to/from_user() fault
handling to access the 'other' process.

In which case you'd want to do the bound check against the
limit of the user addresses in the mm rather than those of
the current process.

But later posts probably imply that it is all done differently.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

