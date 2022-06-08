Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8DA65431DF
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 15:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240480AbiFHNr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 09:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240325AbiFHNr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 09:47:56 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 594225A5AE;
        Wed,  8 Jun 2022 06:47:54 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id DC00AE0006;
        Wed,  8 Jun 2022 13:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1654696072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0SnuIfKA+v08E4CLFZl2WBBZ+AqWPPvRbrIf1bDB0wA=;
        b=TvjKk1lWzV0zQ6QuKckAk/o1FCGspzLB1tzb6OXXoY9qHAUywG6jgJaWwxYZ59mhzJHxd0
        rZEI1VcaQrTXb7O4tMVFBIyU23v8U9bQGTOPMClMlNP8GeC3xs1DRu4VNntATgPldRMEi1
        srOb5wCsJFi7qmvEOrff9BO4/1256Iwwn35OfRtRRnZVawbC8d9RH1vqza7e9q5vsIToDD
        MLIQrCBguAeePfW0X3pu1ZA84/8AQgcgnWk4GKnC/RfV4/LmpLenvsZMQBVNeDnMMtcNwT
        x99TCv5oG2iiEqoLav6T0nuMMEjo33EYZ5wwFNQXNPuejhXuEtvS9m5dzjBmrA==
Date:   Wed, 8 Jun 2022 15:47:49 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next 1/6] net: ieee802154: Drop coordinator
 interface type
Message-ID: <20220608154749.06b62d59@xps-13>
In-Reply-To: <20220607181608.609429cb@xps-13>
References: <20220603182143.692576-1-miquel.raynal@bootlin.com>
        <20220603182143.692576-2-miquel.raynal@bootlin.com>
        <CAK-6q+hAZMqsN=S9uWAm4rTN+uZwz7_L42=emPHz7+MvfW6ZpQ@mail.gmail.com>
        <20220606174319.0924f80d@xps-13>
        <CAK-6q+itswJrmy-AhZ5DpnHH0UsfAeTPQTmX8WfG8=PteumVLg@mail.gmail.com>
        <20220607181608.609429cb@xps-13>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alex,

> > 3. coordinator (any $TYPE specific) userspace software
> >=20
> > May the main argument. Some coordinator specific user space daemon
> > does specific type handling (e.g. hostapd) maybe because some library
> > is required. It is a pain to deal with changing roles during the
> > lifetime of an interface and synchronize user space software with it.
> > We should keep in mind that some of those handlings will maybe be
> > moved to user space instead of doing it in the kernel. I am fine with
> > the solution now, but keep in mind to offer such a possibility.
> >=20
> > I think the above arguments are probably the same why wireless is
> > doing something similar and I would avoid running into issues or it's
> > really difficult to handle because you need to solve other Linux net
> > architecture handling at first. =20
>=20
> Yep.

The spec makes a difference between "coordinator" and "PAN
coordinator", which one is the "coordinator" interface type supposed to
picture? I believe we are talking about being a "PAN coordinator", but
I want to be sure that we are aligned on the terms.

> > > > You are mixing things here with "role in the network" and what
> > > > the transceiver capability (RFD, FFD) is, which are two
> > > > different things.   =20
> > >
> > > I don't think I am, however maybe our vision differ on what an
> > > interface should be.
> > >   =20
> > > > You should use those defines and the user needs to create a new
> > > > interface type and probably have a different extended address
> > > > to act as a coordinator.   =20
> > >
> > > Can't we just simply switch from coordinator to !coordinator
> > > (that's what I currently implemented)? Why would we need the user
> > > to create a new interface type *and* to provide a new address?
> > >
> > > Note that these are real questions that I am asking myself. I'm
> > > fine adapting my implementation, as long as I get the main idea.
> > >   =20
> >=20
> > See above. =20
>=20
> That's okay for me. I will adapt my implementation to use the
> interface thing. In the mean time additional details about what a
> coordinator interface should do differently (above question) is
> welcome because this is not something I am really comfortable with.

I've updated the implementation to use the IFACE_COORD interface and it
works fine, besides one question below.

Also, I read the spec once again (soon I'll sleep with it) and
actually what I extracted is that:

* A FFD, when turned on, will perform a scan, then associate to any PAN
  it found (algorithm is beyond the spec) or otherwise create a PAN ID
  and start its own PAN. In both cases, it finishes its setup by
  starting to send beacons.

* A RFD will behave more or less the same, without the PAN creation
  possibility of course. RFD-RX and RFD-TX are not required to support
  any of that, I'll assume none of the scanning features is suitable
  for them.

I have a couple of questions however:

- Creating an interface (let's call it wpancoord) out of wpan0 means
  that two interfaces can be used in different ways and one can use
  wpan0 as a node while using wpancoord as a PAN coordinator. Is that
  really allowed? How should we prevent this from happening?

- Should the device always wait for the user(space) to provide the PAN
  to associate to after the scan procedure right after the
  add_interface()? (like an information that must be provided prior to
  set the interface up?)

- How does an orphan FFD should pick the PAN ID for a PAN creation?
  Should we use a random number? Start from 0 upwards? Start from
  0xfffd downwards? Should the user always provide it?

- Should an FFD be able to create its own PAN on demand? Shall we
  allow to do that at the creation of the new interface?

Thanks,
Miqu=C3=A8l
