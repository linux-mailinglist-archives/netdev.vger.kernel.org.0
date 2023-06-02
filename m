Return-Path: <netdev+bounces-7420-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5951972031E
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 15:21:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D377F1C20E13
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 13:21:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7699A18C2E;
	Fri,  2 Jun 2023 13:21:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E85015BF
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 13:21:21 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D06B1B3
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 06:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685712076; x=1717248076;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wfeKKg7RBGb1tgrAmItWD9BGqHfp3llnnkFI68In3HE=;
  b=O/0R9nyJvDn2m1GQNRCFwpZkH7KhPnGRlytKsLKcXBUr1tN3yoiaxZGt
   rs3aNpKx4YLE9GYNEdfvg8chT/KLGqkQvtUfp3QfcJqwCsWqjq9LI+JNh
   8iM3JlGNVRntSQygNatgtZmNLoERlL42BtOTa6FROqv2Y/SibFWvpRfrE
   j3sqdVGRP2Qqj0n8fF9Shv2VMqaSkppC3/+6GZmHzv7aQhxa50EA0TWOr
   g9X8kkWsIC6Zb/+QnZ25FXtCmbtt/7Zctze9aROCSVZudNkF1+9J+I4s2
   Vfd9w4aqY0Qa/0vF/5nYkoc04vGvn84a7lQfl32fGCdLythu1qAOOxnOE
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="353360510"
X-IronPort-AV: E=Sophos;i="6.00,213,1681196400"; 
   d="scan'208";a="353360510"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 06:21:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="658272879"
X-IronPort-AV: E=Sophos;i="6.00,213,1681196400"; 
   d="scan'208";a="658272879"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 02 Jun 2023 06:21:14 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 2 Jun 2023 06:21:14 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 2 Jun 2023 06:21:14 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 2 Jun 2023 06:21:14 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 2 Jun 2023 06:21:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xmlh/ywUiZcDBZmsDUM5jwwUQQRe6B63uY1SahZIdHWb9xADeUzPjpA2Ukr24IhE4rNF5smexOTEYpOMqqeLIOAsPuWg5vGhEmwLv4ec2DM/fOB68wRUTCKqYPqIc8Niqj4V3nL+8vWaZWG8Q5W//p3KdWevc4/kl70RX3PQD0naGymYQcUh8GAmReqQmDYXvmsq9HzaQKq08TlRjqqE53f9508hka0MVLcdmqFXEjpaKxYjRecSY6NA6ofdHclyZXx763hUfXGNniUNipTjFLRIWoEHkT5qB43uhj54nRwEfMwdmdTJeQgrbyJBzGPydm42tJxWhf+oCbZkz0vaqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qfbydvKCID88okBMtPmwouxgAq1Y6ycHZCt5KlTMq10=;
 b=acIjTMkCu2ETJhN8bRHC0MbyulQAKkXyyFWrdhSTb8DpsmnO2ailexosiaM+N5yhI6X23Nqx4XyqHaPbghbbvFwYfu4tq90wjr3pJDgECrFtb8hpqeY4/0tktl3ndFzgbfalVYjlCI3ADLEvt051TGhpEzBYARo6ugjDT1LoM6oAPXbtk1rzs5luXYxjBAWyFPCLRG3+urOPLU1Qh2OQHMY8/VVW9yz9VOKn7CaFmwhJeZm6lDl/YVN9x9E2fZiDCrnRddojxpTUyWM0EIoD1PvdJSjZAXLYipYGlzwYYliPWd536NQNQ/8Q9vlFPpSHgWtWQPT4Sz4OhHd2Hxhj6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH0PR11MB4856.namprd11.prod.outlook.com (2603:10b6:510:32::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.24; Fri, 2 Jun
 2023 13:21:11 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325%6]) with mapi id 15.20.6455.024; Fri, 2 Jun 2023
 13:21:11 +0000
Message-ID: <bd58b5a8-de29-d80c-9440-4809162951db@intel.com>
Date: Fri, 2 Jun 2023 15:19:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [RFC PATCH iwl-next 2/6] ip_tunnel: convert __be16 tunnel flags
 to bitmaps
Content-Language: en-US
To: Marcin Szycik <marcin.szycik@linux.intel.com>
CC: <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
	<wojciech.drewek@intel.com>, <michal.swiatkowski@linux.intel.com>,
	<alexandr.lobakin@intel.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<jiri@resnulli.us>, <pabeni@redhat.com>, <jesse.brandeburg@intel.com>,
	<simon.horman@corigine.com>, <idosch@nvidia.com>
References: <20230601131929.294667-1-marcin.szycik@linux.intel.com>
 <20230601131929.294667-3-marcin.szycik@linux.intel.com>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230601131929.294667-3-marcin.szycik@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0188.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ab::9) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH0PR11MB4856:EE_
