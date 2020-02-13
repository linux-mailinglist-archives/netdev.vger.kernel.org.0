Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D21515C0FD
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 16:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbgBMPFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 10:05:52 -0500
Received: from mail-eopbgr20084.outbound.protection.outlook.com ([40.107.2.84]:17728
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726937AbgBMPFv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Feb 2020 10:05:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=noSSVL51yIXso78V/Drx7VlBIuluW9PG+LVgjG1w9olWlzONG0vk5GF097ZgVVgGVLjfONTjp8ZgizsY0iMIsTg5/3xbYz5TtC1Zaj/HiOv7MID9KBblTdMY+BKT5D43F6nSjZWPj+IZqLWizCmJdvp/ttBQdO8HK978U91K2vwhoEcLa+pGbj9wvF7WWyP9zs+ZEnIAuYEyQ8AsMqMy+kb8QJm20IHsK5xVsp/eWQEpSfdL5++nyy5NOYGg9K6pkCjoIX35+cbj/jJUb44BajK3+lN06/hMtYYWrHMHCpCMc+ihgpht+ovUxKfhZpq7wOnDgXeKzusDKVghFW6d/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AZPJ+StsmdpwxZ9pIrUwvbhuQ3GSj2LQY7edxansr/c=;
 b=auO7HzasFaBNK8rMTYqVUwyEVXw3ndgqgyGRg4JFd62TN/f9KnOwqos6tAso7SgO01jbRhSuRAwVq5ulxv45xbewpExVvHz5vthi5guGv2adn887JJ9GOt0any2OSKV/3C5uXO5WLYy+KNlEn9aoy54h2Ei1/WBnLDyudMW2qE2mWW2BRi3TOwICx1eCzNLWM+ZnANqbngMCO9hABYorhcaK8EvJ/XW1QWvSKA4/AqQPgcdDMc6aOPAA+HoGZbBM/7FX2rdq6JWGh8OTsTP6oS36kShT+d1rHv0WnhPmTdcbn838ahqijUlEWHUY5EGSnWd9d4dC8cQBHgDTZj5biQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AZPJ+StsmdpwxZ9pIrUwvbhuQ3GSj2LQY7edxansr/c=;
 b=tBkJ4bz+01k3FHjFAQjeScwkYVAIiXcdb9dZOeLGXnU5xgUNAvqlKQOoR55pfjNxnVrs/QlYxl+9RcjWfXUVfxbtrb4w16YMhWwHeLThEhF/P5XecE41koHqPqiOompDqUj+6JKjpcx3UjyawrLbdB88xhPdqKLX1nSwAKznJiU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (52.133.14.15) by
 VI1PR05MB4303.eurprd05.prod.outlook.com (52.133.15.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.21; Thu, 13 Feb 2020 15:05:46 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d%7]) with mapi id 15.20.2729.025; Thu, 13 Feb 2020
 15:05:46 +0000
