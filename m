Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0435459572
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 20:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239730AbhKVTV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 14:21:29 -0500
Received: from mail-co1nam11on2043.outbound.protection.outlook.com ([40.107.220.43]:9280
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230159AbhKVTV2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 14:21:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nk8X6tGxngXkejW2k6N/T+BRUmwKHdK87q6bitr3obxrSAKOEoCl6XhjazvZT4Ny6LZQ1cEk6TyLPt9tbAHsfAI4VKYETCXdYeWMGK+7xaLqqGCJD84bnv7rNcgTh0U9+pkdqLhq2TUj1n4sKH7/tQuYrRw3VCvPPLP1DB7S7adgIkfBSdUOPUGy0cLVi8cMPA7Keb9C5hkcblvYrKg56W4WL76iF0d9HY5UvPX+eITSM78mVdqJ76PjUvWGjntgkVIMjenm7VkLQLKWg8F+9x7sGWSyYuiuE+meOHGD148yOkelX9mKpFK7cBdjOSAGBIIrp1ziBNjByc6o8o/pkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+uK+/tTaeQ3t0ochNRY6SxbsZXfRVBmI872/khRzBuY=;
 b=MBfjt2MAo0UyolFlR+5DxJjl+ocTP6uU946Dsmn3/HOQyU9otHEf4t0ZzfZNWbpZcfNUwNOM86gn2E66J/IrBzl+eb/EKfgVzaVvy88Jyw0z9utCDcnwV5uPN+zrKh4uC3SQVGm8EBc9/ou+jAF/QsEuB9IH2bJ1T9W/ZaAqPdkNwfvoyTqR9Gs6NyJNAllUuhNitqDPUrx/Cpo+0FxuyCQM7mDf5QH6nMotvJlkVfDg1UdzlILA3n9AbOyIvUm1XqZqJzrZtYWPZi9Ae03gHh5v/QwAjgQpl/t7IqCqTL3cINSMRrT9U8sekB5cDCfw2RjsaKOIc8N1tMHvxFz4oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+uK+/tTaeQ3t0ochNRY6SxbsZXfRVBmI872/khRzBuY=;
 b=sMvqQi8hKdWp+OWZ8ykmpX+RUg9U7BJqE1+lgx27uuGmSuFsFYIShIyDXnZgf9MopqoiRMcZv1/VjY0CklevbJJZWmElYIQWaMNq6l708ZreommcSyQjOFVQkicxkz4I0xk2N0F0eZr8U+1Znv1ou3oko3bTCMzynz6ks2QDjxmNg6k65nz8bvJB92fCBReeGPw1yBCDpI/b+L72LHD6W5fXePRIPYeBO/dfRD1gygGqtsiZvzG7Wu9hCS/pM+E6X+04nOToOMaIcMuRYrRj7MDe5/90UjNBVXQmZMQk497IzFonpgm00SBQJZiQxGgmJ2FrNHg9j9wwYeoJD4kWxg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5362.namprd12.prod.outlook.com (2603:10b6:208:31d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Mon, 22 Nov
 2021 19:18:18 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909%7]) with mapi id 15.20.4713.025; Mon, 22 Nov 2021
 19:18:18 +0000
