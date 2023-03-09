Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2B86B25C8
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 14:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbjCINsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 08:48:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbjCINsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 08:48:10 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24403F77B;
        Thu,  9 Mar 2023 05:48:03 -0800 (PST)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id E0C5985D80;
        Thu,  9 Mar 2023 14:48:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1678369681;
        bh=1boxd4hO5c3HbEK0rNTKI0bA3sJhy3PS11MqmylPXD8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ChBYno7LjbS+oWrxHHOZbpSSOQIBSjuQxkKUkX5Ud0zpJr3oepzIT974ajVxQeUs2
         Bjg5zDlts+HGFqySSktK3wx1saOYd/9pyCgM9ajX1xxW7cMC2tmLpgfeCEch50O/Bb
         I+GrhZypdOPz6bK/3H4j4jjpGGgRIzyE8WuFeXwgv9itRLTeiD43QZz1vr0OXyN9Jf
         q/VjjPA1sm/CtMIjMCmUN3yUCJsHJZTu5/8+FUHUR7gXLGqGNFwAb//Q8YAtqNOjPr
         HOYni4tK6ln+oRLClfPV6TSVnYmXr23UVDxqN/Nct1K5UBpR/bA9iuS1aMia8N35pO
         B2bkFl+l++bVg==
Date:   Thu, 9 Mar 2023 14:47:52 +0100
From:   Lukasz Majewski <lukma@denx.de>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] dsa: marvell: Add helper function to validate the
 max_frame_size variable
Message-ID: <20230309144752.5e62e037@wsk>
In-Reply-To: <ZAnefI4vCZSIPkEK@shell.armlinux.org.uk>
References: <20230309125421.3900962-1-lukma@denx.de>
        <20230309125421.3900962-6-lukma@denx.de>
        <ZAndSR4L1QvOFta6@shell.armlinux.org.uk>
        <ZAnefI4vCZSIPkEK@shell.armlinux.org.uk>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/lv_wEMCvIFJXo6OqNLGw5zo";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/lv_wEMCvIFJXo6OqNLGw5zo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Russell,

> On Thu, Mar 09, 2023 at 01:21:13PM +0000, Russell King (Oracle) wrote:
> > On Thu, Mar 09, 2023 at 01:54:19PM +0100, Lukasz Majewski wrote: =20
> > > This commit shall be regarded as a transition one, as this
> > > function helps to validate the correctness of max_frame_size
> > > variable added to mv88e6xxx_info structure.
> > >=20
> > > It is necessary to avoid regressions as manual assessment of this
> > > value turned out to be error prone.
> > >=20
> > > Signed-off-by: Lukasz Majewski <lukma@denx.de>
> > > Suggested-by: Russell King (Oracle) <linux@armlinux.org.uk> =20
> >=20
> > Shouldn't this be patch 2 - immediately after populating the
> > .max_frame_size members, and before adding any additional devices? =20
>=20
> Moreover, shouldn't the patch order be:
>=20
> 1, 5, 6 (fixing the entry that needs it), 7 (which then gets the
> max frame size support in place), 4 (so that .set_max_frame_size for
> 6250 is in place), 2, 3
>=20
> ?
>=20
> In other words, get the new infrastructure you need in place first
> (that being the new .max_frame_size and the .set_max_frame_size
> function) before then adding the new support.
>=20

Ok, I will reorder those patches and submit v6.

Do you have any other comments regarding this patch set?


Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/lv_wEMCvIFJXo6OqNLGw5zo
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmQJ44gACgkQAR8vZIA0
zr10yggAo1vG2xwQvNUMsJwxrgZuAvdCXxJe4pYukh5o564iNNp8GdUgC3JitCUZ
B5HLPBH/d4zSqWT2S4cTHOcv1SlSQPLSK/2t6E43nqPOV9hh5HSPnxBR3qB6+Jo0
ReB6EdCi4nlcz7gSrZ4DUwyRFzjhXSaf6GrNcvqOZI4gjczyBmuB/sm4yKfWiNXQ
JwZ09sh8Ynv/mFs6PMVql1L/mRww0cbrysBvTal4jjOmMKpommCpOjPC6CDeYA0E
3Q95qFkyS/4FO2uIzelJ9BCRLMaGDfu+VF2si+hgNFTvSdKb4i3C783PIru/l7cp
Y3GRlVQoycU7ZSlelMDinvKxmJbgMw==
=qWDo
-----END PGP SIGNATURE-----

--Sig_/lv_wEMCvIFJXo6OqNLGw5zo--
