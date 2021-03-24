Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38879347094
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 05:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232597AbhCXEvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 00:51:11 -0400
Received: from mail-mw2nam10on2057.outbound.protection.outlook.com ([40.107.94.57]:11905
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232587AbhCXEuw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 00:50:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NhVXQGlOUfr8568vPUUd3uyXY2um8vtz+EifQwZG95LxJY4xv3ECk5a7uJKqyHf7K0L6GZU+PQ94CFjIuByxhOLhXbQYIMy6KH0/uMNOEQQGJqsocy46rdIs/kTtzBxEbAgV5dtrjzgPisslACHDds1a1n7lupVuLrhvQ6IFA2m49WysXYDxPAHZkd1xomDi8zdNIeBR9Fd9oEbwf3gOsU81DITVHe78X5FCUsK7kXmIq48eLWvQGXvH7XFZy0YJEwnNiH60ZxhbjgZQB+B9oa4uRlELqhWq372ic7wdCkScmWGGE8jEJOxVjYYSs+xAr6DE88SxE4VDR6OvdMeGqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X4yzwR1CKzS1bg2APn4k1aoH/I1SVD9xG7eDiVY1Pcg=;
 b=nZvbbj66TR3Kr/QeSn0HmF7OlcCh1ztlN9ah3TIFce/gBxh5tGnjSm2KA6knjC5W9du9l4BtFOHXjOLOG8XbONnKUn+vqgeRLiwfKCz4Rgl3K4fLlUc/G3SlHm79bBauhiqnILSyMI9LM6VFZFMxaLWATS02Q9pR1l4Ir2hniBuYYwfTwNkArXy952GkrmRiEJZ66ZdC0GuvuGE4etwPiACi5uoNdI5wWTjERNJXE/2wstZQNwiuhKxIfJ8uky8u6wiAUC7D/h4e9lsm4y9kPwLcsRU6aADeKSMwINajMr6bBEjbxVZr5YTEr3pJwDoRKMDl4E8ViH5rH9kNRREmrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X4yzwR1CKzS1bg2APn4k1aoH/I1SVD9xG7eDiVY1Pcg=;
 b=t/Vu7KOE5EfXF3LruuM+Oa28nIVDwTXIX7B29zuG/YSRgkOdOnzMEmCjyXtbXucKqUx5pin/gKnAFlguwGUzOeK3QeIUdSkIrmHoktZ4iF3V/gXwcbR8Zh8RwYC3nEB/s3VYhBimsRnJy8U/WXSq8fxERyPAjs4MXp8FICbKu5Uabtg2fKgzMdteUz+VbQKW2XHMTVWPWFq8L8z2rQY90csRKUEH0RKJJsAg0AW8rI25Ulh/46Xnz+8HVARtoyFvTrmkrWInfVlzXYerOPVQLi6EGn1lKcN0CWLUCdhbn/yMdQrV0BvvKM7vSQBbBJ3a23PveWeK6xrFfXKw64n4PQ==
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB4114.namprd12.prod.outlook.com (2603:10b6:a03:20c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Wed, 24 Mar
 2021 04:50:51 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::7cec:a7fa:db2e:3073]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::7cec:a7fa:db2e:3073%8]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 04:50:51 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Shiraz Saleem <shiraz.saleem@intel.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "david.m.ertman@intel.com" <david.m.ertman@intel.com>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>
Subject: RE: [PATCH v2 05/23] ice: Add devlink params support
Thread-Topic: [PATCH v2 05/23] ice: Add devlink params support
Thread-Index: AQHXIEFD/G8hoBwdlE6ZByD8K/Qg36qSkJog
Date:   Wed, 24 Mar 2021 04:50:51 +0000
Message-ID: <BY5PR12MB43228B823CA619460AAF2099DC639@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20210324000007.1450-1-shiraz.saleem@intel.com>
 <20210324000007.1450-6-shiraz.saleem@intel.com>
