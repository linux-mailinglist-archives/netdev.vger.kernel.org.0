Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 051CA5793F6
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 09:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235407AbiGSHSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 03:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233598AbiGSHSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 03:18:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C6B1EC7C;
        Tue, 19 Jul 2022 00:18:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01304B81810;
        Tue, 19 Jul 2022 07:18:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA5DC341C6;
        Tue, 19 Jul 2022 07:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658215088;
        bh=Zpo3d0kFt2DSecXAUJMA9148wQ51zt50WI97410OekI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J+9GJiMRTnsTv2egsEBrsCHjrpOKMoy5LIiO3m3oCv1Pii/hGRb4hONCWnDW8ACDg
         BUsoP27RCtfmbYZ3Z/w9XIE+xWECUJ64ragPzWMEpE7Bh/znE4tN16NDnDCClqOyQM
         AIkxuy43y8cgFmoX7Vm+S0DhrD2KL4dJKyjB4WaRslSo1LReB7SWLKvbyOyb5v73w2
         his4OlfQq5alvg7t5zuVQo1kDTW25e9ISL+j02b18zoaxMTg9vmrOV3dlcZrYC87lk
         i2E/2f2uj/LJPR3d1U/5Nn2IetYDH+p/6qgE3PX2zfIwzVljy0QLWvcNZBIdoK8yVc
         g4a/rlmai909g==
Date:   Tue, 19 Jul 2022 09:18:00 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin __ipraga <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH net-next 2/6] software node: allow named software node
 to be created
Message-ID: <20220719091800.3116daf1@dellmb>
In-Reply-To: <YtXHFQqB3M5Picdl@smile.fi.intel.com>
References: <20220715201715.foea4rifegmnti46@skbuf>
        <YtHPJNpcN4vNfgT6@smile.fi.intel.com>
        <20220715204841.pwhvnue2atrkc2fx@skbuf>
        <YtVSQI5VHtCOTCHc@smile.fi.intel.com>
        <YtVfppMtW77ICyC5@shell.armlinux.org.uk>
        <YtWp3WkpCtfe559l@smile.fi.intel.com>
        <YtWsM1nr2GZWDiEN@smile.fi.intel.com>
        <YtWxMrz3LcVQa43I@shell.armlinux.org.uk>
        <YtWzWdkFVMg0Hyvf@smile.fi.intel.com>
        <20220718223942.245f29b6@thinkpad>
        <YtXHFQqB3M5Picdl@smile.fi.intel.com>
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Jul 2022 23:48:21 +0300
Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

> On Mon, Jul 18, 2022 at 10:39:42PM +0200, Marek Beh=C3=BAn wrote:
> > On Mon, 18 Jul 2022 22:24:09 +0300
> > Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:
> >  =20
> > > On Mon, Jul 18, 2022 at 08:14:58PM +0100, Russell King (Oracle) wrote=
: =20
> > > > On Mon, Jul 18, 2022 at 09:53:39PM +0300, Andy Shevchenko wrote:   =
=20
> > > > > On Mon, Jul 18, 2022 at 09:43:42PM +0300, Andy Shevchenko wrote: =
  =20
> > > > > > On Mon, Jul 18, 2022 at 02:27:02PM +0100, Russell King (Oracle)=
 wrote:   =20
> > > > > > > On Mon, Jul 18, 2022 at 03:29:52PM +0300, Andy Shevchenko wro=
te:   =20
> > > > > > > > On Fri, Jul 15, 2022 at 11:48:41PM +0300, Vladimir Oltean w=
rote:   =20
> > > > > > > > > So won't kobject_init_and_add() fail on namespace collisi=
on? Is it the
> > > > > > > > > problem that it's going to fail, or that it's not trivial=
 to statically
> > > > > > > > > determine whether it'll fail?
> > > > > > > > >=20
> > > > > > > > > Sorry, but I don't see something actionable about this.  =
 =20
> > > > > > > >=20
> > > > > > > > I'm talking about validation before a runtime. But if you t=
hink that is fine,
> > > > > > > > let's fail it at runtime, okay, and consume more backtraces=
 in the future.   =20
> > > > > > >=20
> > > > > > > Is there any sane way to do validation of this namespace befo=
re
> > > > > > > runtime?   =20
> > > > > >=20
> > > > > > For statically compiled, I think we can do it (to some extent).
> > > > > > Currently only three drivers, if I'm not mistaken, define softw=
are nodes with
> > > > > > names. It's easy to check that their node names are unique.
> > > > > >=20
> > > > > > When you allow such an API then we might have tracebacks (from =
sysfs) bout name
> > > > > > collisions. Not that is something new to kernel (we have seen m=
any of a kind),
> > > > > > but I prefer, if possible, to validate this before sysfs issues=
 a traceback.
