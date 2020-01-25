Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B25731494F7
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 11:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgAYKsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 05:48:47 -0500
Received: from mail-eopbgr10124.outbound.protection.outlook.com ([40.107.1.124]:18430
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725710AbgAYKsq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jan 2020 05:48:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bm6EmvEaH2Ucr9fLGD5OzbfNhU0murYznSMXcMb8/v517IIhbfPY6E2K8tnzBnZ79wyHXWCO510ZWWX8EElf2e3zCDiUnkmBzE4SdX1d2pOlAWGbJVLbodP48dB5ZzdFl2fcf1lxPXgBhZZ1oDhmEr0ChYvHleoXKagEXmOEoeoV8WTXJLZedvYpnE+UBmh7UoMWE51TcMMBIXHugzsyOAyUbhYW1DBoNQp1c7Tnea6mOcUP/zqW9QJlzJK8sfIMfleITmDyMARGT8GJVE8irohEPfwpcWo0+SPu8n3E4ni1sAX3brxGLMg/3N9RsZlmVE4UhsAwK7zzD5NtVJgb7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pyupf76kG1FRvQkUMv3/mCjsAzSVF/2pFlZlJ9tdHvY=;
 b=TQp7qhI20WMrSLDqz2uBQhSU2Hu/ReqDINTnkDDPtWb1risISlEy42vn6ftmxYYhQt3PRoc41hBhoVOen7pZU/J82wFg/W/htTzZc5qe5gZTqUPXH0D/kVfZpG6V5C1yFGUdchCYOUsR+5ydHgKV0VYMKlS+RcEmQuBFkZRd9EgE7PcC7K1j9JfBnsggmUpma0p0p7NTC8L7mxsX/SnE+go3T+JqIP/3Q18hyy/3Bf9WIINv+0uRHBmAXMm1eafgMaNHoHK6mhtHPk1Mh75Q/lRoYxqGoa2apHJj88h/bm86jxyL+pQAQo0ryDPLeKoTmR78XrZvZK2FMoSgoqJM+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pyupf76kG1FRvQkUMv3/mCjsAzSVF/2pFlZlJ9tdHvY=;
 b=D5LgM54uvZwRrteUxUrQp4beesrf2rgf/MMfx5rz+7h9SQDGUz7cXld+Wpi7h97RWezml6cQOfB/qcuPbv3QK1PliiPby1lVus7N2XlTR34/5rt3xlN8hPw4cBFyhJl+hsxV2GD2WAoDiGdkxDSmx2YpHGo2W14DrtUfmMRbe+Y=
Received: from AM0PR05MB5156.eurprd05.prod.outlook.com (20.178.20.19) by
 AM0PR05MB4578.eurprd05.prod.outlook.com (52.133.54.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.24; Sat, 25 Jan 2020 10:48:40 +0000
Received: from AM0PR05MB5156.eurprd05.prod.outlook.com
 ([fe80::28cb:442b:6907:83e7]) by AM0PR05MB5156.eurprd05.prod.outlook.com
 ([fe80::28cb:442b:6907:83e7%6]) with mapi id 15.20.2665.017; Sat, 25 Jan 2020
 10:48:40 +0000
Received: from SvensMacBookAir.sven.lan (78.43.2.70) by ZR0P278CA0020.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.22 via Frontend Transport; Sat, 25 Jan 2020 10:48:39 +0000
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     "lorenzo.bianconi@redhat.com" <lorenzo.bianconi@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "matteo.croce@redhat.com" <matteo.croce@redhat.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
Subject: Re: [PATCH v5] mvneta driver disallow XDP program on hardware buffer
 management
Thread-Topic: [PATCH v5] mvneta driver disallow XDP program on hardware buffer
 management
Thread-Index: AQHV01Zt85Jc6nz440+eUwbZXq2o9Kf7EawAgAAhpgA=
Date:   Sat, 25 Jan 2020 10:48:39 +0000
Message-ID: <20200125104838.s6ata3hot4kwr7lq@SvensMacBookAir.sven.lan>
References: <20200125080702.81712-1-sven.auhagen@voleatech.de>
 <20200125084812.GA3398@p977.fit.wifi.vutbr.cz>
In-Reply-To: <20200125084812.GA3398@p977.fit.wifi.vutbr.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: ZR0P278CA0020.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::7) To AM0PR05MB5156.eurprd05.prod.outlook.com
 (2603:10a6:208:f7::19)
x-originating-ip: [78.43.2.70]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sven.auhagen@voleatech.de; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c4c8abeb-b63f-43c2-3dca-08d7a184236e
x-ms-traffictypediagnostic: AM0PR05MB4578:|AM0PR05MB4578:
x-microsoft-antispam-prvs: <AM0PR05MB4578C477E9BDF0D9F7025FFAEF090@AM0PR05MB4578.eurprd05.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:211;
x-forefront-prvs: 0293D40691
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39830400003)(136003)(366004)(376002)(346002)(396003)(189003)(199004)(4326008)(66946007)(66476007)(66446008)(107886003)(66556008)(316002)(64756008)(2906002)(5660300002)(8676002)(55016002)(81156014)(9686003)(8936002)(6862004)(54906003)(508600001)(81166006)(186003)(7696005)(52116002)(6506007)(1076003)(26005)(66574012)(71200400001)(16526019)(956004)(86362001)(44832011)(15974865002)(309714004);DIR:OUT;SFP:1102;SCL:1;SRVR:AM0PR05MB4578;H:AM0PR05MB5156.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:de;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: voleatech.de does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fmIg47eHDbgJz+g6lq71RVBQ+vG+HePTFDpNMnuh6weuQ3rePBnOWapoatoSpKcMmZcYoyrnMgbQ5QKhYXdaHFwsdL1sSZxH+vas1BR2NrqjCqOzxQKHF6YG71D+iiBk9o/wscJj3wPHAgxF1zXVXOggYahy5dnWyjZOE576cPBxdI+zHHcFYFh+OmrTRld3rSLZsHYMzVcxCbkgP0u8qnZWID0/V1nKHZNAAMlUT6S7ICmMlg+WYyQZBgIlfIhjyx456fQ/4B7RB2o84bQGN5rgBZu8Vhr3gTmApkzI3ql80GCd5R/ofFCZsZ4jXdxl1MiDnxlexdmbfuEZIoxtXIra+sPDMazhM004gvN9/rrv4f0oU/Zvb7sfer3UkBmBRCqLVVfF23YD/Ij9zOp2qP0cNIGtlMNzoh088ljFxEiKEgg913cu1Bi21daHvTkXLbNu+EUNKu5JmFk1tt/F3CMHv5IkxjUUmq+yi0vR5CQVBUIE2GdB74QVoU6qJVew+7U8THQ33TBQXBLKsIBQjQ==
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <7A28A22D6415874F8FC8B3F20D6E3CFB@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: c4c8abeb-b63f-43c2-3dca-08d7a184236e
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2020 10:48:39.9926
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Vi0qj31GrOYu4sBhTK6Ji+uGOrgDUfghXFVI/iQ1tstgdJ2HJkOKTqVCYtAGydgnRcc/E5iqk82sWgjO7JsoJplWzAP0lsAHQ9Dy7O++Ao4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4578
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 25, 2020 at 09:48:12AM +0100, lorenzo.bianconi@redhat.com wrote=
:
> > Recently XDP Support was added to the mvneta driver
> > for software buffer management only.
> > It is still possible to attach an XDP program if
> > hardware buffer management is used.
> > It is not doing anything at that point.
> >=20
>=20
> [...]
>=20
> > --- a/drivers/net/ethernet/marvell/mvneta.c
> > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > @@ -4225,6 +4225,12 @@ static int mvneta_xdp_setup(struct net_device *d=
ev, struct bpf_prog *prog,
> >  return -EOPNOTSUPP;
> >  }
> >=20
> > +if (pp->bm_priv) {
> > +NL_SET_ERR_MSG_MOD(extack,
> > +   "Hardware Buffer Management not supported on XDP");
> > +return -EOPNOTSUPP;
> > +}
>=20
> Could you please fix the following checkpatch warnings?
>=20
> $ <kernel_dir>/scripts/checkpatch.pl --strict file.patch
>=20
> WARNING: suspect code indent for conditional statements (0, 0)
> #53: FILE: drivers/net/ethernet/marvell/mvneta.c:4228:
> +if (pp->bm_priv) {
> +NL_SET_ERR_MSG_MOD(extack,
>=20
> CHECK: Alignment should match open parenthesis
> #55: FILE: drivers/net/ethernet/marvell/mvneta.c:4230:
> +NL_SET_ERR_MSG_MOD(extack,
> +   "Hardware Buffer Management not supported on XDP");
>=20
> WARNING: please, no spaces at the start of a line
> #55: FILE: drivers/net/ethernet/marvell/mvneta.c:4230:
> +   "Hardware Buffer Management not supported on XDP");$
>=20
> total: 0 errors, 2 warnings, 12 lines checked
>=20
> Regards,
> Lorenzo

I double checked and I do not have those warning on my end with v5.
I also redownloaded the patch from my submission on patchwork.
What am I missing?

Best
Sven

>=20
> > +
> >  need_update =3D !!pp->xdp_prog !=3D !!prog;
> >  if (running && need_update)
> >  mvneta_stop(dev);
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


