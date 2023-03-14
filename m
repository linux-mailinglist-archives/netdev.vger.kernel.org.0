Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 700E76BA16D
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 22:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbjCNV0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 17:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjCNV0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 17:26:18 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8814F4FF26
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 14:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678829177; x=1710365177;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=foX25xpVp5SnuKNb0uV+gcCJ+I3CEFXUyFKbGv/GOrU=;
  b=bFVf3OGmbBW7Up7TBBEAt/NNFhd1N16WiWBxtj8LUb1xGcDc70grbnax
   9cEo0cLm/fNW13oixHHkfpCNFcDXjw2/A4e9qJTWkLlRPreFVB6PviGbX
   jPA4BhmMkrwhl9VDa9ry3ByXZqfg8a5FwxXS+w0yt7rpehgxvEuBJ5Gfs
   liaFy9j9xjISqY56eEi7enliIwQLndZgsW+eHYDOQjfiusmsyTfjKkllI
   hP5nn7pjWklzcsqOcCyJXuFUOGoLDoOrZzEQ7bkHIEGo7NyBcfd2zGHYL
   jQU+9DhBWavoQtG5/qlRiZCEbMeTGk1sDsUxi+0wMerYLndCEw6nDpKRc
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="336236680"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="336236680"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 14:26:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="748159716"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="748159716"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 14 Mar 2023 14:26:16 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 14:26:16 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 14 Mar 2023 14:26:16 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 14 Mar 2023 14:26:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W0WpFXvZZcdgh0PaZ8bnF2fhCjWX3YVg/BVQxBMfNXHUfk1it4mxKabSGYrZ98q4rLWsYsqlFBJ10/ExFYQW01Qgb3p6p+zudT6b2YL3ccx8cCu0dDYBhYTgaL9vmPisgKlnfz/kVBtUR8U9/IZKImPXGHpZ/4OK3GrYY5/REx1zgvKQDsB10L2YjZso9h3+lkl+8Z8WKVZOy2ffGiB7LVjX53SPxUedGluyQJGNCSkQCaD135Bko9/81czN5fV/WtwF6ul6V3WPglxWNzqmxUwAr28H51FkIhEhSHtSoNlXKjfnqAyzvdGylT7cu6HqcsslYfdgGEkNTHMC5A5C1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N50smaukmk2G4LK2T7G1jX0ZAKM+7iJMKXn+j7D5wl4=;
 b=Xnr1o+0u+kdC/I3aACMzcqvlyu5ARnbdWXsySSPS46OF0SVZUOu2ZvZAMmFNwGQCyNkfS7Xt58Hqxd0vXOMNFnJ8FigxiPmQOFZyJ5jICd504UyrTP+NbyxFrEv0auPSmxBFgqDSoar+yYgFWVtTktyH5/DWG3T5/ToaFL/uXu9Rk2CVqe9ruyo4/wQjvsLP+5ELiuejJvWJMLVprZfMJR1OmicrKTn0bQjxfyxTW8+yMw5j1g5RGu4eeGIdqZDA9lyInn3n42hoYPRXsguKVgDGCI7zLf+FcFOuRUiVk1zOkFA3Kj+qjqBigd0z+IyEIr78FigfuUXKfgCCdlFbiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DM4PR11MB6526.namprd11.prod.outlook.com (2603:10b6:8:8d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Tue, 14 Mar
 2023 21:26:12 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::a54:899:975c:5b65]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::a54:899:975c:5b65%9]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 21:26:12 +0000
Message-ID: <c58fe076-3425-394f-b7da-c6df6ac45d98@intel.com>
Date:   Tue, 14 Mar 2023 14:26:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next 00/14][pull request] ice: refactor mailbox
 overflow detection
To:     Leon Romanovsky <leon@kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <netdev@vger.kernel.org>
References: <20230313182123.483057-1-anthony.l.nguyen@intel.com>
 <20230314135758.GK36557@unreal>
Content-Language: en-US
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230314135758.GK36557@unreal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0051.namprd07.prod.outlook.com
 (2603:10b6:a03:60::28) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DM4PR11MB6526:EE_
