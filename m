Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43E5A6E1378
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 19:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjDMR21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 13:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjDMR2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 13:28:25 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6D878A7D
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 10:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681406903; x=1712942903;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=d9HWgdl3zI+8ahzQKJlt+AN85NhR+x8vzHNtg8u7Ur8=;
  b=gfGcW0FEtKSjqcSIqUxu0ZgUTxcoi6vzKWfRjO/z5y1l+x+MuITJbjHK
   tEuFlVkuMrbFokgpLX1ZIhqiTBtFB1aHvKPSaGYsS+0Ze5A55T43fu47I
   s9N6s7xzJHIRWNmA2G2IHey5uHnN0y54eihfav45qvD/Y5U7E09DaQTek
   bfVYlAS8+j7EomvomCSOpOa9AFSv57xBG3tPIU6iq4z4vij27FXmn2n5A
   Y3l0g6BcQ23gf+jo+anSPzPoctHW3uwpgFBVf4QDKnsguop28M5wzWMWU
   6bp95FJM+Nc3ScEJvo2VevPodD5yeNIASi+P6Fw0yOckwTriHF530p96q
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="430538467"
X-IronPort-AV: E=Sophos;i="5.99,194,1677571200"; 
   d="scan'208";a="430538467"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 10:28:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="719943686"
X-IronPort-AV: E=Sophos;i="5.99,194,1677571200"; 
   d="scan'208";a="719943686"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 13 Apr 2023 10:28:21 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 13 Apr 2023 10:28:21 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 13 Apr 2023 10:28:20 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 13 Apr 2023 10:28:20 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 13 Apr 2023 10:27:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NEMgoTMbNe0Wu+B4s3s0Zy/mLLc4EUehjer3xNIwIfIkXhUg2RPzXEZPw+P1BDbQczwXImpuuU2ptP2VfAtbfegdAWjxLXxW2IGs7KUoULqz/zOAaGeqWItQbd6nB0Wcx12iNeQH+IEos2mRD8PCfsfmzBQcusaf1YZZXvIUlhUtoVoRPaS6xgccdWRpThNtxdQHSHIhwRri/5+57jsKZZDq9qfmkJXWcyD65fDbmgj9c4e8FQ2ia8BDpSavlIwajuElVbRCqrGyw4pnDXfPr11i65+uAbINXb8CEt06V44XA2NEbYb7naLOEmWBNrhi6u7+thMNQbwYyfmoduQ7+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hbBZHpZP5KGiakXj52vuBlSDy7+jtKgvhviL1NZrUmo=;
 b=X7dvKPo5wvVFi73+aEyh2hE4wUoXVWNTUhsWuqoXH40OD3d5ZIz33tXOESrV74HAXDxs+j+TVO04qmkpMXM2YwJc0IEsSdAEo9xKC2bmdKnRuC5jSOEiKf9bKE0n97ZERqbhbrU/jyxUyB0P7rpb0FM7YudUv/2x9aqJHwBZxBEp43U5nno6uOIZ2xIbaMz0gxPwekrV62HfATJz5nAZ0jUuzHipIsoQbSKkaqwzpIP7Dj3i/PYU9vrogNWcKZCpbHOYI+kLRe3A3E9oA+3OfWuvT4ZgXnheCv1lqeHfnY+37AshMMQDiCq8lTAhaUqyepbbeV9eQY0gOIAeGmpkdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SA0PR11MB4717.namprd11.prod.outlook.com (2603:10b6:806:9f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Thu, 13 Apr
 2023 17:27:52 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b%2]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 17:27:52 +0000
Message-ID: <09ec7b55-5ec9-2abc-dbb8-cdb7e0b0c6a8@intel.com>
Date:   Thu, 13 Apr 2023 10:27:56 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net 1/1] ice: identify aRFS flows using L3/L4 dissector
 info
Content-Language: en-US
To:     Ahmed Zaki <ahmed.zaki@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <netdev@vger.kernel.org>,
        Arpana Arland <arpanax.arland@intel.com>
References: <20230407210820.3046220-1-anthony.l.nguyen@intel.com>
 <20230409104529.GQ14869@unreal>
 <3de9c4a4-4fba-9837-962a-e3e78299ed3b@intel.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <3de9c4a4-4fba-9837-962a-e3e78299ed3b@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0066.namprd08.prod.outlook.com
 (2603:10b6:a03:117::43) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SA0PR11MB4717:EE_
