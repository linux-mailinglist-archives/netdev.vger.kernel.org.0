Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 493D91484D3
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 13:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730379AbgAXMFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 07:05:54 -0500
Received: from mail-vi1eur05on2092.outbound.protection.outlook.com ([40.107.21.92]:24928
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725767AbgAXMFy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 07:05:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y1lQOWH+//c8qIv/LhzocnSbHyTTZoPuM36yc7hdvF0ZVWVczPhY7nE6rlJ8u8beiMCsYwexZZdoFtrJqnx3HCGK1OM80WrmUaI5YMn/rCMdPwxso1QnJ3fNITksSG54gxs0sxKrrIfc5J1FBn4xvghk8e8N37RxzSmVKd6tnEsWIV/sjvTvwu1z+I8JfB/c5hX0YhQ9Jaa1l6P/v5X5uszXM4uGisRVaIpmo3g0uEl9Oj9Q+ilzW8AtlKpVfI+EonGHw/ga92mMOUuUD8FBAx4dH4Hyl47t82GGHQzE7YebbVvzrkiTNJzcXGaisccQ1a5KrArObS8cuDQPkPtDog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qzH5nzH5ItBccOe/KGKF9fE1Df2D0eSHdFrqQjIyYGM=;
 b=A5lZCj4ounD63R5/2LVGdL+Gt0jOPBnstOPmtaqqxrp3PoXYM0lUZ1eyzYKTr05i5bCwtdTc41oStGvbXDh6cRdBnNun4mZYvILXxyP7OcDSWHXidM2Wu0YNHqBSqRIr4WMqpjAmEJ1pEMONwJRjdEzJkTNxYUSEZz+38rTkFGEB+DNjOQFnc0vUIvua8k9yBhy/ftqstGrP6qGdhGv+nMv2/rIFeeABw4zWI8F2yMfa1uUkKSlnd7XNcNGaJ9T2deZw/bXV66x4yxiGlO1w0qzFrzIUechyjV3nXGMBLdbzNXk+IzAuOCN75+uPfLTnV28k4FvJA4tghl6hMgSq4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qzH5nzH5ItBccOe/KGKF9fE1Df2D0eSHdFrqQjIyYGM=;
 b=PaTKDXHvq1os7KiwmweXFvSkrtDzrWnUpj3vP7I3/4O0c55Qxb+jjccUsQ8pLe3G7DQ17pJGXWP7/UcXG6iGrfJ7CRk9AYyQC9oxn4hu1d4O8fKkrHkw4+TTGho0CdBjKyEQDyGrW+s+N6oB4Y+z/0F7wn5jYImLR/0bqXpEwlo=
Received: from AM0PR05MB5156.eurprd05.prod.outlook.com (20.178.20.19) by
 AM0PR05MB4674.eurprd05.prod.outlook.com (52.133.59.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.24; Fri, 24 Jan 2020 12:03:46 +0000
Received: from AM0PR05MB5156.eurprd05.prod.outlook.com
 ([fe80::28cb:442b:6907:83e7]) by AM0PR05MB5156.eurprd05.prod.outlook.com
 ([fe80::28cb:442b:6907:83e7%6]) with mapi id 15.20.2644.028; Fri, 24 Jan 2020
 12:03:46 +0000
Received: from SvensMacbookPro.hq.voleatech.com (37.24.174.42) by FR2P281CA0014.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:a::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.22 via Frontend Transport; Fri, 24 Jan 2020 12:03:45 +0000
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     "lorenzo.bianconi@redhat.com" <lorenzo.bianconi@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "matteo.croce@redhat.com" <matteo.croce@redhat.com>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
Subject: Re: [PATCH] mvneta driver XDP fixes armhf
Thread-Topic: [PATCH] mvneta driver XDP fixes armhf
Thread-Index: AQHV0Qt0wGHHU1bPe06KgczxouriXaf3TJoAgAJt9QA=
Date:   Fri, 24 Jan 2020 12:03:46 +0000
Message-ID: <20200124120344.y3avbjdiu6gtmhbr@SvensMacbookPro.hq.voleatech.com>
References: <C39F91BD-26BA-4373-A056-CE2E6B9D750E@voleatech.de>
 <20200122225740.GA3384@localhost.localdomain>
In-Reply-To: <20200122225740.GA3384@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: FR2P281CA0014.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::24) To AM0PR05MB5156.eurprd05.prod.outlook.com
 (2603:10a6:208:f7::19)
x-originating-ip: [37.24.174.42]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sven.auhagen@voleatech.de; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8812aa2d-82e5-4ca7-4a6a-08d7a0c576de
x-ms-traffictypediagnostic: AM0PR05MB4674:|AM0PR05MB4674:
x-microsoft-antispam-prvs: <AM0PR05MB46741FACCDFF29B6ABAE2262EF0E0@AM0PR05MB4674.eurprd05.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02929ECF07
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(136003)(396003)(39830400003)(346002)(376002)(199004)(189003)(2906002)(86362001)(9686003)(55016002)(1076003)(66574012)(66446008)(71200400001)(7696005)(5660300002)(107886003)(66946007)(16526019)(8936002)(956004)(44832011)(15974865002)(66476007)(81166006)(186003)(81156014)(66556008)(64756008)(6862004)(26005)(6506007)(8676002)(52116002)(316002)(508600001)(54906003)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:AM0PR05MB4674;H:AM0PR05MB5156.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: voleatech.de does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1cJckrLWN/a4cCkSBgT1qDi3q9nKVoFsLGl/mx/ZAQv7rU+myNNpi+XToQ+R+XYzgGmsW6U6jSPsbhedfy0eW6iZ+JKaCb7fdpAvRlvWee6JbrG1adRZeCbtUeJjweWyYhdZLfJLlXI7hDd9bjo/PqAv7ued0rQT8NB/LPxE61m2Be+hol/6mW1Jvd3btQqW8vgumMiXGkP8su64Oi4YzsmqHct7e+LecsfEzICtACQf96S2N/y17AgptopgTMB9xOtaKB2wTMYbZlCH/sie7x2BidZBDHaIuv9PBUgS6E3Hy5TATeZtPnbZpbZB6F3iBTJbCbCAYT1LQvN9uvPhXuNLVXPmfErvwC6acyrlLpgxTKxoWezkGaK0pq8XzZjoBb0aDpA1TgkXRD38O02DafNlsEjXVPLyVr9e4H4/6EhadSKjRAAt3I/O0/MP/zarTvHIpoG2KYm6jidJcZnwL2oy5Zv1NOwnRo5DiUu6vKI=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <AD2AFC7E385DAF4F8DF59AEEAD9AF525@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 8812aa2d-82e5-4ca7-4a6a-08d7a0c576de
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2020 12:03:46.1394
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vK7RlJNktYI9TA58j4tUXHfmay8EfLgAwnBh88jkiTfg75O7bvQkru02EPE1+xmtYSgaiZuqk6ju4w3oK3/UWzpBCI44DtZCrQESzGir0G4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4674
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 22, 2020 at 11:57:40PM +0100, lorenzo.bianconi@redhat.com wrote=
:
> Hi Sven,
>=20
> > Recently XDP Support was added to the mvneta driver for software buffer=
 management.
> > I tested XDP with my armada 388 board. It has hardware buffer managemen=
t defined in the device tree file.
> > I disabled the mvneta_bm module to test XDP.
> >=20
> > I found multiple problems.
> >=20
> > 1. With hardware buffer management enabled and mvneta_bm disabled the r=
x_offset was set to 0 with armhf (32 bit) which leads to no headroom in XDP=
 and therefore the XDP Redirect did not work.
> > 2. Removing the hardware buffer management from the device tree file co=
mpletely made the mvneta driver unusable as it did not work anymore.
>=20
> Do you mean removing 'buffer-manager' property from the device tree?

Yes removing it from each nics device tree definition.
The if statement is not used in that case and the rx_offset_correction is a=
lways MVNETA_SKB_HEADROOM.

>=20
> >=20
> > After some debugging I found out that xdp->data =3D data + pp->rx_offse=
t_correction + MVNETA_MH_SIZE;  has to be xdp->data =3D data + pp->rx_offse=
t_correction; if pp->rx_offset_correction > 0.
> > I am not sure why and I am looking for help if someone is seeing the sa=
me on an arm64 board.
>=20
> Are you sure the hw does not insert the mvneta header before the data? It=
 seems
> to me that it is added even for hw buffer devices (according to the code)

It is definitely possible. The 2 bytes before the data are 0. I believe
the mvneta header is also 0 when no switch is attached.
Is it added when a hw buffer capable device is not using and initializing
the hw buffer?

Do you have any documentation regarding the header?
I have access to the Marvell Extranet but could not find anything.

>=20
> >=20
> > Attached is a patch that fixes the problem on my armhf platform, as sai=
d I am not sure if this is a universal fix or armhf only.
> >=20
> > Any feedback is appreciated.
> >=20
> > Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
> >=20
> > --- a/drivers/net/ethernet/marvell/mvneta.c2020-01-22 08:44:05.61139596=
0 +0000
> > +++ b/drivers/net/ethernet/marvell/mvneta.c2020-01-22 08:59:27.05373943=
3 +0000
> > @@ -2158,7 +2158,7 @@ mvneta_swbm_rx_frame(struct mvneta_port
> >  prefetch(data);
> >=20
> >  xdp->data_hard_start =3D data;
> > -xdp->data =3D data + pp->rx_offset_correction + MVNETA_MH_SIZE;
> > +xdp->data =3D data + pp->rx_offset_correction;
>=20
> This will break XDP support for 'real' sw buffer devices like Espressobin=
.

The current code seems to break real hw buffer devices using sw buffer on a=
rmhf though.

Best
Sven

>=20
> Regards,
> Lorenzo
>=20
> >  xdp->data_end =3D xdp->data + data_len;
> >  xdp_set_data_meta_invalid(xdp);
> >=20
> > @@ -4960,7 +4960,8 @@ static int mvneta_probe(struct platform_
> >   * NET_SKB_PAD, exceeds 64B. It should be 64B for 64-bit
> >   * platforms and 0B for 32-bit ones.
> >   */
> > -pp->rx_offset_correction =3D max(0,
> > +if (pp->bm_priv)
> > +pp->rx_offset_correction =3D max(0,
> >         NET_SKB_PAD -
> >         MVNETA_RX_PKT_OFFSET_CORRECTION);
> >  }
> >=20
> >=20
> >=20
> >=20
> > +++ Voleatech auf der E-World, 11. bis 13. Februar 2020, Halle 5, Stand=
 521 +++
> >=20
> > Beste Gr=FC=DFe/Best regards
> >=20
> > Sven Auhagen
> > Dipl. Math. oec., M.Sc.
> > Voleatech GmbH
> > HRB: B 754643
> > USTID: DE303643180
> > Grathwohlstr. 5
> > 72762 Reutlingen
> > Tel: +49 7121539550
> > Fax: +49 7121539551
> > E-Mail: sven.auhagen@voleatech.de
> > www.voleatech.de<https://www.voleatech.de>
> > Diese Information ist ausschlie=DFlich f=FCr den Adressaten bestimmt un=
d kann vertraulich oder gesetzlich gesch=FCtzte Informationen enthalten. We=
nn Sie nicht der bestimmungsgem=E4=DFe Adressat sind, unterrichten Sie bitt=
e den Absender und vernichten Sie diese Mail. Anderen als dem bestimmungsge=
m=E4=DFen Adressaten ist es untersagt, diese E-Mail zu lesen, zu speichern,=
 weiterzuleiten oder ihren Inhalt auf welche Weise auch immer zu verwenden.=
 F=FCr den Adressaten sind die Informationen in dieser Mail nur zum pers=F6=
nlichen Gebrauch. Eine Weiterleitung darf nur nach R=FCcksprache mit dem Ab=
sender erfolgen. Wir verwenden aktuelle Virenschutzprogramme. F=FCr Sch=E4d=
en, die dem Empf=E4nger gleichwohl durch von uns zugesandte mit Viren befal=
lene E-Mails entstehen, schlie=DFen wir jede Haftung aus.


