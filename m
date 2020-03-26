Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D55A9193EB5
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 13:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728171AbgCZMRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 08:17:16 -0400
Received: from mail-eopbgr00063.outbound.protection.outlook.com ([40.107.0.63]:54243
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727841AbgCZMRQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 08:17:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=divM5xc/aYJJzXrPLOwLm9HHtGqj7SXDz9+0/p7LV9efhKx3m0OdVgEedK4TU8PrI8dOXwTueEdGRkaJjiB4kG+HfUWFP0maqPVpWmDSOVjTtMKZHHhnj6LjsI5IfkUnQi8Z8coevqw1lvKytdFG1KPNqHXeoxuEq2x9rgaJYinT4f57MX6ERMVd0zgHUZaCvuFaqAvn4yorzgG4MMEBl8Woy2oINJ1y+4F1qmMgFFWOeDqcF+/Gq85uiynnx3rVKfP4hA2t57HeXoAo54FBTVrIiiezYQleQv1LKRZ7/gxGWlEQ0AQ08y7zG0me9B9SlXl7ZBqL0AHr1F3NPKLMPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8kf2msLgn2Y6bPR4XlOADAK5LICYmgcHyBGVHIP7x5s=;
 b=dOy0NoMAEtKOzxHRMxagPKZZirg5lkZiVY/emtpmBtcsfbykyzxlmsoLKq69j7QEvRdd+VjTlzidvecYvNABtYMWH8Va607LOyxe8C8DH5zu0s2cqZLovAlgcq7bBZIpSwA8RUkOGxA0uyox3IW+0hXO/LOVt6rvHMSGahoie8r6YkUp2UfNAz1nB8p82keSlRuo8wlrylOL9uT0Q32x8DUBVOsBARi9JsaaguAWyIKenruvAHTyedKHloNCx5HJNG9QNic9ouQaCRhQXmoA/6M0gZ4Hhn+7V0rjDuRIa8ER6WWoJGzSH4eY6uvHCwfYyKO/hfwBB8yuI+J9TMzR7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8kf2msLgn2Y6bPR4XlOADAK5LICYmgcHyBGVHIP7x5s=;
 b=rWfQwQVZddF3wSfdl44kW9TcZPv21RCGglaHrApx+V3JJUJxt60wecWZZOF30ViR7pt5i2eGPbkd7JHDoEGMJEbdOTQCJaSWIXqL9V6cxNa9uBxDNPo0mLUtXJiDxmeXoYMyB4AwkeMhZiS6fhQRLR9k6aUCEAWRjLAqZajAQk0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (52.133.14.15) by
 VI1PR05MB5853.eurprd05.prod.outlook.com (20.178.125.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.19; Thu, 26 Mar 2020 12:17:12 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::18d2:a9ea:519:add3]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::18d2:a9ea:519:add3%7]) with mapi id 15.20.2856.019; Thu, 26 Mar 2020
 12:17:11 +0000
Date:   Thu, 26 Mar 2020 09:17:05 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        maxime.coquelin@redhat.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, rob.miller@broadcom.com,
        xiao.w.wang@intel.com, lingshan.zhu@intel.com, eperezma@redhat.com,
        lulu@redhat.com, parav@mellanox.com, kevin.tian@intel.com,
        stefanha@redhat.com, rdunlap@infradead.org, hch@infradead.org,
        aadam@redhat.com, jiri@mellanox.com, shahafs@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com, gdawar@xilinx.com,
        saugatm@xilinx.com, vmireyno@marvell.com,
        Bie Tiwei <tiwei.bie@intel.com>
