Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB07645833
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 11:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbiLGKwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 05:52:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiLGKwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 05:52:24 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21DBC48772
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 02:52:21 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id A206221C60;
        Wed,  7 Dec 2022 10:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1670410340; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/wqjcmCFRwYM+Mbv7G8RWuxpRsx3Fwdh1MIunR/kZLQ=;
        b=vQOTWb8pagtZSu+tkfgQ4BZ7WETjpLRXB1T/rhtZxvq5Al5aW/C/Tf/9MwiEk8Ptoc2hHj
        vDyEPEt0WK/j8NZEqpFs9oAas3zx10mwe7QNoixarVNlvg3KkJlG4KTl1Lt/K0mn4i+IGf
        Jw9VBO24OgWM0DPXBKnEx/lC2OoQ3ck=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1670410340;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/wqjcmCFRwYM+Mbv7G8RWuxpRsx3Fwdh1MIunR/kZLQ=;
        b=vHRhRYCALzagZ8CluI5SzTBU1JKmClga4VSva8zhqVBkwPGN7cE/6oLJtBS7FxVYgiocyx
        PJOLBOYVvrj8Q8Ag==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 960782C141;
        Wed,  7 Dec 2022 10:52:20 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 5E8E06030C; Wed,  7 Dec 2022 11:52:17 +0100 (CET)
Date:   Wed, 7 Dec 2022 11:52:17 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     e1000-patches@eclists.intel.com, netdev@vger.kernel.org
Subject: Re: [PATCH ethtool v1 07/13] ethtool: avoid null pointer dereference
Message-ID: <20221207105217.mw7qkm3l3go2dqri@lion.mk-sys.cz>
References: <20221207010353.821646-1-jesse.brandeburg@intel.com>
 <20221207010353.821646-8-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vjfliyewt6pknfq5"
Content-Disposition: inline
In-Reply-To: <20221207010353.821646-8-jesse.brandeburg@intel.com>
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--vjfliyewt6pknfq5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 06, 2022 at 05:03:47PM -0800, Jesse Brandeburg wrote:
> '$ scan-build make' reports:
>=20
> Description: Array access (from variable 'arg') results in a null
> pointer dereference
> File: /git/ethtool/netlink/parser.c
> Line: 782
>=20
> Description: Dereference of null pointer (loaded from variable 'p')
> File: /git/ethtool/netlink/parser.c
> Line: 794
>=20
> Both of these bugs are prevented by checking the input from netlink
> which was allowing nlctxt->argp to be NULL.

It is not input from netlink, nlctx->argp is always one of the members
in argv[] array and as argc is calculated by kernel (execve() only gets
argv, not argc), a null pointer could only be a result of a kernel bug.

If we wanted to check for null argv[] members, it would rather make
sense to do it somewhere on the global level than in each of the
handlers separately. But I'm not convinced it would help much, while we
could catch a null pointer, I'm not sure we could catch an invalid one.

> CC: Michal Kubecek <mkubecek@suse.cz>
> Fixes: 81a30f416ec7 ("netlink: add bitset command line parser handlers")
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>

This patch is marked as "07/13" but I did not receive the rest of the
series. And even this one was not sent to netdev mailing list.

Michal

> ---
>  netlink/parser.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/netlink/parser.c b/netlink/parser.c
> index 70f451008eb4..c573a9598a9f 100644
> --- a/netlink/parser.c
> +++ b/netlink/parser.c
> @@ -874,7 +874,7 @@ int nl_parse_bitset(struct nl_context *nlctx, uint16_=
t type, const void *data,
>   * optionally followed by '/' and another numeric value (mask, unless no=
_mask
>   * is set), or a string consisting of characters corresponding to bit in=
dices.
>   * The @data parameter points to struct char_bitset_parser_data. Generat=
es
> - * biset nested attribute. Fails if type is zero or if @dest is not null.
> + * bitset nested attribute. Fails if type is zero or if @dest is not nul=
l.
>   */
>  int nl_parse_char_bitset(struct nl_context *nlctx, uint16_t type,
>  			 const void *data, struct nl_msg_buff *msgbuff,
> @@ -882,7 +882,7 @@ int nl_parse_char_bitset(struct nl_context *nlctx, ui=
nt16_t type,
>  {
>  	const struct char_bitset_parser_data *parser_data =3D data;
> =20
> -	if (!type || dest) {
> +	if (!type || dest || !*nlctx->argp) {
>  		fprintf(stderr, "ethtool (%s): internal error parsing '%s'\n",
>  			nlctx->cmd, nlctx->param);
>  		return -EFAULT;
> --=20
> 2.31.1
>=20

--vjfliyewt6pknfq5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmOQcFkACgkQ538sG/LR
dpUFaQf+Lnr90umWrEfGwKtwaOrSE3YyPOOZ/ISrAwMI8SKUph8gz0EZwKkzaRzP
51zwynQ9roKteL447SNhh74YMaN68zBvDL27Vpu0hIfqR9M7Ev6lTXU0XbJcvIQQ
FL3bTweYruTqRhxF47j3UlHBoTO87SdimC+aSu5hBmhOTjtPy8ZMPAGe21igSQCf
LzknK7s2s1dD/l5MHUpIvJI0EgAg7z2jXlWzOrxGtqEpM7BhS+A076AswHOtC2EM
sPxYQJEzJhgsv+BafXDKkXBJcKAZwUf4etv0fqWmV3xWMLVENHiSouMgSpsoAt9n
27OxRYmNNMfbmAyxo1yc9rfTFhJTwA==
=wAYJ
-----END PGP SIGNATURE-----

--vjfliyewt6pknfq5--
