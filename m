Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59E4A42C3BB
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 16:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235592AbhJMOpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 10:45:14 -0400
Received: from mail-dm6nam10on2087.outbound.protection.outlook.com ([40.107.93.87]:45312
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233023AbhJMOpK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 10:45:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DQyX8WBcYjyAcnZuMm5XMWAT7EKDDbujpVDUD5yrGlCc7xlVkDz3DIn/YTED3WIjTRon/tvynpvO9J65BO06b5k73LB05Ky0XgXrFxBH0kf3d4NPqDHaHoa9gY7r5W3NNOxTEpqwJszguqFk4TmQAxceTcZyVZrpyWNKM2YgmrdxXmJMOCkbdqKtAUzM6ZxcmSHZzx9ei3tdBrxrkzAkq5rrk5y/K847WBlttkU7DBdU72HhCTJFS/051cMHUnM7vSj6+m/q8nN5kHlHo05AQf0JcX8yjHsWq+N7EKPaXV6XupO3oapvbtfE+sK33uen4qz7Jd+YKqae4gaiR7GcAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dLrqWX4+aV3fwmWFmqbUkHvFItJYu4buZBfBYYqYDUE=;
 b=nRR/hVwruLqD3L89+cfn5aQovrJZNPHuoFkhBzzNWZOJwHg2VMaIeLcIrG0rvw0hNroSYy9oJFTjvKTeYwlHjlF/xof6UcOGf0imaUDHSVNrYdmqlFUDcCBa+7IIswwqXdu4PyuZnNcC4JVvCnHgZx/QU8bz9n4OS+BaALVQqlviPYiqeaEWRKmvTwTo0FJluCqK8Ia9/kQoD/0hAA0+Tx2LXX1lU8HfYm5cvFj/reh1Z+eKw3cWxh/ARoH6ovaH2WlTLUIZTiCOV4ylqyja+fNm+0D2s6FsEu+ElCD1ZqZWH492uoiKcoGY0GTmtcAHMQqkf3g1letAFpuNaS3yOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dLrqWX4+aV3fwmWFmqbUkHvFItJYu4buZBfBYYqYDUE=;
 b=c8i5jYubG7mI1YEP4a1SRoFBJ5f0mhvUg7dV9DWawbCggOSZ8hTO1iV1iy3QopdMTri2iCSuoGbf9NU3W/hOONKLzTRPR+2CFSnjrXPi/A1soOpXRofMOYDuJB7ICXOZpkerlhVJpKfyYIzGYnGaibZdZnuAJIQiWbb68CNfCgAmu7YhlYAQs/eDdanmi0m17cceijkrcJzT0ltZ+TTEhJpQDA0a32CMy9hHLzHmdH4EhqpRBh7V1sIRoEuhECLaJ2d4y6k+iq2d0Hvz56Mo8gdWGC5/G96AFyFzz7cwQZRgCYDhUVt//JHvXjqN7KRjdRpQuECOPu7DNLWQH488cw==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5142.namprd12.prod.outlook.com (2603:10b6:208:312::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Wed, 13 Oct
 2021 14:43:05 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%6]) with mapi id 15.20.4608.016; Wed, 13 Oct 2021
 14:43:05 +0000
