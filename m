Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B370B6E53F9
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 23:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbjDQVjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 17:39:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbjDQVjp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 17:39:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C541BC2
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 14:39:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 602D06230E
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 21:39:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E627C433D2;
        Mon, 17 Apr 2023 21:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681767583;
        bh=1gB+wpeniBRm7xJNTM78fmgVHcAWvLD4FXYSIG00fK4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UXyFq2npFKJ75E9iS9DekJe59swdfge5D0BjRjHUaVNfl06R9XpSEa643jnAC5uTY
         vOfJAmV0JQGOv3T4L8EC/2CVU72TA8Pp9b06rvfWTNzhiNCp7TZdjPoja34NL/kNbw
         GusMfBzTJxwSYXx4p2zK9vdBAXDwDSFIZyctGGhTnmhbhZku3UJHjckbVAavhAUzQ4
         sGpVKH/FMKftlXhiP6x5A+pJ4LUBjZ5JFDQfPqeFgZDR/4LBwJQh8ZgOZzOoanCAEu
         mvl/9DNtI2WgRRxAdtGslk0v51hLsemUdKlumVHZ6ajGd3jUD8i4U2XCl8U2kJuiVw
         Lxm+0xxjN7cGw==
Date:   Mon, 17 Apr 2023 23:39:40 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, hawk@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com,
        lorenzo.bianconi@redhat.com, jdamato@fastly.com
Subject: Re: [PATCH net-next] net: page_pool: add pages and released_pages
 counters
Message-ID: <ZD28nJonfDPiW4F8@lore-desk>
References: <a20f97acccce65d174f704eadbf685d0ce1201af.1681422222.git.lorenzo@kernel.org>
 <20230414184653.21b4303d@kernel.org>
 <ZDqHmCX7D4aXOQzl@lore-desk>
 <20230417111204.08f19827@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="CTTEipT+S1EDNELL"
Content-Disposition: inline
In-Reply-To: <20230417111204.08f19827@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--CTTEipT+S1EDNELL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Sat, 15 Apr 2023 13:16:40 +0200 Lorenzo Bianconi wrote:
> > > What about high order? If we use bulk API for high order one day,=20
> > > will @slow_high_order not count calls like @slow does? So we should
> > > bump the new counter for high order, too. =20
> >=20
> > yes, right. AFAIU "slow_high_order" and "slow" just count number of
> > pages returned to the pool consumer and not the number of pages
> > allocated to the pool (as you said, since we do not use bulking
> > for high_order allocation there is no difference at the moment).
> > What I would like to track is the number of allocated pages
> > (of any order) so I guess we can just increment "pages" counter in
> > __page_pool_alloc_page_order() as well. Agree?
>=20
> Yup, that sounds better.

ack, fine. I am now wondering if these counters are useful just during
debugging or even in the normal use-case.
@Jesper, Ilias, Joe: what do you think?

Regards,
Lorenzo

>=20
> > > Which makes it very similar to pages_state_hold_cnt, just 64bit... =
=20
> >=20
> > do you prefer to use pages_state_hold_cnt instead of adding a new
> > pages counter?
>=20
> No strong preference either way. It's a tradeoff between saving 4B=20
> and making the code a little more complex. Perhaps we should stick=20
> to simplicity and add the counter like you did. Nothing stops us from
> optimizing later.

--CTTEipT+S1EDNELL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZD28nAAKCRA6cBh0uS2t
rF68AQDhDJvlI0FQzfII9/UCDZD7DUzIArl6d477bvoa53KVQAEAh+YvanDznP7q
JayWlwar+xg1pwS4ujcosAI0o4rkWws=
=NfTK
-----END PGP SIGNATURE-----

--CTTEipT+S1EDNELL--
