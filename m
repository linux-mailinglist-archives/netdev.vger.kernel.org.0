Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 833301957AA
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 14:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbgC0NCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 09:02:23 -0400
Received: from mail-eopbgr50046.outbound.protection.outlook.com ([40.107.5.46]:32779
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726165AbgC0NCW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 09:02:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lmREUd3Wz2PekEMDbOMqJCuoFVoLqa/yTRyAKzGTYnHBEtAUVRiqjW9lPeeEhCV8hHeczdonX8ax8WgqN9EvxGfHq1+gGRqexeDuYGglYQiCqpMpMCwL9/n5DwTeKw4SROizVDvruMpoCUs6uUDGTAgcC2dKr5YZAdhvoXRMajH5SNDnVyof0mwE4NamF789ki6ixW+uWg6Q894ZiKsYAUvlWlvF/v2r6HIza9WqfkUSdRRllgQPpAAPeUxrMC2SVgJzKKU+5pgYqOcQnp7LVYaMld+HhaUG+/prlBggdJmqiIyjZ7oWAEd6b/s35EyHYl+AtONoBmsDzB+eEfBWWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z2vXgZBKpZCJfHhJcX3ltJE7w+g9AwbEN+s+FGEQw9A=;
 b=DUv+qzvDrRUSka1S1Dotj3MXGpDGyLjm0Lipa24TYRoj5N/bdcKyTlXZoQis8FFXXOXZ8mQVs3znTFU160vTDmPnoRdp2fpD96UHM4BKEHwfl6tE2UG6xKCZKY1IN4AeHPVVbC3h3PyEEt24GSvHeKuFS/6No6vS0CG9jp0m5ndQkLeVW5U/1AuZb/KYWSdYLU2ycvlY4LXbR3Gi9HBwpVzrX6BLZKsKgZj9M36DyU+mkwr3CtEHJgkMv4pKMzXSF2OShX5E0kEC+M/O69d3UQXETXtOmQeCI60ozGehBWcuRXMQkuhM78K0ae/qvDY079q00Cbk6wIctPF3eh/Wjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z2vXgZBKpZCJfHhJcX3ltJE7w+g9AwbEN+s+FGEQw9A=;
 b=BkQejmU5DpIeZQg0kPtDKJfyLpae6q1ocQ3zVnaZYQmh6yhIFFi4RKEMLQ6GeHqF+n58LQC4r5KFFaGTFVzRqc3T0tUu3jQljBOu7lbHSkaOU2EA9n373jm6kY2um+aNeBdxGgTdGKhkLGZOSXXsUXgqjVMHAJkmu3SiW/5z3iI=
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com (20.178.114.161) by
 AM0PR04MB5953.eurprd04.prod.outlook.com (20.178.112.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.18; Fri, 27 Mar 2020 13:02:17 +0000
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::ccc:be36:aaf0:709a]) by AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::ccc:be36:aaf0:709a%7]) with mapi id 15.20.2856.019; Fri, 27 Mar 2020
 13:02:17 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: RE: [EXT] Re: [PATCH net-next 6/9] net: phy: add backplane kr driver
 support
Thread-Topic: [EXT] Re: [PATCH net-next 6/9] net: phy: add backplane kr driver
 support
Thread-Index: AQHWA3XAuILwZD5jSkSvPDf9MRgGVqhboSQAgADGgpA=
Date:   Fri, 27 Mar 2020 13:02:17 +0000
Message-ID: <AM0PR04MB5443C1142ABE578ACC641FC5FBCC0@AM0PR04MB5443.eurprd04.prod.outlook.com>
References: <1585230682-24417-1-git-send-email-florinel.iordache@nxp.com>
 <1585230682-24417-7-git-send-email-florinel.iordache@nxp.com>
 <20200327010706.GN3819@lunn.ch>
