Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33E3A3926ED
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 07:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233226AbhE0FiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 01:38:20 -0400
Received: from mail-dm6nam11on2049.outbound.protection.outlook.com ([40.107.223.49]:30883
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229500AbhE0FiS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 01:38:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cqax5/P2Rt1tyM5Cz4da68jglnXYFK4hgJrcN8JwGHrlLYy/s6JbqKDOQXs7XNI9pul1NkvlxjwUghMJR4kPGOfwjN16rxR2ZcEOmN0LUWAsddj7gRzQrcm8WGo+upstaAMH1FPmdQsdn3isfU++4Rxbeh3GOMExsHh7dEK50fGaldRNj8txEa1ayikuxqSNz8pxv5uSHS7kfpJ5l8niqZqI0piLnzNvuyBvz8QnX7JIWz0sFWkbCkWzNQPmxc4aXVmalhTod9hnpKnQTs3imqNVFvoxAoDu/cOe5ZBRes22R+HlHexoNLiJp16llVIf9M/jZMJ9v8iVj5Fk9NADiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1axZL3TzjOJeBtVwpf+ZFdAko4VW15t/9fVVE+r5iTQ=;
 b=YE5zJOB7TbiU4jzeO5MjOSrlM/fggX2Eq/GZTXa0YLhrTw48oh7eWgiUCfbjm55M3RP5XEVEhQQY7mur2qUpcPhMTI0Wuqi4Ep39h3PW2imCJu4RQOOKq1a7/hsPa+UuYSjMLoyunRfrPfwYj0SBg/KGR8xAJBHMkN62ZfvC0zErGkxJ47aW2139rxziwvSg3fEA35ctPzCcSWfy4YlrcM6E84EEohnB5YKab3REtDlHKNu4qBBROoVEef8wS3annsmf4G+KsjxdR4BuiWCco2CqXBKRyQH3RgUZmkt8H+4sRD3roRdilQECCVL7eTRlmr7DjRpUziL6BCjB52HRlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1axZL3TzjOJeBtVwpf+ZFdAko4VW15t/9fVVE+r5iTQ=;
 b=C90Qsgp0bUyBpZFCBy/Kcu/8vMcMX8azVSuMKUDFBZYNTKwfytyLIttNgful1AWRkI2wx94E2UOutKflRMSh/P5WFs6znmNd27x3DifM/jsP48ttXKqmM8UqqFcClmyCM+mKLGQcKW9/zx9nugh9QWIddHUhPjw7HNOT0vWbsPmy3Ar9IJXyYs5Xfbvk6xNsQtd/OkHLda7dQ0CrbvlFeq8ONhO6/Y0qetR/+HKefQc/UBgQZld8RWmSaJxLV+iMoupyhtpoa5J6X/PZzJ6s3CD7i/lk2iXw2T7yKwQ6+nIjTtufAKm4I/+Jm2BYvNYGPBcDPQslWIcvCsuQreKbgQ==
Received: from DM6PR12MB4330.namprd12.prod.outlook.com (2603:10b6:5:21d::20)
 by DM5PR12MB2391.namprd12.prod.outlook.com (2603:10b6:4:b3::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Thu, 27 May
 2021 05:36:44 +0000
Received: from DM6PR12MB4330.namprd12.prod.outlook.com
 ([fe80::4d1e:778d:d6ee:b2cc]) by DM6PR12MB4330.namprd12.prod.outlook.com
 ([fe80::4d1e:778d:d6ee:b2cc%9]) with mapi id 15.20.4150.027; Thu, 27 May 2021
 05:36:44 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: RE: [net-next 17/17] net/mlx5: Improve performance in SF allocation
Thread-Topic: [net-next 17/17] net/mlx5: Improve performance in SF allocation
Thread-Index: AQHXUrH3qlFIS2GAPUCc7sjt4jqkRar2w/ww
Date:   Thu, 27 May 2021 05:36:44 +0000
Message-ID: <DM6PR12MB4330F30E51E9D86F2AA212A7DC239@DM6PR12MB4330.namprd12.prod.outlook.com>
References: <20210527043609.654854-1-saeed@kernel.org>
 <20210527043609.654854-18-saeed@kernel.org>
In-Reply-To: <20210527043609.654854-18-saeed@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.211.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cf2cef18-ed54-4929-733a-08d920d16a13
x-ms-traffictypediagnostic: DM5PR12MB2391:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR12MB23916FEDF1EF90099B994893DC239@DM5PR12MB2391.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FKsl6BIrXV8mNRoDRPVYj3u53oFgv5QB2dKYYr5qkaafY3LSxK2nmjh9FIQGyd61DuT4Lho2Jlf7TVndG4TKCLRexVbww9nyoOJ1XDDKF5CZIPckqj7hxbRFfYnXv+0XMHi0MbEWKDYUlm/Z9SH6VWxCXA9gftmCriAFU068P6PFP2vS2NYHBqKHSPaoLkrTLdU6DHJjPVQH30Cdxdxkbg9FKqIfjRVWC+++gnyRRL7twSoc5ZEOs3nQM5gnvgj+b9xQzp+9g/TKXG7a6Mf3VLBaRnjZl8oMYBjlAb/uXLc0sbup1U1zHi2IguMJJXpLTI2qjmZB18C9wELpYapG2D8JVFAy38Uw1HZBcKZq3uZHuzufi6ZVuBiBGV3NjAxwYduLa/zouYEQapQKWk/tEcBk6XDdgBjbmsMvwAzGsluXYgI3ZOJXMIAxONiNf12hWH5NsvFEMSf94W1fPk9aufx4a2W9DLejTKxopO7bFzf6hc8n1K98Q3up/V9dLEjayYy69y2WoYvBZ+eQ3HPNjb52m1V0rDdiwq+JRtgXu4wd7mdYV2aB0MHl3TKkfFkNK9DeoG5dMVtY6Shwj/RWqG7IaFK4NtpMJxsuFiII9wU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4330.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(366004)(346002)(39860400002)(9686003)(26005)(76116006)(52536014)(64756008)(66556008)(33656002)(122000001)(66446008)(8936002)(86362001)(7696005)(38100700002)(6506007)(66476007)(66946007)(55236004)(83380400001)(5660300002)(4326008)(54906003)(478600001)(2906002)(55016002)(71200400001)(110136005)(107886003)(8676002)(186003)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?3C1kWaG5JJswPhC9rWiHL9uV6BVm/FvKEIf0dAgWG9S7aWRWWyr7muGRGggz?=
 =?us-ascii?Q?COyy4kQoV57l/8u6UWSmz/PgKvkRztYerQMr5buhuUiERTEgNOp+3ts7Tkzw?=
 =?us-ascii?Q?l6h/szA70P6nDPWqjkMGzznzzipScD4Hqx4VLYu6d5Ms6uqvhZp8Cvx3DVr0?=
 =?us-ascii?Q?n9geaXVhfEXOtn8VhKLZ9PQUiWBYz6V/MzjejULPRGPjBHQljrPGlmZKW/cY?=
 =?us-ascii?Q?iqmFd4mY5QJoTlCnO4inc6COOHjH/zULSLo8reIZiOIN+cTBNFcIU0oBH7aS?=
 =?us-ascii?Q?doE4AUk+y7AVXzGG5Yvl+lPQo7a+02SlwB13q3RSBq36zQkaGNFDzyRjpxIA?=
 =?us-ascii?Q?VQe9cn0kIKiV0pPJ6SfyIaGuT5KGJIN5p9rUdFmFMgEopZFbkRmp/kxgnG3u?=
 =?us-ascii?Q?+5t8HLWyj8LwxZbZsFalAcqZFieGl7pghycdUNoK42eQz18v7u70F6ikbLHn?=
 =?us-ascii?Q?2a8fiE+IHvseKRA6PMpx8LgSvvJu+0gtQ1IMy6CJPvvdqqIujbH5DPW1s3xC?=
 =?us-ascii?Q?cSek0zxCy0xuVwMzJ8zTmsdHLjFQKfIuCLwJjgfyLMqh2tjiJcB/kCSLRkP8?=
 =?us-ascii?Q?PuHvCcdEw0mQBujdS/DqEA7DD/WTyT/y9yYockLjFTRfPtEO0lObRzNfiquN?=
 =?us-ascii?Q?QWNtUqJdJQvAbnAralwK4OIke9fHyOkuq/XQfBMpobyMbC2KDNxDC66l1J4k?=
 =?us-ascii?Q?fct1pgIJtzWkAHlApNZsLM+JEcbdNpCXbRTHJunsZHA4bb+ergZ6knulTOn+?=
 =?us-ascii?Q?35TDAL4aozRuyQ2ZQzg6GKehalvMt4D4in9fykAgep/+gmZZ3wgdxVHIKZeV?=
 =?us-ascii?Q?6ze4xi8/L2qWm0Im4GqjWbjo0AZw6sXPu5MW/F0qAWjJM3OmV55paCa0CGj6?=
 =?us-ascii?Q?T6yoH7/siItgJb0DbkFn66McYitEzneuVg9zzBK+/aV/lTcsq+qrh36pJAHN?=
 =?us-ascii?Q?TL2OOdJFeh3FD7Vg+gY0/s06yfOm9u7eQv6d3VVlhktDrJA03E3HgVGkO3z9?=
 =?us-ascii?Q?HjB2imP1UU+AD323Ih3EUfEzYd49pJQCUaf6o6Fx25OeGzejqpl6FfSCm7l/?=
 =?us-ascii?Q?uaTJlMWYk9JZy6QnBw02DM69rKt8vB/nTuk1s+5LnY8cQptseURQmCDhlWdE?=
 =?us-ascii?Q?RLxCvErVcJNViLliRQ5gxhlcIzqHnyK2P88RsjHhBMecDCF3zu4RAy1fFo41?=
 =?us-ascii?Q?4VSo8Kyn4UhUnznQh+/N+1aI0fMGuT41OGIMvKJGibuF0FO3XnW7lUUUnmrq?=
 =?us-ascii?Q?7XzE8PPNG5EDL20G70b+ArgJW+xxCbxEEOo3DyLXm0hfypJv/jpO7vLoZbBb?=
 =?us-ascii?Q?5DuVyTMqWl3hEfj/pMVQ9FKm?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4330.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf2cef18-ed54-4929-733a-08d920d16a13
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2021 05:36:44.8762
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ddIp8zeGq4/VdoeafwFtgmfLKfDGZ86HlsBxYRALmkHhKTAV51Fy747U6fz4ryV2o/hCAA4J2f4zGj70g8w75g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2391
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: Saeed Mahameed <saeed@kernel.org>
> Sent: Thursday, May 27, 2021 10:06 AM
> From: Eli Cohen <elic@nvidia.com>
>=20
> Avoid second traversal on the SF table by recording the first free entry =
and
> using it in case the looked up entry was not found in the table.
>=20
> Signed-off-by: Eli Cohen <elic@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  .../ethernet/mellanox/mlx5/core/sf/hw_table.c | 23 +++++++++++--------
>  1 file changed, 13 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
> b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
> index ef5f892aafad..0c1fbf711fe6 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
> @@ -74,26 +74,29 @@ static int mlx5_sf_hw_table_id_alloc(struct
> mlx5_sf_hw_table *table, u32 control
>  				     u32 usr_sfnum)
>  {
>  	struct mlx5_sf_hwc_table *hwc;
> +	int free_idx =3D -1;
>  	int i;
>=20
>  	hwc =3D mlx5_sf_controller_to_hwc(table->dev, controller);
>  	if (!hwc->sfs)
>  		return -ENOSPC;
>=20
> -	/* Check if sf with same sfnum already exists or not. */
> -	for (i =3D 0; i < hwc->max_fn; i++) {
> -		if (hwc->sfs[i].allocated && hwc->sfs[i].usr_sfnum =3D=3D
> usr_sfnum)
> -			return -EEXIST;
> -	}
> -	/* Find the free entry and allocate the entry from the array */
>  	for (i =3D 0; i < hwc->max_fn; i++) {
>  		if (!hwc->sfs[i].allocated) {
> -			hwc->sfs[i].usr_sfnum =3D usr_sfnum;
> -			hwc->sfs[i].allocated =3D true;
> -			return i;
It is supposed to return an allocated entry.
> +			free_idx =3D free_idx =3D=3D -1 ? i : -1;
This is incorrect. On first attempt it allocates the free index.
On iterating second entry, free index is valid, so this condition is false =
and assigns -1 to free index, making it invalid again.
This leads to never able to allocate an SF situation.

> +			continue;
>  		}
> +
> +		if (hwc->sfs[i].usr_sfnum =3D=3D usr_sfnum)
> +			return -EEXIST;
>  	}
> -	return -ENOSPC;
> +
> +	if (free_idx =3D=3D -1)
> +		return -ENOSPC;
> +
> +	hwc->sfs[free_idx].usr_sfnum =3D usr_sfnum;
> +	hwc->sfs[free_idx].allocated =3D true;
> +	return 0;
This is incorrect. It must return the free_index and not zero.

>  }
>=20
>  static void mlx5_sf_hw_table_id_free(struct mlx5_sf_hw_table *table, u32
> controller, int id)
> --
> 2.31.1

With this erroneous patch single SF allocation fails.
Our internal tests are failing too.
Please drop this patch from the series.

This patch needs below additional small changes, which I verified.

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c b/driver=
s/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
index 0c1fbf711fe6..9cc6ba7085a5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
@@ -82,12 +82,12 @@ static int mlx5_sf_hw_table_id_alloc(struct mlx5_sf_hw_=
table *table, u32 control
                return -ENOSPC;

        for (i =3D 0; i < hwc->max_fn; i++) {
-               if (!hwc->sfs[i].allocated) {
-                       free_idx =3D free_idx =3D=3D -1 ? i : -1;
+               if (!hwc->sfs[i].allocated && free_idx =3D=3D -1) {
+                       free_idx =3D i;
                        continue;
                }

-               if (hwc->sfs[i].usr_sfnum =3D=3D usr_sfnum)
+               if (hwc->sfs[i].allocated && hwc->sfs[i].usr_sfnum =3D=3D u=
sr_sfnum)
                        return -EEXIST;
        }

@@ -96,7 +96,7 @@ static int mlx5_sf_hw_table_id_alloc(struct mlx5_sf_hw_ta=
ble *table, u32 control

        hwc->sfs[free_idx].usr_sfnum =3D usr_sfnum;
        hwc->sfs[free_idx].allocated =3D true;
-       return 0;
+       return free_idx;
 }
