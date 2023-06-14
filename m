Return-Path: <netdev+bounces-10939-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23C4D730B81
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 01:24:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F2C41C20DB5
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 23:24:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10B27156DE;
	Wed, 14 Jun 2023 23:24:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB19E13ACE
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 23:24:54 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072.outbound.protection.outlook.com [40.107.93.72])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A703AC
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 16:24:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MBnwpxDb5UZrhXsiH/X6pMM1dM/4GUBg0vrXzcYq6+Mc0sFlyKoHuBdACrD8AJNc1XwF7ZjGypfDanm8vcvwsh+I88g2YxZM9dT+m8/Uz6wn10at0AueMHG0SvME4Jtyj6Ct4qUc5/vQmNrw50fgGMLM94j26Iu3+9hDXVYh+VnSrU5AEnkF7aLsOPojO6LVOST4tQSXVaHmB0K7lkejLZlekWTxccgZRCkrOwfkNhndqsl+weXAVXDcJcvi6JoVzurq2luNKxTn5bg9HlTpIcQikY3Qr+l+hOSAaw4PTrMGixJ2yxfDhCBO3aUw1JkqgC4z3Sr8xVJuAxsIOL3qGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ptKQK7/mIdsMOGrnrUfKMfX2Q/HzzJzh0f1RMZvcGhA=;
 b=VdWhcnZvnNKQIGXb9LJKK5/vjqs7c6JeCEEB0tEJsLtEXHBczd9RrkxfXQXMk5Di31XmJdBQVHrPRTzGRCix1Ywz9G4HO0ArVeMoXf3R8D8KlEfX9DvKkEdbO+MhcNu2XS1J10EGr7eAPf1Ca+sxmSwOSId+QgHeWxEo2NaxsN5s5vHy6ZkINdmix6V+C5jPX65JG3iGLtyOG3vSpoKwz2w2QHieSCU2DloeIArc8tIq7XsTB6W3eem6NW88R2soLJ741J936bNzdZoLu7l16VVz5es7vxT2plrRkFtX3JIXmA4RfS2eM1BwYALglsrZXEqbs1tHqbPBBirnAEfUuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ptKQK7/mIdsMOGrnrUfKMfX2Q/HzzJzh0f1RMZvcGhA=;
 b=q7LNuMD0K/MiBa5dcpw7uqxjjDpb4yuAP1SKhophORF4fOaUJ3KeuR4jfjsUvWfMjWKFnmUPt29u7wRWpd4INHXlqnZWIchIeLCK3ya5J3O/B3l5XrKl1VBCAphJnKIT/0/HGvypjfn893AzeI6t7Fu5NUwQ49C4g2gL6aWszT0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Wed, 14 Jun
 2023 23:24:51 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::d065:bf1f:880e:543e]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::d065:bf1f:880e:543e%3]) with mapi id 15.20.6477.037; Wed, 14 Jun 2023
 23:24:51 +0000
Message-ID: <e995f2d2-0bfb-08aa-3074-db849f759388@amd.com>
Date: Wed, 14 Jun 2023 16:24:49 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH iwl-next v4 05/10] ice: process events created by lag
 netdev event handler
Content-Language: en-US
To: "Ertman, David M" <david.m.ertman@intel.com>,
 "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Cc: "daniel.machon@microchip.com" <daniel.machon@microchip.com>,
 "simon.horman@corigine.com" <simon.horman@corigine.com>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20230609211626.621968-1-david.m.ertman@intel.com>
 <20230609211626.621968-6-david.m.ertman@intel.com>
 <887cbcd2-d01c-2736-d0de-660de80ef4d6@amd.com>
 <MW5PR11MB58117A92BC18CB758DF950BDDD5AA@MW5PR11MB5811.namprd11.prod.outlook.com>
From: Brett Creeley <bcreeley@amd.com>
In-Reply-To: <MW5PR11MB58117A92BC18CB758DF950BDDD5AA@MW5PR11MB5811.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0073.namprd03.prod.outlook.com
 (2603:10b6:a03:331::18) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|BY5PR12MB4322:EE_
