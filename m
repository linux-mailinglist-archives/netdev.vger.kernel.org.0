Return-Path: <netdev+bounces-3447-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC45A7072A1
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 21:58:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C17D41C20EB9
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 19:58:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEAAB34CF6;
	Wed, 17 May 2023 19:58:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B38C111AD
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 19:58:51 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA85BE67
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 12:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684353529; x=1715889529;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5cbTEdMJVbj+HyisAu6jtGTWzugI0KL3u32A6azdskY=;
  b=WYNabD8ajQFAM2LMKy1hmnN2FDH6pX64tLThczkekzpj2hqpbUm78M1N
   COBmhWiR5f2/I1P/ZKaBDIhwGUrXyJh0igvzYuzPxUF8jWhN6BX9U+iAF
   e/SuvXPqJPsbax4gyRuEBLX0n2sOFskt90Kx/ftJaLG7OHV9twQI2w9ak
   juIzK6uI68vC+ypGZ8Ymnz78TKpOY+orkfFMlHQ2DAgo7bcxCOFJTSFk9
   W8UoEAMNGpeAWAI1684OgUumFygetu8te/LjOc15U+8YPkAibJqB6YfoJ
   dN2aDsyOOkeZ4Go1mtHsiceR9LiCo18yi/7Q173Ele8Duc99I9ptj0gg8
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="355039554"
X-IronPort-AV: E=Sophos;i="5.99,283,1677571200"; 
   d="scan'208";a="355039554"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2023 12:58:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="814003738"
X-IronPort-AV: E=Sophos;i="5.99,283,1677571200"; 
   d="scan'208";a="814003738"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 17 May 2023 12:58:48 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 17 May 2023 12:58:48 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 17 May 2023 12:58:48 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 17 May 2023 12:58:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=evuYE3PQdBR3OO3hSnZNkl+/8cbiodmLPF+fNfIT+H0eiVyAksxCU9S/pGkSZIqstw4RAatPR2mafmZNHFO3cU/SUAIfNGEbJH0wL24FyhEVr1xJfARsbkbPgvW+hufsnZb0y/bDpRpvQZSLxf9iBbHHyoQ7pdpboa1UuU5T4pg63ivF6d2KJoUm8yzknTUiG2khsLinJSSuF+whhYpIPiUFrSi3QvXyMWGnA3RIqAELQXeiqX8Zns/wt1eatw216oZ2hg6yH+oB3oPG1o4te2nVBQZ5sVGbpGiNYoXtasu38GG2YvKZ0ZXTmvcJjItIGNhOs016Hjzq9OWnCV2sAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KgZ/JdX840YZBFufQPHuYMOE7fiGnf69WFsdZQ+UrNs=;
 b=HkWv1obYT3FJNxgNJEuG9joLqTDc8Hk43fPBTaYu1FhIdPUOZHZLJsmTQcqXGimcrH075CrczDBznF/CmjTOHvo+G5Gh6OJuwMZz494QYlkYcVViQZA1aFhq1/NgavX5A+zgbCpX4868TP7fCO72sWGiBcabt6GYxK1ajTcaLKe3ZcVbKaCgD90BYYbhDRFLOpdBLYqi9d86AI6SUK47lPy7/qLXeIBvbejUqZ5Z/D5biyDALWRPioTlrPP8+/H0ON2Y15MHp1JMWwngBnyHLvS0woEXor+fYTer9Enhv6od7q6krEVYSD+35rt/8+dNfMrOifKzvB7pFHOabgMHhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CO1PR11MB4962.namprd11.prod.outlook.com (2603:10b6:303:99::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Wed, 17 May
 2023 19:58:46 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::27fc:4cc8:6fea:1584]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::27fc:4cc8:6fea:1584%5]) with mapi id 15.20.6387.032; Wed, 17 May 2023
 19:58:46 +0000
Message-ID: <bd270cc5-607b-0ec2-f5c4-15895067ffe1@intel.com>
Date: Wed, 17 May 2023 12:58:43 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next RFC v4 2/5] net: Expose available time stamping
 layers to user space.
Content-Language: en-US
To: =?UTF-8?Q?K=c3=b6ry_Maincent?= <kory.maincent@bootlin.com>, Jakub Kicinski
	<kuba@kernel.org>
CC: <netdev@vger.kernel.org>, <glipus@gmail.com>,
	<maxime.chevallier@bootlin.com>, <vladimir.oltean@nxp.com>,
	<vadim.fedorenko@linux.dev>, <richardcochran@gmail.com>,
	<gerhard@engleder-embedded.com>, <thomas.petazzoni@bootlin.com>,
	<krzysztof.kozlowski+dt@linaro.org>, <robh+dt@kernel.org>,
	<linux@armlinux.org.uk>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
 <20230406173308.401924-3-kory.maincent@bootlin.com>
 <20230406184646.0c7c2ab1@kernel.org>
 <20230407105857.1b11a000@kmaincent-XPS-13-7390>
