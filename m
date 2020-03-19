Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9352318B3D8
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 14:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgCSND1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 09:03:27 -0400
Received: from mail-vi1eur05on2044.outbound.protection.outlook.com ([40.107.21.44]:28902
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725787AbgCSND0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 09:03:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WIk5ClK5qYtgAWV0obTZWJbXtMJJD6Jyjvai9Ml6vVHrKE+q96PGH8EviXhDCOkbS8vKBsPoKEaJbnvG9Fal67T4H0bDAs2d0n0p5we6DzQpC50EIvxxWro//rqfo2TaP3FcWgZhHAannJB6G6HhyxUt2pHLAFYMQayQ+1g23r6oxj22b0OAQ3j/o2ar2CW9EidTn1wI29wnWJJcuQRw3ZxUG2ATtjshCmrtsBv74dKc61XG1LpkhRkmmzxW6ucDcv9iUUgc32Rjy/9OKakrmVSfLT0+IAzAmSJ1reMmAD28uNptIwmslLEq0FyV8HV8ASF0L9v1ZNg4Tj6Gd+evRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=//4y0pWVTPrnSvNPOIIyemyc3flXqyb2JpGvIAfEZdE=;
 b=aAHoEW8Jeu8Ir1vZmqkoJjmWmiS5JM+HJxbRis7YBIr1vQXoE3fBv5N9hxu7iFhSz0OitBgQ8lVi2Xd6CWl8J1GOxY41Dl81t5q0k9OqbKKncTpREYIrNLZaq53cJeRcM6lMyfJ5NamrIGCeO8H68yuUBoSt1vQ8ff15g917tby2ygJ6qsTvyviOFzy64qDspHPQMQ7UMPY4zs88INFCr6nBJxT+cxpvFBf5nxX+rKUkEQ2tvmtJ3ItIazz+sYKPf04ps8EXTi+DgxaJR49kOnoMA+HJjC6Zyu72nFPyo93p3zeiS2u0EkEKawqPvfRqx79/OfFchvBjXrk+9vkgog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=//4y0pWVTPrnSvNPOIIyemyc3flXqyb2JpGvIAfEZdE=;
 b=ctgsChtlzv5n/ICht1ZVLrdb0+JYVVQHj4LpKbu9ESkYQOFolPgR9C08rnlD8nQXO6O0ZarqipfkVcfsdBdbvDCoz7rwG0vVnc/RI2GAzyoh/T8uSNiWm0DkEKa8C61/SRIUU9sRV0j3eNS8LyGc4qsi9YkWjYsneXsyJKWcAyM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (52.133.14.15) by
 VI1PR05MB7150.eurprd05.prod.outlook.com (10.141.234.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.18; Thu, 19 Mar 2020 13:02:44 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::18d2:a9ea:519:add3]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::18d2:a9ea:519:add3%7]) with mapi id 15.20.2814.025; Thu, 19 Mar 2020
 13:02:44 +0000