In-Reply-To: <20210324000007.1450-6-shiraz.saleem@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [122.166.131.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3e4002e3-7cd2-4006-2afd-08d8ee806652
x-ms-traffictypediagnostic: BY5PR12MB4114:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB411481EEFE1D8B45A73C1BB1DC639@BY5PR12MB4114.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PyPcPi5QNTisDbIaaQZZOcMu62mMF1D8bUJei8a3V92/8q+/SZidGhTkl8BPXrOWjLtokwUBVxtbVD/z36z2NfbxGPeivfhNlhar3THa7bIEHHRXKqihV5yZrXccrsQUDlqF24ufPt8r9KJ4Yn8goInQVU4z2GSnQN8qDjKEs89VToVbPf8E9MsnQIiuPqdPCfbN23b3TrPt/dMGSJXP0zbQHzke/ncWhBViokGlRjyNo/bkfD/tdktdw9Jgd3BaQ3s9zQHRbCHMD/ofnsETbgPjZLZZkoQeMwSB/Tbo9/zghKJ5uOHHC8OjXNXOD848wUz/bIzzN/uyU7HvrEqozekpx3Y5eMincX31PHD8yQaxpSScn0txlQIMT8vbxbJrDg8ZFGrVPgdko6hlkH9B2cAjR55dtV+650suHhYSiDUUCVfpsgsylRIKwJq1H5riE5/gFS0wXKz+a8J9nuO+UER1DguaQ2/mMtRt6gqAKCHLUAr4yAFuOjXBS5/xMondu/VX8O8RhXD+Izagk5+HbJd9CuYJ0UdD7YiJgFa1D3JW1KAAczEZMEXRq3uf4M2MEMiYjM36IHbA/Y4MiP+E5P9U3NsnCD/5OZfG7W8wyPvxHMp38pf5R6gPTWQYfKi7R5vnGD3reg4vpejHX7AQBKZUjMncYTOnodCB6WEWvUg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(366004)(376002)(136003)(38100700001)(7696005)(71200400001)(52536014)(8936002)(66946007)(478600001)(8676002)(2906002)(5660300002)(55016002)(9686003)(110136005)(4326008)(54906003)(76116006)(64756008)(86362001)(33656002)(66476007)(186003)(83380400001)(66446008)(26005)(316002)(66556008)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?gF8fsZolzDbo/diI4OEcjCLuyAfuXAU0WRedIhOydt9akbv+Zc0OaVktUe+3?=
 =?us-ascii?Q?OW6+RMGZPeLAa2n5Yk78g3E+oa6m1E3ML3RiTJ5edDOZBhdlV9UjavGmbpO3?=
 =?us-ascii?Q?XAxjE//S6c5xA3+Td25zDzFcsGynlhSwv8ueNUuB/8xDpLTQKjnTnTzBp8Rn?=
 =?us-ascii?Q?DMwLlQaLX6RADADbsE3IkpvsWaBB3kXL6IzQVc8UmnA36wABDfvHany96ldy?=
 =?us-ascii?Q?XCQkcGpQbrNQhKC5vI+aDNB+inAvpcz2Wp0dfEuzGoALmCcKXtH0BiBDBrXv?=
 =?us-ascii?Q?zkrc8IQyA3MPEKgucE1d1VZKyqCZXo6ofz6rpFRyypsGiWpQnOcfUvIgz6PW?=
 =?us-ascii?Q?8dQEVNIXTml5jNPYyseybSnGIETDLtbnZsuQO1FIfJX5LH6y6I+v8OrZldti?=
 =?us-ascii?Q?IPez3EhxJZAm7bwXvd+kKuV99AOVXfh4vz1Me8zJY8aXWpdEc5WXjbshVFNg?=
 =?us-ascii?Q?kxrKnzsQRBsvoKk7pgCYWIYA8kI4KGdewX3Od117f9KD+kmucQf8pt0msCQy?=
 =?us-ascii?Q?X/YhEW1CxASLwCxCtwKsrk3pdH5hGGZAPci7vUcFB0pjLVmBpmtB6fsadb7Z?=
 =?us-ascii?Q?i09wNz5QkzZCi67q+M7hxGQZZQq6tz4to5zqEmvP8HPTL/7dw6RgDiWg9Suc?=
 =?us-ascii?Q?FSeyHyOvUO8ROkQ9KOynvlpWbK51d2DmEfWSUlx9P1Bf3g2NpKU8jiA2gd/Q?=
 =?us-ascii?Q?O9oZ7A5afV/3H4s6GezFxxuVbbYSDRydjCMrnYvYYzvSF202DhSLiYnT/n11?=
 =?us-ascii?Q?T12NWqtGzD3XQNPhEjkJ/QdHmgUZe/+Id0xAT/wEpGAa9lhGMNAIWLjcAKV+?=
 =?us-ascii?Q?bzQCyxyT5Kcu0H81Hv81yx8t68fAAx0PhYDaw4/ZcmVko7zmbndC88AUFSXA?=
 =?us-ascii?Q?IkQsfQa9o3z9EDGt5qWBXOOi8Ndy0jzzlOoPpDUx8i7V1gNFBv7uM5XLxr3r?=
 =?us-ascii?Q?+Q7aJxTsLumYgynMHpZEMwCLFJJyB1DGd8cuH2zTis9RRwqh1dDoIMN5lp88?=
 =?us-ascii?Q?zUa4Q28Ykw+3S7sQIl3mxUsgvhJS0O5D+zB/bV8UkADi/yABLVrv5ktFwysF?=
 =?us-ascii?Q?hJVx+j3Tg2RKyOwvhpNaV9CXFPXUOz+rvfSabK/WH2MfD5ul4WoOWixYwgWS?=
 =?us-ascii?Q?1RFt3hvb9Cj5U1+7zAGHlT4A4VaagGDQDuy0qJAc0QwpBTD7Kk515VaF9noU?=
 =?us-ascii?Q?AhGs2gZWQa4DtWoprTrSEMS6rIB/GZ+A+naPhNqDrFNOXxrlhscIDQk/zBtf?=
 =?us-ascii?Q?l3f3vRRyeWc+09tvVOQybX2TOK6m+i33FJXXJ0VHO6oWAZ1bTEECExoCeDBV?=
 =?us-ascii?Q?XI/mxeamdYqiybrGogjYql59?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e4002e3-7cd2-4006-2afd-08d8ee806652
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2021 04:50:51.2293
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bNoypceF1/22OUDNPyWxzQYiCSnUYbmValfaZr/mr6VWxBNP/c8bjAd+LdsxCmcQX23/V1FZvuYxQuS/5kSr5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4114
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Shiraz,

> From: Shiraz Saleem <shiraz.saleem@intel.com>
> Sent: Wednesday, March 24, 2021 5:30 AM
>=20
> Add two new runtime RDMA related devlink parameters to ice driver.
> 'rdma_resource_limits_sel' is driver-specific while 'rdma_protocol' is ge=
neric.
> Configuration changes result in unplugging the auxiliary RDMA device and =
re-
> plugging it with updated values for irdma auxiiary driver to consume at
> drv.probe()
>=20
> Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> ---
>  .../networking/devlink/devlink-params.rst          |   6 +
>  Documentation/networking/devlink/ice.rst           |  35 +++++
>  drivers/net/ethernet/intel/ice/ice_devlink.c       | 146
> ++++++++++++++++++++-
>  drivers/net/ethernet/intel/ice/ice_devlink.h       |   6 +
>  drivers/net/ethernet/intel/ice/ice_main.c          |   2 +
>  include/net/devlink.h                              |   4 +
>  net/core/devlink.c                                 |   5 +
>  7 files changed, 202 insertions(+), 2 deletions(-)
>=20

[..]
> +.. list-table:: Driver-specific parameters implemented
> +   :widths: 5 5 5 85
> +
> +   * - Name
> +     - Type
> +     - Mode
> +     - Description
> +   * - ``rdma_resource_limits_sel``
> +     - string
> +     - runtime
> +     - Selector to limit the RDMA resources configured for the device. T=
he
> range
> +       is between 0 and 7 with a default value equal to 3. Each selector
> supports
> +       up to the value specified in the table.
> +          - 0: 128 QPs
> +          - 1: 1K QPs
> +          - 2: 2K QPs
> +          - 3: 4K QPs
> +          - 4: 16K QPs
> +          - 5: 64K QPs
> +          - 6: 128K QPs
> +          - 7: 256K QPs

Resources are better represented as devlink resource.
Such as,

$ devlink resource set pci/0000:06:00.0 /rdma/max_qps 16384
$ devlink resource set pci/0000:06:00.0 /rdma/max_cqs 8192
$ devlink resource set pci/0000:06:00.0 /rdma/max_mrs 16384

Please move from param to resource.
