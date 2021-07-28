Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 462913D99C4
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 01:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232727AbhG1Xwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 19:52:32 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23368 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232609AbhG1Xwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 19:52:30 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16SNnEqL011521;
        Wed, 28 Jul 2021 16:52:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=vKOaTnq93hhberq5UZQrxSk9y4qbefPy/lG9x5lsKLA=;
 b=D7py8OO4XX6wMKY9kjHJt+1O/qPXmdNZ6WQfoEgTLvrC9aZkU/4926rLle1RHGf8IYZb
 Zid10TY8HTgdQe8ctildx04R0oDtz48Abi/8I/EEvQgKRyTh8YUSZ852AWr37X/Dq1ok
 wOCC5lveFDVAI8HWQuJr5SjN2HS6uWo0UlM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3a3ecngyh3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 28 Jul 2021 16:52:15 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 28 Jul 2021 16:52:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LRD5jT0C+fQpCHlP+bJLeXiYrRfs+a+PO6fFO6bvGPGXpTZ0TG9YyaH+tvRMNSFQ7cHs1BpD8xp/d5Igr5WIdacn0ldDfRtbvoiV8C9nCyGucz4ioKFmdc4lpd0YLHzY0bZjzCdOcKGCP/8NnVF4popnFJcJd3NdbNbcv15w2xrnMxh3TTsl4CfcrgKjhrECD9cmb+qtEkXokaOpRqJbsrp35YbR1S+a6JIMHw+gDP1hH1barc/KmX2p8YmnCP7gGREqbBtub2RSqkB7qt16a0FM5rhqF2kpyXIauIs8RCnCW8j5YX08kvN0j+9WH0Ut2mz+nH4t6cpNTYg5VTlHig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vKOaTnq93hhberq5UZQrxSk9y4qbefPy/lG9x5lsKLA=;
 b=EazhCjHFSeWpLicQIT60Wp5biRg6YYBz0QYOR68xjUuRdsMR4k9TWjVe+raBUmq24NxTVBMU3jJhp7RfxOolJmduoMumvA5Bcp7beARANwkFk4sqBvfWU57c1joKUhq/n/+Au2XkwTm2YT5kpCSfV0iVHWTz2QDlUhX1jQ7cEX0OyEzbavBJhpDqsQg8AnbT9A6GvBAMKm0Ybb32xLYubQxfl4KvBEPjs4BL7eKWnh6u2alSWWUZl1HQdgd3ib+CxW+bhI7UWlUkh0EmHxtkI9VIGY+bOIIlUi+DFpCpbU8zyDFhFjw5sgzkLFFJazaj6cV9Ct2w75lUFbOxZn1DBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4435.namprd15.prod.outlook.com (2603:10b6:806:196::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Wed, 28 Jul
 2021 23:52:12 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb%7]) with mapi id 15.20.4373.021; Wed, 28 Jul 2021
 23:52:12 +0000
Subject: Re: [PATCH 08/14] bpf/tests: Add tests for ALU operations implemented
 with function calls
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>
CC:     <kafai@fb.com>, <songliubraving@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <Tony.Ambardar@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20210728170502.351010-1-johan.almbladh@anyfinetworks.com>
 <20210728170502.351010-9-johan.almbladh@anyfinetworks.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <ba3656eb-500b-9f14-1c97-d27868f1c3e6@fb.com>
