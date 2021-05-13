Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D475438008B
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 00:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbhEMWwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 18:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbhEMWwo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 18:52:44 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBE33C061574;
        Thu, 13 May 2021 15:51:33 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Fh6N134Vjz9sW5;
        Fri, 14 May 2021 08:51:29 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1620946291;
        bh=5X8s9x7hCNYhfbxnbCyNQ7P37vMNwoxzFyLRY49rDeY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HHGhJM3Xf4MQD+TU+o54B/oYhhuz4Km5oin/ROJxmQzzsAAfgcfAwjSROPHDuZX3Y
         BmraFHodj3fShwq1bYORRXRJCT3Eb3djMCCf+IHN6LaUUl4ObX8aJi0BKxO5vXniKu
         3sechXwgNT8/kbiCyL1xHEJMBcdx5HzKAYwFIYyVki9oP0GcuVgPZ1c9KcHl32Ef0H
         Rpb4dfo/5wKRsb/utcsp8vujq/ZbNzQST0SBTQQ0+iccCpCyChZJCuemVCPsvlpWOm
         9Y3EwU24QxLhoXbDagvB/ZXl1tN6VrXqpvhNkFTvtUk5uoLtCpvBGVfNbfxyyog1UP
         cIOS1WNbZEU1Q==
Date:   Fri, 14 May 2021 08:51:28 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Oliver Neukum <oneukum@suse.com>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20210514085128.43026b8c@canb.auug.org.au>
In-Reply-To: <CAMZdPi_CtyM=Rs+OEdRoscqr55qNxmG70AgUckzvyAMvY-amLQ@mail.gmail.com>
References: <20210512095201.09323cda@canb.auug.org.au>
        <20210512095418.0ad4ea4a@canb.auug.org.au>
        <20210513111110.02e1caee@canb.auug.org.au>
        <CAMZdPi_CtyM=Rs+OEdRoscqr55qNxmG70AgUckzvyAMvY-amLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Kr7kHy4DBFAUfq6yvNv7vg3";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Kr7kHy4DBFAUfq6yvNv7vg3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Loic,

On Thu, 13 May 2021 08:35:50 +0200 Loic Poulain <loic.poulain@linaro.org> w=
rote:
>
> On Thu, 13 May 2021 at 03:11, Stephen Rothwell <sfr@canb.auug.org.au> wro=
te:
> >
> > On Wed, 12 May 2021 09:54:18 +1000 Stephen Rothwell <sfr@canb.auug.org.=
au> wrote: =20
> > >
> > > On Wed, 12 May 2021 09:52:01 +1000 Stephen Rothwell <sfr@canb.auug.or=
g.au> wrote: =20
> > > >
> > > > After merging the net-next tree, today's linux-next build (x86_64
> > > > allmodconfig) failed like this:
> > > >
> > > > drivers/usb/class/cdc-wdm.c: In function 'wdm_wwan_port_stop':
> > > > drivers/usb/class/cdc-wdm.c:858:2: error: implicit declaration of f=
unction 'kill_urbs' [-Werror=3Dimplicit-function-declaration]
> > > >   858 |  kill_urbs(desc);
> > > >       |  ^~~~~~~~~
> > > >
> > > > Caused by commit
> > > >
> > > >   cac6fb015f71 ("usb: class: cdc-wdm: WWAN framework integration")
> > > >
> > > > kill_urbs() was removed by commit
> > > >
> > > >   18abf8743674 ("cdc-wdm: untangle a circular dependency between ca=
llback and softint")
> > > >
> > > > Which is included in v5.13-rc1. =20
> > >
> > > Sorry, that commit is only in linux-next (from the usb.current tree).
> > > I will do a merge fix up tomorrow - unless someone provides one.
> > > =20
> > > > I have used the net-next tree from next-20210511 for today. =20
> >
> > I have used the following merge fix patch for today.  I don't know if
> > this is sufficient (or even correct), but it does build. =20
>=20
> Thanks for working on this.
>=20
> >
> > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > Date: Thu, 13 May 2021 11:04:09 +1000
> > Subject: [PATCH] usb: class: cdc-wdm: fix for kill_urbs() removal
> >
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > ---
> >  drivers/usb/class/cdc-wdm.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
> > index c88dcc4b6618..489b0e049402 100644
> > --- a/drivers/usb/class/cdc-wdm.c
> > +++ b/drivers/usb/class/cdc-wdm.c
> > @@ -855,7 +855,7 @@ static void wdm_wwan_port_stop(struct wwan_port *po=
rt)
> >         struct wdm_device *desc =3D wwan_port_get_drvdata(port);
> >
> >         /* Stop all transfers and disable WWAN mode */
> > -       kill_urbs(desc);
> > +       poison_urbs(desc);
> >         desc->manage_power(desc->intf, 0);
> >         clear_bit(WDM_READ, &desc->flags);
> >         clear_bit(WDM_WWAN_IN_USE, &desc->flags); =20
>=20
> AFAIU, each poison call must be balanced with unpoison call.
> So you probably want to call unpoison_urbs right here, similarly to
> wdm_release or wdm_suspend.

I have added that call today.

Thanks for the feedback.

--=20
Cheers,
Stephen Rothwell

--Sig_/Kr7kHy4DBFAUfq6yvNv7vg3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmCdrXAACgkQAVBC80lX
0GyllwgAk5PAqa3+IgXJfdTQqcAWry4rrYdDtDBCXocafx5NverCrvYQLGhMc+vQ
jWz2+W+HiqbKCWsoxn0uCsuiYn9+nBuF/ZUUvVdwQa+V6T4/v/u4R+/kdstkZfHG
hI007XWhcXojvcb0KdTrYaGw8qA7D/ud1AMYrBjOEHlzMi8DJvcYu7FHMJYoza2L
S5OMBoc/rzOaA5cucrf3exaylvxCrwyz/iWeaixRmcRRL8dZrCcWC9lgDQ3B0kaV
U6xf7XIfFKHasqBNJllY+8Smv471VIGn/IzM5CepcZSIKajz7iss7TaqgFjpIjKO
VSd8z8MFlPDlynhj30yMFN1rKnrxJw==
=HuW+
-----END PGP SIGNATURE-----

--Sig_/Kr7kHy4DBFAUfq6yvNv7vg3--
