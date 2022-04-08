Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF2C4F9A0B
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 18:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237892AbiDHQDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 12:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbiDHQDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 12:03:37 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8367E13CCFD;
        Fri,  8 Apr 2022 09:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649433692; x=1680969692;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=poNKrDzogzbl9aJw8TkAIAP8MlZEyKMcAva4g/VDp30=;
  b=dgfYsPI25ZmASf1YhMFj+z/o3VPtgpjotI7/wjr1gbnyS1BiHPueQdiK
   z6UgjdAvMYiFf068e6yl9DGDkM7R37Gr61GYvwpl4gp7hYhMK1zB+dMTv
   tiWJ3nEio9PyanLVA+dkgiGnD0URifVXxOPUA3Tquhvu7eEfeHYzycTXh
   kBpWS1lJ4J0o3x0y/wV57g0KCjOgE9lzTh9jFENGn2Q2m8v1yypsigriS
   7anelmclfhOoDhCRLmVnbHYS0uyvLj3J9ukNKmo/Wo/vtAvkpOXSueSpN
   GSPHhtflt99fS29SCElXRsHFB16HpRDp4XOx8YtBwP1YhkPgybUgy5m5o
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="249154039"
X-IronPort-AV: E=Sophos;i="5.90,245,1643702400"; 
   d="scan'208";a="249154039"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2022 08:58:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,245,1643702400"; 
   d="scan'208";a="653310402"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga002.fm.intel.com with ESMTP; 08 Apr 2022 08:58:50 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 8 Apr 2022 08:58:50 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 8 Apr 2022 08:58:49 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 8 Apr 2022 08:58:49 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.48) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 8 Apr 2022 08:58:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ioRUsvRckSnTnncnekNRwHMiFhPx0XEwI2Tp8D1Ql1Amm1sflGg9rbjx3L1z88w8JLu326HAO39BUrYEqDpqZHHnKCcJdfaO6/VuwElKdAXS2aOYCUj5UhRk/2v31+nj33zy+RqVeRxE83quSmiYgpKzPQHcg8fBIALPFct51H5Q0zKVxqAzJhyOuk1DxGYyn0Cr/RJJ7XFvMiECiuomhlYHirVGyFbznc5jlS+j9i+Jpbc8Am8uEtxlR7oZRPm86NeHQmt/W24dN+rnuiZwqRH5PP+cxuyg17Ng6Tf+KxWBUs445UeHoMJ5ejPuHBnDG/qiyOQnGPH0l10Y1xKPgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n1SzAam9W7pT0tl2EsyJOM+7pnwNjJtm6rGLIQtDVeM=;
 b=OJQRDwGQAnSjeL9Yvv3iy0JYNVTP9MBNWnsw1SU34xVnprzMXid26GNVfijNeKfZpJrZsXwZ70P3yCjCKx3DJtG5niERoscpajGmuClVkiWGsBUJupRd8XeGY4jOjCv/8jNAyexnZh+ExJbLXpgCImrdgT0OJYRcmmq9lkCkDwc6VPIv/yAMbcXW01sVNhxKuUunYarIXA3ZwVrKn5HLL+7/U4+xdDHp/+q04xYVl4KNaK4XauoB/6ENsrOVdzFVvDHmlYmP5bBP2OsgrkNN+GC5oMmqSPxqJMnO2iEb4iSjSivtgXySnAtfG4WnRC/dq9k9wf1UzAYGUEVpt4cM/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by CH0PR11MB5476.namprd11.prod.outlook.com (2603:10b6:610:d7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.26; Fri, 8 Apr
 2022 15:58:47 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::c560:8006:3235:7aa7]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::c560:8006:3235:7aa7%7]) with mapi id 15.20.5144.022; Fri, 8 Apr 2022
 15:58:47 +0000
Message-ID: <607fe8b6-2f30-ac0c-996a-9d8c4cfeaba5@intel.com>
Date:   Fri, 8 Apr 2022 08:58:19 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 net] ice: arfs: fix use-after-free when freeing
 @rx_cpu_rmap
