Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6FE26C9D66
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 10:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbjC0IP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 04:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233024AbjC0IPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 04:15:08 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F6249E6
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 01:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=k1; bh=dBOXurVqj/MpMeq7Dle54wgSV5Q1
        alYox1rkTkRCkMo=; b=AWKXt0Plw+rjd7A3YnNT0Fp9WhzaT4NndoV8v4KBzk3c
        awUQC+4QF6w/JhTh7g0AKsKOjLa1Q3+1OIcDRuHc6+kiYNHWBHJ1/q+PTGaKijVF
        5Zbo6utek8eQ3yzr/x1foY44zomLKuV4Ctn1gEDug/4p2qG1YbRi6ymOgiBrDLg=
Received: (qmail 3059495 invoked from network); 27 Mar 2023 10:14:58 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 27 Mar 2023 10:14:58 +0200
X-UD-Smtp-Session: l3s3148p1@fcW5Vt33HLQujnv6
Date:   Mon, 27 Mar 2023 10:14:58 +0200
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] sh_eth: remove open coded netif_running()
Message-ID: <ZCFQgiqKPaP2Ss08@ninjato>
Mail-Followup-To: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Jakub Kicinski <kuba@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20230321065826.2044-1-wsa+renesas@sang-engineering.com>
 <79d945a4-e105-4bc4-3e73-64971731660e@omp.ru>
 <CAMuHMdUt_kTH3tnrdF=oKBLyjrstei8PLsyr+dFXVoPEyxTLAA@mail.gmail.com>
 <20230323094034.5b021c65@kernel.org>
 <6d2f216c-df1d-9ab5-353c-de5e5e082b57@omp.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2MGGcozzLoV/RlMr"
Content-Disposition: inline
In-Reply-To: <6d2f216c-df1d-9ab5-353c-de5e5e082b57@omp.ru>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--2MGGcozzLoV/RlMr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > Nope - one is under rtnl_lock, the other under just RCU, IIRC.
> > So this patch just makes the race worse, but it was already
> > racy before.
>=20
>    How about reverting it then?

Agreed. Will send a revert.


--2MGGcozzLoV/RlMr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmQhUHcACgkQFA3kzBSg
KbYxbg/+KHZbqTHMix9aCgZXPrX01VDK5eK8U6kE5L+WHoU3RBqqTO1Y3CDf86Mm
T8FFmPGGdP1gQTtpw5uSEDli8AgetRTWvc2T81sw7YDXmR0b5e1eZDacmzxvyi6p
UCF7F6XVnN//1iOVRNdfxeGtK6NASezdITOtgbotF9aZrmy9c0lapd2xfFTOMXUk
+AuL4TRSnxTyCLgieguHbrPdhGq3qbPfVcH88vdnyqINBf1d/Z+8L6QJtWL11qPk
pcqTnFByZ6pU384XS4C/vVejmSujQIpuvyHx3K+okTq5EHJoAPrXRdboX6MOCxAt
shQkOmT19YXHpYxve7AfWSEKUINj3fCU4V41YNXHN12DBbGqbcjPrgPcMN9R/7jN
GMNVMkx7uylXaDfAWnzax6t5J+W/AqB3R2BOHDtjvXaKYikCg+Sx2MgqdI/leZt1
OwYrndoDPzofzBQ1Tcd4Qu5hk94RimpfwngbWkehWa5mXYtLRqgoUNhYcWvkEUZI
Dn6oO+SBKrpacqDH7QI+Q9gh6y2cDwuxLu2FIeHkj1EEzVoVfI6VEBRHd5DY/fsR
zfQnT+WUIcNZbgstdHKI0BaIc0UOltSabcb90F4tmkoFFH3E7hSt8MVhsmiyRi7J
NICb9J/HySL8P5FeSEt2Qw1vP9gh/aM6BfIv4JyXAFbE9aGdDkI=
=6y40
-----END PGP SIGNATURE-----

--2MGGcozzLoV/RlMr--
