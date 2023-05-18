Return-Path: <netdev+bounces-3772-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D13C2708C41
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 01:26:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7CCDF2819AF
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 23:26:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6505B20F7;
	Thu, 18 May 2023 23:26:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C62520EE
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 23:26:32 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AEBAE66
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 16:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684452391; x=1715988391;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Fp27PusR3jmvXNoop1PbbHE4AJz1eFHKblKkN+RykxI=;
  b=FbCyGDVsL7p2XfOHD3bVK8rCekqLnBT+BEC86oP3m4I1S69jtA5VBIft
   CMKNf9pmidkYcxGr5of3yjeDhsi/vbozOCwkHUIPIanKMOoBWcRg8k2bH
   5X3fW753RX20+aBtXHfPYhh8zFO5bTqqqNO1189BHpJ1FQqVuV4nVV6IF
   KDRZ3EJjn4Uh1MpJ1L5agzzDYMmvma6lEdq5/X0Hro8gTPnwvKwtPh5Ed
   MkAxdpRsRUHKWpDzaJ2/L4A4ZTk/rvKEJClrf7OaHIBiPdN+Z6d9x5WKE
   iYj/8jNcxYe0oJYz2fQVKMj8lpNcZNd6CSH43bt8Zj6gLMF5+vH8t1shH
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="349738714"
X-IronPort-AV: E=Sophos;i="6.00,175,1681196400"; 
   d="scan'208";a="349738714"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 16:26:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="772066826"
X-IronPort-AV: E=Sophos;i="6.00,175,1681196400"; 
   d="scan'208";a="772066826"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga004.fm.intel.com with ESMTP; 18 May 2023 16:26:30 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 18 May 2023 16:26:29 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 18 May 2023 16:26:29 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 18 May 2023 16:26:29 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 18 May 2023 16:26:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gHD/mgNm3GtCuQVcHJAfAcwB3KRidvdjqNibkx+2r+5h11JP/kSu4+NGi8T9xI/W7Qsh7fv4HKfEapA6DSxuYUDelO9ro3xvTRgZoPXRrjGaJ6YB8L5b8dIU9KQ/L3f88BSCOMaCTYGGVt4ndpX4svGR+0buZnYcGHW3FdiCdlCjUWusJpWfuvJJxHPSH0VYFEnac5grfseyzo55BW6AIxKhmhLqEUGqk5GBf8tmcc/ACdHV1OqotmVEWH0bbazS9lRGat5bfxJVpID6/yDzoHzE1YW7WaOz4FCqLyJjb+uW5jakWXJfRk9qKoOXQ7DUfSD535nAAc2tvuB5cxNdAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5tKweditLGY9/omIeC+pQLW8V0Ft5aRfUkHuyDeK5qU=;
 b=AecVkPKgJQEDRkficIZftBC5J/H7R3ii5I79WX+T8pxoCesL4ImFrai4VjmH0JohSHCiyitrKW/sWSdbfZuRQMBfjFrZnMhSgh2qc7JrUAzNcQBdZh3GuF5l85vRcxcti+83GfSTruNbe5ZxT2jkGnd59IwgHaBuyKkfh0QvkBgUTtWxvQhJXxQbZFiXt9dQvIBPX7jIyeaTOrCBmHQwjaJlmwP7Fmp2sj079yw5qA/0/iic53P1FMd2N4Pz51WcY7H6XjnltyBDOabS3mMGqYTHcVZtUo++AiXQB6C3ykM/6QXyyqTX2fIkGiX9uLCD6TbTGEa2o8v1VpLBPFyfHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4886.namprd11.prod.outlook.com (2603:10b6:510:33::22)
 by SJ1PR11MB6153.namprd11.prod.outlook.com (2603:10b6:a03:488::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.19; Thu, 18 May
 2023 23:26:27 +0000
Received: from PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::bc17:d050:e04d:f740]) by PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::bc17:d050:e04d:f740%4]) with mapi id 15.20.6411.019; Thu, 18 May 2023
 23:26:27 +0000
