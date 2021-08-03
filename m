Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23B03DE490
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 04:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233718AbhHCC6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 22:58:23 -0400
Received: from mail-bn8nam12on2083.outbound.protection.outlook.com ([40.107.237.83]:18528
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233537AbhHCC6U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 22:58:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cA7UU3V+641L55KVZjSOVGF/sWfsZPEIdrUCdl54kZnHaH3Z9ed1XxKcetcDW/e3BYj4XUANy2UfAbpuB0f34tI4GTUfzpHHXuVRpRDDv3KrJQpek76IJpoeSbce+ctQ37v1epsi2izT+/4lSJYpwnuTPwexBNub0GDs+bXkufHYx0WiFQXoUej72057QrTie1Li20Uim1uMlDZsG6k2WwPCt5fwRuW9vwhghuUn2+iNFnEQ7+diJfRv0qU5NQqkfBuTuSwkyF0QkkryJnd2VyYyeyShwdvMoP85c7N/Jl7lNidHMR1JxKXU9j6hN6Kv48n7kMZ3kFrYzkWxqfmu/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kueW+M3BLAQZ6jXns3TTtPR9grT4lkeYmU1nQ0YXYEA=;
 b=Th26L9Wl+95uwLF+ZMx9L2JDqqTll489i5X3q0cTmkWmdQCghOt+EA6OQDqoaCCFAsy0wA8Cork6aiNs5KAXt3m1y0ZMP27Dtg232WYuUl4kSAmwm7Yl7hCuZDXT0nsaoU6VbhG+2hotlbpeWX5Ec5CNSqZCccvUd/YGku2KxWawTZobpPahMofk0GXt3kSDCrYxoQaTiL6mHjd0NwAe7tk9nVn9fxq6ac/qqFNRwsSdlbynfTNu7nv0djQcZt6EKTxvTPNAf0fA3QGKGviBnLl2UcIwm8azMSODfnT29d1JHfOYvi/ai+sRspnGsH9efOTYjcNTghKDOvlXi2ZQsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kueW+M3BLAQZ6jXns3TTtPR9grT4lkeYmU1nQ0YXYEA=;
 b=EQoSZqBA3f7UAOc0zH23jFS7E+U+kBn+6nGkL1D0KioHVVP2h9oeXz/KqS4r3DGyawWvDqqqbgpZTQjgf7NNSZzfUQhKjIa/DKqDFwroAg+gKSvxmzUkWOV7jvJ3gmAcNKev8IrXusKTwIjO57VRf7rO0ugJclHODokEAP9JtYb5lSgTh1V8/alKx15duP2RNtckJveKnq/qZtJSBS7kj1D9Fsu6GeYoiwIvJc8JaHEyzSH6T/dpyCfhY7GPfir88bdBl2MC7u5qbtQI5vyhTQj4WnKz1X4LZfWJ8IbXIpju1FbRjDnk838BlsWWrTqS5WG6HNRU9BZnxF21YSIcNw==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by PH0PR12MB5468.namprd12.prod.outlook.com (2603:10b6:510:ea::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Tue, 3 Aug
 2021 02:58:08 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::ace1:9322:ab32:7293]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::ace1:9322:ab32:7293%3]) with mapi id 15.20.4373.026; Tue, 3 Aug 2021
 02:58:08 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
CC:     Leon Romanovsky <leonro@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Vu Pham <vuhuong@nvidia.com>
Subject: RE: [PATCH net] net/mlx5: Don't skip subfunction cleanup in case of
 error in module init
Thread-Topic: [PATCH net] net/mlx5: Don't skip subfunction cleanup in case of
 error in module init
