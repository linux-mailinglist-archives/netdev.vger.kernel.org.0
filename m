Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12EB531D7BE
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 11:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbhBQK5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 05:57:24 -0500
Received: from mail-eopbgr30085.outbound.protection.outlook.com ([40.107.3.85]:32560
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229707AbhBQK5P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 05:57:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZrPqfNWhs1uaLuRaAU/N2L5pj7nKBER5WLyyJZjzg6Kvg6tTpr8mchsRB996vX9FwX+F2r1iQ5KmAHckxk5sAwQcJNBizx1YijtR1fGcQM37/RQlgOPohTNnI53L99ajIPCn/6PRUACaUkMkRKVodXUuKl2R7A1m1oJn1TYpWwYHpL5GW3yNf0Zw+baLGcSPnMXKO9lWLaumFWVopcIPWlDz7jJoFDCqjgqdjOgeS4l9uGUlUGKPSpB8ZLIdeUg9FlTQj6CBnK6zwANKjtrrgJ6dlbN/MGywKuoaDFjt4CcAlHDyhCSj5KxcGNDo4CNjcZZlvksHuiC+zfWcYILaLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6KLMQTuObJSA9QIMaMCef6bB2Ga2f3nOrogAh5nYxOM=;
 b=TJTiFRM27QKmnm6m6IjZFcgyogA/ACIfD02zC6y6QMLyodIhkMkV1IkqpwSfkZWmIAFeorgUVLOQCfY3LR2pGNZQ2PEweTb+URK5I46qWm0Xz/xvQSrlcOEFVHhFef7W9S6T5Yzwu48jC54Y/X4yIytVTe01h1Zl6dpSx9QaPTdd/CDpsYWk63bDJczbHJLkuTsVlY/0Tr0IeGC2upuMyNuxtJVGixW6UaBQ1x/BNSWpnvuD+li7xLi36O53Ho3RNv3kBmOJiLhykxrLeJsRUQQdB0RXLFrIlooKpaNPYKoOf2aDNQAl1F7IqeWbDRZUxvsakUlYnval2ZQlHoCh5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6KLMQTuObJSA9QIMaMCef6bB2Ga2f3nOrogAh5nYxOM=;
 b=dNBdZ9B0nRtd9SVbr3QYMwf+MipFUcG+jwb0P1EHfugoBDzfO0CfQO1rUbdJ+8uWpvFh+pzibm2poQbnc2DNe3PIaCMCxoRwo15hCmajSwpMbVcgfEZo3cLOFrkYLdJianeqGYa2PNd9EULKmM+GRZPEt43rRbZH4VJcvSZOpiY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Wed, 17 Feb
 2021 10:56:26 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%7]) with mapi id 15.20.3846.042; Wed, 17 Feb 2021
 10:56:26 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "ivecera@redhat.com" <ivecera@redhat.com>,
        "nikolay@nvidia.com" <nikolay@nvidia.com>,
        "roopa@nvidia.com" <roopa@nvidia.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "rasmus.villemoes@prevas.dk" <rasmus.villemoes@prevas.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH net-next v4 4/8] bridge: mrp: Extend br_mrp_switchdev to
 detect better the errors
Thread-Topic: [PATCH net-next v4 4/8] bridge: mrp: Extend br_mrp_switchdev to
 detect better the errors
Thread-Index: AQHXBKzNjMFI2d//q0iFlfLbm7atSqpcLbcA
Date:   Wed, 17 Feb 2021 10:56:25 +0000
Message-ID: <20210217105624.aehyxw3tfs5uycdl@skbuf>
References: <20210216214205.32385-1-horatiu.vultur@microchip.com>
 <20210216214205.32385-5-horatiu.vultur@microchip.com>
