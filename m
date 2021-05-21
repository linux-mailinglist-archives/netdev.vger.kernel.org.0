Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C629138D1AB
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 00:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbhEUWrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 18:47:13 -0400
Received: from mail-dm6nam10on2060.outbound.protection.outlook.com ([40.107.93.60]:5952
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229512AbhEUWrM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 18:47:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JPIzqzvDABQumvO5gEQDXspXd0wHpnEt3bfRJmEdE3SjXV20QK0qDV1uoFBz0T9fSZZav2zyQSmKcJlHw4Zv5DY2zGUH9PWh9Ihujk2QdA1AnksIsVXVEo+M9LzCcOo20ytChEIe+zdqGiqP32dB5/3zbJgX8Io6TfveY4H3PnfX3ft/p3V/4J6GBdT3c4MXT7qJgN0DZiWWrT+NkKQWzmdmWvlCoz4vUt//lA0JEERj9kYdNoOQsZNbrQSO6ZzmOwOC+7mbOij6C0p0NJCBJqjLHz+TtbYOpDzNdhid+CjrtCT72GRlcmtzxGJoNjDWbkUautAXAqDfHEjMV1+y6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ccajh6NL8rSyMUb4eNzQKMVxqRPfHHNwE/IP3c0Kwmw=;
 b=My8A0z5gs6PaLhqqD2KAE3pqmorH4ybrD4Lhz4sMzuFepliL7DosWUzXd9YidE5Pa1WjJ6VvcPtHLpgW08gPN7+quzcW4zNumnqSw4/YVg2kfXy+6V+m+u+yw7Kz/bXdL+Own+lSYTKlCdUMcINiroIZl+q46LEN6phE9DKb7jeaN1elC+bArBHsZmUweFog4IvtMhbQj4wq3tPtBOsEHJFXQh7/znTKc8BiIaXS5irVrAGdE4iewpSJ9HHIKtTM1sR030WqLjncsVtd/V02Xy56x734is4tj3df+Eq8qwoYEota6USERf8dBXYkA8ja2wIZDkHG6uYvK3tJT1sCMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ccajh6NL8rSyMUb4eNzQKMVxqRPfHHNwE/IP3c0Kwmw=;
 b=sWJ2ik9F+owlY4dZMg4rWiMyXSi4FGczuY1rtu2mfN0CtE3ci/8lS74GhjppJGZlowvsAy2N8e8377ZVMHSY0+aS9iRwUMrXoV2mOJ2ZwzypRnvOlzOM+byEjWL0oY3gODYmPK/GOM8+kPC2k9d3jbOT9V+QhnoM1Da/Hcoco2XiXV9LetF2reL51VnySwJaCbo6RJdAcsIGtavkWKjBSSsFd3PUqDePctxuOJMl0Z5bGkcZvJuMAVY/VEcJLb+PJXjJZHLZTSiMWiVFID78GhsCL5dO3IGB0hFP588YrXfRmups3AcpJxdetklsb1fpn3JAj0V6AFQiBNUlB2ZUdw==
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.25; Fri, 21 May
 2021 22:45:47 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4150.025; Fri, 21 May 2021
 22:45:47 +0000
Date:   Fri, 21 May 2021 19:45:44 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     David Miller <davem@davemloft.net>
Cc:     anthony.l.nguyen@intel.com, kuba@kernel.org, dledford@redhat.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        shiraz.saleem@intel.com, david.m.ertman@intel.com
Subject: Re: [PATCH net-next v1 0/6][pull request] iwl-next Intel Wired LAN
 Driver Updates 2021-05-21
Message-ID: <20210521224544.GD1002214@nvidia.com>
References: <20210521182205.3823642-1-anthony.l.nguyen@intel.com>
 <20210521.143114.1063478082804784831.davem@davemloft.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210521.143114.1063478082804784831.davem@davemloft.net>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: CH2PR05CA0066.namprd05.prod.outlook.com
 (2603:10b6:610:38::43) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by CH2PR05CA0066.namprd05.prod.outlook.com (2603:10b6:610:38::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.11 via Frontend Transport; Fri, 21 May 2021 22:45:46 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lkDto-00Clkr-Or; Fri, 21 May 2021 19:45:44 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ad8cd4b9-608e-4348-14e6-08d91caa2cb9
X-MS-TrafficTypeDiagnostic: BL1PR12MB5144:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5144A2FA6D6A8B111B90461DC2299@BL1PR12MB5144.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I/OwJIGF6vlVQQcot06ACMereXN5WmBzekKwYf7oYlIYOiIkNfOj9S7eCn5orAdL7AnO6xUcCD35QFSw9WHsN0yE5/0aymw3MOBk+ZHYYzQ9xEPk4KTreMIMKryEXnmYNjiEyqMYca2ZiTN1iO1PCwogxNIitLXkalX0ULK/VjBjzbW/73xCas9aMBMAHd+F0ZfRSRhdswyrAN2zV+H4sdm4khSymX5lQmN7ph8Jm3Yog/gxN6/EOjwYCgORxZy1S0DpMFoqW9r5sbdjlyqesSX10w9JNC+ybzTBoUCrvCRRcPghmzcSlc8o8dyABP/V2hg6pNhutDFSsBh5j7Mr4nI3J0tfJcpMkEgdw57cm5yHtPFWxy1lQN4hXkfxUMDdsDcZ4reoglRZOJT++2csfusmSxt9Kf9Sntw/2ludHCVSF+Jw21+ANvz//7g1qYPek8dLc3FBseDNMGuAM6gadyLKtE7jAHlfnB3gYdMCyy2bRdwDMD/A8Em/SV1mXlhldjNrbgewvPMHDXdbOstIuPyycc9e1c64507E4FRQ/2WDHQJdMVUzXHsb9LcIGlGfJ6FPpT4e3QxyW+SxXLkmXod16HenEAYF10DsKLQBxgMBU5KLbZtROIsdQcTtHBSLZC9wePYcn8E/zKnyrXq2Wz7dB7q4y4L2PzWJCzvRMuHzwqtWRjhIusci8CfSIiXduzXEro2OA4ZjDasnGNmAIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(39860400002)(366004)(396003)(66556008)(66476007)(26005)(66946007)(86362001)(33656002)(2906002)(426003)(8936002)(2616005)(5660300002)(38100700002)(966005)(4326008)(9746002)(36756003)(6916009)(316002)(9786002)(83380400001)(8676002)(186003)(478600001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?xyZ4QzMgLTj2DUqsXhZwjDnx7CqipTZvVHiOf1dAfWf/MrWnHNOVm7SaXSVq?=
 =?us-ascii?Q?LxXyCIUjy0KYd1q1NbMNWQwX1QB127UMbNH0Cl2dKtK7PlDztug0eGT76fMN?=
 =?us-ascii?Q?H/9vp2XtTQhtcv5aE5drtHSdupZIfOHRl1wbj84fQEYOCsecIoh3gtig9Id/?=
 =?us-ascii?Q?cZ1erWa/GQXGy3j5CRlz6PeHxdEZ2WaemHT344RBxMtzIy0T4T+Wd87912ut?=
 =?us-ascii?Q?qIUaMYwbhVZ8/+ilzs1l5zNuCewPSpNB5E0GZoYqqNcpfnQQinVz5jCIunGr?=
 =?us-ascii?Q?vuQiOrYg9JhUHFIbMUiMzAFwWHXNJdoMoyo7ierL/oYxdfBhnneK8zc8CtzQ?=
 =?us-ascii?Q?9vXx02VuHnGzqLVXmhksjh1B5SyHLqlO7YDKTp/OZVg0mFE923oAqL6Xsi20?=
 =?us-ascii?Q?96q2U7HwqSd5APuWtOKCz20f9P6u+P9Ukxzaq/foBspqjuEmCcpo+XDQ7DZf?=
 =?us-ascii?Q?rOTxp6YTZpDic6YRzRpHxwnT3UqoN1bi9vd8Hl3Y6E0kA2/zwTS2wXLMee1p?=
 =?us-ascii?Q?2392Y9LZg5PQ+eI64E2q2/9jfzxalhthiqIxvKeCr+ULnePCpOn4ZpkNfrHy?=
 =?us-ascii?Q?0nY1YdS/czYR7/cVt/+q7iASFbydNa7bUnY9d+ay8JowHh74549m/SSLRcTL?=
 =?us-ascii?Q?SxPc33hFHOGHwL2x8YN7Ct4RZpu8ng159aoHvuItnSoPISdSGenIt1K7Z3mF?=
 =?us-ascii?Q?V3lBeLzJl0xXU4rgUQo41YundheuXD/974suvx3Z8LiPhOryz4iNsnjbLn48?=
 =?us-ascii?Q?VZQ/sr3CrkqVxd55J8LXUt8ZM+7jcm+iVRl/tTS04lBJakYm1e7otWiYcxWY?=
 =?us-ascii?Q?CLQIYGnM1rvgWcTQvcBeLq2NWN8K5II0kkVtNKvTCbHBxyO7w4mdobgfza72?=
 =?us-ascii?Q?K1q5dYr9+kK5SMBiQXg2dw/TMcnYZX7KII0TXI2KJe3pw9DLbQXDnasTXFJE?=
 =?us-ascii?Q?hRjgz2GUW5bh9Uf5W0ZpAKyD5OZZGIL8CKa0FmD+juqCm8pMbJRJ9fZ+3RAe?=
 =?us-ascii?Q?E7DLJjPijEEFvsGNsTPR66kVXWg8DRCQ2tCxIUKUWadONyhYG4H0q7MEAAlJ?=
 =?us-ascii?Q?i/ssS7O1IzqYgl7S3T5TTCA+YpgqfqZO2Ggc4XiPrc/sme4kVg9o+2kzPtin?=
 =?us-ascii?Q?odBTd0J43rccK//IJLX/r71gWeD2USd11xZEfOR+/w5guhYG73858O87WPA7?=
 =?us-ascii?Q?+clD++NAGJalHC+kNCvJA86lV3uAeACpSUpSargrKVaPzFSUr872ayb1S97N?=
 =?us-ascii?Q?n5wsw7My5K7fNCj//ToFQbMDQVxvlEnKJcYh29a+tKSdMgXS9wAijNryiFaW?=
 =?us-ascii?Q?3i4+nAltWEx54bpkPz7y4MQ+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad8cd4b9-608e-4348-14e6-08d91caa2cb9
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 22:45:47.2002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8n7XFs6ArhpFdXHznYFtenRtab78SAUACND7QBVAPb4BCsA5pWCZgdc1qV9Q4DfS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5144
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 21, 2021 at 02:31:14PM -0700, David Miller wrote:
> From: Tony Nguyen <anthony.l.nguyen@intel.com>
> Date: Fri, 21 May 2021 11:21:59 -0700
> 
> > This pull request is targeting net-next and rdma-next branches.
> > These patches have been reviewed by netdev and rdma mailing lists[1].
> > 
> > This series adds RDMA support to the ice driver for E810 devices and
> > converts the i40e driver to use the auxiliary bus infrastructure
> > for X722 devices. The PCI netdev drivers register auxiliary RDMA devices
> > that will bind to auxiliary drivers registered by the new irdma module.
> > 
> > [1] https://lore.kernel.org/netdev/20210520143809.819-1-shiraz.saleem@intel.com/
> > Changes from last review (v6):
> > - Removed unnecessary checks in i40e_client_device_register() and
> > i40e_client_device_unregister()
> > - Simplified the i40e_client_device_register() API
> > 
> > The following are changes since commit 6efb943b8616ec53a5e444193dccf1af9ad627b5:
> >   Linux 5.13-rc1
> > and are available in the git repository at:
> >   git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/linux iwl-next
> 
> There is a lot of extra stuff in this pull, please clean that up.

It will have to wait until you merge a 5.13 rc into net-next, I can't
take a branch into the rdma tree that isn't based on a rc.

Jason
