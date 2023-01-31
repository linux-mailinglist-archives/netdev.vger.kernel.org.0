Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54A4568356B
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 19:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbjAaSes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 13:34:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231770AbjAaSeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 13:34:23 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0111E5BA9
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 10:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675190018; x=1706726018;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=m2GdOYQ8DX6PEWFWTxs+qd2N7RSGoW8lZdq620kylA4=;
  b=fTYNRegtAFmv0hdPVa1N9TVeao2TjmMgYn1ZIh7baKuVHi9IBIaIW9j7
   Dl6mxg+U2cvS/1f/A7ziVZZ3CzzdaE3gjZdDd9ZT5ecfY4JcGHAWM6UOL
   zP6wkXTJRHoXmDuPQcqMcMOe+WR8Hc54c82tnJwkKb+HvCyQVQPDs2Owt
   Xd/y9v8fG83m9U8cOorefKUUNCB+QEEz13w+FOsvz6dQZRxZkANe7I22R
   3U714CdIMa7jUiqJBNhyd+ppur7UkKKPRfcc6SkbtYstZOeXqM3WBabQN
   B5JScMSCDqqD+/A3dHLgOCNvGm/uiPllBbQ+FqUACusWeH87JBjsqT0hm
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="325621890"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="325621890"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 10:32:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="657988852"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="657988852"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 31 Jan 2023 10:32:57 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 31 Jan 2023 10:32:57 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 31 Jan 2023 10:32:56 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 31 Jan 2023 10:32:56 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 31 Jan 2023 10:32:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kj+RL7JMXhAOofTSx5s/YONzRZkh7MRSRA0laVERgiTXftmipF+8nXzClecQUFylurN5YMSWuA/AegPj6wElua242gfEONehJ/86RenVu4wYU9N5lT8dLqbKlAOrhKfvDkvVMoGli2nmPUscou4Q8vC8klY0GNcim6CReVB5qnYCeXOHVMW4ZmcEgpNs/CKnTCDjA2LMmDpQ7bxlxg/ibHoQpDksfD2ae78iBOktJo6URAtmPKBVt6mfJhFO6jv9OOgAqLVAH6RrelceTMmZUn8ZUZsGGQ4CXecvaMp6ark3juTsGfSYerAu+TrbTw6zOk5AcrBWJ110ptI0eHjE1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IcTkAswBFVWBzDkZ3lCnAtnvuTFVPnfgY+RWTOxis+w=;
 b=e1ci19+gG3JECM890Pi/rqhGKFp8xgzr5u8m7h4XnK/+9ZQe4Lnm2F0FCzZf+uz+WJj9I/tulqnAW57CU3ZA4qSCJQSaQwiO1vKqjXzGQdpn/wXMW/KkC2wmDEApZ0BmE4b1dqwXgSbaTGm7Nkq+SIA9Sz5k1Tq6KsVhgXvtL40E6fGXuEK6dH2xj2mGu7Ja52+Sg8S+i3aByunSj7jlkZ5nstPlQHJZko4gCA2hZ5nPSVNgX3Y5QatxWh9+ipRcWedI5ZA4x7caZTKxZgiTAj7MFTMGDICGIwyK4bkoyJBlJBza8oJnv3I8u+QnqpWl63Q2IJDTpE1YMBsor6ewtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DM4PR11MB6335.namprd11.prod.outlook.com (2603:10b6:8:b7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Tue, 31 Jan
 2023 18:32:54 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6043.038; Tue, 31 Jan 2023
 18:32:54 +0000
Message-ID: <36db5ab7-8063-21bc-2fcc-b964637030e4@intel.com>
Date:   Tue, 31 Jan 2023 10:32:52 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [patch net-next 0/3] devlink: trivial names cleanup
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>, Jiri Pirko <jiri@resnulli.us>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <edumazet@google.com>
References: <20230131090613.2131740-1-jiri@resnulli.us>
 <Y9kCTq//4yXyDSM1@unreal>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <Y9kCTq//4yXyDSM1@unreal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0006.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::19) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DM4PR11MB6335:EE_
X-MS-Office365-Filtering-Correlation-Id: 882860ca-1ad7-4a95-0de2-08db03b9912b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jouoqUWdPtu0+0neXyJOhcYQQql17QjXaDgUS8m2O72ynFZKFW/fVfr/I0ieallimGltrjmHxy9jxL12ckb8T6uIjLx+/3Ztjp2kFHpNoLD8A2b1/m1Hut7ODWeTF+0LQDqrMwEcIgryKbTA8erp9tas+sIO9t91dC8vNZctxC3I1ryY4mNWgPjUdMM4522TIY07dmjYVuSSpL5Pqs+2k1p7VjLpn6znZW0KvOZQgD/Zg5/7Vtvsw8z9Ev6Aed+IvoAp1bGhpEotAjR5OrXPb8eOPpUHUP4E3tAMt+TnNkxJcjf7Nx0iftSTIO4+si/pgOf7G4CHq896YYQ/fiG3w2TATDGCNT50+B5SO9ktxOHVAXWZTHmFy8IzRumKEkdOkm+AtY20f7nSappOc0pEK+xC0GV5HJG9afQB+J6p3fS6zdepOSnVus0XWoQ8D8CwbjSIq6cpKsHyhXjIK/g2PPIATMqcfw1qPmEC8vN+mVr7fEhCDYeNkUgTKY47fSevUYnXuvG3UKJszST9U/Nl7WblGHEFkMMUwdMhWdb89M8F0NPKvN0cfBdGs47Zyt18E48/J293loAx8nk0lPcbBEwWkRVCrqCtjNnPrQVsZJ7mjDPDk5mdHbhpYqQMmIWSWfmyLDNPDWuNx5x4/RxSLVX4IttBHJPzdK/8gdpn1p3AR9lzg14rjcnnp/W0/YMH+eGRTrHMjsSz7yfKnzopmRelkX3/mM7/ZUEkEITUV5I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(346002)(136003)(396003)(366004)(451199018)(8936002)(31696002)(41300700001)(4744005)(86362001)(83380400001)(82960400001)(6486002)(110136005)(4326008)(2616005)(66476007)(38100700002)(66946007)(8676002)(316002)(66556008)(186003)(53546011)(6512007)(36756003)(26005)(478600001)(5660300002)(6506007)(31686004)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QlZEVXVNRkZmRU1TNHZITG4rVStQZGxzUDN4dzVsYUx0aVl4SzVOQmxrbEda?=
 =?utf-8?B?K1NPZWRBOWdONG83R3dwZFg1Y25Kb0krYjJLRGl5ekZKdXhQNE8rUEVRRkdn?=
 =?utf-8?B?NUNnUkJ5VVVmbDJBVHVxNTg5bkhnM2c5RFZ4SHltYUtyeHNnKzdGWHRKWTdq?=
 =?utf-8?B?MG9GOUs3SWNCVXNvME1tcUs3UzAraFY3UVJQbGRxdkhPUndKdVdTVDVFU05Z?=
 =?utf-8?B?NjVQeXpRc09yaEx0a1F0WmRrWmtPRURwLzU0SkhuVS9rd21YN3ZCL3VhblVS?=
 =?utf-8?B?cG9sbkx0K3l3WGY4WFdmbUJJVldVdTdzSDVETzV1ZU1sV0kvODBIbXVtd3d0?=
 =?utf-8?B?OHJMMGpVSXJXRFBmbmNDSmx5R2xrdFc4SnE2b0szb3B0anB2Yi9MOXVhRENw?=
 =?utf-8?B?STRLZC9iUGZ4Y2poeHMwNEd2YTlKLzgwc0VjeCtYRzArLzZrZ2ovL3hSekFM?=
 =?utf-8?B?UFlhM1BwR2pMU1dWbU9sWkNUYW1FU2JTMnEzMHVxUGtLd3FXSEVTNFBGTGg4?=
 =?utf-8?B?azFrMUJJdXc1VnNja2NzME8yeW4zV0p4Tm5DeHRoMlZKS0dFWjlWbk1qcTJJ?=
 =?utf-8?B?aXNtUWtoMHZsSXAydjBWaHBPekEvczB2anRrN0Q3OUsxYUR4SGs5cEtLaWV0?=
 =?utf-8?B?OHJ5Qy9qbkNpRVljTEZSSXIzdW5tamtQL25hZGordEtyQktKS2pJVW9CTWVJ?=
 =?utf-8?B?WncwRWgxc3ZRUWtqWUxKeGRyczF6TXpNWnB4eTFOc1Mva0JZbGtGcVJsdXF0?=
 =?utf-8?B?MFpnVGRWa294Sm5zZlJ4MVhEdjVDVkFXYnNFY2FOcVJTaWVIV3NFem01aEJz?=
 =?utf-8?B?ZklIaTl5QzhQNUE0THBobEd1VlFxa2JJZU9MZDB5QzlXYmppSGhFeVI0QzZk?=
 =?utf-8?B?TzRXdHFnSjZUUHJLbnJwYXZZS3pzUkM1YzYvQzYvQXNUT3AwaE11T1VjOXBq?=
 =?utf-8?B?Mk9EcXZreEJTU1RYRVRXWjd5ek95U0g2cVpqM1NtZHUwWVNUQnBrQnJ0d2FQ?=
 =?utf-8?B?SG45Rk1NaUFRc2FvaFEySUtGRGl1NXNqTGNsVCs4Y0NJN3AyNkFKcFNxbGp6?=
 =?utf-8?B?S0dVUnhnUGxPVVFiM3VXOHNWcHpGSmFBK2hOWWVNa1EzTjZEVnAwczQ2dGto?=
 =?utf-8?B?RjU1Z2ZETTUvcmQxZXhJRnQrQzJ5YjVsR2pFT2YzOXgrQ2kxOG1HdEhpZTVV?=
 =?utf-8?B?bWhnbWpWRVVrY3FyRjJScW1rZlpVRk1DN2FkbmJkMDJrbk5aZVhoVndvRGlD?=
 =?utf-8?B?RS83cG5wRUEybVExbVh0VGt2eUhjMER1aUZFYml4RWcrRGNETGNlZlZRbThr?=
 =?utf-8?B?VERKL0FCaFZrekNES0NqR0V6eThSL2g3UmFVRDJFbmFuVlcxK2FTVFNtbWNV?=
 =?utf-8?B?cTZ5L3Q4MmpxN0EwOHp6Q3dsM242OXg2NHVjYnpQSmZ0WEV5QU9KVllVRWFy?=
 =?utf-8?B?TmRDbHgwZDBHUjR0a0RMMGZReWxodEUvdWNoZEVXL1dUQzMzSzRNek83ZS9p?=
 =?utf-8?B?RGFKR3pqcC9vWW9keHZ5UTZkVElKTU5yNmRycFJ0VmdRS1lHaUk2YTRVYWNB?=
 =?utf-8?B?UGN1R1ZGRytRRnZJQ0M0OWJZQ3pKSitHa1QxbFRKSERtT0ZVK1JNMEVldElB?=
 =?utf-8?B?dmxDOXZ4UWp0MHkzWkcydFgybUFSNENNOC9leUkrL1h4eUVIWjlpTnVKbWR1?=
 =?utf-8?B?S2hRTnJIelpBaWdNeVRYaVREZFJJTDBpNmpPSWVBdE1ObkRKZ2FITUlncDhm?=
 =?utf-8?B?MTNmVFBvbzhCZDZVcERUZGRUeVNTZmxGam84RDlGT1Rsdnh1bUxZYXY3akR4?=
 =?utf-8?B?UFNRTUVmWG1oZ2Z2eFljYlREQ2UrVVpoa09VTzczaXp5WVVSZ3hORERVRDh2?=
 =?utf-8?B?UUFEbnpTeEJaUkZwMk5tc1ZadUJ4L0w1NThOVWEzak1XdWx3VUxjMmxESUd0?=
 =?utf-8?B?VldabllNLzVtT2hlcWhKVmtMQ2ltMURzTzB5V042OFZLcFpMMVpHdkJtVERC?=
 =?utf-8?B?MFA5UnpMRW9DVk1uR3JPZXNVZnhVSFZXTXpBS1VJUlZ5b1BBeWMwSjBVZzF2?=
 =?utf-8?B?Y3NKTTZncHJZeFEvLzdrdjVnY3h1U245bUgyR2FRRnJ5c21aZWoyZW4wQ3A5?=
 =?utf-8?B?aFByQm16dGlmNDhsMGpYbjFjUkdrcytoampZVXpXeHJOR1o4eEVScDBnR05Q?=
 =?utf-8?B?RlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 882860ca-1ad7-4a95-0de2-08db03b9912b
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 18:32:54.4439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GdzoWVk76OlepUUwWi31YJpYNIk97ACRu1R2lpoR+Xg/DWKtUy4B0GFCFjU2rqasgwwOJGkU/r2LrrVv87QBO6EhdxlxwnyZ1tADbFEHsro=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6335
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



On 1/31/2023 3:58 AM, Leon Romanovsky wrote:
> On Tue, Jan 31, 2023 at 10:06:10AM +0100, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>>
>> This is a follow-up to Jakub's devlink code split and dump iteration
>> helper patchset. No functional changes, just couple of renames to makes
>> things consistent and perhaps easier to follow.
>>
>> Jiri Pirko (3):
>>   devlink: rename devlink_nl_instance_iter_dump() to "dumpit"
>>   devlink: remove "gen" from struct devlink_gen_cmd name
>>   devlink: rename and reorder instances of struct devlink_cmd
>>
> 
> Thanks,
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

I like these name cleanups as well.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

Thanks,
Jake
