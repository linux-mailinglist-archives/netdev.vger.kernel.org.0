Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0363B5A37E5
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 15:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233011AbiH0NTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 09:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbiH0NTy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 09:19:54 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2040.outbound.protection.outlook.com [40.107.96.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 567A0326E4;
        Sat, 27 Aug 2022 06:19:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fb7nhkuxHa5q1FQY//2IQXh4AJ5MCvXgQ3bw79R/8MMbjbp71kKH49GRXR3YZk/lLWtU0fK2j0waoqrR8b4LN8GL1nbxBPvBfHCo9Ds6xYWGOB71zkPOWiPjUmILGOYlryhL2UBdExZ+5pgU1+ByqEdURqcPbu5bCZW7dO0xnGG2+kIQrIInxh6SBWnhFACncVyKU8ImsRIqFTj9hGHd31TvSzwWZcySqpTuhpKlgmuuiOQ8eF01NfwpayehOAAmv1x2saLFNWLjvEwjnTwXRkJgxlA8VaaHrifbqGK+BXtFvUd5u7TY12/gF/E7ZnYPDVkY0CXPgeHb4Gp3y7gT2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nZNaIzbG6yMX3Xo6umWpdew8C8ARCYMXdU7Pm325wdc=;
 b=bHLJ1/axGlGDqKCSJxCoydXt9bL86x8BxbVhzUpWv1ztSle44Ui1pZveeLVvNnjJwMOqzLaAlEU5XWl7fbJKkvkFEgehD/95SoU4yRpvwvxOJTIgN3wQfv7Gm0pN+pB9dBAOFyYh2/pgHMpuafv2G/S1tJA3/6GGBo0AsgjvNPivTA7RPjRcDJceZV5WunSFjpv+d8I/kRKQ41YIRSAizUHMep8rUsz1PrheAgBAerw4onfKCjhy6EoZsQ5rVs+aVSU5rdiratIjc27bVpBkarCIp9O7WXz8SzXZne+c1oe2GTprxaDuoToicFdwK9JHFEObbOA6J2DRgE6uQeQTXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nZNaIzbG6yMX3Xo6umWpdew8C8ARCYMXdU7Pm325wdc=;
 b=fi5qMQSdGJVSIWYrWtwrnLOdw2H8Funq+Nbaol/Oem8gl8LiFNhwfF9zEHSad8fbP9FDoW8xLAwGRaoPn0WroZMiZuqyhg36nhRApn1O9KWE9Q15lWm/f6UcqF6fJH+BamV1ZVD7B9rRZXDJgQiDpH9KFYm2ugJcR8oXFmXNzFDQ4sc5K1N31cnEGZ/aZwLXi/Wv7uaKiOVZCbETXhU2m5dh2PHLuCqYZeKS2cEVL5xnGPP+7pmGvrkunlWlKYnk9u07uyC5Rv68ei5IAbZJ9AdMFhE/b6+PPBcrPEeL2Ff47CN+2pKHddx/EbXTR5qt7NIYkGsnts2ZoZLrS31mzQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7SPRMB0001.namprd12.prod.outlook.com (2603:10b6:510:13c::20)
 by MN2PR12MB4655.namprd12.prod.outlook.com (2603:10b6:208:1b9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Sat, 27 Aug
 2022 13:19:51 +0000
Received: from PH7SPRMB0001.namprd12.prod.outlook.com
 ([fe80::3ca6:ba11:2893:980e]) by PH7SPRMB0001.namprd12.prod.outlook.com
 ([fe80::3ca6:ba11:2893:980e%6]) with mapi id 15.20.5504.025; Sat, 27 Aug 2022
 13:19:51 +0000
Date:   Sat, 27 Aug 2022 16:19:45 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Vadim Pasternak <vadimp@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@nvidia.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] mlxsw: minimal: Return -ENOMEM on allocation
 failure
Message-ID: <YwoZ8V1Y++bUSLxj@shredder>
References: <YwjgwoJ3M7Kdq9VK@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwjgwoJ3M7Kdq9VK@kili>
X-ClientProxiedBy: VI1PR09CA0047.eurprd09.prod.outlook.com
 (2603:10a6:802:28::15) To PH7SPRMB0001.namprd12.prod.outlook.com
 (2603:10b6:510:13c::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9838fa0a-0cc0-4b74-8bfa-08da882ed2e1
X-MS-TrafficTypeDiagnostic: MN2PR12MB4655:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bZP4MpP+ed2KgTOhj1p5iMXk/cmXBMSGVi3DZY3nP1eptFassvcQx/X37Russ5JAE7UF0IiTA1VPdTuByiQeX78ClZMTtdBHL4Vgk2mJ82V7lus3KFrAsdP207AXXHYQMuTuOlrSF8VL2sSwM645gkyVER5Hy6VA3yInItBiMWLscipD5FLsE/diFPLcMoTA3ReXBDHTa5dRaFt4eCWBrVZ/hwUxM4Kev9YJcC/vIkvk3Cfork+GEsJXzFZgZ7U65UFpPFrg5zOfNFfhC38yEEDk4mQNS/HpN123duvqigqx3fcfnu+7zaxDH/liCy/t6DSOwZjkM+rVIxmSW+dy2hp5g7yIjTlHhdGmRLxdwoUI37ELrxIocHGG4idkp1fmfgVItOZ0GTX5ars+1cRIZYYx6O/xt3yMIRyuiN4BsnI9bnUsGvgrEhhPXKU3oOw0eDZuOB2Rzrj7hAwWchHMm1Fk4uWqmj/SNfkVSLVuvm/YTdB4q52911v+ZjHGNLhX5mwqOw3EqfRsYjgmPUoxiKpDOl/MZ/J13eOTPgwgbQnFQOjsT/vbOel0gy1hB9aVceE7kHu0d/jMy/xM4UkmLzHQK20PZIOn5hjUiuGtpSug045EAB8n8acYXlJqLjgNVikoiP9UeCHTibBNa/3Hx3VExTS18l2F4A6kIAXBIjLOSDfRd3t0t8MHbbdjF8wLEgTU+A8BQPs1SwNWEEHvEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7SPRMB0001.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(366004)(39860400002)(346002)(396003)(136003)(376002)(38100700002)(6916009)(316002)(5660300002)(54906003)(8936002)(4744005)(66556008)(66476007)(66946007)(8676002)(4326008)(2906002)(186003)(478600001)(41300700001)(6486002)(6666004)(6506007)(9686003)(6512007)(26005)(33716001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Bt8vQPyWGqnmjHeXxeP9QtZcct39UDC1L9RtSaFIV2rCxCqUGrQFskOnYClI?=
 =?us-ascii?Q?MvC+UIAmd5Try08kf79YB4b90/WR1vPKmlnVzlrKZ88UJu1B0xTgTkFfLaMk?=
 =?us-ascii?Q?p7S3CjIticElcrEU9tq/vZLW69bORnVx9A0B4pVTEGXRZdmZ1nfm5ZXxsEUz?=
 =?us-ascii?Q?qBqsqekFgetwV+lN/8jHtuZxPW2saH75v01i0LImC9V5Ox1OTB+S56A1evhX?=
 =?us-ascii?Q?CkZWidcYqATQ3jjJ7sH9qthU73rfG9J7c2dhRpMBU8qPTFK4ITRhqXYoNhHq?=
 =?us-ascii?Q?mWy40EHAS0iDiUKPW6Q0XDH7z30Fv5F4XlU4DIudWZRZ5OogGEEsV92PZ1BU?=
 =?us-ascii?Q?KZWm03yepX3VwbP2N5EbRfyYkavqZAfBa+CBRFKVBWdNx+vM0eNUqtpfpsA9?=
 =?us-ascii?Q?gfR3h9kzi8mg/MgB5WJseOGc9uFwoHeVeVIZdlOU10VX/z7ZsTINxfVHUxrH?=
 =?us-ascii?Q?6j8iQ2+qj2e6K8f9ejKiwVvnkwfK1fS902UsEuZoHECuSIH5Nq9jqyMLX+G2?=
 =?us-ascii?Q?zl1E84Z1Mm1d4sZenBvblWL8tOGarZZGm0TBEG+/Jvl1r0J0nVg2UCGZgMwL?=
 =?us-ascii?Q?CxUL4x0ulUVvorNCBn47B3OmchVXJ+bN84gKHXQTtUrUOo1caPTYlqg1+7xv?=
 =?us-ascii?Q?wj5KKn4O7evZ7shlcm/mWMv1Z/YSpSjKxzGtD+x/I855ktKQecRehfm4JrzZ?=
 =?us-ascii?Q?cLsXayPsGieisq1FumFcy7a3e+yaSLWZRYta8O6QeMT1grQeK17/cDDuSKup?=
 =?us-ascii?Q?fQ9jjC9AQ5y7nN4xNY17Y5ejTz87eQGKxDzUyVDDdcY98MXLxbq8VbN+A4rO?=
 =?us-ascii?Q?aeTPIehjNJ3/j0xOcCal7LjDB68pI/xdXXVALGlzWnkrbOuAKKeLUD24qHci?=
 =?us-ascii?Q?QjnvtBpu9W620S9hvjXdht/S8asU9Ub60YGCh/K44lN/DTjJxHj5cINa7Yfb?=
 =?us-ascii?Q?tmaJILZx1NiCaX2WKIHrthHuaJCcJsaCO47EdUSG2H7k+rNCEtBVVfckud5T?=
 =?us-ascii?Q?MC37y7Jc/WfzehO2bFL7X64BwpI5vmQ6xq28udv/8fyLkXG53sl2N3hrA6CD?=
 =?us-ascii?Q?yWKMbmuyIDNT1emB352X3dZOsqustZ9Hu8DEqjMl8g5/M0UVGlQe/ob0jdtj?=
 =?us-ascii?Q?oTmwY/WF8otJ/4XyBVMHV0eE7GXWTMjJ0w+9G+MJwHDPBd/wXjV4e7l1S19D?=
 =?us-ascii?Q?Fm4p39nZR/lokfXj9CBIioAaWJ8GM/E5XOhE/JpRxRgTFqpCm0Zpf+DpAJ9D?=
 =?us-ascii?Q?zYEFpbtcpgFhFqcHkmxbLTYLa4U1DvXdgu6pSUwW4fq8ZVxMMdQybe86+omS?=
 =?us-ascii?Q?WKNEqdItKgmgM63JvaRjGsgnpTtIY1Ov2AsB7g8Xnz3XnFPv4NtmjPd85kP7?=
 =?us-ascii?Q?p8HzsAw3GCfiEqvll64kFG+VVOUdYOfYiBcagEQjNs7gVizDj/ixGVZiQKwj?=
 =?us-ascii?Q?lZq5xTp7EfKYCD+E1PqwCfLxM14YcJWBUgUVzseQ4x83qq0vx6dHb4MzCHqX?=
 =?us-ascii?Q?elmVf9rQK0L3rnYIrnnbOzab3im++EInYOG+WOfj6P3Bp1zM7pESMxldx/SI?=
 =?us-ascii?Q?74nWLhgW9xWe5WgfowR5Do8z7RnDSE2pjJuDI3vg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9838fa0a-0cc0-4b74-8bfa-08da882ed2e1
X-MS-Exchange-CrossTenant-AuthSource: PH7SPRMB0001.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2022 13:19:51.5779
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1XFNO62OZywjIugqCuYLKlA8/ujebfbJPrRMyoh+2rgElNbb9wo66MzON1/AjYEfpPjxo1LMthWzMnq7PIXObQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4655
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 26, 2022 at 06:03:30PM +0300, Dan Carpenter wrote:
> These error paths return success but they should return -ENOMEM.
> 
> Fixes: 01328e23a476 ("mlxsw: minimal: Extend module to port mapping with slot index")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>

Thanks!
