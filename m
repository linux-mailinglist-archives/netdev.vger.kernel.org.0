Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 799E36947AB
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 15:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbjBMOGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 09:06:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjBMOGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 09:06:16 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99951DBF4;
        Mon, 13 Feb 2023 06:06:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676297175; x=1707833175;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AAljeAuHxNSFFUWl8kFK3hpDgGNWvewNMfuKOKJ7tFA=;
  b=GLCM3a3Vc5QzcPRpbHIJo0FzXMPvi4VaUFxXqVwfROZ9fEgVLM+tp568
   JLyHNimnEdMElNWcSlJDRfVrN7Dbyev5rRyRUWoLWN4Mq3HZmTkicU2/4
   e3X/2qgmVCohXAQ/S+ucvLeGiHdSbba05lqFY0yz0vJdzSHfKIBFcIv6C
   Ag8TynADzUTOwdsPcCxGW/wVLjxGXmfy+dFOR6WDyuEXwzeca0nTXghh2
   1kEetCLLsL3EnUPsa3XM/8I1mUTNchoAXWx1pcIpUnlRRJLFRIvog5ieW
   4XF/2DLUXG/8BHc7fDdN/r12cA03vOXfF6izmRy6CXDT3EqRf44Q1WKaW
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="314537439"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="314537439"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 06:04:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="997702353"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="997702353"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 13 Feb 2023 06:04:14 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 06:04:13 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 13 Feb 2023 06:04:13 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 13 Feb 2023 06:04:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GeUjySTyxE1y0iZCO5OVgUkL4fe7EbAdfoO8PLxa1jxS04/zU5X+T9AU54KaajKlicn99dDrKlTS1GjHMNdgm4zp5Yyf1EKcHhX97sS6nLNEgUne4TJoeGJsTtN9LwB52fDAbakdpZNUdsCvE2Xtks8tfKso/ma2I53bHVTOHyAga56ij4u+Exl1kJCiDXxKaD8H81+6fPVbNBpvHHxF9yR19swdNY6Fcd1kYC8Dzuhu0JaDCU3bStiDrniXCAc5Bb+bjC1fDO6m6aPx8amPtNxyL5i8koQ1CRflkaXMK1ORkAO9WpQMDcRP0qwOof5xPljQNQ7+hv+c/u1f6NiY2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WZfOcsSM9JfGlTyOrEaf2VvtPrkdu383LXB49PTNvOg=;
 b=Oe1PMFUnp3QPUd66INfHZNLYGywJAx4T2yAWDnT3IU3Tzqf4zRAu8P5DFakoRGshdfJr2nr/amZUE7wmtFny/RsYpyEwBaOi1K9QbtE0VUbUWkwvrH1FO61bOSmB3tP0MjnU9NHIfCXFnlHHVyNB5lrTcNt5kw3oucUINm7TjstYoDs03fx44V/D8VKN+tEvjU+/j1DLqbA61oHfbrxcPgUyXgu2hZuuJGKcvZRmfwM9qYU2mYVHnD/WfjhNC69lZ7l01W4RY6/n39Ooa20jCydla+AEqM+lCqEV/xqQh8ZQJVUpddSBujbRVvWRMZztKounnB07gYwjp6/v5s/uHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by IA0PR11MB7402.namprd11.prod.outlook.com (2603:10b6:208:432::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.21; Mon, 13 Feb
 2023 14:04:12 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.017; Mon, 13 Feb 2023
 14:04:12 +0000
Message-ID: <0f304e2b-f49e-a3c6-9f8a-0061b7665e5f@intel.com>
Date:   Mon, 13 Feb 2023 15:03:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH bpf] bpf, test_run: fix &xdp_frame misplacement for
 LIVE_FRAMES
Content-Language: en-US
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230209172827.874728-1-alexandr.lobakin@intel.com>
 <87v8ka7gh5.fsf@toke.dk> <8d3a9feb-9ee5-4a49-330a-9a475e459228@intel.com>
 <87lel5774q.fsf@toke.dk>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <87lel5774q.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0044.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ac::23) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|IA0PR11MB7402:EE_
