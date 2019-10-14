Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACB16D645D
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 15:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732288AbfJNNtD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 14 Oct 2019 09:49:03 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:55879 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732275AbfJNNtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 09:49:02 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-18-spBsG0rnPI-Sf4cdjsBoZQ-1; Mon, 14 Oct 2019 14:48:59 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 14 Oct 2019 14:48:59 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 14 Oct 2019 14:48:59 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Neil Horman' <nhorman@tuxdriver.com>,
        Xin Long <lucien.xin@gmail.com>
CC:     network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCHv2 net-next 3/5] sctp: add
 SCTP_EXPOSE_POTENTIALLY_FAILED_STATE sockopt
Thread-Topic: [PATCHv2 net-next 3/5] sctp: add
 SCTP_EXPOSE_POTENTIALLY_FAILED_STATE sockopt
Thread-Index: AQHVfcsgrQL6OT4GuU648eHSKFH716dQtSlAgAlozbiAAAvUMA==
Date:   Mon, 14 Oct 2019 13:48:59 +0000
Message-ID: <0cfd3050e4bf41f1920837767ed5c23e@AcuMS.aculab.com>
References: <cover.1570533716.git.lucien.xin@gmail.com>
 <066605f2269d5d92bc3fefebf33c6943579d8764.1570533716.git.lucien.xin@gmail.com>
 <60a7f76bd5f743dd8d057b32a4456ebd@AcuMS.aculab.com>
 <CADvbK_cFCuHAwxGAdY0BevrrAd6pQRP2tW_ej9mM3G4Aog3qpg@mail.gmail.com>
 <20191009161508.GB25555@hmswarspite.think-freely.org>
 <CADvbK_fb9jjm-h-XyVci971Uu=YuwMsUjWEcv9ehUv9Q6W_VxQ@mail.gmail.com>
 <20191014124143.GA11844@hmswarspite.think-freely.org>
In-Reply-To: <20191014124143.GA11844@hmswarspite.think-freely.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: spBsG0rnPI-Sf4cdjsBoZQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>
> Sent: 14 October 2019 13:42
> To: Xin Long <lucien.xin@gmail.com>
> Cc: David Laight <David.Laight@ACULAB.COM>; network dev <netdev@vger.kernel.org>; linux-sctp@vger.kernel.org; Marcelo
> Ricardo Leitner <marcelo.leitner@gmail.com>; davem@davemloft.net
> Subject: Re: [PATCHv2 net-next 3/5] sctp: add SCTP_EXPOSE_POTENTIALLY_FAILED_STATE sockopt
> 
> On Mon, Oct 14, 2019 at 04:36:34PM +0800, Xin Long wrote:
> > On Thu, Oct 10, 2019 at 12:18 AM Neil Horman <nhorman@tuxdriver.com> wrote:
> > >
> > > On Tue, Oct 08, 2019 at 11:28:32PM +0800, Xin Long wrote:
> > > > On Tue, Oct 8, 2019 at 9:02 PM David Laight <David.Laight@aculab.com> wrote:
> > > > >
> > > > > From: Xin Long
> > > > > > Sent: 08 October 2019 12:25
> > > > > >
> > > > > > This is a sockopt defined in section 7.3 of rfc7829: "Exposing
> > > > > > the Potentially Failed Path State", by which users can change
> > > > > > pf_expose per sock and asoc.
> > > > >
> > > > > If I read these patches correctly the default for this sockopt in 'enabled'.
> > > > > Doesn't this mean that old application binaries will receive notifications
> > > > > that they aren't expecting?
> > > > >
> > > > > I'd have thought that applications would be required to enable it.
> > > > If we do that, sctp_getsockopt_peer_addr_info() in patch 2/5 breaks.
> > > >
> > > I don't think we can safely do either of these things.  Older
> > > applications still need to behave as they did prior to the introduction
> > > of this notification, and we shouldn't allow unexpected notifications to
> > > be sent.
> > Hi, Neil
> >
> > I think about again, and also talked with QE, we think to get unexpected
> > notifications shouldn't be a problem for user's applications.
> >
> On principle, I disagree.  Regardless of what the RFC does, we shouldn't
> send notifications that an application aren't subscribed to.  Just
> because QE doesn't think it should be a problem (and for their uses it
> may well not be an issue), we can't make that general assumption.
> 
> > RFC actually keeps adding new notifications, and a user shouldn't expect
> > the specific notifications coming in some exact orders. They should just
> > ignore it and wait until the ones they expect. I don't think some users
> > would abort its application when getting an unexpected notification.
> >
> To make that assertion is to discount the purpose of the SCTP_EVENTS
> sockopt entirely.  the SCTP_EVENTS option is a whitelist operation, so
> they expect to get what they subscribe to, and no more.
> 
> > We should NACK patchset v3 and go with v2. What do you think?
> >
> No, we need to go with an option that maintains backwards compatibility
> without relying on the assumption that applications will just ignore
> events they didn't subscribe to.  Davids example is a case in point.

Although I don't enable the SCTP_PEER_ADDR_CHANGE indications.
But rfc 6458 doesn't say that the list might be extended.

Aren't there 3 separate items here:
1) The SCTP protocol changes (to better handle primary path failure).
2) The SCTP_GET_PEER_ADDR_INFO sockopt.
3) The MSG_NOTIFICATION indication for SCTP_ADDR_POTENTIALLY_FAILED.

Looking at RFC 7829 section 7.3.
7.3 defines SCTP_EXPOSE_POTENTIALLY_FAILED_STATE.
For compatibility this must default to 'disabled'.
This is even true if the application has set the SCTP_PEER_ADDR_THLDS.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

