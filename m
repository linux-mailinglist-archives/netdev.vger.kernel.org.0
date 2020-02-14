Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 939B115D8F1
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 15:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387434AbgBNOE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 09:04:57 -0500
Received: from mail-eopbgr00074.outbound.protection.outlook.com ([40.107.0.74]:38275
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726191AbgBNOE4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 09:04:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i0pMDtLBPrI9DC47M7THOEaKRqQiUnwStk0X/FeJ8yZ1/dqcKT4tR/Hn403VMTKql/aHeMAbKDFZYtdIGs9BerNWityTorXjL+5OVxnjWLnhMjFFP3zeKlTrC5xQmZ8LrUGF99+I9aM4KxpAMk9X6ihEcm3MrxVcNUcCmnRRbZCOIgvOfS8q7tWn723qOorGONrEYDNl1l7qF3GOwEuxMAGf/tWr8V8nFJBSr3vLuNQPYOvVX0nbB3N7Skq1954awoxHXTa4emzS/Er96EA/+tmYBD5/1mvSubOlg4A9BZEYb/9KYklaioowfXfftPJhKXYoC9vRIrzzAMK1yUrtmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QCXeQN9UBfJaHleubs4Gqrirjj0nzTtb/7eL1LxX6mE=;
 b=TlE+wlwrfue5IPqguFNxLGz0gJdMOc+4T2PLB1GEbdIvAAS5v8n0wWeUqD4yfdxgpPkkm6zRr3jJFJbhkf0da/G4nFpelSPS+Awq+iOQSKkAk+ZIE+COd1eWPBfSm5Vh5UeNng37x0MiFheqx3AvLKgpoFtvO0bKO+fagNMMSymiYR5p22NoMBJzcoSuLB2+TXZeVgDVtKlti1x8La38L46KMioPmXuVn4fApQcj048jHyFMdV8b/WR7s9MkoBP4y2cqRQigop4qpReqGczkvd3Dh/yCcSBZb9QX0F8bJYTYp4Qx1nMNXTYO64NgA6sCGZyIIW5LL4pACE8yBE0tMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QCXeQN9UBfJaHleubs4Gqrirjj0nzTtb/7eL1LxX6mE=;
 b=VhdjAgPCgtuvOkuK/Yo+QxQ02AEBkVp5LRGXi5Zg5Ld4YQtAby7ZNFYk4slDiJI++gN8HbWWVoK00zlbsGAsB77c+GOv50MFVFoHe/iTymlVStyytBmdrpG1iob8iP245qM2RcQiIOpmYVZsjF+eN+6jWBsoWe+7mJrhVgtU73Q=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (52.133.14.15) by
 VI1PR05MB6383.eurprd05.prod.outlook.com (20.179.25.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Fri, 14 Feb 2020 14:04:49 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d%7]) with mapi id 15.20.2729.025; Fri, 14 Feb 2020
 14:04:49 +0000
Date:   Fri, 14 Feb 2020 10:04:46 -0400
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        tiwei.bie@intel.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        kevin.tian@intel.com, stefanha@redhat.com, rdunlap@infradead.org,
        hch@infradead.org, aadam@redhat.com, jiri@mellanox.com,
        shahafs@mellanox.com, hanand@xilinx.com, mhabets@solarflare.com
