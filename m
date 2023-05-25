Return-Path: <netdev+bounces-5250-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3433C7106B4
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 09:50:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD2852813FC
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 07:50:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9D8DBE76;
	Thu, 25 May 2023 07:50:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95AA7BE50
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 07:50:36 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B45186
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 00:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685001033; x=1716537033;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ACesLFQX/otj+ByF30wzcHJOLgbyBQIAmycxnSV3Na0=;
  b=epYpEdo/dQ6LeRo8Hx78DslglG1s2DiemG2ANP7/pWu+r4BF5SEg1TR1
   2a+JbXl7/SujCxTtvgKFtoCz9RfrA3tHCF4KvlYoeRbO7DOTbRlQoM00+
   dvzjwrfGBDzqLScIkWy6VZBj92MTj2rhBHEIrX9bUgKjHucUG696owmOm
   Q6bBYRY3hrCrkHFzA/iWL8suxA+cEIofd/MtOmH6k2mt0IbFhDxa5utfk
   SpQCmYraIYOnPmW1d1zTjc0NENCHVM8apoeUB6WQMu+ji3JrvBxEp03sp
   iViKTVCLDSUY39IDxa/YKDdptcF4mPCE1FfgyNlTrG+q9pponyBy/egBz
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="419539831"
X-IronPort-AV: E=Sophos;i="6.00,190,1681196400"; 
   d="scan'208";a="419539831"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 00:50:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="704703545"
X-IronPort-AV: E=Sophos;i="6.00,190,1681196400"; 
   d="scan'208";a="704703545"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP; 25 May 2023 00:50:07 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 25 May 2023 00:50:07 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 25 May 2023 00:50:07 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 25 May 2023 00:50:07 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 25 May 2023 00:50:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AgsO+dwPj4rDj+lgVARHhEWk5wnuxJETMl/N6Y2MyZxHjUYZDvsBtdkarLGpDzNjqYjn3ifKiOesGpk4o7yMlWeOuaH2klgMh2izTmNa1bUyJf/dhTcZbzeAujjsXbK0NJq5Caach+soOWLWDP4GxWad/WrBD7M3LS/FXDtbSWugE/CoiV5pETmyqITQu5sRwXmPzJW1Nu1juJWEgkbRYEh4oQ2KcO2cRkx9Oe0aXtm2Z/42wIi5pwxUW/1tM/6A6zs5i2+xJ6sPw9Tm+dgbF/zT2JCXETS7lDzNgt1TesaFKe4xLONvViED1k088c4rqHJZQu955tM83sZxT54y/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H0Moo3tXEphI47LoLPMKkZO1vZKcLlllGSqvKoxxAXQ=;
 b=MQGDrYwlku/W+rb2oxIAm2PTpX9EPJHwMJsHD1H1UXdllBfRIkINQHkqxsK0xHezsucM7kAPVVqybFim+mm6qps7xDdMuE9keUuBr5sggFDsAQSUb2Y5bNSJnwm35YkBJBfJ0bLfyqUX18mfBpxq2EogMFY6hfG8FW7WfRLDrLuA/sJr4TkZXnIB3oWCftY2G1sCgNdFQTWnRLuTDYoxMs4E48xpTBXz9Khh8OeT51KumcJlNbV7uUAFDpaEki1Gv5buSkzi5j9URDI9Ft/fDlHu9+AHiEIM9LE+qpspr9qvLQjRsF6Ayshs36Wt/IBYByTXQfSFqLQlkdtAOUYMdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5603.namprd11.prod.outlook.com (2603:10b6:5:35c::12)
 by CY8PR11MB7105.namprd11.prod.outlook.com (2603:10b6:930:53::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.16; Thu, 25 May
 2023 07:50:00 +0000
Received: from CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::4287:6d31:8c78:de92]) by CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::4287:6d31:8c78:de92%6]) with mapi id 15.20.6433.015; Thu, 25 May 2023
 07:50:00 +0000
