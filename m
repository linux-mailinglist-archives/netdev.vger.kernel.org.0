Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 820A13D997B
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 01:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232638AbhG1Xcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 19:32:48 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:25566 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232116AbhG1Xcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 19:32:47 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16SNPAcl023338;
        Wed, 28 Jul 2021 16:32:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=qRfhfuJXwuS7SvDG5H+iFmE7/3dQ3mRhO8DtUKb6DQU=;
 b=Gsqc6gA8gWdnuT4wh2cwJSkcAVNZKxGGLuvXqhYyWbfApptETOJSwOXOO6v5IYnU+OvM
 04wCqO6LWF4D73xOozR9TpjTzbOePq77zwMdbvRKFqfkLeZN99MUM/UyDAaAh9cmECH1
 r5nEjUH690bHC76lpuZjYFP5pZ1aSdkNvRk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3a39ssjypa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 28 Jul 2021 16:32:32 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 28 Jul 2021 16:32:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oLrDnMMKeHdZvYnb6DInbVcTx6GBCetsj9V/yiDcYDPabpDZ2ALffIE5gdqj+ubQ2qCZ0ZJNlKfbO4/aj+2zPDR9lp6zwur2b/Q/6xiZIZsj73t4hdWweKbkOylsEj5hJLVmfgl1mgGCOaOsh0hES2Pg4LypSby/5prLsELrgMccFS7yV+/x8vKZ1RHe4xgsPzNrtjO6vZMyrLfn/XtQNTe+fqL8Fr0s5GpEDBUjXaauYgSwDtPKlJGBNrKqa+WtcJ0PvrgLmHmzzlD86h9hGSiuHN8nw4Es6vsGpsNxTb+YnzUKfI8nSCCfssWeWJ0rIdHEaeaDEfNszHB8XNsbFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qRfhfuJXwuS7SvDG5H+iFmE7/3dQ3mRhO8DtUKb6DQU=;
 b=boXEejajXbXgIEFOebwiq+RrkIeU6EnW1ASZs0GKq6GrR3O1rWdDVXJJ9G9OZtT47jcQYEsf0bHzAnP8FK6NUp8cLuj7DcuMnEEYy5KOEHa7LnrdBpuv1RDRGs6rnIj4tSUIZuu5QCv0wrD/eI0SiXmeqp+4whDV9xXIQQslrr6EozJg6Rok6Tj40kHx7AvXuPL8tpVCplU8lwJaNoPFgzIkz2vGmjlxIYSQaAcbHCA7CEIhXwkVgZZLM4lv1xW75z1tJnz870wC9xFbciLzixq83RFw+93vko7gZRwe5snOPlMcRObdJ8ChQblz0OT7jLxpqu63vxQYO3SXYNxYgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4869.namprd15.prod.outlook.com (2603:10b6:806:1d0::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.20; Wed, 28 Jul
 2021 23:32:30 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb%7]) with mapi id 15.20.4373.021; Wed, 28 Jul 2021
 23:32:29 +0000
Subject: Re: [PATCH 07/14] bpf/tests: Add more ALU64 BPF_MUL tests
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>
CC:     <kafai@fb.com>, <songliubraving@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <Tony.Ambardar@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20210728170502.351010-1-johan.almbladh@anyfinetworks.com>
 <20210728170502.351010-8-johan.almbladh@anyfinetworks.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <cbff35ec-07ce-9c7d-4c29-66f2f780daa4@fb.com>
