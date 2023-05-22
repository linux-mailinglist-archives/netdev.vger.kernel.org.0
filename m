Return-Path: <netdev+bounces-4134-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AC1E70B363
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 04:55:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E5B8280E16
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 02:55:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2316EA49;
	Mon, 22 May 2023 02:55:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B253A2C
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 02:55:04 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 348BDA0
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 19:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684724102; x=1716260102;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=i/h2X6n5zmcSGdR4Ip2RdQtAdltRsscE/+niCj+LASg=;
  b=YoE1jfK8VoO0Z9wkbIsJHFcBanR006PwZTFAloMuUkVwEP+sEaydmvkf
   ttp4IkT8iQduom2Cu6L8FCPhWzSLSOQCDXIcJjcUuaf4bZnT9TF5B+OIp
   sq+3bNXGaUGTxzCtUitLCkeUGjJu4Yd15oN9HrVOJEQ1QRnV8U6B+Gyqi
   XGx/vMzuEi/b6EIluCZP7YH6Ft81Gs6z1iIgDZ6YJ/kCFGiclHld5Ke+/
   KbMJ9Kn0onywULMk6WI8WfUpTPqXvFQVjRY0kL4ykfHq/dknRr8kcFIs3
   2hmDSm3Hzz9J/hDHv1yoXtf15U5L4Ug/dea268U2lFic7D+3Gi+OB1wLR
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="350320794"
X-IronPort-AV: E=Sophos;i="6.00,183,1681196400"; 
   d="scan'208";a="350320794"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2023 19:55:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="768344651"
X-IronPort-AV: E=Sophos;i="6.00,183,1681196400"; 
   d="scan'208";a="768344651"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 21 May 2023 19:55:01 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 21 May 2023 19:55:00 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 21 May 2023 19:55:00 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 21 May 2023 19:55:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LzNfZ/izn5Lkps5opE9ZT/KChpIc8dX1T7DS2YytQHJq1/R8tId7dAyz4Rj3R0VwF18O/JNnRebl015wsg/Z/araxvJ9pVHjAalC4RWpjNPD98ER+FPpdxKAsyT0GWf0T+Rhsw5yyDESzS+5sNwZK9HAoohN+kupgC8KQ69f5Eun4r+7zZm3+af67+CRLBPH50rdFf26U+6NE1972Cuz0K6hhq5W4VOUnhK6GnnilHj1D2HPNfx3SIlTPYGffOoaKPn4v2RH8/ul6bYLrkuxmEd3xh9Gouua3vvkiW0fuFOcesdRW0YT8Rq3O49eODxuhypsbLe7uBX3i382UvZFuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q284aBZ/Uiklf7MMXzReokfHA4AcGhBD7k+n6UeVbCI=;
 b=Pgp0xnL4621LV44L9O3TpbJ2XiaFNC4uN8BJwx4C7lz/qae7E819oN+Hmyu/dxbFqayNxM0eJ+k353SWdf5DEDxV9v5rO52MqTWEQps/OWSwPJY/sIz3CZfJkiMdCADj7MZzmR5CQDgTv4Td09YCtBIF1DRwlf/QGxV6hDhXgEdcOOL6MNdW91T8sYJicUqqYJRNJ6wGMG0URgsKCEnX2KHbO2w22sIqIgQBbAhZHG46HCtdjYau0bED/S5Sb+gZSrHWur6p0mnCJneTq5FJInKp/XvFlfzzKiZDVNrhk2gbcQSJRTJB9gilJAHIYvj1BZLpQsWqCLoIIcXTtz1XGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4886.namprd11.prod.outlook.com (2603:10b6:510:33::22)
 by DS0PR11MB6328.namprd11.prod.outlook.com (2603:10b6:8:cc::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.28; Mon, 22 May 2023 02:54:58 +0000
Received: from PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::bc17:d050:e04d:f740]) by PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::bc17:d050:e04d:f740%4]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 02:54:58 +0000
Message-ID: <50c01916-4da5-82bf-04b1-496be065224d@intel.com>
Date: Sun, 21 May 2023 19:54:55 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH iwl-next v4 00/15] Introduce Intel IDPF driver
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Emil Tantilov <emil.s.tantilov@intel.com>,
	<intel-wired-lan@lists.osuosl.org>, <shannon.nelson@amd.com>,
	<simon.horman@corigine.com>, <leon@kernel.org>, <decot@google.com>,
	<willemb@google.com>, <jesse.brandeburg@intel.com>,
	<anthony.l.nguyen@intel.com>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>, "Singhai,
 Anjali" <anjali.singhai@intel.com>, "Orr, Michael" <michael.orr@intel.com>
