Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2220F2F6BCE
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 21:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728654AbhANUJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 15:09:09 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:2731 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbhANUJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 15:09:09 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6000a4bc0000>; Thu, 14 Jan 2021 12:08:28 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 14 Jan
 2021 20:08:28 +0000
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.176)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 14 Jan 2021 20:08:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WIXIgjrnJq2n5HZcgY/tT2JMw6ZhD/MTgTO9ZRjraNqplqy/RDbjZXi9bT5HaJZo55/YBKL+mJFMv8Hnk+R3iEPB5SaNMM0ZLvCu+wHHI+qJFbgoMaUgsd01eAbxpR7hHDM6YF6IAVm35KCK02qm1+2eOM1HrX7V6W6set8nD/w73F3siBEnUGvWlTh3K5xIVWe9EhtM4o0TFJaLCdg4Hn6BxPZAmUmBirJp9mwnpyyyr8oMzR1aWLPp03JAFmrwCAaxZ21khBF7SEF1DzNpniH4g3VKREqilvBXikob1XVF4w4ZXQ1+UEhJFLpAQQxmH4/JRbPPwlgpl9Z1UJcwmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f8cJQO334QpnU3YwY9lpSaLe5gAXLQGzieDEWXFJoOY=;
 b=Swz2vLY4k41KxJqBCjruRJioEKmBcnOCVq1eSOr/JXL4C9N5IAONWTAwsEYho0KkUblWAYRxjwGq1l5L1HetRKVw43ctPD53QgOuCGEsHkoKroFPDtpA2wzcCqEywXk0iU25IEKJ8uGe/JE4g2GtqzgxmuMJDZK8Kg60HHJL9sb8ET5AcZ13CrY/hv/Dz+xQ9esmosC7yds8sv4jqM7VLPTFYSY2eNfIhQgdIui/xagjpQuTLyKevk3tI4QXN/F4Ia0sEdh9amWIYdWvHXOXq3rVs5MgthMuKfJpoBVHTgWo5lzzTyn6rtwt6GLwCIXFVN42O7AOhTpoMKn4ya24fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4266.namprd12.prod.outlook.com (2603:10b6:5:21a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Thu, 14 Jan
 2021 20:08:27 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3742.012; Thu, 14 Jan 2021
 20:08:27 +0000
Date:   Thu, 14 Jan 2021 16:08:25 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
CC:     Leon Romanovsky <leon@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH mlx5-next v1 2/5] PCI: Add SR-IOV sysfs entry to read
 number of MSI-X vectors
Message-ID: <20210114200825.GR4147@nvidia.com>
References: <20210112065601.GD4678@unreal>
 <CAKgT0UdndGdA3xONBr62hE-_RBdL-fq6rHLy0PrdsuMn1936TA@mail.gmail.com>
 <20210113061909.GG4678@unreal>
 <CAKgT0Uc4v54vqRVk_HhjOk=OLJu-20AhuBVcg7=C9_hsLtzxLA@mail.gmail.com>
 <20210114065024.GK4678@unreal>
 <CAKgT0UeTXMeH24L9=wsPc2oJ=ZJ5jSpJeOqiJvsB2J9TFRFzwQ@mail.gmail.com>
 <20210114164857.GN4147@nvidia.com>
 <CAKgT0UcKqt=EgE+eitB8-u8LvxqHBDfF+u2ZSi5urP_Aj0Btvg@mail.gmail.com>
 <20210114182945.GO4147@nvidia.com>
 <CAKgT0UcQW+nJjTircZAYs1_GWNrRud=hSTsphfVpsc=xaF7aRQ@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAKgT0UcQW+nJjTircZAYs1_GWNrRud=hSTsphfVpsc=xaF7aRQ@mail.gmail.com>
