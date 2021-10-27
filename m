Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C0D43CE01
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 17:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242835AbhJ0P4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 11:56:08 -0400
Received: from mail-bn8nam11on2053.outbound.protection.outlook.com ([40.107.236.53]:6336
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238504AbhJ0P4I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 11:56:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DTx4AnAElp7Tkvkvyk8e1syzcF1uWBnipzwgB2GRYKJ8RhuIOtEPPYsGBJcd6cliTjVyqxe5/oYQ6pT4m4tEnSrD0QdnxILpTApzNyeOnfnuwygIGMm55dBYH8/lvIcf1I6EYjSEVTr4P8GYlalZC+yUCn9V7D8G+v59uhNWNlZq1c14U/4e3z7rac4d/i2cz9E1wdkjdo97B/XDo6EQb5IE3O8TCx1eDjh0/NcOuArqhyEVoojssW6idc4dO2qiBgp28+LzU9geRCCGhF7qFKM32O/LFo1Z6AVMgDKr5cdxsaMln6eFMRkrqN2ncsYtNP8Y6RlTOkrbPF5QH9GTaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AFI5gbWBjQULfmhHZRh499jbId6qn4vOMXDJQohH7uc=;
 b=bjDVLcAWEbY/zLvQItY4vQwVWob1QcyOBf7kDjKoqPFZfnAttj1VKseW/q9nnXGI3enWVBySpYEKSyyfO5viSdAQdj713CjTmnErOFN10BAIY1GX5IIRHSO+h5ezkmuybSqjKd+cbNV2Nw+Ps65jXta7UhaouWsGDUbj/gcUZV3GOLP0jklO4i99djAxgDPOjwERhTNrpfFtfiYVjQPmbWUko9zB0mf+Xh5jEumnrqfNd2Fd48WEi+h+UkOb3ekQMpUOe9S82hSybzCCpymPT2MjcLtMcGECHtm/aaYxAz8caQZLF3006pe22l56f6Wv5bf+4iOBz0+A2VA/jpymAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AFI5gbWBjQULfmhHZRh499jbId6qn4vOMXDJQohH7uc=;
 b=MXg9ZDFwJ6RnrIioaHeOpEZPiESkssPNxwwtoovv8OrtBnpIF7088/VliWe+zzV07d5fmz6augd4DNZ+N0C+X1DirALZphqlk6Oszw+fa33NSDQfWvA8MiTW6qmkUNhg72rhxYl1pz7ER4uNbuFSgJhv4OxRuWh91XmuVVIjRjXBm1uYEuby2sI2YoMvMxMc3CcXm2zngMEgIteZeUP0b/NCkak0M0LKmty9jn3kxeHPC/zH3NTzu3P2/E4qLqwWPntdUoYQ61OyOBQnULx5FGPS3Vi2hIZvsJNYwsqNOiPyWDvaX+orGryE0Kl7PNSjstnCPwHGJfZ5rLQhVE3Qjg==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5062.namprd12.prod.outlook.com (2603:10b6:208:313::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Wed, 27 Oct
 2021 15:53:41 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4649.015; Wed, 27 Oct 2021
 15:53:41 +0000
Date:   Wed, 27 Oct 2021 12:53:39 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V4 mlx5-next 13/13] vfio/mlx5: Use its own PCI reset_done
 error handler
Message-ID: <20211027155339.GE2744544@nvidia.com>
References: <20211026090605.91646-1-yishaih@nvidia.com>
 <20211026090605.91646-14-yishaih@nvidia.com>
 <20211026171644.41019161.alex.williamson@redhat.com>
 <20211026235002.GC2744544@nvidia.com>
 <20211027092943.4f95f220.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211027092943.4f95f220.alex.williamson@redhat.com>
X-ClientProxiedBy: YTOPR0101CA0043.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00:14::20) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by YTOPR0101CA0043.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:14::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19 via Frontend Transport; Wed, 27 Oct 2021 15:53:40 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mflFD-002cc5-0g; Wed, 27 Oct 2021 12:53:39 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b6a0128-8ab8-47f9-84fe-08d99961f262
X-MS-TrafficTypeDiagnostic: BL1PR12MB5062:
X-Microsoft-Antispam-PRVS: <BL1PR12MB50622242A207977D1598DC1FC2859@BL1PR12MB5062.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7Yltc2ru3ySx6xsQ69wWrBVikQt/dgWR8z8RIJRtfpnB70stmhVlsWIZGcDZJThfoq2q3upEsD3mz0vE6FfbxuRLxxIWHggK+irZCE+BorDTR7kcCVvOYSCYEypLDlOI34XWf4FUIs2J0VzhA2eqeR1wRwFfYxtBOdyxID3B2C9ShQHFf4yWeIUGB5zWmDoARVtR4yVQwV6UXkjQNRD31kS917z16avdk/drDU7R6y1u0Vz7pnIg6q5tYVrEca0C2R69CRr2yjv5KmgXaRxFRIgPB5VQc/8GMRDTn5CJX4T20XNmuxdzQaa8BbikoW+l3x9iv4k3rqaVPcVaRHSMmjEtf/2XPXXQ7h+EOVpfBI1OPjjHTIFMmefpjZ2He8PSLxexRWBPmITN+RlU5YP2nuGb0td1jdmVAeOXQSekDcoDswY+NgOCe6SPU0d9gEqTp5+u9rR1J5zw+es9Um1oghJQppc92bXPCm9E95wx8gtdM4/CJT0KhojVBOjmQmSD+lmvYyh4WMLhKdcAQ2HyTBlvhVkBnt/AD/uQh31QNzFNPvnBT1JbJ0jEoJGI1v1dDON7B93f32Z3tHHjR/xuf7bNgls62jn2NStCoZYj1EUm3RvDZSjRvVD9kRPqqM1jldbKdM+Cvs5/qmekq5EM+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(2906002)(9746002)(1076003)(508600001)(33656002)(9786002)(5660300002)(8676002)(4326008)(83380400001)(8936002)(66476007)(426003)(66556008)(186003)(107886003)(66946007)(316002)(36756003)(26005)(2616005)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ex/PFiwkPgYguRr0xhl54J8GqvrLpFpYqf5tWuxPx62GbV0aIxp4vTMKLaCd?=
 =?us-ascii?Q?ipxui1C/LK+9CYwYrCvoOQ3psR4UcH/IUQF5IH0/ToHBsrHyldAUS5A+QZgg?=
 =?us-ascii?Q?nONNPJ6FhE/kQQaQOp38Tgr9mSUanDbvOPpDV2+uSwRVzExWPzGjW9Akgv/8?=
 =?us-ascii?Q?EizOvTfjuZM8NqDa5slSoAhM6gsfo7tfjNHu0RpVAGjTe71Ic0iFdvp9ddDj?=
 =?us-ascii?Q?MpyNsIP7T1LorYuDYtLPgzxy30XEZs9IZcwWm71JrwPPhKqGZyDLZSFCMNxZ?=
 =?us-ascii?Q?p38GCqu2EwwUL7IkIgkHzgJYh5BjS8nZkO5VVVyHyrC0BU1ZH4sMUl4mmn+F?=
 =?us-ascii?Q?sEhFHQVUQGoqp0lL+6u4ffo+YkRvuWtVt/pkD5FYioxlbXJlxHsMNhjq2QJK?=
 =?us-ascii?Q?H5mrxPZ7oxuZPNbDw2Rj8b7M+0YqGxK9EfUPnjo3jOyIsr8cAF5jz/1YJUcR?=
 =?us-ascii?Q?koctcgdSQV3JafudJm1H2iUkX5iWkcgzLsxMRsEq63rT357KRwEMIp9rktSm?=
 =?us-ascii?Q?R+/aKLXvIYpruFpEhlnBv7ZYWXdvaqxaa5lchHzIuxUXDpu6yELzwBhoB7g8?=
 =?us-ascii?Q?StL88hWHHdFHS+iN2iq0RTLlKatRxM0aIJ59Wv+02p0bkm4RdJrHXRrwyTtu?=
 =?us-ascii?Q?D4ACtnOz9U0q74eNeW36J1lrUeqQ3CzjqhJjXS2hj1sUSpc2vmD6rCKG1EwI?=
 =?us-ascii?Q?jnwzzwV7gQtYUgfiYZZWYTCi8U9yTfFYdHKNAs3IYSIDGznmZl0GpsTaTYgc?=
 =?us-ascii?Q?5hFDfcrME5tNIB7637u6PzaKKyNMZLCnjm/X96HXh4sspcMSs2uN2Uon062E?=
 =?us-ascii?Q?9DE/qxVqhUN44tEVmYT5HLAaa7Kgq2EVdQJ+32IzGC7mCd45jYnH2EPit0tv?=
 =?us-ascii?Q?kMkDQigc+JSXGXH7nIsC1ELJ/gQzMPSY3If5XLFdIMuVbJaW82qvHTxEDXVH?=
 =?us-ascii?Q?Fnj0Rt8ZvcSZwHwQGQdC85VQREoZCb3RZe5Bl6xRkGvgR9oYESFo4PvWWq8d?=
 =?us-ascii?Q?eAAobhrPHeoe3hovWs/wmjYvHylY4fuCupRJAtYxXIbpYjU3JRHh2V+WuGMI?=
 =?us-ascii?Q?U2GOHgs5VsPLigxsWRMAXrBn5nqo5MOjWe2jGR6E9OaGM822Ki+9rzLuiaCD?=
 =?us-ascii?Q?egvIUsRlsHnBMjcIN4N9G6Dp0WlmEAN8HiaVYX+Pkl7CcP/YX/+qUTz+g4Tc?=
 =?us-ascii?Q?WAo2u0juz7k/Ec1dkBSl1ao3cztOIiC4JScFsmKA/iyT8E5r+7arGIVtLVVm?=
 =?us-ascii?Q?lXDSrClQoC+IozjkUzakBlhAgtbJsfvGy8Qq8YJI68sBYefE8Asyae4nlZaC?=
 =?us-ascii?Q?Pi7vMAGHYFdhiUddOMTWXBPsray07t6BWASNhKqep3FL0HxOfGArSMQRcVYz?=
 =?us-ascii?Q?EKA7NCYMY9s1dMvT8EKW3SmTVmWa1i1WTjGdyStxYxUS7qZzpqCxSi2yljHA?=
 =?us-ascii?Q?YC9i/Hj2qtKN2GZDsyzQ7eWglSHYqoi6gUtGSz9UO2mLPKXNY4RGVcfnHVWP?=
 =?us-ascii?Q?Ja7tGSn+pBUg8hOnhT6qBu5nykdC7Q19GMmHXz94UmSuwsGeC31mvuVssmS3?=
 =?us-ascii?Q?cYgqEKlZ/Y5yXLiAwck=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b6a0128-8ab8-47f9-84fe-08d99961f262
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 15:53:40.9107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nMh8/vmfzc6yFQzTf07GvzBSMgOAAJCDBSpmPJ980CxYhNUaAOveBcwyQPHc385I
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5062
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 09:29:43AM -0600, Alex Williamson wrote:

