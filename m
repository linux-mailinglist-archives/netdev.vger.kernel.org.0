Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29B1A14951A
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 12:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgAYLMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 06:12:08 -0500
Received: from mail-eopbgr30093.outbound.protection.outlook.com ([40.107.3.93]:58106
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725767AbgAYLMH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jan 2020 06:12:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rw/r6s2TIHRwWF5VsVj4XKZvBKRol3sgesp2J2iVz3qQPQHBWE9hsiQf6x9Te0IlZ8UOugrhfj+fbplDk+/YJS38ijYHyrgdQo3Qx2a+6rJl25pagJnpYJl3wx2FojsmK8tEcHmK4Mf8tCjMfwbL1X8aUN8kd/HJFUgWbsTDHkwXzEkT+31xtxmCjiFcjT9+O/JmFgO98EzOgMB608FGogxk5sSJd/+LdBF3mV6UKYgS4VERLr8AcvQ+A+VCuZeBkGqA7POLM2uO72U1arfYPxIuI7NCL/uHid7AHFwA966FQJzkhHYZ+vPHV5dLDL9SRanMJUb/yQpdgqogox6e1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8YDVjPFeaxp6QlcHjRT526FrapfLiyjeKvt8jSIK9nk=;
 b=F8EIyNaT0VCt5YS+NGtg1tzpTW53JWr4VK/ZBQvlpSXSylM2m0ykQsR9dGOD1TA5GviqH/lXBLs4+koJMAuOwk+aKaZCS1qQHu+rimiewnLFO0HM9UytUy4uF9l+XG/SHauIRPZxPSAJN9b4YRIFHBRRGObvw1gETZYUeKvXp+yhOBZHTsJkbZ6z9HIVKW1G2kDLZXLraDhw/Lo3Va/i8ZktfFtyXM564okaOdfWUQ10u4jB5nLTUp5s9p6zupewJKLW2GwelBSdEZ+voR9qiJWnal1BIAw1F5fLTahX6bjdtg7wcGdCcNnoghu7Fq+Y/LRLFIEyfrboOuZIcJcsxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8YDVjPFeaxp6QlcHjRT526FrapfLiyjeKvt8jSIK9nk=;
 b=OTnvyKt6e2u1xWWPCjYWwUI8WyAR4qeZoAz3WEPXkNjtUVlxDK7eQyWlTfCL2vUZB2W37efLVnJNROPfXtgEqOnqMFnVIrfORt0pc6JQYRMnJHqHbMUZ6QvG97znM3i6u8c21osoH2xpsdpTdNsPRjT3T1HUv/DlnN+QWkDkyIs=
Received: from AM0PR05MB5156.eurprd05.prod.outlook.com (20.178.20.19) by
 AM0PR05MB5924.eurprd05.prod.outlook.com (20.178.202.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.20; Sat, 25 Jan 2020 11:12:00 +0000
Received: from AM0PR05MB5156.eurprd05.prod.outlook.com
 ([fe80::28cb:442b:6907:83e7]) by AM0PR05MB5156.eurprd05.prod.outlook.com
 ([fe80::28cb:442b:6907:83e7%6]) with mapi id 15.20.2665.017; Sat, 25 Jan 2020
 11:12:00 +0000
Received: from SvensMacBookAir.sven.lan (78.43.2.70) by AM0PR06CA0095.eurprd06.prod.outlook.com (20.178.20.228) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.22 via Frontend Transport; Sat, 25 Jan 2020 11:11:59 +0000
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
Thread-Index: AQHV0Qt0wGHHU1bPe06KgczxouriXaf3TJoAgAJ+uwCAAXMYAA==
Date:   Sat, 25 Jan 2020 11:11:59 +0000
Message-ID: <20200125111158.nge3qahnocq2obot@SvensMacBookAir.sven.lan>
References: <C39F91BD-26BA-4373-A056-CE2E6B9D750E@voleatech.de>
 <20200122225740.GA3384@localhost.localdomain>
 <20200124120344.y3avbjdiu6gtmhbr@SvensMacbookPro.hq.voleatech.com>
In-Reply-To: <20200124120344.y3avbjdiu6gtmhbr@SvensMacbookPro.hq.voleatech.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR06CA0095.eurprd06.prod.outlook.com (20.178.20.228) To
 AM0PR05MB5156.eurprd05.prod.outlook.com (20.178.20.19)
x-originating-ip: [78.43.2.70]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sven.auhagen@voleatech.de; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5e00c8d3-fc83-4251-8d1b-08d7a18765cd
x-ms-traffictypediagnostic: AM0PR05MB5924:|AM0PR05MB5924:
x-microsoft-antispam-prvs: <AM0PR05MB592482BB585597BA966B8A63EF090@AM0PR05MB5924.eurprd05.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0293D40691
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(136003)(366004)(346002)(39830400003)(396003)(199004)(189003)(107886003)(86362001)(8936002)(8676002)(966005)(6862004)(316002)(44832011)(71200400001)(54906003)(508600001)(956004)(66946007)(2906002)(186003)(16526019)(64756008)(66476007)(66556008)(66446008)(81156014)(45080400002)(81166006)(55016002)(7696005)(52116002)(6506007)(26005)(9686003)(4326008)(66574012)(1076003)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM0PR05MB5924;H:AM0PR05MB5156.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: voleatech.de does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5XyjX77vhyzqQC3mFqmn6p1g6ueZKSnM1loxuV7jK4gGuWOwZO2Fx5j6baQTyXAwLV7qWkxE84y0qtaAGYxEBBAvAbgEP8OdAyXFo7YjTvS6kwprbqNdQblM7FFz/DGlr8kh3zvVD4SY53jBzxQReIaUBLd+BRDQlI1cERR0texdSYKFyzJLkqJVSTIQzMjIIkR+ytCQP3apWc85EtuSyjiK4ZaJLQpvq4mT+Xnt0gXQ7N7ZWLiH2WYIRWnCscpGQUJ38BT6DI+p5PMTUCwUSdCQpkSKmYuLwFOWwS6eABoR4DNUujLBWFBJ6mVvgcQkxYCzeqXpHa1LgcM3zIdSfGtyXTbRd/9NtBXiTKiDtElbVrrA587GVoE89qS1g2f+TLG9XLXK+TSEFAF1U9x0ma05kAQ5rlVXCiRvjt+q2AEQpJcBKaDPBz4sg1ho3NkJNyIPKx4Ku+x59l3K0HKc5sx2Lmusbin7cgP0AfrX6Mw=
x-ms-exchange-antispam-messagedata: M1+0Eqry0U/wHMC5RrLIT98rm2MyDE5sj/tkFWESYh7Yi527LG1VbHSDLO4gJRO18XvuP6r/79BqwORHC/NHE6a+VdrHPQiMVMTSuUV2/wo2LAoG7El5ErIeWFMVBaQr6EgmXPb9G50FdXLbDVXAZg==
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <868AF094B9A0674285FC090C4683ABE5@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e00c8d3-fc83-4251-8d1b-08d7a18765cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2020 11:12:00.1898
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g2rMvvUW4NCUXq4YIi0jR1VTFHykRjV3KRlX2AvdgyVNepLMUpYbaHatl4T/oi9tk5lOdpGgGL4yORtOSW1mlZD+tvhh+fezVSnzq2vwVFM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5924
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 24, 2020 at 12:03:46PM +0000, Sven Auhagen wrote:
> On Wed, Jan 22, 2020 at 11:57:40PM +0100, lorenzo.bianconi@redhat.com wro=
te:
> > Hi Sven,
> >=20
> > > Recently XDP Support was added to the mvneta driver for software buff=
er management.
> > > I tested XDP with my armada 388 board. It has hardware buffer managem=
ent defined in the device tree file.
> > > I disabled the mvneta_bm module to test XDP.
> > >=20
> > > I found multiple problems.
> > >=20
> > > 1. With hardware buffer management enabled and mvneta_bm disabled the=
 rx_offset was set to 0 with armhf (32 bit) which leads to no headroom in X=
DP and therefore the XDP Redirect did not work.
> > > 2. Removing the hardware buffer management from the device tree file =
completely made the mvneta driver unusable as it did not work anymore.
> >=20
> > Do you mean removing 'buffer-manager' property from the device tree?
>=20
> Yes removing it from each nics device tree definition.
> The if statement is not used in that case and the rx_offset_correction is=
 always MVNETA_SKB_HEADROOM.
>=20
> >=20
> > >=20
> > > After some debugging I found out that xdp->data =3D data + pp->rx_off=
set_correction + MVNETA_MH_SIZE;  has to be xdp->data =3D data + pp->rx_off=
set_correction; if pp->rx_offset_correction > 0.
> > > I am not sure why and I am looking for help if someone is seeing the =
same on an arm64 board.
> >=20
> > Are you sure the hw does not insert the mvneta header before the data? =
It seems
> > to me that it is added even for hw buffer devices (according to the cod=
e)
>=20
> It is definitely possible. The 2 bytes before the data are 0. I believe
> the mvneta header is also 0 when no switch is attached.
> Is it added when a hw buffer capable device is not using and initializing
> the hw buffer?
>=20
> Do you have any documentation regarding the header?
> I have access to the Marvell Extranet but could not find anything.

I think I found the problem. I found the documentation finally and it state=
s:

The physical buffer pointer must be 64-bit aligned; therefore, bits[2:0] of=
 the pointers are considered as zeros.

rx_offset is defined as MVNETA_SKB_HEADROOM which in turn is:

#define MVNETA_SKB_HEADROOM	(max(XDP_PACKET_HEADROOM, NET_SKB_PAD) + \
				 NET_IP_ALIGN)

this leads to an offset on armhf of 258 which is not 64 bit aligned and the=
refore
shortened to 256 hence the MH header is actually at 256.

This would explain my problem.

Any thoughts?

Best
Sven

>=20
> >=20
> > >=20
> > > Attached is a patch that fixes the problem on my armhf platform, as s=
aid I am not sure if this is a universal fix or armhf only.
> > >=20
> > > Any feedback is appreciated.
> > >=20
> > > Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
> > >=20
> > > --- a/drivers/net/ethernet/marvell/mvneta.c2020-01-22 08:44:05.611395=
960 +0000
> > > +++ b/drivers/net/ethernet/marvell/mvneta.c2020-01-22 08:59:27.053739=
433 +0000
> > > @@ -2158,7 +2158,7 @@ mvneta_swbm_rx_frame(struct mvneta_port
> > >  prefetch(data);
> > >=20
> > >  xdp->data_hard_start =3D data;
> > > -xdp->data =3D data + pp->rx_offset_correction + MVNETA_MH_SIZE;
> > > +xdp->data =3D data + pp->rx_offset_correction;
> >=20
> > This will break XDP support for 'real' sw buffer devices like Espressob=
in.
>=20
> The current code seems to break real hw buffer devices using sw buffer on=
 armhf though.
>=20
> Best
> Sven
>=20
> >=20
> > Regards,
> > Lorenzo
> >=20
> > >  xdp->data_end =3D xdp->data + data_len;
> > >  xdp_set_data_meta_invalid(xdp);
> > >=20
> > > @@ -4960,7 +4960,8 @@ static int mvneta_probe(struct platform_
> > >   * NET_SKB_PAD, exceeds 64B. It should be 64B for 64-bit
> > >   * platforms and 0B for 32-bit ones.
> > >   */
> > > -pp->rx_offset_correction =3D max(0,
> > > +if (pp->bm_priv)
> > > +pp->rx_offset_correction =3D max(0,
> > >         NET_SKB_PAD -
> > >         MVNETA_RX_PKT_OFFSET_CORRECTION);
> > >  }
> > >=20
> > >=20
> > >=20
> > >=20
> > > +++ Voleatech auf der E-World, 11. bis 13. Februar 2020, Halle 5, Sta=
nd 521 +++
> > >=20
> > > Beste Gr=FC=DFe/Best regards
> > >=20
> > > Sven Auhagen
> > > Dipl. Math. oec., M.Sc.
> > > Voleatech GmbH
> > > HRB: B 754643
> > > USTID: DE303643180
> > > Grathwohlstr. 5
> > > 72762 Reutlingen
> > > Tel: +49 7121539550
> > > Fax: +49 7121539551
> > > E-Mail: sven.auhagen@voleatech.de
> > > https://eur03.safelinks.protection.outlook.com/?url=3Dwww.voleatech.d=
e&amp;data=3D02%7C01%7Csven.auhagen%40voleatech.de%7C16ecc6de7670473d7de108=
d7a0c5cf85%7Cb82a99f679814a7295344d35298f847b%7C0%7C0%7C637154643755759442&=
amp;sdata=3DPlhiaiQCqIc9Pmkux%2B8xLf%2FiwP3Nn3UsMRozhbX%2FR%2B0%3D&amp;rese=
rved=3D0<https://eur03.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%=
2Fwww.voleatech.de&amp;data=3D02%7C01%7Csven.auhagen%40voleatech.de%7C16ecc=
6de7670473d7de108d7a0c5cf85%7Cb82a99f679814a7295344d35298f847b%7C0%7C0%7C63=
7154643755759442&amp;sdata=3DsSpe8NSqXN8dJOp%2Fb%2FaaHcEPTdtT4jE59ek97VvTtl=
Y%3D&amp;reserved=3D0>
> > > Diese Information ist ausschlie=DFlich f=FCr den Adressaten bestimmt =
und kann vertraulich oder gesetzlich gesch=FCtzte Informationen enthalten. =
Wenn Sie nicht der bestimmungsgem=E4=DFe Adressat sind, unterrichten Sie bi=
tte den Absender und vernichten Sie diese Mail. Anderen als dem bestimmungs=
gem=E4=DFen Adressaten ist es untersagt, diese E-Mail zu lesen, zu speicher=
n, weiterzuleiten oder ihren Inhalt auf welche Weise auch immer zu verwende=
n. F=FCr den Adressaten sind die Informationen in dieser Mail nur zum pers=
=F6nlichen Gebrauch. Eine Weiterleitung darf nur nach R=FCcksprache mit dem=
 Absender erfolgen. Wir verwenden aktuelle Virenschutzprogramme. F=FCr Sch=
=E4den, die dem Empf=E4nger gleichwohl durch von uns zugesandte mit Viren b=
efallene E-Mails entstehen, schlie=DFen wir jede Haftung aus.
>=20
>=20
>=20
