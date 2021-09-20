Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD8FE4115CD
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 15:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239629AbhITNar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 09:30:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37122 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237112AbhITNai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 09:30:38 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KDD1mC022010;
        Mon, 20 Sep 2021 09:28:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=xgT5YD3UxBnXVsri9sxzcL9itRY6pX+a3Msv567DtkM=;
 b=SMD7ir+JALlj8+aC7tSkZPH3Wj2jvIYaSZJ73Pg5vToZMbDgUxKUaGD2PRbDJTHy11Gs
 fO2e9aDC1+KB0xQN8ld3V2QD3/Pj1GN+ipYzvUTSfeMcLltOYwasFe46bS3bXd4fuEo5
 JLRr4wGR3uIpOU5AYL+JIYvt8OFNH91ZXjWKl4Yq3PMvM+3xatY46TlI0vLnW/6OqBn5
 ypXZJBqH2XSnv6vaPQeq+4R+Yz55Td6MrfpbJC2M0BDazQvtvm2qmePXm6EtXhN/+2Ui
 +zoHVNv8Dc/GnvKS73Mkj3ZZ6omJJD3pAQcOAw0PF7jNouhtb+TN+9t7BaaLXD7pPpcy xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b6rfrkn5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 09:28:40 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18KDD5Dm022569;
        Mon, 20 Sep 2021 09:28:39 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b6rfrkn4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 09:28:39 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18KDD6Ij012146;
        Mon, 20 Sep 2021 13:28:37 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3b57r8gwfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 13:28:37 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18KDSYMh29884746
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 13:28:34 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 98FE9A406D;
        Mon, 20 Sep 2021 13:28:34 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 942F5A404D;
        Mon, 20 Sep 2021 13:28:29 +0000 (GMT)
Received: from [9.43.114.206] (unknown [9.43.114.206])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 20 Sep 2021 13:28:29 +0000 (GMT)
Message-ID: <4710b971-12f0-e6cc-545a-9c7ee96d6057@linux.ibm.com>
Date:   Mon, 20 Sep 2021 18:58:28 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 3/8] bpf powerpc: refactor JIT compiler code
Content-Language: en-US
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        naveen.n.rao@linux.ibm.com, mpe@ellerman.id.au, ast@kernel.org,
        daniel@iogearbox.net
Cc:     paulus@samba.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
References: <20210917153047.177141-1-hbathini@linux.ibm.com>
 <20210917153047.177141-4-hbathini@linux.ibm.com>
 <b73d67d5-3ec3-c618-7f4c-ffdd71650e7e@csgroup.eu>
From:   Hari Bathini <hbathini@linux.ibm.com>
In-Reply-To: <b73d67d5-3ec3-c618-7f4c-ffdd71650e7e@csgroup.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Xh5bJFO4xu8Jz_AF2mhhttQ4q-7NC0PV
X-Proofpoint-ORIG-GUID: _19XF3e6ajpK5myoVRHFjw2ul01moovs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-20_07,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 spamscore=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 mlxscore=0 adultscore=0 clxscore=1015 bulkscore=0
 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109030001 definitions=main-2109200084
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christophe,

Thanks for reviewing the series.

On 17/09/21 9:40 pm, Christophe Leroy wrote:
> 
> 
> Le 17/09/2021 à 17:30, Hari Bathini a écrit :
>> Refactor powerpc JITing. This simplifies adding BPF_PROBE_MEM support.
> 
> Could you describe a bit more what you are refactoring exactly ?

I am trying to do more than BPF_PROBE_MEM needs. Will keep the changes 
minimal (BPF_PROBE_MEM specific) and update the changelog..

