Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 150A46D243E
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 17:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233228AbjCaPnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 11:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233218AbjCaPnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 11:43:22 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D046E98
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 08:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680277401; x=1711813401;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vm9fry+KGa/fXrnNJ9qMrh89Qto0bi9LqYFwoQpVxGM=;
  b=PYRwAw07lWsomvl3oNKEZIuvAK1Twma+EP9p2Hkwgjq8KyyhxgA2cL1y
   3aUtfrSMR0Jwls3W/aMaSpe/H1+wDUWk3VnFExrDH4TztFZpO/06nOXyj
   rKppFQrfuJg/sBQkrerl38x2zasg8BAFSDhHL2lpx+xPG4aeMVn/2dMKZ
   etb6duV40MFP/pGiXLWJctQ0gcsID3/jKn+gYbjjUyE2c2cN5QLa7lxA5
   kD4B0jOXYeTMfNPRKdVdxJax0h3ptaonWpbNoqJan4ZiDFxSzaP72sUne
   jQGFJra5DgKxJXOLcwRiHJoQhEaWHMVJ6HQ/Ro6ghmaa4d2difX7yXPsD
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10666"; a="343147033"
X-IronPort-AV: E=Sophos;i="5.98,307,1673942400"; 
   d="scan'208";a="343147033"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2023 08:43:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10666"; a="749686762"
X-IronPort-AV: E=Sophos;i="5.98,307,1673942400"; 
   d="scan'208";a="749686762"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 31 Mar 2023 08:43:21 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 31 Mar 2023 08:43:20 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 31 Mar 2023 08:43:20 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 31 Mar 2023 08:43:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f8nn9kq0YaxVJUYzlg2l8uoR/gdwQGRkXClcA5sPU2yivU3TLRrWDE0hZlEP+PWLX23oE9moaZ2RVI2qciUHYKRkh/ZkeBtsKTYRBQJQIHuQ4LML+zK0HdvLjqYB4O/uJaAbGx0h2dTS3Z/0Tm67Z7oj7/3kso0d5wI4CAS/VlGXT8f76oL7/2gqXnvjg8sHWKKRLpXjsJmQznOifDQPmyPKgwY5sMv5A1DIkS95UY/7vQRFeG/uhWMCY5xbiNFNDiISUp0a0rbTx3APYoTGUqAvxEDYoLrwcS0UCMW6jG8LSZk5Exd2P638pX+slDQPi69Xzcr1wr9gNM7hfx3ymg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=clKtPEEmsMU8MseoG87NekUbhJrINyG7NgD0ZhamEkY=;
 b=nETEcQVmfTyLt1wYqqWp8giChUGa9co775dmfRoHP3zSpOY2qWd+Cc2gaTQqkTj7tBH11HxSFYbkafLA8ktxrTxVpkOTWut1UzFfGxuE0ksYYDgl8oBzFV5CxALIXZ0cmIaRGplOqFFjsGhyk+HA053x+10NC0w+tlOaLRii3cPcK9NZg9Usak6dkeYrh9ikdWZgKaauE5m++R4LKaDVbAX4cBGNk60fOuIiDVElH+/eecgWkwA38ZSDVAmPGbYK5N0rRBY3Cx6/nYGZ+ydD/fWmSNVbciA3MzxOvm9mpjN4KY770h/cWR+zN13aIUOcEDHwg0wNW1pSsb3RJXxcVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by IA0PR11MB7837.namprd11.prod.outlook.com (2603:10b6:208:406::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.20; Fri, 31 Mar
 2023 15:43:15 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224%5]) with mapi id 15.20.6222.035; Fri, 31 Mar 2023
 15:43:15 +0000
Message-ID: <1ef142e0-43dc-8f18-e67b-2020af37fd17@intel.com>
Date:   Fri, 31 Mar 2023 17:43:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH RFC net-next v19] vmxnet3: Add XDP support.
Content-Language: en-US
To:     William Tu <u9012063@gmail.com>
CC:     <netdev@vger.kernel.org>, <jsankararama@vmware.com>,
        <gyang@vmware.com>, <doshir@vmware.com>,
        <alexander.duyck@gmail.com>, <alexandr.lobakin@intel.com>,
        <bang@vmware.com>, <maciej.fijalkowski@intel.com>,
        <witu@nvidia.com>, <horatiu.vultur@microchip.com>,
        <error27@gmail.com>, Alexander Duyck <alexanderduyck@fb.com>
