Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3622922E0
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 09:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbgJSHTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 03:19:37 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:10601 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727223AbgJSHTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 03:19:36 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f8d3dfc0000>; Mon, 19 Oct 2020 00:19:24 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 19 Oct
 2020 07:19:36 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 19 Oct 2020 07:19:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TLzpdjxHPZ+KxmwO3RWTbOd2ticVEimp4iJ77feRZCwMUkB+a6e2sdFCIEs5345rLEYoGloUc+jK8K1l38l85vzQRGSgc2+vGYRHZIQr3iiOx83V+0uyWFNmmfC/BykSI5iWhzXcfKC7GPgsqALSMCwmEaVUHw6RTgmOAMJl8JFdtrZqX7pdzYiXyCcAomBEv7cRfhV5eIlnYvRNZIS+nuS5b4L+T6JS3Fj4A0xecsaTjzlT1Ao7c1p3Wt3x/iYZTKC5j+fAIhEDj4HcmSJnsjmVcL1GxeNNZxw9gYb6FbvrATTApTT/1Ucnk9fpAgZHfHuvBxcx5zTm/pGt+DYixw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kAw0BHcelu87tceIWTDcc0RJt2SXiBawmBbnXC9lcEs=;
 b=jUMb+GNiJ80RXkpYkWu2Zv/76Ffz1at3xXzOyQIDIUF7isweZoon2WuuQyJ2DX/RSDVsrb7SXRSJfAydiCh1D831/PAEK+aqDmNbe1DbiJx02pzpR1nTGlOUaiV60qSoZ2olWJc0t/WdAlL8wJ3KGg/2d3BRKPk7QDUivLCEZe1c/DiUmKgfroE5hjF9vIAsfyieejqcQ0kQA3e8oOPjFop+20bqACRoyQcd7rF9D7No9NY8qm7uiDoVf7JIq6vQcBq1V850XmwA4otsnRv5mUDGE2ShMCvgTbeWElMRsjNtkAo/ehMjoX4ncylPh/crMp/BQn/9z9NibVqf7qCqTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (2603:10b6:5:1c4::14)
 by DM6PR12MB4957.namprd12.prod.outlook.com (2603:10b6:5:20d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Mon, 19 Oct
 2020 07:19:34 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::e4a1:5c3f:8b16:5e88]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::e4a1:5c3f:8b16:5e88%7]) with mapi id 15.20.3477.028; Mon, 19 Oct 2020
 07:19:34 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Jakub Kicinski <kuba@kernel.org>, Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>, mlxsw <mlxsw@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: RE: [PATCH net-next 1/6] ethtool: Extend link modes settings uAPI
 with lanes
Thread-Topic: [PATCH net-next 1/6] ethtool: Extend link modes settings uAPI
 with lanes
Thread-Index: AQHWnxvjfEscixWoTUGw9NLDRcgaq6mTAB+AgAEV0YCAAAzGgIABa6aQgAVHPoCAAh/yQA==
Date:   Mon, 19 Oct 2020 07:19:34 +0000
Message-ID: <DM6PR12MB3865B000BE04105A4373FD08D81E0@DM6PR12MB3865.namprd12.prod.outlook.com>
References: <20201010154119.3537085-1-idosch@idosch.org>
 <20201010154119.3537085-2-idosch@idosch.org>
 <20201011153759.1bcb6738@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <DM6PR12MB3865B2FBA17BABBC747190D8D8070@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201012085803.61e256e6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <DM6PR12MB3865E4CB3854ECF70F5864D7D8040@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201016221553.GN139700@lunn.ch>
