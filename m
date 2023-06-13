Return-Path: <netdev+bounces-10392-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A70BE72E41E
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 15:30:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EAB6A1C20C8A
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 13:30:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9D6D31F04;
	Tue, 13 Jun 2023 13:30:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54FF522B
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 13:30:43 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD6191B2;
	Tue, 13 Jun 2023 06:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686663041; x=1718199041;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=F4hrn0P255JYE1Ar+ICeKI7t7O7YUWJUqN5xCgGcF90=;
  b=kQsHtXEsJ3Byy99E+hD80zu5KkDbb/tQVOEpH40C2ILQQ0y7roPk9rDe
   inCwlmeSbS7I1/NBhJLgQOy68gKxRAjsucIUFlyxJ0jGqZGpkunfluSq/
   flqqODHTYFl4ZPPeZkNdwuPE9nojLOgQAc8D6X2fDO5b6j+GF9K3IX3Xf
   4TrBL0UQrZou8lN/4Bs3oWZ6bkTmVGMGp+uqv9isSNfiFBgJUuWBe5x9N
   I7U5TgFgGn7vi6tq+hWlrG25N4oOzxmzy9WHvkK2Z0MnidI13CQXLS27U
   f7S7LeZ/kt1KJgnFhP5R1QE3O3kfrygPiGBDItV+8g2iP78ETNsnkM0p8
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="347984339"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="347984339"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 06:30:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="801488742"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="801488742"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Jun 2023 06:30:39 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 06:30:39 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 06:30:38 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 13 Jun 2023 06:30:38 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 13 Jun 2023 06:30:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hnmZCCJ9T0MI6BcuyH7+FlXnnSDYmPy6V/Az6DHeofxL6weOZBuGLtBcN69JDEgWuLDuvos3gRZ2JUoUSSOOdcmkLerd1TgHwVauxkr6xsukh7NkMHYQXvrJ8i0CkUVBsrTojgfQH/qPOYzo/kdQ9BqB6wO6lxXFJU7YT33qant+kh19ewWyyJmPs7wpTp9scE0nsIgZ3Tfef4F2jnE1ICWI+tmHul+N7MyZVYsbWYounO/fA0vKMVPbOdlhgbAfVdXx/JceLmlFVHtpdZbB8JU3Rymr4A5YJDphiRqYvRK1Ml2KFN1xAnPGs8zrK1X4HqqO3QQr3BOb+n2aKenr/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ucsS52c8LaJb5WHjiWPWAFFUPQ61HO+I3WhlcK1v3KU=;
 b=VxD6UlQavJ2aC2eHV2IF1NI8bbFylBmDfp+B/THCXMa+eT5rYje510pUzHmPDyxHHgQgch+1bWCJMjlqRF3v4+bY3P/Dqkv/jSOOHwq+BabYhel+iylMhqv8h0dL/OfcIC2lpSrCYM3GQ7ZDHeVLXg8rrNC8WTPHvZqM2X9pabtyg20U93i9Z6O7XQ9YWZv7fay4/K1/vo0/uFGc8M9OdKTNxZ0QCGMYP1R8xNbwrOXJz+I/2NxBAPrUDdXU05BFzu62UWtOflhbS+TC8nPhXMSoM/NwTaxSpDdH2csBzsHeRGb7J+oTwoik2s7/2kXfL4jajTfwBQa02N6H+Lndww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH8PR11MB6951.namprd11.prod.outlook.com (2603:10b6:510:225::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Tue, 13 Jun
 2023 13:30:34 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325%6]) with mapi id 15.20.6455.030; Tue, 13 Jun 2023
 13:30:33 +0000
Message-ID: <483d7a70-3377-a241-4554-212662ee3930@intel.com>
Date: Tue, 13 Jun 2023 15:30:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.1
Subject: Re: [PATCH net-next v4 1/5] page_pool: frag API support for 32-bit
 arch with 64-bit DMA
Content-Language: en-US
To: Yunsheng Lin <linyunsheng@huawei.com>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Lorenzo Bianconi
	<lorenzo@kernel.org>, Alexander Duyck <alexander.duyck@gmail.com>, "Saeed
 Mahameed" <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, "Eric
 Dumazet" <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, <linux-rdma@vger.kernel.org>
References: <20230612130256.4572-1-linyunsheng@huawei.com>
 <20230612130256.4572-2-linyunsheng@huawei.com>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230612130256.4572-2-linyunsheng@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0113.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9d::8) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH8PR11MB6951:EE_
