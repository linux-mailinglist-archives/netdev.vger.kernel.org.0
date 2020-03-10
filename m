Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84857180583
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 18:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgCJRwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 13:52:49 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:27058 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726290AbgCJRwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 13:52:49 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02AHmsPT009167;
        Tue, 10 Mar 2020 10:52:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=M41Hbbu24ekOfc8iDi8jYcId02P3PGp+MucuqX+COe0=;
 b=HG4Os1aXo95YI+0bwy/PicVmqou75uBKOplNwsf2zbnUcT0hNpYiDapJu4Bf6IvFpawh
 ZpIe8Jbe1c/yxR9TSxCwN++CDuvjB0weUPzxoW+eubLaureJnhDCFSiiMwUadUn0KYg+
 KerGJ3QgAG7dSf3G52gODLms2G6gVL2E92M= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yp25fktfj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 10 Mar 2020 10:52:35 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 10 Mar 2020 10:52:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jDkOVKBI/SR83kCk7unKCckiw8soFsAzov/O9uVbH+7Mi5bjiBV9bg0ra18PdzTInUERnmOeyi0ebNbzn5esNhtur8Rw+MWSaO9LMWQYozB3UwU7kVnqQQ7fzV8GPRPbxHmoNLzEaqwJsO3JSWza1oIGZeMyXupN7yY96T2Wn3jmtlairU5Ryf3jLEKnCKCaoZ/jenBPesyhrQvVCuObPMmCoB2ISvQLuav/59MP3YM5W+x/JQwj6AjsvengK1QZA6k8xRttIWENSTlGJUiW0SGA28tujHPgrGHL1+w6I10sHU0ZoJWucXW0pMex3U4TQBWd0uhWNuNO52y+TQ9Vlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M41Hbbu24ekOfc8iDi8jYcId02P3PGp+MucuqX+COe0=;
 b=O023CH4PxSROxPZ5gBxt9+VT9qMexkVKACVATVB5RSskl6qyv/B5n5rWVA2ULMsWymjgY+AOlA8gqzBbATHsODn0DA7ztcQPNoVIEQz1v/pupuXgFIiA+57SqdyWGjOUGsri6uKdnKh59kk6McMDQLxunWKIVeT0AG/8ErQGpme+WJsJ5Ouzxu/5LySwqxbNi8wK4sUTzXlcT6saeDeT5BVCUDQZaLCbHEYbd10/M7UFuOl5JfYWCdpYtboJ5mk/nDbyf+u4Mti2bjmcocWcGtZwz+yJtWdYiOse4mmoXJhUJzwr6Ng1LmpEQSgvI3fTiIXdca5BEfvPNtKe/UDadg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M41Hbbu24ekOfc8iDi8jYcId02P3PGp+MucuqX+COe0=;
 b=JzzbjyfiX+3EV0/lZN123aq+SgHdYRN4pBGG2D6YHlj9+wldVbdi/k0VhGR8OPQYBMbX9aPsA748W5H9ZH/T09ThWtkmmFDNv8A1fezniGzyhqYZlx60/V9prT06XXUNUDLCUx1u3SjsvDgYzikiiK9/SqnsPa7smUgyKK1a+MI=
Received: from DM6PR15MB3001.namprd15.prod.outlook.com (2603:10b6:5:13c::16)
 by DM6PR15MB2842.namprd15.prod.outlook.com (2603:10b6:5:136::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.14; Tue, 10 Mar
 2020 17:52:33 +0000
Received: from DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c]) by DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c%4]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 17:52:32 +0000
Subject: Re: [RFC PATCH 2/4] bpf: verifier, do explicit u32 bounds tracking
To:     John Fastabend <john.fastabend@gmail.com>,
        <alexei.starovoitov@gmail.com>, <daniel@iogearbox.net>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
References: <158353965971.3451.14666851223845760316.stgit@ubuntu3-kvm2>
 <158353986285.3451.6986018098665897886.stgit@ubuntu3-kvm2>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <e41f7369-1215-43fb-6418-5ff37310eeae@fb.com>
