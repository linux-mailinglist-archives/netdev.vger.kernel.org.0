Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15E983928AF
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 09:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235005AbhE0HkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 03:40:14 -0400
Received: from mail-bn8nam12on2067.outbound.protection.outlook.com ([40.107.237.67]:62816
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234205AbhE0HkO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 03:40:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kFLRbXjWxjUCtHpqv1lsNNMOSpsVxImD0ApMoK2H4fDCYNVKggrmXWiEKzfNO5hhtTWvzZTGtLH4IeuaLLersuP/VqvrrLfrGqxTG7owIDouxNBaAkUfvYrrgFs/fex5lpdZgeA8bv8fPsvlwrEfILDIgEDbkyJPPlY3ouM7CyD8wwkgkyeMHzpdwll1HG3oZqrsLJOkg6G1h6s0ifJadwOuYjiyes6queThujBnAmZ1zp7KYrkZx8FL+zhu+x2hteLV+RtaPtGb4auify0I1q9UKZC4ou9rhv2xkxuUalQeL4PclmW9QHFy28PaqYh0V/g5jXWFTqPMDUBXkdnURQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lMuNV13aiF4XX46wSosd1tM1oOh5nkw4GFZSdJ7q5cI=;
 b=fPW/alhBWOS0ipZPMkOIWU0KgzU8ZebxT0sghPvJmJFcIkrWKmepMURpkolj9q3H61nfg06YRY//rPi9lrF9P6PiD4naDBfryWoSe2Tk2lIFTlZANYrjBi7dSf6XbdpFBRo+OkDhRZPW+XoYfM+FD8En3LV1S3gvMJlrNi1MnA43J9KeDYCqZwsnI+9dtzaNZIniMl4MJGMfA94aUQVf2eWsxEz2opg1KxZLDkMwhyRgsW2BrXgpgiPzdHi1btsb9f8D5FHlJAREpebn0uCom/ZbFqWwgiHRL2DxIGjG9iBxC2e4rp5A0i2fEl3kgug7RRoaHojTKq+E6Qtv5d98BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lMuNV13aiF4XX46wSosd1tM1oOh5nkw4GFZSdJ7q5cI=;
 b=pA6/gBQtLjWsPDVprfqqoolWeuEcL80/cmGmnr1VgAbWq5qINz4s5sWX0A6Lej1RAYws/KxYkmM1CVnmttkuwyEdS2SaLNnB3LtwhM2Lzl32msYbvhG3omdoLGb204coBuOWMoes1wfZ8QwzT8qd936UMILRCAXzz86PuzQrhkLUttStoTt+P9WDgvTvHvggasNQkY/S6StIQ3GQUor4xKRZwiPfL5+hJCC/M9roOcmUPfs1RXAs1b3cculid+AA1p074v0SvW5syOeFXBA6xowTM41x7gl2B+OH0rUMLsMjtJhfnE61KMGU45Jz6U3tSXDIh2iOdJiUCjXGxQfYsA==
Received: from DM6PR12MB4330.namprd12.prod.outlook.com (2603:10b6:5:21d::20)
 by DM6PR12MB3675.namprd12.prod.outlook.com (2603:10b6:5:14a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Thu, 27 May
 2021 07:38:40 +0000
Received: from DM6PR12MB4330.namprd12.prod.outlook.com
 ([fe80::4d1e:778d:d6ee:b2cc]) by DM6PR12MB4330.namprd12.prod.outlook.com
 ([fe80::4d1e:778d:d6ee:b2cc%9]) with mapi id 15.20.4150.027; Thu, 27 May 2021
 07:38:40 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: RE: [net-next 16/17] net/mlx5: Ensure SF BAR size is at least
 PAGE_SIZE
Thread-Topic: [net-next 16/17] net/mlx5: Ensure SF BAR size is at least
 PAGE_SIZE
Thread-Index: AQHXUrH2O8dggCI4Zk2XgCqug3tpFar28D0Q
Date:   Thu, 27 May 2021 07:38:40 +0000
Message-ID: <DM6PR12MB43306F8A03809C2FE2CC3BBFDC239@DM6PR12MB4330.namprd12.prod.outlook.com>
References: <20210527043609.654854-1-saeed@kernel.org>
 <20210527043609.654854-17-saeed@kernel.org>
In-Reply-To: <20210527043609.654854-17-saeed@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.211.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6c575563-17c6-47b3-ed26-08d920e27260
x-ms-traffictypediagnostic: DM6PR12MB3675:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB367508151ABBB81CA05916DBDC239@DM6PR12MB3675.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:765;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Z16c+bi5qQrGiY8+P++XQTg2IGH4Tg9QvRI6AMGgqBZ+/NYsVB99sd6Gdg31URakcLePS7UH7GxL01Zvd1yVuW8h4a5uhzURHEmVP9wDQ/ItirOVzSg86pgADocKoFvsfj4eooDMm4+7nRZGUnRhGx/9lzCcf+Em+taeROf+f/4U8ZJSR+HJbfCqUihG852a1mGk4nAZgppooWRV37yCBp4bgqEzpaKy2/ggzouG10rhBXMx1oCHSiYMlx19C7ibjmC39UWDwr7NDxtIOVvIiNVhBafU7/lf4JKdmUAJaa5c6nWQgbM+QjPsogibe3A+usSKPB5u+g+8wWWmM2T5WLg1h4S7NRkHv+xHOUC0ElANte4uDmpRtgBLG3tA6F88U1RNa4hwz2HrUTRz4RJv0rRkn3HZGsEhY1lRn2H1ZXmKR6ONm+C8ZrCB+It7OT4gU2oTbxNAy2+fVjbEnElaiCeAZWESxBLE29wdRvnrmRli68wfkB7cN3NZ1wWdv7tQ5nNPuAWm2XV3zilnrPyAk68Ihux4epSGygk7IkXEnMMoZiFrzpESW5faDV1BD4xE3cGLXmtg899ChhQxv0WaPuUlwPoVKefNxkSVC1EF6i8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4330.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(376002)(366004)(346002)(55236004)(38100700002)(64756008)(186003)(86362001)(316002)(26005)(66946007)(8936002)(6506007)(122000001)(66446008)(33656002)(7696005)(66556008)(4326008)(8676002)(110136005)(478600001)(107886003)(54906003)(5660300002)(9686003)(52536014)(66476007)(76116006)(83380400001)(2906002)(71200400001)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?nTn5sRL5l22MasJyoJHnXw3u7+vJ03Sf1TOP34yIgcYQDVIEfzthHGzI9WWc?=
 =?us-ascii?Q?F6Ro07usoKWUG9M7v60UXZoMPX1VhwNslLoYTfoUCLhiWmLdHPaHP/GCsCXU?=
 =?us-ascii?Q?PkY8kjV3ARhaLbB3s5dwUJVvPRmCV71JTVK54jqob/FO5g4cgHgeS+3wJiR4?=
 =?us-ascii?Q?wzWCOnOgoI5rYLj9zbVm3jF0IhzNodj9MlgPSoZ5An5GyPddH+zywhadaHNb?=
 =?us-ascii?Q?WVSlHguJ/lxO3r3Enk2bqGuvwlUjo6CENq9KkA//8UjQ7/Rul8ibPQQzZdyA?=
 =?us-ascii?Q?slUxWQVeBekdSl+FgBIQV1k6rmU6P6eF7BdDMftZNSHIuW2Bg0XP/mDCJ+sF?=
 =?us-ascii?Q?T/L20sSJhSceZPscqqZ+qR4iMU1hifNEQBVziFI3pkFNRMX2EnAqD3RQXenX?=
 =?us-ascii?Q?jzNKi7QEdQ2yagmPxajlDWfyH9uaWUSip8oG69PVG5CFpFrcFIFq88X6S5EF?=
 =?us-ascii?Q?9Fp0g5Hu1ri9qvwjm87w/cI5lC0a7YNDTPTL/SEBWxnhp4UH3TCJruDIkmPF?=
 =?us-ascii?Q?oihPMM+4JoHeCIZg/2VNA8uAmNrjEHSRnZ1sOTcmmqTYo9qlQT9bAQ7gEwbc?=
 =?us-ascii?Q?BZ6BvvgEPi7CHgpF6HT2SGkc7oRGc9iIWB9YNlNu7Fg3sF9RL6ARS0MusIqY?=
 =?us-ascii?Q?MTSjaZUgGkc3PAYvxvmWsw59nsb9+h/o6zZfj0nDgKlKxB+ylYNRUMYwa4GZ?=
 =?us-ascii?Q?cz0j2c60lUMPKqP9npJgSis3PmR4EBBFKEQ+h3ZgXkl4j/gTgKbymnYv0Mbp?=
 =?us-ascii?Q?IArTkZrvQtK8XLMzmLq0d50Cz71ynv3IRObPwY4DOOg5G9qLhr29j7ZPKplu?=
 =?us-ascii?Q?q6kXBJ66ykAsZ49XqgRU0TuwNNJzkt0TvR4s437kLmm+3re5Ts7/GFxY/IqW?=
 =?us-ascii?Q?qi++hut6e+y5X6tRV232FFOrP55kazM+eGdgwyri9RWtABk5Ca86btbAmFWX?=
 =?us-ascii?Q?xPXNN7XQLwai1fENg/xTMsZU4uQnVRDIALk2lZkU8lBkt9FuYtQFq3SAywK0?=
 =?us-ascii?Q?+N321Rm8OT+7UgMNqAYAQktlysG69fUi6TZ10nsQQ3AqaQJ4hAMSWlGBP/oB?=
 =?us-ascii?Q?6HfS9nhV+SqLIhcua2QSkABSNxXLIjZjyiv1fGGdToSdOPvNiGl2Mh/v3kYI?=
 =?us-ascii?Q?N+iqZbudsw9f58rCaHCKfTC8mK+ou4XcMOCheKm5yWIxvMxPckH6iCR53Okg?=
 =?us-ascii?Q?kBfo7t714so5b7TkonbPJwZXgBO/LwWuaCPGWEvkNiSqAfs2cyliLlTpm2do?=
 =?us-ascii?Q?m482akVYWm0fS/6s8Xd7J2njEdDGRg+UPRzjKdmC+v/zRgFPV9AV3w7borhi?=
 =?us-ascii?Q?piHhqPfOGWWcQUOKvblTsd8V?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4330.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c575563-17c6-47b3-ed26-08d920e27260
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2021 07:38:40.2013
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TEkyRuGWp1aEdYZwsOoEyqYW/4KXNh9IEjzvDFO8d+LQI2+vwHaYVFwUjYk0z9HwadvtH4S4gI3SwFKIcQsHMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3675
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Saeed Mahameed <saeed@kernel.org>
> Sent: Thursday, May 27, 2021 10:06 AM
>=20
> From: Eli Cohen <elic@nvidia.com>
>=20
> Make sure the allocated SF BAR size is at least PAGE_SIZE so that when
> mapping it userspace, the mapped page will not cover other SFs.
>=20
> Signed-off-by: Eli Cohen <elic@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
> b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
> index 6a0c6f965ad1..9f9728324731 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
> @@ -227,7 +227,8 @@ void mlx5_sf_dev_table_create(struct
> mlx5_core_dev *dev)
>  		max_sfs =3D MLX5_CAP_GEN(dev, max_num_sf);
>  	else
>  		max_sfs =3D 1 << MLX5_CAP_GEN(dev, log_max_sf);
> -	table->sf_bar_length =3D 1 << (MLX5_CAP_GEN(dev, log_min_sf_size)
> + 12);
> +	table->sf_bar_length =3D 1 << (max_t(u8, MLX5_CAP_GEN(dev,
> log_min_sf_size) + 12,
> +					   PAGE_SHIFT));
This is incorrect. You cannot do max(). BAR size of a SF is absolute number=
.
You will expose BAR of other SF when PAGE_SHIFT is > other value.
Please drop this patch from the series.

>  	table->base_address =3D pci_resource_start(dev->pdev, 2);
>  	table->max_sfs =3D max_sfs;
>  	xa_init(&table->devices);
> --
> 2.31.1

