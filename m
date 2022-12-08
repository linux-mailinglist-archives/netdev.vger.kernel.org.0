Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4792F646D81
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 11:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbiLHKso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 05:48:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbiLHKsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 05:48:08 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D6789313
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 02:43:20 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 2636933799;
        Thu,  8 Dec 2022 10:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1670496199; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QPFxnL1pxomXaBvapjhCCtdbJlaUAdnMNKxdbQBIUs8=;
        b=HST0j6CCq6GiKf+/HEcEpoTNoYFFFlIHq/099FK4fZWh49D/n6XaGqHagreUu/7rdSq+r9
        76CimJSt7Ta+CsohUXlMOeaj9H6aVmn9Y5EJsm39X6VLSGIz5H/ql3TtAKDfipgp1hBW1U
        fhlNgkUWpXpe97JTjO2zFAvNMEQzUrY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1670496199;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QPFxnL1pxomXaBvapjhCCtdbJlaUAdnMNKxdbQBIUs8=;
        b=fz32wfecvHhbTmkI3BbVGKVFG/fCJNaUtqeZjhEuLzCJr+g6BKx654C6giUy6CM1E4KDdV
        chwbQ7PVd8AauuCg==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id DF5592C27D;
        Thu,  8 Dec 2022 10:43:16 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id CDC416045E; Thu,  8 Dec 2022 11:43:18 +0100 (CET)
Date:   Thu, 8 Dec 2022 11:43:18 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool v2 05/13] ethtool: fix extra warnings
Message-ID: <20221208104318.hq3ze7vaskbcpuix@lion.mk-sys.cz>
References: <20221208011122.2343363-1-jesse.brandeburg@intel.com>
 <20221208011122.2343363-6-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mgpy4ahei62gwgas"
Content-Disposition: inline
In-Reply-To: <20221208011122.2343363-6-jesse.brandeburg@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--mgpy4ahei62gwgas
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 07, 2022 at 05:11:14PM -0800, Jesse Brandeburg wrote:
> '$ scan-build make' reports
>=20
> netlink/permaddr.c:44:2: warning: Value stored to 'ifinfo' is never read =
[deadcode.DeadStores]
>         ifinfo =3D mnl_nlmsg_put_extra_header(nlhdr, sizeof(*ifinfo));
>         ^        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>=20
> So just remove the extra assignment which is never used.
>=20
> Fixes: 7f3585b22a4b ("netlink: add handler for permaddr (-P)")
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> ---
>  netlink/permaddr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/netlink/permaddr.c b/netlink/permaddr.c
> index 006eac6c0094..dccb0c6cfdb7 100644
> --- a/netlink/permaddr.c
> +++ b/netlink/permaddr.c
> @@ -41,7 +41,7 @@ static int permaddr_prep_request(struct nl_socket *nlsk)
>  	nlhdr->nlmsg_type =3D RTM_GETLINK;
>  	nlhdr->nlmsg_flags =3D nlm_flags;
>  	msgbuff->nlhdr =3D nlhdr;
> -	ifinfo =3D mnl_nlmsg_put_extra_header(nlhdr, sizeof(*ifinfo));
> +	mnl_nlmsg_put_extra_header(nlhdr, sizeof(*ifinfo));

Good point. But looking at the code, the variable isn't in fact used
at all, except of the two occurences of sizeof(*ifinfo). So we can
just as well replace them with sizeof(struct ifinfomsg) and drop the
variable.

Michal

> =20
>  	if (devname) {
>  		uint16_t type =3D IFLA_IFNAME;
> --=20
> 2.31.1
>=20

--mgpy4ahei62gwgas
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmORv8IACgkQ538sG/LR
dpXXHQgAxsKmLKS+HY8neLZDJ/FO/gPRz5hdPGGw85aH/qgz50WP9OiX8PtH54Je
52NQOYvMGShMX7P6/noOpzU6IrsOOLhQArqTnxhNkOPe8ij73MltR4P45NFQ8IkZ
Q962QvKmbShQQv329eMtn+I2yUjEELu5IYS/7DMBFlYaP0zVcSrR0wM2f91qGk9f
vT2K4H47tEeZmZ+KCtK7RyJ5DPyFKE2YDslyKsTEE0KdqG2PT+bHHZ+YPlcgdbt0
XjYcoZw42wAQHszkffkNdnFFbNTrOuDKC04jU15s+xj4w+rDhIqjlpJFMk3bOXHF
Hmb32tzZ8WJFIS2kVg4t1JxD2fuTyg==
=wT5E
-----END PGP SIGNATURE-----

--mgpy4ahei62gwgas--
