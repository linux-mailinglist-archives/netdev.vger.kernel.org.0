Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8A9115C829
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 17:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbgBMQYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 11:24:19 -0500
Received: from mail-eopbgr70048.outbound.protection.outlook.com ([40.107.7.48]:4759
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727795AbgBMQYS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Feb 2020 11:24:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X3OVgbsP656Cdir35iHwMcnE0GhibdjMsP0BwYQDIzkabSWGzTskSTIvz2x8seZohwQI5xdmiKLz/dTo6tRu5dJVx76DWXHR+EC18s3p+Kjv0za0TIcc3Bp6HtkJozLFmolzA2abk5l6v200hWdFW5hL5lDFC7BakBFD2raXNhzB75RihtaakZ+DURbb7/0f//IXJhKQcYszmxyKWauTYUJrpXtAvOLymtSnZRjvZmueGsIfPeqSPFbJjoCNNWN/5Ck/PIBm2GfPbWgqkimO3wAg1tvH5q6Z4jploG8NU+RmtVKqYl0ZvCgPe7fR47fXE1PwnNEWHOFILcYHe8pgZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UwkTbhWg25wSF3E2JzX74PIg7XsDDH7p6QkLUIgvGqg=;
 b=fbi66ZDOetBezXkWAWb6SVwzL1V21g/GoLEGeXNNSiO7I6EoLUnmYKNsatdcduFpZW5gxFrcAT4gZJs68MfltYuYEJyLGl0E3YXe5/qwkALoxT9tOtCprRgxSsR8smP9G/YvAmvzmOO9E2vSESw+sJjHw1F2+EX74s5jK4audxVWkRFF7O4vRj8D+gL2fCJa+Rg3zPh7j9feGDOTRyTsLRNSX1aYJ78WpWAC1DnIhibIKx9ySGXitHl4p2OOObMv6dhr/rNx55Rf6hmo9k1XIZ2+e5KPw1Nae6czRzRaRs+pGqk1on44QMlAJGn5j/l42m96yiS9J/TtjTaEDJ0Aiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UwkTbhWg25wSF3E2JzX74PIg7XsDDH7p6QkLUIgvGqg=;
 b=lxCBhiMD9xLYWQCXrrzeXTDNLe++0mt+wliNq7QVjHdpkP7QIxXc9puY5SfwOQp7hoTvlEMV9F1GyVF7WMVgJ0dYkG9iZ+rLuYLxO85UbKJ/KTOlRrlHGjDgZFLIPK2x/MG0G/ILuQVFir0g2Q8XfNGpIzCHukkzqP5UlTMfDC0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (52.133.14.15) by
 VI1PR05MB3405.eurprd05.prod.outlook.com (10.175.243.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.23; Thu, 13 Feb 2020 16:24:11 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d%7]) with mapi id 15.20.2729.025; Thu, 13 Feb 2020
 16:24:11 +0000
