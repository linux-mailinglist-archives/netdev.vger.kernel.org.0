Return-Path: <netdev+bounces-8806-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 78B03725D89
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 13:47:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2DD46281370
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 11:47:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A93530B97;
	Wed,  7 Jun 2023 11:46:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68AF17488
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 11:46:59 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68DE719D;
	Wed,  7 Jun 2023 04:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686138417; x=1717674417;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=CAxCp0NZH9ib+Y0yW8Toii1XTj8yFcdzSVLUE1ZSwIg=;
  b=lDM4mPw6f/NC+eWOwG7nPjXvzRhRP8Y1OZekLAdPJODwWTTSp1fjbZZh
   /2PW1GsvzOu5q6ZOJnUJfWDbL6mwIAHQ8D6tT9bUdZ9L/W4QaUnL3IjOg
   dRqB3DhTWNHsUGbWX63h5Uxl4pacILn9RLd83c3hxp1Ow1FWhrSDt5CKz
   SJiCa0qxsLU7kCPuSu+1coNupq6VsWXmy13poyw1IRDEb9j2c9ldDgfkR
   RwXPO94ZZ9tS31DqNdL3TCdcaMhzQw/Mfv/sfLNlRT0rMAAj/A5ZOJ4w5
   BLqMlvIxKiKtqt0zki8rVYPsksZ/f+isNwR25tGqMBsY36bdWvf4GCMrf
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="354453107"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="354453107"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 04:46:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="703606886"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="703606886"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 07 Jun 2023 04:46:56 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 04:46:56 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 04:46:55 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 7 Jun 2023 04:46:55 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 7 Jun 2023 04:46:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ArjyqgZ01/FDzrmPqi9XbvQR0p9+Ckrhb/fComuD/MX7YPf7rcAQbnZIP5qi56qXY7KzhUGR9YvruubknTBAX4HJnm8L4t6ljnU2TeuwRJRPLMIiTtWhs5UcwWXLadnnmc2vQ4oE5grojsZMwcjpr/vbU/RE9mdgLmP4e/0Xq+lp67oNKjOd7VbpefHe/CUS8t43X13Q+ma6Eb7UZrzCqCEG333+Gpeii4x0fqyKd+Yk2Wc9vzXlvDfy4XQO2ardJ7YvMP4NS8+fIjDddTDdonpnLtlu/uagvDqL4usunThXon/m9zOJfohEMC9rVAfCuyxRxNpzmuNonQRy0zC7ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EO4m71TcmbElYEAR1VH7qqUCWdG4B9akkH+zc+WHNaQ=;
 b=cmKvleRilp0f8lZQjFTsZltdYWvSAIE4L5Kk2ATDCmtyjx3UYtxqDBjQMUaTlFhf+MzZG86QvT+QhdQPTwBP93oagW1db64haLHfMm1FN+miTg0zfPATl3fuFMcK5kwiTA1YCzfHAYjUcXYzn7ykgyFaVolBTNbs/+suVdbtZYOPbbzt46cuXeVRAF4H0pcwHkTPhmziDgP8GZ5rNm8rRFtqivHX6DGYnWx1eAkUNW3MRKvcYxpHgXT5ParZ7h3Wsermabd2um1kwuOtbz4vNU4Rlmx5JnsEt4coX4FuQqa+DWTCXNmexL4UJcJtT7Aj0JtTcZWb2VhXvZqd5HnL0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 SA1PR11MB6870.namprd11.prod.outlook.com (2603:10b6:806:2b4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Wed, 7 Jun
 2023 11:46:53 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6477.016; Wed, 7 Jun 2023
 11:46:53 +0000
Date: Wed, 7 Jun 2023 13:46:41 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Sai Krishna <saikrishnag@marvell.com>
CC: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <sgoutham@marvell.com>,
	<dan.carpenter@linaro.org>, Naveen Mamindlapalli <naveenm@marvell.com>
Subject: Re: [net PATCH] octeontx2-af: Fix pointer dereference before sanity
 check
Message-ID: <ZIBuIXH2M1KbCg06@boxer>
References: <20230607070255.2013980-1-saikrishnag@marvell.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230607070255.2013980-1-saikrishnag@marvell.com>
X-ClientProxiedBy: FR3P281CA0108.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a3::11) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|SA1PR11MB6870:EE_
X-MS-Office365-Filtering-Correlation-Id: 46bb870e-f686-47a3-2c15-08db674ce370
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5jhJxzzqhoQgwsZpcnbDfg/i03MJaMeu+sSFDZBJ8FBLuLg4xma6bwO3RiveCkZnqemJJZ6qBF+NQDxn9VJsg6GgwgzUKRMP2CqTJJ8U705AWw5jzBCfx+6Wr2IZM81eYNqGYLpUw3l5dXzvlGBEjrPXyLSAcZ2YremolqpQu88AkOzoQi9rPqvk16dO8sfK2A1xI1FnOoqTwtM3UDXl7O4an33NoaskLCuQqzlr80whT1LbcVqAU5ECg86z5kVm6+YTFErg08MshisSXCs7otBGFnGmBlpqyRq7vg2golsV1+VrvgKZK3mXw7sbMdVz/q3JO/9cgcHXl3UiYhPixRGgwNNC8m4gbf6yhHv+wxA2iqOiUbqNNjIBEPaFa/pt6Sk94AwDM+637vyk0dlV1fQIJozvAPfnMdPdL99UUTN9jfnJV7geUAopOi6vZWO/dOJ3rOrPF06Rqda9wCZWA6D12j8YVPTyeRBZe/8U4C5dxqgOcj/asAY0ki73+0/8pz+OsGamLowG073QyAkJ0rDE8n9hCbb3QMj4Nx8I6eL6DHCJxpCMx18IPJfgT8rj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(376002)(136003)(366004)(346002)(39860400002)(451199021)(6486002)(6666004)(82960400001)(2906002)(66946007)(66556008)(66476007)(38100700002)(44832011)(8936002)(7416002)(86362001)(8676002)(5660300002)(41300700001)(6916009)(4326008)(316002)(478600001)(6506007)(6512007)(9686003)(26005)(186003)(33716001)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wrGWjmT+A/zZoEbiv6JnusSCx6xyky5AADLV41me1Klp4zs/RuCNcBKn2d+z?=
 =?us-ascii?Q?YbuJll+DB8Dm5lgPSlRIl38dKNyq6J83y+pG3/7lQTk9A5WBZpGf6q3nEVMr?=
 =?us-ascii?Q?8CFcSnIU1gzJ4TU/tiGe7If80vnKMLT+KIem4fKdyUuuuoZwSLR/OIVRNwEO?=
 =?us-ascii?Q?77ENPExBW+b8Oz7x8qCVrOAYQM78PfsyTs9vPAkooTyE+rZoodnuzsTLIDQ6?=
 =?us-ascii?Q?NZoyRmF82YzXUbMFQ7D2p5eLFkb8kw/Mts2UxgCJxFsS/RHVKFS7ucm0HHEo?=
 =?us-ascii?Q?1+W/Ts8CheTczwzA7fuT7dv7TlCFIt5uwe5T2Skr5CXYxoJ3g/cy7GuZ32sw?=
 =?us-ascii?Q?X58fk887r3faLpwwF/q7beOFAieP1fssMFltuVLfLSGA1hGwqyHafbpx5VQQ?=
 =?us-ascii?Q?OcLgjqyM754kaKpz0YtHQwJwQYHKRDASAxbclPggSIKNeije8m+WqMZ4u5ET?=
 =?us-ascii?Q?JQ6Nwp20HPu48ShNdiv4Mhb6Fq+6DnJK7xLZBfTdSIOyp+cftF2tK6TjmIxR?=
 =?us-ascii?Q?hyUyyC6TQGeFVoXMdx18aDXEjbMr5zjsivvHiARgBevETmQafM8PFw2vV9Ap?=
 =?us-ascii?Q?UleU+GJ+WhAvNKyj65N6xOjsgLaB1X19gNonIKYx6RwGcMkJpru+OBbS560W?=
 =?us-ascii?Q?HW6hgN0pybGprEukhu3gBCyPt49CrNavEQgE9n6z1yVBQLWG1F/+f1lijVc8?=
 =?us-ascii?Q?PohnjejKUge3OSA0fNtvZd8HbAz9dtrz2JKu2SSWqpCzE1TnEtlxVO52urhv?=
 =?us-ascii?Q?DIsoLUnkVILJz6XiUUDyIxkAozznVlV8AOBIc/r17ylUWzhlN1+469C3hJnB?=
 =?us-ascii?Q?7m4umvU8zVQuj5rqFCJiaoOkY8h3dgfhO19Er6iocFnAU5A9sd3NCc1glZG7?=
 =?us-ascii?Q?Y1MrF8pZp0fuX6QYticVx6OqbAGD0z2cFk75/WbZqvbTvsuhyZCqSlsePrVi?=
 =?us-ascii?Q?dJby3RSsQUJIf1J8qwXGAJ7ILm8MEOkkhQdtQ4MUYJyBs//ulreJdRfTUjFY?=
 =?us-ascii?Q?oa3HPo1KKY1V9HTiiB5JbnhmxOuqXZeS5fInT4W5p/fNunBfwjFKfv4gxMbK?=
 =?us-ascii?Q?8XPLvgQKUPNfV5L7KyVkyatkCQY6GZn4HRpvOLG74DCjETn8DSwjbIo1JBq1?=
 =?us-ascii?Q?IsxouDjsTXmsdcuzUheOhGWs+/IdjTKI5VQOViHtym7WIuKTt6OTi+Yk/lRv?=
 =?us-ascii?Q?nAND/IKFMkzVf6k1Zvzi0IxsWBmrAJ4ma8ukchZRX915QUF+c62OkSbkVI3p?=
 =?us-ascii?Q?DMcs0bnzVKlrT8gplW0KubY0YIw9dRaCGCP3nCbQgENA5g5+XEnLItVbnVs3?=
 =?us-ascii?Q?csPZq68T7DWV0/z13PKSBzmkiAb/FNRk01Py0jaDKFWAOsPWiEPi7hjysgLT?=
 =?us-ascii?Q?r3w9+pG8xg/4hLw3oSVYuq6pn1lThOqP505wDJf4r/mySmklkM1Q8/rTF9h9?=
 =?us-ascii?Q?6OO6jkF4EY+hR3yFvEMNXkpcapGchwvcr+gDeupeBlrDhDrK06NGvUI4DANY?=
 =?us-ascii?Q?lLwvEoybYQ7UgyIB+bYdZQIhHDlyTue/83A33Ajd+jNYcJ/wgSkZcYBq9vbN?=
 =?us-ascii?Q?IpkfLE6upB0W5N4ww5Di2imeHbVO8PB5AVZfLyP6e9Z0XHEDJEL1+5SMFnCH?=
 =?us-ascii?Q?DUEw5yNwV2mMlvtjj4GQNQs=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 46bb870e-f686-47a3-2c15-08db674ce370
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 11:46:53.5415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lhqzAJPUzpaD4f/RrERceS6VfxS8InPu5hyffPQpQ1wZ8ED2phxIeXlZqmbWE2c/POdMwalX/FFxX0iggp6CVApVi9lrccYbWFXcKNJsYz8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6870
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 12:32:55PM +0530, Sai Krishna wrote:
> PTP pointer is being dereferenced before NULL, error check.
> Fixed the same to avoid NULL dereference and smatch checker warning.

