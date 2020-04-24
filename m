Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD3AA1B786E
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 16:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbgDXOj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 10:39:59 -0400
Received: from mail-eopbgr50063.outbound.protection.outlook.com ([40.107.5.63]:45042
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726813AbgDXOj6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 10:39:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iA6NgLzqijXR94cCT3k/pQ/XuWDkucxOZVrvO/NKVcBtccSeK/sfudOJDhvONd5iK5+lH0O9CfgG+vCXK1HnaoulLf9i0ataMR6PgUdBTt87j5AE7Kdud+W1iypBChKp+2JwjKMNUId6bjnXqvjGpdGfGzb2n0EwiD3jm+ThtBPOkSRFBiulZnAZwmEZjdzbEIyuv86J1N7JgihGSznfB6f2tkN+c4qRwoI1vu8MHFx55EJj/jD8znKCbkHjZTDaa2RTprl+AhvLhkTPwulZOQg5cK3qUdy66CJp670YbdhvhLJ1F10RQL2xkdsBJVIk9Z+6VKM196aPHAOX9hO6hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=El7UDRVQpMMg9nFO5vjYJuep7JYJNDc11HnZl67GajI=;
 b=cJMMA/ba3HRl0MBee3NqetoMvpyODInOfXJGaJwGGAxrvhEBXrfl9pBSmrLcvxeu3xGTDqLTEfxzymHgOg+s8cyWqTBPKcMfu4jh948IFaGB1HNvoKocD1zPnBrC6e7wy1xjpt8Iul668mL3pUqnJXjt9Y6dbjl4o4d8hXhiyuj26XQTd4KLgCKy9IzsespbY3bd6NE2Fihv7dMHvL3Y7mQjcNV9nNwCLY8a+FE6hNRX3a5ZhkLXTNpfgasmvKeHUahebvkxJ6L8yTaaXfNtez3LsEiGQI3G5Ma+anBR47OIEZbAhy2nzxfHxcjbBqyS/tgGrMTJxzxiQAfyAMyeeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=El7UDRVQpMMg9nFO5vjYJuep7JYJNDc11HnZl67GajI=;
 b=PL7fH1J9TbSjxAVu0/RkE1wTfYeICuJlvyyZBNEOdK7skaKzdJFJMNklg45vdv5mIRqztPsLtC7A4rWBPzSihuEQiXFMFJmtKrSCCEptyiVY94ZyhPFYItUJJ4VBp4u+UJ/sOGpdyCoFJKf+3WtlRK1q9J+a11Acr5idloI6vfQ=
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com (2603:10a6:208:119::33)
 by AM0PR04MB6481.eurprd04.prod.outlook.com (2603:10a6:208:171::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Fri, 24 Apr
 2020 14:39:54 +0000
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::8cc9:252:1c77:5860]) by AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::8cc9:252:1c77:5860%2]) with mapi id 15.20.2937.012; Fri, 24 Apr 2020
 14:39:54 +0000
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
Subject: RE: Re: [PATCH net-next v2 6/9] net: phy: add backplane kr driver
 support
Thread-Topic: Re: [PATCH net-next v2 6/9] net: phy: add backplane kr driver
 support