Message-ID: <dba3d773-0834-10fe-01a1-511b4dd263e5@intel.com>
Date: Thu, 18 May 2023 16:26:24 -0700
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
Content-Language: en-US
From: "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
In-Reply-To: <20230518130452-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0019.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::32) To PH0PR11MB4886.namprd11.prod.outlook.com
 (2603:10b6:510:33::22)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4886:EE_|SJ1PR11MB6153:EE_
X-MS-Office365-Filtering-Correlation-Id: fc9d2c9e-ca85-42b4-eaa3-08db57f74d9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aYQUbBCpyLa8dF8DIRmkH6ihIOOfKmbN251LcweBw07ioQNG5EVRRnyROC0UFaCumJkL7evdnz3vPkEslCNtFJjKI9DkUJqOR400gFwRrjStd2+QQq5NsaL6cOyM4Nh/8MNMpmxV6aM8nV2JzLacgqYFm2C5gL6yZ69O7UFm+5ondlNCY4PCP6pEvz4ZoZeOhJWH/475IwRb8Aq7EqdRhu67v+OtJJ9pMmhEzFnOnOerRuKlkiEMsquYMvrMLhtocS4nE/5jJycs9ouFUbkmHzc3i18ztEQFktk7FvSWNIKm86RT9r2AR6pAn/iS0QGcFcYKylTwq7V50gmLFDhSAFnN981UrR/WYh6v+HT8lMdKOUQzFzh5rC9W/AKcnCSDE+LHj+TFpV9nf280rK5N5G6PU3+zfwsZ/yTmo7YoviA9I8PlM/ZsbKNuBzKHwKbvgQidpMgJz/yjqWTvA90CBEcwOQizyDUtjMWQ9ZbqZn6hxb6NDyJUp8EJiz+ZhZrlIKTobIDvmRupOrV4Z1AoULWXrSxPoHn3HjH+7MQhcgoPQ4yrG3xdOsPWKswdBOti3CBHzg9HWgKCDtHB9jPrGvG6BlkyhPCgaGs1ojdvQWH+RX4PxAiey4WbETQk4bTqA3dJqdkPBi8mi6OvTHc7iUFHeKeWu3odZM1pmGJEgeQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(39860400002)(376002)(396003)(366004)(451199021)(107886003)(6512007)(53546011)(26005)(6506007)(966005)(36756003)(83380400001)(31696002)(38100700002)(2616005)(86362001)(82960400001)(186003)(54906003)(7416002)(478600001)(2906002)(8676002)(8936002)(31686004)(316002)(41300700001)(5660300002)(66476007)(6916009)(4326008)(66946007)(66556008)(6486002)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SnhDV0w1RFhzOGFObkd2S0dmeGNpcmorbmdycmthQVE5ZVZ1L0pUY1ZsOVkr?=
 =?utf-8?B?OW1qeFNnelRjRzZ3cUc3RGhBclFUSytZNkFrbUR4SkdRMFdJclVBdzBockdp?=
 =?utf-8?B?WXhkMmZtTFZVczVDTmxCc1czbUZyY29qRXZCcS9YTHFrUGFzcDJ3clh2ZmFi?=
 =?utf-8?B?VEFMSFBwdG80b29mYTNZUE9SeWRhVk00Sm91YkJaUlVlME9RRC9xc0grRTlt?=
 =?utf-8?B?OGxGYWVWQlFBa1U5Nmd1aHJ5NU8vaUl5Q2pGT2RsOGZEWGZwYVRyaG5iZjYz?=
 =?utf-8?B?NGFaTXBSejA2dTNPMVBPSk1LM29IVjNNN1l2T1lJeVRwbFk3VEFTUmlSOVVI?=
 =?utf-8?B?elhCcXZhWkxTZkJub3lwY2xOVTY2cTZGY1Vrb1dxYVlTRHJkRDJqazlPN3U5?=
 =?utf-8?B?Y2dPUDV4ZEFzQmlUd2xlRzMrYzZHL2cwWXdjaHpzVU1XZmd3UTlSWDVVTytR?=
 =?utf-8?B?RjAyVVl2T2JtbmZOQjZzYllEeVFwVzR5MTluSnJPUnl4MnpMT2Z0ckgveEZm?=
 =?utf-8?B?Z3JvS0ZCWUZpL1lna215emxGQ0x1OEFGcWpydzFkUFRJcXI5ek5xK0FDT05Z?=
 =?utf-8?B?bkROK1gyY1ljZmRIR1dZOGR5VUdZRFJPQUdvTUpyS0xTcENSeUxzbzVYekF5?=
 =?utf-8?B?M3E2Q2hQRVZEVUFWblZsdGlla0IxNlB3UUJsR1drOTg5SFhGWmpMNDZhMGhG?=
 =?utf-8?B?emZIaitGZ1dKYmtQbTlRS1QzMGoyWG1UeWppYkxXcXVyZlRKWll6cXl5cW5E?=
 =?utf-8?B?ZStaNHA1a3JuNVRtcFhRejYwbjJZREZsNmdNS1o1VTFXbkNXTGlCdkVZanUw?=
 =?utf-8?B?RlFzVDk3QWJ0T2x5VEZBMGJ0WnpFQTRxRUdlS2VpWWx0MnJJU2ViSk5XQ1hF?=
 =?utf-8?B?UzBVTmNQQWlqQTl3N1BhSW9lNjR0UnFHejFWVEtDVWRielpRWis0SlpxSWtl?=
 =?utf-8?B?TEtVaHJ5YTdzMks3NTQzMW15TkI2azZUSWplMGV4c0kxcTJLTnRRMUdEL1J5?=
 =?utf-8?B?VWdLNDJjRnU5enBXR0NHQlBUczBtclJtMWhQdmlabkhyeWNuUk5KTStiYjJG?=
 =?utf-8?B?Mm9iVEh3bnVhTUM0cGtlNk1pTnEySmFVcExBeGRJbVZhT3dMa0hYVEl5K3g3?=
 =?utf-8?B?WUJPOEtQZmhrNEliY2ovSTMvV3JSYzFtbm13ZTlmeTB5bnczZHNrWDlZZ2Y0?=
 =?utf-8?B?S3U3TnZBUHBVN3V2QmgxYVplY0J5RHFDSUNyUmdnQStnMnZhb3QyTXIvRFlz?=
 =?utf-8?B?Z2lyZytFdHZ1ZHNFVHFoYUFnYU1zMkxCT0RjQWVHTlNKKzROcUdkOWtyR3Zn?=
 =?utf-8?B?MjllczJ1Y1pRamM5NGwvYzAvcUZLNFZGN2FCNmtaMVM1R1pzbjR5WGkwS1FH?=
 =?utf-8?B?SU4vOGhRK2pyU1hSTkhjYmxmWkgrUlNTSGQxM1o2Z0kreFV2RVhVVXR0V3BS?=
 =?utf-8?B?Y2kzNW16dDcyb0toK1ltSDd1cFU5ZThBN0owQm9qcjB5RDNKaERjQ3Q4Q3lv?=
 =?utf-8?B?ZktWZUo2dWZCb0sxVGUwRmlUdlJrRERBcVc2aUVPV0RwMk9sRzVGMUxTTlF3?=
 =?utf-8?B?S2M4S0QzVjdHeE1XbDcxRXRSSUwxMlp3b0Nyb1VFYlROUXV3ckE5UzY0akZj?=
 =?utf-8?B?NVcrT3V2N3hlVURQOVRHSG5rbXBNSFliU1B6aWRkdkRhQmVXM05CS1lYSVBX?=
 =?utf-8?B?eG5ObDQ4RUVubW8yaG1sT1RkOUgyU2w3RzhtL3pyNEc3QTJvalhwZWN4VCt2?=
 =?utf-8?B?UHpoclBDZk1seVFxRWo4bFltUGF2eG1uQWFnUGdFMmFBNUkvdGNENm1SZFB0?=
 =?utf-8?B?SlJJdEZEcVMzOVhoa2dSZ1R2amY2blRqakNzcTE0Z0xmVW1pVE9FcVRFcXdS?=
 =?utf-8?B?SmFYSVZvdWJqRlY5MDJWNTl0ODlzaHVZZi95VFJRejIwTmxxMVNiOS9ocU12?=
 =?utf-8?B?RUhvUXRsRXEvbjRmYmtxMHN5Ty95bE9hSGo0YWttdHM1cG5zeWlOZWFCZTJq?=
 =?utf-8?B?cTJSdHhISTBRSlRPV0YzT1VqbVpBMGl0bmYwRno0a3dGaVhXOHArYWF5bGpl?=
 =?utf-8?B?UWZFd3pDVEF5K0xnUGQxZEYrMXBrbUxwUEpIOXlENEx1YTk4M1hiQ2kxNnRQ?=
 =?utf-8?B?TmFhWVJEeTF2SEtONThpbUJTdG5PaVd4VmI1OTU5K2w4eGE1V0hnV1V2V2tN?=
 =?utf-8?B?Znc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fc9d2c9e-ca85-42b4-eaa3-08db57f74d9a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2023 23:26:27.5737
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MNzBDJliI7/N2WFSCqopqmCpsBH6o2DupStVUMCSQRHb5kAtdGIDZCsoyh3I2+MIkZG2aE//cRZ2cPw4nMXSbiu7HY3o+1W1kOmRTGyzgvM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6153
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/18/2023 10:10 AM, Michael S. Tsirkin wrote:
> On Thu, May 18, 2023 at 09:19:31AM -0700, Samudrala, Sridhar wrote:
>>
>>
>> On 5/11/2023 11:34 PM, Michael S. Tsirkin wrote:
>>> On Mon, May 08, 2023 at 12:43:11PM -0700, Emil Tantilov wrote:
>>>> This patch series introduces the Intel Infrastructure Data Path Function
>>>> (IDPF) driver. It is used for both physical and virtual functions. Except
>>>> for some of the device operations the rest of the functionality is the
>>>> same for both PF and VF. IDPF uses virtchnl version2 opcodes and
>>>> structures defined in the virtchnl2 header file which helps the driver
>>>> to learn the capabilities and register offsets from the device
>>>> Control Plane (CP) instead of assuming the default values.
>>>
>>> So, is this for merge in the next cycle?  Should this be an RFC rather?
>>> It seems unlikely that the IDPF specification will be finalized by that
>>> time - how are you going to handle any specification changes?
>>
>> Yes. we would like this driver to be merged in the next cycle(6.5).
>> Based on the community feedback on v1 version of the driver, we removed all
>> references to OASIS standard and at this time this is an intel vendor
>> driver.
>>
>> Links to v1 and v2 discussion threads
>> https://lore.kernel.org/netdev/20230329140404.1647925-1-pavan.kumar.linga@intel.com/
>> https://lore.kernel.org/netdev/20230411011354.2619359-1-pavan.kumar.linga@intel.com/
>>
>> The v1->v2 change log reflects this update.
>> v1 --> v2: link [1]
>>   * removed the OASIS reference in the commit message to make it clear
>>     that this is an Intel vendor specific driver
> 
> Yes this makes sense.
> 
> 
>> Any IDPF specification updates would be handled as part of the changes that
>> would be required to make this a common standards driver.
> 
> 
> So my question is, would it make sense to update Kconfig and module name
> to be "ipu" or if you prefer "intel-idpf" to make it clear this is
> currently an Intel vendor specific driver?  And then when you make it a
> common standards driver rename it to idpf?  The point being to help make
> sure users are not confused about whether they got a driver with
> or without IDPF updates. It's not critical I guess but seems like a good
> idea. WDYT?

It would be more disruptive to change the name of the driver. We can 
update the pci device table, module description and possibly driver 
version when we are ready to make this a standard driver.
So we would prefer not changing the driver name.

