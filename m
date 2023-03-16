Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D150D6BC819
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 09:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbjCPICh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 04:02:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbjCPICb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 04:02:31 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D78B5CC31
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 01:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        date:from:to:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=k1; bh=qTgxZi2N8WngTS7AJuNYP/T8rF/7
        fpHomMW9FUIfnKE=; b=jM3Ioj41dmdwi2mOSWlmWALEXjbD9KQXuez44anmxSKJ
        R/WVcEQRRxXXi/iuzRaj+Bj2l9g8w8C85rxZuvl0Dxk7ejHVs/WJoN06nfmkD20A
        uvkTZFXdmHW3sf8WdQGZGxpJVmhZNRrDJyNJqbDeLN9yMcXf79ckku7ZR23Xh6g=
Received: (qmail 3698686 invoked from network); 16 Mar 2023 09:02:17 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 16 Mar 2023 09:02:17 +0100
X-UD-Smtp-Session: l3s3148p1@Za8f4f/2boUujnvb
Date:   Thu, 16 Mar 2023 09:02:17 +0100
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     Wei Fang <wei.fang@nxp.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 3/4] fec: add FIXME to move 'mac_managed_pm' to
 probe
Message-ID: <ZBLNCYgeTtNBSaMi@ninjato>
Mail-Followup-To: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Wei Fang <wei.fang@nxp.com>,
        "linux-renesas-soc@vger.kernel.org" <linux-renesas-soc@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20230314131443.46342-1-wsa+renesas@sang-engineering.com>
 <20230314131443.46342-4-wsa+renesas@sang-engineering.com>
 <DB9PR04MB8106C492FAAE4D7BE9CB731688BF9@DB9PR04MB8106.eurprd04.prod.outlook.com>
 <ZBFzVjaRjcITP0bA@ninjato>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="IhMaB8MQ29TyJgc3"
Content-Disposition: inline
In-Reply-To: <ZBFzVjaRjcITP0bA@ninjato>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--IhMaB8MQ29TyJgc3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> Yes, I will resend the series as RFC with more explanations.

Because I was able to fix SMSC myself, I'll just describe the procedure
here:

1) apply this debug patch:

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 1b2e253fce75..7b79c5979486 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -310,6 +310,8 @@ static __maybe_unused int mdio_bus_phy_suspend(struct d=
evice *dev)
 	if (phydev->mac_managed_pm)
 		return 0;
=20
+printk(KERN_INFO "****** MDIO suspend\n");
+
 	/* Wakeup interrupts may occur during the system sleep transition when
 	 * the PHY is inaccessible. Set flag to postpone handling until the PHY
 	 * has resumed. Wait for concurrent interrupt handler to complete.

2) boot the device without bringing the interface (and thus the PHY) up.
   Bringing it down after it was up is not the same! It is important
   that it was never up before.

3) do a suspend-to-ram/resume cycle

4) your log should show the above debug message. If not, I was wrong

5) If yes, apply a similar fix to the one I did for the Renesas drivers
   in this series

6) suspend/resume should not show the debug message anymore

7) test for regressions and send out :)

I hope this was understandable. If not, feel free to ask.

Happy hacking,

   Wolfram


--IhMaB8MQ29TyJgc3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmQSzQUACgkQFA3kzBSg
KbbCiw/6A0LifU8y+F4lZ4bTaBEjFkRDzIW0XmWpx5IB8paJhjZsdv0MxeQ+kBRM
40jREfLld5z7zo/JtAo0VThszzSLal5/gx2X1a5qe9IKLnpJ6rTrGEdH+DD2dscP
K8+b2fDHjPJyzq0jYszLewdjjd4noe0GioAdG0A3khvQHyWNYBihIyDrPcbVfGk6
ncD6Mdmu/EegqWNlLtsXkjI5F4DD46T1wUie8FCPEYwOUsB27ff67wH8aMiJ1Y5B
rTyMPbKAiHHrwlpOhigwJm2NV9kMMqwoMr35HjKxKpHuZIuRVGahHk4QuWrLfAtB
OJkECMwo11roYFeYlLkQVfkeTNfWg4TaBUpif3d8WKBDZFy5vY6GYSVD5LBqhvP9
9MIg1UpridQW27daQplEe7Bwj/Z1AJEsh0dhShgn2sDfWKo1wqgttB3rzTT/O12E
GzmrSwsllhOxHfNzZo/u0+KEIEvi9BRxfC/KELEFq02uE6d/K3abCm/+H9RTpb/U
GGmlVhZ+ahW3SpuNX79k7xtDQ3y5Z9I7oYtPP3N3OaHeE/bgecQ8YNio+gLFcU5/
lAFa9d24IxEuzO8r5ZDxt3pY4hvJ579AMvmeR/Rl32R8YH3bPLNmB2pECwvn+7nL
/C/Z7YB8cLS9Ww9XuWsNUYKWdebUNxwYwx21q6I5AzCcPw4r5t0=
=Pti+
-----END PGP SIGNATURE-----

--IhMaB8MQ29TyJgc3--
