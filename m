Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45A25433A67
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 17:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbhJSPcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 11:32:47 -0400
Received: from mga06.intel.com ([134.134.136.31]:52329 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231532AbhJSPcq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 11:32:46 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10142"; a="289396343"
X-IronPort-AV: E=Sophos;i="5.87,164,1631602800"; 
   d="scan'208";a="289396343"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2021 08:30:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,164,1631602800"; 
   d="scan'208";a="567009982"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by FMSMGA003.fm.intel.com with ESMTP; 19 Oct 2021 08:30:33 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 19 Oct 2021 08:30:32 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 19 Oct 2021 08:30:32 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 19 Oct 2021 08:30:32 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.48) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 19 Oct 2021 08:30:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HCqHSFmHaNEhKgFyBhkBAAn5cyXFUIgFAq5DWjs/9S313DUHmkueoE3z2d/F3KXoGPZQQWm3qmupVQ3SMeiVYiOCSGnL0BYv8LYnahNefLfNmdp+bMac9Qg9irPtxlyDQewfOltGjCfdB14yzPF3fS9mEiqwcGqm4T+Ol4N5RbWmAixQpw8WbPLaNP95QLZwvbIyyYr0k9eaixfRe7CdULgdaUAwjMANrjf8V0vjfnwQsCWas9ZxVoGhPMqoDvJyyKb2VmtB6kKLt8Ogf1GCNfyTipEtSIn6gBBfnX87DFouYPjijmCSCeP/VIfV+xLrjJrp6DhJFCHCXNaOAu2zrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=csi8hF6R3dtA3XfjIBEzROCckLxj2GZUNA9ifJrEfG8=;
 b=bWqDYl3GqSu6+ULbcaRj+rETCK8CtllKKCbeZ5EnShgqadOhtn6dIfipGe35vugryyIO5A6MTvXQRCVBWF5+0Y+bSDd84YVPBk6DW8U94fdNTIYH0CIRXKHzndKsJr0WpNaOPp2qR8FBTf36DKRosCTtDKgx40dxDL8TWzTcjZCw0dgXExbdWvvR9UJ/GpfBfQmfuPHEzCJE8NbW1tk7weWwG5bKQEgg0DCmViCxwR6lBQaqW6C4wEHePR6LJKz14fCXJd2QIwHlOHfKpz+WgsxPzjskNa5luDMpp7fZw25H8WL+vlClWi2RbzIxZ8BHjrvVcUzbFztV9bFJ2cN40Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=csi8hF6R3dtA3XfjIBEzROCckLxj2GZUNA9ifJrEfG8=;
 b=RwOCfC94ITO8qcULCwHhkANeJCH6VXoD/JWv5EXDyXrY9FMQnRd+Q7KcKUo3HJ/wjYftdAjqV2I3YinIWARTtNVlRtnRJ5fLAEj9AYvXpGkGGELhhkhD7AK5V2WG2ic9Rra3rYWnkRljNTKXHUir8f8v1+9rjgXKWI4550lwbhg=
Authentication-Results: linux.dev; dkim=none (message not signed)
 header.d=none;linux.dev; dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by MWHPR1101MB2319.namprd11.prod.outlook.com (2603:10b6:301:52::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Tue, 19 Oct
 2021 15:30:30 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::3166:ce06:b90:f304]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::3166:ce06:b90:f304%3]) with mapi id 15.20.4608.018; Tue, 19 Oct 2021
 15:30:30 +0000
Message-ID: <5f4cdd35-680f-b5f1-25b4-dcd27419edf0@intel.com>
Date:   Tue, 19 Oct 2021 08:30:28 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 1/1] ice: remove the unused function
 ice_aq_nvm_update_empr
Content-Language: en-US
To:     <yanjun.zhu@linux.dev>, <anthony.l.nguyen@intel.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>
References: <20211019091743.12046-1-yanjun.zhu@linux.dev>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20211019091743.12046-1-yanjun.zhu@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR19CA0078.namprd19.prod.outlook.com
 (2603:10b6:320:1f::16) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