Date:   Tue, 10 Mar 2020 10:52:29 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
In-Reply-To: <158353986285.3451.6986018098665897886.stgit@ubuntu3-kvm2>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR14CA0018.namprd14.prod.outlook.com
 (2603:10b6:300:ae::28) To DM6PR15MB3001.namprd15.prod.outlook.com
 (2603:10b6:5:13c::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:cec9) by MWHPR14CA0018.namprd14.prod.outlook.com (2603:10b6:300:ae::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16 via Frontend Transport; Tue, 10 Mar 2020 17:52:31 +0000
X-Originating-IP: [2620:10d:c090:400::5:cec9]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb1daf51-71dc-4817-c5c2-08d7c51bcf21
X-MS-TrafficTypeDiagnostic: DM6PR15MB2842:
X-Microsoft-Antispam-PRVS: <DM6PR15MB28429C65077860443CC2FAD2D3FF0@DM6PR15MB2842.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(346002)(39860400002)(366004)(376002)(136003)(396003)(189003)(199004)(316002)(66946007)(66556008)(66476007)(31686004)(31696002)(16526019)(8936002)(186003)(2616005)(5660300002)(52116002)(2906002)(6506007)(6486002)(478600001)(53546011)(81156014)(36756003)(86362001)(81166006)(6512007)(4326008)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB2842;H:DM6PR15MB3001.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Aw4htd8Y4bzj5kx8LFPcTijQdHEpM/ReK3iW/Z2DA7hQGcZKxmO2/QPy6Obu2tCkNFtlPEjSodlgAxQk/G6blEvzTeWc2HMc1zmPSCsIUX+uNc9WTcDYKNrILXs1FrMipHvLLIAyyCnNG+RS9d4uhhBu09rD8pICMfR4eFjxFb3X1VMMhgt4nlTfk3CzSQ5x0PXVX4Wq9r8KYtGmBX8I7z34b+CFjQGzJtMCt67cwxhF+jT/UpPXTT5Qz8Kvd7sL1VCo7ACrBZQEBCQdcTeWLRrDDA69IC9o3y2ZwoHgg6om0k0VIJYmFucuwlpB0nJqBFGyCw/4LGTXsoSu1yRpqZxN++Rduv9bawN08n16WZ6LBO0sMDdmttvN3hZCs2X6SZdedqKWontW+tvSP+gpQ1isRQ8fUDai4EN4xdi8MxSdT88N4LWrX7BJTGu3RtIL
X-MS-Exchange-AntiSpam-MessageData: NqpiboVC4je/7PrhPON2mw+530HPDHFlY9026t7ncgXN2RKp7THe1+XYaoDL2YWq+ctD0k2/K+kCb9teehOsJeK3sTBV2N4F/DyIOqAIFvHgQ+noZHjzWmSO/wT2VGYmp9RbRqdLwg1KVNAtJPBt7f1XuFnq/cy8Pa2zqxxuN39q7mFEQszAwwRup/tOCyqX
X-MS-Exchange-CrossTenant-Network-Message-Id: fb1daf51-71dc-4817-c5c2-08d7c51bcf21
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 17:52:32.8119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jHNmMfrS7D8W2dY20tCPky7M3amSmUNkV6q37ekxdLlZrk4SqoiLAYjHbrWo5VDg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2842
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-10_12:2020-03-10,2020-03-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 phishscore=0 malwarescore=0 suspectscore=0 clxscore=1015 spamscore=0
 mlxscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003100108
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/6/20 4:11 PM, John Fastabend wrote:
> It is not possible for the current verifier to track u32 alu ops and jmps
> correctly. This can result in the verifier aborting with errors even though
> the program should be verifiable. Cilium code base has hit this but worked
> around it by changing int variables to u64 variables and marking a few
> things volatile. It would be better to avoid these tricks.
> 
> But, the main reason to address this now is do_refine_retval_range() was
> assuming return values could not be negative. Once we fix this in the
> next patches code that was previously working will no longer work.
> See do_refine_retval_range() patch for details.
> 
> The simplest example code snippet that illustrates the problem is likelyy
> this,
> 
>   53: w8 = w0                    // r8 <- [0, S32_MAX],
>                                  // w8 <- [-S32_MIN, X]
>   54: w8 <s 0                    // r8 <- [0, U32_MAX]
>                                  // w8 <- [0, X]
> 
> The expected 64-bit and 32-bit bounds after each line are shown on the
> right. The current issue is without the w* bounds we are forced to use
> the worst case bound of [0, U32_MAX]. To resolve this type of case,
> jmp32 creating divergent 32-bit bounds from 64-bit bounds, we add explicit
> 32-bit register bounds s32_{min|max}_value, u32_{min|max}_value, and
> var32_off. Then from branch_taken logic creating new bounds we can
> track 32-bit bounds explicitly.
> 
> The next case we observed is ALU ops after the jmp32,
> 
>   53: w8 = w0                    // r8 <- [0, S32_MAX],
>                                  // w8 <- [-S32_MIN, X]
>   54: w8 <s 0                    // r8 <- [0, U32_MAX]
>                                  // w8 <- [0, X]
>   55: w8 += 1                    // r8 <- [0, U32_MAX+1]
>                                  // w8 <- [0, X+1]
> 
> In order to keep the bounds accurate at this point we also need to track
> ALU32 ops. To do this we add explicit alu32 logic for each of the alu
> ops, mov, add, sub, etc.
> 
> Finally there is a question of how and when to merge bounds. The cases
> enumerate here,
> 
> 1. MOV ALU32   - zext 32-bit -> 64-bit
> 2. MOV ALU64   - copy 64-bit -> 32-bit
> 3. op  ALU32   - zext 32-bit -> 64-bit
> 4. op  ALU64   - n/a
> 5. jmp ALU32   - 64-bit: var32_off | var64_off
> 6. jmp ALU64   - 32-bit: (>> (<< var64_off))
> 
> Details for each case,
> 
> For "MOV ALU32" BPF arch zero extends so we simply copy the bounds
> from 32-bit into 64-bit ensuring we cast the var32_off. See zext_32_to_64.
> 
> For "MOV ALU64" copy all bounds including 32-bit into new register. If
> the src register had 32-bit bounds the dst register will as well.
> 
> For "op ALU32" zero extend 32-bit into 64-bit, see zext_32_to_64.
> 
> For "op ALU64" calculate both 32-bit and 64-bit bounds no merging
> is done here. Except we have a special case. When RSH or ARSH is
> done we can't simply ignore shifting bits from 64-bit reg into the
> 32-bit subreg. So currently just push bounds from 64-bit into 32-bit.
> This will be correct in the sense that they will represent a valid
> state of the register. However we could lose some accuracy if an
> ARSH is following a jmp32 operation. We can handle this special
> case in a follow up series.
> 
> For "jmp ALU32" mark 64-bit reg unknown and recalculate 64-bit bounds
> from tnum by setting var_off to ((<<(>>var_off)) | var32_off). We
> special case if 64-bit bounds has zero'd upper 32bits at which point
> wee can simply copy 32-bit bounds into 64-bit register. This catches
> a common compiler trick where upper 32-bits are zeroed and then
> 32-bit ops are used followed by a 64-bit compare or 64-bit op on
> a pointer. See __reg_combine_64_into_32().
> 
> For "jmp ALU64" cast the bounds of the 64bit to their 32-bit
> counterpart. For example s32_min_value = (s32)reg->smin_value. For
> tnum use only the lower 32bits via, (>>(<<var_off)). See
> __reg_combine_64_into_32().
> 
> Some questions and TBDs aka the RFC part,
> 
>   0) opinions on the approach?
> 
>   1) We currently tnum always has 64-bits even for the 32-bit tnum
>      tracking. I think ideally we convert the tnum var32_off to a
>      32-bit type so the types are correct both in the verifier and
>      from what it is tracking. But this in turn means we end up
>      with tnum32 ops. It seems to not be strictly needed though so
>      I'm saving it for a follow up series. Any thoughts?
> 
>      struct tnum {
>         u64 value;
>         u64 mask;
>      }
> 
>      struct tnum32 {
>         u32 value;
>         u32 mask;
>      }
> 
>   2) I guess this patch could be split into two and still be
>      workable. First patch to do alu32 logic and second to
>      do jmp32 logic. I slightly prefer the single big patch
>      to keep all the logic in one patch but it makes for a
>      large change. I'll tear it into two if folks care.
> 
>   3) This is passing test_verifier I need to run test_progs
>      all the way through still. My test box missed a few tests
>      due to kernel feature flags.
> 
>   4) I'm testing Cilium now as well to be sure we are still
>      working there.
> 
>   5) Do we like this approach? Should we push it all the way
>      through to stable? We need something for stable and I
>      haven't found a better solution yet. Its a good chunk
>      of code though if we do that we probably want the fuzzers
>      to run over it first.
> 
>   6) I need to do another review pass.
> 
>   7) I'm writing a set of verifier tests to exercise some of
>      the more subtle 32 vs 64-bit cases now.
> 
>   8) I have a small test patch I use with test_verifier to
>      dump the verifier state every line which I find helpful
>      I'll push it to bpf-next in case anyone else cares to
>      use it.

