Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB10E45AD72
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 21:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233255AbhKWUk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 15:40:57 -0500
Received: from mga02.intel.com ([134.134.136.20]:43385 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232084AbhKWUk4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 15:40:56 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="222349144"
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="222349144"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2021 12:36:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="740158424"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga005.fm.intel.com with ESMTP; 23 Nov 2021 12:36:16 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 23 Nov 2021 12:36:15 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 23 Nov 2021 12:36:15 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 23 Nov 2021 12:36:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OiG7d9pBLTf6c4kzaV6FEAm5U0J/pSuMIJhmFZMLL4C80H5rVvDDPwO9O5UYalzHBqvKInDWIUOA1NJYjBSWZvJRfklvLYVprxtTTMXhECzhfAonVCf5TzUNMsUmR9cOwrcbjSdRvVE62cPuzfzJA0hcwzo3s7A9ElbYH7HswkyvREmq1pM9npnqKhTpR0D3RDiG0ZLH0WBs8XE6lQn0Xst1sSF6YX3vJUiW7/ka5FRFAyeoHOoKMIOfyxDUN0BHSfSxrKKKfJK3O4StmwDxR5whG9bRUV3hTLyhZReURLKT9akIXknqJ7Oci/KOS1YwJnqVvp9DfhOIhoVuPv+ApQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tk97lydkoOF23bjbxZx/P0WW70LNYLL1X9tNgMHKFcY=;
 b=V3GcRBLON4DO2MYKae+Q8LYYEdWCPCsaPEUdshAaUDROCxokWcEmzs1CjqKtHSgMJT3P05E/o3APjntmIoFVS5kLXm+yibTfqmckBMmEogDgF6/LnMHpG20sUIYRMDX04cRWzRY+G1OFzYODZitsrU6C9zTm8DYHRjjz+xrg1HA9dVm61ir1nxOKhbjYZrBPWZaIhFTfsZVE/LEeQta7VbYgp4v9Zk6XIzW04sSGN+OB3SqaQ0SZ0odSXPs9iQrLp42+rh9bQuJ3RxC4Dz1pnjqUfY8dgKT952sGZxgf8uFJ8NwlskDEisYNRG4+jwRqaU/b2HXttMNSQX2mmTa5YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tk97lydkoOF23bjbxZx/P0WW70LNYLL1X9tNgMHKFcY=;
 b=ON7GcYmdAT9bFtuD/UebcD5JbyQLertjXLYNW+eyYKHtQE31unvPwaB5GC7Td+mgiXemhFBWYWLc5txZZ8zZLfabn7GhZKO3ztjmkOGkAgkccXCj+L/vdTsdHCXKuYHdtZ14TTK/j5cTUHkg7p55vm04XdQkMiQiYFScqn/2A1M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by CO1PR11MB4849.namprd11.prod.outlook.com (2603:10b6:303:90::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Tue, 23 Nov
 2021 20:36:13 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::b0d7:d746:481b:103a]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::b0d7:d746:481b:103a%7]) with mapi id 15.20.4713.022; Tue, 23 Nov 2021
 20:36:13 +0000
Message-ID: <8de1a0ac-f707-8b45-787c-469ebba4a6ce@intel.com>
Date:   Tue, 23 Nov 2021 12:36:11 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [igb] netconsole triggers warning in netpoll_poll_dev
Content-Language: en-US
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        Danielle Ratson <danieller@nvidia.com>
CC:     Oleksandr Natalenko <oleksandr@natalenko.name>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Netdev <netdev@vger.kernel.org>
References: <DM6PR12MB45165BFF3AB84602238FA595D89B9@DM6PR12MB4516.namprd12.prod.outlook.com>
 <CAKgT0UfGvcGXAC5VBjXRpR5Y5uAPEPPCsYWjQR8RmW_1kw8TMQ@mail.gmail.com>
 <DM6PR12MB45162662DF7FAF82E7BD2207D89E9@DM6PR12MB4516.namprd12.prod.outlook.com>
 <CAKgT0Uc5ggH24LuKCbSTubDSiTnD5UsLbrC5G6C73rj7ZEnTYQ@mail.gmail.com>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <CAKgT0Uc5ggH24LuKCbSTubDSiTnD5UsLbrC5G6C73rj7ZEnTYQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P222CA0020.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::25) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