In-Reply-To: <20200327010706.GN3819@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=florinel.iordache@nxp.com; 
x-originating-ip: [78.96.99.111]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6774d1e0-6c24-4059-a6b4-08d7d24f141e
x-ms-traffictypediagnostic: AM0PR04MB5953:|AM0PR04MB5953:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB5953B12DBD44782E84D12FCDFBCC0@AM0PR04MB5953.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0355F3A3AE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5443.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(366004)(376002)(396003)(39860400002)(346002)(44832011)(6916009)(478600001)(316002)(186003)(4326008)(54906003)(7696005)(76116006)(55016002)(66476007)(71200400001)(64756008)(6506007)(52536014)(8936002)(81156014)(81166006)(86362001)(9686003)(7416002)(66556008)(26005)(66946007)(66446008)(5660300002)(2906002)(33656002)(8676002);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1dDC8Axkfh/dF1XN5mhnqnnmnIS9hPKXSfJ1TsyNgmKr6XHW+dxuPqLN2yLY4OvCpLtQg2VozxPnrKTH2ZcSxtwFxwn+2/0Ygzrr8iye6L7PCuZmcAhlPeTYAvar0LCPsXSRoZItr0cpA3HGcxTsrlkvdE/Gnt3O3cuh/+mOgJWnAqQa2qNvCmXltsU+zU/3u8qRiEYxU1dRy+wQ2BCQ1NoRIlbAf6Af5S/X4Zem8IngRF87zU/wfDfLxR5S5cxqN1pqvAjQJ108XSNpzw34tZqXy+o4UsWkkeyHSn1A0WjKhJH6W/bxIrSrSrJLC6PcN8h6IO4R7VSaD5yoMEkjyRIJy0mxvMpEK7spPeTPd+YQpRgZw9hweo/Xb4Gkej1iauF3RTI7545/RUhm8hUSThPPEiwKKSPsYhiboET/QM5sEXjnORQpSpD/ZCL+D0Ho
x-ms-exchange-antispam-messagedata: MGT7SOw0u3Uc9X6VHhs4xd9WqYZ2G6reR/xkUuEq4WLSV/9mqP14CRkffto4xkPOyRcxfXgQh7tUFejGGJMlgYdWP2HtH+nzspBnLmSqSYgWGVRXpwL7Mk7bFNYpXWRRpVv4UlAHZAbLqxRIKm3B/w==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6774d1e0-6c24-4059-a6b4-08d7d24f141e
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2020 13:02:17.7037
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vfSxV0b2rhvelcLC6IEClS47lo+tyXZtse1E1pFolF89NuH2GHDFN5q/YZTu5DHaIuxHKtlevj4N9GGng+mBjH3vf+78qvomM+FW/SbhSmA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5953
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +static u32 le_ioread32(void __iomem *reg) {
> > +     return ioread32(reg);
> > +}
> > +
> > +static void le_iowrite32(u32 value, void __iomem *reg) {
> > +     iowrite32(value, reg);
> > +}
> > +
> > +static u32 be_ioread32(void __iomem *reg) {
> > +     return ioread32be(reg);
> > +}
> > +
> > +static void be_iowrite32(u32 value, void __iomem *reg) {
> > +     iowrite32be(value, reg);
> > +}
>=20
> This is very surprising to me. I've not got my head around the structure =
of this
> code yet, but i'm surprised to see memory mapped access functions in gene=
ric
> code.
>=20
>        Andrew

Hi Andrew,

This is part of the framework used to automatically setup desired I/O=20
callbacks for memory access according to device specific endianness=20
which is specified in the specific device tree (DTS).
This approach (explained below) was used to avoid the potential=20
redundant code related to memory access LE/BE which should be=20
similar for all devices.=20

This portion of code is just preparing these four static IO routines=20
for specific endianness access LE/BE which are then installed as=20
callbacks by the generic driver on generic DT parsing routine:=20
backplane_parse_dt according to endianness flag:
+    /* setup ioread/iowrite according to endianness */
+    if (bp_phy->bp_dev.is_little_endian) {
+        bp_phy->bp_dev.io.read32 =3D le_ioread32;
+        bp_phy->bp_dev.io.write32 =3D le_iowrite32;
+    } else {
+        bp_phy->bp_dev.io.read32 =3D be_ioread32;
+        bp_phy->bp_dev.io.write32 =3D be_iowrite32;
+    }

These io callbacks are setup in the following structure:
+/* Endianness specific memory I/O operations */=20
struct mem_io_ops {

which is part of generic structure:
+/* Backplane device info */
+struct backplane_dev_info {
+. . .=20
+    struct mem_io_ops io;

which in the end will be used directly by the device specific code for=20
specific memory access according to specific endianness specified=20
in the DTS.=20

The endianness flag must be correctly set by the device specific code=20
before calling the generic function backplane_parse_dt, according to=20
device specific endianness specified in the specific device tree DTS:
+bp_phy->bp_dev.is_little_endian =3D of_property_read_bool(serdes_node,
                            "little-endian");

This action to setup desired IO callbacks could also be performed in the=20
specific device code but by using this framework the process is more=20
automatic, it's reusing the logic and therefore decreasing the overall=20
LOC required.
If any specific device is doing this action by itself (which is a similar=20
action regardless the specific device) then we will end up with a lot of=20
redundant code.

Florin.
