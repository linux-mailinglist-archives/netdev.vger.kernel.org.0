Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 831AC66A761
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 01:09:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbjANAJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 19:09:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbjANAJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 19:09:23 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F148D5F2
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 16:09:21 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 55B9E34AB8;
        Sat, 14 Jan 2023 00:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1673654960; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PEZiHvi1g7h0Tro9i8mi/dHTTw2Sc5zFielHZoKTaFY=;
        b=sEdZovnRpuQE2RW6q/ii3oKmACbsY0/+8shkH590hiPVKL0V3ev0C+d4PZxKsjPD9rOxVq
        1RsnohX7Kw26ZX52AsrgKSvBuGoVztlEGMpvlAjUFTBiBgLSe90Sc0EqEy6+HV1EePP1IH
        FJ7bYmgTALBVyho38TxBlDqV0Tq1CpA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1673654960;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PEZiHvi1g7h0Tro9i8mi/dHTTw2Sc5zFielHZoKTaFY=;
        b=m8FlpiQD3WBBwJHvSQbcOdwnR2wbs3Mw6rFiljTu083aveycVUdeCwCYN89QrpLd+vzpYB
        9CRuFv9uDUE0Z4AA==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 4A1E02C141;
        Sat, 14 Jan 2023 00:09:20 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 1FD2B60330; Sat, 14 Jan 2023 01:09:20 +0100 (CET)
Date:   Sat, 14 Jan 2023 01:09:20 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Markus Mayer <mmayer@broadcom.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH ethtool 2/3] netlink: Fix maybe uninitialized 'meters'
 variable
Message-ID: <20230114000920.izp4tzfcn4cbciec@lion.mk-sys.cz>
References: <20230113233148.235543-1-f.fainelli@gmail.com>
 <20230113233148.235543-3-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="osmy37lkpwcoj5ac"
Content-Disposition: inline
In-Reply-To: <20230113233148.235543-3-f.fainelli@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--osmy37lkpwcoj5ac
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 13, 2023 at 03:31:47PM -0800, Florian Fainelli wrote:
> GCC12 warns that 'meters' may be uninitialized, initialize it
> accordingly.
>=20
> Fixes: 9561db9b76f4 ("Add cable test TDR support")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  netlink/parser.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/netlink/parser.c b/netlink/parser.c
> index f982f229a040..6f863610a490 100644
> --- a/netlink/parser.c
> +++ b/netlink/parser.c
> @@ -237,7 +237,7 @@ int nl_parse_direct_m2cm(struct nl_context *nlctx, ui=
nt16_t type,
>  			 struct nl_msg_buff *msgbuff, void *dest)
>  {
>  	const char *arg =3D *nlctx->argp;
> -	float meters;
> +	float meters =3D 0.0;
>  	uint32_t cm;
>  	int ret;
> =20

No problem here either but it's quite surprising as I check build with
gcc versions 7 and 11-13 (10-12 until recently) for each new commit and
I never saw this warning. As the warning is actually incorrect (either
parse_float() returns an error and we bail out or it assigns a value to
meters), it may be a gcc issue that was fixed in a later version. But
initializing the variable does no harm so let's do it.

Michal

--osmy37lkpwcoj5ac
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmPB8qwACgkQ538sG/LR
dpVq1wf7BG3DU3GWhSMJF2SlsgjKO1rFjnmB0ljEqs/X+9xjrdzQGLu+i3cZg/R3
UmOfCZeH7fDR5a1tKBV7jbE8dLVKG391xLX/Nmt9Q1LRXvqGNOg37+pzQUkVMQER
x89RrQSONmsYk1DmIDTrU1R7NIs7SjyARG4mdMX8esRJRN5ga5nzcop96l8PgHBL
bfuGFXBOkopTyGVgB99xWZoxMSglXn57hvF0w5rK3W9JnTpCJayPZ7lCXVhp8paR
iy4uSzhM4llwA7wvEgpVVmynXWMuHIP1ZXtxQyVYAdOfvXLIQ29/uLReF1TeBigC
dw1OVn4oVb3G02hAf8erC9R8/+zqRQ==
=jY2I
-----END PGP SIGNATURE-----

--osmy37lkpwcoj5ac--
