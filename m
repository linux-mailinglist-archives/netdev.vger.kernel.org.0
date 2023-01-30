Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 883C4680D98
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 13:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236232AbjA3M1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 07:27:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232776AbjA3M07 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 07:26:59 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD01523658
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 04:26:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675081617; x=1706617617;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Qj62gBusqyKy+9mlorvrtjqpdv32hOaRhv4CLPRk320=;
  b=kxvGKPMWvCrJVSC3T3ZDfDB6BaGxflgxZnXRnfY7bVLE+XMFM//tUfbJ
   c9eitFy1jWAOnwNaZBDVKtJvWDu8sZ2dU75YbLLnw5yIx+RUwIOK1vg70
   ZPpUO60lS0/f4GZWHYbEkxdl7fZO912Cg4ZTODV0EzgMsRAS6SrImqojv
   58veyTZr55JTFB+CgsDTYlaMByaNqP+l6fkD2uT/lNmsWRcSdxQXPnxyK
   3CVCpwsgNUUuXdzwJ7A/TgKRqzurwIj/iyHpNSs6woG7114MVuMzVMTvS
   c2C5Je3mgFAjjXzAAOxgmUqbVV7F2914lSc2L/FfKrz5oE+cvsab6I83V
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="328819921"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="328819921"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 04:26:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="641527171"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="641527171"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 30 Jan 2023 04:26:54 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 30 Jan 2023 04:26:53 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 30 Jan 2023 04:26:53 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 30 Jan 2023 04:26:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=apR5VQWmkyAAjuB/b0qTwWodgEK4zoVn3NnIaZETQrtJWLKy++MmVl0DTsbHRSwlruHr3ns+uw6vE6aZML99UQ7pwD7A1Y4S4/Ra2lZIFYsnG2D/5Kv0sLWC0iZA7JDaQcR4zLzBH9W2EBpr405c1iGhRMnTNb07GXhkW2rl2/pSLEmxybhHNLJolJM7EUEIvjHBD/peX00WHL+DeTSPzS07NEyjkRn/iUIcZ2wER38BzsD7hycYWPcpOzryPsl76G6vxpRSPwM5aXjhMLIia1WWISsHb50HN3CVhzZZFSEvnKYEww32YaAKSxmZPpSS9tCo5bOP28e45C3Ptb80MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ptLL5m3WZ45NfU5jUZO24RHZfHE7uHXxmrcT0rmnJw=;
 b=Cksm4NktXcFcJPxiuiNPkMMNkbxcJ+BRuSW6blVsN+p8zmUIYbVGYQow1tbM9YO/JvyhSE4oDzcaALKM9v0sy1P2jKL3eTLl92n4iYrz+9yTMN35fGM4OyJZtbhtRp2hlG7/PylxPhbqMG2R+6oslOZM8KImxhVqAe0vacDXCB6l/TDnLe5B8UO4D3aHkxVqEV0e33OcvQB5AkJxpzLPU7hjYYMLasdfM8RcdljzGjEhKHOPjr1MhvsW4lXwhhx/1MTY80ceRm0NJbZFaHAymT/z0NEnhsxmFP5n0aTMR2U//GmH6++SL/XKc33teDvBVUJ8+OfTZbeuYdXJuolm6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by CY5PR11MB6461.namprd11.prod.outlook.com (2603:10b6:930:33::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.33; Mon, 30 Jan
 2023 12:26:45 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%3]) with mapi id 15.20.6043.033; Mon, 30 Jan 2023
 12:26:45 +0000
Message-ID: <1e78d2df-2b9e-3e46-017e-5cc42807db03@intel.com>
Date:   Mon, 30 Jan 2023 13:26:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [RFC PATCH net-next v15] vmxnet3: Add XDP support.
Content-Language: en-US
To:     William Tu <u9012063@gmail.com>
CC:     <netdev@vger.kernel.org>, <jsankararama@vmware.com>,
        <gyang@vmware.com>, <doshir@vmware.com>,
        <alexander.duyck@gmail.com>, <bang@vmware.com>,
        "Yifeng Sun" <yifengs@vmware.com>,
        Alexander Duyck <alexanderduyck@fb.com>
