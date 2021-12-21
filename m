Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 708AB47C92F
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 23:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237857AbhLUWY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 17:24:56 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:16730 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbhLUWYz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 17:24:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1640125495; x=1671661495;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+YR86mI1y+8Ce2Z9MCbJEBnWRLKvWzw6uNFKAEHEwkI=;
  b=0bfBXYJLfxzNwni9EkyKHJ8ldznDfQwLjV+7tFq1mNKGsYssnZuCxbBt
   6uiGccmgm6HdqrPsRGy24gsXVFs3liiNcC7lQL9gGnJMzY1RJlwxXQuik
   0MYLqi/KL2MiE07Fpb6D1eZ4MIGjSD4g4u27FvKHu0n+mPiKBZq0+rqQf
   UZ9Y7XQNUyV59+p7BY4RMGQViRzEbeOj12OjzdcUQ0Ui8ukv+Ozvog2lC
   DfUbPIhlVbq0Urk3hYxGRjswayJHlNEan0mNR9XvgkV1ewhE+GPCAZq7o
   0jv/kkQfz1551eBiSUulxvoatW9CCvPMandXOHUP/0eY6nbBkiqTFUrdO
   A==;
IronPort-SDR: tT+8PBnM/gnHCaUHINrP2g9HSt6Yq/VSGIfuB1PJ6Rw/aSd5O2DytyOPcjEuUr+ubY/GfO7CHu
 p3Eu4doBWOXJ8KgQagrYRSlwnJSCY+/UOqDREyRkslQxa3q7IjupxwDc5zCcePpwCFLesgvxCY
 tG5RWhz3hFY1cU0LtrPUVi9dtxOzbT31Jnld8+GynmI/0UwVoXGrlF2reH0vwkWh3E4Bgx8ABW
 QMs5kswXI3jf1sYK7HApzph1oJFnMI6GmkdITR7vnDGwiKHHu1Ztfv6xl4705/kWul7dRCk/EW
 /pGaMIIAlX8J39E1L9J53yhQ
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="143162504"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Dec 2021 15:24:54 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 21 Dec 2021 15:24:54 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Tue, 21 Dec 2021 15:24:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B0FxnHlm+Hsynm+VHMdlAoQ0RioFviO9UUvOYuNasAhWyZ5SnrIQ21982gbHnyN64268IokfD9s5rLgXylp0KahnrAnhEKx5A0IQyBIAoVZlgxMG1xohCgaL3ZqjeQOA0sBLbE6tWGdi3fhvDuuTICeWkifIScZKcR1XZ0q8p0chWwNZJscYGP2PuM/HJmCaamu449YuHlWDaU9B1hE1JVK8NnvbN3OpRo49GsgXlU8wTSa9Rf9jnXzYLFJHu1tqZKQz+16ofzGMTYZ7bW9Tpo9kVxThpbjnrj206j09s9p7ChREYiDOXRw5F9frzhdylp58PwtzvskbIDeUo4+LTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=waWmqxRcAAAnHSYuivocWgxiskA0dJsTOc3qZ9/j3vs=;
 b=Sg9y6yzhsGAFm8BgxT1frIHt9JF1IMQvSHPbtbK8q0tmtnAlICrg7Yzn5qpW0Z39fHujHC0wA7QAKbLYhuNeYRpGOJv8OsaPaB4cIO/PgGl2Fhd3gELQ446xmIMtjKBsmyqsAuxP4YzIo9h9REWpJKflfpGhwsuTN3WbhHdAs2fJLSMhm/4JnavA9c9h0hi5VG/jhsS8L0M1G66nIsA3d0LS3hIMS0NwmJ3kW733ea9oMTktAqINrqW/GtMISv/NAzCJodaxr0TQvln7W83/gWwGp11P61m8dZ5AEyrBSbHAuP7grRTa/JJaZsQMC0YkfkS1SfZowz2Fu2kAtO3X8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=waWmqxRcAAAnHSYuivocWgxiskA0dJsTOc3qZ9/j3vs=;
 b=nrgWDuMIZXRlNSdJGXFkcJOV0PC85FVnbax8XSTFqmPIEvlzYyPUvoHyStRzDypiv9anG5oUSxGMAiAEz2MuF9hLY4uGd5UKM+8UtKCNHF/9rMYySOXCTHhK+xgUpq5B/loqU5LFnZptJawkFWQrGYLg875ta9zc8y9Wr/jvHbM=
