Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0932FA56B
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 16:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406141AbhARP6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 10:58:23 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:11005 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405890AbhARPrz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 10:47:55 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6005ad7d0002>; Mon, 18 Jan 2021 07:47:09 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 18 Jan
 2021 15:47:09 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 18 Jan 2021 15:47:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MxOdRpP9CBrMYABsvprBuBDX+ne67cdaL6CWgMBggUYEcHtA8McC+ltofD54LG7VW55Aj81WrAt1Y7kpnqPjeJnbU0Pb69O3P3q9r2OzxiqRQG2IGDG6kEsAQs/qRouLWBa71FUqXDJl3raqDpvF9gtpkzbJlX+/WpIYLESxq15xr6fl7qSiyak+I9DRvF0UkiYvw9zmnsHpjD3Z6uTsBy+Iga06D/2zv9RENz3rxxK8jLg+iMkJwaQw+Kutj8m/+Flu+4Pp1p+QAby3Em29nhIJlIEsbG0wwYduKgVSmPZni2BznGH0eEE8JjT9atzJWITrm9sOBDDHujX8XQMvew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YEcQrRC3aVCEMun2EKQCxRLBrYsyH9MspeVeRJbkbcw=;
 b=EDrydWy7BTIAjNd+R1MYXw6PX5dXU35ECXhU3XnMHfu5QEoNrYZhtV3fk0191Sh3Y9Jn+01u3BRO/ngjhi+iOPsZ47ime6+7UYv8E9hycaZsTqB9P+eZgo6oLAIMmpafrG82QILG5zvMqLo8ZJSbMxO0y2tE49oLHCRVkaBvWYXeK+pAX3nt14kFJjt0caBLUF3wi6EGleJiYA0JJxbQuS+6d0KSnnY+dS9Oh29YgrXAbs4dfzQO/UKeGxljPPdeo7QlUtV2saodtzC0RQPYSelIr6CMhOO76VZaK8iIUnPeOtTINSuHqX+ssav2fDHE82rYYuRJSOLDd4rXJldRBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4010.namprd12.prod.outlook.com (2603:10b6:5:1ce::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Mon, 18 Jan
 2021 15:47:07 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3763.014; Mon, 18 Jan 2021
 15:47:07 +0000
Date:   Mon, 18 Jan 2021 11:47:05 -0400
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
Message-ID: <20210118154705.GK4147@nvidia.com>
References: <20210114164857.GN4147@nvidia.com>
 <CAKgT0UcKqt=EgE+eitB8-u8LvxqHBDfF+u2ZSi5urP_Aj0Btvg@mail.gmail.com>
 <20210114182945.GO4147@nvidia.com>
 <CAKgT0UcQW+nJjTircZAYs1_GWNrRud=hSTsphfVpsc=xaF7aRQ@mail.gmail.com>
 <20210114200825.GR4147@nvidia.com>
 <CAKgT0UcaRgY4XnM0jgWRvwBLj+ufiabFzKPyrf3jkLrF1Z8zEg@mail.gmail.com>
 <20210114162812.268d684a@omen.home.shazbot.org>
 <CAKgT0Ufe1w4PpZb3NXuSxug+OMcjm1RP3ZqVrJmQqBDt3ByOZQ@mail.gmail.com>
 <20210115140619.GA4147@nvidia.com>
 <CAKgT0UfAoGXQp9C0uL124GZfdhY6vvpk3NmCDqCpLET9dzAdRg@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAKgT0UfAoGXQp9C0uL124GZfdhY6vvpk3NmCDqCpLET9dzAdRg@mail.gmail.com>
X-ClientProxiedBy: BL1PR13CA0141.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::26) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0141.namprd13.prod.outlook.com (2603:10b6:208:2bb::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.6 via Frontend Transport; Mon, 18 Jan 2021 15:47:07 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l1WkD-002yn2-9y; Mon, 18 Jan 2021 11:47:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610984829; bh=YEcQrRC3aVCEMun2EKQCxRLBrYsyH9MspeVeRJbkbcw=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=Eg5Vj3wMTROKVjlcrEZ+kn064+iDF5M3EJNML+nzVqWp7tJcH9IYubtG7panaLr8s
         dVnn6v4mIMT+fthsuS6kMhyzWsZlkX360NEEQ83ijiKJDvP9GmYkx5Q4XDgmhUGqGj
         39kUYTHB8rIRxWZdOxvjVwbioAhzh0BBAgMu9Mc9HmezdklXbGuU6hGSlxxR50z+KZ
         NJdgwURtKf9so81Ky1uORdQKlawdcHZbBXoFS8ZD6sVMC77jABeovloEupC3Deaefx
         oudhE0HwPW+cyChjt42bA36w3/53/8BlbVLCItJzK3S7aFd0jdlPl67MXSgXFbKFGk
         pZYmYUeQsHWUg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 08:32:19PM -0800, Alexander Duyck wrote:
> On Fri, Jan 15, 2021 at 6:06 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > On Thu, Jan 14, 2021 at 05:56:20PM -0800, Alexander Duyck wrote:
> >
> > > That said, it only works at the driver level. So if the firmware is
> > > the one that is having to do this it also occured to me that if this
> > > update happened on FLR that would probably be preferred.
> >
> > FLR is not free, I'd prefer not to require it just for some
> > philosophical reason.
> 
> It wasn't so much a philosophical thing as the fact that it can sort
> of take the place as a reload. 

Asserting no driver is present and doing some SW-only "FLR" is pretty
much the same thing.

We can't issue FLR unless no driver is present anyhow, so really all
this does is add a useless step. If some HW needs FLR then it can do
it in here, but I don't see a value to inject it when not needed. 

Yes, if we were PCI-SIG we'd probably insist that a FLR be done, but
we are not PCI-SIG, this is just Linux, and asserting there are no
users of the MSI is sufficient.

> However looking over the mlx5 code I don't see any handling of FLR
> in there so I am assuming that is handled by the firmware.

The device does the device side of the FLR, the mlx5 driver should
trigger FLR during error recovery flows.

> It is about the setup of things. The sysfs existing in the VF is kind
> of ugly since it is a child device calling up to the parent and
> telling it how it is supposed to be configured. 

Well, the logical place to put that sysfs file is under the VF,
otherwise it becomes ugly in a different way. I agree it would be
nicer if the file only existed when the right driver is loaded, and
there was a better way to get from the PF to VF.

> I'm sure in theory we could probably even have the VF request
> something like that itself through some sort of mailbox and cut out
> the middle-man but that would be even uglier.

No, not ever. The VF is in a security domain that can't make those
kinds of changes to itself.

> In my mind it was the PF driver providing a devlink instance for the
> VF if a driver isn't loaded.

I think hacking up devlink to provide dummy devlink objects for VFs
that otherwise wouldn't exist and then ensuring handover to/from real
drivers that might want those objects natively, just for the sake of
using devlink to instead of the existing PCI sysfs is major overkill.

If we are even thinking of moving PCI to devlink I'd want to see
devlink taken out of net and a whole devlink PCI subsystem
infrastructure created to manage all this sanely.

Hacking a subystem into devlink on the side with some small niche
feature is not the way to approach such fundamental things.

I also don't know if PCI will get much value from netlinkification, or
if devlink is even the right netlink representation for PCI in the
first place.

Jason
