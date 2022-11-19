Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0DAF6308BB
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 02:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233548AbiKSBtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 20:49:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233638AbiKSBsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 20:48:50 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52CF7A4662
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 17:22:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668820947; x=1700356947;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=8gpj9w5n8RTBnuxg6rqzz0fRuAPfPCxTWIL2Auko5Vs=;
  b=lx/Je8uwReI1Hr0HNbu7vAhcNRDWFSRseb06w5CUoeVIdZhXilp7lqsI
   2eDG8uzEimJqwY9lbjhd9lI4kgTDlY/r7LCBROEIWHyTJI5Mpy1FwH/Fj
   9Mh49/q8z0wxrwsK7MnwNc2bym+X4hRzdHGu/tyKQPsWwIMRoz4iDVCKC
   jfLrc62koJV0F57kr70QHjg6OQzCg+njYTC5q9Gq2lZZlNyR8BMwakuZD
   nUQnByvnn2a4Myz0aMfl+DHrVeTGneBffNjBLUNaLjPQZVWnCI/s4RZNp
   g84EQyDP1BCHMrFYY8XWEgRI+fJ97fyMDHJrC7cC/1NUZlXaZNQ1Axe00
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="340121984"
X-IronPort-AV: E=Sophos;i="5.96,175,1665471600"; 
   d="scan'208";a="340121984"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2022 17:22:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="969478550"
X-IronPort-AV: E=Sophos;i="5.96,175,1665471600"; 
   d="scan'208";a="969478550"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 18 Nov 2022 17:22:26 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 18 Nov 2022 17:22:26 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 18 Nov 2022 17:22:26 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 18 Nov 2022 17:22:26 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 18 Nov 2022 17:22:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hT2cjEEagQlpp2h+BYXcNehSXIs09F9lWzyY0UljKpBGUSSNtegDGaevUzMo5jN/DAYFndY7Y4q69szvQOo15s0WTToweBk72Ouel5BUmbV4L+j+WVayXHZ5SZ8Uu7j8GBNWR+jo+kpD3uCzdLlYix4SpurdEmdPcAJScTdIBvXHDmO73NkWnmvJ582458EuzBmMdbRBABQ/tI6SKvBpMo46JLU/Qnin+ZwOWgTToe7uNUObSBzXiUm+7RAp8uxCW9TY7JNaN0layH/5CqzciXKt90l9d2pMylKln8RKarzCJE3gpXktyLTEYerCYCKRasQ29A4KIkbMe2+T0xDlDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o22LZ2kiPIqfap5l98pHEmHoWfK9NIKs9aPaidzAPco=;
 b=V93aU+2mdUowL/0/Dvqi8q4QxMPOmvvc/KA+QsDq5+XfyyvLnI7/zgjt0Fx3mU8TikWMnFqf+ImLJK6fCN0ohjthaKlF9ldd6kKNV3YK+u5lWRot+abbwYMF5P96aq5NUOTeqSAHT5BS7tRnyg/oBb9P/mWpWxuOQRMps4vagCnoEz4sFuxtRJ9dNQGheqYvcaE25j4BQ759m+cLZSYrCwoGqcEqGpbEt64dg1iYsJa4mH/P1caF0dROedjOc82pcCJ6lbClqLWinYj0l1ZiGDvOriiOydvpu5FsySyBUXM2LN4YilXhn9Llbeb30BeKjSphplIgQCUvyusDeIvsWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by IA1PR11MB6467.namprd11.prod.outlook.com (2603:10b6:208:3a5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.20; Sat, 19 Nov
 2022 01:22:24 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::5236:c530:cc10:68f]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::5236:c530:cc10:68f%5]) with mapi id 15.20.5813.019; Sat, 19 Nov 2022
 01:22:24 +0000
Date:   Fri, 18 Nov 2022 17:22:18 -0800
From:   Ira Weiny <ira.weiny@intel.com>
To:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
CC:     <netdev@vger.kernel.org>,
        "Fabio M . De Francesco" <fmdefrancesco@gmail.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        "Vinay Kumar Yadav" <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: Re: [PATCH net-next 1/5] ch_ktls: Use kmap_local_page() instead of
 kmap_atomic()
Message-ID: <Y3gvyhYa1JSRVxaE@iweiny-desk3>
References: <20221117222557.2196195-1-anirudh.venkataramanan@intel.com>
 <20221117222557.2196195-2-anirudh.venkataramanan@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221117222557.2196195-2-anirudh.venkataramanan@intel.com>
