Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684D931DF9B
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 20:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232968AbhBQT0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 14:26:16 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:15429 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbhBQT0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 14:26:12 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602d6dab0001>; Wed, 17 Feb 2021 11:25:31 -0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 17 Feb
 2021 19:25:29 +0000
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 17 Feb
 2021 19:25:27 +0000
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.53) by
 HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 17 Feb 2021 19:25:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I2nCcJMJ10orAMrRB5/UrcEWPh4uVk2/P/OodxJ40Sfzb+3MPzuSBp3OL+hg6nFuzs3U0+wDs8zuGrIOhKhrb9Nfvjh3plERcvdl+SzCx3nHWt9Z2lMq2h2/q3MbAbhji1JnQP5HMPBApY3zIQWG7uqB+M2EHZqIXW8roiwF4KhhMkVLXvgVcpH75KZ19fdQlUGr1qehPE+szODafB/wmNVdPGhs504sd/KokKVR+a6yMkMVNAmgXtq8LU+LTxDl3/4P8tThULjxfSfFqt1NCg9gEtRDZsyN0dmZTPlVeqCLFCsUWvpNrcseL3wYrA9cawL2B4nVrUXn0dKfB++KhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ummEi7dJI4688G6dZce8fv8mf95V5106apXNnNPGYew=;
 b=HinV0mshVR5KZC4lwPw+CPtduUPqX8oe/DdjsPLWfn3ZA05JF2FM6ed0yAoz02i9r6Dltb0qZ/B0lmCyJMahocxQsKKHx7X3NSXgzhfv0Jrs/hcVJzBs7EUzyIVY3tdYqC7SpJF422grkT4+PLE7J2JBSmBbQRfxMLixKMugIWUUbXAa7x9lxxFVsmgcnKzWXPv6VXk81t8Tt1RJnzCx4wt4J3ELEgeKFWHdjd4Z0WZaf+stvSIYf1VDm2s1gLbiJCCZ7JkqSaoypwiCfsK4IqKn61sxZORvQDg+rhoTB1pk0sEytDYVnhgdkPemyz0nupOYHJjqXNqm+UZJrz/qUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4499.namprd12.prod.outlook.com (2603:10b6:5:2ab::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Wed, 17 Feb
 2021 19:25:24 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3846.041; Wed, 17 Feb 2021
 19:25:24 +0000
Date:   Wed, 17 Feb 2021 15:25:22 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
CC:     Leon Romanovsky <leon@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>
Subject: Re: [PATCH mlx5-next v6 1/4] PCI: Add sysfs callback to allow MSI-X
 table size change of SR-IOV VFs
Message-ID: <20210217192522.GW4247@nvidia.com>
References: <YCwj4WsrVeklgl7i@unreal>
 <20210217180239.GA896669@bjorn-Precision-5520>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210217180239.GA896669@bjorn-Precision-5520>
X-ClientProxiedBy: MN2PR15CA0056.namprd15.prod.outlook.com
 (2603:10b6:208:237::25) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR15CA0056.namprd15.prod.outlook.com (2603:10b6:208:237::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Wed, 17 Feb 2021 19:25:23 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lCSRu-00A4CP-GN; Wed, 17 Feb 2021 15:25:22 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613589931; bh=ummEi7dJI4688G6dZce8fv8mf95V5106apXNnNPGYew=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=IrhJjBDZetT1iYywfk+ioSxjo4iUy4qtVjMse1Ha0EL9dhU4yNbAy/twW0Sb0GzIO
         ZL/5GLuNSk+c+7nY+5pMrCnfin+ybVdyyMaxbdopybswpSKiIr4DKc35LSyzk+HTbz
         lDWcBEcuosqndd0SXao1/g07xTGxUpOIg+70xCTvVP83+qcNGXCAUsJ8uhqznCpxN2
         RxYh+fxeTSXMskvil1nwzuqUQH739TkVoD3VTqZoVzlGY8tmMjkMT+lbjULNFjtuic
         pE5f6vN1tNvnwXeDz5x5ArwE5MvuseoKUdUgy5ID8w91+OyutAgTLib/EQrOqKcxGx
         gXj8CYBS23aKg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 12:02:39PM -0600, Bjorn Helgaas wrote:

> > BTW, I asked more than once how these sysfs knobs should be handled
> > in the PCI/core.
> 
> Thanks for the pointers.  This is the first instance I can think of
> where we want to create PCI core sysfs files based on a driver
> binding, so there really isn't a precedent.

The MSI stuff does it today, doesn't it? eg:

virtblk_probe (this is a driver bind)
  init_vq
   virtio_find_vqs
    vp_modern_find_vqs
     vp_find_vqs
      vp_find_vqs_msix
       vp_request_msix_vectors
        pci_alloc_irq_vectors_affinity
         __pci_enable_msi_range
          msi_capability_init
	   populate_msi_sysfs
	    	ret = sysfs_create_groups(&pdev->dev.kobj, msi_irq_groups);

And the sysfs is removed during pci_disable_msi(), also called by the
driver

Jason