Date:   Mon, 22 Nov 2021 15:18:16 -0400
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
Message-ID: <20211122191816.GH2105516@nvidia.com>
References: <20211103161019.GR2744544@nvidia.com>
 <20211103120411.3a470501.alex.williamson@redhat.com>
 <20211105132404.GB2744544@nvidia.com>
 <20211105093145.386d0e89.alex.williamson@redhat.com>
 <20211115232921.GV2105516@nvidia.com>
 <20211116105736.0388a183.alex.williamson@redhat.com>
 <20211116192505.GB2105516@nvidia.com>
 <20211116141031.443e8936.alex.williamson@redhat.com>
 <20211117014831.GH2105516@nvidia.com>
 <20211118111555.18dd7d4f.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211118111555.18dd7d4f.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR16CA0064.namprd16.prod.outlook.com
 (2603:10b6:208:234::33) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR16CA0064.namprd16.prod.outlook.com (2603:10b6:208:234::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.20 via Frontend Transport; Mon, 22 Nov 2021 19:18:18 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mpEpU-00DwlL-Ux; Mon, 22 Nov 2021 15:18:16 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 702cca16-e7d3-453d-449b-08d9adecd709
X-MS-TrafficTypeDiagnostic: BL1PR12MB5362:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5362B5BAE79D02CC0742743FC29F9@BL1PR12MB5362.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XsH3mDbEdgesZtBxr/j1c4T9TvMGXwIqN25d0UvOpN5mz8XTQtauDdY0c0lvALMVY1XHsF2zYc1fApoJB9PGajfWLfTGSsb7l7+bSmbriDJcZ6DThlU/uSeAJWqvYlD7AqqUnI7hZHd2QaDdEzFgDwyubVEXkGMZ3iQ3+RZGwVN/ejizbv0j6z7CcuadprNt8doD6liT+JaKyMgnGOMVbAXl/i1k/FnmCgBopkxKZY1LBaX/DUu16GD9+RftXXaM7COCTWKoOg4K1iUqKrxAyjll5kKXOFFP8zo2FLKTTG8VQZ0HVjt3UhA8VtaezPkQmSgm8U5cN8rOWWJypueePqvUfo11uhZLUk/7vnsxKZe/JwqIIIymQCzpjuoYJfVFrtvveedi4OIL4cNKcURG6uzxcNaqFz9D9QEeL7IUr31vjhmEETYhiA34js044oj8ZoS3TqLiihmhxLVjD9hZz2S6HJPX6vAy8C/12s4VcxGFkG/gRpw71p0od3N6gc+HynTwHwvL4L2QAaN59qI35oLSmtbl1rK8O4qBBWT/PQNUocPOeSi/jfBKYotwB/LLMUveVGqlAxqT1gzSu1ePKX9chVOJ6HtmWrG5CuCqvAHoocxu+VauY45+mhXEI+ZmmnROonDjsPzPu4ufE9r9Zg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(66946007)(66476007)(2616005)(5660300002)(8676002)(36756003)(426003)(4326008)(8936002)(83380400001)(33656002)(508600001)(6916009)(9746002)(1076003)(2906002)(9786002)(38100700002)(26005)(54906003)(316002)(186003)(30864003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cdiIjkkkkZrlcAuP2SBnbWPW8IJ1vUWqJ0pl7HmCOYKlO2R85FGtOjdknNA6?=
 =?us-ascii?Q?0CSZgx2mr0B2Fjw+uRLGtFklOM00mWXVuJ/fwXNAqNZkCLM9J+Mp2wqWKbh1?=
 =?us-ascii?Q?CnF/oTvuYTrKHsdJdq/yLximmNfi3vpuvorp+TPXDUVeiDR5n6h9r/CQha/N?=
 =?us-ascii?Q?aPWEjMt0Sslc5xEIsj35X/GHdAmgRGoipC1h5rPzFpTROalgi5lCG0nCY3qb?=
 =?us-ascii?Q?SfjkDf04g8y+KDQdztf+Rl08lbQF7wC3ojV20Y2Zd7PeC2nF7eRw2RlXawPl?=
 =?us-ascii?Q?U9tpYSy6tEc67HYSK7YciqAe5DCJjknD+srLAsC6wmswt+aQF2yZRMdJO5TT?=
 =?us-ascii?Q?nes4Kw4VmLtzUkcwTAq4B0Z2kyyDpZMBlmNnQBbyaTPhQ9dgqgUGr1r00Cjx?=
 =?us-ascii?Q?6Zqf13b4plMRHu9vRnP+r1VZprO7i5tXyUHrgkzvgzb9sWo0/CXSJaEParuZ?=
 =?us-ascii?Q?b+kZ3HfzgktYs0Gye/KCtI/80hme242+nl7pt5PZewBQpAVVOEot2jnWRwLp?=
 =?us-ascii?Q?IpEkq7F+s01TKsSOJIZhYjOJEUsBROrqSvcf095E1Mluz8IQT5K8ADeyyIwm?=
 =?us-ascii?Q?e2D0Nc77ahLgFjlUiL7Ra7DE2Yo/54ZGMsuNTSD+SV+fLRIpi9320md4HBxb?=
 =?us-ascii?Q?kRUJNii6IQJXHKXIyK8ugSZpsF0qRHWgbF/r8rDXAGpmX0IIt926ZUPTKiH2?=
 =?us-ascii?Q?V93/S9WBlzqFznpo0J3WS8OrIh+iMDzbi7ARSccwICDoc5PWYT2FR/QHbYUr?=
 =?us-ascii?Q?AkRuvWurf1rRoTMhnUW9sqpzGthifKiuO/oxAAIdltsylCtCdeAorMGjIPPx?=
 =?us-ascii?Q?HOJlu6R0yoA5Ok6JtI2RmP6bkIvhg9kJ18eaPcxlNZk6oLQGu775wbBy9OQH?=
 =?us-ascii?Q?idZGBMj+bNbLACZDHFz3xJAWjDmJZJceZQjjYK1YTv+kjjhJSQTxOn6yPzK7?=
 =?us-ascii?Q?BAKXEmTIR2UDwASyAgHqrKIGFY8nzQbkjFYvLMhhdSCO3k2EYV/2ixmx1lgl?=
 =?us-ascii?Q?Ez+pjiT6OMX9pHK7wmjMwM81gOFspV+Y0GWB9s+sAOrokpqocWna1iynGp1i?=
 =?us-ascii?Q?j4jWJNLpkjoJlvx3BR7zyO4/VI2yfjOoqR2j4s7icYu7AkURCokBGTEGxRiO?=
 =?us-ascii?Q?hT2cnWCaxLyXVFSmQTfC3z5Rl2Z3qdIdes0sAB/CzcuRsQFZUX0D14RBtVOo?=
 =?us-ascii?Q?u3N35FuOMWOjfaLsq9c9h1bTsqS46/cjWYnaTHBc9CKETqDAoPeBgHuHek3/?=
 =?us-ascii?Q?B6KvAwWmRchPdEUU9CO82toy/ibTgudHA0w1f3BXHwmT30G8M32CiNzCXedj?=
 =?us-ascii?Q?YyO7wfadyBC/a1M/QyFYB4LMIB5lpBUQnREeUTmj9YV2P/B7phROTMTPvnOs?=
 =?us-ascii?Q?oXZZnnSQg4hIKOa4dPZCC9Qd5JQNVx3eeS/x/5MYOslePp0Cld9x9HgWxCut?=
 =?us-ascii?Q?2hXgCuVFj+UCFu2cSHmGgOH3kzbb0Tz3w1QnU+5hnjO5Fl1XIHDR+f6SD8+U?=
 =?us-ascii?Q?ulLtrQEwSKwxbkuNRxGiuaHSTUEHUuEA4X8cNCIZ1FxyRHxXAjN1m2w8GUap?=
 =?us-ascii?Q?/eTCH/c72BA+C8tJtiA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 702cca16-e7d3-453d-449b-08d9adecd709
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2021 19:18:18.5473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lv9l8d8TEmTsXZz712UKMlAFQ0IfYNHndp1knpk+bgQxZjWvemZ4pwHAz8xjxS3D
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5362
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 18, 2021 at 11:15:55AM -0700, Alex Williamson wrote:
> On Tue, 16 Nov 2021 21:48:31 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Tue, Nov 16, 2021 at 02:10:31PM -0700, Alex Williamson wrote:
> > > On Tue, 16 Nov 2021 15:25:05 -0400
> > > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > >   
> > > > On Tue, Nov 16, 2021 at 10:57:36AM -0700, Alex Williamson wrote:
> > > >   
> > > > > > I think userspace should decide if it wants to use mlx5 built in or
> > > > > > the system IOMMU to do dirty tracking.    
> > > > > 
> > > > > What information does userspace use to inform such a decision?    
> > > > 
> > > > Kernel can't know which approach performs better. Operators should
> > > > benchmark and make a choice for their deployment HW. Maybe device
> > > > tracking severely impacts device performance or vice versa.  
> > > 
> > > I'm all for keeping policy decisions out of the kernel, but it's pretty
> > > absurd to expect a userspace operator to benchmark various combination
> > > and wire various knobs through the user interface for this.   
> > 
> > Huh? This is the standard operating procedure in netdev land, mm and
> > others. Max performance requires tunables. And here we really do care
> > alot about migration time. I've seen the mm complexity supporting the
> > normal vCPU migration to know this is a high priority for many people.
> 
> Per previous reply:
> 
> "Maybe start with what uAPI visible knobs really make sense
> and provide a benefit for per-device dirty bitmap tuning and how a
> device agnostic userspace like QEMU is going to make intelligent
> decisions about those knobs."

Well, the main knob is to pick which dirty tracker to use, and a
2ndary knob is to perhaps configure it (eg granual size or something,
but I have nothing concrete right now).

How to do that in the current uapi? I don't know. Beyond some very
ugly 'do not use system iommu' flag that doesn't fit every need, I
don't have any suggestion.

IMHO, generic qemu is fine to do something simple like always prefer
the system IOMMU tracker.

> QEMU is device agnostic and has no visibility to the system IOMMU
> capabilities.

Ah, there is a lot going on here. We are adding iommufd and iommufd's
design has a specific place to expose the iommu_domain, it's unique
capabilities, and uAPI visible connections from the devices. This is
the big uAPI design upgrade that is needed to get to all the features
we want to see on the iommu side.

For what we have now it is quite easy to add a few ioctls for dirty
track query/start/stop/read&clear that wire directly 1:1 to an ops on
the iommu_domain.

So, qemu does a simple 'query' to the iommu_domain, sees dirty track
is supported and esn't even do anything device specific. If that fails
then it queries each vfio_device for a tracker, if that fails it
operates with no dirty track.

Since each domain and device is a uAPI object all policy is trivially
in userspace hands with a simple uAPI design.

> > The current implementation forces no dirty tracking. That is a policy
> > choice that denies userspace the option to run one device with dirty
> > track and simply suspend the other.
> 
> "Forces no dirty tracking"?  I think you're suggesting that if a device
> within an IOMMU context doesn't support dirty tracking that we're
> forced to always report all mappings within that context as dirty,
> because for some reason we're not allowed to evolve how devices can
> interact with a shared dirty context, but we are allowed to invent a new
> per-device uAPI?

Basically yes. If we are changing the uAPI then let's change it to
something that makes sense for the HW implementations we actually
have. If you have a clever idea how to do this with the current API
I'm interested to hear, but I don't have anything in mind right now
that isn't much more complicated for everyone.

> What if we have a scenario where devices optionally have per device
> dirty page tracking.
> 
> A) mlx5 w/ device level dirty page tracking, vGPU w/ page pinning
> 
> vs
> 
> B) mlx5 w/ device level dirty page tracking, NIC with system IOMMU
>    dirty page tracking
> 
> Compare and contrast in which case the shared IOMMU context dirty page
> tracking reports both device's versus only the devices without
> per-device tracking.  Is this obvious to both userspace and the shared
> dirty page tracking if it's the same or different in both cases?

