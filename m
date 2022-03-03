Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52FE34CC534
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 19:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234655AbiCCS3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 13:29:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233030AbiCCS3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 13:29:12 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BEA2DEA14;
        Thu,  3 Mar 2022 10:28:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646332106; x=1677868106;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/POH554UqH5EK9J6Qj68x77+/6tPDKf3dbqdjd6Kf0c=;
  b=FeAlH3qmjgPKsbT8XG15YwpWshj8nYhYlwsVLnOqr5x+wvZdmQTG587N
   RsCmfyPNo2OrzO4o6VXw2eZBwE8lkruDS2h3GcSPonIY6VZn9wrfd/1SI
   GT+qh3r0fOZRwgvPdnMnfc/6kV0T6k7Px/xN19atVZ9TCN0kirasXgTtx
   O5OD20GCOR7Wmtym5bsNNKHtr6Kmr2CconIIvxp9azXKxqdkqslSoE+6P
   6XjItiSTyLp1m7TU/200zsAmHWa8VkwxBNo6XhnbJynu1OIMFEKgXIiGV
   0rYqzC67GpUUbVRfjONiUDNizFKvEoEy2T8KOWrNGgSywS5yfFSOSCCkT
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10275"; a="253701577"
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="253701577"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2022 10:25:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="710030062"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 03 Mar 2022 10:25:23 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 3 Mar 2022 10:25:22 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Thu, 3 Mar 2022 10:25:22 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Thu, 3 Mar 2022 10:25:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OaCC1hjvBVp3C5/IJd0Ny0uXWa92HzEJhB+E0W9FQfQ/2/nx6W+pUVGSMxcxKtUI71dCzytbqhy2ltdZllmf+Ey/7v4SApRjviLWXy09Et9Pq0YM4wwuXhE0GIlPACLx9wmmKRj4ct0fuCBqohLvmpSsmEMjMNC06pyVbSWY6WN7OidXkFgbHMyHCoeoraQvLM+YKc2EDRl0/1+Ga+SdHU7Kmb5zv0uxPSrqEBxc8y9SHwNepSCtL01SBo7jtBnVi38p2CO0QZ4mjnqjwcMWMJ0onaz6mQNA0lbruqCrB1DO9P8BuUitwiAydRVNSHXmMut8RIH31geB0ApzYQFw3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4dgjPmDOt4iUkUne3G5/1EBwkzS93QG1TXy84Ptwdjo=;
 b=PRuoZvLq20396hXhSMEWxBSDLGBwEyBV5A+fHkRHrQDYwPYGuN/0LbMVpnalQSyTWuabiFHcxiU/Zk1z5qXrQ7S2kGZ4oeL1q6O/bbWMXmP9cBNPX3RtLTAkdwBGq2nckchc95C4HzLfjG21z8gECcA5Z5lxIVbivk5WWMOr/Pqk6B4WRKoYL5f7MCTq/uifpmwyMYE+Ijw8PbnaNRTOX5sqg+FqRiOoTQcppnqcURzmIUJySDCkz+Mhc5o3my5CV35nZdC0v+Xy8YKYpphkR+p/g9svChXn40vacVyvJPaZEB7Rl8P0Xiju0fmi1nggLN6JbAL5SLofxQaINKSDVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by MW3PR11MB4651.namprd11.prod.outlook.com (2603:10b6:303:2c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Thu, 3 Mar
 2022 18:25:18 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::d484:c3ff:3689:fe81]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::d484:c3ff:3689:fe81%6]) with mapi id 15.20.5017.027; Thu, 3 Mar 2022
 18:25:17 +0000
Message-ID: <9d9250be-0bdc-07c8-ee53-53041cd11b33@intel.com>
Date:   Thu, 3 Mar 2022 10:25:13 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH net 2/2] ice: avoid XDP checks in ice_clean_tx_irq()
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        <netdev@vger.kernel.org>, <magnus.karlsson@intel.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <bpf@vger.kernel.org>,
        <andrii@kernel.org>, <kpsingh@kernel.org>, <kafai@fb.com>,
        <yhs@fb.com>, <songliubraving@fb.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Kiran Bhandare <kiranx.bhandare@intel.com>
References: <20220302175928.4129098-1-anthony.l.nguyen@intel.com>
 <20220302175928.4129098-3-anthony.l.nguyen@intel.com>
 <20220303081901.3e811507@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220303082848.64804e7a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20220303082848.64804e7a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO1PR15CA0076.namprd15.prod.outlook.com
 (2603:10b6:101:20::20) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6da5da4f-4e37-41dd-60ef-08d9fd432afb
