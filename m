Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 424AD5B59D3
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 14:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiILMBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 08:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbiILMA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 08:00:59 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6800E3DF0B
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 05:00:50 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oXi74-00089r-QC; Mon, 12 Sep 2022 14:00:30 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:75e7:62d4:691e:2f47])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id B82F4E12EF;
        Mon, 12 Sep 2022 12:00:28 +0000 (UTC)
Date:   Mon, 12 Sep 2022 14:00:20 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>,
        edumazet@google.com, kuba@kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] can: bcm: registration process optimization in
 bcm_module_init()
Message-ID: <20220912120020.dlxuryltw4sii635@pengutronix.de>
References: <cover.1662606045.git.william.xuanziyang@huawei.com>
 <823cff0ebec33fa9389eeaf8b8ded3217c32cb38.1662606045.git.william.xuanziyang@huawei.com>
 <381dd961-f786-2400-0977-9639c3f7006e@hartkopp.net>
 <c480bdd7-e35e-fbf9-6767-801e04703780@hartkopp.net>
 <7b063d38-311c-76d6-4e31-02f9cccc9bcb@huawei.com>
 <053c7de3-c76c-82fd-2d44-2e7c1673ae98@hartkopp.net>
 <9228b20a-3baa-32ad-6059-5cf0ffdb97a3@huawei.com>
 <d392c1f4-7ad3-59a4-1358-2c216c498402@hartkopp.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="pfhkvun2s53jnksz"
Content-Disposition: inline
In-Reply-To: <d392c1f4-7ad3-59a4-1358-2c216c498402@hartkopp.net>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--pfhkvun2s53jnksz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09.09.2022 17:04:06, Oliver Hartkopp wrote:
>=20
>=20
> On 09.09.22 05:58, Ziyang Xuan (William) wrote:
> > >=20
> > >=20
> > > On 9/8/22 13:14, Ziyang Xuan (William) wrote:
> > > > > Just another reference which make it clear that the reordering of=
 function calls in your patch is likely not correct:
> > > > >=20
> > > > > https://elixir.bootlin.com/linux/v5.19.7/source/net/packet/af_pac=
ket.c#L4734
> > > > >=20
> > > > > static int __init packet_init(void)
> > > > > {
> > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int rc;
> > > > >=20
> > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rc =3D proto_re=
gister(&packet_proto, 0);
> > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (rc)
> > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
> > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rc =3D sock_reg=
ister(&packet_family_ops);
> > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (rc)
> > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out_proto;
> > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rc =3D register=
_pernet_subsys(&packet_net_ops);
> > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (rc)
> > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out_sock;
> > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rc =3D register=
_netdevice_notifier(&packet_netdev_notifier);
> > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (rc)
> > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out_pernet;
> > > > >=20
> > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
> > > > >=20
> > > > > out_pernet:
> > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unregister_pern=
et_subsys(&packet_net_ops);
> > > > > out_sock:
> > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sock_unregister=
(PF_PACKET);
> > > > > out_proto:
> > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 proto_unregiste=
r(&packet_proto);
> > > > > out:
> > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return rc;
> > > > > }
> > > > >=20
>=20
> > Yes=EF=BC=8Call these socket operations need time, most likely, registe=
r_netdevice_notifier() and register_pernet_subsys() had been done.
> > But it maybe not for some reasons, for example, cpu# that runs {raw,bcm=
}_module_init() is stuck temporary,
> > or pernet_ops_rwsem lock competition in register_netdevice_notifier() a=
nd register_pernet_subsys().
> >=20
> > If the condition which I pointed happens, I think my solution can solve.
> >=20
>=20
> No, I don't think so.
>=20
> We need to maintain the exact order which is depicted in the af_packet.c
> code from above as the notifier call references the sock pointer.

The notifier calls bcm_notifier() first, which will loop over the
bcm_notifier_list. The list is empty if there are no sockets open, yet.
So from my point of view this change looks fine.

IMHO it's better to make a series where all these notifiers are moved in
front of the respective socket proto_register().

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--pfhkvun2s53jnksz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmMfH1EACgkQrX5LkNig
011qwAf/bGFObCZJbGqIckupWOK0uOipTVPxdIGEMiSjj0ojWIxPNhiTt3p8f9kg
aoRrgyocaYHcp8fwvLNUPA6HSRJBqEMYTYCdulywYJmwTZ2OyHq9WfZm9N+zwBm+
kfQojUHpcA2KIAd8bGgIGvqKv1WyW02ZhJIYGszz2YJZaUQMlPKhvmlJZnbszzxt
8EJfXo46SgHM/ENd4M8LVZvpOTr21GDKeQH8mMeRMg79KPvJZKXG6hpUTaVpM7je
pJueB4mnJfi2Q6pepE9inkhVL8F7H9AKxnkzNbmAwey2Hegy7ydw3OKeq/S1tzsl
MkKaONSBw/jybsLpzlYLHTdgJsc57A==
=5HUG
-----END PGP SIGNATURE-----

--pfhkvun2s53jnksz--
