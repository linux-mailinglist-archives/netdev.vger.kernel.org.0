Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A998A561FCA
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 17:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236256AbiF3P5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 11:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236228AbiF3P5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 11:57:05 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130049.outbound.protection.outlook.com [40.107.13.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33DCB3B00A;
        Thu, 30 Jun 2022 08:57:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LvSKYwHUGbg6BU2OS4UWRSe6GtQeu7lwUtfmhoHkTbWILksj50D70gEDgRlYVH8G0v7VOjlcCdgbQdVdw4K3kLh5mz4ETlsPh6VczvlGKc9/iH45ONZp9h0XfZdtXyjwwF4DsJneoPu/GYYlXE6crd+sBPuu7TJ7wfdWAWYQ8jholiqi0HIZDutnhq+NREVYsRuXGI0/FQyGUw/0KcemspXFxeeu2UpWzKkJlGQs8OwdsvOyCxRgHgYJ+ko0KRJRV8oPPXS83wp3BydR8EYw4cjDS35298LTGKETU8wvJvahd+6EfT/JJSTNo7l3dhXWrWR4/Rw3fI0V+LH9Z9rAOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2B/TpdNAQsvKQS1Wwy4Bbvo5O0XPVDMPIH4NJwxfIB0=;
 b=cgkI7Ml2ZR2l7Wx+FFSVGWk3TUFus/LHoAa1Z2SDMzo9tgQw9lI0FuGYy0lPbt4Nn6kZiKSzHUrUH7L/N2kMHH8l08g4C5xJMeEGMyt+mH6aqxhCZkjmV2SBvCZ7YFqcTMkGfPX3eHkN/lV9KE1YYZ7/qcLnuBb17N5khcyiXdhlnCKalr+XFVsThjJjZVNc3Hya4VfjvkOIDcgd23OZECRnUVsRKSgpmCxIfZog/2tC7SiIHqImK36xwpHDHcQ1pmKskcpffqByZg1DU90WF8shwJ8X6xl5Pvmbk/XDPudIYAJ+gNu+92hvSEnsYkkmbEkWXJRb5OoBvmlMUGwT2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2B/TpdNAQsvKQS1Wwy4Bbvo5O0XPVDMPIH4NJwxfIB0=;
 b=lbu7hV2HsS87HWyXUAr0w0EgCWIH1wvCfQxIZ0ITH5OhmmlOnI8Cs9Wvzl9DHkPfRbdCBEH/gvJYFhnpdG/4APQKAk4HPmi+80sEz+uZFWToCR2Vir/EC/EPepR+JhzdBxxKQln+hwsnp/2OS0NgNpSGQM2/899QYNr91G9XfEg=
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AM6PR04MB5845.eurprd04.prod.outlook.com (2603:10a6:20b:aa::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Thu, 30 Jun
 2022 15:57:00 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::4c14:c403:a8a4:b4e4]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::4c14:c403:a8a4:b4e4%5]) with mapi id 15.20.5373.018; Thu, 30 Jun 2022
 15:57:00 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Eric Dumazet <edumazet@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>
Subject: Re: [PATCH net-next v2 04/35] [RFC] phy: fsl: Add Lynx 10G SerDes
 driver
Thread-Topic: [PATCH net-next v2 04/35] [RFC] phy: fsl: Add Lynx 10G SerDes
 driver
Thread-Index: AQHYizxxgRetEOVzUEGZ10DjfnbHAK1oHZSA
Date:   Thu, 30 Jun 2022 15:56:59 +0000
Message-ID: <20220630155657.wa2z45z25s4e74m4@skbuf>
References: <20220628221404.1444200-1-sean.anderson@seco.com>
 <20220628221404.1444200-5-sean.anderson@seco.com>
