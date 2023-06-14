Return-Path: <netdev+bounces-10937-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF2BB730B76
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 01:19:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F33FF1C20AED
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 23:19:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 823D8156DA;
	Wed, 14 Jun 2023 23:19:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C571154A9
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 23:19:20 +0000 (UTC)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2083.outbound.protection.outlook.com [40.107.96.83])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6F852D62
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 16:18:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dpwUQnqGJvrF30id9T8awM0vMuSb5fkwTA3Ronah3tOZOHGfqIWz2XL9PVwv5PlO+ikD9vttD1QJJF5HXnzBS96oDjlbsa4eE0AjOelQ5BVg/EdOenRKmhm7QO6Qii7zgTLvRYwxfFB40anW9qzF1s1FObMMSBJ+I1BJLLo1zh67OyEdIg3Ywt/QlQVHAO6uUXwHHB6lSVerTKIjdZOAirw91o52LPV7wh4wY91sDMe5RNeg1ZIfbVT8052dBrRUmszj5QjH/q3qMuFH0OXJwS4nGE9PUa+BYmJxXAddgJugvpBO/i76fwpWdtPy+uktExo1YgGl+LtsMVCPdSNOVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hEn/5QRn0L9J5EIjZAw8cQHvYx/uOeQRoyV44eg6T3Y=;
 b=cNamcHaSgTTNfa/HAZIwT1YzKDXID52/+cf/tWOGyHC8OYTClOnTGePArU6mOP72YKOJ/ryjpqTZDArUdmh36Dq5CTxZQvGXOsRe9ZriPJWPAs3jNa4pgPSdQcgDf8FjmvWcCF3g+2uKZwn5YDjEGx40ZD9hHt+aYERUo8zAM4iQRkrI2hCe+WLRxhgYiRMbrd18SAZ0PtxS3L3HyxjhxDVx0CUt6L2Pk7mozciRsLfVgkERF68E0u02COScBWvYFdi7ROV4DDxqC5IPgHw97U+DemKT6nWytvUOhhSxY1YVdtgDD8xzilszynX5oGQguxwfoFiwNr95tC+8ZuHBig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hEn/5QRn0L9J5EIjZAw8cQHvYx/uOeQRoyV44eg6T3Y=;
 b=HSBbVZolDzDenC9Vec4Hm8SRzPgrOFYmFMY4G2BlnDqJxHvP3tGPhnvfgwnplHqA1fhRjTNAXN+dTLAt/kEp1DeOaeszBvmn4cAD49ebSzpdU5tzRO0O6CQ98BIe/+aFMrFuXwPpNJ0xm3sQz3MKCGtkq4XvRA2cSlsF+Pwu/Cc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by DM4PR12MB5055.namprd12.prod.outlook.com (2603:10b6:5:39a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Wed, 14 Jun
 2023 23:18:52 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::d065:bf1f:880e:543e]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::d065:bf1f:880e:543e%3]) with mapi id 15.20.6477.037; Wed, 14 Jun 2023
 23:18:52 +0000
Message-ID: <12e374aa-58a5-47a4-b54e-dcfc2f93e58f@amd.com>
Date: Wed, 14 Jun 2023 16:18:49 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH iwl-next v4 04/10] ice: implement lag netdev event handler
Content-Language: en-US
To: "Ertman, David M" <david.m.ertman@intel.com>,
 "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Cc: "daniel.machon@microchip.com" <daniel.machon@microchip.com>,
 "simon.horman@corigine.com" <simon.horman@corigine.com>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20230609211626.621968-1-david.m.ertman@intel.com>
 <20230609211626.621968-5-david.m.ertman@intel.com>
 <26e4698d-fd5e-feae-b9ee-fc3ac35c7a1c@amd.com>
 <MW5PR11MB5811D84BB9769C3FE5D0AEA8DD5AA@MW5PR11MB5811.namprd11.prod.outlook.com>
