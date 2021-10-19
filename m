Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0182E433F05
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 21:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234961AbhJSTMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 15:12:45 -0400
Received: from mail-bn8nam08on2089.outbound.protection.outlook.com ([40.107.100.89]:29601
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231355AbhJSTMn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 15:12:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MrKZLizP4XmOUeYq5wxX8pK4FluG12YQSTKzImjwNXwjz2EE/7FkQo6r9Wb1J5uu0VoiMxX5OjC+kVFdGaTe1E522rDQMMZS0GzkRsM2ZdrbMusKX+YlfQ0dx+c4ZnrPi4+3V5A6JX+8p1n91NHmiaQDZoWtSyurbRbYdqEz1JfZQRv32bN9oqdK4ZYr86cRhyyTwE5c0J2uAieA6xBa6Cf9r7HOfsJVJNS1r8g9eKb9CkjPoTsJZETxIf8hM/uzY1blP9QV4NJ7ZwEgaf2fkvH2MnxpfPDOX3N/D5GHnCWxbtpXTJ8+gF9nnfQLazbf2aVwAKnIy3KWt91TNmHZXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7O1SoEFkc5POLnEBj1YuoSuIBrZfzeyVzl2p3gPrJXM=;
 b=YBahoqSLecFze4l1myjxfVb6+ncs6TQRazfVUKSEfJdkGZ5yrhGM7sr8crf9lRvPN53ZEFEfm8pZngVZRJqbfA59Pz9DTT3uxk0vtM2/FAF68bkqk1jgLDDo4LqmVMv0Z04Z+PPOIyt3YEe9iX6RmyiznRyBmS7AbR39qk5VliVDOG41dxi+FnX9EGkVQkFT1N1sQfTNRERGlSmEZsUI6EraR1uF8ru4tS0OKDfbvsjVhGsV1+Pkl2+9NzjeG44IXcOHOCOxIdpX59mWGXG8Zo9X0jLo9xvkgaBxyYvxZl5bVWmWqHID0+RhEDDk8gQkQydThibvCsnD7EN09pX4Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7O1SoEFkc5POLnEBj1YuoSuIBrZfzeyVzl2p3gPrJXM=;
 b=cxQIIFa0Ubv0Xdw0rnfvvFO3sZJsGC5Smg3g20xr1a2bVkLNX38bRZChLef6OYyzpp8AfHqsxX1rbGGoKi8Ben776fX4idijZrQqolpahwJFkeNtwQd75edEWEc5WArH2tWuFI/C8ULRDMi2yz9YdfvqIk+XizhPOwHBUooBZiAStRuT0YwhWV3sy2glK+F/n6CVWUeLiRjdDpHcWT7NSgOnT1cXzc7n56P5pj05lblJC6Ymw5QkDcqnJds/zpdqPBBRdM+e+yU5D5KXteMY/jCK4PxnNlid55GN5LrZE3C+X9/g7xfDblriKD/AHaxQLn0TxUgOeYgaTe/7IGvJeA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5031.namprd12.prod.outlook.com (2603:10b6:208:31a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15; Tue, 19 Oct
 2021 19:10:27 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4628.015; Tue, 19 Oct 2021
 19:10:27 +0000
Date:   Tue, 19 Oct 2021 16:10:25 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V2 mlx5-next 14/14] vfio/mlx5: Use its own PCI reset_done
 error handler
Message-ID: <20211019191025.GA4072278@nvidia.com>
References: <20211019105838.227569-1-yishaih@nvidia.com>
 <20211019105838.227569-15-yishaih@nvidia.com>
 <20211019125513.4e522af9.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211019125513.4e522af9.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR05CA0024.namprd05.prod.outlook.com
 (2603:10b6:208:c0::37) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR05CA0024.namprd05.prod.outlook.com (2603:10b6:208:c0::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.13 via Frontend Transport; Tue, 19 Oct 2021 19:10:26 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mcuVF-00H5Wq-V0; Tue, 19 Oct 2021 16:10:25 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e62c2b9c-e1b7-4144-4927-08d993341c1d
X-MS-TrafficTypeDiagnostic: BL1PR12MB5031:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5031F8E6C53950A3971A6EC4C2BD9@BL1PR12MB5031.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rtbz98AJmR/W5A+FYGxV72FQu8FbU3xVEhEjnvbHq94NBv1ODpdVZUYuGL4XB/h5zAK2VMCDy+nhctK22mGZkE1lx6A9gJbeFatfbv/ezAr4Z3z1/XTGvReFf6yBqyTMlBEs2a+1EQ9uO8sMssWzS+LQONeAjbVDE5emI6nT4t/0TBNTzFd74Qkpx6f/ZZLELGtRnpX6C7M3Du4UeTkrQbntOg5heleNbQRwW2faipzndcB+t59UYXYHClmk1nBUbpDng1FOpUoD9zAWP8/1jvacgzcPyiTxpJGtJ1PTJyeQ6RJmmaClzUQcqKZNbSprW1trSvvOHOFlm2cnMJvEoVn+/CJcr72sAXmnEgW1gyYGzDwmZQQAEdLSLy+6msBnLL5TiaTR1oBliyO+XoWn5yVp8lI84M12ePQV3aLSqql1nhPFE3429NXgnCL/TD93/osvNn6p/jond8SuTdDB48ruAsZ9nhtNwJ+wNn5zyhd4WdQ8HUavvxbkDSREVieu5LZdFmLqruZFoY3nYX1fmCBunshhj/w2NDR+C3mjVKUaJDPiftMRg0BAnK2s8ut32m1xPYM43yeG+ZZVDfZP+PKHgxh3yIUYpkk5DDzMI9EOFMcugNvOlcZQMX+LwvgDr63SjXkV+QaGJn//Wyx2Jw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(83380400001)(38100700002)(107886003)(33656002)(86362001)(1076003)(66946007)(2616005)(66556008)(426003)(66476007)(5660300002)(4326008)(186003)(8676002)(8936002)(26005)(9786002)(9746002)(6916009)(508600001)(316002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ClF0IKZKJ9jyPy0AN0FDtWcAG1jjugdg9rrSdIwhrWSvO2pffO1Eh8wKp7yu?=
 =?us-ascii?Q?iYEN3sf02FkEDKSda3UkDcMte+v6/FOKLc18TTngndXuxGo2jf1wz6Eyyd4a?=
 =?us-ascii?Q?9XcQpc5yP4fJ3ObiDCSrW8TC2Y+OpUkfpqcj2fNbus6PFPa66v5pvXNk6Lu5?=
 =?us-ascii?Q?HQPGq9H82nmEfqnFGwqDZsXDqs41lBDZvlppAuyn5tcKa+40w09FNSO2X0W7?=
 =?us-ascii?Q?PEMo5V0RKBH3C7B1fbL2ZwAVn9F1kP5zWdIxGnk5kNBNCCDe/0nuRDu7xNnx?=
 =?us-ascii?Q?GScYnFZvJ2BiWegijWfB4pWKlL0uRki0y16JaBml+8D2ndPh6QiKcwvGOSOF?=
 =?us-ascii?Q?NKCpPSoTdhzMyTAqsefy055Qu00oXDHkdxBjrPEshAc2ScKE4Z0nN89V76gP?=
 =?us-ascii?Q?yrdnmjTkVRkIWjtabm7ruGNfYkMbQvNhpNxEOpPO0CurBFuRmIYeyT1RVsLf?=
 =?us-ascii?Q?4y3vwmDVmto30mYQIKde9gWNdAtij/qZHi2l/6qY9/XcDQU2hIBnTltGVgyt?=
 =?us-ascii?Q?P/x+FnR36AiQUGfIGZ/GmJCo4mIwrhs0ZO/gWaT0vwp27LG395/phdoTb7j5?=
 =?us-ascii?Q?3SHYRneIMdYO6VEYeqhKA2rn6KZj6NOC64MMlY+gd5Mac/di5CxymQbpDIZ2?=
 =?us-ascii?Q?z+qRBN+q9QLWLixcN10R+cUxcsR5M0w8oBuyEclTojtPXkinqmSNSOF6C1Fj?=
 =?us-ascii?Q?CPOLaYWXr+o2VNYrzr1xeyzXZ5z1dQfXSUpUY+aFGb9Y0rwsBQY1E2MY1+Ku?=
 =?us-ascii?Q?K2oJszIvstlIdAAJ7Vw6G+X7lQGDv3w/oGHOV6uHAMGw+7A16Q3kV+T4Xmcb?=
 =?us-ascii?Q?T6gH0wNlpPqDmZfA/aBbjumjUO8r3NQbyDQXGMweYXxRycZx9ZNpP67h6V2p?=
 =?us-ascii?Q?XkKGaY2k1HpBbXIcZZPhb+E+KadotxliZL34ZASXcqSQ9aoiy5SqnrtS7t/w?=
 =?us-ascii?Q?GI0Kno8lM3fSaYzqUYadGOByzoL1i4Bp9ijqBolK36p5c+iB7iWlGEx1t3kf?=
 =?us-ascii?Q?L91z6DLBsdZa7dXNScFTcE4GuvavpDr3QabJBA8aBeTrDc6xD/uWCCruVIkA?=
 =?us-ascii?Q?h1Pvx5yTVPX5u+Uvbni9gCauX+ysbefE1TPgzAnj1d6dB6x0hyAbY84FyI3h?=
 =?us-ascii?Q?CzGVFDLVVJbzuzfGeGfDaRhrFtYEsCr/zlxlwkvYwaKezR6CfVAgb9fKhf5z?=
 =?us-ascii?Q?wkf8JvFxGgGhXBOiu9jCU9EvAT2hymamWCIZSASQGV3Ic+K64E8RIbsSpECu?=
 =?us-ascii?Q?nftk3gVZ0pGBi5CsQkMF8J7G7L+TZSrLHEZ5A9Tnsn2+M/Jjy/CgN3YpWCwE?=
 =?us-ascii?Q?8rBH68xQZtc0bwYfMrFAX7wSkwdvDNaw6UC+vcG1f7EXeEm04iE/bvNCt6O5?=
 =?us-ascii?Q?5elKy6ncMR6i+UJ/x+txkWOyj7kSfgzV82p3MiF/Tzfc46nLYYvgd4RtdEIb?=
 =?us-ascii?Q?xRXO/0w8smg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e62c2b9c-e1b7-4144-4927-08d993341c1d
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 19:10:26.9805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jgg@nvidia.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5031
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 19, 2021 at 12:55:13PM -0600, Alex Williamson wrote:

> > +static void mlx5vf_reset_work_handler(struct work_struct *work)
> > +{
> > +	struct mlx5vf_pci_core_device *mvdev =
> > +		container_of(work, struct mlx5vf_pci_core_device, work);
> > +
> > +	mutex_lock(&mvdev->state_mutex);
> > +	mlx5vf_reset_mig_state(mvdev);
> 
> I see this calls mlx5vf_reset_vhca_state() but how does that unfreeze
> and unquiesce the device as necessary to get back to _RUNNING?

FLR of the function does it.

Same flow as if userspace attaches the vfio migration, freezes the
device then closes the FD. The FLR puts everything in the device right
and the next open will see a functional, unfrozen, blank device.

> > +	mvdev->vmig.vfio_dev_state = VFIO_DEVICE_STATE_RUNNING;
> > +	mutex_unlock(&mvdev->state_mutex);
> > +}
> > +
> > +static void mlx5vf_pci_aer_reset_done(struct pci_dev *pdev)
> > +{
> > +	struct mlx5vf_pci_core_device *mvdev = dev_get_drvdata(&pdev->dev);
> > +
> > +	if (!mvdev->migrate_cap)
> > +		return;
> > +
> > +	schedule_work(&mvdev->work);
> 
> This seems troublesome, how long does userspace poll the device state
> after reset to get back to _RUNNING?  Seems we at least need a
> flush_work() call when userspace reads the device state.  Thanks,

The locking is very troubled here because the higher VFIO layers are
holding locks across reset and using those same locks with the mm_lock

The delay is a good point :(

The other algorithm that can rescue this is to defer the cleanup work
to the mutex unlock, which ever context happens to get to it:

reset_done:
   spin_lock(spin)
   defered_reset = true;
   if (!mutex_trylock(&state_mutex)) 
      spin_unlock(spin)
      return
   spin_unlock(spin)

   state_mutex_unlock()

state_mutex_unlock:
 again:
   spin_lock(spin)
   if (defered_reset)
      spin_unlock()
      do_post_reset;
      goto again;
   mutex_unlock(state_mutex);
   spin_unlock()

and call state_mutex_unlock() in all unlock cases.

It is a much more complicated algorithm than the work.

Yishai this should also have had a comment explaining why this is
needed as nobody is going to guess a ABBA deadlock on mm_lock is the
reason.

Jason
