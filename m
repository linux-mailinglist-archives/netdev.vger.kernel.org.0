Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF8FC5E6CB0
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 22:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbiIVUHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 16:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232198AbiIVUHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 16:07:50 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF635E6A1E;
        Thu, 22 Sep 2022 13:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663877268; x=1695413268;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=U5GnEsZWXn7ptu7CNAt9Bd6335O8LBPub3wp7Gfjy4E=;
  b=CAVerdI0kKWiiEt/2zgwJM7Ojny/parVAd/IIuuCATx75tF63/JdH1D/
   vRXaDGhhNDI/mC4+uETqrqEMvlBVuMoCbe0kldG/Xrj8geV8AIdJ6eyd4
   otICjpta5vA/jOwMKn77UEoFG42e0jejKMKbISgdDcElF1PABjKnhYQcX
   98pdJIhA80HUVIcVMgJVcm0mMNlGGGbKXQOSyt5L+0nKoGBlg8AOMFyKV
   dnxV+AVttv3h9chUAmtFUSoxhkz1+VrsWCLb3qH2MIM/4eWcPLtMYOJuu
   Qjo2PriSGYUMIyvR7y0pYeEWbs2daxQ0zd8rI1Oyyk8UO2BeYhHpOaMxi
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="326743159"
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="326743159"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 13:07:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="865018984"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP; 22 Sep 2022 13:07:29 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 13:07:28 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 13:07:28 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 22 Sep 2022 13:07:28 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 22 Sep 2022 13:07:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LnVsO/wwHshWzQOX/iJUTjQFdHpRCe8QMEldZg07S+jtVtMbSVZkvQs3tJknIWBvLZcK2GJ/gWn+Faaq/iOnm+grgMVLt0TuTG8//4WOLHTs/5vE/FY7Gch4TEt+/g69I8BuYM7A01Loc9c6uES7uhR4L3uIDtXmQXt8s4fd5CPRWsFo8+oKvt78fAcCWPVm0cjkPMUCFW5XesletlxCMZzrOo3FaSS5ay4rRIx8eRNaIRQyi/ehHJkNMM45xbSCRb+p9n7hYlkwt7l/XisMKhdX59vmMQh0t4PlC3IhJC2WTSP2w59dUUg/suWQer3cr0EO//wq9v18l/F8ZUaBmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=68MWHITrm4Jn6U8XFWdW8K/4mQFdALH7xAiQ7zw0dl4=;
 b=ba0e1G3wEQOCFUIkq7LfD2DwWDfZtlszErROoWbbvx5hA8Nk7SutBP+ChwAFhtCk2+ivnywbEaNLsxSy0jIIj0EFFZ5HLrMypoN+T0n3xcVw0mJIIP771l/sgj+g687809rLfoVLkpxhdc0ukIjb50UKnbNCbFA80sNEvRD93pBxh9uqo9ID1bGhsQ9IxPVO1LGDz5m1S7hkXnWDkpnohYvzz6Pzhh5YsX9P4faAUjvtog+BU11bPZ7sB7Wyq9V1hXQewfrBlBrfhije1mvmWidqGWPr3xP+DGAeysoRf6Bo00elmCu7w6oC4nVP6XaH+0EtLlgOH1PzfXJUrsrOBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW3PR11MB4764.namprd11.prod.outlook.com (2603:10b6:303:5a::16)
 by CH0PR11MB5348.namprd11.prod.outlook.com (2603:10b6:610:bb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.18; Thu, 22 Sep
 2022 20:07:26 +0000
Received: from MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::e82e:c89f:d355:5101]) by MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::e82e:c89f:d355:5101%6]) with mapi id 15.20.5654.018; Thu, 22 Sep 2022
 20:07:26 +0000
Message-ID: <d4e33ca3-92e5-ba30-f103-09d028526ea2@intel.com>
Date:   Thu, 22 Sep 2022 13:07:22 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [Intel-wired-lan] [PATCH] ixgbe: Use kmap_local_page in
 ixgbe_check_lbtest_frame()
