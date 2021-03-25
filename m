Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FDC434983F
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 18:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbhCYRhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 13:37:07 -0400
Received: from mail-bn8nam12on2043.outbound.protection.outlook.com ([40.107.237.43]:3040
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229676AbhCYRgx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 13:36:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CkoB5iB8fm+j+jXiPrOvOxQAvVdRqAmMjnWW1UyAhlP6tQYxnTAbIWRegxdlCU3xC7Vpxr9iLsNTyp/qH88Si4Bs4mINLfC10JouZ7YIeeuOD9T0vseKJc8tovJuK9KZiO2N4lwIcirq6C+pw3mFqriRtyvuAltkMHfm5gAQxwItPqp1MWZsfLPW3d0L1XVWWKX2qeyIbZCoci9FPG7VJL3NL30yZPYOgHTE3yjSkh8UoR5J+OR1IUHQeNlCZM7ob26siJhyIVHHj9DvAucJIXSpP8nKjk82jZCOtdbLSFKloCU8YUmzVDbuviXC+rSQ0IRFkLriWtlWFpj8F8TGNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C3lGqG6BWvw47EoBsUQ/8ytSaXn6G+HNve4YkBRWZk8=;
 b=g0qhmCqMvv4RK1/kLf6s4BFnIPh2Lmj7/QTyzlIhauSvGxJlluY/PRdjd20NhGZvzT4B/vEDcovw0GI4Cr7zFlXZ/0zwxSIjUQQ8WnlE3xAYZVCMtSjZX8wiudyh54dLdR1Y7rhNt3I2IKdBqYfA7ryraH/tImULGar4GfzWf/YZTRcpBHrBDOsWZq5g7onVfUkbl8bmzm1kH2Ji7neT5h2YY6dzkuixv+RJ3va7+l5F2fLAmTLb++gbuivz0/H2pLX+JQK3vB3Oj6Kratkx/ilucfa5k8BwPjVMRVJbXhsP6n4/m+nVYb7ODLxbgX02GIcpkdg8EGodtuuPE2iYig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C3lGqG6BWvw47EoBsUQ/8ytSaXn6G+HNve4YkBRWZk8=;
 b=GyGcBHulzeIH5UM0jPj6mJRmIXK/iRsICrqB+4kI6BAS+X+Z+Ya9If9jyUBEtkUD3Q4TY18alHo3/WAzJbwBm/hMl5h+MLaBn9Hg/CpGNrnSpW4+I1zAO7597/q4uFnJOOV643M6ZuUrb2cb2KQBKT9nnkcs+h/Vcip9wbAVBCy8iN0NfHkFid4Ks/c6QyYZKsODKBZfH41xu6qQ0Hq7asHGcuipISo+DFwijJfQNAtRwph9IEEQQ5wQO5I9UIBLGpmqnb7Fn+kHbBP+Y4QHqas02y3JHpbwBbvxiiHxgX7gbXu6swp3x3XQR2UwyujNElMf53H9jhPIryf6pmv6NQ==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1243.namprd12.prod.outlook.com (2603:10b6:3:74::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Thu, 25 Mar
 2021 17:36:48 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3977.029; Thu, 25 Mar 2021
 17:36:48 +0000
Date:   Thu, 25 Mar 2021 14:36:46 -0300
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
Message-ID: <20210325173646.GG2356281@nvidia.com>
References: <20210311214424.GQ2356281@nvidia.com>
 <20210325172144.GA696830@bjorn-Precision-5520>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325172144.GA696830@bjorn-Precision-5520>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: CH2PR11CA0017.namprd11.prod.outlook.com
 (2603:10b6:610:54::27) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by CH2PR11CA0017.namprd11.prod.outlook.com (2603:10b6:610:54::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Thu, 25 Mar 2021 17:36:48 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lPTuY-002kfy-V0; Thu, 25 Mar 2021 14:36:46 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a526200-005d-4578-0fd9-08d8efb4911b
X-MS-TrafficTypeDiagnostic: DM5PR12MB1243:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1243103D8C552975D96F1ACAC2629@DM5PR12MB1243.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZGwF6af37sV7clJNUYfkW7lpwcDV7YvyrmprNqQGpvpnh9m9DMBq1w1xn1dDk3r596uJ67gdbR5yjelMxUZ7xv/J2HAca/mPpr9sf99fnydBzY6FeIp66Ouk1zEW5onP57fS0w6Hoo3ueAPXZeTwfBGXnsAcRkjuUSMdaVxf5y7I5VLuvpuitpd+kT3cKrvwNeqXTvNXF2F/ORHSpp9ggPuHcWswycqIqZ8FxaFxnVvPj3t3L3t+I6ONuUWsMYnP3h9OrBru7Sv9HM47w8bYwo+NuRBGDr7om28nhSsRLY+x7CRcs13BJff0CkoBD+Qq1Sj6PObwnAD+S6464Dcv+G6HSgFZ5H20Nn//o+SVoqmaGx3D6KbXZ5o+uO+gF7scTrFqrjK6btkVUdQi8dtYc5EoF62cmC6OuFMXClVUbYjXHFBnbTRAFmHqJfzcjaHcd2VHfHtkQXi38ORL0yGMgO+OmLSPpvShCh48T4qZVkB5k/cDJz3SBY/HBZTWpngMQ5B7cXGwwuF8Wbbxoz8pbkqaSfTxwBhGXgYZo8D1wEJyBH/yjdHljCfdvIiY5v6sZ7HgMAL0hAzhY9M5CDrjTq2N4pWkLBm3Jivc7yQa/xXHScgv4yIlf6RvrZWe7/y5O+qlh3npOgwwu6Ss7e7ekw/6Y8NGcsWMN9nh4/TZFRc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(366004)(376002)(136003)(38100700001)(426003)(5660300002)(54906003)(7416002)(66476007)(36756003)(8676002)(26005)(6916009)(186003)(8936002)(9746002)(9786002)(2906002)(66946007)(4326008)(2616005)(316002)(478600001)(83380400001)(66556008)(33656002)(1076003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?VB8hrdCEufVaWa6e+bsNgCnlrmn64JJuR03+LdEpQYCSyue4JUCUQPLHw0Cc?=
 =?us-ascii?Q?4Ze4f3/0MeFFewjqQM+JWtxVOa+eKQ0d8O6CPbRiWVAsLWsj01PAELmpNzFw?=
 =?us-ascii?Q?vGEu7K3blxdt9AakA3jDHGAJlAEMc5Mq1IIS4eTqLrzGeZ2EI/tYK+z3zM7+?=
 =?us-ascii?Q?ae7Z2u+7W+Lpp2P/2liwfshGLvqkzvy5xGMYLjPLz9qInIClRnZDzNZJtpaQ?=
 =?us-ascii?Q?e3POxDGRt4MVWrkClGCsfQCFqzpMeBeoYiu1WuocXkutfADolITTnkQfVDFi?=
 =?us-ascii?Q?TDvWiC/aXWTDvcEDZaRS9akrcdp02vOwYZXgFdp6V053u1QEziK2v+SlwTkz?=
 =?us-ascii?Q?1TPylF7YGwrsSO9B0A//cnPDX9jvEy034Ts7bFwafszXLDksisGYXUAMh4HZ?=
 =?us-ascii?Q?Zi9Mzi2WWDd6OIDolxOosxan9NkWV9C7PGuQFryZube6Oj8xRsZU0l52btfx?=
 =?us-ascii?Q?4NeGdpCAnpjueL74R0pW4C9FIwq6cxGMlrE3tKA2YgSIHtgRLYAimoGLtYoo?=
 =?us-ascii?Q?o0JJ71cuoYnfDqCBu8Ogje5gRL/GBHtYZeeVy9hF7p0R7QqRhGSd9jJtndjW?=
 =?us-ascii?Q?MSAcTsdx7UOHau3FTK2PEoDs4NsxPKLOBT9yH1yQZHixtsjaEdJCP2yCESz9?=
 =?us-ascii?Q?d06Sjvzg46mcOL8bdyEJfiKxZzgQqXWnmSLPMueXpsCVa6bajmI5oWWyCRBq?=
 =?us-ascii?Q?tdwzjkGK9Mo42D6EzxKR8UnvDDJQeW+B3xIEBbEyuWsol63CiJ7MZiO55rfA?=
 =?us-ascii?Q?VvtgtzaZM4s5W/V0RxX0HZAJQgXthqjTSDW1CYL1+cIf2f3I6PaFiwBiXICd?=
 =?us-ascii?Q?kPcV+XpC75LmZBBH0YNt89yLKzYE8sof1xShNYnW5zC32AgfFT5JKlJ2rixL?=
 =?us-ascii?Q?rl3sDuiJq6I9nNYW05IMvH4Qo7jpwPKrPC30mVUlqkHa2Hc4Az8KoJfUMN4D?=
 =?us-ascii?Q?/jMW+hSiuWYCzFz8OULH41Woh4M0QryVCoQ2YvFYrrWkmH054HcBXBt7Pb7p?=
 =?us-ascii?Q?iXK0nmX0eHZFztVYkOtBNW7AKoY7665mkwsBCmAB34E2DD80mE0FpEPUiGfu?=
 =?us-ascii?Q?8GkQnpVXNpPLS6979QNp2c3TEhKqrclBEL/r/4YA9QpYmHOUoBxI5Jg5fbDg?=
 =?us-ascii?Q?Gbl9gtjhrlogR8w+/h0EyqkfZpddd8UZOb2kNQR0rkhZVJBtLOn7/KU8oI1D?=
 =?us-ascii?Q?mSQhrAW6ho+4JoJoGrt7S3UjC+f9tC/ms1O/koyv+ViR7Tcj0zZrSbyb78VM?=
 =?us-ascii?Q?azVISuWSX5twV/IiEoid7tPvmHrnWaZgj0JV6VGlO33AG9ECW81FnUDkHLIq?=
 =?us-ascii?Q?KFaBbhhx2mvc0TF6y2ZWWxEs?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a526200-005d-4578-0fd9-08d8efb4911b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 17:36:48.1746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wU0Q+MqF+tCdZ9zKhWGO6J6ntefceQKUD2ATTACto3y6A+Hkg9EEjFJy1QWaiVvp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1243
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 12:21:44PM -0500, Bjorn Helgaas wrote:

> NVMe and mlx5 have basically identical functionality in this respect.
> Other devices and vendors will likely implement similar functionality.
> It would be ideal if we had an interface generic enough to support
> them all.
> 
> Is the mlx5 interface proposed here sufficient to support the NVMe
> model?  I think it's close, but not quite, because the the NVMe
> "offline" state isn't explicitly visible in the mlx5 model.

I thought Keith basically said "offline" wasn't really useful as a
distinct idea. It is an artifact of nvme being a standards body
divorced from the operating system.

In linux offline and no driver attached are the same thing, you'd
never want an API to make a nvme device with a driver attached offline
because it would break the driver.

So I think it is good as is (well one of the 8 versions anyhow).

Keith didn't go into detail why the queue allocations in nvme were any
different than the queue allocations in mlx5. I expect they can
probably work the same where the # of interrupts is an upper bound on
the # of CPUs that can get queues and the device, once instantiated,
could be configured for the number of queues to actually operate, if
it wants.

Jason
