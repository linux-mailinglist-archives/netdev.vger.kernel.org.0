Return-Path: <netdev+bounces-5010-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B1DFF70F6E6
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:51:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1AD252811BF
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:51:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5725960855;
	Wed, 24 May 2023 12:51:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0426084D
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 12:51:28 +0000 (UTC)
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E8799;
	Wed, 24 May 2023 05:51:25 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1ae6dce19f7so1692655ad.3;
        Wed, 24 May 2023 05:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684932685; x=1687524685;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Zk9EWfEb3kBrQUJGitkwkI89dkxpciH5LXEkEz68Cj8=;
        b=T/XLAZorwFOJbaa+132APjPt+LQnEsFtRTYN3LtrM53eQaswePBHFctCjxCgSDDhjL
         shp/g03d1hxkDFqQCoOTNcYnUvwnGun9DeIBp1zRws3X5wyPTHzSzRqGHDiNDdIoCLWP
         zg/SyF8x0SQvQvYNp8VfjT3Z17jY2pXHGOmhD1JUN6Ev4i9Bn/wdQN7KYt/6eiTilcVK
         rFiEtr/pLq/s139Kb+SEtb/929kZJgiwDjZKwz/wwPmdPAAXmN+RDPaPA/0Hjfw7Qq2w
         gHdixhDSMM6kKKXG9H2m/w+gLQqfRI3YJ2MwGuFUhfidcHqz0HirkRli3v6jxKNxOovm
         rEsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684932685; x=1687524685;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zk9EWfEb3kBrQUJGitkwkI89dkxpciH5LXEkEz68Cj8=;
        b=cB+pARy5A5cLK6NrVTtMcV/73peEjXw+z54EEncSAgQUu87N2Gw6ewoZq6HI5d6fv5
         d3l1LpJVH97nt+tZjyp3azV35Fuw83IBZfdHZRqaDDBK6YuL9Kj3U8ECiGTvqGXQhEzL
         Nnh8K6TYgUJ18ahOsP8At/LQt7mv444oNZb39Dk3pRgrRVPn6Jrt2BywNYusBFSM1kYA
         Cl0CDdXX9wG4Km1fi+/5fnb6nW2VsR8RrorI9gMYVIoqiqgI7DIQUiwFJJ3jSWNDRWDY
         RTRzhRDehsVIcIm3Grkf5GXbFrlpYqJbF0KCpiN9BWlNGHX+IwrrOXszGajGnNcjrFgs
         sB0w==
X-Gm-Message-State: AC+VfDzmBo4mwWxTk75r3ibnqQ87XYJVyEsYS8I1b+m17ZfrJBJnyzvt
	5B+ur3F9sPkDG9xeXPF439I=
X-Google-Smtp-Source: ACHHUZ5C3R3Zpckqk00E2SQecJySjUWpaFT2Zzoiw6GylxDNkN3UlZL/FW9NAvl/SZqFfuEWDECbkQ==
X-Received: by 2002:a17:902:e751:b0:19e:6e00:4676 with SMTP id p17-20020a170902e75100b0019e6e004676mr20675820plf.61.1684932685101;
        Wed, 24 May 2023 05:51:25 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-11.three.co.id. [180.214.232.11])
        by smtp.gmail.com with ESMTPSA id l10-20020a170903244a00b001a221d14179sm8607679pls.302.2023.05.24.05.51.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 05:51:24 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 2D0C210622B; Wed, 24 May 2023 19:51:20 +0700 (WIB)
Date: Wed, 24 May 2023 19:51:20 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Francesco Dolcini <francesco@dolcini.it>, Andrew Lunn <andrew@lunn.ch>,
	Praneeth Bajjuri <praneeth@ti.com>, Geet Modi <geet.modi@ti.com>,
	"David S. Miller" <davem@davemloft.net>
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Grygorii Strashko <grygorii.strashko@ti.com>,
	Dan Murphy <dmurphy@ti.com>
Subject: Re: DP83867 ethernet PHY regression
Message-ID: <ZG4ISE3WXlTM3H54@debian.me>
References: <ZGuDJos8D7N0J6Z2@francesco-nb.int.toradex.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="G6zBKAl4QuB1XUdm"
Content-Disposition: inline
In-Reply-To: <ZGuDJos8D7N0J6Z2@francesco-nb.int.toradex.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--G6zBKAl4QuB1XUdm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 22, 2023 at 04:58:46PM +0200, Francesco Dolcini wrote:
> Hello all,
> commit da9ef50f545f ("net: phy: dp83867: perform soft reset and retain
> established link") introduces a regression on my TI AM62 based board.
>=20
> I have a working DTS with Linux TI 5.10 downstream kernel branch, while
> testing the DTS with v6.4-rc in preparation of sending it to the mailing
> list I noticed that ethernet is working only on a cold poweron.
>=20
> With da9ef50f545f reverted it always works.
>=20
> Here the DTS snippet for reference:
>=20
> &cpsw_port1 {
> 	phy-handle =3D <&cpsw3g_phy0>;
> 	phy-mode =3D "rgmii-rxid";
> };
>=20
> &cpsw3g_mdio {
> 	assigned-clocks =3D <&k3_clks 157 20>;
> 	assigned-clock-parents =3D <&k3_clks 157 22>;
> 	assigned-clock-rates =3D <25000000>;
>=20
> 	cpsw3g_phy0: ethernet-phy@0 {
> 		compatible =3D "ethernet-phy-id2000.a231";
> 		reg =3D <0>;
> 		interrupt-parent =3D <&main_gpio0>;
> 		interrupts =3D <25 IRQ_TYPE_EDGE_FALLING>;
> 		reset-gpios =3D <&main_gpio0 17 GPIO_ACTIVE_LOW>;
> 		reset-assert-us =3D <10>;
> 		reset-deassert-us =3D <1000>;
> 		ti,fifo-depth =3D <DP83867_PHYCR_FIFO_DEPTH_4_B_NIB>;
> 		ti,rx-internal-delay =3D <DP83867_RGMIIDCTL_2_00_NS>;
> 	};
> };
>=20

Thanks for the regression report. I'm adding it to regzbot:

#regzbot ^introduced: da9ef50f545f86
#regzbot title: TI AM62 DTS regression due to dp83867 soft reset

--=20
An old man doll... just what I always wanted! - Clara

--G6zBKAl4QuB1XUdm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZG4IRAAKCRD2uYlJVVFO
o5qfAQDwUI5i8vhNfuMRPTkr53hzcc3BMXEOS2dbl0R+Acl0NAD/Us8OljgaYCr2
IRxQ5ohMdzwq4B8pLzs3Fl4LanHLHQY=
=T8Bf
-----END PGP SIGNATURE-----

--G6zBKAl4QuB1XUdm--