As reading the patch, a few minor comments below.

> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>   tools/testing/selftests/bpf/test_verifier.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
[...]
>   
> +/* BPF architecture zero extends alu32 ops into 64-bit registesr */
> +static void zext_32_to_64(struct bpf_reg_state *reg)
> +{
> +	reg->var_off = reg->var32_off = tnum_cast(reg->var32_off, 4);
> +	reg->umin_value = reg->smin_value = reg->u32_min_value;

reg->smin_value = reg->u32_min_value? Could you explain?

> +	reg->umax_value = reg->smax_value = reg->u32_max_value;
> +}
>   
>   /* truncate register to smaller size (in bytes)
>    * must be called with size < BPF_REG_SIZE
> @@ -2791,6 +2957,7 @@ static int check_tp_buffer_access(struct bpf_verifier_env *env,
>   static void coerce_reg_to_size(struct bpf_reg_state *reg, int size)
>   {
>   	u64 mask;
> +	u32 u32mask;
>   
>   	/* clear high bits in bit representation */
>   	reg->var_off = tnum_cast(reg->var_off, size);
> @@ -2804,8 +2971,36 @@ static void coerce_reg_to_size(struct bpf_reg_state *reg, int size)
>   		reg->umin_value = 0;
>   		reg->umax_value = mask;
>   	}
> +
> +	/* TBD this is its own patch */
> +	if (reg->smin_value < 0 || reg->smax_value > reg->umax_value)

