Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0F11270EAA
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 16:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbgISOyS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 19 Sep 2020 10:54:18 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:20493 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726493AbgISOyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 10:54:17 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-123-Q8cAoOVtN9-3ia4vwC15wg-1; Sat, 19 Sep 2020 15:53:09 +0100
X-MC-Unique: Q8cAoOVtN9-3ia4vwC15wg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Sat, 19 Sep 2020 15:53:08 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Sat, 19 Sep 2020 15:53:08 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Al Viro' <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>
Subject: RE: [PATCH 1/9] kernel: add a PF_FORCE_COMPAT flag
Thread-Topic: [PATCH 1/9] kernel: add a PF_FORCE_COMPAT flag
Thread-Index: AQHWjcPPLxbJUITJXkeWJwtHmAdwxKlwCErw
Date:   Sat, 19 Sep 2020 14:53:08 +0000
Message-ID: <6d064d8688324279af89152a8da22d69@AcuMS.aculab.com>
References: <20200918124533.3487701-1-hch@lst.de>
 <20200918124533.3487701-2-hch@lst.de>
 <20200918134012.GY3421308@ZenIV.linux.org.uk> <20200918134406.GA17064@lst.de>
 <20200918135822.GZ3421308@ZenIV.linux.org.uk>
In-Reply-To: <20200918135822.GZ3421308@ZenIV.linux.org.uk>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Al Viro
> Sent: 18 September 2020 14:58
> 
> On Fri, Sep 18, 2020 at 03:44:06PM +0200, Christoph Hellwig wrote:
> > On Fri, Sep 18, 2020 at 02:40:12PM +0100, Al Viro wrote:
> > > >  	/* Vector 0x110 is LINUX_32BIT_SYSCALL_TRAP */
> > > > -	return pt_regs_trap_type(current_pt_regs()) == 0x110;
> > > > +	return pt_regs_trap_type(current_pt_regs()) == 0x110 ||
> > > > +		(current->flags & PF_FORCE_COMPAT);
> > >
> > > Can't say I like that approach ;-/  Reasoning about the behaviour is much
> > > harder when it's controlled like that - witness set_fs() shite...
> >
> > I don't particularly like it either.  But do you have a better idea
> > how to deal with io_uring vs compat tasks?
> 
> <wry> git rm fs/io_uring.c would make a good starting point </wry>
> Yes, I know it's not going to happen, but one can dream...

Maybe the io_uring code needs some changes to make it vaguely safe.
- No support for 32-bit compat mixed working (or at all?).
  Plausibly a special worker could do 32bit work.
- ring structure (I'm assuming mapped by mmap()) never mapped
  in more than one process (not cloned by fork()).
- No implicit handover of files to another process.
  Would need an munmap, handover, mmap sequence.

In any case the io_ring rather abuses the import_iovec() interface.

The canonical sequence is (types from memory):
	struct iovec cache[8], *iov = cache;
	struct iter iter;
	...
	rval = import_iovec(..., &iov, 8, &iter);
	// Do read/write user using 'iter'
	free(iov);

I don't think there is any strict requirement that iter.iov
is set to either 'cache' or 'iov' (it probably must point
into one of them.)
But the io_uring code will make that assumption because the
actual copies can be done much later and it doesn't save 'iter'.
It gets itself in a right mess because it doesn't separate
the 'address I need to free' from 'the iov[] for any transfers'.

io_uring is also the only code that relies on import_iovec()
returning the iter.count on success.
It would be much better to have:
	iov = import_iovec(..., &cache, ...);
	free(iov);
and use ERR_PTR() et al for error detectoion.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

