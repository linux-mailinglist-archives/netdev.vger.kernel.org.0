Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92F23633BF6
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 13:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233357AbiKVMAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 07:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233394AbiKVMAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 07:00:21 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBFED13EB0;
        Tue, 22 Nov 2022 04:00:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669118419; x=1700654419;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=BKHjxv2voONaWtxZ/fthlD474gAw4gFqTC7XRUxhmb4=;
  b=VvOEGVhvlYzG96am599xODLFUE0S7fJS0jH8UJsPsRxd9pPEQZ7ylIe8
   EaRa0YcoZLFOpeetDqutAtxbYKf3ISSIHaTvaeenv+GfewCxncLCAuZc8
   UFDtgzcg5npgcmbEAhHJXk0JZxY+AqsAWT01ZzlQSmxmPscTREJsYT2di
   ZcmeAHZkY86RXlYeoANRGNSIkvlwLXXxQ6nMyG7GdGAv2zrlHtWm288SV
   tRATntm4lwaD/ExuvGe6OgSdx4DQgD33UY3IanDw9c+4dpojC1hkTZNGv
   qk/p2SaVrvr6IeQ04W1xnfogkx213wt0+sQy1PmjTz9u2fsOgvFkm33SC
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="313827890"
X-IronPort-AV: E=Sophos;i="5.96,183,1665471600"; 
   d="scan'208";a="313827890"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 04:00:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="674326356"
X-IronPort-AV: E=Sophos;i="5.96,183,1665471600"; 
   d="scan'208";a="674326356"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 22 Nov 2022 04:00:19 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 04:00:19 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 22 Nov 2022 04:00:19 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 22 Nov 2022 04:00:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=akmPi213Mbvocu602gmf5HOCYSn7cklmPjj4nnqtgRNVdaUcVyq7GtNoTZ9OayXLNxHadURuKQRrGop0XaMQXkENXxx0BMiEREIJZVeygR3/aVOZCLBMUhvD+Hur7LbYN7jU43CmklJrJWam7+omQ1VHgDn4KrrIK3aIvLyL2mewXoyyjnqyOzJqflhoAT5ONSLzvJ6tO21E21sAmUZZLA666UrGpq5Vw2dnINJdFk1e9h2zciLXsCGxck14HZbFU+qsRDygfB1DX9aHJmdc9m0dvlXIBT9phPcl/nmM72LZBfIq5nRLR1QLgwiLSQTy6QqR3x0+p9Xd0c5ImpyhYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q189HjDMmYkxQ+ZlWbKoBQuXpo7nKHngLghTlHGzRPM=;
 b=NOdybGAAnwv3jMESquLrvUxmtx9kFYM6XLnmtPY7O4Sln3fV3Go/esXkGsVA0grv8VkneIYojF75BXJjZaXMNFz2m5TPdcX/OvrxnidWJxqEtqdm/P8UAfmQo1kv/p4K9XDQ8HsA2ygnnuYt2LCbZIip9LFG9Om1AZb3IjOyctTzO+SSXWBoay6MDsz5DLblJLSH8LQVzVhLB3oAbeoP6mNrD5l/q77tFG/RfoNtbERwKrT4khNVVwj42I13aPq4QWFeeSg90SVlUzLso6eikCV86FUKzCbjy/vs1Li4KNBjFMHGsjD9+ytg7T107AoB0K7b303+wTdxiCUaXZR84w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 CY8PR11MB7134.namprd11.prod.outlook.com (2603:10b6:930:62::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.15; Tue, 22 Nov 2022 12:00:17 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%6]) with mapi id 15.20.5834.009; Tue, 22 Nov 2022
 12:00:17 +0000
Date:   Tue, 22 Nov 2022 13:00:06 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
CC:     <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <hkelam@marvell.com>,
        <sbhatta@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] octeontx2-pf: Add check for devm_kcalloc
