Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 991DA5B8EF7
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 20:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiINSk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 14:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiINSk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 14:40:56 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2054.outbound.protection.outlook.com [40.107.20.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C148C7858F;
        Wed, 14 Sep 2022 11:40:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J74zYvVf+e+b6VPB0swBVgpZwJhxYy3OtEX203jvZe1D7HRdWtuVbXsYbfdOqSJkWBnKG624+3X2GYVfkUBFHe9NePYgXUC6AUQLuw9PjaD2/WFNTQESLqrQvPYqF0WWpYUh+stB743TNZAugzkdDdp7JBe7n0wUsebwHEr6c+kYKADCzBHDnVGqUFyEkhbmlBVrQjSjgtY8YNUfDxMA7BBzi5Q3gdF/tfX2kfkj69278pVuHPSxs1H78lafT59D5qie8khF61fItKGBiCTRFdRuacnasapI4t99to9tvODGXtr6E/2OaAlWObHvTkfoUNPEyB7HOqEvHLDHnzfDxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SabWVLWwFdou9gFaZhBPHsutHQh6Z7Tk23GaGagStEw=;
 b=Zy9295AzriwN8NKybtBJgtg6XiODfh5LtE34Y5eMPIxBgJHYVQbxcDxxsrON01fD2SK65XLZaDJ4X7dYsJNFMRQ70LRtvk40hzJDTk8WzPjSn4t5vsQyx5UPK+P9Z0rN/KgkeITFFVPvmHNjqkr4XZ076QqAHr8R+FZKrx3RLzru3ABwkHXM2u5IuURU2GxrFS9OsTc4ILwXQd5nGsaMAk2aKDl2cR7oi9YxmMhvl4tiGo0rRogvJ0zhzCNn58eML3QVJ2CtuWwXl3d5yVieA26Lvmc0YKavZz12IAQgCnSbwCLQDYatdPKWVQb1AL8xIvoAjifm2SRYqm7oxu9LCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SabWVLWwFdou9gFaZhBPHsutHQh6Z7Tk23GaGagStEw=;
 b=MyZIKykAR0a0T3JFogNVnuW7JODUlItopWnlOTebqyGjmdfQxBfOwHjK/i0uXfaXoo1DuBRouTK+lGUzr1QyLuEWp2EDuLw2IgK/1AO0ffT8PsI/vlujU5YyTPQlm9IcBlkaszNE0xlEcB1hl1vPiNGHgZ1PFpyV5Q53v9e5CGY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB7036.eurprd04.prod.outlook.com (2603:10a6:10:12f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 14 Sep
 2022 18:40:52 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 18:40:52 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 08/13] net: dsa: hellcreek: deny tc-taprio
 changes to per-tc max SDU
Thread-Topic: [PATCH net-next 08/13] net: dsa: hellcreek: deny tc-taprio
 changes to per-tc max SDU
Thread-Index: AQHYyE9hWKLuwg2RcUaJgx4+STifDq3fOt+AgAAHiYA=
Date:   Wed, 14 Sep 2022 18:40:52 +0000
Message-ID: <20220914184051.2awuutgr4vm4tfgf@skbuf>
References: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
 <20220914153303.1792444-9-vladimir.oltean@nxp.com> <87a671bz8e.fsf@kurt>
In-Reply-To: <87a671bz8e.fsf@kurt>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|DB8PR04MB7036:EE_
x-ms-office365-filtering-correlation-id: 6823c97b-43a9-4f8a-b9cf-08da9680a6d2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uAWTGSVoFXbMW45QG5CmTmj7IL7vUPn4948dwNA6ilSh0N/cTZ/8IzMDnt+l9pYujQjRvLAEizCeeQNJPOxasmIvDe3QpbWmESJrPCuGVdB4rYHv/w+OG/1CMYiq/COP6GdXnCXofZ7SDSlpNGAMPo0XplM1mKeUWi08TNOiRRqwlO33P52hZIsF54Cwq/Sspf1Q4nCDweFb04tulqmdjfHLdV+Dygk51y1TtQ7eCRo8wXc3P0XssBqtuwZ+4UHiaI+mZigq9bF5xbbblDLtHZhlY9h+Oe+K2Fjzedgb4f1B8xhGbFlDADlEYvul9UmJK8YhnGm1q6UxxvCSRsve5yD8/VQ26FZqMrB5+p5fReCUYtEuaO7fr3FrMUAOsAt996VoNDUDmqfDndcfNQdEAXCBCu+Wg3KkF/cEnYEWl3Gaojh6/C/dWKDPoRxsna3jBevQWhA63WY0p+hbvEtkxJQNHHl5aftjyjFFg2GACQF0f8df1fhX8CR5obGcREkNjSJDsgvLcCaPQizuOppVzwrBkLzyJrTBwZiAR0rUN/BlSu7h15sqdaF7nGVHlGUFTjbA0UPgopyStqauGAEVud/NyCb7WEhbR4t/gLVEElhjgz1OHfh/tkObHh39GuxV5kxCb3AOo9MCWKpss7dFOLu0QPft1UM5Wu9axZ22AdRQDLLy0PyXOu4VI96nmfjVF7B+HgSXdpx4UHVrix9dpmEz2/t9myq+V6sZZy6ZIGDlYSrOfaugygIM98AmTBR+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(366004)(346002)(136003)(39860400002)(396003)(376002)(451199015)(64756008)(71200400001)(26005)(33716001)(66556008)(6486002)(6512007)(2906002)(122000001)(44832011)(316002)(7416002)(186003)(1076003)(8936002)(8676002)(66476007)(4326008)(66946007)(478600001)(66446008)(9686003)(41300700001)(38100700002)(91956017)(6506007)(76116006)(5660300002)(54906003)(53546011)(38070700005)(6916009)(83380400001)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AOr435Y6pEHmSY92mdi2oLYm6KxkYjNaTMSFfg1iaT0mNY6t4LtipBG1nUzM?=
 =?us-ascii?Q?4zpFohBjV5BYugHOpLGhR59oo5s7arhYfdgbDnJDM4k86h0gWYlywNva2zJ6?=
 =?us-ascii?Q?sP4gFr6igkcISuHM/3VLVaoGGEBSIEyU42ycJGXvN3zI8ergmKGuJMbqmSoU?=
 =?us-ascii?Q?/NZq7kQgPvnR6xf4AmdQLHR/C0WjAtjKk4HbBJEnp36Qpi98P/l9dJI0RbRY?=
 =?us-ascii?Q?4twPN5mBIf2KZWV39DTPQ5aJKaxz8cKBAyUjQq92GY+si8e5w2gxP/c6xPC+?=
 =?us-ascii?Q?KDdGdvQ9nTiZ0W9QQEd1aHgZtv8XWWAQwXBbfaAavaSaOL/DZdV0oDJNUg6N?=
 =?us-ascii?Q?uL4mxscdNPVdCNQ9SvnW5YoBltDpnk7qvkSmlzy+XbsO2C1TKC0twkgkDJtp?=
 =?us-ascii?Q?s2WIg9rFmb2jSRuoRJ/oHahZxJ6bAXA8O/QKTx2meHDpsM0NGSQXWXwL/D9g?=
 =?us-ascii?Q?4ZWoJhgP1wjfY2Kv7VnOX2oSLqxKvFkH4Ol1LqGy5+cpcdkXhyckes0WNvpW?=
 =?us-ascii?Q?cdWT/vw+hKJ9oiELfKVP8z4zBdh5zjpAjSC2qGv9vHm/MnBkLk04mzU5chMh?=
 =?us-ascii?Q?xJV2cl3oT8qe0SsWg6cylvw+Fye6rImPOCJVs1sz6yKti+eYQ6HjgXEBe2ks?=
 =?us-ascii?Q?Qz13mo1GCqnfUY+1f2jepP8cL/NN4Jo7vthoqKNidZJNlKeQAW9QP95DwgQA?=
 =?us-ascii?Q?swH4OkB15XijS5V0fT6jUS3cY8lCNCrUgDBFc5jIpLKZhWRDPE4Wg+b+jy0M?=
 =?us-ascii?Q?cvAUD/nEln7vtmlVAUNY4I++4QRJFNVm6fW3m919ynMFwdyNELkhcOsO98jT?=
 =?us-ascii?Q?FS35YocQ5kYtbUBcm+kw2bRSBKfdvhXai3Bt4q0m8bJkIlcORodDH6Ehn87i?=
 =?us-ascii?Q?hUtHscrq1o4A6wMfCVhHjkvv3U86bq4RNRCIacap5dA9/qkigmBseD/Gclss?=
 =?us-ascii?Q?2zuFGzGp5ZKZxVlxKF/xzsFpq1YqZnV6jrKG9yho8fm0MJ8h89LcSQU8fYc1?=
 =?us-ascii?Q?+dBxw+nu2/MV3OiXqjy6LH77FqGOBJ6U4J+AbmmmJh1GZh6WiGqzX7qmcLSP?=
 =?us-ascii?Q?tudHj2H3UF4QO8ZP2dStLlrfLCAhWHZ1UQRD4oOc5y+6q+X1xOCTmNXcCIZL?=
 =?us-ascii?Q?AWKXsQFxlz6dniczqJplrYsKa39br8jghb07jls4zBIypvrvzhsxn5gZekih?=
 =?us-ascii?Q?SIsmTXAMYUjqoktZk/YAOVf0FsHY6UPiejnco1vSIWgJe93Ul9yUaZAmxfrf?=
 =?us-ascii?Q?1gymEDS7H9QLkN2y69Gs1D+KpdU37AtxWV8RC6qCsJwszOROr0d5Pg8x3RyB?=
 =?us-ascii?Q?tzBJbNvnoWkzPuzBeNXpEz66dbIA+LCFELTMnLGBiqj5SCEPhoY0iYVtvuzO?=
 =?us-ascii?Q?+8xiHTeuKlufNTOuCxkD9E5ewWhmIrHWhKTaaEfJoa7uEasPgInH6BlatsHF?=
 =?us-ascii?Q?4RChFmdBZeG2xglDaIEAaluXWl3SplNKxDTu2+UvhU1aikpPlYyM65fgR1dI?=
 =?us-ascii?Q?9NoTuKC/wDvrMxdUY5lHwSwtXRwsgq/dZiyl3oaat8nZslC6uK8a+tYG9j0+?=
 =?us-ascii?Q?CbMKgov6A6u+wci+n+gye07A9/p0Gsm9asV3EjBWC3FV/GAYdqGFymocUkZr?=
 =?us-ascii?Q?CQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BF6B1CB6939F5E4E87A884C24C251F50@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6823c97b-43a9-4f8a-b9cf-08da9680a6d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2022 18:40:52.4998
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Oi2SRrrDOitFuRoW04oGwYEgj7m49+B8lH2BLtLgk03PS9nO6wQCkkfnYd3BaKOu+g0hzJ6gDA8zn66Vi4lW1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7036
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 14, 2022 at 08:13:53PM +0200, Kurt Kanzenbach wrote:
> I'd rather like to see that feature implemented :-). Something like below=
.
>=20
> From 3d44683979bf50960125fa3005b1142af61525c7 Mon Sep 17 00:00:00 2001
> From: Kurt Kanzenbach <kurt@linutronix.de>
> Date: Wed, 14 Sep 2022 19:51:40 +0200
> Subject: [PATCH] net: dsa: hellcreek: Offload per-tc max SDU from tc-tapr=
io
>=20
> Add support for configuring the max SDU per priority and per port. If not
> specified, keep the default.
>=20
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---

Nice :) Do you also want the iproute2 patch, so you can test it?

