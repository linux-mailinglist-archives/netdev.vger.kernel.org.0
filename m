Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EAE7699998
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 17:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbjBPQOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 11:14:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjBPQOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 11:14:17 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F53B189;
        Thu, 16 Feb 2023 08:14:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676564053; x=1708100053;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tE6PdIcuKACghtwQfyMAzmGcT3BCn5M/IIEYggmqBic=;
  b=EQ8wzxY5FXkKJfEeOComRfwEg3yCAjE+xP4nLIcD8S5h1cyjctI5pooY
   gMxL55QpgejyQUiKhDoC611F4+1JPs8qFG/XnajarWXBnkV7iYgObvuay
   hVM1uuKF7kAxqt+D/9qg9G+0GgO8k+MaRuh86IYPw+o40CqASkNKi+JvW
   15xLCtvEDHcA3AS22ee4tob1+TTLsfRxCi1actSdbu4vEU+evSOr14kqN
   zxP0SoofYCGLD0QjDeSOuV+JYUGFZPCrOY1zS/TWYJLXo19cvHCV8S6k9
   5qjT5X5/iR9T42XOItsQBnzzBwBFXMGkd3IrhPXvDYm7/j2LsDpaCVxMI
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="394196686"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="394196686"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 07:44:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="779385181"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="779385181"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 16 Feb 2023 07:44:39 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 07:44:39 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 07:44:39 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 16 Feb 2023 07:44:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sh2TfsAdB1lTMqiYZXSrHC3qSkFd4cZ0aZnPYpzID35RZnmUS7Zzd+ImYykwz86ELUBbFsLEnV3+kde7BWSnRzKzcMmrA0/U3QnPPuYJ/m7rEVpIKWKUVDSshGRJ2KCAuuxShiv3C5clLscb2DWYKfTOUc0XkekUdkZQvDUKwIvAF9CmIKoHWzmhMPWLEnytju1qKurx/UCvAHM3+3muei76v7IKA3kUZhodGR1Yq1YijpVPGooDLj/YRYjzlORdUyvkVJP89Z5TtFwUpi3tmLbpsNlAbMQ6z9glK9jfxxoSgYWrrK3o1HeBjI6NuDYTbR7vSxR29y5mSORK0Et/kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZgSVWejAng6NyJFHEm6bIyiZ7GfzfJD9y3CtPy3LAbA=;
 b=ZxqKzHfbVB50PBQyIlFW0twQcXGVD0myobBy7dD4fZzq8kGPvzA1N37oybOE8af1BSoqDmTxiuW8P5fRuON7Jsf2o1siLMcgSy7dVHWXMqALUKeDkdKbyAjs+055ygTulCDExFRmchVRZlvzVOvA80riT4EHem33oi2Ny+8BF2wp4nn9nq0ygtv30OrzP2TddGU+Hbv+1T3Ho8Q7b2lggCTwOwrSJf6d69mePXCWnyBBGCk/pSrE1n984uf169JI6N7rKFJ79dxF8lTa5b6cfvAH9PfEC2me4mrzgg2n0y8kwH4by0XvemaHM56rwExWBROtua0twQ87Z+Rkf/9irA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by BL1PR11MB5255.namprd11.prod.outlook.com (2603:10b6:208:31a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.27; Thu, 16 Feb
 2023 15:44:34 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.026; Thu, 16 Feb 2023
 15:44:34 +0000
Message-ID: <a499a5df-e128-b75f-50d0-69a868b18a71@intel.com>
Date:   Thu, 16 Feb 2023 16:43:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [xdp-hints] Re: [Intel-wired-lan] [PATCH bpf-next V1] igc: enable
 and fix RX hash usage by netstack
Content-Language: en-US
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
CC:     Paul Menzel <pmenzel@molgen.mpg.de>, <brouer@redhat.com>,
        <bpf@vger.kernel.org>, <xdp-hints@xdp-project.net>,
        <martin.lau@kernel.org>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <ast@kernel.org>,
        "Stanislav Fomichev" <sdf@google.com>,
        <yoong.siang.song@intel.com>, <anthony.l.nguyen@intel.com>,
        <intel-wired-lan@lists.osuosl.org>
References: <167604167956.1726972.7266620647404438534.stgit@firesoul>
 <6a5ded96-2425-ff9b-c1b1-eca1c103164c@molgen.mpg.de>
 <b6143e67-a0f1-a238-f901-448b85281154@intel.com>
 <9a7a44a6-ec0c-e5e9-1c94-ccc0d1755560@redhat.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <9a7a44a6-ec0c-e5e9-1c94-ccc0d1755560@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FRYP281CA0001.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::11)
 To DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|BL1PR11MB5255:EE_
