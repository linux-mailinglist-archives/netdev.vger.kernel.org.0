Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93377671F9A
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 15:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbjAROaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 09:30:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231423AbjAROaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 09:30:01 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B7904A223
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 06:17:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674051457; x=1705587457;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=h5IEpZ6Nafrp2JK/AjGunRJZpK8bpv1TAwNznw5Odbk=;
  b=ekY04fWwp79k0tco6aYuH1M4K4kxO6vbE3/CJ1kwRJ9iq7tJb/BCeYiI
   0hW6buRocU8cLFDEYXZwztuTDWSG57yUPaYxQvDKrVQN+kjUIqZfVVWFa
   zBBCVNgU57cIdQzOBDbhiJz7LFgY8hSSIwaoqifGVPRC/jn6QwXMJ0yVx
   j61RH7AcLyPZ6S7M4zWp5/zGcliFwGmHIdxrTYUN4YmSL3jKxjmDwuwds
   t3U0QhNim4Q+g0ZabsS0K82LieWymBWHwq+0bT578dnFlUJIQtEHP/9/d
   L9+ArC/mUXiZxsV4EDrRqcRUpuRmd3fBpLfdhL+jSFX2Vh6D0xAJVVOSB
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="387339543"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="387339543"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 06:17:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="659819536"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="659819536"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 18 Jan 2023 06:17:35 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 06:17:35 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 06:17:35 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 06:17:35 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 06:17:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L2CSMJqjyUgI6RxLXgII/Mb5M2eFJVGyIXuYaC+LFbXaNutQd72cvrD1W24TNAq8qabaQoZ8e0NTM8VTvlPFEB3uU3+DZjtvf0hyf7qNqNNYzqUnVQu2fzngquujAC8zTYtgEw8D/45irTDgznBQzT5HewzbqpI6ATZvIuEZ+qUodE4cVm85JHQOfs7F/ipIYjk32hCKIgeeHJZdMF9ZCgnRRn5SP+9dzSqUkGSGiTOQMlGV03NlonbrZmzCUbd+bLnzqlmxd2OZCyncA6OHktEOJlnmc/gRztvJHphToOoJU89KELzvO+C92VvMl1ZSpJjZsgBM+WEWr8fuVsPcgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JoaaVBtWY/6uoHIOf8XWOy15imYfT+ile8GvbqRXysg=;
 b=odBu5hUQ+b7DYEEMlX2sD3OiOZ2Bm4yM8AvAZDrQl7E7avsacMw/9og8PjjB32zZFb8tj13ZzZrHMU7TCOLb+EfrrwdXLl/FhfpCzqpy5jVVEtgw0gedC+oOFL9OrX4mxkCl4zzA1zF923T8a1kNGReWEGFLzeXzbXRow4iusEqGsltJdzqy/p/K1Syyn0I3hGYVuzL/PhHX3IRdQKuFCpMFkNLvwjNeA4zYRb9DSCc8VM1wD2kIfSnlrX/dpFSwkqzRJ7r9q2XR6PjYA1RntyeE1P5vsB6yiWx4SdCrW2j4gHFaFLbiX1hgu0f6cQHU4n/AluvX7fjcFMxsIZcBmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SJ1PR11MB6153.namprd11.prod.outlook.com (2603:10b6:a03:488::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Wed, 18 Jan
 2023 14:17:32 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%3]) with mapi id 15.20.5986.023; Wed, 18 Jan 2023
 14:17:32 +0000
Message-ID: <450e40d1-cec6-ba81-90c3-276eeddd1dd1@intel.com>
Date:   Wed, 18 Jan 2023 15:17:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [RFC PATCH net-next v13] vmxnet3: Add XDP support.
Content-Language: en-US
To:     William Tu <u9012063@gmail.com>
CC:     <netdev@vger.kernel.org>, <jsankararama@vmware.com>,
        <gyang@vmware.com>, <doshir@vmware.com>,
        <alexander.duyck@gmail.com>, <gerhard@engleder-embedded.com>,
        <bang@vmware.com>, <tuc@vmware.com>
