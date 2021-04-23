Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3438B368A24
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 03:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240006AbhDWBCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 21:02:55 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52330 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235839AbhDWBCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 21:02:54 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13N0xKqo025071;
        Thu, 22 Apr 2021 18:02:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=vJYCEcfi87BJeyrGY61Vo8tSIh/QXDUeOTLrzVtv9RY=;
 b=iBrBRoo8HzRhGUjkbN74dcLy0OGGy5K+bKqT0Q5WrcvZNawMjXeuGnPJZK5MoVeOqRbE
 M+haYlZlRoKe/Sua1Icqk/EkD/McXcTXZyqgkrbK7MwunjYObnCs+g3PBeONXdzVOl+G
 wrH4X+HMGoa+RXhsIQSu5hqyccUrZRRHU+I= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3839usm4ag-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 22 Apr 2021 18:02:06 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 22 Apr 2021 18:02:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pb+OUuMoQjcM87LaVccAggdUU9v12oOcrJRhyagm96JJBY7tUu4kcwLSeEM/56FTGz1HXn5vkHVwF5mzAAv1GHRW6CZYb0gAKXQZkUDQ+A/FaBrjSpPTG81TsoxKlgxtc83uNxqDFgGS7Ki3BPzM1S+vE36kRk9k33smBNFT5yfSVC9rulCB4bi40BDD7asdVeVKHSTOwzc7SJdbi/0GC2nUT+N3RJkfyyyt36097Wwgs4hWs7op+7NvZHi1eRzrGVNNQog0fgPr7B5qr+EUiGvXXPm4QeiXsqaIlMjbQZ3aBi3bhwNQPV+3wkdawuED/abbDYQr9Z7kgsp7KCZPCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vJYCEcfi87BJeyrGY61Vo8tSIh/QXDUeOTLrzVtv9RY=;
 b=eCv4nETy/35cIwYpFTpi4uGGH0wpZyGhhD1ZDTrXg33YgM1coXyEsog68cjNmpv8eO2DnvZz0qIjNIWdC0KxiC/onoe4KTWSP0AR5THjLmtYNK5w/O5FyHbNjewlr9fArjQ62mdg3J706AkhE9bhMEuajswYC4tBk6pNWg6+wItBXYFw7CjLkUxOjQrz5ZpCFBCtxoWM0RYaXkLtwmhW0ghPWDZlGKWZsl06rdv/Zby3jMtrWQWmMovkW5Kf+cDLpmXVKsbPHXmVXgUARfpyZswCk6Y6PdWMie1netYEJKJTZLox9NNsaFsgzi+zd4+fs41ZGF4z9w4kziK2oVyBXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4433.namprd15.prod.outlook.com (2603:10b6:806:194::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22; Fri, 23 Apr
 2021 01:02:02 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.021; Fri, 23 Apr 2021
 01:02:02 +0000
Subject: Re: [PATCH v2 bpf-next 16/17] selftests/bpf: add global variables
 linking selftest
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>
References: <20210416202404.3443623-1-andrii@kernel.org>
 <20210416202404.3443623-17-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <f4a5d205-ad40-4930-7bbb-25d3f7f940bb@fb.com>
Date:   Thu, 22 Apr 2021 18:01:57 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210416202404.3443623-17-andrii@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:83f]
X-ClientProxiedBy: MWHPR04CA0034.namprd04.prod.outlook.com
 (2603:10b6:300:ee::20) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::17f2] (2620:10d:c090:400::5:83f) by MWHPR04CA0034.namprd04.prod.outlook.com (2603:10b6:300:ee::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22 via Frontend Transport; Fri, 23 Apr 2021 01:02:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ddf7322f-fac4-49d3-1f2c-08d905f36760
X-MS-TrafficTypeDiagnostic: SA1PR15MB4433:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB443355625DE97C81B9ED4ACED3459@SA1PR15MB4433.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nzuWsg2M8Z5Tpvjkh93yLMdiopRm+9MVfWICsf1fCth3NQJWK7Ckro+24CxzsNKGPl697u2eKkM7mgfYARoGDbxWt/IAepAxXeF8sFbwoSZPiw0APRPM6Uc9aboUHwz5M2OxVFccKcRKzKdP7ZqsRRhMFJcPh2L5zBQmrR/ZVEL6HKBJuGML+ybFut3+HmsJ3n/IMPuhdSQxXHHFDOkgJH77DNQgbiGP0G3LLzo1sFLaMyPpY6FALldYyfkeyIl5C4rbrSECG0cVO8g5bAEngrtazkak8rk31vnhq25zRDXRQrSPK06VldpFZl+XCi1hzod1qnockjmB4fdu97JHU3dIYjSgjX2c6XZI20FLQGsHN30eu8BRGb3/MeViVz67+nF4sGMxhMHcDyNEPRzbrPqss9cppUSWXz+ejiFINcQRndQsEaoIKScZOgmgIFBU5eXKMc+8VcBfdHWebM+GaQIjMt9Kkkx7Q016x7mvV4QvHOjeFcslq02ecPzGT9DqKyt1D5Q0spvnHLZ4Wbo4eo0U8eJVkecNm/d7oSOJNRIisDKnizj28aGG2joXNnVQFYiPHYmNWoOEjEYIQnnrGR7UDi4ClWr1jzbkP+RMkDWURTxepbSMGNGecdh1ju46cakxYxcTNaXifHp+QdgvGNqDT1TXNMVVaooTJlKr5y3k32p0MIRtumkYvoWKHpAs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(346002)(39860400002)(366004)(136003)(8936002)(8676002)(2906002)(53546011)(52116002)(36756003)(38100700002)(6486002)(31686004)(4326008)(478600001)(2616005)(186003)(66556008)(31696002)(16526019)(5660300002)(316002)(66946007)(83380400001)(86362001)(6666004)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YXFlc3lXdU9jR1ltc2U3T0pNUHUrd3o0bVJXTG1jMW9zM2l6TitBYjR6ZytY?=
 =?utf-8?B?UDlDaW1CVVJ0WXZ1eGYzWEwyNHZVNFFhOWlCb0xmYnZlbUZFTzNYUGNPWDZG?=
 =?utf-8?B?K2ZMbnZWT29NeklDMFhaZHppa3RxQ3NRTTR3aUtWY28rd2wzU3ZMM0lhaXRn?=
 =?utf-8?B?UitrTVZhQ29CNzVWNzRZUWE2Z2p2RVpEWjRaQU5Uclgrc0VLZW01OG82eFg4?=
 =?utf-8?B?ZHpUTGo4WFliNVVOMEg0ZGQwT1YxU1I0WVllVjZhc0ZEbXhWY2RVcmlhU29T?=
 =?utf-8?B?TVJvRWc4K09CMTIxOXhvbFhpcm1XNkY4T3BXTzM4WUNYQTFXVXg5ZzR5OVV6?=
 =?utf-8?B?QXJoWm9BcFRPR0d1RzY1WnFtUncyWktjR0xsVVhGM0kwME12K3QrS1daeTFE?=
 =?utf-8?B?dUwvaUZJLzA3aDBPNmlyeEg5Qm5Nd0VuMWszNVkwRnEweWM4SWxKN2d5bHNU?=
 =?utf-8?B?Zk5RTDBmSncydjRkU0hwemZ6clBHNDdqYm5melNzTG5wYys2QjdmeDV0cWp4?=
 =?utf-8?B?RUZHb0VWbkE2eis0Q05SVk1BRDFMUEZxV2FkeWkvQ256TG40WUpsOFpyWlhU?=
 =?utf-8?B?M0ZjTldaaWJaYlA5Zk5tOVZoV3BCSXJQdXNqNnFEaEp2M3FsbFFwOGtxMVE1?=
 =?utf-8?B?YkN0SExXU1FrS2ozejYyZGVNaC82YWRCWTQ2YzBGZXAwWXVyUUpLbWdoTFpV?=
 =?utf-8?B?OTJRdjZaYW5reEdNZ25JeUl0WFRPbGJxVWx4N2VINktUd0xpbWJlbHFHcGts?=
 =?utf-8?B?Q3JJbjlVU3liNlZJYWpPcDFEVisvZC9XUGVJdkU1WWFMYTJWa0lUZlMzM3hQ?=
 =?utf-8?B?NW5Rbzl0a09OVFhnYUE5SUpNMnVhTGIwdk5Ja3VHeDdSd2RFTTdueGFaRWF1?=
 =?utf-8?B?bU1uMjI5T2xuWkhDU01mMU1SNGZkZndWRXhlaVo1WkEvTzNYRmJEL3NVbGk0?=
 =?utf-8?B?YmZmNFZMeHRXZEZCbnFDOWtSVUY5MnkxM2gzOEJKOGpKSm96b2RQY1JkcFIw?=
 =?utf-8?B?L1NHV0VoWWd4ckVITDNGL0IzRG5OT2JrVGFPWDlLcmNnRlpTZUxiNXVxQUFz?=
 =?utf-8?B?dXZ0dEtSQWM3OHY3cE1sNk4zNHExN05RUGlxSG1hOGQwMmx5ZDNpWk0wanl3?=
 =?utf-8?B?ZWEvRW1IelpDaDE3QWQ3OWZPUC9kd0tURFArM0ROODM0b1NmWHdVMTV2aHFn?=
 =?utf-8?B?RWMzOHpZem5CT0F0aGNTWXhKYVpqdXdNTXJ4S25iR0ozOFYwQmVxTmU5bm1o?=
 =?utf-8?B?T0J1a0lrMWhyZktpM1JmMGh0dWZxbWVWd1MzS3pBaWNGNGcrajBMVzFmY1hp?=
 =?utf-8?B?dnpJdDI4ekdOZ0RmT2ZSNlAwSEczRGhZOVdWeWlCYVBSZnBKOXVmMytxZ2pz?=
 =?utf-8?B?MVQwQS92VTEvMk0vaStwcEF5cWhuMGEzWmJPak1RSUhoVHR3WXN2aitKeWls?=
 =?utf-8?B?cGFIaVc5U3kvNkhzOUJjaE53TUpjQTA1Tk5rQmFlOVRNcVB4WEFaL2xYVVUx?=
 =?utf-8?B?Z1ZKRnppZ0hJZUtaYUZTTzNJUGNHdmlCM05wY2VtVjZKQ0ZNdGFXUGZaVVpn?=
 =?utf-8?B?QlRYc2FzbVQzQlIzVXBuVVFFb0NCUkhqbUdRcWIza1lWdVE2L3AwamJGTXU4?=
 =?utf-8?B?QkltVFE2cFN2QUt0a25pb21iZHdBNlBzMWRuV2NLaTF3WGlHTnpIaEFqSWdo?=
 =?utf-8?B?aTE5UDhMSk0yTGErUUlIWkM4OGJmT3ErZGVKT00vR3pQczExZ1NvWjJremY4?=
 =?utf-8?B?YkdqbFoxb1dLczF4dVRFaCtvUWhXbzMvaFdFcWs2Z0Zha2RYZ2kwZ2Z3TlZa?=
 =?utf-8?Q?qZvqdM65gcrDjYcmNv7udcbbgc/iuIpqguPCI=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ddf7322f-fac4-49d3-1f2c-08d905f36760
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 01:02:02.3248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HbOkFAnXw+ShKzkKNfw9tdVEFeAHUIr4rVgu17LQDfbipjbkQ82nq/AnQjmxFc94
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4433
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: IAztBhoPa_GiWE00ab2T20C8TAx7HW1v
X-Proofpoint-ORIG-GUID: IAztBhoPa_GiWE00ab2T20C8TAx7HW1v
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-22_15:2021-04-22,2021-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 adultscore=0 mlxlogscore=999 clxscore=1015
 lowpriorityscore=0 mlxscore=0 malwarescore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104230003
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/16/21 1:24 PM, Andrii Nakryiko wrote:
> Add selftest validating various aspects of statically linking global
> variables:
>    - correct resolution of extern variables across .bss, .data, and .rodata
>      sections;
>    - correct handling of weak definitions;
>    - correct de-duplication of repeating special externs (.kconfig, .ksyms).
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Ack with a minor nit below.

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   tools/testing/selftests/bpf/Makefile          |  3 +-
>   .../selftests/bpf/prog_tests/linked_vars.c    | 43 +++++++++++++++
>   .../selftests/bpf/progs/linked_vars1.c        | 54 ++++++++++++++++++
>   .../selftests/bpf/progs/linked_vars2.c        | 55 +++++++++++++++++++
>   4 files changed, 154 insertions(+), 1 deletion(-)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/linked_vars.c
>   create mode 100644 tools/testing/selftests/bpf/progs/linked_vars1.c
>   create mode 100644 tools/testing/selftests/bpf/progs/linked_vars2.c
> 
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 427ccfec1a6a..d8f176b55c01 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -308,10 +308,11 @@ endef
>   
>   SKEL_BLACKLIST := btf__% test_pinning_invalid.c test_sk_assign.c
>   
> -LINKED_SKELS := test_static_linked.skel.h linked_funcs.skel.h
> +LINKED_SKELS := test_static_linked.skel.h linked_funcs.skel.h linked_vars.skel.h
>   
>   test_static_linked.skel.h-deps := test_static_linked1.o test_static_linked2.o
>   linked_funcs.skel.h-deps := linked_funcs1.o linked_funcs2.o
> +linked_vars.skel.h-deps := linked_vars1.o linked_vars2.o
>   
>   LINKED_BPF_SRCS := $(patsubst %.o,%.c,$(foreach skel,$(LINKED_SKELS),$($(skel)-deps)))
>   
> diff --git a/tools/testing/selftests/bpf/prog_tests/linked_vars.c b/tools/testing/selftests/bpf/prog_tests/linked_vars.c
> new file mode 100644
> index 000000000000..f3d6ba31ef99
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/linked_vars.c
> @@ -0,0 +1,43 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2021 Facebook */
> +
> +#include <test_progs.h>
> +#include <sys/syscall.h>
> +#include "linked_vars.skel.h"
> +
> +void test_linked_vars(void)
> +{
> +	int err;
> +	struct linked_vars *skel;
> +
> +	skel = linked_vars__open();
> +	if (!ASSERT_OK_PTR(skel, "skel_open"))
> +		return;
> +
> +	skel->bss->input_bss1 = 1000;
> +	skel->bss->input_bss2 = 2000;
> +	skel->bss->input_bss_weak = 3000;
> +
> +	err = linked_vars__load(skel);
> +	if (!ASSERT_OK(err, "skel_load"))
> +		goto cleanup;
> +
> +	err = linked_vars__attach(skel);
> +	if (!ASSERT_OK(err, "skel_attach"))
> +		goto cleanup;
> +
> +	/* trigger */
> +	syscall(SYS_getpgid);
> +
> +	ASSERT_EQ(skel->bss->output_bss1, 1000 + 2000 + 3000, "output_bss1");
> +	ASSERT_EQ(skel->bss->output_bss2, 1000 + 2000 + 3000, "output_bss2");
> +	/* 10 comes from "winner" input_data_weak in first obj file */
> +	ASSERT_EQ(skel->bss->output_data1, 1 + 2 + 10, "output_bss1");
> +	ASSERT_EQ(skel->bss->output_data2, 1 + 2 + 10, "output_bss2");
> +	/* 10 comes from "winner" input_rodata_weak in first obj file */

10 => 100 here.

> +	ASSERT_EQ(skel->bss->output_rodata1, 11 + 22 + 100, "output_weak1");
> +	ASSERT_EQ(skel->bss->output_rodata2, 11 + 22 + 100, "output_weak2");
> +
> +cleanup:
> +	linked_vars__destroy(skel);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/linked_vars1.c b/tools/testing/selftests/bpf/progs/linked_vars1.c
> new file mode 100644
> index 000000000000..bc96eff9b8c1
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/linked_vars1.c
> @@ -0,0 +1,54 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2021 Facebook */
> +
> +#include "vmlinux.h"
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +
> +extern int LINUX_KERNEL_VERSION __kconfig;
> +/* this weak extern will be strict due to the other file's strong extern */
> +extern bool CONFIG_BPF_SYSCALL __kconfig __weak;
> +extern const void bpf_link_fops __ksym __weak;
> +
> +int input_bss1 = 0;
> +int input_data1 = 1;
> +const volatile int input_rodata1 = 11;
> +
> +int input_bss_weak __weak = 0;
> +/* these two definitions should win */
> +int input_data_weak __weak = 10;
> +const volatile int input_rodata_weak __weak = 100;
> +
[...]