References: <20230325172828.24923-1-witu@nvidia.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230325172828.24923-1-witu@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0132.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:94::12) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|IA0PR11MB7837:EE_
X-MS-Office365-Filtering-Correlation-Id: cc9235ed-8e5d-4729-5aa2-08db31fea471
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JCpZoN0YA0Z8tkly7WegYPP/Zf7i0iMctphYkfvBnMMDvIvzUXfw6cghwIqh7bBAQik7kBssCVa43ye0Agj6RhKTopmxdzl0gSlosqfVlKeAl68AJmTP0yGtI4oEm3TtXSY0GZCHgfVHPzCfjo61DX4YBOv3SiMxDdDgPYptp9VRF38kgf1W5Y2xY1rgHyl/WQ1VN610tc/WO3nABc0Ouc6Lzb8HwFlb6CGlPy/lOC8UPFPf4M4F1oXPHMuVAEuLNAlqqYhsKNMeRT31PmoH7AZVLQOYQs7WqGY1sgCW9xoCffRnoI8wZZPh0iHTQXEhW8phZUCUUkX9Bc27A80Pyi3ezr2qwkVILS8PxvuRZRlkF86dj/3j31YWOa9KKu1jICBzULq8YVF+6FEfQl4tnlOA74iORqXqi7ixRigmS0GSdFEaxONcjj+opjuFWIpPZojHY7iqG/c88oOijTCQYSloEiYFHpf54+HPQF2f97KzZbHRJ/+yBBvVq790UothjAdBt572JpWjCyO55LVDOSR7AuCr7sN5vCg6uS2PEaWiCdTzJU7TA9biQn1YkciFmxLFmgkS+BoesvAMSDa1856nJ+8NCi6SIswVh7n3e88Pbm38mAJtxmMRuEbsNcKtqdgokxD7/2tfHOaDmCxJVA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(376002)(136003)(39860400002)(396003)(451199021)(5660300002)(7416002)(8936002)(86362001)(2906002)(41300700001)(31686004)(8676002)(66476007)(66556008)(6916009)(66946007)(4326008)(2616005)(316002)(19627235002)(478600001)(36756003)(6486002)(6666004)(6512007)(6506007)(26005)(186003)(83380400001)(82960400001)(38100700002)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cERFUWZqNHpkRkIwcWJ1RUpGRG1Pc2diRmk3U3NqdDJZdnNpN1R0RTVsQUZK?=
 =?utf-8?B?MU9FL2VtTS9raHk3aDZVVG1FdWtGZjRjL3kvQmNZaGhGWGg0TEQ5MGhlaVVq?=
 =?utf-8?B?bDV0NSt0SU5nYnAwSzM4Tm9NZzhnWGhqZkNjUzNCaUxVWXZHSW5wWEMyTHhJ?=
 =?utf-8?B?Z2NnSk5rd3dBazU2TDhvSDJ6elFpd09NR3ZoMkx2Ymk2M3U4cGhxa2kvU1Rt?=
 =?utf-8?B?UHdQNFdPTC8vSi9NOWlhMjEycUgydThTR1M5c3pRZER0WFFRNGsvRWFITFcy?=
 =?utf-8?B?dHllYnpMT3F4aS9sdlViRVNCWGVBU3ZzbE1Nd25tUEtCNUNVZjJIaGI5SFRT?=
 =?utf-8?B?ZFdWbHVDOXFyNHprRFRscndZRGtyWGc1SGlISWtyZTRmQ2s5U3RpejJ6cmFT?=
 =?utf-8?B?a1NDYTVhc2tOTXdDN1pYT2d3TEFEL1lrQlBGNUhpRjFLbEF2U2dqZkNmRjZE?=
 =?utf-8?B?WTR2QVlVMTVDaUpvVnFES3YvVEVZMkw3NXVteUlkbWtlcGZkMHFicDM2VHAy?=
 =?utf-8?B?bXBSQWoxdU1SYjVDNGFYUE1Ca2d0VkhBWnpTT0pKWVF1Y3pIaGdVYU83emJI?=
 =?utf-8?B?d1cxN2NjcElJVjJmRDM4L1J2MldiL0JZdjVRNHJObytuUTdXM2xDNENYVEtw?=
 =?utf-8?B?eCtqYk9xQm56T0dVSUc4a3hZdXl4SjFZQ3c2azZaMWFmUzVoTkZ5TWx3UUlL?=
 =?utf-8?B?bHg2YW9pQlFuRnRyNG0vM2dpcGNwZGs2bWJHR1VMbCtvbXBTRU96OGhTNDFH?=
 =?utf-8?B?VGxFKzlYQjZPNGR3WVdVdWtRMWJzeFhFT0xUQVVpeUJJVHRWYjhmWU15STFn?=
 =?utf-8?B?TUVkbWFObFQ1ZUtOMzM3THZCamRlazZoTm5yeWdOY2VyK09tanpIVC9tOUV2?=
 =?utf-8?B?UjRObVhVd2d5R1gxRXd0UHZ4Qm1Da21ibk1yNS9TOGNZQmQ0QVAyeXEybVZZ?=
 =?utf-8?B?ZjBZWklEQUMzS2JLMlhKbWtxMU1IMDg0WG5adXI3TER2OEN4YTVxaUxKOVdq?=
 =?utf-8?B?MS9kbGhsZGs2RmZVbFFqemp6WmRqdFo4SWVjMnJEeDFPMVBuWVRoMnVPM1dt?=
 =?utf-8?B?elZMZTQ2MDd5VFRqK3owTGdFOXd1cU1UTkJldmNiVHZoVDRZTzZnak5HQy90?=
 =?utf-8?B?UTI1ZWxBZWU0WnNDS242azNtNEw5SXpvYkhkdFcvdmV4KzQ3MitmQnE2QkNJ?=
 =?utf-8?B?VWFyUnZsNUdrYjZyclNvYTFEbWsvYitmbUxXME1leHd6c0MvSXNUTXBTN2JO?=
 =?utf-8?B?UXpBMXNHNlFtYmxXQXVhVFF6bFVoNnU1elYxZDVJZlpSS0l0QnAyVUJtbEVI?=
 =?utf-8?B?c0hCSXNmSHNVdkVLZmVCUjBaREsvc3lROFFlU2tsMmJMaFZ6dUtKTW9HdnNm?=
 =?utf-8?B?V2NyWG1LK2ZIWEVBVi9jTzQrQ3d6Zk9SVFVoVFNiZXd5UXBENU5FRGhiNzd5?=
 =?utf-8?B?TE5qb3UzTHl3YXNKSXVwOHpWcmcwMENReG9YcEJ0OEw3a3RUVy9FZUVraGVs?=
 =?utf-8?B?ZEpGOG9tRk80WkQrMnljT2Q2d1U0THF5RUY0ZXVLTms3dGxaclBzV2lmcHR3?=
 =?utf-8?B?bkszV3gzcnZPVzJ4OUlUeGpYSk4rRnNpUWZmOStNeUdnWG50Y1FjQ21vdmFk?=
 =?utf-8?B?czlFQVJCVW5pb3V4S3huS2hkUDR1VGRTenUzMzZKR3c1c0Q5c0ZNcDd3V0VH?=
 =?utf-8?B?cHl2NDR0RGtFSmpuSVhVQm0wT2trQStCMDZLaGNmQ3lSVWxjUFN3TGJaenM0?=
 =?utf-8?B?dlI0Zmc4MGorbWxzNENUdUtjSFZsYy9CYlJTMjZjZGRVQWhmUWpZekt0cldO?=
 =?utf-8?B?TDJTMThaWitXaGpZL0VhSUdianpMaVFRWnNxMFk1d1B6ZnA3Rk5CZlFIOVhM?=
 =?utf-8?B?U1JxejFHU0NiSjRFY2lFM2NKTXVTQjFsUUowSzdscWxtRkh3QkhUZnNhSk9L?=
 =?utf-8?B?NlU0bkxNMlNKeEg2V2hpTFVqaXcrTXhBZFJJK2JCVy9Tcm9wTktBNHlyc0h0?=
 =?utf-8?B?RU9kN1o4T3dJZVpHRGRXY0FDRzNKSHhUUnU2T0N6UmlDbjhVMnlWR2ptaHd3?=
 =?utf-8?B?UUl6ZDJaMmMwUWRUb3BiaFZrYldZUW9FZEZEbWZTbHVHTGVYMy8zUzM2Q1pP?=
 =?utf-8?B?MmQ2c093Yms5d212RTZYS3ZkRnlCNUNxcVlIUmZoTHVhN1ZlRTBNcTFtVS9T?=
 =?utf-8?B?U0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cc9235ed-8e5d-4729-5aa2-08db31fea471
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 15:43:15.5782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9DMEM074E5qloD3cc6qtGmvZjqtQ9RaK6mTyA272GMLQHhXRb9sux63o6utL8HiMWhodJnPK5VGT+zTKAsl8cGlQ9wt0ObYSKsgWiAMK1H0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7837
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: William Tu <u9012063@gmail.com>
Date: Sat, 25 Mar 2023 10:28:28 -0700

