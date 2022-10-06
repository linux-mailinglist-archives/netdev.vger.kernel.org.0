Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3B9F5F6738
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 15:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbiJFNEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 09:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbiJFNEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 09:04:22 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D546C97D6E
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 06:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665061460; x=1696597460;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=Ank9YDP3gcUmlueX6GyF5st9T+Nf/kmNe9HBpOr7jKc=;
  b=Z/zHH4NGFmFEXPu2f/y5/8t2LRXrpKtW51gYUzmf5FuJwUxhPiS38+m+
   mJxPtI5dJ7uzle3ewo3O/W/Rh4y05K42cWFIm08XLSD0tsFIqVlUJvuOD
   que3P6jWlIIpO4V8Mve2rMhmTZN5WnNwZJ73zttRY8jY/QyShlOT5llLi
   1vUPyQGvxFHFh8L96/EeD//H0kscVsxOKfaSw3ftVy765sLdV8bZtQza0
   PvHfhH9/suPFxk2Cl7IuBzAHq/bWT8HInGrFKCgluRLr371+THP0TaTNs
   Gv0T9OIjVsiYIEKGSwMYyWa+v7Sgj7+UWx9yUpXZZZ9Jg8NTecESp2ThX
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10491"; a="304429396"
X-IronPort-AV: E=Sophos;i="5.95,163,1661842800"; 
   d="scan'208";a="304429396"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2022 06:03:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10491"; a="602426000"
X-IronPort-AV: E=Sophos;i="5.95,163,1661842800"; 
   d="scan'208";a="602426000"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 06 Oct 2022 06:03:46 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 6 Oct 2022 06:03:46 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 6 Oct 2022 06:03:46 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 6 Oct 2022 06:03:46 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.49) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 6 Oct 2022 06:03:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bQDEtOYuM7bDlbOE2Vn4X7qXtk7NreO9/AdlQ2CGkNSHU/IsdIrRr1TqJ4uERmBM1tC3MkWw2tlztCKR280oxQUPLSRElvj+pYg5ZRqJAZx9wl8BvVk7axN1iIAuyGT1deC066IWqjHC8b/eRNx+4ObjzmHwcX1M9cLx/O8ZvlobTGvh6ddhSGGJA6WeeEhBlao2L/iJEOlY5WMyRHrVWUnniGvg+lo6UvTigO3UXslp6CQL+g7wkqtFQnRYE5M/gzFbGFRm/INcyMvXEaVCPB8h84Wf1YBLJbxoUw/Lvc6t+Bz4Tu2d8tGwl94BuVVELAoTLaWtztbAcOJuz0pdzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ubHdPbnGj0IuM0c16ToVoguhqFuRlDUfMuU85pNCZB8=;
 b=io20SG5YVk1mcBj5RvX6ZhoyJytS0unI/T3soo6new0SqMip02nLQmX6pEJ+MRZ0SVTgB5nfUdoeamZjwzH+Axet9IRV3G3rI/gEckW8uC+x7wvLtyOuSOUwoeUBS7QX+IyTTvvGkR88jIojdNNbFUWBH3p/qNfhzx0zlGGPNmrdfs7qjyTC/PhBq8WggMa52p8MHxL+p0HLbPc3bPz8X809KaMtLsl1r86xIPy8JZsAVUWkWs8jbPrn5BRghhpj/7kdA8ijR/plrKIBb96WX2PJil9eyZfnXLZ5cMuG+zzmJySKL06oU12nv8olb6zsdrJ31c7Uiy3r/YX2c6Azqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 BL1PR11MB5553.namprd11.prod.outlook.com (2603:10b6:208:31f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Thu, 6 Oct
 2022 13:03:38 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::6ae9:91fd:f3e0:7923]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::6ae9:91fd:f3e0:7923%4]) with mapi id 15.20.5676.028; Thu, 6 Oct 2022
 13:03:38 +0000
Date:   Thu, 6 Oct 2022 15:03:26 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Joe Damato <jdamato@fastly.com>
CC:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <kuba@kernel.org>, <davem@davemloft.net>,
        <anthony.l.nguyen@intel.com>, <jesse.brandeburg@intel.com>