X-MS-Office365-Filtering-Correlation-Id: 23af0df0-6245-46b3-f75f-08db636c3b07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mnCtvxjz5L6e0eFcqFTR+zA98IogVp8Mug000Bd9Gl8Rou4P0ooEoeNuNzjXnxcaWnc+DIFvaHTDB0A3yBpIzFBZKonPgCvkK2ZU+asXYqo4xlC+E3QE0wBDa3v7Zxh+ES1Jq65dTSq1EMO3JL0V5dNWedE2XhvmU+6rog10aPiYfAawjSvJSavo++qDQRaxLfCcyBvdgK4Qd4zHoHcVMHsX8g76iEIzW6o5W1B3qIoLHGAugN/sPSJibEOnF8vMD4w1yqtMR/fAWKCfWJ9F7O0uBv3y4HeaadV115fl4SdFP7U+Gz7Mw9VZkh2DYkxUTQETPsh6s3N/a5TDLlAwUEYLNOUoEF0pHLuACPq99G2KlvmOzGjtrq86BYGr02oe0Nh9Cqn7y4GHWMtl63yvEwA8XoWZPUqeyLQ8t6n3+6VzQx8QOZcuHf4fOOr49NFVNEa4e0li3WIRmPqh+RlMjvaVfZiFdk5qk04oA4Xq3DrTsnz8fp1UoUQ6KBtrzQ8piLLfYACMYgFu6xSEOX/tm21E94tKpWnB51SgAkOBA4qXVHaMqUlQnkH+Qxzkc7MgdXGzMgBWNLvU4rCVc9nOpHRmaYW0cSgK2rItUXJgOMWSkVXO+wNPVD0qE8C91EPULd7ZKmSNRlCxiOM7DpGAhw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(376002)(136003)(346002)(396003)(451199021)(82960400001)(38100700002)(31686004)(8676002)(86362001)(66556008)(66946007)(6916009)(66476007)(4326008)(36756003)(31696002)(6486002)(6666004)(478600001)(26005)(186003)(6512007)(6506007)(316002)(4744005)(7416002)(8936002)(5660300002)(41300700001)(2616005)(2906002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WGx3Z3kwWEp3NlVpbTlRYXV5eVlWeEczdy94YmJMbTBQaHRvUUpnR0VtL0d6?=
 =?utf-8?B?QUF3NkM2RmRxa2JaVklxSnJGTEZYdThpNnJuV0dmbTk0TnQ2WnZoU0UrRlJ4?=
 =?utf-8?B?bnNMUk5zOUxQWFN3d0lMNzZYSFBSSm5SS1dEQVFvZUwycU4vU3UrNVdLRjZJ?=
 =?utf-8?B?TkZxTEt6VHNrSE0rd2JHYmN6UU1abEVrbVFIMmpKNFR0ak5PNVVoS1dndGZo?=
 =?utf-8?B?dnRzUU5yY2lYVzlaNXpmbkt1WGoyL1NtV2l5L1dINnczNHgwd2llOUNsemdU?=
 =?utf-8?B?RSs0QytMVU5HTHpxcTdXN2Y0Z3NMdDE2T0xEejNUSEFLMGlyQzVtZDE4RHBX?=
 =?utf-8?B?dUppblNCRU9NNkY2c0pCSDRiMjEzTWRmd2tGNHF3Y1JIdEhuOXBnRHlDYlNQ?=
 =?utf-8?B?SkVwTEhhbjZMMnFsWHQ3QmJFZmo1TFBQajhJVWNmUU9kaHZzc0dGSGVSWHVF?=
 =?utf-8?B?eER5TlNSL2lSZnRDYTd5OCt5emh2UGZMTytaK1JUcTJPV0NsLzBjOC9xb3NW?=
 =?utf-8?B?aG1XVnZ2TnNJTEJVNWI1L3I3VTFJZDVpWXQ3VWVyaFRlR210SXNFU2VyNW9N?=
 =?utf-8?B?WGN3SzFqeHRtZHp1NzdhYU9OVjJEZWVITHhhcHgrakdiUWdmYnVtN1BSRzMr?=
 =?utf-8?B?ODZQcmdKbVJWUHJYd0l5MjNYd0NaSStHa3A2NnZnQWl1aE1iSUlBMHN3ZE01?=
 =?utf-8?B?dlRBU205RUFZdWx6OFNsUjExVVlPL1RrSHFuRGNsRE9nelplN01ldnRsbWQy?=
 =?utf-8?B?ZDhkVGVFTGdwYWRpeUZmejhoY3o5Y3dkVVVXRGhyd3cxVGtMSWZIcDdzdU1y?=
 =?utf-8?B?QUJkNGNXWjh4WkhCTkZITm93YnNEeURqY0dIc3N5US9JUm53ZEtZZWlvRXNK?=
 =?utf-8?B?dFhNTldEamlQVHpsQmpuOG01UUM2UDdXWnNqRy90RnR5L0RMWVFKaU81Wlhh?=
 =?utf-8?B?UjZKYk5DNFRaek9wMFczc1BMYlNZdTJQN3YyWDUxWmJkREEwMHNyVzBIZTVi?=
 =?utf-8?B?VEhnMkRILzRJdWphd3dkbFd1cHJwMzhXWDFuQkowVUplU3gySmtzMUo4blQz?=
 =?utf-8?B?U2kyWDVHTTRvWTdqWmhNUElSOUV4WnNIamlRQkl5S1NCaWtKUnJRRDc2R0Vw?=
 =?utf-8?B?L0J3TmVwZUZDTUNQUTA5a0NQRllBeUVXUXJHdlZQL1k2anFMVzZEL0QxNkp4?=
 =?utf-8?B?dUd4WDQ3ZGlEODFqTnF0UEcvUkM1TFdVeGNJQ29sKzJFU3BZdGNvNUtNRGRS?=
 =?utf-8?B?VjRvNHppL0FwQ1k2V1FUQ2FNZXJaQzg5S0kyeGl6ckJyQU1xVE5IZmtvUkdK?=
 =?utf-8?B?ZzdoS3o3V2hrS1QwKzNuRktPUnZSWmZqU1M1eUZDQkp5VWh3QnNlbmNFeHg3?=
 =?utf-8?B?OEZML0l6dUtRSitoZVYzRTBOS2luNTNoWjhwRlhER3Z5Ly9CSTZPNC9MdHZi?=
 =?utf-8?B?bHR3OEpoZEZBMDVZUHR3SjdBdThMaC8xcHNvaXNoV3hRYmtFc1FHdWU5bGNk?=
 =?utf-8?B?R0kwc1BIai9WUndsMmI2aEFDcjZRTnRndHV1S3FuRnU1aEJCT25vUHJSdzZu?=
 =?utf-8?B?cm1YNkRlNjlRVkNkN1pzTlRMRnVlQkFRVGFDeWtSbWk5V3R1VVBxaXAxODV1?=
 =?utf-8?B?SGo3NWg5S0hCbUpRSWpCbGhhU3YyN2JTSW5RbDRQU1QySVdOVlA4czVGUUs0?=
 =?utf-8?B?OWcxT0tkUHdiS0NKMElzdmJsTVVlQkFySlVZQzN5VWdjVGVyUlpwWjR3WFAz?=
 =?utf-8?B?NlRvcXJJbDI0aDdpWUtpaHpLV2txbEsvZWZjbHhWSUdxd0tyRDFxRUVnbnoz?=
 =?utf-8?B?QmxBSEtVWHQySGlTNHVwdGhlZU5XTE1qN1NBV05vV00xUEFtSGdCMXh4RmFL?=
 =?utf-8?B?Zk9oUTl6bjFGbG8vMmk4NWt6Q3g0WGNpNmxEOWRkaU1ySVg1aU5WdTJkS2dt?=
 =?utf-8?B?MGswSHdGRjBralpZeUs0cHVnVkhYbHJtTEMxbVh5OGVuR3ZMMFZPN3dVOGdw?=
 =?utf-8?B?d0swSnlLdEEzM1BIQWlSQzAzaWlnMzNMazhmSlRxL1ZkMUszVU95V0F1ZWVH?=
 =?utf-8?B?TmJ1ZFJDcWx4MldUV1BhV2oyL2J5YkF4SHFkMmVHZ0l0MktQZHBGdE02MWlQ?=
 =?utf-8?B?Yjc4azBKU3lzbUYwalI2V2FGdXIyRkdVakFISEtwUWl2eFFEQXZpc09nL3dG?=
 =?utf-8?B?REE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 23af0df0-6245-46b3-f75f-08db636c3b07
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 13:21:10.5474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7I7ylF4jgiLreF/dG9EjWT4KpfjqBonZESavPvChVDhNaKXwVdA/o3raUvTYqouxSnkTnkqGCN5kSTXM3Rb78CN3022Pr9m/uEdx2sWsfjQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4856
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Marcin Szycik <marcin.szycik@linux.intel.com>
Date: Thu, 1 Jun 2023 15:19:25 +0200

> From: Alexander Lobakin <alexandr.lobakin@intel.com>
> 
> Historically, tunnel flags like TUNNEL_CSUM or TUNNEL_ERSPAN_OPT
> have been defined as __be16. Now all of those 16 bits are occupied
> and there's no more free space for new flags.
> It can't be simply switched to a bigger container with no
> adjustments to the values, since it's an explicit Endian storage,
> and on LE systems (__be16)0x0001 equals to
> (__be64)0x0001000000000000.
[...]

Little comment on this: yes, I'm planning to extend UAPI to be able to
use more bits, but using Netlink bigint, which I posted last autumn,
then switched to another project, now I'm a little (a ton) busy with
urgent another one... Hopefully I'll send v3 in 2 weeks or so.
PFCP doesn't depend on it anyway, so this can be done separately.

Thanks,
Olek

