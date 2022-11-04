Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 891D8619A29
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 15:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbiKDOgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 10:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231803AbiKDOfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 10:35:47 -0400
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2043.outbound.protection.outlook.com [40.107.247.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 802EA3137C;
        Fri,  4 Nov 2022 07:32:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S4LUHx4C++aECohCVr7sxR0JGg8YL5MlaYPJj6HrA1KQ1ZCuMIZ6wZGf1DWYt06Qnh7ZIsalJJksujI19FPGfN69ogfSVYHhjrNdXm0MPetCU/hlm6i9QyecJsZDbvJybQL03J644v9MR8fz1PBpHpNkTgQt5eOYEj/QMCPIYvEm0St9A0U2Bo3uHIYKNgnsg/u4G6mpcWZ0+nNRuYgm+nIv/KxTqDk5VE5Wxi9cNcvrhSfQO24PUxMK44Vp6jfD6XIqjzEMBp0dbVPRJaq7/hX7czRPMu9nEPt3wTytf96m3tPybnWfdtDlMZvZFT3nzWH/N9ScPdrUudRtMQSU1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MWFblSOuVDzjhsiEEdBZPlyBMICPA+ooUzZXncE5AJI=;
 b=GgFeP0mRkyd/7927f382V4Aat7uhcBHMS/6fMaJiBMsrufEIv1slVXpKKdp98oNYugVeElHJH6jIyozgeMq2Frf8/I/mfdEzyw/v3zdUaeRSPg97SDe+lSCuQ+60fh7dkNXz0JZiYPrAlhF4O6oa2A6xbukfPcQq/Fsrmeytbqz3oBbSy7tOerDo9haDzGG0ZFdT6vvTIqdIAfjJw3nnUP9O4mzp3e41sfVOByCF5gmhHOLevxOBGYMzYI0rVM4ZWOLuUvfQoRaKdP3Kr3CkZiLUghP+YlJqfCmhkCB8tZZCG1wZL/Lm+fZH1fBmfjjscw21VPAv0tSDtAqb48U1FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MWFblSOuVDzjhsiEEdBZPlyBMICPA+ooUzZXncE5AJI=;
 b=NhTQhwFvc11QPWnpmjKyOn9eRf3nnKAKmgGYdOEYmCGToJrkUHqomOkOXIzoYz9vL2niqfgNpHpCYB0vXxYn6vYNernMxBjUozxGZblmInUwSTsDead4NsfSyqn3CdXprT2LmTS0jsCee481fzX5+K/9uPa2b/thCGbe3h17gnI=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by GV1PR04MB9181.eurprd04.prod.outlook.com (2603:10a6:150:25::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Fri, 4 Nov
 2022 14:32:51 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336%7]) with mapi id 15.20.5769.022; Fri, 4 Nov 2022
 14:32:50 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
CC:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
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
        Robert Marko <robert.marko@sartura.hr>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>
Subject: Re: [PATCH net-next v7 5/5] ARM: dts: qcom: ipq4019: Add description
 for the IPQESS Ethernet controller
Thread-Topic: [PATCH net-next v7 5/5] ARM: dts: qcom: ipq4019: Add description
 for the IPQESS Ethernet controller
Thread-Index: AQHY8FmpmsPL59Zv3k23UVCewDzxaK4u03IAgAAAfAA=
Date:   Fri, 4 Nov 2022 14:32:50 +0000
Message-ID: <20221104143250.6qjkphkhrycp75rv@skbuf>
References: <20221104142746.350468-1-maxime.chevallier@bootlin.com>
 <20221104142746.350468-6-maxime.chevallier@bootlin.com>
 <50814a5b-03d3-95b4-ab14-bfd19adae52b@linaro.org>