Subject: Re: [PATCH V2 3/5] vDPA: introduce vDPA bus
Message-ID: <20200214140446.GD4271@mellanox.com>
References: <20200212125108.GS4271@mellanox.com>
 <12775659-1589-39e4-e344-b7a2c792b0f3@redhat.com>
 <20200213134128.GV4271@mellanox.com>
 <ebaea825-5432-65e2-2ab3-720a8c4030e7@redhat.com>
 <20200213150542.GW4271@mellanox.com>
 <20200213103714-mutt-send-email-mst@kernel.org>
 <20200213155154.GX4271@mellanox.com>
 <20200213105425-mutt-send-email-mst@kernel.org>
 <20200213162407.GZ4271@mellanox.com>
 <5625f971-0455-6463-2c0a-cbca6a1f8271@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5625f971-0455-6463-2c0a-cbca6a1f8271@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MN2PR05CA0054.namprd05.prod.outlook.com
 (2603:10b6:208:236::23) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR05CA0054.namprd05.prod.outlook.com (2603:10b6:208:236::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.16 via Frontend Transport; Fri, 14 Feb 2020 14:04:49 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1j2baI-0003O8-Co; Fri, 14 Feb 2020 10:04:46 -0400
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ee6bf460-08e1-4a4d-c9d4-08d7b156dab0
X-MS-TrafficTypeDiagnostic: VI1PR05MB6383:|VI1PR05MB6383:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6383F42679A87E141C9233E2CF150@VI1PR05MB6383.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03137AC81E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(376002)(346002)(396003)(366004)(136003)(199004)(189003)(81156014)(8676002)(36756003)(81166006)(7416002)(9786002)(9746002)(52116002)(1076003)(8936002)(2616005)(4326008)(66556008)(66476007)(66946007)(86362001)(478600001)(186003)(33656002)(5660300002)(316002)(2906002)(6916009)(26005)(21314003)(24400500001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6383;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cJ9+JySpWJlUar2SxEoDedM+39ExJs/ZZtEY7Pn5GSZbmynuYFgJ99aOOO5ZAQmFafgxgXV4S40wTduGg+/+27SBF9h7c12zUzE8UOUNWG7PXhjPMXcR6SJPDg6xmDYJhNJ9DvhIXTUEAjb5InkVaPphx1bOJUf8HAtK8wqGhGnsQqJzz6XXssyo0BVzbAXxGOFvPEAJEWb8wU0Ftp7BCNdRRo2Zs/+jysKzUDZ3mxyrzPIdk6Mf/rLkt+cLCrjDPurbBu/Od5z+HgRQeul4zb6WlTxls9B2uANAfmy7YaNIvfh1MQ0Yqo4N3PviyRrdN9rAhElogVghgQO/a3FWOtegNUWBFK1fmghrlPTgRnaiggc3o4tA4vuBaHa0bInBcP/7acPDQSxJMzWw8+PPw+JVNJ6doErVi33TpQT/HHnCfld5zs2t6pm0E9LraHZQbmKa3jaCIwa1vv6aeespAwuLjWzstdzdi3xDANhyh9GcFuTqqWWMzIiIXOBirh0ptT140gI09nHHLUQstxrcIQ==
X-MS-Exchange-AntiSpam-MessageData: GPnSDgFwapwTtSZdA8VOoAcYFFi/9y0eqxe5rQsIOvPsK8H/onipS3lUd4rhrN7XtwiyGFLS+j/6btmiZTxFMI+qYvkp4opoQTm8aOzF+Kfb+thRUGnBhsqA7XyFB/19/5g/FM+P9AZjfqAG/bzQfg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee6bf460-08e1-4a4d-c9d4-08d7b156dab0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2020 14:04:49.2066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /0vY7Z+de9Cn/ZbV2YQRpJIxWtTGqVP5PVcK7qdXD/UtzSFjfc7V/vhF/jZ+KIWagIbkXxVksR2zCe5AYG/QAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6383
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 14, 2020 at 12:05:32PM +0800, Jason Wang wrote:

> > The standard driver model is a 'bus' driver provides the HW access
> > (think PCI level things), and a 'hw driver' attaches to the bus
> > device,
> 
> This is not true, kernel had already had plenty virtual bus where virtual
> devices and drivers could be attached, besides mdev and virtio, you can see
> vop, rpmsg, visorbus etc.

Sure, but those are not connecting HW into the kernel..
 
> > and instantiates a 'subsystem device' (think netdev, rdma,
> > etc) using some per-subsystem XXX_register().
> 
> 
> Well, if you go through virtio spec, we support ~20 types of different
> devices. Classes like netdev and rdma are correct since they have a clear
> set of semantics their own. But grouping network and scsi into a single
> class looks wrong, that's the work of a virtual bus.

rdma also has about 20 different types of things it supports on top of
the generic ib_device.

The central point in RDMA is the 'struct ib_device' which is a device
class. You can discover all RDMA devices by looking in /sys/class/infiniband/

It has an internal bus like thing (which probably should have been an
actual bus, but this was done 15 years ago) which allows other
subsystems to have drivers to match and bind their own drivers to the
struct ib_device.

So you'd have a chain like:

struct pci_device -> struct ib_device -> [ib client bus thing] -> struct net_device

And the various char devs are created by clients connecting to the
ib_device and creating char devs on their own classes.

Since ib_devices are multi-queue we can have all 20 devices running
concurrently and there are various schemes to manage when the various
things are created.

> > The 'hw driver' pulls in
> > functions from the 'subsystem' using a combination of callbacks and
> > library-style calls so there is no code duplication.
> 
> The point is we want vDPA devices to be used by different subsystems, not
> only vhost, but also netdev, blk, crypto (every subsystem that can use
> virtio devices). That's why we introduce vDPA bus and introduce different
> drivers on top.

See the other mail, it seems struct virtio_device serves this purpose
already, confused why a struct vdpa_device and another bus is being
introduced

> There're several examples that a bus is needed on top.
> 
> A good example is Mellanox TmFIFO driver which is a platform device driver
> but register itself as a virtio device in order to be used by virito-console
> driver on the virtio bus.

How is that another bus? The platform bus is the HW bus, the TmFIFO is
the HW driver, and virtio_device is the subsystem.

This seems reasonable/normal so far..

> But it's a pity that the device can not be used by userspace driver due to
> the limitation of virito bus which is designed for kernel driver. That's why
> vDPA bus is introduced which abstract the common requirements of both kernel
> and userspace drivers which allow the a single HW driver to be used by
> kernel drivers (and the subsystems on top) and userspace drivers.

Ah! Maybe this is the source of all this strangeness - the userspace
driver is something parallel to the struct virtio_device instead of
being a consumer of it?? That certianly would mess up the driver model
quite a lot.

Then you want to add another bus to switch between vhost and struct
virtio_device? But only for vdpa?

But as you point out something like TmFIFO is left hanging. Seems like
the wrong abstraction point..

Jason
