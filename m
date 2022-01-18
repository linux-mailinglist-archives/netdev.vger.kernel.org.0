Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1C14923DC
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 11:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237580AbiARKim convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 18 Jan 2022 05:38:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237302AbiARKil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 05:38:41 -0500
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C77FC061574;
        Tue, 18 Jan 2022 02:38:40 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 2D5A0FF80C;
        Tue, 18 Jan 2022 10:38:34 +0000 (UTC)
Date:   Tue, 18 Jan 2022 11:38:33 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Harry Morris <h.morris@cascoda.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "linux-wireless@vger.kernel.org Wireless" 
        <linux-wireless@vger.kernel.org>
Subject: Re: [wpan-next v2 08/27] net: ieee802154: Drop symbol duration
 settings when the core does it already
Message-ID: <20220118113833.0185f564@xps13>
In-Reply-To: <CAB_54W4rqXxSrTY=fqbt6o41a2SAEY_suqyqZ3hymheCgzRqTQ@mail.gmail.com>
References: <20220112173312.764660-1-miquel.raynal@bootlin.com>
        <20220112173312.764660-9-miquel.raynal@bootlin.com>
        <CAB_54W5QU5JCtQYwvTKREd6ZeQWmC19LF4mj853U0Gz-mCObVQ@mail.gmail.com>
        <20220113121645.434a6ef6@xps13>
        <CAB_54W5_x88zVgSJep=yK5WVjPvcWMy8dmyOJWcjy=5o0jCy0w@mail.gmail.com>
        <20220114112113.63661251@xps13>
        <CAB_54W77d_PjX_ZfKJdO4D4hHsAWjw0jWgRA7L0ewNnqApQhcQ@mail.gmail.com>
        <20220117101245.1946e474@xps13>
        <CAB_54W4rqXxSrTY=fqbt6o41a2SAEY_suqyqZ3hymheCgzRqTQ@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

> > > btw:
> > > Also for testing with hwsim and the missing features which currently
> > > exist. Can we implement some user space test program which replies
> > > (active scan) or sends periodically something out via AF_PACKET raw
> > > and a monitor interface that should work to test if it is working?  
> >
> > We already have all this handled, no need for extra software. You can
> > test active and passive scans between two hwsim devices already:
> >
> > # iwpan dev wpan0 beacons send interval 15
> > # iwpan dev wpan1 scan type active duration 1
> > # iwpan dev wpan0 beacons stop
> >
> > or
> >
> > # iwpan dev wpan0 beacons send interval 1
> > # iwpan dev wpan1 scan type passive duration 2
> > # iwpan dev wpan0 beacons stop
> >  
> > > Ideally we could do that very easily with scapy (not sure about their
> > > _upstream_ 802.15.4 support). I hope I got that right that there is
> > > still something missing but we could fake it in such a way (just for
> > > hwsim testing).  
> >
> > I hope the above will match your expectations.
> >  
> 
> I need to think and read more about... in my mind is currently the
> following question: are not coordinators broadcasting that information
> only? Means, isn't that a job for a coordinator?

My understanding right now:
- The spec states that coordinators only can send beacons and perform
  scans.
- I don't yet have the necessary infrastructure to give coordinators
  more rights than regular devices or RFDs (but 40+ patches already,
  don't worry this is something we have in mind)
- Right now this is the user to decide whether a device might answer
  beacon requests or not. This will soon become more limited but it
  greatly simplifies the logic for now.

Thanks,
Miquèl