Neither A nor B have 'shared dirty page tracking'

The only case where we have some kind of shared tracker is when there
are multiple mdevs with migration support, and the mdev HW can support
a shared bitmap.

In iommufd we still have a reasonable place to put a shared mdev dirty
tracker - the "emulated iommu" is also exposed as uAPI object that can
hold it - however I wouldn't want to implement that in iommufd until
we have some intree drivers that need it.

All the out of tree mdev drivers can use the device specific ioctl. It
only means they can't share dirty bitmaps. Which I think is a
reasonable penalty for out of tree drivers.

> If maybe what you're really trying to get at all along is visibility to
> the per-device dirty page contribution, that does sound interesting.

Visibility and control, yes. It is the requests I've had from our
internal teams.

> But I also don't know how that interacts with system IOMMU based
> reporting.  Does the IOMMU report to the driver that reports to
> userspace the per-device dirty pages?

No, the system IOMMU reports through iommufd on the
iommu_domain. Completely unconnected from the migration driver.

Completely unconnected is the design simplification because I don't
need to make kernel infrastructure to build that connection and uAPI
to manage it explicitly.

> That depends whether there are other devices in the context and if the
> container dirty context is meant to include all devices or if the
> driver is opt'ing out of the shared tracking... 

Right now, *today*, I know of nothing that needs or can make good use
of shared state bitmaps.

