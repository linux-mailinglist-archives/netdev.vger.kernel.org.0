Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4083D66A74A
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 00:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbjAMX5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 18:57:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbjAMX5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 18:57:43 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB277466F
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 15:57:41 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id DE8385C6F0;
        Fri, 13 Jan 2023 23:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1673654258; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=n/Vx8UJUHuHTIzKG7+ocWPm84VMGhwGCVMYDbmIXrJs=;
        b=gHr/m2RduLJ/BDvGk7nspPc3o7JJZuiEziDKm/Jzc+HUcLYQnqNoKvaOoSv5/MEnyehcgc
        0QRvy5CIEehreImVYhYq+lQEf6tq/Fjlv+4NuQhirjjI8kwmP+1y2QCdK2Bk0m8kRKK3Ig
        WydPl8mKdQffpCG3GZLzwHExQox/pQ4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1673654258;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=n/Vx8UJUHuHTIzKG7+ocWPm84VMGhwGCVMYDbmIXrJs=;
        b=qYUCEZTKUk6syGfxpGPMFSexTVWC60SKF8gDA8P6ERMi7lS5uTMJ3GlF6nMgqlSfF4VucK
        8eCLhfGIce9AB3BA==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id D21462C141;
        Fri, 13 Jan 2023 23:57:38 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id ACAB860330; Sat, 14 Jan 2023 00:57:38 +0100 (CET)
Date:   Sat, 14 Jan 2023 00:57:38 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Markus Mayer <mmayer@broadcom.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH ethtool 1/3] misc: Fix build with kernel headers < v4.11
Message-ID: <20230113235738.wyaf3rg63olkwixw@lion.mk-sys.cz>
References: <20230113233148.235543-1-f.fainelli@gmail.com>
 <20230113233148.235543-2-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2vyyi26fe2shrq3h"
Content-Disposition: inline
In-Reply-To: <20230113233148.235543-2-f.fainelli@gmail.com>
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--2vyyi26fe2shrq3h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 13, 2023 at 03:31:46PM -0800, Florian Fainelli wrote:
> Not all toolchain kernel headers may contain upstream commit
> 2618be7dccf8739b89e1906b64bd8d551af351e6 ("uapi: fix linux/if.h
> userspace compilation errors") which is included in v4.11 and onwards.
> Err on the side of caution by including sys/socket.h ahead of including
> linux/if.h.
>=20
> Fixes: 1fa60003a8b8 ("misc: header includes cleanup")
> Reported-by: Markus Mayer <mmayer@broadcom.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  internal.h | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/internal.h b/internal.h
> index b80f77afa4c0..f7aaaf5229f4 100644
> --- a/internal.h
> +++ b/internal.h
> @@ -21,6 +21,7 @@
>  #include <unistd.h>
>  #include <endian.h>
>  #include <sys/ioctl.h>
> +#include <sys/socket.h>
>  #include <linux/if.h>
> =20
>  #include "json_writer.h"

No objection but I wonder if it wouldn't make sense to add linux/if.h to
the header copies in uapi/ instead as then we could also drop the
fallback definition of ALTIFNAMSIZ and perhaps more similar hacks.

Michal

--2vyyi26fe2shrq3h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmPB7+0ACgkQ538sG/LR
dpUH0gf/dzEcNgyveKQXD4iFgRj+CHxTNPexKV49WlXd/Vm6IDqk1sm+YXfFzx5t
FOc/sKttEOSN6znfl+c2Kdkj7I8dwgh7Lr+/qIT2zN/hkd7MfdOJBmVH6uLsi80D
nTS3BwSHSz3Bc7hNov4FTlKyAwJZMeLrMK3xhscHy5mtiD1sLPlnCoP+kpRbu50V
oG1kKTkhwT9sdEC8OzDMYUbwOlM1mvxR16ZJ6sU7Ki/i4iSETY8wrW3NcDbg5PHq
tC3TQCyfXkQLPmsZBX+IJVDYRytZ8SiNd0/jsEOnwfDONokQHp0gHUAW49ubs+jH
BN45B1ijwuL6oATGcTXayKXHwDEicw==
=il/w
-----END PGP SIGNATURE-----

--2vyyi26fe2shrq3h--
