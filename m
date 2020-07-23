Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39CDA22B8FF
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 23:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbgGWV4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 17:56:22 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14414 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726368AbgGWV4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 17:56:22 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06NLjNPZ010487;
        Thu, 23 Jul 2020 14:56:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=S7GFy+F9Sgs0lnJXMtJl/Fzk/R1vp5tLFM2bTkLBEUc=;
 b=oWglcDYmn8adGDztVGNzh2UVDQTd9Ez49rVxarg++7H26iJbRAjSD9Izfsw0EPULwHxZ
 H6M7jonO+vYfTOzeJRQSubz/sGPXtUIFuQwd4yaejkTbfLuK3+30dvznvqrht7fgb9qs
 gZAWJCmdsQGvehGcEem3k0Bbw1V3GgAPrJk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32etg3ef3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 23 Jul 2020 14:56:05 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 23 Jul 2020 14:56:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bghQnieu8CQfvn65nK2a6UVgsS8DQvQWobPcKHcHFS90jzdDL7lXgCMh46YQF1XBR7kACZHUBH9d4168oGn5Y1/UOcnjw54FQ3eJf4CAH6Kh8YNwgcHMhmPYUg9upqGLTSmL1Y6ZO1xucI5NQCZJGE+UDj8eqaSH4TlXsOqptrPMW5Py/GvE7Zsn7IL7lm5IeIsC1i7YYg/pZwd0T0JEaFBp++0R92McpA2eendSDlYKfKytCtHCowmWz2ONwnUFhP8z6Hy2jLMgxLZAooUEwIeE5XxJPlkSrOUUgmddD5yszVuDqHp/QlaPjC9qdiu4Ioh07gU/5/SCvuzSaTGNGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S7GFy+F9Sgs0lnJXMtJl/Fzk/R1vp5tLFM2bTkLBEUc=;
 b=Q4xiHwVBx6jIQm7IwFxT6MjWrxHDbe/+O8N5fyuWKXcZjdph+687KytwxqrhDkZvgHPbOdS+h2dw5MGE18C/Ma0pza/DVoMe/VBa0XT6dGXVh4AO+NsQ0zO1x1OB0tK7KjF7ONVMdfuktdXSoZfvs+IeR/Y6j6hmtBRPoSMohg46o7HbibJDEzFt3lQy4AcboP77DOQSLgqiJR5pYvFhtYJhtqzikUmKeJQC5Wrjwr5fevPOfjCcdXeiugr9yXHz+j8mkb4yZWqpAHiVH2QPxwqziuO6N1DvbNbmpJnMOu4fgTYiwJATPuJ30uKUFfW0tl26SDAobJ4PBHyXCZ+YRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S7GFy+F9Sgs0lnJXMtJl/Fzk/R1vp5tLFM2bTkLBEUc=;
 b=enHK3bXN4CF0bPCh5SsfpfD3oOs5sLwpmPRumd3veVxIEOWNphMgdQPOUSwA4zohyOlPM8vyggtC9XXfeRVT1bbUfLEOFSKDJq50g1GLIgjdMtC/1Rd/KTJLZQW/6voSfHCKkBeqALC+MNl5G85CHFADCObp0s9/+H5dwdx6rjw=
