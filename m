Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA5B2718B3
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 01:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbgITX7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 19:59:33 -0400
Received: from mail-eopbgr40076.outbound.protection.outlook.com ([40.107.4.76]:12512
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726156AbgITX7c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Sep 2020 19:59:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hvirCnZo1st+TfzBggn34li1lH1W/QZM9mH2wRTy7FH2zuWA24D9PWVwY4xFirZfU1y8V4IQORh+SGjuLoR/I+IeX5+QbV1AQRsEUWekhIkKi5YwDgqKS2uexEvOslnJ6JVbxChHKsc2DXqFjpmucb/BMnrGtenO8ES3NSP7XphzS4hZsATRA/xraYG4nVJFigNNbIpk8y18jt1MH+WExOH/nFNaxuOIw7e2VeijY5ZKCVQyjfKMqzmylQcrL+g2jPUDX8dbST80EVo8k7hSdwxntUbOnRJGeu8fpTsGJiRY7XUMxu6xn8LC19q+b+B/boKL/HykC/wGIjLuX8McfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OWTdo42zFxQedSnuw/VS7+7CEh8UoNDrnrj+y6z8lMU=;
 b=S8CY3mSORzwLfpyPZPMAiDOniNQOd+X+6pjugxEgmhhvHZo8fn28Sip2uICiSHaS9rIMCe5tJDK+D4RlDQtPLuh7uqvnLsOaXa4/IAaHwhAwqsmcS+x4r4YN3ZN0YzY4zfFQYnbspD2XZtBaH+unSDGsxcUuaXah4kQrEpeD8KhQwMrTj5cn3+/AbN/y9O9lnF/7ymTa9H5LszZNgw/bijVvX8FQpzuQ/rNP3OWMx997N49czStJ5PYLs9zSz5zYS57Zj5dHJwxv1N6oe9uLi8Sm7zXWBwq+AKRu5r6npeEyVEx7euoUUQjU79hvcQOHqGk479ziy+ESgnQH3KLbKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OWTdo42zFxQedSnuw/VS7+7CEh8UoNDrnrj+y6z8lMU=;
 b=JVdaLpwMFP6mkqSo2bSZL6YIUnS/BxHui65NpC0AKx3wa6QntR6xO/pKwleBC+w03WEHI91EbGzUKRt15//Jtk5dS0gb2rQ7OFR/rsCQMqLTkBg6Zw4+u3C0TbU9hs4llFJ3DUQZWArlrlTmmh+uuT5OQIwD36ZTZRZIxueZ+n8=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7374.eurprd04.prod.outlook.com (2603:10a6:800:1ac::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Sun, 20 Sep
 2020 23:59:27 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3391.014; Sun, 20 Sep 2020
 23:59:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH net-next RFC v1 4/4] net: dsa: mv88e6xxx: Add per port
 devlink regions
Thread-Topic: [PATCH net-next RFC v1 4/4] net: dsa: mv88e6xxx: Add per port
 devlink regions
Thread-Index: AQHWjpNQb2AbGJ/CwEa1iUSxmKzmF6lyNvwA
Date:   Sun, 20 Sep 2020 23:59:26 +0000
Message-ID: <20200920235926.66ijlyq5kvdr6ov5@skbuf>
References: <20200919144332.3665538-1-andrew@lunn.ch>
 <20200919144332.3665538-5-andrew@lunn.ch>
