Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0F36E3105
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 13:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbjDOLG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 07:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjDOLGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 07:06:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5105113;
        Sat, 15 Apr 2023 04:06:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F8AB60ABD;
        Sat, 15 Apr 2023 11:06:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD83C433EF;
        Sat, 15 Apr 2023 11:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681556782;
        bh=OfRXHDEAMGckWvo+w3e14CTIL3xcNUSya6MXvwA2H9Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ema41yFq1zd8qy/HvRvuNzL+OJXs0LGuwPI097rMNeMDnNp+ue2nCs9ufdMqPJF9T
         zfHTCB5AZ0nBvERk+cvypQiJbaei8IRPmm6NeA6sSmE8mUxoM9tnNKpyq700D5Amv0
         jZDMM/EffSBP+CG2FliQIm7dPsR0Rz4HpyapvSHhNUBvnGydOCD1yI0/7aSc/JfzRT
         +3iRxe22FkIhnVlfPT/cgPkHajTjTD5yKW/u/irkAJaIc+648cMX5cUvXlP3IkaVdV
         2fAS5LBfA4L2OuhEtqqN5ZxZv8dvk2aLwqY+ZIMuwAr64WSqgNEo3dA6woK+ueLhK1
         out0NG5d9kdUA==
Date:   Sat, 15 Apr 2023 13:06:18 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, joamaki@gmail.com
Subject: Re: [PATCH bpf] selftests/bpf: fix xdp_redirect xdp-features for
 xdp_bonding selftest
Message-ID: <ZDqFKnW/3ML7GAOz@lore-desk>
References: <73f0028461c4f3fa577e24d8d797ddd76f1d17c6.1681507058.git.lorenzo@kernel.org>
 <dc994c7b-c8fe-df8e-7203-0d6dae8dee9f@iogearbox.net>
 <ZDnPXYvfu46i0YpE@lore-desk>
 <dc040740-6823-c524-2580-e9604e04dcb0@iogearbox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="HzxYgRApOA8p9t1J"
