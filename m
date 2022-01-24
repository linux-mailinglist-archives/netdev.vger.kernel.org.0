Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78329497F8E
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 13:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241363AbiAXM35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 07:29:57 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26788 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239755AbiAXM35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 07:29:57 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20OAIAek016573;
        Mon, 24 Jan 2022 12:29:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=AVmhQmE//C1P8vXQ4nPVnGgu7zsBsxxS7En3lN9MMK4=;
 b=Pl1Y8KzoBa1Tu3quByUK5+773CQutQc1NBijTlQc/yChxfWHNDNFBz1zJYyuk5foi1pJ
 CjwwlAflDG2HrFuHv8rM2qflE7MAglVBBNRNLJjygElhDig2AUMPMfe9oxQoYBC1Y2SG
 4GJw5ZLjKqhcDwrzaNQLAepKF8H2Spx5dUtFE+KmwQgWeALxCX20hZI1jBUMXM8Ts7Ap
 mWRfJnBN6vtioLCM5MoLoMQog8grNv6hWvLcXl1Vge4+cMkieQz1GweNHB2mYnkR/Irh
 cmf0nbEDEa4sCa3LIXpgtjI7vP+au01o9t1kwUuAVfF4AuY8T1O4tt3JR8mLyDRkTv7D LQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dssbtkpt4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jan 2022 12:29:30 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20OCHdu3000300;
        Mon, 24 Jan 2022 12:29:29 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dssbtkpsj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jan 2022 12:29:29 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20OCDQoZ011818;
        Mon, 24 Jan 2022 12:29:27 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3dr9j8v3kj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jan 2022 12:29:27 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20OCTO5i47186356
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jan 2022 12:29:25 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBAEBAE051;
        Mon, 24 Jan 2022 12:29:24 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 42F4BAE04D;
        Mon, 24 Jan 2022 12:29:24 +0000 (GMT)
Received: from [9.171.78.41] (unknown [9.171.78.41])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 24 Jan 2022 12:29:24 +0000 (GMT)
Message-ID: <adec88f9-b3e6-bfe4-c09e-54825a60f45d@linux.ibm.com>
Date:   Mon, 24 Jan 2022 13:29:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v6 bpf-next 6/7] bpf: introduce bpf_prog_pack allocator
Content-Language: en-US
To:     Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, X86 ML <x86@kernel.org>
References: <20220121194926.1970172-1-song@kernel.org>
 <20220121194926.1970172-7-song@kernel.org>
 <CAADnVQK6+gWTUDo2z1H6AE5_DtuBBetW+VTwwKz03tpVdfuoHA@mail.gmail.com>
 <7393B983-3295-4B14-9528-B7BD04A82709@fb.com>
 <CAADnVQJLHXaU7tUJN=EM-Nt28xtu4vw9+Ox_uQsjh-E-4VNKoA@mail.gmail.com>
 <5407DA0E-C0F8-4DA9-B407-3DE657301BB2@fb.com>
 <CAADnVQLOpgGG9qfR4EAgzrdMrfSg9ftCY=9psR46GeBWP7aDvQ@mail.gmail.com>
 <5F4DEFB2-5F5A-4703-B5E5-BBCE05CD3651@fb.com>
 <CAADnVQLXGu_eF8VT6NmxKVxOHmfx7C=mWmmWF8KmsjFXg6P5OA@mail.gmail.com>
 <5E70BF53-E3FB-4F7A-B55D-199C54A8FDCA@fb.com>
