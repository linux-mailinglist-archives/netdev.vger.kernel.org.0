Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99F73607919
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 16:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbiJUOCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 10:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231270AbiJUOCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 10:02:00 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2044.outbound.protection.outlook.com [40.107.21.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96192279D7D;
        Fri, 21 Oct 2022 07:01:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P76skoDwLMXIVimp+KkLr7BZQqCvrlcbGNuX1VesiR+mkiJ4zwKtyIoMQRFALi4rCw1/KjMjCEket+l43IxYpH79hAakpHwXirKLx0uyxjIkC/le/19ZsKbmQY+PvtMi0RwYrGy2CSPoxPd6uN5AN70ECvL7cjPTykEfA+aCTVjkXq7X5Z/eR9oaaoDjeTCCVcjGfBFtF4seuacZo8W9LMw9XGSu4Pgqgnc0umvUzK4VlFN037AhSkExDRlLhGI9uUiTB2fQBJQEQzcUfTfyJlHfyzgoz7QoflVD8PhvL6TXGYeD3rDUQ5hHpPYZ/TAtf1AlqM6PtYz9Ku+6D2qqvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iAbQ5VYuaNWNsoJl55nUYoIB1/1losWLUSYOsm+hwTU=;
 b=aaiGcNEPkk6yY7CFvAes1nmzoAcIvZVcWFqjq2wasWWElt76bgrB3sbwXk8txWNqj76ShlI/kqFZJZgPYkeqE0CV/kc2yN6ZyUjmJpkh6W2lKZqq+zte6tiJ24Isd7OL7AYrBVFghU+EHiVMS5Xo0njOYW90MSqQp1Vt3sirn6a1Nmgb2vLf1iNo1EdW9yGcJZYn1j3+xbTjbgCYNFfR7BCvUYfP+LBaF6pXPv7cqrJTUJLva/Q8UWituWjMnH3Sjw7C2cFNrMIgZrBP8cBznAicPHeT4e2zZiW1daRX3P3nm1kYusBdyy/RO0yucvRTUFyZs9Cx4fwzeHXYaTsO3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iAbQ5VYuaNWNsoJl55nUYoIB1/1losWLUSYOsm+hwTU=;
 b=GP2xTRHxbVwHnI0esqDRvUg7FlXnHfwFpSFCYQXPfPJwNe+GHQ/fVexWxuO55HuAJV0ZC3lh4o8Z+Yyj4HAcDnBEsw3eur9UzA/p4t+2DVxAzUeNzSmQz02eNEZEdKBTQ7bn0Ofce8q/NoeuCwNmvhjpOs1ETK2bEW5hlZ/eVT4=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB9110.eurprd04.prod.outlook.com (2603:10a6:20b:449::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Fri, 21 Oct
 2022 14:01:52 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5723.035; Fri, 21 Oct 2022
 14:01:52 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v5 3/5] net: dsa: add out-of-band tagging
 protocol
Thread-Topic: [PATCH net-next v5 3/5] net: dsa: add out-of-band tagging
 protocol
Thread-Index: AQHY5UsWSYHOWMzUAEio8TPArqgrBw==
Date:   Fri, 21 Oct 2022 14:01:52 +0000
Message-ID: <20221021140151.js2n6yvzs4nbpvrj@skbuf>
References: <20221021124556.100445-1-maxime.chevallier@bootlin.com>
 <20221021124556.100445-1-maxime.chevallier@bootlin.com>
 <20221021124556.100445-4-maxime.chevallier@bootlin.com>
 <20221021124556.100445-4-maxime.chevallier@bootlin.com>
In-Reply-To: <20221021124556.100445-4-maxime.chevallier@bootlin.com>
 <20221021124556.100445-4-maxime.chevallier@bootlin.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AS8PR04MB9110:EE_
x-ms-office365-filtering-correlation-id: 59f250e4-170f-42d7-f5f8-08dab36cce22
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mn2lfdQOQBsotVujfemtjVdswKNcw9mRAYXRifIkMWPIgiYlYOUvwxmHq+5ZEFYExZMBPJiGEwRXtEpM2nu8Fu3K55p9pmu0iqNeJBTM9OO3PAguwIYWmnSYY1fckXl6Qrv4tE+zGjIkjk3rwCOg61hPPZGhSP3gkDKKdQCrZE2Fp8UJKzb4u0wiHP6RG27x9nFw85NBtC1vCR0ekIumVO6XKRFg1cvnXm7tukdoUxIOnoXDnFYBkh+PIMtr7Jw9qXcGgq2B2iJ9JI2Vf6BmXdP/XTIBZnJZ0GmIyxQSdQztoVmhzC1+OjYPrMNyomZl0/2RzYHQ3DpzgTtcalnPnyLhy3t8xqAWGzJAMUEqwyqAt/HMtF05sNcHdo/olR3jd3/WXZiHqMTAzAiFPsuKJD1a1QpIsGEHSUTvm9Tx/8uw5zJ0GEY4yk6M3/NOj+ckzrpTis/iWy2Y0xavFNjxjxK6rmEJuSf7FQyOTg5SU1IOmmjkLkFzZQ59GDQuUPgeenDgEl/jRrj5fckpoXWdXXBzylCi+RYGRhiQXijLl2pk+zGv88Nkv/IgY7yU7jr4MM/4K1EWi85E0ZfHuAirrSFhewptsmNE0nRfPvsNDWJFT4gT6s1ieme/6M9z9eYeiSJhGUOAD0BPMTdW5C9hhAQzHuYSleHIANi6lKnDD7oXgZDwRkko8+Ns7lzJPkTEm5Fz2Lad2+HDt6U4pebF/RPiEYQ80idP/MhB8xrprSqGwCfkNEsc4VaRcNe6FWeclXvs6gmQ6hcsKUpjegLQGQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(39860400002)(136003)(366004)(376002)(396003)(346002)(451199015)(8676002)(4326008)(26005)(186003)(38070700005)(122000001)(7416002)(83380400001)(54906003)(38100700002)(5660300002)(44832011)(1076003)(6916009)(41300700001)(64756008)(8936002)(66556008)(6486002)(6506007)(6512007)(316002)(66446008)(478600001)(33716001)(66946007)(66476007)(86362001)(9686003)(76116006)(71200400001)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?dybUNGa3p8zMtZXTOr2H25ynatd6xFxvzAvvqqh2vytJIi/m368iXJAvJhnW?=
 =?us-ascii?Q?LaFz1tWKTgxazh8ttCUifxDHafAsnQoqhahKNefoBeGGppb70G9unWF3gEk1?=
 =?us-ascii?Q?f+92piS3ZU5+64JDFUZ4EYJvR912mfaAOG5Ww6Wphhll6AjZCT4tqduK5KiA?=
 =?us-ascii?Q?ODvUwSBfTHB44ZQhDMvlOvTDj0iCwC8cRaeggeB5PTOA6D4uflDo1AiYEroJ?=
 =?us-ascii?Q?ISBRgSjwYZDi6Vwck8lyICYmlvbJdk1z+T+GCNV46/djJ2gJYzKXQmSOaYvr?=
 =?us-ascii?Q?IKepBZ3SA/y5xRdGR1ks6ycLTAMKGfHeSEuPGaO3JAXGqOUB1jvB5L3QW3Kb?=
 =?us-ascii?Q?JSUYlvKbcCsr5ZOw6GurPHRay1jyQIuJACyWMo1NjiRbkIyMBI1eDT5tdXvD?=
 =?us-ascii?Q?2LJEKHXJN9oO60QVjj4S2HpxciD5TY/YHmGc5Hnz8pTNPq2NMGAm+a7QGz28?=
 =?us-ascii?Q?x9Qr1O3MixzpCgySxr8i7P6jXTZPKvs30HfkveLjPQ1PX+PrrumQR7wnBYJu?=
 =?us-ascii?Q?pLQULUtmDYYvjUVCaTy0C1olIfiScyFDfU+MUCBCDAHrHbKUUzi665J8LSiq?=
 =?us-ascii?Q?m3uAeGkg0fwF/3tPe4C82HwrAq5pSSVw7PDDOQYD6jI+WSmCqlp5L5GVRlCs?=
 =?us-ascii?Q?D90UdkmvAz7KvuNCiBFpTabljGz2rEEpuROmGF/i8wpil0Dv5dZxX0js0hRR?=
 =?us-ascii?Q?5reSlfuLRFzKnVOoHBHxbyXk8VgtARnehOqHzFWmoXekPSnfQjhLB+3M8xw9?=
 =?us-ascii?Q?RbHipSjlqjrXlNsVqeQTbmhQktk/0mdtkwBzUepMqC1EEjUKBYgyTeTneDLU?=
 =?us-ascii?Q?caSa6CiI7M08lKFAhHc3c8bN7ikRMm8rs3cceEV9rwBuh2giQ3KAiebqs7h3?=
 =?us-ascii?Q?TrCrkki3aTg42ED6m4jgtxyAOXxLUyzTU6/iA7Owg8IxenaRQbsv2hj3u/pP?=
 =?us-ascii?Q?3S07yLzsdBFcRVlwer6BmXNn0gqek43u5RYacNmclZj4rCck5qBrZe6wPtjD?=
 =?us-ascii?Q?AQ//9V6H/ufEPIsM+GmoohZqrFxZJeiNyHENHom5i3U0t9bTp/saxMDCKj3D?=
 =?us-ascii?Q?ekQWefs06VYnb7IEoLQ2vAA6NWK3c/MkH7PrOpPRFi44n54dfMu8hpOlKT4l?=
 =?us-ascii?Q?A74zodX81Ea/OdM4DMK19PaERFIP4uN68fJt8VmbOnBatEOIfwuHtuCMa65B?=
 =?us-ascii?Q?DCEHOrdRZKMD/6Zen33Ky3KRRT1YaNt2PRvvCKxeVYG/4uf4Aws6xn1926bk?=
 =?us-ascii?Q?YIdxI1htLpDh61+OhrRkVWzDrUQnLP8iK0UzKaWgQ6hTOYYMMnx/zy6YYil+?=
 =?us-ascii?Q?gTR+x4kBV94G++6qiFmWKIQr3csWBfuN3uC7J2dWP97Z+22KapRr5dmN+TSY?=
 =?us-ascii?Q?JlGKHh1OvKyv2aGCarWbHv/obMOUDQ3U3gtPak6NrF4d/hVeR54nlHLJkJKG?=
 =?us-ascii?Q?I5wLvS4ksF/ybVNaOQn/310cyCrtJDtFibohFR23UavZ7MNjMOEYpDUlIbo/?=
 =?us-ascii?Q?6AWlagYE0WDNCYvomCzUk0GikpWCwgHZfYraAx7dw8E4gLU0/qhZ+I11nOLg?=
 =?us-ascii?Q?uNXidVN5XGTBdz+xGwAkzZnFRL0DnAEtevVK6YjPr1dQK7qJ4x2X+ZkV5PWR?=
 =?us-ascii?Q?6Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9CDF02B308966946852681845731163B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59f250e4-170f-42d7-f5f8-08dab36cce22
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2022 14:01:52.2115
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gYvS3Yg2/lJdVrh+2+XCSsm9DV7yFHrTT5b2XKzvIfSHhvfc7dG9OevcOa3RiUAn1mjA+OzIhKRextwhWd7kbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB9110
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 21, 2022 at 02:45:54PM +0200, Maxime Chevallier wrote:
> This tagging protocol is designed for the situation where the link
> between the MAC and the Switch is designed such that the Destination
> Port, which is usually embedded in some part of the Ethernet Header, is
> sent out-of-band, and isn't present at all in the Ethernet frame.
>=20
> This can happen when the MAC and Switch are tightly integrated on an
> SoC, as is the case with the Qualcomm IPQ4019 for example, where the DSA
> tag is inserted directly into the DMA descriptors. In that case,
> the MAC driver is responsible for sending the tag to the switch using
> the out-of-band medium. To do so, the MAC driver needs to have the
> information of the destination port for that skb.
>=20
> Add a new tagging protocol based on SKB extensions to convey the
> information about the destination port to the MAC driver
>=20
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> ---
> V4->V5
>  - Use SKB extensions to convey the tag
> V3->V4=20
>  - No changes
> V3->V2:
>  - No changes, as the discussion is ongoing
> V1->V2:
>  - Reworked the tagging method, putting the tag at skb->head instead
>    of putting it into skb->shinfo, as per Andrew, Florian and Vlad's
>    reviews
>=20
>  include/linux/dsa/oob.h | 17 +++++++++
>  include/linux/skbuff.h  |  3 ++
>  include/net/dsa.h       |  2 ++
>  net/core/skbuff.c       | 10 ++++++
>  net/dsa/Kconfig         |  8 +++++
>  net/dsa/Makefile        |  1 +
>  net/dsa/tag_oob.c       | 80 +++++++++++++++++++++++++++++++++++++++++
>  7 files changed, 121 insertions(+)
>  create mode 100644 include/linux/dsa/oob.h
>  create mode 100644 net/dsa/tag_oob.c
>=20
> diff --git a/include/linux/dsa/oob.h b/include/linux/dsa/oob.h
> new file mode 100644
> index 000000000000..dbb4a6fb1ce4
> --- /dev/null
> +++ b/include/linux/dsa/oob.h
> @@ -0,0 +1,17 @@
> +/* SPDX-License-Identifier: GPL-2.0-only
> + * Copyright (C) 2022 Maxime Chevallier <maxime.chevallier@bootlin.com>
> + */
> +
> +#ifndef _NET_DSA_OOB_H
> +#define _NET_DSA_OOB_H
> +
> +#include <linux/skbuff.h>
> +
> +struct dsa_oob_tag_info {
> +	u16 proto;

Not needed / not used, please remove.

> +	u16 dp;

Could you please rename "dp" into "port"? The naming convention is that
variables named "dp" have the type "struct dsa_port *".

> +};
> +
> +int dsa_oob_tag_push(struct sk_buff *skb, struct dsa_oob_tag_info *ti);
> +int dsa_oob_tag_pop(struct sk_buff *skb, struct dsa_oob_tag_info *ti);
> +#endif
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 9fcf534f2d92..e387d6795919 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -4571,6 +4571,9 @@ enum skb_ext_id {
>  #endif
>  #if IS_ENABLED(CONFIG_MCTP_FLOWS)
>  	SKB_EXT_MCTP,
> +#endif
> +#if IS_ENABLED(CONFIG_NET_DSA_TAG_OOB)
> +	SKB_EXT_DSA_OOB,
>  #endif
>  	SKB_EXT_NUM, /* must be last */
>  };
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index ee369670e20e..114176efacc9 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -55,6 +55,7 @@ struct phylink_link_state;
>  #define DSA_TAG_PROTO_RTL8_4T_VALUE		25
>  #define DSA_TAG_PROTO_RZN1_A5PSW_VALUE		26
>  #define DSA_TAG_PROTO_LAN937X_VALUE		27
> +#define DSA_TAG_PROTO_OOB_VALUE			28
> =20
>  enum dsa_tag_protocol {
>  	DSA_TAG_PROTO_NONE		=3D DSA_TAG_PROTO_NONE_VALUE,
> @@ -85,6 +86,7 @@ enum dsa_tag_protocol {
>  	DSA_TAG_PROTO_RTL8_4T		=3D DSA_TAG_PROTO_RTL8_4T_VALUE,
>  	DSA_TAG_PROTO_RZN1_A5PSW	=3D DSA_TAG_PROTO_RZN1_A5PSW_VALUE,
>  	DSA_TAG_PROTO_LAN937X		=3D DSA_TAG_PROTO_LAN937X_VALUE,
> +	DSA_TAG_PROTO_OOB		=3D DSA_TAG_PROTO_OOB_VALUE,
>  };
> =20
>  struct dsa_switch;
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 1d9719e72f9d..627b0b9c0b23 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -61,8 +61,12 @@
>  #include <linux/if_vlan.h>
>  #include <linux/mpls.h>
>  #include <linux/kcov.h>
> +#ifdef CONFIG_NET_DSA_TAG_OOB
> +#include <linux/dsa/oob.h>
> +#endif
> =20
>  #include <net/protocol.h>
> +#include <net/dsa.h>
>  #include <net/dst.h>
>  #include <net/sock.h>
>  #include <net/checksum.h>
> @@ -4474,6 +4478,9 @@ static const u8 skb_ext_type_len[] =3D {
>  #if IS_ENABLED(CONFIG_MCTP_FLOWS)
>  	[SKB_EXT_MCTP] =3D SKB_EXT_CHUNKSIZEOF(struct mctp_flow),
>  #endif
> +#if IS_ENABLED(CONFIG_NET_DSA_TAG_OOB)
> +	[SKB_EXT_DSA_OOB] =3D SKB_EXT_CHUNKSIZEOF(struct dsa_oob_tag_info),
> +#endif
>  };
> =20
>  static __always_inline unsigned int skb_ext_total_length(void)
> @@ -4493,6 +4500,9 @@ static __always_inline unsigned int skb_ext_total_l=
ength(void)
>  #endif
>  #if IS_ENABLED(CONFIG_MCTP_FLOWS)
>  		skb_ext_type_len[SKB_EXT_MCTP] +
> +#endif
> +#if IS_ENABLED(CONFIG_NET_DSA_TAG_OOB)
> +		skb_ext_type_len[SKB_EXT_DSA_OOB] +
>  #endif
>  		0;
>  }
> diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
> index 3eef72ce99a4..c50508e9f636 100644
> --- a/net/dsa/Kconfig
> +++ b/net/dsa/Kconfig
> @@ -57,6 +57,14 @@ config NET_DSA_TAG_HELLCREEK
>  	  Say Y or M if you want to enable support for tagging frames
>  	  for the Hirschmann Hellcreek TSN switches.
> =20
> +config NET_DSA_TAG_OOB
> +	select SKB_EXTENSIONS
> +	tristate "Tag driver for Out-of-band tagging drivers"
> +	help
> +	  Say Y or M if you want to enable support for tagging out-of-band. In
> +	  that case, the MAC driver becomes responsible for sending the tag to
> +	  the switch, outside the inband data.

I suppose at some point you should clarify what this "band" really is.
How about:

	  Say Y or M if you want to enable support for pairs of embedded
	  switches and host MAC drivers which perform demultiplexing and
	  packet steering to ports using out of band metadata processed
	  by the DSA master, rather than tags present in the packets.

Could you also update Documentation/networking/dsa/dsa.rst (the section
"Switch tagging protocols") with some information about how this works?

DSA tags generally support stacking (i.e. a DSA switch port can be a
master for another DSA switch, and so on). Every switch along the path
inserts/extracts its own tag where it expects it to be, and the packet
is steered through all switches in the hierarchy.

It would be good to mention what is the situation with tag stacking when
NET_DSA_TAG_OOB is used. I suppose multiple oob tags don't make sense
for the same skb, and if oob tags are used, they are always for the
switches within the top-most tree. Beyond that, other DSA tags could
still be present in the skb, for downstream switches?

> +
>  config NET_DSA_TAG_GSWIP
>  	tristate "Tag driver for Lantiq / Intel GSWIP switches"
>  	help
> diff --git a/net/dsa/Makefile b/net/dsa/Makefile
> index bf57ef3bce2a..fff657064be4 100644
> --- a/net/dsa/Makefile
> +++ b/net/dsa/Makefile
> @@ -17,6 +17,7 @@ obj-$(CONFIG_NET_DSA_TAG_BRCM_COMMON) +=3D tag_brcm.o
>  obj-$(CONFIG_NET_DSA_TAG_DSA_COMMON) +=3D tag_dsa.o
>  obj-$(CONFIG_NET_DSA_TAG_GSWIP) +=3D tag_gswip.o
>  obj-$(CONFIG_NET_DSA_TAG_HELLCREEK) +=3D tag_hellcreek.o
> +obj-$(CONFIG_NET_DSA_TAG_OOB) +=3D tag_oob.o

Alphabetic ordering please. Same for the Kconfig entry too, probably.

>  obj-$(CONFIG_NET_DSA_TAG_KSZ) +=3D tag_ksz.o
>  obj-$(CONFIG_NET_DSA_TAG_LAN9303) +=3D tag_lan9303.o
>  obj-$(CONFIG_NET_DSA_TAG_MTK) +=3D tag_mtk.o
> diff --git a/net/dsa/tag_oob.c b/net/dsa/tag_oob.c
> new file mode 100644
> index 000000000000..f8fba8406307
> --- /dev/null
> +++ b/net/dsa/tag_oob.c
> @@ -0,0 +1,80 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +/* Copyright (c) 2022, Maxime Chevallier <maxime.chevallier@bootlin.com>=
 */
> +
> +#include <linux/bitfield.h>

not needed

> +#include <linux/dsa/oob.h>
> +#include <linux/skbuff.h>
> +
> +#include "dsa_priv.h"
> +
> +#define DSA_OOB_TAG_LEN 4

Not used.

> +
> +int dsa_oob_tag_push(struct sk_buff *skb, struct dsa_oob_tag_info *ti)

const struct dsa_oob_tag_info *

> +{
> +	struct dsa_oob_tag_info *tag_info;
> +
> +	tag_info =3D skb_ext_add(skb, SKB_EXT_DSA_OOB);

skb_ext_add() can return NULL. The return code for this function is not
really adequate.

> +
> +	tag_info->dp =3D ti->dp;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(dsa_oob_tag_push);
> +
> +int dsa_oob_tag_pop(struct sk_buff *skb, struct dsa_oob_tag_info *ti)
> +{
> +	struct dsa_oob_tag_info *tag_info;
> +
> +	tag_info =3D skb_ext_find(skb, SKB_EXT_DSA_OOB);
> +	if (!tag_info)
> +		return -EINVAL;
> +
> +	ti->dp =3D tag_info->dp;

The function doesn't really "pop" it, despite the name (not clear if
that's even necessary). If we keep the extension in place, can we just
return a pointer to it, rather than make a copy on stack?

> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(dsa_oob_tag_pop);

I think these 2 functions can be made "static inline" in <linux/dsa/oob.h>
and this could avoid depending on net/dsa/tag_oob.ko for their other
callers?

> +
> +static struct sk_buff *oob_tag_xmit(struct sk_buff *skb,
> +				    struct net_device *dev)
> +{
> +	struct dsa_port *dp =3D dsa_slave_to_port(dev);
> +	struct dsa_oob_tag_info tag_info;
> +
> +	tag_info.dp =3D dp->index;

I would prefer a definition like this:

	struct dsa_oob_tag_info tag_info =3D {
		.port =3D dp->index,
	};

here and everywhere else, because if new fields are added to the
structure and are not explicitly present in this initializer, they will
get initialized with zeroes rather than on-stack garbage.

> +
> +	if (dsa_oob_tag_push(skb, &tag_info))
> +		return NULL;
> +
> +	return skb;
> +}
> +
> +static struct sk_buff *oob_tag_rcv(struct sk_buff *skb,
> +				   struct net_device *dev)
> +{
> +	struct dsa_oob_tag_info tag_info;
> +
> +	if (dsa_oob_tag_pop(skb, &tag_info))
> +		return NULL;
> +
> +	skb->dev =3D dsa_master_find_slave(dev, 0, tag_info.dp);
> +	if (!skb->dev)
> +		return NULL;
> +
> +	return skb;
> +}
> +
> +const struct dsa_device_ops oob_tag_dsa_ops =3D {
> +	.name	=3D "oob",
> +	.proto	=3D DSA_TAG_PROTO_OOB,
> +	.xmit	=3D oob_tag_xmit,
> +	.rcv	=3D oob_tag_rcv,
> +};
> +
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("DSA tag driver for out-of-band tagging");
> +MODULE_AUTHOR("Maxime Chevallier <maxime.chevallier@bootlin.com>");
> +MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_OOB);
> +
> +module_dsa_tag_driver(oob_tag_dsa_ops);
> --=20
> 2.37.3
>=
