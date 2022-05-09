Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B955251FAAC
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 12:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbiEILAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 07:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiEILAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 07:00:36 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140087.outbound.protection.outlook.com [40.107.14.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB61B20F4D3;
        Mon,  9 May 2022 03:56:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B+cKC7gaHu0wi9PkBSI6kwu6rnik48MDlRnJZ+lx6x9RRc1XfmuQLANvOLNJui+Ra7ERCJew08QZVHtZU32Y+04o75sCzRB0axwNX+TUyWuxHLpByCl2PByGO+U9sJe7P/OsYdyn6kqU6cnaJg3fmsHP9K5Q7HJBoMjvRVSEPKixLMf+v6yVpyn5UgAAT/YZRDijn0To1TNF1vcima8Ef27500bAezXDJBGTnrsiQPbn8+x7mm5mdz6Sq8r/3vcjDVKPYtPUwEkhh+xr5rwaeVVjEtIuiQYKMfo7TO+YZ/u+jRUNgyuLtlbVlZ3lJ/omiUPB9bxlugjrsPz6jUKm1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tTeGXLvHcKB4u8iZzf33ESA94dIZ/oD+iIbiDF2uvnQ=;
 b=FB6/7zqJnbButXYEBSokZREwpE94/OhdJy2U/MLNJzLnkAvogDIIx3oSvWfiEtriFP+zZOCjV37zSjLhL0d2eKZbwyZErIRblH8YDuuK2TtEdcFkDybRUwd8pyN2PlORLmKHm3vPx+jXBeTlNOdOBu96if2l4qA+SSKBAeIejrXyeYxInaY54MWmxx1T8n2eneQl5CxmPaUpXSe/vDLPFjv9ROHNUJW+RQf4pyen5S78CBzrjaRNxomGsxjhB1BvlgotguiUBLNUBi4FOumvAMJVEdKo4CIy7QZfg25M4pwLQR0gwTGusT8c0TMLm+D7tctbNF4nMNaP3LD1CEHHiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tTeGXLvHcKB4u8iZzf33ESA94dIZ/oD+iIbiDF2uvnQ=;
 b=g4Cvif3GfCge7+hdgcAFZ5X+S7hyUJuimMVy9Q5u4JS4Pm1+BgW6poqtomvKw0UqbIPD4xwXIU4PuUQqK089wWhw60DSESEQa/AYlLA2SioTGV0xeywPfVIHvAngy/jMAFhZFzI5ojKKtctZbJvHeJLCVx6UEc9OSbvp/N1eWMA=
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM0PR0402MB3636.eurprd04.prod.outlook.com (2603:10a6:208:6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Mon, 9 May
 2022 10:56:40 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5227.022; Mon, 9 May 2022
 10:56:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [RFC v8 net-next 11/16] net: mscc: ocelot: expose regfield
 definition to be used by other drivers
Thread-Topic: [RFC v8 net-next 11/16] net: mscc: ocelot: expose regfield
 definition to be used by other drivers
Thread-Index: AQHYYwz4SNH0MpQ2cUi8XXsJVHXXRq0WYM8A
Date:   Mon, 9 May 2022 10:56:39 +0000
Message-ID: <20220509105638.btfgdr4wt427ewip@skbuf>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
 <20220508185313.2222956-12-colin.foster@in-advantage.com>
In-Reply-To: <20220508185313.2222956-12-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 94501c91-fd50-4475-3363-08da31aa987c
x-ms-traffictypediagnostic: AM0PR0402MB3636:EE_
x-microsoft-antispam-prvs: <AM0PR0402MB3636EDCB08D79718990D273BE0C69@AM0PR0402MB3636.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y7XNh5ap1V3rM52S7ARXkWlbCom3Vl5rgrZzZCH1ubLkgdlNbUB/uYJycQyGkKTCkRDmiiudG70L8JD7cQousCcWxp3Yf1ZxfpD996b7XU5XtdWqKTkMkSVcwh1Ca9SQm8tnoo/dCCZKc6HMxzRtsM1JtM98s6sDs1HmnUSiIrNcXYb4oW88CLtMgrC4aJl095TXyjb4e31xzFvgRIVg3+uEFkmdKdjO7ONHLZbXmmsUxwbSPAyOXTavlAMSqoda258l7dCO5E95jmebciDR+B1HSWJiDkKxjMCltqlJ6NQPWT81KrHwGYVCzViidaJSWbUihZMFLWo/S5T/ziFfPgsox4RuQe3MxGQnxu+d/4pzAK7tMVc28Xbrl6SOHpDqCQXPQDUyh8y6YzZ0bpgNbwqkqUhfUTpp54hNBri4bOpjnoM0HfscAteato7MKw8pZjYDTyzSBESs+o2O/SC8BOg9e+FNsShIYeRv6Pvc/6rZi6n83MFdrpCxZnmjt/uuGtKgdSKMD+2h8pWMPwjkZaRIj1PFXmmvXFQNHAVasuLEYl61V5HPu1rrta6QyaH0XLX0smbieSQlKF32qTvOSMne+q+drd0OO14nhoozpBs/4Mf/+M95SRvWmyrhz9HoN9LLriisO7GgQVNnwIyKH/IwNHMZF1j9jsKHB0TRem3/6XEpCApNQwbAwpEemOh+y7a6M4UZ0o72VVkrnhGYEg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(66476007)(54906003)(6916009)(1076003)(8936002)(4326008)(64756008)(66946007)(316002)(66446008)(76116006)(66556008)(8676002)(122000001)(6512007)(9686003)(86362001)(91956017)(6506007)(26005)(71200400001)(508600001)(38070700005)(44832011)(6486002)(38100700002)(2906002)(7416002)(83380400001)(5660300002)(33716001)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5EhETUXbn0haiT7M+xl9SY1fPYTrj+udsmXmYrszUYpNF4HzKI0rz+nhWoo9?=
 =?us-ascii?Q?98xBtgHEs/t4KyqSY85Q3EBprZhmSNTzxgANRX45/xm4Kdi4uO9jPBOUhY82?=
 =?us-ascii?Q?9Vt28DdsJ6U4ZHDsNhOmVgn8hO97mY5es47DgH23qgEMINzmbGc3GUKPq4uM?=
 =?us-ascii?Q?FTBtCFLDefAVhCvG/qeqdIyXo/bztouseoQU3qMjIAUWDzy9FwJ3y32BsjW+?=
 =?us-ascii?Q?eG1JhhdnQBX2xvwELCoiTKzy8ZsOuuiCKtXqRSlnDUtaYnphR9Y3Bgj14hG9?=
 =?us-ascii?Q?PagCbstv7zStXfDy1hYgr0qXSDYrPKOQwvtj6MTdaurRp8VVgnFTi8BMfvCR?=
 =?us-ascii?Q?wxVDyalvnXxiVKMbr7qtrFcY4PQpq7/yRi5PaPTEGI2Xz7EMFSabTL9OQByJ?=
 =?us-ascii?Q?AIrZ1V1GnEw+ZKqwsefymnIY9QkJlJzHtXFU66i2NYykvZ7NW42XKUuhErha?=
 =?us-ascii?Q?Ae1feNZBEbXhK7rhHptQpWQGL4toWBzhLjFpHH1Y9I9uAB4+ECU2M++ZItP3?=
 =?us-ascii?Q?HEt320mGtZb9x8cbGqx6aN/rH1DOXGb+mclivc50Co0XDzY6mlK8o9TcqhJx?=
 =?us-ascii?Q?EjD/97HzML3XQ5MCJ1n9OR49SI4YxisIOmtvvDximjrRffW/+RLWqns8AsYE?=
 =?us-ascii?Q?Jm4wA7fhBhYC+GPsCtXcZPK1IZEF41RD2R9TJegoGnQVkICyKs2dSKMCiCQ+?=
 =?us-ascii?Q?gvBqLCP/+UOsc9jiVbJjkzneHAvkj+21tvpNiMw6mSrJiw3DSyHkginv7SwH?=
 =?us-ascii?Q?emFU0ea0sM5a0ipi4VrfsiJrMLMOORlg9dWUKDZ3drZDmb1Z1azlwH5bAVx1?=
 =?us-ascii?Q?aUifEzecDAXgiirxb53VusSJ/KnmYVU5y7Dqxe2TTvDvZt1TYDOpzZC50o53?=
 =?us-ascii?Q?xuxQ/3PuP85uUsZ5Z9i37WGe6IcatfQ7KCfcva+byjreqga3OBBA3wFXM5bH?=
 =?us-ascii?Q?Uk//ZQFyPxk7Plw4qIFYvM58yr6HrBD1tBPIpZPWF3lN4dBUiVdASMwh/cyJ?=
 =?us-ascii?Q?7C5mWAfaYAhp+TMASGU3HsUl6JTIasOvhYygQudFCPYYPw0JUkA6FBnEtszd?=
 =?us-ascii?Q?btuHz8JjWA5qlPuYy/0CtZcooe3YGa+zfaJOpXLSpAMuVgXHWZXA8BaGZyvi?=
 =?us-ascii?Q?GdFT01pV7iy7MEGZjIXPHBzip6SwT6IzB1akqRTK8G2bU2CulwhQbLgHkP+D?=
 =?us-ascii?Q?oCjf1hNNJcjlVC8v6eStYo4RasCoR352dmLnBs+hd1laE5IEJF4NOUEwWZft?=
 =?us-ascii?Q?zGjIQcuao+kmI4P6pM1byXEEIIWMobiIe0dGC/lfJmHcfz0kmcqSvzS+pw1o?=
 =?us-ascii?Q?QHRIcxwOmpTMlsnMKAAFgdt6KJPr//6XStf9sg93/syYbCWwMbDT8m/yIheR?=
 =?us-ascii?Q?l8up4SIQBT1K3qpBNjxoONJvIZm1YUC+bbZ/H1OVzhCR8nhGywACe1pQrhN3?=
 =?us-ascii?Q?pr+GSWAnNS278D76Gt8DVlrburl7wZ5Eemc+xMpUIIY6NKAHqXG11VBkIYNd?=
 =?us-ascii?Q?tNTXqcpouyD6NROrlWNKNATws54V7DkfqZH46uWY1SKv+b0NT5psxpKbxgmQ?=
 =?us-ascii?Q?yVtHT0IF8gtg3zaw9jdb5zyd/PuwIPRn6/NtP1JUgwtD1NWd4Kf/h/bvIoND?=
 =?us-ascii?Q?3y+TFWNpbJWxxfrsFkzK5uv9SYfxfb5D6IWXoH/UEraptzbFtil66rrIC9Y4?=
 =?us-ascii?Q?IrRgNBN4Bmqwqny8Ti6V8/n8SygJobdtaPqG9k1kA+RW2i8NLV9jEPQ4XYzA?=
 =?us-ascii?Q?0yB20xZpVa9ljUQ480dsF+UM9zPIZ+c=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F8DD128C521AE14F87E437FEC1A97D46@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94501c91-fd50-4475-3363-08da31aa987c
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2022 10:56:39.8199
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e583rh+gN1+SbHrO4mxcIQ4uT1TfW1vAUOgvdW4GkjFnH/Jvr/W6cytmTNozFda6znpi6XINyDIrfcF69dylQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3636
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 08, 2022 at 11:53:08AM -0700, Colin Foster wrote:
> The ocelot_regfields struct is common between several different chips, so=
me
> of which can only be controlled externally. Export this structure so it
> doesn't have to be duplicated in these other drivers.
>=20
> Rename the structure as well, to follow the conventions of other shared
> resources.
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---

Doesn't the symbol need to be actually _exported_ (EXPORT_SYMBOL) to
work when CONFIG_MSCC_OCELOT_SWITCH_LIB is a module?

>  drivers/net/ethernet/mscc/ocelot_vsc7514.c | 60 +---------------------
>  drivers/net/ethernet/mscc/vsc7514_regs.c   | 59 +++++++++++++++++++++
>  include/soc/mscc/vsc7514_regs.h            |  2 +
>  3 files changed, 62 insertions(+), 59 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/eth=
ernet/mscc/ocelot_vsc7514.c
> index 68d205088665..a13fec7247d6 100644
> --- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> +++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> @@ -38,64 +38,6 @@ static const u32 *ocelot_regmap[TARGET_MAX] =3D {
>  	[DEV_GMII] =3D vsc7514_dev_gmii_regmap,
>  };
> =20
> -static const struct reg_field ocelot_regfields[REGFIELD_MAX] =3D {
> -};
> -
>  static const struct ocelot_stat_layout ocelot_stats_layout[] =3D {
>  	{ .name =3D "rx_octets", .offset =3D 0x00, },
>  	{ .name =3D "rx_unicast", .offset =3D 0x01, },
> @@ -231,7 +173,7 @@ static int ocelot_chip_init(struct ocelot *ocelot, co=
nst struct ocelot_ops *ops)
>  	ocelot->num_mact_rows =3D 1024;
>  	ocelot->ops =3D ops;
> =20
> -	ret =3D ocelot_regfields_init(ocelot, ocelot_regfields);
> +	ret =3D ocelot_regfields_init(ocelot, vsc7514_regfields);
>  	if (ret)
>  		return ret;
> =20
> diff --git a/drivers/net/ethernet/mscc/vsc7514_regs.c b/drivers/net/ether=
net/mscc/vsc7514_regs.c
> index c2af4eb8ca5d..847e64d11075 100644
> --- a/drivers/net/ethernet/mscc/vsc7514_regs.c
> +++ b/drivers/net/ethernet/mscc/vsc7514_regs.c
> @@ -9,6 +9,65 @@
>  #include <soc/mscc/vsc7514_regs.h>
>  #include "ocelot.h"
> =20
> +const struct reg_field vsc7514_regfields[REGFIELD_MAX] =3D {
> +};
> +
>  const u32 vsc7514_ana_regmap[] =3D {
>  	REG(ANA_ADVLEARN,				0x009000),
>  	REG(ANA_VLANMASK,				0x009004),
> diff --git a/include/soc/mscc/vsc7514_regs.h b/include/soc/mscc/vsc7514_r=
egs.h
> index ceee26c96959..9b40e7d00ec5 100644
> --- a/include/soc/mscc/vsc7514_regs.h
> +++ b/include/soc/mscc/vsc7514_regs.h
> @@ -10,6 +10,8 @@
> =20
>  #include <soc/mscc/ocelot_vcap.h>
> =20
> +extern const struct reg_field vsc7514_regfields[REGFIELD_MAX];
> +
>  extern const u32 vsc7514_ana_regmap[];
>  extern const u32 vsc7514_qs_regmap[];
>  extern const u32 vsc7514_qsys_regmap[];
> --=20
> 2.25.1
>=
