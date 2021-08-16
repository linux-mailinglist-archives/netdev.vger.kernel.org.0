Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D344E3EDC90
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 19:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbhHPRsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 13:48:40 -0400
Received: from mail-eopbgr00054.outbound.protection.outlook.com ([40.107.0.54]:61062
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229613AbhHPRsj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 13:48:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lqHF2IaYcnTT2QmEHnxknO6ZlZZoqu+eOFvExj5dQrWbH/nfIGtZgwQlW9UUVdFrBdKK82a2c6XP1u7mkR4ZGChyxQmXLW5icQzDHpSPzgIZdnZNIDFFhTG2GqvxAaMOHLrj8v/nFDaHQ62fpSEtCJR3fa8xwtgzsCGACAg978YJBqJT8I5OohbDxknPrY/jqdl0ntCGU8D1hEOjIrtPx9OugiUixoavjo6SSsv7gNR9bP5a4M7f9tWv/8nFUePaF5OxKDL/kvZhsagqrKZr29iWG9aKtmyH9QbSewBXX3TaUxIbTEepDsBAAfaBau1kqLLCxYVm8zIBodbSJEZs8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xI+4mjfXwXxJcwjO+puhYLTfGQtv11Ru5OHqqqPibKY=;
 b=YLQJjpOOU6BpFMGH3ID/V1X1fgcqs9+867Dy5j1BejWcBUIOEYNqUwVN6vZ5t04028LUDymh1eaCAbcxYE9Eo5DWFFDeUlOTlqis8SwXuzGmrPWyItFWC6bXE2ewKPKemrhaDQWAXnIKWqsMfpY0lIwaB+vl6BTufos61uUj/ibGXdsDV78UnMiECcGxod8GRHuV/mhc1m4KIjFiEJxulRwtsQxczI2RVLB+jWuPoyCUrXGBGLXz/0SnuJy+6Yb+KlvEHVOVtxfNwps/2REc8DCGJEH+MK8Pd8p3OC5xkZqGyFXLtH3K71+m8GOIfOGJywYZFFZp/LlTBzPP8ZFulA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xI+4mjfXwXxJcwjO+puhYLTfGQtv11Ru5OHqqqPibKY=;
 b=XajLAmbwpUZB/2uu//cncTYH33kWJehFEVS23mv8FcmwTueR9oa5M5P5OUbLY9T4KwilSaDvWqTvT/Z/mT2jrqmW/7II8GpwlQruUAVWNlFnMFO1291RvnbTtKzKzf29dS4pjrXcF3CRAIVsct6ssvN/m8CxfEEJTqrfTYnT3CE=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6272.eurprd04.prod.outlook.com (2603:10a6:803:fe::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Mon, 16 Aug
 2021 17:48:04 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 17:48:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Hongbo Wang <hongbo.wang@nxp.com>
CC:     Andrew Lunn <andrew@lunn.ch>, Hongjun Chen <hongjun.chen@nxp.com>,
        Po Liu <po.liu@nxp.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH v1] arm64: dts: fsl: ls1028a-rdb: Add dts file
 to choose swp5 as dsa master
Thread-Topic: [EXT] Re: [PATCH v1] arm64: dts: fsl: ls1028a-rdb: Add dts file
 to choose swp5 as dsa master
Thread-Index: AQHXj+75z1qD/BGTVEaJLO5FNXuRQ6txaSUAgAANIYCAAAMJgIAEL8wAgADEv4A=
Date:   Mon, 16 Aug 2021 17:48:03 +0000
Message-ID: <20210816174803.k53gqgw45hda7zh2@skbuf>
References: <20210813030155.23097-1-hongbo.wang@nxp.com>
 <YRZvItRlSpF2Xf+S@lunn.ch>
 <VI1PR04MB56773CC01AB86A8AA1A33F9AE1FA9@VI1PR04MB5677.eurprd04.prod.outlook.com>
 <20210813140745.fwjkmixzgvikvffz@skbuf>
 <VI1PR04MB56777E60653203A471B9864EE1FD9@VI1PR04MB5677.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR04MB56777E60653203A471B9864EE1FD9@VI1PR04MB5677.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 175511aa-bf6a-4b4b-df5f-08d960ddff94