X-MS-Office365-Filtering-Correlation-Id: c2008fdb-ae5f-434b-be98-08db1034b36e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5q/jXjJi4M/qOAHiBdyVwwYRal/PTUQdbPg+UknBV6soTLh9C1WT5XiOHcu4nmkdlukSlNVjgV1QZ+CV04sdxH1kp+fI8TsqbvB7f6huR4q7qa+TNCHyMJSNOHpkHHXTrZYVqctJgvrfBKTNDVP4t4WXGRRaO4eId9kYqUaeu9pQIpy1D9SoQ7jmEIBJDx2CJqE7H4nKFISdzAf7vcMtnA97qw+UUPsRguE5aLp9l9rC8/QC5f8M2K6agdxLXn2bXW2qRgXdGS5Rk34hqKtFF9j3UfHPEZibeQodF2VoKS7sKfZ8Ju9zbpl1RvizOpegsP6JDzd4acXRq43GZZOlvwjEWlCUjAd77UHGmQQ1XbxVzNURGQ7mjSBx2ca1QzQ1/98nLBUWV1dhh33Sz0lpV+YUmYPEoNI5UHafWWs4Kav+MqraeHdcaXrGtrGHUCVhUNibwx4HU5AsswQ+8Eg3auU9ytph5iMlZFsuTknv4IfK45ET7JR3UGN+CA6usvvUwgARu4WMDbCBJLsn4eD0GnPNLyLZt5TpEuFjIRbRIB5Sg175tFDLDokxagicRACYY0NSUk4YOqCzUuiCzBjPdqTlcMp4RAQcLBLCrOy0MrAcYzT0HLnqqFovt0H6A/2fWSwsf6wXXTc2/f3ZIPXHo6uFV4Dia7hg/elcL6y28FhKc/lZZKx6hCwBzgW9SbZvPfCl0E2kJw7q0X9KES5aahVOu0eJk0By0yb/KJl74eG/V++eW9kMduA3HPCv6jYw04anKFMpK1sJ6w7DSsCCrw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(39860400002)(136003)(346002)(366004)(451199018)(82960400001)(966005)(86362001)(31696002)(38100700002)(6486002)(478600001)(6512007)(6506007)(36756003)(186003)(6666004)(2616005)(26005)(66476007)(4326008)(8676002)(66556008)(6916009)(66946007)(2906002)(5660300002)(8936002)(7416002)(41300700001)(31686004)(54906003)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eXJXNS8vVjdKYTg2aFRVZ3RRNEJIU0NKYmNTWVFUQnlOa2lVUjJqbXdWVUZR?=
 =?utf-8?B?eWJ0MWRvM3puazJjcVRQTEZ1M3RzZmM3a1gxMW9jQmphTGErSlBnZUdDL0Fi?=
 =?utf-8?B?cndwZ0pRVnlvYkRMNmQxVkFPMkNnaVlwelpsNkkyL1JwMm9lRXpuOFlRaEV3?=
 =?utf-8?B?V0VDdEJweTBXdHdpUnlwRGtNcUFRWkpqRUx1amJPaTNmeTdBTi94VW1UbjR4?=
 =?utf-8?B?Sm1pcFV2Smkrb2pxbHFRY0VQVmd6VlQwb3JqQUx6WDRKSnNxNzhHUXc5UEJx?=
 =?utf-8?B?Vnh5ZTNGTHI5QUFua0xuejlGajNTcURVWlFaSnVzd1dDaUxLSHpUdWZOMDNi?=
 =?utf-8?B?QWEzNlBtNlhLa1RuK2FWcGNqclU0a3RRZkFLckpQMlJtQnhaMVUwajk5MnRQ?=
 =?utf-8?B?dHJXbm5odkYyZVBqemZrb0NDQXJQMlBXMWJscEtIcWgyYy83dFN2elB0akIx?=
 =?utf-8?B?M0pYM1hpUk1MclVlTGdMNlZBV0pYNnVmbjIzQXhwY0pSUlViYm1OQ3RiZE45?=
 =?utf-8?B?eGJMSXRjZnhQQU5LVGtURWErMnVaYnlPRzc1V0IzUTdtSDRRSHFzZDdoWTg1?=
 =?utf-8?B?bnVxWTBWVWpyZkFzOVdja0VIWXp6Nkp6Nkovc1BKbkg3Y3g1aURmVkFoTDg2?=
 =?utf-8?B?SFZZU04wVnZqUStaRTlPZXdEL0hiQTdGRVZ1SlV0czYyYWJCdUo3d0hrUnJD?=
 =?utf-8?B?cUNwem8xckJ0RXp5anQ4dHFZMXpLdFd2aC9OWm14ZnplUUhRb2YrdGMwQWpv?=
 =?utf-8?B?L2VZaU5paVBoRnhad1lQWktrUTZzTHljYjJGWXdZd0F2VzAzTzJWeTBkNzM5?=
 =?utf-8?B?a3VkTS9RWXZic1pNdWoyMVA1Q0FKQTZwWUQ5K2R0K3NVY2ltYUhOUThTYjlp?=
 =?utf-8?B?akRNdWZaY01ET295bHUvUnlva1lJZ3FOQjJGM2lnZ1ZQdFk5M29vMGpZektv?=
 =?utf-8?B?dG5WVWVMZ2QwNmZwcDQ1NFlOKy9rbFVjc3pBZVUzY1Q4dy9CaUdCQlhUMGxn?=
 =?utf-8?B?Vjl5V0xmSUJiL3c0VW00aFYyK1lROEdvUTVFWHVNeVVscW1XTlI1OVQ0NGNT?=
 =?utf-8?B?ZTBiSDlkK0tmZlcrOW5vbkdLaWdFRGJrV0pEc21EWmhVcERyOCtkNkl2UEly?=
 =?utf-8?B?NWZZd29idlYxRXBELzJBWWFQNkJOV1lSWCs4UzRUMlM1ei9FekFsM3NyU0N6?=
 =?utf-8?B?QllPRjYvRlNBWEplRzQ5U05PL2huZk5oZUx5YUJNaStmY1JUWjA4UU5aNjNL?=
 =?utf-8?B?eW9PZlZ5dWVSU3V1OTg1YVFweGZRSW1ZR3VxV0JWOVlNOFJWWmFUWlp5dVYr?=
 =?utf-8?B?bHdvOVVkc3VJNHgxTzY2TCtxenE1cmNodUFWUC8rMzFzZlFnTWtBVkwzYVhM?=
 =?utf-8?B?MVh3eHBLNlR4azc0QTUvRytkdEE5Z1ZDOS9BeXVVUkdzTHpmbzBBTzVsanV2?=
 =?utf-8?B?dDBnbEw5b0NzRlF6cnd1aTRYT0pJVDJaNXBYOEFFV0FyMVR0RHJNZzl1aExh?=
 =?utf-8?B?eVJLK2NYbUl2eE1taWZzQncvS2JBeG5tVFB4b3JzNGpsclRuby93bThzVHcr?=
 =?utf-8?B?ZWxTV1ZlOExTbzc0TTJlWU8xVlI5b1J0S2FiSjMwM3gzYitEMGpTdzY4cGRk?=
 =?utf-8?B?M0ZiZE5nYk1rbGVSYzR6V01hM2o4b2NmaW5tbUFpT1NGYm54aW1paUJTODA0?=
 =?utf-8?B?Z0dBMVBHbVBKYnVMN1JVNlFVTjRYWk80Zm9qalZybjNBNFdmc00rTUxaM1Jm?=
 =?utf-8?B?QjZSTWFibUZzdnVaK3hjcW9ML1Q0WklLOTNQTFdGWXR2TFU4bHM3b1FLaXRx?=
 =?utf-8?B?MkQ3SnN3VURjWkF3YmxoS3I4SE5oRllTSzRPOGVRMXBHZGo0UFI1OGhqaWtW?=
 =?utf-8?B?eFcwQzR5Qm1pZlVST096ZGY2ZGpLOExwTUZ2aVEvOXhudkk5UFY5Yjl5d0tw?=
 =?utf-8?B?bnd1OVBrVFhTVkQxYk55dElvTmRwYmtFNXJQdEhGWmVEaXpKS1VsZjIxOCt0?=
 =?utf-8?B?b3VzUE9sVXRSR0ZBMDZqeGNxY2F1OVF0S2pmZmJQN284aWJkaExIc3BQYVdK?=
 =?utf-8?B?TUtGU2ZtdnMzbEo2TmJ3TTFXbyszbjVKcnlzeWVOT3ZlSlN6UkFYRkMyaEVQ?=
 =?utf-8?B?VjQvZGdxN1RKU2FtajJ4Y3BvYUN6eDFFMGpPc2Jad0NpVmV1VGRkTGFlMVZa?=
 =?utf-8?Q?vC0wuogzLoQt6puNIiyzpTA=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c2008fdb-ae5f-434b-be98-08db1034b36e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 15:44:33.9499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VPxw6tfD1+SV82r7jE8JPkaPKvsbYcm14Lnr1xl0Rdd2k39V+QxPCztaFdxMbdzgfwb/YgzajOvT2FIOQy6pE/wKUxnn2cP0vSLVGzuh/MI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5255
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

