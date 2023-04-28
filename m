Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF1366F2002
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 23:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbjD1VSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 17:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbjD1VSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 17:18:05 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5DA7211E
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 14:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682716681; x=1714252681;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=40PhiRyk7TIiteml7jItME8JXb/Q4jKn8ZX9jjiMWb4=;
  b=B3n3vJ75FqvHjuHcUsUeqUbQS3vudeS407s6Y/YbPdbKOv7dgiHGi4bS
   c0rAoLTQKwvuuuwfUhwQzbgQv4QgOCrK1GAyLhlraKZWALcB+UZyg+le8
   TFef13N0/V421nOmu/2zzbAY6fAW+oxXRWT5qJwLmx0B8QPjylM6VHKBU
   Z9zM+YKxuRgiahC1aH2YHB1RBJNUCO43J6eb9NwfmrWZ3FnJ+uaKUfmPo
   z95N8PsIswdFbHQres6oGEpA1V2xj1tPaPBerDUVdpwrTZ6vH7sxw7lyD
   hNs3dUI+FcoPaCn8hIvNONFg4ZfMaRCD3O1OQzadEWS4lwen14Qi9PXn7
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10694"; a="332185834"
X-IronPort-AV: E=Sophos;i="5.99,235,1677571200"; 
   d="scan'208";a="332185834"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2023 14:18:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10694"; a="819150296"
