Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEDC59FB4E
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 15:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238210AbiHXN1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 09:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236887AbiHXN07 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 09:26:59 -0400
X-Greylist: delayed 21061 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 24 Aug 2022 06:26:57 PDT
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49DE66C757;
        Wed, 24 Aug 2022 06:26:54 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 73C1A1C0004;
        Wed, 24 Aug 2022 13:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1661347612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Lw1F0q0Mv6tpsWAvoqGppwUfQHRruH9wmo6EH6tLz4I=;
        b=pBJFewUO0yXkmDmSCE7jG7fp/LewlvSjCwXdks3yHaygJSLDD08sntk+v2MblKszrc579Q
        qxqLtivdjDHqQmVuejxgAvmxQYMiG8AaLME9jjRXvFwyQZxn2mQGYaTZ5BIhTCxiPGYUeK
        sGdbWcZlyHzr/MOAwnxRjxtITrmYZIf+8HhBodWVHXQffjI4vP2hC6H7tGYhKidIDMIABY
        nxbAi0P2DbI0wvKdqzZFgqeysm02t3mncAiBIZpHgkyqHNYBbBKV6CLxTPERllws20cJL1
        7GiboaMjDEev0Lx+8XZ9dPCC0eO3UD4H8ZCMQMQfTiCFE5ec9tIuGtNLsKiXIQ==
Date:   Wed, 24 Aug 2022 15:26:48 +0200
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
Message-ID: <20220824152648.4bfb9a89@xps-13>
In-Reply-To: <CAK-6q+gjgQ1BF-QrT01JWh+2b3oL3RU+SoxUf5t7h3Hc6R8pcg@mail.gmail.com>
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
        <20220701143052.1267509-2-miquel.raynal@bootlin.com>
        <CAK-6q+jkUUjAGqEDgU1oJvRkigUbvSO5SXWRau6+320b=GbfxQ@mail.gmail.com>
        <20220819191109.0e639918@xps-13>
        <CAK-6q+gCY3ufaADHNQWJGNpNZJMwm=fhKfe02GWkfGEdgsMVzg@mail.gmail.com>
        <20220823182950.1c722e13@xps-13>
        <CAK-6q+jfva++dGkyX_h2zQGXnoJpiOu5+eofCto=KZ+u6KJbJA@mail.gmail.com>
        <20220824122058.1c46e09a@xps-13>
        <CAK-6q+gjgQ1BF-QrT01JWh+2b3oL3RU+SoxUf5t7h3Hc6R8pcg@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

aahringo@redhat.com wrote on Wed, 24 Aug 2022 08:43:20 -0400:

> Hi,
>=20
> On Wed, Aug 24, 2022 at 6:21 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> ...
> >
> > Actually right now the second level is not enforced, and all the
> > filtering levels are a bit fuzzy and spread everywhere in rx.c.
> >
> > I'm gonna see if I can at least clarify all of that and only make
> > coord-dependent the right section because right now a
> > ieee802154_coord_rx() path in ieee802154_rx_handle_packet() does not
> > really make sense given that the level 3 filtering rules are mostly
> > enforced in ieee802154_subif_frame(). =20
>=20
> One thing I mentioned before is that we probably like to have a
> parameter for rx path to give mac802154 a hint on which filtering
> level it was received. We don't have that, I currently see that this
> is a parameter for hwsim receiving it on promiscuous level only and
> all others do third level filtering.
> We need that now, because the promiscuous mode was only used for
> sniffing which goes directly into the rx path for monitors. With scan
> we mix things up here and in my opinion require such a parameter and
> do filtering if necessary.

I am currently trying to implement a slightly different approach. The
core does not know hwsim is always in promiscuous mode, but it does
know that it does not check FCS. So the core checks it. This is
level 1 achieved. Then in level 2 we want to know if the core asked
the transceiver to enter promiscuous mode, which, if it did, should
not imply more filtering. If the device is working in promiscuous
mode but this was not asked explicitly by the core, we don't really
care, software filtering will apply anyway.

I am reworking the rx path to clarify what is being done and when,
because I found this part very obscure right now. In the end I don't
think we need additional rx info from the drivers. Hopefully my
proposal will clarify why this is (IMHO) not needed.

Thanks,
Miqu=C3=A8l
