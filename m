Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A78312F08E3
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 18:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbhAJRwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 12:52:45 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:10174 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726250AbhAJRwo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 12:52:44 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10AHl1Kh010190;
        Sun, 10 Jan 2021 09:49:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=hRbAXXJnejFCTUHyreOi4wselVmbJQfcJ5hHK8LgERA=;
 b=j4WTcmA9WrmmD8dVI/E2Ud8CI8Rb/mp2+m+X44/7rutEW7dlOP+yx5XZWsjHVJSlxrOm
 1zG+6CqvtOG74hA8RpZivK4bSS5c5Ld5ob/l+1YbizVz7w/6zU5w2Et+3KFSWZ/rFgXZ
 bdRS80QgvS+z4bqTs60+IwAeSXgDuNIRK41sxyJURYqozAGv9IopqpRXWKujXAOTuRkp
 /A+fLNo8oc0lwdsFIiJF8ta5v0P43ZhbNW8TqDoA2s5IQdiUdKo4GL3VWzho0nj7t/1m
 OsbU/BdnzShHspXLemp09hP6z70SHeoDQdZtgIr4/rICxopBxv1gERDcV6xkabyk0OZp XQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 35yaqsjamj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 10 Jan 2021 09:49:53 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 10 Jan
 2021 09:49:52 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 10 Jan
 2021 09:49:52 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 10 Jan 2021 09:49:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MWpDnAqx3Adrrz9oe2hcwfFtLfUMropG0iaAmBMxZhYxWPmbzfwxf6a+7fum9jtNtoWH2kPFeYNq6ACz7jNDcAhkN4fDoI3D/M5mC/Ck6atF7BL4zzcMIWca/nvjDsoIl0/5OJIzRUB6iqs9Ju3XMfBxQLdZvYZL5kkCSf6zNjlf50ubGsECx/4tBKyRyKk+MhAcmhuZUe9li0OB24FELOzgN3cku+pWWw7tPuZYnoIeiDoDM2X5h0cdoCDoCFQLuCJzpBBv7EODNrA7DS8HcsgrrE9RR93rKBRuhBIFf/LoIow+JxbuU81f0zuPvW+rVC7aRlXim9qf1s/Zj+4DVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hRbAXXJnejFCTUHyreOi4wselVmbJQfcJ5hHK8LgERA=;
 b=IrNnzmWqb9J7tnjJJQ84ZZ1jrsHVqKfRuCl/RA7a9CTrascrg4mTX9TmXIAV4veBuuDFXUf/ws2XqGxmeyYcPIKEgRc5ysCd98GgqhFmqXXi8yewvxHmLmDFo9zXaDnPeRn7B6WU9AG197kxWySC4zKupGzWoBwkMErMoMHuHW84arBjAmNOg7F67YU4L0W4n3wgVed4VSzcZGeNq4mmnX5pNLf4c9FjS7Uuk0bPC0UiPrU91zkH0Lltr7JOiJu4tke8noEdw3ZeWab3LQDh99hOOMsqJHmfhp2TPoz9PoPIII9OkNNyLS7H094qMt96YvWN7BH0FsIrltSoDsbMnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hRbAXXJnejFCTUHyreOi4wselVmbJQfcJ5hHK8LgERA=;
 b=sDk9cgUMzLnQEIEQp+LG/gtkghbhzajI0RKVQdGHkDwlnVb4NNJ75JoJR9wPdgQxcAHF3ISLKC9kO8Cob+aGIAf4wOue1Dlqabz9Sm7hlweWd5pPuwu+ZYH0XdlCnCn92a73OaHoN1vUZgS6jAZYoLBoExToeWY5XR3jcM+b0vo=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (20.182.164.23) by
 MWHPR1801MB2015.namprd18.prod.outlook.com (10.164.192.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3742.6; Sun, 10 Jan 2021 17:49:47 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b%7]) with mapi id 15.20.3742.012; Sun, 10 Jan 2021
 17:49:47 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>,
        "atenart@kernel.org" <atenart@kernel.org>
Subject: RE: [EXT] Re: [PATCH RFC net-next  03/19] net: mvpp2: add CM3 SRAM
 memory map
Thread-Topic: [EXT] Re: [PATCH RFC net-next  03/19] net: mvpp2: add CM3 SRAM
 memory map
Thread-Index: AQHW52WtPfi4P1NcGU6aLxAkyBGTaqohFpOAgAAAhYCAAApnAIAAAPyQ
Date:   Sun, 10 Jan 2021 17:49:47 +0000
Message-ID: <CO6PR18MB38733FF528490548137E1ACCB0AC9@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
 <1610292623-15564-4-git-send-email-stefanc@marvell.com>
 <X/szqUG3nr/FrZXS@lunn.ch>
 <CO6PR18MB387341801046DE9663E2FD85B0AC9@CO6PR18MB3873.namprd18.prod.outlook.com>
 <X/s80rM1HBFrkHyl@lunn.ch>
