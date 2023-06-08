Return-Path: <netdev+bounces-9394-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79037728BF9
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 01:48:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AFE502817E8
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 23:48:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAE1F370DA;
	Thu,  8 Jun 2023 23:48:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2BC1953A
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 23:48:13 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A082715;
	Thu,  8 Jun 2023 16:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686268091; x=1717804091;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SS3tGqT2jxeKbJCIIXoxiUIC7TstFYV4q/LJUZl+Zgw=;
  b=RX4tdVd9hJbAzO/yM35mc1WLeLpLoLiJwFdSZYpbPLhzjUFWq7+wxzKr
   aPrFRNJ4Ta6+kM4tfk29oWujBUT7f1NmExuDyDsQYl+xmsSnN+5OOJs2U
   GbAOpK/KJLPB+wF/iN/zy/IudB2ff9rHFlHZOKMsxHs5CEdWF1MCk3iEd
   PsuAKzroRCNeyKlr60rkTA9rDv5PuBa0CE2yR6ZyEDPunY2YLSbmWHdNc
   NJsgHxUslXkRtYPtKDTz+FrrRDujiyU/7H+6Hi/hWBbh1cEdu0Dd/0GCj
   VpBaQH2O2nuqNc2OvvqjFEHkQhA+kLUxRelY1tv21k62SATM8zJm63bMk
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="342139749"
X-IronPort-AV: E=Sophos;i="6.00,228,1681196400"; 
   d="scan'208";a="342139749"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 16:48:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="713290349"
X-IronPort-AV: E=Sophos;i="6.00,228,1681196400"; 
   d="scan'208";a="713290349"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga007.fm.intel.com with ESMTP; 08 Jun 2023 16:48:10 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 8 Jun 2023 16:48:09 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 8 Jun 2023 16:48:09 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 8 Jun 2023 16:48:09 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 8 Jun 2023 16:48:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VA6iEOeqUu7P3kAUs0/nWuneugNEcbKMpAh7Vxt3wqaYYbmXx09hEL0Foul66fR21GEF4yjSwJg9NI6RD075Yc8s2oPiZmZ401sqqI7MiFrUF2cCMLsTdLkzl4sgNmQD7X6gkkNq1Lcd/IcV/IiIZK9hQxCIiLtNHmx0Tc1+uOFJ+Y8tRe4Ckb4A/KU7W7jvPV+oSbprHkW4qlRNTdeBXIjeKTlYFKxO+RXZ8V6/IgPRsubDTRCWRZUFVkjN3tPwI90Y68VCxokskbTerZrU7HnWAcUTf8g2fgexDOBKm5r9FghbB0EGsM6S3ES8DIsk2f4KAcVbBPGtLDjrcPBVnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GUs/9gOgdngwgmzzfOay8HL3WP/yDIjCXuZjMpqq5RM=;
 b=WRuvlCpigQY5a63xbOPkyHFmu++zffcnbyoi9d9aW7QnaYtXoLh3KHYgC3FKzurCPLkHvWtf9y8R/OX5kcQEyK7maHluSUvaUStOXLnkrYa1r34GKx4BmGiz+M6TDSnTFd8uF7NQGbWsgwLAbiAreZCSOQOcRgpzdJsHpI0PGpr4QLb6zp7yOSieO2wYfeN4OKlaQ/pPuTU9eUqHVZJb6hgTwvTxzXydZOFxbV8fFZelHfmbkbQ1jmAZ8NpVxuLjVTdZjxWeyDRqPMV6yRoq9kfXXxfoLDU4o6G/ouQ8NEPAiPNGAOyR4b6fd/sdSVu3CvpT2sw2mRWB7UwYP/Zklg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4886.namprd11.prod.outlook.com (2603:10b6:510:33::22)
 by DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.31; Thu, 8 Jun
 2023 23:48:03 +0000
Received: from PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::b3c7:ebf8:7ddc:c5a4]) by PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::b3c7:ebf8:7ddc:c5a4%6]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 23:48:00 +0000
Message-ID: <b6084daf-990d-9ec2-4fc3-dd95fb25eb72@intel.com>
Date: Thu, 8 Jun 2023 16:47:58 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [net PATCH 1/2] octeontx2-af: fixed resource availability check
To: Naveen Mamindlapalli <naveenm@marvell.com>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<sgoutham@marvell.com>
CC: Satha Rao <skoteshwar@marvell.com>
References: <20230608114201.31112-1-naveenm@marvell.com>
 <20230608114201.31112-2-naveenm@marvell.com>
Content-Language: en-US
From: "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
In-Reply-To: <20230608114201.31112-2-naveenm@marvell.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0021.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::26) To PH0PR11MB4886.namprd11.prod.outlook.com
 (2603:10b6:510:33::22)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4886:EE_|DS0PR11MB7529:EE_
