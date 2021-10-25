Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5CDE43996E
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 16:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233696AbhJYO7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 10:59:17 -0400
Received: from mail-bn8nam11on2042.outbound.protection.outlook.com ([40.107.236.42]:61707
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230268AbhJYO7L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 10:59:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZhEvy71beUfCGbMXtLRwA6Z3MDTn5+O/y2b6FVJiD0cw8Zwy6nWACMPv7TaeNStfhneTslphRhmHU6ClYCu7tbExc2iymscMrGMRc9+pYvfT7/oeB74nacvHdpXphzC/Ix+yA3XHNg60uAaGAlZIhTbdiI3+e1CwXsMpRx+FZt7ibnbYGI1VWmZqbZO8oPI/9L2VfAYwTwQmUyNoAbsa9nlzoSMi9l3bAtQXi2oabagiCSz/BZbFcyrZf7eAs0+Wr60b/sVzSy52UbHYe0snHOv+KgJGQagv6mVkY/6W6gyhC+ADRPECJ58oexLChgaAWUFTDaP1OvJT3bWi5Ji+Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hEUYunYmsFZr3LqShAPG71JsLSPYvJ1u8Rs9qAsZxx8=;
 b=m/zK9rsX/iFjK/dq6/AKSMd8NIMHKA0qofx7cghDLlpv7H+Egx/X/t2yaubUwODqQ6bIEHirdQ+oIlhpOvRLaq9f1kTg4l4X1ziw6pb8LU0J7GQ/V6cm7TndZYLVcUvY+qYdsymqCs60zDY4/+nRfg4pAjWJayi7DfMUOrwAt9wJbTcsxFQkq+xDS+VQV07fft8EAM3eUz6ZNrSNoGkWMsRkMF1ncmLjj3VmFivEMHkYfRU8HL9N2fncgd7/+dToX8RMOV8s9ptL5nlgU9ncGc7p6G03QCZRvLooOkmgcRJVfWkcct1tjp7XKsZ+gFVbBgfU976NmjTmhnaNKiTyDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hEUYunYmsFZr3LqShAPG71JsLSPYvJ1u8Rs9qAsZxx8=;
 b=FyJJcQ54HutFnvIzM37bszJWnvPxIKh9UOfl1w+O2agCTrI81hUZFl9xEEl/Tzi1x5HBQ+UEJ9yOt7endgS4hFMKag/IDkY/YDQPXxbrJFiFPhxE+OPbaeFWGWQCYkPDSzpFwfBYJvo6QQxyF8TSjJzW/kkdhlObf0V9XVSAbWGusb1GLxTogvRNdQ16NVVy59ah7MvB7ydsciixjYTA6PWWszuIGLCX68ilauXgqFK3eNEBPO0KUYvKU0M0B53jX4ETklOjhIHE6Usl3cDsKpxQqDv2cKCtIyp8N1PadBDM/SAe73Hs9BZyIf9V5ffcTM/vVJ9GrQdf94EbS1aYow==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5094.namprd12.prod.outlook.com (2603:10b6:208:312::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Mon, 25 Oct
 2021 14:56:47 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4628.020; Mon, 25 Oct 2021
 14:56:47 +0000
Date:   Mon, 25 Oct 2021 11:56:46 -0300
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
Message-ID: <20211025145646.GX2744544@nvidia.com>
References: <20211019145856.2fa7f7c8.alex.williamson@redhat.com>
 <20211019230431.GA2744544@nvidia.com>
 <5a496713-ae1d-11f2-1260-e4c1956e1eda@nvidia.com>
 <20211020105230.524e2149.alex.williamson@redhat.com>
 <20211020185919.GH2744544@nvidia.com>
 <20211020150709.7cff2066.alex.williamson@redhat.com>
 <87o87isovr.fsf@redhat.com>
 <20211021154729.0e166e67.alex.williamson@redhat.com>
 <20211025122938.GR2744544@nvidia.com>
 <20211025082857.4baa4794.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211025082857.4baa4794.alex.williamson@redhat.com>
X-ClientProxiedBy: YT3PR01CA0023.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::28) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by YT3PR01CA0023.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:86::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Mon, 25 Oct 2021 14:56:47 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mf1P4-001VHr-1l; Mon, 25 Oct 2021 11:56:46 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b6ed4c1f-6b00-406b-f54b-08d997c7ab34
X-MS-TrafficTypeDiagnostic: BL1PR12MB5094:
X-Microsoft-Antispam-PRVS: <BL1PR12MB50947DC310F7B43BCC4766DCC2839@BL1PR12MB5094.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G3femh+3cLXD/zrtYJXUUlfNAK1UgL54cAkn0LObYmboc29suQARL4T/DRKE+YLeSa6h3MUNsjZUzv2IhqfwxGIpBAunWZefMroZicQYpqdqY4jbbJ7Mb1xhq63OVtI/ewsPCFJ0noGw9tA1gy3DoAeOz+LQtXS2ehqFkQw8XBTNZ6xDTnR9eqW5NWcdNDeflQg7F2rD3yabK/7yYswjFhEI519/fqa2Cvi/mUNa+Ans56Dil4q29nY+2wIDc52ynlhOhRXurYvEt3ngZGWwGPWTVyZ4pPDhaG1c7AwLFmfrP4JAOhfq8sIulAnuV9Xma5Ygr94S8zS1GokzQ5Twgjr8PynCBxVG2lKJ5Rjreya1zEX9xg7eYtjaXs/eFUwdS3jOYZlur2s1qRHIpqDUH94fjZbBJtobXm/KAc4AJH1ys8r/2SMo6lMruiXC2E0R5hIqFy9/GRGCfkZU+pod2TOTRt8gm3fWv0eC4hEHHEy++kB6EEFSNgTMMXxP0Ax0TD2NxkmwexwnJqXyl5VkQ3CnCKgDJ20GjtNGxJOzk9m2WtE/jiolwCY16JV9E9n1RLKBDaAfkIhZlvINLBRh7XrmWwFU/hEJYoGhPzSUSJQdepecOLhOjUboMYFj9oBX40Ie2PkZfJDZgS8mg6NEBg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(1076003)(4326008)(83380400001)(8676002)(316002)(2616005)(5660300002)(9746002)(38100700002)(54906003)(508600001)(6916009)(26005)(426003)(9786002)(186003)(66946007)(33656002)(66476007)(8936002)(36756003)(66556008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JtOtWySujjAvIuJfDoCvpNc+hRcfO27OBp/5O4DyOpKnDAYj6FQJ5iQVj+w3?=
 =?us-ascii?Q?KJwEfa0i8cFJKaXbaqys8gVXI1Veq3ZVhmK8gIuu0R5rCufuVSgsf0ugvT76?=
 =?us-ascii?Q?LmW7duiOtlEhyEs4+xDXJzz98iT+fjRmTtPKbNOLWKigsOafK5fLey/Evzp/?=
 =?us-ascii?Q?NazwPYpdWdiyIClUDSKxKuSGBHfc0ZXm/XAk03psks8d/Si2cUc1zUY041jr?=
 =?us-ascii?Q?8288CjP5XaQtELS6khMQB9VyVgtonnpFnnPbUFdcVdJ+DxuQB7Do0IznCwKd?=
 =?us-ascii?Q?wXo81sevcQB/Q2BRyKX5pko9vZu5HwfBdrVE48hzQPmRN4VxxqMCrZdRby+0?=
 =?us-ascii?Q?Rat9R9k/5xPTGVGUiWnvZo1Q/yz2qDx8dBa3eVwcMEiDhFz9OiTBpH26mrIR?=
 =?us-ascii?Q?rvzBnpd4mGZ82PnBKuIy2HYr3XHZMFQUhlYe8b9aTYAGjdCNTnG5FZeVtp1r?=
 =?us-ascii?Q?490g9ACvcYCOkq5KoR+sTfW1ERe7yFRPsBY1khiQSGT0qXff7X9CUmMMQQ6/?=
 =?us-ascii?Q?dH84l+ZTem3Jxf0xAb2TEtRgUKlY9gJx8My6I7lgEjckLu99VDgLFGQ5RvDo?=
 =?us-ascii?Q?o4xRnMAqoc19yV2ISgQHucOOTxL6+TcG2htSgIqGzm8Wd1MgcEoLvYrsC39Y?=
 =?us-ascii?Q?JdqswvP+bQxU003bvFICAYCk9v4KJB7u1H7yLHBBy/EkB/2RLKhP+cdBc/sW?=
 =?us-ascii?Q?SzwApcJsCxsEvhIo7PPxiny1katYcxr1nNscLGGaXAmJH28wYcLPKgZQsqrq?=
 =?us-ascii?Q?U83wK86man/IvR1sz9qxpwkaJyDC+AS2cN7JiZfZDfn/kj+m1C8jQEWUYZQP?=
 =?us-ascii?Q?7AHWrCCTQGyuN1QIb+fMoLTbKEPVOq0DK5fWHmJ9m6cQFUE+1bg+xAKpJd+G?=
 =?us-ascii?Q?rgGdYVRqxQSfic4hUeHB4dmP2mpKGoGIOqEvDPbnLQEFL7u/liwncNPtrsls?=
 =?us-ascii?Q?js989O0u0zpd899J5mQ67GUMN5fwFlMULTBpOUdVM/spUpBbVcDIXsA9IRUd?=
 =?us-ascii?Q?2UsGpRyf0rBao/UJLTXYm+AXoSNfc4JUXr0plB4QDXGMnK6QZsvP4HSC0BsL?=
 =?us-ascii?Q?C0TjPWiaQGIKnXsbpk4QU/0qNI3xKShFTlnO2g3bLKjK2/1HR7kzLCrAl3DL?=
 =?us-ascii?Q?6zl0aHPR095cCW3Drn9Xklq8W+zoj84GkMryx8RTlTLmAHuMMQJ9VP6h3DBL?=
 =?us-ascii?Q?bDJfHgT8w2L6TUPyzXxdkmhhrZmmBujhx0zpEkqZQJczlOIp0c4+sLgxodf4?=
 =?us-ascii?Q?33uvUB4F8Fe3USiwTdLtgGzKdjt1FRPFnTqQlwSnG6qSLjbBeeAuHZJr9cmi?=
 =?us-ascii?Q?BnkVfUekUoNhxynnVWxj+knjKda6PG8WpahpIohnTf9lIPbP8iTu6kT66r07?=
 =?us-ascii?Q?a9vkdb+gGU6U3Z+DeBqmkBYydx+99IqbOTxLxxwe0ZRxTHU+Mh4GORHYqNRa?=
 =?us-ascii?Q?FJqUPNkNBzWcJfaKBJ+HX10ENgFd2GXRVl8IlyUkOsmbh0alfHof0FPT13Dh?=
 =?us-ascii?Q?vlS3QpXjfr4YliG8VAFSLbttWVEydVX+4HvKH18MYuKB6xlr7bCxxpZB0yDL?=
 =?us-ascii?Q?voNLEIsscZZuDAkFpuA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6ed4c1f-6b00-406b-f54b-08d997c7ab34
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2021 14:56:47.7770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0pXtcvS6HqDv8tSEZ1Z6Zo9USjyV75dZaW+G1zV5cfBRNt8hGmjzKIWuJhPDWpnR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5094
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 25, 2021 at 08:28:57AM -0600, Alex Williamson wrote:
> On Mon, 25 Oct 2021 09:29:38 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Thu, Oct 21, 2021 at 03:47:29PM -0600, Alex Williamson wrote:
> > > I recall that we previously suggested a very strict interpretation of
> > > clearing the _RUNNING bit, but again I'm questioning if that's a real
> > > requirement or simply a nice-to-have feature for some undefined
> > > debugging capability.  In raising the p2p DMA issue, we can see that a
> > > hard stop independent of other devices is not really practical but I
> > > also don't see that introducing a new state bit solves this problem any
> > > more elegantly than proposed here.  Thanks,  
> > 
> > I still disagree with this - the level of 'frozenness' of a device is
> > something that belongs in the defined state exposed to userspace, not
> > as a hidden internal state that userspace can't see.
> > 
> > It makes the state transitions asymmetric between suspend/resume as
> > resume does have a defined uAPI state for each level of frozeness and
> > suspend does not.
> > 
> > With the extra bit resume does:
> >   
> >   0000, 0100, 1000, 0001
> > 
> > And suspend does:
> > 
> >   0001, 1001, 0010, 0000
> > 
> > However, without the extra bit suspend is only
> >   
> >   001,  010, 000
> > 
> > With hidden state inside the 010
> 
> And what is the device supposed to do if it receives a DMA while in
> this strictly defined stopped state?  If it generates an unsupported
> request, that can trigger a fatal platform error.  

I don't see that this question changes anything, we always have a
state where the device is unable to respond to incoming DMA.

In all cases entry to this state is triggered only by user space
action, if userspace does the ioctls in the wrong order then it will
hit it.

> If it silently drops the DMA, then we have data loss.  We're
> defining a catch-22 scenario for drivers versus placing the onus on
> the user to quiesce the set of devices in order to consider the
> migration status as valid.  

The device should error the TLP.

Userspace must globally fence access to the device before it enters
the device into the state where it errors TLPs.

This is also why I don't like it being so transparent as it is
something userspace needs to care about - especially if the HW cannot
support such a thing, if we intend to allow that.

Jason