In-Reply-To: <20220628221404.1444200-5-sean.anderson@seco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c0504e31-8992-4ac8-5b3e-08da5ab12ac4
x-ms-traffictypediagnostic: AM6PR04MB5845:EE_
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BR1TYXqcnPIpzPFQtrurn+AZ7DrP4yZDrdv2tpj4lmiEfWB0KBRH9iJ/qWYRJdBQM8Zzq9/5U0DrKtv5eDm9wfg6T72wN1FiWXaGePtTQ+t/8D5LR+upqLd2tPyuMBlmThpXvz23pYbBYJ/8Tfqz7TUgxPJgGqT9PRJQdY2LJpcYi6PnGmgxcPib09nJrBMVSw37JdEReY8XMkZ4758xJgSlmDfxmOcpdFvU9qmRn6vUq3NKAWQPqe9QdEt4anV0+Pwm49xvqK6ZEgcbhIOsW4XEWCsaAgi+y88Xg1O5k7uB+JqvlDueK8wnhkRFyg/P9UuJ5hVRUS10bdwfi48CHWFiTFpfMaji2r/HJsNUa9G4M6pcVqHZj9rTGhpzUlaLwa+VPoTLAiNz/6hS7cAuOZzyKpf8BMMttTCvXLIOD3oTFCGC7cKCjqzWF/MX4pgRu6f8PTWN9Agc4h9NLmLXnfXwxTn2b0ACQwKLfNposA+xwPmPVYhTwhTd9xoe5zijbnAxOBwqgthd28PttjZJKaeDG8mvKLgdreobfXDLlR/5cLbAsEJ5GDTLayb32dtXY6w7fDSj39PCgI0aZjbGHMBNFzsMzuFZ8drGRb/wZ8mGXkSC8gylVjITrhxIKF925dhqcsxpDVm+ZQCBNvITltPoS8rWaTYo5ErU90Si6mckPZOAK+YiEUN5lNhy1X09ip5rCHNfiU/qEIemvsV5d3vud3tMCvZIru32MoBMoLL8ZHAoBR+I6/zH9Po5gqmStOhrjf0ZLcA3g8nhL0UCyQ96jlKLpiV28GT37PNE2ENgcsUgKHmHFCWlYl4bmVsL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(39860400002)(376002)(396003)(136003)(366004)(346002)(7416002)(66476007)(66446008)(64756008)(86362001)(8676002)(33716001)(66556008)(6506007)(71200400001)(66946007)(4326008)(26005)(2906002)(76116006)(5660300002)(83380400001)(122000001)(6512007)(9686003)(6486002)(1076003)(316002)(38070700005)(8936002)(54906003)(6916009)(186003)(91956017)(41300700001)(478600001)(44832011)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?91oiVdU8Rc0YLz4wnhHkz5hrxtIVjUtfimQUy1LqI+MfKyQ+yo7p+mLwAYYb?=
 =?us-ascii?Q?ePweV6fgp8dxrErxtg4vSsHFlaE+5rOobH5sMtpwjAebzk6nt348OReumoDp?=
 =?us-ascii?Q?VKbq87TyT2toOQwQsQHucfwVDIPNZXK29BV1rw0lb+RLLRQxp3e5CeeypT5V?=
 =?us-ascii?Q?Y6Bm81dG4zw7PS1BuXySbPvFc/hdtBHMIx9b5JaoZSc/ozuuotYj7JFlldFR?=
 =?us-ascii?Q?7WiH1gUuc6H9ZidzWECGyacVDYtXKIFnTaBg/EJjEhXNPm0Kzy8/j8lGGmFj?=
 =?us-ascii?Q?eJJI4+9L15g09Fe43LVJd/iZAb4CgVkcjcD1+M4op8b3zenfXWcTTz8I6TGD?=
 =?us-ascii?Q?NGs087+JDLaJp3DNk7WiSefoJosRwd+Dh+7ybgWs3xPI3KlZPcCfyRWzNYYm?=
 =?us-ascii?Q?P0cNQ8ya6O/l7aiom4RLCoVBz+tFbQgVWMu4kWRW7yzMaMOyKYUipF2DtseG?=
 =?us-ascii?Q?eqyhPUz47xOr81zFReJYXlak4wfczXSnNLWwJcJlYWeiavmi8TJMZzq9QbQG?=
 =?us-ascii?Q?RUz9pxr2Zo7VW9rCIPy87d2tMezN5sG04l9prlMLnGKkksQdFe2T/Im9IkxA?=
 =?us-ascii?Q?2Z3JXOEjg80ze/KKLMzl3TXy0+ed6Dzi9vmim0p1e9QaWyivC9yMvzaNdOtA?=
 =?us-ascii?Q?EdCH5WXj1OGmKZ0Iz9WHhrMmStWJXCdA/3nEi+r6lkzJzrJ2gEyLdWO0Lba9?=
 =?us-ascii?Q?URmgZD0cPWQ73QTnTef37TblnXnQnU4lb3Npmn0Wo4GaFqziy/+87eP8GjmN?=
 =?us-ascii?Q?5ipB04Zlu0PyjMxghiZQFHhzS1D0kQXGOwY51RtftG2D3d9q879zc8kJHpGL?=
 =?us-ascii?Q?tu+41Uqbi/UFtfId2ywKU6yhlU1pxcapJS3jRzkK+gG+QCSr5ujAEPWL7sOD?=
 =?us-ascii?Q?d4bWMAi8bhaIY1JQJlBmy1TpL7g3hw07XYJotnkP5q7n8Sq5UjSkGyynJN7B?=
 =?us-ascii?Q?GO6NCughJ6kZ78Q8G+Ywa2UO4v8qFUYcXeHIu8mbyJNu+eqzIji+XtA87chm?=
 =?us-ascii?Q?eA/I+GS0BR59q2X34tEifvHhLrKTRZsNKlTcvolDVfZopBQUvffAwY+CmLIF?=
 =?us-ascii?Q?eeW6GhNSB+M5xEiLJEC9J/KI4hjhd/MSA86iC2MOZnBFZfCgV15UJb6joD0W?=
 =?us-ascii?Q?RLTGV7ZE+s8GA7Zt5FprcA00YXDGLDyV3kfUlfswvPHYW/FPgMmUUI4D6XTJ?=
 =?us-ascii?Q?RmqDNG43WeZBTv6wEPP6fxheFtdJXNA2OO2YKXjhFVurSJO2o9S70uolALyl?=
 =?us-ascii?Q?rjVQntJnBRwInFl6dNzUIB4g0pNVzUAExDOsJOrzuPzKdmVuk4w6L1qT3WLN?=
 =?us-ascii?Q?GMK783RM7l32kpXfPkKkrcb5G1sv0EA+33zVCr+ImWCHLDjxRzW6tn6tDTeq?=
 =?us-ascii?Q?MLSmrtAbUBLaAPu+ahI768xxdTaRJdechaLr3WoWj7eQFxvLUuEcLAFKLEP4?=
 =?us-ascii?Q?A3kdtPhj5Xyxjam9LiqgVgKh0lCT/D1s5SyWdMRYzb91hYwcvRRk30R7V2rg?=
 =?us-ascii?Q?PNI4r0JNabb8M35NJp05ZerjO3R+hPFdFHC5XOQ6FnktwAuBt5NKMpugX8D1?=
 =?us-ascii?Q?1ha31Owo5lrPSbFAnovbldKarAVAUDgo2vlxZXBsbRyFt1j8kD6Zq4eTRZhL?=
 =?us-ascii?Q?pg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8F32EDF25F7E624F8AC22CCD68F99060@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0504e31-8992-4ac8-5b3e-08da5ab12ac4
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2022 15:56:59.9100
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TcREKIFaVae6xpJcgEl+xHPhoVn9d2HlDSWxjws+jHlqhEXyZE0u4ujSONIdtGAmLzDGDVe04ZtNOiLuq6rbQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5845
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Sean,