References: <20230127163027.60672-1-u9012063@gmail.com>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <20230127163027.60672-1-u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0278.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a1::26) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|CY5PR11MB6461:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c6a997c-764b-4fc3-9e7e-08db02bd4035
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: khCTWaFgfgDfSdCvq8jRWTLHV9HPak18OkTIlzVRsbHrYUpAPucq3IXWHakr04QXgdZVdHX72hT8RaD2OvHfJJmQ8ij95x/AUxKC+I2qJZL+8Zf9GcXQ31Gg4rsPslnox1A1oGbh1196hIT2Dzi1adU7lb1en1vEAfm6bj9nBSx5KbMLc5F/vJnol5qOKdTX5c2PZtUQQP6WNe5WOO73I5ieUYdwNifaaZ2wfIXpn9HTvXGbu/+cguYj2NPYJb02D5brvuuU/F/gB5yyajlbVYnsJqPiPMO3X/tVJWrbcceUZm7QuNfrxuMLBNu4LXZeZoRmEEzY/Y3Up9ohsvaNO9uPJGB4ozVBkO/QffzkjrZBgFlBSY6yNzaEm7pNFHXvpy/4RzjX7iCsGPakMyfHBMkePS0Q7k9SmHbDNu/6wkFOX8DWVfLemJIv54Lt9ulwlEvwNGqzLyalHJhcGyVVJMEqkOYz/T37HvTkj6uyHmQ0EhZvBuhv2JL3OG4qn55lxNB+5UB3Ef2BW64YbH6dozTtJdrvUUfGii2UTwNmrwkMFD/9s4Ado0Kdce54reQAnb/54Qj1bzQ3whaUy5Y9B+hYS/A3kH6M/moFwwwpdA6uZ+GXRlGCsKcrM6LGoiC4HQQYhcFciPJKv33tLZEjapTmzblwBomsBhx1m1JsxPLVQH1Bh7V+sYRzVvoDVo3k6NEVNN4s9sQw8UfcvbD3ibYzEObQri0CvDgLdYl7wzY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(136003)(396003)(39860400002)(366004)(451199018)(31686004)(186003)(6506007)(478600001)(26005)(6512007)(8676002)(6486002)(6666004)(4326008)(6916009)(66476007)(2616005)(66556008)(82960400001)(66946007)(83380400001)(41300700001)(8936002)(19627235002)(86362001)(38100700002)(36756003)(2906002)(5660300002)(316002)(54906003)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NHliSXdtZUFZeU9sZ1FxQllyRkxTczlscjUzbWNvZHFkbVpXWUxEa3VNYmtl?=
 =?utf-8?B?SXhGeHBjeW1Ublg4ak9kQkhwdWIwMEwrN2l2dEJaQXZ4cUYyZlB0MmV5dmVx?=
 =?utf-8?B?TlVUYW1SeDJsclNSQmE1dWQrNVp2dGQ3LzNNSTJmamtwZldQdDRkajdGSzhz?=
 =?utf-8?B?eEFIaFZCRTJXSC8rVmpXZU5UdHFVVWhraThIMjN5MzJXRHFDanliejNZTmI1?=
 =?utf-8?B?VXMwYk1PSE5qRTI3TlBCbUowM0FsdkJvdmVlT3hWSXNrNnU5ZXQwcncxMklz?=
 =?utf-8?B?aUFSbGVOYm1WL051YnZxem9rVEtKbVp3Q0ZFTWtBRm92dGNtbUtac0NYOEF4?=
 =?utf-8?B?bm15eGRMQmhyREVoZ0t0ejJhRk1zU0JQTWpJTmVLd3BrM0lXZ2gzKzFDcXNJ?=
 =?utf-8?B?UU54b0dqQlY5a1B1dWFnZWhNVy9BV2Y3bFZ0V0pkRk14MmdaeitENW1RZEd4?=
 =?utf-8?B?Tzhvd0hwUHhhNFV0MC96cnFHZHF1YVpJZVN5eUtnUXVyeVpPcThFU3o2WDRU?=
 =?utf-8?B?OTBFazVrNDBwbGVMcGgyR0VVOHZZMzd4UDlVTEFRL0F2TlZPcnVEb0ZLbmhm?=
 =?utf-8?B?Y3krMHRzblhGWTlnVUpQTmxJME5EbEdNYVNjbEp4U2hjcTcvYWJZeEg5QWVt?=
 =?utf-8?B?T3VGWnE1VEYrSTVOWlE5aWtLZ3dEcytSOEVpTFh0YlJ5RHJOT1hVQnJQTDY5?=
 =?utf-8?B?elVEYW5hZTlTMzhyR0dJZkFhbU9GWnhNSS9pZmpFTzFEcTVxQklXTXV6Umkz?=
 =?utf-8?B?Rk9pZW5pZS9TcEVxSnV2WjMzeFMwekFzUExxSktmSlZXRnJBQk0ya3kwdjVC?=
 =?utf-8?B?dXRQdHdNYlBreGJpZHplc2JndzZGaEc3ejJxWVFkM3YvbmZwQ3NNNTNxRTRH?=
 =?utf-8?B?RC8wNlJoZWhscDBQU1hjd2JkVnRkWlBXdDZGYllhWnRYT09OdURwUW9ta1lz?=
 =?utf-8?B?dDFVUXo4NUhiWnFQNll1V2VrTEhGTWEvNnlXYWxnejRUbHY4dXFicEl0TGpI?=
 =?utf-8?B?djBiWHJpbW9BcmRjK2d1dVV6SFIwQzdyZ1picnRXYmt6UDRyUnoxUmo5c0J1?=
 =?utf-8?B?OVhWM3FRVmlBTUNreWdEWUw2bUo1cERSNStqVVdORE1FeW4wZDhUWWRnVlBy?=
 =?utf-8?B?WFdiRlZHQzNRa3RURGwzbTl0STh1QnltTytxbU9iSG82b09KMFh1czM2MlVF?=
 =?utf-8?B?NVdCaS96Y3dhNmw3YVc1K3FyVHJ4V1Z2V2NHS3lHdE4ySW9BZTJEWnM1bjN5?=
 =?utf-8?B?QjQ5dHlyT1cxZWhaRXZkK2ZSSlNQYSt4b2hBbXY4VTFpUU45Q1B3bGZJVTRu?=
 =?utf-8?B?YkxmTU9BVkp3UEVTLytiWmRiUnduRFk4ZUF4R3NLOUZmczB3L0htWUtVMW15?=
 =?utf-8?B?ejhUeXo4U2tFVW9WRUl2UUJxak9nQm5wb01sMUNVSjNobkRzQnpvV1N1MzNT?=
 =?utf-8?B?SjlwUXZ3UWI0NDF4QWFwZjBwenB1d09SVno4UWxSV3k5bm55ZFJCREFLa0V5?=
 =?utf-8?B?UHI2dUhuUzkrbEd6WXFrNXc0RDk1dkNZdXg2K1ZMZ29mamt2T1BJREIwWGsv?=
 =?utf-8?B?WmlyUnJLd0dkSWJPNnAxMjExOEw0R2loTzBTbDVoRlp4dnpEV2w0Q2tPNys2?=
 =?utf-8?B?ZWtndDdqS1JBcmpXN1BvMlFGdEhoMFNiZ215L3QrNENmMXAwTWExSUcvZExz?=
 =?utf-8?B?bWxZcXRWOFErbE5Rb2ZLU1EvWWNwNnNrYWVMUkMwb3lKZ1ByMUp1SVRMdWIy?=
 =?utf-8?B?OUx0OURueXljUHRFNnBBRUs3azM3UkdoZzZ1enJMN01Ud0tFQnVtZFFKWncx?=
 =?utf-8?B?YVBKa2xyRWFLUmptaERGWHY3b24xM3FURTRSTmI5ZngwKy92WHZYbXE5bVpV?=
 =?utf-8?B?dlBJSExCUWN4aURpOHdpU0x6UU5qTHJyRkVucGNRb0ZVWlp0UzVwK281ekls?=
 =?utf-8?B?UCtUN2ZvS3RnVjFJTTdGS0tpa0tMTGR1VCt2cUZ4V3E4Zks2OGcwOCtTN21C?=
 =?utf-8?B?Z1FpZUdWU0I4SUowMFN3VlpRMGhIMGs4SUh3UUVEZjBJKzRSRTVoWXgxS2ZD?=
 =?utf-8?B?RHdvbGVNbGVaa2wxaXFuR0hUVnRVR1RKcEZTNitnMEkyc2VEWVZ4ekhqekli?=
 =?utf-8?B?SG1mKzlLL3JNbTFRYlU0NmJicVo4MjI2MDNxcWlpVU1DSlBJN3lzUHhSVWFZ?=
 =?utf-8?B?MUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c6a997c-764b-4fc3-9e7e-08db02bd4035
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 12:26:45.5980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Ty1TmQCzoXe76W61ns2SzjBBvyPhp7WjDx7muo6s4/7YAXvO9rfa9ZgiNKn2d7hVt4DPmilHVHrm3e+TPrCzZAlZI6PxRz8izdVMijmB1k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6461
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: William Tu <u9012063@gmail.com>
Date: Fri, 27 Jan 2023 08:30:27 -0800

