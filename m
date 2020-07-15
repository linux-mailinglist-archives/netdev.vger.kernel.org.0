Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D779F22054F
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 08:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728385AbgGOGoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 02:44:19 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:10838 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725924AbgGOGoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 02:44:18 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06F6a8Q3001110;
        Tue, 14 Jul 2020 23:44:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=TSnq+ZiF2OxiN8eAv/r72JZyWcVnfOCiTkdqoSi3Iw4=;
 b=HaJQU3QyU5Zt7jWFiY5cnCUoyF/EXSAA01tvoYtrx5wnsud/uvLuhDEIuJ06Sv82zdOp
 iGO2ljyxJHQde1sfA7yjcZxLMYG4gOLqf0Zo6OhHkr4lPfDT3/kR8GIxldRejrosg0Tl
 qnpPchUxi7ELBJOCTaTcwI2VvtLQZMkPLlM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3288hm4mev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 14 Jul 2020 23:44:04 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 14 Jul 2020 23:44:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K7U6BHeq08y3Cjc5j9QChPUce1CX5OHxszAfVKtZvb73kq3EVJi6nierSQFeK3HZ7tJ+vnXgJXldnhvIYdiA3QnyvBGFNXceDu8RiH8H4D2QV9u9AG24P6dVsW+KNABEMlsTTCq7SSjPDaE2zN7MvNw7nDNnmtaNjcAsIb6aOhVdBZFod1l2D7GBVys3hcQYlhIYG91kG1K07NfEBkcksKL9crrsIyeV3V7Y8p6P/ptgERFZAA7DgeTdr7Ej1JdmGPS2h8sdvhUHWqeilXASO2KJxgqsnJLEx3mUXKick53cdlcgy/htEp3jVWsMXVVhMTAMVTNLxs9dMxBTMPSAtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TSnq+ZiF2OxiN8eAv/r72JZyWcVnfOCiTkdqoSi3Iw4=;
 b=YrbreWcgZA0iUDArn06oo3Kwzk1ctNRPMTcIDffb8DDTyfKGxcaP/obtpKe0WYd6YpKr8sI7fxQYbRXXZQPyAMmJPRDzF+pOjFdvoKSntdkQAxvFe79RCZTtZNBl1t88LELH8yFNdibsLra9cr5iwdJuvw7UytQYIyQCKqUtEA64woUTHLa68mOclTZj9GqqUaBk4MzQNp5T2CBBzdF4r/eCnbiUJ0vLpTvfZ49G1ap6tp1/i3NR1cdB6TtRHDafJzfOld3zcZv3C4oL4Is1FQxa1MssJq/JHQ4ab29YHzFs/cVkvi3yU6DppaYlewZGIvE8zV5eTX4x0XDQUZfrnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TSnq+ZiF2OxiN8eAv/r72JZyWcVnfOCiTkdqoSi3Iw4=;
 b=VdM+2RuF9py0vfIg1ZY4G7bYuFi23Hs8+PBRiOsKB2X6UoB5qBar1G1f69g3kg/FKoYFA8Ai/U06JLQoJeiAsk/9ZNQyOHFeqEzlJtRKdtgW0jdl4NV77aZAb3P/TsD52d2IlMkfuIIFNXVo9kKNeXwW39grjHd/n3QHXSHDRUY=
