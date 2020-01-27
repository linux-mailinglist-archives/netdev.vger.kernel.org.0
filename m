Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F381C14A13F
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 10:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgA0J41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 04:56:27 -0500
Received: from mail-eopbgr130104.outbound.protection.outlook.com ([40.107.13.104]:29573
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725807AbgA0J40 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 04:56:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WTrmmovBb+e4w945XVPjw0SRaCBZuxfKqPtjoHWH2upVykDCnx7SyLpB9Eps/UPTvlmZpwq+bGOEMGlevCYJnl4xnZRrmwf/wu/J9vew7mtlSHRKug3sFxLxeHeXR1dGQuLEszHzsLBDw39sRQeCNl3kw72nKqhpdkGUWKtgWn+RLdF5pTMySgcw8gUdP4KBlXhRPM+o0sbEr7JPMvv+LkHrA0xiiNKyXOp2Rwcou/Up3IqeAe9xVXicJqgAq1xrNknBYJFCF3SJ0aHt2kD3aeFzIm0DtKRZzWZsMKUJoP2FaX/bcXclfGEmqx3//ncRopCF0wnxmUlHm2pNif87Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hv1gB6Plqflb4wjWlsCfecESkJ8nWle3uqHvmQHTjfk=;
 b=hqovsQ/1U46WU9fhneu+jctP1COsJfc1MGKj1a7V9pjapOfEaRtm/GQrwUhW5/2k5Au6Lti4a0mpvkOYM5Wr/xCJ0MdaSqLnXvKM5qCbktL3P3GYQ0wWHVV5DHQSliHMzFcqDvO6Co17JbwliTEtaPlcFt7ACxwKZni30HcuwY0od/tTFJaPd2VkwTwXV35+s1edg1eCVoOrotFO4uWDZYGKYEKKdGFpWoztue0FK3vbz6Xhh2UGQSXhoq6t61HO2c6maD50eMbXMaK77oIXhAjGYn1ULt/+lAvGVVMxOgFCpbrabeATXTjpBmk+7wkt5fGIrRpHGYB8I3Vj+RQI+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hv1gB6Plqflb4wjWlsCfecESkJ8nWle3uqHvmQHTjfk=;
 b=EKnX07U4UbK0yKJKCii34INTqrkLz1mzzE43BU45uTZAQhjkaarQD6UrteTt8bjP0W+oJArGC0J9/Cl7IxKprDC+inoCfX6LoLHAealYbykkR0wpdRJIWKaMqbEEhjUC5UiVT5Hau9OIzuJit3nsvLwTWJW2VoZ9OSGshIfhT2s=
Received: from AM0PR05MB5156.eurprd05.prod.outlook.com (20.178.20.19) by
 AM0PR05MB6499.eurprd05.prod.outlook.com (20.179.35.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.23; Mon, 27 Jan 2020 09:56:21 +0000
Received: from AM0PR05MB5156.eurprd05.prod.outlook.com
 ([fe80::28cb:442b:6907:83e7]) by AM0PR05MB5156.eurprd05.prod.outlook.com
 ([fe80::28cb:442b:6907:83e7%6]) with mapi id 15.20.2665.026; Mon, 27 Jan 2020
 09:56:21 +0000
Received: from SvensMacbookPro.hq.voleatech.com (37.24.174.42) by AM4PR05CA0028.eurprd05.prod.outlook.com (2603:10a6:205::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.22 via Frontend Transport; Mon, 27 Jan 2020 09:56:20 +0000
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "matteo.croce@redhat.com" <matteo.croce@redhat.com>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
Subject: Re: [PATCH] mvneta driver XDP fixes armhf
Thread-Topic: [PATCH] mvneta driver XDP fixes armhf
Thread-Index: AQHV0Qt0wGHHU1bPe06KgczxouriXaf3TJoAgAJ+uwCAAYPeAIAASCkAgAK5AAD///hEgIAABVUA
Date:   Mon, 27 Jan 2020 09:56:21 +0000
Message-ID: <20200127095620.yuhbf5m574igzi6d@SvensMacbookPro.hq.voleatech.com>
References: <C39F91BD-26BA-4373-A056-CE2E6B9D750E@voleatech.de>
 <20200122225740.GA3384@localhost.localdomain>
 <20200124120344.y3avbjdiu6gtmhbr@SvensMacbookPro.hq.voleatech.com>
 <20200125111158.nge3qahnocq2obot@SvensMacBookAir.sven.lan>
 <20200125163016.GA13217@localhost.localdomain>
 <20200127090454.dmstvqgqltgdyzog@SvensMacbookPro.hq.voleatech.com>
 <20200127093715.GA2543@localhost.localdomain>
In-Reply-To: <20200127093715.GA2543@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM4PR05CA0028.eurprd05.prod.outlook.com (2603:10a6:205::41)
 To AM0PR05MB5156.eurprd05.prod.outlook.com (2603:10a6:208:f7::19)
x-originating-ip: [37.24.174.42]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sven.auhagen@voleatech.de; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5b36cb5a-db81-4cfc-4f73-08d7a30f297b
x-ms-traffictypediagnostic: AM0PR05MB6499:
x-microsoft-antispam-prvs: <AM0PR05MB649997ACFCC7EC3BA0B51E88EF0B0@AM0PR05MB6499.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:773;
x-forefront-prvs: 02951C14DC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(376002)(396003)(136003)(39830400003)(346002)(199004)(189003)(64756008)(66446008)(66556008)(66946007)(66476007)(5660300002)(71200400001)(1076003)(6916009)(9686003)(55016002)(66574012)(4326008)(8676002)(81166006)(15974865002)(81156014)(7416002)(54906003)(316002)(52116002)(7696005)(86362001)(966005)(6506007)(45080400002)(508600001)(2906002)(956004)(16526019)(186003)(44832011)(26005)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM0PR05MB6499;H:AM0PR05MB5156.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:de;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: voleatech.de does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5UU9BCG3yrcX+BgwdNlDVfz+rd9kfJsAXVMtmsD71Q2XZplw31qmmTKLFGt+E6ZW0QDE4Cu1YaIEatVO0X88SsMWiGkhHR3VJDqyK6UJfgs40IzNZpDyx7F99jFyF0lURLFvowvUny9TX2P8V8l0fPFLyqSmhEssrGYg46B7G2X4GqNGIYf4kqilsk2g3FKPV4HmlNuTrFwsKW0pvUEe0dnXVaa45oMlkna59shu/HrF0m0DdnYVUG2hHuqVY3gEabG5KGu2ocilrhFG9+7df/fZMieiLwUSY7OaKOhNlaJTrQCJZXjepZVUS4js/YOSfCR7lSkPMS4+7AGrXTd0l1JDyu1+1qd76x26vmplx1yvgJWssMEDA0Bq+OjvCht0gabIr6B/JBEn149rYjL1n+wA5wFA3eeezoLoFmMtHmx7IddsBmPhSUdLuSsw5huWDuK9EnftlNG9kvEPdmVUv+HMYrDImhVkrjRr+xOo1vY=
x-ms-exchange-antispam-messagedata: z09x4nrLA3r6g5pdd87XvcNVOqGSqcBvfJJfrHmEh6vhmFCCW9jw/bnpH/zG2D4WGqJq3CZty4C3wwT5f7I/AGuj5ibq3vitffIUdMuGOIgafzDwC49itGk34fRa5LVkuA5qLd3+68X5q+jeOxJixA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <7C99F66FC06B5E47B5B3D4DC66ED4DBB@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b36cb5a-db81-4cfc-4f73-08d7a30f297b
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2020 09:56:21.3797
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ETrlcl6OrgihvSN8PoeakoBKTbVmoAcOe42c/ZcrrYNPHVF7RbyND0dDHGlN6rMwVdKrLFU1TQaRSoHa8fQlBLpMopa36aKPFjF3qYj29zY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6499
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 27, 2020 at 10:37:15AM +0100, Lorenzo Bianconi wrote:
> > On Sat, Jan 25, 2020 at 05:30:16PM +0100, Lorenzo Bianconi wrote:
> > > > On Fri, Jan 24, 2020 at 12:03:46PM +0000, Sven Auhagen wrote:
> > > > > On Wed, Jan 22, 2020 at 11:57:40PM +0100, lorenzo.bianconi@redhat=
.com wrote:
> > > > > > Hi Sven,
> > > > > >
> > >=20
> > > [...]
> > >=20
> > > >=20
>=20
> [...]
>=20
> > >=20
> > > Hi Sven,
> > >=20
> > > IIUC how the hw works, I guess we can reduce MVNETA_SKB_HEADROOM and =
let the hw put the MH
> > > header to align the IP header. Could you please try the following pat=
ch?
> > >=20
> > > Regards,
> > > Lorenzo
> > >=20
> > > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethe=
rnet/marvell/mvneta.c
> > > index 67ad8b8b127d..c032cffa6ae8 100644
> > > --- a/drivers/net/ethernet/marvell/mvneta.c
> > > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > > @@ -324,8 +324,7 @@
> > >  	      ETH_HLEN + ETH_FCS_LEN,			     \
> > >  	      cache_line_size())
> > > =20
> > > -#define MVNETA_SKB_HEADROOM	(max(XDP_PACKET_HEADROOM, NET_SKB_PAD) +=
 \
> > > -				 NET_IP_ALIGN)
> > > +#define MVNETA_SKB_HEADROOM	max(XDP_PACKET_HEADROOM, NET_SKB_PAD)
> > >  #define MVNETA_SKB_PAD	(SKB_DATA_ALIGN(sizeof(struct skb_shared_info=
) + \
> > >  			 MVNETA_SKB_HEADROOM))
> > >  #define MVNETA_SKB_SIZE(len)	(SKB_DATA_ALIGN(len) + MVNETA_SKB_PAD)
> > > @@ -1167,6 +1166,7 @@ static void mvneta_bm_update_mtu(struct mvneta_=
port *pp, int mtu)
> > >  	mvneta_bm_pool_destroy(pp->bm_priv, pp->pool_short, 1 << pp->id);
> > > =20
> > >  	pp->bm_priv =3D NULL;
> > > +	pp->rx_offset_correction =3D MVNETA_SKB_HEADROOM;
> > >  	mvreg_write(pp, MVNETA_ACC_MODE, MVNETA_ACC_MODE_EXT1);
> > >  	netdev_info(pp->dev, "fail to update MTU, fall back to software BM\=
n");
> > >  }
> > > @@ -4942,7 +4942,6 @@ static int mvneta_probe(struct platform_device =
*pdev)
> > >  	SET_NETDEV_DEV(dev, &pdev->dev);
> > > =20
> > >  	pp->id =3D global_port_id++;
> > > -	pp->rx_offset_correction =3D MVNETA_SKB_HEADROOM;
> > > =20
> > >  	/* Obtain access to BM resources if enabled and already initialized=
 */
