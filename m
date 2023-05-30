Return-Path: <netdev+bounces-6358-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C6388715EE5
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:20:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81258281161
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 12:20:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D6B81990D;
	Tue, 30 May 2023 12:20:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91AF517725
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 12:20:55 +0000 (UTC)
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F215EC5;
	Tue, 30 May 2023 05:20:53 -0700 (PDT)
From: Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1685449252;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tdnAZsjhgls6Ysa0NOeGOUiZJaoZowNmTdGhfiI/C5U=;
	b=fZ8qv0Te23M/bJLqj9Tgbb6ugLulO4dv61shIIvrlyKEBW41yLyUKBn0iNHMPNtKFd2821
	hkp0tNq3kBGxqPg684mBxMVGyGc6ykkwnDkaPUujjhu9YJmZYGSaqC4W2YOG4JJzhci0Pl
	P4IyAJ+Kfg7WpBsb0U7owvrkNiMuqsJ8A91b5BUWCk5dbZmDvPJ3HtQySAozCDWlvBwRge
	JX+21vUpL52Ye+ta5dvu1tUOZcum/Yq4f3F92883L//eYymb5IRXX5WLJrGvfnt40WjdfI
	X9BiPl0QuRP43rXkBw1qFMXIWOi4i54hjjPcSJruT5/z9TtqmyblvbcbaMrMvQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1685449252;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tdnAZsjhgls6Ysa0NOeGOUiZJaoZowNmTdGhfiI/C5U=;
	b=xzMIJMURQ7ginLdQaR9ahBUEgohs1yMYQ3L6XcZKS7DdsKI8IGT0ffq+b4ML/g1j3pSCMm
	nW3/uAatyUQETvBg==
To: Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
 <pabeni@redhat.com>, Jamal Hadi Salim <jhs@mojatatu.com>, Cong Wang
 <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>, Vinicius Costa
 Gomes <vinicius.gomes@intel.com>, Gerhard Engleder
 <gerhard@engleder-embedded.com>, Amritha Nambiar
 <amritha.nambiar@intel.com>, Ferenc Fejes <ferenc.fejes@ericsson.com>,
 Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, Roger Quadros
 <rogerq@kernel.org>, Pranavi Somisetty <pranavi.somisetty@amd.com>, Harini
 Katakam <harini.katakam@amd.com>, Giuseppe Cavallaro
 <peppe.cavallaro@st.com>, Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>, Mohammad Athari Bin
 Ismail <mohammad.athari.ismail@intel.com>, Oleksij Rempel
 <linux@rempel-privat.de>, Jacob Keller <jacob.e.keller@intel.com>,
 linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>, Florian
 Fainelli <f.fainelli@gmail.com>, Claudiu Manoil <claudiu.manoil@nxp.com>,
 Alexandre Belloni <alexandre.belloni@bootlin.com>,
 UNGLinuxDriver@microchip.com, Jesse Brandeburg
 <jesse.brandeburg@intel.com>, Tony Nguyen <anthony.l.nguyen@intel.com>,
 Horatiu Vultur <horatiu.vultur@microchip.com>, Jose Abreu
 <joabreu@synopsys.com>, Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 intel-wired-lan@lists.osuosl.org, Muhammad Husaini Zulkifli
 <muhammad.husaini.zulkifli@intel.com>
Subject: Re: [PATCH net-next 2/5] net/sched: taprio: replace
 tc_taprio_qopt_offload :: enable with a "cmd" enum
In-Reply-To: <20230530091948.1408477-3-vladimir.oltean@nxp.com>
References: <20230530091948.1408477-1-vladimir.oltean@nxp.com>
 <20230530091948.1408477-3-vladimir.oltean@nxp.com>
