Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7DE65F90E
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 02:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbjAFB2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 20:28:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbjAFB1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 20:27:44 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E423B78163
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 17:21:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672968079; x=1704504079;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Gjag4xNe3BGmQIQ51dVgVOq6ycugHFryjcg98uiizCM=;
  b=g4pqcL2TqzUQUnvmZ3DoJn49l9kjw2p7UJXotZYToZu2g+LS+EZsMTVw
   WeRlFysF1jV+v/aYkofn8UyhPZpMZr4WR6FV1aTx9yy3A0IH5tdl0jmY4
   miakRaEwtMC5GpqU6Y5esj9ZH72xJ5LEbVTdWIqCmXFTHPmgCgVRInb7o
   AFmcoCveUIXJaPknBxpQsRwNHx4hA3lZbzQl7ekJyBiEPu6vQcU/2kayG
   jv9fQM0/jA6GmgxikLjm5wg1u7zBgw19gvKF4Bb2dpYII5A++qVJg3UfO
   90geTWNlZafimxwH7Vo2ygHtq/F8s/Qr+gR50X38J+kxMkI//5Ku/nfBk
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="386820155"
X-IronPort-AV: E=Sophos;i="5.96,303,1665471600"; 
   d="scan'208";a="386820155"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2023 17:21:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="798118980"
X-IronPort-AV: E=Sophos;i="5.96,303,1665471600"; 
   d="scan'208";a="798118980"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 05 Jan 2023 17:21:04 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 5 Jan 2023 17:21:04 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 5 Jan 2023 17:21:03 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 5 Jan 2023 17:21:03 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 5 Jan 2023 17:21:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OvRvWb/Us7qE9XZSmKn/05uUuSMCRhwHYo71YDtx0VIokYLEuby0NAa3u5ODlOfx9RYrhguqjcpoQhe0PVP+kaFdV3eOX0D2EVqedzyGu9MX0YDrX58287iXJRhzUBFpk5ZGwTrSa4l/yFhikmQ8ZsoCna/UxADq+g+fStJk2VrvDR3lxxQFAuXCA10S6IRNYBPSTiwTHjTsHs293cF5GiKmXja1qcOZIpRBux8Tnx5TbrS2IsPv3XBKUiMi05W2TIaGlAYfQghoaf2/QiQFuir2KbAvPKQYnguxJCU8zAAeSxAgwj0vNB0TzG9Xc5GKBNlDEAuP4h2EVFMARxUEWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/c9MPf5KvJC3WW6HHMyX2ToIWWZWXp25L0FypxN4n8A=;
 b=DdZSwVStRZwSJiTxtEoxPSvbwK+yijLKqcKpWcSzG1Jby0AoUi76sQ+rY3ahO+uGgZQQPWZWHKA2pdBj5kvdw116ZvZayxQy6j5vYDXa52NDoU8cz2c5DBOY8hY7W1O8d56dDGJxwOu1HBJY6bCBMYBl4Iwdy/QdRjVvpBM+pC1io6tPWQfgayWgWNMlYRWFI/pEDQbN4EZtJnxXIVIDciIKZNh9cSWLcUBciYLfj2SWRZmwdYzpH3b4mGpLo5Lw7YA8H67kHA8qceDu4PtwjfdFQp7HglBZ0pP4TEP+9aiikj5v6P0ObUJIm4q1EPoQS6yyM+lXY8y4ujYqDf66mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by IA1PR11MB7917.namprd11.prod.outlook.com (2603:10b6:208:3fe::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 01:21:00 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::6ce9:35:a5db:f6dc]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::6ce9:35:a5db:f6dc%6]) with mapi id 15.20.5944.019; Fri, 6 Jan 2023
 01:21:00 +0000
Message-ID: <153c38bf-f16b-cd6f-0c6a-8db226769159@intel.com>
Date:   Thu, 5 Jan 2023 17:20:58 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 00/24] Split netmem from struct page
Content-Language: en-US
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
CC:     <netdev@vger.kernel.org>, <linux-mm@kvack.org>,
        Shakeel Butt <shakeelb@google.com>
