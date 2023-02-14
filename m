Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D72B696A4F
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 17:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232533AbjBNQuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 11:50:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232528AbjBNQuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 11:50:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87BAB2E0E9
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 08:50:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82299B81BF9
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 16:49:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A34C433EF;
        Tue, 14 Feb 2023 16:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676393379;
        bh=W6B/m734m/kjyz8yYIdkGxVDEUrxtpcevEyOfjHm0fI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mp7Ml6EwpyWc6g/LrmUibcSqt3a54lHoxaY8SquxXrAuN8KNvk5Ci4gnHscJNs3gV
         MiZ04nahIfDS2wSaSNSsLR3F/PGxJMclfCxoWDOS7hwl7dbNJt7oyW4DqBHtoTrLFX
         qjW5A92KXb3oTK3rMNBmt+ULEx9/LOjQ6D3xcdTnQUqZcL9eb4mYetvlxr3cqc8DGD
         a9vpf0c/lolSsSquF1vl8tjdrU7i6tIapqXasA+CqeEVK4sT1NzCDE+nWrAkIBi+wM
         eRgaTb/ybR5N78ZpAW+q7Dxa9EFSPowSKXgWlnksfqyL7PiE1wfRsN1ndd+3T5QG2W
         UNa7p5TpmrFiQ==
Date:   Tue, 14 Feb 2023 17:49:35 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com, edumazet@google.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org, pabeni@redhat.com,
        davem@davemloft.net
Subject: Re: [Intel-wired-lan] [PATCH v2 net-next] ice: update xdp_features
 with xdp multi-buff
Message-ID: <Y+u7n4gRNy+F3fkx@lore-desk>
References: <8a4781511ab6e3cd280e944eef69158954f1a15f.1676385351.git.lorenzo@kernel.org>
 <Y+u6jkfVo4oZWn42@boxer>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hgOXsxVkxdzX+dA9"
Content-Disposition: inline
In-Reply-To: <Y+u6jkfVo4oZWn42@boxer>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--hgOXsxVkxdzX+dA9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Tue, Feb 14, 2023 at 03:39:27PM +0100, Lorenzo Bianconi wrote:
> > Now ice driver supports xdp multi-buffer so add it to xdp_features.
> > Check vsi type before setting xdp_features flag.
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> > Changes since v1:
> > - rebase on top of net-next
> > - check vsi type before setting xdp_features flag
> > ---
> >  drivers/net/ethernet/intel/ice/ice_main.c | 18 ++++++++++++------
> >  1 file changed, 12 insertions(+), 6 deletions(-)
> >=20
> > diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/et=
hernet/intel/ice/ice_main.c
> > index 0712c1055aea..4994a0e5a668 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_main.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> > @@ -2912,7 +2912,7 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bp=
f_prog *prog,
> >  			if (xdp_ring_err)
> >  				NL_SET_ERR_MSG_MOD(extack, "Setting up XDP Tx resources failed");
> >  		}
> > -		xdp_features_set_redirect_target(vsi->netdev, false);
> > +		xdp_features_set_redirect_target(vsi->netdev, true);
> >  		/* reallocate Rx queues that are used for zero-copy */
> >  		xdp_ring_err =3D ice_realloc_zc_buf(vsi, true);
> >  		if (xdp_ring_err)
> > @@ -3333,10 +3333,11 @@ static void ice_napi_add(struct ice_vsi *vsi)
> > =20
> >  /**
> >   * ice_set_ops - set netdev and ethtools ops for the given netdev
> > - * @netdev: netdev instance
> > + * @vsi: the VSI associated with the new netdev
> >   */
> > -static void ice_set_ops(struct net_device *netdev)
> > +static void ice_set_ops(struct ice_vsi *vsi)
> >  {
> > +	struct net_device *netdev =3D vsi->netdev;
> >  	struct ice_pf *pf =3D ice_netdev_to_pf(netdev);
> > =20
> >  	if (ice_is_safe_mode(pf)) {
> > @@ -3348,6 +3349,13 @@ static void ice_set_ops(struct net_device *netde=
v)
> >  	netdev->netdev_ops =3D &ice_netdev_ops;
> >  	netdev->udp_tunnel_nic_info =3D &pf->hw.udp_tunnel_nic;
> >  	ice_set_ethtool_ops(netdev);
> > +
> > +	if (vsi->type !=3D ICE_VSI_PF)
> > +		return;
> > +
> > +	netdev->xdp_features =3D NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRE=
CT |
> > +			       NETDEV_XDP_ACT_XSK_ZEROCOPY |
> > +			       NETDEV_XDP_ACT_RX_SG;
>=20
> FWIW we do support frags in ndo_xdp_xmit() now so
> NETDEV_XDP_ACT_NDO_XMIT_SG should be set.

yep, I have enabled them in ice_xdp_setup_prog() setting support_sg to true=
 in
xdp_features_set_redirect_target().

Regards,
Lorenzo

>=20
> >  }
> > =20
> >  /**
> > @@ -4568,9 +4576,7 @@ static int ice_cfg_netdev(struct ice_vsi *vsi)
> >  	np->vsi =3D vsi;
> > =20
> >  	ice_set_netdev_features(netdev);
> > -	netdev->xdp_features =3D NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRE=
CT |
> > -			       NETDEV_XDP_ACT_XSK_ZEROCOPY;
> > -	ice_set_ops(netdev);
> > +	ice_set_ops(vsi);
> > =20
> >  	if (vsi->type =3D=3D ICE_VSI_PF) {
> >  		SET_NETDEV_DEV(netdev, ice_pf_to_dev(vsi->back));
> > --=20
> > 2.39.1
> >=20
> > _______________________________________________
> > Intel-wired-lan mailing list
> > Intel-wired-lan@osuosl.org
> > https://lists.osuosl.org/mailman/listinfo/intel-wired-lan

--hgOXsxVkxdzX+dA9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY+u7nwAKCRA6cBh0uS2t
rMTHAP93bN/jYu+AAvLkcKUqmaTdtSl/6TN2MOxTBN19p78SYgD9HY7Qo51GylZ/
LCDj5x3hEReTGwgZU/XPaOEdkgLXsQg=
=1ukL
-----END PGP SIGNATURE-----

--hgOXsxVkxdzX+dA9--
