Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4344FC5B2
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 22:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232614AbiDKUXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 16:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiDKUXt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 16:23:49 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2050.outbound.protection.outlook.com [40.107.20.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D58133A0D
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 13:21:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cxsbRCIbEF2do8HQQTa9NdpZx/lajERLBw3OHNZJLwaUwI8W1XvJgQYYs0rxqefhmZIpneJMYZPlec5Lfes6fwEFGHRUfl2nAA5eaxilIXFeUGEC4zMFdTX2Hm+m6KiTBBy+3I+Trcsgh6W120TVl+vCL92DBmSL5nXoP/3iOppX5P37NR8PbZAOYoCJw4nLHU4Mp3iudiot1IXHZiitbULpyYvqWZJkzoBbuU2v6gDYpcuqe9I8rvpfkZ7ty2xjeIKkP1d6nQwoFzMU4hnXC96/tNiVsedWSFWn+ZJsjBWHJiC44kSAF35MGcVw2+uH9R9qW7mQABSQZ3SOWwTH0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Me/DTbVXSoG9I1ySybG/TGZIhn1pLx4AssvjQjthykA=;
 b=eAMXIPGhdQMbsbjycuYyOD4R+h4MUvWQIWXcdQnJFmVFBFQndI+jBFx0mu4TL85UOyNkgWAhspknFfMm6UkWIr0q9W5adsYt0mo2ZDk8J04HPeZdo99WJgEddMFGHQebJSTB1nbg17TZTM2+gCDY44M8wcBGjW33yTZwZ9FKKvnw/jAU4ihqEAIoU3F4Bqt2UjBJskDmbNHLf7eHQrk4GaIuwZnMhqhbYdDJLQNm1aIkiI140f9FL11FZlWHwu2UvEMDKOBT/7tqVniGBcMplMB+oMcbL2yqdQ1jmXolAXGoltQFEygPyKs9bSU+8UvUK0LOfBrBQCR/zU4rx5tHDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Me/DTbVXSoG9I1ySybG/TGZIhn1pLx4AssvjQjthykA=;
 b=Et9FvgNdek52Enh4mbIUXsdfJYPKvnsocpOkDjVepmNHcCA+a7kmwrd1R6iHS5QYITl1o6RH6tZGYcjd2dYLlgQAmFF4V7Rwc/ImiLdhlMIa13vfF1rpcpOT7/j+p37NVu5sf6OOb29Y7QYR3yHXvGHfgF3+IOZX23O/tMt274E=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB6955.eurprd04.prod.outlook.com (2603:10a6:10:11d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 20:21:29 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 20:21:29 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Joachim Wiberg <troglobit@gmail.com>
CC:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH RFC net-next 07/13] selftests: forwarding: new test,
 verify bridge flood flags
Thread-Topic: [PATCH RFC net-next 07/13] selftests: forwarding: new test,
 verify bridge flood flags
Thread-Index: AQHYTamAs7QHO4PKl0yCkkH/jUKUX6zrKB8A
Date:   Mon, 11 Apr 2022 20:21:29 +0000
Message-ID: <20220411202128.n4dafks4mnkbzr2k@skbuf>
References: <20220411133837.318876-1-troglobit@gmail.com>
 <20220411133837.318876-8-troglobit@gmail.com>
In-Reply-To: <20220411133837.318876-8-troglobit@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 629291f0-9601-4e7d-bccb-08da1bf8dcc6
x-ms-traffictypediagnostic: DB8PR04MB6955:EE_
x-microsoft-antispam-prvs: <DB8PR04MB6955C3151E436CDBB3AB24CDE0EA9@DB8PR04MB6955.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cg6BAPyn2QozSP5AwTvorgAQ9Z0mmuNoYyfHjtzFkiofvrsO195nbcnamYffXxj8ZLR8ewNFBdF17Cd/s1k2uP/Zp1fV8QOJqM5IoTzC5MvswWzyHStHcjj48DjaPUYcpgsn6oFGGONPaN/py1dkvvxye1sKfYmCgZvDrhTXQb2GD2w5WK9VQKxJ5uzF2xJVYHqogG7QX3Xre/bSz24KiURe215gMq2D+a2zYgLKiI2nmRgrJrCAEFEMKK7G7+zavPOQ21XzOZ/55ihXLTXJFlWRitQRkPFFeiTKZ5VLzVNHiiID/ZXEHGDKpf9wyM7t5NklJs8pjsBj7zxLT2Ph4vbocVLd6aVMP2rT+6yPM6Dt5Ed9VcW242z0ROWMF/q75BAU7Uv4czFuinUgLVjKTUtQhjdEcXD6pQDj2QPztgBnvRA4wp9PrOO73Vx89tnnH35mNfu+o/XPW27rvAODnAz0puNu+0xUu6PwNwclDBWSRNaJZmViX99ARUJTfCVe0dgBVrusV+ck8MEMlfk3fsT1mfV7Po7lVJreCdXzy6Q/zE28k+tInOcfLfbEv/Ahw+sQi0K6pYpt75B0aO8BFGt+ZruKQCifJWVFpDvnvDslyBuZ/HEFbchfRgi12yf0mp12nK3ln/HhZbHG9dh9rlkuM/fAMTkXQ5h3J8pXLk5Z4CfBTgBfKwZ+21tGs0BKUMh6aa+IFIperVMedvdxww==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(6916009)(1076003)(86362001)(64756008)(66946007)(66476007)(66446008)(54906003)(66556008)(8676002)(4326008)(44832011)(508600001)(316002)(76116006)(122000001)(38100700002)(6506007)(9686003)(6512007)(71200400001)(38070700005)(6486002)(8936002)(15650500001)(2906002)(33716001)(5660300002)(186003)(26005)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Ki+ONgD3+i32laypc8m8VDqIjhULMfv0KgTlyoa/13sPT+7psfD40veSJAxI?=
 =?us-ascii?Q?wGoEEuEXFgcILPcfNIbYA3vbZw/X02bRDVry0Djxiv/GxvoGY0eCX1zdAU2N?=
 =?us-ascii?Q?iWgvbBeUTnBH+k6HjW1dJRoSLFctPg8TXaZhEH6odlF+FYzgN7m2Ikvbjy87?=
 =?us-ascii?Q?BiUn+SjQRjYWjIq3TumjWFcPdH0fgPIDvqPeK3PsY6GcQ0RKsBPauw9H4XEO?=
 =?us-ascii?Q?KU8OdbfGnO6GiaUm+7fqCJ0mvejBSe2cwD91uXcF+voRHP1z9a64kY8E7ktV?=
 =?us-ascii?Q?iDZ7zp7v+cGYthaW+vqF8TZFXQ1NwSIm2KrumM/MseqW6cKTscP0v3X7jDtf?=
 =?us-ascii?Q?IQM6zAOS40cV6mPNfna4EkQUr7mYnAG4VEjja1C0OIGyGkpK4Fov+CelRz5b?=
 =?us-ascii?Q?yUxFnFfH1hx44gCKSti0bT3w6+O5ZVq4ILT+d1eOgEURKn943iVzIvQIb9Sy?=
 =?us-ascii?Q?AxivofjyDWMB/uYmXXg5kxxpXiwTgWJlWmaWbAks0po8tIQdqdPy37d2sZOS?=
 =?us-ascii?Q?SlGfhOI8OzpwtnIJfeMrpgPdD3ND9k9lbVJH1YbIfvpajoFYrJqtHHpYpX9P?=
 =?us-ascii?Q?txn1153d4VOtVd/N+FTY1RMo/sptQVtx46eckmBR2zlN1S+7cvoy2NeVAbAs?=
 =?us-ascii?Q?Ne+SL0fvAmsD887KgjhjsIGlWh+Bk0iqKUdfjuaWoOtLHWxeKpDb26e64DQ6?=
 =?us-ascii?Q?/cKaXN2EXpHF8+pU9Jid5e3H5eXY+I5+nFME3QtHEHmV+FmTL96aDY9EePAj?=
 =?us-ascii?Q?YI8SUpiKNXEM+2QmSYuEBDaiLCGWaLzEtVwvfA4/wc8k+q0hih2UhQeznwx4?=
 =?us-ascii?Q?7rL6ze+cuDm3Gl/jNU7OJo8jeSvHsnibv+pobc+AI6fqLbYKQCCRlgP4PI4p?=
 =?us-ascii?Q?tvDzzzCEgVVdhDN3gHUCAHGzxUYE4YLY0G1rBlVfiWoPrg/i3XMa1Q+8uPLh?=
 =?us-ascii?Q?gCfJpQgkOsJLehWehJTpvtaryjEIBDMgX1k+1NUgUg4kK+rb6XgYeVJXlmzP?=
 =?us-ascii?Q?zigY4xJH3oBNc9FvK3lKHtRfhwPHDMi54F/uZtO14I1/rW8xI6J1a8jez9BM?=
 =?us-ascii?Q?7UzAKXNM3GKh8Gx7zGzPZDItasf0Y8Pw66r3M22RW+83xSO+02kq8ltLq+p4?=
 =?us-ascii?Q?O5WRkCNvY1HdqVLr5urBCl3w1Stp+R1jNVuauiex3HLSRKO7WIN2bXGvzdL/?=
 =?us-ascii?Q?fmckXEKCAOEoaVoMa5j3khBhXZNxJFjjEqDDbSx2e95uoOkx4TfG8yGxLor7?=
 =?us-ascii?Q?3isQ+jmxNMQoAEmHCd1iw6rWUW/uElQuxwFJ/tt4LkQJZLCntZxUGuuwHutn?=
 =?us-ascii?Q?RHL+EL2DzJwm5S2h+sdn0WPEFy/W4yyRs6/UMjOou2uG8v2dylZhw0xTciNL?=
 =?us-ascii?Q?t3J5SXSKWSEwePhYbE6SmvQPviDy7aZI713D9vQ9Lggd5Z4EKh7XvMH8yAFJ?=
 =?us-ascii?Q?K2RUzKYX7NWUpma+fe2M/ZrZkhbeLWndYQrOPw03hIPktIhrGnabjsCW4z6y?=
 =?us-ascii?Q?UBneMbrpm088qZeaWTyOgSFfO8fyOQcZ60W687DOG2dIn3k/rfc0tZjI8Rjk?=
 =?us-ascii?Q?2ItbfbNKI7K/qHX+W/cFrYyNQf7QL2lWiLnr0pBolxv5cZvHTPI8pAqzBfTk?=
 =?us-ascii?Q?YHFZmkN3J78laeK6xPIRvR8ohtG9Ja4W2uO70aqxxxXAX5lo4dFqvimS0JJQ?=
 =?us-ascii?Q?gNKk7YcVfuAYL4arBqhIOtGELmewvl1ZM9P5BvCZ52laTMbPz2TmJ5ppoG/A?=
 =?us-ascii?Q?QDpc1QPk2JJQ1W5aLPijKbNbgefZJz8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DD442BD49C678D4FA5239A49D0B4FA49@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 629291f0-9601-4e7d-bccb-08da1bf8dcc6
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Apr 2022 20:21:29.4166
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vPpoKdmOkABQ0F0p8LDFVAlZ9irZvi7teWFx3iZ85zyqrxRQnWy9K/08iMKu5Gfy2ZTk75DmtleHkeO+FYTHEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6955
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 11, 2022 at 03:38:31PM +0200, Joachim Wiberg wrote:
> Test per-port flood control flags of unknown BUM traffic by injecting
> bc/uc/mc on one bridge port and verifying it being forwarded to both
> the bridge itself and another regular bridge port.
>=20
> Signed-off-by: Joachim Wiberg <troglobit@gmail.com>
> ---
>  .../testing/selftests/net/forwarding/Makefile |   3 +-
>  .../selftests/net/forwarding/bridge_flood.sh  | 170 ++++++++++++++++++
>  2 files changed, 172 insertions(+), 1 deletion(-)
>  create mode 100755 tools/testing/selftests/net/forwarding/bridge_flood.s=
h
>=20
> diff --git a/tools/testing/selftests/net/forwarding/Makefile b/tools/test=
ing/selftests/net/forwarding/Makefile
> index ae80c2aef577..873fa61d1ee1 100644
> --- a/tools/testing/selftests/net/forwarding/Makefile
> +++ b/tools/testing/selftests/net/forwarding/Makefile
> @@ -1,6 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0+ OR MIT
> =20
> -TEST_PROGS =3D bridge_igmp.sh \
> +TEST_PROGS =3D bridge_flood.sh \
> +	bridge_igmp.sh \
>  	bridge_locked_port.sh \
>  	bridge_mdb.sh \
>  	bridge_port_isolation.sh \
> diff --git a/tools/testing/selftests/net/forwarding/bridge_flood.sh b/too=
ls/testing/selftests/net/forwarding/bridge_flood.sh
> new file mode 100755
> index 000000000000..1966c960d705
> --- /dev/null
> +++ b/tools/testing/selftests/net/forwarding/bridge_flood.sh
> @@ -0,0 +1,170 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Verify per-port flood control flags of unknown BUM traffic.
> +#
> +#                     br0
> +#                    /   \
> +#                  h1     h2

I think the picture is slightly inaccurate. From it I understand that h1
and h2 are bridge ports, but they are stations attached to the real
bridge ports, swp1 and swp2. Maybe it would be good to draw all interfaces.

> +#
> +# We inject bc/uc/mc on h1, toggle the three flood flags for
> +# both br0 and h2, then verify that traffic is flooded as per
> +# the flags, and nowhere else.
> +#
> +#set -x

stray debug line

> +
> +ALL_TESTS=3D"br_flood_unknown_bc_test br_flood_unknown_uc_test br_flood_=
unknown_mc_test"
> +NUM_NETIFS=3D4
> +
> +SRC_MAC=3D"00:de:ad:be:ef:00"
> +GRP_IP4=3D"225.1.2.3"
> +GRP_MAC=3D"01:00:01:c0:ff:ee"
> +GRP_IP6=3D"ff02::42"
> +
> +BC_PKT=3D"ff:ff:ff:ff:ff:ff $SRC_MAC 00:04 48:45:4c:4f"

HELO to you too

> +UC_PKT=3D"02:00:01:c0:ff:ee $SRC_MAC 00:04 48:45:4c:4f"
> +MC_PKT=3D"01:00:5e:01:02:03 $SRC_MAC 08:00 45:00 00:20 c2:10 00:00 ff 11=
 12:b2 01:02:03:04 e1:01:02:03 04:d2 10:e1 00:0c 6e:84 48:45:4c:4f"
> +
> +# Disable promisc to ensure we only receive flooded frames
> +export TCPDUMP_EXTRA_FLAGS=3D"-pl"

Exporting should be required only for sub-shells, doesn't apply when you
source a script.

> +
> +source lib.sh
> +
> +h1=3D${NETIFS[p1]}
> +h2=3D${NETIFS[p3]}
> +swp1=3D${NETIFS[p2]}
> +swp2=3D${NETIFS[p4]}
> +
> +#
> +# Port mappings and flood flag pattern to set/detect
> +#
> +declare -A ports=3D([br0]=3Dbr0 [$swp1]=3D$h1 [$swp2]=3D$h2)

Maybe you could populate the "ports" and the "flagN" arrays in the same
order, i.e. bridge first for all?

Also, to be honest, a generic name like "ports" is hard to digest,
especially since you have another generic variable name "iface".
Maybe "brports" and "station" is a little bit more specific?

> +declare -A flag1=3D([$swp1]=3Doff [$swp2]=3Doff [br0]=3Doff)
> +declare -A flag2=3D([$swp1]=3Doff [$swp2]=3Don  [br0]=3Doff)
> +declare -A flag3=3D([$swp1]=3Doff [$swp2]=3Don  [br0]=3Don )
> +declare -A flag4=3D([$swp1]=3Doff [$swp2]=3Doff [br0]=3Don )

If it's not too much, maybe these could be called "flags_pass1", etc.
Again, it was a bit hard to digest on first read.

> +
> +switch_create()
> +{
> +	ip link add dev br0 type bridge
> +
> +	for port in ${!ports[@]}; do
> +		[ "$port" !=3D "br0" ] && ip link set dev $port master br0
> +		ip link set dev $port up
> +	done
> +}
> +
> +switch_destroy()
> +{
> +	for port in ${!ports[@]}; do
> +		ip link set dev $port down
> +	done
> +	ip link del dev br0
> +}
> +
> +setup_prepare()
> +{
> +	vrf_prepare
> +
> +	let i=3D1
> +	for iface in ${ports[@]}; do
> +		[ "$iface" =3D "br0" ] && continue
> +		simple_if_init $iface 192.0.2.$i/24 2001:db8:1::$i/64
> +		let i=3D$((i + 1))
> +	done
> +
> +	switch_create
> +}
> +
> +cleanup()
> +{
> +	pre_cleanup
> +	switch_destroy
> +
> +	let i=3D1
> +	for iface in ${ports[@]}; do
> +		[ "$iface" =3D "br0" ] && continue
> +		simple_if_fini $iface 192.0.2.$i/24 2001:db8:1::$i/64
> +		let i=3D$((i + 1))
> +	done
> +
> +	vrf_cleanup
> +}
> +
> +do_flood_unknown()
> +{
> +	local type=3D$1
> +	local pass=3D$2
> +	local flag=3D$3
> +	local pkt=3D$4
> +	local -n flags=3D$5

I find it slightly less confusing if "flag" and "flags" are next to each
other in the parameter list, since they're related.

> +
> +	RET=3D0
> +	for port in ${!ports[@]}; do
> +		if [ "$port" =3D "br0" ]; then
> +			self=3D"self"
> +		else
> +			self=3D""
> +		fi
> +		bridge link set dev $port $flag ${flags[$port]} $self
> +		check_err $? "Failed setting $port $flag ${flags[$port]}"
> +	done
> +
> +	for iface in ${ports[@]}; do
> +		tcpdump_start $iface
> +	done
> +
> +	$MZ -q $h1 "$pkt"
> +	sleep 1
> +
> +	for iface in ${ports[@]}; do
> +		tcpdump_stop $iface
> +	done
> +
> +	for port in ${!ports[@]}; do
> +		iface=3D${ports[$port]}
> +
> +#		echo "Dumping PCAP from $iface, expecting ${flags[$port]}:"
> +#		tcpdump_show $iface

Do something about the commented lines.

> +		tcpdump_show $iface |grep -q "$SRC_MAC"

Space between pipe and grep.

> +		rc=3D$?
> +
> +		check_err_fail "${flags[$port]} =3D on"  $? "failed flooding from $h1 =
to port $port"

I think the "failed" word here is superfluous, since check_err_fail
already says "$what succeeded, but should have failed".

> +		check_err_fail "${flags[$port]} =3D off" $? "flooding from $h1 to port=
 $port"
> +	done
> +
> +	log_test "flood unknown $type pass $pass/4"
> +}
> +
> +br_flood_unknown_bc_test()
> +{
> +	do_flood_unknown BC 1 bcast_flood "$BC_PKT" flag1
> +	do_flood_unknown BC 2 bcast_flood "$BC_PKT" flag2
> +	do_flood_unknown BC 3 bcast_flood "$BC_PKT" flag3
> +	do_flood_unknown BC 4 bcast_flood "$BC_PKT" flag4
> +}
> +
> +br_flood_unknown_uc_test()
> +{
> +	do_flood_unknown UC 1 flood "$UC_PKT" flag1
> +	do_flood_unknown UC 2 flood "$UC_PKT" flag2
> +	do_flood_unknown UC 3 flood "$UC_PKT" flag3
> +	do_flood_unknown UC 4 flood "$UC_PKT" flag4
> +}
> +
> +br_flood_unknown_mc_test()
> +{
> +	do_flood_unknown MC 1 mcast_flood "$MC_PKT" flag1
> +	do_flood_unknown MC 2 mcast_flood "$MC_PKT" flag2
> +	do_flood_unknown MC 3 mcast_flood "$MC_PKT" flag3
> +	do_flood_unknown MC 4 mcast_flood "$MC_PKT" flag4
> +}
> +
> +trap cleanup EXIT
> +
> +setup_prepare
> +setup_wait
> +
> +tests_run
> +
> +exit $EXIT_STATUS
> --=20
> 2.25.1
>=
