Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 843DE454BB0
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 18:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239159AbhKQROA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 12:14:00 -0500
Received: from mail-eopbgr140072.outbound.protection.outlook.com ([40.107.14.72]:1973
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239286AbhKQRN5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 12:13:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OzxXVF6xdsdH82eITk8K/eXiUr7q2FvATKZKN6PUoNEUo0gNiwNKIK8LlxgwON67IpBCuElKkt9BMQhTMrFddh3QTsZRDzQsHejHRF0HThwwPtoQy/9+C4HFU3UaiLxPVBR9eI8trrfNA8tlsnXB6aQkPjP5ty0LkxNHegXjtuOzkx+nNRpnMAxRscDfmgVjMREhcF33UyyXGFg36Un31XSA5DkHWKyF8QcC9c0kEk9rcq6wgrW78BmQ5iMkcbhBgyjjpGssg8RtWQ7a9+KRuv2uTR+HX7jDnxF3t73GdBZ2FxXDj1TQxGtA0DdRsQuyc97PB4L+1zjzkANJ6HixXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jUcdtSONGd9tp8d+W4pHk5Wp5kFuWkNqDHR+J5PGEdo=;
 b=VCAXkxpoW9z6bFAJl2sfF7D6PIKC6N8VTuTvWBQLx5mJJy+BSadBxgUhscl3VPCO6tYtWXZRaAUWvp47LO18Z5uFd8PUKPF5q0ohxHczBGzw7gfbAImBW77qs6TBGG8MeB0sxDNGNNOjpFkhBI2UT7RbE+zDtZKz0FqsZeTccsXG5ZzPXQ2Rh7rCMgPHj8Sd1ZxoA5IKkI72aItUGMfuvS5w+kJfRfspFZIevsNY+WNOg5ISUiEgVU9av6dj/v/XnPvvv6zolI+M372vERJ4M6pWIZ5+dpTH07k3EbdPU6uYypRICnnJ2OLLdRtfj/d7JTWk60oHAQ/la2jv6LN9XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jUcdtSONGd9tp8d+W4pHk5Wp5kFuWkNqDHR+J5PGEdo=;
 b=Kx+qKGWUShL8kSZLypmQ6sGnwwzPQ24jSHCaLlGSfdNB6v48QObusz7iyAeuF8qwknug6y5o6FQenDYQ8Rcagh+Xz54i47i/c9PWMPcS00/jldyjPxQKDxun0n0bxtOccd83ZSUdBxR9ThWDuo9IoD2F6yr8HUx5uVZOKvH6nqI=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6942.eurprd04.prod.outlook.com (2603:10a6:803:136::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Wed, 17 Nov
 2021 17:10:56 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4669.022; Wed, 17 Nov 2021
 17:10:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mickeyr@marvell.com" <mickeyr@marvell.com>,
        "serhiy.pshyk@plvision.eu" <serhiy.pshyk@plvision.eu>,
        "taras.chornyi@plvision.eu" <taras.chornyi@plvision.eu>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: marvell: prestera: fix brige port operation
Thread-Topic: [PATCH net] net: marvell: prestera: fix brige port operation
Thread-Index: AQHX25fOH/y6p2zJhEGVbWfn0oBDyKwH9PgA
Date:   Wed, 17 Nov 2021 17:10:55 +0000
Message-ID: <20211117171054.cupmcwwi2ruxjxuh@skbuf>
References: <1637142232-19344-1-git-send-email-volodymyr.mytnyk@plvision.eu>
In-Reply-To: <1637142232-19344-1-git-send-email-volodymyr.mytnyk@plvision.eu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 12eb54dc-b00f-4ec0-9b13-08d9a9ed37e7
x-ms-traffictypediagnostic: VI1PR04MB6942:
x-microsoft-antispam-prvs: <VI1PR04MB694298454477CD18A2C17F5DE09A9@VI1PR04MB6942.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LsKffvv8HnlJZYQq0S/A65TgjOQZiazCyyqEMq1YNauPG+nzRJEB2eLRVuVQmWse2IH6yWKCIorBdZjn+zZyrIGgaw4G/aAZXsBBYnYFkfvv5Tqa/AO/tWB4+Boh6wpEAtoez9ZPzIlrrR43AWxXHgl+h4oviOmLIqCn74SUbm0Af+Qu61rhrc/e67VeQ3nhL0rY+65bzgqTifQUdMunv36PXpl9CrCayVBSYbgz+r1k6SKa1R3Hgd+P6eLfc37H9LqxnKwUM6awESbOYS+aUYV3itRBn33u2kqX3fndAdCTmPFkvNxL0WYZEdOat/qA+cV9+sE3Rf/XNiPECW+/fPatViNblYtNN5z8T0FVtDvak1+/773+8W1OVw8zzXvE3SYPWbSdU7jgqRG+iFLbpGttAB+npH4/7w25ZqXxBbCt5ROYf9zyfItnltzm6f5UvYGpCe+MBDK5C4K7lW/uxziBWH3yieIa3jD/IIqF++TDjOBd66jMZtWj+CpsKBCYGtkMhjchecKDtcjkgikSw4gOt8clTtKnJEQqCedx04PA3hvUQo6VLf4tj4gsP3wdzWfB9N/W5asAJ4obdEtMGE81RtCHrDVGL78UqPnAH/lsQR5bJkZW/+9mxoA1+XWiZ1HYYykue6X4cL84HnfSxWT9Rqux/KTE9xt1LIGY0Coc0pe7Y9l9bVXPc2rqSuKK6mBdUUMlor5JuIusU+t9hQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(44832011)(1076003)(6506007)(6512007)(71200400001)(122000001)(7416002)(66946007)(83380400001)(9686003)(4326008)(76116006)(33716001)(66446008)(66556008)(66476007)(64756008)(91956017)(26005)(6916009)(86362001)(6486002)(54906003)(8676002)(38100700002)(5660300002)(186003)(2906002)(38070700005)(45080400002)(8936002)(508600001)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?i1pvWwLvzC6KMWgPKizx0hFeixgw5/AYHKMo3wykVRiqnG8ZdyulCTZa8NAt?=
 =?us-ascii?Q?JsPhpIugmL5dPJuJKyQ5vvqWWOD6MgHoL6esJdzP4chRdLpQCmQUOwjer2uf?=
 =?us-ascii?Q?U/GoXcwvhxgzw7q/++Fc5uLM3DDyYG/2Crnt4XRqtd0NsBwM5kjlT3dAa7N4?=
 =?us-ascii?Q?U6MUrLQO1/OFMftxGGF7139resqNdDXkZZ38qvfuLY62bJK4JjdnyKJgzBLk?=
 =?us-ascii?Q?97l2Eppm4B3NgqXjk2dXghxg0LeWksgzHgK9zHhQ/W8wsSkeM4BOMAYUgPLb?=
 =?us-ascii?Q?rpxm9Pp1jcrY+CDsDKxlM6kkJEHPQI92LN4dS+/vdKR3+f0M2IITYUBR0EmV?=
 =?us-ascii?Q?uFFvYgHTsx6V9+a6wJZ6ClaMqJAqDah4SeG1ocBBxdTDCWcCdoJo0LkTkVIp?=
 =?us-ascii?Q?+TRtZOnENUPYvFV6n4D7U0E2tMHhJyfTg36fB52yKPeb2PYObVYUMh087eXo?=
 =?us-ascii?Q?FlNAQggG3AaftowrtTMgkT8Cj/4ypgPLOxThhg06gj2OIOcSMf35cdZFixE/?=
 =?us-ascii?Q?l6GAR5FpbDmGEFMyUZb2PB0VlnkS/yaaMIXBsyqnWqogtXSOzTgba5N5mmys?=
 =?us-ascii?Q?6BNGKNDYrrRfTdq6pl4DjrN++afGRd0+O34YHy5pFT9nezeSr7CbiXdZ44sn?=
 =?us-ascii?Q?LwV0/4Tr5QLbEFQkELmi7bGLQHsDn+GzufwN4EQoiAd9jvX+fQURKM9T6ROg?=
 =?us-ascii?Q?epahfwOC3r/Lv9jh0gjoaa8KKkJKW06LR7ZqGiSCD0Vp+hDj2SWZfgSxMf8f?=
 =?us-ascii?Q?oHTvBMTY/zFrYSEe/8pPTtllBILZ59hl42AfYRV2myIPuo58dWoBZOGZr/wf?=
 =?us-ascii?Q?tyVop8JlnBFldYwrGysnOZ5QN+O7uvzswbzUPEwOO4uv2VjbH7c9ujbYuiQD?=
 =?us-ascii?Q?T3rUdsBJqvDBUhGovVbp+ufimgdLJcAgE86tb/7oX9fzSvOd6I/gl+aFZo5i?=
 =?us-ascii?Q?1Q2NnHhD2qrAc3LPvJXtZG2e5VehepDxgQFtbjbIDrvw5TNSsBx0iB73skSq?=
 =?us-ascii?Q?31hLMPPwN9qeb/lRPj6rn4CPENZ9x29cG6IbV/lWNZY1oa2LOGQugkNYzaOy?=
 =?us-ascii?Q?LlxpxmyRfDiZbKTkc8HubKgYJoQT+PBEdcXDPjPY/WJ+NdA1i1e1lfLtZKhC?=
 =?us-ascii?Q?17CDFetEP+G42iFTDTpnbP7fjjEagJ9fGZUowdGvEMr5zcyKHR1WcoMfd/Ox?=
 =?us-ascii?Q?3AApSTR+2OQqqya5K3PPg81dT5bzizVBMn2j0R9Oa1RhCI+3ybkTga0IsBI3?=
 =?us-ascii?Q?5tL3zNaqNMEq9HgAlX6AeZqQl0vR4uJm3wPAmUe+LJhUiyCrH2kZjAjlSn1C?=
 =?us-ascii?Q?ZuSPNjOVCuUtJDxOPVidOaP3K1Ko+E8vB6uFqnw20LZtyLY7P94bW2dhuayM?=
 =?us-ascii?Q?k6UdUNRy3GTNHaQu0dw77A1TWYHkJBTfVkMtyv7zR9IbclVTr/ZtFsMCfqfL?=
 =?us-ascii?Q?lutCJM7nk/5wafpvSUaIaTvatV7cyZr8l3EuMDThiI0QnTRXXncQxjVSuooB?=
 =?us-ascii?Q?0v42lU0gQ49q+gGn5+j+UJ2bnX5ClMiVBHJGQGr5CKq65fsLqqwD2S2oBeX9?=
 =?us-ascii?Q?PLr1/MPjHLeG6K6kk1g1g13Bwgh+0sN/6dpSC4oqCYuA4If+zwazg2L5YdJw?=
 =?us-ascii?Q?BWvE54mmURMpk5zaKUGzi7M=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <352BE20F7438A640A431D9AF1FCE3F50@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12eb54dc-b00f-4ec0-9b13-08d9a9ed37e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2021 17:10:55.9045
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UNtjvnoDpI5xGzCIJrBTU55933Aoc7y1yRmjybJl5JxaRryEmKEfBNQwee06f0WQUqvSNJ1MUGfOnHbODLpUyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6942
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 11:43:51AM +0200, Volodymyr Mytnyk wrote:
> From: Volodymyr Mytnyk <vmytnyk@marvell.com>
>=20
> - handle SWITCHDEV_BRPORT_[UN]OFFLOADED events for
>   switchdev_bridge_port_offload to avoid fail return.
> - fix error path handling in prestera_bridge_port_join to
>   fix double free issue (see below).
>=20
> Trace:
>   Internal error: Oops: 96000044 [#1] SMP
>   Modules linked in: prestera_pci prestera uio_pdrv_genirq
>   CPU: 1 PID: 881 Comm: ip Not tainted 5.15.0 #1
>   pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=3D--)
>   pc : prestera_bridge_destroy+0x2c/0xb0 [prestera]
>   lr : prestera_bridge_port_join+0x2cc/0x350 [prestera]
>   sp : ffff800011a1b0f0
>   ...
>   x2 : ffff000109ca6c80 x1 : dead000000000100 x0 : dead000000000122
>    Call trace:
>   prestera_bridge_destroy+0x2c/0xb0 [prestera]
>   prestera_bridge_port_join+0x2cc/0x350 [prestera]
>   prestera_netdev_port_event.constprop.0+0x3c4/0x450 [prestera]
>   prestera_netdev_event_handler+0xf4/0x110 [prestera]
>   raw_notifier_call_chain+0x54/0x80
>   call_netdevice_notifiers_info+0x54/0xa0
>   __netdev_upper_dev_link+0x19c/0x380
>=20
> Fixes: 2f5dc00f7a3e ("net: bridge: switchdev: let drivers inform which br=
idge ports are offloaded")
> Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
> ---
>  drivers/net/ethernet/marvell/prestera/prestera_switchdev.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b=
/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
> index 3ce6ccd0f539..f1bc6699ec8b 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
> @@ -497,8 +497,8 @@ int prestera_bridge_port_join(struct net_device *br_d=
ev,
> =20
>  	br_port =3D prestera_bridge_port_add(bridge, port->dev);
>  	if (IS_ERR(br_port)) {
> -		err =3D PTR_ERR(br_port);
> -		goto err_brport_create;
> +		prestera_bridge_put(bridge);
> +		return PTR_ERR(br_port);
>  	}

Here is how the function looked _before_ my patch:

int prestera_bridge_port_join(struct net_device *br_dev,
			      struct prestera_port *port)
{
	struct prestera_switchdev *swdev =3D port->sw->swdev;
	struct prestera_bridge_port *br_port;
	struct prestera_bridge *bridge;
	int err;

	bridge =3D prestera_bridge_by_dev(swdev, br_dev);
	if (!bridge) {
		bridge =3D prestera_bridge_create(swdev, br_dev);
		if (IS_ERR(bridge))
			return PTR_ERR(bridge);
	}

	br_port =3D prestera_bridge_port_add(bridge, port->dev);
	if (IS_ERR(br_port)) {
		err =3D PTR_ERR(br_port);
		goto err_brport_create;
	}

	if (bridge->vlan_enabled)
		return 0;

	err =3D prestera_bridge_1d_port_join(br_port);
	if (err)
		goto err_port_join;

	return 0;

err_port_join:
	prestera_bridge_port_put(br_port);
err_brport_create:
	prestera_bridge_put(bridge);
	return err;
}

The double free is due to the fact that prestera_bridge_port_put() calls
prestera_bridge_put() by itself too.

But the code was already buggy, for example the error path of
prestera_bridge_1d_port_join() would trigger this double free as well.
The change itself is ok (but is very poorly explained), if
prestera_bridge_port_add() fails, you want to undo just
prestera_bridge_create(), otherwise, prestera_bridge_port_put() will
undo both prestera_bridge_port_add() and prestera_bridge_create().

So the honest Fixes: tag should be:

Fixes: e1189d9a5fbe ("net: marvell: prestera: Add Switchdev driver implemen=
tation")

because you want this change to be backported even to stable kernels
where commit 2f5dc00f7a3e ("net: bridge: switchdev: let drivers inform
which bridge ports are offloaded") is not present.

> =20
>  	err =3D switchdev_bridge_port_offload(br_port->dev, port->dev, NULL,
> @@ -519,8 +519,6 @@ int prestera_bridge_port_join(struct net_device *br_d=
ev,
>  	switchdev_bridge_port_unoffload(br_port->dev, NULL, NULL, NULL);
>  err_switchdev_offload:
>  	prestera_bridge_port_put(br_port);
> -err_brport_create:
> -	prestera_bridge_put(bridge);
>  	return err;
>  }
> =20
> @@ -1123,6 +1121,9 @@ static int prestera_switchdev_blk_event(struct noti=
fier_block *unused,
>  						     prestera_netdev_check,
>  						     prestera_port_obj_attr_set);
>  		break;
> +	case SWITCHDEV_BRPORT_OFFLOADED:
> +	case SWITCHDEV_BRPORT_UNOFFLOADED:
> +		return NOTIFY_DONE;
>  	default:
>  		err =3D -EOPNOTSUPP;

May I suggest that the root cause of the problem is that you're
returning -EOPNOTSUPP here? The switchdev events may just as well not be
destined for your prestera switch. You should return NOTIFY_DONE ("don't
care") for event types you don't know how to handle.

And technically, this part of the patch should have:
Fixes: 957e2235e526 ("net: make switchdev_bridge_port_{,unoffload} loosely =
coupled with the bridge")

>  	}
> --=20
> 2.7.4
>=
