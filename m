Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4030A6F2114
	for <lists+netdev@lfdr.de>; Sat, 29 Apr 2023 01:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbjD1XKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 19:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjD1XKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 19:10:20 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C30849D5
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 16:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682723416; x=1714259416;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=S50Ez9TJRXJgfYF+MnGvLgcYozDUwpnxxohRehX6OQs=;
  b=SMxJDv/N++RI4/pK/2ZEVfD6Yu3PcSY0hd+zTCoiOvVHwLdi3BIbj4Ac
   pFIDG2UfCC8r1LkU1HGOZCHN6ifY6XcoF358BuYh8CIzSmG4/bMg1nXkn
   uKmm6q5fk0WcDZBoSH9ujyYW/TgN3Afm7hlwMs5yydn75wsHRvLTr0bOF
   u2hMmwMg2qMtae7PiLWdd5RwdHRkAy+htLx4tq29ecWBwB5XFXSe7ZX3Z
   bVgzSMkHleuqH7KdnxY4oSF1jZC7wu9mzo7+9KMQqekTGgRvWAaraeC8n
   g5OQhRXxAbfLBQLbpK7X7N/kqQNgip6aJ3MiEr+PSdL/vY29PDOB2RONl
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10694"; a="336963590"
X-IronPort-AV: E=Sophos;i="5.99,235,1677571200"; 
   d="scan'208";a="336963590"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2023 16:10:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10694"; a="672366890"
