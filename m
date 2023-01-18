Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F438672679
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 19:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbjARSPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 13:15:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjARSPV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 13:15:21 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70EFC37F36;
        Wed, 18 Jan 2023 10:15:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674065720; x=1705601720;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qP12dg0xrliZWrJg746dgAtwnCWNeLwnsxfkBcgOLI0=;
  b=BrSQy0O1ZJXBcwyX1/ypgEezBYG5emE9sNAgoui+96CuiVTxAxpwU+bx
   1OSRdBd/Y7K94aQhcLr+3+plEcIRSIA3vVl04A6U15N6FO0hGvavZVXPA
   Ub/EOC++DcOTnTpjazJXFlwFp8SvEoLrbhHrrbWHC9xPg2ONBsCJGxODR
   9l/jvoI5PcNudr3zHOvjdCxLLr/urzkHAgGfHrlromzwO1z2sKXIF5H46
   olFCN5nFbwlwrrzkNUVNLFSCyr29A0wKoE64rHD+zsgTFKM70ujnK5yAf
   Kjklggq3fLHiYgXxU480pe78ILrpZqjHvh2PtTtB2XQytvzpqPkRCYzvP
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="387407842"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="387407842"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 10:15:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="905196668"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="905196668"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP; 18 Jan 2023 10:15:18 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 10:15:17 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 10:15:17 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 10:15:17 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 10:15:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZzbsHYkSvF02RYLgHpldp7LFs9G2/kMujUjaCMvG5nw9ajWFyxGVt9XW2jbxCEOstPuHDaKJ+pHAREvf9ty6vln42t6vqD850eZKE6FzgWwA9nn2LURTtel5RQE3t5oqm7gxzfey5/zfviJ7pxg9u+l5oA32EqiFOZXHl9oZ5/61GN+Fh47rtMar8ht3TaPBF3pppr1uo8RaJyBkMAxoTnkUOyb3NwWu3a3lAKVuqU8Nsk1deE+xgCxwWR4toc4qHVt8fORjd4HSoQM94sP+Rlk0dytp9/GP2DHN2CTtcPuU8/FFTWN/2uY2Af8kovSW0mo9rN+F3ntLvew7HP7jHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EIZmWh3rapMqIMjael6t0tPtaog/D6DOZCA7QzJmRig=;
 b=mjvxgCK3KCt4jR4PUbHE7CgERBiXf0R6A8ZKWdwyhaKV3VYOZGikkZJnPQ9/fW4ks/Hn9xSyMStPjEl3+glGCtILYBHERq6phTzhyy6o4pmlz03bwqp2eIxa+ZNKFajFmbVXdTW0MUK/u5yrIzQm5MtXCr+X60olU4ISHIdZpR2ipv1ACDmVUXszfOGOtX6gUXlCI+iVZlmh1WimLjzlURpoQya0nMEWjlm5PdhrlhCuMoq7tpOFr7OBluZ39y3MIU0WBZ3hKgAVy4e95B+NjFnI0LAaOYVjjSf6XSoUjrsV1gLhvDTXnQf1AavM3q+7fzjuV4EeVV1PlUQxFRlrJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by IA1PR11MB8245.namprd11.prod.outlook.com (2603:10b6:208:448::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 18:15:15 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::933:90f8:7128:f1c5]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::933:90f8:7128:f1c5%5]) with mapi id 15.20.5986.023; Wed, 18 Jan 2023
 18:15:15 +0000
