Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5071C31D1A6
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 21:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbhBPUiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 15:38:18 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:4124 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbhBPUiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 15:38:16 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602c2d0e0000>; Tue, 16 Feb 2021 12:37:34 -0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 16 Feb
 2021 20:37:32 +0000
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 16 Feb
 2021 20:37:30 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 16 Feb 2021 20:37:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XeH00gjhC8cTBEi/Fvcdpapwd5XQh36f519Rv4kzfWaLIFRBl8y6ZYxcT8I9i8y+KIvMfWkp7itp7M4aGFTjD1eIjkPdOI7NOIixNSyYtTJrfngNQtWHofP4bu0cp2lF3C/OXsQ76uVsiJ77NrRJH05nwnqFnbs3tXsVGEp54+nCtVTuFRUGfTdK33MKXMoyE1qrTAuntAR+kI/lEVZ42rbv6H7L+d9oQOMQmfSplIuPr0UmBvtMSTMMaciQxuaoPy/4Nxytrcn48KQl8NNuyYDsFXyHKZR84WRhIatkqmXuwCd53b6Gk+8QjJ8QSp2bp5cnTHMKif94YR1w35ixuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DO80BabukQjg/O7gbshaqTOtij5NDzriH8zaM/otgcE=;
 b=QetCokRyXcdMP5MYz5QASCu3AOqs7k0xsspmD0cufQ7qh99HuYxpulFGgyQ+ouigDK2PDgy3qGj72pWwf1kdIPNj1EjuCmYO47mLEm5d/5j29ABkOFq7vKhXfl2pxSRdn7MLUtS4K7P2snghEl3CELC73CU1E//gS0nUIczTkVCn0YK9TOpN7nl7ndslmj7i2zLL+j39ym9LedpZ/dfNP8vi7JBTJbxzCb/BOcD7hNeBpQz1T6iaZNM9VHwkJoyQpqxiHIhsyBW2zCq0Kb04kH56pIMmS9fYR4eDheO2gDZc6rgBdM3qLoNI4N+LtyG0OUTKL6MM1RVplkOigXas0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4402.namprd12.prod.outlook.com (2603:10b6:5:2a5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Tue, 16 Feb
 2021 20:37:27 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3846.041; Tue, 16 Feb 2021
 20:37:27 +0000
Date:   Tue, 16 Feb 2021 16:37:26 -0400
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
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH mlx5-next v6 1/4] PCI: Add sysfs callback to allow MSI-X
 table size change of SR-IOV VFs
Message-ID: <20210216203726.GH4247@nvidia.com>
References: <YCt1WAAEO1hx2pjY@unreal>
 <20210216161212.GA805748@bjorn-Precision-5520>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210216161212.GA805748@bjorn-Precision-5520>
X-ClientProxiedBy: MN2PR01CA0008.prod.exchangelabs.com (2603:10b6:208:10c::21)
 To DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR01CA0008.prod.exchangelabs.com (2603:10b6:208:10c::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Tue, 16 Feb 2021 20:37:27 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lC766-009Kh0-2y; Tue, 16 Feb 2021 16:37:26 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613507854; bh=DO80BabukQjg/O7gbshaqTOtij5NDzriH8zaM/otgcE=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=NpE/iY//vESb1CMPeSQ0kyrqIh4ErodWNyszLNh1hbocUnkqMwkQl1BLFX+RQ9WB1
         adPKk1+iYGXKKzP5+zxPogYsexY3b3D8d1NYps2rZELIOZ+P+ODy6x8dwLVeGUt4Cr
         LH5J1HLljoFl4tJhmb2phkzl4TTh2S/UrhJyVTItVtSvaylWbXgy/+y1eYBx40flik
         7Inbjevu1YG+H9JOGZdXECvSjmJlRBLXt4Vq3XkwG7RlIW3fxxZi00J7Ft9ah9+UR9
         aWi2N8TB+SauxJq6I5kFBsg/lTkCZjdzAgiCccUPRDoorQ4J6FCRDu9ZLETMxCJ2vm
         4uZCmfnVZ0Yxw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 16, 2021 at 10:12:12AM -0600, Bjorn Helgaas wrote:
> > >
> > > But I still don't like the fact that we're calling
> > > sysfs_create_files() and sysfs_remove_files() directly.  It makes
> > > complication and opportunities for errors.
> > 
> > It is not different from any other code that we have in the kernel.
> 
> It *is* different.  There is a general rule that drivers should not
> call sysfs_* [1].  The PCI core is arguably not a "driver," but it is
> still true that callers of sysfs_create_files() are very special, and
> I'd prefer not to add another one.

I think the point of [1] is people should be setting up their sysfs in
the struct device attribute groups/etc before doing device_add() and
allowing the driver core to handle everything. This can be done in
a lot of cases, eg we have examples of building a dynamic list of
attributes

In other cases, calling wrappers like device_create_file() introduces
a bit more type safety, so adding a device_create_files() would be
trivial enough

Other places in PCI are using syfs_create_group() (and there are over
400 calls to this function in all sorts of device drivers):

drivers/pci/msi.c:      ret = sysfs_create_groups(&pdev->dev.kobj, msi_irq_groups);
drivers/pci/p2pdma.c:   error = sysfs_create_group(&pdev->dev.kobj, &p2pmem_group);
drivers/pci/pci-label.c:        return sysfs_create_group(&pdev->dev.kobj, &smbios_attr_group);
drivers/pci/pci-label.c:        return sysfs_create_group(&pdev->dev.kobj, &acpi_attr_group);

For post-driver_add() stuff, maybe this should do the same, a
"srio_vf/" group?

And a minor cleanup would change these to use device_create_bin_file():

drivers/pci/pci-sysfs.c:        retval = sysfs_create_bin_file(&pdev->dev.kobj, res_attr);
drivers/pci/pci-sysfs.c:                retval = sysfs_create_bin_file(&pdev->dev.kobj, &pcie_config_attr);
drivers/pci/pci-sysfs.c:                retval = sysfs_create_bin_file(&pdev->dev.kobj, &pci_config_attr);
drivers/pci/pci-sysfs.c:                retval = sysfs_create_bin_file(&pdev->dev.kobj, attr);
drivers/pci/vpd.c:      retval = sysfs_create_bin_file(&dev->dev.kobj, attr);

I haven't worked out why pci_create_firmware_label_files() and all of
this needs to be after device_add() though.. Would be slick to put
that in the normal attribute list - we've got some examples of dynamic
pre-device_add() attribute lists in the tree (eg tpm, rdma) that work
nicely.

Jason