please use imperative mood, you could say:
Move validation of ptp pointer before its usage

> 
> Fixes: 2ef4e45d99b1 ("octeontx2-af: Add PTP PPS Errata workaround on CN10K silicon")
> Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
> Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>

Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> ---
>  drivers/net/ethernet/marvell/octeontx2/af/ptp.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/ptp.c b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
> index 3411e2e47d46..6a7dfb181fa8 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
> @@ -449,12 +449,12 @@ static void ptp_remove(struct pci_dev *pdev)
>  	struct ptp *ptp = pci_get_drvdata(pdev);
>  	u64 clock_cfg;
>  
> -	if (cn10k_ptp_errata(ptp) && hrtimer_active(&ptp->hrtimer))
> -		hrtimer_cancel(&ptp->hrtimer);
> -
>  	if (IS_ERR_OR_NULL(ptp))
>  		return;
>  
> +	if (cn10k_ptp_errata(ptp) && hrtimer_active(&ptp->hrtimer))
> +		hrtimer_cancel(&ptp->hrtimer);
> +
>  	/* Disable PTP clock */
>  	clock_cfg = readq(ptp->reg_base + PTP_CLOCK_CFG);
>  	clock_cfg &= ~PTP_CLOCK_CFG_PTP_EN;

i wonder if ptp_remove() would be able to free the struct ptp that
ptp_probe() allocated - then you wouldn't have to use devm_kzalloc().

> -- 
> 2.25.1
> 
> 