References: <20230112140743.7438-1-u9012063@gmail.com>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <20230112140743.7438-1-u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0029.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::16) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SJ1PR11MB6153:EE_
X-MS-Office365-Filtering-Correlation-Id: bac4a3ed-a23d-47e0-8157-08daf95ebcaf
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FWLr48oqf9VhirWNRnP+d9bDep6hzID8O8zJntLbeCkitJQXi5lbsihenYtoPmkss7WoY4tul7QyHYvyk4JmDhEdLzkI7nRZMBH6YT2NAQY1fmDcOWxCnse+5UL0RjLNlSvAG2QLK3jBNcJ62jVGIR1jhXIaBEbhuFsaS3M7o9xD2mY+qX8NSnHiVbb9BJvaFz7GVZRoACpRB6zlF/AoOSeO8y1VbxG5lIeT+UTIeW+YYbvxNXBFRR512gDv+Y3fsBKc6t3N/sKL0f2tTOKj9swT9rOUz8MIofwaZxmboXx8QrDeD3YZjg+Clt1O4Pibh6F1o/hARQS2xr2bUWUCTHSiTk43v1HvuGa2Zb+onvE8jX15msRKRvSQ6kq2hRGLYXgMYsOwUQL4F6Xtm+iSBigsnEMEo44ZT8gN/T4weuwlfszdBMnyHH54+LAZMv/cvqZJAxf3oVDORDJ706lW/tsiCuAt40O66AZdH3YxLm5UT+QV3slmi3LCtt80OODuf+npryS0k4JXjC9mBVmrNQ8UJmxxk5zhGKprhxrmghKNiwRjuComh3pbJ9RTsgu53E+hU7c2t2K7OA0tK+etD9hRGsVyrihlsHVky/p0pIUy/8SgtPmWNZjlLg2i1nc08OYri64puEmhB6JoB0fWSicylm+bsjOKOQEtQRt3ZfFf8Lp7ZORQ5tJQSRrsxnLnfv8oAdg2gtCwSFsXI2fcQ1/7elliZWanFYgljDRn4rdqx45QeGjQNQ3JQycdzYIyyUXWf0hq5hO1GX8MV5P7uKd2uS8zVBtq4lbHmFCtnos=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(376002)(396003)(366004)(346002)(451199015)(82960400001)(38100700002)(83380400001)(6666004)(86362001)(8676002)(6916009)(4326008)(2906002)(5660300002)(31696002)(30864003)(66556008)(66476007)(66946007)(41300700001)(8936002)(6506007)(6512007)(2616005)(26005)(186003)(19627235002)(6486002)(478600001)(316002)(31686004)(36756003)(120234004)(43740500002)(45980500001)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aG1JdE4zVjc0Zys5VWR2cm1xM2hMeHovVytVUGpTNkVaY09nYkhraHV5UWdO?=
 =?utf-8?B?WXo0ZWJvSXlUbzRNSHY3QkdRT013ZzBZWDFMSUZZVjNhTCs0TXZSRVNxVGFq?=
 =?utf-8?B?d3NTckc4REZOL3VpUFJZZVpnR0MzaGhHVWpxdkw3bnpWYTVZV28rdlZnMkZs?=
 =?utf-8?B?QXVLTDZjM3dvU3BkMEhuTitZM2U0Nm1IVWEwZ29ZNEwyY09jbVpQZlpMMHkx?=
 =?utf-8?B?dVo0cmpEZUNnVXhTUzFpOTVvWFFtY2Q5Nm9ET0RWdXkzTlN3YkYrUU1yajlj?=
 =?utf-8?B?QTFwQTc5UzN1ancybUFpZ1ZxZTAvYWwwS085MEwxSzIwL2o4NldTcmtCUWpD?=
 =?utf-8?B?R2d3ZmRBQjlBenhlYUgvcGFsVFNRS01nVFlVaDRIY09YTGhtZHVueXJ1QkZy?=
 =?utf-8?B?cEZBUmVVQk95S2RhWnE3VXRWUUVhVVRSOEt3Q0VkTlphcWRraGowR24xNFl5?=
 =?utf-8?B?RCtJcS8vYzExVmxoM2gyOVIwcmF2TnB2a2VPNWJUL0NqTWh5ODJCblJZTVcv?=
 =?utf-8?B?T0kzY2U1VTNadERKeExCdmUrRldkMnhWTUVqTzdubHFsR0c2cDBwNXNWcENH?=
 =?utf-8?B?dXNiV0V5OGExSmlaWExRblNhdXR3NDVCSUQ2bG81L0VXcVFSZnhXeTRMWkdC?=
 =?utf-8?B?UytZZ011cVdnMy9OQWlQVHJLUndCc25sczd3Q2tTakhDOWtNUDJPWjVpVW05?=
 =?utf-8?B?dWlLMjI4aUlPV2MzTjlqMXpFZ3JTS29QYTZsZlF6YWlLaWQzZDdpZ0EvdjhQ?=
 =?utf-8?B?QzN4WGpXRHI0TWxlZ0tXZkVwRHVSQUxDd2tUTW90NjJPWmJ5NzVxcktBR2Uy?=
 =?utf-8?B?aXJOKzBEZVhZMkU2eW5hb1k2Z2ovQ0JkVWJ6MmlQa0RSclFsSXZ5dlpLVjF3?=
 =?utf-8?B?M0FuUGl4a3VXeFZYWjkyNHV3Z3lpV0J1VGxzdFdQdk80WXBlTER2TE1yNzM0?=
 =?utf-8?B?N2FDMFlJdkgvWjU4VzJBdkc4ZXpiUUlhVUk4TjRaMGNKeFRWS3I5cHhmWkl4?=
 =?utf-8?B?Wlo5ck1FNlpLSUM3QzNLeTRVZGtITW9MRUowYzV6NmZrdnJDSlMyT2VuL0Fy?=
 =?utf-8?B?Ujc0em5EamEvQjZtTzVpQXI2dkprVjV4MHo3TWdYUkNrZ1MwOGlwSUFPRWY5?=
 =?utf-8?B?YkVqTVY1aEpEMk9KaUNqUHJTaFNxb1RLdEpVNXBMMW14ZVZ1QkUvcTRHckts?=
 =?utf-8?B?SHF3Sitkem52VlNKWng3LzZYWUhXanhSb0RMalF0Nyt5UWErTTZzZnJhQ25n?=
 =?utf-8?B?cC9SVWJ5c3NWbFgwbXlVck5SK1YrMEZnWDFtbXB0SHVodHlXd1Q5OFBrb2Y1?=
 =?utf-8?B?VTRVbEV5OEk4dWJBZFVPbHZXTWx0MTBpa3RJbjNmWG0yemtBOVRiWTczdEJW?=
 =?utf-8?B?NG1ZTjQveHBxM2hEQjgvMVhIWnFBcS9RcmxsdXZCcEhicGRlT096TVNZaCtU?=
 =?utf-8?B?ZW82OUVTUkF6VHJzVEp6U1JiT2phMWJDOUtzY2tCSWlPS09XN0VOUVIrRyt1?=
 =?utf-8?B?NW5sSk9XdkQ0ak9Qd1ZmRkVYQ0U1MlpDT3AzVnFYN2QwZHY2UURPSUIyd3V6?=
 =?utf-8?B?NGUwejhPaC83MHpVRnQzK0FQUnk5NzdrS2NxblFXY1o4VTl5c0RhdFBaVnNl?=
 =?utf-8?B?U0x6blplTHFac3RWdXBIeWtoTEdhVlJyNHo2NHhNM0hyditIVHFzMWp0VGI3?=
 =?utf-8?B?ZG02VnRHMzVVaHZhUFZkdGMrSjlQQ2xTM00yV1cwOFQ3bFhCTVZ2Z2pPc2Uw?=
 =?utf-8?B?VWdNRDZ1cFJpVUVQcE5XOVI4Tyt6dThrVjJINnp4UWVaSDg0SWkySjE0aVMw?=
 =?utf-8?B?bVJmQVZSTTJFSkJQR1Y1NHh2MnNJdzNZeFJpdmsvSFFnb3F3enN3M05BbEtF?=
 =?utf-8?B?bUYyaEpna0VNQzFxWUtxQ25HQkROc3J2VWJUQ3F6K25OL3pSSFY3Z3h4eXlX?=
 =?utf-8?B?ZW5aVFJ5RVA0RWpjZWl6eG1Nb3NkZ2NGbjNRTEhPdUs1clBWUGZPVTMrUVlk?=
 =?utf-8?B?bTJVRGppbldwM09MYytsWlgvYnpxekFzVWk2NHVPeHRCT1h6dVRJZHBWSkZy?=
 =?utf-8?B?eGN4Wk9vVE9IVzUzRDdFZVFpZm1wdmdUcDhVWVpFYmI3WTArOGZNZzhCM0lj?=
 =?utf-8?B?bktwYUt0d2gzTUl4LyttVTQ0bkFrSERoL3VwOHRQZExQNkVDcnVYU1IxcGhH?=
 =?utf-8?B?VUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bac4a3ed-a23d-47e0-8157-08daf95ebcaf
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 14:17:32.0456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 38Kz6uQkk1NbSZ+nPkgTodzCqZjv36/x+z1hT0aQpaLbpbRIudES90oWFwnkoBokKvoYjGHgiZ3bcRILptWq/wovOZTa9RIZ2bMiTqwAXCA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6153
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: William Tu <u9012063@gmail.com>
Date: Thu, 12 Jan 2023 06:07:43 -0800