I am in the process of adding the necessary configuration for this
driver to work on a LS1088A based board. At the moment, I can see that
the lane's PLL is changed depending on the SFP module plugged, I have a
CDR lock but no PCS link.

I'll let you know when I get to the bottom of this.

I didn't go through the driver in detail but added some comments below.

On Tue, Jun 28, 2022 at 06:13:33PM -0400, Sean Anderson wrote:
> This adds support for the Lynx 10G "SerDes" devices found on various NXP
> QorIQ SoCs. There may be up to four SerDes devices on each SoC, each
> supporting up to eight lanes. Protocol support for each SerDes is highly
> heterogeneous, with each SoC typically having a totally different
> selection of supported protocols for each lane. Additionally, the SerDes
> devices on each SoC also have differing support. One SerDes will
> typically support Ethernet on most lanes, while the other will typically
> support PCIe on most lanes.
>=20

(...)

> +For example, the configuration for SerDes1 of the LS1046A is::
> +
> +    static const struct lynx_mode ls1046a_modes1[] =3D {
> +        CONF_SINGLE(1, PCIE, 0x0, 1, 0b001),
> +        CONF_1000BASEKX(0, 0x8, 0, 0b001),
> +        CONF_SGMII25KX(1, 0x8, 1, 0b001),
> +        CONF_SGMII25KX(2, 0x8, 2, 0b001),
> +        CONF_SGMII25KX(3, 0x8, 3, 0b001),
> +        CONF_SINGLE(1, QSGMII, 0x9, 2, 0b001),
> +        CONF_XFI(2, 0xB, 0, 0b010),
> +        CONF_XFI(3, 0xB, 1, 0b001),
> +    };
> +
> +    static const struct lynx_conf ls1046a_conf1 =3D {
> +        .modes =3D ls1046a_modes1,
> +        .mode_count =3D ARRAY_SIZE(ls1046a_modes1),
> +        .lanes =3D 4,
> +        .endian =3D REGMAP_ENDIAN_BIG,
> +    };
> +
> +There is an additional set of configuration for SerDes2, which supports =
a
> +different set of modes. Both configurations should be added to the match
> +table::
> +
> +    { .compatible =3D "fsl,ls1046-serdes-1", .data =3D &ls1046a_conf1 },
> +    { .compatible =3D "fsl,ls1046-serdes-2", .data =3D &ls1046a_conf2 },

