Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4AC2216B5
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 23:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgGOVAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 17:00:18 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:27262 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726356AbgGOVAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 17:00:17 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06FKuDOV013114;
        Wed, 15 Jul 2020 14:00:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=pYIEAP4akUQ1FGRTE3BP4kJ8f9D1Ip9upEQPbEBhWSM=;
 b=lES6MLxjXbRCKURsgKJA1RJL6OOSsiADG9DCXIwSEaHsFYRbz4dwoEgvcOf/vaG0iHz3
 zh9wi5NpP5lua7pD9cMEik46CNqzCf9+eU1L3qoiHZqOJZnuZJd0TL8AevSOQAz+grR3
 rHjF+nl9ivsd8Vw1M89VYm9TYCmK5yCTlCw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 327b5pcm0u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 15 Jul 2020 14:00:00 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 15 Jul 2020 13:59:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mVdaGP4HX+7v4vfBVXUa/Pq/bR6yLH/QSbm811Zt9jZ+NU7WDqCVjOSYUdEo6jIryjLT0NOIPLlW7AhNssJvcfh7nii8AkHUuZYxj1rNOyTv2KnGHgSfYe3eAMkmwFqIPYLcFNnMK6cSR62NcHMXhrHndB4J9JsqQJiQR1RpxeEceZJpNjUl+PyqdFrcpm9hhnslUzufORsnn5hbtamkpOOmOD951XNTWJ+Jg7Bzmbj1IddDfv9f6JGZiRDhi1blaFPfQdBPzpikIt02AN26hFNH7sha/t81wJDJUoByHc6B7YET2/a2mvfY/EoKxoQesj5dx8KYMVC6wnKqqOHFjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pYIEAP4akUQ1FGRTE3BP4kJ8f9D1Ip9upEQPbEBhWSM=;
 b=Mn9D9tK1x4yAB3XHM82be6G8kXZH5UOxogYRkoTRob2jUS2saho8BmF1Su4kyNvLXrtT/AsSaVi0joa6QhRLzK39c3SsdIMZbUyF2O/AswyFvyS+41NNHlfY9voJTLtXgngjW9eirMnb7aA8PfMFb98ffxtb3dHveAT7FMkWm5RcUKGlYKQ3pKZki1wPtPAixvZGr75FItYY2yhflQH66/bEolPi1mA7MpRXXyO7lzLl/iU9LdyzwBRYZGidpuVwXqxMVxLaJxlZHx1fs31MzhwN+ACrnauEOB36VmHIpwHvmmtsBTleq774F06pcK7HLQzWGVnS8VOFWx4xJl1CEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pYIEAP4akUQ1FGRTE3BP4kJ8f9D1Ip9upEQPbEBhWSM=;
 b=JkBg5fM6v0RojAcnDmwautK5S962TtmrZlL9v1lfdH+H5aQp/RqpmVCFqqKLDqmKYIptAbvH19iCGA8yj/qOWV29CnBoPpKyNs2oPy3P4Srfnitk4yDUkJ5qzFLrhHLdY9W4FWki86pr9J58T6LR+rfIlb9sHxeIjn5thdqrCo4=