First of all, sorry for the huge delay. I have a couple ten thousand
lines of code to review this week, not counting LKML submissions >_<

> The patch adds native-mode XDP support: XDP DROP, PASS, TX, and REDIRECT.

[...]

> -	skb = tq->buf_info[eop_idx].skb;
> -	BUG_ON(skb == NULL);
> -	tq->buf_info[eop_idx].skb = NULL;
> -
> +	tbi = &tq->buf_info[eop_idx];
> +	BUG_ON(tbi->skb == NULL);
> +	map_type = tbi->map_type;
>  	VMXNET3_INC_RING_IDX_ONLY(eop_idx, tq->tx_ring.size);
>  
>  	while (tq->tx_ring.next2comp != eop_idx) {
>  		vmxnet3_unmap_tx_buf(tq->buf_info + tq->tx_ring.next2comp,
>  				     pdev);
> -

Nit: please try to avoid such unrelated changes. Moreover, I feel like
it's better for readability to have a newline here, so see no reason to
remove it.

>  		/* update next2comp w/o tx_lock. Since we are marking more,
>  		 * instead of less, tx ring entries avail, the worst case is
>  		 * that the tx routine incorrectly re-queues a pkt due to
> @@ -369,7 +371,14 @@ vmxnet3_unmap_pkt(u32 eop_idx, struct vmxnet3_tx_queue *tq,
>  		entries++;
>  	}
>  
> -	dev_kfree_skb_any(skb);
> +	if (map_type & VMXNET3_MAP_XDP)
> +		xdp_return_frame_bulk(tbi->xdpf, bq);
> +	else
> +		dev_kfree_skb_any(tbi->skb);

Not really related to XDP, but maybe for some future improvements: this
function is to be called inside the BH context only, so using
napi_consume_skb() would give you some nice perf improvement.

> +
> +	/* xdpf and skb are in an anonymous union. */
> +	tbi->skb = NULL;
> +
>  	return entries;
>  }
>  
> @@ -379,8 +388,10 @@ vmxnet3_tq_tx_complete(struct vmxnet3_tx_queue *tq,
>  			struct vmxnet3_adapter *adapter)
>  {
>  	int completed = 0;
> +	struct xdp_frame_bulk bq;
>  	union Vmxnet3_GenericDesc *gdesc;

RCT style of declarations?

>  
> +	xdp_frame_bulk_init(&bq);
>  	gdesc = tq->comp_ring.base + tq->comp_ring.next2proc;
>  	while (VMXNET3_TCD_GET_GEN(&gdesc->tcd) == tq->comp_ring.gen) {
>  		/* Prevent any &gdesc->tcd field from being (speculatively)

[...]

> @@ -1253,6 +1283,60 @@ vmxnet3_tq_xmit(struct sk_buff *skb, struct vmxnet3_tx_queue *tq,
>  	return NETDEV_TX_OK;
>  }
>  
> +static int
> +vmxnet3_create_pp(struct vmxnet3_adapter *adapter,
> +		  struct vmxnet3_rx_queue *rq, int size)
> +{
> +	const struct page_pool_params pp_params = {
> +		.order = 0,

Nit: it will be zeroed implicitly, so can be omitted. OTOH if you want
to explicitly say that you always use order-0 pages only, you can leave
it here.

> +		.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
> +		.pool_size = size,
> +		.nid = NUMA_NO_NODE,
> +		.dev = &adapter->pdev->dev,
> +		.offset = XDP_PACKET_HEADROOM,

Curious, on which architectures does this driver work in the real world?
Is it x86 only or maybe 64-bit systems only? Because not having
%NET_IP_ALIGN here will significantly slow down Rx on the systems where
it's defined as 2, not 0 (those systems can't stand unaligned access).

> +		.max_len = VMXNET3_XDP_MAX_MTU,
> +		.dma_dir = DMA_BIDIRECTIONAL,
> +	};
> +	struct page_pool *pp;
> +	int err;
> +
> +	pp = page_pool_create(&pp_params);
> +	if (IS_ERR(pp))
> +		return PTR_ERR(pp);
> +
> +	err = xdp_rxq_info_reg(&rq->xdp_rxq, adapter->netdev, rq->qid,
> +			       rq->napi.napi_id);
> +	if (err < 0)
> +		goto err_free_pp;
> +
> +	err = xdp_rxq_info_reg_mem_model(&rq->xdp_rxq, MEM_TYPE_PAGE_POOL, pp);
> +	if (err)
> +		goto err_unregister_rxq;
> +
> +	rq->page_pool = pp;

Nit: newline here?

> +	return 0;
> +
> +err_unregister_rxq:
> +	xdp_rxq_info_unreg(&rq->xdp_rxq);
> +err_free_pp:
> +	page_pool_destroy(pp);
> +
> +	return err;
> +}
> +
> +void *
> +vmxnet3_pp_get_buff(struct page_pool *pp, dma_addr_t *dma_addr,
> +		    gfp_t gfp_mask)
> +{
> +	struct page *page;
> +
> +	page = page_pool_alloc_pages(pp, gfp_mask | __GFP_NOWARN);
> +	if (!page)

unlikely()? It's error/exception path, you will never hit this branch
under normal conditions.

> +		return NULL;
> +
> +	*dma_addr = page_pool_get_dma_addr(page) + XDP_PACKET_HEADROOM;

Hmm, I'd rather say:

	*dma_addr = page_pool_get_dma_addr(page) + pp->p.offset;

Then you'd need to adujst offset only once in the function where you
create Page Pool if/when you need to change the Rx offset.
With the current code, it's easy to forget you need to change it in two
places.
Alternatively, you could define something like

#define VMXNET3_RX_OFFSET	XDP_PACKET_HEADROOM

and use it here and on Page Pool creation. Then, if you need to change
the Rx offset one day, you will adjust only that definition.

(also nit re newline before return?)

> +	return page_address(page);
> +}
>  
>  static netdev_tx_t
>  vmxnet3_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
> @@ -1404,6 +1488,8 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
>  	struct Vmxnet3_RxDesc rxCmdDesc;
>  	struct Vmxnet3_RxCompDesc rxComp;
>  #endif
> +	bool need_flush = 0;

= false, it's boolean, not int.

> +
>  	vmxnet3_getRxComp(rcd, &rq->comp_ring.base[rq->comp_ring.next2proc].rcd,
>  			  &rxComp);
>  	while (rcd->gen == rq->comp_ring.gen) {

[...]

> @@ -1622,6 +1754,7 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
>  		}
>  
>  
> +sop_done:
>  		skb = ctx->skb;
>  		if (rcd->eop) {
>  			u32 mtu = adapter->netdev->mtu;
> @@ -1730,6 +1863,8 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
>  		vmxnet3_getRxComp(rcd,
>  				  &rq->comp_ring.base[rq->comp_ring.next2proc].rcd, &rxComp);
>  	}
> +	if (need_flush)
> +		xdp_do_flush();

What about %XDP_TX? On each %XDP_TX we usually only place the frame to a
Tx ring and hit the doorbell to kick Tx only here, before xdp_do_flush().

>  
>  	return num_pkts;
>  }
> @@ -1755,13 +1890,20 @@ vmxnet3_rq_cleanup(struct vmxnet3_rx_queue *rq,
>  				&rq->rx_ring[ring_idx].base[i].rxd, &rxDesc);
>  
>  			if (rxd->btype == VMXNET3_RXD_BTYPE_HEAD &&
> -					rq->buf_info[ring_idx][i].skb) {
> +			    rq->buf_info[ring_idx][i].pp_page &&
> +			    rq->buf_info[ring_idx][i].buf_type ==
> +			    VMXNET3_RX_BUF_XDP) {
> +				page_pool_recycle_direct(rq->page_pool,
> +							 rq->buf_info[ring_idx][i].pp_page);
> +				rq->buf_info[ring_idx][i].pp_page = NULL;
> +			} else if (rxd->btype == VMXNET3_RXD_BTYPE_HEAD &&
> +				   rq->buf_info[ring_idx][i].skb) {
>  				dma_unmap_single(&adapter->pdev->dev, rxd->addr,
>  						 rxd->len, DMA_FROM_DEVICE);
>  				dev_kfree_skb(rq->buf_info[ring_idx][i].skb);
>  				rq->buf_info[ring_idx][i].skb = NULL;
>  			} else if (rxd->btype == VMXNET3_RXD_BTYPE_BODY &&
> -					rq->buf_info[ring_idx][i].page) {
> +				   rq->buf_info[ring_idx][i].page) {
>  				dma_unmap_page(&adapter->pdev->dev, rxd->addr,
>  					       rxd->len, DMA_FROM_DEVICE);
>  				put_page(rq->buf_info[ring_idx][i].page);
> @@ -1786,9 +1928,9 @@ vmxnet3_rq_cleanup_all(struct vmxnet3_adapter *adapter)
>  
>  	for (i = 0; i < adapter->num_rx_queues; i++)
>  		vmxnet3_rq_cleanup(&adapter->rx_queue[i], adapter);
> +	rcu_assign_pointer(adapter->xdp_bpf_prog, NULL);
>  }
>  
> -

(nit: also unrelated)

>  static void vmxnet3_rq_destroy(struct vmxnet3_rx_queue *rq,
>  			       struct vmxnet3_adapter *adapter)
>  {
> @@ -1815,6 +1957,13 @@ static void vmxnet3_rq_destroy(struct vmxnet3_rx_queue *rq,
>  		}
>  	}
>  
> +	if (rq->page_pool) {

Isn't it always true? You always create a Page Pool per each RQ IIUC?

> +		if (xdp_rxq_info_is_reg(&rq->xdp_rxq))
> +			xdp_rxq_info_unreg(&rq->xdp_rxq);
> +		page_pool_destroy(rq->page_pool);
> +		rq->page_pool = NULL;
> +	}
> +
>  	if (rq->data_ring.base) {
>  		dma_free_coherent(&adapter->pdev->dev,
>  				  rq->rx_ring[0].size * rq->data_ring.desc_size,

[...]

> -static int
> +int
>  vmxnet3_rq_create_all(struct vmxnet3_adapter *adapter)
>  {
>  	int i, err = 0;
> @@ -2585,7 +2742,7 @@ vmxnet3_setup_driver_shared(struct vmxnet3_adapter *adapter)
>  	if (adapter->netdev->features & NETIF_F_RXCSUM)
>  		devRead->misc.uptFeatures |= UPT1_F_RXCSUM;
>  
> -	if (adapter->netdev->features & NETIF_F_LRO) {
> +	if ((adapter->netdev->features & NETIF_F_LRO)) {

Unneeded change (moreover, Clang sometimes triggers on such on W=1+)

>  		devRead->misc.uptFeatures |= UPT1_F_LRO;
>  		devRead->misc.maxNumRxSG = cpu_to_le16(1 + MAX_SKB_FRAGS);
>  	}
> @@ -3026,7 +3183,7 @@ vmxnet3_free_pci_resources(struct vmxnet3_adapter *adapter)
>  }
>  
>  
> -static void
> +void
>  vmxnet3_adjust_rx_ring_size(struct vmxnet3_adapter *adapter)
>  {
>  	size_t sz, i, ring0_size, ring1_size, comp_size;
> @@ -3035,7 +3192,8 @@ vmxnet3_adjust_rx_ring_size(struct vmxnet3_adapter *adapter)
>  		if (adapter->netdev->mtu <= VMXNET3_MAX_SKB_BUF_SIZE -
>  					    VMXNET3_MAX_ETH_HDR_SIZE) {
>  			adapter->skb_buf_size = adapter->netdev->mtu +
> -						VMXNET3_MAX_ETH_HDR_SIZE;
> +						VMXNET3_MAX_ETH_HDR_SIZE +
> +						vmxnet3_xdp_headroom(adapter);
>  			if (adapter->skb_buf_size < VMXNET3_MIN_T0_BUF_SIZE)
>  				adapter->skb_buf_size = VMXNET3_MIN_T0_BUF_SIZE;
>  
> @@ -3563,7 +3721,6 @@ vmxnet3_reset_work(struct work_struct *data)
>  	clear_bit(VMXNET3_STATE_BIT_RESETTING, &adapter->state);
>  }
>  
> -

(unrelated)

>  static int
>  vmxnet3_probe_device(struct pci_dev *pdev,
>  		     const struct pci_device_id *id)

[...]

>  enum vmxnet3_rx_buf_type {
>  	VMXNET3_RX_BUF_NONE = 0,
>  	VMXNET3_RX_BUF_SKB = 1,
> -	VMXNET3_RX_BUF_PAGE = 2
> +	VMXNET3_RX_BUF_PAGE = 2,
> +	VMXNET3_RX_BUF_XDP = 3

I'd always leave a ',' after the last entry. As you can see, if you
don't do that, you have to introduce 2 lines of changes instead of just
1 when you add a new entry.

>  };
>  
>  #define VMXNET3_RXD_COMP_PENDING        0
> @@ -271,6 +279,7 @@ struct vmxnet3_rx_buf_info {
>  	union {
>  		struct sk_buff *skb;
>  		struct page    *page;
> +		struct page    *pp_page; /* Page Pool for XDP frame */

Why not just use the already existing field if they're of the same type?

>  	};
>  	dma_addr_t dma_addr;
>  };

