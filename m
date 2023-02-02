Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD5E0688892
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 21:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbjBBUwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 15:52:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjBBUwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 15:52:43 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3295D46A5
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 12:52:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675371161; x=1706907161;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Vk5WFXdcNRdRsqMgxPObuw8US2634yXHutHukZGhhSk=;
  b=OYDx5ZwqIzzpCOFAJl78QrctPSu5iuegYBlwbmEtwZIDCxMMmHAPd3TU
   BL4h+tCn6HiL12btJiB50nE0ogWS7OlvvpRZO1kCsrGrdMODh53cNHiZo
   0euP5OB1MfrPYE3h9wQuG7GDKRsR1ju8CZKMoXC6POW0+RoOVbDUE1AWC
   prHUwQIC9TJGxh9DiU2jNZFUTQOgcDS7Z5AInWKOBL524AmCn67JAXKsa
   e3kljlYZg3/7aPHO7KD1gJNOtLk4lJpdcjv+COCHaHDRMgYrNwnOSx8GW
   78dCCxy8wW16P6fE7I5KDM27eFudyOic7dej1s5ZLrThKty5QOMCh+oF7
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="308212802"
X-IronPort-AV: E=Sophos;i="5.97,268,1669104000"; 
   d="scan'208";a="308212802"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2023 12:52:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="994259452"
X-IronPort-AV: E=Sophos;i="5.97,268,1669104000"; 
   d="scan'208";a="994259452"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 02 Feb 2023 12:52:40 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 12:52:39 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 2 Feb 2023 12:52:39 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 2 Feb 2023 12:52:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JohdTpKZbrskDSxU0D4I3/ZBC+qdcb5Ey0xqgeweO1ttU0ixDrcnnaRz1YZF1fsusCMi0u/qC4HA4ftfkYliFCAAL1lp7G3IaeoeNO5G3lI6OpkE1MmJLzjtLJWc7n1AZdFFlmtpzV2hF6LDX9WvCvebdbIv96XBgvn7mvN1wZz/y6RfO5roS1h/iK/EmZnIcuBMREBgrd7dFnUEZbMao0GsankJR3JITyrvVCgyTpeN/s8EwtN+tcOkRZ2ih+fyVFJMa6V/oGXU0gHiXKjqIOWxh25T+DM1iaprjeoZRaYUNfSuRq193KcpurcC9us9YkSNxCVfXUel9DIFGUPwKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2DXLGeJSd9jvfdDmw0EiRdImBkPKGt0IxU+rLrFYw+k=;
 b=bwiy8CgCUysW76ly+4HVLLHYVQXxTB4uixv8SFNFWQoLnzNr1etgaAUdXbMM4EfuiBeHuopbs/aSnvOBNJGWzxDJ7gTjr9JHwOEj8HneaQ5vMADSQ3jZ7eRds0dtEqFveddQZJ+163aTuGtrzonxTzkgtHUhFXzv88JDan8YpLMKq22xcOWWIk1B+HTf1ZXZgtpJBPuJOU2HfQWaoVIQZZneglFbSTcD27aZyO7IxhrXHu6lUX+SybCguHVvPl9xP9URexeJ/9Kh4lQfZbdzjZwfy58WEutQKfvxA2anTzJspaPhraLWSYP1VQ5c9vuZLePs4p+Kp/NcfwoX4yNgzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DS0PR11MB6349.namprd11.prod.outlook.com (2603:10b6:8:ce::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Thu, 2 Feb
 2023 20:52:37 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%6]) with mapi id 15.20.6064.025; Thu, 2 Feb 2023
 20:52:37 +0000
Message-ID: <c611562b-f767-ceed-3227-82c89ff4cc52@intel.com>
Date:   Thu, 2 Feb 2023 12:52:34 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: PTP vclock: BUG: scheduling while atomic
Content-Language: en-US
To:     Miroslav Lichvar <mlichvar@redhat.com>,
        =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
