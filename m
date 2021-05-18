Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81DF93876CC
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 12:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243722AbhERKnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 06:43:43 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48295 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243193AbhERKnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 06:43:40 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 04EE35C00CC;
        Tue, 18 May 2021 06:42:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 18 May 2021 06:42:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=A1IP30
        HlocCCSSewwTTQKoI3s1gaJPVsV9LOgsd0CWU=; b=PDd2AlXO81dFZXzywDoRBh
        a63zAUk2V9q1iSsGg5X1gFq3efI4ALWqUkn4508HsyVIA5G94DTpbUkGnBl0fCQF
        G5ej9sK73N4brI2B2w2edoTXNKYjjLFlT39RTJp2dTpSAE+bHgX0pBdzw6KgHZwd
        TAnY5WG1SNX/KSs2lifgfPIOWeNWDqkse2xPnGhIDsU1506qk/S3ntKyswn6R7lP
        ITFPcGGVvCAsG5YoVkkooMHwSnhS8K2FvyuUhOdIMStteNld/tlBkl9Gv1Km2vXH
        tfOOGLac9Wci1w7H88ecY53DxGxZ8AtC/pWn2wBY4g26ooK7a8pZXMUfElBjz2fg
        ==
X-ME-Sender: <xms:BpqjYFvNjlVWTJ4Vk5D7XAE3lpEWEfjS6el9uPIDEvT8Xl39_utgjA>
    <xme:BpqjYOdNJzy0IUMeBEaW8LKOekqSMH2KoneVIYPa5Cel72kg9h0hts-ycQYjUgd_W
    WaUF18js64t7A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeijedgfedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehgtderredttdejnecuhfhrohhmpeforghrvghk
    ucforghrtgiihihkohifshhkihdqifpkrhgvtghkihcuoehmrghrmhgrrhgvkhesihhnvh
    hishhisghlvghthhhinhhgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeetveff
    iefghfekhffggeeffffhgeevieektedthfehveeiheeiiedtudegfeetffenucfkpheple
    durdeijedrjeelrdegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghi
    lhhfrhhomhepmhgrrhhmrghrvghksehinhhvihhsihgslhgvthhhihhnghhslhgrsgdrtg
    homh
X-ME-Proxy: <xmx:BpqjYIwNDgcxGaUt_ioEaRwdThfVwvp_T0jJqf72wietrjCbpBl2TQ>
    <xmx:BpqjYMP4GssPYn30Z3GaO2PxxRSyHVRvyJUKIme98PDkMRiVZ7gK9Q>
    <xmx:BpqjYF_hAmAd4Mr-OL69JtqbQzDvP0yucH6qvweNN-8tIcQpyfU7Ng>
    <xmx:B5qjYBbHVDNzO1Qw5mikBbtXDwnvS9eURlR4Sp-U7JNg-IuDWOQDwQ>
Received: from mail-itl (ip5b434f04.dynamic.kabel-deutschland.de [91.67.79.4])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Tue, 18 May 2021 06:42:12 -0400 (EDT)
Date:   Tue, 18 May 2021 12:42:09 +0200
From:   Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
To:     "Durrant, Paul" <pdurrant@amazon.co.uk>
Cc:     Michael Brown <mbrown@fensystems.co.uk>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Ian Jackson <iwj@xenproject.org>, Wei Liu <wl@xen.org>,
        Anthony PERARD <anthony.perard@citrix.com>
Subject: Re: [PATCH] xen-netback: Check for hotplug-status existence before
 watching
Message-ID: <YKOaAjdO5H3dRTiK@mail-itl>
References: <df9e9a32b0294aee814eeb58d2d71edd@EX13D32EUC003.ant.amazon.com>
 <YJpfORXIgEaWlQ7E@mail-itl>
 <YJpgNvOmDL9SuRye@mail-itl>
 <9edd6873034f474baafd70b1df693001@EX13D32EUC003.ant.amazon.com>
 <YKLjoALdw4oKSZ04@mail-itl>
 <8b7a9cd5-3696-65c2-5656-a1c8eb174344@xen.org>
 <YKOGayhGghjfgNXZ@mail-itl>
 <887f9533f5c54bfabfbff7231eb99b08@EX13D32EUC003.ant.amazon.com>
 <YKOMpXwcnr9QiXy8@mail-itl>
 <2c23e102b6254e42877eb1e8fe68a4f7@EX13D32EUC003.ant.amazon.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6EOIiVkRIQqWqOV/"