[...]

> +static int
> +vmxnet3_xdp_set(struct net_device *netdev, struct netdev_bpf *bpf,
> +		struct netlink_ext_ack *extack)
> +{
> +	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
> +	struct bpf_prog *new_bpf_prog = bpf->prog;
> +	struct bpf_prog *old_bpf_prog;
> +	bool need_update;
> +	bool running;
> +	int err = 0;
> +
> +	if (new_bpf_prog && netdev->mtu > VMXNET3_XDP_MAX_MTU) {

Mismatch: as I said before, %VMXNET3_XDP_MAX_MTU is not MTU, rather max
frame len. At the same time, netdev->mtu is real MTU, which doesn't
include Eth, VLAN and FCS.

> +		NL_SET_ERR_MSG_MOD(extack, "MTU too large for XDP");

Any plans to add XDP multi-buffer support?

> +		return -EOPNOTSUPP;
> +	}
> +
> +	if ((adapter->netdev->features & NETIF_F_LRO)) {

(redundant braces)

> +		netdev_err(adapter->netdev, "LRO is not supported with XDP");

Why is this error printed via netdev_err(), not NL_SET()?

> +		adapter->netdev->features &= ~NETIF_F_LRO;
> +	}
> +
> +	old_bpf_prog = rcu_dereference(adapter->xdp_bpf_prog);
> +	if (!new_bpf_prog && !old_bpf_prog)
> +		return 0;
> +
> +	running = netif_running(netdev);
> +	need_update = !!old_bpf_prog != !!new_bpf_prog;
> +
> +	if (running && need_update)
> +		vmxnet3_quiesce_dev(adapter);
> +
> +	vmxnet3_xdp_exchange_program(adapter, new_bpf_prog);
> +	if (old_bpf_prog)
> +		bpf_prog_put(old_bpf_prog);
> +
> +	if (!running || !need_update)
> +		return 0;
> +
> +	vmxnet3_reset_dev(adapter);
> +	vmxnet3_rq_destroy_all(adapter);
> +	vmxnet3_adjust_rx_ring_size(adapter);
> +	err = vmxnet3_rq_create_all(adapter);
> +	if (err) {
> +		NL_SET_ERR_MSG_MOD(extack,
> +				   "failed to re-create rx queues for XDP.");
> +		err = -EOPNOTSUPP;
> +		return err;

return -OPNOTSUPP? Why doing it in two steps?

> +	}
> +	err = vmxnet3_activate_dev(adapter);
> +	if (err) {
> +		NL_SET_ERR_MSG_MOD(extack,
> +				   "failed to activate device for XDP.");
> +		err = -EOPNOTSUPP;
> +		return err;

(same)

> +	}
> +	clear_bit(VMXNET3_STATE_BIT_RESETTING, &adapter->state);

(classic newline nit)

> +	return err;

@err will be 0 at this point, return it directly.

> +}
> +
> +/* This is the main xdp call used by kernel to set/unset eBPF program. */
> +int
> +vmxnet3_xdp(struct net_device *netdev, struct netdev_bpf *bpf)
> +{
> +	switch (bpf->command) {
> +	case XDP_SETUP_PROG:
> +		return vmxnet3_xdp_set(netdev, bpf, bpf->extack);
> +	default:
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +bool
> +vmxnet3_xdp_enabled(struct vmxnet3_adapter *adapter)
> +{
> +	return !!rcu_access_pointer(adapter->xdp_bpf_prog);
> +}
> +
> +int
> +vmxnet3_xdp_headroom(struct vmxnet3_adapter *adapter)
> +{
> +	return vmxnet3_xdp_enabled(adapter) ? VMXNET3_XDP_PAD : 0;

Uhm, the function is called '_headroom', but in fact it returns skb
overhead (headroom + tailroom).
Also, I don't feel like it's incorrect to return 0 as skb overhead, as
you unconditionally set PP offset to %XDP_PACKET_HEADROOM, plus skb
tailroom is always `SKB_DATA_ALIGN(sizeof(skb_shared_info))` regardless
of XDP prog presence. So I'd rather always return _XDP_PAD (or just
embed this definition into the single call site).

> +}

Making these 2 functions global are overkill and doesn't affect
performance positively. They can easily be static inlines.

> +
> +static int
> +vmxnet3_xdp_xmit_frame(struct vmxnet3_adapter *adapter,
> +		       struct xdp_frame *xdpf,
> +		       struct vmxnet3_tx_queue *tq, bool dma_map)
> +{
> +	struct vmxnet3_tx_buf_info *tbi = NULL;
> +	union Vmxnet3_GenericDesc *gdesc;
> +	struct vmxnet3_tx_ctx ctx;
> +	int tx_num_deferred;
> +	struct page *page;
> +	u32 buf_size;
> +	int ret = 0;
> +	u32 dw2;

[...]

> +	dma_wmb();
> +	gdesc->dword[2] = cpu_to_le32(le32_to_cpu(gdesc->dword[2]) ^
> +						  VMXNET3_TXD_GEN);
> +
> +	if (tx_num_deferred >= le32_to_cpu(tq->shared->txThreshold)) {
> +		tq->shared->txNumDeferred = 0;
> +		VMXNET3_WRITE_BAR0_REG(adapter,
> +				       VMXNET3_REG_TXPROD + tq->qid * 8,
> +				       tq->tx_ring.next2fill);
> +	}

(NL))

> +	return ret;
> +}
> +
> +static int
> +vmxnet3_xdp_xmit_back(struct vmxnet3_adapter *adapter,
> +		      struct xdp_frame *xdpf)
> +{
> +	struct vmxnet3_tx_queue *tq;
> +	struct netdev_queue *nq;
> +	int err = 0, cpu;
> +	int tq_number;
> +
> +	tq_number = adapter->num_tx_queues;
> +	cpu = smp_processor_id();
> +	if (likely(cpu < tq_number))
> +		tq = &adapter->tx_queue[cpu];
> +	else
> +		tq = &adapter->tx_queue[reciprocal_scale(cpu, tq_number)];

Interesting solution, the first time I see such. Usually we do just
`smp_processor_id() % num_tx_queues`. I don't say yours is worse, just a
sidenote :)

