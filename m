Return-Path: <netdev+bounces-6473-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C229716650
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 17:12:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52C8C28128C
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 15:12:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92FFA23D77;
	Tue, 30 May 2023 15:12:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED2E17AD4
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 15:12:00 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265F68E
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 08:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685459518; x=1716995518;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fpusGfT0eCqr02i/xuNctgzWlgY8THQJaGmvWRg9xt8=;
  b=NT6Gjjxuu4sf6qlCaX7bWFiA5JC2V4QYXrDTBXRwMUcXGucVUkn9vqfi
   RxwcXlZNyEK6joE6PDIQjzoXgJBtkerq+Tnv9p0b7Y3AgGYHfOWXZrlcZ
   /wGvvqKRxCItdjljOrx6/HmibLH/8RYAotpVobgPduY5y3bSVttxvZmMA
   kax1XBk1RepYzPWb2TJxh3nSr+FhfP9lGj4O3g437aGLo11cqc8NTxDOg
   7UKtz845yuc36DgO8KQ+W9CxfoGGEv1avx8DY+peCmXV9OThFihWa5NSL
   1raN+otOqhs2Rnsz8CQL/BG1hLISHpPxtkH9PkEaE3T3PS6VOU+iFbYvZ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="441303134"
X-IronPort-AV: E=Sophos;i="6.00,204,1681196400"; 
   d="scan'208";a="441303134"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 08:11:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="818861870"
