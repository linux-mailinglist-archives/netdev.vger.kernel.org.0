Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1884A2F50BF
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 18:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbhAMRNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 12:13:14 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:8620 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727713AbhAMRNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 12:13:13 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10DH0fVp005845;
        Wed, 13 Jan 2021 09:12:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=T6pNHeN3c7nS04x/FGaP18p57ZxxbBMCVZUc/tEFFXo=;
 b=JgBkHkov8GOqBUZlg4X/xCS6yKPu1hVLC4jMNjiPfHMjealyYw25FLJsPVFDQV96GPFy
 clKTXZDgubHu1VLSxhWagBp+o1UmYJvEYO8Az8xGOB6HuW1y2GzKFCnnBl01/fmxxDqZ
 fDudYxZyQrmeJHgbQMbfnM9RmK+LCxKaxI8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 361fpue51c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 13 Jan 2021 09:12:09 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 13 Jan 2021 09:12:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LF+36XqzyMx+hNkqgyDJlupsAxlUPnHM2cftAvvSaoLS6ZgxGJZgJACAzu+4Hdc+eh57aUcCTIL/X8EJthD0rgEw1qoCX3zjP2rMP33PDqlan5ERL62IeWUwIw2QyOklPc+y4QsfZB92qAYJMvtgmQVB4v3Jrr0BGqGM5SHp81Y5CfyRxJRmAXMCmaViDxm8xM7oRUvebtNw61CVJtCfu+D4SJUY1+o6Lz+BSYPwevUx0BqiqSbPlD0M5VifXtxHpX9kpOwaIjN0W7zXrnSnkuF5IWd0gatQQ6mOS8jMa04qU5miiroPPvD8FszUWnziL8iMzTRVdC5POVoTmbAcrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T6pNHeN3c7nS04x/FGaP18p57ZxxbBMCVZUc/tEFFXo=;
 b=g3Cakn2bjEODGbIw0CCv1/rGUOJV6Lsxpsvi6QpSOyytxomv+qoElJ5pLsCeKTJOxTCQHia0XSWvAnHkrFnmIa/fNRiM+OWBm+sU/b5//od9erSpO7e4FkVZsC+ZKYCqQOioOsPoH7rnXRwXpBfE6OA5RmR9ELgypMOIuAeWcfNCzqp5Znd6dWeXFBT7+iCk6WkzNn7Cw4BbaTfVoB3jU1wr5s+TtUkGyr5DSkT5TbRUMPNpNCAVw6fDRP5yMVKZ8wGIhV+Ik2dJ+Q0GCsbZdQnZsJw63VgvwWSIgU81PAobycobYk2uHm1oytvVVFJ8emJmcCXUBfwEU2arMQP/7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T6pNHeN3c7nS04x/FGaP18p57ZxxbBMCVZUc/tEFFXo=;
 b=OtlTP1/XHL8bik8NmeK1iSEthPNBse4Oiyxi2TO9EUG3vCZIgeqEXD253Tq5wI3RkTQRMWXM8LTiBBenDbB1m9ZSrzz61mc5KGYH9wTCtcYEagu7MkDb17YbDotPmJQHUaxD0GqOUFFNrDmjvHgvcymJpF7OS+5lnAIIQ7nHXyM=
