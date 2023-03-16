Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 755BB6BCD43
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 11:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbjCPKvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 06:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjCPKvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 06:51:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8336D65BE;
        Thu, 16 Mar 2023 03:51:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2874B61FD7;
        Thu, 16 Mar 2023 10:51:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD5EC433D2;
        Thu, 16 Mar 2023 10:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678963879;
        bh=xiPIb8+Q4UJ4wW93hhwCVGhKL7SNf8ibQmalvww6fW4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MN2tOFO3KcXeFwwAQFVithapHhc9Rf6hQon5Yfe87Tb9epmMATRa0QszTCBYtOowk
         1NLke/UmDrH7v0QtvpzREwcpBSkAAF/1MEIMcmu4GT9caAlb79wFP5Gvwj3S2JZjNN
         dYbAf2PhJ2B0sIS3XrbIqnVSf8K69EwXtFRmCjVGu5wUYUANoFVNQOYUsxA60FI9W/
         dkg+XAZ+aZ6AdgB8cWp+Wa0HFTeXvRIAmeTwthLikcirwiXNYXqG4v/e0kb2D2eoQp
         CxA7F5+YJoQzN5BeCIdwyxVuEq5UhL3p7WeYKgnfjtHW5MggDbEw/fLcB9GmR3RMX9
         HSl3ulFaU3l9Q==
Date:   Thu, 16 Mar 2023 12:03:57 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, tariqt@nvidia.com, bpf@vger.kernel.org
Subject: Re: [PATCH net] net: xdp: don't call notifiers during driver init
Message-ID: <ZBL3nVZ4LVWUPRva@localhost.localdomain>
References: <20230316002903.492497-1-kuba@kernel.org>
 <ebe10b79-34c2-4e85-2cf7-b7491266748e@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="CH98NzvD0Jqt94fk"
Content-Disposition: inline
In-Reply-To: <ebe10b79-34c2-4e85-2cf7-b7491266748e@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--CH98NzvD0Jqt94fk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

>=20
>=20
> On 16/03/2023 2:29, Jakub Kicinski wrote:
> > Drivers will commonly perform feature setting during init, if they use
> > the xdp_set_features_flag() helper they'll likely run into an ASSERT_RT=
NL()
> > inside call_netdevice_notifiers_info().
> >=20
> > Don't call the notifier until the device is actually registered.
> > Nothing should be tracking the device until its registered.
> >=20
> > Fixes: 4d5ab0ad964d ("net/mlx5e: take into account device reconfigurati=
on for xdp_features flag")
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> > CC: ast@kernel.org
> > CC: daniel@iogearbox.net
> > CC: hawk@kernel.org
> > CC: john.fastabend@gmail.com
> > CC: lorenzo@kernel.org
> > CC: tariqt@nvidia.com
> > CC: bpf@vger.kernel.org
> > ---
> >   net/core/xdp.c | 3 +++
> >   1 file changed, 3 insertions(+)
> >=20
> > diff --git a/net/core/xdp.c b/net/core/xdp.c
> > index 87e654b7d06c..5722a1fc6e9e 100644
> > --- a/net/core/xdp.c
> > +++ b/net/core/xdp.c
> > @@ -781,6 +781,9 @@ void xdp_set_features_flag(struct net_device *dev, =
xdp_features_t val)
> >   		return;
> >   	dev->xdp_features =3D val;
> > +
> > +	if (dev->reg_state < NETREG_REGISTERED)
> > +		return;
>=20
> I maybe need to dig deeper, but, it looks strange to still
> call_netdevice_notifiers in cases > NETREG_REGISTERED.
>=20
> Isn't it problematic to call it with NETREG_UNREGISTERED ?
>=20
> For comparison, netif_set_real_num_tx_queues has this ASSERT_RTNL() only
> under dev->reg_state =3D=3D NETREG_REGISTERED || dev->reg_state =3D=3D
> NETREG_UNREGISTERING.

does it make sense to run call_netdevice_notifiers() in xdp_set_features_fl=
ag()
just if dev->reg_state is NETREG_REGISTERED?
Moreover, looking at the code it seems netdev code can run with dev->reg_st=
ate
set to NETREG_UNREGISTERED and without holding RTNL lock, right?

Regards,
Lorenzo

>=20
> >   	call_netdevice_notifiers(NETDEV_XDP_FEAT_CHANGE, dev);
> >   }
> >   EXPORT_SYMBOL_GPL(xdp_set_features_flag);

--CH98NzvD0Jqt94fk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZBL3mgAKCRA6cBh0uS2t
rMphAP42u+uRvCdXF5ch/08W4qaGU07ZVaIrKLefmthSmLsyqAD/W0BKCQdhy2O0
zCy88wPIYw9BogGQVJCbrEcuC5Zwkwc=
=qoyD
-----END PGP SIGNATURE-----

--CH98NzvD0Jqt94fk--
