Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80E6015D8CD
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 14:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729335AbgBNNwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 08:52:43 -0500
Received: from mail-eopbgr20061.outbound.protection.outlook.com ([40.107.2.61]:19405
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728336AbgBNNwn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 08:52:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L5ZzalYHtNcBgMzZqnD3H86VJr3tmTbKIMo0Xybp+3/buds8XfdHh5BLpiClM87BsfU9Y/rrVeUUCajIYt/MQ0jKpMHpY5LIK+w3/QPFBGdvMOBIYUUDZVl2IMRGURO6aQkVwKfW9eCMzgVnWvsZL/dokDhJGJBbmu1D8ANPVPP48YA5JFtGMdKkZvu/XfzJWebtVNO+ImzI2W5vWAWG41rbWyclRjiWMHfVF8UsAh4etnCLDFE8SNukjkKgmDZutRot3qifd+x25mGudyKRX7YOXIHuMp2hPYNaFk0itWGa0YfUc1nvgpWzrbzze/QCzuGk1L2Gc50O42zYC9eg6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YxpWpz4eowZpMYAuHyuVF5zK2GcnGnMBAfGo76YNdzI=;
 b=EaEjgK6u/3tmcuZHDUlvYx0w6mnnzidptXaNhWLm/IHrMP3DKY6lsAIIP8WcdvZl/a6bX0UZAuJIGyV1mNU1nIx7LhsKeuKJ6SKzfatEyLH48e77VBMFPKaO5oqv6hFGz5lzR1sgRWXryB7MFkN4HYtQTjjtbyhuK83V5/ppWy+9wsIYdszrAMXx086PATHaWo3DKUTVUCG6VgeNxglDewBVx5gakDY5iOCkly+crIBV2f+Oq0AKtzg5cfYjEkVOlDf0BnrdDGJEhUsROgvurIJPbLJND9tu+lGnWrTe83sdhOS94SVgS1wZlswB4qsh44f6obv7c6PenaF821cv4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YxpWpz4eowZpMYAuHyuVF5zK2GcnGnMBAfGo76YNdzI=;
 b=ZcR3nfqYyR9mrJICQHsIF/SuEYX/zZa6iLzmfMWNp5y4MZ1NHcjEow3wFCY8A7esenKOLySty5MxDlCYkhRUW9YD4IjFPf2orhBmiE7jotd1P5369vKqOpS6CHIHyt7FEUorc1AzOm8WKtRpobmz6j+xZYXCXVnXBgmTEkl0g8Q=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (52.133.14.15) by
 VI1PR05MB6621.eurprd05.prod.outlook.com (20.178.204.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.21; Fri, 14 Feb 2020 13:52:36 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d%7]) with mapi id 15.20.2729.025; Fri, 14 Feb 2020
 13:52:36 +0000