> > >  	bm_node =3D of_parse_phandle(dn, "buffer-manager", 0);
> > > @@ -4967,6 +4966,10 @@ static int mvneta_probe(struct platform_device=
 *pdev)
> > >  	}
> > >  	of_node_put(bm_node);
> > > =20
> > > +	/* sw buffer management */
> > > +	if (!pp->bm_priv)
> > > +		pp->rx_offset_correction =3D MVNETA_SKB_HEADROOM;
> > > +
> > >  	err =3D mvneta_init(&pdev->dev, pp);
> > >  	if (err < 0)
> > >  		goto err_netdev;
> > > @@ -5124,6 +5127,7 @@ static int mvneta_resume(struct device *device)
> > >  		err =3D mvneta_bm_port_init(pdev, pp);
> > >  		if (err < 0) {
> > >  			dev_info(&pdev->dev, "use SW buffer management\n");
> > > +			pp->rx_offset_correction =3D MVNETA_SKB_HEADROOM;
> > >  			pp->bm_priv =3D NULL;
> > >  		}
> > >  	}
> >=20
> > This patch works on my armada 388 board, thanks.
>=20
> cool, thx for testing it. Is XDP support working on your board
> following back in sw bm?

Yes, XDP redirect also works on sw bm on my board.
The performance is not really faster than non XDP forwarding though.

