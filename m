Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B67C6611784
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 18:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbiJ1Qaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 12:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiJ1Qa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 12:30:28 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2069.outbound.protection.outlook.com [40.107.22.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8811E753A8;
        Fri, 28 Oct 2022 09:30:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dH9azIbVaQNdmvnodLr70sLzjb0COUbsuE9fklQLrsHMPq8gDyeihHWiSgAbCdvPtfp5J8acKmS1Pk5WZ49S+HVeGc4RxHkqLHfp7mREiePlHvNrHrolH8NEm9BRN1LjwSPTwcpYwBU8y35zED6aqEttarA9rOFo9uPcSTlLHviEHP7dnABXBWxxJFnRZmAKFWIuEop0t057BPeOsEgg9yxKR1y/rZOpZRHjobQa6AjkPipNEqC+d+fEICtvCC0pZWoTNuZvXP6sPDczRH+aMGgJ/fiioHG3mIrpxgiZ3ZqaGAGH8Hy+n4IrveOGdKnLeOB+5WgFsk3/j+dYY8vAbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WCiH4tpy5XEQqQRg88oKAKXMbiD88c8QSLeIANmqp+M=;
 b=fDZjDHndb0Qo2CAtIy93MP28mLWAjSiKdnqGSIhOcHT9CtWE1FQepqa4A0V4ZpAn9SGc6df0YZHF5pxx6uym09lMS/rwshzzcfLN7t/hf0kPhnCd8uRB0C6q2emvMDNNN6wt8seSELcLJprCp/e3wMrrt4vrYEVgzXl4uM/9ADx2dKJ5hrjibQG4M3oSCCAFlO6q1xjrV+7C0Sb9TLE2nElw7eAaO7obEOrXeyHPhXuxRs+pPYs+5uaSJJG5lh0cz9Z0A7g4h1i9wGBAciELWKn5DMneT4OMIWFJfEcpB5BaHyuVuKvHWcT1DqzC4k51iL7U3DuQYW/r55ttvW2cOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WCiH4tpy5XEQqQRg88oKAKXMbiD88c8QSLeIANmqp+M=;
 b=Hqro6K7PN8Wfq7c9Q9/N+5qjviFex5WZUaaTT29mkeraifHjWFg9HvT0fYA3Dm+D/y0YmsPAd8UOzOAlpo2ybXzjjFWlUbrG3Hy4/Mm2MO7KG4WqtFw1jovgyUdcCIMbdmaEanlg/jIL5g0LN/wMr9ETe89w6yCMDr4ql4FqRfI=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by PAXPR04MB8157.eurprd04.prod.outlook.com (2603:10a6:102:1cf::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Fri, 28 Oct
 2022 16:30:21 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::6bd6:8137:61db:6d3b]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::6bd6:8137:61db:6d3b%4]) with mapi id 15.20.5746.021; Fri, 28 Oct 2022
 16:30:21 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Eric Dumazet <edumazet@google.com>,
        "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Leo Li <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCH net-next v7 08/10] powerpc: dts: t208x: Mark MAC1 and MAC2
 as 10G
Thread-Topic: [PATCH net-next v7 08/10] powerpc: dts: t208x: Mark MAC1 and
 MAC2 as 10G
Thread-Index: AQHY4mZVM2/wD5sz80qraMJF5926A64kC8Mw
Date:   Fri, 28 Oct 2022 16:30:21 +0000
Message-ID: <VI1PR04MB580721D3F8DFC5C1BCAC6FC7F2329@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <20221017202241.1741671-1-sean.anderson@seco.com>
 <20221017202241.1741671-9-sean.anderson@seco.com>
