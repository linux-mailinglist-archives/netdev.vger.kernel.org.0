Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 872592CD2B6
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 10:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388621AbgLCJj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 04:39:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388476AbgLCJj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 04:39:27 -0500
X-Greylist: delayed 2746 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 03 Dec 2020 01:38:46 PST
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3026C061A4E
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 01:38:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3TDucFgEwJuiwJKrj0DtZQH0tRb74voosApy5X21rmM=; b=MeYhrU8uMe9VcC23NygcXmmRu6
        wsfOsMjx+TduIj/SODNDGunQaaqKtRaumQ4As+r0CyvtUpZpBXOwFDThWrVPhthVRCGP2QZHX9fsu
        hy1/HtjXB9ckLXkGrWiy3rEW9wfCEFcyxYFOmM6Bo55zrKiC0kS7qP738e5rXknpsgOp3qxaBNFb5
        ohDjUpe45qil0krlX876OkKpwAh9E7RE1Wto2SRLqkckebhJuYuHkMPHv9aGdD00XKCYPF+ifzUwP
        FTWfpfrrr4ejp7mAPyBAiTG5rGC5MKjLX2DCDO1v9w7aWWnlrp7h5OwMvY78FdjcJAf4z2yExL9TY
        lNaCYjLw==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:7c7a:91ff:fe7e:d268] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1kkkMD-0004sP-Qn; Thu, 03 Dec 2020 08:52:57 +0000
Date:   Thu, 3 Dec 2020 08:52:56 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jonas Bonn <jonas@norrbonn.se>
Cc:     netdev@vger.kernel.org, pablo@netfilter.org, laforge@gnumonks.org
Subject: Re: [PATCH 2/5] gtp: include role in link info
Message-ID: <X8inaGuheZmfN1aG@azazel.net>
References: <20201202123345.565657-1-jonas@norrbonn.se>
 <20201202123345.565657-2-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="f+tvkKMljXxRSTax"
Content-Disposition: inline
In-Reply-To: <20201202123345.565657-2-jonas@norrbonn.se>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:7c7a:91ff:fe7e:d268
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--f+tvkKMljXxRSTax
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2020-12-02, at 13:33:42 +0100, Jonas Bonn wrote:
> Querying link info for the GTP interface doesn't reveal in which
> "role" the
> device is set to operate.  Include this information in the info query
> result.
>
> Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
> ---
>  drivers/net/gtp.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
> index 5a048f050a9c..096aaf1c867e 100644
> --- a/drivers/net/gtp.c
> +++ b/drivers/net/gtp.c
> @@ -728,7 +728,8 @@ static int gtp_validate(struct nlattr *tb[],
> struct nlattr *data[],
>
>  static size_t gtp_get_size(const struct net_device *dev)
>  {
> -	return nla_total_size(sizeof(__u32));	/* IFLA_GTP_PDP_HASHSIZE */
> +	return nla_total_size(sizeof(__u32)) +	/* IFLA_GTP_PDP_HASHSIZE */
> +		+ nla_total_size(sizeof(__u32)); /* IFLA_GTP_ROLE */

You have a '+' at the end of l.781 and another at the beginning of
l.782.

>  }
>
>  static int gtp_fill_info(struct sk_buff *skb, const struct net_device
> *dev)
> @@ -737,6 +738,8 @@ static int gtp_fill_info(struct sk_buff *skb,
> const struct net_device *dev)
>
>  	if (nla_put_u32(skb, IFLA_GTP_PDP_HASHSIZE, gtp->hash_size))
>  		goto nla_put_failure;
> +	if (nla_put_u32(skb, IFLA_GTP_ROLE, gtp->role))
> +		goto nla_put_failure;
>
>  	return 0;
>
> --
> 2.27.0
>
>

J.

--f+tvkKMljXxRSTax
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAl/Ip2EACgkQKYasCr3x
BA2w4A/+KELKG14iUN2OYIOGwvGC5AnjHgz1GjROa22PvJKZLcc3c08HSTPU7Vsb
ywDFB4XIbB314O9XyBFpph3vrx0PJPTciVRWfhk30AKNhYiTLfpkcpqMnWQPe2jB
hnf60OdC5YAZ3/1JoBKKKNq3Bh3k6islvUe/tOdUMOBOpKKCe6RiyraFSfoY0CL4
Mx64XaIZGYiFn1AjB1QEHFqenhEXZUQz48X1GtBBmTCAdQHFU5I84mX10rRGyNJP
QmLpJwUwO/6DxvwiS3r3er6SCGRhjoCCp/85Wt1yG/djcWL35SuAmohqwueCi28j
iZA3qzQStuVv0l5iwTiU1yJJj5+hCODv92g6UDDvevrBuZ4DVT429lLDZZbz+4Oa
CxFHKos5paq5s2x05bKSdekA8P6IMHvhzvaHAyhwVXnd2gGaV9ckjNgTb+mXl+Pa
QYCROvdX7Ugtt1rfAvn8r6PuHJ7GrK3juBKX7ATnjC001HnSY97vqgJ/OJj7btG2
eadXDAZXftOH4L6YF12/HARdBrczKOPP6XIWouiguYKNbxAFBufu/sYCm+HAcy9b
uXDc2g3ZAKG3mzoTTvC7fbaODYlQa2fk6PCboo03nLoCvMuaFN/Stdih7lluon5H
fWc9vdV6VFOMRvPKesTGsMCP/oPlMQAKmqr6FK7c6NbrOpVk2DM=
=Os4H
-----END PGP SIGNATURE-----

--f+tvkKMljXxRSTax--