Received: from DM4PR11MB5390.namprd11.prod.outlook.com (2603:10b6:5:395::13)
 by DM6PR11MB2859.namprd11.prod.outlook.com (2603:10b6:5:c9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.15; Tue, 21 Dec
 2021 22:24:52 +0000
Received: from DM4PR11MB5390.namprd11.prod.outlook.com
 ([fe80::bcc4:7cdf:d47b:1ed6]) by DM4PR11MB5390.namprd11.prod.outlook.com
 ([fe80::bcc4:7cdf:d47b:1ed6%3]) with mapi id 15.20.4801.020; Tue, 21 Dec 2021
 22:24:52 +0000
From:   <Thomas.Kopp@microchip.com>
To:     <pavel.modilaynen@volvocars.com>, <mkl@pengutronix.de>
CC:     <drew@beagleboard.org>, <linux-can@vger.kernel.org>,
        <menschel.p@posteo.de>, <netdev@vger.kernel.org>,
        <will@macchina.cc>
Subject: RE: [net-next 6/6] can: mcp251xfd: mcp251xfd_regmap_crc_read(): work
 around broken CRC on TBC register
Thread-Topic: [net-next 6/6] can: mcp251xfd: mcp251xfd_regmap_crc_read(): work
 around broken CRC on TBC register
Thread-Index: AQHX63m5RC9thyxmT0S34SqWhDegYawp9YdggAADTb6AExztoA==
Date:   Tue, 21 Dec 2021 22:24:52 +0000
Message-ID: <DM4PR11MB53901D49578FE265B239E55AFB7C9@DM4PR11MB5390.namprd11.prod.outlook.com>
References: <PR3P174MB0112D073D0E5E080FAAE8510846E9@PR3P174MB0112.EURP174.PROD.OUTLOOK.COM>
 <DM4PR11MB5390BA1C370A5AF90E666F1EFB709@DM4PR11MB5390.namprd11.prod.outlook.com>
 <PR3P174MB01124C085C0E0A0220F2B11584709@PR3P174MB0112.EURP174.PROD.OUTLOOK.COM>
In-Reply-To: <PR3P174MB01124C085C0E0A0220F2B11584709@PR3P174MB0112.EURP174.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_7fea2623-af8f-4fb8-b1cf-b63cc8e496aa_Enabled=True;MSIP_Label_7fea2623-af8f-4fb8-b1cf-b63cc8e496aa_SiteId=81fa766e-a349-4867-8bf4-ab35e250a08f;MSIP_Label_7fea2623-af8f-4fb8-b1cf-b63cc8e496aa_SetDate=2021-12-13T22:12:48.726Z;MSIP_Label_7fea2623-af8f-4fb8-b1cf-b63cc8e496aa_Name=Proprietary;MSIP_Label_7fea2623-af8f-4fb8-b1cf-b63cc8e496aa_ContentBits=0;MSIP_Label_7fea2623-af8f-4fb8-b1cf-b63cc8e496aa_Method=Standard;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9fba0477-69d1-4e66-8463-08d9c4d0b54c
x-ms-traffictypediagnostic: DM6PR11MB2859:EE_
x-microsoft-antispam-prvs: <DM6PR11MB285908DF90436645F02AC7B6FB7C9@DM6PR11MB2859.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lqJ2TNS6sWm1F9cqA6eTz3F7nFK4TinRdfeTE/Q3rY+rjMTK8nh18cr+RFOo3qyuwapfF0QfV2JgyZ5c9CjZnvP/Dmz3/2NJTksu5NAHLR9yLHc7PpXkURHbYRyTmW9smysxybgmhmW7QTDIvX9sH8/NE8/n4z7k1ZjKiGmv0Ge4l24+XHUEBdva1Ygs4BS9kjdqEhot00DaHgo1y3BAKKR6Tt7EJOjr/7bVpAWvyjCvsZxkoB8Bg7dDgivJ5Jer/8hoGt6uqWte6d55b4+GOmhT++6bXDmKKxxspWBSslUCYTi7QSenIs1Ejkdn4Vxb7hBcBBQl/xhaB9vIEz8AZ8e1+Rz1DnryazHIXv0+BbRJyeHul7Ng87x3A/i0l1XZzzTqrT+i8acbkbewWene02C1jRcYhSFsjTPAfadqORmFVVAhykt8cRvw5cS2YxDCgrIAnuaCjMPFhcluAKFl77AHyROKoaMaHQzcZmkrvxAI+mHUFf9t1K7kr8WISSDEHLsVLDU8u+RjVlYuGp2pNKkw2rlXfLUoUfG68UcjNOOe4jejLT8gAEpuoDeansAVj0SNghy/ZYOFktfM+O2srxkPB/aXWz6zPBJzAQG57HEEbfgS0HCB2EwlpMU2vbJmFEJWXriy2+uzrAqXPSyMjWAz1L1WS/1uLgx71ybEHiHbOe8kpiEAgt0GOXovLPmHeBO0jDwkGM9B446b+3LgEw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5390.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(122000001)(38100700002)(76116006)(38070700005)(55016003)(83380400001)(316002)(8936002)(86362001)(4326008)(9686003)(66446008)(2906002)(7696005)(110136005)(54906003)(5660300002)(66476007)(66946007)(66556008)(64756008)(52536014)(26005)(33656002)(6506007)(186003)(71200400001)(508600001)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?DnODoBFlw6ScomaxLEKl/izWTAXJmVLYlwpepsWoTgu0zJpLi6Ck3ToGTV?=
 =?iso-8859-1?Q?5cEH5yWXO9GLuHFuws/FGJx5rXfKKAGZjHjqRuIQJYc16Jj/tWqbs0Bel0?=
 =?iso-8859-1?Q?2OhGTrKdbiqyRaxauYBRDSFFOQEwrftrpWkk1VmSMsh9218X2cOuw6K+w8?=
 =?iso-8859-1?Q?fmPKxtnYIj1ObfQxI5SYgzjalMo2rN6nYI4md9svTbkbTzMtuHsx+wFRV4?=
 =?iso-8859-1?Q?BlLYngWtnfQEP2NSwqn3wNtGbQP4frcPTaD0L8BwLfKjvSUoUnymKOs5I0?=
 =?iso-8859-1?Q?Ll8ehF7zf1ybu/qJfkwIsxFwONY0e4W7WAB7UKEQzp46qDIyBUeDa7OG24?=
 =?iso-8859-1?Q?84nGxyzvn/8v/cis4YQYCoYI//agyyISSpUgs6v8hSb73fSMXjinW5HrbA?=
 =?iso-8859-1?Q?Ut8CKQ7vmd3INIRv89a29XoCbLf0lMNNPCabS8r6TaFxRmAXral9Oz+GLF?=
 =?iso-8859-1?Q?2emft/0yorF3a96Og3DyMgE8IA2Y7vqT8ecjylrnWW/dkeMwROYm524gF4?=
 =?iso-8859-1?Q?SnTgjaFwVoY6FI7Ud/wIeh0ci1E7efxjwcTDGf0JwTOAEiE25CXLTBfiSW?=
 =?iso-8859-1?Q?BtsDC/SzxO+GuKJC2g8aoJm+YnVXc4Wsajg+E1AKH8LI8s0qCvgBRdB3vU?=
 =?iso-8859-1?Q?B1bPpIgUmv7D5VO52jhgUORmu2y1RxZLN97C0IEmm6igiFYaIJYLTQjMNL?=
 =?iso-8859-1?Q?oZZwq1451Nf15tLRKtWdsvpNJ8dTThkDds4FGJ3Jlqd0AM3tSeZYFpemsp?=
 =?iso-8859-1?Q?VxECt7TvDxro+okpOKnEoBXbgNgXPXrAOAWlSxlQHJFgU7k/ODZ0Ijsph6?=
 =?iso-8859-1?Q?mNxQoCyaNs87h1YxEibX5wY1wFe3KepJSuj5+zLsZytLY2PsEikMegbraX?=
 =?iso-8859-1?Q?B+3J8J/70DtxH+PWnkroreQYQc0NEoPgVyuF3bbz71TK8naqZhnnHUsOfy?=
 =?iso-8859-1?Q?pD9v/QrQbBTV9zXsmZSxG9KMVwV+kJ6SVEXpUCmFcweY4atcHfvIYxadtt?=
 =?iso-8859-1?Q?zA9V1GKGR3PGw2G0GIQ2Bbdcdj+VuzuchpxcpmwgJ28UgbmsTG3g4Tzzu4?=
 =?iso-8859-1?Q?id5lOykKrOKn11koCdD1tDVf5L2gFOcMEuRPdpu2YAV4qn+8z21B1GAZW4?=
 =?iso-8859-1?Q?2nf69n78xirJHvLL1GLIWT1n59qGKrZQojc4YABTN+HumdekOGoHAqaEbh?=
 =?iso-8859-1?Q?yTEItYtSYmWTar9upc6H0psfoq9PpX/83kcKoBj+wHml6hdfiZzOIZKyh2?=
 =?iso-8859-1?Q?J6Uuh0c93CTbbcYUkBdAK9nD9NwwOiiyyZ7FrV6eXx/fbVz1wtmz63PqxY?=
 =?iso-8859-1?Q?Il4IR3BHu/WbXVhOJpmmCRjAh16JBWFCqk/D4xif56Qv0vg+bNHK6ByWMT?=
 =?iso-8859-1?Q?q8BU+1QrUAYyoHLrRvnPamzygW8p4ALMf57Psek9ylhc2/A+f7LGFFJC/L?=
 =?iso-8859-1?Q?cV4klmbaaVxIi6c3klrl+Eb6t5TzYrXj+NLmI5yXu3Tu2WlAzTLKboxfMa?=
 =?iso-8859-1?Q?3+KhBTVcrmEhaid3cEI0gER2dNaJk0kIVfXlP3UikSMgUwDYnGApXKI23n?=
 =?iso-8859-1?Q?RFdpMTYMX49eYy2Bt9DQaiK7T9OW1MtJCUFRfakaTT90k/o3DVNSyWw/uQ?=
 =?iso-8859-1?Q?Bg31S3BGFL1bee0p/X7hsb3FaIfKK6VeXSbySb/eQHzLJgfntGhhPvNexf?=
 =?iso-8859-1?Q?l6mER5Ci7FrnF14utLyB5JqQkgkTNFIANAFFTdqK9lB8PM6z1hRHOz3g7P?=
 =?iso-8859-1?Q?6ubA=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5390.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fba0477-69d1-4e66-8463-08d9c4d0b54c
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2021 22:24:52.2630
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZeK2yOAT+IR7GE6V2LlvOkGALkz/oife4zNJ+GEWYDfXzTdS5TlvzRh5mc7tVxL+nebdzw3YujtW0QYUR6T5uS4yynvhFCHsKkW+bJtevuM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2859
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pavel,

> >=A0> We have the similar CRC read errors but
> > > the lowest byte is not 0x00 and 0x80, it's actually 0x0x or 0x8x, e.g=
.
> > >
> >=A0> mcp251xfd spi0.0 can0: CRC read error at address 0x0010 (length=3D4=
,
> >=A0> data=3D82 d1 fa 6c, CRC=3D0xd9c2) retrying.
> >=A0>
> >=A0> 0xb0 0x10 0x04 0x82 0xd1 0xfa 0x6c =3D> 0x59FD (not matching)
> >=A0>
> >=A0> but if I flip the first received bit  (highest bit in the lowest by=
te):
> >=A0> 0xb0 0x10 0x04 0x02 0xd1 0xfa 0x6c =3D> 0xD9C2 (matching!)
>=20
> >=A0What settings do you have on your setup? Can you please print the
> dmesg output from the init? I'm especially interested in Sysclk and SPI
> speed.
>=20
> mcp251xfd spi0.0 can0: MCP2517FD rev0.0 (-RX_INT +MAB_NO_WARN
> +CRC_REG +CRC_RX +CRC_TX +ECC -HD c:40.00MHz m:10.00MHz
> r:10.00MHz e:10.00MHz) successfully initialized.

Thanks for the data. I've looked into this and it seems that the second bit=
 being set in your case does not depend on the SPI-Rate (or the quirks for =
that matter) but it seems to be hardware setup related.=20
I'm fine with changing the driver so that it ignores set LSBs but would lim=
it it to 2 or 3 bits:
(buf_rx->data[0] =3D=3D 0x0 || buf_rx->data[0] =3D=3D 0x80))
becomes
((buf_rx->data[0] & 0xf8) =3D=3D 0x0 || (buf_rx->data[0] & 0xf8) =3D=3D 0x8=
0)) {

The action also needs to be changed and the flip back of the bit needs to b=
e removed. In this case the flipped databit that produces a matching CRC is=
 actually  correct (i.e. consistent with the 7 LSBs in that byte.)
A patch could look like this (I'm currently not close to a setup where I ca=
n compile/test this.)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c b/drivers/net=
/can/spi/mcp251xfd/mcp251xfd-regmap.c
index 297491516a26..e5bc897f37e8 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c
@@ -332,12 +332,10 @@ mcp251xfd_regmap_crc_read(void *context,
                 *
                 * If the highest bit in the lowest byte is flipped
                 * the transferred CRC matches the calculated one. We
-                * assume for now the CRC calculation in the chip
-                * works on wrong data and the transferred data is
-                * correct.
+                * assume for now the CRC operates on the correct data.
                 */
                if (reg =3D=3D MCP251XFD_REG_TBC &&
-                   (buf_rx->data[0] =3D=3D 0x0 || buf_rx->data[0] =3D=3D 0=
x80)) {
+                   ((buf_rx->data[0] & 0xF8) =3D=3D 0x0 || (buf_rx->data[0=
] & 0xF8) =3D=3D 0x80)) {
                        /* Flip highest bit in lowest byte of le32 */
                        buf_rx->data[0] ^=3D 0x80;

@@ -347,10 +345,8 @@ mcp251xfd_regmap_crc_read(void *context,
                                                                  val_len);
                        if (!err) {
                                /* If CRC is now correct, assume
-                                * transferred data was OK, flip bit
-                                * back to original value.
+                                * flipped data was OK.
                                 */
-                               buf_rx->data[0] ^=3D 0x80;
                                goto out;
                        }
                }

Thanks,
Thomas