> Alternatively, drivers could register callbacks to report their dirty
> pages into the shared tracking for ranges requested by the user.  We
> need to figure out how per-device tracking an system IOMMU tracking get
> along if that's where we're headed.

I don't want shared tracking, it is a waste of CPU and memory
resources. With a single API the only thing that would be OK is no
shared state and kernel iterates over all the trackers. This is quite
far from what is there right now.

> do something like that, then we have some devices that can do p2p and
> some devices that cannot... all or none seems like a much more
> deterministic choice for QEMU.  How do guest drivers currently test p2p?

There is a 'p2p allowed' call inside the kernel pci_p2p layer. It
could concievably be extended to consult some firmware table provided
by the hypervisor. It is another one of these cases, like IMS, where
guest transparency is not possible :(

However, you can easially see this need arising - eg a GPU is
frequently a P2P target but rarely a P2P initiator.

It is another case where I can see people making custom VMMs deviating
from what makes sense in enterprise qemu.

> Agreed, but I don't see that userspace choosing to use separate
> contexts either negates the value of the kernel aggregating dirty pages
> within a container or clearly makes the case for per-device dirty pages.

I bring it up because I don't see a clear way to support it at all
with the current API design. Happy to hear ideas

> It's only finally here in the thread that we're seeing some of the mlx5
> implementation details that might favor a per-device solution, hints
> that per device page granularity might be useful, and maybe that
> exposing per-device dirty page footprints to userspace is underlying
> this change of course.

Well, yes, I mean we've thought about this quite a lot internally, we
are not suggesting things randomly for "NIH" as you said. We have lots
of different use cases, several customers, multiple devices and more.

> So provide the justification I asked for previously and quoted above,
> what are the things we want to be able to tune that cannot be done
> through reasonable extensions of the current design?  I'm not trying to
> be dismissive, I'm lacking facts and evidence of due diligence that the
> current design is incapable of meeting our goals.

It is not incapable or not, it is ROI. I'm sure we can hack the
current design into something, with a lot of work and complexity.

I'm saying we see a much simpler version that has a simpler kernel
side.

> > If we split them it looks quite simple:
> >  - new ioctl on vfio device to read & clear dirty bitmap
> >     & extension flag to show this is supported
> >  - DIRTY_TRACK migration state bit to start/stop
> 
> Is this another device_state bit?

Probably, or a device ioctl - semantically the same

> >    Simple logic that read is only possible in NDMA/!RUNNING
> >  - new ioctl on vfio device to report dirty tracking capability flags:
> >     - internal dirty track supported
> >     - real dirty track through attached container supported
> >       (only mdev can set this today)
> 
> How does system IOMMU dirty tracking work?

As above, it is parallel and completely contained in iommufd.

It is split, iommufd only does system iommu tracking, the device FD
only does device integral tracking. They never cross interfaces
internally, so I don't need to make a kernel framework to support,
aggregate and control multiple dirty trackers.

> I don't understand what's being described here, I'm glad an attempt is
> being made to see what this might look like with the current interface,
> but at the same time the outline seems biased towards a complicated
> portrayal.

Well, not understanding is a problem :|
 
> > a. works the same, kernel turns on both trackers
> > b. works the same, kernel turns on only mlx5
> > c. Hum. We have to disable the 'no tracker report everything as
> >    dirty' feature somehow so we can access only the mlx5 tracker
> >    without forcing evey page seen as dirty. Needs a details
> 
> Doesn't seem as complicated in my rendition.

I don't see your path through the code.

> > And I don't see that it makes userspace really much simpler anyhow. On
> > the other hand it looks like a lot more kernel work..
> 
> There's kernel work either way.

Yes, more vs less :)
 
