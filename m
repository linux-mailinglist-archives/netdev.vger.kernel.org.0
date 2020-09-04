Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5FC25E41C
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 01:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728261AbgIDXVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 19:21:04 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:15198 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728235AbgIDXVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 19:21:02 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 084NDeEn000609;
        Fri, 4 Sep 2020 16:20:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Q5fimtVWJXhFx1y139mWoC/uKRsf178Ksa1QVzSGORw=;
 b=g6RGs6pl7BANaITTA3B+ZrNgFvln+h57uzXZNQ3bEyLzesXj1RKMROVCP+OT/lx+Vxet
 FojxPjYQHkfRbx6rDogupu/QSAqGjBS3yyS0Cqyl7Dkv388WVEjl0hQQpgG1R50yDIDs
 5UdNiacTr0+qIOLf55BTdbIK5wP0nvA23aI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33am8emey9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 04 Sep 2020 16:20:48 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Sep 2020 16:20:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SohHZeCWPW9oIlsjatpmK+ujIK3Xg3IFNjxR3Y1bQRljZQN3d6b/LoGDA/sheQKkywJj1RGGVrdKfvnftiGJTVmL8EGo8DXBZaGUASyrb3lL/iFw0GihvdFzu4mPtXB0B5512hNWTE2cXm94N73UMZdVjKaBz180CEvu48r3BUO0FOIan3ydIrn/s2X5jOKTpSuSPZwXYfbEXB6V89oQw39XXoSVZgAm30vxh8HFyw+KJ3H4t3VcX+3/LIB5lfXCJw3oBMHUkC0ctGmBAtlHt/lUUuNX1wICR+N0RA4bbyzX0nX6/axAORsnZXS14SlQT3a9pefoRKa5+0/5JZ9KkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q5fimtVWJXhFx1y139mWoC/uKRsf178Ksa1QVzSGORw=;
 b=alz0F8/vaVDtDq/YqHpXGZfGgdMhBe+RrstsEDcNSmL6NwCbG3fMF9XH+5u6hrKTHX8+4VTe82SlYXqMG3k7lgcGd1JcO/rW1DfuZRJT1naq7cvbjc2tAnacq+ubPnS1XID1PKakKO7EbTx15Bz0CM9uTQtv0o9y8BWaoMR9V53UJbsSc4BmQn8jN6W71rLTjhUJbO/8eI2qK8Gw0S5PYXsvwg0CEdox/JPZ0zG55Pxde4QrwkmKMxI3ZHXKIkO4WV57bwwrDAqOGUkFZybJn+ks4TZjIzxR90t2P1NN2/zNG0+ywk7Q9/pp6TVDrJ/JHnlt/ZjxpygZaAGw5bVRUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q5fimtVWJXhFx1y139mWoC/uKRsf178Ksa1QVzSGORw=;
 b=PjJ6MpGlQ98vGDEBbJr9SyVjCmbaHiZT2xV4k0kTzcXpEe/g0R0L9/Foty2L2qoJyShN677BEesw5hbcjD/ullqEvCqIm8xxm9hjjpok/Us7doGfKCdcsuIch9hQn+OqsJ6yLrfTEgRyx44Ss0Qmp8st/U+HGoQFkpcNRoc0Ljs=
