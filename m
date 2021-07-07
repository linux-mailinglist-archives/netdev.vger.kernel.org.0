Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 040263BE1C2
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 06:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhGGEFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 00:05:21 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36938 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230019AbhGGEFU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 00:05:20 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1673X4c0006648;
        Wed, 7 Jul 2021 00:01:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=xjxOpIlH+Q14vnMN7w6aDuOBwcyqN4ZHj9orX9lVsMI=;
 b=OQPzU/L4nPIeBVKm3qJkDXeTlZ/Hspj4rPfV+8ETQQK1YTm5gy66InNjxcHaZJYwA3II
 qmxOGLNS6bLK/qWREx8TNpSrYB3qYLWKKacmfVs/cNiYWSsF69ndxKaxNaOENH2ZcUSd
 Vv5xFWgw8pPzI6gBbxpSyVXTfpPz4Pg6ahj/cqD28OqMh7eNWLBtPpensES1gsD3gnAY
 ISEulBuxskoukxf5txZfE0uBXSRObTcLIkrd2ULLjXCbKwiaHaAFFu5wW4BVIgt7/SBv
 X1hep/I/LNkmhlp/xsS3h/7FkCiL41bD2xzU74OFpRV37Y6iecuf2kPFNe0Fa77YBsDw kQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mk5240k7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 00:01:39 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1673XQML007256;
        Wed, 7 Jul 2021 00:01:39 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mk5240jg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 00:01:38 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1674094U003176;
        Wed, 7 Jul 2021 04:01:36 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 39jfh8gtcn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 04:01:36 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16741XUv31654272
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Jul 2021 04:01:33 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E6A3BAE04D;
        Wed,  7 Jul 2021 04:01:32 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7657DAE051;
        Wed,  7 Jul 2021 04:01:25 +0000 (GMT)
Received: from [9.199.33.242] (unknown [9.199.33.242])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  7 Jul 2021 04:01:25 +0000 (GMT)
Subject: Re: [PATCH 3/4] bpf powerpc: Add BPF_PROBE_MEM support for 64bit JIT
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     naveen.n.rao@linux.ibm.com, mpe@ellerman.id.au, ast@kernel.org,
        daniel@iogearbox.net, songliubraving@fb.com,
        netdev@vger.kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kpsingh@kernel.org, paulus@samba.org,
        sandipan@linux.ibm.com, yhs@fb.com, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kafai@fb.com,
        linux-kernel@vger.kernel.org,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>
References: <20210706073211.349889-1-ravi.bangoria@linux.ibm.com>
 <20210706073211.349889-4-ravi.bangoria@linux.ibm.com>
 <2bfcb782-3133-2db2-31a7-6886156d2048@csgroup.eu>
From:   Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Message-ID: <5abce0d5-000e-9321-2f25-a6c6710fa70d@linux.ibm.com>
Date:   Wed, 7 Jul 2021 09:31:23 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <2bfcb782-3133-2db2-31a7-6886156d2048@csgroup.eu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _deMQT6zaqXhQNFye4lFLIcFp9pamSB6
X-Proofpoint-GUID: bgCW1AGfG_iQPaGtb1tRhzd5EkLdkajz
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-07_01:2021-07-06,2021-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 priorityscore=1501
 clxscore=1011 phishscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107070017
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/6/21 3:23 PM, Christophe Leroy wrote:
> 
> 
> Le 06/07/2021 à 09:32, Ravi Bangoria a écrit :
>> BPF load instruction with BPF_PROBE_MEM mode can cause a fault
>> inside kernel. Append exception table for such instructions
>> within BPF program.
> 
> Can you do the same for 32bit ?

Sure. But before that, do you think the approach is fine(including
patch #4)? Because it's little bit different from what other archs do.

[...]
>> @@ -89,6 +89,8 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
>>   {
>>       u32 proglen;
>>       u32 alloclen;
>> +    u32 extable_len = 0;
>> +    u32 fixup_len = 0;
> 
> Setting those to 0 doesn't seem to be needed, as it doesn't seem to exist any path to skip the setting below. You should not perform unnecessary init at declaration as it is error prone.

Ok.

[...]
>> @@ -234,7 +247,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
>>       fp->bpf_func = (void *)image;
>>       fp->jited = 1;
>> -    fp->jited_len = alloclen;
>> +    fp->jited_len = proglen + FUNCTION_DESCR_SIZE;
>>       bpf_flush_icache(bpf_hdr, (u8 *)bpf_hdr + (bpf_hdr->pages * PAGE_SIZE));
>>       if (!fp->is_func || extra_pass) {
> 
> This hunk does not apply on latest powerpc tree. You are missing commit 62e3d4210ac9c

Ok. I prepared this on a bpf/master. Will rebase it to powerpc/next.

[...]
>> +static int add_extable_entry(struct bpf_prog *fp, u32 *image, int pass,
>> +                 u32 code, struct codegen_context *ctx, int dst_reg)
>> +{
>> +    off_t offset;
>> +    unsigned long pc;
>> +    struct exception_table_entry *ex;
>> +    u32 *fixup;
>> +
>> +    /* Populate extable entries only in the last pass */
>> +    if (pass != 2 || BPF_MODE(code) != BPF_PROBE_MEM)
> 
> 'code' is only used for that test, can you do the test before calling add_extable_entry() ?

Ok.

> 
>> +        return 0;
>> +
>> +    if (!fp->aux->extable ||
>> +        WARN_ON_ONCE(ctx->exentry_idx >= fp->aux->num_exentries))
>> +        return -EINVAL;
>> +
>> +    pc = (unsigned long)&image[ctx->idx - 1];
> 
> You should call this function before incrementing ctx->idx

Ok.

> 
>> +
>> +    fixup = (void *)fp->aux->extable -
>> +        (fp->aux->num_exentries * BPF_FIXUP_LEN) +
>> +        (ctx->exentry_idx * BPF_FIXUP_LEN);
>> +
>> +    fixup[0] = PPC_RAW_XOR(dst_reg, dst_reg, dst_reg);
> 
> Prefered way to clear a reg in according to ISA is to do 'li reg, 0'

Sure I'll use 'li reg, 0' But can you point me to where in ISA this
is mentioned?

> 
>> +    fixup[1] = (PPC_INST_BRANCH |
>> +           (((long)(pc + 4) - (long)&fixup[1]) & 0x03fffffc));
> 
> Would be nice if we could have a PPC_RAW_BRANCH() stuff, we could do something like PPC_RAW_BRANCH((long)(pc + 4) - (long)&fixup[1])

Ok.

[...]
>> @@ -710,25 +752,41 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
>>            */
>>           /* dst = *(u8 *)(ul) (src + off) */
>>           case BPF_LDX | BPF_MEM | BPF_B:
>> +        case BPF_LDX | BPF_PROBE_MEM | BPF_B:
> 
> Could do:
> +        case BPF_LDX | BPF_PROBE_MEM | BPF_B:
> +            ret = add_extable_entry(fp, image, pass, code, ctx, dst_reg);
> +            if (ret)
> +                return ret;
>            case BPF_LDX | BPF_MEM | BPF_B:

Yes this is neat.

Thanks for the review.
Ravi
