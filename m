Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A50B6D1774
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 08:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbjCaGda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 02:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbjCaGd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 02:33:29 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2913EB63
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 23:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=k1; bh=j30QLMDESvoyDz9iXByOpZ6fuiif
        C140J3QpR7RkjPQ=; b=oXu9mPTaTxRk6wk56CLilnLn1AJMz6BsqGKKrOmoxSDk
        giEsFLBaGazYey8qG+NZ0qFrWc+XpvN/yx5gR+rww/lXF3owJUEeHoarR+rM6lc4
        1kdYuSl8KXYamdiHBXLAqLrLYstIlsNPBncTnLQBB4/DD5wn/8jldNbqWEX/8rc=
Received: (qmail 1183893 invoked from network); 31 Mar 2023 08:33:24 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 31 Mar 2023 08:33:24 +0200
X-UD-Smtp-Session: l3s3148p1@iTbcYiz4iqAujnv6
Date:   Fri, 31 Mar 2023 08:33:24 +0200
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
Message-ID: <ZCZ+tFtp9NBBjiqv@ninjato>
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
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5qdbPEL+nrZZAkQ+"
Content-Disposition: inline
In-Reply-To: <20230329131724.4484a881@kernel.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--5qdbPEL+nrZZAkQ+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> Okay, core changes aside - does pm_runtime_put() imply an RCU sync?
> Otherwise your check in get_stats is racy...

=46rom some light research, I can't find a trace of RCU sync. Pity, I'll
need to move furhter investigation to later. I'll report back if I have
something, but it may take a while. Thanks for the help!


--5qdbPEL+nrZZAkQ+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmQmfrAACgkQFA3kzBSg
KbaqLw//ZoK8taG1FXjfTLeNELsk6VxQP8Gp7XWth0XTlt6av1jXS8HWdO+zvYfI
HIjujOUzkWqmDJ6YrupRseMl6FXBcWPfKfa/q1eQ68a9Pv0ur+zbhWhKDk/7DaEN
veuSNRzEjOwTqtqJmF6hsjZFPeuoqijb+ObmYMgMHswUfRsuP4OHi3sJRTsFB2+6
jGCrQYJH5tPHifl6nkDvaah57Y6r1gG4zMx9Yq8ON0f92ZwAjkt8q5sgv80NxWJu
3Z+oSa1ysbO2FGqRfH5gVtmrG9wS565O8b6AcD/ZgRP23B+alssS7DNBUVc8FKc0
RyvFwxLxF7LB23EKsu46Xm/C49junk1xhlQpasldrPQmIbPyAA8vcN4F3ruAZLr9
v7kk5g+uSOT3r/dFy6byG7vsh18HsGzhm0wlVh447iAT7fasuRI/79cfuufDqI0v
FI0fVNlWdvsJs+RGl+ZOO3D23fSEYqMiKZSunf/Z/2Mp3H6ZIQKI3QL2G4Ygyjlb
diCVFcV6P5N1VQ1eSkIrRoAPlonzCy7LKJKE22yF4B/odmdOyTY+zaC0tBNvQ4Q8
z5ZzWYOTvBSmZplFmPE6Us3inG2NLCFlHb1WWm9GfuWCjqqgM/54rQbml5IQUR6o
jV1X6s+4tSiOzknY/a0bmZXv/v/LyzctwQrBkyyD3YDdSCnSxk0=
=QAsY
-----END PGP SIGNATURE-----

--5qdbPEL+nrZZAkQ+--
