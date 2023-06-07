Return-Path: <netdev+bounces-8833-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC8DF725F3F
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:25:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31507281072
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 12:25:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A8093444F;
	Wed,  7 Jun 2023 12:25:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462F313AD6
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 12:25:10 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7942A173B;
	Wed,  7 Jun 2023 05:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686140708; x=1717676708;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=X/APdZIeVzVRelXkd4Ezc9PDsLf/rPkK+McB98PDsxo=;
  b=nqlAKVBosINcZ3H0tSqfXDIRED1BulJWmjQXCXiMZHPvmNdHv83QJ8zq
   /GMT1fPUiCk672Or0v4cjt5gWWfWMINw8+rGpQs/0GW6zktIkjZugdlfN
   6bZ1RkoyGTGExJi45rMINn0KcbU8dtvU4LXJ46SESmrjnztzZCbth89tw
   Qu9pUMZ4qnIPGf9PvLW07Ey+GaFadvjzYuEPkC+J5WOJQBbIWDA7ccUel
   V8triw6OEBAwWOQeu4cxXPW6CysbFXC7ceHmWcq3jSgRg5uRPvDMlbCi8
   IOSFjwn00NtB+X29WTxLx7m/nlUWhqfElutJlS5uavnXxAcrHXh+VOIsP
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="359440507"
X-IronPort-AV: E=Sophos;i="6.00,224,1681196400"; 
   d="scan'208";a="359440507"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 05:25:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="883770726"