Thread-Index: AQHXh6Pk3xgYlyCwEkm6xE8MeIZ9wqthFdrA
Date:   Tue, 3 Aug 2021 02:58:08 +0000
Message-ID: <PH0PR12MB5481D1AC09BAB933660E12F8DCF09@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <955a0ebca11c8e41470e37ec2eb2a3bbcd77bbe5.1627911426.git.leonro@nvidia.com>
In-Reply-To: <955a0ebca11c8e41470e37ec2eb2a3bbcd77bbe5.1627911426.git.leonro@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1966437d-40e3-4bb1-2d5d-08d9562a860f
x-ms-traffictypediagnostic: PH0PR12MB5468:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR12MB546865C6A21214330CC843F4DCF09@PH0PR12MB5468.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1/M8/e0tTtbjfRtrv+pTEtP7tYARQU3JkR6hwMlqrA3/scj4tTOH8m9lmpi6DutUOv7rygFM2rP8oEtIRpBesWk9Igp2E7ituAoPe7M9DnqDWwClclxLNfl6XTaQ9pgRaQGIT7pvqO20goAEpBS1UvOGJ/aIFO9bk+WHbST1dfWLwcrmv4t+W9Oi9AcuxaybHpA+8R1kOBulGxiozPGaYoJ2pEBB1u/EgHF54rjANpYKuTIVT4kC3KUhASl68Yl3fAmM1g9EZoHiO2Cdf+ZCnCy79GNAiXv7OAv2p1sPGjwrHLwpyNwAt/A8IkaEuhwr+0LW+dwxMzrszaWhpyBkXkpwyDln0RgNsr17hpcL1nTEaIkiw0YX9WW0dGMtGv1XQbJKUi3vMx3X7bEH6fVHYJfwUJzPkxCWbMwYGTVx9nPKRhDAkmiZ4KwvfpSyStPKUo1bGWEVkxfddwqS6QdFJL2+Vw08RbF1HQuYCUZvlcAbwSbwHtb8Hos8L0pTUVEIlAco/Lp/yy/hu0RgI2r/7UlvHg1P+5OIAreSzBp+sOVRZrxxz9InYnS6+JY/R5vEKnt32+uknkwPALduxjl9H8i5jr6zQTuK+972VMFbKmQGJdR2hHy/1b0xIy5eolsAcm9+zyx5FeCo73Y6pPkMW1RzA2ddm03fXUiul5MUnYRUR9PMQkeNnV8j+65Ef7MrWdjhdpJGNw/Vgkf1TRX6DA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(346002)(376002)(136003)(26005)(83380400001)(186003)(8936002)(110136005)(54906003)(76116006)(66476007)(64756008)(66556008)(66446008)(33656002)(4326008)(66946007)(55016002)(107886003)(38100700002)(52536014)(2906002)(6506007)(9686003)(38070700005)(5660300002)(7696005)(316002)(478600001)(8676002)(122000001)(71200400001)(86362001)(55236004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aHTfL03HG7nBCnGw5Z8CmGZl9jQ2o3uThSoeIQOmJJ4/rQ7SdCDEch3rKkQ7?=
 =?us-ascii?Q?SY6iaZm8WWijt+FJXRyJQrTcuOkZe6YmsrkyUgCvFizjNr/2Q/nnq6M2Vhei?=
 =?us-ascii?Q?rbOkoBBCAOHNo1GM59IXxknifdsVN39JebG2IOXc1f3mLpLApx5FnYZDBsfY?=
 =?us-ascii?Q?0SeEmiuyVyUixxLR7MumfTwFy9lVP/ZALFuHoJY+4wNVG0mWTklFEoZow959?=
 =?us-ascii?Q?stKvMvrEYiMZA6n0v9d27Rh1H8BE5YVIP3RrzSGgb/RaSlyrhur7e0vkn/Qm?=
 =?us-ascii?Q?Tb8BLXnqbbd7zy8teWtDhL13jEVWuS9vDedeMBz2rTq1B3h9iwVZlbA7bJD2?=
 =?us-ascii?Q?oGQsNbNE4JAihcb/rwmBpr/fcB7JEWgXVm1qfRWorolYU/TTD6RwXzFbj0AN?=
 =?us-ascii?Q?mkPsRp02al50yjviuvWqCDDeKv9lFVJlc7i+nETyjX5+8Q3K/mNCNeoiu+mO?=
 =?us-ascii?Q?kLKfK62xOzQhNmUpIvKILQ0oiUAsUoidKmriyfHTaFafeK0SEmZJkstZT6N0?=
 =?us-ascii?Q?uqt3wyZPL6AHPNliOP867x6Xhg3lg/LmXU4fso5C2VeZqa9SnFomO8XMYKI9?=
 =?us-ascii?Q?tcH1LKQKBR498GLc4hNaVogX9SQiXHT8rfIxuSAC4+tXKVkWQkK2YMxHz7zk?=
 =?us-ascii?Q?xeuWv/LSayz1WQYXQc/WhSCEH3XlDQxyp2hDhuVon6YiuxSQfaklcvx8ndC0?=
 =?us-ascii?Q?HIlNYw48hTRDTXkk8oXRVpGcjoDcSqiNLQxyqjXL0uVEV/AihslDajnhMoaa?=
 =?us-ascii?Q?nDusBFHDz1HksNgJ9eZEtQhf9Ai1xjgMKGJN77v78Wz38RwLNVFCXl/iFSsC?=
 =?us-ascii?Q?IhKI2/bkxxoalrLsZJNMyYETAmo0i/wikyjZDjaif+zn7eY32Xq/Vkc67JBV?=
 =?us-ascii?Q?EEOE9vmYS+Tb1JgSWCH+V2BnSewii0fOBzdP595Z7nX1r6odU4BN1wlFhL2E?=
 =?us-ascii?Q?RFk+jC4q6Ly0ert79awKI9BrlcGdE6Ov0NJ0lMIz4x/j4ocZhgSX9Q1czXzK?=
 =?us-ascii?Q?djEcC+emymntYxWAj/sKoutjUr+lVvEyHGwhAZ4GSmiQvhVAXV7JFG5CW4FY?=
 =?us-ascii?Q?LgtfGgxfK9V1c019TGgbkzT16/mD1zYCyKv9y8C1Sy3JDpqe444GZUcu00RK?=
 =?us-ascii?Q?0IM6q/Iikxh8ZVYmdGcAxK+8YjwvFzWodBgrAeUOAJg5BHjHwR4eSdGkJbh+?=
 =?us-ascii?Q?n9J40wtKyNHA8aRHAKjR8iuBxQ4NmQC/XBsE4HtR0aoDtS1VeOzCujParzzD?=
 =?us-ascii?Q?bB06LMWQhhgFaYbFGrVzoXEMki4PrrjsAyp1w7CI+1H/+vER0vMEQjzx0coT?=
 =?us-ascii?Q?ivvSos8ZU06DaSIVoKOTotJ6?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1966437d-40e3-4bb1-2d5d-08d9562a860f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2021 02:58:08.5839
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KxsjASId3OzauP/vsIsjgziss/K0R/lJgoBD04pC8hStvdV9vF5ePm/JOiSvy/ly2Z+xR0vd7/3nzbU3DLIitg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5468
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Leon Romanovsky <leon@kernel.org>
> Sent: Monday, August 2, 2021 7:10 PM


> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> Clean SF resources if mlx5 eth failed to initialize.
>=20
> Fixes: 1958fc2f0712 ("net/mlx5: SF, Add auxiliary device driver")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/main.c      | 12 ++++--------
>  drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h |  5 +++++
>  2 files changed, 9 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> index eb1b316560a8..c84ad87c99bb 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> @@ -1784,16 +1784,14 @@ static int __init init(void)
>  	if (err)
>  		goto err_sf;
>=20
> -#ifdef CONFIG_MLX5_CORE_EN
>  	err =3D mlx5e_init();
> -	if (err) {
> -		pci_unregister_driver(&mlx5_core_driver);
> -		goto err_debug;
> -	}
> -#endif
> +	if (err)
> +		goto err_en;
>=20
>  	return 0;
>=20
> +err_en:
> +	mlx5_sf_driver_unregister();
>  err_sf:
>  	pci_unregister_driver(&mlx5_core_driver);
>  err_debug:
> @@ -1803,9 +1801,7 @@ static int __init init(void)
>=20
>  static void __exit cleanup(void)
>  {
> -#ifdef CONFIG_MLX5_CORE_EN
>  	mlx5e_cleanup();
> -#endif
>  	mlx5_sf_driver_unregister();
>  	pci_unregister_driver(&mlx5_core_driver);
>  	mlx5_unregister_debugfs();
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
> b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
> index 343807ac2036..da365b8f0141 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
> @@ -206,8 +206,13 @@ int mlx5_firmware_flash(struct mlx5_core_dev
> *dev, const struct firmware *fw,  int mlx5_fw_version_query(struct
> mlx5_core_dev *dev,
>  			  u32 *running_ver, u32 *stored_ver);
>=20
> +#ifdef CONFIG_MLX5_CORE_EN
>  int mlx5e_init(void);
>  void mlx5e_cleanup(void);
> +#else
> +static inline int mlx5e_init(void){ return 0; } static inline void
> +mlx5e_cleanup(void){} #endif
>=20
mlx5e_*() functionality is provided by core/en.h and core/en_main.c
So above declaration should come from en_main.h, instead of mlx5_core.h, bu=
t we don't have en_main.h currently.
Including en.h is too much given rest of the other declarations in it.
So for net fix, this is ok, for net-next en.h should be improved and above =
declaration should move to en_main.h.

Reviewed-by: Parav Pandit <parav@nvidia.com>