x-ms-traffictypediagnostic: VI1PR04MB6272:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB62723CC59A9E528A96E3CAE8E0FD9@VI1PR04MB6272.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jaVSr+SEiDQPhxhZ3IqdvAtuWpHy0UXdNHHqNj8XRYoYniDoy1a5XPyVoWjOLqf/a8pY8G436/anth32TGBxMW6lhHyx5OL2AaZSrUy7YwnYOZ5/wF1ST48sBqKEnK7yzJ+3bsua/xt1+M4np1VUZievU9GFGB3T3NfaqNDakr4Vg9elCYq+3KETN/6lv5jssgCkjgllD/gqLTo+EAmPLM3SWm1sYA9fipm/f5cKNWP2olaXmw0LX9QZflctvx4BR+sEQdR/bpmaHYub1HYQ+bX8yHZo48kUM1LFDzagraz5aYJ/7j/d7bJN9zkSduDCnhe5YAYVIJMNEOthyfgMVaNMqBaraaTtsW4uqKig/bfIMHHWNoMddGIhU3L3Ndng+zhY5NUzgDatseFohWFl/TYrBkopOhnSAS2KhiXhWfxG72wyNg1YFo5KWItOGRTKTS+pOg+jaXf9NHjQlrF3MCYbzzYGHTgGOqtnOxaa/hdE7WPNWmVlsuM0KxEz+5cFWe1ftIBGmjmERbWpYEdtqVCh9bly87swG5Zvx2lYK2BbLtHiy92INFLqj/xeSdrvumfF2l5MXxwc467MP9p8Xh1FRBkPv4i4XYpvL/MQi/9UW+cErdStAc0jzISXsThXaoZwngVov0BTejBrYbSWLdigteJnI1rsvA/QCUmhCUlE7H0haw/mq8gcZi5vE4eVWeibPeYCN9qluWg+bPnPdr9rmAUCduIONZ5YPjkLSAf9EDnXXVUUNIC0at3oqCkZF5XD1obdG5AlKT5DDTHkqfiZ2yFk0tA1F/EvjW8HEv2BWNCKO9B2+7PyavG68wti
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(86362001)(6862004)(33716001)(4326008)(8676002)(8936002)(71200400001)(38100700002)(2906002)(83380400001)(6486002)(26005)(38070700005)(5660300002)(7416002)(6506007)(316002)(54906003)(6636002)(66446008)(1076003)(966005)(9686003)(186003)(508600001)(44832011)(64756008)(122000001)(76116006)(6512007)(66476007)(66556008)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cn2xbqKCFoZ/YoUqLttsLuomqXC/AKEN8zkqhHadrX5EFrnSjxoyOdKJWTOO?=
 =?us-ascii?Q?jPMYF7uXa00OREVnwE88UCxFT5RVKkXSlFN11u1gi5vawhcQmemGnTzRQIDs?=
 =?us-ascii?Q?9z+XihGT9QVfD1Kwaf3r6mbErraiyihIRgVBOeWogbmMOZD/sMYuWbYJzKdO?=
 =?us-ascii?Q?ZoTPQCEE6VAeB3zTVJOs5B+n28sren/xjBQIyY/qPqPdnocBkqiGBu/m6gBK?=
 =?us-ascii?Q?dLxITiCYf+Ry3BO9I6o4USuYpMP8O2WTVBxPHTp1BvShlrzJS0MLVDkN6ihQ?=
 =?us-ascii?Q?3Po4TjOsjigwtE8xyZVkDOYhnleeh5bqyNyTvMK5hh46/ANrT7zlBF0gAlkG?=
 =?us-ascii?Q?cp8+Vg+1Z2KySthbSf0Nbq62Uo537/8pjXPx+xjTe+CF+cYXbwE5wCezObOa?=
 =?us-ascii?Q?2IMde6CpaNgOE401Pzy4wbEYqKKkfEeaItmRYKQpBTVeSWg6ECvQriUCB44H?=
 =?us-ascii?Q?WNjm2j8rEEI2RXmM1qSA4MrhjBWu2jfxzUbiUYPFclX+d9qKg//4qHX9caSH?=
 =?us-ascii?Q?LSJJnRgY3KKmpb2zkODvG5rcexcn6+4+JJ+E3awl/a9L54xctBKYdwNRH8UB?=
 =?us-ascii?Q?XfIIK/uZBQdEdL6GUoH12vsAYTtlkj4EtyGqT8EEiElJ9a+ybf+dA1yw3jUY?=
 =?us-ascii?Q?+wz98R9jujGQvscJmipqPltTRJaTBDvP/3gf6SsKjaBg06baShQ4xKg31KYT?=
 =?us-ascii?Q?rJ0k67zvNyuJPUZ1W8s2rldYqRpjYIENHSBLSKPKQ4YCwZq7KVi8f9pFzi7a?=
 =?us-ascii?Q?tHotz7Yf4Bnx/JNkl3VKGg3TaTsX8XhqFR9CrlbF8EvH37zWc8n29xqOZhs7?=
 =?us-ascii?Q?eF0zlB/AcJ2zegZsOEWrOCvROQ6I6qFrnz4Lu5PENr98JyTw3qtOYpBLIpuo?=
 =?us-ascii?Q?MF4l6F6B8vbblqXK7Y8eU1ywjhaAgN7+WdqTl31Gwwf7HaigdXgW1ljvd+y+?=
 =?us-ascii?Q?pKdsrtg8ycUJEpSfIjNmyGdCUGiqoaTSWq6KP5Uv+n+bwpxiMBCyjwKfaR1K?=
 =?us-ascii?Q?4WmYZ8XtUkTu/9qbIwHMaNa4EG+tYlRywcirmA5SKXaShgGYwZ9gjx/9XIYD?=
 =?us-ascii?Q?q4KeT8GNSkVtjOIzuvka2CEUqTrMqyZ6vnVqZGNQr11tP3SPN8F9uFp4+NtM?=
 =?us-ascii?Q?KQEJF+isCKVJKQUNYxEVjF9Vco0KN3cCsmkD+oZJvM5Tj4qQb7sY7IuO2xwH?=
 =?us-ascii?Q?v/mqdNZ0UJeHJCm1U/ZotPZ+OgIlgw80Ib3D5YokqndTKRVKJjIDhQFf/bMq?=
 =?us-ascii?Q?otS4BTbr/64dq8eHMIdcLZmbBzKUnLWAJyCZx/HBsXNQk/rhUIP90oej6vwK?=
 =?us-ascii?Q?ftf9aDkLjf0D4Xg/S6CBrpiG?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <598393336F9D4149A92D2BB84E39700E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 175511aa-bf6a-4b4b-df5f-08d960ddff94
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2021 17:48:03.9812
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eAW9U1hp9fsO5nEtri8QNeBvecMj1TKLgG8VtkEpjNoc2CNmuXSgk70sxuj5y5G6kKrQbzOhyW4J7gGjQtXPUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6272
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 06:03:52AM +0000, Hongbo Wang wrote:
> > I was going to suggest as an alternative to define a device tree overla=
y file with
> > the changes in the CPU port assignment, instead of defining a wholly ne=
w DTS
> > for the LS1028A reference design board. But I am pretty sure that it is=
 not
