Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 312BA495296
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 17:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377092AbiATQsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 11:48:36 -0500
Received: from mail-eopbgr60063.outbound.protection.outlook.com ([40.107.6.63]:5863
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233174AbiATQsf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jan 2022 11:48:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OAyyYryUltd5Qc4e9aOG2ZFayF4k0NTmfagt6z265Z60M/ukysw7vzdUw85wOCTgsj1Lus8YelCwgzn3Xr+5UcC32aNC8C3md6fTuJacaWBdRLDVzCKumA9b0dS3QPl4Z2ds7lYzj7i9emVWnaLj3AvaN04pTgnxsvksMiuyR84KvjRy5hJix3oJATNbOa7RIPVPBRbOE8xrpdIUeiZUhGcgiXEqsGHbT98c8OapQWV6+TlbDBSXmfNdjdmjX5x7PYks/PoTc7n8wZH120udEf79GkjNskXEUq/DgWWpbEaV2APBJ0cfrV/Um2VyQvy0OT24spbbbXkh09BhmBGsmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tavg80Oyn7C3mO+4698p87eB6Aw0RL5Nc4Q9+KvNn8M=;
 b=InhK+qkHnVMjj9Opqkuo7uOcQ6kO3C4JL/ZylqLTLCsnC2Qvn+2UxnT0wf4FgHNqsSjk0TeFCAAhhsqrxRzu5cNJucq4Cxx2lHJEyv4gieZu1efTCyGXWaioitJr5XUfPu77/QXwDw8XGzUkvHh/Re287K9Ys+m1JYrQIGvyQQjnYMbyRjIfZBCM2dLIyKZ839D0oR+CpzZ6URRz8wMO43IVjsNQbbqvn+gXQXU9tUbSFCjJVd+w/dp1ORVZA8006unfJ0Bs5obeRbXBTRCYTIMnleek1Y0AJsystSkaFlcij5QPgFwRJTrHSXGD+zy6sJDmp25zQvewfJ97iAmQbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tavg80Oyn7C3mO+4698p87eB6Aw0RL5Nc4Q9+KvNn8M=;
 b=crfdPArgryFeCo9apPzIdH1ZLQHAt9hjYE8fMSpucKy8iHOoMwy/HxrLI+RdR8biBDzRQ/7yt7lS2zGneEaXvJexlrryNFeui+hlPUjKGOMmsJIg4yI0OAGnp5gNKc4zWLheP0+OF5bxErNKU9usCW0it+XcEsII0Q7mQ+dsMlQ=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by GV1PR04MB9134.eurprd04.prod.outlook.com (2603:10a6:150:25::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Thu, 20 Jan
 2022 16:48:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4909.010; Thu, 20 Jan 2022
 16:48:32 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        David Miller <davem@davemloft.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH RFC V1 net-next 3/4] net: Let the active time stamping
 layer be selectable.
Thread-Topic: [PATCH RFC V1 net-next 3/4] net: Let the active time stamping
 layer be selectable.
Thread-Index: AQHYAPlHUZ7+aaeSVU6jmUK14JiGzaxsOSsA
Date:   Thu, 20 Jan 2022 16:48:32 +0000
Message-ID: <20220120164832.xdebp5vykib6h6dp@skbuf>
References: <20220103232555.19791-4-richardcochran@gmail.com>
In-Reply-To: <20220103232555.19791-4-richardcochran@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 426fdac6-6099-4f82-50d4-08d9dc34b1ce
x-ms-traffictypediagnostic: GV1PR04MB9134:EE_
x-microsoft-antispam-prvs: <GV1PR04MB9134846F6D183DE566A4DC89E05A9@GV1PR04MB9134.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5LNerwuw5f1ZtORTKhWOfbHUznLcLd2LUcXPvscCcMdSLs88i8IJSIsH2vwlw/Hb70nWUwV6OTAK0IVs1XulQ+YQoMu3RazFjtz3R7G3wiAEH6f8h+tvWJtFZeYh0yrgteQrVa3BImZKEHmiTXRVQeapleuExnr3fqEucJafrP6UWoeig4cISjHX9akwpJIExng5rVgf+wQpJKOMQWS+2HIzj+Ao3/RZzHTZasXazT/9SmbQGKExhpbExzg7MUiu+x/qwz43LhzGBbeqOYM8+DnG/4aRy3SPKIsjX7rN3pZXk/f8jyVLwLnz2qP0a998lwXCOjT/gspuLCsFbZCFyaSfdzMZmU3SUQnQVytt6MgPyalk45IOQGnJFKtJDGagX9KumWm3uge43AHUxlsVYldSyu4iewTg6DKnI4pzPC3qui6GR/5Fon3xv3oLO/qjJIkRm7rks76B+FuUpTPYS4I8wht8QBwa6SfSsoQur5rJVpIa331egqIVukZ7JOsyxbMTqMsynhzpajLzZ/4S4KGNKgQHHLqtBNNgtX1w7UmFhxH9ioH+gdazxGYrfiOKnegUP18Y4+P346mYeE7+V0ryCIr8RaNZjihPWUb63roZxMxnP2oFCIDDhN4J7BHObksmiIm72KNlry8X3ABPEwUn3lZifrMXFnxFYs4ZFh4I6UP0ep4aG6GIS4ZztZF8yUIAazxTfUbvS0zXuoH+ig==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(6506007)(86362001)(186003)(54906003)(316002)(5660300002)(6486002)(26005)(6512007)(9686003)(44832011)(71200400001)(508600001)(8676002)(1076003)(6916009)(8936002)(2906002)(38070700005)(33716001)(38100700002)(122000001)(4326008)(76116006)(83380400001)(66946007)(7416002)(66446008)(64756008)(66556008)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WZ+lByO9y6rXW4C/Oq2xSDuJr+eNxVC8LTtuju+d3TP6bNNv3V60XQrUyzgo?=
 =?us-ascii?Q?EoevSTbPJeexkmAuM2cY7R6WWWVUCNZ87Z8ybk9un2KASjQRFmPdWHTHkdON?=
 =?us-ascii?Q?qQITUFfwD3NoRghZSoxt+VRGjwRi1DYW9ZdNaRwU9bWMmV5VIEvtb8LjcSxG?=
 =?us-ascii?Q?iYZ29jABRMPEW4Pn1saFjakVhqufSFhRFB5yibrWzGsV5ZLaSD24Y3bUHnm2?=
 =?us-ascii?Q?wHYabOw+ntSC6tFdMLmzEGDh7OnJ25vX59YQdL54bUXSFWs48CEg5hLFEYrd?=
 =?us-ascii?Q?/NnlQXvCCPPtkvTNuONcW/pa355L1kwhgnsrHfoMNgG7D8JDD1zsDbNuVKz7?=
 =?us-ascii?Q?9njbj3JPlyVQ23TIezJ5fQ7r1PixjVWT+DWaD+V29GOvnY1L3cYa3ySB1UfS?=
 =?us-ascii?Q?TUIOt3Q6qRCp8NgWclNLb0pE2nKM3f+dMmZoFRnSEIz8T+CU2GKPw6erThJ7?=
 =?us-ascii?Q?ofxPG+sfV6EW7Efdu857straIuflQqyLu/LPjYFhIjFQjgHIHMAg97M3Cl5/?=
 =?us-ascii?Q?TA6IfkpglQTNzeT7DYLDb2stsTllENdlfiPEt14OgMH6S88ySMq35pbG0wln?=
 =?us-ascii?Q?j4o4HBN5E4HKYKK4iA2eTwOctmI8Du4Gao6S3GBMvL+77DdHQ45dCq3YbV/6?=
 =?us-ascii?Q?xxw5hQbokePnJ3b88Wlsjo9mKmHiZ9JDqFlNqCMEPmwNty4bBaNV/ulBo4IN?=
 =?us-ascii?Q?nDjwic6+RPwgZZQEXBS1nKEnbGn8Ps2Cd5+PUvZ/uOiLQB2K1s8EHGC+D35W?=
 =?us-ascii?Q?MZcp6upXJDVIiOHGqSDgj0326nIqu1QKlzy0D/aLl/H9LzlsNhKWQ/jGf4lY?=
 =?us-ascii?Q?gxQwx/3Thmxe3+IFsR34gH5mnmNlGZQvZLuYQA8iIb5mHC7belIqxLM5H/Q8?=
 =?us-ascii?Q?QIXwgCOgr2bueofTdNahSl7fuBcsDHysCdQ17C7bQTf0fhDPe+jWYtxeOMok?=
 =?us-ascii?Q?AfJuprmz90JfRGowQJ0J8dkyVJHI+zHBtbb1+rc9lpfujYMYtahczIZWlfmd?=
 =?us-ascii?Q?bXHB3ppg0roCPgjDzTsCe5CtV9V7/sIZZP7YGZwdsDZdeS18YUQIgy+3+FV0?=
 =?us-ascii?Q?O7KNpyjSqY+kN5+IEuDBGDOj9n2r4UJ5xNES32Zt8Kee7r9rqOW0sIwLwyU3?=
 =?us-ascii?Q?4xKAKmFp0RveL+LOzN8lg3UQHrOFkNP/gef6EG/+m0+J33/e6HioSevuiceI?=
 =?us-ascii?Q?AE7SBRFFhX7QQP8iaHgAsayNcZPDXAONXcAMm0WL8t19rCR3CT3GFXizUnut?=
 =?us-ascii?Q?MlxCBDWjzLDCbvnBLhPFB6pOYotwnrBRgZFFgU6yYno1GQq7okM3iJomWPVn?=
 =?us-ascii?Q?ig9CPRf/cXLbQ+jyIzUDE2HTtankcfGUuCEZejw5D8RkU3haV/NjmT9TSG/I?=
 =?us-ascii?Q?aN8spTBtX+cJwEfFoelIBncWyqClxcDrtvqVNpiY/RDAnHldgB/kwplSCuD8?=
 =?us-ascii?Q?NEGVcPI1S+74kjWiLHArqz3dA97CpY7bJwtOGNSnvBqwpPjkO3sMZrBnohEf?=
 =?us-ascii?Q?AGlFOGXi8jdVkY/gP+MNU8+msXUlgUT+diiNWdiF9wmRWlCIvF0KTw3EwvPq?=
 =?us-ascii?Q?DKZf90XpBsd6hi6hr8Q0wg6R+zUuFxOBMFD4QLyUHycUdjp3iIjmFwdDSCqR?=
 =?us-ascii?Q?fXKisLd9jhOWIQT+LnQXsWA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EB6E35F45CAAE4419B2498D87F91C661@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 426fdac6-6099-4f82-50d4-08d9dc34b1ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2022 16:48:32.7884
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ja9d/TTZbdlmVyb0s9qm2iHIL+2DUEFghM2jo4k42MSPyjmkBtDHNRxCcXDRZPI2L2rnBBGe6C74XbpfLMT+Vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9134
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Richard,

On Mon, Jan 03, 2022 at 03:25:54PM -0800, Richard Cochran wrote:
> Make the sysfs knob writable, and add checks in the ioctl and time
> stamping paths to respect the currently selected time stamping layer.
>=20
> Signed-off-by: Richard Cochran <richardcochran@gmail.com>
> ---

Could we think of a more flexible solution? Your proposal would not
allow a packet to have multiple hwtstamps, and maybe that would be
interesting for some use cases (hardware testing, mostly).
The problem with that, really, is that user space doesn't know which PHC
is a hardware timestamp coming from - this info isn't present in the
struct scm_timestamping presented in the SOL_SOCKET/SCM_TIMESTAMPING
cmsg.

This is also the reason why DSA denies PTP timestamping on the master
interface, although there isn't any physical reason to do that. For the
same reason mentioned earlier, it would be nice to see hwtstamps for a
packet as it traverses DSA master -> DSA switch port -> PHY attached to
DSA switch.

With a new SO_TIMESTAMPING API (say, SOF_TIMESTAMPING_SELECT_PHC |
SOF_TIMESTAMPING_PHY, plus a new SCM_TIMESTAMP_PHC enum that would also
contain the PHC index), we could make this a per-socket option. Kernel
keeps track of whether any socket requests PHY timestamping, and
enables/disables PHY timestamping as needed. Your patch replays a call
to ops->ndo_eth_ioctl() from current_timestamping_provider_store()
anyway (I mean creates a call from outside its intended calling context),
we'd need similar logic to call that function from sock_set_timestamping()
or thereabouts.

Do you consider this a valid use case? Different approaches for
different needs, I suppose. I guess what you want to achieve is for
ptp4l to not really care who is the timestamp provider.

>  .../ABI/testing/sysfs-class-net-timestamping  |  5 +-
>  net/core/dev_ioctl.c                          | 44 ++++++++++++++--
>  net/core/net-sysfs.c                          | 50 +++++++++++++++++--
>  net/core/timestamping.c                       |  6 +++
>  net/ethtool/common.c                          | 18 +++++--
>  5 files changed, 111 insertions(+), 12 deletions(-)
>=20
> diff --git a/Documentation/ABI/testing/sysfs-class-net-timestamping b/Doc=
umentation/ABI/testing/sysfs-class-net-timestamping
> index 529c3a6eb607..6dfd59740cad 100644
> --- a/Documentation/ABI/testing/sysfs-class-net-timestamping
> +++ b/Documentation/ABI/testing/sysfs-class-net-timestamping
> @@ -11,7 +11,10 @@ What:		/sys/class/net/<iface>/current_timestamping_pro=
vider
>  Date:		January 2022
>  Contact:	Richard Cochran <richardcochran@gmail.com>
>  Description:
> -		Show the current SO_TIMESTAMPING provider.
> +		Shows or sets the current SO_TIMESTAMPING provider.
> +		When changing the value, some packets in the kernel
> +		networking stack may still be delivered with time
> +		stamps from the previous provider.
>  		The possible values are:
>  		- "mac"  The MAC provides time stamping.
>  		- "phy"  The PHY or MII device provides time stamping.
> diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
> index 1b807d119da5..269068ce3a51 100644
> --- a/net/core/dev_ioctl.c
> +++ b/net/core/dev_ioctl.c
> @@ -260,6 +260,43 @@ static int dev_eth_ioctl(struct net_device *dev,
>  	return err;
>  }
> =20
> +static int dev_hwtstamp_ioctl(struct net_device *dev,
> +			      struct ifreq *ifr, unsigned int cmd)
> +{
> +	const struct net_device_ops *ops =3D dev->netdev_ops;
> +	int err;
> +
> +	err =3D dsa_ndo_eth_ioctl(dev, ifr, cmd);
> +	if (err =3D=3D 0 || err !=3D -EOPNOTSUPP)
> +		return err;
> +
> +	if (!netif_device_present(dev))
> +		return -ENODEV;
> +
> +	switch (dev->selected_timestamping_layer) {
> +
> +	case MAC_TIMESTAMPING:
> +		if (ops->ndo_do_ioctl =3D=3D phy_do_ioctl) {
> +			/* Some drivers set .ndo_do_ioctl to phy_do_ioctl. */
> +			err =3D -EOPNOTSUPP;
> +		} else {
> +			err =3D ops->ndo_eth_ioctl(dev, ifr, cmd);
> +		}
> +		break;
> +
> +	case PHY_TIMESTAMPING:
> +		if (phy_has_hwtstamp(dev->phydev)) {
> +			err =3D phy_mii_ioctl(dev->phydev, ifr, cmd);
> +		} else {
> +			err =3D -ENODEV;
> +			WARN_ON(1);
> +		}
> +		break;
> +	}
> +
> +	return err;
> +}
> +
>  static int dev_siocbond(struct net_device *dev,
>  			struct ifreq *ifr, unsigned int cmd)
>  {
> @@ -395,6 +432,9 @@ static int dev_ifsioc(struct net *net, struct ifreq *=
ifr, void __user *data,
>  			return err;
>  		fallthrough;
> =20
> +	case SIOCGHWTSTAMP:
> +		return dev_hwtstamp_ioctl(dev, ifr, cmd);
> +
>  	/*
>  	 *	Unknown or private ioctl
>  	 */
> @@ -405,9 +445,7 @@ static int dev_ifsioc(struct net *net, struct ifreq *=
ifr, void __user *data,
> =20
>  		if (cmd =3D=3D SIOCGMIIPHY ||
>  		    cmd =3D=3D SIOCGMIIREG ||
> -		    cmd =3D=3D SIOCSMIIREG ||
> -		    cmd =3D=3D SIOCSHWTSTAMP ||
> -		    cmd =3D=3D SIOCGHWTSTAMP) {
> +		    cmd =3D=3D SIOCSMIIREG) {
>  			err =3D dev_eth_ioctl(dev, ifr, cmd);
>  		} else if (cmd =3D=3D SIOCBONDENSLAVE ||
>  		    cmd =3D=3D SIOCBONDRELEASE ||
> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> index 4ff7ef417c38..c27f01a1a285 100644
> --- a/net/core/net-sysfs.c
> +++ b/net/core/net-sysfs.c
> @@ -664,17 +664,59 @@ static ssize_t current_timestamping_provider_show(s=
truct device *dev,
>  	if (!rtnl_trylock())
>  		return restart_syscall();
> =20
> -	if (phy_has_tsinfo(phydev)) {
> -		ret =3D sprintf(buf, "%s\n", "phy");
> -	} else {
> +	switch (netdev->selected_timestamping_layer) {
> +	case MAC_TIMESTAMPING:
>  		ret =3D sprintf(buf, "%s\n", "mac");
> +		break;
> +	case PHY_TIMESTAMPING:
> +		ret =3D sprintf(buf, "%s\n", "phy");
> +		break;
>  	}
> =20
>  	rtnl_unlock();
> =20
>  	return ret;
>  }
> -static DEVICE_ATTR_RO(current_timestamping_provider);
> +
> +static ssize_t current_timestamping_provider_store(struct device *dev,
> +						   struct device_attribute *attr,
> +						   const char *buf, size_t len)
> +{
> +	struct net_device *netdev =3D to_net_dev(dev);
> +	struct net *net =3D dev_net(netdev);
> +	enum timestamping_layer flavor;
> +
> +	if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
> +		return -EPERM;
> +
> +	if (!strcmp(buf, "mac\n"))
> +		flavor =3D MAC_TIMESTAMPING;
> +	else if (!strcmp(buf, "phy\n"))
> +		flavor =3D PHY_TIMESTAMPING;

Shouldn't we use sysfs_streq()?

> +	else
> +		return -EINVAL;
> +
> +	if (!rtnl_trylock())
> +		return restart_syscall();
> +
> +	if (!dev_isalive(netdev))
> +		goto out;
> +
> +	if (netdev->selected_timestamping_layer !=3D flavor) {
> +		const struct net_device_ops *ops =3D netdev->netdev_ops;
> +		struct ifreq ifr =3D {0};
> +
> +		/* Disable time stamping in the current layer. */
> +		if (netif_device_present(netdev) && ops->ndo_eth_ioctl)
> +			ops->ndo_eth_ioctl(netdev, &ifr, SIOCSHWTSTAMP);
> +
> +		netdev->selected_timestamping_layer =3D flavor;

I'm unclear about this. If MAC timestamping was previously enabled on
the interface, ptp4l is running, and the admin surprise-changes it to
PHY, this will not enable PHY timestamping, will it? So the ptp4l
application must be restarted.

If I'm correct about this, then it would be cleaner to use the
setsockopt interface, since the kernel would have a better way of not
changing stuff from under existing processes' feet.

> +	}
> +out:
> +	rtnl_unlock();
> +	return len;
> +}
> +static DEVICE_ATTR_RW(current_timestamping_provider);
> =20
>  static struct attribute *net_class_attrs[] __ro_after_init =3D {
>  	&dev_attr_netdev_group.attr,
> diff --git a/net/core/timestamping.c b/net/core/timestamping.c
> index 04840697fe79..31c3142787b7 100644
> --- a/net/core/timestamping.c
> +++ b/net/core/timestamping.c
> @@ -28,6 +28,9 @@ void skb_clone_tx_timestamp(struct sk_buff *skb)
>  	if (!skb->sk)
>  		return;
> =20
> +	if (skb->dev->selected_timestamping_layer !=3D PHY_TIMESTAMPING)
> +		return;
> +
>  	type =3D classify(skb);
>  	if (type =3D=3D PTP_CLASS_NONE)
>  		return;
> @@ -50,6 +53,9 @@ bool skb_defer_rx_timestamp(struct sk_buff *skb)
>  	if (!skb->dev || !skb->dev->phydev || !skb->dev->phydev->mii_ts)
>  		return false;
> =20
> +	if (skb->dev->selected_timestamping_layer !=3D PHY_TIMESTAMPING)
> +		return false;
> +
>  	if (skb_headroom(skb) < ETH_HLEN)
>  		return false;
> =20
> diff --git a/net/ethtool/common.c b/net/ethtool/common.c
> index 651d18eef589..7b50820c1d1d 100644
> --- a/net/ethtool/common.c
> +++ b/net/ethtool/common.c
> @@ -545,10 +545,20 @@ int __ethtool_get_ts_info(struct net_device *dev, s=
truct ethtool_ts_info *info)
>  	memset(info, 0, sizeof(*info));
>  	info->cmd =3D ETHTOOL_GET_TS_INFO;
> =20
> -	if (phy_has_tsinfo(phydev))
> -		return phy_ts_info(phydev, info);
> -	if (ops->get_ts_info)
> -		return ops->get_ts_info(dev, info);
> +	switch (dev->selected_timestamping_layer) {
> +
> +	case MAC_TIMESTAMPING:
> +		if (ops->get_ts_info)
> +			return ops->get_ts_info(dev, info);
> +		break;
> +
> +	case PHY_TIMESTAMPING:
> +		if (phy_has_tsinfo(phydev)) {
> +			return phy_ts_info(phydev, info);
> +		}
> +		WARN_ON(1);
> +		return -ENODEV;
> +	}
> =20
>  	info->so_timestamping =3D SOF_TIMESTAMPING_RX_SOFTWARE |
>  				SOF_TIMESTAMPING_SOFTWARE;
> --=20
> 2.20.1
>=
