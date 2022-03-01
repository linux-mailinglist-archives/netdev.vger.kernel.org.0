Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3E34C83E3
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 07:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbiCAGXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 01:23:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbiCAGXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 01:23:11 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF9251C91B;
        Mon, 28 Feb 2022 22:22:29 -0800 (PST)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21SMwhxm028391;
        Mon, 28 Feb 2022 22:22:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Ybc9cMSGcAbePqq5mz+KtS1w8YA2BkCkBl5EiLpKzlc=;
 b=c/FHSEhDAx2aDc5WmBg3wG5+aTTFLJrEUfjnHspPb7Npp2Y5FPWxSEyGIJfOs8UxCUYu
 jPwd72a9J9s6Qd3xuzmebW8/qatJLwNPfjbwvFo441IPlEoqxml1VfFFstKSzk1nHS5+
 Gp/V5a/VyDsoYrtpe06u9yRCUbj4wiorWKs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3egxd5e364-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 28 Feb 2022 22:22:13 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 28 Feb 2022 22:22:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JzdWrNbA216gRkmQefneJbwRAEZrlbl6Bd0MiUckD8WMTdAc7W5F406g/rEitd5KL2LRDIoP88evE5JIXW/wEU92r3EugN5Qck3wBfeJxG9e1bjvLT6MM+9101lygI72Qz6p/Hrjq4NgmjIotx3F/2e1O8E8aKpvEnJSihW9xI8ZChHnq81cG29Grs50opW37n22kWGzJ4FSkegJ4o/fy17Ru9qGvn/IlqsOd4As9hf2EBRltsDxph7xw31pF+N9r61Cv1LmIUgUmRBuOBdsLwRto0eTSxpviKnj3tOHxZUM+FqmkKkXr7ptTCROT5EFkXIJ7Nxbp3XJELXzvp9fug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ybc9cMSGcAbePqq5mz+KtS1w8YA2BkCkBl5EiLpKzlc=;
 b=mFJnTCo2h8NWWBQspcPrcojhWzhL3MWR2T3qfCFYDEZw2qgmxV/Dti2kb9TEZ2c8frCafN1os8CkZduinwMloDUtHur3iuZXqCIOC2DJimjCImn4foW+iHqsMtNj/3HzZKl2r9vATlsK1vVQufhgeJwoSuE/JZ93K2ZIXqmAsdpBS+n/8/zO0Wo+OxFcAn+Wp6LZedZ2DzFznz5FkHL+smLIukn1NutaWsOO1pF1gkqGrzmc7xO4EywxwonynPyQuwghelDwKkFdWr5niGOV/UjmbYiIl9kXoq5+5wKMthf/5pUWJzV/+C0Eie8na2bjglMWsSR2+VQYvx5vb38nIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by LV2PR15MB5335.namprd15.prod.outlook.com (2603:10b6:408:17d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Tue, 1 Mar
 2022 06:22:11 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1d2d:7a0f:fa57:cbdd]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1d2d:7a0f:fa57:cbdd%8]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 06:22:11 +0000
Date:   Mon, 28 Feb 2022 22:22:07 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        <kernel-team@cloudflare.com>, Ilya Leoshkevich <iii@linux.ibm.com>
Subject: Re: [PATCH bpf-next v2 3/3] selftests/bpf: Fix test for 4-byte load
 from dst_port on big-endian
Message-ID: <20220301062207.d3aqge5qg623asr6@kafai-mbp.dhcp.thefacebook.com>
References: <20220227202757.519015-1-jakub@cloudflare.com>
 <20220227202757.519015-4-jakub@cloudflare.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220227202757.519015-4-jakub@cloudflare.com>
X-ClientProxiedBy: MWHPR13CA0048.namprd13.prod.outlook.com
 (2603:10b6:300:95::34) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9d5d211-1739-436b-90a1-08d9fb4bd1ad