> +	if (tq->stopped)
> +		return -ENETDOWN;
> +
> +	nq = netdev_get_tx_queue(adapter->netdev, tq->qid);
> +
> +	__netif_tx_lock(nq, cpu);
> +	err = vmxnet3_xdp_xmit_frame(adapter, xdpf, tq, false);
> +	__netif_tx_unlock(nq);
> +	return err;
> +}
> +
> +/* ndo_xdp_xmit */
> +int
> +vmxnet3_xdp_xmit(struct net_device *dev,
> +		 int n, struct xdp_frame **frames, u32 flags)
> +{
> +	struct vmxnet3_adapter *adapter;
> +	struct vmxnet3_tx_queue *tq;
> +	struct netdev_queue *nq;
> +	int i, err, cpu;
> +	int tq_number;
> +
> +	adapter = netdev_priv(dev);

Nit: embed into the declaration?

> +
> +	if (unlikely(test_bit(VMXNET3_STATE_BIT_QUIESCED, &adapter->state)))
> +		return -ENETDOWN;
> +	if (unlikely(test_bit(VMXNET3_STATE_BIT_RESETTING, &adapter->state)))
> +		return -EINVAL;
> +
> +	tq_number = adapter->num_tx_queues;
> +	cpu = smp_processor_id();
> +	if (likely(cpu < tq_number))
> +		tq = &adapter->tx_queue[cpu];
> +	else
> +		tq = &adapter->tx_queue[reciprocal_scale(cpu, tq_number)];
> +	if (tq->stopped)
> +		return -ENETDOWN;
> +
> +	nq = netdev_get_tx_queue(adapter->netdev, tq->qid);
> +
> +	for (i = 0; i < n; i++) {
> +		err = vmxnet3_xdp_xmit_frame(adapter, frames[i], tq, true);
> +		if (err) {
> +			tq->stats.xdp_xmit_err++;
> +			break;
> +		}
> +	}
> +	tq->stats.xdp_xmit += i;
> +
> +	return i;
> +}
> +
> +static int
> +vmxnet3_run_xdp(struct vmxnet3_rx_queue *rq, struct xdp_buff *xdp)
> +{
> +	struct xdp_frame *xdpf;
> +	struct bpf_prog *prog;
> +	int err;
> +	u32 act;
> +
> +	prog = rcu_dereference(rq->adapter->xdp_bpf_prog);
> +	act = bpf_prog_run_xdp(prog, xdp);
> +	rq->stats.xdp_packets++;
> +
> +	switch (act) {
> +	case XDP_PASS:
> +		return act;
> +	case XDP_REDIRECT:
> +		err = xdp_do_redirect(rq->adapter->netdev, xdp, prog);
> +		if (!err)
> +			rq->stats.xdp_redirects++;
> +		else
> +			rq->stats.xdp_drops++;
> +		return act;
> +	case XDP_TX:
> +		xdpf = xdp_convert_buff_to_frame(xdp);
> +		if (!xdpf || vmxnet3_xdp_xmit_back(rq->adapter, xdpf)) {

I think this also could be unlikely()?

> +			rq->stats.xdp_drops++;
> +			page_pool_recycle_direct(rq->page_pool,
> +				 virt_to_head_page(xdp->data_hard_start));

Uff, I don't like this line break. Maybe grab the page into a local var
at first and then pass it to the function?

> +		} else {
> +			rq->stats.xdp_tx++;
> +		}
> +		return act;
> +	default:
> +		bpf_warn_invalid_xdp_action(rq->adapter->netdev, prog, act);
> +		fallthrough;
> +	case XDP_ABORTED:
> +		trace_xdp_exception(rq->adapter->netdev, prog, act);
> +		rq->stats.xdp_aborted++;
> +		break;
> +	case XDP_DROP:
> +		rq->stats.xdp_drops++;
> +		break;
> +	}
> +
> +	page_pool_recycle_direct(rq->page_pool,
> +				 virt_to_head_page(xdp->data_hard_start));
> +	return act;
> +}
> +
> +static struct sk_buff *
> +vmxnet3_build_skb(struct vmxnet3_rx_queue *rq, struct page *page,
> +		  const struct xdp_buff *xdp)
> +{
> +	struct sk_buff *skb;
> +
> +	skb = build_skb(page_address(page), PAGE_SIZE);
> +	if (unlikely(!skb)) {
> +		page_pool_recycle_direct(rq->page_pool, page);
> +		rq->stats.rx_buf_alloc_failure++;
> +		return NULL;
> +	}
> +
> +	/* bpf prog might change len and data position. */
> +	skb_reserve(skb, xdp->data - xdp->data_hard_start);
> +	skb_put(skb, xdp->data_end - xdp->data);
> +	skb_mark_for_recycle(skb);
> +
> +	return skb;
> +}
> +
> +/* Handle packets from DataRing. */
> +int
> +vmxnet3_process_xdp_small(struct vmxnet3_adapter *adapter,
> +			  struct vmxnet3_rx_queue *rq,
> +			  void *data, int len,
> +			  struct sk_buff **skb_xdp_pass)
> +{
> +	struct bpf_prog *xdp_prog;
> +	struct xdp_buff xdp;
> +	struct page *page;
> +	int act;
> +
> +	page = page_pool_alloc_pages(rq->page_pool, GFP_ATOMIC);
> +	if (!page) {

(unlikely nit)

> +		rq->stats.rx_buf_alloc_failure++;
> +		return XDP_DROP;
> +	}
> +
> +	xdp_init_buff(&xdp, PAGE_SIZE, &rq->xdp_rxq);
> +	xdp_prepare_buff(&xdp, page_address(page), XDP_PACKET_HEADROOM,
> +			 len, false);
> +	xdp_buff_clear_frags_flag(&xdp);
> +
> +	/* Must copy the data because it's at dataring. */
> +	memcpy(xdp.data, data, len);

Wanted to write "oh, too bad we have to copy the data" and only then
noticed your explanation that dataring is used for frames < 128 bytes
only :D

> +
> +	rcu_read_lock();
> +	xdp_prog = rcu_dereference(rq->adapter->xdp_bpf_prog);
> +	if (!xdp_prog) {
> +		rcu_read_unlock();
> +		page_pool_recycle_direct(rq->page_pool, page);
> +		act = XDP_PASS;
> +		goto out_skb;
> +	}
> +	act = vmxnet3_run_xdp(rq, &xdp);
> +	rcu_read_unlock();
> +
> +out_skb:

Nit: you can move this label one line below and skip always-true branch
when !xdp_prog.

> +	if (act == XDP_PASS) {
> +		*skb_xdp_pass = vmxnet3_build_skb(rq, page, &xdp);
> +		if (!skb_xdp_pass)
> +			return XDP_DROP;
> +	}

[...]

> +#include "vmxnet3_int.h"
> +
> +#define VMXNET3_XDP_PAD (SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) + \
> +			 XDP_PACKET_HEADROOM)
> +#define VMXNET3_XDP_MAX_MTU (PAGE_SIZE - VMXNET3_XDP_PAD)

