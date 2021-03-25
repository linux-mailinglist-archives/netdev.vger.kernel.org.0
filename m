Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388AB349253
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 13:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbhCYMpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 08:45:20 -0400
Received: from mail-co1nam11on2044.outbound.protection.outlook.com ([40.107.220.44]:33376
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231211AbhCYMoe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 08:44:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kcp/CSnOniaqRo4H07pk7OvO50hDyT8mVzr9PxyErJonS/A+lS69lnH8fw1ASHKdViWVKYbMyjsLOshAe7MYf+MnGBelCaHqc/WRJUF00Jyp+BP4IjKFjk57UPnLb6R6HJWm2Smmx7WrFih6qdTz0DBtz2Jipu7X8EbzhLxoH4c765UJLBBPqV4x/ovVwnjLQEbfRLZWBQEXtdTaviZMF3+2knWWwlXAzsQpT9rIaYO6m40Mqisx1m55p9PNVHCVOS+QxucSXiPACsEE++UZynw95yqpGqutWn1pj9njZpT/wnBIqMUDrywfM/qbmwZlhhsq8WLLKF+Rv7vAEjLy6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u93jbq47AB9enYx2y1KavyHpsEaz1iWuYqDVzLkmWTg=;
 b=QO6MO5ZkRmWz8VCr4MBVMT0J9jzEOYQtcgwSEW2lQrHJsKpEVsYJo8/LnGYmgtSqYhhNScbSHKTOsX92HJ9u5dqC7W34lkBPeGQeAyfQdg70tHQ5R3/zXjkHIEXKR8P7ttWzB4XHJ8EZG/40A5w+L7cKr/faPSwPymZ1b8HGD1dZDnlWjNQDA1tp1jbewWSnBkM7K62K6ZYJp0mEF4tw24xFfgY4OhPipun+9uxFnt07wKKouBTwZT5ys9Ikh7H9oeLsNkjQ5XUupNe0o5GeH/juhaji/nMX+0wrn0tomvzdRpPNPciQCz5d/A0F62QIOcSNo/373WTgs14mJZpNhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u93jbq47AB9enYx2y1KavyHpsEaz1iWuYqDVzLkmWTg=;
 b=MGDotI2zFwpe47+Mxubfmg2G7DwiotHUgcWIhlWEtmD0kd1Vlu6zXo9pRnX+6dJmuwJlWmlvf6WKjdz5RYdDB7CdDhfL9db/3h4OeiTl9H9zD2dOdw2ykE7sijDC8+gLNAb6W3uU4Nw8IO31I2hL/dosALwidWcEffnNZZuTfCA=
Received: from BY5PR02MB6520.namprd02.prod.outlook.com (2603:10b6:a03:1d3::8)
 by SJ0PR02MB7295.namprd02.prod.outlook.com (2603:10b6:a03:292::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26; Thu, 25 Mar
 2021 12:44:30 +0000
Received: from BY5PR02MB6520.namprd02.prod.outlook.com
 ([fe80::15d:35ca:a307:bbe4]) by BY5PR02MB6520.namprd02.prod.outlook.com
 ([fe80::15d:35ca:a307:bbe4%7]) with mapi id 15.20.3977.024; Thu, 25 Mar 2021
 12:44:30 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Daniel Mack <daniel@zonque.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2] net: axienet: allow setups without MDIO
Thread-Topic: [PATCH v2] net: axienet: allow setups without MDIO
Thread-Index: AQHXIK5rKIaUrur1j0Ol77z1+FOWpqqUp0Sg
Date:   Thu, 25 Mar 2021 12:44:30 +0000
Message-ID: <BY5PR02MB6520E81C2A99992B1008FFA0C7629@BY5PR02MB6520.namprd02.prod.outlook.com>
References: <20210324130536.1663062-1-daniel@zonque.org>
In-Reply-To: <20210324130536.1663062-1-daniel@zonque.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: zonque.org; dkim=none (message not signed)
 header.d=none;zonque.org; dmarc=none action=none header.from=xilinx.com;
x-originating-ip: [157.34.5.227]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c5eaebde-b71f-4563-c26a-08d8ef8bbc1c
x-ms-traffictypediagnostic: SJ0PR02MB7295:
x-microsoft-antispam-prvs: <SJ0PR02MB72951F310C82EBC159C13A8AC7629@SJ0PR02MB7295.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9sucKGsacp6IH9KX1TQCK/4p7fxTaEnOg/EI3PPbhyXDbUCpGr6oenRnjqFxUspfpFW76wGgIMdggcdnJi1INrccLIwfReetnCPKYT8MrnQR+1o5zOWxlqmxk1IFMnPxvSBTrBDragzZ3HLvmWqythL6xidixudJDhBTYCX5MrFr7LxD6XyPYdjRTq3Kr1y/u0YBKarQD/BsuQF0BqWIp78W2qL3tFtwHKV6Q16v4R34S1M+y75Lh9ETxUwFLnMUdyXHM6gPJata3waTci8LPWsImTjF4WGmTmYqGD8ooBsVCzVHwKGJBbwG52OkZm6osRBbfzGobUx7LdbWxlDWzGS62nasyoNtwTaAFTo0hduAfjL37z90p++xcK4KYEJRHL/u2aDAv0JvC1y+oaZ+Ixnf49R6gdWFtsHiP7cukiOk4rsxZj0O806FccIhItsxSFIYu0e0C7l3A+K8N3z1HIQ1kocMaI9qMsw+z95d2RS7pp4y2XPoRMDOK7XaiZc2zs30lv0u57YfdGrRixVxlJToXmP42W2NsEYtDdAuznSfg0MzysjXWieRFonqH/Os5FW5NjCl4fvrDjZnLatq2KbYodOVDNJgp8w2FKfDStB40w14C43sq8qxvDlqofk01qGV/6V3+kZqYCqQYIGSvCEMfmAxqpI1W2lCBUNeJKk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR02MB6520.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(136003)(39860400002)(376002)(8676002)(86362001)(316002)(54906003)(9686003)(38100700001)(71200400001)(76116006)(52536014)(478600001)(66946007)(4326008)(2906002)(64756008)(33656002)(186003)(83380400001)(55016002)(53546011)(5660300002)(8936002)(66476007)(66446008)(26005)(66556008)(7696005)(6916009)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?bMuwVXOVW6HwPfR99WAd17Nrf4tE6relM+BuSZL/tUC3IpRlRxZYzfyZ8kbm?=
 =?us-ascii?Q?oHG7PGA1CEDhL1nVqM5a7aA7Hl/wTYf54RRYjSIGiNzSd5NY7N0nwaAFMHSf?=
 =?us-ascii?Q?fayYhrGrHMH/9xfUjmP8NI9uAC0NV+OBJjMgaeR4oYGLOnqXGoN9I7/o2CDJ?=
 =?us-ascii?Q?ZDvPxsdettajk4yIvo9eGHSLHNBAvjYVUA+oUhjJkyS/AfkWaEh8R6Ol38dq?=
 =?us-ascii?Q?baPdFtSH4RWkjyh8UcYyNu/kWXqoX+6ESizv3ZiFdNHBunruzZnu3cgYsxm9?=
 =?us-ascii?Q?up8d+oAYSNs+tYu6BGnkkwsQGdpzoU98eKSM/FuNhqBISukDr/iomJCaNvtq?=
 =?us-ascii?Q?U7nppheTfGyjccL+TgeDVlA/DKw0/L1ngTmlD0Ri4iU/68On0s8wUM8+qB3x?=
 =?us-ascii?Q?BHB18upBL3tHvzlRIiB0uSCKWL9mCYAz0tHOH0ELkpaMzQXLuNWoKqwflguc?=
 =?us-ascii?Q?s2tpcTnAm5u7M8yxj9/wIsn+jsVuZvo/zvV+8VPY1aTJWcaVjFBYkq3UXV57?=
 =?us-ascii?Q?Xc7axmw0x/VJ8ipVgY5B7UIyrbGZMF6bkQmeKJJlnARXoU4ea9tmKkiySsvJ?=
 =?us-ascii?Q?OU0LpEyYp+Zacjx+Bn3amhUJ6RQj7Mh+ZyimVof6kBfXPlcu5xUVlwBunUKn?=
 =?us-ascii?Q?3Dt8xC6GmhoGJOzAztDXgI+v7U9LSEnFGYkmDpMths7bw27+LPZWFDeGC9PS?=
 =?us-ascii?Q?V+w+K1T6BJywWL9CcobjT+6MOrZc2Nm0PubUpyMGhiXIpQsRdgLQcn7wzsfz?=
 =?us-ascii?Q?ZredlHibKio/Sdo3JWTtmGJELyE9ifi/DGx++Bd3q5F4/ujme7pLB9HLJixu?=
 =?us-ascii?Q?msokT2cCg5WWa3/mVfwyh/kGSVFuf2iuNX33zkhGQQ0TFiyESohgxFLgtLQI?=
 =?us-ascii?Q?AOBrqFiFG84cuO/EQNs3iz6AHWjfdKr1bY4o/6AH0VpljqiWrFI7a9KviwSD?=
 =?us-ascii?Q?rWQjhg5FTI7KEXKypSUIiUmd+H7/o4JpjY1MWWahiveRsa4c59IENP25Qaf6?=
 =?us-ascii?Q?OsqHjAuE8iMTwDPtCPFhZURd5Dy5YW/dUvbt/kYVUYoIRUB4HOMTlIOcXeZ7?=
 =?us-ascii?Q?lMXSOmgnnMcGLDbFGA4alnFK4SI/WNLVPmHGKvk8TzvhQxzhQlWncuhOzayM?=
 =?us-ascii?Q?49sTWE9KGJl4rL8RoMY4iPIU6BP25RqVhFvvcdyaLw9gUwFvHduHS7ytUvHy?=
 =?us-ascii?Q?GYG7AVdiG53+eDfMS21XDVRJdGabqPJOLkhmeqeAQ5Xac1z2H+hty9D07IyW?=
 =?us-ascii?Q?s5i/IGHvddiQjbem/IQGiRGi4Lmz2M/ZpKR0c5YMhwguzLwu3LMrGi2hBvr9?=
 =?us-ascii?Q?+do=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR02MB6520.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5eaebde-b71f-4563-c26a-08d8ef8bbc1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2021 12:44:30.7015
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ImlGqHUe0pJK9qZBRoDjpFUBoeEvOz6Owkdgn4QcVvqZ4vV0d0sp51xVeSxqRck3epaW8+vSggGndmXvslXoWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB7295
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Daniel Mack <daniel@zonque.org>
> Sent: Wednesday, March 24, 2021 6:36 PM
> To: Radhey Shyam Pandey <radheys@xilinx.com>
> Cc: davem@davemloft.net; kuba@kernel.org; netdev@vger.kernel.org;
> Daniel Mack <daniel@zonque.org>
> Subject: [PATCH v2] net: axienet: allow setups without MDIO
>=20
> In setups with fixed-link settings there is no mdio node in DTS.
> axienet_probe() already handles that gracefully but lp->mii_bus is then
> NULL.
>=20
> Fix code that tries to blindly grab the MDIO lock by introducing two help=
er
> functions that make the locking conditional.
>=20
> Signed-off-by: Daniel Mack <daniel@zonque.org>

Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Thanks!
> ---
> v2:
>   * Also fix axienet_dma_err_handler, as pointed out by Andrew Lunn
>=20
>  drivers/net/ethernet/xilinx/xilinx_axienet.h      | 12 ++++++++++++
>  drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 12 ++++++------
>  2 files changed, 18 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h
> b/drivers/net/ethernet/xilinx/xilinx_axienet.h
> index 1e966a39967e5..aca7f82f6791b 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
> @@ -504,6 +504,18 @@ static inline u32 axinet_ior_read_mcr(struct
> axienet_local *lp)
>  	return axienet_ior(lp, XAE_MDIO_MCR_OFFSET);  }
>=20
> +static inline void axienet_lock_mii(struct axienet_local *lp) {
> +	if (lp->mii_bus)
> +		mutex_lock(&lp->mii_bus->mdio_lock);
> +}
> +
> +static inline void axienet_unlock_mii(struct axienet_local *lp) {
> +	if (lp->mii_bus)
> +		mutex_unlock(&lp->mii_bus->mdio_lock);
> +}
> +
>  /**
>   * axienet_iow - Memory mapped Axi Ethernet register write
>   * @lp:         Pointer to axienet local structure
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> index 3a8775e0ca552..61380c6b65b86 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> @@ -1053,9 +1053,9 @@ static int axienet_open(struct net_device *ndev)
>  	 * including the MDIO. MDIO must be disabled before resetting.
>  	 * Hold MDIO bus lock to avoid MDIO accesses during the reset.
>  	 */
> -	mutex_lock(&lp->mii_bus->mdio_lock);
> +	axienet_lock_mii(lp);
>  	ret =3D axienet_device_reset(ndev);
> -	mutex_unlock(&lp->mii_bus->mdio_lock);
> +	axienet_unlock_mii(lp);
>=20
>  	ret =3D phylink_of_phy_connect(lp->phylink, lp->dev->of_node, 0);
>  	if (ret) {
> @@ -1148,9 +1148,9 @@ static int axienet_stop(struct net_device *ndev)
>  	}
>=20
>  	/* Do a reset to ensure DMA is really stopped */
> -	mutex_lock(&lp->mii_bus->mdio_lock);
> +	axienet_lock_mii(lp);
>  	__axienet_device_reset(lp);
> -	mutex_unlock(&lp->mii_bus->mdio_lock);
> +	axienet_unlock_mii(lp);
>=20
>  	cancel_work_sync(&lp->dma_err_task);
>=20
> @@ -1709,9 +1709,9 @@ static void axienet_dma_err_handler(struct
> work_struct *work)
>  	 * including the MDIO. MDIO must be disabled before resetting.
>  	 * Hold MDIO bus lock to avoid MDIO accesses during the reset.
>  	 */
> -	mutex_lock(&lp->mii_bus->mdio_lock);
> +	axienet_lock_mii(lp);
>  	__axienet_device_reset(lp);
> -	mutex_unlock(&lp->mii_bus->mdio_lock);
> +	axienet_unlock_mii(lp);
>=20
>  	for (i =3D 0; i < lp->tx_bd_num; i++) {
>  		cur_p =3D &lp->tx_bd_v[i];
> --
> 2.30.2