X-MS-TrafficTypeDiagnostic: LV2PR15MB5335:EE_
X-Microsoft-Antispam-PRVS: <LV2PR15MB5335BCB6B25FB4E3B1ECFC0FD5029@LV2PR15MB5335.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vp3bpmXdw62WTLdZsKpXoiGRhpflLZUGLJ8QWDyywjT82so/czVV/KjbhrmTpWQSkrod37TXQyhvvD/H9//n6kQGVlZ9JTfo4MwrvCJmTC2ORKYvBcjoqQKB9/Oez3ClN/PMxHK8eCYA8MD4WSvbToaIhCMhjABElsJKQDDadpl4noA82DG+6ee6G+a7dfeWG8uLuI6PXvcFMSOfGlT5JfW/1o5mxtYlEKB9SgmrEsR2ubIKkMEpusuX7hVlMySZEIIgJhikNtO71AHlVlJE2rxj86WBAP30Q/7iRvMK193IuKQkjKJNPFyeBZ+o047Lz4589Vgn+cxcFQ1SgAoHSPkfhlCBAATTKSnfQZIBYCD/V75FEq5jzUCZr9gURV8ees7ghf8V6S9J/5HlZJWkrTK5jwwAltO3fZ02BPYBxGY0dds4SFIjWt1j6nWIkT8JRB02re4ElDpao80sHURYhLN4vrEibkpietbSdfXSb9uaHUo06HWZcYASSsxnpsmc8tMQDDjmf7O0Fu9ZzM6AYrUq2QpZqevwEX1zZjaN+kyKjo9XxQItIEkpkHwk7lyjhYoDH7lZy/UOUFAnqHMOTKPQ1VmUbIpXftrNXIzhlnVtbDNsETzotfuPBS6zC3RjJ3v+8XB/tT18qv0CB6m/XA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(2906002)(316002)(6916009)(54906003)(6486002)(4326008)(86362001)(38100700002)(66946007)(66476007)(66556008)(9686003)(8936002)(1076003)(6506007)(6666004)(6512007)(52116002)(5660300002)(83380400001)(8676002)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PDogrpuF6DclhF1P7d/b3WER/hA2mr56w491Htp4qpAb2eEUdNmKLExnTFG4?=
 =?us-ascii?Q?xF2ck86GEOdYgqLZxZfPa/hf9v4K2nw/lXG3JPUrMdFLU0ZsWVQvP2KuhfAx?=
 =?us-ascii?Q?RHfUNViFOqIxX9n8CSxVD5y0zpU7Zxj83V9gRopNUEo9+1ThsVRo3fAyJtGc?=
 =?us-ascii?Q?C4o+K7vDkSf4bZnBboS1T45p3fJcw7+0RuV7g0QxU2va9Qlytqt/IFODXdu9?=
 =?us-ascii?Q?pmTGrGSoxSxDy7v4fEqr6qILit51OuUtWHJaYkV6z75p9P+bnjmYLhpRuW19?=
 =?us-ascii?Q?ZpxRHX+I8C+9hozDdWjYKRtCId3/w2elEIykyba0EN/Y7xeLIjm8efoajVVU?=
 =?us-ascii?Q?6r+6Ib64JOBCVggNrpzPRgL+p7aV4QcN6gFmZB4lEPjX7jM73ou8WvRfBbsV?=
 =?us-ascii?Q?eWkIhC66+G/nXqCobl4huV+wKywKBQp04ujfG/fW1TbGMFgeQR40b4PGuzlX?=
 =?us-ascii?Q?ceZeqxQdA7ZFUJnR7Qt6gdk8x1zrWt52387ymU0dKs3405YJ/Q3bemecJBE3?=
 =?us-ascii?Q?DPRzcOOm4S99N+EN8JWzG81d1LnFLbfAJaWk95epwmT6GWOC5cZ4oWzLS6xt?=
 =?us-ascii?Q?mLzP0dYUZd7+wMoWsM0wIxoyihr8LnFv4iRO3DOdwSDQQ3j3VPvvwpBo4OHy?=
 =?us-ascii?Q?PCgJRrAp2icLV0kcR8LwhJDrk7FNztHDVfmh9PTXAwJfUPtoag/ceqhRGxGG?=
 =?us-ascii?Q?tDYil0VJPS/PXAZKc9FNut0KPPTS3le3F5RldS7B3vgbW4BQo5EyALmSE9l4?=
 =?us-ascii?Q?7Po1SHReyrBjGk6REl1qyhZ7fPtawDyG55gDexiz5H1qTY2uwPGi4R0yVQR6?=
 =?us-ascii?Q?5S2t8kBScae+W/E/EOUl3lM/NMv2FNx+nBj4qAZNesfoFf5pioHzRQQ9QVRO?=
 =?us-ascii?Q?2cNAC/klv8i9lfYsBspm4lLvhuJKPr5lWY8WQ10KYrXzphBu0XvXXvnUeN7u?=
 =?us-ascii?Q?3uy+L7Wu9w6EXDqLgeLe76vjB076jeyUkNEnN3F5tncxU+3F4eBP3/lpF5uQ?=
 =?us-ascii?Q?m1jm0rgfazlRKaiztgvXt4dBeo3ZAvybbb4IRBcrpYJVta/x85BTCj2WUrTw?=
 =?us-ascii?Q?B7ogrx+ya5QckcXBIHY0gwWshd/Hsj/8q7lRQA1aFAA4VphzGYjwrumkZ2H5?=
 =?us-ascii?Q?rrqmZqsoSnKj7ACcTX0ZAn3miutQ/JeReuudIpu/W4LpZiJsPB54gvtpAJLt?=
 =?us-ascii?Q?oywRKoPCBga0XEN3yWgi0r5UpR8A9JQX2mgv8p76wKaqdmKXrwg7aNjXfGaV?=
 =?us-ascii?Q?fX+fX3I4wBFA2EUqHfo4wMjJoEuCjsXL7wEKeXzFJ5EMz3XrwKi991oANGfM?=
 =?us-ascii?Q?lebNVp8t/k0nsEigOMMYqfIg79wOOMAKqGraBp9a8f9nAJFYMoXuK2XM6SLw?=
 =?us-ascii?Q?FrE7u9qKIL20MB6Pgl8rwDc7JWaGCrMFbAdYrcIm1tudFfWXFmgfEvkiYqup?=
 =?us-ascii?Q?uez+0kK0nk7vb6suQp4SXOX7SaUMdPR1A3f77zypGkFwLWgwMIJw+0Hvgb8v?=
 =?us-ascii?Q?ZDIKNh0q8appxzzt67zA93+MSKgwa76By1iMK6gJtyAALbFVBNSBZS2JqlLU?=
 =?us-ascii?Q?PEWBFxm9ILl8/H/mbrgTRpD/O80KraNvd0fPy469?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f9d5d211-1739-436b-90a1-08d9fb4bd1ad
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 06:22:11.1692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OOvELB9DFUbKd91StyW8o6ijpHIQiS/jO1YC5wDaEYVmA9fCmts56iIv1Tn3k8p9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR15MB5335
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: Z-jjrI2xeS9ul0YlxAf8geANezFfTo2v
X-Proofpoint-ORIG-GUID: Z-jjrI2xeS9ul0YlxAf8geANezFfTo2v
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-28_10,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 bulkscore=0 spamscore=0 priorityscore=1501 clxscore=1015
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203010027
X-FB-Internal: deliver
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 27, 2022 at 09:27:57PM +0100, Jakub Sitnicki wrote:
> The check for 4-byte load from dst_port offset into bpf_sock is failing on
> big-endian architecture - s390. The bpf access converter rewrites the
> 4-byte load to a 2-byte load from sock_common at skc_dport offset, as shown
> below.
> 
>   * s390 / llvm-objdump -S --no-show-raw-insn
> 
>   00000000000002a0 <sk_dst_port__load_word>:
>         84:       r1 = *(u32 *)(r1 + 48)
>         85:       w0 = 1
>         86:       if w1 == 51966 goto +1 <LBB5_2>
>         87:       w0 = 0
>   00000000000002c0 <LBB5_2>:
>         88:       exit
> 
>   * s390 / bpftool prog dump xlated
> 
>   _Bool sk_dst_port__load_word(struct bpf_sock * sk):
>     35: (69) r1 = *(u16 *)(r1 +12)
>     36: (bc) w1 = w1
>     37: (b4) w0 = 1
>     38: (16) if w1 == 0xcafe goto pc+1
>     39: (b4) w0 = 0
>     40: (95) exit
> 
>   * s390 / llvm-objdump -S --no-show-raw-insn
x86_64