Date:   Wed, 28 Jul 2021 16:52:08 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <20210728170502.351010-9-johan.almbladh@anyfinetworks.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0045.namprd11.prod.outlook.com
 (2603:10b6:a03:80::22) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::1398] (2620:10d:c090:400::5:8298) by BYAPR11CA0045.namprd11.prod.outlook.com (2603:10b6:a03:80::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend Transport; Wed, 28 Jul 2021 23:52:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f1cb998b-75c2-45f5-6f68-08d95222b7f4
X-MS-TrafficTypeDiagnostic: SA1PR15MB4435:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB44350B415D1D7909D155EEECD3EA9@SA1PR15MB4435.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gckL69XIoyLpytmdGqOJLqTrCOpnC8Fd4ZTDG/7/5BRNLpT2e5r2ocLSO0zUR3ORvpZaUa9+IXzfyQrqWtBLL8SAFmtXHZkp5J0KEjxkUbVe+uULgJfmTjji4i6mO/QU8gdIFOJlF9LrCARsK+lTZUXCoge4u/ZeoJQoLbENYcjit8FdJB2Y1PDXFgM2kZgNSPKR+opIbktIKZmiAmieHA6Qpzp2Y+pONIxlfDLipFoXBf9CaXe8M4Paog+LZrRu9Chk7JN+SXbhNjiY2/ixZzYAnPYWqgc8o6wFX8aCqz/6y7anPPD+G+iEwO6U1O2px5SI4nZqdoWU6TZ+yDf4Vrg748Abz0GhkgYolinVpoLLFD3E+ZNBPJBspnIEABMYXWOHg7PsmFBqfbmuD8zmJcxa+s5KmE0hFF4OSYY+CqWeONta+tNV79EndV5GZlA7sTivUGQMnmLLd2F4KVKvihbLhU4B2eNbAHpSZa+nn2GwavbCV4gSo45AsZVuAQSAdyhl9GuOKpXmhOGursTVChhQvORQMTxHo5L9WI7ycHUD28r+w7IGMm/PjbxpVMgoZmhYARxCEq0nGHcSCvDCrqVYpb41ZQ6hj4m+nt9TvNGjuzAFL/QcdEiwUMGP9LPb228XJM+BuTXFFpYHDitUYUGRgJ7PDfxw8okdHQfwuTcjWxjKH2qLWsXfuZbvsmdxw6J+Bw3Q3s9yTPAYwJA2vJIzvA4kuqugzlS95bvA8EA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31696002)(508600001)(8936002)(6486002)(86362001)(2906002)(66946007)(8676002)(38100700002)(66476007)(316002)(6666004)(31686004)(53546011)(4326008)(2616005)(66556008)(52116002)(36756003)(5660300002)(186003)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eVJPNjVsbUxjSmlPK1VjUDFoVkpyTEVqOGlFbUdJV1U1ZzIyckJxRXFpajc4?=
 =?utf-8?B?U2VBamdyTGRzOENldjVVUFlRRlBRZDdOSlBxdkFuUFNtR1prSUVRNks0cG9Z?=
 =?utf-8?B?azV6ZTVnaVJpQkora2F1ZHNIckt0Tzg1eGY5aFZNeFBpM0hHRGpRR2NWMlRB?=
 =?utf-8?B?WG1lOE1WekU2YjlIVXluMU9tMG80TTByVlVOQzlBRWl6T2xRWHlyMkVXd0Y1?=
 =?utf-8?B?VHJQc2ZjYWczQnlQRUxONmZtbmJwZVNyd3dVdWNlTEkwK0VWcHhZSkNwV25Z?=
 =?utf-8?B?U0dTYzlFbkREY2o4TEswcjZjbWQ1NDlmRk5JOEMzaDZTQWdmbVdxM2pPOGVI?=
 =?utf-8?B?OFY3QXZINGgvVG5DUjZ0WlFHcDhrVVI3eHZUVTV2MElBdXhXbEVTTTFZZGMy?=
 =?utf-8?B?ODNmcGNSSUg0UFI2dzdpMEk1ZzJEdHdqcGdoNXpIMk9pL3ZMQUdSVHIwWUhG?=
 =?utf-8?B?NW8xV0trR1Rua1hoQUtsVU14ODFlcEJ5elUrWXNRdnhuY0VUOXRmMTNYWi9x?=
 =?utf-8?B?QTNxSTFhc3BXSm1wNHJpUEFKd0lya2l6ME1zMCtjV0xWRS9aOVBpSUpaWnNw?=
 =?utf-8?B?MnRxVEtVZEkra2lwSGsvVXBwdjY1TzR2dDl1NS81VkU4MTA3TWdCT1BpNGhl?=
 =?utf-8?B?U05rT3g0azI5RmgrL2dkMXJLTFFRdXRsU0pacTd4Z0h2b0FNcmg0TVNmZGVR?=
 =?utf-8?B?a1JoRXBFemJzendReGl4THJwYWd4MEFwQkZ5NnUzdlBibVZTbkNiZlZ1cTRX?=
 =?utf-8?B?V09GQXBnR29UTmNhOEtIOXQ1TjhuQnhKY0JZaExwaG1ZS3FlOW8vUU1Va2to?=
 =?utf-8?B?RjNLcFNMcGFIZUlSL1VQT0UrYUk1LzJDbGtjWnorSCt6MDU4elo5MW1qUDFJ?=
 =?utf-8?B?TERLZTJnT0FLZC9vVzJES3hrcEp5NzJoVGhSTlNnYTU1d2Q4RkpuL2NjWXRp?=
 =?utf-8?B?ZXV3REhjcmg1eGw1Y0U2Q0pYQVRpT2dSbkYxeHR0NGQ5SkQwYkh0alNiUWFM?=
 =?utf-8?B?Wm5OMWpVUXhNbTVTWU8rMmtia1RZajVaTkpqcmFCa3p1M2lHUmdSZlhXb09V?=
 =?utf-8?B?YnVlYXVzR3JtVis5OUJJUzFrelJBR2twdjJqQVVxSzIwbVduTkJUeUNBSW83?=
 =?utf-8?B?cU9iT3dUdDRjTWZJdkRUOC9iSGFCZlFHZGNiN1pzQVAwQkpONkVOZHBFRHgx?=
 =?utf-8?B?Y3p0RWdpaG52U3dNOThEcUFXU1o3dEpXbG8zblBjWU9jZFp4UUdpRHF4aWtC?=
 =?utf-8?B?K0l2RGNPOXFDb0s5aDlsZU9KWmZOOHEzUVc0TmJsSE5Db3dldURGZXZvVHdE?=
 =?utf-8?B?bytLWFlJeWJwcHU2WkwzSEdXT0FJQWJjRWsrMWpFS2gxUnU2RkozNEgwcURr?=
 =?utf-8?B?cUN1dS9rem5uTE5idHNKYjdqSGFPeVlnbGxhS3VBbkJ3M2F3NHdhb2EzbVhS?=
 =?utf-8?B?OWxoaytxeWdnZTZXbjBRbit6R0hydldEN1dXZGpUWnQyWHhHQjJjZW9qUXlr?=
 =?utf-8?B?VGdQU2dJMVRpcnJXZlg1UFpyL0pnTHdSYlg0UlY2Tm5QaHBoTzZvRHphT1U4?=
 =?utf-8?B?b0RDdjk3ZTdkVDYzRUtzbDlVQTVkT3hBODd1UGVZMjNCVitSUWZibkM3SUU1?=
 =?utf-8?B?eHN2dXFUeXFja0x0TUdISko0aHAvWVFNNDdDVlV3b1NMbFAwdlVqc1pqb0tW?=
 =?utf-8?B?bjBBU2VBK3QwUXIrRlBRUTBwTjNFODY3VXZzdU1xM0NGQVhuME9uNnFUYms0?=
 =?utf-8?B?dUxxc29Ua3g2MzdQZnBsUmhWM0hiV1QxYjhOMHlSdzdFOUlFUm5FYU5OSnpu?=
 =?utf-8?Q?OhtzeRNcWCYMHh5BRnNRM6R19A/WvZeFd2fgE=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f1cb998b-75c2-45f5-6f68-08d95222b7f4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 23:52:11.9180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aKd/yeiCJ6NBLEObKcCxkItG+arL+ojiaSyIiV/x+V4JMIkrT/i82MeG0e0xlPIY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4435
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: aM2zKMKEWckCDk9LTe5kxREEtHrNqYIR
X-Proofpoint-ORIG-GUID: aM2zKMKEWckCDk9LTe5kxREEtHrNqYIR
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-28_12:2021-07-27,2021-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 impostorscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107280124
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/28/21 10:04 AM, Johan Almbladh wrote:
> 32-bit JITs may implement complex ALU64 instructions using function calls.
> The new tests check aspects related to this, such as register clobbering
> and register argument re-ordering.
> 
> Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
> ---
>   lib/test_bpf.c | 138 +++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 138 insertions(+)
> 
> diff --git a/lib/test_bpf.c b/lib/test_bpf.c
> index eb61088a674f..1115e39630ce 100644
> --- a/lib/test_bpf.c
> +++ b/lib/test_bpf.c
> @@ -1916,6 +1916,144 @@ static struct bpf_test tests[] = {
>   		{ },
>   		{ { 0, -1 } }
>   	},
> +	{
> +		/*
> +		 * Register (non-)clobbering test, in the case where a 32-bit
> +		 * JIT implements complex ALU64 operations via function calls.
> +		 */
> +		"INT: Register clobbering, R1 updated",
> +		.u.insns_int = {
> +			BPF_ALU32_IMM(BPF_MOV, R0, 0),
> +			BPF_ALU32_IMM(BPF_MOV, R1, 123456789),
> +			BPF_ALU32_IMM(BPF_MOV, R2, 2),
> +			BPF_ALU32_IMM(BPF_MOV, R3, 3),
> +			BPF_ALU32_IMM(BPF_MOV, R4, 4),
> +			BPF_ALU32_IMM(BPF_MOV, R5, 5),
> +			BPF_ALU32_IMM(BPF_MOV, R6, 6),
> +			BPF_ALU32_IMM(BPF_MOV, R7, 7),
> +			BPF_ALU32_IMM(BPF_MOV, R8, 8),
> +			BPF_ALU32_IMM(BPF_MOV, R9, 9),
> +			BPF_ALU64_IMM(BPF_DIV, R1, 123456789),
> +			BPF_JMP_IMM(BPF_JNE, R0, 0, 10),
> +			BPF_JMP_IMM(BPF_JNE, R1, 1, 9),
> +			BPF_JMP_IMM(BPF_JNE, R2, 2, 8),
> +			BPF_JMP_IMM(BPF_JNE, R3, 3, 7),
> +			BPF_JMP_IMM(BPF_JNE, R4, 4, 6),
> +			BPF_JMP_IMM(BPF_JNE, R5, 5, 5),
> +			BPF_JMP_IMM(BPF_JNE, R6, 6, 4),
> +			BPF_JMP_IMM(BPF_JNE, R7, 7, 3),
> +			BPF_JMP_IMM(BPF_JNE, R8, 8, 2),
> +			BPF_JMP_IMM(BPF_JNE, R9, 9, 1),
> +			BPF_ALU32_IMM(BPF_MOV, R0, 1),
> +			BPF_EXIT_INSN(),
> +		},
> +		INTERNAL,
> +		{ },
> +		{ { 0, 1 } }
> +	},
> +	{
> +		"INT: Register clobbering, R2 updated",
> +		.u.insns_int = {
> +			BPF_ALU32_IMM(BPF_MOV, R0, 0),
> +			BPF_ALU32_IMM(BPF_MOV, R1, 1),
> +			BPF_ALU32_IMM(BPF_MOV, R2, 2 * 123456789),
> +			BPF_ALU32_IMM(BPF_MOV, R3, 3),
> +			BPF_ALU32_IMM(BPF_MOV, R4, 4),
> +			BPF_ALU32_IMM(BPF_MOV, R5, 5),
> +			BPF_ALU32_IMM(BPF_MOV, R6, 6),
> +			BPF_ALU32_IMM(BPF_MOV, R7, 7),
> +			BPF_ALU32_IMM(BPF_MOV, R8, 8),
> +			BPF_ALU32_IMM(BPF_MOV, R9, 9),
> +			BPF_ALU64_IMM(BPF_DIV, R2, 123456789),
> +			BPF_JMP_IMM(BPF_JNE, R0, 0, 10),
> +			BPF_JMP_IMM(BPF_JNE, R1, 1, 9),
> +			BPF_JMP_IMM(BPF_JNE, R2, 2, 8),
> +			BPF_JMP_IMM(BPF_JNE, R3, 3, 7),
> +			BPF_JMP_IMM(BPF_JNE, R4, 4, 6),
> +			BPF_JMP_IMM(BPF_JNE, R5, 5, 5),
> +			BPF_JMP_IMM(BPF_JNE, R6, 6, 4),
> +			BPF_JMP_IMM(BPF_JNE, R7, 7, 3),
> +			BPF_JMP_IMM(BPF_JNE, R8, 8, 2),
> +			BPF_JMP_IMM(BPF_JNE, R9, 9, 1),
> +			BPF_ALU32_IMM(BPF_MOV, R0, 1),
> +			BPF_EXIT_INSN(),
> +		},
> +		INTERNAL,
> +		{ },
> +		{ { 0, 1 } }
> +	},