Date:   Thu, 13 Feb 2020 11:05:42 -0400
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
Message-ID: <20200213150542.GW4271@mellanox.com>
References: <20200210035608.10002-1-jasowang@redhat.com>
 <20200210035608.10002-4-jasowang@redhat.com>
 <20200211134746.GI4271@mellanox.com>
 <cf7abcc9-f8ef-1fe2-248e-9b9028788ade@redhat.com>
 <20200212125108.GS4271@mellanox.com>
 <12775659-1589-39e4-e344-b7a2c792b0f3@redhat.com>
 <20200213134128.GV4271@mellanox.com>
 <ebaea825-5432-65e2-2ab3-720a8c4030e7@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ebaea825-5432-65e2-2ab3-720a8c4030e7@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MN2PR13CA0030.namprd13.prod.outlook.com
 (2603:10b6:208:160::43) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR13CA0030.namprd13.prod.outlook.com (2603:10b6:208:160::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.8 via Frontend Transport; Thu, 13 Feb 2020 15:05:46 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1j2G3i-00051c-IR; Thu, 13 Feb 2020 11:05:42 -0400
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1de89200-f5cd-4531-9b8b-08d7b0963424
X-MS-TrafficTypeDiagnostic: VI1PR05MB4303:|VI1PR05MB4303:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4303985C9353290AE0B7AFC5CF1A0@VI1PR05MB4303.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 031257FE13
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(346002)(136003)(376002)(366004)(199004)(189003)(66946007)(66556008)(66476007)(1076003)(5660300002)(2616005)(9786002)(9746002)(6916009)(33656002)(7416002)(36756003)(81156014)(316002)(8936002)(8676002)(186003)(4326008)(52116002)(26005)(2906002)(478600001)(81166006)(86362001)(24400500001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4303;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0JV+7gcnIpRhY7xy6VlPe50jvbWAdQ/VgWpnmlYS34kEZItBzHLgfbAd/fYyRfdKFbMYcXiOcppWPg8eLl3BnIyMXf46EypX4A5RCDbE2HnB6AH883q9UTzAum9lTkHdN65ojwxUaBUVBbhnq4WZjidZgMKSyG30Y2g1iQdJVU2tQrA6P6h66Qcn9aEqmEfvyKnqcL1k53Xwrx7kqu338aTR+z7Te+hyDmJSVAbnH+yBcz5lzerUybhblGGE7sfkJ3Fz3NG1bMZHjU+3gE6Nq4fQWLZUsFxPE3ymVr6d/PLhSmFkz/kEVq1meF3rOZgeM8p+rS68ypsvb4NALoxLcLx2LQcjlCd5nnyF8NDjE6zvqOx4DVvEC9Ysye4k4vSfben30/By6mA9CAZrOqiBkOE6Pe7p1MPD2kBfGo3ce2OHsw3OSFe73DGvoSVNwZ89Ms391nHJPhotRJtdC8AlB8KCFX38ZCYElvVd6GKfv04vrHrPpSLBT3ZozYI4RnK+
X-MS-Exchange-AntiSpam-MessageData: 2knGk/lhiSDBLfVEG7p0Gewtp8omMkfE3scWuR+/HuuJOhjjlZkqIzDQKVVisdnCgG+519Dq90GIstvc/zU8uaEKzqfVK+93ZRGfMb95diSCoQqiOEeUSwVMv1aK84dGAUOToRglULVP5wZO/icr5w==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1de89200-f5cd-4531-9b8b-08d7b0963424
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2020 15:05:46.5619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5OgHvRSQiJaIqUR0iQv5SiJgQj0mFopLu5IxDzpYTxDmC7hHopdzG/PriGlsv9ctdMmatxPwkpEhdRPisGqssg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4303
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 13, 2020 at 10:58:44PM +0800, Jason Wang wrote:
> 
> On 2020/2/13 下午9:41, Jason Gunthorpe wrote:
> > On Thu, Feb 13, 2020 at 11:34:10AM +0800, Jason Wang wrote:
> > 
> > > >    You have dev, type or
> > > > class to choose from. Type is rarely used and doesn't seem to be used
> > > > by vdpa, so class seems the right choice
> > > > 
> > > > Jason
> > > Yes, but my understanding is class and bus are mutually exclusive. So we
> > > can't add a class to a device which is already attached on a bus.
> > While I suppose there are variations, typically 'class' devices are
> > user facing things and 'bus' devices are internal facing (ie like a
> > PCI device)
> 
> 
> Though all vDPA devices have the same programming interface, but the
> semantic is different. So it looks to me that use bus complies what
> class.rst said:
> 
> "
> 
> Each device class defines a set of semantics and a programming interface
> that devices of that class adhere to. Device drivers are the
> implementation of that programming interface for a particular device on
> a particular bus.
> 
> "

Here we are talking about the /dev/XX node that provides the
programming interface. All the vdpa devices have the same basic
chardev interface and discover any semantic variations 'in band'

> > So why is this using a bus? VDPA is a user facing object, so the
> > driver should create a class vhost_vdpa device directly, and that
> > driver should live in the drivers/vhost/ directory.
>  
> This is because we want vDPA to be generic for being used by different
> drivers which is not limited to vhost-vdpa. E.g in this series, it allows
> vDPA to be used by kernel virtio drivers. And in the future, we will
> probably introduce more drivers in the future.

I don't see how that connects with using a bus.

Every class of virtio traffic is going to need a special HW driver to
enable VDPA, that special driver can create the correct vhost side
class device.

> > For the PCI VF case this driver would bind to a PCI device like
> > everything else
> > 
> > For our future SF/ADI cases the driver would bind to some
> > SF/ADI/whatever device on a bus.
> 
> All these driver will still be bound to their own bus (PCI or other). And
> what the driver needs is to present a vDPA device to virtual vDPA bus on
> top.

Again, I can't see any reason to inject a 'vdpa virtual bus' on
top. That seems like mis-using the driver core.

Jason
