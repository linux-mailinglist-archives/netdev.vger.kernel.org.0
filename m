Return-Path: <netdev+bounces-7268-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD6C571F6D5
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 01:48:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7327628193C
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 23:48:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6820D48251;
	Thu,  1 Jun 2023 23:48:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A3A10FA
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 23:48:18 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67997136
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 16:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685663294; x=1717199294;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=O92LZH4Xx2kIeGWfmGp7raa+NEDgkp/SIi7aRwjYpjw=;
  b=kNv8oRIPhP0pES7SDq+cmmz4GN7Bufq0VjD1Rx8anEMFaL5EB/CGDVzj
   EDL+Q9xeQUMuH4+UFuNo9sb996fHiQ+Bd5cd0kIjoNoizniqcS4tS7o2Z
   9fpqAHTnwT2AgE4UL7Rg2M7YGIzl0vykzj6WDt84kmy65Xf3CacbbqWrC
   +ExXDpMwkQj/OyVDEhtRXRnUVu3GelKsqb54G3FT0CaZhJ2oPJip0wWdk
   HHaTywDMr54xCZwF8Gm+OHYg94OiARlJz2gdO40fdIcxTNOLnNcpITAO+
   ysFN63eYnLLGFfSl9lz5/1EuRs3M4D2SMgjZTOlvsMLu7DfMh1gsmSBoY
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="336082294"
X-IronPort-AV: E=Sophos;i="6.00,211,1681196400"; 
   d="scan'208";a="336082294"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 16:48:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="954229934"