Authentication-Results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB4085.namprd15.prod.outlook.com (2603:10b6:a02:bf::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.24; Wed, 15 Jul
 2020 20:59:57 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3174.026; Wed, 15 Jul 2020
 20:59:57 +0000
Subject: Re: [PATCH bpf] bpf: Shift and mask loads narrower than context field
 size
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-team@cloudflare.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
References: <20200710173123.427983-1-jakub@cloudflare.com>
 <c98aaa5e-9347-c23f-cfa6-e267f2485c5b@fb.com> <87a700y3yb.fsf@cloudflare.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <7c27726c-9bba-8d7c-55b4-69d7af287382@fb.com>
Date:   Wed, 15 Jul 2020 13:59:56 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
In-Reply-To: <87a700y3yb.fsf@cloudflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR20CA0013.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::26) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::1176] (2620:10d:c090:400::5:7353) by BY5PR20CA0013.namprd20.prod.outlook.com (2603:10b6:a03:1f4::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.18 via Frontend Transport; Wed, 15 Jul 2020 20:59:57 +0000
X-Originating-IP: [2620:10d:c090:400::5:7353]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9757857-752d-4ead-471b-08d82902080e
X-MS-TrafficTypeDiagnostic: BYAPR15MB4085:
X-Microsoft-Antispam-PRVS: <BYAPR15MB40857DF4F82EFA6A9FDEA293D37E0@BYAPR15MB4085.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: utVD5gOq5mzl1ivkyVz8qFk3h55ZxzpBdqNAXHvPgOhtmkWLqQrJnp3dg4pMQYC7G3vALw2STEytPFvpl49mKNFJ+AYR3NnzHU9vcIqx6EsL8JpjwJog2jIfsf9S7oL0cV8uHDjCi4P/HxhDaf2/4s4/SG8PMVN/HrWKsKOPSG7cCFi7p1aCSM4FFQnVnXOcoH10qEnzvjix8D4J8Uoqr3Qu4lv2bWu1kP62EAV+Kog1DR850kRRFHnO4Q/kgdnsubAO3VJY/jDIo7ifKZI+j2KfTSMzc4snhgIYGjlNhsBO0QLmB050fp5IIdv5YGAMTreI3rzMtADXPt/MHDcbbYnl/5Th6hO4TT7gOAsFoEy3JBWI83HmRKjfFa2GlfzU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(366004)(346002)(396003)(136003)(376002)(66946007)(52116002)(6486002)(2616005)(2906002)(478600001)(83380400001)(4326008)(66556008)(186003)(16526019)(31686004)(36756003)(66476007)(316002)(8936002)(54906003)(31696002)(5660300002)(6916009)(8676002)(53546011)(86362001)(30864003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: v5JC1E0LCaZ5m1btffuqnf729czE+YBXl4QQo850h+mKqtbZwG3i8nRRssYPGkouHdRDZ2JOFMKRTbrez9aN9GDclmh89032O9Ts3PDDi1vaOWtyJ1YX7VTPWCG6jJztu7UnKqIR2wLwe843wyEOWSt7Y+qPfizrERzs+/ee529pl1ZQkk9CZEWXb/2WIDc3tIPY9ZRQhnE5OByaTHU3qP3Ricvnbf56SEPs358hs5h2RzxQSh8D692eBAqSGDomzfncADNZisZEo9mnkGjf8UHnSJnMzjkOZy+dpVFGHX0/lE8EBVWYRGRqQbw2RK6pUDcXvgudkFD7GokJLdIwWiHewXn0xDmS/+V7xI9YDvAANvQT2EkPbGGxyhkBYrwtZY6s28WWG2C7TP9aTd0PDQ7slgaa+JucknivG21A/JkcnRE2gqHLE8z3lntDczhiesxcip4goxnnDH2wpJIk6NY/H5HNAiB2XMLQP9pYyV1VaIy7Kq/kM8EtnLT0+pdd9oahuyXkhNLag+kQ5vvwbQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: f9757857-752d-4ead-471b-08d82902080e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2020 20:59:57.6970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sTkCxnR+gE99o7/wl5BYNBXe8m1nM+4NGT5wZ3y5uDqKlt74v2oCcJGfP5eotzxS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4085
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-15_12:2020-07-15,2020-07-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 bulkscore=0 mlxlogscore=999 priorityscore=1501 suspectscore=0 adultscore=0
 spamscore=0 phishscore=0 mlxscore=0 lowpriorityscore=0 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007150159
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/15/20 12:26 PM, Jakub Sitnicki wrote:
> On Wed, Jul 15, 2020 at 08:44 AM CEST, Yonghong Song wrote:
>> On 7/10/20 10:31 AM, Jakub Sitnicki wrote:
>>> When size of load from context is the same as target field size, but less
>>> than context field size, the verifier does not emit the shift and mask
>>> instructions for loads at non-zero offset.
>>>
>>> This has the unexpected effect of loading the same data no matter what the
>>> offset was. While the expected behavior would be to load zeros for offsets
>>> that are greater than target field size.
>>>
>>> For instance, u16 load from u32 context field backed by u16 target field at
>>> an offset of 2 bytes results in:
>>>
>>>     SEC("sk_reuseport/narrow_half")
>>>     int reuseport_narrow_half(struct sk_reuseport_md *ctx)
>>>     {
>>>     	__u16 *half;
>>>
>>>     	half = (__u16 *)&ctx->ip_protocol;
>>>     	if (half[0] == 0xaaaa)
>>>     		return SK_DROP;
>>>     	if (half[1] == 0xbbbb)
>>>     		return SK_DROP;
>>>     	return SK_PASS;
>>>     }
>>
>> It would be good if you can include llvm asm output like below so people
>> can correlate source => asm => xlated codes:
>>
>>         0:       w0 = 0
>>         1:       r2 = *(u16 *)(r1 + 24)
>>         2:       if w2 == 43690 goto +4 <LBB0_3>
>>         3:       r1 = *(u16 *)(r1 + 26)
>>         4:       w0 = 1
>>         5:       if w1 != 48059 goto +1 <LBB0_3>
>>         6:       w0 = 0
>>
>> 0000000000000038 <LBB0_3>:
>>         7:       exit
> 
> Sure, not a problem, if it makes reasoning about the problem easier.
> I'm assuming that it is the narrow load at an offset that you wanted to
> confirm with asm output.
> 
>>
>>>
>>>     int reuseport_narrow_half(struct sk_reuseport_md * ctx):
>>>     ; int reuseport_narrow_half(struct sk_reuseport_md *ctx)
>>>        0: (b4) w0 = 0
>>>     ; if (half[0] == 0xaaaa)
>>>        1: (79) r2 = *(u64 *)(r1 +8)
>>>        2: (69) r2 = *(u16 *)(r2 +924)
>>>     ; if (half[0] == 0xaaaa)
>>>        3: (16) if w2 == 0xaaaa goto pc+5
>>>     ; if (half[1] == 0xbbbb)
>>>        4: (79) r1 = *(u64 *)(r1 +8)
>>>        5: (69) r1 = *(u16 *)(r1 +924)
>>>        6: (b4) w0 = 1
>>>     ; if (half[1] == 0xbbbb)
>>>        7: (56) if w1 != 0xbbbb goto pc+1
>>>        8: (b4) w0 = 0
>>>     ; }
>>>        9: (95) exit
>>
>> Indeed we have an issue here. The insn 5 is not correct.
>> The original assembly is correct.
>>
>> Internally ip_protocol is backed by 2 bytes in sk_reuseport_kern.
>> The current verifier implementation makes an important assumption:
>>     all user load requests are within the size of kernel internal range
>> In this case, the verifier actually only correctly supports
>>     . one byte from offset 0
>>     . one byte from offset 1
>>     . two bytes from offset 0
> 
> I don't think that's true. For a field that has target size of 2 bytes,
> like ip_protocol, 1-byte load at any offset is correctly supported
> because right shifting and masking takes place. That is because we hit
> the "size < target_size" condition in this case. Only loads of size >=
> target size at an offset != give surprising results.

okay, yes, you are right. We relied on the fact even the inst is to load 
2 bytes but effectively we load 8 bytes always for 64bit load and 4 
bytes always for 32bit load. For any other one byte access, shifting and 
masking will kick in to make it work although the value is 0.

> 
>>
>> The original assembly code tries to access 2 bytes from offset 2
>> and the verifier did incorrect transformation.
>>
>> This actually makes sense since any other read is
>> misleading. For example, for ip_protocol, if people wants to
>> load 2 bytes from offset 2, what should we return? 0? In this case,
>> actually verifier can convert it to 0 with doing a load.
> 
> Yes, IMHO, if you are loading 2 bytes at offset of 2 from a 4 byte
> context field that holds an unsigned value, then it should return 0 for
> for a field that is backed by a 2 byte kernel field.
> 
> I agree that it could be optimized to load an immediate value instead of
> performing a load from memory. It didn't occur to me, so thanks for the
> suggestion.
> 
>>> In this case half[0] == half[1] == sk->sk_protocol that backs the
>>> ctx->ip_protocol field.
>>>
>>> Fix it by shifting and masking any load from context that is narrower than
>>> context field size (is_narrower_load = size < ctx_field_size), in addition
>>> to loads that are narrower than target field size.
>>
>> The fix can workaround the issue, but I think we should generate better codes
>> for such cases.
> 
> Not sure I'd go as far as calling it a workaround. After all I
> understand that in BPF loading a half word into a register is well
> defined, and you can rely on upper word being zero. But please correct
> me if not.

This is true. I should have said that "the fix can fix the issue".

> 
> You're right, though, that approach can be smarter here, that is we can
> emit just a single instruction that doesn't access memory.
> 
>>> The "size < target_size" check is left in place to cover the case when a
>>> context field is narrower than its target field, even if we might not have
>>> such case now. (It would have to be a u32 context field backed by a u64
>>> target field, with context fields all being 4-bytes or wider.)
>>>
>>> Going back to the example, with the fix in place, the upper half load from
>>> ctx->ip_protocol yields zero:
>>>
>>>     int reuseport_narrow_half(struct sk_reuseport_md * ctx):
>>>     ; int reuseport_narrow_half(struct sk_reuseport_md *ctx)
>>>        0: (b4) w0 = 0
>>>     ; if (half[0] == 0xaaaa)
>>>        1: (79) r2 = *(u64 *)(r1 +8)
>>>        2: (69) r2 = *(u16 *)(r2 +924)
>>>        3: (54) w2 &= 65535
>>>     ; if (half[0] == 0xaaaa)
>>>        4: (16) if w2 == 0xaaaa goto pc+7
>>>     ; if (half[1] == 0xbbbb)
>>>        5: (79) r1 = *(u64 *)(r1 +8)
>>>        6: (69) r1 = *(u16 *)(r1 +924)
>>
>> The load is still from offset 0, 2 bytes with upper 48 bits as 0.
> 
> Yes, this is how narrow loads currently work, right? It is not specific
> to the case I'm fixing.
> 
> To give an example - if you do a 1-byte load at offset 1, it will load
> the value from offset 0, and shift it right by 1 byte. So it is expected
> that the load is always from offset 0 with current implementation.

Yes, the load is always from offset 0. The confusion part is
it load offset 0 with 2 bytes and then right shifting 2 bytes
to get 0...

> 
> SEC("sk_reuseport/narrow_byte")
> int reuseport_narrow_byte(struct sk_reuseport_md *ctx)
> {
> 	__u8 *byte;
> 
> 	byte = (__u8 *)&ctx->ip_protocol;
> 	if (byte[0] == 0xaa)
> 		return SK_DROP;
> 	if (byte[1] == 0xbb)
> 		return SK_DROP;
> 	if (byte[2] == 0xcc)
> 		return SK_DROP;
> 	if (byte[3] == 0xdd)
> 		return SK_DROP;
> 	return SK_PASS;
> }
> 
> int reuseport_narrow_byte(struct sk_reuseport_md * ctx):
> ; int reuseport_narrow_byte(struct sk_reuseport_md *ctx)
>     0: (b4) w0 = 0
> ; if (byte[0] == 0xaa)
>     1: (79) r2 = *(u64 *)(r1 +8)
>     2: (69) r2 = *(u16 *)(r2 +924)
>     3: (54) w2 &= 255
> ; if (byte[0] == 0xaa)
>     4: (16) if w2 == 0xaa goto pc+17
> ; if (byte[1] == 0xbb)
>     5: (79) r2 = *(u64 *)(r1 +8)
>     6: (69) r2 = *(u16 *)(r2 +924)
>     7: (74) w2 >>= 8
>     8: (54) w2 &= 255
> ; if (byte[1] == 0xbb)
>     9: (16) if w2 == 0xbb goto pc+12
> ; if (byte[2] == 0xcc)
>    10: (79) r2 = *(u64 *)(r1 +8)
>    11: (69) r2 = *(u16 *)(r2 +924)
>    12: (74) w2 >>= 16
>    13: (54) w2 &= 255
> ; if (byte[2] == 0xcc)
>    14: (16) if w2 == 0xcc goto pc+7
> ; if (byte[3] == 0xdd)
>    15: (79) r1 = *(u64 *)(r1 +8)
>    16: (69) r1 = *(u16 *)(r1 +924)
>    17: (74) w1 >>= 24
>    18: (54) w1 &= 255
>    19: (b4) w0 = 1
> ; if (byte[3] == 0xdd)
>    20: (56) if w1 != 0xdd goto pc+1
>    21: (b4) w0 = 0
> ; }
>    22: (95) exit
> 
>>
>>>        7: (74) w1 >>= 16
>>
>> w1 will be 0 now. so this will work.
>>
>>>        8: (54) w1 &= 65535
>>
>> For the above insns 5-8, verifier, based on target information can
>> directly generate w1 = 0 since:
>>    . target kernel field size is 2, ctx field size is 4.
>>    . user tries to access offset 2 size 2.
>>
>> Here, we need to decide whether we permits user to do partial read beyond of
>> kernel narrow field or not (e.g., this example)? I would
>> say yes, but Daniel or Alexei can provide additional comments.
>>
>> If we allow such accesses, I would like verifier to generate better
>> code as I illustrated in the above. This can be implemented in
>> verifier itself with target passing additional kernel field size
>> to the verifier. The target already passed the ctx field size back
>> to the verifier.
> 
> Keep in mind that the BPF user is writing their code under the
> assumption that the context field has 4 bytes. IMHO it's reasonable to
> expect that I can load 2 bytes at offset of 2 from a 4 byte field.
> 
> Restricting it now to loads below the target field size, which is
> unknown to the user, would mean rejecting programs that are working
> today. Even if they are getting funny values.
> 
> I think implementing what you suggest is doable without major
> changes. We have load size, target field size, and context field size at
> hand in convert_ctx_accesses(), so it seems like a matter of adding an
> 'if' branch to handle better the case when we know the end result must
> be 0. I'll give it a try.