> 
>   00000000000002a0 <sk_dst_port__load_word>:
>         84:       r1 = *(u32 *)(r1 + 48)
>         85:       w0 = 1
>         86:       if w1 == 65226 goto +1 <LBB5_2>
>         87:       w0 = 0
>   00000000000002c0 <LBB5_2>:
>         88:       exit
> 
>   * x86_64 / bpftool prog dump xlated
> 
>   _Bool sk_dst_port__load_word(struct bpf_sock * sk):
>     33: (69) r1 = *(u16 *)(r1 +12)
>     34: (b4) w0 = 1
>     35: (16) if w1 == 0xfeca goto pc+1
>     36: (b4) w0 = 0
>     37: (95) exit
> 
> This leads to surprisings results. On big-endian platforms, the loaded
> value is as expected. The user observes no difference between a 4-byte load
> and 2-byte load. However, on little-endian platforms, the access conversion
> is not what would be expected, that is the result is left shifted after
> converting the value to the native byte order.
> 
> That said, 4-byte loads in BPF from sk->dst_port are not a use case we
> expect to see, now that the dst_port field is clearly declared as a u16.
> 
> Account for the quirky behavior of the access converter in the test case,
> so that the check passes on both endian variants.
> 
> Fixes: 8f50f16ff39d ("selftests/bpf: Extend verifier and bpf_sock tests for dst_port loads")
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  .../selftests/bpf/progs/test_sock_fields.c        | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/bpf/progs/test_sock_fields.c b/tools/testing/selftests/bpf/progs/test_sock_fields.c
> index 186fed1deaab..3dddc173070c 100644
> --- a/tools/testing/selftests/bpf/progs/test_sock_fields.c
> +++ b/tools/testing/selftests/bpf/progs/test_sock_fields.c
> @@ -256,10 +256,23 @@ int ingress_read_sock_fields(struct __sk_buff *skb)
>  	return CG_OK;
>  }
>  
> +/*
> + * NOTE: 4-byte load from bpf_sock at dst_port offset is quirky. The
> + * result is left shifted on little-endian architectures because the
> + * access is converted to a 2-byte load. The quirky behavior is kept
> + * for backward compatibility.
> + */
>  static __noinline bool sk_dst_port__load_word(struct bpf_sock *sk)
>  {
> +#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
> +	const __u8 SHIFT = 16;
> +#elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
> +	const __u8 SHIFT = 0;
> +#else
> +#error "Unrecognized __BYTE_ORDER__"
> +#endif
>  	__u32 *word = (__u32 *)&sk->dst_port;
> -	return word[0] == bpf_htonl(0xcafe0000);
> +	return word[0] == bpf_htonl(0xcafe << SHIFT);
I believe it should be fine.  It is the behavior even before
commit 4421a582718a ("bpf: Make dst_port field in struct bpf_sock 16-bit wide") ?

btw, is it the same as testing "return word[0] == bpf_hton's'(0xcafe);"

>  }
>  
>  static __noinline bool sk_dst_port__load_half(struct bpf_sock *sk)
> -- 
> 2.35.1
> 