X-IronPort-AV: E=Sophos;i="6.00,211,1681196400"; 
   d="scan'208";a="954229934"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 01 Jun 2023 16:48:13 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 1 Jun 2023 16:48:13 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 1 Jun 2023 16:48:13 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 1 Jun 2023 16:48:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qt5KePPVKK4zvY6RZ/smolfJUj2fQk0I01Q4x8s4Iruhvxkt251pciWtOz0XDqRz4UnzayEIfFRLc/qhWVc1351PqzoEuspkOfCRoZt9oEZ5ep842+rmDAGHSgjtml/vYMoJTGMQdxdjY9ED79doEU5iRF6vQ9ClfK00d0CB0NgukAOCHkerv4fhVKIj8uQVMhT1GQngtYqvDIs9bSWkLVq5d7HafpckeblQC4fnVeXgPFph4iLfPGFD18q4zIfk6cuQc6Vm7INWHPTHrIPLRkQvkpv8SaOwAhqWFgRFmEfx4oEypcid8IDzfgvO8CVBJF9FyIIpX3qqilmuQ9fNjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ah28uhPB0bK+Kr77U3vTNt7lJO41sFzYobXBSCUCK/8=;
 b=HSt7MytWC56DiJVEq7ClFuA1+epMBtN/dvWiNkUPFjbYDUvY892SRena0pNRY/e0+10Ah0Vw6kXyc3MzpxgOq/5nSDfCkZE+IndFvqDOW+4D/+6GHLWRx931ep9ioQaf3yP8UHZFoDOiAE50Owoa4ETryciNiiBJT4y1BBuufg22RXQCE5xHT8kI+zRhMx2pzvO9nSqj9xDBd9f+1pez5Q2smJHutU0l8KivqnHI+5EQ0ZulE2Sd7p4GuffoURoAIu8szySSSonkXKTCrPQh2MOA+9oJIWxYk3X8bzV3Bp6T3+yLteNCmkDNqY+k33jZLMR5bm+zCs16RyST2NZI1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB2599.namprd11.prod.outlook.com (2603:10b6:a02:c6::20)
 by PH0PR11MB4918.namprd11.prod.outlook.com (2603:10b6:510:31::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Thu, 1 Jun
 2023 23:48:01 +0000
Received: from BYAPR11MB2599.namprd11.prod.outlook.com
 ([fe80::cab7:84ac:bee4:f96]) by BYAPR11MB2599.namprd11.prod.outlook.com
 ([fe80::cab7:84ac:bee4:f96%6]) with mapi id 15.20.6455.020; Thu, 1 Jun 2023
 23:48:01 +0000
Message-ID: <3fe3bf2a-6cb2-c3a1-3fa3-ed9a5425e603@intel.com>
Date: Thu, 1 Jun 2023 16:47:58 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.1
Subject: Re: [PATCH net-next 05/15] idpf: add create vport and netdev
 configuration
To: Jakub Kicinski <kuba@kernel.org>, Tony Nguyen <anthony.l.nguyen@intel.com>
CC: <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
	<netdev@vger.kernel.org>, <emil.s.tantilov@intel.com>,
	<jesse.brandeburg@intel.com>, <sridhar.samudrala@intel.com>,
	<shiraz.saleem@intel.com>, <sindhu.devale@intel.com>, <willemb@google.com>,
	<decot@google.com>, <andrew@lunn.ch>, <leon@kernel.org>, <mst@redhat.com>,
	<simon.horman@corigine.com>, <shannon.nelson@amd.com>,
	<stephen@networkplumber.org>, Alan Brady <alan.brady@intel.com>, Joshua Hay
	<joshua.a.hay@intel.com>, Madhu Chittim <madhu.chittim@intel.com>, "Phani
 Burra" <phani.r.burra@intel.com>, Shailendra Bhatnagar
	<shailendra.bhatnagar@intel.com>, Krishneil Singh
	<krishneil.k.singh@intel.com>
References: <20230530234501.2680230-1-anthony.l.nguyen@intel.com>
 <20230530234501.2680230-6-anthony.l.nguyen@intel.com>
 <20230531232239.5db93c09@kernel.org>
Content-Language: en-US
From: "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>
In-Reply-To: <20230531232239.5db93c09@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR04CA0024.namprd04.prod.outlook.com
 (2603:10b6:a03:40::37) To BYAPR11MB2599.namprd11.prod.outlook.com
 (2603:10b6:a02:c6::20)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB2599:EE_|PH0PR11MB4918:EE_
X-MS-Office365-Filtering-Correlation-Id: dd9665c4-2821-497a-875b-08db62faa2ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aqhrEoMi1RuwTTIDcqFOucExqhVso5dX6DkEKnQcIE4DAoK9/ibcDhCoAjNw4Pa7wTv9heoVAaIB3ZEsBp145XhknVHF0L8vVVsWosEwo5JAjhCxe1eRj+j611cTIM2QSoOPKHOJ5ygASYSvEEvzq2w5n2dqlKMki/j553X0D9/1KQp6S4GiU79QsH5Dhop0+fSLA8lK9I8c6U3bTZij40SqsKB8zMe6lTqF3g2hIFtkY6HJJuu588WTKrRdltQiJCYMHSKay3lbLFGjsh6mf7WrZw7mUH5uFSyXtUHfiWDUh6psbNk4pnwHwjdV2xJTOwCi1JeJJrC9RhlD2PWho2R6dyWuvzRpiDOGr/cR76LhSSEBGlqcrFQ372h98mm/lgQZfRAZwlkLZGNf01secbwOljlmzBpwRZiEFZUn07y/TmjozyJAseKMTa/rja7TPSGj84WbXvBi9zOOchWIMomD9BogCD7GWsxPqOOY/6ETnfb45qJaZleRB9FASaUd9DcwuzkN2d98LzLk9SCOZ/O+WhC9cwkijoURHmpojhnz7ykJZkXHbUBy2atUzuNaE2CBxdqHudlW7QpbnPlfqcZcZKNZoqksSWs8f0JVjh+A9avUbdsAKQgdwRhgZH8oVIf9tfMNaXMkjcC4/HRPdw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2599.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(376002)(136003)(366004)(39860400002)(451199021)(4326008)(6636002)(66556008)(66946007)(66476007)(8676002)(31686004)(7416002)(316002)(41300700001)(110136005)(54906003)(8936002)(2906002)(4744005)(5660300002)(6486002)(6666004)(478600001)(107886003)(53546011)(6506007)(26005)(36756003)(83380400001)(186003)(82960400001)(2616005)(86362001)(31696002)(38100700002)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a2dPSGw1bjcyM3RUbUFaTjUrOEtudklSNHRBWk9IQ3JPa21PS3dUTFBGMDQx?=
 =?utf-8?B?d3VIcVB4M1hycUhsa01TMzVXbjBsNWZVdStSWXpVREFqdjVMdkc1aVJ5eDlU?=
 =?utf-8?B?ZWh3MldVNmozc0dJNUh5Y1VSK2xjamRzMkM0Z1NLZkwyV2tRUzM2a1drR0Jw?=
 =?utf-8?B?NUo3dFZOaEE4YUlVZjg5YXEwRlh0Ti9WSmxPWStsbXB0NG9GWVpHcllmdkJi?=
 =?utf-8?B?UGlYT1NnamFpTHcxZ0ZJU3JXMnZ4K25IOHBTbG5nQ0R3NVBhNG5KN28xNnRR?=
 =?utf-8?B?bkx6NDBMKzZ0b3hBWHhMOG5hUVV4ZWNjSkl6TXNldi95MGxPSGpvTHdmOGwv?=
 =?utf-8?B?amI2aW1ZMTdvOC9uUzArNkI5enBTenlLZFI4aWZ1YnlOV3pDcERkOVFUbTRT?=
 =?utf-8?B?dDhMNUVrczl0Vm5IaldONnR2bkRyT3hOOWthaHhSZnQzRlVJOXIxTCtybnA3?=
 =?utf-8?B?VkxmQlZTQzVXdkRNczNBTVRmdW5wN0h6UW94NmhZK2NUUmFYWTFPeDlYYUs1?=
 =?utf-8?B?cFc1WUdDbmhjVkp2eCtIbjFObzJjN0JBaWwrNUpXd1VrbEZuZVRwcWNmUkQr?=
 =?utf-8?B?SkRtNHlDTDEzMWE3TEpVQWtZVFBpWHNtN2lHcS82Zi9KVUtoQ0xIRjZTd3Zq?=
 =?utf-8?B?RWl2QXkwa0xMekphamd1aWJmS29uMkZ4WjBFZGxzQnBVYjMzSk9TemdKc293?=
 =?utf-8?B?Wkx4ZlFKNEd6dGR5SXpXWVdEdUFUNlhJVmJwYXFnWUpIY1RnU2o5QUh3cThh?=
 =?utf-8?B?bWdSUzkwcXRYMldRazU5VHRQNzRQR0lDQXZlVXJkMVVOMEd4ZWRyMGtlWGlq?=
 =?utf-8?B?c0lWUTF4T2dqK01XZ2dtODV6KzVkbFhHNnBlbVNoMjVPTGhLWkhQSnRpTDNT?=
 =?utf-8?B?T2wways3eERXNndtbmh2NFVaQVVXN2Q4dmpMaE0yZWVaYTZKNkZjTDczRGZR?=
 =?utf-8?B?QWFSemlXQU9qSnNROVVmbEtUMTFQRGU2RkF3aFp4Y01ER1dIU0NxM01FUTli?=
 =?utf-8?B?WFAzYzVXU0I2TmZUamZoN29rNTRDbUxoL0cyb3p6ZUFBaW5BL3lHdmdxUWxr?=
 =?utf-8?B?YmE2VE02N0RPaGZzRWoyeGYvc0hGZW5lRG80WGtSTDArcTZETG9PcmVnVWF0?=
 =?utf-8?B?M09POFkyZ3B0ZEJjT2hCRVpkQm1wL3VTWnlBaUc3aWR3cElxdnU4ZXk0YUh3?=
 =?utf-8?B?WVMvK3R6RFJhTlNjQ1hqalBwZllwS1F4K0wyU0RmVDdtd01SZnJjUHhPSGtq?=
 =?utf-8?B?ek1xWCtScGUzUGpsNzFhbGhPaGZrbjcrYThXaWFnb2RGR1VlK2dUaURPMGxD?=
 =?utf-8?B?T0VKMXBFSG9yZWEwNHRvN0hoL1BrK0ZXMTJQeS9SOE9JNEVuTU1uZWQzUlZn?=
 =?utf-8?B?TXVtaXVybmZQMlRJajNvOTU2STREU1UybHZXcjZGdjdLcjE4clFYcWx4UWNr?=
 =?utf-8?B?VnltTXdaaW9FY1E0Sm42eVp4TjRUNmxpWTQ0RHp5UjBkNXo4ZjhobGJmbE53?=
 =?utf-8?B?UTkzSmdLSzVVeFNoYW95T1RjMzdMNU1VbFZWT0k4ajBXTzZ5WU1NWFhCYldw?=
 =?utf-8?B?dXlxcXhJSWpCMUhpRXpLOHBFYW9OVnJXTEoxYjdwVjJTaHBhWlJ0dGtGbm1h?=
 =?utf-8?B?aEkvdlM0cHlTOWJhWTd4M0VXZ21xNTBDZFluRm8yc1Z6eG92SnZsZ2orLzJD?=
 =?utf-8?B?ZDhnMDVFTWlTUnBBRTY5WkdKQlpiUitSQkJhY0F0WUJRdDVZVDJBVFo0eVJK?=
 =?utf-8?B?Qk9jM3FXT0NFNnhQaTUzcVR2VU8wcWFpUERLV3BwQ3VjcldtN2ljL1VOSkxz?=
 =?utf-8?B?bFJ2Y2I5dXhDSHM5dmRzOFdwQ29WTE9LSjlLVTNvOVBJSWZWRXM0aEdqMENR?=
 =?utf-8?B?dUxVdHNxbGJiSlpuNExqQTJhSklGL0cxTldzbUpCZ2hpZ0k5SStnK0NOZHlh?=
 =?utf-8?B?TFZhNmxFSDFFamx6dURKblhBVThMOHp4bktoTVFmcHNVWFNtTlpOZFg1Q0dC?=
 =?utf-8?B?V01VZ3RTRGxVSHgvUi9GVTZBaFQyVFlBMHhRd3dENzJWdmNsb21FYWRrOCtJ?=
 =?utf-8?B?WDZ2UHV2aHMrSTM2YUVIWXplU1dVQzNVekxBZ3VnM0p3TzJSRUxtdjJ5VzZ1?=
 =?utf-8?B?WlR0NE5NYnVLNkljQ0t6bDhMOG9YSnNmRUVmWnJ6R1JRc1Z0Q2dtZ2QrNzZn?=
 =?utf-8?B?WXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dd9665c4-2821-497a-875b-08db62faa2ae
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2599.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2023 23:48:01.6045
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rG9aEUl1pxWsPPoDdwkuDYtxU7Z3HhCpgbCeHMyBabr0/CPUbky356XSimGX6+P8Z640qV5N/kJkgESGH947gRJGqya3UZLcXSSYcraI028=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4918
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/31/2023 11:22 PM, Jakub Kicinski wrote:
> On Tue, 30 May 2023 16:44:51 -0700 Tony Nguyen wrote:
>> @@ -137,8 +210,12 @@ static int idpf_set_msg_pending_bit(struct idpf_adapter *adapter,
>>   	 * previous message.
>>   	 */
>>   	while (retries) {
>> -		if (!test_and_set_bit(IDPF_VC_MSG_PENDING, adapter->flags))
>> +		if ((vport && !test_and_set_bit(IDPF_VPORT_VC_MSG_PENDING,
>> +						vport->flags)) ||
>> +		    (!vport && !test_and_set_bit(IDPF_VC_MSG_PENDING,
>> +						 adapter->flags)))
>>   			break;
>> +
>>   		msleep(20);
>>   		retries--;
>>   	}
> 
> Please use locks. Every single Intel driver comes with gazillion flags
> and endless bugs when the flags go out of sync.

Thanks for the feedback. Will use mutex lock instead of 'VC_MSG_PENDING' 
flag.

Regards,
Pavan

