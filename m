Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0466BA5F
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 12:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfGQKgm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 17 Jul 2019 06:36:42 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1552 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726575AbfGQKgl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 06:36:41 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6HAVgHj070520
        for <netdev@vger.kernel.org>; Wed, 17 Jul 2019 06:36:40 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tt1mf9898-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 17 Jul 2019 06:36:40 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <iii@linux.ibm.com>;
        Wed, 17 Jul 2019 11:36:37 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 17 Jul 2019 11:36:35 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6HAaYPA42598592
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Jul 2019 10:36:34 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 93008A4055;
        Wed, 17 Jul 2019 10:36:34 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 66101A4053;
        Wed, 17 Jul 2019 10:36:34 +0000 (GMT)
Received: from dyn-9-152-96-15.boeblingen.de.ibm.com (unknown [9.152.96.15])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 17 Jul 2019 10:36:34 +0000 (GMT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re: [PATCH bpf] bpf: fix narrower loads on s390
From:   Ilya Leoshkevich <iii@linux.ibm.com>
In-Reply-To: <98C6AA13-A44D-4FF1-BA73-1BD446BD773A@linux.ibm.com>
Date:   Wed, 17 Jul 2019 12:36:34 +0200
Cc:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        gor@linux.ibm.com, heiko.carstens@de.ibm.com
Content-Transfer-Encoding: 8BIT
References: <20190716115910.23093-1-iii@linux.ibm.com>
 <CAH3MdRWGVDjW8cA9EbnFjK8ko1EqeyDyC_LoRTsxhLsYn1fZtw@mail.gmail.com>
 <CAH3MdRU-u1Gn6uj2D=mzXvdC2RDWas3Ec0QXObKsLac1GwuREQ@mail.gmail.com>
 <98C6AA13-A44D-4FF1-BA73-1BD446BD773A@linux.ibm.com>
To:     Y Song <ys114321@gmail.com>
X-Mailer: Apple Mail (2.3445.9.1)
X-TM-AS-GCONF: 00
x-cbid: 19071710-0016-0000-0000-00000293A12A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071710-0017-0000-0000-000032F17815
Message-Id: <4311B5C3-8D1B-4958-9CDE-450662A7851D@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-17_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=988 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907170128
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Am 17.07.2019 um 11:21 schrieb Ilya Leoshkevich <iii@linux.ibm.com>:
> 
>> Am 17.07.2019 um 07:11 schrieb Y Song <ys114321@gmail.com>:
>> 
>> [sorry, resend again as previous one has come text messed out due to
>> networking issues]
>> 
>> On Tue, Jul 16, 2019 at 10:08 PM Y Song <ys114321@gmail.com> wrote:
>>> 
>>> On Tue, Jul 16, 2019 at 4:59 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
>>>> 
>>>> test_pkt_md_access is failing on s390, since the associated eBPF prog
>>>> returns TC_ACT_SHOT, which in turn happens because loading a part of a
>>>> struct __sk_buff field produces an incorrect result.
>>>> 
>>>> The problem is that when verifier emits the code to replace partial load
>>>> of a field with a full load, a shift and a bitwise AND, it assumes that
>>>> the machine is little endian.
>>>> 
>>>> Adjust shift count calculation to account for endianness.
>>>> 
>>>> Fixes: 31fd85816dbe ("bpf: permits narrower load from bpf program context fields")
>>>> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
>>>> ---
>>>> kernel/bpf/verifier.c | 8 ++++++--
>>>> 1 file changed, 6 insertions(+), 2 deletions(-)
>>>> 
>>>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>>>> index 5900cbb966b1..3f9353653558 100644
>>>> --- a/kernel/bpf/verifier.c
>>>> +++ b/kernel/bpf/verifier.c
>>>> @@ -8616,8 +8616,12 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
>>>>               }
>>>> 
>>>>               if (is_narrower_load && size < target_size) {
>>>> -                       u8 shift = (off & (size_default - 1)) * 8;
>>>> -
>>>> +                       u8 load_off = off & (size_default - 1);
>>>> +#ifdef __LITTLE_ENDIAN
>>>> +                       u8 shift = load_off * 8;
>>>> +#else
>>>> +                       u8 shift = (size_default - (load_off + size)) * 8;
>>>> +#endif
>>> 
>> All the values are in register. The shifting operations should be the
>> same for big endian and little endian, e.g., value 64 >> 2 = 16 when
>> value "64" is in register. So I did not see a problem here.
>> 
>> Could you elaborate which field access in test_pkt_md_access
>> caused problem?
> 
> The very first one: TEST_FIELD(__u8,  len, 0xFF);
> 
>> It would be good if you can give detailed memory layout and register values
>> to illustrate the problem.
> 
> Suppose len = 0x11223344. On a big endian system, this would be
> 
> 11 22 33 44
> 
> Now, we would like to do *(u8 *)&len, the desired result is 0x11.
> Verifier should emit the following: ((*(u32 *)&len) >> 24) & 0xff, but as
> of today it misses the shift.
> 
> On a little endian system the layout is:
> 
> 44 33 22 11
> 
> and the desired result is different - 0x44. Verifier correctly emits
> (*(u32 *)&len) & 0xff.

I’ve just realized, that this example does not reflect what the test is
doing on big-endian systems (there is an #ifdef for those).

Here is a better one: len=0x11223344 and we would like to do
((u8 *)&len)[3].

len is represented as `11 22 33 44` in memory, so the desired result is
0x44. It can be obtained by doing (*(u32 *)&len) & 0xff, but today the
verifier does ((*(u32 *)&len) >> 24) & 0xff instead.
