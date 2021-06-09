Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22A133A09B1
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 03:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232412AbhFIB6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 21:58:45 -0400
Received: from mail-co1nam11on2040.outbound.protection.outlook.com ([40.107.220.40]:38881
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229685AbhFIB6o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 21:58:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YuZk5xO3a6afRhuf6CkYysZUoiKsfDXrY2aRfZUVMDp5NlF5jxFXynLiwMMqpS4NGdwMLFoYViAJS0uN0ioo4ihivKyX6kvX2IZPcV+l6gAt7IYKh06JPm4SUdk97FMSNx/UCEoqAvF6DOmbAkktqdb8XPkk80injsulaLriKzCEXUKVXEeStd1iKHjLtj6Gh9uRv5IMla4bi36UL9ngVyeBUl5QX7wadLQAOvrMZGT1tg/jRcXCHCQmsWl3yDoH68SDU5uGBvWHcpH/ytlbGbSe2nDO/VI4gL9usIHt1esqp+LNozd8g/+ICn2D0oHCmySMIIlqdAhI5V112vXlBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=geyXtBUQOGZacyUb1xHSiDxb9DOBM00lEO77OV0Dy7A=;
 b=iHSnwePuRS1O6TNcQJxlTAkjftphOCISouD8KfiOhNopJNFy9E70q8N7aIZLi6pltSIzwjWGG4UF3vaJ971nNvmzGKChHKq0x1uI6Sq6kY4nK9PvfIn6B7OLZdfFz/ohTBCalpRgTeXxx4oNfsFFug3eW1lDbG0Gdzr0xHuRRxaQCd8jDs8/gI+YpSu89RaE9Ic9Nnp5mokPnxwPqUq1J9sEgj4XLOlmh1rQbvUkGxd/9jAW4+1ZdEjF3opD//No3+2phjet3MzpdFpuSJiFpTS5FotX8InFBeA9UGLg7CcbR4oI9+dVzz7fCUSODv1BNh2l36Y3hHVS6uVMfg5xaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=geyXtBUQOGZacyUb1xHSiDxb9DOBM00lEO77OV0Dy7A=;
 b=hoOrrJFmNb05H/UVPRIo332aRTMUWWrQOS1CleffgKD87vCETF8r96eSNO0CMgz/6lMZ6dh+pjC16tUVgc4ua2Jway2d6Hu8xgMtScROO939LojejN8IA75DTUpqHgFtPDrkrBu8Mw9XkqIp1njfjIDr48hWo/HyDiEzfw0dBRk=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=synaptics.com;
Received: from BN9PR03MB6058.namprd03.prod.outlook.com (2603:10b6:408:137::15)
 by BN8PR03MB4788.namprd03.prod.outlook.com (2603:10b6:408:98::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Wed, 9 Jun
 2021 01:56:48 +0000
Received: from BN9PR03MB6058.namprd03.prod.outlook.com
 ([fe80::502a:5487:b3ee:f61c]) by BN9PR03MB6058.namprd03.prod.outlook.com
 ([fe80::502a:5487:b3ee:f61c%4]) with mapi id 15.20.4219.021; Wed, 9 Jun 2021
 01:56:48 +0000
Date:   Wed, 9 Jun 2021 09:56:33 +0800
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
Message-ID: <20210609095633.1bce2c22@xhacker.debian>
In-Reply-To: <DB8PR04MB6795D312FDECF820164B0DE6E6379@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210608031535.3651-1-qiangqing.zhang@nxp.com>
        <20210608031535.3651-4-qiangqing.zhang@nxp.com>
        <20210608175104.7ce18d1d@xhacker.debian>
        <DB8PR04MB6795D312FDECF820164B0DE6E6379@DB8PR04MB6795.eurprd04.prod.outlook.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [192.147.44.204]
X-ClientProxiedBy: SJ0PR13CA0150.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::35) To BN9PR03MB6058.namprd03.prod.outlook.com
 (2603:10b6:408:137::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (192.147.44.204) by SJ0PR13CA0150.namprd13.prod.outlook.com (2603:10b6:a03:2c6::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.11 via Frontend Transport; Wed, 9 Jun 2021 01:56:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 03c3bd5b-da86-4925-1a58-08d92ae9d76a
X-MS-TrafficTypeDiagnostic: BN8PR03MB4788:
X-Microsoft-Antispam-PRVS: <BN8PR03MB47886579469418359917F0B4ED369@BN8PR03MB4788.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qctvepDD0bZc8/FiPNqRGZHhXvOfHI80KpKw79a4oKDlsXCzhYSdr/uWM3sYLgXObE4bZhFVLDrDCsCCuM1UfmHOiMOjXJKRo8Qtdlq20Dqy0IGpEZs0rIlmADZfoQpiPZY6y3OPxRgPztPSxSTj/YD/2hsSyBtbgLxe2LlMWbqykglr3sXHO5kgEufIibSzF4jVjioVCcjL8aIFnBz+x6hvrL26XGdYZxzdazEWvDrVf79WBudkNDY3TjgjszkvshBpJdnaRts9b/Rtt54/r2/bKNMpsjAWcAibB2j+cDkNa2h/1nar5QvNjdktdXjHKoCBVs2RIdxtUvibpQHtoWEQXKSgr3m+SoFzfHTwrx+Qx+jOpjY6gIQ4pzi64Jt/L5G9XYuTUxKWIBf1TfgiASMyaTrdraV4mD0clRz5uYTlyhFKZ/afxPr8BKT91BEHXcRwcbBMBeBl7f7qSmyadi8Gcr7+vm7ybWjZ/qE8KSZcgNCzffSCcqFj3JpwpLJTl60lIoDHGRLkEfEKEDCpRpGH1CgKO2Kf+LXXTJoUQy/1Ig6xEl1TUhr1Ww9VUzdp1pIX7XT1+fLiXd6jXhdS7bpTCEsWxwp2dLmwspZ5gtgxvUF4d7vt/hzVvP+ppI0vJxz1YV8qiCmaOEZtI4KukJzAZzoH24iRFTCJmRiMKyU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR03MB6058.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(396003)(366004)(346002)(136003)(376002)(83380400001)(54906003)(53546011)(186003)(6666004)(478600001)(7696005)(26005)(66946007)(1076003)(52116002)(8936002)(66556008)(66476007)(2906002)(6506007)(8676002)(9686003)(956004)(86362001)(5660300002)(7416002)(38350700002)(4326008)(16526019)(38100700002)(316002)(6916009)(55016002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N2NWblgrSHdIYTB2OWxpdnFZM2xtNGJ5dS9WcDBrZ1BKaGtZYmNDMEl3TWVw?=
 =?utf-8?B?T1haM0pNK1FBeFp1UFVJNFArSzI3K0RDaTVnWWlWOEd6TWxxUVg2Rm5SK0hL?=
 =?utf-8?B?ZGE3T3hHTmRtQndNZjZRdGt5YmI5VmgyaE4xWndEQ2NMOWdLbmRLYVJPM2xZ?=
 =?utf-8?B?bUkrRXM3MmUyRlRVQldNaU9kUmY3MEplTGhrSy83bndUZXlpQmhZTTFlbU9M?=
 =?utf-8?B?L2U3cTlvVyt0V2RQMDJjSU9XQThPMGY1NjBkb3p4VitKTXVkUDM0akdVZExa?=
 =?utf-8?B?czRaUWxFNjc5c2taeVZrcXRCU3cyZkJNOW5jTUNxbjF3NlpGcjg4VlZna3BI?=
 =?utf-8?B?UmpndzRkcHZlSW9tVi9neUdBcjQvcE9CZVA3dEVwQVRJT0xQbFRVcnNnNVhP?=
 =?utf-8?B?dDdGRDVpY1ZTRmZ6TDZXcGgxOTQvc09xMDNJblRUNkZ3NGR6TXB0THQyZjNP?=
 =?utf-8?B?ZUI2WEJOQ1BtMnFkSk1JVWo4bU1Belo5Z2VIZ0c2dWpQalM0OTBnNHB0eFZP?=
 =?utf-8?B?eUdUblZIUUtmN2hKT2tyOWtFL2VsMGNjRURtQUdyc21SVm9EYk4yVjBJRmk2?=
 =?utf-8?B?WWRDRWFwOThvclFGbGhMT3pPMkxFamxTa2paK3EwbGt1aHZPZU5acFhsOHdq?=
 =?utf-8?B?Z1ZtQUhBQVowck9aWkNldm1JY2lGUGpWMjRwbHlja2JIc0JjSFlCOFlKTWxZ?=
 =?utf-8?B?R2RVbVl4WlhzUlpjMWs0bEsyb0RndzlXZmk2WHFUM1ZnU0tWZEpGQWMzaFMw?=
 =?utf-8?B?NE9xME5JbTZyTEd3bWlPdW84UEhzZmEzVitvT1YrSWVoWkRYNlpocVZFSldV?=
 =?utf-8?B?aGQrQUhOSVpSRHp6M0s2YTBPQ2syRXZ4VkFCaEdtejlGMldmWnIwdGVZOWhn?=
 =?utf-8?B?czFTQ3Q4YmdWYUs1aWMxNGpSSmJzNFA3bUdYY2pxNFVDdEdjeklkOVV1Ymlu?=
 =?utf-8?B?YWNuRkhra2hiYVRnRVhHRzY2OGpsQmVHbUEwNzU4cVZVYm53Yk1wRVR2bUlw?=
 =?utf-8?B?eXNOL1F5N0RqTTdoTjQyT2VvYnp6dUxpc2F2YkZ3cUxpVEQ5RHRKS3I4SCta?=
 =?utf-8?B?UWNZWFlzSVl2NWZvcldGR0wxcHhwd0pscE16VGZ4VlpSUXNsZml4RHQvUzhK?=
 =?utf-8?B?OVZvSFZBdDVmbXhuRUI4UXRlVHBxVWppYSt1cVJEOWV4aHZTY0F0VFdmRElW?=
 =?utf-8?B?WWw0TmJQOXg3cTZFNlIrVVE2cnExNFRhY0ExNGw0VldKdjBBWVpveW5kNGNW?=
 =?utf-8?B?V1UvaE9yZ2R0b1VQNGpBZW5TZVlKcENndkc3ZmtGRjM0TTNLRVRhaXhDSXJT?=
 =?utf-8?B?RGVkYkRPSGxFTXFtQlRMNEdGWXp5eDlHaFkvWnh6Vkc2L09XbzVjZDVVKzhs?=
 =?utf-8?B?Z2k1cjJUUVkxTVdGZVRmL29YNDR0LzZlblZPWWVtMzVzM09ydUdTYVhWbysv?=
 =?utf-8?B?bldSZXZLZVMrVHpyZkJHR1R1ZmV6aFNMY2w3WFl6VThWdGR2a0RqY1BiMC9a?=
 =?utf-8?B?TDlNQ0NLOG11UnErSXI4alMwMmgzMDhJL1lDbVA3MHR5NVBzSzNuYmY4aDFz?=
 =?utf-8?B?TFkrRkRmTmV5NEZncWNGeTRhQmhPNFJtWHdneURNbktVaEVEeFBqZEVXaVpi?=
 =?utf-8?B?ZVVkazF3citobW5mNjE1SlJraEQzclhTcGRJZ0s0djNpTW1yK1lwTkoxUUg4?=
 =?utf-8?B?UHBUOVNLNlk5QjExUXdMN281MEo4YkMreUpZNnBKZ2lwUFJHYk5iL0Fnandk?=
 =?utf-8?Q?SVqO/YCOOvTzSnJEsVn/gR02sZdvQHSJ/y3B7NP?=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03c3bd5b-da86-4925-1a58-08d92ae9d76a
X-MS-Exchange-CrossTenant-AuthSource: BN9PR03MB6058.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 01:56:48.0532
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kpP8Umna6A9s0gvCBiQEbaGon585jVci22DhlN6VOObpoOVKk4BzPtKoXAD9mEqtpKqHom8ds5KCc0ColjIYoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR03MB4788
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Jun 2021 10:14:40 +0000
Joakim Zhang <qiangqing.zhang@nxp.com> wrote:


>=20
>=20
> Hi Jisheng,

Hi,

>=20
> > -----Original Message-----
> > From: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
> > Sent: 2021=E5=B9=B46=E6=9C=888=E6=97=A5 17:51
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
> > On Tue,  8 Jun 2021 11:15:34 +0800
> > Joakim Zhang <qiangqing.zhang@nxp.com> wrote:
> >
> > =20
> > >
> > >
> > > If enable Advance Link Down Power Saving (ALDPS) mode, it will change
> > > crystal/clock behavior, which cause RXC clock stop for dozens to
> > > hundreds of miliseconds. This is comfirmed by Realtek engineer. For
> > > some MACs, it needs RXC clock to support RX logic, after this patch,
> > > PHY can generate continuous RXC clock during auto-negotiation.
> > >
> > > ALDPS default is disabled after hardware reset, it's more reasonable
> > > to add a property to enable this feature, since ALDPS would introduce=
 side =20
> > effect. =20
> > > This patch adds dt property "realtek,aldps-enable" to enable ALDPS
> > > mode per users' requirement.
> > >
> > > Jisheng Zhang enables this feature, changes the default behavior.
> > > Since mine patch breaks the rule that new implementation should not
> > > break existing design, so Cc'ed let him know to see if it can be acce=
pted.
> > >
> > > Cc: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
> > > Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
> > > ---
> > >  drivers/net/phy/realtek.c | 20 +++++++++++++++++---
> > >  1 file changed, 17 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
> > > index ca258f2a9613..79dc55bb4091 100644
> > > --- a/drivers/net/phy/realtek.c
> > > +++ b/drivers/net/phy/realtek.c
> > > @@ -76,6 +76,7 @@ MODULE_AUTHOR("Johnson Leung");
> > > MODULE_LICENSE("GPL");
> > >
> > >  struct rtl821x_priv {
> > > +       u16 phycr1;
> > >         u16 phycr2;
> > >  };
> > >
> > > @@ -98,6 +99,14 @@ static int rtl821x_probe(struct phy_device *phydev=
)
> > >         if (!priv)
> > >                 return -ENOMEM;
> > >
> > > +       priv->phycr1 =3D phy_read_paged(phydev, 0xa43, =20
> > RTL8211F_PHYCR1); =20
> > > +       if (priv->phycr1 < 0)
> > > +               return priv->phycr1;
> > > +
> > > +       priv->phycr1 &=3D (RTL8211F_ALDPS_PLL_OFF |
> > > + RTL8211F_ALDPS_ENABLE | RTL8211F_ALDPS_XTAL_OFF);=20

I believe your intention is

priv->phycr1 &=3D ~(RTL8211F_ALDPS_PLL_OFF | RTL8211F_ALDPS_ENABLE | RTL821=
1F_ALDPS_XTAL_OFF);=20
However, this is not necessary. See below.

> >
> > priv->phycr1 is 0 by default, so above 5 LoCs can be removed =20
>=20
> The intention of this is to take bootloader into account. Such as uboot c=
onfigure the PHY before.

The last param "set" of phy_modify_paged_changed() means *bit mask of bits =
to set*
If we don't want to enable ALDPS, 0 is enough.

Even if uboot configured the PHY before linux, I believe phy_modify_paged_c=
hanged()
can clear ALDPS bits w/o above 5 LoCs.=20

Thanks

>=20
> Best Regards,
> Joakim Zhang
> > > +       if (of_property_read_bool(dev->of_node, "realtek,aldps-enable=
"))
> > > +               priv->phycr1 |=3D RTL8211F_ALDPS_PLL_OFF |
> > > + RTL8211F_ALDPS_ENABLE | RTL8211F_ALDPS_XTAL_OFF;
> > > +
> > >         priv->phycr2 =3D phy_read_paged(phydev, 0xa43, =20
> > RTL8211F_PHYCR2); =20
> > >         if (priv->phycr2 < 0)
> > >                 return priv->phycr2;
> > > @@ -324,11 +333,16 @@ static int rtl8211f_config_init(struct phy_devi=
ce =20
> > *phydev) =20
> > >         struct rtl821x_priv *priv =3D phydev->priv;
> > >         struct device *dev =3D &phydev->mdio.dev;
> > >         u16 val_txdly, val_rxdly;
> > > -       u16 val;
> > >         int ret;
> > >
> > > -       val =3D RTL8211F_ALDPS_ENABLE | RTL8211F_ALDPS_PLL_OFF | =20
> > RTL8211F_ALDPS_XTAL_OFF; =20
> > > -       phy_modify_paged_changed(phydev, 0xa43, RTL8211F_PHYCR1, val,=
 =20
> > val); =20
> > > +       ret =3D phy_modify_paged_changed(phydev, 0xa43, =20
> > RTL8211F_PHYCR1, =20
> > > +                                      RTL8211F_ALDPS_PLL_OFF | =20
> > RTL8211F_ALDPS_ENABLE | RTL8211F_ALDPS_XTAL_OFF, =20
> > > +                                      priv->phycr1);
> > > +       if (ret < 0) {
> > > +               dev_err(dev, "aldps mode  configuration failed: %pe\n=
",
> > > +                       ERR_PTR(ret));
> > > +               return ret;
> > > +       }
> > >
> > >         switch (phydev->interface) {
> > >         case PHY_INTERFACE_MODE_RGMII:
> > > --
> > > 2.17.1
> > > =20
>=20

