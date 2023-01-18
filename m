Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14B1A672AC4
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjARVoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:44:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbjARVoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:44:20 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B506308F
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 13:44:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674078258; x=1705614258;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3UyDM0JKfYpXDj5jHH3Fsp55XVL4xW+/qLhaeEs/JX0=;
  b=jufariiaqpTk9LPZQoVjku+uD1t8dEWsMbg4qy7ij71CcA5B9vjIC4OB
   mhCZgX4yX8dLyy7t8WxNEdDEnJnr9Fg4Z8xzPvYplzNn2oCFIh+BMRiTU
   lCHcHnKnYMxYvLnUYmVTR1p3Lu9gqtiVO/69f+3W405fnPDjVchzyFO3p
   JXwlVzcpxibatts5SK5m+4KM6FgcNVaZN6dzQVkKS5XMOtvZ8uwzkJ/3+
   /jWKpv8Wxqsa1UkQD0D6ytIPm9OEGtp0Ki2kkz2butUCp79eMGDhPLtS3
   RTloVRCcOpE4ErPIH5cdxjBkNTH976slvfdLj8oRJsec4ne2avGO+YLme
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="305486887"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="305486887"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 13:44:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="609831276"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="609831276"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga003.jf.intel.com with ESMTP; 18 Jan 2023 13:44:18 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 13:44:17 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 13:44:17 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 13:44:17 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 13:44:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ebHH+K12nmFwovem9YCxR5z4Lg9rVUzFUBbZ8tD1QiDg4/JpmTNu9SVTvbjoJ+i4KHm0O6TUxgstQ9zy49EGrDope2o+cJbGWY9vz8zHBHYXuTdwUUa7oyj8ZuVLg/6euCrk/E3GT08vEYUSNqo7QLGsIJPGvsWPUL0VEJTeHIXgmVhV6zGyy7t1G6avcT1VBe2RrcbYueh0qIVzawxoCyBJayzDZInIISEEf0ASig0TXa72y6SVMstOlmF6uCs76XJ555L+IEeI+uTVHeYMlAzHa5t5iS0XKvOc7uO3+XOhihunAtlbTXRN/qiCch8KhSnfDhqARBlEU8NZV2lRpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UmL/DVhs2REL1WrD63tFZVHEqWs3sig9jdajsPUFz9g=;
 b=amihMU8fhlYDOO4oNW5tZAwMPRvvyyVtlfZN8jyImKdCuRr8H0iw5ERzwDFK88zA2wfFRAXXjXWGCdueLPT77RgaaB+MeGg/7a/Y3fBLTxcewN/TlFoxnewJrYDUbInr3+qDcgruzq7lZjP0pfVjOt8Zc9ey0RAWg4tFcCUBsdmRqJ0At6d3FVs2oMr9J9h+ZaohURTOlJIf3bbbm/195RjaqcT1jIRiiOtdc6Fdk7uhwOsnnaaH86D4lOfJARgw1Ry8FOe9t//zKBaGtqSxrKYI5mmLnBiFBVY7uoi2uOYN3qqLEN2x7RDuBRfp2EV2M6RPBETOGFySWI43FxduJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SA2PR11MB4825.namprd11.prod.outlook.com (2603:10b6:806:111::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Wed, 18 Jan
 2023 21:44:16 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 21:44:15 +0000
Message-ID: <d66261bf-d3f8-3a32-09dc-2dc6e88a783c@intel.com>
Date:   Wed, 18 Jan 2023 13:44:11 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [net-next 09/15] net/mlx5e: TC, Add tc prefix to attach/detach
 hdr functions
Content-Language: en-US
To:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
CC:     Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
References: <20230118183602.124323-1-saeed@kernel.org>
 <20230118183602.124323-10-saeed@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230118183602.124323-10-saeed@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR16CA0028.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::41) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SA2PR11MB4825:EE_
