Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5BBB3874EC
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 11:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346909AbhERJT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 05:19:59 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:46477 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240078AbhERJT6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 05:19:58 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id B75B05C01C6;
        Tue, 18 May 2021 05:18:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 18 May 2021 05:18:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=pQOEY9
        uzaBbBGayfBBHGueQpT/CjFd/DrtGtIFRgTjc=; b=O7+4JlrellB3ex6Fnt9+Ge
        D/TTpy0wedSr9jVAKUZLwrrmKzob4xubqRF00xZRHC35wvgyVTKvF43lg7A7rmCF
        eeypZyImb6/S8K5I93ous5ioW3PjhKegRNyU5vHYjSSCDD/R6+zvYPtjBEE9mLDd
        BCifk+9YlM4g6GmI5lEJCVyByaQgwvbMGxtqHEKW8gqtTy9bGUEe+YkXEmRAXT6W
        6ExJE42kTGpz5vHh6DUh2gRVBgRHwWi6FJ5SML+cjyHKyMoP08jzvgZERv0AowTq
        z0Wo+99T+9KNcCmjjNiQxPctiP7cbBc2ilUOzbOdSHTS7pmD2AYs1W+1JeRKiZBw
        ==
X-ME-Sender: <xms:b4ajYMtUvRpYzIFR3xZ6t9AdyFx1X__U56fIPDUXNU6prkWUyfFYXQ>
    <xme:b4ajYJeY5fkltpxrdOsoCYdwMqDQ52X5bkJ9rLDsnThNLVQ-aA4k3ifvU7YQK8fp6
    p1EVSkJhZxatw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeijedgudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehgtdorredttdejnecuhfhrohhmpeforghrvghk
    ucforghrtgiihihkohifshhkihdqifpkrhgvtghkihcuoehmrghrmhgrrhgvkhesihhnvh
    hishhisghlvghthhhinhhgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeeiieeh
    jeegteeggeeigffhkeekieefjeduhedvfffhiefgkefhvdevfeejffdvfeenucfkpheple
    durdeijedrjeelrdegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghi
    lhhfrhhomhepmhgrrhhmrghrvghksehinhhvihhsihgslhgvthhhihhnghhslhgrsgdrtg
    homh
X-ME-Proxy: <xmx:b4ajYHz6bUK6MaQZT9XJ2rIQtGIDdwVd2sudeYnUT_iSIMy3e3NP9g>
    <xmx:b4ajYPN6Es-b6nCQkIXvW1OKsJbsTDyFXgGolA18lyp65UcfH5-7UQ>
    <xmx:b4ajYM9vnBNOwYVJN3miUsEXt7N8V5YWJk_TO91IMrAzlWRzJFcI6A>
    <xmx:cIajYLlpLq2OtKOV53j2yNqRQUx3juRbfO2eCSEI116j2J29s_GMcQ>
Received: from mail-itl (ip5b434f04.dynamic.kabel-deutschland.de [91.67.79.4])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Tue, 18 May 2021 05:18:38 -0400 (EDT)
Date:   Tue, 18 May 2021 11:18:35 +0200
From:   Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
To:     paul@xen.org
Cc:     "Durrant, Paul" <pdurrant@amazon.co.uk>,
        Michael Brown <mbrown@fensystems.co.uk>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Ian Jackson <iwj@xenproject.org>, Wei Liu <wl@xen.org>,
        Anthony PERARD <anthony.perard@citrix.com>
Subject: Re: [PATCH] xen-netback: Check for hotplug-status existence before
 watching
Message-ID: <YKOGayhGghjfgNXZ@mail-itl>
References: <404130e4-210d-2214-47a8-833c0463d997@fensystems.co.uk>
 <YJmBDpqQ12ZBGf58@mail-itl>
 <21f38a92-c8ae-12a7-f1d8-50810c5eb088@fensystems.co.uk>
 <YJmMvTkp2Y1hlLLm@mail-itl>
 <df9e9a32b0294aee814eeb58d2d71edd@EX13D32EUC003.ant.amazon.com>
 <YJpfORXIgEaWlQ7E@mail-itl>
 <YJpgNvOmDL9SuRye@mail-itl>
 <9edd6873034f474baafd70b1df693001@EX13D32EUC003.ant.amazon.com>
 <YKLjoALdw4oKSZ04@mail-itl>
 <8b7a9cd5-3696-65c2-5656-a1c8eb174344@xen.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="f87/K/rmaC2eIhg2"
Content-Disposition: inline
In-Reply-To: <8b7a9cd5-3696-65c2-5656-a1c8eb174344@xen.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--f87/K/rmaC2eIhg2
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Tue, 18 May 2021 11:18:35 +0200
From: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
To: paul@xen.org
Cc: "Durrant, Paul" <pdurrant@amazon.co.uk>,
	Michael Brown <mbrown@fensystems.co.uk>,
	"xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"wei.liu@kernel.org" <wei.liu@kernel.org>,
	Ian Jackson <iwj@xenproject.org>, Wei Liu <wl@xen.org>,
	Anthony PERARD <anthony.perard@citrix.com>
