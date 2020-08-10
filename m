Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51B042400B2
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 03:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgHJBVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Aug 2020 21:21:37 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27138 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726335AbgHJBVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Aug 2020 21:21:37 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07A1IE5k010593;
        Sun, 9 Aug 2020 18:21:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=1y1dGaPumaRNGs+WGqhVnb5gvfAgZfIT0LGPcXP5HXM=;
 b=khcw2qSWR9GbORLIu6OWWVIHuqDccex4r+Ik4zF4kVj8LOb3a10Abv9jJuazCpjwkU+z
 WtWMX+NOWPIlpirLqnH3FDu+9DrvQxci+FDI8IoaB7fkDFEjog9SOpfuO/F4GdTWNscG
 GfSJ+BPGWvoqZyOB+ZtuLqD+Se7i8pVxYnI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32tbvkaatw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 09 Aug 2020 18:21:18 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 9 Aug 2020 18:21:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iLXM4XOiFIEq7REM0+43OeF/HgdViKhFWOZHWqnrt+HPaeTfei5Kprg7p4qRAz95BMy3eVard06rUb786axrpIlxfgUP7mwvzuMJM71H7vKb2Q6HAvGrydUxF24FsXzEgH7W97z9/Tw56rHPV5HK+Vrq9hCZrzW0NKmUW7RoBnnoduLefPqrnniuZz6qOt0Y7KhRMShibhax7Bz4GNYwDMxiM22f+OJ63mwfjqyENZdScRLThkHPxIXVeLaQf8Y8KnMgW7oZgk06VH4OdtkjGY0tsQEIynoB+a93Z6HjQDxJ1gv2wKJIHYGv/a+vtaMjrNcBIjItUTakxE5yACSWXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1y1dGaPumaRNGs+WGqhVnb5gvfAgZfIT0LGPcXP5HXM=;
 b=OnDiKVjHOz7L7mJ5Yl+FDp+Aqq2EkFBJe0mfL0DOj7tdTkPxAUCiu5RK6ZuWGLpslokS5UcbIziPfMNNT+0hORvqk/VBpzdO/MHaHdBmhepUKzdagxng0IssgywJF5ZYAg60qEoGnBPBSIoQO4nE94OhKRFT4LpRhGXvSX/S4It5G9tjtOMZQgZ/Sv34J5Tcm6Lkrk45yAkFSZqmJxMQH0oS7FyO7tgTAjx0xnohrYi4cJBSXu8kPnUHJGwH02k2dF3CeME2t3uxnvmTyMGPeqhUPWo1ilY246ZsrzO3I26AFcoxVuydgJ4clHbPUohX/ED2shmnF58aiO0UP4JNEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1y1dGaPumaRNGs+WGqhVnb5gvfAgZfIT0LGPcXP5HXM=;
 b=bvsd3ulPbdAddl2MOWPj8D1LCiEFjKg12DDlLJVzM0z3QRdU2VQBGz8JcSSgQ4epsylh/3LMlpsuYc7pYE4Yj6t/tqBCbUjW3w0jmsdDFrtKeWUDI+ct3n52MMw42joyvDMfbHtXd02Lxjrhyqf/cNKEzynYQ/N5EtCAoCw1rss=