Subject: Re: [PATCH V8 9/9] virtio: Intel IFC VF driver for VDPA
Message-ID: <20200326121705.GJ13183@mellanox.com>
References: <20200325082711.1107-1-jasowang@redhat.com>
 <20200325082711.1107-10-jasowang@redhat.com>
 <20200325123410.GX13183@mellanox.com>
 <ed04692d-236c-2eee-4429-6ef4d5d165fe@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed04692d-236c-2eee-4429-6ef4d5d165fe@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: BL0PR03CA0012.namprd03.prod.outlook.com
 (2603:10b6:208:2d::25) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.68.57.212) by BL0PR03CA0012.namprd03.prod.outlook.com (2603:10b6:208:2d::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.18 via Frontend Transport; Thu, 26 Mar 2020 12:17:11 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jHRRZ-0003kY-Ac; Thu, 26 Mar 2020 09:17:05 -0300
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c2efe42e-1115-46e5-11ad-08d7d17f9c92
X-MS-TrafficTypeDiagnostic: VI1PR05MB5853:|VI1PR05MB5853:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB58537EF3DCA4B72DC49FD733CFCF0@VI1PR05MB5853.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0354B4BED2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(346002)(39860400002)(396003)(366004)(376002)(26005)(1076003)(478600001)(9786002)(8676002)(81156014)(81166006)(8936002)(186003)(316002)(52116002)(2906002)(9746002)(6916009)(66556008)(66476007)(66946007)(7416002)(4326008)(5660300002)(86362001)(36756003)(33656002)(2616005)(24400500001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J2bRjluQP8K2zSNOzjRD6zLaSySAoQ625fEWofB+jXkHnb0wNaZ9FGMhblWNwEVjmD7B7HGHnMAHtdcsSStdSPIADvJbnBZRFf5Zhn71YJe/R/x/u807GKCMNV7zK2ImGoi7NMRFInMutShHITs/mpY2cOoYD5jLzB5nP/hK1tv1fvt2MlUQstO2DpXCaZacqMlE2e4mYWC3xO+ynilMX2lT7n2EqD5nQLvWgG1cTOZEUGCAzIBb+giuWgqR9CKBxy59TpAy+Q/vACPBUgWYEIl42AHHHTdUZOZ/MC7R/+TirmnyLZvDJeHvbYLq1UX+Tb7g1YYajlFQb39f9HGa3HLxj+CA1XbeEezPp9vg48PITqDmqssmQcIr6Uauwyug9dFGcLL6/GpOkfs5SZua/lU9cSs1XOCuo6u2VAQv/PLJIOVSNBR9ROzNp9KYkC9zEGMOCVXQifocHBuD1NImuOLY1JfH5srTvLut17YKC/NBHz9bgmlefRrNhzAuXlht
X-MS-Exchange-AntiSpam-MessageData: 22bXDp0f+v7oC2C42v83iadYQDV++m0Uc7kZCrLIZgUymmB6R/3apJX68rLdSx6WAYqcpWZCIcOr/5GzMQLqXPbSdU5Ad1nzcN+lbr+UTaK5dyHPvnXlJNvdLfh5NWWVT7W4HWQgNbUOrUTypyPloQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2efe42e-1115-46e5-11ad-08d7d17f9c92
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2020 12:17:11.7262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wVIVZIBRIuuHDoWGv+kAaFVV5Dm6ZEokNNECIl4H4YCwd+h5zzuDnz0cPqEaZxInVLv3p2o6Uzse/1N5WuSK7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5853
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 01:50:53PM +0800, Jason Wang wrote:

> > > +	adapter->vdpa.dma_dev = dev;
> > > +	ret = vdpa_register_device(&adapter->vdpa);
> > > +	if (ret) {
> > > +		IFCVF_ERR(adapter->dev, "Failed to register ifcvf to vdpa bus");
> > > +		goto err_msix;
> > > +	}
> > > +
> > > +	return 0;
> > > +
> > > +err_msix:
> > > +	put_device(&adapter->vdpa.dev);
> > > +	return ret;
> > > +err_alloc:
> > > +	pci_free_irq_vectors(pdev);
> > > +err_vectors:
> > > +	pci_release_regions(pdev);
> > > +err_regions:
> > > +	pci_disable_device(pdev);
> > > +err_enable:
> > > +	return ret;
> > > +}
> > I personally don't like seeing goto unwinds with multiple returns, and
> > here I think it is actually a tiny bug.
> > 
> > All touches to the PCI device must stop before the driver core
> > remove() returns - so these pci function cannot be in the kref put
> > release function anyhow.
> 
> 
> I'm not sure I get here. IFCVF held refcnt of its PCI parent, so it looks to
> me it's safe to free PCI resources in vDPA free callback?

The refcnt doesn't prevent the driver core from re-binding the
pci_device to another driver. Then the refcount put would do a
pci_disable_device() after another driver has started

For this reason all touches to a struct pci_device must stop before
remove returns.

Jason
