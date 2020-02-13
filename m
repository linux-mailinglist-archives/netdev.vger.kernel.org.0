Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D639F15C4F1
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 16:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388042AbgBMPwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 10:52:05 -0500
Received: from mail-am6eur05on2089.outbound.protection.outlook.com ([40.107.22.89]:52160
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387553AbgBMPwD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Feb 2020 10:52:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WwKGxwjq2mdjBmhyCT+b6zakkOCkomtfy3Y/uM2DBTS3ioL9I5yW4dvNkm/VUJ6PGT/bvbly2WhsM4ieMy9ZSz+PpSMEcT9zb6i9PcOGcN+EPH85rqD4U92dg3+Qvr0f0MAMaCl7Yfw/zI35T/ebslXJ/b7i9i0iILmL7CVJdjo3s41Kk0oq2mFit8mjpYxZoYQ47BxGSsp56gsxcJ23t/nYJYSzyOboeQOkt6KNsCpY6u6WyIQcunjMsvBGdgiPdLJ5rsovpf8uwxOlNWcjHZfKOod1dCpKw1KowCqeIcEtpQGUk/r4GRvFT2RIQqgVGiydNXZg39gBxYShIUi9PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=//KczrXwWXzK/7f9S1HusaFzzirPOtrPtbT6BJ3ZVP8=;
 b=KcK0k92se9Kg9mX5BrF7jnmdJqkGlnI0nbU6GjFZFyohRwzoJL4wF8MCsm1UfdWQifzy53664zr8AEXcPe4gJXstzX46l4HCM5jCwbv4INv7k4XxD/janNX9aH/4YqcCe4eSq+NOLwXo/jcWM36zuWBngN7LN1xMP9Hq/G+RvSXyXTapPsJasR7lXzTnNnWkGcCzbgl4uewc45YOJf3fDNUTS6Qt/p0d8RG+CziT5cUAXNA4awpQrvZRUiBYw1461JieuJD1RazOfCpwyI3e7HSsBzIaVLAo6ZJkbYxPpx2TstCcFOtNOwFFi3DEjY2gGOlGlUIkeoRR+OljIQdGgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=//KczrXwWXzK/7f9S1HusaFzzirPOtrPtbT6BJ3ZVP8=;
 b=s740qDprh5u7bKpsTMgKULs9Gj6fu2FR0mzaCdJc1xewYjjo9VKmO6Xp6mQuRTyZ0Vrjq/0HMcO4uR/mqbyu0efhivnl49OdDc4OIIVjfMHUgjVXUT6yJgPX0UytWKUqLpIGkwWZCgwAe4M5dJqW1kzFmBTFun3wYDX04IPd1os=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (52.133.14.15) by
 VI1PR05MB3278.eurprd05.prod.outlook.com (10.170.239.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Thu, 13 Feb 2020 15:51:59 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d%7]) with mapi id 15.20.2729.025; Thu, 13 Feb 2020
 15:51:58 +0000
Date:   Thu, 13 Feb 2020 11:51:54 -0400
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, tiwei.bie@intel.com,
        maxime.coquelin@redhat.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, rob.miller@broadcom.com,
        xiao.w.wang@intel.com, haotian.wang@sifive.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, lulu@redhat.com,
        parav@mellanox.com, kevin.tian@intel.com, stefanha@redhat.com,
        rdunlap@infradead.org, hch@infradead.org, aadam@redhat.com,
        jiri@mellanox.com, shahafs@mellanox.com, hanand@xilinx.com,
        mhabets@solarflare.com
