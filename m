Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9FA4A5413
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 01:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbiBAAb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 19:31:27 -0500
Received: from mail-mw2nam08on2079.outbound.protection.outlook.com ([40.107.101.79]:14528
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230387AbiBAAb1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 19:31:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AWCuiWOe97Z4ICU6Tq/BpQdkeaMwtN6bMpUEYMry99BNHjBT7IZ65wgBDP5TzyAwo2orKfVHV11JFdNBwj+JBOFWJoPot7xC6KAMVo1Odr19h3QZB2gg0kQ21kuE9hdj0qkONfJ2qWLnfbu7C+GX8/7PjGoTPLNfKj8W7diTeflVOosaUURXaeriSMSlXzazmTcfyQFxKnPSWxFRU0nm/qT5gJH3NdfhCpK7869Q7Iz6USyEaS70cBxBUPQk/GklMeJzR7IKDERBRs96TahY7MLlyn/kBrXvTggmOIVQfOIJNHrAXYk7H6I2qRiL9arDnsMi630uDZchRqb3Wo3TAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k0eJTZ3t3hAPTS53jb+KPEN1Yc4sYER7V7yxXs3IDjg=;
 b=ogAg9cgLxGCjd423UfQOfT86GDgU4Mmz32SbNNTl4eS1ZyfpcZCTUXMKbK3AaRHN01nemXl9srVCY223Z+/xbWvj09NOdvguPVLevpG+nNtdS+6jzwKerV3teYHT2XhRH1mOnIzRe6vP8iXydyN2p9xWxOK2YUDoA9zZfgyx6z1Q9C+7gizXBGTuJMBzqp1vL/rup8Rct+T6iV/G0ihjoaz6UPR0qe0Qqi4VXG3roEqciB4GVDR+pLXFd0W1Ifk17G+J/ewI191YtWVcibMA+qozQv4clE58165GyFlU0E2czVKc/a6UNwjdLxOX7QA8Y6pJYvQtjrTIGeiCHrtFpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k0eJTZ3t3hAPTS53jb+KPEN1Yc4sYER7V7yxXs3IDjg=;
 b=oNT2MRJxru61Jm/D21xWlfKClhv5cqpGTxOBT3h+kVH1GOFj/2FS/LlrngR1VrhgMH4PRQpXe/J9/smxpvvziBYS5OIqROg4Jr247yIaS1vszqZpjI0f2IZfZLYmKkjp6Rp040gS/bCLgDito+zIYQd6uUSbjz7H6cUq2AeDtrKhHv8tYGTcbdrpyiAo4ZhNtdnN7D5YKptU7bLZd48J56s97iU2YU5D6767vdZLUFSwhuC5t2aToVXH4BVZQwcabYTOf7Ipop+UjRaK4NPts0mkQqu4UzdCLxg25sZHZWnv/2k3B2U0AAGbK+2INF7vpZ8jD1azTlNZ6IjqGy+d7Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MWHPR12MB1293.namprd12.prod.outlook.com (2603:10b6:300:9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Tue, 1 Feb
 2022 00:31:25 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4930.022; Tue, 1 Feb 2022
 00:31:25 +0000
Date:   Mon, 31 Jan 2022 20:31:24 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V6 mlx5-next 08/15] vfio: Define device migration
 protocol v2
Message-ID: <20220201003124.GZ1786498@nvidia.com>
References: <20220130160826.32449-1-yishaih@nvidia.com>
 <20220130160826.32449-9-yishaih@nvidia.com>
 <20220131164318.3da9eae5.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220131164318.3da9eae5.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR20CA0040.namprd20.prod.outlook.com
 (2603:10b6:208:235::9) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9828f2ce-a18b-4945-e200-08d9e51a2de6
X-MS-TrafficTypeDiagnostic: MWHPR12MB1293:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB12935F70F0D80603FDBCC592C2269@MWHPR12MB1293.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CiGucjNC4Irg6EtylzHjoWdpoBqYycp4JsWi0UTFypdqOsoyla7bV1ZbZiCHgNoH7vtsH5R+9Z8pmfrZbwkSQfHNdpwqP2Im28mh7oFeCcopgAO9xP88Vbb4yCeyzMaUQszDubJH/Wdv0aeBs2wXnnB5ktmmgsPPcT3zsYFOLPsxeJkt+bVmOIeY2s0dM0VmaVO/v30yZ0Olbg19mexnvRa4B4EQRf3IIruS+9nZSOVa3c/jzGd37/WPh9CqwANkCLd3/2yS6NolOnK57MyPKUNydzWLGOidZdwyH7esrrGo7XZZVeVzPIpVq7B2d3T/pksR0Y5ybemwlGbExYcaipFjAruGbVnE7/c7tVWakFySY9T5yn79S2PZWWaI36efR2TjWqqUgA1d8lUD+5gt4S52B9+d9F0Cdu6qAJ8qy9orG5hQYIhqc/OFC3mPbUUSgu6I2taft7Ic2VO5mh+6rDkAehsHwgd0hCg019VV5uA0IwDhhSOvDfp25bFOo9AXSU+vbO4V8Ctdw4TIcI1NxlF/Yt4A3aCDOT/CJDMCpD70Xd1a49CLgBaWv7jy3+Q9g+bfh/lJWoC3q95pOK3lqxhL+qfHAhA8kfTqHKYy5ub3daslCGktyLCjZGPSkeGUtTIdGvxBhhCd3Qs9w3MwCA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(6506007)(1076003)(26005)(83380400001)(33656002)(2906002)(107886003)(2616005)(5660300002)(6512007)(38100700002)(66946007)(508600001)(6486002)(86362001)(6916009)(4326008)(66476007)(8676002)(36756003)(8936002)(66556008)(316002)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jjr1N+echKIITnjQvJ3HaRBNI0I8R5FI1OmbY/DV/y5CZhN7YRkIecJ0rns0?=
 =?us-ascii?Q?RuI1+mWVwSuaqFB5Ypx/d2PEV+mvwMIjKCgejEMGYauh8j55pldiTFKW1bdJ?=
 =?us-ascii?Q?DRwzLcvymqp89bfZgVW3fZNg+k6D5i/0xZOjV+7LLkIe01VRu/7+JIKBfK5c?=
 =?us-ascii?Q?PffCK1ownExM5OpJzHUoVqOBLNILgtd8TKLw/SHSAy5JyQ9G0LwHNdC5lPsT?=
 =?us-ascii?Q?Gzq42srpteo823Ic9RPZge/JUn110mAyj2PAjOSIlqDxReMkXZPtRxOGkNL7?=
 =?us-ascii?Q?D/BHu41qvh3jdnR1Fc8FiAQ/VQFAuNL6UpmI3LJDSVIfOwVQI3Y4oN3tOf6M?=
 =?us-ascii?Q?NkZYAb65Z3aPfGdJR3aed/R7Om9itjnlNesRBnw8WE80u1wssidszzN32iey?=
 =?us-ascii?Q?AvemLcrBgXY75MqEVrVtPJSncfxDnL+SLYabup/dnnq5JcxFOha8G9xgvitH?=
 =?us-ascii?Q?+DhlGKcYzxalLQVD4q2cY2Qk+crKllD/uqicT0l50NzmgiinMNz8S/foIKaL?=
 =?us-ascii?Q?PPwSjZM7OigmbpE/tae3Au2UjQaO49lm3Vl/xlRpDsnnwdIc4i9lQVZRxtnM?=
 =?us-ascii?Q?bnBMzmxWrxLA87lfVOJHqamUHFdwn2jLr1SiNYsl3ons8H87Xjn8bMogmsgf?=
 =?us-ascii?Q?l6KDyo3u16gHE8IOyH1CcmDw2RYEYo3oEIk7SKkYTTGIl+fk75qIQzgZomno?=
 =?us-ascii?Q?OkfYshC2VfZyMwNeAICzyqJcfzJbLtCnlZctCDbs5GYZhsjisC2/kT1qoQgr?=
 =?us-ascii?Q?KH69fPqWngZK9a0Rctc0oO1lzRsf2hm9SB0bZ64sEeAwZrUuBxgUcgsSQgaC?=
 =?us-ascii?Q?AOwYVLg0ebK1VRQQAga+YPWPIjRH8lCA9kUtKpDlrX3TfUwycarAwwt7B1rE?=
 =?us-ascii?Q?1Bi1TbsvhoFbIgIFBd33vlviUHlczXnarFeL5vdefwMqBQejYdJU3bMRWGVQ?=
 =?us-ascii?Q?P8qZMNbZ/ZogrjXdEko3UgNUbLHxvLwttDPnrf98zmQ0nz4AusFY6rVUCD3V?=
 =?us-ascii?Q?5TsdCcajYHfMTVHyMBMbOMGumE5gb3zjiLoBKeJp19tFKx0Z74K0upf3cOd8?=
 =?us-ascii?Q?Y4UMMOG5SqQQCQ96GwJUEly1uQTYeM+9I5EofO0cUxZj+ocCK7V2eh9ZhIot?=
 =?us-ascii?Q?sfxxdYn7eElASt9uQ1WPvUbqSewR2wcBNzL2v3eyCJ1LVq3uG8XsZfggxp6p?=
 =?us-ascii?Q?jF6/ZdRg0nZsjSNS9ctEvAaDwz5letT9Fz2DkNBpXpxYandYbSUAzUHereeq?=
 =?us-ascii?Q?cqFJRSs3STuhC4gmB0EBgUdjU5IvJpU/TJ3/8bUNY/ANmMla168P/rz2JGO6?=
 =?us-ascii?Q?O2PecWOodBSme8Fs9yjBz/Tz3SMbFb8TEEuBDDO+j1UNm7EQMobTfwj1GSYd?=
 =?us-ascii?Q?KcDQta7Ri1H9PMmU/4K3WwN8pev5IhcX4pYJCbKUe0g8yHSstDwrtwcMBQYs?=
 =?us-ascii?Q?4fm0JC63RGXTVJh5f2sBy7hHnjna6Rx7magbzMEH0Ai3wwSdNZOlPdn/ELCN?=
 =?us-ascii?Q?Ri0La5rEwEAqhrcHoJEl73tJTB1l3nHJejQmZa3Hq6lHHf5BfJn1rZklcLs+?=
 =?us-ascii?Q?YctCklF8rLSj22mDs0w=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9828f2ce-a18b-4945-e200-08d9e51a2de6
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2022 00:31:25.3058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5H8Kjs3s4WScRNMgx+gTZlXNMy3f1zTqQRWlCSAQy0LWfBlOx8aM0vVWSwhc5t30
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1293
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 04:43:18PM -0700, Alex Williamson wrote:
> On Sun, 30 Jan 2022 18:08:19 +0200
> Yishai Hadas <yishaih@nvidia.com> wrote:
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index ef33ea002b0b..d9162702973a 100644
> > +++ b/include/uapi/linux/vfio.h
> > @@ -605,10 +605,10 @@ struct vfio_region_gfx_edid {
> >  
> >  struct vfio_device_migration_info {
> >  	__u32 device_state;         /* VFIO device state */
> > -#define VFIO_DEVICE_STATE_STOP      (0)
> > -#define VFIO_DEVICE_STATE_RUNNING   (1 << 0)
> > -#define VFIO_DEVICE_STATE_SAVING    (1 << 1)
> > -#define VFIO_DEVICE_STATE_RESUMING  (1 << 2)
> > +#define VFIO_DEVICE_STATE_V1_STOP      (0)
> > +#define VFIO_DEVICE_STATE_V1_RUNNING   (1 << 0)
> > +#define VFIO_DEVICE_STATE_V1_SAVING    (1 << 1)
> > +#define VFIO_DEVICE_STATE_V1_RESUMING  (1 << 2)
> 
> I assume the below is kept until we rip out all the references, but I'm
> not sure why we're bothering to define V1 that's not used anywhere
> versus just deleting the above to avoid collision with the new enum.

I felt adding the deletion made this patch too big so I shoved it into
its own patch after the v2 stuff is described. The rename here is only
because we end up with a naming conflict with the enum below.

> > + * If this function fails and returns -1 then the device_state is updated with
> > + * the current state the device is in. This may be the original operating state
> > + * or some other state along the combination transition path. The user can then
> > + * decide if it should execute a VFIO_DEVICE_RESET, attempt to return to the
> > + * original state, or attempt to return to some other state such as RUNNING or
> > + * STOP. If errno is set to EOPNOTSUPP, EFAULT or ENOTTY then the device_state
> > + * output is not reliable.
> 
> I haven't made it through the full series yet, but it's not clear to me
> why these specific errnos are being masked above.

Basically, we can't return the device_state unless we properly process
the ioctl. Eg old kernels that do not support this will return ENOTTY
and will not update it. If userspace messed up the pointer EFAULT will
be return and it will not be updated, finally EOPNOTSUPP is a generic
escape for any future reason the kernel might not want to update it.

In practice, I found no use for using the device_state in the error
path in qemu, but it seemed useful for debugging.

> > + * If the new_state starts a new data transfer session then the FD associated
> > + * with that session is returned in data_fd. The user is responsible to close
> > + * this FD when it is finished. The user must consider the migration data
> > + * segments carried over the FD to be opaque and non-fungible. During RESUMING,
> > + * the data segments must be written in the same order they came out of the
> > + * saving side FD.
> 
> The lifecycle of this FD is a little sketchy.  The user is responsible
> to close the FD, are they required to?

No. Detecting this in the kernel would be notable added complexity to
the drivers.

Let's clarify it:

 "close this FD when it no longer has data to
 read/write. data_fds are not re-used, every data transfer session gets
 a new FD."

?

> ie. should the migration driver fail transitions if there's an
> outstanding FD?

No, the driver should orphan that FD and use a fresh new one the next
cycle. mlx5 will sanitize the FD, free all the memory, and render it
inoperable which I'd view as best practice.

> Should the core code mangle the f_ops or force and EOF or in some
> other way disconnect the FD to avoid driver bugs/exploits with users
> poking stale FDs?  

We looked at swapping f_ops of a running fd for the iommufd project
and decided it was not allowed/desired. It needs locking.

Here the driver should piggy back the force EOF using its own existing
locking protecting concurrent read/write, like mlx5 did. It is
straightforward.

> Should we be bumping a reference on the device FD such that we can't
> have outstanding migration FDs with the device closed (and
> re-assigned to a new user)?

The driver must ensure any activity triggered by the migration FD
against the vfio_device is halted before close_device() returns, just
like basically everything else connected to open/close_device(). mlx5
does this by using the same EOF sanitizing the FSM logic uses.

Once sanitized the f_ops should not be touching the vfio_device, or
even have a pointer to it, so there is no reason to connect the two
FDs together. I'd say it is a red flag if a driver proposes to do
this, likely it means it has a problem with the open/close_device()
lifetime model.

> > + * Setting device_state to VFIO_DEVICE_STATE_ERROR will always fail with EINVAL,
> > + * and take no action. However the device_state will be updated with the current
> > + * value.
> > + *
> > + * Return: 0 on success, -1 and errno set on failure.
> > + */
> > +struct vfio_device_mig_set_state {
> > +	__u32 argsz;
> > +	__u32 device_state;
> > +	__s32 data_fd;
> > +	__u32 flags;
> > +};
> 
> argsz and flags layout is inconsistent with all other vfio ioctls.

OK

> 
> > +
> > +#define VFIO_DEVICE_MIG_SET_STATE _IO(VFIO_TYPE, VFIO_BASE + 21)
> 
> Did you consider whether this could also be implemented as a
> VFIO_DEVICE_FEATURE?  Seems the feature struct would just be
> device_state and data_fd.  Perhaps there's a use case for GET as well.
> Thanks,

Only briefly..

I'm not sure what the overall VFIO vision is here.. Are we abandoning
traditional ioctls in favour of a multiplexer? Calling the multiplexer
ioctl "feature" is a bit odd..

It complicates the user code a bit, it is more complicated to invoke the
VFIO_DEVICE_FEATURE (check the qemu patch to see the difference).

Either way I don't have a strong opinion, please have a think and let
us know which you'd like to follow.

Thanks,
Jason
