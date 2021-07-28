Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351E63D99D3
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 01:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232730AbhG1X7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 19:59:16 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61432 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232384AbhG1X7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 19:59:16 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16SNtE2I002057;
        Wed, 28 Jul 2021 16:59:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=tUu5JadFeddZSuHFGhj2nTv+e/sgHsKxJDzxyGA+DOs=;
 b=M9RVJ9A+8yryhZfhjphr0XB4VQvDguT/Yvg/UgHQU7hUV1tCgFrZ2upBvVFScWFGjvgS
 oGyipn6t/c6UQrYgR7qdxRXvQG06jnt9rpIDJtghdmKYoBnZFow12Dss3QbqsySxowyL
 hCVd5qVCnLBrBx4lpfSRVlDa5SOi8Bm3Gx8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3a3bu9a062-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 28 Jul 2021 16:59:01 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 28 Jul 2021 16:59:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mgs5lg2aDQpNZEwIJRbthXF8qXD3Ojrif6adKwY8dgYSBqqx4JVCBZnOYouv3ZHq/7N+r/tHNvX1ac3MJoavQ79ZtHUhsnsuVwA2qgxW4j5QnGyft19exssDVXXd4AaHqFPBaGe7ILTWp7Oa2Qpzf36lKfZRvM2t3DU96C99p9m4O11PhA5V6hLIRlbjs3pTrYY7I8IqJRSCmYKX0XsoRmRxB7cit5OtLX2mT8ymRd/jgp/mP0EFoN+1oGDMrC9jHZwPMtUR63Qj1NKNMcB1f7iTUiaRIQUhwj/CE62om4MscZcJvH/ncm5lQ0xtm6ErXN+a2Db5Xg021tNRcxi+kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tUu5JadFeddZSuHFGhj2nTv+e/sgHsKxJDzxyGA+DOs=;
 b=M7Buq57lbFrp84gkvkcjEiA88SV1peaLtViTBygT2Cz2TbH66I8CL1pRW2bfm1ip0839exAbUZYbhaPIQGTI7buz4wz3coFIjskd2zi1ubr02a9JBnJPiu/J61BrGFnN+481JdpCBTqEaDmTZPN8nHLY6Ji9Y7enqyKeSG/TdcNTp5HBkc8fz6NR1EenyF59j/yHAwVjAiyNj9JtlRmSmCM8FMIrzbaFXmLEDipDsESzMSbl6RUdEBl7eX/Aj0LuSV3m+msqJ5QgUvqYOWEvy3I3EDPqR3rlRQ9HTNsWZQWptGNJ5GlAT8Ywut5lLgmsjtCdnxLf7CjVEcmr0xlJOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR15MB2479.namprd15.prod.outlook.com (2603:10b6:805:17::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.20; Wed, 28 Jul
 2021 23:58:53 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb%7]) with mapi id 15.20.4373.021; Wed, 28 Jul 2021
 23:58:53 +0000
Subject: Re: [PATCH 10/14] bpf/tests: Add branch conversion JIT test
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>
CC:     <kafai@fb.com>, <songliubraving@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <Tony.Ambardar@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20210728170502.351010-1-johan.almbladh@anyfinetworks.com>
 <20210728170502.351010-11-johan.almbladh@anyfinetworks.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <693d7244-6b92-8690-4b04-e0a066ca4f6f@fb.com>
