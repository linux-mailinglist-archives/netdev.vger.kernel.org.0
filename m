Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDD334997F
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 19:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbhCYS2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 14:28:43 -0400
Received: from mail-dm3nam07on2051.outbound.protection.outlook.com ([40.107.95.51]:18017
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229533AbhCYS2k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 14:28:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m9UnrwdwYkmO953UA+bxbtyu3P0xrSZoqe7+5R2+Qm7NWD4ZTXiVmbRZfaMf75ENQLnRL/5luiiHiu2spwyH7W3Zzn5RxEkZhhy0MsoO7dgsmm0TClVve/Rb8yqPYL+WgCQm+3hJL0Ccb3ul/4NbkuM5v8/XGqc/STZ8o18P9vPTaYhDlZ48YrugJBO+hJSSFKbsQm/9schQ4CoT7VQAPFR2UYKV28VcQqNrvx6ellnMibLiasl7u657gvBxl3iYsJYXWwjEF2BZLx+gmz7gJNUNxVQjwr1P05Vmzj0SGjDVsTfkyNVWk4Q5J9YPG16EOLAz8s6O+rQf1Zyzb695RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XMyd36lj6tcULp+vXaqBO8Hjq15bIp5uuGLONikQpNc=;
 b=J4PFQMV3kDucDiLPkKnZX/c5q+3OxCfIfRYowiNk2Qc0okJ1iZGYlmjh1klX4G6q9FwtfoHsUFSPbvjfbg+DtxtvwRu2h7yqrRHagrhFCG5T/fWnEPaVo0P7h5nMfvZHVe8Ah75xxA4wFC0ibdWL9vi6d5BY3Ik9WqCOPRJokSDKE4wD9xSFcKb4plbC/CEHG00nr9JFyX8HsXhb5tZq+czr+iEqlTiM29tw3Cj/W0EVrdCasiDHpSmG/sIy9p7CTvHCImODW5JReM7I3ArStwqHuiM0fKo3hM1YoHLrd5BDhp3dMSfGDxH8bfewBi9LhMh3CquA5uXelgmJlvAOTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XMyd36lj6tcULp+vXaqBO8Hjq15bIp5uuGLONikQpNc=;
 b=Au+mmoftys64vCzcATRlzdVqDEZEtu1Z30RMp61e/0Z7g2A4XGLEy8hWXh3x8SQOdZklFx6tjCAPHS5TyhDzMfftOEMRCyA58AbAs6Ln+sfU1a9MtvhOmZ+5sFiQuVodHG1FkoCPm6rdlzF4OzA9ZzHNhBTGKtPT0p7jExXeg3uCYtzy/JASC6uCLALClYrS01a7Wiz6XUqcjBezX6Gsa71223UJH52yRqF1vi9doLj3ZvmCmWj8F6ChYyhF/vdHDPGX/j7CoHReSptYg+7jJjLhMhbkIRlk6rTYgczXwzTuiPyRzMSdf+b1FgxtAcBty25TzmdApObVKiiwVp59aw==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB2858.namprd12.prod.outlook.com (2603:10b6:5:182::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.24; Thu, 25 Mar
 2021 18:28:38 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3977.029; Thu, 25 Mar 2021
 18:28:38 +0000
Date:   Thu, 25 Mar 2021 15:28:36 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Keith Busch <kbusch@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH mlx5-next v7 0/4] Dynamically assign MSI-X vectors count
Message-ID: <20210325182836.GJ2356281@nvidia.com>
References: <20210325173646.GG2356281@nvidia.com>
 <20210325182021.GA795636@bjorn-Precision-5520>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325182021.GA795636@bjorn-Precision-5520>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: YTBPR01CA0012.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:14::25) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by YTBPR01CA0012.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:14::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.24 via Frontend Transport; Thu, 25 Mar 2021 18:28:38 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lPUii-002xYU-8y; Thu, 25 Mar 2021 15:28:36 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1bfeab5-0e7a-4f67-9738-08d8efbbcec8
