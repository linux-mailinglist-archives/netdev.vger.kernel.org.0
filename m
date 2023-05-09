Return-Path: <netdev+bounces-1252-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8E306FCF37
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 22:14:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A69B7280F3F
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 20:14:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9552318C12;
	Tue,  9 May 2023 20:14:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC4F18C02
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 20:14:05 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6E510F6
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 13:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683663244; x=1715199244;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FNbGetsjlYtb8wHklcZ1NIzg+ToXZ4Qis00yRMw7NYY=;
  b=VuUxo9nMr/lx/eA+yxkZGBBTbYhrEkbI0wZk+cgwOoN0YEO8P5TJxchd
   AqUeDXrSNKI/EaIg8DgHEOJCBuSvXWFxYADkKzxxFbqxVDRzhVPEJ9UCN
   180lbd/mo4+qIc6c4kqu6wbpDQMzOQ+3cQonwd7Cv7R5h+56HPB6GNCn9
   9rpQUTdjIk/N/c5TJIT9bWNlH9MdkxefcYRpTK7W849Zi0JV6RnKGNbDU
   y8oJVM7DtmnOBV9Bwy/AZxsjrvZA27cHn6Ny6rUqRd4E24UoDUk7O8MBe
   oMzl51Hmdd6ZG2WlbfvTVZgfhFIz8eSoo+tRRPUir/U+UaBqXGhvSKgfI
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="330406374"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="330406374"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 13:14:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="693120670"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="693120670"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 09 May 2023 13:14:03 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 9 May 2023 13:14:03 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 9 May 2023 13:14:03 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 9 May 2023 13:14:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QCTnGhHR7pAnA2nGamoSJd9nAzlXuPMkwnY+e1qaSmyvNKl0mdTueczA6Br4ApkpcgbSpAlvg4W5d39bi/3KAGNlgTnyoIrdfq46+mvjurDn1wk9W/EZ7MlDD6lgUKyHntwzkiYLapj4u9zvFcRBzHNc47cXXpOn4aL1X8eEYHkY3LP4WNNf2Yixik5rP2GvJdNuStdtVRckphjDsoqPNPBkXsEtrl73FwpPDlWmCAjDcdHloea5+NW1ApdHGdyrwPCni91mhFJVZ0Wdgg9VDJgmbvx/KC3mDOlEFYukIG5WFjEFpqPYgjhv3saXpPA8gDxkBxZG5eV6egwSx0l6ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9HJHc6Vi2t8W+5Z0wA2z2yLz5gQaP28sMfcwGc6HA2o=;
 b=lwikgy3q9BQMBS7zQ0C/GNavpuY3XvcQalMparyCNQiDty56jHtqxFhv+Ky9iPc42CoT0l6U5DsAJbk6jGk2G9kwBXYAu7sTD7wT5QIxmBScxG9e8QiYl/VNz0/i/9fMHuVP0ne0h55OOMOzYxEkecwpyg+22OkwB7eD99XXOCMsAI9hI9k/dNoYSQ1mTNAHhyHk+zGl2JtWTCQ/LTUiEomTeEDz0Ay2I1ffOpuC7MSKrnZgIig/HTawt4iJtnropKS0u37A6xdWo3PL0IfacUG6r9YKB4eHWgDZc7uK/rpAmJByBAfGNY4yay2FQuzYHLh52KwitNUYoUXZ6Lrbtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SA0PR11MB4592.namprd11.prod.outlook.com (2603:10b6:806:98::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Tue, 9 May
 2023 20:14:01 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::27fc:4cc8:6fea:1584]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::27fc:4cc8:6fea:1584%5]) with mapi id 15.20.6387.018; Tue, 9 May 2023
 20:14:01 +0000
Message-ID: <d3488814-f4fc-f477-e7c1-dceee81c13c3@intel.com>
Date: Tue, 9 May 2023 13:13:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [patch net 3/3] devlink: fix a deadlock with nested instances
 during namespace remove
