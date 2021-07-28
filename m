Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 089323D9976
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 01:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbhG1XbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 19:31:04 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:2950 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232116AbhG1XbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 19:31:03 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16SNPWOq026708;
        Wed, 28 Jul 2021 16:30:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=J6rKiqsk3h2PuA2sWPTurzIjC7IXNAGE1Y3Pz6M1Ft4=;
 b=A0ohzcE7GuAiov45ZL9GqCe3SSZdEquuMNrjkf4aBY0G6q0/VP01sl5aDhRxHJ7sI528
 LgSuk4530F/1ZVH/8pOIUEVqqzsxcYKVTEsynyKG4ssn8Oy4YWnSL8smyOSiwdBlKczk
 /Vk+56/b75SNKnsZ1Ge98HlEE0xgJBIKRSs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3a3a9qtp8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 28 Jul 2021 16:30:47 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 28 Jul 2021 16:30:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HDvDr1S9m1g32NCwllWV2Mh7tzkJNCPLhvRurL6vgDvVaChq18hd1IiChi14TnnrdErQ97zxGNcOr7eJOgsHd0VfYjLXppC4kKBTdYna3XLFhEcH4UXB+HwHJKkue2X6RhkIi4yMEnTVrq67np/c+m/2XeFN6zuUft77Ik+pJvX+sL4bJ2SbLMXGdMz3xWAscEPLznb3o9GaWUcpn/aqQ6kkIKq0aCjLcsxuIbKZWf1jJMb2VxrMSekuAs2okHqREqVmW1IgNlqBMVrPpwB1klU2FhhvfbVzlX5/ukviVZH2wyRGK/kHakOv8ie7cHKTY51GQqAgU6BtGDpfjFMqRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J6rKiqsk3h2PuA2sWPTurzIjC7IXNAGE1Y3Pz6M1Ft4=;
 b=FyKGhuvwusRcFgYOkFsRMXEVZWPDwhMozowVeUOW2YWvdiRtuODV8cDNUByUqqUHN744JRr5XkLH0zwVUCjvseVYVZmgS3kmctGkcuqT4P8HUWum/Dr5ctw+LUbZmzTjF/VoUEhUlpQS2mCKREfseDGbkGB0Klwuomb82n74bXhs/pHDY0xDBQqbnVsdcEb+RbbxLBepNVr54XUhRF7uT4RKaWjoAmfH3xP2nBqnuwy5V65zgpQ0VUQAz5nrQitpKkjtPPi8jq0s/3xXT/v1Wzf5im4y9ATGfSsW7z76zSWwRipFmhyOprKqHkSKKP93hKuM0X/oLBbSVEQMheqlmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4869.namprd15.prod.outlook.com (2603:10b6:806:1d0::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.20; Wed, 28 Jul
 2021 23:30:39 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb%7]) with mapi id 15.20.4373.021; Wed, 28 Jul 2021
 23:30:39 +0000
Subject: Re: [PATCH 06/14] bpf/tests: Add more BPF_LSH/RSH/ARSH tests for
 ALU64
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>
CC:     <kafai@fb.com>, <songliubraving@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <Tony.Ambardar@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20210728170502.351010-1-johan.almbladh@anyfinetworks.com>
 <20210728170502.351010-7-johan.almbladh@anyfinetworks.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <b134e3bc-a9f7-6c4f-21fe-8d5068ac029e@fb.com>