Sorry for the late reply, I've been busy :s

> From: William Tu <u9012063@gmail.com>
> 
> The patch adds native-mode XDP support: XDP DROP, PASS, TX, and REDIRECT.
> 
> Background:

[...]

> +static int
> +vmxnet3_run_xdp(struct vmxnet3_rx_queue *rq, struct xdp_buff *xdp,
> +		struct bpf_prog *prog)
> +{
> +	struct xdp_frame *xdpf;
> +	struct page *page;
> +	int err;
> +	u32 act;
> +
> +	act = bpf_prog_run_xdp(prog, xdp);
> +	rq->stats.xdp_packets++;

I think you can increment it *before* running the program, so that
there'll be as tiny time gap as possible.

> +	page = virt_to_page(xdp->data_hard_start);

You don't need it for PASS and REDIRECT.

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

BTW, if you get @err here, shouldn't you recycle the page, just like in
TX case?

> +		return act;
> +	case XDP_TX:
> +		xdpf = xdp_convert_buff_to_frame(xdp);
> +		if (unlikely(!xdpf ||
> +			     vmxnet3_xdp_xmit_back(rq->adapter, xdpf))) {
> +			rq->stats.xdp_drops++;
> +			page_pool_recycle_direct(rq->page_pool, page);
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
> +	page_pool_recycle_direct(rq->page_pool, page);
> +
> +	return act;
> +}

[...]

> +	xdp_init_buff(&xdp, PAGE_SIZE, &rq->xdp_rxq);
> +	xdp_prepare_buff(&xdp, page_address(page), rq->page_pool->p.offset,
> +			 len, false);
> +	xdp_buff_clear_frags_flag(&xdp);
> +
> +	/* Must copy the data because it's at dataring. */
> +	memcpy(xdp.data, data, len);
> +
> +	rcu_read_lock();

Where's the corresponding unlock?

> +	xdp_prog = rcu_dereference(rq->adapter->xdp_bpf_prog);
> +	if (!xdp_prog) {
> +		act = XDP_PASS;
> +		goto out_skb;
> +	}
> +	act = vmxnet3_run_xdp(rq, &xdp, xdp_prog);
> +
> +	if (act == XDP_PASS) {
> +out_skb:
> +		*skb_xdp_pass = vmxnet3_build_skb(rq, page, &xdp);
> +		if (!*skb_xdp_pass)
> +			return XDP_DROP;
> +	}
> +
> +	/* No need to refill. */
> +	return act;

Maybe

	act = vmxnet3_run_xdp(rq, &xdp, xdp_prog);
	if (act != XDP_PASS)
		return act;

out_skb:
	*skb_xdp_pass = vmxnet3_build_skb(rq, page, &xdp);

	return likely(*skb_xdp_pass) ? act : XDP_DROP;

?

> +}
> +
> +int
> +vmxnet3_process_xdp(struct vmxnet3_adapter *adapter,
> +		    struct vmxnet3_rx_queue *rq,
> +		    struct Vmxnet3_RxCompDesc *rcd,
> +		    struct vmxnet3_rx_buf_info *rbi,
> +		    struct Vmxnet3_RxDesc *rxd,
> +		    struct sk_buff **skb_xdp_pass)
[...]

Thanks,
Olek