Received: from [192.168.1.211] (50.39.107.76) by MW4P222CA0020.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Tue, 23 Nov 2021 20:36:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed05e23e-4e7b-4bef-513a-08d9aec0e3f6
X-MS-TrafficTypeDiagnostic: CO1PR11MB4849:
X-Microsoft-Antispam-PRVS: <CO1PR11MB48497E34160B516A028D87F597609@CO1PR11MB4849.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dtwxRobtiJmkTuzmRbPfqbigN68M/2B6V8Byw2V5aNoucV10J+6W3krvMPKYMrosolbTMQ5H78LPX462t2oSCtLlQ96gk23eBOGMkskizUpoFQGAF7wltNQhP3EnupaweOK6ZvX2PGxvMOqyYhxmazBXezspCBkpb2RbNH2aVNVrIpNBu1GYgL5Keir3msu2MHLhsUc/GYSnVjT2rd6/7GM1lLEypCZwWL9gBwT3dl2mp9VVN3Rbms8EvDPmKDg0QMfTELDVhHJEcWxOyyogzQMBGKvUqdpJ7M2uKjuqZWdwe3kjwg+jCx+8n7auHuY3rDNkfsjdz30h8TmnOICS5m+dU5la9dJtfaNEtfBtUXmwYsxOQanmziXflCXTjx3Xb7zaFoXvVVbdx4LcCrRyoNGhI2d3MQnKK2OVdudngkHcNH9LB++jag+iop/cTbr2gtcFldSmZp7U6kXMT6CeiC2EOk4dxvQncdEzRHErqothmrZMAxdJKCKwwk9aRVCPtPlYnUeDcE1uDtkFOq+rzPTVfzW6PouWw4qQSXGq4E8xyyZuQUm6jFOYR41aKipeGlisOVdoeONZd+8NlOzzCaQNqoe148FUUraBVd92Xw1xbIdtl0Ru2mv/o3J50CSoOheHUyoftiECfWvBPKq3UgPL2xlqDKbFoQnjzfuIvwUKcj2Micku53/PmLwbZb4i7PeBPFX8WJ/faemRj3mqjUTistTz126Z3pxKEB2hoqYpCTD3b6QIFvD/Q2G5nncQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(4744005)(66946007)(508600001)(66556008)(5660300002)(186003)(44832011)(4326008)(31696002)(6486002)(38100700002)(956004)(2616005)(8936002)(31686004)(8676002)(86362001)(316002)(53546011)(54906003)(2906002)(26005)(16576012)(82960400001)(36756003)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RzdFcHpuMkFTU2FSaytHM0Mzd0VQNjgyN3R1MGRtTUVqOUMyNnRsN1lWWDA4?=
 =?utf-8?B?cWJMbm5pVE03V2hNOG43bU0rSUFzajg0cElRb0xPSWVXM1d0REFYTWtYQTN0?=
 =?utf-8?B?cVFyQ2FyYjd2RFBmR1dDbWlMRHJ4MmVKZTNXTE83Qk9YRFh4SG1vYUg5azF1?=
 =?utf-8?B?bnRhbkZhaGtqTmdmblJHNU12b3oybmxyZG5UOWhNWDFtVFJuWnR5WlEyMWlX?=
 =?utf-8?B?RnhadFczNXg2MzNjeW9ZUnljVms4V1dvbXc0c0FBS0F3R3hZZHRCTEJlcExD?=
 =?utf-8?B?TmxQUjF3bEcvdWM2UUs2Zjd0SVVobDZycTQwYm52UzZQcnNLN1hSakgrVmRS?=
 =?utf-8?B?WDUyNTRBbDNRVVREek5kY3RmM09LTXVVVGc2TWIwT3ZKcE84RW80NjB1aEFP?=
 =?utf-8?B?Qm5JRnFhMGIxMXIyYnZsQTdlRUZDZnREZFN1UHBZSWY3QndlelZpc3JJc0Y0?=
 =?utf-8?B?VXBoUXJGZjVwbk5LUFM2dUQxT1VoRysrdmJaeUZmM05qRjNUejBIMWJLV3o3?=
 =?utf-8?B?RXRZNkxQN3N0WDJjdXNLY1crNVcza2V6aFpWaGEvU3M5L1ZkSDFubG1QWXly?=
 =?utf-8?B?WW1BaFVXcmlNUHkwWVp3YXg3Y1B2VVBna3NYOTBFbC94ZG9Mc1FxV3J2TUVI?=
 =?utf-8?B?bGEzdjMxWWNOdytla1VHdjFGbmFIZHNEWEQ4aVVUNDZaODVCNGRMTDZtbXEw?=
 =?utf-8?B?Z29CMWJScHA4RDdBN1hwSk8rb2l4M3dmekw2UzR4cEtTK0NPR3ZDUDd5NFFO?=
 =?utf-8?B?QVVyWTdpTU0vVWtZTks0WFZrb3NhSU1YQlhtUnNOKytJa3JFVm1Pa01KVUtP?=
 =?utf-8?B?N0t0SG1FZDZ3VU1YOFcranlHVlYwQnhURFB0VUtzazU0cWYxZWZaRllDN2Nl?=
 =?utf-8?B?anRRM0dyRnlnOUozMTdoRTdOK1RIZC9GNFIveVlWOURiZExVNkM4VHUxc2hU?=
 =?utf-8?B?SGVCTmk0cHRqdmFqSlQ4MnQ5SHNTTWwxZjRIUXZpUmJVWXRHUXM2a2x3ZjIv?=
 =?utf-8?B?TWhqK01uNFRDVHMydlVsVC9SOXJZVXZYemdjdldrT1lMWll1RHlhRnUvQUVL?=
 =?utf-8?B?VkhhZDV6bHlJY3M2N0hIdmg2NElHNTdLUE4yYkVVTjFuNUN3Q3U3MndseGV2?=
 =?utf-8?B?TmlVK2V1WkR3dEcwdkFxUWVGSXlsT200RUF4Ni9rTGswblZuMGx2TXRMZ0JG?=
 =?utf-8?B?U1hCNVFHcjRGcTJLN0JNYmw5UzV3MlhlNWFjNzFtTlZ1TDQwSkNITkdvUHRv?=
 =?utf-8?B?MGFjUWJ6R05nYmM4MTE2ckZPNFc0dGFmNTdsc2k1ZldUY0Yyc0pDRTBMS3cr?=
 =?utf-8?B?WWVRZy9RakVubHV6N28yZnJmNEhVNTVJZDd2WjNjYWhWQzc4enppZkMvRGY1?=
 =?utf-8?B?QkR1a0c5eTFqU2JqN3JNcE9laG9NSzBnYW9WQ1Jsc0ExRkVvcFNjZHQ5dzIw?=
 =?utf-8?B?a09xQVgrN09GS3ZiMEJ5azY1Tml5VDZGTERzbUg3ZzR3SXhKdXErRHAzTDNx?=
 =?utf-8?B?ZFlQS1JNVit4RWxRbHBQTTJkbXg2RlBTMElGejh1SkMxbEU3T2J6a1QxRVJ0?=
 =?utf-8?B?Y3plQmhGMTE2d3JwRDRuT01uR3RaQ3Q5Y3N4UkZ6VVBnNU0zaUVHcittTUtz?=
 =?utf-8?B?TlY5WHQ0Skk3YTc3dU9JZGo4dk8yMitSekFiRWhYUG1QN1ZpRFZtUXNxQlRj?=
 =?utf-8?B?T25uZDhFMWgveHFWQ0tWdGZiNjBRZGZBV0NKb3JueWdzc3FKLzd1cnZ1YkEw?=
 =?utf-8?B?dFF2KzFKVjIwMmJKb0UvYXhYVGdaK2xiYUNmM1dCUlRXWDNUNWUzbStoWVYy?=
 =?utf-8?B?Sm5ZQzNaM3N6dENuVHg1N254OHozb21xY2RKRnZhWmdOb1hucTdCSXZhM0lW?=
 =?utf-8?B?ZnZmaWtrU210RzdicVg2NmZYMHUvN1VtMW5Mays5ZzU4Qmg5R0k5RTh3RFRS?=
 =?utf-8?B?N1hLU0JzaWhmanhUeTFKSlUwYTVMdEEyMGpnK2ttNVMwVnJpSUlGb0M1b3Vk?=
 =?utf-8?B?dk5hbzA1L2N0VDNLRFVwd1pSWEhhZU00ZHVza1BJNlJteG9ZQVY0Sk5mRkpI?=
 =?utf-8?B?WHdCKzI1S2lqQkZJd3lJdERBMTRuRG0zOWhEQ3JUR3c0NkRmNVVKNWJOeGZ1?=
 =?utf-8?B?bDRsdXhhY3ZnZWpnNHdNazc1Y1dFTjc4MHM5ODJnYzh1RW53TERhVUJIaisx?=
 =?utf-8?B?ekU1czFUdFBjbEk3N0lpcitGVmJKbWRhazBJS3NWR0tHZXpld1d1Njc1TEdy?=
 =?utf-8?Q?X9ZF8By/zcq2xJWLGmp9El0GQsOTancE/mBCxcvcxo=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ed05e23e-4e7b-4bef-513a-08d9aec0e3f6
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2021 20:36:13.2474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: THfeTjFVo9SImhjPEMK4ela81KWCmlxVIs5WTrMNdzHzcoSYS0jDPyOWCOBtP41HenzuAsDDZb9YalkjTb0YMn6ymKdDehLfZWiSmlayrqc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4849
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/21/2021 1:16 PM, Alexander Duyck wrote:
>>> The easiest fix for all of this in the in-kernel driver is to just get rid of the
>>> "min" at the end and instead just "return work_done;". The extra
>>> complication is only needed if you were to be polling multiple queues and
>>> that isn't the case here so we should simplify it and get rid of the buggy
>>> "budget - 1" return value.
>>
>> Thank you very much for your reply Alexander!
>> It seems to work well!
>>
>> Are you planning to send it upstream?
> 
> No, I was just suggesting it as a possible solution. Feel free to put
> together your own patch and submit it if it is working for you.

Thanks for your feedback and work on this, I've prepared a patch and 
will send to netdev and intel-wired-lan shortly.

I don't have an easy way to test this one, please let me know what you 
think.


