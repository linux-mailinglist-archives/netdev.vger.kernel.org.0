Return-Path: <netdev+bounces-10825-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0B0C730610
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 19:27:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F1EA21C20D9A
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 17:27:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 199B82EC36;
	Wed, 14 Jun 2023 17:27:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057147F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 17:27:42 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A727810A
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 10:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686763661; x=1718299661;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6/63HzMd6nyoqlGy1/hCI50BxLlYQ0Zm6FeOMw7yblM=;
  b=PPALTcbpAoXHwXvK7x3IxL1k1LWmayZnXzvJfY0QnS+dA9mDcd/+kmgo
   VwZWH8T9OsLHGrYlbU/SZs5BFD1ha4scTlSnw/cafWjY1E6kwEVFg0Kca
   YwbA4sgrxQgriLYmRkdv36S7qaZE8QABmrntrQXPIK88DkIev1GsM3rO7
   1vPd0q61acKQR2xCZ/mVReYm2msZt2hIjmuyrX7QSBTyFlYJ0O1y++RCz
   tJx4WXWNxJoTiGjyPoP9rnFsp6SuJE73/olcn9Zb01KUTnU/cDDocVKVZ
   QQwVxehejAYYJVKFKaeH+nrIIqWbepKNKs9MH2rSnc3GBUhnRgyMlEQH5
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="343381728"
X-IronPort-AV: E=Sophos;i="6.00,243,1681196400"; 
   d="scan'208";a="343381728"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 10:27:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="741905755"
X-IronPort-AV: E=Sophos;i="6.00,243,1681196400"; 
   d="scan'208";a="741905755"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 14 Jun 2023 10:27:41 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 10:27:40 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 14 Jun 2023 10:27:40 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 14 Jun 2023 10:27:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dPSvFJ/uBKzc1alLAG4I5PJbxX97ENkWPOMU3BNhoHsF/vjjJhr8zR0VPLUhWQZw4YwvMK007psdz6HIwwt2HTj6uXVEF0rBSL1JocIhDFTBueGrdbytBWrn+mhd3EDEuXrC4yk1CFM3DRWAfWpFggAzrHnGlL1QlwKTbEb72/1eLHnGZA+toU7fm4uUJ3saqXS2RcoOzkLqgXKS3KIXf7UV+eVUEJWIP5Y8h0KD1rnUIlYutUuoEheORmSpYmLtFlrf5Uj4V5skwtmO2a4uTB9AuQ4jIygsUOt6KErxNJcT9XqqUaoE1KR9fOEhtCllp+EV2v+eEQEZHjdvG4aAKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ho8/tbF4zGhHC2UrDK3urcLVcBwLIja/aGeJbUZdqvE=;
 b=RMsRdz5DFMlMQmZcNfsFVgU27tWIRprXFCidfs8m8B9YlUKnDcyT4VAxBAxX8OryQpF2IrkbsF6twJsySsYR3vHbjRdIkFsuXszEkn0x/sORvygrPYwWyvSkAKspzpm0twnpuY+lPmCd5lMgpvjbwX6tjCGGmT+7IoGov+HtlR7wSUSWqxsS35HCHzTZwS2YoL+FUo+hIgcVTg9qYzgEDyY11DrDOh6Hul8Q7VdkgO912+eWEzpel2ZkQkMBJ0TWS4jJrRfZwXW6lLWLqLL9Ck/M5jxIVsgBfZ8diL3eFFJbYyb+tArzNIWUkPTGsyOwCmEdWiNLJWAsU06UE4pgtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by IA1PR11MB7197.namprd11.prod.outlook.com (2603:10b6:208:41a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Wed, 14 Jun
 2023 17:27:31 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bdec:3ca4:b5e1:2b84]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bdec:3ca4:b5e1:2b84%7]) with mapi id 15.20.6477.037; Wed, 14 Jun 2023
 17:27:30 +0000
Message-ID: <cb2b26e2-a716-eddd-c182-744437591d66@intel.com>
Date: Wed, 14 Jun 2023 10:27:28 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH iwl-next 0/2] iavf: make some functions static
To: Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	<intel-wired-lan@lists.osuosl.org>
CC: <netdev@vger.kernel.org>, Ahmed Zaki <ahmed.zaki@intel.com>, "Maciej
 Fijalkowski" <maciej.fijalkowski@intel.com>