From: Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230407105857.1b11a000@kmaincent-XPS-13-7390>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0383.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::28) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|CO1PR11MB4962:EE_
X-MS-Office365-Filtering-Correlation-Id: bcac1228-bc1a-4cd9-669d-08db57111f85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JbkrK/VWJM5R9TyGdSSFEUtDgaIQvrc6l5DObTcAeNQ0zITpxJOs+HwFXRjESZwr44xnlYtmt+MhzlSpQNNoPCUSAgubikUUwHFchKTP+FCBS8+c4kK6RfgNtJkRRoPHlOOI235L3R/AGhpi10Oikq0gV+iIDxaFVnXhDPnVkz8ne8mKTkgSt68NPd4KBLZcXg5KCrkfT59heB0nbmHJm5K9zhDxEaG3t15i9j71gSHg3vABsSP3RwCEeTw75P0jBSYXdlmgnH36cYfJ+v3mW5bjChlD1SY1sziIoYIJp0zMZaksvj3AFgsa/B+SIyS5vbjz5cVSGkuVG6rp6SzBKBSU5RPR2SJk+WKskXsNA8nRRw1VwUcoUt/f/UBcGvQ/gCnw4pi9wkJLXpz7imZpOaBKsfiWURCIXm6pnuxQUk6bBKErYWrt64Ga+lqIDpvM/Mz+C5zDy3OnEovDyaWwt1uBBPgfI7jHGr0IPAe6khfrCuFmRd/W2aG10mxDxYohP3AwRcn59SXImHyN7D7gFzmYm3t5oSqustBwRNdFC9nLE1SmTGbnq3EFCG63NI9qgmWUf08SyxDvlwJW+3G7Ycas1cj58h35/IlFgZzYnAbAnCxiVgfAIghXnpoYVj/P584dCOnmFyE8eiX4HHMNSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(396003)(346002)(39860400002)(366004)(451199021)(31686004)(4326008)(66476007)(66946007)(478600001)(66556008)(316002)(86362001)(110136005)(31696002)(36756003)(2616005)(6506007)(26005)(6512007)(53546011)(186003)(6486002)(8676002)(7416002)(2906002)(5660300002)(8936002)(82960400001)(4744005)(41300700001)(6666004)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WmN2UEJZakVkME9rNzVTdUJtb1pheGJqSWp2SGxJSE5pc3pNOVUrYWJsZHp4?=
 =?utf-8?B?MHhOWVkyTUEzd2VHOW1yMDMweklzMXVZazVSSW1va3QvdTZPY1c4ZzAvWnhz?=
 =?utf-8?B?V1RiZ1VuZmhkbUtQT1NteUZWbytjME4ydndBcnBDcVFGYkcwekJ3bVRKeE51?=
 =?utf-8?B?alpKaTVwVk9FWjdkU0dCMkVWZklOaklJakFrYkx6dW9IWmx0L20wMFJsR1Fo?=
 =?utf-8?B?Rk5CZlpYTnZ3U1F5a2RKaERNNHR1MHczK0tCYVhlYWRxVkJEcTZnRTF3OFNL?=
 =?utf-8?B?WFZMdDNESHl4ZjhxWjhHWlRic3NVdTl5dnR3bElZdzJmUmJQRXJxaGdIYjVJ?=
 =?utf-8?B?QVJDRGgrNVh0b2YxOFFuRTdNeWZBRy9DVUlmYVhoL09tL29kVXN4TTlzN2tu?=
 =?utf-8?B?eHVpK1lwbURsMTFYdjR2d2V6Zk94U09yeTQvMXZyNm1OZ2dLRlBGUGNwdmcz?=
 =?utf-8?B?aU42dUJuNzlyc1BDcFBXb3Zzanc0cWJ0a0xmbUMrcGJHejZTSXlrWE5tZDRK?=
 =?utf-8?B?b3kybFdnMzFjU053RU5GWTljeDZvdTh6RS90dldWUmV6TExBdm5aWmErakta?=
 =?utf-8?B?ZXRHWUc0a0FWNWZCZXZWTDRlWUIrckF4eVVvYUcwdkhRVW9OeUppQXU2aXpV?=
 =?utf-8?B?YWpYSlNyaWFHdnRQNVdYZEhMWk5MRktTWDdzUGFlMDFucnBOT2FnNzVWN0Ez?=
 =?utf-8?B?MTV5RG4vcCtjV3QvY1YzZDZtWEpTT1Vjam01bVUraGRZRHMwTkZWays2MnJF?=
 =?utf-8?B?djBYN1hrRU5jdTg2OXVVeEF2bE43QS8vS0JMM1NxMWtOdmdQb1d0aGJXYWxh?=
 =?utf-8?B?aTRVc1p2YkRLeTl4YU9WV3BseWNYNXRLMGpoVTl1bERscjRuREZNL2dENHRi?=
 =?utf-8?B?a1NOcS9LQUZWYVBHUmRBTThPa2NCUHdNZU4yVFAwWFI0V1MxZmxyaXozR3Zv?=
 =?utf-8?B?UlJ4a2MvQ0hIajVjcDlPT0dLUHQxS2cxTUpmSkFnOHRHQ1huMHlJcCtIU0gx?=
 =?utf-8?B?OEY0RnNtNHN1UEJxR0tENXFqZFMxYVZOeVZZV1Vqczk5cytLTm9xbTZEenVQ?=
 =?utf-8?B?U29ZaW9pbU54V1ozeUVQTHYyQzZSUEp6YnpoK2dlZHM4MFJuOG5DM09PcEQ0?=
 =?utf-8?B?eCsrRTYxM2Q4ak44M2V2SThhRTRRTG9OZG5Md3EwMW56alhzQ1U5Qy9TaE5j?=
 =?utf-8?B?NE40bnBGelYxZmxQaGdQdlJJL3NBalB1WHZ1cXIrdVRZRWQzMlBsSkFYWGJR?=
 =?utf-8?B?YytvdUZiQXZNVCt3V2RXcFlZY3J0SFZDZ0xCekpFWkhUVTR0alB1WVp3djN3?=
 =?utf-8?B?ejFQTXlvcEdLTzNxUjVFcStldU1vMEYxVzdmTEd1NFZwUGE5akxwaHpLak90?=
 =?utf-8?B?OXJuRVhVUzJCZ3hTMk82RDA2NjlEVGRZK0w3SjU0L2E0Qm1JQ0N2YVZ5LzFD?=
 =?utf-8?B?eXFxMHlKNjVkVlFBK0JyRmtyUXhaQzRrVTNSaWtpSWMwUzlTSEx4L0s1ZnBO?=
 =?utf-8?B?QjBxL2hTVmxTK0NLOGdBZ0d5V1Q4RWpiRFA5MjIwNzB0WWxsZE1Jc1RNcll4?=
 =?utf-8?B?UVNkZGNaN1JXMWxDVVVoR1I0NXJvNDZCVk5NaS9QeEpXMndsRVJYcXNyaysz?=
 =?utf-8?B?RjdwMWlEbW1QOWw3RTJDOE1VVHN1bHVYUEVBTTQ1NU5Rd0FaSE9MemhWUHJv?=
 =?utf-8?B?WkUxUm82Y1Y1OEd0SnZFL1ovUTRoN2lUQ1AwRHdLTWRUSVQwTjBIU2JKYzlr?=
 =?utf-8?B?eFRtNGs3UWwydkMvbXUvdnkyT2YyQ1BpbE9xZ2xaeDBTdUpzU05yQ2FTbDBO?=
 =?utf-8?B?U1BoK0tsSzhXWCtiMjhQRlZBZmkxRlJ5dEtxMXltTVUxZ21Ba2VuSWZaYUdw?=
 =?utf-8?B?SkFtN1JoM0h4K2xFMnRncFpGL1p4M0FTaWVwaWlrb0tybFJSSWtQMS81VFdC?=
 =?utf-8?B?V2Z1dWo5MEd3WWRCOUNkcFJOKzNLOElBcXVFZ2ppTm5LZ29Cb3VnUGUxaUFJ?=
 =?utf-8?B?em4rdFM4OUduTXU5eDNCdUZwVEZJTHZuMWhScWpDd25LSlorN3I2STlTM1Y3?=
 =?utf-8?B?WWlYTlV2dGZueklHNDJGaDZteWVKazcvaUoxdVd5cUxBdTE4MVJxOXh0L08w?=
 =?utf-8?B?NXJCWkp1MXR4WkxrVURUSTY3RkRCMld6QkRwNDQzbUd4NTZKSEF6Q1dZekU2?=
 =?utf-8?B?a3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bcac1228-bc1a-4cd9-669d-08db57111f85
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 19:58:45.9657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vmoMjIWCUhLcuaayF8HEY83SpSbCr/QUOqCDYxfqxuJP8ZwN18C4hObhR4EnvPxrtTbAJ8HWdjM0OUfV268GKBmYhk9+naTxmXDRzsIQmHw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4962
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 4/7/2023 1:58 AM, Köry Maincent wrote:
> On Thu, 6 Apr 2023 18:46:46 -0700
>> What does SOF_ stand for? 🤔️
> 
> It was to follow the naming reference in
> "Documentation/networking/timestamping.rst" like SOF_TIMESTAMPING_RX_HARDWARE
> or SOF_TIMESTAMPING_RX_SOFTAWRE but indeed I do not really understand the SOF
> prefix. SocketF?
> 

I believe its something like "Socket Option Flag" or "Socket Option
Feature", but it is pretty old, so I don't really remember full context.

Thanks,
Jake

