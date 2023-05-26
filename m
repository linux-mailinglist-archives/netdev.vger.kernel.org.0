Return-Path: <netdev+bounces-5521-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D0F87711F8F
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 08:03:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86E5C2816A1
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 06:03:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C2AE3FDC;
	Fri, 26 May 2023 06:03:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC3F3C00;
	Fri, 26 May 2023 06:03:20 +0000 (UTC)
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 214491A6;
	Thu, 25 May 2023 23:03:05 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34Q26v9A025797;
	Thu, 25 May 2023 23:03:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=mP2MNDn5ChDL3ITPBwoZbZTtsMZ8l8vZWXEQRN1wqcY=;
 b=nzi3JswaUJ7oduZ1B7TJNyb9E/d95gFOZWfUhfwX94wKLL3CM5qaFvRTsVJc2Mi7nppx
 f3O3cJ3kExIEcTWM1EtMy8/Exu4Dqz+k+MFrerP2ST3EGeTHdWhnW0m9sZYgLDiaOTzu
 X0sKgqsxPeKdspZaSsk5AMJIUNA91uJxAcuHDxngvrIzn93HKtFL+Kd3avHdkwJ7giob
 m1O6TPkzzZAFn1cgTGmylw1a3adDaqSAzXGD4phZMwbd7Y+JDyY0ELy1IqMWCB+R44Vl
 Q19xzW+Lbl7EjcQNUiYvy9ahP3DMwcHf+zbUCLfpQVldoo5ib3qBr3TpV7574gEp7mWW HA== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3qtkpch66g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 May 2023 23:02:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FOzGpzuu1At8BEM7rAJysjLG3ELDCLRjdD0FgHxPCNCxJuPV7SjUkq/fo5vP5DLD5O1EvZybFTX/1IkoNAlQlPQjx8henNtTME10wUd35wVpYwmZyhsac9k5EXsbvtA1MINdfUtLHfW+HSgAk8zGQKYWwrr7bT8xnP1C1lu1hKacQUbfy6TuZ7Q26nXTOHlnLK7oMjOASIVN4BENUFDi/6R0AGafPFVtpmyDlkPbiPsbyGbwVDcYrVC29YF12IhLx7MGcwjUZXdD7kGtPB60s/+Q3u0vr0LEJ4CTY/2eprjFu/z4jPbLX4uDtjLy7J863iINQhIndusgEaPNOh27mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mP2MNDn5ChDL3ITPBwoZbZTtsMZ8l8vZWXEQRN1wqcY=;
 b=Sivh802wKvGN/ZOrFeOT9kxLQ7jdB1859/QXLPo3nPF7WA7KzEUhRw5v8TjlTs8g+HQd/HiJj7b8Hb8kxf6R9CFhI6g4qCeRgViHNp1cVmRksHLn1jmE02iRfXlYUcBQkfocxHJDGw/W4483ByTuibSVmeFl5kp5+W8ZS6AHSyEBv+/pmoQKPfA93XbFxmCvOddizJgFz7axwSe5ggcEJudTdQC0O0E+r94HP4x+kOss/TqxIj12PD8MKz/KdcMhpyna4C0uJaibVPTVup/Bu+qWaQ7HtESSiwkyBjc9pQdrlHflukulhzDYdhDRLSLFsQoi3DT0JUJnEdWSou9bNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4871.namprd15.prod.outlook.com (2603:10b6:806:1d2::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.18; Fri, 26 May
 2023 06:02:57 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::bf7d:a453:b8d9:cf0]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::bf7d:a453:b8d9:cf0%5]) with mapi id 15.20.6433.016; Fri, 26 May 2023
 06:02:57 +0000
Message-ID: <924ee916-b7a4-a17f-30df-2e5ab4251d3f@meta.com>
Date: Thu, 25 May 2023 23:02:54 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Subject: Re: [PATCH 2/2] bpf: test table ID fib lookup BPF helper
Content-Language: en-US
To: Louis DeLosSantos <louis.delos.devel@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc: Martin KaFai Lau <martin.lau@linux.dev>,
        Stanislav Fomichev <sdf@google.com>, razor@blackwall.org