Date:   Wed, 28 Jul 2021 16:30:37 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <20210728170502.351010-7-johan.almbladh@anyfinetworks.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0191.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::16) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::1398] (2620:10d:c090:400::5:8298) by SJ0PR03CA0191.namprd03.prod.outlook.com (2603:10b6:a03:2ef::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 23:30:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64303ef6-dcfa-46fa-99af-08d9521fb5af
X-MS-TrafficTypeDiagnostic: SA1PR15MB4869:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB486994E4814882F9C01969EBD3EA9@SA1PR15MB4869.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1RPyQorjHKx5WeUeqOMkoz1v8lzmnxtDQ2Gg73p6i6oePg8dfgRDyWn12GI89jdSrD8roFUK6I2w+KkPq2su7wWUfiCejB2U54qSwRViLrx2cDAHAoAFYhXa1zfq20KA55jLik3KTYm3IGd0TRYoxqNWeHZhD1iKFKh4jZ+1eGUP+oJbrpiiutSqUtHmWwDXr+dI0IgsWYv0vzgPDEoTofqFmZVP0uCwsoFgTkHKh93arSaSRkaJqiGJQ5r8rgUf3Z1ilwNWKB+RU+SgOuo4R5RiOwo5UndX3XhoalTkWpxnq0G3jhKUshgPJ+9v72CWH0rTVhQLwN+oapqI0fF7EFLVaq3O7oytfAo3ySE/622EYkDq0+o9q15GGQOmSWTVKn9/hstrTBmsGn+RSYeDH1I6vfEZQW7rg6ipz4PVG3TMk2G4VQAjaW6DXZyV8rXG5uQ52nWlD4h/cdD2+NbxwKAm8gt2th5qylhmjdrkCztCpk9pfWOQidWRib+ahKxPyf6TgKghJt5/IZAR54dTgaYkMHixGfAVckquGrOIpouXQB+bvn4LmFe5E/6eXfj09sEaR62YI6azf/+kmj3PKsc+j7haEd8vCt/Ot1SK9z1kXYl/CKpjAP56j2KsMBEgNmZVLsLtjuktPcLiaQzOkR0jOsj9/t1+4k7QSoJluInRN7cT1p75lJ+cwAWFMur22+kB9GFIF02jCdrKncv15C1s2htSSG8rcBUcnMGZBIYZ0dSievrm5aC0K2kehLjH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(346002)(39860400002)(376002)(86362001)(53546011)(6486002)(66946007)(52116002)(36756003)(66556008)(66476007)(83380400001)(31686004)(8676002)(2616005)(8936002)(2906002)(38100700002)(478600001)(186003)(316002)(5660300002)(4326008)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OHk2bEczVWFXOU96YXo3WnNnSEM0elJ3bjRieE1uczVjUFpxZ3dxRHlaQTg0?=
 =?utf-8?B?VXBkMDFNT1U5eEU2Y0VsRVRFQmwxdmZZT1JENk1JMElGZGtYVnF6VHdXVEx0?=
 =?utf-8?B?WnFHOG1uVytvM0xadWxLRnhXWEhpYk50TCtDZzN5RlRTMTNXQlBFUUF1QWRu?=
 =?utf-8?B?c2NPdXM0RFlPT1ZyNG82Y084dDMzU3VmQ3hZcTJGemtMMmlTREFvd3hpcjFH?=
 =?utf-8?B?WVVvTGRBaW96ZURPZzlqdkdydlBOU1lzdHdGTkNwam8vVkJhZ0pRcGtuT0gz?=
 =?utf-8?B?SWZUamlTUE5IWlIvV3ArODNDb2ZiNWFoenhDUEJBamxIbStnbXRpVkREbnZP?=
 =?utf-8?B?SDNuQVE1d1F0OHJYNE9NTXQvWEEyMGY2cmtPVytFa1VaQ2lTcHJrV3N4bVBJ?=
 =?utf-8?B?SjFMRDA2ZkxWdDNDZ0hXS3A4U0hHNGZhWms4bCsrQ1NxOVFyR3Z1R0VsMUtH?=
 =?utf-8?B?eW1JQUIwVkcrMnJzd3BJRzA2VTJWMDM1ZUdjT2hHcWFHN1phd2RvcDRSekZj?=
 =?utf-8?B?TDBDcHFLMkdUZHlRY0g0RVVpb25rcHIra3krV0JvVHYzeGhxWmpML3M0Rm1U?=
 =?utf-8?B?QnVjdzZKVTJ1ZzQ2bjZZWEN4OVNGYjJSM29vR0c5MVQ3OGx0dG83NVZBS3N2?=
 =?utf-8?B?SDZLNnV5SnVLNHBmNThiVDlCUDVFRm1QYnRsRU5kekhKMGdJTHQrRkFCOVUw?=
 =?utf-8?B?YUpBTzZRVHBIV1dKMjJMSGVjdkR5anNVUm5PQ0tJYW91NHgzSGZ0cis4NlUv?=
 =?utf-8?B?NTlJMzF4Z1lkM0p3NjBnaXZOUHhZRUNiMUYyUk1iU0FiOWJDTDBGN2dDRWxD?=
 =?utf-8?B?KzZ4ekx1SWFBR2FrN0p4ZzlzSlk0TWpoNlhKRkVRZnRScUhLUEdPTFg5MjM5?=
 =?utf-8?B?eHBxOW9FaUN3VXZUU0FYMXdJeGRGUFI1elBTTUc0Zk9GZkpEZTg2ZzVtcFgr?=
 =?utf-8?B?WXFWYVBPenI2V2dGa2NZb2xRR24zcE4xR2pHdlBxNjhJcjIrWWxJMlVlTXlk?=
 =?utf-8?B?dW9uNm83UnRxY0ZycGIza3o0YzhNeEI3bjVlcDdJQUdiOTI0cE1zM2dINnJa?=
 =?utf-8?B?V2JoN0JHUWs5SzI2alRBQlJHNkZjU28vNTNmQjdSWlh3eTZ4RlZHeFk0NWUz?=
 =?utf-8?B?WndtaE1iQjh5OFFpT05zTVpjcVQxeFlBVEZFWThKSEN2emFvZ2dNY3M3UmRU?=
 =?utf-8?B?akt1M0I5L1VUSGc0WmVXUnV4M1VLN3Vja0xMQUJjV25oQzJ0MndTTWMrWlBu?=
 =?utf-8?B?NWwvSWF6dmprTzFBQ3BMdGNXdHAwRy9oVFVFNWRmdjlkK0xoZGhDS1NzbW15?=
 =?utf-8?B?akF1QmlrdytCYzVoOXlPc0ozemZ3TkRRTTRocWFVS0x6QWF0NHVjQ0VxUE9m?=
 =?utf-8?B?TFFSeVlGT3hYeDQ1TWp5eVBFRjZEMC9Mb2FEd0ZDbnptdmk2UTJHc3F5S1lG?=
 =?utf-8?B?UkxTU250ZmVsOUhKYUN4dFRranlIbXJXWXFkMGZHVWVzcERvYXdSclFKaFhV?=
 =?utf-8?B?QXVnalJqWGFVLzB0U3hhemlGbHMxNVlobnVTYUh4VEZjbE9FNTdLQUZ1ZU9u?=
 =?utf-8?B?czNCNjh0K0ZHYXdUODBBbHBKVlM1TExsa1h5TEd2U1hTVFFxOExXRnQ3MlZs?=
 =?utf-8?B?cUVOTVQxbE8wVVd1dVd2NDdpanp3WlB5OTg0YnFyZEJZdi9YS1pxRXlDcTVx?=
 =?utf-8?B?VkdVelNIdU9TNVlpdzRMOXdFL3p4cURqYy9LOW1PK1JHSzFrR3duRlFid0hI?=
 =?utf-8?B?TE1saXJLajRwbkFVWHM5aEZLdVViZjJ0Y2tTbFFGUVVHNnBHV3dUV1ZNd1Jz?=
 =?utf-8?Q?kteqHjF/82B222SWJLLJVX5bjGbgU47AYaHmc=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 64303ef6-dcfa-46fa-99af-08d9521fb5af
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 23:30:39.6743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SaoWh3rQPpB35Zvg69bv5Ckn4Gs0vH7V3+q21guOJkh0S4NGc3hKQIYmWWYuPAlM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4869
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: ZaLjILL7WHKhbGJIrBzAAuZGzGSjHg_K
X-Proofpoint-ORIG-GUID: ZaLjILL7WHKhbGJIrBzAAuZGzGSjHg_K
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-28_12:2021-07-27,2021-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 mlxlogscore=962
 clxscore=1015 adultscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107280121
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/28/21 10:04 AM, Johan Almbladh wrote:
> This patch adds a number of tests for BPF_LSH, BPF_RSH amd BPF_ARSH
> ALU64 operations with values that may trigger different JIT code paths.
> Mainly testing 32-bit JITs that implement ALU64 operations with two
> 32-bit CPU registers per operand.
> 
> Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
> ---
>   lib/test_bpf.c | 544 ++++++++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 542 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/test_bpf.c b/lib/test_bpf.c
> index ef75dbf53ec2..b930fa35b9ef 100644
> --- a/lib/test_bpf.c
> +++ b/lib/test_bpf.c
> @@ -4139,6 +4139,106 @@ static struct bpf_test tests[] = {
>   		{ },
>   		{ { 0, 0x80000000 } },
>   	},
> +	{
> +		"ALU64_LSH_X: Shift < 32, low word",
> +		.u.insns_int = {
> +			BPF_LD_IMM64(R0, 0x0123456789abcdefLL),
> +			BPF_ALU32_IMM(BPF_MOV, R1, 12),
> +			BPF_ALU64_REG(BPF_LSH, R0, R1),
> +			BPF_EXIT_INSN(),
> +		},
> +		INTERNAL,
> +		{ },
> +		{ { 0, 0xbcdef000 } }

In bpf_test struct, the result is defined as __u32
         struct {
                 int data_size;
                 __u32 result;
         } test[MAX_SUBTESTS];

But the above result 0xbcdef000 does not really capture the bpf program
return value, which should be 0x3456789abcdef000.
Can we change "result" type to __u64 so the result truly captures the 
program return value?

We have several other similar cases for the rest of this patch.

> +	},
> +	{
> +		"ALU64_LSH_X: Shift < 32, high word",
> +		.u.insns_int = {
> +			BPF_LD_IMM64(R0, 0x0123456789abcdefLL),
> +			BPF_ALU32_IMM(BPF_MOV, R1, 12),
> +			BPF_ALU64_REG(BPF_LSH, R0, R1),
> +			BPF_ALU64_IMM(BPF_RSH, R0, 32),
> +			BPF_EXIT_INSN(),
> +		},
> +		INTERNAL,
> +		{ },
> +		{ { 0, 0x3456789a } }
> +	},
[...]
