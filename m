Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CABC03111FF
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 21:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233260AbhBES31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 13:29:27 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:4563 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233160AbhBEPNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 10:13:09 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601d63e80000>; Fri, 05 Feb 2021 07:27:36 -0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 5 Feb
 2021 15:27:35 +0000
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 5 Feb
 2021 15:27:31 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 5 Feb 2021 15:27:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nZSU6hD4CiGfGVkoU/q8JW9xibxBQg56nhxhLlZlogY47m96Z+yoPqqAMlJnCRSDqFrFr8d7K3C4tbyPJLtPR32nXTtmS4kk+sR3GMcMHnowETrAucWUiL+++/fCjpWsC2nhcCeWjakP2bos9nHEJRJpCog8AQtLOhASjHYS9s3wok/0BRNbkZDL30CDnmZLpc3jx3xk4N0r4eg6DpjVn/oAoLvmHo/4MWRgN6o+WCQ1PScm5drzWq1W22TDaa1Z/1XA3NVQAOuiN3soOH9QJiit3cRKWeici0ShX9tNGBHprAhPuz/u59QQwSlPuYcMY643J7ghNoZj4xxSLzlOug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gi6UXFGeVnkoq/NRt6oJbd2UsKIvLSaFVbodx0sJS54=;
 b=Le0y+IId3XJlqzocH7cF+RD95O96Nx3CxBnByjFjvf2pG/N9fD17+pUleUni5zUHasz9F4fkbXPjbMxaBweKFWS+lp/0YY9AQz7cqAURI8eP4f3gzlVqblgT6BEiagmQnjJ2qPINPm+oM8P466YIFpjxQ5AsXJiy4+ZiYogIYpSZOeyrJRh+6i6Pohiv6mPlDlwF3ZYKhDRsXACmAE1f26qqYnfoymxDS+VmnA3CAmwfGJYGD6YsBk8LAOtaYgl/U9WnwVLWGu0i76MBA8CzJW5qIALdN77X7+23x2IfgqJ8USAnrion2kU0nSMUi6rzcwbrnDwaV2Ji2D6flq2UWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3116.namprd12.prod.outlook.com (2603:10b6:5:38::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.27; Fri, 5 Feb
 2021 15:27:28 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3825.025; Fri, 5 Feb 2021
 15:27:28 +0000
Date:   Fri, 5 Feb 2021 11:27:26 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH 04/22] ice: Register auxiliary device to provide RDMA
Message-ID: <20210205152726.GS4247@nvidia.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-5-shiraz.saleem@intel.com>
 <20210125190923.GV4147@nvidia.com>
 <ae763e223c0040259c63c1e745faa095@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ae763e223c0040259c63c1e745faa095@intel.com>
X-ClientProxiedBy: BL1PR13CA0086.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::31) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0086.namprd13.prod.outlook.com (2603:10b6:208:2b8::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.10 via Frontend Transport; Fri, 5 Feb 2021 15:27:27 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l8314-003sdZ-EU; Fri, 05 Feb 2021 11:27:26 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612538856; bh=gi6UXFGeVnkoq/NRt6oJbd2UsKIvLSaFVbodx0sJS54=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=Ur3+fzh2c+YqKSTN4u9Cp3oIr/EZMsHTcYOgrOUKC6jAbNJpriGcTsREvkLERerLO
         Rb1xDwzBqXU0lz40rycjRypY8PT38RGZe3P+W+7Fhqg44e9kZlg1emLX8Sr6lvp/tC
         qJ3W2N/5LVGUiiyAEbLnujLF4Rvaop69jnMYWHCXN/yy1Qu6jo7tDRIrfoq3ulQ7ip
         mzrN0EuFdfBQAqNGBPC2DvgaYqRGDxH9KrWeFyv9cDYsxszI1XWJguKtzgC3L6TeTO
         EAInd8fWGQD9MmwcqmV10k1ygnamqkumI5km5P1LCyxb1iT8wqwcPoHpxH2manHD2I
         1yI6ZYgCnkF3w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 05, 2021 at 03:23:12PM +0000, Saleem, Shiraz wrote:
> > Subject: Re: [PATCH 04/22] ice: Register auxiliary device to provide RDMA
> >  
> > > @@ -1254,20 +1282,37 @@ int ice_init_peer_devices(struct ice_pf *pf)
> > >  		 * |--> iidc_peer_obj
> > >  		 * |--> *ice_peer_drv_int
> > >  		 *
> > > +		 * iidc_auxiliary_object (container_of parent for adev)
> > > +		 * |--> auxiliary_device
> > > +		 * |--> *iidc_peer_obj (pointer from internal struct)
> > > +		 *
> > >  		 * ice_peer_drv_int (internal only peer_drv struct)
> > >  		 */
> > >  		peer_obj_int = kzalloc(sizeof(*peer_obj_int), GFP_KERNEL);
> > > -		if (!peer_obj_int)
> > > +		if (!peer_obj_int) {
> > > +			ida_simple_remove(&ice_peer_ida, id);
> > >  			return -ENOMEM;
> > > +		}
> > 
> > Why is this allocated memory with a lifetime different from the aux device?
> 
> This ice_peer_obj_int is the PCI driver internal only info about the peer_obj (not exposed externally)
> like the state machine, per PF. But Dave is re-writing all of this with the feedback about getting rid
> of state machine, and this peer_obj_int will likely be culled.
> 
> I think what we will end up with is an iidc_peer_obj per PF which is
> exported to aux driver with lifetime as described below.

I wouldn't call it 'peer' anything, this object represents the
programming API of the PCI device. The object and the API should be
understandable from the header files

A good design will have netdev also sit on this programming API, even
if it doesn't have the aux device. mlx5 used mlx5_core as the name,
I'd suggest something similar.

Jason
