Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC2A43D29F
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 22:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235867AbhJ0UPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 16:15:45 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:49292 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234969AbhJ0UPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 16:15:43 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id B48431FD3D;
        Wed, 27 Oct 2021 20:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1635365596; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i5tSPb1L5H9R1crBuZvYhKBXnBdOpQDc1gKoF4V5z8s=;
        b=LQn11XSnMhYMo4vQIw3w+DYM92M+dr6hr9zCnoQbE4RtvVzxxhSvGwAWwruHckcWGP+5f8
        JSht5rR08+yjk9kQ6sQ8pLZKdPJ5u3P2m8j32HNfF1Y2SgIFVJoP7ypm6FyTTDYR76sv5S
        3EoInCT7NC/ZRMeVwXbdapfrmFhoCQY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1635365596;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i5tSPb1L5H9R1crBuZvYhKBXnBdOpQDc1gKoF4V5z8s=;
        b=TyrIp8GhgQF9ekZ4w/mUVWelU/fPozKCQowp+XMgKWW13MF44pkCkyzITwttc8LFWbefd5
        LSZZWVueqv+5mdCA==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id AC781A3B85;
        Wed, 27 Oct 2021 20:13:16 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 8E198607F2; Wed, 27 Oct 2021 22:13:16 +0200 (CEST)
Date:   Wed, 27 Oct 2021 22:13:16 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     bage@linutronix.de
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool 1/2] netlink: settings: Correct duplicate
 condition
Message-ID: <20211027201316.q76qnhh2xmsdd3ad@lion.mk-sys.cz>
References: <20211027181140.46971-1-bage@linutronix.de>
 <20211027181140.46971-2-bage@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="x3jktce7azounzci"
Content-Disposition: inline
In-Reply-To: <20211027181140.46971-2-bage@linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--x3jktce7azounzci
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 27, 2021 at 08:11:39PM +0200, bage@linutronix.de wrote:
> From: Bastian Germann <bage@linutronix.de>
>=20
> tb's fields ETHTOOL_A_LINKINFO_TP_MDIX and ETHTOOL_A_LINKINFO_TP_MDIX_CTRL
> are used in this case. The condition is duplicate for the former. Fix tha=
t.
>=20
> Signed-off-by: Bastian Germann <bage@linutronix.de>
> ---
>  netlink/settings.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/netlink/settings.c b/netlink/settings.c
> index 6d10a07..c4f5d61 100644
> --- a/netlink/settings.c
> +++ b/netlink/settings.c
> @@ -560,7 +560,7 @@ int linkinfo_reply_cb(const struct nlmsghdr *nlhdr, v=
oid *data)
>  		print_enum(names_transceiver, ARRAY_SIZE(names_transceiver),
>  			   val, "Transceiver");
>  	}
> -	if (tb[ETHTOOL_A_LINKINFO_TP_MDIX] && tb[ETHTOOL_A_LINKINFO_TP_MDIX] &&
> +	if (tb[ETHTOOL_A_LINKINFO_TP_MDIX] && tb[ETHTOOL_A_LINKINFO_TP_MDIX_CTR=
L] &&
>  	    port =3D=3D PORT_TP) {
>  		uint8_t mdix =3D mnl_attr_get_u8(tb[ETHTOOL_A_LINKINFO_TP_MDIX]);
>  		uint8_t mdix_ctrl =3D

Fixes: 10cc3ea337d1 ("netlink: partial netlink handler for gset (no option)=
")
Acked-by: Michal Kubecek <mkubecek@suse.cz>

--x3jktce7azounzci
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmF5stcACgkQ538sG/LR
dpUrvwf/YM6w7UVslqtuiL4CpsrbAfPmu9j1ryU3PlY2eTN5Vayuo5Oi7MRZQ5tF
vu9sQYQbEIx4vPjI/iy393kJY6AkhC3zgQpBs7D7cCrF4agH5OqLN56z3Y71Guw9
wFtAppCTOAMGuNkFPHAc7Txy5pOF9Cmnoj/tNC85P31ruIS2zodEe/1v3YxEsGbu
zBc2OkKvpR6kSyWcXLiIcElFOjoAlkTtP1dGjOCKsI8dGvqzL3Ro3VoQnzQCi+19
U5eOObHYeKojOlAqU7GfYjp0ax7UJr65rly7Hf195vd3JyNgcNQ933ssva2+CzNt
jGT286m77QV4iWS6fP6cSt9ka4DgGw==
=5MXk
-----END PGP SIGNATURE-----

--x3jktce7azounzci--