References: <20230505-bpf-add-tbid-fib-lookup-v1-0-fd99f7162e76@gmail.com>
 <20230505-bpf-add-tbid-fib-lookup-v1-2-fd99f7162e76@gmail.com>
From: Yonghong Song <yhs@meta.com>
In-Reply-To: <20230505-bpf-add-tbid-fib-lookup-v1-2-fd99f7162e76@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::26) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|SA1PR15MB4871:EE_
X-MS-Office365-Filtering-Correlation-Id: 8412addb-3eed-475f-64a1-08db5daeda91
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Kcl+8cOT1/Au+fjFnJsvrDX9Y8v4VI2f9IDk90f23ycH7Efbv3WTpiIJ02EChbapOdVsN0x9fzSfyaCKQKcR9hFW4JqXxc/POldyImk5+1wVEf+qO+GhqtCoomYrKvE1Q1qYVRaKYWITiujrUj3aSPDiwN8LNHyYRAtXJ8TNGbJNldKrHT8AJ56S9ZGLI5J2WhydPJtdSWdbGxZ5K2BDmidompuZQa8jakEEtEqvFmK1ZDZ9Y6uOI7Tdjj0enY/Cy53eHpAbQO9zviA9HOzPdaQ5Zh/4eygOFAMQFpZ48jv5+GCqVxUrY83bW6y/h5o8fKq9JjHhHPlSVu+rM4pK6RexWM1XrL8fbdjqw6n1uHW2pOy+6eHtH+ppdxmmsn5jpHv8RsFG6AqLcIePu9JygDA0Rs6ERjePct1ayFy8chw9wBMKHcC91XRX22SLMW78oZFwxy06zScrtsnpPvYBuK2V/FUH+Z6XkRJLoBrrns36jITNmmOP7k/19L30M/QzpNXX+YbULV/zUiAhrrU8RxAGWhVNt8LfW4NyssVTgvXPBTattxYf7g6wdqXEUy/vmZ5PZ16aJR6cOoGpF++DCsnb9VJruDUyyT5k5mDgIKMeNEhdqorzyIVzFQfPpApLO9PpZlqQLJQ98sycIpr57A==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(136003)(39860400002)(396003)(366004)(451199021)(38100700002)(8936002)(8676002)(5660300002)(478600001)(54906003)(6486002)(316002)(6666004)(41300700001)(4326008)(66946007)(66556008)(66476007)(36756003)(2616005)(86362001)(186003)(2906002)(31686004)(31696002)(83380400001)(6506007)(6512007)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?cUwzWVFGRzZKZTVHSzU1Y2RRR3YzMHBSbUdFQTRJM2NieHJHNThFNGZLRE1O?=
 =?utf-8?B?M3djYUdPNEZma2FabHZHWDFuUGFwUlFudkR0Unh5VjM4cWx6MDcvR0haMjI1?=
 =?utf-8?B?RzZoMGlpblAxMEpwQy83OWVaeEtCN1p0QWo1NFVhV2VDV1gxOXg4Z3B2Wmln?=
 =?utf-8?B?N3dCWC9SMkgyNFdYZFZBNW02VEM4MFgrNFNHK3Y3QitFNGNlK3g2eGhGTUk3?=
 =?utf-8?B?WEpmbDlORUZpdW0vTEUvbHEzUVlqZFlFcmUyUURxejVZZUdWeHQ1SEw0QWx1?=
 =?utf-8?B?WUhQSXhBWWIzZU9NNWc3UlJmZkY5WUg0R1FYZkdhb1BZbUNOR1hFMGVEY0R5?=
 =?utf-8?B?bzF2MDgyc2hmdVNucU95MGFxdjREc0VsSHFsWnU5a3p1RGtKQm94ZUJwWG0v?=
 =?utf-8?B?ZjJVSE5ndmhscFRtZFJQMitQV3FTZ3hZWG9HOW13MmRyRUFrcWQ0cFdNRGdM?=
 =?utf-8?B?R0ZTdlovUEJndll4MEVGeC93ZGQ0TkxOMmR3T0lQRjZVMTBMRlNiRHBSbjln?=
 =?utf-8?B?UktuUGQreDUwaHRaSEhVcWxNYUhZc2tDSTdDRlVaeHlxdzljWlR5dFlyNGlY?=
 =?utf-8?B?cjZsd2lvOWo1Q2cwd3c5b0JsZkQ3Z09PU3plYzU4dUV5WWhuS3Fod3kyeHhS?=
 =?utf-8?B?Y3NoOEt5TG5Mbmk1K2RjZ2VlTVNBRjRweHNNVUxaWlVpTzJPOWNIZ2tkQ2Ft?=
 =?utf-8?B?b2NiL0E2ZVdNMFlnd1k3d0tDbmZ0SHR0N3NCTmJ1Qjl3RWtTSTZZMzRrZzFm?=
 =?utf-8?B?ajI3R1dMRktDVXdUUkZEdTJTZEcrQmZvUE5kS0xDd3J0OFBzNUVoUTBRM3BK?=
 =?utf-8?B?RmJtRVNGeXU1RUgvOUhiRG44TURFK0NJNVhUMEFkcDVZMVk3SUdVS3BhWlRO?=
 =?utf-8?B?L3diNHcvb2krbmhPS3JVZzRQdVpjcFk2dFk1UkZtMHozK1FPbUpIejd6ZmZ2?=
 =?utf-8?B?RWNGTEhDRnp2azJVaEs0RUYwbEtYeTUwUUo1L0wzTHA4bUp3d2VMOFZmK3Zy?=
 =?utf-8?B?bVVTRkhDY3VIeDhMKzQ4Wk5FOUx2aElvek1vMkNlZk95U2xFdVczSjJucXZ3?=
 =?utf-8?B?cE45clBtSVVLWDFHRTZBQmFnanllaEJGdW9QOWFhbHYwd2ttdStLT3lMVndL?=
 =?utf-8?B?UzdScWNvTWNZWEZjdXpsVjJmTys1Ky8yR2pYR3F1TzJRckJNMS9samNvYkpu?=
 =?utf-8?B?ZStBTC9uWHhjZG9FaHpxOU1XYmRIbmtNZHdIaS9RNThWejBnR3BJUngyeGN5?=
 =?utf-8?B?UnJhbnZQbllZNGQrbWc1VTNjalM4T2xBRFQydEp2MlBmUGJ4RmU2QWd6WlAx?=
 =?utf-8?B?OStuOTJCaTA4dXpxU3JhY0RsRlJMVVVhYzh0SEpHTDJ6RGU5OHBiM2NzM2RC?=
 =?utf-8?B?VEZsZnZFalRvMUtzN2pJRC91VTU3WG9GSWdYTEloUDBQdVZubFQ3NWRUQjlG?=
 =?utf-8?B?Qk04cE5paHFHZkFnbEo5WjZocUlORHM1K2NTRnNEcUdHVVpNejd3THplYmM1?=
 =?utf-8?B?UUV5cmVzcTgxcm1jZHpaWnJ4V2t4SnU1eTV1VFNCNVpsL2pQbStrSmk3SGZl?=
 =?utf-8?B?TEJpb1Y5eWc3Q1d3Q2JNR1ozemtOSkszbERPYUJMbmloYWtadXVVd212QmJ5?=
 =?utf-8?B?cEJRL1M5a3UzRWRVdFBwVmVtL09obGMyOHVlY0pVNyt2c2Q1L2ozdEJ5SUJh?=
 =?utf-8?B?Uys1bDRzTWo4NUwxRDBKVThFOE9YUGN4YnZCano0Q1ltenowWVFiellRdHVm?=
 =?utf-8?B?Q2kzUE5RV3pISTk1UTlyOVppSDRGcUl2ajJMVEVDazVwdGdCZUR4WW54cURL?=
 =?utf-8?B?R2NDQXN4cWNLbjUzYUJtWlY5WDVtZDZZU2hhNzhwSDJlQTZsd3h0MDhKOFZr?=
 =?utf-8?B?Z01yR3p5aGdsMVVIRm1uR0RwU1NDYnRJcEltVmgyOW8rL1VUNkRZUnJJRnNV?=
 =?utf-8?B?Z25nQVNIb0w2VllOZ0d3TUEwdzF3cVhJcmp2T3hLbGFmc2lWWDEvbWYyZVhp?=
 =?utf-8?B?aExGd3lMSVFGQlpPTG9lYUdXSXlRVmtEOUcxNVEzQUlzckJQNUF0dTc0ZERI?=
 =?utf-8?B?TExndThQbzYzWWxFQmtYc24wTWJhZzA1WEF6T0Z6c2Q3RVh5OE1JNlBXaEVD?=
 =?utf-8?B?M1krbk8xOWJTblVvVVFOVWtRUjNLbi9paDdqTDhxbTVMUmFqNFM2TXpDR3Na?=
 =?utf-8?B?aEE9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8412addb-3eed-475f-64a1-08db5daeda91
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 06:02:57.7127
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: esWJUHI/IOx8/G9QaBW/9mq1greczwT2W9NTA0M/7AuQ0ZDLNAgV3Sxm87fXQ00G
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4871
X-Proofpoint-ORIG-GUID: iZKrMKYQeF5r_ehJx-p9MeNpTZisbFI4
X-Proofpoint-GUID: iZKrMKYQeF5r_ehJx-p9MeNpTZisbFI4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-26_01,2023-05-25_03,2023-05-22_02
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/25/23 7:28 AM, Louis DeLosSantos wrote:
> Add additional test cases to `fib_lookup.c` prog_test.