Date: Tue, 30 May 2023 14:20:50 +0200
Message-ID: <87leh6qacd.fsf@kurt>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue May 30 2023, Vladimir Oltean wrote:
> Inspired from struct flow_cls_offload :: cmd, in order for taprio to be
> able to report statistics (which is future work), it seems that we need
> to drill one step further with the ndo_setup_tc(TC_SETUP_QDISC_TAPRIO)
> multiplexing, and pass the command as part of the common portion of the
> muxed structure.
>
> Since we already have an "enable" variable in tc_taprio_qopt_offload,
> refactor all drivers to check for "cmd" instead of "enable", and reject
> every other command except "replace" and "destroy" - to be future proof.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

[...]

> diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hir=
schmann/hellcreek.c
> index 595a548bb0a8..af50001ccdd4 100644
> --- a/drivers/net/dsa/hirschmann/hellcreek.c
> +++ b/drivers/net/dsa/hirschmann/hellcreek.c
> @@ -1885,13 +1885,17 @@ static int hellcreek_port_setup_tc(struct dsa_swi=
tch *ds, int port,
>  	case TC_SETUP_QDISC_TAPRIO: {
>  		struct tc_taprio_qopt_offload *taprio =3D type_data;
>=20=20
> -		if (!hellcreek_validate_schedule(hellcreek, taprio))
> -			return -EOPNOTSUPP;
> +		switch (taprio->cmd) {
> +		case TAPRIO_CMD_REPLACE:
> +			if (!hellcreek_validate_schedule(hellcreek, taprio))
> +				return -EOPNOTSUPP;
>=20=20
> -		if (taprio->enable)
>  			return hellcreek_port_set_schedule(ds, port, taprio);
> -
> -		return hellcreek_port_del_schedule(ds, port);
> +		case TAPRIO_CMD_DESTROY:
> +			return hellcreek_port_del_schedule(ds, port);
> +		default:
> +			return -EOPNOTSUPP;
> +		}
>  	}
>  	default:
>  		return -EOPNOTSUPP;

Uhm, seems like the current code validates the schedule even for
removing a schedule which seems a bit odd. With your changes it looks
correct.

Acked-by: Kurt Kanzenbach <kurt@linutronix.de> # hellcreek

Anyway, the hellcreek device has Tx overrun counters per TC. Even though
they should be zero, simply because the hardware Length Aware Shaper is
enabled by default.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmR16iITHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgkgAD/sH6+pSNn/XkaMNq42jziiZnqWffmMr
Nh0eHkqZEXNIBdYtaHhMDv+UySQW2mYItvt+A5sEWzMGDphJluPslMtYdrm98yaE
LMklWNsKSD0Rp4r74n9b1nFjwSYUbdFX9juS4d/fWMlLAdxfIQ5+ADem4v+82nHa
h8STScKKSQLU2L6js/NO1vRXqlOI2Kk2dycw7PPDcCLme/GaWygQG2u8SNE7g+ij
wp/3sh4O1N6P7wIPHJoRhpr+LU5qBpRjkkE89t/7l7aj91XqnSQ1e08Pe7ryZ5wz
Uq2sVg8oDtGpmv6xciMGGpkAYrIYG/qCjLEz+w15Nq6ur9dwvrNqsyYmTUu84GqH
bSQLxYIPynAOacF7oLy2I+YVMdWJwSw/3iP63LSszGmv7igjaWk/rKRW/OnBLKNj
5q+SVPvCaMGl7PRlaEGnW2QMy4ua2CWIL0nBsJLpe26UFljXA860aytaV1zCItGg
s5GlMspLwC0OEbL8s/E+l8InjJoqIMTn7I6Pqh/G+Wk0QfCD+3vZenRo/uyOBCuc
/xOs0fevBDhGNGqbYR0y6oX/fwzSvwEfjYBb/pWFov5Vh1gh7Dbd6TG2PUq/0g9H
TEc/Qqzr3JDPy1kKkrDVnjOdxwYmFXDcQ3I3V+TmOG2hSkMgdCdZqGE0ygem6W7X
nI5BAnq+D8if4g==
=C7wP
-----END PGP SIGNATURE-----
--=-=-=--

