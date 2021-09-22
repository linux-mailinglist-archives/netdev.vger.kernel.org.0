Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D30C1414851
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 14:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235873AbhIVMC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 08:02:58 -0400
Received: from mail-bn8nam12on2138.outbound.protection.outlook.com ([40.107.237.138]:24574
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235848AbhIVMCx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 08:02:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j7zgdUHnck9wVdKrbPmu7tIBnHrTGQAqEQ5+FKQfavxJkZ0uLyGP5Lgu26NGVmhIvS7L2O+hTdnMRDybO4tbQ8MBh1bfbAtfHaiiHwR9mEE/V1l7IP+jINfWcgjaK8+ETE2EOE1SHMOj9VLqv3QqTwGfe9alSsGjgHecjmvaluyR+qPGlf1pBfd0+t0JqTpTfsvnC0+Jliin8a6eBSZ2ig5lHNarR3nldHm8GNr9qnWV2mR7eFMaGV1kRe2Wg8E5QlkkpmQArhIexJE1nhVzqLX2xWKP9NiWNyPl2lrnoPyDad4CUQIWGHrb2z73UXgFx4MtCb+XyNd+rWFB7OqApA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ACAThf4iifXFc+YnNcieQ30gD67W737PY9dxOIMFL94=;
 b=NjCCgrM2lyTZrd0n19VydirmRk+ehvEXCg5vGqeYJ8DkQWUfydag3XC4SqMi7qgdpGCa96hDp4fHhkynE2tKjpvdBJhPB6WtH684JRlTmQt3/im8SuoT3WV2fqqyiJ2zAHXc8UMmCOVAofLlC9oISk1IMABFev8qLr30w2BqfePkZuC2DWY34rV895/9xoBmDPhvWFjF6GELbg3kMCgxpJLtxlwldXLMO5F4TqvKGx4ggiiLIxj5QgxoaWAJybEia7C1FIOfRrAkE5cGW7OwVI2FG4yvc6/oxSyeLUdU9EiQlpWYX/WaIs7FbJVdLA8L0Eb3vjeFEyFTYvLYIp2eAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ACAThf4iifXFc+YnNcieQ30gD67W737PY9dxOIMFL94=;
 b=Jk6EUfMg26eVEyzn91QwW2c3xUmPnjg8BY1RRlIeBqYyglF0cy2AmT0droy5JULRT14Q7spntophOFSK6Plqqd5CYEBPRnA9At2ectWOySz11NnGRreNXBC2mqSHZtDLQRShoB4M4u0sKUz7dD8X8Jdaxe03jHhzMm79vvbNylE=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5639.namprd13.prod.outlook.com (2603:10b6:510:12a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.5; Wed, 22 Sep
 2021 12:01:19 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90%9]) with mapi id 15.20.4544.013; Wed, 22 Sep 2021
 12:01:19 +0000
Date:   Wed, 22 Sep 2021 14:01:05 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, Ariel Elior <aelior@marvell.com>,
        Bin Luo <luobin9@huawei.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Coiby Xu <coiby.xu@gmail.com>,
        Derek Chickles <dchickles@marvell.com>, drivers@pensando.io,
        Felix Manlunas <fmanlunas@marvell.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        GR-everest-linux-l2@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        hariprasad <hkelam@marvell.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Intel Corporation <linuxwwan@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jerin Jacob <jerinj@marvell.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Linu Cherian <lcherian@marvell.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-staging@lists.linux.dev,
        Loic Poulain <loic.poulain@linaro.org>,
        Manish Chopra <manishc@marvell.com>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Michael Chan <michael.chan@broadcom.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        Richard Cochran <richardcochran@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Satanand Burla <sburla@marvell.com>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Shannon Nelson <snelson@pensando.io>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
