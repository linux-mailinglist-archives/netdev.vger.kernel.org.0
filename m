Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB48697069
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 23:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233280AbjBNWEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 17:04:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233212AbjBNWEr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 17:04:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 834F28682;
        Tue, 14 Feb 2023 14:04:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 350F7B81F4B;
        Tue, 14 Feb 2023 22:04:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A594C4339B;
        Tue, 14 Feb 2023 22:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676412283;
        bh=6/moDxmLYwHLD8WUxDsiocogzMrZf/bxPoWBkIplzp0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iWbI7t4kQ+YfXoG07dJal5GNImjrtonzwBA+pxloMcs78h01cNJMAyK4HmvAbPOhK
         aY22AFwG+QvGyq1Dq/R6WxwYdz8TuDmkB5DiSjnq0vT4pf/T6AZcAVvPJOl7Laj555
         8IkplQ7q47wOT089E0dfWwPoo+lVaI3PEBkOv5QDAyZZmsW6w6c42CHFxVoY0XrCgF
         K94D63topZHKdE+/ibofV4MbqY/3FIGnyfwy2BR1kpayENn1xyyyUqgPcclfV6qV8y
         b185qmXsaZmps8EZOQaRkpltrvdGLsTq29F3XMQstFP22ig2hxGRL5I+Lb+RnBMrQa
         ugAcjnULHidlg==
Date:   Tue, 14 Feb 2023 22:04:38 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Marc Bornand <dev.mbornand@systemb.ch>
Cc:     Denis Kirjanov <dkirjanov@suse.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kalle Valo <kvalo@kernel.org>,
        Yohan Prod'homme <kernel@zoddo.fr>, stable@vger.kernel.org
Subject: Re: [PATCH v4] Set ssid when authenticating
Message-ID: <Y+wFdg4R1Azpssp4@spud>
References: <20230214132009.1011452-1-dev.mbornand@systemb.ch>
 <13e8e0bb-b2a2-e138-75c0-54e61a5d679e@suse.de>
 <Y+wEtf2dy8hXWYA4@opmb2>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ySt7za8gnO1TLneA"
Content-Disposition: inline
In-Reply-To: <Y+wEtf2dy8hXWYA4@opmb2>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ySt7za8gnO1TLneA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 14, 2023 at 10:01:35PM +0000, Marc Bornand wrote:
> On Tue, Feb 14, 2023 at 04:27:27PM +0300, Denis Kirjanov wrote:

> > On 2/14/23 16:20, Marc Bornand wrote:
> > > changes since v3:
> > > - add missing NULL check
> > > - add missing break
> > >
> > > changes since v2:
> > > - The code was tottaly rewritten based on the disscution of the
> > >   v2 patch.
> > > - the ssid is set in __cfg80211_connect_result() and only if the ssid=
 is
> > >   not already set.
> > > - Do not add an other ssid reset path since it is already done in
> > >   __cfg80211_disconnected()
> > >
> > > When a connexion was established without going through
> > > NL80211_CMD_CONNECT, the ssid was never set in the wireless_dev struc=
t.
> > > Now we set it in __cfg80211_connect_result() when it is not already s=
et.
> >
> > A couple of small nits
> >
> > >
> > > Reported-by: Yohan Prod'homme <kernel@zoddo.fr>
> > > Fixes: 7b0a0e3c3a88260b6fcb017e49f198463aa62ed1
> > Please add a test description to the fixes tag
>=20
> What do you mean by "test description" ?

s/s/x/ ;)

Fixes: 7b0a0e3c3a88 ("wifi: cfg80211: do some rework towards MLO link APIs")

Cheers,
Conor.


--ySt7za8gnO1TLneA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY+wFdgAKCRB4tDGHoIJi
0n4FAQDQZ0yLAERYxZu8ZhVFQmCORJsohZ7+pYuK15xRvYBnogD+LrI1vsI9R5vk
uFBohjgHp/LfDmVPsWpiRmlIcMJaigc=
=WUUA
-----END PGP SIGNATURE-----

--ySt7za8gnO1TLneA--