X-IronPort-AV: E=Sophos;i="6.00,224,1681196400"; 
   d="scan'208";a="883770726"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 07 Jun 2023 05:25:07 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 05:25:07 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 05:25:06 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 7 Jun 2023 05:25:06 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 7 Jun 2023 05:25:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l85VGo5pVaZQKF6v7ofOdl7pAWqH1d/injYHe43ugxExKf36R5JyIa4ju91/pfnNfi1bEWYDfuLoJBz9ObNMlKqZXJO0Ez4F20RWm50QzxD0QO/SkF+UQeSZ0Gxu8JDJPNFSgfYMTpengA+R6JB+Lcx0joW5dsWnRJ/dnCVTEGwLrQOUKEaJAPsrjxVCQdSL2siJuw76vnuyndvWAoigeXa7F63z1k8dGX7yRfewoWYFO/oX7MYoOMWnb5w+q0OQdCt0dpMXedbxgDEeEJTWIyxj6FKv7BtiEPdkt2t/7svSKRDN5gWwNHn/Apb8HemAdlFv7OxEecQL7QMLZwJkqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H4xMvWgSooyNO8kSokS7OK4ovH9WsbAB0uC17Wd0HJQ=;
 b=FSi6jXfd0On9vYe5SsFw7CujnNs1pBjtuZ9nlc6o3T7q3m22a9WWmXnkQETdByrhSUAwJjyU8eKNinf/zg2SAQExQaip7Iay4YWlym+W2XwdrpR5k9Fwgte5mhcN0GEXU3lz/L66Pm04ugIPzNt+xcCGivwNGci9fJkj5dAhzCLJNV/+42VvkyBh/kfXjUsQd+gBnod5WYq9XdA4Hfsjtl9POJSdNR39a0M4pHtVKlbme3WsHDy1/qQHe6flqNCqoaHvsK94OwcvBIkD3UuCzQpVB5uK+anfO9oLyl1hnzP/XDJCNcFgW+ZI5VspOMCUb3DAeLG9FeFUPagmENVHzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 BL3PR11MB6313.namprd11.prod.outlook.com (2603:10b6:208:3b0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Wed, 7 Jun
 2023 12:25:04 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6477.016; Wed, 7 Jun 2023
 12:25:04 +0000
Date: Wed, 7 Jun 2023 14:24:51 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Sai Krishna Gajula <saikrishnag@marvell.com>
CC: "davem@davemloft.net" <davem@davemloft.net>, "edumazet@google.com"
	<edumazet@google.com>, "kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Sunil Kovvuri Goutham <sgoutham@marvell.com>,
	"dan.carpenter@linaro.org" <dan.carpenter@linaro.org>, Naveen Mamindlapalli
	<naveenm@marvell.com>
Subject: Re: [net PATCH] octeontx2-af: Fix pointer dereference before sanity
 check
Message-ID: <ZIB3E+nyJE6YIcge@boxer>
References: <20230607070255.2013980-1-saikrishnag@marvell.com>
 <ZIBuIXH2M1KbCg06@boxer>
 <BY3PR18MB47075B84527934A80F4B4C93A053A@BY3PR18MB4707.namprd18.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BY3PR18MB47075B84527934A80F4B4C93A053A@BY3PR18MB4707.namprd18.prod.outlook.com>
X-ClientProxiedBy: FR3P281CA0190.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a4::8) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|BL3PR11MB6313:EE_
X-MS-Office365-Filtering-Correlation-Id: 53ed8c31-e90b-4c3b-7eb9-08db6752391e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x+ExFwEhZeuPAQI/aLtpql2Zvhc5Y+IhrDz759XmVRJz52bTCgmG9H9WcjkH6GFGxNSeJjYUfDzDsjJ1DdJ5FEvoXUoBl61QXDZsuBgv9o4Sfas63hoAKbExXViHr3A3/4Lg26Yxo5c79CBnvOayHA7CsC7HXwiDVQeNH5nhdWGCfPsDkXOrYAFbLKojM1Fb1G+qyCe/t58ixcGL/7uiTm8VKy3uaSXVreFBQBFOyHCDTP7wDgYHzBy58cMjOvlNiU9IWznoP7VQhPbxeuDAMRKNcRLBXFSGnuXnNY3SLAKj9GVmRz0f/3OikgtvaVk2TS7sunWoTGvLhF7BfSl4EDGrk5NafH537B96ZofhTC2VgM+sGboKRGg5IR96voua6T15CeC0IgZzNh+XC53zN/M4SFBc53IpfrgcQOIChatxUKGS9OH9PvKwZ/ySXP3P2RIk5ELWBHUDEB8wmDwL3jsk7lyUievfy/nnXgGrOrHDBTFHG/FRABQslQ+HLmfjuxt8O4Nf7NhydT2j1SPdSlN68Di+X6qtJzvn5qb25Lr+mTXtrMEx9uvcX8kKoc1hMZ1ZpEfCmReEiYzYtg0ktmB3AI3wKllDJ8qG5YmUsdE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(136003)(39860400002)(366004)(376002)(346002)(451199021)(54906003)(478600001)(6916009)(44832011)(8936002)(66556008)(8676002)(7416002)(2906002)(33716001)(5660300002)(86362001)(4326008)(66476007)(66946007)(316002)(82960400001)(38100700002)(6506007)(41300700001)(53546011)(6512007)(9686003)(26005)(83380400001)(186003)(6486002)(6666004)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ou/QJhWkTgoCOwBLsrUfJ2p3FmNNlBf5NBxrNZ81Lb0M/CUwTqqdVunKZq6c?=
 =?us-ascii?Q?sr0sCV8tJfQ3/3pGxHzorjPkit+TWf5P/PY7iPzg+uXRaPC+aeACjBBEPj8r?=
 =?us-ascii?Q?FeAwoHgSUZtVkhDYbXtxczWRbM3D9x99o5EqGW6RVOKtavw3PPuSn0KlDeKF?=
 =?us-ascii?Q?YFnGiifg3WvyS/5yMezBKo+B8rlFOQhX7hDXtv1ptJdJspWfBOK4gOhTf/F2?=
 =?us-ascii?Q?1wlCCLOJ1lf7wf/49EYoyDJGLWMG5hNmb4rh/Mit8xxY6jN3YGnlVU3juIL3?=
 =?us-ascii?Q?Fua5MpciAVyofUOLrKuFw9AOymMaiQb1hJnNelC5Qy+/O0mKXQ4kcIP7O5L+?=
 =?us-ascii?Q?iSPHh63cOcJlSjj1dfcbGf3hxt8JQ225dVj00L8CVYcYTmAJXiFYnvWrqRXi?=
 =?us-ascii?Q?CMQF9fFMJ4wNX30LEJevRIavqA7uM8grIkr/ZSdUdwC1NzEdO7NU3noaXNmo?=
 =?us-ascii?Q?3zJS0KGAXlOBfV/6Kb98aDgQM7a9QYcSn1Lu9+2pu5TlDglKb2jGbkvNgL2p?=
 =?us-ascii?Q?Pr1UhGp+ofZAILO/DNzGTihk4F2E+JkVayaETR1JvJaljwTMZMAFU5/jgjXf?=
 =?us-ascii?Q?KIGhKgUIfu3MNlHtXSGi2KMaUhVNzqUZsJ8UoDph5RZStqJkIbrX39iBKvdN?=
 =?us-ascii?Q?ATIzayR26iRIFEce+OO4xjMCSwL8s5je0bvawkoWOqaYmw9C7ymAxVzmxAOX?=
 =?us-ascii?Q?lYSK64m9B1Eprc2QLjX6zuqmsjWcr0MMYQ5MXNuYoFOZT2BTavyGxginiTiG?=
 =?us-ascii?Q?5/RxuWtN1wK08wD5tlNYqSHfsycqGI3DwDnY40LgW7qqM+Ss7yCv5j9e5vAD?=
 =?us-ascii?Q?5p4rnLOM98jpOZyeyViqX/ZkjbvTuoWgjLf0OFUM/eXhMExw1btVaoMd82Xe?=
 =?us-ascii?Q?mVBceax7KUAKlC6XJ31KmTa9PpAK/aVcFkjE4ZI/CaN/qOK6/S3n4QTiQ/MC?=
 =?us-ascii?Q?PEn1vCdSwgE+/T0JgrUhLofXZZzTfkaUhnpYlr223529bAH2wb7rHfehzrGx?=
 =?us-ascii?Q?ILtQokVsRHZWljCsho7EcLuYtu92DYle8MJvQa+T4ceRVS05YVxoB79TzxDc?=
 =?us-ascii?Q?uOzpTfGyFFKHpVsFhbGXiJcikCUaZZrsIkg9PbwihsrT423dP+BcR7GGr4eH?=
 =?us-ascii?Q?268nb/lL++xFNg9CquHGBnqZyK2fRZTd/CPN1/yyntxVHpdJXuoxu94ADexD?=
 =?us-ascii?Q?dCmikdKD9VDNM3UIq4RCmEHvJArxCejYBRMCqTjfuGpi7qDwi0HUK/LCiFvz?=
 =?us-ascii?Q?kN19ZyV0bf3vWyJEkGNc3WvjsIGKNqcd6blsfAydYeRZK+Kj3XZogOtdtxfM?=
 =?us-ascii?Q?LBn+KjwclDONVj0VMyLkV2ebQDJS4ntXKrYcNduA3Z6nMs3mncRKvmQIS3y6?=
 =?us-ascii?Q?0mugMWMDbvOi4JfOLBTQQlaBlYNgs5IqlK80dYxMCH50myN5h4cvP2QUS/pQ?=
 =?us-ascii?Q?9E6NeyZ2tYMXPzTO7nl1Rq2h1xiPwUyTf2dP6doQFsa8Z/OQ6OhuW8Sz5f+t?=
 =?us-ascii?Q?fXfgI/2sqbftwEw0Q+mVPduP/luDbn16OGCboArNnFchUjrjt0z2n3nv80Av?=
 =?us-ascii?Q?g4ApC67Xx9P6+nWAh5AQeNgy2W9q+ZIV0gO4Uu6OKh17b9mrh9X5dTBShbj+?=
 =?us-ascii?Q?zbk7Uim+101WMrVVUo72AW4=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 53ed8c31-e90b-4c3b-7eb9-08db6752391e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 12:25:04.7380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 779Per4Yd8emF1NDp7cLslkDUy85bHLV3kUT3mxTIuG4xr+XjBLeqqZrXUR6pow9xQhru1974ApnEGNB2ZXZAhyVClapLOBvtGsPBXkOeRY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6313
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 12:04:40PM +0000, Sai Krishna Gajula wrote:
> 
> > -----Original Message-----
> > From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > Sent: Wednesday, June 7, 2023 5:17 PM
> > To: Sai Krishna Gajula <saikrishnag@marvell.com>
> > Cc: davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> > pabeni@redhat.com; netdev@vger.kernel.org; linux-
> > kernel@vger.kernel.org; Sunil Kovvuri Goutham <sgoutham@marvell.com>;
> > dan.carpenter@linaro.org; Naveen Mamindlapalli <naveenm@marvell.com>
> > Subject: Re: [net PATCH] octeontx2-af: Fix pointer dereference before
> > sanity check
> > 
> > On Wed, Jun 07, 2023 at 12:32:55PM +0530, Sai Krishna wrote:
> > > PTP pointer is being dereferenced before NULL, error check.
> > > Fixed the same to avoid NULL dereference and smatch checker warning.
> > 
> > please use imperative mood, you could say:
> > Move validation of ptp pointer before its usage
> > 
> I will change in V2 patch.
> 
> > >
> > > Fixes: 2ef4e45d99b1 ("octeontx2-af: Add PTP PPS Errata workaround on
> > CN10K silicon")
> > > Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
> > > Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
> > 
> > Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > 
> > > ---
> > >  drivers/net/ethernet/marvell/octeontx2/af/ptp.c | 6 +++---
> > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
> > b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
> > > index 3411e2e47d46..6a7dfb181fa8 100644
> > > --- a/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
> > > +++ b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
> > > @@ -449,12 +449,12 @@ static void ptp_remove(struct pci_dev *pdev)
> > >  	struct ptp *ptp = pci_get_drvdata(pdev);
> > >  	u64 clock_cfg;
> > >
> > > -	if (cn10k_ptp_errata(ptp) && hrtimer_active(&ptp->hrtimer))
> > > -		hrtimer_cancel(&ptp->hrtimer);
> > > -
> > >  	if (IS_ERR_OR_NULL(ptp))
> > >  		return;
> > >
> > > +	if (cn10k_ptp_errata(ptp) && hrtimer_active(&ptp->hrtimer))
> > > +		hrtimer_cancel(&ptp->hrtimer);
> > > +
> > >  	/* Disable PTP clock */
> > >  	clock_cfg = readq(ptp->reg_base + PTP_CLOCK_CFG);
> > >  	clock_cfg &= ~PTP_CLOCK_CFG_PTP_EN;
> > 
> > i wonder if ptp_remove() would be able to free the struct ptp that
> > ptp_probe() allocated - then you wouldn't have to use devm_kzalloc().
> > 
> We intend to use devm_kzalloc() so that we do not need to call kfree in
> the remove function. Please let us know why you prefer to manually free
> the resource.

I just don't think this is really necessary as this object's lifetime
scope is clearly defined, i am in the rush now but i can try to come up
with further arguments later on if needed.

> 
> Thanks,
> Sai
> > > --
> > > 2.25.1
> > >
> > >