Date:   Wed, 13 Oct 2021 11:43:03 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Aharon Landau <aharonl@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH mlx5-next 0/7] Clean MR key use across mlx5_* modules
Message-ID: <20211013144303.GF2744544@nvidia.com>
References: <cover.1634033956.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1634033956.git.leonro@nvidia.com>
X-ClientProxiedBy: YTOPR0101CA0014.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00:15::27) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by YTOPR0101CA0014.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:15::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Wed, 13 Oct 2021 14:43:04 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mafTD-00EVV8-2s; Wed, 13 Oct 2021 11:43:03 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5dea7020-c905-42fa-6d65-08d98e57c3c8
X-MS-TrafficTypeDiagnostic: BL1PR12MB5142:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5142F3A278053F79E7C035EFC2B79@BL1PR12MB5142.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1vdzcy6E3TZ3ERgfnvXm808D1XFus3HQEJf3KSDZd+AxL4YL8/mtQ1/CPJD7VjBRGB8d7EdEdixUrNgM/EB5KRO1kNnoZto+DMjonrcfl/3MJYkBrS6JPdb0gZeTcyvY/c1+QQ/2rzeP9vZCd9il4WmB2EQl98v0ahK/j1AO6HMZVp5J55JlLPiT4k4NvZCYlHAfba0/qa8vVjAeXUXEwO6Y/ABoNCvnrv6atOCji4Oh3IR2XXiWNOV0Jj9Dhj2diipv3Pcs5pgLkcmCTv9r81bQKew8iZgGHZK/59WHndc3ShAOuM8p9LMVtqeNkhELgUA7SuXjxrEtInA3RGYDrllMgp6/udcWnHBtbNJl6TnKbZky8DZ53WTfOqXgCZvvySpvYTArMpp7Hr0CCoOubnYDYxF+9FnBchED2uWVlsNhwXJscy30F0Yg2ophDk2C1S0/CgwCCiYhibA2GslnVoyOVSinag9uF1X3ThdwTX68hvcy3HpBtIuOlSTRQ+CdqMoZV51J+sbRk/CIIbsleXT9fxMSKo7APhAOXcRQzIQrrv0+8T+m2YKv5JIi0E5l6yw7rQ1PK38YwbmB7kw7R1TY09OdpCK+qcogUMyj60MmL0RKnkS9wixMuoOkAWvA5Sr9J8YqlWF3HVHngs49Fg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(1076003)(4326008)(36756003)(33656002)(508600001)(9786002)(9746002)(6916009)(8676002)(426003)(186003)(26005)(2906002)(316002)(66556008)(66476007)(66946007)(8936002)(4744005)(38100700002)(86362001)(54906003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8XLINhkJvnMZBxHyM5a6IXdD4xVcGl94rgPQZN4Q6D+GatNv2xKmD5XRDKs+?=
 =?us-ascii?Q?n7+5Todsds15Kahg2TpVoqDjZmLPnnkyxiaFMsNXNsSHE99Ha9q2tmm0D3YB?=
 =?us-ascii?Q?lmfvFcixFb8gffXMAVKW3bmGIl3uNBHJ0Lj6epHOUYPsk7gaZPx+BfS3afW3?=
 =?us-ascii?Q?5Tjc5uPMrKkEzXliVL71uah4B5VPt445ItFf5HXJL35W5s9UAYBiScODTQ3j?=
 =?us-ascii?Q?jCoNb8SxLsBkXDshcuIacfllEpbOlvFz9naUvEApu7peZSuCtUOr7WnQzPIT?=
 =?us-ascii?Q?6Klco+A7cAihxzooZ1yf/UZlZ2KK0/JKD6sMz4UngRrH+1NtLJHe5Bm+GALv?=
 =?us-ascii?Q?JWmW5N9r5siWwU/uMGfLxxcQNMZtONIF2wLhyKM8tYio5wQEf9acgo+d4cW6?=
 =?us-ascii?Q?K48fUP/zlklLIIFP/wAD8mkHwJabldYXw5GttLRBb01V4M0BBTw4v/sHEehH?=
 =?us-ascii?Q?qCLzLwJxBXL/Jg+8QnjrN4zqizyEMxtgSxcwROyhA1f8OkALmtqqc+ZkItwv?=
 =?us-ascii?Q?oaqMQ4J/Rvt19vJVHbE9CwlVHMHekUNpWilDvsAYbfgWz6ewahhbh3ztQNZq?=
 =?us-ascii?Q?OlbYnc1xQt3YfCmuP+PQ9TlKMpvEK8ZgVa/MK5KA79uZSqxJCjNKRGHPCAxz?=
 =?us-ascii?Q?VnZE4L3L+j1TSmro9uGoEJ9QjSWAnWp9iQ1C+rGL19oyuiay1q5yHiAGZ2F6?=
 =?us-ascii?Q?EewE09EYgHw3aQIE8iSjNuzsSP2yGnHDSA9zNEPY8mODrWE9EdlTw0kBN43i?=
 =?us-ascii?Q?JBZQM6KTYqej1E0XfPML2utxEv08/r6xKdfY+fQhfAG3ip3Ovp5qm9JANKSN?=
 =?us-ascii?Q?DykCwOBmPhVNbB4iFFB+A7XAK2uQuf/oguRsKSUGy/c64xzPOBpZh3AU09sj?=
 =?us-ascii?Q?s2q8Gz13JCZWJ1cUmOjwVvvpofv1S1A+BRivNJufylaQXhEOYgWWxprEKspg?=
 =?us-ascii?Q?wIJDwxWcnPyaHqLRhqjxyf3ZNb7qP9sEhgiSjQWb3sngliHFJbkesGYZ/P8e?=
 =?us-ascii?Q?u4K+hIyhcDebicME7g2vOnEF+gjQQwIM45Lo/wEWkauoaBgfg96ATf+n53mE?=
 =?us-ascii?Q?yjN3fzjRS/tr0UR7mhKkGF4E/SVyrq9rzZgWBJ/bSMVLSK3YMyk0gZz0Ktnc?=
 =?us-ascii?Q?AryVgxPq68smgtz7zf3bUV//xTScEgxLgX4Idl7+61nRWFuIj+l0MQBDGMBM?=
 =?us-ascii?Q?QGg5ensyxkOfchFpN2EPbKIHtFb/SJU1fJQsU8JMezgkqGtoalQx/E31Vogc?=
 =?us-ascii?Q?fPGlH7/bAJKhPOK7BYWeEcBrEiU4+qjZpgwB/FQKorSsEvNQDaE7+Xi4Hafb?=
 =?us-ascii?Q?JYJKiHlqnWI/NIxmmcSO0Etv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dea7020-c905-42fa-6d65-08d98e57c3c8
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 14:43:05.1689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V/0nE9zIEuJUjrw0v45YFxnYk5b4zrRNvvcMyKIs0zTXOfSz+F9SQioO6+GvAqqQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5142
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 12, 2021 at 01:26:28PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Hi,
> 
> This is cleanup series of mlx5_* MR mkey management.
> 
> Thanks
> 
> Aharon Landau (7):
>   RDMA/mlx5: Don't set esc_size in user mr

Please sent just this patch to -rc after modifying as I noted, don't
put this in mlx5-next

>   RDMA/mlx5: Remove iova from struct mlx5_core_mkey
>   RDMA/mlx5: Remove size from struct mlx5_core_mkey
>   RDMA/mlx5: Remove pd from struct mlx5_core_mkey
>   RDMA/mlx5: Replace struct mlx5_core_mkey by u32 key
>   RDMA/mlx5: Move struct mlx5_core_mkey to mlx5_ib
>   RDMA/mlx5: Attach ndescs to mlx5_ib_mkey

It seems fine to me, other than the little notes, a V2 can go to
mlx5-next

Jason