Message-ID: <Y3y5xpewO/wh6ooB@boxer>
References: <20221122055449.31247-1-jiasheng@iscas.ac.cn>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221122055449.31247-1-jiasheng@iscas.ac.cn>
X-ClientProxiedBy: LO4P123CA0523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2c5::7) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|CY8PR11MB7134:EE_
X-MS-Office365-Filtering-Correlation-Id: 15c1ea37-1ac3-469c-1bc1-08dacc811f3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SR55dzHs///9NAE8idETU7AKyc3EGNC2gfZ53H7g3bpPBMw3INN3YwyCJ+Ag3AN/KJekWzHOBQDcxuLeLp2QpvkEJCZ/qJMhEsBgBWjDm9Y4KQvC8S7uuiUZ2ThJYfMCljGt8A1biMBT9/qOpL32U6ljyGt9UJPHOU5QDQdXQi0i4J2cDwOQsQLgaJO0Q6CULAr4ojcTMVmVrqNPPaDba/yq4s/3MHDB7lPwY2VOz8OhEENL3Lmqt2xtMnWba/gQwYUJBsk+QRjzCZChonY3xrUTAC6HmiBwlq08SZfGjtDHqoGhSDEt2EPJi6rnlzCJIt36Vs//aeYGgBd//KRsdIc/9bvpD4QTEBAdsncsEtYHD+QDb75fbJJ/yr+d/kSQf7RGAMy0ZqKurEEPlv+0UfNJ0co/Ko5DvLvsODwItyoiUrPcYW1raF+meZpumZddAmgCdm3ugG2oygKkTqwyFlEG8az1PCv7xiPG+VQ151hjlNDvZ5q0VULPabPo3yUbpHxCeTO/fUa2FXEQZybcOpEmt9cmAhb4SXh34PUyuhwb7c5iZwVPZ2tt3fW+MdbYRaElRdSYeJKJVsI8UJywSQbRzWuMsBJeqLuApdsbMi482mHTvYbk//LBfIMT3ou5ZIarF4bACpfCTwPbBTXoPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(376002)(136003)(366004)(346002)(396003)(39860400002)(451199015)(2906002)(6506007)(86362001)(478600001)(316002)(6486002)(9686003)(6512007)(8936002)(44832011)(5660300002)(186003)(7416002)(26005)(82960400001)(66556008)(66476007)(8676002)(6916009)(4326008)(66946007)(38100700002)(33716001)(6666004)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kuqM3a7VTOpPQITymi5zG6rlAAEbFv75iZRywZyA+TVhPnIrlH9uIq6PfCu6?=
 =?us-ascii?Q?peYZVWJk3YMITaDHvxIvwyOINvaKpjY2Knc+bsHYvhN9HkquPdX6W4Xf7bAl?=
 =?us-ascii?Q?HosmM17czmaEyOESyg2ngyEgkO3F9x6VM+6M2FZ0R4NbY58OwuiN2Eq1bkFS?=
 =?us-ascii?Q?FLCRAGi1k9W24AXMxSABs1m/9uYF0rl4wMX5MW0lG6qEsm7YScXNmZ415xJe?=
 =?us-ascii?Q?F7ONDtU4brBFExOcyWooaiU1uU3wmYr9VMabGIk0CXRAI7kiis8yoQw7+I4R?=
 =?us-ascii?Q?mo68GeV54BYwpClFSc5omVkhOOdKKYI37lYbHPWt6U1Q30lY9uERgvMfJwVH?=
 =?us-ascii?Q?Rw57iEZfXKxx+okGSiMKbGethhzIP4VjqNMTbG1kCL/5CyCK9rCeomlWc/sZ?=
 =?us-ascii?Q?m9ldlgFXzJfB1T4o/lXJ7WsfnF35mg1UFDHAqPnrzV7ksm36O1vs1+ApIZR6?=
 =?us-ascii?Q?nXlq62/cBELYso6ujSk84iREa2BJ8+CTssZVksRuq64U9rQnzxkYb8oS5Ncb?=
 =?us-ascii?Q?xKjtafqpc1xwyQzLT1PwYOFceWEBditMdQlD2rCp72fTg7FzSfvSCBagvHa6?=
 =?us-ascii?Q?EUYratzQMXd6EZ4zu+Yv1dqIhXPXRMZS8/DNTzDzOAmYSeJRvmh3BhE6aGuh?=
 =?us-ascii?Q?QJ4hUIGAwpE+pxnsuMMDkwc2UC9GjceeLipfEY2sDCjJTUxyn/Izstd9mwsc?=
 =?us-ascii?Q?HD8kVMBEt07tf9ksmP6W4EdQCIiLTElYNBCqtpU+FTrSs10LL7rAAOLXYjpF?=
 =?us-ascii?Q?1z4nl/QTuiwkBP3SPDW4MvIK1S2BQWlOx1z2wFJbTBklfkjIav4WVorQJ5dW?=
 =?us-ascii?Q?vb/LIiSZ+Il0eAalLw3+IvDcKha8Fin+S60tAeMRi3MFRCgquAq2wndT+be6?=
 =?us-ascii?Q?jqLyEO+gYbYfQ3cABDP37ZnDHGPllkw4KR+Oj1wHuJwjmQmHoYd9JlsDYVwe?=
 =?us-ascii?Q?zEsatACD7ZoA5o4v3LZ0oDjvGj9oaEhrUuNcbngQD9L8yfHQGxPJiDBMYEIK?=
 =?us-ascii?Q?boFJales/7lj0HoQavapDRKmBBUnHJZ1/WT3aaVWDxVQCVIctqEN0zUXYvwP?=
 =?us-ascii?Q?xM1ztzY1emJxZcKKZrw6wYck2Vni9CgguJN57MmbxnWVOPEQiFcGcBBAJVVC?=
 =?us-ascii?Q?1RXwfqzKvBIaShNGNzgknnblfoR9s8VNQ6oVw9DwWjZktP+CwQgmlH099rhY?=
 =?us-ascii?Q?5+a/OfccbfgDbJ3FrlRBI5frnrxfZJQHm1dzDJJFUYo6DSn+nowF0ojiRnk7?=
 =?us-ascii?Q?hCXIvjAvHAeeew6lWX4MliN5HRi3XEMSEwfMfUIE6EgiuBOVWMiOI61uDE/C?=
 =?us-ascii?Q?GAhweNXKKS3XT/F37ojkynAy2tQ7lH81mFIjxivSIAmJ0/mb3n0vHCUXIeT3?=
 =?us-ascii?Q?s6ySvhmzTxGhojqJs2qsumkxh0uZbNfwTNuaJyDbtBwbBm4FW0/mIBzf/2RW?=
 =?us-ascii?Q?nC+RZDoxIOJnIvtO2VZTmr6M814XhjdVGF4YVpzxTPIgphD0xn4x2MNeKFXC?=
 =?us-ascii?Q?OcfX8ITQSBcBdCVYKg/yjKfIvKuaYwYKBsUz3nr8zwwjLkWl/alO2DPXtFCj?=
 =?us-ascii?Q?U+T3TMTKo0v/D2l+y95g95beIX1/2DYFi7AnU1NVXGUJQY9hQbOlwufqYMVV?=
 =?us-ascii?Q?qA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 15c1ea37-1ac3-469c-1bc1-08dacc811f3c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 12:00:17.4476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RcG3C8isb5JrkXUIC6FHhfl+Wch04skkaZGvki123xcjRfQ3VK1xM9YyekXpuCDcVZC7c9WM0iQGfc3uQ+mzZQSDDqe8wYhn3MA4RgqHcuo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7134
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 01:54:49PM +0800, Jiasheng Jiang wrote:
> As the devm_kcalloc may return NULL pointer,
> it should be better to add check for the return
> value, as same as the others.
> 
> Fixes: e8e095b3b370 ("octeontx2-af: cn10k: Bandwidth profiles config support")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> ---
>  drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
> index 7646bb2ec89b..a62c1b322012 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
> @@ -4985,6 +4985,8 @@ static int nix_setup_ipolicers(struct rvu *rvu,
>  		ipolicer->ref_count = devm_kcalloc(rvu->dev,
>  						   ipolicer->band_prof.max,
>  						   sizeof(u16), GFP_KERNEL);
> +		if (!ipolicer->ref_count)
> +			return -ENOMEM;

So every other successful devm_kcalloc() calls in here don't have to be
explicitly freed in case of an error as in the end rvu_nix_init() will
fail and therefore the probe() itself.

Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Please also remember to state which tree you are targetting your patch
(this is a fix so you should have [PATCH net])

>  	}
>  
>  	/* Set policer timeunit to 2us ie  (19 + 1) * 100 nsec = 2us */
> -- 
> 2.25.1
> 