Received: from DM6PR15MB4090.namprd15.prod.outlook.com (2603:10b6:5:c2::18) by
 DM6PR15MB4007.namprd15.prod.outlook.com (2603:10b6:5:2bb::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.15; Fri, 4 Sep 2020 23:20:45 +0000
Received: from DM6PR15MB4090.namprd15.prod.outlook.com
 ([fe80::293b:8163:b8e5:29ef]) by DM6PR15MB4090.namprd15.prod.outlook.com
 ([fe80::293b:8163:b8e5:29ef%6]) with mapi id 15.20.3348.017; Fri, 4 Sep 2020
 23:20:45 +0000
Subject: Re: [PATCH bpf-next 1/2] bpf: permit map_ptr arithmetic with opcode
 add and offset 0
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200904194900.3031319-1-yhs@fb.com>
 <20200904194900.3031377-1-yhs@fb.com>
 <CAEf4BzboqpYa7Zq=6xcpGez+jk--NTDA0=FQi5utwcFaHwC7bA@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <c016695c-3d22-ac74-5e2f-9210fb5b58af@fb.com>
Date:   Fri, 4 Sep 2020 16:20:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
In-Reply-To: <CAEf4BzboqpYa7Zq=6xcpGez+jk--NTDA0=FQi5utwcFaHwC7bA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0034.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::47) To DM6PR15MB4090.namprd15.prod.outlook.com
 (2603:10b6:5:c2::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1126] (2620:10d:c090:400::5:8e75) by BYAPR06CA0034.namprd06.prod.outlook.com (2603:10b6:a03:d4::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15 via Frontend Transport; Fri, 4 Sep 2020 23:20:43 +0000
X-Originating-IP: [2620:10d:c090:400::5:8e75]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0e3ac9dc-2288-4a99-4a94-08d8512925e5
X-MS-TrafficTypeDiagnostic: DM6PR15MB4007:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB4007CFAE081845CE2F2B82F5D32D0@DM6PR15MB4007.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CBJXrXI/DG8mGBytwq1MqdYcXwvSrOkLDlW1OpJALJneMEr23S9IKbPtZm4SqSwI5s25ViuhoLEwSZnxfX+fGTQOzDuCdg0uGFAGydyLRuz2Qa1CM99gvZ1BujiIi2+n8f+eHF7Ot54RtF3+1hJ92yqDJD2HOZrSv/tnPMOWnqkNaIXjcmd4XzFsnHHdAepA+JC4d6/VXEm5h3WgvrbJYBGs5fziaDGpWY2KFwSVotBEoSI8Iw6oP65hk6NCb5uqX8us44jI6SnZWhQrkud6TVV0XxHdwDxgimS/010vc96t5VVmdhUPWm+YYPgJyonG9QF7BGqtS0JjEuFhc542O350iE1E1NjqRPwzbtUVYQGXLwo62ZQ8CC76DZwDbAE3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB4090.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(366004)(136003)(39860400002)(376002)(54906003)(8676002)(8936002)(2616005)(2906002)(31686004)(53546011)(52116002)(4326008)(6916009)(86362001)(5660300002)(31696002)(66476007)(66556008)(478600001)(66946007)(36756003)(6486002)(316002)(16526019)(83380400001)(186003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: S6p1VSr14KfnmTcu/0qfPEC+/uGW9DGB/pC2VTLQjihzTWecsrWiGQibhI54g3u8elxFmli8mped/C1z+gSgxWH3zcivnBaVYDWNPyZzHFWCAlDidDBcJL/uqKpHvXIf2fspRWjYOvFk2BlTQo/cLjMOLggl5tnKjkU8ASiNb+w/UoZRrAIes8lga96m0oKBlal1H4oZH+yrOAeq8ywFsGddiR/H0bvWfZ9EoQqUfCO8AGS3PJ+4iHLBfFEwRK+y/XIsPHxdtLoL4o3NZWQ/p45ziBzBc4FBVxIYYl0qyjgn+I520VLDrlg7aql+34VfEc3FiY9rCkXxZyKkVEVLkPM9qNqwFRBmLOAN/1edd7DZRG9viV+mZcBcmA8yu12OtPzAg+fnjQCh7grvnsqAMfFS+WXxO1TkAL5uHxLdsKCMBR42nmCpAl++hltcQCysA76NE6K3p/Ev1e2V7v87NKc5B2P+wvAoGUY9dPAVygjOak2kB2+02bNGdcIINJtUlrDHEKtyMkt+GAOCioAhe+xVoePvXtQkqoOstKsZHTAF3XHi/9yZjlSwI5R9P6osgN3w4GidnnFckC7vq+Llf1jBRec7/Dfeedyn16km7MmrycdiNIBl20s7wK7ZJVHVnGy9tkahEquTXvT+V/cGN92fFCkUaI857zXd5WhpVgg=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e3ac9dc-2288-4a99-4a94-08d8512925e5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB4090.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2020 23:20:44.9534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 17VCwUibcS3AOOdjRAUeA9HNFLjIemoDMiXpvarHXoQGUZ2ulQnrca+PCd3NABYn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB4007
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-04_15:2020-09-04,2020-09-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 impostorscore=0 malwarescore=0 mlxscore=0
 priorityscore=1501 spamscore=0 mlxlogscore=999 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009040196
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/4/20 1:30 PM, Andrii Nakryiko wrote:
> On Fri, Sep 4, 2020 at 12:49 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> Commit 41c48f3a98231 ("bpf: Support access
>> to bpf map fields") added support to access map fields
>> with CORE support. For example,
>>
>>              struct bpf_map {
>>                      __u32 max_entries;
>>              } __attribute__((preserve_access_index));
>>
>>              struct bpf_array {
>>                      struct bpf_map map;
>>                      __u32 elem_size;
>>              } __attribute__((preserve_access_index));
>>
>>              struct {
>>                      __uint(type, BPF_MAP_TYPE_ARRAY);
>>                      __uint(max_entries, 4);
>>                      __type(key, __u32);
>>                      __type(value, __u32);
>>              } m_array SEC(".maps");
>>
>>              SEC("cgroup_skb/egress")
>>              int cg_skb(void *ctx)
>>              {
>>                      struct bpf_array *array = (struct bpf_array *)&m_array;
>>
>>                      /* .. array->map.max_entries .. */
>>              }
>>
>> In kernel, bpf_htab has similar structure,
>>
>>              struct bpf_htab {
>>                      struct bpf_map map;
>>                      ...
>>              }
>>
>> In the above cg_skb(), to access array->map.max_entries, with CORE, the clang will
>> generate two builtin's.
>>              base = &m_array;
>>              /* access array.map */
>>              map_addr = __builtin_preserve_struct_access_info(base, 0, 0);
>>              /* access array.map.max_entries */
>>              max_entries_addr = __builtin_preserve_struct_access_info(map_addr, 0, 0);
>>              max_entries = *max_entries_addr;
>>
>> In the current llvm, if two builtin's are in the same function or
>> in the same function after inlining, the compiler is smart enough to chain
>> them together and generates like below:
>>              base = &m_array;
>>              max_entries = *(base + reloc_offset); /* reloc_offset = 0 in this case */
>> and we are fine.
>>
>> But if we force no inlining for one of functions in test_map_ptr() selftest, e.g.,
>> check_default(), the above two __builtin_preserve_* will be in two different
>> functions. In this case, we will have code like:
>>     func check_hash():
>>              reloc_offset_map = 0;
>>              base = &m_array;
>>              map_base = base + reloc_offset_map;
>>              check_default(map_base, ...)
>>     func check_default(map_base, ...):
>>              max_entries = *(map_base + reloc_offset_max_entries);
>>
>> In kernel, map_ptr (CONST_PTR_TO_MAP) does not allow any arithmetic.
>> The above "map_base = base + reloc_offset_map" will trigger a verifier failure.
>>    ; VERIFY(check_default(&hash->map, map));
>>    0: (18) r7 = 0xffffb4fe8018a004
>>    2: (b4) w1 = 110
>>    3: (63) *(u32 *)(r7 +0) = r1
>>     R1_w=invP110 R7_w=map_value(id=0,off=4,ks=4,vs=8,imm=0) R10=fp0
>>    ; VERIFY_TYPE(BPF_MAP_TYPE_HASH, check_hash);
>>    4: (18) r1 = 0xffffb4fe8018a000
>>    6: (b4) w2 = 1
>>    7: (63) *(u32 *)(r1 +0) = r2
>>     R1_w=map_value(id=0,off=0,ks=4,vs=8,imm=0) R2_w=invP1 R7_w=map_value(id=0,off=4,ks=4,vs=8,imm=0) R10=fp0
>>    8: (b7) r2 = 0
>>    9: (18) r8 = 0xffff90bcb500c000
>>    11: (18) r1 = 0xffff90bcb500c000
>>    13: (0f) r1 += r2
>>    R1 pointer arithmetic on map_ptr prohibited
>>
>> To fix the issue, let us permit map_ptr + 0 arithmetic which will
>> result in exactly the same map_ptr.
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
>>   kernel/bpf/verifier.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>> index b4e9c56b8b32..92aa985e99df 100644
>> --- a/kernel/bpf/verifier.c
>> +++ b/kernel/bpf/verifier.c
>> @@ -5317,6 +5317,9 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
>>                          dst, reg_type_str[ptr_reg->type]);
>>                  return -EACCES;
>>          case CONST_PTR_TO_MAP:
>> +               if (known && smin_val == 0 && opcode == BPF_ADD)
> 
> does smin_val imply that var_off is strictly zero? if that's the case,
> can you please leave a comment stating this clearly, it's hard to tell
> if that's enough of a check.

It should be, if register state is maintained properly, the following 
function (or its functionality) should have been called.

static void __update_reg64_bounds(struct bpf_reg_state *reg)
{
         /* min signed is max(sign bit) | min(other bits) */
         reg->smin_value = max_t(s64, reg->smin_value,
                                 reg->var_off.value | (reg->var_off.mask 
& S64_MIN));
         /* max signed is min(sign bit) | max(other bits) */
         reg->smax_value = min_t(s64, reg->smax_value,
                                 reg->var_off.value | (reg->var_off.mask 
& S64_MAX));
         reg->umin_value = max(reg->umin_value, reg->var_off.value);
         reg->umax_value = min(reg->umax_value,
                               reg->var_off.value | reg->var_off.mask);
}

for scalar constant, reg->var_off.mask should be 0. so we will have
reg->smin_value = reg->smax_value = (s64)reg->var_off.value.

The smin_val is also used below, e.g., BPF_ADD, for a known value.
That is why I am using smin_val here.

Will add a comment and submit v2.

> 
>> +                       break;
>> +               /* fall-through */
>>          case PTR_TO_PACKET_END:
>>          case PTR_TO_SOCKET:
>>          case PTR_TO_SOCKET_OR_NULL:
>> --
>> 2.24.1
>>
