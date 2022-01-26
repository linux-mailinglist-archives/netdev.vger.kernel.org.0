Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA6CC49D48F
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 22:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232606AbiAZVeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 16:34:02 -0500
Received: from mail-bn8nam11on2051.outbound.protection.outlook.com ([40.107.236.51]:3424
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229516AbiAZVeA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 16:34:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dCODws4dPKWkyb6pEz82Rgt8JdfzyOnyT+02CsxJeceVYThF/yrdtF+ZLSckNFBdCUQngysIHKnQiqVfOKTZ6c0pftLiyhAT450GYp5obsS29aZHPQOJHsZOs/fHvvtE65Ke3/BbjjvVwt8au6GQwK1oPZ0fGIu6B0nA5Pd180/ht8rvpnFYrZGwWU3f3a84EpK5y0ZKkLCamvhS3gbXqiAL9+qAbM4Sg9SFFjAsjuQUIlT+Di5jPo9Hl8irssMjSwCgS59FeT/HpdgHVZ6K5SDrqGJ8VWEtz4uxmNMF7krjVN7zGJOXCg2ubOPHTKprKWX0GxAjiC8kHRWYl4Eodw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DpG/ZPoAjZjVXMh6LkBZLqmzyEZCzsRclQA6Fs9f9JU=;
 b=SuKh827HtX4tV0ftt1sE7Ex4ParE5xLkYXRlNg9C5e24g1iNKxaDC+ui6n3czLz67dhif70f95fHl/A7k0M+DlXOuMfZtlfDgt3YAYZ2CgtZryq9o1b4XyULuY8Es6LTT4Y9Iae76f0rVoTqrtlD+xiHP0j2tCrCJ4x/JT37wySj/2blDsj5sK789/6u45X0AL/NXe75/NZIddB9E6Jn4I1mjtjcB/FTWprJvxrADH2lPJx1v4Q1HIrlNMy3dWu9E/DufJYvKpOnCCpyyVOI0MFg8pXPuKTSssycP8ZRPWP7EiDmpYAdeLI2D5dWsgok1J8xOE/UraRxcVSeqM3udA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DpG/ZPoAjZjVXMh6LkBZLqmzyEZCzsRclQA6Fs9f9JU=;
 b=M0xFa6I6SWkjwY6Yyc4m3aUrSRupdgu/19IhglNHJ0+RMpKKUsVWq0GZe7eRZkVSVG+tYuu/Vx2PBq6fGH4VvnwAn6Bmp1P3i73RLcmb9f+74IuejYJSK+bcWoLWckKtmHS2VnRDVtyk5zlfCHTGyfKhNj0agI4/E+iwJRdhwJlvEfIVQq3TKgJJBWqIeGhSIdqyh3PVXWUmMlLEQ1dfdfrYy3zuLJOgu/tLyKGVEEdwtSXOaFO6sJld06mOjbnA7IWq7FcE2crSG2KSuRO/MNOQ2Ww3sExc+qf+lvRfFP4xeHfOe4FjbDYsVuQDxHTbZRdYN/DRU3YRhK6cx0hv+g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by DM6PR12MB3803.namprd12.prod.outlook.com (2603:10b6:5:1ce::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.12; Wed, 26 Jan
 2022 21:33:57 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::35a1:8b68:d0f7:7496]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::35a1:8b68:d0f7:7496%4]) with mapi id 15.20.4930.017; Wed, 26 Jan 2022
 21:33:57 +0000
