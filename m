Return-Path: <netdev+bounces-8154-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DEE59722EA9
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 20:27:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 46DFF1C20CB5
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 18:27:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3C1623D45;
	Mon,  5 Jun 2023 18:27:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0467DDD0
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 18:27:55 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7422ECD
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 11:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685989674; x=1717525674;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=rkjxUh77Jj3tGicIg10/wBLmu9XFZqhFPVqYQlyohn0=;
  b=AAZ7t9fK6PuJ+IMztantXhT4gbw2uVfPo6LJKxgK22Ip7/KqhX+1aN55
   JmcrK3fDA+LeCL7PIr3qilYCNuLDjh2VdXr2EwX49cfoXUh+ihSIBNhPi
   aqrv8hV70ZzyXTxe3tBDhj4zuKLwnXCM5TNWupHvXsFj0pd3+34yIYRK5
   NAkH+VCKne3fK7VBjXTC7PtPJl4YnMIsid3jchvABsZ0m0gc7zqO4WYrA
   vxLFyus2+A64zowDn+I7/ncR+722XlG4fiQAdIKx+/36wwrQIjqJDUUBY
   fYky6LTfkTpOKQ/CVcMRYx44wsZcXFtaCDPXNbVy9TXdRxF7+0VR31kMv
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="353938118"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="353938118"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 11:27:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="821281146"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="821281146"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 05 Jun 2023 11:27:48 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 5 Jun 2023 11:27:47 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 5 Jun 2023 11:27:47 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 5 Jun 2023 11:27:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jhF3PRvKtro02+wl1g5A+X8oZp9A3dsdGqphCYyqMaaypBtIi6Rcat2OfNDZpHroawwWIFbZIBLwUlZb9QqAd4j+zGCHJfAhmJoluo+0P2uI5nbSZHQhlWdyGSc18YBJIFmio+JMPubXuUXKmLJopPT5EWXi4z2DmQ6/UFPLw766B3b4ZYhObAEiL07BX/MWNOIWl3gOvVKPCka6dLbJj9vus6PYylYw0Ntvnluko1AjPrcuBvP9BZiauq0Caxfxeng2lFeONl/uB142+f5FE2QP1/2IF4vd/sr7a1c4VTLcszzt7v0sJEzONyjHgYmB3Glnx2KHe/FXTGj0R3eQCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oBJhwmIS9TeFMVR7xGrgZLZE5Gv2Cc9k2r++GGVT728=;
 b=f3B2o/rYloJIUgZPL7IkPjFLZXixidzTgP5hn6ABHyIGbgb0eAEEBHS/0BSKQ+u/x5H3I/4AJQB8/R15vSwc36Sj8Dd8AOXD7fW91qGZPUzfvbhwHPs5dzhPLMkwAkMRFwzWF2jTF2aI6UY+J35kD7B3JEXtxvlTiJFiv9gCk9JU5OXIevt8n81wx1Oju89rJAHbLU/sMHD3yJXlHVlDZfx/5LcFIipN392VQDpt0ZJjyUuEAaVOhUzgZgKk881sPwJPiv+kkdpmxAOygWiiIGdud/Jsco0vrC81k+ZbDftUOZQRwtBiWECt31UatQxpk+XzuyclMeXHTOjtPIR8Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 CO6PR11MB5666.namprd11.prod.outlook.com (2603:10b6:303:13a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 5 Jun
 2023 18:27:46 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 18:27:45 +0000
Date: Mon, 5 Jun 2023 20:27:38 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: =?iso-8859-1?B?Q3Pza+Fz?= Bence <csokas.bence@prolan.hu>
CC: <netdev@vger.kernel.org>, Richard Cochran <richardcochran@gmail.com>,
	"David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
	<qiangqing.zhang@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
	<kernel@pengutronix.de>
Subject: Re: [PATCH resubmit] net: fec: Refactor: rename `adapter` to `fep`
Message-ID: <ZH4pGitjMPiiGgE8@boxer>
References: <20230605094402.85071-1-csokas.bence@prolan.hu>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230605094402.85071-1-csokas.bence@prolan.hu>
X-ClientProxiedBy: FR2P281CA0146.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:98::7) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|CO6PR11MB5666:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ba64187-cc30-473a-eab5-08db65f28ee1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6xrKmlPgzpJqoMrdre6hlC6lCpP8Kmk5P8L3/4T2vMe49vYoxmyKrKGtz5tv0iJNKvZIA5XURiTWHK6Ry10DxnU5V6HeHtUcobZGOppo0SoDxGLstdot5Yz+qKnBo00mtRC8P/pYViiGeZGNqAfhLTkBWKblaUfNJkNUIo4xkt9J+g46etbilYB1O84oKX075c7qPwTNwZO4nawLksoaHhuvVWKqLcV98VHMMFMrirbyRupD6WTSSBOhMrtmwocXVlaYGjwNUYyPgR/pvLlJy4GqxqrytMz7UkKNKRYNe29680wB+SKFVfm2MuHDGvDyUPq56lZKFZgMqMiY2S/0eUPhbenH2HV6PJzNlvCDjcZR9I5RLnHsVJxL3XTZVJi93Wd61TSPWdhGWVClIoV5eY6maxXdIi65muj1Z/IQ1EDQGxglk8/iXcNY6XvXH/I1Yk8BfnUyN8/U+gvNuSeVKno4V97HgDPZ+bQIEgHqjeEgUk6TA1pcR9+X6+AcxL2l798tLKh34gvdPUx8oPHxVSbLfG17dQ6RNA5VdRkwYHw9atIrITqZCAdLgkO8mUPwyN7KtC9bPJ1IRAchn6B7uOfx+rVj/QTbQJ91LVOGBY8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(366004)(136003)(39860400002)(376002)(396003)(346002)(451199021)(86362001)(186003)(5660300002)(26005)(6666004)(6512007)(6506007)(9686003)(2906002)(33716001)(44832011)(316002)(8676002)(8936002)(54906003)(41300700001)(4326008)(6916009)(38100700002)(82960400001)(66946007)(66476007)(66556008)(478600001)(6486002)(83380400001)(66574015)(81973001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?AGN0EyT2cUTXft7kqnjQcn5PJWyWtkb2NpR9Ew8mAAeWv6Qd/RGi4higoj?=
 =?iso-8859-1?Q?7OhE9M9paTKHrkyPJ/MczBCAXa25eqQzv58iWycpCrfqr1JmLESmJ2cC0S?=
 =?iso-8859-1?Q?dj9F8IhZ4TqjJ+vcVSFeA8DiIZTnWlkRzXsMvfmR0ATDXEpHoUoaJdtdu3?=
 =?iso-8859-1?Q?V3aYmztmiDONep7qbFblCcjr0CnCZXmXKne9HN8FXs8mexDF+sCH8aRh5k?=
 =?iso-8859-1?Q?BYOnEOOE/05Y9LwnYGrwJi8yVewCz4eoba1ViEW5k1mZYo5VJh13UjrqDD?=
 =?iso-8859-1?Q?dChL4JqnlCd2cI0dAa+VgigjpkQw8ANtTePM3lcydUwgWaQj0gHHR3QXGk?=
 =?iso-8859-1?Q?8F6LWFFy1z9uLNBfBiygSBDBtv95Xj6GcRelbZRmcv5RqX6dXmBn2IgJg0?=
 =?iso-8859-1?Q?IoECuYX1i5MQzggIpDuiph7+fl+2+2/bu3jlDMF7sLtXsePGfonzyF09kw?=
 =?iso-8859-1?Q?wPIa79DRiz/L63szHfAbcQratCnKnkjiRWLyj3ig5qiW4ivBeNX1TYDOjg?=
 =?iso-8859-1?Q?TUEmPPHSKopfSnJZ7CDC/saIsfPbBOTJOgZ8gUR+HVMoXDZraM3CcbYTAG?=
 =?iso-8859-1?Q?R7FnqgbxJVVJYpvc9g+EchP8uXwwQOyScGY7F/tkFI3spbzCm8CMwjvyXK?=
 =?iso-8859-1?Q?xNpEXX4/WQxTvayzDA5hNi4DRyQFrd3mX5ZIFdlyy8ZtJBWThWk7Z1I5+0?=
 =?iso-8859-1?Q?ur68gvSF2wLaiKLpF/7cVuSEUjTa+mkE5fgfDeyaOzQ5+LjtUU/RB9FTWT?=
 =?iso-8859-1?Q?Aphm44GBvhgHVHHdBl5Je7zKGcSwuTq0C/C8B3jQjanMtCxtjAAnmsRcfH?=
 =?iso-8859-1?Q?GkhRl+1jRIcf+XifQtQVPsHR/HzsZEcGCeFVQ03YVFF9con8wFNoaTInMD?=
 =?iso-8859-1?Q?FtcEnk1GgyVr1e2O5sre8lGPbogn4YNie58zgIu6xzfKzETUdZkvLz1Gm+?=
 =?iso-8859-1?Q?eALnk+KwnjfzsmXkSnCQEPfE4Z9o0TxS5G7KI3XikOm9d3UUn6ljhJZGXh?=
 =?iso-8859-1?Q?8KpY7zDXjUzXGlctmGn7bvO966vqUHCpS5XVJWpEPvtg4CpP9gZu7V4gGf?=
 =?iso-8859-1?Q?CzfSZfwz7i3enhVFKUg57Cg7TrgMMmBU2C41Eu9i+Cfn4CljS9G/kcVxIN?=
 =?iso-8859-1?Q?Tosg7t7f/eHoyvd79e0nDtjigY01B7Y798n6jpqsl2jeC+NsyAHJjyQWAy?=
 =?iso-8859-1?Q?rD5zaBeTZTfnyKfK/fThuhWQPI0BXK1eN4tiJk8xeAG9UQOGu0+8cIfk2j?=
 =?iso-8859-1?Q?ExsxrQHpb8unFHElHogumx1NspmtS5vmjH054E3BaussLhaa1rKVt6lPtc?=
 =?iso-8859-1?Q?iRBS3nv6e/CcOSmhefYhK0eJdC3fKJMaIL2qenOC5A9x8VtuNpGv4xgxYk?=
 =?iso-8859-1?Q?efhBmF6hsXEhrOQyOOM/HKXtVnt3GWbULG/Epuj0zt/A43tOv1MhgDU5HW?=
 =?iso-8859-1?Q?nWKKaJjYMAfsLSCBwjwzFKx/paG5yXrYiQph8kmuw8ztdrP2a78oHqMD5s?=
 =?iso-8859-1?Q?L3rDfo9/ACDX4MoX5oWtY83gD8XKm/daMJon8LJ0c+6lMFPsZGmjrTR/3E?=
 =?iso-8859-1?Q?vyvRyjti2v6FegYqVBoIyMC30uNwjiXM7/iymmXLGMNx7TtgVaS+23PLNv?=
 =?iso-8859-1?Q?ay4faAqM/Y2tj2opfhRFIoBkqmNYtqdN2I5BE8MPUVsq6LtAR84mX0VQ?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ba64187-cc30-473a-eab5-08db65f28ee1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 18:27:45.8859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QvR0e9g5C4FcYOU6MEg37HN7TnrFUxV8rnd2jbSSq8FkbriV8cmmHhd22WnENEgQzCFLuHCirXNSJYMc6jiHh1dm9NYqqedUQSQz7DaS+/g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR11MB5666
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 11:44:03AM +0200, Csókás Bence wrote:

please provide a motivation behind this rename in the commit message.

> Signed-off-by: Csókás Bence <csokas.bence@prolan.hu>
> ---
>  drivers/net/ethernet/freescale/fec_ptp.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
> index ab86bb8562ef..afc658d2c271 100644
> --- a/drivers/net/ethernet/freescale/fec_ptp.c
> +++ b/drivers/net/ethernet/freescale/fec_ptp.c
> @@ -443,21 +443,21 @@ static int fec_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
>   */
>  static int fec_ptp_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
>  {
> -	struct fec_enet_private *adapter =
> +	struct fec_enet_private *fep =
>  	    container_of(ptp, struct fec_enet_private, ptp_caps);
>  	u64 ns;
>  	unsigned long flags;
>  
> -	mutex_lock(&adapter->ptp_clk_mutex);
> +	mutex_lock(&fep->ptp_clk_mutex);
>  	/* Check the ptp clock */
> -	if (!adapter->ptp_clk_on) {
> -		mutex_unlock(&adapter->ptp_clk_mutex);
> +	if (!fep->ptp_clk_on) {
> +		mutex_unlock(&fep->ptp_clk_mutex);
>  		return -EINVAL;
>  	}
> -	spin_lock_irqsave(&adapter->tmreg_lock, flags);
> -	ns = timecounter_read(&adapter->tc);
> -	spin_unlock_irqrestore(&adapter->tmreg_lock, flags);
> -	mutex_unlock(&adapter->ptp_clk_mutex);
> +	spin_lock_irqsave(&fep->tmreg_lock, flags);
> +	ns = timecounter_read(&fep->tc);
> +	spin_unlock_irqrestore(&fep->tmreg_lock, flags);
> +	mutex_unlock(&fep->ptp_clk_mutex);
>  
>  	*ts = ns_to_timespec64(ns);
>  
> -- 
> 2.25.1
> 
> 
> 

