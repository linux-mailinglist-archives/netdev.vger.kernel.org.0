Return-Path: <netdev+bounces-2779-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 21A43703EE1
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 22:52:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C2C2281427
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 20:52:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7A2018C1B;
	Mon, 15 May 2023 20:52:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB64F1FBE
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 20:52:17 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5981593F4
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 13:52:16 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mkl@pengutronix.de>)
	id 1pyfAm-0005zl-2x; Mon, 15 May 2023 22:52:00 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	(Authenticated sender: mkl-all@blackshift.org)
	by smtp.blackshift.org (Postfix) with ESMTPSA id C20C11C5CA7;
	Mon, 15 May 2023 20:51:58 +0000 (UTC)
Date: Mon, 15 May 2023 22:51:58 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Pavel Pisa <pisa@cmp.felk.cvut.cz>, Ondrej Ille <ondrej.ille@gmail.com>,
	Wolfgang Grandegger <wg@grandegger.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Martin Jerabek <martin.jerabek01@gmail.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] can: ctucanfd: Fix an error handling path in
 ctucan_probe_common()
Message-ID: <20230515-finisher-plating-8ab57747fea5-mkl@pengutronix.de>
References: <4b78c848826fde1b8a3ccd53f32b80674812cb12.1684182962.git.christophe.jaillet@wanadoo.fr>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="e2jyg7v42mrpg4qu"
Content-Disposition: inline
In-Reply-To: <4b78c848826fde1b8a3ccd53f32b80674812cb12.1684182962.git.christophe.jaillet@wanadoo.fr>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--e2jyg7v42mrpg4qu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 15.05.2023 22:36:28, Christophe JAILLET wrote:
> If register_candev() fails, a previous netif_napi_add() needs to be undon=
e.
> Add the missing netif_napi_del() in the error handling path.

What about this path:
free_candev(ndev) -> free_netdev() -> netif_napi_del()

| https://elixir.bootlin.com/linux/v6.3.2/source/net/core/dev.c#L10714

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--e2jyg7v42mrpg4qu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmRim2sACgkQvlAcSiqK
BOjuAwf6A4GauV2RYDb0DKtBocZA6JCTFpxr+DJK7LK19G344FjrZMVvb9Tch5iO
Z280B9XDtr4dERafr3H5Eu7GxJVOvuI15TM09c1W4Rx5lpo4a7pUYnKrsmu8JAdX
2Jl8DCIF61Pzv+5HnFuefw8e+twXjmD3Htie4zFUVUeZ52Bm60+H5reYeMPxUOcV
P27GtPBrEx7N5tJjedlb+E2EqpqLRl3RCNgdpizUBGCoUZqlr7Hv2YXTcyet0SV/
wovJpqmyFDKT3k6r8rXFJuZMp4xBQZibGQJX3f6hYqF7C1QsXcriRUL5h6cRsFCh
jnY6LSzFQSrj7ca6rvFv67dmymX+Dw==
=WizN
-----END PGP SIGNATURE-----

--e2jyg7v42mrpg4qu--