Authentication-Results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2327.namprd15.prod.outlook.com (2603:10b6:a02:8e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17; Thu, 23 Jul
 2020 21:56:03 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3216.021; Thu, 23 Jul 2020
 21:56:03 +0000
Subject: Re: [PATCH bpf v2 1/2] bpf: Load zeros for narrow loads beyond target
 field
To:     Jakub Sitnicki <jakub@cloudflare.com>, <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
References: <20200723095953.1003302-1-jakub@cloudflare.com>
 <20200723095953.1003302-2-jakub@cloudflare.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <822d5ee4-e507-22fc-a27d-60b5f0f2c5f2@fb.com>
Date:   Thu, 23 Jul 2020 14:56:01 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
In-Reply-To: <20200723095953.1003302-2-jakub@cloudflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR16CA0030.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::43) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1888] (2620:10d:c090:400::5:e13e) by BY5PR16CA0030.namprd16.prod.outlook.com (2603:10b6:a03:1a0::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.22 via Frontend Transport; Thu, 23 Jul 2020 21:56:03 +0000
X-Originating-IP: [2620:10d:c090:400::5:e13e]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1def9b6-5192-48ce-7431-08d82f533199
X-MS-TrafficTypeDiagnostic: BYAPR15MB2327:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2327DCFACD575063A2523BB8D3760@BYAPR15MB2327.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E2ZowYk4y0elEjervh51xOc+KErGfnbn0IgyRtYQvJdTzom9pNlz9LwZDrCnwII4e9vyA2tudENBvUtmT4h9RCdW7zogPkd43kiObKc/4+PMN5sNDZjcpjLV306CRWU4bskMV1CAu9/40QtD38m2DgDPg9wjB1KPfpyi0kIe1NhTGT2g6hbwfgfXw0AnybUChEixcRflywtuSwHHTKcnRvE43QDrMd6v8FW9c+WaJ0+Llu1M5myMFGSTL0HhkcAoTik9Zg0hX0xpY7qjg1ZtOthM6QQyaP/AFsv6f328WwiZpJpxfFTvx6wPx64dek485WB4uhfsm5uWxlShBXC+FWmbfHBjOTh/Y0K5HHtwoUYjPzNl+Z2IOxhAn+VWbVOt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(346002)(136003)(376002)(366004)(39860400002)(54906003)(53546011)(83380400001)(2906002)(31686004)(5660300002)(36756003)(86362001)(2616005)(478600001)(8936002)(16526019)(52116002)(186003)(8676002)(6486002)(4326008)(31696002)(316002)(66476007)(66946007)(66556008)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: KbdHdgFsy+Yq49lLbpyZPmpOVeLZpfz8VjGN94c5N3SrpoIm9wMS4uws0fNB36ThHauor2FlH4VDHrwIBlWdXWbRY6LwwxvUgJzPMOu79zNQ8Y2h9lF96In3+jnxcGSTjd6qRqCIoHYd/bE+NdMGfQsFaIPGLWeG+WHaufXr669RqjmAv61TDYfMIY+UsQxG+3xTHbG84bltnGlwVBkBT7Y1OmRXRGKfyouEfyXWzmp6mLJJ7J/m2XaE+DE5CuQ7z8Y0cGgBoeQNA6gop/sZI+gqE5kagJpEzITEj4Qo4iPaMdMTXcsigsOkfPROOo9P93qiQgnMq8iBRGPXR2HkBKh+9R88jLH9zt9UzGmJRZ7Dzj3nuTXSuZmkiUybnEl/QetMAZidLn5gQ3cX/Hj+OmcdzqnIHTeFU5hmoJ2lHdMwnryd3+VTalzFGPSAqF3CJm18/MHn+FwPqZJof+FFnzsRfYxPsUIyD9QKeMi3Rnn4tJrz+rNQbIc7oLu4F/V9Nsd8iXbar6Mic7jlpnyLKg==
X-MS-Exchange-CrossTenant-Network-Message-Id: c1def9b6-5192-48ce-7431-08d82f533199
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2020 21:56:03.4606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F3/yJR/AyIyat0H6z6CodixGteUH3hzSCXMnyZzMDxqzsqMKzrCffnKkz7w+wnOa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2327
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-23_09:2020-07-23,2020-07-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 lowpriorityscore=0 impostorscore=0
 mlxscore=0 adultscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007230153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/23/20 2:59 AM, Jakub Sitnicki wrote:
> For narrow loads from context that are:
> 
>    1) as big in size as the target field, and
>    2) at an offset beyond the target field,
> 
> the verifier does not emit the shift-and-mask instruction sequence
> following the target field load instruction, as it happens for narrow loads
> smaller in size than the target field width.
> 
> This has an unexpected effect of loading the same data, no matter what the
> offset. While, arguably, the expected behavior is to load zeros for offsets
> that beyond the target field.
> 
> For instance, 2-byte load from a 4-byte context field, backed by a 2-byte
> target field at an offset of 2 bytes results in:
> 
>    $ cat progs/test_narrow_load.c
>    [...]
>    SEC("sk_reuseport/narrow_load_half_word")
>    int narrow_load_half_word(struct sk_reuseport_md *ctx)
>    {
>    	__u16 *half;
> 
>    	half = (__u16 *)&ctx->ip_protocol;
>    	if (half[0] != IPPROTO_UDP)
>    		return SK_DROP;
>    	if (half[1] != 0)
>    		return SK_DROP;
>    	return SK_PASS;
>    }
> 
>    $ llvm-objdump -S --no-show-raw-insn ...
>    [...]
>    0000000000000000 narrow_load_half_word:
>    ; {
>           0:       w0 = 0
>    ;       if (half[0] != IPPROTO_UDP)
>           1:       r2 = *(u16 *)(r1 + 24)
>           2:       if w2 != 17 goto +4 <LBB1_3>
>    ;       if (half[1] != 0)
>           3:       r1 = *(u16 *)(r1 + 26)
>           4:       w0 = 1
>           5:       if w1 == 0 goto +1 <LBB1_3>
>           6:       w0 = 0
> 
>    0000000000000038 LBB1_3:
>    ; }
>           7:       exit
> 
>    $ bpftool prog dump xlated ...
>    int narrow_load_half_word(struct sk_reuseport_md * ctx):
>    ; int narrow_load_half_word(struct sk_reuseport_md *ctx)
>       0: (b4) w0 = 0
>    ; if (half[0] != IPPROTO_UDP)
>       1: (79) r2 = *(u64 *)(r1 +8)
>       2: (69) r2 = *(u16 *)(r2 +924)
>    ; if (half[0] != IPPROTO_UDP)
>       3: (56) if w2 != 0x11 goto pc+5
>    ; if (half[1] != 0)
>       4: (79) r1 = *(u64 *)(r1 +8)
>       5: (69) r1 = *(u16 *)(r1 +924)
>       6: (b4) w0 = 1
>    ; if (half[1] != 0)
>       7: (16) if w1 == 0x0 goto pc+1
>       8: (b4) w0 = 0
>    ; }
>       9: (95) exit
> 
> In this case half[0] == half[1] == sk->sk_protocol, which is the target
> field for the ctx->ip_protocol.
> 
> Fix it by emitting 'wX = 0' or 'rX = 0' instruction for all narrow loads
> from an offset that is beyond the target field.
> 
> Going back to the example, with the fix in place, the upper half load from
> ctx->ip_protocol yields zero:
> 
>    int narrow_load_half_word(struct sk_reuseport_md * ctx):
>    ; int narrow_load_half_word(struct sk_reuseport_md *ctx)
>       0: (b4) w0 = 0
>    ; if (half[0] != IPPROTO_UDP)
>       1: (79) r2 = *(u64 *)(r1 +8)
>       2: (69) r2 = *(u16 *)(r2 +924)
>    ; if (half[0] != IPPROTO_UDP)
>       3: (56) if w2 != 0x11 goto pc+4
>    ; if (half[1] != 0)
>       4: (b4) w1 = 0
>       5: (b4) w0 = 1
>    ; if (half[1] != 0)
>       6: (16) if w1 == 0x0 goto pc+1
>       7: (b4) w0 = 0
>    ; }
>       8: (95) exit
> 
> Fixes: f96da09473b5 ("bpf: simplify narrower ctx access")
> Suggested-by: Yonghong Song <yhs@fb.com>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>

