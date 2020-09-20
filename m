Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39F59271895
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 01:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbgITXXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 19:23:34 -0400
Received: from mail-eopbgr30078.outbound.protection.outlook.com ([40.107.3.78]:35140
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726305AbgITXXe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Sep 2020 19:23:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iAe8Wagi67BMvs4+Zx2YzXMh4LJ7yfVLuBq0ylUl+R74ER29cCz6M3WP4voDYV7FIipDlzJ4yASPPx1pz0z1eRVO27tjKfg3nm/3xt4R3vxxZa/EKu2/Ol0VmKmUjsdSsZLI7yDUCcNEbsLmrJBU2CU0n20zzrKdbQ75wBGLPbr8AZVZfNEB7LLw98bk+7dO1FDsw9lf/E9R7QSmsfdzR9Icl+yXhLGxWTxiJwYNmRrtplnq7TS6VriqdT1ZYW51dRVoe4Bc0wvYwQ4wtsUmHWm61VDtAikZGBpgxWJ5CLxhLMhHqCjA+blIgRIDk2TyQ44OwmSK5HDXa2ARNfk07Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X43/LHMQ1S+9dAs+W+9ftr7/E3FTYXeth0AeOlM+bL0=;
 b=fn7+cgSFBPLtVIDv308Pb3OD7yQuTgipnb9rroIw/Tj1Mpt1R+V1Rs9/2cDIkAOutiEOwYMOiL6WZkWEAux+AeTdDXsV6hqkoF1p3Avp1ykzA4sOREtYKamMsPRve+/daHGN6g6ow6JqXgB76QHRcy9h7HtsRQGTXeKuMNGTeDva16FLORsyVxBw9uoODaTOvMp9SAyeQh+KXvZEeUVK+DH/o4uY6sEjo1ZINvme9NsB/cTT3StYdjIXlBd0Eiq3Q5gwtqFfR9F+Un3mq9/MCyyOgoQJbjnXgDzPKRK6Q7gSKrjMWQHxtzQPXhI7e52ZTtFB5iyYyZH0AHKjiu70qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X43/LHMQ1S+9dAs+W+9ftr7/E3FTYXeth0AeOlM+bL0=;
 b=IMsV5DkJliMmA5gyLMAgl+XJVc2/tS/eo2myE0OnykiBX5whcNYTTxGOnd2dx/iHNEbfuH9TGOBq9H7hirUIT4m1WXxgdz988+nNkn27zD6NSt/OhSROzQ7tGwk+QvE0iAKnquSU8dkYgq36haByoIL+Dr8MkQWHxauiuHJ6iKc=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4221.eurprd04.prod.outlook.com (2603:10a6:803:3e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Sun, 20 Sep
 2020 23:23:30 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3391.014; Sun, 20 Sep 2020
 23:23:29 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH net-next RFC v1 2/4] net: dsa: Add devlink port regions
 support to DSA
Thread-Topic: [PATCH net-next RFC v1 2/4] net: dsa: Add devlink port regions
 support to DSA
Thread-Index: AQHWjpNSUDjDBh5J9kaRERDwmnIlLqlyLPAA
Date:   Sun, 20 Sep 2020 23:23:29 +0000
Message-ID: <20200920232328.o4gcq23olg75ia6n@skbuf>
References: <20200919144332.3665538-1-andrew@lunn.ch>
 <20200919144332.3665538-3-andrew@lunn.ch>
In-Reply-To: <20200919144332.3665538-3-andrew@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.217.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4c850775-bc2a-44cc-c118-08d85dbc2f2f
x-ms-traffictypediagnostic: VI1PR04MB4221:
x-microsoft-antispam-prvs: <VI1PR04MB4221AD09FD1DDCFDA7F25733E03D0@VI1PR04MB4221.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:773;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JPaL74d4tgdBv9rDzqY27UG/E6Y0URfW6eIYKXuhz5pRW5mjWawNTtg8FNMdC6d5H5lImdnndU0b6QBKYuzhEZGe7nn9LLNpViCKa2jUrrdtX+RC6dB8KwAnvRLApl3YyjSzOWFmiTTY2x/jcNk3y7uHl/G45MCX13nIC/0Q8skKx5KydAO1DfC243WaY2cSCaUNFKYN/FGw5Lz2rb8K2D2UZb19/11FGdeSZP8nN96oyKlcpLHhoPNuFOut8E5GrHCPDShT/y20+aaLBRvEHFcTEam+AkrZ3NXx4xLN/D7cObQW9TBFuz0Dt918t/ew8WauzM/ldmZK/k3DWlSZiA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(376002)(366004)(346002)(136003)(39860400002)(396003)(8936002)(6506007)(44832011)(8676002)(6916009)(6512007)(2906002)(26005)(83380400001)(54906003)(9686003)(316002)(71200400001)(4326008)(478600001)(6486002)(186003)(66446008)(66476007)(66946007)(64756008)(66556008)(76116006)(1076003)(33716001)(86362001)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Eky1M7UFB5xu/X3HNeiyShAswXwne6BhKAB7jVFdmjLY00n4S8bPi/2saQ8iUXnaPjjeuMYMBQqFwQW7eFYq/9vv+9ok2CjCWmgZUUmP9Ml1ouMUC+160c75LXVvAnhj/LghQmsTekod9FCS6pArj5RJBCHSxUpt/qknJoEC35xGiCzLZEHfZ9YJQDlmTq/Nvy/A5oJDDP6vr8MVCDymBBE+2TN3fyQtUajkiBzMKKH93mHIFx0VThaYMo0aeDZ6YhjDke/IokDCBd4DdwutpAGi2a9W30IJMvF3g+H0Z/tSXtnd7/ew8/t7EkVPP8El5GVGDJEftVsJNhOJb0fDGjMWCpmAJKxJddIpUW7VXI+x7l9sW5fV2PY5T8l2KAZN+2/nzTq2cQG0muswgV33RdDmIQsU5N0CvhJNZFzWScUS1DgUpAiYO3hZhKEe/npSeaM4SqE91w9OAhc7W74XK+BEke5ylShNSjsxug/v5FVtD0FmAIir58mB/4alSiBy9DqOUe18KcRMPHmdJxzdlTRI11kPW3UHrJp6S03qq+EmylwZBHqg2+Yy+QhTfMJCNz0nsVOXeT8vew7Lf1a1eBJj+PfvR9Kb3iZh5aSxV2axp/JaganeOyKW73rkIvLwDzJM+cnqWFu1NA4H9KOV3w==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BB28B6F2BD49A74B841A22408A46EFB2@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c850775-bc2a-44cc-c118-08d85dbc2f2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2020 23:23:29.8889
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WHwCFnEjqdEht/I2cMGqhh0HZaMXn2Ji7mhFqGBVifgU5rBbNp5qksi3wePEav9ulGeRzikpa/+QZX2uwgOFsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4221
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 19, 2020 at 04:43:30PM +0200, Andrew Lunn wrote:
> Allow DSA drivers to make use of devlink port regions, via simple
> wrappers.
>=20
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  include/net/dsa.h  |  5 +++++
>  net/core/devlink.c |  3 +--
>  net/dsa/dsa.c      | 14 ++++++++++++++
>  3 files changed, 20 insertions(+), 2 deletions(-)
>=20
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index d16057c5987a..01da896b2998 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -665,6 +665,11 @@ struct devlink_region *
>  dsa_devlink_region_create(struct dsa_switch *ds,
>  			  const struct devlink_region_ops *ops,
>  			  u32 region_max_snapshots, u64 region_size);
> +struct devlink_region *
> +dsa_devlink_port_region_create(struct dsa_switch *ds,
> +			       int port,
> +			       const struct devlink_port_region_ops *ops,
> +			       u32 region_max_snapshots, u64 region_size);
>  void dsa_devlink_region_destroy(struct devlink_region *region);
> =20
>  struct dsa_port *dsa_port_from_netdev(struct net_device *netdev);
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 66469cdcdc1e..4701ec17f3da 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -4292,7 +4292,6 @@ static int devlink_nl_cmd_region_get_port_dumpit(st=
ruct sk_buff *msg,
>  	}
> =20
>  out:
> -	mutex_unlock(&devlink_mutex);

This diff is probably not intended?

>  	return err;
>  }
> =20
> @@ -4330,7 +4329,7 @@ static int devlink_nl_cmd_region_get_devlink_dumpit=
(struct sk_buff *msg,
>  	}
> =20
>  out:
> -	mutex_unlock(&devlink_mutex);
> +	mutex_unlock(&devlink->lock);

Similar here.

>  	return err;
>  }
> =20
> diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
> index 5c18c0214aac..97fcabdeccec 100644
> --- a/net/dsa/dsa.c
> +++ b/net/dsa/dsa.c
> @@ -414,6 +414,20 @@ dsa_devlink_region_create(struct dsa_switch *ds,
>  }
>  EXPORT_SYMBOL_GPL(dsa_devlink_region_create);
> =20
> +struct devlink_region *
> +dsa_devlink_port_region_create(struct dsa_switch *ds,
> +			       int port,
> +			       const struct devlink_port_region_ops *ops,
> +			       u32 region_max_snapshots, u64 region_size)
> +{
> +	struct dsa_port *dp =3D dsa_to_port(ds, port);
> +
> +	return devlink_port_region_create(&dp->devlink_port, ops,
> +					  region_max_snapshots,
> +					  region_size);
> +}
> +EXPORT_SYMBOL_GPL(dsa_devlink_port_region_create);
> +
>  void dsa_devlink_region_destroy(struct devlink_region *region)
>  {
>  	devlink_region_destroy(region);
> --=20
> 2.28.0
>=20

Thanks,
-Vladimir=
