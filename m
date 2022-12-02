Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB70640D60
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 19:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234398AbiLBSgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 13:36:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233863AbiLBSgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 13:36:47 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4408EDD6C
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 10:36:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670006206; x=1701542206;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Omphoqm++Gi9GLDZYaOYdjyXFrQ9oPYff0KAishh8mg=;
  b=kuDB76QjzPSc4wEB0Q2e9JB51SpZRc6i6SyweMXUZ4fcGhbf1cpuSQbf
   uX6RC/HNt4bvI9X7NF/cWkze2fhPK8ycbXmb3qLCDkjtG1HTiFXW5EUqo
   e109AXRgKXOTQyiu2jYf2IbHdBvYPJMBLjolS7e+Vwu0aJOli7W7/CvxB
   pvgQFnj3Q8Mylktr5zdj1x+FKjMLtKnKhgVkL7vMjgia6Y1XfD/ouZRX0
   zU4sdRycW76d02uJ5uPhQpoy2WqKuu2+TbgESbquHYCPfcnPVIlr+jCDl
   pSur64MeAOIAIyJQ49Cppq9p+2S05oTwkoqHOwlZWflpSErrcy/UI8/9Z
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10549"; a="314724414"
X-IronPort-AV: E=Sophos;i="5.96,213,1665471600"; 
   d="scan'208";a="314724414"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2022 10:36:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10549"; a="713717231"
X-IronPort-AV: E=Sophos;i="5.96,213,1665471600"; 
   d="scan'208";a="713717231"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga004.fm.intel.com with ESMTP; 02 Dec 2022 10:36:46 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 10:36:45 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 10:36:45 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 2 Dec 2022 10:36:45 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.47) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 2 Dec 2022 10:36:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jA1mSXbhqiQJG99Fdgynr9hfntEHSVzlZBXmhmlzmOoXa75/1IEH7a21N5uXF76pOWBn3/BuA7a5wgVy5dEbB2a6j527Ar5RQmqI+zt1raDeQqyXazGTRKc9kxykpaARxiAZbY4dpitz7DoD1Kb8uqvJvGtjdZVz5nqu+69gdvd8Yb5XW3psenHaaB8M9dhVNPodXKB5Jz7wmpLEsNLne3AiGwAbRIgkfa06v7GdS4DxxOtokF72DArD6PYZ0TXDlc3EhmpiFHlcpLmOxQ2J5bQGdKW977MlSxBr/YbtO7iDrabcStY5sndt0w7slKhg6RkwWate+ySAvhIuwID2Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VCilIRoYvIi4RVPM999ltJxTBbfB4NM59zTvi//MNWA=;
 b=ngkh6MOeK9ztGN5Niryfx/W8e8jCKzSkMcvCmiDoLzxRny4XOFd+gQlzyYXT/r0qCHOmzWRNJ1KL/VTgSRpkTpaWygmQXFexDEA6ldNofFjN79w4+6JpEz74nBZftICr8GCykgKJQikk1IDVDzya1uXGG+fP/BWo6J7J8dS0dM5Los8a3NpY6Q0Rw4jQ/LgPxd8llMI9Sroafb4TNVWe97Wi9OyeRnvQCXsd4aZcR4LvlHp/oEQ1Je3QOHtfUzan5AiZ7QEIvmPi0t/xv25EfOJrGVZwOjjbo8QdtMBt6ZwoQYTeNxM/WqcWukItdLNTLFW6v4Y7mEk3LCXbcJbiZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by PH8PR11MB6880.namprd11.prod.outlook.com (2603:10b6:510:228::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Fri, 2 Dec
 2022 18:36:43 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%6]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 18:36:43 +0000
Message-ID: <ba949af0-7de6-ab12-6501-46a5af06001f@intel.com>
Date:   Fri, 2 Dec 2022 10:36:40 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH net-next 08/14] ice: protect init and calibrating fields
 with spinlock
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <netdev@vger.kernel.org>,
        <richardcochran@gmail.com>, Gurucharan G <gurucharanx.g@intel.com>
References: <20221130194330.3257836-1-anthony.l.nguyen@intel.com>
 <20221130194330.3257836-9-anthony.l.nguyen@intel.com>
 <Y4hxen0fOSVnXWbf@unreal>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <Y4hxen0fOSVnXWbf@unreal>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0068.namprd17.prod.outlook.com
 (2603:10b6:a03:167::45) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|PH8PR11MB6880:EE_