Thanks for the fix. The final code is much better now.
Ack with some nits below.

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   kernel/bpf/verifier.c | 23 +++++++++++++++++++++--
>   1 file changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 94cead5a43e5..0a9dbcdd6341 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -9614,11 +9614,11 @@ static int opt_subreg_zext_lo32_rnd_hi32(struct bpf_verifier_env *env,
>    */
>   static int convert_ctx_accesses(struct bpf_verifier_env *env)
>   {
> +	u32 target_size, size_default, off, access_off;
>   	const struct bpf_verifier_ops *ops = env->ops;
>   	int i, cnt, size, ctx_field_size, delta = 0;
>   	const int insn_cnt = env->prog->len;
>   	struct bpf_insn insn_buf[16], *insn;
> -	u32 target_size, size_default, off;
>   	struct bpf_prog *new_prog;
>   	enum bpf_access_type type;
>   	bool is_narrower_load;
> @@ -9760,7 +9760,26 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
>   			return -EINVAL;
>   		}
>   
> -		if (is_narrower_load && size < target_size) {
> +		/* When context field is wider than the target field,
> +		 * narrow load from an offset beyond the target field
> +		 * can be reduced to loading zero because there is
> +		 * nothing to load from memory.

Maybe it is worthwhile to mention that the below codegen undos
what convert_ctx_access() just did.

> +		 */
> +		access_off = off & (size_default - 1);
> +		if (is_narrower_load && access_off >= target_size) {
> +			cnt = 0;
> +			if (ctx_field_size <= 4)
> +				insn_buf[cnt++] = BPF_MOV32_IMM(insn->dst_reg, 0);
> +			else
> +				insn_buf[cnt++] = BPF_MOV64_IMM(insn->dst_reg, 0);
> +		}
> +		/* Narrow load from an offset within the target field,
> +		 * smaller in size than the target field, needs
> +		 * shifting and masking because convert_ctx_access
> +		 * always emits full-size target field load.
> +		 */
> +		if (is_narrower_load && access_off < target_size &&
> +		    size < target_size) {

The code becomes a little bit complex here. I think it is worthwhile
to have a static function to do codegen if is_narrower_load is true.

The above two if statements are exclusive. It would be good to
make it clear with "else if ...", and things will become easier
if the narrower codegen is factored to a separate function.

>   			u8 shift = bpf_ctx_narrow_access_offset(
>   				off, size, size_default) * 8;
>   			if (ctx_field_size <= 4) {
> 