In-Reply-To: <X/s80rM1HBFrkHyl@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [80.230.29.26]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: acee20e3-95ba-48c1-dd17-08d8b5901f10
x-ms-traffictypediagnostic: MWHPR1801MB2015:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1801MB2015F75569C68E8CB277F3D0B0AC9@MWHPR1801MB2015.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YP8HW9HFARE6MRhA43CdBTn0hHBwT8DEsKDNdCL6f4nDfYcGUy+bXoIeG6/IHko5CVw8jpO61Y5PWXrVL4hGbXwHNPIzpUu1ATHEdiENm1VKhXpGsj7HcLsbNmAF81AprXRUs348fFYo4DNh5npqf0NFNNLv6lcX+78nY1b/fKAbn7UEAYhkrvst4cAwkmCl0UvogqPJVLwikDRRAFryurxaVKRoHjUXfw9omcV1RvmsWcOMEp6PkLjJGpdEm//D4B/gwmGfrQ4Eo+R2rbxlUmNGoMwrP7+hgCJOkGf2TFz10Atr9vQrRelfJc5w5o0bmgaQPN/rE5VLw33xtRjpoBvTV9IugAZyZO2K1ILJuwPckoSjvF+O8Fvla8RGE9QLMyS273UySu/gia6B+hcKTQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(366004)(39860400002)(346002)(64756008)(8936002)(76116006)(66446008)(8676002)(5660300002)(66476007)(66556008)(6506007)(86362001)(7416002)(66946007)(9686003)(2906002)(55016002)(6916009)(54906003)(33656002)(52536014)(4744005)(478600001)(7696005)(71200400001)(26005)(316002)(186003)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?eZ3FMIB2TFN+Con5UkpzNxq240aSSLrIFac7ggMzdLgOzcdXp4z6YGRF9NsV?=
 =?us-ascii?Q?3eFGXPuZSWG58soJN9x9ZMgC5WG6ruughGcLfWOtnfX87lFUDl9m6ESvnU9R?=
 =?us-ascii?Q?bk1BXL9YKSqXziXCAzgwzhWl+sHZdY308R+3IqWfGRJNQ82qIyfRwqzte9zO?=
 =?us-ascii?Q?2sUQ3qxjOcyRm1U8c0ByKf08wa8/sKJSowbB0hdl0hMJ03k4Jw9H+YCQR7Sh?=
 =?us-ascii?Q?lLScMxzRk3SR7y+n3IPOXXDLU+Dd3UcubmbHVlSHF5DpHc1hrH0JyL/Pd/ZJ?=
 =?us-ascii?Q?o8Sqm0L/LyxG85yPkADeZYgurKuFcdYsGT1g0xIK30DKE9aoJt6VCJvUj4nQ?=
 =?us-ascii?Q?dOzo3hLZgAl7wcDDT6/XFyviUNfOjFKSd46mItoI1pPaCOnZZLLSLxGPoi6/?=
 =?us-ascii?Q?ZFZtT0FSCV9xZ6Yo3btqgYkeiWvsVjdKGprhhmt/BGEZQSjWGNmTfuna4u5z?=
 =?us-ascii?Q?MEXGg55Px9Eq/ijHTI0lg3rVv/VMvIItJdO/VVluwZA5N8w+g9+HhHCbbDmz?=
 =?us-ascii?Q?FMNLfx1IIH37vHFoTgNEIZgoDTrUDtLW7VXQQu/6wzqUSV3Rc7sr9hlbABuD?=
 =?us-ascii?Q?/focgecmBYs5l4HbUki2T164uvPbDnIjgvxWayRyooT/v799uha/hUaczPA+?=
 =?us-ascii?Q?o1UCLirGemBwFONZMziPpUVWl/Iy0P7mCl/6rbeNJqOHEOx50TYhb15A6KMw?=
 =?us-ascii?Q?+yId0IXbkwmOr+6Yi/th3Y9ojgMdMtse/BhGAfqOMy31rCbRuUbUdYWnh74T?=
 =?us-ascii?Q?UXM+O8JRzZ1uSEVWYuAd/WNrHr3UiA8TkL+SJv03ijExth76oXjE2yloD7M+?=
 =?us-ascii?Q?onxau4AwcEJJrWTN6YVz6eZE8wLFmaXLqnDH22KgfiKur8CtP4TQhEfmKJ2m?=
 =?us-ascii?Q?ChlgSilcq1V61mpTSIgam8k1UhJDbibh8u7Oslp1+c6gYtPam5qMNAM4Mqjc?=
 =?us-ascii?Q?u15WqhztT+CrCNvIG2DJDFwa1wNQnLTpe35lY29Cr1o=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acee20e3-95ba-48c1-dd17-08d8b5901f10
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2021 17:49:47.2419
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gOz8gG01CKrZe2hEH7qKM98svcxle6FfgRuBwD3YELo+CbEHL5+jU2rtnukodBSIuY527YyDlLmWPGAeHtIprQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1801MB2015
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-09_13:2021-01-07,2021-01-09 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>=20
> > > Should there be -EPROBE_DEFER handling in here somewhere? The SRAM
> > > is a device, so it might not of been probed yet?
> >
>=20
> > No, firmware probed during bootloader boot and we can use SRAM. SRAM
> > memory can be safely used.
>=20
> A previous patch added:
>=20
> +               CP11X_LABEL(cm3_sram): cm3@220000 {
> +                       compatible =3D "mmio-sram";
> +                       reg =3D <0x220000 0x800>;
> +                       #address-cells =3D <1>;
> +                       #size-cells =3D <1>;
> +                       ranges =3D <0 0x220000 0x800>;
> +               };
> +
>=20
> So it looks like the SRAM is a device, in the linux driver model. And the=
re is a
> driver for this, driver/misc/sram.c. How do you know this device has been
> probed before the Ethernet driver?
>=20
>        Andrew

You right, I would add EPROBE_DEFER if of_gen_pool_get return NULL.

Thanks.