References: <20230508194326.482-1-emil.s.tantilov@intel.com>
 <20230512023234-mutt-send-email-mst@kernel.org>
 <6a900cd7-470a-3611-c88a-9f901c56c97f@intel.com>
 <20230518130452-mutt-send-email-mst@kernel.org>
 <dba3d773-0834-10fe-01a1-511b4dd263e5@intel.com>
 <20230519013710-mutt-send-email-mst@kernel.org>
 <bb44cf67-3b8c-7cc2-b48e-438cc9af5fdb@intel.com>
 <20230521051826-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
In-Reply-To: <20230521051826-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0018.prod.exchangelabs.com (2603:10b6:a02:80::31)
 To PH0PR11MB4886.namprd11.prod.outlook.com (2603:10b6:510:33::22)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4886:EE_|DS0PR11MB6328:EE_
X-MS-Office365-Filtering-Correlation-Id: 490c43b6-9cd7-44d9-db5f-08db5a6fedd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AKOpyNIR0XIM9plLLd3TjV9yylNzJzu6Ad6kKplt6CErBASIN7pjrq3Z44YfQpd6MwCvzUyVoa02BM9aPWmLabmFpZk+RQNBLkrkh+YjVSmfRdNVlRHJkGwsLyYnYc/YPxOmtQZ/s6M2aZUKRuNvp+xQd55X3Gq0FcKYo9Ap0NA8aDlZb/H85kgfGOyrx6fcscf/K4YrasdVfCWish32R91cr+NlNcZMjkuK17vhr60zCuNMYePXyuOknpZUOYI/A6VWgiGjq5i0Sywswsc9BpqJuZodAla2mQFZvgxHMts2ZGmgo0up41jQwUXYh5uBWBCrbzgN05nkf+sZ8euHlHeCJv5uj2nVlsJSacoCQ+VaaHJ1O2KJ7i+bFem8oPuztVM9xJmZn92/u2wxInl9DbFofx97HJEFXZ7yC8wYoOn0XllasJGKTmE+XoOSDHgqdkVqBzHPkzF9vXeADEnqNx8zr1FlxvGC+e+5MJ4ZH5nIF7OQOHpsp0rvHut+LQIe2JuujamEXyjuv74QoREwIujcwxRhWLB/moQwniWyJtG7We2tqPSpfXuhdS3BZb9goqR3/KKZnZW9usjPxzTA3PYc6i2jqZ7Ls797XpFY9tb2rbrIGtx4LxtCQ+jEzVeea+WRhRyA3ATIFWnTBW4kKHob1oiHAlU3Wy1LuFe1bio=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(346002)(376002)(366004)(136003)(451199021)(7416002)(5660300002)(8936002)(8676002)(83380400001)(2906002)(186003)(36756003)(2616005)(82960400001)(38100700002)(31696002)(86362001)(107886003)(6512007)(6506007)(26005)(53546011)(966005)(54906003)(31686004)(316002)(6666004)(478600001)(66556008)(66476007)(6916009)(4326008)(66946007)(6486002)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MFd6NzVDakRvREVOL1V6OWVveVJwZXVMSlY2V3Jra0ZwVm9JWmt6Z2FWUHox?=
 =?utf-8?B?U1c4eGZJSy9xZW1MY3EvNEdzd1BlVjFPSnJUVVF2TnZBbE93T3JnQzR6bVd6?=
 =?utf-8?B?dWpkcGxNeHBXaktUczJzQjdVMk1UcktmUWkrcTRVMy9mWHJiRHFlMGxRaVdW?=
 =?utf-8?B?SitETy9IWGR2d1N4UWdzRitEQThBZGxKUThNcWlUQW9zK091dnB2eTh0QldC?=
 =?utf-8?B?ZCtyRjc5cDF6VjhXTndweGhseVRqMVJPVXFVcFplRm4yTUFsWmlDUUtQVUhK?=
 =?utf-8?B?T3NCbXRXajhUbGlNTDJIK0dDZ2dBOTNlMGJ5VlZJNUs5ZFBhRVlkTGZDc0pT?=
 =?utf-8?B?OGExOTU2NXlBQkxIZWpqUlExUFhFNStkNURIemp5ZVFVRUtjNmUwLzlaQVpT?=
 =?utf-8?B?Rkc5dmpBbU5NUi9OWHBIZzZnWC80VnBIbVlrdnFXUTdqZWhMenJ3eTAyamMr?=
 =?utf-8?B?MldsQ3AzeXo5emhTbm00MyszSm9Kd0QwQjBzRDRzMU9VS3BSaWEzQ1JYUTBN?=
 =?utf-8?B?c1UvUHBJTlNxdWJOVG0yR1htMWhMeWVhYm8rKzlCNmdVVUF5aWJOSFVFcWs1?=
 =?utf-8?B?aUduc2JOSHo0a0ZMdXFrMjI2Vi8relFNUWR2cU1IcGkrbzBGendvZVVTQUdL?=
 =?utf-8?B?U2lTbnZDdWVHSm4ybGE5YU4rWFMycHB0T3h3emZKUW5JUTYrOWsvekdSUjlF?=
 =?utf-8?B?T05ZWlQwd2RQcVdmb2pvT25MVTBrMmYwM3dkeGVrL0w5WUlmWVg1SXA2eXlE?=
 =?utf-8?B?dFdBRkdqN2kya3R4OGpiN1BZOVhCRFFlbHF1ZFRFQ2J4Vi9sRWdtUCt3UlR6?=
 =?utf-8?B?aXRRYldUUzYwRlkwNHVKaHhkN2tLYmFvY0U4dlZ0b1FBR3diS1Z1Z3pITmxu?=
 =?utf-8?B?Zm5kRmlTMjhWRGJYVmRRdlhBODMwMDhXNEpCdGcwdHZEUExvZXFUN1lEMGMy?=
 =?utf-8?B?R0QrWHBUTFhyMDRSL2NjZ3FMWnRVcjlyb0t6TE45ZlJOK3pQbnpkQkQ3R2Fr?=
 =?utf-8?B?ZnNOY1pMSXBrZTg0Z2pUL0RMMzRLRWVMN29YOEJ0Y0tvSzF5QnQxTXk1Q1cv?=
 =?utf-8?B?MVJtN3FJeUQyT3VFUUsxTW5FS01SSlpFZlZ0bFkyajJpcHJsQWJhZjlmSm9q?=
 =?utf-8?B?RlprYnBDOWo5K2dmTXUwNm1mKzQydkdFVHZKOGtoQmpvU2FXZ1NLSVVySWdG?=
 =?utf-8?B?MUdkcDhCaTRZdEhRVC96cTNBR3BNSWZGOEFBSHdPL2lXWnJVY3B5ZE9ncVgr?=
 =?utf-8?B?NWt6QTVWbnh6Z3BZdnJqbFhQTGhYUnFiL0VzaVFjN3UwaU5tQU8yVDRlVVRr?=
 =?utf-8?B?bHRpQm03SUlaNVJvdHZLN1Vncm1FYm1kbVhLZlZxK0hWWDY4WDV5elZlbVhx?=
 =?utf-8?B?QitOWVFpN0E2WmpYS1puQUU0VVpmQTdaSk5DbnpuQkZLdktranEzZStEbEZv?=
 =?utf-8?B?UkhTcmZIUTZkbk10UXFLWUNjdDQ5eGliUzFkOGN2eWRUMnBzNGx4ZTMvbjhr?=
 =?utf-8?B?SVFyd05Ra2JEQ3JzckVhUkZQaC91UWJveW5GTzNJb1ZqNnR0ei95cXpaTDB3?=
 =?utf-8?B?OHlVZm1pWGlJMWFsYWR3a2ltQ3k1L09IQ0J3cXN1TzdnT2tuL2JqVjh6Vmda?=
 =?utf-8?B?cnlTaHdCRXhTTmxadlRUallZWWF0L2RSa2d1MVVwaFBaaFdMclk4SnRYcDA5?=
 =?utf-8?B?NC9XSGo3d0trbGpFN0RpaCtXZGVwcE8yZXczejNqTm5pV3hXQlZBWmJlUSsw?=
 =?utf-8?B?TklocVlTdFUxU2FES1QvcUJ1VHhVdVZFTkZLd2xUdldaVTdWRTV3dmRRajdh?=
 =?utf-8?B?YXBST2o3d0h0cTVZdmVhNUZ0dUg1V0dDM1BJbllYc21SYlV4a0VkZzVFaEg5?=
 =?utf-8?B?eWsvcDVJUnZUeEgzYWxIdVVsbFRXMUJaMzZxd1lHYUdWZ0lhekp2V2tKOHg4?=
 =?utf-8?B?dVhqSkdYSDh0Y3dXZkRTVDZIYVFQTjd2R2FVWmVXTUNuZ0hMci9lalQ1OW96?=
 =?utf-8?B?eFZKbDZPWk1XSTNHTGluTGhaMFhhNEpON3dhd2kzMUg0VHJJUGVIRTBMUXBN?=
 =?utf-8?B?VG56UVhhcDR6ODIxS2R0UkNFOHYvd1FZUi9EUHBpUGVpOTJBSFJpejFrWmFx?=
 =?utf-8?B?Nmd3bGYyd0hWVktoUDZnVm5LRTVQak9hYVFaTmhYSDRaZVk2NkVOOHY1emEr?=
 =?utf-8?B?Nnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 490c43b6-9cd7-44d9-db5f-08db5a6fedd0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2023 02:54:58.4051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0QVsAzOaCr6YY0wa49YB991e74Qw9GP9aG9PLrTh4SLDjVE3ct9AN5LG5vRjM3B9l3FpNf8ft9nRPgO9TsWAlxSyus4OA54lA+gAB4Iqh5M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6328
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/21/2023 2:21 AM, Michael S. Tsirkin wrote:
> On Fri, May 19, 2023 at 10:36:00AM -0700, Samudrala, Sridhar wrote:
>>
>>
>> On 5/18/2023 10:49 PM, Michael S. Tsirkin wrote:
>>> On Thu, May 18, 2023 at 04:26:24PM -0700, Samudrala, Sridhar wrote:
>>>>
>>>>
>>>> On 5/18/2023 10:10 AM, Michael S. Tsirkin wrote:
>>>>> On Thu, May 18, 2023 at 09:19:31AM -0700, Samudrala, Sridhar wrote:
>>>>>>
>>>>>>
>>>>>> On 5/11/2023 11:34 PM, Michael S. Tsirkin wrote:
>>>>>>> On Mon, May 08, 2023 at 12:43:11PM -0700, Emil Tantilov wrote:
>>>>>>>> This patch series introduces the Intel Infrastructure Data Path Function
>>>>>>>> (IDPF) driver. It is used for both physical and virtual functions. Except
>>>>>>>> for some of the device operations the rest of the functionality is the
>>>>>>>> same for both PF and VF. IDPF uses virtchnl version2 opcodes and
>>>>>>>> structures defined in the virtchnl2 header file which helps the driver
>>>>>>>> to learn the capabilities and register offsets from the device
>>>>>>>> Control Plane (CP) instead of assuming the default values.
>>>>>>>
>>>>>>> So, is this for merge in the next cycle?  Should this be an RFC rather?
>>>>>>> It seems unlikely that the IDPF specification will be finalized by that
>>>>>>> time - how are you going to handle any specification changes?
>>>>>>
>>>>>> Yes. we would like this driver to be merged in the next cycle(6.5).
>>>>>> Based on the community feedback on v1 version of the driver, we removed all
>>>>>> references to OASIS standard and at this time this is an intel vendor
>>>>>> driver.
>>>>>>
>>>>>> Links to v1 and v2 discussion threads
>>>>>> https://lore.kernel.org/netdev/20230329140404.1647925-1-pavan.kumar.linga@intel.com/
>>>>>> https://lore.kernel.org/netdev/20230411011354.2619359-1-pavan.kumar.linga@intel.com/
>>>>>>
>>>>>> The v1->v2 change log reflects this update.
>>>>>> v1 --> v2: link [1]
>>>>>>     * removed the OASIS reference in the commit message to make it clear
>>>>>>       that this is an Intel vendor specific driver
>>>>>
>>>>> Yes this makes sense.
>>>>>
>>>>>
>>>>>> Any IDPF specification updates would be handled as part of the changes that
>>>>>> would be required to make this a common standards driver.
>>>>>
>>>>>
>>>>> So my question is, would it make sense to update Kconfig and module name
>>>>> to be "ipu" or if you prefer "intel-idpf" to make it clear this is
>>>>> currently an Intel vendor specific driver?  And then when you make it a
>>>>> common standards driver rename it to idpf?  The point being to help make
>>>>> sure users are not confused about whether they got a driver with
>>>>> or without IDPF updates. It's not critical I guess but seems like a good
>>>>> idea. WDYT?
>>>>
>>>> It would be more disruptive to change the name of the driver. We can update
>>>> the pci device table, module description and possibly driver version when we
>>>> are ready to make this a standard driver.
>>>> So we would prefer not changing the driver name.
>>>
>>> Kconfig entry and description too?
>>>
>>
>> The current Kconfig entry has Intel references.
>>
>> +config IDPF
>> +	tristate "Intel(R) Infrastructure Data Path Function Support"
>> +	depends on PCI_MSI
>> +	select DIMLIB
>> +	help
>> +	  This driver supports Intel(R) Infrastructure Processing Unit (IPU)
>> +	  devices.
>>
>> It can be updated with Intel references removed when the spec becomes
>> standard and meets the community requirements.
> 
> Right, name says IDPF support help says IPU support.
> Also config does not match name.
> 
> Do you want:
> 
> 
> config INTEL_IDPF
> 	tristate "Intel(R) Infrastructure Data Path Function Support"
> 
> and should help say
> 
> 	  This driver supports Intel(R) Infrastructure Data Path Function
> 	  devices.
> ?

IDPF Kconfig entry is listed only when CONFIG_NET_VENDOR_INTEL is 
selected. So I think adding INTEL_ prefix to the config entry under 
Intel devices sounds redundant.

But we can definitely update the help section as you suggested to match 
with the name.