X-MS-Office365-Filtering-Correlation-Id: 0daa5407-af3e-40e0-579b-08db24d2bc3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L7sJocB25I/FH4Ejr+c97CxFbJqbxDtrMat0S6bNls61xPKzE561ArkWXC2OvFDXV39LZY2g5q7gMrXvB0xd2zNaoNsIBVbLQAnuvOOyyuXzUjfr/V7Q0lE7FcO8kHskHurNnH9+1WwNvJa5xHgRyZpcxlwuG+H1/MtSuLCmdn3vsO63L+fB/759vh2cATzdZ1rRQYaGJMSeKP3ZaHX8Q8NjsM7cWmiqIsZL34H0EPKJywekS2MAueq56NsRK9I+9T7ZZVrFN4k66onqtP1e5SpqZS1J/81yHaLsntbho+58LHgfhueGxabMglXiaB84NIpDmE+7leSHmjW5BjexJqD6E4Gd1GhIhbMU8B+hZN+JCrk7nrWJdYd3fIPlpl+Kp/nD7Y0LPDezs7vVpm722oQeAfmYxehj1PYQ634kUPCjDxe0Aa7/x2fdjnkQTvOZhtsxoF6jYW15CsHmUEzoj3U2riySU9IYDyCbA7KbkGE4iBX/24/g24c21IFdUKTVLJE4BKHMo7xOWmofigppI+4D3Ua7HcH3cxHGQbWC7afKdToR6g3MEVuIRvyEZWRe9fpTb19GngJ5Qt+4cxVVevmrKQTyIBCQS5r4Vleu1pDq+oR97IPsf1b8yg0nZswoC0Fz5ZoGMy/kU5Gl7bRAslxaazLg2NovDEgke1ARH28bFrrxiutVdDlkU6RaqObQjOfjQMVK5xXLwif4x7tsY0rge5xZ0+p63s5knVheI4o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(136003)(346002)(366004)(376002)(396003)(451199018)(5660300002)(186003)(38100700002)(36756003)(478600001)(31696002)(15650500001)(8936002)(31686004)(26005)(41300700001)(2616005)(6512007)(53546011)(6506007)(86362001)(66556008)(82960400001)(8676002)(66476007)(4326008)(66946007)(83380400001)(2906002)(6486002)(6636002)(110136005)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZTlmSm9hNzZpRTJOVEtwU09JSWViMTE4bnpOT1FEWHdGWE9LempNVVNmRk5h?=
 =?utf-8?B?SnJDd3QvSDRMbXc0a1FIbDdPN3llMWI0eWhoWTMwWVk0UU44NkpsbjJVeGQ0?=
 =?utf-8?B?YzdZYXRXMjV0S0VqVnBaR3ptOWNRNmpRU2I0TGthS3VEcmg0Q1JldVU2enVD?=
 =?utf-8?B?dmJTVVptaGZjQjE2L2cvUVE3MlhQWGNvQW1oL21relArN1lwakl5bVFLemVx?=
 =?utf-8?B?Zkl1NWV3TGtrQmZFRHJPZi9Kbk1lYW54YnJxRUh0eTIreDB3Q3J3dSs5eTlh?=
 =?utf-8?B?MkY0Qy9OMjBCLzI2R3Y3RjBka21iUTZNdzBvdE1JaDNqVGF5ZTB2U0pIMTNG?=
 =?utf-8?B?UkJtUk4wNGJOZURlSjV2UVJqeVBZNi9NWVlibkRPRkJ1eDNWTWxsUEVFSlhU?=
 =?utf-8?B?c3YxS0lLdGJGSnFkUXpGVktRRlJNQzhRQUxxKzZtZGc5VFNrVzhoOGRTU29r?=
 =?utf-8?B?Z05CaFVxY2hiWWpGYWJ0LzBUK0cyOFVwQzZDdkVLRHplenFxMDRPZ2xnK1hu?=
 =?utf-8?B?U1M3VXZKc0I1ZzlOY0NlMURSNUtPMURpVjFuVFFDWUpTSUZLb2JsUktPYlMx?=
 =?utf-8?B?MEJJVllyUHlzMGs0WWV4Ukc4RVRoeXo5Ulk4Sy9Hb05DOVFkY2FlYjM2RWlJ?=
 =?utf-8?B?S2ZMZnZ5blAxMERzKzFjQWNSeHh3SXRCc3U5RHhtYTFYT2p4ejVmcTl0WFlJ?=
 =?utf-8?B?QWoxVVg3NjF0MzlzVWFFNkd1bC9LVE5LNlB4aDhySTlyRHRCQ1ZTc0JnVm9O?=
 =?utf-8?B?SHQ4d042QmRzRnJnQ1J5YVZpUk9ITjFtTkdTT1lxbDhqYkNjNENuSXBmMlZv?=
 =?utf-8?B?alJsM3NzalZLS2xBTC9haW4vZklNZSt5V3BrUTltV1dOejA0UkY0ekJEUk04?=
 =?utf-8?B?TXQvaEhkRVNSckRSblBHa3RzTCsxdlVJN3JSaWdkTytrVmZ1Q1dPd09uMjRl?=
 =?utf-8?B?ZTYvRzRSQjk1NzNjYWw3RWJRM2VzSXBzeTRPM2w2Q2FWVWt0L3RTYUNjZnVV?=
 =?utf-8?B?bktqQ2xHaGNyY2NoeVhGa2hBdHExSktBMHZZUU9aNy9EY0F1eWp0aThqalRB?=
 =?utf-8?B?NldjUnZMSEwxVHNRSitsTFlIbXBweDFUR0VGQmUyZCtYekdwZm1QUXJPZkFP?=
 =?utf-8?B?d3hMT1VxbFNLRnlsWmY3Y3ZDY05seXEwM0ZlUTB1eW1mdWZVdzMyazlaYVRs?=
 =?utf-8?B?RC9IZFczZG8xRVB2MlhkTkFybFNwdGpWZ1JUL0w5YVFGOTZBb2YwM0VFZ3JG?=
 =?utf-8?B?elMyQkRVNHJFQTh0QnkrdWV3RSswTmVhZlJ4YXU0eWIvdjRMK21oT05KM25Q?=
 =?utf-8?B?RkNMaXdUV2NydFdWMFRYa2ZFcmszWGhEaVdNNm1VRkhGdzY2eUFQTmlhMUNn?=
 =?utf-8?B?SS9tVHJPVnJTQ3E3c1Nid0thOHcxanAvWUdGZXR5bkQ2dFlBYTFidWltZ1k1?=
 =?utf-8?B?NzVNQmJ6MzQrbmxWTG1pSVBDY0krc3lLUHJ2SVZGMnJVWDk1UEFheEJneDJm?=
 =?utf-8?B?T0RNTml6SmViU2JDVUZyd0dwVW1iKzFPUXozek9ncFNnVG54cGZxNDZlamtv?=
 =?utf-8?B?VmdIU0w4UHpzczhYbnRzdW9zRjdjazhwMHJyNjBzVHVnWlppelNNYmY4NGpl?=
 =?utf-8?B?QVpJS213SUk1SThSRVVzOVJVeER5NDdCakQ1VVVlVnVLOHBYOHRXK2VRK3p2?=
 =?utf-8?B?WnZiRjQzaWUrSmVtdHVNS08ycWhoSy90QVRhTHFrVGFOMVo1V3JkRytEZDNm?=
 =?utf-8?B?dC9DWldpMkcrUnZpNUFRR3JTbDU0aDcvd1A0azBRSjd3dGUrOGpRK0pkb1VN?=
 =?utf-8?B?dXVsR1VCanZmOUhpTWdybTJ6cDFMWElRVEErL3ZzcjhIb0FrdDg5VE9weklH?=
 =?utf-8?B?bllEVmdZNnJMdVArcVdJRzhYVFp2N3c4czB0R2J5SDJRRFczVFRiYUZaUEMx?=
 =?utf-8?B?QUJDWGhvUGI5NmZkUmpYVmhzR0IwamN5bEtZR09kRjhFTWV6T0hwSEFPL1Ry?=
 =?utf-8?B?bG0zakJmdEZKVkZMbko2ckJJRHFBdzY2aVl6SFYrUEtvaXFLbEJiZkZ1QXdz?=
 =?utf-8?B?MUkvMm1HcHdpTXo2TEF6YXAyakYyYnVtZWpaVE5CR3RoOTB2YXlmelpleTFr?=
 =?utf-8?B?VndaWlROV0phZ1ZXK1J3d0RVNEJQZ0JGWWJKR01aMEpSWk5ySGJvS1ZCamw1?=
 =?utf-8?B?UVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0daa5407-af3e-40e0-579b-08db24d2bc3b
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 21:26:12.4682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZWHYyUUKthiORV0oOlUGxpamV9gOG2Q+iScQlnKLqDQn4OhuUuM4v3zSpSiaVGtuAp1cFXJlXGFtV/tuzch+evbuUBqgBpUonwSsCjYP6nE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6526
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/14/2023 6:57 AM, Leon Romanovsky wrote:
> On Mon, Mar 13, 2023 at 11:21:09AM -0700, Tony Nguyen wrote:
>> Jake Keller says:
>>
>> The primary motivation of this series is to cleanup and refactor the mailbox
>> overflow detection logic such that it will work with Scalable IOV. In
>> addition a few other minor cleanups are done while I was working on the
>> code in the area.
>>
>> First, the mailbox overflow functions in ice_vf_mbx.c are refactored to
>> store the data per-VF as an embedded structure in struct ice_vf, rather than
>> stored separately as a fixed-size array which only works with Single Root
>> IOV. This reduces the overall memory footprint when only a handful of VFs
>> are used.
>>
>> The overflow detection functions are also cleaned up to reduce the need for
>> multiple separate calls to determine when to report a VF as potentially
>> malicious.
>>
>> Finally, the ice_is_malicious_vf function is cleaned up and moved into
>> ice_virtchnl.c since it is not Single Root IOV specific, and thus does not
>> belong in ice_sriov.c
>>
>> I could probably have done this in fewer patches, but I split pieces out to
>> hopefully aid in reviewing the overall sequence of changes. This does cause
>> some additional thrash as it results in intermediate versions of the
>> refactor, but I think its worth it for making each step easier to
>> understand.
>>
>> The following are changes since commit 95b744508d4d5135ae2a096ff3f0ee882bcc52b3:
>>   qede: remove linux/version.h and linux/compiler.h
>> and are available in the git repository at:
>>   git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE
>>
>> Jacob Keller (14):
>>   ice: re-order ice_mbx_reset_snapshot function
>>   ice: convert ice_mbx_clear_malvf to void and use WARN
>>   ice: track malicious VFs in new ice_mbx_vf_info structure
>>   ice: move VF overflow message count into struct ice_mbx_vf_info
>>   ice: remove ice_mbx_deinit_snapshot
>>   ice: merge ice_mbx_report_malvf with ice_mbx_vf_state_handler
>>   ice: initialize mailbox snapshot earlier in PF init
>>   ice: declare ice_vc_process_vf_msg in ice_virtchnl.h
>>   ice: always report VF overflowing mailbox even without PF VSI
>>   ice: remove unnecessary &array[0] and just use array
>>   ice: pass mbxdata to ice_is_malicious_vf()
>>   ice: print message if ice_mbx_vf_state_handler returns an error
>>   ice: move ice_is_malicious_vf() to ice_virtchnl.c
>>   ice: call ice_is_malicious_vf() from ice_vc_process_vf_msg()
> 
> Everything looks legit except your anti-spamming logic which IMHO
> shouldn't happen in first place.
> 

Without the checks there's no warning to the system administrator that a
VM may have been misconfigured or modified to spam messages. If this
occurs, the VM can overload the PF's mailbox queue and prevent other VFs
from using the queue normally, and thus performing a denial of service.

My understanding (I was not involved in the original implementation or
discussions) is that there is no hardware mechanism to prevent such
overflow in this device. This is an oversight in the design which was
not caught until it was too late to make such a change.

The original checks were added in 0891c89674e8 ("ice: warn about
potentially malicious VFs"), but it seems that commit message did not
provide much detail :(

-Jake

> Thanks,
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