X-MS-Office365-Filtering-Correlation-Id: 798497db-413f-4607-9b6f-08daf99d2552
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8vGqcjn+kohtDxJe1/sbOfnpNfUwlkp9A2UNpnZO6prqMu2PkqbmOkSaehCGlxCMg5I5iH/eW51cK5NRQJE2T5vdSfIWHLqzoVnqMC2HQArkLC1Z1ZdOJbei59pJ2FmIvUsVW2o1Y8OAwL0hY3aPjI5phRWsS0EWjkaHNtz+EJyZGb6D0VGx1TTrLMKwmYlp3pHUvkUw0mn2owdWDQPG/xH3GUYZTi6Vh0oiH+eErWHyOZUPVPY7gXqN/nTiXeb+j8/lrFzS6hrwm1JlH4URnPVklUWtS6k6yVZNINpyLlX68RdACDaEFYzNTJ7p07oum9jdzYe8LjAHCpfoqc8BM7EuqFzpnONieILg4CXMr8vkW0oMCI763lL2DCFPrJUS3OmNaBszSRJevHqymcpYrOrWz8mV+1AQBsYyWyjXAg/yoVjL4yrAd9xTrh2unBKGvPX73u9ryGP6m1/e6nGpShgENyFMswmJpkbyBOW63nHYB+/hjWuPGxAPsgR7OOSrz4NmNgNAR8POr9BcIbDGMasUuHFMM0yAzhhX5LLCEehi1Q7UaYkLhiDP+YdoA/1h5WFVetsh2PdFhYYxkDIPExEmXhBnGYEnvsIoQUysRz+HHxeNzZTOR03+oNPmlEIWm1Tqnm/05DUfpz01lDLUQSYi9YqVDeAtCZfeLg14msyTvenvMdGw/9h0k27mVypvKes3o6e2AA9fA06xx3r6heAJnT0bGiw0zDI4dsiloqE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(366004)(346002)(376002)(39860400002)(451199015)(86362001)(31686004)(66556008)(4744005)(66476007)(7416002)(8936002)(5660300002)(2906002)(82960400001)(31696002)(66946007)(38100700002)(6666004)(54906003)(53546011)(316002)(110136005)(6506007)(6486002)(36756003)(478600001)(41300700001)(8676002)(4326008)(186003)(26005)(6512007)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WkV1UXZadHg0b3p3ZW9LUFdhcmlQWEQ3cFgvb2RQWWVEY1RzT3VVNVpFWVB6?=
 =?utf-8?B?S3BuYnhUZ2dMUHNaR2xtTWhwMGlMOGR5S0NpVzU2enZ3UDZOSEJtVE0wblJB?=
 =?utf-8?B?MUwxMHBzZHFYTHZTQlNGMUpZWnM5RWVNODFTTmhPcVZMTkVHRHNFay8xVS9u?=
 =?utf-8?B?Y0hJZjJOclZIL1VDUHlxM3JLa2NCRTIydisyS2pUb1lySWhoWGNyaTJtVzhY?=
 =?utf-8?B?a1BKZ1hwVzJKS0xYN3E2eUtNbUZqRnhuN1dSZkRqaUgrbnhvRmllOE91b29P?=
 =?utf-8?B?WXlwQWdaMHBONTR5K0hLTnQybHJMRVM4cTdxWnRoVWhqYTQwVitlbUVJSy9X?=
 =?utf-8?B?RkhQcWdHOHFwek5QZEFwWTRpREtWTkl0Y0M1RCs3WFd5WTQwTkNzbmdHenJN?=
 =?utf-8?B?WGREM3pnRUYzcExZTi9xS2h5MC84d2xXL2lhVzE4NUxXd1RrbmZDQ1Q4aGE1?=
 =?utf-8?B?TUVvakZVVDlFRjExY3ByM0pLNjI4d0FyZWM4N2RNQm16bVhOUVM4RGFSditw?=
 =?utf-8?B?TXplUUlBSk9GOS9xWkc0VTFRVVBKVkNWRW0vNTY2T1ltZE5rem1wMkxlNHdz?=
 =?utf-8?B?U2tuRTdlallqT1M4eEwxRzN0MndDWWtNVnR5WkwrZmZRWGE1bG9CcEE1Q1Fu?=
 =?utf-8?B?WUY3R01oTmZNdnRwbG9wakozZFAzMFUyS2lRaUN3WjZQMjZ4RXFCUWlERTdP?=
 =?utf-8?B?ZTdUUHV0eGFvanUvbVhVSitrd2hHcFVVSExka001dXNabjlsNFYxYnJrQU5G?=
 =?utf-8?B?d0hWN0RhcHA1bG1VTVJMTjY1U3M0VjJtSS8yT3UxNzdJbWNiZit0M000SkRX?=
 =?utf-8?B?VGVCOHB5Wk1FWTI3TTR6R3BlNlZPTlVtdU1iTVI1V1U0WU56b20wMVF4Z2tN?=
 =?utf-8?B?MW5zQWErdDZ2WmdIUStpRXZnbUtHcDJycmxVZ2NwMDFNMkhPM1NHWVltRHo5?=
 =?utf-8?B?Nm1DQjZJdFNONTd2dTM4YzF2WW14QzVwdlBvY3N4OW9NcW1pNWQvRFVqQmxN?=
 =?utf-8?B?TkdiTlJjZFlZRHhBemFxdFlkVjZTQ2o3OEdTNmNrY3dBSkswaDBvbnVJSEty?=
 =?utf-8?B?bUk0bUY2RTBJOUMzSVdYT01aazh0UHpMaW41eGpyOFlRVExHUUx5YWx1NTdR?=
 =?utf-8?B?OW5jTVZhZXJjVzBTckltT2lOZjlRS01MSzNRTHdabnV4VHJMZEwyOThrc2wx?=
 =?utf-8?B?NWFERWt5QW05TDdJcmpxK2hUYXpNcTM2UWNUY1lab3NSdVJVUTBVK0kyTmdK?=
 =?utf-8?B?N0tBdEZZRFhkcDNPQ2tZYkRFVE1RL0MxcmFQMHJkMWMrVXNsU25DYk4zZ25O?=
 =?utf-8?B?QmVMWGFmWVFwcWVSUHl6SGE5VVBuWDB3eDJpbzVnSFR1d2xQVElsSSswZ3BV?=
 =?utf-8?B?bnR5akNLNDZvQThIWmhnRkdORCswaHBOUXhDOG5UU21ZM3BObjRwUG1jYm0v?=
 =?utf-8?B?aWtvb0loTlNUb3RCL1Zzd3ZZRjJpT0tQMkFhVTQ0TnJDTVJMRzdpeXVFMWNu?=
 =?utf-8?B?NFBDODNQZGQzUDV5TWFPd3VMSVNMblpaSjlEZ0U2Y3NYOS9wWmZ4SDJtOE8w?=
 =?utf-8?B?ejAvSUlTK3Z5cDY3ZGYrUkZrcmVmM1U1NzJDV3dzTktVb2FrSEdpN3FIRncy?=
 =?utf-8?B?bHgxV0E4NzhTYzFiQTQveXpUYXp4emlETEd4MGtWT3BObEQxQ2ZKWWRlUmZR?=
 =?utf-8?B?cW5HdXMvd281OWI2eVBTR0IrOEJFWVd4emVSQ2RDU2hveUd5bGxNUWlNbFlY?=
 =?utf-8?B?OFR5emNyeS9NSDdZd3h2MGh2Sm9BdHVSSGp2dnlIcW1pN284bDMvNGtQK1Ur?=
 =?utf-8?B?WURGQnlLZExhWWxvUUxFY0JMQStJNVJURm40b3dscDJ2RXJjNDU3OFRYbnd4?=
 =?utf-8?B?cGpyd0RDczRneDBLdVE1U0Nac2pYUG5WWFJJNy8rQkJZa21rdjhMUjJKeDEv?=
 =?utf-8?B?ZUVJUWQ1UzlYSU96TGloM0NuaVA1RGNwQkJleEQ0MVluRmxSYTFUeHVUeFlG?=
 =?utf-8?B?dXFNK1lGM25icDZGd1VSU3E2QTVxNzBQK1lIaU1MYThWRWlzbGN4cEdFbTZz?=
 =?utf-8?B?eGl0T1RXa2JwL1pPNXZqb1ZpZzU1c055Lzc4MTdSVjNhTnU5N3F4VjNIbWFU?=
 =?utf-8?B?d0IwWDArb01hejdNQWpuQi9NNlNWODNBQm1rREsyUTNOditiZlpWL0RsZGx4?=
 =?utf-8?B?c1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 798497db-413f-4607-9b6f-08daf99d2552
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 21:44:15.8792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H+ko0FcY1v7GBzYEiaiAoam5R74v9a1Oc5FLgjo/bzeEGBB/xIG+9FZJUfIIwrORm4QxFoMNB5WCMktCVFdLuG1l4bm2O3Av/QxjwaQ2/KI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4825
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



On 1/18/2023 10:35 AM, Saeed Mahameed wrote:
> From: Roi Dayan <roid@nvidia.com>
> 
> Currently there are confusing names for attach/detach functions.
> 
> mlx5e_attach_mod_hdr() vs mlx5e_mod_hdr_attach()
> mlx5e_detach_mod_hdr() vs mlx5e_mod_hdr_detach()
> 
> Add tc prefix to the functions that are in en_tc.c to separate
> from the functions in mod_hdr.c which has the mod_hdr prefix.
> 

Makes it a bit easier to distinguish the pairs.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