Authentication-Results: loongson.cn; dkim=none (message not signed)
 header.d=none;loongson.cn; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3046.namprd15.prod.outlook.com (2603:10b6:a03:fa::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Wed, 13 Jan
 2021 17:12:07 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3742.012; Wed, 13 Jan 2021
 17:12:07 +0000
Subject: Re: [PATCH bpf 1/2] samples/bpf: Set flag __SANE_USERSPACE_TYPES__
 for MIPS to fix build warnings
To:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>
CC:     <linux-sparse@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <clang-built-linux@googlegroups.com>,
        <linux-mips@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Xuefeng Li <lixuefeng@loongson.cn>
References: <1610535453-2352-1-git-send-email-yangtiezhu@loongson.cn>
 <1610535453-2352-2-git-send-email-yangtiezhu@loongson.cn>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <e3eb5919-4573-4576-e6aa-bd8ff56409ed@fb.com>
Date:   Wed, 13 Jan 2021 09:12:03 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
In-Reply-To: <1610535453-2352-2-git-send-email-yangtiezhu@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:e777]
X-ClientProxiedBy: MW4PR04CA0354.namprd04.prod.outlook.com
 (2603:10b6:303:8a::29) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::13f6] (2620:10d:c090:400::5:e777) by MW4PR04CA0354.namprd04.prod.outlook.com (2603:10b6:303:8a::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Wed, 13 Jan 2021 17:12:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 59cfa8b0-1cfa-44d3-97b2-08d8b7e65b29
X-MS-TrafficTypeDiagnostic: BYAPR15MB3046:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3046D3DFB0A6E2281A0D54B9D3A90@BYAPR15MB3046.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:843;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lpEmsJKnbjuY6+6VV1U6X7ihvUe38zMxwqpvBM7j2lMUybp21PezBn+XkqOB8gC7FHuFdt29PLD1KeGzK+UhxkqqIJDkwpJlmCYSr6mHNM701+jq6j2DAgeVzRlgIdZ6k56R6JD44mz6hDgl9F2A0jkdZHi5LGoIrgDrjlNzXYr0sF6/ckNcxsobP1GrT+xpZN55EyQVHDg8QcNN2LFJ+MzQccEar0Y7bIAnlYWDofBe1VQYZZ9JqIU09o7mwswtotikI48EUndx6ZPSLoKfqMvXIWrr1n6CyyBuSCOi9koniLvbvXldY3NA3RYMtgub+K6FKWvH0bcMLpbkl0KMN/X38abwhYS8M27Fa4LjMbJHzg23Xf2Sq0GpfvrLow8c+z2MQ3cMcdQil5mCMa0HAN/5sXWsidGWLltH5FK5qWu86YPcpSk/k63eT5BQw0yP2aE/liqS3Qx2WcJ7HHNBCc8qUl7aqq2OchdstuYQuFYhXASCeOLm4uhzyBrzk4k0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(366004)(396003)(376002)(346002)(31686004)(478600001)(66946007)(8676002)(2616005)(53546011)(31696002)(2906002)(66556008)(66476007)(5660300002)(8936002)(921005)(52116002)(36756003)(7416002)(316002)(16526019)(4326008)(186003)(83380400001)(110136005)(6486002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OXpyazRPUTE4V0lCTXVWbXVkWkdPL3EwRWl5a1RwOTQrN2RyQlhRRE1QYjVB?=
 =?utf-8?B?TWQ0VTdkcEFLdUFWNFBtREJlWDRBcGVWdXVrSm55dXZTTERSdDdtaWJOTzZ3?=
 =?utf-8?B?dW5LMEJGb1hRa2JwTjlwSTRjNXYzOFgzWnJ3YlFSNXFSbUlqbDdLbjNtYnBZ?=
 =?utf-8?B?Um9zMEVjbWJzbFpLQW5TTXdRbnpnMkx2UWNIRkZLSnhFRjdxRE14U0diTHZv?=
 =?utf-8?B?cHY4dVVoR0dnYnZmaHZWNzRMbkY1emlXb2ovUTlHZjU0UVIzaGpGUG55R0JZ?=
 =?utf-8?B?MER5WjB4a1ZEV2RTc0xLWTlsNXdOSnFUMUJDQ1dnL2E3ekVDaUFlYmZZbTRk?=
 =?utf-8?B?M092YXhFbmh1bGFjcmRVNFR3RWRmOEdEbXY0SHF4MUF4RXJSKzlUTURLV2Ez?=
 =?utf-8?B?eHdiR1djT3RBVlFoZ0x2UGNxUHovZTI5UkcrQUhqOVc0S3hmdDFZa1Q3RUow?=
 =?utf-8?B?ZUdrQks0UlFCZDdxRkFDSkJpV1Zua3crTUNYR1ZXME1vbnQydlpIZTI4ZXcx?=
 =?utf-8?B?ak9mc1BzNVR3QnRMaDAxYitaZWxRN28wU0pwZlVOZUVJQUtZSFJGalNjS3la?=
 =?utf-8?B?WGl2QmhrenBHWW1TUWNUai9FSlNSZVgxa1BmaGZJdVJaQlA2TXdPYXo3Rllo?=
 =?utf-8?B?ZDBqZFM0aEplYnRZQUM3UHBMU0I4VzR1dC95VVkwVUhOb050emlaVnVqQmlu?=
 =?utf-8?B?OVhhZDV0UmVZWGxCb05vcjRubm5aWkpIOVpqQWxlK1BWSnBpTlAvSHVtdzVk?=
 =?utf-8?B?RWpBdm84REZld1NmNE1BMkFuTUNGVnVpa3pkbnh0dVpVM2xTVmpta0ZpYWhM?=
 =?utf-8?B?L25tUnc3RTZuZzlxVDBkTHZrRkMvZzh2eUxJM0l2eklNWWdLTnNkVlhGTTgr?=
 =?utf-8?B?NkgyRzh3NHVRYzFKcDdDY3VhMDNsd2pNM3lOSDkxL0hnbTFyM0hWWVNBaWJz?=
 =?utf-8?B?NXoyaER4SG9GT3NaRWxQdWU1aml3c2o5ZnpKNkliQ3NReW1QZ1FNMlgzbW1w?=
 =?utf-8?B?c2lGQ1JQSVVpeUR0MndHNDRBUGVDZE9wVE5jNGVxQlB2a1FscXJ1cHhYVTdE?=
 =?utf-8?B?Qzl1aHZsOGo4V0EwdGRneTVHQXI5WEljZlRLM0RIS1BoQkh0elhIREQ2OWdZ?=
 =?utf-8?B?Qm5NdjR5eU51eUgzS3AwUjhReGJTUERzNG1GRDJ6NUY3Snh1U0RmOUh2VXQ3?=
 =?utf-8?B?L0FWQVl2NGFoeTJmNmM0dWZrZFcrc3pmZFBlNkpVOUtZL3NIWml4c0w0REZy?=
 =?utf-8?B?ckdkZU82Qys0K2NDNFBLM0FhYjROaDZIMjhidG91LzQwTE5hbmo2V3cxNmxY?=
 =?utf-8?B?YVFJR2gyK3ljRy9IUmlpVE5SWnYyWG01VGhkMzQzSkJqdXJYY1JLSFdBSnVO?=
 =?utf-8?B?MlhSQTlpR0lnYUE9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2021 17:12:07.1209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 59cfa8b0-1cfa-44d3-97b2-08d8b7e65b29
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 65BSGNJzbtS0DB5X+2/+85TMmc94ye+wHQEHn8dOO/wSiRoaHlckW2RsWr7TUVgX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3046
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_07:2021-01-13,2021-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011
 adultscore=0 lowpriorityscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 mlxscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130103
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/13/21 2:57 AM, Tiezhu Yang wrote:
> MIPS needs __SANE_USERSPACE_TYPES__ before <linux/types.h> to select
> 'int-ll64.h' in arch/mips/include/uapi/asm/types.h and avoid compile
> warnings when printing __u64 with %llu, %llx or %lld.

could you mention which command produces the following warning?

> 
>      printf("0x%02x : %llu\n", key, value);
>                       ~~~^          ~~~~~
>                       %lu
>     printf("%s/%llx;", sym->name, addr);
>                ~~~^               ~~~~
>                %lx
>    printf(";%s %lld\n", key->waker, count);
>                ~~~^                 ~~~~~
>                %ld
> 
> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> ---
>   samples/bpf/Makefile        | 4 ++++
>   tools/include/linux/types.h | 3 +++
>   2 files changed, 7 insertions(+)
> 
> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index 26fc96c..27de306 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile
> @@ -183,6 +183,10 @@ BPF_EXTRA_CFLAGS := $(ARM_ARCH_SELECTOR)
>   TPROGS_CFLAGS += $(ARM_ARCH_SELECTOR)
>   endif
>   
> +ifeq ($(ARCH), mips)
> +TPROGS_CFLAGS += -D__SANE_USERSPACE_TYPES__
> +endif
> +

This change looks okay based on description in
arch/mips/include/uapi/asm/types.h

'''
/*
  * We don't use int-l64.h for the kernel anymore but still use it for
  * userspace to avoid code changes.
  *
  * However, some user programs (e.g. perf) may not want this. They can
  * flag __SANE_USERSPACE_TYPES__ to get int-ll64.h here.
  */
'''

>   TPROGS_CFLAGS += -Wall -O2
>   TPROGS_CFLAGS += -Wmissing-prototypes
>   TPROGS_CFLAGS += -Wstrict-prototypes
> diff --git a/tools/include/linux/types.h b/tools/include/linux/types.h
> index 154eb4e..e9c5a21 100644
> --- a/tools/include/linux/types.h
> +++ b/tools/include/linux/types.h
> @@ -6,7 +6,10 @@
>   #include <stddef.h>
>   #include <stdint.h>
>   
> +#ifndef __SANE_USERSPACE_TYPES__
>   #define __SANE_USERSPACE_TYPES__	/* For PPC64, to get LL64 types */
> +#endif

What problem this patch fixed? If this header is used, you can just
change comment from "PPC64" to "PPC64/MIPS", right?

> +
>   #include <asm/types.h>
>   #include <asm/posix_types.h>
>   
> 
