Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3563A14A069
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 10:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727493AbgA0JFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 04:05:04 -0500
Received: from mail-eopbgr70092.outbound.protection.outlook.com ([40.107.7.92]:35140
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726569AbgA0JFE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 04:05:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Raid3Mwcnw85/KCDIXiqvK0HzwlRkGsJ5xVqLPj1t8tWI+LCG07mHi4azQNvjq0c77ytneB142GBUboQhKbWuvvqw1zkiLW0ivd0HCEd0Xn3avz92wgNt91XZjIFYn3h4q4/ihzzyf9Ml++U2JrkHjHOj1oHS0t0huZoYl9Q8gnRSUQqPLGnhOsoK+gclJf2tdOJT1HrAc0AUtuhO5LDPblcojxSrPLMlesuSI9Bd6l+RiXF55c5WYAa8HdWPFWFIjOUNd5lPw/B5ZbUxxMPEwj6iMqGn97FU4zlkUEktM2G4KWkZgGyWF4bDNZFGarTpFXLpkLgYibXg8MIAdXDPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lksxqAkG6QjRx8hT/PyuNI2P5+YoTlB8CNGCt0oM7aw=;
 b=NlQpaK8bMYOxRinz8fOPhV1jcoQgwC7rDBUAy80j8g0eNJmWL+bTbZOxTNJXqqOl7BFqaXMqm2u8g2Hj52IxpeQSjS5p3G9/srIQ5wIFYAICv472I7/L7Keno4MRqXPlWdfvU0sts3AqwVh2Jtn27CuoTXt5ysPqeEokTZBuMLkVa2RDgG5PNje0VbSaMBjRFy5rpNalL688gDSG2kQb8dmPDHa97QBKjS2bb66OeafB+AZ+gazgzJyUILc53sajlGVXjBlk7vB8zq71WKw4FsAOwZRxDMalKG6j3i+0l6+NXjkYlcpyz8k9Dkh5N8tyrmQSwEkKQHVWZ6wqE7OFMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lksxqAkG6QjRx8hT/PyuNI2P5+YoTlB8CNGCt0oM7aw=;
 b=T3rZpj7uHML1APxahIk3uDCHoRFnbAQgRK0CWK0S5cK7uvr+d4L48qeB60QFNZjRpFaCvwtJz7jiD8T9j0HOYmpDkzRsmarLIiVfWdq3aTnyA6zRaCH1jgfKMmxx4uZfxX6HUdhsx5cXWk/En4uZibbf2y53pNaC7Vpi6NbmOh8=
Received: from AM0PR05MB5156.eurprd05.prod.outlook.com (20.178.20.19) by
 AM0PR05MB6468.eurprd05.prod.outlook.com (20.179.32.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.23; Mon, 27 Jan 2020 09:04:55 +0000
Received: from AM0PR05MB5156.eurprd05.prod.outlook.com
 ([fe80::28cb:442b:6907:83e7]) by AM0PR05MB5156.eurprd05.prod.outlook.com
 ([fe80::28cb:442b:6907:83e7%6]) with mapi id 15.20.2665.026; Mon, 27 Jan 2020
 09:04:55 +0000
Received: from SvensMacbookPro.hq.voleatech.com (37.24.174.42) by AM0PR06CA0081.eurprd06.prod.outlook.com (2603:10a6:208:fa::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.20 via Frontend Transport; Mon, 27 Jan 2020 09:04:54 +0000
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
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
Thread-Index: AQHV0Qt0wGHHU1bPe06KgczxouriXaf3TJoAgAJ+uwCAAYPeAIAASCkAgAKoOgA=
Date:   Mon, 27 Jan 2020 09:04:55 +0000
Message-ID: <20200127090454.dmstvqgqltgdyzog@SvensMacbookPro.hq.voleatech.com>
References: <C39F91BD-26BA-4373-A056-CE2E6B9D750E@voleatech.de>
 <20200122225740.GA3384@localhost.localdomain>
 <20200124120344.y3avbjdiu6gtmhbr@SvensMacbookPro.hq.voleatech.com>
 <20200125111158.nge3qahnocq2obot@SvensMacBookAir.sven.lan>
 <20200125163016.GA13217@localhost.localdomain>
In-Reply-To: <20200125163016.GA13217@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR06CA0081.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::22) To AM0PR05MB5156.eurprd05.prod.outlook.com
 (2603:10a6:208:f7::19)
x-originating-ip: [37.24.174.42]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sven.auhagen@voleatech.de; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 24824e14-c2f3-4204-b64e-08d7a307fa09
x-ms-traffictypediagnostic: AM0PR05MB6468:
x-microsoft-antispam-prvs: <AM0PR05MB6468CD127A82EC929FFA00B1EF0B0@AM0PR05MB6468.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:843;
x-forefront-prvs: 02951C14DC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(136003)(39830400003)(376002)(366004)(346002)(189003)(199004)(1076003)(4326008)(44832011)(2906002)(16526019)(7696005)(9686003)(66574012)(52116002)(55016002)(71200400001)(956004)(86362001)(6506007)(186003)(5660300002)(3716004)(8936002)(66446008)(26005)(66476007)(966005)(66946007)(64756008)(66556008)(81166006)(54906003)(6916009)(81156014)(15974865002)(316002)(508600001)(45080400002)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM0PR05MB6468;H:AM0PR05MB5156.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: voleatech.de does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KkZWy0RD00HAGBOrOxpd5CoTTMqMv0Wr/iOEAEYidY3AhKtqU09ZMM/WcD40Pex1Yo2EfqaJTdY0kiV5dzETduRsEZvqf5bjL1mx42YEJG9PQVACfs95qAvba8i/p+ce5K2SZKyaBoSfTYaO1dbI1gg2SDoXRHWVBve8s5Vd7RzOXySEaUlrnj+muCgEn8gnU8Ha4mnLOqyOyNfr5bYqLQPOdnLofCzMtOQ5T0n506t8gKxX7RkRLjzGKK9ebQ4o9okA3DEQC5aAkgTU1m9cZT4GkZJ2ut8CCCl5KsHQ9+bXIkkw9Vqau1zHqTLx40x2HPW9EDFlNIALLFf5x88reHIeQ8o54fXQlZZPp+6FYw33O82lK5GfXwwQZG7php5ubu5TWUJqeWMPhbnn/dj+7dHkfPoa5VDNIP1N03s1WxZ7P+N0oDMPltaMu765E0byjTyQCafc7BMms7j9ovjt1m0wUF2rl1UPSUJt3UC3gBw=
x-ms-exchange-antispam-messagedata: UcCZodSiyjAlMLcfQMsbVYHQnQHxiGTv/g/URn3T6+IczOZ6C0vdptgTWQNRhYGcpYJkt1SVJPUJxXxh6KivLggeGYv7dhUCFQyHJqwssfRuvXp8Vch3B7uctK/1qmc3/nyxKTCDNQHtnZypKA/HAA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <64635B765078214EBCF8BFFDA4EDBD79@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 24824e14-c2f3-4204-b64e-08d7a307fa09
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2020 09:04:55.3462
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JHLS0h3zCzAl72URnyB9NTV7yZX+IdailBKU9fsuj9lfUO6o/WyCvokFLxGhq6Ay8WjblfN4rq4ZMq+p/mxuic94NaAIZYYs6rkDs1jhpI4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6468
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 25, 2020 at 05:30:16PM +0100, Lorenzo Bianconi wrote:
> > On Fri, Jan 24, 2020 at 12:03:46PM +0000, Sven Auhagen wrote:
> > > On Wed, Jan 22, 2020 at 11:57:40PM +0100, lorenzo.bianconi@redhat.com=
 wrote:
> > > > Hi Sven,
> > > >
>=20
> [...]
>=20
> >=20
> > I think I found the problem. I found the documentation finally and it s=
tates:
> >=20
> > The physical buffer pointer must be 64-bit aligned; therefore, bits[2:0=
] of the pointers are considered as zeros.
> >=20
> > rx_offset is defined as MVNETA_SKB_HEADROOM which in turn is:
> >=20
> > #define MVNETA_SKB_HEADROOM(max(XDP_PACKET_HEADROOM, NET_SKB_PAD) + \
> >  NET_IP_ALIGN)
> >=20
> > this leads to an offset on armhf of 258 which is not 64 bit aligned and=
 therefore
> > shortened to 256 hence the MH header is actually at 256.
> >=20
> > This would explain my problem.
> >=20
> > Any thoughts?
>=20
> Hi Sven,
>=20
> IIUC how the hw works, I guess we can reduce MVNETA_SKB_HEADROOM and let =
the hw put the MH
> header to align the IP header. Could you please try the following patch?
>=20
> Regards,
> Lorenzo
>=20
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet=
/marvell/mvneta.c
> index 67ad8b8b127d..c032cffa6ae8 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -324,8 +324,7 @@
>  	      ETH_HLEN + ETH_FCS_LEN,			     \
>  	      cache_line_size())
> =20
> -#define MVNETA_SKB_HEADROOM	(max(XDP_PACKET_HEADROOM, NET_SKB_PAD) + \
> -				 NET_IP_ALIGN)
> +#define MVNETA_SKB_HEADROOM	max(XDP_PACKET_HEADROOM, NET_SKB_PAD)
>  #define MVNETA_SKB_PAD	(SKB_DATA_ALIGN(sizeof(struct skb_shared_info) + =
\
>  			 MVNETA_SKB_HEADROOM))
>  #define MVNETA_SKB_SIZE(len)	(SKB_DATA_ALIGN(len) + MVNETA_SKB_PAD)
> @@ -1167,6 +1166,7 @@ static void mvneta_bm_update_mtu(struct mvneta_port=
 *pp, int mtu)