Subject: Re: [PATCH V2 3/5] vDPA: introduce vDPA bus
Message-ID: <20200213155154.GX4271@mellanox.com>
References: <20200210035608.10002-1-jasowang@redhat.com>
 <20200210035608.10002-4-jasowang@redhat.com>
 <20200211134746.GI4271@mellanox.com>
 <cf7abcc9-f8ef-1fe2-248e-9b9028788ade@redhat.com>
 <20200212125108.GS4271@mellanox.com>
 <12775659-1589-39e4-e344-b7a2c792b0f3@redhat.com>
 <20200213134128.GV4271@mellanox.com>
 <ebaea825-5432-65e2-2ab3-720a8c4030e7@redhat.com>
 <20200213150542.GW4271@mellanox.com>
 <20200213103714-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200213103714-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MN2PR15CA0020.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::33) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR15CA0020.namprd15.prod.outlook.com (2603:10b6:208:1b4::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.23 via Frontend Transport; Thu, 13 Feb 2020 15:51:58 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1j2GmQ-0005eB-SB; Thu, 13 Feb 2020 11:51:54 -0400
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1f81508b-e3b9-41c0-6e98-08d7b09ca87a
X-MS-TrafficTypeDiagnostic: VI1PR05MB3278:|VI1PR05MB3278:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB327810783AA414DF6A22D69ACF1A0@VI1PR05MB3278.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 031257FE13
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(376002)(136003)(39860400002)(396003)(199004)(189003)(7416002)(1076003)(9786002)(4326008)(2616005)(9746002)(36756003)(478600001)(86362001)(33656002)(66476007)(81156014)(8936002)(52116002)(8676002)(26005)(66946007)(316002)(81166006)(5660300002)(186003)(66556008)(2906002)(6916009)(24400500001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3278;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VDrOmCQPbhG6OMaA30BTqTP/4l7SRhA4OM9iPTfxKcaIo6L77coKcFcOgoBUXpDN+Lc8MQOA2aM11/T4vlfTb36xiLOuy/CdzBR0oFwIkL+IvkYRuqqZpeFZd8z8LvbjSmafLwchhzoaNisejZQCDTwRH5M3HarbDxwOrHR1yJuypZXz9BCEyovOZXrR9kD47m9sn44s+1XZePHPGEZd8YpEP0jKcUv9uCO6d8CHWTYxVHR1x7zDgaUTEbyj0wN1kgbNkKc9Ikjf50viyA/Zk3OlOmu5mFNWkHaUnBUzgLqrbpA62VBTovzUXRkCmBCA4PlYYSj5XRqVD0DPmELKjIRIy/4h9FC2Il11QTIehfViRQS9gYMWHdRepRSHabS+vllAlEKTQcrqE4z96x1nRaNvT/DXbholOGH2yHA74G2g2fI38a4SZ8Pcl79s0xYRRZOYqYq78dmiBXuKpG/SvE68a87N68RkTwnP8/IGEH0KNT68Rc5DI3BEijMnbwni
X-MS-Exchange-AntiSpam-MessageData: Qh++IUh2Ir+bpDxJTgnzfj+6h+Ord0RqJxQLFngvzxjrnAuzqjXJPbo+F9UBsZafY5hSfeZ3n+Bm+4+dnA99yjdNqtFKGOAAkdSRHnbVHiv0H+BnaPWsJD/RtGS+GrDC9klDfAaxGrbxsj/tw2k5Sg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f81508b-e3b9-41c0-6e98-08d7b09ca87a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2020 15:51:58.5916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tDA8g3Wn8CQpdW0mHz1caFOR6pJjN6jMUZXPolgv0Bf0JxHqdm3bAf6WLAxqS/rEe8FEZrPuoNPt9lmO+jYh+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3278
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 13, 2020 at 10:41:06AM -0500, Michael S. Tsirkin wrote:
> On Thu, Feb 13, 2020 at 11:05:42AM -0400, Jason Gunthorpe wrote:
> > On Thu, Feb 13, 2020 at 10:58:44PM +0800, Jason Wang wrote:
> > > 
> > > On 2020/2/13 下午9:41, Jason Gunthorpe wrote:
> > > > On Thu, Feb 13, 2020 at 11:34:10AM +0800, Jason Wang wrote:
> > > > 
> > > > > >    You have dev, type or
> > > > > > class to choose from. Type is rarely used and doesn't seem to be used
> > > > > > by vdpa, so class seems the right choice
> > > > > > 
> > > > > > Jason
> > > > > Yes, but my understanding is class and bus are mutually exclusive. So we
> > > > > can't add a class to a device which is already attached on a bus.
> > > > While I suppose there are variations, typically 'class' devices are
> > > > user facing things and 'bus' devices are internal facing (ie like a
> > > > PCI device)
> > > 
> > > 
> > > Though all vDPA devices have the same programming interface, but the
> > > semantic is different. So it looks to me that use bus complies what
> > > class.rst said:
> > > 
> > > "
> > > 
> > > Each device class defines a set of semantics and a programming interface
> > > that devices of that class adhere to. Device drivers are the
> > > implementation of that programming interface for a particular device on
> > > a particular bus.
> > > 
> > > "
> > 
> > Here we are talking about the /dev/XX node that provides the
> > programming interface. All the vdpa devices have the same basic
> > chardev interface and discover any semantic variations 'in band'
> > 
> > > > So why is this using a bus? VDPA is a user facing object, so the
> > > > driver should create a class vhost_vdpa device directly, and that
> > > > driver should live in the drivers/vhost/ directory.
> > >  
> > > This is because we want vDPA to be generic for being used by different
> > > drivers which is not limited to vhost-vdpa. E.g in this series, it allows
> > > vDPA to be used by kernel virtio drivers. And in the future, we will
> > > probably introduce more drivers in the future.
> > 
> > I don't see how that connects with using a bus.
> > 
> > Every class of virtio traffic is going to need a special HW driver to
> > enable VDPA, that special driver can create the correct vhost side
> > class device.
> 
> That's just a ton of useless code duplication, and a good chance
> to have minor variations in implementations confusing
> userspace.

What? Why? This is how almost every user of the driver core works.

I don't see how you get any duplication unless the subsystem core is
badly done wrong.

The 'class' is supposed to provide all the library functions to remove
this duplication. Instead of plugging the HW driver in via some bus
scheme every subsystem has its own 'ops' that the HW driver provides
to the subsystem's class via subsystem_register()

This is the *standard* pattern to use the driver core.

This is almost there, it just has this extra bus part to convey the HW
ops instead of directly.

> Instead, each device implement the same interface, and then
> vhost sits on top.

Sure, but plugging in via ops/etc not via a bus and another struct
device.

> That bus is exactly what Greg KH proposed. There are other ways
> to solve this I guess but this bikeshedding is getting tiring.

This discussion was for a different goal, IMHO.

> Come on it's an internal kernel interface, if we feel
> it was a wrong direction to take we can change our minds later.
> Main thing is getting UAPI right.

This discussion started because the refcounting has been busted up in
every version posted so far. It is not bikeshedding when these bugs
are actually being caused by trying to abuse the driver core and
shoehorn in a bus that isn't needed when a class is the correct thing
to use.

Jason
