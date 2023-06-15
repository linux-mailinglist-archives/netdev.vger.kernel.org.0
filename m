Return-Path: <netdev+bounces-10951-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ADF41730C0A
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 02:12:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4F8A281594
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 00:12:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7759362;
	Thu, 15 Jun 2023 00:12:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08E5360
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 00:12:15 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02BB2212B
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 17:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686787929; x=1718323929;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8Xh61NNEK/aexOt+eRk+Usu/+SUSNdq6cixHwz9pI6g=;
  b=VYaNYjrdekJmxl3Q0OOcmHIGr7R1pzW5OmyPZq99yJ/+8gR7ObKE4LOh
   aZY2B8aVuKRkdWkuD9uThGcUYBD824AOSK/SSgFM7pvvjkqj1c2SpDRGR
   BTBNnPvl5SNNB+sKSdqA3pzUjvRVySjNvwww3I3gGSMMeWkmNJ9OXbDVb
   +a+ZUDU8JOQwKB+rzlGFB3dPf5tmmjiWACmL+XLY5Qi97MCErPbfSpNHz
   7CiLl2Apn0dwYkop5K6hxC+laEHGYZ8nr5nPf4y7Z/YV6hfGSB1ax3BN8
   5pO+At3qWwFQsPh36mSxLVpPO2VPSvMRzRhsxZmeSyhJHxV1rM/lx+xng
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="343467376"
X-IronPort-AV: E=Sophos;i="6.00,243,1681196400"; 
   d="scan'208";a="343467376"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 17:12:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="856706893"