From: Jesper Dangaard Brouer <jbrouer@redhat.com>
Date: Thu, 16 Feb 2023 16:17:46 +0100

> 
> On 14/02/2023 16.13, Alexander Lobakin wrote:
>> From: Paul Menzel <pmenzel@molgen.mpg.de>
>> Date: Tue, 14 Feb 2023 16:00:52 +0100
>>>
>>> Am 10.02.23 um 16:07 schrieb Jesper Dangaard Brouer:
>>>> When function igc_rx_hash() was introduced in v4.20 via commit
>>>> 0507ef8a0372
>>>> ("igc: Add transmit and receive fastpath and interrupt handlers"), the
>>>> hardware wasn't configured to provide RSS hash, thus it made sense
>>>> to not
>>>> enable net_device NETIF_F_RXHASH feature bit.
>>>>
> [...]
>>>
>>>> hash value doesn't include UDP port numbers. Not being
>>>> PKT_HASH_TYPE_L4, have
>>>> the effect that netstack will do a software based hash calc calling
>>>> into
>>>> flow_dissect, but only when code calls skb_get_hash(), which doesn't
>>>> necessary happen for local delivery.
>>>
>>> Excuse my ignorance, but is that bug visible in practice by users
>>> (performance?) or is that fix needed for future work?
>>
>> Hash calculation always happens when RPS or RFS is enabled. So having no
>> hash in skb before hitting the netstack slows down their performance.
>> Also, no hash in skb passed from the driver results in worse NAPI bucket
>> distribution when there are more traffic flows than Rx queues / CPUs.
>> + Netfilter needs hashes on some configurations.
>>
> 
> Thanks Olek for explaining that.

