Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78DDA6CC7A8
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 18:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbjC1QO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 12:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232220AbjC1QOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 12:14:52 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21816DBCD
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 09:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680020091; x=1711556091;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=pdgNqQxj8vIV+Sm9ogUn+laxvs31+xd92ZB+ITnFAbA=;
  b=bg5yNt1Y2+by8iMfRAkMq28ulCqZdhqxu/9hEd2fJEcIIKD84ClGDHk7
   zdUJRZUijC4cUKYm4SBvQ6pwaoyifwJyMMTfcqMT5Ur9Hb5k7/RaGpH9T
   GrA+vdD+0sqdxQSHdO0Rl+UwvUXiRR/ZX8dUaFQg0LyG5uwF9hVKJQRY5
   VnWDrHApDHGBI8QZnn9ztSGBC8ruVQty3JjqtiyBeEUpD2SsKkXgY8kX4
   3EVF46nF6PzIYKA4wi3J81/RF1GhxzRnQ3IA9X2xdLwvYpFQfxyEzRYCu
   J3WLSgn1gJ20eZ7FEC6eP6G79mvRPr3LW4EideDFMUaSKw5r21I/yQBkA
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="368376026"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="368376026"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 09:12:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="677431217"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="677431217"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 28 Mar 2023 09:12:21 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 28 Mar 2023 09:12:20 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 28 Mar 2023 09:12:20 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 28 Mar 2023 09:12:20 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 28 Mar 2023 09:12:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M0V1DZLJC/lWOVcIeWcLOv2i8+reyl19ErONlkHslO9yQ/6in4PPzEGFuIFoMG6tqsmkDIMD4ZrPMQEnqXafpUNv29EfasCWie4FxgsVgjE9hVgcdIS+zeozrcpKXgkrRQhmG6F5ew53BgPmeBS4iQPQYh0P+LtJA1FcfUM2+vsVbBetYlzqaYkoxW8rTZQaKlW3utC74xHyw+xFYdPi6rgC0Jl2EUdKgZAmZ0NxFqW0Sz9fx+KPNxdzfdvrvXJ7V6KEaN2cjjFH8srFIhmh6MvTf+c0HBilAfjtpnTC56CBmfMQP4OES3cm3kfAdg4ITZVVWXdP0V1Vwp6u+w9VJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bk2mrP4TVSdzs+taqI3DxjYQO8xuCM9AQ6CRHe+LguU=;
 b=I01E5U76VW68L5ZyGRbaYqJKYBJMFcUWTtDtFHr4LssZaimwwh1C02JOYPNk+3C+LqaN3O51pYm3i9gzJUQaq1Srly53YXjNTkxnk045TaRHVnJvLR5t2UdZFsREus8ErH7R1tdzH1mju7RLaRS2423AUaUevTqHGY0ImFTQ7cqgnmO+iHmvMpLYs3MMYt5a5q9SGBd4+Tifrp+E2Tel8EX+LpqnvMnlr4DxEAS2UMxW7Sl5vN17VStk1Vy8w22gSUIbYMgcOfWF7Kz/2Me57kRH1Fbs20MwWPIUyFdN2x4AgMpc8Ytyu/dNq3Hsp7J0YR625DQyQbJu8euNUeX8yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13)
 by IA1PR11MB6194.namprd11.prod.outlook.com (2603:10b6:208:3ea::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Tue, 28 Mar
 2023 16:12:18 +0000
Received: from PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056]) by PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056%2]) with mapi id 15.20.6222.033; Tue, 28 Mar 2023
 16:12:18 +0000
Date:   Tue, 28 Mar 2023 18:12:15 +0200
From:   Piotr Raczynski <piotr.raczynski@intel.com>
To:     Simon Horman <simon.horman@corigine.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <michal.swiatkowski@intel.com>, <shiraz.saleem@intel.com>,
        <jacob.e.keller@intel.com>, <sridhar.samudrala@intel.com>,
        <jesse.brandeburg@intel.com>, <aleksander.lobakin@intel.com>,
        <lukasz.czapnik@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Subject: Re: [PATCH net-next v3 7/8] ice: track interrupt vectors with xarray
Message-ID: <ZCMR3/M+DFKRO0sN@nimitz>
References: <20230323122440.3419214-1-piotr.raczynski@intel.com>
 <20230323122440.3419214-8-piotr.raczynski@intel.com>
 <ZCBGfoqzid7PLcZE@corigine.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZCBGfoqzid7PLcZE@corigine.com>
