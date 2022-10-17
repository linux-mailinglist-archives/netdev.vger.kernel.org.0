Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B963600E98
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 14:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbiJQMLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 08:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbiJQMLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 08:11:50 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B8A5D0CA
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 05:11:47 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1okOxt-00034B-Ey; Mon, 17 Oct 2022 14:11:29 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id B0CB0100A4C;
        Mon, 17 Oct 2022 12:11:26 +0000 (UTC)
Date:   Mon, 17 Oct 2022 14:11:22 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Pavel Pisa <pisa@cmp.felk.cvut.cz>
Cc:     Matej Vasilevski <matej.vasilevski@seznam.cz>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v5 2/4] can: ctucanfd: add HW timestamps to RX and error
 CAN frames
Message-ID: <20221017121122.kt6adqz4dtqc2sy5@pengutronix.de>
References: <20221012062558.732930-1-matej.vasilevski@seznam.cz>
 <20221012062558.732930-3-matej.vasilevski@seznam.cz>
 <202210162354.48915.pisa@cmp.felk.cvut.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="rvnrtrzjwhjvuun7"
Content-Disposition: inline
In-Reply-To: <202210162354.48915.pisa@cmp.felk.cvut.cz>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--rvnrtrzjwhjvuun7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 16.10.2022 23:54:48, Pavel Pisa wrote:
[...]
> I hope/expect that it is not problem to call clk_prepare_enable twice
> on same reference when the clocks are the same. As I read the code the
> state is counted. If it is a problem then some if has to be put there
> when the core and timestamp clock are the same.

The clock prepare and enable are counting. If you call then twice, you
have to call disable and unprepare twice, too, to shut it down. This is
widely used in the kernel, e.g. if the same clock is passed to several
IP cores.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--rvnrtrzjwhjvuun7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmNNRmcACgkQrX5LkNig
013jTQf+O3lLkZSM4YhGiVas49XH0Hf3wyVccsA5bdMIO4RQMnWPnxWbY/wIzY1o
POdo3ycEo6hQCYZ1XMpNznzmnBaD17yXiLJHzWVrx16ZSAWfQOblluOgHujs3vkg
jnqPRD74I1F5LlqOI0RRWtX1jlGZkO9Bd0cyyYgwtSoNFWXp6I+xIxrclgArda24
HPWR2VSeqmiQAna8r9rdslI8j/HD6llI4Rspq8I3PpSL2ipyvtN9v2FbSfhLPOer
Kr0Pc7/LITS95Klj/cpCFLJDLX/F4o0MdamQar5kh92vDSx15Sc2gUxBD9jqgpyc
SPVzpWjMEbIaPv7++vzBN8Z/px/Yjg==
=GIBY
-----END PGP SIGNATURE-----

--rvnrtrzjwhjvuun7--
