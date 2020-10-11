Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E6D28A658
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 10:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729307AbgJKIcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 04:32:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbgJKIcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 04:32:32 -0400
Received: from wp003.webpack.hosteurope.de (wp003.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:840a::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4441DC0613CE;
        Sun, 11 Oct 2020 01:32:31 -0700 (PDT)
Received: from p548da7b6.dip0.t-ipconnect.de ([84.141.167.182] helo=kmk0); authenticated
        by wp003.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1kRWm5-0008An-OQ; Sun, 11 Oct 2020 10:32:13 +0200
From:   Kurt Kanzenbach <kurt@kmk-computers.de>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, kurt@linutronix.de
Subject: Re: [PATCH net-next 1/2] dt-bindings: net: dsa: b53: Add YAML bindings
In-Reply-To: <3249c764-ec4a-26be-a52d-e9e85f3162ea@gmail.com>
References: <20201010164627.9309-1-kurt@kmk-computers.de>
 <20201010164627.9309-2-kurt@kmk-computers.de>
 <3249c764-ec4a-26be-a52d-e9e85f3162ea@gmail.com>
Date:   Sun, 11 Oct 2020 10:32:02 +0200
Message-ID: <877drxp3i5.fsf@kmk-computers.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
X-bounce-key: webpack.hosteurope.de;kurt@kmk-computers.de;1602405151;c918a955;
X-HE-SMSGID: 1kRWm5-0008An-OQ
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat Oct 10 2020, Florian Fainelli wrote:
> On 10/10/2020 9:46 AM, Kurt Kanzenbach wrote:
>> Convert the b53 DSA device tree bindings to YAML in order to allow
>> for automatic checking and such.
>>=20
>> Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
>> Signed-off-by: Kurt Kanzenbach <kurt@kmk-computers.de>
>
> Thanks for making this change, there are quite a few warnings that are=20
> going to show up because the binding was defined in a way that it would=20
> define chip compatible strings, which not all DTS files are using.

Oh, I didn't know there is a second make command for doing the actual
check against the dtbs. I've just used `make dt_binding_check'.

So, it seems like a lot of the errors are caused by the include files
such as

[linux]/arch/arm/boot/dts/bcm5301x.dtsi

	srab: srab@18007000 {
		compatible =3D "brcm,bcm5301x-srab";
		reg =3D <0x18007000 0x1000>;

		status =3D "disabled";

		/* ports are defined in board DTS */
	};

The nodename should be "switch" not "srab" as enforced by
dsa.yaml. Furthermore, some DTS files are not adding the chip specific
compatible strings and the ports leading to more errors.

There are also some minor errors regarding the reg-names and such for
specific instances.

How should we proceed? Adding the missing compatible strings and ports
to the DTS files? Or adjusting the include files?

> I don't know if Rob would be comfortable with taking this until we
> resolve all warnings first.

Probably not. We should fix the existing device trees first.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJKBAEBCAA0FiEEiQLjxJIQcNxwU7Bj249qgr3OILkFAl+CwwIWHGt1cnRAa21r
LWNvbXB1dGVycy5kZQAKCRDbj2qCvc4guTL2D/4/J9yKF/KUjL+XZvYUslqcMSwu
HkoIg5d416nWzCbbJ1jyZRHdJeQspVOymcoE8plPjjoQl9MjT1nnFfXSCUiAybq+
lAvxgP/Pj4GrInnRTIWynzvo+W6o5G0jJLrUWO5GdJdMQRqDpoy3SizLAfNk9q/W
AsGo+7La3CwQAuZmyQ145NdsMph6uRuW8BxCzdwEI8PI44dMz6kUiSF1DKqJfdRl
+56IrhOdUg6ST28ytwUdDlRvMLbPR9Q5BKxKxK6PYuee4M3O83VNyei5OUZ+mKzi
qUvlT91EmciVqNGnDAM+R14mR5NfVZhvqyxp2YXhIMXlR9KDfLw8dBVypYnyOlkQ
FFcYznTZcMzSMZDerZ61qw81ciXGLtrEyergSmOcpnPv9QodXTrSlPXQO7D/12rj
O1b+mHB4anbJsCWUY03MUhCoPRKBKcVmYE2apnkMFTdRR1ogSgUPgcQ+dvbsBUlQ
N4waVf500qbvJNNOawthiXGQYtzBjo6qaBX6utgbBX/rapLvYp1KffHJHTsoI4TV
G/PjZDjnR+BxQVPdm2bX57t39fz6bFL/ZNIKq4HYrGlKyexqqEVcuHqE3vmAPAmB
xsm1O3MdV4A6qBdxq2ctqM4mnMjjan1O+ROiUIeS6YjXg0Rc1/0MD0ZJPDtUF7mX
4o/+xo7iSiPDKOnFVQ==
=9iWY
-----END PGP SIGNATURE-----
--=-=-=--