X-IronPort-AV: E=Sophos;i="5.99,235,1677571200"; 
   d="scan'208";a="672366890"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP; 28 Apr 2023 16:10:14 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 28 Apr 2023 16:10:14 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 28 Apr 2023 16:10:14 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 28 Apr 2023 16:10:14 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.43) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 28 Apr 2023 16:10:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fe9OIRg+qmHeTyr++fDg1v0XvNmH5pHCfKeewICnveuWNXrlwdVS6uOOObVURbJZkjGSap9zJalve8Yvlvb6xXBrFh5zkpOJBeVm4LOIiRErT7rRP1PcNQp/+Wlery9QVQ64cEKDZ5Pk9e1UYsc8fft40/PlnPTEeVxaP1ICq7QArBhc+rc8N6e7nohelGrDmrBrjKqdSyf20M57adr42h3i8qu9W+pRbf2cuH4GPX2zz6goP1nK5CnkT53XvZaWk2YNxnV3mzqc/mrz+d0TXIbfHehIZg8GzhFVVEbKNGeT5M3B5YMCq3ZKPF4JbXb4z/W60a2M9w4bTAG1aU0wVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PpqSrt1A9pGSg6gtEPKSNPYUpci85OVl828Pe1na6es=;
 b=m7VLtbT1odiN7Y5m+bXwFq0fsXg4DRnXq9siV+qqDkiH53VrME8HOeTLTepPI3Clh6f7i7NYTNNpKCxpFkdHeHeZBfJrzLOuOqMMnNnW6otiuK1eAMRbrfOUbVLyf5mPmRVh/eNOBFObxESRY4+Ty8BRSE5dMZrvfHeIjHdxNoBsF43k5geOyrzuEcg/iRHYxKNCCERUdD6Wxp3PimP4SyPnFYxZCnuSvKsse5HuhH4ivuy+2zjA//56TNOBqkCc8Do6faX0842EDnGsLxoB55VUkdXHYEIN6Qpp9W4cWBqJw3EMhvRc4qYyLAYeDZrOXaBp0wEZCanxHDDw5XVnrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW3PR11MB4538.namprd11.prod.outlook.com (2603:10b6:303:57::12)
 by SJ0PR11MB5661.namprd11.prod.outlook.com (2603:10b6:a03:3b9::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.23; Fri, 28 Apr
 2023 23:10:10 +0000
Received: from MW3PR11MB4538.namprd11.prod.outlook.com
 ([fe80::aae6:d608:6b8d:977e]) by MW3PR11MB4538.namprd11.prod.outlook.com
 ([fe80::aae6:d608:6b8d:977e%7]) with mapi id 15.20.6340.021; Fri, 28 Apr 2023
 23:10:09 +0000
Message-ID: <cbea4872-d3a0-75fc-1a57-97e5c1ec41a7@intel.com>
Date:   Fri, 28 Apr 2023 16:10:06 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [net-next v3 01/15] virtchnl: add virtchnl version 2 ops
Content-Language: en-US
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
 <20230427020917.12029-2-emil.s.tantilov@intel.com>
 <fe8c70fd-b308-31e0-9c83-8ea191753a24@amd.com>
From:   "Tantilov, Emil S" <emil.s.tantilov@intel.com>
In-Reply-To: <fe8c70fd-b308-31e0-9c83-8ea191753a24@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY3PR04CA0029.namprd04.prod.outlook.com
 (2603:10b6:a03:217::34) To MW3PR11MB4538.namprd11.prod.outlook.com
 (2603:10b6:303:57::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR11MB4538:EE_|SJ0PR11MB5661:EE_
X-MS-Office365-Filtering-Correlation-Id: 126f8258-44c7-43e5-3b81-08db483db67f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AlMEWRjoMN7dE04Eycxn7ven6gufcCXw5ssYpRUzGh5byk7IuOQemmXo44bdmV7imlC3VHpJ/mjyrmHv1E0v2fsEkLUHauiIhfFBxgQnKb2TJICoRTU4lYIKEjrr57ac+bJC6nujUmE7WP14E6aTAwsX3uxap/203divyyhcnzVfoH3/y6R+sDLxFaPNpPpbIz02CXfy2iXFFLs1beOQKA9ijKaO5g9SPVqyhitvN74v9ZLLpZpemM1dP4yMOJUMCUV1LJjiQXAbk3fN1RnbteCrV2l87Rh1GhCOaLbNt9dIRYAh5UHhaSfwLiJdOOW4m/2iwXOAw80ZplBG5pXkta2Dy8z8VetBTVKK2J8z3h7VxbMLHxrkT9OyhZuJO5C0GnSBtH/UpUvzJpK53pLLoLgt5sP52M6dHY+jEo9vgDTgWEDwVn0LpmlrMKgijzJ4h8k8ABsJz4rXNz8ATemEQjGrd8he+0CQq2FepCqqTIfz44QFyWY18OJhWFNa+A87xMTOSqaMKGOf8hDgYzS1b0LXkRHQL3t8UXEqWBuI4swdojQxafUqmGLS+NtxFUT0vt2abFTKBJMgcxPCD6jTx5IrAmzwRPL6bzbjcucEI9n1vRYVCaInENuXt3q9pg0Z+i9Zy0GydHxNDwZ6NVwurw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4538.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(39860400002)(346002)(136003)(396003)(451199021)(86362001)(38100700002)(8936002)(8676002)(83380400001)(7416002)(36756003)(5660300002)(2616005)(31696002)(478600001)(31686004)(66556008)(6486002)(30864003)(6666004)(66476007)(66946007)(316002)(41300700001)(66899021)(186003)(4326008)(6506007)(26005)(2906002)(82960400001)(6512007)(53546011)(45980500001)(43740500002)(559001)(579004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MzR4WnNOMUZEU3E3Qnc3NXpxME9tTnpHL3ZKdFI4THUybCtTYmhGUmNmMWh3?=
 =?utf-8?B?Y2EyVzdydVdxd0JTRnZtc0E0S096ajNnV2R0TVlRL3NPVjZvSWs4US91VUJR?=
 =?utf-8?B?Ylp2Q0F6QVFablZVMlJJZlM4dlVuSjlLc3l2c01MajlsVVBxZ2NsWDVuSGMz?=
 =?utf-8?B?WDk5K0NzYkJlNDJPb1llOGZuYm4xS3VLOE91OG1wM2ppUGd0MjdXUGx0aS91?=
 =?utf-8?B?M3ZGOTNPOEQ5bHJMMlk0dDJwNmNIczlkWFNnWVh3bG9wZDRWeGNsclVFN3J1?=
 =?utf-8?B?aU1LR083QzZBSys1elJuTS9KQTRzNnJlNEdXNC9xRnNTeXNUYWl1NXl4anBt?=
 =?utf-8?B?TGNKaTdhcVVWRFVwR2NlS09ENmEvT1U0Ky85ekhJMm1aWllIa0pSMXQ1bHhK?=
 =?utf-8?B?a3hFYlFTRThOd05SMi9iKzZkZUpsSlFVdnJHd0xSN1RVem1WMlBRWUFIN3p0?=
 =?utf-8?B?OGt1dWp3eVMxbWxPUVpQaW5PRVB1OWtPQ1dXdzFsaDh6eTkrOTkwNjd6WTJh?=
 =?utf-8?B?VDVuRHo3dXYyNTArVnBKNGpwWGw1Y0xiOHE0eGpWSEN0bnhQbHlPcnc0YmVR?=
 =?utf-8?B?QXlianFQMlpVZ3FzLzNjb0FCR3Z5QURscGJYbHM3d05reWhyM0xHK1llRXdG?=
 =?utf-8?B?K0pWaVVEVjBzanUwb0huRmQ4MWRZdXA2TFAyRkVGMEwzOW1rVFpYTmdHcHpI?=
 =?utf-8?B?bit3MXJ6Ym5CRXRXTklHdGFrV0Nsalo0ZzRQcHJiTDIxWlVLMUN6eDJUK3Z0?=
 =?utf-8?B?ZWJqQmNsWXZHbmdtVHBqN0RDL2lzSmtXZGJKRlFhdlF5VE1Nb1hVYmEzRWRB?=
 =?utf-8?B?bDhKTFQvMWplNFM3Ty9aWmQyb2wrZVIrdGcvZGYwL1EwMmpjN2Y3dUgwWkxQ?=
 =?utf-8?B?MzFma3NBVy9CYW5xb2hJeklacDFEMG81MkloQTRZVVYrMUdNSWFTYjVZRG9W?=
 =?utf-8?B?cC9CR21SeUxTa21yNTR0cGJwTEtGOVRmN3ovLytJTHMwVzIzNmJDd2Z6MzFu?=
 =?utf-8?B?V0ozRWh2Sk5yY1pUU0lhbFhEUHRhRVMyNTYzTFZGZnFBKytyVUZPR3dGL1F6?=
 =?utf-8?B?MU5pQmVpQkc1a2hmOGRVc2JLVWZYVDNlME01TUQ4TmFabEsvaTIvbmxVWUkr?=
 =?utf-8?B?NERBR3BJQW9lOFVsOWJiVUNHcldtRmo5WXd2bHpyNjhHYWcxd1BHWUk4cm1p?=
 =?utf-8?B?UkxXSVRUZnErWW9saW4vWVBnYXNMWllEQVVXRnFsdjJCT0VWU3NnZlBPMGU1?=
 =?utf-8?B?bXVoNFZKcGdDUzkxdXR3NnpRSllzK2hxSzQwcVpOK1F6ZlNJVnF1Sit0ak4r?=
 =?utf-8?B?LzN4UVk4bWxuVnBpUUI3dHNiOU5XWldFUVJGbkZ3WU11SVlkeDE4NnJvaGNG?=
 =?utf-8?B?TkNMOUdVRDlpWGxiTmpzMklsYXprVGhtbEJGU1pWd21QSTV0eXFzVm1kb21t?=
 =?utf-8?B?OGd4NEhJZ1VXU1FWeXovMXAvcm9qdENJSHI1UHlRTVdUN3RBVyt2TUNBWGVz?=
 =?utf-8?B?cW9yaTFuWmhQK2ZUdGRzMDJkNzVuUW1uZzVpSlZ2YnJWQ0RyZFUrdlJOQWtY?=
 =?utf-8?B?ajRBaDVuVnY3ZllVV0NiSG5sSEpiUFNRZ3hEaDZhMzY0V0VUWEY2SVJWZUdH?=
 =?utf-8?B?eHRDd1JhRWFkWTg2dVpDWmhRRktidVc3Z3FzUW5JQVcvdjY0dnZzdHNwYk9s?=
 =?utf-8?B?d0hhR0xTWVpWaEtHQlNSRXZ4Wk0yNkxTN2V1RjZOODd3MmczOXVhK3NOdVlG?=
 =?utf-8?B?R016ZWhiK2VFRzlrRkt2THhvYm9oUjRCZHhKbHVjQ0lXUWhPbHhUSHZiRHFs?=
 =?utf-8?B?eEtHNHZ4djRyYmRMbGhPY3lSVUhkZ1JQTkw0UWV5WU53Wkg5Uk13bTA5ajQ0?=
 =?utf-8?B?aDNwcDFxTmZUeitZQ1E3a3ZWMTh6T2xjWGQ1eEhOeDZtRkJzdm9jbFRPN0tp?=
 =?utf-8?B?ZlZ0cDhPcEJucldtNEV4RDVJYkJ2b3RVZjVXQ05MeENud1lQZXY1QkhaQW4y?=
 =?utf-8?B?cFFJMVZ5ZGJkODdjRnkrZWtCYVprZHAyYXpET3RUeStJdnVmckUrUWZGSHlX?=
 =?utf-8?B?UUtvVXpmT3BFWGVEZUZ4VEdqU3JNRmlLQTgzYWEwZUYwZUpGSVhZTHNibzQw?=
 =?utf-8?B?MFJOTmo0NFZ3RC8rQUxuQ0ZYVVdjU1l5cEhMNGZaTUdoOWxYNDhQNFA3V2oz?=
 =?utf-8?B?ZVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 126f8258-44c7-43e5-3b81-08db483db67f
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4538.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2023 23:10:09.7377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cKLFgBw4Vsqsol8kooxvgBAaGZIShDHIdXnPKMFFQpYR9vbfjSR6COJtEPiBnxNHsSwD/32kq/+ikvdOA05tqu176Rx60IYBGu5eweMiSC8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5661
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/27/2023 3:04 PM, Shannon Nelson wrote:
> On 4/26/23 7:09 PM, Emil Tantilov wrote:
>> From: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
>>
>> Virtchnl version 1 is an interface used by the current generation of
>> foundational NICs to negotiate the capabilities and configure the
>> HW resources such as queues, vectors, RSS LUT, etc between the PF
>> and VF drivers. It is not extensible to enable new features supported
>> in the next generation of NICs/IPUs and to negotiate descriptor types,
>> packet types and register offsets.
>>
>> To overcome the limitations of the existing interface, introduce
>> the virtchnl version 2 and add the necessary opcodes, structures,
>> definitions, and descriptor formats. The driver also learns the
>> data queue and other register offsets to use instead of hardcoding
>> them. The advantage of this approach is that it gives the flexibility
>> to modify the register offsets if needed, restrict the use of
>> certain descriptor types and negotiate the supported packet types.
>>
>> Co-developed-by: Alan Brady <alan.brady@intel.com>
>> Signed-off-by: Alan Brady <alan.brady@intel.com>
>> Co-developed-by: Joshua Hay <joshua.a.hay@intel.com>
>> Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
>> Co-developed-by: Madhu Chittim <madhu.chittim@intel.com>
>> Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
>> Co-developed-by: Phani Burra <phani.r.burra@intel.com>
>> Signed-off-by: Phani Burra <phani.r.burra@intel.com>
>> Co-developed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
>> Signed-off-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
>> Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
>> Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
>> Reviewed-by: Willem de Bruijn <willemb@google.com>
>> ---
>>   drivers/net/ethernet/intel/idpf/virtchnl2.h   | 1317 +++++++++++++++++
>>   .../ethernet/intel/idpf/virtchnl2_lan_desc.h  |  448 ++++++
>>   2 files changed, 1765 insertions(+)
>>   create mode 100644 drivers/net/ethernet/intel/idpf/virtchnl2.h
>>   create mode 100644 drivers/net/ethernet/intel/idpf/virtchnl2_lan_desc.h
>>
>> diff --git a/drivers/net/ethernet/intel/idpf/virtchnl2.h 
>> b/drivers/net/ethernet/intel/idpf/virtchnl2.h
>> new file mode 100644
>> index 000000000000..3a63c5136e83
>> --- /dev/null
>> +++ b/drivers/net/ethernet/intel/idpf/virtchnl2.h
>> @@ -0,0 +1,1317 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/* Copyright (C) 2023 Intel Corporation */
>> +
>> +#ifndef _VIRTCHNL2_H_
>> +#define _VIRTCHNL2_H_
>> +
>> +/* All opcodes associated with virtchnl 2 are prefixed with virtchnl2 or
>> + * VIRTCHNL2. Any future opcodes, offloads/capabilities, structures,
>> + * and defines must be prefixed with virtchnl2 or VIRTCHNL2 to avoid 
>> confusion.
>> + *
>> + * PF/VF uses the virtchnl interface defined in this header file to 
>> communicate
> 
> virtchnl2
> 
>> + * with device Control Plane (CP). Driver and the CP may run on 
>> different
>> + * platforms with different endianness. To avoid byte order 
>> discrepancies,
>> + * struct members in this header follow little-endian format. Users 
>> of this
>> + * virtchnl interface are expected to convert back to their native 
>> endian
> 
> virtchnl2
> 

OK, we'll rename it.

>> + * format.
>> + *
>> + * This is an interface definition file where existing enums and 
>> their values
>> + * must remain unchanged over time, so we specify explicit values for 
>> all enums.
>> + */
>> +
>> +#include "virtchnl2_lan_desc.h"
>> +
>> +/**
>> + * enum virtchnl2_status - Error codes.
>> + * @VIRTCHNL2_STATUS_SUCCESS: success
>> + * @VIRTCHNL2_STATUS_ERR_EPERM: Operation not permitted, used in case 
>> of command
>> + *                             not permitted for sender.
>> + * @VIRTCHNL2_STATUS_ERR_ESRCH: Bad opcode - virtchnl interface problem.
>> + * @VIRTCHNL2_STATUS_ERR_EIO: I/O error - HW access error.
>> + * @VIRTCHNL2_STATUS_ERR_ENXIO: No such resource - Referenced 
>> resource is not
>> + *                             allocated.
>> + * @VIRTCHNL2_STATUS_ERR_EACCES: Permission denied - Resource is not 
>> permitted
>> + *                             to caller.
>> + * @VIRTCHNL2_STATUS_ERR_EBUSY: Device or resource busy - In case shared
>> + *                             resource is in use by others.
>> + * @VIRTCHNL2_STATUS_ERR_EEXIST: Object already exists and not free.
>> + * @VIRTCHNL2_STATUS_ERR_EINVAL: Invalid input argument in command.
>> + * @VIRTCHNL2_STATUS_ERR_ENOSPC: No space left or allocation failure.
>> + * @VIRTCHNL2_STATUS_ERR_ERANGE: Parameter out of range.
>> + * @VIRTCHNL2_STATUS_ERR_EMODE: Operation not allowed in current dev 
>> mode.
>> + * @VIRTCHNL2_STATUS_ERR_ESM: State Machine error - Command sequence 
>> problem.
>> + */
>> +enum virtchnl2_status {
>> +       VIRTCHNL2_STATUS_SUCCESS                = 0,
>> +       VIRTCHNL2_STATUS_ERR_EPERM              = 1,
>> +       VIRTCHNL2_STATUS_ERR_ESRCH              = 3,
>> +       VIRTCHNL2_STATUS_ERR_EIO                = 5,
>> +       VIRTCHNL2_STATUS_ERR_ENXIO              = 6,
>> +       VIRTCHNL2_STATUS_ERR_EACCES             = 13,
>> +       VIRTCHNL2_STATUS_ERR_EBUSY              = 16,
>> +       VIRTCHNL2_STATUS_ERR_EEXIST             = 17,
>> +       VIRTCHNL2_STATUS_ERR_EINVAL             = 22,
>> +       VIRTCHNL2_STATUS_ERR_ENOSPC             = 28,
>> +       VIRTCHNL2_STATUS_ERR_ERANGE             = 34,
> 
> If these are going to be the same values as what's in errno.h, there's 
> no reason to create new names, just use the errno.h definitions.
> 
>> +       VIRTCHNL2_STATUS_ERR_EMODE              = 200,
>> +       VIRTCHNL2_STATUS_ERR_ESM                = 201,
> 
> I imagine you can find existing errno values for these as well, perhaps 
> like EBADE or EBADFD.
> 

Right, we should be able to use the errno equivalents.

>> +};
>> +/* This macro is used to generate compilation errors if a structure
>> + * is not exactly the correct length.
>> + */
>> +#define VIRTCHNL2_CHECK_STRUCT_LEN(n, X)       \
>> +       static_assert((n) == sizeof(struct X))
>> +
>> +/* New major set of opcodes introduced and so leaving room for
>> + * old misc opcodes to be added in future. Also these opcodes may only
>> + * be used if both the PF and VF have successfully negotiated the
>> + * VIRTCHNL version as 2.0 during VIRTCHNL2_OP_VERSION exchange.
>> + */
>> +enum virtchnl2_op {
>> +       VIRTCHNL2_OP_UNKNOWN                    = 0,
>> +       VIRTCHNL2_OP_VERSION                    = 1,
>> +       VIRTCHNL2_OP_GET_CAPS                   = 500,
>> +       VIRTCHNL2_OP_CREATE_VPORT               = 501,
>> +       VIRTCHNL2_OP_DESTROY_VPORT              = 502,
>> +       VIRTCHNL2_OP_ENABLE_VPORT               = 503,
>> +       VIRTCHNL2_OP_DISABLE_VPORT              = 504,
>> +       VIRTCHNL2_OP_CONFIG_TX_QUEUES           = 505,
>> +       VIRTCHNL2_OP_CONFIG_RX_QUEUES           = 506,
>> +       VIRTCHNL2_OP_ENABLE_QUEUES              = 507,
>> +       VIRTCHNL2_OP_DISABLE_QUEUES             = 508,
>> +       VIRTCHNL2_OP_ADD_QUEUES                 = 509,
>> +       VIRTCHNL2_OP_DEL_QUEUES                 = 510,
>> +       VIRTCHNL2_OP_MAP_QUEUE_VECTOR           = 511,
>> +       VIRTCHNL2_OP_UNMAP_QUEUE_VECTOR         = 512,
>> +       VIRTCHNL2_OP_GET_RSS_KEY                = 513,
>> +       VIRTCHNL2_OP_SET_RSS_KEY                = 514,
>> +       VIRTCHNL2_OP_GET_RSS_LUT                = 515,
>> +       VIRTCHNL2_OP_SET_RSS_LUT                = 516,
>> +       VIRTCHNL2_OP_GET_RSS_HASH               = 517,
>> +       VIRTCHNL2_OP_SET_RSS_HASH               = 518,
>> +       VIRTCHNL2_OP_SET_SRIOV_VFS              = 519,
>> +       VIRTCHNL2_OP_ALLOC_VECTORS              = 520,
>> +       VIRTCHNL2_OP_DEALLOC_VECTORS            = 521,
>> +       VIRTCHNL2_OP_EVENT                      = 522,
>> +       VIRTCHNL2_OP_GET_STATS                  = 523,
>> +       VIRTCHNL2_OP_RESET_VF                   = 524,
>> +       VIRTCHNL2_OP_GET_EDT_CAPS               = 525,
>> +       VIRTCHNL2_OP_GET_PTYPE_INFO             = 526,
>> +       /* Opcode 527 and 528 are reserved for 
>> VIRTCHNL2_OP_GET_PTYPE_ID and
>> +        * VIRTCHNL2_OP_GET_PTYPE_INFO_RAW.
>> +        * Opcodes 529, 530, 531, 532 and 533 are reserved.
>> +        */
>> +       VIRTCHNL2_OP_LOOPBACK                   = 534,
>> +       VIRTCHNL2_OP_ADD_MAC_ADDR               = 535,
>> +       VIRTCHNL2_OP_DEL_MAC_ADDR               = 536,
>> +       VIRTCHNL2_OP_CONFIG_PROMISCUOUS_MODE    = 537,
>> +};
>> +
>> +/**
>> + * enum virtchnl2_vport_type - Type of virtual port.
>> + * @VIRTCHNL2_VPORT_TYPE_DEFAULT: Default virtual port type.
>> + */
>> +enum virtchnl2_vport_type {
>> +       VIRTCHNL2_VPORT_TYPE_DEFAULT            = 0,
>> +};
>> +
>> +/**
>> + * enum virtchnl2_queue_model - Type of queue model.
>> + * @VIRTCHNL2_QUEUE_MODEL_SINGLE: Single queue model.
>> + * @VIRTCHNL2_QUEUE_MODEL_SPLIT: Split queue model.
>> + *
>> + * In the single queue model, the same transmit descriptor queue is 
>> used by
>> + * software to post descriptors to hardware and by hardware to post 
>> completed
>> + * descriptors to software.
>> + * Likewise, the same receive descriptor queue is used by hardware to 
>> post
>> + * completions to software and by software to post buffers to hardware.
>> + *
>> + * In the split queue model, hardware uses transmit completion queues 
>> to post
>> + * descriptor/buffer completions to software, while software uses 
>> transmit
>> + * descriptor queues to post descriptors to hardware.
>> + * Likewise, hardware posts descriptor completions to the receive 
>> descriptor
>> + * queue, while software uses receive buffer queues to post buffers 
>> to hardware.
>> + */
>> +enum virtchnl2_queue_model {
>> +       VIRTCHNL2_QUEUE_MODEL_SINGLE            = 0,
>> +       VIRTCHNL2_QUEUE_MODEL_SPLIT             = 1,
>> +};
>> +
>> +/* Checksum offload capability flags */
>> +enum virtchnl2_cap_txrx_csum {
>> +       VIRTCHNL2_CAP_TX_CSUM_L3_IPV4           = BIT(0),
>> +       VIRTCHNL2_CAP_TX_CSUM_L4_IPV4_TCP       = BIT(1),
>> +       VIRTCHNL2_CAP_TX_CSUM_L4_IPV4_UDP       = BIT(2),
>> +       VIRTCHNL2_CAP_TX_CSUM_L4_IPV4_SCTP      = BIT(3),
>> +       VIRTCHNL2_CAP_TX_CSUM_L4_IPV6_TCP       = BIT(4),
>> +       VIRTCHNL2_CAP_TX_CSUM_L4_IPV6_UDP       = BIT(5),
>> +       VIRTCHNL2_CAP_TX_CSUM_L4_IPV6_SCTP      = BIT(6),
>> +       VIRTCHNL2_CAP_TX_CSUM_GENERIC           = BIT(7),
>> +       VIRTCHNL2_CAP_RX_CSUM_L3_IPV4           = BIT(8),
>> +       VIRTCHNL2_CAP_RX_CSUM_L4_IPV4_TCP       = BIT(9),
>> +       VIRTCHNL2_CAP_RX_CSUM_L4_IPV4_UDP       = BIT(10),
>> +       VIRTCHNL2_CAP_RX_CSUM_L4_IPV4_SCTP      = BIT(11),
>> +       VIRTCHNL2_CAP_RX_CSUM_L4_IPV6_TCP       = BIT(12),
>> +       VIRTCHNL2_CAP_RX_CSUM_L4_IPV6_UDP       = BIT(13),
>> +       VIRTCHNL2_CAP_RX_CSUM_L4_IPV6_SCTP      = BIT(14),
>> +       VIRTCHNL2_CAP_RX_CSUM_GENERIC           = BIT(15),
>> +       VIRTCHNL2_CAP_TX_CSUM_L3_SINGLE_TUNNEL  = BIT(16),
>> +       VIRTCHNL2_CAP_TX_CSUM_L3_DOUBLE_TUNNEL  = BIT(17),
>> +       VIRTCHNL2_CAP_RX_CSUM_L3_SINGLE_TUNNEL  = BIT(18),
>> +       VIRTCHNL2_CAP_RX_CSUM_L3_DOUBLE_TUNNEL  = BIT(19),
>> +       VIRTCHNL2_CAP_TX_CSUM_L4_SINGLE_TUNNEL  = BIT(20),
>> +       VIRTCHNL2_CAP_TX_CSUM_L4_DOUBLE_TUNNEL  = BIT(21),
>> +       VIRTCHNL2_CAP_RX_CSUM_L4_SINGLE_TUNNEL  = BIT(22),
>> +       VIRTCHNL2_CAP_RX_CSUM_L4_DOUBLE_TUNNEL  = BIT(23),
>> +};
>> +
>> +/* Segmentation offload capability flags */
>> +enum virtchnl2_cap_seg {
>> +       VIRTCHNL2_CAP_SEG_IPV4_TCP              = BIT(0),
>> +       VIRTCHNL2_CAP_SEG_IPV4_UDP              = BIT(1),
>> +       VIRTCHNL2_CAP_SEG_IPV4_SCTP             = BIT(2),
>> +       VIRTCHNL2_CAP_SEG_IPV6_TCP              = BIT(3),
>> +       VIRTCHNL2_CAP_SEG_IPV6_UDP              = BIT(4),
>> +       VIRTCHNL2_CAP_SEG_IPV6_SCTP             = BIT(5),
>> +       VIRTCHNL2_CAP_SEG_GENERIC               = BIT(6),
>> +       VIRTCHNL2_CAP_SEG_TX_SINGLE_TUNNEL      = BIT(7),
>> +       VIRTCHNL2_CAP_SEG_TX_DOUBLE_TUNNEL      = BIT(8),
>> +};
>> +
>> +/* Receive Side Scaling Flow type capability flags */
>> +enum virtcnl2_cap_rss {
>> +       VIRTCHNL2_CAP_RSS_IPV4_TCP              = BIT(0),
>> +       VIRTCHNL2_CAP_RSS_IPV4_UDP              = BIT(1),
>> +       VIRTCHNL2_CAP_RSS_IPV4_SCTP             = BIT(2),
>> +       VIRTCHNL2_CAP_RSS_IPV4_OTHER            = BIT(3),
>> +       VIRTCHNL2_CAP_RSS_IPV6_TCP              = BIT(4),
>> +       VIRTCHNL2_CAP_RSS_IPV6_UDP              = BIT(5),
>> +       VIRTCHNL2_CAP_RSS_IPV6_SCTP             = BIT(6),
>> +       VIRTCHNL2_CAP_RSS_IPV6_OTHER            = BIT(7),
>> +       VIRTCHNL2_CAP_RSS_IPV4_AH               = BIT(8),
>> +       VIRTCHNL2_CAP_RSS_IPV4_ESP              = BIT(9),
>> +       VIRTCHNL2_CAP_RSS_IPV4_AH_ESP           = BIT(10),
>> +       VIRTCHNL2_CAP_RSS_IPV6_AH               = BIT(11),
>> +       VIRTCHNL2_CAP_RSS_IPV6_ESP              = BIT(12),
>> +       VIRTCHNL2_CAP_RSS_IPV6_AH_ESP           = BIT(13),
>> +};
>> +
>> +/* Header split capability flags */
>> +enum virtchnl2_cap_rx_hsplit_at {
>> +       /* for prepended metadata  */
>> +       VIRTCHNL2_CAP_RX_HSPLIT_AT_L2           = BIT(0),
>> +       /* all VLANs go into header buffer */
>> +       VIRTCHNL2_CAP_RX_HSPLIT_AT_L3           = BIT(1),
>> +       VIRTCHNL2_CAP_RX_HSPLIT_AT_L4V4         = BIT(2),
>> +       VIRTCHNL2_CAP_RX_HSPLIT_AT_L4V6         = BIT(3),
>> +};
>> +
>> +/* Receive Side Coalescing offload capability flags */
>> +enum virtchnl2_cap_rsc {
>> +       VIRTCHNL2_CAP_RSC_IPV4_TCP              = BIT(0),
>> +       VIRTCHNL2_CAP_RSC_IPV4_SCTP             = BIT(1),
>> +       VIRTCHNL2_CAP_RSC_IPV6_TCP              = BIT(2),
>> +       VIRTCHNL2_CAP_RSC_IPV6_SCTP             = BIT(3),
>> +};
>> +
>> +/* Other capability flags */
>> +enum virtchnl2_cap_other {
>> +       VIRTCHNL2_CAP_RDMA                      = BIT_ULL(0),
>> +       VIRTCHNL2_CAP_SRIOV                     = BIT_ULL(1),
>> +       VIRTCHNL2_CAP_MACFILTER                 = BIT_ULL(2),
>> +       VIRTCHNL2_CAP_FLOW_DIRECTOR             = BIT_ULL(3),
>> +       /* Queue based scheduling using split queue model */
>> +       VIRTCHNL2_CAP_SPLITQ_QSCHED             = BIT_ULL(4),
>> +       VIRTCHNL2_CAP_CRC                       = BIT_ULL(5),
>> +       VIRTCHNL2_CAP_ADQ                       = BIT_ULL(6),
>> +       VIRTCHNL2_CAP_WB_ON_ITR                 = BIT_ULL(7),
>> +       VIRTCHNL2_CAP_PROMISC                   = BIT_ULL(8),
>> +       VIRTCHNL2_CAP_LINK_SPEED                = BIT_ULL(9),
>> +       VIRTCHNL2_CAP_INLINE_IPSEC              = BIT_ULL(10),
>> +       VIRTCHNL2_CAP_LARGE_NUM_QUEUES          = BIT_ULL(11),
>> +       VIRTCHNL2_CAP_VLAN                      = BIT_ULL(12),
>> +       VIRTCHNL2_CAP_PTP                       = BIT_ULL(13),
>> +       /* EDT: Earliest Departure Time capability used for Timing 
>> Wheel */
>> +       VIRTCHNL2_CAP_EDT                       = BIT_ULL(14),
>> +       VIRTCHNL2_CAP_ADV_RSS                   = BIT_ULL(15),
>> +       VIRTCHNL2_CAP_FDIR                      = BIT_ULL(16),
>> +       VIRTCHNL2_CAP_RX_FLEX_DESC              = BIT_ULL(17),
>> +       VIRTCHNL2_CAP_PTYPE                     = BIT_ULL(18),
>> +       VIRTCHNL2_CAP_LOOPBACK                  = BIT_ULL(19),
>> +       /* Enable miss completion types plus ability to detect a miss 
>> completion if a
>> +        * reserved bit is set in a standared completion's tag.
>> +        */
>> +       VIRTCHNL2_CAP_MISS_COMPL_TAG            = BIT_ULL(20),
>> +       /* this must be the last capability */
>> +       VIRTCHNL2_CAP_OEM                       = BIT_ULL(63),
>> +};
>> +
>> +/* underlying device type */
>> +enum virtchl2_device_type {
>> +       VIRTCHNL2_MEV_DEVICE                    = 0,
>> +};
>> +
>> +/**
>> + * enum virtcnl2_txq_sched_mode - Transmit Queue Scheduling Modes.
>> + * @VIRTCHNL2_TXQ_SCHED_MODE_QUEUE: Queue mode is the legacy mode 
>> i.e. inorder
>> + *                                 completions where descriptors and 
>> buffers
>> + *                                 are completed at the same time.
>> + * @VIRTCHNL2_TXQ_SCHED_MODE_FLOW: Flow scheduling mode allows for 
>> out of order
>> + *                                packet processing where descriptors 
>> are
>> + *                                cleaned in order, but buffers can be
>> + *                                completed out of order.
>> + */
>> +enum virtcnl2_txq_sched_mode {
>> +       VIRTCHNL2_TXQ_SCHED_MODE_QUEUE          = 0,
>> +       VIRTCHNL2_TXQ_SCHED_MODE_FLOW           = 1,
>> +};
>> +
>> +/**
>> + * enum virtchnl2_txq_flags - Tx Queue feature flags.
>> + * @VIRTCHNL2_TXQ_ENABLE_MISS_COMPL: Enable rule miss completion 
>> type. Packet
>> + *                                  completion for a packet sent on 
>> exception
>> + *                                  path. Only relevant in flow 
>> scheduling mode.
>> + */
>> +enum virtchnl2_txq_flags {
>> +       VIRTCHNL2_TXQ_ENABLE_MISS_COMPL         = BIT(0),
>> +};
>> +
>> +/**
>> + * enum virtchnl2_rxq_flags - Receive Queue Feature flags.
>> + * @VIRTCHNL2_RXQ_RSC: Rx queue RSC flag.
>> + * @VIRTCHNL2_RXQ_HDR_SPLIT: Rx queue header split flag.
>> + * @VIRTCHNL2_RXQ_IMMEDIATE_WRITE_BACK: When set, packet descriptors 
>> are flushed
>> + *                                     by hardware immediately after 
>> processing
>> + *                                     each packet.
>> + * @VIRTCHNL2_RX_DESC_SIZE_16BYTE: Rx queue 16 byte descriptor size.
>> + * @VIRTCHNL2_RX_DESC_SIZE_32BYTE: Rx queue 32 byte descriptor size.
>> + */
>> +enum virtchnl2_rxq_flags {
>> +       VIRTCHNL2_RXQ_RSC                       = BIT(0),
>> +       VIRTCHNL2_RXQ_HDR_SPLIT                 = BIT(1),
>> +       VIRTCHNL2_RXQ_IMMEDIATE_WRITE_BACK      = BIT(2),
>> +       VIRTCHNL2_RX_DESC_SIZE_16BYTE           = BIT(3),
>> +       VIRTCHNL2_RX_DESC_SIZE_32BYTE           = BIT(4),
>> +};
>> +
>> +/* Type of RSS algorithm */
>> +enum virtcnl2_rss_alg {
>> +       VIRTCHNL2_RSS_ALG_TOEPLITZ_ASYMMETRIC   = 0,
>> +       VIRTCHNL2_RSS_ALG_R_ASYMMETRIC          = 1,
>> +       VIRTCHNL2_RSS_ALG_TOEPLITZ_SYMMETRIC    = 2,
>> +       VIRTCHNL2_RSS_ALG_XOR_SYMMETRIC         = 3,
>> +};
>> +
>> +/* Type of event */
>> +enum virtchnl2_event_codes {
>> +       VIRTCHNL2_EVENT_UNKNOWN                 = 0,
>> +       VIRTCHNL2_EVENT_LINK_CHANGE             = 1,
>> +       /* Event type 2, 3 are reserved */
>> +};
>> +
>> +/* Transmit and Receive queue types are valid in legacy as well as 
>> split queue
>> + * models. With Split Queue model, 2 additional types are introduced -
>> + * TX_COMPLETION and RX_BUFFER. In split queue model, receive  
>> corresponds to
>> + * the queue where hardware posts completions.
>> + */
>> +enum virtchnl2_queue_type {
>> +       VIRTCHNL2_QUEUE_TYPE_TX                 = 0,
>> +       VIRTCHNL2_QUEUE_TYPE_RX                 = 1,
>> +       VIRTCHNL2_QUEUE_TYPE_TX_COMPLETION      = 2,
>> +       VIRTCHNL2_QUEUE_TYPE_RX_BUFFER          = 3,
>> +       VIRTCHNL2_QUEUE_TYPE_CONFIG_TX          = 4,
>> +       VIRTCHNL2_QUEUE_TYPE_CONFIG_RX          = 5,
>> +       /* Queue types 6, 7, 8, 9 are reserved */
>> +       VIRTCHNL2_QUEUE_TYPE_MBX_TX             = 10,
>> +       VIRTCHNL2_QUEUE_TYPE_MBX_RX             = 11,
>> +};
>> +
>> +/* Interrupt throttling rate index */
>> +enum virtchnl2_itr_idx {
>> +       VIRTCHNL2_ITR_IDX_0                     = 0,
>> +       VIRTCHNL2_ITR_IDX_1                     = 1,
>> +};
>> +
>> +/**
>> + * enum virtchnl2_mac_addr_type - MAC address types.
>> + * @VIRTCHNL2_MAC_ADDR_PRIMARY: PF/VF driver should set this type for 
>> the
>> + *                             primary/device unicast MAC address 
>> filter for
>> + *                             VIRTCHNL2_OP_ADD_MAC_ADDR and 
>> VIRTCHNL2_OP_DEL_MAC_ADDR.
>> + *                             This allows for the underlying control 
>> plane
>> + *                             function to accurately track the MAC 
>> address and for
>> + *                             VM/function reset.
>> + *
>> + * @VIRTCHNL2_MAC_ADDR_EXTRA: PF/VF driver should set this type for 
>> any extra unicast
>> + *                           and/or multicast filters that are being 
>> added/deleted via
>> + *                           VIRTCHNL2_OP_ADD_MAC_ADDR or 
>> VIRTCHNL2_OP_DEL_MAC_ADDR.
>> + */
>> +enum virtchnl2_mac_addr_type {
>> +       VIRTCHNL2_MAC_ADDR_PRIMARY              = 1,
>> +       VIRTCHNL2_MAC_ADDR_EXTRA                = 2,
>> +};
>> +
>> +/* Flags used for promiscuous mode */
>> +enum virtchnl2_promisc_flags {
>> +       VIRTCHNL2_UNICAST_PROMISC               = BIT(0),
>> +       VIRTCHNL2_MULTICAST_PROMISC             = BIT(1),
>> +};
>> +
>> +/* Protocol header type within a packet segment. A segment consists 
>> of one or
>> + * more protocol headers that make up a logical group of protocol 
>> headers. Each
>> + * logical group of protocol headers encapsulates or is encapsulated 
>> using/by
>> + * tunneling or encapsulation protocols for network virtualization.
>> + */
>> +enum virtchnl2_proto_hdr_type {
>> +       /* VIRTCHNL2_PROTO_HDR_ANY is a mandatory protocol id */
>> +       VIRTCHNL2_PROTO_HDR_ANY                 = 0,
>> +       VIRTCHNL2_PROTO_HDR_PRE_MAC             = 1,
>> +       /* VIRTCHNL2_PROTO_HDR_MAC is a mandatory protocol id */
>> +       VIRTCHNL2_PROTO_HDR_MAC                 = 2,
>> +       VIRTCHNL2_PROTO_HDR_POST_MAC            = 3,
>> +       VIRTCHNL2_PROTO_HDR_ETHERTYPE           = 4,
>> +       VIRTCHNL2_PROTO_HDR_VLAN                = 5,
>> +       VIRTCHNL2_PROTO_HDR_SVLAN               = 6,
>> +       VIRTCHNL2_PROTO_HDR_CVLAN               = 7,
>> +       VIRTCHNL2_PROTO_HDR_MPLS                = 8,
>> +       VIRTCHNL2_PROTO_HDR_UMPLS               = 9,
>> +       VIRTCHNL2_PROTO_HDR_MMPLS               = 10,
>> +       VIRTCHNL2_PROTO_HDR_PTP                 = 11,
>> +       VIRTCHNL2_PROTO_HDR_CTRL                = 12,
>> +       VIRTCHNL2_PROTO_HDR_LLDP                = 13,
>> +       VIRTCHNL2_PROTO_HDR_ARP                 = 14,
>> +       VIRTCHNL2_PROTO_HDR_ECP                 = 15,
>> +       VIRTCHNL2_PROTO_HDR_EAPOL               = 16,
>> +       VIRTCHNL2_PROTO_HDR_PPPOD               = 17,
>> +       VIRTCHNL2_PROTO_HDR_PPPOE               = 18,
>> +       /* VIRTCHNL2_PROTO_HDR_IPV4 is a mandatory protocol id */
>> +       VIRTCHNL2_PROTO_HDR_IPV4                = 19,
>> +       /* IPv4 and IPv6 Fragment header types are only associated to
>> +        * VIRTCHNL2_PROTO_HDR_IPV4 and VIRTCHNL2_PROTO_HDR_IPV6 
>> respectively,
>> +        * cannot be used independently.
>> +        */
>> +       /* VIRTCHNL2_PROTO_HDR_IPV4_FRAG is a mandatory protocol id */
>> +       VIRTCHNL2_PROTO_HDR_IPV4_FRAG           = 20,
>> +       /* VIRTCHNL2_PROTO_HDR_IPV6 is a mandatory protocol id */
>> +       VIRTCHNL2_PROTO_HDR_IPV6                = 21,
>> +       /* VIRTCHNL2_PROTO_HDR_IPV6_FRAG is a mandatory protocol id */
>> +       VIRTCHNL2_PROTO_HDR_IPV6_FRAG           = 22,
>> +       VIRTCHNL2_PROTO_HDR_IPV6_EH             = 23,
>> +       /* VIRTCHNL2_PROTO_HDR_UDP is a mandatory protocol id */
>> +       VIRTCHNL2_PROTO_HDR_UDP                 = 24,
>> +       /* VIRTCHNL2_PROTO_HDR_TCP is a mandatory protocol id */
>> +       VIRTCHNL2_PROTO_HDR_TCP                 = 25,
>> +       /* VIRTCHNL2_PROTO_HDR_SCTP is a mandatory protocol id */
>> +       VIRTCHNL2_PROTO_HDR_SCTP                = 26,
>> +       /* VIRTCHNL2_PROTO_HDR_ICMP is a mandatory protocol id */
>> +       VIRTCHNL2_PROTO_HDR_ICMP                = 27,
>> +       /* VIRTCHNL2_PROTO_HDR_ICMPV6 is a mandatory protocol id */
>> +       VIRTCHNL2_PROTO_HDR_ICMPV6              = 28,
>> +       VIRTCHNL2_PROTO_HDR_IGMP                = 29,
>> +       VIRTCHNL2_PROTO_HDR_AH                  = 30,
>> +       VIRTCHNL2_PROTO_HDR_ESP                 = 31,
>> +       VIRTCHNL2_PROTO_HDR_IKE                 = 32,
>> +       VIRTCHNL2_PROTO_HDR_NATT_KEEP           = 33,
>> +       /* VIRTCHNL2_PROTO_HDR_PAY is a mandatory protocol id */
>> +       VIRTCHNL2_PROTO_HDR_PAY                 = 34,
>> +       VIRTCHNL2_PROTO_HDR_L2TPV2              = 35,
>> +       VIRTCHNL2_PROTO_HDR_L2TPV2_CONTROL      = 36,
>> +       VIRTCHNL2_PROTO_HDR_L2TPV3              = 37,
>> +       VIRTCHNL2_PROTO_HDR_GTP                 = 38,
>> +       VIRTCHNL2_PROTO_HDR_GTP_EH              = 39,
>> +       VIRTCHNL2_PROTO_HDR_GTPCV2              = 40,
>> +       VIRTCHNL2_PROTO_HDR_GTPC_TEID           = 41,
>> +       VIRTCHNL2_PROTO_HDR_GTPU                = 42,
>> +       VIRTCHNL2_PROTO_HDR_GTPU_UL             = 43,
>> +       VIRTCHNL2_PROTO_HDR_GTPU_DL             = 44,
>> +       VIRTCHNL2_PROTO_HDR_ECPRI               = 45,
>> +       VIRTCHNL2_PROTO_HDR_VRRP                = 46,
>> +       VIRTCHNL2_PROTO_HDR_OSPF                = 47,
>> +       /* VIRTCHNL2_PROTO_HDR_TUN is a mandatory protocol id */
>> +       VIRTCHNL2_PROTO_HDR_TUN                 = 48,
>> +       VIRTCHNL2_PROTO_HDR_GRE                 = 49,
>> +       VIRTCHNL2_PROTO_HDR_NVGRE               = 50,
>> +       VIRTCHNL2_PROTO_HDR_VXLAN               = 51,
>> +       VIRTCHNL2_PROTO_HDR_VXLAN_GPE           = 52,
>> +       VIRTCHNL2_PROTO_HDR_GENEVE              = 53,
>> +       VIRTCHNL2_PROTO_HDR_NSH                 = 54,
>> +       VIRTCHNL2_PROTO_HDR_QUIC                = 55,
>> +       VIRTCHNL2_PROTO_HDR_PFCP                = 56,
>> +       VIRTCHNL2_PROTO_HDR_PFCP_NODE           = 57,
>> +       VIRTCHNL2_PROTO_HDR_PFCP_SESSION        = 58,
>> +       VIRTCHNL2_PROTO_HDR_RTP                 = 59,
>> +       VIRTCHNL2_PROTO_HDR_ROCE                = 60,
>> +       VIRTCHNL2_PROTO_HDR_ROCEV1              = 61,
>> +       VIRTCHNL2_PROTO_HDR_ROCEV2              = 62,
>> +       /* protocol ids up to 32767 are reserved for AVF use */
> 
> Remove AVF reference here?
> 

OK

>> +       /* 32768 - 65534 are used for user defined protocol ids */
>> +       /* VIRTCHNL2_PROTO_HDR_NO_PROTO is a mandatory protocol id */
>> +       VIRTCHNL2_PROTO_HDR_NO_PROTO            = 65535,
>> +};
>> +
>> +enum virtchl2_version {
>> +       VIRTCHNL2_VERSION_MINOR_0               = 0,
>> +       VIRTCHNL2_VERSION_MAJOR_2               = 2,
>> +};
>> +
>> +/**
>> + * struct virtchnl2_edt_caps - Get EDT granularity and time horizon.
>> + * @tstamp_granularity_ns: Timestamp granularity in nanoseconds.
>> + * @time_horizon_ns: Total time window in nanoseconds.
>> + *
>> + * Associated with VIRTCHNL2_OP_GET_EDT_CAPS.
>> + */
>> +struct virtchnl2_edt_caps {
>> +       __le64 tstamp_granularity_ns;
>> +       __le64 time_horizon_ns;
>> +};
>> +VIRTCHNL2_CHECK_STRUCT_LEN(16, virtchnl2_edt_caps);
>> +
>> +/**
>> + * struct virtchnl2_version_info - Version information.
>> + * @major: Major version.
>> + * @minor: Minor version.
>> + *
>> + * PF/VF posts its version number to the CP. CP responds with its 
>> version number
>> + * in the same format, along with a return code.
>> + * If there is a major version mismatch, then the PF/VF cannot operate.
>> + * If there is a minor version mismatch, then the PF/VF can operate 
>> but should
>> + * add a warning to the system log.
>> + *
>> + * This version opcode MUST always be specified as == 1, regardless 
>> of other
>> + * changes in the API. The CP must always respond to this message 
>> without
>> + * error regardless of version mismatch.
>> + *
>> + * Associated with VIRTCHNL2_OP_VERSION.
>> + */
>> +struct virtchnl2_version_info {
>> +       __le32 major;
>> +       __le32 minor;
>> +};
>> +VIRTCHNL2_CHECK_STRUCT_LEN(8, virtchnl2_version_info);
>> +
>> +/**
>> + * struct virtchnl2_get_capabilities - Capabilities info.
>> + * @csum_caps: See enum virtchnl2_cap_txrx_csum.
>> + * @seg_caps: See enum virtchnl2_cap_seg.
>> + * @hsplit_caps: See enum virtchnl2_cap_rx_hsplit_at.
>> + * @rsc_caps: See enum virtchnl2_cap_rsc.
>> + * @rss_caps: See enum virtcnl2_cap_rss.
>> + * @other_caps: See enum virtchnl2_cap_other.
>> + * @mailbox_dyn_ctl: DYN_CTL register offset and vector id for 
>> mailbox provided by CP.
>> + * @mailbox_vector_id: Mailbox vector id.
>> + * @num_allocated_vectors: Maximum number of allocated vectors for 
>> the device.
>> + * @max_rx_q: Maximum number of supported Rx queues.
>> + * @max_tx_q: Maximum number of supported Tx queues.
>> + * @max_rx_bufq: Maximum number of supported buffer queues.
>> + * @max_tx_complq: Maximum number of supported completion queues.
>> + * @max_sriov_vfs: The PF sends the maximum VFs it is requesting. The CP
>> + *                responds with the maximum VFs granted.
>> + * @max_vports: Maximum number of vports that can be supported.
>> + * @default_num_vports: Default number of vports driver should 
>> allocate on load.
>> + * @max_tx_hdr_size: Max header length hardware can parse/checksum, 
>> in bytes.
>> + * @max_sg_bufs_per_tx_pkt: Max number of scatter gather buffers that 
>> can be sent
>> + *                         per transmit packet without needing to be 
>> linearized.
>> + * @pad: Padding.
>> + * @reserved: Reserved.
>> + * @device_type: See enum virtchl2_device_type.
>> + * @min_sso_packet_len: Min packet length supported by device for single
>> + *                     segment offload.
>> + * @max_hdr_buf_per_lso: Max number of header buffers that can be 
>> used for an LSO.
>> + * @pad1: Padding for future extensions.
>> + *
>> + * Dataplane driver sends this message to CP to negotiate 
>> capabilities and
>> + * provides a virtchnl2_get_capabilities structure with its desired
>> + * capabilities, max_sriov_vfs and num_allocated_vectors.
>> + * CP responds with a virtchnl2_get_capabilities structure updated
>> + * with allowed capabilities and the other fields as below.
>> + * If PF sets max_sriov_vfs as 0, CP will respond with max number of VFs
>> + * that can be created by this PF. For any other value 'n', CP responds
>> + * with max_sriov_vfs set to min(n, x) where x is the max number of VFs
>> + * allowed by CP's policy. max_sriov_vfs is not applicable for VFs.
>> + * If dataplane driver sets num_allocated_vectors as 0, CP will 
>> respond with 1
>> + * which is default vector associated with the default mailbox. For 
>> any other
>> + * value 'n', CP responds with a value <= n based on the CP's policy of
>> + * max number of vectors for a PF.
>> + * CP will respond with the vector ID of mailbox allocated to the PF in
>> + * mailbox_vector_id and the number of itr index registers in 
>> itr_idx_map.
>> + * It also responds with default number of vports that the dataplane 
>> driver
>> + * should comeup with in default_num_vports and maximum number of 
>> vports that
>> + * can be supported in max_vports.
>> + *
>> + * Associated with VIRTCHNL2_OP_GET_CAPS.
>> + */
>> +struct virtchnl2_get_capabilities {
>> +       __le32 csum_caps;
>> +       __le32 seg_caps;
>> +       __le32 hsplit_caps;
>> +       __le32 rsc_caps;
>> +       __le64 rss_caps;
>> +       __le64 other_caps;
>> +       __le32 mailbox_dyn_ctl;
>> +       __le16 mailbox_vector_id;
>> +       __le16 num_allocated_vectors;
>> +       __le16 max_rx_q;
>> +       __le16 max_tx_q;
>> +       __le16 max_rx_bufq;
>> +       __le16 max_tx_complq;
>> +       __le16 max_sriov_vfs;
>> +       __le16 max_vports;
>> +       __le16 default_num_vports;
>> +       __le16 max_tx_hdr_size;
>> +       u8 max_sg_bufs_per_tx_pkt;
>> +       u8 pad[3];
>> +       u8 reserved[4];
>> +       __le32 device_type;
>> +       u8 min_sso_packet_len;
>> +       u8 max_hdr_buf_per_lso;
>> +       u8 pad1[10];
>> +};
>> +VIRTCHNL2_CHECK_STRUCT_LEN(80, virtchnl2_get_capabilities);
>> +
>> +/**
>> + * struct virtchnl2_queue_reg_chunk - Single queue chunk.
>> + * @type: See enum virtchnl2_queue_type.
>> + * @start_queue_id: Start Queue ID.
>> + * @num_queues: Number of queues in the chunk.
>> + * @pad: Padding.
>> + * @qtail_reg_start: Queue tail register offset.
>> + * @qtail_reg_spacing: Queue tail register spacing.
>> + * @pad1: Padding for future extensions.
>> + */
>> +struct virtchnl2_queue_reg_chunk {
>> +       __le32 type;
>> +       __le32 start_queue_id;
>> +       __le32 num_queues;
>> +       __le32 pad;
>> +       __le64 qtail_reg_start;
>> +       __le32 qtail_reg_spacing;
>> +       u8 pad1[4];
>> +};
>> +VIRTCHNL2_CHECK_STRUCT_LEN(32, virtchnl2_queue_reg_chunk);
>> +
>> +/**
>> + *  struct virtchnl2_queue_reg_chunks - Specify several chunks of 
>> contiguous queues.
>> + *  @num_chunks: Number of chunks.
>> + *  @pad: Padding.
>> + *  @chunks: Chunks of queue info.
>> + */
>> +struct virtchnl2_queue_reg_chunks {
>> +       __le16 num_chunks;
>> +       u8 pad[6];
>> +       struct virtchnl2_queue_reg_chunk chunks[];
>> +};
>> +VIRTCHNL2_CHECK_STRUCT_LEN(8, virtchnl2_queue_reg_chunks);
>> +
>> +/**
>> + * struct virtchnl2_create_vport - Create vport config info.
>> + * @vport_type: See enum virtchnl2_vport_type.
>> + * @txq_model: See virtchnl2_queue_model.
>> + * @rxq_model: See virtchnl2_queue_model.
>> + * @num_tx_q: Number of Tx queues.
>> + * @num_tx_complq: Valid only if txq_model is split queue.
>> + * @num_rx_q: Number of Rx queues.
>> + * @num_rx_bufq: Valid only if rxq_model is split queue.
>> + * @default_rx_q: Relative receive queue index to be used as default.
>> + * @vport_index: Used to align PF and CP in case of default multiple 
>> vports,
>> + *              it is filled by the PF and CP returns the same value, to
>> + *              enable the driver to support multiple asynchronous 
>> parallel
>> + *              CREATE_VPORT requests and associate a response to a 
>> specific
>> + *              request.
>> + * @max_mtu: Max MTU. CP populates this field on response.
>> + * @vport_id: Vport id. CP populates this field on response.
>> + * @default_mac_addr: Default MAC address.
>> + * @pad: Padding.
>> + * @rx_desc_ids: See VIRTCHNL2_RX_DESC_IDS definitions.
>> + * @tx_desc_ids: See VIRTCHNL2_TX_DESC_IDS definitions.
>> + * @pad1: Padding.
>> + * @rss_algorithm: RSS algorithm.
>> + * @rss_key_size: RSS key size.
>> + * @rss_lut_size: RSS LUT size.
>> + * @rx_split_pos: See enum virtchnl2_cap_rx_hsplit_at.
>> + * @pad2: Padding.
>> + * @chunks: Chunks of contiguous queues.
>> + *
>> + * PF sends this message to CP to create a vport by filling in required
>> + * fields of virtchnl2_create_vport structure.
>> + * CP responds with the updated virtchnl2_create_vport structure 
>> containing the
>> + * necessary fields followed by chunks which in turn will have an 
>> array of
>> + * num_chunks entries of virtchnl2_queue_chunk structures.
>> + *
>> + * Associated with VIRTCHNL2_OP_CREATE_VPORT.
>> + */
>> +struct virtchnl2_create_vport {
>> +       __le16 vport_type;
>> +       __le16 txq_model;
>> +       __le16 rxq_model;
>> +       __le16 num_tx_q;
>> +       __le16 num_tx_complq;
>> +       __le16 num_rx_q;
>> +       __le16 num_rx_bufq;
>> +       __le16 default_rx_q;
>> +       __le16 vport_index;
>> +       /* CP populates the following fields on response */
>> +       __le16 max_mtu;
>> +       __le32 vport_id;
>> +       u8 default_mac_addr[ETH_ALEN];
>> +       __le16 pad;
>> +       __le64 rx_desc_ids;
>> +       __le64 tx_desc_ids;
>> +       u8 pad1[72];
>> +       __le32 rss_algorithm;
>> +       __le16 rss_key_size;
>> +       __le16 rss_lut_size;
>> +       __le32 rx_split_pos;
>> +       u8 pad2[20];
>> +       struct virtchnl2_queue_reg_chunks chunks;
>> +};
>> +VIRTCHNL2_CHECK_STRUCT_LEN(160, virtchnl2_create_vport);
>> +
>> +/**
>> + * struct virtchnl2_vport - Vport ID info.
>> + * @vport_id: Vport id.
>> + * @pad: Padding for future extensions.
>> + *
>> + * PF sends this message to CP to destroy, enable or disable a vport 
>> by filling
>> + * in the vport_id in virtchnl2_vport structure.
>> + * CP responds with the status of the requested operation.
>> + *
>> + * Associated with VIRTCHNL2_OP_DESTROY_VPORT, 
>> VIRTCHNL2_OP_ENABLE_VPORT,
>> + * VIRTCHNL2_OP_DISABLE_VPORT.
>> + */
>> +struct virtchnl2_vport {
>> +       __le32 vport_id;
>> +       u8 pad[4];
>> +};
>> +VIRTCHNL2_CHECK_STRUCT_LEN(8, virtchnl2_vport);
>> +
>> +/**
>> + * struct virtchnl2_txq_info - Transmit queue config info
>> + * @dma_ring_addr: DMA address.
>> + * @type: See enum virtchnl2_queue_type.
>> + * @queue_id: Queue ID.
>> + * @relative_queue_id: Valid only if queue model is split and type is 
>> transmit
>> + *                    queue. Used in many to one mapping of transmit 
>> queues to
>> + *                    completion queue.
>> + * @model: See enum virtchnl2_queue_model.
>> + * @sched_mode: See enum virtcnl2_txq_sched_mode.
>> + * @qflags: TX queue feature flags.
>> + * @ring_len: Ring length.
>> + * @tx_compl_queue_id: Valid only if queue model is split and type is 
>> transmit queue.
>> + * @peer_type: Valid only if queue type is 
>> VIRTCHNL2_QUEUE_TYPE_MAILBOX_TX
>> + *            See enum virtchnl2_peer_type.
>> + * @peer_rx_queue_id: Valid only if queue type is CONFIG_TX and used 
>> to deliver
>> + *                   messages for the respective CONFIG_TX queue.
>> + * @pad: Padding.
>> + * @egress_pasid: Egress PASID info.
>> + * @egress_hdr_pasid: Egress HDR passid.
>> + * @egress_buf_pasid: Egress buf passid.
>> + * @pad1: Padding for future extensions.
>> + */
>> +struct virtchnl2_txq_info {
>> +       __le64 dma_ring_addr;
>> +       __le32 type;
>> +       __le32 queue_id;
>> +       __le16 relative_queue_id;
>> +       __le16 model;
>> +       __le16 sched_mode;
>> +       __le16 qflags;
>> +       __le16 ring_len;
>> +       __le16 tx_compl_queue_id;
>> +       __le16 peer_type;
>> +       __le16 peer_rx_queue_id;
>> +       u8 pad[4];
>> +       __le32 egress_pasid;
>> +       __le32 egress_hdr_pasid;
>> +       __le32 egress_buf_pasid;
>> +       u8 pad1[8];
>> +};
>> +VIRTCHNL2_CHECK_STRUCT_LEN(56, virtchnl2_txq_info);
>> +
>> +/**
>> + * struct virtchnl2_config_tx_queues - TX queue config.
>> + * @vport_id: Vport id.
>> + * @num_qinfo: Number of virtchnl2_txq_info structs.
>> + * @pad: Padding.
>> + * @qinfo: Tx queues config info.
>> + *
>> + * PF sends this message to set up parameters for one or more 
>> transmit queues.
>> + * This message contains an array of num_qinfo instances of 
>> virtchnl2_txq_info
>> + * structures. CP configures requested queues and returns a status 
>> code. If
>> + * num_qinfo specified is greater than the number of queues 
>> associated with the
>> + * vport, an error is returned and no queues are configured.
>> + *
>> + * Associated with VIRTCHNL2_OP_CONFIG_TX_QUEUES.
>> + */
>> +struct virtchnl2_config_tx_queues {
>> +       __le32 vport_id;
>> +       __le16 num_qinfo;
>> +       u8 pad[10];
>> +       struct virtchnl2_txq_info qinfo[];
>> +};
>> +VIRTCHNL2_CHECK_STRUCT_LEN(16, virtchnl2_config_tx_queues);
>> +
>> +/**
>> + * struct virtchnl2_rxq_info - Receive queue config info.
>> + * @desc_ids: See VIRTCHNL2_RX_DESC_IDS definitions.
>> + * @dma_ring_addr: See VIRTCHNL2_RX_DESC_IDS definitions.
>> + * @type: See enum virtchnl2_queue_type.
>> + * @queue_id: Queue id.
>> + * @model: See enum virtchnl2_queue_model.
>> + * @hdr_buffer_size: Header buffer size.
>> + * @data_buffer_size: Data buffer size.
>> + * @max_pkt_size: Max packet size.
>> + * @ring_len: Ring length.
>> + * @buffer_notif_stride: Buffer notification stride in units of 
>> 32-descriptors.
>> + *                      This field must be a power of 2.
>> + * @pad: Padding.
>> + * @dma_head_wb_addr: Applicable only for receive buffer queues.
>> + * @qflags: Applicable only for receive completion queues.
>> + *         See enum virtchnl2_rxq_flags.
>> + * @rx_buffer_low_watermark: Rx buffer low watermark.
>> + * @rx_bufq1_id: Buffer queue index of the first buffer queue 
>> associated with
>> + *              the Rx queue. Valid only in split queue model.
>> + * @rx_bufq2_id: Buffer queue index of the second buffer queue 
>> associated with
>> + *              the Rx queue. Valid only in split queue model.
>> + * @bufq2_ena: It indicates if there is a second buffer, rx_bufq2_id 
>> is valid
>> + *            only if this field is set.
>> + * @pad1: Padding.
>> + * @ingress_pasid: Ingress PASID.
>> + * @ingress_hdr_pasid: Ingress PASID header.
>> + * @ingress_buf_pasid: Ingress PASID buffer.
>> + * @pad2: Padding for future extensions.
>> + */
>> +struct virtchnl2_rxq_info {
>> +       __le64 desc_ids;
>> +       __le64 dma_ring_addr;
>> +       __le32 type;
>> +       __le32 queue_id;
>> +       __le16 model;
>> +       __le16 hdr_buffer_size;
>> +       __le32 data_buffer_size;
>> +       __le32 max_pkt_size;
>> +       __le16 ring_len;
>> +       u8 buffer_notif_stride;
>> +       u8 pad;
>> +       __le64 dma_head_wb_addr;
>> +       __le16 qflags;
>> +       __le16 rx_buffer_low_watermark;
>> +       __le16 rx_bufq1_id;
>> +       __le16 rx_bufq2_id;
>> +       u8 bufq2_ena;
>> +       u8 pad1[3];
>> +       __le32 ingress_pasid;
>> +       __le32 ingress_hdr_pasid;
>> +       __le32 ingress_buf_pasid;
>> +       u8 pad2[16];
>> +};
>> +VIRTCHNL2_CHECK_STRUCT_LEN(88, virtchnl2_rxq_info);
>> +
>> +/**
>> + * struct virtchnl2_config_rx_queues - Rx queues config.
>> + * @vport_id: Vport id.
>> + * @num_qinfo: Number of instances.
>> + * @pad: Padding.
>> + * @qinfo: Rx queues config info.
>> + *
>> + * PF sends this message to set up parameters for one or more receive 
>> queues.
>> + * This message contains an array of num_qinfo instances of 
>> virtchnl2_rxq_info
>> + * structures. CP configures requested queues and returns a status code.
>> + * If the number of queues specified is greater than the number of 
>> queues
>> + * associated with the vport, an error is returned and no queues are 
>> configured.
>> + *
>> + * Associated with VIRTCHNL2_OP_CONFIG_RX_QUEUES.
>> + */
>> +struct virtchnl2_config_rx_queues {
>> +       __le32 vport_id;
>> +       __le16 num_qinfo;
>> +       u8 pad[18];
>> +       struct virtchnl2_rxq_info qinfo[];
>> +};
>> +VIRTCHNL2_CHECK_STRUCT_LEN(24, virtchnl2_config_rx_queues);
>> +
>> +/**
>> + * struct virtchnl2_add_queues - data for VIRTCHNL2_OP_ADD_QUEUES.
>> + * @vport_id: Vport id.
>> + * @num_tx_q: Number of Tx qieues.
>> + * @num_tx_complq: Number of Tx completion queues.
>> + * @num_rx_q:  Number of Rx queues.
>> + * @num_rx_bufq:  Number of Rx buffer queues.
>> + * @pad: Padding.
>> + * @chunks: Chunks of contiguous queues.
>> + *
>> + * PF sends this message to request additional transmit/receive 
>> queues beyond
>> + * the ones that were assigned via CREATE_VPORT request. 
>> virtchnl2_add_queues
>> + * structure is used to specify the number of each type of queues.
>> + * CP responds with the same structure with the actual number of 
>> queues assigned
>> + * followed by num_chunks of virtchnl2_queue_chunk structures.
>> + *
>> + * Associated with VIRTCHNL2_OP_ADD_QUEUES.
>> + */
>> +struct virtchnl2_add_queues {
>> +       __le32 vport_id;
>> +       __le16 num_tx_q;
>> +       __le16 num_tx_complq;
>> +       __le16 num_rx_q;
>> +       __le16 num_rx_bufq;
>> +       u8 pad[4];
>> +       struct virtchnl2_queue_reg_chunks chunks;
>> +};
>> +VIRTCHNL2_CHECK_STRUCT_LEN(24, virtchnl2_add_queues);
>> +
>> +/**
>> + * struct virtchnl2_vector_chunk - Structure to specify a chunk of 
>> contiguous
>> + *                                interrupt vectors.
>> + * @start_vector_id: Start vector id.
>> + * @start_evv_id: Start EVV id.
>> + * @num_vectors: Number of vectors.
>> + * @pad: Padding.
>> + * @dynctl_reg_start: DYN_CTL register offset.
>> + * @dynctl_reg_spacing: register spacing between DYN_CTL registers of 2
>> + *                     consecutive vectors.
>> + * @itrn_reg_start: ITRN register offset.
>> + * @itrn_reg_spacing: Register spacing between dynctl registers of 2
>> + *                   consecutive vectors.
>> + * @itrn_index_spacing: Register spacing between itrn registers of 
>> the same
>> + *                     vector where n=0..2.
>> + * @pad1: Padding for future extensions.
>> + *
>> + * Register offsets and spacing provided by CP.
>> + * Dynamic control registers are used for enabling/disabling/re-enabling
>> + * interrupts and updating interrupt rates in the hotpath. Any changes
>> + * to interrupt rates in the dynamic control registers will be reflected
>> + * in the interrupt throttling rate registers.
>> + * itrn registers are used to update interrupt rates for specific
>> + * interrupt indices without modifying the state of the interrupt.
>> + */
>> +struct virtchnl2_vector_chunk {
>> +       __le16 start_vector_id;
>> +       __le16 start_evv_id;
>> +       __le16 num_vectors;
>> +       __le16 pad;
>> +       __le32 dynctl_reg_start;
>> +       __le32 dynctl_reg_spacing;
>> +       __le32 itrn_reg_start;
>> +       __le32 itrn_reg_spacing;
>> +       __le32 itrn_index_spacing;
>> +       u8 pad1[4];
>> +};
>> +VIRTCHNL2_CHECK_STRUCT_LEN(32, virtchnl2_vector_chunk);
>> +
>> +/**
>> + * struct virtchnl2_vector_chunks - chunks of contiguous interrupt 
>> vectors.
>> + * @num_vchunks: number of vector chunks.
>> + * @pad: Padding.
>> + * @vchunks: Chunks of contiguous vector info.
>> + *
>> + * PF sends virtchnl2_vector_chunks struct to specify the vectors it 
>> is giving
>> + * away. CP performs requested action and returns status.
>> + *
>> + * Associated with VIRTCHNL2_OP_DEALLOC_VECTORS.
>> + */
>> +struct virtchnl2_vector_chunks {
>> +       __le16 num_vchunks;
>> +       u8 pad[14];
>> +       struct virtchnl2_vector_chunk vchunks[];
>> +};
>> +VIRTCHNL2_CHECK_STRUCT_LEN(16, virtchnl2_vector_chunks);
>> +
>> +/**
>> + * struct virtchnl2_alloc_vectors - vector allocation info.
>> + * @num_vectors: Number of vectors.
>> + * @pad: Padding.
>> + * @vchunks: Chunks of contiguous vector info.
>> + *
>> + * PF sends this message to request additional interrupt vectors 
>> beyond the
>> + * ones that were assigned via GET_CAPS request. virtchnl2_alloc_vectors
>> + * structure is used to specify the number of vectors requested. CP 
>> responds
>> + * with the same structure with the actual number of vectors assigned 
>> followed
>> + * by virtchnl2_vector_chunks structure identifying the vector ids.
>> + *
>> + * Associated with VIRTCHNL2_OP_ALLOC_VECTORS.
>> + */
>> +struct virtchnl2_alloc_vectors {
>> +       __le16 num_vectors;
>> +       u8 pad[14];
>> +       struct virtchnl2_vector_chunks vchunks;
>> +};
>> +VIRTCHNL2_CHECK_STRUCT_LEN(32, virtchnl2_alloc_vectors);
>> +
>> +/**
>> + * struct virtchnl2_rss_lut - RSS LUT info.
>> + * @vport_id: Vport id.
>> + * @lut_entries_start: Start of LUT entries.
>> + * @lut_entries: Number of LUT entrties.
>> + * @pad: Padding.
>> + * @lut: RSS lookup table.
>> + *
>> + * PF sends this message to get or set RSS lookup table. Only 
>> supported if
>> + * both PF and CP drivers set the VIRTCHNL2_CAP_RSS bit during 
>> configuration
>> + * negotiation.
>> + *
>> + * Associated with VIRTCHNL2_OP_GET_RSS_LUT and 
>> VIRTCHNL2_OP_SET_RSS_LUT.
>> + */
>> +struct virtchnl2_rss_lut {
>> +       __le32 vport_id;
>> +       __le16 lut_entries_start;
>> +       __le16 lut_entries;
>> +       u8 pad[4];
>> +       __le32 lut[];
>> +};
>> +VIRTCHNL2_CHECK_STRUCT_LEN(12, virtchnl2_rss_lut);
>> +
>> +/**
>> + * struct virtchnl2_rss_hash - RSS hash info.
>> + * @ptype_groups: Packet type groups bitmap.
>> + * @vport_id: Vport id.
>> + * @pad: Padding for future extensions.
>> + *
>> + * PF sends these messages to get and set the hash filter enable bits 
>> for RSS.
>> + * By default, the CP sets these to all possible traffic types that the
>> + * hardware supports. The PF can query this value if it wants to 
>> change the
>> + * traffic types that are hashed by the hardware.
>> + * Only supported if both PF and CP drivers set the VIRTCHNL2_CAP_RSS 
>> bit
>> + * during configuration negotiation.
>> + *
>> + * Associated with VIRTCHNL2_OP_GET_RSS_HASH and 
>> VIRTCHNL2_OP_SET_RSS_HASH
>> + */
>> +struct virtchnl2_rss_hash {
>> +       __le64 ptype_groups;
>> +       __le32 vport_id;
>> +       u8 pad[4];
>> +};
>> +VIRTCHNL2_CHECK_STRUCT_LEN(16, virtchnl2_rss_hash);
>> +
>> +/**
>> + * struct virtchnl2_sriov_vfs_info - VFs info.
>> + * @num_vfs: Number of VFs.
>> + * @pad: Padding for future extensions.
>> + *
>> + * This message is used to set number of SRIOV VFs to be created. The 
>> actual
>> + * allocation of resources for the VFs in terms of vport, queues and 
>> interrupts
>> + * is done by CP. When this call completes, the IDPF driver calls
>> + * pci_enable_sriov to let the OS instantiate the SRIOV PCIE devices.
>> + * The number of VFs set to 0 will destroy all the VFs of this function.
>> + *
>> + * Associated with VIRTCHNL2_OP_SET_SRIOV_VFS.
>> + */
>> +struct virtchnl2_sriov_vfs_info {
>> +       __le16 num_vfs;
>> +       __le16 pad;
>> +};
>> +VIRTCHNL2_CHECK_STRUCT_LEN(4, virtchnl2_sriov_vfs_info);
>> +
>> +/**
>> + * struct virtchnl2_ptype - Packet type info.
>> + * @ptype_id_10: 10-bit packet type.
>> + * @ptype_id_8: 8-bit packet type.
>> + * @proto_id_count: Number of protocol ids the packet supports, 
>> maximum of 32
>> + *                 protocol ids are supported.
>> + * @pad: Padding.
>> + * @proto_id: proto_id_count decides the allocation of protocol id 
>> array.
>> + *           See enum virtchnl2_proto_hdr_type.
>> + *
>> + * Based on the descriptor type the PF supports, CP fills ptype_id_10 or
>> + * ptype_id_8 for flex and base descriptor respectively. If 
>> ptype_id_10 value
>> + * is set to 0xFFFF, PF should consider this ptype as dummy one and 
>> it is the
>> + * last ptype.
>> + */
>> +struct virtchnl2_ptype {
>> +       __le16 ptype_id_10;
>> +       u8 ptype_id_8;
>> +       u8 proto_id_count;
>> +       __le16 pad;
>> +       __le16 proto_id[];
>> +};
>> +
> 
> unnecessary blank line
> 

OK

>> +VIRTCHNL2_CHECK_STRUCT_LEN(6, virtchnl2_ptype);
>> +
>> +/**
>> + * struct virtchnl2_get_ptype_info - Packet type info.
>> + * @start_ptype_id: Starting ptype ID.
>> + * @num_ptypes: Number of packet types from start_ptype_id.
>> + * @pad: Padding for future extensions.
>> + *
>> + * The total number of supported packet types is based on the 
>> descriptor type.
>> + * For the flex descriptor, it is 1024 (10-bit ptype), and for the base
>> + * descriptor, it is 256 (8-bit ptype). Send this message to the CP by
>> + * populating the 'start_ptype_id' and the 'num_ptypes'. CP responds 
>> with the
>> + * 'start_ptype_id', 'num_ptypes', and the array of ptype 
>> (virtchnl2_ptype) that
>> + * are added at the end of the 'virtchnl2_get_ptype_info' message 
>> (Note: There
>> + * is no specific field for the ptypes but are added at the end of the
>> + * ptype info message. PF/VF is expected to extract the ptypes 
>> accordingly.
>> + * Reason for doing this is because compiler doesn't allow nested 
>> flexible
>> + * array fields).
>> + *
>> + * If all the ptypes don't fit into one mailbox buffer, CP splits the
>> + * ptype info into multiple messages, where each message will have 
>> its own
>> + * 'start_ptype_id', 'num_ptypes', and the ptype array itself. When 
>> CP is done
>> + * updating all the ptype information extracted from the package (the 
>> number of
>> + * ptypes extracted might be less than what PF/VF expects), it will 
>> append a
>> + * dummy ptype (which has 'ptype_id_10' of 'struct virtchnl2_ptype' 
>> as 0xFFFF)
>> + * to the ptype array.
>> + *
>> + * PF/VF is expected to receive multiple VIRTCHNL2_OP_GET_PTYPE_INFO 
>> messages.
>> + *
>> + * Associated with VIRTCHNL2_OP_GET_PTYPE_INFO.
>> + */
>> +struct virtchnl2_get_ptype_info {
>> +       __le16 start_ptype_id;
>> +       __le16 num_ptypes;
>> +       __le32 pad;
>> +};
>> +VIRTCHNL2_CHECK_STRUCT_LEN(8, virtchnl2_get_ptype_info);
>> +
>> +/**
>> + * struct virtchnl2_vport_stats - Vport statistics.
>> + * @vport_id: Vport id.
>> + * @pad: Padding.
>> + * @rx_bytes: Received bytes.
>> + * @rx_unicast: Received unicast packets.
>> + * @rx_multicast: Received multicast packets.
>> + * @rx_broadcast: Received broadcast packets.
>> + * @rx_discards: Discarded packets on receive.
>> + * @rx_errors: Receive errors.
>> + * @rx_unknown_protocol: Unlnown protocol.
>> + * @tx_bytes: Transmitted bytes.
>> + * @tx_unicast: Transmitted unicast packets.
>> + * @tx_multicast: Transmitted multicast packets.
>> + * @tx_broadcast: Transmitted broadcast packets.
>> + * @tx_discards: Discarded packets on transmit.
>> + * @tx_errors: Transmit errors.
>> + * @rx_invalid_frame_length: Packets with invalid frame length.
>> + * @rx_overflow_drop: Packets dropped on buffer overflow.
>> + *
>> + * PF/VF sends this message to CP to get the update stats by 
>> specifying the
>> + * vport_id. CP responds with stats in struct virtchnl2_vport_stats.
>> + *
>> + * Associated with VIRTCHNL2_OP_GET_STATS.
>> + */
>> +struct virtchnl2_vport_stats {
>> +       __le32 vport_id;
>> +       u8 pad[4];
>> +       __le64 rx_bytes;
>> +       __le64 rx_unicast;
>> +       __le64 rx_multicast;
>> +       __le64 rx_broadcast;
>> +       __le64 rx_discards;
>> +       __le64 rx_errors;
>> +       __le64 rx_unknown_protocol;
>> +       __le64 tx_bytes;
>> +       __le64 tx_unicast;
>> +       __le64 tx_multicast;
>> +       __le64 tx_broadcast;
>> +       __le64 tx_discards;
>> +       __le64 tx_errors;
>> +       __le64 rx_invalid_frame_length;
>> +       __le64 rx_overflow_drop;
>> +};
>> +VIRTCHNL2_CHECK_STRUCT_LEN(128, virtchnl2_vport_stats);
>> +
>> +/**
>> + * struct virtchnl2_event - Event info.
>> + * @event: Event opcode. See enum virtchnl2_event_codes.
>> + * @link_speed: Link_speed provided in Mbps.
>> + * @vport_id: Vport ID.
>> + * @link_status: Link status.
>> + * @pad: Padding.
>> + * @reserved: Reserved.
>> + *
>> + * CP sends this message to inform the PF/VF driver of events that 
>> may affect
>> + * it. No direct response is expected from the driver, though it may 
>> generate
>> + * other messages in response to this one.
>> + *
>> + * Associated with VIRTCHNL2_OP_EVENT.
>> + */
>> +struct virtchnl2_event {
>> +       __le32 event;
>> +       __le32 link_speed;
>> +       __le32 vport_id;
>> +       u8 link_status;
>> +       u8 pad;
>> +       __le16 reserved;
>> +};
>> +VIRTCHNL2_CHECK_STRUCT_LEN(16, virtchnl2_event);
>> +
>> +/**
>> + * struct virtchnl2_rss_key - RSS key info.
>> + * @vport_id: Vport id.
>> + * @key_len: Length of RSS key.
>> + * @pad: Padding.
>> + * @key_flex: RSS hash key, packed bytes.
>> + * PF/VF sends this message to get or set RSS key. Only supported if 
>> both
>> + * PF/VF and CP drivers set the VIRTCHNL2_CAP_RSS bit during 
>> configuration
>> + * negotiation.
>> + *
>> + * Associated with VIRTCHNL2_OP_GET_RSS_KEY and 
>> VIRTCHNL2_OP_SET_RSS_KEY.
>> + */
>> +struct virtchnl2_rss_key {
>> +       __le32 vport_id;
>> +       __le16 key_len;
>> +       u8 pad;
>> +       __DECLARE_FLEX_ARRAY(u8, key_flex);
>> +};
>> +VIRTCHNL2_CHECK_STRUCT_LEN(8, virtchnl2_rss_key);
>> +
>> +/**
>> + * struct virtchnl2_queue_chunk - chunk of contiguous queues
>> + * @type: See enum virtchnl2_queue_type.
>> + * @start_queue_id: Starting queue id.
>> + * @num_queues: Number of queues.
>> + * @pad: Padding for future extensions.
>> + */
>> +struct virtchnl2_queue_chunk {
>> +       __le32 type;
>> +       __le32 start_queue_id;
>> +       __le32 num_queues;
>> +       u8 pad[4];
>> +};
>> +VIRTCHNL2_CHECK_STRUCT_LEN(16, virtchnl2_queue_chunk);
>> +
>> +/* struct virtchnl2_queue_chunks - chunks of contiguous queues
>> + * @num_chunks: Number of chunks.
>> + * @pad: Padding.
>> + * @chunks: Chunks of contiguous queues info.
>> + */
>> +struct virtchnl2_queue_chunks {
>> +       __le16 num_chunks;
>> +       u8 pad[6];
>> +       struct virtchnl2_queue_chunk chunks[];
>> +};
>> +VIRTCHNL2_CHECK_STRUCT_LEN(8, virtchnl2_queue_chunks);
>> +
>> +/**
>> + * struct virtchnl2_del_ena_dis_queues - Enable/disable queues info.
>> + * @vport_id: Vport id.
>> + * @pad: Padding.
>> + * @chunks: Chunks of contiguous queues info.
>> + *
>> + * PF sends these messages to enable, disable or delete queues 
>> specified in
>> + * chunks. PF sends virtchnl2_del_ena_dis_queues struct to specify 
>> the queues
>> + * to be enabled/disabled/deleted. Also applicable to single queue 
>> receive or
>> + * transmit. CP performs requested action and returns status.
>> + *
>> + * Associated with VIRTCHNL2_OP_ENABLE_QUEUES, 
>> VIRTCHNL2_OP_DISABLE_QUEUES and
>> + * VIRTCHNL2_OP_DISABLE_QUEUES.
>> + */
>> +struct virtchnl2_del_ena_dis_queues {
>> +       __le32 vport_id;
>> +       u8 pad[4];
>> +       struct virtchnl2_queue_chunks chunks;
>> +};
>> +VIRTCHNL2_CHECK_STRUCT_LEN(16, virtchnl2_del_ena_dis_queues);
>> +
>> +/**
>> + * struct virtchnl2_queue_vector - Queue to vector mapping.
>> + * @queue_id: Queue id.
>> + * @vector_id: Vector id.
>> + * @pad: Padding.
>> + * @itr_idx: See enum virtchnl2_itr_idx.
>> + * @queue_type: See enum virtchnl2_queue_type.
>> + * @pad1: Padding for future extensions.
>> + */
>> +struct virtchnl2_queue_vector {
>> +       __le32 queue_id;
>> +       __le16 vector_id;
>> +       u8 pad[2];
>> +       __le32 itr_idx;
>> +       __le32 queue_type;
>> +       u8 pad1[8];
>> +};
>> +VIRTCHNL2_CHECK_STRUCT_LEN(24, virtchnl2_queue_vector);
>> +
>> +/**
>> + * struct virtchnl2_queue_vector_maps - Map/unmap queues info.
>> + * @vport_id: Vport id.
>> + * @num_qv_maps: Number of queue vector maps.
>> + * @pad: Padding.
>> + * @qv_maps: Queue to vector maps.
>> + *
>> + * PF sends this message to map or unmap queues to vectors and interrupt
>> + * throttling rate index registers. External data buffer contains
>> + * virtchnl2_queue_vector_maps structure that contains num_qv_maps of
>> + * virtchnl2_queue_vector structures. CP maps the requested queue 
>> vector maps
>> + * after validating the queue and vector ids and returns a status code.
>> + *
>> + * Associated with VIRTCHNL2_OP_MAP_QUEUE_VECTOR and 
>> VIRTCHNL2_OP_UNMAP_QUEUE_VECTOR.
>> + */
>> +struct virtchnl2_queue_vector_maps {
>> +       __le32 vport_id;
>> +       __le16 num_qv_maps;
>> +       u8 pad[10];
>> +       struct virtchnl2_queue_vector qv_maps[];
>> +};
>> +VIRTCHNL2_CHECK_STRUCT_LEN(16, virtchnl2_queue_vector_maps);
>> +
>> +/**
>> + * struct virtchnl2_loopback - Loopback info.
>> + * @vport_id: Vport id.
>> + * @enable: Enable/disable.
>> + * @pad: Padding for future extensions.
>> + *
>> + * PF/VF sends this message to transition to/from the loopback state. 
>> Setting
>> + * the 'enable' to 1 enables the loopback state and setting 'enable' 
>> to 0
>> + * disables it. CP configures the state to loopback and returns status.
>> + *
>> + * Associated with VIRTCHNL2_OP_LOOPBACK.
>> + */
>> +struct virtchnl2_loopback {
>> +       __le32 vport_id;
>> +       u8 enable;
>> +       u8 pad[3];
>> +};
>> +VIRTCHNL2_CHECK_STRUCT_LEN(8, virtchnl2_loopback);
>> +
>> +/* struct virtchnl2_mac_addr - MAC address info.
>> + * @addr: MAC address.
>> + * @type: MAC type. See enum virtchnl2_mac_addr_type.
>> + * @pad: Padding for future extensions.
>> + */
>> +struct virtchnl2_mac_addr {
>> +       u8 addr[ETH_ALEN];
>> +       u8 type;
>> +       u8 pad;
>> +};
>> +VIRTCHNL2_CHECK_STRUCT_LEN(8, virtchnl2_mac_addr);
>> +
>> +/**
>> + * struct virtchnl2_mac_addr_list - List of MAC addresses.
>> + * @vport_id: Vport id.
>> + * @num_mac_addr: Number of MAC addresses.
>> + * @pad: Padding.
>> + * @mac_addr_list: List with MAC address info.
>> + *
>> + * PF/VF driver uses this structure to send list of MAC addresses to be
>> + * added/deleted to the CP where as CP performs the action and 
>> returns the
>> + * status.
>> + *
>> + * Associated with VIRTCHNL2_OP_ADD_MAC_ADDR and 
>> VIRTCHNL2_OP_DEL_MAC_ADDR.
>> + */
>> +
> 
> blank line
> 

OK

<snip>

Thanks,
Emil
