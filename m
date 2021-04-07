Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66AEF356F6C
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 16:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345670AbhDGO5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 10:57:19 -0400
Received: from mail-dm6nam11on2072.outbound.protection.outlook.com ([40.107.223.72]:28193
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1345603AbhDGO5R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 10:57:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gx1rVTWrv3HeLArNrSak4xG1N8mQKXcBI4tmNlBYyDMm7ogG29K/qmMbR0ouRyKb64WEoxYHJS63oY/nxPCQ7QNj1kw2XfcuaEp/TBCdYlHmEdMamtqda+zgO7wMWPcDP3/lwV22MMDj8Yx15G82wETsqnXyimDwo95S6ayEVoisrsYxmvbcsfVPn//JkREb02io+4otyqfTHu6JTQfOKmg41OODtPGxwWsI1smA9yjySWlOCHXy5mvMpZAgmvr9P4XcyyMsBpQTdnO1jWVdjBWrHKAVNX+yLNx4ElARg64TTQs4ahG7lrqj0uaMJpWzhF3Q16LwbsTmp5bT973uMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fhm4bvJQoIOZxsm+4W7pXpFQuAt8uoyNvwGCCVrQFio=;
 b=E2WlycmsUWCZFGqXIvJiatwTU/J5I9sHtGTRKPQYd38L5h4koCf6YCz/UVfdzmqrN/rVSVlGzpFDqfRuwouEhtsk6PtwL/KxuP7WX6EYBYjU12YN3+Ie3TdfYg5GehDA+W80P5aeNh7m8grGs102p5mQYyBDoi+2UUJEX2HRAxu8n6NATmZl0N+g8zgQkWpPAMaLsqh1FXKy7Jly+2mShBfZJr8OvS7A4V1fBfw8rlnQRUHKaN9Hhiw8kkHsBONyTdT3G8q2Igj9Nf44Ob1NE//iIvrc64+VmI5i8jUsGkSs5FaIjHlhNqzwcTccxDr1bAzHR01flORo6TD51+dLiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fhm4bvJQoIOZxsm+4W7pXpFQuAt8uoyNvwGCCVrQFio=;
 b=CEdLDAbmKFQyYkd+lbxdJjGjTynPKPp9FaW8n+0NH/mCF5BJiW/kLLqvPl0I8no4xrCeUozKVLLYroKJBbuVyzmIHidV9shs9nkzXIOqEqnDwv1nyq3tuQIMtxRd0CUk0y9qFcMaFOjTlFZlucOwruQXkJygP2ghYm5evN6RKtNxpXhuHol7X7Ku8Nvj3R8qDVlUeFaH63XVjWbSS+rSI4cN7cVt8xH21gNT3FncR3pD8IYC+1SPiL46ZBi8cZFEOf3i0y/UxJzrAKe0AQq7r44LcVRceig0UVLZ4fF3a0NoDeWV85Bnpj152aXW9n26PDzZYMaQQSpkbtXpiSUlFg==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3115.namprd12.prod.outlook.com (2603:10b6:5:11c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Wed, 7 Apr
 2021 14:57:07 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.032; Wed, 7 Apr 2021
 14:57:06 +0000
Date:   Wed, 7 Apr 2021 11:57:05 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shiraz Saleem <shiraz.saleem@intel.com>
Cc:     dledford@redhat.com, kuba@kernel.org, davem@davemloft.net,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        david.m.ertman@intel.com, anthony.l.nguyen@intel.com
Subject: Re: [PATCH v4 05/23] ice: Add devlink params support
Message-ID: <20210407145705.GA499950@nvidia.com>
References: <20210406210125.241-1-shiraz.saleem@intel.com>
 <20210406210125.241-6-shiraz.saleem@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406210125.241-6-shiraz.saleem@intel.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL1PR13CA0199.namprd13.prod.outlook.com
 (2603:10b6:208:2be::24) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0199.namprd13.prod.outlook.com (2603:10b6:208:2be::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.11 via Frontend Transport; Wed, 7 Apr 2021 14:57:06 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lU9c9-00265S-Fp; Wed, 07 Apr 2021 11:57:05 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 56b4edbd-7077-48b8-42c8-08d8f9d56976
X-MS-TrafficTypeDiagnostic: DM6PR12MB3115:
X-Microsoft-Antispam-PRVS: <DM6PR12MB311588E6F6241CE9B7A89F3AC2759@DM6PR12MB3115.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lnmlNHB8FGFVCf9q7mB0vVMFjl4neV/R7EGrXQ92SfhrBLNMqPQcAd9Xj77Dy7Mxojj9xKnY2oqSH6MJYcD0LHHJyT6hSyjS5tl0fjZH4X8pXIe23q7VxrZq4FhM0p6esKLwDbbslax8O+8KMMyOC5nq+fOQfigtUH5fdphD1UqcOLvRKnOxbmexBb8va57VD/X5Z5EWet2dkY6An+KWCQYmn/5fXvjFPVBIh+bN4QinuKu441IHK1UyXvIuGPLFtVkY07lz8yC6Cqi4wQ4cW3z31WzGag8RoIqFgHigzlwcTH7t4WjePUsVgn4mkpxtNEELaX/sfzVdejn3oGPerWkCvzGsQzfBhTwnreWoRYiakzpag1wrbx1BWtOu6hb3JshreJpgW787O8TZ0jrHrK6GUPM3fxAoyit4/Ki6OALHYv2L9d4PCpEqlVv2JBCdGierSBuDPQ7Lc+DE3WPRTjfsfymSNqmHUbwTY2A1+uBqZvNDsBpSC+/JAo+mflErVm6VardzuZUX/8AfbSp8frK/2PsKyol/cjs7NgMDsA8x/3AUUXXRbLyBhLZdNsC5nIhh0CwSAXWjiZclAAVCDoYGYXazcHDZPs+UVKmuWB1zdtYvYBXNXPfGKZNbE8JX1YNkkonNZOcGItWmMxjCOhfsWfnPZ3VR3kYeNYfBP5xJDiTn5tzw2VfN7+PJTX+A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(376002)(346002)(136003)(478600001)(26005)(66946007)(36756003)(316002)(4326008)(66476007)(66556008)(86362001)(83380400001)(9746002)(9786002)(8936002)(8676002)(426003)(1076003)(186003)(5660300002)(2616005)(33656002)(2906002)(38100700001)(6916009)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?x9vyBFWwTIahn+WY01W0cYbVrYSb3p8SM6QpjgI6Y5IglTfzQflBOFgFgA5s?=
 =?us-ascii?Q?DOPRL9lOgf9UXM8TKnJeNuOheL3w87Q5mN9dfqqxUcbpiq7fPKYv26vlbAPi?=
 =?us-ascii?Q?RgMKGvjQbawUlNt0oxJuTqW4gvO3r1v1c8U95+Gl5/It/Gq5+8IcR29Amv/C?=
 =?us-ascii?Q?vIWtyXsXDrfuEZADq0osUgfdNVEYskRA+w8EKB1+MYVqBrBIOFCHOhqPunEw?=
 =?us-ascii?Q?9WUp8f51pJK3LWe1dBusgfkc/LZ7UbWXX5GohJJLPLfrlRHNwSsmpRIWT6S+?=
 =?us-ascii?Q?+OcsM2FEpJoOieb1qVb/FFtm9hUsyuWj2lbjfqqIW9tYSuRUZhngzB6Mr5AU?=
 =?us-ascii?Q?zZuf07l9G0dY9p9LfQ6AA9fzcg5tIE0kzvqKkHnP/FObqoVj2n0FD1FAU2W7?=
 =?us-ascii?Q?gRRuFt7FA4Sk2V3VbpqdpbvQ83AE3RRbkkRcNaQCxnT37fiHE3PgVHklyq/D?=
 =?us-ascii?Q?WfLwq7jkcZikemml/bmVNaEejaycKwLuqFILYIUPBcdcisiIRZpJ355cXqH+?=
 =?us-ascii?Q?4QVbqucZ1aTo7r45xPAKtx/d48yGqMxCEnEHHz4G9THkON9n5J8ie5linqyi?=
 =?us-ascii?Q?ap3RND3ofURTQI5nQ/sREKZqkbWKrVczKFoETGb1Gce6pQQJ3VzF4mKK/Pja?=
 =?us-ascii?Q?P81wDO1ADD7nXhymSVk3W8W3DPCsjBBbgSGfmKScBzvXgErhMRyfl/Vs53Ft?=
 =?us-ascii?Q?SvQ2ns4WNkGSlDRBzbg2bkr9JIGS6b36xcA4nvJfuZGA+lerGBwL6wwBalAG?=
 =?us-ascii?Q?Und3WQkka5ekTYobkclCCtFs533u8JuGzG/WxyrxvkzVqg4DwEXyULVd0zJr?=
 =?us-ascii?Q?HUHsoPqKYC8AMP12QWXJcfFC9OB0RAYi98IhgWNWgiLS4x9BQzbGGTkC2IJm?=
 =?us-ascii?Q?5Oo1LmYrUIheqMdcD18LbtcCK4IkF2b7N5w7vH+g3B0T5HoLVsVcyzjRfHdQ?=
 =?us-ascii?Q?KFev8aTbGpTApGfdh3MinLxyhHFNg1tbFAVawsf7RdLPMdvk+Bm0pduYpmTt?=
 =?us-ascii?Q?HXZ/PycWoDV5YoYZ4XuBvcfzo/6oQoBOPyU6NVyDYr2Qo0NQHJYvkd6OFb64?=
 =?us-ascii?Q?wndcOVkOPYOC/TNQPYxyhDgtexLauinxzTlg8GYDTdrX72OXsfE/F0T2CvH0?=
 =?us-ascii?Q?4TqMpV6eftbnF8m4WMqRz67yYG6a5Lyr+PjGZ4UP1SiaQC+QMEarKLpC/IpX?=
 =?us-ascii?Q?IQix3XysSkFA8MJzhRRwxgmxQYXBquzpM+9afi1phCObKRJWnwP6aBhHhTmY?=
 =?us-ascii?Q?TFt88DXKQ7TSNkDdfYaQAosH71xg/0Flf5TxQM7zVzeahX6sLBRDH+RXvmgS?=
 =?us-ascii?Q?0MwE21NT2cZ0ex6ZebnwL2mg9JgXuOgh5VLRk78KJsOXQQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56b4edbd-7077-48b8-42c8-08d8f9d56976
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 14:57:06.7332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lRH+HC9ffIgYz0uLIBU6vEWv56YXpBH60MfOy+vmqqWqP6En9czTeBS6j89PGgNb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3115
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 04:01:07PM -0500, Shiraz Saleem wrote:
> Add a new generic runtime devlink parameter 'rdma_protocol'
> and use it in ice PCI driver. Configuration changes
> result in unplugging the auxiliary RDMA device and re-plugging
> it with updated values for irdma auxiiary driver to consume at
> drv.probe()
> 
> Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
>  .../networking/devlink/devlink-params.rst          |  6 ++
>  Documentation/networking/devlink/ice.rst           | 13 +++
>  drivers/net/ethernet/intel/ice/ice_devlink.c       | 92 +++++++++++++++++++++-
>  drivers/net/ethernet/intel/ice/ice_devlink.h       |  5 ++
>  drivers/net/ethernet/intel/ice/ice_main.c          |  2 +
>  include/net/devlink.h                              |  4 +
>  net/core/devlink.c                                 |  5 ++
>  7 files changed, 125 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
> index 54c9f10..0b454c3 100644
> +++ b/Documentation/networking/devlink/devlink-params.rst
> @@ -114,3 +114,9 @@ own name.
>         will NACK any attempt of other host to reset the device. This parameter
>         is useful for setups where a device is shared by different hosts, such
>         as multi-host setup.
> +   * - ``rdma_protocol``
> +     - string
> +     - Selects the RDMA protocol selected for multi-protocol devices.
> +        - ``iwarp`` iWARP
> +	- ``roce`` RoCE
> +	- ``ib`` Infiniband

I'm still not sure this belongs in devlink. 

What about devices that support roce and iwarp concurrently?

There is nothing at the protocol level that precludes this - doesn't
this device allow it?

I know Parav is looking at the general problem of how to customize
what aux devices are created, that may be a better fit for this.

Can you remove the devlink parts to make progress?

Jason
