Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD182F6651
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 17:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbhANQtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 11:49:41 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:18816 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbhANQtk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 11:49:40 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600075fc0000>; Thu, 14 Jan 2021 08:49:00 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 14 Jan
 2021 16:48:59 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 14 Jan 2021 16:48:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lbYJNqaOA/uwTTgDtg8/lf4grLqE3YQpi5NXoSX3+5SbIoiPBwThlPhSCqv+DRcoQ7aXVnGiP+Q50A/VHkTYh22c/Vu8vWAfliwpqKuVslclhz2lxpHiKhTLGOIJKmpytbQfUKzPuxTBEFzqg1NbDu7eewnvTLjEFPUTezpGovl45aOcD9Az+/guZoVPnG4FZ70R9iQTO68ACryIKq43Tl3KPslK/gNAd4rucNxxPtzSmd805ITisLPfTsiMAD8Kz3PlxzGL18pgB3yuNzjY8w0XfmQSs716MU87G75OYqwkNuC9xxXt3Ai+f28RroGuxZW8BNVdWwZYmUCBswtu9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hiASIEIaF5ivVqHCUiACO2OJS2o39vjpsPmKeKH7zf4=;
 b=LZ9nQULg4ziYZf+7V0iVWvPeFcgEu8yMS19KCb0u6zEF1/q8Q9JMDnA0gi9qLnIu9gub4IjNwh6n1WwclV42VCozG9GKu3cIW6+BERD61HZuMpyMFSablG70esAFIR/hDE/pkZ578KOgz8nGaYrE5uSy1+DrEv+AB/D7+DkDgRnfKt8lOpP7cc/bNN5cUta50P838YNnlV9CxkQ17dfaJeDFGf6jKf15AGqJ3ecpG4BDzpVEZ61kCjmD6NmYBc0rrgOhbXlJ+6E9azCNjjeCIrlkXT4QHoQRiMEEl4t6bN+ebmQz3Y9adwNyVExOzKukTsMkRb23fRT3CxHnChbiTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3211.namprd12.prod.outlook.com (2603:10b6:5:15c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Thu, 14 Jan
 2021 16:48:58 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3742.012; Thu, 14 Jan 2021
 16:48:58 +0000
Date:   Thu, 14 Jan 2021 12:48:57 -0400
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
Message-ID: <20210114164857.GN4147@nvidia.com>
References: <20210110150727.1965295-1-leon@kernel.org>
 <20210110150727.1965295-3-leon@kernel.org>
 <CAKgT0Uczu6cULPsVjFuFVmir35SpL-bs0hosbfH-T5sZLZ78BQ@mail.gmail.com>
 <20210112065601.GD4678@unreal>
 <CAKgT0UdndGdA3xONBr62hE-_RBdL-fq6rHLy0PrdsuMn1936TA@mail.gmail.com>
 <20210113061909.GG4678@unreal>
 <CAKgT0Uc4v54vqRVk_HhjOk=OLJu-20AhuBVcg7=C9_hsLtzxLA@mail.gmail.com>
 <20210114065024.GK4678@unreal>
 <CAKgT0UeTXMeH24L9=wsPc2oJ=ZJ5jSpJeOqiJvsB2J9TFRFzwQ@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAKgT0UeTXMeH24L9=wsPc2oJ=ZJ5jSpJeOqiJvsB2J9TFRFzwQ@mail.gmail.com>
X-ClientProxiedBy: BL0PR02CA0020.namprd02.prod.outlook.com
 (2603:10b6:207:3c::33) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR02CA0020.namprd02.prod.outlook.com (2603:10b6:207:3c::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Thu, 14 Jan 2021 16:48:58 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l05nt-001D6P-J4; Thu, 14 Jan 2021 12:48:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610642940; bh=hiASIEIaF5ivVqHCUiACO2OJS2o39vjpsPmKeKH7zf4=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=Iu1AnFLSoJxvchQbQu68opP+C9Jc3XxbUw8JoOnL7js80nWcv4ysOgrEEsKI9elre
         XNxIrJBqszikE7zZsk4guYyK50wOvDkY9Ut91MadM9/AnaZUbtaDV0eTIg3qVPgBIG
         8ewsDOFFP05HH4XhRsgIDxg+1Unitf3b6hfMcJ5RBHWBJoJa4a8As49g21/IyqLAKI
         zGsSi3ynhiCef6rn0BNrjxTz33GZN2NiqyokI/KDz20m38PFLQbWtiEI501mJD8bBn
         K18N2k8PAFUXz8hCSniPl93baOEnqViSSg8h/DoTVrHpJ2FmnjG3zl5sLh6/jdTfA+
         JZRi3t/3nxcdw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 08:40:14AM -0800, Alexander Duyck wrote:

> Where I think you and I disagree is that I really think the MSI-X
> table size should be fixed at one value for the life of the VF.
> Instead of changing the table size it should be the number of vectors
> that are functional that should be the limit. Basically there should
> be only some that are functional and some that are essentially just
> dummy vectors that you can write values into that will never be used.

Ignoring the PCI config space to learn the # of available MSI-X
vectors is big break on the how the device's programming ABI works.

Or stated another way, that isn't compatible with any existing drivers
so it is basically not a useful approach as it can't be deployed.

I don't know why you think that is better.

Jason
