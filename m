Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE56444119
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 13:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231971AbhKCMMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 08:12:35 -0400
Received: from mail-mw2nam12on2085.outbound.protection.outlook.com ([40.107.244.85]:7457
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229816AbhKCMMe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 08:12:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e6pyUCqnPa6lbcDU0nt31uIRw0ZluQHrHVBzQIhq9TqBgGsqQ5MIoffJEZu++Ljbsm8szfqYadcpkbQeXWljDh5wCToAeeo/c4RhK8X2kR6O3R4YwR6FWxElXQAqeL9pnT9bIRuZ32LfiZxlR/MLYL1h4xkbOHkLwaEP/FRnoWC0upZjgfZXW/eVp34cwA3XsQJiAaweZmk8RelKhI1aoOOhEns/ey1INa6NokThZVOKBb2d9nEn+PTwl/f5ZUDJ9f/x7MQfFtezB4zINH6cWugaa4Ck5C7DzRWqwnzaH6Hzq44IZswOa16y6ldYhSOjuZ4UYC0sQBmxaWDSYHB7ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mGmrwvP+iNXjoIj9A2YHRYzIboWwWlBAc+gymArHQJI=;
 b=nE7wIAjWZAq6fj4bk4km6Izy2NKkAKxKAqYpUB+jAjegPi17iTD/zAUHYckIMKhh/lEq7+go1fDAVk4xfdrEihLfKokx6E3rzM6/7pTgDaUm8U4EuTkbzFtmOqVtbixA+X2qXj1RIx/16oEDZ0erAzn9lWmmjvgsfzkQ4tB733MQwlKvwObnWtpvbeGB5/1EjjeAPNgtK49mcqdpjtAiTtUTZ3m8aquZ48IeMySSIlxom7jorDSt6mUNCaqTPWodIBsAKBMmIuqCBf0YEIPjfKrkYbzP6OxxKmNcYwmciN77EIugs/bGfDAXzyH7VPPyjenYaPUPDvni0QWwZUeNdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mGmrwvP+iNXjoIj9A2YHRYzIboWwWlBAc+gymArHQJI=;
 b=MATO5AI0Yi3+YBOqFta1n3cJgCGTPri6MVZUyMV6bONdWyZTw3bfIWBY0DskqfSBlWPEmbN1hG9KkzSLMGx5+ua5ugX2Rc+GUlVdgY2VValxZ+bcW2XkEZm9lv06V7AWHY1xU5eS7JYw5ISoFY6YxpmF9iCccukR9VQxx+mTgrbEN7qeBm1K+dR99fM9ZtL7VwPKMUQqtIYVtJ819p4AKFHJmELJafHG1Tu4tNdfv3FP7hleTiNHEiQfcF8SuEfoaDlZPwCxq3WnaeBUqlHS2ZzmIVdB1njaLd+6Kxqo2XyNWIfBg/uYyfPwfRTjuPyXSlS5DUNAbV/du6c0hrGnYw==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB5520.namprd12.prod.outlook.com (2603:10b6:5:208::9) by
 DM4PR12MB5103.namprd12.prod.outlook.com (2603:10b6:5:392::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4649.15; Wed, 3 Nov 2021 12:09:57 +0000
Received: from DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::8817:6826:b654:6944]) by DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::8817:6826:b654:6944%6]) with mapi id 15.20.4649.020; Wed, 3 Nov 2021
 12:09:57 +0000