Subject: Re: [PATCH] xen-netback: Check for hotplug-status existence before
 watching

On Tue, May 18, 2021 at 07:57:16AM +0100, Paul Durrant wrote:
> On 17/05/2021 22:43, Marek Marczykowski-G=C3=B3recki wrote:
> > On Tue, May 11, 2021 at 12:46:38PM +0000, Durrant, Paul wrote:
> > > I really can't remember any detail. Perhaps try reverting both patche=
s then and check that the unbind/rmmod/modprobe/bind sequence still works (=
and the backend actually makes it into connected state).
> >=20
> > Ok, I've tried this. I've reverted both commits, then used your test
> > script from the 9476654bd5e8ad42abe8ee9f9e90069ff8e60c17:
> >      This has been tested by running iperf as a server in the test VM a=
nd
> >      then running a client against it in a continuous loop, whilst also
> >      running:
> >      while true;
> >        do echo vif-$DOMID-$VIF >unbind;
> >        echo down;
> >        rmmod xen-netback;
> >        echo unloaded;
> >        modprobe xen-netback;
> >        cd $(pwd);
> >        brctl addif xenbr0 vif$DOMID.$VIF;
> >        ip link set vif$DOMID.$VIF up;
> >        echo up;
> >        sleep 5;
> >        done
> >      in dom0 from /sys/bus/xen-backend/drivers/vif to continuously unbi=
nd,
> >      unload, re-load, re-bind and re-plumb the backend.
> > In fact, the need to call `brctl` and `ip link` manually is exactly
> > because the hotplug script isn't executed. When I execute it manually,
> > the backend properly gets back to working. So, removing 'hotplug-status'
> > was in the correct place (netback_remove). The missing part is the tool=
stack
> > calling the hotplug script on xen-netback re-bind.
> >=20
>=20
> Why is that missing? We're going behind the back of the toolstack to do t=
he
> unbind and bind so why should we expect it to re-execute a hotplug script?

Ok, then simply execute the whole hotplug script (instead of its subset)
after re-loading the backend module and everything will be fine.

For example like this:
    XENBUS_PATH=3Dbackend/vif/$DOMID/$VIF \
    XENBUS_TYPE=3Dvif \
    XENBUS_BASE_PATH=3Dbackend \
    script=3D/etc/xen/scripts/vif-bridge \
    vif=3Dvif.$DOMID.$VIF \
    /etc/xen/scripts/vif-bridge online

(...)

> > In short: if device gets XenbusStateInitWait for the first time (ddev =
=3D=3D
> > NULL case), it goes to add_device() which executes the hotplug script
> > and stores the device.
> > Then, if device goes to XenbusStateClosed + online=3D=3D0 state, then it
> > executes hotplug script again (with "offline" parameter) and forgets the
> > device. If you unbind the driver, the device stays in
> > XenbusStateConnected state (in xenstore), and after you bind it again,
> > it goes to XenbusStateInitWait. It don't think it goes through
> > XenbusStateClosed, and online stays at 1 too, so libxl doesn't execute
> > the hotplug script again.
>=20
> This is pretty key. The frontend should not notice an unbind/bind i.e. th=
ere
> should be no evidence of it happening by examining states in xenstore (fr=
om
> the guest side).

If you update the backend module, I think the frontend needs at least to
re-evaluate feature-* nodes. In case of applying just a bug fix, they
should not change (in theory), but technically that would be the correct
thing to do.

--=20
Best Regards,
Marek Marczykowski-G=C3=B3recki
Invisible Things Lab

--f87/K/rmaC2eIhg2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhrpukzGPukRmQqkK24/THMrX1ywFAmCjhmsACgkQ24/THMrX
1yx8oAf/XCZOI2Ckmb3Ii8u0x2jWgKb9lUQJOhjXf1KjxF5xkUaM0EGGflO20D3h
VuobCUFcsEsrjBqJkaKT3mST0yYVyQzQhGerIVEn46UulxekbclZUCfhVylqi4ft
epRzNdTuENg9Rdsb5j7DL2/pq/LVTdOdK5r0En8vXE903YK6ylYj1zlnAl4L5hGP
kDQpRXZZpvvGzCynS6QrIsN3amJY4i+gq4C/WHZzzVBQPbFy2rnDTjlCljaBfd0v
/xA4eoYvJpcg6ia1O5JAKG34sD9I9PeFsY/A+6shzghDe+5L5R/CBCBwU4XNVKg6
wJPOcMJyZijDHT1jacYGybor/WxeoA==
=gEzQ
-----END PGP SIGNATURE-----

--f87/K/rmaC2eIhg2--
