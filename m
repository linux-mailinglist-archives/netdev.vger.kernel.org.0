Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F227E276C51
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 10:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727311AbgIXItJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 04:49:09 -0400
Received: from mail-eopbgr80073.outbound.protection.outlook.com ([40.107.8.73]:14567
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727244AbgIXItJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 04:49:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wxj3l5iZzcNi9N4m928eiK7ZF1+shN3bc6epZ1JfBODUcNJ330JpkdUJ+nO6Z6PHIsaWPghGrTSOikXsaTyWWlb0rDRGV7Up6geCj/VdkHkkCSfqZs7DgNTid1/x4W/5va2ML6uIdA8maXam9+epifGiEv7NHLGNiYy8vh+ZZ4H1Tw7rzHMQuRPoxTKVDtqFI/zMwM3yyO7vFkPzfawRxGDvTyqbmu+Ml4m7UDoWVU0avcWLvWK8swii6EdB6dJiOovmnIThFyDqo/WMe6gHr8PrRMwhrcsiSMFxxQvS87K1YRNDikLH3Gy1s2rv6xj/rPCzqxi5h3+vPYgnn4402A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dd/LDp1zh89BDjj7ibOtBMYyIiPUQqTEMkC5I1b+tFk=;
 b=nWCHJk+KTEaXZ1CYeoAICQ8of7fVZej/xYRNgEktLhrTE/HLquhvyH5vVgxY7uw+jihGxJbfJm235pJDGpFphuWQb+Rt9G/KXDeWzX8PpRrB8faEgJwflo1mBb+vmqp3rxGpAM3+D+Xr3XGCRwBD1nbgNeswFPqbjH7VePss2tXoMpZHTXAqpMEk+WbAPrvmDdVORmyi63ueUf1xGrpFkIO6V3E3X9F9TL8JsB9DLfZZH76vgZuvEdOtU+WD+EE27husbKWeAS5h/Q2pheFL2wviNB4hn4d6nxquJNQPya8PyUhOeHqlm6ljSbhlu3qJ6PpsoIqJeN4NV2lgrkb2yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dd/LDp1zh89BDjj7ibOtBMYyIiPUQqTEMkC5I1b+tFk=;
 b=iFmNcqiST3yoxoFegerqrOfDqO3Vu0+qfGV2oxf00ugIANpJv47Gp7CSeo1I3moM1MFO/cWecfJpwD61KADIRhmKmwA/MNqLfn3HMITQSflKPpdZBqc5+r12qpSIJ+uuHuD8CcaiHoBHbHrFI2B/cBh3FES159pGyDTG5fS5Grs=
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com (2603:10a6:10:b0::22)
 by DB6PR04MB2968.eurprd04.prod.outlook.com (2603:10a6:6:b::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3391.17; Thu, 24 Sep 2020 08:49:04 +0000
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::2174:5a93:4c29:2cf4]) by DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::2174:5a93:4c29:2cf4%6]) with mapi id 15.20.3412.022; Thu, 24 Sep 2020
 08:49:03 +0000
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "fido_max@inbox.ru" <fido_max@inbox.ru>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Leo Li <leoyang.li@nxp.com>
Subject: RE: [EXT] Re: [net] net: mscc: ocelot: fix fields offset in
 SG_CONFIG_REG_3
Thread-Topic: [EXT] Re: [net] net: mscc: ocelot: fix fields offset in
 SG_CONFIG_REG_3
Thread-Index: AQHWkhknIXVazVOwWE+swO2avJDnIKl3XsAAgAAY5sA=
Date:   Thu, 24 Sep 2020 08:49:03 +0000
Message-ID: <DB8PR04MB5785459EB246027CB9E118D5F0390@DB8PR04MB5785.eurprd04.prod.outlook.com>
References: <20200924021113.9964-1-xiaoliang.yang_1@nxp.com>
 <20200924070816.GS9675@piout.net>
In-Reply-To: <20200924070816.GS9675@piout.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: bootlin.com; dkim=none (message not signed)
 header.d=none;bootlin.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 07043a9a-d32a-4370-2951-08d86066b0ac
