Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 771E535E6B5
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 20:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232890AbhDMSzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 14:55:55 -0400
Received: from mail-dm6nam10on2057.outbound.protection.outlook.com ([40.107.93.57]:61441
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232517AbhDMSzv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 14:55:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QNooMd+APdd6kzAJelvW4Sl03sVLPZZ0xhsvjoBxezC6jE1gkZYOCRZeC2UkxMLOlCq+Xb6X1Rqh5u3ULcjHWXuGJgUESkB+Qan0lJt9nTl6cbtrO0xWeoqg3EqjBgGXE7oT49qLIht5yNGIsQY+ec9x2W1vuIKZe+TuwmS9UunLbXdFODCEy5FwFFDwICwiv9VH6GblJOVqXUKYU1KJ4yVFkq38qcfzzHwm8DzlvRQEr0Oi25+0X2CBcPpBz1OwdA1MVcDsk58FsTDcITpzwfNHrqRrT1aaFZKrCnimXTrjKABOnClvM6O0+76qgZkroFSk78xiYfMs6IV4KA1hDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hiZH1fleDXHqOOBN5vJzaB9DLsaE/ZBNosyDEX1GUHs=;
 b=AK9V6t1V3d5oCa7MBVODAmg682JrFgqr9q5JLcsItMpg43G54dPHTReyXZrjYvHZPuYDMWJOp+DslPSaMlaoZ4dbHPFTfOFokt1QuqrlbqwmaZkfupLVzBrI1F14XOt81SazK/IMgRviqmT3fJUwJ2mBbpV5slF5Q690qovgIKH5byCf+HerfrnC36WBe0ONl4hnLuey1ll8JvvJeVrgSsyOPqTKhNaWZuiZj8wSzSvQPCTB7twTTtycsjmrpAB0Tc5qHI86e92pXL61CsO4LOOXwVB5RcLdCUmlDdATr9bMb6fG2IR69+tK6/RJrQnUpfVboC0HIWZn4pGSq2hmLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hiZH1fleDXHqOOBN5vJzaB9DLsaE/ZBNosyDEX1GUHs=;
 b=Q0tXCTmVFwP0Ys+PTjluESnQGg7Rx7UNlPpVO36bJktITiMLJGnB4vT04dqLimWiMs2Fuuk4StHfNcbgh3zaJCh3YRljerBC3Uyu+VeypPZrhKvy/ZX8w4RWvug4fFhPEgLNnomdo7b1a02lFCJrH1kWUUZRhl1pnf9/vjkX09ArziIlWWuVHYADAW2BZDvekOKFUKfUgMVvEX+/NVEOIgLILr+IH7DCy/LpxaOnV/XTfc3YFDFCYYMwOLoQJUUHiqALx4LriCikGlXg4udIiIn4bbtRvc41lUFiUUeCSTa8bgfF5j5JM0isknMYgOo3VB+r/Hpp1OfHF4nophAwcg==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4010.namprd12.prod.outlook.com (2603:10b6:5:1ce::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Tue, 13 Apr
 2021 18:55:29 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 18:55:29 +0000
Date:   Tue, 13 Apr 2021 15:55:27 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>, linux-api@vger.kernel.org,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Yishai Hadas <yishaih@mellanox.com>
Subject: Re: [PATCH rdma-next v1 0/7] Add MEMIC operations support
Message-ID: <20210413185527.GA1340003@nvidia.com>
References: <20210411122924.60230-1-leon@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210411122924.60230-1-leon@kernel.org>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR02CA0008.namprd02.prod.outlook.com
 (2603:10b6:208:fc::21) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR02CA0008.namprd02.prod.outlook.com (2603:10b6:208:fc::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Tue, 13 Apr 2021 18:55:29 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lWOC7-005cbw-W3; Tue, 13 Apr 2021 15:55:28 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b45b7496-dc3a-45b5-f57a-08d8feadb4e9
X-MS-TrafficTypeDiagnostic: DM6PR12MB4010:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB40108272F9626604F53A327DC24F9@DM6PR12MB4010.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kN/NkMZUVGpap99Zi3ipPEApJelwB+zTdINud69ta0se1bnWaEYK1ERpdB1Iau839cqGgtnleIVOQ3S0fCoD4CWs/ztRpS+vVakkK6o0vAY2tf+U4djw8mM3xRD9i3ovVbBCZbSfl544XsV2y/nrcgOxbtYusfVXQ2wbLjieTG4aHnebdTYZMYdRIa5B/goWb+EPW19L5B05iUVLDjviMPDh1Yo2kZQMzMImBpsj0n3saoFNsAJXswmiyvavI2lcQBAgO0AvAW5fScYiODBljw7TxYljlKy4RGL//5Ym1Igxbi+NE4G6mfdWUaRvRN3sewaFv2QWTk269Ju5ibBV74ttsx0yMp5JfALn0cPqjZDvswziDcv9z/lCavFMUzvfnH2ciHkPZK22duZehlMRx0+NvdggvUmEuwV6vyFEtRRGFhoKvCxHm+ZxLnTmYeyhOQ2IktAtxzHE5HWVngHOOROpPUfZwYZjjTT91MB73Rznao4dhp03HNiuyXvC2XkMGFonabVarVFzrWO92+QyNKx1D+fKUExHBla2pEpLspIGtALP+AR4shj+NuBAt1olmfleE4rJt/Rcy2eGD+7YiCOACeEX34e8DXlzffz681VcHf9LPrwytesh3tNJOpGkdLWt7GP2HVdixMVr7GrI0IvAGvh5dKkkMrzHEyOyYaDNBev8mxrU44f793/a+4o2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(136003)(366004)(396003)(26005)(36756003)(33656002)(9786002)(2906002)(66476007)(316002)(107886003)(966005)(186003)(4326008)(9746002)(426003)(83380400001)(54906003)(66556008)(5660300002)(38100700002)(2616005)(86362001)(8936002)(1076003)(478600001)(6916009)(4744005)(66946007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?JAzvw9qHItfFa123LgbduuV47IF1lNhNS+MbNSPH4Ruzuo/y343dy81CCQLG?=
 =?us-ascii?Q?3xY1N/4zq+2Pxt+Hp10td5rAklgsu6VLl6TOGZ3SsXDPYcxZaYi+Jz51KsK8?=
 =?us-ascii?Q?aGyiMVibuvwpPSerbHmtAWucHFjGs4T4fr7GwiVzQNHjpPEFt7sUvdJRxXij?=
 =?us-ascii?Q?q5qX0KK42v9QL14DzXXNUzIeYhE7SbtK78/EtjFYh7Ru6OETBkye14eGqoO8?=
 =?us-ascii?Q?/a3/+hsIoL7vGycCo+YxPJjvZOZzHC77LXK8ho/DgdIrcO3U7cJhE72P3W3P?=
 =?us-ascii?Q?hV7Ofc75yoMezcUM3gkSeMsJH3BKuZ1PT7sVp/a8bJs9taWuE0KTel+wrj1s?=
 =?us-ascii?Q?gCYDI7j/DC3sRTKv7Tpo5/s6h8nPUYFd41nUh7nBzuX6zwQrahO8A9681/oW?=
 =?us-ascii?Q?8A/tFhsyEbRQIZTTH3HRGXgH9hMcLEZM1cj/jg7jD7VdND9hp/ts0ryZfBML?=
 =?us-ascii?Q?eP+sPrWGKRvQVi3gL8jb082rHKWoyk3pBaqQQ0vq88rQHO2g037u6/l2e0lq?=
 =?us-ascii?Q?X3yBo7cbXj0+/OLp8ktr+o77Ak1k399i7LD4M2iv7wvim08gTkh33U1471lf?=
 =?us-ascii?Q?YmX6v5QQ1IhKo8FIH8/6HCh/9cM8zPmo28skBG0HK7X38bWlEYUPVKizodS3?=
 =?us-ascii?Q?A0U9wCNQJD9bmgdiLc1QxJzhsgBvOr5kp1GJyAWxLOxUi8Vb/OnlVbuuSa+0?=
 =?us-ascii?Q?hKgOIZsTW+yKx3TrNRyY8/6JhpBPDzN1FlmWjVR+x+waLjpITO85YbL+Ovmk?=
 =?us-ascii?Q?3eiqGq0lre6g6NatRwNyYuZ6Dmm+NgkJOEDHCOnffPB425lxd9iPY+plhIKB?=
 =?us-ascii?Q?JyQjxjAJLbUzQt7TFVJyhUUbjI2F/yU0oG/OzVV8F/wRNfXOUs5iDkYlQT4M?=
 =?us-ascii?Q?O9S1Bw2xVrdXik2qy9QWnRTelDsk9DtPmajemNOAQ58/mKEPPEpWOHYluajx?=
 =?us-ascii?Q?BJrSM5NtVqdbY4aG67gxoBWvLbtM83pQZPZ/998pS94i5+Qwes/7ePNGWkuV?=
 =?us-ascii?Q?ri09ZBeJtbcJEDCEumLVbJfvsiDhv0WK1LSN3527i6pgS9D2Qz2udvkehe4m?=
 =?us-ascii?Q?60xunsAyBSk5DNl5JbXeooIJbVk8ceHZc9tJtELJ5bke9twRbmOoRqnplzqI?=
 =?us-ascii?Q?JaJ0eBqwKMCwqP727Q0PGsYT2FpeZONU7p0U8Q2suUeDDkGlERBvOFLzvhmq?=
 =?us-ascii?Q?hen1RJHsVgj64DxYS0PegWtFKtoSq1M+CPlxSuEhuYepqcsRb2fGKchpNoRz?=
 =?us-ascii?Q?0y2SXSdygMX1dDO93jWF7zKwja0iEzp/n7hn6toCwG4Dhw587eojBzF1IcCx?=
 =?us-ascii?Q?N1PhwpXhU8qkcbp0KhqZ3AS69HSGkr22J7aNm0WWEjSqmA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b45b7496-dc3a-45b5-f57a-08d8feadb4e9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 18:55:29.2883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rq8tP+GWodIasdNTCmSjNk7vpazs9nQ2hvxPEvArXcFjawNf4+JqsZjoFBosdWhp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4010
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 11, 2021 at 03:29:17PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Changelog:
> v1: 
>  * Changed logic of patch #6 per-Jason's request. 
> v0: https://lore.kernel.org/linux-rdma/20210318111548.674749-1-leon@kernel.org
> 
> ---------------------------------------------------------------------------
> 
> Hi,
> 
> This series from Maor extends MEMIC to support atomic operations from
> the host in addition to already supported regular read/write.
> 
> Thanks
> 
> Maor Gottlieb (7):
>   net/mlx5: Add MEMIC operations related bits
>   RDMA/uverbs: Make UVERBS_OBJECT_METHODS to consider line number
>   RDMA/mlx5: Move all DM logic to separate file
>   RDMA/mlx5: Re-organize the DM code
>   RDMA/mlx5: Add support to MODIFY_MEMIC command
>   RDMA/mlx5: Add support in MEMIC operations
>   RDMA/mlx5: Expose UAPI to query DM

This looks OK now, can you update the shared branch?

Thanks,
Jason
