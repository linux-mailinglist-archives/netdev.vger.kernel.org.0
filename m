Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06CED6E151C
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 21:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjDMTWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 15:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjDMTWS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 15:22:18 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39E410B
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 12:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681413737; x=1712949737;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fsHJL9TskUPpAX7N8bJqmcNni2AHaL+NECZH23jW4kM=;
  b=Ct+F/mAvPEuhZIx0qGoE+Ix2BTvbmq4XxjXdYN9aEYz83WqEpjXKQT2O
   5qGe1AC4TjVEbOKTRCORpHqIebjw3iIxwAI0ReE9U5Qu1Y8niD6P0xCz+
   iUJIPZf2xUEPZbHnKuimVe+ocixp0N+2URJXHW08LAay1bNX6nmP++N9g
   fyvJZ+oTOFlanpm1c57bHhUca9UrASltk4nD6GQNMDcH0elJMiIMt+dAc
   uUkYl1Dr8RLDWsWECyb7Ha3pTYumKugnmuo/wNFHOa47RwaX5oG0XX7G8
   LRPqB3sRsoIMU1RNC2w8E4+cnYL1PuFHxR/q+Tm1kDxL6NrZI2m+qZaRM
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="344278205"
X-IronPort-AV: E=Sophos;i="5.99,194,1677571200"; 
   d="scan'208";a="344278205"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 12:22:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="720000062"
X-IronPort-AV: E=Sophos;i="5.99,194,1677571200"; 
   d="scan'208";a="720000062"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 13 Apr 2023 12:22:14 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 13 Apr 2023 12:22:13 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 13 Apr 2023 12:22:13 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 13 Apr 2023 12:22:13 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.48) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 13 Apr 2023 12:22:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U3mpogNv63suET8xGBDgZF/hyw8oWdgFs+9AS1EbgYWXDs0HkYVpeCZxPt29A6FX9JsT2BJ8GjshvHJYhjePjtFRj3nRdHE2y9kU3KlLx2SbXU9ugEE7fZtTRjshbKrpaqHEE8cRyn6PJqS3tPECBsOa8zg0R4FqozE1U8zEYcM3Ri3ThFZ1PbLhXJfKlkwfgr9eJE8wbdSALu2N6+4r9YugL3R/HPUHJhDGprRNGdlGo7W9zggfeOeCzvOjxS5z6c28Ceu6rOevuqVo/LL3zCs6u3fugUEXtzaRqobxOpEQbpfJxO3waM4vGb70i/ZzMy5Mq6HwXGMx1rHHjuUTNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bim3bagFDeqOQmK24KRlxGdjO533qhqNg8QBBYtrsdE=;
 b=R10WzC167gTjMfUtA6EwuQIxLLOpdk+kpHzs+eR/O4T78fOiDB7TTmu2hsIjuF94TrsF++Op2nInhtdbt05nW6XqeOJFQf8AwGgRzTEKhMN/uOqcmtJTbJ/dZHi0La4S+m/9iiuddBy6EtqfwE+NlP0WCmdzOCwWj9zfFJBIPcYtECNdOr8wuZiyIzILx0zreYDNMGAXhN9/b2KQJDV32WXL/vrlOBR/itzl8fxqd9NLcz5mpGCQqXlnXsYnx672GeS1odUzLeM6dIMX+DTFVO4Elx/WNBEvP+kAaCGIIuE5dB5KhfBGGPGeIIl6B2fxAzSooQqhqdyhwhYcTo73Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MW4PR11MB6984.namprd11.prod.outlook.com (2603:10b6:303:22e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Thu, 13 Apr
 2023 19:22:11 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b%2]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 19:22:11 +0000