For the subject line:
   bpf: test table ID fib lookup BPF helper
to
   selftests/bpf: test table ID fib lookup BPF helper

> 
> These test cases add a new /24 network to the previously unused veth2
> device, removes the directly connected route from the main routing table
> and moves it to table 100.
> 
> The first test case then confirms a fib lookup for a remote address in this
> directly connected network, using the main routing table fails.
> 
> The second test case ensures the same fib lookup using table 100
> succeeds.
> 
> An additional pair of tests which function in the same manner are added
> for IPv6.
> 
> Signed-off-by: Louis DeLosSantos <louis.delos.devel@gmail.com>
> ---
>   .../testing/selftests/bpf/prog_tests/fib_lookup.c  | 58 +++++++++++++++++++---
>   1 file changed, 50 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/fib_lookup.c b/tools/testing/selftests/bpf/prog_tests/fib_lookup.c
> index a1e7121058118..e8d1f35780d75 100644
> --- a/tools/testing/selftests/bpf/prog_tests/fib_lookup.c
> +++ b/tools/testing/selftests/bpf/prog_tests/fib_lookup.c
> @@ -1,6 +1,8 @@
>   // SPDX-License-Identifier: GPL-2.0
>   /* Copyright (c) 2023 Meta Platforms, Inc. and affiliates. */
>   
> +#include "linux/bpf.h"
> +#include <linux/rtnetlink.h>
>   #include <sys/types.h>
>   #include <net/if.h>
>   
> @@ -15,14 +17,23 @@
>   #define IPV4_IFACE_ADDR		"10.0.0.254"
>   #define IPV4_NUD_FAILED_ADDR	"10.0.0.1"
>   #define IPV4_NUD_STALE_ADDR	"10.0.0.2"
> +#define IPV4_TBID_ADDR		"172.0.0.254"
> +#define IPV4_TBID_NET		"172.0.0.0"
> +#define IPV4_TBID_DST		"172.0.0.2"
> +#define IPV6_TBID_ADDR		"fd00::FFFF"
> +#define IPV6_TBID_NET		"fd00::"
> +#define IPV6_TBID_DST		"fd00::2"
>   #define DMAC			"11:11:11:11:11:11"
>   #define DMAC_INIT { 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, }
> +#define DMAC2			"01:01:01:01:01:01"
> +#define DMAC_INIT2 { 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, }
>   
>   struct fib_lookup_test {
>   	const char *desc;
>   	const char *daddr;
>   	int expected_ret;
>   	int lookup_flags;
> +	__u32 tbid;
>   	__u8 dmac[6];
>   };
>   
> @@ -43,6 +54,18 @@ static const struct fib_lookup_test tests[] = {
>   	{ .desc = "IPv4 skip neigh",
>   	  .daddr = IPV4_NUD_FAILED_ADDR, .expected_ret = BPF_FIB_LKUP_RET_SUCCESS,
>   	  .lookup_flags = BPF_FIB_LOOKUP_SKIP_NEIGH, },
> +	{ .desc = "IPv4 TBID lookup failure",
> +	  .daddr = IPV4_TBID_DST, .expected_ret = BPF_FIB_LKUP_RET_NOT_FWDED,
> +	  .lookup_flags = BPF_FIB_LOOKUP_DIRECT },
> +	{ .desc = "IPv4 TBID lookup success",
> +	  .daddr = IPV4_TBID_DST, .expected_ret = BPF_FIB_LKUP_RET_SUCCESS,
> +	  .lookup_flags = BPF_FIB_LOOKUP_DIRECT, .tbid = 100, .dmac = DMAC_INIT2, },
> +	{ .desc = "IPv6 TBID lookup failure",
> +	  .daddr = IPV6_TBID_DST, .expected_ret = BPF_FIB_LKUP_RET_NOT_FWDED,
> +	  .lookup_flags = BPF_FIB_LOOKUP_DIRECT, },
> +	{ .desc = "IPv6 TBID lookup success",
> +	  .daddr = IPV6_TBID_DST, .expected_ret = BPF_FIB_LKUP_RET_SUCCESS,
> +	  .lookup_flags = BPF_FIB_LOOKUP_DIRECT, .tbid = 100, .dmac = DMAC_INIT2, },
>   };
>   
>   static int ifindex;
> @@ -53,6 +76,7 @@ static int setup_netns(void)
>   
>   	SYS(fail, "ip link add veth1 type veth peer name veth2");
>   	SYS(fail, "ip link set dev veth1 up");
> +	SYS(fail, "ip link set dev veth2 up");
>   
>   	err = write_sysctl("/proc/sys/net/ipv4/neigh/veth1/gc_stale_time", "900");
>   	if (!ASSERT_OK(err, "write_sysctl(net.ipv4.neigh.veth1.gc_stale_time)"))
> @@ -70,6 +94,17 @@ static int setup_netns(void)
>   	SYS(fail, "ip neigh add %s dev veth1 nud failed", IPV4_NUD_FAILED_ADDR);
>   	SYS(fail, "ip neigh add %s dev veth1 lladdr %s nud stale", IPV4_NUD_STALE_ADDR, DMAC);
>   
> +	/* Setup for tbid lookup tests */
> +	SYS(fail, "ip addr add %s/24 dev veth2", IPV4_TBID_ADDR);
> +	SYS(fail, "ip route del %s/24 dev veth2", IPV4_TBID_NET);
> +	SYS(fail, "ip route add table 100 %s/24 dev veth2", IPV4_TBID_NET);
> +	SYS(fail, "ip neigh add %s dev veth2 lladdr %s nud stale", IPV4_TBID_DST, DMAC2);
> +
> +	SYS(fail, "ip addr add %s/64 dev veth2", IPV6_TBID_ADDR);
> +	SYS(fail, "ip -6 route del %s/64 dev veth2", IPV6_TBID_NET);
> +	SYS(fail, "ip -6 route add table 100 %s/64 dev veth2", IPV6_TBID_NET);
> +	SYS(fail, "ip neigh add %s dev veth2 lladdr %s nud stale", IPV6_TBID_DST, DMAC2);
> +
>   	err = write_sysctl("/proc/sys/net/ipv4/conf/veth1/forwarding", "1");
>   	if (!ASSERT_OK(err, "write_sysctl(net.ipv4.conf.veth1.forwarding)"))
>   		goto fail;
> @@ -83,7 +118,7 @@ static int setup_netns(void)
>   	return -1;
>   }
>   
> -static int set_lookup_params(struct bpf_fib_lookup *params, const char *daddr)
> +static int set_lookup_params(struct bpf_fib_lookup *params, const struct fib_lookup_test *test)
>   {
>   	int ret;
>   
> @@ -91,8 +126,9 @@ static int set_lookup_params(struct bpf_fib_lookup *params, const char *daddr)
>   
>   	params->l4_protocol = IPPROTO_TCP;
>   	params->ifindex = ifindex;
> +	params->tbid = test->tbid;
>   
> -	if (inet_pton(AF_INET6, daddr, params->ipv6_dst) == 1) {
> +	if (inet_pton(AF_INET6, test->daddr, params->ipv6_dst) == 1) {
>   		params->family = AF_INET6;
>   		ret = inet_pton(AF_INET6, IPV6_IFACE_ADDR, params->ipv6_src);
>   		if (!ASSERT_EQ(ret, 1, "inet_pton(IPV6_IFACE_ADDR)"))
> @@ -100,7 +136,7 @@ static int set_lookup_params(struct bpf_fib_lookup *params, const char *daddr)
>   		return 0;
>   	}
>   
> -	ret = inet_pton(AF_INET, daddr, &params->ipv4_dst);
> +	ret = inet_pton(AF_INET, test->daddr, &params->ipv4_dst);
>   	if (!ASSERT_EQ(ret, 1, "convert IP[46] address"))
>   		return -1;
>   	params->family = AF_INET;
> @@ -154,13 +190,12 @@ void test_fib_lookup(void)
>   	fib_params = &skel->bss->fib_params;
>   
>   	for (i = 0; i < ARRAY_SIZE(tests); i++) {
> -		printf("Testing %s\n", tests[i].desc);
> +		printf("Testing %s ", tests[i].desc);
>   
> -		if (set_lookup_params(fib_params, tests[i].daddr))
> +		if (set_lookup_params(fib_params, &tests[i]))
>   			continue;
>   		skel->bss->fib_lookup_ret = -1;
> -		skel->bss->lookup_flags = BPF_FIB_LOOKUP_OUTPUT |
> -			tests[i].lookup_flags;
> +		skel->bss->lookup_flags = tests[i].lookup_flags;
>   
>   		err = bpf_prog_test_run_opts(prog_fd, &run_opts);
>   		if (!ASSERT_OK(err, "bpf_prog_test_run_opts"))
> @@ -175,7 +210,14 @@ void test_fib_lookup(void)
>   
>   			mac_str(expected, tests[i].dmac);
>   			mac_str(actual, fib_params->dmac);
> -			printf("dmac expected %s actual %s\n", expected, actual);
> +			printf("dmac expected %s actual %s ", expected, actual);
> +		}
> +
> +		// ensure tbid is zero'd out after fib lookup.
> +		if (tests[i].lookup_flags & BPF_FIB_LOOKUP_DIRECT) {
> +			if (!ASSERT_EQ(skel->bss->fib_params.tbid, 0,
> +					"expected fib_params.tbid to be zero"))
> +				goto fail;
>   		}
>   	}
>   
> 