Sounds good. The target_size is returned in convert_ctx_access(), which
is too late as the verifier already generated load instructions. You 
need to get it earlier in is_valid_access().

> 
> But I do want to empahsize that I still think the fix in current form is
> correct, or at least not worse than what we have already in place narrow
> loads.

I did agree that the fix in this patch is correct. It is just that we
could do better to fix this problem.

> 
>>
>>>        9: (b4) w0 = 1
>>>     ; if (half[1] == 0xbbbb)
>>>       10: (56) if w1 != 0xbbbb goto pc+1
>>>       11: (b4) w0 = 0
>>>     ; }
>>>       12: (95) exit
>>>
>>> Fixes: f96da09473b5 ("bpf: simplify narrower ctx access")
>>> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>>> ---
>>>    kernel/bpf/verifier.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>>> index 94cead5a43e5..1c4d0e24a5a2 100644
>>> --- a/kernel/bpf/verifier.c
>>> +++ b/kernel/bpf/verifier.c
>>> @@ -9760,7 +9760,7 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
>>>    			return -EINVAL;
>>>    		}
>>>    -		if (is_narrower_load && size < target_size) {
>>> +		if (is_narrower_load || size < target_size) {
>>>    			u8 shift = bpf_ctx_narrow_access_offset(
>>>    				off, size, size_default) * 8;
>>>    			if (ctx_field_size <= 4) {
>>>