X-ClientProxiedBy: BYAPR05CA0030.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::43) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|IA1PR11MB6467:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e53fc92-6a38-410f-3678-08dac9cc827c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h0RjsmJUcUUL23AdKkgjjUaF+OkYkHnWn4U5+VVO8f1jgYzPuDeUduieuSId27Mn5NFFgjSYn5NmwR2lhfDiqKm3iAx2a4hSgeJFmT+kNkrb2SSUsgHpdHf9ZZ76B5AkZh4P3diM+EnMpNCjL7erSaoS/OpMruasw6IEPiZ3JMpK15RYst3O6g4BAXaeU6VzUrsppvBikShN6/fR0/3tL2fWjUTX9WHMPgOi0nNsWFPnAsDFEQZMnLNhcv2LmWaBtU3nXVkUUnPuwYS3fnAcvXuKT6TwYf/S9zzrFGMTVoKliUDsxzPd7yf/MT2uj2jfdrDn3bwHWX5c6KdUc5SMfT/AXYs/yBQahubAdhqcsW5jIx6qDy8IuMIly+Ggzkgq3C/R7S27B8x++Euo0E0ltSkq6GV63RRRh4TZngVFKi/JERrphvWhuXxJdXa0jVKRcgsv+pwEn1E0EzHHQ8f0aatjltwJmV8/66Txm068opYXcNZYEapt+A67qAjlvPNkst/Mkv2IOqZF9l+N0nUqXHstz3RFdeHtKf+UIVqXakns3MnJUB7+zAEoSRj8GTqMGfqSEe8mr1LRHKaIlwRbcc/oBa4Pq8c3cHRWwS0wqAcg2MxPaqnZcbqZlOFFHnIGOIralqH8yM4qq2XOTZ+f/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(396003)(376002)(136003)(39860400002)(346002)(451199015)(478600001)(6666004)(6486002)(26005)(6862004)(4326008)(8936002)(66476007)(8676002)(66946007)(9686003)(6512007)(66556008)(5660300002)(186003)(44832011)(6506007)(316002)(54906003)(6636002)(83380400001)(2906002)(33716001)(86362001)(82960400001)(41300700001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4Vr8Zibvf8DH6Q2FFlw9c2+dCRrSGQt39M7fR85RdzY4SYL+ETQeMlg7fi/F?=
 =?us-ascii?Q?cXBazUliSdd+Y7/x7gJBPvP2GwO55JgbzOgTBxnv/NIMR/5dAmOoOMeQXYIb?=
 =?us-ascii?Q?BghMlzd6W9eUVampVXWxY57RvZU5jrLVn2NxaWbG/RRdw/t3RSHb7zO6zDJe?=
 =?us-ascii?Q?fbwT392ZyEyOswc1wHZQymxzl8gOV6H3PVvbAcmcGcD/N62unOMLQ3Tc1U4D?=
 =?us-ascii?Q?KEWaVNxqwgN+NXYiwzPPPxawjPD/qveCzleV6ZdXGxuCZ6s0SggtW6f4a8TA?=
 =?us-ascii?Q?OkbACnBVharpi+cyPupXC3ONCf8DYsGsLOFA//r1AOzaU36sRWwZGc0F4cPe?=
 =?us-ascii?Q?xHco/ohh5mD32o2HpoKZkaKFvDCA8fKWuSGob1m8lcMwTAEvre0nXBWj0yps?=
 =?us-ascii?Q?V0A9F0mdVaYswA2igXnOsEMqLP3E3Z9V5B4uEBewEzINf/H7cjxr+qgO3Pqd?=
 =?us-ascii?Q?zdGFiqv2Ag9UBjqH2qHmtOavQfat9WrEvSb0fbNWRw44CnlVbbr00FDfu+hq?=
 =?us-ascii?Q?G/fIez8z6eYwMK4rznz/aEaoS1ATdK+gjb7Cum2Q+CcgGkH7b3MpuTIOSB4o?=
 =?us-ascii?Q?6B6XVH1ylFa7O9VdxRxez6wDR/Kux13z+OelKNqmtnHbRobjVLaThyCzr0q9?=
 =?us-ascii?Q?sTAetwU0lfF0BsXGqzMHQ4AwtxqeXl2qrp2fMFzNEeFgxLrJO5VaDYh4jgjx?=
 =?us-ascii?Q?Po3QI4cu2bxGWr1+6c+zEHfX/YRDWTEyTpA6OwOsTT+k6f5ie7/sZpagOIUz?=
 =?us-ascii?Q?o4r1gq0Xuc+/teZg7VUYbHBFWBzBF11bZUeywW5/ca3P0rk2jY4T1h4qVg+3?=
 =?us-ascii?Q?gk1JeyChy2yitf1U6nVkWBZCMZrFJMSVBLeKoIiM8c3HyoaVLpkvySLb7nfu?=
 =?us-ascii?Q?LUrpoRGvvc1BSRwNg9iw2Hr6Zv40a+g5tRSn1hksJ/8/1dgEDUkiybCMhc/o?=
 =?us-ascii?Q?z99zK8Ik5XMClbQ847LLdB6/vltVQIJ8JJwHPhgSi0eik2G1PfYpvV2Bli+f?=
 =?us-ascii?Q?lJxRqM0/xrtHX0imKlSBHBZp4qDTXDOJBRobBD7rzO7mtC72zeAyDfKck8sR?=
 =?us-ascii?Q?vyqn7Zd27Tm+c/IIqGS0hNp719GYUXy3ks/gSJftfJyBzQIYYdnlBUWWkmGh?=
 =?us-ascii?Q?thfnP28IIAI/SllcWM2zXixjI7EabgorP7xNPrEDfNOMAQhMYLsr/olDeNQF?=
 =?us-ascii?Q?gk0rJ93kThgmvhCr41YneBuj5+uvL1yIcft+vWpOqFxfLXnrwRF4UMv9n2ot?=
 =?us-ascii?Q?5NeknOD9PkDJq79RfRGD1RmK8LKFk5kKm5s6mkr6mfJKMAVoxIwSjEsTj36M?=
 =?us-ascii?Q?bvWUPbc0LIqMwKLQCEfmT1CVLNN9L223YFIkm0DNhI6OL7ZftT9LdNARftC3?=
 =?us-ascii?Q?YVrdmZUs95uTfaZVi0D/1G5rSYND9tvMUw6W8+WD1nAXxsYpq6t1g81Hib8H?=
 =?us-ascii?Q?NDlUgpmIPuMxl2zBKUTdKib/cYw4MfKjPgAQRg9babVAVYkrQaddga1Pc1mn?=
 =?us-ascii?Q?96ahNqpLVbL6+4+gB5mBYbAUTxXk7YSLqSgLAo3FLoHhApE+ouE1Ty86NAwk?=
 =?us-ascii?Q?7teBSZXTBMs0RXlFHNNwq3k+ubUsf/QqGXkVsBoq?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e53fc92-6a38-410f-3678-08dac9cc827c
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2022 01:22:24.1671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: asNdHEbODrhOqA0k+4mo2DNI9qNoIqvaQYikz3ualMhwFo6hF/1IUfa5/PX4xsWIx6qzrhnWCTVZN2bF6ac4YQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6467
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 02:25:53PM -0800, Venkataramanan, Anirudh wrote:
> kmap_atomic() is being deprecated in favor of kmap_local_page().
> Replace kmap_atomic() and kunmap_atomic() with kmap_local_page()
> and kunmap_local() respectively.
> 
> Note that kmap_atomic() disables preemption and page-fault processing,
> but kmap_local_page() doesn't. Converting the former to the latter is safe
> only if there isn't an implicit dependency on preemption and page-fault
> handling being disabled, which does appear to be the case here.
                                 does not?

Also, say 'is not the case here'.  Appearances are not enough.  But we know
that this code is safe doing only memcpy's.

> 
> Also note that the page being mapped is not allocated by the driver,
> and so the driver doesn't know if the page is in normal memory. This is the
> reason kmap_local_page() is used as opposed to page_address().
> 
> I don't have hardware, so this change has only been compile tested.
> 
> Cc: Ayush Sawal <ayush.sawal@chelsio.com>
> Cc: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
> Cc: Rohit Maheshwari <rohitm@chelsio.com>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Fabio M. De Francesco <fmdefrancesco@gmail.com>
> Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
> ---
>  .../ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
> index da9973b..d95f230 100644
> --- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
> +++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
> @@ -1853,24 +1853,24 @@ static int chcr_short_record_handler(struct chcr_ktls_info *tx_info,
>  				i++;
>  			}
>  			f = &record->frags[i];
> -			vaddr = kmap_atomic(skb_frag_page(f));
> +			vaddr = kmap_local_page(skb_frag_page(f));
>  
>  			data = vaddr + skb_frag_off(f)  + remaining;
>  			frag_delta = skb_frag_size(f) - remaining;
>  
>  			if (frag_delta >= prior_data_len) {
>  				memcpy(prior_data, data, prior_data_len);
> -				kunmap_atomic(vaddr);
> +				kunmap_local(vaddr);
>  			} else {
>  				memcpy(prior_data, data, frag_delta);
> -				kunmap_atomic(vaddr);
> +				kunmap_local(vaddr);
>  				/* get the next page */
>  				f = &record->frags[i + 1];
> -				vaddr = kmap_atomic(skb_frag_page(f));
> +				vaddr = kmap_local_page(skb_frag_page(f));
>  				data = vaddr + skb_frag_off(f);
>  				memcpy(prior_data + frag_delta,
>  				       data, (prior_data_len - frag_delta));
> -				kunmap_atomic(vaddr);
> +				kunmap_local(vaddr);

Agree with Fabio that this needs to be memcpy_from_page().  We should be
consistent in using it.

Ira

>  			}
>  			/* reset tcp_seq as per the prior_data_required len */
>  			tcp_seq -= prior_data_len;
> -- 
> 2.37.2
> 