From: Brett Creeley <bcreeley@amd.com>
In-Reply-To: <MW5PR11MB5811D84BB9769C3FE5D0AEA8DD5AA@MW5PR11MB5811.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR21CA0028.namprd21.prod.outlook.com
 (2603:10b6:a03:114::38) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|DM4PR12MB5055:EE_
X-MS-Office365-Filtering-Correlation-Id: 1473ef09-b363-447f-d35f-08db6d2db72b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	GDMFn5qqZ30R31ciDLQfdC7fNWuiOgW8gf/pZmBBDU4id7N2AVTIMm83hxx4tYSPQqbXCaLdFTn2ls3JEQlu95bQHQEvUh2P/+m5nsB67Nh7WJfCtV5k96R9eUXJaevMXjU15WJ0e8/gevgg8hGqDx/PbC9mCgRAISdnhyCcUFZqHSs3g3lTk1R8YdABwTSiHKiZOrNSdDmu7ZNQIbx80UZ8PkuorTVyBsH2jMnOx0wW6qr2GLke6YK85Q3wdKpnyGQdUvs/bRDIvEXkxPpbWgU1BBUkAhnaubBK/hOvbO+0N63Bxmx0vRO4zPPAsrtSC8sSOvSUVpvoofHYqxXV0LMJWGZX7d6nqtQiGwkMWXswL5owtS70+AIpzKLpFB/82jNb/FiEXjs85Jrmh8Ow+3UyfASBqCKE+MHYaE8QaUBExZpebU5kfTH6bolDxnazFCxNPhuXMKLekUi5Mt4MozG/k/VisZGac1ODoRUUWNoarev6wxJ6/i+uNWZAf5KlgIANJQ3qPw5k0HswDOfJGqOcwYaZLkBh7vHPgcidBR8mHgNB+hCVUNhJTZRbFV/bBQwkbtRV17twYM3vxrRYMM5KKTPhsa6hWKQFVI/MOQVKVXjmu/ViiymvxDrchNLRGnT7hDCdxAOeiJepVbGfpQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39860400002)(366004)(396003)(376002)(451199021)(6486002)(478600001)(6666004)(36756003)(83380400001)(38100700002)(2616005)(186003)(26005)(31696002)(53546011)(6512007)(6506007)(8936002)(8676002)(5660300002)(41300700001)(2906002)(31686004)(54906003)(110136005)(4326008)(316002)(66946007)(66476007)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c2JQSURUbmZhWlNLWEQrS3NoN2ZiUmd5US8xM1dDSzBESW04Slp0V3Qzc3JD?=
 =?utf-8?B?TXJ5eW5xOHNKdUNsa2Z1V2ZuMkJPRzBLcFljOXJGbUpRcXFmbFVkNVAxUi9m?=
 =?utf-8?B?a1p0TzdUNHpZUnVrZHBmTWFZUjNudGlOZEJlTElXRnNrTGxBOFZPRW5KNGN5?=
 =?utf-8?B?NVY4U1J4NWJYTGZPQWdvSWRwRk5vcjkyeHpaem1LVFFpRFhnTGhPRFJ3enU2?=
 =?utf-8?B?WEpRUjhzSURCSlNtcmEyVFg1U2llb3VZYnRXbXZLc0FUK3g1Rk5JQUNCYmQ5?=
 =?utf-8?B?WE1OTXNZUlJUN0dIRUY4OFNkSEVERE53eWtmNnV6RVh4U2pFZUxlcGp6QVhF?=
 =?utf-8?B?NWE5L0FndXRhYzE4VWIwS2N0akIva0N0VGN5UWczdzVYSWJuUFJ6ZDRqZ0ow?=
 =?utf-8?B?N1ZiWmxBMUZ0RzA1NDd3Wk4vWmVEdlhMbFlIcitzQXc4aXhoMnNhYmJyakZM?=
 =?utf-8?B?OGQwN09Jc3E3aUkyQWlCSVN6NFBPQVhyNmgzdUhub3dFS3JvQXVTdVFKeVhn?=
 =?utf-8?B?ZGd3Ymc0eWhBWXZucFNTRk5rRjdlRTZhRVI0bFZHTGlBYXlmZXpFSjFKb0ls?=
 =?utf-8?B?Vk1kRnBRT292ZW1iVlVyM1dwNU9ocW52TFhMNkhmWCszbU0yVTZldk5TNjVH?=
 =?utf-8?B?K0V1bVR3Vk1DUTN6UTBiQWxFWnlSclpsNEVBSEhPMjV3VCs0MlViRGtDbDdi?=
 =?utf-8?B?MVZjU0F5dVoxNkJYeWN4aEVxY1VGNEhGUXkxRWdXZ21NS0xQZDFFOFFKNjdU?=
 =?utf-8?B?bWZuUXJ3ZXhlZTVGL3FyWit1R0ZyZVBYdWx0akdxblJ5NFltdURKM3U2ZjFo?=
 =?utf-8?B?WWNVT2VsWUdMcC9pK0x3Y0FmSWh0eTFyYXN2STJzYjlGY1pSRmdlUzFYaXpw?=
 =?utf-8?B?dUdRdmhPQkNaS2c4ZHAwNnRFTTZnNG1wWkx6QXBJMHhLUVZkWW8xV3ZRU2Jr?=
 =?utf-8?B?dXJlUHc5dmhzRW1YY3ZvdEpRTWN5UGJVbVV1U3dKcHlmYUtVK2hRWVByMG55?=
 =?utf-8?B?WWVvSDdFeEdjSzVwRXJnZ0hyYjVxYTVIZVFuZEdJOHVJcmFad3NWajNwZFoy?=
 =?utf-8?B?Um5ReHVZckNQQk1XWUtsOHlrOG90WUxNOGZzcmtRUGxWWlhtN1VNb1QweTlt?=
 =?utf-8?B?dkpROFhocWtNaktyRGNyVlZYcEtFemJadFphajhoVEF3S3FUYlBFK3pDVzJr?=
 =?utf-8?B?K0VOOW5zbUNwTmUvNThLMjgzc1VDekdoWFgzcm1yK1Y2OFNpYTgwRHN6RHBQ?=
 =?utf-8?B?dEQxaFNiR2tzMVN2VVFJejhudGdIL1RKS3EvWklON29KVi8wZXRyZlhGN05Y?=
 =?utf-8?B?YjI5SGpGWDM5Y2ZRdUUrYndBUkN2QWI3cVhCZjlQdzZ2bDIwbi8rcGl2Vm52?=
 =?utf-8?B?dmlEc2dMVU1lckgrd3Fyd0t1SCtYWEEzUWxwcTJPYXhLektFRHZMRGkzNDFQ?=
 =?utf-8?B?N2JFdHRXY2tkTnJmd3g4YVhONEZLWDhzSmhwVVE3U2ZPdHpJbm9OYmxZcjIw?=
 =?utf-8?B?dE9qOVE1SWF0dFlFeHJEaTdwQ0hCZksvRmdSYmI5N2RkSG8vL2duUWRuSHZY?=
 =?utf-8?B?RFVBanZwMUx0bmcyZDZzMnJvL2RqVW16aWxvbmVhc1l2QU16V3JGZHZFdWtD?=
 =?utf-8?B?SC8xbHhHYmljeExNMTg2bXZEYkVHWTQwSmV6V0NrK2dsYmhHSUxmY3VYZzJB?=
 =?utf-8?B?ajJ4aDR1N1MxeEp4V3l3cklMVmpWcUFiMms1bXhBUGZCR1h3WlE0N0tZQU1m?=
 =?utf-8?B?SWFQSi9sNUdoWG4vU3lqMU52amxGdUR4UXF3NEFXa2lMSFRTYnVSYUNwbW9i?=
 =?utf-8?B?MHZGZFQ3VmJtYlVzalpKcElCekVHRDJwTGhCRTBPWjRteHhaam5NbGN6VzF2?=
 =?utf-8?B?NitocUJXUm81OEZIQUhqcVNNeTEyVkNkVXdVMHNWYnRuNUwzMU8zbmN3S0Ny?=
 =?utf-8?B?ZlRnUXFadWVNZmg1ZGRYLzl3RWt1RG9vMHlkdkxrRW5QRXdpOXdqc0YyaCs4?=
 =?utf-8?B?eXNSU3NHdlQrVWFOaXhtY294a2dKYUVCQ3FjekdUbEMyOFMxRk5HSUFNT05z?=
 =?utf-8?B?MDQvY21iQ0xIcWhXb3FYSEJGWlUrbmFxZmVNcy9PUEEweXpveFV4L3B2REZW?=
 =?utf-8?Q?wnRtqnSoGa2FKkio5hL3QrND4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1473ef09-b363-447f-d35f-08db6d2db72b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 23:18:51.8092
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JeqiAwb+3mCdAKBIjM6dPtLmwAlP2U6GibR9TYMW+KIPsqRuJfMnWr66q9mHIQUjBj+QFkkMionCfEXMpO5E9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5055
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/14/2023 3:58 PM, Ertman, David M wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
>> -----Original Message-----
>> From: Brett Creeley <bcreeley@amd.com>
>> Sent: Wednesday, June 14, 2023 2:24 PM
>> To: Ertman, David M <david.m.ertman@intel.com>; intel-wired-
>> lan@lists.osuosl.org
>> Cc: daniel.machon@microchip.com; simon.horman@corigine.com;
>> netdev@vger.kernel.org
>> Subject: Re: [PATCH iwl-next v4 04/10] ice: implement lag netdev event
>> handler
>>
>> On 6/9/2023 2:16 PM, Dave Ertman wrote:
>>> Caution: This message originated from an External Source. Use proper
>> caution when opening attachments, clicking links, or responding.
>>>
>>>
>>> The event handler for LAG will create a work item to place on the ordered
>>> workqueue to be processed.
>>>
>>> Add in defines for training packets and new recipes to be used by the
>>> switching block of the HW for LAG packet steering.
>>>
>>> Update the ice_lag struct to reflect the new processing methodology.
>>>
>>> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
>>> ---
>>>    drivers/net/ethernet/intel/ice/ice_lag.c | 125 ++++++++++++++++++++--
>> -
>>>    drivers/net/ethernet/intel/ice/ice_lag.h |  30 +++++-
>>>    2 files changed, 141 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/intel/ice/ice_lag.c
>> b/drivers/net/ethernet/intel/ice/ice_lag.c
>>> index 73bfc5cd8b37..529abfb904d0 100644
>>> --- a/drivers/net/ethernet/intel/ice/ice_lag.c
>>> +++ b/drivers/net/ethernet/intel/ice/ice_lag.c
>>
>> [...]
>>
>>> +/**
>>> + * ice_lag_process_event - process a task assigned to the lag_wq
>>> + * @work: pointer to work_struct
>>> + */
>>> +static void ice_lag_process_event(struct work_struct *work)
>>> +{
>>> +       struct netdev_notifier_changeupper_info *info;
>>> +       struct ice_lag_work *lag_work;
>>> +       struct net_device *netdev;
>>> +       struct list_head *tmp, *n;
>>> +       struct ice_pf *pf;
>>> +
>>> +       lag_work = container_of(work, struct ice_lag_work, lag_task);
>>> +       pf = lag_work->lag->pf;
>>> +
>>> +       mutex_lock(&pf->lag_mutex);
>>> +       lag_work->lag->netdev_head = &lag_work->netdev_list.node;
>>> +
>>> +       switch (lag_work->event) {
>>> +       case NETDEV_CHANGEUPPER:
>>> +               info = &lag_work->info.changeupper_info;
>>> +               if (ice_is_feature_supported(pf, ICE_F_SRIOV_LAG))
>>> +                       ice_lag_changeupper_event(lag_work->lag, info);
>>> +               break;
>>> +       case NETDEV_BONDING_INFO:
>>> +               ice_lag_info_event(lag_work->lag, &lag_work-
>>> info.bonding_info);
>>> +               break;
>>> +       case NETDEV_UNREGISTER:
>>> +               if (ice_is_feature_supported(pf, ICE_F_SRIOV_LAG)) {
>>> +                       netdev = lag_work->info.bonding_info.info.dev;
>>> +                       if ((netdev == lag_work->lag->netdev ||
>>> +                            lag_work->lag->primary) && lag_work->lag->bonded)
>>> +                               ice_lag_unregister(lag_work->lag, netdev);
>>> +               }
>>> +               break;
>>> +       default:
>>> +               break;
>>> +       }
>>> +
>>> +       /* cleanup resources allocated for this work item */
>>> +       list_for_each_safe(tmp, n, &lag_work->netdev_list.node) {
>>> +               struct ice_lag_netdev_list *entry;
>>> +
>>> +               entry = list_entry(tmp, struct ice_lag_netdev_list, node);
>>> +               list_del(&entry->node);
>>> +               kfree(entry);
>>> +       }
>>> +       lag_work->lag->netdev_head = NULL;
>>> +
>>> +       mutex_unlock(&pf->lag_mutex);
>>> +
>>> +       kfree(work);
>>
>> Should this be freeing lag_work instead?
> 
> Nice catch!!!  You are right, lag_work is what is allocated not it's element work!
> 
>>
>>> +}
>>> +
>>>    /**
>>>     * ice_lag_event_handler - handle LAG events from netdev
>>>     * @notif_blk: notifier block registered by this netdev
>>> @@ -299,31 +351,79 @@ ice_lag_event_handler(struct notifier_block
>> *notif_blk, unsigned long event,
>>>                         void *ptr)
>>>    {
>>>           struct net_device *netdev = netdev_notifier_info_to_dev(ptr);
>>> +       struct net_device *upper_netdev;
>>> +       struct ice_lag_work *lag_work;
>>>           struct ice_lag *lag;
>>>
>>> -       lag = container_of(notif_blk, struct ice_lag, notif_block);
>>> +       if (!netif_is_ice(netdev))
>>> +               return NOTIFY_DONE;
>>> +
>>> +       if (event != NETDEV_CHANGEUPPER && event !=
>> NETDEV_BONDING_INFO &&
>>> +           event != NETDEV_UNREGISTER)
>>> +               return NOTIFY_DONE;
>>
>> Would it make more sense to prevent the work item and any related work
>> if the ice_is_feature_supported(pf, ICE_F_SRIOV_LAG) check is moved to
>> this function along with the events that require that feature?
>>
>> Something like:
>>
>> if ((event == NETDEV_CHANGEUPPER || event == NETDEV_UNREGISTER)
>> &&
>>        !ice_is_feature_supported(pf, ICE_F_SRIOV_LAG))
>>        return NOTIFY_DONE;
>>
> 
> Even if SRIOV is not supported, there are still tasks that need to be performed for bonding
> events - e.g. unplug the RDMA aux devices, so we don't want to avoid creating a workqueue
> entry when feature not supported. Which makes me notice that ice_lag_changeupper_event
> is under a feature check and it should not be here.
> 
> Will change it.  Changes coming in v5.
> DaveE

Ah, okay makes sense. Thanks for the explanation.

> 
>>>
>>> +       if (!(netdev->priv_flags & IFF_BONDING))
>>> +               return NOTIFY_DONE;
>>> +
> 

