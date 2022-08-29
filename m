Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE4395A447F
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 10:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbiH2IFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 04:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbiH2IF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 04:05:29 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5CC193FE;
        Mon, 29 Aug 2022 01:05:27 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 58D61C0002;
        Mon, 29 Aug 2022 08:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1661760326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QMq6SaZxih7nZIC2bQAgwcycjB3AsLB32Ejo7VBvV3U=;
        b=IdTntAaF9C/gteGTzwtwToWqQQt4xQO8lNR9hU0Km/gK0xaK5g7u3LShODHrl2HoTGqFwk
        7iJZCy7RoWhz5DYd1eJGiadAPigUdvma9bDzlCULT36pDB8kc7nFhNOfPRXZvmR8rVyAwa
        LQrn/uV7SyiFMKGG7yXgHxZGAzIksm8BQyqVQetTntu5Dgc2FxYyA0FxUqWYoQYuqi8806
        9TT5ZmGxnEsltA1fcCQ0GL44k9fEn+jZ0wy/FcbZTwu54LdqxoEOMD2la6Fcbaj/cWEFEv
        P3/kL9fNBXeK3aKa2rxZieleBrxSXIrgprbYN6AOPgMZYf04/W8nBLRZSq9YgA==
Date:   Mon, 29 Aug 2022 10:05:21 +0200
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
Message-ID: <20220829100521.04b52196@xps-13>
In-Reply-To: <CAK-6q+gZ5fSdNptvQoKpf1SOqODv70gzbFTYyWBagC6AFtAkig@mail.gmail.com>
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
        <20220701143052.1267509-2-miquel.raynal@bootlin.com>
        <CAK-6q+jkUUjAGqEDgU1oJvRkigUbvSO5SXWRau6+320b=GbfxQ@mail.gmail.com>
        <20220819191109.0e639918@xps-13>
        <CAK-6q+gCY3ufaADHNQWJGNpNZJMwm=fhKfe02GWkfGEdgsMVzg@mail.gmail.com>
        <20220823182950.1c722e13@xps-13>
        <CAK-6q+jfva++dGkyX_h2zQGXnoJpiOu5+eofCto=KZ+u6KJbJA@mail.gmail.com>
        <20220824093547.16f05d15@xps-13>
        <CAK-6q+gqX8w+WEgSk2J9FOdrFJPvqJOsgmaY4wOu=siRszBujA@mail.gmail.com>
        <20220825104035.11806a67@xps-13>
        <CAK-6q+hxSpw1yJR5H5D6gy5gGdm6Qa3VzyjZXA45KFQfVVqwFw@mail.gmail.com>
        <CAK-6q+jbBg4kCh88Oz7mBa0RBBX_+cqqoPjT3POEjbQKX1ZDKw@mail.gmail.com>
        <20220826100825.4f79c777@xps-13>
        <CAK-6q+gZ5fSdNptvQoKpf1SOqODv70gzbFTYyWBagC6AFtAkig@mail.gmail.com>
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

Hi Alexander,

aahringo@redhat.com wrote on Sun, 28 Aug 2022 22:31:19 -0400:

> Hi,
>=20
> On Fri, Aug 26, 2022 at 4:08 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> ...
> > >
> > > I need to say that I really used multiple monitors at the same time on
> > > one phy only and I did that with hwsim to run multiple user space
> > > stacks. It was working and I was happy and didn't need to do a lot of
> > > phy creations in hwsim. =20
> >
> > Indeed, looking at the code, you could use as many MONITOR interfaces
> > you needed, but only a single NODE. I've changed that to use as many
> > NODE and COORD that we wish.
> > =20
>=20
> Be careful there, there is a reason why we don't allow this and this
> has to do with support of multiple address filters... but here it
> depends also what you mean with "use".

I've updated this part, you're right I was not careful enough on the
per-iface filtering part, I think it's fine now. Basically, compared to
the v2 sent last week, I've stopped considering that if one interface
was in promiscuous mode, all of them should and did a per-PHY check, so
that otherwise we can apply the necessary filtering if needed.

> I need to admit, you can achieve the same behaviour of multiple user
> space stacks and one monitor, _but_ you can easily filter the traffic
> if you do it per interface...

Thanks,
Miqu=C3=A8l