Date:   Wed, 28 Jul 2021 16:32:27 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <20210728170502.351010-8-johan.almbladh@anyfinetworks.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0186.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::11) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::1398] (2620:10d:c090:400::5:8298) by SJ0PR03CA0186.namprd03.prod.outlook.com (2603:10b6:a03:2ef::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 23:32:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6d6b60eb-7e96-4271-a774-08d9521ff75b
X-MS-TrafficTypeDiagnostic: SA1PR15MB4869:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB4869A0E0C17BBBD4BFC2CAE2D3EA9@SA1PR15MB4869.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:404;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 63YKFhwASX89pYrHFs9FZanwGkVcSd1Y8iPoILJFC3XKNI+yIX00d0TWAO7EO88xvF7Kk/ZVEzrXFAuGdvfgUIAMCU5xg3lL1V8zJWGliF4N5GrG8XrzRyw0tkiaYW5aB6AWWsz0Slc54bRwrBlKbgTiYRAnD6dDikzIk7o/Bnb+Mh80/wRFgOkz/cQkhFY8H53So2Yuc7QT8XAP/qjMlJ9QABr5Ay9ZTpifCqdD84hZtCjvk+ectBIdUVOFyoXGgUPdfDx4bqZll3w+RmI5t9HucM/2qmeysiJVr+wWcgE6yazYcsv90w8uYa8u36n6oFHgbetwOsvo+Cr0rC9JFzNApM4hQcxAIX1Is5fLoWSypCYQnSPVZ+QvwS+HplyoCJt1LfZMKgCkEbWwLhI1mFCk9XK4lIkPKO6prCj4A4RHzUYYqECUWhMGmX9onYvOTocXdyFxb9eShZz1dE9RmZDsxV7tO4OwSBU52nc8AWrqkFHvAlrCXcIHKmm9g86/18dCRmvjsgF4yi4W3kmJ8Mtys52npV7lOiqRmKlcwm0llkI1b6oeWC+KsvXTcCGxf5Pdgh6zW9YuWuuUqCULykpO59QVImU+lCHzdhKRh64alhk7bOST5Zw88TDu9I1+IVOLE8XheOnjwJPl6QYKiyx/AZQNvZ87CSsqTq6dacocIP1dhNjKV1ee44pNmK8Lut7c9/JrBLxD5RJi6JcUuTw7dHS48SDzMEXVxwUBjTQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(136003)(366004)(346002)(2906002)(186003)(316002)(38100700002)(478600001)(31686004)(2616005)(8936002)(8676002)(4326008)(31696002)(5660300002)(53546011)(86362001)(66476007)(6486002)(66946007)(52116002)(66556008)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dGxOZStMdVdrREdBRkNqMnNBT2t4ZEdJcGxvZXpFNHpVeE5aU200b2diSGtH?=
 =?utf-8?B?TDBEWUxEZm5NN0ptci9XRTFGN0RtZW9nbkh0Qk5rRjNMaFduVHZEVDRKNjky?=
 =?utf-8?B?eHBVOWVaL204NERZU3Q3QWYwdERIb09GMlFaU2VJa3RZWk0wa2tCd3FPeUsz?=
 =?utf-8?B?MzcyOTRjSUhMbktDd3dyQWJFVmZuWlZWeU4yLy8vTXp4Ung1NXZzdVBsdWZi?=
 =?utf-8?B?cVRtaTJ6S0RLcGxFS2VFbzI4QjQ1NHpDdm1weVZNSjVmWGRsNElmNlhaV0t0?=
 =?utf-8?B?ejlEb2lmTG53bm9vWUJaM0JiRE1odzllMzh5cVFMUVlJUVYzM0NObXJDM2dp?=
 =?utf-8?B?Q2dYR3c4a0U0c0lucVBZVFNQVHF6dE45ek1NKzQ1ODl2ZGEyR2xpb1ZWMEdX?=
 =?utf-8?B?OHdsdzZvWHo2SEFWbWFVOHhmK0lVL0xCUEhmSnVUYUlRVUJ4Nm85SXBUSElZ?=
 =?utf-8?B?Z1pyY2IwWkJVVlBRVGRzYjlVeWRqNWJSU1FicmdzKy9VOXVXaXcxUW95ditQ?=
 =?utf-8?B?d3l2UjY4TTFreXU1S25kczVnS2U4RmVrVzhRL0kzbWFSVVFSNXEyWENZd1dH?=
 =?utf-8?B?Z0VLdzVDaWUzUUVxajI3R0w2c1lCV04xYTZDbjc1bTF6U3p3ZitFSlZWaTBs?=
 =?utf-8?B?Umo2cDdPWkc0RWIwN1YyTW90bitzSzNrOVprOVhBNjZtYjhEeWVxRnY4SWVJ?=
 =?utf-8?B?RE9pZStsUS9DdldJWHVDUHRpTXFRRUsxV0x0U2VOOUtlTmZ4NG0zdVl3WUhE?=
 =?utf-8?B?dHF3ZlVuL29ZT1QrNTdjNFNtSkdaYzhwMTNQa01CMEY4T0lYY2grenVsTFNI?=
 =?utf-8?B?SlhmenJrV0x5bUp0UlpuZnJXTW8zVm93WVZncWpWcGhIczRDN3k5V1VranNn?=
 =?utf-8?B?bm5XOXVzY25ZN3JIWkRXc3RxSmhYWk5vNTZvQk5rdVFMQWdEdVVBZUU1Nkl6?=
 =?utf-8?B?MGRJVE5HYlh6UlVVa1dsNXNWUks2K3NYSlpCaE9aeGp5L3BZb2RucUZhbTFC?=
 =?utf-8?B?emtmT056QmdKSEFMM1BPelg0VVNjcXRYcnVwL2JFR1VCL2plcmFvY010dCti?=
 =?utf-8?B?NFBuOGZNMTNtUkRKbzJCRWJSVGxwQ2dNUkw0NVhNemNJTE0reDNQdWJURzJT?=
 =?utf-8?B?K1FQbHVTamZST3Bvd0dIRFJyajZLTGVkUTFrMEpkTDRtOFdQOFEwZHR2eFky?=
 =?utf-8?B?dVp0QWhTYkFUSWtTL2d3SS90UHNLb3IyMzdSUWpsUEhzWUxqNkdYYlFWM01t?=
 =?utf-8?B?dHIxTWVOYmdLRlBnanlEN0tnY3VuTE5GTElPWThwdldLajAzbTgwSS9UbUtR?=
 =?utf-8?B?T1NJSnJXNGZlWHU1KzNJZ2dEUzRHem11bWJiN0VzRXZDUkpPeE03VllIWTFj?=
 =?utf-8?B?cnV4YS9abmxMOWd5RTN4alhsUVpZQUxJVkMrbHR6ZU5CdmJVbXBXRGxnL0F5?=
 =?utf-8?B?UEtSYktRSlgxelZCRnlTKzM3Tzg1aFdHR28yNXBiOVREUzQrQ09VZGdMUnNm?=
 =?utf-8?B?NnlFR2JCbmhydXVuNm8vV1ZTMm9DaHdTV1ZEMS8xVmhsdmdpdEIxc0h4SG1E?=
 =?utf-8?B?VUcxd1NnSnZmb2c3c2FZaG44MHhGQ3c3WUJBMTVCRGdGU3YxSk1MQzh3TGNT?=
 =?utf-8?B?VWRBQzdTTVhSeFNyM1F1dW5WV3JJOERUd3NEWURrcVR3MGFuYTJ0bzlBUG1X?=
 =?utf-8?B?dnBRdmhIcTVaRTZGUFdpRU1qWjZuUTlJc3RRUmhYdzZBcnlzNjJobzcwalIy?=
 =?utf-8?B?NU5neG90bk9HaDQwZ3RpYmR3KzZZOFliMUFYVjFmdzFrTGR5WitaczE4Ymdi?=
 =?utf-8?B?QUJmd0VWSEpWK3JoQitEdz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d6b60eb-7e96-4271-a774-08d9521ff75b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 23:32:29.8527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m/CYxJTBsORZ8U7T754QoFk3LwklmSGN9NWzmjKb/K9tlWW1YFEcEHEpoOAtH8U6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4869
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: eE0_r09bfB2acSxKA8SSvp6lcMXiCNDs
X-Proofpoint-GUID: eE0_r09bfB2acSxKA8SSvp6lcMXiCNDs
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-28_12:2021-07-27,2021-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 bulkscore=0
 phishscore=0 adultscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 priorityscore=1501 spamscore=0 mlxlogscore=894
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107280121
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/28/21 10:04 AM, Johan Almbladh wrote:
> This patch adds BPF_MUL tests for 64x32 and 64x64 multiply. Mainly
> testing 32-bit JITs that implement ALU64 operations with two 32-bit
> CPU registers per operand.
> 
> Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
> ---
>   lib/test_bpf.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 48 insertions(+)
> 
> diff --git a/lib/test_bpf.c b/lib/test_bpf.c
> index b930fa35b9ef..eb61088a674f 100644
> --- a/lib/test_bpf.c
> +++ b/lib/test_bpf.c
> @@ -3051,6 +3051,31 @@ static struct bpf_test tests[] = {
>   		{ },
>   		{ { 0, 2147483647 } },
>   	},
> +	{
> +		"ALU64_MUL_X: 64x64 multiply, low word",
> +		.u.insns_int = {
> +			BPF_LD_IMM64(R0, 0x0fedcba987654321LL),
> +			BPF_LD_IMM64(R1, 0x123456789abcdef0LL),
> +			BPF_ALU64_REG(BPF_MUL, R0, R1),
> +			BPF_EXIT_INSN(),
> +		},
> +		INTERNAL,
> +		{ },
> +		{ { 0, 0xe5618cf0 } }

Same here. Maybe capture the true 64-bit R0 value?

> +	},
> +	{
> +		"ALU64_MUL_X: 64x64 multiply, high word",
> +		.u.insns_int = {
> +			BPF_LD_IMM64(R0, 0x0fedcba987654321LL),
> +			BPF_LD_IMM64(R1, 0x123456789abcdef0LL),
> +			BPF_ALU64_REG(BPF_MUL, R0, R1),
> +			BPF_ALU64_IMM(BPF_RSH, R0, 32),
> +			BPF_EXIT_INSN(),
> +		},
> +		INTERNAL,
> +		{ },
> +		{ { 0, 0x2236d88f } }
> +	},
>   	/* BPF_ALU | BPF_MUL | BPF_K */
>   	{
>   		"ALU_MUL_K: 2 * 3 = 6",
> @@ -3161,6 +3186,29 @@ static struct bpf_test tests[] = {
>   		{ },
>   		{ { 0, 0x1 } },
>   	},
> +	{
> +		"ALU64_MUL_K: 64x32 multiply, low word",
> +		.u.insns_int = {
> +			BPF_LD_IMM64(R0, 0x0123456789abcdefLL),
> +			BPF_ALU64_IMM(BPF_MUL, R0, 0x12345678),
> +			BPF_EXIT_INSN(),
> +		},
> +		INTERNAL,
> +		{ },
> +		{ { 0, 0xe242d208 } }
> +	},
> +	{
> +		"ALU64_MUL_K: 64x32 multiply, high word",
> +		.u.insns_int = {
> +			BPF_LD_IMM64(R0, 0x0123456789abcdefLL),
> +			BPF_ALU64_IMM(BPF_MUL, R0, 0x12345678),
> +			BPF_ALU64_IMM(BPF_RSH, R0, 32),
> +			BPF_EXIT_INSN(),
> +		},
> +		INTERNAL,
> +		{ },
> +		{ { 0, 0xc28f5c28 } }
> +	},
>   	/* BPF_ALU | BPF_DIV | BPF_X */
>   	{
>   		"ALU_DIV_X: 6 / 2 = 3",
> 