> > > OTOH, aggregating these features in the IOMMU reduces both overhead
> > > of per device bitmaps and user operations to create their own
> > > consolidated view.  
> > 
> > I don't understand this, funneling will not reduce overhead, at best
> > with some work we can almost break even by not allocating the SW
> > bitmaps.
> 
> The moment we have more than one device that requires a bitmap, where
> the device doesn't have the visibility of the extent of the bitmap, we
> introduce both space and time overhead versus a shared bitmap that can
> be pre-allocated.

The HW designs we can see right now: mlx5, AMD IOMMU, and hns IOMMU
(though less clear on this one) track the full IOVA space, they store
the track in their own memory and they allow reading each page's dirty
bit with an 'atomic test and clear' semantic.

So currently, we have *zero* devices that require the shared bitmap.

Why should I invest in maintaining and extending this code that has no
current user and no known future purpose?

> What's being asked for here is a change from the current plan of
> record, that entails work and justification, including tangible
> benefits versus a fair exploration of how the same might work in the
> current design.

So, we will make patches for our plan to split them.

We'll show an mlx5 implementation using an ioctl on the vfio device.

I'll sketch how a system iommu works through iommu_domain ops in
iommufd (my goal is to get an AMD implementation at least too)

I can write a paragraph how to fit a shared mdev bitmap tracker into
iommufd if an in-tree user comes..

Can someone provide an equally complete view of how to extend the
current API and solve the same set of use cases?

We can revist this in a month or so when we might have a mlx5 patch.

Jason
