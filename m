Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 096296D1D43
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 11:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbjCaJzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 05:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231934AbjCaJyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 05:54:36 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9825C1EA34
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 02:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=k1; bh=knBfvFI+XBaNKBkXLAa03skuAeIM
        36tCM55o+/JUSuw=; b=2n+y5NGKFFIAGgSVaC4XDfdG9HBzyYNDp2nzzVtjxvwZ
        a9PRdb2HrO7SratzSkxIc8sWlUFGGSW4ZwHllI5AopiceJgo4xSO0FSva0j+LOoi
        6YeGGqa8r5NNJUd+/G7UAqMa2sP5i/0MPsxfPWn+1vtokh7BnJQDSJMCO0fFg9M=
Received: (qmail 1248333 invoked from network); 31 Mar 2023 11:53:50 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 31 Mar 2023 11:53:50 +0200
X-UD-Smtp-Session: l3s3148p1@UUd2Ly/4HI8gAQnoAGp6AVf1ypUvNUaL
Date:   Fri, 31 Mar 2023 11:53:46 +0200
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v4] smsc911x: only update stats when interface is up
Message-ID: <ZCatqhQPAk2KDBG5@kunai>
Mail-Followup-To: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-kernel@vger.kernel.org
References: <20230329064010.24657-1-wsa+renesas@sang-engineering.com>
 <20230329123958.045c9861@kernel.org>
 <ZCSWJxuu1EY/zBFm@shikoro>
 <20230329131724.4484a881@kernel.org>
 <ZCZ+tFtp9NBBjiqv@ninjato>
 <20230330235009.4b6d4b8e@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hS661faOj7ODwf5N"
Content-Disposition: inline
In-Reply-To: <20230330235009.4b6d4b8e@kernel.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--hS661faOj7ODwf5N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > From some light research, I can't find a trace of RCU sync. Pity, I'll
> > need to move furhter investigation to later. I'll report back if I have
> > something, but it may take a while. Thanks for the help!
>=20
> If you don't want to spend too much time you can just call it yourself
> right? :) Put a synchronize_rcu() with a comment about concurrent stat
> reading after pdata->is_open =3D false; and that's it?

Probably. Although I trust you, I would still add code which I a) don't
fully understand myself yet and b) feels somehow wrong because something
like synchronize_rcu() should likely not be in drivers but somewhere
more generic. Given that the bug in this driver went unnoticed for years
(same with the race in other drivers), I do prefer to come back later
with the good feeling that I understood the problem and fixed it
thoroughly.


--hS661faOj7ODwf5N
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmQmraYACgkQFA3kzBSg
KbZKrg/9EGYOcYvQrbvIIqQMB/3LQ6pvRorJh0XNeEpSoe/AlN7tC6adzglzE8Zc
LSMu+JflOlxFdNagxQ0H4bhTOYT2g5aJEFW4tdJUwo9NfJT6GbA2L//qKK4Dze8w
zTXZwrXaoBUNFbp+zC6YHcVQavhc9MGvVaLQo/PATgNVfeJsrngBco+hX4fPR8Sr
HGgocHayjs1KUcMfp2u3UbuZjB02CMMsUzR8k9z0wewu8+ysaVvOjCZGtvq1I3j8
hjSONz0gmZiazARTyFmABS5kNN+ode406U6xO0Hw9PR0pYh6dtAKdR+EL0oM1USW
rXoC2wtpfzR4ZXsGdaGZ1xxUZL/mj4y+P+Yz9aPixqp5LFTvA/3/3VVnRBIOvG88
awsBBKZiayXRh37ZHlX8d5J17hSx22ahC0Kne4bkXg2/qM1JX7u53EH2e4c1NzeH
IGw0nPLU3c/aAHnCw5URtX1w8MIYcOTwSEXadkVRmq0vGbvcTEni8ZQClEEBWekR
yO1WXv1pQGPFJhSHkJQfo499GuJXfUkEo6n3xjYjknp7fMjGBweyq3wYU1bQpIls
Lm5S48laU12WFL/YC4vgwigZUpBYNdkZzzH4WgwZ2gBZ9Ir2bWwzvuEPeVatt5Ve
Auj4LGBi7oDbZC3CpW8SpmImBtKxr7W3Rprvtbx9A7WSnS0t2Q0=
=jOLs
-----END PGP SIGNATURE-----

--hS661faOj7ODwf5N--
