Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08CBE4B8DA4
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 17:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236223AbiBPQQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 11:16:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236148AbiBPQQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 11:16:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 613C62AE061;
        Wed, 16 Feb 2022 08:16:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13834B81F72;
        Wed, 16 Feb 2022 16:16:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87362C004E1;
        Wed, 16 Feb 2022 16:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645028160;
        bh=qPGOjCsk5qP8/ldMi4Gopws8pyTxuZAyGGhgDyKcdTA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mOJR/di1IvuM5MFS5yHENjDpbf9iMYOj5t/e9JW9HqjG+HBzQy0WrpdZYZ94FOsbB
         0Jm1S8YlVUYV4fliWBisJ2/JCbqcnIsi8xnn8ytlY+rZ3RNrthnVjsQhoFtiWQFkSZ
         c4LclVZWwpF+Adng/coN+I1rU68CUdKHT9xwmEOFr4D8J271AFc3+7inf9SGPAFwdX
         M6R1iyKLXOOMX0/ur75u9Q3q3VmiA8YxVk9aXVXIiczTdtWebqncsuBcAnxeE2jODM
         JYYnhVGGL3MgPkgbJ4cqwy6XHPezvS7ry0nGGtABWALFBFbOuApLqpWErmiWm2ztMl
         BrYGYbJbjLShg==
Date:   Wed, 16 Feb 2022 17:15:46 +0100
From:   Wolfram Sang <wsa@kernel.org>
To:     Matt Johnston <matt@codeconstruct.com.au>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org,
        Zev Weiss <zev@bewilderbeest.net>
Subject: Re: [PATCH net-next v5 2/2] mctp i2c: MCTP I2C binding driver
Message-ID: <Yg0jMkt56EhrBybc@ninjato>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Matt Johnston <matt@codeconstruct.com.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeremy Kerr <jk@codeconstruct.com.au>, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org, Zev Weiss <zev@bewilderbeest.net>
References: <20220210063651.798007-1-matt@codeconstruct.com.au>
 <20220210063651.798007-3-matt@codeconstruct.com.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="aqq7uLdNiV09xLK0"
Content-Disposition: inline
In-Reply-To: <20220210063651.798007-3-matt@codeconstruct.com.au>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--aqq7uLdNiV09xLK0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Matt, all,

On Thu, Feb 10, 2022 at 02:36:51PM +0800, Matt Johnston wrote:
> Provides MCTP network transport over an I2C bus, as specified in
> DMTF DSP0237. All messages between nodes are sent as SMBus Block Writes.
>=20
> Each I2C bus to be used for MCTP is flagged in devicetree by a
> 'mctp-controller' property on the bus node. Each flagged bus gets a
> mctpi2cX net device created based on the bus number. A
> 'mctp-i2c-controller' I2C client needs to be added under the adapter. In
> an I2C mux situation the mctp-i2c-controller node must be attached only
> to the root I2C bus. The I2C client will handle incoming I2C slave block
> write data for subordinate busses as well as its own bus.
>=20
> In configurations without devicetree a driver instance can be attached
> to a bus using the I2C slave new_device mechanism.
>=20
> The MCTP core will hold/release the MCTP I2C device while responses
> are pending (a 6 second timeout or once a socket is closed, response
> received etc). While held the MCTP I2C driver will lock the I2C bus so
> that the correct I2C mux remains selected while responses are received.
>=20
> (Ideally we would just lock the mux to keep the current bus selected for
> the response rather than a full I2C bus lock, but that isn't exposed in
> the I2C mux API)
>=20
> Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
> Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>

So, I did a high level review regardings the I2C stuff. I did not check
locking, device lifetime, etc. My biggest general remark is the mixture
of multi-comment styles, like C++ style or no empty "/*" at the
beginning as per Kernel coding style. Some functions have nice
explanations in the header but not proper kdoc formatting. And also on
the nitbit side, I don't think '__func__' helps here on the error
messages. But that's me, I'll leave it to the netdev maintainers.

Now for the I2C part. It looks good. I have only one remark:

> +static const struct i2c_device_id mctp_i2c_id[] =3D {
> +	{ "mctp-i2c", 0 },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(i2c, mctp_i2c_id);

=2E..

> +static struct i2c_driver mctp_i2c_driver =3D {
> +	.driver =3D {
> +		.name =3D "mctp-i2c",
> +		.of_match_table =3D mctp_i2c_of_match,
> +	},
> +	.probe_new =3D mctp_i2c_probe,
> +	.remove =3D mctp_i2c_remove,
> +	.id_table =3D mctp_i2c_id,
> +};

I'd suggest to add 'slave' to the 'mctp-i2c' string somewhere to make it
easily visible that this driver does not manage a remote device but
processes requests to its own address.

Thanks for the work!

   Wolfram


--aqq7uLdNiV09xLK0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmINIzEACgkQFA3kzBSg
KbY2hg//Y4x99TwK6piUWmXG9SqGoMRZVgAgtOr2p5Itm23ASqIhQZRlV8CLwFZ+
YCJUG7WYRqi7hgU4iaW4wSW2sHnovCcvPACJtqg5H17teJ6bwzVkHglvOKOvnn70
fMQsGxR8boR1BZS/YZbIZ1VJULx/tJzCFubhC7TfTvIpS2SriP5vh6X/uc4nG43c
T5OLRKlgzwgvQYuCVi0J4aXpUuZmlKf8MYf8rAkukAkPxnry86m4f7tdlxlNXhC+
PSVGihmgoNAxga7esmnT+ymHEV9qyUj1F2ByVtph20/XsxzBrPtrUbL98ACI35fC
GYpbRIdlFT3gnJsCxxOyYI8+Z8Xg5MUWUfCD6Xql2nz23bAiCrkVgGxjA1Sh59BO
GMqmz5GBzFN/t7e8RUvCKh1zvRm4W9MQZ/zqqJRMHVjKpxUHacSABaDWH+3Vbpav
K1AyGCVWQglG2wRruWQpBgHMmk36samEcXNLzSmIXvHq1e+b4OKPGyeqCWDLNtk5
8uDOOMgZrBlc1XJOJxFgan+ZQnU4DMMPfVJfUzDbdcGn6W8MRHBYIvSO8u6VDUq7
wzdMFX2lAoOqKexkoiwqZ8FLR+Lu8xrpfpcu4H1+F6r/G65Fchr/+gROsuZ9ELcN
8UzrnG2KTeWnxJm8tWrmJ6LNzsXHfKgNboYefXJSqMpIdTzb6Co=
=YZkx
-----END PGP SIGNATURE-----

--aqq7uLdNiV09xLK0--