>  	mvneta_bm_pool_destroy(pp->bm_priv, pp->pool_short, 1 << pp->id);
> =20
>  	pp->bm_priv =3D NULL;
> +	pp->rx_offset_correction =3D MVNETA_SKB_HEADROOM;
>  	mvreg_write(pp, MVNETA_ACC_MODE, MVNETA_ACC_MODE_EXT1);
>  	netdev_info(pp->dev, "fail to update MTU, fall back to software BM\n");
>  }
> @@ -4942,7 +4942,6 @@ static int mvneta_probe(struct platform_device *pde=
v)
>  	SET_NETDEV_DEV(dev, &pdev->dev);
> =20
>  	pp->id =3D global_port_id++;
> -	pp->rx_offset_correction =3D MVNETA_SKB_HEADROOM;
> =20
>  	/* Obtain access to BM resources if enabled and already initialized */
>  	bm_node =3D of_parse_phandle(dn, "buffer-manager", 0);
> @@ -4967,6 +4966,10 @@ static int mvneta_probe(struct platform_device *pd=
ev)
>  	}
>  	of_node_put(bm_node);
> =20
> +	/* sw buffer management */
> +	if (!pp->bm_priv)
> +		pp->rx_offset_correction =3D MVNETA_SKB_HEADROOM;
> +
>  	err =3D mvneta_init(&pdev->dev, pp);
>  	if (err < 0)
>  		goto err_netdev;
> @@ -5124,6 +5127,7 @@ static int mvneta_resume(struct device *device)
>  		err =3D mvneta_bm_port_init(pdev, pp);
>  		if (err < 0) {
>  			dev_info(&pdev->dev, "use SW buffer management\n");
> +			pp->rx_offset_correction =3D MVNETA_SKB_HEADROOM;
>  			pp->bm_priv =3D NULL;
>  		}
>  	}

