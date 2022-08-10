Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2196658F17B
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 19:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233452AbiHJRVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 13:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233509AbiHJRVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 13:21:00 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5CF97C76B;
        Wed, 10 Aug 2022 10:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660152059; x=1691688059;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OBZYRmsIqtiitCZasW8KHj8ihpXkhrTkXlsjV3KAVJI=;
  b=fUH6yKoqcyY331AX/XvPDpG2a3wUCiGXGhTjORSF1jVJVXpGr0CwcGJg
   uZiKckSEDyoE1sotZ17q69uQ5uEo5pOQ6jxY2zrC/cpKsZCUSUYNxLHqe
   QM0z0ST07j89JlTrNGwhh0nERklW1mBsWVSxyot+vx/qSiAtQYmgLli29
   x0T8Fm+Wer9efM0x6shFPS9amIjIQVznldd3I5AH4tC1/X5tMvDAfSNSQ
   ybGo47V2n6vpCHPI20PfGUTuqGjxuPm626TaiM6QdLwHyKHFn1QLkX6Rd
   corX7cpdxImTzE9doIAFB13ZE/QxnMsX8QsnO8lHJxeSjke0F1+YchX2y
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10435"; a="288714079"
X-IronPort-AV: E=Sophos;i="5.93,227,1654585200"; 
   d="scan'208";a="288714079"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2022 10:20:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,227,1654585200"; 
   d="scan'208";a="731568762"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 10 Aug 2022 10:20:59 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 10 Aug 2022 10:20:58 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 10 Aug 2022 10:20:58 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Wed, 10 Aug 2022 10:20:58 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.45) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Wed, 10 Aug 2022 10:20:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jM8CfsXngMUQ9BYT8Exrqgbe7l4ve+UPgE9dde4p5s4eUeJyPW6Cfloq7RiOPgMxw+NF0YPp8Pv+Mmco0yuOI3Y7WYMUrFmUMAoWCIZ4Kbuu3tW2pVtK+A0wc+D+iqbbN9Zfg+Yw3LqeyaZmv5DKbCtiKvzb4wqcJQH3e76XcTjFUjm9SB9UoBi2D4d4d1D2y3S8XiMuEVRBwiQZsyeaZ0oHgjo1p1V+Ya6Gwv8AbKZSTjgkwwiFUuONjWkprwSev/qKKzr5I/qsUS2bOkhSBvKs8ZQrQNJuMlUOKgj9w0svBLZWEXZbXOydnCpurazzoFVSfpHbaLXcyN3pSyH9UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F8/3k1OiroKC5hYirB+1TPWXwxeUYn9WoeoIaTB8Lns=;
 b=UDmgq6B5Kuq+xC3z6Qx7GN1STiOutGQ13d2FHnD5zSKJ3CmYG4feMQ94lOlEtN3bclXeDHhAUGDymP4MphrXMUWhkjGuNAFdEsmF/AyRVG3NtoVKjVt0eI9JUOA4SZqp87w2kFVBDTHceSFJQ0/im/eQ83eekgkOuJxHqEMKJCpgzI6db7dP25qyjF8E2hICnCYiO3SH4ng/QyBI0JMQzsCMQPepDQk2pNMfNYjZ/nfS7T699/J91HCGoNNw7Q3Viepp2NVNZZyI5XAT77juZTdfubYmhl0L+riKbHXcqhJKQaCplT+KlgEMpoo6IlZPID28+Ar5FTDeOrW/GMHvvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by BYAPR11MB3751.namprd11.prod.outlook.com (2603:10b6:a03:f8::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Wed, 10 Aug
 2022 17:20:54 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::9d3b:23bc:a1e8:2475]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::9d3b:23bc:a1e8:2475%7]) with mapi id 15.20.5504.016; Wed, 10 Aug 2022
 17:20:54 +0000
Message-ID: <da087ad9-981a-2a9f-a134-1f6cab7addc0@intel.com>
Date:   Wed, 10 Aug 2022 10:20:35 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH] igc: Remove _I_PHY_ID check for i225 devices
Content-Language: en-US
To:     Linjun Bao <meljbao@gmail.com>
CC:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20220809133502.37387-1-meljbao@gmail.com>
 <b39c9fa3-1b7c-c7b1-c3dd-bf5ceb035dc8@intel.com>
 <0b4ce201-be78-5a5d-0098-0cbe14ea43fd@gmail.com>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <0b4ce201-be78-5a5d-0098-0cbe14ea43fd@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0031.prod.exchangelabs.com (2603:10b6:a02:80::44)
 To SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cbaf51ab-34b1-415f-960b-08da7af4ae78