Thread-Index: AdYaRAr6OuhHlsgtRe2hojICsYdYXA==
Date:   Fri, 24 Apr 2020 14:39:54 +0000
Message-ID: <AM0PR04MB5443BCFEC71B6903BE6EFE02FBD00@AM0PR04MB5443.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=florinel.iordache@nxp.com; 
x-originating-ip: [89.136.167.85]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: af9b0be3-049c-4d2a-0b30-08d7e85d5a92
x-ms-traffictypediagnostic: AM0PR04MB6481:|AM0PR04MB6481:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB6481EAEBDB4C4E54402B7627FBD00@AM0PR04MB6481.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 03838E948C
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5443.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(39860400002)(396003)(376002)(136003)(186003)(316002)(6506007)(66946007)(66556008)(66476007)(54906003)(7696005)(66446008)(76116006)(52536014)(71200400001)(5660300002)(64756008)(4326008)(86362001)(7416002)(2906002)(55016002)(26005)(8676002)(9686003)(81156014)(44832011)(478600001)(6916009)(8936002)(33656002);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i01M3m5uAWiFb6AwNyY/37DAKGD+HwRpdCNJTtXXccfrfTo1J4im55z6ia4gxjWiYZhHwsMOFUXUD07Qf9HaQxLISpMGpJjL4NMWKKSshF40PyBRRgAub4l8d6ZVSFHS526awUegupSwnCK2haAHzM2hJFknrJCfOAISTpDv+mMgwCcjaXJzb6MsssgyRk9RNlQDJI77BBcuYnuqWzBciiKVW9Wtu5tSbzKWHh8wxvRbbbxRbxZ5nW+OSUBYcOOzFbG9dMCtW84J0PHefJ/f70bgWitkgoRaGXm8ETNePyWj8UZsX5Oyvh3fYxin7TJpxeySlFWvhTTEPL3c24ISPgcuRM35PHpyCMucLXeP4Sxfvf84xuI/ozKwAgwvjB31C5NDEneKMKoXXdffuyGFTGQsG6HUyB0OyqU20GvCu/PHEadzmj96B531DEecnNrz
x-ms-exchange-antispam-messagedata: XuLW//yiv7aFp4RLkhA5lzUfW/VZywSgOUUtXoDHbOAbehUCE5oZ7TUMwDWkfi1AK6/zmFb6QbA7fnla9GaJR9z4XpRZSHZ3Qi3MWA/1o07KE5z/CBQ750bLImgZC8ZJZngNn5/NvCw31WmM4hc1bQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af9b0be3-049c-4d2a-0b30-08d7e85d5a92
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2020 14:39:54.3738
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RhZPaZelauvgQO5zNRDKoid0fIgK9UwyRG5aZUshHDZudKMUikZK08nKi7ZpuJoX0N51JE9No/QrubWzHSZaY2O3AqKiHHfKVhdO13r23vw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6481
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +/* Backplane custom logging */
> > +#define bpdev_fn(fn)                                                 \
> > +void bpdev_##fn(struct phy_device *phydev, char *fmt, ...)           \
> > +{                                                                    \
> > +     struct va_format vaf =3D {                                       =
 \
> > +             .fmt =3D fmt,                                            =
 \
> > +     };                                                              \
> > +     va_list args;                                                   \
> > +     va_start(args, fmt);                                            \
> > +     vaf.va =3D &args;                                                =
 \
> > +     if (!phydev->attached_dev)                                      \
> > +             dev_##fn(&phydev->mdio.dev, "%pV", &vaf);               \
> > +     else                                                            \
> > +             dev_##fn(&phydev->mdio.dev, "%s: %pV",                  \
> > +                     netdev_name(phydev->attached_dev), &vaf);       \
> > +     va_end(args);                                                   \
> > +}
> > +
> > +bpdev_fn(err)
> > +EXPORT_SYMBOL(bpdev_err);
> > +
> > +bpdev_fn(warn)
> > +EXPORT_SYMBOL(bpdev_warn);
> > +
> > +bpdev_fn(info)
> > +EXPORT_SYMBOL(bpdev_info);
> > +
> > +bpdev_fn(dbg)
> > +EXPORT_SYMBOL(bpdev_dbg);
>=20
> Didn't i say something about just using phydev_{err|warn|info|dbg}?
>=20
>        Andrew

Hi Andrew,

I used this custom logging in order to be able to add any kind of useful in=
formation we might need to all prints (err/warn/info/dbg).
For example all these bpdev_ functions are equivalent with phydev_ but only=
 in the case when there is no attached device: phydev->attached_dev =3D=3D =
NULL.
Otherwise, if there is a device attached, then we also want to add its name=
 to all these prints in order to know to which device the information refer=
s to.
For example in this case the print looks like this:
[   50.853515] backplane_qoriq 8c13000:00: eth1: 10gbase-kr link trained, T=
x equalization: C(-1)=3D0x0, C(0)=3D0x29, C(+1)=3D0x5
This is very useful because we can see very easy to which interface the inf=
ormation printed is related to: in this case the link was trained for inter=
face: eth1
This information (the name of attached device: eth1) is not printed by phyd=
ev_ functions.
I'm sorry I have not explained all this earlier, the first time when you as=
ked about it.=20

Florin.
