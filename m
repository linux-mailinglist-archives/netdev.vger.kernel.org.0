Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3863A6476CC
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 20:49:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbiLHTtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 14:49:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiLHTtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 14:49:06 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998C4389DC
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 11:49:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670528945; x=1702064945;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TiB3nxNYr1EK8QUQdML/LxJ+n7O9fUWzw7XERzgPzGQ=;
  b=TZJpsV+kXt+kHMvPLjRxrWVexX4lGiNOj4YZovs48/I0DdNQg1G6/wsh
   lFK2yCvbQ3SHnZVrAL1lW25ySsvLLM10jAf5ryXNDhCWifO0535rEtPxT
   pzGKsjEykXeo7chZqOoUtgwTNuCugDxpua2S5BsFEQA6NXhHvg/PWVCSW
   seDQLlhk6kifkEcZHs3zYQgxTQWskPnEstqQW1IG3PoGZUhp4G1EYXmVn
   afPfn48XLDkta3CNRRPrCbTbnyEjubrUijaqhKgcYxpaTGDUqQsRVOdZn
   CkRoBdOerqzYW7AeUWV6kEP8hkcFAsqDvWoBk3o81x34hXoTy7Bvq3SIB
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="318435747"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="318435747"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 11:49:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="710616283"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="710616283"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 08 Dec 2022 11:49:04 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 8 Dec 2022 11:49:04 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 8 Dec 2022 11:49:03 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 8 Dec 2022 11:49:03 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 8 Dec 2022 11:49:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P7VvUfSZNsYtQdiwV+fQuR6heh6KSXF2UjQJVwGuk47ryfVDsCIxYsD9S5b4murv+g+Qeri/xeOYzoPKcrEF0Q3TmshwGrQex7MXpJd9zJYzaRfFYmzOKkdPj5lRJdNxPUDzWv/lgscoYgfWNuJqYSu+u/uVHMZ/OoGtOZ7xNGGY5A8dJFGPZmloF4vAZY2n3qPGh6t295cDiL/hbxkOBR7bZM/mXrqeYfyqNaQZIqRYzvYvjJZjfny16F3vI7s2bjCisL5Dr3bGwb5DkJOp60ne4m78/du66m1EQ6MNad5UXi0mBt+ayxitQ7CSCYp6xUn6JNs8Hg7Mb5ZATnQpYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LRiVXJHYIH/oZ2N5vs/o1yXK8afiZ48WYlSMcJNEJ0A=;
 b=fEOmtjcQUnLulLdA1jCqrkYtCOakouv8igt4XpVdk2F2xr9tPB3xnRNBL/CW2+HM5mQd/IkIQmkqaLAAiSY8aW9RtdDezD9vQu9PhrkASfG6JPhBCqsMkxa4Vlwrf2Pq0OKeK0Yg2OkuStS6ap033eP4pBxeq6DEH7KjHOTj0sL2+YGO/52uTQhNqA9TkIyiMhAV5H+i9K+o6qf5QOLp9O5DEBqBUnULLDxPbUsq+Uj9/dtJXneRBUfun8Y58xXQh/dXtKWCQEOEZNyth6xL7XpwES/OnA/un4u+PiFFUm6UWuHvP1Z32VjImcIKAm3/8BIxJXsgdeqrwYZXRRLOiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MW3PR11MB4572.namprd11.prod.outlook.com (2603:10b6:303:5e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 19:49:00 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%5]) with mapi id 15.20.5880.016; Thu, 8 Dec 2022
 19:48:58 +0000
Message-ID: <ebc6aad1-c997-78f1-8f26-95cd49ed1355@intel.com>
Date:   Thu, 8 Dec 2022 11:48:56 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH net-next v2 09/15] ice: protect init and calibrating check
 in ice_ptp_request_ts
Content-Language: en-US
To:     Saeed Mahameed <saeed@kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <netdev@vger.kernel.org>,
        <richardcochran@gmail.com>, <leon@kernel.org>,
        Gurucharan G <gurucharanx.g@intel.com>
