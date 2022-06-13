Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 827A754801F
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 09:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238518AbiFMHB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 03:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238378AbiFMHBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 03:01:25 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDBA167F0
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 00:01:24 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o0e4T-0001Wn-1V; Mon, 13 Jun 2022 09:01:09 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 4F9719388D;
        Mon, 13 Jun 2022 07:01:06 +0000 (UTC)
Date:   Mon, 13 Jun 2022 09:01:05 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org, michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 04/13] can: slcan: use CAN network device driver API
Message-ID: <20220613070105.wfvjfyyoozyhlqgw@pengutronix.de>
References: <20220612213927.3004444-1-dario.binacchi@amarulasolutions.com>
 <20220612213927.3004444-5-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ccwrf434ekjioy6h"
Content-Disposition: inline
In-Reply-To: <20220612213927.3004444-5-dario.binacchi@amarulasolutions.com>
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


--ccwrf434ekjioy6h
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 12.06.2022 23:39:18, Dario Binacchi wrote:
> As suggested by commit [1], now the driver uses the functions and the
> data structures provided by the CAN network device driver interface.
>=20
> Currently the driver doesn't implement a way to set bitrate for SLCAN
> based devices via ip tool, so you'll have to do this by slcand or
> slcan_attach invocation through the -sX parameter:
>=20
> - slcan_attach -f -s6 -o /dev/ttyACM0
> - slcand -f -s8 -o /dev/ttyUSB0
>=20
> where -s6 in will set adapter's bitrate to 500 Kbit/s and -s8 to
> 1Mbit/s.
> See the table below for further CAN bitrates:
> - s0 ->   10 Kbit/s
> - s1 ->   20 Kbit/s
> - s2 ->   50 Kbit/s
> - s3 ->  100 Kbit/s
> - s4 ->  125 Kbit/s
> - s5 ->  250 Kbit/s
> - s6 ->  500 Kbit/s
> - s7 ->  800 Kbit/s
> - s8 -> 1000 Kbit/s
>=20
> In doing so, the struct can_priv::bittiming.bitrate of the driver is not
> set and since the open_candev() checks that the bitrate has been set, it
> must be a non-zero value, the bitrate is set to a fake value (-1U)
> before it is called.

The patch description doesn't mention the change of the locking from
rtnl to a spin_lock. Please test your code with a kernel that has
CONFIG_PROVE_LOCKING enabled.

Please move patch
| [PATCH v3 05/13] can: netlink: dump bitrate 0 if can_priv::bittiming.bitr=
ate is -1U
in front of this one.

> @@ -374,7 +375,7 @@ static netdev_tx_t slc_xmit(struct sk_buff *skb, stru=
ct net_device *dev)
>  	spin_unlock(&sl->lock);
> =20
>  out:
> -	kfree_skb(skb);
> +	can_put_echo_skb(skb, dev, 0, 0);

Where's the corresponding can_get_echo_skb()?

If you convert the driver to can_put_echo_skb()/can_get_echo_skb(), you
must set "netdev->flags |=3D IFF_ECHO;". And you should do the put()
before triggering the send, the corresponding get() needs to be added
where you have the TX completion from the hardware. If you don't get a
response the best you can do is moving it after the triggering of the
send.

If you want to convert the driver to can_put/get_echo_skb(), please make
it a separate patch.

>  	return NETDEV_TX_OK;
>  }
> =20
> @@ -394,6 +395,8 @@ static int slc_close(struct net_device *dev)
>  		clear_bit(TTY_DO_WRITE_WAKEUP, &sl->tty->flags);
>  	}
>  	netif_stop_queue(dev);
> +	close_candev(dev);
> +	sl->can.state =3D CAN_STATE_STOPPED;
>  	sl->rcount   =3D 0;
>  	sl->xleft    =3D 0;
>  	spin_unlock_bh(&sl->lock);
> @@ -405,21 +408,36 @@ static int slc_close(struct net_device *dev)
>  static int slc_open(struct net_device *dev)
>  {
>  	struct slcan *sl =3D netdev_priv(dev);
> +	int err;
> =20
>  	if (sl->tty =3D=3D NULL)
>  		return -ENODEV;
> =20
> +	/* The baud rate is not set with the command
> +	 * `ip link set <iface> type can bitrate <baud>' and therefore
> +	 * can.bittiming.bitrate is 0, causing open_candev() to fail.
> +	 * So let's set to a fake value.
> +	 */
> +	sl->can.bittiming.bitrate =3D -1;
> +	err =3D open_candev(dev);
> +	if (err) {
> +		netdev_err(dev, "failed to open can device\n");
> +		return err;
> +	}
> +
> +	sl->can.state =3D CAN_STATE_ERROR_ACTIVE;
>  	sl->flags &=3D BIT(SLF_INUSE);
>  	netif_start_queue(dev);
>  	return 0;
>  }
> =20
> -/* Hook the destructor so we can free slcan devs at the right point in t=
ime */
> -static void slc_free_netdev(struct net_device *dev)
> +static void slc_dealloc(struct slcan *sl)
>  {
> -	int i =3D dev->base_addr;
> +	int i =3D sl->dev->base_addr;
> =20
> -	slcan_devs[i] =3D NULL;
> +	free_candev(sl->dev);
> +	if (slcan_devs)

Why have you added this check?

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ccwrf434ekjioy6h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKm4K8ACgkQrX5LkNig
012mXQgAi+rDJc5evDKgChhpPHoAiEz4ETrlh17X0Ow3tKG1hYhcVe84sTj8qHos
6LLW7q+1wfWR8cYKKkAubLHWB4w/bpb9h4/yhW2c034U4GyDOlcQHn4FWyG0uy/H
OtKvxLNd1Y6DraXGjL+5qnecH8YZ5Y92v1CSgFEOkOzXPibLsxC9/ElZQjFWNJsj
Do9BheA72WQBTTl1HymU6tKe5MG2kbNJ4CEpnOk/zr3svCm/OCFcctjgwZ+QIKxW
prRc4AJtivbX2RsqJ6tAanSI9OsOC+5uM0g7FXSMJl5OCa0d5nya+aWBSZBp69uy
MrgwB5ke69MX0OPRwgLN1eR9Sh9pZA==
=SrP2
-----END PGP SIGNATURE-----

--ccwrf434ekjioy6h--