CC:     <netdev@vger.kernel.org>, <richardcochran@gmail.com>,
        <yangbo.lu@nxp.com>, <gerhard@engleder-embedded.com>,
        <habetsm.xilinx@gmail.com>, <ecree.xilinx@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <alex.maftei@amd.com>
References: <69d0ff33-bd32-6aa5-d36c-fbdc3c01337c@redhat.com>
 <Y9vly2QNCxl3d2QL@localhost>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <Y9vly2QNCxl3d2QL@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0146.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::31) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DS0PR11MB6349:EE_
X-MS-Office365-Filtering-Correlation-Id: 84a41b8f-4363-4b5f-daae-08db055f6ab9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e/W/VcSRbbyGoe5mCBnESqgKl2JKzdRzcKOityunTR03/9Ysrp4WHarrfiHwe49XEtdFbycFzdFmLS2meEgJXd6/OmgWRiJIlwJ7zVLT6e9wPec+L6M2TTJUNfvni/gqSf3JYG4T7L7ahbF9dXE6ZA/WYAmCxnLccGXSjt/73Ucr+nHupHMs24KT3vByrQaPixio7ovnlL4J8NTtqVyXU3PMvf4hhAmGR6XfKZTAyw9+ZyhMw0XnVThyuymWGkBv2rTFk0wB157a3JCAYeziJFCPPWq+VrTHItss0spyHw0RTOJuCDwRxIXj52FOxxIq/66r/LW7wVIsy1YXkS7KSrZPFwJ8prcpcuACBt8HdZLI2f77j7+Hvc9CLYMmKKc/g+lYH8XzTRtG5HJ+tqWCdAI/dnUdiZFxDN395GxiWOwnsQiG7Ow22tdwopVHGn6U+868u0zp3bZ2dRzS/mRxGRo17etudGR6Uz0jacySnTdWXhImHF1IQ0nIn92/l5AOyrGwentkUcCTMWdrnqbun+PUUPjaWV9SPvYX5kC2ubU+a9jaA0sobAgf221Ps6P96goCaGws09SWgQMF1hJzZqM6rjcD+mnk55Ktf8TK6xBQXhIw2s3+17xkasDN8TwWEq3zAeveE8/oxID9PEUFeRDDoAJgqAabdczlUPEuV9zqo1N+StajikvBSiHyyTcknx+phnaMzXrCjZB9QOaCWMOS+VnH0Bq9v12hG7SXruywu3mttjqvMrGo5jv5L+uvYHAXcSbhqwi/VgLw5lsGkS+R/ya+nltE/HuEmW8MDEYE2u/Um/leGIBFsEyTkxx7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(136003)(366004)(39860400002)(396003)(451199018)(31686004)(186003)(53546011)(26005)(6512007)(83380400001)(66946007)(6506007)(31696002)(38100700002)(36756003)(86362001)(5660300002)(8936002)(41300700001)(966005)(4326008)(110136005)(316002)(6666004)(66556008)(66476007)(2616005)(8676002)(7416002)(82960400001)(478600001)(2906002)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?THhqemtTam10MzR5bmV3VXBxL1YvZDdUTkNOQ05WdVBoU1pPRjB3Qmo2TzZt?=
 =?utf-8?B?SmJLWEk2QzlsQlU5WHZTT3NvN0kzRENmdC9WczRTWmNBc3RMY05xNGRnazlD?=
 =?utf-8?B?Y0dhL2JFdjlJYWpyQ3lUbFc0bTRKcXNEWFlBdUIxb0hWY0VzbWNTSEZoNDdM?=
 =?utf-8?B?L0xMUjdvaEEwR0FjRE5xNjhiZHYzdnFmay91cHZqL1RyanBMS3MwUzJwWTRh?=
 =?utf-8?B?U09ueW1EZGtEalArWjVUNmFTZmh6Q0hMaTRHYnNGQ0RnMENETGU4ZGwvVGpB?=
 =?utf-8?B?UjF6aHFDbzBlTzlZU2RLT1BueXArcnl2UlJ6TDBIeGRLR1BxQlZLQ2xkbmRp?=
 =?utf-8?B?ZDVPK251R21DUDgwZk4xaU5vUTBIeWZabHo5R1FWREpaQ3RianlSVUdCdXcx?=
 =?utf-8?B?dXhRUGwrSWNjU3JJTS8rY0xzcC9FSFNaUHFURTFQdVVxSHZIZTlBV2NNc3FQ?=
 =?utf-8?B?TTVNNXFCWUx0RElrWW9iNlNGKzdzTXdkQ0g5dUtWZjBDM09pYkVuTGtxWlcy?=
 =?utf-8?B?amEzWkpxOERTR2pNMGpNZVNYRUdYWlNIL3JLM0RJcjFWZ3hwa2grUzRCQ2JZ?=
 =?utf-8?B?d1R0K2RadWl2WjkvbFE0VEh1VmsvNGVLTnZMb2hueEQvdEIyYWkweVQ3S2RX?=
 =?utf-8?B?SWJseG1UM2F0TzJqUDBPekc0YVBaWmtiR0VEdGhpdXFyRTVNZkcwZm5yNXhP?=
 =?utf-8?B?cmhOVkNhcEpYQ2NHVmx1Qk9LQjZpVnRqdUtrUitQYlZYTFBGWFA2Q1l5VmpO?=
 =?utf-8?B?dS9PWDdnSkZwWXJCRkhMNEY0YjgyMjJRL2pQRktIV0JVaFlQU0lTT01VbURF?=
 =?utf-8?B?VnROUnRLc080UXJneFYvV2Z6TTBabGdJYjVuWEgxOW5Yb3VNb2pwdGpXWWg3?=
 =?utf-8?B?VnA1S2FsSmcwVFVKWTJjUXVjbzRLVFpUaDRJMXJGYVNqelhxRU01RHVRQnZC?=
 =?utf-8?B?VTlheUJHVlVwWXpDUzVyUi9ON28wODNwdzlRejRLQ2tOdWYyc25NcnhHTmV4?=
 =?utf-8?B?SUdYTWhQY3J5TVpYNWtZY0tQOFlVUmtSeno0Y0xwanB4d1hYRm9SclBCOFR3?=
 =?utf-8?B?MUpuZFBVbkp6Sy9WamlxZWxFU3hnZ3lGZ1pNanpRZ1dFbnFaTXJKVWJPQVo4?=
 =?utf-8?B?SHp4Ryt1eXZqbll0T0NBdVlQV3QvOEJzZzZRNkt4SzJHMjVEWHA0d084NEQz?=
 =?utf-8?B?SUd6WTVsb0JWYW0za0NDK25qcDU0YnJNejlTM2tudUhmcGdjcUNldUdFdUho?=
 =?utf-8?B?WDNyZFd6NURsQzc5MTBSdEpMRituYkt5ZjUwWUtGWWN1SFVCR1FMMFRBN0xs?=
 =?utf-8?B?Z2NoWkpyYnY2bWtmTkdiS0UzaTdvRUU2cUlmY3RPQnU2RnVZcmZIUk1aOWpE?=
 =?utf-8?B?aVJCS1FLQWhZdXI0dlFuRFBlTTVOMXdyMmRwc0x6cFZNazdXUUVnZU9IVHR5?=
 =?utf-8?B?Z0NzWjlDWkZoNGhVMUdkNGNZRzJkYWVPUDN0U3FuUG15Y2c4dXV5bnVRc2ZH?=
 =?utf-8?B?SmY3YXJtbHpxK1JBMlh5elg0OVg4WGpneFh2N0Z0THA1WnNtZlVZN2diYjNY?=
 =?utf-8?B?dTNYR0x0Y0lRSWpwTEdDUlFZT2lrT3lMYnZwdm9FTy9hQXB6b295T1ltQStP?=
 =?utf-8?B?WWYrL3FyTGZPMURwUVlSaGIwTktiZ3VpZjNXK05Ycmx2UUVoMlVKZ08wdG9s?=
 =?utf-8?B?L0cxMjJGQ2oycHkwTG81bFVKMnN5SzgwTzMvSSszMlRMU3BzQzJrQnBIdVdJ?=
 =?utf-8?B?K2hPTDZlT3B5WUhTbkt4dUlpdUdxQnZWK1drZmswZCtWT29WaDg5cC9TblFp?=
 =?utf-8?B?eWh5YU5qNTYwR0FVMWxkdzdLNXFnbmNVWDRhYVlvSWNNeTFHRVZVb0YybDda?=
 =?utf-8?B?bHBna3MxNDJSUXRSTmttUFBCOFBva0JOOUwrRlNTVlRBMVhNQlVyZTU2ZVNa?=
 =?utf-8?B?dzRNOUJVK3pxYWFCOThNNGdoRVFjME9NSzRHdzg1N3EvVVhlcVd6eVJlL3cw?=
 =?utf-8?B?MUlrcXYva2IvSmdyNXJvVWlweHhCOGJ3dytxTEtJa3pwaWo2SzNDMWhacHFU?=
 =?utf-8?B?RTNXYmVKallKSnI2ZnUzWlNRQ1BIV1hJZG1VWnVZWjB6ekxzZHMxUDhzNStr?=
 =?utf-8?B?SGxCcVBzdWtxcUhpNGVQbVVUR1R2U1ZwWmN4MGVYSWNNblhWUS85OU4zR3pQ?=
 =?utf-8?B?UkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 84a41b8f-4363-4b5f-daae-08db055f6ab9
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 20:52:37.6444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xC0kayaTB8ua7T7poX9n2iCzZMzE0EuBARgoOU0PMRqqeon7xoG0mPsVi1mUpB7TVyY12kuWmHprHt+b5o06t8fCByyuQX2EGblftBROprI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6349
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/2/2023 8:33 AM, Miroslav Lichvar wrote:
> On Thu, Feb 02, 2023 at 05:02:07PM +0100, Íñigo Huguet wrote:
>> Our QA team was testing PTP vclocks, and they've found this error with sfc NIC/driver:
>>   BUG: scheduling while atomic: ptp5/25223/0x00000002
>>
>> The reason seems to be that vclocks disable interrupts with `spin_lock_irqsave` in
>> `ptp_vclock_gettime`, and then read the timecounter, which in turns ends calling to
>> the driver's `gettime64` callback.
> 
> The same issue was observed with the ice driver:
> https://lists.osuosl.org/pipermail/intel-wired-lan/Week-of-Mon-20221107/030633.html
> 
> I tried to fix it generally in the vclock support, but was not
> successful. There was a hint it would be fixed in the driver. I'm not
> sure what is the best approach here.
> 

This slipped through the cracks. The root cause (for ice) is that the
.gettime callback might sleep while waiting for the HW semaphore registers.

We had a change that fixed this (though we had done it for other
reasons) by simply not blocking gettime access with the semaphore, but
Richard didn't like this approach and NAK'd the patch on netdev:

https://lore.kernel.org/intel-wired-lan/877d0yt0ns.fsf@intel.com/

Alternatives are challenging here as the semaphore is used across
multiple PFs which makes using a spinlock difficult, as the PFs don't
share any references.

We could switch the part that does usleep to udelay instead, so we
wouldn't cause this scheduling bug... not sure if that has any other
side effects.

I'm not sure if there's another way to drop the semaphore and assuage
concerns over correctness. We need to read the time registers and its
possible another thread (or in principle another PF) is modifying the
time. We only expose a single PTP clock device, but all PFs can access
the time for the purpose of caching value used for extending 40bit
timestamps.