X-MS-Office365-Filtering-Correlation-Id: c58c2e65-ae67-4aac-458b-08db6d2e8d43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	m3DW5etTXt80amxkXw8DkqM9gvJ1CtgvsRTzXKR+ZaQbqJSGEPHMhHsYqiGfCA96YktfoIq1g16i/3nYe+TKa9PkpXZbfEg05r89SGm4MHDjp5xkwsHsgtSsPdKnc61tiV8obOECGp+ILC+1GTLMOH8AP+M2q7zWsmTCVWppph2rL9MEyyKj4nt0H2G0TMo5GPCrmSY7PiTjv1MsTt8qioPhunETeM4fXXCuUkrrudwKvwJPHeOvDxpDuOihK33k/hXdjfzham+3VX52k0PuDwPQeRQjUB/lrOZb0A6wDYk2JYub58tuK4mW8GtKF22vx4SPcq7R/K+/N+X0aOO9kDf6q9hvNeoH8Xnf6ejo61HH/ZtZlCHhAlHDV6yh5s0/dX4szNlsKOuC/sczXerrYUJx87hB9so5dppUThrsxPFUUyHjd59fh1VJ9DtIeJz+11pJs/+OYIVaf+B9Z4MwNlGcxn/hpV8hZ5FvrBivmZ9StGBNm9/xy2soz0EQkzYMxdMhkwAcssc3Mh0DmPfU8YoEdJUe7jyZGMbJI432OuwL2UKY9UgoWAVsq69zcYxpVZG5g5GKu50qXsD5Ovnu/PK/AWRZfKn/xFUgT8+s+K+gA8MfF7sDzylQWSnI/DueepTQfifud2jdWDxBBTQTvQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(136003)(396003)(346002)(39860400002)(451199021)(6506007)(6512007)(53546011)(26005)(186003)(2616005)(478600001)(31686004)(6486002)(83380400001)(316002)(110136005)(31696002)(66476007)(54906003)(41300700001)(66556008)(4326008)(66946007)(8676002)(8936002)(5660300002)(36756003)(38100700002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cU5Lck5BbzZDNmtGQ0M2WmpSYlZuaHZUckRKMEd5VDJicDJuS1o1bFl4SVRW?=
 =?utf-8?B?OU1xUmVnVzUvcDk2cHBaWGczNTJmN3RmUXFUcWtrb29JOUtOUTVNZUY2cm1p?=
 =?utf-8?B?Qjk3aUQrSW1NOTZkakZqS3A3a2Y0UE9mU3BEYkpoZ1JYc0ZJQTBxcWkvVEF3?=
 =?utf-8?B?L0wvUEo3ZlVPRXpJODlYTW1GNjNsbjA2M3NZRmdZRUIraUtpVVF4WkFMMGFL?=
 =?utf-8?B?dzVmV0VKTDVMTGtvQUx0T29oalZCdVNRM3pzRGprZGNKbkFyR0ZVM1FJSlph?=
 =?utf-8?B?OTkvZjNWS0E5NVdCYkRHdXFadVNjYWRBQXE3cU1sNGgrNkVwelBTdm1vbDJS?=
 =?utf-8?B?NSt6Q2ZXbXVSRXdmQUxjY25zNldWV2p6dGpVQktMbGl6RkIza3Y4Q3M4c3Vi?=
 =?utf-8?B?ZFJlYmF3NVJRRHgyaWN4YTNsYmcxMVVZcnN0L0VCL04xYXV3WThHaGR2QkVR?=
 =?utf-8?B?dW8rVUJ5dm9GM1hxeDRHQWhwSkUvTVVQZXROTVRVT29CVEQ1SjJ5eUU0LzVD?=
 =?utf-8?B?bE1OOERkQ1V2bG53QmgxaFpUQzBvb2ZyUU1Ydy9jR3dmSUlhak8rS1N1K2Jn?=
 =?utf-8?B?eHprT2dXNnVLYnN3cjlSZ1RLNDc5bEVTaSt5elQvQ2QyVDVaVWZjUFF6WnJy?=
 =?utf-8?B?N3ZZSjh3TXNWdk85amlVUUJTY3JzVEF3NklqekdSdTBwNS83RGpOQjY2OXQ2?=
 =?utf-8?B?OTVsWjJ0TjRKSEtkbVlxK29Dc2wvTVRIejVHZ1dKcGFzR2dtbG5iMmJRVCtw?=
 =?utf-8?B?SERkbE1sRjJ5dStpSElrZDhaVVhtam5lNVlSZCsyenBLUFk0QUhzbDNLM0la?=
 =?utf-8?B?R2tuQndEcG8yeGFNQ0E0eHp6RFJEdFVvbWpPY0xhcFpkZXo0YVZPbkRyaHJq?=
 =?utf-8?B?eVdiRHNzdWMwQkIxbkQvMEZOMVhsQUgvNGZTZmJvWHdiUkFuOWtSbzgzdkxI?=
 =?utf-8?B?UzhETUQwK0MwSzZnUjlaM09QWFJEM0FBY3R5VFhHNU9EcHN3Zm5PQmxqT0RJ?=
 =?utf-8?B?WHk0L292bXVTL0dVbCtuTm1yQUNySWJPaGhaQlJ1dnoyWEVIVHhZeTdrRUp4?=
 =?utf-8?B?V1QwcDRsTGRPTUNRZE1jR3Z5WXVFYnJTeVJVYmozTjRFaDNibGVTMndpR1NY?=
 =?utf-8?B?NlFtaisya3VrYXEvYnVMUk51VFllTkc5Y2h2VjR5VlRleWpmM2hQcDRQVnpS?=
 =?utf-8?B?WDhwdUZZR3EybVF5c0ZOekFXbm5hSXZSekwybDJPSVFleVNiZC9YZXhOKzJY?=
 =?utf-8?B?NGRpZmNLeWM0M2pBam1NK3k0ME43Z0l1NFpvaWlNMFBWL255cnd0QVVneXNs?=
 =?utf-8?B?aVQ2RTMreVJJeXZ2eGRuM2hIRkpWam9ZMHVYTFNIN2RHTmpmZXZuaXFJcEFF?=
 =?utf-8?B?OU91K1VxOFJOQjVET2R5cmdYQmRoKzlsNzJTSFBjRWNNTXNqS2Q1M2Ezd2Fv?=
 =?utf-8?B?UXlEb1RCVldaNlZCMm0waEJ4b0VZcCtETnBwWFY2OXBIbzJ5c0VaYUEyd0M2?=
 =?utf-8?B?ZE1GaTZJek1WSmtKT3EwMno2Vjh2ODgwai9vbWxWbnRRR3RGQXh0MnIzbm9H?=
 =?utf-8?B?RjdSQ0pEM2JoWXk5czRSS3M3OU9wbnpYbmF5VUZ1TkVkYysyekc4ck1qczRu?=
 =?utf-8?B?QUhPR0pDYndkMkNFeFV4UHlEME5yN3JIMkpUWDVJQml3L2ZyWnlaN2FCcXpv?=
 =?utf-8?B?ZkNpZ2RSUDIzbHgzSk42aFhZWU9FQy9iNTRkb05iSnovWjZCOEo4ZHBSNHIz?=
 =?utf-8?B?VFQ5Qk9vdkhnYUJEUDdGN1BKNXlIVHA4ZkNTWlE4OEdFVkZ0VUFySkdvWmlP?=
 =?utf-8?B?ZkZtSWxveGxOdlU4Y0F3clg0OGFwT0ZGRWtFSjIzOGZ0VTZ4S1l3QjF1RlZI?=
 =?utf-8?B?aEVXU3gxdnVwWG0xazdCVWpaVis5VllZMURidmo1ZnkvdXhLK2JQRUVWQTFH?=
 =?utf-8?B?dU0vekZONXdCZThLS2JpZ2MxM1dNbXVPYzRlN3g0V2VnTWxEVml3U0RRWlVm?=
 =?utf-8?B?eUNoT251eUYrMkxBQUZFS0dxdys5cmYyejByaUMrNlNJUkJLbndOeXBIUTdZ?=
 =?utf-8?B?elVYRmdmVithNmRidm5rM1dMcXF4b3JIR3RiclZ6NFRJVzd4SFdJdk1aRWxU?=
 =?utf-8?Q?aNa6qz3rlv/2eKFWE1NKyuxb7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c58c2e65-ae67-4aac-458b-08db6d2e8d43
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 23:24:50.9921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r882ZCLs1cRhGEnrV30IzXLpilk4g5+CGLWm9NzaJ8L/FszNEKQz/JJv6HU/byZlNECfzmheagLT1MaJVr9nBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4322
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/14/2023 4:19 PM, Ertman, David M wrote:
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
>> Subject: Re: [PATCH iwl-next v4 05/10] ice: process events created by lag
>> netdev event handler
>>
>> On 6/9/2023 2:16 PM, Dave Ertman wrote:
>>> Caution: This message originated from an External Source. Use proper
>> caution when opening attachments, clicking links, or responding.
>>>
>>>
>>> Add in the function framework for the processing of LAG events.  Also add
>>> in helper function to perform common tasks.
>>>
>>> Add the basis of the process of linking a lower netdev to an upper netdev.
>>>
>>> Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
>>> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
>>> ---
>>>    drivers/net/ethernet/intel/ice/ice_lag.c      | 535 +++++++++++++++---
>>>    drivers/net/ethernet/intel/ice/ice_lag.h      |   1 +
>>>    drivers/net/ethernet/intel/ice/ice_switch.c   |  10 +-
>>>    drivers/net/ethernet/intel/ice/ice_switch.h   |   3 +
>>>    drivers/net/ethernet/intel/ice/ice_virtchnl.c |   2 +
>>>    5 files changed, 478 insertions(+), 73 deletions(-)
>>>
>>
>> [...]
>>
>>> +/**
>>> + * ice_lag_reclaim_vf_nodes - When interface leaving bond primary
>> reclaims nodes
>>> + * @lag: primary interface lag struct
>>> + * @src_hw: HW struct for current node location
>>> + */
>>> +static void
>>> +ice_lag_reclaim_vf_nodes(struct ice_lag *lag, struct ice_hw *src_hw)
>>> +{
>>> +       struct ice_pf *pf;
>>> +       int i, tc;
>>> +
>>> +       if (!lag->primary || !src_hw)
>>> +               return;
>>> +
>>> +       pf = lag->pf;
>>> +       ice_for_each_vsi(pf, i)
>>> +               if (pf->vsi[i] && (pf->vsi[i]->type == ICE_VSI_VF ||
>>> +                                  pf->vsi[i]->type == ICE_VSI_SWITCHDEV_CTRL))
>>> +                       ice_for_each_traffic_class(tc)
>>> +                               ice_lag_reclaim_vf_tc(lag, src_hw, i, tc);
>>
>> Seems like indentation got messed up here for ice_lag_reclaim_vf_tc()?
>> Is this supposed to be under the if block?
> 
> Unless I am missing something, looks correct to me?  The if statement has a parenthetical
> sub block that the second line of the if statement is aligning to.  The ice_for_each_traffic_class
> is one indent in from the if block, and the ice_lag_reclaim_vf_tc is under the macro'd for statement.
> 
> DaveE

Yeah, you are right. I misread the ice_for_each_traffic_class() as a 
function call for some reason, which is where my confusion came in. Thanks!

>>
>>> +}
>>> +
>>
>>
>> [...]

