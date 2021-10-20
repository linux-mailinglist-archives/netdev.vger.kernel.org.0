Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C858143534C
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 20:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbhJTS7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 14:59:39 -0400
Received: from mail-dm6nam11on2052.outbound.protection.outlook.com ([40.107.223.52]:40375
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230076AbhJTS7i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 14:59:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DR2Ju+mNaAulOoZVqA8FYU7+LmU5Ym+LFfa6fWGMFQl+riUvAc8j15a163CYYHGjYQT3Mah3Mk336tjiomuF1J5TnPocHVAhB37Er/Sv9viFK9vKbmnCrZVflznWmdoh6VgRlaiiMUlS50iGwugyWd4s2SHJZo3lJg2sspnUpGtIg3WuiwDFnpZrJPm8bobfdGs19WfluDV7LB2f3e3/94F07zsLAdnSF6ACilirSwzW3ibCIJmyqNchkxpM0VbMcpzs+RuO4wFohf6VfE6qaZhreU1307XQZcTjlA7MYV8mL2PEuOpXkAonvAOX4gTVYPYXx3f4/NA0nuYoxNM16w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ou6q5DX0fBbYxkn91N8uNybgyqU5RktsY1MNVUTy7Nk=;
 b=fS3wjeAVrKPjKKj2CETn7fuMvAP1/txQJbLr/FrWdEuPWPvCdUg3FBra1XkKjEbDYOnPMkzfAFbKpqwQ0ahxsZhYtdV8Mm+cTSgPjWFEd2tv5cwNzwXkvPBjsXAK/PAL46vD3vpixCjC5dNNO16MAZ1p+/Y2ShR1CGOkKzaNEYOeO9c6scEOEd9l91kOKWPJrt6O8O7Nw4H+ozhwEDDmAQ16kykB5NO/P73uag9x/ENGWUAjXaQtMe3cKcR5mL53cGdZHwsWU0pnETK2E7+kHMBtBpjjHU38nBwBeOSvyZeCLRtRHWtxbU6nBTP0gbFICobsg/N2sWE6yR3CKgw5DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ou6q5DX0fBbYxkn91N8uNybgyqU5RktsY1MNVUTy7Nk=;
 b=LbwfPOtfWwy0FZJgW246A2/DrwXLFVZVvtWAZ68dtCtB2Vr25AU1oWWbGlLMGytMXyVw5uZdAoDAEKKIgXZTxeNL1nupvcUag9nnbKuLGVjoWopyZ707gdjqxnCAkY1E6ujr4VYZQyGXzldrEKgL94KpfAbV3shCKQhIWaQ52W6DMnDgKC/ee3QE9JYmal2NWV1vb8mYsoy7NRlcuF5b4MQzKoj0V9IBIRTNWAexAjRZ35Uun3gSrYjPFg3Afgd1waYfcV15LLn+KKTGD+LNZdCeyQyu6TlVDmqZz8ZMThKDP2GbSSpUDpspfTcZLtA5Q3nQBmMKmF7Hc/BVeL/XJg==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5254.namprd12.prod.outlook.com (2603:10b6:208:31e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Wed, 20 Oct
 2021 18:57:22 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4628.016; Wed, 20 Oct 2021
 18:57:22 +0000
Date:   Wed, 20 Oct 2021 15:57:21 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V2 mlx5-next 14/14] vfio/mlx5: Use its own PCI reset_done
 error handler
Message-ID: <20211020185721.GA334@nvidia.com>
References: <20211019105838.227569-1-yishaih@nvidia.com>
 <20211019105838.227569-15-yishaih@nvidia.com>
 <20211019125513.4e522af9.alex.williamson@redhat.com>
 <20211019191025.GA4072278@nvidia.com>
 <5cf3fb6c-2ca0-f54e-3a05-27762d29b8e2@nvidia.com>
 <20211020164629.GG2744544@nvidia.com>
 <20211020114514.560ce2fa.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211020114514.560ce2fa.alex.williamson@redhat.com>
X-ClientProxiedBy: BL0PR0102CA0010.prod.exchangelabs.com
 (2603:10b6:207:18::23) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL0PR0102CA0010.prod.exchangelabs.com (2603:10b6:207:18::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18 via Frontend Transport; Wed, 20 Oct 2021 18:57:22 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mdGm9-0002A5-CS; Wed, 20 Oct 2021 15:57:21 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3bd9ac66-3274-4c1d-22dd-08d993fb72e2
X-MS-TrafficTypeDiagnostic: BL1PR12MB5254:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5254977C82C2270486CCB15FC2BE9@BL1PR12MB5254.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mjG84jGD+Kqsr8ToaUF0ue7zo1hXOpjls64E31/2j0iletA8HxElzD0MXEVRJkti61m12PnJsBu4V71ZLL9n05b5b29tK4HKtgbH2dk4Q8rDqbAPLVpTotFT+GoCnKNC6JqDEK97fxbAntNMFK2cu/+iae5r0q8TfUoF7iEyhSP5sdccwq8oFyOPml6uLZnoh8Ll6y9aw0h3qxCmBsATyXlDuVyZpzZAKHO3SKgr1Xbl34qhn7APY7AZrEncxN8MyZ0akbNcU1HWPOdFfo1EeRkLRYt0wahvmc3kkM/3vKwVaisNuAWYlnrUvkQoQWKD/u74nAItKr1AoYV+C2MzjxWfu/L7c5qnuTKc1ZSxRFBY8E3PsWOo8GmX2hI/bXyhfvQgptrJxScxl13hNyu/9o8VXyNkxy4n44dT4yAbQK1Sf+/+rbo572y4FWDe3lo22qspCwGHM0PqWKuKv8R57AXEh6Ezl6KWX7D3cY8aNzh0dJxantoK7pN4e/bjacSYE5lP1sdP5n5laNFtuZA62TdcrICqQKub1r13mE8ChH5feVXjW46N/p/IIDqnZ9bRrICUUj/Ah0K21h24iBJZq+9nYY5ejx9r6GHr2g2XOIkc6S4u1ijqsvTo/yI7WDnYJa2inNP8XWWb5fNv1RwB2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(26005)(38100700002)(66556008)(2616005)(66476007)(33656002)(6916009)(36756003)(4326008)(426003)(83380400001)(107886003)(9786002)(508600001)(186003)(2906002)(86362001)(9746002)(316002)(1076003)(5660300002)(8936002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yNEmwWs1miRbEXcyZ1VvYYgWOUWqxPDtSFjwrjoA467b0tljSJwWpCF1S92N?=
 =?us-ascii?Q?uaQ9TpIeDZc/C9EBWlf0T7iwkTrGSuN0kB2fQ1h8kmWr6aNR+0lMttJ4rQ22?=
 =?us-ascii?Q?/B1aD8Z2/35b6458ge5kRlsnpu1zgM/kDmL6gv8R7S1aIxGfE5Le6bNYbICV?=
 =?us-ascii?Q?oH6y1770Z3POpBnAv/PwaLFItbMN/v8YqJJHO3BGq8GkNrfUvVjotCj6h5B8?=
 =?us-ascii?Q?xORz+wTb/feNySc/6HcCgHpghlDq6/xG9WhhhCI05sfb3Hmg2dIi7aEAdHj8?=
 =?us-ascii?Q?pEwsX45Qwi52L3ggDxp8aoNBDn+QZDyJqIuNAy8tJ7IGFOKP/pfHHu5wjR9I?=
 =?us-ascii?Q?tDJAMJqpC30ijWV6DJ5TC5upjvAWtSSHqDNucAFt1/+k5NgcykcbhwDjUz9H?=
 =?us-ascii?Q?F12JiuTuNz/0RdoNefMIMi8ZPNKBYAJvmRPaXkUkdUqxwcVRFPXojPwsFsNe?=
 =?us-ascii?Q?QQV4GBxzJGQ4ef2SMfVX5lRmDVfnFqhjVmkiYyhQYw2dZO8eBp1A86z4c8+h?=
 =?us-ascii?Q?rvImzcfrNYXv7aLEsWRPMKoqJbYAKKOoTk2HpsNfMub/AEnaTz6um84zmEVA?=
 =?us-ascii?Q?C5xGHUfM6jeTY84ulww+mLlhKD436bvPaKKehX4134ecz9SdbrX3l1ox8Z0M?=
 =?us-ascii?Q?pH4JFMAzcb2w4wsVn70v5yWc0re+eTK4U0hUUyyFJZCfchJmJdIijOKe9Zy+?=
 =?us-ascii?Q?IGZSYeI2n7Ige+rYU7C3fN6auCGqEolvitIIw+Ng/aif//6cWzDcQnYkWHD7?=
 =?us-ascii?Q?gcZt6mz+39Cj7bPuKh2vu1LMLp3LBgoco1m4+smEBVfoPKsMJLx+iNXxTmyR?=
 =?us-ascii?Q?11LIrYo1DmMSlI5utAKxbI4Ww+4IX9TearShdKlE/CFm0pWpNk9EKQmnLz15?=
 =?us-ascii?Q?Mwo6915A5tj7U5DfT9L71qOrKo22EqDWcS2K1K/CMa4w2iQNZjCMwqvLfX4N?=
 =?us-ascii?Q?XkO1XLEq9C55fK+wh6OpLG0PKiR3RrmBqcDCUGKAoynqu9ITXH4LbL+dNyot?=
 =?us-ascii?Q?7ndMBBGD/irOpYua7SbbH8Zbp3cBrVsIFPVjBlQoL83zFpogMMMjqen+13lX?=
 =?us-ascii?Q?8lubUaDTeQwtPY8EVf1bWy9RXbXfgQX5jOfUw5Mx3bHO1QTxJ6NSquFcbOIm?=
 =?us-ascii?Q?GvTtyj3idVGGj0uqZzwwWihyZ19C9I9MJIJs/4Iocotj5pZwOLPIsYdtBKPp?=
 =?us-ascii?Q?kfVSjzvFL3xMMmfo9s1WbMxJWszPPUpRhzGNksWtoEKfoWlXzvX1s6WpsTfE?=
 =?us-ascii?Q?VNpc0Li110ln5oBFTkipIqoGhgLMQW558iz3Jcuame1j3rrCUwnO8lexgIBJ?=
 =?us-ascii?Q?ezgcU8zJlC4swQLg0xZgnWW2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bd9ac66-3274-4c1d-22dd-08d993fb72e2
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 18:57:22.5353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jgg@nvidia.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5254
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 11:45:14AM -0600, Alex Williamson wrote:
> On Wed, 20 Oct 2021 13:46:29 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Wed, Oct 20, 2021 at 11:46:07AM +0300, Yishai Hadas wrote:
> > 
> > > What is the expectation for a reasonable delay ? we may expect this system
> > > WQ to run only short tasks and be very responsive.  
> > 
> > If the expectation is that qemu will see the error return and the turn
> > around and issue FLR followed by another state operation then it does
> > seem strange that there would be a delay.
> > 
> > On the other hand, this doesn't seem that useful. If qemu tries to
> > migrate and the device fails then the migration operation is toast and
> > possibly the device is wrecked. It can't really issue a FLR without
> > coordinating with the VM, and it cannot resume the VM as the device is
> > now irrecoverably messed up.
> > 
> > If we look at this from a RAS perspective would would be useful here
> > is a way for qemu to request a fail safe migration data. This must
> > always be available and cannot fail.
> > 
> > When the failsafe is loaded into the device it would trigger the
> > device's built-in RAS features to co-ordinate with the VM driver and
> > recover. Perhaps qemu would also have to inject an AER or something.
> > 
> > Basically instead of the device starting in an "empty ready to use
> > state" it would start in a "failure detected, needs recovery" state.
> 
> The "fail-safe recovery state" is essentially the reset state of the
> device.

This is only the case if qemu does work to isolate the recently FLR'd
device from the VM until the VM acknowledges that it understands it is
FLR'd.

At least it would have to remove it from CPU access and the IOMMU, as
though the memory enable bit was cleared.

Is it reasonable to do this using just qemu, AER and no device
support?

> If a device enters an error state during migration, I would
> think the ultimate recovery procedure would be to abort the migration,
> send an AER to the VM, whereby the guest would trigger a reset, and
> the RAS capabilities of the guest would handle failing over to a
> multipath device, ejecting the failing device, etc.

Yes, this is my thinking, except I would not abort the migration but
continue on to the new hypervisor and then do the RAS recovery with
the new device.

Jason
