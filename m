Return-Path: <netdev+bounces-5132-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F6C670FC11
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 18:59:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25EDD28134E
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 16:59:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4571119E56;
	Wed, 24 May 2023 16:59:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB6F4406
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 16:59:33 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E715BB
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 09:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684947571; x=1716483571;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rqchs36uHH8Ae9zhlcGr+GXcGWadsCejhB3GErZJ/sk=;
  b=DFX8VGo0lyABg1jGccfjVI9J+TLLFTiVMdwKnZ0ri8A5KfQvqMO8wQ5r
   +piCuFHDRiwYIn4afs2bvJVi5uoR552SMtcmrpgaQ2YZWxUfhGfRG4wgn
   m5O0/cdcsBAjsyX0jmPLGXYKYmOVTNsgOugx0J2BBiAGYLHfaS83+lVyw
   0aRczSYkVXv9DwzFK/d6vA4w61Kc3/gZVs5rVQ2aJ2n5mj4+WujvuUjRk
   +AcpieVo6/sJ+5MbIOoUoz38BQ5sbPfju1kaz1TYRnsVaQOIOBR1U1PWV
   nVDxxDciYWBEN65jF6ZxJGfTl5qrD8NEiZa5ijCtVjKxMJdDf8pD8HN7A
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="381873719"
X-IronPort-AV: E=Sophos;i="6.00,189,1681196400"; 
   d="scan'208";a="381873719"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 09:59:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="816663791"
X-IronPort-AV: E=Sophos;i="6.00,189,1681196400"; 
   d="scan'208";a="816663791"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga002.fm.intel.com with ESMTP; 24 May 2023 09:59:30 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 24 May 2023 09:59:29 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 24 May 2023 09:59:29 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 24 May 2023 09:59:29 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 24 May 2023 09:59:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yz7IcYYbeBtYsVyhLB28b0NAUgVyyF/dEBKjAXF0iv2SDznLaKRlAZsnn0AQxHyIvLB8eYL4FGMRRc6qpxEpQ9ePQDWjgrVK2aFF9BjLPEOkLGCFX9133+vEQnbGd9Ar9Doigjj2osC7i/4DjB1uOhPYO+/vC9mQKpOiLmP0xpFVf2st4k6WJcDEgKeS7iLd2OghxTh66TjAq/DSWfxDo9UrbLTRSrpstdvz3GWaimK71J49UQ9arbbi1ExJ/dv5ZvlOf9X0TOJxNqYJM+FZ3GTCtq4rdWJk4zuTZgSOpTUlaq8uccHoWIK5B9yh4I/L895nBrtt2D9PdVxqOX0JiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t/W2hdQ104ybp9N8QIGLQ/GnNB7kxXUXdwDM2g2BYBI=;
 b=bT/CySHL/PAgs15f1IVlqcbIEvt2MAyyMj691N5wd6GfE0uzQECqYXDKcpsGUXWBzfqSHosq45pcdn9mpYWEvg3Xbk9uQKi08VykzC/lVFzc+y6Wtv6whIh776W+pO2Ni/M/uo+BR9dC2pPKij0Qu80XZNr2EfcNSNIguufghk359BgGHATbo6ytwAox2RDDDL1zhj/izry8M5EG46P5lnnFlvaBLPP9jaoNbpbZxPjNuHNT+ORqEzN8czwjVrLszhbKmZjEtGxZ3rP3nGn+vDQtSDbh5d+DV9wz3jKFLOxvZf946krwYR/Dpb6AKCfI0hf/B7CAXtTf3lBVR19gNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5603.namprd11.prod.outlook.com (2603:10b6:5:35c::12)
 by DM8PR11MB5592.namprd11.prod.outlook.com (2603:10b6:8:35::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.28; Wed, 24 May 2023 16:59:27 +0000
Received: from CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::4287:6d31:8c78:de92]) by CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::4287:6d31:8c78:de92%6]) with mapi id 15.20.6433.015; Wed, 24 May 2023
 16:59:26 +0000
