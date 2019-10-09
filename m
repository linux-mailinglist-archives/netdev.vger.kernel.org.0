Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCA8D13D3
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 18:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731695AbfJIQSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 12:18:12 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33639 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731688AbfJIQSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 12:18:11 -0400
Received: from cpe-2606-a000-111b-43ee-0-0-0-115f.dyn6.twc.com ([2606:a000:111b:43ee::115f] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1iIEcK-0006Zd-8J; Wed, 09 Oct 2019 12:15:17 -0400
Date:   Wed, 9 Oct 2019 12:15:08 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     David Laight <David.Laight@aculab.com>,
        network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCHv2 net-next 3/5] sctp: add
 SCTP_EXPOSE_POTENTIALLY_FAILED_STATE sockopt
Message-ID: <20191009161508.GB25555@hmswarspite.think-freely.org>
References: <cover.1570533716.git.lucien.xin@gmail.com>
 <066605f2269d5d92bc3fefebf33c6943579d8764.1570533716.git.lucien.xin@gmail.com>
 <60a7f76bd5f743dd8d057b32a4456ebd@AcuMS.aculab.com>
 <CADvbK_cFCuHAwxGAdY0BevrrAd6pQRP2tW_ej9mM3G4Aog3qpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADvbK_cFCuHAwxGAdY0BevrrAd6pQRP2tW_ej9mM3G4Aog3qpg@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 08, 2019 at 11:28:32PM +0800, Xin Long wrote:
> On Tue, Oct 8, 2019 at 9:02 PM David Laight <David.Laight@aculab.com> wrote:
> >
> > From: Xin Long
> > > Sent: 08 October 2019 12:25
> > >
> > > This is a sockopt defined in section 7.3 of rfc7829: "Exposing
> > > the Potentially Failed Path State", by which users can change
> > > pf_expose per sock and asoc.
> >
> > If I read these patches correctly the default for this sockopt in 'enabled'.
> > Doesn't this mean that old application binaries will receive notifications
> > that they aren't expecting?
> >
> > I'd have thought that applications would be required to enable it.
> If we do that, sctp_getsockopt_peer_addr_info() in patch 2/5 breaks.
> 
I don't think we can safely do either of these things.  Older
applications still need to behave as they did prior to the introduction
of this notification, and we shouldn't allow unexpected notifications to
be sent.

What if you added a check in get_peer_addr_info to only return -EACCESS
if pf_expose is 0 and the application isn't subscribed to the PF event?

Neil

> >
> >         David
> >
> > -
> > Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> > Registration No: 1397386 (Wales)
> >
> 
