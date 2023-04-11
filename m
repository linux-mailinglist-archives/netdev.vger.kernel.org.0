Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA806DE7D3
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 01:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjDKXLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 19:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjDKXK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 19:10:59 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A90CF19A0;
        Tue, 11 Apr 2023 16:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681254657; x=1712790657;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9lKRwWD+sUoSoN0uoDxfuAze6ceFt3/cptawi2x/v9A=;
  b=NxEU7g0XT2XsVK4lF+6jWn00akn4Ytc7iowEsBI8Crv1a3MB6gxgrD93
   r6XpoexpoW945ZXEkSkwLru/ffPDztfA7/oY16Ye7oWLjFXJd1gQULKrU
   3dO+9Cep+CL8swFSFQwHcqbgf/QIYdpg+qksAFcZy2pxfbdPfexAGESJw
   XdN7bx4WbNdyiGcbJIzy2mDh+hnjJeyUFhi1hja7EyHdNs+NYhXq3NO0M
   oWyzwveFfNY4EKo+IF7FQoMVtmU4QRe/WIyIGhowey/JiyPgfciVABfxj
   S65Cyy2vgaosdJDJtwlTUiFYp25PNY4gxD/sdkVKvPjnS8szRq5cCfwDe
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="430042245"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="430042245"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 16:10:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="682263503"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="682263503"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga007.jf.intel.com with ESMTP; 11 Apr 2023 16:10:56 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 16:10:56 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 16:10:56 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 11 Apr 2023 16:10:56 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 11 Apr 2023 16:10:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mizfyGcUqLKExwXIKlPZ1e31dh+t/nvmENJS3BmEq9qcZ5ydHY4agg24Z/CCDLqw4dIsVSl3FyUkDyR982VyZ5Ia9m7K4AGu254FdIfMNJ8z8zG9V8VfUEebuxIa7j3yuTIR50cXQchtSOPDDeb9jmdbU66R9411g+NzcPh4WrsEaiFMzMgS3H4op/0C94+E9c96sSArFcjNv1hIMiEPafTHWJRtw4WE8SapmN6BfuzSvBqtJwLstZy35vJpoHllMFKDS2fRBfkyH+JWd3cFZR7nmN57zoT4PJ3DTf9JgsnjHJQ3Q5T8ezZLPkosvUjmaFbZBgTkMwYcduU6STD3Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3A9szpGEzozLhE+PyOfhTKeWVpLPf3toJIRIe54E6vw=;
 b=cB7w8fMw/xyKccUqer/h0OPc9mpGDRErCKdmWMsbgiLgWwhh+O2BL6GCc+tSmqrT6rQQv6llf6xU4f6pGgWUpW4QMNNr1KoYyCsIfCB0pFQe8hn5QsuXXIez+ZsRRGqtBwEtgfd/M5IG+SZVPKsUmnVURLIJ7QfMdINeDxs1Cx+E9Cqgr3X9UjGCLUbkGxJ7QHSdJvTKKErvJsH+7ay1DVbn01M/IconR5DCla4bQ06+eFrXXIjST/6Yo8jSeIeGr2/iCOWWilTfjqBgW6dOUBDYJhfaazvDnTtiSyb2JkRNSlDfE3R8IoS+ZeTywqY/RIzUuQWegvr4ruUgGEu6Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by IA1PR11MB8223.namprd11.prod.outlook.com (2603:10b6:208:450::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 23:10:47 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6ebd:374d:1176:368]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6ebd:374d:1176:368%5]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 23:10:47 +0000
Message-ID: <422e4a51-4cec-5772-70f5-1019789acd18@intel.com>
Date:   Tue, 11 Apr 2023 16:10:51 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH V2,net-next, 2/3] net: mana: Enable RX path to handle
 various MTU sizes
Content-Language: en-US
To:     Haiyang Zhang <haiyangz@microsoft.com>,
        <linux-hyperv@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <decui@microsoft.com>, <kys@microsoft.com>,
        <paulros@microsoft.com>, <olaf@aepfle.de>, <vkuznets@redhat.com>,
        <davem@davemloft.net>, <wei.liu@kernel.org>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <leon@kernel.org>,
        <longli@microsoft.com>, <ssengar@linux.microsoft.com>,
        <linux-rdma@vger.kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <bpf@vger.kernel.org>,
        <ast@kernel.org>, <sharmaajay@microsoft.com>, <hawk@kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1680901196-20643-1-git-send-email-haiyangz@microsoft.com>
 <1680901196-20643-3-git-send-email-haiyangz@microsoft.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <1680901196-20643-3-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR13CA0002.namprd13.prod.outlook.com
 (2603:10b6:a03:180::15) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|IA1PR11MB8223:EE_