In-Reply-To: <20200919144332.3665538-5-andrew@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.217.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2c3c5366-9a3f-4de5-5c75-08d85dc134e1
x-ms-traffictypediagnostic: VE1PR04MB7374:
x-microsoft-antispam-prvs: <VE1PR04MB7374E4CF89ADC54601D0EA91E03D0@VE1PR04MB7374.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1186;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SPxoGxa5wDTtCIJqvsKsMgZ9Bu/5K7fEjDejdmqzHNmxa8yHTlqy7Y6wwn3rEtV1BTvzwI5RGF6eWEfo6e+OwbFIuvoWOvgCPoYMnBrYCL+MNndbpiRkUt/NEbGAKp3B68JtNaxRbAii+xmPHtjs/d+CD0kxoSrXUTB5ItO9ub+26gj5d7irjyWGozq1wVcAzrxX3T1pShglILTMf0qFZ/jp8mr+suN61R3QtJvCZIC8yUl9bqqV5uCJx6GkCOrrEp9iNTmmCdFoPCYcEjBw1OUziuZPlo1+81CCbFIbil0wR2ho99/d8Pb3U3CcU+rLvV/v8RpRWAF4hzeBUiy1Mw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(39860400002)(366004)(376002)(136003)(396003)(346002)(66556008)(66476007)(64756008)(4326008)(2906002)(44832011)(6916009)(9686003)(6512007)(8936002)(1076003)(76116006)(8676002)(66946007)(71200400001)(478600001)(66446008)(54906003)(5660300002)(316002)(6506007)(83380400001)(6486002)(33716001)(186003)(26005)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: i1bAQSrEXTWgiz7poFH9dn6OBilcw16xgRCP+3y4IDe3BJvjJVO2m0gkBb8lS97R4hcX1B928mlNiS3T8XYGhCkDIJYN7I7U6VdTuxcqIWIfV+8VoU9HPZ68LJaDDrK5Y+dVSljzD3N81qPdhary7MozXS05RefmMxrCXROW6wahI5ZU4melYlTyaUDuKRoFySDjOsfuKX8Nxk4LVVxQ2onU1GLE7qdhQdbmtCThok5avTD4psc6Ku0Ik/Zf3zuoXdwm4A3MMWQgUa0fKBu4zswD4D+N5CgN33Q1R35CA9bH5vaVD6evvoKxTqmIvN9c6v8fhXGDokyEgwQqEUZaF3y7FRG75NI5wxM4wfTXOy6Wnuba0+e3XWS1qU5HVktMHt0zKt5BoRs4dOeOd4ZF2vghcuqVpGtaiGda8e+/TQAAKBnH5XXdzwU0V9fHDK7OzAO9dJMbzSVX5k09AzgbbAt9oKsZ3Tx0ZfFAX5PetOm8/s5fw1U3nWE5Fs/eornMzYIgYkzEtwqXygudopZpfTMwmHeWz1605MprM3r1djJf/LUonNtmCQB85q7AJqj5UXgO8kdzlYm5GQC+0T9De3vPFVBKYPOq0ECTXsncjQS/N6Os6E0SWyUqQ+uSD+ed0BAbLMgJTMKCNq6aWuOrqQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <064687EF694BAB4AAFEBB1F2D438459E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c3c5366-9a3f-4de5-5c75-08d85dc134e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2020 23:59:26.9911
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OYWuuZWXKmc6mcGthv64iI5DmLCEAHP9tB2b+wxeLE0nfHQ1Rtpz1yeAAWXnFOe0WNbxAwOSJz8258WX1TqxbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7374
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 19, 2020 at 04:43:32PM +0200, Andrew Lunn wrote:
> Add a devlink region to return the per port registers.
>=20
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c    |  8 ++++
>  drivers/net/dsa/mv88e6xxx/devlink.c | 61 +++++++++++++++++++++++++++++
>  drivers/net/dsa/mv88e6xxx/devlink.h |  6 ++-
>  3 files changed, 74 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx=
/chip.c
> index 9417412e5fce..3d2d813f7a79 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -2741,10 +2741,16 @@ static int mv88e6xxx_port_enable(struct dsa_switc=
h *ds, int port,
>  	struct mv88e6xxx_chip *chip =3D ds->priv;
>  	int err;
> =20
> +	err =3D mv88e6xxx_setup_devlink_regions_port(ds, chip, port);
> +	if (err)
> +		return err;
> +
>  	mv88e6xxx_reg_lock(chip);
>  	err =3D mv88e6xxx_serdes_power(chip, port, true);
>  	mv88e6xxx_reg_unlock(chip);
> =20
> +	if (err)
> +		mv88e6xxx_teardown_devlink_regions_port(chip, port);
>  	return err;
>  }
> =20
> @@ -2752,6 +2758,8 @@ static void mv88e6xxx_port_disable(struct dsa_switc=
h *ds, int port)
>  {
>  	struct mv88e6xxx_chip *chip =3D ds->priv;
> =20
> +	mv88e6xxx_teardown_devlink_regions_port(chip, port);
> +
>  	mv88e6xxx_reg_lock(chip);
>  	if (mv88e6xxx_serdes_power(chip, port, false))
>  		dev_err(chip->dev, "failed to power off SERDES\n");
> diff --git a/drivers/net/dsa/mv88e6xxx/devlink.c b/drivers/net/dsa/mv88e6=
xxx/devlink.c
> index 81e1560db206..dc8a244aa154 100644
> --- a/drivers/net/dsa/mv88e6xxx/devlink.c
> +++ b/drivers/net/dsa/mv88e6xxx/devlink.c
> @@ -415,6 +415,36 @@ static int mv88e6xxx_region_atu_snapshot(struct devl=
ink *dl,
>  	return err;
>  }
> =20
> +static int mv88e6xxx_region_port_snapshot(struct devlink_port *devlink_p=
ort,
> +					  const struct devlink_port_region_ops *ops,
> +					  struct netlink_ext_ack *extack,
> +					  u8 **data)
> +{
> +	struct dsa_switch *ds =3D dsa_devlink_port_to_ds(devlink_port);
> +	int port =3D dsa_devlink_port_to_port(devlink_port);
> +	struct mv88e6xxx_chip *chip =3D ds->priv;
> +	u16 *registers;
> +	int i, err;
> +
> +	registers =3D kmalloc_array(32, sizeof(u16), GFP_KERNEL);
> +	if (!registers)
> +		return -ENOMEM;
> +
> +	mv88e6xxx_reg_lock(chip);
> +	for (i =3D 0; i < 32; i++) {
> +		err =3D mv88e6xxx_port_read(chip, port, i, &registers[i]);
> +		if (err) {
> +			kfree(registers);
> +			goto out;
> +		}
> +	}
> +	*data =3D (u8 *)registers;
> +out:
> +	mv88e6xxx_reg_unlock(chip);
> +
> +	return err;
> +}
> +
>  static struct mv88e6xxx_region_priv mv88e6xxx_region_global1_priv =3D {
>  	.id =3D MV88E6XXX_REGION_GLOBAL1,
>  };
> @@ -443,6 +473,12 @@ static struct devlink_region_ops mv88e6xxx_region_at=
u_ops =3D {
>  	.destructor =3D kfree,
>  };
> =20
> +static const struct devlink_port_region_ops mv88e6xxx_region_port_ops =
=3D {
> +	.name =3D "port",
> +	.snapshot =3D mv88e6xxx_region_port_snapshot,
> +	.destructor =3D kfree,
> +};
> +
>  struct mv88e6xxx_region {
>  	struct devlink_region_ops *ops;
>  	u64 size;
> @@ -478,6 +514,31 @@ void mv88e6xxx_teardown_devlink_regions(struct dsa_s=
witch *ds)
>  	mv88e6xxx_teardown_devlink_regions_global(chip);
>  }
> =20
> +int mv88e6xxx_setup_devlink_regions_port(struct dsa_switch *ds,
> +					 struct mv88e6xxx_chip *chip,
> +					 int port)

You probably don't need to pass both *ds and *chip here, since you can
derive one from the other.

> +{
> +	struct devlink_region *region;
> +
> +	region =3D dsa_devlink_port_region_create(ds,
> +						port,
> +						&mv88e6xxx_region_port_ops, 1,
> +						32 * sizeof(u16));
> +	if (IS_ERR(region))
> +		return PTR_ERR(region);
> +
> +	chip->ports[port].region =3D region;
> +
> +	return 0;
> +}
> +
> +void mv88e6xxx_teardown_devlink_regions_port(struct mv88e6xxx_chip *chip=
,
> +					     int port)
> +{
> +	if (chip->ports[port].region)
> +		dsa_devlink_region_destroy(chip->ports[port].region);
> +}
> +
>  static int mv88e6xxx_setup_devlink_regions_global(struct dsa_switch *ds,
>  						  struct mv88e6xxx_chip *chip)
>  {
> diff --git a/drivers/net/dsa/mv88e6xxx/devlink.h b/drivers/net/dsa/mv88e6=
xxx/devlink.h
> index 3d72db3dcf95..9302f0ee550d 100644
> --- a/drivers/net/dsa/mv88e6xxx/devlink.h
> +++ b/drivers/net/dsa/mv88e6xxx/devlink.h
> @@ -14,7 +14,11 @@ int mv88e6xxx_devlink_param_set(struct dsa_switch *ds,=
 u32 id,
>  				struct devlink_param_gset_ctx *ctx);
>  int mv88e6xxx_setup_devlink_regions(struct dsa_switch *ds);
>  void mv88e6xxx_teardown_devlink_regions(struct dsa_switch *ds);
> -
> +int mv88e6xxx_setup_devlink_regions_port(struct dsa_switch *ds,
> +					 struct mv88e6xxx_chip *chip,
> +					 int port);
> +void mv88e6xxx_teardown_devlink_regions_port(struct mv88e6xxx_chip *chip=
,
> +					     int port);
>  int mv88e6xxx_devlink_info_get(struct dsa_switch *ds,
>  			       struct devlink_info_req *req,
>  			       struct netlink_ext_ack *extack);
> --=20
> 2.28.0
>=20

Thanks,
-Vladimir=