X-MS-TrafficTypeDiagnostic: MW3PR11MB4651:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <MW3PR11MB4651DFCBED8F62FBCAEC5766C6049@MW3PR11MB4651.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aUAa0v4e2rv9gK5TUIDaE3B7lLkQyNxqqWkDSEFG/5FO8sL1ONYKSNsBzN47OLb+4oj9vVkHPRxAgrrVCa8/gcvEXFCNhQSGqVe/otTCEt5rfiqf94ciV9LXwp8X3SgGh75+0z8vZjinirjIWhP71p1zfjNF9YNyw7Ij9lTmhLuPK7m49cjHSqXvHQBkk/SePCiJ6RGTlgczT144O3VFBqHya51qyozlxLwjlUAPKqvnBNeuzixDtUFZnSuyla8f4Aw7M2uQDHKHuGnXIlL1vqvpqriW+sd1eI2TGgAGuHTdYdANdsQU6EA7PhAjNdMo4ueMJx1vxj9MeUKTWJKTuHQ+gOJxTB77rUQXfUIrqM+uppzloEshGQqizQfxMYel2Wf+AgxasWwa1X8DdFVBn6oCZ/dMmQ+bF7vfdef9+URyUJqeU3dT1F/I0YH0YE4XOqPMH/UpLGYN+8Y2ITQynwRjQdwrRW91bRdD71m3j+NWLPzIKSbnesAk+CNh+2EQmKPC6uCXbEr7JdIjhnf3pQpFOVezCaHGUZm2uJSIgq7atJI6kuNSMBh4ZHF6/91V529kzJukDbzsI3qqx+et8F9a+O+nsmncsRm6qc3yzHSu8wGYA5DL+ynqTlTdZXNFMLUiK3BYMZEWjCzt1APPPFJ1zpPzSNnx3G/lc6TuYVrLNkqo3tA6NC+RVrQEWlTiAp4eLvXNv+KmwqJOT0xOW+RA0/Dsb7QmzIFHLtt3HDXMnOS4F3rlxGvBeysiiL8X
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(8676002)(36756003)(4326008)(66476007)(5660300002)(66556008)(8936002)(6486002)(53546011)(83380400001)(7416002)(508600001)(38100700002)(86362001)(31686004)(2906002)(316002)(31696002)(82960400001)(107886003)(54906003)(6916009)(6506007)(186003)(2616005)(26005)(6666004)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eFM4RVBkdkE5QlVmUUl2Y2tuS1o2anlQclowaDdza0ZoVFFPRmRrWUM0T0Ro?=
 =?utf-8?B?V2J0d3FrK09Za0M4R1VkUnZoaklmdi9PN1RiZVJ0aFBWanl0Q0pxQVZ2aS9W?=
 =?utf-8?B?Uys1R0pOcWsvOHZ2T1NSYjV3bHVUZkNjbXVSKzdBSXAwMFRNb1V0Y21KT1Zh?=
 =?utf-8?B?RHRnWld5Q3dHQWpmeEVsUlRqd0crelM2QjJsU3M3SWxsRSthRFhsQ0F4ZEc0?=
 =?utf-8?B?VW9OVzcxOWgvTlh5QTV6OC83Wm95MWp0ZmtVKzNMRFBCdFlTNXMyT3lHWXZI?=
 =?utf-8?B?VFNDYTkxVk83L3h0YkpQT09EeGU2R2d0NjFndnNGajBvc01jZ3k4VFIyTTZw?=
 =?utf-8?B?NnZoc3RoZXV0YW92b0hoUCthNXV1c0VjUE9mVWpIcVIxZEpkVlFDTkhsYmJW?=
 =?utf-8?B?RWNnNEYyS3BDcmU1cjVSVnBCaW1NemRZZlhHc3RxcG4vL3RzODM2eTh4MUtG?=
 =?utf-8?B?T05UbXBqUTdSUDA0aWpLdUtjNW0zdTNpbVV6VDdWSlZvaitBaFJhN2xRTHB0?=
 =?utf-8?B?Y0Fyb29MbEFNVFR1emFGVHBya0dwUTVGc1hKNXVLQ2Y3aU14U1VZNFZZMHlD?=
 =?utf-8?B?T3l5eDFmYU5WbmFaSEtETlBGQjBBc0t1M3ZZcVJSTVlVY21oQ0Zwa0FVa0lN?=
 =?utf-8?B?UmtWL3Bsc3VZZ2MwZm5PY0UwSXpmUkJobjNqdGQ3QXFGQkpReFUvN2NXODNW?=
 =?utf-8?B?MktPakZVcUtnZ2xhM3gwajEwNlFjSlFPL3lrYlpzckVCbStxZGFQc3pSUk9S?=
 =?utf-8?B?b2hJRGRlWmZnYW9wcTJGeW9vcC8reUdkbllMbmpodXV5RUJpUXVzb2tYc2VB?=
 =?utf-8?B?SXJuTnFBTFo3dFhoOTl5cUtDV0taS2ZvbkZFV1QwRTZXTmlaYXJwUU5acmFP?=
 =?utf-8?B?c1cyY2pUaGtjdHVxbVI5OTJUNnRmRUFqZnBFWitnS2QvQlhJWDQyZlY0YjBZ?=
 =?utf-8?B?aUp2Vk9jZE4rM0pINlA0QzJkMFhHU3hTK1lpZllyQ1NPZ0tHem1yY1lNc2ps?=
 =?utf-8?B?ZjRqTzNEUHJMdnk4Z2h6THNIMnVxcjJMUVovV0Q2RmlibGVlV1FTSkdJUWk1?=
 =?utf-8?B?VUdDRWIrZDFDT2NuMmU2SXBFWlhqay9uY0J6ZHVkQWgxelg1K2ZxN3RiMG9J?=
 =?utf-8?B?K3I1dEJZVnZJYllrRmthQXBEdDFXQzlROVFjV1lMOWM0TkZBNUo3RHF1L1My?=
 =?utf-8?B?THdrbEdDVVlYM1dSVGZ5WGlwcks2cFgxNm5HNk52MVJSZjVXMlpQdWJUTm5S?=
 =?utf-8?B?V1J1T3gyR0ZDMnpubS9EZDVDWnFjWDdnSzBWVVJicEQ3T0xEYldobFdDWTUr?=
 =?utf-8?B?alhuM0Z0NVVNNkNpVk5BakZrU3dmUmxtVllHSHhjT3UrYkNTVmlYL1E0Ukh4?=
 =?utf-8?B?ZUNoZi9pT2ErbWxZdGRqVVJXOVRycU5jY0J0Z0NwM3NDYTF2OC91bFpqSEFM?=
 =?utf-8?B?V0d0OXBnWVYyVjRMT3pkRHA3cEt3WEVpdHAxVWdiR3NWR1hzNm9QL0U0Nk1L?=
 =?utf-8?B?RUNjSVEwZFRUWGlqNndCSnJta3VjRDJMVlBxTmlBV0FFMFZsUVBPb2tIYjN5?=
 =?utf-8?B?OU9BZXgveis2SHg5ZVZRRS94QkZjY2Nwemlrd3FQbk5oZTltUXBsdnZlRzlj?=
 =?utf-8?B?UWl6dkRjVlJCTVQrdERjUWxWbUw3U1lLczJIemtTMGZleElIUnU2eTFDY1R3?=
 =?utf-8?B?OVk2eVpwcSttWTlkeWxadG1MbFp2d2NQL3laRy9RSDlIWGREeE9WWHRBcWJ1?=
 =?utf-8?B?Tlk0c01IOUxrb2NtYkhNdC8xSDNJYmVPSGYyK3h0TC9KRk95QzVFNEh4VWxj?=
 =?utf-8?B?SXZDZTUwcmlmK3RHU1kwbThSQ1oxRHVJdXRwMEhvZHRvM1FyQmF1cUhZUUtN?=
 =?utf-8?B?S2hKTXdaTG5WajRhSnozRFpPZjUxei9RNzQramh4SFgwRnRQeWFvZkc5WDZp?=
 =?utf-8?B?a1VpWVB1VGZJZkxtS2NQdkZ5WEw5czBHZXJQSC85aWx1Q3hmSGcyTjNGWXJE?=
 =?utf-8?B?WE5zM2NRS0VBdDhMK3hLc3Y2WG9Cd2tLbGg3aTZqL04vbnhpZXcwYlNaUEgw?=
 =?utf-8?B?YjFpZDB2L2IzOFZuKzZQK3VHSTZoK3ZRYkEwSDliQXBGeFQ1ZXFFTGM0RGtU?=
 =?utf-8?B?SUE0TkV2TUVzVDNlcTcwbWdweVdwZk1iZlBVeHlsWldFM01keE5KZHhaV0tN?=
 =?utf-8?B?OExObGNtT2dKRVN4Wmg1SjJ4ZTNSb3owL2o1K0dUczJFU25HQVE5cFB1Z2dw?=
 =?utf-8?Q?X23OCjG+93WWG30OeCYq83mdujbXS4+IcnZYonPe+s=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6da5da4f-4e37-41dd-60ef-08d9fd432afb
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 18:25:17.6951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fTy2B+5sfwtQjEKxQ57O8SGYrTM5WjhmtNXMqHsJMxinVMAVcmeLp+4sClwnkrrbafARZFumMUYmvD8OpZ/7xOKsXv9ud6Xt2izBlBslUVk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4651
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/3/2022 8:28 AM, Jakub Kicinski wrote:
> On Thu, 3 Mar 2022 08:19:01 -0800 Jakub Kicinski wrote:
>> On Wed,  2 Mar 2022 09:59:28 -0800 Tony Nguyen wrote:
>>> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
>>>
>>> Commit 9610bd988df9 ("ice: optimize XDP_TX workloads") introduced Tx IRQ
>>> cleaning routine dedicated for XDP rings. Currently it is impossible to
>>> call ice_clean_tx_irq() against XDP ring, so it is safe to drop
>>> ice_ring_is_xdp() calls in there.
>>>
>>> Fixes: 1c96c16858ba ("ice: update to newer kernel API")
>>> Fixes: cc14db11c8a4 ("ice: use prefetch methods")
>>> Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
>>> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
>>> Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>  (A Contingent Worker at Intel)
>>> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
>> Is this really a fix?
> I'll apply patch 1 from the list, please reroute this one to net-next.

Thanks Jakub, will do.

-Tony

