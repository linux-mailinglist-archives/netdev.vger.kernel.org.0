Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49FEB337254
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 13:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232759AbhCKMU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 07:20:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233148AbhCKMU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 07:20:56 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 848F4C061760
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 04:20:56 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lKKJC-000182-TI; Thu, 11 Mar 2021 13:20:54 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:cd1a:e083:465e:4edf])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 064CE5F3608;
        Thu, 11 Mar 2021 12:20:53 +0000 (UTC)
Date:   Thu, 11 Mar 2021 13:20:53 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Daniel =?utf-8?B?R2zDtmNrbmVy?= <dg@emlix.com>
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org
Subject: Re: Softirq error with mcp251xfd driver
Message-ID: <20210311122053.4ymta6byqjeocmsv@pengutronix.de>
References: <20210310064626.GA11893@homes.emlix.com>
 <20210310071351.rimo5qvp5t3hwjli@pengutronix.de>
 <20210310212254.GA2050@homes.emlix.com>
 <20210310215621.GA5538@homes.emlix.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6aabzysww5xjeyax"
Content-Disposition: inline
In-Reply-To: <20210310215621.GA5538@homes.emlix.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6aabzysww5xjeyax
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 10.03.2021 22:56:21, Daniel Gl=C3=B6ckner wrote:
[...]
> Or we leave can_rx_offload unchanged and keep two additional lists of skbs
> inside the mcp251xfd driver: One for the packets that arrived before the
> timestamp read from TBC and one for the packets that arrived later. At the
> end of an iteration we call local_bh_disable, enqueue all packets from the
> first list with can_rx_offload_queue_sorted, and the ask the softirq to
> process them by calling local_bh_enable. Afterwards we move everything
> from the second list to the first list and do the next iteration.

In the patch series (which was started by Kurt Van Dijck) there is a
second queue in rx-offload, this one is filled inside the IRQ handler
and than added at the end of the IRQ handler to the queue that NAPI
works on. He started this to get rid of the spin_lock operation on every
skb added to the queue.

> The drawback is that we can't use can_rx_offload_get_echo_skb.

I'd like to keep it, as this optimizes other use cases, too.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--6aabzysww5xjeyax
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmBKCyIACgkQqclaivrt
76nUyQf/eri29ha+3N/5YdQ6kq6PPo7xTdHMUTU6MLA5SZL7dxBgB+yKU0j//1xw
Ryn7ovUTWa7K0AScFXtGQVXg7p4nJjGDEdcexUh7A27YOBTcli2/b3t7g3onBXmH
UOEtsEKNpqv/2EzOg9Dgo2wSPTMNzftSeBvagNIGCOU/k1U1jCSzgMyEL6mqrY72
aIimXO6kDSgX5GLFWusR5a7vYSotNIKhDHmjkaoiYT2Hlo8EXtsLDJ2/EEgtZ8nF
Ahai9hRjrrNitRiOiecqjMcOT0QlYbcgGvwtH/QtnAre6AP7lMEYDAf0D5L+DpVI
dxs+/rxFsxcYWvE8tMVuqfPT5Lwpmw==
=a5V8
-----END PGP SIGNATURE-----

--6aabzysww5xjeyax--