In-Reply-To: <50814a5b-03d3-95b4-ab14-bfd19adae52b@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|GV1PR04MB9181:EE_
x-ms-office365-filtering-correlation-id: cee70430-3246-4a81-701d-08dabe7173c8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yjZUNUxrxKoHgDlE24f6Zmvhb5BQqQ6ttrmQ71juTQoVAWPrOVn2oo1/PrvDEHzAmk7ds7KEG44lhqkZwyLBwASLoX+j8aUCI8SWQ6FNjnbtgkwo9SA1BN7FSUwW9y1oDfm8Iil/51t9olcvrScgd3iBiwNdwwtpHkF+hnfL0PUwfx5ZhJ8qas1hb0cGZ4m+xxRHCrU3vC0CCQGlWb8483Ev3sgcEfrhbmgNyGedFJuXP7v/IOlC/zFYMLgnOuJr1Ya+96FXPYpqaOz5FbuInYDId7kGug5WY+8fdJSufPhqAmMf/1XuEMp1SEMEIO2GF6vRfljjBh+Kq2ztF1pNHKBeeLLqRBrOq12sfNIgGg5Ka1kVnqRapZuqpsBaE1CxhfC4oun3+OfbAG/FbQDeyy2IrVJkU8Ynbb/7o1PyB5r/tdkAs5iS/DgI+HLMoabGEhL+05+pp+dhr1MPE/reXEMXKv2Ts/sGV8OmP+NgDYFTFGYRq9I/zWwHaEJ/Xop5z/ho7wWgF7t6v61bYy6T+muyZKT2Br/AF2MlwkVfjZZXlfJNcHzJxUd9Nju5P511Z5JbvyVMx/DpG2jY1trmBpOZm94SZF+VCskWo8e9LBtvmUQGm+z3/CiDLf9obfPjV8c2vBZqtjhrBRsDEPV55flaRpe4smiw7q9nDmIad6Kk3PDknr55MRZiriE+BZWPZOdd7LnTxnqXX012Sp9jRnZ5X96/K2pTBm+CZBQ6/ocpyUg1pAVKFoEybWyj2fUMJVhq7ekW5e1Wu+00f8P7tA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(366004)(136003)(396003)(346002)(376002)(39860400002)(451199015)(86362001)(33716001)(38070700005)(7416002)(4326008)(41300700001)(66476007)(66556008)(8676002)(76116006)(6512007)(66446008)(64756008)(9686003)(26005)(66946007)(4744005)(44832011)(1076003)(8936002)(186003)(5660300002)(6486002)(478600001)(71200400001)(54906003)(6506007)(91956017)(6916009)(38100700002)(316002)(122000001)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?m/09n30seC+iw2UkP32Wn4Ilubcfp3OH96k5dfyZEPKhj8rSHBQPdp3SGtx8?=
 =?us-ascii?Q?j0E826TbGdcvp3G8nRJUs8aMyHRY6GULIjQPGs09mhyD86pSl19tNMMf13or?=
 =?us-ascii?Q?c0QfFJLdrxx89DaJlGmzogjBuQZkRnaUBCTW551FgnQpY54tEIMXyDQ4pTFj?=
 =?us-ascii?Q?mi6aCwqkxoJ6YopE4zEzFdwNCQa95iHJhes5DeNqcVMToW0aD1PJdbIz8bvK?=
 =?us-ascii?Q?3LUuvFAWxbhkw/iFgzEyjXfATbIqhG3vYW8dgKIfgyafV+kkAucpAFzcleHH?=
 =?us-ascii?Q?6qi1I7RJC3mHT9PbMFh/T4gP9PXPyymjZk8uFh/mvkFLaLPgBSySNdSdBdjz?=
 =?us-ascii?Q?2RrNdNr/fNsvo+FeW3Hp/CIk5/TOqD84r1esolKVj729ya6v98zUDm1MWvQq?=
 =?us-ascii?Q?3Fm/eI6pBQa/+TE61N/LuAIksqBMr+5xUSRuccZKhUT88edH7SQjyn7frQQ1?=
 =?us-ascii?Q?Foj6T9g1SWFSKJXYKtzdPtNYZ8krBWNeCTbM2M+4KdAIEKhqGQwQe3d+4VhK?=
 =?us-ascii?Q?PX4xhWyoquHTma9U7QqdOdT+uDFm2X38ZBT8N7WbPcH2mucwi3c70iRkk8FL?=
 =?us-ascii?Q?U9Isklz3g357e12l2Wp6OVKEnN9oUT/OxEv+zGpGJH0C+lp3xs1/1zea4SqK?=
 =?us-ascii?Q?BgA5iYpSNW4k94teCYvw1G1sFzD3dNZPZJHp/ATwqiWdLuXqkSSwApcvq/7O?=
 =?us-ascii?Q?zzDuuFNNTRz7fWsmzUzx3XM2HeadBTI5XGQh2sIs44WFHevbin97UCciV/E/?=
 =?us-ascii?Q?ghfWx1eF4n5alWKZaoMADClAbercQf4RkoEfNOZ/fBjtDWY1yrU0/DIdpumc?=
 =?us-ascii?Q?gzIGEJbOLdY5Ud0TBaMn68S4PariyXqmUrv5BcHyLrkRqnsWIpcrSpTvsIaF?=
 =?us-ascii?Q?SNKXoKbc36fZlY7C3X4E3PtfxJvPpyswsNsLHiNreVO3YD2FKXLfdlB9gaoC?=
 =?us-ascii?Q?jGg2TGYKnj9imcy9zCvw6TeMnahkZANDW7REJbh9tLHWGqMp0+dHC4wR3Ny2?=
 =?us-ascii?Q?cduYAT1mY7x+u/M9kyCmgbG213+i2GuS2S6++qT3zRDJ4j913R/2LvpOWD5z?=
 =?us-ascii?Q?s4orf9uHV7rD/AaM5bu8U5EOkFRBehm3wStPFY/F6Qv+nRttK/3XfdKA/5Ya?=
 =?us-ascii?Q?DY4t+1tYXEZTGUSMDL9oUl/uOQac1yAufVGzPqYOTJe/DljJdxfa73m4nBoh?=
 =?us-ascii?Q?yugIMLpeD58sKIhuCqxYB+bOTIMwDeq08X+QefohW9+CLC8HSnqiIEw+1nAl?=
 =?us-ascii?Q?BC9NmirpRWJPnHkFBylEficps3eUgf3jasND7TpcdP8X/Ju1yMR3UItMX7rr?=
 =?us-ascii?Q?epEdSoP8ZQQUu1VmL+tefqLeJtwr8YYbbiVU8qthf+BgtHfcf1SYuiRaobuV?=
 =?us-ascii?Q?4wnbPvhmq4jcZvESkkigGg1J1wGY3Nnw3s3gJuwasoUamZoDVKPVxV4BW1EG?=
 =?us-ascii?Q?fZXRHVtj1fuKRroATvZ5UWCUaLl70J4egoNVJ4IHOfTPvYRFw6XanXsT1ycy?=
 =?us-ascii?Q?T+qTkx2sNjGDs068dEWyULIdTkqfvWjRhHEqLFV1CkQPHpw+meyl5NGwjeac?=
 =?us-ascii?Q?JsnIs9XUr+lWZpE3DXCHOh3vk6CYRIfwpnUIk3dagpzHZxc+JXsHNNm1EtCe?=
 =?us-ascii?Q?lA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <007924274551D24F8388772AFD35525D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cee70430-3246-4a81-701d-08dabe7173c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2022 14:32:50.8819
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pSJicNI5ILchXQT/U0ggEwtHLXpuLLtfgX8K79yFBlMe73gayq/5Le9BodBjt5wXmvPx1+Vm3r+YYYg6WrB3TQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9181
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 04, 2022 at 10:31:06AM -0400, Krzysztof Kozlowski wrote:
> > diff --git a/arch/arm/boot/dts/qcom-ipq4019.dtsi b/arch/arm/boot/dts/qc=
om-ipq4019.dtsi
> > index b23591110bd2..5fa1af147df9 100644
> > --- a/arch/arm/boot/dts/qcom-ipq4019.dtsi
> > +++ b/arch/arm/boot/dts/qcom-ipq4019.dtsi
> > @@ -38,6 +38,7 @@ aliases {
> >  		spi1 =3D &blsp1_spi2;
> >  		i2c0 =3D &blsp1_i2c3;
> >  		i2c1 =3D &blsp1_i2c4;
> > +		ethernet0 =3D &gmac;
>=20
> Hm, I have doubts about this one. Why alias is needed and why it is a
> property of a SoC? Not every board has Ethernet enabled, so this looks
> like board property.
>=20
> I also wonder why do you need it at all?

In general, Ethernet aliases are needed so that the bootloader can fix
up the MAC address of each port's OF node with values it gets from the
U-Boot environment or an AT24 EEPROM or something like that.=
