Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D282A699BBC
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 19:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbjBPSBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 13:01:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbjBPSBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 13:01:46 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 673433A87D
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 10:01:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676570504; x=1708106504;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fMg1vwA0l9pPcFuFmR30YxnMCzAvB/mUdMRe+S+cy0Y=;
  b=fCysPCpbyRffb77hhTB71QVsMw8dnPXabeU/kH59alc/wvpRmyRv83GN
   VN5dbBo1XRyiW9sQdP57a2eFXPoe6fhAp+N6WJnaPdtDWRysRAyzqrZM/
   7o0Vsctq7fmbQxXWVb3UtYds58QV3P64F5I8GCtSVLoDVHmte7hu7XOgO
   MlNwHpQkyjLaF3HoTdivHRt1SRQn7WGBcUXi1Is8o9/Bsn4cRX1aIeBB9
   b18GWBISv/Vivbzw7oLTu68pgSpRZ0JTZJy7cOuDiwfwBFrGHfHtZrz8h
   aujdCIx/SROh8Np4oY1z2shNrpJkFR8pUTpqxvVqFVYMTB4HnpXJUS3p3
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="312152976"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="312152976"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 10:01:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="663561861"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="663561861"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 16 Feb 2023 10:01:05 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 10:01:04 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 10:01:04 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 10:01:04 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.46) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 16 Feb 2023 10:01:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mLOEXRNO1NwgLA5EZi4MdT3ArVtjJlFoh55NxMslE/i2DeL6S9OHakXysh9UwYcR6tNG2WMde9TJPtGzKEBlVxtJoeEODXUhM2GOty6u+kcNWAQLFkTZ2wzB4ePAez/JnVwiqdg4RDymayYI0FR6OJZQmuOU1myBTFMfQ4Xb10E16pcDUbFRmyCbQ9eCZUSoWOOMIl15a99+G8jdwvkvYGY5UQDNyPJ0PE9gagW4m6OlDWG6rf5pcwoIzEcxIDbOW2Al7zs0Q4NWavaD9MMZz+9Gbcez6zu/7zVeMzrd6x0RTDu3d6rMMNOI2sWUi3iGrZSeQGpuc3P7zQAQWccXIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JXxuWrLFod5fDUeFqPBXu8JmSgok6FkUAgmCkelkEgM=;
 b=jkwW8rIHMGKsePISLv2W4jnaZsgL/ALdSsdslM84xaHaZ6UI6g9BpVENIVd/Ddba7Fwqg0j6Vxp+SJOsGEELHzAliXVXq8Q1L2uexSA7NKIBkx3AuDwrrtc3Sok3KejnCyRIz+kcL+2kOe0fyg09dva0ia8IRTUnNOy/4F89bGCFxzbEO74HummsU9N5kz0iGSxH7YO+41K7i1OPhREofTEfAMqAcUo1KqI1j4c9QZwZnAUTxT7ClLMOJsXKgpq4D+V76kme4h+mI7m3uW4x9ZuEY2KjbLa90c/l9jhpoWQDx3PlvLEnwqxWlKRl1wv649ckmWYPFd6lj1oKFN8KXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by IA1PR11MB6442.namprd11.prod.outlook.com (2603:10b6:208:3a9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 18:01:02 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.026; Thu, 16 Feb 2023
 18:01:02 +0000
Message-ID: <151e4778-f4b2-d5ea-eb8e-cbb8d7b26f9b@intel.com>
Date:   Thu, 16 Feb 2023 18:59:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [net-next 1/9] net/mlx5e: Switch to using napi_build_skb()
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
References: <20230216000918.235103-1-saeed@kernel.org>
 <20230216000918.235103-2-saeed@kernel.org>
 <07a89ee6-2886-65b8-d2cb-ca154f1f1f4f@intel.com>
 <20230216095324.4fa4f6fb@kernel.org>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230216095324.4fa4f6fb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HE1PR05CA0165.eurprd05.prod.outlook.com
 (2603:10a6:3:f8::13) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|IA1PR11MB6442:EE_
X-MS-Office365-Filtering-Correlation-Id: 132a5c33-8c6c-406b-aaf2-08db1047c3eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ujp3WeXHjY+w3+5IFFj5TwhJeDQAkk1dCQucw8hzR69d9JlSwNhDndMgwe0grx6TMNRUl38eClixgRH2oeSSNBh7qQtM7bQo8R0IFyPkKpaZWnCJkPR/VdWRqaRVfaGfWoHGTvMW4OXqbpR1KbJ1WXqDLiKjfYylgAwITt880V9OF6eeeW0ujuRoQigcE5JDJuFlG2W/f7NwICsNsGPrPchJTe4AxdmkFDziltFPYQp/ZsF0tNWGPd/gJ01vQImVMJ5UQ4H7vFPuYIjKd/SIoL8PJAuONYJaDYYQLfqsJpuGmvWY1oz5bpwjqMJqwy3/H1zH/vAb5vfzc+Dih3DKb72MBNK35fiNCnOFsS55yt+zob4hs9WjL17BnAbkb/zC1qvY59xeCLC8kef6LlnCETcjcqtr8MSz9ujhucD203KuNeGCJfGiW+kMtuvX5T4ZqhPnM/xIem6UCSvXLVkZSBuQZeiR2RzpnNGBdgRrAQfn4MeNXhY6zSZnlllb9YR+y6+U3meM/eoTPBi0kkSZoD25uLt4/mDN2iDAhMml2mlODzXXPuMS266+A0YSHlZqTKDPE0mHgPvoIaxppT/bVj/A79x1+TOvKZdz40QcOhUhCCUwdW0T+MFzyptCwk+EipHMEqf3kAjWlsoj3885EwXn6HF7I+Q4aN8vh6QV+S1VcNLr6mUFO+bk+yV3QqGRYD8/7p80W11IVT2rwTlbe99zx2Rcz6JQ8ujwpxiZoNM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(396003)(39860400002)(366004)(376002)(136003)(451199018)(36756003)(38100700002)(8936002)(41300700001)(6486002)(478600001)(66476007)(66556008)(82960400001)(8676002)(4326008)(6916009)(5660300002)(186003)(26005)(6512007)(66946007)(6506007)(2906002)(6666004)(31686004)(83380400001)(54906003)(316002)(31696002)(2616005)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WE9NTXYwT05jcVNCQ0JLUVVFa1oxWlBtUTQ0UnVGOXZWSjAzMC9hOHAra0Js?=
 =?utf-8?B?ZjZoOWc4WHdJUXJhRnFXZlJnbUFkT0xDMkYvc1BmZmJGMHVUYU5ZVENjK1pD?=
 =?utf-8?B?clpHNlJ5R29rclZ6N2VLc0Z6QmJnSU9oYUkxOXlxMUdlZnZTWVR4b2tNNHJq?=
 =?utf-8?B?c1Zac05wU0FhU1E4Y3lyWU4zL1VQWGt2U1pJK2NHbDFoTlZwWVVNVS9xVDdK?=
 =?utf-8?B?MmF4YlVlMXBUdUNOVllsYm1teDNGaE1aZENlOWx0VWZtbUs4M0VPRnNXMVlN?=
 =?utf-8?B?V3YrYlZSeVJKaXNhNDRaZWlWZkVheTc3U2pPVjNvNzFRMStJakNsRmRiVHVQ?=
 =?utf-8?B?Uk10S0cvcHp3Z01KNUxEVHBZUndEdWVnV0FPcHZLblFRQWpFeC92TGptTURn?=
 =?utf-8?B?U1RxYk5WUTNRVFhndUYwK3NhemsxWGV5dlFYSjhkYmMyTmFMSWErdFhaWGlx?=
 =?utf-8?B?RWZjbkM0UndKZDhWMWNpeEtPK2RsbWIvcW9VTmM0ZmtRbXFRU1FyVGd4S2JN?=
 =?utf-8?B?UEIrSnp3SjN1K3hxRzFmRzhvQkpLaWxucXZGRlg0cDE5M2xhNThBRXhpVnhp?=
 =?utf-8?B?NElaQ3E5dFdKTFpueEtkVDViZ2wyckxkQi9YMTJEQWlMTjhRNEVzSTg3OUY3?=
 =?utf-8?B?ZW5mZFQ4S05lSmF6K1RZdVVzbUNlSklWaUFIK0ZvTmlmK0g4TGU4MEJlTW8z?=
 =?utf-8?B?ME1OMU9GV2lsa3k0eERQekJlNHN0YTN4bDdreTZXNlBDSCtXYVRXMkNZSVlP?=
 =?utf-8?B?RzNsek1PS2xZYUxwd1RwQndPV0t0YmFncUpzRlBrZllwcGtlMFkyK1cxMWhj?=
 =?utf-8?B?ajRnaTJOUWRNTURuYkpWRmQvVEFBSHRMYzcrVm5IM0FPS0N3RnZLK3ZJY21K?=
 =?utf-8?B?Wm9nTStnakQrUE9LMTJZekF4SzZYa09nMGUrbVdNQWZVYWZNUjRlZzRudXA3?=
 =?utf-8?B?M3pRYjg5M210VHMvTlpIM0drSndZb2VDYmIxL3FUbWU0Nm1BL0M2SFRveVpj?=
 =?utf-8?B?cm5nSWd1N3J2aDhGbCtFZWVQTUcycXM0cVBaOTJlR3RJUlYwd0RtOTRHdURh?=
 =?utf-8?B?Z2NGTlJTbWtSU1kxQmJNVDdOdVdQMmsyeTBZQ1Q1SndsdWVZOHR3Q093amQx?=
 =?utf-8?B?cGJxMmVPMWVWRzdsUGlrQncvQ0YzSDVlRGROdkErV1VMMG1jQ0FEZ3paM2Q1?=
 =?utf-8?B?eFNLWG92Y0ZwaEVqWXNWNGRrWVMrNnhHMVYyWm9ldlBaQWc1UlNsL0thTHpp?=
 =?utf-8?B?bHFXM2EzQk9Yd2ZRQUxEV3ZHL3l3eHc1dU12YmdFTEZ5ZkZMaEZMd0VsNExs?=
 =?utf-8?B?M1ZObThjSVovbjFScWtvQ2tvTEk2V2ZSNGZlZWZFTjF0T1Z6SklFQkE3Y1gz?=
 =?utf-8?B?RWVkdENzYmMzb0ZjSVRVSjNDRm4yeTdiWnl1SU5BUVJqY0ZrTDdWVExEREJa?=
 =?utf-8?B?eksrMStGRGlYNyt0WUFwa0QwUHB0QUFNSU03cThXRmxyRUNhT2VZaFBwNmt5?=
 =?utf-8?B?dUV2Y2gxYld5WXRmMHNIMFJWOEFlRXpIbzVHWTI3RkNmS1pHdGxMaUNDR3dF?=
 =?utf-8?B?UkJuKzROWWJOUmFsTXFzVVk2TDcvOTRnaWJ0eTBzWThrVG9TODJaU0VYU1Vo?=
 =?utf-8?B?ZmhaUU50dkIzVGVxdTR2c2ZVajRNM3ZXL1pmbjY0a0cydEluT2YvZVJhelJD?=
 =?utf-8?B?SklJNkZyUHdzbnJZaGRVTnN2dkMvVUo1QzdVZUFQOUtNTVNEdFhtOGw4YWN1?=
 =?utf-8?B?bGZJbWgvVWh2bWEydkJHd0xKWWp2VUoveDJjbWlUWi9kOVNIUzJJS2RkYjl2?=
 =?utf-8?B?eFVaTkNoVncvcW5KTDRTVFhXd1luOTlhV05ZQUVGeDA1N3psUUtobDF0ZEsz?=
 =?utf-8?B?elhmSXJaV3l3bjlwUURKOHd3c3paVGdseTU1WlZldDdrczY3aXltQXFadFNS?=
 =?utf-8?B?L1IzOWVPcnc0c21oWW83azBja1pQR3hQOHNsM3BUQUVlRU55Z2R5NVNEd2dZ?=
 =?utf-8?B?emxDcERTcHNiV205eVpmd1paMkRhaExXRlVraTBadFhRMEJuVWgxbG85Uzlk?=
 =?utf-8?B?WU5ZdWlLVWo1ZTJ4aFV3RnR3SUNhK09pTHkxdnQydi82NU5qcWpydXJGeFkv?=
 =?utf-8?B?WkJTaTFPc0xTKzhUSnlwT0IySjNzbXlMNU1wd0RYSGxabkpXR1RCRmlJQTNr?=
 =?utf-8?Q?+boC6slUQWFiaq7bSy4HdrY=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 132a5c33-8c6c-406b-aaf2-08db1047c3eb
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 18:01:02.1593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P8ptuiJUMtuNqBn1hmCqxXDjqBxzmZDzk9vDxYv2JEu8noGbJ+xhohb0wReyK53NGXaU+VcubcwCVk3iEk8EIKvTE2QPWX0sESsXqg9MPyI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6442
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Thu, 16 Feb 2023 09:53:24 -0800

> On Thu, 16 Feb 2023 18:26:19 +0100 Alexander Lobakin wrote:
>>> Before: 26.5 Gbits/sec
>>> After:  30.1 Gbits/sec (+13.6%)  
>>
>> +14%, gosh! Happy to see more and more vendors switching to it, someone
>> told me back then we have so fast RAM nowadays that it won't make any
>> sense to directly recycle kmem-cached objects. Maybe it's fast, but
>> seems like not *so* fast :D
> 
> Interestingly I had a similar patch in my tree when testing the skb_ext
> cache and enabling slow_gro kills this gain.
> 
> IOW without adding an skb_ext using napi_build_skb() gives me ~12%
> boost. If I start adding skb_ext (with the cache and perfect reuse) 
> I'm back to the baseline (26.5Gbps in this case).
> 
> But without using napi_build_skb() adding skb_ext (with the cache)
> doesn't change anything, skb_ext or not, I'll get 26.5Gbps.
> 
> Very finicky. Not sure why this happens. Perhaps napi_build_skb() 
> let's us fit under some CPU resource constraint and additional
> functionality knocks us back over the line?

Both skb and skb ext use kmem cache, maybe calling kmem cache related
functions like alloc/free touches some global objects (or even locks)
we'd like to avoid accessing on hotpath? I'm not deep into the kmem
cache, so might be saying something perfectly stupid here :D

Nevertheless, it's always fun to see how performance does some weird and
counter-intuitive moves sometimes (not speaking of why
CONFIG_DEBUG_FORCE_FUNCTION_ALIGN_64B exists).

Thanks,
Olek
