Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C98F22F27F
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 16:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729228AbgG0OkS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 27 Jul 2020 10:40:18 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:40887 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729587AbgG0OJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 10:09:15 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-250-GXr1mpTxOlmxyosLYcC-jw-1; Mon, 27 Jul 2020 15:09:11 +0100
X-MC-Unique: GXr1mpTxOlmxyosLYcC-jw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 27 Jul 2020 15:09:10 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 27 Jul 2020 15:09:10 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Al Viro' <viro@zeniv.linux.org.uk>
CC:     'David Miller' <davem@davemloft.net>, "hch@lst.de" <hch@lst.de>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "linux-hams@vger.kernel.org" <linux-hams@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "dccp@vger.kernel.org" <dccp@vger.kernel.org>,
        "linux-decnet-user@lists.sourceforge.net" 
        <linux-decnet-user@lists.sourceforge.net>,
        "linux-wpan@vger.kernel.org" <linux-wpan@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "mptcp@lists.01.org" <mptcp@lists.01.org>,
        "lvs-devel@vger.kernel.org" <lvs-devel@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "linux-x25@vger.kernel.org" <linux-x25@vger.kernel.org>
Subject: RE: get rid of the address_space override in setsockopt v2
Thread-Topic: get rid of the address_space override in setsockopt v2
Thread-Index: AQHWYgvqDt5Xt3HFu0u82UKLVqcKxKkbLTEQgAA3GQCAABNbQA==
Date:   Mon, 27 Jul 2020 14:09:09 +0000
Message-ID: <5d958e937db54849b4ef9046e7e12277@AcuMS.aculab.com>
References: <20200723060908.50081-1-hch@lst.de>
 <20200724.154342.1433271593505001306.davem@davemloft.net>
 <8ae792c27f144d4bb5cbea0c1cce4eed@AcuMS.aculab.com>
 <20200727134814.GD794331@ZenIV.linux.org.uk>
In-Reply-To: <20200727134814.GD794331@ZenIV.linux.org.uk>
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

From: Al Viro
> Sent: 27 July 2020 14:48
> 
> On Mon, Jul 27, 2020 at 09:51:45AM +0000, David Laight wrote:
> 
> > I'm sure there is code that processes options in chunks.
> > This probably means it is possible to put a chunk boundary
> > at the end of userspace and continue processing the very start
> > of kernel memory.
> >
> > At best this faults on the kernel copy code and crashes the system.
> 
> Really?  Care to provide some details, or is it another of your "I can't
> be possibly arsed to check what I'm saying, but it stands for reason
> that..." specials?

I did more 'homework' than sometimes :-)
Slightly difficult without a searchable net-next tree.
However, as has been pointed out is a different thread
this code is used to update IPv6 flow labels:

> > -		if (copy_from_user(fl->opt+1, optval+CMSG_ALIGN(sizeof(*freq)), olen))
> > +		sockptr_advance(optval, CMSG_ALIGN(sizeof(*freq)));
> > +		if (copy_from_sockptr(fl->opt + 1, optval, olen))
> >  			goto done;

and doesn't work because the advances are no longer cumulative.

Now access_ok() has to take the base address and length to stop
'running into' kernel space, but the code above can advance from
a valid user pointer (which won't fault) to a kernel address.

If there were always an unmapped 'guard' page in the user address
space the access_ok() check prior to copy_to/from_user() wouldn't
need the length.
So I surmise that no such guard page exists and so the above
can advance from user addresses into kernel ones.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

