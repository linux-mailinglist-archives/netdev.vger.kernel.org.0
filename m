Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91D0A417695
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 16:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346648AbhIXOLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 10:11:45 -0400
Received: from mail-bn8nam08on2050.outbound.protection.outlook.com ([40.107.100.50]:64113
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231683AbhIXOLk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 10:11:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nz3sOQNtR79+o2BKP3vrC1Oy3BpMp2CVS6HiIcZS3yUTGVG47+m505CVZdbM/5VxMLwLYvA9O784mVH9puAd5WMqoeI/rsMjePsRlp5Gh4KWZLej7CgXC74wk8rAKo9AGFWIOd7+SDZgsTX29EP6oy9Q3URUzXKI/RguHKZ1g4apksFZ/6rjb8qfl0hRHnUf7pAIE9MWiwXUEU8CFsg1M98yZ/CbmHBor1zkwxNv64xycxx9795X12rBMLlGdaVakDwBS5pZB10GzUW9mXKgrGKySGCLnMsWhx/+R1MD6vV8DXQVnnr5c+18u7VTe8ewzySp3BtgMoppq75sCxsGCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=fFIIiSt4bZzW8MsXWk9abxhLHHzzTzKjE2fZpv3F5lg=;
 b=jX6hTrP+ybjEF0Gs8hG1D+0hHuTd9TXsmMyMknJo8tkQxo/kiYCOwjHpT7q4FuZyxZKuzun2PClDcF2tgXxR25XbX99mGCOK+9W8HS9rB1f/XTuoH9McrzShFB4c6lmNNPbxv8EE4dRYJYSAG7ENK+cfFaeAFFqbh139NWx3sQkUM6UcxB8Jin7USEPtYOgUUeTP4HMhKiDXmAixsnVLmUyGJiJy4BiqP4iiECpo0yDhzu81bPfnQAlCkq/Htb5WTyBz03cBKw7UoWaSFNg8OVQVY1/m4jwBH75grFWsEuJ0677l/SWTGzL1Gfs5vvjmiuDzHCpfllOZLxWCm/4E/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fFIIiSt4bZzW8MsXWk9abxhLHHzzTzKjE2fZpv3F5lg=;
 b=kFkw+8pP2H2RSnyoCbxnq4IK94I5p/Ea5U+QMjyQRUe6y88RxJRhySXBh0KulrRZQfzkOe9GKa4h55Y5wMFcqH37Thf7q/Jn/lNL/ZPEmx6zp/9C+WZw1pwqDcXPTE8b2+PkuNI7u3l/3mXxGgNkRSkOP/VOP51w9HaER52UZ4vFWTNu6JEU1AaYrKxMZKsJnDh0kQREOmfG5SpnuxBXCnw02b+PBiUpuu+RSSOOW5MgsBX8EakzA9W1PZE5xOrmu7sjq4ptTZeJKODSQUmXT03b2Uhg/1wuhx2w1+iD2gwG2DkON1yPjhwcq7MMpCs96pnJBpADYvnA13YA0q7oRg==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5112.namprd12.prod.outlook.com (2603:10b6:208:316::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Fri, 24 Sep
 2021 14:10:06 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.018; Fri, 24 Sep 2021
 14:10:06 +0000
Date:   Fri, 24 Sep 2021 11:10:04 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Dave Ertman <david.m.ertman@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, yongxin.liu@windriver.com,
        shiraz.saleem@intel.com, anthony.l.nguyen@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jesse.brandeburg@intel.com, intel-wired-lan@lists.osuosl.org,
        leon@kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH RESEND net] ice: Correctly deal with PFs that do not
 support RDMA
Message-ID: <20210924141004.GA1237721@nvidia.com>
References: <20210909151223.572918-1-david.m.ertman@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909151223.572918-1-david.m.ertman@intel.com>
X-ClientProxiedBy: BL1PR13CA0356.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::31) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0356.namprd13.prod.outlook.com (2603:10b6:208:2c6::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.8 via Frontend Transport; Fri, 24 Sep 2021 14:10:05 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mTlts-005C75-Ug; Fri, 24 Sep 2021 11:10:04 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff3869d1-c19a-4708-dc56-08d97f650270
X-MS-TrafficTypeDiagnostic: BL1PR12MB5112:
X-Microsoft-Antispam-PRVS: <BL1PR12MB51121B8646F67E720F34A043C2A49@BL1PR12MB5112.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4mdJwUVunVpUI332J+0nD0Cz9JA/1Njjj7PrcCb0MkK9DuEVW094M6xmn+iaBrZWNbBQmgLUcG0MqTrg3O6rLmuVta5kx6V9hYjpq02/FYD6mwGeTuj6Dz8az74wUaw6ycUPripfSpshsm23CpCLi8QtJqpd57VAj0U4JXR972tD4lI5BY482M1hv6LmgClxREXlP874JLtf4t5kmKg/0BKmL+9DYE8fNeDNviewW1LBGgW1AiGy+usVJQnDxumkgLxYyAu5LV5YwIe9a142UH+Pfblgs4wEZEvwjS5WNoL8oVCq7UpSsyeR/sd+tkZL4cpGPMgDTHhW/Oj8n1wrw2WCcDfMPXU5opkA2VLf2rq31LPbjwQ9FH6a8sTYBsIOd7VO2A4JKOW+X2BJMbgTiIdEpRi3r1popbGezFHnTQluvc9JWpWQV/apttqbyVan/CX1s4PUbRddxROCFtn+lWGJ+NSgHp12ZY5l0aLbdi7n+fbf2Zwhu3vYPOpqekKaEtbphqPNTE8wTpD4Y0BMlyoTQ33v+FTq+JPvYs5zhWFG7kljs1hc3KYR69PbeI7jEl8cUGhCkwb2lkmF6cYuJB/NN5YgbIvi79BJDJg6dU0ZwEkI5mOY4vlBJkMIQ+MMtht5l7e332hMV2WArIwkcQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(6916009)(26005)(9746002)(66476007)(86362001)(66556008)(36756003)(5660300002)(33656002)(2906002)(4326008)(186003)(1076003)(316002)(8936002)(66946007)(38100700002)(83380400001)(508600001)(426003)(7416002)(9786002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cHj1hn4REdQ23Ua8yEGB0/ZkmssLqtXjTADonzM9invMSBP2DdTE3VUItGcC?=
 =?us-ascii?Q?f+tQyFZk7Oq5sT4wwkn1Oa8I+EuRj2iUyfCFhwAWoD40sm2HRrOaTvjVixkf?=
 =?us-ascii?Q?a6IL7H7MUMQNJuxfGpO+n18WiFjtI7ehIkTOClIciEFiZvwuC26YVnUN+nwz?=
 =?us-ascii?Q?+nslbb106KZ7Np7xIoDNzfKSmVQq4Kn4xUN9ffGAuQWeFZW552sLVIITjd6a?=
 =?us-ascii?Q?ddUbqobGbfqB9l9SM3bU5wtpCMEuNib50UF4l26TbmpFPeWUhKP/lys3liBg?=
 =?us-ascii?Q?gvWWzL0DezehLJzG2mmHw+Tofz1svNpnu05yhK0pidHzGOOzp+kxwEiXoDEC?=
 =?us-ascii?Q?pUPUZeZIbbCOTgfm3XZuZWkwryFYv4J8L6945cG2nTPx/xhmekeQAq084sWy?=
 =?us-ascii?Q?fLp92YiCdK0UeAOOV+XXzpQhT1jlratoGu/YTpmiOJcNvYm5qndL3teGcvZL?=
 =?us-ascii?Q?m5LlzmGSlMFIWSfSdBvM2+igpsW6e8wLXuT0Cdtr3AIK0PYpYa5IYfXfHXxx?=
 =?us-ascii?Q?DXIlKCkUDLtY9AQvPm4q71UUHmca9RmAbfe8wun6WfrCQtdeAsq3ZrQTrieD?=
 =?us-ascii?Q?xsxYlh/lKPCXCYgcEU30mN5oG9mFjb18zlWy3EJCkKHjC5Au52ECCv410EPM?=
 =?us-ascii?Q?qd2HF3QNDxL+uaMSmim/+MK9SClQ/Jm2H5VIhrAwf0Jv7vFZ8CR5FP4aO/sf?=
 =?us-ascii?Q?+8QjzCzQzOEK2n5gKcfM8hIKm3UR9Yet/iirZp1gYt7FikFG+D/QTcHOprcy?=
 =?us-ascii?Q?SUxWmkawDkiE4eIhwp8vXtVhpH0y+J9FrSY4soJNOH8ykv9K2aPQQrpRqoY3?=
 =?us-ascii?Q?JdYa5nsP7aARhwHxcJJvHZ+7MlpsLc/80JcAHnOiCplfmtGEGjhpVMsRjNv+?=
 =?us-ascii?Q?yO23Vv9wU8CEnYmiSbWpx66NxSPNkTaLyP+Jtm9Z9rtFIpCy7J37BDst6wE/?=
 =?us-ascii?Q?gJvTupIEI9bwNi9i+kdik01ZoiDUlgvvEkL1YfagiyqSUiT6z2ZGhZTibFsj?=
 =?us-ascii?Q?8yZAPB12vAgV7VdKmfyqAp7GlQzicQwS6XVHLFRzau92QzdmvEBfUXqKdjr+?=
 =?us-ascii?Q?Sp64MipqYr3Gr838HP+SRX9mH8exko2/adhM7dED18k9ceQzb4RARq38vpId?=
 =?us-ascii?Q?nkHzPqord0sOVITVbo7Ak/0WOnX2WfhowNUoX+Blb7RObuK5+WaYjaE5JSyL?=
 =?us-ascii?Q?pr5357C5ys1p7pJKmMkT2pYOYX/fJdooglwq1gc9BMf9BycSVwwXC10X261t?=
 =?us-ascii?Q?lOzn6aBhty+nDyN51mi1KLccYgpokJ83FHS05JD+W07FvRDIK9CBxcvgIGmF?=
 =?us-ascii?Q?al7XHP7tP0NLztDIi81N1FXv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff3869d1-c19a-4708-dc56-08d97f650270
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2021 14:10:06.1609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: isEF8Hb1gvmEFAmZCc3iYzwGBVDKUo573WXUaiBefiQdjV6MK/CBHRyHlciUZoWt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5112
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 09, 2021 at 08:12:23AM -0700, Dave Ertman wrote:
> There are two cases where the current PF does not support RDMA
> functionality.  The first is if the NVM loaded on the device is set
> to not support RDMA (common_caps.rdma is false).  The second is if
> the kernel bonding driver has included the current PF in an active
> link aggregate.
> 
> When the driver has determined that this PF does not support RDMA, then
> auxiliary devices should not be created on the auxiliary bus.  Without
> a device on the auxiliary bus, even if the irdma driver is present, there
> will be no RDMA activity attempted on this PF.
> 
> Currently, in the reset flow, an attempt to create auxiliary devices is
> performed without regard to the ability of the PF.  There needs to be a
> check in ice_aux_plug_dev (as the central point that creates auxiliary
> devices) to see if the PF is in a state to support the functionality.
> 
> When disabling and re-enabling RDMA due to the inclusion/removal of the PF
> in a link aggregate, we also need to set/clear the bit which controls
> auxiliary device creation so that a reset recovery in a link aggregate
> situation doesn't try to create auxiliary devices when it shouldn't.
> 
> Fixes: f9f5301e7e2d ("ice: Register auxiliary device to provide RDMA")
> Reported-by: Yongxin Liu <yongxin.liu@windriver.com>
> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
>  drivers/net/ethernet/intel/ice/ice.h     | 2 ++
>  drivers/net/ethernet/intel/ice/ice_idc.c | 6 ++++++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
> index eadcb9958346..3c4f08d20414 100644
> +++ b/drivers/net/ethernet/intel/ice/ice.h
> @@ -695,6 +695,7 @@ static inline void ice_set_rdma_cap(struct ice_pf *pf)
>  {
>  	if (pf->hw.func_caps.common_cap.rdma && pf->num_rdma_msix) {
>  		set_bit(ICE_FLAG_RDMA_ENA, pf->flags);
> +		set_bit(ICE_FLAG_AUX_ENA, pf->flags);
>  		ice_plug_aux_dev(pf);

I agree with Leon, there shouldn't be a flag for "aux en". aux is
enabled when a device on the aux bus is required. It should all be
rdma en, which already seems to have a bit.

Th only existing place that uses aux_ena immediately calls

		err = ice_init_rdma(pf);

So I'd just delete the whole thing and use rdma_ena. Frankly it looks
structured confusingly, the mlx implementation is better where this is
one function that synchronizes the aux bus with the current state of
the driver - adding/removing as required

Jason
