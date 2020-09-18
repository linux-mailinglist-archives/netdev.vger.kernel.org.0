Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A806426FE92
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 15:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgIRNeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 09:34:08 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:9363 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgIRNeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 09:34:07 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f64b7420001>; Fri, 18 Sep 2020 06:33:54 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 18 Sep
 2020 13:33:53 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 18 Sep 2020 13:33:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qp/YIcX3q/ORdLdcJwgWXDWiTqaXTR75eeJpLWSGCymW0flxLN4aEYSfJvki/19VWlmOL6Gf/l9xht6ZPPdI4zYEzjAvl3SJF7fVogurcMrhpK90Wf8bs0ORZvRqLMFK/SHTrBKy3TK12dIcIH2PTnVeN4fe/Iw45vJHvOJKtuIsACbqCEEsdSL6ERwNqqGZVTQ/iD4MwW1LGEzTObaCUEdS2w/G/6d5EKcSDhTTdIEZrLJmlzdww5QV9QwbtCiUztdh7Gg13/hH3OH27++MFd4sUa31aQouMloqKxrT8us79eVi3CJYeYrvZj9ZCiFvH5TOPB+zpYn9gI67019hTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pfxcRqFEEs/hG1Ff146zc+R78OiquqRzWVL4UekYdbw=;
 b=TdQHNDVe3L7x8zW9P+l0dYWIFcA7DHUkBdqsNJ5oVqIpKLN7FKBOzgXXPRBoSnohCvmie9/9ky8ViTXUNRkjo4gz27iSTk9/6bFscCGS5ebWugAZ1loO0eSL2AtjY/3C+qrmp97wyZPNuuPtL4XPviDPsQfHb8VWDvcjFn0tiFmLx+SRnK5MI5s86w+H7G8oK7rpnpWVDNXOao84rKJkhb41RvjWG5+9y4NFQ17gEFdSYFFkubh9XM3GJSwXF51i0tDt0B8hh1z8/fa7pWQX1IuGwguqO88WnYoJY/kRURKKLZcRJNzc42S+XjYLhq4MpAKP5+LpdhZvDB1FrjH1RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4402.namprd12.prod.outlook.com (2603:10b6:5:2a5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Fri, 18 Sep
 2020 13:33:52 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3391.011; Fri, 18 Sep 2020
 13:33:52 +0000
Date:   Fri, 18 Sep 2020 10:33:49 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Doug Ledford <dledford@redhat.com>,
        Achiad Shochat <achiad@mellanox.com>,
        Adit Ranadive <aditr@vmware.com>,
        Aharon Landau <aharonl@mellanox.com>,
        "Ariel Elior" <aelior@marvell.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>, <linux-rdma@vger.kernel.org>,
        "Michael Guralnik" <michaelgur@nvidia.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        "Somnath Kotur" <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        VMware PV-Drivers <pv-drivers@vmware.com>
Subject: Re: [PATCH rdma-next v2 0/3] Fix in-kernel active_speed type
Message-ID: <20200918133349.GB3699@nvidia.com>
References: <20200917090223.1018224-1-leon@kernel.org>
 <20200917114154.GH3699@nvidia.com> <20200917163520.GH869610@unreal>
 <20200917230442.GZ3699@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200917230442.GZ3699@nvidia.com>
X-ClientProxiedBy: MN2PR18CA0012.namprd18.prod.outlook.com
 (2603:10b6:208:23c::17) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR18CA0012.namprd18.prod.outlook.com (2603:10b6:208:23c::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14 via Frontend Transport; Fri, 18 Sep 2020 13:33:51 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kJGWL-001FZM-Oe; Fri, 18 Sep 2020 10:33:49 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 379d46b7-dee3-451c-4923-08d85bd77b51
X-MS-TrafficTypeDiagnostic: DM6PR12MB4402:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4402CAF8093CA0FC2E748E1AC23F0@DM6PR12MB4402.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I//IJezzngAAbPJXhyvIQ+iIyefTdtQLF6YlU1pJFmFsL8bAbh1pQgt06TPK9CVzswTpC6xA8U2diDFTOyFeCJQqAAYy9yr+g1XEfN05w3dnkdfArMbvHyLiA8hffNsxukK0X5vA3WLaRf8p1cHMKP9Z4h4ZTn3uojJivL303hxSRIIf2GzgT98sG7msWifqjSJKOn0c2k3hBT1B8HUShtlPeGfw2eYucMKo44iSj6FnxVSp0mEI+njTDJByfwUOFtJ5OqjQLG+YTXcMsWZBVynFbMICq+zecPVlVbrawp1NpD7JKV+9iXeDwXiolpz0AAxGKBSkkxUpkFZ0nTjH8SlQNZvcKPQZhJ51JVj7kFv5gj59moz81W3cA5Gqo7pnk2eM6Jq4dv/jFTHfqK8MUA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(396003)(136003)(366004)(2616005)(4326008)(9746002)(2906002)(426003)(33656002)(9786002)(186003)(54906003)(36756003)(66556008)(66476007)(8936002)(66946007)(1076003)(966005)(86362001)(6916009)(478600001)(83380400001)(8676002)(316002)(7416002)(26005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: kBBI3dU225kvaoIsB9z8aT3VFI3KyLKWjjMA7pEcHDQTM2uOWbsICjWFGUhKhcSsGtHvS0x572bmaWe/OmHdyylYtvjuWE/BF9Co/c3pP9sRoUrKslw5UBr7azdIbqaUBNgF8Aw1woie72BPRrxvZhRAjTBmr54DWzGCPOWL+Hjyg81RNQYJYVoSzKq7U0g9ZKcI+EsvYRkv5TS9FkeKWZiTXS6bMYOKdWa+qr953NSa7oBy7kVkTmx17uAGNfX3ekbFa/dfZKbKXom4rLtNxeJuzfq7/1ASL92jAcYYews6xhI4M8X89wNdLs/WGh3/2eLjTMLMX/piv5sUgUrguZjZU6uvLd/ZDLeRkG9G8jXvEEe+izRm6q6wa9z+NRPwFRVjfRN6Le6Rs9lStaf3T7OMjzOKuYcIYqCEUAFrW8ht7qOBESm6BNv/QNWe+UXFR6u66pNwVzzGrd4yT7ER7ZOi1Iepa2CKKbhWGdC8d4ZQHY4ocycquKRsl0YGgFz0UWSIRatAB/O9NJknTVYVGpK7q6AoHd+cOxBDju+eAlOQr5KJnNcoR45FQ07YQOs+/jobxAON/B7xDjxowwGa/vpGmc2m6CH4lcYjdOpKofFS12u5F70SqY+6nWK18GOCXTEcUTA+fAgOJsM95U80OA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 379d46b7-dee3-451c-4923-08d85bd77b51
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2020 13:33:52.0814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s1LXrATpm7ONfSotziACa3p8gtfwfObGoe7IXMBI6CyQDiFMfe8N4lcpbZeiTres
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4402
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600436034; bh=pfxcRqFEEs/hG1Ff146zc+R78OiquqRzWVL4UekYdbw=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:
         Authentication-Results:Date:From:To:CC:Subject:Message-ID:
         References:Content-Type:Content-Disposition:In-Reply-To:
         X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Originating-IP:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-MS-Exchange-Transport-Forked:
         X-Microsoft-Antispam-PRVS:X-MS-Oob-TLC-OOBClassifiers:
         X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
         X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
         X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=ZAZ9W8tSFyqID+OKiF5Ftnmpex/esTEqxvOKoxTCITHjgOPXaYnE77tgry1JIipKi
         7k6JlI575Y/jeh7fz73IMlxjt287KAWad4twJCOiQFfNIrp46QFNWoICMByRWOOGk6
         qGgWCe6H3fEN7Y3c4OKwAGJmayN0gP4ffdfYYSi//vOXtC1GtlkWDO8syOBFBRwXnF
         Z61DaA4VV2vZv1ULMU6bZroeCFHOgIvBIpgEYYYSat3ik+y8XuD882+Lpevv2R8hYI
         InWzkeca4bWm6A/oSejz/a7MGDytosS8MGnzje1vuC7GYwK4S+OZvw+7oBhfvPOJiL
         XJTJiqWOtf+kg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 17, 2020 at 08:04:42PM -0300, Jason Gunthorpe wrote:
> On Thu, Sep 17, 2020 at 07:35:20PM +0300, Leon Romanovsky wrote:
> > On Thu, Sep 17, 2020 at 08:41:54AM -0300, Jason Gunthorpe wrote:
> > > On Thu, Sep 17, 2020 at 12:02:20PM +0300, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > >
> > > > Changelog:
> > > > v2:
> > > >  * Changed WARN_ON casting to be saturated value instead while returning active_speed
> > > >    to the user.
> > > > v1: https://lore.kernel.org/linux-rdma/20200902074503.743310-1-leon@kernel.org
> > > >  * Changed patch #1 to fix memory corruption to help with bisect. No
> > > >    change in series, because the added code is changed anyway in patch
> > > >    #3.
> > > > v0:
> > > >  * https://lore.kernel.org/linux-rdma/20200824105826.1093613-1-leon@kernel.org
> > > >
> > > >
> > > > IBTA declares speed as 16 bits, but kernel stores it in u8. This series
> > > > fixes in-kernel declaration while keeping external interface intact.
> > > >
> > > > Thanks
> > > >
> > > > Aharon Landau (3):
> > > >   net/mlx5: Refactor query port speed functions
> > > >   RDMA/mlx5: Delete duplicated mlx5_ptys_width enum
> > > >   RDMA: Fix link active_speed size
> > >
> > > Look OK, can you update the shared branch?
> > 
> > I pushed first two patches to mlx5-next branch:
> > 
> > e27014bdb47e RDMA/mlx5: Delete duplicated mlx5_ptys_width enum
> > 639bf4415cad net/mlx5: Refactor query port speed functions
> 
> Applied to for-next, thanks

Actually it needed a little help with this:

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index caa9c5966e44bd..a7e203bcb012db 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -535,7 +535,8 @@ enum ib_port_speed {
 	IB_SPEED_FDR10	= 8,
 	IB_SPEED_FDR	= 16,
 	IB_SPEED_EDR	= 32,
-	IB_SPEED_HDR	= 64
+	IB_SPEED_HDR	= 64,
+	IB_SPEED_NDR	= 128,
 };
 
 /**

I fixed it

Jason
