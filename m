Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E049553E88A
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241051AbiFFPn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 11:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241036AbiFFPn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 11:43:27 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA35987A38;
        Mon,  6 Jun 2022 08:43:25 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 7BC0440003;
        Mon,  6 Jun 2022 15:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1654530203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iB3ZlXySloDoec4clQsobveNwwgHZW2TIz9Z8M7REBg=;
        b=KqhKu7xD42sVbE/RMck+GMlu0NvMd1LHOTIitc41BCqLnHDkyZFWCBTvPW6waO9HC6MSJO
        j4xQIAsD5iTDRL56GLnJfHR2uPCjR86S4l+SA1YPuUyFFh60psIEbeM4CC/dW5kg7OPQQ8
        tZ2gKABv+9RIBLKMGCwQFoVlSXwVctie5+JrOfrDWw86LfxgNt3yCMKDmxNf0YVy2THj5D
        2leTrY1/YWiXwczT3iRwTb4zxFYVSPE4iriFuZzMHH6j+i9//sDlXo91iA2pOkZKAmkRbn
        1b7BHwBCnDESLNWqagDZvDkSu1pu4dzbMvGywj3SVafI/H2SjEeKNWDTNxr/cw==
Date:   Mon, 6 Jun 2022 17:43:19 +0200
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
Message-ID: <20220606174319.0924f80d@xps-13>
In-Reply-To: <CAK-6q+hAZMqsN=S9uWAm4rTN+uZwz7_L42=emPHz7+MvfW6ZpQ@mail.gmail.com>
References: <20220603182143.692576-1-miquel.raynal@bootlin.com>
        <20220603182143.692576-2-miquel.raynal@bootlin.com>
        <CAK-6q+hAZMqsN=S9uWAm4rTN+uZwz7_L42=emPHz7+MvfW6ZpQ@mail.gmail.com>
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

Hi Alexander,

aahringo@redhat.com wrote on Fri, 3 Jun 2022 22:01:38 -0400:

> Hi,
>=20
> On Fri, Jun 3, 2022 at 2:34 PM Miquel Raynal <miquel.raynal@bootlin.com> =
wrote:
> >
> > The current enum is wrong. A device can either be an RFD, an RFD-RX, an
> > RFD-TX or an FFD. If it is an FFD, it can also be a coordinator. While
> > defining a node type might make sense from a strict software point of
> > view, opposing node and coordinator seems meaningless in the ieee
> > 802.15.4 world. As this enumeration is not used anywhere, let's just
> > drop it. We will in a second time add a new "node type" enumeration
> > which apply only to nodes, and does differentiates the type of devices
> > mentioned above.
> > =20
>=20
> First you cannot say if this is not used anywhere else.

Mmmh, that's tricky, I really don't see how that might be a
problem because there is literally nowhere in the kernel that uses this
type, besides ieee802154_setup_sdata() which would just BUG() if this
type was to be used. So I assumed it was safe to be removed.

> Second I have
> a different opinion here that you cannot just "switch" the role from
> RFD, FFD, whatever.

I agree with this, and that's why I don't understand this enum.

A device can either be a NODE (an active device) or a MONITOR (a
passive device) at a time. We can certainly switch from one to
another at run time.

A NODE can be either an RFD or an FFD. That is a static property which
cannot change.

However being a coordinator is just an additional property of a NODE
which is of type FFD, and this can change over time.

So I don't get what having a coordinator interface would bring. What
was the idea behind its introduction then?

> You are mixing things here with "role in the network" and what the
> transceiver capability (RFD, FFD) is, which are two different things.

I don't think I am, however maybe our vision differ on what an
interface should be.

> You should use those defines and the user needs to create a new
> interface type and probably have a different extended address to act
> as a coordinator.

Can't we just simply switch from coordinator to !coordinator (that's
what I currently implemented)? Why would we need the user to create a
new interface type *and* to provide a new address?

Note that these are real questions that I am asking myself. I'm fine
adapting my implementation, as long as I get the main idea.

Thanks,
Miqu=C3=A8l