From:   Ilya Leoshkevich <iii@linux.ibm.com>
In-Reply-To: <5E70BF53-E3FB-4F7A-B55D-199C54A8FDCA@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7h0xHIHMS_MVknwGGiqSVpOLX_yfVWIR
X-Proofpoint-ORIG-GUID: isY7_ClicwkbuAkYt4O0ZxX_yhTiQpSY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-24_06,2022-01-24_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 impostorscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 suspectscore=0 bulkscore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201240081
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/23/22 02:03, Song Liu wrote:
> 
> 
>> On Jan 21, 2022, at 6:12 PM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
>>
>> On Fri, Jan 21, 2022 at 5:30 PM Song Liu <songliubraving@fb.com> wrote:
>>>
>>>
>>>
>>>> On Jan 21, 2022, at 5:12 PM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
>>>>
>>>> On Fri, Jan 21, 2022 at 5:01 PM Song Liu <songliubraving@fb.com> wrote:
>>>>>
>>>>> In this way, we need to allocate rw_image here, and free it in
>>>>> bpf_jit_comp.c. This feels a little weird to me, but I guess that
>>>>> is still the cleanest solution for now.
>>>>
>>>> You mean inside bpf_jit_binary_alloc?
>>>> That won't be arch independent.
>>>> It needs to be split into generic piece that stays in core.c
>>>> and callbacks like bpf_jit_fill_hole_t
>>>> or into multiple helpers with prep in-between.
>>>> Don't worry if all archs need to be touched.
>>>
>>> How about we introduce callback bpf_jit_set_header_size_t? Then we
>>> can split x86's jit_fill_hole() into two functions, one to fill the
>>> hole, the other to set size. The rest of the logic gonna stay the same.
>>>
>>> Archs that do not use bpf_prog_pack won't need bpf_jit_set_header_size_t.
>>
>> That's not any better.
>>
>> Currently the choice of bpf_jit_binary_alloc_pack vs bpf_jit_binary_alloc
>> leaks into arch bits and bpf_prog_pack_max_size() doesn't
>> really make it generic.
>>
>> Ideally all archs continue to use bpf_jit_binary_alloc()
>> and magic happens in a generic code.
>> If not then please remove bpf_prog_pack_max_size(),
>> since it doesn't provide much value and pick
>> bpf_jit_binary_alloc_pack() signature to fit x86 jit better.
>> It wouldn't need bpf_jit_fill_hole_t callback at all.
>> Please think it through so we don't need to redesign it
>> when another arch will decide to use huge pages for bpf progs.
>>
>> cc-ing Ilya for ideas on how that would fit s390.
> 
> I guess we have a few different questions here:
> 
> 1. Can we use bpf_jit_binary_alloc() for both regular page and shared
> huge page?
> 
> I think the answer is no, as bpf_jit_binary_alloc() allocates a rw
> buffer, and arch calls bpf_jit_binary_lock_ro after JITing. The new
> allocator will return a slice of a shared huge page, which is locked
> RO before JITing.
> 
> 2. The problem with bpf_prog_pack_max_size() limitation.
> 
> I think this is the worst part of current version of bpf_prog_pack,
> but it shouldn't be too hard to fix. I will remove this limitation
> in the next version.
> 
> 3. How to set proper header->size?
> 
> I guess we can introduce something similar to bpf_arch_text_poke()
> for this?
> 
> 
> My proposal for the next version is:
> 1. No changes to archs that do not use huge page, just keep using
>     bpf_jit_binary_alloc.
> 
> 2. For x86_64 (and other arch that would support bpf program on huge
>     pages):
>     2.1 arch/bpf_jit_comp calls bpf_jit_binary_alloc_pack() to allocate
>         an RO bpf_binary_header;
>     2.2 arch allocates a temporary buffer for JIT. Once JIT is done,
>         use text_poke_copy to copy the code to the RO bpf_binary_header.

Are arches expected to allocate rw buffers in different ways? If not,
I would consider putting this into the common code as well. Then
arch-specific code would do something like

   header = bpf_jit_binary_alloc_pack(size, &prg_buf, &prg_addr, ...);
   ...
   /*
    * Generate code into prg_buf, the code should assume that its first
    * byte is located at prg_addr.
    */
   ...
   bpf_jit_binary_finalize_pack(header, prg_buf);

where bpf_jit_binary_finalize_pack() would copy prg_buf to header and
free it.

If this won't work, I also don't see any big problems in the scheme
that you propose (especially if bpf_prog_pack_max_size() limitation is
gone).

[...]

Btw, are there any existing benchmarks that I can use to check whether
this is worth enabling on s390?

Best regards,
Ilya
