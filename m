Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99B3B69D0C8
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 16:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbjBTPks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 10:40:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbjBTPkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 10:40:47 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A0FA1EBE7;
        Mon, 20 Feb 2023 07:40:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676907646; x=1708443646;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=b/TGW+8fHu5msJjFt5uAXIR/0Z/23AKJ5rSdCEje3Vs=;
  b=L/ZHHfXgHtWMMFKpPYq56SWcp4LRoo5wzQqooR1fvR/LrIwCVD9aKX+g
   JRn5WiENltvJIQd1CmTX019VNRHLPeDvj3p9iJB3kNBs6wU3itCKVt4x5
   4df9u1DV4cNc8mnW5PlejER6yE5YN2zRFywAGVwVgpIgQyhj7GKd/C+Gf
   l+okLYkRHnVOgkEbpnTFdtHFJCpJiBUVi0Sv85dA+0paxPK0n6d3odS+N
   tvcQMlBVwO3BkjPOMDjtf2R/g9UxE1OeDDi90OQJOop0cbt3n0lLllM/L
   t2bHe/JOlzvvhDWZxBbRtlMaSfR7TYh1HJhviqAroXzYFAjg4tLd6FQcf
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="330143067"
X-IronPort-AV: E=Sophos;i="5.97,312,1669104000"; 
   d="scan'208";a="330143067"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2023 07:40:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="664674045"
X-IronPort-AV: E=Sophos;i="5.97,312,1669104000"; 
   d="scan'208";a="664674045"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga007.jf.intel.com with ESMTP; 20 Feb 2023 07:40:44 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 20 Feb 2023 07:40:44 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 20 Feb 2023 07:40:44 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 20 Feb 2023 07:40:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DdQmy/Q9XGkl1LF9KcA272v0SFoKa/kfQS07+JGffWPZMdKuflAiThWJ22+hmdQsStQV2Br8pgzUgyzU+mZzT7wJrmUgxZF6jSmugTqaEyroo0ll/gyy/+KYSAtmW+N5Tqi8laYSd+LHAOZ+pfFDqWpb/085J/cla4BBWht3FJlerVvK5+hVh5h5AGSkuG10xhTIPOGq8Xt8vUImOVFU5dl+dCkrNN6uk4eD6plzh+J+OgCIh9B65amnAvYOK0H2lUhYyEWrBQhljNehbJq1oePAq1kX6zUUCqwnaNcLzrGS9/7rM6ttUTaC0ylyxq/Ovw6bRyIUDUZ+EE7WK3ztPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dMagXdK457bw5xf8OGZ+zkR9BjDOHBL0UUik1pFjTT8=;
 b=FrRrt1BuG4ahfHJCLTbOu4B1NRD5lC06s25Yh9zLJHIXnsMmBTsWrmY2r4xC2eXRXmxzyMfzC1/lFIld/ZVBohmXwPp964YlJC/xXxd9bhJXXn4UBkPaftN+ifyHPDDLcSn3OkT7prV90HY8sqt5fIbGgkbTdQfYSapykBz3pVnbVEKueODdKUtOnpwPn+IrgYxJajP4JAedP92TJzIJFpM2EXTv/T6qDLGff49PRZnTU/Zfuk+l6dmM5x83jqlmEBjAUROi0dYIxesHZyfm7+9UVLdGmuY4hIA8bI9wrbbsxs7dsmlTvpCtkniqXYruYY0ya9K9PA/sXfPyV970ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by LV2PR11MB5973.namprd11.prod.outlook.com (2603:10b6:408:14e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.18; Mon, 20 Feb
 2023 15:40:39 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6111.019; Mon, 20 Feb 2023
 15:40:39 +0000
Message-ID: <74330cb7-bf54-6aa0-8a07-c9c557037a31@intel.com>
Date:   Mon, 20 Feb 2023 16:39:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH bpf-next V1] igc: enable and fix RX hash usage by netstack
Content-Language: en-US
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
CC:     <brouer@redhat.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, Stanislav Fomichev <sdf@google.com>,
        <martin.lau@kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <yoong.siang.song@intel.com>, <anthony.l.nguyen@intel.com>,
        <intel-wired-lan@lists.osuosl.org>, <xdp-hints@xdp-project.net>