Date:   Wed, 26 Jan 2022 13:33:56 -0800
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     leon@kernel.org, tariqt@nvidia.com, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] mlx5: remove usused static inlines
Message-ID: <20220126213356.xysgbihizzwh5wbe@sx1>
References: <20220126185707.2787329-1-kuba@kernel.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220126185707.2787329-1-kuba@kernel.org>
X-ClientProxiedBy: SJ0PR03CA0283.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::18) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0df5aec-69b0-4f05-acea-08d9e1138f39
X-MS-TrafficTypeDiagnostic: DM6PR12MB3803:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB380350B3F28E08A7465317EAB3209@DM6PR12MB3803.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WiNb9/cFHsOTKlxPTFV/ubQUfwFEPLtcqTeUnw6fByvhqEfXvk7kqJE9AE5tr1IP2YIkOogjMk1/rvbC/JFHaR54UT5lk0GObGcdooWFQZdK7r8uOc5zC846w7fIUr0IK+tCW6RwG/RqPRzYCY45MbtmnAUfA3salMcsQw4FkOBHnbmmTEeYsiyFFODgHJYIqJiHsNxmgKqS6jz+JRAz/qzS/SRch39eHDY5ENNXK1krouFhFdPDXzA1dBl/I6+SeZ3V0dXt4im+F6fc3Av9acQ99J3/FJ660Qoe5HP5L3mPMpbo+1GuxjIGXrZPjmKu2Oi8p7FRX/VLW2OtvjhYrnajDe0cRhiCFZBMMuvQpMOd45XwW7IRIvUqsUijMVx6eRI78DMWUQUEeP7uxxGyWmqTieEiB5TY/yepNC5sEQ5UDtqIm03m1mb0pzuYdXvZIbEPBNzcJ2Z3H4gWglpz6blSlQDFI1osEj/wnjug2SRZuzCxpN48y3GKo4vA7tKC3uKirO66KRROKh/VSbI+sopdyFBeCir1GOfsfg6cDbj++eoVeHp+iG2A5YLUXkg33HLvVeYhFk+l3rUoYF2jopjsjk9OZuXA7BtbU0W7WR/G6I/rk27Yvds5PJCg+cdW8Fh6B2Hm9ZvVTfPOZqbMudr15RfyXSqPAsy4WkfVIe8YKjcVGfXcDTvop0oz2ge3Jkl6kHSVa0ZY3s/uHaIJYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(5660300002)(66946007)(66556008)(8936002)(26005)(6506007)(9686003)(4744005)(2906002)(86362001)(66476007)(6916009)(6512007)(1076003)(316002)(52116002)(186003)(8676002)(4326008)(6486002)(38350700002)(33716001)(38100700002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f+wCf+5gqfNZv9fE98mwSqiK0w2xpaQoRMZI6b1djrKWLQH0mi/PJT0MOyZj?=
 =?us-ascii?Q?mS+iw9ysYC7buG7gRSBHud7uSMgLRmbhQ8CCHT75ArlHi8OTDFYKlHPswHvl?=
 =?us-ascii?Q?XCTJDaIif6eZVEOwA2mJBqTByvbm77uqqOJPA/UW3K9xuW/UcLnASgrj3iAc?=
 =?us-ascii?Q?R6LUi1zgFSws6JBRRbwV6hbn3UHAdtGIRCf1KGQXG+tm+9LrAMRuE2+Wr3Fr?=
 =?us-ascii?Q?5pj0Tle7PlgyY7c0aVwsjxfDyXqcwA690Qn0/n4ST01EA/BsuGGiTUkar3ze?=
 =?us-ascii?Q?ZbjY6Su0pkWQo0qH81vMvxRgWeIrKNZBXmj21VgEhKV9WfKXXYDx4Tpbls8d?=
 =?us-ascii?Q?khM8fRFjISUq5O0be3KBS+y5kH86+4DcMrZFU+7lhtWT1yRBYY20fwbYu+o+?=
 =?us-ascii?Q?L1+OOtwZ6hkDI6XgNfey3yYorYyBArPB7Yh4vizuzabvnntp04IWSma9otxX?=
 =?us-ascii?Q?J31hAhTkWFJCXbtage5ENIrF8QZMQdUDF0mvMI7yXF0CH7fdj6u60WkW4eJy?=
 =?us-ascii?Q?UJ8uSx0brBoJny48BrUii94VQSSZs/ihN72ReZF9Alav3KrXxedKv4op51j6?=
 =?us-ascii?Q?NZuXrP44/16tKH2pcX/KzUmdSLeXSzcPqUzksqpbKY4lBMIIXvmNie/NenxS?=
 =?us-ascii?Q?1bqjVYbmsQJ7JnNRJ9HLyIzmNSfHuIEPSew6FFBy5wGk4oui0is6QDgsMhh/?=
 =?us-ascii?Q?RtM1DT5f7b0VYTCSfIQVVPvctXXRiYDqxq23f4ya2jkbxUzXiKpW4nusc77a?=
 =?us-ascii?Q?G5pCzbSCKgFWlYMouj+g5wUaHncqde5zehzspJpV+V5yrU7d0a8atYe717pk?=
 =?us-ascii?Q?dkgx3azIiUTCzSEc0RuXKcRYrrF/jPixI4XWt/yX2p5wUDHMs7lV2uY8cYnO?=
 =?us-ascii?Q?5HX8TVkRIVeOS4WOo5bGLGdZOCUXF1+BlzGzKIscjiegur2ODV5DLVluCLuW?=
 =?us-ascii?Q?I3uqosRfes1DpSKU7umRE6XB5lZRGmcjv8PPiafLCIn6N/fXuDBfXu58VdIF?=
 =?us-ascii?Q?MEInjp4j32o/uk3d1FC6O4uhgqJD1b/sUEpZ2fMQucllsPupXc2q7O6kVN7z?=
 =?us-ascii?Q?YinDVLvwAvPjZZla+VJeYN+tuxpSaHkk4x9dHQByHSXBCZ8auBgNLpeWepOl?=
 =?us-ascii?Q?ILRtiXxrqGh7SmlzIRArzkfB/gGWYdVqY+KofZBskMfXKL9VewcBzBVizpiX?=
 =?us-ascii?Q?hj5kw2SFa3UswkhwmLy5zfcrlTsUmKWx3f08cnHO4nPGPuhIf1AvIoYFgDxP?=
 =?us-ascii?Q?fqzn9SmlgFmJHvTl5XUPuFaGDFp1FWkSo4qfR7G5bgBfO2eUyH8+poVxNbHG?=
 =?us-ascii?Q?4aqZvIU+vnajhYmHbr4VFB13iOfmwRNR4Evb7HNJwBAWYuoMqoTYpqaiYNY2?=
 =?us-ascii?Q?bKUJrX3dePDLhoCpWiqesuovsgWAxKF2HbXy74Fc5h9MtQn4/OB8MPfBK8ys?=
 =?us-ascii?Q?2b+eOOfK0ejvTZkCVviebH45+Tjh7Nya1xKpcgzjzfL7CHaNIEVftyQag0BA?=
 =?us-ascii?Q?yoYr/KjrEtZ5cP81GNwk5D5+tQqvuc0RyTdGrh9GN3aC//1JrvfBM7TS/yhm?=
 =?us-ascii?Q?Kz/GBw9HNvVTA6xKMscs0sEtf/JZbZFAGPiHl83gxqxXVbw46GhiIO5bD9xO?=
 =?us-ascii?Q?y0RkSloUdgvlP3akDKtRYNE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0df5aec-69b0-4f05-acea-08d9e1138f39
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2022 21:33:57.4904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R5FjfFsRhruL8C7oQXxYRmq5XiTDB3SuZcIQNKvTclMYmtyvNrNwXdwYGwYefaKPd6ja1E4YvqFiC6Bqkk8vWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3803
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26 Jan 10:57, Jakub Kicinski wrote:
>mlx5 has some unused static inline helpers in include/
>while at it also clean static inlines in the driver itself.
>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>---
> .../ethernet/mellanox/mlx5/core/en_accel/en_accel.h    |  9 ---------
> drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h  |  7 -------
> include/linux/mlx5/driver.h                            | 10 ----------

LGTM, applied to mlx5-next.