X-MS-Office365-Filtering-Correlation-Id: 7177d551-050f-4261-0698-08dad49428f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0bzSmNH463MZ8kc0YpCvj2fNnMpZYhtcNN2MeiaJmI2BUKkuTTeU/RdCR1D7NRDYJX2AAy+1XZtzSgwkHwCIVPvX0PSWHZYj/1FTY2kfKUk1WSyltGdwPhj5lQ7QZT/A+ND4+SezkYLPqo8MwlX5hov68hkitHm6cUufBWeZOPM0ROdIFD+0HTaU3/ZV1toOOilVCYMNdYsPQVXIfp7cs32IOwUQkZfz6fXrUbGpLX0Cts2a1+m/0P3+6cbpIAF1I7QigvqHD0M82DBoXg99Jhm+Hq9USMECZ4xHP1R/yJsjERgwi/RzF7kISRk3holGeuuJkKCZRf/zISge4vfAL6Gl6YiQ0PPkNOBf2XvnHc3ayi4tSzaTqNovDyoVJRfFvDwgIn+zQmvB8bTwy9Vp6TGWWEDJb44MDYU4GfF1LYXzV1aWgLOJ1dh2sn5kb6cPnS10gTshoZmGDnS+ZnK27IZTvCVAzroldMCnNjBxycZz23OQFXGZUxqAlbrnz8Ex18k81ul0rs4Dje9TholGuejw/WReP26VUXFfBbvNvCNdF1s2ZBpwiEQkfa/ZpGySbIQ630e0ngvbTBm3UqELn9mH1yvCtyDMDRQNw+9PIWcdLq0ErwAzrDdfMtY5b8yNGE7AxgaujWNHHrZp5YiBYAXv4+j3PwJIqReTxhtMMH1n0WLIDj6mPJRU2o5PR1+UkdtuyR3MWbt9FGenJOyVzyPX4NDntey3ALpFBckzID4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(39860400002)(136003)(396003)(346002)(451199015)(107886003)(53546011)(6506007)(31686004)(478600001)(26005)(6512007)(8676002)(66946007)(86362001)(83380400001)(4326008)(6486002)(6636002)(66556008)(316002)(66476007)(110136005)(8936002)(186003)(2616005)(2906002)(36756003)(41300700001)(31696002)(82960400001)(5660300002)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cEtwcFAzcjV1YlJRQVB1dTZSNVB1Y1hwam5XQVMwVXNxNytMZHRQNzBVQUdF?=
 =?utf-8?B?cURRdk5wZEZ0WHcwVlJJMnBNcmhkNFUvUHZ4ejFqcDhTd1NzVnR0M3M1c2pO?=
 =?utf-8?B?d0xOWUhXbzY2NnZYeWhJMEl3a3hGbXBBaW1zTSsyVlg2QU5Rc1BUSXVKT09C?=
 =?utf-8?B?RmZyVnNpRFNiS1ZyZHVvd2NadW1aSmhJZkdLQkh2T3RldFZIcnpScnlMUm9p?=
 =?utf-8?B?dGpsYTdCUEtkOE95S2pad2FBcjc5Qnp5Q1dQTjY1WmtJcWgxRTA0VGpUcGk0?=
 =?utf-8?B?Uk9nVE9WbVJBVlA5cEVDdGwza05ydXBodlJsWndpdUdOVU44czVObTBLNTk5?=
 =?utf-8?B?V3RETm9aQmJwTWgrTVBOeHh1N1RpbGpGc2FDN1RXWXpva3ZFWFl0cjJSVHRn?=
 =?utf-8?B?NVJKeXFid21rRDgwbUl3NXFoemRpemtNQTRSUlh6VFQxa1hrTml6cVA4TmlC?=
 =?utf-8?B?cUhIcXFpbnpoeHFkUG16NkJBSXRVdWFVdmRpY3U4eWYzczhkQVJMNTI5SFJK?=
 =?utf-8?B?bXdkQndVUzFpaWY0Y0VBK1pGc2E1Ry91cGxieHVzRnB0SVhpOElPV2NtUld4?=
 =?utf-8?B?VWszM25nb1VKNmFWLzV3K2I2Q3MwWkRsekJiV2FLem9pdUZlN1ZLL293Tkcy?=
 =?utf-8?B?c3Z1NkdaN3IwTXVNOHI5MTh3YW5STmtZZ1pRWWxKWklNVzNVK0JRV3p1M3Y5?=
 =?utf-8?B?Q0k2T1ByMXoweU5DSkFyemFYa3J2ZHNtNkl3TlBtMG92MTg0YWl3aURoNnZK?=
 =?utf-8?B?d0Ztdy82bVd4WTl6c0pocHNVSERacE5tN0tMSEFXb2RoQ1NMYmNFL0dTM2Vz?=
 =?utf-8?B?SmV3TnQ1V0h5UlNnQlVITDAwVUc5Y2N0QXIyS201Vmw0WThUdlFQS0JCampK?=
 =?utf-8?B?VHk4WGViaFYvZ3FMMEtDMDI4NVZjVllzVFVYNE01ajcxeG9WRnVrYXlWM1J4?=
 =?utf-8?B?VGVpdFZYei8wLzR1aFVrWE1LWnlXcjhhaWJkUTc3c2VnbEk0S0krcmUwTy9T?=
 =?utf-8?B?RjVMSHV3dERrb3hjSjdLU3ZhMnJBc1YyR0ZqM3VQWGdRTk9GTjNkdXloaTdJ?=
 =?utf-8?B?TVJONUR6bFVLOE4zTng3M1JRNUJGbzMyRnMya1BJNkZhQk05T09CYlpFRnc4?=
 =?utf-8?B?MVhEWTkwckdKUXRqVUdwb0VhV2VRUWJSeXN6OGdnazhrNW9YY3dzcVVVa2Vt?=
 =?utf-8?B?UCtGTWZzdE8zcEN3eUpoZVJnam9Sa1FHQnoySTBFYVFYdjM0WERjZFJUWG1l?=
 =?utf-8?B?ckNKQXJyZVdCRk8yMUVWR1N3eExCSmE5V2E2ZXdMbFEzMzg5dHZsMzZtcTBD?=
 =?utf-8?B?RTZXSmQ1VitucmswN0VuM0k1d1p2a3doVm9paGlPREIrTXlXUlFiem5GQ2cx?=
 =?utf-8?B?eE1XSDUvMlphazJLZnd3N1QwMXhhcFI4MWpjUUFON29kUnB0WGJ6djRac0w2?=
 =?utf-8?B?ZXRMbUpicmlZOVdLbVB2RTlxdGtleTJ3MEhkKzNOMmI2Qm9uY3hBcTd2a2tY?=
 =?utf-8?B?bUVOUEs2TVFKSTBZbWFwdHZqcDhTK2dYOXBrWVBvY29DcE9tZ0d3eDNLOS9U?=
 =?utf-8?B?OHRiNDcydllTMEFmMHVmTitNSWN5QzkvRHNXK2pTamZZT0prcldrYXNIc2cr?=
 =?utf-8?B?M3VJQ0JsYjFJb3BwOFNWSDVUbkhkTThHMWRDWTNkT1RyOWxhQ21UbjdXcHB4?=
 =?utf-8?B?VnFjWVlOVnFUTVVkakxvRXU1SzVxRzZSZm1VV1pEZlc4dXkyUHNMN080TllH?=
 =?utf-8?B?ci9nTFVXMjAyZnN6Yi9uVlFjVXVpTDhYclhIM3NlWEtTZVBWQ3hJV0NTYjNq?=
 =?utf-8?B?RkVVeldWeXI4OEFSZU9WdTVqSnpZbFkxZHV6RFlQM2FaWmhBdFdFdFljemVX?=
 =?utf-8?B?RmxMNng2Nm96Yys5S0w2WFIwT3BXWUxnSWcvK3g1Q25yc1JsU1dYb0V0SzdI?=
 =?utf-8?B?b1htTUNVYjJBVnQwNWdMbER2L3UxTzhlUFFndG1DdVBBL3drWFkraVNUSU1F?=
 =?utf-8?B?YVNuckRxelJBZUtFdDVtS1lMdXkrbjNBZExRcjVUWTd3c3lPNVdaZDZHY0FM?=
 =?utf-8?B?ZXVhRWRuVTdtN1l3WURTTEEyN3YxZk1KTHROTVdFUlEyZmx0WVhxdlF4REtU?=
 =?utf-8?B?RjRpQ3I3amVMekVqZjMzUEp0elJhZjRidEVDbFJZRCtCRnAxMlZLSVh2ajd0?=
 =?utf-8?B?MGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7177d551-050f-4261-0698-08dad49428f9
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 18:36:43.4940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E7ba3J1iqnL4rxJLF8a5Oc7LnIkNxBbLv1QgJs2X4Q5RCu8rgwan5j5WMV7uZ2qVCsUqtyyBZ7KsCa9iY+UPzBjBM17K9aDq2H46wOA4NIQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6880
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/1/2022 1:18 AM, Leon Romanovsky wrote:
> On Wed, Nov 30, 2022 at 11:43:24AM -0800, Tony Nguyen wrote:
>> From: Jacob Keller <jacob.e.keller@intel.com>
>>
>> Ensure that the init and calibrating fields of the PTP Tx timestamp tracker
>> structure are only modified under the spin lock. This ensures that the
>> accesses are consistent and that new timestamp requests will either begin
>> completely or get ignored.
>>
>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>> Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
>> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
>> ---
>>   drivers/net/ethernet/intel/ice/ice_ptp.c | 55 ++++++++++++++++++++++--
>>   drivers/net/ethernet/intel/ice/ice_ptp.h |  2 +-
>>   2 files changed, 52 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
>> index a7d950dd1264..0e39fed7cfca 100644
>> --- a/drivers/net/ethernet/intel/ice/ice_ptp.c
>> +++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
>> @@ -599,6 +599,42 @@ static u64 ice_ptp_extend_40b_ts(struct ice_pf *pf, u64 in_tstamp)
>>   				     (in_tstamp >> 8) & mask);
>>   }
>>   
>> +/**
>> + * ice_ptp_is_tx_tracker_init - Check if the Tx tracker is initialized
>> + * @tx: the PTP Tx timestamp tracker to check
>> + *
>> + * Check that a given PTP Tx timestamp tracker is initialized. Acquires the
>> + * tx->lock spinlock.
>> + */
>> +static bool
>> +ice_ptp_is_tx_tracker_init(struct ice_ptp_tx *tx)
>> +{
>> +	bool init;
>> +
>> +	spin_lock(&tx->lock);
>> +	init = tx->init;
>> +	spin_unlock(&tx->lock);
>> +
>> +	return init;
> 
> How this type of locking can be correct?
> It doesn't protect anything and equal to do not have locking at all.
> 
> Thanks

The init field is used to by the Tx timestamp work item to have it exit 
if it is executed after the Tx tracker starts being de-initialized. I 
guess technically reading the value would be atomic.. Though using a 
spinlock also ensures the appropriate memory barriers are in place 
around reading the value, preventing re-ordering.

We clear the init field and then the Tx timestamp thread will stop 
re-arming itself. We used to have a kthread item which we would then 
call flush to ensure the last queued instance of the work item was 
removed... but ugh now that we're using a threaded interrupt I am not 
sure if we have any way to guarantee that the Tx work has completed. I 
am not sure how to address that now with a threaded interrupt. Hmm.

We can't hold a spin lock for the entire duration of the Tx timestamp 
work because it might sleep while checking for an outstanding Tx 
timestamp via the device Admin queue interface to read the PHY timestamp.

The goal is to ensure that

a) timestamp requests guarantee that they each get unique indexes or 
fail to start. This is covered by the fact that timestamp requests all 
hold the lock over the duration of checking that requests are being 
accepted, picking the index, and setting that index's in_use bit