Content-Language: en-US
To:     "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Netdev <netdev@vger.kernel.org>
CC:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
References: <20220629085836.18042-1-fmdefrancesco@gmail.com>
 <2254584.ElGaqSPkdT@opensuse>
 <CAKgT0UfThk3MLcE38wQu5+2Qy7Ld2px-2WJgnD+2xbDsA8iEEw@mail.gmail.com>
 <2834855.e9J7NaK4W3@opensuse>
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
In-Reply-To: <2834855.e9J7NaK4W3@opensuse>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0015.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::20) To MW3PR11MB4764.namprd11.prod.outlook.com
 (2603:10b6:303:5a::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR11MB4764:EE_|CH0PR11MB5348:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a66ed2f-639c-43ea-20b9-08da9cd61189
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gaHtvrdBLAGl5YAVxmpgeGVBVpcvENAH/5MZu6J3ZSE6jq5g1p2HTIox/n12Gn0w4+/25/7xpbX1q+vPly2bHRIWCov+Lud2me6Lus7X/i+a3DN4MVGv+FG+bjukkW34rx1D0Z0XbQdgyMpbZbTXzFvRhryu80KXPLHuGOQGB/7YNGf2AYb+l26J2Tp0wN/j8OAiawHo/h9rZUhP97ZRLcswNheeAtTYXuHm01wmVmvfieKReGTvuI6q7AZxUMLHKKync7T8eRLvFArP4XqPZYOSIvdXl628vUZhh3JZM8g1S6pogzbP+IMVzUMgkBi19wM+N77Y8/Hbnen27r+i+iupFSJYZRzS4OooYKobUV7RB5Kdsau8+tT/Ih9/78nyQu5LYziIh7B2l/Q7J/+a1cLFLtA+MYRKFIX4SJ/Axk8L3KxyttglosXl7S6EnDM/4KCBHUSqXc0/hvizUqtOM4ujS3nio4cFSwvBQDY6EEgdShg6BEQUlgafmh2CsgFC0deqZcPem4uyZHbQvmz05C8ZY6IDhxiLayKEtJ21uO7vU9HKxHaxYr/E844le7oXRNdKz5iWUBaXrROoIP9MCP6ECpnQuxXoXPQr5v9YiusmMEjwR5+7KTmvADD+EDu9sX4RDCjdR4iyDoAa8E23X7XsLp9vEfSTG/T5vsHuKRb0FGmhHbMdxRm/f5TQmKKVYdbeS2b6jsiGoTi9qbBaO7KexnpfdHFsXS3N1urTjq48g9Lc9i3SdiXRd9MR7eVKaVQu4pzJanyZnH8uIpV7xVQ9p2WA3Cb2ipRnxWpWuNUy3Xpur4QTeqUxZuyjnIyyEZ0nWROGkzbwHw7zCVYH25/YJ7bYDllti6SopZUruaSyejaTEclsllHZJt4XEioi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4764.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(366004)(396003)(346002)(136003)(451199015)(31686004)(2906002)(36756003)(8676002)(4326008)(31696002)(82960400001)(38100700002)(83380400001)(186003)(7416002)(44832011)(8936002)(66476007)(66946007)(66556008)(316002)(54906003)(110136005)(86362001)(5660300002)(6486002)(2616005)(478600001)(26005)(6512007)(6666004)(107886003)(966005)(41300700001)(6506007)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RmhNaUczRVpZZFAyWnNRbmJpa1U4TC9hUGhqeW91R1hRMFovelBVcEpxUTFn?=
 =?utf-8?B?cEdUMHFKSkNQY204QXpTVXdMUXl6dldzTk5TWW9mMFFJRGZjODduYUlsQm1v?=
 =?utf-8?B?V3BEQXAvTzFPUUlBcUpGdTlkcnA2MFdIMmt6OU1vMzU4OUhtMGFaSUhqUHlv?=
 =?utf-8?B?VnRVSGN1WEdjRVJZQWY2akZ3ZndjejRRTWVLZkY0OWwvcExBNm1YQ042RURL?=
 =?utf-8?B?TDM3RTdtdkZFZUFLaVVuNVZ6Qkw4cks2aUVBSkFjNlpzbmY3ZVRMSVZIWVVw?=
 =?utf-8?B?N2dIckdlYzRvdTduRWlPd3k1eGtwNDBEQTh1U2VzYmFQM1k1YUxCTkxQeGhk?=
 =?utf-8?B?eXBRaXFBRlRXZWNWQUR3ZXRkb2tqZDVtSXQwM2NxUGhKMHpWdFRVK0VoNHM1?=
 =?utf-8?B?a3l2WXlNcEM3SXJXVXcxaXc1d2M1NXRTbjBXVjFCK0ZSb3BsWG1WTXY3TGhE?=
 =?utf-8?B?cGU1d2xMVjNldGg1c1dwV0FHM1VSSHU2VW5kNGlvZVlMdEVMVHhEVURNWlp6?=
 =?utf-8?B?NkpGTUVubmJsUVk1VzNlZG9lb3ppd2oxQ3N2YmJDRnFwWnh5RW95T3FnQmJV?=
 =?utf-8?B?UHhSR1lBdy9uTlkxYzBSY2t3SElCMmc4WmNJNTZadkYzaDJDWGYvM2JSMnR0?=
 =?utf-8?B?Z01CSEM0V2phUWZDVVcxLytiak02ZS9jWWtKcE5pYXQ3NnN3OWFXTnd2TXoy?=
 =?utf-8?B?bmwydzBrSG92T2NhMGJIeU9lRlJQdWdWenRiT0ZSYmFaSDVETVFjeXV4UHFv?=
 =?utf-8?B?STN5aU9VZ1locEtwR1JvbTNBTUg3VnZnZVZrNjU3YTdrSy9hUWJUZCszRHI4?=
 =?utf-8?B?Q1EySE8xN1hOQmJBM1BpRFUxdGVkWFlxUmgyQXhCTDVLNHZROEIwbmEvajNr?=
 =?utf-8?B?YmZNOWt3dDduSHRvTmlsM2dGR3krK2ZvMXNVNFJza0dYMWxlVjZsOVQ2aE5x?=
 =?utf-8?B?V29jQmtFYXlaZW1xSUczOVVuR2ptN0hhalRsM1E2d2JWMDhmbmg0cmNNQVE5?=
 =?utf-8?B?QStMNnZONkQ1a21rcmplWldpT3UxenFMMXdIRU9YRUhXWEVRNW5EOVVjL0hT?=
 =?utf-8?B?TXR4VjJaU1hPK05FSkFPTTBMT2U2WWhKL2tjRGhibU9NRHhXc0V6SllMbTlC?=
 =?utf-8?B?QlBXSTlwNitZNWM3WnlaRHBUTWJ2NVJIRzJOSGh6Y3lGTzBaampkWjhUM0dK?=
 =?utf-8?B?WUZXZVZjZGZLWHpKbHdvUXVieVZkVzBsR2NyWU8ySHZ0cStpdFRlZklQL0Rr?=
 =?utf-8?B?WUVKN3VtWG4vNk12WTltdU1sN0pJTXJDU1NZV0xQbit3c3h1bWdhaW54S1Uv?=
 =?utf-8?B?RzR5clBIdmhjQWxwSndnZWcyUFp5ckY1RGtreFRqQU1HaVNSUFNBeUNHdjFi?=
 =?utf-8?B?L2J5WDFnTWVwNVg0c0hpd1hWT3lVK2NGdFprMzhjUFVIV0pIWHRSR25xT1FF?=
 =?utf-8?B?bWZ4NzdJTXJjTFc1UzRQUXYyZFcxb3N2MmhRdWdEQlI4WGlqcG5oYTR0Y0VB?=
 =?utf-8?B?UnJrb0xnZ2MrV2F6aFVPcEJRampncCtpQzVhWTNVUE5TZ2xrT2F3VUFjb29C?=
 =?utf-8?B?bDVCQUFSS3VYZE92c0pHemFud1EvNTBLcjdKU2hxUWNsN3BCTVVONHFsSVgw?=
 =?utf-8?B?Wk5tT3JRY0lYOWdoaDQvRG5VNHhIc3lrZGdwNEhiY2hPOWdnT05COUx4T1U1?=
 =?utf-8?B?aCtvNXMveHJqNjVRT1lGWTlwakkrYWdnUEdYTkVwS3BxeUJJTU01VHNCNnAv?=
 =?utf-8?B?SlYyVnkwLzQ1M0xaUlV5aHVUNWQzR00xOFlQNFQ3K0I0YnV1QXVlbVhzWGhD?=
 =?utf-8?B?MVEzK05BMndMcUZKTUlYamh2MWlVUmRWRGgxUmt0d1NSa2FkbE52bWlLdzhW?=
 =?utf-8?B?dmZDRjBvcitaVzFKckc0TEpwS3BXM2xod2xrd1RMd0lmY0pER0dVSFYxRVJX?=
 =?utf-8?B?RmtaM3h4ckd2YzNRWUdDNUNSTUVUam92eU9QQURFbDVha0NLVXU2UjA0UmJs?=
 =?utf-8?B?N0xmUk40SXBPSjNKREJ3eGwyZmQzWHMrbWhDNDNrbGViS0lGUG9uRFpGejF1?=
 =?utf-8?B?ZW5sdGxjMFJTa1JmdlQ3ZDlSbmtsT2UyTGNIYUtKNDJxZmp4YU1SN2ZCUHNu?=
 =?utf-8?B?VFB2WUY3UndaYkd0Tjl6cXRWR1Uzbk55SXhvTUl1b0lmdUhNSk4vdkNQQXk5?=
 =?utf-8?Q?p5wl5j1VOze0PEmUjfmzai0=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a66ed2f-639c-43ea-20b9-08da9cd61189
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4764.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 20:07:25.8886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bY48JKjcm4t+W6WzZR+ZAez42ND5WLtUi+A40bEzlD1GYWPjdWwGUdpFSyb2khBmH1Z73nwNqoiQ2w3UNF67G4hm36iEb0aKjiof6k4Uj+uYSIQzAB2LxHZtLMcABozX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5348
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-9.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/1/2022 8:36 AM, Fabio M. De Francesco wrote:
> On giovedì 30 giugno 2022 23:59:23 CEST Alexander Duyck wrote:
>> On Thu, Jun 30, 2022 at 11:18 AM Fabio M. De Francesco
>> <fmdefrancesco@gmail.com> wrote:
>>>
>>> On giovedì 30 giugno 2022 18:09:18 CEST Alexander Duyck wrote:
>>>> On Thu, Jun 30, 2022 at 8:25 AM Eric Dumazet <edumazet@google.com>
> wrote:
>>>>>
>>>>> On Thu, Jun 30, 2022 at 5:17 PM Alexander Duyck
>>>>> <alexander.duyck@gmail.com> wrote:
>>>>>>
>>>>>> On Thu, Jun 30, 2022 at 3:10 AM Maciej Fijalkowski
>>>>>> <maciej.fijalkowski@intel.com> wrote:
>>>>>>>
>>>>>>> On Wed, Jun 29, 2022 at 10:58:36AM +0200, Fabio M. De Francesco
>>> wrote:
>>>>>>>> The use of kmap() is being deprecated in favor of
>>> kmap_local_page().
>>>>>>>>
>>>>>>>> With kmap_local_page(), the mapping is per thread, CPU local
> and
>>> not
>>>>>>>> globally visible. Furthermore, the mapping can be acquired
> from
>>> any context
>>>>>>>> (including interrupts).
>>>>>>>>
>>>>>>>> Therefore, use kmap_local_page() in
> ixgbe_check_lbtest_frame()
>>> because
>>>>>>>> this mapping is per thread, CPU local, and not globally
> visible.
>>>>>>>
>>>>>>> Hi,
>>>>>>>
>>>>>>> I'd like to ask why kmap was there in the first place and not
> plain
>>>>>>> page_address() ?
>>>>>>>
>>>>>>> Alex?
>>>>>>
>>>>>> The page_address function only works on architectures that have
>>> access
>>>>>> to all of physical memory via virtual memory addresses. The kmap
>>>>>> function is meant to take care of highmem which will need to be
>>> mapped
>>>>>> before it can be accessed.
>>>>>>
>>>>>> For non-highmem pages kmap just calls the page_address function.
>>>>>> https://elixir.bootlin.com/linux/latest/source/include/linux/
> highmem-internal.h#L40
>>>>>
>>>>>
>>>>> Sure, but drivers/net/ethernet/intel/ixgbe/ixgbe_main.c is
> allocating
>>>>> pages that are not highmem ?
>>>>>
>>>>> This kmap() does not seem needed.
>>>>
>>>> Good point. So odds are page_address is fine to use. Actually there
> is
>>>> a note to that effect in ixgbe_pull_tail.
>>>>
>>>> As such we could probably go through and update igb, and several of
>>>> the other Intel drivers as well.
>>>>
>>>> - Alex
>>>>
>>> I don't know this code, however I know kmap*().
>>>
>>> I assumed that, if author used kmap(), there was possibility that the
> page
>>> came from highmem.
>>>
>>> In that case kmap_local_page() looks correct here.
>>>
>>> However, now I read that that page _cannot_ come from highmem.
> Therefore,
>>> page_address() would suffice.
>>>
>>> If you all want I can replace kmap() / kunmap() with a "plain"
>>> page_address(). Please let me know.
>>>
>>> Thanks,
>>>
>>> Fabio
>>
>> Replacing it with just page_address() should be fine. Back when I
>> wrote the code I didn't realize that GFP_ATOMIC pages weren't
>> allocated from highmem so I suspect I just used kmap since it was the
>> way to cover all the bases.
>>
>> Thanks,
>>
>> - Alex
>>
> 
> OK, I'm about to prepare another patch with page_address() (obviously, this
> should be discarded).
> 
> Last thing... Is that page allocated with dma_pool_alloc() at
> ixgbe/ixgbe_fcoe.c:196? Somewhere else?
> 
> Thanks,
> 
> Fabio
> 
> P.S.: Can you say something about how pages are allocated in intel/e1000
> and in intel/e1000e? I see that those drivers use kmap_atomic().

Following Fabio's patches, I made similar changes for e1000/e1000e and 
submitted them to IWL [1].

Yesterday, Ira Weiny pointed me to some feedback from Dave Hansen on the 
use of page_address() [2]. My understanding of this feedback is that 
it's safer to use kmap_local_page() instead of page_address(), because 
you don't always know how the underlying page was allocated.

This approach (of using kmap_local_page() instead of page_address()) 
makes sense to me. Any reason not to go this way?

[1]

https://patchwork.ozlabs.org/project/intel-wired-lan/patch/20220919180949.388785-1-anirudh.venkataramanan@intel.com/

https://patchwork.ozlabs.org/project/intel-wired-lan/patch/20220919180949.388785-2-anirudh.venkataramanan@intel.com/

[2] 
https://lore.kernel.org/lkml/5d667258-b58b-3d28-3609-e7914c99b31b@intel.com/

Ani