Content-Language: en-US
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Brett Creeley <brett@pensando.io>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Ivan Vecera <ivecera@redhat.com>
References: <20220404161509.3489310-1-alexandr.lobakin@intel.com>
 <20220408123120.1829671-1-alexandr.lobakin@intel.com>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20220408123120.1829671-1-alexandr.lobakin@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR04CA0009.namprd04.prod.outlook.com
 (2603:10b6:a03:40::22) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2da38aa6-dbc4-403a-5ab9-08da1978aa25
X-MS-TrafficTypeDiagnostic: CH0PR11MB5476:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <CH0PR11MB54760C4EC6D80EE36C9465E7C6E99@CH0PR11MB5476.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pK0Cjmn8Dy/uEW9cWMZxHpsaYkUi8n/huUtvQzcUk1wZNIOfUYMTMRTQSUMZ8C2aezHKQWyxD5nMcGEM6NaWjqMdtHK2tgU16MV1fGkzbzvOGWYwx2p2pqgqhBoiTUNGMXfk6WreCyLKlzFKNhklsi/ywCWP2RtuUK1SniQHQ5jOYDnv9soU7gdc/yD2CLtKgiHdJgO2fQrq5sURo8oPPchF1h5Ny+iycEfhGIdvviIokEU3G8UmQDdPMeVZsgF9d71IL73e9Lzb02dpm8XBCFWOhOms83Aa50yJuuPqQf6/rRgg2zHc6RG30YMQ7Yukp8m0wtGQzqkHC7CVFqGY+7U+6TXqoxyr6/hvj/pWMuRnrI9SU4SqdUI/OJuR4DJfkr1viHSR+RuxpdEyvmFVwKil4Vwfd9h3NQKjryB8bixyVD+HfZ8xYzSEwQUrIB69gjQsVyrO2wZJlgt4oRiT0JmgNFTwfEdPzy+O0skkBeH3UbtLZ2nkd3kWUAf+cO/8RoQlkiC7pkl/ilbptzwr2czOHyEZ+J7kDDjD4ZkVDfDWQbWoDNDbjf5tsi+isdAg7PUmnczatDQ/xFQP69fBcFcWXIlA5w8kZQ0N5SlXlQQ5mo9GTF2xJJOwSuwDH+bz6N+P0MW7Z3ux/SHrAV4EHr7CHJOka4rJ5MjTyxVJy2k+KKKy73Ocn7wXfXaEmNRHFUfSsYA7QA8KMnHOLEZAu9QJbOarvl+rQEah36Xd/gbsdq4b+5nwt+oSn8wTlwIKH9kCFNqrQIVG3UCqn6QNlXl3AnW6mSCqhUNjefHGY9UuXPszsQOr96XcIDI4rWlaMnp5Bjclo4/Y68kZ5hUv2awduSGbtUvuvcYS/xB1AL8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(53546011)(6512007)(6636002)(82960400001)(37006003)(5660300002)(54906003)(38100700002)(31696002)(86362001)(2906002)(6486002)(966005)(6666004)(508600001)(66946007)(8936002)(66476007)(66556008)(36756003)(83380400001)(31686004)(6862004)(8676002)(4326008)(186003)(316002)(2616005)(26005)(43740500002)(45980500001)(505234007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ym5nYjlIUWlPOWlCSE9QWHdxdFI3TndzQXNLS3VybmJHcHV0RHQzU21hOXgy?=
 =?utf-8?B?STFiUEV0TDYzcUZORXQvS0x2ZUNwUlBXSEZabVZINU42dFoxRlRCais2QnpQ?=
 =?utf-8?B?UWgrWFI3WUZzcm1WWHExNHpCMU5ZL2FGVXNSTzNRaDdsUkIrWGJBNlBTYnpK?=
 =?utf-8?B?UGZ4ZTQ0TE54djl4THB2QWI3VkdmakdSTkcrTFBRYVpjaUNHeEtsem1uTGQz?=
 =?utf-8?B?YVVlRkYxb25LcTFQRHJJYUQ2MUdzamxtUWtPZjRpNlU0YkRMeHptZWdheEE3?=
 =?utf-8?B?RjVldG1zQlgzREl3VGRpOG1TakNXL3FRWFo2VERGZXVteTBVdXVocC9kUTU3?=
 =?utf-8?B?ekxEbm5GcnhwemxnRkVNYVpZTllHSElWNTN5NWd3QmpIRnVMWTFUUk9mMmFG?=
 =?utf-8?B?QzYwT3hla2VwYXc5eVdFeHFJMjNYa3l3UmE5c1hsWTV0SVJQZU16cHFVdWFa?=
 =?utf-8?B?Y2MwVm9NSkFlTENwTU9ZcW9vS2pZSDFKMk84cVlQUjJTOW9xMTdUc2w3VG9o?=
 =?utf-8?B?NTJZN1RYUG4yb2VsS1U3TTY3OWh2V3lHckFSQ2VaNjJnVFVqcUlVdmdkQ0Fl?=
 =?utf-8?B?ZDc2cGE0NlcwRDNrTm8reElRQ2ZBWEkxdTltUGEwSmF3aGxkMGNnN2ZUN2lU?=
 =?utf-8?B?SHNtclBHRDdIaXNBdm4zNi9NcnlmK1pOUUs4TG1RcHJnVFh5dE1tNURHMHJJ?=
 =?utf-8?B?UTg1R1BYYTVIMjE0M2cwbEhpayt3NUtybjd0MmV3TW85MlZkMmtPRWsrVzZJ?=
 =?utf-8?B?VDVCZGdnOFYvYllNckE3aDhaaGU0Z2U3ZWJTU3EyNjZrY1J3eXRCbjZqR3k5?=
 =?utf-8?B?a2RSL0NDMlVZYWRDa0F4N2lhRnIyR2wvMTRKTnZSU3V2LzlLQngwT1J3Q2xF?=
 =?utf-8?B?WENsSlBpVE80UDk3V1B4aFpBdHEwclZ6OE5VcnpGWE9EL0ZQZEI0a3pGZUJI?=
 =?utf-8?B?SzAyV0VyaTVvQnA0Z0lEbE0xdXIyWTJ0L0hURVIzbDNHV0dPUUpETUdub1gz?=
 =?utf-8?B?RzBJbG1FbmUyRktMaFYxN25UVVNGRmxRVTJnMVkxQVI5MEJpRzh0WEcvOHVC?=
 =?utf-8?B?amh1Y1JGZCtneDRQUGt6Y0lPbDRhSXc5Vis3aVBrTmJHUXM2WEpoRnp0UytM?=
 =?utf-8?B?NExEV2w3ZUpVZ0o1eElTRFlROGdWZXZBYVVMUk5ITUZ6STQxQllWSC9Bcktm?=
 =?utf-8?B?MC9FWVB5bFo2cmwzT3h4WC92cWp4Z3Y2WDlYZjRpdkR3ZCt1L2lMQ3VweHlR?=
 =?utf-8?B?c3hpOWs5aUVLN3I3Nnhoa2JVZCtrQThNUGZuVENOMmNMOFZrWElvWUdObXBT?=
 =?utf-8?B?Q1ZodWVUQnNYMFFyL3Q4SXVNZHEvRnlTdUFWUUtrNVpSWFZvZW5PVmdTdDVZ?=
 =?utf-8?B?NnZXQm5RQ09ZalY4TDN5ZjYxcDdxWmNnZDFKOXpNSEhKTXAvVFdTY3NPVmd3?=
 =?utf-8?B?c0xHR1J1bVhsbC9oWGRTUTVXL0lnK29YWG5NeFJ6OWlEQVNRZHJNUHBnNDdQ?=
 =?utf-8?B?d2wxOUhGY3BiWE41dzFaOGh3bTVGaEFSZkk5STFMelhqeENzVVJWVWxzMmEx?=
 =?utf-8?B?N0FsQWFxR04zSVBJN0d6ejAzRVlIZjJIQnI5OEZYRmlVMUVOZWJBNDJ5Uk1w?=
 =?utf-8?B?cmNubzFJWXZtM1pGc1RnaGhOdGpjVGdUZEFPYkJNdEczcFUxL0N6YlEwdWdv?=
 =?utf-8?B?UUJqWllRa3JmYUFrdXBwYVZOMjZYZEp6WEkvMTdaRVFqU0wrS3kyZGhCWVMy?=
 =?utf-8?B?KzB2VkduQjh0ZkN2ODRHN1Z2UzN2WDFFMzZVUTVQMnpJbnI4eXczUG5SMitW?=
 =?utf-8?B?RG84UnI1OWhVZkFRMFFtY29hZVFiamVYbDVPNVcwWGNiY1RKemRhTG15d01x?=
 =?utf-8?B?YVBTVmZNQW1CTjI5d0VRdUp1MGpqbGhsSVRDbjVlbHVhOVdaNEYxUllabmFW?=
 =?utf-8?B?R21BcEp5RzlPcGhxeWM0MmhtUVBMWnZWRjcrbklTcEZ4aFdqOWwwM1VYLzlj?=
 =?utf-8?B?dlVJL2VnUkZ6U3NuVVprbTg2MTk2bVoyREM0ZjhycW83SG41Rys4a3g4K0lo?=
 =?utf-8?B?aXhQTWdseDRoSERmSHdneEVpTTFUMHJ5d0lxZmFCTFVyVE51UTJtdFVydW81?=
 =?utf-8?B?eUhhVzdjUDAySFBFYzNwTWhXdWxDenZrdFUrdWoreW80ekVJWGhab1R1azBy?=
 =?utf-8?B?Wk5JTEw5L2RlNWtCdWIrVlZWS3VIYll5ckkvcUtEVE41SFcvT0dCSW56bjRq?=
 =?utf-8?B?TjVRVzhHcmE3WFFUNXpxMzROVkdPeTB0cFZsU1dIWm9xQlRRbk5ZSzcwemYw?=
 =?utf-8?B?L2YxM2dKRDVOMnNadit2Q2l0bG9IRXZlMGowaTlWV2xpODVuYkh5MU1zekF6?=
 =?utf-8?Q?3d6oNPgdK6wZr4ro=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2da38aa6-dbc4-403a-5ab9-08da1978aa25
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 15:58:46.9097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jQcTAMkD6LSrvaJgLS86+7UnLgJP8yHaQUlmgUTgZfqT93NET/YUVVVAnl9Hdo5Uop2vlfmnDpzgLB0zVpAdGRDRw5vnmwKFfOaIlwVoLHc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5476
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/8/2022 5:31 AM, Alexander Lobakin wrote:
> From: Alexander Lobakin <alexandr.lobakin@intel.com>
> Date: Mon, 4 Apr 2022 18:15:09 +0200
>
>> The CI testing bots triggered the following splat:
>>
>> [  718.203054] BUG: KASAN: use-after-free in free_irq_cpu_rmap+0x53/0x80
>> [  718.206349] Read of size 4 at addr ffff8881bd127e00 by task sh/20834
>> [  718.212852] CPU: 28 PID: 20834 Comm: sh Kdump: loaded Tainted: G S      W IOE     5.17.0-rc8_nextqueue-devqueue-02643-g23f3121aca93 #1
>> [  718.219695] Hardware name: Intel Corporation S2600WFT/S2600WFT, BIOS SE5C620.86B.02.01.0012.070720200218 07/07/2020
>> [  718.223418] Call Trace:
>> [  718.227139]
>> [  718.230783]  dump_stack_lvl+0x33/0x42
>> [  718.234431]  print_address_description.constprop.9+0x21/0x170
>> [  718.238177]  ? free_irq_cpu_rmap+0x53/0x80
>> [  718.241885]  ? free_irq_cpu_rmap+0x53/0x80
>> [  718.245539]  kasan_report.cold.18+0x7f/0x11b
>> [  718.249197]  ? free_irq_cpu_rmap+0x53/0x80
>> [  718.252852]  free_irq_cpu_rmap+0x53/0x80
>> [  718.256471]  ice_free_cpu_rx_rmap.part.11+0x37/0x50 [ice]
>> [  718.260174]  ice_remove_arfs+0x5f/0x70 [ice]
>> [  718.263810]  ice_rebuild_arfs+0x3b/0x70 [ice]
>> [  718.267419]  ice_rebuild+0x39c/0xb60 [ice]
>> [  718.270974]  ? asm_sysvec_apic_timer_interrupt+0x12/0x20
>> [  718.274472]  ? ice_init_phy_user_cfg+0x360/0x360 [ice]
>> [  718.278033]  ? delay_tsc+0x4a/0xb0
>> [  718.281513]  ? preempt_count_sub+0x14/0xc0
>> [  718.284984]  ? delay_tsc+0x8f/0xb0
>> [  718.288463]  ice_do_reset+0x92/0xf0 [ice]
>> [  718.292014]  ice_pci_err_resume+0x91/0xf0 [ice]
>> [  718.295561]  pci_reset_function+0x53/0x80
>> <...>
>> [  718.393035] Allocated by task 690:
>> [  718.433497] Freed by task 20834:
>> [  718.495688] Last potentially related work creation:
>> [  718.568966] The buggy address belongs to the object at ffff8881bd127e00
>>                  which belongs to the cache kmalloc-96 of size 96
>> [  718.574085] The buggy address is located 0 bytes inside of
>>                  96-byte region [ffff8881bd127e00, ffff8881bd127e60)
>> [  718.579265] The buggy address belongs to the page:
>> [  718.598905] Memory state around the buggy address:
>> [  718.601809]  ffff8881bd127d00: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
>> [  718.604796]  ffff8881bd127d80: 00 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc
>> [  718.607794] >ffff8881bd127e00: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
>> [  718.610811]                    ^
>> [  718.613819]  ffff8881bd127e80: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
>> [  718.617107]  ffff8881bd127f00: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
>>
>> This is due to that free_irq_cpu_rmap() is always being called
>> *after* (devm_)free_irq() and thus it tries to work with IRQ descs
>> already freed. For example, on device reset the driver frees the
>> rmap right before allocating a new one (the splat above).
>> Make rmap creation and freeing function symmetrical with
>> {request,free}_irq() calls i.e. do that on ifup/ifdown instead
>> of device probe/remove/resume. These operations can be performed
>> independently from the actual device aRFS configuration.
>> Also, make sure ice_vsi_free_irq() clears IRQ affinity notifiers
>> only when aRFS is disabled -- otherwise, CPU rmap sets and clears
>> its own and they must not be touched manually.
>>
>> Fixes: 28bf26724fdb0 ("ice: Implement aRFS")
>> Co-developed-by: Ivan Vecera <ivecera@redhat.com>
>> Signed-off-by: Ivan Vecera <ivecera@redhat.com>
>> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Bah, forgot to mention in v2 that it's an urgent fix. Tony, are you
> okay with posting it to netdev or allowing it to go directly to
> -net? It's been tested by Ivan already (I had also asked Konrad, but
> he hasn't replied yet).

I have another patch to send as well. I'll send that and this one to 
netdev today.

Thanks,

Tony

>> ---
>>  From v1[0]:
>>   - remove the obsolete `!vsi->arfs_fltr_list` check from
>>     ice_free_cpu_rx_rmap() leading to a leak and trace (Ivan).
>>
>> [0] https://lore.kernel.org/netdev/20220404132832.1936529-1-alexandr.lobakin@intel.com
>> ---
> --- 8< ---
>
>> -- 
>> 2.35.1
> Thanks,
> Al
