Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C374549F02
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 22:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238489AbiFMU1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 16:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346878AbiFMU1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 16:27:05 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F4B58E65;
        Mon, 13 Jun 2022 12:12:34 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25DIw8V4014027;
        Mon, 13 Jun 2022 19:12:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=uA4zG66fam6l4B6mjBlT//nlFFTGecFnw5lB0H2lkxY=;
 b=S4JE/G6qo6MJz+zLRpa6hwq+nqVFVxsB6t64WSGMgd7tSadZEuVgP3pNri+nUHUtkdGP
 CvRo8wf99ckSdfrkU6VLuMWj2UPjBubFnDOGh6yIeqwpxboJVk+WHwbJOOR/dLbm64Ky
 B5T31yoUKm6L/s0D4Slx5BbYFr2qvA6Zpsy/oKCckIHaddRRisjwcxkaMnPOmK/w98Wn
 bRRUMKUT0TI9KM8jairRBTJgUkgxw+bvlIdpddqXxKfAx4VDCNSCazThPJU1Fcg0mnc+
 JPCjJ8y6FJiOcg/yr0CGcA+ztItQRPwIA8pckpsNETr6xAxmK3BJa4CR+2JnUzOAS0ur cA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gpayy07td-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Jun 2022 19:12:02 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25DJ28bK000342;
        Mon, 13 Jun 2022 19:12:01 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gpayy07t0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Jun 2022 19:12:01 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25DJ5ZDT021962;
        Mon, 13 Jun 2022 19:11:59 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 3gmjahtgwc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Jun 2022 19:11:59 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25DJBuWJ15139090
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jun 2022 19:11:56 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A68FD4204B;
        Mon, 13 Jun 2022 19:11:56 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1CC794203F;
        Mon, 13 Jun 2022 19:11:50 +0000 (GMT)
Received: from [9.211.149.2] (unknown [9.211.149.2])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 13 Jun 2022 19:11:49 +0000 (GMT)
Message-ID: <3d5f05d1-448f-58a6-20b0-3e9f0b13df03@linux.ibm.com>
Date:   Tue, 14 Jun 2022 00:41:47 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v2 5/5] bpf ppc32: Add instructions for atomic_[cmp]xchg
Content-Language: en-US
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc:     Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Yonghong Song <yhs@fb.com>, KP Singh <kpsingh@kernel.org>,
        Jordan Niethe <jniethe5@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
References: <20220610155552.25892-1-hbathini@linux.ibm.com>
 <20220610155552.25892-6-hbathini@linux.ibm.com>
 <f09b59ee-c965-a140-4d03-723830cba66d@csgroup.eu>
From:   Hari Bathini <hbathini@linux.ibm.com>
In-Reply-To: <f09b59ee-c965-a140-4d03-723830cba66d@csgroup.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8YjALtviDIzEBvbLD7VRCDBcyA2sUEZL
X-Proofpoint-GUID: H_rgvvzClw6qofGNWuY5UUAh1VFmHJnR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-13_08,2022-06-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 adultscore=0 malwarescore=0
 suspectscore=0 phishscore=0 impostorscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206130080
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/06/22 11:04 pm, Christophe Leroy wrote:
> 
> 
> Le 10/06/2022 à 17:55, Hari Bathini a écrit :
>> This adds two atomic opcodes BPF_XCHG and BPF_CMPXCHG on ppc32, both
>> of which include the BPF_FETCH flag.  The kernel's atomic_cmpxchg
>> operation fundamentally has 3 operands, but we only have two register
>> fields. Therefore the operand we compare against (the kernel's API
>> calls it 'old') is hard-coded to be BPF_REG_R0. Also, kernel's
>> atomic_cmpxchg returns the previous value at dst_reg + off. JIT the
>> same for BPF too with return value put in BPF_REG_0.
>>
>>     BPF_REG_R0 = atomic_cmpxchg(dst_reg + off, BPF_REG_R0, src_reg);
>>
>> Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
>> ---
>>
>> Changes in v2:
>> * Moved variable declaration to avoid late declaration error on
>>     some compilers.
>> * Tried to make code readable and compact.
>>
>>
>>    arch/powerpc/net/bpf_jit_comp32.c | 25 ++++++++++++++++++++++---
>>    1 file changed, 22 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/powerpc/net/bpf_jit_comp32.c b/arch/powerpc/net/bpf_jit_comp32.c
>> index 28dc6a1a8f2f..43f1c76d48ce 100644
>> --- a/arch/powerpc/net/bpf_jit_comp32.c
>> +++ b/arch/powerpc/net/bpf_jit_comp32.c
>> @@ -297,6 +297,7 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
>>    		u32 ax_reg = bpf_to_ppc(BPF_REG_AX);
>>    		u32 tmp_reg = bpf_to_ppc(TMP_REG);
>>    		u32 size = BPF_SIZE(code);
>> +		u32 save_reg, ret_reg;
>>    		s16 off = insn[i].off;
>>    		s32 imm = insn[i].imm;
>>    		bool func_addr_fixed;
>> @@ -799,6 +800,9 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
>>    		 * BPF_STX ATOMIC (atomic ops)
>>    		 */
>>    		case BPF_STX | BPF_ATOMIC | BPF_W:
>> +			save_reg = _R0;
>> +			ret_reg = src_reg;
>> +
>>    			bpf_set_seen_register(ctx, tmp_reg);
>>    			bpf_set_seen_register(ctx, ax_reg);
>>    
>> @@ -829,6 +833,21 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
>>    			case BPF_XOR | BPF_FETCH:
>>    				EMIT(PPC_RAW_XOR(_R0, _R0, src_reg));
>>    				break;
>> +			case BPF_CMPXCHG:
>> +				/*
>> +				 * Return old value in BPF_REG_0 for BPF_CMPXCHG &
>> +				 * in src_reg for other cases.
>> +				 */
>> +				ret_reg = bpf_to_ppc(BPF_REG_0);
>> +
>> +				/* Compare with old value in BPF_REG_0 */
>> +				EMIT(PPC_RAW_CMPW(bpf_to_ppc(BPF_REG_0), _R0));
>> +				/* Don't set if different from old value */
>> +				PPC_BCC_SHORT(COND_NE, (ctx->idx + 3) * 4);
>> +				fallthrough;
>> +			case BPF_XCHG:
>> +				save_reg = src_reg;
> 
> I'm a bit lost, when save_reg is src_reg, don't we expect the upper part
> (ie src_reg - 1) to be explicitely zeroised ?
> 

For BPF_FETCH variants, old value is returned in src_reg (ret_reg).
In all such cases, higher 32-bit is zero'ed. But in case of BPF_CMPXCHG,
src_reg is untouched as BPF_REG_0 is used instead. So, higher 32-bit
remains untouched for that case alone..


>> +				break;
>>    			default:
>>    				pr_err_ratelimited("eBPF filter atomic op code %02x (@%d) unsupported\n",
>>    						   code, i);
>> @@ -836,15 +855,15 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
>>    			}
>>    
>>    			/* store new value */
>> -			EMIT(PPC_RAW_STWCX(_R0, tmp_reg, dst_reg));
>> +			EMIT(PPC_RAW_STWCX(save_reg, tmp_reg, dst_reg));
>>    			/* we're done if this succeeded */
>>    			PPC_BCC_SHORT(COND_NE, tmp_idx);
>>    

>>    			/* For the BPF_FETCH variant, get old data into src_reg */

With this commit, this comment is not true for BPF_CMPXCHG. So, this
comment should not be removed..

Thanks
Hari