X-IronPort-AV: E=Sophos;i="6.00,204,1681196400"; 
   d="scan'208";a="818861870"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 30 May 2023 08:11:57 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 30 May 2023 08:11:56 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 30 May 2023 08:11:56 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 30 May 2023 08:11:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nh5Qpk/9eegkJ69I78276uQwnOQ4MTk8PkwFTMTYZQTJz7SwkHbRWNXw16Dvv5YR2xltFQYSSJBqAXsp+V77M0oqdAqzk1iOHlGkZ3UV3+jVvTjUCvg1fuWzaSV2h2kl0l0Xe8lkgHoCCd+Pqm20rQb/qpglG62Qp5Re/XtbicM/zg4ROsg4APml90Qk4SQ3Pp5U+pqvaHmP0QTejl8BO+tCTz/ZY1KK02B++QpiLt2PsnLiV+zP0jIyx5RVKTecNVH1izSComiOckDEtp0UohL24HLk/T3kkqC7Oq6+MzilyZJomNcEUESmQPMsa7fFDAPYylKrViYAIV8Xq3PBCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4lPeGA6K9SL+79XOouz8vbu3LI6UxrwiD7udynzH8Lk=;
 b=i+e+5jFwhaosdE7eliL/j/o7iqUautX9n5mWxcEHHdjqO2XttAdiK1sHRkNhvpRCPE1a+Os0Ty8Q/Ubd2vxWjtuvwIXP4nFiqW20qMyE3bHXilcS4H/e50yvu1TdgGyPxidZvOUBmS9j5vA8HajNb3Bf/zZHMiCQVEulYNYN66RzZ0JC1CMWImQFmZS55MOmbiwK6Q68Cy6XxKptdfDyU5Cx8eR2YlbSJGoBiYfMladmu4ERg81R92kRcc+jnWGztLwCC4HZE+0YlZsN1jdDvWhU6B0Cv47Ck0Kt47L7bxciky8Chgp911hZ+Du1w9eRLZ+9Xwd/h3gxUzxz1R/ukQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7491.namprd11.prod.outlook.com (2603:10b6:806:349::8)
 by SJ2PR11MB8565.namprd11.prod.outlook.com (2603:10b6:a03:56b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 15:11:54 +0000
Received: from SN7PR11MB7491.namprd11.prod.outlook.com
 ([fe80::e162:f0e1:1dbb:7ea5]) by SN7PR11MB7491.namprd11.prod.outlook.com
 ([fe80::e162:f0e1:1dbb:7ea5%2]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 15:11:54 +0000
Message-ID: <194528a1-1789-b31c-c7ec-aff55d7c259d@intel.com>
Date: Tue, 30 May 2023 17:11:46 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.11.2
Subject: Re: [PATCH net] ice: Fix ice module unload
Content-Language: en-US
To: Jiri Pirko <jiri@resnulli.us>, Tony Nguyen <anthony.l.nguyen@intel.com>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <netdev@vger.kernel.org>, Michal Swiatkowski
	<michal.swiatkowski@linux.intel.com>, Arpana Arland
	<arpanax.arland@intel.com>, <przemyslaw.kitszel@intel.com>
References: <20230523173033.3577110-1-anthony.l.nguyen@intel.com>
 <ZG34v/FrUoEMkpMH@nanopsycho>
From: "Buchocki, JakubX" <jakubx.buchocki@intel.com>
In-Reply-To: <ZG34v/FrUoEMkpMH@nanopsycho>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0258.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b5::10) To SN7PR11MB7491.namprd11.prod.outlook.com
 (2603:10b6:806:349::8)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7491:EE_|SJ2PR11MB8565:EE_
X-MS-Office365-Filtering-Correlation-Id: 34e480c1-1aaf-49b8-7407-08db612033b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FXJbdKM6c9KXozIq/zZW36XUhQHEALOH7uFbJF7TlHxL8VpGuCaw+bddL9Xjm76PWk7Q5mLov4csdHiKZuEV4iXlxGkrMIgDTplbVVxcR6QxDI3T+GtGo+Yy5rwb5RksLOcqYaA/sva+66xUNeRmGiIoHgXldPd8Q1P03kVXHQkD0bV7d/K4gVPqKHn5o1A6hbEJMMrbgS49+xnZ+buUJuktI2oFbIMs1i7hdSCBqw3bnj7FJrw8N/0JQ3KuZheX8KAMS43nXbwHAdzmsBq5AW3HNRWL3Pih6enqCY9PQ83vex7gpBxWgdAVRL3vY69Q7lATX4kuY9+7q4vDEzRGtzmG+9YABs0qxS/R+eV+XvYx3XzpIO9Q3Rn6kzGfp+QEcnAx9BriWCJzdVQvngG5kFDZgy4BuEXns5Ij2f2mw1aALdWtGT1Tttp9KbIPD4ikYlStTqMW5+dT/gTHgll67/Lghd3I2KeDLMiIeycqOPUfP4h25aSZKVw9LYPptjWnN8PyqwcZEcF92fFgif6bpRy//OELaoCWm/41zalkyK/brpdlXlPhR7EkV2+WIRiMxlK9jpoHOgSATBphvXXlr3Gq4deIiojhvNfh+CnP+qirf6U+MTkuuLoXBe+hTRJncS9mJ+R364dtCv6M+H28VQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7491.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(346002)(366004)(376002)(396003)(451199021)(478600001)(31696002)(6486002)(86362001)(41300700001)(6636002)(6666004)(4326008)(316002)(36756003)(66476007)(66946007)(66556008)(5660300002)(186003)(2906002)(53546011)(31686004)(6506007)(6512007)(26005)(2616005)(83380400001)(66899021)(8676002)(54906003)(8936002)(82960400001)(110136005)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b0VWM2YwZDA3K0hQbTZlUFlIZ0ZLeGc1ajNJeTFYR2JGYlBuVEU4VEFaZDRY?=
 =?utf-8?B?Q09NemkvY1pLUEgxL1BibzRRcmxseVJYWk5vaGd1Mi9CYzg0aFM3dXhqb3dU?=
 =?utf-8?B?TCttWWJoQkFydFRhbkdSbzE1anJsVWt0WTFzVU9yVXJscjZVZlB5SDIyOHEr?=
 =?utf-8?B?dG52UEZYVEI2UFVETEs2cEx0N2VnQnpRM0ZFcXhxM0xTbThZeE5aeDQwU2dJ?=
 =?utf-8?B?QjlSZ2c5WTRhbXA0QmxUSUFyWnA3WlY4ME1USU5zVndTYmNhR3N6WGkwbWEr?=
 =?utf-8?B?Q09tOWZKbDNwUzgvT3BpUXplYUdoZzZrNEN2empxVmRxbGEzbFhWSGpYTG5S?=
 =?utf-8?B?a2Y1WVdXUmdRNFhBcDhOeU1FNEFENVJmODlCK0xmNERaRmgzMHBRS1VwaUU0?=
 =?utf-8?B?NzhzTHVRQzJsU2NYd2psclQwZ0lld1lXKzF6V1VGSzJYTFVXcmt0WXQyYzVj?=
 =?utf-8?B?WHdSdVpwZlgzVTJXNHd1VHFablZZTGlzaUIremhUREo1b3FBRittcm9VaTdP?=
 =?utf-8?B?UGhRaE9aN1pNeVBKUmtGUmc2bVNyay8rY2pVeCtkVVJsUzRuY0Z0MVRScGpu?=
 =?utf-8?B?aHMzaE4zQm5kUVdaV1hnWWtDdThpN0VSSk9BcDJrc3lIblJOVmgxdklYRVla?=
 =?utf-8?B?T0ZJaDYvcGJkVld6NGpHZFdhdjFjR3p3ODVUWEVPOVBLY0dXcFkwNXZ3TG5l?=
 =?utf-8?B?Ulc2cWJpL2JzendTaS9CdTZIOHZEaWs0ZktaM1ZHdXlFUkkvYVNWVitRdWZj?=
 =?utf-8?B?T3ZBUklvaU5XcE1SSElQMEZmbVZwTVk2eEhNaExFaC9xaGtlY2FBNW91SUZt?=
 =?utf-8?B?SG9laGE4bVU1N3lyZ1VyK3k3MmZkVE13SUViVTVzQUtSaWVrYkxLZyt4Rk1W?=
 =?utf-8?B?SmJWemxwcUlHeERtNytiM3V0aU9PV0pROGZuenJPbGMrZktyM3JpT3NGT0R6?=
 =?utf-8?B?aG1XZjRKRWhDUUxLV0FOR29PWDFONVN0aUZFWTBjWUMrMDJQNTBFbXRCc2pL?=
 =?utf-8?B?SjY1KzJ1YnE1Vk80WkpmUVNCR250UnFmVmV1cUtlVzlmbXZxWFdtcFVqL1pX?=
 =?utf-8?B?Z2w0cTE3M1ZuQ0ZpeTlYcVlEWUJ6RXlIRDdCaTBYczg0V0xrR2gvRGFjbkp1?=
 =?utf-8?B?bWtWZXhJMVZ4K1VJbEJyaUNhdGp2bFJYZHNPbGNIZmxMbWdrSGo3MytjRU5J?=
 =?utf-8?B?ZUwrcHlzUE4yWWdsRXZ3MTVwbVFrUlh2VzE5YW5XYnpSMkJPOW1KSHZoU0Z6?=
 =?utf-8?B?RFJoamluT08xQTdXRW1sVXVvMFZBbHQxaVF3bm5uY0ZibnVpekNyWU5zblp2?=
 =?utf-8?B?aTFUdFFJaVhGVmlVQjFteDFWQzNwM0lxK1hzcXJLZW44dlBmQzF5azhhcWpD?=
 =?utf-8?B?QkoxNm1sSGE4ekMrcWc5MzhsUlVZY3BXaHhZbGY3VWVPNW40cDVBR1p2ZWp5?=
 =?utf-8?B?UzNlWDB0RFJ1NUJ2RksrTFJDRmFkYVlsa1NsSEtxR1RWS2hCOFdrZldGU2F4?=
 =?utf-8?B?dEJBaVlUUEMvOUlURUFhMzZWYklPL1dWb2dIOG9HMnpFcFBkdmZOcTFVMlZR?=
 =?utf-8?B?eWpJcy91dURjSThVbkEvcWViS1h0czFUNS9vc2dsRHZQbFZ2aldnWmo3OFpU?=
 =?utf-8?B?TzBnb3JnM1ZMTjArSDBIN2hBQUxWckdjeFdCTnZZUXk0bytyZmtDUklTaUJp?=
 =?utf-8?B?U3BybHo4TWJINk10SGVxOE1lWDc2V211R0x2VXg5dFJ5SmFaVURPVi9icHpu?=
 =?utf-8?B?ay9uZGljOFdsUlZnb2dKVXYwYkg3TkM3RlNmNU40aCt6SG83WWp4c1JPLzhy?=
 =?utf-8?B?QlAySUdoSzdvQWpNZFpvdEJxOFVlNWlDS2hOQloxRmtoNkxRZU8rRzR3aXZa?=
 =?utf-8?B?bEtaK0NmTnlCcVNBYVV5NHJJdEZnOGZEZFAwNERjbms3SlB0SmF5clFNbGF3?=
 =?utf-8?B?a1Z6U3AzUzlBQjFDQWpXSjVtQzMzSlE3RXltVllNRDVTTmNheWdXTFRjVTRL?=
 =?utf-8?B?cjRUbzJoM2t0YXhOZ2J4MUlHRlVOVUdpN0lrSmEzMUpwYUlkN0FPUDYrTWlK?=
 =?utf-8?B?Vlk3NHZLTmJEL0ExenVEMCtJNzJtRUgxelMxTVAxTGU2N1hmQUdJcVh1NUg1?=
 =?utf-8?B?T1NXaUdUZjlVbDRqYXVJdXdKS1ByZ3I1SDF0YS9XT0pMbktvcm16bThWT1R1?=
 =?utf-8?B?aWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 34e480c1-1aaf-49b8-7407-08db612033b1
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7491.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 15:11:54.0714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jOcznQjuOkKD2KhNTAYewbO2MhqUZc0Jg3ql7URGq3YxcvGqRcB9tlyS8ISyd5c3mZoEUzi75YJC00qXzz5At5cOIHfvjoMqkdc8DUnJRBs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8565
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/24/2023 1:45 PM, Jiri Pirko wrote:
> Tue, May 23, 2023 at 07:30:33PM CEST, anthony.l.nguyen@intel.com wrote:
>> From: Jakub Buchocki <jakubx.buchocki@intel.com>
>>
>> Clearing interrupt scheme before PFR reset, during the removal routine,
>> could cause the hardware errors and possibly lead to system reboot, as
>> the PF reset can cause the interrupt to be generated.
>> Move clearing interrupt scheme from device deinitialization subprocedure,
>> and call it directly in particular routines. In ice_remove(), call the
>> ice_clear_interrupt_scheme() after the PFR is complete and all pending
>> transactions are done.
>>
>> Error example:
>> [   75.229328] ice 0000:ca:00.1: Failed to read Tx Scheduler Tree - User Selection data from flash
>> [   77.571315] {1}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 1
>> [   77.571418] {1}[Hardware Error]: event severity: recoverable
>> [   77.571459] {1}[Hardware Error]:  Error 0, type: recoverable
>> [   77.571500] {1}[Hardware Error]:   section_type: PCIe error
>> [   77.571540] {1}[Hardware Error]:   port_type: 4, root port
>> [   77.571580] {1}[Hardware Error]:   version: 3.0
>> [   77.571615] {1}[Hardware Error]:   command: 0x0547, status: 0x4010
>> [   77.571661] {1}[Hardware Error]:   device_id: 0000:c9:02.0
>> [   77.571703] {1}[Hardware Error]:   slot: 25
>> [   77.571736] {1}[Hardware Error]:   secondary_bus: 0xca
>> [   77.571773] {1}[Hardware Error]:   vendor_id: 0x8086, device_id: 0x347a
>> [   77.571821] {1}[Hardware Error]:   class_code: 060400
>> [   77.571858] {1}[Hardware Error]:   bridge: secondary_status: 0x2800, control: 0x0013
>> [   77.572490] pcieport 0000:c9:02.0: AER: aer_status: 0x00200000, aer_mask: 0x00100020
>> [   77.572870] pcieport 0000:c9:02.0:    [21] ACSViol                (First)
>> [   77.573222] pcieport 0000:c9:02.0: AER: aer_layer=Transaction Layer, aer_agent=Receiver ID
>> [   77.573554] pcieport 0000:c9:02.0: AER: aer_uncor_severity: 0x00463010
>> [   77.691273] {2}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 1
>> [   77.691738] {2}[Hardware Error]: event severity: recoverable
>> [   77.691971] {2}[Hardware Error]:  Error 0, type: recoverable
>> [   77.692192] {2}[Hardware Error]:   section_type: PCIe error
>> [   77.692403] {2}[Hardware Error]:   port_type: 4, root port
>> [   77.692616] {2}[Hardware Error]:   version: 3.0
>> [   77.692825] {2}[Hardware Error]:   command: 0x0547, status: 0x4010
>> [   77.693032] {2}[Hardware Error]:   device_id: 0000:c9:02.0
>> [   77.693238] {2}[Hardware Error]:   slot: 25
>> [   77.693440] {2}[Hardware Error]:   secondary_bus: 0xca
>> [   77.693641] {2}[Hardware Error]:   vendor_id: 0x8086, device_id: 0x347a
>> [   77.693853] {2}[Hardware Error]:   class_code: 060400
>> [   77.694054] {2}[Hardware Error]:   bridge: secondary_status: 0x0800, control: 0x0013
>> [   77.719115] pci 0000:ca:00.1: AER: can't recover (no error_detected callback)
>> [   77.719140] pcieport 0000:c9:02.0: AER: device recovery failed
>> [   77.719216] pcieport 0000:c9:02.0: AER: aer_status: 0x00200000, aer_mask: 0x00100020
>> [   77.719390] pcieport 0000:c9:02.0:    [21] ACSViol                (First)
>> [   77.719557] pcieport 0000:c9:02.0: AER: aer_layer=Transaction Layer, aer_agent=Receiver ID
>> [   77.719723] pcieport 0000:c9:02.0: AER: aer_uncor_severity: 0x00463010
>>
>> Fixes: 5b246e533d01 ("ice: split probe into smaller functions")
>> Signed-off-by: Jakub Buchocki <jakubx.buchocki@intel.com>
>> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
>> Tested-by: Arpana Arland <arpanax.arland@intel.com> (A Contingent worker at Intel)
>> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
>> ---
>> drivers/net/ethernet/intel/ice/ice_main.c | 7 ++++++-
>> 1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
>> index a1f7c8edc22f..5052250b147e 100644
>> --- a/drivers/net/ethernet/intel/ice/ice_main.c
>> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
>> @@ -4802,7 +4802,6 @@ static int ice_init_dev(struct ice_pf *pf)
>> static void ice_deinit_dev(struct ice_pf *pf)
>> {
>> 	ice_free_irq_msix_misc(pf);
>> -	ice_clear_interrupt_scheme(pf);
>> 	ice_deinit_pf(pf);
>> 	ice_deinit_hw(&pf->hw);
>> }
>> @@ -5071,6 +5070,7 @@ static int ice_init(struct ice_pf *pf)
>> 	ice_dealloc_vsis(pf);
>> err_alloc_vsis:
>> 	ice_deinit_dev(pf);
>> +	ice_clear_interrupt_scheme(pf);
> 
> Can't you maintain the same order of calling
> ice_clear_interrupt_scheme() and ice_deinit_pf()?
> 

Sorry, for the delayed response.
We tried to maintain the same order and move the PFR reset and
pci_wait_for_pending_transaction() to ice_deinit_dev().
The code looked cleaner but it made the unloading process much longer (~6s/PF).
At this point, to keep the order of calls we would have to break the
ice_deinit_dev() back to individual calls and it doesn't seem to be
that beneficial.

>> 	return err;
>> }
>>
>> @@ -5098,6 +5098,8 @@ int ice_load(struct ice_pf *pf)
>> 	if (err)
>> 		return err;
> 
> Don't you need pci_wait_for_pending_transaction() here as well?
> 
> Btw, why can't you do reset in ice_unload to follow the same patterns as
> probe/remove?
> 
> 

