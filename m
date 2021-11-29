Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C62F4613C7
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 12:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242771AbhK2LXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 06:23:10 -0500
Received: from mail-vi1eur05on2117.outbound.protection.outlook.com ([40.107.21.117]:12800
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242074AbhK2LVH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Nov 2021 06:21:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dkfb3RSwnHVBQ2Ig2Zw04771pRUOjMGdmegbmfyo7DHFqXpbnjR5vntI/PNda9t2bZAs+KrEHnvNglwvMq8ypK6WsARBFJgae2nPHTNouPQy1zk3vP+cOItRr+ibOpiwDZdnmSe0BhnBOLPITqHdDt6GTGbTMLVbVeUvc7McXIYO+A317gLLsiKl0JcgRgZekgNAUsjL+9xaGkdj5YcjY0IaNANn2nYUIMGkRe9FhCCrwTRbSzMdrrMkKEb7dXJ/be5RUMb6je9Ehn/GTepCtF2mGSXs9R7gkgN91JKQ5+TfBGW49ssLkKqQs2up0joUvsgN3+tB3Ekpl8A5/WPLPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AXsipE5JcKY6hIsBtEUbbUd5iNNDEBsjVDeBMM5oERg=;
 b=Z0PLETFIkny3mdricEqZxiwl0rfcWVR10z6w+Xp4VUwVtD6IkDNcuIA5uWbI27RziQk8VKf/UXvh87eFSAjg6jZd897BPketvIDM+5ZGoflf3Dxo/fGVnvHnjqA7o40IoU9Y/+7N0Fri4pMGmz55nUXYK8HRAEWNrwjh6xhbZCkNTr80WPq6TRxi4b7NrdazL0OlPRnJ1UmxC4wLZ3hKRW12MzsTbmqTE0MClUpe1fqFFpygAkOfH8khbju41Jl+W1Z2QeYh7tNTatBiAH53WWsxM0Fv/UpyiyfkcbJj17W0DE8iOOeOP1jiuugJPs8OtpJbWSTvBcCG4GcHi9Ox2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hitachienergy.com; dmarc=pass action=none
 header.from=hitachienergy.com; dkim=pass header.d=hitachienergy.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hitachienergy.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AXsipE5JcKY6hIsBtEUbbUd5iNNDEBsjVDeBMM5oERg=;
 b=GsWHph7v0V+NCDOuKKHffCtGZv3vnYVY/UmpDMRA0x9jlD4/eNIYoSGV4mg8wQrBYPQZdq0uDTVr058WpNuV1JX+OJszTQb2U4ILHq2SwcNOgOeat7SqxJlBe/5b5xow3O+J1KlVZIyPUabEv0gzcGjYO3ELt79oAM8i+aBXT332p3+i9sb5YmB10OTWhcpXi7eHufjBkncsKnWqjApp7DW29LV0wRJdE+XKVaRJT1yuKocis3WKVnev/vrz+ap15Wge3+02if4iAdd4LHYkYmkFpp6+q+6Pa/2q27GpSqXz8tqESL70RqmvL2LiXAOCtBOoHPRET9QzNs8yCrWx2w==
Received: from AM0PR0602MB3666.eurprd06.prod.outlook.com (2603:10a6:208:2::19)
 by AM0PR06MB6435.eurprd06.prod.outlook.com (2603:10a6:208:19b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20; Mon, 29 Nov
 2021 11:17:48 +0000
Received: from AM0PR0602MB3666.eurprd06.prod.outlook.com
 ([fe80::845d:9ff2:f8d4:779]) by AM0PR0602MB3666.eurprd06.prod.outlook.com
 ([fe80::845d:9ff2:f8d4:779%6]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 11:17:48 +0000
From:   Holger Brunck <holger.brunck@hitachienergy.com>
To:     =?iso-8859-1?Q?Marek_Beh=FAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: RE: [PATCH 2/2] dsa: mv88e6xxx: make serdes SGMII/Fiber output
 amplitude configurable
Thread-Topic: [PATCH 2/2] dsa: mv88e6xxx: make serdes SGMII/Fiber output
 amplitude configurable
Thread-Index: AQHX4txS8D4G0DBu/021bqVbJ7ZqkawWOamAgAQlTsA=
Date:   Mon, 29 Nov 2021 11:17:48 +0000
Message-ID: <AM0PR0602MB3666A56A4BB143F3BB45346FF7669@AM0PR0602MB3666.eurprd06.prod.outlook.com>
References: <20211126154249.2958-1-holger.brunck@hitachienergy.com>
        <20211126154249.2958-2-holger.brunck@hitachienergy.com>
 <20211126205625.5c0e38c5@thinkpad>
In-Reply-To: <20211126205625.5c0e38c5@thinkpad>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-processedbytemplafy: true
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hitachienergy.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4b7a0bf8-3092-4866-38ba-08d9b329dffc
x-ms-traffictypediagnostic: AM0PR06MB6435:
x-microsoft-antispam-prvs: <AM0PR06MB64353EF87EF81B27A89C20F9F7669@AM0PR06MB6435.eurprd06.prod.outlook.com>
x-he-o365-outbound: HEO365Out
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r0UJyr1eQ4t2JIgtU0VOC7ntMpsKg18IXF3yUeLrteAY9SxDC6t770W79qXGMmBvRJjArGS4Y0kYCUku71P8CJVdOOKQDNvUaOlVX5FK8poc0gVPhviKpgCIovijU5Z0Dnjv8A4n6rgbFJ0RkuhRb77J3QD0zN80C10OBSXbHoZelV1jbAe1U8gvpZM9qUOP0zlO9a3qeuKNDsDi9R5BlJnaxGkvZ9tq2eApkIomN99JYEf5ociswn5njUGdIKrjJZtrEzSxqdOFFZIGxMHQ+9eAJlJGPnFisiaZFP0xXls3r7Eiw9O+i5dxKW5fX60znt8qB3C1HGi1g+Uk2fVCCyjdG86jVp1qP/p5kj3Wg0hEFh2XbgWglCgifCzbW55F3nCIMqUb4xQbt8DuSUpDdbosRUQQIi9wM/HkKw1jwnc8RhuLT4qxqigh7LycCW7Ytecn325g3W9LvTBtMrbhEygvd73rxZmpYkY+trtPlamA7whwmT3nNcaRLHIxE9JJclfgq9WfhkyLBgVWUQi+JdOM2uMjyEOrmobrFt75I2d5BnCRkq/QS2gfkaUM9xJF8a462+tEG9XzWzMBiJJZLwpMr/NG+rXOjErMuWcHTuRkCZixElrSFpTeol6bjzS+ubnXesFPZ8ZpYealNb0YuJ2wq4CZXcG4Qnv1jDjGaFEQ6y3aikx0VLV7RhuWealuYUZd7rg5LF5TosE28mhFWw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0602MB3666.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(508600001)(26005)(38070700005)(71200400001)(8676002)(8936002)(52536014)(110136005)(186003)(83380400001)(316002)(2906002)(55016003)(44832011)(4326008)(33656002)(82960400001)(7696005)(86362001)(5660300002)(66556008)(64756008)(66446008)(66946007)(6506007)(66476007)(9686003)(122000001)(38100700002)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?bj1Wb8Io2VUZ9zYym3lCOE7NqOimq+CL/Hq0ZwnX8HMaEQGCKTXB6fGUXq?=
 =?iso-8859-1?Q?7BCov3hWICsgmnQFnSRdfkw9fxBKtryLy1enAEikr/HwwTAF1O6YHJ2ELn?=
 =?iso-8859-1?Q?WRvoMTVTsUK0xJLRWtn5nQGRCp9biGnLDYgHc1sGAG3eCAtqAQhN3z+qVF?=
 =?iso-8859-1?Q?FLjXP8vyFkCPNhvIrKig3Smoc+a22NU0XYvuzDcSTDhSXnHBX0Qc7XoDjP?=
 =?iso-8859-1?Q?FemShxlB2JpAS0cNkDYb8calm1qOsPs6rehY4xBn4zRcL5IvMTp3L5FzhP?=
 =?iso-8859-1?Q?n8bUDAXaKQUFF6XACwjlCr05jA0/xJTx2PXnfNFL8fU4v6cewgod9WR+FS?=
 =?iso-8859-1?Q?P5VlA+h8MAX1oeo7Usc86v7PxbIXdSNixFi/K+5NRPyP+iwuM5aDBJ9osU?=
 =?iso-8859-1?Q?3VWZwgjr20Dhuc8ofb1BzYhlP3UYbyyVLqIkNulA1PO45NaqsAoJOMOx+B?=
 =?iso-8859-1?Q?fZwiRaHozTWHhfz0Aj34FXQiIytkXBwsF+so86ukB+C6dEhH0Hi07BM1dx?=
 =?iso-8859-1?Q?FCaz4IfYrZ/lSQWIE69+5jeBdqMoV0vWHN2oRO78SsNf5yYc+GJ8mA80Br?=
 =?iso-8859-1?Q?A101D5o048U6LFNMVDXmk0h+W5WS72IX+YYApWeywgKCt6/OO2Aa7im/jT?=
 =?iso-8859-1?Q?b87W5yQQGr6QQpuCF5VdWq7RJwjyTFrntgVe2/KtXEAt2DDHV7+RMORecZ?=
 =?iso-8859-1?Q?ZYsvE0mRtHeILUTth9THgrfWYEoWot6DNN6KuYo89FFLtR4xpTXtXYJYdR?=
 =?iso-8859-1?Q?Cx1c+7ia/UEFRg0m4B3wKzyOWTloiBW4Mc1FE+BOZ57JP4I0sTj6Sf/FM2?=
 =?iso-8859-1?Q?nNeRft90PDFKqFUUv14pWCF3LvDf/3BwuKETervWLj7DCpWTMnO0B5UXWj?=
 =?iso-8859-1?Q?ulAoYMN5dfARrIC5vEwcxRHUOXaQwX/hWjd50Z+iI8Wj44yJdZTeErfTgp?=
 =?iso-8859-1?Q?9oZwagdJsA54NGXqa7k2N+bhruMib8lMDpuey6vtNn5iuHo+/ujfikBuBy?=
 =?iso-8859-1?Q?megAo0ZJp4ZfFP8etQHz+dAgSRhJxVm5YKAAepo5qreeN7fyyB4h3e+qZ0?=
 =?iso-8859-1?Q?ZMkzy8tmZu2h6JFAByPL76zg+iFv+e21UCL5p89n9KaVGzI0cqwHZoXb5N?=
 =?iso-8859-1?Q?peYcYDZmFfrNqsBOVIae1aBZsyv5OFkXyb4bLdGKsIVxaKhcqwIc1f2VZq?=
 =?iso-8859-1?Q?bxH9ZuVMBvLJgBMygk42c9Uy5XSrErvCJ7kw+yfkMRXumEFKNctoy3rNQq?=
 =?iso-8859-1?Q?qliBnsOwpwFuX5oYge6MVPL2i/Mj9gu5lLq+O5l3yjukBUdt4WKqNn46Cv?=
 =?iso-8859-1?Q?NE02KsHDmKPPqc4GTIxyOUM8D3zjlvZE5hmlwNzACnIZllqhiLbuy5YE35?=
 =?iso-8859-1?Q?Em4RCFlRvA37BotYtnlfM5rFFvXdogLPLx2eREHZn/V19svpnopyDSNKQG?=
 =?iso-8859-1?Q?tZrvaQZOiUhzINA+WoaIcKghf9Mbj7SVXe0RiPq1TWv2HHihFERJCyBAc/?=
 =?iso-8859-1?Q?uBnVU6XU3DzHCGT9f/RzzfsSFm4rEeCmolupFaYof4fNAd9/CD57olXyR5?=
 =?iso-8859-1?Q?N3+asbKp2tqc9MHpd7KjiU+8XDDJ4xWEkqHn2/Mpluwol0rMV1Iv2NVGek?=
 =?iso-8859-1?Q?WmWPJdahJE1sUWPZLwn3BpXZTA6lsfl1YIXhgrX6OYtsPjq/BXVbSmh+I9?=
 =?iso-8859-1?Q?oAHuKH+rAZIFl3idnHVyplBP3XVP5ei02os8HiLyrd2lhX+ma7UZIT/+Aw?=
 =?iso-8859-1?Q?lcSA=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: hitachienergy.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR0602MB3666.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b7a0bf8-3092-4866-38ba-08d9b329dffc
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 11:17:48.1706
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7831e6d9-dc6c-4cd1-9ec6-1dc2b4133195
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Gt4x81qZk3IYw+8N2Oc6MR8e+ZkgYy+A885v0rApqbKxn8Jn0B6hQSsuMXUDVPXpQGaHdN4YwiwvTIvttjgNdtLqlc0D8DqhFrAdTpktDDM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR06MB6435
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > The mv88e6352, mv88e6240 and mv88e6176  have a serdes interface. This
> > patch allows to configure the output swing to a desired value in the
> > devicetree node of the switch.
> >
> > CC: Andrew Lunn <andrew@lunn.ch>
> > CC: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Holger Brunck <holger.brunck@hitachienergy.com>
> > ---
> >  drivers/net/dsa/mv88e6xxx/chip.c   | 14 ++++++++++++++
> >  drivers/net/dsa/mv88e6xxx/chip.h   |  3 +++
> >  drivers/net/dsa/mv88e6xxx/serdes.c | 14 ++++++++++++++
> > drivers/net/dsa/mv88e6xxx/serdes.h |  4 ++++
> >  4 files changed, 35 insertions(+)
> >
> > diff --git a/drivers/net/dsa/mv88e6xxx/chip.c
> > b/drivers/net/dsa/mv88e6xxx/chip.c
> > index f00cbf5753b9..5182128959a0 100644
> > --- a/drivers/net/dsa/mv88e6xxx/chip.c
> > +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> > @@ -3173,9 +3173,11 @@ static void mv88e6xxx_teardown(struct
> > dsa_switch *ds)  static int mv88e6xxx_setup(struct dsa_switch *ds)  {
> >       struct mv88e6xxx_chip *chip =3D ds->priv;
> > +     struct device_node *np =3D chip->dev->of_node;
> >       u8 cmode;
> >       int err;
> >       int i;
> > +     int out_amp;
>=20
> Reverse christmas tree please, where possible.
>=20
>         struct mv88e6xxx_chip *chip =3D ds->priv;
> +       struct device_node *np =3D chip->dev->of_node;
> +       int out_amp;
>         u8 cmode;
>         int err;
>         int
>=20

ok.

> >
> >       chip->ds =3D ds;
> >       ds->slave_mii_bus =3D mv88e6xxx_default_mdio_bus(chip); @@ -3292,=
6
> > +3294,15 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
> >       if (err)
> >               goto unlock;
> >
> > +     if (chip->info->ops->serdes_set_out_amplitude && np) {
> > +             if (!of_property_read_u32(np, "serdes-output-amplitude",
>=20
> Hmm. Andrew, why don't we use <linux/property.h> instead of <linux/of*.h>
> stuff in this dirver? Is there a reason or is this just because it wasn't=
 converted
> yet?
>=20
> A simple device_property_read_u32() would be better here and we wouldn't
> need the np pointer.
>=20
> ...
>=20
> > +int mv88e6352_serdes_set_out_amplitude(struct mv88e6xxx_chip *chip,
> > +int val) {
> > +     u16 reg;
> > +     int err;
> > +
> > +     err =3D mv88e6352_serdes_read(chip, MV88E6352_SERDES_SPEC_CTRL2,
> &reg);
> > +     if (err)
> > +             return err;
> > +
> > +     reg =3D (reg & MV88E6352_SERDES_OUT_AMP_MASK) | val;
> > +
> > +     return mv88e6352_serdes_write(chip, MV88E6352_SERDES_SPEC_CTRL2,
> > +reg); }
>=20
> Is there a reason why we call this from driver probe instead of 6352's
> serdes_power() ?
>=20

serdes_power is always called for enable and disable. It should be better t=
o configure
it only once. But I agree that it should be moved from chip_probe to port_s=
etup.

Best regards
Holger