References: <20221207210937.1099650-1-anthony.l.nguyen@intel.com>
 <20221207210937.1099650-10-anthony.l.nguyen@intel.com>
 <Y5Ejgb2P2f/PX0ym@x130>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <Y5Ejgb2P2f/PX0ym@x130>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR11CA0087.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::28) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|MW3PR11MB4572:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f178531-1a61-4ed6-3578-08dad9553f72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xqgK3YfKmK37licnJtajEMriCN6lhTtJp/FTvJzN0tnxQeIYKuE8pLwIZmywtOAANBQF3XUMyL6kkwV/1+78MZvojYTx66cXCVykebbsVu1rzCew29mDYok1db0P9UEe4/IeBaQaDiQKCge75d1V3zCTzGXE8m6e39NqS8ZEZvNb7yFFs6fFymE7nOEnNSVAMFzqV7RLzwM9dxyF6L0YYg2xGRRO3nVjZ0WXjHDG9YM7mIZ9JEEWOslZqbH8/Cfa/IYOXLOZSsFA3yy9LhFhJINMFKr8wax3E3uSRizI0WQ8dFPGi/8iHO8aUwd0C+nhI99cpLzemnhtMFMIjXc7dpE3CGxzMgoa0/dUSSkF52dkWmsiiWh8GeE4YSWNgELS4jgzP/uqwTTeRFFkl5YhcaUvOuxIfXt1+ruakbnYi6snb843W7GegwwZAN/AcVB0oA1fiE8bAWvYzB7Fnha3Wf0vtU6KQb5QMTSSRhGb9bLmr/31Aq+q4086EpXhHA5V9qCARKyjwEy6TStI1wE25XvN4pYOhLBQgBD26p8emWNsvPRi7luNLAV2Wr0QM7t7iikOdrqOXygGUcRAGiV4ezZp0RMRSbn0eb5TH1/+pGk+tcC4Tj9i+HegRrAdOinMJ3V7tJwbkTF9/JE7auYy4iMFVhYpbE6KTzX2sQbivzI3Zv1e04iN3Xf75PoypaZroihDK4JspjHW4l0F7jSDlvTCac3mEok+hvKcTpudSlQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(346002)(376002)(396003)(39860400002)(451199015)(83380400001)(38100700002)(4326008)(66556008)(86362001)(31696002)(2906002)(41300700001)(4744005)(66476007)(66946007)(8676002)(8936002)(5660300002)(107886003)(26005)(186003)(6512007)(6506007)(53546011)(2616005)(110136005)(316002)(82960400001)(6636002)(6486002)(478600001)(31686004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q3RldTBEU29VTllialBBSndJNjA1ekN2WGdQclREelFESUx0SjZkb1RNVVJ5?=
 =?utf-8?B?eHh0YWhlREFJV3ZSd1l2N1pkenVpQVZLUkR1eFc5SXBPUmVlWWQzeVhUVEVE?=
 =?utf-8?B?VUZ3aGhJSzNLYnIwU2M0ZzB3L2djcGd0OFl3bW5iZkxLbGlTcWFRRmhtbzNS?=
 =?utf-8?B?ZTY0VFhvOHRyaGowRUdxZWRTWWJibWhpQ0JOQVE0cnpvdXV1WmdtTW9vdjdx?=
 =?utf-8?B?amc4N3I0ZVdOdjFMd3hzMWVtR04vTzRtY1hkejdlTW1RUXlUYUlsSEk4Vm5Y?=
 =?utf-8?B?clFHeDZEZU5DUVFjNTRkK0F0cTErOUdFZVhoZzVzQ3J0NGVxMlFDOGpGMlFT?=
 =?utf-8?B?T1ZzdmMzYWN0MWtWUDFsZkVmS25kakxidmV1QXEyaHBjcmFENmxuZTdKVWpT?=
 =?utf-8?B?ZElxTzQ5YU1OcjdnQjZ0VyttMTFJcGdteTVKMCtqQlpERWVMYzJud0UzQ05L?=
 =?utf-8?B?K1V0NlFhNWZLUEZJM1haUklRcFJxaW9zWkRybE10V1p0Ni9URWhuTUFHSkdE?=
 =?utf-8?B?RmdXV1ZmTU5GRnlnUmVmTEFON0RRMUFjc0tnU1RRSzYwbXZTMWlnZCtRVTRQ?=
 =?utf-8?B?eFhSYXNWT1VZRVlxWHVibDVIM1FNbllmTjJOOUpiSGNTVWkvTWU2bjM4TkE0?=
 =?utf-8?B?WC9ZK0JkK0Rvd1c0b1J4V1B5TndxdCtnRTN1UjlDVTRKQkJTTEdneWF4emFU?=
 =?utf-8?B?N3RSS1lJdTh0T0FlMkRMRk5pM2Y5KytxVUt4bnJWdDRuK0tTaTVRdDYzMUkv?=
 =?utf-8?B?U2t1S2ltcXFDV0tlZnhGMFhiVlJld3lTYkpUaHZNZ1RBRUNjVElmL2NZNFFQ?=
 =?utf-8?B?ZHNVTFBaVnVOUFFxaUpEN2x6SExHb2RwNG93dExkK2tYKzlHZzlxM3RrMWpy?=
 =?utf-8?B?MHJxQnM5Y3ZsNjRwNDZVc2dBaE9GOS80NGtBZHo5K21LNjRicC9NeGgrbmJH?=
 =?utf-8?B?aGFqQWRKdXcxRmszTWgwTm51L3RnODdrdmhkZ3JrajdIUnpFNUtDNHFSZnhN?=
 =?utf-8?B?Y0d2WUpENTVDRmxiditlZnFJRmdpemNPWGlVZ3RwWFlUWW9OeEJQeVlsVGtm?=
 =?utf-8?B?Y01TcG5Ya2NpTE5vU2VtSGJzYVUyNEE0TTBXbmpzcmxyUG12UEpJYUZlaEtD?=
 =?utf-8?B?UUQ0TWdJbG9TMVJjdDVrZG5vQ2paOENPdGhpQ2JrWksxeDBZMnJMNUFwQVA3?=
 =?utf-8?B?MjYxb2lSNndmZ1A5QVB4TTFwZWNQNElOejRJejhZMWRtNENjcm9iOW85YS9I?=
 =?utf-8?B?KzAyaWN2RW5zelZpZkZITjR3dDVBbm0rekdzNEE3M051WkRCandjdmhQbFNH?=
 =?utf-8?B?NkYrYjNaNTJOQ3lKVXFIRU9SZ2pNWmZxU2YzVjczcEUvT0tIYXowNDFjMDFh?=
 =?utf-8?B?S0s4SWZ0VDNpa0ZIUUY3ejkvdUpPUWY0NGN2eThRbnBtejJRYlhiYmxkQU0w?=
 =?utf-8?B?U25xUi9qUGJFNjJmZzM1QVlMRTJhZXE0ZExoOTNKRGpDMzY3bnFJSCsvRjlD?=
 =?utf-8?B?QlYvVXJOakJWWGhwMkw1TmI2N29GZnZ0STRhbERMamlVYXFuUjdlOXgrLzYz?=
 =?utf-8?B?Q1pzYncyckl1N1hmZ21HZlMzSi9TdElycG41S3AycTRLSHg5aTdWUlRlU04z?=
 =?utf-8?B?U2JHZExhblNWYWFUaUtkbElTZ3U2eUF3UDRsQXRqQkUySUVWVkNWUVNnb0tm?=
 =?utf-8?B?YzNjRmdhT3NuUytYeDU4WkJpZDd5YzRjWHExSXFBcG5FRmUvcG9DV1JjZGRY?=
 =?utf-8?B?eFYxT0RpUzhVSksrbE5HVXpEeFlsUVJlMWZzbkJ4R0laOG9QaVVDNGt1OEd4?=
 =?utf-8?B?K1hENTc3TFVIL1BSOS9sTHZrZ2dHaDl4QnB1VW10dG1iU3hCMlZoVzZDbldU?=
 =?utf-8?B?WmdSaVRCeG1TZEhBdEJqeFBDYkd2YUIyWGpNYVlabW9NYlRTQ0d1T2lIc0gw?=
 =?utf-8?B?b3N3eHIxQ0F2YitSQjdZYzFYdVVvRjJpdjUrRTI2Z2dYUm1UOXNIUnRNU2Nn?=
 =?utf-8?B?a1hRMXhjRVl6TUpzdldhS215QllXMHg1UjFuUnI4Szl2ZnVRb2UwNWpOT21D?=
 =?utf-8?B?RVE4c3hDTXYzZWlyT3hINkxORHJHYmFTcjU0Uy9LWm9KS0RCbm9OampURWxq?=
 =?utf-8?B?ZUdOL20vL0J3dlBXK1g3dU9tMVdGZzZLaXZCME4rWlMwWVF1QlBnSFVXQkNv?=
 =?utf-8?B?bkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f178531-1a61-4ed6-3578-08dad9553f72
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 19:48:58.7961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k+If9o0M03Z1CKaw39BwySGwZt0b52ZWdoFdrjwooDnqBf37Pyq0jfG5kwgJNImao4tU0wrSJmIVgoHMayCXkAGX7bjsM1wtEQN9l63sPO4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4572
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/7/2022 3:36 PM, Saeed Mahameed wrote:
> On 07 Dec 13:09, Tony Nguyen wrote:
>> /**
>>  * ice_ptp_tx_tstamp - Process Tx timestamps for a port
>>  * @tx: the PTP Tx timestamp tracker
>> @@ -788,10 +805,10 @@ ice_ptp_alloc_tx_tracker(struct ice_ptp_tx *tx)
>>         return -ENOMEM;
>>     }
>>
>> -    spin_lock_init(&tx->lock);
>> -
>>     tx->init = 1;
>>
>> +    spin_lock_init(&tx->lock);
>> +
> 
> this change is pointless.

Yes it has no functional change, but I found the code nicer to read with 
this last.

Thanks,
Jake
