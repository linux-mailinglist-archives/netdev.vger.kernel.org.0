Return-Path: <netdev+bounces-11611-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8494D733AF7
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:37:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2F6D1C2104A
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:37:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A30B51866;
	Fri, 16 Jun 2023 20:37:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC9FED9
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 20:37:44 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC1373AA0
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 13:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686947862; x=1718483862;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PlkbK21YYgmYJSy7yOIF8bQpi2OBqZ0+UHKL2lIgCog=;
  b=BzyeMyOq/Qk6Ifo1Va51oVxnmXoeRKFVd+XTlBOl97g5ILhZVCzJR6tC
   CIRM01awYE7xDEMZe24p8g88bc40WpLSDgA8k23MVZrXJfRmMwLis2rmY
   HHCQ0bbLaSxkiHXBF1khaxMppe0DgqfAJHzPv2UC/EkcF0IhQL6XMPrRY
   +AviJtJi8xMofURVT978GG4WfznOjqjI760hIUiT/2FKiuTLdUua73IGU
   r0fFpJVw2bLWo99Efo/lPCbpa5mAlkDgvTFP1Jvv9BiEkZOLPZYULgEkn
   JJqYWmQSm0dEV92dI0gq1mMHVjaf2U7hX/NLUPWNyGHEqV9exC5Blhpyz
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="358182208"
X-IronPort-AV: E=Sophos;i="6.00,248,1681196400"; 
   d="scan'208";a="358182208"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 13:37:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="802964935"
X-IronPort-AV: E=Sophos;i="6.00,248,1681196400"; 
   d="scan'208";a="802964935"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Jun 2023 13:37:42 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 16 Jun 2023 13:37:41 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 16 Jun 2023 13:37:41 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 16 Jun 2023 13:37:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dxH6UTAmXD+vVX/YqH7z1MzISf1cIip/LGd8rMznDBlL/6g1sPzngxMSy4buELqIFNn62TNTZ/OLl2RJMlpYMWRJidgC3Ks8mL6syBUloV1fuZbhC0crqNFWXUVjzegVCPi4Y5ng4VOcj248CS9AYRpSg7RAS+fCsEMxMjxlB12l5LAakcAfk8esYfjM6YfEezvQqpIj0d4fwEVZGaH4pofVRsD9uy3j17l0aOtOlSAMwjHX5YuqgLqVk4EdsVFNVDysTqmA5Ntg4CdIoB9swjFsDY8cSiEbcvBykHPopy9sGjnO3rb7a/DAzV6OweRVt9BVAhX4A1+jvdA3edlw7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WYj7NAACq+Ja6RVQP5l4xSggIKu6EkutuVVAXS6dzqg=;
 b=hj06K4tDZ6iT8W4FPPgq3J0bhpzN89ZCqSjsSulYFnFyllMBX/Ryy586sNRvEW4LmxDEIbN4ihE9O3QIsOqELlOG/K3MFigxxreLfIlw+f3h37oFaakkotKb5YmqWCtM2vg/IDAHWl2zsIiG7T/SrBTkNEqI6bupAHYPi7+1/CRBgqpN9ZmbjqvZX1l1GK0TgH/9/26Ds9C4nB9cFxk52PKZFIoOzE2xx0zlqBj+LTpwnvK21PaiS6fpRZY4ol4dC3OEz+tM3Sq+HQJDI/DAZjBwSQq9SbOkaIO0TKo5o+6hDdNZz79vlotn2+TZseVpCoXnS1BEpr4H54xEAV0C0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Fri, 16 Jun
 2023 20:37:38 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bdec:3ca4:b5e1:2b84]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bdec:3ca4:b5e1:2b84%7]) with mapi id 15.20.6500.029; Fri, 16 Jun 2023
 20:37:38 +0000
Message-ID: <ad5eaaa5-0ee8-036b-d830-18c10039c41f@intel.com>
Date: Fri, 16 Jun 2023 13:37:35 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [Intel-wired-lan] [PATCH iwl-next v1 0/4] change MSI-X vectors
 per VF
Content-Language: en-US
To: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	<intel-wired-lan@lists.osuosl.org>
CC: <netdev@vger.kernel.org>, <przemyslaw.kitszel@intel.com>
References: <20230615123830.155927-1-michal.swiatkowski@linux.intel.com>
From: Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20230615123830.155927-1-michal.swiatkowski@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0060.namprd08.prod.outlook.com
 (2603:10b6:a03:117::37) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|PH0PR11MB7471:EE_
