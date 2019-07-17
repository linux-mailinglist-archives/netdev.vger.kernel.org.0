Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8A326B91C
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 11:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfGQJVX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 17 Jul 2019 05:21:23 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25314 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726180AbfGQJVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 05:21:23 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6H9HMJS100452
        for <netdev@vger.kernel.org>; Wed, 17 Jul 2019 05:21:21 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tt0bx9qwq-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 17 Jul 2019 05:21:21 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <iii@linux.ibm.com>;
        Wed, 17 Jul 2019 10:21:20 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 17 Jul 2019 10:21:18 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6H9LH9U49807490
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Jul 2019 09:21:17 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 424DD11C058;
        Wed, 17 Jul 2019 09:21:17 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1472311C04C;
        Wed, 17 Jul 2019 09:21:17 +0000 (GMT)
Received: from dyn-9-152-96-15.boeblingen.de.ibm.com (unknown [9.152.96.15])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 17 Jul 2019 09:21:17 +0000 (GMT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re: [PATCH bpf] bpf: fix narrower loads on s390
From:   Ilya Leoshkevich <iii@linux.ibm.com>
In-Reply-To: <CAH3MdRU-u1Gn6uj2D=mzXvdC2RDWas3Ec0QXObKsLac1GwuREQ@mail.gmail.com>
Date:   Wed, 17 Jul 2019 11:21:16 +0200
Cc:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        gor@linux.ibm.com, heiko.carstens@de.ibm.com
Content-Transfer-Encoding: 8BIT
References: <20190716115910.23093-1-iii@linux.ibm.com>
 <CAH3MdRWGVDjW8cA9EbnFjK8ko1EqeyDyC_LoRTsxhLsYn1fZtw@mail.gmail.com>
 <CAH3MdRU-u1Gn6uj2D=mzXvdC2RDWas3Ec0QXObKsLac1GwuREQ@mail.gmail.com>
To:     Y Song <ys114321@gmail.com>
X-Mailer: Apple Mail (2.3445.9.1)
X-TM-AS-GCONF: 00
x-cbid: 19071709-4275-0000-0000-0000034E0997
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071709-4276-0000-0000-0000385E1EDC
Message-Id: <98C6AA13-A44D-4FF1-BA73-1BD446BD773A@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-17_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=856 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907170112
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Am 17.07.2019 um 07:11 schrieb Y Song <ys114321@gmail.com>:
> 
> [sorry, resend again as previous one has come text messed out due to
> networking issues]
> 
> On Tue, Jul 16, 2019 at 10:08 PM Y Song <ys114321@gmail.com> wrote:
>> 
>> On Tue, Jul 16, 2019 at 4:59 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
>>> 
>>> test_pkt_md_access is failing on s390, since the associated eBPF prog
>>> returns TC_ACT_SHOT, which in turn happens because loading a part of a
>>> struct __sk_buff field produces an incorrect result.
>>> 
>>> The problem is that when verifier emits the code to replace partial load
>>> of a field with a full load, a shift and a bitwise AND, it assumes that
>>> the machine is little endian.
>>> 
>>> Adjust shift count calculation to account for endianness.
>>> 
>>> Fixes: 31fd85816dbe ("bpf: permits narrower load from bpf program context fields")
>>> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
>>> ---
>>> kernel/bpf/verifier.c | 8 ++++++--
>>> 1 file changed, 6 insertions(+), 2 deletions(-)
>>> 
>>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>>> index 5900cbb966b1..3f9353653558 100644
>>> --- a/kernel/bpf/verifier.c
>>> +++ b/kernel/bpf/verifier.c
>>> @@ -8616,8 +8616,12 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
>>>                }
>>> 
>>>                if (is_narrower_load && size < target_size) {
>>> -                       u8 shift = (off & (size_default - 1)) * 8;
>>> -
>>> +                       u8 load_off = off & (size_default - 1);
>>> +#ifdef __LITTLE_ENDIAN
>>> +                       u8 shift = load_off * 8;
>>> +#else
>>> +                       u8 shift = (size_default - (load_off + size)) * 8;
>>> +#endif
>> 
> All the values are in register. The shifting operations should be the
> same for big endian and little endian, e.g., value 64 >> 2 = 16 when
> value "64" is in register. So I did not see a problem here.
> 
> Could you elaborate which field access in test_pkt_md_access
> caused problem?

The very first one: TEST_FIELD(__u8,  len, 0xFF);

> It would be good if you can give detailed memory layout and register values
> to illustrate the problem.

Suppose len = 0x11223344. On a big endian system, this would be

11 22 33 44

Now, we would like to do *(u8 *)&len, the desired result is 0x11.
Verifier should emit the following: ((*(u32 *)&len) >> 24) & 0xff, but as
of today it misses the shift.

On a little endian system the layout is:

44 33 22 11

and the desired result is different - 0x44. Verifier correctly emits
(*(u32 *)&len) & 0xff.

> 
>> 
>>>                        if (ctx_field_size <= 4) {
>>>                                if (shift)
>>>                                        insn_buf[cnt++] = BPF_ALU32_IMM(BPF_RSH,
>>> --
>>> 2.21.0