Date:   Wed, 3 Nov 2021 09:09:55 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211103120955.GK2744544@nvidia.com>
References: <20211027192345.GJ2744544@nvidia.com>
 <20211028093035.17ecbc5d.alex.williamson@redhat.com>
 <20211028234750.GP2744544@nvidia.com>
 <20211029160621.46ca7b54.alex.williamson@redhat.com>
 <20211101172506.GC2744544@nvidia.com>
 <20211102085651.28e0203c.alex.williamson@redhat.com>
 <20211102155420.GK2744544@nvidia.com>
 <20211102102236.711dc6b5.alex.williamson@redhat.com>
 <20211102163610.GG2744544@nvidia.com>
 <20211102141547.6f1b0bb3.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211102141547.6f1b0bb3.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR15CA0028.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::41) To DM6PR12MB5520.namprd12.prod.outlook.com
 (2603:10b6:5:208::9)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR15CA0028.namprd15.prod.outlook.com (2603:10b6:208:1b4::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Wed, 3 Nov 2021 12:09:56 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1miF5X-005OwY-CT; Wed, 03 Nov 2021 09:09:55 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78575915-3277-42bc-f1fa-08d99ec2d9c4
X-MS-TrafficTypeDiagnostic: DM4PR12MB5103:
X-Microsoft-Antispam-PRVS: <DM4PR12MB510365FCABF2B67DED12FAC2C28C9@DM4PR12MB5103.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E39PKwpeoeR5mTeOCRzcWgE9ywe9WCz9N2/g9SH38IzTXj09fFe5iD/k9CiHSkeoTSEn7lIo6ZbFIMHyo0XjbBerwfFn1X6wAVVO4GJfCEgtgAemIGGLJhbtgwe5TzUvnNuygmzJ+El0xvSblNv5dZ1Oyy005rr0Vua7BLtcA9qqpMPiyVf8+MvbnPvByJhGy0pSYAzzVnZTFXGtjWPBRePVt/dALMM+A+sDtGmVwJLXmXI7RX25ZgeqQE6T6yM/picxTCIsID8GmpSDEFRLIeLifh336pBK8uxhfp85RnbzMZbL9owf2gWhoocS/pcXQP52O9wOG6Hh2jkn/OLxEKQeicUTb2NuJcFDNHtsIdwX+qrZrl4Xh63bpMegdur0ez1tDobZ5rme755a/BY2Hpjxc+K8hG8YdvOS4MxlJmfdVscHpnaSoL9Hy1SDRFyMbbrArxjLfelS/w9IaVMF9f3DeKacrVG8lU9h/sWuWY0WlUn7Zl7KgvmITtuxFTzW/6d+OkKkqZeZI4VE7AmsiS5WS2rTM6YMcIbdg1G6hxvrcR2ds3ll18s9I5QTCJzv847/8FbHpG0taDi8f6xatjNMfO3wxKU5TrLps+NfUBYfgpg8JGga9qJ1G8AhneJtdjR6ak26/lR+CRPlqF9VdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5520.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(83380400001)(4326008)(508600001)(1076003)(6916009)(86362001)(8936002)(2616005)(9746002)(33656002)(66556008)(36756003)(186003)(9786002)(316002)(66946007)(2906002)(426003)(8676002)(66476007)(54906003)(26005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/ipdaYFZCQKqs7fYoigYXPNBEPxZDWg1QEOM5aTIIBaZwX7WKoqtXn+rDBJj?=
 =?us-ascii?Q?LKOgERlrLRiw0V5eWd5B+eRHwhg9FKEzFYd86a6nZ9nfnZ7trBMK6OP8hvcD?=
 =?us-ascii?Q?grCV4GjSbIvNjppztt2RMB96zqwRoazLh8Nuff+IsU4HrwPdnWqqWp3DNfOj?=
 =?us-ascii?Q?dRB8u4/mjyCth7XRdZq02zuBqSbTvdfHaJ0jx0ANUIUUQvbBhu3SAmmjXX5Z?=
 =?us-ascii?Q?krjnyC6S84cLwfymZDhNEpQT7zhh07VA+t3f1wijeBgTcbxGIYC0FwjBGySR?=
 =?us-ascii?Q?l5PMPUCiFOo0QWZKAZjD3PAfXyDg3WPNb6d5OhegyM4PrGZVHZSaudRA5BIC?=
 =?us-ascii?Q?a11H2Sm0C4acpeDmccbPf9xtLAX+LPppw62Jhbgior4Q/mdA8DsrN6FVOmpX?=
 =?us-ascii?Q?8tkj3VrNMtcL2fF/kAMZMdqckc4pcXDaJXXS3aXhDmYSnwSQFXUjDiUrADhw?=
 =?us-ascii?Q?mDZnkq++QDe9wvafmtIHmYORCWUs1qEadtn23dZH0pDmcRgMfla/G5Nf1JeZ?=
 =?us-ascii?Q?+HJNT2E09yty/xgKdq4iRpfV0WlFPkEClaKwNGfIZbMQWiRvC01z3d3MIAoA?=
 =?us-ascii?Q?RGISXwaHo80Fyi3iyt0fw6B5m1VNRTSz/B9C8S001PseIYK2EvSPL1NGUuzV?=
 =?us-ascii?Q?8DoSSGe0mNj/kjB1jAOoY/cf6MnS2TeDpSSLtmS/7GtGp1rJVircSWWSx9Gl?=
 =?us-ascii?Q?VxsT/8Dh7v6Eu+dtwggx3qw4Cqdl2Hj7Rlgs+YAYPX+GhQFf2IqM8nBmSgXD?=
 =?us-ascii?Q?g1vAEIPjKlC1CrH4Mv9KUa15ke/C+2kI/SsVmfgkKykR0NIkuE2QO1HSDhMD?=
 =?us-ascii?Q?vuJuXkVsIyVf8Z/2ix41Z9YGGL4lUNER4qSyvfi23JOdq62VbPJL6u/IaLsL?=
 =?us-ascii?Q?7b/A/hYgBPTBnzPDBOvahu2Jw4QSdscgy9ZVpQZp4vOHLtIX2ewoiWcXxanF?=
 =?us-ascii?Q?JC2V1WMAj6nTdXJXAqFYutF+QR0JSBxW/zz5nTRUNiyVlJhIZgAJ7lwctN05?=
 =?us-ascii?Q?q3xC38wceQN2eciL7TYUX4UCRpWOv2rxmUCC/PYpvxIZSUQzKQmN4SopJe5y?=
 =?us-ascii?Q?zWJwwmgoZ6hhlIsqpqy2UML54YxdonJ2ZAHGZGlLGgp2kLSAwV6Zumzq1DUf?=
 =?us-ascii?Q?A/GTzKcBVr2JcFJ+Nn1BYsJRMIz4h54hqYD9nr8dT8onH6ETmaMc5Y0RVFQ8?=
 =?us-ascii?Q?pwTJicJy1xUFGDTEjsR25HFGNEWl+1jUWJsMcUfWT5+bzc63lXPVWd+qRgsJ?=
 =?us-ascii?Q?GmqcOPRTAoqY2GKZYLZDIhXJp0pvLyyHvFtbTBRQIzj64WdLMvppTvxReoEU?=
 =?us-ascii?Q?UBcJXh9mgt/4R54eAy5f6ZjTgnCMmXSNJG0UrzvxFLKw++UaMBn9RzcbMWzZ?=
 =?us-ascii?Q?UHGJmbmqhzgY+RyWRysfvXHBilpRZ0rdbiDbnn0kfailE+/oMEve8piLlU/g?=
 =?us-ascii?Q?NWAc3DG1801A9DOAWVBUKr5zgZOr4Lq8lDPBP816eYU3mUQX1p21ILwebMtS?=
 =?us-ascii?Q?FGSjaMXD1MzFsJv2JpLy0oXWgpjZy493gI/KETayCdHM2EzmynXGNNEkUvbh?=
 =?us-ascii?Q?32SsC1woxqD93lkeFGE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78575915-3277-42bc-f1fa-08d99ec2d9c4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5520.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2021 12:09:56.9648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nA6Oyvc/ynLpYdhol8QSP+fdN2TLUd0Gv3rnOax2j5jNzDpWKoDn6Fm0F8h5GraF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5103
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 02, 2021 at 02:15:47PM -0600, Alex Williamson wrote:
> On Tue, 2 Nov 2021 13:36:10 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Tue, Nov 02, 2021 at 10:22:36AM -0600, Alex Williamson wrote:
> > 
> > > > > There's no point at which we can do SET_IRQS other than in the
> > > > > _RESUMING state.  Generally SET_IRQS ioctls are coordinated with the
> > > > > guest driver based on actions to the device, we can't be mucking
> > > > > with IRQs while the device is presumed running and already
> > > > > generating interrupt conditions.    
> > > > 
> > > > We need to do it in state 000
> > > > 
> > > > ie resume should go 
> > > > 
> > > >   000 -> 100 -> 000 -> 001
> > > > 
> > > > With SET_IRQS and any other fixing done during the 2nd 000, after the
> > > > migration data has been loaded into the device.  
> > > 
> > > Again, this is not how QEMU works today.  
> > 
> > I know, I think it is a poor choice to carve out certain changes to
> > the device that must be preserved across loading the migration state.
> > 
> > > > The uAPI comment does not define when to do the SET_IRQS, it seems
> > > > this has been missed.
> > > > 
> > > > We really should fix it, unless you feel strongly that the
> > > > experimental API in qemu shouldn't be changed.  
> > > 
> > > I think the QEMU implementation fills in some details of how the uAPI
> > > is expected to work.  
> > 
> > Well, we already know QEMU has problems, like the P2P thing. Is this a
> > bug, or a preferred limitation as designed?
> > 
> > > MSI/X is expected to be restored while _RESUMING based on the
> > > config space of the device, there is no intermediate step between
> > > _RESUMING and _RUNNING.  Introducing such a requirement precludes
> > > the option of a post-copy implementation of (_RESUMING | _RUNNING).  
> > 
> > Not precluded, a new state bit would be required to implement some
> > future post-copy.
> > 
> > 0000 -> 1100 -> 1000 -> 1001 -> 0001
> > 
> > Instead of overloading the meaning of RUNNING.
> > 
> > I think this is cleaner anyhow.
> > 
> > (though I don't know how we'd structure the save side to get two
> > bitstreams)
> 
> The way this is supposed to work is that the device migration stream
> contains the device internal state.  QEMU is then responsible for
> restoring the external state of the device, including the DMA mappings,
> interrupts, and config space.  It's not possible for the migration
> driver to reestablish these things.  So there is a necessary division
> of device state between QEMU and the migration driver.
> 
> If we don't think the uAPI includes the necessary states, doesn't
> sufficiently define the states, and we're not following the existing
> QEMU implementation as the guide for the intentions of the uAPI spec,
> then what exactly is the proposed mlx5 migration driver implementing
> and why would we even considering including it at this point?  Thanks,

The driver posting follows the undocumented behaviors of QEMU

You asked that these all be documented, evaluated and formalized as a
precondition to merging it.

So, what do you want? A critical review of the uAPI design or
documenting whatever behvaior is coded in qemu?

A critical review suggest SET_IRQ should not happen during RESUMING,
but mlx5 today doesn't care either way.

Jason
