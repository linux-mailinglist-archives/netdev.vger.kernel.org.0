Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3464BB677
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 11:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233895AbiBRKLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 05:11:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbiBRKLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 05:11:50 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C46BB369C6;
        Fri, 18 Feb 2022 02:11:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645179093; x=1676715093;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tCccRiwobay9DULgPmXUhgPNS+hL0ny+CccAw6bWo8k=;
  b=ExGZgNWb9jE47WNsLD7xbIC1++dhPGHn/vCraMdkKgiQj2jhK0sZ2IAG
   8RmKF6BjcIV2DIfGUvi+VCu91bJFKnFQcRHVexUyxGMfPKmpS3LH0J2Es
   0jake9noQfjWOjnaosJSQxcNkByLIFN3SKieoBQD8D/ReBvRScVZPtqmN
   1Lr8bYjWxzpB+VWjf2zsvG8G8Mm8vIfiG8gAX+17bY2RimycZ1AC8KRGa
   6BOBiZiIJckOpmCpwshUw2OWMMX9SEdM8rwhKWSJu42btDCx0Cch+Eleh
   EByQ3xU040Br4kn1FemjtMQ72StRBi7VOZQ4gLYMXmVkGby2oKqr6MosJ
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10261"; a="251298069"
X-IronPort-AV: E=Sophos;i="5.88,378,1635231600"; 
   d="scan'208";a="251298069"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2022 02:11:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,378,1635231600"; 
   d="scan'208";a="682444549"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga001.fm.intel.com with ESMTP; 18 Feb 2022 02:11:33 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 18 Feb 2022 02:11:33 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 18 Feb 2022 02:11:32 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Fri, 18 Feb 2022 02:11:32 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Fri, 18 Feb 2022 02:11:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z+tZ7467OiuyRMt5HmkiYu7hv3m9vn8tBVlbzXy1JHKET/zrp/PxISKS+LCbAtGkN2AdvrFBKYDpMFRqdvy+uOjKqcLbVqZWr5woxjPd7w86sTA3y2gBjIOqlonzvnt7NAIzFcy+ClWHWC+7o2LEGp7rSSJt+eDMyWprM+vC0hJv3Z2ew7EEQHmsgGiwLOmSX6TLX9D4NDGjiOcYnciurwoirG1Rbc/Edg1PVuYZMk0bvS0pJ4T1C7JFOu/I9vWhz5GKsvveAW/uPmuYqkOqqafSWOquICgUWdzUEbJEafE+J9TXAW/3/3BJ8MCyI0ZG+UUgz1kuiHd7g/e4JidMxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SzHuwU1mWUeBa0w2b7jO8kf+m0gyDxrsAXfRuZKXkEs=;
 b=gvcTYQBi/KJzOWZQVJY2pnirRSYRqpJhtYm46cC0EoLH/a13CF0zJrmGXBw3xbD+Sbf5L2VO/GmTrjj/Bbuiow/V2oVam84Ry2IpolnykG1xv3g2OW8rxJDPybFDOruxLvfjW4cUkCwZ54Ir2iWKCZ/JOY72HSBeHYUCc7+2w1cbNjDgiiKXF4FQnL4e+rLi7n7bOOl8l0GVYwjFr5UnZ1qB5W3U45UUrcWHgk4peyXe9qTMqM2yE7xwa4vajhrUt7f4SncPyRdoxxJb8bpdoDHXLf27Xmrxhpd7z/wIlKl/Jc3oYTDl8cLhv5wUvZhGMo1fPA43WQKZpjPaPzZTcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3180.namprd11.prod.outlook.com (2603:10b6:5:9::13) by
 CH0PR11MB5346.namprd11.prod.outlook.com (2603:10b6:610:b9::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.16; Fri, 18 Feb 2022 10:11:30 +0000
Received: from DM6PR11MB3180.namprd11.prod.outlook.com
 ([fe80::11f6:76fa:fc62:6511]) by DM6PR11MB3180.namprd11.prod.outlook.com
 ([fe80::11f6:76fa:fc62:6511%6]) with mapi id 15.20.4995.016; Fri, 18 Feb 2022
 10:11:30 +0000
Message-ID: <be54417d-3fe2-9af6-a1e9-85d516b7fd87@intel.com>
Date:   Fri, 18 Feb 2022 11:11:24 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.6.1
Subject: Re: [PATCH 3/9] lib/ref_tracker: __ref_tracker_dir_print improve
 printing
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
CC:     LKML <linux-kernel@vger.kernel.org>,
        <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, netdev <netdev@vger.kernel.org>,
        "Jani Nikula" <jani.nikula@linux.intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Chris Wilson <chris.p.wilson@intel.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>
References: <20220217140441.1218045-1-andrzej.hajda@intel.com>
 <20220217140441.1218045-4-andrzej.hajda@intel.com>
 <CANn89iJ3W3ioVUaBJikCpFdCa9o_APpqyb0FmK9AmYPtgOeC7w@mail.gmail.com>
From:   Andrzej Hajda <andrzej.hajda@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298
 Gdansk - KRS 101882 - NIP 957-07-52-316
In-Reply-To: <CANn89iJ3W3ioVUaBJikCpFdCa9o_APpqyb0FmK9AmYPtgOeC7w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0467.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a2::23) To DM6PR11MB3180.namprd11.prod.outlook.com
 (2603:10b6:5:9::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 13475f63-08ef-463b-21d3-08d9f2c70875
X-MS-TrafficTypeDiagnostic: CH0PR11MB5346:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <CH0PR11MB53466B24AF5320D3AA9669C6EB379@CH0PR11MB5346.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:256;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oGUe7a0/T9W2ohTJ+2rEgF0ySpKCSRYfYPi7/Z2Yws+UGJu0pVQ/Y09lBz8kKV2ijmiX55oAPcf8Tdd0I8oi0STVDa2b8flCWoZIs3AVLVC/1fiV2UgKO1SuyReY1XPKJwmBV+h96+TscpRR5Jp1fExThQp9bCW1SxYHoNZ+SVLQkbv1BZ8ll+0XVHB7HOpte6+MAusRapqzoHjjmhrzPL4mNX0Oll8wiPjxayJnaaZFQYUN+yR99r+RVEtGNznQn5Ov0MrZ5FDCU222f4P/wbpQGhtltvk4tjx6S3okW9E8wb9xBMupGcKv7ECr6RXxDmuCTMue+YKRh9lE3qV5hmyDpcZKVz5JDBPwx+u1nmZIpS8rrn4G7/6yF4QgoVwbCr9IlXpCz3UuBA2o7X2Fv78nAg0q+Q4iD2UzMPZFf4v1+3ZV1v0dZN8Jvz4clSeBaTbGRv9tNxjTT6CLbvVpRwZcib3A/gCWuESbiQWfpqpF2GMOp9PQIOuQnyU2Alz5/eV4VnbRdc5V0pnmku8clF+VLEYGFVOTM7+OcBpNPrlgQ1dQHw7AZHCuM60ARJTocWDl9YsyL4Y5sLcVIBf9/HqoagsLHIY9iO3HuWF1rin8/tjsoOtxFI92OftKmkAxumCC+sDjQ9iP2zkNJlF9o9GdCREoA+lyZNuuIrO3Lj1MgCudtThCKxeLsGeE24hGz9ZYRjjXoEyVGj9QV9QwHwVxzQo3zccNX6Jvj0ZdwXw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3180.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(2616005)(86362001)(31696002)(6486002)(8676002)(66476007)(4326008)(508600001)(66946007)(66556008)(2906002)(36916002)(6506007)(26005)(186003)(6666004)(44832011)(53546011)(5660300002)(8936002)(83380400001)(38100700002)(82960400001)(31686004)(6916009)(54906003)(36756003)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bFNNWmxhZHZBZUx1djYvV2xTS0NUVHBXRmh3U3JWUGUwOHNrdW1uajFFem1s?=
 =?utf-8?B?WDYvcjlkZ1pNVS9vOVZrWjlCaCtyeW1BVXVEU1diNFpHeXc4TWlOY0xURlpH?=
 =?utf-8?B?cDUrdG94ZW1XMFZvSXF4dGVTb01BOUUzV1YvTXRhUitVWk1jZ1ZnR1M2Y2lr?=
 =?utf-8?B?WGc3NFo5NWd2RTN3Z2duV05yZ1lEdXY5TUJEY0FsMmV2aEpFUEUxbHFTMERP?=
 =?utf-8?B?NXlFcjMrVExyTTNSTDRSR2F0dHQybThwN0lxSkhySW1teXVLU2oyV09sa3Na?=
 =?utf-8?B?RjFHMUt4Z0ZacldPL3VnRU9JOUt6Q2hYK0Z5Y1dVUHBmbnUzVVhSc2JyTHJU?=
 =?utf-8?B?NnFwaTVZY0srVGUxUzlzb3RJZ0xDNFhoS2UyUDhlTWdwNndUdUJnclYxY25s?=
 =?utf-8?B?NHkzN0dVanNoblZXTU9vdjJjaFIwem41Mk9zVEU2M0o3ODR1dUNYRFNzNHp1?=
 =?utf-8?B?MkNReGw5VFl1bThteHVCaUdFS0dtbFNWa2V0cjVleWlUQ2FCVGN5K3k3eGRz?=
 =?utf-8?B?UXllUTZkaVV2NGJEQmVsZVhlcXViRVhiZDM5SDBLNVdGSDlOOEE3dXRnRnFs?=
 =?utf-8?B?SWl5Z21vMVlxRmZDbmJVczNmekRBRGNUZHdMUnAvYUJXTllQL2FScXFWU1VM?=
 =?utf-8?B?SkRrSGx4WmdDbHhwVVpIUE1ZRUNmalNRMWs2UnFRemRzZzNuSUpCOFcyZlJ4?=
 =?utf-8?B?VFR5U0JzOVZtcHEwamNBcndBeWJJZTVhWnpaaXpUSHJyRFZCSnhDTWF4NVJW?=
 =?utf-8?B?NTlFbU9TODU0V2liYlQ1Rk9SelArMk5qNFZMZmdQblgzdW1DTUlLcDV5Y1hJ?=
 =?utf-8?B?WGtuWVRjTXJiSzFoVERDcjA4cXlJTGF1ZnErVnB3ekdoam1FTE9sMHNjNGYr?=
 =?utf-8?B?Q0pVdDhUS20wSHcvTCtMeTVaS3JWd3NZZGdnczJ0OG9FKzQwQnpRNDFZdHV0?=
 =?utf-8?B?Y1Rlb1VyM3M3QmlJbG41K2ZBcUVzbUo3bjdKZGoxd3BjZS9NWWxwRTIvdnFE?=
 =?utf-8?B?aXp2SjVuQ1h1RjJOUCtxWnVzUndySkZsUnhtZ1E4RWRRSTgzWlhWM2kwNGEz?=
 =?utf-8?B?a2JyVlY2SzJ5VU05QXEvL3BtL3hKOFArbXhTQS82QStqUUxGdk45cTdLemh0?=
 =?utf-8?B?OHlQM0tLV3U4b04vdWZwdzd4RUxGdFh6OTV0MC95eEVQQWhVR0NPMVYvNjZ5?=
 =?utf-8?B?Z0hHZHNHV05kMlVmRFhtbjNJYTRDejlKUHNVQ2NOczNkRDQ2UVlhQlJTMWpL?=
 =?utf-8?B?OGdVMTdaWk1LeHk5MjJUa3BoTVZ0bzVLVmdOaTlFeWh5TzFNTHI3aThRblVX?=
 =?utf-8?B?N0swOUNpdGRWNjdoY3YxK01VaEdoZ1RCSHM4WEdNeXQ5YVJkTUI3YVVqV3Uz?=
 =?utf-8?B?Vkd1dGR0VFZhbGgwcG81eGdzS0FydFJUOGZRSytsdjh5Nm43K2MwL09OcCtq?=
 =?utf-8?B?anZyMzFPQVBEV1NndldzTnR6R2dSVjg1SHczR1gySjRYZFRzTlZCanRpdldH?=
 =?utf-8?B?aDU3dUdPRVY2UnBFQjczU1ZWR3NBNW96dnY2ZFVhTFcwc1ViMUxpWGsxMXlP?=
 =?utf-8?B?cW9MQlIwMWxrMmN1L2NKeUNxOGs5T1ZhaXJVS0J4dU5FT0dOdHVWTEUxbm43?=
 =?utf-8?B?U25YNGxudTdIaGc0ZDBTVUJoZ0cvV1FqWFlQdkRReFlTdWJQQzgrOFowN1M5?=
 =?utf-8?B?TWJiWFRDTWJxV1FQVmQwOWVZMitCMjFpbzlpNW5pZUErM0xTOFA2T3ZNc1Fw?=
 =?utf-8?B?VHhoY3A4bUF2emlDYWFRSzFYVEgwZEJGZVltUGNXRHkyaERrNWpEQTMyOC91?=
 =?utf-8?B?aytlWmJvdEV2RThpN2h0a1ZNSHI3UFdNWlg2M1Ewc01TK1RHVTY4aGNER28w?=
 =?utf-8?B?SG5ZRUpiOVQwM0tubUU0Ty9tZE5Td3ZCVk5sblNCdHBVMGp2ZkZ3cFhNRGJH?=
 =?utf-8?B?VkRPbER3eUlLVFdSS1k1QjduaEtweFI1dUh1R0F2Vll4SmZOTzlkU0VSOU1j?=
 =?utf-8?B?OW1aRmpOK0ZjZ29UYldJYXlLZUFlZnBOS0pKVm5NTFNsNTlHemp3aHZVdmFW?=
 =?utf-8?B?Vm9xS0xJVUgxT3p1OFRsaTJaZDBXSUJjcGVIVVRYSTdmZStpdHpobjdQcU1Y?=
 =?utf-8?B?dVRldTBRT1FqdE1KZlZmSTh2S0hHaVpCZTFzVDRHUThIWFZjbGdvbFFSWjg1?=
 =?utf-8?Q?EEb9grL2PZKWrA5KPwyLK4E=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 13475f63-08ef-463b-21d3-08d9f2c70875
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3180.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2022 10:11:30.6912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jKj7pHMEcIimwYVj2nZb4WRW3wpATTmcAgyyvSPaJAiDV7CEQ4/cHUqCMtiZKb27KBvZ/9zHxJ25GaWM813sQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5346
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 17.02.2022 16:38, Eric Dumazet wrote:
> On Thu, Feb 17, 2022 at 6:05 AM Andrzej Hajda <andrzej.hajda@intel.com> wrote:
>> To improve readibility of ref_tracker printing following changes
>> have been performed:
>> - added display name for ref_tracker_dir,
>> - stack trace is printed indented, in the same printk call,
>> - total number of references is printed every time,
>> - print info about dropped references.
>>
>> Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
>> Reviewed-by: Chris Wilson <chris.p.wilson@intel.com>
>> ---
>>   include/linux/ref_tracker.h | 15 ++++++++++++---
>>   lib/ref_tracker.c           | 28 ++++++++++++++++++++++------
>>   2 files changed, 34 insertions(+), 9 deletions(-)
>>
>> diff --git a/include/linux/ref_tracker.h b/include/linux/ref_tracker.h
>> index b9c968a716483..090230e5b485d 100644
>> --- a/include/linux/ref_tracker.h
>> +++ b/include/linux/ref_tracker.h
>> @@ -15,18 +15,26 @@ struct ref_tracker_dir {
>>          refcount_t              untracked;
>>          struct list_head        list; /* List of active trackers */
>>          struct list_head        quarantine; /* List of dead trackers */
>> +       char                    name[32];
>>   #endif
>>   };
>>
>>   #ifdef CONFIG_REF_TRACKER
>> -static inline void ref_tracker_dir_init(struct ref_tracker_dir *dir,
>> -                                       unsigned int quarantine_count)
>> +
>> +// Temporary allow two and three arguments, until consumers are converted
>> +#define ref_tracker_dir_init(_d, _q, args...) _ref_tracker_dir_init(_d, _q, ##args, #_d)
>> +#define _ref_tracker_dir_init(_d, _q, _n, ...) __ref_tracker_dir_init(_d, _q, _n)
>> +
>> +static inline void __ref_tracker_dir_init(struct ref_tracker_dir *dir,
>> +                                       unsigned int quarantine_count,
>> +                                       const char *name)
>>   {
>>          INIT_LIST_HEAD(&dir->list);
>>          INIT_LIST_HEAD(&dir->quarantine);
>>          spin_lock_init(&dir->lock);
>>          dir->quarantine_avail = quarantine_count;
>>          refcount_set(&dir->untracked, 1);
>> +       strlcpy(dir->name, name, sizeof(dir->name));
>>          stack_depot_init();
>>   }
>>
>> @@ -47,7 +55,8 @@ int ref_tracker_free(struct ref_tracker_dir *dir,
>>   #else /* CONFIG_REF_TRACKER */
>>
>>   static inline void ref_tracker_dir_init(struct ref_tracker_dir *dir,
>> -                                       unsigned int quarantine_count)
>> +                                       unsigned int quarantine_count,
>> +                                       ...)
>>   {
>>   }
>>
>> diff --git a/lib/ref_tracker.c b/lib/ref_tracker.c
>> index 0e9c7d2828ccb..943cff08110e3 100644
>> --- a/lib/ref_tracker.c
>> +++ b/lib/ref_tracker.c
>> @@ -1,4 +1,7 @@
>>   // SPDX-License-Identifier: GPL-2.0-or-later
>> +
>> +#define pr_fmt(fmt) "ref_tracker: " fmt
>> +
>>   #include <linux/export.h>
>>   #include <linux/list_sort.h>
>>   #include <linux/ref_tracker.h>
>> @@ -7,6 +10,7 @@
>>   #include <linux/stackdepot.h>
>>
>>   #define REF_TRACKER_STACK_ENTRIES 16
>> +#define STACK_BUF_SIZE 1024
>
>>   struct ref_tracker {
>>          struct list_head        head;   /* anchor into dir->list or dir->quarantine */
>> @@ -26,31 +30,43 @@ static int ref_tracker_cmp(void *priv, const struct list_head *a, const struct l
>>   void __ref_tracker_dir_print(struct ref_tracker_dir *dir,
>>                             unsigned int display_limit)
>>   {
>> -       unsigned int i = 0, count = 0;
>> +       unsigned int i = 0, count = 0, total = 0;
>>          struct ref_tracker *tracker;
>>          depot_stack_handle_t stack;
>> +       char *sbuf;
>>
>>          lockdep_assert_held(&dir->lock);
>>
>>          if (list_empty(&dir->list))
>>                  return;
>>
>> +       sbuf = kmalloc(STACK_BUF_SIZE, GFP_NOWAIT);
>> +
>> +       list_for_each_entry(tracker, &dir->list, head)
>> +               ++total;
> Another iteration over a potential long list.
>
> You can count the @skipped number in the following iteration just fine.

Skipped is already in 'count', but you are right with double looping> I 
can count total in the same loop,
just forgot to merge loops during code evolution.
Will be fixed.

Regards
Andrzej

> int skipped = 0;
>
>> +
>>          list_sort(NULL, &dir->list, ref_tracker_cmp);
>>
>>          list_for_each_entry(tracker, &dir->list, head) {
>> -               if (i++ >= display_limit)
>> -                       break;
>>                  if (!count++)
>>                          stack = tracker->alloc_stack_handle;
>>                  if (stack == tracker->alloc_stack_handle &&
>>                      !list_is_last(&tracker->head, &dir->list))
>>                          continue;
>> +               if (i++ >= display_limit)
>                              skipped++;
>> +                       continue;
>>
>> -               pr_err("leaked %d references.\n", count);
>> -               if (stack)
>> -                       stack_depot_print(stack);
>> +               if (sbuf && !stack_depot_snprint(stack, sbuf, STACK_BUF_SIZE, 4))
>> +                       sbuf[0] = 0;
>> +               pr_err("%s@%pK has %d/%d users at\n%s\n",
>> +                      dir->name, dir, count, total, sbuf);
>>                  count = 0;
>>          }
>> +       if (i > display_limit)
>> +               pr_err("%s@%pK skipped %d/%d reports with %d unique stacks.\n",
>> +                      dir->name, dir, count, total, i - display_limit);
>> +
>> +       kfree(sbuf);
>>   }
>>   EXPORT_SYMBOL(__ref_tracker_dir_print);
>>
>> --
>> 2.25.1
>>

