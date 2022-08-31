Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72B395A8168
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 17:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231871AbiHaPjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 11:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbiHaPjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 11:39:10 -0400
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D150D8B07;
        Wed, 31 Aug 2022 08:39:08 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 6A5D620004;
        Wed, 31 Aug 2022 15:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1661960346;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JaN95KS1q/LjGpKWGX9qydG0jbE2xV4Q5Qxh/1+0e7Y=;
        b=Vxgr48GWsGuwV1gKlAMLpd2GUpYU9blHwzRr1ftHviOBv26f2aNQYZPKR5q6lKpqsn3kv9
        p1RZ20v5635v3T+PRD2rGkpDgXuCrp/dG9+aNyRhYbLWG9sgrRoOCdfvgob8Op0th6n++u
        T4qZ2axU4u/liBuo1p0egNpcJVVV/bXQqv8RDYr1sSmLfwg4NGkFB9ZcA86G38QsAs6Xc7
        7rKiPSChJBBA7e4xmxFJVfDySyPCR+BkbCykjhucfv3KrTzfEWYEZ9+2kuhA30F67IBHBS
        7s+7EJtGssBF3aJUMXzJhyriIJBF7YX29RNklaoRdIGWhgrOnN5q8tP3LSE0XQ==
Date:   Wed, 31 Aug 2022 17:39:03 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next 01/20] net: mac802154: Allow the creation of
 coordinator interfaces
Message-ID: <20220831173903.1a980653@xps-13>
In-Reply-To: <CAK-6q+gJwm0bhHgMVBF_pmjD9zSrxxHvNGdTrTm0fG-hAmSaUQ@mail.gmail.com>
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
        <20220701143052.1267509-2-miquel.raynal@bootlin.com>
        <CAK-6q+jkUUjAGqEDgU1oJvRkigUbvSO5SXWRau6+320b=GbfxQ@mail.gmail.com>
        <20220819191109.0e639918@xps-13>
        <CAK-6q+gCY3ufaADHNQWJGNpNZJMwm=fhKfe02GWkfGEdgsMVzg@mail.gmail.com>
        <20220823182950.1c722e13@xps-13>
        <CAK-6q+jfva++dGkyX_h2zQGXnoJpiOu5+eofCto=KZ+u6KJbJA@mail.gmail.com>
        <20220824122058.1c46e09a@xps-13>
        <CAK-6q+gjgQ1BF-QrT01JWh+2b3oL3RU+SoxUf5t7h3Hc6R8pcg@mail.gmail.com>
        <20220824152648.4bfb9a89@xps-13>
        <CAK-6q+itA0C4zPAq5XGKXgCHW5znSFeB-YDMp3uB9W-kLV6WaA@mail.gmail.com>
        <20220825145831.1105cb54@xps-13>
        <CAK-6q+j3LMoSe_7u0WqhowdPV9KM-6g0z-+OmSumJXCZfo0CAw@mail.gmail.com>
        <20220826095408.706438c2@xps-13>
        <CAK-6q+gxD0TkXzUVTOiR4-DXwJrFUHKgvccOqF5QMGRjfZQwvw@mail.gmail.com>
        <20220829100214.3c6dad63@xps-13>
        <CAK-6q+gJwm0bhHgMVBF_pmjD9zSrxxHvNGdTrTm0fG-hAmSaUQ@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander & Stefan,

aahringo@redhat.com wrote on Mon, 29 Aug 2022 22:23:09 -0400:

I am currently testing my code with the ATUSB devices, the association
works, so it's a good news! However I am struggling to get the
association working for a simple reason: the crafted ACKs are
transmitted (the ATUSB in monitor mode sees it) but I get absolutely
nothing on the receiver side.

The logic is:

coord0                 coord1
association req ->
                <-     ack
                <-     association response
ack             ->

The first ack is sent by coord1 but coord0 never sees anything. In
practice coord0 has sent an association request and received a single
one-byte packet in return which I guess is the firmware saying "okay, Tx
has been performed". Shall I interpret this byte differently? Does it
mean that the ack has also been received?=20

I could not find a documentation of the firmware interface, I went
through the wiki but I did not find something clear about what to
expect or "what the driver should do". But perhaps this will ring a
bell on your side?

[...]

> I did not see the v2 until now. Sorry for that.

Ah! Ok, no problem :)

>=20
> However I think there are missing bits here at the receive handling
> side. Which are:
>=20
> 1. Do a stop_tx(), stop_rx(), start_rx(filtering_level) to go into
> other filtering modes while ifup.

Who is supposed to change the filtering level?

For now there is only the promiscuous mode being applied and the user
has no knowledge about it, it's just something internal.

Changing how the promiscuous mode is applied (using a filtering level
instead of a "promiscuous on" boolean) would impact all the drivers
and for now we don't really need it.

> I don't want to see all filtering modes here, just what we currently
> support with NONE (then with FCS check on software if necessary),
> ?THIRD/FOURTH? LEVEL filtering and that's it. What I don't want to see
> is runtime changes of phy flags. To tell the receive path what to
> filter and what's not.

Runtime changes on a dedicated "filtering" PHY flag is what I've used
and it works okay for this situation, why don't you want that? It
avoids the need for (yet) another rework of the API with the drivers,
no?

> 2. set the pan coordinator bit for hw address filter. And there is a
> TODO about setting pkt_type in mac802154 receive path which we should
> take a look into. This bit should be addressed for coordinator support
> even if there is the question about coordinator vs pan coordinator,
> then the kernel needs a bit as coordinator iface type parameter to
> know if it's a pan coordinator and not coordinator.

This is not really something that we can "set". Either the device
had performed an association and it is a child device: it is not the
PAN coordinator, or it initiated the PAN and it is the PAN coordinator.
There are commands to change that later on but those are not supported.

The "PAN coordinator" information is being added in the association
series (which comes after the scan). I have handled the pkt_type you are
mentioning.

> I think it makes total sense to split this work in transmit handling,
> where we had no support at all to send something besides the usual
> data path, and receive handling, where we have no way to change the
> filtering level besides interface type and ifup time of an interface.
> We are currently trying to make a receive path working in a way that
> "the other ideas flying around which are good" can be introduced in
> future.
> If this is done, then take care about how to add the rest of it.
>=20
> I will look into v2 the next few days.
>=20
> - Alex
>=20


Thanks,
Miqu=C3=A8l