b) timestamp completions are reported only once. The only place that 
processes timestamp completions is the threaded interrupt function, 
which can only have one instance executing at a time. This function 
doesn't hold the spin lock while iterating the in_use bitmap, but it 
does hold the lock when it reports the timestamp and before doing so it 
rechecks the in_use bit in case the timestamp got flushed. We used to 
have a separate thread that handled discarding old timestamps after 2 
seconds but we now do that from within the same threaded function. Its 
possible that a request thread might execute while this function is 
processing and *set* a new in_use bit. In this case, either the function 
will see the update when iterating the in_use bitmap, in which case it 
will check the PHY register and process the timestamp if it happened to 
be completed. Or, it will miss the timestamp in that run. At the end of 
the loop, the lock is re-acquired and we check if any timestamp requests 
are outstanding. If so, we exit such that the threaded interrupt 
function will re-execute the Tx timestamp thread shortly to check again.

c) In previous versions we had a kthread task which was used to run the 
Tx timestamp function. In that version we used kthread flush after 
clearing the init flag to ensure that the threaded function was 
completed. I think this is a gap since the commit that introduced a 
threaded interrupt instead. We need some way for the tear down to ensure 
that no more timestamp processing will occur. There is a small window 
after we clear init that we could race with tearing down and removing 
the Tx tracker memory now :(

I am not sure what the best way to fix c) is. Perhaps an additional flag 
of some sort which indicates that the timestamp thread function is 
processing so that tear down can wait until after the interrupt function 
completes. Once init is cleared, the function will stop re-executing, 
but we need a way to wait until it has stopped. That method in tear down 
can't hold the lock or else we'd potentially deadlock... Maybe an 
additional "processing" flag which is set under lock only if the init 
flag is set? and then cleared when the function exits. Then the tear 
down can check and wait for the processing to be complete? Hmm.

I realize this whole scheme is rather complicated. The biggest problem 
is that while reading timestamps we need to interact with firmware over 
the Admin queue, but we also need to safely be able to set new timestamp 
requests from the hot path with minimal disruption. If we locked over 
the entire Tx timestamp read process it would block hot path.

I think there's a gap now with the threaded interrupt needing a way to 
ensure that no new Tx timestamp interrupts will be processed since we 
can no longer use kthread flushing to handle that. I believe the other 
parts are correct.

Thanks,
Jake
