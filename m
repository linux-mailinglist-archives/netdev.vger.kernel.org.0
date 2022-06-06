Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3FD53E0D7
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 08:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbiFFF21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 01:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbiFFF2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 01:28:20 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2078.outbound.protection.outlook.com [40.107.93.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A4A3140400;
        Sun,  5 Jun 2022 22:11:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LhAbFWYWEl5kG20pVX20tMTjHSheYVsW+cH5EGBANqHmLxHZAKWd3Dhv9HhQUY3eLmTHE0fY+uyYTuKYlngSQwVUpjrXcN67mu10VDXUgG+g33y3Zgz8kBB8cBmXJT/Vte+29eXdjV527hPeINEXrAmC3M+b2DOR1PVwJW4feoxvbKvBmjiw1saC6NyNFB8xL60gfiFbWTenHAfE1ewBwPLmfJmMnjTFWkSiQ1anNKGTbXJ2ans2gh/9hNkwb3rwXbn7njg9k6lilAaSTAAVuVQvA1GpLLlGA+eB4PH/sVS+eyG5yDXcRQRdWE2FB1Yw9t6yrhp/B2WkCz+Ohf9ZYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NnK+oRRD98ytlgpWam8z7ziymujypU9puXgSNK4MZdc=;
 b=T3SjKJmi4FIbcEX5mFtHWjuE5if/roOh0BHOY8BAWbTtGmj23xRuwVXUjYcCmPxa3pjNnLLUCzpHQW7FnEU5NlTX7Y4zaA52TYdkNmpOZBUnIPNG6X8mR0GGeqld5UHR0J0+IYBYx7l4CYdhM9LdMyL2g3EqbwznfZcMwSs9L4e4gAiA/+H0Gm/lJcl6IsBjkBCP4OfQ4RvQMQcuUhwuTZaYaHVGUt9MHp5078fMMkHHFcy/zfgJQnCqmDpM6hyIpq2bBb+5McAIOF5Z1LRQ2OmOjPWYWkDpNIXlfIsqSXZvkgvze6gNYV9r8W8/VGSu3udQejmnI3Q/05m/xsyD1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NnK+oRRD98ytlgpWam8z7ziymujypU9puXgSNK4MZdc=;
 b=V79QDlAlL5Pq9FQy2njw3iQLGstc+OSAFz408O3/iA2DRCjMQXaj4cWhzNv80PXAvoNuZVHweR8zTZkpuuARbWVI+k49qxshsdqLyFk5ZLv/IlwtWcaWG+1MbYB5xDabz4xRjWVqzcoOZltUUoMQ45UuNf4gbfxMAlvh80wQptWQA9zQuG4h8n9+lLXsQ3oBnzlOHo8FxY3YvoqBmMFBto8ciwi5cQracpvGA43V/cwAPkwQhRU/fWHVTCcFLgaA7eevqCc+b8EqEwIr1VqP75XlSxzj2ejTvfxYmIRdhurZ4MaXqe340BXGcZPOErTCATNGtTy88Ngs9b1q/2zSQw==
Received: from DM8PR12MB5400.namprd12.prod.outlook.com (2603:10b6:8:3b::12) by
 BYAPR12MB3173.namprd12.prod.outlook.com (2603:10b6:a03:13d::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.14; Mon, 6 Jun
 2022 05:11:43 +0000
Received: from DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::a196:bbcc:de9d:50a5]) by DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::a196:bbcc:de9d:50a5%9]) with mapi id 15.20.5314.019; Mon, 6 Jun 2022
 05:11:43 +0000
From:   Eli Cohen <elic@nvidia.com>
To:     Gautam Dawar <gautam.dawar@amd.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linux-net-drivers@amd.com" <linux-net-drivers@amd.com>,
        "hanand@amd.com" <hanand@amd.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Parav Pandit <parav@nvidia.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] vdpa: allow vdpa dev_del management operation to return
 failure
Thread-Topic: [PATCH] vdpa: allow vdpa dev_del management operation to return
 failure