This patch works on my armada 388 board, thanks.
Are you going to send in the patch?

Best
Sven

>=20
> >=20
> > Best
> > Sven
> >=20
> > >
> > > >
> > > > >
> > > > > Attached is a patch that fixes the problem on my armhf platform, =
as said I am not sure if this is a universal fix or armhf only.
> > > > >
> > > > > Any feedback is appreciated.
> > > > >
> > > > > Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
> > > > >
> > > > > --- a/drivers/net/ethernet/marvell/mvneta.c2020-01-22 08:44:05.61=
1395960 +0000
> > > > > +++ b/drivers/net/ethernet/marvell/mvneta.c2020-01-22 08:59:27.05=
3739433 +0000
> > > > > @@ -2158,7 +2158,7 @@ mvneta_swbm_rx_frame(struct mvneta_port
> > > > >  prefetch(data);
> > > > >
> > > > >  xdp->data_hard_start =3D data;
> > > > > -xdp->data =3D data + pp->rx_offset_correction + MVNETA_MH_SIZE;
> > > > > +xdp->data =3D data + pp->rx_offset_correction;
> > > >
> > > > This will break XDP support for 'real' sw buffer devices like Espre=
ssobin.
> > >
> > > The current code seems to break real hw buffer devices using sw buffe=
r on armhf though.
> > >
> > > Best
> > > Sven
> > >
> > > >
> > > > Regards,
> > > > Lorenzo
> > > >
> > > > >  xdp->data_end =3D xdp->data + data_len;
> > > > >  xdp_set_data_meta_invalid(xdp);
> > > > >
> > > > > @@ -4960,7 +4960,8 @@ static int mvneta_probe(struct platform_
> > > > >   * NET_SKB_PAD, exceeds 64B. It should be 64B for 64-bit
> > > > >   * platforms and 0B for 32-bit ones.
> > > > >   */
> > > > > -pp->rx_offset_correction =3D max(0,
> > > > > +if (pp->bm_priv)
> > > > > +pp->rx_offset_correction =3D max(0,
> > > > >         NET_SKB_PAD -
> > > > >         MVNETA_RX_PKT_OFFSET_CORRECTION);
> > > > >  }
> > > > >
> > > > >
> > > > >
> > > > >
> > > > > +++ Voleatech auf der E-World, 11. bis 13. Februar 2020, Halle 5,=
 Stand 521 +++
> > > > >
> > > > > Beste Gr=FC=DFe/Best regards
> > > > >
> > > > > Sven Auhagen
> > > > > Dipl. Math. oec., M.Sc.
> > > > > Voleatech GmbH
> > > > > HRB: B 754643
> > > > > USTID: DE303643180
> > > > > Grathwohlstr. 5
> > > > > 72762 Reutlingen
> > > > > Tel: +49 7121539550
> > > > > Fax: +49 7121539551
> > > > > E-Mail: sven.auhagen@voleatech.de
> > > > > https://eur03.safelinks.protection.outlook.com/?url=3Dwww.voleate=
ch.de&amp;data=3D02%7C01%7Csven.auhagen%40voleatech.de%7C16ecc6de7670473d7d=
e108d7a0c5cf85%7Cb82a99f679814a7295344d35298f847b%7C0%7C0%7C637154643755759=
442&amp;sdata=3DPlhiaiQCqIc9Pmkux%2B8xLf%2FiwP3Nn3UsMRozhbX%2FR%2B0%3D&amp;=
reserved=3D0<https://eur03.safelinks.protection.outlook.com/?url=3Dhttps%3A=
%2F%2Fwww.voleatech.de&amp;data=3D02%7C01%7Csven.auhagen%40voleatech.de%7C1=
6ecc6de7670473d7de108d7a0c5cf85%7Cb82a99f679814a7295344d35298f847b%7C0%7C0%=
7C637154643755759442&amp;sdata=3DsSpe8NSqXN8dJOp%2Fb%2FaaHcEPTdtT4jE59ek97V=
vTtlY%3D&amp;reserved=3D0>
> > > > > Diese Information ist ausschlie=DFlich f=FCr den Adressaten besti=
mmt und kann vertraulich oder gesetzlich gesch=FCtzte Informationen enthalt=
en. Wenn Sie nicht der bestimmungsgem=E4=DFe Adressat sind, unterrichten Si=
e bitte den Absender und vernichten Sie diese Mail. Anderen als dem bestimm=
ungsgem=E4=DFen Adressaten ist es untersagt, diese E-Mail zu lesen, zu spei=
chern, weiterzuleiten oder ihren Inhalt auf welche Weise auch immer zu verw=
enden. F=FCr den Adressaten sind die Informationen in dieser Mail nur zum p=
ers=F6nlichen Gebrauch. Eine Weiterleitung darf nur nach R=FCcksprache mit =
dem Absender erfolgen. Wir verwenden aktuelle Virenschutzprogramme. F=FCr S=
ch=E4den, die dem Empf=E4nger gleichwohl durch von uns zugesandte mit Viren=
 befallene E-Mails entstehen, schlie=DFen wir jede Haftung aus.
> > >
> > >
> > >
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
> >=20


