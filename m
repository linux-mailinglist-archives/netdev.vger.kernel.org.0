Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57120610D70
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 11:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbiJ1Jh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 05:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiJ1JhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 05:37:00 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3610F72ED3
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 02:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666949773; x=1698485773;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PRh4sj4tDp0rjxuyeZMnnkV26GHB4NDUYA0jUiFhEJ4=;
  b=KRRSTNoQE8xLNL3tkj7YUqip3dzARZSFJVOQ9Ji+zI8XDAnZPG44Whb2
   lapx9rBx+H7YbhscqMwfCI7lCppG7LxebbxxEN9WnHt8QbP9CdfQij31s
   DSGvZUyj+hzv221T6Pd9LlI+xAtwnyiZeCnyylYcaTJjKAEZggkNw698m
   O2NAAnfFRY6TZ10u9HV/LK7n6sHH9NCmGZHnpoZ0sT16M2xh427EktmVU
   6UbzDzgKfBfD35Zf9ctXbo11GdfHoI6AKp2sB2KRNTShjICl5RjDpqvjL
   O4Sev9GdMDOXnWsUykTIQDmzm2ybDwukKLLB3wGBNgM7x8/P31iNdeCuk
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="370519854"
X-IronPort-AV: E=Sophos;i="5.95,220,1661842800"; 
   d="scan'208";a="370519854"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2022 02:36:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="807768087"
X-IronPort-AV: E=Sophos;i="5.95,220,1661842800"; 
   d="scan'208";a="807768087"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 28 Oct 2022 02:36:12 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 28 Oct 2022 02:36:12 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 28 Oct 2022 02:36:12 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 28 Oct 2022 02:36:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rv+XuTS2EeToHuxonY8+Msw6VVyHAFSE6Lwqq2DsZa6/y2IMHHiyEs0BLvNY8mHaMgnpQDH5XMjtof6uJJf606Q1l3uiJzRAwmLd0WbXbqfsztztiiIbXFaBfcwm83NZ34IQLazaqNRQd++X9buseip8V/L30ozcVHJfHR57vaZ1PwOC8j06davqLlFLr8ArhDUJgMTxxVbnx7/5KltQsa7Kj3CAsbjwUXbTfLUZ2qAkoreubObftW/MyTB8yit8YxCOP/HLAWkrla1epLdSIFDEiZdWAvCoGItvZcSToNsrcdqVJrpDu2Ctq4J884R+AVE1qNQl+iDchbvEYDxMOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZFNMZ3NWAxEvU1S3PP8gAV0FHMjYdNrlHJf8iLUC3As=;
 b=Bv78Za0kcAsoKHa+uJBG+xHCf0wtrDWLFHcBNY7mqykOGUlo6kQPHm82Ly+Pzf8+RbZXvkTy7TU0HiUcu9aW4cd452Ak6bAFNqFOSEjELYIcWFM/vLRpzgDYjJtNylT02j7T6t0hZYjiXE8umaXJMKLBHjwrIm/bW3AEHRxl4oZEQA2vyrCMZZgqVcCYzas9WZTcEfjxe7glFsdOkGbeCxDWl1yZp73pDb7OVXKg6Emf+/b2v+DzodZTyIEq+lh9l5766GHEWtUDgAed59OXGo7t5cYFSlC5zpEKw3S1WL1QBD7Dys0yaJ5gcu4iU2pD7DAMQ/SLuJwoNTfKl2rmYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5603.namprd11.prod.outlook.com (2603:10b6:5:35c::12)
 by CO6PR11MB5570.namprd11.prod.outlook.com (2603:10b6:303:138::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Fri, 28 Oct
 2022 09:36:05 +0000
Received: from CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::712e:208e:f167:1634]) by CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::712e:208e:f167:1634%9]) with mapi id 15.20.5746.028; Fri, 28 Oct 2022
 09:36:05 +0000
Message-ID: <a4ce35f6-c230-ea0f-0933-b55b2e25d42c@intel.com>
Date:   Fri, 28 Oct 2022 11:35:58 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net-next v7 4/9] devlink: Allow for devlink-rate nodes
 parent reassignment
Content-Language: en-US
To:     Przemek Kitszel <przemyslaw.kitszel@intel.com>,
        <netdev@vger.kernel.org>
