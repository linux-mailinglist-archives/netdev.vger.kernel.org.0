Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 206616487E8
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 18:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbiLIRnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 12:43:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiLIRnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 12:43:11 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D4310FEE
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 09:43:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670607788; x=1702143788;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bkSeHC0nvZxN/zqE5ltBpP139izKly+bkJdlOOkhi2w=;
  b=Tv5nUlL7wyi1zZRicONF8mq8JY3S0/NUCfRLDeWjonDmYALMpJXBpLn8
   iMO0xrwxH4jK0wv9qAEKDGCOWMRW8DNYGrNYmlOEiFZwroerHMZ3qkt29
   KkO927+565yAu/60Kt5ep/kuYbIRclLnQdvHhtU7K1uwfgllmMo4MuPLM
   Z/1QcSicDTTF+q8v9sVPQtABMty9tKQCjkV73l7QiY9kmAnfNZknK6D4j
   wAVQBkLIvveYjgy5r70ey733YYYUUrPBdT6s2HhG/O/+AYuNNAGXn7uwO
   9wXf1A2i41EOjYRpAIRsQFIqr1ic69Culv2YckbkI2jmk68y4Faskhsw8
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="300932591"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="300932591"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2022 09:43:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="754109861"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="754109861"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 09 Dec 2022 09:43:08 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 9 Dec 2022 09:43:07 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 9 Dec 2022 09:43:07 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 9 Dec 2022 09:43:07 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 9 Dec 2022 09:43:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N40eV0IP8Y6gGY/buk8aJqbhiYofaFUGoOSYkXN2wsDM9pjMSqwCWKsXPJJFA0hhAsqQcKXMg3npXRssxDvVCkqvpf1dDi/bLfHb37WV6nbYHy5sbkDhuh4TlJFPUVoPaqvKqZipX36Cs9r9b6WGwqN4QqwOEBxUmImdXrEAr6ztbg/pneJvaTAN09SDItRfK14F22ucF5CIMnM+78rIxJzd2/M/rWwjiGvPbuYe1XsqJRMtbIsrfkW4U0dJEAy7rT6e4RUEodQPkzAeRBgkNhr5+of9TKuWkV+EPZ+RsTpRAFS1DuB3ahHWu/ylI88r+ddrxHAwgOk9a0qb9w00gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sIeE6LFWlWpMnENLAbdWNeWUrN/ZoKJiSO0ikJVMBro=;
 b=BT1VOWKt3tpE0g3cM4IqPmBi7FQ1RU+9FUeYuAPAl5A+PqpSWG0kip7mccRNIwRZ2WbxepZMmItWtZBeXm65wVlVMOjT/TuQblOEHvCWuSunavGXFQ9ix6Sr5J5T/5bcbw9OqtcrhaQ82o0QywfXarjU80VbLV7CguQy6JBzcMzKJKPAKvzoqvNg6ZGq7u7Oxh/v/iCUuXcqzwZp6Rcaw9Iiv4b+UOoQCRb/vCODem+L3ywGrqwO643b+M/PgAvpBQ9n8xjLZsmZTqEsEcei45ulHnjqEFtBMLFdZJRLmUmSP0+SMN93sjQ1xtGbghX8sQ6IOaT4vet9KuIPvzIIwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by MW3PR11MB4604.namprd11.prod.outlook.com (2603:10b6:303:2f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.18; Fri, 9 Dec
 2022 17:43:05 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::6ce9:35:a5db:f6dc]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::6ce9:35:a5db:f6dc%4]) with mapi id 15.20.5880.016; Fri, 9 Dec 2022
 17:43:05 +0000
Message-ID: <52408830-e05b-03bd-3c3c-4195af1efbf2@intel.com>
Date:   Fri, 9 Dec 2022 09:42:59 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH ethtool v2 08/13] ethtool: fix runtime errors found by
 sanitizers
Content-Language: en-US
To:     Michal Kubecek <mkubecek@suse.cz>
CC:     <netdev@vger.kernel.org>
References: <20221208011122.2343363-1-jesse.brandeburg@intel.com>
 <20221208011122.2343363-9-jesse.brandeburg@intel.com>
 <20221208063432.rt3iunzactq6bxcp@lion.mk-sys.cz>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20221208063432.rt3iunzactq6bxcp@lion.mk-sys.cz>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0064.namprd05.prod.outlook.com
 (2603:10b6:a03:74::41) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|MW3PR11MB4604:EE_