References: <20230613141253.57811-1-przemyslaw.kitszel@intel.com>
Content-Language: en-US
From: Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20230613141253.57811-1-przemyslaw.kitszel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0158.namprd05.prod.outlook.com
 (2603:10b6:a03:339::13) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|IA1PR11MB7197:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fc9304d-95a9-4d5c-46ea-08db6cfca1bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tVvyfDMWaXGYuw0Ldn9V3RDoOzQ3bKYf4EqT9btUbaNIJJ2aMuE7d06+PC7cFSId2C84YSt9ffRJWiC9iw05x+IBL2QnDIajYwxSvP5EQuGXseLj+wg06H0grN6kmjVKEt50Om3NwDzy2/f8nUWEAiGvkdO6Kw35gz5xtq2Q5zBw3/H8ZAWvhWYoLc1zJ6q71MSsu5E6ivialO16GCk6BLKIsfV6g72J0vjS3gofUh7eU9uNsAbwuI42WOE3w+RZGw/GY3NKp3x9Mvf+gnulJC8cQuSlODAgMg2OHXdrKLJdrr5nBJhc3uXXe8A+GnNiLp/kMRD6Yq5QtEZNQci8ThF7FR/T3C7lvAaQtiAi252YqfGLPiEiUZB3Kune0q/3cztPRFUINrRYii6wE2yRpdpWe6MWdqsAMNIjvUoGRlv2ltoUs8V2a7LxMSocc9O1+DhPvynvI6Ux35vF5tLMPmVG6u/4KaJtztO5yZ4zp/1TnTaQVG0sHqS8zr2+KLSqtbCiFNUBPEg9AqYcMaAS/cJ3/L77m/QNd3S1SIIrf8FfQ8MLHVE6YYjp80/VBwfhHAPUumJBMOKQBePMJcgw3qYfHymlMTOm1feDGyQfWval0iUhniI/yfMBpa+e2LvfL4rPJPrh9ygvQDxmrGk0OA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(136003)(376002)(396003)(39860400002)(451199021)(83380400001)(5660300002)(186003)(6506007)(2906002)(31686004)(4744005)(2616005)(107886003)(41300700001)(6512007)(8936002)(26005)(8676002)(6486002)(316002)(31696002)(54906003)(53546011)(82960400001)(36756003)(478600001)(38100700002)(4326008)(66556008)(66476007)(86362001)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eGxxN3pldWZkL3UyMG41a0FiUTI4VVRQdGRuTzU4SnhLNUpYVzIyR0M4Vncx?=
 =?utf-8?B?QnprMHlXaS9hUjdIZlR4VXdDL0N1Sys2WVhOQU1DWE11ZGN0UGNqR3JmWWFu?=
 =?utf-8?B?dDd3U0tkMXlqcU5wL3pDTllLTGdmOTRSRnZQYlJwRGhhSzgzeWlNNndHUnlo?=
 =?utf-8?B?N1diLytHSlBRejA3QUVQc0daWkhBY042em5lU3IxSnoxY3JQcmtDSTNEY3Ry?=
 =?utf-8?B?L1FyNGlsK0NyeUd4eSt1V2xrWjJBWi9XaFRSWUhjdkJ2WjFodkc0OUJObTBp?=
 =?utf-8?B?aW5EM0NHei9od1I0NGRPUENIdDM0RU4yVHlQRHF0UksyVGVWd2RiQjV1dVRF?=
 =?utf-8?B?Q01DUkdRN2JXS3RZUG1HRkZFb2NPc1o4d3gxZVE5V01SQUJkdkJsQnB3V1Ux?=
 =?utf-8?B?VnM3S1VMYkl2dmkrcFR2VE1GRndmOGtCMG0vazVxOTBiNWNNWnlHM25XTmZh?=
 =?utf-8?B?WFlPdXVNYzcrYnJteC83MG9BT2NOQi9DRHFPZ2lDcjlDWE5kak0rYTNGb3NT?=
 =?utf-8?B?cWJRbkxENFJxWFk0RG9BUzZFR1phcWRWdXJwZVdlTUZsUTVmU3NoTFI3Wk1w?=
 =?utf-8?B?V0hPYkR5U2N2dW1SUk5nNDhOSWhYWmtiR2xVd1VJbHdrbGNZT3VMdlpLTDdQ?=
 =?utf-8?B?emV0WU00SkpqdWpzTzdHWFl4bEZWcnVkOVVmRUFNU1FKT3ltOVZBckNYS3NM?=
 =?utf-8?B?UzcxbUFwTFh1YzlMU0hPREl0ZkpncjlCbWZlUkwxRDBzaEhHNS9YNXFaOHpJ?=
 =?utf-8?B?NTI4Qk1lTlpmR0RCWUVZMXFwSnFWTGlNdGZjUGRWM3dZY2FDM0gzZFB4ckRT?=
 =?utf-8?B?TGhoT2wwMUhiMGdHei9ReFg4UzZ3V3ZwMmVQQVNzM2ZiQ2pSTk9HL2Q0VVg2?=
 =?utf-8?B?NlB2MFNoRU1iQVRqcURNNTdqcVBNTUlwdlpMZ2ZzSXNkNzNlaW9Oa1owUEpQ?=
 =?utf-8?B?VFQ2ZTh4bDZxdG1FeWJPMHRGcHI5K2lwYnUyOVV3NHNnNmxaT0V3S0ZwOGJw?=
 =?utf-8?B?ckxNQi9lRTdCZVNhYXlCYUJpcFhrVXczckdtTXdwR1BnZ3lEd2Q5UFZBb3hw?=
 =?utf-8?B?TmUzZlY5OEl1KzRiUzYyOThTbTI2YnRXVitNUDM5cEVndnJPNVlTVndJYndN?=
 =?utf-8?B?TUsrZm9FL1BLdVYvQkRjbEp6TzhsTHZiVUg2bUd2L2VKUE15K3pudGZVVHJE?=
 =?utf-8?B?WDhSb045SW40NUxJU1JhN2ZJdWJGUU0weU8wcjNnT0I1SWRQNVdzV0xpdDJX?=
 =?utf-8?B?TUJiZWVVZWwyMThjVTlQZmZ6enFLbXkrUVdUNW9WVUFsdzA3Tk5RTTI2dFNC?=
 =?utf-8?B?d0kzcHJsdUJydVRnWkl1aFdkNFUzRlFyODlpV2pYVGlteDFBVHYzS2FoRmpy?=
 =?utf-8?B?KzloN2tKc3l4emlIZ0RZM0VaeWtkL0hkSjdsRlBKTEdldlBDZ2hncVZ5VFdq?=
 =?utf-8?B?Nml2OEtYbTNzTktoL3ZiNDhncHk0MlJZUmVBQjFnMHVHWVZMQjBYZXRualZt?=
 =?utf-8?B?eFZnS0R3MDVqWEtKY3BReXl3NmtDUVVjSW5WSThqQ2M3MUpUYmUrOW9MQXNh?=
 =?utf-8?B?VnZWaStqdjY0YzIrNkR3aFdDT1lRb3BkOFJ6RzRTRXJWOCtVbGZlK2ZUUlhW?=
 =?utf-8?B?b2RPQzBnQ2w5TUc1dXFtci9Xd2hEOS9pVVVzTzZtWVU1UXV2bm1ldHRjaWNz?=
 =?utf-8?B?YWY2Z21vQlJCV2p1a0hXQ0Vtakc4aXFsL3FleEJ3Wi9oUWJPaFgyeUhId3dN?=
 =?utf-8?B?eVdOUmlHTFRTT1ZZS2RBT2JjTWJWejdRQWFhRlhuSUh2c1NUalNsdVd6aFdX?=
 =?utf-8?B?SGVBUzFidW1BN2NoOFZDTUQ0QnR5SVp4TTFsOGZPbEZSdlB6bVlJZjgrUU1J?=
 =?utf-8?B?cWtjdERSTDdNaS8vVHVKdm5uOXo2WGNRUU1NSHhSS243OWNlYk9ZUHptY3NG?=
 =?utf-8?B?MFdRMzAzWjA0Sm9TY0tOWkJIQzBNN2dEcmRDSVM5Y0JJbWVGekxiSGdXTmVE?=
 =?utf-8?B?SGJUOEd2QVJGOXVCU1A0cmJrdW5KWHJKQ3ZYVytacnVxUWV5bEl6QlNTVFJl?=
 =?utf-8?B?UTZWYngzL2cyYW5BeWd6WHlHOG55Qk8rSUVQNXpWRm1FM243V1VDS2w3M1hK?=
 =?utf-8?B?bTJlczh6T0NLRHhRbXEreUlUNGdYR29VRFp2K3huMlhLb0JZR2RxSzlreWRq?=
 =?utf-8?B?MWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fc9304d-95a9-4d5c-46ea-08db6cfca1bc
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 17:27:30.5677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dz1uDoSo8jSjzPkcqhd6KrZ8rVURNeCpLbxxSS7sDasfgdHj2BP2IDqEa+C/Mi0fhGILIM9E5If+gg/3g+tvW8B1gHYBPupGOTGGfTgeLEY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7197
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/13/2023 7:12 AM, Przemek Kitszel wrote:
> Make static functions that are used in just one translation unit.
> Remove all unused and unexported functions.

This doesn't apply.

> Przemek Kitszel (2):
>    iavf: remove some unused functions and pointless wrappers
>    iavf: make functions static where possible
> 
>   drivers/net/ethernet/intel/iavf/iavf.h        | 10 -----
>   drivers/net/ethernet/intel/iavf/iavf_alloc.h  |  3 +-
>   drivers/net/ethernet/intel/iavf/iavf_common.c | 45 -------------------
>   drivers/net/ethernet/intel/iavf/iavf_main.c   | 34 ++++++--------
>   drivers/net/ethernet/intel/iavf/iavf_osdep.h  |  9 ----
>   .../net/ethernet/intel/iavf/iavf_prototype.h  |  5 ---
>   drivers/net/ethernet/intel/iavf/iavf_txrx.c   | 43 +++++++++---------
>   drivers/net/ethernet/intel/iavf/iavf_txrx.h   |  4 --
>   8 files changed, 35 insertions(+), 118 deletions(-)
> 