x-ms-traffictypediagnostic: DB6PR04MB2968:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR04MB29682451233B2CC96B699F83F0390@DB6PR04MB2968.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WPrD5XTRhl/h3UTBSoDd1GABpYAhFdqkQamFWo4A+0y1tQaxYUN3+dWSUGB/gn7t4JiUTiTgNLBOqDzLy9bRHRtpgOlfox8Q9XmSvc96UtUzLHD1EjPV/g0C2aSMBFVno1U7ep/MlZBHhW0ORxLd7TIodzjO/XlLNWl4eyNC8chxBVX1hsFge/uKIzejPV0M9lC8vToaNTg6ld9C92RuC7R5Ok72LpuNcupjqaHk7JggkHypkMicFk28THIarN86uvPsFIxUbAsIqqrhHTE8zfMm16CqGYMlLpSTkMwZcI7CEJgm2CcTlTyIpM5XPNxvxOLc31lNwydXr2T0O8xe/w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB5785.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(396003)(136003)(366004)(71200400001)(9686003)(478600001)(64756008)(316002)(54906003)(55016002)(66556008)(66946007)(66476007)(6916009)(8676002)(4326008)(66446008)(2906002)(6506007)(33656002)(5660300002)(86362001)(76116006)(83380400001)(186003)(26005)(7696005)(52536014)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 5hzo1BiBPilJ/BjlnW1dwxE29bUgoTwNPpfSEH/beAQLEWe9egHZICchDWmm0g56lIJvHu1nHLtYqhBkdZ6/Xg8DAB1VHmD//TaxM2aYqgfmcwj19g3Lkr6+/yKnwqVlfoJJohAuKUcBfQgjYAY7ae39agP5CramT2zMRdsUh+fsPx0/w+qmIiOoLNBZGbux5mKv1YMF5xg5VMgD1K8O+FH6a23jkQFCQL34DZ1viSQkZUUvgrOFoYUPASyFS1JG5hHFrA0CweTCrrqd3QKIr96iHycVsbBaw/vHpakl4L8EtJceaYhKLEekGJvSuKPJkjh0Qx0TAqW1RpVl80ZD+fb3lOP+qswwLA0kPEkwAHPNgEIzvxPS6L8speRnPHa/f6YLq/5FUahFuUu/GWo4Zu+IQR2/9bEhxkIj/klMXywYkk4J5D8pAjNHBNaLJTBwe8mpycvfknM9qBOR6wIRUIrBauJqddKdP/+ZR12dHvFBIwGreHEcBFC39B/LMQqgzXBEN0lo8NZ0pe3xF+vG0XMb3xcWZn5mJyr3XwskVc7/V2yBu81S5u/19exyBCU2yUJCwA8YmHGEFDKgNZKRf6qznG4Ul9x5FsFoCmpBkLGm2dPSpcEf+B2f9ZCFu6Ihrbs3oagHoUcGd7QrJBk6zw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB5785.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07043a9a-d32a-4370-2951-08d86066b0ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2020 08:49:03.6220
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ts/d4azQoVtjXR5fpT0KcatfB7A47J9AOv/IQBBkOahpBWuQWP8NBLhup9rWcC38ImTEAd9xm/2Bjsac7T8/wzIZTdQIvYicFWJFwCeLpds=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB2968
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexandre,

On 24/09/2020 15:08:21+0800, Alexandre Belloni wrote:
>=20
> Hi,
>=20
> On 24/09/2020 10:11:13+0800, Xiaoliang Yang wrote:
> > INIT_IPS and GATE_ENABLE fields have a wrong offset in SG_CONFIG_REG_3.
>=20
> You are changing GATE_STATE, not GATE_ENABLE
Oh, sorry, it should be GATE_STATE field.

>=20
> > This register is used by stream gate control of PSFP, and it has not
> > been used before, because PSFP is not implemented in ocelot driver.
> >
> > Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> > ---
> >  include/soc/mscc/ocelot_ana.h | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/include/soc/mscc/ocelot_ana.h
> > b/include/soc/mscc/ocelot_ana.h index 841c6ec22b64..1669481d9779
> > 100644
> > --- a/include/soc/mscc/ocelot_ana.h
> > +++ b/include/soc/mscc/ocelot_ana.h
> > @@ -252,10 +252,10 @@
> >  #define ANA_SG_CONFIG_REG_3_LIST_LENGTH_M
> GENMASK(18, 16)
> >  #define ANA_SG_CONFIG_REG_3_LIST_LENGTH_X(x)              (((x)
> & GENMASK(18, 16)) >> 16)
> >  #define ANA_SG_CONFIG_REG_3_GATE_ENABLE
> BIT(20)
> > -#define ANA_SG_CONFIG_REG_3_INIT_IPS(x)                   (((x) <<
> 24) & GENMASK(27, 24))
> > -#define ANA_SG_CONFIG_REG_3_INIT_IPS_M
> GENMASK(27, 24)
> > -#define ANA_SG_CONFIG_REG_3_INIT_IPS_X(x)                 (((x) &
> GENMASK(27, 24)) >> 24)
> > -#define ANA_SG_CONFIG_REG_3_INIT_GATE_STATE
> BIT(28)
> > +#define ANA_SG_CONFIG_REG_3_INIT_IPS(x)                   (((x) <<
> 21) & GENMASK(24, 21))
> > +#define ANA_SG_CONFIG_REG_3_INIT_IPS_M
> GENMASK(24, 21)
> > +#define ANA_SG_CONFIG_REG_3_INIT_IPS_X(x)                 (((x) &
> GENMASK(24, 21)) >> 21)
> > +#define ANA_SG_CONFIG_REG_3_INIT_GATE_STATE
> BIT(25)
> >
>=20
> VSC7514 doesn't have the stream gate registers ans this was generated
> automatically from the cml file for felix. Did that change?
>=20
> Seeing that bits in this register are not packed, I would believe your ch=
ange is
> correct.
Yes, this register is in VSC9959, we need it in PSFP gate control function =
for felix in future. I have tested on VSC9959, the bit offsets are not corr=
ect.

Thanks,
Xiaoliang Yang