In-Reply-To: <20210216214205.32385-5-horatiu.vultur@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.227.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f3633561-c326-4b50-e296-08d8d332abfb
x-ms-traffictypediagnostic: VI1PR04MB7104:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB7104DED91946A12CA467B058E0869@VI1PR04MB7104.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uw8507N7jTiIL4s6MgLdVaj3PXN9QYNMSPuMlSYPNDa5xIsQQI/IwgziilZPSysGC0ZbsiUm303H2x2hVdnpxupz/8DMMFISL3O/FBm/2jxibO2/St2fO/m4OyekUu36rSb1FgMMVs8XBahikaZkDVABnl6WEbEatuLoYWpxW0hDJUuxsYWIEdvIZge3IL/S600EITOMqmnMakAVS9WMOzzHlxSqIBtMYkWBKaZFQJIB8dnwbl49rwSb8qyH7DUjl6wBLqxhgXaYHKbPEKWs9Y1oWjSFVLRT+G82xEMBWXTxIxOBntGyf3JDhSvxJcv6O5e5JXol979+0TEWRWxFEOux/7yb0/+FB//371ZL/uS72Owf6aq/t4BjZR5XuYxscAPlrOxMfulcf82XPN093e+pQkQKDo77I3t1TD1BqfTRDs9fYBV7mXkq/JEMdfmpYYbSOB2YPHHToV9XksFSLB3OAjgE1QdTDu402B9v+Ip7mbl/9FNlc2/FbFDeaxuYtn06FPmYbu9VxWFFeuKzSw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(26005)(4326008)(186003)(6506007)(44832011)(83380400001)(8676002)(91956017)(54906003)(6486002)(478600001)(6916009)(66946007)(6512007)(71200400001)(66446008)(33716001)(7416002)(64756008)(86362001)(8936002)(1076003)(316002)(66476007)(9686003)(66556008)(5660300002)(76116006)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?GxcbmOdz9MV9/YZ0OxArxzgFYiOZM9H+CjhrgxbOr5rWVn3eNUtsy1MzVDTF?=
 =?us-ascii?Q?ahr9wlYrFkdCyk35KS3SbuSHnGGzicKeQK6n605+HZePK/gf1ag0wTSuTpAV?=
 =?us-ascii?Q?5+rNVDC0cU1XwbTrenWhYTzR2DihQR18BBBQ8yyvBbIuVkujBsFHRyztiGo7?=
 =?us-ascii?Q?wxkt9KBRWXaRNPLX4PVzQCmjp5PcvMSUeQpmQ2Tx2Oeoia0B2PY4+HImuVpu?=
 =?us-ascii?Q?WiqHlKoWukmuSFsdetI7saUn5JVAhm/kFFLvzQs6Iel9/bZUWblS6E+RhE3w?=
 =?us-ascii?Q?Rk5JypUxPS/I/9N61milGOhfK6AElP8NOcF2kuqvE6nkKAWcxCZ/jyhdaGJB?=
 =?us-ascii?Q?pxUrU8nYMJhsrJgXirEZRsDj8LUyc9CPoD+/BNu8xRZnkuUtpND61C/rwoJ3?=
 =?us-ascii?Q?8NPUOTX+af/MnAN00ei4qCW6+JlyTxSU9uTKu6pEHS/NWOwt7NcLMWWnWLp5?=
 =?us-ascii?Q?037QbqRK6SQodOUKjGBzwEMRYhCBwqkLMno57OoHuCvgTupiNUKoPEk9gqXY?=
 =?us-ascii?Q?Y/TsFsRHLOwyRs6qPKm2OpACfiPV+/ZcsvIftk1K57T4S0t4CA/wJh8p/zDi?=
 =?us-ascii?Q?RvPHf2mWMBY15UjXmJAlurbPHd/NdoM9EGvTv7dIaNAPZBxgbrng4dbcutKG?=
 =?us-ascii?Q?W+tWe1BwCoHR5wf5PO3LiUDd1H0QQ1k+Gh95l9ldFhVArL71gpjWV5VD9wNw?=
 =?us-ascii?Q?3m8pZ43KmRSNERAJTVjGvn4h553XA/wbZQFO7Ldzn+ywT9tyMCHmT67sZo52?=
 =?us-ascii?Q?GYZVark8KAsJVK1xDUx9/pGNP4D3mt6/mY6U1GPwb5N8ekz/X7ZdqPHqdOom?=
 =?us-ascii?Q?XzWu9SH+u+jSrgRhPYb2458463lXK1vmg0plMi/56TkeNUtWnSYidoia3H9W?=
 =?us-ascii?Q?LojGF17JWgpmGGf1pxBBkTSkOm1Tjey1FEqF5kfpSSt6aRQAq9zFHNEwvYcT?=
 =?us-ascii?Q?VcMcx3w8hRujlq8ppYcaO4V6wqg0npU40K50LrLQfwYRPSMC1FVRxJ5OeetX?=
 =?us-ascii?Q?/9J+6xCzuAaFXXSF80LAiDVaPiKfhb2N3k8Ymq7toezTLAk1hyj/eQTe4Xsl?=
 =?us-ascii?Q?Aysp5Wc0+gpwNNjNDGytKyk9j5gwFTE9GRc4GgyGY+JNJtuw1J48OwF9EWBB?=
 =?us-ascii?Q?qfBSIsPtzLBxugcG5uxsUlLEudPkMH/fnIg+FJJcGK6CA+466t3Mb1reMfq+?=
 =?us-ascii?Q?Nx4DMOjMZ1l0b9WBI71sVongB5NW9cr/lHTPbY1/PmSgTqdmk7R3JczGNril?=
 =?us-ascii?Q?+zxO8yli7rnOg2v15eqh/65WwjIEeaaYR7DuG+x8kIBNLJnCi8Nga23BerrN?=
 =?us-ascii?Q?0NrUhfCybS5gwvQLqBDyQ5yC?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3B1C35D6AD07A842808B7267A18006C1@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3633561-c326-4b50-e296-08d8d332abfb
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2021 10:56:25.8862
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EhCEI5CBqsO/XGni1F1AzkuQpVp8/uO4uZFscp+789hYKPr0NCMn04nH0um/ah58oMRO6HADFBc7DY/BF2cjHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 16, 2021 at 10:42:01PM +0100, Horatiu Vultur wrote:
> This patch extends the br_mrp_switchdev functions to be able to have a
> better understanding what cause the issue and if the SW needs to be used
> as a backup.
>=20
> There are the following cases:
> - when the code is compiled without CONFIG_NET_SWITCHDEV. In this case
>   return success so the SW can continue with the protocol. Depending
>   on the function, it returns 0 or BR_MRP_SW.
> - when code is compiled with CONFIG_NET_SWITCHDEV and the driver doesn't
>   implement any MRP callbacks. In this case the HW can't run MRP so it
>   just returns -EOPNOTSUPP. So the SW will stop further to configure the
>   node.
> - when code is compiled with CONFIG_NET_SWITCHDEV and the driver fully
>   supports any MRP functionality. In this case the SW doesn't need to do
>   anything. The functions will return 0 or BR_MRP_HW.
> - when code is compiled with CONFIG_NET_SWITCHDEV and the HW can't run
>   completely the protocol but it can help the SW to run it. For
>   example, the HW can't support completely MRM role(can't detect when it
>   stops receiving MRP Test frames) but it can redirect these frames to
>   CPU. In this case it is possible to have a SW fallback. The SW will
>   try initially to call the driver with sw_backup set to false, meaning
>   that the HW should implement completely the role. If the driver returns
>   -EOPNOTSUPP, the SW will try again with sw_backup set to false,
>   meaning that the SW will detect when it stops receiving the frames but
>   it needs HW support to redirect the frames to CPU. In case the driver
>   returns 0 then the SW will continue to configure the node accordingly.
>=20
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  net/bridge/br_mrp_switchdev.c | 171 +++++++++++++++++++++-------------
>  net/bridge/br_private_mrp.h   |  24 +++--
>  2 files changed, 118 insertions(+), 77 deletions(-)
>=20
> diff --git a/net/bridge/br_mrp_switchdev.c b/net/bridge/br_mrp_switchdev.=
c
> index 3c9a4abcf4ee..cb54b324fa8c 100644
> --- a/net/bridge/br_mrp_switchdev.c
> +++ b/net/bridge/br_mrp_switchdev.c
> @@ -4,6 +4,30 @@
> =20
>  #include "br_private_mrp.h"
> =20
> +static enum br_mrp_hw_support
> +br_mrp_switchdev_port_obj(struct net_bridge *br,
> +			  const struct switchdev_obj *obj, bool add)
> +{
> +	int err;
> +

Looks like you could have added this check here and simplified all the
callers:

	if (!IS_ENABLED(CONFIG_NET_SWITCHDEV))
		return BR_MRP_SW;

> +	if (add)
> +		err =3D switchdev_port_obj_add(br->dev, obj, NULL);
> +	else
> +		err =3D switchdev_port_obj_del(br->dev, obj);
> +
> +	/* In case of success just return and notify the SW that doesn't need
> +	 * to do anything
> +	 */
> +	if (!err)
> +		return BR_MRP_HW;
> +
> +	if (err !=3D -EOPNOTSUPP)
> +		return BR_MRP_NONE;
> +
> +	/* Continue with SW backup */
> +	return BR_MRP_SW;
> +}
> +=
