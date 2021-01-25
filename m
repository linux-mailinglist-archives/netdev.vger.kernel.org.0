Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA88C304A2D
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 21:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbhAZFK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:10:26 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:8647 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728862AbhAYN3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 08:29:50 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600ec78d0001>; Mon, 25 Jan 2021 05:28:45 -0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Jan
 2021 13:28:44 +0000
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Jan
 2021 13:28:39 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 25 Jan 2021 13:28:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I7DZ9NSjmqGuDD7B/Ug4M9mIN1sCarzphR8mOb1F14r0mG0iufjO96abMFnvj0Omy5mDTARChjXQDa9XlBC1jeVoPfgRius2zwXsSl1JHZ5MRsmf4Wa6oAhv+8BbLOF4nocHpw7eHhIlLd+ibYyFuNlu4zHnER6I4BcDpc8jUwyweSsgaD/YvKYh7v2JazVlfaXZFDTh9w6tcmerRBLfBB/vERfllVDvKTRLMBoeaGk1GrBrLoCx4NF8FdGyqPp22Gi0CTgrh8NAm+A1aQiBxRe5C35C9yDqoHxMl62XmWKJfNJPRPY3LYQzEhJMzfFQaa4jQVielbxOLCCkxXjytA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RQboH8fQ2uimuNIi08Ed1OHL6/anDz3N6HKmiRWJRKA=;
 b=dgjOaf3hSNzY6CRSLnuVc3U18lkrnZSQEB/anHlyTosdAH4KEKVP+LEfhWme/cjNyGanl726QveC0pC/b4csllWWNFBCq3OQvFnHEzzN1Easu0H5LMdfHd/4mM7NeFc3lL2++l9hoxPidK5j+JAXAe1DLJmDegM5HGHIKYjhFySXNizc8bWb60rly7P0+AqNtbQBp8Tjdca18ESrpLNDsn1jPi6AQKuwEQgp6vCsKAD9Ub6gc71fbY84jdJkFaO+ZrbKJI+c8n25FqR1ZIEs4BHWBXe4i3zaS4XX2IhbXgatp00xKxOKWHyFq8AybR3QZtG33y9QzLDbRMcCV1ynrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1340.namprd12.prod.outlook.com (2603:10b6:3:76::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Mon, 25 Jan
 2021 13:28:35 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3784.017; Mon, 25 Jan 2021
 13:28:35 +0000
Date:   Mon, 25 Jan 2021 09:28:34 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Shiraz Saleem <shiraz.saleem@intel.com>, <dledford@redhat.com>,
        <kuba@kernel.org>, <davem@davemloft.net>,
        <linux-rdma@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <netdev@vger.kernel.org>, <david.m.ertman@intel.com>,
        <anthony.l.nguyen@intel.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>
Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Message-ID: <20210125132834.GK4147@nvidia.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-8-shiraz.saleem@intel.com>
 <20210124134551.GB5038@unreal>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210124134551.GB5038@unreal>
X-ClientProxiedBy: MN2PR15CA0047.namprd15.prod.outlook.com
 (2603:10b6:208:237::16) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR15CA0047.namprd15.prod.outlook.com (2603:10b6:208:237::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Mon, 25 Jan 2021 13:28:35 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l41v0-006Uxg-By; Mon, 25 Jan 2021 09:28:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611581325; bh=RQboH8fQ2uimuNIi08Ed1OHL6/anDz3N6HKmiRWJRKA=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=Y5WKyAUndplq85BXYqVgpLFUNoXpCYVs2ZAmFwipvz24GtmQs0u2PrsWwzkLW8tVe
         Cltg1YG+hIa+TPidGZ/xLhlFyDHXnH285DtH0LwvI4Mi/3xFmvWE/2IO3tEO6j2tyF
         BNUZ44zTEq28hVJ08fv7rhFvm2XHx4Xfw7S8VSis9R71YQQMpZM3dzu1i2JI7bjlw4
         Nl7HHaKZ4Imz+WtyYWpkOIch8yuZ9LQonQToqlMJmLmIWnauc8vhMgRKvB1bnyKRRZ
         kyJy3rqU9900fk2skj4zlajm9/K1F9NR3IhT9B0RVCP0J0SCaqRyL1uG/70sA8qGYF
         oDfgb+8SnqCwg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 24, 2021 at 03:45:51PM +0200, Leon Romanovsky wrote:
> On Fri, Jan 22, 2021 at 05:48:12PM -0600, Shiraz Saleem wrote:
> > From: Mustafa Ismail <mustafa.ismail@intel.com>
> >
> > Register irdma as an auxiliary driver which can attach to auxiliary RDMA
> > devices from Intel PCI netdev drivers i40e and ice. Implement the private
> > channel ops, add basic devlink support in the driver and register net
> > notifiers.
> 
> Devlink part in "the RDMA client" is interesting thing.
> 
> The idea behind auxiliary bus was that PCI logic will stay at one place
> and devlink considered as the tool to manage that.

Yes, this doesn't seem right, I don't think these auxiliary bus
objects should have devlink instances, or at least someone from
devlink land should approve of the idea.

Especially since Mellanox is already putting them on the PCI function,
it seems like the sort of pointless difference AlexD was complaining
about.

Jason