CC:     <alexandr.lobakin@intel.com>, <jacob.e.keller@intel.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <kuba@kernel.org>, <ecree.xilinx@gmail.com>, <jiri@resnulli.us>
References: <20221027130049.2418531-5-michal.wilczynski@intel.com>
 <20221027223414.11627-1-przemyslaw.kitszel@intel.com>
From:   "Wilczynski, Michal" <michal.wilczynski@intel.com>
In-Reply-To: <20221027223414.11627-1-przemyslaw.kitszel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8PR05CA0001.eurprd05.prod.outlook.com
 (2603:10a6:20b:311::6) To CO6PR11MB5603.namprd11.prod.outlook.com
 (2603:10b6:5:35c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5603:EE_|CO6PR11MB5570:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c52fa5b-d1f6-436b-6168-08dab8c7d5dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G4u9C0zadXdVx9UFdijE3eBBQyOyeukINmnEZj+vYk+10L4N5GFvYZK7HaazPH/dblvMUJfBy57gCMoZwQx8jgLj1REkvKs9gR/RiIbKRyTBfBuL+pbijvJFvZSA0ShYjIDdWkQbcZVOkGTdhyce2BWLCkzUdXO2eZdN09KtA58ax0oOin88U86u//RXPZruUcsQPzOuL3RWhcv9YDZ+AUO8cFLUqBC9RMCFiOx1rsW8Qbu4pNWYJMQNCq1S41N85LM3VwjwlovL+CAKFD+fuSQM1PKkZmo09FEiwIxgbZJqSBE+o0dSY32aq5VoKai674T+PwtXBe2aJODAQBay6aYreXndnzT/6fpy/eArqUxdZO6+YtGTWi6dRDs83V9ln7o1bF08m4/beU+pUHQciPjUps3OJT7i1pAaGIAkrqQFdZCEqzTDG5Jc//+piTmNDY0h94fvUP5PGlGMPGjNptmflsHcpUxT+5SHS5e5dwtXasrp1enkiHIEfI7fJMxmnS3r9XNqeoK7yKtR+DO+NSaYLydRKDyOlZvPZCXjzu9HAEvZjY419ylEKNJcprbgqaGMI8oRgsOTmPgtS16XgLyqv4LuXpCRd7GHtXg8gs3dKfYoNTVDOznD4IHUfjexoiudkrbP/Q8o9GoS4BKbQpn7B54mWHTnRifzHJ2CCiRn+kC6osyED4aqWI2CWNz63wwK4HIAlPsU7Khut/tbUJlM6M3oqRALuZP+kx6gudOAbHkPj/Lz5H5w1IdNc9sgDTcD9WZR+80PtAgicR//Uyd7kcxYm9zSqCRdqQ00ais=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(396003)(39860400002)(346002)(366004)(451199015)(53546011)(6486002)(6506007)(478600001)(316002)(4326008)(8676002)(66476007)(36756003)(41300700001)(66946007)(66556008)(6666004)(2616005)(86362001)(38100700002)(82960400001)(31696002)(26005)(6512007)(83380400001)(186003)(2906002)(8936002)(31686004)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M0wzRjBmUkRDTi9qRWdtMUNYcVYrTDJHYkgyMGNFeFYycFphSlJVaFFrZkJk?=
 =?utf-8?B?dVBuQTduUThqNWJlZHlmeVd1eHREMUJDWitiSS80eVlLbitFV3p1TlNlNk4w?=
 =?utf-8?B?Y01YYTRFOXlrQU03Z3VOY2tEbm9RU0VUVE9QaW12WUEyRXhUREdqejFHZnJi?=
 =?utf-8?B?ZDFkZ2czTHpuY1NMOVVPck9UQzdYSXh5V3JyVDZaOURRaWcvaDM3ckFySEwy?=
 =?utf-8?B?TUM1MDNkeFZHOS9ubjl5a2xyZjF2VFJWZXdrc203YVVtMVhCRjI1SUxNL2sy?=
 =?utf-8?B?S3cxN2t0QTBiWDgxMHdQeGpJM0tib3dPOUpLMlkyTGQxenZ1SWgwOTVhM3VW?=
 =?utf-8?B?SjU4UnZpa3dFQlRRRExxanJYWFk0L1NKNmRxQUZmall5eXlmWGwxVDBselFr?=
 =?utf-8?B?WkU3Ris0dllWVXNzb3RMWm5YdU40WGlTTVRYc0UvMVRZbkVhR0ZSZDVyMmJ2?=
 =?utf-8?B?eFlIdXU2bE1TQzQ0TDJqQkpiZVZDbWVKRE1GdVlGWlZVcWdHdXBsNG1tMFNa?=
 =?utf-8?B?UmozYitFb24rdjFjN2JNN0ptdnFqc05VRlQxeDdlNUFsRWxBQit3ZFZjT0l3?=
 =?utf-8?B?RCtDVGNaaVN0WVdnUzAxWGV4Uy80WmtxODU4ekwrMEJkampOV212UHRKcG1D?=
 =?utf-8?B?US9xSTBpYlRHWHFYUEVJR1h1eUZMQlJ0YjNkamNQZ2F2c1Z4MnJNVlNYSjA3?=
 =?utf-8?B?bTNjRXAwT1VZaTkzK25MUGdXZXdDbkw1Ty9NWXlUNm5hSEMwRi9oV1Axd3lo?=
 =?utf-8?B?Z0hyMXZKV1BlaG9IS0EwSXNUVzFPdWczZk5FWXRhYWg2YzQzazVlcTErYUNi?=
 =?utf-8?B?KytoUk01WGJuS2JOZDlSY3R2MkVQZVZaVDRPdEl1MURkeDUvbG9vVmFPem1K?=
 =?utf-8?B?SndSUDZjRkZ0SFZSQVR3bDY4MWl4Z0RvT3Nrb2l6Mit3RU1JRk1vQVRPa2xo?=
 =?utf-8?B?alBObkxwczhnNHFpS2Vqazc3Ni9EcjZwdktqbmN3NHlaaGhVSFlaNlRiWWFy?=
 =?utf-8?B?MDIyRkl2bnVZYWNQVXg4SStSVlFQS1R2UHVrUjBzbVZTM2M3U2JyTlI5OXh2?=
 =?utf-8?B?cDJ5dFNnME00UzVaVmk2Vk5ZSmFTOC9LczNndGZtbnMvS2ZBbXowclRQeXNi?=
 =?utf-8?B?RTlPMmk4Mk9la3AxZktGUGI2ckFJZm1MZkIvN1NzUHdGeUZiOFp4M3RCcWRO?=
 =?utf-8?B?eHFFNUFYdXNMTEVkZ21sVVRhbzJwY2FkSjFkMHZWS3BJZUNUdHUvSnpzSFBQ?=
 =?utf-8?B?U2kvSlNUV0NIRExLOTExVnhDOHVHVCtzUC9abVc5N25RaWhpWEpZVHY2eXZB?=
 =?utf-8?B?QlBZbGxGREh0NFNTT0R0UGd4aURsb2JhVnlXWmo3THlKRnF2NGxyd2NMdXhT?=
 =?utf-8?B?dnVsWmRkWW0rUEpndEJCZ0YxMzh4emtKZTdvZ1Z4ZGVINXVIL3FSRjUyZy9h?=
 =?utf-8?B?TVdKYS9wcSsvWUorV0ZNQ3R2djE5N3hkZjF3dnQyVjQwTHpVN0tJdzIreE12?=
 =?utf-8?B?a2JjN3g1aHlwT0dhTW5Jd0Z2L21mSFdQNVVscW1DYkxYa0JSS0Y3VHRUbmhX?=
 =?utf-8?B?aHpaa0xTcXpHbEdsR0ZhQTJpTDduamNTcHA3bm0wOU02OVdoQTV6NHpVUkZH?=
 =?utf-8?B?TGRrSzFJUDd1SWxFMUF5Q3IyaVlkdElCcXB1MUxiMGdvS1RINDRIRjhpWm9w?=
 =?utf-8?B?eS9hcXp5Mk1TYW8xRW5scGhzV3ZQQkpWdW1rRmdKUEZLeGdOSXZUQjRZNXR5?=
 =?utf-8?B?emJoWUVwVXZRMFdib0lURzBKSDZ5ZHkyN2xXV2l2MDZkOHJwdnVZekZTR1cy?=
 =?utf-8?B?dVhuZjRON3dRc3dlOGpCcjNmWWM3aTNXa3JxbkdObXpCVkQyMlNtWkhCNGts?=
 =?utf-8?B?SXlHTWtIMnlIajFwb2FHYy92YW1YRXZ5MGppMlN5ZkcwdVF0YTN1Ym5JRHJO?=
 =?utf-8?B?cU05RHRoSEY0dlhmU0lZdkpPU0hWOGZvQm9kbFhYaDk4YVlxQzZiU0drZjR5?=
 =?utf-8?B?amFmUDVadjA0RnBKU3VVK0Iwd2ZNa3NuOTAxR1NEem1abmNxQ3dLeC9HQ1Bw?=
 =?utf-8?B?QXRHVnNTdTRlbndxbllhSC9lMVUvcmVGOEN4aUNYTk5UOUxJbjhhaEhUNmxo?=
 =?utf-8?B?cDVMRzEvS0lOQ2E1TzZtU2lxSFhRUlBvRGcrTVpTSjlPZXlwUzVrdkdQbmcv?=
 =?utf-8?B?Qmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c52fa5b-d1f6-436b-6168-08dab8c7d5dc
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2022 09:36:05.5165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4M2psuwJPy0PyzDdVj6YOXDI4OTkwso2Q4tsu4JkTb5KZW05Kar1/diOg68Sv2Ek1ndakgaVjXkpGlxBVDZV3FePtsaMVm3rbdL68NqTA2o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR11MB5570
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/28/2022 12:34 AM, Przemek Kitszel wrote:
> From:   Michal Wilczynski <michal.wilczynski@intel.com>
> Date:   Thu, 27 Oct 2022 15:00:44 +0200
>
> [...]
>
>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>> index 864fa0967b7a..1e0c1b0376bf 100644
>> --- a/net/core/devlink.c
>> +++ b/net/core/devlink.c
>> @@ -1875,10 +1875,9 @@ devlink_nl_rate_parent_node_set(struct devlink_rate *devlink_rate,
>>   	int err = -EOPNOTSUPP;
>>   
>>   	parent = devlink_rate->parent;
>> -	if (parent && len) {
>> -		NL_SET_ERR_MSG_MOD(info->extack, "Rate object already has parent.");
>> -		return -EBUSY;
>> -	} else if (parent && !len) {
>> +
>> +	/* if a parent is already set, just reassign the parent */
>> +	if (parent && !len) {
> Comment that you have added should be placed way below, here it is misleading.

In my mind it made sense, cause we're handling an additional case here that
wasn't handled before. I think I'll just remove the comment then if you
find it misleading.

>
>>   		if (devlink_rate_is_leaf(devlink_rate))
>>   			err = ops->rate_leaf_parent_set(devlink_rate, NULL,
>>   							devlink_rate->priv, NULL,
>> @@ -1892,7 +1891,7 @@ devlink_nl_rate_parent_node_set(struct devlink_rate *devlink_rate,
>>   
>>   		refcount_dec(&parent->refcnt);
>>   		devlink_rate->parent = NULL;
>> -	} else if (!parent && len) {
>> +	} else if (len) {
>>   		parent = devlink_rate_node_get_by_name(devlink, parent_name);
>>   		if (IS_ERR(parent))
>>   			return -ENODEV;
>> @@ -1919,6 +1918,10 @@ devlink_nl_rate_parent_node_set(struct devlink_rate *devlink_rate,
>>   		if (err)
>>   			return err;
>>   
> Comment above makes more sense here, likely combined with the one just below.

They would duplicate in my mind, so I'll just remove the upper one.

>
>> +		if (devlink_rate->parent)
>> +			/* we're reassigning to other parent in this case */
>> +			refcount_dec(&devlink_rate->parent->refcnt);
>> +
>>   		refcount_inc(&parent->refcnt);
>>   		devlink_rate->parent = parent;
>>   	}
>> --
> Thanks for splitting this patch out of the other, change itself is easier
> to follow now. Code (modulo comments) is correct, you could add my Reviewed-by
> after comment fix.
>
> Side note: ops (rate_{leaf|node}_parent_set) lack documentation. There is also
> not much usage of them as of now, so maybe we could extend them to actually do
> refcount_inc + refcount_dec (if applicable) + set pointers.

I'm not sure I follow you there, those are function pointers, and are 
supposed
to be implemented in the driver.

> OTOH: As of now those are more of "on-event" callbacks, not "do-something",
> what is further confirmed in name (word "set" on the end, not begining).
>
> --PK