> > possible to specify a /delete-property/ inside a device tree overlay fi=
le, so that
> > won't actually work.
>
> hi Vladimir,
>
>   if don't specify "/delete-property/" in this dts file, the correspondin=
g dtb will not work well,
> so I add it to delete 'ethernet' property from mscc_felix_port4 explicitl=
y.

Judging by the reply, I am not actually sure you've understood what has bee=
n said.

I said:

There is an option to create a device tree overlay:

https://www.kernel.org/doc/html/latest/devicetree/overlay-notes.html

We use these for the riser cards on the LS1028A-QDS boards.

https://source.codeaurora.org/external/qoriq/qoriq-components/linux/tree/ar=
ch/arm64/boot/dts/freescale/fsl-ls1028a-qds-13bb.dts?h=3DLSDK-20.12-V5.4

They are included as usual in a U-Boot ITB file:

/ {
	images {
		/* Base DTB */
		ls1028aqds-dtb {
			description =3D "ls1028aqds-dtb";
			data =3D /incbin/("arch/arm64/boot/dts/freescale/fsl-ls1028a-qds.dtb");
			type =3D "flat_dt";
			arch =3D "arm64";
			os =3D "linux";
			compression =3D "none";
			load =3D <0x90000000>;
			hash@1 {
				algo =3D "crc32";
			};
		};
		/* Overlay */
		fdt@ls1028aqds-13bb {
			description =3D "ls1028aqds-13bb";
			data =3D /incbin/("arch/arm64/boot/dts/freescale/fsl-ls1028a-qds-13bb.dt=
b");
			type =3D "flat_dt";
			arch =3D "arm64";
			load =3D <0x90010000>;
		};
	};
};

In U-Boot, you apply the overlay as following:

tftp $kernel_addr_r boot.itb && bootm $kernel_addr_r#ls1028aqds#ls1028aqds-=
13bb

It would have been nice to have a similar device tree overlay that
changes the DSA master from eno2 to eno3, and for that overlay to be
able to be applied (or not) from U-Boot.

But it's _not_ possible, because you cannot put the /delete-property/
(that you need to have) in the .dtbo file. Or if you put it, it will not
delete the property from the base dtb.

That's all I said.=
