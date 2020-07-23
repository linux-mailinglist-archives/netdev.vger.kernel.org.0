Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 147D822B1ED
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 16:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728431AbgGWO4j convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 23 Jul 2020 10:56:39 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:49754 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728711AbgGWO4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 10:56:38 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-82-SdYRZOb-OAyxxDdIZA3c_Q-1; Thu, 23 Jul 2020 15:56:34 +0100
X-MC-Unique: SdYRZOb-OAyxxDdIZA3c_Q-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 23 Jul 2020 15:56:33 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 23 Jul 2020 15:56:33 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Christoph Hellwig' <hch@lst.de>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>,
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
Subject: RE: [PATCH 03/26] bpfilter: reject kernel addresses
Thread-Topic: [PATCH 03/26] bpfilter: reject kernel addresses
Thread-Index: AQHWYLhxJPyZOJNDGEen8+LVytPg86kVPIvA///w6YCAABGh0A==
Date:   Thu, 23 Jul 2020 14:56:33 +0000
Message-ID: <5fc6b1716f1b4534bda95bab49512754@AcuMS.aculab.com>
References: <20200723060908.50081-1-hch@lst.de>
 <20200723060908.50081-4-hch@lst.de>
 <c3dc5b4d84e64230bb6ca8df7bb70705@AcuMS.aculab.com>
 <20200723144455.GA12280@lst.de>
In-Reply-To: <20200723144455.GA12280@lst.de>
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

From: 'Christoph Hellwig'
> Sent: 23 July 2020 15:45
> 
> On Thu, Jul 23, 2020 at 02:42:11PM +0000, David Laight wrote:
> > From: Christoph Hellwig
> > > Sent: 23 July 2020 07:09
> > >
> > > The bpfilter user mode helper processes the optval address using
> > > process_vm_readv.  Don't send it kernel addresses fed under
> > > set_fs(KERNEL_DS) as that won't work.
> >
> > What sort of operations is the bpf filter doing on the sockopt buffers?
> >
> > Any attempts to reject some requests can be thwarted by a second
> > application thread modifying the buffer after the bpf filter has
> > checked that it allowed.
> >
> > You can't do security by reading a user buffer twice.
> 
> I'm not saying that I approve of the design, but the current bpfilter
> design uses process_vm_readv to access the buffer, which obviously does
> not work with kernel buffers.

Is this a different bit of bpf that that which used to directly
intercept setsockopt() requests and pass them down from a kernel buffer?

I can't held feeling that bpf is getting 'too big for its boots' and
will have a local-user privilege escalation hiding in it somewhere.

I've had to fix my 'out of tree' driver to remove the [sg]etsockopt()
calls. Some of the replacements will go badly wrong if I've accidentally
lost track of the socket type.
I do have a daemon process sleeping in the driver - so I can wake it up
and make the requests from it with a user buffer.
I may have to implement that to get the negotiated number of 'ostreams'
to an SCTP connection.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