When reg->smax_value > reg->umax_value could happen?

> +		reg->smax_value = reg->umax_value;
> +	else
> +		reg->umax_value = reg->smax_value;

Not quite understand the above logic.


>   	reg->smin_value = reg->umin_value;
> -	reg->smax_value = reg->umax_value;
> +
> +	/* If size is smaller than 32bit register the 32bit register
> +	 * values are also truncated.
> +	 */
> +	if (size >= 4) {
> +		reg->var32_off = tnum_cast(reg->var_off, 4);
> +		return;
> +	}
> +
> +	reg->var32_off = tnum_cast(reg->var_off, size);
> +	u32mask = ((u32)1 << (size *8)) - 1;

Looks like here u32mask trying to remove the 32bit sign and try to 
compare values. Not quite follow the logic below.

> +	if ((reg->u32_min_value & ~u32mask) == (reg->u32_max_value & ~u32mask)) {
> +		reg->u32_min_value &= mask;
> +		reg->u32_max_value &= mask;
> +	} else {
> +		reg->u32_min_value = 0;
> +		reg->u32_max_value = mask;
> +	}
> +	if (reg->s32_min_value < 0 || reg->s32_max_value > reg->u32_max_value)
> +		reg->s32_max_value = reg->u32_max_value;
> +	else
> +		reg->u32_max_value = reg->s32_max_value;
> +	reg->s32_min_value = reg->u32_min_value;
>   }
>   
>   static bool bpf_map_is_rdonly(const struct bpf_map *map)
> @@ -4427,7 +4622,17 @@ static bool signed_add_overflows(s64 a, s64 b)
>   	return res < a;
>   }
>   
[...]