X-IronPort-AV: E=Sophos;i="5.99,235,1677571200"; 
   d="scan'208";a="819150296"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 28 Apr 2023 14:18:01 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 28 Apr 2023 14:18:00 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 28 Apr 2023 14:18:00 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 28 Apr 2023 14:18:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hF6tsSBSBbd3lzyO998Jpbxuv7URK9FQHthehDLeVdEe+GuSSFG+Qc8uYHF+BW4Dw0PIldJ7mgOloH+iglLUEpI+7+kErYhSmpRJn68YqQwKdJ03inMzMgwjVB/39ECxiLJj4KGQo1TMbR/IFLenWNr7LEtp6DVDfO+hQG5K9AQnSDp6n6Ugj0zfKVg16HIpilXUoVS3Lp37G39Rg67Nqvv+RgS2US8C+iDZteyRREbnV7/ClzjoSgkO9qXkkHkSkigiYiDh59SuHG8zYBDwgo8IbNiNtV0SlfBQ+JUzHgPlwhiQXSKeNWBQvjZvq7bW1rCbUYA5CrsmMUyxiL3epw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XHJ4OlD6EyH9zIxB74P7KlPqyG/CydrWWotW/9NDs/c=;
 b=T/92R3W3Xy5b6h4gBkLg/ROWThrUTX9GWb+g2UGrAOd6alWLJRB6vWXIkS4GJsX/m5gYVbDCJ5lH7qywngioXiYrjBbauzEkW9KntmW809VdvdyBc1b1k3LLTrQ4+0gOf4vEYXoPJ6Y8F3XoTAEzjRTglzmWGfLbM44o+Jh+QTkKfn66F+o+Zjofh8sZV9j1oZSCum7eUNSScUkhZcHGpS1fNpwbeBoMvnLaShtS3ptXcscmmSPQqw96EIMFpkioyFmZcQ+CPrEcB4NALaoCNFfVreSyxNRgI7gAI4qSZUJstgBO0kCPYN1DEeqKrOSEq6mocHxDyNJdn9S0NWcuhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW3PR11MB4538.namprd11.prod.outlook.com (2603:10b6:303:57::12)
 by SN7PR11MB7440.namprd11.prod.outlook.com (2603:10b6:806:340::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.20; Fri, 28 Apr
 2023 21:17:57 +0000
Received: from MW3PR11MB4538.namprd11.prod.outlook.com
 ([fe80::aae6:d608:6b8d:977e]) by MW3PR11MB4538.namprd11.prod.outlook.com
 ([fe80::aae6:d608:6b8d:977e%7]) with mapi id 15.20.6340.021; Fri, 28 Apr 2023
 21:17:57 +0000
Message-ID: <88832ddd-d9e3-8427-8f63-c2c6bf94c84e@intel.com>
Date:   Fri, 28 Apr 2023 14:17:53 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [net-next v3 04/15] idpf: add core init and interrupt request
To:     Shannon Nelson <shannon.nelson@amd.com>,
        <intel-wired-lan@lists.osuosl.org>
CC:     <netdev@vger.kernel.org>, <joshua.a.hay@intel.com>,
        <sridhar.samudrala@intel.com>, <jesse.brandeburg@intel.com>,
        <anthony.l.nguyen@intel.com>, <willemb@google.com>,
        <decot@google.com>, <pabeni@redhat.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <davem@davemloft.net>,
        <alan.brady@intel.com>, <madhu.chittim@intel.com>,
        <phani.r.burra@intel.com>, <shailendra.bhatnagar@intel.com>,
        <pavan.kumar.linga@intel.com>, <simon.horman@corigine.com>,
        <leon@kernel.org>
References: <20230427020917.12029-1-emil.s.tantilov@intel.com>
 <20230427020917.12029-5-emil.s.tantilov@intel.com>
 <00acfde0-b970-d0e9-4415-56a295fe073f@amd.com>
Content-Language: en-US
From:   "Tantilov, Emil S" <emil.s.tantilov@intel.com>
In-Reply-To: <00acfde0-b970-d0e9-4415-56a295fe073f@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY3PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:a03:255::14) To MW3PR11MB4538.namprd11.prod.outlook.com
 (2603:10b6:303:57::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR11MB4538:EE_|SN7PR11MB7440:EE_
X-MS-Office365-Filtering-Correlation-Id: 9143849f-edeb-4720-52bc-08db482e096f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D3gVSU2I6KZNF8XlRs1cOoS7iKmZ5eMlkNhbn7Mzr93Y3PDjs3JkNvyU1q8Yj6jjD+XQS3f8Hx2Tky7a33Jp3/dA1caWnSJcbif36h0I6pPCjSpgjoSwdk58mamQn9dLd+bhG1Ri3vAs0qbSkDfkmFE2QSmoyDNc0EGsv4VlzYZ9HbRO0OJhyedpPZg5E56kkTisNNdwN7nVWRFQJyTu+vn2yrgWjUFnUXjkSn7wI1brvgzYXDXAhjObzBbApqAHACzua2zSkVzMd2NlKk790PZxzRcPsSKD8n70U4HEyrHxU1JC7BUNDvqmAv0kxo70oFfHYF+8/N+ok9akO8CAipOXlL2FlSuei+zRrraRQz0LsUNHEeJvDHcddsZE6rVnyHnKNeBwRrqELRm4xG43d4Rqvth60UY//roXXLlg6h7G8z1gWaQ98Ho+MVObIPSG+tYS8NZaLrVUjCOb9dtJU5u93ghR6VRF/EOo2EaKgnoOKq24JivaYBMPyv/+vrtZBlTi0269o95SFNQUkfVIvg8XuZ7qb2apZezLvuQXN3n4hTf1XuzSsgvqur5ov2Cdaq8WNsHnqlmFu1E2u9/gIlOOIm3FAjwaJx4F72E9a9H3incmW/ybaZG60VXSr0nkBRHB4Ge/N4117f+/KJzDNQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4538.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(396003)(376002)(39860400002)(136003)(451199021)(66946007)(6506007)(478600001)(26005)(186003)(53546011)(6486002)(2906002)(6666004)(36756003)(316002)(66556008)(8936002)(5660300002)(82960400001)(8676002)(66476007)(7416002)(6512007)(41300700001)(38100700002)(4326008)(31696002)(86362001)(2616005)(83380400001)(30864003)(31686004)(66899021)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q0F3RGN6cXZMeHhLQ0VhRzZ1YmE1YWprV2dXL2ZSenJUbVBhZ0VnRE03STNr?=
 =?utf-8?B?bzJYeUNQNit5Nzdjd01Iano5SFpYRHA2ZGpXN2lQMTlLU205QXd1aC9aVXVp?=
 =?utf-8?B?RWxuTmw4VFZLUytoN2owUnB2MVB6WisvUFNtVEppVVgwUk05d3ZLQ0hrM3NB?=
 =?utf-8?B?UzllQnMvOXAxT1RjLzdGTThPclplcEdUNUQwOEFwbUNDYktqaUx2RXQ4TGVs?=
 =?utf-8?B?N3lncG85UDBacGdUZUFhYVZEdS8xZ3FMNkNVei9IZGRGcmcydDNmL2xpOUk0?=
 =?utf-8?B?ay9FWkpoSnJhR2hQQU1pT3RFUXRQM21GckhDREdsWERWVXl2RG5VcFdvM1NV?=
 =?utf-8?B?U202T1dYWVMxRHNwclUwaHdtcVVoSEQ2a1VGbk9xNXd2ekJERHpqaDNDVHRp?=
 =?utf-8?B?REUvSzdDSVhwV0c1OWZzVGpadkVyYXFMZmozbkVOQzA3VWFiTUJXcmM0OFBF?=
 =?utf-8?B?QUxJNERHRW1uOTc4MHh4cng4bnpML1VtNkVXSml1eFdlakxoc1U0NHl3WUFV?=
 =?utf-8?B?WWxRUWRyWk9NVnVVK205YklFWGthM3ZPZmlQM09xYUNhcEdRSGhDSkJnVmJ4?=
 =?utf-8?B?WldWcWc1ZndSMld3M3RYems2YnZxMGhPdW9Vcjh3eXZWUW9maVNRSDRQNVBH?=
 =?utf-8?B?c2dnUWh6aDEydVpUZEEreTRBNkVhc2FKVXRyMVdaTmNZTURtL0dRcmR5VHBL?=
 =?utf-8?B?N2xTbzhlRXdLcjFSSXdyOWxsZ2J0bG5PbTBPd00wb0pKRGlSZC8wUjZNR29D?=
 =?utf-8?B?czJCR1l2c1pSd0p5Rmd6QVltR3BHSSs4S25aUXNnamp2Yjh5dTRnNEpTZ3dQ?=
 =?utf-8?B?RnN2S0d4VXQwMEhINDIrV3lWZFFWSktBQnd3YnJ0dnhKeWFzeEpnSXZyWjF2?=
 =?utf-8?B?Q0N0cW42aHJMa0hxRGVNNVB5bm9qaFZQcWQ3T1QvODN4UzJwVjVrekc5U1V3?=
 =?utf-8?B?TlFXNGlQYXIwWUpPYit5ZnkxVktCazVaY1JLMU04OVhrT0xXaUdndzBuR3dl?=
 =?utf-8?B?NU9lQitHQnhrZnlZUTRZck43OTNXT3QvRlh3TXZPUzFqa3kvWlpUcGx6YXZ6?=
 =?utf-8?B?MlBsczV2UVN3K2tOb08ybkNSZW5qd0xNL1ppOHVXOFhVYjFWb1V0Z0pDLzBI?=
 =?utf-8?B?TFJoMHlaa3ZvSW5oR1lTNlk2cWY5a0c0ZFc1aEZOMmtOb2ZuNE8ydTRLNGpL?=
 =?utf-8?B?UXVLMFh5Q25OYU5SZmxUcVgxd3FuOFcrR25DNWF1Nmw5NEhDRU1wQmRZN2Vn?=
 =?utf-8?B?VG5EYWpPeVZoZFZXZXdXVjRQMWZROXBWaVVoenl3OCtxTE05U2g0THJvUDlI?=
 =?utf-8?B?KzNvTGowUGM1VThIUllWaHV3N0hGbGttRzJrMXhNMUY2MnNtYmJOVkY1cVVa?=
 =?utf-8?B?U2RscU8yWlZDa2ZEbUwxYS9qS3BMa1NtOGlMYzE5QUc1cEdDR01JazljRjI2?=
 =?utf-8?B?bzROZ0N5cWkxOExyTURqb3ZQTnl6bjRjSUFRMzVneEQ1a0FZbnBUQTFQR2lG?=
 =?utf-8?B?Qjl5Ui9BcGhaYndZbzB5QVM0STNoV0dQNXZwdE5PUEJXaG9NTk00ajlwKzBP?=
 =?utf-8?B?WTQxMnRkaS9ZUzZoZTViQWl3T043MTV1U2VRbzJZUkM2L3NQckRneTkxNkZu?=
 =?utf-8?B?RVJqUW5mNlNiRUM4REV0dVZyaVhIZHpoaVB2ekZKV0pYVTl2aDZ4RVlCTlFl?=
 =?utf-8?B?TlVadHV4Lys5UnNGRHZ4K2NKTk1EWEpYNjhWZlhUaml0eEg3NktxVFliVkJY?=
 =?utf-8?B?NFR5S3EyZi9BY3hydXpaOFdkZVZrN0NVUkI4MmRhQ1BoYkFWakFScmZmT1JW?=
 =?utf-8?B?OXUwanhZaUYyTUF2bGcyYklnK0dwVXFuU1U0bngrK1UxcTN0djJwL0RDOXFw?=
 =?utf-8?B?SG1RUlpnVnUydnNVanFhWWFSSVRRVnZGTUNsWWN6aTdtSml5bS9SWGNRT1J0?=
 =?utf-8?B?Z3ZTR3ZQUUJmS2tya2s5b2dWSE1nVTZjc1E3MUx1Y04xTzlvcmwzZ0JFM3RK?=
 =?utf-8?B?NU9OUWcyWlVZbVFtUEhnYnFGSkxNb2hwUE95Z2RkenB1eitWYW15VG1MYVpE?=
 =?utf-8?B?NFRnVjUxK0h0U1V0MjZ4Y1dXaHcrREU2bXlMUnZ1ejAwNVRGM0VGbUFKUVN4?=
 =?utf-8?B?ajFmUWE0dUcySEZiU1Z0V1diNTU0Qnc5MnZvM016Y1FCVkNNWjQ4NFREenNl?=
 =?utf-8?B?MGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9143849f-edeb-4720-52bc-08db482e096f
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4538.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2023 21:17:56.9223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8xCrkshrds8E0muw79HL0IHXScvuTDZhNtlMMR/eyw9CXzphnhjosNojcDtM3BRIgYWaMU4wu33AwrVMhfV6PHPV6Xb4yXtqUbX4Jrk9uqY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7440
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/28/2023 12:50 PM, Shannon Nelson wrote:
> On 4/26/23 7:09 PM, Emil Tantilov wrote:
>> From: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
>>
>> As the mailbox is setup, add the necessary send and receive
>> mailbox message framework to support the virtchnl communication
>> between the driver and device Control Plane (CP).
>>
>> Add the core initialization. To start with, driver confirms the
>> virtchnl version with the CP. Once that is done, it requests
>> and gets the required capabilities and resources needed such as
>> max vectors, queues etc.
>>
>> Based on the vector information received in 'VIRTCHNL2_OP_GET_CAPS',
>> request the stack to allocate the required vectors. Finally add
>> the interrupt handling mechanism for the mailbox queue and enable
>> the interrupt.
>>
>> Note: Checkpatch issues a warning about IDPF_FOREACH_VPORT_VC_STATE and
>> IDPF_GEN_STRING being complex macros and should be enclosed in 
>> parentheses
>> but it's not the case. They are never used as a statement and instead 
>> only
>> used to define the enum and array.
>>
>> Co-developed-by: Alan Brady <alan.brady@intel.com>
>> Signed-off-by: Alan Brady <alan.brady@intel.com>
>> Co-developed-by: Emil Tantilov <emil.s.tantilov@intel.com>
>> Signed-off-by: Emil Tantilov <emil.s.tantilov@intel.com>
>> Co-developed-by: Joshua Hay <joshua.a.hay@intel.com>
>> Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
>> Co-developed-by: Madhu Chittim <madhu.chittim@intel.com>
>> Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
>> Co-developed-by: Phani Burra <phani.r.burra@intel.com>
>> Signed-off-by: Phani Burra <phani.r.burra@intel.com>
>> Co-developed-by: Shailendra Bhatnagar <shailendra.bhatnagar@intel.com>
>> Signed-off-by: Shailendra Bhatnagar <shailendra.bhatnagar@intel.com>
>> Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
>> Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
>> Reviewed-by: Willem de Bruijn <willemb@google.com>
>> ---
>>   drivers/net/ethernet/intel/idpf/idpf.h        | 137 ++-
>>   drivers/net/ethernet/intel/idpf/idpf_dev.c    |  17 +
>>   .../ethernet/intel/idpf/idpf_lan_pf_regs.h    |  43 +
>>   .../ethernet/intel/idpf/idpf_lan_vf_regs.h    |  38 +
>>   drivers/net/ethernet/intel/idpf/idpf_lib.c    | 343 ++++++++
>>   drivers/net/ethernet/intel/idpf/idpf_main.c   |  16 +
>>   drivers/net/ethernet/intel/idpf/idpf_txrx.h   |  26 +
>>   drivers/net/ethernet/intel/idpf/idpf_vf_dev.c |  22 +-
>>   .../net/ethernet/intel/idpf/idpf_virtchnl.c   | 801 ++++++++++++++++++
>>   9 files changed, 1441 insertions(+), 2 deletions(-)
>>   create mode 100644 drivers/net/ethernet/intel/idpf/idpf_txrx.h

<snip>

>> +/**
>> + * idpf_intr_req - Request interrupt capabilities
>> + * @adapter: adapter to enable interrupts on
>> + *
>> + * Returns 0 on success, negative on failure
>> + */
>> +int idpf_intr_req(struct idpf_adapter *adapter)
>> +{
>> +       u16 default_vports = idpf_get_default_vports(adapter);
>> +       int num_q_vecs, total_vecs, num_vec_ids;
>> +       int min_vectors, v_actual, err = 0;
>> +       unsigned int vector;
>> +       u16 *vecids;
>> +
>> +       total_vecs = idpf_get_reserved_vecs(adapter);
>> +       num_q_vecs = total_vecs - IDPF_MBX_Q_VEC;
>> +
>> +       err = idpf_send_alloc_vectors_msg(adapter, num_q_vecs);
>> +       if (err) {
>> +               dev_err(&adapter->pdev->dev,
>> +                       "Failed to allocate vectors: %d\n", err);
> 
> To aid in debugging, it would be good to include the number of vectors 
> in these error messages.
Sure.

> 
>> +
>> +               return -EAGAIN;
>> +       }
>> +
>> +       min_vectors = IDPF_MBX_Q_VEC + IDPF_MIN_Q_VEC * default_vports;
>> +       v_actual = pci_alloc_irq_vectors(adapter->pdev, min_vectors,
>> +                                        total_vecs, PCI_IRQ_MSIX);
>> +       if (v_actual < min_vectors) {
>> +               dev_err(&adapter->pdev->dev, "Failed to allocate MSIX 
>> vectors: %d\n",
>> +                       v_actual);
>> +               err = -EAGAIN;
>> +               goto send_dealloc_vecs;
>> +       }
>> +
>> +       adapter->msix_entries = kcalloc(v_actual, sizeof(struct 
>> msix_entry),
>> +                                       GFP_KERNEL);
>> +
>> +       if (!adapter->msix_entries) {
>> +               err = -ENOMEM;
>> +               goto free_irq;
>> +       }
>> +
>> +       idpf_set_mb_vec_id(adapter);
>> +
>> +       vecids = kcalloc(total_vecs, sizeof(u16), GFP_KERNEL);
>> +       if (!vecids) {
>> +               err = -ENOMEM;
>> +               goto free_msix;
>> +       }
>> +
>> +       if (adapter->req_vec_chunks) {
>> +               struct virtchnl2_vector_chunks *vchunks;
>> +               struct virtchnl2_alloc_vectors *ac;
>> +
>> +               ac = adapter->req_vec_chunks;
>> +               vchunks = &ac->vchunks;
>> +
>> +               num_vec_ids = idpf_get_vec_ids(adapter, vecids, 
>> total_vecs,
>> +                                              vchunks);
>> +               if (num_vec_ids < v_actual) {
>> +                       err = -EINVAL;
>> +                       goto free_vecids;
>> +               }
>> +       } else {
>> +               int i = 0;
> 
> zero init unnecessary
> for that matter, I've recently seen someone using
>      for (int i = 0; ...
> in simple local for-loops
> I'm not sure that's an accepted practice yet, but would make sense here
> 
OK, we'll remove the zero init.

>> +
>> +               for (i = 0; i < v_actual; i++)
>> +                       vecids[i] = i;
>> +       }
>> +
>> +       for (vector = 0; vector < v_actual; vector++) {
>> +               adapter->msix_entries[vector].entry = vecids[vector];
>> +               adapter->msix_entries[vector].vector =
>> +                       pci_irq_vector(adapter->pdev, vector);
>> +       }
>> +
>> +       adapter->num_req_msix = total_vecs;
>> +       adapter->num_msix_entries = v_actual;
>> +       /* 'num_avail_msix' is used to distribute excess vectors to 
>> the vports
>> +        * after considering the minimum vectors required per each 
>> default
>> +        * vport
>> +        */
>> +       adapter->num_avail_msix = v_actual - min_vectors;
>> +
>> +       /* Fill MSIX vector lifo stack with vector indexes */
>> +       err = idpf_init_vector_stack(adapter);
>> +       if (err)
>> +               goto free_vecids;
>> +
>> +       err = idpf_mb_intr_init(adapter);
>> +       if (err)
>> +               goto deinit_vec_stack;
>> +       idpf_mb_irq_enable(adapter);
>> +       kfree(vecids);
>> +
>> +       return err;
>> +
>> +deinit_vec_stack:
>> +       idpf_deinit_vector_stack(adapter);
>> +free_vecids:
>> +       kfree(vecids);
>> +free_msix:
>> +       kfree(adapter->msix_entries);
>> +       adapter->msix_entries = NULL;
>> +free_irq:
>> +       pci_free_irq_vectors(adapter->pdev);
>> +send_dealloc_vecs:
>> +       idpf_send_dealloc_vectors_msg(adapter);
>> +
>> +       return err;
>> +}
>> +
>> +/**
>> + * idpf_service_task - Delayed task for handling mailbox responses
>> + * @work: work_struct handle to our data
>> + *
>> + */
>> +void idpf_service_task(struct work_struct *work)
>> +{
>> +       struct idpf_adapter *adapter;
>> +
>> +       adapter = container_of(work, struct idpf_adapter, 
>> serv_task.work);
>> +
>> +       if (test_bit(__IDPF_MB_INTR_MODE, adapter->flags)) {
>> +               if (test_and_clear_bit(__IDPF_MB_INTR_TRIGGER,
>> +                                      adapter->flags)) {
>> +                       idpf_recv_mb_msg(adapter, VIRTCHNL2_OP_UNKNOWN,
>> +                                        NULL, 0);
>> +                       idpf_mb_irq_enable(adapter);
>> +               }
>> +       } else {
>> +               idpf_recv_mb_msg(adapter, VIRTCHNL2_OP_UNKNOWN, NULL, 0);
>> +       }
>> +
>> +       if (idpf_is_reset_detected(adapter) &&
>> +           !idpf_is_reset_in_prog(adapter) &&
>> +           !test_bit(__IDPF_REMOVE_IN_PROG, adapter->flags)) {
>> +               dev_info(&adapter->pdev->dev, "HW reset detected\n");
>> +               set_bit(__IDPF_HR_FUNC_RESET, adapter->flags);
> 
> Is there any chance of some other thread starting a reset in the time 
> between your is_reset_in_progress check and setting this FUNC_RESET bit?
> 
We have a mutex called reset_lock in adapter that should take care of it.

<snip>

>> +/**
>> + * idpf_send_mb_msg - Send message over mailbox
>> + * @adapter: Driver specific private structure
>> + * @op: virtchnl opcode
>> + * @msg_size: size of the payload
>> + * @msg: pointer to buffer holding the payload
>> + *
>> + * Will prepare the control queue message and initiates the send api
>> + *
>> + * Returns 0 on success, negative on failure
>> + */
>> +int idpf_send_mb_msg(struct idpf_adapter *adapter, u32 op,
>> +                    u16 msg_size, u8 *msg)
>> +{
>> +       struct idpf_ctlq_msg *ctlq_msg;
>> +       struct idpf_dma_mem *dma_mem;
>> +       int err;
>> +
>> +       /* If we are here and a reset is detected nothing much can be
>> +        * done. This thread should silently abort and expected to
>> +        * be corrected with a new run either by user or driver
>> +        * flows after reset
>> +        */
>> +       if (idpf_is_reset_detected(adapter))
>> +               return 0;
>> +
>> +       err = idpf_mb_clean(adapter);
>> +       if (err)
>> +               return err;
>> +
>> +       ctlq_msg = kzalloc(sizeof(*ctlq_msg), GFP_ATOMIC);
>> +       if (!ctlq_msg)
>> +               return -ENOMEM;
>> +
>> +       dma_mem = kzalloc(sizeof(*dma_mem), GFP_ATOMIC);
>> +       if (!dma_mem) {
>> +               err = -ENOMEM;
>> +               goto dma_mem_error;
>> +       }
>> +
>> +       memset(ctlq_msg, 0, sizeof(struct idpf_ctlq_msg));
> 
> Unnecessary, kzalloc() did this for you already
We'll remove it.

> 
>> +       ctlq_msg->opcode = idpf_mbq_opc_send_msg_to_pf;
>> +       ctlq_msg->func_id = 0;
>> +       ctlq_msg->data_len = msg_size;
>> +       ctlq_msg->cookie.mbx.chnl_opcode = op;
>> +       ctlq_msg->cookie.mbx.chnl_retval = VIRTCHNL2_STATUS_SUCCESS;
>> +       dma_mem->size = IDPF_DFLT_MBX_BUF_SIZE;
>> +       dma_mem->va = dmam_alloc_coherent(&adapter->pdev->dev, 
>> dma_mem->size,
>> +                                         &dma_mem->pa, GFP_ATOMIC);
> 
> Were you going to replace these dmam as you did the devm?
> Or are you intentionally keeping them?
> 
We look into replacing the dmam calls as well.

>> +       if (!dma_mem->va) {
>> +               err = -ENOMEM;
>> +               goto dma_alloc_error;
>> +       }
>> +       memcpy(dma_mem->va, msg, msg_size);
>> +       ctlq_msg->ctx.indirect.payload = dma_mem;
>> +
>> +       err = idpf_ctlq_send(&adapter->hw, adapter->hw.asq, 1, ctlq_msg);
>> +       if (err)
>> +               goto send_error;
>> +
>> +       return 0;
>> +
>> +send_error:
>> +       dmam_free_coherent(&adapter->pdev->dev, dma_mem->size, 
>> dma_mem->va,
>> +                          dma_mem->pa);
>> +dma_alloc_error:
>> +       kfree(dma_mem);
>> +dma_mem_error:
>> +       kfree(ctlq_msg);
>> +
>> +       return err;
>> +}
>> +
>> +/**
>> + * idpf_set_msg_pending_bit - Wait for clear and set msg pending
>> + * @adapter: driver specific private structure
>> + * @vport: virtual port structure
>> + *
>> + * If clear sets msg pending bit, otherwise waits for it to clear before
>> + * setting it again. Returns 0 on success, negative on failure.
>> + */
>> +static int idpf_set_msg_pending_bit(struct idpf_adapter *adapter,
>> +                                   struct idpf_vport *vport)
>> +{
>> +       unsigned int retries = 100;
>> +
>> +       /* If msg pending bit already set, there's a message waiting 
>> to be
>> +        * parsed and we must wait for it to be cleared before copying 
>> a new
>> +        * message into the vc_msg buffer or else we'll stomp all over 
>> the
>> +        * previous message.
>> +        */
>> +       while (retries) {
>> +               if (!test_and_set_bit(__IDPF_VC_MSG_PENDING, 
>> adapter->flags))
>> +                       break;
>> +               msleep(20);
>> +               retries--;
>> +       }
>> +
>> +       return retries ? 0 : -ETIMEDOUT;
>> +}
>> +
>> +/**
>> + * idpf_set_msg_pending - Wait for msg pending bit and copy msg to buf
>> + * @adapter: driver specific private structure
>> + * @vport: virtual port structure
>> + * @ctlq_msg: msg to copy from
>> + * @err_enum: err bit to set on error
>> + *
>> + * Copies payload from ctlq_msg into vc_msg buf in adapter and sets 
>> msg pending
>> + * bit. Returns 0 on success, negative on failure.
>> + */
>> +static int idpf_set_msg_pending(struct idpf_adapter *adapter,
>> +                               struct idpf_vport *vport,
>> +                               struct idpf_ctlq_msg *ctlq_msg,
>> +                               enum idpf_vport_vc_state err_enum)
>> +{
>> +       if (ctlq_msg->cookie.mbx.chnl_retval) {
>> +               set_bit(err_enum, adapter->vc_state);
>> +
>> +               return -EINVAL;
>> +       }
>> +
>> +       if (idpf_set_msg_pending_bit(adapter, vport)) {
>> +               set_bit(err_enum, adapter->vc_state);
>> +               dev_err(&adapter->pdev->dev, "Timed out setting msg 
>> pending\n");
>> +
>> +               return -ETIMEDOUT;
>> +       }
>> +
>> +       memcpy(adapter->vc_msg, ctlq_msg->ctx.indirect.payload->va,
>> +              min_t(int, ctlq_msg->ctx.indirect.payload->size,
>> +                    IDPF_DFLT_MBX_BUF_SIZE));
>> +
>> +       return 0;
>> +}
>> +
>> +/**
>> + * idpf_recv_vchnl_op - helper function with common logic when 
>> handling the
>> + * reception of VIRTCHNL OPs.
>> + * @adapter: driver specific private structure
>> + * @vport: virtual port structure
>> + * @ctlq_msg: msg to copy from
>> + * @state: state bit used on timeout check
>> + * @err_state: err bit to set on error
>> + */
>> +static void idpf_recv_vchnl_op(struct idpf_adapter *adapter,
>> +                              struct idpf_vport *vport,
>> +                              struct idpf_ctlq_msg *ctlq_msg,
>> +                              enum idpf_vport_vc_state state,
>> +                              enum idpf_vport_vc_state err_state)
>> +{
>> +       wait_queue_head_t *vchnl_wq = &adapter->vchnl_wq;
>> +       int err;
>> +
>> +       err = idpf_set_msg_pending(adapter, vport, ctlq_msg, err_state);
>> +       if (wq_has_sleeper(vchnl_wq)) {
>> +               /* sleeper is present and we got the pending bit */
>> +               set_bit(state, adapter->vc_state);
>> +
>> +               wake_up(vchnl_wq);
>> +       } else {
>> +               if (!err) {
>> +                       /* We got the pending bit, but release it if 
>> we cannot
>> +                        * find a thread waiting for the message.
>> +                        */
>> +                       dev_warn(&adapter->pdev->dev, "opcode %d 
>> received without waiting thread\n",
>> +                                ctlq_msg->cookie.mbx.chnl_opcode);
>> +                       clear_bit(__IDPF_VC_MSG_PENDING, adapter->flags);
>> +               } else {
>> +                       /* Clear the errors since there is no sleeper 
>> to pass them on */
>> +                       clear_bit(err_state, adapter->vc_state);
>> +               }
>> +       }
>> +}
>> +
>> +/**
>> + * idpf_recv_mb_msg - Receive message over mailbox
>> + * @adapter: Driver specific private structure
>> + * @op: virtchannel operation code
>> + * @msg: Received message holding buffer
>> + * @msg_size: message size
>> + *
>> + * Will receive control queue message and posts the receive buffer. 
>> Returns 0
>> + * on success and negative on failure.
>> + */
>> +int idpf_recv_mb_msg(struct idpf_adapter *adapter, u32 op,
>> +                    void *msg, int msg_size)
>> +{
>> +       struct idpf_ctlq_msg ctlq_msg;
>> +       struct idpf_dma_mem *dma_mem;
>> +       bool work_done = false;
>> +       int num_retry = 2000;
>> +       u16 num_q_msg;
>> +       int err;
>> +
>> +       while (1) {
>> +               int payload_size = 0;
>> +
>> +               /* Try to get one message */
>> +               num_q_msg = 1;
>> +               dma_mem = NULL;
>> +               err = idpf_ctlq_recv(adapter->hw.arq, &num_q_msg, 
>> &ctlq_msg);
>> +               /* If no message then decide if we have to retry based on
>> +                * opcode
>> +                */
>> +               if (err || !num_q_msg) {
>> +                       /* Increasing num_retry to consider the delayed
>> +                        * responses because of large number of VF's 
>> mailbox
>> +                        * messages. If the mailbox message is 
>> received from
>> +                        * the other side, we come out of the sleep cycle
>> +                        * immediately else we wait for more time.
>> +                        */
>> +                       if (!op || !num_retry--)
>> +                               break;
>> +                       if (test_bit(__IDPF_REL_RES_IN_PROG, 
>> adapter->flags)) {
>> +                               err = -EIO;
>> +                               break;
>> +                       }
>> +                       msleep(20);
>> +                       continue;
>> +               }
>> +
>> +               /* If we are here a message is received. Check if we 
>> are looking
>> +                * for a specific message based on opcode. If it is 
>> different
>> +                * ignore and post buffers
>> +                */
>> +               if (op && ctlq_msg.cookie.mbx.chnl_opcode != op)
>> +                       goto post_buffs;
>> +
>> +               if (ctlq_msg.data_len)
>> +                       payload_size = 
>> ctlq_msg.ctx.indirect.payload->size;
>> +
>> +               /* All conditions are met. Either a message requested is
>> +                * received or we received a message to be processed
>> +                */
>> +               switch (ctlq_msg.cookie.mbx.chnl_opcode) {
>> +               case VIRTCHNL2_OP_VERSION:
>> +               case VIRTCHNL2_OP_GET_CAPS:
>> +                       if (ctlq_msg.cookie.mbx.chnl_retval) {
>> +                               dev_err(&adapter->pdev->dev, "Failure 
>> initializing, vc op: %u retval: %u\n",
>> +                                       ctlq_msg.cookie.mbx.chnl_opcode,
>> +                                       ctlq_msg.cookie.mbx.chnl_retval);
>> +                               err = -EBADMSG;
>> +                       } else if (msg) {
>> +                               memcpy(msg, 
>> ctlq_msg.ctx.indirect.payload->va,
>> +                                      min_t(int, payload_size, 
>> msg_size));
>> +                       }
>> +                       work_done = true;
>> +                       break;
>> +               case VIRTCHNL2_OP_ALLOC_VECTORS:
>> +                       idpf_recv_vchnl_op(adapter, NULL, &ctlq_msg,
>> +                                          IDPF_VC_ALLOC_VECTORS,
>> +                                          IDPF_VC_ALLOC_VECTORS_ERR);
>> +                       break;
>> +               case VIRTCHNL2_OP_DEALLOC_VECTORS:
>> +                       idpf_recv_vchnl_op(adapter, NULL, &ctlq_msg,
>> +                                          IDPF_VC_DEALLOC_VECTORS,
>> +                                          IDPF_VC_DEALLOC_VECTORS_ERR);
>> +                       break;
>> +               default:
>> +                       dev_warn(&adapter->pdev->dev,
>> +                                "Unhandled virtchnl response %d\n",
>> +                                ctlq_msg.cookie.mbx.chnl_opcode);
>> +                       break;
>> +               }
>> +
>> +post_buffs:
>> +               if (ctlq_msg.data_len)
>> +                       dma_mem = ctlq_msg.ctx.indirect.payload;
>> +               else
>> +                       num_q_msg = 0;
>> +
>> +               err = idpf_ctlq_post_rx_buffs(&adapter->hw, 
>> adapter->hw.arq,
>> +                                             &num_q_msg, &dma_mem);
>> +               /* If post failed clear the only buffer we supplied */
>> +               if (err && dma_mem)
>> +                       dmam_free_coherent(&adapter->pdev->dev, 
>> dma_mem->size,
>> +                                          dma_mem->va, dma_mem->pa);
>> +
>> +               /* Applies only if we are looking for a specific 
>> opcode */
>> +               if (work_done)
>> +                       break;
>> +       }
>> +
>> +       return err;
>> +}
>> +
>> +/**
>> + * __idpf_wait_for_event - wrapper function for wait on virtchannel 
>> response
>> + * @adapter: Driver private data structure
>> + * @vport: virtual port structure
>> + * @state: check on state upon timeout
>> + * @err_check: check if this specific error bit is set
>> + * @timeout: Max time to wait
>> + *
>> + * Checks if state is set upon expiry of timeout.  Returns 0 on success,
>> + * negative on failure.
>> + */
>> +static int __idpf_wait_for_event(struct idpf_adapter *adapter,
>> +                                struct idpf_vport *vport,
>> +                                enum idpf_vport_vc_state state,
>> +                                enum idpf_vport_vc_state err_check,
>> +                                int timeout)
>> +{
>> +       int time_to_wait, num_waits;
>> +       wait_queue_head_t *vchnl_wq;
>> +       unsigned long *vc_state;
>> +
>> +       time_to_wait = ((timeout <= IDPF_MAX_WAIT) ? timeout : 
>> IDPF_MAX_WAIT);
>> +       num_waits = ((timeout <= IDPF_MAX_WAIT) ? 1 : timeout / 
>> IDPF_MAX_WAIT);
>> +
>> +       vchnl_wq = &adapter->vchnl_wq;
>> +       vc_state = adapter->vc_state;
>> +
>> +       while (num_waits) {
>> +               int event;
>> +
>> +               /* If we are here and a reset is detected do not wait but
>> +                * return. Reset timing is out of drivers control. So
>> +                * while we are cleaning resources as part of reset if 
>> the
>> +                * underlying HW mailbox is gone, wait on mailbox 
>> messages
>> +                * is not meaningful
>> +                */
>> +               if (idpf_is_reset_detected(adapter))
>> +                       return 0;
>> +
>> +               event = wait_event_timeout(*vchnl_wq,
>> +                                          test_and_clear_bit(state, 
>> vc_state),
>> +                                          
>> msecs_to_jiffies(time_to_wait));
>> +               if (event) {
>> +                       if (test_and_clear_bit(err_check, vc_state)) {
>> +                               dev_err(&adapter->pdev->dev, "VC 
>> response error %s\n",
>> +                                       
>> idpf_vport_vc_state_str[err_check]);
>> +
>> +                               return -EINVAL;
>> +                       }
>> +
>> +                       return 0;
>> +               }
>> +               num_waits--;
>> +       }
>> +
>> +       /* Timeout occurred */
>> +       dev_err(&adapter->pdev->dev, "VC timeout, state = %s\n",
>> +               idpf_vport_vc_state_str[state]);
>> +
>> +       return -ETIMEDOUT;
>> +}
>> +
>> +/**
>> + * idpf_min_wait_for_event - wait for virtchannel response
>> + * @adapter: Driver private data structure
>> + * @vport: virtual port structure
>> + * @state: check on state upon timeout
>> + * @err_check: check if this specific error bit is set
>> + *
>> + * Returns 0 on success, negative on failure.
>> + */
>> +static int idpf_min_wait_for_event(struct idpf_adapter *adapter,
>> +                                  struct idpf_vport *vport,
>> +                                  enum idpf_vport_vc_state state,
>> +                                  enum idpf_vport_vc_state err_check)
>> +{
>> +       return __idpf_wait_for_event(adapter, vport, state, err_check,
>> +                                    IDPF_WAIT_FOR_EVENT_TIMEO_MIN);
>> +}
>> +
>> +/**
>> + * idpf_wait_for_event - wait for virtchannel response
>> + * @adapter: Driver private data structure
>> + * @vport: virtual port structure
>> + * @state: check on state upon timeout after 500ms
>> + * @err_check: check if this specific error bit is set
>> + *
>> + * Returns 0 on success, negative on failure.
>> + */
>> +static int idpf_wait_for_event(struct idpf_adapter *adapter,
>> +                              struct idpf_vport *vport,
>> +                              enum idpf_vport_vc_state state,
>> +                              enum idpf_vport_vc_state err_check)
>> +{
>> +       /* Increasing the timeout in __IDPF_INIT_SW flow to consider 
>> large
>> +        * number of VF's mailbox message responses. When a message is 
>> received
>> +        * on mailbox, this thread is wake up by the idpf_recv_mb_msg 
>> before the
> 
> s/wake up/woken/
>
OK.

>> +        * timeout expires. Only in the error case i.e. if no message is
>> +        * received on mailbox, we wait for the complete timeout which is
>> +        * less likely to happen.
>> +        */
>> +       return __idpf_wait_for_event(adapter, vport, state, err_check,
>> +                                    IDPF_WAIT_FOR_EVENT_TIMEO);
>> +}
>> +
>> +/**
>> + * idpf_send_ver_msg - send virtchnl version message
>> + * @adapter: Driver specific private structure
>> + *
>> + * Send virtchnl version message.  Returns 0 on success, negative on 
>> failure.
>> + */
>> +static int idpf_send_ver_msg(struct idpf_adapter *adapter)
>> +{
>> +       struct virtchnl2_version_info vvi;
>> +
>> +       if (adapter->virt_ver_maj) {
>> +               vvi.major = cpu_to_le32(adapter->virt_ver_maj);
>> +               vvi.minor = cpu_to_le32(adapter->virt_ver_min);
>> +       } else {
>> +               vvi.major = cpu_to_le32(IDPF_VIRTCHNL_VERSION_MAJOR);
>> +               vvi.minor = cpu_to_le32(IDPF_VIRTCHNL_VERSION_MINOR);
>> +       }
>> +
>> +       return idpf_send_mb_msg(adapter, VIRTCHNL2_OP_VERSION, 
>> sizeof(vvi),
>> +                               (u8 *)&vvi);
>> +}
>> +
>> +/**
>> + * idpf_recv_ver_msg - Receive virtchnl version message
>> + * @adapter: Driver specific private structure
>> + *
>> + * Receive virtchnl version message. Returns 0 on success, -EAGAIN if 
>> we need
>> + * to send version message again, otherwise negative on failure.
>> + */
>> +static int idpf_recv_ver_msg(struct idpf_adapter *adapter)
>> +{
>> +       struct virtchnl2_version_info vvi;
>> +       u32 major, minor;
>> +       int err;
>> +
>> +       err = idpf_recv_mb_msg(adapter, VIRTCHNL2_OP_VERSION, &vvi, 
>> sizeof(vvi));
>> +       if (err)
>> +               return err;
>> +
>> +       major = le32_to_cpu(vvi.major);
>> +       minor = le32_to_cpu(vvi.minor);
>> +
>> +       if (major > IDPF_VIRTCHNL_VERSION_MAJOR) {
>> +               dev_warn(&adapter->pdev->dev, "Virtchnl major version 
>> greater than supported\n");
> 
> Printing the bad version value would be helpful here >
Sure.

>> +
>> +               return -EINVAL;
>> +       }
>> +
>> +       if (major == IDPF_VIRTCHNL_VERSION_MAJOR &&
>> +           minor > IDPF_VIRTCHNL_VERSION_MINOR)
>> +               dev_warn(&adapter->pdev->dev, "Virtchnl minor version 
>> didn't match\n");
> 
> dittoI will go through these to make sure we have more info related to the 
errors.

>> +
>> +       /* If we have a mismatch, resend version to update receiver on 
>> what
>> +        * version we will use.
>> +        */
>> +       if (!adapter->virt_ver_maj &&
>> +           major != IDPF_VIRTCHNL_VERSION_MAJOR &&
>> +           minor != IDPF_VIRTCHNL_VERSION_MINOR)
>> +               err = -EAGAIN;
>> +
>> +       adapter->virt_ver_maj = major;
>> +       adapter->virt_ver_min = minor;
>> +
>> +       return err;
>> +}
>> +
>> +/**
>> + * idpf_send_get_caps_msg - Send virtchnl get capabilities message
>> + * @adapter: Driver specific private structure
>> + *
>> + * Send virtchl get capabilities message. Returns 0 on success, 
>> negative on
>> + * failure.
>> + */
>> +static int idpf_send_get_caps_msg(struct idpf_adapter *adapter)
>> +{
>> +       struct virtchnl2_get_capabilities caps = { };
>> +
>> +       caps.csum_caps =
>> +               cpu_to_le32(VIRTCHNL2_CAP_TX_CSUM_L3_IPV4       |
>> +                           VIRTCHNL2_CAP_TX_CSUM_L4_IPV4_TCP   |
>> +                           VIRTCHNL2_CAP_TX_CSUM_L4_IPV4_UDP   |
>> +                           VIRTCHNL2_CAP_TX_CSUM_L4_IPV4_SCTP  |
>> +                           VIRTCHNL2_CAP_TX_CSUM_L4_IPV6_TCP   |
>> +                           VIRTCHNL2_CAP_TX_CSUM_L4_IPV6_UDP   |
>> +                           VIRTCHNL2_CAP_TX_CSUM_L4_IPV6_SCTP  |
>> +                           VIRTCHNL2_CAP_RX_CSUM_L3_IPV4       |
>> +                           VIRTCHNL2_CAP_RX_CSUM_L4_IPV4_TCP   |
>> +                           VIRTCHNL2_CAP_RX_CSUM_L4_IPV4_UDP   |
>> +                           VIRTCHNL2_CAP_RX_CSUM_L4_IPV4_SCTP  |
>> +                           VIRTCHNL2_CAP_RX_CSUM_L4_IPV6_TCP   |
>> +                           VIRTCHNL2_CAP_RX_CSUM_L4_IPV6_UDP   |
>> +                           VIRTCHNL2_CAP_RX_CSUM_L4_IPV6_SCTP  |
>> +                           VIRTCHNL2_CAP_TX_CSUM_L3_SINGLE_TUNNEL |
>> +                           VIRTCHNL2_CAP_RX_CSUM_L3_SINGLE_TUNNEL |
>> +                           VIRTCHNL2_CAP_TX_CSUM_L4_SINGLE_TUNNEL |
>> +                           VIRTCHNL2_CAP_RX_CSUM_L4_SINGLE_TUNNEL |
>> +                           VIRTCHNL2_CAP_RX_CSUM_GENERIC);
>> +
>> +       caps.seg_caps =
>> +               cpu_to_le32(VIRTCHNL2_CAP_SEG_IPV4_TCP          |
>> +                           VIRTCHNL2_CAP_SEG_IPV4_UDP          |
>> +                           VIRTCHNL2_CAP_SEG_IPV4_SCTP         |
>> +                           VIRTCHNL2_CAP_SEG_IPV6_TCP          |
>> +                           VIRTCHNL2_CAP_SEG_IPV6_UDP          |
>> +                           VIRTCHNL2_CAP_SEG_IPV6_SCTP         |
>> +                           VIRTCHNL2_CAP_SEG_TX_SINGLE_TUNNEL);
>> +
>> +       caps.rss_caps =
>> +               cpu_to_le64(VIRTCHNL2_CAP_RSS_IPV4_TCP          |
>> +                           VIRTCHNL2_CAP_RSS_IPV4_UDP          |
>> +                           VIRTCHNL2_CAP_RSS_IPV4_SCTP         |
>> +                           VIRTCHNL2_CAP_RSS_IPV4_OTHER        |
>> +                           VIRTCHNL2_CAP_RSS_IPV6_TCP          |
>> +                           VIRTCHNL2_CAP_RSS_IPV6_UDP          |
>> +                           VIRTCHNL2_CAP_RSS_IPV6_SCTP         |
>> +                           VIRTCHNL2_CAP_RSS_IPV6_OTHER);
>> +
>> +       caps.hsplit_caps =
>> +               cpu_to_le32(VIRTCHNL2_CAP_RX_HSPLIT_AT_L4V4     |
>> +                           VIRTCHNL2_CAP_RX_HSPLIT_AT_L4V6);
>> +
>> +       caps.rsc_caps =
>> +               cpu_to_le32(VIRTCHNL2_CAP_RSC_IPV4_TCP          |
>> +                           VIRTCHNL2_CAP_RSC_IPV6_TCP);
>> +
>> +       caps.other_caps =
>> +               cpu_to_le64(VIRTCHNL2_CAP_SRIOV                 |
> 
> I think this routine is getting called for both PF and VF - does this 
> SRIOV capability make sense in the VF case?  Or does it simply get 
> filtered out by the CP's response and it doesn't matter?
> 
CP will filter it out.

<snip>

Thanks,
Emil