X-ClientProxiedBy: MN2PR22CA0018.namprd22.prod.outlook.com
 (2603:10b6:208:238::23) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR22CA0018.namprd22.prod.outlook.com (2603:10b6:208:238::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Thu, 14 Jan 2021 20:08:26 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l08uv-001NXw-Up; Thu, 14 Jan 2021 16:08:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610654908; bh=f8cJQO334QpnU3YwY9lpSaLe5gAXLQGzieDEWXFJoOY=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=XtrZ16PNSlECBtpw6sWOQrt9/nomh5wvfMI2PKi9Or/hA0b4xvJhWkPxKzRTOScLt
         KA2wV2x7Log1dFpiEWycK2RoFj2C86igxi4cK4HAgJHz0Xo9Hp7Fy/8Szwm9XeHjVR
         rS6qOzQpj9DPeN/d7L3gA9lMPwwfOqzOeYOZasaPnKYZNOy9ArJB2Kjs9/l7QAa73S
         OMDbQGyEcSImYI9QcOxFOV+WlVxaIz6ky8qay7CUeZ6fh1xbg3l+a5ewasKr7mRIQU
         ozBdzgoPkK7Np2Z+7/oIva9ZLehBS7FkyhDYBgbI3yB4t0487tLEdO1+J8xOLd0fPR
         MWAW6YxvMwgwA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 11:24:12AM -0800, Alexander Duyck wrote:

> > As you say BAR and MSI vector table are not so different, it seems
> > perfectly in line with current PCI sig thinking to allow resizing the
> > MSI as well
> 
> The resizing of a BAR has an extended capability that goes with it and
> isn't something that the device can just do on a whim. This patch set
> is not based on implementing some ECN for resizable MSI-X tables. I
> view it as arbitrarily rewriting the table size for a device after it
> is created.

The only difference is resizing the BAR is backed by an ECN, and this
is an extension. The device does not "do it on a whim" the OS tells it
when to change the size, exactly like for BAR resizing.

> In addition Leon still hasn't answered my question on preventing the
> VF driver from altering entries beyond the ones listed in the table.

Of course this is blocked, the FW completely revokes the HW resource
backing the vectors.

> From what I can tell, the mlx5 Linux driver never reads the MSI-X
> flags register so it isn't reading the MSI-X size either.

I don't know why you say that. All Linux drivers call into something
like pci_alloc_irq_vectors() requesting a maximum # of vectors and
that call returns the actual allocated. Drivers can request more
vectors than the system provides, which is what mlx5 does.

Under the call chain of pci_alloc_irq_vectors() it calls
pci_msix_vec_count() which does

	pci_read_config_word(dev, dev->msix_cap + PCI_MSIX_FLAGS, &control);
	return msix_table_size(control);

And eventually uses that to return the result to the driver.

So, yes, it reads the config space and ensures it doesn't allocate
more vectors than that.

Every driver using MSI does this in Linux.

Adjusting config space *directly* limits the number of vectors the
driver allocates.

You should be able to find the call chain in mlx5 based on the above
guidance.

> At a minimum I really think we need to go through and have a clear
> definition on when updating the MSI-X table size is okay and when it
> is not. I am not sure just saying to not update it when a driver isn't
> attached is enough to guarantee all that.

If you know of a real issue then please state it, other don't fear
monger "maybe" issues that don't exist.

> What we are talking about is the MSI-X table size. Not the number of
> MSI-X vectors being requested by the device driver. Those are normally
> two seperate things.

Yes, table size is what is critical. The number of entries in that BAR
memory is what needs to be controlled.

> > The standards based way to communicate that limit is the MSI table cap
> > size.
> 
> This only defines the maximum number of entries, not how many have to be used.

A driver can't use entries beyond the cap. We are not trying to
reclaim vectors that are available but not used by the OS.

> I'm not offering up a non-standard way to do this. Just think about
> it. If I have a device that defines an MSI-X table size of 2048 but
> makes use of only one vector how would that be any different than what
> I am suggesting where you size your VF to whatever the maximum is you
> need but only make use of some fixed number from the hardware.

That is completely different, in the hypervisor there is no idea how
many vectors a guest OS will create. The FW is told to only permit 1
vector. How is the guest to know this if we don't update the config
space *as the standard requires* ?

> I will repeat what I said before. Why can't this be handled via the
> vfio interface? 

1) The FW has to be told of the limit and everything has to be in sync
   If the FW is out of sync with the config space then everything
   breaks if the user makes even a small mistake - for instance
   forgetting to use the ioctl to override vfio. This is needlessly
   frail and complicated.

2) VFIO needs to know how to tell the FW the limit so it can override
   the config space with emulation. This is all device specific and I
   don't see that adding an extension to vfio is any better than
   adding one here.

3) VFIO doesn't cover any other driver that binds to the VF, so
   this "solution" leaves the normal mlx5_core functionally broken on
   VFs which is a major regression.

Overall the entire idea to have the config space not reflect the
actual current device configuration seems completely wrong to me - why
do this? For what gain? It breaks everything.

Jason
