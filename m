Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73097436E5F
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 01:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232072AbhJUXln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 19:41:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:9378 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230500AbhJUXlm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 19:41:42 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10144"; a="226639770"
X-IronPort-AV: E=Sophos;i="5.87,170,1631602800"; 
   d="scan'208";a="226639770"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2021 16:34:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,170,1631602800"; 
   d="scan'208";a="445543178"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 21 Oct 2021 16:34:01 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 21 Oct 2021 16:34:01 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 21 Oct 2021 16:34:00 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 21 Oct 2021 16:34:00 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 21 Oct 2021 16:33:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xgfm3OSDtg2P5KoXQ7OwHrHIvYEs0bXVlrN37AsdTxrLaN/o+bs0Fb5xEbBm2qhF3YTujCBZpJGm8q3wbf8JwKbXgPdKfox1QRbRAJNCkx1Oi4F9yX02ndKwqMkL+SCqiCvJz92Zeo3BL8LShEaTvNQ9GUXkS8iIRfrXisDAr+du4GqSzPU20i3vEv5TE8sy6fZwzr/gb+fzazJ615ajzqtkLBd4H0NowltBUnNfpKKTCiksja/R1c0NshRU3lIy9T6yn+EUFW9h/Qm8QbWCeVKE+ZPgP38r3zCyDE85ga8fl6EIjfak5Iq5lT0WUOvzPI8M+8EqhRTLKqxgMYYJFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AvuBk6fqa2bdjSShInLHxa3MZyngqEKlCRUfNgfJ6rw=;
 b=I4zXCKElzOIFhsPVsCnIRrdfSnfPkL3+1BM9KkVjw/JWNlaN4WA+dTqpvkO6J1sey0a9B7Lml/G6DVxGaWhpPf6ZDw4eL1dtti650s+YjY9Exdi5EldWE6O4DMeLJq5KBqUbiU4N4YSBigboywZurlocDgMK2cfadabY0By0Lt8QtRmTpY1qgyM0DzLK1G6K2lSRjFMmT5+UYcmSoqQ2nEpH9HKcK2zcapq4ffwgHAlkMepvfKeJE6UrnBfa4GwTLflaD0NiLn+hZHEYjgcq6UM65I/L0wQeuhBTgOao5eXKe5OZ1R7SWsuyDcw0NsCxszYYzdDg3Ef7FGHjUZiIiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AvuBk6fqa2bdjSShInLHxa3MZyngqEKlCRUfNgfJ6rw=;
 b=aPbqjtEUhPZbMGKcKxs8haaPCcv5i9/1h/3lpYO9VEdlWKnbZKsYc7TyWblB2JTx7X0sEbXUMbLOWa8+LgEv58vJz/2ICyriAyQ3PnSezGU3o+Au5JMnXQ+TS5I+6vUKCJLBmViHhmOlI9cXRPhHJ3rjb9cnsz7pYaYA2d9VkIM=
Authentication-Results: kryo.se; dkim=none (message not signed)
 header.d=none;kryo.se; dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by CO1PR11MB5009.namprd11.prod.outlook.com (2603:10b6:303:9e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15; Thu, 21 Oct
 2021 23:33:53 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::3166:ce06:b90:f304]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::3166:ce06:b90:f304%3]) with mapi id 15.20.4608.018; Thu, 21 Oct 2021
 23:33:53 +0000
Message-ID: <e2fc87c9-570b-546a-5c7e-867b26b9840e@intel.com>
Date:   Thu, 21 Oct 2021 16:33:51 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] sfc: Don't use netif_info before net_device setup
Content-Language: en-US
To:     Erik Ekman <erik@kryo.se>, Edward Cree <ecree.xilinx@gmail.com>,
        "Martin Habets" <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20211019224016.26530-1-erik@kryo.se>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20211019224016.26530-1-erik@kryo.se>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR10CA0013.namprd10.prod.outlook.com (2603:10b6:301::23)
 To CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