Subject: Re: [next-queue v2 2/4] i40e: Record number TXes cleaned during NAPI
Message-ID: <Yz7SHod/GPxKWmvw@boxer>
References: <1665004913-25656-1-git-send-email-jdamato@fastly.com>
 <1665004913-25656-3-git-send-email-jdamato@fastly.com>
 <0cdcc8ee-e28d-f3cc-a65a-6c54ee7ee03e@intel.com>
 <20221006003104.GA30279@fastly.com>
 <20221006010024.GA31170@fastly.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221006010024.GA31170@fastly.com>
X-ClientProxiedBy: FR3P281CA0142.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:95::16) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|BL1PR11MB5553:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f085d15-2dcf-42e9-d157-08daa79b2f60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gKw+sZIsDpzmNPRy/Vxaal1lRmp2l54usvdm5CC17+KrctEFapTjQB1idGXyqnaN+IQBwwSN99ab9hJI+aeZx8k+equpjkoc7fUC5Qy0aBDRX6upatn6NcfJOMm1WP5I7WIsEDFPUpPyQmkLz1aXPnIXCN600M+7vqloOw7LIgxmeKAkNNg05h1o4O+f7oIXR6ZLNJgNmlCBot1sjN69TdEkQt0fitWf0kWUVK4y9nscKIEL+SAbzBHId0KpIdkNzqqXm3h+q0/+kazHLDZcV4D4qW0yJcLDWeHpFUcT2o+gq5Adz+f43bgWhqKWYRsYJRG4fS2XJogPPyGp5vps3I0Sa+sM2AFHmduPHTuDc6nUzIjAFCeqssg796MGRvIjHf6PrTTg2S44smBIiRx+BEqu/xbhXaG4kA38dpaS6rwiefMCvqTPrFsRb83wCB4MHisVSgo7gQNNJnB5/+xNlqNfO2r/J1smXBC+tu38b5M3lKFpP2wYPYUcFswonbDssYJnfOzdRPW/TOP0dQiuEOzpLj3MVJksOBIYJ8PJrgnHQDY5NB760ZZoVZw2oBZw8T2EJoGjp9I7NZC4EhNEEPgJ47huNX6RFAA0zIZiXPPIyqHtPjQFeggRFoXnLYmRSgsb2wxjhz/uUpaSAsSbZAnjTG97JVjRHMKHjwAHwC4UiLJlPyMjLT7iFsDlc2McGyKJjWXO95DvUQoOwGWQBgfpwlEZvqbk0Y2+rujmELw58vQMXK+5/PkcZKgZ9Do6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(376002)(136003)(396003)(39860400002)(346002)(366004)(451199015)(38100700002)(86362001)(82960400001)(66556008)(4326008)(8676002)(66946007)(5660300002)(316002)(6916009)(44832011)(66476007)(2906002)(8936002)(41300700001)(186003)(33716001)(83380400001)(6486002)(478600001)(6666004)(9686003)(6512007)(26005)(107886003)(6506007)(53546011)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?GfgClESkB8DTPh9D3FMDw4mZwjnCrzOVdczfRAdxmmNG5/7bOCJmXeRXx7?=
 =?iso-8859-1?Q?4KpzvkU/bVy4FQE68fwxSMDgWRLxADbk0EAXvNz55YdhvaQOxitGk++bAB?=
 =?iso-8859-1?Q?uiEJmcgsxPPdqjszKr0jh4AzQJ3Rk+nZx32+Uuq1RPNOaKozOpBMbwsdxr?=
 =?iso-8859-1?Q?sGULvN7VUBOjoAfwbgcbvMYw/z+M/uAzoDEPm6vLv69lUBO5h/9VMs/lJV?=
 =?iso-8859-1?Q?ZepAqFKlyclW0L4nCWYgvHFDKjt3gvq325o89DNcJLWrwhSaxICjpq4KAJ?=
 =?iso-8859-1?Q?bfmT68K6cjKIkXMm93fgGxi6skrs41Fqecsm2Wc5WXAKkvdAngCCO6lOOf?=
 =?iso-8859-1?Q?hyVrE7qrjwGvtEn4ppCHRKvqCA94eFCFbNnqewdwduRcfDSgF2zWHDNCqR?=
 =?iso-8859-1?Q?ggrFBCQSUweLWBdkkGtZ1BZ68qz7xs1naXsaqdExbNxRJA210fkpG9i+nj?=
 =?iso-8859-1?Q?FgIJOcqMZZF4h8sahNlbLPcovXMDkOYltg6Yuo/Y0o1frl2MuUkB5ULpFb?=
 =?iso-8859-1?Q?wXI/nfmY7/dIDsdal9Jj2iS9q4cJwaUXJkGe+n5WYWnBBthGtKTjxq48pD?=
 =?iso-8859-1?Q?NLoWA1umysNvKVK9AZ7wf6P8u56pe/sagmhsNfCUNvapa0L420KmYBe61q?=
 =?iso-8859-1?Q?BWDMG/ebbCzW1HTE47uoLW67oCIzgCkKqf8W0EROP6b4vU5AQRp5Ge+4L5?=
 =?iso-8859-1?Q?VOh8lyvC0g1JMcdqgXg8Yzpe0qLjNx0LMeziBkI60njj1MF10pPLr1oYZc?=
 =?iso-8859-1?Q?0By4VcuYCh1Y0ciLKER7c5IiE1isGUoKxD7wEL9cK0gIbaeko03VjCv1bw?=
 =?iso-8859-1?Q?7xvD78Q2Fh7nzqNYpXby3cflXqLvqkRRSSfvpGyCxvy0NkHwh/MNmMIxT0?=
 =?iso-8859-1?Q?AEfHIJYMdT8pU9lkqmXUYpcJuMEixHiDFAtHmi/V02owjSSFbrLVbwtcTY?=
 =?iso-8859-1?Q?yxRDgv88qoyMiw7tYcFxIOjNWFesV6Et/WzvwyUi4wuRz+klAshcXR5u4l?=
 =?iso-8859-1?Q?Lo9Z+lor8O7SLthRVRGDheTdQhuSZMCUsKi5Z3nIFhnSQ8athhmxDXbTH+?=
 =?iso-8859-1?Q?1BvmSicWwe4JRErETdjieYjOgEhNY3vkRwmsQscqVU/eFFdryLoJV7ADsV?=
 =?iso-8859-1?Q?Fe4R3N/iXMHVTLiS5yxbt79f89A0ROzDgPbxD/qL9hKUn+692IsVjqUMjB?=
 =?iso-8859-1?Q?taOX7VuU3KB5W+NEwCNY3Mwz4kv22wypDG/Vq9cQvwTVhx+xivlNf/PbTD?=
 =?iso-8859-1?Q?GvRSNljjNjXIMxGZ3Xzk9a8MwxekZmWTAPya55LH4Mv7jm61vDFZP7nkOG?=
 =?iso-8859-1?Q?WzoXSO7VGTXHAw0YmhL2zymEWSCUKoct2LEPpkEx/Aw0/+dgMWat+voaOn?=
 =?iso-8859-1?Q?IiBYizZpfpsf35xWxMnR/BU5X906947qo922E0y5K9LyIaSiccnT+43G6+?=
 =?iso-8859-1?Q?74nzpfg2gadUPzPhdFwK7kb2qIvHEzIF6jPqVW7rWICEuUA4GF8R/9atzY?=
 =?iso-8859-1?Q?37tLM1STJJt8GdWftxro5OwqBQlHJTrijpA1RmRer4OezyqC1Bxn+YG2DN?=
 =?iso-8859-1?Q?+nKxWUeGvyG7tDZHo/154F0HCPL9gUBRTzEAYgH+1H1jbvhCFUZKgVqITz?=
 =?iso-8859-1?Q?q92DGiqsRMJZrKNsiU8sJY+HJKWcwEycryikLEBpehPee8wXZ2lJjD+Q?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f085d15-2dcf-42e9-d157-08daa79b2f60
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2022 13:03:38.4864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ajuptxl4C+GdDFCOM+FXwjVZrbI0Bus99cLTAQMNDjUOB83wp1+XscJ07VwwXNk2uUQw/UR2K76eSivuZxfnk1KESN/+BzT1sGjq8P6zPwY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5553
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 05, 2022 at 06:00:24PM -0700, Joe Damato wrote:
> On Wed, Oct 05, 2022 at 05:31:04PM -0700, Joe Damato wrote:
> > On Wed, Oct 05, 2022 at 07:16:56PM -0500, Samudrala, Sridhar wrote:
> > > On 10/5/2022 4:21 PM, Joe Damato wrote:
> > > >Update i40e_clean_tx_irq to take an out parameter (tx_cleaned) which stores
> > > >the number TXs cleaned.
> > > >
> > > >Likewise, update i40e_clean_xdp_tx_irq and i40e_xmit_zc to do the same.
> > > >
> > > >Care has been taken to avoid changing the control flow of any functions
> > > >involved.
> > > >
> > > >Signed-off-by: Joe Damato <jdamato@fastly.com>
> > > >---
> > > >  drivers/net/ethernet/intel/i40e/i40e_txrx.c | 16 +++++++++++-----
> > > >  drivers/net/ethernet/intel/i40e/i40e_xsk.c  | 15 +++++++++++----
> > > >  drivers/net/ethernet/intel/i40e/i40e_xsk.h  |  3 ++-
> > > >  3 files changed, 24 insertions(+), 10 deletions(-)
> > > >
> > > >diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > > >index b97c95f..a2cc98e 100644
> > > >--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > > >+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > > >@@ -923,11 +923,13 @@ void i40e_detect_recover_hung(struct i40e_vsi *vsi)
> > > >   * @vsi: the VSI we care about
> > > >   * @tx_ring: Tx ring to clean
> > > >   * @napi_budget: Used to determine if we are in netpoll
> > > >+ * @tx_cleaned: Out parameter set to the number of TXes cleaned
> > > >   *
> > > >   * Returns true if there's any budget left (e.g. the clean is finished)
> > > >   **/
> > > >  static bool i40e_clean_tx_irq(struct i40e_vsi *vsi,
> > > >-			      struct i40e_ring *tx_ring, int napi_budget)
> > > >+			      struct i40e_ring *tx_ring, int napi_budget,
> > > >+			      unsigned int *tx_cleaned)
> > > >  {
> > > >  	int i = tx_ring->next_to_clean;
> > > >  	struct i40e_tx_buffer *tx_buf;
> > > >@@ -1026,7 +1028,7 @@ static bool i40e_clean_tx_irq(struct i40e_vsi *vsi,
> > > >  	i40e_arm_wb(tx_ring, vsi, budget);
> > > >  	if (ring_is_xdp(tx_ring))
> > > >-		return !!budget;
> > > >+		goto out;
> > > >  	/* notify netdev of completed buffers */
> > > >  	netdev_tx_completed_queue(txring_txq(tx_ring),
> > > >@@ -1048,6 +1050,8 @@ static bool i40e_clean_tx_irq(struct i40e_vsi *vsi,
> > > >  		}
> > > >  	}
> > > >+out:
> > > >+	*tx_cleaned = total_packets;
> > > >  	return !!budget;
> > > >  }
> > > >@@ -2689,10 +2693,12 @@ int i40e_napi_poll(struct napi_struct *napi, int budget)
> > > >  			       container_of(napi, struct i40e_q_vector, napi);
> > > >  	struct i40e_vsi *vsi = q_vector->vsi;
> > > >  	struct i40e_ring *ring;
> > > >+	bool tx_clean_complete = true;
> > > >  	bool clean_complete = true;
> > > >  	bool arm_wb = false;
> > > >  	int budget_per_ring;
> > > >  	int work_done = 0;
> > > >+	unsigned int tx_cleaned = 0;
> > > >  	if (test_bit(__I40E_VSI_DOWN, vsi->state)) {
> > > >  		napi_complete(napi);
> > > >@@ -2704,11 +2710,11 @@ int i40e_napi_poll(struct napi_struct *napi, int budget)
> > > >  	 */
> > > >  	i40e_for_each_ring(ring, q_vector->tx) {
> > > >  		bool wd = ring->xsk_pool ?
> > > >-			  i40e_clean_xdp_tx_irq(vsi, ring) :
> > > >-			  i40e_clean_tx_irq(vsi, ring, budget);
> > > >+			  i40e_clean_xdp_tx_irq(vsi, ring, &tx_cleaned) :
> > > >+			  i40e_clean_tx_irq(vsi, ring, budget, &tx_cleaned);
> > > >  		if (!wd) {
> > > >-			clean_complete = false;
> > > >+			clean_complete = tx_clean_complete = false;
> > > >  			continue;
> > > >  		}
> > > >  		arm_wb |= ring->arm_wb;
> > > >diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> > > >index 790aaeff..f98ce7e4 100644
> > > >--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> > > >+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> > > >@@ -530,18 +530,22 @@ static void i40e_set_rs_bit(struct i40e_ring *xdp_ring)
> > > >   * i40e_xmit_zc - Performs zero-copy Tx AF_XDP
> > > >   * @xdp_ring: XDP Tx ring
> > > >   * @budget: NAPI budget
> > > >+ * @tx_cleaned: Out parameter of the TX packets processed
> > > >   *
> > > >   * Returns true if the work is finished.
> > > >   **/
> > > >-static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
> > > >+static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget,
> > > >+			 unsigned int *tx_cleaned)
> > > >  {
> > > >  	struct xdp_desc *descs = xdp_ring->xsk_pool->tx_descs;
> > > >  	u32 nb_pkts, nb_processed = 0;
> > > >  	unsigned int total_bytes = 0;
> > > >  	nb_pkts = xsk_tx_peek_release_desc_batch(xdp_ring->xsk_pool, budget);
> > > >-	if (!nb_pkts)
> > > >+	if (!nb_pkts) {
> > > >+		*tx_cleaned = 0;
> > > >  		return true;
> > > >+	}
> > > >  	if (xdp_ring->next_to_use + nb_pkts >= xdp_ring->count) {
> > > >  		nb_processed = xdp_ring->count - xdp_ring->next_to_use;
> > > >@@ -558,6 +562,7 @@ static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
> > > >  	i40e_update_tx_stats(xdp_ring, nb_pkts, total_bytes);
> > > >+	*tx_cleaned = nb_pkts;
> > > 
> > > With XDP, I don't think we should count these as tx_cleaned packets. These are transmitted
> > > packets. The tx_cleaned would be the xsk_frames counter in i40e_clean_xdp_tx_irq
> > > May be we need 2 counters for xdp.
> > 
> > I think there's two issues you are describing, which are separate in my
> > mind.
> > 
> >   1.) The name "tx_cleaned", and
> >   2.) Whether nb_pkts is the right thing to write as the out param.
> > 
> > For #1: I'm OK to change the name if that's the blocker here; please
> > suggest a suitable alternative that you'll accept.
> > 
> > For #2: nb_pkts is, IMO, the right value to bubble up to the tracepoint because
> > nb_pkts affects clean_complete in i40e_napi_poll which in turn determines
> > whether or not polling mode is entered.
> > 
> > The purpose of the tracepoint is to determine when/why/how you are entering
> > polling mode, so if nb_pkts plays a role in that calculation, it's the
> > right number to output.
> 
> I suppose the alternative is to only fire the tracepoint when *not* in XDP.
> Then the changes to the XDP stuff can be dropped and a separate set of
> tracepoints for XDP can be created in the future.

Let's be clear that it's the AF_XDP quirk that we have in here that actual
xmit happens within NAPI polling routine.

Sridhar is right with having xsk_frames as tx_cleaned but you're also
right that nb_pkts affects napi polling. But then if you look at Rx side
there is an analogous case with buffer allocation affecting napi polling.

> 
> That might reduce the complexity a bit, and will probably still be pretty
> useful for people tuning their non-XDP workloads.