X-ClientProxiedBy: DB6PR0802CA0035.eurprd08.prod.outlook.com
 (2603:10a6:4:a3::21) To PH0PR11MB7471.namprd11.prod.outlook.com
 (2603:10b6:510:28a::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7471:EE_|IA1PR11MB6194:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f119d4a-24eb-45ba-20a3-08db2fa7337f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fptu4khPRZGsB27wF5aV+FxPtiAV7Gz1iE1J6+JcpTGhX4wChtm4V2HXs5eAvuhAMqakpV5fFHeu0mL+ezOT5N2sC9rNRdnIXpm1qEPpN/yrQJz1tk+6et32MGoRxmcTNt7JpCVKJa9ZNGA/tBtcrwtfnrfkKJ3+ZBuhdfSCHZDM8md2bovz/rYppFF0SO5VtdVv8Z4G/cdBNhy8/P+wnnPW5Z8j3vCyH3lU0E0ceng9JfE63J4OejavOxcFVVEZefIbzsneqZ3KO+vaIpQnZQw8Qx3d5w13KZELdZ+wAPQoFT2NMd7F9qbMfskxtm4QbPrzYH/3AZ1+PTe3gOAokf4FdIjtZXsj20TbyQTS1zKLFvNXawbdladi5/BIZgZfiUM3gkvJn4xg7g+e4pUxGzX8WJTJk3jNMN8bQj/JOxk7oonOiF3VesntEuudG73D6rcBAtEDXVovVgjkKUyzb6y9NLSK+6aDa/b4g1e067TT/bvV/o2fG08PqrjoTGRwDglKzYy/VgS0zuHGPXyj4WWd7IdzEaqiRV+BWCpMJf1CLuo1zqnDk57IhsJOVlv7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(39860400002)(366004)(396003)(376002)(346002)(451199021)(316002)(6506007)(6512007)(6666004)(82960400001)(86362001)(5660300002)(8936002)(66946007)(41300700001)(66556008)(4326008)(6916009)(8676002)(66476007)(186003)(33716001)(26005)(9686003)(38100700002)(44832011)(83380400001)(478600001)(2906002)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cJD1jDj46hzvpRiAKPRa1rumIKK7D+bO0fjbiEB//CCyWvNluGhBTWNnFIJV?=
 =?us-ascii?Q?rM7IzA2z5loe8WW9LBoH9m6VWcsoG0XV69VmYVdoQ0yLtBolC7lPSGbAK7AM?=
 =?us-ascii?Q?EHHL9AqRLDKYDClEI8Mw8f6QT56V1SuBXuRV6OcDl30jGRqqwkwQNwLRDHT8?=
 =?us-ascii?Q?Q5NA1dt3LifVY3mmFox833ei5VlkSsMST7ZvLen+LCUn/a/fLwXVzM3FzSoB?=
 =?us-ascii?Q?byAn2fBPeAgrfbdnm91F3CjAzTG6l00BUVujVseVvjG8FkCmf4+07puyp8ql?=
 =?us-ascii?Q?T74gSoCNPt1msh6IfUuKLTOARkUZ17isnoWUVE9wi51NQwapgYF1o6WYfOMd?=
 =?us-ascii?Q?VUpyovlIYGJ7qT1rQ/ZifiWothCZJXaiaL4Fk0ASispdC/kw1Xm0NZpleVCB?=
 =?us-ascii?Q?ke4oeM+lbebAcCFyPNebzvqIII/pjPF6iX0GWLs4Du3SAh+5gT8COGb4/f/C?=
 =?us-ascii?Q?qJmAC4DX0ma7JJbrXNe4XFe9+MQeLwovPtmT/lIQp1GsQdmhbUueanfe4Xca?=
 =?us-ascii?Q?wxaaCFmdIm19Sm+9ulBV9CJXibYOO4r9Y+23heLbnv84FF5yRkBoAsVOuAyO?=
 =?us-ascii?Q?AcHohM2PN+si8u8KpGNCNG0C3gqdelLc25GxFV9UC1JS3KjFcDtn3pr1FL46?=
 =?us-ascii?Q?ibh3BJhjYn9Q9kFwbmwIOrXEGQ8H8PYvyG1fhlLshk+ojk2ezuq5NpcCkhTZ?=
 =?us-ascii?Q?1eqV3PFSOt0UrPtxp4FE9QNYsMXRJ2vVDgX2+gZgUcvK+C1MLbOgYqOUCX34?=
 =?us-ascii?Q?Vw44uotomK8vGctaZOrjU2ukOm2kZWv8b8+3V9n8ZiH1I+BASXJGlgmcRFQi?=
 =?us-ascii?Q?yA5Qk246S+JvassS1laqcoOXp4Dg20IdBozSiGAtMIVrRpWHAF+f8AuNM3ku?=
 =?us-ascii?Q?PrlMQcKeEEzpv/OYmpyLTpfwSjsTCG/nKYENszjDbgdw3kRp/ou+Ung5EqUc?=
 =?us-ascii?Q?T9LeIzV+Po0qS8Hl0IWMPpVWyGL5VfZzeZrcfOquGYlsSoKm8hm0xO44Cdnr?=
 =?us-ascii?Q?xqjyM64ErXPzMpIpcdthmTEMxbyOkQnMVkD02HgHFv0fhQbn5vPlRtoRIGd5?=
 =?us-ascii?Q?Uvj4XGGa9GO3c50kVdlODMh6e5tRSWdXOtXfxGHKa6cNKti+iy5C3OBqQygS?=
 =?us-ascii?Q?twKJJbIJJXiMGtNSuNjoCrR/7ERfOoVA+zpzNqUA0qBJn5i6E6y92SmcwsxZ?=
 =?us-ascii?Q?SDWta/wCInGBaFdCFRBTIYw73nd75cfJnmrEuDw8lpGNkQ2m0LFmDYoI4LpO?=
 =?us-ascii?Q?bz15uez+Ah97aeRN4u92EF9HZwq9cktbnGx9VSpOo0HoXGXTaRBrEXRGMl8o?=
 =?us-ascii?Q?syGpHWOV7FgscDbKhpQm1ghKprrDR3HDpx4wnE3/IwOn8YcRtvnw+MYHWf0X?=
 =?us-ascii?Q?jScr9EeEfrK9/Ul/ZZQaz9d/hJ7viwsxF3wichxNCiGuGcYywAduz3CNaSaQ?=
 =?us-ascii?Q?xCYoh7P3yXLzp7uMKxE9fYRw6xlcaGXSuatdwA3JxCKm3eabf5Idj1g90FJl?=
 =?us-ascii?Q?Z0mo0fbb/qXKmLnx7z3UB5rWLtn8C1UShdY9S4bew6myjZveDeqdkx6Yasbn?=
 =?us-ascii?Q?QWOn0jbQv4Cu7MNwtcDBhbwaoLkY1eGS4g6XFtxNudk+zT03v6n1eKHujvPK?=
 =?us-ascii?Q?Dw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f119d4a-24eb-45ba-20a3-08db2fa7337f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 16:12:17.5781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ik9wvBeUS20K69Gi9E3d4RINnfQZ9zEHgkEsfACUDgYpjRgsfDc1X6gl71XGaQgbKeimxI0qbrGzkZYtSY98MlbyRHYpX5r2ZIYudsr7Hso=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6194
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 26, 2023 at 03:19:58PM +0200, Simon Horman wrote:
> On Thu, Mar 23, 2023 at 01:24:39PM +0100, Piotr Raczynski wrote:
> > Replace custom interrupt tracker with generic xarray data structure.
> > Remove all code responsible for searching for a new entry with xa_alloc,
> > which always tries to allocate at the lowes possible index. As a result
> > driver is always using a contiguous region of the MSIX vector table.
> > 
> > New tracker keeps ice_irq_entry entries in xarray as opaque for the rest
> > of the driver hiding the entry details from the caller.
> > 
> > Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> > Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> > Signed-off-by: Piotr Raczynski <piotr.raczynski@intel.com>
> 
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> 
> I've added a few comments inline for your consideration
> if you need to respin for some other reason.
> 
Thanks for reviewing.

> ...
> 
> > diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
> > index 89d80a2b5feb..b7398abda26a 100644
> > --- a/drivers/net/ethernet/intel/ice/ice.h
> > +++ b/drivers/net/ethernet/intel/ice/ice.h
> > @@ -104,7 +104,6 @@
> >  #define ICE_Q_WAIT_RETRY_LIMIT	10
> >  #define ICE_Q_WAIT_MAX_RETRY	(5 * ICE_Q_WAIT_RETRY_LIMIT)
> >  #define ICE_MAX_LG_RSS_QS	256
> > -#define ICE_RES_VALID_BIT	0x8000
> 
> nit: BIT() could be used here.
> 

This piece is gone anyway.

> >  #define ICE_INVAL_Q_INDEX	0xffff
> >  
> >  #define ICE_MAX_RXQS_PER_TC		256	/* Used when setting VSI context per TC Rx queues */
> 
> ...
> 
> > diff --git a/drivers/net/ethernet/intel/ice/ice_irq.c b/drivers/net/ethernet/intel/ice/ice_irq.c
> > index ca1a1de26766..20d4e9a6aefb 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_irq.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_irq.c
> 
> ...
> 
> > +/**
> > + * ice_get_irq_res - get an interrupt resource
> > + * @pf: board private structure
> > + *
> > + * Allocate new irq entry in the free slot of the tracker. Since xarray
> > + * is used, always allocate new entry at the lowest possible index. Set
> > + * proper allocation limit for maximum tracker entries.
> > + *
> > + * Returns allocated irq entry or NULL on failure.
> > + */
> > +static struct ice_irq_entry *ice_get_irq_res(struct ice_pf *pf)
> > +{
> > +	struct xa_limit limit = { .max = pf->irq_tracker.num_entries,
> > +				  .min = 0 };
> > +	struct ice_irq_entry *entry;
> > +	unsigned int index;
> > +	int ret;
> > +
> > +	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
> > +	if (!entry)
> > +		goto exit;
> 
> nit: maybe it is simpler to return NULL here.
> 
> > +
> > +	ret = xa_alloc(&pf->irq_tracker.entries, &index, entry, limit,
> > +		       GFP_KERNEL);
> > +
> > +	if (ret) {
> > +		kfree(entry);
> > +		entry = NULL;
> 
> and here.
> 
> > +	} else {
> > +		entry->index = index;
> 
> Which allows for more idiomatic code by moving this out of the else clause.
> 
> > +	}
> > +
> > +exit:
> 
> And removal of this label.

Good idea, thanks.

> 
> > +	return entry;
> > +}
> > +