References: <20230105214631.3939268-1-willy@infradead.org>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20230105214631.3939268-1-willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0040.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::15) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|IA1PR11MB7917:EE_
X-MS-Office365-Filtering-Correlation-Id: ed0c87e6-1957-49b3-fd4f-08daef844534
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eHGnKPrhqCusv8S41oNYfZ650ntry++APSBMu+mrmLyWuM7lg3xX9FmxLWDPzojfODWX6ZHE2sOaOP+bWuVJAIip0sw5wfFVPDrYJM7qX7W6qzDf7XR4Qwx5M/2saUisjJC1ePi5C5/NXshYM2MACASiDioeSlm8/IC7kqSXQ0/UOs/ImmMDBZlTJH2mn0IfkibGfJt4nqvzjZoVxC8Uyli4WOqaUPGI+CxdNoLTYNv+aifVE86lrNGIowV9muxE8rZ4Ck5NMyhGK+KyVR6OiKpHTmZ6oKli0RKTGQ0UYeUdEy4WEa9vZupLhXALEYsbARGpOojKPLnwrwix2lR4+ZukhrlO73UkbgsHIALD1HBKjGNbtPTPNqtiNrB/dJ/4P/2GirW0f4F2hOySbd1BDsA0EmqndmDdhNAlcuRwzINpg5v+NL5/UBswhFvbvV/7p6DlBjU7wSRmzTtpTEe+gGiX2ftwPCJmKW47ew2Ve70rOFlvMj0u8lp7me6ArCfVctQu3YTrL5zD6QsCtWLzagHDWk5vkodVZ/kFljIrztJlvBTwlBbozqNfXCFcR/GSV8YUNmBVKdilO4XNdYSSvtEHVNljCHXThwxiO0sGB2sjdBK1ixGGbxLdklNn3nxUXp0y/nZOXO5gE2m1xKJtE/LtbG47WM7+CbB2OEixqHDTHjFmOhLLO5G+SYpbur5zRxqUwRXGew937QiuTs8YqI2/FxCUcN5XQKDwngwCHiY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(396003)(346002)(376002)(39860400002)(451199015)(36756003)(31696002)(82960400001)(83380400001)(8936002)(44832011)(38100700002)(5660300002)(2906002)(4744005)(86362001)(41300700001)(6486002)(31686004)(66946007)(4326008)(6506007)(53546011)(110136005)(66556008)(66476007)(2616005)(478600001)(316002)(26005)(186003)(6512007)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cjRYTDFQZjFkNGRqcjN2V3FLaitzcHpmbmREQytESk9MU0M2clEzSDlXUSs2?=
 =?utf-8?B?T1F0MUV5N3J3c052d1hXbjdqWkNsTG1QWmo3NGgycWFkZUVXN0YrVmcwZ0t0?=
 =?utf-8?B?SFkrT0tUMktkVHBNODd5bm4zS1Nua2tSelJaeXZGK0VMZUttZG5mbGVCN3NS?=
 =?utf-8?B?NkJmKzl1MmtIbHpUNllzUjd4Z2ErbXF4aU1haTY5eWl6MkR5TjFhVURCRWk0?=
 =?utf-8?B?K2FuU0hIaGp5d2NVN3dpcUMvUktlQnBNT0VJV2c3cmRORUMvQ0RXV3lOVzla?=
 =?utf-8?B?eVcvNDlTYlFka0IyUnNNV290anFMSmk2TlJidllPQlcrbFRhSUU0cENlVzVW?=
 =?utf-8?B?enFqZDVYR1g1N3ZEUFdsekNUV2RZcTVWdXMxQS9qTVhYN0xkelEvaTlPaE0y?=
 =?utf-8?B?ME12NXBtNURkWUIwa2NZZUw4MlVDWVNodE1VYndocG1ZVXZOSFBLbSt6N24w?=
 =?utf-8?B?WEE2N2o4UE9WaGRxQ2VacnFuUHNJQm9JbjN5VCsxcklJQXppanhvRnBjbndD?=
 =?utf-8?B?YTRkT0U2QTUvTHl1MlhZVmhuVUpoQzdwY214a0o3YmNMem1VeHZGcGZOblNL?=
 =?utf-8?B?TzdtT1QwMUhUbmx4NjU1NTMydFZuRkg1RTBvQ05SbnkydWk0QmowbkhCenlR?=
 =?utf-8?B?STlpK3ZWcU1vMFFSVEFReURBVjUzbUpyL1RId2F3SXZublJwblhnOVNnczM2?=
 =?utf-8?B?b2hQdHY1SlFEazgvc0FBalhVOTVUeDEwem9TTjJmTWhzdi9kNld1K0VFMjZx?=
 =?utf-8?B?dUJWOFlMVkpMOWNmdlBVQ09tQTlqdkIyYnFKeUZXbktFVndPbk5IRU1WVTMv?=
 =?utf-8?B?SW5uc0dyeWttcjBNWGdzUG9PREFXNTJlMnNsRmR5UElEVjRaTUhFVEFLTXBZ?=
 =?utf-8?B?Qkx2WHB3OXh4Rncxb1F2aWtoMTlXUjZSTC9zZ2tQMnpuL2lSdFhSdHRDQTNO?=
 =?utf-8?B?SUtoM3FaWnVsMVdkTlpERDVIeXJEaUVXQkhaQ0l5UitXSjNSYVB4b0g3aTI0?=
 =?utf-8?B?bmcvbXpreHZYeEt4dXhkUGJFeTQyeXJySEJOWEgxL3F4Sld3NnFINFQ4WU9R?=
 =?utf-8?B?T0VnMTQyVFpaVXc3MDFzdkwvbm5XYkpocHVHblByRG5TTWFXL2YzT2tiOTVy?=
 =?utf-8?B?T2hFZHpzWlAweDFSdWh6YkRERUNLSXdpangzWVhhSDJqVDNhOTFPZGhqUnRI?=
 =?utf-8?B?Qks1bzJuc00wdUE1QzBrUnFlT0JHbjdaUFI3YnhmaVhWVGh5bDB6V1J1Q1hZ?=
 =?utf-8?B?MmtRNzBUUm1sbEFwa0RpRnpKeXltcitTOFdrYlJYRVp5QU5tSHNpOG9kTDg2?=
 =?utf-8?B?YUlWVmxDUUU3enh6dXZZN2MzL2Fya25UdHlNUjhsY3Y4aEhRTXZJTlhFQ2ts?=
 =?utf-8?B?WVUzY1ZOdEtxZnNna2pEampvbnl3R3VLWHNjM2xranRQay9TRUE2Z0MxSHRP?=
 =?utf-8?B?dUUxempZeFJHUWx1Y2RtU3NuYnJXT2ZyWmYyOGFvOXRwRXhTbTVkZWwyQXBM?=
 =?utf-8?B?cEtaRkJDSG0ybTlDaENoWFlBMHNSeTJ3ZXVVeE41QlZBc0l0Z2xGUjdITXlZ?=
 =?utf-8?B?QzQ1U2IrV2Qza2RscjQyQnFkam5XbjNzWFJaU2M1V2ZnU0xSVDVCeGhaZWVF?=
 =?utf-8?B?aVljRGoyQ0QvY0FtbkZ0a3NxNWs0ZFM0YlNQY01XMXVDYyt5UWRCSkpSUk5U?=
 =?utf-8?B?cFlWOXBrL00xNGVyOWVwVXA3OWc4WWVIOUc5QmN3K0xHKzh3L2R1RFh6SUhn?=
 =?utf-8?B?c3F6NEZxb04rYlZST3B4QlNOSlRaWFVhZVZTNi9SZU9sTDUvMS9KT20rS1N4?=
 =?utf-8?B?MUJyYU53Rnd0VTBOU2l3anlkWjNUc3lPdUtaMkFsOGZqbFNqTGpreXRtRlZt?=
 =?utf-8?B?UExWUURtbGJnWk5lVVZUL1JydUx0TVYwOC9XZG13RU9GbWJhdTRMa3BtVUZu?=
 =?utf-8?B?TW9UZnlOMTErL3dSNDZJWW5JWmRBR1VpNDAxNTBrNFFCU0IrWldqcU9zdmNn?=
 =?utf-8?B?cFBpUWNINFJmOTl1SmxGa3VCS0dzR0dQc2JSZWJkMGRTcWFadkd6YU54U2dt?=
 =?utf-8?B?WkhaL0g0L3IrNUNGQnNmc2xEV3hJV3Zodjh4OXRHMmVEOVFHQ1J4aElkMXZK?=
 =?utf-8?B?YncyeVJuTk1USnVwbk5tUHJrcjNZVHBoRVM0SHZ0TUtkM2VMa1JTdDk4d3Vy?=
 =?utf-8?B?Y0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ed0c87e6-1957-49b3-fd4f-08daef844534
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 01:21:00.3261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lSUzPbyyyrffeVsjZJs2jEHN6qGClB7p4fhxllY/4fGZB0XuRv36eIiluft3B3Y/VFdA6YxaJhaCsfDlGZwoVDabchD0SCtLHlfKu1N2YJI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7917
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/2023 1:46 PM, Matthew Wilcox (Oracle) wrote:
> The MM subsystem is trying to reduce struct page to a single pointer.
> The first step towards that is splitting struct page by its individual
> users, as has already been done with folio and slab.  This patchset does
> that for netmem which is used for page pools.
> 
> There are some relatively significant reductions in kernel text size
> from these changes.  They don't appear to affect performance at all,
> but it's nice to save a bit of memory.
> 
> v2:
>   - Rebase to next-20230105
>   - Add kernel-doc for struct netmem
>   - Add mlx5 compilation fixes from Jesper
>   - Folded in minor nit from Alex Duyck

I had a brief look over the whole series and didn't see anything bad 
that stood out to me.

The series is remarkably small, with many small and easy to review 
patches, so thanks for taking the time to do those.

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>