X-MS-Office365-Filtering-Correlation-Id: d5389bfa-2c85-4c39-c745-08db6c125d6c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kMXHPlXfLYb+kiS38hsJmOQ0JAdwBk8uOqx4g7O+I0JJeumWIbg7ZPNO5XIbzJVXmoJnvw+QPKDy6wBGgTa4HtTO+krUfxX+kSVBTv+KLTd00pnmftwD8Zgu7D7NmYAqiY/GRshzxKyijBp8UFWVkFgrUG+MsLeyEf7vY8EutM+d/HcLTU+lJrT0lhbnAbvD2sA0xo42PXFIs0BfahKOhxqeeERryY0T7m1zOKe5DoY/0fqqEpYVTZ6/8e+VKZLheYxkiqWAQZGWRaygYsMws7kIPCN37ugfecr/u4EFknv4dKJi8J8LGAUNNL5Gr7t25/jvi7AkuGaeigVZnEcm0OpHqf/nWpfzp3g2BNlRcL7ZS3xIxvHwFZS/FqZ/tKlGoSVTjqn18Ft7RLcjdKd6dDMyDmZOiDIh0pomzoI8SABesiyQCTwRKZwj4sZFjUWuaifgpBDnKLtvi7fx/zjIAkbmII7STTYENPxbD0KLqVYpZHX0oUSCERDfvDIIFD1D6XDAYj+ruKUMthgqNecL6dWr65gA0v1ozMn8iFCCr8hJUr5Rnzuz/U9b6OtuRMvV4/ZC7Q4kQpqPvlz8H+rlXugG+WnwNgm/9a0mBbTKZo6xomE6dgbMby+b8FttA1sLnv9ERonqB+OrJEPT3kAvxA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(366004)(396003)(39860400002)(376002)(451199021)(6486002)(6666004)(36756003)(2616005)(38100700002)(31696002)(82960400001)(86362001)(6506007)(26005)(6512007)(186003)(2906002)(66946007)(54906003)(66476007)(8936002)(4326008)(7416002)(316002)(6916009)(31686004)(41300700001)(5660300002)(478600001)(8676002)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a2VRa0FaY2F3bVpTOUpaMWVGN1VpVnRYMHc1SG5JYWkrL3V3TDBZa1JqWmJX?=
 =?utf-8?B?eUFGdXlLZmNpeWZINkQwNFh6TWVFTzMraHdvOXdUWG9GeVo5eVcvdE9kdHdM?=
 =?utf-8?B?WDI3bUhOVDNOWitJak90a1Aydmx4UkJBRXBCVjl6Z1pXM2hHWGwxb0pUS0Vw?=
 =?utf-8?B?akUrZGtPeDREQzdCMFNIQmgwVEk1UlNXZStKMG1uN3NsRkExRkJSM2FvbVp4?=
 =?utf-8?B?eGhuQnlaSE4vREJWUG53U2I3Y3N4U2FWamVqR1BIRFpmSGlKUGlxSU5iUHNz?=
 =?utf-8?B?K1E1eWdIL2hqL0dPazEyODdwaVdkdVVSWlNsd2twREVGNEN3cm5NejdvN0ll?=
 =?utf-8?B?alVRREl0RDJTUm5jdHVHYVZUVS9pRnR1L1pXZzh2VnA5WTRXUGVBNW9DNTc0?=
 =?utf-8?B?b0N6b3RDK3c5bUJMODEycVZHbUhwUG5paDdpd3pzMllVdStTVXhLL1MxVHVX?=
 =?utf-8?B?dE51dHA4UGFraGEzU3dhYU5NMFRwTFNnNThiakVwbjFRT01ySVlKMTB4NXRR?=
 =?utf-8?B?NUlOQUVuOE1oRWVGZGFVM3l0NlRoeHZ3bTgzNlpoRVdCdU13L2FtckRXT0t2?=
 =?utf-8?B?cklCdXM1ZktOSkNGa0p0VVdEa3dWclNXZWpMSVQ1M0ppaDhVMm5iK1NrREtk?=
 =?utf-8?B?dmhsc2ZpbTFySWlOdWp2Zld6VnlVenB2Q20ySm5sRkNVUUcyUXRwNG9vZ0N6?=
 =?utf-8?B?Uk12WG9pZ1V5M0xZNHppTC9HNzc1R2dGSFdmRmY5YjRMWEtSejUwd2x1Z283?=
 =?utf-8?B?K3duUThENkJnZnFRMU1jOVNoYndOODlLTmE4aEQ0ak94WnZQb3hLQ2ZhT3V4?=
 =?utf-8?B?a2NvR285Qm5nUy8veUtZTXpvQ2RWdTRIUEUvMFIvdjVBbThTbkFkTzQvMkcy?=
 =?utf-8?B?dVJ3cXpmck9XUXY5b3hQTWtTV3h4U2VsdGpzYllRNGJWMXVsdHRLRWx1ZC9Y?=
 =?utf-8?B?OCszZExZdDgzWmUzZE01WTJsRGZoT2xPOGh6ZGR4WlVyWVgxeTJzMjdWWU5s?=
 =?utf-8?B?VnJsVmJ0YzllbGNUdFhrOFJNeExGZVduMXZCNnJwOFdoSk0rZ1R4SnJCNlhh?=
 =?utf-8?B?bVFFQzRMRjJlNGI2U1N1djRYSWlVVGpYeERBMzg3aFd5QWRzWnE2S0F6Y0Nq?=
 =?utf-8?B?Q0xmS0JhRU9nc0tETm1mSmt4SlZKL2o2empTc2dDdmkrZm1heTlOTEQ1emVl?=
 =?utf-8?B?THpNYisvZllCNEd0VHRmNXJVVlBEL2dEa0h6LzVCNURzSm9nMjMxdkFUSFJK?=
 =?utf-8?B?ZVhCQnRGemJRZHp6UERxS2ZDYlBRcmlFT3F5eDgwWCtUNVI4dDJHYzVUb2Rh?=
 =?utf-8?B?MWRMMjYydHpBZGd5WUd0NHZlMGtBZzBwMTdIWjMyUnZjeTFRZzZHSTFranY2?=
 =?utf-8?B?bEpYK3V1cEZJTEtLQ0pJazI3TjBQdSt0STIvNDlHZkpsNGhKVkg4enlKQ3Z0?=
 =?utf-8?B?QkFGbzRvUUJPVG9LTUVZa3gydnBHcHBRK0ZPRXQyODcyYW1Zampnb3NLVFJt?=
 =?utf-8?B?eWhJajNvZ3lTOUZTbDljaTdFMDlSSnJzMVl0OE9Bayt5QWVqNkJCVHMwSTlW?=
 =?utf-8?B?em9IQUJoN1RLQzhEVitWYlBCQURkS2RWVi9qSVpPYVIwNG14WmFHc09QM0RR?=
 =?utf-8?B?VDh5SkdWcm5PaDl4aWE0cC82YmtkdUVlS0NwZHNEclpEeC9qSTBtR1RLOW5Q?=
 =?utf-8?B?a2xKZ25iQkwydzhZamRVbWZ3N3dzWk4weXd2aG9XMTE4U0pNUUZLRWR3UzZX?=
 =?utf-8?B?Q0N1aVF2NlVMa0hjd0tjTVVaQ3dWcGtxRUEwTk00dWdHZjg1bDl5WEFpWkIz?=
 =?utf-8?B?RWlZNm8rK29VME04SERKNGVsb3hkYVoxcVAza0tPOXRTVDJHQkVmMm9NR0xt?=
 =?utf-8?B?L1pIdExWUXdaTGJacml5a3ZKRUpHdmhGemhGV0Y3Nms5VnU3ejg5a1hQdUlJ?=
 =?utf-8?B?aFpidm9GQzN5Uk8yVjNVazBMNTZvTWJndEwvYXZQT3l6aUc2bEJDdlhnajZK?=
 =?utf-8?B?U1BSVDNMZU9nK2Q0ZWRGVVVPVVhPOWdqRkEyWnM0OXdqaTdLOHJuMnFSOEc2?=
 =?utf-8?B?a20vNlNtalZQWmc1aEcreXJPaHJkTEgxNzFSc0JqTTVkTFNaL0dRSVJKRWsx?=
 =?utf-8?B?TFRRK3BodTZ4aUVyaDdhMjZRNlFxSVVIUlJId0ZJRzFkcWdKdXd3UnJ3dm1U?=
 =?utf-8?B?Snc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d5389bfa-2c85-4c39-c745-08db6c125d6c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 13:30:33.8765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C2TFOy149MQaD5qBdzG6L6AElNBj+xONKbs7MZyNueRreKcos32P/MIc3WzGE6ScoQAfRA5rKaiwTn7uaQX2Z0V55A8Xh/dLXdtcRRBk85I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6951
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Yunsheng Lin <linyunsheng@huawei.com>
Date: Mon, 12 Jun 2023 21:02:52 +0800

> Currently page_pool_alloc_frag() is not supported in 32-bit
> arch with 64-bit DMA, which seems to be quite common, see
> [1], which means driver may need to handle it when using
> page_pool_alloc_frag() API.

[...]

> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 126f9e294389..5c7f7501f300 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -33,6 +33,7 @@
>  #include <linux/mm.h> /* Needed by ptr_ring */
>  #include <linux/ptr_ring.h>
>  #include <linux/dma-direction.h>

This include is redundant now that you include dma-mapping.h.

> +#include <linux/dma-mapping.h>

As Jakub previously mentioned, this involves including dma-mapping.h,
which is relatively heavy, to each source file which includes skbuff.h,
i.e. almost the whole kernel :D
I addressed this in my series, which I hope will land soon after yours
(sending new revision in 24-48 hours), so you can leave it as it is. Or
otherwise you can pick my solution (or come up with your own :D).

>  
>  #define PP_FLAG_DMA_MAP		BIT(0) /* Should page_pool do the DMA
>  					* map/unmap

Thanks,
Olek

