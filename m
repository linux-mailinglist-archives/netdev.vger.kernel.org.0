Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20F6B2DE904
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 19:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729856AbgLRSmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 13:42:49 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:9257 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbgLRSms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 13:42:48 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fdcf8000000>; Fri, 18 Dec 2020 10:42:08 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 18 Dec
 2020 18:42:05 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 18 Dec 2020 18:42:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GKt5a4dCkUsCD78m0BceBQrYm8SvXrtdzLZ8AncRvOhFsWtj3PsXbYrwjcnhlffwSSrvKw9j3zyZDsc8s0vzHEfh1hKeqMKGrKM+RykRg/MMWW66JLAgi37ug2YNxwnU+yZ9XWxvEIywoLLB3fAuYyS3KTM15NN2cWx3Ftc/5xAMWaB9Rigj7AeKtIL0YlI+Q/X3tEFt4XxdL7EhYy62j7KrplmLu67Ja6deUfnlX50ziUEIEgijh5Ns+NwopM8I81tObj0Tm3g9AzDI4SIavfgX8f3iBLt7hQP25FqTueDBl4O5Dch/KGaOwiTHC7TQob8z8nAVxgmy8Vkekmg/bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aTl/QYJ+E5k++MI7vs3WNbzaKDLhrayY6nvCdMDPaOM=;
 b=dSPnou+8RBDmBi0fFu81uZel/+TRN2x6mMjpCbRzu7noxmikbfzPj4lzpcQbpJV/OlbQ2K3/NJ9JS6QE5gO+3dTjIIXYtVOgFvt5tiEIpfTXRv3/2tToP7rjsE1iXICx1+BrWHavBHNKiqQhiGRXIAeT2q4VxZwBwKFNx5PijISz2FzKu3SF4lOStmHwnCmLoxa1XWueqwNRfSh7r3inFDAp7TB80T7XXzHs5TLryOZo5M3XTgwPjQOf+lu5LLRizJXmFQFZCgtSAuMgTuZO9vtl0lzar8azVdPSP5G2hkzJ3wWA9tCp8gLPXHxbFZoq9MfvzShcW4vScg2Ru/aTOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4265.namprd12.prod.outlook.com (2603:10b6:5:211::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.21; Fri, 18 Dec
 2020 18:41:52 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3676.025; Fri, 18 Dec 2020
 18:41:52 +0000
Date:   Fri, 18 Dec 2020 14:41:50 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Mark Brown <broonie@kernel.org>
CC:     Greg KH <gregkh@linuxfoundation.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        <alsa-devel@alsa-project.org>, Kiran Patil <kiran.patil@intel.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Martin Habets <mhabets@solarflare.com>,
        "Liam Girdwood" <lgirdwood@gmail.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        "Dave Ertman" <david.m.ertman@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>, <lee.jones@linaro.org>
Subject: Re: [resend/standalone PATCH v4] Add auxiliary bus support
Message-ID: <20201218184150.GY552508@nvidia.com>
References: <X8ogtmrm7tOzZo+N@kroah.com>
 <CAPcyv4iLG7V9JT34La5PYfyM9378acbLnkShx=6pOmpPK7yg3A@mail.gmail.com>
 <X8usiKhLCU3PGL9J@kroah.com> <20201217211937.GA3177478@piout.net>
 <X9xV+8Mujo4dhfU4@kroah.com> <20201218131709.GA5333@sirena.org.uk>
 <20201218140854.GW552508@nvidia.com> <20201218155204.GC5333@sirena.org.uk>
 <20201218162817.GX552508@nvidia.com> <20201218180310.GD5333@sirena.org.uk>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201218180310.GD5333@sirena.org.uk>
X-ClientProxiedBy: BL1PR13CA0352.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::27) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0352.namprd13.prod.outlook.com (2603:10b6:208:2c6::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.21 via Frontend Transport; Fri, 18 Dec 2020 18:41:51 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kqKhK-00ClnT-8I; Fri, 18 Dec 2020 14:41:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1608316928; bh=aTl/QYJ+E5k++MI7vs3WNbzaKDLhrayY6nvCdMDPaOM=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=bWrIeqWfA4PnBUSffPzpK9PmtPf0dVIRGWHdu01y3TXjej7LY3VIl4pAszfmiERWM
         9EEjSh0PuarVTix7DwYc2Mz7LshYg3+GJqsxDWm/ivF9tlVjrickmfII2RL2kCQqD6
         1Zd8ArG+/YhKkl83sEuHtQ/OD2+LoH8SaZyZybf8/05aCwbv5SF17hI4cr+Fsfp2zZ
         e1aiP5uXRJJMX2zmY5blyP6Sq+A+Rhz6lERW801vDQh5B02MS/wesLiowkI3scmL+8
         IMtn4xRKI9YIfz8pq9adkB2sy74hsHjlq5elq8rGcusv0/mvzGzrT4FBymQfCtTvCJ
         xrdg2OfBaaCVQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 18, 2020 at 06:03:10PM +0000, Mark Brown wrote:
> On Fri, Dec 18, 2020 at 12:28:17PM -0400, Jason Gunthorpe wrote:
> > On Fri, Dec 18, 2020 at 03:52:04PM +0000, Mark Brown wrote:
> > > On Fri, Dec 18, 2020 at 10:08:54AM -0400, Jason Gunthorpe wrote:
> 
> > > > I thought the recent LWN article summed it up nicely, auxillary bus is
> > > > for gluing to subsystems together using a driver specific software API
> > > > to connect to the HW, MFD is for splitting a physical HW into disjoint
> > > > regions of HW.
> 
> > > This conflicts with the statements from Greg about not using the
> > > platform bus for things that aren't memory mapped or "direct firmware",
> > > a large proportion of MFD subfunctions are neither at least in so far as
> > > I can understand what direct firmware means.
> 
> > I assume MFD will keep existing and it will somehow stop using
> > platform device for the children it builds.
> 
> If it's not supposed to use platform devices so I'm assuming that the
> intention is that it should use aux devices, otherwise presumably it'd
> be making some new clone of the platform bus but I've not seen anyone
> suggesting this.

I wouldn't assume that, I certainly don't want to see all the HW
related items in platform_device cloned roughly into aux device.

I've understood the bus type should be basically related to the thing
that is creating the device. In a clean view platform code creates
platform devices. DT should create DT devices, ACPI creates ACPI
devices, PNP does pnp devices, etc

So, I strongly suspect, MFD should create mfd devices on a MFD bus
type.

Alexandre's point is completely valid, and I think is the main
challenge here, somehow avoiding duplication.

If we were to look at it with some OOP viewpoint I'd say the generic
HW resource related parts should be some shared superclass between
'struct device' and 'struct platform/pnp/pci/acpi/mfd/etc_device'.

> > > To be honest I don't find the LWN article clarifies things particularly
> > > here, the rationale appears to involve some misconceptions about what
> > > MFDs look like.  It looks like it assumes that MFD functions have
> > > physically separate register sets for example which is not a reliable
> > > feature of MFDs, nor is the assumption that there's no shared
> > > functionality which appears to be there.  It also appears to assume that
> 
> > I think the MFD cell model is probably the deciding feature. If that
> > cell description scheme suites the device, and it is very HW focused,
> > then MFD is probably the answer.
> 
> > The places I see aux device being used are a terrible fit for the cell
> > idea. If there are MFD drivers that are awkardly crammed into that
> > cell description then maybe they should be aux devices?
> 
> When you say the MFD cell model it's not clear what you mean - I *think*
> you're referring to the idea of the subdevices getting all the

I mean using static "struct mfd_cell" arrays to describe things.

> Look at something like wm8994 for example - the subdevices just know
> which addresses in the device I2C/SPI regmap to work with but some of
> them have interrupts passed through to them (and could potentially also
> have separate subdevices for clocks and pinctrl).  These subdevices are
> not memory mapped, not enumerated by firmware and the hardware has
> indistinct separation of functions in the register map compared to how
> Linux models the chips.

wm8994 seems to fit in the mfd_cell static arrays pretty well..

Jason