This patch was limited to the changes required to fix the issue, targeted for net.
Your ask is accurate and it might be a good change, but I would prefer to work
on it in another series (for net-next), so it can be properly tested.

>>
>> +	ice_clear_interrupt_scheme(pf);
>> +
>> 	err = ice_init_dev(pf);
>> 	if (err)
>> 		return err;
>> @@ -5132,6 +5134,7 @@ int ice_load(struct ice_pf *pf)
>> 	ice_vsi_decfg(ice_get_main_vsi(pf));
>> err_vsi_cfg:
>> 	ice_deinit_dev(pf);
>> +	ice_clear_interrupt_scheme(pf);
>> 	return err;
>> }
>>
>> @@ -5251,6 +5254,7 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
>> 	ice_deinit_eth(pf);
>> err_init_eth:
>> 	ice_deinit(pf);
>> +	ice_clear_interrupt_scheme(pf);
>> err_init:
>> 	pci_disable_device(pdev);
>> 	return err;
>> @@ -5360,6 +5364,7 @@ static void ice_remove(struct pci_dev *pdev)
>> 	 */
>> 	ice_reset(&pf->hw, ICE_RESET_PFR);
>> 	pci_wait_for_pending_transaction(pdev);
>> +	ice_clear_interrupt_scheme(pf);
>> 	pci_disable_device(pdev);
>> }
>>
>> -- 
>> 2.38.1
>>
>>

