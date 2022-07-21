Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62E9657CC84
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 15:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbiGUNs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 09:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiGUNs2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 09:48:28 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2086.outbound.protection.outlook.com [40.107.21.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5558B1D7;
        Thu, 21 Jul 2022 06:48:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nvt/F6cC1Gid6SHzDVqdKpt0D2Iv69R3RjijSiERJ1tUUtXsCa+Ekjr6pXHcI+4YcSdcNgrpz1ZJll5pfkC/ry+abUhQCD9R5k5vOtZu7SNYfW1SW9IO+EQ3hb5Qk3ljjvQnIqj3eEvuDytz3DpFvnW1fAPvpP6bCHf0WjfhaROwD1O+5TU1Z6EL48hDN+pjTSOoPwbPLFEAT1x/q6PUHU0DGKWb1xXbYkichIs/A8XI8gTP5qKLhceofGqrazNDaZLBNINyTNQLWkGUFiAmvgyA9ueXcNM78IBQjJjzk4gCXujwIomVH3lJbfmyz03Z4gT9MKwYjbl253Ag4ULa3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hk2uY6HmqwisibCUmu//MAomsQV0G7DZcZonBs77X1Q=;
 b=I8bZA+coH88+Ima9SGUbuqN3fva6Ker7WrhmhDWNiw6Mx9jjupv5oKAuxfbgFQdEzeaNpbYMMwTd5bpUs3+26963evdYdNUmymZHXOrPMwNNqdEIO1ZdXWiPIiMXfnuzDagO5dadlWFNK2uruI1J+3PRZiTv+5/QtiwROKE6OoJFUmgV5Wr0/HyAvrJMFVOAuTEGJgtkdW4IGyJQrxTSifzAThgJIOlNDMAnoTMNx/iy0ikJpW6EFht7ZtuTvwhc/Nc/uL5PFutm+KbQzp0dyYyUMkVr3bY80/ROnl81lpnctxQPk8R9c5sFIAKrJ+sLZnq3xpxzUJggLNU7lwC+KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hk2uY6HmqwisibCUmu//MAomsQV0G7DZcZonBs77X1Q=;
 b=IPC4x5U7TXsMMQ5hc4VgpZFQ2K5E4EuEruNTsAoNqXgikZ8y5hHVL/y0qWLchAI0yxf8TilythmvOKjVtjD1ws+auaNbAZL5A8vv2BjCdZxATGx2/mJNcnHDhZvorfLQmqzBSv4UV3F/5jljnFhMrGYsC8OqSm9HS24KMO6bIx0=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by PAXPR04MB8783.eurprd04.prod.outlook.com (2603:10a6:102:20e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 13:48:21 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 13:48:21 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        Sean Anderson <sean.anderson@seco.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Russell King <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Rob Herring <robh+dt@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shawn Guo <shawnguo@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH net-next v3 42/47] powerpc: dts: qoriq: Add nodes for
 QSGMII PCSs
Thread-Topic: [PATCH net-next v3 42/47] powerpc: dts: qoriq: Add nodes for
 QSGMII PCSs
Thread-Index: AQHYmJbdnjAOsVscb0m35C49TyMPEa2I3ITg
Date:   Thu, 21 Jul 2022 13:48:21 +0000
Message-ID: <VI1PR04MB58079B0A71B13CC3B6D1D289F2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-43-sean.anderson@seco.com>
In-Reply-To: <20220715215954.1449214-43-sean.anderson@seco.com>
Accept-Language: en-GB, ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7b2042d4-cfea-4d08-3136-08da6b1face0
x-ms-traffictypediagnostic: PAXPR04MB8783:EE_
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8CxuiyX/andufj6oIrmm4Cf/AEI7emTfZTakhfS4bwBtMDZCCTIyCIGks6x3VSRtF/+d7UQGEa2ZC5I8zLMtIPawcrnxW6mQ2jD71ymrfjbVFaCoxaHLHbBRfUEVYYz3tuc2ZpOiZe6sXNm3vjcP5sKZYBTcrtcNQHRaOka80k6nOXnpB9ppwSwp3nsIFfcyTO3PtJSBFwtV7Mhazam2zfprgBvssDgID89VHjzRut8xIxYw0zlYjDoZ2HZ0odzGdShQZrktUJVvrO4IaexcuD5ZLqTdosMabfJPireNB59cfzO8DXVxUS2ICG7BvcEXJrf+kiYAfS1SshiJupx9GKAQRxXt7HOs5RdaNH98OgsIzeUbbW2pT0fUf6xuV5evsupExCpWk7tjGaZy4iI/aPWiXdj8WezvsXdcS/ECggOxjat8Zs0lCLIE2HYC1dKeECruLxut8ExXdzGA787/VaZFT0IzwTZEMb89gFNaTUPd+LAyTP80KTXL5z3dlEhrOYy6Uii3BsUbXCleDgbQm9lRpnVcxeEZgkTIcIB0vtdvjvirXbqhk0lhP+7gEp8AS/wGVQMULEQid/qAt8Frqqw+SKRfjOsWX2qeggTSUqt3t00dkosZ5hSG97nbb4GPjvJxxzzOjjeWE60BM8NkcXNT0vrfees+zcQqicOCFtG6lS+Yiw0AUkrhhCOBBP24pwa5y7Lmk+H7KRgRUvCOR1uNJZlRUmIcShr10pwnac/xsKsiNi6nOOgGAHTU9M1HW406IeEmsN3d25OrBSH0DmafB8VXTsmXevg/juOQyxE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(396003)(136003)(346002)(366004)(86362001)(66946007)(38100700002)(83380400001)(38070700005)(66476007)(122000001)(8676002)(64756008)(66556008)(66446008)(55016003)(316002)(4326008)(54906003)(71200400001)(7696005)(52536014)(30864003)(8936002)(53546011)(5660300002)(9686003)(7416002)(26005)(6506007)(2906002)(55236004)(110136005)(41300700001)(186003)(76116006)(478600001)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VogEwCJJFiX4ESkhESRwgrKYVE8qyOaL6kO7Sjt8aCisXvr4KNHshC5bHYxa?=
 =?us-ascii?Q?fDx4txyvA7m1AF9nUKcnFCLGiAv0Ro4b63WTvqa/Ng0TvvAaeawh1bKAcUOl?=
 =?us-ascii?Q?DIu/kjBzyP5fm4eFT4B7UvRkYOs5ley7yx1SKPigB1FjEW9AUbjX2TuV7ZL+?=
 =?us-ascii?Q?VYhK3BySQtZ9Taf+vBuqioiDcGQ1OTkmU3MPlB1b7StrIUQyHInXPwMc3ICy?=
 =?us-ascii?Q?xveDnQTSwahlfjSPgbKWu/rAs4zI5wLIFXwtBx+Km4L5Y76NQcEV8a/SrW+C?=
 =?us-ascii?Q?50marV7fInekIvc4Tqo4OpUi9E3RctyIYI3VhJGGo8o1aiWByo2ZAyA2NeCA?=
 =?us-ascii?Q?cyT59cSWaUaWTQLlSa0x62C/LhyTUorqVXYC+qsJJR7rYDI2rYzPAqECCQzx?=
 =?us-ascii?Q?FS2bigrKQyUrPtpRlpp9hWocLjC3g0ZRtwA/GsMhXlBRKzJwvpFjER7zMe5B?=
 =?us-ascii?Q?TdjBS3PB5fTaGkar8xnj8GU3Wfx2D71B1Vpl2a0hja4iUHWqqg8/HD0Ah2+x?=
 =?us-ascii?Q?QdrN5Um3nKag0zJXyR05VrhLlX/KVqDG62C1rQXCLFDGRmW8ixpSZyb1ryRG?=
 =?us-ascii?Q?GbNYrFYCESpI8WNOSnkl6e86W+C9E5a248jGL0/DSmBnhNkUkeJ1cEMI2RWr?=
 =?us-ascii?Q?6Mg/gHV7LT8DSrAowQkU1FqHtKQNvNVQXC/mQbnYDGdvIFlxUG0YKc65hqnb?=
 =?us-ascii?Q?vkqcOTYpULP3DVWv7FrJ8rLm5MI33+QIdS690VwopCTk0qCIW26XTutmfrdw?=
 =?us-ascii?Q?7GJROmsbRoRWhJhYmt1mP1x4iRYuMWlBEhp/yqW3RqUAOloUzpQnU/0U3QPO?=
 =?us-ascii?Q?VJmYBlv44Hycx8wNLRzFck1hXqEfIQI6loi+rpPg8KLQkocJLLhfq2TdIPy5?=
 =?us-ascii?Q?qf8kzpIDlnMoEiJDmga1GzPMQ/eUcn7ZnjHAKq5nWbCoIr8E+nnXsKV85Big?=
 =?us-ascii?Q?dhw9BY+tTliDawx7lNkF82Su3Y5E4YYj7vJBHP1YssCZCAbPkIg0CU4KEjlA?=
 =?us-ascii?Q?rL43kDG0IrpxH1Ik8jEud22Um3oAouhyVwvp5duLk1ECHmTzr6BinmppCwCW?=
 =?us-ascii?Q?LKXf3Fu5Ovpud26Cp3kFLgKOPTBzPQvMALR3LCYtLBK6lsArci5y71lHqM/g?=
 =?us-ascii?Q?hVyD3WESKKW64U1kDmwnN8lWcEeveZA9EC2+g9Mwb7JSTEB3kDsSjj4Gn+bM?=
 =?us-ascii?Q?lhg95SdMZgpOJED2KdxmcN174TNsIE3JdPrmj/0z9BbcNODbqKc5lPXVDEdK?=
 =?us-ascii?Q?iQwWsmIveCD9bPPnnGb1d1slU5WjL3v1jVuNeSLKHCgH6/PH4zTOasymDpq1?=
 =?us-ascii?Q?Gs9R3J10sapVi2S5IEbGTD3j6fkR92dGdeC/xcT3pbqazycopvrmhr7bgN84?=
 =?us-ascii?Q?LHycT4FncDs/YzOftIzCuBklLo/l18R4XKEPvec/w5b0p/+Yoptb9FnKq4CH?=
 =?us-ascii?Q?E3SC52KDUMPomF0ZYdSRcW6UTwSeDjdUt8kw2QEhdJSjRELEuBlF4ofMEMYN?=
 =?us-ascii?Q?i+c4rq4SyzlJRtghGBrf4DlWTly/Nfoh/iugQvT0S3F4CUl7qsZBLCyJ0Qkr?=
 =?us-ascii?Q?F5dSMBqDjCI6wZiJCanKzFMRWgCiIhFwHq/MHByg?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b2042d4-cfea-4d08-3136-08da6b1face0
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 13:48:21.4566
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z4H6HQdunhrfHhT5Do//7yMYN2U9yCWluf6ZxjsPkPXyTHcvfxYqe0KcfBdXfUof3kSTeE+7DycycyWR8oJf+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8783
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
> From: Linuxppc-dev <linuxppc-dev-
> bounces+camelia.groza=3Dnxp.com@lists.ozlabs.org> On Behalf Of Sean
> Anderson
> Sent: Saturday, July 16, 2022 1:00
> To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
> <kuba@kernel.org>; Madalin Bucur <madalin.bucur@nxp.com>;
> netdev@vger.kernel.org
> Cc: devicetree@vger.kernel.org; Leo Li <leoyang.li@nxp.com>; Sean
> Anderson <sean.anderson@seco.com>; linuxppc-dev@lists.ozlabs.org;
> Russell King <linux@armlinux.org.uk>; linux-kernel@vger.kernel.org; Eric
> Dumazet <edumazet@google.com>; Rob Herring <robh+dt@kernel.org>;
> Paul Mackerras <paulus@samba.org>; Krzysztof Kozlowski
> <krzysztof.kozlowski+dt@linaro.org>; Paolo Abeni <pabeni@redhat.com>;
> Shawn Guo <shawnguo@kernel.org>; linux-arm-kernel@lists.infradead.org
> Subject: [PATCH net-next v3 42/47] powerpc: dts: qoriq: Add nodes for
> QSGMII PCSs
>=20
> Now that we actually read registers from QSGMII PCSs, it's important
> that we have the correct address (instead of hoping that we're the MAC
> with all the QSGMII PCSs on its bus). This adds nodes for the QSGMII
> PCSs. They have the same addresses on all SoCs (e.g. if QSGMIIA is
> present it's used for MACs 1 through 4).
>=20
> Since the first QSGMII PCSs share an address with the SGMII and XFI
> PCSs, we only add new nodes for PCSs 2-4. This avoids address conflicts
> on the bus.
>=20
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>

MAC1 and MAC2 can be XFI on T2080. This needs to be reflected in qoriq-fman=
3-0-1g-0.dtsi
and qoriq-fman3-0-1g-1.dtsi

The two associated netdevs fail to probe on a T2080RDB without "xfi" added =
to the pcs-names:
fsl_dpaa_mac ffe4e0000.ethernet (unnamed net_device) (uninitialized): faile=
d to validate link configuration for in-band status
fsl_dpaa_mac ffe4e0000.ethernet: error -EINVAL: Could not create phylink
fsl_dpa: probe of dpaa-ethernet.0 failed with error -22

> ---
>=20
> Changes in v3:
> - Add compatibles for QSGMII PCSs
> - Split arm and powerpcs dts updates
>=20
> Changes in v2:
> - New
>=20
>  .../boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi  |  3 ++-
>  arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi     | 10 +++++++++-
>  .../boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi  | 10 +++++++++-
>  arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi     | 10 +++++++++-
>  arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi      |  3 ++-
>  arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi      | 10 +++++++++-
>  arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi      | 10 +++++++++-
>  arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi      | 10 +++++++++-
>  arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi      |  3 ++-
>  arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi      | 10 +++++++++-
>  arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi     | 10 +++++++++-
>  arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi     | 10 +++++++++-
>  arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi      |  3 ++-
>  arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi      | 10 +++++++++-
>  arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi      | 10 +++++++++-
>  arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi      | 10 +++++++++-
>  arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi      |  3 ++-
>  arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi      | 10 +++++++++-
>  18 files changed, 127 insertions(+), 18 deletions(-)
>=20
> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dt=
si
> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi
> index baa0c503e741..db169d630db3 100644
> --- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi
> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi
> @@ -55,7 +55,8 @@ ethernet@e0000 {
>  		reg =3D <0xe0000 0x1000>;
>  		fsl,fman-ports =3D <&fman0_rx_0x08 &fman0_tx_0x28>;
>  		ptp-timer =3D <&ptp_timer0>;
> -		pcsphy-handle =3D <&pcsphy0>;
> +		pcsphy-handle =3D <&pcsphy0>, <&pcsphy0>;
> +		pcs-names =3D "sgmii", "qsgmii";
>  	};
>=20
>  	mdio@e1000 {
> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi
> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi
> index 93095600e808..e80ad8675be8 100644
> --- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi
> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi
> @@ -52,7 +52,15 @@ ethernet@f0000 {
>  		compatible =3D "fsl,fman-memac";
>  		reg =3D <0xf0000 0x1000>;
>  		fsl,fman-ports =3D <&fman0_rx_0x10 &fman0_tx_0x30>;
> -		pcsphy-handle =3D <&pcsphy6>;
> +		pcsphy-handle =3D <&pcsphy6>, <&qsgmiib_pcs2>,
> <&pcsphy6>;
> +		pcs-names =3D "sgmii", "qsgmii", "xfi";
> +	};
> +
> +	mdio@e9000 {
> +		qsgmiib_pcs2: ethernet-pcs@2 {
> +			compatible =3D "fsl,lynx-pcs";
> +			reg =3D <2>;
> +		};
>  	};
>=20
>  	mdio@f1000 {
> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dt=
si
> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi
> index ff4bd38f0645..6a6f51842ad5 100644
> --- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi
> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi
> @@ -55,7 +55,15 @@ ethernet@e2000 {
>  		reg =3D <0xe2000 0x1000>;
>  		fsl,fman-ports =3D <&fman0_rx_0x09 &fman0_tx_0x29>;
>  		ptp-timer =3D <&ptp_timer0>;
> -		pcsphy-handle =3D <&pcsphy1>;
> +		pcsphy-handle =3D <&pcsphy1>, <&qsgmiia_pcs1>;
> +		pcs-names =3D "sgmii", "qsgmii";
> +	};
> +
> +	mdio@e1000 {
> +		qsgmiia_pcs1: ethernet-pcs@1 {
> +			compatible =3D "fsl,lynx-pcs";
> +			reg =3D <1>;
> +		};
>  	};
>=20
>  	mdio@e3000 {
> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi
> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi
> index 1fa38ed6f59e..543da5493e40 100644
> --- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi
> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi
> @@ -52,7 +52,15 @@ ethernet@f2000 {
>  		compatible =3D "fsl,fman-memac";
>  		reg =3D <0xf2000 0x1000>;
>  		fsl,fman-ports =3D <&fman0_rx_0x11 &fman0_tx_0x31>;
> -		pcsphy-handle =3D <&pcsphy7>;
> +		pcsphy-handle =3D <&pcsphy7>, <&qsgmiib_pcs3>,
> <&pcsphy7>;
> +		pcs-names =3D "sgmii", "qsgmii", "xfi";
> +	};
> +
> +	mdio@e9000 {
> +		qsgmiib_pcs3: ethernet-pcs@3 {
> +			compatible =3D "fsl,lynx-pcs";
> +			reg =3D <3>;
> +		};
>  	};
>=20
>  	mdio@f3000 {
> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi
> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi
> index a8cc9780c0c4..ce76725e6eb2 100644
> --- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi
> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi
> @@ -51,7 +51,8 @@ ethernet@e0000 {
>  		reg =3D <0xe0000 0x1000>;
>  		fsl,fman-ports =3D <&fman0_rx_0x08 &fman0_tx_0x28>;
>  		ptp-timer =3D <&ptp_timer0>;
> -		pcsphy-handle =3D <&pcsphy0>;
> +		pcsphy-handle =3D <&pcsphy0>, <&pcsphy0>;
> +		pcs-names =3D "sgmii", "qsgmii";
>  	};
>=20
>  	mdio@e1000 {
> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi
> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi
> index 8b8bd70c9382..f3af67df4767 100644
> --- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi
> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi
> @@ -51,7 +51,15 @@ ethernet@e2000 {
>  		reg =3D <0xe2000 0x1000>;
>  		fsl,fman-ports =3D <&fman0_rx_0x09 &fman0_tx_0x29>;
>  		ptp-timer =3D <&ptp_timer0>;
> -		pcsphy-handle =3D <&pcsphy1>;
> +		pcsphy-handle =3D <&pcsphy1>, <&qsgmiia_pcs1>;
> +		pcs-names =3D "sgmii", "qsgmii";
> +	};
> +
> +	mdio@e1000 {
> +		qsgmiia_pcs1: ethernet-pcs@1 {
> +			compatible =3D "fsl,lynx-pcs";
> +			reg =3D <1>;
> +		};
>  	};
>=20
>  	mdio@e3000 {
> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi
> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi
> index 619c880b54d8..f6d74de84bfe 100644
> --- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi
> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi
> @@ -51,7 +51,15 @@ ethernet@e4000 {
>  		reg =3D <0xe4000 0x1000>;
>  		fsl,fman-ports =3D <&fman0_rx_0x0a &fman0_tx_0x2a>;
>  		ptp-timer =3D <&ptp_timer0>;
> -		pcsphy-handle =3D <&pcsphy2>;
> +		pcsphy-handle =3D <&pcsphy2>, <&qsgmiia_pcs2>;
> +		pcs-names =3D "sgmii", "qsgmii";
> +	};
> +
> +	mdio@e1000 {
> +		qsgmiia_pcs2: ethernet-pcs@2 {
> +			compatible =3D "fsl,lynx-pcs";
> +			reg =3D <2>;
> +		};
>  	};
>=20
>  	mdio@e5000 {
> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi
> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi
> index d7ebb73a400d..6e091d8ae9e2 100644
> --- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi
> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi
> @@ -51,7 +51,15 @@ ethernet@e6000 {
>  		reg =3D <0xe6000 0x1000>;
>  		fsl,fman-ports =3D <&fman0_rx_0x0b &fman0_tx_0x2b>;
>  		ptp-timer =3D <&ptp_timer0>;
> -		pcsphy-handle =3D <&pcsphy3>;
> +		pcsphy-handle =3D <&pcsphy3>, <&qsgmiia_pcs3>;
> +		pcs-names =3D "sgmii", "qsgmii";
> +	};
> +
> +	mdio@e1000 {
> +		qsgmiia_pcs3: ethernet-pcs@3 {
> +			compatible =3D "fsl,lynx-pcs";
> +			reg =3D <3>;
> +		};
>  	};
>=20
>  	mdio@e7000 {
> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi
> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi
> index b151d696a069..e2174c0fc841 100644
> --- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi
> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi
> @@ -51,7 +51,8 @@ ethernet@e8000 {
>  		reg =3D <0xe8000 0x1000>;
>  		fsl,fman-ports =3D <&fman0_rx_0x0c &fman0_tx_0x2c>;
>  		ptp-timer =3D <&ptp_timer0>;
> -		pcsphy-handle =3D <&pcsphy4>;
> +		pcsphy-handle =3D <&pcsphy4>, <&pcsphy4>;
> +		pcs-names =3D "sgmii", "qsgmii";
>  	};
>=20
>  	mdio@e9000 {
> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi
> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi
> index adc0ae0013a3..9106815bd63e 100644
> --- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi
> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi
> @@ -51,7 +51,15 @@ ethernet@ea000 {
>  		reg =3D <0xea000 0x1000>;
>  		fsl,fman-ports =3D <&fman0_rx_0x0d &fman0_tx_0x2d>;
>  		ptp-timer =3D <&ptp_timer0>;
> -		pcsphy-handle =3D <&pcsphy5>;
> +		pcsphy-handle =3D <&pcsphy5>, <&qsgmiib_pcs1>;
> +		pcs-names =3D "sgmii", "qsgmii";
> +	};
> +
> +	mdio@e9000 {
> +		qsgmiib_pcs1: ethernet-pcs@1 {
> +			compatible =3D "fsl,lynx-pcs";
> +			reg =3D <1>;
> +		};
>  	};
>=20
>  	mdio@eb000 {
> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi
> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi
> index 435047e0e250..a3c1538dfda1 100644
> --- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi
> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi
> @@ -52,7 +52,15 @@ ethernet@f0000 {
>  		compatible =3D "fsl,fman-memac";
>  		reg =3D <0xf0000 0x1000>;
>  		fsl,fman-ports =3D <&fman1_rx_0x10 &fman1_tx_0x30>;
> -		pcsphy-handle =3D <&pcsphy14>;
> +		pcsphy-handle =3D <&pcsphy14>, <&qsgmiid_pcs2>,
> <&pcsphy14>;
> +		pcs-names =3D "sgmii", "qsgmii", "xfi";
> +	};
> +
> +	mdio@e9000 {
> +		qsgmiid_pcs2: ethernet-pcs@2 {
> +			compatible =3D "fsl,lynx-pcs";
> +			reg =3D <2>;
> +		};
>  	};
>=20
>  	mdio@f1000 {
> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi
> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi
> index c098657cca0a..c024517e70d6 100644
> --- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi
> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi
> @@ -52,7 +52,15 @@ ethernet@f2000 {
>  		compatible =3D "fsl,fman-memac";
>  		reg =3D <0xf2000 0x1000>;
>  		fsl,fman-ports =3D <&fman1_rx_0x11 &fman1_tx_0x31>;
> -		pcsphy-handle =3D <&pcsphy15>;
> +		pcsphy-handle =3D <&pcsphy15>, <&qsgmiid_pcs3>,
> <&pcsphy15>;
> +		pcs-names =3D "sgmii", "qsgmii", "xfi";
> +	};
> +
> +	mdio@e9000 {
> +		qsgmiid_pcs3: ethernet-pcs@3 {
> +			compatible =3D "fsl,lynx-pcs";
> +			reg =3D <3>;
> +		};
>  	};
>=20
>  	mdio@f3000 {
> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi
> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi
> index 9d06824815f3..16fb299f615a 100644
> --- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi
> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi
> @@ -51,7 +51,8 @@ ethernet@e0000 {
>  		reg =3D <0xe0000 0x1000>;
>  		fsl,fman-ports =3D <&fman1_rx_0x08 &fman1_tx_0x28>;
>  		ptp-timer =3D <&ptp_timer1>;
> -		pcsphy-handle =3D <&pcsphy8>;
> +		pcsphy-handle =3D <&pcsphy8>, <&pcsphy8>;
> +		pcs-names =3D "sgmii", "qsgmii";
>  	};
>=20
>  	mdio@e1000 {
> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi
> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi
> index 70e947730c4b..75cecbef8469 100644
> --- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi
> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi
> @@ -51,7 +51,15 @@ ethernet@e2000 {
>  		reg =3D <0xe2000 0x1000>;
>  		fsl,fman-ports =3D <&fman1_rx_0x09 &fman1_tx_0x29>;
>  		ptp-timer =3D <&ptp_timer1>;
> -		pcsphy-handle =3D <&pcsphy9>;
> +		pcsphy-handle =3D <&pcsphy9>, <&qsgmiic_pcs1>;
> +		pcs-names =3D "sgmii", "qsgmii";
> +	};
> +
> +	mdio@e1000 {
> +		qsgmiic_pcs1: ethernet-pcs@1 {
> +			compatible =3D "fsl,lynx-pcs";
> +			reg =3D <1>;
> +		};
>  	};
>=20
>  	mdio@e3000 {
> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi
> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi
> index ad96e6529595..98c1d27f17e7 100644
> --- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi
> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi
> @@ -51,7 +51,15 @@ ethernet@e4000 {
>  		reg =3D <0xe4000 0x1000>;
>  		fsl,fman-ports =3D <&fman1_rx_0x0a &fman1_tx_0x2a>;
>  		ptp-timer =3D <&ptp_timer1>;
> -		pcsphy-handle =3D <&pcsphy10>;
> +		pcsphy-handle =3D <&pcsphy10>, <&qsgmiic_pcs2>;
> +		pcs-names =3D "sgmii", "qsgmii";
> +	};
> +
> +	mdio@e1000 {
> +		qsgmiic_pcs2: ethernet-pcs@2 {
> +			compatible =3D "fsl,lynx-pcs";
> +			reg =3D <2>;
> +		};
>  	};
>=20
>  	mdio@e5000 {
> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi
> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi
> index 034bc4b71f7a..203a00036f17 100644
> --- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi
> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi
> @@ -51,7 +51,15 @@ ethernet@e6000 {
>  		reg =3D <0xe6000 0x1000>;
>  		fsl,fman-ports =3D <&fman1_rx_0x0b &fman1_tx_0x2b>;
>  		ptp-timer =3D <&ptp_timer1>;
> -		pcsphy-handle =3D <&pcsphy11>;
> +		pcsphy-handle =3D <&pcsphy11>, <&qsgmiic_pcs3>;
> +		pcs-names =3D "sgmii", "qsgmii";
> +	};
> +
> +	mdio@e1000 {
> +		qsgmiic_pcs3: ethernet-pcs@3 {
> +			compatible =3D "fsl,lynx-pcs";
> +			reg =3D <3>;
> +		};
>  	};
>=20
>  	mdio@e7000 {
> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi
> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi
> index 93ca23d82b39..9366935ebc02 100644
> --- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi
> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi
> @@ -51,7 +51,8 @@ ethernet@e8000 {
>  		reg =3D <0xe8000 0x1000>;
>  		fsl,fman-ports =3D <&fman1_rx_0x0c &fman1_tx_0x2c>;
>  		ptp-timer =3D <&ptp_timer1>;
> -		pcsphy-handle =3D <&pcsphy12>;
> +		pcsphy-handle =3D <&pcsphy12>, <&pcsphy12>;
> +		pcs-names =3D "sgmii", "qsgmii";
>  	};
>=20
>  	mdio@e9000 {
> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi
> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi
> index 23b3117a2fd2..39f7c6133017 100644
> --- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi
> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi
> @@ -51,7 +51,15 @@ ethernet@ea000 {
>  		reg =3D <0xea000 0x1000>;
>  		fsl,fman-ports =3D <&fman1_rx_0x0d &fman1_tx_0x2d>;
>  		ptp-timer =3D <&ptp_timer1>;
> -		pcsphy-handle =3D <&pcsphy13>;
> +		pcsphy-handle =3D <&pcsphy13>, <&qsgmiid_pcs1>;
> +		pcs-names =3D "sgmii", "qsgmii";
> +	};
> +
> +	mdio@e9000 {
> +		qsgmiid_pcs1: ethernet-pcs@1 {
> +			compatible =3D "fsl,lynx-pcs";
> +			reg =3D <1>;
> +		};
>  	};
>=20
>  	mdio@eb000 {
> --
> 2.35.1.1320.gc452695387.dirty

