Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D67BD21A6BF
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 20:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgGISUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 14:20:32 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:50172 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726339AbgGISUb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 14:20:31 -0400
Received: from hkpgpgate102.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f075fec0000>; Fri, 10 Jul 2020 02:20:28 +0800
Received: from HKMAIL102.nvidia.com ([10.18.16.11])
  by hkpgpgate102.nvidia.com (PGP Universal service);
  Thu, 09 Jul 2020 11:20:28 -0700
X-PGP-Universal: processed;
        by hkpgpgate102.nvidia.com on Thu, 09 Jul 2020 11:20:28 -0700
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 9 Jul
 2020 18:20:16 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 9 Jul 2020 18:20:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N7cRZP44iX1XXoBdyIBvFGV/PIjVLtqYeNtCWzcsZZ3AXj5tEi1LUTMRBh3OU5D92apcoOrSa60+V/1l/KRUkRUheqdeBXkwIrEUtebqApmglB1wpRIGJgtQt6gtTRJ3nbjzWRdRrK9X2KDTWTrSyQEH67nZVR60gtp4StrNRnv+QQQCBgamjqHeOVj13iQ4TUZIYmixykcvUIQ7r2soQ+8e7WuSjo3ZeQ1IUE8IAEhKIyV7XzDGQLMqbQs/xVr1Y/Bg+wBlQy7BIZPFXuyS7Vvrtf3YlzT0w7wrAxHyOgmUltT6e4Uz1Hj7Gj1osbNuyzk7U/UaS0GLj1+ylzm+mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fyi5WgZDciPhRvvoq0S8IcRaOXLDk2CONOM9w7CGG2o=;
 b=DKLXMFC6LWH7Id1yC6BWVEst+0oayH35o2zbxq+zGZcsL2/yyqYfWWlYyJrAjm8/K3QRCxVa4CyTnRi/9eSPtIhf2b4kIuqxdk4X7SxBe3+t7rL/g3CenfSGqiFm5Mf0KKFSjv6/GCjkMMD4hXAowIY90B7Bb0CzCVXkJ2w+k1LCpy4FOezesYmS0hiGwwpQpY4z/vIIrOXjxsZLQCtVfXLn7Qc2qXxEF3R8LWFMOfmtgFh0my4+ZHYlYqaPxqmurUKr7Gvao6oAeOwLfu1ZXK2WCk+fayCuuJPA94sJESteFwWZjfcs9ntm5pjbrf04W1EhL/S1mJHy/bw6/j4Czw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4011.namprd12.prod.outlook.com (2603:10b6:5:1c5::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Thu, 9 Jul
 2020 18:20:13 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1d53:7cb4:c3d7:2b54]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1d53:7cb4:c3d7:2b54%6]) with mapi id 15.20.3174.022; Thu, 9 Jul 2020
 18:20:13 +0000
Date:   Thu, 9 Jul 2020 15:20:11 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
CC:     Bjorn Helgaas <helgaas@kernel.org>, Aya Levin <ayal@mellanox.com>,
        "David Miller" <davem@davemloft.net>, <kuba@kernel.org>,
        <saeedm@mellanox.com>, <mkubecek@suse.cz>,
        <linux-pci@vger.kernel.org>, <netdev@vger.kernel.org>,
        <tariqt@mellanox.com>, <alexander.h.duyck@linux.intel.com>
Subject: Re: [net-next 10/10] net/mlx5e: Add support for PCI relaxed ordering
Message-ID: <20200709182011.GQ23676@nvidia.com>
References: <0506f0aa-f35e-09c7-5ba0-b74cd9eb1384@mellanox.com>
 <20200708231630.GA472767@bjorn-Precision-5520>
 <20200708232602.GO23676@nvidia.com>
 <20200709173550.skza6igm72xrkw4w@bsd-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200709173550.skza6igm72xrkw4w@bsd-mbp.dhcp.thefacebook.com>