Thread-Index: AQHYdzWCnESnrLqGvkeDzLWpq6Csqa1B2KWQ
Date:   Mon, 6 Jun 2022 05:11:43 +0000
Message-ID: <DM8PR12MB540082219FBD835F40AB999AABA29@DM8PR12MB5400.namprd12.prod.outlook.com>
References: <20220603103356.26564-1-gautam.dawar@amd.com>
In-Reply-To: <20220603103356.26564-1-gautam.dawar@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4992769d-aa41-4cc4-ac73-08da477b0c3e
x-ms-traffictypediagnostic: BYAPR12MB3173:EE_
x-microsoft-antispam-prvs: <BYAPR12MB31738AEC918A84EFDF4284D1ABA29@BYAPR12MB3173.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aexQOoD/Nm8CcuQiBcKA8w7HoBo6RWlk7ab7Th6mKKu6yUr91O5WrsLGpyuQikQGlqlwCKs/McmCtkjlMO4rCh1gp0F/VIWy82Jo1px8hNDwzOvqoa0n3ImozNw7xhSGQae1t1FTgXEdwpgkiSfN+fGsAPoYD8ckPAyLcOd1GtVdQwC27pcBZcCz5sTk7QVztFf7ggGQ4aQM6bOlFHkwFf7KOcdgv5GwP2333DDQ4/mhz9AWf8cP15br8HgmlL8M30bNkGKgEPJQbFfDS7X1U03YLwgeepEUneijg9dDP6vZnEHkb998cZ1yhhA3VrSUmCGfyosysSquwoTBOHhsyUL9FQom6zhH0h4rqaoEy86IcPsLWdRdgbDkZlcfcEhz5HRTtvftLAZFcAtdNpzVZ8EOXOHKfwXSAR9HaVm2ICJVYf533eJA8GPTWG3zz9jccfkUcrjzSU91LqqByo4fCtj1TY3VsY/lHSsYrQkV9IusepGd1fLCeyT1hynlOgUbLwTnqMfbj385rgmtblLL5n+xCK86E2biSnM7xCH72duBqHtamXgdht6O2sqmb/sY1FV8vk052yfl9CjZgypHVsh4u6sYpzmWTY+b2dp3f3tJZ097cTedqmh4RggWDGty8ofggVUK3+hvkXuBa2plMV6uN0ddeuOiDRydcEtNMFzAqmBciulWa9QN8ZVrQksh8W1JA/GEmxJiwPfDywGoBw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5400.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(52536014)(4326008)(38070700005)(122000001)(33656002)(316002)(8676002)(66446008)(86362001)(7416002)(64756008)(5660300002)(2906002)(66556008)(76116006)(110136005)(8936002)(66476007)(66946007)(26005)(9686003)(186003)(508600001)(55016003)(7696005)(53546011)(38100700002)(54906003)(83380400001)(6506007)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bOSZrmpwWx8IFLJocNMTnDsP/fcDC87AXGjMN8I6jNnJLAxHvT5oP8oQ/Mqq?=
 =?us-ascii?Q?vC9ZX5cRyiM58PGIGEmycRb5QLJaUb3ENwb1iXk+mC5UraMziMJ+oorz/8jS?=
 =?us-ascii?Q?T2rbWXy+8CVuNoL7RZWa3sHdxOV6phScI4YLOzcsbcqdMmfwoCw1tKFGJw0b?=
 =?us-ascii?Q?k/pFPrigalW85ikOo0IHYk+G4ovmg+PZFa/WjitdT4anBageV3h/VumBx00Z?=
 =?us-ascii?Q?7j+can+GPq9Iz5z5e0Gy18qjyaEtY+q0o1DZ6jUATTCw2PztsJ6Zo0OSQEwa?=
 =?us-ascii?Q?7fSDw1CgoiHnoRYh2usHJE2XZOGRMiDofPoP9ICZaHPiFLK1iEM4gBYMWrU0?=
 =?us-ascii?Q?WcQ6jVgiYXboKackeGm2ecEHYLepWYVIXD7skG2gwkezanfR7VkchJr29HjN?=
 =?us-ascii?Q?MGpI35SEbl0muWw2iiFMRQOxYZKtVyFTuxtd285FUS5ULQ91U56gDdJ10ZLb?=
 =?us-ascii?Q?647x7GwfoP2EE2UQhfcjkUjp1BTOkS/6ZK1ej7+eoGcFMmrZpcEgQWKqBtSi?=
 =?us-ascii?Q?UCXOj8V0hZjPzdzhPYhce2ret59+s0RozN8M8Zsala6VAby20+RetNEwevMc?=
 =?us-ascii?Q?Anc5fEFIYpSiMqxBPTIDaHQXXDyCC5defoTsuWg1rEZ3S80IQ4NO+hVG4NNQ?=
 =?us-ascii?Q?9oCErREw6ts73fw4U5xnk+74H3RjyxRHhfGnRjp0ls3/DxBoW6jRfqswgpiH?=
 =?us-ascii?Q?Ix5ODwHC3DWFilzSUA2j3IXP0g5faGje4/CbKVURDF4c2l1UdeC5z14sxiEh?=
 =?us-ascii?Q?qkgT+XOckNalazC0o88XDsZFDl54h3qN09UIDlDMJ+C3vYpuziku7X4TCHqS?=
 =?us-ascii?Q?/mDFN9XKVCX+H4QuiDTeDUOlXtN3H8vQtt/GM1jQDROuuPg5k/2LEQBGUusv?=
 =?us-ascii?Q?tvQcAaA9aOhGhf/IgjjnFAzSkqe7I6kzdFdoOl9rC6IpnGYZVSlhl55KkHAC?=
 =?us-ascii?Q?8ndSPGdLRglmm9dljSZVw65EfFWYL8MFwmfhRcrPdBE0ZRSsgJtKFznKxIul?=
 =?us-ascii?Q?msNvXgOZgw6LfbVxW1RrsTrX8uzuSKATqyLuTzlUuDPqX9jmtOFn7nlxacxD?=
 =?us-ascii?Q?bmlOdstDqNhkc25glzfG2rWcoy1j7NelUPtCNIYJXKVloGkJGVIvZeghyfBM?=
 =?us-ascii?Q?X95qb6OKtAZJkol9sC7drT9P2R/2KKKXNWR60sFh4kfTrfJ4RRmXmbP9MOtB?=
 =?us-ascii?Q?IAdKuLGPd0YXLk6bivOoY4e/tCuoHbkxL7rldMaJ6gJMLCxa47MjtkwnFjCH?=
 =?us-ascii?Q?SDaBCvSjx9hlmFO7cjNy3dMU/2t6pq7xhMYRZoZZr2mHiCOnoZ/abrKsgP/z?=
 =?us-ascii?Q?8xzTkDil0cihJRXy0MURgVWDleF51MqqBp8M7PGammM7LCCkzQmxiX7Ede28?=
 =?us-ascii?Q?Ah2WU2aUdbY+ES4lKQQ/0fm8y63ZJfKHcpxdrCRGuhX9V6p3VlF6dGbMOQ3g?=
 =?us-ascii?Q?Wi34ecCSeGMNXlmEFjsaD9aZ3QE6PwRR0XsVlsSydOJl54kAo3hqhdWVXGaL?=
 =?us-ascii?Q?2aCO92NFghMXAoC8+k5Qdx3obuVhOxuwuXq8zdzsQJbO3FEmofrzYCexxRFl?=
 =?us-ascii?Q?UYyZFOsotZP/S2RINnIWmOjIlB1YOaypSYnLTK22dgHchURzIk+0Wngdx5ql?=
 =?us-ascii?Q?p+Y4iigbclQRR3htpORXAzZEvmQWX/NdtOzAIxvcUKrR+HLFvJvyYNcX1ir3?=
 =?us-ascii?Q?LjZMjZaLdRhyrx4rTes/jfiqXLChrnaY7J27ya4kAGqrT2M2?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5400.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4992769d-aa41-4cc4-ac73-08da477b0c3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2022 05:11:43.8006
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ecx6rz64ewQpZ3/BU+S0s/8FHb7pSkkSv8dLPe14ep06ZuxPpi8VW74AqS7rlF3z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3173
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Gautam Dawar <gautam.dawar@amd.com>
> Sent: Friday, June 3, 2022 1:34 PM
> To: netdev@vger.kernel.org
> Cc: linux-net-drivers@amd.com; hanand@amd.com; Gautam Dawar <gautam.dawar=
@amd.com>; Michael S. Tsirkin
> <mst@redhat.com>; Jason Wang <jasowang@redhat.com>; Zhu Lingshan <lingsha=
n.zhu@intel.com>; Xie Yongji
> <xieyongji@bytedance.com>; Eli Cohen <elic@nvidia.com>; Parav Pandit <par=
av@nvidia.com>; Si-Wei Liu <si-wei.liu@oracle.com>;
> Stefano Garzarella <sgarzare@redhat.com>; Wan Jiabing <wanjiabing@vivo.co=
m>; Dan Carpenter <dan.carpenter@oracle.com>;
> virtualization@lists.linux-foundation.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] vdpa: allow vdpa dev_del management operation to return =
failure
>=20
> Currently, the vdpa_nl_cmd_dev_del_set_doit() implementation allows
> returning a value to depict the operation status but the return type
> of dev_del() callback is void. So, any error while deleting the vdpa
> device in the vdpa parent driver can't be returned to the management
> layer.
> This patch changes the return type of dev_del() callback to int to
> allow returning an error code in case of failure.
>=20
> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
> ---