X-MS-Office365-Filtering-Correlation-Id: 692c4e4d-5608-46a9-3fa9-08db3c44686e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 50yzj5QgzeDbe3OqsBZiTmF//9ovhPBytGdlOVOrEP0sZKGHZxsKVPdhMfz5BluM5IINOxPMQU2a7YV9ZiD8E/bi4j042Wws4bmbbS3TUanSk861lYouceVHqoRtgF2a8KW4H4L9r9IRz9M7Rlp5CyDeNNwHUrq+Nkm6/aIFwB+2ZOgvaJwzlpyLeJ12i8z16XZQbg7BQZiYwWj6N5OIXNoUPANqMPPRQ4PV6xkao4wfspKpS3lcXtj0dT/mh/Cl3hqgMe3oGL+aJsH2ojdDN59uq4cZ8F3VnC6L9SKCo1rqvuzE8/ZntGhG5VRlLeW+Gvwi9g/3/e6wCQzfKC9V1xDJ173O1wAar6QuvJ9epBdJjLOt07XnlqQbfVpXvDFt/yAm58Zjg7tT34FR4nBYGVV+CM7fipCsY/3l5/1rUK2Y4lrhXNfHGZ0dnAKd9gYG/oTIPwfzbHS0jGmo5v+/jKemFyyqmfxkYsGUp21BFfHcweDNg7KOQylnCfmMOst0eZk56qWo4gVYsgsgBINgFw+JNP8ybZ6msDjYn52syebieTKm/oy0Vr3tWVdSTZpnbU4s6UWaZtyKOegGiM4eLN3MTXpWctxTFStT9AFT3ZnZLk0jBs0LTYPHDh9ruqxYtRgBwIHMzomjv6dZsJXQwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(346002)(376002)(39860400002)(366004)(451199021)(6486002)(66476007)(66556008)(66946007)(4326008)(36756003)(110136005)(2906002)(31696002)(86362001)(41300700001)(82960400001)(5660300002)(8676002)(8936002)(316002)(38100700002)(478600001)(6636002)(53546011)(6512007)(6506007)(26005)(31686004)(2616005)(186003)(107886003)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V2o3bkxjeXZsQ3MrZ1BVajA2Wkxnd2lCRVE3MDhHYnhUdkdRRm9ndEhVR3BS?=
 =?utf-8?B?c3Y3OXVEK1U1aERrT1J0emlENEdudmhvYSsvNTVHc3hEN2RZR252ZTR6a0Yw?=
 =?utf-8?B?REZwRWRvKzd0cXRKMkJmczFvZjBGckcwOENLYUplY0pyZ2sza0l0UlZISlBq?=
 =?utf-8?B?MHhiV3FNMlhhM1JkYlFaUExqREJSTzVya2h3TDRyZldwcTQ5bDVCUFZLSlMy?=
 =?utf-8?B?YzJXRzhxWTh3SjVQL3JaWUdsZk1QUFM1bjYvSTl4eGdweGdvUGNiUGZJWllh?=
 =?utf-8?B?bzVScGtLOVFBcjhwS0RtRmxDdzRnYWZtVCtTUTNwSkNrMkFJZ205bm4wWlNS?=
 =?utf-8?B?Uy9QbmN3bHIvaFRIcVE2OUNtdVJyR2dGMFY0eTNOWSttcENjME5FWDVxempF?=
 =?utf-8?B?MEJscDIvang2OXpzWjFHZUdmbGNZaU1xamVRNU1YcldiZEFMWnBIbithZ3gr?=
 =?utf-8?B?eUM4THRLVElJdXliUVRCQ3pGZk9MOVlTb2VnTDM3RzJHbW9XQ1BrQTAvZ0xv?=
 =?utf-8?B?RnFmQ0k5YnA3SFhUNHhYbUgrZk84YVVaenJWblVUNW4rbEs0bHhUQnBDUDN5?=
 =?utf-8?B?Y1VuOEx0VDJkNEQ2OUx2aFpoOXpQUXZRbmRsMGZQQnQ3L0NnRXI2Vi9pWXRH?=
 =?utf-8?B?ZUFKc1pXdzBvbFh1OVpVNVRCbjh1emVTaDRFUHQ1Y2tYVnhpZ05VSXJXdWFU?=
 =?utf-8?B?UjRDOFdLYWppdTN3eWZkS0FtZC9MeUpkempOK3QyU1BqNTVtVThsTVVZaXov?=
 =?utf-8?B?Z1dtbXZUUzB5WGIzdFFIaGE1N1ZlV3hldzJIdE93bEN1dTZNTjI5MndkWURo?=
 =?utf-8?B?VjUvU1FTTzdjWHQ3QkVzTXFHRWl1VEhuUkJhc1JldE5DZ2RrTjRHekZ6ZjJm?=
 =?utf-8?B?S2t6bk5jR09zMFYyTTZrMnk2Ulg3L1A0bWhlZkV1RlEwNEUwVHRqOEZHRm1z?=
 =?utf-8?B?S0JDRnhQSVc2Z3l1YjZRSmZPTDN5eTRUTDFWeDR4aDRXdVBJQ0pGZWc3MmhZ?=
 =?utf-8?B?V1hrT3N2b21zMjdYVThDSStzWXBDL2NQSzRGd3RWa0lFSGtjQkd3anI5TnFW?=
 =?utf-8?B?U3p5QUpDQitXUGsyeHFadW1GZ0IyZ2VTSE1WcUpnMmxNNXdzNGVLRkw2L1dG?=
 =?utf-8?B?N0wxVnlpaW9mdVRqR1BsU3ZPazM3MlEzUkdKbGFhMWZ3YllvQ1dDMjdza3la?=
 =?utf-8?B?bFdQbnZzdXVFSyt6U2dsS2cwSVhHRjNoaWF4RWtNK29Hd2xCaWZTYWNROThs?=
 =?utf-8?B?N1BzaXdEdE9GZXpxR0oxVVFQOWFwREJOT0s0cVVWcUdScWtlNEM3dW5Nb0NM?=
 =?utf-8?B?N1pPSUw3SVRQZ2pVL0xvRFZMM2FmV3Z3UkNXUVRiMmZtVjNmSi9qd0VNVVAv?=
 =?utf-8?B?ZGpLQjdubzJqNzVuQTM1dG84bWkvaU1rUkw0UzBvK3NDdFdkcFVGTjEyYjl1?=
 =?utf-8?B?UDZhYld4REt5MXZKczFtbUFHbXArczRiNy94M0JxQm5Ha1RZY2hickZ4WFEw?=
 =?utf-8?B?L29OS2cvOW95MC9yU0hCRS8rSG5CQ2lHWWlRSk40emxtanRnbG8vSWZrZ0lt?=
 =?utf-8?B?emw0RTJKMjByU3k4SEhpWWk5U2ZvV3BJV0pkSDdwNFVrU3dqdUJ5bjNadUZL?=
 =?utf-8?B?S2IwU3ZyVHE2eTV1WjRaRkZ1cVBJNXlubmNmQWlnNVhFMW55V2tPWXpFc0lV?=
 =?utf-8?B?NFRoKzNzZVcrWm9TYld4SUFKaEEvdDRZckNpaHYrdjN1VEV3Q1RxbWc3Qkx4?=
 =?utf-8?B?NXNtMmpzaVZkT1E5UGZkTEJwSHA3SklqWmZnaUp3aEhUUTdqT2E0Z0tYejBr?=
 =?utf-8?B?OElLMWJ3YWo2SFhsQmlpRS96MkxNMWZGZmtIVjRJQUhZekFyNTR4QWdRVnk3?=
 =?utf-8?B?Q2NSQVl4VEMydWFjWDdFd0JUWDJpNjBNdS9zcmg0d0RibVVoQW1RZVA2V0Yx?=
 =?utf-8?B?UnNZcy9pWHVaMnY5WDZJZHc2OVBJaWF0MnpEbVNOeE4xVkI0L2owL1F5di81?=
 =?utf-8?B?TldZMWIxRC8yVE50amRBV3ZiNmVqalZVREpOU2d6OW9GdEtWL2h6Y2JYd3lD?=
 =?utf-8?B?dWV1Tnh0L3ZSTDBWMnFJaDBhNzFYdThkaWJJcFdmSy9wSEh6ZlcrR21jdDh3?=
 =?utf-8?B?UGkzZWkvdTlSazdMTVZWT2J0SXpQQjhzU1ZzZTFudm80NEFpYTV3My9UWGNa?=
 =?utf-8?B?RkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 692c4e4d-5608-46a9-3fa9-08db3c44686e
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 17:27:51.8453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yZe4P8MOQEPVEA5bQw0ivhX+FZNusTX3N53A8GvA9flhKwy8ovSBwCHf/mGrqinzIEvT1D5Z1YnKWK2ySbtCRsudkl9Kl/1vRo22ZRh2isc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4717
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



