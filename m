Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5852F43D194
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 21:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239173AbhJ0T0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 15:26:17 -0400
Received: from mail-co1nam11on2072.outbound.protection.outlook.com ([40.107.220.72]:52321
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231430AbhJ0T0P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 15:26:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jUn68o7uzFDTQEy7my4Z4MhYV/SevFLRAUzmpzPcTJ/ro6O5YWOs1uJGHdOlOqBHXvXRNUnyfDHrgyh7h+US9wL0CjfjNWSxx6XGW3Fk3oAnFy+nYntsZSPjyQtWUJJRXAdGAMK738brgA8YlsDSDFWr0tXqrmdLpLKZqnplWbI2t/2rKLl43ldynCuYar2a/iXXWNzsmSjt8wZl1cqL5sW4FWLgj4NKjh1t7hyIEFFqamlWIFkfGC+SAmPmNBXyIEY1Q9zm3N6JxD8KkrXzLaKh1fTezNErVi9bZAVL/PSwK2jhIcE+bqlF3Z2Khzk7Vm+0pZ4yVCfoAP0i442+ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FJTTNBv5/0EJPz+pjDlIDgQAHVXhxIj+ma9kUZxxI1E=;
 b=M9degXxj9/ZLGI/R4T9iJs5umtAy3VCpk/rL2gWTfXOH3jZhf9/lbNrPewYGvIImedjtDQPoZh03U2UQFTyV2JSThHcPgP4J2Eq6P3YEZuKTjnHEUw+as1aGigdm+gnd0Tt5vBlEvqwO1z3yDaKr66Ef3Ex/C+uvM/po9Y7LZ20WRA5NycF+iTQFBB4ny8IachSaoIG+HTlA07cqZ84Dq6cAEorGj3Knoo9F3tnxFk6HUAuc8P/cvg1Ses/JP+6WVk+1fNAIsWLoen/3uETS1YrkZNjBpK74naPCiIUawWaPM6m2LvoTtODT3/SS/VPiBwClRzVhAP8WkIYFupLPeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FJTTNBv5/0EJPz+pjDlIDgQAHVXhxIj+ma9kUZxxI1E=;
 b=rXBQu5pn7nypx6wsLz6bsJRn3tRWJ0eUOF84JiAKfh22lBsJoihwJYuy9G+ZdVUAAYd1CRrv/7ZrmLePEe4YW6CPKPaHkUiszrP0lvL9QEDMM3EJq5iKT3xFUxbOqyerhf7ivNcyyTjwL5bHlF4kCtdeVJnrNgWd2jENoDYPgYxS9vH8MhXX0977qNB1lTOjXuZnP/5KPn9k1NdBNlVwwwYcGdNm+T2pS4LfFTp5fG1qDMzzCWSY1YfaGirMsr/1VOCVQuM4+lIa/vGkhDrjHNJLtAQIMnlIzvhliUVoH6e6BkJJRU/IvKQJ2C1kbtB6k0dWc8ufBWhfH1UJWWHIyQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5079.namprd12.prod.outlook.com (2603:10b6:208:31a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15; Wed, 27 Oct
 2021 19:23:47 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4649.015; Wed, 27 Oct 2021
 19:23:47 +0000
Date:   Wed, 27 Oct 2021 16:23:45 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211027192345.GJ2744544@nvidia.com>
References: <87o87isovr.fsf@redhat.com>
 <20211021154729.0e166e67.alex.williamson@redhat.com>
 <20211025122938.GR2744544@nvidia.com>
 <20211025082857.4baa4794.alex.williamson@redhat.com>
 <20211025145646.GX2744544@nvidia.com>
 <20211026084212.36b0142c.alex.williamson@redhat.com>
 <20211026151851.GW2744544@nvidia.com>
 <20211026135046.5190e103.alex.williamson@redhat.com>
 <20211026234300.GA2744544@nvidia.com>
 <20211027130520.33652a49.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211027130520.33652a49.alex.williamson@redhat.com>
X-ClientProxiedBy: BY3PR05CA0004.namprd05.prod.outlook.com
 (2603:10b6:a03:254::9) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by BY3PR05CA0004.namprd05.prod.outlook.com (2603:10b6:a03:254::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.4 via Frontend Transport; Wed, 27 Oct 2021 19:23:47 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mfoWX-002jvH-Gk; Wed, 27 Oct 2021 16:23:45 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 15ce1dee-5f3d-412c-357f-08d9997f4ca5
X-MS-TrafficTypeDiagnostic: BL1PR12MB5079:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5079DDC179CFAF6A94E4E5A3C2859@BL1PR12MB5079.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2Y565uylg+33d9AGoZ7242YHqXORv1yi6oferY40146c0FuMG9mlqtB9UCHDZ/GTjmNJhYIT+0Pg8Vdvn5ukbwiEgnESC8HMkFf1mJ+arYDzA0H1L0qrfnfz6bnHGewwQ7yXD/I4nqqeWffJo1+Ee0YBfqhz6mEOEOtPDlczVTN2CoYny0GG7TREaTjoO3AJInAV663mpxWDh04VOj35h6XKajRAjV+NxKgdNhm8lmN4P1OJuohfKD60MUyfakuyjJqP8OYCBHgH7Bpc7BLougduj6uEChfKOKBLPwUocsFVh2l7TVA8nRgATQtDgaJjlIPgRtKaEjK+w45vmi/g1miNWGDzk9MshVryGKb85A4vp596d+UTu1eP+mNoe5gtcTWA5s0CCOYWJ2p8saxRjWCO8uhk1SVosP7FPZcoSlLlupa3TN5s2O+sC+ytC8IawK4DlWKFkGD0HhFz8zQz9WedDblqVKfPaXM+Fg6OO/m8C7Wcor5ezTVoS1Cj+dAp0Yj6J1m4b2PwN3W1LunfZpRZwUGADD5S+dtdDes06lHQvlSLoRSe8si37+GZeSSpqCsLuOlosPA9JbbIKhpflkUQ5ETMxX+meP6EXl1i9yoxEUQG1lWerKIdYhUHclEHRJ1GqMu7WRAFJ2gvMMzGuw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(426003)(33656002)(26005)(8936002)(54906003)(186003)(36756003)(2906002)(2616005)(316002)(86362001)(66556008)(83380400001)(38100700002)(66946007)(6916009)(9786002)(1076003)(9746002)(8676002)(4326008)(5660300002)(508600001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W2hH4y0dXtHlIfT4QRv2boiA7xEoAd/Cf7od0SLXqPHTBnb9P9ZPH1ZHafwi?=
 =?us-ascii?Q?RTU6Va0ii0rQ7qjJ3K/V8yPbx/l9Z/40mbkEzK3/1dVJsigzDZAVHXb5Y6at?=
 =?us-ascii?Q?sQNumkP/VUdkhYDMcIpvqer0ql99XCl2XT4LsCJGcGdkBGiftV6o9xlEk+NM?=
 =?us-ascii?Q?L7bmpqaRDqao8nWhU6tpToopSoISOiuZsh32r9F8i0KnLBbbXMl2ri/I52yW?=
 =?us-ascii?Q?qAraEi5KWY3+3aJu6M/KlCJpn1dGOtA2aAXq7xw7L4z7w3x4wX/rhAxGNdtD?=
 =?us-ascii?Q?brxOWfYGWBao8VGtOz+iB4kiYT3CIdHp1LMkQ/tZBdiYbQO1mdET6cala8IR?=
 =?us-ascii?Q?uYJ6zdp3CCmwMTzU3cZx5rABD+5cwrtyB/nzovpdA6/hNe+xhIyIHi9HcmR7?=
 =?us-ascii?Q?q3aAcDsJ+Llv9GxQMq0sCOj+BoOIIift9jf1jkhW9Flyf1zcxbkbBVjiJvqC?=
 =?us-ascii?Q?P4eimjmSKnjH2zRw/3OIlrrNg8ih2aYgrqhGI5DqhvZLg/lPRu47oh2V0VoA?=
 =?us-ascii?Q?peR6eJm1I9voMvs2+1xb9bBVXPB4wW3gwOUvOJC7pIjpN99NEkyqFhF77BwN?=
 =?us-ascii?Q?HTe7Z7iEdxpyZ0ph6E2i44+apQdHWbutGMd1FbJuMdOE+G2xhd0463EYiULS?=
 =?us-ascii?Q?9yNNWBNxFgg3uhFdfl1mC2MC2+aLIc52dlXAR3VClVQu+DF5vHOyYkc8vdRU?=
 =?us-ascii?Q?WNbjJugxEKDNz8CHomN4hUEubtQMr6RctbbFHQkjisDzUUKFTFIUhVrnpsKX?=
 =?us-ascii?Q?irhtMhJts6iklRl2ECf+WfIWKiVdeg734BOS4p3wD31Z1dbsVkHXfr4gIWUm?=
 =?us-ascii?Q?p59zCU9rdnSIQ7dJzqtQvS4U6IKHhVAWvcXcUI2lSqczQkhbD/8En+/LhGb7?=
 =?us-ascii?Q?izGb5bJXowR84g+f9bfrRLEnzClhRETWwAW62xdoiZz4RLpL8ab8CUP2d/8G?=
 =?us-ascii?Q?V/R0DiusMRQRHnV78jEvgFJbb77BBBqZoOYG+FjRdQtqI/iFo22A6JKzitgT?=
 =?us-ascii?Q?k230iNdJePEuH7kQOjwVwAKDExoUZEwtvrlxzk9wtyTkWa6LC9PdjeHOH2ho?=
 =?us-ascii?Q?xA28SZHZyzf9RSLMjeyaLX/Ltyb2FgthoPd4grN4BedRDSeoQ7d98rfdGX7b?=
 =?us-ascii?Q?Y+ZSz/UOZ3SHzr4JmQQOHJ/hKK1R3rD5lZbpV8lilhD0an3hHtnBOcLruhkU?=
 =?us-ascii?Q?nJeyM6dWSlaCBQZ5V1Hih8JJfj9gkcSbSesWTWIZraP8cHilPdMRwMuT93rX?=
 =?us-ascii?Q?tjrOZk0HFwmLPuxEoB4jQiUUKjMGKgAApyp1aqnGf6Rizq9HjJgGknCzjJiN?=
 =?us-ascii?Q?25YZ1TY7zqdHrk0gWYnsMx5Yvl0BNgGgScNDar0ZTsJdzuzCiCx3goF72tat?=
 =?us-ascii?Q?lukLHia8OpDVt4pDvlkYUmRG8n73NYZVrVQukYCFNYsmkbgFE8GsT/6ntwvg?=
 =?us-ascii?Q?2HqDf5nTlnaAmCtdXtVOOw/r1woINm43BDGiHN7Yyksw9opMZdzwAsx6nV74?=
 =?us-ascii?Q?rdDo0681kZJpeS1eEKs2OwSt3pFaqBo18/IawEFnM6BgZxUVoXRrlPoF4c2d?=
 =?us-ascii?Q?rmKj/FkKFNV8qEV65M0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15ce1dee-5f3d-412c-357f-08d9997f4ca5
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 19:23:47.6941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0oX8eOifY2VUNXwsW4xKrYcoT+kvQqmMrqMuZRpdXKk8c2a1ZhBDtozn61Cq5ZN9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5079
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 01:05:20PM -0600, Alex Williamson wrote:

> > As far as the actual issue, if you hadn't just discovered it now
> > nobody would have known we have this gap - much like how the very
> > similar reset issue was present in VFIO for so many years until you
> > plugged it.
> 
> But the fact that we did discover it is hugely important.  We've
> identified that the potential use case is significantly limited and
> that userspace doesn't have a good mechanism to determine when to
> expose that limitation to the user.  

Huh?

We've identified that, depending on device behavior, the kernel may
need to revoke MMIO access to protect itself from hostile userspace
triggering TLP Errors or something.

Well behaved userspace must already stop touching the MMIO on the
device when !RUNNING - I see no compelling argument against that
position.

We've been investigating how the mlx5 HW will behave in corner cases,
and currently it looks like mlx5 vfio will not generate error TLPs, or
corrupt the device itself due to MMIO operations when !RUNNING. So the
driver itself, as written, probably does not currently have a bug
here, or need changes.

> We're tossing around solutions that involve extensions, if not
> changes to the uAPI.  It's Wednesday of rc7.

The P2P issue is seperate, and as I keep saying, unless you want to
block support for any HW that does not have freeze&queice userspace
must be aware of this ability and it is logical to design it as an
extension from where we are now.

> I feel like we've already been burned by making one of these
> "reasonable quanta of progress" to accept and mark experimental
> decisions with where we stand between defining the uAPI in the kernel
> and accepting an experimental implementation in QEMU.  

I won't argue there..

> Now we have multiple closed driver implementations (none of which
> are contributing to this discussion), but thankfully we're not
> committed to supporting them because we have no open
> implementations.  I think we could get away with ripping up the uAPI
> if we really needed to.

Do we need to?

> > > Deciding at some point in the future to forcefully block device MMIO
> > > access from userspace when the device stops running is clearly a user
> > > visible change and therefore subject to the don't-break-userspace
> > > clause.    
> > 
> > I don't think so, this was done for reset retroactively after
> > all. Well behaved qmeu should have silenced all MMIO touches as part
> > of the ABI contract anyhow.
> 
> That's not obvious to me and I think it conflates access to the device
> and execution of the device.  If it's QEMU's responsibility to quiesce
> access to the device anyway, why does the kernel need to impose this
> restriction.  I'd think we'd generally only impose such a restriction
> if the alternative allows the user to invoke bad behavior outside the
> scope of their use of the device or consistency of the migration data.
> It appears that any such behavior would be implementation specific here.

I think if an implementation has a problem, like error TLPs, then yes,
it must fence. The conservative specification of the uAPI is that
userspace should not allow MMIO when !RUNNING.

If we ever get any implementation that needs this to fence then we
should do it for all implementations just out of consistency.

> > The "don't-break-userspace" is not an absolute prohibition, Linus has
> > been very clear this limitation is about direct, ideally demonstrable,
> > breakage to actually deployed software.
> 
> And if we introduce an open driver that unblocks QEMU support to become
> non-experimental, I think that's where we stand.

Yes, if qemu becomes deployed, but our testing shows qemu support
needs a lot of work before it is deployable, so that doesn't seem to
be an immediate risk.

> > > That might also indicate that "freeze" is only an implementation
> > > specific requirement.  Thanks,  
> > 
> > It doesn't matter if a theoretical device can exist that doesn't need
> > "freeze" - this device does, and so it is the lowest common
> > denominator for the uAPI contract and userspace must abide by the
> > restriction.
> 
> Sorry, "to the victor go the spoils" is not really how I strictly want
> to define a uAPI contract with userspace.  

This is not the "victor go the spoils" this is meeting the least
common denominator of HW we have today.

If some fictional HW can be more advanced and can snapshot not freeze,
that is great, but it doesn't change one bit that mlx5 cannot and will
not work that way. Since mlx5 must be supported, there is no choice
but to define the uAPI around its limitations.

snapshot devices are strictly a superset of freeze devices, they can
emulate freeze by doing snapshot at the freeze operation.

In all cases userspace should not touch the device when !RUNNING to
preserve generality to all implementations.

> If we're claiming that userspace is responsible for quiescing
> devices and we're providing a means for that to occur, and userspace
> is already responsible for managing MMIO access, then the only
> reason the kernel would forcefully impose such a restriction itself
> would be to protect the host and the implementation of that would
> depend on whether this is expected to be a universal or device
> specific limitation.  

I think the best way forward is to allow for revoke to happen if we
ever need it (by specification), and not implement it right now.

So, I am not left with a clear idea what is still open that you see as
blocking. Can you summarize?

Jason