Received: from [192.168.1.214] (50.39.107.76) by MWHPR19CA0078.namprd19.prod.outlook.com (2603:10b6:320:1f::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Tue, 19 Oct 2021 15:30:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 728a01f6-184e-4f7b-448c-08d993156239
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2319:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1101MB2319F073326AB1357924A7BC97BD9@MWHPR1101MB2319.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: haRtZPaLi3ObQGkVqU5A4o6yt7lGHvqbv4l4G9XhYj4CvHpfKnp+0IT/CdHipUBFXU0ckv9/wG/7srm4OA+B7F/cIY+wcxGX6LPy+5FciFssUoleIDZ0LjRCMuR+3SmItQqnbcMENC2WYLNGZmV51fisDX5eirOoKc7Ju24Vzyv3jiD1rrKu3j4iJV1ORet0NKzBYEI9fxhfXoyZO8uP7fj+tHFU+RKuMu5v1uPfcEs1XBd+G12Y2fsJWUjROyKyivHqNtJxD6qKBAaXgiqQVxnCY6xgxfJ3+brGy/EBVULnzMh29YcFGejEbtvTOFnTlYUQIEcwMRojYzMfNqOnxJRJY7YGxjHl3XbSEZ+6JzQ70CG1AP86RHtgbm2JcF/jh5Ex1TonbFrcoHhMIHNjKXxmRfYMVoDHo5oSMpxVHRFQ1UVhMusk+XbMumwOUdg9nCx09GzdaXTO614+TupAo4qHimvSreeucupBLPDC2yjKoUCbiTEkg+9PZVXYtkfWqzlhAFJrf+/mc8AUeqMbzCaZNtUwi8rdtH+8x2p743E4SI/ENZVNjn9S6JYOrQ1f7Wj26fem+gsRx58bCQZ1vvGJZYpVT35AT/w4lJf/1duKRwB21aKLoM2ixvnTLYQvpaNuqWZFtDZpMc5Gnv/tJ3gQAr/p+bm0pvKSxwVY/UOmJ/eZy5GtZV+vtTGSsm94i6f2ZYfwc9qzZ3kC2OHc2hpZonyo9rI63t7G8puu7sg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(956004)(186003)(44832011)(31686004)(2616005)(86362001)(2906002)(6486002)(66476007)(53546011)(316002)(5660300002)(558084003)(83380400001)(26005)(8676002)(66556008)(82960400001)(31696002)(508600001)(66946007)(8936002)(16576012)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WXlzYmRCN3VudXNsZlNHQ2VVZnZhN0J0T2h1ZTRDYVphTnVwQkczM3RmNzRn?=
 =?utf-8?B?L01OenRqNm5UUTBUSDlnYXd4SGNXYmRYcG1zN1FGeTdza1AxN1NEU1BvN0x0?=
 =?utf-8?B?bGhqVFJoamNuemk2MWtQK3FpdndxZ1EzbExZbnNNK0R5aWV5YlRtYVdmNVIz?=
 =?utf-8?B?NTN2d3N6bDNVRGpyS3Z6Q0N1bkxoaHVVZU5Cc3BUYzNWZlFoYjlVOEs4SjlN?=
 =?utf-8?B?c00yQUIwZE9iQjk1dnhmTzFycEJKWUVMK21Xb0pXNGVrM1laaWNlS3RXamNm?=
 =?utf-8?B?ZzRzUTN3QWg0SDlCT1h3WmNVTFF5dzNWU1YwZWhWclNtbzlBdDVoWjBYRU44?=
 =?utf-8?B?WE5RWWxXM1Q4cGIzQTM2bzZpd3MveEpiK1k5MlJZU2ZZalhTT3phUWxvNWUw?=
 =?utf-8?B?RHRFR1RmTUQ1Q1BqbjdzMTZVZlBTRUZuWXF3WFRuakNrUWNVU2lSZUtEWjcr?=
 =?utf-8?B?SU9vZXU3L3RWY2NrMXhGb2E5L2p2UEFVN2RSS1hyRCtPMEJ1c1NjV0gwT2J3?=
 =?utf-8?B?amRybUovRDZNemNsc052Qk00SW1ML2hyZEQ2eE40OC9NT241TytrOXRwdzZn?=
 =?utf-8?B?NjV6V0gxaG8wbnU3eFZHS01GbUp6aG1MMTloallRUndlOXJMNzhuWGJOK0tC?=
 =?utf-8?B?NUlqRkZVMkJaSjI5dFA1aDBQWjBmTFNOazM3T1pVNDB4OTFHWjN3YXFIVkNo?=
 =?utf-8?B?blNNYWRxSlA2M0FjeS9VZDIrb2EzRWhNdGxHQTA0bW04NlU3UEdlUXBqWWky?=
 =?utf-8?B?aVVqam5RZlNHbGd3VFJRMTFjZTlJemd6T2Mzcmo3aHJZMC9kZ1o4ODdmQTEw?=
 =?utf-8?B?OENHSGJJUitCM2ZDa2pyaWVScEkzTFFRYlF1TEVQRVkzRVhmR1ZFem9ubTZ2?=
 =?utf-8?B?ZXBJNnFpcU9YUmRnZ0tKdWZHODNPUDhJcHM3cHh4b1NJQ1dERG96M2VzNTBp?=
 =?utf-8?B?RnlwQnZ0ZlFqQzYzWEF6K0d0eEJDQ1FCdGJndGpMeXliU2c5Z2xnTUJGVCsx?=
 =?utf-8?B?eDVSK0s3ZTI4Y3R1NkFjeTkxRWNGZFo0OG8xaTlzMUNaY28zRG82YllxK3VE?=
 =?utf-8?B?VXQrRjhEbjBjSzNnSHRYUXFpUmlEZEhGODd4QlFrdktaWlFURmlVSk9NMUpV?=
 =?utf-8?B?VHJUSmRLeW13UUh6R3hQVWlrWi9XTWVrVm0weGFCVzV0NlVOTnpzcXU3Tko2?=
 =?utf-8?B?WndTZHlRNzd3ZjBJSGpEajhIOGY2RWJraTllSDlRZkkydFFuSXNFbFV1cS9X?=
 =?utf-8?B?TzRWN3lUMTI3QWc4Y2dBenlVVm4rMmxWa2JHWTRiMzZ0ZFQrQ1lqL1VhZHdv?=
 =?utf-8?B?UGxXMDFOQS9HaXQ3MnNlK0dVTUVJU2QxKzhaMG9JSTBkQ3FvU1RpMlN1KzFU?=
 =?utf-8?B?VnQvaUpJdUtWSTl3R2xSQ3JpUnl0bVQ1MXc0SEtkYkxUWG1UZFNiOHR6TXd3?=
 =?utf-8?B?dGhJN0dNV3FIYzMyRDg5ZXRUdnFON0phMGswcStkcEtPNndWU1lYZnRzTUd1?=
 =?utf-8?B?YWVWWkVCY0JvN3p0MGo4aUI5MzJIMitDK0M4UjNiMGl2UW1mZDBIZFBMNk5a?=
 =?utf-8?B?WC9oaE45VjY3a1NqenBxTkRjRk4zWTUwYnJDMGFjalQrdVhNdmRCekx1Uisw?=
 =?utf-8?B?L0EwckljZG1SY29aNmlYdS9HMlpzSXJjbnl4a2NSelBVam91OURpdzlRZEN1?=
 =?utf-8?B?Y0JrWFQvRytQZzJDdGFGODBFYllIN2llU2dtMXJuZG1LV25DaUFmbC9ubzdE?=
 =?utf-8?Q?+BzMUQUp1UQYYX4C+wOG4pOZFb4RfG+3ik7cOOj?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 728a01f6-184e-4f7b-448c-08d993156239
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 15:30:30.2665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2kqTbgYSeMcRumAy3KbGiePlXor3N+1c+rA7F6Fs3y7xLeYMM6Te+OJPg8Y5FrLW5UFyknGt9gqL/zsP1A7EukgeKKZi8YJTrLWNi5lUKJU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2319
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/19/2021 2:17 AM, yanjun.zhu@linux.dev wrote:
> From: Zhu Yanjun <yanjun.zhu@linux.dev>
> 
> The function ice_aq_nvm_update_empr is not used, so remove it.
> 
> Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>

Thanks for the patch!
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