Message-ID: <7ece1ba9-03bf-b836-1c55-c57f5235467c@intel.com>
Date: Wed, 24 May 2023 18:59:20 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH net-next 0/5][pull request] ice: Support 5 layer Tx
 scheduler topology
Content-Language: en-US
To: Jakub Kicinski <kuba@kernel.org>
CC: Jiri Pirko <jiri@resnulli.us>, Tony Nguyen <anthony.l.nguyen@intel.com>,
	<davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
	<netdev@vger.kernel.org>, <lukasz.czapnik@intel.com>,
	<przemyslaw.kitszel@intel.com>
References: <20230523174008.3585300-1-anthony.l.nguyen@intel.com>
 <ZG367+pNuYtvHXPh@nanopsycho>
 <98366fa5-dc88-aa73-d07b-10e3bc84321c@intel.com>
 <20230524092607.17123289@kernel.org>
From: "Wilczynski, Michal" <michal.wilczynski@intel.com>
In-Reply-To: <20230524092607.17123289@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0169.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a0::8) To CO6PR11MB5603.namprd11.prod.outlook.com
 (2603:10b6:5:35c::12)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5603:EE_|DM8PR11MB5592:EE_
X-MS-Office365-Filtering-Correlation-Id: 25012c2d-c800-45fc-4c83-08db5c783b68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MFh3dcM8COnq+FhBqhubxJzJfBjkpGNDhhODfze5Lh7FFPSmF4p/UGGAazucSnPKAOY28rFyE5aADHTld88R1eielp+dPA3vaNvWE87gsIeX1VoXdWZ2g/2MeEDtd3KXC1gwNKv4p6UCXihADTY+2U1qyuOFoDHuxWney5GXnJu0CPO7y9bOywXFPW+6Ka+8a1GgSGt9nz8Id3xyxkjbOkLuO/knk3IMCPHiOxFBatRxoMAzwqC23uhZH6JVlZPISQvtyR/6JpKxN2+mQatkkx33hwF8BJGZrCBWunlhsVf/x6noR/sgnIF4zkPwqp2spDQcQYRro2+zIzeccK8aJROm3XXrBYvD4Gx+klozCERml+kbVhX3S9LTubepEpVJWYPE6rdTV3bS9AUc7LwBlerfjfcObhKzO8LPu1uO12Q5rPvs8ozom80fwAeFXXl/RqQTfXlKS0/vTWh6ZvmBdc6HXhVI0flYiRN5RWmgyfAJl2OE/tb9z72GoQSV2Ig909mD3v0zRfJFRQGg0/amX2CXDUsasDYNbm40OLWv/sfslQ8pk9ZxnqRMi2AuHFkqDOOblTLCI0w1BFc5aBnWq2jgC9IT8fol6/FRAj4AmiPm1cM/+3SGjrNHZWpbUW+zOfPs/AjDj3GmuqpHHwozoQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(396003)(39860400002)(366004)(346002)(451199021)(31686004)(83380400001)(2906002)(8676002)(5660300002)(6666004)(6486002)(107886003)(4326008)(6916009)(8936002)(66556008)(66476007)(66946007)(36756003)(316002)(54906003)(478600001)(2616005)(38100700002)(186003)(26005)(82960400001)(6506007)(53546011)(6512007)(41300700001)(31696002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RG1zVDZhSnYrZWpLaTUxV1gzcXIyR3krZm96RkE0bzJldkYrY3d1TjNmV2RN?=
 =?utf-8?B?U0wxa0MrZ1hUVmxRZ2MvRHRGTlJXREl5c21WREYweFNUWjVjWHhPYzBsQWxu?=
 =?utf-8?B?NDV0TnN6RjJHeG15TER2aWhkTWRWdHQ4dFRVMlVUTnJTZkdkcG1VRHRKN203?=
 =?utf-8?B?MFZ3ZEhGMmNRSzB6UVdja1FMK2ZXNGFNSjh2aEt2bEFzdzh1YlpOZXk5TlZn?=
 =?utf-8?B?M3BpWUkwRE51VEFVcUZLcEwzekExbmYxVTZmSDRMdVoxN1BVc1FKWDIrUWhI?=
 =?utf-8?B?YWoxbFF6V09KeG5zdE5ZdjlVQ1RtdE4vMmR5TGZ2RU5ucENTTjcxSWhLR3di?=
 =?utf-8?B?bG9VTUErNDFlcWRYdkNDSE5OcnVOWjFITkRCU1M0TDRIY0k5RWlKR1ZwWHN0?=
 =?utf-8?B?RTVlcG5RR2xxSEIzT0NVLy9nM1BxemRVRHVlcTYrZHhPbGQzaXdVMTZmM1RW?=
 =?utf-8?B?NkxzWmpCZ3d2YVRLdk1FeUNOWFZJM3NkTlJpVzdna1ZnVXlhcVh5V0MyV0dG?=
 =?utf-8?B?YzBFWmlrWkNwV1lBOGVxcjhmMGgra1d5SlhaV3hNMXF5K0t5WDJTcnV5cGZK?=
 =?utf-8?B?QWYxRG5sNGdUSENyUU56ZE02L1VMZHk5VXJTS21adHYzYTBocThsbmtGOG15?=
 =?utf-8?B?NHZOcmppM1hnajBFc3E0MlYxd1h4d1BYVG5DSHpYZFRSbTdpVFZlVHRkdFJH?=
 =?utf-8?B?TzZkMXJpQWt4cm05QTJGUEh0Q0F4WXlmOGhJY1ZGN0I3LysrWGxMOHdJL2lG?=
 =?utf-8?B?K3pvcFc3UUo0dlFqMjVNVjJRYVhrZ1BBbEpCZ05EL2dOUzdudC9nb3BnSXg0?=
 =?utf-8?B?MXBRcytyejh6WVpZRTRiY21YeVdTaW96UVNDaU5ZODI2SjF4cnhpelJmZmJW?=
 =?utf-8?B?V1B6MHJTbkNyS0psMTIwNzZOWDJ3VkpLRGl6cDRmM01UYm1FM3ozSjJod1pL?=
 =?utf-8?B?V0h3Sk1ITlVueWR2WUdzd0d1bkluTkRlR3JWdEIyZnNXK2ZYb29jQ3FmdERn?=
 =?utf-8?B?US9IMDNNNzZRRU85dnVmRkdCM0FFUlFnSlBVTENRNVhhOUFKdHljR2IwRVdS?=
 =?utf-8?B?bXQ3K2FCNW92WTJCN2dOajFPZGp5T2sraEIxc29DRDhPS0tHY015WUV3a1F6?=
 =?utf-8?B?dldmU2swVHRDTWtXYTE4VzA4WndPVis5aHhHVXpvRm5jbWVMYVRMWjBveVc5?=
 =?utf-8?B?SzZyV2RuMWJxNlFpTDZrVXlURHNXdHRnZ1RqdmZvS29FbmszcjNaT1h1S0Ev?=
 =?utf-8?B?eDIrYkgwajBocWtTd3dHaEkza0N2ZEI2WWVMSXRpRjBCQ1dzQU5TdkxLcjgw?=
 =?utf-8?B?MWJweEN0eGlwRHFYalg2dHpKalcyNzZjUklreVczdkUyMlBGLzZudUFrTG9s?=
 =?utf-8?B?QVpkbTk2Q3c4a1Vib3lSQ0tKUzlSaVdhMG1tc2NBMnB6ZjA4Q1h3elhaRDla?=
 =?utf-8?B?NGM0N29qQzBnS3N5bjUvb1h0QmhVbTJsdFdLUGRua2hkUjdEaXhRQU8rNGdn?=
 =?utf-8?B?ZENLRzBYbjM1dHZFYUFldEFmTGt0Vi9vR2FCYk5wenp1SzhYNkhDRm81dDMz?=
 =?utf-8?B?K2pLdTF1eCsrOE5DSnVZb0Zrem1BM2gwYkNvdWlBS3BjZTZQbmM0UHRodlg5?=
 =?utf-8?B?R09ZTHpieHVMYmN2Zk1uc1MvalpiSm5aUFkvMklIYm5JRDVOMitCMXFPdDZR?=
 =?utf-8?B?d3YvNnlCWEh2RytXSE9XeXQ1YW1STml2Q3dsOWVYV1VnYStYU21WcjZhRjJ1?=
 =?utf-8?B?OXgyaW5ZeGNzWCtyNzVHUk5udGNXZE8weFdxN2pjTkR5amV2UlpodEsveGxO?=
 =?utf-8?B?ck02MzFINW1LT1pKZ1J6bmhBK2NWNi9CVUIxWHpwdnFoWGIybEgzYWFvd2hX?=
 =?utf-8?B?SjlMeFo4MzY1Z3U0L2dwRkYwWWVCTDUzM2N3WXEvYitXY256a205ZGtwQ1dl?=
 =?utf-8?B?N3R6Q1FCRWd3TVcxMjNhVUR1cnBWWEpEUEkrSzNKMmZ5aDJpbXVuZUgwS3NK?=
 =?utf-8?B?dTdMVmlHOVYxWXV1R0xnZXFPWVJCYURQazZrUFhNYlpiQnZxU3lwS1dWVEsz?=
 =?utf-8?B?aCtMUlQ1VzhOL3V6Q01CZXp3OHJGangwN21LcmFtWTJNcU5jZmpndDdhdDc0?=
 =?utf-8?B?ZEIrOHNsV1UwbGFGS0dhd3dyWUR4M0pROUdrVEhCdVlTWS9ET1JOVk1DNFVH?=
 =?utf-8?B?bGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 25012c2d-c800-45fc-4c83-08db5c783b68
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 16:59:26.8473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IH5DN8JHyr5DwqwFty8h9c4qwEoFj6KO384ysRLO+uhlhUahDClqIgqyv8pYboJmhcdCkB/rULD0OVj2/11sobl0shjCp0TiV1PYFYojCqM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5592
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/24/2023 6:26 PM, Jakub Kicinski wrote:
> On Wed, 24 May 2023 15:25:22 +0200 Wilczynski, Michal wrote:
>>>> For performance reasons there is a need to have support for selectable
>>>> Tx scheduler topology. Currently firmware supports only the default
>>>> 9-layer and 5-layer topology. This patch series enables switch from
>>>> default to 5-layer topology, if user decides to opt-in.  
>>> Why exactly the user cares which FW implementation you use. From what I
>>> see, there is a FW but causing unequal queue distribution in some cases,
>>> you fox this. Why would the user want to alter the behaviour between
>>> fixed and unfixed?  
>> I wouldn't say it's a FW bug. Both approaches - 9-layer and 5-layer
>> have their own pros and cons, and in some cases 5-layer is
>> preferable, especially if the user desires the performance to be
>> better. But at the same time the user gives up the layers in a tree
>> that are actually useful in some cases (especially if using DCB, but
>> also recently added devlink-rate implementation).
> I didn't notice mentions of DCB and devlink-rate in the series.
> The whole thing is really poorly explained.

Sorry about that, I gave examples from the top of my head, since those are the
features that potentially could modify the scheduler tree, seemed obvious to me
at the time. Lowering number of layers in the scheduling tree increases performance,
but only allows you to create a much simpler scheduling tree. I agree that mentioning the
features that actually modify the scheduling tree could be helpful to the reviewer.

Regards,
Michał