I am not 100% sure that different compatible strings are needed for each
SerDes block. I know that in the 'supported SerDes options' tables only
a certain list of combinations are present, different for each block.
Even with this, I find it odd to believe that, for example, SerDes block
2 from LS1046A was instantiated so that it does not support any Ethernet
protocols.

I'll ask around to see if indeed this happens.

> +
> +Supporting Protocols
> +--------------------
> +
> +Each protocol is a combination of values which must be programmed into t=
he lane
> +registers. To add a new protocol, first add it to :c:type:`enum lynx_pro=
tocol
> +<lynx_protocol>`. If it is in ``UNSUPPORTED_PROTOS``, remove it. Add a n=
ew
> +entry to `lynx_proto_params`, and populate the appropriate fields. You m=
ay need
> +to add some new members to support new fields. Modify `lynx_lookup_proto=
` to
> +map the :c:type:`enum phy_mode <phy_mode>` to :c:type:`enum lynx_protoco=
l
> +<lynx_protocol>`. Ensure that :c:func:`lynx_proto_mode_mask` and
> +:c:func:`lynx_proto_mode_shift` have been updated with support for your
> +protocol.
> +
> +You may need to modify :c:func:`lynx_set_mode` in order to support your
> +procotol. This can happen when you have added members to :c:type:`struct
> +lynx_proto_params <lynx_proto_params>`. It can also happen if you have s=
pecific
> +clocking requirements, or protocol-specific registers to program.
> +
> +Internal API Reference
> +----------------------
> +
> +.. kernel-doc:: drivers/phy/freescale/phy-fsl-lynx-10g.c
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ca95b1833b97..ef65e2acdb48 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7977,6 +7977,12 @@ F:	drivers/ptp/ptp_qoriq.c
>  F:	drivers/ptp/ptp_qoriq_debugfs.c
>  F:	include/linux/fsl/ptp_qoriq.h
> =20
> +FREESCALE QORIQ SERDES DRIVER
> +M:	Sean Anderson <sean.anderson@seco.com>
> +S:	Maintained
> +F:	Documentation/driver-api/phy/qoriq.rst
> +F:	drivers/phy/freescale/phy-qoriq.c
> +

These file names have to be changed as well.

(...)