This patch is not changing anything except for planning on some future devi=
ce returning error upon delete.
Until that happens I don't see much reason for making this change.

>  drivers/vdpa/ifcvf/ifcvf_main.c      |  3 ++-
>  drivers/vdpa/mlx5/net/mlx5_vnet.c    |  3 ++-
>  drivers/vdpa/vdpa.c                  | 11 ++++++++---
>  drivers/vdpa/vdpa_sim/vdpa_sim_blk.c |  3 ++-
>  drivers/vdpa/vdpa_sim/vdpa_sim_net.c |  3 ++-
>  drivers/vdpa/vdpa_user/vduse_dev.c   |  3 ++-
>  include/linux/vdpa.h                 |  5 +++--
>  7 files changed, 21 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_m=
ain.c
> index 4366320fb68d..6a967935478b 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -800,13 +800,14 @@ static int ifcvf_vdpa_dev_add(struct vdpa_mgmt_dev =
*mdev, const char *name,
>  	return ret;
>  }
>=20
> -static void ifcvf_vdpa_dev_del(struct vdpa_mgmt_dev *mdev, struct vdpa_d=
evice *dev)
> +static int ifcvf_vdpa_dev_del(struct vdpa_mgmt_dev *mdev, struct vdpa_de=
vice *dev)
>  {
>  	struct ifcvf_vdpa_mgmt_dev *ifcvf_mgmt_dev;
>=20
>  	ifcvf_mgmt_dev =3D container_of(mdev, struct ifcvf_vdpa_mgmt_dev, mdev)=
;
>  	_vdpa_unregister_device(dev);
>  	ifcvf_mgmt_dev->adapter =3D NULL;
> +	return 0;
>  }
>=20
>  static const struct vdpa_mgmtdev_ops ifcvf_vdpa_mgmt_dev_ops =3D {
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/ml=
x5_vnet.c
> index e0de44000d92..b06204c2f3e8 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -2775,7 +2775,7 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *=
v_mdev, const char *name,
>  	return err;
>  }
>=20
> -static void mlx5_vdpa_dev_del(struct vdpa_mgmt_dev *v_mdev, struct vdpa_=
device *dev)
> +static int mlx5_vdpa_dev_del(struct vdpa_mgmt_dev *v_mdev, struct vdpa_d=
evice *dev)
>  {
>  	struct mlx5_vdpa_mgmtdev *mgtdev =3D container_of(v_mdev, struct mlx5_v=
dpa_mgmtdev, mgtdev);
>  	struct mlx5_vdpa_dev *mvdev =3D to_mvdev(dev);
> @@ -2788,6 +2788,7 @@ static void mlx5_vdpa_dev_del(struct vdpa_mgmt_dev =
*v_mdev, struct vdpa_device *
>  	destroy_workqueue(wq);
>  	_vdpa_unregister_device(dev);
>  	mgtdev->ndev =3D NULL;
> +	return 0;
>  }
>=20
>  static const struct vdpa_mgmtdev_ops mdev_ops =3D {
> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> index 2b75c00b1005..65dc8bf2f37f 100644
> --- a/drivers/vdpa/vdpa.c
> +++ b/drivers/vdpa/vdpa.c
> @@ -363,10 +363,11 @@ static int vdpa_match_remove(struct device *dev, vo=
id *data)
>  {
>  	struct vdpa_device *vdev =3D container_of(dev, struct vdpa_device, dev)=
;
>  	struct vdpa_mgmt_dev *mdev =3D vdev->mdev;
> +	int err =3D 0;
>=20
>  	if (mdev =3D=3D data)
> -		mdev->ops->dev_del(mdev, vdev);
> -	return 0;
> +		err =3D mdev->ops->dev_del(mdev, vdev);
> +	return err;
>  }
>=20
>  void vdpa_mgmtdev_unregister(struct vdpa_mgmt_dev *mdev)
> @@ -673,7 +674,11 @@ static int vdpa_nl_cmd_dev_del_set_doit(struct sk_bu=
ff *skb, struct genl_info *i
>  		goto mdev_err;
>  	}
>  	mdev =3D vdev->mdev;
> -	mdev->ops->dev_del(mdev, vdev);
> +	err =3D mdev->ops->dev_del(mdev, vdev);
> +	if (err) {
> +		NL_SET_ERR_MSG_MOD(info->extack, "ops->dev_del failed");
> +		goto dev_err;
> +	}
>  mdev_err:
>  	put_device(dev);
>  dev_err:
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c b/drivers/vdpa/vdpa_sim=
/vdpa_sim_blk.c
> index 42d401d43911..443d4b94268f 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
> @@ -280,12 +280,13 @@ static int vdpasim_blk_dev_add(struct vdpa_mgmt_dev=
 *mdev, const char *name,
>  	return ret;
>  }
>=20
> -static void vdpasim_blk_dev_del(struct vdpa_mgmt_dev *mdev,
> +static int vdpasim_blk_dev_del(struct vdpa_mgmt_dev *mdev,
>  				struct vdpa_device *dev)
>  {
>  	struct vdpasim *simdev =3D container_of(dev, struct vdpasim, vdpa);
>=20
>  	_vdpa_unregister_device(&simdev->vdpa);
> +	return 0;
>  }
>=20
>  static const struct vdpa_mgmtdev_ops vdpasim_blk_mgmtdev_ops =3D {
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_sim=
/vdpa_sim_net.c
> index d5324f6fd8c7..9e5a5ad34e65 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> @@ -167,12 +167,13 @@ static int vdpasim_net_dev_add(struct vdpa_mgmt_dev=
 *mdev, const char *name,
>  	return ret;
>  }
>=20
> -static void vdpasim_net_dev_del(struct vdpa_mgmt_dev *mdev,
> +static int vdpasim_net_dev_del(struct vdpa_mgmt_dev *mdev,
>  				struct vdpa_device *dev)
>  {
>  	struct vdpasim *simdev =3D container_of(dev, struct vdpasim, vdpa);
>=20
>  	_vdpa_unregister_device(&simdev->vdpa);
> +	return 0;
>  }
>=20
>  static const struct vdpa_mgmtdev_ops vdpasim_net_mgmtdev_ops =3D {
> diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/=
vduse_dev.c
> index f85d1a08ed87..33ff45e70ff7 100644
> --- a/drivers/vdpa/vdpa_user/vduse_dev.c
> +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> @@ -1540,9 +1540,10 @@ static int vdpa_dev_add(struct vdpa_mgmt_dev *mdev=
, const char *name,
>  	return 0;
>  }
>=20
> -static void vdpa_dev_del(struct vdpa_mgmt_dev *mdev, struct vdpa_device =
*dev)
> +static int vdpa_dev_del(struct vdpa_mgmt_dev *mdev, struct vdpa_device *=
dev)
>  {
>  	_vdpa_unregister_device(dev);
> +	return 0;
>  }
>=20
>  static const struct vdpa_mgmtdev_ops vdpa_dev_mgmtdev_ops =3D {
> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> index 8943a209202e..e547c9dfdfce 100644
> --- a/include/linux/vdpa.h
> +++ b/include/linux/vdpa.h
> @@ -443,12 +443,13 @@ void vdpa_set_status(struct vdpa_device *vdev, u8 s=
tatus);
>   *	     @mdev: parent device to use for device removal
>   *	     @dev: vdpa device to remove
>   *	     Driver need to remove the specified device by calling
> - *	     _vdpa_unregister_device().
> + *	     _vdpa_unregister_device(). Driver must return 0
> + *	     on success or appropriate error code in failure case.
>   */
>  struct vdpa_mgmtdev_ops {
>  	int (*dev_add)(struct vdpa_mgmt_dev *mdev, const char *name,
>  		       const struct vdpa_dev_set_config *config);
> -	void (*dev_del)(struct vdpa_mgmt_dev *mdev, struct vdpa_device *dev);
> +	int (*dev_del)(struct vdpa_mgmt_dev *mdev, struct vdpa_device *dev);
>  };
>=20
>  /**
> --
> 2.30.1

