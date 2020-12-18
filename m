Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4902DE770
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 17:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730270AbgLRQ3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 11:29:08 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:7727 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728286AbgLRQ3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 11:29:08 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fdcd8ab0000>; Fri, 18 Dec 2020 08:28:27 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 18 Dec
 2020 16:28:23 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 18 Dec 2020 16:28:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EPevoOdOl1MHEkyyJHj3GAQVvXey9U1v0yuHTwzSIffDZK2pfojNQD1LVoP2btOabQkt+jf0GdpmZF22ELg5HM4NJSH/YqBGTkCj49Tk7NoblvGrF8b8KkyQVI3Nb4yFzz+BaMIlcmQkSVds8h2CaqdhkVsg1wC7hmyTc8PXkWeQD02qmHpUZR7+JH8znMFBMBlikdHQ/WH6g3Q3rJfoB0/5aqPu1+x0pXiyzPdMgFul4HXrdMt/vM4RPQWaS/drhz0DVB4Kk/N6tahvS7Y50qgw5Ty+KG258Sri2WK0gr4BhJKSptmJzwiKTEvMFZBbIVVJkQlvnFpdjgKeT0os5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4fpFXmIERgQnZo7Ju+oBGZcu5IyKJrgxt66Mtoedtfw=;
 b=ftJ5n3sMLHf5hE6Gzok5oWem2ad2PLR7eqitDRTDIYSnc9Q/3o131jfxUGvWQXYXbzNpqY092Q0cBB2EwtZPuKdNs30/4h59wgg8oAVaKys3ap03GrupiTZP/2OqsZn7isiubh63hatwqey+hqUb89D0TbdtTek5mPsqsaytjQCcZNRxMs4hcw6VHSPm/5tsFtjzcJtrE5QZlooSksD1Xg+SQSNjkN9V//HCqwiGRie6b2ATzl3h1If5E/W6GtjK+QTnouFkxKGrRLi7T0TuqTKpyCFty1TaNmPttrzL0Y8jSZTXS9z2lZBdExm+zX8qWJYwqKXy4QXyPSBXKiLUPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3019.namprd12.prod.outlook.com (2603:10b6:5:3d::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.15; Fri, 18 Dec
 2020 16:28:19 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3676.025; Fri, 18 Dec 2020
 16:28:19 +0000
Date:   Fri, 18 Dec 2020 12:28:17 -0400
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
Message-ID: <20201218162817.GX552508@nvidia.com>
References: <160695681289.505290.8978295443574440604.stgit@dwillia2-desk3.amr.corp.intel.com>
 <X8ogtmrm7tOzZo+N@kroah.com>
 <CAPcyv4iLG7V9JT34La5PYfyM9378acbLnkShx=6pOmpPK7yg3A@mail.gmail.com>
 <X8usiKhLCU3PGL9J@kroah.com> <20201217211937.GA3177478@piout.net>
 <X9xV+8Mujo4dhfU4@kroah.com> <20201218131709.GA5333@sirena.org.uk>
 <20201218140854.GW552508@nvidia.com> <20201218155204.GC5333@sirena.org.uk>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201218155204.GC5333@sirena.org.uk>
X-ClientProxiedBy: BL0PR02CA0063.namprd02.prod.outlook.com
 (2603:10b6:207:3d::40) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR02CA0063.namprd02.prod.outlook.com (2603:10b6:207:3d::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Fri, 18 Dec 2020 16:28:19 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kqIc5-00CjNC-Ih; Fri, 18 Dec 2020 12:28:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1608308907; bh=4fpFXmIERgQnZo7Ju+oBGZcu5IyKJrgxt66Mtoedtfw=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=WMht87P7zFfRZu8ZTmtZGj32IEeVj5SPj5zlLD2XhATnkZrbSUZEGfBOULrR7OWN9
         QyeKzz3LzGo+N+SKCJCfhITsSaEeTJ0jpnTe/1rmrX6Chodgxfk++qDMGstaZVIcs9
         ioMonDFIMDczlGq2gmCbo2wYQwRUcBQo00Nd3jZ5WZG6jdod8NBCdmuvcTOCKz+h9t
         EKI3EybnO/KAcRIjMVhUI6qs8YjKVKcXQKgwPOf8v75GhgLwDNyj91vN5fzJKK9Xr8
         c6OJNvyT2/H1A1hAvBpqXrwA4R6NEJrRJRN4HguAw6YyZkURHt1boCaCQvqPXEDEPx
         zeyeXyVS49R/w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 18, 2020 at 03:52:04PM +0000, Mark Brown wrote:
> On Fri, Dec 18, 2020 at 10:08:54AM -0400, Jason Gunthorpe wrote:
> > On Fri, Dec 18, 2020 at 01:17:09PM +0000, Mark Brown wrote:
> 
> > > As previously discussed this will need the auxilliary bus extending to
> > > support at least interrupts and possibly also general resources.
> 
> > I thought the recent LWN article summed it up nicely, auxillary bus is
> > for gluing to subsystems together using a driver specific software API
> > to connect to the HW, MFD is for splitting a physical HW into disjoint
> > regions of HW.
> 
> This conflicts with the statements from Greg about not using the
> platform bus for things that aren't memory mapped or "direct firmware",
> a large proportion of MFD subfunctions are neither at least in so far as
> I can understand what direct firmware means.

I assume MFD will keep existing and it will somehow stop using
platform device for the children it builds.

That doesn't mean MFD must use aux device, so I don't see what you
mean by conflicts?

If someone has a PCI device and they want to split it up, they should
choose between aux device and MFD (assuming MFD gets fixed, as Greg
has basically blanket NAK'd adding more of them to MFD as is)

> To be honest I don't find the LWN article clarifies things particularly
> here, the rationale appears to involve some misconceptions about what
> MFDs look like.  It looks like it assumes that MFD functions have
> physically separate register sets for example which is not a reliable
> feature of MFDs, nor is the assumption that there's no shared
> functionality which appears to be there.  It also appears to assume that
> MFD subfunctions can clearly be described by ACPI (where it would be
> unidiomatic, we just don't see this happening for the MFDs that appear
> on ACPI systems and I'm not sure bindings exist within ACPI) or DT
> (where even where subfunctions are individually described it's rarely
> doing more than enumerating that things exist).

I think the MFD cell model is probably the deciding feature. If that
cell description scheme suites the device, and it is very HW focused,
then MFD is probably the answer.

The places I see aux device being used are a terrible fit for the cell
idea. If there are MFD drivers that are awkardly crammed into that
cell description then maybe they should be aux devices?

> > Maybe there is some overlap, but if you want to add HW representations
> > to the general auxillary device then I think you are using it for the
> > wrong thing.
> 
> Even for the narrowest use case for auxiliary devices that I can think
> of I think the assumption that nobody will ever design something which
> can wire an interrupt intended to be serviced by a subfunction is a bit
> optimistic.  

mlx5, for example, uses interrupts but an aux device is not assigned
an exclusive MSI interrupt list.

These devices have a very dynamic interrupt scheme, pre-partitioning
the MSI vector table is completely the wrong API.

The "interrupt" API is more like:

   mlx5_register_event_handler(hw_object, my_function);

Which would call my_function from some MSI interrupt vector when
hw_object has an event to report. There might be 1000's of dynamic
hw_objects in the system any moment.

As I said, I see aux device as being something that exposes a driver
specifc SW API, not a list of generic HW resources.

Jason