> The reset_done handler sets deferred_reset = true and if it's possible
> to get the state_mutex, will reset migration data and device_state as
> part of releasing that mutex.  If there's contention on state_mutex,
> the deferred_reset field flags that this migration state is still stale.
> 
> So, I assume that it's possible that a user resets the device via ioctl
> or config space, there was contention and the migration state is still
> stale, right?

If this occurs it is a userspace bug and the goal here is to maintain
kernel integrity.

> The user then goes to read device_state, but the staleness of the
> migration state is not resolved until *after* the stale device state is
> copied to the user buffer.

This is not preventable in the general case. Assume we have sane
locking and it looks like this:

   CPU0                            CPU1
  ioctl state change
    mutex_lock
    copy_to_user(state == !RUNNING)
    mutex_unlock
                               ioctl reset
                                 mutex_lock
                                 state = RUNNING
                                 mutex_unlock
                               return to userspace
  return to userspace
  Userspace sees state != RUNNING

Same issue. Userspace cannot race state manipulating ioctls and expect
things to make any sense.

In all cases contention on the mutex during reset causes the reset to
order after the mutex is released. This is true with this approach and
it is true with a simple direct use of mutex.

In either case userspace will see incoherent results, and it is
userspace error to try and run the kernel ioctls this way.

> What did the user do wrong to see stale data?  Thanks,

Userspace allowed two state effecting IOCTLs to run concurrently.

Userspace must block reset while it is manipulating migration states.

Jason
