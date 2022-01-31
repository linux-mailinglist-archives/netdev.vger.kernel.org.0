Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 647D74A493F
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 15:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234254AbiAaOXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 09:23:53 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:50523 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233565AbiAaOXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 09:23:50 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 1A05A6000A;
        Mon, 31 Jan 2022 14:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1643639028;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1J1iSHwA0jGHFy0j25b8SdmnmmiziMUJ96pXDRWTDpM=;
        b=plZl53NfOGgrzbDK6qi7JeMPNPp3OnN/9/Z8EI9WdIPeJ16L0s6rwksepGCro7kWdhWRCZ
        z6P3AgRkRDOIvrHstjs6jPFTinkU017Ph9IoKYf2ro/U2PgKsfOqmez6IR6CPave6jXa7Y
        JTVWKPRRgQr4L8RjnUp5N5VVhKWOsQaTBP+wX0PMmweXoRPO3Qdw9E1zz8mQK1aXVyBDrm
        qZyin612Trby5pkAVThsKYTZDXboKW0M9/4XZeg2pvA5Yc7hJlK9DKZd7r9Rtnp/fPc3Rw
        BUH4DaDnYhxvF86cWK7gvEzsV9588TvJljQw+onVehIYwjOLC/13uT+dfmAXOw==
Date:   Mon, 31 Jan 2022 15:23:45 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>
Subject: Re: [PATCH wpan-next v2 1/5] net: ieee802154: Improve the way
 supported channels are declared
Message-ID: <20220131152345.3fefa3aa@xps13>
In-Reply-To: <CAB_54W60OiGmjLQ2dAvnraq6fkZ6GGTLMVzjVbVAobcvNsaWtQ@mail.gmail.com>
References: <20220128110825.1120678-1-miquel.raynal@bootlin.com>
        <20220128110825.1120678-2-miquel.raynal@bootlin.com>
        <CAB_54W60OiGmjLQ2dAvnraq6fkZ6GGTLMVzjVbVAobcvNsaWtQ@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

alex.aring@gmail.com wrote on Sun, 30 Jan 2022 16:35:35 -0500:

> Hi,
>=20
> On Fri, Jan 28, 2022 at 6:08 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > The idea here is to create a structure per set of channels so that we
> > can define much more than basic bitfields for these.
> >
> > The structure is currently almost empty on purpose because this change
> > is supposed to be a mechanical update without additional information but
> > more details will be added in the following commits.
> > =20
>=20
> In my opinion you want to put more information in this structure which
> is not necessary and force the driver developer to add information
> which is already there encoded in the page/channel bitfields.

The information I am looking forward to add is clearly not encoded in
the page/channel bitfields (these information are added in the
following patches). At least I don't see anywhere in the spec a
paragraph telling which protocol and band must be used as a function of
the page and channel information. So I improved the way channels are
declared to give more information than what we currently have.

BTW I see the wpan tools actually derive the protocol/band from the
channel/page information and I _really_ don't get it. I believe it only
works with hwsim but if it's not the case I would like to hear
more about it.

> Why not
> add helper functionality and get your "band" and "protocol" for a
> page/channel combination?

This information is as static as the channel/page information, so why
using two different channels to get it? This means two different places
where the channels must be described, which IMHO hardens the work for
device driver writers.

I however agree that the final presentation looks a bit more heavy to
the eyes, but besides the extra fat that this change brings, it is
rather easy to give the core all the information it needs in a rather
detailed and understandable way.

Thanks,
Miqu=C3=A8l