<O

> 
> My perf measurements show that the expensive part is that netstack will
> call the flow_dissector code, when the hardware RX-hash is missing.

Well, not always, but right, the skb_get_hash() family is used widely
across the netstack, so it's highly recommended to have hardware hash
filled in skbs, same as with checksums, to avoid wasting CPU on
computing them in software.
And the Flow Dissector is expensive by its nature, a bunch faster when
you attach a BPF prog to it, but still (not that I support P4, I don't
at all).

> 
>>>
>>>> Fixes: 2121c2712f82 ("igc: Add multiple receive queues control
>>>> supporting")
>>>> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>>
>> [...]
>>
>> Nice to see that you also care about (not) using short types on the
>> stack :)
> 
> As can be seen by godbolt.org exploration[0] I have done, the stack
> isn't used for storing the values.
> 
>  [0]
> https://github.com/xdp-project/xdp-project/tree/master/areas/hints/godbolt/
> 
> I have created three files[2] with C-code that can be compiled via
> https://godbolt.org/.  The C-code contains a comment with the ASM code
> that was generated with -02 with compiler x86-64 gcc 12.2.
> 
> The first file[01] corresponds to this patch.
> 
>  [01]
> https://github.com/xdp-project/xdp-project/blob/master/areas/hints/godbolt/igc_godbolt01.c
>  [G01] https://godbolt.org/z/j79M9aTsn
> 
> The second file igc_godbolt02.c [02] have changes in [diff02]
> 
>  [02]
> https://github.com/xdp-project/xdp-project/blob/master/areas/hints/godbolt/igc_godbolt02.c
>  [G02] https://godbolt.org/z/sErqe4qd5
>  [diff02] https://github.com/xdp-project/xdp-project/commit/1f3488a932767
> 
> The third file igc_godbolt03.c [03] have changes in [diff03]
> 
>  [03]
> https://github.com/xdp-project/xdp-project/blob/master/areas/hints/godbolt/igc_godbolt03.c
>  [G03] https://godbolt.org/z/5K3vE1Wsv
>  [diff03] https://github.com/xdp-project/xdp-project/commit/aa9298f68705
> 
> Summary, the only thing we can save is replacing some movzx
> (zero-extend) with mov instructions.

Good stuff, thanks! When I call to not use short types on the stack, the
only thing I care about is the resulting object code, not simple "just
don't use it, I said so". So when a developer inspects the results from
using one or another type, he's free in picking whatever he wants if it
doesn't hurt optimization.

[...]

Olek
