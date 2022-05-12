Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDC2C52477D
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 09:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351266AbiELH6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 03:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241283AbiELH6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 03:58:17 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A80436899C
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 00:58:16 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1np3i7-0001Rg-3t; Thu, 12 May 2022 09:58:11 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id D10C37C670;
        Thu, 12 May 2022 07:58:08 +0000 (UTC)
Date:   Thu, 12 May 2022 09:58:08 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Devid Antonio Filoni <devid.filoni@egluetechnologies.com>,
        kernel@pengutronix.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Jander <david@protonic.nl>
Subject: Re: [PATCH 1/1] can: skb: add and set local_origin flag
Message-ID: <20220512075808.urlptf4d3wiu4kwh@pengutronix.de>
References: <20220511121913.2696181-1-o.rempel@pengutronix.de>
 <b631b022-72d5-9160-fd13-f33c80dbbe59@hartkopp.net>
 <20220511132421.7o5a3po32l3w2wcr@pengutronix.de>
 <20220511143620.kphwgp2vhjyoecs5@pengutronix.de>
 <002d234f-a7d6-7b1a-72f4-157d7a283446@hartkopp.net>
 <20220511145437.oezwkcprqiv5lfda@pengutronix.de>
 <3c6bf83c-0d91-ea43-1a5d-27df7db1fb08@hartkopp.net>
 <f6cb7e44-226b-cffb-d907-9014075cdcb5@hartkopp.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7ajn64kwg73u2oir"
Content-Disposition: inline
In-Reply-To: <f6cb7e44-226b-cffb-d907-9014075cdcb5@hartkopp.net>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--7ajn64kwg73u2oir
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 12.05.2022 08:23:26, Oliver Hartkopp wrote:
> > > > > BTW: There is a bug with interfaces that don't support IFF_ECHO.
> > > > >=20
> > > > > Assume an invalid CAN frame is passed to can_send() on an
> > > > > interface that doesn't support IFF_ECHO. The above mentioned
> > > > > code does happily generate an echo frame and it's send, even
> > > > > if the driver drops it, due to can_dropped_invalid_skb(dev,
> > > > > skb).
> > > > >=20
> > > > > The echoed back CAN frame is treated in raw_rcv() as if the
> > > > > headroom is valid:

> I double checked that code and when I didn't miss anything all the callers
> of can_send() (e.g. raw_sendmsg()) are creating valid skbs.

ACK - I haven't checked, but I assume that all current callers of
can_send() are sound, this I why I started the description with: "Assume
an invalid CAN frame is passed to can_send()". But we can argue that we
trust all callers.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--7ajn64kwg73u2oir
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmJ8vg0ACgkQrX5LkNig
0123iAf9ErX08AbRVn9w0Yc3/EK4BXK/wG8D+Qc4T3MK+m6wTUWjEozDpbcdT9Xf
7KwXqMctUdH/G3YvAHSD0dM0qFv6PL9BSO+Cj7TX2itOe6ME1r2/Ym8fodHtZIv9
FSfySMHM8/+kN1v2xyfL8VlOsBuaXaQzTHv/Oj+O3cdKZnFS2qG2SFlXhPvmTdLE
j29aIQakN+nCJCcmXoimM5Bn9DftyXbbNLa14hN93bfNIktuveaKKgSjH36hZ96S
JjCDRfpG16DnxyYAuk+grsThKZGFeylRtV8TC4E53aumG/zoDNZpmkV+/FtPa/VS
QoLahTJiU4vJphpbic4F7MHlTwaSFQ==
=epSY
-----END PGP SIGNATURE-----

--7ajn64kwg73u2oir--