X-IronPort-AV: E=Sophos;i="6.00,243,1681196400"; 
   d="scan'208";a="856706893"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 14 Jun 2023 17:12:08 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 17:12:08 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 17:12:07 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 14 Jun 2023 17:12:07 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 14 Jun 2023 17:12:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SbEBufXEIdwNKHPLpHy2hHXcejjqgnKfEo8SMaCP0tqI12MVJXNmCEt22a/yB7HJjuo2aLv1s76rk72pYmKB8ytCGmT/NHZz4Mvf3nsJKTAQOWdhJM5qybQD7Sq8Rg/5BqFnA6eaQNCmMmm/V5l+NKQc9yrs3SjWh02dHC9XVCnor9yUbltYjacwn2kg7ktqhcP80qNWB9bD83Yp7u/kuSJD86DAAy/Aa6mDcHpZIJ/VVLvK8npYRQlMU2OXd9U9fXQLRwmyZNDMmfNfkH8FtzTTFfmpBHWYr5BSqL+/5AaHFA2clVjnatpuZ1b3DBlRqw/ZZ656Zq7rpMNUKTrBcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NrdQ9AQKHjHOUtoiE5Ctnwj15BMjZOIyQ76rKi0wRkI=;
 b=gRu+Peu9IojIR6Ue2eMe0zQVHoG+mqXLUcMCEMV+WWZdqoFa643PiMwfa2JaWvUITfDWZXpkRkhkiR0ob4S23FVDz1BWrodUE3zFmj9GzSRfLHQnFSEAiw45nDrVLvLCabSZRV3hK0YDnQ3ww17nHFEtOE1GNGsC63F0RPa1FwoLmwKClMCBOdsEV4+rZ0sPo+LWTXYzh5uGHL4jlj6MNg0w9hXAYZWbcnhqWa76dVX6JMVgox7X2Z8jHihS0Onsek34zYfPwCi8NTjQOvmP3kSw2BD4r52C3NXaNwkKyT74t/ij6wpq6NmaIC8fgACpey2xF43zxB0vPTiyQg47fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB2599.namprd11.prod.outlook.com (2603:10b6:a02:c6::20)
 by DM4PR11MB6215.namprd11.prod.outlook.com (2603:10b6:8:a9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Thu, 15 Jun
 2023 00:12:05 +0000
Received: from BYAPR11MB2599.namprd11.prod.outlook.com
 ([fe80::ab9d:1251:6349:37ce]) by BYAPR11MB2599.namprd11.prod.outlook.com
 ([fe80::ab9d:1251:6349:37ce%4]) with mapi id 15.20.6455.030; Thu, 15 Jun 2023
 00:12:05 +0000
Message-ID: <6bdee083-ded5-dac4-5ffd-6bd6896e9f98@intel.com>
Date: Wed, 14 Jun 2023 17:12:02 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.11.2
Subject: Re: [PATCH net-next v2 05/15] idpf: add create vport and netdev
 configuration
To: Stephen Hemminger <stephen@networkplumber.org>, Tony Nguyen
	<anthony.l.nguyen@intel.com>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <netdev@vger.kernel.org>, <emil.s.tantilov@intel.com>,
	<jesse.brandeburg@intel.com>, <sridhar.samudrala@intel.com>,
	<shiraz.saleem@intel.com>, <sindhu.devale@intel.com>, <willemb@google.com>,
	<decot@google.com>, <andrew@lunn.ch>, <leon@kernel.org>, <mst@redhat.com>,
	<simon.horman@corigine.com>, <shannon.nelson@amd.com>, Alan Brady
	<alan.brady@intel.com>, Joshua Hay <joshua.a.hay@intel.com>, Madhu Chittim
	<madhu.chittim@intel.com>, Phani Burra <phani.r.burra@intel.com>, "Shailendra
 Bhatnagar" <shailendra.bhatnagar@intel.com>
References: <20230614171428.1504179-1-anthony.l.nguyen@intel.com>
 <20230614171428.1504179-6-anthony.l.nguyen@intel.com>
 <20230614112144.55d2fdf9@hermes.local>
Content-Language: en-US
From: "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>
In-Reply-To: <20230614112144.55d2fdf9@hermes.local>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR20CA0031.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::44) To BYAPR11MB2599.namprd11.prod.outlook.com
 (2603:10b6:a02:c6::20)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB2599:EE_|DM4PR11MB6215:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e320c5b-08ba-4856-cb74-08db6d35265c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ByBW14DKEzoHDFRvA7ZiJbUN+XBZlYAtHFynYOGLX/5nPsLj5hybOyKdwF/mQROTrYtEfmu0VmR73OAgj2NJrez4hhG1PrS9z7qW1n2NAvgFselN6CD+AhKePECkIngtzXl89wsKaLVnckLCqSah3HZjmqEMsMZMnsn8Kgt7IfDQePFnpWJIfOP1nOqA1mpVS/NQyeyIV/ZRTFeeuAbb4On8yXtoLRtGd03BYsC5Jc/HzXtyL9cLGrZ5SAM1phf9+MZ6tdYMeIzcG9jBrc9Cijv3KNk6uDq8wYb8Xzyan84ToU7GcmQbtGvZBD2hvTmoT99gOopgh0TBF+yn1D8xH+2ySDOdToXvnagw0MC8rIZ79HbD12B+nMWLn25W7t/YaZ5etu5kJtKTFSWSfxeCbj7pZTk0GdZC2NrUwtXL6/ehvzG77Q773b1cPSaX+MTl/v5Mn0O/wLVQQAyYYpXNedOciKMerAL9zHeHX8u9S07qUAhtR7i2JOXPHt54zG8vGlkAesAeQe2ysmJeQCcs8i74e/LkCEqhjvqdTuPnhAY35vfj0JGUD21CsT4EXtu/A+41Wf43vJwPXBnp0JWQVBj5On5ER6UEum1P42CCBfX+qZS51drXSvMahQx3Iy7dSS2vH9LItjttLSWSVJpcdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2599.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(346002)(366004)(376002)(396003)(451199021)(4744005)(8676002)(8936002)(2906002)(5660300002)(66946007)(66556008)(316002)(82960400001)(4326008)(6636002)(31686004)(66476007)(38100700002)(2616005)(54906003)(110136005)(66899021)(41300700001)(36756003)(478600001)(186003)(53546011)(6512007)(26005)(107886003)(7416002)(6666004)(6506007)(6486002)(31696002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Tmw3dnN0ZlNGVnB2YVJZZkYyaGZvYzczSmlCSTdYQlczaGJOVElTSFdLVnJ5?=
 =?utf-8?B?L2VBQU1HaUNVOWNzeWd2KzJNbEdKMVhBelQwSmdpVWtsWnFZYUU5N0Jianox?=
 =?utf-8?B?WEltQzBsTjNGcTE0MGRzYW5rNjArb2tyZ3JLaHoyY1R0cnFra1gybGtwMG5J?=
 =?utf-8?B?L3dxRmpRbjhJeVErUHRYWDlacXVUdGxwWEVBK1JLN2JORm94T0k5M01TSnFS?=
 =?utf-8?B?RUNXcDRPeXZMZ1c4YUg4YS9GMk0yVGpwQ1VLc2Jzc2dOdmFTTktRRFNkWW5x?=
 =?utf-8?B?WFFuZnRhRkN3Q0toZUc4Q2xYY3B1L2pVbVlYVnpPWlN4UmNqODNiR2V2TmpX?=
 =?utf-8?B?VzRCZE1EMjBrZTJXalVaU0NYK2toaTgwWW04TXdHUHdnckd5Q1hJVWkwUlhI?=
 =?utf-8?B?MFVNNmpjZ1ZGUXpLOG5ZOWFiRDBiZzlRY0s4U1o3Q0hYbWZlNDhXSDdTTDBh?=
 =?utf-8?B?VXk5SG8rVk1RU0ZPUHVtMWhxVnhDc1h3bGoyWEJFMnFPUVZCSmFVeVUwLzVR?=
 =?utf-8?B?c3p4Yk1FS2tlbjc3c1d2TlY3R2ZPZ3hCQVVOb2Y0R24rY0hRdXRiekUwbFRK?=
 =?utf-8?B?bm5TSFN6elg3NEMwWThEVW9pRzg5dUVCNlV4OHlnQmlDY25oQ2VPK3Rkd0c3?=
 =?utf-8?B?bjJGaUVTSkhsNEpZM045T1A4RFlhdmUzZXY0ZGpnVXdWL1RPaVpPUHd3a2x3?=
 =?utf-8?B?WVJySG5IS2lsQ09IY3BPamsrMGUwY1NMVVdGNEJ2RGRkSXplWHZ6cU1LTVBZ?=
 =?utf-8?B?WlpKYmYrYmdjTC9NcUoyMHhhYTQ3U3RPL1ZzNEhwNDhta1kwSi9TZVM1UDdJ?=
 =?utf-8?B?Zjlvc2xoNVJSbEZYcWlqczNXcFVzRXkvdDNyd2J4RnRrL09CYkNtOVlRR0Vp?=
 =?utf-8?B?QXVNRE9sUElTNjV4UlNIMHZubHV4cTJQemI3bGp4RnEvMktXYnk0bXBYb2sr?=
 =?utf-8?B?b2lGckM0aFJ1WUZlSTJtRzdTWjVKT2dVb0xBcmdIdWZmQTgzYUQ1SUJ1Smcw?=
 =?utf-8?B?NVo3dU04VTRFVzc0Vm1Ob3dzSGRwWU1hOFArQmxpbVBMc2FkdnJGRmRKcHBX?=
 =?utf-8?B?OGlKclNsbFJacTZhOVBkRDU1YVMzYVd5RW10YzM5MkNOOTF2NUZFTDJXZ0E3?=
 =?utf-8?B?Q0hyYnpGenM1UHdPNHRtL0FpbDI3Nmk0UmNlZUdVWjFwVnpnSFRod3Zrbjg1?=
 =?utf-8?B?WmpJUXZ6cnhjWjRRUjVNS244dWR0djJlVnoxN3hQNm5HeDhzV1BKVUY0SUUy?=
 =?utf-8?B?b05Id0pvMmxvcFhkZGtaR2NESnNvdG9wc1Zxdmh1bk8zaDF1VFoyeVNwaytn?=
 =?utf-8?B?aDJXU01IbnBGV1BjNzR2ejZhR3h4VVR3UmpLa3pndFFFRDZkeEpBL1dpVkxa?=
 =?utf-8?B?NnpXZ216UDZwSmV6Q01ETkgwdE45OXVTL3AxL1NMS0hsWGpMa1Y3aEZudHA4?=
 =?utf-8?B?cW9hQzlUUEFuNTRzN1EweGxqM0M4TU9Sc3ZncXBBdHJpUkptYkJWMVlZaW15?=
 =?utf-8?B?Tk8rSkpaRTJPajlrNHVNV1Q3MDZOTFVuRTlKQjZ4L1BQaFRpVThzVVZ1RzZC?=
 =?utf-8?B?SXYxY081MDVJNFpaM1VOSHduOSt4TEVQQUIycmovWStsVytNRzE0MmZHL3dJ?=
 =?utf-8?B?eHFrdSthb3VrUkxtYlYwOHBUTnhVRnlKcDA3SlpSV2JWTmhyeUlMQVEzMWRO?=
 =?utf-8?B?UzNCa3QyWFJoRzMrT3pQemxjMnBvSU42WmZGRmtUdkYrZ1RIQ3hIcjk4TXhJ?=
 =?utf-8?B?NHF5anBQYTRPOHBhaDEyQitkOFFwM0VSUjNwOU9FT3lTUjhhWXVBZElXMmFh?=
 =?utf-8?B?S2JtNENzUXdYMDlXL09RRko1Uk03V0ZrbGlPdUdGb1ZpbTgwa1FKRUhyY1RK?=
 =?utf-8?B?M2lxNmI0RXlpMloyWFVxem5VQmhvVWtUWmluNGhVZm90a3FrRGFqaTZHTTNY?=
 =?utf-8?B?Rmt0MENnZnRpdUtHbnd4cWNuUzVtM0oxeVZRY0JuemlNMS95N2NjRFllK2p0?=
 =?utf-8?B?RmRmWTNyUzZtTkV4VHBUWkNCL3dueThuZC9wb1VBK05xNTNkZHA1SDhLUDE2?=
 =?utf-8?B?UUlRd0xWallmOWN5ZjdHQVhaRXIvR2J3dVkxbmlIQlhUQ2Z6dGlVNmhESE5w?=
 =?utf-8?B?Mjc0OFdCREZCSlFMY2J4SDlHakVhTFJxWTlZei8yTEluTFI1ejV6K3hEVXA0?=
 =?utf-8?B?eGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e320c5b-08ba-4856-cb74-08db6d35265c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2599.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 00:12:05.0300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dwdIpyqism6NMs71J/MuW7yEZC2JV70YmMvUmfyPOpESuMB4T62RXOOoM6XUux9lfZUsxjDIJn24KWdx5iMKCSEp03+tMIfXBLTt3ROQeCI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6215
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 6/14/2023 11:21 AM, Stephen Hemminger wrote:
> On Wed, 14 Jun 2023 10:14:18 -0700
> Tony Nguyen <anthony.l.nguyen@intel.com> wrote:
> 
>> +	/* TX */
>> +	int num_txq;
>> +	int num_complq;
>> +	/* It makes more sense for descriptor count to be part of only idpf
>> +	 * queue structure. But when user changes the count via ethtool, driver
>> +	 * has to store that value somewhere other than queue structure as the
>> +	 * queues will be freed and allocated again.
>> +	 */
>> +	int txq_desc_count;
>> +	int complq_desc_count;
>> +	int num_txq_grp;
>> +	u32 txq_model;
>> +
>> +	/* RX */
>> +	int num_rxq;
>> +	int num_bufq;
>> +	int rxq_desc_count;
> 
> If value can never be negative, you can avoid future errors by using
> an unsigned type. Ideally to save space use u32 or u16.

Thanks for the feedback. Will convert them to u16 or u32 as required.

Regards,
Pavan

