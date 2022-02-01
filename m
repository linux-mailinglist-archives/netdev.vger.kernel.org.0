Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D53224A640A
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 19:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241954AbiBASgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 13:36:25 -0500
Received: from mail-co1nam11on2055.outbound.protection.outlook.com ([40.107.220.55]:13040
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241935AbiBASgZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Feb 2022 13:36:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YMa1Sidyym5E866DO4C4ai/eR7rr6j026M6gpzhv9VmkLqoBO+oEmudph37TzCN27ac43X+H6vS+lBESliri3XLLB+WFjTQsWdzHHU09839GM8ZBaMIYEFZO3h6MSBHQ6J7CSd/FQCp+BsJOGdUWH/TQT3IoNTP7cdD5wTp3XrNzSbY4KaIl/WQc9IC9dsUkzx0ilkymVAz/kGaXWZ8xq9PG+ROHr65LtVV8mapN7PGjJPWcxyeJE+OVTrN4FQT2RrVycU/Ic72eFQTMCOwQxZvzJwd/7CncO5NuPqP8wY5fcWmNfy4t8yfRk52D9YfzgCvken7GPg+OAjReMKN1/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a9Es9WE6VFu481BbUccO5mkkqJouxZowOQnCJQ/cU/w=;
 b=cCbwzeK531yYVEpgNzXjGTCw4mwTxBlyF2xo4znjsPUOUjaW1I1fYodROvEAh5JOJyhb84lGMYmZzThQovAIxwey3cn4iRKEAK9RaVxzxkZG2ksOhNVoPkkMr0bZicq2yU82Az/CfCrZh59UBIPQXTVhQOQSazpobPKEXXBfjzyBegotJ6NQK6E30cP3vHYCp6Ihfs4tzfWrkgNn0NbuXqpElnJlgSaRgnRufeUypCTysMMiaT9TFJ4zbCLncVeBlZotC6PEbIFG6WyopP9NwAcuE9JbXLqkzvUbwiO25coUI4llJUTgIdfzsV8ccojMC5dX0J7bry5Hm8uiS1QAzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a9Es9WE6VFu481BbUccO5mkkqJouxZowOQnCJQ/cU/w=;
 b=gECTaT7zjn+kh1/tu+WNXbo2fmCIu4d/TQ/toOFkmmuruFMIFWnvNeqtaeBKTUikJT4Bhr6Hx7RTZxkog5AgST5GezPq1Qk7WDuheRvFtTe4mhOuJb5TM6TMuv0o5n6+EUR97aRsTC2gJxHMBmOiMgYC5dTDXcfdRA1id2EHf/JMxm+iQj/8yubt83wn6StvBvKbjGWtjfYyY7Gd+SdxF1bNfJY5bEP1xVUatd5AbRKhr1gvcFeijDLr65DxLjvf1ishVKeTntl+HkZH4QVrhLAlHoom6ZNS4Dq6sZ/FEzORuTj7sUE1x4O118OqwZX653V+M3sM/g+BPYBG1ONjJg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN6PR12MB1297.namprd12.prod.outlook.com (2603:10b6:404:14::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.18; Tue, 1 Feb
 2022 18:36:22 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4930.022; Tue, 1 Feb 2022
 18:36:21 +0000
Date:   Tue, 1 Feb 2022 14:36:20 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V6 mlx5-next 08/15] vfio: Define device migration
 protocol v2
Message-ID: <20220201183620.GL1786498@nvidia.com>
References: <20220130160826.32449-1-yishaih@nvidia.com>
 <20220130160826.32449-9-yishaih@nvidia.com>
 <20220131164318.3da9eae5.alex.williamson@redhat.com>
 <20220201003124.GZ1786498@nvidia.com>
 <20220201100408.4a68df09.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220201100408.4a68df09.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1P222CA0018.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::23) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d5452b68-ee5e-4f0d-bbfc-08d9e5b1be51