X-MS-Office365-Filtering-Correlation-Id: f5911714-9730-497c-9d72-08db0dcb2eb5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +xMN+QviDAni24TrcpPGYEwDXe3DhBGpx5B+h04sjO7dtyeyJH3hp1Xpjf7N1cHWT5cAvENxGeijvcIevgrZg87APytkP96MHc4BxoBk2YQzSwsaBNIKIGi0qtsUMnP8NiYyMYLRqlZMxmHC6iQTs4g1DoJLK1AEz/74b0B/OmdWJH9mA50INhubGSXMkwlYVJYcbZDISwpPJ+7vF81cL6fBvS2uQh6MIFRzVfW4GdZLs8+InJynuImmYwUXZFaVLMpopzlNa5ETiAL+TdpiK6Jb13z1L6m3IqvaSgaiV8zuu7k1SuhFK5wj5gmO9pDks6LII0lDdF4x7h+Gi1yK1n6MpWGm742iKbfb5yExx3qf+BviTrnQJRVtTj/Jgid1ovCipZx8idGJGXJ4mx5eE09eQEpADwyFaWssEnCFNy0SoDQJqf9Bt1G8+IKHhN7oAmqjVYYSoIh/0wZ3KErf+s1EhESc3sN2wL8sBr4IYU6VibVTFauuXVVo8mnLpaf7Oul0Z1Zf+1mjrDann//neE8tX+LwL8iYZ6vUT4OsIf4oYMk4qYkpX55GGR3szVJT/DT2NH3GAkfbV8CuFJJtY3Az5x2zCf7s0ARzIc2mqLf7fmqheyXihu0HwcBIWKdDRUtJVkFO6BILcZVUYU2b5nBwUcjkgtmzgwPXE79ArmmE8C3YZQbzpWxPQPA7nz8qFHJgixMLfKARQjdN4uZ8QbA7VBobONuGdVbFSWkmZXc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(346002)(376002)(39860400002)(396003)(136003)(451199018)(31686004)(66946007)(186003)(8936002)(7416002)(4744005)(8676002)(66556008)(6512007)(4326008)(66476007)(86362001)(36756003)(26005)(31696002)(82960400001)(6506007)(38100700002)(6916009)(66574015)(2906002)(5660300002)(2616005)(6486002)(6666004)(478600001)(41300700001)(54906003)(83380400001)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cC9SaTFQRDM2ZTlWVkFrc21nRHZXTmV2OWZLVWJYOTREOVRkYXd3MmxMQUF6?=
 =?utf-8?B?bGx5WGpHZHh6blFjM01UWk9BVTBxYnlCaE1MUzRzNmFvclFYZEZXZGlzZlQ0?=
 =?utf-8?B?WlpjQklHZkJPUnVrNXJBVnArL0QwYzhpdWptRHNUTVFxZWZRTFdaeFBTdkhz?=
 =?utf-8?B?YjlBcFNFeHRZY1F4YnozbmRYNkJGUXJRQ1c2WHFsSEVwVm03V3FCSWczMi9u?=
 =?utf-8?B?dkFqZ25BQmw0OFM0RS9hTGd6SlR0TWtoYW9UQlJhYzM0Ry95bUhjMW1qdkdT?=
 =?utf-8?B?VkZhNTRTS1p5WkhEVENYWVhBd0kycUpJU3hoNkxVWGcvR2hkSjVLNUlaSW1s?=
 =?utf-8?B?OVRpdFZ3WDFBb3pUQTZjK054eFlmU3JRY0IzK0ViZzdMbitmY2ZTUzZvVmFh?=
 =?utf-8?B?eUFvd0l4aEwzZ2dKMGVka3JEQjZGeFlkbDJJdEVnSWV1cDZJalFPT1lyYXA4?=
 =?utf-8?B?czBTdjlzRGsyQy9sdFJ1LzFxWXhCa1U1YmhFYktxUVJZaDgwWGM0Mi80eXYz?=
 =?utf-8?B?cVBSd1BydmlDOGdabmRjdzAxOExEeVhyclkrR2t5QWFkTWQ1a2FrV0w5MjFs?=
 =?utf-8?B?SXFZZ0dFRVY3R29VWWJXaWhmUm40UTM0ZXNOK1FQVWNsdWs4alhyOEJicUp0?=
 =?utf-8?B?cVF0VExNYWx5VTluZjlDeUY5eEpXRmZubDlSckZsMXVUekZNZDl4bm1hUFl5?=
 =?utf-8?B?SUtHcndQNE1nc0tXcnh0TGlBUHdnQlVYQjZyZXIxVjNqbHpiWmNvNE1IZ1p0?=
 =?utf-8?B?SmVPa0ZIclIxMzdNKzlQMG16KzdwKy9TQXpJZUxrYVpmSi8xamI1cDBiTFhZ?=
 =?utf-8?B?WVdZQUNlR1dHN1ZTN20xcXNCRytaRmpWUHFEZkIrUW9KU3Fjb05mUFcxVWtF?=
 =?utf-8?B?UWhWek9kdnR0bmJ2dmdLbFEzWWdOZTZhWTdYN1BueUltVEh3M2EvRWM2aUJ5?=
 =?utf-8?B?K2VQbEE2ZU9TK05BV1VBMUZzeEJQQU9Qa3VydzNUdVFrSGM5MG5FVm45ZmQr?=
 =?utf-8?B?emt6MVNRNEtNTDJ5ZzBhMUIwTTlQWWswbTd3dGREVHNzajNUeFBycG9LYjQx?=
 =?utf-8?B?ZHFtZjZDK2lpU1dNTXNNdExUTzMrbHhxOExsZkhqaDVRSVR3Sk9pUmhOMCtQ?=
 =?utf-8?B?NE0yTmh4Sk9GZFFmSTIyNDR0NVIxWVdicCsrajlLbEdpbkt4ZHp0WTJ6aVI1?=
 =?utf-8?B?bEJTRTdHbDZHRkxFZHZpREh3bGk0eTAvc3QySTI2cXZjeVYxTVJaWlE2aE5i?=
 =?utf-8?B?YmhUR1dZYXVmQjBjNExjM3pJSkZscUkxemE4VEloUTNVT2o5RTM0aXFVTG00?=
 =?utf-8?B?L2oxcldKaHBtM0h4V3VzUnYxM2NZYVAwcDB1UnpPd3VPSWVDMWl1dGtGYS9i?=
 =?utf-8?B?WXRQUU55alFqQU1nZnRObXoxL2JyNVNldm9UVmRVaFpiN0lkeHhZM0JtL2tt?=
 =?utf-8?B?aFNnaWZkMFIrSWlIaHFvQ0dLNCt4cWlaN0lBVThGWkFOcDI1cDFqOHp0VlFH?=
 =?utf-8?B?dlVMREFjN2NkWjJVLzVYd0FYSE40aVJhbG9aU2M4OWZjdTVWZUltOVRPVTVw?=
 =?utf-8?B?SUMyZUd3SngweEdBaHhoRGwxa2tkc2w0TFBWOGpqVkQ5NzMwbklsUndjV0NR?=
 =?utf-8?B?WkM3MTgybjUyTUp1QjY3R3ExY0NGQ1c2MFY1ck82R1E0K3hEYkpEek83MnlT?=
 =?utf-8?B?clFyUG15MUJnWG1tVmZOdSttRXdGTzRPcjFMbndHL1hEM2ZCSmMrdFdTcUNR?=
 =?utf-8?B?cUIxc3d1ZmFiMnlaU3lQWGVqNXBKV2RvazM1ZmMxbEE4OUJmWDM3Q2pEMVU4?=
 =?utf-8?B?Wko3YnlBbnB3ZHFuVExNc3lsS01VS3NxckF3VE01SGhRb242VnprZ2NoRHQr?=
 =?utf-8?B?akZpY3czaUludWVrNEg1S1JMbHZXTGQrNEZvRU9LREk4VSs2dUQzYmpRM0dG?=
 =?utf-8?B?OWNibjlVUFJ2K1dwcWVzZ2drdHNKUEVnQ1M5bHJZcEZMcGgxTHl0aXNMOGdq?=
 =?utf-8?B?aVU5V09mc0JJZ3RaUG4yNnE5SlVTMVZPWE03ZVZPYkoxUmI5NmY0WjZUM2FS?=
 =?utf-8?B?SWU4dFVtSnhrK1duOHVOWDlwZEhkamk4bEFPbW1zaW96RDhzcklKT3M4bkdy?=
 =?utf-8?B?RGM2MlpDdjBSSEtUS2RrTWlGNXZ1M1o4QkJLd0pkb0xpS09QdTVuSDJWUlF3?=
 =?utf-8?B?anc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f5911714-9730-497c-9d72-08db0dcb2eb5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 14:04:11.9358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M2cjqCXXNN4S7HJvxa/JUQRxIi620SRHwok75rZ9hBRycCdlOv7gUdZALSM8BhUPfJP8ToWmiLdD6z94cqid9IYw2Z3nEWfqakTzRiYctLU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7402
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>
Date: Fri, 10 Feb 2023 18:38:45 +0100

> Alexander Lobakin <alexandr.lobakin@intel.com> writes:
> 
>> From: Toke Høiland-Jørgensen <toke@redhat.com>
>> Date: Thu, 09 Feb 2023 21:04:38 +0100

[...]

> both of those assignments refer to flex arrays, which seems a bit
> inconsistent. The second one works because it's assigning to a void
> pointer, so the compiler doesn't complain about the type mismatch; but
> it should work with just 'data = head->data' as well, so can we update
> that as well for consistency?

Aaaah, I see, you're right. Will do in a minute.

> 
> -Toke
Thanks,
Olek
