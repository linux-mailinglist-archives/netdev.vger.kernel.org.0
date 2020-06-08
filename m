Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 423801F145E
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 10:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729162AbgFHIRL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 8 Jun 2020 04:17:11 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:45935 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729163AbgFHIRK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 04:17:10 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-150-kD24PW9MNL-vSTkdKyPWtQ-1; Mon, 08 Jun 2020 09:17:06 +0100
X-MC-Unique: kD24PW9MNL-vSTkdKyPWtQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 8 Jun 2020 09:17:05 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 8 Jun 2020 09:17:05 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Michael Tuexen' <Michael.Tuexen@lurchi.franken.de>
CC:     "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: packed structures used in socket options
Thread-Topic: packed structures used in socket options
Thread-Index: AQHWPLpUTq2nADe9c02l9PzEMhJDA6jNLBzwgAAGoICAAC9ugP//9FcAgABAGeCAAAqrAIAAvifw
Date:   Mon, 8 Jun 2020 08:17:05 +0000
Message-ID: <5fcc0a27f6494e8495ad043dfb3f2c56@AcuMS.aculab.com>
References: <CBFEFEF1-127A-4ADA-B438-B171B9E26282@lurchi.franken.de>
 <ec8c26c792ea414dbe50bda45725d26f@AcuMS.aculab.com>
 <7B4E2F06-8FF9-4C45-8F7D-8C24028C70EF@lurchi.franken.de>
 <e67c3c6e7d634138a4e71e0e768922c6@AcuMS.aculab.com>
 <B69695A1-F45B-4375-B9BB-1E50D1550C6D@lurchi.franken.de>
 <23a14b44bd5749a6b1b51150c7f3c8ba@AcuMS.aculab.com>
 <F68C9FD5-2F94-4782-9EFF-9EA1153EBE3E@lurchi.franken.de>
In-Reply-To: <F68C9FD5-2F94-4782-9EFF-9EA1153EBE3E@lurchi.franken.de>
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

From: Michael Tuexen
> Sent: 07 June 2020 22:51
> > On 7. Jun 2020, at 22:21, David Laight <David.Laight@ACULAB.COM> wrote:
> >
> > From: Michael Tuexen
> >> Sent: 07 June 2020 18:24
> >>> On 7. Jun 2020, at 19:14, David Laight <David.Laight@ACULAB.COM> wrote:
> >>>
> >>> From: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
> >>>> Sent: 07 June 2020 16:15
> >>>>> On 7. Jun 2020, at 15:53, David Laight <David.Laight@ACULAB.COM> wrote:
> >>>>>
> >>>>> From: Michael Tuexen
> >>>>>>
> >>>>>> since gcc uses -Werror=address-of-packed-member, I get warnings for my variant
> >>>>>> of packetdrill, which supports SCTP.
> >>>>>>
> >>>>>> Here is why:
> >>>>>>
> >>>>>>
> >>>>
> >>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/uapi/linux/sctp.h?h=v5
> >>>>>> .7
> >>>>>> contains:
> >>>>>>
> >>>>>> struct sctp_paddrparams {
> >>>>>> 	sctp_assoc_t		spp_assoc_id;
> >>>>>> 	struct sockaddr_storage	spp_address;
> >>>>>> 	__u32			spp_hbinterval;
> >>>>>> 	__u16			spp_pathmaxrxt;
> >>>>>> 	__u32			spp_pathmtu;
> >>>>>> 	__u32			spp_sackdelay;
> >>>>>> 	__u32			spp_flags;
> >>>>>> 	__u32			spp_ipv6_flowlabel;
> >>>>>> 	__u8			spp_dscp;
> >>>>>> } __attribute__((packed, aligned(4)));
> >>>>>>
> >>>>>> This structure is only used in the IPPROTO_SCTP level socket option SCTP_PEER_ADDR_PARAMS.
> >>>>>> Why is it packed?
> >>>>>
> >>>>> I'm guessing 'to remove holes to avoid leaking kernel data'.
> >>>>>
> >>>>> The sctp socket api defines loads of structures that will have
> >>>>> holes in them if not packed.
> >>>>
> >>>> Hi David,
> >>>> I agree that they have holes and we should have done better. The
> >>>> kernel definitely should also not leak kernel data. However, the
> >>>> way to handle this shouldn't be packing. I guess it is too late
> >>>> to change this?
> >>>
> >>> Probably too late.
> >>> I've no idea how it got through the standards body either.
> >>> In fact, the standard may actually require the holes.
> >>
> >> No, it does not. Avoiding holes was not taken into account.
> >
> > It depends on whether the rfc that describes the sockops says
> > the structures 'look like this' or 'contain the following members'.
>
> It uses "is defined as"... Using "contain the following members"
> would have been a better way. But is wasn't used. So yes, we could
> have minimised the number of holes. But also other structure have
> them. So when passing them from kernel land to user land one has
> to zero out the padding. Not optimal, but doable.

If it says 'defined as' then the 'packed' is just wrong.

No idea what can be done about it.
But an application is within its rights to define the structure
as it is defined in the rfc.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