> > > > > >    =20
> > > > > > > The problem in this instance is we need a node named "fixed-l=
ink" that
> > > > > > > is attached to the parent node as that is defined in the bind=
ing doc,
> > > > > > > and we're creating swnodes to provide software generated node=
s for
> > > > > > > this binding.   =20
> > > > > >=20
> > > > > > And how you guarantee that it will be only a single one with un=
ique pathname?
> > > > > >=20
> > > > > > For example, you have two DSA cards (or whatever it's called) i=
n the SMP system,
> > > > > > it mean that there is non-zero probability of coexisting swnode=
s for them.
> > > > > >    =20
> > > > > > > There could be several such nodes scattered around, but in th=
is
> > > > > > > instance they are very short-lived before they are destroyed,=
 they
> > > > > > > don't even need to be published to userspace (and its probabl=
y a waste
> > > > > > > of CPU cycles for them to be published there.)
> > > > > > >=20
> > > > > > > So, for this specific case, is this the best approach, or is =
there
> > > > > > > some better way to achieve what we need here?   =20
> > > > > >=20
> > > > > > Honestly, I don't know.
> > > > > >=20
> > > > > > The "workaround" (but it looks to me rather a hack) is to creat=
e unique swnode
> > > > > > and make fixed-link as a child of it.
> > > > > >=20
> > > > > > Or entire concept of the root swnodes (when name is provided) s=
hould be
> > > > > > reconsidered, so somehow we will have a uniqueness so that the =
entire
> > > > > > path(s) behind it will be caller-dependent. But this I also don=
't like.
> > > > > >=20
> > > > > > Maybe Heikki, Sakari, Rafael can share their thoughts...
> > > > > >=20
> > > > > > Just for my learning, why PHY uses "fixed-link" instead of rely=
ing on a
> > > > > > (firmware) graph? It might be the actual solution to your probl=
em.
> > > > > >=20
> > > > > > How graphs are used with swnodes, you may look into IPU3 (Intel=
 Camera)
> > > > > > glue driver to support devices before MIPI standardisation of t=
he
> > > > > > respective properties.   =20
> > > > >=20
> > > > > Forgot to say (yes, it maybe obvious) that this API will be expor=
ted,
> > > > > anyone can use it and trap into the similar issue, because, for e=
xample,
> > > > > of testing in environment with a single instance of the caller.  =
 =20
> > > >=20
> > > > I think we're coming to the conclusion that using swnodes is not the
> > > > correct approach for this problem, correct?   =20
> > >=20
> > > If I understand the possibilities of the usage in _this_ case, then i=
t's
> > > would be problematic (it does not mean it's incorrect). It might be d=
ue to
> > > swnode design restrictions which shouldn't be made, I dunno. That' why
> > > it's better to ask the others for their opinions.
> > >=20
> > > By design swnode's name makes not much sense, because the payload the=
re
> > > is a property set, where _name_ is a must.
> > >=20
> > > Now, telling you this, I'm questioning myself why the heck I added na=
mes
> > > to swnodes in the intel_quark_i2c_gpio driver... =20
> >=20
> > 1. the way we use this new named swnode (in patch 5/6 of this series) is
> >    that it gets destroyed immediately after being parsed, so I don't
> >    think there will be collisions in the namespace for forseeable future
> >=20
> >    also, we first create an unnamed swnode for port and only then
> >    fixed-link swnode as a child.
> >=20
> >       new_port_fwnode =3D fwnode_create_software_node(port_props, NULL);
> >       ...
> >       fixed_link_fwnode =3D
> >         fwnode_create_named_software_node(fixed_link_props,
> >                                           new_port_fwnode, "fixed-link"=
);
> >=20
> >    so there shouldn't be a name collision, since the port node gets a
> >    unique name, or am I misunderstanding this? =20
>=20
> This is not problem, but what I was talking about is how to guarantee this
> hierarchy? See what I answered to RNK.
>=20
> > 2. even if there was a problem with name collision, I think the place
> >    that needs to be fixed is swnode system. What use are swnodes if
> >    they cannot be used like this? =20
>=20
> Precisely, that's why I don't want to introduce an API that needs to be f=
ixed.
>=20

Aha, so you want to ensure that root swnodes are created with unique
name?

Can't we just make it so that named software node must have a parent?

Marek