X-MS-TrafficTypeDiagnostic: DM6PR12MB2858:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB28587C46CAAC5B83086B6F62C2629@DM6PR12MB2858.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vqKhnYmaPVgQGtMv3+go8towpeSCrlbOgFg9FC/uQi9hb9TQNBOQyQ78kal1/vBCdRH2Torxg6QbOCI28MB94St2APveAifMur+pgN+Ssh1i/idRM+6RsbFi+3HVUvi5R7O1XFX34CVeBi79RvFwWNhsj0JtlbT8RZ0hPB1jq+kJicPIDrZ43s55ephpyS4mXCfXDC9/VMITFWAK1BCO+seLa0PsJmTX42pdc5MQgGOJPEIQKFQ0rmO/SG4thCpZOwYNonZQgFm4bPxcmZ00EXa2bs4VEhv82l+vLw8hbLKxC/j6A+dGMPYcBrDd5S3CF+4tNwLmleZoIWNZgFFn15yegEzJhy/WRtVWcpTlYl/Wdcpum8YiEAw6bWHkd0bE3fih9BHVAOnxwI9J3PVjSc0z6t7OmJ4UtYNTWMFd0h30J0Q6K9oIO2QFVGSyz30bKIGjsxLIIHHBPGBxsJmloj4/+nAfOsDDTy47gaAIF87wkDt19C7JeWHXaApFDee+BV+fqS6xK8Fl6gxWyiH1VF1dMucT65FRlvqQbh/+OsKSoN04PprK9lrZIUpPUFlnqTrzmeXhae3V0FIaVuhvfcIeH4y4Q4sNPSty9Dbr9FBLtSeA6BWWziTzoAXo7DK1tse3qzW8aJnH5we4eu3SZN/4Xsi0MjUbGcJDEgiyZHA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(366004)(346002)(376002)(426003)(4326008)(8936002)(2616005)(54906003)(66946007)(2906002)(1076003)(33656002)(66556008)(316002)(186003)(66476007)(9746002)(478600001)(26005)(86362001)(6916009)(5660300002)(7416002)(83380400001)(8676002)(38100700001)(9786002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4xJ0RlDDw6MN/zZ3OTVWoMHtFz+0ur18O9rRbHJ6qRunH2eR6qnCkqSvNK+s?=
 =?us-ascii?Q?8MjgKRo+J60BbSUA3LJP284amEIOJ2DOu+IHXVC9TNHkbA+hQj+JsJ563SbA?=
 =?us-ascii?Q?ItGBvqs7B3Eka4ojPFzMfi/o6SWskx9IFuoN25HxZ+JlBm9DZhna0ixiVyxS?=
 =?us-ascii?Q?pRwu+Js8REMiSgsItLXa9jS/c76jYOQjuVF0yqaIbKcrOTfY8qAOINmjUCQf?=
 =?us-ascii?Q?h//UiVH6c2W6b10OZPl+VnuOxCQ22XYLDZHXVbBrikbCkGz6NtQ2WmTWu/RQ?=
 =?us-ascii?Q?2VLVBPj8ym0GMXLDR11POEt725GJnC6Fun1QrzzSwDTPJ6o1lN2Duu4Hm7DZ?=
 =?us-ascii?Q?0cdg5gYBh/0F2WXUqNOYSSNBs1aIfHkXcRCQbh/KDOaKOedF67UOw5M4/uHL?=
 =?us-ascii?Q?LbyjwPN15Y/OK8Q2LSzJWQGqohcJ6s/Xx6T2YGYcjO04EAko+KjuIG5ks2nI?=
 =?us-ascii?Q?17+WjejQfeqAL8LgOuLEqZO9c3omYey0kqiye9Qfw5Iecptst79PZzZj9VeA?=
 =?us-ascii?Q?ny5DDgIBQYGKp7kqmP8M13uhyadtoJExbyxldlUfpks401C8lNFixaDqv9UN?=
 =?us-ascii?Q?E8bxN8VIDVsKClkNiBo95w9oGZH6Kv9T4qGmsMfNanJj1FgjY4HevS2xv8uz?=
 =?us-ascii?Q?//Rfc82IPPM2tMLxLor8+7UkuKuXQs2W011urKEbZOXSrg3dwM+ffFnoqEY3?=
 =?us-ascii?Q?ObCZ8mTlD3bttAyBeWHX+6duJmLG1ELRn+WBf9dl+Xo41m6SkM4+f2npIvze?=
 =?us-ascii?Q?UvQdSm87u7hKoRz3ju3h4oznOvr3e3eTUXQ0dKadNemPpadg1rvyqPQpHE2P?=
 =?us-ascii?Q?LBP3QigjX2Ziu/sxvFnEysrydjko6wzYujdLM/B5iDUaHNcDSzuPjIc81Ljl?=
 =?us-ascii?Q?fD1Mr2B6YCjFHBi4l1tj8+1fu2skNKrdYuYXFL3bQb2a9VpwF8Rai3gCsqju?=
 =?us-ascii?Q?F5Nv7a6cB1xOQqcEq0BA/MqcUvuaMOUMQde1emG1VHV3b9E3xN/LjrMyTltT?=
 =?us-ascii?Q?/TWv9/jmt/5btEISbeMvQ7Td9PANQ4Rd44LQ5UaM3ZHl4611azcJ9VXPAm3o?=
 =?us-ascii?Q?GG93+dJ9TUnGxKxssvooEO3F/3WttKVeM0Cub+0To9dcKjKCZjTp79vL0cdU?=
 =?us-ascii?Q?JVqokekQY8RWIwgYyeZNrCGH3ZrNeJfslKAhkvPw/YtCMAzL+YreEAbBNsl/?=
 =?us-ascii?Q?uKJXky+FWyXJJ6fy4WjRLk4S2jBrq5FT6O+lBO8WWDrEcDGN1hkMF0aLKq/l?=
 =?us-ascii?Q?zJvEgNoe5UJXvWbPyV9HaHhhpwXyfhLqVxYSFFGAAB9rnh0M5pyxBPyjODmT?=
 =?us-ascii?Q?Ul0tgYqBRuh0a+S7G1shOGcG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1bfeab5-0e7a-4f67-9738-08d8efbbcec8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 18:28:38.3458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R3u3QUvkgFOxy4FwnYaeCdxR9r26kLIXccngFLLEqbt3hk3l43RhlDuZeYdLy4+V
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2858
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 01:20:21PM -0500, Bjorn Helgaas wrote:
> On Thu, Mar 25, 2021 at 02:36:46PM -0300, Jason Gunthorpe wrote:
> > On Thu, Mar 25, 2021 at 12:21:44PM -0500, Bjorn Helgaas wrote:
> > 
> > > NVMe and mlx5 have basically identical functionality in this respect.
> > > Other devices and vendors will likely implement similar functionality.
> > > It would be ideal if we had an interface generic enough to support
> > > them all.
> > > 
> > > Is the mlx5 interface proposed here sufficient to support the NVMe
> > > model?  I think it's close, but not quite, because the the NVMe
> > > "offline" state isn't explicitly visible in the mlx5 model.
> > 
> > I thought Keith basically said "offline" wasn't really useful as a
> > distinct idea. It is an artifact of nvme being a standards body
> > divorced from the operating system.
> > 
> > In linux offline and no driver attached are the same thing, you'd
> > never want an API to make a nvme device with a driver attached offline
> > because it would break the driver.
> 
> I think the sticky part is that Linux driver attach is not visible to
> the hardware device, while the NVMe "offline" state *is*.  An NVMe PF
> can only assign resources to a VF when the VF is offline, and the VF
> is only usable when it is online.
> 
> For NVMe, software must ask the PF to make those online/offline
> transitions via Secondary Controller Offline and Secondary Controller
> Online commands [1].  How would this be integrated into this sysfs
> interface?

Either the NVMe PF driver tracks the driver attach state using a bus
notifier and mirrors it to the offline state, or it simply
offline/onlines as part of the sequence to program the MSI change.

I don't see why we need any additional modeling of this behavior. 

What would be the point of onlining a device without a driver?

Jason
