Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A102D67EF5F
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 21:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbjA0UMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 15:12:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjA0UMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 15:12:51 -0500
X-Greylist: delayed 1077 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 27 Jan 2023 12:12:48 PST
Received: from relay.sandelman.ca (relay.cooperix.net [176.58.120.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC73044AF;
        Fri, 27 Jan 2023 12:12:47 -0800 (PST)
Received: from dyas.sandelman.ca (unknown [142.169.78.18])
        by relay.sandelman.ca (Postfix) with ESMTPS id 394731F4A5;
        Fri, 27 Jan 2023 19:39:49 +0000 (UTC)
Received: by dyas.sandelman.ca (Postfix, from userid 1000)
        id 2C80DA1807; Fri, 27 Jan 2023 14:39:40 -0500 (EST)
Received: from dyas (localhost [127.0.0.1])
        by dyas.sandelman.ca (Postfix) with ESMTP id 2A691A17E1;
        Fri, 27 Jan 2023 14:39:40 -0500 (EST)
From:   Michael Richardson <mcr@sandelman.ca>
To:     Alexander Aring <aahringo@redhat.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next 0/2] ieee802154: Beaconing support
In-reply-to: <CAK-6q+irhYroxV_P5ORtO9Ui9-Bs=SNS+vO5bZ7_X-geab+XrA@mail.gmail.com>
References: <20230106113129.694750-1-miquel.raynal@bootlin.com> <CAK-6q+jNmvtBKKxSp1WepVXbaQ65CghZv3bS2ptjB9jyzOSGTA@mail.gmail.com> <20230118102058.3b1f275b@xps-13> <CAK-6q+gwP8P--5e9HKt2iPhjeefMXrXUVy-G+szGdFXZvgYKvg@mail.gmail.com> <CAK-6q+gn7W9x2+ihSC41RzkhmBn1E44pKtJFHgqRdd8aBpLrVQ@mail.gmail.com> <20230124110814.6096ecbe@xps-13> <CAB_54W69KcM0UJjf8py-VyRXx2iEUvcAKspXiAkykkQoF6ccDA@mail.gmail.com> <20230125105653.44e9498f@xps-13> <CAK-6q+irhYroxV_P5ORtO9Ui9-Bs=SNS+vO5bZ7_X-geab+XrA@mail.gmail.com>
Comments: In-reply-to Alexander Aring <aahringo@redhat.com>
   message dated "Thu, 26 Jan 2023 20:29:25 -0500."
X-Mailer: MH-E 8.6+git; nmh 1.7+dev; GNU Emacs 26.3
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Date:   Fri, 27 Jan 2023 14:39:40 -0500
Message-ID: <1322777.1674848380@dyas>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain


Alexander Aring <aahringo@redhat.com> wrote:
    >> - MLME ops without feedback constraints like beacons -> should go
    >> through the hot path, but not through the whole net stack, so
    >> ieee802154_subif_start_xmit()
    >>

    > it will bypass the qdisc handling (+ some other things which are around
    > there). The current difference is what I see llsec handling and other
    > things which might be around there? It depends if other "MLME-ops" need
    > to be e.g. encrypted or not.

I haven't followed the whole thread.
So I am neither agreeing nor disagreeing, just clarifying.
Useful beacons are "signed" (have integrity applied), but not encrypted.

It's important for userspace to be able to receive them, even if we don't
have a key that can verify them.  AFAIK, we have no specific interface to
receive beacons.

    >> NB: Perhaps a prerequisites of bringing security to the MLME ops would
    >> be to have wpan-tools updated (it looks like the support was never
    >> merged?) as well as a simple example how to use it on linux-wpan.org.
    >>

    > this is correct. It is still in a branch, I am fine to merge it in this
    > state although it's not really practical to use right now.

:-)


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEERK+9HEcJHTJ9UqTMlUzhVv38QpAFAmPUKHsACgkQlUzhVv38
QpAEIQf/VmalH2lNjcl0ZYTMhoMXYeowU8ZvHbg2ArQ8XNdjOTRYHJ1k55alotPX
sUYITkgKA4wQRob2s9JrvAR4NlfrJ6j96PCbQUqGv1OyvztgQkdhJ5bmnYdz6Gmd
KWhy+IgxX5GPsJbab4jAvQDtP0+dz+FXqo8uULFzXMfU1zl9tmJqzPMktWeHobLM
nOmQcuAVbm48+OLUClBuWZfknuRGXHzx7MiuuIw3oEKkIhDDtZB8HzV+zjgpU1wo
8fvXUQ0k9j3jhlFQkL4ca7aDfHu18dXo+zCKz9IAFUhwQ4U+KlxVFedLGgWasOYR
1KSvlFMeY/qEO5YEeJZwAJNojJDtZQ==
=O6FF
-----END PGP SIGNATURE-----
--=-=-=--