X-MS-TrafficTypeDiagnostic: BN6PR12MB1297:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB129712B21E1D45F398E0A660C2269@BN6PR12MB1297.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lyv5HlMMnR5Fuu5cf3F+Xpqma35qcNgXkfmnLBj0eUEyPJ2pO4abs14libTo1vP955h6PHG74K1+tq2rl1rARGePnhlR35TKxs5En2e3hVZZqB5H7kohLL1BApOx8Z6ldCRfwFlkXtley44tKRkd5PLw4r7LwL6fB1Mvzw/reUm1moBnCtWgVTu2a3CaryXKGZNnvwb/K3fG7hj/+no7kOBkPee+pPCZYToIRS8SUay7NVZ8auEnQ9i8a9hBpQZTnaNVOjtUDpvUnkM1CGjwhaXQS86yeKXinka+yrJ05U1R1ZHKFleg71inkJnRLbcjX6BkehecgqIB4Cu0Q4aYE7loqtsewmc6y5dpvJ1+Gsb6Ft0Gko8MAPovon9IrvJk8SHLhOZgIfUUdKjQze2cmNetknWl3NMC2ad/wwxDYQ8R9x+Vf3x4JKwRPuHV39Xiq+nb+I0GlaE+vXd/rcEFYxB7s7tU8MhOby6nyVIlJd8OzOTHeuGM+2v30JE/hmVAlmKwcifQstOdzpbLLlaE9CsUQBw1XsRGwo76iQoO+vraSLL+n/EWK0xeN+fLzNeJPQmcWaku9rTjmgV2MFx7RJkczFyewoBaZ8hM7O4TO+4ZNbihgcKvK4uIoHxGIE1IvtTBf6DcbiV0O85Y2izlxw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(33656002)(316002)(107886003)(2906002)(83380400001)(38100700002)(5660300002)(1076003)(186003)(26005)(2616005)(6916009)(66476007)(4326008)(6506007)(8676002)(66946007)(66556008)(508600001)(6486002)(8936002)(86362001)(36756003)(6512007)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z+UrjRoWOsDTCUUgOljUwraKMVK0mu5z6rGJ7P3c3kJTlJiJHlqvRr6h+wjp?=
 =?us-ascii?Q?I+x2tjgtS5eA0G15NS+pSh4itzg4uZ5GcL3f/tM2UfuEnxQzunqh4dxUXoZN?=
 =?us-ascii?Q?pYShMaRTvbUVWF1J51FIvuCTu51Tl+GoE/t+xkj2iRmQVgVH7+kbzm1PCVU4?=
 =?us-ascii?Q?1nD1edxbl0256sS7HjzGnPhSUMJrBSdCWb6yIfV9olAFJw9pjK7EITQpkPLR?=
 =?us-ascii?Q?RggBWxN8TSIhIfJ/zMLsOtUvbmFs+mXqCYggbv76C/LgR43EOzJLzYTeXBRO?=
 =?us-ascii?Q?6uR1LiutniEU1J1bu2C66cveP6IQY+/A/gMGVxfX/2gFz1SMSK0KwVdLRgnV?=
 =?us-ascii?Q?vrjY1OH6S1B3yT2Bhx6ed3wyJw0N8unvhaO0ANsyfTrx6+jP3cOqpJT316WH?=
 =?us-ascii?Q?jrzgNIqS3JCGRnRbjsj6loh/DZp85Z5+f14mHHIfWGPDqX6i/sv+Td9BW5+M?=
 =?us-ascii?Q?LgJ49gJZnP3/EOGJCJlz2yS7PNFN3KOQ7K4wsKmCGaMVBKsuksDcR2WboZ4P?=
 =?us-ascii?Q?S3Jp6G0waSkPVjnkpVsLwV4vxKghwd1bDmDXaoLZ3SsYqhkb1ToGk0P5Ape9?=
 =?us-ascii?Q?amFKqNHWeAzLvkKLpm2W3L6x7oAuHzVXHc8PVwHQ9WUYgpVr8/1lGzFcu3eg?=
 =?us-ascii?Q?GHmNveUJy6QN+VbJXvmfq9kFK5TPDhOyPUYMxAZ+Z8VWq666dfwLqKcXUdzY?=
 =?us-ascii?Q?ER2N7t5GoAaIMQQ44M4hnm9XvS+CoKRCfIfIUd0x8LcSyhjtVS4TuRUfXmLT?=
 =?us-ascii?Q?rEm10QRgALKxCzEoCkU8EFIlp8Olt62wztuOhbtEZBvaxArRMWV/GWGc7OG9?=
 =?us-ascii?Q?bb7PGf9djsL8Ut+2hwOY7G3Am09xFyM8SKgKA1ET+0Jm8t5vikxVUx/7cryC?=
 =?us-ascii?Q?jslZg7god0S1hi4oluf1k+U2mRMtJdPqCkENK9dyfQpjGxMgsa0mszu+FpiB?=
 =?us-ascii?Q?GTjOay/Cyyw1W8izI8ESNgy/4PuNB2IO3en83phf967ggKXjfr+nxnb9RYOH?=
 =?us-ascii?Q?W2mD7aBraTj1aicICFq1niGI+csfjSJzO7Zx/klucLer/qr064QDXQDAQebR?=
 =?us-ascii?Q?aoD5ljKOE7ObI6g06PnbDvIwmXXuqiNqPGObfgI6QoNDX0B8JLmAU9rGrCEl?=
 =?us-ascii?Q?F9lGRn4cnJQMFN8a4XCasdoLj7vQFPyWORtm2Kv+XPNcgr8FT7Nc1Ut5DBJb?=
 =?us-ascii?Q?yotFceFxfbpCsfwAoKUE1NRYmq9N6jNgB3+N2BFDahZslm7LR8S1/DsN4pTz?=
 =?us-ascii?Q?JIkHyfnwFL9MlyyEHy2FEwwnyeUfPjzKfFi2SMNvirqHPxJDQ6Ec05Df2dn8?=
 =?us-ascii?Q?XqKCL25DdDnjbmqyILkhvhxd6Es4kUzrKtbSDwtWDBRtZKFEQD/jS8Sed/dX?=
 =?us-ascii?Q?FbLCfG456uRzHIXy8/Q1Cjhp5nSmqLK0ay/kUIo10s6OYYAN+o7KCYKyHQ9v?=
 =?us-ascii?Q?MUnaxILJG3U9F1AhN+Hj5jeZ8SxxvU5QkoFQThiDuvvbb4gtZaqlo4xhRWdh?=
 =?us-ascii?Q?dE1jk8lCkd8zIfiOjvv3i6PjHxg+ncUeFM1de9gl26H4ucam5H7Hb6cVNjEz?=
 =?us-ascii?Q?uBnuOUzZVkfktCzwUYI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5452b68-ee5e-4f0d-bbfc-08d9e5b1be51
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2022 18:36:21.7603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CcEwqC60IK7BtNQtTvY9b+izEQATqi5EjbV8ZO1yUFiSTB5xY0hr8zmaQBURhn9p
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1297
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 01, 2022 at 10:04:08AM -0700, Alex Williamson wrote:

> Ok, let me parrot back to see if I understand.  -ENOTTY will be
> returned if the ioctl doesn't exist, in which case device_state is
> untouched and cannot be trusted.  At the same time, we expect the user
> to use the feature ioctl to make sure the ioctl exists, so it would
> seem that we've reclaimed that errno if we believe the user should
> follow the protocol.

I don't follow - the documentation says what the code does, if you get
ENOTTY returned then you don't get the device_state too. Saying the
user shouldn't have called it in the first place is completely
correct, but doesn't change the device_state output.

> +       if (!device->ops->migration_set_state)
> +               return -EOPNOTSUPP;
> 
> Should return -ENOTTY, just as the feature does.  

As far as I know the kernel 'standard' is:
 - ENOTTY if the ioctl cmd # itself is not understood
 - E2BIG if the ioctl arg is longer than the kernel understands
 - EOPNOTSUPP if the ioctl arg contains data the kernel doesn't
   understand (eg flags the kernel doesn't know about), or the
   kernel understands the request but cannot support it for some
   reason.
 - EINVAL if the ioctl arg contains data the kernel knows about but
   rejects (ie invalid combinations of flags)

VFIO kind of has its own thing, but I'm not entirely sure what the
rules are, eg you asked for EOPNOTSUPP in the other patch, and here we
are asking for ENOTTY?

But sure, lets make it ENOTTY.

> But it's also for future unsupported ops, but couldn't we also
> specify that the driver must fill final_state with the current
> device state for any such case.  We also have this:
> 
> +       if (set_state.argsz < minsz || set_state.flags)
> +               return -EOPNOTSUPP;
> 
> Which I think should be -EINVAL.

That would match the majority of other VFIO tests.

> That leaves -EFAULT, for example:
> 
> +       if (copy_from_user(&set_state, arg, minsz))
> +               return -EFAULT;
> 
> Should we be able to know the current device state in core code such
> that we can fill in device state here?

There is no point in doing a copy_to_user() to the same memory if a
copy_from_user() failed, so device_state will still not be returned.

We don't know the device_state in the core code because it can only be
read under locking that is controlled by the driver. I hope when we
get another driver merged that we can hoist the locking, but right now
I'm not really sure - it is a complicated lock.

> I think those changes would go a ways towards fully specified behavior
> instead of these wishy washy unreliable return values.  Then we could

Huh? It is fully specified already. These changes just removed
EOPNOTSUPP from the list where device_state isn't filled in. It is OK,
but it is not really different...

>  "If this function fails and returns -1 then..."
> 
> Could we clarify that to s/function/ioctl/?  It caused me a moment of
> confusion for the returned -errnos.

Sure.

> > > Should we be bumping a reference on the device FD such that we can't
> > > have outstanding migration FDs with the device closed (and
> > > re-assigned to a new user)?  
> > 
> > The driver must ensure any activity triggered by the migration FD
> > against the vfio_device is halted before close_device() returns, just
> > like basically everything else connected to open/close_device(). mlx5
> > does this by using the same EOF sanitizing the FSM logic uses.
> > 
> > Once sanitized the f_ops should not be touching the vfio_device, or
> > even have a pointer to it, so there is no reason to connect the two
> > FDs together. I'd say it is a red flag if a driver proposes to do
> > this, likely it means it has a problem with the open/close_device()
> > lifetime model.
> 
> Maybe we just need a paragraph somewhere to describe the driver
> responsibilities and expectations in managing the migration FD,
> including disconnecting it after end of stream and access relative to
> the open state of the vfio_device.  Seems an expanded descriptions
> somewhere near the declaration in vfio_device_ops would be appropriate.

Yes that is probably better than in the uapi header.

> > I'm not sure what the overall VFIO vision is here.. Are we abandoning
> > traditional ioctls in favour of a multiplexer? Calling the multiplexer
> > ioctl "feature" is a bit odd..
> 
> Is it really?  VF Token support is a feature that a device might have
> and we can use the same interface to probe that it exists as well as
> set the UUID token.  We're using it to manipulate the state of a device
> feature.
> 
> If we're only looking for a means to expose that a device has support
> for something, our options are a flag bit on the vfio_device_info or a
> capability on that ioctl.  It's arguable that the latter might be a
> better option for VFIO_DEVICE_FEATURE_MIGRATION since its purpose is
> only to return a flags field, ie. we're not interacting with a feature,
> we're exposing a capability with fixed properties.

I looked at this, and decided against it on practical reasons.

I've organized this so the core code can do more work for the driver,
which means the core code supplies the support info back to
userspace. VFIO_DEVICE_INFO is currently open coded in every single
driver and lifting that to get the same support looks like a huge
pain. Even if we try to work it backwards somehow, we'd need to
re-organize vfio-pci so other drivers can contribute to the cap chain -
which is another ugly looking thing.

On top of that, qemu becomes much less straightforward as we have to
piggy back on the existing vfio code instead of just doing a simple
ioctl to get back the small support info back. There is even an
unpleasing mandatory user/kernel memory allocation and double ioctl in
the caps path.

The feature approach is much better, it has a much cleaner
implementation in user/kernel. I think we should focus on it going
forward and freeze caps.

> > It complicates the user code a bit, it is more complicated to invoke the
> > VFIO_DEVICE_FEATURE (check the qemu patch to see the difference).
> 
> Is it really any more than some wrapper code?  Are there objections to
> this sort of multiplexer?

There isn't too much reason to do this kind of stuff. Each subsystem
gets something like 4 million ioctl numbers within its type, we will
never run out of unique ioctls.

Normal ioctls have a nice simplicity to them, adding layers creates
complexity, feature is defiantly more complex to implement, and cap
is a whole other level of more complex. None of this is necessary.

I don't know what "cluttering" means here, I'd prefer we focus on
things that give clean code and simple implementations than arbitary
aesthetics.

> > Either way I don't have a strong opinion, please have a think and let
> > us know which you'd like to follow.
> 
> I'm leaning towards a capability for migration support flags and a
> feature for setting the state, but let me know if this looks like a bad
> idea for some reason.  Thanks,

I don't want to touch capabilities, but we can try to use feature for
set state. Please confirm this is what you want.

You'll want the same for the PRE_COPY related information too?

If we are into these very minor nitpicks does this mean you are OK
with all the big topics now?

Jason