X-MS-Office365-Filtering-Correlation-Id: 1148a386-1d66-4302-2da4-08db3ae1fbdb
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pqxIC3CtKP2QFOImGY2NJqi4pKGADcriTlMLtxVcNvXmIkNuutbNh3XedMJfzuNrHuykDuH58wkoJyEMuYBVfKZ5yV67bEdgHxKBANc0WweT3in3xZscu35VSMsDdsVmOs9KB3eNQD290jIaWJlfVa1LAtn8djHFZ821mByUSPzCSMu9WvarrEumYPd6NUP+LMY23GImQcc3EHcnNfsZiGgAlV+765Gz9S6yaQIL8Pe9x9DbIvhsH+xkI40c9YmNR6lphopC06OLyH5hcI50X0W4prd9Rh3l2y6UI4HzGRkIgKMz0iT2yW7l9g2EKQ447PshPnsoHabsE4bXa3yxTxHQNQfGPpVELmXXSpFfjoAhnzOlJxhq+HV4Csn5PFH0Q2NN91dVd6jiFlAADOS0lnv5iSCrdYS8sYq93w79GD7U9S868p0WKJmvzmrW5ig9XCMKatAhQH4EvCuDMQdDOPclfWT0eRPcGH/Az7HiN80m0iR/f2cmEYXBxcy8LSejghIjhL4iQlNJJRHgQXdZfZYmBlE2LDCNN8fGGa//j+tkI7DuO+6gOhDaOhUIsdeip8yExgmiGgIAfnU+mp+OBipP+vDbwdFDKcdXVTmzlvk/fla7NXzvd57VAbwFgEysyVp9VZqbxj13bA1n8vgqxg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(366004)(346002)(396003)(376002)(451199021)(38100700002)(31686004)(82960400001)(66476007)(66946007)(8676002)(86362001)(31696002)(66556008)(478600001)(4326008)(45080400002)(186003)(2616005)(26005)(316002)(41300700001)(36756003)(2906002)(53546011)(6512007)(6506007)(83380400001)(6666004)(8936002)(5660300002)(7416002)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eisreDNzT2lKZ1ZrMSsvMFFuQVJCeURueURKRjZqU1hBRUs4aTh0bjZiQlBm?=
 =?utf-8?B?QURSNzlNaUJFVGZZeEVnbjA5YW4xYjJMSXlwTmx4ejl6aFlWN0NZQXprb2dm?=
 =?utf-8?B?Y3hBT29DWVdkc0k3R3RIa2swMDdBMmRNdUoyWUVobTdRUjRnTlh3SThVNTdV?=
 =?utf-8?B?RHNpWTgyVytYb3drOEIzNGNsRmp3bG5abVR3dUgzT1RSTFcwQ3dvZFoyNERs?=
 =?utf-8?B?T0FLZCtJbjEwWXVzRitUQ2o2c3Z1T0k0RGREU3NRejZQM29qZXpwTi9HYXRt?=
 =?utf-8?B?cEM4Vzg3aHBONXptVzk1c0hxUWNtdGt1NVNCZlNzQUUxQWgwSG16RmFCWHFk?=
 =?utf-8?B?bWFsWHpWUGxLakRBMWV2cVA3UVo4eWFCK2dMRm1zSjhlbGhKdDRJbGI5TEg2?=
 =?utf-8?B?VVlGRVhvYUk2d09NUFFqbXVHSmk3TUk2Y2JJZktmeXR1aDdhMFNyVHAycHdP?=
 =?utf-8?B?dVlIZk91ZFErbG5CeHF4bjdnNkJocU5yQVBIeWRydVY5SzY0WDI3NFo3eTNu?=
 =?utf-8?B?c2xPVHNYNzdVRnMva3dkcjcxVTZqRHZKTUt0Zm1iV3BySmNWMkJLcURNejhn?=
 =?utf-8?B?ZU5XSGErNHNXU3FSL2FyU0tVNDZCS1o2R3J5bzdoQmFsZkxMeEdPY2dRcEdp?=
 =?utf-8?B?UncyY2YrcS9uUGpaZGNPbk1WTU1JWENEbWZWTVdQQmZjbWs4bE1QeDJHMVBm?=
 =?utf-8?B?US9JOW9YbDdSQjJld01SVHJlNzI5cUhrcEp5cExNdHpoOFlOWnNLYlBxMWtU?=
 =?utf-8?B?MStQdGZsZ1g5RWI5VXRnWkZjMjFGY0Z4SW50WGJKYlJRTVhpVHQ1c2cySU9E?=
 =?utf-8?B?ZmdUQnZNSjdEZ3l4a3lkdzU3NmJZaktXak9SVHdjYzJDeXppWE4xaTN4cERx?=
 =?utf-8?B?QVR5VDBUMW9nc2k1N01RS2pJSHpQTzk4YzVhRHQ5OTJxL09FcG5BcGx5M1p4?=
 =?utf-8?B?UmxFWVNrYXBXZlBYb0EyaURRZzlSSnJ6TTdqUmdVdE9aMWxzVHkzRTJFY0xL?=
 =?utf-8?B?QkYvd3JTTUl3REtndzRTN1dzc0FVWUdvT3kwYXZKazJneDdjZmFXd2YrREIw?=
 =?utf-8?B?R3B2bEgzZEFYSzBBRGFId0Uya0pUMzZ0T2ZMSDNzSXM2Y3pHYm1VaUp1dkNH?=
 =?utf-8?B?MHZ5dXkva3pxNUpxYVY0K2FMb3E1dG85K3VXU1BWS2pKbVVlUVJNKzdQUUJr?=
 =?utf-8?B?M2NJMjlid1lQL1NrczZzWkt3djZyYWp3SzAreW1KUnZIbWhhV0c2OW45dGtF?=
 =?utf-8?B?emNLZWlncVNuWUNTNFVXa2JSUHZMQ1g4Wk1MV3BOYTRCT25XWTFtdGFCS1lz?=
 =?utf-8?B?WmJUdlRvVURBMEw1RkRVT0pOcjJGZHk5aEYxdGVaUTJTdDVBYitMZWx1cnpi?=
 =?utf-8?B?Sm1NWVFtVUEzNjdLd013d0NyRitKM1ExZHpLaW1qUkRqYVZWcytiUmY3ZSs4?=
 =?utf-8?B?Vkx2bWRxR2FoZkFlZUhITk5iQVg1L1Y0RzlzSmVZMDJPNE5YaTZDdUdLeUcr?=
 =?utf-8?B?a0ZMSWIzQkp5TmZRY0FUTFBTRUF1UEZ6eU9HWWlNV2hSZUF6em03SlVCUmVT?=
 =?utf-8?B?aTJHbmxrUEZvMXUybTErOEM0elhvaWt5OWVqVlVwMXdJOHBNcktjNzRJQS9H?=
 =?utf-8?B?clRIMW9zekZuNlRxbFh2VXR4cUg4VjhKUHdsRDNmQUZyeDhHUnIvVStNWW5O?=
 =?utf-8?B?NWtTSjB5NURjb1RPVDZDWG9zUzZSckRXcjRqZnc1VkE2WHlSb05Vc0JmcFVj?=
 =?utf-8?B?Q081SmZSN0pCY2tIM3dqVkVBQ1NxTXNuVk5RR0laQ24zQ2FBd1F4ZTVLTU83?=
 =?utf-8?B?cW0wS2FndmtGQTYyTmJFQld2cXlQdGNyWEh4SWpDMEpvR2JJd2FVdmhVajlk?=
 =?utf-8?B?OUQ2dzJoU0ZnK1ZsYlpTV3lEVlUwUVR1Q01aanU3Wk1Gb2xuSk9oVUtCcEtz?=
 =?utf-8?B?TDRmdFNlVDBhemhqWTBiSE0relgrdUVaYTNFeEl6YVpOUk9HMWI4VWhZOFp4?=
 =?utf-8?B?NG81bE9rZTlhL1BsSmJVVVloZUNBSUdmSGNqMVRkcHk3QWd1dlUvdmc5bXds?=
 =?utf-8?B?QStyZENyK0ZLWWFBOWFwelIrQlFac29WS1l2UHlEZFc0ZHBTbzJwdUs0WU83?=
 =?utf-8?B?d0xBcnBOYVN2cE93STVxaXJpUHZJZkptREsxK1VVa29TNWJhb3paRGlEMmRO?=
 =?utf-8?B?Ymc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1148a386-1d66-4302-2da4-08db3ae1fbdb
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 23:10:47.3908
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9n1kCzci4bdyURBhgAHK2XCMvsw3d7zxI2VZR+J+fsmGBS95LKd4DXklCug5yEZh97rQeM25npZzYODM1ppOReMV424fAlBFHMm4tkRETEU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8223
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/7/2023 1:59 PM, Haiyang Zhang wrote:
> Update RX data path to allocate and use RX queue DMA buffers with
> proper size based on potentially various MTU sizes.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> 
> ---
> V2:
> Refectored to multiple patches for readability. Suggested by Yunsheng Lin.
> 
> ---
>  drivers/net/ethernet/microsoft/mana/mana_en.c | 188 +++++++++++-------
>  include/net/mana/mana.h                       |  13 +-
>  2 files changed, 124 insertions(+), 77 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index 112c642dc89b..e5d5dea763f2 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> @@ -1185,10 +1185,10 @@ static void mana_post_pkt_rxq(struct mana_rxq *rxq)
>  	WARN_ON_ONCE(recv_buf_oob->wqe_inf.wqe_size_in_bu != 1);
>  }
>  
> -static struct sk_buff *mana_build_skb(void *buf_va, uint pkt_len,
> -				      struct xdp_buff *xdp)
> +static struct sk_buff *mana_build_skb(struct mana_rxq *rxq, void *buf_va,
> +				      uint pkt_len, struct xdp_buff *xdp)
>  {
> -	struct sk_buff *skb = napi_build_skb(buf_va, PAGE_SIZE);
> +	struct sk_buff *skb = napi_build_skb(buf_va, rxq->alloc_size);
>  
>  	if (!skb)
>  		return NULL;
> @@ -1196,11 +1196,12 @@ static struct sk_buff *mana_build_skb(void *buf_va, uint pkt_len,
>  	if (xdp->data_hard_start) {
>  		skb_reserve(skb, xdp->data - xdp->data_hard_start);
>  		skb_put(skb, xdp->data_end - xdp->data);
> -	} else {
> -		skb_reserve(skb, XDP_PACKET_HEADROOM);
> -		skb_put(skb, pkt_len);
> +		return skb;
>  	}
>  
> +	skb_reserve(skb, rxq->headroom);
> +	skb_put(skb, pkt_len);
> +
>  	return skb;
>  }
>  
> @@ -1233,7 +1234,7 @@ static void mana_rx_skb(void *buf_va, struct mana_rxcomp_oob *cqe,
>  	if (act != XDP_PASS && act != XDP_TX)
>  		goto drop_xdp;
>  
> -	skb = mana_build_skb(buf_va, pkt_len, &xdp);
> +	skb = mana_build_skb(rxq, buf_va, pkt_len, &xdp);
>  
>  	if (!skb)
>  		goto drop;
> @@ -1282,14 +1283,72 @@ static void mana_rx_skb(void *buf_va, struct mana_rxcomp_oob *cqe,
>  	u64_stats_update_end(&rx_stats->syncp);
>  
>  drop:
> -	WARN_ON_ONCE(rxq->xdp_save_page);
> -	rxq->xdp_save_page = virt_to_page(buf_va);
> +	WARN_ON_ONCE(rxq->xdp_save_va);
> +	/* Save for reuse */
> +	rxq->xdp_save_va = buf_va;
>  
>  	++ndev->stats.rx_dropped;
>  
>  	return;
>  }
>  
> +static void *mana_get_rxfrag(struct mana_rxq *rxq, struct device *dev,
> +			     dma_addr_t *da, bool is_napi)
> +{
> +	struct page *page;
> +	void *va;
> +
> +	/* Reuse XDP dropped page if available */
> +	if (rxq->xdp_save_va) {
> +		va = rxq->xdp_save_va;
> +		rxq->xdp_save_va = NULL;
> +	} else if (rxq->alloc_size > PAGE_SIZE) {
> +		if (is_napi)
> +			va = napi_alloc_frag(rxq->alloc_size);
> +		else
> +			va = netdev_alloc_frag(rxq->alloc_size);
> +
> +		if (!va)
> +			return NULL;
> +	} else {
> +		page = dev_alloc_page();
> +		if (!page)
> +			return NULL;
> +
> +		va = page_to_virt(page);
> +	}
> +
> +	*da = dma_map_single(dev, va + rxq->headroom, rxq->datasize,
> +			     DMA_FROM_DEVICE);
> +
> +	if (dma_mapping_error(dev, *da)) {
> +		put_page(virt_to_head_page(va));
> +		return NULL;
> +	}
> +
> +	return va;
> +}
> +
> +/* Allocate frag for rx buffer, and save the old buf */
> +static void mana_refill_rxoob(struct device *dev, struct mana_rxq *rxq,
> +			      struct mana_recv_buf_oob *rxoob, void **old_buf)
> +{
> +	dma_addr_t da;
> +	void *va;
> +
> +	va = mana_get_rxfrag(rxq, dev, &da, true);
> +
> +	if (!va)
> +		return;
> +
> +	dma_unmap_single(dev, rxoob->sgl[0].address, rxq->datasize,
> +			 DMA_FROM_DEVICE);
> +	*old_buf = rxoob->buf_va;
> +
> +	rxoob->buf_va = va;
> +	rxoob->sgl[0].address = da;
> +}
> +

So you're pulling out these functions from the code below, which is
good, but it makes it hard to tell what code actually changed.

>  static void mana_process_rx_cqe(struct mana_rxq *rxq, struct mana_cq *cq,
>  				struct gdma_comp *cqe)
>  {
> @@ -1299,10 +1358,8 @@ static void mana_process_rx_cqe(struct mana_rxq *rxq, struct mana_cq *cq,
>  	struct mana_recv_buf_oob *rxbuf_oob;
>  	struct mana_port_context *apc;
>  	struct device *dev = gc->dev;
> -	void *new_buf, *old_buf;
> -	struct page *new_page;
> +	void *old_buf = NULL;
>  	u32 curr, pktlen;
> -	dma_addr_t da;
>  
>  	apc = netdev_priv(ndev);
>  
> @@ -1345,40 +1402,11 @@ static void mana_process_rx_cqe(struct mana_rxq *rxq, struct mana_cq *cq,
>  	rxbuf_oob = &rxq->rx_oobs[curr];
>  	WARN_ON_ONCE(rxbuf_oob->wqe_inf.wqe_size_in_bu != 1);
>  
> -	/* Reuse XDP dropped page if available */
> -	if (rxq->xdp_save_page) {
> -		new_page = rxq->xdp_save_page;
> -		rxq->xdp_save_page = NULL;
> -	} else {
> -		new_page = alloc_page(GFP_ATOMIC);
> -	}
> -
> -	if (new_page) {
> -		da = dma_map_page(dev, new_page, XDP_PACKET_HEADROOM, rxq->datasize,
> -				  DMA_FROM_DEVICE);
> -
> -		if (dma_mapping_error(dev, da)) {
> -			__free_page(new_page);
> -			new_page = NULL;
> -		}
> -	}
> -
> -	new_buf = new_page ? page_to_virt(new_page) : NULL;
> -
> -	if (new_buf) {
> -		dma_unmap_page(dev, rxbuf_oob->buf_dma_addr, rxq->datasize,
> -			       DMA_FROM_DEVICE);
> -
> -		old_buf = rxbuf_oob->buf_va;
> -
> -		/* refresh the rxbuf_oob with the new page */
> -		rxbuf_oob->buf_va = new_buf;
> -		rxbuf_oob->buf_dma_addr = da;
> -		rxbuf_oob->sgl[0].address = rxbuf_oob->buf_dma_addr;
> -	} else {
> -		old_buf = NULL; /* drop the packet if no memory */
> -	}

Could you do this split into helper functions first in a separate change
before adding support for handling various MTU size?

Doing it that way would make it much easier to review what actually
changes in that block of code.

Thanks,
Jake