References: <167604167956.1726972.7266620647404438534.stgit@firesoul>
 <af69e040-3884-aa73-1241-99207aa577b4@intel.com>
 <fe613404-9d1c-d816-404f-9af4526a42a3@redhat.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <fe613404-9d1c-d816-404f-9af4526a42a3@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0056.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::6) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|LV2PR11MB5973:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ea08a9a-ddd8-4b3d-065f-08db1358d11e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sE8mNocyrwvfob06Kf/p080hhy7UuoVx83NciCHNNE+Bwuc2AlGpknkyS10zdqkNraNPjN6RDMkkFcWuOcuoQ67/InGu4HSI9mkrpRylKJPItswzlny0NE652r3/iULK8eO+zf5XwteZaWc+ouz+0tA6wNMUe32zxyA8A60hQN0/CWakPXGqWHMESFyihHngEaSx2VLgn7CfefSb91ofYpMyQh01vtlQi71AHyFDDHWzifv/XqvUgnWc93pox+Q5TlVCa7B5i4Bx011sR12ucV9Nq+XHIJQq2BnEI7KapMWl4Z48ggPepm35A7v2wOIJYNY/aI2zKdbZvYW7TZ46GbdAkj0Wq9PE/fnbJ7vLOwrAWU50PDmlPuIRJXxobw8Bzt3/++l0AYZAm2327xEECxEFm4bBgS/Z4pLNcPsxfl5N4wfY6IWUb1kmZc78p0TnIVzwXPVXxGRkfMRA5FcddFo/lzyzKnQrlyaF/zI+1Qsk6AxpIOuqZh2BeQ3tWqfg2WzCDoTSuJWbaTX0pfbAyOMHWlRohWph0wo8gJor6mtW+InFVldhp5B6sJN0Q0CxFIWNab0cTfIxFay9i8IImFFJyzzWQ4SG/12i/jn07vZquVNuKjsXPDQL4ZYbnDuImPvBbCFt9naXbYbPalqJCNuTFSoAkCzRXYqd2fREkF9HUqzcQfB/f7jJj9/1UQ71lF3d5oC1ezzAb2NoYG2dkmCC3O9XzcCmWTmFRc8LACk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(376002)(136003)(346002)(396003)(366004)(451199018)(38100700002)(6666004)(2616005)(26005)(6506007)(186003)(6512007)(83380400001)(66946007)(66556008)(7416002)(66476007)(8936002)(6916009)(2906002)(4326008)(5660300002)(41300700001)(6486002)(316002)(31696002)(86362001)(82960400001)(478600001)(36756003)(8676002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Nm9VQ2FDdFl0eEVsS3gySjNFWFNZczVxbHZkSU0xa2lCVjIzSTlsY2NUY0ky?=
 =?utf-8?B?V0RXdldKdVNKeDhSWlZFM2FJdWhPeEhudE5EUWU2ckVNTW5pdFBoNG9ZNU84?=
 =?utf-8?B?RFJDaFN6R3dUQkM0VW1UQlpmSTNxaFc0WmVlMk41UVJJbGRGdEZzR2RWbktu?=
 =?utf-8?B?TzA1RS9rYWIyN21oSU56RjQ5S2o5c3U0VUZzQjJBYm1PQ0Yvdk8xRGY1L1d5?=
 =?utf-8?B?Q1BwZG9WTE1lLzF2VjhDL2VOU0M2ejdnTVN1MktpSU9WbDI5UXdpSGxZRElV?=
 =?utf-8?B?WGl3UWR5K1pJdlNtRElvVXl2YlBGdlFzdkg0bHN5d3ZjUTJBYzM2Rjl3UUFl?=
 =?utf-8?B?MmZKUzYzdlNYa0VCaXVmNHlYRFNPZzlPb0xta0FDc243WmxMTjBuUWhYZXF3?=
 =?utf-8?B?OUxSSkhpbmdlZ0lCbHprTElNMHJ1eGZrSU1EaFFUektwUDBXdVQwTXlxUFRL?=
 =?utf-8?B?TUpHK3liSVNFU1RyNGhNYjBQSUMvSHZDamV0T09BeWorSWFnQkhRZ0l1ZFpp?=
 =?utf-8?B?eDZRTWdUUDh0OTNLNWlVaVY3ZTZtNjBURkhMN1dKUDU0WmtwNzdBYTJhWDZ6?=
 =?utf-8?B?QmErS01LR3YzZ0pDMGg3MjQxRkxDcjQ5NW1vZ0xjaGtaeDZpN3ZERlVKK1pk?=
 =?utf-8?B?RXBhV3VHL0p1OTJIUWVPZHIyRnR3cHp6TFBNSUZ6aGg2b1RXakxrbnhicEhi?=
 =?utf-8?B?eWJxR3FxVDBlaHpVeWEzbXEwNEJqYUNNRjkvMG1ZazI3TDNqNmhqbXFKbEsz?=
 =?utf-8?B?MkRsRGgrcGVqa2htLzdsTGl5YnN5UDN0WThpK05WMXF0aE85QVRZTG9lYUhl?=
 =?utf-8?B?RTJrKzRqUVVySGtNeVJFdExHV0pDdW9sWHJiT1cxK25LZkdnSUJlN2cxMVhC?=
 =?utf-8?B?MzhwVUgwNUFiRml6RkY4SUI3bjZDcWp4ODAwZUZRN3dveWFPRnZndjNKOFU5?=
 =?utf-8?B?NjdyUmRHeUpWcE5wREwyYmR3R0JuOG85cHVkV1A5dXFOTTRxQkhnbUVTa2hD?=
 =?utf-8?B?ck8rODdERWtGa0VqL1Bhc2s3NXpOYlFneVZFVk01bmdWRmRIWnovSlU4enpp?=
 =?utf-8?B?bGEyZnJBNjdxMzB2WG1MRnhWWlI4MXV5SWpIQXJzVEZJZFVZbGhvUjFGWTdr?=
 =?utf-8?B?N1NFRTZabERnVEdkbFQ5NVo1Z1JOa0RoY3VYdStLeU1jK2lyM21QMUJLdUNR?=
 =?utf-8?B?aExjU1ptQUVvaDNCd3ZOWlFXenB4S0FVYWV5bnh1QkZnOElwMzhMY2MrTStZ?=
 =?utf-8?B?bzJobFd5RGFTdjExQTNpOEFleVJoWVdJTzg0SlUvRjFaVjAvTGdCTWJQVitT?=
 =?utf-8?B?aUVCRUZHZThBNlNCeUxWMGgzdVg4dERKYWcxSHZJcDh5eU0yWVNUaWQ4U3JB?=
 =?utf-8?B?b0pFMFlqQnlRMTlRTnRMUVJkTEZQMVZrUUxnWkJnYzc0dVJPYWp2ekpybFZY?=
 =?utf-8?B?UnNpelpxazBEa25OQXFmU1gwUG93TjZaT0RqeXpFWENKcHFhUXFMcUlCQlVO?=
 =?utf-8?B?Z2pNMjFoeG90bUpCTU5yajJOaDFlWDdQME9PRjRDT09lQzhZeUxHc1dMQUNx?=
 =?utf-8?B?K0d0M3JXYkFvV3NVT3lFa3RiRUkwL054aU84ajN2VXVIamFIN0lMOHlkWXQ5?=
 =?utf-8?B?WUlNbXZyTWhFQXdkSlFjdit3WU5tSGcySWpQNjBYVitvQkdOdUdzR2hwWGow?=
 =?utf-8?B?OVlTeUwwOFQvOGFUS0VHcnNabDRWN29jZTlCeU5JZGxiUW5sVmhteks1THUz?=
 =?utf-8?B?UXBHSjYyaWlZanFmTnN1azdxeENpbjBPOHNsYVdFck5iNFhHTWNYbmxlcGdR?=
 =?utf-8?B?eEUrb0lCLzE1UWo3SjRLOVRSSmN0aEc5NjNVVng3T05ZWUpJVElGTkhOVUhE?=
 =?utf-8?B?RTZzNmRNcHBaUVh2aXJtbWcwOFBFUVV5S2dLVmVFZkRuUDhBSnpsOXk2cUJ2?=
 =?utf-8?B?cDg5QjIxT2MyeTRpRWJaVDByWXJ1OGcxYWFoT3NSMkZqQzlEL3Uvck9BRXVI?=
 =?utf-8?B?dzVoSCs5ZFJmME0rSmpGUGRzSnFGeDZXY2tyNTZmRXB1VE5uZXRQS3BFeGhl?=
 =?utf-8?B?bFcxdkN0Y3MvTWxlY0tzTGQvRlNkTzhZTUtSRUhJMWd1TUY4bTFpeURHOC8w?=
 =?utf-8?B?dzJYd0pOUkVvMWRDV2F4Y1Mrdyt5aEFUR1ZsVTFNZHQrbkN2UmhGem9aK000?=
 =?utf-8?Q?ZSn8TRPaRbA59FM0v2tyJ7Y=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ea08a9a-ddd8-4b3d-065f-08db1358d11e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 15:40:39.2793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ac3jVxL/J5w2ltsziD4Yvx5zNaatLk1NhYwbdLaCm/VWgUlwCkKUhGPJqtBwWH2DUKPT03qAQThVREzsze8cN8tNWHp4fnHfqZPtvUPpePQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB5973
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

From: Jesper Dangaard Brouer <jbrouer@redhat.com>
Date: Thu, 16 Feb 2023 17:46:53 +0100

> 
> On 14/02/2023 14.21, Alexander Lobakin wrote:
>> From: Jesper Dangaard Brouer <brouer@redhat.com>
>> Date: Fri, 10 Feb 2023 16:07:59 +0100
>>
>>> When function igc_rx_hash() was introduced in v4.20 via commit
>>> 0507ef8a0372
>>> ("igc: Add transmit and receive fastpath and interrupt handlers"), the
>>> hardware wasn't configured to provide RSS hash, thus it made sense to
>>> not
>>> enable net_device NETIF_F_RXHASH feature bit.
>>
>> [...]
>>
>>> @@ -311,6 +311,58 @@ extern char igc_driver_name[];
>>>   #define IGC_MRQC_RSS_FIELD_IPV4_UDP    0x00400000
>>>   #define IGC_MRQC_RSS_FIELD_IPV6_UDP    0x00800000
>>>   +/* RX-desc Write-Back format RSS Type's */
>>> +enum igc_rss_type_num {
>>> +    IGC_RSS_TYPE_NO_HASH        = 0,
>>> +    IGC_RSS_TYPE_HASH_TCP_IPV4    = 1,
>>> +    IGC_RSS_TYPE_HASH_IPV4        = 2,
>>> +    IGC_RSS_TYPE_HASH_TCP_IPV6    = 3,
>>> +    IGC_RSS_TYPE_HASH_IPV6_EX    = 4,
>>> +    IGC_RSS_TYPE_HASH_IPV6        = 5,
>>> +    IGC_RSS_TYPE_HASH_TCP_IPV6_EX    = 6,
>>> +    IGC_RSS_TYPE_HASH_UDP_IPV4    = 7,
>>> +    IGC_RSS_TYPE_HASH_UDP_IPV6    = 8,
>>> +    IGC_RSS_TYPE_HASH_UDP_IPV6_EX    = 9,
>>> +    IGC_RSS_TYPE_MAX        = 10,
>>> +};
>>> +#define IGC_RSS_TYPE_MAX_TABLE        16
>>> +#define IGC_RSS_TYPE_MASK        0xF
>>
>> GENMASK()?
>>
> 
> hmm... GENMASK(3,0) looks more confusing to me. The mask we need here is
> so simple that I prefer not to complicate this with GENMASK.
> 
>>> +
>>> +/* igc_rss_type - Rx descriptor RSS type field */
>>> +static inline u8 igc_rss_type(union igc_adv_rx_desc *rx_desc)
>>
>> Why use types shorter than u32 on the stack?
> 
> Changing to u32 in V2
> 
>> Why this union is not const here, since there are no modifications?
> 
> Sure
> 
>>> +{
>>> +    /* RSS Type 4-bit number: 0-9 (above 9 is reserved) */
>>> +    return rx_desc->wb.lower.lo_dword.hs_rss.pkt_info &
>>> IGC_RSS_TYPE_MASK;
>>
>> The most important I wanted to mention: doesn't this function make the
>> CPU read the uncached field again, while you could just read it once
>> onto the stack and then extract all such data from there?
> 
> I really don't think this is an issues here. The igc_adv_rx_desc is only
> 16 bytes and it should be hot in CPU cache by now.

Rx descriptors are located in the DMA coherent zone (allocated via
dma_alloc_coherent()), I am missing something? Because I was (I am) sure
CPU doesn't cache anything from it (and doesn't reorder reads/writes
from/to). I thought that's the point of coherent zones -- you may talk
to hardware without needing for syncing...

> 
> To avoid the movzx I have changed this to do a u32 read instead.
> 
>>> +}
>>> +
>>> +/* Packet header type identified by hardware (when BIT(11) is zero).
>>> + * Even when UDP ports are not part of RSS hash HW still parse and
>>> mark UDP bits
>>> + */
>>> +enum igc_pkt_type_bits {
>>> +    IGC_PKT_TYPE_HDR_IPV4    =    BIT(0),
>>> +    IGC_PKT_TYPE_HDR_IPV4_WITH_OPT=    BIT(1), /* IPv4 Hdr includes
>>> IP options */
>>> +    IGC_PKT_TYPE_HDR_IPV6    =    BIT(2),
>>> +    IGC_PKT_TYPE_HDR_IPV6_WITH_EXT=    BIT(3), /* IPv6 Hdr includes
>>> extensions */
>>> +    IGC_PKT_TYPE_HDR_L4_TCP    =    BIT(4),
>>> +    IGC_PKT_TYPE_HDR_L4_UDP    =    BIT(5),
>>> +    IGC_PKT_TYPE_HDR_L4_SCTP=    BIT(6),
>>> +    IGC_PKT_TYPE_HDR_NFS    =    BIT(7),
>>> +    /* Above only valid when BIT(11) is zero */
>>> +    IGC_PKT_TYPE_L2        =    BIT(11),
>>> +    IGC_PKT_TYPE_VLAN    =    BIT(12),
>>> +    IGC_PKT_TYPE_MASK    =    0x1FFF, /* 13-bits */
>>
>> Also GENMASK().
> 
> GENMASK would make more sense here.
> 
>>> +};
>>> +
>>> +/* igc_pkt_type - Rx descriptor Packet type field */
>>> +static inline u16 igc_pkt_type(union igc_adv_rx_desc *rx_desc)
>>
>> Also short types and consts.
>>
> 
> Fixed in V2
> 
>>> +{
>>> +    u32 data = le32_to_cpu(rx_desc->wb.lower.lo_dword.data);
>>> +    /* Packet type is 13-bits - as bits (16:4) in lower.lo_dword*/
>>> +    u16 pkt_type = (data >> 4) & IGC_PKT_TYPE_MASK;
>>
>> Perfect candidate for FIELD_GET(). No, even for le32_get_bits().
> 
> I adjusted this, but I could not find a central define for FIELD_GET
> (but many drivers open code this).

<linux/bitfield.h>. It has FIELD_{GET,PREP}() and also builds
{u,__le,__be}{8,16,32}_{encode,get,replace}_bits() via macro (the latter
doesn't get indexed by Elixir, as it doesn't parse functions built via
macros).

> 
>> Also my note above about excessive expensive reads.
>>
>>> +
>>> +    return pkt_type;
>>> +}
>>> +
>>>   /* Interrupt defines */
>>>   #define IGC_START_ITR            648 /* ~6000 ints/sec */
>>>   #define IGC_4K_ITR            980
>>> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c
>>> b/drivers/net/ethernet/intel/igc/igc_main.c
>>> index 8b572cd2c350..42a072509d2a 100644
>>> --- a/drivers/net/ethernet/intel/igc/igc_main.c
>>> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
>>> @@ -1677,14 +1677,40 @@ static void igc_rx_checksum(struct igc_ring
>>> *ring,
>>>              le32_to_cpu(rx_desc->wb.upper.status_error));
>>>   }
>>>   +/* Mapping HW RSS Type to enum pkt_hash_types */
>>> +struct igc_rss_type {
>>> +    u8 hash_type; /* can contain enum pkt_hash_types */
>>
>> Why make a struct for one field? + short type note
>>
>>> +} igc_rss_type_table[IGC_RSS_TYPE_MAX_TABLE] = {
>>> +    [IGC_RSS_TYPE_NO_HASH].hash_type      = PKT_HASH_TYPE_L2,
>>> +    [IGC_RSS_TYPE_HASH_TCP_IPV4].hash_type      = PKT_HASH_TYPE_L4,
>>> +    [IGC_RSS_TYPE_HASH_IPV4].hash_type      = PKT_HASH_TYPE_L3,
>>> +    [IGC_RSS_TYPE_HASH_TCP_IPV6].hash_type      = PKT_HASH_TYPE_L4,
>>> +    [IGC_RSS_TYPE_HASH_IPV6_EX].hash_type      = PKT_HASH_TYPE_L3,
>>> +    [IGC_RSS_TYPE_HASH_IPV6].hash_type      = PKT_HASH_TYPE_L3,
>>> +    [IGC_RSS_TYPE_HASH_TCP_IPV6_EX].hash_type = PKT_HASH_TYPE_L4,
>>> +    [IGC_RSS_TYPE_HASH_UDP_IPV4].hash_type      = PKT_HASH_TYPE_L4,
>>> +    [IGC_RSS_TYPE_HASH_UDP_IPV6].hash_type      = PKT_HASH_TYPE_L4,
>>> +    [IGC_RSS_TYPE_HASH_UDP_IPV6_EX].hash_type = PKT_HASH_TYPE_L4,
>>> +    [10].hash_type = PKT_HASH_TYPE_L2, /* RSS Type above 9
>>> "Reserved" by HW */
>>> +    [11].hash_type = PKT_HASH_TYPE_L2,
>>> +    [12].hash_type = PKT_HASH_TYPE_L2,
>>> +    [13].hash_type = PKT_HASH_TYPE_L2,
>>> +    [14].hash_type = PKT_HASH_TYPE_L2,
>>> +    [15].hash_type = PKT_HASH_TYPE_L2,
>>
>> Why define those empty if you could do a bound check in the code
>> instead? E.g. `if (unlikely(bigger_than_9)) return PKT_HASH_TYPE_L2`.
> 
> Having a branch for this is likely slower.  On godbolt I see that this
> generates suboptimal and larger code.

But you have to verify HW output anyway, right? Or would like to rely on
that on some weird revision it won't spit BIT(69) on you?

> 
> 
>>> +};
>>> +
>>>   static inline void igc_rx_hash(struct igc_ring *ring,
>>>                      union igc_adv_rx_desc *rx_desc,
>>>                      struct sk_buff *skb)
>>>   {
>>> -    if (ring->netdev->features & NETIF_F_RXHASH)
>>> -        skb_set_hash(skb,
>>> -                 le32_to_cpu(rx_desc->wb.lower.hi_dword.rss),
>>> -                 PKT_HASH_TYPE_L3);
>>> +    if (ring->netdev->features & NETIF_F_RXHASH) {
>>
>>     if (!(feature & HASH))
>>         return;
>>
>> and -1 indent level?
> 
> Usually, yes, I also prefer early return style code.
> For one I just followed the existing style.

I'd not recommend "keep the existing style" of Intel drivers -- not
something I'd like to keep as is :D

> 
> Second, I tried to code it up, but it looks ugly in this case, as the
> variable defines need to get moved outside the if statement.
> 
>>> +        u32 rss_hash = le32_to_cpu(rx_desc->wb.lower.hi_dword.rss);
>>> +        u8  rss_type = igc_rss_type(rx_desc);
>>> +        enum pkt_hash_types hash_type;
>>> +
>>> +        hash_type = igc_rss_type_table[rss_type].hash_type;
>>> +        skb_set_hash(skb, rss_hash, hash_type);
>>> +    }
>>>   }
>>
>> [...]
>>
>> Thanks,
>> Olek
>>
> 

Thanks,
Olek
