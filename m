Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07B106911D7
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 21:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbjBIUFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 15:05:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbjBIUFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 15:05:18 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C4CB6ADCC;
        Thu,  9 Feb 2023 12:05:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675973108; x=1707509108;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9hNlKZnqwNHjNLsHhraVjzqL1XAHDVux7caBgz1yE20=;
  b=Yc+eSaw2PBqo3JOR+pij67S7FtyO258YSBFMOTxmYcHOygz/I5ExL20n
   Dk8ibw2z3CPEohe5hT0g1SiCP7epU4pyIEY/Gn8AwmiQ7bCmesVnL6a4V
   sLPfXM8k53HIKpOG4cEkAginLRrm3p9mAjt6Br9Pq/6tmtf13uP+2PGi8
   ibStXaZZEAJMGlPheeV4xC138FlCx/pj3GsllqXBzWw7AFYJaH0AgFec9
   pEo/jBz4CzaFhZCfsXKGn3g/Xnlw8mgqqW8oT7RK2ylDj7+svwq5scdM/
   t8h0h+2jH5jWDsbUaJyYE/eacCiRRqDR709tyB2PohNlWQerRzklTjpCb
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="394830963"
X-IronPort-AV: E=Sophos;i="5.97,284,1669104000"; 
   d="scan'208";a="394830963"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 12:05:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="698160835"
