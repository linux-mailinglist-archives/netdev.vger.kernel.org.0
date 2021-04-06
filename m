Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9002355F48
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 01:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244092AbhDFXQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 19:16:05 -0400
Received: from mail-co1nam11on2044.outbound.protection.outlook.com ([40.107.220.44]:7136
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232039AbhDFXQC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 19:16:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gN7+vAoatv/NUY0abkKsbqq1y+s2BpQ30ynh3k443oA1o2MvqU55adc1eti3DHybZY4/cgEzLHdbj1cSTBOd1m8l+Lbt0DMctYJGtz+6VF8J784LrK9YJNoTHCxK5u7Wr8sd2pKtv180xDnfeLWJE4+m/XhXG0pnAO0BnRNHCLh+WPmU453Ofmy8Agfxpc3HsYsPHi4YrCj93CXIBblMmy40MK/3iaeutvSTvz0x4cWfre2+mAyuRSXe4udEYA3TYLwVdQpxQR1xNqkMyINQ9KlvHOW857EytLh3/XMsqe4+Xu9g/wF36tpqHITeS6QGhaSrLkf/lHsHX1WuFw8u+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pDH0m2UwDtAiKfS/8xqz0fG79fc+HNJLfVuj3dFyIBA=;
 b=W16OR57AdGxQb3G2ok1P6rWFMcfwephYUR7t8BMxZ0gY02Fdba6qKz7yk+OsLUTYcUa0PcNZ6zEnuMi60FODvrE/ggmiiRbFR/1KNBhvG4kXK7w01FKMdkEFy8aoT+2+5QDNZYqQK9V0NPZ/ph3oInGK6MNfHVCRw2zXgIT7RCOmyNo53Fh5qhvHJn6wI7BHE40L1gP8VFJbCbdp7kxR/MUa4gpWNDwwanWliU9ZcXuH/rE1Cnjfi7c4OZwIqYqpVNNJnLPj/woSoHrsmuZp/4sKOd4FoJn/V/5xqxpiL5ISwJvul3U6FJag+nM762f1Vdl0DS170Et/9sDPS0X+hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pDH0m2UwDtAiKfS/8xqz0fG79fc+HNJLfVuj3dFyIBA=;
 b=DAitDU2QGTCRKCcEvBSgxGgDkGjf0bHi/bwbaGpigpa9qsYettwSKfj19pYo7vBVdUeEKpDscpLFF0u3BJMCYZonkRub7QEzl1M7myHMl3gzF3wVbs8vc0rNEsANzJpTqCyt37fRE0LVax37uwy2hAutbZs0SUI5OPkCGIEJSgEL7sVKosJ7G2NGW9CV+di5Vt6PPKFnnwz5a/y0NbclhAE6ISUddMJFLDHkVU8kiZdDV5DbEopUBBf6GHSOUC97tF4Bmm88xrLB+9FbzqUDMb0iCI9cWVnlOFu6WCFT71tvjVHwofFutZIbaaoRjKw1gIFZItHtgztNkecLEo3dyg==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB2812.namprd12.prod.outlook.com (2603:10b6:5:44::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.32; Tue, 6 Apr
 2021 23:15:52 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 23:15:52 +0000
Date:   Tue, 6 Apr 2021 20:15:50 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shiraz Saleem <shiraz.saleem@intel.com>
Cc:     dledford@redhat.com, kuba@kernel.org, davem@davemloft.net,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        david.m.ertman@intel.com, anthony.l.nguyen@intel.com
Subject: Re: [PATCH v4 00/23] Add Intel Ethernet Protocol Driver for RDMA
 (irdma)
Message-ID: <20210406231550.GB7405@nvidia.com>
References: <20210406210125.241-1-shiraz.saleem@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406210125.241-1-shiraz.saleem@intel.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL0PR02CA0008.namprd02.prod.outlook.com
 (2603:10b6:207:3c::21) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR02CA0008.namprd02.prod.outlook.com (2603:10b6:207:3c::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Tue, 6 Apr 2021 23:15:52 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lTuvG-001ps1-JR; Tue, 06 Apr 2021 20:15:50 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2e7f953c-8096-45b1-6215-08d8f951ec09
X-MS-TrafficTypeDiagnostic: DM6PR12MB2812:
X-Microsoft-Antispam-PRVS: <DM6PR12MB2812A2DDDA398F809EEC37C2C2769@DM6PR12MB2812.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OglfDsXHi9DnAf/ih6uoOZO7qXrNNNfFmqlVlQcwiW+8VgzIKW2GamPcZJZ58rbuNM4COWzsNri01gjV/vgem0HMLGNmVB8sH291pqFAYfbvnyrU9FTlagRZfd4ewOlqa2POqWDwAdeSVif2Qrj7t7fTGeSL345nD1dFqBJlxqNIFiJShCh/ESP9CcwvT5DeYpxlgJiNxAIQbeiT455uv5364FKgDLsg7M8cFeNQm1QrrXhQIIKL7t0+jgw5vnftHOLlTyKjaUyR5DOc8IK4+zmWqKgF13Y5atl7+9lWI56wnJQB4GC9xOMFbFVqzbdhVxWhTynm4x0ApvtXL+TOmyLY1gzfLJ/7fV4vlXInK4iOCmVbYtfodwG5k7Sxv7OV2T/Rd8SQBwXq1BXYenJtJ1803fyssbetlNNyBN6ajrKAM1LS5JvzG+/mfVFRSPjnGsbS+/32Xyicsam8Mto+21Q4RmBXxyxTHjiw5JFG5akqkihu0wG0BqS1RXglsxKh/tNQQNxdh2BmBKWzoWxbJKA6J0MKkIYtzcyxNPQ5laC0B48nzZcFBCEAmmKIqSY6EohfwTBrFecRuAC6Aw3kyUtbuIXl5Uisyu1XW4YsjiebtsbwyoFvHLJE/5D0pnt33iFeSSvbfpX0S+d1ZIGB+l7jdxlVLzDbHgbS/7Oved4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(366004)(376002)(39860400002)(426003)(4326008)(1076003)(2906002)(8676002)(83380400001)(33656002)(36756003)(9786002)(38100700001)(66946007)(86362001)(5660300002)(66556008)(66476007)(26005)(186003)(478600001)(316002)(9746002)(2616005)(8936002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?EnCZp2Hgr6MQtTOJ1oklWogG8H8LKASjhmwNEDrCdri8g1gWc+VOObV+MjNf?=
 =?us-ascii?Q?O9MGUysNkzEimE/LchSDVu2y5JU4VcVxY8ADbSimmX6yekr/9k+6SrFRqY4F?=
 =?us-ascii?Q?EQwtbJ0BQWvtlgR/rWwhSBB+vWZO0z0jvFyCk44BOZ1QNywhda47R0xdAsoz?=
 =?us-ascii?Q?LLxBo2fkeaxTDorYKmZN5UhQg0bIaM1PolhUv7YrN8vm58dvOOHpKDYjCR6k?=
 =?us-ascii?Q?oIM5o44YplDgMcEDADtvqx+nCeZyTR+BqkkRWYDkdqxh5UnUxijwWL28j+M3?=
 =?us-ascii?Q?8Zt4mRDqwCY1tpx9Qhh8ZKsjDI3x0XIv/FnbqfuMjNKicL2KR5azL7Mw03ZN?=
 =?us-ascii?Q?kQt1hwPaK+cMTZ5ieu7VgNffCYOznTQ9IErOmB+Eu7U+hYOc7j4AG70IhblD?=
 =?us-ascii?Q?5wTaIy9kMkfSUt8xxnon0WNTwXeTjIQ2zHFdWl1d2yiiJRmP0TFkL4w9Ao3v?=
 =?us-ascii?Q?EOR9nGzqsYYmdxfC3mwcAX4e6ZZZb9ujW9w23XMki0/q4dDB84Cepyrase2a?=
 =?us-ascii?Q?tw6Z6BaLbNiEdbyiFijua6XV0JMn6arU+dE/VHbCNn9F11mp1R4xcScEe+rv?=
 =?us-ascii?Q?Jzd7TQy1Hz1nuPL0UoCQRcIBOxwlMApOZZlcVEtrZBAhFs6tKaTYuLrV7aBL?=
 =?us-ascii?Q?orkU2m/myiw3rcUzeWsQkX5W5GP6xqVwsuJFHNirle8DyS4sUJgRuPhSKABG?=
 =?us-ascii?Q?ArfdUvWSCcTCOCFJsgeIr6gM0wvQfwUO7zvh6uYi64S8nlqsvxXoUtho883v?=
 =?us-ascii?Q?kamx0d0zt+c7StEzhYJIE/jupAwX7Z3CW3gtz4Eyupd6gfir+ClK/Dec+Tf5?=
 =?us-ascii?Q?6CVdOOlju+C0pXtPClTofXJKfPTJSuZKel680QQnEHTYpHhQiFcXMbak+kDE?=
 =?us-ascii?Q?cQ1esIhFylKW9G+jiAZCsgkwn7IhfXaKKH/OEdtwWlT3bZnTok5i0EiFvICv?=
 =?us-ascii?Q?XMmZ7fB0+AX8SFKtCOp9ljA2TRpRlLhdY4jff/QVk1YXgiwxg8UhftrL2qon?=
 =?us-ascii?Q?uqIF6oUQrukS7dQEurNsvrLyu7yWOdNVaXt8hAiXrdeXYncnmenaxFs3J9np?=
 =?us-ascii?Q?r1od0552dcaXuYNTkLbroVeNkJ28FcnpYWSUx2dj5ojHyvbhOTdbgPDOWJFL?=
 =?us-ascii?Q?D98LzTwdl3rd47iq3WuuCvjy4JC/7BK7IFWAWKXNcIg9c2ZpJMiLWYA4psCt?=
 =?us-ascii?Q?TvuVijfk9LicKPpF/26zoKR+gUJP5pwUR/CdnNl1t7N8f/o9JBsgwT9X8KsU?=
 =?us-ascii?Q?O6TQ7opNXOtt5FeQWR3lPEzUajlfdE1oQmc54RNxn6bHl3/W3wwpAwQKwkN8?=
 =?us-ascii?Q?M2ceYSUSlBB6CHT2V7DDgLv/2qRl2hq4O0aOvdNx5rCcGQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e7f953c-8096-45b1-6215-08d8f951ec09
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 23:15:52.2369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ucUUAj9b98v+CStwlcn1wLDaFCqW6i+QEcfMeHFxA3RzTi7XGoJ/UIt3JAuB1o0z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2812
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 04:01:02PM -0500, Shiraz Saleem wrote:
> Dave Ertman (4):
>   iidc: Introduce iidc.h
>   ice: Initialize RDMA support
>   ice: Implement iidc operations
>   ice: Register auxiliary device to provide RDMA
> 
> Michael J. Ruhl (1):
>   RDMA/irdma: Add dynamic tracing for CM
> 
> Mustafa Ismail (13):
>   RDMA/irdma: Register auxiliary driver and implement private channel
>     OPs
>   RDMA/irdma: Implement device initialization definitions
>   RDMA/irdma: Implement HW Admin Queue OPs
>   RDMA/irdma: Add HMC backing store setup functions
>   RDMA/irdma: Add privileged UDA queue implementation
>   RDMA/irdma: Add QoS definitions
>   RDMA/irdma: Add connection manager
>   RDMA/irdma: Add PBLE resource manager
>   RDMA/irdma: Implement device supported verb APIs
>   RDMA/irdma: Add RoCEv2 UD OP support
>   RDMA/irdma: Add user/kernel shared libraries
>   RDMA/irdma: Add miscellaneous utility definitions
>   RDMA/irdma: Add ABI definitions
> 
> Shiraz Saleem (5):
>   ice: Add devlink params support
>   i40e: Prep i40e header for aux bus conversion
>   i40e: Register auxiliary devices to provide RDMA
>   RDMA/irdma: Add irdma Kconfig/Makefile and remove i40iw
>   RDMA/irdma: Update MAINTAINERS file

This doesn't apply, and I don't really know why:

Applying: iidc: Introduce iidc.h
Applying: ice: Initialize RDMA support
Applying: ice: Implement iidc operations
Applying: ice: Register auxiliary device to provide RDMA
Applying: ice: Add devlink params support
Applying: i40e: Prep i40e header for aux bus conversion
Applying: i40e: Register auxiliary devices to provide RDMA
Applying: RDMA/irdma: Register auxiliary driver and implement private channel OPs
Applying: RDMA/irdma: Implement device initialization definitions
Applying: RDMA/irdma: Implement HW Admin Queue OPs
Applying: RDMA/irdma: Add HMC backing store setup functions
Applying: RDMA/irdma: Add privileged UDA queue implementation
Applying: RDMA/irdma: Add QoS definitions
Applying: RDMA/irdma: Add connection manager
Applying: RDMA/irdma: Add PBLE resource manager
Applying: RDMA/irdma: Implement device supported verb APIs
Applying: RDMA/irdma: Add RoCEv2 UD OP support
Applying: RDMA/irdma: Add user/kernel shared libraries
Applying: RDMA/irdma: Add miscellaneous utility definitions
Applying: RDMA/irdma: Add dynamic tracing for CM
Applying: RDMA/irdma: Add ABI definitions
Applying: RDMA/irdma: Add irdma Kconfig/Makefile and remove i40iw
Using index info to reconstruct a base tree...
error: removal patch leaves file contents
error: drivers/infiniband/hw/i40iw/Kconfig: patch does not apply

Can you investigate and fix it? Perhaps using a 9 year old version of
git is the problem?

Jason
