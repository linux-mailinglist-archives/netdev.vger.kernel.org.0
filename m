Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCA76E7B40
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 15:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbjDSNu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 09:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbjDSNuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 09:50:25 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0622A469A
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 06:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681912225; x=1713448225;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MOiNhDbrT2TFKnvOclXQXFWpW3G8xx8h157rozzEDTM=;
  b=U8NN0wMt0F6OQbOqQRTGkdG8EZC9dPjadOAd3yITu8Mv2cd4fZ3vlBvb
   GOURYlxpsPiWOSsU4Vh9KXumVx1L4spvO9IXcRjNvGW4jhK3smMIPhctk
   /PlQQwBGgMNhir+B5Bo+wEP8hisQ8eFjZFck6GW4S931IvfbikyrOCg2e
   smG5BEik5i0Ep06Zlv+PkUwOIDLZm9knbZrHjrlJyfkoG4DkdvWiacUYb
   gbTp+xKkPA4fV5oOlWJmCZoClroUOsKvieDRiDrM8k/TgUlJFRz+OcXOA
   uqMQ1+cX9suqaLmQxl1lvQVc6O+iFp9EvTi814/6Bp9gQcbHC85OdjXKK
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="345453576"
X-IronPort-AV: E=Sophos;i="5.99,208,1677571200"; 
   d="scan'208";a="345453576"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2023 06:50:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="937680038"
X-IronPort-AV: E=Sophos;i="5.99,208,1677571200"; 
   d="scan'208";a="937680038"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 19 Apr 2023 06:50:23 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 19 Apr 2023 06:50:22 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 19 Apr 2023 06:50:22 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 19 Apr 2023 06:50:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KicaZW2Q1RjfeQ2qccOE0oTmBJ8V5OYuPkFI4mE00Qh9UalGTxTEqZK8w8jN6Zfdkk9rAua9EU0zuNQHvhNOjx1mVCzjru3jVtFba4gyPzB5AxusI9Uvame0EnDsLSb+MT37teZdYCiIdocjTCVJi7lkCyBgzHfHgf1uCK/OrrdfIb5A0VoAAXMZEth6ZKkYF0GWtJIqzIms7vvnsEsDyOr7pZB59BfVUrECqGJS+5Q64uB2nxy+QMlbx5PmWfUgGztg4ny6tk+T6lr1mYc85hXCbJQLnBTB0SEDc+BNI3SLd/NE/JFHJ8uU4zIWIHE+2eCIhddxekJrp2N1TNpS1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PIEXpNX9gm/rxZhP69E3znoGat069dy3UL7cVma4/5A=;
 b=F0FVOIB7l4MTZSr/X7xICIsCTIFxKBUKePW51pKO4rx3fzUXTJPCDVtPUyAXLa89rH84LgSIKWaz/YJoGjJVp0e+DpDcILVd54Zopa3ceYfks1FTNQqptYi0m/8+YzQOssRa7C5vXyCkZBDyvdmt5fjLT98ij/ofmFOE0rIcFxo92USnCMx05bvNEtkpbYewoitGTaPytdsJ/etjp6lSeCJUkusrGvYweVFn3PJCH42GqWrN6yWUPPaftWLJvz/Gl1nQzP8ySbvWn4izduPJ8hF3vroRtvhvu7UbDZSvVR+ci/F/7+HUNDgjg+DLx1Yy2QBOg5c23Z/sI/J1OUcZGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by DS0PR11MB7484.namprd11.prod.outlook.com (2603:10b6:8:14c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Wed, 19 Apr
 2023 13:50:21 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::4c38:d223:b2ac:813e]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::4c38:d223:b2ac:813e%5]) with mapi id 15.20.6319.020; Wed, 19 Apr 2023
 13:50:21 +0000
