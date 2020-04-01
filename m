Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E75E619AD4A
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 16:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732863AbgDAOBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 10:01:30 -0400
Received: from mail-vi1eur05on2082.outbound.protection.outlook.com ([40.107.21.82]:6061
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732587AbgDAOBa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 10:01:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hVu2fNCilSh4BnBUWLZ0HnzTS08HI3iYWbckE5GXqQdFEmOEfBXowg/m9qGVEi7eXaEmfTcgEblPmuSnD8mn25MQzxFk4aJ20LjLgpCtoyPkJMMbaydcSuoZyi/xvgFFzwZaRhXTYbvQLhfnfpHpd9Sv1dnCyZ29hBrENXuRKE/KSUdm2XI+7yhvtfbRPIVITKJFpopjWlpDR5ZkD5L7zVvwI3teg7T+zCPmEwx2ehQr0YoRz8raB5eAzcI7JMPvxSyaLkuQyMJqf9Aecq//znDyEwbCYGF27R91+vZyt9aRn3x4zfi0SD+67LTNtwdYwDYsksTvq6DbaGBZoHkt5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sdQZAnPhxbUU0wz7EbtiR/NiPNnaMZrIONl2QtELy5k=;
 b=SJCqkJBltqrbOk1TdPAwm48c3Qm5zFLWOimmlXkVz6N7yoTF2Gbcm3T2OZzoem9uhykpDBwWGNQOZN9XN0lIarlyjB1eaHNwd22l7THsG/XpBxTda5W6204WjqouNuoQnBv5Hl6jD6bh91lkbqV14cZryWrcmQyJJw9wR4dbB8VZaIHO5idbeRvUIWu9KMtHbzJvExi+LSIKhyc7J2yJH+mtjo3eRChAnMiJQzt3Em5zZZ+rg4guyrJcqopJJKT/t9RKv0qAmDl9UzmcARn0wZUu6vwVXDgqXWrP4btLTU3Hpn/UkKILWpLmI4CwTXCqlSFLkCIIw13z3yucK7CR3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sdQZAnPhxbUU0wz7EbtiR/NiPNnaMZrIONl2QtELy5k=;
 b=QfCEyKF4sgaEPO+GrkSNPiR+qWDHGCaT0fNdMk/OQ4ETDnqkDT5FSzFjz0ZaCZZUHuXvXJjNsXrsMkfSXphG4dNx3wEbuOtSlFs4svgGZxNHmmDP6gEdvONZYUuNEQcISJbPhiZuYMq8t2cyE2UZU5DPvTCLSkRRkO99Op9JHmw=
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com (20.178.114.161) by
 AM0PR04MB4274.eurprd04.prod.outlook.com (52.134.124.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.20; Wed, 1 Apr 2020 14:01:25 +0000
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::ccc:be36:aaf0:709a]) by AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::ccc:be36:aaf0:709a%7]) with mapi id 15.20.2856.019; Wed, 1 Apr 2020
 14:01:25 +0000
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
Subject: Re: [PATCH net-next 6/9] net: phy: add backplane kr driver support
Thread-Topic: [PATCH net-next 6/9] net: phy: add backplane kr driver support
Thread-Index: AdYIKzcJA6qpFTRuS0KZUSXx/e10Jg==
Date:   Wed, 1 Apr 2020 14:01:25 +0000
Message-ID: <AM0PR04MB544326757B0B510C7C3C6417FBC90@AM0PR04MB5443.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=florinel.iordache@nxp.com; 
x-originating-ip: [78.96.99.111]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 93234786-f796-4285-5da6-08d7d6452a92
x-ms-traffictypediagnostic: AM0PR04MB4274:|AM0PR04MB4274:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB427419D3BB299DEAC16D7C03FBC90@AM0PR04MB4274.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 03607C04F0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5443.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(376002)(346002)(366004)(39860400002)(396003)(6916009)(7416002)(7696005)(66446008)(64756008)(66556008)(6506007)(81166006)(81156014)(316002)(8676002)(2906002)(8936002)(52536014)(26005)(66476007)(54906003)(478600001)(186003)(44832011)(76116006)(33656002)(5660300002)(4326008)(66946007)(71200400001)(55016002)(9686003)(86362001);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tdmbRsfFz5nOqLQapvanb19l6UKaGG24ikn2Lr1GO+Kq6nSGvTASbsYRmclGx9cNG01+k1sHk5SYXSBxN7G2KfAh4qMxAzFXf11wKurgInzQUjNh88n74KMri7bHnSQzyj8VtfmvQ5FHUGOOW2ggxli8EosO72rJlEIvdH9o6d4WgDHMcbN6CoCBPBqPsxy6IAA9iBeyWeqgcHxB3+MLGZcGCtQwN2x9yO2ZDWA5w8bn7dSAnmeK9Hmod5IBJoHUI24ks7zYJX3y4Ix7hb+KJx5wRWIPIetzWzjsqYaLx93B5Jx9gWPMm/yRfjnZOvbBVDzEfvyYZA92naBTvVnORv/2umVcC8PBcTb95hOYxnYpk7Na+afDa8ug1wVsPY/AsMcrtLlQCnPIpYln3PBmQxN/fbLFwr2Z7zzhHyKcP9Hf5Z44OBfmKG5pGpBrgyhd
x-ms-exchange-antispam-messagedata: ah7nl6lFBPsSUMCP5MXqskvDniSdtJTRkJWRTGRD3FgHAn2qXDeR77BZHcqrbc2vqZGekmp9bEpcWh2Wfvt2ka8T/foDZlL9F2KdFZWCg3pKCRxIVVrsDrF/T3kLgThAlFHqbweAs9/qLXEYoQx5/A==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93234786-f796-4285-5da6-08d7d6452a92
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2020 14:01:25.0797
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 03LwOiRrOm4aHykiZ2liflosIv1SUv3AAs0HVbwO+R2goXi1nRBeZXy3iQVRPqpWyIeY1P/V35aPe5yNTYA0h7ILuLXRXtVmJWPVuzbFOog=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4274
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Thu, Mar 26, 2020 at 03:51:19PM +0200, Florinel Iordache wrote:
> > Add support for backplane kr generic driver including link training
> > (ieee802.3ap/ba) and fixed equalization algorithm
> >
> > Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
> > +/* Read AN Link Status */
> > +static int is_an_link_up(struct phy_device *bpphy) {
> > +     struct backplane_phy_info *bp_phy =3D bpphy->priv;
> > +     int ret, val =3D 0;
> > +
> > +     mutex_lock(&bp_phy->bpphy_lock);
> > +
> > +     /* Read twice because Link_Status is LL (Latched Low) bit */
> > +     val =3D phy_read_mmd(bpphy, MDIO_MMD_AN, bp_phy-
> >bp_dev.mdio.an_status);
> > +     val =3D phy_read_mmd(bpphy, MDIO_MMD_AN,
> > + bp_phy->bp_dev.mdio.an_status);
>=20
> Why not just
>=20
> val =3D phy_read_mmd(bpphy, MDIO_MMD_AN, MDIO_CTRL1);
>=20
> Or is your hardware not actually conformant to the standard?
>=20
> There has also been a lot of discussion of reading the status twice is co=
rrect or
> not. Don't you care the link has briefly gone down and up again?
>=20
>         Andrew

This could be changed to use directly the MDIO_STAT1 in order to read
AN status (and use MDIO_CTRL1 for writing the control register) but this
is more flexible and more readable since we defined the structure
kr_mdio_info that contains all registers offsets required by backplane
driver like: LT(link training) registers, AN registers, PMD registers.
So we wanted to put all these together to be clear that all these
offsets are essential for backplane driver and they can be setup
automatically by calling the function: backplane_setup_mdio_c45.

+ void backplane_setup_mdio_c45(struct backplane_kr_info *bpkr)
+ /* KX/KR AN registers: IEEE802.3 Clause 45 (MMD 7) */
+ bpkr->mdio.an_control =3D MDIO_CTRL1;
+ bpkr->mdio.an_status =3D MDIO_STAT1;
+ bpkr->mdio.an_ad_ability_0 =3D MDIO_PMA_EXTABLE_10GBKR;
+ bpkr->mdio.an_ad_ability_1 =3D MDIO_PMA_EXTABLE_10GBKR + 1;
+ bpkr->mdio.an_lp_base_page_ability_1 =3D MDIO_PMA_EXTABLE_10GBKR + 4;

This approach is more flexible because it lets open the possibility for
extension on other non-standard devices (devices non-compliant with
clause 45) to still use this driver for backplane operation.
These non-standard devices will have just to define their particular
registers offsets in structure kr_mdio_info and then the rest of the driver
can be used without other modifications.

Florin.