Message-ID: <e5a3edb9-1f6b-d7af-3f3a-4c80ee567c6b@intel.com>
Date: Thu, 25 May 2023 09:49:53 +0200
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
 <7ece1ba9-03bf-b836-1c55-c57f5235467c@intel.com>
 <20230524130240.24a47852@kernel.org>
From: "Wilczynski, Michal" <michal.wilczynski@intel.com>
In-Reply-To: <20230524130240.24a47852@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0162.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b3::9) To CO6PR11MB5603.namprd11.prod.outlook.com
 (2603:10b6:5:35c::12)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5603:EE_|CY8PR11MB7105:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d97103a-1bf9-46dd-34ee-08db5cf4a44c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WeJQdcE+sCg6Dbi1CjpFYeQQqr0rZgB5y1+YBJENGPdAGmp/8w58V3vKmdrWlg25kT9d0iHok7v2I+GtfxHCUeUit4QkGuaIKnJlgGDRiWPbZo8n+alIDtdbFztWIs8kByh5Lw97Gj8yfuP52N+OO9HgrS+4pedzgaQJpI8ahgNeZO9o1mbhufe9yPTUCsoG/8nP6mpR6RYnPdP034jwm98fOKbwMRos5E6hf3jysrTuVfne+KUS8tsVv1zCoyrBfCEA9EYFN0HyH2sEBiBs6eaO8v+W/bokBIeOxrw/H4IolOzZ+cTaZNReBBqd9Ej5CMIBpbZCHKTifepRBXQhaow7NQvpPEEmvO1zx4t7IaywRmbM3VBfB3Ot0cuyRGIP5l3xzAZFlw5iq2hgSjPDv/I2kt2jSJKQOwJdeEPN0hH/TKQuHuWFLnBmtohYnhUzS4zMYKJQUqujNoRSXxSje8xOswZWnni3iq9Mnzb2bNPNMRYdG6O2ykz2n8mwdfqqCKYp1Y/4uQbZHIN8gNBsXT59yowSDq8GEjYE4/CrF1evs3+hdM6doj1aK7Ji4BFfndQVD7OXmpeTXgeqK0Ubmrhqq156wUkuIDKbzr/lcJ6DJwED4d9keYmShIQAlG9sNz/LV+JyLSzIZCCrPDG15g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(136003)(346002)(39860400002)(366004)(451199021)(31686004)(6506007)(107886003)(6512007)(41300700001)(8936002)(8676002)(2616005)(186003)(26005)(53546011)(86362001)(4326008)(36756003)(2906002)(478600001)(66556008)(6916009)(66476007)(66946007)(5660300002)(83380400001)(316002)(54906003)(31696002)(38100700002)(6486002)(6666004)(82960400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V2pRSHJiOGJ1YjJYVU9jV0h6NEtpTkVnaURCREllQy96c3o5bEVIZ3RvMTQ0?=
 =?utf-8?B?OGtIa1pnMUJ0WDc0Z2ZDbHl0MWNDTzdPMTNVM1huZ3Z1TWs0eWsvenlSS21u?=
 =?utf-8?B?VXlJNkV6cTdCaDFkSE1CWnpyMEtIV3lLMnZSYXByK1lBREpsQlNyb2hCM3d2?=
 =?utf-8?B?d3IzMk8vYkFwSFR2UnBMSFEyUytzc0JCbXpUYzlBUmRFbHpmbmlSQ1hXcEp4?=
 =?utf-8?B?UFlKd0pjZHNUKzk5NjlBcEh0RjlsOXozUlRCK1lBcjN2K1ZCa05XV3NBTnZt?=
 =?utf-8?B?dHN4ZnV6VTNGWDlLYzFJOWlkRU9Hbk1wbnNHTWR5alpBL25PNHRLeHcrVllW?=
 =?utf-8?B?STZwZmxjUENZTFQ4aXI4dzJxN1oxRDFuc3VMQWl3bmpFSjJORlNERHcrUndZ?=
 =?utf-8?B?bW5HdkZWWWhZem9CYzdDYUo2RHNJMnNRcnA0V250QjJnZ1JtNjFhTmk2WFRN?=
 =?utf-8?B?SERnSFBDTDlFSlNmQ3REVEhQazVYdWtDck45SUlYRGJtRndObnRxR2p6M3Y1?=
 =?utf-8?B?MlR0V3lSVjJLL2kvaFh2M1ZTK21NM2ZWOERDUDRMTkZydHo0Mm1NYWZnTlNF?=
 =?utf-8?B?Nzc5TGw5Y25DMlZyY09pUmpDT0ZMWGtYb2NoRC9CYUlKSzlMbEZOTTdOdy9p?=
 =?utf-8?B?K3RmSTNmNGtUU3NkZDhZR1hkaUYxVXRId0NDZkgvU0I3ancrZTQxUHcvN3Fy?=
 =?utf-8?B?QUl2bGFWc1pUTnFzUjBXOXV1UzREc2RpVFp1OUtwZXNHeHdHQVV6V2pCbk1t?=
 =?utf-8?B?YVVHejJMaVFXekw2cHplVDdCVlhBL2NDUkpucEoxVStJaFpBZXpuc0dEemJ6?=
 =?utf-8?B?Q2tKd09Od00wc0pGdGJCN2s4aS81emFKNm9CRC95MGM1K0REUUpkZUhSS1g3?=
 =?utf-8?B?clIwSTI0aU1zM2VXck81M1UwZzd2UUk0Zk5JcGkzOWY5cExnY1J4UVBMSmla?=
 =?utf-8?B?ODhPRkhyVTVNWG1PQ3VyOWNzREV2eHRQc0hpeHNKM2Q1WHZDK1hGeVNxS1JB?=
 =?utf-8?B?M2R4a01HblFKSFlzZ0t3R1pWNHdaVDBPdmxqRDUxSzVXT0ZwZlpaMkgrS1do?=
 =?utf-8?B?b3BNSjNmQ29VMkp2NjJmdWlJdkx6OUZYOGsrNk9VMU5UUlJGMmhOSjVWNVBW?=
 =?utf-8?B?L0l6SnMrbW5nRGN6em0yQlBoME1TSWFzb2RjandqditKNjhGZjN4VyszRmln?=
 =?utf-8?B?ck14UGFCdW5EY29nSUFDcXJWb2ZYazU5N1ZXY3lxR2R5emxkbG9XVE10aVY1?=
 =?utf-8?B?czFYTnh0dUluZWIxQ3Y4TzJYaU95NjFLMFJrT1NSKzh1bE8welVNZjZFb3Fj?=
 =?utf-8?B?bENqNCtRQWlEK29BL3h2ejlwTTJOWE53bDNqMU5qLy9nVGNTeEtZTUFsOUNR?=
 =?utf-8?B?VW9qc1E2YXhwdkF3Vk1kMHY5RjlQS3dLdGtqcDRJdXk4VjNLU0pGM2lzRWZy?=
 =?utf-8?B?V0JuWWdvbGtWZURuZ0F5VGxUQjJvbFI3WDQvNFhtKzJGVWw2UFRGemQzazZG?=
 =?utf-8?B?Q3p6ZVMxRE9McTR5VDlyM2s4S3lzR1JYKzc0Yjdnc0FNVWJ4ZzdtOUp0NGpr?=
 =?utf-8?B?NEZBWW5za1k0YnlPUUdZdngrbSsva3FIZEtycGNZdHpFQmRwQ3p0NkEyU0Zn?=
 =?utf-8?B?RVhSY3NDelhNSnFja2dZdEQwYmpqUTB5cW15dWZscXFKbjdrcmxzeGZBalRO?=
 =?utf-8?B?QzJMZkZyK21yblRoajQzR3paSEJYc1hzL29FM2xqTGR1Sm9WdnFwL2llUkdN?=
 =?utf-8?B?czgxWlJYYkJCcnZtYk5FakJvT0NGSXdOa2lBNXd6bmsyTkRYWWFoK0VnbUFQ?=
 =?utf-8?B?aXRITmFBRzNmbTc4d2U0OGNHNHBXN0t6bW5aT01XcmhFRC9CNzRxQTM1WTM2?=
 =?utf-8?B?VzlwZUlxaVhpbWZJVkhGS0N3QzVlTFhRTmdqdWRXVlRNNmIxNXFjSTRhT1Ba?=
 =?utf-8?B?UmQ0blBOOWl6b1R0dTZnN0xKNUdEZDNWa0FwREhJOExTUDJWd0ZSaEhObkp2?=
 =?utf-8?B?enVVTlhBNWhpMnIvelkvRGhBTitFN3lSWW9xMW1oVUFxUjJiUGtwdVU4MVNB?=
 =?utf-8?B?WGJDMENpTHByOVYxVjFPS1A0YlNNOVFDUS9HSFlWajV4eHg2ZU1FWkhpcVNq?=
 =?utf-8?B?MVhVMHptTXpRMTlKQXFJRnkwUnYyQ05PWjJsVjVNell4WHpaOEhWcktPU3JJ?=
 =?utf-8?B?VUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d97103a-1bf9-46dd-34ee-08db5cf4a44c
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2023 07:50:00.7832
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dq+E92x8Q4zsRXtaVfzVjwuLWGpawWbW1skVZoVoPQYcGKkUXWrUPAHy76bRho3Z3xNNv9bB9W59dmfOMH/BiVUcRFqA2h+kLCqFH5FQbuw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7105
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/24/2023 10:02 PM, Jakub Kicinski wrote:
> On Wed, 24 May 2023 18:59:20 +0200 Wilczynski, Michal wrote:
>>  [...]  
>>>> I wouldn't say it's a FW bug. Both approaches - 9-layer and 5-layer
>>>> have their own pros and cons, and in some cases 5-layer is
>>>> preferable, especially if the user desires the performance to be
>>>> better. But at the same time the user gives up the layers in a tree
>>>> that are actually useful in some cases (especially if using DCB, but
>>>> also recently added devlink-rate implementation).  
>>> I didn't notice mentions of DCB and devlink-rate in the series.
>>> The whole thing is really poorly explained.  
>> Sorry about that, I gave examples from the top of my head, since those are the
>> features that potentially could modify the scheduler tree, seemed obvious to me
>> at the time. Lowering number of layers in the scheduling tree increases performance,
>> but only allows you to create a much simpler scheduling tree. I agree that mentioning the
>> features that actually modify the scheduling tree could be helpful to the reviewer.
> Reviewer is one thing, but also the user. The documentation needs to be
> clear enough for the user to be able to confidently make a choice one
> way or the other. I'm not sure 5- vs 9-layer is meaningful to the user
> at all.

It is relevant especially if the number of VF's/queues is not a multiply of 8, as described
in the first commit of this series - that's the real-world user problem. Performance was
not consistent among queues if you had 9 queues for example.

But I was also trying to provide some background on why we don't want to make 5-layer
topology the default in the answers above.


>  In fact, the entire configuration would be better defined as
> a choice of features user wants to be available and the FW || driver
> makes the decision on how to implement that most efficiently.

User can change number of queues/VF's 'on the fly' , but change in topology
requires a reboot basically, since the contents of the NVM are changed.

So to accomplish that we would need to perform topology change after each
change to number of queues to adapt, and it's not feasible to reboot every time
user changes number of queues.

Additionally 5-layer topology doesn't disable any of the features mentioned
(i.e. DCB/devlink-rate) it just makes them work a bit differently, but they still
should work.

To summarize: I would say that this series address specific performance problem
user might have if their queue count is not a power of 8. I can't see how this can
be solved by a choice of features, as the decision regarding number of queues can
be made 'on-the-fly'.

Regards,
Michał