Message-ID: <10538d3d-415e-7361-9038-e4ea70fc2640@intel.com>
Date:   Wed, 18 Jan 2023 10:15:11 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v1 1/1] net: hns: Switch to use acpi_evaluate_dsm_typed()
Content-Language: en-US
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20230118092922.39426-1-andriy.shevchenko@linux.intel.com>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20230118092922.39426-1-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0293.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::28) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|IA1PR11MB8245:EE_
X-MS-Office365-Filtering-Correlation-Id: caa1bad4-234e-489b-3851-08daf97ff27f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FJb0rMJb0eYvtuj0AnH5pBj9oMpHuGnVSAIDU+Cl7tbMLJ2AYginrdYwbK0CTcKNDYoWWgwxB/ClpBCFHAZNKx2yYOCbkOdyB0Qf7zVFIZOYGytTeYfpDiflKDRyQt8HmeDAIEsY0wnlpJdpkyVhzPxf1BJnnstFOkV9DSkvRQQLQmGVWV9chdtxcx2OaJBL4ZRWE2Oq8plxWH38HlPwIuVCHZtdXA3z98tUxInAgBZ6DB1JyblPOrF/g4pIeB6X/TB2Ox76iXq4dbHCRIBDJojt18iaqKf5yrHwZLh+HNL4pK5cSwaOBM8zp7H4iKyRVgYCLk8YoyDpRfkya46k9xr5FlMZTsWxwvrTQ8Qeec4QsT1L0dkBDqBorZfAY+adpFHKf4nz/R+WQzV7HkPrSwQHf3bu6tDQtXWrTnYckU5fKlA63udC4GCGNRXCgBc9ecwIcnhOMa4em5CsM8HQ7qjrJH0C0UYDFys1JR0Gdoo4nOpMU3lKozyPLCmbCTlKX+HoI0CWIP7ipYWR1VFP8NNC0YKE/QcQ4Nf47ej4ACpNCCNyeGMBg4GTe8XG9A45slzO0XdxjobXKghJXCueJT4dfWuYA1rBVy2w0UjgLKJs4DUSnDe9DNyj74WW8hVQwHUv9G48H5Nn/CR48q8DTCB1tlC+d9vq4bfq5xbxr+hEu3iFx24PvmKf2aCEOgZ8U/XMWp+SCEg92rcowS83qf6gV8aSbUM1unSAlciRPD8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(366004)(346002)(396003)(39860400002)(451199015)(31686004)(36756003)(86362001)(2906002)(4744005)(8936002)(66556008)(31696002)(4326008)(66476007)(8676002)(66946007)(82960400001)(83380400001)(5660300002)(38100700002)(110136005)(54906003)(316002)(6486002)(6666004)(41300700001)(2616005)(478600001)(6512007)(53546011)(6506007)(186003)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UWNKcU1IcjBiQjAzb3FUa2k0cFJzMmZKNUd2VEpiTDlIRXl3ZHB3YzZpSUQ5?=
 =?utf-8?B?aGkvMzIyeXllVE9iWUxVWnJEVkVmQXU0SUdSUjgxa0JHVWlMVktoRUxObmZR?=
 =?utf-8?B?MGJxTkZkb09zQmVhc3h0YjgvbDUvaTFRWnZnTmFLV29hTElmZ2FVSTJIdG5C?=
 =?utf-8?B?c1gyK3FIUDZKN0tIcHBUbU9kKzhIQVYxL0xBT2QxTmhJWkRTY2dnTjVrcHJL?=
 =?utf-8?B?c2MvZ1hBaGdFY0JzSUpjekZRT0I4MkVjQWNEV0hlMXYvNUE5MmZVWUphemFi?=
 =?utf-8?B?QUNuN2IzZXFMT3hOZEp5Rm4wa3NXdWVNUk1uZ3BETW1OUU9rcTFBKytvR3V5?=
 =?utf-8?B?UGtnbHBhNy8rTXRoZUsvRG95N0hmK1d1THpvSis4Q3pYM2hpK05zNElNOEc0?=
 =?utf-8?B?WWZiZ1pDa0pobzJBMVhtZUMzSEZjcSswQ01EQVZuMnViUTdSVkEyd3l3S0g0?=
 =?utf-8?B?SHJqL1A3ZlhYaXI5WWRaOGJHdDd4dFhxZFk4Y0twUGdtL1cyRlQybWdkOFBu?=
 =?utf-8?B?ZWlObUowS1JkWUxBaFZQdm1hMGxmTnp1elJNeXlyRjd3eFIxYkVNR0xIVzZw?=
 =?utf-8?B?WGlmTlMveDF3cDUxWEVwTHJib09XaCtUSkczTmhzd3BSeElJR1F1eU1lVENn?=
 =?utf-8?B?cExRY1hRQXpDLzdHOW9yNHk4dWZiSGgrL01VYXRFejFkVHhSK2Ryck1KOENK?=
 =?utf-8?B?eHo3aEJTL3MvZlJ5TDhKWHFGS1d0NDc1VStpWkh1U3VUVkxNU1prbmxmUEZJ?=
 =?utf-8?B?ZzhXV3VMTlFSalFoNGVDb3Q2ZFduNks0Z3RkUVhObHpBWnp2eDRpblUrYmRs?=
 =?utf-8?B?TUcrSStCUkY2Y0FLR1RJbUZnZVdxNVBZZXhLWmh4MHFTTWgxNGZwcHZ5NmdP?=
 =?utf-8?B?K0FTMzFKQm16UE1PVmE4VWtDck5QSnVtMkVGYitYT2o5dFc3NVJ1ckRyVFZr?=
 =?utf-8?B?bFcyVXVhRFNNUXZ2UVNIZndRVlh2NXdjT05vUGRIZHpZVkxncm5QSVZsN1NV?=
 =?utf-8?B?azFPaUQ5VVc3cGxxU3ZINVFPaTNzdkg3YkNJalBaUHlBYlNYTmU1Qy9SSjFG?=
 =?utf-8?B?VmRPbUpyMGg2cENzeXhVQ1JIZWZPSnc5ZG93dlRaTU5yWDJlOXJnRnA5bUwz?=
 =?utf-8?B?YjZSakx4ejBOTTdoV1pxWkFyOE4rRFd0SmFtWjM1amxZYzBMNnM3ZHNUT0ZR?=
 =?utf-8?B?SWJ2V1B3dzhMdnorcU5wYTM2NFl4ZnhNd2RmV1lwS090NmNvdld0dE9aUGtw?=
 =?utf-8?B?bm9KM05hYzAveWdRelBnTnp0MzF1WExFNEgxME90WXROZG9PSEg2d1Y5YzVu?=
 =?utf-8?B?TzRKZ29zdm5QOUl3b01kdDdiOFovSy90c0F5TjNTQ3ZXdHAzMFJKZU5xakNz?=
 =?utf-8?B?M0t0SFVBZHRPWER6T3U5RWFzUmcrSzdPWDdIQXdEK1EwZGJQMkJLeTFMY21Q?=
 =?utf-8?B?cmFPVUdVM2c0Z0tFZ0Y0dkxSMWdXbkduOTZZaEUyR2hQdzNuWDVZUVVDSEMv?=
 =?utf-8?B?NjJZWkpyUFF4Yjd0U1JEaXorZ2NyY280ajhxNk94RGNPdjZ2MjFTSWNERUsv?=
 =?utf-8?B?cjFZcDdqMUUxTk9GZzh2L295Tzc2aVBLNmZPb09ITXZ0RVJLZ080Y0JnS1By?=
 =?utf-8?B?Nk5veTJxUWQvb3I5ZHFTVWxUUk5OOFY5SE5jSDBFbGZJQmc3VG8xZjhiWStT?=
 =?utf-8?B?clh1SGdLcUhKSXNSNEJKMjNBcGswdWkvNU9uVFpMd2x6RHJSQTBJVGJ5R1p1?=
 =?utf-8?B?U0VJRXEveExWWGFLNFNvanpUZ2hrVHE4OWZZNUs1ZUk3dTJwOFJaVEtCYW1G?=
 =?utf-8?B?MTZkc2VLN290ay96a05jWjJqbEpkdGNkYlQ0SEtYNGc2TW9jSkZqQ09HUmNx?=
 =?utf-8?B?ZkdYcmszWm93WlVMemtHa2pXVmlRek1GN3Rqb0pYa2RJdERpR0pKUzNZRzJP?=
 =?utf-8?B?aG1rekVYanA0WE1WWmZmaExhYSsxeFZCVVVJcTRFTEhDR1QwS0VvMDNhTUY0?=
 =?utf-8?B?aXZ1alpUdlM3eVVIVEZNL2ltcnFaVGhBU3FXazFCL0J0Z1MwSnN3MHJiOGI2?=
 =?utf-8?B?dmk4cUlncDhJeGxsTTRVTURLNi90RTJGemJPZzF2QnB1MDZ1dEN3TzY0V3hN?=
 =?utf-8?B?TmhaZHNZYzkzLys3b2NNUnduaVhtbHRVdkkxYS9UdlYxN2tkSHo4QTM3dnFT?=
 =?utf-8?B?RVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: caa1bad4-234e-489b-3851-08daf97ff27f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 18:15:15.2807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p64/iwPhbB3aBA0Nl6V1bpzCMpsw/+bODL/sIgkLEcjlFQa157VP7ZUjFARQ2poH0xTLzRawCu1FTUJJVgWjRAOroxlvyPq2uuESlbcYU6w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8245
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

On 1/18/2023 1:29 AM, Andy Shevchenko wrote:
> The acpi_evaluate_dsm_typed() provides a way to check the type of the
> object evaluated by _DSM call. Use it instead of open coded variant.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>   .../net/ethernet/hisilicon/hns/hns_dsaf_misc.c   | 16 ++++++++--------
>   1 file changed, 8 insertions(+), 8 deletions(-)

LGTM

Reviewed-by: Tony Nguyen <anthony.l.nguyen@intel.com