On 4/10/2023 11:54 AM, Ahmed Zaki wrote:
> 
> On 2023-04-09 04:45, Leon Romanovsky wrote:
>> On Fri, Apr 07, 2023 at 02:08:20PM -0700, Tony Nguyen wrote:
>>> From: Ahmed Zaki <ahmed.zaki@intel.com>
>>>
>>> The flow ID passed to ice_rx_flow_steer() is computed like this:
>>>
>>>      flow_id = skb_get_hash(skb) & flow_table->mask;
>>>
>>> With smaller aRFS tables (for example, size 256) and higher number of
>>> flows, there is a good chance of flow ID collisions where two or more
>>> different flows are using the same flow ID. This results in the aRFS
>>> destination queue constantly changing for all flows sharing that ID.
>>>
>>> Use the full L3/L4 flow dissector info to identify the steered flow
>>> instead of the passed flow ID.
>>>
>>> Fixes: 28bf26724fdb ("ice: Implement aRFS")
>>> Signed-off-by: Ahmed Zaki <ahmed.zaki@intel.com>
>>> Tested-by: Arpana Arland <arpanax.arland@intel.com> (A Contingent worker at Intel)
>>> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
>>> ---
>>>   drivers/net/ethernet/intel/ice/ice_arfs.c | 44 +++++++++++++++++++++--
>>>   1 file changed, 41 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/intel/ice/ice_arfs.c b/drivers/net/ethernet/intel/ice/ice_arfs.c
>>> index fba178e07600..d7ae64d21e01 100644
>>> --- a/drivers/net/ethernet/intel/ice/ice_arfs.c
>>> +++ b/drivers/net/ethernet/intel/ice/ice_arfs.c
>>> @@ -345,6 +345,44 @@ ice_arfs_build_entry(struct ice_vsi *vsi, const struct flow_keys *fk,
>>>   	return arfs_entry;
>>>   }
>>>   
>>> +/**
>>> + * ice_arfs_cmp - compare flow to a saved ARFS entry's filter info
>>> + * @fltr_info: filter info of the saved ARFS entry
>>> + * @fk: flow dissector keys
>>> + *
>>> + * Caller must hold arfs_lock if @fltr_info belongs to arfs_fltr_list
>>> + */
>>> +static bool
>>> +ice_arfs_cmp(struct ice_fdir_fltr *fltr_info, const struct flow_keys *fk)
>>> +{
>>> +	bool is_ipv4;
>>> +
>>> +	if (!fltr_info || !fk)
>>> +		return false;
>>> +
>>> +	is_ipv4 = (fltr_info->flow_type == ICE_FLTR_PTYPE_NONF_IPV4_UDP ||
>>> +		fltr_info->flow_type == ICE_FLTR_PTYPE_NONF_IPV4_TCP);
>>> +
>>> +	if (fk->basic.n_proto == htons(ETH_P_IP) && is_ipv4)
>>> +		return (fltr_info->ip.v4.proto == fk->basic.ip_proto &&
>>> +			fltr_info->ip.v4.src_port == fk->ports.src &&
>>> +			fltr_info->ip.v4.dst_port == fk->ports.dst &&
>>> +			fltr_info->ip.v4.src_ip == fk->addrs.v4addrs.src &&
>>> +			fltr_info->ip.v4.dst_ip == fk->addrs.v4addrs.dst);
>>> +	else if (fk->basic.n_proto == htons(ETH_P_IPV6) && !is_ipv4)
>>> +		return (fltr_info->ip.v6.proto == fk->basic.ip_proto &&
>>> +			fltr_info->ip.v6.src_port == fk->ports.src &&
>>> +			fltr_info->ip.v6.dst_port == fk->ports.dst &&
>>> +			!memcmp(&fltr_info->ip.v6.src_ip,
>>> +				&fk->addrs.v6addrs.src,
>>> +				sizeof(struct in6_addr)) &&
>>> +			!memcmp(&fltr_info->ip.v6.dst_ip,
>>> +				&fk->addrs.v6addrs.dst,
>>> +				sizeof(struct in6_addr)));
>> I'm confident that you can write this function more clear with
>> comparisons in one "return ..." instruction.
>>>> Thanks
> 
> Do you mean remove the "if condition"? how?
> 
> I wrote it this way to match how I'd think:
> 
> If (IPv4 and V4 flows), test IPv4 flow keys, else if (IPv6 and V6 
> flows), test IPv6 keys, else false.
> 

You can use a || chain, something like:

return (is_ipv4 && (<check ipv4 fields)) || (!is_ipv4 && (<check ip6
fields>)

There might be other ways to simplify the conditional. You could
possibly combine the n_proto check with the is_ipv4 check above as well.


> I m not sure how can I make it more clearer.
> 
> Thanks.
> 