Date:   Wed, 28 Jul 2021 16:58:50 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <20210728170502.351010-11-johan.almbladh@anyfinetworks.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0057.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::32) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::1398] (2620:10d:c090:400::5:8298) by SJ0PR13CA0057.namprd13.prod.outlook.com (2603:10b6:a03:2c2::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.8 via Frontend Transport; Wed, 28 Jul 2021 23:58:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6d861960-2fc3-465c-c687-08d95223a75c
X-MS-TrafficTypeDiagnostic: SN6PR15MB2479:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR15MB2479722625A5C365054177C0D3EA9@SN6PR15MB2479.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1360;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C1/PcrQkNKrt4A3zidDXinfxC4c0iFp0Ygy0eLS1vl38Ieilw4ZI1ECfShMChneoCb7votsTbnPaxhJnI3quMP7F8hO8X6EDAQgGj2JnAe+CwcIsUPvXAPBK11Uf/U6AkkwMnUsZ33mpvv1/zUx0nknLbLXdtkM+2LhCykVTEhbJaHfp6J9L7YzF2Umwxdg3zhSFrA63QLmRcTYL83tCmwz/vUKPCsdGwxUfHQfJDdnj4mo0RFryDp/fQojbiwbCPWLR4Q6Gl0P1LvbOWzAixbPDwCZPo/3ZRlugM1nZ2qHWh6URg1ZEZjw38CygqamWDmSNLkm0HDkZg5s2aA0RZoPC2CShhKtv7fMYwcMtJW6WXWzmWxuxei/+OFKhkSpshXz0he9bzb6hPwKAYCbJ8NTgw4NYpZ8QllluIFlGugJ+ZDkERsGTbdIfNQIJQpYt7C8RfAA37LVfNFLrjIHbrzCMMlEc9Ezf7iB/vWSU9vgKCqgzCQsg5PH/DOtEDew2J5SEak0WU8r4vYbTXz03bvgO3LobX5/oxfglxxsGo+MDm+LRluMdsro/0Fe88ZimnsdlfaKNzPdA2ngZ3Gps35q+q9C9pAGKD7AkaETwm4sBV6cOFCiHvuJgyA75B1H7jzNII+cVKk5E872zT0+xlNEESpn5t9VgyqLO2Rcf9LiGGybEfLnUzL267AKPCM61ohedwO1WAOXlAWyN/YmZRSuETrq54m0qw25GudCkvFo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(396003)(376002)(39860400002)(8676002)(316002)(52116002)(186003)(5660300002)(53546011)(2906002)(36756003)(86362001)(83380400001)(31696002)(31686004)(8936002)(38100700002)(2616005)(6486002)(478600001)(66556008)(66476007)(66946007)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MEcxNTd5MEx5MEdMUGp2TlcyYkQ1RGlXSE9KMjcyMjd4UEEyUlBHYXRkRThO?=
 =?utf-8?B?TTM5WkF6bDJrakhJRmI2WjhqcXl4TnpqTTNGMDRWZGwxM254UUc1RUxuMTdz?=
 =?utf-8?B?TEd5WUdVZGxoSm10bS9ZLzkzbUQ0YlJ1MTZBd1VxTC9FSThMMGdQWHlYRW1B?=
 =?utf-8?B?VjBtOGlvZHUvMnFua3prUzVzZmRLZUpUL2gwTituWEUxdDZDeHZBZ2s2Ri9J?=
 =?utf-8?B?ckkyYXRLblNCaVBITDJ2YmR6L1g0a01TYmFncTZZRWRZTmQycHE4TWdKMWZD?=
 =?utf-8?B?d3NmWDlZU1d1a3M3V2QrMGJmYlhhcVZ0YTlXZTQ3emxYVkpzaHh4L0FQaWhT?=
 =?utf-8?B?WHdGdGNNY0F6cFcrOXhHeHpFaFpJR3FhYk9MMU5mODRkSUNSdGZad1hMOXg1?=
 =?utf-8?B?N3BPSUorNm5IaGNIOVpFZ2RJT1ZhVkYvMlZrcUh1NTMyb2VmbXZ1dm1KLzVj?=
 =?utf-8?B?eUkwUDJya1VVQjNkUGNQaUxteURNcjh1TjZNeVl3NFFLZFFtUTlUa3F3bzFC?=
 =?utf-8?B?REx4SnhPZWRPajJSNSszUS94TUw5NzdhSjVwc3hqUnRqdVFLMUxha1pJQXFH?=
 =?utf-8?B?aXcxZXRIQXd4ckkxbUV3M2EraDgvOGlIU2k4VW1XVjJUeUozSnMveDRmVVc0?=
 =?utf-8?B?WmlSWHFRQ05NTlVMbm1SSHNPTlg5UTd4QVI1VjlrRHVIeTI0VHIzU0FveHdF?=
 =?utf-8?B?Q2NKV3JvVUdHT1RxOTlpZlBVaU51QXIxandremtKdXdVWFlqMSt1U213R2RE?=
 =?utf-8?B?UEloTjVHUUN3aVQydTc5WWRnR082MXpDTW4xWDdaak5xR0dxUWZnWXFUaE1X?=
 =?utf-8?B?ZWl3NUxNMEZiTS94R2dsUjhYZDFQemtGQThMZDB6bFkzT3NqbDIxUjVrQU01?=
 =?utf-8?B?ZTNQSzZGbTAxNkhSanYxN1JSMjVZbDFuRXhuSmRSVGp3SjVtOFNGYUNrdVpE?=
 =?utf-8?B?cmwwVFh5VkNSVDQ5Zm9uOTFrQjBrdm9WYmNHYksrVWhsV2dlZnUxYzlaUmV6?=
 =?utf-8?B?Tk13UFpHZEU1L2s2cFlZUGRaL2R3RkxxWjVzcXdNSllwQ01GQzIxSUVkemlZ?=
 =?utf-8?B?UUU5ZG1NUEpSVkhUVmVMbS9reGZkVitxZ04vczJDMHJQb0RkOEROaDhVeGF0?=
 =?utf-8?B?Si9mMEFvV3RSZTRhNnZIR0l0aldFTyt1Z24yMkpFR21BYXNGZUZMd0ZiY01J?=
 =?utf-8?B?NE1wK1hGMnRzajlTdlRhbkhYaXI5UGFVM2lCbGx2V0JRUTZmWHd4VW9nYkxO?=
 =?utf-8?B?YmNtclUzYWQxelM0MCswdFU5aXZrK1paUER1Z2hCYXhkOWdzV2RtbVl6b2My?=
 =?utf-8?B?NG9zSzRJRHJ4d0dkZm55YWhseXU1VjNZaC9OT0Fjd09XVk1LZ3diZ1RjNUJ0?=
 =?utf-8?B?VEtmUU5PbGxkV1ZtYTlXTFpqQjc5TCtIeTNzbVRUUVZiRWdMUldWM1F1ZmdY?=
 =?utf-8?B?dTF4d282Z1NFcUJFRWZvUWJVZ3VUNXZTNStkemtIT294RzltRVZhdEE0K1BE?=
 =?utf-8?B?bkFKWU81QkV6N1BQd3JNZHlRUnh4NVNsUVVkb3YrOFNCb2JuY1FCMEdMOGhu?=
 =?utf-8?B?NVUwTytaVkwwUmZsc2VpOHB0bklxL3dRemR2VW12c1VwaG1IQ3BXbk1EaVRp?=
 =?utf-8?B?WUpnWVd6bGxIbFl0cVZpYWkyd2oyakw1V0ZFc0Y1SFBCcHdrMUttNzB3c0xh?=
 =?utf-8?B?NkY5bXRzbnhxMmZkUFVtRC9vT1hSNnM5QTRESFE0TnFseUlYSmY0c1Ivb21S?=
 =?utf-8?B?V1RZQnpVOXgwMlZmcFJ4cSs1Smp4dk9EY08zNHY5TW4xdmZDUlh1VVloSllD?=
 =?utf-8?Q?NXO+Vnykg/MX58qUru/SeaJ0q4oEl6kjD/RBg=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d861960-2fc3-465c-c687-08d95223a75c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 23:58:53.5693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e+Sf0j0P5aq6Yr3gid4uAr6jQIUHIEXWGLppvlTc0ICZow6FhQDkDI0dhaEunINy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2479
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: Iq4KeZR0YezY0dvTlR4JiyK2jCuqF0jb
X-Proofpoint-GUID: Iq4KeZR0YezY0dvTlR4JiyK2jCuqF0jb
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-28_12:2021-07-27,2021-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=936
 lowpriorityscore=0 suspectscore=0 spamscore=0 malwarescore=0
 impostorscore=0 adultscore=0 mlxscore=0 bulkscore=0 clxscore=1015
 phishscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2107280125
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/28/21 10:04 AM, Johan Almbladh wrote:
> Some JITs may need to convert a conditional jump instruction to
> to short PC-relative branch and a long unconditional jump, if the
> PC-relative offset exceeds offset field width in the CPU instruction.
> This test triggers such branch conversion on the 32-bit MIPS JIT.
> 
> Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
> ---
>   lib/test_bpf.c | 38 ++++++++++++++++++++++++++++++++++++++
>   1 file changed, 38 insertions(+)
> 
> diff --git a/lib/test_bpf.c b/lib/test_bpf.c
> index 8b94902702ed..55914b6236aa 100644
> --- a/lib/test_bpf.c
> +++ b/lib/test_bpf.c
> @@ -461,6 +461,36 @@ static int bpf_fill_stxdw(struct bpf_test *self)
>   	return __bpf_fill_stxdw(self, BPF_DW);
>   }
>   
> +static int bpf_fill_long_jmp(struct bpf_test *self)
> +{
> +	unsigned int len = BPF_MAXINSNS;
> +	struct bpf_insn *insn;
> +	int i;
> +
> +	insn = kmalloc_array(len, sizeof(*insn), GFP_KERNEL);
> +	if (!insn)
> +		return -ENOMEM;

When insn will be freed?

> +
> +	insn[0] = BPF_ALU64_IMM(BPF_MOV, R0, 1);
> +	insn[1] = BPF_JMP_IMM(BPF_JEQ, R0, 1, len - 2 - 1);
> +
> +	/*
> +	 * Fill with a complex 64-bit operation that expands to a lot of
> +	 * instructions on 32-bit JITs. The large jump offset can then
> +	 * overflow the conditional branch field size, triggering a branch
> +	 * conversion mechanism in some JITs.
> +	 */
> +	for (i = 2; i < len - 1; i++)
> +		insn[i] = BPF_ALU64_IMM(BPF_MUL, R0, (i << 16) + i);
> +
> +	insn[len - 1] = BPF_EXIT_INSN();
> +
> +	self->u.ptr.insns = insn;
> +	self->u.ptr.len = len;
> +
> +	return 0;
> +}
> +
[...]
