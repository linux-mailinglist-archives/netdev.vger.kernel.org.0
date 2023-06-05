Return-Path: <netdev+bounces-7971-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C54E5722467
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 13:17:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3DA8D1C209B7
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 11:17:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF100168DA;
	Mon,  5 Jun 2023 11:17:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B67111B5
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 11:17:27 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6429DF2
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 04:17:04 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mkl@pengutronix.de>)
	id 1q68CX-0003EX-Lc; Mon, 05 Jun 2023 13:16:41 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	(Authenticated sender: mkl-all@blackshift.org)
	by smtp.blackshift.org (Postfix) with ESMTPSA id 05EFD1D248B;
	Mon,  5 Jun 2023 11:16:37 +0000 (UTC)
Date: Mon, 5 Jun 2023 13:16:37 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, netdev@vger.kernel.org,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	sasha.neftin@intel.com, richardcochran@gmail.com,
	Kurt Kanzenbach <kurt@linutronix.de>,
	Naama Meir <naamax.meir@linux.intel.com>
Subject: Re: [PATCH net 3/4] igc: Retrieve TX timestamp during interrupt
 handling
Message-ID: <20230605-distort-jab-ce1f3ece058a-mkl@pengutronix.de>
References: <20230530174928.2516291-1-anthony.l.nguyen@intel.com>
 <20230530174928.2516291-4-anthony.l.nguyen@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="hdpqt2u6gtk3ko7j"
Content-Disposition: inline
In-Reply-To: <20230530174928.2516291-4-anthony.l.nguyen@intel.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--hdpqt2u6gtk3ko7j
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 30.05.2023 10:49:27, Tony Nguyen wrote:
> From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
>=20
> When the interrupt is handled, the TXTT_0 bit in the TSYNCTXCTL
> register should already be set and the timestamp value already loaded
> in the appropriate register.
>=20
> This simplifies the handling, and reduces the latency for retrieving
> the TX timestamp, which increase the amount of TX timestamps that can
> be handled in a given time period.

What about renaming the igc_ptp_tx_work() function, as it's not
scheduled work anymore, also IMHO you should update the function's
comment.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--hdpqt2u6gtk3ko7j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmR9xBIACgkQvlAcSiqK
BOiY0wgArz/JseGdOyK9EYdiHWYkC6yBgRBS2PjAZvGMu9jqJTKiY0TPWNy/L2Pe
B5wzNsPneJ5WD86gOrAjkeDqM5fwSFpcnorf20WQH9VaicTYdFQxYUJ/mcqZ2U96
vy9GF2Ufa9P47cek/toU8dIJ7JYVk3jAV+wQWAlfDhmzHh4KMENxb9jdd7wus6vs
+2TlaMs/uIphilophN2O8iD5vgDcRDJUSjvCjmMjzihf0zLUKuEnWMfAFTBHEtBZ
y1J0gX9+cInu5WqmzENWaqlAThR18uFehiQQgymzpbZ/Dgv33DeFErXXcuPNC2t4
oadUf1An+t8CdBt1Zf7xFnvLIG9F+A==
=kuvR
-----END PGP SIGNATURE-----

--hdpqt2u6gtk3ko7j--