In-Reply-To: <20221017202241.1741671-9-sean.anderson@seco.com>
Accept-Language: en-GB, ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5807:EE_|PAXPR04MB8157:EE_
x-ms-office365-filtering-correlation-id: 9ec44e36-f601-42e2-d96e-08dab901b545
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wdv8aD8263/wKf5oljYeKK/jLg69QlS38aJrHpuWe4QEfLI1BNNavW1SY+jLxNi1YEmmLBseROKCBOsjxhmqQUN8NukbMQkw9Q+szpmq58OvFIkmLbVsBa0ErYq/3NcwCrX7dt7gksCBm8Tzds/125Yk5kcgpwTPyL58NmhYR/xi1ZDYnFcVFDcArSjEYybyrZ1/EiXsXzH39tWyjZcyq1EzywjYZRg+CH0K/HHU4liLc9R+ezHYPZhIn4Vtw7dqS1c3t87OSE/7kkOGI4mL8ozQWvRWbBv1VPaxdGYnKFgeYocjsPffsnUDcCgx4S/azDrvfvnvzKx/+xOJ9UXfG3NgU74KZGKOHBvAO7cbWGKvyLf7xwLt7wjHHo8/QpQ3A2r9CZZFpXciabx4KhSUEcSQuQPXzkxuUxL6NlB60Rda5E5lDChw6AK8lfYOUI/49HZpol3JpIv3AaY5KhNLVNxsksaFFMjoLs/ncaBIk7NOfo0/NtRzLL7rPSUmDpC955976eFSdB9Ev2FhpAtueKrkmRklaXrpnjiOCeSzIHXk7lAUJItYmHZ8zLPZl3AxAStqD1EzR3Yybu2PDVgZsbb6Ewi9xNX03xRZDDVDbsq7j1kFWB2R6pwgAqO6YwtYK2xZaScQ85fXVILqAKdriEPXrWJ2kk31gDFPUR7CmT20szkVjHQibjTmXjUyBO6C9DANghokX9mvT1Teo/QRC9yjuVn8HvjnNQaaiaL+Mq4qnU5DTJVLRwT+hPC8M4rIy8vbUSgIs1UKv1w0SknB7w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(366004)(136003)(346002)(451199015)(9686003)(26005)(478600001)(55236004)(83380400001)(53546011)(7696005)(6506007)(186003)(2906002)(55016003)(316002)(54906003)(52536014)(66446008)(71200400001)(66946007)(110136005)(66556008)(8936002)(76116006)(5660300002)(41300700001)(4326008)(8676002)(64756008)(66476007)(7416002)(86362001)(33656002)(38100700002)(38070700005)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?J63bXAYac8FFNyJGa1boCrrfdicL9C2DyWuIAi2twSf0Po/k/r5QT2Tjvx3H?=
 =?us-ascii?Q?aPj50saGFHgyq6gNk70YS/BIcGQripwCjHpxsHzlQSra//itg6nWVr21f+H1?=
 =?us-ascii?Q?cHgAC8GUmT4zS8cs9KLA8+I2dP4D5Hzo8f+WXxH0J0ZVaEO5jHAW/GnJtAR0?=
 =?us-ascii?Q?zNXvQERBf795sMYOR88MPBOruSiM/Z8HUpBKpKr1mzWDb+ZhHCbZeLGx7DEq?=
 =?us-ascii?Q?QwVlPrZeL2CZvVvVjAV5NfrLsiW47Nc/IIVzTPKvPDjvudvK/jnPj2IZ+YA2?=
 =?us-ascii?Q?AONvJc2BApS51YitcMqO610H0DWFADfzQSVpxij4W+1GOdt2LZ5BpA0cO9KR?=
 =?us-ascii?Q?XvTuStPGrVYsKzUNaAdbL9Rrynh5LCZN62Y50STyiNv3qy4/uJeDPywi3U3t?=
 =?us-ascii?Q?GPUIGiooPSJTXxf0v6UfK+L2q67ywpID+Bk4LgTeUOG7HUu3tdTJpjjT+mI+?=
 =?us-ascii?Q?DKugLqFG22yINXsAL9sCMSmPvO9+3tlV0QQ+EYnj90p87nu6nnQhU1xk5Mal?=
 =?us-ascii?Q?FdSRHyJOAlbw5DGWC4vV7c4CdmQwsVqMfjoV5rms12ot3SjY8wZrhb7f7PxY?=
 =?us-ascii?Q?FA+VAlAjRy5okyDSzl+h7rauuS34wQDGYqG/sohcnOFemqcqOkfAT7NkU/EV?=
 =?us-ascii?Q?9Gm+teuyObnl9Uw+FzLnrwBhKNHjY92yJzJIrX4h9m9r4uQ1EKmWk96Q8fqp?=
 =?us-ascii?Q?5kWQiZOSxRceN5bm9D00tv1c9aIMFo+WMrw3rOF+fPAOiREGAIUtjVRC5qe4?=
 =?us-ascii?Q?H9v83isZ66lMtheuF8tu/trx7RkR0+FcpCS6KALpqm9T/rPWWh5k0NcBUip9?=
 =?us-ascii?Q?0wcvLs+mVjQastNMctPMlxjqBx1Eou/tdVYoJK/uEyXWRBzXCP4GjRGEgG9c?=
 =?us-ascii?Q?78MvfOlwaeTPMAPXvyLAg+QHiShELRGsbFWBofKknMzJjgzJgSKi5Vsl0+ye?=
 =?us-ascii?Q?UfywuqntgWOjurLZ6VmFL2jFKPyyzJW+h91dqNv1Xvn+4Mb7KadI+EPPqDW0?=
 =?us-ascii?Q?F+cxwq85Ia04cwht9nsW2rJQccKyzrn/kIXF/2PlCfm4QLk18P3A8GmP/vFs?=
 =?us-ascii?Q?sLo1BF+Ozd92eZVCIRZ2lnnxS2P17n0yjy4zFYjOvc/0NthAL6Q/cJtbv/jz?=
 =?us-ascii?Q?SVu7Uf6sbX0aoB5Dl4Oyimvee0W4Y1gdZZFTt0TXoAgVMeZZ8x2A+0knSRoW?=
 =?us-ascii?Q?x+k4CpOPpJug+9AHfcfHkXEbD0jCKIiSEvD7lM6rVPdF/jcAw0L74HcMrx8X?=
 =?us-ascii?Q?L/gU7lbw+0vuzzK4a7pgr/uXBptIAtNCFVjJlUBKgRQedMqKZ46Jq0N2Z7LQ?=
 =?us-ascii?Q?/582luXqa5AeYAjqurhEt6181CsdqEra/nCdvtRYg0/qakScDsTGeMHMWl8U?=
 =?us-ascii?Q?OZB1MN9d4p16W91LLlNuDerITeO+1rpRtUNEEpX6R5A2MwWYwxHhNJqnBVii?=
 =?us-ascii?Q?VsV28QNVKoMcWqQQF7ojxORb/na7AsrYsuMoJbouWqAEyXJgmxiXoIDXqLHg?=
 =?us-ascii?Q?QNf+a1+rFDC7t+xW0vxDVhtS7Irw8554vCrmkVPajjOQPr/yXSKrzQqMPjTs?=
 =?us-ascii?Q?gSwlLv9bNbZW4TbRQZCrn/NfZ1I5Uu3KGdYkuxEv?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ec44e36-f601-42e2-d96e-08dab901b545
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2022 16:30:21.3393
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WldzADb6pUJEJCHel4YOXz1wbUvEvdtnd92DDK6SvtISSlBD3jaKzPkWBOy1aBUMn67tZsLFqczrwDG9A5oMDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8157
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Sean Anderson <sean.anderson@seco.com>
> Sent: Monday, October 17, 2022 23:23
> To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
> <kuba@kernel.org>; Madalin Bucur <madalin.bucur@nxp.com>; Camelia
> Alexandra Groza <camelia.groza@nxp.com>; netdev@vger.kernel.org
> Cc: Eric Dumazet <edumazet@google.com>; linuxppc-dev @ lists . ozlabs .
> org <linuxppc-dev@lists.ozlabs.org>; linux-arm-kernel@lists.infradead.org=
;
> linux-kernel@vger.kernel.org; Russell King <linux@armlinux.org.uk>; Paolo
> Abeni <pabeni@redhat.com>; Sean Anderson <sean.anderson@seco.com>;
> Benjamin Herrenschmidt <benh@kernel.crashing.org>; Krzysztof Kozlowski
> <krzysztof.kozlowski+dt@linaro.org>; Leo Li <leoyang.li@nxp.com>; Michael
> Ellerman <mpe@ellerman.id.au>; Paul Mackerras <paulus@samba.org>; Rob
> Herring <robh+dt@kernel.org>; devicetree@vger.kernel.org
> Subject: [PATCH net-next v7 08/10] powerpc: dts: t208x: Mark MAC1 and
> MAC2 as 10G
>=20
> On the T208X SoCs, MAC1 and MAC2 support XGMII. Add some new MAC
> dtsi
> fragments, and mark the QMAN ports as 10G.
>=20
> Fixes: da414bb923d9 ("powerpc/mpc85xx: Add FSL QorIQ DPAA FMan
> support to the SoC device tree(s)")
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
>=20
> (no changes since v4)
>=20
> Changes in v4:
> - New

Hi Sean,

These changes prevent MAC2 from probing on T2080RDB due to insufficient FMa=
n hardware resources.

fsl-fman ffe400000.fman: set_num_of_tasks: Requested num_of_tasks and extra=
 tasks pool for fm0 exceed total num_of_tasks.
fsl_dpa: dpaa_eth_init_tx_port: fm_port_init failed
fsl_dpa: probe of dpaa-ethernet.5 failed with error -11

The distribution of resources depends on the port type, and different FMan =
hardware revisions have different amounts of resources.

The current distribution of resources can be reconsidered, but this change =
should be reverted for now.

Regards,
Camelia


>  .../boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi     | 44 +++++++++++++++++++
>  .../boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi     | 44 +++++++++++++++++++
>  arch/powerpc/boot/dts/fsl/t2081si-post.dtsi   |  4 +-
>  3 files changed, 90 insertions(+), 2 deletions(-)
>  create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
>  create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
>=20
> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
> new file mode 100644
> index 000000000000..437dab3fc017
> --- /dev/null
> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
> @@ -0,0 +1,44 @@
> +// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later
> +/*
> + * QorIQ FMan v3 10g port #2 device tree stub [ controller @ offset
> 0x400000 ]
> + *
> + * Copyright 2022 Sean Anderson <sean.anderson@seco.com>
> + * Copyright 2012 - 2015 Freescale Semiconductor Inc.
> + */
> +
> +fman@400000 {
> +	fman0_rx_0x08: port@88000 {
> +		cell-index =3D <0x8>;
> +		compatible =3D "fsl,fman-v3-port-rx";
> +		reg =3D <0x88000 0x1000>;
> +		fsl,fman-10g-port;
> +	};
> +
> +	fman0_tx_0x28: port@a8000 {
> +		cell-index =3D <0x28>;
> +		compatible =3D "fsl,fman-v3-port-tx";
> +		reg =3D <0xa8000 0x1000>;
> +		fsl,fman-10g-port;
> +	};
> +
> +	ethernet@e0000 {
> +		cell-index =3D <0>;
> +		compatible =3D "fsl,fman-memac";
> +		reg =3D <0xe0000 0x1000>;
> +		fsl,fman-ports =3D <&fman0_rx_0x08 &fman0_tx_0x28>;
> +		ptp-timer =3D <&ptp_timer0>;
> +		pcsphy-handle =3D <&pcsphy0>;
> +	};
> +
> +	mdio@e1000 {
> +		#address-cells =3D <1>;
> +		#size-cells =3D <0>;
> +		compatible =3D "fsl,fman-memac-mdio", "fsl,fman-xmdio";
> +		reg =3D <0xe1000 0x1000>;
> +		fsl,erratum-a011043; /* must ignore read errors */
> +
> +		pcsphy0: ethernet-phy@0 {
> +			reg =3D <0x0>;
> +		};
> +	};
> +};
> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
> new file mode 100644
> index 000000000000..ad116b17850a
> --- /dev/null
> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
> @@ -0,0 +1,44 @@
> +// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later
> +/*
> + * QorIQ FMan v3 10g port #3 device tree stub [ controller @ offset
> 0x400000 ]
> + *
> + * Copyright 2022 Sean Anderson <sean.anderson@seco.com>
> + * Copyright 2012 - 2015 Freescale Semiconductor Inc.
> + */
> +
> +fman@400000 {
> +	fman0_rx_0x09: port@89000 {
> +		cell-index =3D <0x9>;
> +		compatible =3D "fsl,fman-v3-port-rx";
> +		reg =3D <0x89000 0x1000>;
> +		fsl,fman-10g-port;
> +	};
> +
> +	fman0_tx_0x29: port@a9000 {
> +		cell-index =3D <0x29>;
> +		compatible =3D "fsl,fman-v3-port-tx";
> +		reg =3D <0xa9000 0x1000>;
> +		fsl,fman-10g-port;
> +	};
> +
> +	ethernet@e2000 {
> +		cell-index =3D <1>;
> +		compatible =3D "fsl,fman-memac";
> +		reg =3D <0xe2000 0x1000>;
> +		fsl,fman-ports =3D <&fman0_rx_0x09 &fman0_tx_0x29>;
> +		ptp-timer =3D <&ptp_timer0>;
> +		pcsphy-handle =3D <&pcsphy1>;
> +	};
> +
> +	mdio@e3000 {
> +		#address-cells =3D <1>;
> +		#size-cells =3D <0>;
> +		compatible =3D "fsl,fman-memac-mdio", "fsl,fman-xmdio";
> +		reg =3D <0xe3000 0x1000>;
> +		fsl,erratum-a011043; /* must ignore read errors */
> +
> +		pcsphy1: ethernet-phy@0 {
> +			reg =3D <0x0>;
> +		};
> +	};
> +};
> diff --git a/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
> b/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
> index ecbb447920bc..74e17e134387 100644
> --- a/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
> +++ b/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
> @@ -609,8 +609,8 @@ usb1: usb@211000 {
>  /include/ "qoriq-bman1.dtsi"
>=20
>  /include/ "qoriq-fman3-0.dtsi"
> -/include/ "qoriq-fman3-0-1g-0.dtsi"
> -/include/ "qoriq-fman3-0-1g-1.dtsi"
> +/include/ "qoriq-fman3-0-10g-2.dtsi"
> +/include/ "qoriq-fman3-0-10g-3.dtsi"
>  /include/ "qoriq-fman3-0-1g-2.dtsi"
>  /include/ "qoriq-fman3-0-1g-3.dtsi"
>  /include/ "qoriq-fman3-0-1g-4.dtsi"
> --
> 2.35.1.1320.gc452695387.dirty

