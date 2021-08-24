Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80413F6856
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 19:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239000AbhHXRoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 13:44:06 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:49662 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242445AbhHXRmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 13:42:10 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 22AB722144;
        Tue, 24 Aug 2021 17:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1629826884; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gVamMwtKCJjRWQhUZD5IFZbj0RUM1MuJs/RoHD+PyEs=;
        b=adlUHC9hFvkDc9IgqbsMgzyIewSR3gy5fXjSfhx92U0MhwGuIBlCWOurpVALLF/UTWiTKU
        RSPXLQrvadghCdaez5ulnFMGRsqANHSYcvJmhooE0t7nhX4ezVrVlOIyIkwGTWQ1aQGDXr
        0dKes2RyO9p4VxGOAE8yD9ozyFIsH8k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1629826884;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gVamMwtKCJjRWQhUZD5IFZbj0RUM1MuJs/RoHD+PyEs=;
        b=I9oB8Mk1wq70iWCFq+IthjOTb8Vk4gf7eTEsttF4Ut5SEPwPPeaJnjIaCZCe1zIgVz53zg
        PXYL1RnodKaDdPAQ==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 1721DA3BE1;
        Tue, 24 Aug 2021 17:41:24 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id ED1B4603F6; Tue, 24 Aug 2021 19:41:23 +0200 (CEST)
Date:   Tue, 24 Aug 2021 19:41:23 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, dcavalca@fb.com,
        filbranden@fb.com, michel@fb.com
Subject: Re: [PATCH ethtool 2/3] ethtool: use dummy args[] entry for no-args
 case
Message-ID: <20210824174123.h6iispbooeqrychw@lion.mk-sys.cz>
References: <20210813171938.1127891-1-kuba@kernel.org>
 <20210813171938.1127891-3-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jxrlllaxyudkdyoa"
Content-Disposition: inline
In-Reply-To: <20210813171938.1127891-3-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--jxrlllaxyudkdyoa
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 13, 2021 at 10:19:37AM -0700, Jakub Kicinski wrote:
> Note that this patch adds a false-positive warning with GCC 11:
>=20
> ethtool.c: In function =E2=80=98find_option=E2=80=99:
> ethtool.c:6082:29: warning: offset =E2=80=981=E2=80=99 outside bounds of =
constant string [-Warray-bounds]
>  6082 |                         opt +=3D len + 1;
>       |                         ~~~~^~~~~~~~~~
>=20
> we'll never get to that code if the string is empty.

Unless I missed something, an easy workaround should be starting the
loop in find_option() from 1 rather than from 0. It would IMHO even make
more sense as there is little point comparing the first argument against
the dummy args[0] entry.

Michal

--jxrlllaxyudkdyoa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmElLz0ACgkQ538sG/LR
dpUFSAgAnFenzvqxb7rBh9ffKVh7aZbKBu4X03q69qvdD5gs5czm/OlUDzGBbZZK
3SVke4/7ZPO8kyxkKTXRIlTahoUkgbdnOMktKK438l2H+chnnylpHL1VeTsXd1rp
epmqwhgKdd7TGZvN7Peycmaxv9rOUXBuV1nfg3P4yWVg8VWucgmAsiEsHgBbKp61
H94oe/z1ser3S5/ifB3F5ZcmYQQJHkLm4thGLg/pN6Om2d+D8J/1Spspkfv1Mlq3
pZBvYnOO3Ue+5tgJ9dysqvuYEpl1uLgEFRzcwFCfbIPio2UjcQfB6BBXdnbPuhHq
dCAbQ4Zr8W9UE1i3paGxv/tanHcGyQ==
=eQiM
-----END PGP SIGNATURE-----

--jxrlllaxyudkdyoa--