MIME-Version: 1.0
Received: from [192.168.1.214] (50.39.107.76) by MWHPR10CA0013.namprd10.prod.outlook.com (2603:10b6:301::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Thu, 21 Oct 2021 23:33:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1cd9d212-6e61-4d96-d260-08d994eb3e8c
X-MS-TrafficTypeDiagnostic: CO1PR11MB5009:
X-Microsoft-Antispam-PRVS: <CO1PR11MB500999B6BE397E0C485E013897BF9@CO1PR11MB5009.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:586;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NXW3JGo7GUFmlooOXm1L3L2ahUmgt9o4CS6DScHpXCuPDWnYWGyCJmm8b/H89kb13W0U5txgIM5JNLWwcmp/+IWtD7wd90RoPtBlWkgX+CpExB2K8JKHvz3bDIr2eQwJZjC78BMgbKgqqCawFvReA4zhONTVO3u+yGK5Y+ewwWp8CW+NR13DUh9ccly19p5zjBJdVAQtpPgNCS1QlkE+Xzjc0ImEeq1KyFBFWiWn2wpjQuDtCfsdxvQgLBLhNLBquZoJdlb+NnT6HwaYqfG6VpYErz3dHt5Us8Kd1vhDQWbt8K2DMMzMUUzTUfsKMpYhzqzaKO/2FR6aRSs5VCkrhEWMvVU/wYIW0h+lxCkPf+iQ4vB9q1xemmdHEc5rvcCZuwK/dBOmdD78VDgsBb+QujSJ3CUi8HqLBkPLiqcU3UcNfLPO1PQKnoIA/VN0FRceIixNywpxMUIATy9sDfXRFayVuoVv+DsV+zTpzTMSk2EhOO8ZMuZSg9aPC32IrNT68DZb8miIJU6ST5RjR8+Hj5JUKYA7o+G9TTUnUkh4GQbfEaUyotWqv/vuucTJ6hV57d7hd4cgo+xP861CRghcsKDxI6U+zBJIUg/uBjnAusGz71pQlvsLVX4C9dKrER0OOC3w5qEgJ/H8Y8lFeNEH5MMfCA4HVC+6nBPDNwAeluzUYoUaK/fqj+vugztTaJ0MjPjS4GlbVKHfPkcvhYLDAmboHWC5U2GSgn4rCAgK7FkM7d981JHb8l/NS5UsgSj/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(4326008)(8676002)(4744005)(5660300002)(83380400001)(6486002)(31696002)(110136005)(36756003)(82960400001)(38100700002)(2616005)(2906002)(956004)(26005)(44832011)(66476007)(31686004)(16576012)(508600001)(86362001)(53546011)(66556008)(186003)(316002)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c0RFdmRBZDJvUm83NVRnbWY5OVltb01acWc2dTZaYklyRnA0YXA4UnU4N0Q3?=
 =?utf-8?B?TU0vam9icTM1TE4zdTBNZWdZZ0tRN0RQZUsxT3ZWYkdXYVNlZ0hBY1RPc1dx?=
 =?utf-8?B?Q1djRDJSRVRmakhoL1ZNUjM4cUlBK202bDdoY0VxRjFpc2lXVXY5b21JTitw?=
 =?utf-8?B?Z09nMU5VRTdzcSt6Q1J6dkZOMDFTS2hjcFJJRXViNFZ5UGlNZUpnUGdYaXNG?=
 =?utf-8?B?aG1PaXJUbVVhTkF4TkEyeXI2cVkxb3hjb2k4RUtURzMyYjVBUk5XbmhTZFFC?=
 =?utf-8?B?NUxoMXRIUVIxNUdhMVBsNlUrejU4Mk5WbDJTdXZId2hFR3RkQytycml3dXov?=
 =?utf-8?B?eWZMT1RLbnQwNm1OSk1tM011SEhCMHRnLzVSNUVSM3p5d2g3SEovM25iTXZC?=
 =?utf-8?B?eFhSQnZBZ2FZbjgyWlBGYmoxaGRxK1pJNW9rbmVlejQ1MkNnR1NNTjE3S2Uy?=
 =?utf-8?B?SUdvZmdRVmRZSG1USy8xUEFaazBCb3cyczZHaVgrNnBTNXdNTnlqK1lyZkEx?=
 =?utf-8?B?MzlpcG4zRHhIanU5dmVOeEVtSGdqM3NHb1B0V20rUmRjaEpqSG1ha29QZnlx?=
 =?utf-8?B?b3VDeXQ3a0RVQ0txcWx1WjA4aFZSUnMvQmhkY1RiZ2JSN05PeUtZL2Q1amFH?=
 =?utf-8?B?dUJtbDdvYkt3TC9iL2h6R2ZtdkJaU25qelZ5UzMrbXQxbEtQeGhFcnlldEhP?=
 =?utf-8?B?eUR1T2ZrQmZQVUZiVkFqbzBtZjN0MUR4MjN1N1FDeXVaWWw0T3ZUZVNKZ0N3?=
 =?utf-8?B?WG9taVhxZUF4ZkgzRUxFNEdtZXB5S0ZPN2MxNmc5WWdrN3grTHpSaFJRZDZa?=
 =?utf-8?B?ZkJlZ1dETzZKZzJzakpWUUtPZlU2bnR1T2ZaTmV3TWY3SlJoMnpKQjl0STBW?=
 =?utf-8?B?NlNKeHppZHBPMkJzQXd0TFl2S0t5WlF0YlZCREo2ZjFObFhoRXZFMUF6OFFQ?=
 =?utf-8?B?NGNaQUY1NEdCeDd3Z3h0eGlPK0FXbk9iVE5Dd0trNmloSlBtbnFxdzQ3d2hV?=
 =?utf-8?B?ODlpSjVrQmpLVGpnL2tpMmp6ZitzWXUxUlJhWlB3N1dkYkVUZm5MUW9VUFNZ?=
 =?utf-8?B?Y0lHZHRVaVJMSFlobDhWV2FOWVNxY0dIS3pnM0NGczVFdTFHdzNEbVFjWFNX?=
 =?utf-8?B?ZFk4VzFRRGtMQVVLWmppcjM1QkEyTkdKbjVnSmpwVXlqcE84QjlyczBnczZi?=
 =?utf-8?B?U0p0MHU3Ykx5NTY2WWtsUDdENUpHMGF6WHJqVHl2MTFPWGJOMHF0WXRxS2F3?=
 =?utf-8?B?bU1rVzMwU2NpRG1kdDBTRWNqTUUwTVB0MHgwb1NOYTJtYWRGbUZvdms3ZHc2?=
 =?utf-8?B?aFJDMGVwSDV5V3dQQmNTOVBzeVUyUmg3V3Mra21HdU4zTGVRRzhoUmwzWHJX?=
 =?utf-8?B?bVZndFl5UVJBOU1WSVFwaVRrWmU0RlF1WlMyWHN4bXBvS1Z6YkFaZDgrWW5Q?=
 =?utf-8?B?eXpsYjdNbnV6S0VaMHFraG1qaTlrUUtycXJnU3dyK1REank4TUFMb0M5VSs0?=
 =?utf-8?B?dHNqZ3hLdm5WbGRjWXJHVldvR1ozNmVxa0ZJV3pkUmZPZUNGenFXMGRPMHRI?=
 =?utf-8?B?a2JiUXUxalNSUEZZR2V3UEdTcUFibldVZ013MzBlMlFSWjFWUlp0a0R4TnNa?=
 =?utf-8?B?RkVpUEp0NGcycFdHclhuNzYwRlZZUXJ3UktaU0NhWVdGdFp2ZVJRSnhFYVlO?=
 =?utf-8?B?STRiRXRMcG4vUVgrMDlCUmo0MVF5M05hak15WS9DTWx2VlNPMTNXQW13aHNj?=
 =?utf-8?B?QUlXbUxWejMxVjdlQzg1bzdldnA3UUFtNmx6N3NOR0ZRdDBpd0wvbmtQbVc4?=
 =?utf-8?B?SkIwMTd1Zk5iMjVWaXo0aVV3V2c5WWFIN0k2TkprSGhkRWZIRjdSUCtnTVA5?=
 =?utf-8?B?Q2hzVHdObXZEcUR3a1BZNGdVZmcrTnZjU0tIUFRHL1U2M1B2L2JBQ3MrTVFm?=
 =?utf-8?Q?X7buBLDRTpsY1Dzh6k1v4Hs23Mi6BdY2?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cd9d212-6e61-4d96-d260-08d994eb3e8c
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2021 23:33:53.8362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jesse.brandeburg@intel.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5009
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/19/2021 3:40 PM, Erik Ekman wrote:
> Use pci_info instead to avoid unnamed/uninitialized noise:
> 
> [197088.688729] sfc 0000:01:00.0: Solarflare NIC detected
> [197088.690333] sfc 0000:01:00.0: Part Number : SFN5122F
> [197088.729061] sfc 0000:01:00.0 (unnamed net_device) (uninitialized): no SR-IOV VFs probed
> [197088.729071] sfc 0000:01:00.0 (unnamed net_device) (uninitialized): no PTP support
> 
> Inspired by fa44821a4ddd ("sfc: don't use netif_info et al before
> net_device is registered") from Heiner Kallweit.
> 
> Signed-off-by: Erik Ekman <erik@kryo.se>

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>

