Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A88C3D9AA4
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 02:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbhG2Azj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 20:55:39 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11562 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232837AbhG2Azi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 20:55:38 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16T0tLIA032636;
        Wed, 28 Jul 2021 17:55:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=78EevUGmtA6aPSB1yv8p/gsEU+uM1l84dQFA+adEt68=;
 b=C5cZWv2JseD5Ndvfd2FC1JLcOEzOy73GIZncd1Y71BjeeiBRBW3zWpHky4pZr4SyXxX7
 EtLLGjT5M1rilVAFumWBowMTnVjGaJILMb4Bc2Q8GG6DXI0ydfYYsi5NYPIXP/5zRFoz
 fwYKZaJ52O7fvfjCZmODXwbgKPCsJnRLnqc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3a3a9qu09t-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 28 Jul 2021 17:55:21 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 28 Jul 2021 17:55:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L5RQ370Ye4tXrGjyR2qqf0QDGm4nnreHLaBtN6vaUZANoChpGKlfkhGK5dz9hP7gdBdKQZQrzNHQGUzOyBVmo9wnylpw2xFSKHTG/CP44C5/zGQDQy4cjW46x94gwOS7g1LiOQcnMZj0rkHXMp0tPugwrsnYjBYKUwfpGTzd/E/PlO9vHrpNaLTTpPzciSyYKuOMvY/kI+MeUp47ShL4LiOoRhucE/oNbnjNxVC1d7cnktZVu4yga9us2x73GRGQauW3ZSnwXgKJu68JFG4YDRHSliWMB0HeMcVpZyuCUebec79bTCrfYASP2nCPq3EJdxLTRRVA6RxU5rQ4IPtCeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=78EevUGmtA6aPSB1yv8p/gsEU+uM1l84dQFA+adEt68=;
 b=jC2KjxmZKQkHRqa/T14rPYqNJinSCyUl2ficVVixJaQzE2WehiJHGHQs9KBV3KFRCi6txZiWiJfkxGo+0iHDNBnwA+rPlSCKAzJjlYkLeDmN39sgGQr4jL83xsqWUPAIMn/W0XJRuOv8LZXe51zloi6rJSE4a1XzMFkjIJzTMxoB31C0BbYauzZcQeUWp4+TXSnLRuvhuMpvghXs0x7bMVH7j6R54rHxITSGJ1ym1tB9dRxUtAxPO7WBa8ox938hwyFAFHHOYJL4gMnd4cL1ft5xRxyZt/8AnAGJvfpVJiLH4jHFQBkt0+NC5flSh/RPH0NcpPnXTqEMp5UrIO3X3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4433.namprd15.prod.outlook.com (2603:10b6:806:194::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Thu, 29 Jul
 2021 00:55:19 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb%7]) with mapi id 15.20.4373.021; Thu, 29 Jul 2021
 00:55:19 +0000
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
Message-ID: <6c362bc2-e4cf-321b-89fb-4e20276c0d73@fb.com>
Date:   Wed, 28 Jul 2021 17:55:15 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <20210728170502.351010-11-johan.almbladh@anyfinetworks.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0070.namprd03.prod.outlook.com
 (2603:10b6:a03:331::15) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::1398] (2620:10d:c090:400::5:8298) by SJ0PR03CA0070.namprd03.prod.outlook.com (2603:10b6:a03:331::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Thu, 29 Jul 2021 00:55:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c579cb7-8307-4a08-c422-08d9522b896c
X-MS-TrafficTypeDiagnostic: SA1PR15MB4433:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB4433D4AED1BAE253A0B6173CD3EB9@SA1PR15MB4433.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: giaPczVlLqqwE+JOHjU+ki9pf7Hfctc6ST0L6Fg3yO2E52LJohm9tO6aV9dSnX2XqBOn/0i10bDyjyrDRNQdvJa5rZ4h9z+MxLm184uqsnzU96a7UnshUtbKMlEqbP6Uf/7LeXcI1JNPIkE2EZ2IhO/RYBKyFZ1HuLA55pHxTywOSxLKHXdxzVp2XrxE29mpvA4yB8wdUUm5Bv53kN3qSyrjEWzyq2QBMMKuCge0LOl30YrT0dR1ldXX+Gik3QP/3x9g3yOXkbkskj7MwJLfH9DVggjmMnaqBic0T3UqSgVm1JRfy0eqXoAxbUifuhlDKgvBg1bNgmT8Vhz/c4dDmhxo5WHeNkiKjU4DZAXexBL3zzvJzlqHNp+rgS/X91HbRuMr1mQeDpT6zIqLSzX6TIi0AI59zkdVG5Ry8DJhEPRjP0jp6gbmThTUFV9CSDpCSzHN21zYwwcYM/jYCyA0IiRKwYANMYLJ63VMIig930BNZqUAIDQK4gTp/g/bz41DAHSLzbqD7VuYkhKfQqzZVIlnESvLbSOa27drE9vCDJBuB1t6qqvg5HPDFN2UKBenPajHiD3w1QNl4DLOvNJOG1XtUNjl4epb/9EK5Gfid6aTHs6QSnjyR2Jc78zSeHMK99tL/xn0+tk5hnuc7JV9M11r2MWPlClTswfwi7X4kBSTM8KmfCHLniQJzeH3qlaIIRMxZSLXTjbrZOeXexLkLLS9G17lJHHMq2P/Bn9ccW8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(366004)(39860400002)(136003)(66556008)(31686004)(186003)(66946007)(36756003)(86362001)(4326008)(38100700002)(66476007)(6486002)(31696002)(8936002)(52116002)(8676002)(2616005)(5660300002)(53546011)(83380400001)(316002)(478600001)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QUVhYlRYcGJFLzFRTFBZamVvdGU0aVpudHZ0bWU0eHNoMDI1QjBabVB3cFBi?=
 =?utf-8?B?djBxV1REVzl2UGp2VjlqMG1QZ0IybnA4UVRzdDJablkzOWtydkZkNnhZeTZ4?=
 =?utf-8?B?dGFkek1ERDBSZU5WQ1ByM2RIWWR1TDkwWkNkekpHd08xWTJqSjE1RkZ3TWxE?=
 =?utf-8?B?TXVSbHJCZUQ1MW4xZGpXNG1ra1BzRklhUTJXWmVydlBkM3Y3OS8rcWRpUGds?=
 =?utf-8?B?N0hzcERzUlVTNDd1V0ZyS21LOWlDaVJ5MTQrRnU1WGFXV25IUTJENEJoQ05M?=
 =?utf-8?B?WUxsemE3SkxXQmdOclZ0Si9lSUVidTZuU3pyYUZ3ODJ2ZC9qVHhGcndqbzBq?=
 =?utf-8?B?MjlqVFgrM2I5aFc4RWFFc0Zia2FTUnY2TnUyR2tZM0hibEErT0tlSUNOdzhV?=
 =?utf-8?B?bmlmUnNnSG1QMzZUai93M00xbE5NNEFFKzV1NHVpWjdSbnNRSjA0L1ZMZFZY?=
 =?utf-8?B?SldWZXd0WkhpaEg4eTN4ZkV1RGFFZ2VlRk9DWSs3RTZlZnRDcWkwb3l4Q3VP?=
 =?utf-8?B?a2FCSFlqTGtydWJNVDMvbCs5dUk5bXEzTXpRREZTRGRBREdWL1UyMExqZGFZ?=
 =?utf-8?B?cU9hUmhnL25tTTBpNnZTazErb3lyQ1g2cnJGT3c4SEFRMHZtcmxMaXozWEN0?=
 =?utf-8?B?bGRLZE5aUnF3aGk5ZjR3NmFNZ29lbjN3UHM5d2hlWnI3RWhSaGoxR3FiUVlN?=
 =?utf-8?B?eEQyRmQ3aUh2SWNTVS8xbGc3K09IenU0TGIyMW5Jd1I5NVZON3UrTklXMjFI?=
 =?utf-8?B?bnc4eHVCclVSYmhWSEdIT0xUTk52RXM5V2RBd3k0OEgyc2pzOVpaNGJQMW9k?=
 =?utf-8?B?R1BzNlE0YUorUEpXRzhBMkE1allhZnNRVHVXMzNYK0h3alp4Q2VOMEhnQ01T?=
 =?utf-8?B?KzkxVmNwTW5QME9OWkdPUzgyNnh5OE1UWDk2QkUrTXBLNU10eDZqTVFRWUU0?=
 =?utf-8?B?M1A1clNVWUxTcWNUUUgrV0daTHdwS2k0ZFVOQlR2MTc4QUJBL0RRQnJxTVND?=
 =?utf-8?B?Znk3YVRYaStmTTRod296bjF0K3U0S3hYZkFtdmx4dlJIanZPT3JnTWQ1bzd2?=
 =?utf-8?B?LzVYWGx6L3FMRUFoTjNtNWVjN0hrV0I3R3JkMGNrdTByU0R6T2VNcGNLTUNV?=
 =?utf-8?B?SWpXSFloMzc3WWdMQnlTSmh5Q21zbjVIWmdndWtPQUtQTXJnNXd6SmtkbHB3?=
 =?utf-8?B?SUkvT0puelhTYUhYbjFhUUl6Mi80NU9jWXpEeVBRUHREYVgxSGlZZGl0SzZq?=
 =?utf-8?B?eU83SVdtRmU1Z2N4V1hOMzBQNHdGa0V2UVFvTGlvWTA4YWY1SnNtLy9YU2t2?=
 =?utf-8?B?QmUvbzVHL2tqWnRIOW5XdWpta1NnaC8zTEp1OTY4dnY1L1NOeU96aGNBWU5T?=
 =?utf-8?B?TDhVTmVJaXc1NDdaVlZhU1NWdFF5NGpGamQ5Z0NiYm9nMEJwbU9DMkdxdWZI?=
 =?utf-8?B?bUw0OVQwMCtpZGhuYkxFSVlNZXhUS3FheDJtclJybGJvaUthN09BVkcyQlJZ?=
 =?utf-8?B?NHZVZ0Z0QTNMSXAremFPWDVqZjlLRFVvRHZ6MjZkTVRMN2hDU0NBc3F4UUc0?=
 =?utf-8?B?NDJqVENuRXVJRy9uRU5nUTR4RW5sTmxIeDFTeTV4MCtHenorMjhWQUpLQUVR?=
 =?utf-8?B?aFZJN2ZrTVFxSEJtRm94SGJaNkFGTWcyUytXT2VENWJTcWZUM3JsVDJOK2Ry?=
 =?utf-8?B?a1JYb2RPRSt1UCt3Z0wyaFJ0a01VUWhyb2xyc3Vlb2x1dTc2SlpDTmdvbWxS?=
 =?utf-8?B?WXJRcURBWXpqaE1hNUhKbUFVR1VXNERDVkJYMndpL0hsYTduUkpwT2xDQ2VQ?=
 =?utf-8?Q?3QyNEOnWrDQh5xB8sPhli1rPkJM8PpWQgqaQI=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c579cb7-8307-4a08-c422-08d9522b896c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 00:55:19.3303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sw+oAm1XhBvhoqBrw0ipQObp+YNZ41uWzGPZh7p0MTqJwlf0iyE14FcY1FUoH5NQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4433
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: G7d6HGI0miWVcjvJ35DIE_s_mzhw-JZo
X-Proofpoint-ORIG-GUID: G7d6HGI0miWVcjvJ35DIE_s_mzhw-JZo
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-28_12:2021-07-27,2021-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 mlxlogscore=875
 clxscore=1015 adultscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290004
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

BPF_MAXINSNS is 4096 as defined in uapi/linux/bpf_common.h.
Will it be able to trigger a PC relative branch + long
conditional jump?

> +	struct bpf_insn *insn;
> +	int i;
> +
> +	insn = kmalloc_array(len, sizeof(*insn), GFP_KERNEL);
> +	if (!insn)
> +		return -ENOMEM;
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
