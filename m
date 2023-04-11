Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDCB56DE7DB
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 01:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjDKXM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 19:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjDKXM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 19:12:58 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B34E94;
        Tue, 11 Apr 2023 16:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681254777; x=1712790777;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RUi6BTcIPwTWV7UShYZqBEgHKSW81vrAS2UZNhz9KFY=;
  b=dDwP37oVnnv4CD/iskiolEPETbp9EmvFeV4/NZK/7PDHizuCtVW54Zr0
   RjMGPzmhfuvhomI/+sGUpnlmG6KvBT/RlZkkBuPCyuw5WLKwyQjDZmxsG
   Y0lNrRI+g3/MJaMNM38E/darKpRdRe4rB57S5PqbcLEt0b37RLeSr3Yjl
   tZqBhXZU4hQhxrWnwtzf9ebbEjyKjHDE2AyYAIPrINtEx+Bh/EOfyjk+2
   MNaRysrxaEeaLfHRp7oIiwD+zzsnwn+9qs1JmI/9YrWodDRAOZ2MIEVzy
   3iP6SS3etKGuzsOO1oG36LQ2AR1QFOGx3b9FOgFzMbtC8OLC+z/JGk9Om
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="430042835"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="430042835"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 16:12:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="719141813"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="719141813"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga008.jf.intel.com with ESMTP; 11 Apr 2023 16:12:55 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 16:12:54 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 16:12:54 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 11 Apr 2023 16:12:54 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 11 Apr 2023 16:12:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MKU4kiHaJcqX/QDwgrejLJbUAKWdmdN+3NJWM/oQhjPkCd/KpIemADMfRIBxcTlc4iur5RMl5ZdxYRX6WZa9PwCklFDCwiRiqed2YEDyTGUvO6NFOBesiNlArRakWcHUC2nhvU+/DtYogqHLE+WCTBngBHkKxSLzOFyz+gQFzPbk7BnTTmYbc3xQmYKI7i/BoUOLyNvby8hgMxRlF0b+Z+1OGnvNwtwuRbMCHrn6YLlvOWv29aR4noEVypMjek1wVig+v7bE7TH23Wgdp/QbiBBN6jmOjORmg8csljYue+i+ZLOSUcL2fia80eOUBPw9ZCoxbdfpZeZH9Vg02kykfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WWvuOgzUSEqhEbivi94P1zLkYUC9M+XXBPqnEYDqb8s=;
 b=Yy6jhumH3YlLPZnKJSxbokp3E44Kovkjz3r3Mf1sUHQf3ipnuD3HchlwH0LhCPeOxpTTwPQxWdlAnXNbIO+DoJ72n0fIdWvovaJm0pFkziRJpivEsPpwQOO8GzX+coXI+2Xy/0QbQF5mhiEaG7he3SJu5DmelC6l3r6eenoxhQh88ak5qcSfEwf12fLOzrrBWbaFWLVFdFzDuoXtJBG42g03pbxtoo3vVbf2TVbTrbBXi5TgipzSmHAFRSxpdM2qqvAc9JhezJ2wvJFPswmD1qYbfb6zWinlS7sJgkTlnMFklSmzamh6aXnHsiWlwkY9U1WihvBQfbtIr7nFePV1dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DS7PR11MB7781.namprd11.prod.outlook.com (2603:10b6:8:e1::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6277.35; Tue, 11 Apr 2023 23:12:51 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6ebd:374d:1176:368]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6ebd:374d:1176:368%5]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 23:12:51 +0000
Message-ID: <7287f315-0ac9-eef1-850f-8d8a91effe3d@intel.com>
Date:   Tue, 11 Apr 2023 16:12:55 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH V2,net-next, 3/3] net: mana: Add support for jumbo frame
Content-Language: en-US
To:     Haiyang Zhang <haiyangz@microsoft.com>,
        <linux-hyperv@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <decui@microsoft.com>, <kys@microsoft.com>,
        <paulros@microsoft.com>, <olaf@aepfle.de>, <vkuznets@redhat.com>,
        <davem@davemloft.net>, <wei.liu@kernel.org>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <leon@kernel.org>,
        <longli@microsoft.com>, <ssengar@linux.microsoft.com>,
        <linux-rdma@vger.kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <bpf@vger.kernel.org>,
        <ast@kernel.org>, <sharmaajay@microsoft.com>, <hawk@kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1680901196-20643-1-git-send-email-haiyangz@microsoft.com>
 <1680901196-20643-4-git-send-email-haiyangz@microsoft.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <1680901196-20643-4-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0208.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::33) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DS7PR11MB7781:EE_