> +enum lynx_protocol {
> +	LYNX_PROTO_NONE =3D 0,
> +	LYNX_PROTO_SGMII,
> +	LYNX_PROTO_SGMII25,
> +	LYNX_PROTO_1000BASEKX,
> +	LYNX_PROTO_QSGMII,
> +	LYNX_PROTO_XFI,
> +	LYNX_PROTO_10GKR,
> +	LYNX_PROTO_PCIE, /* Not implemented */
> +	LYNX_PROTO_SATA, /* Not implemented */
> +	LYNX_PROTO_LAST,
> +};
> +
> +static const char lynx_proto_str[][16] =3D {
> +	[LYNX_PROTO_NONE] =3D "unknown",
> +	[LYNX_PROTO_SGMII] =3D "SGMII",
> +	[LYNX_PROTO_SGMII25] =3D "2.5G SGMII",
> +	[LYNX_PROTO_1000BASEKX] =3D "1000Base-KX",
> +	[LYNX_PROTO_QSGMII] =3D "QSGMII",
> +	[LYNX_PROTO_XFI] =3D "XFI",
> +	[LYNX_PROTO_10GKR] =3D "10GBase-KR",
> +	[LYNX_PROTO_PCIE] =3D "PCIe",
> +	[LYNX_PROTO_SATA] =3D "SATA",
> +};

> +
> +#define PROTO_MASK(proto) BIT(LYNX_PROTO_##proto)
> +#define UNSUPPORTED_PROTOS (PROTO_MASK(SATA) | PROTO_MASK(PCIE))

From what I know, -KX and -KR need software level link training.
Did you test these protocols?

I would be much more comfortable if we only add to the supported
protocols list what was tested.

(...)

> +	/* Deselect anything configured by the RCW/bootloader */
> +	for (i =3D 0; i < conf->mode_count; i++) {
> +		const struct lynx_mode *mode =3D &conf->modes[i];
> +		u32 pccr =3D lynx_read(serdes, PCCRn(mode->pccr));
> +
> +		if (lynx_proto_mode_get(mode, pccr) =3D=3D mode->cfg) {
> +			if (mode->protos & UNSUPPORTED_PROTOS) {
> +				/* Don't mess with modes we don't support */
> +				serdes->used_lanes |=3D mode->lanes;
> +				if (grabbed_clocks)
> +					continue;
> +
> +				grabbed_clocks =3D true;
> +				clk_prepare_enable(serdes->pll[0].hw.clk);
> +				clk_prepare_enable(serdes->pll[1].hw.clk);
> +				clk_rate_exclusive_get(serdes->pll[0].hw.clk);
> +				clk_rate_exclusive_get(serdes->pll[1].hw.clk);

Am I understanding correctly that if you encounter a protocol which is
not supported (PCIe, SATA) both PLLs will not be capable of changing,
right?

Why aren't you just getting exclusivity on the PLL that is actually used
by a lane configured with a protocol which the driver does not support?


> +			} else {
> +				/* Otherwise, clear out the existing config */
> +				pccr =3D lynx_proto_mode_prep(mode, pccr,
> +							    LYNX_PROTO_NONE);
> +				lynx_write(serdes, pccr, PCCRn(mode->pccr));
> +			}

Hmmm, do you need this?

Wouldn't it be better to just leave the lane untouched (as it was setup
by the RCW) just in case the lane is not requested by a consumer driver
but actually used in practice. I am referring to the case in which some
ethernet nodes have the 'phys' property, some don't.

If you really need this, maybe you can move it in the phy_init callback.

> +
> +			/* Disable the SGMII PCS until we're ready for it */
> +			if (mode->protos & LYNX_PROTO_SGMII) {
> +				u32 cr1;
> +
> +				cr1 =3D lynx_read(serdes, SGMIIaCR1(mode->idx));
> +				cr1 &=3D ~SGMIIaCR1_SGPCS_EN;
> +				lynx_write(serdes, cr1, SGMIIaCR1(mode->idx));
> +			}
> +		}
> +	}
> +
> +	/* Power off all lanes; used ones will be powered on later */
> +	for (i =3D 0; i < conf->lanes; i++)
> +		lynx_power_off_lane(serdes, i);

This means that you are powering-off any lane, PCIe/SATA lanes
which are not integrated with this driver at all, right?.
I don't think we want to break stuff that used to be working.

(...)

> +MODULE_DEVICE_TABLE(of, lynx_of_match);
> +
> +static struct platform_driver lynx_driver =3D {
> +	.probe =3D lynx_probe,
> +	.driver =3D {
> +		.name =3D "qoriq_serdes",

Please change the driver's name as well.

Ioana=