> 
> 
>>
>> Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
>> ---
>>
>> Changes in v2:
>> * New patch to refactor a bit of JITing code.
>>
>>
>>   arch/powerpc/net/bpf_jit_comp32.c | 50 +++++++++++---------
>>   arch/powerpc/net/bpf_jit_comp64.c | 76 ++++++++++++++++---------------
>>   2 files changed, 68 insertions(+), 58 deletions(-)
>>
>> diff --git a/arch/powerpc/net/bpf_jit_comp32.c 
>> b/arch/powerpc/net/bpf_jit_comp32.c
>> index b60b59426a24..c8ae14c316e3 100644
>> --- a/arch/powerpc/net/bpf_jit_comp32.c
>> +++ b/arch/powerpc/net/bpf_jit_comp32.c
>> @@ -276,17 +276,17 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 
>> *image, struct codegen_context *
>>       u32 exit_addr = addrs[flen];
>>       for (i = 0; i < flen; i++) {
>> -        u32 code = insn[i].code;
>>           u32 dst_reg = bpf_to_ppc(ctx, insn[i].dst_reg);
>> -        u32 dst_reg_h = dst_reg - 1;
>>           u32 src_reg = bpf_to_ppc(ctx, insn[i].src_reg);
>> -        u32 src_reg_h = src_reg - 1;
>>           u32 tmp_reg = bpf_to_ppc(ctx, TMP_REG);
>> +        u32 true_cond, code = insn[i].code;
>> +        u32 dst_reg_h = dst_reg - 1;
>> +        u32 src_reg_h = src_reg - 1;
> 
> All changes above seems unneeded and not linked to the current patch. 
> Please leave cosmetic changes outside and focus on necessary changes.
> 
>> +        u32 size = BPF_SIZE(code);
>>           s16 off = insn[i].off;
>>           s32 imm = insn[i].imm;
>>           bool func_addr_fixed;
>>           u64 func_addr;
>> -        u32 true_cond;
>>           /*
>>            * addrs[] maps a BPF bytecode address into a real offset from
>> @@ -809,25 +809,33 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 
>> *image, struct codegen_context *
>>           /*
>>            * BPF_LDX
>>            */
>> -        case BPF_LDX | BPF_MEM | BPF_B: /* dst = *(u8 *)(ul) (src + 
>> off) */
>> -            EMIT(PPC_RAW_LBZ(dst_reg, src_reg, off));
>> -            if (!fp->aux->verifier_zext)
>> -                EMIT(PPC_RAW_LI(dst_reg_h, 0));
>> -            break;
>> -        case BPF_LDX | BPF_MEM | BPF_H: /* dst = *(u16 *)(ul) (src + 
>> off) */
>> -            EMIT(PPC_RAW_LHZ(dst_reg, src_reg, off));
>> -            if (!fp->aux->verifier_zext)
>> -                EMIT(PPC_RAW_LI(dst_reg_h, 0));
>> -            break;
>> -        case BPF_LDX | BPF_MEM | BPF_W: /* dst = *(u32 *)(ul) (src + 
>> off) */
>> -            EMIT(PPC_RAW_LWZ(dst_reg, src_reg, off));
>> -            if (!fp->aux->verifier_zext)
>> +        /* dst = *(u8 *)(ul) (src + off) */
>> +        case BPF_LDX | BPF_MEM | BPF_B:
>> +        /* dst = *(u16 *)(ul) (src + off) */
>> +        case BPF_LDX | BPF_MEM | BPF_H:
>> +        /* dst = *(u32 *)(ul) (src + off) */
>> +        case BPF_LDX | BPF_MEM | BPF_W:
>> +        /* dst = *(u64 *)(ul) (src + off) */
>> +        case BPF_LDX | BPF_MEM | BPF_DW:
> Why changing the location of the comments ? I found it more readable 
> before.

Sure. I will revert that change.

>> +            switch (size) {
>> +            case BPF_B:
>> +                EMIT(PPC_RAW_LBZ(dst_reg, src_reg, off));
>> +                break;
>> +            case BPF_H:
>> +                EMIT(PPC_RAW_LHZ(dst_reg, src_reg, off));
>> +                break;
>> +            case BPF_W:
>> +                EMIT(PPC_RAW_LWZ(dst_reg, src_reg, off));
>> +                break;
>> +            case BPF_DW:
>> +                EMIT(PPC_RAW_LWZ(dst_reg_h, src_reg, off));
>> +                EMIT(PPC_RAW_LWZ(dst_reg, src_reg, off + 4));
>> +                break;
>> +            }
> 
> BPF_B, BPF_H, ... are not part of an enum. Are you sure GCC is happy to 
> have no default ?

I used gcc 10.3 for ppc32 & gcc 8.3 for ppc64. No warnings.
Though, no harm adding the below, I guess..

	default:
		break;

Thanks
Hari
