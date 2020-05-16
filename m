Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 265341D61EB
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 17:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgEPPV0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 16 May 2020 11:21:26 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:23897 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726537AbgEPPVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 11:21:20 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id uk-mta-2-M-or8IPqO3ut6gEkeJwgCw-1;
 Sat, 16 May 2020 16:21:16 +0100
X-MC-Unique: M-or8IPqO3ut6gEkeJwgCw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Sat, 16 May 2020 16:21:15 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Sat, 16 May 2020 16:21:15 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Christoph Hellwig' <hch@lst.de>,
        David Howells <dhowells@redhat.com>
CC:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>,
        "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "cluster-devel@redhat.com" <cluster-devel@redhat.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: RE: [PATCH 27/33] sctp: export sctp_setsockopt_bindx
Thread-Topic: [PATCH 27/33] sctp: export sctp_setsockopt_bindx
Thread-Index: AQHWKsz+yiOODFVfBEqdWGEpseVc56iq0wgA
Date:   Sat, 16 May 2020 15:21:15 +0000
Message-ID: <c23030de384747ae83c6c0813bd4f1c0@AcuMS.aculab.com>
References: <20200514062820.GC8564@lst.de>
 <20200513062649.2100053-1-hch@lst.de> <20200513062649.2100053-28-hch@lst.de>
 <20200513180058.GB2491@localhost.localdomain>
 <129070.1589556002@warthog.procyon.org.uk> <20200515152459.GA28995@lst.de>
In-Reply-To: <20200515152459.GA28995@lst.de>
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
> Sent: 15 May 2020 16:25
> On Fri, May 15, 2020 at 04:20:02PM +0100, David Howells wrote:
> > Christoph Hellwig <hch@lst.de> wrote:
> >
> > > > The advantage on using kernel_setsockopt here is that sctp module will
> > > > only be loaded if dlm actually creates a SCTP socket.  With this
> > > > change, sctp will be loaded on setups that may not be actually using
> > > > it. It's a quite big module and might expose the system.
> > >
> > > True.  Not that the intent is to kill kernel space callers of setsockopt,
> > > as I plan to remove the set_fs address space override used for it.
> >
> > For getsockopt, does it make sense to have the core kernel load optval/optlen
> > into a buffer before calling the protocol driver?  Then the driver need not
> > see the userspace pointer at all.
> >
> > Similar could be done for setsockopt - allocate a buffer of the size requested
> > by the user inside the kernel and pass it into the driver, then copy the data
> > back afterwards.
> 
> I did look into that initially.  The problem is that tons of sockopts
> entirely ignore optlen and just use a fixed size.  So I fear that there
> could be tons of breakage if we suddently respect it.  Otherwise that
> would be a pretty nice way to handle the situation.

I'd guess that most application use the correct size for setsockopt().
(Well, apart from using 4 instead of 1.)

It is certainly possible to always try to read in 64 bytes
regardless of the supplied length, but handle the EFAULT case
by shortening the buffer.

Historically getsockopt() only wrote the length back.
Treating 0 and garbage as (say) 4k and letting the protocol
code set a shorten the copy to user might work.
All short transfers would want to use an on-stack buffer,
so slight oversizes could also be allowed for.

OTOH if i did a getsockopt() with too short a length I wouldn't
want the kernel to trash my program memory.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