Subject: Re: [PATCH net-next v1] devlink: Make devlink_register to be void
Message-ID: <20210922120105.GA2994@corigine.com>
References: <311a6c7e74ad612474446890a12c9d310b9507ed.1632300324.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <311a6c7e74ad612474446890a12c9d310b9507ed.1632300324.git.leonro@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM0PR04CA0111.eurprd04.prod.outlook.com
 (2603:10a6:208:55::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from corigine.com (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM0PR04CA0111.eurprd04.prod.outlook.com (2603:10a6:208:55::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14 via Frontend Transport; Wed, 22 Sep 2021 12:01:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c862ff7-3688-4c32-87b0-08d97dc0af7f
X-MS-TrafficTypeDiagnostic: PH0PR13MB5639:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB56390EFCCDC1EAA7A92975E1E8A29@PH0PR13MB5639.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:425;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HaqCIVHkqP0utT+GN1R8KKWaZpledsQ0DG4QCGP+DeU+cainAT/EY6cQe52Pf5+z7jKw8txJQvcC2sMMuR4PJkGbxeACR5Grq8KoUwF3vdrZg3moQeL8p2BApiOz/TNPGn7yyM7xuEzstiAXD1KY49Kly0mRafS5e+wdR7pK/lcJ1ZRtozWgXwKXfAXC35hqcU3dGs6t9esXTzjkTLQxt2SK45+N55UXx7RiN/IBb+HvMl7KwvvTSNR0gHCvxn2Tah6aK9+h5Og71Xl/xtuuMS18CIUicDGckFIPvBqpCf3SOFq2Y8HTX3hHT2Nu9Sg4Ciq97qrDFKQy4f86DNDMkQV+cGtX/vI4l5ujEFEJQeOjqES+UinC5NVG+e3n5rQMc8Pr6giAoP+sE30V8cTrK+pCXzo1W4Zbyskyp/F9O18aHu3ncWo/fb/Wd6v56xCbPA8s4z5FmENtmskVYCXMXqUa/N5EZJcqRcawYYuamdu5BjwqDlYLWf/Nm29xgGsxG73oxdSirK64DRyYv4KPTjfvCK6cYw8si1/8yQ4H+ynMVTtjneM1gKXt4QFJz+GsLgVJrHoCC0kf/nzWDsAxK2r6S4vwAP0U7b99xgQDETufxdgiq64LmQLQlMnXAdyuk9DvteHjkHzYznouPiKZyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(376002)(39830400003)(366004)(346002)(6666004)(2906002)(186003)(54906003)(36756003)(2616005)(66946007)(66476007)(7366002)(8936002)(86362001)(38100700002)(1076003)(8676002)(6916009)(52116002)(8886007)(5660300002)(55016002)(7696005)(66556008)(508600001)(44832011)(7416002)(316002)(4744005)(7406005)(33656002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/LfH1fATqQ+jIP19QhGXIsg3npFfDRircl5GZ2mUKCWtze1nrD3yhsm25G7J?=
 =?us-ascii?Q?gL1kB2EUU0Go5mM+FmEIIJIP7xZZDneOrmAvjb+MMzj9KxT+s6X1OiDAd0Ar?=
 =?us-ascii?Q?N7iFaF+kpvfYAlI3UdgrmpW+Xh3ZQTKDYsWpvul4KVQgZpCz//wnINVWuiO7?=
 =?us-ascii?Q?LHzAvxlFTfXZqyAibVb0n+xD+zFkzi3PJCxSBZ7L7F5SJh5diiMBo05gi33t?=
 =?us-ascii?Q?7tSFKU3tQ6stEftSyr3qDF9O+2KPanuYDszft0OyVNMvAfztpWaN+86XppAu?=
 =?us-ascii?Q?psjGN5u53sBYQDDx4rgdxm+FwP1KxbfhhTFzYEduH7YViOFnwut1SqQyWsFJ?=
 =?us-ascii?Q?RfxScxz2w235X3I+oomAV4nsnULRzPY9fa1UUuvubdphBeVGEg84pN+FJRBq?=
 =?us-ascii?Q?xTisbiIELA65s4iJhLaTn/IsfKAXRZmwtH8U2/3tTWbAPUXpv8DrepO7RF0t?=
 =?us-ascii?Q?+Z3hwa6KUepBrcSP1oQxBxkIVt1EdASyQfPeiGyWETxitJWYlkki78QNsV/J?=
 =?us-ascii?Q?b5e0wft/UsOTVKXH8wKq5isp/PWLh2feZHUhXRt8XVP3tzbiAVtof9XxA7QR?=
 =?us-ascii?Q?jkDTEQbOAo8MlTSl2RRBfkl87EdvVGWVkGr/2STkNiZMtoVRWZLzk85LQ4CZ?=
 =?us-ascii?Q?0pTdw54e5wAXqDFfkUGm4WbBjBUh7ypjY6tK/HlZ3MRQFbN4OFgXknZiL0Ik?=
 =?us-ascii?Q?7PB5DGk2OLq5nJrqCKXyJdp4DOXnGBOWeuBKJg0evenGmT3nj94ouFrKdVkP?=
 =?us-ascii?Q?RsOSjwkRNSUhRNHwaqVJJPgXMP9BKe1KGL5w8RrGiz/THYESzvOrubUSDaEN?=
 =?us-ascii?Q?tkMLfYtIOsLI6YFO3TNL1n0A5ZWQNm2Aa4EjNtfYuW1yBS7lbWxVaKzVlOra?=
 =?us-ascii?Q?VGUoOdVM7VacWyi8sWi5kVbjexwDgoW4/tkmfHfjZh3Nw0+sIL9DYECpWjGv?=
 =?us-ascii?Q?g7c8CuEpafFB9Dj2Zw11Sre46gwSp0/PkYc+fNS4hGVM+cA7RSjTz9TQeYRy?=
 =?us-ascii?Q?rS72ZOv4IzzcEWSTMzG25ZPvvX1iH6QjyToaisIBV2Ic1tZJ3tzjWiPbuY8M?=
 =?us-ascii?Q?wgDZR+e1+OQ3+TqbRWuHuybOi1qauLkgtp+oPqpMhLTLVHGgty1wIrDshTQ8?=
 =?us-ascii?Q?pEtvCggwTBrvUtK7tweQlIOxYPNSIQJ+PaKqDxNddV+qZ9BNIS1YbMF879Nc?=
 =?us-ascii?Q?9eg6ik3s7FkYZAg52dR+Z0NJAkdrouCeQDdRRsHY7bjphob+KvwOSQinLr8s?=
 =?us-ascii?Q?AY2BqswSf+wGfJyLiI+bweeZH/T0koqxMgleZ99dLwiwS0aSfT+9nq+u1FQX?=
 =?us-ascii?Q?aCYbuXZLqExjp9WtqodTJTTDkoS8xYWknA+YIF2o0sXw764xvU9Q4xezZrFc?=
 =?us-ascii?Q?51F2es6h1IDS8x+PpF6Hhwd2otie?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c862ff7-3688-4c32-87b0-08d97dc0af7f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 12:01:18.7431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JxfnXCG52sDW2zk9SsKGRBmFYG52UnjgSD8QmaSYnMag6C5JvtSXHRTcw8l70zz2Ii+7fmYFJdfeoaJBMKWes0PR2wdnL/Td7bPQsMXchwE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5639
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 11:58:03AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> devlink_register() can't fail and always returns success, but all drivers
> are obligated to check returned status anyway. This adds a lot of boilerplate
> code to handle impossible flow.
> 
> Make devlink_register() void and simplify the drivers that use that
> API call.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

NFP portion:

Acked-by: Simon Horman <simon.horman@corigine.com>

