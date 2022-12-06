Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64CE0644488
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 14:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbiLFNaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 08:30:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234142AbiLFNaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 08:30:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12AB0248EF
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 05:30:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBAF7B81A23
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 13:30:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57ED9C43470;
        Tue,  6 Dec 2022 13:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670333445;
        bh=38B3P6lnwN8ZtkN25kO81Y8I6An36uiPUKfvYOIiPtY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M3m/wmL0DWYrAcTVJjYLD+z0IJLY2o/wwqlkAb3efQ3lZaf7ZqsrgAitEcC1YGYTv
         PlfWb+2RinBWrXkYFj67M9dWME7UIxyWkTDgIV8JtX6vTUaHKYnAxpdtT/g2qswlqL
         j0Ut4S0DFSGfA+u5WdVrCSCkG5HFMhUBPj/zf2GoNS49m2PUdDM0hCSsWdMEHHiDM0
         kuBOLw/lHiYau91/g3Y0HNYM4Ew6cotEHRAA11j1Dp88CNIp+Hn/p5RwUZjEZPAx//
         HJR3BMKaXmkpsrMbLk1jVStAHYrmQKuoW72c27knktbiRKUANDwyzmtY4XSAKyd2ip
         yfifkkhvbsy2g==
Date:   Tue, 6 Dec 2022 14:30:41 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, claudiu.manoil@nxp.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com
Subject: Re: [PATCH net-next] net: ethernet: enetc: set frag flag for
 non-linear xdp buffers
Message-ID: <Y49EARwosUGZfvcL@lore-desk>
References: <df882eddcf76b5d0ae53c19f368a617713462fd3.1670193080.git.lorenzo@kernel.org>
 <20221206123552.6yqwxg3tlakgnkmf@skbuf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="+mwzb22cGmFKlMjD"
Content-Disposition: inline
In-Reply-To: <20221206123552.6yqwxg3tlakgnkmf@skbuf>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--+mwzb22cGmFKlMjD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Hi Lorenzo,

Hi Vladimir,

>=20
> On Sun, Dec 04, 2022 at 11:33:23PM +0100, Lorenzo Bianconi wrote:
> > Set missing XDP_FLAGS_HAS_FRAGS bit in enetc_add_rx_buff_to_xdp for
> > non-linear xdp buffers.
> >=20
> > Fixes: d1b15102dd16 ("net: enetc: add support for XDP_DROP and XDP_PASS=
")
>=20
> This can't be the Fixes: tag, struct xdp_buff didn't even have a "flags"
> field when that commit was introduced.

yes, my fault, I did not check dates, I assumed this commit was done after =
xdp
multi-buff support. We should get rid of the Fixes tag.

>=20
> Also, what does this change aim to achieve? It has a Fixes: tag but it's
> aimed for net-next. Is it to enable multi-buff XDP support? But we also
> have this in place, shouldn't that be deleted too?

I think we should get rid of the chunk below as well. I am currently workin=
g on
xdp feature support in order to allow XDP_REDIRECT for S/G xdp frames.
I will post a v2.

Regards,
Lorenzo

>=20
> 		case XDP_REDIRECT:
> 			/* xdp_return_frame does not support S/G in the sense
> 			 * that it leaks the fragments (__xdp_return should not
> 			 * call page_frag_free only for the initial buffer).
> 			 * Until XDP_REDIRECT gains support for S/G let's keep
> 			 * the code structure in place, but dead. We drop the
> 			 * S/G frames ourselves to avoid memory leaks which
> 			 * would otherwise leave the kernel OOM.
> 			 */
> 			if (unlikely(cleaned_cnt - orig_cleaned_cnt !=3D 1)) {
> 				enetc_xdp_drop(rx_ring, orig_i, i);
> 				rx_ring->stats.xdp_redirect_sg++;
> 				break;
> 			}

--+mwzb22cGmFKlMjD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY49EAQAKCRA6cBh0uS2t
rL7xAP0R2SttM2oaxvts4kOJOmkQE+oExSbVX3UItod+JfRd8gD/QgA2C8MG4McZ
r68ET/C1nPAwkYUUsu0iKnksWZ//aAw=
=nY+K
-----END PGP SIGNATURE-----

--+mwzb22cGmFKlMjD--
