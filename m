Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67462356FEC
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 17:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234119AbhDGPOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 11:14:16 -0400
Received: from mail-bn8nam12on2086.outbound.protection.outlook.com ([40.107.237.86]:61536
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1353380AbhDGPOM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 11:14:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=giRIcVlPUr9sA4/QGOWPrJNyTZoN4LCDopV2ez1o66YXfyEj2CfkK6Cc6pE2GpDA+0PTtWeSjcD5lt2UuUwhz8XDM/qzDzADdu1SpkOkLfMHZ48oxGCX1sxrr9n/XqEkc5EMmf1AI0bYo4NRbd+pNforVteizM2F7snm4hMYGpkk3eOS8bFDs5picgHx/wNQbLd2Xl3uXxr8V6kPpMdltuHN+ERkx1YRHoh5JD/AxY8oOFOffSzKvb1COED+ZlKPlM0SX8wl4ycJPQT/BJu+8J7FUxKD2yE4kAVDjuzIBqBrbsFOCgzgSi3ZesDnxoybNIf092nMe8Y18oeVA3zDBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tUv143bcuRi2EFMp1m5OFKn9N2xZ2jwz+laTpAeTINU=;
 b=ZyUkKKXGXjyN6wf1dwmC3BAQYwaQ+VZI4bHnW1KurFHU8lnbtOsFZRPB6oTYBe7ODQ1QAQuhVkgaNicDP0k1eGS03RA+tzlnuMcnyCLUCOyjoOwnvZFm4fPNz1RJflu98azWyNeHrfMA/JglRV6PCSfgsXMGazrK9quUt+YzN8lUa9kQW6fT0HUszy+7AtEfuI5C5OhYiAHX7uVOGENWfQxu8CsloJmt4+xT7b8xuFgMKyJ0+9j0J4XCLhWcQc3AQLwlj6ioCFEJW0EhcnVPIo/buZNmFaMOC6KQThAAEIk9uYHYnsiurptbnL1AA46mYfrR9cxtyvrndiX2ps17Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tUv143bcuRi2EFMp1m5OFKn9N2xZ2jwz+laTpAeTINU=;
 b=LoPck79pvmUQ6DI691u0Vnh8mFVZzv6ZZcxELyo71Kgu+Rfg/s0UkQHF8KBWVyBeqR0YDMd6H/PA5Ef0CTA/dKyuqIJ+V1J1ywymAfs6vSSbD3HWSgxNB6vvH/ueKpbipos7JCzRET70/Qi/ma0VpU6xkbKMH/39Q6G3q2ifwPoKoaE8NCiBhKlcYJp25iQiI1zX6cYkN284nQncx/HdsV8gT5ORKguo32wxev54HNh6f0Ui6OQXH7UlTsBH792feW0oPNRDNmbsIe1Gvpmf2PXQInxe+UordHTVXxqRmpKo8avMBExHI9fMn96OmfWnYPvsZflD7fbbgKqppzzvyA==
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4499.namprd12.prod.outlook.com (2603:10b6:5:2ab::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Wed, 7 Apr
 2021 15:14:01 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.032; Wed, 7 Apr 2021
 15:14:01 +0000
Date:   Wed, 7 Apr 2021 12:13:59 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Karsten Graul <kgraul@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>
Subject: Re: [PATCH rdma-next 4/8] IB/core: Skip device which doesn't have
 necessary capabilities
Message-ID: <20210407151359.GI7405@nvidia.com>
References: <20210405055000.215792-1-leon@kernel.org>
 <20210405055000.215792-5-leon@kernel.org>
 <20210406154646.GW7405@nvidia.com>
 <BY5PR12MB4322E477DA2334233EAD5173DC759@BY5PR12MB4322.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY5PR12MB4322E477DA2334233EAD5173DC759@BY5PR12MB4322.namprd12.prod.outlook.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR08CA0013.namprd08.prod.outlook.com
 (2603:10b6:208:239::18) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR08CA0013.namprd08.prod.outlook.com (2603:10b6:208:239::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Wed, 7 Apr 2021 15:14:00 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lU9sV-0026ae-34; Wed, 07 Apr 2021 12:13:59 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1af7bdc3-a69f-4c3f-a7ef-08d8f9d7c5fe
X-MS-TrafficTypeDiagnostic: DM6PR12MB4499:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4499C69ECDE7B0029A114D29C2759@DM6PR12MB4499.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3Zm9ZCS5bbQLaePwAK9vaFnqURNEZGH0uOSIEc/IglF5B8oBvgv3yq1wE5TXmm46d0G9coR4Ld6eFf0hvx9qdromg8KXeynK1/Vyudt/Ig6wO977CwZ44iRb9kcQIiadSgRDjgKHb3STfspN6/wnJHUt8BqBTZ5M61Z6Hm+dll7IVLUaW0V+6whmzsQ2OFi5NpIplZK/L59Ex5igfTPS8fvj2Ez6JUOAxWcacObtQikm3tJILaN2U8xnZD9U0IEm0gVNDUkhvd3OH7D8Q9ZA6NbbUZnSyCf41JggvnH28jpUcH2oz2TwBw65I2qL84D2stXg1Lp45xUGILAxSo1AT+DQLn9NVZplVJ/3JeTG4lixCRnDBlo99RT0a3WpgDlAYpqbat+MrnLwTCrem+NskQNAf5o9FDNv0fAZph8+wABev3/lXioIxOq1izJaglrSXTinTwm3PUeVA/liFrH6LTmT5JESCd6oAOf6osLYkdM7AsbaRKhAlLVStXJnT9WjdCWjc6nXduRMIaMvKxin5+iPmVW6Yn7ayrLdCiUnUn3LWcfRPenjIlX/V37jg+TdrXP+LsQpzhflEFsTOGICRmr2IcE+uSDFaQEJYc+EFvxse6jWRn4kfmrN1MYugVK6XxKaWWRjt550yF+yyxOBOKaAxEWn5WjakPqJFZ4p6pk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(39860400002)(136003)(346002)(86362001)(426003)(38100700001)(6636002)(4326008)(66476007)(66946007)(6862004)(66556008)(54906003)(26005)(37006003)(9746002)(9786002)(5660300002)(316002)(1076003)(2616005)(478600001)(33656002)(8936002)(7416002)(186003)(2906002)(36756003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?XKSHEQTwLtDs32da/LiTDnJxBE4lgnO4EonJQhpzJBk/kyHYFiG/daD1j0DB?=
 =?us-ascii?Q?Vr6MYbwwGG41q9SKRCkRnb+Q9VDdsucEKRo6hb/dUptAtyi2lul+D6YrV6UE?=
 =?us-ascii?Q?0cqBn2fY+fsGkSHZQvbEo+HvFYpGCscK9PTwT3/1Jmcosk/hkN61v6wlbQb5?=
 =?us-ascii?Q?bCB5Hqul4SfYicVlufw2j4B1ehSoxGbG1JTHlV3uEiMDWSo/2k/ZFNmwGCk5?=
 =?us-ascii?Q?kvK/+qr3n2ekQp5fzAbLCkXSswM8vTuJt42USOoUv72fwjDV0Iat6TEq7tcd?=
 =?us-ascii?Q?6ykADWLNg6scp86kw+WvvP5T8wUlNeJa3h28P10eRBywKFvOBMTTfbma/9ff?=
 =?us-ascii?Q?OhZYaCpU3cFsAiZnrZSrwpNRxqn7YyWBEBB90MzPWFATgTPd4YgkG61n4UKT?=
 =?us-ascii?Q?DiZpTlCi2GGMQ9EOsxsrMxLdOKyR5ZjwoS1wmiA8ueVzE1F00y/n3YxA4rM3?=
 =?us-ascii?Q?LGyZ0Zwo8Gcde1IcrHM3xSHrCJ+xaMbFxR3r3WCGnxdWNbZIEQyNLAFOWq+y?=
 =?us-ascii?Q?aeNNunZMvAHpCFTXC4xBBlbkbPtYL6KifIznJpV7BUeMXko60csAyKxGDYv9?=
 =?us-ascii?Q?ZSryl0dszbqaLuBR4RnweJ7qDIF7sIXUVytszbwBHxpavhjQxXOS7dyQ8Vub?=
 =?us-ascii?Q?/PwZTQM92ixVBJXiVv89GOrQy18NCVGMKa4tuDVllT7yLYSmIwJ19OJ+HcOb?=
 =?us-ascii?Q?OrHy1XUnM4aS5pRD/WdVDPAm7+Pmavzikq4c9fCGj7b0p4rALt9PUZB9nObt?=
 =?us-ascii?Q?jzhJbJNtI/lVVXI+N4sGr4MOGX4ot0ZueNBy2HnsJ44vrLKnNQ+sm/MojHd1?=
 =?us-ascii?Q?y3NUuszyUE1A3r5l6nu4qmbUXyU/hkprXP8p3xsdfZ7t0vk02q5e2ItKZL3M?=
 =?us-ascii?Q?V0UVfzzXvSzAtuwAwFPp1iJdzaIhbyR2RNyxVrcgkDfoZvRb977lGvFr9EBU?=
 =?us-ascii?Q?A5R86xaaCKvomrM88ZBtKUnk8j65Ra/JOy52rzvDuR3IStTXf4NTkXqcj+k1?=
 =?us-ascii?Q?FLowxUoMo4zIv5piRA6SV3eYZ8gl4H1cpVcQ6D/a9kNpfYgcZ4y6Ag4s/NCV?=
 =?us-ascii?Q?GZRLCy0n5wXmBeJh7fReejrTPyMnaWqD9Cm7XNmb8C70zvzYloyXMUlmkYTO?=
 =?us-ascii?Q?d+7qqZ9eTRkVLNVrNMSc9EK/E+25diOQLCgdkXHy2Mo5I9RfVDtj7JSI0A81?=
 =?us-ascii?Q?Vg+uc8RBj7YPmblmCz2OsBbylMv4VfRfkSRc8oMj+GlG2t5udKQ104llVyb0?=
 =?us-ascii?Q?fqwC7pJjNotnxyD/salodOjahsxtRKJWlMOozeel4rsWhqfQB+yhkw+XebRC?=
 =?us-ascii?Q?pwbtdPutc+jz7L0mFCrnNb3/WEHgP2Py6otBifP1tEgCoQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1af7bdc3-a69f-4c3f-a7ef-08d8f9d7c5fe
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 15:14:00.9399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YghhCiHUG1c3joIBV/guhiKo6ouV0GhZlCLvHPL8Dt3vpjzeKogzZDmMDYm6ZnRs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4499
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 07, 2021 at 03:06:35PM +0000, Parav Pandit wrote:
> 
> 
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, April 6, 2021 9:17 PM
> > 
> > On Mon, Apr 05, 2021 at 08:49:56AM +0300, Leon Romanovsky wrote:
> > > @@ -2293,6 +2295,17 @@ static void ib_sa_event(struct ib_event_handler
> > *handler,
> > >  	}
> > >  }
> > >
> > > +static bool ib_sa_client_supported(struct ib_device *device) {
> > > +	unsigned int i;
> > > +
> > > +	rdma_for_each_port(device, i) {
> > > +		if (rdma_cap_ib_sa(device, i))
> > > +			return true;
> > > +	}
> > > +	return false;
> > > +}
> > 
> > This is already done though:

> It is but, ib_sa_device() allocates ib_sa_device worth of struct for
> each port without checking the rdma_cap_ib_sa().  This results into
> allocating 40 * 512 = 20480 rounded of to power of 2 to 32K bytes of
> memory for the rdma device with 512 ports.  Other modules are also
> similarly wasting such memory.

If it returns EOPNOTUPP then the remove is never called so if it
allocated memory and left it allocated then it is leaking memory.

If you are saying 32k bytes of temporary allocation matters during
device startup then it needs benchmarks and a use case.

> > The add_one function should return -EOPNOTSUPP if it doesn't want to run
> > on this device and any supported checks should just be at the front - this is
> > how things work right now

> I am ok to fold this check at the beginning of add callback.  When
> 512 to 1K RoCE devices are used, they do not have SA, CM, CMA etc
> caps on and all the client needs to go through refcnt + xa + sem and
> unroll them.  Is_supported() routine helps to cut down all of it. I
> didn't calculate the usec saved with it.

If that is the reason then explain in the cover letter and provide
benchmarks

Jason