Best
Sven

>=20
> > Are you going to send in the patch?
>=20
> I will test it on my espressobin and then I will post it.
> @Andrew: applying this patch, is WRT1900ac working in your configuration?
>=20
> Regards,
> Lorenzo
>=20
> >=20
> > Best
> > Sven
> >=20
> > >=20
> > > >=20
> > > > Best
> > > > Sven
> > > >=20
> > > > >
> > > > > >
> > > > > > >
> > > > > > > Attached is a patch that fixes the problem on my armhf platfo=
rm, as said I am not sure if this is a universal fix or armhf only.
> > > > > > >
> > > > > > > Any feedback is appreciated.
> > > > > > >
> > > > > > > Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
> > > > > > >
> > > > > > > --- a/drivers/net/ethernet/marvell/mvneta.c2020-01-22 08:44:0=
5.611395960 +0000
> > > > > > > +++ b/drivers/net/ethernet/marvell/mvneta.c2020-01-22 08:59:2=
7.053739433 +0000
> > > > > > > @@ -2158,7 +2158,7 @@ mvneta_swbm_rx_frame(struct mvneta_port
> > > > > > >  prefetch(data);
> > > > > > >
> > > > > > >  xdp->data_hard_start =3D data;
> > > > > > > -xdp->data =3D data + pp->rx_offset_correction + MVNETA_MH_SI=
ZE;
> > > > > > > +xdp->data =3D data + pp->rx_offset_correction;
> > > > > >
> > > > > > This will break XDP support for 'real' sw buffer devices like E=
spressobin.
> > > > >
> > > > > The current code seems to break real hw buffer devices using sw b=
uffer on armhf though.
> > > > >
> > > > > Best
> > > > > Sven
> > > > >
> > > > > >
> > > > > > Regards,
> > > > > > Lorenzo
> > > > > >
> > > > > > >  xdp->data_end =3D xdp->data + data_len;
> > > > > > >  xdp_set_data_meta_invalid(xdp);
> > > > > > >
> > > > > > > @@ -4960,7 +4960,8 @@ static int mvneta_probe(struct platform=
_
> > > > > > >   * NET_SKB_PAD, exceeds 64B. It should be 64B for 64-bit
> > > > > > >   * platforms and 0B for 32-bit ones.
> > > > > > >   */
> > > > > > > -pp->rx_offset_correction =3D max(0,
> > > > > > > +if (pp->bm_priv)
> > > > > > > +pp->rx_offset_correction =3D max(0,
> > > > > > >         NET_SKB_PAD -
> > > > > > >         MVNETA_RX_PKT_OFFSET_CORRECTION);
> > > > > > >  }
> > > > > > >
> > > > > > >
> > > > > > >
> > > > > > >
> > > > > > > +++ Voleatech auf der E-World, 11. bis 13. Februar 2020, Hall=
e 5, Stand 521 +++
> > > > > > >
> > > > > > > Beste Gr=FC=DFe/Best regards
> > > > > > >
> > > > > > > Sven Auhagen
> > > > > > > Dipl. Math. oec., M.Sc.
> > > > > > > Voleatech GmbH
> > > > > > > HRB: B 754643
> > > > > > > USTID: DE303643180
> > > > > > > Grathwohlstr. 5
> > > > > > > 72762 Reutlingen
> > > > > > > Tel: +49 7121539550
> > > > > > > Fax: +49 7121539551
> > > > > > > E-Mail: sven.auhagen@voleatech.de
> > > > > > > https://eur03.safelinks.protection.outlook.com/?url=3Dwww.vol=
eatech.de&amp;data=3D02%7C01%7Csven.auhagen%40voleatech.de%7C16ecc6de767047=
3d7de108d7a0c5cf85%7Cb82a99f679814a7295344d35298f847b%7C0%7C0%7C63715464375=
5759442&amp;sdata=3DPlhiaiQCqIc9Pmkux%2B8xLf%2FiwP3Nn3UsMRozhbX%2FR%2B0%3D&=
amp;reserved=3D0<https://eur03.safelinks.protection.outlook.com/?url=3Dhttp=
s%3A%2F%2Fwww.voleatech.de&amp;data=3D02%7C01%7Csven.auhagen%40voleatech.de=
%7C16ecc6de7670473d7de108d7a0c5cf85%7Cb82a99f679814a7295344d35298f847b%7C0%=
7C0%7C637154643755759442&amp;sdata=3DsSpe8NSqXN8dJOp%2Fb%2FaaHcEPTdtT4jE59e=
k97VvTtlY%3D&amp;reserved=3D0>
> > > > > > > Diese Information ist ausschlie=DFlich f=FCr den Adressaten b=
estimmt und kann vertraulich oder gesetzlich gesch=FCtzte Informationen ent=
halten. Wenn Sie nicht der bestimmungsgem=E4=DFe Adressat sind, unterrichte=
n Sie bitte den Absender und vernichten Sie diese Mail. Anderen als dem bes=
timmungsgem=E4=DFen Adressaten ist es untersagt, diese E-Mail zu lesen, zu =
speichern, weiterzuleiten oder ihren Inhalt auf welche Weise auch immer zu =
verwenden. F=FCr den Adressaten sind die Informationen in dieser Mail nur z=
um pers=F6nlichen Gebrauch. Eine Weiterleitung darf nur nach R=FCcksprache =
mit dem Absender erfolgen. Wir verwenden aktuelle Virenschutzprogramme. F=
=FCr Sch=E4den, die dem Empf=E4nger gleichwohl durch von uns zugesandte mit=
 Viren befallene E-Mails entstehen, schlie=DFen wir jede Haftung aus.
> > > > >
> > > > >
> > > > >
> > > >=20
> > > > +++ Voleatech auf der E-World, 11. bis 13. Februar 2020, Halle 5, S=
tand 521 +++
> > > >=20
> > > > Beste Gr=FC=DFe/Best regards
> > > >=20
> > > > Sven Auhagen
> > > > Dipl. Math. oec., M.Sc.
> > > > Voleatech GmbH
> > > > HRB: B 754643
> > > > USTID: DE303643180
> > > > Grathwohlstr. 5
> > > > 72762 Reutlingen
> > > > Tel: +49 7121539550
> > > > Fax: +49 7121539551
> > > > E-Mail: sven.auhagen@voleatech.de
> > > > www.voleatech.de<https://www.voleatech.de>
> > > > Diese Information ist ausschlie=DFlich f=FCr den Adressaten bestimm=
t und kann vertraulich oder gesetzlich gesch=FCtzte Informationen enthalten=
. Wenn Sie nicht der bestimmungsgem=E4=DFe Adressat sind, unterrichten Sie =
bitte den Absender und vernichten Sie diese Mail. Anderen als dem bestimmun=
gsgem=E4=DFen Adressaten ist es untersagt, diese E-Mail zu lesen, zu speich=
ern, weiterzuleiten oder ihren Inhalt auf welche Weise auch immer zu verwen=
den. F=FCr den Adressaten sind die Informationen in dieser Mail nur zum per=
s=F6nlichen Gebrauch. Eine Weiterleitung darf nur nach R=FCcksprache mit de=
m Absender erfolgen. Wir verwenden aktuelle Virenschutzprogramme. F=FCr Sch=
=E4den, die dem Empf=E4nger gleichwohl durch von uns zugesandte mit Viren b=
efallene E-Mails entstehen, schlie=DFen wir jede Haftung aus.
> > > >=20
> >=20
> >=20


