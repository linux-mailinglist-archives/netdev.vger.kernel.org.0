Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B54A74AE77B
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 04:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241371AbiBIDD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 22:03:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350279AbiBICtf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 21:49:35 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2055.outbound.protection.outlook.com [40.107.95.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7689C061353;
        Tue,  8 Feb 2022 18:36:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CbeMbghHtB2+IZUlJ+GNEBF8+z8kaSHxaUUHLErawW6beUcYJVhA3pPtc0n3xcsp9MOqhm6xdvbUGwO7WDrnwZYpdBevez7xhAFN3CsjgZA7i2ZhSn+ewrjJWsVAioYSGORYPl9XA5b1UZqk7FY/TcmTyslQx6bV9nmDs0C9c4KlrMPy4nwfqQ+bVQFSN23lft7q2vdmhzHLBDHJAGTvCk4t6gT8oNpnjgPVFDrZQUwb9DmuR8RMk0iTrsyqUohUjyTZU3K2ROlsSYXf/A63WaEXtZ8Dx3DJo3i03p9+X6M/m4UkrT4QrLFR10xA2mszSP+5BnpiTLhQ8X+P0v2Jvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xY6hqX5flxgjhu/Lkcq/BtvGdZ5Ac8TVhRHYMG8lhvk=;
 b=JlpdWGPZR6ECuH5UoNGoXGGXXvo8/m8fM8/5kYDYjPpq7evdCEt+8nonG61ak834dFdZuUVeahpBFu6f+ju7MO24Z/WqR6wCEJ0uieM4RNl9azeMPXU0n97f6UVgMXSt0DHqHCSUz/DAy8v39LlgEn+TKUQ9r+htmCU5NzfwZ9SGUBDgZowk112lPybFyfP6gFW+PF4/IcrX8gMvescnzTyOFaxYcsx7o2HNgEXOf8Uk7vW/q+ViwAM9JX6ISui8ZU7oHF8GMyvNEyT8jXUEkljPyfxqrwQrkH2K6K9VFgVoiXwgbjhsJ1E4Ke4GHviDQODC77IhcEjD8VcNwUazBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xY6hqX5flxgjhu/Lkcq/BtvGdZ5Ac8TVhRHYMG8lhvk=;
 b=AG/daQyZrMvWLQkd3bU1FQlMEPRMv77zIsq8xc+ygBnCjbDv8ns+dV9H7JTeXfoy0NWLludSXF5rn6og0iyuV6P9goRGaDcfe+RZ6BbtqgqETm8BtQ2E9uOOiE4iCNejG3tt547L8QYZRoOIyhQCcmiy2+uXjUewXRxjuclR79jx2QQfXNj/6VyoIuTnu9K7CuXqNKEvRjELdIIWsVjJ2+DNgbwegooNwuIA34jEEH8pmlf5cbS9iurfOimBPypSs4hk+kv11TBl6wfyRzTOxv97OxHmZsyNktK6UDNcQJ2a5SYsXiSKFN3VbJjdkHDzg4UQP9tQgbDV48L6XR0wwQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CY4PR12MB1704.namprd12.prod.outlook.com (2603:10b6:903:11d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Wed, 9 Feb
 2022 02:36:47 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4975.011; Wed, 9 Feb 2022
 02:36:46 +0000
Date:   Tue, 8 Feb 2022 22:36:45 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        ashok.raj@intel.com, kevin.tian@intel.com,
        shameerali.kolothum.thodi@huawei.com
Subject: Re: [PATCH V7 mlx5-next 08/15] vfio: Define device migration
 protocol v2
Message-ID: <20220209023645.GN4160@nvidia.com>
References: <20220207172216.206415-1-yishaih@nvidia.com>
 <20220207172216.206415-9-yishaih@nvidia.com>
 <20220208170754.01d05a1d.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220208170754.01d05a1d.alex.williamson@redhat.com>
X-ClientProxiedBy: BLAP220CA0016.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::21) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f309ec1a-9f7c-4780-0b96-08d9eb75040c
X-MS-TrafficTypeDiagnostic: CY4PR12MB1704:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB170482E5B25CE28421CBD87FC22E9@CY4PR12MB1704.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ylpdkru7KZXYJpB2wBzyJh1yDYkbEx09RHcFxoeVcglO5XBfHgIEGAPhIMG2u3ZZ3sC6o2ZixTq9R0ZF0CcYHv8qxn0g01IN8YHJb1Cjhu7LLeAovzcK0pXT9Iaavws4MYtfiIXu09Ijr9DyPZgOsHCgyF8Fz8PfnafAjB9lknb1eZq0joD5ig07a+ECzKbL+uZBzml/5vsNQO0CVmFcO82k7UdZ2Cg6DJTUa5ixufJ1Uj1qNsixtRzdhgTqkdiWdb5J81jEVZ7ndIa97/uNiGpR9zl7GT1/oFfIEy7/3TWkWvGPZyUXmqn1aYYkrBT3awo/bQsuthqDIGIDbXK6HX6L2z+jx5LFlaXoRKriroF0kswKiXa+xKpYg3jAyKJXtvOTtz90JEJp3+KaQ1TzvFtwF6C4tslQHQExv5HBvh7hel16WSdfWdeX/96d63C99Wym7Q1cgV/GlrCt9+GYBrAlP2qSr2AD2nT6dv9aCZrWQrUp2HaJIZMATPNxyGL+xtETh4j9O853Q3K+R17AbZXLPwtLWHsDBZHnIChKNuM5PtXg/NbDVWkQBOjAhUqyjMxiBN2NGMvNkc4q+K0bDDLw1YKzIyA/XOtrwPGfauz4lLAkuHPp/s5dv7rQU1GOwpb7BNC8ndudrR/Xkswpow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(4326008)(66476007)(2906002)(36756003)(66556008)(83380400001)(38100700002)(5660300002)(6506007)(6916009)(33656002)(8936002)(8676002)(316002)(6512007)(2616005)(1076003)(6486002)(508600001)(26005)(66946007)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Vc8FhelVfu+jjxfK78gI8b5/9NTVem+Tk8E5LsgI72/cAZd+wzCwQWqkuCKe?=
 =?us-ascii?Q?HqK7UzYbOukGz3hz055sBeub/2cRHxeezGsVWg6bUOpkVvYjTdAx5N2bHxrN?=
 =?us-ascii?Q?sD4ubBT0EGkpl1r/NjzK/fyanDeTs1oPIoldSiZwvQC3krTNsPkDLNTRbpdg?=
 =?us-ascii?Q?z6ZwUZwAnMNnr+V/UO4XfBoS5/Svr+pTEIUhirIXqac73BJwkKHMOcXB6jHU?=
 =?us-ascii?Q?+Pr9Rrx3WEnlk/IKjS0HJ/QEjGAEcDdIA/4BJS1uauHcX5PYrJS1W0oYpsj6?=
 =?us-ascii?Q?MmZMSfWGlqQI6xDf3wEKEKbxHLP3JZHw5L3g43QEVXpID7zGCjx8cLk+qDL7?=
 =?us-ascii?Q?yRwzznDE4GRxS0ufAnUzJ6YK1xkIIfB3UcVN57QzRufcBJIrtlTAtXEa7GE3?=
 =?us-ascii?Q?WbEt17jCUA9al0UIhvYm3WuVNJAt3+bn+CZWN74i/K5UlOq9qz/z8RyoenIv?=
 =?us-ascii?Q?9SskkaQ6RwnPxTMX4SbrdamqP9q8RtHP/NbP9O/d2JWHLdPLF+O7V4R7Tn3g?=
 =?us-ascii?Q?Sb+Q7qYA+XQbz0/HHqHbXpvIVWQGLXnfAjqFw0py1aUzbqThQW5vf2kIlRLC?=
 =?us-ascii?Q?Igg8JB0UovbxpYcFSA93hoiXYj5TiDNhDRnP3rJX6ikhVj0XRZslxU3cUOXb?=
 =?us-ascii?Q?WfVlIfjc/rXP7zUG7eWQapkdvNiqeqCFXA3qkDvVxf4/NVJw+gqYBnAheq/Q?=
 =?us-ascii?Q?xM7LrpVRqRTjABULHD0KcwJ4vPeySmwGs9UP/FPHqrpiOxtgPCgsOYsvrvzZ?=
 =?us-ascii?Q?7HDUwWykvhvT42ADBCVRCzztlWt8CzbaAMtNqVaC4KFG9qhm8wPuvwHsceH9?=
 =?us-ascii?Q?OEz76ixiDFP5k6VNvWUsBufvxrGvt8izqUC5ejKBcxaf3xdbk/MDruiG+Pq4?=
 =?us-ascii?Q?OcojhELTP3H2woLEM3F/J+oDxitPQXWPD+na6aLF/tNi2pcvdV8qeyW8chJb?=
 =?us-ascii?Q?SISZtt7ommZOo9lbs8A/YASt7JDSJGqBVnrDZq9koszKnCnP1I04X/iR6Ksx?=
 =?us-ascii?Q?jFpZtHhrbSLT8z4XhF5YIx5jMnxxzITvUyBUjuDgwkXuI4rOQmW+31U9n/p/?=
 =?us-ascii?Q?W91dm0rjUFnRBSyKB6BY4UjBgyCCXrIsgQzpJ1Gp+IvJh//l9FnmNyZCNenI?=
 =?us-ascii?Q?KW8CKN9x5RStkykgsrIveQs1kV0J54tabW4BiJmINDCuk24LG3mA92MCB7iS?=
 =?us-ascii?Q?p7nYoThB5f7/dEMwl7AbmGH1RjvxuZMZYC+fvkr4nHS6xGw/PRu9FiS31/Vq?=
 =?us-ascii?Q?a/EEFezawlfPFrNWjV57i/owzoYcMRg7CMkcTbmpwxwF5oHg9eG8Tv5dVOfV?=
 =?us-ascii?Q?T+Z3yfjywXyKg2/yO16coT3J6jU+Fl6GfTX1R81AHYFVUa62vrgJH0zYvqBg?=
 =?us-ascii?Q?5D5FehtFzVCmeCDkCRHFvykzdZgNtUAt4Na1UIrjBNdGn5VLBMGcJmvzecLG?=
 =?us-ascii?Q?ozHDMgI4kCskp9vQFcJ4X4qq/a8y+Q4A1PT/nUmuQDamPSLMDrC20JnWTZHm?=
 =?us-ascii?Q?KASWDDseodTuBCOsy5z3Ipr7ybmRERDnLHhrolmCRAwms5rX+Fz+G2CQbnDt?=
 =?us-ascii?Q?v8jemq55i0JJmZRoVKE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f309ec1a-9f7c-4780-0b96-08d9eb75040c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 02:36:46.4215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HIDOmW2TcVH0T/UAO3gfj71dKpl1mNjJ+ZrSBh4A+QzT4OYXk3ieOMWtx2XPcs+8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1704
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 08, 2022 at 05:07:54PM -0700, Alex Williamson wrote:
> On Mon, 7 Feb 2022 19:22:09 +0200
> Yishai Hadas <yishaih@nvidia.com> wrote:
> > +static int
> > +vfio_ioctl_device_feature_mig_device_state(struct vfio_device *device,
> > +					   u32 flags, void __user *arg,
> > +					   size_t argsz)
> > +{
> > +	size_t minsz =
> > +		offsetofend(struct vfio_device_feature_mig_state, data_fd);
> > +	struct vfio_device_feature_mig_state mig;
> 
> Perhaps set default data_fd here?  ie.
> 
>   struct vfio_device_feature_mig_state mig = { .data_fd = -1 };

Why? there is no path where this variable is read before set.

> > +	struct file *filp = NULL;
> > +	int ret;
> > +
> > +	if (!device->ops->migration_set_state ||
> > +	    !device->ops->migration_get_state)
> > +		return -ENOTTY;
> > +
> > +	ret = vfio_check_feature(flags, argsz,
> > +				 VFIO_DEVICE_FEATURE_SET |
> > +				 VFIO_DEVICE_FEATURE_GET,
> > +				 sizeof(mig));
> > +	if (ret != 1)
> > +		return ret;
> > +
> > +	if (copy_from_user(&mig, arg, minsz))
> > +		return -EFAULT;

                   ^^^^^^^^^^^^^^

Is before all gotos.

> > +enum vfio_device_mig_state {
> > +	VFIO_DEVICE_STATE_ERROR = 0,
> > +	VFIO_DEVICE_STATE_STOP = 1,
> > +	VFIO_DEVICE_STATE_RUNNING = 2,
> 
> I'm a little surprised we're not using RUNNING = 0 given all the
> objection in the v1 protocol that the default state was non-zero.

Making ERROR 0 ensures that errors, eg in the FSM table due to a
backport or something still work properly.

I think we corrected that confusion by explicitly calling out RUNNING
as the default and removing the register-like region API.

> >  /* -------- API for Type1 VFIO IOMMU -------- */
> >  
> >  /**
> 
> Otherwise, I'm still not sure how userspace handles the fact that it
> can't know how much data will be read from the device and how important
> that is.  There's no replacement of that feature from the v1 protocol
> here.

I'm not sure this was part of the v1 protocol either. Yes it had a
pending_bytes, but I don't think it was actually expected to be 100%
accurate. Computing this value accurately is potentially quite
expensive, I would prefer we not enforce this on an implementation
without a reason, and qemu currently doesn't make use of it.

The ioctl from the precopy patch is probably the best approach, I
think it would be fine to allow that for stop copy as well, but also
don't see a usage right now.

It is not something that needs decision now, it is very easy to detect
if an ioctl is supported on the data_fd at runtime to add new things
here when needed.

> I also think we're still waiting for confirmation from owners of
> devices with extremely large device states (vGPUs) whether they consider
> the stream FD sufficient versus their ability to directly mmap regions
> of the device in the previous protocol.  Thanks,

As is this.

I think the mlx5 and huwaei patches show that without a doubt the
stream fd is the correct choice for these drivers.

Jason