Date:   Thu, 13 Feb 2020 12:24:07 -0400
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
Message-ID: <20200213162407.GZ4271@mellanox.com>
References: <20200211134746.GI4271@mellanox.com>
 <cf7abcc9-f8ef-1fe2-248e-9b9028788ade@redhat.com>
 <20200212125108.GS4271@mellanox.com>
 <12775659-1589-39e4-e344-b7a2c792b0f3@redhat.com>
 <20200213134128.GV4271@mellanox.com>
 <ebaea825-5432-65e2-2ab3-720a8c4030e7@redhat.com>
 <20200213150542.GW4271@mellanox.com>
 <20200213103714-mutt-send-email-mst@kernel.org>
 <20200213155154.GX4271@mellanox.com>
 <20200213105425-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200213105425-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: BL0PR02CA0017.namprd02.prod.outlook.com
 (2603:10b6:207:3c::30) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.68.57.212) by BL0PR02CA0017.namprd02.prod.outlook.com (2603:10b6:207:3c::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.23 via Frontend Transport; Thu, 13 Feb 2020 16:24:10 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1j2HHb-0000BN-W0; Thu, 13 Feb 2020 12:24:07 -0400
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cfff4a3f-27f9-4837-7c72-08d7b0a12862
X-MS-TrafficTypeDiagnostic: VI1PR05MB3405:|VI1PR05MB3405:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3405E96A30DA39837608FC99CF1A0@VI1PR05MB3405.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 031257FE13
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(346002)(366004)(396003)(376002)(189003)(199004)(4326008)(478600001)(5660300002)(1076003)(36756003)(316002)(52116002)(8676002)(8936002)(26005)(81166006)(9786002)(6916009)(7416002)(33656002)(86362001)(81156014)(9746002)(66556008)(2616005)(66946007)(186003)(2906002)(66476007)(21314003)(24400500001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3405;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MJ+muuDflxrCPcMhH8MLrUF3Jbxc/EUiWulPJxiOpnIu5v1YFl1ce17BbwN7vDU+kRwT9Te7+D9lroSWlxQdUlfIm2TCrApZVwJQQLwRIIqSjEJyzjOrrE7Wtt2KdEP/9Yp6jJIK82KRzE6lkjJBRF/RKH/SjD5Kz+y+8mySA9Rbvr1XDhDak7z8pGIwJeetoxA50vF6UrmUwyO80rBv3RXD9tW6G+ISzegimG/gkpvyIainjyhkHw4bLWTBN37HApbmM8djqR7PlJCFouk5iyuzJFOuhDGoOJVErWlK8gjyyblGctRMcPtut4IlXoKk+GFyZWEhokR+dzKa/1Ggqo5JYTArGutGZEpyKh5Lqpev773RGpZNPohSTD3i5UaEk31BYuFuQLZqq3n2n/t+yprBlHz9pU0tMjUBovp6ICPcEwLy7cIW5hCO1mRLnUOTbwSdq3o5mLPYJ4BVVB2XtLLZJ2Wdv8RwiuFQo6h8z9sHgDXHWsGKONgYSzen0BMs52abN+mQMyJqMxCIMk7zhg==
X-MS-Exchange-AntiSpam-MessageData: lSxSf8LYae0N3VyhQQ2acwugKXXcg2C3o+qS7rFQAJK2Ll+hiRbQnONrm8Chb4MY+UUKg5w0ZIY8F5JpDPcOfprSc/nlZawDkXQZGpKBwW+VOKeiWNXTwlE30zkoY47aPpK5AkR4kzbr/awmrrp7yQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfff4a3f-27f9-4837-7c72-08d7b0a12862
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2020 16:24:11.1359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SlVNHLcWHCYnrjBAZ7FrI3K69geTNvJoZ5Qby4rKKO365SI7390M9K0jIpuvWi5MgkbaVXEYH+Akg5pZJ9YKvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3405
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 13, 2020 at 10:56:00AM -0500, Michael S. Tsirkin wrote:
> On Thu, Feb 13, 2020 at 11:51:54AM -0400, Jason Gunthorpe wrote:
> > > That bus is exactly what Greg KH proposed. There are other ways
> > > to solve this I guess but this bikeshedding is getting tiring.
> > 
> > This discussion was for a different goal, IMHO.
> 
> Hmm couldn't find it anymore. What was the goal there in your opinion?

I think it was largely talking about how to model things like
ADI/SF/etc, plus stuff got very confused when the discussion tried to
explain what mdev's role was vs the driver core.

The standard driver model is a 'bus' driver provides the HW access
(think PCI level things), and a 'hw driver' attaches to the bus
device, and instantiates a 'subsystem device' (think netdev, rdma,
etc) using some per-subsystem XXX_register(). The 'hw driver' pulls in
functions from the 'subsystem' using a combination of callbacks and
library-style calls so there is no code duplication.

As a subsystem, vhost&vdpa should expect its 'HW driver' to bind to
devices on busses, for instance I would expect:

 - A future SF/ADI/'virtual bus' as a child of multi-functional PCI device
   Exactly how this works is still under active discussion and is
   one place where Greg said 'use a bus'.
 - An existing PCI, platform, or other bus and device. No need for an
   extra bus here, PCI is the bus.
 - No bus, ie for a simulator or binding to a netdev. (existing vhost?)

They point is that the HW driver's job is to adapt from the bus level
interfaces (eg readl/writel) to the subsystem level (eg something like
the vdpa_ops). 

For instance that Intel driver should be a pci_driver to bind to a
struct pci_device for its VF and then call some 'vhost&vdpa'
_register() function to pass its ops to the subsystem which in turn
creates the struct device of the subsystem calls, common char devices,
sysfs, etc and calls the driver's ops in response to uAPI calls.

This is already almost how things were setup in v2 of the patches,
near as I can see, just that a bus was inserted somehow instead of
having only the vhost class. So it iwas confusing and the lifetime
model becomes too complicated to implement correctly...

Jason