In-Reply-To: <20201016221553.GN139700@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [147.236.146.106]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 282a68de-61f8-4f1c-da7d-08d873ff54bc
x-ms-traffictypediagnostic: DM6PR12MB4957:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB4957C33E3AF934A3C1C2113FD81E0@DM6PR12MB4957.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1169;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YFCsHg+BNWGeG/3qUX5ScRs+/sISwhzRZdHVOZ+OImnXuHg7K87c3jBPfuc6RXgOzEtPYocMF0mBBJs1aP2KNEOEk/6vkPaYCSDha+a5JeJgowb2uBwAzG8exyyK2ddw4Q+BhMb+AvjjrL10mc7sKY1V4nEQpDePqpH1Oi0k7NMXx+tyOTgfkoFor7RQHCdUyDIcjdKsRGrnst0+8Wn0tPa1fCiZXXEMV+g1uIffrenSW8TvpG+JWsP6rrg7gK4iPUTEndIvkEaLfEB2Vliq+ndxUyfus+//9xuuU1VkojLFIjTLDsGXqh91GIm88HYUK+Bso89DHxQIJpMr4+5XLA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3865.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(136003)(376002)(366004)(86362001)(52536014)(186003)(8936002)(66946007)(64756008)(66556008)(66476007)(76116006)(26005)(6916009)(66446008)(55016002)(33656002)(5660300002)(6506007)(316002)(53546011)(2906002)(8676002)(54906003)(4326008)(9686003)(7696005)(83380400001)(71200400001)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: eWqRbR/DelIAR4tzNZGAO0n5JSbG7AnmHEMyFiYvgKrn+oxFzLQpbWSGNW5W+QlNy7C5L8ml2SFUNVy2ExQ5pgcX45TsHXwY+nOhODw5nRvKsbwRvAPtsHminD28hFOzjaO8QvhZUCEIAQXhmy2QXZFGsUn/Ba3TRV1lNoCCT4epNWrikl7qdl+2ZQsVKdfsAHIeMeIDeUbXLggsGCRvV25IW91GWdnTHTx90KCiTnwUpC9FlTNT5MqMZTuqkMW8W60rnp9f/OHrb6ncbqXQRNLAWmny52NyetJeMsrvLxw2FRjjCqF8z4pE/ZFBqP2/Vo5d0WhdvdIrwS4d7tm9HyuuoGwCe13UKfI2w4J3B+vGK+v9GPtjp4V6W6ST/mKnBiLxO5VkUv/51xSQEaGlCHGl0GGZHkwTgf5JGoD515uUSydWBPddZ1HHsbAKzZjaG2URJP9u8rMstg6IjSPvZYe2QWM+vTapggIKfZFW6r8p3cbYXBc3x7AIpKXXGqGp8CKXm3gOMsdSyQxw1OOcO5uM0WPcGUI6RIBTN0HOHvKr9T0/Ox3DawPZ+9N9byjFW5abQeoa34SfdKHDoE7eOcGWUzq7qtgApY34lqx9nC1JTLnbhczZnRwWaxZcdgoPl6f7CJGGbODKJtuuYp4W3g==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3865.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 282a68de-61f8-4f1c-da7d-08d873ff54bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2020 07:19:34.8022
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5VTPBuChX8n7OlXcn33N3CVNNlmthgQE97U/QfVXYMiLmhRGauwBpkmdWV9IeISYxIB/9SsAiuEkv8YoYAXSSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4957
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603091964; bh=kAw0BHcelu87tceIWTDcc0RJt2SXiBawmBbnXC9lcEs=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=O3z4n6t5PowYl1Nwj7LDOvuVcE439+Zlz+DM9ibnswcNRh27Oj/zRRZQeKZn2dkr0
         jKEQVtvThV/TceMz+CjsVSICbuv+9zDbc1H9CThG64scOC5ORTGku9BH7IbJt7iBCz
         fNdLqVkI/Y+O75sPHmmlCP0bCgBkmHl14Tc5RX5kyI0VoqS3QCPB8K2AohqN4J209I
         o9vuXhVT5J9J5waxf+gycaEXbWk80YbGKYDmG8W03t4PuF9WIiQ6FsYX9XBw/12fnv
         tMvXFvoqNCMgCiqAMEkmc5DJtpyV8prGRrD5MU7ccv+d13TXWyjV0JaJNtf7NCZ3J2
         5ldyKBH/IFD1g==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Saturday, October 17, 2020 1:16 AM
> To: Danielle Ratson <danieller@nvidia.com>
> Cc: Jakub Kicinski <kuba@kernel.org>; Ido Schimmel <idosch@idosch.org>;
> netdev@vger.kernel.org; davem@davemloft.net; Jiri Pirko
> <jiri@nvidia.com>; f.fainelli@gmail.com; mkubecek@suse.cz; mlxsw
> <mlxsw@nvidia.com>; Ido Schimmel <idosch@nvidia.com>;
> johannes@sipsolutions.net
> Subject: Re: [PATCH net-next 1/6] ethtool: Extend link modes settings uAP=
I
> with lanes
>=20
> > Example:
> > - swp1 is a 200G port with 4 lanes.
> > - QSFP28 is plugged in.
> > - The user wants to select configuration of 100G speed using 2 lanes, 5=
0G
> each.
> >
> > $ ethtool swp1
> > Settings for swp1:
> >         Supported ports: [ FIBRE         Backplane ]
> >         Supported link modes:   1000baseT/Full
> >                                 10000baseT/Full
> >                                 1000baseKX/Full
> >                                 10000baseKR/Full
> >                                 10000baseR_FEC
> >                                 40000baseKR4/Full
> >                                 40000baseCR4/Full
> >                                 40000baseSR4/Full
> >                                 40000baseLR4/Full
> >                                 25000baseCR/Full
> >                                 25000baseKR/Full
> >                                 25000baseSR/Full
> >                                 50000baseCR2/Full
> >                                 50000baseKR2/Full
> >                                 100000baseKR4/Full
> >                                 100000baseSR4/Full
> >                                 100000baseCR4/Full
> >                                 100000baseLR4_ER4/Full
> >                                 50000baseSR2/Full
> >                                 10000baseCR/Full
> >                                 10000baseSR/Full
> >                                 10000baseLR/Full
> >                                 10000baseER/Full
> >                                 50000baseKR/Full
> >                                 50000baseSR/Full
> >                                 50000baseCR/Full
> >                                 50000baseLR_ER_FR/Full
> >                                 50000baseDR/Full
>=20
> >                                 100000baseKR2/Full
> >                                 100000baseSR2/Full
> >                                 100000baseCR2/Full
> >                                 100000baseLR2_ER2_FR2/Full
> >                                 100000baseDR2/Full
>=20
> I'm not sure i fully understand all these different link modes, but i tho=
ught
> these 5 are all 100G using 2 lanes? So why cannot the user simply do
>=20
> ethtool -s swp1 advertise 100000baseKR2/Full
>=20
> and the driver can figure out it needs to use two lanes at 50G?
>=20
>     Andrew

Hi Andrew,

Thanks for the feedback.

I guess you mean " ethtool -s swp1 advertise 100000baseKR2/Full on".

First, the idea might work but only for auto negotiation mode, whereas the =
lanes parameter is a solution for both.

Second, the command as you have suggested it, wouldn't change anything in t=
he current situation as I checked. We can disable all the others and leave =
only the one we want but the command doesn't filter the other link modes bu=
t it just turns the mentioned link modes up if they aren't. However, the la=
nes parameter is a selector, which make it much more user friendly in my op=
inion.

Also, we can't turn only one of them up. But you have to set for example:

$ ethtool -s swp1 advertise 100000baseKR2/Full on 100000baseSR2/Full on 100=
000baseCR2/Full on 100000baseLR2_ER2_FR2/Full on 100000baseDR2/Full on

Am I missing something?

