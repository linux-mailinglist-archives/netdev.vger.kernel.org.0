Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF2DE43D200
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 21:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243754AbhJ0UBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 16:01:53 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:48984 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231203AbhJ0UBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 16:01:53 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 215221FD47;
        Wed, 27 Oct 2021 19:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1635364766; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FrnnAOFcXq8GB+5b0zF+pyaZVod9Tk0BXaojWrXlqak=;
        b=sphwHn6VwdbMB2OHqeJGzy8uSW8YIjm8ebI02x5UoBMPXCP02FzP143MQNcgBZBIEbkqlB
        LSGpWVpsUmoArqFRSo3JMtkU84qW0w5sw0dt5NustGE+N6KCpMQSdotyKOVyRs0i9rgc6O
        ug6qsP8DfaTui5k7bt0q7cogywayfk4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1635364766;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FrnnAOFcXq8GB+5b0zF+pyaZVod9Tk0BXaojWrXlqak=;
        b=lr1nGGI9fpNV6KcI6BUH78FzMqaSdapw1FlQ4e76ceIQm6NczSBol3HNx7OumJ6cA/YNAA
        p1O63nnMpf4rSLCw==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 19887A3B87;
        Wed, 27 Oct 2021 19:59:26 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 7E9C4607F2; Wed, 27 Oct 2021 21:59:23 +0200 (CEST)
Date:   Wed, 27 Oct 2021 21:59:23 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     bage@linutronix.de
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool 2/2] netlink: settings: Drop port filter for MDI-X
Message-ID: <20211027195923.3vhfr4diwuelw3gg@lion.mk-sys.cz>
References: <20211027181140.46971-1-bage@linutronix.de>
 <20211027181140.46971-3-bage@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="e4zkmqcx6khakr4p"
Content-Disposition: inline
In-Reply-To: <20211027181140.46971-3-bage@linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--e4zkmqcx6khakr4p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 27, 2021 at 08:11:40PM +0200, bage@linutronix.de wrote:
> From: Bastian Germann <bage@linutronix.de>
>=20
> The port =3D=3D PORT_TP condition on printing linkinfo's MDI-X field prev=
ents
> ethtool from printing that info even if it is present and valid, e.g. with
> the port being MII and still having that info.
>=20
> Signed-off-by: Bastian Germann <bage@linutronix.de>
> ---
>  netlink/settings.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/netlink/settings.c b/netlink/settings.c
> index c4f5d61..4da251b 100644
> --- a/netlink/settings.c
> +++ b/netlink/settings.c
> @@ -560,8 +560,7 @@ int linkinfo_reply_cb(const struct nlmsghdr *nlhdr, v=
oid *data)
>  		print_enum(names_transceiver, ARRAY_SIZE(names_transceiver),
>  			   val, "Transceiver");
>  	}
> -	if (tb[ETHTOOL_A_LINKINFO_TP_MDIX] && tb[ETHTOOL_A_LINKINFO_TP_MDIX_CTR=
L] &&
> -	    port =3D=3D PORT_TP) {
> +	if (tb[ETHTOOL_A_LINKINFO_TP_MDIX] && tb[ETHTOOL_A_LINKINFO_TP_MDIX_CTR=
L]) {
>  		uint8_t mdix =3D mnl_attr_get_u8(tb[ETHTOOL_A_LINKINFO_TP_MDIX]);
>  		uint8_t mdix_ctrl =3D
>  			mnl_attr_get_u8(tb[ETHTOOL_A_LINKINFO_TP_MDIX_CTRL]);

It's a bit more complicated, I'm afraid. With current kernel code, both
ETHTOOL_A_LINKINFO_TP_MDIX and ETHTOOL_A_LINKINFO_TP_MDIX_CTRL will be
always present in kernel reply so that we would always show something.
Also, the same condition is also used in ioctl code path and we should
try to keep the output consistent between ioctl and netlink.

How about replacing "port =3D=3D PORT_TP" with

  (port =3D=3D TP || mdix !=3D ETH_TP_MDI_INVALID || mdix_ctrl !=3D ETH_TP_=
MDI_INVALID)

in both code path and probably moving the check into dump_mdix()?

We could (and perhaps should) also modify kernel code to omit
ETHTOOL_A_LINKINFO_TP_MDIX or ETHTOOL_A_LINKINFO_TP_MDIX_CTRL if the
value is ETH_TP_MDI_INVALID but ethtool would still have to check for
both options (absence and ETH_TP_MDI_INVALID value) to preserve
compatibility with older kernels.

Michal

--e4zkmqcx6khakr4p
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmF5r5YACgkQ538sG/LR
dpUqpwf/ecZtDNw4DlO0beMOmC7FrZUO2++tcB0CYTIHd4e3dbxOxcsIMc9waX45
fkvxDLvJIRYoSJbdv2H7+VmsTeCJZy92WBnpfSn4lwj58eYBkmkmztBipxuxVJco
OaEuB40CKAmkTe2aI1C9bHK3vCFWpDaSXf0/cXqcIeijacepBLkGlHldWCFT2VJu
Zx3b8g6FoK15HceBJwJZjCzcqEkzYoRg2rJkR8MGvDGMfna5SY+0SbGqFnNM/ZOp
gIH/fUV1eYYlEthQj8E0tnFKmR29pAtc7XSmIYDrRn/AJHh72t86FTxXnz1o7Hrh
oBwbfXXePFCNRkfufuAPX5DSPjNWpg==
=dbuY
-----END PGP SIGNATURE-----

--e4zkmqcx6khakr4p--
