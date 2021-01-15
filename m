Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCFE32F7DB7
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 15:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732508AbhAOOHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 09:07:04 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:4836 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731144AbhAOOHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 09:07:03 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6001a15e0000>; Fri, 15 Jan 2021 06:06:22 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 15 Jan
 2021 14:06:22 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 15 Jan 2021 14:06:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EoXYW0BHkS5248OT2b7ePeM04OsTeZXR2N1TQ/w41Nm9cyEtfZ5oLR/ccCj1unS0jJSBdX6RetTIBNUJzlQ2GgLoLlrOh7fALHNsxvW17bvZNHvMncTcXORJaSg4MEgvYTNkBGWuOKZuuwyyRQy6ZOlJAMDvQf0bNhYbbF32ICLLUrfTjAp3AXzjSgEhiWUqSIKqDWK4NF9f8ABRclQWhvML09SpkaWYmxCKAJEIfxx8quT1uJuD3MDggT/QLWGYbJJP8lIsBPrpiRGwxfvk8jnWvgl8spxe8S269vnDJ+oqdSJifc4nRfVpIAcWPZyfG8+uCTjnkUOEUcv4BwLykg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yiX7JWGbaXU4ASa3ptn4JXZPuhBwAL/I1rLSI8ise4U=;
 b=n1LizUMw1YVYny9zuAVuW5Du+o3hMo6+RKJLSfOZjYwVnprFMtfl5/NLNqT7wC67bvnz9WdLDzsV/DG4sA5uSm0GOmdRY4QfLa4vicHzZriu+iS+5yzroG78w713N//lB4ozQoWgWZhdPBS4Ownk8sMnmmmtNXxuIwqx20n31xSxy5kLDncgUVITKX47X9x/N97Y5dDkwwYMYQ0nsGMCVSKhBLQf5fICJBRFFhmOAtv+jZUreV16hmR19cJUDYu2QcRXfJ0qMDhExTRlCUukNr+KVhTv7nG8IFGvEYsnkx2PZZWhWA7613vn5YtSrlnumocv6c21zYdkAs6iqgAtcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4973.namprd12.prod.outlook.com (2603:10b6:5:1b7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Fri, 15 Jan
 2021 14:06:21 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3742.012; Fri, 15 Jan 2021
 14:06:21 +0000
Date:   Fri, 15 Jan 2021 10:06:19 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>
Subject: Re: [PATCH mlx5-next v1 2/5] PCI: Add SR-IOV sysfs entry to read
 number of MSI-X vectors
Message-ID: <20210115140619.GA4147@nvidia.com>
References: <20210114065024.GK4678@unreal>
 <CAKgT0UeTXMeH24L9=wsPc2oJ=ZJ5jSpJeOqiJvsB2J9TFRFzwQ@mail.gmail.com>
 <20210114164857.GN4147@nvidia.com>
 <CAKgT0UcKqt=EgE+eitB8-u8LvxqHBDfF+u2ZSi5urP_Aj0Btvg@mail.gmail.com>
 <20210114182945.GO4147@nvidia.com>
 <CAKgT0UcQW+nJjTircZAYs1_GWNrRud=hSTsphfVpsc=xaF7aRQ@mail.gmail.com>
 <20210114200825.GR4147@nvidia.com>
 <CAKgT0UcaRgY4XnM0jgWRvwBLj+ufiabFzKPyrf3jkLrF1Z8zEg@mail.gmail.com>
 <20210114162812.268d684a@omen.home.shazbot.org>
 <CAKgT0Ufe1w4PpZb3NXuSxug+OMcjm1RP3ZqVrJmQqBDt3ByOZQ@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAKgT0Ufe1w4PpZb3NXuSxug+OMcjm1RP3ZqVrJmQqBDt3ByOZQ@mail.gmail.com>
X-ClientProxiedBy: MN2PR07CA0012.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::22) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR07CA0012.namprd07.prod.outlook.com (2603:10b6:208:1a0::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Fri, 15 Jan 2021 14:06:20 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l0Pk3-001dEQ-UT; Fri, 15 Jan 2021 10:06:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610719582; bh=yiX7JWGbaXU4ASa3ptn4JXZPuhBwAL/I1rLSI8ise4U=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=EaocFYhsf6jVHLZdH6BI4fq2EqJKgaMFAvYjgMBaQQENmRUma/wIwfHJ1ng0OqIcA
         P3VlpOZn1ZcGsjj41mEec78VxR4RFXFIJvq/a/igw2T64LcpRlCROWqoHeJ/L3juW8
         nk3uGg5+oGMi2RqubmeyxLqpUD6eoEHuXZIB+7fgD8SMDSmteqU2P005lcPMJvpMgn
         qxINmPNnz63NkqnA+CCbZ+Lrnq3EZXdbn6tG6jne3wv2GBLMuYUKxrbM8Lkrdy9I8h
         E7ex7DLAlvf5KeY4VktCLklEddpmGMJHSYj9LsZi/ZtSGiFDXYg2oKM+bGDN6j3VwH
         35vmj5UxD45Sw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 05:56:20PM -0800, Alexander Duyck wrote:

> That said, it only works at the driver level. So if the firmware is
> the one that is having to do this it also occured to me that if this
> update happened on FLR that would probably be preferred. 

FLR is not free, I'd prefer not to require it just for some
philosophical reason.

> Since the mlx5 already supports devlink I don't see any reason why the
> driver couldn't be extended to also support the devlink resource
> interface and apply it to interrupts.

So you are OK with the PF changing the VF as long as it is devlink not
sysfs? Seems rather arbitary?

Leon knows best, but if I recall devlink becomes wonky when the VF
driver doesn't provide a devlink instance. How does it do reload of a
VF then?

I think you end up with essentially the same logic as presented here
with sysfs.

> > It is possible for vfio to fake the MSI-X capability and limit what a
> > user can access, but I don't think that's what is being done here.
> 
> Yeah, I am assuming that is what is being done here. 

Just to be really clear, that assumption is wrong

Jason