Date:   Thu, 19 Mar 2020 10:02:39 -0300
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
Subject: Re: [PATCH V6 8/8] virtio: Intel IFC VF driver for VDPA
Message-ID: <20200319130239.GW13183@mellanox.com>
References: <20200318080327.21958-1-jasowang@redhat.com>
 <20200318080327.21958-9-jasowang@redhat.com>
 <20200318122255.GG13183@mellanox.com>
 <30359bae-d66a-0311-0028-d7d33b8295f2@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <30359bae-d66a-0311-0028-d7d33b8295f2@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MN2PR04CA0015.namprd04.prod.outlook.com
 (2603:10b6:208:d4::28) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR04CA0015.namprd04.prod.outlook.com (2603:10b6:208:d4::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.20 via Frontend Transport; Thu, 19 Mar 2020 13:02:43 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jEuop-0005nX-Qe; Thu, 19 Mar 2020 10:02:39 -0300
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ad14dc61-9e34-466b-22ac-08d7cc05d03d
X-MS-TrafficTypeDiagnostic: VI1PR05MB7150:|VI1PR05MB7150:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB715064BC27E89253BFFAC4E1CFF40@VI1PR05MB7150.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0347410860
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(396003)(136003)(346002)(39860400002)(199004)(8676002)(316002)(4326008)(86362001)(81156014)(33656002)(81166006)(6916009)(66946007)(2906002)(9786002)(36756003)(5660300002)(52116002)(66476007)(66556008)(1076003)(9746002)(2616005)(26005)(8936002)(186003)(7416002)(478600001)(24400500001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB7150;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bGbCtPrNZR30Vw4cMomAnsEMxqxb7nXS3Nqt9D5wGiTe85znPvVPzKx8XkvJIQYP48zDFzY7Q2y4dnJrrOoEnHjI2VubN65nzP5ChVOsUi0mawkO8E6WKRuB5HFRzzlhv9MQx+t21BAGE/Usd6Wvg6ZpR75I1U2K4L8ctTD8h0VrGVJ/5ZBgAq1qHKX2I8tgN7FPVOienHVXX5rWA6ls5fgCIa+jVZlUd8kFngUcFKxuGYWYbvKZRX9gkuiF+Xz8gf11VDovMsjftoPK2XnbZS2Bce2zFlxoUoj8GFahml/KbG+OX/Un9gn411Q7yE+VyxTSrhaceR5flN/k+wypYYv4QCgzOz1tRNu4vIbtgrDqB1XVvj5jQ/3Q/SXSv5NctIpmiINxEXGMsioJiaSf6O0zY8g9DdHDLHAxhPVjhHM3FNfkqSdGZov5prd16B2d6X3qvVprIPz2ui+msdiu9l/ubCYr7kD9pUqA8p1fvW1FI2/mE5WsjODl4NHMC9xQ
X-MS-Exchange-AntiSpam-MessageData: VD8NG3rnq/NO3+Lmfh4zuctlXKVCPu1CGfgSH+nAM0RcyX1UBYYplgQoSCynalY5URwpOW6GAKgWGwW8Dp4dHdmi+JqkZLaBk8qZ/Wowu/ZHd6l2RhU6swPz6uIVAnzoKJZ9+cAFS6dQR9oNPSFcNg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad14dc61-9e34-466b-22ac-08d7cc05d03d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2020 13:02:44.7348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GvE7FDAJpRIABvezilJMYsiCHpeefYaEfNtWFiKgVppn+f/Xk35iCoYYVXIaKUP62fQAxrly5kJyGaFWHp1s9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7150
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 19, 2020 at 04:14:37PM +0800, Jason Wang wrote:
> 
> On 2020/3/18 下午8:22, Jason Gunthorpe wrote:
> > On Wed, Mar 18, 2020 at 04:03:27PM +0800, Jason Wang wrote:
> > > From: Zhu Lingshan <lingshan.zhu@intel.com>
> > > +
> > > +static int ifcvf_vdpa_attach(struct ifcvf_adapter *adapter)
> > > +{
> > > +	int ret;
> > > +
> > > +	adapter->vdpa_dev  = vdpa_alloc_device(adapter->dev, adapter->dev,
> > > +					       &ifc_vdpa_ops);
> > > +	if (IS_ERR(adapter->vdpa_dev)) {
> > > +		IFCVF_ERR(adapter->dev, "Failed to init ifcvf on vdpa bus");
> > > +		put_device(&adapter->vdpa_dev->dev);
> > > +		return -ENODEV;
> > > +	}
> > The point of having an alloc call is so that the drivers
> > ifcvf_adaptor memory could be placed in the same struct - eg use
> > container_of to flip between them, and have a kref for both memories.
> > 
> > It seem really weird to have an alloc followed immediately by
> > register.
> 
> 
> I admit the ifcvf_adapter is not correctly ref-counted. What you suggest
> should work. But it looks to me the following is more cleaner since the
> members of ifcvf_adapter are all related to PCI device not vDPA itself.

I've done it both ways (eg tpm is as you describe, ib is using alloc).

I tend to prefer the alloc method today, allowing the driver memory to
have a proper refcount makes the driver structure usable with RCU and
allows simple solutions to some tricky cases. It is a bit hard to
switch to this later..

> - keep the current layout of ifcvf_adapter
> - merge vdpa_alloc_device() and vdpa_register_device()
> - use devres to bind ifcvf_adapter refcnt/lifcycle to the under PCI device

This is almost what tpm does. Keep in mind the lifecycle with devm is
just slightly past the driver remove call, so remove still 
must revoke all external references to the memory.

The merging alloc and register rarely works out, the register must be
the very last thing done, and usually you need the subsystem pointer
to do pre-registration setup in anything but the most trivial of
subsystems and drivers.

> If we go for the container_of method, we probably need
> 
> - accept a size of parent parent structure in vdpa_alloc_device() and
> mandate vdpa_device to be the first member of ifcvf_adapter
> - we need provide a way to free resources of parent structure when we
> destroy vDPA device

Yep. netdev and rdma work this way with a free memory callback in the
existing ops structures.

Jason