> The patch adds native-mode XDP support: XDP DROP, PASS, TX, and REDIRECT.
> 
> Background:
> The vmxnet3 rx consists of three rings: ring0, ring1, and dataring.
> For r0 and r1, buffers at r0 are allocated using alloc_skb APIs and dma
> mapped to the ring's descriptor. If LRO is enabled and packet size larger
> than 3K, VMXNET3_MAX_SKB_BUF_SIZE, then r1 is used to mapped the rest of
> the buffer larger than VMXNET3_MAX_SKB_BUF_SIZE. Each buffer in r1 is
> allocated using alloc_page. So for LRO packets, the payload will be in one
> buffer from r0 and multiple from r1, for non-LRO packets, only one
> descriptor in r0 is used for packet size less than 3k.

[...]

> @@ -1404,6 +1496,8 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
>  	struct Vmxnet3_RxDesc rxCmdDesc;
>  	struct Vmxnet3_RxCompDesc rxComp;
>  #endif
> +	bool need_flush = false;
> +
>  	vmxnet3_getRxComp(rcd, &rq->comp_ring.base[rq->comp_ring.next2proc].rcd,
>  			  &rxComp);
>  	while (rcd->gen == rq->comp_ring.gen) {
> @@ -1444,6 +1538,31 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
>  			goto rcd_done;
>  		}
>  
> +		if (rcd->sop && rcd->eop && vmxnet3_xdp_enabled(adapter)) {

Hmm, it's a relatively big block of code for one `if`. I mean, could we
do it like that?

		if (!rcd->sop || !vmxnet3_xdp_enabled(adapter))
			goto skip_xdp;

		if (VMXNET3_RX_DATA_RING(adapter, rcd->rqID)) {
			...

This way you would save 1 indent level and make code a little bit more
readable.
But it might be a matter of personal tastes :) Just noticed you have
this `skip_xdp` label anyway, why not reuse it here.

> +			struct sk_buff *skb_xdp_pass;
> +			int act;
> +
> +			if (VMXNET3_RX_DATA_RING(adapter, rcd->rqID)) {
> +				ctx->skb = NULL;
> +				goto skip_xdp; /* Handle it later. */
> +			}
> +
> +			if (rbi->buf_type != VMXNET3_RX_BUF_XDP)
> +				goto rcd_done;
> +
> +			act = vmxnet3_process_xdp(adapter, rq, rcd, rbi, rxd,
> +						  &skb_xdp_pass);
> +			if (act == XDP_PASS) {
> +				ctx->skb = skb_xdp_pass;
> +				goto sop_done;
> +			}
> +			ctx->skb = NULL;
> +			if (act == XDP_REDIRECT)
> +				need_flush = true;

			need_flush |= act == XDP_REDIRECT;

But this looks a big ugly to be honest, I just wrote it to show off a
bit :D Your `if` is perfectly fine, not even sure the line I wrote above
produces more optimized object code.

> +			goto rcd_done;
> +		}
> +skip_xdp:
> +
>  		if (rcd->sop) { /* first buf of the pkt */
>  			bool rxDataRingUsed;
>  			u16 len;
> @@ -1452,7 +1571,8 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
>  			       (rcd->rqID != rq->qid &&
>  				rcd->rqID != rq->dataRingQid));
>  
> -			BUG_ON(rbi->buf_type != VMXNET3_RX_BUF_SKB);
> +			BUG_ON(rbi->buf_type != VMXNET3_RX_BUF_SKB &&
> +			       rbi->buf_type != VMXNET3_RX_BUF_XDP);
>  			BUG_ON(ctx->skb != NULL || rbi->skb == NULL);
>  
>  			if (unlikely(rcd->len == 0)) {
> @@ -1470,6 +1590,26 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
>  			rxDataRingUsed =
>  				VMXNET3_RX_DATA_RING(adapter, rcd->rqID);
>  			len = rxDataRingUsed ? rcd->len : rbi->len;
> +
> +			if (rxDataRingUsed && vmxnet3_xdp_enabled(adapter)) {

Maybe save 1 level here as well:

			if (!rxDataRingUsed || !vmxnet3_xdp_enabled(ad))
				goto alloc_skb;

			sz = rcd->rxdIdx * ...

> +				struct sk_buff *skb_xdp_pass;
> +				size_t sz;
> +				int act;
> +
> +				sz = rcd->rxdIdx * rq->data_ring.desc_size;
> +				act = vmxnet3_process_xdp_small(adapter, rq,
> +								&rq->data_ring.base[sz],
> +								rcd->len,
> +								&skb_xdp_pass);
> +				if (act == XDP_PASS) {
> +					ctx->skb = skb_xdp_pass;
> +					goto sop_done;
> +				}
> +				if (act == XDP_REDIRECT)
> +					need_flush = true;
> +
> +				goto rcd_done;
> +			}

alloc_skb:

>  			new_skb = netdev_alloc_skb_ip_align(adapter->netdev,
>  							    len);
>  			if (new_skb == NULL) {

[...]

> @@ -217,6 +221,9 @@ struct vmxnet3_tq_driver_stats {
>  	u64 linearized;         /* # of pkts linearized */
>  	u64 copy_skb_header;    /* # of times we have to copy skb header */
>  	u64 oversized_hdr;
> +
> +	u64 xdp_xmit;
> +	u64 xdp_xmit_err;

Sorry for missing this earlier... You use u64 here for stats and
previously we were using it for the stats, but then u64_stat_t was
introduced to exclude partial updates and tearing. I know there are
stats already in u64 above, but maybe right now is the best time to use
u64_stat_t for the new fields? :)

>  };
>  
>  struct vmxnet3_tx_ctx {
> @@ -253,12 +260,13 @@ struct vmxnet3_tx_queue {
>  						    * stopped */
>  	int				qid;
>  	u16				txdata_desc_size;
> -} __attribute__((__aligned__(SMP_CACHE_BYTES)));
> +} ____cacheline_aligned;
>  
>  enum vmxnet3_rx_buf_type {
>  	VMXNET3_RX_BUF_NONE = 0,
>  	VMXNET3_RX_BUF_SKB = 1,
> -	VMXNET3_RX_BUF_PAGE = 2
> +	VMXNET3_RX_BUF_PAGE = 2,
> +	VMXNET3_RX_BUF_XDP = 3,
>  };
>  
>  #define VMXNET3_RXD_COMP_PENDING        0
> @@ -285,6 +293,12 @@ struct vmxnet3_rq_driver_stats {
>  	u64 drop_err;
>  	u64 drop_fcs;
>  	u64 rx_buf_alloc_failure;
> +
> +	u64 xdp_packets;	/* Total packets processed by XDP. */
> +	u64 xdp_tx;
> +	u64 xdp_redirects;
> +	u64 xdp_drops;
> +	u64 xdp_aborted;

(same)

>  };
>  
>  struct vmxnet3_rx_data_ring {

[...]

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
> +
> +	dw2 = (tq->tx_ring.gen ^ 0x1) << VMXNET3_TXD_GEN_SHIFT;
> +	dw2 |= xdpf->len;
> +	ctx.sop_txd = tq->tx_ring.base + tq->tx_ring.next2fill;
> +	gdesc = ctx.sop_txd;
> +
> +	buf_size = xdpf->len;
> +	tbi = tq->buf_info + tq->tx_ring.next2fill;
> +
> +	if (vmxnet3_cmd_ring_desc_avail(&tq->tx_ring) == 0) {
> +		tq->stats.tx_ring_full++;
> +		return -ENOSPC;
> +	}
> +
> +	tbi->map_type = VMXNET3_MAP_XDP;
> +	if (dma_map) { /* ndo_xdp_xmit */
> +		tbi->dma_addr = dma_map_single(&adapter->pdev->dev,
> +					       xdpf->data, buf_size,
> +					       DMA_TO_DEVICE);
> +		if (dma_mapping_error(&adapter->pdev->dev, tbi->dma_addr))
> +			return -EFAULT;
> +		tbi->map_type |= VMXNET3_MAP_SINGLE;
> +	} else { /* XDP buffer from page pool */
> +		page = virt_to_head_page(xdpf->data);

Nit: your page pools are always order-0, thus you could shortcut those
virt_to_head_page() throughout the drivers to just virt_to_page() and
save at least 1 unlikely() condition check this way (it will always be
false for the pages coming from your page pools). I remember we had huge
CPU load point on this compound_head() check inside virt_to_head_page()...

> +		tbi->dma_addr = page_pool_get_dma_addr(page) +
> +				XDP_PACKET_HEADROOM;
> +		dma_sync_single_for_device(&adapter->pdev->dev,
> +					   tbi->dma_addr, buf_size,
> +					   DMA_BIDIRECTIONAL);
> +	}

[...]

Those are some minors/propositions, up to you whether to address the
rest was addressed perfectly by you, thanks!

Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>

Olek