X-MS-Office365-Filtering-Correlation-Id: f48ba0b4-a9c5-493f-a339-08db3ae2456f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9XDdJMm3t5H+a4DF2SuqPZJOQKFjIteLw/33TLvCtq9H/rFNb2U5D//wWlR8YNuRgw7LAXe1OBh2L/J3z/ue+idpNHOHSvyx95/oRir06Qs1bSD2Oz03YaaiwyrvTeNVXmFo+Bgvmc8xOuNYq01DryXB69RyGml1hjI0LYFil8RPxEalmuQKgEBhnQ2UFkXBmiUksfe2rsAnofTyQSASgOLgbHSGwjxCAteLuVwd49DanI4PfICGW8ZciSqmdIbxsZ2KM07ileNJp45LMZ+pR3l39r/nJShYaf9AMvRHpXXzi4tUH5QzEG4RT9AQjUH5l8/ZNFFcgBPS7Urf3fE6vIWiDQO3q9iUVwYJC31C4tYpjO59neysUa/RUWQxaYVxu5PfhV+Jc3V/emPJ8O9enHL9cMCRVxDwqN79oT115aExOFzx37uXint5zB+l2TLQqXWZHgRzlkSr5Zbm+spZGJLPjLATt7r3ZxLs8U9JU68QSiRvDTBcRMSb89h7Rw4fZHepXc5rqWpZG2UKrFwFWc77yif7MN+zAVG/rkuupIjKgzkl9feo28pZuMbYxp+pn1GVs6ONNeiEusZGD5n+NPnRRYtOo+CPipyEjYTUsiAryIgGEptu03tHgHU7cWeUBI1BHN/HDZgoVT+9yUIfpA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(136003)(396003)(376002)(346002)(451199021)(8936002)(2616005)(86362001)(66556008)(66946007)(66476007)(31696002)(4326008)(8676002)(82960400001)(478600001)(38100700002)(6486002)(316002)(36756003)(41300700001)(83380400001)(4744005)(186003)(7416002)(31686004)(6512007)(53546011)(6506007)(2906002)(26005)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?emZ3UmNnWlpQRWhDMW12aHZxTmpNQkt4a1ZvMUZ5OG93cXgzZ1pxUWZYYXpJ?=
 =?utf-8?B?Y0JVQU82K2ptcEV3K3gxWGRxd0ViRHIxSUVUUG9meUlCZEwzNncxRUFEMGRP?=
 =?utf-8?B?dE9NUE9ISkZMeER6QkZ3WmQyMTFVcS95SnNKbHRtZTlFb2JpTlp5bG5OV2tN?=
 =?utf-8?B?ZitwNDBMMko4ZDNiSkloNHhyVlZEOEhzYTVncTE4eDF1NVVrWTdVK0xiMDl5?=
 =?utf-8?B?T2Q0SWFvYTk1elRYQmlTbFVGT0doTXVUZWFUNmV4dkh2a2NKQmY5a1Uzdy9v?=
 =?utf-8?B?enh0aHBCemZ0Q1k1ajRScHF3TEZhZk9xbEZhangvNUViQUQ3aEhnTFpLM3J4?=
 =?utf-8?B?R3h0a0J0Si9hNjVUUUFuRUtDc3JlS0xwWGVPc0hmcHlTMk9zaGlhbSt6SkNX?=
 =?utf-8?B?Z043VkI0L3NHUGhuNnMvSjlaRUl1UGJzWEpLYWljQjdDdXNONXdnS3FFWHl3?=
 =?utf-8?B?NEkvdm85SXR3bFJreVZEcnFSbFVnZVNJMjJvYzNQbmpxK2FHaklWRDZlZ0Ex?=
 =?utf-8?B?cGtycktNNVZKM1NFYnNkWElrNEZPUVFyUTB3THdWWG5VdjgvTC9WMmM0ZnZ0?=
 =?utf-8?B?bWZ2L1RxTWxaYWk2Y29NSjRkQi9YNDdtTFY3VFE3NDBXVWhDVTB0aE40cGdq?=
 =?utf-8?B?QXpMQ08yQTBVY1gzaXM5dWtybzk1OW9YVEhzVW5xOHZXQ0VwNSthandzYUtk?=
 =?utf-8?B?aFVoUlVUOXZlcVQwOTFBaXhqY0xLbnRSWk5vbnVqUFlrSm53WWFNei9xQklj?=
 =?utf-8?B?NVA1QmFIOUhyb1FPTG5RcWJDUmVzd0Ezbzd4R2ZBR2Z5K3Y3U1N1Z0ZUWldR?=
 =?utf-8?B?ai8yc1Z3VDJxMWRjaHhDcnpxSHFHcFhSRTFVQSt0VDQySjk0MnZUQ0taMUFQ?=
 =?utf-8?B?N1NnOW1ESlZkY09hMHNpK0h3cGx3dEgreUV1N0MzeEs0amxDR0Z6NHNuVmlw?=
 =?utf-8?B?TGxUOG9UbnlJOVhlRndYUzFtSURla0dGVTdHR3pOaG42cEE1QVZSRVo2Q202?=
 =?utf-8?B?M3c2MS9hbjFqTkhNR3ZqMjB4ZGsxNDI2a09tcm5PS0FWdWNMZG56MXBxVW5D?=
 =?utf-8?B?WXYyZkJtaVZ0S3c3NGhPTlpldkVZUmlHZE9CNlcwSFVURE5ZS1RPOU0za2lH?=
 =?utf-8?B?ZTJneDludDZhQmVwNWwwaVdiWEtudU5zeGdLQ3ZkaGQydzBrVEhMVUVxRmRt?=
 =?utf-8?B?d0piNmdDMVVZL0Q5NnVqZVhvQnkzUDdWTDgrSjBSUWU4aHlZenMxMW1YNTcw?=
 =?utf-8?B?b2pDY0tEb1kyTU9SbjFvcHVTbVBFbXJxbGFxVm1zNWtRS28wcndOcXJYdEhX?=
 =?utf-8?B?NytVT3dlNDhCOWZoRHYxbFNzN09qVVo1RkNDRnFkbEdUeFQ2VlY4UFZjdXlU?=
 =?utf-8?B?M3h5cEVxWFFmazVNVmlhVHZJTXJPZDlrM3RnSGpjYVZBNXRVeWhtYWt5ZXdk?=
 =?utf-8?B?SU1xUjNZd204b3pqU0hnOGNMemMxZjJMOTRBeEVONDMxdmxQN2EyVUlZdU1u?=
 =?utf-8?B?SHBzZlI0VDloc2tuckNBZFRLL3ZWblVYa3VuZzFYMzl1eHRNa1h6YVFUemli?=
 =?utf-8?B?L2NtWkZxeWJ5UDVaTGh3U0lkMmlTRXQxWFNLV1FYZWZBaW5ReTRnSXRvN2RC?=
 =?utf-8?B?eS9MY3Q4eVpuRjJvWW5MMGdHWU1YdkVobVdsenFTVThtbXpGUUtsRUd3Y0JE?=
 =?utf-8?B?VGVQV2JhcjBWRW11SlNqYkp1dnZvRWE4MGpWUnpISEUxNEFCNnVuMnF4eWd4?=
 =?utf-8?B?K0E4bjQwc2haTTM1dUY0UlRyeFJQVGtmeWRtUS9taWdVdWZOakVSZ1RWUXkz?=
 =?utf-8?B?b21HZzJTTGl0YmYwdFBEYS80aXZ5TkY5OUFDdE1ESkc5VUdhWHFUOFJKQWVR?=
 =?utf-8?B?Y3hCeEp6ajZMTzJCUlFlYUdjSmRTWnB5SGNhNnlFdFpUY29rOEo1OE9jVDZy?=
 =?utf-8?B?N2NzTmU2MkozOFRMQlkvWXBtdHBlQk5UcnJiU21tT1doUE5vWHE0bUxMQmU4?=
 =?utf-8?B?Ukd3clhvd25sbVg0UEErZDJ6YzhhaEtSL290dEVrdDVjT1pJTzR2T1c2V3cw?=
 =?utf-8?B?aEUzVWN4NmhNeFlQc2ZNSWZNVGxEM0MrNVg4NFFmQVFIVjlScUhLdzBNb0ZG?=
 =?utf-8?B?ZWxRMW1tY3BZSVIvWUtrT3M4UlFmbC9tU1hlSDhTZS9qU1d1Q0YzU3plc28r?=
 =?utf-8?B?NUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f48ba0b4-a9c5-493f-a339-08db3ae2456f
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 23:12:50.7865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h6axBj7AtmxsBliIq0UHsrBhbZX8vknivhCX1bGZMzfG92N2XrxL1dq569s76CYBsPubfVnmcfnFtYGpANH2bEtq377+jlABP/2qIrgYozU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7781
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/7/2023 1:59 PM, Haiyang Zhang wrote:
> During probe, get the hardware-allowed max MTU by querying the device
> configuration. Users can select MTU up to the device limit.
> When XDP is in use, limit MTU settings so the buffer size is within
> one page.
> Also, to prevent changing MTU fails, and leaves the NIC in a bad state,
> pre-allocate all buffers before starting the change. So in low memory
> condition, it will return error, without affecting the NIC.
> 

What happens if XDP gets enabled after MTU larger than PAGE_SIZE is set?
Will XDP fail to enable in that case?

Thanks,
Jake
