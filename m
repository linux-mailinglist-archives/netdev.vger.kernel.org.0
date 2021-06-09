Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 522833A0A6F
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 05:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236231AbhFIDGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 23:06:36 -0400
Received: from mail-dm6nam11on2065.outbound.protection.outlook.com ([40.107.223.65]:58688
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231438AbhFIDGe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 23:06:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S6EQLzLAn9uiC/BoY2JZCOa7cA7KnTIoXXhJVCnoBk6fxYoAN/5SsKlT3393JpQpomWT+/I1F29empr9u+bbPAHI2NZlGlkx1/n1xBTF5NA3whYO/H6ZeObKXF8gtL1690GjXsqqLJqLJOAxayyJDEKzcCdJMBU3PNmrnbitCxPpW6mRk8rIE90J5Nu4OdAj8v4lAPtqKAUHEmO7O2Us6frJ+qTV9uLIXdGG6O4nIV8a3G/81ajGZF8mJ0nakQTaa+ZfOkRN0EEnjALLIQTtWd7AKs2gLHXGBqjo85I1eubbnl18pJcHIyIm8UgA77u6o6HCyLW/YoI0z24z3S/BOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vevu1+VecJutF2pp4FyWcqNcPGyfcSBoD57mSvGnOWk=;
 b=WgJdQwl8TJXAwH7NML8CEB02BTUQJuJ/uO1VW0ZYjFZxrJ+ahnjhLIVQKMTDtlvfz2S+oBmPOlwBGLYwHQNcVib1oKK7Rr00FHDwZzz/kCqG9EHIewkeGtTj+hb4vJwFoVpymHCa4GVt360aF2DYL2WNTwBW2zf6dbVRkkEifA0ZpgK4BYtFHpCQDZvFiwBPFNPibAxvJFbQAfB5/l7OjLen+KNy2bkIG8cgc1MW4hCqrb9O1qg6rtv7hOEY2+nqKYihqF0vq5Mln4eIpU08x7HVVSAyPRmgOb/cmo+LgZTGEyDF80TRyXBs5vg/yl7UaOlXbfFhFF14EdYITziSFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vevu1+VecJutF2pp4FyWcqNcPGyfcSBoD57mSvGnOWk=;
 b=jF0g8XlhgEXukBGu/92EHJ0XcvYhmscWUONbpLrYGAc7dRJA/Vs3hTmS0MM40iO0l9x879niQ4YapwouoLAcIpUsqLp/TSZ6Tc3jNzNQW/Sqo/QI/nKsiiU6FvP5ofmQ9QImVvFzROyFbfT1BX2ZeC6Mmj0odD1zZzr5vVZsDyM=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=synaptics.com;
Received: from BN9PR03MB6058.namprd03.prod.outlook.com (2603:10b6:408:137::15)
 by BN6PR03MB3012.namprd03.prod.outlook.com (2603:10b6:404:116::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.25; Wed, 9 Jun
 2021 03:04:39 +0000
Received: from BN9PR03MB6058.namprd03.prod.outlook.com
 ([fe80::502a:5487:b3ee:f61c]) by BN9PR03MB6058.namprd03.prod.outlook.com
 ([fe80::502a:5487:b3ee:f61c%4]) with mapi id 15.20.4219.021; Wed, 9 Jun 2021
 03:04:38 +0000
Date:   Wed, 9 Jun 2021 11:04:28 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 net-next 3/4] net: phy: realtek: add dt property to
 enable ALDPS mode
Message-ID: <20210609110428.5a136b03@xhacker.debian>
In-Reply-To: <DB8PR04MB67955F0424EAEBF362D34B30E6369@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210608031535.3651-1-qiangqing.zhang@nxp.com>
        <20210608031535.3651-4-qiangqing.zhang@nxp.com>
        <20210608175104.7ce18d1d@xhacker.debian>
        <DB8PR04MB6795D312FDECF820164B0DE6E6379@DB8PR04MB6795.eurprd04.prod.outlook.com>
        <20210609095633.1bce2c22@xhacker.debian>
        <DB8PR04MB67955F0424EAEBF362D34B30E6369@DB8PR04MB6795.eurprd04.prod.outlook.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [192.147.44.204]
X-ClientProxiedBy: SJ0PR03CA0014.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::19) To BN9PR03MB6058.namprd03.prod.outlook.com
 (2603:10b6:408:137::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (192.147.44.204) by SJ0PR03CA0014.namprd03.prod.outlook.com (2603:10b6:a03:33a::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Wed, 9 Jun 2021 03:04:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 04f5f72d-c82e-4c44-de3c-08d92af351ad
X-MS-TrafficTypeDiagnostic: BN6PR03MB3012:
X-Microsoft-Antispam-PRVS: <BN6PR03MB3012E6018E07BEEA7774EB60ED369@BN6PR03MB3012.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +2lM8gREr8+LDV01Kenx0eLwHxBjYUt+Rqv/3fNjH/o/cj7Thfn4aCpZYU65t2sKn/DDKxe3CNf5HMtR+L5i83d9vJNksxvCygpf7TibFTC+bmRlysQfZfj+WmFyM3yCEyskXbEeY3nL/VyAaNhILoTpLqiKUrRySAzyOBiOwkE4bLevdpsdJlq9MbnYWd6UyP08mMN3VBzGZTl9HbwOjJ/7OUWckoMk5Qx1OaaBq4cxLVWEdzRPuVHNCMohdxPhJtHZ0SWlrsnQdr2htjyiarZ15mKLAvyFM6aYe9BbJFFgInAfz2Sp83RdZS3mxDjBNHHk+nFFIEQ/DBUV4Jmllec2OkbEESY2x7srIx85U2+3qFlzaM5DtAWdcBHBRUTtWWZ/IbURLdy/iT8Oh1ERgFEwjbclXC3ZGcPOayqyIULUsMfcPo+Pe9rnEEhRxVUcvE5EAI7U8ZhwbCbs4gxk7Zm38Xe2jSzC3SxIIIwnBeA6qxVUHCfFP6/k8124zZBdf5HQPHY8fMeK5OKE848P7iNZoz5396Z1gyFca/p5ZSq/ffwOECNlt0Ibp+jocJtAxdLHKfCOjJrFjCC9a6thicLmEt4lydbtEE380lCwgEi6I6Ki8r/T5Zakohb6dxjK9CG+I40S0harPcPdGs6xgiSjIP7iD21oIc+2X9yOhDU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR03MB6058.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(136003)(396003)(39850400004)(346002)(55016002)(9686003)(5660300002)(38350700002)(38100700002)(8936002)(956004)(1076003)(86362001)(186003)(2906002)(6666004)(478600001)(6506007)(52116002)(53546011)(7696005)(54906003)(26005)(66946007)(8676002)(66476007)(66556008)(4326008)(316002)(16526019)(83380400001)(7416002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aFdVS0htUzYraHJWcEdKc3RaUjlreVRYS1ZxN21sUnMrMWNTbzY0SWtiN3g3?=
 =?utf-8?B?Q1l4UnBVanRyK2VNMUJmM1NyZUVyRTJRRm03ZmdBTncxVmhDa0hOYkpId3hr?=
 =?utf-8?B?NTVJZHBPR0VLWW1LRi95TGxnTUNwYzFiU3FPVXF0ZU5HTkxoZWVPNFRLQy9j?=
 =?utf-8?B?eE15Nm5FS25WWEJBU3E2UVhRUTRIYzZaVytLQmVLSDdVYUF5bGt2TEF2MkRK?=
 =?utf-8?B?ZDd0TG83WElyWVJWb3JnMjVBdXM3bHdhSlBYcTRRQkw4ZDJKK2xhQVJuWjJD?=
 =?utf-8?B?WGpLbWcwb1VxVlF3WG5RdUdOYWxDMXRiVkZQVERySyttazRWVGoraFppWXZh?=
 =?utf-8?B?bGw3UFBaVElqb0p1NXVheGV6Vks1a2d5cTA3OHUvd2Vsdnc0U2Q1R3l4VlVj?=
 =?utf-8?B?eUZEOVhOM29ieWJLZVhtZmh3ZlI3VGRRTGRzS0lrZE45cU1OKzdRVE8ydlBH?=
 =?utf-8?B?ejQwMUxBTldpQ3JQdUlvdXFIbFVoeUFDQjU4UjBoMTZKYURveE9PU2E3OE1q?=
 =?utf-8?B?ZHNZU3gvU0wvRDZ5M1o4RVhHMEYwZUEweTlodlc0bGVHSDN6Vit5MVY5M2VB?=
 =?utf-8?B?QXdWaisrRmxRYkJGSUNmenRySHZLV0FrRE5MTklibmNQWDRKSmgxYnc2akZn?=
 =?utf-8?B?N2FHemRjcWZCdjhocjRXeFRiRzZwbFBuVWZDL1VFTDd5SkRHekhrZ05nZUp3?=
 =?utf-8?B?MTN2NFNEUFJRSUVaWVB3bCtRcmtTakhWV1ZJUmcxb0pHeTAvMzVYdnZCYklN?=
 =?utf-8?B?YVNDSFJ0UDJ1cHAzSXArY0o3K2RPNTB1c2V4cFFyT041T3k4ajlpRnQzOUs1?=
 =?utf-8?B?Z21IODFZcG1kRVJDbEsvc1FrN2tVQ090Y2R1MVI0WGVkMzgrSTFjWnlOdkMw?=
 =?utf-8?B?bDM2QXFRTHEzTElHcldJVG9BMmhzSWJvTFpFRzJoZ1g2TmExSVNPeVU2d2xr?=
 =?utf-8?B?RUU0M1lBSWNhNGo3bG5XdzZwcEtwTFdjdzZnb29IczhXTGFMYzZkUWJnNlkr?=
 =?utf-8?B?OU5vZkl5VDVTRHhOcEFYZDNTTW4zY3U1UThNYlR4NndtbTZpd090eTNJVGhk?=
 =?utf-8?B?RE9Ya2tGeGFzbVRYSEwveGs3NmZPdmFGbkhiZFFhdmk5MUpyWUNqeFRUazZa?=
 =?utf-8?B?bDlEazd5VkhhcVRqNk1OcVRNVnA1Zk5KV0FWTlh3bTc5SzY3YlArcmwzZ1BR?=
 =?utf-8?B?Sm1lYkJjWEVUcGsvd3ZpUjNtNWZMeGU1dXVweUFodmc0a1JyR3JmM0xRZVMz?=
 =?utf-8?B?Zk1aeUMvNFBmSEZmVW93TEZzWkhLMVQ2NHhvV0xNTE5sU1ZRR25ZZWszR3ky?=
 =?utf-8?B?QjZYMFdsZ2U4T2pSRjdiRGcxbVYvZlVZS24yK1QxMFVDcHRVcWExakZyQU1T?=
 =?utf-8?B?MkZPcGFxaExjSUdFcXJhMGpXSU41Y2daaHF3ajVsNENldVpNZ0tmRHg5d1l5?=
 =?utf-8?B?T3RscVVrbnZyR080ZjhyaXkydHBDNk5YazIxODA1OW9TT0RqSCt0cHZqdFg2?=
 =?utf-8?B?Qk9CeVgwZlVLY3crZWxocmlFdkZHRzVuV2pBM1BJOFFHRzBNc1l6cGhQZDR6?=
 =?utf-8?B?S0FGUUt6UDBzeVhQcXdlZkZvVHVyYytpa1UyWTU4bXpDMGFqVWFRQ2dmWmor?=
 =?utf-8?B?Z3dNa0FvRzJJR3NKSllTRU45aklSMnZTL2pVWXJ6czliMGlYaGpzeS9peG83?=
 =?utf-8?B?OEhNL2xjZi9vWGh2MW5ZNWE3OGg2WEtPWHMvSkRVbXJydXdSRDQyYk45dzl4?=
 =?utf-8?Q?ZjEgBiLo1T9mt2Dcnh1eGq0yUEqvr2KSXO3HKlb?=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04f5f72d-c82e-4c44-de3c-08d92af351ad
X-MS-Exchange-CrossTenant-AuthSource: BN9PR03MB6058.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 03:04:38.7564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yRRorzEySSbtIz/wYp4UrCv24UloojOU/HQmay0Hf6QfEeUwtY1x/oPwGn3/UK2Vo/+dhUNPC0jkJAibxhNKYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR03MB3012
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Jun 2021 02:51:11 +0000
Joakim Zhang <qiangqing.zhang@nxp.com> wrote:

> CAUTION: Email originated externally, do not click links or open attachme=
nts unless you recognize the sender and know the content is safe.
>=20
>=20
> Hi Jisheng,
>=20
> > -----Original Message-----
> > From: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
> > Sent: 2021=E5=B9=B46=E6=9C=889=E6=97=A5 9:57
> > To: Joakim Zhang <qiangqing.zhang@nxp.com>
> > Cc: davem@davemloft.net; kuba@kernel.org; robh+dt@kernel.org;
> > andrew@lunn.ch; hkallweit1@gmail.com; linux@armlinux.org.uk;
> > f.fainelli@gmail.com; dl-linux-imx <linux-imx@nxp.com>;
> > netdev@vger.kernel.org; devicetree@vger.kernel.org;
> > linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH V3 net-next 3/4] net: phy: realtek: add dt property=
 to
> > enable ALDPS mode
> >
> > On Tue, 8 Jun 2021 10:14:40 +0000
> > Joakim Zhang <qiangqing.zhang@nxp.com> wrote:
> >
> > =20
> > >
> > >
> > > Hi Jisheng, =20
> >
> > Hi,
> > =20
> > > =20
> > > > -----Original Message-----
> > > > From: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
> > > > Sent: 2021=E5=B9=B46=E6=9C=888=E6=97=A5 17:51
> > > > To: Joakim Zhang <qiangqing.zhang@nxp.com>
> > > > Cc: davem@davemloft.net; kuba@kernel.org; robh+dt@kernel.org;
> > > > andrew@lunn.ch; hkallweit1@gmail.com; linux@armlinux.org.uk;
> > > > f.fainelli@gmail.com; dl-linux-imx <linux-imx@nxp.com>;
> > > > netdev@vger.kernel.org; devicetree@vger.kernel.org;
> > > > linux-kernel@vger.kernel.org
> > > > Subject: Re: [PATCH V3 net-next 3/4] net: phy: realtek: add dt
> > > > property to enable ALDPS mode
> > > >
> > > > On Tue,  8 Jun 2021 11:15:34 +0800
> > > > Joakim Zhang <qiangqing.zhang@nxp.com> wrote:
> > > >
> > > > =20
> > > > >
> > > > >
> > > > > If enable Advance Link Down Power Saving (ALDPS) mode, it will
> > > > > change crystal/clock behavior, which cause RXC clock stop for
> > > > > dozens to hundreds of miliseconds. This is comfirmed by Realtek
> > > > > engineer. For some MACs, it needs RXC clock to support RX logic,
> > > > > after this patch, PHY can generate continuous RXC clock during =20
> > auto-negotiation. =20
> > > > >
> > > > > ALDPS default is disabled after hardware reset, it's more
> > > > > reasonable to add a property to enable this feature, since ALDPS
> > > > > would introduce side =20
> > > > effect. =20
> > > > > This patch adds dt property "realtek,aldps-enable" to enable ALDP=
S
> > > > > mode per users' requirement.
> > > > >
> > > > > Jisheng Zhang enables this feature, changes the default behavior.
> > > > > Since mine patch breaks the rule that new implementation should
> > > > > not break existing design, so Cc'ed let him know to see if it can=
 be =20
> > accepted. =20
> > > > >
> > > > > Cc: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
> > > > > Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
> > > > > ---
> > > > >  drivers/net/phy/realtek.c | 20 +++++++++++++++++---
> > > > >  1 file changed, 17 insertions(+), 3 deletions(-)
> > > > >
> > > > > diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.=
c
> > > > > index ca258f2a9613..79dc55bb4091 100644
> > > > > --- a/drivers/net/phy/realtek.c
> > > > > +++ b/drivers/net/phy/realtek.c
> > > > > @@ -76,6 +76,7 @@ MODULE_AUTHOR("Johnson Leung");
> > > > > MODULE_LICENSE("GPL");
> > > > >
> > > > >  struct rtl821x_priv {
> > > > > +       u16 phycr1;
> > > > >         u16 phycr2;
> > > > >  };
> > > > >
> > > > > @@ -98,6 +99,14 @@ static int rtl821x_probe(struct phy_device =20
> > *phydev) =20
> > > > >         if (!priv)
> > > > >                 return -ENOMEM;
> > > > >
> > > > > +       priv->phycr1 =3D phy_read_paged(phydev, 0xa43, =20
> > > > RTL8211F_PHYCR1); =20
> > > > > +       if (priv->phycr1 < 0)
> > > > > +               return priv->phycr1;
> > > > > +
> > > > > +       priv->phycr1 &=3D (RTL8211F_ALDPS_PLL_OFF |
> > > > > + RTL8211F_ALDPS_ENABLE | RTL8211F_ALDPS_XTAL_OFF); =20
> >
> > I believe your intention is
> >
> > priv->phycr1 &=3D ~(RTL8211F_ALDPS_PLL_OFF | RTL8211F_ALDPS_ENABLE |
> > priv->RTL8211F_ALDPS_XTAL_OFF);
> > However, this is not necessary. See below. =20
>=20
> No, mine intention is to read back this three bits what the register cont=
ained.
>=20
> > > >
> > > > priv->phycr1 is 0 by default, so above 5 LoCs can be removed =20
> > >
> > > The intention of this is to take bootloader into account. Such as ubo=
ot =20
> > configure the PHY before.
> >
> > The last param "set" of phy_modify_paged_changed() means *bit mask of b=
its
> > to set* If we don't want to enable ALDPS, 0 is enough.
> >
> > Even if uboot configured the PHY before linux, I believe
> > phy_modify_paged_changed() can clear ALDPS bits w/o above 5 LoCs. =20
>=20
> The logic is:
> 1) read back these three bits from the register.
> 2) if linux set "realtek,aldps-enable", assert these three bit; if not, k=
eep these three bits read before.
> 3) call phy_modify_paged_changed() to configure, "mask" parameter to clea=
r these three bits first, "set" parameter to assert these three bits per th=
e result of step 2.
>=20
> So, if step 1 read back the value is that these three bits are asserted, =
then in step 3, it will first clear these three bits and assert these three=
 bits again. The result is ALDPS is enabled even without " realtek,aldps-en=
able " in DT.
>=20

Aha, I see you want to keep the ALDPS bits(maybe configured by prelinux env=
) untouched.
If ALDPS has been enabled by prelinux env, even there's no "realtek,aldps-e=
nable"
in DT, the ALDPS may be keep enabled in linux. Thus the ALDPS behavior rely=
 on
the prelinux env. I'm not sure whether this is correct or not.

IMHO, the "realtek,aldps-enable" is a "yes" or "no" bool. If it's set, ALDP=
S
will be enabled in linux; If it's no, ALDPS will be disabled in linux. We
should not rely on prelinux env.

Thanks