X-MS-TrafficTypeDiagnostic: BYAPR11MB3751:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c248+K48zkUjfZFNGXV5ubgW1BRegbQ1DTs2bSXmHqTj4pUkCCdXoVE0+8BcZd2s97QL07dzUMzT446+BpWDKBQc1pFfzmasO6cJbVf9dJQNMrtAEl4O9m0Q2awXYclKw8vzPCPfJLsS9jEGX17ASMLBVvxCoG3J3KiSrKUdSoQLCUSeXZskdgDdG1IxeaOu9yJh+FXTbBbtMLuvlIDFY2OasDiw0+2O+9DL9aw8vU+szlmE2kN/7LLXOpUeWo0nKBVCP9hUYte88cgr9FMGMlz99zFbA+O0R/hhIjG0WWxxaZdRSIwgtPzGSswCRWnkIXoQSsdfah6K1sG2ilE6ZTKo2H2A7iLp0Ikr9RcLF/QbEjqjHHssLwwTPXhym+SHt4H3zN7pF9KwOSmtx+ZMOh23pJu4USbCNKuVesHvLDxJUqrRY7ggPWfaujTlxH0llB27LPQc0kIEBPmLw9tTMyLPCWuS6d9kDsBlUjAzzyXzfHQlBRqCodzQtld622ts9Ae6CaQOhZDV7G+9zzEGvxUNqSyqSX/HAlstFrR9R2xM54qsmW2nmCg7UjuKSq72jxvXWjJ9joUkLliuP+/DtcMHm88LB0sC1jV4jomL4nYkfhvKmWJySd3Oexk/NxgXZynXZylnTYjCivPuRza2tPUwULk2vl5Ve/uWdk+dtWeeErbFc9U2KEIXybQ9SJ2Wxsstj+6Ee9HlV3sat6CdiShAF9MGHO1mX2mBpw3Oi5RfwxAWv9nWarzByCeTcEcaKe+Sm5+5pgkLSm7O4Z1LNfbgNVRlpc8BE8PBWG2qlGg/kCnMBa6VDj5yEkA722174v1Mp2EJmoBjGkyTj4VJvke3u9zHv3bUTKUV86DEqnv6G9zi3nVGh+hgdIvVu3Rm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(346002)(366004)(396003)(39860400002)(38100700002)(31686004)(82960400001)(53546011)(6666004)(6486002)(966005)(2616005)(478600001)(26005)(186003)(6512007)(41300700001)(6506007)(5660300002)(86362001)(31696002)(66946007)(66476007)(6916009)(54906003)(66556008)(8676002)(4326008)(316002)(2906002)(83380400001)(36756003)(4744005)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?alNsWDM2UGlEQmF3dTVkd3d2Qkc4NmZXUDRsc3hLZHRnUlU5d3A2SVJUNnQx?=
 =?utf-8?B?U01RYVhwcXVaNHdEem1EbTdrOXNhT295cFZZUUtaa2lZNFZ4WklteEw2d3M5?=
 =?utf-8?B?Q042U2tkKytWeXFqcHJYOEFTb3hiTnhFeU5weG5TQlI5Z0hGendpWm0rcmx0?=
 =?utf-8?B?dXJLQU45SGpBaXpGYmd2UzJzMkY5ZnI3K2FYczF2K3VzTFUyQXBEKzRmMUFR?=
 =?utf-8?B?N0F4NnRjTUQvR2dVNTYreWhHTnVlWmg4bG4yT0NVenlOWXRnK0pOSWc5NFQ0?=
 =?utf-8?B?ejhwbWt3M3RKWVlMcnRMbExSRGhqdEd3OEswWWExazFGODRhQlZqenRKc2xV?=
 =?utf-8?B?NE9yWHhxYnF3UkNudjZvK2h4ejh3RmN0VGVFTlljWVNobytEREFXTDJhNVRK?=
 =?utf-8?B?YmYrWTFYZ05CQmFlYnBEbDJVNTl5V0drTXhuTGdWOHBhZmNpTEtYaHJvb1FV?=
 =?utf-8?B?WHRxVTJ5ZDlSOUJCdTQwSXdGa21ubTZiTVBPQStoZW4vdHdDWmRnQkh0bmx5?=
 =?utf-8?B?VjM4TFJ2OTZyanNhSzkzZTdYMUhjZlF0aWZGYklqb0hXQmtQaldPZm1PMCtG?=
 =?utf-8?B?YjQwVGROVlBzaFZKQng3SEVGNzNXVVZIeWZhdWdPT1hoaXBNemhlSXNOdVZK?=
 =?utf-8?B?anNWMWhBZ2xMeStuZW5TdE1MVktka3BvUzhlemJTSDJiMEUwSzR3ZThEMkRM?=
 =?utf-8?B?T2dMU3krdFVXajl4aGg3WTNrcnlHN3VGekNyNjZlT2s2bWkyOTFvTjhJTDRW?=
 =?utf-8?B?M25wczBpYmpWQWtwSnB1NWVJUUEzRHk2dzExNkIvOGtyQXlXRG1kUlFzMzBX?=
 =?utf-8?B?cTFKVERLcFk5WXBzNEsyVDNnUHM4WWsrY0o5VmtLREdSY1R0OTlBUEVrbUVT?=
 =?utf-8?B?U0dKUUJ0U1UyamJIQ3l6b3prWXg2Vkl1STJINE9jSjdpUS9SRVRKMTV3VWw5?=
 =?utf-8?B?K1ZBNXcvRUQ0SjZNaWRXSTZoOUlZc2x1eTFqVjhWak9mOCtpOHIzSzltNis0?=
 =?utf-8?B?SS90QkdkbmNSUHhTOUhuTnhiUldLWUdmVE03L0ZKNHBBWjN6L1ZTQ0kxVll6?=
 =?utf-8?B?dU5EVUtiY2FreEc4SmJySG1IUnFtR2lOYUhHeTFaYkozcjlEaUlmSkFHZitW?=
 =?utf-8?B?ZDAya3ZxUFdIR3VrOGtleGErTUVEbVh4MHNhR3ZGT1hJN0w0OWgwUWk2Nmpz?=
 =?utf-8?B?aERWUmgwUkNXWnM4NllFY2x5S1ZGTEIxSUpCay9la3dLYmo1NzkvUjJ6SmJB?=
 =?utf-8?B?eU1BMHA1cENuakpJUjhBMWVrbE1XUlZZcm9kZmIvSDR1VnpDUS96Zks1Y09x?=
 =?utf-8?B?SHNlSFZiSlU4M1FVUjFzeG5IcGlNalJxYVlkMkZ5NkRycGhVNTI2VW5UQlJ3?=
 =?utf-8?B?dWxPYXRGemdoQ01rZnNiTVFjc1RHNjFHUldSdUp2NXlzQXJQUk5SazA3YzVV?=
 =?utf-8?B?enVyZXR2U09LOWI3NlJDbDZmcWFxQ1pKc0ZDekhFTzRNTmY2OXVISmYycVVL?=
 =?utf-8?B?Q0tFTTBPeDJmeEpxS1NIVEwxMWI3R090SE5obkQrSm9FbTd6MU9kQjNyVloy?=
 =?utf-8?B?MmhRSFJGTVNTblk1cTExbnpObWVpZlFGRDQzUHJBR01ocHpTUHltVmtxZlVQ?=
 =?utf-8?B?VDdQUmdRNzZ5WVZTQlhvczlxbTRhWmdWcGdnNE1tMUk2cThhL3hlUklnSm13?=
 =?utf-8?B?QmJRNHpUeVFDQnpGb0VPd3M2U0lqS2VsdkdpZWJxd0RtQ3BFb0RUR2YzbHE1?=
 =?utf-8?B?NHhpQTlZZkMzRlZ1SHdCVGZDOTBkNFM2UjlCRm9yVkhOTDlDcU9iKzJlRkFJ?=
 =?utf-8?B?VUorQmp1dWhVaXVNTDhISEFWaUxxU1FEbDB2WXNHZnZwMXhqc0dUNlFFVW9G?=
 =?utf-8?B?cU9ybi9TT2Zmb2x0cTRnT3pMNFBQc0dYbGxzU2RLQXVXT3h6aTcwSWtCSnow?=
 =?utf-8?B?MUdVL29RTks1UGR3eUFUUmpCTG5Kb2JsWHRWRTJybGVORGhCcG5oOHVhY0lv?=
 =?utf-8?B?VWFVbHFtZVl4ZjhNdFJGQW9tYVkvTEpaRG9RaFQ0Q2F2bXRkRWlMKzlnUFFI?=
 =?utf-8?B?WlpZWDRvbVpPN2c4V3VRWlRLcDBLVThtU1RnZTBRTTNmKzh3RklnbnhHSGhr?=
 =?utf-8?B?dE1nMVlTSTIrbmdrUzVzWUozNUlIdkN2Z2JCcnBNNjhZYnUrYXRVUXluanhZ?=
 =?utf-8?B?eEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cbaf51ab-34b1-415f-960b-08da7af4ae78
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 17:20:54.5499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d4OKphV+kl5A9LYTdycBk3Hxj74aQVCejuKB7sH+LQ0mHMC5LZ/vFXftb7FGIqAooFnuOE/b+ItlK4m9n5SU5sS165i0s785RJdUVD+HOoY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3751
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/10/2022 1:22 AM, Linjun Bao wrote:
> Yes this commit was committed to mainline about one year ago. But this commit has not been included into kernel 5.4 yet, and I encountered the probe failure when using alderlake-s with Ethernet adapter i225-LM. Since I could not directly apply the patch 7c496de538ee to kernel 5.4, so I generated this patch for kernel 5.4 usage.
> 
> 
> Looks like sending a duplicated patch is not expected. Would you please advise what is the proper action when encountering such case? 

Sounds like you want this backported to stable. Documentation on how to 
do it is here [1]. Option 3 seems to be the correct choice.

Thanks,
Tony

[1] 
https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html#procedure-for-submitting-patches-to-the-stable-tree