Content-Disposition: inline
In-Reply-To: <dc040740-6823-c524-2580-e9604e04dcb0@iogearbox.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--HzxYgRApOA8p9t1J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 4/15/23 12:10 AM, Lorenzo Bianconi wrote:
> > > On 4/14/23 11:21 PM, Lorenzo Bianconi wrote:
> > > > NETDEV_XDP_ACT_NDO_XMIT is not enabled by default for veth driver b=
ut it
> > > > depends on the device configuration. Fix XDP_REDIRECT xdp-features =
in
> > > > xdp_bonding selftest loading a dummy XDP program on veth2_2 device.
> > > >=20
> > > > Fixes: fccca038f300 ("veth: take into account device reconfiguratio=
n for xdp_features flag")
> > >=20
> > > Hm, does that mean we're changing^breaking existing user behavior iff=
 after
> > > fccca038f300 you can only make it work by loading dummy prog?
> >=20
> > nope, even before in order to enable ndo_xdp_xmit for veth you should l=
oad a dummy
> > program on the device peer or enable gro on the device peer:
> >=20
> > https://github.com/torvalds/linux/blob/master/drivers/net/veth.c#L477
> >=20
> > we are just reflecting this behaviour in the xdp_features flag.
>=20
> Ok, I'm confused then why it passed before?

ack, you are right. I guess the issue is in veth driver code. In order to
enable NETDEV_XDP_ACT_NDO_XMIT for device "veth0", we need to check the peer
veth1 configuration since the check in veth_xdp_xmit() is on the peer rx qu=
eue.
Something like:

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index e1b38fbf1dd9..4b3c6647edc6 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1262,11 +1262,12 @@ static void veth_set_xdp_features(struct net_device=
 *dev)
=20
 	peer =3D rtnl_dereference(priv->peer);
 	if (peer && peer->real_num_tx_queues <=3D dev->real_num_rx_queues) {
+		struct veth_priv *priv_peer =3D netdev_priv(peer);
 		xdp_features_t val =3D NETDEV_XDP_ACT_BASIC |
 				     NETDEV_XDP_ACT_REDIRECT |
 				     NETDEV_XDP_ACT_RX_SG;
=20
-		if (priv->_xdp_prog || veth_gro_requested(dev))
+		if (priv_peer->_xdp_prog || veth_gro_requested(peer))
 			val |=3D NETDEV_XDP_ACT_NDO_XMIT |
 			       NETDEV_XDP_ACT_NDO_XMIT_SG;
 		xdp_set_features_flag(dev, val);
@@ -1504,19 +1505,23 @@ static int veth_set_features(struct net_device *dev,
 {
 	netdev_features_t changed =3D features ^ dev->features;
 	struct veth_priv *priv =3D netdev_priv(dev);
+	struct net_device *peer;
 	int err;
=20
 	if (!(changed & NETIF_F_GRO) || !(dev->flags & IFF_UP) || priv->_xdp_prog)
 		return 0;
=20
+	peer =3D rtnl_dereference(priv->peer);
 	if (features & NETIF_F_GRO) {
 		err =3D veth_napi_enable(dev);
 		if (err)
 			return err;
=20
-		xdp_features_set_redirect_target(dev, true);
+		if (peer)
+			xdp_features_set_redirect_target(peer, true);
 	} else {
-		xdp_features_clear_redirect_target(dev);
+		if (peer)
+			xdp_features_clear_redirect_target(peer);
 		veth_napi_del(dev);
 	}
 	return 0;
@@ -1598,13 +1603,13 @@ static int veth_xdp_set(struct net_device *dev, str=
uct bpf_prog *prog,
 			peer->max_mtu =3D max_mtu;
 		}
=20
-		xdp_features_set_redirect_target(dev, true);
+		xdp_features_set_redirect_target(peer, true);
 	}
=20
 	if (old_prog) {
 		if (!prog) {
-			if (!veth_gro_requested(dev))
-				xdp_features_clear_redirect_target(dev);
+			if (peer && !veth_gro_requested(dev))
+				xdp_features_clear_redirect_target(peer);
=20
 			if (dev->flags & IFF_UP)
 				veth_disable_xdp(dev);

What do you think?

Regards,
Lorenzo

>=20
> > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > ---
> > > >    tools/testing/selftests/bpf/prog_tests/xdp_bonding.c | 11 ++++++=
+++++
> > > >    1 file changed, 11 insertions(+)
> > > >=20
> > > > diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_bonding.c b=
/tools/testing/selftests/bpf/prog_tests/xdp_bonding.c
> > > > index 5e3a26b15ec6..dcbe30c81291 100644
> > > > --- a/tools/testing/selftests/bpf/prog_tests/xdp_bonding.c
> > > > +++ b/tools/testing/selftests/bpf/prog_tests/xdp_bonding.c
> > > > @@ -168,6 +168,17 @@ static int bonding_setup(struct skeletons *ske=
letons, int mode, int xmit_policy,
> > > >    		if (xdp_attach(skeletons, skeletons->xdp_dummy->progs.xdp_dumm=
y_prog, "veth1_2"))
> > > >    			return -1;
> > > > +
> > > > +		if (!ASSERT_OK(setns_by_name("ns_dst"), "set netns to ns_dst"))
> > > > +			return -1;
> > > > +
> > > > +		/* Load a dummy XDP program on veth2_2 in order to enable
> > > > +		 * NETDEV_XDP_ACT_NDO_XMIT feature
> > > > +		 */
> > > > +		if (xdp_attach(skeletons, skeletons->xdp_dummy->progs.xdp_dummy_=
prog, "veth2_2"))
> > > > +			return -1;
> > > > +
> > > > +		restore_root_netns();
> > > >    	}
> > > >    	SYS("ip -netns ns_dst link set veth2_1 master bond2");

--HzxYgRApOA8p9t1J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZDqFKgAKCRA6cBh0uS2t
rF7IAP9BgVrJUxfDB+2VyU6UWIaLBlsAMr5jtcb9fVBrJDm5mQD/UUWAAQhwgn+a
OyuTzb8iaLgu1KBl73UVeYMcXm8LmAs=
=cFGU
-----END PGP SIGNATURE-----

--HzxYgRApOA8p9t1J--