X-MS-Office365-Filtering-Correlation-Id: 488a638f-27ba-4788-878d-08dada0cd3e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JMbDPNAzctou6vOy5wDT4YXdZ8FssCAIPWQVKyNMwYc7MgAbZQrZVgyoG1/zdm0wtFSEa5mVq4eAp+GQQlRMDMS+zkaW6X0Wyh3Sb2Ol6eNNk3ImFDa2UejOxeeUTxMmpw4qkSgAHHHbyotfyrvH4Nz3pc1DH/v0DPs92pqnMiYing1IZ6eNJxJvnEJV7n3x0tPtJuxOGLinWCGNt1WWSmbFCTifNOtEnHCVl8H6hCbIiNW0CBJdndSiNCpmqNEiYD5F7n5WqgohMBqzeNnLqxwuJStjD3UW4cgTaiVh3zI90ReZDbygM7jqPHauoa5/5ao7HzfLqqsb6uhQJdcrZl/1a+8hTAqDqAL9gcpvdbsvCjFfaO2bSRn0guYhtjr8jKIMZZu2AQA81FXIvG1p64P4vJkRXL+E1mSbjUqU1x9ezWZKg+JsJkfHuwFnIpliqAWBC2RSp7siwGcQ/IK/yr3qfWEjAo7lKOA4ndBk7trhvb866KffwKlXCA78hGeqxFy96z2e1/vvZbffrBDmKJXssvf7VJjEsic6Kmh9eSG8O8fYzV3p2PABBdaSzbcs/45oBJMKQMeIdc9sJeFnwGqorPldPYg8MhPn0YcTNNaze/+RZtsJpw+racrDVLO0/YqcDiJuW7RX8T143h/oRBxU/s1mmy8MYCwuIv3TwW00aVmJTylFFC0bVsc4JA9RK5ngl2ne9/qkIoWJqRXe4Z01aDxxBLNwytyOlWGkzac=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(136003)(376002)(39860400002)(346002)(451199015)(66476007)(66556008)(66946007)(8676002)(8936002)(4326008)(36756003)(26005)(41300700001)(83380400001)(186003)(6512007)(478600001)(38100700002)(6506007)(6486002)(6666004)(53546011)(2616005)(316002)(6916009)(86362001)(31696002)(44832011)(2906002)(31686004)(5660300002)(82960400001)(4744005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SER6bDF4enhCclJ5QU83UU1WeWNDQ0hMUWMya2FoUCtxTnhad091NmlyL29r?=
 =?utf-8?B?MXFDTExIMjJXMnY5MktiRi9GL3BrUGNmYXJkandqdGt3ZHdOQmxiL0NPVTJJ?=
 =?utf-8?B?MTk5YjdhY1V5Ny92UUk1RXF1aVZnaFV4MGQ3My9YQ0tJRktWbFZaQzM4NC9I?=
 =?utf-8?B?YnYrZ2s2YmxEaDVVejk1ckJnSDE4dFQ1RGx5UFJhbi9ZWFJaOWhqOWI0NjRX?=
 =?utf-8?B?Q1hMMUZidTVZdkphNmkvRVVLSmZGclZLVGZvejdsd3Y3d1NSV3BNUVVhNEZK?=
 =?utf-8?B?YmJlaFVCVzNsQ2JZL096cjN4eTVrN3AyQllRSmQ0bUljbkpQQkhFejRtTy9r?=
 =?utf-8?B?SzByNWtyaWkwaVZTMEdaL1pwMkJNTmJ5RjRRaDloWS9qMFhXUWN0NUhZdHNQ?=
 =?utf-8?B?RFdUaU1TYjVJWFRsMmpvWjVPMGFERzN4NENMK1NaV21jVkM1aHBuaWdNNUFq?=
 =?utf-8?B?MmpwY2tDM1RxU1RjY1czSkQwS1luOWpiRzJpWkVPYnlXQTlRMkdHNGQxN0ZO?=
 =?utf-8?B?aU8xUXZCb0Y1RjRKVnc1TGlOYWRhaEtORlR4Qmp6ajQ0WVQ1S0tsZVBIa1o5?=
 =?utf-8?B?cVQyVVZKOVZPREhQSFFvSS9GYVBHOEcrQjZ3cG10TERNcnVOTXBvcGpSUDJ6?=
 =?utf-8?B?VUlDWEdjcDh5Kzc5Z0ZscGdrTnh2NDIyREhZakYwRUJkazJJeGY4Y1I5OVhZ?=
 =?utf-8?B?eGVVMDMzQWhQaTdqaytUckFQZ0dIUFZLTHRobHUvaW9hb1hpeUFrZ2RLclZO?=
 =?utf-8?B?TTJGR3RDZnRmdWkvZnJKZGVpUEkvd1ppekNvdnUyVTFaaHplaFhhMFpXMGo4?=
 =?utf-8?B?M0tWSERaS1FZM05leUE1NWRXb3NRb2xmVGlmT3ZkN3l4bGRmVUhxY0Q0c0g4?=
 =?utf-8?B?UUpaSXFvc1hkVTRmRjJGSEkyY1l2WW40dHYwKzZZZVZpLzVWZnYrQnl0Qmlv?=
 =?utf-8?B?aFhUam5KRVlsd1dvNzJJWHc0SUNWQ3diUGVmRnZyWU9lRUdDY2V0TjNYb01x?=
 =?utf-8?B?bVQxWTE4bDVUNXltTE1hamFtYTUzdnNLNTE3K2dxa09pRlFqOGFzeDFxSnRP?=
 =?utf-8?B?aThrMk9ySUhJbGJSQ0l3cjFSOG9FVVVUeWw2UVJTUUdEeWMvU3BCdWxzbFd6?=
 =?utf-8?B?bGZNd090VTg4ZGlsSjJmYy83NHhwR2RiaHU4d1dPbk1ZS1A2dS9tRVd2WmdK?=
 =?utf-8?B?Z1RjNytTanRpUVVFSjZ4aUFnbWkyMDNHUWVjZjhmNUJzVUtQM2ZrZ1l1Z0ZU?=
 =?utf-8?B?YWlyY3VoMml0K1F1djVtbFdQV1JhRXdqK092L1RoR0lqaUtFcjV6SjJhdVo0?=
 =?utf-8?B?Y2VTeEgxWmZLYm5zNHJQVDh6RzhSWUVidzkvQ09aakRsOHNIcGRwUFlISk1G?=
 =?utf-8?B?YUo3SUxneSthU0c0WHZOSkJ0T25nWW9oZFFpL0hLcjRoQ0hqSzRPaHBqd0JF?=
 =?utf-8?B?R2daNEFEK2VrUGpoTnk3UDZRVlpyRWRHNFhOOWFXNXpBVGhvMDE5RHZra29u?=
 =?utf-8?B?eGtOTHNqTGV6anpOalhmRW9EL3B5RGladVloWTl0WjR0eGswSm9KSEd5TzFk?=
 =?utf-8?B?WmR5V0Y1U1NQTldPaEpBV0VBZTREVmp1enBndVNxWThxT3ROMVY2NmJPVitk?=
 =?utf-8?B?a09DN2NXdlo3bUtsZEkxcStLSDNDamlFbUFaRW5LZTY1dzlwZWJQak80d3Fa?=
 =?utf-8?B?QU9tc0ZLNVY1WXBYdkV4bkJzdjVPaklqaWQyVkxJajVYS0oyNEh4Z3FtTVgr?=
 =?utf-8?B?Z3IxS1JZUVVUUG9tekNsUnJiYUJLNTZhNUdrUW15aGRHNE5qK21ySkFVVXB1?=
 =?utf-8?B?YTZLVUZXQnE4cmhHRFlzTFpuS3hWcE5NaEZ5d1ZkRkFHMTNwSG5XdDc2ZzZ1?=
 =?utf-8?B?N29ucTdJZDVjTHd2RjFsM01oYnFIZzFOakJpK0wwcStpazU3V1NPNWU5Um52?=
 =?utf-8?B?M3o2S3ZMSVhGTzBKWWFjMDV3eVBHK2ltaC9Td2VjTVl2K05xQnUyOGhlTEVC?=
 =?utf-8?B?T2xySGNzWlBjdDdtQVRjVk1FbE9Yay9Lc3RmN3A3MHBlRUQ5TTVBMTc2YWFS?=
 =?utf-8?B?MUgrNFdHTmdTKzN3YUxxYStFeGg0RnNGUmFXcU5panV6Q3doc09uZi8yUEtE?=
 =?utf-8?B?VjZtZFJhMW84QkRsazB2ZVpIZDdkT2Jya2JudXU5MktSU0M4U0lIT0ZYTS9N?=
 =?utf-8?B?UWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 488a638f-27ba-4788-878d-08dada0cd3e1
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 17:43:05.6676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SylljuDAJFVMX4MAewFbBwK20bGuIJTn5wN3m/+Dqgp/Klixm6SH7hlDDggRM2gQyT4bVFjbOfE7PZTwMmcdof5RWJHYTzPMIOJBhb0Nab8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4604
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/7/2022 10:34 PM, Michal Kubecek wrote:
> On Wed, Dec 07, 2022 at 05:11:17PM -0800, Jesse Brandeburg wrote:

>> -	INTR			= (1 << 31),
>> +	INTR			= (1UL << 31),
>>   	PCSINT			= (1 << 28),
>>   	LCINT			= (1 << 27),
>>   	APINT5			= (1 << 26),
> 
> While the signedness issue only directly affects only INTR value,
> I would rather prefer to keep the code consistent and fix the whole enum.
> Also, as you intend to introduce the BIT() macro in the series anyway,
> wouldn't it be cleaner to move this patch after the UAPI update and use
> BIT() instead?

I had done it this way to separate the "most minimal fix" from the 
"refactor", as I figure that is a clearer way to delineate changes. 
Also, this specifically addresses the issues found by the undefined 
behavior sanitizer.

I'll do it whichever way you like, but you're correct, later in this 
series I fix up all the BIT() usages. Maybe we can just leave this patch 
as is, knowing the full fix comes during the refactor in 10/13 ?

