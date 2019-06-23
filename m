Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F059C4FC8A
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 18:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbfFWQAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 12:00:43 -0400
Received: from mail-eopbgr60084.outbound.protection.outlook.com ([40.107.6.84]:9742
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726747AbfFWQAn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Jun 2019 12:00:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9RJntJEeZVLfrdFcL8zinagWVC8OtQfoVd2nvt4MF4o=;
 b=YUfguqhCX/6zKj3vzUtF5IhEP9DWDX+QaPdoaEr+755qjfqnNIK5debZC1wdMAGqu/SruG+WyiEOtYNd7bj76wwhyKYQ4mDOMGlqjLlX8TDL/2pcT3OT92Lo1SDCEJ0MwYH9Vj4SnJT+R2v1MDtrKzPPudvGNBEoiP1o54Tv8Fk=
Received: from AM6PR05MB5224.eurprd05.prod.outlook.com (20.177.196.210) by
 AM6PR05MB6247.eurprd05.prod.outlook.com (20.179.3.208) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Sun, 23 Jun 2019 16:00:39 +0000
Received: from AM6PR05MB5224.eurprd05.prod.outlook.com
 ([fe80::9c01:fb00:b03c:e594]) by AM6PR05MB5224.eurprd05.prod.outlook.com
 ([fe80::9c01:fb00:b03c:e594%4]) with mapi id 15.20.2008.007; Sun, 23 Jun 2019
 16:00:39 +0000
From:   Vadim Pasternak <vadimp@mellanox.com>
To:     Andrew Lunn <andrew@lunn.ch>, Ido Schimmel <idosch@idosch.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, mlxsw <mlxsw@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: RE: [PATCH net-next 3/3] mlxsw: core: Add support for negative
 temperature readout
Thread-Topic: [PATCH net-next 3/3] mlxsw: core: Add support for negative
 temperature readout
Thread-Index: AQHVKcM2m6uv7yWu1EeOXJKYv1f1W6apYXWAgAABsPA=
Date:   Sun, 23 Jun 2019 16:00:38 +0000
Message-ID: <AM6PR05MB5224C6BC97D0F90391DA9B0FA2E10@AM6PR05MB5224.eurprd05.prod.outlook.com>
References: <20190623125645.2663-1-idosch@idosch.org>
 <20190623125645.2663-4-idosch@idosch.org> <20190623154407.GE28942@lunn.ch>
In-Reply-To: <20190623154407.GE28942@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vadimp@mellanox.com; 
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b2d9b3aa-24a0-46ca-b14f-08d6f7f3efb8
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB6247;
x-ms-traffictypediagnostic: AM6PR05MB6247:
x-microsoft-antispam-prvs: <AM6PR05MB6247DADCB03D8C28C93A9CCDA2E10@AM6PR05MB6247.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 00770C4423
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(39860400002)(136003)(346002)(396003)(376002)(13464003)(189003)(199004)(4326008)(8676002)(53546011)(73956011)(54906003)(110136005)(66066001)(81166006)(7696005)(102836004)(8936002)(7736002)(446003)(107886003)(6116002)(74316002)(66946007)(6506007)(478600001)(3846002)(55016002)(305945005)(53936002)(11346002)(14444005)(26005)(486006)(99286004)(186003)(14454004)(33656002)(6246003)(256004)(76176011)(476003)(2906002)(86362001)(76116006)(81156014)(25786009)(64756008)(316002)(68736007)(229853002)(66476007)(5660300002)(71190400001)(71200400001)(6436002)(9686003)(52536014)(66446008)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6247;H:AM6PR05MB5224.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: uyjUCCteenNq7w1hmgQ3/6JBABXsRamPagNmuc94ETU24HCnHuNkTnPoKRoIKBDvZ+fjIwMMrYHlmud0TzLR78DFCX7R7bEwCYSrptY4zi8328Em2zzrF5HBRD9HfiK+q8MA7QNyK+4AugZ8tDybn5wlfzZdb0PSKm8c5k8yuwmrGJhPxgBEXkSlI1cwbsuF7fyJIIp3E2WbYbm8rdmlqEGcmFvFTx2HuxmF9bMxmTRRLURi9ZyAe+0iktM+AJpRuLVy88A7OGPy3IH79oSsZp66XO2Umkpw2ms+JxmPUSUKED152gT7UooUWM61DpBBCSPJhpeoaMIsgdqKWybxomIPVTgVA+isb1hVP6nSVEKWytPr+b9aV6BQzzzfyJgluWuCv6MtjGyf5XIAnnzteN858CFgz6++WcUx2bO9nAg=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2d9b3aa-24a0-46ca-b14f-08d6f7f3efb8
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2019 16:00:38.9996
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vadimp@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6247
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Sunday, June 23, 2019 6:44 PM
> To: Ido Schimmel <idosch@idosch.org>
> Cc: netdev@vger.kernel.org; davem@davemloft.net; Jiri Pirko
> <jiri@mellanox.com>; mlxsw <mlxsw@mellanox.com>; Vadim Pasternak
> <vadimp@mellanox.com>; Ido Schimmel <idosch@mellanox.com>
> Subject: Re: [PATCH net-next 3/3] mlxsw: core: Add support for negative
> temperature readout
>=20
> > --- a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
> > +++ b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
> > @@ -52,8 +52,7 @@ static ssize_t mlxsw_hwmon_temp_show(struct device
> *dev,
> >  			container_of(attr, struct mlxsw_hwmon_attr,
> dev_attr);
> >  	struct mlxsw_hwmon *mlxsw_hwmon =3D mlwsw_hwmon_attr->hwmon;
> >  	char mtmp_pl[MLXSW_REG_MTMP_LEN];
> > -	unsigned int temp;
> > -	int index;
> > +	int temp, index;
> >  	int err;
> >
> >  	index =3D mlxsw_hwmon_get_attr_index(mlwsw_hwmon_attr-
> >type_index,
> > @@ -65,7 +64,7 @@ static ssize_t mlxsw_hwmon_temp_show(struct device
> *dev,
> >  		return err;
> >  	}
> >  	mlxsw_reg_mtmp_unpack(mtmp_pl, &temp, NULL, NULL);
> > -	return sprintf(buf, "%u\n", temp);
> > +	return sprintf(buf, "%d\n", temp);
> >  }
>=20
> If you had used the hwmon core, rather than implementing it yourself, you=
 could
> of avoided this part of the bug.
>=20

Hi Andrew.

Yes.
But before we handle only positive temperature.
And currently support for the negative readouts has been added.

> >  static ssize_t mlxsw_hwmon_temp_rst_store(struct device *dev, @@
> > -215,8 +213,8 @@ static ssize_t mlxsw_hwmon_module_temp_show(struct
> device *dev,
> >  			container_of(attr, struct mlxsw_hwmon_attr,
> dev_attr);
> >  	struct mlxsw_hwmon *mlxsw_hwmon =3D mlwsw_hwmon_attr->hwmon;
> >  	char mtmp_pl[MLXSW_REG_MTMP_LEN];
> > -	unsigned int temp;
> >  	u8 module;
> > +	int temp;
> >  	int err;
> >
> >  	module =3D mlwsw_hwmon_attr->type_index - mlxsw_hwmon-
> >sensor_count;
>=20
> I think you missed changing the %u to %d in this function.

If I am not wrong, I think you refer to mlxsw_hwmon_fan_rpm_show(),
where it should be %u.

>=20
> > @@ -519,14 +519,14 @@ static int mlxsw_thermal_module_temp_get(struct
> thermal_zone_device *tzdev,
> >  		return 0;
> >  	}
> >  	mlxsw_reg_mtmp_unpack(mtmp_pl, &temp, NULL, NULL);
> > -	*p_temp =3D (int) temp;
> > +	*p_temp =3D temp;
> >
> >  	if (!temp)
> >  		return 0;
> >
> >  	/* Update trip points. */
> >  	err =3D mlxsw_thermal_module_trips_update(dev, thermal->core, tz);
> > -	if (!err)
> > +	if (!err && temp > 0)
> >  		mlxsw_thermal_tz_score_update(thermal, tzdev, tz->trips,
> temp);
>=20
> Why the > 0?

We don't consider negative temperature for thermal control.

>=20
>     Andrew