Authentication-Results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BY5PR15MB3620.namprd15.prod.outlook.com (2603:10b6:a03:1f8::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.20; Mon, 10 Aug
 2020 01:21:03 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3261.024; Mon, 10 Aug 2020
 01:21:03 +0000
Subject: Re: [RFC] bpf: verifier check for dead branch
To:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
References: <20200807173045.GC561444@krava>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <f13fde40-0c07-ff73-eeb3-3c59c5694f74@fb.com>
Date:   Sun, 9 Aug 2020 18:21:01 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200807173045.GC561444@krava>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR04CA0010.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::20) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::11f6] (2620:10d:c090:400::5:8eb1) by BY5PR04CA0010.namprd04.prod.outlook.com (2603:10b6:a03:1d0::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.18 via Frontend Transport; Mon, 10 Aug 2020 01:21:02 +0000
X-Originating-IP: [2620:10d:c090:400::5:8eb1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac9167cf-11f8-4627-ad30-08d83ccba598
X-MS-TrafficTypeDiagnostic: BY5PR15MB3620:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB3620812AAC702581C09A9859D3440@BY5PR15MB3620.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m2P7dwLdKEKN2dl09gh+REfw3JZvnqnOzNHjp6N2jtWHNRsnIbV7Ykac3eMHFyL1UoRoO/rvH2hFJIwUvb65lIS9YmzAy94BoocvmDDiso2Xs+6CgrXTYw2InCxjnBSdQ5Lv7VadCSSIGgPBg8zMhck5tswo2XecpiEioFtsYBxCQPLiG5eXYVWtWyV807kJfTFKBE6iQnBDS1cWuSd7/TyYfBDWTnl0JjH8NSPGnd849nV1df+BpppTfGHpsMEzNUiMRNHGb1wt34PGetcOkpMAdwj3eooPZ374/JKNXwHzq6UvcWe4jZN4AgE1O80av8gVEExqa+l0jicwhP/Pibch94KA0h1OQM+ui2qWsmf58BEK/HAI2leS8CYZq42b
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(366004)(396003)(376002)(346002)(136003)(52116002)(186003)(86362001)(53546011)(36756003)(66946007)(16526019)(66556008)(66476007)(4326008)(31696002)(478600001)(2616005)(31686004)(110136005)(54906003)(8676002)(8936002)(5660300002)(316002)(2906002)(83380400001)(6486002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: OtWM/lTHXobjfcHqFC+jaf3VFuk1Vkz5+ylZOy+BkLEjUT2vMIx6y/fHZ9IN9XjAl3bwksaX9QslVk8DhL2jLPdS2vGLKXpSib02uFNYxK+/oNFWh2PSoH4+aehLSSk0eYqv1VWHv3xMDAVi3YOdRuRA6O613CaG2TXAhhbknRZV75orfjsxhrBDA6Nir8SLdo6KErClAU3MohfYij0p0G2cia2aRereKWnadEJcJOpgg9Fj3QkMYoXu1CSQFsafKcs21R/FR+TMP8PohD7QKbUNNMBnAV1QE4/CAtRLH6dfaxfQmsryab7tbWHJ02zG8t0D6uTPil1QaJEYKTlExOSB3VYDhA9soRaSoHmT9gw77HnQ8l5d4vNa/Jwiwbqj14ffqQ5XT5wJIjaATgqwIRj7vNbXZO3qtD2Y2Dg5kuhK8WQ2JjRxjGFaN8/HWNepsdTIeOQCuHSz5SQpWW/oxPI7/2QYHRmB6qUc4u1M269bkK/IJC7JNQ6gY89oEfgXkIhKQlbynt39FSW+D3//iI/Tnec1RtF9LtK6z7nyhEFq7/kLAGK1Ahz1x86JW8zeJriP+aSkYDlEPFODIf57MNFOuX/t3zqMo80mKpml99rqM2RSPg/Np0XAvZkH/3TYSFQGq+nn0HHxHpIj+DPRXLPMU16wl9/GkHodQLUo/WA=
X-MS-Exchange-CrossTenant-Network-Message-Id: ac9167cf-11f8-4627-ad30-08d83ccba598
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2020 01:21:02.9787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q8Yyq44tjRJtW2sN813294+EKzVCrPE/FwyADHvPh2EwMIdZLRGyazWEvMWsUaB3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3620
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-09_12:2020-08-06,2020-08-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 priorityscore=1501 impostorscore=0 spamscore=0 clxscore=1015 phishscore=0
 bulkscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008100007
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/7/20 10:30 AM, Jiri Olsa wrote:
> hi,
> we have a customer facing some odd verifier fails on following
> sk_skb program:
> 
>     0. r2 = *(u32 *)(r1 + data_end)
>     1. r4 = *(u32 *)(r1 + data)
>     2. r3 = r4
>     3. r3 += 42
>     4. r1 = 0
>     5. if r3 > r2 goto 8
>     6. r4 += 14
>     7. r1 = r4
>     8. if r3 > r2 goto 10
>     9. r2 = *(u8 *)(r1 + 9)
>    10. r0 = 0
>    11. exit
> 
> The code checks if the skb data is big enough (5) and if it is,
> it prepares pointer in r1 (7), then there's again size check (8)
> and finally data load from r1 (9).
> 
> It's and odd code, but apparently this is something that can
> get produced by clang.

Could you provide a test case where clang generates the above code?
I would like to see whether clang can do a better job to avoid
such codes.

> 
> I made selftest out of it and it fails to load with:
> 
>    # test_verifier -v 267
>    #267/p dead path check FAIL
>    Failed to load prog 'Success'!
>    0: (61) r2 = *(u32 *)(r1 +80)
>    1: (61) r4 = *(u32 *)(r1 +76)
>    2: (bf) r3 = r4
>    3: (07) r3 += 42
>    4: (b7) r1 = 0
>    5: (2d) if r3 > r2 goto pc+2
> 
>    from 5 to 8: R1_w=inv0 R2_w=pkt_end(id=0,off=0,imm=0) R3_w=pkt(id=0,off=42,r=0,imm=0) R4_w=pkt(id=0,off=0,r=0,imm=0) R10=fp0
>    8: (2d) if r3 > r2 goto pc+1
>     R1_w=inv0 R2_w=pkt_end(id=0,off=0,imm=0) R3_w=pkt(id=0,off=42,r=42,imm=0) R4_w=pkt(id=0,off=0,r=42,imm=0) R10=fp0
>    9: (69) r2 = *(u16 *)(r1 +9)
>    R1 invalid mem access 'inv'
>    processed 15 insns (limit 1000000) max_states_per_insn 0 total_states 1 peak_states 1 mark_read 0
> 
> The verifier does not seem to take into account that code can't
> ever reach instruction 9 if the size check fails and r1 will be
> always valid when size check succeeds.
> 
> My guess is that verifier does not have such check, but I'm still
> scratching on the surface of it, so I could be totally wrong and
> missing something.. before I dive in I was wondering you guys
> could help me out with some insights or suggestions.

There are no bits in reg_state to indicate a pkt pointer already goes 
beyond the packet_end. So insn 8 cannot conclude the condition r3 > r2 
is always true...

If a bit to indicate packet pointer exceeding the end, it should work.
Fixing in verifier probably not too hard. But this should be a corner 
case and it will be good to check whether we can avoid it in clang.

> 
> thanks,
> jirka
> 
> 
> ---
>   .../testing/selftests/bpf/verifier/ctx_skb.c  | 21 +++++++++++++++++++
>   1 file changed, 21 insertions(+)
> 
> diff --git a/tools/testing/selftests/bpf/verifier/ctx_skb.c b/tools/testing/selftests/bpf/verifier/ctx_skb.c
> index 2e16b8e268f2..54578f1fb662 100644
> --- a/tools/testing/selftests/bpf/verifier/ctx_skb.c
> +++ b/tools/testing/selftests/bpf/verifier/ctx_skb.c
> @@ -346,6 +346,27 @@
>   	.result = ACCEPT,
>   	.prog_type = BPF_PROG_TYPE_SK_SKB,
>   },
> +{
> +	"dead path check",
> +	.insns = {
> +	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,		//  0. r2 = *(u32 *)(r1 + data_end)
> +		    offsetof(struct __sk_buff, data_end)),
> +	BPF_LDX_MEM(BPF_W, BPF_REG_4, BPF_REG_1,		//  1. r4 = *(u32 *)(r1 + data)
> +		    offsetof(struct __sk_buff, data)),
> +	BPF_MOV64_REG(BPF_REG_3, BPF_REG_4),			//  2. r3 = r4
> +	BPF_ALU64_IMM(BPF_ADD, BPF_REG_3, 42),			//  3. r3 += 42
> +	BPF_MOV64_IMM(BPF_REG_1, 0),				//  4. r1 = 0
> +	BPF_JMP_REG(BPF_JGT, BPF_REG_3, BPF_REG_2, 2),		//  5. if r3 > r2 goto 8
> +	BPF_ALU64_IMM(BPF_ADD, BPF_REG_4, 14),			//  6. r4 += 14
> +	BPF_MOV64_REG(BPF_REG_1, BPF_REG_4),			//  7. r1 = r4
> +	BPF_JMP_REG(BPF_JGT, BPF_REG_3, BPF_REG_2, 1),		//  8. if r3 > r2 goto 10
> +	BPF_LDX_MEM(BPF_H, BPF_REG_2, BPF_REG_1, 9),		//  9. r2 = *(u8 *)(r1 + 9)
> +	BPF_MOV64_IMM(BPF_REG_0, 0),				// 10. r0 = 0
> +	BPF_EXIT_INSN(),					// 11. exit
> +	},
> +	.result = ACCEPT,
> +	.prog_type = BPF_PROG_TYPE_SK_SKB,
> +},
>   {
>   	"overlapping checks for direct packet access SK_SKB",
>   	.insns = {
> 