X-MS-Office365-Filtering-Correlation-Id: 37b800d9-6171-4984-4e42-08db687acacf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fr0d2fj62d7t8MOA4ng6quJD2R1wC1WAWQ/3qqhTWcNyuEb4/mlTb6togvSkV37w9lvpF+ejiAp3d/wFyJU/sJ4iZ4UTAkwTQTSEC4+0uOsLRGGySAh00dSgHEvsFRykK7kRFhxUTGpecpciMczZ0yyZSYyZNIOWgVQstl7DQ4q19sTrsnneOk3672JzRvMBDLYW0NSzwTFGZU8tSJ8ffNinReNxeJTrgvYyVFk+r55GTiwL1X3UxogL3XFvBwrKFwBqRZPO8Hj9AmF/8iaULAN7GboV80EALajowKLmEr5O+slrrl0m0DFVtzRPSb1/pvNS6vF4A7RW5+MgWmOI3vJ3a9STp5PjBKPDel8/JrFcPnuzeLjTwrzkALhUc9Ytz7Kggmm567sPp1O8y7g5WT1TaPoVqg2TCjbCF+f62ta9M1kDc4gCt5GFZztVlNXlZMrL3KQanA8kw3/RM/lXKHl/w4LBgIE7JdbJaXQ28+sjdwQxYZ06rpdQ6S+4AEaKqOTTWS6mVkNsMeQM3UfAs/HwUCb8BE+Zf1rprB8wQruRjV8MO3VtWgGu1xYPh3+B6u0Rv2sTXpm7FxcgBj41QJXN0bcks+PYWGdqiMr38/FykiHwZRBojKNupB5ZTqixsbQINPYdFzDX1Zw7Da6nZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(136003)(396003)(39860400002)(366004)(451199021)(6512007)(6506007)(53546011)(36756003)(478600001)(186003)(26005)(6486002)(316002)(8936002)(41300700001)(82960400001)(86362001)(8676002)(31686004)(31696002)(38100700002)(83380400001)(2616005)(2906002)(5660300002)(66476007)(66946007)(66556008)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T2tOU040dGpVbXZFOGtmdHFhbGNGR2JoRkp1N2p6WHRPMXJCUzlCN0xhNnJl?=
 =?utf-8?B?cDl1QXd1Rzk1eno5Z1RrWURpcGk4c1U4R2R6UmcyVjJRYVkvSS9kOTcwVU5s?=
 =?utf-8?B?dUl3aEpqTms1bnlBRjVUQVE2RlM0MVN2cE5YWDB1WDV3eDAzeGJjUmpxamZD?=
 =?utf-8?B?VmhrZHVDSDkrbXArWnBPNmZlOEI2ZzRjOG5TZmEwczhtRWwvekZCNndNNUtl?=
 =?utf-8?B?Yk0xa3FJSkxsY0h6MVRxSDh5RFFKeG0vby9ia1NuNGVMeXJ3bU5sMjY3Q0tF?=
 =?utf-8?B?S3cyQURVK041UTJ4UGdXZHdVR3lkNHZtcHRPdlpQT20xbEJvSVFoS0E0SnE5?=
 =?utf-8?B?WDJxRmhGdEh4V2NMMURsR1lBNncwQTlvZmUrZzk1WkU2RjVhOGpwTkxva0lr?=
 =?utf-8?B?UU5aTmNyaVJzbFRzZGpia3ZxcDZlQlBvNE5BaU1RUTVsZDNsVWJhVjNnTENK?=
 =?utf-8?B?d2pFU2MwQkwya1dpVFRYakE2d1R0bWNjRGdoNExKUUIvVnVpMGsrcGpobkpL?=
 =?utf-8?B?anJVcHVjQVZFd2RxMGJIcndIenR2Sk5sL0t1UmhNMHdsaURock14SkJLVDdL?=
 =?utf-8?B?dVU4NHVPaFh2NU1UWTJ5LzdmMDBJaE13bks3cEpJY2gvbHN4Nm1SN1lTM0Ju?=
 =?utf-8?B?eVpWbDV3ZU1QQVlkMDcwNmZHRU84R1N4d2NaeDB1a2NwVk1oSVpOSXJhTEQ2?=
 =?utf-8?B?UzV5eDUzYi9WV2ZmUFgwSmhGelU1T1BNa1MzNkFUQ0xjeDJnUkNVS3h5Nys4?=
 =?utf-8?B?YjBFd0hUa0lqblR1T1gwMzhiR2tUL3lmbjZ5VllBcDcwOGU1NlBJTW5GUS9F?=
 =?utf-8?B?QlYxQnE4cmVhbjNLdmhmd3k5YzNCWVpSV1M2SDl0THJOQWdqUTZSOEovK3lU?=
 =?utf-8?B?VHF3dXNpaDAzMmkxbVVJNXNFWFdVRTJZU0c2OE9DanFjVzMvNzlBR3MvNVVU?=
 =?utf-8?B?SDlnU0hEUldzbTFkZlNIMklTUUJHRzdyWFFRc2lyWWtycVp2OGRVNXlJbVNy?=
 =?utf-8?B?bENWTTVmRXlUOWJQOWJGNEl3L2hTczFSYXVrU2RHWVpvMmdFMmVtSE9OUE9Q?=
 =?utf-8?B?THlUZmpYRzB0N1FtZTdoUmJBdENaSVVMckh5VG44eEhlSGRSc1NWNGh0dFlZ?=
 =?utf-8?B?WUpXK3llRnJjZWZ6SlF5eVBQOEhnSVFCdzVWN2xBaGJpUDY0K2U5dzNWcEN5?=
 =?utf-8?B?R1R3aHlNYTdRdWxsVmJxbHZpM0NwdGlEeTdvRTQrckhwMldBNU0wTVpvV25I?=
 =?utf-8?B?VGJ5aStLNVYyTWVIV2t0VXVHQ2NrL1ZKd2VSUktwUXV4ZWptczl0aGhGNlhk?=
 =?utf-8?B?a3UyVFVQUm4zbXc1YjdBcnhmQmZna2dJNUNrcXM2R3NCcjIxUVNXUjhPRXRw?=
 =?utf-8?B?ODFHd0RiN0VaWmZtN01DUFBialFZWWw2dnVSS1JpajF3cEhCQnJqSGZGdXJl?=
 =?utf-8?B?aEwyVjFDTE5SckUyR1Z5blRnUTZSeFNVYzhTaVFBdndyekIySFBpUHptd29q?=
 =?utf-8?B?UXlkTXhmdkduT2xENzVrVUpiY0hoa09za2dOZVhCMTdCY0Q1V3hpL1FXVW4y?=
 =?utf-8?B?SU9pUnQzZWMwek91WGJKdU5FYTVablhmQUNEUGY1a3liNFdDQmVXYlJxVm5C?=
 =?utf-8?B?Mi84dGVxV2YwRlptdGRhcVQ2WlY4SEcrdVJoUVNEQm1RQWZ3UFdKNnUxalNs?=
 =?utf-8?B?TXdEZFNFT3ZQKzJBZXR6bkFNc0dRaFF1eXlZVkNqMzVwVGh1SFBQY3VVbnZx?=
 =?utf-8?B?NGJ2SWpGT1d5elQ3bWJQU3VqOUZ5cTNMNVVjQ0NreG54ZXlrcElxRUJzV1dy?=
 =?utf-8?B?MFM0dU02NHJLSUVLbGhwVUN3MkFTTWFMSHFnb3pUWjFuM1M2NnRiNHZDL2Jn?=
 =?utf-8?B?UVF5ZmxCVHBxdUo2SU55Zm1uYm9acHlvZUVDbzNVNW1pbUkzREhCREJhR002?=
 =?utf-8?B?ekw4TDlNa3RvTThwNlpHOVY1U3ordEsza3hlWmJCTS9IRVhNd2wzK0FTbFJS?=
 =?utf-8?B?aFB2YXZ6T2Jwb0hZeUFtVURQSk1UM0JDZzFVbUlGa3h1UWJQeXZBRHVoUjFI?=
 =?utf-8?B?QUFrc2I1U3BmN0h6WDYyYVFHdE1JTmZrZVhGVWZXdWxyWTMya0lOZzR1YzVu?=
 =?utf-8?B?VlhYTWdSb3dKU1U2d05CUjVkU05EWlRGNCtzMnRvRXNxcnVvc29MYnVrZXEr?=
 =?utf-8?B?ZXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 37b800d9-6171-4984-4e42-08db687acacf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 23:48:00.2780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tqi0QffmqfZZ6pT1+PYQWa1H1dMZ4N1+4Ed60Hcro1HXmCoc1Qk6YtnUBXoHbB97Yh1QzBZ+rRbWyifHDAPJjzpv+KgmBhUK4C03SyiH4T4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7529
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 6/8/2023 4:42 AM, Naveen Mamindlapalli wrote:
> From: Satha Rao <skoteshwar@marvell.com>
> 
> txschq_alloc response have two different arrays to store continuous
> and non-continuous schedulers of each level. Requested count should
> be checked for each array separately.
> 
> Fixes: 5d9b976d4480 ("octeontx2-af: Support fixed transmit scheduler topology")
> Signed-off-by: Satha Rao <skoteshwar@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>

Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>

> ---
>   drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
> index 26e639e57dae..967370c0a649 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
> @@ -1864,7 +1864,8 @@ static int nix_check_txschq_alloc_req(struct rvu *rvu, int lvl, u16 pcifunc,
>   		free_cnt = rvu_rsrc_free_count(&txsch->schq);
>   	}
>   
> -	if (free_cnt < req_schq || req_schq > MAX_TXSCHQ_PER_FUNC)
> +	if (free_cnt < req_schq || req->schq[lvl] > MAX_TXSCHQ_PER_FUNC ||
> +	    req->schq_contig[lvl] > MAX_TXSCHQ_PER_FUNC)
>   		return NIX_AF_ERR_TLX_ALLOC_FAIL;
>   
>   	/* If contiguous queues are needed, check for availability */