X-IronPort-AV: E=Sophos;i="5.97,284,1669104000"; 
   d="scan'208";a="698160835"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 09 Feb 2023 12:05:06 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 9 Feb 2023 12:05:06 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 9 Feb 2023 12:05:06 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 9 Feb 2023 12:05:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FiVTfD28QOrQcL0ukQg8Mi3e5pRzYGo4LtoPi29j5dOTVh9Rwe7OrGF9UtDK7LGW2nVPVqIgpv7aHmh8hPc3E3F1YR6DLe712i1xJzz7hRu57f+9fHyuyQNM0aIfWlFatX9WTAhi2NXVQDMX5AjedL2SkA1rJgjaNYs2SWY7QrAZFiZF6IHy8mu/OmKMKC7Y1tcuNZenCTIfv0+sLG9RQuoFbzu9fl76yTK7sTtghNmFJ6GLaIBmc2INoCEuSZptt9ZSipdtawn5BXGVLxOlPDqDl+K/8O+94CNgDiKDk5i+IT0FuvQzNkv7dQFRHhAT7e8UG4tyXZayIqz3Z2h7aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LnlyWSgPOVdg2ahrDkaffF1A0vIRB45Fcpme2XSNQ5M=;
 b=SoZRdpuxwOYYBuU8XSKe539r133jQznEW56apwELZ2wiHg1FzKqtiDLUgNcICemK11jCljfkLLh3G5mrj7GCsKLgwcjvtO/CSBRj2A4u6zYj8aRJ2MAILQyqO+v/lpKxKMQUnHhzTAONBeCtHDJcQEbZiR5cKEbXe3ir5RnLDrDewLDEzuwJPhbnqv1ePfznOmqavcYne9NjRa5HmRwo2qokwfn+RS+tSyiGqf39KpMAgtPiEqlFv6kxub672lKV7h5XY8rwGsZRIs4MV/LgoTq3gmCkkHqIFUAICyFr4iwcs94PCzG/demkUPSBYY0awbvjFns5rNXa05hqrjW/NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3624.namprd11.prod.outlook.com (2603:10b6:a03:b1::33)
 by DM4PR11MB5424.namprd11.prod.outlook.com (2603:10b6:5:39c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Thu, 9 Feb
 2023 20:05:04 +0000
Received: from BYAPR11MB3624.namprd11.prod.outlook.com
 ([fe80::e816:b8cb:7857:4ed9]) by BYAPR11MB3624.namprd11.prod.outlook.com
 ([fe80::e816:b8cb:7857:4ed9%4]) with mapi id 15.20.6064.036; Thu, 9 Feb 2023
 20:05:04 +0000
Message-ID: <6db57eb4-02c2-9443-b9eb-21c499142c98@intel.com>
Date:   Thu, 9 Feb 2023 21:04:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH bpf] bpf, test_run: fix &xdp_frame misplacement for
 LIVE_FRAMES
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
CC:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        "Martin KaFai Lau" <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230209172827.874728-1-alexandr.lobakin@intel.com>
Content-Language: en-US
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <20230209172827.874728-1-alexandr.lobakin@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0193.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a4::6) To BYAPR11MB3624.namprd11.prod.outlook.com
 (2603:10b6:a03:b1::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3624:EE_|DM4PR11MB5424:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b8a36f2-ca16-4dc7-12ec-08db0ad8eead
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xToF3zUmoOIu2t2KwL0fuXetRrXy9bVoBCRq6rm77MQVOETbxYLXs1NxXMiAJlKYYpwt5ZwivXFHMfO6QNvalckkLgJKe32zLQWBjxk0RawJL+I7bCzya/agQQceWHGew9oOi6kUIA0sjCTQbOv7kKA5HBiIlUpTSoFP/aAkVHA9aPjjMm1AM+XJXzM/oQtk6Y0Cbv7LdfLfRXi7dK3iSdTnZUx3oS0jeJ1CYFGBhqSLZhW66G2SCE+KZvjBYg5qR8sYJj0N2rkigJWbpnFDMrkNyWh2+G0y2DfBaWWRTaueWdlMp97nA6l9prvtEOcAAJ0pJ7bk3HqbV9kM3sRiPqRBpW8pqLHYJqrGv6LOMXa+uOKbLT7uK9EVN20LeTbJNEyxx149GYIJXZpqRd3OELp8cTPtCc78eVG+26kwe2DIFhImFNDjFBjdJKBh4jEo1gdOijTLTyJHHDVXZ1zJXPkd0R0v+hejeDntUEVUZd/yoJxTzjaPx8JinzB5Vz3tcWsxafVGCbkJEFSd734B3xTVb96LHYUvTIibECyWlpXLjI+UUG+d9iuSWVY2dfEoBWn9Yu0oiRknD7qw5H8ALKUFtw6T9d02sWgCZnuvSmatDE1G85zU5yYjDq7lIJl+U+7Hyw9E1jKrsdG1BGBbJySfJzbeNOuux+sIZ9D0ToD9xHE8QpmSoA5ScvRrRMy121wt/PVL2kNwKoMzyKt6dIqDllK13GeGGEsvRkTBt94=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3624.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(366004)(346002)(39860400002)(136003)(451199018)(5660300002)(26005)(31696002)(7416002)(86362001)(186003)(8936002)(2616005)(38100700002)(6512007)(110136005)(54906003)(4326008)(66946007)(41300700001)(316002)(66556008)(8676002)(66476007)(6506007)(6666004)(478600001)(36756003)(6486002)(82960400001)(31686004)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Rk4zYm92QjRZTnZDUEhSbnJvdGZUdWVhM0xiS0tXYWptVFFnbG1DWTRMTVAv?=
 =?utf-8?B?di8wZG5EUjFGdUExTHV6eFh0MjVBMVVpT1JwU3c1Q3pwZHJFQWNzTEdCc3Z4?=
 =?utf-8?B?c2FscWovUlhlWlBGOVFLZFdWYmJjZ0ZzNGkzTmdQbytTRVdhMWFHZ3NIazBC?=
 =?utf-8?B?RHpJQk5Uc1RDQW5DZ2xIM1FwKyszcEFLWnI3cEhSUTFNdWJIMzRqeFBnM3J4?=
 =?utf-8?B?SmFDMmxEZ0psQ3J6N2p3N1Z4dGZPRVY5M0p6cXFzZ3VEZjBVMGFhZDRBUTZq?=
 =?utf-8?B?SmFEd2VUNlNLNTlJdUljMmk5K2NkcXNDT2xKSVd0N1hHSWdWTmJMeG1zSGsr?=
 =?utf-8?B?dzNDUjJaM1hJUkplVXR4TlZibEIvQ2FYV052TkpKQ2JXT1FWaVNNd2EzZEE0?=
 =?utf-8?B?eEFKclBib0MzTWIvd3RQLzMyWno0UzB1Qk5FTG9VbVhudFZkc0IxNktzaWNi?=
 =?utf-8?B?UGo1SHNUU09ncW9zdE1JN3I2SmZEN0hXZEZQK1hDbytHVm1rcVcrWXNVckxh?=
 =?utf-8?B?TWdxVG9EMlFZZm51Nmp2bGZEdFo0eUhQcmJsK1Ftdng4Qnp2VzQrQXY2M2Ex?=
 =?utf-8?B?QVpubzE4czJScTQwRElsUjhNT3Nna3VSRUpYM0MrSW5ObVR1Wm80Ym0wTFox?=
 =?utf-8?B?M093VEVYaEFJcEJRRy9CMmhYMzZzRjZqb1FudVhqVzJicFJ0WUhGRWRzNTB0?=
 =?utf-8?B?NlZmQ1JNK1QyMWJxbVRGSFBUc2NyODZrdzFsUDJ2SE5QMlVqcWRNMzNyUzFX?=
 =?utf-8?B?MkZYRytkNDlpazdsL0dMYmlNUjVsWW40WktFbFd0akViZU9zSkNIWWtxU1N0?=
 =?utf-8?B?T0V6MVZUNzFzVm91dnJKYlhlcWdLRjE5NlJISkUwWGg1NTVuTTVZQkFENDUx?=
 =?utf-8?B?bjZZM3BsbThDbTJKb29wRmRTR1NnMytMbEpGSVI5RVVsczdZRW5oY1lWckN5?=
 =?utf-8?B?S0lMcE01THJFKzh2eEZpMS9DMm5TamxRTi8rVCtTWFlSMStVUGJ1Qm02Q0tt?=
 =?utf-8?B?MXYvR3lSZWNubm03Yk1yMEpoUWhaK3pYVlVVU0V6QTQ2bkRnd2tCUVJXbE4y?=
 =?utf-8?B?RkovR0M2RHFNWW5SRG9CTlBuYU9WaW94a3ZRaVdYZEVaT2htaG9iUk9FQnh6?=
 =?utf-8?B?RGcvUzFkcW1neGhjOGFjQ1V1SWRxcmg5cXpkNXZOWnVjNlhUbFdOVmgxM1dV?=
 =?utf-8?B?RFFERXYzbzFUV2VVemxrZ3RBQ3BwWTJHQkZJUTVrVXdvQzFOYXFCY3JLT1N0?=
 =?utf-8?B?aGI4WDRGRmd3clhMejZNSUdEY0VTTnFLY3JwYUthVk15VzJOTS95M0p4ck1H?=
 =?utf-8?B?SUdNTk1oVVJRcEFpRzU5N0dZRVBKYkc1bTRhTUV1emZsQXdKQVhUR2pYaDlp?=
 =?utf-8?B?a0VKRk42NEJyZW9NNjFXVUx0ZzZWZ3ZnM2xZRGZObitHYWZheEJYMk1TT0xs?=
 =?utf-8?B?K3RLbmFteVFlUEEwbDVzc3BlTklvM2c2M1hLTlVvUmcyV1ZqT2tCd0thTmZu?=
 =?utf-8?B?RUt6WHdrWUhBMHk1SVM2MlBxV2VBYU5icllrTzJOdXBnc1ZtUWVwQjlaODNN?=
 =?utf-8?B?ZjlPU3JRNVoxSk1ON0xFSWZ0TmxOamhuRXVpWTF1REhRQXlvK3I2WkRUVzM4?=
 =?utf-8?B?d2pSeXY3SnU1aWJnRnY0ZXZYdWYvQ0FUTGxQWFFJbE02RVF1ZytwaDI0ckt5?=
 =?utf-8?B?RHBpRVMrbkZtM0NsUUsrQk5taFV5UEQvUHdDcGJkUEhvZWQ3MVFKQVNqR2lN?=
 =?utf-8?B?TUUwM0VuN3ZrMHhMczZnVlliWmxqWlBzTG5JY3JXNjZXYTVTY0h5ZHhsK0Vj?=
 =?utf-8?B?YzJSMXVKWU1QMDYwOG1SbzEzdzNvRTU1LzJ1T2RNMnJuSGwrcmFTSG4zUVBl?=
 =?utf-8?B?SG9kRDhXb3VtZHFlN2xoelJIY2NiSWM3MU5HRkQ3V3VqeC94YkUxeDJBVGsr?=
 =?utf-8?B?bDVmbHJYUzRLeXN2UTRiWWp6bm9Oa0REc01MUEh3ZkErbklRV1NPTmlrSDdJ?=
 =?utf-8?B?S3I0bFBLQUFIdG9wU1FHRWZ1UjBnQ3NTcUFGMklFK3NmZG1pUkFMNTNpZVNJ?=
 =?utf-8?B?ZkJCZEU5ck5pOWwzL1NRNS92MExnYXZSaSt1R2gyd1ppREZiTjVWOGxXeVU2?=
 =?utf-8?B?ekU3ckJGMW5pZTErWTlRNWFpbnV5aFQ5Z0tSQW00L3pkbkhLc0FJd3FGSCs3?=
 =?utf-8?B?dFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b8a36f2-ca16-4dc7-12ec-08db0ad8eead
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3624.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 20:05:04.0653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SBm4s+CdmEXXH9D2leZanGz7Ll4c1H4QyZX55KQSTb4zx56WeVOeVuXrU9zg6jCoay3ZF5jbuQC0++QBWVIkyRZGTs9GcRtHPW0thFyqDo8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5424
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alexandr.lobakin@intel.com>
Date: Thu, 9 Feb 2023 18:28:27 +0100

> &xdp_buff and &xdp_frame are bound in a way that
> 
> xdp_buff->data_hard_start == xdp_frame

[...]

> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index 2723623429ac..c3cce7a8d47d 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -97,8 +97,11 @@ static bool bpf_test_timer_continue(struct bpf_test_timer *t, int iterations,
>  struct xdp_page_head {
>  	struct xdp_buff orig_ctx;
>  	struct xdp_buff ctx;
> -	struct xdp_frame frm;
> -	u8 data[];
> +	union {
> +		/* ::data_hard_start starts here */
> +		DECLARE_FLEX_ARRAY(struct xdp_frame, frm);
> +		DECLARE_FLEX_ARRAY(u8, data);
> +	};

BTW, xdp_frame here starts at 112 byte offset, i.e. in 16 bytes a
cacheline boundary is hit, so xdp_frame gets sliced into halves: 16
bytes in CL1 + 24 bytes in CL2. Maybe we'd better align this union to
%NET_SKB_PAD / %SMP_CACHE_BYTES / ... to avoid this?

(but in bpf-next probably)

>  };
>  
>  struct xdp_test_data {
Thanks,
Olek
