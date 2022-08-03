Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E54E5888BC
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 10:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234712AbiHCIhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 04:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234256AbiHCIhh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 04:37:37 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C641ADB7
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 01:37:36 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oJ9sY-0003DA-J2; Wed, 03 Aug 2022 10:37:22 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 66F8AC1E98;
        Wed,  3 Aug 2022 08:37:19 +0000 (UTC)
Date:   Wed, 3 Aug 2022 10:37:18 +0200
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
Subject: Re: [PATCH v2 1/3] can: ctucanfd: add HW timestamps to RX and error
 CAN frames
Message-ID: <20220803083718.7bh2edmsorwuv4vu@pengutronix.de>
References: <20220801184656.702930-1-matej.vasilevski@seznam.cz>
 <20220801184656.702930-2-matej.vasilevski@seznam.cz>
 <20220802092907.d2xtbqulkvzcwfgj@pengutronix.de>
 <202208021820.17878.pisa@cmp.felk.cvut.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="izugbepx2z5mwcpb"
Content-Disposition: inline
In-Reply-To: <202208021820.17878.pisa@cmp.felk.cvut.cz>
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


--izugbepx2z5mwcpb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 02.08.2022 18:20:17, Pavel Pisa wrote:
> Hello Marc,
>=20
> thanks for feedback.
>=20
> On Tuesday 02 of August 2022 11:29:07 Marc Kleine-Budde wrote:
> > On 01.08.2022 20:46:54, Matej Vasilevski wrote:
> > > This patch adds support for retrieving hardware timestamps to RX and
> > > error CAN frames. It uses timecounter and cyclecounter structures,
> > > because the timestamping counter width depends on the IP core integra=
tion
> > > (it might not always be 64-bit).
> > > For platform devices, you should specify "ts_clk" clock in device tre=
e.
> > > For PCI devices, the timestamping frequency is assumed to be the same
> > > as bus frequency.
> > >
> > > Signed-off-by: Matej Vasilevski <matej.vasilevski@seznam.cz>
> > > ---
> > >  drivers/net/can/ctucanfd/Makefile             |   2 +-
> > >  drivers/net/can/ctucanfd/ctucanfd.h           |  20 ++
> > >  drivers/net/can/ctucanfd/ctucanfd_base.c      | 214 ++++++++++++++++=
+-
> > >  drivers/net/can/ctucanfd/ctucanfd_timestamp.c |  87 +++++++
> > >  4 files changed, 315 insertions(+), 8 deletions(-)
> > >  create mode 100644 drivers/net/can/ctucanfd/ctucanfd_timestamp.c
> ...
> > > +	if (ts_high2 !=3D ts_high)
> > > +		ts_low =3D priv->read_reg(priv, CTUCANFD_TIMESTAMP_LOW);
> > > +
> > > +	return concatenate_two_u32(ts_high2, ts_low) & priv->cc.mask;
> > > +}
> > > +
> > >  #define CTU_CAN_FD_TXTNF(priv) (!!FIELD_GET(REG_STATUS_TXNF,
> > > ctucan_read32(priv, CTUCANFD_STATUS))) #define CTU_CAN_FD_ENABLED(pri=
v)
> > > (!!FIELD_GET(REG_MODE_ENA, ctucan_read32(priv, CTUCANFD_MODE)))
> >
> > please make these static inline bool functions.
>=20
> We put that to TODO list. But I prefer to prepare separate followup
> patch later.

ACK. I noticed later that these were not modified by this patch. Sorry
for the noise

>=20
> > > @@ -736,7 +764,9 @@ static int ctucan_rx(struct net_device *ndev)
> > >  		return 0;
> > >  	}
> > >
> > > -	ctucan_read_rx_frame(priv, cf, ffw);
> > > +	ctucan_read_rx_frame(priv, cf, ffw, &timestamp);
> > > +	if (priv->timestamp_enabled)
> > > +		ctucan_skb_set_timestamp(priv, skb, timestamp);
> >
> > Can the ctucan_skb_set_timestamp() and ctucan_read_timestamp_counter()
> > happen concurrently? AFAICS they are all called from ctucan_rx_poll(),
> > right?
>=20
> I am not sure about which possible problem do you think.
> But ctucan_read_timestamp_counter() is fully reentrant
> and has no side effect on the core. So there is no
> problem.