X-MS-Office365-Filtering-Correlation-Id: da4894c5-b57d-4ccd-0bfa-08db6ea98630
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eUKB14h8tXFz2MbbvbFyJUZmnyhVxDIeqoZzHbmLb3DImj9yr44uWiDKCt+o3OL7NKDkiANRGtJ9T2u4iAVp/UHDp9UtMmYKE+Cvi3qQQIDJNW0stNP2nrNd5CprY/AEQEi8p23+kIkbXIQMHMQk5P+G1pbd6DgoZLc5VNCslV2qJSvOARnHZ5vP8oE2QvoA5UscZi9OW91oAGeCuf4ZgeDLlXGF5/DhXbZfDaawM++TAOhEJFc9t3preySc3Gm49koOAU2MfNCShgR7KXlX+SoJAvbK0m0ULMjf2rApwOMfudiV1a1HmsB3eVqr9fiLMFXQzCIC5YXvOepZzXJJ/HgV6pln1H3fBH1HeMxcmTJ6TUEv5WDovWmDmHNx+uyor/a/32ZuU61TjLaxGLiCK+xPfz5SkI3agSxNAHGMotgmUclqZzqwIyN6RwNDc+hHbjV6ywiLPN8qH/Tbzv3i1/eS5A3RJ1qfQtzYDqdBGdOCdLvfALABX824WEITELznQ0UlC8+ExpZTpaM5rpndDD5F0z8ar25BnOM4vfBVhlhpOvlPcG1LDddGjaLdw41qqiS+15wTtMWxTmgQUy70MMfxwdg0yI3GzJByX/Dke9vd+p7RSqJuXfqinkSKPx3K
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(376002)(396003)(39860400002)(136003)(451199021)(83380400001)(6486002)(966005)(53546011)(31696002)(478600001)(6506007)(86362001)(6512007)(2616005)(26005)(186003)(82960400001)(31686004)(4326008)(66946007)(316002)(66476007)(66556008)(6666004)(38100700002)(8676002)(8936002)(5660300002)(2906002)(41300700001)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ky9wT2dOcGgwZnFTVkMwQ0Mwc3M0Y2k0aisyUEF4QXNwZ05TdEZ1ZkQ3L3o0?=
 =?utf-8?B?OS96anNGVDZQcVVVTXdxYm5NelpPbThHbUM4SlplRVZ4ak9HLzBPd1hWU0tm?=
 =?utf-8?B?cytOUEdhTGtTaDVtdE1uNTNCUEJBOXhvRUtNa0VYVDlGRjZ6SDZQSVhrR2xR?=
 =?utf-8?B?S1pCajlRNWtMMFB4eTVUamhGMjBucDI0UFcyMDlBWS9PVVN0Q2V4QWJ4OG1x?=
 =?utf-8?B?RUdwam84Ym1lM0IramZCc0RlU3d6eDlPQTg5TS9kVkR4QldFbmw1ZkMzdC9W?=
 =?utf-8?B?ZnBocGtjbFgxRGUvOHVPNlh1QXNBS1VTVk9STm1hN3llcnZtbkszWlZsZTFZ?=
 =?utf-8?B?WXNxVnMxZ0RJSGhQajhRQmQ5ajlvUmdiNllGU2ZNNTR2blpBNTRXTlNTV3pR?=
 =?utf-8?B?dlJ6SC81azZEcU0xM2xCQ1pVcW5ySHhLZWRnMll0ekhPYlBhT1dUYUJMMHNH?=
 =?utf-8?B?V2xpYWpmQ0RrVVc3RkYzcUxaVDdKWG9JQjJBNmhLdERCUEp5ai84K0U5NzF4?=
 =?utf-8?B?c0ZFcnkzQitnOU51ZVRXSDJVbzVtUFQzbjNVSU8veHVJRnJTVEl2VlpBeG8r?=
 =?utf-8?B?YzhnQmsrSTRnTDBXZm9Qd0QyTTk0VlY2bXBOQVF4alVSaGlISDE0V1FlRzJX?=
 =?utf-8?B?MjNhOXA1THR4dTk1cVVOd2hzYVFtY1FGN1ptSmJCcHdBQmtEQ3ZORnNPdzRZ?=
 =?utf-8?B?RlI4ZnVVSjNZVmx5aHRlekFaeklDclN0R1dBaWsrOEJrbFlpcW1mcnFFTHcv?=
 =?utf-8?B?Uzg3YkNQaVhDS2drNHlaZUFsVEJIVEtyZHJFVXo1STJLMW1xM2IveW13MFVj?=
 =?utf-8?B?b2RSODV2YUdhK3h4a2V0SHFiUm9zWkVPbzhsS2JkcEZidjZXc3g3ZEp5QmNk?=
 =?utf-8?B?bXNWZ2JucE1TRmlXZ3RkcDEzd1Q1bWV0alpKbzYvczUxYlB1enNpWEczTjQ1?=
 =?utf-8?B?b1ZCSnJIOFIya0lCVWkwTmpzNDRMQm91bER2M0dZZlVYWE9XRnkrVXg5djky?=
 =?utf-8?B?RDFyeG52WnBrd2RUS3JHQVdCK0xna0ZhQVFpY1dFL1RidS82dHNZR3BmUHZz?=
 =?utf-8?B?aGg0WjM1UGIzVkphYzZTdndPRVZQOWJIUytPMEdBenBvbmlBOTI2Y0JZbkln?=
 =?utf-8?B?QnhyUnFPRVZWM3BETzZlVUpqV2RRN2NGRVNjck16eGVvRE8yVFdpcUJKK1A3?=
 =?utf-8?B?RmxDSGU0aUc0L3pYbnlJcHUrUk03M2d2aU1mQnVEVnFOLytaK3BLTVByUmxt?=
 =?utf-8?B?d2gwSk5DNTA1b3pXZWZiSGhSSTlOTUIrMkMvYkFxYUxma3hURFhLK0RoVmRX?=
 =?utf-8?B?cWZXNFpxUnFRSnNSM0o2eFdzbHZkbWFndE1nSlZvbUJNd3BqTVJzenJUdDNQ?=
 =?utf-8?B?T1d5VmtkU0FvZVRhODVFQ25WSDZYY0lPWCsyL1FsVHF3UG9uWmY1bFlrcDJp?=
 =?utf-8?B?Sm1DMk0wbEg2ajhCdHRZR0F1aU9VQ1hVdjhTby9MandZNjFlc1EvVHNORzFl?=
 =?utf-8?B?Ky8yNXRMVmxqaGpYeXhiRCtBdmp4dWZ3UjhjVWIwTW8zRUJZelNMRFUyeVRX?=
 =?utf-8?B?bGpQZmZmVzNaM0tUaXhZMXdkamVlSGM5eHVmeDBHYnhVMDFFOHNJSFFpNkN4?=
 =?utf-8?B?VU1Ha3pERHlSYkJOYXRzVmFMcnlhaVQwZ25BNGdGRnM4RzZUTlpmLy9xT0FN?=
 =?utf-8?B?K2MzRks0bGs5NFg0Rzh1RjFDNVk0amVkVGR4R3NZbE1lOWNxeWJFUHFHaU85?=
 =?utf-8?B?RUJaZXMya1BQU2szWXIxS2lHSVAxYkNBNERPL2w0WHdUYTA1VXA5TDBXdWZX?=
 =?utf-8?B?NFZ3K3dYRmUvNTErVkFLRUxUeWJMK2NRZTJkOHN0UnNZWUdOZHAxZFA0aW5u?=
 =?utf-8?B?MWZwdHRiSlljWThOaTNRSFN3RG4zVVBtR1VBRjh1VzQ5RTBrRkt1V1FOYXU3?=
 =?utf-8?B?Wko3dzVRekRBTC9YMUdwWW5DY1dwZzBYSUQ3dU92WUxEamhNbEVFNzU5K0hr?=
 =?utf-8?B?L2tRcWNZMG1QV1dySXAzNStsMU5ENTdOQlNxeGdJOWJrWTRIUGh1K0JEZDll?=
 =?utf-8?B?RkpqSE9Tay9iejIwOTA4a3BHU0h2bndoUVNYcC81SWJscnVOMUluSjlIMTlY?=
 =?utf-8?B?YVdaRUE1UmxjZHdoVHY0ZlFhQnhJZEpLM2F4K200ZE12ZVplR0NmK0ZFWVFs?=
 =?utf-8?B?UWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: da4894c5-b57d-4ccd-0bfa-08db6ea98630
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 20:37:38.5042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dxdauErkyeljUuIhXRdZKcq7TLuNie3lPWqXO+M0+V+tExHSX6MmHyDtKTk/DjpR1Nq9iWrQ43PfTJnGkQ+JaMGqQDWvmgcc9oSe5ko3L0Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7471
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/15/2023 5:38 AM, Michal Swiatkowski wrote:
> Hi,
> 
> This patchset is implementing sysfs API introduced here [1].
> 
> It will allow user to assign different amount of MSI-X vectors to VF.
> For example when there are VMs with different number of virtual cores.
> 
> Example:
> 1. Turn off autoprobe
> echo 0 > /sys/bus/pci/devices/0000\:18\:00.0/sriov_drivers_autoprobe
> 2. Create VFs
> echo 4 > /sys/bus/pci/devices/0000\:18\:00.0/sriov_numvfs
> 3. Configure MSI-X
> echo 20 > /sys/class/pci_bus/0000\:18/device/0000\:18\:01.0/sriov_vf_msix_count
> 
> [1] https://lore.kernel.org/netdev/20210314124256.70253-1-leon@kernel.org/
> 
> Michal Swiatkowski (4):
>    ice: implement num_msix field per VF
>    ice: add bitmap to track VF MSI-X usage
>    ice: set MSI-X vector count on VF
>    ice: manage VFs MSI-X using resource tracking
> 
>   drivers/net/ethernet/intel/ice/ice.h          |   2 +
>   drivers/net/ethernet/intel/ice/ice_lib.c      |   2 +-
>   drivers/net/ethernet/intel/ice/ice_main.c     |   2 +
>   drivers/net/ethernet/intel/ice/ice_sriov.c    | 257 ++++++++++++++++--
>   drivers/net/ethernet/intel/ice/ice_sriov.h    |  13 +
>   drivers/net/ethernet/intel/ice/ice_vf_lib.h   |   4 +-
>   drivers/net/ethernet/intel/ice/ice_virtchnl.c |   2 +-
>   7 files changed, 258 insertions(+), 24 deletions(-)

This doesn't apply to net-queue, however, it seems as though it applies 
to net-next. Please use the tree that you are targeting to base your 
patches on. While most the time it may not matter, in some cases, like 
this, it does.

Thanks,
Tony


