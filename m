Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE8674FC9C
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 18:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbfFWQLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 12:11:45 -0400
Received: from mail-eopbgr20070.outbound.protection.outlook.com ([40.107.2.70]:5122
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726399AbfFWQLp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Jun 2019 12:11:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=apZUSLlPCjQRtjQzKtSnfJHUGwNjN6irw5Zz/on/FiE=;
 b=c5CQzJ0rZR/5hAm8aUPg0tXXxrsFhft1yuOlouCbB1EgTj27HFy4/Y/zKkZqAnWNjhxU0Y6Ckd+7HXSVQnCdTE3jxdUp2QOU+8K1keKo6RG2MPijro21SR9OH/egWALoMVlB1nolQEllJgb431qdDSvh0+oYa9vaW7jqMK1w7iI=
Received: from AM6PR05MB5224.eurprd05.prod.outlook.com (20.177.196.210) by
 AM6PR05MB4184.eurprd05.prod.outlook.com (52.135.161.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Sun, 23 Jun 2019 16:11:40 +0000
Received: from AM6PR05MB5224.eurprd05.prod.outlook.com
 ([fe80::9c01:fb00:b03c:e594]) by AM6PR05MB5224.eurprd05.prod.outlook.com
 ([fe80::9c01:fb00:b03c:e594%4]) with mapi id 15.20.2008.007; Sun, 23 Jun 2019
 16:11:40 +0000
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
Thread-Index: AQHVKcM2m6uv7yWu1EeOXJKYv1f1W6apYXWAgAABsPCAAAWeAA==
Date:   Sun, 23 Jun 2019 16:11:40 +0000
Message-ID: <AM6PR05MB5224331ECB7E643BA18C10BDA2E10@AM6PR05MB5224.eurprd05.prod.outlook.com>
References: <20190623125645.2663-1-idosch@idosch.org>
 <20190623125645.2663-4-idosch@idosch.org> <20190623154407.GE28942@lunn.ch>
 <AM6PR05MB5224C6BC97D0F90391DA9B0FA2E10@AM6PR05MB5224.eurprd05.prod.outlook.com>
In-Reply-To: <AM6PR05MB5224C6BC97D0F90391DA9B0FA2E10@AM6PR05MB5224.eurprd05.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vadimp@mellanox.com; 
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1bee5584-bae7-45ed-4230-08d6f7f57a30
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB4184;
x-ms-traffictypediagnostic: AM6PR05MB4184:
x-microsoft-antispam-prvs: <AM6PR05MB4184F63E9DFC3403A1DD6E5DA2E10@AM6PR05MB4184.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 00770C4423
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(396003)(39860400002)(346002)(376002)(13464003)(199004)(189003)(66446008)(66946007)(33656002)(53546011)(305945005)(4326008)(229853002)(9686003)(486006)(55016002)(110136005)(107886003)(102836004)(2906002)(476003)(186003)(11346002)(316002)(446003)(6246003)(25786009)(54906003)(6436002)(81156014)(76116006)(66556008)(8676002)(73956011)(2940100002)(5660300002)(71190400001)(14444005)(74316002)(6506007)(26005)(71200400001)(99286004)(8936002)(52536014)(6116002)(7696005)(7736002)(478600001)(66066001)(68736007)(256004)(76176011)(86362001)(53936002)(81166006)(3846002)(64756008)(66476007)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4184;H:AM6PR05MB5224.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: AYS5iZxw0oIhyO7sPav/IHdaWCGkN8Yvns9TpiaaBrDUSrISXq3xaZ8MqNkclh/4G42s4/0FijnREioWys34jIJlDLiB89UB2pHSC9vwTfwajvuteqMHusTdRj6ioyHEhF1Ncp63oz1pxViz0FyVWCeRNAN28T03XC+v2g+cmpctBQ70LnW+Gt7kjl93lf9W2N9ANznIJqF/9L8R7OgXjJtavPVhVtZA1rvrpeZEF7UB4w6HSEd0mnwu7RK1C0h5mKsqkQQzzKzUGNPNfii8oy1uv+5N2du+qh2CDRgXDMgnq4QER1XYsiKYtjfxF7ZmrMtpBkna9B8jgAGXaTCYKEbefcdRGKbzH4vh7yNTLROtSRy2xXxxieU0hcKSfaLXM9lR4WDjNefydtwib9sbOEf0GdzrmhdIlBgzxzP6gyc=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bee5584-bae7-45ed-4230-08d6f7f57a30
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2019 16:11:40.7485
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vadimp@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4184
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Vadim Pasternak
> Sent: Sunday, June 23, 2019 7:01 PM
> To: Andrew Lunn <andrew@lunn.ch>; Ido Schimmel <idosch@idosch.org>
> Cc: netdev@vger.kernel.org; davem@davemloft.net; Jiri Pirko
> <jiri@mellanox.com>; mlxsw <mlxsw@mellanox.com>; Ido Schimmel
> <idosch@mellanox.com>
> Subject: RE: [PATCH net-next 3/3] mlxsw: core: Add support for negative
> temperature readout
>=20
>=20
>=20
> > -----Original Message-----
> > From: Andrew Lunn <andrew@lunn.ch>
> > Sent: Sunday, June 23, 2019 6:44 PM
> > To: Ido Schimmel <idosch@idosch.org>
> > Cc: netdev@vger.kernel.org; davem@davemloft.net; Jiri Pirko
> > <jiri@mellanox.com>; mlxsw <mlxsw@mellanox.com>; Vadim Pasternak
> > <vadimp@mellanox.com>; Ido Schimmel <idosch@mellanox.com>
> > Subject: Re: [PATCH net-next 3/3] mlxsw: core: Add support for
> > negative temperature readout
> >
> > > --- a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
> > > +++ b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
> > > @@ -52,8 +52,7 @@ static ssize_t mlxsw_hwmon_temp_show(struct device
> > *dev,
> > >  			container_of(attr, struct mlxsw_hwmon_attr,
> > dev_attr);
> > >  	struct mlxsw_hwmon *mlxsw_hwmon =3D mlwsw_hwmon_attr->hwmon;
> > >  	char mtmp_pl[MLXSW_REG_MTMP_LEN];
> > > -	unsigned int temp;
> > > -	int index;
> > > +	int temp, index;
> > >  	int err;
> > >
> > >  	index =3D mlxsw_hwmon_get_attr_index(mlwsw_hwmon_attr-
> > >type_index,
> > > @@ -65,7 +64,7 @@ static ssize_t mlxsw_hwmon_temp_show(struct device
> > *dev,
> > >  		return err;
> > >  	}
> > >  	mlxsw_reg_mtmp_unpack(mtmp_pl, &temp, NULL, NULL);
> > > -	return sprintf(buf, "%u\n", temp);
> > > +	return sprintf(buf, "%d\n", temp);
> > >  }
> >
> > If you had used the hwmon core, rather than implementing it yourself,
> > you could of avoided this part of the bug.
> >
>=20
> Hi Andrew.
>=20
> Yes.
> But before we handle only positive temperature.
> And currently support for the negative readouts has been added.
>=20
> > >  static ssize_t mlxsw_hwmon_temp_rst_store(struct device *dev, @@
> > > -215,8 +213,8 @@ static ssize_t mlxsw_hwmon_module_temp_show(struct
> > device *dev,
> > >  			container_of(attr, struct mlxsw_hwmon_attr,
> > dev_attr);
> > >  	struct mlxsw_hwmon *mlxsw_hwmon =3D mlwsw_hwmon_attr->hwmon;
> > >  	char mtmp_pl[MLXSW_REG_MTMP_LEN];
> > > -	unsigned int temp;
> > >  	u8 module;
> > > +	int temp;
> > >  	int err;
> > >
> > >  	module =3D mlwsw_hwmon_attr->type_index - mlxsw_hwmon-
> sensor_count;
> >
> > I think you missed changing the %u to %d in this function.
>=20
> If I am not wrong, I think you refer to mlxsw_hwmon_fan_rpm_show(), where=
 it
> should be %u.
>=20
 O, I see what you mentioned.
This is mlxsw_hwmon_module_temp_show().
Yes, right it should be %d.
Thank you.

> >
> > > @@ -519,14 +519,14 @@ static int
> > > mlxsw_thermal_module_temp_get(struct
> > thermal_zone_device *tzdev,
> > >  		return 0;
> > >  	}
> > >  	mlxsw_reg_mtmp_unpack(mtmp_pl, &temp, NULL, NULL);
> > > -	*p_temp =3D (int) temp;
> > > +	*p_temp =3D temp;
> > >
> > >  	if (!temp)
> > >  		return 0;
> > >
> > >  	/* Update trip points. */
> > >  	err =3D mlxsw_thermal_module_trips_update(dev, thermal->core, tz);
> > > -	if (!err)
> > > +	if (!err && temp > 0)
> > >  		mlxsw_thermal_tz_score_update(thermal, tzdev, tz->trips,
> > temp);
> >
> > Why the > 0?
>=20
> We don't consider negative temperature for thermal control.
>=20
> >
> >     Andrew