Uhm, couldn't say it's valid to name it as "MTU", it's rather max frame
size. MTU doesn't include Ethernet, VLAN headers and FCS.

> +
> +int vmxnet3_xdp(struct net_device *netdev, struct netdev_bpf *bpf);
> +bool vmxnet3_xdp_enabled(struct vmxnet3_adapter *adapter);
> +int vmxnet3_xdp_headroom(struct vmxnet3_adapter *adapter);
> +int vmxnet3_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
> +		     u32 flags);
> +int vmxnet3_process_xdp(struct vmxnet3_adapter *adapter,
> +			struct vmxnet3_rx_queue *rq,
> +			struct Vmxnet3_RxCompDesc *rcd,
> +			struct vmxnet3_rx_buf_info *rbi,
> +			struct Vmxnet3_RxDesc *rxd,
> +			struct sk_buff **skb_xdp_pass);
> +int vmxnet3_process_xdp_small(struct vmxnet3_adapter *adapter,
> +			      struct vmxnet3_rx_queue *rq,
> +			      void *data, int len,
> +			      struct sk_buff **skb_xdp_pass);
> +void *vmxnet3_pp_get_buff(struct page_pool *pp, dma_addr_t *dma_addr,
> +			  gfp_t gfp_mask);
> +#endif
Thanks,
Olek