>  drivers/net/dsa/hirschmann/hellcreek.c | 61 +++++++++++++++++++++++---
>  drivers/net/dsa/hirschmann/hellcreek.h |  7 +++
>  2 files changed, 61 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hir=
schmann/hellcreek.c
> index 5ceee71d9a25..1b22710e1641 100644
> --- a/drivers/net/dsa/hirschmann/hellcreek.c
> +++ b/drivers/net/dsa/hirschmann/hellcreek.c
> @@ -128,6 +128,16 @@ static void hellcreek_select_prio(struct hellcreek *=
hellcreek, int prio)
>  	hellcreek_write(hellcreek, val, HR_PSEL);
>  }
> =20
> +static void hellcreek_select_port_prio(struct hellcreek *hellcreek, int =
port,
> +				       int prio)
> +{
> +	u16 val =3D port << HR_PSEL_PTWSEL_SHIFT;
> +
> +	val |=3D prio << HR_PSEL_PRTCWSEL_SHIFT;
> +
> +	hellcreek_write(hellcreek, val, HR_PSEL);
> +}
> +
>  static void hellcreek_select_counter(struct hellcreek *hellcreek, int co=
unter)
>  {
>  	u16 val =3D counter << HR_CSEL_SHIFT;
> @@ -1537,6 +1547,42 @@ hellcreek_port_prechangeupper(struct dsa_switch *d=
s, int port,
>  	return ret;
>  }
> =20
> +static void hellcreek_setup_maxsdu(struct hellcreek *hellcreek, int port=
,
> +				   const struct tc_taprio_qopt_offload *schedule)
> +{
> +	int tc;
> +
> +	for (tc =3D 0; tc < 8; ++tc) {
> +		u16 val;
> +
> +		if (!schedule->max_sdu[tc])
> +			continue;
> +
> +		hellcreek_select_port_prio(hellcreek, port, tc);
> +
> +		val =3D (schedule->max_sdu[tc] & HR_PTPRTCCFG_MAXSDU_MASK)
> +			<< HR_PTPRTCCFG_MAXSDU_SHIFT;
> +
> +		hellcreek_write(hellcreek, val, HR_PTPRTCCFG);

So the maxSDU hardware register tracks exactly the L2 payload size, like
the software variable does, or does it include the Ethernet header size
and/or FCS?

> +	}
> +}=