Content-Disposition: inline
In-Reply-To: <2c23e102b6254e42877eb1e8fe68a4f7@EX13D32EUC003.ant.amazon.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6EOIiVkRIQqWqOV/
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Tue, 18 May 2021 12:42:09 +0200
From: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
To: "Durrant, Paul" <pdurrant@amazon.co.uk>
Cc: Michael Brown <mbrown@fensystems.co.uk>,
	"xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"wei.liu@kernel.org" <wei.liu@kernel.org>,
	Ian Jackson <iwj@xenproject.org>, Wei Liu <wl@xen.org>,
	Anthony PERARD <anthony.perard@citrix.com>
Subject: Re: [PATCH] xen-netback: Check for hotplug-status existence before
 watching

On Tue, May 18, 2021 at 09:48:25AM +0000, Durrant, Paul wrote:
> > -----Original Message-----
> > From: Marek Marczykowski-G=C3=B3recki <marmarek@invisiblethingslab.com>
> >=20
> > On Tue, May 18, 2021 at 09:34:45AM +0000, Durrant, Paul wrote:
> > > > -----Original Message-----
> > > > From: Marek Marczykowski-G=C3=B3recki <marmarek@invisiblethingslab.=
com>
> > > >
> > > > On Tue, May 18, 2021 at 07:57:16AM +0100, Paul Durrant wrote:
> > > > > Why is that missing? We're going behind the back of the toolstack=
 to do the
> > > > > unbind and bind so why should we expect it to re-execute a hotplu=
g script?
> > > >
> > > > Ok, then simply execute the whole hotplug script (instead of its su=
bset)
> > > > after re-loading the backend module and everything will be fine.
> > > >
> > > > For example like this:
> > > >     XENBUS_PATH=3Dbackend/vif/$DOMID/$VIF \
> > > >     XENBUS_TYPE=3Dvif \
> > > >     XENBUS_BASE_PATH=3Dbackend \
> > > >     script=3D/etc/xen/scripts/vif-bridge \
> > > >     vif=3Dvif.$DOMID.$VIF \
> > > >     /etc/xen/scripts/vif-bridge online
> > > >
> > >
> > > ... as long as there's no xenstore fall-out that the guest can observ=
e.
> >=20
> > Backend will set state to XenbusStateInitWait on load anyway...
> >=20
>=20
> Oh, that sounds like a bug then... It ought to go straight to connected i=
f the frontend is already there.

To me this sounds very suspicious. But if that's really what should
backend do, then it would "solve" also hotplug-status node issue.
See the end of netback_probe() function.
But I think if you start processing traffic before hotplug script
configures the interface (so - without switching to XenbusStateInitWait
and waiting for hotplug-status node), you'll post some packets into not
enabled interface, which I think will drop them (not queue). TCP will be
fine with that, but many other protocols not.

--=20
Best Regards,
Marek Marczykowski-G=C3=B3recki
Invisible Things Lab

--6EOIiVkRIQqWqOV/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhrpukzGPukRmQqkK24/THMrX1ywFAmCjmgEACgkQ24/THMrX
1yzCmwf/QjWF5aAIE38gHNVk+1kC9JDgsgIoaXSFus+0rK5dcZvAPXv15NxNpSeF
IGm9jhgEylYrv/cj/bwx8Wq1H2bKS2Dr3s3qxr3nP7MSCHxn3EmhaPy+5ZzhHkY4
nrlD6xqRSEV1aPoNVX97oASD5eLIZCai21T36fqk4ZH1YJfVy29mqI695ZRR0IFP
5wkIu7JgRyCGrqWVB0/RWjCuw3A2vGU3lIe4wKkS67K6EjCSh26V+/GDtKoJA07i
RH0W3V5iwOvsw0S9PtSDGelb+9SUP8gbqvcJ2akMLyxhOxVkM6ao0/1Xc+IwHxbt
xdURruEb31oJbMXvIC4caVACSmN9dQ==
=2E+b
-----END PGP SIGNATURE-----

--6EOIiVkRIQqWqOV/--