Authentication-Results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2197.namprd15.prod.outlook.com (2603:10b6:a02:8e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Wed, 15 Jul
 2020 06:44:02 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3174.025; Wed, 15 Jul 2020
 06:44:02 +0000
Subject: Re: [PATCH bpf] bpf: Shift and mask loads narrower than context field
 size
To:     Jakub Sitnicki <jakub@cloudflare.com>, <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
References: <20200710173123.427983-1-jakub@cloudflare.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <c98aaa5e-9347-c23f-cfa6-e267f2485c5b@fb.com>
Date:   Tue, 14 Jul 2020 23:44:01 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
In-Reply-To: <20200710173123.427983-1-jakub@cloudflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR04CA0005.namprd04.prod.outlook.com
 (2603:10b6:a03:217::10) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::11c9] (2620:10d:c090:400::5:48ba) by BY3PR04CA0005.namprd04.prod.outlook.com (2603:10b6:a03:217::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22 via Frontend Transport; Wed, 15 Jul 2020 06:44:02 +0000
X-Originating-IP: [2620:10d:c090:400::5:48ba]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 506fbae4-f678-423c-4b67-08d8288a75e3
X-MS-TrafficTypeDiagnostic: BYAPR15MB2197:
X-Microsoft-Antispam-PRVS: <BYAPR15MB21973DD45A6132A8226A34E5D37E0@BYAPR15MB2197.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5+O81qxmuNZEohcjq2z8fERGRnC004V7wGSZfA1IYpQSg88LNxBgo5siOawQbJKUOJueEyjvVGYlAdmxsl7yLmZtRiGzIQAQxkRaI7biBY5OU8A7ykRpvf1HyiHIodEdnAL0JI0jnoj0Ld5rAQlDkazoShhjAv9KNsEpqrKRaYDvUExXp8VcQbw1SatNEf3Q9xDgBtucu6zXesLTCapqMo6uxuJS3rtDftSf9AJs5mBf+aTGmqKuAbh1lx8Q5QSmi3RthQIou3SHEi6ur5EndtSUDnI6uEf9xsjbAPZCZqrok4hHC8KM7vWWvRG4vur7xu6S3fCLumKJrHD1sniufVEO78jT2mgQCMmyJXMc71iBaAVcEQHJW8X+hfz07r88
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(39860400002)(396003)(376002)(346002)(136003)(6486002)(66476007)(54906003)(478600001)(36756003)(316002)(31686004)(2906002)(83380400001)(66556008)(31696002)(4326008)(16526019)(8676002)(66946007)(86362001)(52116002)(8936002)(2616005)(53546011)(5660300002)(186003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: czjL9SlVX+ee5UQAEgBmvLK8hqT45mwnKI7uQxN/kqbBTM4blRmOdp/qqncTkMYbdJwg0XyxoOy56fUwIYAFdW/mVJ93YClz3w66Azu+gIxl/iLEQzEDgwsjiu/KtCKFugFQ5C5KOsgvfeeKgehd26ngohVEU9YthxkzfkkXFRpxXUKgHFEK2kz7IChJCLp5IiYob+aJmLQdWwWJogsCXaXl81UWER6jO4jHtiKISERT6bE0INFBCUNWM0HwYcyqxw5gdVIU12sAhZOUaXf2cOIW4+K3C8diwoNacMOh8LB2bXDbkxVeO8f1QzQAyYYqlRFqZqXC80MfjB0QkbgKI+37jJ4X4jwr9WUi9/4K0gBreT2e1T0T224FuLkB+IcPsvTi6RLCl7H179wyhhNbFB8Lb+WpBqeGupNBTo/EvPF/wW1Rt1OUW/IkMDUp8a8Oz1LtLjS6iP29wONOGdF27w3rFZT3M6vkSepUQ97rddDxXeYcqSQZSDT1twkSfMe5wfk2XSNeonnp+jI+MMliJA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 506fbae4-f678-423c-4b67-08d8288a75e3
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2020 06:44:02.2902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3/vZhVQ4ZlVjU2r69q2r0nqlYeHpvcBYPRe8Tqy2icsNFUo8a5YxL4Gudh+0KDlM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2197
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-15_05:2020-07-15,2020-07-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 impostorscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007150055
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/10/20 10:31 AM, Jakub Sitnicki wrote:
> When size of load from context is the same as target field size, but less
> than context field size, the verifier does not emit the shift and mask
> instructions for loads at non-zero offset.
> 
> This has the unexpected effect of loading the same data no matter what the
> offset was. While the expected behavior would be to load zeros for offsets
> that are greater than target field size.
> 
> For instance, u16 load from u32 context field backed by u16 target field at
> an offset of 2 bytes results in:
> 
>    SEC("sk_reuseport/narrow_half")
>    int reuseport_narrow_half(struct sk_reuseport_md *ctx)
>    {
>    	__u16 *half;
> 
>    	half = (__u16 *)&ctx->ip_protocol;
>    	if (half[0] == 0xaaaa)
>    		return SK_DROP;
>    	if (half[1] == 0xbbbb)
>    		return SK_DROP;
>    	return SK_PASS;
>    }

It would be good if you can include llvm asm output like below so people
can correlate source => asm => xlated codes:

        0:       w0 = 0
        1:       r2 = *(u16 *)(r1 + 24)
        2:       if w2 == 43690 goto +4 <LBB0_3>
        3:       r1 = *(u16 *)(r1 + 26)
        4:       w0 = 1
        5:       if w1 != 48059 goto +1 <LBB0_3>
        6:       w0 = 0

0000000000000038 <LBB0_3>:
        7:       exit

> 
>    int reuseport_narrow_half(struct sk_reuseport_md * ctx):
>    ; int reuseport_narrow_half(struct sk_reuseport_md *ctx)
>       0: (b4) w0 = 0
>    ; if (half[0] == 0xaaaa)
>       1: (79) r2 = *(u64 *)(r1 +8)
>       2: (69) r2 = *(u16 *)(r2 +924)
>    ; if (half[0] == 0xaaaa)
>       3: (16) if w2 == 0xaaaa goto pc+5
>    ; if (half[1] == 0xbbbb)
>       4: (79) r1 = *(u64 *)(r1 +8)
>       5: (69) r1 = *(u16 *)(r1 +924)
>       6: (b4) w0 = 1
>    ; if (half[1] == 0xbbbb)
>       7: (56) if w1 != 0xbbbb goto pc+1
>       8: (b4) w0 = 0
>    ; }
>       9: (95) exit

Indeed we have an issue here. The insn 5 is not correct.
The original assembly is correct.

Internally ip_protocol is backed by 2 bytes in sk_reuseport_kern.
The current verifier implementation makes an important assumption:
    all user load requests are within the size of kernel internal range
In this case, the verifier actually only correctly supports
    . one byte from offset 0
    . one byte from offset 1
    . two bytes from offset 0

The original assembly code tries to access 2 bytes from offset 2
and the verifier did incorrect transformation.

This actually makes sense since any other read is
misleading. For example, for ip_protocol, if people wants to
load 2 bytes from offset 2, what should we return? 0? In this case,
actually verifier can convert it to 0 with doing a load.


> In this case half[0] == half[1] == sk->sk_protocol that backs the
> ctx->ip_protocol field.
> 
> Fix it by shifting and masking any load from context that is narrower than
> context field size (is_narrower_load = size < ctx_field_size), in addition
> to loads that are narrower than target field size.

The fix can workaround the issue, but I think we should generate better 
codes for such cases.

> 
> The "size < target_size" check is left in place to cover the case when a
> context field is narrower than its target field, even if we might not have
> such case now. (It would have to be a u32 context field backed by a u64
> target field, with context fields all being 4-bytes or wider.)
> 
> Going back to the example, with the fix in place, the upper half load from
> ctx->ip_protocol yields zero:
> 
>    int reuseport_narrow_half(struct sk_reuseport_md * ctx):
>    ; int reuseport_narrow_half(struct sk_reuseport_md *ctx)
>       0: (b4) w0 = 0
>    ; if (half[0] == 0xaaaa)
>       1: (79) r2 = *(u64 *)(r1 +8)
>       2: (69) r2 = *(u16 *)(r2 +924)
>       3: (54) w2 &= 65535
>    ; if (half[0] == 0xaaaa)
>       4: (16) if w2 == 0xaaaa goto pc+7
>    ; if (half[1] == 0xbbbb)
>       5: (79) r1 = *(u64 *)(r1 +8)
>       6: (69) r1 = *(u16 *)(r1 +924)

The load is still from offset 0, 2 bytes with upper 48 bits as 0.

>       7: (74) w1 >>= 16

w1 will be 0 now. so this will work.

>       8: (54) w1 &= 65535

For the above insns 5-8, verifier, based on target information can
directly generate w1 = 0 since:
   . target kernel field size is 2, ctx field size is 4.
   . user tries to access offset 2 size 2.

Here, we need to decide whether we permits user to do partial read 
beyond of kernel narrow field or not (e.g., this example)? I would
say yes, but Daniel or Alexei can provide additional comments.

If we allow such accesses, I would like verifier to generate better
code as I illustrated in the above. This can be implemented in
verifier itself with target passing additional kernel field size
to the verifier. The target already passed the ctx field size back
to the verifier.

>       9: (b4) w0 = 1
>    ; if (half[1] == 0xbbbb)
>      10: (56) if w1 != 0xbbbb goto pc+1
>      11: (b4) w0 = 0
>    ; }
>      12: (95) exit
> 
> Fixes: f96da09473b5 ("bpf: simplify narrower ctx access")
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>   kernel/bpf/verifier.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 94cead5a43e5..1c4d0e24a5a2 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -9760,7 +9760,7 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
>   			return -EINVAL;
>   		}
>   
> -		if (is_narrower_load && size < target_size) {
> +		if (is_narrower_load || size < target_size) {
>   			u8 shift = bpf_ctx_narrow_access_offset(
>   				off, size, size_default) * 8;
>   			if (ctx_field_size <= 4) {
> 