Date:   Fri, 14 Feb 2020 09:52:32 -0400
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
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
Message-ID: <20200214135232.GB4271@mellanox.com>
References: <20200210035608.10002-1-jasowang@redhat.com>
 <20200210035608.10002-4-jasowang@redhat.com>
 <20200211134746.GI4271@mellanox.com>
 <cf7abcc9-f8ef-1fe2-248e-9b9028788ade@redhat.com>
 <20200212125108.GS4271@mellanox.com>
 <12775659-1589-39e4-e344-b7a2c792b0f3@redhat.com>
 <20200213134128.GV4271@mellanox.com>
 <ebaea825-5432-65e2-2ab3-720a8c4030e7@redhat.com>
 <20200213150542.GW4271@mellanox.com>
 <8b3e6a9c-8bfd-fb3c-12a8-2d6a3879f1ae@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b3e6a9c-8bfd-fb3c-12a8-2d6a3879f1ae@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MN2PR10CA0026.namprd10.prod.outlook.com
 (2603:10b6:208:120::39) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR10CA0026.namprd10.prod.outlook.com (2603:10b6:208:120::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.26 via Frontend Transport; Fri, 14 Feb 2020 13:52:36 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1j2bOS-0003FV-6X; Fri, 14 Feb 2020 09:52:32 -0400
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6e271afe-f030-4144-f0b2-08d7b15525d1
X-MS-TrafficTypeDiagnostic: VI1PR05MB6621:|VI1PR05MB6621:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6621E34FFFB266C5F7BFC95ACF150@VI1PR05MB6621.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 03137AC81E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39850400004)(346002)(376002)(366004)(189003)(199004)(316002)(4326008)(81166006)(81156014)(8676002)(2906002)(2616005)(186003)(33656002)(66946007)(26005)(8936002)(6916009)(52116002)(86362001)(36756003)(478600001)(1076003)(66556008)(9746002)(9786002)(5660300002)(66476007)(7416002)(24400500001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6621;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JauTHxWt7t7VdWMC57/Psrc9u1RNFT1QksxHxkrOdvVzWC+GhECky+PkB/CQF0KxxyU+9MnodSNUMZhxdRKS0NOwiyBZzZRKC3CjcVRgp7p4sNf34V7rSuc0pFghUeE5UhtKyT5J4wEUEcvb+u6ZvGYcx1M1WAEL9lTQ2gmNKXD+WYjmaQ7y3c/IXWFzk5cuNdG7Wcc3NJEwjUcZaEQ8zpLXawZfOURh4g6A8b9gfVwkHHdJVqkI+bY/M424bZMvFMnzw+EzRzc7Y/ATAoWKF1bkk+oerRk/svaaC2Fa6h9psE3KlMvAkXDBjfAEe2zjn840XOWpJrcP5ZU05EB4QKE7nuGhfAL+77Sc7F0KeCjKVmruumdwuFO1N9It7ryFo6eMP4As2CS4/kbsEe8EPyipVNsHshWDazF0oRAHgCiSRtah32F1TWJVXiu1XaNREaEKDwSYpDBHCw6K6KyNNce430XL23FPGDbHIQG+QQ9sQzIDRzKIHlLgedIw3DZI
X-MS-Exchange-AntiSpam-MessageData: DFWHp3xgtS72ySJlgdo/TcKbYn6hmg95vo+5OZ35Db+J2RTdaRsvchI/PcKWiHvEwstSBxsBof8dAi1C11LME1DIPr0gO9rMhXcclCbNInVTtLsC+HPBuIQ2IAxSDa1C1bQ5CkQXgGUwowdLs4IqHw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e271afe-f030-4144-f0b2-08d7b15525d1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2020 13:52:36.3715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CuqEAMdz4DD+aUr6MoSXqk3kHyIhl7o/MHhq+oRLqZS45AHa0H3vvnLP9AaqnOXjXKTpeiH3nQDjSKL1CvxDEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6621
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 14, 2020 at 11:23:27AM +0800, Jason Wang wrote:

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
> > Here we are talking about the /dev/XX node that provides the
> > programming interface.
> 
> 
> I'm confused here, are you suggesting to use class to create char device in
> vhost-vdpa? That's fine but the comment should go for vhost-vdpa patch.

Certainly yes, something creating many char devs should have a
class. That makes the sysfs work as expected

I suppose this is vhost user? I admit I don't really see how this
vhost stuff works, all I see are global misc devices? Very unusual for
a new subsystem to be using global misc devices..

I would have expected that a single VDPA device comes out as a single
char dev linked to only that VDPA device.

> > All the vdpa devices have the same basic
> > chardev interface and discover any semantic variations 'in band'
> 
> That's not true, char interface is only used for vhost. Kernel virtio driver
> does not need char dev but a device on the virtio bus.

Okay, this is fine, but why do you need two busses to accomplish this?

Shouldn't the 'struct virito_device' be the plug in point for HW
drivers I was talking about - and from there a vhost-user can connect
to the struct virtio_device to give it a char dev or a kernel driver
can connect to link it to another subsystem?

It is easy to see something is going wrong with this design because
the drivers/virtio/virtio_vdpa.c mainly contains a bunch of trampoline
functions reflecting identical calls from one ops struct to a
different ops struct. This suggests the 'vdpa' is some subclass of
'virtio' and it is possibly better to model it by extending 'struct
virito_device' to include the vdpa specific stuff.

Where does the vhost-user char dev get invovled in with the v2 series?
Is that included?

> > Every class of virtio traffic is going to need a special HW driver to
> > enable VDPA, that special driver can create the correct vhost side
> > class device.
> 
> Are you saying, e.g it's the charge of IFCVF driver to create vhost char dev
> and other stuffs?

No.

Jason
