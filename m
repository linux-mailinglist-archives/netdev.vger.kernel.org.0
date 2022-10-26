Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E26F60DBF2
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 09:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbiJZHQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 03:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231847AbiJZHQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 03:16:07 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB208BA905
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 00:16:06 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1onade-00048m-FD; Wed, 26 Oct 2022 09:15:46 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 7F7C0109F4C;
        Wed, 26 Oct 2022 07:15:43 +0000 (UTC)
Date:   Wed, 26 Oct 2022 09:15:41 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Matej Vasilevski <matej.vasilevski@seznam.cz>
Cc:     Pavel Pisa <pisa@cmp.felk.cvut.cz>,
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
Message-ID: <20221026071541.ydvvtreum242he6w@pengutronix.de>
References: <20221012062558.732930-1-matej.vasilevski@seznam.cz>
 <20221012062558.732930-3-matej.vasilevski@seznam.cz>
 <20221024200238.tgqkjjyagklglshu@pengutronix.de>
 <20221025222237.GA4635@hopium>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2l67orfrxkjniwtd"
Content-Disposition: inline
In-Reply-To: <20221025222237.GA4635@hopium>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--2l67orfrxkjniwtd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 26.10.2022 00:22:37, Matej Vasilevski wrote:
> On Mon, Oct 24, 2022 at 10:02:38PM +0200, Marc Kleine-Budde wrote:
> > On 12.10.2022 08:25:56, Matej Vasilevski wrote:
> > > This patch adds support for retrieving hardware timestamps to RX and
> >=20
> > Later in the code you set struct ethtool_ts_info::tx_types but the
> > driver doesn't set TX timestamps, does it?
>=20
> No, it doesn't explicitly. Unless something changed and I don't know abou=
t it,
> all the drivers using can_put_echo_skb() (includes ctucanfd) now report
> software (hardware if available) tx timestamps thanks to Vincent's patch.
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git/co=
mmit/?id=3D12a18d79dc14c80b358dbd26461614b97f2ea4a6

Yes, since that patch, drivers using can_put_echo_skb() support software
TX timestamps. But you have to set the HW timestamp on the TX'ed CAN
frame prior to the can_rx_offload_get_echo_skb() call for HW TX
timestamps, e.g.:

| https://elixir.bootlin.com/linux/v6.0.3/source/drivers/net/can/spi/mcp251=
xfd/mcp251xfd-tef.c#L112

[...]

> > > +	/* Setup conversion constants and work delay */
> > > +	if (priv->timestamp_possible) {
> > > +		u64 max_cycles;
> > > +		u64 work_delay_ns;
> > > +		u32 maxsec;
> > > +
> > > +		priv->cc.read =3D ctucan_read_timestamp_cc_wrapper;
> > > +		priv->cc.mask =3D CYCLECOUNTER_MASK(timestamp_bit_size);
> > > +		maxsec =3D min_t(u32, CTUCANFD_MAX_WORK_DELAY_SEC,
> > > +			       div_u64(priv->cc.mask, timestamp_clk_rate));
> > > +		clocks_calc_mult_shift(&priv->cc.mult, &priv->cc.shift,
> > > +				       timestamp_clk_rate, NSEC_PER_SEC, maxsec);
> > > +
> > > +		/* shortened copy of clocks_calc_max_nsecs() */
> > > +		max_cycles =3D div_u64(ULLONG_MAX, priv->cc.mult);
> > > +		max_cycles =3D min(max_cycles, priv->cc.mask);
> > > +		work_delay_ns =3D clocksource_cyc2ns(max_cycles, priv->cc.mult,
> > > +						   priv->cc.shift) >> 2;
> >=20
> > I think we can use cyclecounter_cyc2ns() for this, see:
> >=20
> > | https://elixir.bootlin.com/linux/v6.0.3/source/drivers/net/ethernet/t=
i/cpts.c#L642
> >=20
> > BTW: This is the only networking driver using clocks_calc_mult_shift()
> > (so far) :D
> >=20
>=20
> I don't really see the benefit at the moment (I have to include
> clocksource.h anyway due to the clocks_calc_mult_shift()), but sure,
> I'll use cyclecounter_cyc2ns().
>=20
> Fun fact :-D I might look into the cpts.c

The benefit is less variance in the kernel tree, use the same pattern to
calculate the delay if both register width and frequency are unknown at
compile time.

[...]

> >Regarding the timestamp_clk handling:
> >
> >If you prepare_enable the timestamp_clk during probe_common() and don't
> >disable_unprepare it, it stays on the whole lifetime of the driver. So
> >there's no need/reason for the runtime suspend/resume functions.
> >
> >So either keep the clock powered and remove the suspend/resume functions
> >or shut down the clock after probe.
> >
> >If you want to make things 1000% clean, you can get the timestamp's
> >clock rate during open() and re-calculate the mult and shift. The
> >background is that the clock rate might change if the clock is not
> >enabled (at least that's not guaranteed by the common clock framework).
> >Actual HW implementations might differ.
>=20
> Hmm, I thought that pm_runtime_put() will eventually run runtime suspend
> callback, but now I see that it will run only the idle callback (which
> I haven't defined).
> I'll remove the runtime suspend/resume callbacks.

If your clock stays enabled the whole driver lifetime you can use
devm_clk_get_enabled(), devm will take care of the disable & unprepare.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--2l67orfrxkjniwtd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmNY3psACgkQrX5LkNig
012JVQf+Kmtl9VwlhnbuQxUaQTfLZYcHTNpnfpLQqwdY3D0eVghiAKzQY5CJScB2
nzwYYsTgJd4wFm2a8hJQkOmtvo2dyqiQlwzEFomuoj2z5qHfz+IQy3xyGyc1hUZZ
tHFg40Rr7YuD/gp/uWZAP6+wF0fFlhFj5+NFiYrSOpSUQ7j+xos3Q19Xwsyl0r8z
UV8q0gA1wKI1Ii3H5oTrokGiQY0nTxjsVLfxgv7ruy0l+sGGjWRtYUisg2xl1SZm
pWVeFPvW52E+l9Wgkrevtcnxc2iDR5oWXBPy7sC8Z8BpUnjlFR1/2CB8U9o2II6h
stAqS8Fy+tBB5RoHoS9DPDe9LFp97A==
=lPhI
-----END PGP SIGNATURE-----

--2l67orfrxkjniwtd--
