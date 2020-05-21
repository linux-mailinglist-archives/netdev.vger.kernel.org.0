Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE041DC93F
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 11:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728724AbgEUJG0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 21 May 2020 05:06:26 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:43257 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728657AbgEUJGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 05:06:25 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mtapsc-2-5zY-0iRdNzGaTxwUZDYv5A-1; Thu, 21 May 2020 10:06:20 +0100
X-MC-Unique: 5zY-0iRdNzGaTxwUZDYv5A-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 21 May 2020 10:06:19 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 21 May 2020 10:06:19 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Christoph Hellwig' <hch@lst.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "vyasevich@gmail.com" <vyasevich@gmail.com>,
        "nhorman@tuxdriver.com" <nhorman@tuxdriver.com>,
        "jmaloy@redhat.com" <jmaloy@redhat.com>,
        "ying.xue@windriver.com" <ying.xue@windriver.com>,
        "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "cluster-devel@redhat.com" <cluster-devel@redhat.com>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>
Subject: RE: [PATCH 31/33] sctp: add sctp_sock_set_nodelay
Thread-Topic: [PATCH 31/33] sctp: add sctp_sock_set_nodelay
Thread-Index: AQHWL0qynFLZF0CI80WcvwAESh6D26iyPrKg
Date:   Thu, 21 May 2020 09:06:19 +0000
Message-ID: <0a6839ab0ba04fcf9b9c92784c9564aa@AcuMS.aculab.com>
References: <20200520195509.2215098-1-hch@lst.de>
 <20200520195509.2215098-32-hch@lst.de>
 <20200520231001.GU2491@localhost.localdomain>
 <20200520.162355.2212209708127373208.davem@davemloft.net>
 <20200520233913.GV2491@localhost.localdomain> <20200521083442.GA7771@lst.de>
In-Reply-To: <20200521083442.GA7771@lst.de>
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
> Sent: 21 May 2020 09:35
> On Wed, May 20, 2020 at 08:39:13PM -0300, Marcelo Ricardo Leitner wrote:
> > On Wed, May 20, 2020 at 04:23:55PM -0700, David Miller wrote:
> > > From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> > > Date: Wed, 20 May 2020 20:10:01 -0300
> > >
> > > > The duplication with sctp_setsockopt_nodelay() is quite silly/bad.
> > > > Also, why have the 'true' hardcoded? It's what dlm uses, yes, but the
> > > > API could be a bit more complete than that.
> > >
> > > The APIs are being designed based upon what in-tree users actually
> > > make use of.  We can expand things later if necessary.
> >
> > Sometimes expanding things later can be though, thus why the worry.
> > But ok, I get it. Thanks.
> >
> > The comment still applies, though. (re the duplication)
> 
> Where do you see duplication?

The whole thing just doesn't scale.

As soon as you get to the slightly more complex requests
like SCTP_INITMSG (which should probably be called to
set the required number of data streams) you've either
got replicated code or nested wrappers.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

