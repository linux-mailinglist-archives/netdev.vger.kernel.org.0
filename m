Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 128EC4553BF
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 05:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242926AbhKREYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 23:24:53 -0500
Received: from mail-bn1nam07on2042.outbound.protection.outlook.com ([40.107.212.42]:24369
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242925AbhKREYx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 23:24:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XP+3m5yAb036gB/2Q+SVk6WmLLeDxwDLd6Km0tnelYNr161xj4PqMXa1H0mfFnQjnxVyaVCdmvIl5hOrej2zm7osm1TbxPg9aZmcDeMMwHIsRIyAsbvaJR2PE+F45Yo8MUyjOuq8TPy+8aTY30eRzM1gnqcucwb8TdTnhcFzIVnM/700C4h4WsoKcAo2YJ1i5ItywBgXcg6aTWhIEOPHdra6Q4gENgLNUBNNVRbTnCQxwV/tFr47pl5Sp6IQvNijJRTuRcxwHvw0PxGTmbMtEOBL9oDXRd2SKKQeepk4qe/2T4oH2+x5Sjw3Smjz29XdAakPFJ/HmDKECOMbUBPeIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5uA4I2sS+RW06Z3CLH2vrm5Sv6yWr8ZasFr4XJj7rdY=;
 b=RfPekJdaVVBLyYYZiPBQGSeeBlz8Mt4ack2dFtSXUc/skDWteYg7f0lxJWFpb8tuPRlT8XsP9pp5ORJdy7G1CQsHrTtwnVDhhdI5Aldsk3ulrX916+eqHx8Ld/QjVeUhERI4XPZ3JUcLKs1VeTZ8NHv6yb7FLTLHTvLsvgXDxc7EgpsPw+83u4jfb9Zou/JoIeRJQqsv8eg5z3zcRsidbzg1MTQ0Xh7t7s4oETsDg1z2erCgG3c2niTPqKjgMg6MDdYUTGcBrKt82vl1pTC3HWfHi+IuwGHioGERaVqxqbWUBLA30qvA0LvvObb2yK7FvEESm+IEVFlHAFlki2x6pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5uA4I2sS+RW06Z3CLH2vrm5Sv6yWr8ZasFr4XJj7rdY=;
 b=sYIZq2CdB9jLVtAyd7yppbzFYpK2igUNivyeN+F27awPXlezK2JafgIaoSabGN0/EUx0x4vPs0yYBgLCw/1nLdFguR2miFc3h93vomcljEr7gb9kO2O6PYUF9ScUbeT0yeuhfe7AS/GZkzJHXdqhcZJiaTlTyZM4l0oB9y1JLRWlweUO2edV8C9fTyQLl5xP0MI7TKbSwMIfnTBY4YfomWTcDE/nH4nVM8ZJjH3TCRnbkTBwvpPfaLpIQon/5yQcmbDsxm9heK7WZ0gMd1qLnHlxyZ/MOa+i4sSTsGtOxgLYrCnM4VE0hO4SzQk8dFGYX6iXKE1j3o59Bke7xJdHLQ==
Received: from DM8PR12MB5480.namprd12.prod.outlook.com (2603:10b6:8:24::17) by
 DM6PR12MB5520.namprd12.prod.outlook.com (2603:10b6:5:208::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4690.27; Thu, 18 Nov 2021 04:21:52 +0000
Received: from DM8PR12MB5480.namprd12.prod.outlook.com
 ([fe80::fdc5:44d:885a:6c61]) by DM8PR12MB5480.namprd12.prod.outlook.com
 ([fe80::fdc5:44d:885a:6c61%7]) with mapi id 15.20.4669.011; Thu, 18 Nov 2021
 04:21:52 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Parav Pandit <parav@nvidia.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next iproute2] vdpa: Remove duplicate vdpa UAPI header
 file
Thread-Topic: [PATCH net-next iproute2] vdpa: Remove duplicate vdpa UAPI
 header file
Thread-Index: AQHX0tlvbTUJW6In1k6rmFSqzpp0FqwIwX4A
Date:   Thu, 18 Nov 2021 04:21:52 +0000
Message-ID: <DM8PR12MB548089EFC4288F4D824AFE04DC9B9@DM8PR12MB5480.namprd12.prod.outlook.com>
References: <20211106064152.313417-1-parav@nvidia.com>
In-Reply-To: <20211106064152.313417-1-parav@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c7957107-9395-41e5-4db3-08d9aa4af277
x-ms-traffictypediagnostic: DM6PR12MB5520:
x-microsoft-antispam-prvs: <DM6PR12MB552097B1C1562C12E0AC96AADC9B9@DM6PR12MB5520.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UeNnQYSsyVopjCp6VwAUBamSnOJasxEPyhz2IRJg3oAXu5TSppwYXQxrjOX9IGE1QhXzxuAvi26Xcmq3cBLSZdR2IbIxNLXAIMqYpQSPCYmzoiQNhItWR6PlRkkLua9xpOTlBuWyk2LamnNIXjJBngCNOD5IqWPj28Tpfqg/8wGifACnFps1IiTbyy6jD2ccK8FBuQ8rTBBRW1aFTXTjcENLnSp8TPSJ4UhjoyTFyUH5O9DQ8zz3/AtAGKr7kfuI57F1mO2eZPldzkbHVzPQP4MKN3/oOuakVhsBhZsZtjQnVq0VymGbVsjnDzIH1ZJzLt7fpfEn3df5v+i2ksWhS3CUdORkigaS8LhUsMDImlspkzBh4JH4mmV2z7f6aPzunn3nU4L5qF/Btx/Qu0Qkytuvhx8CqVmvOJ/ZVkir1+tsji9MiFvhC6aQOBCND15IhiM/DYzgQCDVPrgH5T3Dv8EABlLI1xHToF5UCvzDEQs3yQyBhS2pB7TDA9ueFKMzNiu4CJVZSt9spJGRBlucz4H5X5wAKgz6phDfrsAQo6giZMR1ulmk9Oy1QUizCwlghcCNugFyJfWUYELg+kgNHIsD2s42fd9K2iriJNNl1q2rt0x7qMfpKEOMhejycoWfrsDdh6+G04mUo7m6zi/I9GpiggnS0wXjqa2PpCjg3me4APkrzNujA9HO9VbPDUh8aqE1ARWA8V+cX5EJ9WdlPQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5480.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(55236004)(9686003)(52536014)(8676002)(7696005)(76116006)(66946007)(122000001)(64756008)(55016002)(6506007)(186003)(66476007)(66556008)(66446008)(86362001)(38070700005)(5660300002)(508600001)(26005)(110136005)(33656002)(8936002)(71200400001)(83380400001)(316002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?M4crQvkKCjYwKpFj4daS49PQcSalvFAE5zxCS6iC35LvaN1ol9wdB9aMYqsF?=
 =?us-ascii?Q?TB9vcuHmdNvc8EbM9oVjGG4q0Yh+3Iftyeg+Kgd6tRV3h++2jX10LglpLDxA?=
 =?us-ascii?Q?310yKcZcghZu3Luwy/5nGyPdqAaf/aKxwp9bbXDFif8XnXyxLIVkcZiTv4O5?=
 =?us-ascii?Q?ppOHe7ZfjoWXq0BXRWeVz4jA0/mMglbpWlla5NSyGoCMfIoKCddOHHmtwLpt?=
 =?us-ascii?Q?kl2v2+tnrRjaW11/faBCneJZFYwABPzLVizh+3/Y47qNaM5l856yunwbS/Md?=
 =?us-ascii?Q?1veGWRyASClzZwpxT6BQeX9CaRhYki4+VeEFfkFjKGhHvS2mxfNPzzyXzN2i?=
 =?us-ascii?Q?WNLNzVQX5S8XwgSSOj6Tw3VtoNNyx5dWICocCFp3ViGYOdP0vr2JqevvfOCx?=
 =?us-ascii?Q?+YGE89RHQFxAF0hj6rZq7Nnsv8MCeCW4qfGkJ2Dp1IT/eztA9Lp2KnIo4R1y?=
 =?us-ascii?Q?w0v4EEMwLuTBrCnKdpud0PL4n9/K5ul+T4oUzwybLq2T95ScK9O5vLTeekpE?=
 =?us-ascii?Q?KN/YDE59GJn/XmeVDFlCWf/pbyMkDvYmV5GGHHnxNJxjY+zYp5293WozOmWJ?=
 =?us-ascii?Q?Odk/js9SBTld0XJvUwUmZnnQ08iFtLRVb+Y5fwYXicVoZE8dsKiuPuc5izYQ?=
 =?us-ascii?Q?Jwgn10AkcuZnVtDR9goPSH3OqrGOh5dGi/tFzn3lDLmJQBPiJke2Lz6v/6sp?=
 =?us-ascii?Q?1mhuQpezdgI8YBdbmxZJE9xhERAGluyZBbaPhQ/zx9BmwfVqqzP87tBdXFSW?=
 =?us-ascii?Q?6Y6vwymxvd2j1J6pAEZIi+q+pLqfy3zdxTTn+oKlu8EriscQhhs/ihmc6ajr?=
 =?us-ascii?Q?7H+G8mKHWeR14L9WqW14L28ZNRLCSJTPm0o9xtMJ3DLUneq3geGCnuLaUSeG?=
 =?us-ascii?Q?Tm/uE3/jr4wSqfzhYLQ2ECCHRX5aM3e0yurlWQSdEk+PAOx3Jv2/JYVx02dG?=
 =?us-ascii?Q?c3ol0XBdYnevVHe6PluIGXgqhRe7pbymcfiwZ69dPyt0lbEL9A0dWOLgnJae?=
 =?us-ascii?Q?jHQl+cUXeCdQxsdKdxwuRaiGR2Hdq0Jin9JEWx7YIu9WYbCqWSwVYLFqbGCe?=
 =?us-ascii?Q?NW/23uRj0tnun5ghgkV8rAZpNvmV7GJ3e+3jJ5+gqoMJv25G2A7OjeSzZHNY?=
 =?us-ascii?Q?d4D2HXKWrbS2LBzLzZpFA+ue/FgBVdsIcRzS5rR4+b1SAPUrkAGL1K5jXLgV?=
 =?us-ascii?Q?zFagfTv5S2WfdFZfjwxdRex0OorfTZvhBotS9PcxCWEg6Om+UhV2qY7492pB?=
 =?us-ascii?Q?oigEsIEXaNHaakrJzbWuvFas177a3lIbJzmJvUskmy0+9vD9przZT8g/lmFO?=
 =?us-ascii?Q?IPAPcSHujcjO+d7loR6WX/ihfNP3RIppSw4Nua2syKxTCg1G/hl+FXAuA+wI?=
 =?us-ascii?Q?XmhijVSW/OQYP1hvDNloae090r+PevU7QwMW9PaUzds+tr3hhUwVkS/P5efb?=
 =?us-ascii?Q?aUU1JMBCom4GHzyusUHycnJGcSZ/rSTMzi1MmzjA02WXkVfji14rbpVQR+BU?=
 =?us-ascii?Q?GvHRlq4jmzXETllnWwSn61u8S2vSomvW/d80mQMf7NxqANc6j3z27dJ3BiKS?=
 =?us-ascii?Q?GKmXdNP8kNUIiTReA5AgXkoGH/FpQmuvShV6M3tzNTxKatNVvhOSehySu78T?=
 =?us-ascii?Q?5yqtcbGvlE+3dWUUwT4BjfM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5480.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7957107-9395-41e5-4db3-08d9aa4af277
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2021 04:21:52.1006
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ciCfnmNTumsCKveBqbbQTZDcjC/g25Thlwm5+a7ZJOAtbEnrjg8goMwM+9s21UPj+qYL2os1O/y/it2pTcuatg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5520
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, Stephen,

> From: Parav Pandit <parav@nvidia.com>
> Sent: Saturday, November 6, 2021 12:12 PM
>=20
> vdpa header file is already present in the tree at
> vdpa/include/uapi/linux/vdpa.h and used by vdpa/vdpa.c.
>=20
> As we discussed in thread [1] vdpa header comes from a different tree, si=
milar
> to rdma subsystem. Hence remove the duplicate vdpa UAPI header file.
>=20
[..]

>=20
> Fixes: b5a6ed9cc9fc ("uapi: add missing virtio related headers")
> Signed-off-by: Parav Pandit <parav@nvidia.com>

Can you please review this fix?
I need to submit further extensions to vdpa tool that needs header update; =
and above fix is necessary.

> ---
>  include/uapi/linux/vdpa.h | 40 ---------------------------------------
>  1 file changed, 40 deletions(-)
>  delete mode 100644 include/uapi/linux/vdpa.h
>=20
> diff --git a/include/uapi/linux/vdpa.h b/include/uapi/linux/vdpa.h delete=
d file
> mode 100644 index 37ae26b6..00000000
> --- a/include/uapi/linux/vdpa.h
> +++ /dev/null
> @@ -1,40 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
> -/*
> - * vdpa device management interface
> - * Copyright (c) 2020 Mellanox Technologies Ltd. All rights reserved.
> - */
> -
> -#ifndef _LINUX_VDPA_H_
> -#define _LINUX_VDPA_H_
> -
> -#define VDPA_GENL_NAME "vdpa"
> -#define VDPA_GENL_VERSION 0x1
> -
> -enum vdpa_command {
> -	VDPA_CMD_UNSPEC,
> -	VDPA_CMD_MGMTDEV_NEW,
> -	VDPA_CMD_MGMTDEV_GET,		/* can dump */
> -	VDPA_CMD_DEV_NEW,
> -	VDPA_CMD_DEV_DEL,
> -	VDPA_CMD_DEV_GET,		/* can dump */
> -};
> -
> -enum vdpa_attr {
> -	VDPA_ATTR_UNSPEC,
> -
> -	/* bus name (optional) + dev name together make the parent device
> handle */
> -	VDPA_ATTR_MGMTDEV_BUS_NAME,		/* string */
> -	VDPA_ATTR_MGMTDEV_DEV_NAME,		/* string */
> -	VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES,	/* u64 */
> -
> -	VDPA_ATTR_DEV_NAME,			/* string */
> -	VDPA_ATTR_DEV_ID,			/* u32 */
> -	VDPA_ATTR_DEV_VENDOR_ID,		/* u32 */
> -	VDPA_ATTR_DEV_MAX_VQS,			/* u32 */
> -	VDPA_ATTR_DEV_MAX_VQ_SIZE,		/* u16 */
> -
> -	/* new attributes must be added above here */
> -	VDPA_ATTR_MAX,
> -};
> -
> -#endif
> --
> 2.26.2