Message-ID: <4d9c854f-16c7-66e4-34d0-498147d0acdf@intel.com>
Date:   Thu, 13 Apr 2023 12:22:09 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 1/3] net: add macro netif_subqueue_completed_wake
Content-Language: en-US
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        "Eric Dumazet" <edumazet@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <32e7eaf4-7e1c-04ce-eee5-a190349b31f9@gmail.com>
 <16e51984-a539-24d4-a2d6-604c0b75f14b@gmail.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <16e51984-a539-24d4-a2d6-604c0b75f14b@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0010.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::23) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|MW4PR11MB6984:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c855324-a5e3-4cbc-8f56-08db3c54617c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tmEmu18xYf0vwIUqs88QHF5HW7qZNuIJiTpGrt5i5lD/2LEfaQGRZrczGMEdQnl1CQB7VlmPzbkCxlBm/ghmRwA/kNQEbIBPK8t9gANU4jXJH4jMYybJF7ZYiSO6V0YRDWFRhAzO+gKPXpxfkjP2LQvgnJ+WiUcSSKfBipzUJvg807mKaG+XBI4v2vUkxpgP3uT2gAA/5fidhY2oPRhTiWsiSG3Yz8qvhnsyQjP+qVKb6hTKPtXdr25dovrqR6/2jEzqF1+ZC+j3gi3hZFcavjGPPRxnV+VHFFb1TMuAdZK3TurTpHksh7BRGHQcE/wAF4xguGyGMoLR/QIxot69vAURF+w05ZOwX2FXq7wHDHkTStx1QxlG48kndkF8XltkyzvHBNFOjamI5A4anjBtsdrTJ6Qu3poGoh4DoiVWFu4TKGChRR54MFFQukGxMprOb1Zb4gU5DVuatEjoGVlOZ5N7QuPwKP1Kps1gifDrBab2WPRpz8vJx7HMuaKfXmmSKSB6llL7OJhK44W+Mk3omp28XQHyW/d69AfghwmU/p+xRy/Q5dEMjlFpyzMcMN1LPAY8or5avvaYbh0n+33b7lscW7yuaU8eiOrSqT5QIrS5lfsrEjZ5qAyogPVFuYkk4RW8nbDYP9qUO7q/bN1ebQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(366004)(396003)(346002)(376002)(451199021)(31686004)(6506007)(478600001)(26005)(53546011)(31696002)(6512007)(82960400001)(4326008)(66476007)(66556008)(66946007)(6486002)(110136005)(316002)(86362001)(186003)(8936002)(41300700001)(8676002)(36756003)(2616005)(5660300002)(4744005)(2906002)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?REhYa1pISWFOZ0lhZXVYVGgzNER1VWlSUFJiV041V0JHVThEN21oZG95ZEto?=
 =?utf-8?B?Szlsb3BBaHJtblY4NmV1S2JGTitDWi93M1ZiUzE3YzM4bzRaSzFiTzJLaUtw?=
 =?utf-8?B?a3lXZVB3clRyR21MWjA0SVdvbTRCNFZaSGtQRzRQdnBVejgrNWFOYUcxZi94?=
 =?utf-8?B?UnNVMWI4RmxLeWlxZ0NGc3lhMkNHdzFOa2NaeVpuQXVQOU5MWkQ5RE1mdGdo?=
 =?utf-8?B?ZTdIRzd5R1pEMk5PRkIwOEZDUXBqOEl1cmpMejZGdVBqdW8yaEJ4N0REWThH?=
 =?utf-8?B?YVk4aGVUSy9sMm5aS0VkZGFoUDI5WGJFdEIrRGVoWWVsS20wWFJUUzZWdTVU?=
 =?utf-8?B?dGEyalZ2MGJPV2t3d2N1ZklzbVhLcGhYcmloOEl1QWNNWmtMYWcvNjJsWWt6?=
 =?utf-8?B?RU42cVRPcjkyN0NXdTZwUVVzdDE1ODF3R0RNQXlMNlRkUG1OZEdGb2NwMFNw?=
 =?utf-8?B?bXpqaElWS01mdXBUMmUzQU42VVd4MFppckk2ZnE1c1kzaTVKMTRWYnFUUXkx?=
 =?utf-8?B?bDFtSGlOQzFWUTBOdFdiRFpIQmlBejhkdEcrNTF2V3ZFK3MvWFBKMDhwcXRX?=
 =?utf-8?B?UjNUQy83NGZhVHI5L1dUK2h5TVdNYS9oYy9NSzdVVmZzQUN1VkpCVWppcFAz?=
 =?utf-8?B?MXhUOEt4S0hteTR0SHJEd0N1S3NSTUlhVmx2cTNjQmhMOXJKWDJJN0g2WlRu?=
 =?utf-8?B?MVZJL3lwT2RwMC93V3FWVEtGaDE3U3k0ak9IWFhHcWRIR1QvMlJHVG1YUTNQ?=
 =?utf-8?B?b1p6YUN5VDJCa0YyWUpweDFRd2Nqb21hbXFXS0lJTStjbXJ6ODQ5THYvQXVX?=
 =?utf-8?B?OG5VcmgyczhHeFJ3Z3N5UXNOMWhBN0VoMEpTeFhJN0VUME1TOXJVbTE0NHlK?=
 =?utf-8?B?dXd3L251REZ0TjhPc1ArWGFsM0ZIcVYvbVJ5UUFrbjRwUUFwMSs5MjMvMXZR?=
 =?utf-8?B?b2dvNlQwNUJjQUV4MmhRa09ja09vbCsxY2xGZjQyWTZVaWc2M2lRVmM1M1M5?=
 =?utf-8?B?U0RmcngzdExxVUZjcjBnUm11VHZ6dDRPRDgzT2ZvSUI5NnZoaDk1THVkVUdJ?=
 =?utf-8?B?VkpObmdPaGxHS1J5bWZ1K3p0UHU4NWdWZS80TFFoL1pXRThRM1E5WXVjQXVD?=
 =?utf-8?B?UDBkaHh3TGhOaXR0Z3J0WndKckZUOWhsUGpsVkl1YXJ2WDlqUEpma2JqSEhC?=
 =?utf-8?B?ZGl4QTh5dmRoanFySktLbkpWUG9QZWJ4L2h0aEtxVkt3VWwwejJ5ODlnMDBz?=
 =?utf-8?B?aml2SFZjSTl6S0I0K0RFcm40ZElBTlh1OG1ieVR4Y2FxYW1zNVQ2T1N1UlJQ?=
 =?utf-8?B?QWxWeTUxbHAvNXdDOXVXZm1TYVloMmxPL3J0T2pJSVNEME9LbFQzUUl5K0FO?=
 =?utf-8?B?M2Q1My9mMlh0eGsyQjh2MUZvTmVhQk1hZXJYRnZNdFpwZFVKbytXVkMvL1pT?=
 =?utf-8?B?WHN5NkJDZEJtQkNzVGJ2VmtENXQwb3pLcnBRM01Gc1d0a21vc3hoTkMwN1JH?=
 =?utf-8?B?amJPcHljcDlocHozSkM0NGJpVVU2bWFEdVhaTDduL0tOaHJKdERHbWpwZVBP?=
 =?utf-8?B?ckFDVkVZa1M3Vml6TS9Eb3pzUDF5NmQ4SG9nS3NHMm40RXNveUQxaURhcDRz?=
 =?utf-8?B?MTdrS2dEUUJTRXpyZ0JRRFJTbCt0bFNFc3ZzRXAwaTJrMlI2Q1pTdjVqTkxt?=
 =?utf-8?B?QnAvY3lGcVNVSEZrdVdKdWVtOWk0K3pKVEFKcWlSQStTc0NNdHl4M0R1Vnly?=
 =?utf-8?B?c2Z6ZUsvcmwrRTNxOHB6ckM1MnRqUVRLRDJwT1h2OXBiZFZoaDVkYVIweWFG?=
 =?utf-8?B?eVNEWGU3ME9IaVk0Lzdmd01iWHJuRWdmWUtheUxoL2V6M1l6NmNuQ01NaHBI?=
 =?utf-8?B?ZElkcFZ5UWVSYjlla2hjUnlmRzE4eStaRC9lNGFEK2pneUNZK3Y0dGpRUDJO?=
 =?utf-8?B?Wnh1dWZqOVZjQm5MNkFLN3dzZUNENUo3MDV1NGhnSUJuVFlVdHFJalpFSGFU?=
 =?utf-8?B?ajVpb1A4ZWY5czBYMy9yN1pMU2hxMy9uN0tEUU1nQnYzUkVaaVpVU0F4R3F0?=
 =?utf-8?B?OTVLVDVuNFp5cXJZK0h0ZmdYNlNXTGo2T2srR1lDV3UyRUt3dE55V0ZDL2lL?=
 =?utf-8?B?aWh0RVZPandiSGlsempORDNySEpqVDM3NGxEQndTYlEwTnVhbklvU1dkS0tQ?=
 =?utf-8?B?d1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c855324-a5e3-4cbc-8f56-08db3c54617c
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 19:22:11.5775
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rLS5ivKP46ZJhNs4XgxCyEewInBFrlAiWJBBfUc3OWxgwVrrS12YJe2Nell+FTV3OB+BtC6l1ONvDe33YbMKdnjFPix9addbDlhBb5LoixQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6984
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/13/2023 12:14 PM, Heiner Kallweit wrote:
> Add netif_subqueue_completed_wake, complementing the subqueue versions
> netif_subqueue_try_stop and netif_subqueue_maybe_stop.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

>  include/net/netdev_queues.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/include/net/netdev_queues.h b/include/net/netdev_queues.h
> index b26fdb441..d68b0a483 100644
> --- a/include/net/netdev_queues.h
> +++ b/include/net/netdev_queues.h
> @@ -160,4 +160,14 @@ netdev_txq_completed_mb(struct netdev_queue *dev_queue,
>  		netif_txq_maybe_stop(txq, get_desc, stop_thrs, start_thrs); \
>  	})
>  
> +#define netif_subqueue_completed_wake(dev, idx, pkts, bytes,		\
> +				      get_desc, start_thrs)		\
> +	({								\
> +		struct netdev_queue *txq;				\
> +									\
> +		txq = netdev_get_tx_queue(dev, idx);			\
> +		netif_txq_completed_wake(txq, pkts, bytes,		\
> +					 get_desc, start_thrs);		\
> +	})
> +
>  #endif