Content-Language: en-US
To: Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>
CC: <kuba@kernel.org>, <pabeni@redhat.com>, <davem@davemloft.net>,
	<edumazet@google.com>, <saeedm@nvidia.com>, <moshe@nvidia.com>
References: <20230509100939.760867-1-jiri@resnulli.us>
From: Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230509100939.760867-1-jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0219.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::14) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SA0PR11MB4592:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c73f9f9-f466-45db-8610-08db50c9edd6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EadRHf2EH4I3po5PXK4u9OMAyfdbOn4rvcdIn/0k7Z/DeDZNGllkpBLB7A77SfXDrSmGtl4uzJflAhMNfUd87M+jV9rN56/GNtXaFmfibivjqRab2oPNZ8q+dFfcJ6K99YpUct2QJRQsxxFemEtgp745IF0YT/eY1BexiBZ27PGzEte3khsSTfXWjdMyYbLpNU5rE3YM1Yy/z98hUYaHsTYwNvP+1W9MEdXG/uoC1gp/lA1SMLelv7XPuK0VIi0S7lfht37z2VvFSmq9KhFiCSVYkIUWUfEL29tC3TUTqFnOZO5MXZqZk5ffsYXoh0IqV5JSOjJXQ1pANFEamBFrtp3l5+hx1/tRP0ICpL7RWJJ6ovKfMiRaZeI6vVakV3CThmZ0E9lDTFEYiJ3UFe5lF9JDd1JYkhubmONxP21FQI5JepgK6F9U0wdLSAyqS8WmaOIrDammGTJ3NS4wdbexxCU8iwUnxAgiG7v1N04YHa2mDrm2IqiF/GeFi3IXqtAEcJ6rGifUMEQa6mMaQSDZ/vj/npF2kVwzp+FRmr5x5IXMcU/4zBVvp7BTd5IoX7WPwIG2KjClh/G5c+415snln4IrkUaSev8PG+WowSod2ET0VuX0nxSZDPGOQhXnFNLWquCMjxPaiR/H+KUfbJ0Jjw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(396003)(376002)(136003)(366004)(451199021)(6512007)(26005)(53546011)(6506007)(6486002)(2616005)(36756003)(38100700002)(31696002)(86362001)(82960400001)(186003)(83380400001)(41300700001)(4326008)(2906002)(31686004)(5660300002)(66556008)(8676002)(66476007)(478600001)(8936002)(316002)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RkVNRzZodXpya3ludDNGcnlpOWJ4RVY1cnZzMkVDUGg2V3BJd1AwSjdkaVhz?=
 =?utf-8?B?d0FYaEpkT3lhSVpML3FwOTVCaE55L2VqaThQVHJ6NXp6VVRvSkxtaXNSenR0?=
 =?utf-8?B?UUxrZm1SU1lxbW9xUVYxVFlEMzhhQVRRMm9TZjFrTEYwR3FiRW9mVmNlS1Fl?=
 =?utf-8?B?WUNZSXBBYkRub0drRGJPLzR0MUxrWi96dVdFZi9BNFJoa1VXd0RXK3ZqUkJl?=
 =?utf-8?B?Y3hsY29Dc2J2d3dFYld2QWJ2QjJXcG1iTTBUcXNKVnZkbE1Pa1ZOV3F5RUNN?=
 =?utf-8?B?M3FGdHVKZUJlb3QzTHlMRmg4VmQzSTdiWVBOeGdvTnBpL3JteHM3Nzh3R3gr?=
 =?utf-8?B?MXo3YWdxM3g2cHhXSFpoZmwrVjg5UmxvOS9sdmpGbTdtV2Zsa1FhMlQxUTR3?=
 =?utf-8?B?QUd6WWk4R0JQUW85S0lJakJxRm5QM1N3dG9OR0ROaDY3WmlzY3RReXc4ckl5?=
 =?utf-8?B?YWZ0aVpuZHgvQW52aG90d01udnVLSHU5cVk3TzFVQTUva05JUDNYc0VIdGs1?=
 =?utf-8?B?Yy9TdDExdmFnblhiUFNBOHVGKzNvSlI0bStFazZ5WFk2SWVDRlJVQUhpQ2tW?=
 =?utf-8?B?RklneGVtclpoemZ1QlQrYTcwcHZaaWdLMGloaEFoR0dLNUE5TmJXU2NoQzRB?=
 =?utf-8?B?Qk1FR3lPbFFJdFR2MnBvcFB1cE1FRFJBdjhEQ2wzYkRSVFJHTmN6bmh4YXRI?=
 =?utf-8?B?SFBYcCtWbzdrWmE0TnZxNlc5eEh2NFFnSWlVaVR0dzJaZEpPU3VFZUZHL29i?=
 =?utf-8?B?OFNTeTM3Zkhobnp6ZXZsU3JwUHhUdGRDcXdkdzVENUxrbm5RM25pMEhoMHYx?=
 =?utf-8?B?QWtzNW5MSUw3WWR6ZEloamtFNEJoN1g0dmtndnlXaGF2S3g3dmc4b05mMnJ6?=
 =?utf-8?B?a1FiMWpZN054SzFHNDNIWmRvRktJV2QxTmMzMmRnTzFqK1hSSmJ5dVZMejUx?=
 =?utf-8?B?cjlQUVZtUFp5TFpBVEFtQTQwM2Q3V3ZqbHNxQk9DdEtEQUlZemVoQllyNWFw?=
 =?utf-8?B?V3piRmtYdlRSdjROVHdJSFFFNUdSUlFBbkVxZmNId2RxYWtYUjhKWjJwbEZW?=
 =?utf-8?B?aFFsSE82UFpBZk1ubHlkKzJJMHQ3SThyV1F3bGhaVzJ0bnpmWXRKdkdINUc2?=
 =?utf-8?B?ZXozWEE5aGx3dVlHSWduempRSUVabkFBSXk4dFFXVDVQbzIvV3hvdGF6RmxC?=
 =?utf-8?B?d2tPeVVUYlJDYTZNUjJCQjNWT2U4bUx4UnlQVzBYWlA4bnJnZ0gxY2FibGJW?=
 =?utf-8?B?U0RVQzI1ZXlSQkdZSnlKczJhZkRyd3dFZzlINWJJZTNmQld6YnhIWDNMZFFU?=
 =?utf-8?B?elFaSElWVFg5WHgyWThlS3NQak9mdk55UlVuZ3JEV3ViN3BZSStZczZpa0Y0?=
 =?utf-8?B?a0NSaUhvMEFPTGsyTDRIdmxkMHN5RUVtVGpaNms2ZEFXMTRzM2psSW5YMU4w?=
 =?utf-8?B?RkFZT0Z3d3I3YlJZeXlLaEx6NVdPYkZNWVBVN3JGMVhtWDF0bnRMTGM5N2V5?=
 =?utf-8?B?d1ZYelNFbDN1VWpDSXczSURuTnduZFREbDRtaUprbU1zMnpudlhoSFNhL0dD?=
 =?utf-8?B?Y3JocXdVR0huOVZTbEdwR3dVL0Z3K2ErbDkyNE45bnk4b3Q2alFrTkh0Mkc0?=
 =?utf-8?B?VzZOaENmSEpCRllzM2xsejA5TTZLMDhMZVhMNVdRREdLYlNsWXp3UG9jMEoy?=
 =?utf-8?B?eEpCWFZCN2pScmNsUXdiMXNWUkN2cVYwYWJTS0JyUFRUVTZWM05GMmlvb2wx?=
 =?utf-8?B?cU9DSktLZWlydmNQVExGWmhlK3o0Mi8wUjFSMXpmOWtGOFpZbHArSktkdmxr?=
 =?utf-8?B?Q2tlNy9yZ3BudW1RN0J1TTY4NUZMbHYzUGt3cWwxandGaWNxNkJHVGtQRU5y?=
 =?utf-8?B?cVZzdWhSZWs1OEs3Vm5aajhxWFVTK0JoSkNXRkdRZjlCeHI4MW9haDhMZ1Ex?=
 =?utf-8?B?YkRGOFFoRnFwSHlscFFWck5WOFNwdE9xY2YxcU54Ni9LZmdmbDRyMjZrNmZz?=
 =?utf-8?B?cU5DdklsQzJ4WExwMk56VUNrRmREWkIxTjNDcEFpK2tKeHRtOWdPRXdnTHFC?=
 =?utf-8?B?MGJIMXAvUVN1OEVBR3NxSnVFYVA3QXc3QTJkVFdUcWo4UEIzNlhlWEU1czN1?=
 =?utf-8?Q?SML+Hb4nggSCiomc4ptqgH0gS?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c73f9f9-f466-45db-8610-08db50c9edd6
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2023 20:14:01.3741
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gnl8uUzDY/MNO5ouPZuTn5Q5oUHmXg6flbAT/Cvze855xxKEk9TaBQ0bngoGAq3vDLSfClLCryjNXnCZ8iQBhZeCTcMCIqrtobR5bxGTtTs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4592
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/9/2023 3:09 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> The commit 565b4824c39f ("devlink: change port event netdev notifier
> from per-net to global") changed original per-net notifier to be global
> which fixed the issue of non-receiving events of netdev uninit if that
> moved to a different namespace. That worked fine in -net tree.
> 
> However, later on when commit ee75f1fc44dd ("net/mlx5e: Create
> separate devlink instance for ethernet auxiliary device") and
> commit 72ed5d5624af ("net/mlx5: Suspend auxiliary devices only in
> case of PCI device suspend") were merged, a deadlock was introduced
> when removing a namespace with devlink instance with another nested
> instance.
> 
> Here there is the bad flow example resulting in deadlock with mlx5:
> net_cleanup_work -> cleanup_net (takes down_read(&pernet_ops_rwsem) ->
> devlink_pernet_pre_exit() -> devlink_reload() ->
> mlx5_devlink_reload_down() -> mlx5_unload_one_devl_locked() ->
> mlx5_detach_device() -> del_adev() -> mlx5e_remove() ->
> mlx5e_destroy_devlink() -> devlink_free() ->
> unregister_netdevice_notifier() (takes down_write(&pernet_ops_rwsem)
> 
> Steps to reproduce:
> $ modprobe mlx5_core
> $ ip netns add ns1
> $ devlink dev reload pci/0000:08:00.0 netns ns1
> $ ip netns del ns1
> 
> The first two patches are just dependencies of the last one, which is
> actually fixing the issue. It converts the notifier to per per-net
> again. But this time also per-devlink_port and setting to follow
> the netdev to different namespace.
> 
> Jiri Pirko (3):
>   net: allow to ask per-net netdevice notifier to follow netdev
>     dynamically
>   devlink: make netdev notifier per-port
>   devlink: change port event netdev notifier to be per-net and following
>     netdev
> 
>  include/linux/netdevice.h   |  6 +++++
>  include/net/devlink.h       |  2 ++
>  net/core/dev.c              | 34 +++++++++++++++++++++++-----
>  net/devlink/core.c          |  9 --------
>  net/devlink/devl_internal.h |  4 ----
>  net/devlink/leftover.c      | 45 ++++++++++++++++++++++++++-----------
>  6 files changed, 69 insertions(+), 31 deletions(-)
> 

Not sure of the patchworks is confused by 3/3 instead of 0/3 on the
cover letter, but the series looks good to me:

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