It looks like the above two tests, "R1 updated" and "R2 updated" should 
be very similar and the only difference is one immediate is 123456789 
and another is 2 * 123456789. But for generated code, they all just have
the final immediate. Could you explain what the difference in terms of
jit for the above two tests?

> +	{
> +		/*
> +		 * Test 32-bit JITs that implement complex ALU64 operations as
> +		 * function calls R0 = f(R1, R2), and must re-arrange operands.
> +		 */
> +#define NUMER 0xfedcba9876543210ULL
> +#define DENOM 0x0123456789abcdefULL
> +		"ALU64_DIV X: Operand register permutations",
> +		.u.insns_int = {
> +			/* R0 / R2 */
> +			BPF_LD_IMM64(R0, NUMER),
> +			BPF_LD_IMM64(R2, DENOM),
> +			BPF_ALU64_REG(BPF_DIV, R0, R2),
> +			BPF_JMP_IMM(BPF_JEQ, R0, NUMER / DENOM, 1),
> +			BPF_EXIT_INSN(),
> +			/* R1 / R0 */
> +			BPF_LD_IMM64(R1, NUMER),
> +			BPF_LD_IMM64(R0, DENOM),
> +			BPF_ALU64_REG(BPF_DIV, R1, R0),
> +			BPF_JMP_IMM(BPF_JEQ, R1, NUMER / DENOM, 1),
> +			BPF_EXIT_INSN(),
> +			/* R0 / R1 */
> +			BPF_LD_IMM64(R0, NUMER),
> +			BPF_LD_IMM64(R1, DENOM),
> +			BPF_ALU64_REG(BPF_DIV, R0, R1),
> +			BPF_JMP_IMM(BPF_JEQ, R0, NUMER / DENOM, 1),
> +			BPF_EXIT_INSN(),
> +			/* R2 / R0 */
> +			BPF_LD_IMM64(R2, NUMER),
> +			BPF_LD_IMM64(R0, DENOM),
> +			BPF_ALU64_REG(BPF_DIV, R2, R0),
> +			BPF_JMP_IMM(BPF_JEQ, R2, NUMER / DENOM, 1),
> +			BPF_EXIT_INSN(),
> +			/* R2 / R1 */
> +			BPF_LD_IMM64(R2, NUMER),
> +			BPF_LD_IMM64(R1, DENOM),
> +			BPF_ALU64_REG(BPF_DIV, R2, R1),
> +			BPF_JMP_IMM(BPF_JEQ, R2, NUMER / DENOM, 1),
> +			BPF_EXIT_INSN(),
> +			/* R1 / R2 */
> +			BPF_LD_IMM64(R1, NUMER),
> +			BPF_LD_IMM64(R2, DENOM),
> +			BPF_ALU64_REG(BPF_DIV, R1, R2),
> +			BPF_JMP_IMM(BPF_JEQ, R1, NUMER / DENOM, 1),
> +			BPF_EXIT_INSN(),
> +			BPF_LD_IMM64(R0, 1),

Do we need this BPF_LD_IMM64(R0, 1)?
First, if we have it, and next "BPF_ALU64_REG(BPF_DIV, R1, R1)"
generates incorrect value and exit and then you will get
exit value 1, which will signal the test success.

Second, if you don't have this R0 = 1, R0 will be DENOM
and you will be fine.

> +			/* R1 / R1 */
> +			BPF_LD_IMM64(R1, NUMER),
> +			BPF_ALU64_REG(BPF_DIV, R1, R1),
> +			BPF_JMP_IMM(BPF_JEQ, R1, 1, 1),
> +			BPF_EXIT_INSN(),
> +			/* R2 / R2 */
> +			BPF_LD_IMM64(R2, DENOM),
> +			BPF_ALU64_REG(BPF_DIV, R2, R2),
> +			BPF_JMP_IMM(BPF_JEQ, R2, 1, 1),
> +			BPF_EXIT_INSN(),
> +			/* R3 / R4 */
> +			BPF_LD_IMM64(R3, NUMER),
> +			BPF_LD_IMM64(R4, DENOM),
> +			BPF_ALU64_REG(BPF_DIV, R3, R4),
> +			BPF_JMP_IMM(BPF_JEQ, R3, NUMER / DENOM, 1),
> +			BPF_EXIT_INSN(),
> +			/* Successful return */
> +			BPF_LD_IMM64(R0, 1),
> +			BPF_EXIT_INSN(),
> +		},
> +		INTERNAL,
> +		{ },
> +		{ { 0, 1 } },
> +#undef NUMER
> +#undef DENOM
> +	},
>   	{
>   		"check: missing ret",
>   		.u.insns = {
> 