Message-ID: <0e4f2fe3-1d5e-2a3a-005b-042bc7ef3d9e@intel.com>
Date:   Wed, 19 Apr 2023 15:49:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net-next] page_pool: add DMA_ATTR_WEAK_ORDERING on all
 mappings
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <michael.chan@broadcom.com>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>
References: <20230417152805.331865-1-kuba@kernel.org>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230417152805.331865-1-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0353.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18d::16) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|DS0PR11MB7484:EE_
X-MS-Office365-Filtering-Correlation-Id: ee81d899-7bb6-4361-5876-08db40dd0443
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /QbhYdsUzmZFVpLLVmvlYDENiKch0qOrNqQ+i63KVs0qcmP3NoFXzenxi5LKMGApdvodji0ucY+n+fW1AYxeLF7A46F6iCoDMfUD1mWBaYr90a8WLgGq6UooIk0M7VIHT0bDrwM+mu7jyOJlAeLlHu6jhSYYp+PUonheEskuLPdapu9c4RWT/QEbIAghDKUCgDfP6athbr567dNAhfcY6ZRyU3PTyNLZrVAjq4KnFTwKO/PvesHcbbBcY0HKE4tmbydRtxnRL1Ez/Zt7hCH+YtJqRF/SLfjBn62Ohgi0EJc2HUkz6g/T2YtfKugFopuxzSy5rJOE4qsLwwwjnLr9Vu8aggv+sI5ZX2ropbAw9OvP11H8GchQP2GpeQD3IjC3vSqdY6qu6Gm56d/c1eqIEvfKRbleL1m3TKXGnJujY8DS1sYnzPxNGgXIQrXohTVNJT+dbXqW4Lz3MzGT6vIC4+n7G+ucB0oOeD7iBV480ELTIVPV2o1c7FP6AEqfa3Fw+qDqJ9YLTAZVTHmbDukaUcVt7m1BzahHTixzZkMuEhd9OVoe7mfWkhtx6/kFgqHYE2c6Tczuz68bKIE2qpYR2ySIrYIath7zIa9CfpGj/vSs6umyGdAbZqXf0OMPGqrBIXrIV+Si6VFQAGkekK82zu8wTmqeRcsHz/NGGtcQ98c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(39860400002)(396003)(366004)(376002)(451199021)(2906002)(8936002)(8676002)(41300700001)(82960400001)(38100700002)(5660300002)(36756003)(31696002)(86362001)(31686004)(478600001)(2616005)(6512007)(26005)(6506007)(6666004)(186003)(6486002)(966005)(6916009)(83380400001)(316002)(4326008)(66946007)(66556008)(66476007)(341764005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OCt1UWFpSmdWZTdtYWRKb3lnc0VNeVJCcmNQYzMvazhPNWZJV1Rnd1BKYThy?=
 =?utf-8?B?eDZTeDRRNHIrekhGUzYwQ0RqMXNrZ29pYldUbVpSb0hFRFpYQU02OFh5Y2hT?=
 =?utf-8?B?SWFsVW42UkpjN2cvaFN3YXB2Yy9IcXVGMkRMdisxbXVXZDVzZlN6cWUwMlFT?=
 =?utf-8?B?bkZYa3Z6MHpsWHd0NDkyaDlDUzAxeG5wcWVmdi9ZYjVxQ241clJ0cnZWb2po?=
 =?utf-8?B?cTFjMEpDejdUZzJRRElTa2s3d3ZlUWt4N29TOFU4K1F3dVVabkRZVVdReTNp?=
 =?utf-8?B?Q3RyRTVqc2djTzRLN1hUMHE0MlR3L2FHRTRGbndxZW5obHg4KzBqQkMxY1Zq?=
 =?utf-8?B?Q2s4bGJ5L2JORmxWempsbEdhVTdva05Zb011NTBVWGVjQVZOZmVFY2VUQi9U?=
 =?utf-8?B?SmlrSXZ4YkEvajdMTm1tTGNMVW5VeHBzUURWaHA3WGFsUWZvOGNSdzZEREVi?=
 =?utf-8?B?K1dxY056ZkNORmhNdE1lVldTT3dEa21hMmI2WFg1ZTRhRmdXcmorN0FsNGFH?=
 =?utf-8?B?ZHcyTThvdHkrZ25VTmxhdjg0NG9obmI0Zlp3SzljMFcrcWV1TDV6UE9vSnBG?=
 =?utf-8?B?NmdKb3g2VDBWOVdrRFNMdjR1eVBldnFMdUtreDBGLzBKTCtuUkhZVG4rWHJi?=
 =?utf-8?B?ZVhPYjBYVFp5VGRlSG5aL25ud3dOQ29MTERLcVMybnYwNDcrYW0veDdtWXFr?=
 =?utf-8?B?TjRCUVFwSDNxYnBZVVFtVjA0dFZTcGJOVytOSCt6NjNnbU5aMzQ1RTBPM3R0?=
 =?utf-8?B?UWtHT1BHNmw2ckFUc1dmRnZuYVBzSWZkL00rRUZnaDlrTDV1aGtaaVJNT01p?=
 =?utf-8?B?VVpUenVyTHpKdWRrcTBNcmcyeU1NeFZja3NKNFJuVUtBOWdOeEVyRUZzTng0?=
 =?utf-8?B?MnlOUU5zcncxSGU5a0RaRDE5bVlVb3ppM29kVTVEUUFhek94M3NSWW9EU09n?=
 =?utf-8?B?emlYZXZ2SmE4L0ExdkpuaFZZVE55aWh3SXZOK29nRGloOWI4bjhaNjM2SlNR?=
 =?utf-8?B?eTZCZTNPY1UxUmw5K3dnaTZ1aXl0a2JwUjZiMnRJTzBvZ0NjbmpxWUtYdFpi?=
 =?utf-8?B?eTI3bm9ueHFVWFh3bXQvSFp0NUZFeWNtVTJ4T3loTEE0a21EVkpWa0hIY1Za?=
 =?utf-8?B?aWlLdVNGL3BBMG5HRWFuUHJKRHlYTXFJeUgycURzMHdjVE9mTTRkYkNUaE11?=
 =?utf-8?B?NTBaMWJwZHdoWGtWaGFxcHZSaW1ZbHkzdzNqMVF3L1VaU0ZQZXpKVlNwbTNx?=
 =?utf-8?B?U21uVHlRcWZaV2NTN3NtN0dLcHl6Q1hpd2c0V0p2K3JHTWZxME4vTldoNmFF?=
 =?utf-8?B?dndzSjNHczdxVG1GWWlzaWwrTHVGOW1tOEhOWEZrWGw0bi9jQ0FPSEQ2Ukwx?=
 =?utf-8?B?MUttUlVZQVBDNTNRZ001UlJXL1R5S3JVQUhlWWZtOUhtZi94MmQ2T0crTkRG?=
 =?utf-8?B?RGhkamR2Um8xS1BBK29aRXF6QURVMWIxZnh5c1NyVjcvaVJwa3BML01TVGV3?=
 =?utf-8?B?K3Bya3Y4bTM4VUlCU0hzN3g0OFRVSEU2c1dab20vNlJOSTdhVXFwZzhLQ29P?=
 =?utf-8?B?eGw3Qnp2amZTclZRUWV6bXc3bUVBSHNTc3R1TUhuSERhcjVMUUdESEtROVlh?=
 =?utf-8?B?Q2YvTFB0MWRycUlTQlRERzVoUEJ6aFJlM3VMakthb003bDgzbGJuWG5weGwz?=
 =?utf-8?B?QWh5amZ5UVArYnhkbVd6ZUd6VmF3SjFtNFhxd2NUc3kzTlJONUU4K2d4aXhu?=
 =?utf-8?B?UVJ2M0xmcjJHc0kySmRRRnNpTW5nMytsTEpzRms2R0pYU3VmaUt5UVd1anlP?=
 =?utf-8?B?aEFUeGIrdWZaZENkd1lPUHBFYUt3SXFZeHpIaEVJRmlYWXJhdnRjOHZtVkh5?=
 =?utf-8?B?RTNSU0dLSDdxcEtKaVpzRjZsbHVMN1hTcEprbTl4WUF6ZnJFS1JQcjE1eWFi?=
 =?utf-8?B?M29BUU5tQThmT2JSNEhodVFJQU0xaUVEbk1nVUMreUdrTEVsTUpjZzNuRnRG?=
 =?utf-8?B?dGhDeWQ5OFFrdllFVzl5bm5LVkd4THY1Wk5BNWEzelF0VUsxZStXRFVUbDU3?=
 =?utf-8?B?Y1g3dU9nMW5wNk1PNjVZNFMxOUkrOEY0ZXJnR212aHNLakV3SVZlc05KdW9i?=
 =?utf-8?B?K1hMM1lzNVoxeC9vTXIrbXpaR1JDMmUydEFEWm1WSzhqenhLdTNQZFZMdzQ5?=
 =?utf-8?B?OGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ee81d899-7bb6-4361-5876-08db40dd0443
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 13:50:20.9147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YeSdg+xG6XimwGbzRgshr5FvQ0KaSjSlh/18uLfKWZOx8XgoYWvmCZWwldUCGKNEJcbMPgCVh9BO4SIbIhSzDuxWQD+LzUkOX2Ptzh4Kn+4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7484
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Mon, 17 Apr 2023 08:28:05 -0700

> Commit c519fe9a4f0d ("bnxt: add dma mapping attributes") added
> DMA_ATTR_WEAK_ORDERING to DMA attrs on bnxt. It has since spread
> to a few more drivers (possibly as a copy'n'paste).
> 
> DMA_ATTR_WEAK_ORDERING only seems to matter on Sparc and PowerPC/cell,
> the rarity of these platforms is likely why we never bothered adding
> the attribute in the page pool, even though it should be safe to add.
> 
> To make the page pool migration in drivers which set this flag less
> of a risk (of regressing the precious sparc database workloads or
> whatever needed this) let's add DMA_ATTR_WEAK_ORDERING on all
> page pool DMA mappings.
> 
> We could make this a driver opt-in but frankly I don't think it's
> worth complicating the API. I can't think of a reason why device
> accesses to packet memory would have to be ordered.

And you do that 2 days before I send this: [0] :D
Just jokin' :p

Unconditional weak ordering seems reasonable to me as well. BTW, I've
seen one driver converted to PP already, which manages DMA mappings on
its own *solely* because it needs to map stuff with weak ordering =\
It could be switched to PP builtin map handling thanks to this change
(-100 locs).

Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>

> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: hawk@kernel.org
> CC: ilias.apalodimas@linaro.org
> ---
>  net/core/page_pool.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 2f6bf422ed30..97f20f7ff4fc 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -316,7 +316,8 @@ static bool page_pool_dma_map(struct page_pool *pool, struct page *page)
>  	 */
>  	dma = dma_map_page_attrs(pool->p.dev, page, 0,
>  				 (PAGE_SIZE << pool->p.order),
> -				 pool->p.dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
> +				 pool->p.dma_dir, DMA_ATTR_SKIP_CPU_SYNC |
> +						  DMA_ATTR_WEAK_ORDERING);
>  	if (dma_mapping_error(pool->p.dev, dma))
>  		return false;
>  
> @@ -484,7 +485,7 @@ void page_pool_release_page(struct page_pool *pool, struct page *page)
>  	/* When page is unmapped, it cannot be returned to our pool */
>  	dma_unmap_page_attrs(pool->p.dev, dma,
>  			     PAGE_SIZE << pool->p.order, pool->p.dma_dir,
> -			     DMA_ATTR_SKIP_CPU_SYNC);
> +			     DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING);
>  	page_pool_set_dma_addr(page, 0);
>  skip_dma_unmap:
>  	page_pool_clear_pp_info(page);

[0]
https://github.com/alobakin/linux/commit/9d3d9ab4e7765d5a4c466c65ad6cf204a3ad1a71

Thanks,
Olek