ctucan_read_timestamp_counter() is reentrant, but on 32 bit systems the
update of tc->cycle_last isn't.

[...]

> > > +
> > > +	/* Obtain timestamping frequency */
> > > +	if (pm_enable_call) {
> > > +		/* Plaftorm device: get tstamp clock from device tree */
> > > +		priv->timestamp_clk =3D devm_clk_get(dev, "ts-clk");
> > > +		if (IS_ERR(priv->timestamp_clk)) {
> > > +			/* Take the core clock frequency instead */
> > > +			timestamp_freq =3D can_clk_rate;
> > > +		} else {
> > > +			timestamp_freq =3D clk_get_rate(priv->timestamp_clk);
> > > +		}
> >
> > Who prepares/enabled the timestamp clock? clk_get_rate() is only valid =
if
> > the clock is enabled. I know, we violate this for the CAN clock. :/
>=20
> Yes, I have noticed that we miss clk_prepare_enable() in the
> ctucan_probe_common() and clk_disable_unprepare() in ctucan_platform_remo=
ve().

Oh, I missed the fact that the CAN clock is not enabled at all. That
should be fixed, too, in a separate patch.

So let's focus on the ts_clk here. On DT systems if there's no ts-clk,
you can assign the normal clk pointer to the priv->timestamp_clk, too.
Move the calculation of mult, shift and the delays into
ctucan_timestamp_init(). If ctucan_timestamp_init is not NULL, add a
clk_prepare_enable() and clk_get_rate(), otherwise use the can_clk_rate.
Add the corresponding clk_disable_unprepare() to ctucan_timestamp_stop().

> The need for clock running should be released in ctucan_suspend()
> and regained in ctucan_resume(). I see that the most CAN drivers
> use there clk_disable_unprepare/clk_prepare_enable but I am not
> sure, if this is right. Ma be plain clk_disable/clk_enable should
> be used for suspend and resume because as I understand, the clock
> frequency can be recomputed and reset during clk_prepare which
> would require to recompute bitrate. Do you have some advice
> what is a right option there?

For the CAN clock, add a prepare_enable to ndo_open, corresponding
function to ndo_stop. Or better, add these time runtime_pm.

Has system suspend/resume been tested? I think the IP core might be
powered off during system suspend, so the driver has to restore the
state of the chip. The easiest would be to run through
chip_start()/chip_stop().

For the possible change of clock rate between probe and ifup, we should
add a CAN driver framework wide function to re-calculate the bitrates
with the current clock rate after the prepare_enable.

BTW: In an early version of the stm32mp1 device tree some graphics clock
and the CAN clock shared the same parent clock. The configuration of the
display (which happened after the probe of the CAN driver ) caused a
different rate in the CAN clock, resulting in broken bit timings.

> Actual omission is no problem on our systems, be the clock are used
> in whole FPGA system with AXI connection and has to running already
> and we use same for timestamping.
>=20
> I would prefer to allow timestamping patch as it is without clock enable
> and then correct clock enable, disable by another patch for both ts and c=
ore
> clocks.

NACK - if the time stamping clock is added, please with proper handling.
The core clock can be fixed in a later patch.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--izugbepx2z5mwcpb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLqM7sACgkQrX5LkNig
012UEggApgw++SiOOTSwAHObtiyCNc2Gg/EuWuJi+J+uoqiwj2GNNkK7W0DNUVRz
x+GpBuroQNqFrIJ3WntuVwWlbHRXAbFMNEzkxDR8HCH2nhiLkovpqAKnJqmCqPhU
PEgPElv4QZsheOOC+emcedUxYsRudLDDFe92OyPgGwlb19wbKkBZBQvLNbs1yXV/
VpTLLigtYBvLHFliNvT+xFEkY+iYJoDlPutNcuKlb+q6AWZ65fGvAMvGvq6ybaAX
M1MgK0bdOBUTMK8flwKXRBOnUJmLVKKfMcdhBNAwjAB4Bvm83XjX8FdEI7pKeWOw
2A4fCtfzYbAKyBhLsS5yL2e9jitQkw==
=KN02
-----END PGP SIGNATURE-----

--izugbepx2z5mwcpb--