X-ClientProxiedBy: MN2PR19CA0063.namprd19.prod.outlook.com
 (2603:10b6:208:19b::40) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR19CA0063.namprd19.prod.outlook.com (2603:10b6:208:19b::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Thu, 9 Jul 2020 18:20:12 +0000
Received: from jgg by mlx with local (Exim 4.93)        (envelope-from <jgg@nvidia.com>)        id 1jtb9X-007kGx-Rd; Thu, 09 Jul 2020 15:20:11 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99a36376-adaf-42f7-2dbd-08d82434b8ac
X-MS-TrafficTypeDiagnostic: DM6PR12MB4011:
X-Microsoft-Antispam-PRVS: <DM6PR12MB401118063609F7A98C5353C3C2640@DM6PR12MB4011.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ur69XRikPkQu7dTuOzgClIiRXNFTRTzUDXBCxH8Dz/UDstafGtiZ6OIN33d1ICaR3FifmtnVNqo4ZF/fLzJzP0t1S5lrM4wIM/qScBeXSDOhQaIAj3gOuiMbqDJnyJ995y7RxA/xT4azJSVstrOMlpbi+h0Y9NG/hww3yXjFIjBSv6wPeCznOGnWIQIQI/X7rNo46DsDMlGSMnuLRijOgJoFJHrQoQ5qeqdtMDsF/SZKyfdVpQQAQgDT4Ka0zXLjIfphFemUVyXt7i83cgWwttgtkWZnVa/esdxHqE1x93X9d8wQbIz+Gv0Ivnq5LLT2+vqmfgMY/H8Vo2xNcGRQhA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(39860400002)(346002)(136003)(396003)(7416002)(4326008)(54906003)(26005)(186003)(6916009)(2906002)(478600001)(5660300002)(8936002)(1076003)(2616005)(8676002)(426003)(66476007)(66556008)(66946007)(83380400001)(9746002)(86362001)(9786002)(316002)(33656002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: guB6y/+MoS/Hn08gg91IP+oTPR98JGi8JWNKmTjMhDKoN9GZm8ggvFn/ImkeHi5uxYWZsOYXkstDC9z0J74+PeOVkHwZ2jJTh+yTYzQC7RXzpIt+rzW63QgOy3leRvdtV/49DlA+wqosqYzeXsCahvY77RlpboHM3ZDVtIUlIM2BZoxv25UYKOe/CumIKwAPpqeIeQDUWOa5VFjRllf8xcMnRPxri8u6lrIfDv+BF+EMth8WWdJh3y767hisXBDZxf4knTg7TTgTDVToLofykqPKp7NDaD3OAyfBisbOe4yfX7da9/fRkShDqHIsrNndDdIJdLrMYdqGgac8yuCN09xwqgF0FHNlLAw/6m4psQgpEWdlu71o99PEQqtwFs+fVJdJ8UByUOEIctw3LVUe7/af6OKRqQkpZJ4kT+EpGH82zPbECc5SJyFBiOLpgyBq15EdXcJlAJtQV2TzY87X6uEp6f2Ngi5NBKVkBFmV+XQ=
X-MS-Exchange-CrossTenant-Network-Message-Id: 99a36376-adaf-42f7-2dbd-08d82434b8ac
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2020 18:20:12.9335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vS+18kMWdmmQop/xY0ExqyYaf59DB5e0va42Z0PyUGpAPy4Wy6aEV9Sq/pfftAEF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4011
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1594318828; bh=fyi5WgZDciPhRvvoq0S8IcRaOXLDk2CONOM9w7CGG2o=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:Authentication-Results:Date:From:To:CC:
         Subject:Message-ID:References:Content-Type:Content-Disposition:
         In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Originating-IP:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-Microsoft-Antispam-PRVS:
         X-MS-Oob-TLC-OOBClassifiers:X-MS-Exchange-SenderADCheck:
         X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
         X-Forefront-Antispam-Report:X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=d7U49CfAaumhPypKV0kwzDqb/tbyUgYuBR9SYUUJEzpQOrnhuD8piomGfnbo5cSIb
         kU7SgCQnVacn1h3Y5VqQyrS7Bkd01LZcEd4Mfm+ik+8GFq0lcYiK8WSWjiIz988yHw
         U3zE4pfYNZuzCNJeeYg3+lsVy7iNRJWk/MWuHC1h5uLNIgUIx7j2pZ5UK8fn/hk6vL
         e2I1rBeNVAm7c2H9TTz9AqgIaKFxL8jrt68v/X4wv4vGKzZKUtBX6ZXRHtfT8u6j/l
         mSO3miaTw0HRTujM6kAZa6lQASiqGn9bRl+PPz2MI7NK9mDkyspYYLGOo9AkGl/W1x
         DHTlU/9O9OPcw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 09, 2020 at 10:35:50AM -0700, Jonathan Lemon wrote:
> On Wed, Jul 08, 2020 at 08:26:02PM -0300, Jason Gunthorpe wrote:
> > On Wed, Jul 08, 2020 at 06:16:30PM -0500, Bjorn Helgaas wrote:
> > >     I suspect there may be device-specific controls, too, because [1]
> > >     claims to enable/disable Relaxed Ordering but doesn't touch the
> > >     PCIe Device Control register.  Device-specific controls are
> > >     certainly allowed, but of course it would be up to the driver, and
> > >     the device cannot generate TLPs with Relaxed Ordering unless the
> > >     architected PCIe Enable Relaxed Ordering bit is *also* set.
> > 
> > Yes, at least on RDMA relaxed ordering can be set on a per transaction
> > basis and is something userspace can choose to use or not at a fine
> > granularity. This is because we have to support historical
> > applications that make assumptions that data arrives in certain
> > orders.
> > 
> > I've been thinking of doing the same as this patch but for RDMA kernel
> > ULPs and just globally turn it on if the PCI CAP is enabled as none of
> > our in-kernel uses have the legacy data ordering problem.
> 
> If I'm following this correctly - there are two different controls being
> discussed here:
> 
>     1) having the driver request PCI relaxed ordering, which may or may
>        not be granted, based on other system settings, and

This is what Bjorn was thinking about, yes, it is some PCI layer
function to control the global config space bit.

>     2) having the driver set RO on the transactions it initiates, which
>        are honored iff the PCI bit is set.
>
> It seems that in addition to the PCI core changes, there still is a need
> for driver controls?  Unless the driver always enables RO if it's capable?

I think the PCI spec imagined that when the config space RO bit was
enabled the PCI device would just start using RO packets, in an
appropriate and device specific way.

So the fine grained control in #2 is something done extra by some
devices.

IMHO if the driver knows it is functionally correct with RO then it
should enable it fully on the device when the config space bit is set.

I'm not sure there is a reason to allow users to finely tune RO, at
least I haven't heard of cases where RO is a degredation depending on
workload.

If some platform doesn't work when RO is turned on then it should be
globally black listed like is already done in some cases.

If the devices has bugs and uses RO wrong, or the driver has bugs and
is only stable with !RO and Intel, then the driver shouldn't turn it
on at all.

In all of these cases it is not a user tunable.

Development and testing reasons, like 'is my crash from a RO bug?' to
tune should be met by the device global setpci, I think.

Jason
